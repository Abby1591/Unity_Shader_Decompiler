using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace UnityShaderDecompiler.Core.Hlsl;

// Math-idiom recognition: normalize/rsqrt/dot/lerp/gamma/log2 patterns.
internal static partial class HlslMathSimplify
{
    private static string SimplifyMathIdioms(string body)
    {
        string[] lines = body.Split('\n');
        var drop = new bool[lines.Length];
        var replacements = new Dictionary<int, string>();
        var inserts = new Dictionary<int, string>();
        var renames = new List<(string Old, string New)>();

        SimplifyNormalizes(lines, drop, replacements, renames);
        SimplifyDotProducts(lines, drop, replacements, renames);
        SimplifyLerps(lines, drop, replacements, renames);
        SimplifyVectorMatrixMuls(lines, drop, replacements, renames);
        SimplifyRowMatrixMuls(lines, drop, replacements);
        CollapseMatrixMuls(lines, drop, replacements, renames);
        SimplifyExp2Log2(lines, replacements);
        SimplifyGammaCorrection(lines, replacements);
        SimplifySwizzleChains(lines, replacements);

        if (!drop.Any(d => d) && replacements.Count == 0 && renames.Count == 0)
            return body;

        return RebuildBodyWithRenames(lines, drop, replacements, inserts, renames);
    }

    private static void SimplifyNormalizes(string[] lines, bool[] drop,
        Dictionary<int, string> replacements, List<(string Old, string New)> renames)
    {
        int matchCount = 0;
        for (int i = 0; i + 2 < lines.Length; i++)
        {
            if (drop[i] || drop[i + 1] || drop[i + 2])
                continue;

            var t0 = Tokenize(lines[i]);
            var t1 = Tokenize(lines[i + 1]);
            var t2 = Tokenize(lines[i + 2]);

            if (!TryParseDotCall(t0, out string dr, out string dotA, out string dotB))
                continue;

            if (dotA != dotB) continue;

            if (!TryParseRsqrtCall(t1, out string rsr, out string rsqrtArg))
                continue;
            if (rsqrtArg != dr) continue;

            if (!TryParseNormalizeMul(t2, out string resName, out string vecRaw))
                continue;

            string indent = ExtractIndent(lines[i]);
            string resultType = t2[0].Text;
            string vec;
            int normDims;

            if (dotA.Contains('('))
            {
                var parts = ExtractComponents(dotA);
                if (parts.Count < 3 || parts.Count > 4) continue;
                var unique = parts.Distinct(StringComparer.Ordinal).ToList();
                if (unique.Count != parts.Count) continue;
                normDims = unique.Count;
                vec = $"float{normDims}({string.Join(", ", unique)})";
            }
            else
            {
                int dotIdx = dotA.LastIndexOf('.');
                if (dotIdx > 0)
                {
                    string swz = dotA[(dotIdx + 1)..];
                    string baseName = dotA[..dotIdx];
                    normDims = swz.Distinct().Count();
                    vec = baseName;
                }
                else
                {
                    normDims = 3;
                    vec = dotA;
                }
            }

            int resultDims = resultType switch { "float2" => 2, "float3" => 3, "float4" => 4, _ => 0 };
            if (normDims < resultDims) continue;

            bool rsrUsedElsewhere = false;
            for (int j = 0; j < lines.Length; j++)
            {
                if (j == i || j == i + 1 || j == i + 2 || drop[j]) continue;
                // Compare identifier tokens, not substrings or space-delimited
                // text: the value is also used as `mad(x, rsr, y)`, with a
                // space after the comma, which no substring test caught.
                if (Tokenize(lines[j]).Any(t => t.Text == rsr))
                {
                    rsrUsedElsewhere = true;
                    break;
                }
            }
            if (rsrUsedElsewhere) continue;

            matchCount++;
            drop[i + 1] = true;
            drop[i + 2] = true;
            replacements[i] = $"{indent}{resultType} {resName} = normalize({vec});";
        }
    }

    private static void SimplifyRowMatrixMuls(string[] lines, bool[] drop, Dictionary<int, string> replacements)
    {
        for (int i = 0; i + 3 < lines.Length; i++)
        {
            if (drop[i] || drop[i + 1] || drop[i + 2] || drop[i + 3]) continue;

            if (!TryParseRowMatrixSeed(lines[i], out string acc1, out string matA, out string row, out string matB))
                continue;

            if (!TryParseRowMatrixMad(lines[i + 1], acc1, matB, out string acc2)) continue;
            if (!TryParseRowMatrixMad(lines[i + 2], acc2, matB, out string acc3)) continue;
            if (!TryParseRowMatrixMad(lines[i + 3], acc3, matB, out string acc4)) continue;

            string indent = ExtractIndent(lines[i]);
            replacements[i] = $"{indent}float3 {acc4} = mul({matA}[{row}], {matB}).xyz;";
            drop[i + 1] = true;
            drop[i + 2] = true;
            drop[i + 3] = true;
        }
    }

