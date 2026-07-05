namespace Parser.DXBC.Instructions;

public class ShdrParser
{
    public uint VersionToken { get; private set; }
    public uint DeclaredDwordCount { get; private set; }
    public List<Instruction> Instructions { get; } = new();
    public List<string> Warnings { get; } = new();

    private static readonly Dictionary<uint, OpcodeInfo> OpcodeTable = new() {
    { 0,  new(){ Opcode=Opcode.Add, Name="add", OperandCount=3 } },
    { 1,  new(){ Opcode=Opcode.And, Name="and", OperandCount=3 } },
    { 2,  new(){ Opcode=Opcode.Break, Name="break", OperandCount=0 } },
    { 3,  new(){ Opcode=Opcode.BreakC, Name="breakc", OperandCount=1 } },
    { 8,  new(){ Opcode=Opcode.Call, Name="call", OperandCount=1 } },
    { 9,  new(){ Opcode=Opcode.CallC, Name="callc", OperandCount=2 } },
    { 10, new(){ Opcode=Opcode.Case, Name="case", OperandCount=1 } },
    { 13, new(){ Opcode=Opcode.Continue, Name="continue", OperandCount=0 } },
    { 14, new(){ Opcode=Opcode.ContinueC, Name="continuec", OperandCount=1 } },
    { 16, new(){ Opcode=Opcode.Discard, Name="discard", OperandCount=1 } },
    { 18, new(){ Opcode=Opcode.Div, Name="div", OperandCount=3 } },
    { 21, new(){ Opcode=Opcode.Dp2, Name="dp2", OperandCount=3 } },
    { 22, new(){ Opcode=Opcode.Dp3, Name="dp3", OperandCount=3 } },
    { 23, new(){ Opcode=Opcode.Dp4, Name="dp4", OperandCount=3 } },
    { 24, new(){ Opcode=Opcode.Else, Name="else", OperandCount=0 } },
    { 25, new(){ Opcode=Opcode.Emit, Name="emit", OperandCount=0 } },
    { 26, new(){ Opcode=Opcode.EmitThenCut, Name="emitThenCut", OperandCount=0 } },
    { 27, new(){ Opcode=Opcode.EndIf, Name="endif", OperandCount=0 } },
    { 28, new(){ Opcode=Opcode.EndLoop, Name="endloop", OperandCount=0 } },
    { 30, new(){ Opcode=Opcode.EndSwitch, Name="endswitch", OperandCount=0 } },
    { 31, new(){ Opcode=Opcode.Eq, Name="eq", OperandCount=3 } },
    { 32, new(){ Opcode=Opcode.Exp, Name="exp", OperandCount=2 } },
    { 33, new(){ Opcode=Opcode.Frc, Name="frc", OperandCount=2 } },
    { 34, new(){ Opcode=Opcode.Ftoi, Name="ftoi", OperandCount=2 } },
    { 35, new(){ Opcode=Opcode.Ftou, Name="ftou", OperandCount=2 } },
    { 36, new(){ Opcode=Opcode.GE, Name="ge", OperandCount=3 } },
    { 37, new(){ Opcode=Opcode.IAdd, Name="iadd", OperandCount=3 } },
    { 38, new(){ Opcode=Opcode.If, Name="if", OperandCount=1 } },
    { 39, new(){ Opcode=Opcode.IEq, Name="ieq", OperandCount=3 } },
    { 40, new(){ Opcode=Opcode.IGe, Name="ige", OperandCount=3 } },
    { 41, new(){ Opcode=Opcode.ILt, Name="ilt", OperandCount=3 } },
    { 42, new(){ Opcode=Opcode.IMad, Name="imad", OperandCount=4 } },
    { 43, new(){ Opcode=Opcode.IMax, Name="imax", OperandCount=3 } },
    { 44, new(){ Opcode=Opcode.IMin, Name="imin", OperandCount=3 } },
    { 45, new(){ Opcode=Opcode.IMul, Name="imul", OperandCount=3 } },
    { 46, new(){ Opcode=Opcode.INe, Name="ine", OperandCount=3 } },
    { 47, new(){ Opcode=Opcode.Label, Name="label", OperandCount=1 } },
    { 48, new(){ Opcode=Opcode.Ld, Name="ld", OperandCount=3 } },
    { 49, new(){ Opcode=Opcode.Log, Name="log", OperandCount=2 } },
    { 50, new(){ Opcode=Opcode.Loop, Name="loop", OperandCount=0 } },
    { 53, new(){ Opcode=Opcode.Max,      Name="max",        OperandCount=3 } },
    { 54, new(){ Opcode=Opcode.Mov,      Name="mov",        OperandCount=2 } },
    { 55, new(){ Opcode=Opcode.MovC,     Name="movc",       OperandCount=3 } },
    { 56, new(){ Opcode=Opcode.Mul,      Name="mul",        OperandCount=3 } },
    { 57, new(){ Opcode=Opcode.Ne,       Name="ne",         OperandCount=3 } },
    { 58, new(){ Opcode=Opcode.Nop,      Name="nop",        OperandCount=0 } },
    { 59, new(){ Opcode=Opcode.Not,      Name="not",        OperandCount=2 } },
    { 60, new(){ Opcode=Opcode.Or,       Name="or",         OperandCount=3 } },
    { 61, new(){ Opcode=Opcode.ResInfo,  Name="resinfo",    OperandCount=3 } },
    { 62, new(){ Opcode=Opcode.Ret,      Name="ret",        OperandCount=0 } },
    { 63, new(){ Name="retc",            OperandCount=1 } },
    { 64, new(){ Name="round_ne",        OperandCount=2 } },
    { 65, new(){ Opcode=Opcode.RoundNI,  Name="round_ni",   OperandCount=2 } },
    { 66, new(){ Opcode=Opcode.RoundPI,  Name="round_pi",   OperandCount=2 } },
    { 67, new(){ Opcode=Opcode.RoundZ,   Name="round_z",    OperandCount=2 } },
    { 68, new(){ Opcode=Opcode.Rsq,      Name="rsq",        OperandCount=2 } },
    { 69, new(){ Opcode=Opcode.Sample,   Name="sample",     OperandCount=4 } },
    { 70, new(){ Opcode=Opcode.SampleC,  Name="sample_c",   OperandCount=4 } },
    { 71, new(){ Name="sample_c_lz",     OperandCount=4 } },
    { 72, new(){ Opcode=Opcode.SampleL,  Name="sample_l",   OperandCount=5 } },
    { 73, new(){ Name="sample_d",        OperandCount=6 } },
    { 74, new(){ Name="sample_b",        OperandCount=5 } },
    { 75, new(){ Opcode=Opcode.Sqrt,     Name="sqrt",       OperandCount=2 } },
    { 76, new(){ Name="switch",          OperandCount=1 } },
    { 77, new(){ Opcode = Opcode.Dp2Add, Name = "dp2add", OperandCount = 4 } },

    // declarations
    { 88, new(){ Name="dcl_input", OperandCount=1 } },
    { 89, new(){ Name="dcl_input_ps", OperandCount=1 } },
    { 90, new(){ Name="dcl_output", OperandCount=1 } },
    { 95, new(){ Name="dcl_constantbuffer", OperandCount=2 } },
    { 98, new(){ Name="dcl_resource", OperandCount=2 } },
    { 101,new(){ Name="dcl_sampler", OperandCount=2 } },
    { 103,new(){ Name="dcl_temps", OperandCount=1 } },
    { 104,new(){ Name="dcl_globalFlags", OperandCount=1 } },
};
    
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
    // Register type
    //--------------------------------------------------------

