using UnityShaderDecompiler.Core.DXBC.Instructions;
using UnityShaderDecompiler.Core.DXBC.IR;
using UnityShaderDecompiler.Core.DXBC.Metadata;

namespace UnityShaderDecompiler.Core.Hlsl.Ast;

// Stage 12b — Semantic naming.
//
// HlslNameRecovery only propagates PROVABLE copy-chains and leaves every
// other temp as r0/r1/... That is the right default, but a handful of
// canonical Unity idioms are deterministic enough to name without guessing:
// the camera-vector add, the ObjectToWorld position transform, the
// WorldToObject normal transform, UV scale-offset chains, and texture
// samples. These are transient value labels, not recovered author names, so
// the sign must match the actual compiled operand modifiers.
//
// Sign awareness matters specifically for camera vectors: the printer can
// faithfully emit `worldPos + -cameraPos`, but calling that `viewDir` would
// be a lie — it points away from the viewer. The name is chosen from which
// operand carries the negate modifier.
public static partial class HlslSemanticNaming
{
    private readonly record struct RegKey(RegisterType Type, uint Index, int? V0, int? V1, int? V2, int? V3);

    private const string CameraPos = "_WorldSpaceCameraPos";
    private const string ObjectToWorld = "unity_ObjectToWorld";
    private const string WorldToObject = "unity_WorldToObject";

    // Runs inside the pretty-printer (PrintFunction), NOT at AST-build time:
    // the pass needs the stage-filtered slot->CbufferMetadata map to resolve
    // constant-buffer reads whose names live only in the metadata (the AST
    // registers themselves carry a null SymbolicName for those).
    public static void Apply(HlslBlockStatement root, Dictionary<int, CbufferMetadata> cbuffers)
        => Apply(root, cbuffers, stageInputNames: null, stageOutputNames: null);

