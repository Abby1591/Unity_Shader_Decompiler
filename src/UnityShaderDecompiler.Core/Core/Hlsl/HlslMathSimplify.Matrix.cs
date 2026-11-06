using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace UnityShaderDecompiler.Core.Hlsl;

// Scalar-lane and matrix-multiply collapses.
internal static partial class HlslMathSimplify
{
    private static string CollapseScalarLanes(string body)
    {
        while (true)
        {
            string next = CollapseScalarLanesOnce(body);
            if (next == body)
                return body;
            body = next;
        }
    }

    private static string CollapseScalarLanesOnce(string body)
    {
        string[] lines = body.Split('\n');
        var parsed = new ParsedLine[lines.Length];
        for (int idx = 0; idx < lines.Length; idx++)
            parsed[idx] = ParseLine(idx, lines[idx]);

        var drop = new bool[lines.Length];
        var edits = new Dictionary<int, List<(int Start, int Len, string Rep)>>();
        int i = 0;
        while (i + 3 < lines.Length)
        {
            if (!TryMatchScalarSplit(parsed, i, out string V, out Dictionary<string, char> lane))
            {
                i++;
                continue;
            }

            bool clean = true;
            var groupEdits = new List<(int Line, int Start, int Len, string Rep)>();
            for (int k = 0; k < lines.Length && clean; k++)
            {
                if (k >= i && k <= i + 3)
                    continue;
                string t = lines[k];
                var tTokens = parsed[k].Tokens;

                // (a) whole-constructor units first
                var covered = new List<(int Start, int Len)>();
                // Scan for float2/3/4(...) constructors
                for (int j = 0; j < tTokens.Length; j++)
                {
                    if (tTokens[j].Type == TokenType.Ident &&
                        (tTokens[j].Text == "float2" || tTokens[j].Text == "float3" || tTokens[j].Text == "float4") &&
                        j + 1 < tTokens.Length && tTokens[j + 1].Type == TokenType.LParen)
                    {
                        // Find matching RParen
                        int depth = 0;
                        int rparen = -1;
                        for (int r = j + 1; r < tTokens.Length; r++)
                        {
                            if (tTokens[r].Type == TokenType.LParen) depth++;
                            if (tTokens[r].Type == TokenType.RParen)
                            {
                                depth--;
                                if (depth == 0) { rparen = r; break; }
                            }
                        }
                        if (rparen < 0) continue;

                        // Extract args between LParen and RParen
                        var args = new List<string>();
                        int argStart = -1;
                        int innerDepth = 0;
                        for (int a = j + 2; a < rparen; a++)
                        {
                            if (tTokens[a].Type == TokenType.LParen) innerDepth++;
                            if (tTokens[a].Type == TokenType.RParen) innerDepth--;
                            if (innerDepth == 0 && tTokens[a].Type == TokenType.Comma)
                            {
                                if (argStart >= 0)
                                {
                                    var sb = new StringBuilder();
                                    for (int q = argStart; q < a; q++)
                                    {
                                        if (q > argStart && NeedsSpace(tTokens[q - 1], tTokens[q]))
                                            sb.Append(' ');
                                        sb.Append(tTokens[q].Text);
                                    }
                                    args.Add(sb.ToString().Trim());
                                }
                                argStart = -1;
                            }
                            else if (innerDepth == 0 && argStart == -1 && tTokens[a].Type != TokenType.Comma)
                            {
                                argStart = a;
                            }
                        }
                        if (argStart >= 0)
                        {
                            var sb = new StringBuilder();
                            for (int q = argStart; q < rparen; q++)
                            {
                                if (q > argStart && NeedsSpace(tTokens[q - 1], tTokens[q]))
                                    sb.Append(' ');
                                sb.Append(tTokens[q].Text);
                            }
                            args.Add(sb.ToString().Trim());
                        }

                        if (args.All(a => lane.ContainsKey(a)))
                        {
                            string swz = string.Concat(args.Select(a => lane[a]));
                            int ctorStart = tTokens[j].Start;
                            int ctorEnd = tTokens[rparen].Start + tTokens[rparen].Text.Length;
                            string replacement = swz == "xyzw" ? V : $"{V}.{swz}";
                            groupEdits.Add((k, ctorStart, ctorEnd - ctorStart, replacement));
                            covered.Add((ctorStart, ctorEnd - ctorStart));
                        }
                    }
                }

                // (b)+(c) individual occurrences
                for (int j = 0; j < tTokens.Length; j++)
                {
                    if (tTokens[j].Type != TokenType.Ident) continue;
                    if (!lane.TryGetValue(tTokens[j].Text, out char lc)) continue;
                    int nmStart = tTokens[j].Start;
                    int nmEnd = nmStart + tTokens[j].Text.Length;
                    if (covered.Any(c => nmStart >= c.Start && nmStart < c.Start + c.Len))
                        continue;

                    // Check if followed by a dot + swizzle
                    if (j + 1 < tTokens.Length && tTokens[j + 1].Type == TokenType.Dot &&
                        j + 2 < tTokens.Length && tTokens[j + 2].Type == TokenType.Ident)
                    {
                        string suffix = tTokens[j + 2].Text;
                        if (suffix.All(c => c == 'x' || c == 'y' || c == 'z' || c == 'w'))
                        {
                            if (suffix.Any(c => c != suffix[0]))
                            {
                                clean = false;
                                break;
                            }
                            int swizzleEnd = tTokens[j + 2].Start + tTokens[j + 2].Text.Length;
                            groupEdits.Add((k, nmStart, swizzleEnd - nmStart, $"{V}.{new string(lc, suffix.Length)}"));
                            j += 2;
                            continue;
                        }
                        else
                        {
                            clean = false;
                            break;
                        }
                    }
                    // Check if followed by [ (bracket access on scalar - not clean)
                    else if (j + 1 < tTokens.Length && tTokens[j + 1].Type == TokenType.LBracket)
                    {
                        clean = false;
                        break;
                    }
                    // Check if followed by ( (function call on scalar - not clean)
                    else if (j + 1 < tTokens.Length && tTokens[j + 1].Type == TokenType.LParen)
                    {
                        clean = false;
                        break;
                    }
                    else
                    {
                        groupEdits.Add((k, nmStart, tTokens[j].Text.Length, $"{V}.{lc}"));
                    }
                }
            }

            if (clean)
            {
                drop[i] = drop[i + 1] = drop[i + 2] = drop[i + 3] = true;
                foreach ((int li, int st, int ln, string rep) in groupEdits)
                {
                    if (!edits.TryGetValue(li, out var list))
                        edits[li] = list = new List<(int, int, string)>();
                    list.Add((st, ln, rep));
                }
            }
            i += 4;
        }

        // Check if any changes were made
        bool anyDrop = drop.Any(d => d);
        bool anyEdit = edits.Count > 0;
        if (!anyDrop && !anyEdit)
            return body;

        var sb2 = new StringBuilder(body.Length);
        bool first = true;
        for (int k = 0; k < lines.Length; k++)
        {
            if (drop[k])
                continue;
            if (k == lines.Length - 1 && lines[k].Length == 0)
                continue;
            string line = lines[k];
            if (edits.TryGetValue(k, out var list))
                foreach ((int st, int ln, string rep) in list.OrderByDescending(e => e.Start))
                    line = line[..st] + rep + line[(st + ln)..];
            if (!first)
                sb2.Append('\n');
            sb2.Append(line);
            first = false;
        }
        if (body.Length > 0 && body[body.Length - 1] == '\n')
            sb2.Append('\n');
        return sb2.ToString();
    }

