namespace Parser.DXBC.Instructions;

public enum InstructionTestBoolean
{
    Zero = 0,
    NonZero = 1
}

public class Instruction
{
    // Position of this instruction within ShdrParser.Instructions, set
    // by the parser as each instruction is emitted. Makes it easy to
    // refer back to "the Nth instruction" in later IR/decompiler passes.
    public int InstructionIndex;

    public uint OpcodeToken;

    public Opcode Opcode;

    public uint OpcodeId;
    
    public uint OpcodeControls;
    
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

    // Extended opcode type 2: resource dimension (e.g. on ld_structured /
    // ld_raw variants that carry it inline rather than via dcl_resource).
    public bool HasResourceDim;
    public uint ResourceDim;
    public uint ResourceStructureStride;

    // Extended opcode type 3: resource return type, one 4-bit component
    // type (x/y/z/w) per return component.
    public bool HasResourceReturnType;
    public uint ResourceReturnTypeX;
    public uint ResourceReturnTypeY;
    public uint ResourceReturnTypeZ;
    public uint ResourceReturnTypeW;

    // CUSTOMDATA (opcode 53) is the only instruction whose length is
    // not derived from bits 24-30 of the opcode token - it has its
    // own length DWORD immediately following, followed by raw bytes.
    public uint CustomDataLength;
    public byte[]? CustomData;

    // dcl_input_ps only: interpolation mode, encoded in bits 11-14 of
    // the opcode token itself (not a trailing DWORD).
    public Parser.DXBC.IR.InterpolationMode Interpolation = Parser.DXBC.IR.InterpolationMode.Undefined;

    // sync (opcode 190) only: which memory/execution barriers this sync
    // covers, decoded from the opcode-specific control bits of the token
    // (D3D11_SB_SYNC_* - bits 11-14). Verified against Microsoft's
    // d3d11TokenizedProgramFormat.hpp.
    public bool SyncThreadsInGroup;
    public bool SyncThreadGroupSharedMemory;
    public bool SyncUAVMemoryGroup;
    public bool SyncUAVMemoryGlobal;

    // dcl_resource only: resource dimension (D3D10_SB_RESOURCE_DIMENSION),
    // bits 11-15 of the opcode token. Also present (raw) as ExtraData[0]
    // for backward compatibility with existing consumers; this is just a
    // named accessor so callers don't need to know the ExtraData index.
    public Parser.DXBC.IR.ResourceDimension? DeclaredResourceDimension;
}