    // stageInputNames carries the names the VERTEX stage resolved for values
    // it wrote into its interpolator outputs (TEXCOORD fields). Those same
    // semantic fields arrive at the FRAGMENT stage as Input registers, so the
    // fragment pass can seed their names instead of treating e.g.
    // `i.texcoord3` as an anonymous interpolator. Interpolated values are no
    // longer unit length (the vertex normalized them per-vertex; rasterization
    // mixes them), which is why the renormalize-at-the-top-of-frag idiom is so
    // common — the seeded name is the UN-normalized base name (the "unit"
    // prefix stripped) and the renormalize rule re-applies the unit prefix.
    // stageOutputNames is the complementary direction: when a stage writes an
    // interpolator, the printer records which named value it copied into the
    // output (by output semantic), and hands that map to the next stage.
    public static void Apply(
        HlslBlockStatement root,
        Dictionary<int, CbufferMetadata> cbuffers,
        Dictionary<string, string>? stageInputNames,
        Dictionary<string, string>? stageOutputNames = null)
    {
        List<(IRRegister Dest, IRExpression Expr)> assignments =
            HlslNameRecovery.EnumerateAssignments(root).ToList();

        // Definition map used by the chain rules to chase a length holder
        // (rsqrt(dot(v,v))), a UV scale-offset source (_ST), or a
        // pow(fresnel) back to the value they were computed from.
        var defs = new Dictionary<RegKey, IRExpression>();
        foreach (var (dest, expr) in assignments)
            defs.TryAdd(KeyOf(dest), expr);

        var names = new Dictionary<RegKey, string>();

        if (stageInputNames is not null)
        {
            foreach (IRRegister reg in HlslNameRecovery.EnumerateAllRegisters(root))
            {
                if (reg.RegisterType != RegisterType.Input) continue;
                if (reg.SymbolicName is not { } sem) continue;
                if (stageInputNames.TryGetValue(sem, out string? inherited) && inherited is not null)
                    names.TryAdd(KeyOf(reg), DropUnitPrefix(inherited));
            }
        }

        var claimed = new Dictionary<string, RegKey>();
        var matrixChains = new List<MatrixChain>();
        var normalChains = new List<NormalChain>();
        var vectorChains = new List<VectorChain>();
        var worldNormalChains = new List<WorldNormalChain>();

        foreach (var (dest, expr) in assignments)
        {
            switch (expr)
            {
                case IRExpression.BinaryExpression { Operation: IRExpression.BinaryOperation.Add } add:
                    NameCameraVector(names, dest, add, cbuffers);
                    AdvanceVectorChains(names, claimed, dest, add, cbuffers, vectorChains);
                    NameNoiseAccumulator(names, dest, add, defs);
                    break;

                case IRExpression.BinaryExpression mul when mul.Operation == IRExpression.BinaryOperation.Multiply:
                    NameMatrixProduct(names, claimed, dest, mul, cbuffers, matrixChains);
                    NameViewNormalChain(names, claimed, dest, mul, defs, normalChains);
                    NameNormalizeMul(names, dest, mul, defs, cbuffers);
                    NameVectorProduct(names, claimed, dest, mul, cbuffers, vectorChains);
                    break;

                case IRExpression.FusedMultiplyAddExpression fma:
                    AdvanceMatrixChains(names, claimed, dest, fma, cbuffers, matrixChains);
                    AdvanceViewNormalChains(names, claimed, dest, fma, defs, normalChains);
                    NameObjectToWorldPos(names, dest, fma, cbuffers);
                    NameUvChain(names, dest, fma, cbuffers, defs);
                    AdvanceVectorChains(names, claimed, dest, fma, cbuffers, vectorChains);
                    break;

                case IRExpression.IntrinsicExpression { Intrinsic: IRExpression.IRIntrinsic.Exp2 } exp:
                    NameFresnel(names, dest, exp, defs);
                    break;

                case IRExpression.IntrinsicExpression { Intrinsic: IRExpression.IRIntrinsic.Normalize } norm:
                    NameNormalize(names, dest, norm.Arguments);
                    break;

                case IRExpression.DotProductExpression dot:
                    NameWorldNormalDot(names, claimed, dest, dot, cbuffers, worldNormalChains);
                    NameLightingDots(names, dest, dot);
                    break;

                case IRExpression.TextureOperationExpression { Operation: IRExpression.TextureOperation.Sample } sample:
                    NameSample(names, dest, sample);
                    break;

                case IRExpression.ConditionalExpression cond:
                    NameToggleSelect(names, dest, cond, cbuffers, defs);
                    break;
            }
        }

        // Interpolator hand-off: the names resolved above are transient
        // labels, but a stage that copies a NAMED value into an output
        // semantic has just told us what semantic "carries" that value for
        // the next stage. Record it (the printer seeds the receiving stage's
        // matching input with the same name). Only TEXCOORD fields are
        // considered — SV_POSITION/COLOR outputs either don't round-trip as
        // fragment inputs or (COLOR) carry colors with no semantic meaning.
        if (stageOutputNames is not null)
        {
            foreach (var (dest, expr) in assignments)
            {
                if (dest.RegisterType != RegisterType.Output) continue;
                if (dest.SymbolicName is not { } sem
                    || !sem.StartsWith("TEXCOORD", StringComparison.Ordinal)) continue;
                if (stageOutputNames.ContainsKey(sem)) continue;
                if (ResolveValueName(expr, names) is { } v)
                    stageOutputNames.TryAdd(sem, v);
            }
        }

        foreach (IRRegister reg in HlslNameRecovery.EnumerateAllRegisters(root))
        {
            if (reg.SymbolicName is not null) continue;
            if (reg.RegisterType is not RegisterType.Temp and not RegisterType.IndexableTemp) continue;
            if (names.TryGetValue(KeyOf(reg), out string? name))
                reg.SymbolicName = name;
        }

        // Push the freshly assigned names through copy chains the same way
        // metadata-bound names already are.
        HlslNameRecovery.Apply(root);
    }

    private static string UnitPrefix(string baseName) =>
        "unit" + char.ToUpperInvariant(baseName[0]) + baseName[1..];