    // Try to match 4 consecutive lines as a scalar split group.
    // Lines must be:
    //   float <sx> = <V>.x;
    //   float <sy> = <V>.y;
    //   float <sz> = <V>.z;
    //   float <sw> = <V>.w;
    private static bool TryMatchScalarSplit(ParsedLine[] parsed, int i, out string V, out Dictionary<string, char> lane)
    {
        V = "";
        lane = new Dictionary<string, char>();
        if (i + 3 >= parsed.Length)
            return false;

        string[] lanes = { ".x", ".y", ".z", ".w" };
        char[] laneChars = { 'x', 'y', 'z', 'w' };
        string? baseV = null;

        for (int l = 0; l < 4; l++)
        {
            var pl = parsed[i + l];
            var t = pl.Tokens;
            // Expected: float <varName> = <V>.<lane>;
            if (pl.TypeName != "float") return false;
            if (string.IsNullOrEmpty(pl.VarName)) return false;

            // Find '='
            int eqIdx = -1;
            for (int j = 0; j < t.Length; j++)
                if (t[j].Type == TokenType.Op && t[j].Text == "=")
                { eqIdx = j; break; }
            if (eqIdx < 0) return false;

            // After '=', expect: <V> . <lane> ;
            // tokens: ... = ident dot ident ;
            int rhsStart = eqIdx + 1;
            // skip leading ops
            while (rhsStart < t.Length && t[rhsStart].Type == TokenType.Op)
                rhsStart++;

            // expect ident (the base vector)
            if (rhsStart >= t.Length || t[rhsStart].Type != TokenType.Ident)
                return false;
            string thisV = t[rhsStart].Text;

            // expect dot
            int dotIdx = rhsStart + 1;
            if (dotIdx >= t.Length || t[dotIdx].Type != TokenType.Dot)
                return false;

            // expect lane name
            int laneIdx = dotIdx + 1;
            if (laneIdx >= t.Length || t[laneIdx].Type != TokenType.Ident)
                return false;
            string laneName = t[laneIdx].Text;
            if (laneName != lanes[l][1..])
                return false;

            // expect semicolon
            int semiIdx = laneIdx + 1;
            if (semiIdx >= t.Length || t[semiIdx].Type != TokenType.Semicolon)
                return false;

            if (baseV == null)
                baseV = thisV;
            else if (thisV != baseV)
                return false;

            lane[pl.VarName] = laneChars[l];
        }

        V = baseV!;
        return true;
    }