    private static bool TryParseRowMatrixSeed(string line, out string acc, out string matA, out string row, out string matB)
    {
        acc = matA = row = matB = "";
        string trimmed = line.Trim();

        var m = System.Text.RegularExpressions.Regex.Match(trimmed,
            @"^float3\s+(\w+)\s*=\s*\(\(\s*(\w+)\[(\d+)\]\.yyyy\s*\*\s*(\w+)\[1\]\.xyzx\s*\)\)\.xyz\s*;\s*$");
        if (!m.Success) return false;

        acc = m.Groups[1].Value;
        matA = m.Groups[2].Value;
        row = m.Groups[3].Value;
        matB = m.Groups[4].Value;
        return true;
    }

    private static bool TryParseRowMatrixMad(string line, string prevAcc, string matB, out string nextAcc)
    {
        nextAcc = "";
        string trimmed = line.Trim();

        var m = System.Text.RegularExpressions.Regex.Match(trimmed,
            @"^float3\s+(\w+)\s*=\s*\(mad\(\s*" + System.Text.RegularExpressions.Regex.Escape(matB) +
            @"\[\d+\]\.xyzx\s*,\s*\w+\[\d+\]\.\w+\s*,\s*" +
            System.Text.RegularExpressions.Regex.Escape(prevAcc) + @"\.xyzx\s*\)\)\.xyz\s*;\s*$");
        if (!m.Success) return false;

        nextAcc = m.Groups[1].Value;
        return true;
    }

    private static void CollapseMatrixMuls(string[] lines, bool[] drop,
        Dictionary<int, string> replacements, List<(string Old, string New)> renames)
    {
        var mulPattern = new System.Text.RegularExpressions.Regex(
            @"^float3\s+(\w+)\s*=\s*mul\((\w+)\[(\d+)\],\s*(\w+)\)\.xyz\s*;\s*$");

        for (int i = 0; i < lines.Length; i++)
        {
            if (drop[i]) continue;

            string lineI = replacements.TryGetValue(i, out string? ri) ? ri : lines[i];
            var m0 = mulPattern.Match(lineI.Trim());
            if (!m0.Success) continue;

            string var0 = m0.Groups[1].Value;
            string matA = m0.Groups[2].Value;
            string matB = m0.Groups[4].Value;
            int row0 = int.Parse(m0.Groups[3].Value);

            var group = new List<(int lineIdx, string varName, int row)> { (i, var0, row0) };

            int nextLine = i + 1;
            while (nextLine < lines.Length && group.Count < 8)
            {
                if (drop[nextLine]) { nextLine++; continue; }

                string lineJ = replacements.TryGetValue(nextLine, out string? rj) ? rj : lines[nextLine];
                var mj = mulPattern.Match(lineJ.Trim());
                if (!mj.Success) break;

                if (mj.Groups[2].Value != matA || mj.Groups[4].Value != matB) break;

                int row = int.Parse(mj.Groups[3].Value);
                group.Add((nextLine, mj.Groups[1].Value, row));
                nextLine++;
            }

            if (group.Count < 2) continue;

            var rows = group.Select(g => g.row).OrderBy(r => r).ToList();
            bool isContiguous = true;
            for (int r = 1; r < rows.Count; r++)
            {
                if (rows[r] != rows[0] + r) { isContiguous = false; break; }
            }
            if (!isContiguous) continue;

            string indent = ExtractIndent(lineI);
            string baseName = ExtractBaseName(var0, row0);

            replacements[i] = $"{indent}float4x4 {baseName} = mul({matA}, {matB});";
            renames.Add((var0, $"{baseName}[{row0}].xyz"));

            for (int k = 1; k < group.Count; k++)
            {
                drop[group[k].lineIdx] = true;
                renames.Add((group[k].varName, $"{baseName}[{group[k].row}].xyz"));
            }
        }
    }

    private static string ExtractBaseName(string varName, int row)
    {
        string suffix = $"{row}_xyz_";
        int idx = varName.IndexOf(suffix, StringComparison.Ordinal);
        if (idx >= 0) return varName[..idx];

        suffix = $"{row}_xyzw_";
        idx = varName.IndexOf(suffix, StringComparison.Ordinal);
        if (idx >= 0) return varName[..idx];

        return varName;
    }