    // One operand is the camera position cbuffer, the other is the
    // world-position temp. Which side carries the negate decides the real
    // direction of the resulting vector:
    //   (-worldPos + cameraPos) == cameraPos - worldPos -> viewDir (surface->camera)
    //   ( worldPos + -cameraPos) == worldPos - cameraPos -> dirToSurface (camera->surface)
    private static void NameCameraVector(
        Dictionary<RegKey, string> names,
        IRRegister dest,
        IRExpression.BinaryExpression add,
        Dictionary<int, CbufferMetadata> cbuffers)
    {
        (IRRegister? posReg, IRRegister? camReg) = DetectCameraAdd(add, cbuffers, names);
        if (posReg is null) return;

        bool posNeg = posReg.Modifier == ShdrParser.OperandModifier.Neg;

        SetName(names, KeyOf(posReg), "worldPos");
        SetName(names, KeyOf(dest), posNeg ? "viewDir" : "dirToSurface");
    }

    private static (IRRegister? Position, IRRegister? Camera) DetectCameraAdd(
        IRExpression.BinaryExpression add,
        Dictionary<int, CbufferMetadata> cbuffers,
        Dictionary<RegKey, string> names)
    {
        for (int side = 0; side < 2; side++)
        {
            IRExpression posSide = side == 0 ? add.Left : add.Right;
            IRExpression camSide = side == 0 ? add.Right : add.Left;

            if (posSide is not IRExpression.RegisterExpression { Register: { RegisterType: RegisterType.Temp or RegisterType.Input } pos }) continue;
            // A Temp position operand may be a locally-computed worldPos (the
            // same register can get claimed worldPos elsewhere). An Input is
            // only trusted when cross-stage seeding already declared it to BE
            // the interpolated worldPos — a UV texcoord input minus the camera
            // is just a UV artifact, not a view vector.
            if (pos.RegisterType == RegisterType.Input && RelaxedName(names, pos) != "worldPos") continue;
            if (camSide is not IRExpression.RegisterExpression { Register: { RegisterType: RegisterType.ConstantBuffer } cam }) continue;
            if (CbName(cam, cbuffers) is not { } camName
                || !camName.StartsWith(CameraPos, StringComparison.Ordinal)) continue;

            bool posNeg = pos.Modifier == ShdrParser.OperandModifier.Neg;
            bool camNeg = cam.Modifier == ShdrParser.OperandModifier.Neg;
            if (posNeg == camNeg) continue; // both or neither negated — not a simple subtraction
            return (pos, cam);
        }
        return (null, null);
    }

    private static void NameObjectToWorldPos(
        Dictionary<RegKey, string> names,
        IRRegister dest,
        IRExpression.FusedMultiplyAddExpression fma,
        Dictionary<int, CbufferMetadata> cbuffers)
    {
        if (!ReferencesAny(fma, r => r.RegisterType == RegisterType.ConstantBuffer
            && CbName(r, cbuffers) is { } sn && sn.StartsWith(ObjectToWorld, StringComparison.Ordinal))) return;
        if (!ReferencesAny(fma, r => r.RegisterType == RegisterType.Input && (r.SymbolicName ?? "").StartsWith("POSITION"))) return;
        SetName(names, KeyOf(dest), "worldPos");
    }

    private static void NameUvChain(
        Dictionary<RegKey, string> names,
        IRRegister dest,
        IRExpression.FusedMultiplyAddExpression fma,
        Dictionary<int, CbufferMetadata> cbuffers,
        Dictionary<RegKey, IRExpression> defs)
    {
        if (!ReferencesAny(fma, r => r.RegisterType == RegisterType.Input
            && (r.SymbolicName ?? "").StartsWith("TEXCOORD"))) return;

        // The scale/offset pair usually appears in the fma directly
        // (_N_map_ST.xxyx), but a shader that pre-scales it (e.g. an
        // animated UV: mad(uv, _M_map_ST.y * cos, _M_map_ST.w * sin)) hides
        // it behind one temp hop. Chase that hop, but never deeper — a
        // two-level chase risks associating the uv with an unrelated _ST.
        string? stName = FindSTIn(fma, cbuffers, defs, depth: 0);
        if (stName is null) return;

        SetName(names, KeyOf(dest), "uv" + Camelize(stName.Split('.')[0][..^3]));
    }