    // ==================== Matrix-multiply reconstruction ====================

    private readonly record struct MatrixTerm(string Matrix, int Index, string Swizzle);

    private static string CollapseMatrixMul(string body)
    {
        string[] lines = body.Split('\n');
        var drop = new bool[lines.Length];
        var inserts = new Dictionary<int, string>();
        var renames = new List<(string Old, string New)>();

        int i = 0;
        while (i + 15 < lines.Length)
        {
            if (!TryParseMatrixBlock(lines, i, out string prefix, out string aMat, out string mMat))
            {
                i++;
                continue;
            }

            // Intermediates (_1.._3) must never be consumed outside the block,
            // and at least one final (_4) row must be
            bool clean = true;
            bool anyUse = false;
            for (int k = 0; k < lines.Length && clean; k++)
            {
                if (k >= i && k < i + 16)
                    continue;
                var tokens = Tokenize(lines[k]);
                for (int j = 0; j < tokens.Length; j++)
                {
                    if (tokens[j].Type != TokenType.Ident) continue;
                    string txt = tokens[j].Text;
                    // Check intermediate: prefix[0-3]_xyz_[123]
                    for (int r = 0; r < 4; r++)
                    {
                        for (int v = 1; v <= 3; v++)
                        {
                            string intermediate = $"{prefix}{r}_xyz_{v}";
                            if (txt == intermediate)
                            {
                                clean = false;
                                break;
                            }
                        }
                        if (!clean) break;
                        string final = $"{prefix}{r}_xyz_4";
                        if (txt == final)
                            anyUse = true;
                    }
                    if (!clean) break;
                }
            }
            if (!clean || !anyUse)
            {
                i++;
                continue;
            }

            for (int r = 0; r < 4; r++)
                for (int v = 1; v <= 4; v++)
                    drop[i + r * 4 + v - 1] = true;

            string indent = ExtractIndent(lines[i]);
            inserts[i] = $"{indent}float4x4 {prefix} = mul({aMat}, {mMat});";
            for (int r = 0; r < 4; r++)
                renames.Add(($"{prefix}{r}_xyz_4", $"{prefix}[{r}]"));
            i += 16;
        }

        if (!drop.Any(d => d))
            return body;

        return RebuildBodyWithRenames(lines, drop, null, inserts, renames);
    }

    private static bool TryParseMatrixBlock(string[] lines, int start, out string prefix, out string aMat, out string mMat)
    {
        prefix = aMat = mMat = "";
        string? p = null, a = null, m = null;
        for (int r = 0; r < 4; r++)
        {
            if (!TryParseMatrixRow(lines, start + r * 4, r, out string rowPrefix, out string rowA, out string rowM))
                return false;
            if (p is null)
            {
                p = rowPrefix;
                a = rowA;
                m = rowM;
            }
            else if (rowPrefix != p || rowA != a || rowM != m)
            {
                return false;
            }
        }
        prefix = p!;
        aMat = a!;
        mMat = m!;
        return true;
    }

