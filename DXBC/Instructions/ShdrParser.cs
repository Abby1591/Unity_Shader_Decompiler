namespace Parser.DXBC.Instructions;

public class ShdrParser
{
    public uint VersionToken { get; private set; }
    public uint DeclaredDwordCount { get; private set; }
    public List<Instruction> Instructions { get; } = new();
    public List<string> Warnings { get; } = new();

    private static readonly Dictionary<uint, OpcodeInfo> OpcodeTable = new()
    {
        { 0,  new(){ Opcode=Opcode.Add,     Name="add", OperandCount=3 } },
        { 50, new(){ Opcode=Opcode.Mad,     Name="mad", OperandCount=4 } },
        { 54, new(){ Opcode=Opcode.Mov,     Name="mov", OperandCount=2 } },
        { 56, new(){ Opcode=Opcode.Mul,     Name="mul", OperandCount=3 } },
        { 62, new(){ Opcode=Opcode.Ret,     Name="ret", OperandCount=0 } },
        { 65, new(){ Opcode=Opcode.Dp3,     Name="dp3", OperandCount=3 } },
        { 69, new(){ Opcode=Opcode.Sample,  Name="sample", OperandCount=4 } },
        { 72, new(){ Opcode=Opcode.SampleL, Name="sample_l", OperandCount=5 } },
        { 77, new(){ Opcode=Opcode.Rsq,     Name="rsq", OperandCount=2 } },

        // declarations
        { 88, new(){ Name="dcl_input", OperandCount=1 } },
        { 89, new(){ Name="dcl_input_ps", OperandCount=1 } },
        { 90, new(){ Name="dcl_output", OperandCount=1 } },
        { 95, new(){ Name="dcl_constantBuffer", OperandCount=2 } },
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
        uint type = (token >> 12) & 0xFF;
        uint index = 0;

        if (((token >> 22) & 0x3) != 0)
        {
            index = reader.ReadUInt32();
        }
        
        return new Operand
        {
            RegisterType = DecodeRegisterType(type),
            RegisterIndex = index,
            Mask = 0xF
        };
    }
    
    private RegisterType DecodeRegisterType(uint type)
    {
        return type switch
        {
            0 => RegisterType.Temp,
            1 => RegisterType.Input,
            2 => RegisterType.Output,
            3 => RegisterType.ConstantBuffer,
            6 => RegisterType.Resource,
            7 => RegisterType.Sampler,

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

            for (int i = 0; i < info.OperandCount; i++)
            {
                instruction.Operands.Add(DecodeOperand(reader));
            }

            long consumed = (reader.BaseStream.Position - start) / 4;

            while (consumed < length)
            {
                reader.ReadUInt32();
                consumed++;
            }

            Instructions.Add(instruction);

            if (opcode == 62) // RET
                break;
        }
    }
}