    private static void SimplifyExp2Log2(string[] lines, Dictionary<int, string> replacements)
    {
        for (int i = 0; i < lines.Length; i++)
        {
            string line = lines[i];
            string trimmed = line.TrimStart();
            if (!trimmed.Contains("exp2(")) continue;

            int exp2Start = line.IndexOf("exp2(");
            if (exp2Start < 0) continue;

            int exp2ArgStart = exp2Start + 4;
            int depth = 0;
            int exp2ArgEnd = -1;
            for (int j = exp2ArgStart; j < line.Length; j++)
            {
                if (line[j] == '(') depth++;
                else if (line[j] == ')')
                {
                    depth--;
                    if (depth == 0) { exp2ArgEnd = j; break; }
                }
            }
            if (exp2ArgEnd < 0) continue;

            string exp2Arg = line.Substring(exp2ArgStart + 1, exp2ArgEnd - exp2ArgStart - 1);

            string log2Arg = "", multArg = "";
            if (!SplitLog2MulPattern(exp2Arg, out log2Arg, out multArg))
                continue;

            string indent = ExtractIndent(line);
            string prefix = line.Substring(0, exp2Start);
            string suffix = line.Substring(exp2ArgEnd + 1);

            string replacement = $"{indent}{prefix}pow({log2Arg}, {multArg}){suffix}";
            replacements[i] = replacement;
        }
    }

    private static void SimplifyGammaCorrection(string[] lines, Dictionary<int, string> replacements)
    {
        var gammaPattern = new System.Text.RegularExpressions.Regex(
            @"exp2\(.+log2\(\(max\(\((.+?)\)\.xyzx, float4\(0, 0, 0, 0\)\)\)\.xyzx\).+0\.41666666.+\.xyz");

        for (int i = 0; i < lines.Length; i++)
        {
            if (replacements.ContainsKey(i)) continue;
            string line = lines[i];
            var m = gammaPattern.Match(line);
            if (!m.Success) continue;

            string colorExpr = m.Groups[1].Value;
            string indent = ExtractIndent(line);
            int exp2Start = line.IndexOf("exp2(");
            string prefix = line.Substring(0, exp2Start);
            string suffix = line.Substring(m.Index + m.Length);

            replacements[i] = $"{indent}{prefix}pow(max({colorExpr}.xyz, float3(0, 0, 0)), float3(0.41666666, 0.41666666, 0.41666666))){suffix}";
        }
    }

    private static bool SplitLog2MulPattern(string expr, out string log2Arg, out string multArg)
    {
        log2Arg = multArg = "";
        expr = expr.Trim();

        if (!expr.StartsWith("(") || !expr.EndsWith(")"))
            return false;

        string inner = expr[1..^1].Trim();
        if (!inner.StartsWith("log2("))
            return false;

        int log2ArgStart = inner.IndexOf('(') + 1;
        int depth = 1;
        int log2ArgEnd = -1;
        for (int i = log2ArgStart; i < inner.Length; i++)
        {
            if (inner[i] == '(') depth++;
            else if (inner[i] == ')')
            {
                depth--;
                if (depth == 0) { log2ArgEnd = i; break; }
            }
        }
        if (log2ArgEnd < 0) return false;

        log2Arg = inner.Substring(log2ArgStart, log2ArgEnd - log2ArgStart).Trim();

        string afterLog2 = inner.Substring(log2ArgEnd + 1).Trim();
        if (!afterLog2.StartsWith("*"))
            return false;

        multArg = afterLog2[1..].Trim();
        if (string.IsNullOrEmpty(multArg)) return false;

        return true;
    }

    private static void SimplifySwizzleChains(string[] lines, Dictionary<int, string> replacements)
    {
        string swizChars = "xyzw";
        for (int i = 0; i < lines.Length; i++)
        {
            string line = lines[i];
            if (replacements.ContainsKey(i)) continue;
            if (!line.Contains(".xyzx)")) continue;

            string result = System.Text.RegularExpressions.Regex.Replace(line,
                @"\(([^()]+)\.([xyzw]+)\)\.([xyzw]+)",
                m =>
                {
                    string expr = m.Groups[1].Value;
                    string innerSwiz = m.Groups[2].Value;
                    string outerSwiz = m.Groups[3].Value;
                    if (innerSwiz.Length != 4) return m.Value;
                    string netSwiz = "";
                    foreach (char c in outerSwiz)
                    {
                        int idx = swizChars.IndexOf(c);
                        if (idx >= 0 && idx < innerSwiz.Length)
                            netSwiz += innerSwiz[idx];
                    }
                    if (netSwiz.Length == 0) return m.Value;
                    return $"{expr}.{netSwiz}";
                });
            if (result != line)
                replacements[i] = result;
        }
    }