    private static bool TryParseMatrixRow(string[] lines, int start, int r, out string prefix, out string aMat, out string mMat)
    {
        prefix = aMat = mMat = "";
        // First line: float3 <T><r>_xyz_1 = ((<a> * <b>)).xyz;
        var tokens = Tokenize(lines[start]);
        // Expected: float3 T r _xyz _1 = ( ( a * b ) ) . xyz ;
        // Let's parse structurally
        // Find '='
        int eqIdx = -1;
        for (int j = 0; j < tokens.Length; j++)
            if (tokens[j].Type == TokenType.Op && tokens[j].Text == "=")
            { eqIdx = j; break; }
        if (eqIdx < 0) return false;

        // LHS: float3 <T><r>_xyz_1
        // tokens before '=': float3 ident
        if (eqIdx < 2) return false;
        if (tokens[0].Text != "float3") return false;
        string lhsName = tokens[1].Text;
        // Parse lhsName: should end with _xyz_1
        if (!lhsName.EndsWith("_xyz_1")) return false;
        string tBase = lhsName[..^"_xyz_1".Length];
        // The base should end with the row digit
        if (tBase.Length == 0) return false;
        char rowDigit = tBase[^1];
        if (rowDigit != '0' && rowDigit != '1' && rowDigit != '2' && rowDigit != '3')
            return false;
        if (rowDigit - '0' != r) return false;
        string t = tBase[..^1]; // prefix without row digit

        // RHS: (( <a> * <b> )).xyz ;
        // After '=', expect: ( ( a * b ) ) . xyz ;
        int rhsStart = eqIdx + 1;
        // skip ops
        while (rhsStart < tokens.Length && tokens[rhsStart].Type == TokenType.Op)
            rhsStart++;

        // Expect LParen
        if (rhsStart >= tokens.Length || tokens[rhsStart].Type != TokenType.LParen) return false;
        int depth = 0;
        int innerStart = -1;
        int innerEnd = -1;
        for (int j = rhsStart; j < tokens.Length; j++)
        {
            if (tokens[j].Type == TokenType.LParen)
            {
                depth++;
                if (depth == 2 && innerStart < 0) innerStart = j + 1;
            }
            if (tokens[j].Type == TokenType.RParen)
            {
                depth--;
                if (depth == 1 && innerStart >= 0 && innerEnd < 0) innerEnd = j;
            }
            if (depth == 0 && innerStart >= 0) break;
        }
        if (innerStart < 0 || innerEnd < 0) return false;

        // inner: a * b
        // Find '*' at depth 0 within inner
        int mulIdx = -1;
        int innerDepth = 0;
        for (int j = innerStart; j < innerEnd; j++)
        {
            if (tokens[j].Type == TokenType.LParen) innerDepth++;
            if (tokens[j].Type == TokenType.RParen) innerDepth--;
            if (innerDepth == 0 && tokens[j].Type == TokenType.Op && tokens[j].Text == "*")
            {
                mulIdx = j;
                break;
            }
        }
        if (mulIdx < 0) return false;

        string aExpr = TokensToText(tokens, innerStart, mulIdx);
        string bExpr = TokensToText(tokens, mulIdx + 1, innerEnd);

        if (!TryParseMatrixTerm(aExpr, out MatrixTerm ta)) return false;
        if (!TryParseMatrixTerm(bExpr, out MatrixTerm tb)) return false;

        MatrixTerm aTerm, mTerm;
        if (IsSplat(ta.Swizzle) && tb.Swizzle.StartsWith("xyz")) { aTerm = ta; mTerm = tb; }
        else if (IsSplat(tb.Swizzle) && ta.Swizzle.StartsWith("xyz")) { aTerm = tb; mTerm = ta; }
        else return false;
        if (aTerm.Index != r || mTerm.Index is < 0 or > 3) return false;

        var pairs = new Dictionary<char, int> { [aTerm.Swizzle[0]] = mTerm.Index };

        // Parse next 3 mad lines
        for (int v = 2; v <= 4; v++)
        {
            var madTokens = Tokenize(lines[start + v - 1]);
            // Expected: float3 <T><r>_xyz_<v> = ( mad( m1, m2, acc ) ).xyz ;
            int madEq = -1;
            for (int j = 0; j < madTokens.Length; j++)
                if (madTokens[j].Type == TokenType.Op && madTokens[j].Text == "=")
                { madEq = j; break; }
            if (madEq < 0) return false;

            // LHS
            if (madEq < 2) return false;
            if (madTokens[0].Text != "float3") return false;
            string madLhs = madTokens[1].Text;
            if (!madLhs.EndsWith($"_xyz_{v}")) return false;
            string madTBase = madLhs[..^$"_xyz_{v}".Length];
            if (madTBase.Length == 0) return false;
            char madRow = madTBase[^1];
            if (madRow - '0' != r) return false;
            string madT = madTBase[..^1];
            if (madT != t) return false;

            // RHS: ( mad( m1, m2, acc ) ).xyz ;
            int madRhsStart = madEq + 1;
            while (madRhsStart < madTokens.Length && madTokens[madRhsStart].Type == TokenType.Op)
                madRhsStart++;

            // Find mad( ... )
            // Look for "mad" then "("
            int madFnIdx = -1;
            for (int j = madRhsStart; j < madTokens.Length; j++)
            {
                if (madTokens[j].Type == TokenType.Ident && madTokens[j].Text == "mad" &&
                    j + 1 < madTokens.Length && madTokens[j + 1].Type == TokenType.LParen)
                {
                    madFnIdx = j + 1; // points to the LParen
                    break;
                }
            }
            if (madFnIdx < 0) return false;

            // Find matching RParen for mad(
            int madDepth = 0;
            int madRparen = -1;
            for (int j = madFnIdx; j < madTokens.Length; j++)
            {
                if (madTokens[j].Type == TokenType.LParen) madDepth++;
                if (madTokens[j].Type == TokenType.RParen)
                {
                    madDepth--;
                    if (madDepth == 0) { madRparen = j; break; }
                }
            }
            if (madRparen < 0) return false;

            // Inside mad: m1, m2, acc
            // Find commas at depth 1
            var madArgs = new List<int>(); // start indices of each arg
            int argStart = madFnIdx + 1;
            int commaCount = 0;
            int argDepth = 0;
            for (int j = madFnIdx + 1; j < madRparen; j++)
            {
                if (madTokens[j].Type == TokenType.LParen) argDepth++;
                if (madTokens[j].Type == TokenType.RParen) argDepth--;
                if (argDepth == 0 && madTokens[j].Type == TokenType.Comma)
                {
                    madArgs.Add(argStart);
                    argStart = j + 1;
                    commaCount++;
                }
            }
            madArgs.Add(argStart);
            if (madArgs.Count != 3) return false;

            string m1Expr = GatherArg(madTokens, madArgs[0], madRparen);
            string m2Expr = GatherArg(madTokens, madArgs[1], madRparen);
            string accExpr = GatherArg(madTokens, madArgs[2], madRparen);

            // accExpr should be <T><r>_xyz_<v-1>
            string expectedAcc = $"{t}{r}_xyz_{v - 1}";
            if (accExpr.Trim() != expectedAcc) return false;

            if (!TryParseMatrixTerm(m1Expr.Trim(), out MatrixTerm t1)) return false;
            if (!TryParseMatrixTerm(m2Expr.Trim(), out MatrixTerm t2)) return false;

            MatrixTerm a2, m2;
            if (IsSplat(t1.Swizzle) && t2.Swizzle.StartsWith("xyz")) { a2 = t1; m2 = t2; }
            else if (IsSplat(t2.Swizzle) && t1.Swizzle.StartsWith("xyz")) { a2 = t2; m2 = t1; }
            else return false;
            if (a2.Matrix != aTerm.Matrix || a2.Index != aTerm.Index ||
                m2.Matrix != mTerm.Matrix || m2.Index is < 0 or > 3)
                return false;
            pairs[a2.Swizzle[0]] = m2.Index;
        }

        if (pairs.Count != 4) return false;
        foreach (var (c, k) in pairs)
        {
            int expected = c switch { 'x' => 0, 'y' => 1, 'z' => 2, 'w' => 3, _ => -1 };
            if (k != expected) return false;
        }

        prefix = t;
        aMat = aTerm.Matrix;
        mMat = mTerm.Matrix;
        return true;
    }

