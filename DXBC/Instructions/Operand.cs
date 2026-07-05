namespace Parser.DXBC.Instructions;

public class Operand
{
    public RegisterType RegisterType { get; set; }

    public uint RegisterIndex { get; set; }

    public int NumComponents { get; set; }

    public OperandComponentMode ComponentMode;

    public OperandIndexRepresentation[] IndexRepresentation = new OperandIndexRepresentation[3];

    public bool IsExtended { get; set; }

    public byte Mask { get; set; }

    public byte Swizzle { get; set; }

    public byte Component { get; set; }

    public List<uint> Indices { get; } = new();
    
    public float[]? Immediate32Values;
    
    public double[]? Immediate64Values;
    
    public Operand?[] RelativeOperands = new Operand?[3];
    
    public ShdrParser.OperandModifier Modifier { get; set; } = ShdrParser.OperandModifier.None;
    
    private static string DecodeSwizzle(byte swizzle)
    {
        char[] c = { 'x', 'y', 'z', 'w' };

        return new string(new[]
        {
            c[(swizzle >> 0) & 3],
            c[(swizzle >> 2) & 3],
            c[(swizzle >> 4) & 3],
            c[(swizzle >> 6) & 3]
        });
    }
    
    public string GetComponentString()
    {
        switch (ComponentMode)
        {
            case OperandComponentMode.Mask:
                return "." + DecodeMask(Mask);

            case OperandComponentMode.Swizzle:
                return "." + DecodeSwizzle(Swizzle);

            case OperandComponentMode.Select1:
                return "." + "xyzw"[Component];

            default:
                return "";
        }
    }
    
    private static string DecodeMask(byte mask)
    {
        string s = "";

        if ((mask & 1) != 0) s += "x";
        if ((mask & 2) != 0) s += "y";
        if ((mask & 4) != 0) s += "z";
        if ((mask & 8) != 0) s += "w";

        return s;
    }
    
    public override string ToString()
    {
        if (RegisterType == RegisterType.Immediate32 && Immediate32Values != null)
            return "l(" + string.Join(", ", Immediate32Values) + ")";

        if (RegisterType == RegisterType.Immediate64 && Immediate64Values != null)
            return "d(" + string.Join(", ", Immediate64Values) + ")";
        
        string reg = RegisterType switch
        {
            RegisterType.Temp => $"r{RegisterIndex}",
            RegisterType.Input => $"v{RegisterIndex}",
            RegisterType.Output => $"o{RegisterIndex}",
            RegisterType.ConstantBuffer => $"cb{RegisterIndex}",
            RegisterType.Resource => $"t{RegisterIndex}",
            RegisterType.Sampler => $"s{RegisterIndex}",
            RegisterType.Immediate32 => "l",
            RegisterType.Null => "null",
            _ => $"{RegisterType}{RegisterIndex}"
        };

        return reg + GetComponentString();
    }
    
    public enum OperandNumComponents
    {
        Zero = 0,
        One = 1,
        Four = 2,
        N = 3
    }

    public enum OperandComponentSelectionMode
    {
        Mask = 0,
        Swizzle = 1,
        Select1 = 2
    }
    
    
    public enum OperandComponentMode
    {
        Mask = 0,
        Swizzle = 1,
        Select1 = 2
    }

    public enum OperandIndexRepresentation
    {
        Immediate32 = 0,
        Immediate64 = 1,
        Relative = 2,
        Immediate32PlusRelative = 3,
        Immediate64PlusRelative = 4
    }
    
}