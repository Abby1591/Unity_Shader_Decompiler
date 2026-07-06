using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public sealed class IRRegister
{
    public RegisterType Type;

    public uint Index;

    public byte Mask;

    public byte Swizzle;

    public Operand.OperandComponentMode ComponentMode;
}