    private static bool TryParseDotCall(Token[] tokens, out string resultVar, out string argA, out string argB)
    {
        resultVar = argA = argB = "";
        // Expected: float <resultVar> = dot( <argA> , <argB> ) ;
        if (tokens.Length < 7) return false;
        if (tokens[0].Text != "float") return false;
        resultVar = tokens[1].Text;
        if (tokens[2].Text != "=") return false;
        if (tokens[3].Text != "dot") return false;
        if (tokens[4].Type != TokenType.LParen) return false;

        // Find the matching RParen for dot(
        int depth = 0;
        int rparen = -1;
        for (int i = 4; i < tokens.Length; i++)
        {
            if (tokens[i].Type == TokenType.LParen) depth++;
            if (tokens[i].Type == TokenType.RParen)
            {
                depth--;
                if (depth == 0) { rparen = i; break; }
            }
        }
        if (rparen < 0) return false;

        // Find comma at depth 1 (inside dot)
        int commaIdx = -1;
        int innerDepth = 0;
        for (int i = 5; i < rparen; i++)
        {
            if (tokens[i].Type == TokenType.LParen) innerDepth++;
            if (tokens[i].Type == TokenType.RParen) innerDepth--;
            if (innerDepth == 0 && tokens[i].Type == TokenType.Comma)
            {
                commaIdx = i;
                break;
            }
        }
        if (commaIdx < 0) return false;

        argA = GatherArg(tokens, 5, commaIdx);
        argB = GatherArg(tokens, commaIdx + 1, rparen);

        // Check semicolon after rparen
        if (rparen + 1 < tokens.Length && tokens[rparen + 1].Type == TokenType.Semicolon)
            return true;
        // Sometimes there's no semicolon token if we're at end of tokens
        return rparen == tokens.Length - 1 || (rparen + 1 < tokens.Length && tokens[rparen + 1].Type == TokenType.Semicolon);
    }

    private static bool TryParseRsqrtCall(Token[] tokens, out string resultVar, out string arg)
    {
        resultVar = arg = "";
        // Expected: float <resultVar> = rsqrt( <arg> ) ;
        if (tokens.Length < 6) return false;
        if (tokens[0].Text != "float") return false;
        resultVar = tokens[1].Text;
        if (tokens[2].Text != "=") return false;
        if (tokens[3].Text != "rsqrt") return false;
        if (tokens[4].Type != TokenType.LParen) return false;

        int depth = 0;
        int rparen = -1;
        for (int i = 4; i < tokens.Length; i++)
        {
            if (tokens[i].Type == TokenType.LParen) depth++;
            if (tokens[i].Type == TokenType.RParen)
            {
                depth--;
                if (depth == 0) { rparen = i; break; }
            }
        }
        if (rparen < 0) return false;

        arg = GatherArg(tokens, 5, rparen).Trim();
        return true;
    }

    private static bool TryParseNormalizeMul(Token[] tokens, out string resultVar, out string vecRaw)
    {
        resultVar = vecRaw = "";
        // Expected: floatN <resultVar> = <possibly wrapped expression with rsr.xxxx * vec>
        // The * may be at depth > 0 due to outer parens: ((rsr.xxxx * vec)).swz
        if (tokens.Length < 4) return false;
        string typeName = tokens[0].Text;
        if (typeName != "float2" && typeName != "float3" && typeName != "float4") return false;
        resultVar = tokens[1].Text;
        if (tokens[2].Text != "=") return false;

        // Find the '*' at the shallowest non-negative depth.
        // Outer parens push depth up, so we look for the shallowest * that has
        // .xxxx to its left (confirming it's the normalize multiply).
        int mulIdx = -1;
        int bestDepth = int.MaxValue;
        int depth = 0;
        for (int i = 3; i < tokens.Length; i++)
        {
            if (tokens[i].Type == TokenType.LParen) depth++;
            if (tokens[i].Type == TokenType.RParen) depth--;
            if (tokens[i].Type == TokenType.Op && tokens[i].Text == "*" && depth < bestDepth)
            {
                // Verify left side ends with .xxxx
                if (i >= 3 && i - 2 >= 3 &&
                    tokens[i - 1].Type == TokenType.Ident && tokens[i - 1].Text == "xxxx" &&
                    tokens[i - 2].Type == TokenType.Dot)
                {
                    mulIdx = i;
                    bestDepth = depth;
                }
            }
        }
        if (mulIdx < 0) return false;

        // Right side: <vec> possibly followed by .swizzle
        vecRaw = GatherArg(tokens, mulIdx + 1, tokens.Length).Trim();
        while (vecRaw.Length > 0 && vecRaw[^1] is ';' or ' ')
            vecRaw = vecRaw[..^1];

        return true;
    }

