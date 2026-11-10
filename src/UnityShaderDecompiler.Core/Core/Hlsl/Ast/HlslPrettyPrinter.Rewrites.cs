using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;
using UnityShaderDecompiler.Core.DXBC.Chunks;
using UnityShaderDecompiler.Core.DXBC.Instructions;
using UnityShaderDecompiler.Core.DXBC.IR;
using UnityShaderDecompiler.Core.Analysis;
using UnityShaderDecompiler.Core.DXBC.Metadata;

namespace UnityShaderDecompiler.Core.Hlsl.Ast;

// Stage 13 rewrite helpers: temp fusion, macro reversion, and the
// clip-space / object-to-world pattern collapses that turn raw SSA
// statement text back into readable expressions.
public static partial class HlslPrettyPrinter
{
    // Collapses runs of consecutive single-component extracts that render the
    // SAME full-width RHS, e.g.
    //
    //     float r1_x_9 = (t2.Sample(s0, float4(...))).x;
    //     float r1_y_10 = (t2.Sample(s0, float4(...))).y;
    //     float r1_z_9 = (t2.Sample(s0, float4(...))).z;
    //     float r1_w_3 = (t2.Sample(s0, float4(...))).w;
    //
    // into
    //
    //     float4 r1_xyzw_9 = t2.Sample(s0, float4(...));
    //     float r1_x_9 = r1_xyzw_9.x;
    //     float r1_y_10 = r1_xyzw_9.y;
    //     float r1_z_9 = r1_xyzw_9.z;
    //     float r1_w_3 = r1_xyzw_9.w;
    //
    // This is strictly faithful: every extract computed the identical value
    // (the rendered RHS is textually the same), the lanes are the destination
    // register's own lanes (same base name), and the bytecode holds the value
    // in one register — one materialization + lane reads is what the source
    // instructions actually did. The temp is named after the destination
    // register's first lane version (r1_xyzw_9); a name collision with a real
    // co-write of the same register is impossible going forward (versions only
    // increase, and a shared co-write version exceeds every lane's) and is
    // skipped if an earlier declaration already owns it.
    private static readonly System.Text.RegularExpressions.Regex ExtractChainPattern =
        new(@"^(?<decl>float )?(?<dest>[A-Za-z_][A-Za-z0-9_]*_[xyzw](?:_[0-9]+)?) = \((?<expr>.+)\)\.(?<comp>[xyzw]);$");

    private static List<string> CollapseExtractChains(List<string> lines, PrintContext ctx)
    {
        var result = new List<string>(lines.Count);
        int i = 0;
        while (i < lines.Count)
        {
            System.Text.RegularExpressions.Match m = ExtractChainPattern.Match(lines[i]);
            // A chain-eligible line must re-render a "heavy" RHS (a call or
            // constructor) — a bare register read extract (E = "r4_xyzw_5")
            // has no `(` and is left alone (it is already as compact as the
            // direct resolve would be).
            if (!m.Success || !m.Groups["expr"].Value.Contains('('))
            {
                result.Add(lines[i]);
                i++;
                continue;
            }

            int j = i + 1;
            while (j < lines.Count)
            {
                System.Text.RegularExpressions.Match m2 = ExtractChainPattern.Match(lines[j]);
                if (!m2.Success || m2.Groups["expr"].Value != m.Groups["expr"].Value)
                    break;
                j++;
            }

            if (j - i < 2)
            {
                result.Add(lines[i]);
                i++;
                continue;
            }

            // Only collapse when every lane writes the same base register
            // (r1_x_9, r1_y_10, ... all from r1) so the temp name is the
            // register's own and the reads are plain lane swizzles.
            string baseName = ExtractChainPattern.Match(lines[i]).Groups["dest"].Value;
            bool sameBase = true;
            for (int k = i + 1; k < j; k++)
            {
                string other = ExtractChainPattern.Match(lines[k]).Groups["dest"].Value;
                if (LaneBaseName(other) != LaneBaseName(baseName))
                {
                    sameBase = false;
                    break;
                }
            }
            if (!sameBase)
            {
                result.Add(lines[i]);
                i++;
                continue;
            }

            string temp = TempName(baseName, ctx);
            if (temp is null)
            {
                result.Add(lines[i]);
                i++;
                continue;
            }
            ctx.Declared.Add(temp);

            result.Add($"float4 {temp} = {m.Groups["expr"].Value};");
            for (int k = i; k < j; k++)
            {
                System.Text.RegularExpressions.Match mk = ExtractChainPattern.Match(lines[k]);
                string decl = mk.Groups["decl"].Success ? "float " : "";
                result.Add($"{decl}{mk.Groups["dest"].Value} = {temp}.{mk.Groups["comp"].Value};");
            }
            i = j;
        }

        return result;
    }

