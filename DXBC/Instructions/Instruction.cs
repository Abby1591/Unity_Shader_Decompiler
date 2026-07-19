namespace Parser.DXBC.Instructions;

public enum InstructionTestBoolean
{
    Zero = 0,
    NonZero = 1
}

public class Instruction
{
    public uint OpcodeToken;

    public Opcode Opcode;

    public int Length;
    
    public List<uint> ExtraData { get; } = new();
    
    public List<Operand> Operands { get; } = new();
    
    public string Name = "";

    // bit 13 of the opcode token
    public bool Saturate;

    // bit 31 of the opcode token
    public bool HasExtendedOpcode;

    // bit 18 of the opcode token (used by breakc/if/etc.)
    public InstructionTestBoolean TestBoolean;

    // raw DWORD(s) consumed for an extended opcode chain (only the
    // first is kept for now - later this should be decoded into
    // aoffimmi / resource-return-type / etc.)
    public uint ExtendedOpcode;

    // CUSTOMDATA (opcode 53) is the only instruction whose length is
    // not derived from bits 24-30 of the opcode token - it has its
    // own length DWORD immediately following, followed by raw bytes.
    public uint CustomDataLength;
    public byte[]? CustomData;
}