    private static void SimplifyDotProducts(string[] lines, bool[] drop,
        Dictionary<int, string> replacements, List<(string Old, string New)> renames)
    {
        for (int i = 0; i < lines.Length; i++)
        {
            if (drop[i]) continue;

            var tokens = Tokenize(lines[i]);
            // Expected: float <res> = ( <t1> * <v1>.<c1> + <t2> * <v2>.<c2> + <t3> * <v3>.<c3> [ + <t4> * <v4>.<c4> ] ) ;
            if (!TryParseDotProductChain(tokens, out string res, out string[] scalars, out string[] vecs))
                continue;

            int count = scalars.Length;
            string sBase = scalars[0].Split('.')[0];
            string vBase = vecs[0].Split('.')[0];
            bool allScalarMatch = scalars.All(s => s.Split('.')[0] == sBase);
            bool allVecMatch = vecs.All(v => v.Split('.')[0] == vBase);
            if (!allScalarMatch || !allVecMatch) continue;

            char[] sComps = scalars.Select(s => s.Contains('.') ? s.Split('.')[1][0] : 'x').ToArray();
            char[] vComps = vecs.Select(v => v.Contains('.') ? v.Split('.')[1][0] : 'x').ToArray();
            if (sComps.Distinct().Count() != count || vComps.Distinct().Count() != count)
                continue;

            string indent = ExtractIndent(lines[i]);
            string swz = new string(sComps);
            string dim = count == 3 ? "3" : "4";
            string dotA = $"{sBase}.{swz}";
            string dotB = $"{vBase}.{swz}";

            replacements[i] = $"{indent}float{dim} {res} = dot({dotA}, {dotB});";
        }
    }

    private static bool TryParseDotProductChain(Token[] tokens, out string res, out string[] scalars, out string[] vecs)
    {
        res = "";
        scalars = Array.Empty<string>();
        vecs = Array.Empty<string>();

        // float <res> = ( ... ) ;
        if (tokens.Length < 5) return false;
        if (tokens[0].Text != "float") return false;
        res = tokens[1].Text;
        if (tokens[2].Text != "=") return false;

        // Find the expression - could be wrapped in parens or not
        int exprStart = 3;
        // Skip optional leading paren
        bool hasLeadingParen = false;
        if (tokens[exprStart].Type == TokenType.LParen)
        {
            hasLeadingParen = true;
            exprStart++;
        }

        // Collect terms: term = <scalar>*<vec>.<comp> separated by '+'
        var scalarsList = new List<string>();
        var vecsList = new List<string>();
        int depth = 0;
        int termStart = exprStart;

        for (int i = exprStart; i < tokens.Length; i++)
        {
            if (tokens[i].Type == TokenType.LParen) depth++;
            if (tokens[i].Type == TokenType.RParen)
            {
                if (depth == 0) break; // closing paren of expression
                depth--;
            }
            if (depth == 0 && tokens[i].Type == TokenType.Op && tokens[i].Text == "+")
            {
                // Parse the term from termStart to i
                if (!TryParseDotTerm(tokens, termStart, i, out string scalar, out string vec))
                    return false;
                scalarsList.Add(scalar);
                vecsList.Add(vec);
                termStart = i + 1;
            }
        }
        // Parse last term
        int termEnd = tokens.Length;
        if (hasLeadingParen)
        {
            // Find the closing paren
            int pDepth = 0;
            for (int i = exprStart - 1; i < tokens.Length; i++)
            {
                if (tokens[i].Type == TokenType.LParen) pDepth++;
                if (tokens[i].Type == TokenType.RParen)
                {
                    pDepth--;
                    if (pDepth == 0) { termEnd = i; break; }
                }
            }
        }
        else
        {
            // The expression ends at semicolon or end
            for (int i = termStart; i < tokens.Length; i++)
            {
                if (tokens[i].Type == TokenType.Semicolon) { termEnd = i; break; }
            }
        }

        if (!TryParseDotTerm(tokens, termStart, termEnd, out string lastScalar, out string lastVec))
            return false;
        scalarsList.Add(lastScalar);
        vecsList.Add(lastVec);

        if (scalarsList.Count < 3 || scalarsList.Count > 4)
            return false;

        scalars = scalarsList.ToArray();
        vecs = vecsList.ToArray();
        return true;
    }

    private static bool TryParseDotTerm(Token[] tokens, int start, int end, out string scalar, out string vec)
    {
        scalar = vec = "";
        // Term: <scalar> * <vec>.<comp>
        // Find '*' at depth 0
        int mulIdx = -1;
        int depth = 0;
        for (int i = start; i < end; i++)
        {
            if (tokens[i].Type == TokenType.LParen) depth++;
            if (tokens[i].Type == TokenType.RParen) depth--;
            if (depth == 0 && tokens[i].Type == TokenType.Op && tokens[i].Text == "*")
            {
                mulIdx = i;
                break;
            }
        }
        if (mulIdx < 0) return false;

        scalar = GatherArg(tokens, start, mulIdx).Trim();
        // After *, expect: <vec>.<comp>
        // vec should be ident, then dot, then ident (the component)
        int rhsStart = mulIdx + 1;
        // Skip leading parens/ops
        while (rhsStart < end && tokens[rhsStart].Type == TokenType.LParen)
            rhsStart++;

        if (rhsStart >= end) return false;
        if (tokens[rhsStart].Type != TokenType.Ident) return false;
        string vecName = tokens[rhsStart].Text;

        if (rhsStart + 2 < end && tokens[rhsStart + 1].Type == TokenType.Dot &&
            tokens[rhsStart + 2].Type == TokenType.Ident)
        {
            vec = $"{vecName}.{tokens[rhsStart + 2].Text}";
        }
        else
        {
            vec = vecName;
        }
        return true;
    }