    private static string LaneBaseName(string laneName) =>
        System.Text.RegularExpressions.Regex.Replace(laneName, @"_[xyzw](?:_[0-9]+)?$", "");

    private static string? TempName(string dest, PrintContext ctx)
    {
        // dest is a single-lane name like "r1_x_9" or "r1_x".
        string bare = LaneBaseName(dest);
        string version = System.Text.RegularExpressions.Regex.Match(dest, @"_([xyzw])_([0-9]+)$") is { Success: true } m
            ? m.Groups[2].Value
            : "";
        string candidate = version.Length > 0 ? $"{bare}_xyzw_{version}" : $"{bare}_xyzw";
        return ctx.Declared.Contains(candidate) ? null : candidate;
    }

    // ---------- Unity source-macro reversion ----------
    //
    // The Unity `UnityObjectToClipPos(v)` idiom is `mul(UNITY_MATRIX_MVP, v)`,
    // which the D3D compiler emits as a row-by-row mad chain:
    //
    //     float4 clipPos_xyzw_2 = mad(unity_MatrixVP[0], X.xxxx, (X.yyyy * unity_MatrixVP[1]));
    //     float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], X.zzzz, clipPos_xyzw_2);
    //     o.sv_Position0.xyzw = mad(unity_MatrixVP[3], X.wwww, clipPos_xyzw_3);
    //
    // (or fully inlined into one line, or ending in a temp that is copied to
    // the output). Recognized and reverted to:
    //
    //     o.sv_Position0.xyzw = UnityObjectToClipPos(X);
    //
    // with `#define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)` emitted
    // ahead of the body, so the reversion reproduces the bytecode's matrix
    // multiply exactly. Guards are strict — every row {0,1,2,3} used exactly
    // once, each multiplied by the matching single lane of the SAME source
    // register, all chain temps single-use, nothing else in the expression —
    // and any doubt leaves the statements untouched.
    private static readonly System.Text.RegularExpressions.Regex ClipPosOutLine =
        new(@"^o\.sv_Position0\.xyzw = (.+);$");
    private static readonly System.Text.RegularExpressions.Regex TempDefLine =
        new(@"^float4 (\w+) = (.+);$");
    private static readonly System.Text.RegularExpressions.Regex RowRead =
        new(@"^([A-Za-z_][A-Za-z0-9_]*)\[([0-9]+)\](\.[xyzw]+)?$");
    private static readonly System.Text.RegularExpressions.Regex ObjectToWorldRowRead =
        new(@"^unity_ObjectToWorld\[([0-9]+)\]$");
    private static readonly System.Text.RegularExpressions.Regex LaneSplat =
        new(@"^([A-Za-z_][A-Za-z0-9_]*(\.[A-Za-z_][A-Za-z0-9_]*)?)\.([xyzw])\3\3\3$");
    private static readonly System.Text.RegularExpressions.Regex SimpleIdentifier =
        new(@"^[A-Za-z_][A-Za-z0-9_]*$");
    private static readonly System.Text.RegularExpressions.Regex SimpleSource =
        new(@"^[A-Za-z_][A-Za-z0-9_]*(\.[A-Za-z_][A-Za-z0-9_]*)?$");
    // `LHS = (mad(unity_ObjectToWorld[3].xyzx, SRC.wwww, T.xyzx)).xyz;` — a
    // re-derivation of the translation-add tail. Since the chain's final add is
    // bare (SRC.w folded to 1), this equals `LHS = <final>.xyz;`.
    private static readonly System.Text.RegularExpressions.Regex RecomputeLine =
        new(@"^(?<lhs>[^=]+?) = \(mad\(unity_ObjectToWorld\[3\]\.xyzx, (?<src>[^,]+?)\.wwww, (?<t>[^,]+?)\.xyzx\)\)\.xyz;$");
    // `float r0_y_20 = ((float4(1, 1, 1, 1) / r0_y_19)).y;` — a scalar
    // reciprocal. When the denominator is `mad(_ZBufferParams.*, z,
    // _ZBufferParams.*)` the pair is exactly Unity's LinearEyeDepth(z) =
    // 1/(_ZBufferParams.z*z + _ZBufferParams.w) or Linear01Depth(z) =
    // 1/(_ZBufferParams.x*z + _ZBufferParams.y).
    private static readonly System.Text.RegularExpressions.Regex ScalarTempDefLine =
        new(@"^float (\w+) = (.+);$");
    private static readonly System.Text.RegularExpressions.Regex ScalarReciprocalLine =
        new(@"^float (?<dst>\w+) = \(\(float4\(1, 1, 1, 1\) / (?<den>.+)\)\)\.(?<lane>[xyzw]);$");
    private static readonly System.Text.RegularExpressions.Regex DepthZBufParam =
        new(@"^_ZBufferParams\.(?<c>[xyzw])$");

