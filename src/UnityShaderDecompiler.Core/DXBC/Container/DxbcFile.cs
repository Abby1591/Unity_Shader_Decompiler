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
    public OsgnChunk? OutputSignature { get; private set; }
    public OsgnChunk? PatchConstantSignature { get; private set; }
    public RdefChunk? ResourceDefinition { get; private set; }
    public StatChunk? Statistics { get; private set; }
    public Sfi0Chunk? ShaderInfo { get; private set; }
    public ShdrParser? Shader;
    public FourCC ShaderChunkType { get; private set; }

    /// <summary>Chunk types encountered but not (yet) given a dedicated typed parser.
    /// Their raw bytes remain available via the entry's Data in Chunks.</summary>
    public List<DxbcChunk> UnknownChunks { get; } = new();

    public void Load(string file)
    {
        using var stream = File.OpenRead(file);
        using var reader = new BinaryReader(stream);

        Parse(reader);
    }

    public void Load(byte[] data)
    {
        using var stream = new MemoryStream(data);
        using var reader = new BinaryReader(stream);

        Parse(reader);
    }

    private void Parse(BinaryReader reader)
    {
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

        if (offset % 4 != 0)
        {
            throw new InvalidDataException($"Chunk offset {offset} is not 4-byte aligned.");
        }

        reader.BaseStream.Position = offset;

        var chunk = new DxbcChunk
        {
            Name = reader.ReadFourCC(),
            Offset = offset
        };
        
        chunk.Size = reader.ReadUInt32();
        if ((ulong)offset + 8 + chunk.Size > TotalLength)
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
        else if (chunk.Name == FourCC.OSGN)
        {
            using var ms = new MemoryStream(chunk.Data);
            using var r = new BinaryReader(ms);
            OutputSignature = new OsgnChunk();
            OutputSignature.Read(r, hasStreamIndex: false);
        }
        else if (chunk.Name == FourCC.OSG5)
        {
            using var ms = new MemoryStream(chunk.Data);
            using var r = new BinaryReader(ms);
            OutputSignature = new OsgnChunk();
            OutputSignature.Read(r, hasStreamIndex: true);
        }
        else if (chunk.Name == FourCC.PSGN)
        {
            using var ms = new MemoryStream(chunk.Data);
            using var r = new BinaryReader(ms);
            PatchConstantSignature = new OsgnChunk();
            PatchConstantSignature.Read(r, hasStreamIndex: false);
        }
        else if (chunk.Name == FourCC.PCON)
        {
            using var ms = new MemoryStream(chunk.Data);
            using var r = new BinaryReader(ms);
            PatchConstantSignature = new OsgnChunk();
            PatchConstantSignature.Read(r, hasStreamIndex: false);
        }
        else if (chunk.Name == FourCC.SFI0)
        {
            using var ms = new MemoryStream(chunk.Data);
            using var r = new BinaryReader(ms);
            ShaderInfo = new Sfi0Chunk();
            ShaderInfo.Read(r);
        }
        else if (chunk.Name == FourCC.RDEF)
        {
            using var ms = new MemoryStream(chunk.Data);
            using var r = new BinaryReader(ms);
            ResourceDefinition = new RdefChunk();
            ResourceDefinition.Read(r);
        }
        else if (chunk.Name == FourCC.STAT)
        {
            using var ms = new MemoryStream(chunk.Data);
            using var r = new BinaryReader(ms);
            Statistics = new StatChunk();
            Statistics.Read(r);
        }
        else if (chunk.Name == FourCC.SHDR ||
                 chunk.Name == FourCC.SHEX)
        {
            ShaderChunkType = chunk.Name;

            Shader = new ShdrParser();
            Shader.Parse(chunk.Data);
        }
        else
        {
            // Unknown/unhandled chunk type: raw bytes are already preserved in
            // chunk.Data (added to Chunks above), so nothing is lost. Track it
            // separately too so callers can enumerate exactly what wasn't decoded.
            UnknownChunks.Add(chunk);
        }
    }
}