namespace Parser.DXBC.Instructions;

// D3D10_SB_TOKENIZED_PROGRAM_TYPE - decoded from bits 16-31 of the
// shader version token.
public enum ShaderProgramType
{
    Pixel = 0,
    Vertex = 1,
    Geometry = 2,
    Hull = 3,
    Domain = 4,
    Compute = 5,
    Unknown = 0xFFFF
}

public class ShdrParser
{
    public uint VersionToken { get; private set; }
    public uint DeclaredDwordCount { get; private set; }

    // Decoded from VersionToken: bits 0-3 minor version, bits 4-7 major
    // version, bits 16-31 program type (shader stage).
    public uint MinorVersion { get; private set; }
    public uint MajorVersion { get; private set; }
    public ShaderProgramType ProgramType { get; private set; }

    // Human-readable shader model string, e.g. "ps_5_0", "vs_4_1", "cs_5_0".
    public string ShaderModel =>
        $"{ProgramTypeAbbreviation(ProgramType)}_{MajorVersion}_{MinorVersion}";

    // Number of instructions actually decoded (distinct from
    // DeclaredDwordCount, which is the total DWORD length of the program
    // including the two header DWORDs, not an instruction tally).
    public int InstructionCount => Instructions.Count;

    private static string ProgramTypeAbbreviation(ShaderProgramType type) => type switch
    {
        ShaderProgramType.Pixel => "ps",
        ShaderProgramType.Vertex => "vs",
        ShaderProgramType.Geometry => "gs",
        ShaderProgramType.Hull => "hs",
        ShaderProgramType.Domain => "ds",
        ShaderProgramType.Compute => "cs",
        _ => "unknown"
    };

    public List<Instruction> Instructions { get; } = new();
    public List<string> Warnings { get; } = new();