    private static List<string> RevertUnityMacros(List<string> lines, PrintContext ctx)
    {
        if (lines.Count < 2)
            return lines;

        var result = new List<string>(lines.Count);
        var rewrites = new Dictionary<string, string>();
        int i = 0;
        while (i < lines.Count)
        {
            // A translation-tail re-derivation flagged by an earlier worldPos
            // collapse: `LHS = ... T.xyzx ... .xyz` → `LHS = final.xyz`.
            if (rewrites.TryGetValue(lines[i], out var rewrite))
            {
                result.Add(rewrite);
                i++;
                continue;
            }

            var outMatch = ClipPosOutLine.Match(lines[i]);
            if (outMatch.Success && TryCollapseClipTransform(lines, outMatch.Groups[1].Value, i, out var clipReplacement, out var usedTemps, out var canDeleteTemps))
            {
                if (clipReplacement is not null)
                {
                    if (clipReplacement.Contains("UnityObjectToClipPos", StringComparison.Ordinal))
                        ctx.Macros.Add("UnityObjectToClipPos");

                    // Chain temps that are single-use are now dead — remove their
                    // def lines from the tail of the run. Shared temps stay (their
                    // other consumers still need them).
                    if (canDeleteTemps)
                    {
                        for (int k = result.Count - 1; k >= 0; k--)
                        {
                            var t = TempDefLine.Match(result[k]);
                            if (!t.Success || !usedTemps.Contains(t.Groups[1].Value))
                                break;
                            result.RemoveAt(k);
                        }
                    }
                    result.Add(clipReplacement);
                    i++;
                    continue;
                }
            }

            // LinearEyeDepth / Linear01Depth: `float D = 1/(_ZBufferParams.* z
            // + _ZBufferParams.*);`. The denominator is either the mad inline or
            // a temp whose def sits directly above.
            var recipMatch = ScalarReciprocalLine.Match(lines[i]);
            if (recipMatch.Success)
            {
                string dst = recipMatch.Groups["dst"].Value;
                string den = recipMatch.Groups["den"].Value.Trim();
                if (TryParseDepthDenominator(den, out var depthSrc, out var depthMacro))
                {
                    result.Add($"float {dst} = {depthMacro}({depthSrc});");
                    ctx.Macros.Add(depthMacro);
                    i++;
                    continue;
                }
                if (SimpleIdentifier.IsMatch(den) && result.Count > 0)
                {
                    var defMatch = ScalarTempDefLine.Match(result[^1]);
                    if (defMatch.Success
                        && defMatch.Groups[1].Value == den
                        && TryParseDepthDenominator(defMatch.Groups[2].Value, out depthSrc, out depthMacro))
                    {
                        // Safe to drop the temp def only when it feeds nothing
                        // else in the run; shared temps stay for their other
                        // consumers and the reciprocal alone is rewritten.
                        if (CountTokenOccurrences(lines, den) <= 2)
                            result.RemoveAt(result.Count - 1);
                        result.Add($"float {dst} = {depthMacro}({depthSrc});");
                        ctx.Macros.Add(depthMacro);
                        i++;
                        continue;
                    }
                }
            }

            // UnityObjectToWorldPos: `float4 W = <mul chain over xyz> + unity_ObjectToWorld[3];`
            var worldMatch = TempDefLine.Match(lines[i]);
            if (worldMatch.Success && TryCollapseObjectToWorldPos(lines, worldMatch.Groups[2].Value, i, worldMatch.Groups[1].Value, out var worldSrc, out var worldTemps, out var worldRewrites))
            {
                ctx.Macros.Add("UnityObjectToWorldPos");
                foreach (var kv in worldRewrites)
                    rewrites[kv.Key] = kv.Value;
                for (int k = result.Count - 1; k >= 0; k--)
                {
                    var t = TempDefLine.Match(result[k]);
                    if (!t.Success || !worldTemps.Contains(t.Groups[1].Value))
                        break;
                    result.RemoveAt(k);
                }
                result.Add($"float4 {worldMatch.Groups[1].Value} = UnityObjectToWorldPos({worldSrc}.xyz);");
                i++;
                continue;
            }

            result.Add(lines[i]);
            i++;
        }
        return result;
    }

