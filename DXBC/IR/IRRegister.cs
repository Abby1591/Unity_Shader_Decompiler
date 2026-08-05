using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public sealed class IRRegister
{
    // What kind of register it is (r#, v#, cb#, ...)
    public RegisterType RegisterType;

    // What data it stores
    public IRValueType Type = IRValueType.Unknown;

    public uint Index;

    public List<uint> Indices { get; } = new();

    // Dynamic/relative component of each index slot (e.g. cb0[r2.x + 4] or
    // x0[r2.y]). Parallel to Indices/IndexRepresentation on the source
    // Operand — null when that index slot is a plain immediate.
    public IRExpression?[] RelativeIndices { get; } = new IRExpression?[3];

    public byte Mask;

    public Operand.OperandComponentMode ComponentMode;

    public byte Swizzle;

    public byte Component;

    public ShdrParser.OperandModifier Modifier;

    // "precise" qualifier — real DXBC encodes this via a bitmask on the
    // extended opcode token (OPCODE_EXTENDED_TYPE == precision/precise info),
    // which ShdrParser doesn't decode yet (only Neg/Abs/AbsNeg modifiers are
    // currently extracted from the extension token). Field is provided so
    // downstream consumers can start threading it through; defaults false
    // until parser support lands.
    public bool Precise;

    // Human-readable name attached by IRMetadataBinding from the DXBC
    // container's own reflection chunks (RDEF cbuffer/variable names,
    // RDEF resource bindings, ISGN/OSGN semantic names). Null until that
    // pass runs, or for registers it has no metadata for (temps, indexable
    // temps). When set, ToString() uses it in place of the raw r#/cb#/t#
    // name — component-mask/swizzle and SSA-version suffixes still apply
    // on top of it, same as always.
    public string? SymbolicName;
    
    // SSA version number per component (index 0=x,1=y,2=z,3=w), filled in
    // by SSA renaming (Phase 7). Null until renamed — and stays null for
    // any component that's read before ever being written (an implicit
    // function input). Stored per-component rather than as one scalar on
    // the register because a single instruction can write several
    // components at once (mov r0.xy, ...) whose version histories then
    // diverge independently (only r0.x might get redefined later).
    public int?[] SsaVersion { get; } = new int?[4];

    // Registers referenced by dynamic/relative indexing on this register
    // (e.g. the r2 in cb0[r2.x + 4]). These are reads regardless of whether
    // this IRRegister itself is being used or defined — writing to
    // x0[r2.x] still reads r2.
    public IEnumerable<IRRegister> IndexRegisterUses()
    {
        foreach (IRExpression? relative in RelativeIndices)
        {
            if (relative is null)
                continue;

            foreach (IRRegister r in relative.CollectRegisterUses())
                yield return r;
        }
    }

    public override string ToString()
    {
        return ToStringAs(isDefinition: false);
    }

    // Render register with optional distinction for whether it's being defined
    // (written to) vs used. This affects SSA suffix rendering.
    public string ToStringAs(bool isDefinition)
    {
        string name = SymbolicName ?? RegisterType switch
        {
            RegisterType.Temp => $"r{Index}",
            RegisterType.Input => $"v{Index}",
            RegisterType.Output => $"o{Index}",
            RegisterType.ConstantBuffer =>
                Indices.Count >= 2
                    ? $"cb{IndexToString(0)}[{IndexToString(1)}]"
                    : $"cb{Index}",
            RegisterType.Resource => $"t{Index}",
            RegisterType.Sampler => $"s{Index}",
            RegisterType.IndexableTemp =>
                Indices.Count >= 1
                    ? $"x{IndexToString(0)}[{(Indices.Count >= 2 ? IndexToString(1) : "0")}]"
                    : $"x{Index}",
            _ => $"{RegisterType.ToString().ToLower()}{Index}"
        };

        string suffix = ComponentMode switch
        {
            Operand.OperandComponentMode.Mask => MaskToString(Mask),
            Operand.OperandComponentMode.Swizzle => SwizzleToString(Swizzle),
            Operand.OperandComponentMode.Select1 => "." + ComponentToChar(Component),
            _ => ""
        };

        string result = name + suffix + SsaSuffix(isDefinition);

        result = Modifier switch
        {
            ShdrParser.OperandModifier.Neg => "-" + result,
            ShdrParser.OperandModifier.Abs => $"abs({result})",
            ShdrParser.OperandModifier.AbsNeg => $"-abs({result})",
            _ => result
        };

        return result;
    }

    // Renders index slot i, combining a dynamic component (from relative
    // addressing, e.g. r2.x) with any constant offset that accompanies it
    // (the "Immediate32PlusRelative" case — cb0[r2.x + 4]).
    private string IndexToString(int i)
    {
        IRExpression? relative = i < RelativeIndices.Length ? RelativeIndices[i] : null;

        if (relative is not null)
        {
            uint constantOffset = Indices.Count > i ? Indices[i] : 0;

            return constantOffset != 0
                ? $"{relative} + {constantOffset}"
                : relative.ToString()!;
        }

        return Indices.Count > i ? Indices[i].ToString() : "0";
    }

    private static string MaskToString(byte mask)
    {
        if (mask == 0)
            return "";

        string s = ".";

        if ((mask & 1) != 0) s += "x";
        if ((mask & 2) != 0) s += "y";
        if ((mask & 4) != 0) s += "z";
        if ((mask & 8) != 0) s += "w";

        return s;
    }

    private static string SwizzleToString(byte swizzle)
    {
        char[] chars = new char[4];

        chars[0] = ComponentToChar((byte)(swizzle & 3));
        chars[1] = ComponentToChar((byte)((swizzle >> 2) & 3));
        chars[2] = ComponentToChar((byte)((swizzle >> 4) & 3));
        chars[3] = ComponentToChar((byte)((swizzle >> 6) & 3));

        return "." + new string(chars);
    }

    // Debug-display only: "_N" once renamed, so a statement can be printed
    // as e.g. "r0.x_1 = r0.x_0 + r1.y_2". 
    // Note: SSA versions differ between uses and definitions:
    // - For USES (right-hand side): show distinct versions of accessed components
    // - For DEFINITIONS (left-hand side): show per-component versions (no dedup)
    // Since we can't distinguish context here, we generate both and let the
    // caller choose which is appropriate via isDefinition parameter.
    private string SsaSuffix(bool isDefinition = false)
    {
        List<int> indices = ComponentMode switch
        {
            Operand.OperandComponentMode.Mask => MaskComponentIndices(Mask),
            Operand.OperandComponentMode.Swizzle => new List<int>
            {
                Swizzle & 3, (Swizzle >> 2) & 3, (Swizzle >> 4) & 3, (Swizzle >> 6) & 3
            },
            Operand.OperandComponentMode.Select1 => new List<int> { Component },
            _ => new List<int>()
        };

        List<int> versions = indices
            .Select(i => SsaVersion[i])
            .Where(v => v.HasValue)
            .Select(v => v!.Value)
            .ToList();

        // For uses: apply Distinct() to show which distinct versions are live.
        // For definitions: keep all versions (one per component assigned).
        if (!isDefinition)
            versions = versions.Distinct().ToList();

        if (versions.Count == 0)
            return "";

        if (versions.Count == 1)
            return $"_{versions[0]}";

        // Comma-separated rather than concatenated: once any component's
        // version hits double digits, plain concatenation (e.g. "_71066")
        // is ambiguous and can't be split back into per-component versions.
        return "_" + string.Join(",", versions);
    }

    private static List<int> MaskComponentIndices(byte mask)
    {
        var result = new List<int>();
        if ((mask & 1) != 0) result.Add(0);
        if ((mask & 2) != 0) result.Add(1);
        if ((mask & 4) != 0) result.Add(2);
        if ((mask & 8) != 0) result.Add(3);
        return result;
    }

    private static char ComponentToChar(byte c)
    {
        return c switch
        {
            0 => 'x',
            1 => 'y',
            2 => 'z',
            3 => 'w',
            _ => '?'
        };
    }
}