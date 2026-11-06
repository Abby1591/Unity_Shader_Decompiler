using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace UnityShaderDecompiler.Core.Hlsl;

internal static partial class HlslMathSimplify
{
    public static string Simplify(string body)
    {
        body = CollapseScalarLanes(body);
        body = CollapseMatrixMul(body);
        body = SimplifyMathIdioms(body);
        return body;
    }

    // ==================== Tokenizer ====================

    private enum TokenType
    {
        Ident,
        Number,
        Op,
        Dot,
        LBracket,
        RBracket,
        LParen,
        RParen,
        Comma,
        Semicolon
    }

    private readonly record struct Token(TokenType Type, string Text, int Start);

    private static Token[] Tokenize(string text)
    {
        var tokens = new List<Token>();
        int i = 0;
        while (i < text.Length)
        {
            char c = text[i];
            if (char.IsWhiteSpace(c))
            {
                i++;
                continue;
            }
            if (char.IsLetter(c) || c == '_')
            {
                int start = i;
                while (i < text.Length && (char.IsLetterOrDigit(text[i]) || text[i] == '_'))
                    i++;
                tokens.Add(new Token(TokenType.Ident, text[start..i], start));
            }
            else if (char.IsDigit(c) || (c == '.' && i + 1 < text.Length && char.IsDigit(text[i + 1])))
            {
                int start = i;
                bool hasDot = c == '.';
                i++;
                while (i < text.Length && char.IsDigit(text[i]))
                    i++;
                if (!hasDot && i < text.Length && text[i] == '.')
                {
                    hasDot = true;
                    i++;
                    while (i < text.Length && char.IsDigit(text[i]))
                        i++;
                }
                if (hasDot && i < text.Length && (text[i] == 'e' || text[i] == 'E'))
                {
                    i++;
                    if (i < text.Length && (text[i] == '+' || text[i] == '-'))
                        i++;
                    while (i < text.Length && char.IsDigit(text[i]))
                        i++;
                }
                tokens.Add(new Token(TokenType.Number, text[start..i], start));
            }
            else
            {
                int start = i;
                switch (c)
                {
                    case '*' or '+' or '-' or '=':
                        tokens.Add(new Token(TokenType.Op, c.ToString(), start));
                        i++;
                        break;
                    case '.':
                        tokens.Add(new Token(TokenType.Dot, ".", start));
                        i++;
                        break;
                    case '[':
                        tokens.Add(new Token(TokenType.LBracket, "[", start));
                        i++;
                        break;
                    case ']':
                        tokens.Add(new Token(TokenType.RBracket, "]", start));
                        i++;
                        break;
                    case '(':
                        tokens.Add(new Token(TokenType.LParen, "(", start));
                        i++;
                        break;
                    case ')':
                        tokens.Add(new Token(TokenType.RParen, ")", start));
                        i++;
                        break;
                    case ',':
                        tokens.Add(new Token(TokenType.Comma, ",", start));
                        i++;
                        break;
                    case ';':
                        tokens.Add(new Token(TokenType.Semicolon, ";", start));
                        i++;
                        break;
                    default:
                        i++;
                        break;
                }
            }
        }
        return tokens.ToArray();
    }

    // ==================== ParsedLine ====================

    private readonly record struct ParsedLine(
        int LineIndex,
        string RawText,
        string Indent,
        string? TypeName,
        string VarName,
        Token[] Tokens
    );

    private static ParsedLine ParseLine(int lineIndex, string text)
    {
        string indent = "";
        int i = 0;
        while (i < text.Length && char.IsWhiteSpace(text[i]))
            i++;
        if (i > 0)
            indent = text[..i];

        string? typeName = null;
        string varName = "";
        Token[] tokens = Tokenize(text);

        if (tokens.Length >= 2 && tokens[0].Type == TokenType.Ident)
        {
            string first = tokens[0].Text;
            if (first is "float" or "float2" or "float3" or "float4" or "float4x4" or "float3x3" or "float2x2"
                or "half" or "half2" or "half3" or "half4"
                or "int" or "int2" or "int3" or "int4"
                or "bool" or "bool2" or "bool3" or "bool4")
            {
                typeName = first;
                // varName is the next identifier before '='
                for (int j = 1; j < tokens.Length; j++)
                {
                    if (tokens[j].Type == TokenType.Ident)
                    {
                        varName = tokens[j].Text;
                        break;
                    }
                }
            }
            else
            {
                // Assignment: first token is the variable name
                varName = first;
            }
        }

        return new ParsedLine(lineIndex, text, indent, typeName, varName, tokens);
    }