    // Returns true and sets replacement (plus whether its chain temps may be
    // deleted) when lines[i] (o.sv_Position0.xyzw = E;) is a pure 4x4
    // matrix·vector row-sum over the SAME vector register X:
    //
    //     Σ row[k] * X.<lane of (k - base)>   (rows consecutive, one per lane)
    //
    // where row[k] is a whole cbuffer row read — unity_MatrixVP[k] or a
    // synthesized cbN_values[k] (the RDEF-less fallback that names rows only
    // by slot). When the matrix is unity_MatrixVP and every chain temp is
    // single-use, the chain reverts to UnityObjectToClipPos(X) exactly as the
    // original Unity source wrote it. Any other cbuffer name, or a shared
    // chain temp, still collapses to the plain mul(float4x4(rows), X) — the
    // same math regrouped, keeping the chain statements for their other
    // consumers. Guards are strict — every row {base..base+3} used exactly
    // once, each multiplied by the matching single lane of the SAME source
    // register, all rows from the SAME cbuffer array, nothing else in the
    // expression — and any doubt leaves the statements untouched.
    private static bool TryCollapseClipTransform(List<string> lines, string rhs, int i, out string? replacement, out HashSet<string> usedTemps, out bool canDelete)
    {
        replacement = null;
        usedTemps = new HashSet<string>();
        canDelete = false;

        // Build the map of float4 temp defs directly above the final line.
        var temps = new Dictionary<string, (string Expr, int Line)>();
        for (int k = i - 1; k >= 0; k--)
        {
            var td = TempDefLine.Match(lines[k]);
            if (!td.Success)
                break;
            temps[td.Groups[1].Value] = (td.Groups[2].Value, k);
        }

        var terms = new List<(string Name, int Row, string Src, char Lane)>();
        if (!ParseRowSum(rhs, temps, usedTemps, i, terms))
        {
            return false;
        }
        if (terms.Count != 4)
            return false;

        int baseRow = terms.Min(t => t.Row);
        string name = terms[0].Name;
        int[] rows = new int[4];
        string src = "";
        foreach (var (n, row, s, lane) in terms)
        {
            if (n != name)
                return false; // rows of different cbuffer arrays — skip
            int rel = row - baseRow;
            if (rel < 0 || rel > 3)
                return false;
            rows[rel]++;
            // lane letter must match the relative row index (row i * lane i).
            if (lane != "xyzw"[rel])
                return false;
            if (src.Length == 0)
                src = s;
            else if (src != s)
                return false; // lanes of different registers — skip
        }
        if (rows.Any(r => r != 1))
            return false;
        if (!SimpleIdentifier.IsMatch(src))
            return false;

        // Chain temps must be single-use: each must not appear anywhere in the
        // run outside its own definition and the consumed chain lines. When any
        // is shared (e.g. the final clip-position temp also feeding texcoord
        // outputs), the statements stay and only the output line is rewritten.
        canDelete = true;
        foreach (string t in usedTemps)
        {
            if (!temps.TryGetValue(t, out var td))
                return false;
            int total = CountTokenOccurrences(lines, t);
            int inChain = CountTokenOccurrences(lines, td.Line, i, t);
            if (total != inChain)
                canDelete = false;
        }

        string matrix = $"float4x4({name}[{baseRow}], {name}[{baseRow + 1}], {name}[{baseRow + 2}], {name}[{baseRow + 3}])";
        replacement = name == "unity_MatrixVP"
            ? $"o.sv_Position0.xyzw = UnityObjectToClipPos({src});"
            : $"o.sv_Position0.xyzw = mul({matrix}, {src});";
        return true;
    }

