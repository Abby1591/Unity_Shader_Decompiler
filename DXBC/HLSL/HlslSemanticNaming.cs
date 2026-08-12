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
                    break;

                case IRExpression.BinaryExpression mul when mul.Operation == IRExpression.BinaryOperation.Multiply:
                    NameMatrixProduct(names, claimed, dest, mul, cbuffers, matrixChains);
                    NameViewNormalChain(names, claimed, dest, mul, defs, normalChains);
                    NameNormalizeMul(names, dest, mul, defs);
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
                    NameNdotV(names, dest, dot);
                    break;

                case IRExpression.TextureOperationExpression { Operation: IRExpression.TextureOperation.Sample } sample:
                    NameSample(names, dest, sample);
                    break;
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
        (IRRegister? posReg, IRRegister? camReg) = DetectCameraAdd(add, cbuffers);
        if (posReg is null) return;

        bool posNeg = posReg.Modifier == ShdrParser.OperandModifier.Neg;

        SetName(names, KeyOf(posReg), "worldPos");
        SetName(names, KeyOf(dest), posNeg ? "viewDir" : "dirToSurface");
    }

    private static (IRRegister? Position, IRRegister? Camera) DetectCameraAdd(
        IRExpression.BinaryExpression add,
        Dictionary<int, CbufferMetadata> cbuffers)
    {
        for (int side = 0; side < 2; side++)
        {
            IRExpression posSide = side == 0 ? add.Left : add.Right;
            IRExpression camSide = side == 0 ? add.Right : add.Left;

            if (posSide is not IRExpression.RegisterExpression { Register: { RegisterType: RegisterType.Temp } pos }) continue;
            if (camSide is not IRExpression.RegisterExpression { Register: { RegisterType: RegisterType.ConstantBuffer } cam }) continue;
            if (CbName(cam, cbuffers) != CameraPos) continue;

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

        bool hasNamedOperand = ReferencesAny(add, r => r.RegisterType is RegisterType.Temp or RegisterType.IndexableTemp
            && (r.SymbolicName is not null || RelaxedName(names, r) is not null));
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
    // the result is unit<thatname> — never an unverified guess.
    private static void NameNormalizeMul(
        Dictionary<RegKey, string> names,
        IRRegister dest,
        IRExpression.BinaryExpression mul,
        Dictionary<RegKey, IRExpression> defs)
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

            if (RelaxedName(names, vec.Register) is { } baseName)
                SetName(names, KeyOf(dest), UnitPrefix(baseName));
            return;
        }
    }

    // dot of two named unit vectors — the classic NdotV/rim input.
    private static void NameNdotV(
        Dictionary<RegKey, string> names,
        IRRegister dest,
        IRExpression.DotProductExpression dot)
    {
        if (dot.Left is not IRExpression.RegisterExpression n || dot.Right is not IRExpression.RegisterExpression v) return;
        string? nb = BaseName(names, n.Register);
        string? vb = BaseName(names, v.Register);
        if (nb is not null && nb.StartsWith("unit", StringComparison.Ordinal)
            && vb is not null && vb.StartsWith("unit", StringComparison.Ordinal))
            SetName(names, KeyOf(dest), "nDotV");
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