    private static string? FindSTIn(IRExpression expr, Dictionary<int, CbufferMetadata> cbuffers, Dictionary<RegKey, IRExpression> defs, int depth)
    {
        if (depth > 1) return null;
        foreach (IRRegister r in expr.CollectRegisterUses())
        {
            if (r.RegisterType == RegisterType.ConstantBuffer)
            {
                if (CbName(r, cbuffers) is { } sn && sn.Split('.')[0].EndsWith("_ST", StringComparison.Ordinal))
                    return sn;
                continue;
            }
            if (depth == 0 && r.RegisterType == RegisterType.Temp
                && TryGetDef(defs, r, out IRExpression? operandDef))
            {
                if (FindSTIn(operandDef, cbuffers, defs, depth + 1) is { } nested)
                    return nested;
            }
        }
        return null;
    }

    // ================= matrix products (A·B rows) and matrix·vector =================
    //
    // A compiler lays out `mul(A, B)` as one run per output row, each row a
    // chain of mul + mad accumulating A[j]·B[i][j] over j. When both A and B
    // are named constant-buffer matrices the product is deterministic enough
    // to name (unity_MatrixV · unity_ObjectToWorld is the object->view
    // matrix, a Unity-standard value). The chain steps are all partial sums
    // of the same row, so every step takes the same base name and the SSA
    // version suffix keeps the identifiers distinct.

    private sealed class MatrixChain
    {
        public string LeftMat = "";   // matrix whose rows cycle (unity_MatrixV)
        public string RightMat = "";  // matrix whose row is fixed (unity_ObjectToWorld[i])
        public uint RightRow;         // output row index
        public string ResultName = ""; // e.g. "objectToView"
        public int StepCount;
        public RegKey PrevKey;
        public bool[] Seen = new bool[4];
    }

    // mul(matMul/matVec accumulator state for a run of mul + mad statements.
    private sealed class NormalChain
    {
        public string RowPrefix = ""; // e.g. "objectToView"
        public int StepCount;
        public RegKey PrevKey;
        public bool[] SeenRow = new bool[4];
        public bool[] SeenComp = new bool[4];
    }

    // The three consecutive dot(normal, M[i]) statements (i = 0,1,2) the
    // compiler emits for mul((float3x3)M, normal) against an RDEF-less
    // matrix. Named only once all three rows are confirmed.
    private sealed class WorldNormalChain
    {
        public int Buffer;              // cbuffer slot holding the matrix
        public int RowBase;             // absolute row of M[0]
        public RegisterType NormalType;
        public uint NormalIndex;
        public RegisterType DestType;
        public uint DestIndex;
        public RegKey?[] Written = new RegKey?[3]; // per-row component keys
    }

    private static void NameMatrixProduct(
        Dictionary<RegKey, string> names,
        Dictionary<string, RegKey> claimed,
        IRRegister dest,
        IRExpression.BinaryExpression mul,
        Dictionary<int, CbufferMetadata> cbuffers,
        List<MatrixChain> chains)
    {
        if (!TryMatrixPair(mul, cbuffers, out string leftMat, out int leftRow, out string rightMat, out int rightRow))
            return;
        if (leftRow is < 0 or > 3 || rightRow is < 0 or > 3)
            return;

        string? resultName = ResultMatrixName(leftMat, rightMat);
        if (resultName is null)
            return;

        var chain = new MatrixChain
        {
            LeftMat = leftMat,
            RightMat = rightMat,
            RightRow = (uint)rightRow,
            ResultName = resultName,
            StepCount = 1,
            PrevKey = KeyOf(dest),
        };
        chain.Seen[leftRow] = true;
        chains.Add(chain);

        TrySetName(names, claimed, dest, resultName + rightRow);
    }