    private static readonly Dictionary<uint, OpcodeInfo> OpcodeTable = new()
    {
        { 0, new() { Opcode = Opcode.Add, Name = "add", OperandCount = 3 } },
        { 1, new() { Opcode = Opcode.And, Name = "and", OperandCount = 3 } },
        { 2, new() { Opcode = Opcode.Break, Name = "break", OperandCount = 0 } },
        { 3, new() { Opcode = Opcode.BreakC, Name = "breakc", OperandCount = 1 } },
        { 4, new() { Opcode = Opcode.Call, Name = "call", OperandCount = 1 } },
        { 5, new() { Opcode = Opcode.CallC, Name = "callc", OperandCount = 2 } },
        { 6, new() { Opcode = Opcode.Case, Name = "case", OperandCount = 1 } },
        { 7, new() { Opcode = Opcode.Continue, Name = "continue", OperandCount = 0 } },
        { 8, new() { Opcode = Opcode.ContinueC, Name = "continuec", OperandCount = 1 } },
        { 9, new() { Opcode = Opcode.Cut, Name = "cut", OperandCount = 0 } },
        { 10, new() { Opcode = Opcode.Default, Name = "default", OperandCount = 0 } },
        { 11, new() { Opcode = Opcode.DerivRtx, Name = "deriv_rtx", OperandCount = 2 } },
        { 12, new() { Opcode = Opcode.DerivRty, Name = "deriv_rty", OperandCount = 2 } },
        { 13, new() { Opcode = Opcode.Discard, Name = "discard", OperandCount = 1 } },
        { 14, new() { Opcode = Opcode.Div, Name = "div", OperandCount = 3 } },
        { 15, new() { Opcode = Opcode.Dp2, Name = "dp2", OperandCount = 3 } },
        { 16, new() { Opcode = Opcode.Dp3, Name = "dp3", OperandCount = 3 } },
        { 17, new() { Opcode = Opcode.Dp4, Name = "dp4", OperandCount = 3 } },
        { 18, new() { Opcode = Opcode.Else, Name = "else", OperandCount = 0 } },
        { 19, new() { Opcode = Opcode.Emit, Name = "emit", OperandCount = 0 } },
        { 20, new() { Opcode = Opcode.EmitThenCut, Name = "emitThenCut", OperandCount = 0 } },
        { 21, new() { Opcode = Opcode.EndIf, Name = "endif", OperandCount = 0 } },
        { 22, new() { Opcode = Opcode.EndLoop, Name = "endloop", OperandCount = 0 } },
        { 23, new() { Opcode = Opcode.EndSwitch, Name = "endswitch", OperandCount = 0 } },
        { 24, new() { Opcode = Opcode.Eq, Name = "eq", OperandCount = 3 } },
        { 25, new() { Opcode = Opcode.Exp, Name = "exp", OperandCount = 2 } },
        { 26, new() { Opcode = Opcode.Frc, Name = "frc", OperandCount = 2 } },
        { 27, new() { Opcode = Opcode.Ftoi, Name = "ftoi", OperandCount = 2 } },
        { 28, new() { Opcode = Opcode.Ftou, Name = "ftou", OperandCount = 2 } },
        { 29, new() { Opcode = Opcode.GE, Name = "ge", OperandCount = 3 } },
        { 30, new() { Opcode = Opcode.IAdd, Name = "iadd", OperandCount = 3 } },
        { 31, new() { Opcode = Opcode.If, Name = "if", OperandCount = 1 } },
        { 32, new() { Opcode = Opcode.IEq, Name = "ieq", OperandCount = 3 } },
        { 33, new() { Opcode = Opcode.IGe, Name = "ige", OperandCount = 3 } },
        { 34, new() { Opcode = Opcode.ILt, Name = "ilt", OperandCount = 3 } },
        { 35, new() { Opcode = Opcode.IMad, Name = "imad", OperandCount = 4 } },
        { 36, new() { Opcode = Opcode.IMax, Name = "imax", OperandCount = 3 } },
        { 37, new() { Opcode = Opcode.IMin, Name = "imin", OperandCount = 3 } },
        { 38, new() { Opcode = Opcode.IMul, Name = "imul", OperandCount = 4 } },
        { 39, new() { Opcode = Opcode.INe, Name = "ine", OperandCount = 3 } },
        { 40, new() { Opcode = Opcode.INeg, Name = "ineg", OperandCount = 2 } },
        { 41, new() { Opcode = Opcode.Ishl, Name = "ishl", OperandCount = 3 } },
        { 42, new() { Opcode = Opcode.Ishr, Name = "ishr", OperandCount = 3 } },
        { 43, new() { Opcode = Opcode.Itof, Name = "itof", OperandCount = 2 } },
        { 44, new() { Opcode = Opcode.Label, Name = "label", OperandCount = 1 } },
        { 45, new() { Opcode = Opcode.Ld, Name = "ld", OperandCount = 3 } },
        { 46, new() { Opcode = Opcode.LdMS, Name = "ld2dms", OperandCount = 4 } },
        { 47, new() { Opcode = Opcode.Log, Name = "log", OperandCount = 2 } },
        { 48, new() { Opcode = Opcode.Loop, Name = "loop", OperandCount = 0 } },
        { 49, new() { Opcode = Opcode.Lt, Name = "lt", OperandCount = 3 } },
        { 50, new() { Opcode = Opcode.Mad, Name = "mad", OperandCount = 4 } },
        { 51, new() { Opcode = Opcode.Min, Name = "min", OperandCount = 3 } },
        { 52, new() { Opcode = Opcode.Max, Name = "max", OperandCount = 3 } },
        { 53, new() { Opcode = Opcode.CustomData, Name = "customdata", OperandCount = 0 } },
        { 54, new() { Opcode = Opcode.Mov, Name = "mov", OperandCount = 2 } },
        { 55, new() { Opcode = Opcode.MovC, Name = "movc", OperandCount = 4 } },
        { 56, new() { Opcode = Opcode.Mul, Name = "mul", OperandCount = 3 } },
        { 57, new() { Opcode = Opcode.Ne, Name = "ne", OperandCount = 3 } },
        { 58, new() { Opcode = Opcode.Nop, Name = "nop", OperandCount = 0 } },
        { 59, new() { Opcode = Opcode.Not, Name = "not", OperandCount = 2 } },
        { 60, new() { Opcode = Opcode.Or, Name = "or", OperandCount = 3 } },
        { 61, new() { Opcode = Opcode.ResInfo, Name = "resinfo", OperandCount = 3 } },
        { 62, new() { Opcode = Opcode.Ret, Name = "ret", OperandCount = 0 } },
        { 63, new() { Opcode = Opcode.Retc, Name = "retc", OperandCount = 1 } },
        { 64, new() { Opcode = Opcode.RoundNE, Name = "round_ne", OperandCount = 2 } },
        { 65, new() { Opcode = Opcode.RoundNI, Name = "round_ni", OperandCount = 2 } },
        { 66, new() { Opcode = Opcode.RoundPI, Name = "round_pi", OperandCount = 2 } },
        { 67, new() { Opcode = Opcode.RoundZ, Name = "round_z", OperandCount = 2 } },
        { 68, new() { Opcode = Opcode.Rsq, Name = "rsq", OperandCount = 2 } },
        { 69, new() { Opcode = Opcode.Sample, Name = "sample", OperandCount = 4 } },
        { 70, new() { Opcode = Opcode.SampleC, Name = "sample_c", OperandCount = 5 } },
        { 71, new() { Opcode = Opcode.SampleCLZ, Name = "sample_c_lz", OperandCount = 5 } },
        { 72, new() { Opcode = Opcode.SampleL, Name = "sample_l", OperandCount = 5 } },
        { 73, new() { Opcode = Opcode.SampleD, Name = "sample_d", OperandCount = 6 } },
        { 74, new() { Opcode = Opcode.SampleB, Name = "sample_b", OperandCount = 5 } },
        { 75, new() { Opcode = Opcode.Sqrt, Name = "sqrt", OperandCount = 2 } },
        { 76, new() { Opcode = Opcode.Switch, Name = "switch", OperandCount = 1 } },
        { 77, new() { Opcode = Opcode.SinCos, Name = "sincos", OperandCount = 3 } },
        { 78, new() { Opcode = Opcode.UDiv, Name = "udiv", OperandCount = 4 } },
        { 79, new() { Opcode = Opcode.Ult, Name = "ult", OperandCount = 3 } },
        { 80, new() { Opcode = Opcode.Uge, Name = "uge", OperandCount = 3 } },
        { 81, new() { Opcode = Opcode.UMul, Name = "umul", OperandCount = 4 } },
        { 82, new() { Opcode = Opcode.UMad, Name = "umad", OperandCount = 4 } },
        { 83, new() { Opcode = Opcode.UMax, Name = "umax", OperandCount = 3 } },
        { 84, new() { Opcode = Opcode.UMin, Name = "umin", OperandCount = 3 } },
        { 85, new() { Opcode = Opcode.Ushr, Name = "ushr", OperandCount = 3 } },
        { 86, new() { Opcode = Opcode.Utof, Name = "utof", OperandCount = 2 } },
        { 87, new() { Opcode = Opcode.Xor, Name = "xor", OperandCount = 3 } },
        { 88, new() { Opcode = Opcode.DclResource, Name = "dcl_resource", OperandCount = 1 } },
        { 89, new() { Opcode = Opcode.DclConstantBuffer, Name = "dcl_constantbuffer", OperandCount = 1 } },
        { 90, new() { Opcode = Opcode.DclSampler, Name = "dcl_sampler", OperandCount = 1 } },
        { 91, new() { Opcode = Opcode.DclIndexRange, Name = "dcl_indexrange", OperandCount = 2 } },
        { 92, new() { Opcode = Opcode.DclOutputTopology, Name = "dcl_outputtopology", OperandCount = 0 } },
        { 95, new() { Opcode = Opcode.DclInput, Name = "dcl_input", OperandCount = 1 } },
        { 96, new() { Opcode = Opcode.DclInputSVG, Name = "dcl_input_sgv", OperandCount = 1 } },
        { 98, new() { Opcode = Opcode.DclInputPS, Name = "dcl_input_ps", OperandCount = 1 } },
        { 101, new() { Opcode = Opcode.DclOutput, Name = "dcl_output", OperandCount = 1 } },
        { 103, new() { Opcode = Opcode.DclOutputSIV, Name = "dcl_output_siv", OperandCount = 1 } },
        { 104, new() { Opcode = Opcode.DclTemps, Name = "dcl_temps", OperandCount = 0 } },
        { 105, new() { Opcode = Opcode.DclIndexableTemp, Name = "dcl_indexabletemp", OperandCount = 0 } },
        { 106, new() { Opcode = Opcode.DclGlobalFlags, Name = "dcl_globalFlags", OperandCount = 0 } },
        { 108, new() { Opcode = Opcode.Lod, Name = "lod", OperandCount = 4 } },
        { 109, new() { Opcode = Opcode.Gather4, Name = "gather4", OperandCount = 4 } },
        { 110, new() { Opcode = Opcode.SamplePos, Name = "sample_pos", OperandCount = 3 } },
        { 111, new() { Opcode = Opcode.SampleInfo, Name = "sample_info", OperandCount = 2 } },
        { 114, new() { Opcode = Opcode.HSControlPointPhase, Name = "hs_control_point_phase", OperandCount = 0 } },
        { 115, new() { Opcode = Opcode.HSForkPhase, Name = "hs_fork_phase", OperandCount = 0 } },
        { 116, new() { Opcode = Opcode.HSJoinPhase, Name = "hs_join_phase", OperandCount = 0 } },
        { 117, new() { Opcode = Opcode.EmitStream, Name = "emit_stream", OperandCount = 1 } },
        { 118, new() { Opcode = Opcode.CutStream, Name = "cut_stream", OperandCount = 1 } },
        { 121, new() { Opcode = Opcode.BufInfo, Name = "bufinfo", OperandCount = 2 } },
        { 122, new() { Opcode = Opcode.DerivRtxCoarse, Name = "deriv_rtx_coarse", OperandCount = 2 } },
        { 123, new() { Opcode = Opcode.DerivRtxFine, Name = "deriv_rtx_fine", OperandCount = 2 } },
        { 124, new() { Opcode = Opcode.DerivRtyCoarse, Name = "deriv_rty_coarse", OperandCount = 2 } },
        { 125, new() { Opcode = Opcode.DerivRtyFine, Name = "deriv_rty_fine", OperandCount = 2 } },
        { 126, new() { Opcode = Opcode.Gather4C, Name = "gather4_c", OperandCount = 5 } },
        { 127, new() { Opcode = Opcode.Gather4Po, Name = "gather4_po", OperandCount = 5 } },
        { 128, new() { Opcode = Opcode.Gather4PoC, Name = "gather4_po_c", OperandCount = 6 } },
        { 129, new() { Opcode = Opcode.Rcp, Name = "rcp", OperandCount = 2 } },
        { 130, new() { Opcode = Opcode.F32ToF16, Name = "f32tof16", OperandCount = 2 } },
        { 131, new() { Opcode = Opcode.F16ToF32, Name = "f16tof32", OperandCount = 2 } },
        { 132, new() { Opcode = Opcode.UAddC, Name = "uaddc", OperandCount = 4 } },
        { 133, new() { Opcode = Opcode.USubB, Name = "usubb", OperandCount = 4 } },
        { 134, new() { Opcode = Opcode.CountBits, Name = "countbits", OperandCount = 2 } },
        { 135, new() { Opcode = Opcode.FirstBitHi, Name = "firstbit_hi", OperandCount = 2 } },
        { 136, new() { Opcode = Opcode.FirstBitLo, Name = "firstbit_lo", OperandCount = 2 } },
        { 137, new() { Opcode = Opcode.FirstBitSHi, Name = "firstbit_shi", OperandCount = 2 } },
        { 138, new() { Opcode = Opcode.Ubfe, Name = "ubfe", OperandCount = 4 } },
        { 139, new() { Opcode = Opcode.Ibfe, Name = "ibfe", OperandCount = 4 } },
        { 140, new() { Opcode = Opcode.Bfi, Name = "bfi", OperandCount = 5 } },
        { 141, new() { Opcode = Opcode.ReverseBits, Name = "bfrev", OperandCount = 2 } },
        { 142, new() { Opcode = Opcode.SwapC, Name = "swapc", OperandCount = 5 } },
        { 143, new() { Opcode = Opcode.DclStream, Name = "dcl_stream", OperandCount = 1 } },
        { 144, new() { Opcode = Opcode.DclFunctionBody, Name = "dcl_function_body", OperandCount = 1 } },
        { 145, new() { Opcode = Opcode.DclFunctionTable, Name = "dcl_function_table", OperandCount = 1 } },
        { 146, new() { Opcode = Opcode.DclInterface, Name = "dcl_interface", OperandCount = 1 } },
        { 147, new() { Opcode = Opcode.DclInputControlPointCount, Name = "dcl_input_control_point_count", OperandCount = 0 } },
        { 148, new() { Opcode = Opcode.DclOutputControlPointCount, Name = "dcl_output_control_point_count", OperandCount = 0 } },
        { 149, new() { Opcode = Opcode.DclDomain, Name = "dcl_tessellator_domain", OperandCount = 0 } },
        { 150, new() { Opcode = Opcode.DclPartitioning, Name = "dcl_tessellator_partitioning", OperandCount = 0 } },
        { 152, new() { Opcode = Opcode.DclHSMaxTessFactor, Name = "dcl_hs_max_tessfactor", OperandCount = 0 } },
        { 155, new() { Opcode = Opcode.DclThreadGroup, Name = "dcl_thread_group", OperandCount = 0 } },
        { 156, new() { Opcode = Opcode.DclUAV, Name = "dcl_uav_typed", OperandCount = 1 } },
        { 163, new() { Opcode = Opcode.LdUAVTyped, Name = "ld_uav_typed", OperandCount = 2 } },
        { 164, new() { Opcode = Opcode.StoreUAV, Name = "store_uav_typed", OperandCount = 2 } },
        { 165, new() { Opcode = Opcode.LdRaw, Name = "ld_raw", OperandCount = 3 } },
        { 166, new() { Opcode = Opcode.StoreRaw, Name = "store_raw", OperandCount = 3 } },
        { 167, new() { Opcode = Opcode.LdStructured, Name = "ld_structured", OperandCount = 4 } },
        { 168, new() { Opcode = Opcode.StoreStructured, Name = "store_structured", OperandCount = 4 } },
        { 169, new() { Opcode = Opcode.AtomicAnd, Name = "atomic_and", OperandCount = 3 } },
        { 170, new() { Opcode = Opcode.AtomicOr, Name = "atomic_or", OperandCount = 3 } },
        { 171, new() { Opcode = Opcode.AtomicXor, Name = "atomic_xor", OperandCount = 3 } },
        { 172, new() { Opcode = Opcode.AtomicCmpStore, Name = "atomic_cmp_store", OperandCount = 4 } },
        { 173, new() { Opcode = Opcode.AtomicIAdd, Name = "atomic_iadd", OperandCount = 3 } },
        { 174, new() { Opcode = Opcode.AtomicIMax, Name = "atomic_imax", OperandCount = 3 } },
        { 175, new() { Opcode = Opcode.AtomicIMin, Name = "atomic_imin", OperandCount = 3 } },
        { 176, new() { Opcode = Opcode.AtomicUMax, Name = "atomic_umax", OperandCount = 3 } },
        { 177, new() { Opcode = Opcode.AtomicUMin, Name = "atomic_umin", OperandCount = 3 } },
        { 180, new() { Opcode = Opcode.ImmAtomicIAdd, Name = "imm_atomic_iadd", OperandCount = 4 } },
        { 181, new() { Opcode = Opcode.ImmAtomicAnd, Name = "imm_atomic_and", OperandCount = 4 } },
        { 182, new() { Opcode = Opcode.ImmAtomicOr, Name = "imm_atomic_or", OperandCount = 4 } },
        { 183, new() { Opcode = Opcode.ImmAtomicXor, Name = "imm_atomic_xor", OperandCount = 4 } },
        { 184, new() { Opcode = Opcode.ImmAtomicExch, Name = "imm_atomic_exch", OperandCount = 4 } },
        { 185, new() { Opcode = Opcode.ImmAtomicCmpExch, Name = "imm_atomic_cmp_exch", OperandCount = 5 } },
        { 186, new() { Opcode = Opcode.ImmAtomicIMax, Name = "imm_atomic_imax", OperandCount = 4 } },
        { 187, new() { Opcode = Opcode.ImmAtomicIMin, Name = "imm_atomic_imin", OperandCount = 4 } },
        { 188, new() { Opcode = Opcode.ImmAtomicUMax, Name = "imm_atomic_umax", OperandCount = 4 } },
        { 189, new() { Opcode = Opcode.ImmAtomicUMin, Name = "imm_atomic_umin", OperandCount = 4 } },
        { 190, new() { Opcode = Opcode.Sync, Name = "sync", OperandCount = 0 } },
        { 203, new() { Opcode = Opcode.EvalSnapped, Name = "eval_snapped", OperandCount = 3 } },
        { 204, new() { Opcode = Opcode.EvalSampleIndex, Name = "eval_sample_index", OperandCount = 3 } },
        { 205, new() { Opcode = Opcode.EvalCentroid, Name = "eval_centroid", OperandCount = 2 } },
    };

