namespace Parser.DXBC.Instructions;

public class Operand
{
    public RegisterType RegisterType { get; set; }

    public uint RegisterIndex { get; set; }

    public int NumComponents { get; set; }

    public int SelectionMode { get; set; }

    public int IndexDimension { get; set; }

    public bool IsExtended { get; set; }

    public byte Mask { get; set; }

    public byte Swizzle { get; set; }

    public byte Component { get; set; }

    public List<uint> Indices { get; } = new();
    
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
        switch (SelectionMode)
        {
            case 0:
                return "." + DecodeMask(Mask);

            case 1:
                return "." + DecodeSwizzle(Swizzle);

            case 2:
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
    
}