    private static void AdvanceMatrixChains(
        Dictionary<RegKey, string> names,
        Dictionary<string, RegKey> claimed,
        IRRegister dest,
        IRExpression.FusedMultiplyAddExpression fma,
        Dictionary<int, CbufferMetadata> cbuffers,
        List<MatrixChain> chains)
    {
        foreach (MatrixChain chain in chains)
        {
            if (chain.StepCount >= 4) continue;
            if (fma.C is not IRExpression.RegisterExpression prev) continue;
            if (KeyOf(prev.Register) != chain.PrevKey) continue;
            if (!TryChainRowPair(fma.A, fma.B, chain, cbuffers, out int leftRow, out int bcastComp)) continue;
            if (leftRow is < 0 or > 3 || chain.Seen[leftRow]) continue;
            _ = bcastComp;

            chain.Seen[leftRow] = true;
            chain.StepCount++;
            chain.PrevKey = KeyOf(dest);
            TrySetName(names, claimed, dest, chain.ResultName + chain.RightRow);
            return;
        }
    }

    // mul(whole, broadcast) where the whole operand is one row of matrix L
    // and the broadcast operand is one row (same row every step) of matrix
    // R — the seed of an A·B row chain. The broadcast carries R's row index.
    private static bool TryMatrixPair(
        IRExpression.BinaryExpression mul,
        Dictionary<int, CbufferMetadata> cbuffers,
        out string leftMat, out int leftRow, out string rightMat, out int rightRow)
    {
        leftMat = rightMat = "";
        leftRow = rightRow = -1;

        if (mul.Left is not IRExpression.RegisterExpression l || mul.Right is not IRExpression.RegisterExpression r)
            return false;
        if (l.Register.RegisterType != RegisterType.ConstantBuffer || r.Register.RegisterType != RegisterType.ConstantBuffer)
            return false;

        int? lComp = BroadcastComponent(l.Register);
        int? rComp = BroadcastComponent(r.Register);
        if ((lComp is null) == (rComp is null))
            return false; // need exactly one broadcast

        IRExpression.RegisterExpression whole = lComp is null ? l : r;
        IRExpression.RegisterExpression bcast = lComp is null ? r : l;

        if (!TryMatrixRow(CbName(whole.Register, cbuffers), out leftMat, out leftRow))
            return false;
        return TryMatrixRow(CbName(bcast.Register, cbuffers), out rightMat, out rightRow);
    }

    private static bool TryChainRowPair(
        IRExpression a,
        IRExpression b,
        MatrixChain chain,
        Dictionary<int, CbufferMetadata> cbuffers,
        out int leftRow, out int bcastComp)
    {
        leftRow = bcastComp = -1;
        if (a is not IRExpression.RegisterExpression ra || b is not IRExpression.RegisterExpression rb)
            return false;

        int? compA = BroadcastComponent(ra.Register);
        int? compB = BroadcastComponent(rb.Register);
        if ((compA is null) == (compB is null))
            return false;

        IRExpression.RegisterExpression whole = compA is null ? ra : rb;
        IRExpression.RegisterExpression bcast = compA is null ? rb : ra;

        if (whole.Register.RegisterType != RegisterType.ConstantBuffer || bcast.Register.RegisterType != RegisterType.ConstantBuffer)
            return false;

        if (!TryMatrixRow(CbName(whole.Register, cbuffers), out string wMat, out leftRow))
            return false;
        if (wMat != chain.LeftMat)
            return false;

        if (!TryMatrixRow(CbName(bcast.Register, cbuffers), out string bMat, out int brow))
            return false;
        if (bMat != chain.RightMat || brow != (int)chain.RightRow)
            return false;

        bcastComp = compA ?? compB ?? -1;
        return true;
    }

    private static string? ResultMatrixName(string leftMat, string rightMat) => (leftMat, rightMat) switch
    {
        ("unity_MatrixV", "unity_ObjectToWorld") => "objectToView",
        _ => null,
    };