    // ==================== BodyGraph ====================

    private class BodyGraph
    {
        public ParsedLine[] Lines;
        public Dictionary<string, int> Defs = new(); // var name -> line index
        public Dictionary<int, List<string>> Uses = new(); // line index -> vars used

        public BodyGraph(string[] rawLines)
        {
            Lines = new ParsedLine[rawLines.Length];
            for (int i = 0; i < rawLines.Length; i++)
            {
                Lines[i] = ParseLine(i, rawLines[i]);
                if (!string.IsNullOrEmpty(Lines[i].VarName))
                    Defs[Lines[i].VarName] = i;
            }
            for (int i = 0; i < Lines.Length; i++)
            {
                var uses = new HashSet<string>();
                var t = Lines[i].Tokens;
                for (int j = 0; j < t.Length; j++)
                {
                    if (t[j].Type == TokenType.Ident && Defs.ContainsKey(t[j].Text))
                    {
                        // Check it's not a type name
                        if (Lines[i].TypeName != null && j == 0)
                            continue;
                        // Check it's not a function name (preceded by LParen or start of line, followed by LParen)
                        if (j + 1 < t.Length && t[j + 1].Type == TokenType.LParen)
                            continue;
                        // Check it's not a keyword
                        if (t[j].Text is "float" or "float2" or "float3" or "float4" or "float4x4"
                            or "float3x3" or "float2x2" or "half" or "half2" or "half3" or "half4"
                            or "int" or "int2" or "int3" or "int4"
                            or "bool" or "bool2" or "bool3" or "bool4"
                            or "mad" or "dot" or "rsqrt" or "normalize" or "mul" or "lerp"
                            or "return" or "if" or "else" or "for" or "while"
                            or "true" or "false")
                            continue;
                        uses.Add(t[j].Text);
                    }
                }
                if (uses.Count > 0)
                    Uses[i] = uses.ToList();
            }
        }

        public bool HasUseAnywhere(string varName)
        {
            foreach (var kvp in Uses)
            {
                if (kvp.Value.Contains(varName))
                    return true;
            }
            return false;
        }

        public List<int> GetUseLines(string varName)
        {
            var result = new List<int>();
            foreach (var kvp in Uses)
            {
                if (kvp.Value.Contains(varName))
                    result.Add(kvp.Key);
            }
            return result;
        }
    }

    // ==================== ExtractComponents ====================

    private static List<string> ExtractComponents(string expr)
    {
        var tokens = Tokenize(expr);
        var result = new List<string>();
        int depth = 0;
        int compStart = -1;
        for (int i = 0; i < tokens.Length; i++)
        {
            if (tokens[i].Type == TokenType.LParen)
            {
                depth++;
                if (depth == 1)
                {
                    compStart = -1;
                    continue;
                }
            }
            if (tokens[i].Type == TokenType.RParen)
            {
                depth--;
                if (depth == 0 && compStart >= 0)
                {
                    // gather tokens from compStart to i-1
                    var sb = new StringBuilder();
                    for (int j = compStart; j < i; j++)
                    {
                        if (j > compStart && NeedsSpace(tokens[j - 1], tokens[j]))
                            sb.Append(' ');
                        sb.Append(tokens[j].Text);
                    }
                    string part = sb.ToString().Trim();
                    if (part.Length > 0) result.Add(part);
                    compStart = -1;
                }
                continue;
            }
            if (depth == 1 && tokens[i].Type == TokenType.Comma)
            {
                if (compStart >= 0)
                {
                    var sb = new StringBuilder();
                    for (int j = compStart; j < i; j++)
                    {
                        if (j > compStart && NeedsSpace(tokens[j - 1], tokens[j]))
                            sb.Append(' ');
                        sb.Append(tokens[j].Text);
                    }
                    string part = sb.ToString().Trim();
                    if (part.Length > 0) result.Add(part);
                    compStart = -1;
                }
            }
            if (depth == 1 && compStart == -1 && tokens[i].Type != TokenType.Comma)
            {
                compStart = i;
            }
        }
        return result;
    }

    private static bool NeedsSpace(Token a, Token b)
    {
        if (a.Type == TokenType.RParen || a.Type == TokenType.RBracket || a.Type == TokenType.Ident
            || a.Type == TokenType.Number)
        {
            if (b.Type == TokenType.LParen || b.Type == TokenType.LBracket || b.Type == TokenType.Ident
                || b.Type == TokenType.Number)
                return true;
        }
        return false;
    }