    // Parses the denominator of a depth reciprocal. Recognizes Unity's
    // LinearEyeDepth / Linear01Depth expansions in either operand order:
    // mad(_ZBufferParams.z, z, _ZBufferParams.w) == mad(z, _ZBufferParams.z,
    // _ZBufferParams.w). Any other shape — a different cbuffer name, a
    // mismatched pair, extra terms — is left untouched.
    private static bool TryParseDepthDenominator(string den, out string src, out string macroName)
    {
        src = "";
        macroName = "";
        den = den.Trim();
        while (den.StartsWith('(') && den.EndsWith(')'))
            den = den[1..^1].Trim();
        if (!den.StartsWith("mad(") || !den.EndsWith(')'))
            return false;
        List<string> args = SplitTopLevelArgs(den[4..^1]);
        if (args.Count != 3)
            return false;

        int scale = -1, bias = -1;
        string zsrc = "";
        for (int k = 0; k < 3; k++)
        {
            var m = DepthZBufParam.Match(args[k].Trim());
            if (m.Success)
            {
                char c = m.Groups["c"].Value[0];
                if (c is 'x' or 'z') scale = k;
                else bias = k;
            }
            else if (SimpleSource.IsMatch(args[k].Trim()))
                zsrc = args[k].Trim();
            else
                return false;
        }
        if (scale < 0 || bias < 0 || zsrc.Length == 0)
            return false;

        char sc = DepthZBufParam.Match(args[scale].Trim()).Groups["c"].Value[0];
        char bc = DepthZBufParam.Match(args[bias].Trim()).Groups["c"].Value[0];
        if (sc == 'x' && bc == 'y')
            macroName = "Linear01Depth";
        else if (sc == 'z' && bc == 'w')
            macroName = "LinearEyeDepth";
        else
            return false;
        src = zsrc;
        return true;
    }