    // ================= matrix·vector chains =================
    //
    // mul(M, v) is compiled as one chain per output row: seed
    //   v[i].xxxx * M[base+i]  (row i dotted with vector component i), then
    //   mad(M[base+j], v[j].xxxx, partial) over the other rows, and finally
    //   either mad(M[base+3], v.w, partial) or, when v.w folds to 1, a bare
    //   add of M[base+3]. A Unity shader doing this against ObjectToWorld or
    //   MatrixVP is the classic position transform (worldPos/clipPos); when
    //   the matrix metadata has no name (cbN_values fallback) the product's
    //   meaning falls out of the VECTOR instead: a POSITION input, a NORMAL,
    //   a TANGENT, or a temp already named worldPos. The vector is a single
    //   register read one component at a time (r4.x / r4.y / ..., or
    //   i.position0.x / ...), which is what distinguishes this from the
    //   matrix·matrix product above.

    private sealed class VectorChain
    {
        public int Buffer;     // cbuffer slot holding the matrix
        public string ResultName = "";
        public int RowBase;    // absolute matrix-row offset of the first row
        public (RegisterType Type, uint Index) Vector;
        public int StepCount;
        public RegKey PrevKey;
        public bool[] SeenComp = new bool[4];
    }

    private static void NameVectorProduct(
        Dictionary<RegKey, string> names,
        Dictionary<string, RegKey> claimed,
        IRRegister dest,
        IRExpression.BinaryExpression mul,
        Dictionary<int, CbufferMetadata> cbuffers,
        List<VectorChain> chains)
    {
        if (mul.Left is not IRExpression.RegisterExpression l || mul.Right is not IRExpression.RegisterExpression r)
            return;

        int? lComp = BroadcastComponent(l.Register);
        int? rComp = BroadcastComponent(r.Register);
        if ((lComp is null) == (rComp is null))
            return; // need exactly one broadcast

        IRExpression.RegisterExpression whole = lComp is null ? l : r;
        IRExpression.RegisterExpression bcast = lComp is null ? r : l;

        if (whole.Register.RegisterType != RegisterType.ConstantBuffer) return;
        if (bcast.Register.RegisterType is not RegisterType.Temp and not RegisterType.Input) return;
        if (whole.Register.Indices.Count < 2) return;

        int buffer = (int)whole.Register.Indices[0];
        int row = (int)whole.Register.Indices[1];
        int comp = lComp ?? rComp ?? -1;
        if (comp is < 0 or > 3) return;

        // The seed row always pairs with the vector component it broadcasts
        // (row i is dotted with v[i]); the matrix base is that row minus the
        // component. For a named matrix rows run 0..3 (base 0); an unnamed
        // cbuffer element carries the ABSOLUTE slot so its base is element-comp.
        int rowBase = row - comp;
        if (rowBase < 0) return;

        string? resultName = VectorResultName(CbName(whole.Register, cbuffers), bcast.Register, names);
        if (resultName is null) return;

        var chain = new VectorChain
        {
            Buffer = buffer,
            ResultName = resultName,
            RowBase = rowBase,
            Vector = (bcast.Register.RegisterType, bcast.Register.Index),
            StepCount = 1,
            PrevKey = KeyOf(dest),
        };
        chain.SeenComp[comp] = true;
        chains.Add(chain);

        TrySetName(names, claimed, dest, resultName);
    }

    // A mad or add that carries one more row of an open matrix·vector chain.
    private static void AdvanceVectorChains(
        Dictionary<RegKey, string> names,
        Dictionary<string, RegKey> claimed,
        IRRegister dest,
        IRExpression expr,
        Dictionary<int, CbufferMetadata> cbuffers,
        List<VectorChain> chains)
    {
        foreach (VectorChain chain in chains)
        {
            if (chain.StepCount >= 4) continue;

            if (expr is IRExpression.FusedMultiplyAddExpression fma)
            {
                if (fma.C is not IRExpression.RegisterExpression prev) continue;
                if (KeyOf(prev.Register) != chain.PrevKey) continue;
                if (!TryVectorTimes(chain, fma.A, fma.B, out int comp)) continue;
                if (chain.SeenComp[comp]) continue;

                chain.SeenComp[comp] = true;
                chain.StepCount++;
                chain.PrevKey = KeyOf(dest);
                TrySetName(names, claimed, dest, chain.ResultName);
                return;
            }

            if (expr is IRExpression.BinaryExpression { Operation: IRExpression.BinaryOperation.Add } add)
            {
                // The w-row folds to a bare add when the vector's w is 1.
                IRExpression whole;
                if (add.Left is IRExpression.RegisterExpression pl && KeyOf(pl.Register) == chain.PrevKey)
                    whole = add.Right;
                else if (add.Right is IRExpression.RegisterExpression pr && KeyOf(pr.Register) == chain.PrevKey)
                    whole = add.Left;
                else
                    continue;

                if (whole is not IRExpression.RegisterExpression wr
                    || wr.Register.RegisterType != RegisterType.ConstantBuffer
                    || wr.Register.Indices.Count < 2) continue;
                if ((int)wr.Register.Indices[0] != chain.Buffer) continue;
                if ((int)wr.Register.Indices[1] != chain.RowBase + 3) continue;
                if (chain.SeenComp[3]) continue;

                chain.SeenComp[3] = true;
                chain.StepCount++;
                chain.PrevKey = KeyOf(dest);
                TrySetName(names, claimed, dest, chain.ResultName);
                return;
            }
        }
    }