    //------------------------------------------------------------------
    // Extended opcode tokens. For now this just stores the raw DWORD so
    // the parser stays synchronized. Later this should decode aoffimmi,
    // resource return type, etc. based on the extended opcode type in
    // bits 0-5 of the token.
    //------------------------------------------------------------------

    private void ParseExtendedOpcode(uint token, Instruction instruction)
    {
        instruction.ExtendedOpcode = token;

        // bits 0-5: extended opcode type. Type 1 is "sample controls"
        // (aoffimmi) - three signed 4-bit texel offsets (U/V/W) packed
        // into bits 9-12 / 13-16 / 17-20.
        uint extType = token & 0x3F;

        if (extType == 1)
        {
            instruction.HasSampleControls = true;
            instruction.AoffimmiU = SignExtend4((token >> 9) & 0xF);
            instruction.AoffimmiV = SignExtend4((token >> 13) & 0xF);
            instruction.AoffimmiW = SignExtend4((token >> 17) & 0xF);
        }
        else if (extType == 2)
        {
            // bits 6-10: resource dimension, bits 11-16: structure stride
            // (only meaningful for RESOURCE_DIMENSION_STRUCTURED_BUFFER)
            instruction.HasResourceDim = true;
            instruction.ResourceDim = (token >> 6) & 0x1F;
            instruction.ResourceStructureStride = (token >> 11) & 0xFFF;
        }
        else if (extType == 3)
        {
            // bits 6-9/10-13/14-17/18-21: return type per component (x/y/z/w)
            instruction.HasResourceReturnType = true;
            instruction.ResourceReturnTypeX = (token >> 6) & 0xF;
            instruction.ResourceReturnTypeY = (token >> 10) & 0xF;
            instruction.ResourceReturnTypeZ = (token >> 14) & 0xF;
            instruction.ResourceReturnTypeW = (token >> 18) & 0xF;
        }
    }