    // Recursively decomposes a rendered RHS into the set of matrix row terms it
    // adds. Temp reads are inlined from their definitions.
    private static bool ParseRowSum(
        string expr,
        Dictionary<string, (string Expr, int Line)> temps,
        HashSet<string> usedTemps,
        int finalLine,
        List<(string Name, int Row, string Src, char Lane)> terms)
    {
        expr = expr.Trim();
        while (expr.StartsWith('(') && expr.EndsWith(')'))
            expr = expr[1..^1].Trim();

        // A temp accumulation read → inline its definition.
        if (SimpleIdentifier.IsMatch(expr) && temps.TryGetValue(expr, out var td))
        {
            usedTemps.Add(expr);
            return ParseRowSum(td.Expr, temps, usedTemps, finalLine, terms);
        }

        if (expr.StartsWith("mad(") && expr.EndsWith(')'))
        {
            List<string> args = SplitTopLevelArgs(expr[4..^1]);
            if (args.Count != 3)
                return false;
            if (!TryRowTerm(args[0], args[1], out var term))
                return false;
            terms.Add(term);
            return ParseRowSum(args[2], temps, usedTemps, finalLine, terms);
        }

        // A top-level mul is the base row term; a top-level add joins two
        // sub-sums. After paren-stripping the expr is already unparenthesized.
        int op = FindTopLevelOperator(expr);
        if (op < 0)
            return false;
        string left = expr[..op].Trim();
        string right = expr[(op + 1)..].Trim();
        if (expr[op] == '*')
            return TryRowTerm(left, right, out var mulTerm) && AddFinalTerm(mulTerm, terms);
        if (expr[op] == '+')
            return ParseRowSum(left, temps, usedTemps, finalLine, terms)
                && ParseRowSum(right, temps, usedTemps, finalLine, terms);
        return false;
    }

    private static bool AddFinalTerm((string Name, int Row, string Src, char Lane) term, List<(string Name, int Row, string Src, char Lane)> terms)
    {
        terms.Add(term);
        return true;
    }

    private static bool AddObjectToWorldTerm((int Row, string Src, char Lane) term, List<(int Row, string Src, char Lane)> terms)
    {
        terms.Add(term);
        return true;
    }

    // One operand must be a cbuffer row read (unity_MatrixVP[N], cbN_values[N],
    // with an optional full .xyzw suffix) and the other a single-lane splat of a
    // register (X.xxxx) — the row term of a matrix multiply. A partial row
    // swizzle (`.xyz` etc.) means a 3xN product that is not a plain 4x4
    // matrix·vector multiply, so it is rejected here.
    private static bool TryRowTerm(string a, string b, out (string Name, int Row, string Src, char Lane) term)
    {
        term = default;
        if (AsRowTerm(a, b, out term))
            return true;
        return AsRowTerm(b, a, out term);
    }

    private static bool AsRowTerm(string candidate, string other, out (string Name, int Row, string Src, char Lane) term)
    {
        term = default;
        var rowMatch = RowRead.Match(candidate.Trim());
        var laneMatch = LaneSplat.Match(other.Trim());
        if (!rowMatch.Success || !laneMatch.Success)
            return false;

        string swz = rowMatch.Groups[3].Value;
        if (swz.Length > 0 && swz != ".xyzw")
            return false;

        term = (
            rowMatch.Groups[1].Value,
            int.Parse(rowMatch.Groups[2].Value),
            laneMatch.Groups[1].Value,
            laneMatch.Groups[3].Value[0]);
        return true;
    }

    private static List<string> SplitTopLevelArgs(string s)
    {
        var parts = new List<string>();
        int depth = 0;
        var sb = new System.Text.StringBuilder();
        foreach (char c in s)
        {
            if (c is '(' or '[') depth++;
            else if (c is ')' or ']') depth--;
            if (c == ',' && depth == 0) { parts.Add(sb.ToString()); sb.Clear(); }
            else sb.Append(c);
        }
        if (sb.Length > 0) parts.Add(sb.ToString());
        return parts;
    }

