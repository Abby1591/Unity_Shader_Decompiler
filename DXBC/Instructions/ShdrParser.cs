using System.IO;

namespace Parser.DXBC.Instructions;

public class ShdrParser
{
    public List<ShaderInstruction> Instructions { get; } = new();

    public void Parse(byte[] data)
    {
        using var stream = new MemoryStream(data);
        using var reader = new BinaryReader(stream);

        // Shader version token
        uint versionToken = reader.ReadUInt32();

        // Total DWORD count
        uint totalLength = reader.ReadUInt32();

        Console.WriteLine($"Shader Version Token : 0x{versionToken:X8}");
        Console.WriteLine($"Instruction DWORDs   : {totalLength}");
        Console.WriteLine();

        while (reader.BaseStream.Position < reader.BaseStream.Length)
        {
            long start = reader.BaseStream.Position;

            uint token = reader.ReadUInt32();

            int opcode = (int)(token & 0x7FF);
            int length = (int)((token >> 24) & 0x7F);

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

            if (length == 0)
            {
                Console.WriteLine($"Invalid instruction at {start:X}");
                break;
            }
        }
    }
}