    // Sign-extend a 4-bit immediate (range -8..7) stored in the low
    // nibble of an unsigned value.
    private static sbyte SignExtend4(uint value)
    {
        return (sbyte)((value & 0x8) != 0 ? (int)value - 16 : (int)value);
    }

private OpcodeInfo DecodeOpcode(uint opcode)
    {
        if (OpcodeTable.TryGetValue(opcode, out var info))
            return info;

        return new OpcodeInfo
        {
            Opcode = Opcode.Unknown,
            Name = $"opcode_{opcode}",
            OperandCount = 0
        };
    }

    public enum OperandModifier
    {
        None,
        Neg,
        Abs,
        AbsNeg
    }

    private Operand DecodeOperand(BinaryReader reader)
    {
        uint token = reader.ReadUInt32();

        Operand op = new();

        //--------------------------------------------------------
        // bits 0-1
        // Number of components
        //--------------------------------------------------------

        op.NumComponents = (int)(token & 0x3);

        //--------------------------------------------------------
        // bits 2-3
        // Component selection mode
        //--------------------------------------------------------

        op.ComponentMode =
            (Operand.OperandComponentMode)((token >> 2) & 0x3);

        //--------------------------------------------------------
        // bits 4-11
        // Mask / Swizzle / Component
        //--------------------------------------------------------

        switch (op.ComponentMode)
        {
            case Operand.OperandComponentMode.Mask:
                op.Mask = (byte)((token >> 4) & 0xF);
                break;

            case Operand.OperandComponentMode.Swizzle:
                op.Swizzle = (byte)((token >> 4) & 0xFF);
                break;

            case Operand.OperandComponentMode.Select1:
                op.Component = (byte)((token >> 4) & 0x3);
                break;
        }

        //--------------------------------------------------------
        // bits 12-19
        // Register type (8 bits only - NOT extended by bits 20-21,
        // those belong to the index count "order" field below)
        //--------------------------------------------------------

        uint regType = (token >> 12) & 0xFF;

        op.RegisterType = DecodeRegisterType(regType);

        //--------------------------------------------------------
        // Immediate values
        //--------------------------------------------------------

        if (op.RegisterType == RegisterType.Immediate32)
        {
            int count = op.NumComponents switch
            {
                0 => 0,
                1 => 1,
                2 => 4,
                _ => throw new InvalidDataException()
            };

            op.Immediate32Values = new uint[count];

            for (int i = 0; i < count; i++)
                op.Immediate32Values[i] = reader.ReadUInt32();

            return op;
        }

        if (op.RegisterType == RegisterType.Immediate64)
        {
            int count = op.NumComponents switch
            {
                0 => 0,
                1 => 1,
                2 => 4,
                _ => throw new InvalidDataException()
            };

            op.Immediate64Values = new Double[count];

            for (int i = 0; i < count; i++)
                op.Immediate64Values[i] = reader.ReadDouble();

            return op;
        }

        //--------------------------------------------------------
        // bits 20-21
        // "Order" - the number of register indices that follow.
        // This is read directly from the token, NOT derived from
        // register type. (Previously this code used GetIndexCount()
        // based on RegisterType, which is incorrect - that table
        // silently desyncs the parser whenever a register type
        // uses an index count the table didn't predict.)
        //--------------------------------------------------------

        int indexCount = (int)((token >> 20) & 0x3);

        //--------------------------------------------------------
        // bits 22-24
        // Addressing mode / index representation 0
        //--------------------------------------------------------

        if (indexCount > 0)
            op.IndexRepresentation[0] =
                (Operand.OperandIndexRepresentation)((token >> 22) & 0x7);

        //--------------------------------------------------------
        // bits 25-27
        // Addressing mode / index representation 1
        //--------------------------------------------------------

        if (indexCount > 1)
            op.IndexRepresentation[1] =
                (Operand.OperandIndexRepresentation)((token >> 25) & 0x7);

        //--------------------------------------------------------
        // bits 28-30
        // Addressing mode / index representation 2
        //--------------------------------------------------------

        if (indexCount > 2)
            op.IndexRepresentation[2] =
                (Operand.OperandIndexRepresentation)((token >> 28) & 0x7);

        //--------------------------------------------------------
        // bit 31
        // Extended operand
        //--------------------------------------------------------

        op.IsExtended = (token & 0x80000000) != 0;

        //--------------------------------------------------------
        // Extension token(s)
        // First extension token (if present) encodes a source
        // modifier (neg/abs/absneg). Further chained extension
        // tokens (bit 31 set again) are skipped - not modeled.
        //--------------------------------------------------------

        if (op.IsExtended)
        {
            uint ext = reader.ReadUInt32();

            op.Modifier = (ext & 0xFF) switch
            {
                0x41 => OperandModifier.Neg,
                0x81 => OperandModifier.Abs,
                0xC1 => OperandModifier.AbsNeg,
                _ => OperandModifier.None
            };

            while ((ext & 0x80000000) != 0)
                ext = reader.ReadUInt32();
        }
        
        //--------------------------------------------------------
        // Read indices
        //--------------------------------------------------------

        for (int i = 0; i < indexCount; i++)
        {
            switch (op.IndexRepresentation[i])
            {
                case Operand.OperandIndexRepresentation.Immediate32:

                    op.Indices.Add(reader.ReadUInt32());
                    break;

                case Operand.OperandIndexRepresentation.Relative:

                    op.RelativeOperands[i] = DecodeOperand(reader);
                    op.Indices.Add(0);
                    break;

                case Operand.OperandIndexRepresentation.Immediate32PlusRelative:

                    op.Indices.Add(reader.ReadUInt32());
                    op.RelativeOperands[i] = DecodeOperand(reader);
                    break;

                default:
                    throw new InvalidDataException(
                        $"Unknown index representation {op.IndexRepresentation[i]}");
            }
        }

        if (op.Indices.Count > 0)
            op.RegisterIndex = op.Indices[0];
        
        return op;
    }


private RegisterType DecodeRegisterType(uint type)
    {
        return type switch
        {
            0  => RegisterType.Temp,
            1  => RegisterType.Input,
            2  => RegisterType.Output,
            3  => RegisterType.IndexableTemp,
            4  => RegisterType.Immediate32,
            5  => RegisterType.Immediate64,
            6  => RegisterType.Sampler,
            7  => RegisterType.Resource,
            8  => RegisterType.ConstantBuffer,
            9  => RegisterType.ImmediateConstantBuffer,
            10 => RegisterType.Label,
            11 => RegisterType.InputPrimitiveID,
            12 => RegisterType.OutputDepth,
            13 => RegisterType.Null,
            14 => RegisterType.Rasterizer,
            15 => RegisterType.OutputCoverageMask,
            16 => RegisterType.Stream,
            17 => RegisterType.FunctionBody,
            18 => RegisterType.FunctionTable,
            19 => RegisterType.Interface,
            20 => RegisterType.FunctionInput,
            21 => RegisterType.FunctionOutput,
            22 => RegisterType.OutputControlPointID,
            23 => RegisterType.InputForkInstanceID,
            24 => RegisterType.InputJoinInstanceID,
            25 => RegisterType.InputControlPoint,
            26 => RegisterType.OutputControlPoint,
            27 => RegisterType.InputPatchConstant,
            28 => RegisterType.InputDomainPoint,
            29 => RegisterType.ThisPointer,
            30 => RegisterType.UnorderedAccessView,
            31 => RegisterType.ThreadGroupSharedMemory,
            32 => RegisterType.InputThreadID,
            33 => RegisterType.InputThreadGroupID,
            34 => RegisterType.InputThreadIDInGroup,
            35 => RegisterType.InputCoverageMask,
            36 => RegisterType.InputThreadIDInGroupFlattened,
            37 => RegisterType.InputGSInstanceID,
            38 => RegisterType.OutputDepthGreaterEqual,
            39 => RegisterType.OutputDepthLessEqual,
            40 => RegisterType.CycleCounter,

            _ => RegisterType.Unknown
        };
    }

