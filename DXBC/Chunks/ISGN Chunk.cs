using System.Text;

namespace Parser.DXBC.Chunks;

public class IsgnChunk
{
    public List<SignatureElement> Elements { get; } = new();

    public void Read(BinaryReader reader)
    {
        long start = reader.BaseStream.Position;

        uint elementCount = reader.ReadUInt32();
        uint unknown = reader.ReadUInt32();

        Console.WriteLine($"ISGN Elements: {elementCount}");
        Console.WriteLine($"Unknown      : 0x{unknown:X8}");
        Console.WriteLine();

        for (int i = 0; i < elementCount; i++)
        {
            long entryPos = reader.BaseStream.Position;

            uint nameOffset = reader.ReadUInt32();
            uint semanticIndex = reader.ReadUInt32();
            uint systemValue = reader.ReadUInt32();
            uint componentType = reader.ReadUInt32();

            uint register = reader.ReadUInt32();

            byte mask = reader.ReadByte();
            byte rwMask = reader.ReadByte();
            ushort reserved = reader.ReadUInt16();
            long returnPos = reader.BaseStream.Position;
            
            if (nameOffset >= reader.BaseStream.Length)
            {
                Console.WriteLine($"Invalid name offset: {nameOffset}");
                continue;
            }

            reader.BaseStream.Position = start + nameOffset;

            string semantic = reader.ReadNullTerminatedString();

            reader.BaseStream.Position = returnPos;

            var element = new SignatureElement
            {
                SemanticName = semantic,
                SemanticIndex = semanticIndex,
                SystemValue = systemValue,
                ComponentType = componentType,
                Register = register,
                Mask = mask,
                ReadWriteMask = rwMask
            };

            Elements.Add(element);

            Console.WriteLine(element);
        }
    }
}