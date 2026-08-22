using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace Parser.Core.Hlsl;

internal static class HlslMathSimplify
{
    public static string Simplify(string body)
    {
        body = CollapseScalarLanes(body);
        body = CollapseMatrixMul(body);
        body = SimplifyMathIdioms(body);
        return body;
    }

    // ---------- Scalar-lane collapsing ----------
    //
    // When the bytecode consumes the lanes of a vector individually, the
    // leave-SSA materialization renders the value as a vector temp plus four
    // scalar lane reads:
    //
    //     float4 r5_xyzw_5 = (r4_y_9.xxxx * unity_ObjectToWorld[1]);
    //     float r5_x_5 = r5_xyzw_5.x;
    //     float r5_y_4 = r5_xyzw_5.y;
    //     float r5_z_4 = r5_xyzw_5.z;
    //     float r5_w_1 = r5_xyzw_5.w;
    //     float4 r5_xyzw_6 = mad(unity_ObjectToWorld[0], r4_x_7.xxxx, float4(r5_x_5, r5_y_4, r5_z_4, r5_w_1));
    //
    // Every downstream use of those scalars is equivalent to the same use of
    // the vector's lanes, so when all uses are one of
    //   (a) a float2/3/4(...) constructor whose every argument is a lane of
    //       this vector     -> V.xyzw (or the matching swizzle; plain V when
    //                            the swizzle is the identity xyzw)
    //   (b) a same-lane splat like r5_y_4.xxxx   -> V.yyyy
    //   (c) a bare scalar reference              -> V.y
    // the whole detour collapses: constructors/splats/refs are rewritten and
    // the four split declarations are dropped. Strictly faithful — each case
    // selects exactly the same lanes of the same register. Runs once per
    // function body (temp names repeat across vertex/fragment stages), so
    // uses anywhere in the same body are visible; any unexpected use aborts
    // the whole group and leaves it untouched.
    private static readonly Regex ScalarSplitGroupPattern =
        new(@"^float (?<sx>\w+_x_\d+) = (?<V>\w+_xyzw_\d+)\.x;" +
            @"\nfloat (?<sy>\w+_y_\d+) = \k<V>\.y;" +
            @"\nfloat (?<sz>\w+_z_\d+) = \k<V>\.z;" +
            @"\nfloat (?<sw>\w+_w_\d+) = \k<V>\.w;$");

    private static readonly Regex ScalarCtorPattern =
        new(@"float(?:2|3|4)\(\s*(?<args>[^()]+?)\s*\)");

    private static readonly Regex ScalarNamePattern =
        new(@"\b\w+_[xyzw]_\d+\b");

    private static readonly Regex ScalarSplatPattern =
        new(@"\.[xyzw]+");

    // ---------- Matrix-multiply reconstruction ----------
    //
    // The D3D compiler sometimes scalarizes a 4x4 matrix multiply into an
    // outer-product accumulation, one result row at a time, materializing
    // each row as a separate float3 temp with four mad/mul steps:
    //
    //     float3 objectToView0_xyz_1 = ((unity_ObjectToWorld[0].yyyy * unity_MatrixV[1].xyzx)).xyz;
    //     float3 objectToView0_xyz_2 = (mad(unity_MatrixV[0].xyzx, unity_ObjectToWorld[0].xxxx, objectToView0_xyz_1.xyzx)).xyz;
    //     float3 objectToView0_xyz_3 = (mad(unity_MatrixV[2].xyzx, unity_ObjectToWorld[0].zzzz, objectToView0_xyz_2.xyzx)).xyz;
    //     float3 objectToView0_xyz_4 = (mad(unity_MatrixV[3].xyzx, unity_ObjectToWorld[0].wwww, objectToView0_xyz_3.xyzx)).xyz;
    //     ... rows 1..3 identically ...
    //
    // Row i accumulates Σ_k A[i][k] * M[k].xyz — exactly row i of mul(A, M) —
    // where A is the operand whose row index tracks the result row ([i]) and M
    // is the operand whose row index is summed ([k]). When all four rows are
    // present and consistent, the 16 statements collapse to
    //
    //     float4x4 objectToView = mul(unity_ObjectToWorld, unity_MatrixV);
    //
    // and the four final row temps (version _4, the only ones ever consumed
    // downstream) are rewritten to P[0..3]. Strictly faithful: mul(A,M)[i].xyz
    // selects exactly the same lanes. Guards: A's component swizzle is a splat
    // of one of x/y/z/w, M's swizzle starts with xyz (so the .xyz cast selects
    // the matrix-product components), the (component, M-index) pairs cover
    // exactly {(x,0),(y,1),(z,2),(w,3)}, the same A and M across all rows, and
    // the intermediate row temps (_1.._3) never appear outside the block.
    private static readonly Regex MatrixMulLine =
        new(@"^\s*float3 (?<T>\w+?)(?<r>[0-3])_xyz_1 = \(\((?<a>\S+?) \* (?<b>\S+?)\)\)\.xyz;\s*$");
    private static readonly Regex MatrixMadLine =
        new(@"^\s*float3 (?<T>\w+?)(?<r>[0-3])_xyz_(?<v>[2-4]) = \(mad\((?<m1>\S+?), (?<m2>\S+?), (?<acc>\w+?)\.[xyzw]+\)\)\.xyz;\s*$");
    private static readonly Regex MatrixTermPattern =
        new(@"^(?<m>\w+)\[(?<idx>\d+)\]\.(?<swz>[xyzw]+)$");

