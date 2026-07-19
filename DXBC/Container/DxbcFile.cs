using System.Text;
using Parser.DXBC.Chunks;
using Parser.DXBC.Container;
using Parser.DXBC.Instructions;

namespace Parser.DXBC;

public class DxbcFile
{
    public uint TotalLength { get; private set; }
    public List<DxbcChunk> Chunks { get; } = new();
    public IsgnChunk? InputSignature { get; private set; }
    public ShdrParser? Shader;
    public FourCC ShaderChunkType { get; private set; }

    public void Load(string file)
    {
        using var stream = File.OpenRead(file);
        using var reader = new BinaryReader(stream);

        string magic = Encoding.ASCII.GetString(reader.ReadBytes(4));

        if (magic != "DXBC")
            throw new InvalidDataException("Not a DXBC file.");

        reader.ReadBytes(16); // checksum

        uint version = reader.ReadUInt32();

        if (version != 1)
            throw new InvalidDataException($"Unsupported DXBC container version {version}.");
        
        TotalLength = reader.ReadUInt32();
        uint chunkCount = reader.ReadUInt32();

        uint[] offsets = new uint[chunkCount];

        for (int i = 0; i < chunkCount; i++)
            offsets[i] = reader.ReadUInt32();

        foreach (uint offset in offsets)
            ReadChunk(reader, offset);
    }

    private void ReadChunk(BinaryReader reader, uint offset)
    {
        if (offset >= TotalLength)
        {
            throw new InvalidDataException($"Chunk offset {offset} is outside the DXBC container.");
        }

        reader.BaseStream.Position = offset;

        var chunk = new DxbcChunk
        {
            Name = reader.ReadFourCC(),
            Offset = offset
        };
        
        chunk.Size = reader.ReadUInt32();
        if (offset + 8 + chunk.Size > TotalLength)
        {
            throw new InvalidDataException($"Chunk {chunk.Name} extends past end of container.");
        }

        long dataStart = reader.BaseStream.Position;
        chunk.Data = reader.ReadBytes((int)chunk.Size);
        Chunks.Add(chunk);

        if (chunk.Name == FourCC.ISGN)
        {
            using var ms = new MemoryStream(chunk.Data);
            using var r = new BinaryReader(ms);
            InputSignature = new IsgnChunk();
            InputSignature.Read(r);
        }
        else if (chunk.Name == FourCC.SHDR ||
                 chunk.Name == FourCC.SHEX)
        {
            ShaderChunkType = chunk.Name;

            Shader = new ShdrParser();
            Shader.Parse(chunk.Data);
        }
    }
}