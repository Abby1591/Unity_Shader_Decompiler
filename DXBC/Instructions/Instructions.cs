namespace Parser.DXBC.Instructions;

public class Instruction
{
    public uint OpcodeToken;

    public Opcode Opcode;

    public int Length;
    
    public List<uint> ExtraData { get; } = new();
    
    public List<Operand> Operands { get; } = new();
    
    public string Name = "";
}