    private readonly record struct MatrixTerm(string Matrix, int Index, string Swizzle);

    private static string CollapseScalarLanes(string body)
    {
        // Fixpoint: each single pass collapses the vector->scalar splits whose
        // uses are all clean. A pass that rewrites a scalar-copy chain (e.g.
        // r5_x_6 = r4_x_4 -> r5_x_6 = r4_xyzw_4.x) can leave a fresh 4-line
        // group behind for the next pass, so iterate until stable. Every pass
        // only removes lines and rewrites uses to vector lane reads — the text
        // strictly shrinks, so this terminates.
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
        var drop = new bool[lines.Length];
        var edits = new Dictionary<int, List<(int Start, int Len, string Rep)>>();
        int i = 0;
        while (i + 3 < lines.Length)
        {
            string four = string.Join("\n",
                new[] { lines[i], lines[i + 1], lines[i + 2], lines[i + 3] }.Select(l => l.Trim()));
            Match m = ScalarSplitGroupPattern.Match(four);
            if (!m.Success)
            {
                i++;
                continue;
            }

            string V = m.Groups["V"].Value;
            string sx = m.Groups["sx"].Value, sy = m.Groups["sy"].Value,
                   sz = m.Groups["sz"].Value, sw = m.Groups["sw"].Value;
            var lane = new Dictionary<string, char> { { sx, 'x' }, { sy, 'y' }, { sz, 'z' }, { sw, 'w' } };

            bool clean = true;
            var groupEdits = new List<(int Line, int Start, int Len, string Rep)>();
            for (int k = 0; k < lines.Length && clean; k++)
            {
                if (k >= i && k <= i + 3)
                    continue;
                string t = lines[k];

                // (a) whole-constructor units first, so their args aren't
                // re-processed as bare refs below.
                var covered = new List<(int Start, int Len)>();
                foreach (Match cm in ScalarCtorPattern.Matches(t))
                {
                    string[] args = cm.Groups["args"].Value.Split(',').Select(a => a.Trim()).ToArray();
                    if (args.All(a => lane.ContainsKey(a)))
                    {
                        string swz = string.Concat(args.Select(a => lane[a]));
                        groupEdits.Add((k, cm.Index, cm.Length, swz == "xyzw" ? V : $"{V}.{swz}"));
                        covered.Add((cm.Index, cm.Length));
                    }
                }

                // (b)+(c) individual occurrences.
                foreach (Match nm in ScalarNamePattern.Matches(t))
                {
                    if (!lane.TryGetValue(nm.Value, out char lc))
                        continue;
                    if (covered.Any(c => nm.Index >= c.Start && nm.Index < c.Start + c.Len))
                        continue;

                    int after = nm.Index + nm.Value.Length;
                    if (after < t.Length && t[after] == '.')
                    {
                        Match sm = ScalarSplatPattern.Match(t, after);
                        if (!sm.Success || sm.Index != after)
                        {
                            clean = false;
                            break;
                        }
                        string suffix = sm.Value.Substring(1);
                        if (suffix.Any(c => c != suffix[0]))
                        {
                            clean = false; // mixed swizzle on a scalar — not a clean lane splat
                            break;
                        }
                        groupEdits.Add((k, nm.Index, sm.Index + sm.Length - nm.Index, $"{V}.{new string(lc, suffix.Length)}"));
                    }
                    else if (after < t.Length &&
                             (char.IsLetterOrDigit(t[after]) || t[after] == '_' || t[after] == '[' || t[after] == '('))
                    {
                        clean = false; // unexpected attachment — leave the group alone
                        break;
                    }
                    else
                    {
                        groupEdits.Add((k, nm.Index, nm.Value.Length, $"{V}.{lc}"));
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

        var sb = new StringBuilder(body.Length);
        bool first = true;
        for (int k = 0; k < lines.Length; k++)
        {
            if (drop[k])
                continue;
            // Skip the empty element produced by the input's trailing '\n';
            // it is restored below so the output's line structure matches.
            if (k == lines.Length - 1 && lines[k].Length == 0)
                continue;
            string line = lines[k];
            if (edits.TryGetValue(k, out var list))
                foreach ((int st, int ln, string rep) in list.OrderByDescending(e => e.Start))
                    line = line.Substring(0, st) + rep + line.Substring(st + ln);
            if (!first)
                sb.Append('\n');
            sb.Append(line);
            first = false;
        }
        if (body.Length > 0 && body[body.Length - 1] == '\n')
            sb.Append('\n');
        return sb.ToString();
    }

    // Whole-function matrix-multiply reconstruction: collapse the 4x4 outer-
    // product accumulation blocks (16 statements) into `float4x4 P = mul(A,M);`
    // and rewrite the final row temps P{i}_xyz_4 to P[i]. See the pattern
    // documentation above the MatrixMulLine regex for the exact shape and the
    // faithfulness argument. Scans every 16-line window; a block that fails any
    // guard is left untouched.
    private static string CollapseMatrixMul(string body)
    {
        string[] lines = body.Split('\n');
        var drop = new bool[lines.Length];
        var insert = new Dictionary<int, string>();
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
            // and at least one final (_4) row must be, or the collapse is dead.
            string intermediatePattern = $@"(?<!\w){Regex.Escape(prefix)}[0-3]_xyz_[123](?!\w)";
            string finalPattern = $@"(?<!\w){Regex.Escape(prefix)}[0-3]_xyz_4(?!\w)";
            bool clean = true;
            bool anyUse = false;
            for (int k = 0; k < lines.Length && clean; k++)
            {
                if (k >= i && k < i + 16)
                    continue;
                if (Regex.IsMatch(lines[k], intermediatePattern))
                {
                    clean = false;
                    break;
                }
                if (Regex.IsMatch(lines[k], finalPattern))
                    anyUse = true;
            }
            if (!clean || !anyUse)
            {
                i++;
                continue;
            }

            for (int r = 0; r < 4; r++)
                for (int v = 1; v <= 4; v++)
                    drop[i + r * 4 + v - 1] = true;

            string indent = new(lines[i].TakeWhile(char.IsWhiteSpace).ToArray());
            insert[i] = $"{indent}float4x4 {prefix} = mul({aMat}, {mMat});";
            for (int r = 0; r < 4; r++)
                renames.Add(($"{prefix}{r}_xyz_4", $"{prefix}[{r}]"));
            i += 16;
        }

        if (!drop.Any(d => d))
            return body;

        var sb = new StringBuilder(body.Length);
        bool first = true;
        for (int k = 0; k < lines.Length; k++)
        {
            if (drop[k])
            {
                if (insert.TryGetValue(k, out string decl))
                    AppendBodyLine(sb, ref first, decl);
                continue;
            }
            if (k == lines.Length - 1 && lines[k].Length == 0)
                continue;
            string line = lines[k];
            foreach ((string old, string neu) in renames)
                line = Regex.Replace(line, $@"(?<!\w){Regex.Escape(old)}(?!\w)", neu);
            AppendBodyLine(sb, ref first, line);
        }
        if (body.Length > 0 && body[body.Length - 1] == '\n')
            sb.Append('\n');
        return sb.ToString();
    }

    private static void AppendBodyLine(StringBuilder sb, ref bool first, string line)
    {
        if (!first)
            sb.Append('\n');
        sb.Append(line);
        first = false;
    }

    // Parses the 4-row × 4-statement block at lines[start..start+15] as a
    // mul(A, M) accumulation. On success sets the shared prefix (result-matrix
    // name) and the two matrix operands.
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

    // Parses one result row: the bare-mul statement (the seed term, one
    // (component, M-index) pair) plus the three mad accumulations. Row i must
    // be A[i].{splat} * M[k].xyz, summed over k = 0..3, with the A-operand the
    // one whose matrix index equals the row index.
    private static bool TryParseMatrixRow(string[] lines, int start, int r, out string prefix, out string aMat, out string mMat)
    {
        prefix = aMat = mMat = "";
        Match mul = MatrixMulLine.Match(lines[start]);
        if (!mul.Success)
            return false;
        string t = mul.Groups["T"].Value;
        if (!TryParseMatrixTerm(mul.Groups["a"].Value, out MatrixTerm ta) ||
            !TryParseMatrixTerm(mul.Groups["b"].Value, out MatrixTerm tb))
            return false;

        // A's operand is a single-component splat (xxxx/yyyy/zzzz/wwww), M's is
        // a multi-component one starting with xyz. Classify by swizzle shape,
        // NOT by matrix index: the summed index k can equal the row index r
        // (row 0 sums M[0]), so the index alone is ambiguous.
        MatrixTerm a, m;
        if (IsSplat(ta.Swizzle) && tb.Swizzle.StartsWith("xyz")) { a = ta; m = tb; }
        else if (IsSplat(tb.Swizzle) && ta.Swizzle.StartsWith("xyz")) { a = tb; m = ta; }
        else
            return false;
        if (a.Index != r || m.Index is < 0 or > 3)
            return false;

        var pairs = new Dictionary<char, int> { [a.Swizzle[0]] = m.Index };
        for (int v = 2; v <= 4; v++)
        {
            Match mad = MatrixMadLine.Match(lines[start + v - 1]);
            if (!mad.Success)
                return false;
            if (mad.Groups["T"].Value != t || mad.Groups["r"].Value != r.ToString() ||
                mad.Groups["v"].Value != v.ToString() ||
                mad.Groups["acc"].Value != $"{t}{r}_xyz_{v - 1}")
                return false;
            if (!TryParseMatrixTerm(mad.Groups["m1"].Value, out MatrixTerm t1) ||
                !TryParseMatrixTerm(mad.Groups["m2"].Value, out MatrixTerm t2))
                return false;

            MatrixTerm a2, m2;
            if (IsSplat(t1.Swizzle) && t2.Swizzle.StartsWith("xyz")) { a2 = t1; m2 = t2; }
            else if (IsSplat(t2.Swizzle) && t1.Swizzle.StartsWith("xyz")) { a2 = t2; m2 = t1; }
            else
                return false;
            if (a2.Matrix != a.Matrix || a2.Index != a.Index ||
                m2.Matrix != m.Matrix || m2.Index is < 0 or > 3)
                return false;
            pairs[a2.Swizzle[0]] = m2.Index;
        }

        if (pairs.Count != 4)
            return false;
        foreach (var (c, k) in pairs)
        {
            int expected = c switch { 'x' => 0, 'y' => 1, 'z' => 2, 'w' => 3, _ => -1 };
            if (k != expected)
                return false;
        }

        prefix = t;
        aMat = a.Matrix;
        mMat = m.Matrix;
        return true;
    }

    private static bool TryParseMatrixTerm(string s, out MatrixTerm term)
    {
        Match m = MatrixTermPattern.Match(s);
        if (!m.Success)
        {
            term = default;
            return false;
        }
        term = new MatrixTerm(m.Groups["m"].Value, int.Parse(m.Groups["idx"].Value), m.Groups["swz"].Value);
        return true;
    }

    private static bool IsSplat(string swz) =>
        swz.Length == 4 && swz.All(c => c == swz[0]);

    // float4(x, x, x, x) with x a scalar stays as-is: d3dcompiler's strict
    // mode rejects the single-argument broadcast form float4(x) (X3014:
    // "incorrect number of arguments"), so there is no shorter faithful form.

    // ---------- Math idiom simplification ----------
    // Recognises common multi-line patterns in the rendered HLSL and
    // replaces them with shorter equivalent calls (normalize, dot, lerp,
    // saturate, mul).  Each sub-pass is a whole-function regex scan.

    private static string SimplifyMathIdioms(string body)
    {
        string[] lines = body.Split('\n');
        var drop = new bool[lines.Length];
        var replacements = new Dictionary<int, string>();
        var renames = new List<(string Old, string New)>();

        SimplifyNormalizes(lines, drop, replacements, renames);
        SimplifyDotProducts(lines, drop, replacements, renames);
        SimplifyLerps(lines, drop, replacements, renames);
        SimplifyVectorMatrixMuls(lines, drop, replacements, renames);

        if (!drop.Any(d => d) && replacements.Count == 0 && renames.Count == 0)
            return body;

        var sb = new StringBuilder(body.Length);
        bool first = true;
        for (int k = 0; k < lines.Length; k++)
        {
            if (drop[k])
            {
                if (replacements.TryGetValue(k, out string? repl))
                    AppendBodyLine(sb, ref first, repl);
                continue;
            }
            if (k == lines.Length - 1 && lines[k].Length == 0)
                continue;
            string line = lines[k];
            foreach ((string old, string neu) in renames)
                line = Regex.Replace(line, $@"(?<!\w){Regex.Escape(old)}(?!\w)", neu);
            AppendBodyLine(sb, ref first, line);
        }
        if (body.Length > 0 && body[body.Length - 1] == '\n')
            sb.Append('\n');
        return sb.ToString();
    }

    // Pattern: float T = dot(v, v); float T2 = rsqrt(T); floatN result = (T2.xxx * v...).swz;
    // → floatN result = normalize(v);
    private static void SimplifyNormalizes(string[] lines, bool[] drop,
        Dictionary<int, string> replacements, List<(string Old, string New)> renames)
    {
        // Match full line: float <dr> = dot(<anything>, <anything>);
        // We parse the dot args manually to handle nested parens like float4(...).
        var linePat = new Regex(@"^\s*float\s+(?<dr>\w+)\s*=\s*dot\((?<rest>.+)\)\s*;\s*$");

        for (int i = 0; i + 2 < lines.Length; i++)
        {
            if (drop[i] || drop[i + 1] || drop[i + 2])
                continue;

            Match mLine = linePat.Match(lines[i]);
            if (!mLine.Success) continue;
            string dr = mLine.Groups["dr"].Value;
            string rest = mLine.Groups["rest"].Value;

            // Split on comma at nesting depth 0 to get the two dot args
            string? a = null, b = null;
            int depth = 0;
            int split = -1;
            for (int j = 0; j < rest.Length; j++)
            {
                if (rest[j] == '(') depth++;
                else if (rest[j] == ')') depth--;
                else if (rest[j] == ',' && depth == 0) { split = j; break; }
            }
            if (split < 0) continue;
            a = rest[..split].Trim();
            b = rest[(split + 1)..].Trim();

            // Self-dot check: a and b must be the same expression
            if (a != b) continue;

            string escDr = Regex.Escape(dr);
            // Match: float <rsqrtResult> = rsqrt(<dotResult>);
            var rsqrtRe = new Regex($@"^\s*float\s+(?<rsr>\w+)\s*=\s*rsqrt\({escDr}\)\s*;\s*$");
            Match mRsqrt = rsqrtRe.Match(lines[i + 1]);
            if (!mRsqrt.Success) continue;
            string rsr = mRsqrt.Groups["rsr"].Value;

            // Match: floatN <result> = ((<rsqrtResult>.xxxx * vec...)).swz;  OR  (rsr.xxxx * vec...)  OR  rsr.xxxx * vec...
            // The vec is either a simple variable (possibly with swizzle) or a float4(...) constructor.
            string escRsr = Regex.Escape(rsr);
            var mulRe = new Regex($@"^\s*float(?<dims>[234])\s+(?<res>\w+)\s*=\s*\(*\(?{escRsr}\.xxxx\s*\*\s*(?<vec>\w+(?:\([^)]*\))?(?:\.\w+)?)\)+(?:\.\w+)?\s*;\s*$");
            Match mMul = mulRe.Match(lines[i + 2]);
            if (!mMul.Success) continue;

            string resName = mMul.Groups["res"].Value;
            string vecRaw = mMul.Groups["vec"].Value.Trim();
            string vec;
            if (vecRaw.StartsWith("float4(") && vecRaw.EndsWith(")"))
            {
                // Already a complete float4(...) constructor — use as-is
                vec = vecRaw;
            }
            else if (vecRaw.Contains('('))
            {
                var parts = ExtractComponents(vecRaw);
                vec = "float4(" + string.Join(", ", parts) + ")";
            }
            else
            {
                vec = vecRaw.Split('.')[0];
            }
            string indent = new string(lines[i].TakeWhile(char.IsWhiteSpace).ToArray());

            drop[i] = true;
            drop[i + 1] = true;
            drop[i + 2] = true;
            replacements[i] = $"{indent}float3 {resName} = normalize({vec});";
        }
    }

    // Extract comma-separated component names from float4(x, y, z, w)
    private static List<string> ExtractComponents(string expr)
    {
        var result = new List<string>();
        int depth = 0;
        int start = -1;
        for (int i = 0; i < expr.Length; i++)
        {
            if (expr[i] == '(' && start == -1) { depth++; continue; }
            if (expr[i] == '(') depth++;
            if (expr[i] == ')')
            {
                depth--;
                if (depth == 0 && start >= 0)
                {
                    string part = expr[start..i].Trim();
                    if (part.Length > 0) result.Add(part);
                    start = -1;
                }
                continue;
            }
            if (depth == 1 && expr[i] == ',')
            {
                if (start >= 0)
                {
                    string part = expr[start..i].Trim();
                    if (part.Length > 0) result.Add(part);
                    start = -1;
                }
            }
            if (depth == 1 && start == -1 && expr[i] != ' ' && expr[i] != ',') start = i;
        }
        return result;
    }

    // Pattern: float T = a*x + b*y + c*z; (3-4 scalar multiply-adds with
    // matching swizzle pairs on two inputs)
    // → float T = dot(a.xyz, b.xyz);
    private static void SimplifyDotProducts(string[] lines, bool[] drop,
        Dictionary<int, string> replacements, List<(string Old, string New)> renames)
    {
        // Match: float <res> = (<term> + <term> + <term>);
        // where each term is: <scalar> * <vec>.<comp>
        var chainPat = new Regex(
            @"^\s*float\s+(?<res>\w+)\s*=\s*\(" +
            @"(?<t1>\w+(?:\.\w+)?)\s*\*\s*(?<v1>\w+(?:\.\w+)?)\.[xyzw]" +
            @"\s*\+\s*" +
            @"(?<t2>\w+(?:\.\w+)?)\s*\*\s*(?<v2>\w+(?:\.\w+)?)\.[xyzw]" +
            @"\s*\+\s*" +
            @"(?<t3>\w+(?:\.\w+)?)\s*\*\s*(?<v3>\w+(?:\.\w+)?)\.[xyzw]" +
            @"(?:\s*\+\s*" +
            @"(?<t4>\w+(?:\.\w+)?)\s*\*\s*(?<v4>\w+(?:\.\w+)?)\.[xyzw]" +
            @")?\)\s*;\s*$");

        for (int i = 0; i < lines.Length; i++)
        {
            if (drop[i]) continue;

            Match m = chainPat.Match(lines[i]);
            if (!m.Success) continue;

            string res = m.Groups["res"].Value;
            string[] scalars = { m.Groups["t1"].Value, m.Groups["t2"].Value, m.Groups["t3"].Value };
            string[] vecs = { m.Groups["v1"].Value, m.Groups["v2"].Value, m.Groups["v3"].Value };
            int count = 3;
            if (m.Groups["t4"].Success)
            {
                scalars = scalars.Append(m.Groups["t4"].Value).ToArray();
                vecs = vecs.Append(m.Groups["v4"].Value).ToArray();
                count = 4;
            }

            // Check all scalars are the same base variable (e.g. all from one vec)
            // and all vecs are the same base variable — classic dot(a, b) pattern
            // scalars[i] = a.comp, vecs[i] = b.comp
            string sBase = scalars[0].Split('.')[0];
            string vBase = vecs[0].Split('.')[0];
            bool allScalarMatch = scalars.All(s => s.Split('.')[0] == sBase);
            bool allVecMatch = vecs.All(v => v.Split('.')[0] == vBase);
            if (!allScalarMatch || !allVecMatch) continue;

            // Swizzle components must be distinct and match {x,y,z} or {x,y,z,w}
            char[] sComps = scalars.Select(s => s.Contains('.') ? s.Split('.')[1][0] : 'x').ToArray();
            char[] vComps = vecs.Select(v => v.Contains('.') ? v.Split('.')[1][0] : 'x').ToArray();
            if (sComps.Distinct().Count() != count || vComps.Distinct().Count() != count)
                continue;

            string indent = new string(lines[i].TakeWhile(char.IsWhiteSpace).ToArray());
            string swz = new string(sComps);
            string dim = count == 3 ? "3" : "4";

            // Use the vec's swizzle as the dot product swizzle
            string dotA = $"{sBase}.{swz}";
            string dotB = $"{vBase}.{swz}";

            drop[i] = true;
            replacements[i] = $"{indent}float{dim} {res} = dot({dotA}, {dotB});";
        }
    }

    // Pattern: float <res> = <a> * (1 - <t>) + <b> * <t>;
    // Or:        float <res> = mad(<a>, (1 - <t>), <b> * <t>);
    // → float <res> = lerp(<a>, <b>, <t>);
    private static void SimplifyLerps(string[] lines, bool[] drop,
        Dictionary<int, string> replacements, List<(string Old, string New)> renames)
    {
        // Pattern: result = a * (1 - t) + b * t
        var lerpPat = new Regex(
            @"^\s*float\s+(?<res>\w+)\s*=\s*" +
            @"(?<a>\w+(?:\.\w+)?)\s*\*\s*\(1\s*-\s*(?<t>\w+(?:\.\w+)?)\)" +
            @"\s*\+\s*" +
            @"(?<b>\w+(?:\.\w+)?)\s*\*\s*(?<t2>\w+(?:\.\w+)?)\s*;\s*$");

        for (int i = 0; i < lines.Length; i++)
        {
            if (drop[i]) continue;

            Match m = lerpPat.Match(lines[i]);
            if (!m.Success) continue;
            if (m.Groups["t"].Value != m.Groups["t2"].Value) continue;

            string res = m.Groups["res"].Value;
            string a = m.Groups["a"].Value;
            string b = m.Groups["b"].Value;
            string t = m.Groups["t"].Value;
            string indent = new string(lines[i].TakeWhile(char.IsWhiteSpace).ToArray());

            drop[i] = true;
            replacements[i] = $"{indent}float {res} = lerp({a}, {b}, {t});";
        }
    }

    // Pattern: float4 r = v.y * M[1]; r = mad(M[0], v.x, r); r = mad(M[2], v.z, r);
    // Or:        r = r + v.w * M[3];
    // Or:        r = mad(v.w, M[3], r);  (operand order varies)
    // → float4 result = mul(float4(v.x, v.y, v.z, 1), M);
    private static void SimplifyVectorMatrixMuls(string[] lines, bool[] drop,
        Dictionary<int, string> replacements, List<(string Old, string New)> renames)
    {
        // Seed: float4 <acc> = <scalar> * <mat>[<idx>]; OR <mat>[<idx>] * <scalar>;
        var seedPat = new Regex(
            @"^\s*float4\s+(?<acc>\w+)\s*=\s*(?<mul>[^;]+\*\s*(?<mat>\w+)\[(?<idx>\d+)\]|(?<mat2>\w+)\[(?<idx2>\d+)\]\s*\*\s*(?<mul2>[^;]+))\s*;\s*$");
        // Seed (simpler): just match the LHS and RHS
        var seedPat2 = new Regex(
            @"^\s*float4\s+(?<acc>\w+)\s*=\s*(?<rhs>.+)\s*;\s*$");
        // Match mad: <acc> = mad(<a>, <b>, <acc>);  — a,b can be mat[k] or scalar
        var madPat = new Regex(
            @"^\s*(?<acc>\w+)\s*=\s*mad\((?<a>[^,]+),\s*(?<b>[^,]+),\s*(?<c>[^)]+)\)\s*;\s*$");
        // Match add: <acc> = <acc> + <scalar> * <mat>[<idx>]; OR <acc> + mad(...)
        var addPat = new Regex(
            @"^\s*(?<acc>\w+)\s*=\s*(?<acc2>\w+)\s*\+\s*(?<rest>.+)\s*;\s*$");

        for (int i = 0; i + 2 < lines.Length; i++)
        {
            if (drop[i]) continue;

            // Try to parse seed line: float4 acc = scalar * M[idx] or M[idx] * scalar
            Match mSeed = seedPat2.Match(lines[i]);
            if (!mSeed.Success) continue;
            string acc = mSeed.Groups["acc"].Value;
            string rhs = mSeed.Groups["rhs"].Value.Trim();

            // Extract mat[k] and scalar from the RHS
            string? mat = null;
            var comps = new List<char>();
            var indices = new List<string>();

            // Check if RHS contains a matrix access M[idx]
            var matAccess = Regex.Match(rhs, @"(\w+)\[(\d+)\]");
            if (!matAccess.Success) continue;
            mat = matAccess.Groups[1].Value;
            string idx0 = matAccess.Groups[2].Value;

            // Extract the scalar operand (everything not the matrix access)
            string scalarPart = rhs.Replace(matAccess.Value, "").Replace("*", "").Trim();
            // Try to extract the swizzle component from the scalar
            var swizMatch = Regex.Match(scalarPart, @"(\w+)\.([xyzw])");
            if (swizMatch.Success)
            {
                comps.Add(swizMatch.Groups[2].Value[0]);
                indices.Add(idx0);
            }
            else
            {
                continue; // Can't determine the component
            }

            int end = i + 1;
            for (int j = i + 1; j < lines.Length && j < i + 6; j++)
            {
                if (drop[j]) { end = j + 1; continue; }

                Match mMad = madPat.Match(lines[j]);
                if (mMad.Success && mMad.Groups["acc"].Value == acc)
                {
                    string aArg = mMad.Groups["a"].Value.Trim();
                    string bArg = mMad.Groups["b"].Value.Trim();
                    string cArg = mMad.Groups["c"].Value.Trim();

                    // One of a,b should be mat[k], the other should be a scalar
                    string? madMat = null, madScalar = null;
                    var ma1 = Regex.Match(aArg, @"(\w+)\[(\d+)\]");
                    var mb1 = Regex.Match(bArg, @"(\w+)\[(\d+)\]");
                    if (ma1.Success && ma1.Groups[1].Value == mat)
                    {
                        madMat = aArg; madScalar = bArg;
                    }
                    else if (mb1.Success && mb1.Groups[1].Value == mat)
                    {
                        madMat = bArg; madScalar = aArg;
                    }
                    else
                    {
                        continue; // Not our matrix
                    }

                    // Verify cArg is the accumulator
                    if (cArg != acc) continue;

                    var madIdx = Regex.Match(madMat, @"\[(\d+)\]");
                    var madSwiz = Regex.Match(madScalar, @"\.([xyzw])");
                    if (!madIdx.Success || !madSwiz.Success) continue;
                    comps.Add(madSwiz.Groups[1].Value[0]);
                    indices.Add(madIdx.Groups[1].Value);
                    end = j + 1;
                    continue;
                }

                // Try add pattern: acc = acc + scalar * M[idx]
                Match mAdd = addPat.Match(lines[j]);
                if (mAdd.Success && mAdd.Groups["acc"].Value == acc && mAdd.Groups["acc2"].Value == acc)
                {
                    string rest = mAdd.Groups["rest"].Value.Trim();
                    var addMul = Regex.Match(rest, @"(\w+(?:\.\w+)?)\s*\*\s*(\w+)\[(\d+)\]");
                    var addMulRev = Regex.Match(rest, @"(\w+)\[(\d+)\]\s*\*\s*(\w+(?:\.\w+)?)");
                    if (addMul.Success && addMul.Groups[2].Value == mat)
                    {
                        var swz = Regex.Match(addMul.Groups[1].Value, @"\.([xyzw])");
                        if (swz.Success)
                        {
                            comps.Add(swz.Groups[1].Value[0]);
                            indices.Add(addMul.Groups[3].Value);
                            end = j + 1;
                            continue;
                        }
                    }
                    if (addMulRev.Success && addMulRev.Groups[1].Value == mat)
                    {
                        var swz = Regex.Match(addMulRev.Groups[3].Value, @"\.([xyzw])");
                        if (swz.Success)
                        {
                            comps.Add(swz.Groups[1].Value[0]);
                            indices.Add(addMulRev.Groups[2].Value);
                            end = j + 1;
                            continue;
                        }
                    }
                }

                break;
            }

            if (comps.Count < 3) continue;
            if (indices.Count != comps.Count) continue;
            var idxInts = indices.Select(int.Parse).ToList();
            if (idxInts.Any(x => x < 0 || x > 3)) continue;

            string indent = new string(lines[i].TakeWhile(char.IsWhiteSpace).ToArray());
            string swzStr = new string(comps.ToArray());

            // Extract vector base name from the first scalar
            string firstScalar = rhs.Replace(matAccess.Value, "").Replace("*", "").Trim();
            string vecBase = firstScalar.Split('.')[0];

            string vecCtor = $"float4({string.Join(", ", comps.Select(c => $"{vecBase}.{c}"))})";
            string result = $"{indent}float4 {acc} = mul({vecCtor}, {mat});";

            for (int k = i; k < end; k++)
                drop[k] = true;
            replacements[i] = result;
        }
    }
}
