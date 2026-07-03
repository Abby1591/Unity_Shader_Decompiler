namespace Parser.DXBC.Instructions;

public class ShdrParser
{
    public uint VersionToken { get; private set; }
    public uint DeclaredDwordCount { get; private set; }
    public List<ShaderInstruction> Instructions { get; } = new();
    public List<string> Warnings { get; } = new();

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

            var instruction = new ShaderInstruction
            {
                OpcodeToken = token,
                Opcode = opcode,
                Length = length
            };

            for (int i = 1; i < length; i++)
                instruction.Operands.Add(reader.ReadUInt32());

            Instructions.Add(instruction);

            if (opcode == 62) // RET
                break;
        }
    }
}