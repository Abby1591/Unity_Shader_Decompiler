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

    // raw DWORD(s) consumed for an extended opcode chain (kept for
    // reference/debugging; decoded fields below hold the actual data).
    public uint ExtendedOpcode;

    // "precise" flags (bits 19-22 of the opcode token) - one bit per
    // component (x/y/z/w) requesting IEEE-precise evaluation.
    public byte Precise;

    // Decoded sample_controls (aoffimmi) extended opcode token, present
    // on ld/sample/gather4/etc. Each offset is a signed 4-bit immediate
    // in the range -8..7 texel offset.
    public bool HasSampleControls;
    public sbyte AoffimmiU;
    public sbyte AoffimmiV;
    public sbyte AoffimmiW;

    // CUSTOMDATA (opcode 53) is the only instruction whose length is
    // not derived from bits 24-30 of the opcode token - it has its
    // own length DWORD immediately following, followed by raw bytes.
    public uint CustomDataLength;
    public byte[]? CustomData;
}