    private static void SimplifyLerps(string[] lines, bool[] drop,
        Dictionary<int, string> replacements, List<(string Old, string New)> renames)
    {
        for (int i = 0; i < lines.Length; i++)
        {
            if (drop[i]) continue;

            var tokens = Tokenize(lines[i]);
            if (!TryParseLerp(tokens, out string res, out string a, out string b, out string t))
                continue;

            string indent = ExtractIndent(lines[i]);
            replacements[i] = $"{indent}float {res} = lerp({a}, {b}, {t});";
        }
    }

    private static bool TryParseLerp(Token[] tokens, out string res, out string a, out string b, out string t)
    {
        res = a = b = t = "";
        // Expected: float <res> = <a> * (1 - <t>) + <b> * <t> ;
        if (tokens.Length < 8) return false;
        if (tokens[0].Text != "float") return false;
        res = tokens[1].Text;
        if (tokens[2].Text != "=") return false;

        // Find first '*'
        int mul1 = -1;
        for (int i = 3; i < tokens.Length; i++)
        {
            if (tokens[i].Type == TokenType.Op && tokens[i].Text == "*")
            {
                mul1 = i;
                break;
            }
        }
        if (mul1 < 0) return false;

        a = GatherArg(tokens, 3, mul1).Trim();
        // After first *: expect (1 - <t>)
        int afterMul1 = mul1 + 1;
        if (afterMul1 >= tokens.Length || tokens[afterMul1].Type != TokenType.LParen) return false;

        // Find matching RParen
        int depth = 0;
        int rparen1 = -1;
        for (int i = afterMul1; i < tokens.Length; i++)
        {
            if (tokens[i].Type == TokenType.LParen) depth++;
            if (tokens[i].Type == TokenType.RParen)
            {
                depth--;
                if (depth == 0) { rparen1 = i; break; }
            }
        }
        if (rparen1 < 0) return false;

        // Inside parens: 1 - <t>
        // tokens: 1 - ident
        int innerStart = afterMul1 + 1;
        if (tokens[innerStart].Type != TokenType.Number || tokens[innerStart].Text != "1") return false;
        if (tokens[innerStart + 1].Type != TokenType.Op || tokens[innerStart + 1].Text != "-") return false;
        t = GatherArg(tokens, innerStart + 2, rparen1).Trim();

        // After rparen1: + <b> * <t> ;
        int plusIdx = rparen1 + 1;
        if (plusIdx >= tokens.Length || tokens[plusIdx].Type != TokenType.Op || tokens[plusIdx].Text != "+")
            return false;

        // Find second '*'
        int mul2 = -1;
        for (int i = plusIdx + 1; i < tokens.Length; i++)
        {
            if (tokens[i].Type == TokenType.Op && tokens[i].Text == "*")
            {
                mul2 = i;
                break;
            }
        }
        if (mul2 < 0) return false;

        b = GatherArg(tokens, plusIdx + 1, mul2).Trim();

        // After second *: <t>
        string t2 = GatherArg(tokens, mul2 + 1, tokens.Length).Trim();
        // Remove trailing semicolons
        while (t2.Length > 0 && t2[^1] is ';' or ' ')
            t2 = t2[..^1];

        if (t2 != t) return false;

        return true;
    }

