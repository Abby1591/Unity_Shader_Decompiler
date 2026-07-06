using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public sealed class IRRegister
{
    public RegisterType Type;

    public uint Index;

    public byte Mask;

    public override string ToString()
    {
        string mask = Mask switch
        {
            0 => "",
            1 => ".x",
            2 => ".y",
            4 => ".z",
            8 => ".w",
            3 => ".xy",
            7 => ".xyz",
            15 => ".xyzw",
            _ => ""
        };

        return $"{Type.ToString().ToLower()}{Index}{mask}";
    }
}