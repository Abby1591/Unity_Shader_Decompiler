namespace Parser.DXBC.Instructions;

public class Operand
{
    public RegisterType RegisterType;

    public uint RegisterIndex;

    public byte Mask;

    public byte[] Swizzle = new byte[4];

    public int ImmediateValue;
}