    private static void SimplifyVectorMatrixMuls(string[] lines, bool[] drop,
        Dictionary<int, string> replacements, List<(string Old, string New)> renames)
    {
        for (int i = 0; i + 2 < lines.Length; i++)
        {
            if (drop[i]) continue;

            var seedTokens = Tokenize(lines[i]);
            // Seed: float4 <acc> = <scalar> * <mat>[<idx>];
            if (!TryParseVecMatSeed(seedTokens, out string acc, out string vecBase, out string mat, out char comp0, out string idx0))
                continue;

            var comps = new List<char> { comp0 };
            var indices = new List<string> { idx0 };
            int end = i + 1;

            for (int j = i + 1; j < lines.Length && j < i + 6; j++)
            {
                if (drop[j]) { end = j + 1; continue; }

                var jTokens = Tokenize(lines[j]);

                // Try mad pattern: <acc> = mad(<a>, <b>, <acc>);
                if (TryParseVecMatMad(jTokens, acc, mat, out string madScalar, out string madIdx))
                {
                    // madScalar should be <vecBase>.<comp>
                    var madSwiz = TryExtractSwizzle(madScalar, vecBase);
                    if (madSwiz.HasValue)
                    {
                        comps.Add(madSwiz.Value);
                        indices.Add(madIdx);
                        end = j + 1;
                        continue;
                    }
                }

                // Try add pattern: <acc> = <acc> + <scalar> * <mat>[<idx>];
                if (TryParseVecMatAdd(jTokens, acc, mat, out string addScalar, out string addIdx))
                {
                    var addSwiz = TryExtractSwizzle(addScalar, vecBase);
                    if (addSwiz.HasValue)
                    {
                        comps.Add(addSwiz.Value);
                        indices.Add(addIdx);
                        end = j + 1;
                        continue;
                    }
                }

                break;
            }

            if (comps.Count < 3) continue;
            if (indices.Count != comps.Count) continue;
            var idxInts = indices.Select(int.Parse).ToList();
            if (idxInts.Any(x => x < 0 || x > 3)) continue;

            string indent = ExtractIndent(lines[i]);
            string swzStr = new string(comps.ToArray());
            string vecCtor = $"float4({string.Join(", ", comps.Select(c => $"{vecBase}.{c}"))})";
            string result = $"{indent}float4 {acc} = mul({vecCtor}, {mat});";

            for (int k = i + 1; k < end; k++)
                drop[k] = true;
            replacements[i] = result;
        }
    }

    private static bool TryParseVecMatSeed(Token[] tokens, out string acc, out string vecBase, out string mat, out char comp, out string idx)
    {
        acc = vecBase = mat = "";
        comp = 'x';
        idx = "";
        // float4 <acc> = <scalar> * <mat>[<idx>];
        if (tokens.Length < 4) return false;
        if (tokens[0].Text != "float4") return false;
        acc = tokens[1].Text;
        if (tokens[2].Text != "=") return false;

        // Find '*' 
        int mulIdx = -1;
        for (int i = 3; i < tokens.Length; i++)
        {
            if (tokens[i].Type == TokenType.Op && tokens[i].Text == "*")
            {
                mulIdx = i;
                break;
            }
        }
        if (mulIdx < 0) return false;

        // Left side: <scalar> (should be <vecBase>.<comp>)
        string scalarPart = GatherArg(tokens, 3, mulIdx).Trim();
        // Right side: <mat>[<idx>]
        string rhs = GatherArg(tokens, mulIdx + 1, tokens.Length).Trim();
        // Remove trailing semicolons
        while (rhs.Length > 0 && rhs[^1] is ';' or ' ')
            rhs = rhs[..^1];

        if (!TryParseMatAccess(rhs, out mat, out idx)) return false;

        // Parse scalarPart as <base>.<comp>
        var scalarTokens = Tokenize(scalarPart);
        if (scalarTokens.Length >= 3 &&
            scalarTokens[0].Type == TokenType.Ident &&
            scalarTokens[1].Type == TokenType.Dot &&
            scalarTokens[2].Type == TokenType.Ident &&
            scalarTokens[2].Text.Length == 1 &&
            "xyzw".Contains(scalarTokens[2].Text[0]))
        {
            vecBase = scalarTokens[0].Text;
            comp = scalarTokens[2].Text[0];
            return true;
        }

        return false;
    }

    private static bool TryParseMatAccess(string s, out string mat, out string idx)
    {
        mat = idx = "";
        var tokens = Tokenize(s);
        // Expected: <mat>[<idx>]
        if (tokens.Length < 4) return false;
        if (tokens[0].Type != TokenType.Ident) return false;
        if (tokens[1].Type != TokenType.LBracket) return false;
        if (tokens[2].Type != TokenType.Number) return false;
        if (tokens[3].Type != TokenType.RBracket) return false;
        mat = tokens[0].Text;
        idx = tokens[2].Text;
        return true;
    }