    public void Parse(byte[] data)
    {
        using var stream = new MemoryStream(data);
        using var reader = new BinaryReader(stream);

        VersionToken = reader.ReadUInt32();

        MinorVersion = VersionToken & 0xF;
        MajorVersion = (VersionToken >> 4) & 0xF;

        uint programTypeValue = (VersionToken >> 16) & 0xFFFF;
        ProgramType = Enum.IsDefined(typeof(ShaderProgramType), (int)programTypeValue)
            ? (ShaderProgramType)programTypeValue
            : ShaderProgramType.Unknown;

        DeclaredDwordCount = reader.ReadUInt32();

        // Parse up to the declared shader size (in DWORDs), not just
        // until we happen to hit a RET or run out of stream. Clamp to
        // the actual buffer length in case the declared count lies.
        long declaredEndByte = (long)DeclaredDwordCount * 4;
        long parseEndByte = Math.Min(declaredEndByte, reader.BaseStream.Length);

        if (declaredEndByte != reader.BaseStream.Length)
        {
            Warnings.Add($"Declared shader size ({DeclaredDwordCount} DWORDs) does not match chunk data length ({reader.BaseStream.Length / 4} DWORDs).");
        }

        while (reader.BaseStream.Position < parseEndByte)
        {
            long instructionStartByte = reader.BaseStream.Position;
            int instructionStart = (int)(instructionStartByte / 4);

            uint token = reader.ReadUInt32();

            int opcodeValue = (int)(token & 0x7FF);

            //------------------------------------------------------------------
            // CUSTOMDATA (opcode 53) is the only opcode whose length is NOT
            // taken from bits 24-30 - it has its own length DWORD that
            // immediately follows, covering the whole custom data block
            // (including the two header DWORDs already read). Handle it
            // before any of the normal length/operand logic runs, or the
            // parser will desync on every shader that uses it (e.g. for
            // immediate constant buffers).
            //------------------------------------------------------------------

            if (opcodeValue == 53)
            {
                uint customLength = reader.ReadUInt32();

                var customInstruction = new Instruction
                {
                    Opcode = Opcode.CustomData,
                    Name = "customdata",
                    OpcodeToken = token,
                    CustomDataLength = customLength,
                    CustomData = reader.ReadBytes((int)((customLength - 2) * 4))
                };

                customInstruction.Length = (int)customLength;

                customInstruction.InstructionIndex = Instructions.Count;
                Instructions.Add(customInstruction);
                continue;
            }

            int length = (int)((token >> 24) & 0x7F);

            if (length == 0)
            {
                Warnings.Add($"Invalid instruction at DWORD {instructionStart}");
                break;
            }

            OpcodeInfo info = DecodeOpcode((uint)opcodeValue);

            if (info.Opcode == Opcode.Unknown)
            {
                Warnings.Add($"Warning: Unknown opcode {opcodeValue} at DWORD {instructionStart}. Skipping {length} DWORDs.");
            }

            var instruction = new Instruction
            {
                Opcode = info.Opcode,
                Name = info.Name,
                OpcodeToken = token,
                Length = length,

                // bit 13: saturate result
                Saturate = (token & 0x2000) != 0,

                // bit 31: this opcode token is followed by an extended
                // opcode token
                HasExtendedOpcode = (token & 0x80000000) != 0,

                // bit 18: test boolean (used by breakc/if/continuec/retc/etc.)
                TestBoolean = (InstructionTestBoolean)((token >> 18) & 1),

                // bits 19-22: "precise" flags, one bit per component (xyzw)
                Precise = (byte)((token >> 19) & 0xF)
            };

            //------------------------------------------------------------------
            // Extended opcode token(s). Each is decoded via
            // ParseExtendedOpcode(); if bit 31 is set again, another
            // extension token follows immediately (chained extensions),
            // so keep decoding until a token without bit 31 is read.
            //------------------------------------------------------------------

            if (instruction.HasExtendedOpcode)
            {
                uint ext;

                do
                {
                    ext = reader.ReadUInt32();
                    ParseExtendedOpcode(ext, instruction);
                }
                while ((ext & 0x80000000) != 0);
            }

            if (opcodeValue == 88) // dcl_resource
            {
                uint resourceDim = (token >> 11) & 0xF;
                instruction.ExtraData.Add(resourceDim);
            }
            else if (opcodeValue == 90) // dcl_sampler
            {
                uint samplerMode = (token >> 11) & 0xF;
                instruction.ExtraData.Add(samplerMode);
            }
            else if (opcodeValue == 89)
            {
                uint indexType = (token >> 11) & 0x1;
                instruction.ExtraData.Add(indexType);
            }
            else if (opcodeValue == 98) // dcl_input_ps: interpolation mode, bits 11-14
            {
                instruction.Interpolation = (Parser.DXBC.IR.InterpolationMode)((token >> 11) & 0xF);
            }

            for (int i = 0; i < info.OperandCount; i++)
            {
                try
                {
                    Operand operand = DecodeOperand(reader);
                    
                    instruction.Operands.Add(operand);

                }
                catch (Exception ex)
                {
                    throw new Exception(
                        $"Failed decoding operand {i} of {info.Name} " +
                        $"at DWORD {instructionStart} (stream DWORD {reader.BaseStream.Position / 4})",
                        ex);
                }
            }
            
            if (opcodeValue == 88)
            {
                uint returnType = reader.ReadUInt32();
                instruction.ExtraData.Add(returnType);
            }
            
            switch (opcodeValue)
            {

                //----------------------------------------------------------
                // dcl_output
                //----------------------------------------------------------
                case 101:
                    // no extra DWORD
                    break;
                
                //----------------------------------------------------------
                // dcl_input_sgv
                //----------------------------------------------------------
                case 96:
                    instruction.ExtraData.Add(reader.ReadUInt32()); // system-value semantic
                    break;
                
                //----------------------------------------------------------
                // dcl_output_siv
                //----------------------------------------------------------
                
                case 103:
                    instruction.ExtraData.Add(reader.ReadUInt32());
                    break;
                    
                //----------------------------------------------------------
                // dcl_temps
                //----------------------------------------------------------
                case 104:
                    instruction.ExtraData.Add(reader.ReadUInt32());
                    break;

                //----------------------------------------------------------
                // dcl_globalFlags
                //----------------------------------------------------------
                case 106:
                    break;

                //----------------------------------------------------------
                // dcl_indexableTemp - 3 raw immediate DWORDs: register
                // index, number of registers, number of components.
                // Not encoded as normal operand tokens.
                //----------------------------------------------------------
                case 105:
                    instruction.ExtraData.Add(reader.ReadUInt32()); // register index
                    instruction.ExtraData.Add(reader.ReadUInt32()); // num registers
                    instruction.ExtraData.Add(reader.ReadUInt32()); // num components
                    break;

                //----------------------------------------------------------
                // dcl_thread_group - 3 raw immediate DWORDs: x, y, z
                // thread group sizes. Not encoded as normal operand tokens.
                //----------------------------------------------------------
                case 155:
                    instruction.ExtraData.Add(reader.ReadUInt32()); // x
                    instruction.ExtraData.Add(reader.ReadUInt32()); // y
                    instruction.ExtraData.Add(reader.ReadUInt32()); // z
                    break;
            }

            //------------------------------------------------------------------
            // Check that DecodeOperand() consumed exactly the correct number
            // of DWORDs for this instruction.
            //------------------------------------------------------------------

            int expectedEnd = instructionStart + length;
            int actualEnd = (int)(reader.BaseStream.Position / 4);

            if (actualEnd != expectedEnd)
            {
                Warnings.Add($"Instruction desync after {info.Name}: expected DWORD {expectedEnd}, got {actualEnd}");
            }

            //------------------------------------------------------------------
            // Move to the official end of the instruction.
            //------------------------------------------------------------------

            reader.BaseStream.Position = instructionStartByte + length * 4;

            instruction.InstructionIndex = Instructions.Count;
            Instructions.Add(instruction);
        }
    }
}