    uint regType =
        ((token >> 12) & 0xFF) |
        (((token >> 20) & 0x3) << 8);

    op.RegisterType = DecodeRegisterType(regType);

    //--------------------------------------------------------
    // bits 20-21
    // Register order (= index dimension)
    //--------------------------------------------------------

    op.IndexDimension = (int)((token >> 20) & 0x3);

    //--------------------------------------------------------
    // bits 22-23
    // Addressing mode 0
    //--------------------------------------------------------

    if (op.IndexDimension > 0)
        op.IndexRepresentation[0] =
            (Operand.OperandIndexRepresentation)((token >> 22) & 0x3);

    //--------------------------------------------------------
    // bits 25-26
    // Addressing mode 1
    //--------------------------------------------------------

    if (op.IndexDimension > 1)
        op.IndexRepresentation[1] =
            (Operand.OperandIndexRepresentation)((token >> 25) & 0x3);

    //--------------------------------------------------------
    // bit 31
    // Extended operand
    //--------------------------------------------------------

    op.IsExtended = (token & 0x80000000) != 0;

    //--------------------------------------------------------
    // Read indices
    //--------------------------------------------------------

    for (int i = 0; i < op.IndexDimension; i++)
    {
        switch (op.IndexRepresentation[i])
        {
            case Operand.OperandIndexRepresentation.Immediate32:

                op.Indices.Add(reader.ReadUInt32());
                break;

            case Operand.OperandIndexRepresentation.Relative:

                DecodeOperand(reader);
                op.Indices.Add(0);
                break;

            case Operand.OperandIndexRepresentation.Immediate32PlusRelative:

                op.Indices.Add(reader.ReadUInt32());
                DecodeOperand(reader);
                break;

            default:

                op.Indices.Add(0);
                break;
        }
    }

    if (op.Indices.Count > 0)
        op.RegisterIndex = op.Indices[0];

    //--------------------------------------------------------
    // Skip extension tokens
    //--------------------------------------------------------

    if (op.IsExtended)
    {
        uint ext;

        do
        {
            ext = reader.ReadUInt32();
        }
        while ((ext & 0x80000000) != 0);
    }

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
        DeclaredDwordCount = reader.ReadUInt32();

        while (reader.BaseStream.Position < reader.BaseStream.Length)
        {
            long start = reader.BaseStream.Position;
            uint token = reader.ReadUInt32();
            

            int opcode = (int)(token & 0x7FF);
            int length = (int)((token >> 24) & 0x7F);

            if (length == 0)
            {
                Warnings.Add($"Invalid instruction at 0x{start:X}");
                break;
            }

            var info = DecodeOpcode((uint)opcode);

            var instruction = new Instruction
            {
                Opcode = info.Opcode,
                Name = info.Name,
                OpcodeToken = token,
                Length = length
            };

            long instructionEnd = start + length * 4;

            for (int i = 0; i < info.OperandCount; i++)
            {
                try
                {
                    instruction.Operands.Add(DecodeOperand(reader));
                }
                catch (Exception ex)
                {
                    throw new Exception(
                        $"Failed decoding operand {i} of {info.Name} " +
                        $"at 0x{start:X} (stream 0x{reader.BaseStream.Position:X})",
                        ex);
                }
            }
            
            reader.BaseStream.Position = instructionEnd;

            Instructions.Add(instruction);

            if (opcode == 62) // RET
                break;
        }
    }
}