    // Index of the top-level '*' or '+' operator in an unparenthesized
    // expression (bracket depth tracked so unity_MatrixVP[1] doesn't count).
    private static int FindTopLevelOperator(string expr)
    {
        int depth = 0;
        for (int k = 0; k < expr.Length; k++)
        {
            char c = expr[k];
            if (c is '(' or '[') depth++;
            else if (c is ')' or ']') depth--;
            else if (depth == 0 && (c is '*' or '+')) return k;
        }
        return -1;
    }

    // Returns true and sets srcName when lines[i] (`float4 NAME = E;`) computes
    // mul(unity_ObjectToWorld, SRC) over lanes x,y,z plus the translation row —
    // Unity's UnityObjectToWorldPos. The bare `+ unity_ObjectToWorld[3]` tail
    // proves the w multiplier folded to the constant 1, so the macro's appended
    // 1.0 reproduces the bytecode exactly.
    private static bool TryCollapseObjectToWorldPos(List<string> lines, string rhs, int i, string finalName, out string srcName, out HashSet<string> usedTemps, out Dictionary<string, string> rewrites)
    {
        srcName = "";
        usedTemps = new HashSet<string>();
        rewrites = new Dictionary<string, string>();

        // Build the map of float4 temp defs directly above the final line.
        var temps = new Dictionary<string, (string Expr, int Line)>();
        for (int k = i - 1; k >= 0; k--)
        {
            var td = TempDefLine.Match(lines[k]);
            if (!td.Success)
                break;
            temps[td.Groups[1].Value] = (td.Groups[2].Value, k);
        }

        var terms = new List<(int Row, string Src, char Lane)>();
        bool hasTranslation = false;
        if (!ParseObjectToWorldSum(rhs, temps, usedTemps, terms, ref hasTranslation))
            return false;
        if (!hasTranslation || terms.Count != 3)
            return false;

        int[] rows = new int[3];
        string src = "";
        foreach (var (row, s, lane) in terms)
        {
            if (row < 0 || row > 2)
                return false;
            rows[row]++;
            // lane letter must match the row index (row i * lane i), and only
            // lanes x,y,z appear — the w row is the folded translation.
            if (lane != "xyz"[row])
                return false;
            if (src.Length == 0)
                src = s;
            else if (src != s)
                return false; // lanes of different registers — skip
        }
        if (rows.Any(r => r != 1))
            return false;
        if (!SimpleSource.IsMatch(src))
            return false;

        // Chain temps must be single-use: each must not appear anywhere in the
        // run outside its own definition and the consumed chain lines — except
        // for a re-derivation of the translation tail (`LHS = ... T.xyzx ...
        // .xyz`), which is equal to `LHS = finalName.xyz` and gets rewritten.
        foreach (string t in usedTemps)
        {
            if (!temps.TryGetValue(t, out var td))
                return false;
            int total = CountTokenOccurrences(lines, t);
            int inChain = CountTokenOccurrences(lines, td.Line, i, t);
            if (total < inChain)
                return false;
            for (int k = 0; k < lines.Count; k++)
            {
                if (k >= td.Line && k <= i)
                    continue;
                int occ = CountTokenOccurrences(lines, k, k, t);
                if (occ == 0)
                    continue;
                if (occ != 1 || !TryParseRecompute(lines[k], t, src, finalName, out var rep))
                    return false;
                rewrites[lines[k]] = rep;
            }
        }

        srcName = src;
        return true;
    }

    // Recognizes a translation-tail re-derivation `LHS = (mad(unity_ObjectToWorld
    // [3].xyzx, SRC.wwww, T.xyzx)).xyz;` and rewrites it to `LHS = <final>.xyz;`.
    private static bool TryParseRecompute(string line, string t, string src, string finalName, out string replacement)
    {
        replacement = "";
        var m = RecomputeLine.Match(line);
        if (!m.Success || m.Groups["t"].Value != t || m.Groups["src"].Value != src)
            return false;
        replacement = $"{m.Groups["lhs"].Value} = {finalName}.xyz;";
        return true;
    }

