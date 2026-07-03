namespace Parser.DXBC.Instructions;

public class ShdrParser
{
    public uint VersionToken { get; private set; }
    public uint DeclaredDwordCount { get; private set; }
    public List<Instruction> Instructions { get; } = new();
    public List<string> Warnings { get; } = new();

    private Opcode DecodeOpcode(uint opcode)
    {
        return opcode switch
        {
            50 => Opcode.Mad,
            54 => Opcode.Mov,
            56 => Opcode.Mul,
            62 => Opcode.Ret,
            65 => Opcode.Dp3,
            69 => Opcode.Sample,
            72 => Opcode.SampleL,
            77 => Opcode.Rsq,

            _ => Opcode.Unknown
        };
    }
    
    private Operand DecodeOperand(uint token)
    {
        uint type = (token >> 12) & 0xFF;

        return new Operand
        {
            RegisterType = DecodeRegisterType(type),
            RegisterIndex = 0,
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

            var instruction = new Instruction
            {
                OpcodeToken = token,
                Opcode = DecodeOpcode((uint)opcode),
                Length = length
            };

            for (int i = 1; i < length; i++)
            {
                uint operandToken = reader.ReadUInt32();

                instruction.RawOperands.Add(operandToken);

                instruction.Operands.Add(DecodeOperand(operandToken));
            }

            Instructions.Add(instruction);

            if (opcode == 62) // RET
                break;
        }
    }
}