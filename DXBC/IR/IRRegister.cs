using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public sealed class IRRegister
{
    public RegisterType Type;

    public uint Index;
    
    public List<uint> Indices { get; } = new();

    public byte Mask;

    public Operand.OperandComponentMode ComponentMode;

    public byte Swizzle;

    public byte Component;

    public ShdrParser.OperandModifier Modifier;

    public override string ToString()
    {
        string name = Type switch
        {
            RegisterType.Temp => $"r{Index}",
            RegisterType.Input => $"v{Index}",
            RegisterType.Output => $"o{Index}",
            RegisterType.ConstantBuffer =>
                Indices.Count >= 2
                    ? $"cb{Indices[0]}[{Indices[1]}]"
                    : $"cb{Index}",
            RegisterType.Resource => $"t{Index}",
            RegisterType.Sampler => $"s{Index}",
            _ => $"{Type.ToString().ToLower()}{Index}"
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