    // Recursively decomposes a rendered RHS into the set of unity_ObjectToWorld
    // row terms it sums (rows 0..2, lanes x..z) plus the translation tail
    // `+ unity_ObjectToWorld[3]`. Temp reads are inlined from their definitions.
    private static bool ParseObjectToWorldSum(
        string expr,
        Dictionary<string, (string Expr, int Line)> temps,
        HashSet<string> usedTemps,
        List<(int Row, string Src, char Lane)> terms,
        ref bool hasTranslation)
    {
        expr = expr.Trim();
        while (expr.StartsWith('(') && expr.EndsWith(')'))
            expr = expr[1..^1].Trim();

        // A temp accumulation read → inline its definition.
        if (SimpleIdentifier.IsMatch(expr) && temps.TryGetValue(expr, out var td))
        {
            usedTemps.Add(expr);
            return ParseObjectToWorldSum(td.Expr, temps, usedTemps, terms, ref hasTranslation);
        }

        if (expr.StartsWith("mad(") && expr.EndsWith(')'))
        {
            List<string> args = SplitTopLevelArgs(expr[4..^1]);
            if (args.Count != 3)
                return false;
            if (!TryObjectToWorldRowTerm(args[0], args[1], out var term))
                return false;
            terms.Add(term);
            return ParseObjectToWorldSum(args[2], temps, usedTemps, terms, ref hasTranslation);
        }

        // After paren-stripping the expr is already unparenthesized.
        int op = FindTopLevelOperator(expr);
        if (op < 0)
            return false;
        string left = expr[..op].Trim();
        string right = expr[(op + 1)..].Trim();
        if (expr[op] == '*')
            return TryObjectToWorldRowTerm(left, right, out var mulTerm) && AddObjectToWorldTerm(mulTerm, terms);
        if (expr[op] == '+')
        {
            // The translation tail: `... + unity_ObjectToWorld[3]`. A bare add
            // (no w-lane multiplier) is the proof w folded to the constant 1.
            if (right == "unity_ObjectToWorld[3]")
            {
                hasTranslation = true;
                return ParseObjectToWorldSum(left, temps, usedTemps, terms, ref hasTranslation);
            }
            return ParseObjectToWorldSum(left, temps, usedTemps, terms, ref hasTranslation)
                && ParseObjectToWorldSum(right, temps, usedTemps, terms, ref hasTranslation);
        }
        return false;
    }

    // One operand must be a unity_ObjectToWorld row read and the other a
    // single-lane splat of a register (X.xxxx) — the row term of the multiply.
    private static bool TryObjectToWorldRowTerm(string a, string b, out (int Row, string Src, char Lane) term)
    {
        term = default;
        var rowMatch = ObjectToWorldRowRead.Match(a.Trim());
        var laneMatch = LaneSplat.Match(b.Trim());
        if (rowMatch.Success && laneMatch.Success)
        {
            term = (int.Parse(rowMatch.Groups[1].Value), laneMatch.Groups[1].Value, laneMatch.Groups[3].Value[0]);
            return true;
        }
        rowMatch = ObjectToWorldRowRead.Match(b.Trim());
        laneMatch = LaneSplat.Match(a.Trim());
        if (rowMatch.Success && laneMatch.Success)
        {
            term = (int.Parse(rowMatch.Groups[1].Value), laneMatch.Groups[1].Value, laneMatch.Groups[3].Value[0]);
            return true;
        }
        return false;
    }

    private static int CountTokenOccurrences(List<string> lines, string token) =>
        CountTokenOccurrences(lines, 0, lines.Count - 1, token);

    private static int CountTokenOccurrences(List<string> lines, int lo, int hi, string token)
    {
        int count = 0;
        for (int k = lo; k <= hi; k++)
            count += System.Text.RegularExpressions.Regex.Matches(lines[k], $"\\b{token}\\b").Count;
        return count;
    }

}
