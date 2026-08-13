using Parser.DXBC.Instructions;
using Parser.DXBC.IR;
using Parser.DXBC.Metadata;

namespace Parser.DXBC.Hlsl.Ast;

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
public static class HlslSemanticNaming
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

    // mul(rowTemp, inputNormalBroadcast) — the seed of a matrix·normal
    // chain. rowTemp is a named matrix row (objectToView{i}); the output is
    // the normal in that matrix's target space (view space -> viewNormal).
    private static void NameViewNormalChain(
        Dictionary<RegKey, string> names,
        Dictionary<string, RegKey> claimed,
        IRRegister dest,
        IRExpression.BinaryExpression mul,
        Dictionary<RegKey, IRExpression> defs,
        List<NormalChain> chains)
    {
        if (!TryRowAndNormalPair(mul, names, out string? rowName, out int comp, out _)) return;
        if (rowName is null || !TryRowPrefix(rowName, out string prefix, out int row)) return;
        if (prefix != "objectToView" || row != comp) return;
        if (row is < 0 or > 3) return;

        var chain = new NormalChain { RowPrefix = prefix, StepCount = 1, PrevKey = KeyOf(dest) };
        chain.SeenRow[row] = true;
        chain.SeenComp[comp] = true;
        chains.Add(chain);

        TrySetName(names, claimed, dest, "viewNormal");
    }

    private static void AdvanceViewNormalChains(
        Dictionary<RegKey, string> names,
        Dictionary<string, RegKey> claimed,
        IRRegister dest,
        IRExpression.FusedMultiplyAddExpression fma,
        Dictionary<RegKey, IRExpression> defs,
        List<NormalChain> chains)
    {
        foreach (NormalChain chain in chains)
        {
            if (chain.StepCount >= 4) continue;
            if (fma.C is not IRExpression.RegisterExpression prev) continue;
            if (KeyOf(prev.Register) != chain.PrevKey) continue;
            if (!TryRowAndNormalPair(fma, names, out string? rowName, out int comp, out int row)) continue;
            if (rowName is null || !TryRowPrefix(rowName, out string prefix, out _)) continue;
            if (prefix != chain.RowPrefix || row != comp) continue;
            if (row is < 0 or > 3 || chain.SeenRow[row] || chain.SeenComp[comp]) continue;

            chain.SeenRow[row] = true;
            chain.SeenComp[comp] = true;
            chain.StepCount++;
            chain.PrevKey = KeyOf(dest);
            TrySetName(names, claimed, dest, "viewNormal");
            return;
        }
    }

    // Splits a fma/mul into (row temp operand, normal input broadcast
    // operand). The row operand is the whole-read temp carrying a
    // named matrix row; the normal operand is the Select1 broadcast of a
    // NORMAL input. Returns the row's index (from its name) and the
    // broadcast component.
    private static bool TryRowAndNormalPair(
        IRExpression expr,
        Dictionary<RegKey, string> names,
        out string? rowName,
        out int comp,
        out int row)
    {
        rowName = null;
        comp = row = -1;

        IRExpression left = expr is IRExpression.BinaryExpression b ? b.Left
            : expr is IRExpression.FusedMultiplyAddExpression f ? f.A
            : expr;
        IRExpression right = expr is IRExpression.BinaryExpression b2 ? b2.Right
            : expr is IRExpression.FusedMultiplyAddExpression f2 ? f2.B
            : expr;

        if (left is not IRExpression.RegisterExpression l || right is not IRExpression.RegisterExpression r)
            return false;

        int? lComp = BroadcastComponent(l.Register);
        int? rComp = BroadcastComponent(r.Register);
        if ((lComp is null) == (rComp is null))
            return false;

        IRExpression.RegisterExpression rowReg = lComp is null ? l : r;
        IRExpression.RegisterExpression nrmReg = lComp is null ? r : l;

        if (rowReg.Register.RegisterType != RegisterType.Temp)
            return false;
        if (nrmReg.Register.RegisterType != RegisterType.Input)
            return false;
        if (!(nrmReg.Register.SymbolicName ?? "").StartsWith("NORMAL", StringComparison.Ordinal))
            return false;

        rowName = RelaxedName(names, rowReg.Register);
        comp = lComp ?? rComp ?? -1;
        row = -1;
        if (rowName is { } rn && TryRowPrefix(rn, out _, out row))
        {
            // row index must equal the broadcast component for a normal
            // transform (row i is paired with normal[i]).
            return row == comp;
        }
        return false;
    }

    private static bool TryRowPrefix(string name, out string prefix, out int row)
    {
        prefix = "";
        row = -1;
        int i = name.Length;
        while (i > 0 && char.IsDigit(name[i - 1])) i--;
        if (i == name.Length || i == 0) return false;
        if (!int.TryParse(name[i..], out row)) return false;
        prefix = name[..i];
        return true;
    }

    // dest = exp2(pow * log2(<named> + bias)) — the canonical Fresnel term
    // pow(1 - dot(...), power), here written through log2/exp2. Fires only
    // when the log's base is an ADD that references a named register, so a
    // bare exp2 never gets this name.
    private static void NameFresnel(
        Dictionary<RegKey, string> names,
        IRRegister dest,
        IRExpression.IntrinsicExpression exp,
        Dictionary<RegKey, IRExpression> defs)
    {
        if (exp.Arguments.Count == 0 || exp.Arguments[0] is not IRExpression.RegisterExpression p) return;
        if (!TryGetDef(defs, p.Register, out IRExpression? pDef)) return;
        if (pDef is not IRExpression.BinaryExpression { Operation: IRExpression.BinaryOperation.Multiply } mul) return;

        IRExpression? logSide = null;
        IRExpression? powSide = null;
        foreach (IRExpression operand in new[] { mul.Left, mul.Right })
        {
            if (operand is IRExpression.RegisterExpression ore
                && TryGetDef(defs, ore.Register, out IRExpression? od)
                && od is IRExpression.IntrinsicExpression { Intrinsic: IRExpression.IRIntrinsic.Log2 })
            {
                logSide = operand;
            }
            else
            {
                powSide = operand;
            }
        }
        if (logSide is not IRExpression.RegisterExpression logReg || powSide is null) return;

        if (!TryGetDef(defs, logReg.Register, out IRExpression? logDef)
            || logDef is not IRExpression.IntrinsicExpression { Intrinsic: IRExpression.IRIntrinsic.Log2 } log)
            return;
        if (log.Arguments.Count == 0 || log.Arguments[0] is not IRExpression.RegisterExpression baseReg) return;

        if (!TryGetDef(defs, baseReg.Register, out IRExpression? baseDef)
            || baseDef is not IRExpression.BinaryExpression { Operation: IRExpression.BinaryOperation.Add } add)
            return;

        // A named operand can be a temp that already picked up a semantic
        // name from an earlier rule (e.g. nDotV), OR a constant-buffer
        // variable bound straight from RDEF (e.g. _t) — the latter never
        // shows up in `names`/RelaxedName because IRMetadataBinding writes
        // SymbolicName directly onto the register, not through this pass's
        // dictionary, so it needs its own branch here.
        bool hasNamedOperand = ReferencesAny(add, r =>
            (r.RegisterType is RegisterType.Temp or RegisterType.IndexableTemp
                && (r.SymbolicName is not null || RelaxedName(names, r) is not null))
            || (r.RegisterType == RegisterType.ConstantBuffer && r.SymbolicName is not null));
        if (!hasNamedOperand) return;

        SetName(names, KeyOf(dest), "fresnel");
    }


    private static void NameWorldNormalDot(
        Dictionary<RegKey, string> names,
        Dictionary<string, RegKey> claimed,
        IRRegister dest,
        IRExpression.DotProductExpression dot,
        Dictionary<int, CbufferMetadata> cbuffers,
        List<WorldNormalChain> chains)
    {
        if (!ReferencesAny(dot, r => r.RegisterType == RegisterType.Input && (r.SymbolicName ?? "").StartsWith("NORMAL"))) return;

        // The canonical named matrix (unity_WorldToObject) is proof enough on
        // its own — a NORMAL dotted with a named WorldToObject row is
        // deterministically the world normal, no chain needed.
        if (ReferencesAny(dot, r => r.RegisterType == RegisterType.ConstantBuffer
            && CbName(r, cbuffers) is { } sn && sn.StartsWith(WorldToObject, StringComparison.Ordinal)))
        {
            SetName(names, KeyOf(dest), "worldNormal");
            return;
        }

        // RDEF-less matrix: fire only on the full 3-row run the compiler
        // emits for mul((float3x3)M, normal) — dot(normal, M[i]) writing
        // component i of the same register, for i in 0..2, against three
        // consecutive rows of one cbuffer. A lone dot (e.g. NdotL against a
        // light vector) must never be named.
        if (dot.Left is not IRExpression.RegisterExpression l || dot.Right is not IRExpression.RegisterExpression r)
            return;

        IRExpression.RegisterExpression normal = l;
        IRExpression.RegisterExpression cb = r;
        if (normal.Register.RegisterType != RegisterType.Input || !(normal.Register.SymbolicName ?? "").StartsWith("NORMAL"))
        {
            normal = r;
            cb = l;
        }
        if (normal.Register.RegisterType != RegisterType.Input || !(normal.Register.SymbolicName ?? "").StartsWith("NORMAL")) return;
        if (cb.Register.RegisterType != RegisterType.ConstantBuffer) return;
        if (cb.Register.Indices.Count < 2) return;
        if (BroadcastComponent(cb.Register) is not null) return; // scalar/broadcast read is not a matrix row

        int buffer = (int)cb.Register.Indices[0];
        int row = (int)cb.Register.Indices[1];
        List<int> active = MaskIndices(dest.Mask);
        if (active.Count != 1) return; // one component per dot
        int comp = active[0];
        if (comp is < 0 or > 2) return; // rows 0..2 only — w is the translation row
        int rowBase = row - comp;
        if (rowBase < 0) return;

        WorldNormalChain? chain = chains.FirstOrDefault(c =>
            c.Buffer == buffer && c.RowBase == rowBase
            && c.NormalType == normal.Register.RegisterType && c.NormalIndex == normal.Register.Index
            && c.DestType == dest.RegisterType && c.DestIndex == dest.Index);
        if (chain is null)
        {
            chain = new WorldNormalChain
            {
                Buffer = buffer,
                RowBase = rowBase,
                NormalType = normal.Register.RegisterType,
                NormalIndex = normal.Register.Index,
                DestType = dest.RegisterType,
                DestIndex = dest.Index,
            };
            chains.Add(chain);
        }

        if (chain.Written[comp] is not null)
            return;
        chain.Written[comp] = KeyOf(dest);

        if (chain.Written[0] is { } k0 && chain.Written[1] is { } k1 && chain.Written[2] is { } k2)
        {
            TrySetName(names, claimed, dest, "worldNormal");
            SetName(names, k0, "worldNormal");
            SetName(names, k1, "worldNormal");
            SetName(names, k2, "worldNormal");
        }
    }

    private static void NameSample(
        Dictionary<RegKey, string> names,
        IRRegister dest,
        IRExpression.TextureOperationExpression sample)
    {
        // Prefer the texture's own metadata name; fall back to the sampled
        // coordinate when it carries a uv* name (covers resources whose
        // binding has no RDEF name, as long as the uv chain was recognized).
        string baseName;
        if (!string.IsNullOrEmpty(sample.Resource.SymbolicName))
        {
            baseName = sample.Resource.SymbolicName;
        }
        else if (sample.Coordinates is { } coords
            && FindNamedUv(coords, names) is { } uvName)
        {
            baseName = uvName;
        }
        else
        {
            return;
        }

        string tag = baseName.StartsWith("uv", StringComparison.Ordinal) ? baseName[2..] : baseName;
        SetName(names, KeyOf(dest), "sample" + Camelize(tag));
    }

    // First register use that resolves to a name starting with "uv".
    private static string? FindNamedUv(IRExpression expr, Dictionary<RegKey, string> names)
    {
        foreach (IRRegister r in expr.CollectRegisterUses())
        {
            string? n = r.SymbolicName ?? RelaxedName(names, r);
            if (n is not null && n.StartsWith("uv", StringComparison.Ordinal))
                return n;
        }
        return null;
    }

    private static void NameNormalize(
        Dictionary<RegKey, string> names,
        IRRegister dest,
        List<IRExpression> args)
    {
        if (args.Count == 0 || args[0] is not IRExpression.RegisterExpression re) return;
        if (BaseName(names, re.Register) is { } baseName)
            SetName(names, KeyOf(dest), UnitPrefix(baseName));
    }

    // dest = lenReg * vecReg, where lenReg's definition is rsqrt(dot(v,v)).
    // Only fires when the vector operand already carries a semantic name, so
    // the result is unit<thatname> — never an unverified guess. A few
    // canonical Unity idioms additionally fall out of this same shape:
    //   - normalize(_WorldSpaceLightPos0) — the directional-light direction,
    //   - normalize(unit<view> + lightDir) — the Blinn-Phong half-vector,
    //   - normalize(<object normal transformed by the 3 object->world rows>)
    //     — the vertex-stage world normal recomputed per component.
    private static void NameNormalizeMul(
        Dictionary<RegKey, string> names,
        IRRegister dest,
        IRExpression.BinaryExpression mul,
        Dictionary<RegKey, IRExpression> defs,
        Dictionary<int, CbufferMetadata> cbuffers)
    {
        for (int side = 0; side < 2; side++)
        {
            IRExpression a = side == 0 ? mul.Left : mul.Right;
            IRExpression b = side == 0 ? mul.Right : mul.Left;

            if (a is not IRExpression.RegisterExpression { Register: { RegisterType: RegisterType.Temp } } len) continue;
            if (b is not IRExpression.RegisterExpression vec) continue;

            if (!TryGetDef(defs, len.Register, out IRExpression? lenDef)) continue;
            if (lenDef is not IRExpression.IntrinsicExpression { Intrinsic: IRExpression.IRIntrinsic.Rsqrt } rs) continue;
            if (rs.Arguments.Count == 0 || rs.Arguments[0] is not IRExpression.RegisterExpression lenArg) continue;
            if (!TryGetDef(defs, lenArg.Register, out IRExpression? dotDef)) continue;
            if (dotDef is not IRExpression.DotProductExpression dot) continue;
            if (dot.Left is not IRExpression.RegisterExpression d0 || dot.Right is not IRExpression.RegisterExpression d1) continue;
            if (!SameRegisterValue(d0.Register, d1.Register)) continue;
            if (!SameRegisterValue(vec.Register, d0.Register)) continue;

            // Directional-light direction. _WorldSpaceLightPos0 is a
            // position/length for point lights, but normalizing it directly
            // (with no worldPos subtraction) IS the standard directional-only
            // Unity idiom — a point light would be normalized towards the
            // light, not away from the surface.
            if (vec.Register.RegisterType == RegisterType.ConstantBuffer)
            {
                if (CbName(vec.Register, cbuffers) is { } cb
                    && cb.StartsWith("_WorldSpaceLightPos0", StringComparison.Ordinal))
                    SetName(names, KeyOf(dest), "lightDir");
                return;
            }

            if (RelaxedName(names, vec.Register) is { } baseName)
            {
                SetName(names, KeyOf(dest), UnitPrefix(baseName));
                return;
            }

            // half-vector: dest = normalize(unit<view> + lightDir), rendered
            // as normalize(rsqrt(v,v)*v + lightDir) — the vec here is the sum
            // itself, computed as fma(view, 1/|view|, lightDir).
            if (IsHalfVectorSum(vec.Register, defs, names))
            {
                SetName(names, KeyOf(dest), "halfVector");
                return;
            }

            // Vertex-stage object->world normal recomputed one component at a
            // time (dot(normal, row) x3 + normalize). Those dot destinations
            // carry no semantic name of their own, so the composite falls
            // through both checks above — recognize the row-triple shape.
            if (IsCompositeObjectSpaceNormal(vec.Register, defs))
            {
                SetName(names, KeyOf(dest), "unitWorldNormal");
                return;
            }

            return;
        }
    }

    // true when reg's definition is fma(view, 1/|view|, lightDir): the middle
    // step of the classic half-vector construction normalize(view + lightDir).
    private static bool IsHalfVectorSum(
        IRRegister reg,
        Dictionary<RegKey, IRExpression> defs,
        Dictionary<RegKey, string> names)
    {
        if (!TryGetDef(defs, reg, out IRExpression? def)) return false;
        if (def is not IRExpression.FusedMultiplyAddExpression fma) return false;

        // Addend is the light direction and the fma re-normalizes A by its own
        // reciprocal length (B = rsqrt(dot(A, A))): fma(A, 1/|A|, lightDir).
        if (fma.C is not IRExpression.RegisterExpression cReg) return false;
        if (BaseName(names, cReg.Register) != "lightDir") return false;
        if (fma.A is not IRExpression.RegisterExpression aReg) return false;

        if (fma.B is not IRExpression.RegisterExpression bReg) return false;
        if (!TryGetDef(defs, bReg.Register, out IRExpression? bDef)) return false;
        if (bDef is not IRExpression.IntrinsicExpression { Intrinsic: IRExpression.IRIntrinsic.Rsqrt } rs) return false;
        if (rs.Arguments.Count == 0 || rs.Arguments[0] is not IRExpression.RegisterExpression rsc) return false;
        if (!TryGetDef(defs, rsc.Register, out IRExpression? dotDef)) return false;
        if (dotDef is not IRExpression.DotProductExpression dot) return false;
        if (dot.Left is not IRExpression.RegisterExpression dl || dot.Right is not IRExpression.RegisterExpression dr) return false;
        return SameRegisterValue(dl.Register, dr.Register) && SameRegisterValue(dl.Register, aReg.Register);
    }

    // true when reg is a composite (per-component SSA versions) whose first
    // three components are each `dot(i.<NORMAL>, cbufferMatrixRow)` over the
    // same input normal register against three DISTINCT rows: the canonical
    // vertex-stage object->world normal transform.
    private static bool IsCompositeObjectSpaceNormal(IRRegister reg, Dictionary<RegKey, IRExpression> defs)
    {
        IRRegister? normal = null;
        uint?[] row = new uint?[3];
        for (int c = 0; c < 3; c++)
        {
            if (reg.SsaVersion[c] is null) return false;
            IRRegister probe = ComponentProbe(reg, c);
            if (!TryGetDef(defs, probe, out IRExpression? cd)) return false;
            if (cd is not IRExpression.DotProductExpression dot) return false;
            if (dot.Left is not IRExpression.RegisterExpression l
                || dot.Right is not IRExpression.RegisterExpression r) return false;

            IRExpression.RegisterExpression inExpr;
            IRExpression.RegisterExpression cbExpr;
            if (l.Register.RegisterType == RegisterType.ConstantBuffer
                && r.Register.RegisterType == RegisterType.Input) { inExpr = r; cbExpr = l; }
            else if (r.Register.RegisterType == RegisterType.ConstantBuffer
                && l.Register.RegisterType == RegisterType.Input) { inExpr = l; cbExpr = r; }
            else return false;

            if (!(inExpr.Register.SymbolicName ?? "").StartsWith("NORMAL", StringComparison.Ordinal)) return false;
            if (normal is null) normal = inExpr.Register;
            else if (!SameRegisterValue(normal, inExpr.Register)) return false;

            row[c] = cbExpr.Register.Indices.Count > 1 ? cbExpr.Register.Indices[1] : cbExpr.Register.Index;
        }

        return row[0] is { } r0 && row[1] is { } r1 && row[2] is { } r2
            && r0 != r1 && r1 != r2 && r0 != r2;
    }

    // A single-component read of reg at component c (all other SSA versions
    // nulled) — the probe shape TryGetDef needs to resolve component c's own
    // defining instruction rather than its neighbors'.
    private static IRRegister ComponentProbe(IRRegister src, int c)
    {
        var p = new IRRegister
        {
            RegisterType = src.RegisterType,
            Index = src.Index,
            ComponentMode = Operand.OperandComponentMode.Select1,
            Component = (byte)c,
        };
        foreach (uint i in src.Indices) p.Indices.Add(i);
        p.SsaVersion[c] = src.SsaVersion[c];
        return p;
    }

    // The inverse of the normalize-mul rule: strip the "unit" prefix a
    // normalized interpolator value carries so the receiving stage treats the
    // interpolated (no-longer-unit) value under its base name and re-applies
    // the prefix when it renormalizes.
    private static string DropUnitPrefix(string name)
        => name.StartsWith("unit", StringComparison.Ordinal) ? name[4..] : name;

    // First register leaf in an expression that carries a resolved semantic
    // name — used to discover which named value a stage copies out to a
    // TEXCOORD output (the interpolator hand-off).
    private static string? ResolveValueName(IRExpression expr, Dictionary<RegKey, string> names)
    {
        foreach (IRRegister r in expr.CollectRegisterUses())
            if (RelaxedName(names, r) is { } n)
                return n;
        return null;
    }

    // dot between two named lighting vectors — NdotV, NdotL, LdotH, NdotH.
    // Fires only when both operands resolve to semantic names, and never when
    // either operand is negated (the negated dot is a DIFFERENT quantity —
    // e.g. `dot(-V, N)` is -NdotV, not NdotV).
    private static void NameLightingDots(
        Dictionary<RegKey, string> names,
        IRRegister dest,
        IRExpression.DotProductExpression dot)
    {
        if (dot.Left is not IRExpression.RegisterExpression n || dot.Right is not IRExpression.RegisterExpression v) return;
        if (n.Register.Modifier == ShdrParser.OperandModifier.Neg
            || v.Register.Modifier == ShdrParser.OperandModifier.Neg) return;

        string? na = RelaxedName(names, n.Register);
        string? vb = RelaxedName(names, v.Register);
        if (na is null || vb is null) return;

        string? name = ClassifyLightingDot(na, vb);
        if (name is not null)
            SetName(names, KeyOf(dest), name);
    }

    private static string? ClassifyLightingDot(string a, string b)
    {
        if (a == "lightDir" && b == "halfVector") return "lDotH";
        if (b == "lightDir" && a == "halfVector") return "lDotH";
        if (a == "lightDir" && b.StartsWith("unit", StringComparison.Ordinal)) return "nDotL";
        if (b == "lightDir" && a.StartsWith("unit", StringComparison.Ordinal)) return "nDotL";
        if (a == "halfVector" && b.StartsWith("unit", StringComparison.Ordinal)) return "nDotH";
        if (b == "halfVector" && a.StartsWith("unit", StringComparison.Ordinal)) return "nDotH";
        if (a.StartsWith("unit", StringComparison.Ordinal) && b.StartsWith("unit", StringComparison.Ordinal)) return "nDotV";
        return null;
    }

    // dest = dest_prevVersion + sin(...) — a loop-carried temp that accumulates
    // a running sum of sin() terms across [loop] iterations (the classic
    // "sum of sines" procedural-noise idiom). Fires only when one operand is
    // literally the same physical register as dest (an earlier SSA version —
    // i.e. this statement IS the loop's carry-forward step) and the other
    // operand's own definition is a bare Sin call, so a one-shot
    // `x = y + sin(z)` outside a loop never gets mislabeled as an accumulator.
    private static void NameNoiseAccumulator(
        Dictionary<RegKey, string> names,
        IRRegister dest,
        IRExpression.BinaryExpression add,
        Dictionary<RegKey, IRExpression> defs)
    {
        foreach (var (self, other) in new[] { (add.Left, add.Right), (add.Right, add.Left) })
        {
            if (self is not IRExpression.RegisterExpression selfReg) continue;
            if (selfReg.Register.RegisterType != dest.RegisterType || selfReg.Register.Index != dest.Index) continue;
            // Index alone only identifies the physical register slot — DXBC's
            // allocator reuses slot numbers constantly for unrelated values,
            // and Index is shared across all four components. Without also
            // requiring the same component mask, "r1.z + (r1.y + r1.x)" (an
            // ordinary unrelated sum that happens to recycle register r1)
            // false-matches as if r1.z were self-accumulating.
            if (selfReg.Register.Mask != dest.Mask) continue;

            if (other is IRExpression.IntrinsicExpression { Intrinsic: IRExpression.IRIntrinsic.Sin })
            {
                SetName(names, KeyOf(dest), "noiseAccum");
                return;
            }

            if (other is IRExpression.RegisterExpression otherReg
                && TryGetDef(defs, otherReg.Register, out IRExpression? otherDef)
                && otherDef is IRExpression.IntrinsicExpression { Intrinsic: IRExpression.IRIntrinsic.Sin })
            {
                SetName(names, KeyOf(dest), "noiseAccum");
                return;
            }
        }
    }

    // cond ? a : b where cond reads a [Toggle]-style cbuffer float compared
    // against a literal (Unity toggles are 0/1 floats, so the comparison
    // survives as `_name == 1` or similar rather than a bool register). The
    // whole ternary is named after the toggle that drives it — e.g.
    // `_monochrom == 1 ? mono : color` becomes `monochromSelect` — instead of
    // leaving the merged value as an anonymous rN.
    private static void NameToggleSelect(
        Dictionary<RegKey, string> names,
        IRRegister dest,
        IRExpression.ConditionalExpression cond,
        Dictionary<int, CbufferMetadata> cbuffers,
        Dictionary<RegKey, IRExpression> defs)
    {
        // The comparison is very often hoisted into its own SSA statement
        // (`r1_w_3 = (_monochrom == 1);` ... `r1_w_3 ? a : b`) rather than
        // appearing inline as cond.Condition, so resolve one level through
        // defs before giving up — same reasoning as the Sin lookup above.
        IRExpression condExpr = cond.Condition;
        if (condExpr is IRExpression.RegisterExpression condReg
            && TryGetDef(defs, condReg.Register, out IRExpression? resolved))
        {
            condExpr = resolved!;
        }

        if (condExpr is not IRExpression.BinaryExpression
            {
                Operation: IRExpression.BinaryOperation.Equal
                    or IRExpression.BinaryOperation.NotEqual
                    or IRExpression.BinaryOperation.GreaterThan
                    or IRExpression.BinaryOperation.GreaterEqual
            } cmp)
        {
            return;
        }

        string? toggleName = null;
        foreach (IRExpression side in new[] { cmp.Left, cmp.Right })
        {
            if (side is IRExpression.RegisterExpression { Register.RegisterType: RegisterType.ConstantBuffer } r
                && CbName(r.Register, cbuffers) is { } name)
            {
                toggleName = name;
                break;
            }
        }
        if (toggleName is null) return;

        // Property names come through as e.g. "_monochrom" — strip the
        // leading underscore and lowercase the first letter to match this
        // pass's existing camelCase convention (viewNormal, dirToSurface, ...).
        string clean = toggleName.TrimStart('_');
        if (clean.Length == 0) return;
        string camel = char.ToLowerInvariant(clean[0]) + clean[1..];

        SetName(names, KeyOf(dest), camel + "Select");
    }

    private static string? BaseName(Dictionary<RegKey, string> names, IRRegister reg)
    {
        if (reg.SymbolicName is not null) return reg.SymbolicName;
        return names.TryGetValue(KeyOf(reg), out string? n) ? n : null;
    }

    // Like BaseName, but tolerant of the fact that a value written one
    // component at a time registers under several PARTIAL keys (the dot
    // that wrote x, then the dot that wrote y, ... each recording only its
    // own freshly-renumbered component). A read that sees the value as a
    // full vector (all components at their final versions) then fails an
    // exact KeyOf lookup. Match any stored key that agrees with the
    // register on every component where both actually carry a version.
    // Callers must independently pin the value identity (e.g. the
    // normalize rule requires vec == the dotted operand) so a lenient match
    // can't reach across distinct SSA values.
    // Like KeyOf, but tolerant of the fact that a def key records only the
    // components its write actually touched (others null) while a later read
    // of one component carries the register's full live-version array. Match
    // any def key that agrees with the read register on every component where
    // both carry a version. The SSA version counter guarantees a def key
    // agrees with exactly the one (register, version) that produced it.
    private static bool TryGetDef(Dictionary<RegKey, IRExpression> defs, IRRegister reg, out IRExpression expr)
    {
        if (defs.TryGetValue(KeyOf(reg), out expr))
            return true;
        foreach (var (key, e) in defs)
        {
            if (key.Type != reg.RegisterType || key.Index != reg.Index) continue;
            int?[] kv = { key.V0, key.V1, key.V2, key.V3 };
            bool agrees = true;
            for (int c = 0; c < 4; c++)
            {
                int? a = kv[c];
                int? b = reg.SsaVersion[c];
                if (a is not null && b is not null && a != b) { agrees = false; break; }
            }
            if (agrees) { expr = e; return true; }
        }
        return false;
    }

    // The registers of two reads name the same SSA value when they are the
    // same physical register and agree on every component where both carry a
    // version. A swizzle read drops the components it doesn't touch (their
    // versions are null), so a strict full-array compare would reject the
    // same value read at different swizzle widths.
    private static bool SameRegisterValue(IRRegister a, IRRegister b)
    {
        if (a.RegisterType != b.RegisterType || a.Index != b.Index) return false;
        for (int c = 0; c < 4; c++)
        {
            int? av = a.SsaVersion[c];
            int? bv = b.SsaVersion[c];
            if (av is not null && bv is not null && av != bv) return false;
        }
        return true;
    }

    private static string? RelaxedName(Dictionary<RegKey, string> names, IRRegister reg)
    {
        if (names.TryGetValue(KeyOf(reg), out string? exact))
            return exact;
        foreach (var (key, name) in names)
        {
            if (key.Type != reg.RegisterType || key.Index != reg.Index) continue;
            bool agrees = true;
            int?[] kv = { key.V0, key.V1, key.V2, key.V3 };
            for (int c = 0; c < 4; c++)
            {
                int? a = kv[c];
                int? b = reg.SsaVersion[c];
                if (a is not null && b is not null && a != b) { agrees = false; break; }
            }
            if (agrees) return name;
        }
        return null;
    }

    // Resolves a constant-buffer read to its metadata name. The AST register
    // carries no SymbolicName for these — the only authoritative copy lives in
    // the RDEF-derived CbufferMetadata, and the printer is the only component
    // that has it (hence the pass running at print time).
    private static string? CbName(IRRegister reg, Dictionary<int, CbufferMetadata> cbuffers)
    {
        if (reg.RegisterType != RegisterType.ConstantBuffer) return null;
        if (reg.SymbolicName is not null) return reg.SymbolicName;
        if (!cbuffers.TryGetValue((int)reg.Indices[0], out CbufferMetadata? cb)) return null;
        return HlslPrettyPrinter.ResolveCbufferRead(cb, reg);
    }

    private static bool ReferencesAny(IRExpression expr, Func<IRRegister, bool> pred)
        => expr.CollectRegisterUses().Any(pred);

    // The single component a broadcast (Select1, or a swizzle whose four
    // slots are identical) reads, or null when the operand reads distinct
    // components. Mirrors the printer's ActiveComponents semantics.
    private static int? BroadcastComponent(IRRegister reg)
    {
        switch (reg.ComponentMode)
        {
            case Operand.OperandComponentMode.Select1:
                return reg.Component;
            case Operand.OperandComponentMode.Swizzle:
            {
                int c0 = reg.Swizzle & 3;
                int c1 = (reg.Swizzle >> 2) & 3;
                int c2 = (reg.Swizzle >> 4) & 3;
                int c3 = (reg.Swizzle >> 6) & 3;
                return c0 == c1 && c1 == c2 && c2 == c3 ? c0 : (int?)null;
            }
            default:
                return null;
        }
    }

    private static RegKey KeyOf(IRRegister reg) =>
        new(reg.RegisterType, reg.Index, reg.SsaVersion[0], reg.SsaVersion[1], reg.SsaVersion[2], reg.SsaVersion[3]);

    private static void SetName(Dictionary<RegKey, string> names, RegKey key, string name)
        => names.TryAdd(key, name);

    // The printer renders a symbolic name as "{name}_{letters}_{version}".
    // The printer renders a symbolic name as "{name}_{letters}_{version}".
    // Two DIFFERENT registers can produce the same identifier (e.g. two
    // registers both at version 5 named viewNormal) — but within a chain the
    // collision is between a partial sum and the LATER accumulator that
    // consumes it, so the newer claimer is the live value and should WIN the
    // identifier (the older register simply falls back to its rN name). The
    // claim table maps each identifier to the register that currently owns it;
    // a later claim revokes the earlier owner's name rather than leaving the
    // final accumulator unnamed.
    private static void TrySetName(Dictionary<RegKey, string> names, Dictionary<string, RegKey> claimed, IRRegister dest, string name)
    {
        RegKey key = KeyOf(dest);
        if (!TryClaim(names, dest, name, claimed, key)) return;
        SetName(names, key, name);
    }

    private static bool TryClaim(Dictionary<RegKey, string> names, IRRegister dest, string name, Dictionary<string, RegKey> claimed, RegKey key)
    {
        List<int> active = MaskIndices(dest.Mask);
        if (active.Count == 0) return true;

        bool ClaimOne(string id)
        {
            if (claimed.TryGetValue(id, out RegKey oldKey) && oldKey != key)
            {
                // An older value holds the identifier; if it carries the same
                // name it is a superseded chain step, so hand the name over.
                if (names.TryGetValue(oldKey, out string? oldName) && oldName == name)
                    names.Remove(oldKey);
            }
            claimed[id] = key;
            return true;
        }

        int? firstV = dest.SsaVersion[active[0]];
        if (firstV is not null && active.All(c => dest.SsaVersion[c] == firstV))
        {
            string letters = string.Concat(active.Select(c => ComponentLetters[c]));
            return ClaimOne(name + "_" + letters + "_" + firstV);
        }
        foreach (int c in active)
        {
            if (dest.SsaVersion[c] is not { } v) continue;
            ClaimOne(name + "_" + ComponentLetters[c] + "_" + v);
        }
        return true;
    }

    private const string ComponentLetters = "xyzw";

    private static List<int> MaskIndices(byte mask)
    {
        var result = new List<int>();
        if ((mask & 1) != 0) result.Add(0);
        if ((mask & 2) != 0) result.Add(1);
        if ((mask & 4) != 0) result.Add(2);
        if ((mask & 8) != 0) result.Add(3);
        return result;
    }

    // "_N_map" -> "NMap", "_MainTex" -> "MainTex" — a stable identifier
    // fragment, not a property name (properties keep their underscore form).
    private static string Camelize(string name)
    {
        string trimmed = name.TrimStart('_');
        var parts = trimmed.Split('_', StringSplitOptions.RemoveEmptyEntries);
        return string.Concat(parts.Where(p => p.Length > 0).Select(p => char.ToUpperInvariant(p[0]) + p[1..]));
    }
}