namespace Parser.DXBC.Instructions;

public class ShaderInstruction
{
    public uint OpcodeToken { get; set; }

    public int Opcode { get; set; }

    public int Length { get; set; }

    public List<uint> Operands { get; } = new();
}