    private static bool TryParseVecMatMad(Token[] tokens, string acc, string mat, out string scalar, out string idx)
    {
        scalar = idx = "";
        // <acc> = mad(<a>, <b>, <acc>);
        if (tokens.Length < 4) return false;
        // Find '='
        int eqIdx = -1;
        for (int i = 0; i < tokens.Length; i++)
            if (tokens[i].Type == TokenType.Op && tokens[i].Text == "=")
            { eqIdx = i; break; }
        if (eqIdx < 0) return false;

        string lhs = GatherArg(tokens, 0, eqIdx).Trim();
        if (lhs != acc) return false;

        // Find "mad("
        int madIdx = -1;
        for (int i = eqIdx + 1; i < tokens.Length; i++)
        {
            if (tokens[i].Type == TokenType.Ident && tokens[i].Text == "mad" &&
                i + 1 < tokens.Length && tokens[i + 1].Type == TokenType.LParen)
            {
                madIdx = i + 1;
                break;
            }
        }
        if (madIdx < 0) return false;

        // Find matching RParen
        int depth = 0;
        int rparen = -1;
        for (int i = madIdx; i < tokens.Length; i++)
        {
            if (tokens[i].Type == TokenType.LParen) depth++;
            if (tokens[i].Type == TokenType.RParen)
            {
                depth--;
                if (depth == 0) { rparen = i; break; }
            }
        }
        if (rparen < 0) return false;

        // Three args
        var args = new List<string>();
        int argStart = madIdx + 1;
        int argDepth = 0;
        for (int i = madIdx + 1; i < rparen; i++)
        {
            if (tokens[i].Type == TokenType.LParen) argDepth++;
            if (tokens[i].Type == TokenType.RParen) argDepth--;
            if (argDepth == 0 && tokens[i].Type == TokenType.Comma)
            {
                args.Add(GatherArg(tokens, argStart, i).Trim());
                argStart = i + 1;
            }
        }
        args.Add(GatherArg(tokens, argStart, rparen).Trim());
        if (args.Count != 3) return false;

        // Third arg should be acc
        if (args[2] != acc) return false;

        // One of first two args should be mat[...], the other is the scalar
        if (TryParseMatAccess(args[0], out string m0, out string i0) && m0 == mat)
        {
            scalar = args[1];
            idx = i0;
            return true;
        }
        if (TryParseMatAccess(args[1], out string m1, out string i1) && m1 == mat)
        {
            scalar = args[0];
            idx = i1;
            return true;
        }
        return false;
    }

    private static bool TryParseVecMatAdd(Token[] tokens, string acc, string mat, out string scalar, out string idx)
    {
        scalar = idx = "";
        // <acc> = <acc> + <scalar> * <mat>[<idx>];
        if (tokens.Length < 4) return false;

        int eqIdx = -1;
        for (int i = 0; i < tokens.Length; i++)
            if (tokens[i].Type == TokenType.Op && tokens[i].Text == "=")
            { eqIdx = i; break; }
        if (eqIdx < 0) return false;

        string lhs = GatherArg(tokens, 0, eqIdx).Trim();
        if (lhs != acc) return false;

        // Find '+' at depth 0 after '='
        int plusIdx = -1;
        int depth = 0;
        for (int i = eqIdx + 1; i < tokens.Length; i++)
        {
            if (tokens[i].Type == TokenType.LParen) depth++;
            if (tokens[i].Type == TokenType.RParen) depth--;
            if (depth == 0 && tokens[i].Type == TokenType.Op && tokens[i].Text == "+")
            {
                plusIdx = i;
                break;
            }
        }
        if (plusIdx < 0) return false;

        // Left side of '+' should be acc
        string addLhs = GatherArg(tokens, eqIdx + 1, plusIdx).Trim();
        if (addLhs != acc) return false;

        // Right side: <scalar> * <mat>[<idx>]
        string addRhs = GatherArg(tokens, plusIdx + 1, tokens.Length).Trim();
        while (addRhs.Length > 0 && addRhs[^1] is ';' or ' ')
            addRhs = addRhs[..^1];

        // Find '*' in addRhs tokens
        var rhsTokens = Tokenize(addRhs);
        int mulIdx = -1;
        for (int i = 0; i < rhsTokens.Length; i++)
        {
            if (rhsTokens[i].Type == TokenType.Op && rhsTokens[i].Text == "*")
            {
                mulIdx = i;
                break;
            }
        }
        if (mulIdx < 0) return false;

        scalar = GatherArg(rhsTokens, 0, mulIdx).Trim();
        string matPart = GatherArg(rhsTokens, mulIdx + 1, rhsTokens.Length).Trim();
        if (!TryParseMatAccess(matPart, out string m, out string idxVal)) return false;
        if (m != mat) return false;
        idx = idxVal;
        return true;
    }

    private static char? TryExtractSwizzle(string expr, string expectedBase)
    {
        // expr should be <expectedBase>.<comp>
        var tokens = Tokenize(expr);
        if (tokens.Length >= 3 &&
            tokens[0].Type == TokenType.Ident && tokens[0].Text == expectedBase &&
            tokens[1].Type == TokenType.Dot &&
            tokens[2].Type == TokenType.Ident && tokens[2].Text.Length == 1 &&
            "xyzw".Contains(tokens[2].Text[0]))
        {
            return tokens[2].Text[0];
        }
        return null;
    }
}
