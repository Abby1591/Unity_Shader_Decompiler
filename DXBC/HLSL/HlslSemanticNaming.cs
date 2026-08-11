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

        // Definition map used by the normalize rule to chase a length holder
        // (rsqrt(dot(v,v))) back to the vector it was computed from.
        var defs = new Dictionary<RegKey, IRExpression>();
        foreach (var (dest, expr) in assignments)
            defs.TryAdd(KeyOf(dest), expr);

        var names = new Dictionary<RegKey, string>();

        foreach (var (dest, expr) in assignments)
        {
            switch (expr)
            {
                case IRExpression.BinaryExpression { Operation: IRExpression.BinaryOperation.Add } add:
                    NameCameraVector(names, dest, add, cbuffers);
                    break;

                case IRExpression.BinaryExpression mul when mul.Operation == IRExpression.BinaryOperation.Multiply:
                    NameNormalizeMul(names, dest, mul, defs);
                    break;

                case IRExpression.FusedMultiplyAddExpression fma:
                    NameObjectToWorldPos(names, dest, fma, cbuffers);
                    NameUvChain(names, dest, fma, cbuffers);
                    break;

                case IRExpression.IntrinsicExpression { Intrinsic: IRExpression.IRIntrinsic.Normalize } norm:
                    NameNormalize(names, dest, norm.Arguments);
                    break;

                case IRExpression.DotProductExpression dot:
                    NameWorldNormalDot(names, dest, dot, cbuffers);
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
        Dictionary<int, CbufferMetadata> cbuffers)
    {
        if (!ReferencesAny(fma, r => r.RegisterType == RegisterType.Input
            && (r.SymbolicName ?? "").StartsWith("TEXCOORD"))) return;

        string? stName = null;
        foreach (IRRegister r in fma.CollectRegisterUses())
        {
            if (r.RegisterType == RegisterType.ConstantBuffer
                && CbName(r, cbuffers) is { } sn
                && sn.Split('.')[0].EndsWith("_ST", StringComparison.Ordinal))
            {
                stName = sn;
                break;
            }
        }
        if (stName is null) return;

        SetName(names, KeyOf(dest), "uv" + Camelize(stName.Split('.')[0][..^3]));
    }

    // worldNormal via the fragment idiom dot(normal, WorldToObject[row]);
    // each dotted component is one row of the object->world normal transform.
    private static void NameWorldNormalDot(
        Dictionary<RegKey, string> names,
        IRRegister dest,
        IRExpression.DotProductExpression dot,
        Dictionary<int, CbufferMetadata> cbuffers)
    {
        if (!ReferencesAny(dot, r => r.RegisterType == RegisterType.Input && (r.SymbolicName ?? "").StartsWith("NORMAL"))) return;
        if (!ReferencesAny(dot, r => r.RegisterType == RegisterType.ConstantBuffer
            && CbName(r, cbuffers) is { } sn && sn.StartsWith(WorldToObject, StringComparison.Ordinal))) return;
        SetName(names, KeyOf(dest), "worldNormal");
    }

    private static void NameSample(
        Dictionary<RegKey, string> names,
        IRRegister dest,
        IRExpression.TextureOperationExpression sample)
    {
        if (string.IsNullOrEmpty(sample.Resource.SymbolicName)) return;
        SetName(names, KeyOf(dest), "sample" + Camelize(sample.Resource.SymbolicName));
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

            if (!defs.TryGetValue(KeyOf(len.Register), out IRExpression? lenDef)) continue;
            if (lenDef is not IRExpression.IntrinsicExpression { Intrinsic: IRExpression.IRIntrinsic.Rsqrt } rs) continue;
            if (rs.Arguments.Count == 0 || rs.Arguments[0] is not IRExpression.RegisterExpression lenArg) continue;
            if (!defs.TryGetValue(KeyOf(lenArg.Register), out IRExpression? dotDef)) continue;
            if (dotDef is not IRExpression.DotProductExpression dot) continue;
            if (dot.Left is not IRExpression.RegisterExpression d0 || dot.Right is not IRExpression.RegisterExpression d1) continue;
            if (KeyOf(d0.Register) != KeyOf(d1.Register)) continue;
            if (KeyOf(vec.Register) != KeyOf(d0.Register)) continue;

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

    private static RegKey KeyOf(IRRegister reg) =>
        new(reg.RegisterType, reg.Index, reg.SsaVersion[0], reg.SsaVersion[1], reg.SsaVersion[2], reg.SsaVersion[3]);

    private static void SetName(Dictionary<RegKey, string> names, RegKey key, string name)
        => names.TryAdd(key, name);

    // "_N_map" -> "NMap", "_MainTex" -> "MainTex" — a stable identifier
    // fragment, not a property name (properties keep their underscore form).
    private static string Camelize(string name)
    {
        string trimmed = name.TrimStart('_');
        var parts = trimmed.Split('_', StringSplitOptions.RemoveEmptyEntries);
        return string.Concat(parts.Where(p => p.Length > 0).Select(p => char.ToUpperInvariant(p[0]) + p[1..]));
    }
}