    private static string GatherArg(Token[] tokens, int startIdx, int endIdx)
    {
        var sb = new StringBuilder();
        int depth = 0;
        for (int i = startIdx; i < endIdx; i++)
        {
            if (tokens[i].Type == TokenType.Comma && depth == 0)
                break;
            if (tokens[i].Type == TokenType.LParen) depth++;
            if (tokens[i].Type == TokenType.RParen) depth--;
            if (sb.Length > 0 && NeedsSpace(tokens[i - 1], tokens[i]))
                sb.Append(' ');
            sb.Append(tokens[i].Text);
        }
        return sb.ToString();
    }

    private static bool TryParseMatrixTerm(string s, out MatrixTerm term)
    {
        // Expected: <matrix>[<index>].<swizzle>
        var tokens = Tokenize(s);
        term = default;
        if (tokens.Length < 5) return false;
        // ident [ number ] . ident
        if (tokens[0].Type != TokenType.Ident) return false;
        if (tokens[1].Type != TokenType.LBracket) return false;
        if (tokens[2].Type != TokenType.Number) return false;
        if (tokens[3].Type != TokenType.RBracket) return false;
        if (tokens[4].Type != TokenType.Dot) return false;
        if (tokens.Length < 6 || tokens[5].Type != TokenType.Ident) return false;
        string matrix = tokens[0].Text;
        if (!int.TryParse(tokens[2].Text, out int index)) return false;
        string swizzle = tokens[5].Text;
        term = new MatrixTerm(matrix, index, swizzle);
        return true;
    }

    // ==================== Math idiom simplification ====================

}