    // One row · vector-component product: one operand is a whole row of the
    // chain's matrix, the other is a broadcast of the chain's vector register.
    private static bool TryVectorTimes(VectorChain chain, IRExpression a, IRExpression b, out int comp)
    {
        comp = -1;
        if (a is not IRExpression.RegisterExpression ra || b is not IRExpression.RegisterExpression rb) return false;

        int? compA = BroadcastComponent(ra.Register);
        int? compB = BroadcastComponent(rb.Register);
        if ((compA is null) == (compB is null)) return false;

        IRExpression.RegisterExpression whole = compA is null ? ra : rb;
        IRExpression.RegisterExpression bcast = compA is null ? rb : ra;

        if (whole.Register.RegisterType != RegisterType.ConstantBuffer) return false;
        if (whole.Register.Indices.Count < 2) return false;
        if (bcast.Register.RegisterType is not RegisterType.Temp and not RegisterType.Input) return false;
        if (bcast.Register.RegisterType != chain.Vector.Type || bcast.Register.Index != chain.Vector.Index) return false;

        comp = compA ?? compB ?? -1;
        if (comp is < 0 or > 3) return false;
        return (int)whole.Register.Indices[0] == chain.Buffer
            && (int)whole.Register.Indices[1] == chain.RowBase + comp;
    }

    private static string? VectorResultName(string? matrix, IRRegister vector, Dictionary<RegKey, string> names)
    {
        switch (matrix)
        {
            case "unity_ObjectToWorld": return "worldPos";
            case "unity_MatrixVP": return "clipPos";
            case "unity_MatrixV": return "viewPos";
        }

        // Unnamed matrix (RDEF-less cbN_values fallback): the vector's
        // provenance identifies the transform — a position/normal/tangent
        // input, or a temp already established as worldPos.
        if (vector.RegisterType == RegisterType.Input)
        {
            string sn = vector.SymbolicName ?? "";
            if (sn.StartsWith("POSITION", StringComparison.Ordinal)) return "worldPos";
            if (sn.StartsWith("NORMAL", StringComparison.Ordinal)) return "worldNormal";
            if (sn.StartsWith("TANGENT", StringComparison.Ordinal)) return "worldTangent";
            return null;
        }
        if (vector.RegisterType == RegisterType.Temp && RelaxedName(names, vector) == "worldPos")
            return "clipPos";
        return null;
    }

    // A matrix row in metadata form reads as "Name[row]" (+ optional
    // trailing swizzle ".xyz") — split the name from the row index so both
    // can be compared independently.
    private static bool TryMatrixRow(string? name, out string matName, out int row)
    {
        matName = "";
        row = -1;
        if (string.IsNullOrEmpty(name))
            return false;
        int dot = name.IndexOf('.');
        string baseName = dot >= 0 ? name[..dot] : name;
        int open = baseName.IndexOf('[');
        if (open <= 0 || !baseName.EndsWith(']'))
            return false;
        if (!int.TryParse(baseName[(open + 1)..^1], out row))
            return false;
        matName = baseName[..open];
        return true;
    }

}