    // ==================== Helpers ====================

    private static void AppendBodyLine(StringBuilder sb, ref bool first, string line)
    {
        if (!first)
            sb.Append('\n');
        sb.Append(line);
        first = false;
    }

    private static bool IsSplat(string swz) =>
        swz.Length == 4 && swz.All(c => c == swz[0]);

    private static string ExtractIndent(string line)
    {
        int i = 0;
        while (i < line.Length && char.IsWhiteSpace(line[i]))
            i++;
        return line[..i];
    }

    // Recombine lines into a body string preserving trailing newline
    private static string RebuildBody(string[] lines, bool[] drop, Dictionary<int, string>? replacements = null, Dictionary<int, string>? inserts = null)
    {
        var sb = new StringBuilder();
        bool first = true;
        for (int k = 0; k < lines.Length; k++)
        {
            if (drop[k])
            {
                if (inserts != null && inserts.TryGetValue(k, out string? decl))
                    AppendBodyLine(sb, ref first, decl);
                continue;
            }
            if (k == lines.Length - 1 && lines[k].Length == 0)
                continue;
            string line = lines[k];
            if (replacements != null && replacements.TryGetValue(k, out string? repl))
                line = repl;
            AppendBodyLine(sb, ref first, line);
        }
        if (lines.Length > 0 && lines[lines.Length - 1].Length == 0)
            sb.Append('\n');
        return sb.ToString();
    }

    private static string RebuildBodyWithRenames(string[] lines, bool[] drop, Dictionary<int, string>? replacements, Dictionary<int, string>? inserts, List<(string Old, string New)> renames)
    {
        var sb = new StringBuilder();
        bool first = true;
        for (int k = 0; k < lines.Length; k++)
        {
            if (drop[k])
            {
                if (inserts != null && inserts.TryGetValue(k, out string? decl))
                    AppendBodyLine(sb, ref first, decl);
                continue;
            }
            if (k == lines.Length - 1 && lines[k].Length == 0)
                continue;
            string line = lines[k];
            if (replacements != null && replacements.TryGetValue(k, out string? repl))
                line = repl;
            foreach (var (old, neu) in renames)
                line = ReplaceIdent(line, old, neu);
            AppendBodyLine(sb, ref first, line);
        }
        if (lines.Length > 0 && lines[lines.Length - 1].Length == 0)
            sb.Append('\n');
        return sb.ToString();
    }

    // Replace an identifier in text using token-aware replacement (word-boundary safe)
    private static string ReplaceIdent(string text, string oldIdent, string newIdent)
    {
        var tokens = Tokenize(text);
        var sb = new StringBuilder();
        int pos = 0;
        foreach (var tok in tokens)
        {
            // Append any whitespace/gap between previous token and this one
            if (tok.Start > pos)
                sb.Append(text[pos..tok.Start]);
            if (tok.Type == TokenType.Ident && tok.Text == oldIdent)
                sb.Append(newIdent);
            else
                sb.Append(tok.Text);
            pos = tok.Start + tok.Text.Length;
        }
        if (pos < text.Length)
            sb.Append(text[pos..]);
        return sb.ToString();
    }

    // Check if a token at index in array matches ident text
    private static bool IsIdent(Token[] tokens, int idx, string name) =>
        idx >= 0 && idx < tokens.Length && tokens[idx].Type == TokenType.Ident && tokens[idx].Text == name;

    private static bool IsOp(Token[] tokens, int idx, string op) =>
        idx >= 0 && idx < tokens.Length && tokens[idx].Type == TokenType.Op && tokens[idx].Text == op;

    private static bool IsDot(Token[] tokens, int idx) =>
        idx >= 0 && idx < tokens.Length && tokens[idx].Type == TokenType.Dot;

    // Gather all tokens from startIdx to endIdx (exclusive) as text
    private static string TokensToText(Token[] tokens, int startIdx, int endIdx)
    {
        var sb = new StringBuilder();
        for (int i = startIdx; i < endIdx; i++)
        {
            if (i > startIdx && NeedsSpace(tokens[i - 1], tokens[i]))
                sb.Append(' ');
            sb.Append(tokens[i].Text);
        }
        return sb.ToString();
    }

    // ==================== Scalar-lane collapsing ====================

}
