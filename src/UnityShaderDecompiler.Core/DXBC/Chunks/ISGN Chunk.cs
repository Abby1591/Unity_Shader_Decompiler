namespace Parser.DXBC.Chunks;

public class IsgnChunk
{
    public List<SignatureElement> Elements { get; } = new();
    public List<string> Warnings { get; } = new();

    public void Read(BinaryReader reader)
    {
        long start = reader.BaseStream.Position;

        uint elementCount = reader.ReadUInt32();
        uint unknown = reader.ReadUInt32();

        for (int i = 0; i < elementCount; i++)
        {
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
                Warnings.Add($"Invalid name offset: {nameOffset}");
                continue;
            }

            reader.BaseStream.Position = start + nameOffset;
            string semantic = reader.ReadNullTerminatedString();
            reader.BaseStream.Position = returnPos;

            Elements.Add(new SignatureElement
            {
                SemanticName = semantic,
                SemanticIndex = semanticIndex,
                SystemValue = systemValue,
                ComponentType = componentType,
                Register = register,
                Mask = mask,
                ReadWriteMask = rwMask
            });
        }
    }
}