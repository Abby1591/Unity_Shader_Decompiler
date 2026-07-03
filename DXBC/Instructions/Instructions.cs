namespace Parser.DXBC.Instructions;

public class Instruction
{
    public Opcode Opcode;

    public uint OpcodeToken;

    public int Length;

    public List<uint> RawOperands { get; } = new();

    public List<Operand> Operands { get; } = new();
}