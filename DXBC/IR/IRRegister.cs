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

    public override string ToString()
    {
        string name = RegisterType switch
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

        string result = name + suffix;

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