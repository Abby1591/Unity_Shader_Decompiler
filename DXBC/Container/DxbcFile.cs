using System.Text;
using Parser.DXBC.Chunks;
using Parser.DXBC.Container;
using Parser.DXBC.Instructions;

namespace Parser.DXBC;

public class DxbcFile
{
    public List<DxbcChunk> Chunks { get; } = new();
    
    public ShdrParser? Shader;

    public void Load(string file)
    {
        using var stream = File.OpenRead(file);
        using var reader = new BinaryReader(stream);

        string magic = Encoding.ASCII.GetString(reader.ReadBytes(4));

        if (magic != "DXBC")
            throw new Exception("Not a DXBC file.");

        Console.WriteLine($"Magic : {magic}");

        // checksum
        reader.ReadBytes(16);

        uint unknown = reader.ReadUInt32();
        uint length = reader.ReadUInt32();
        uint chunkCount = reader.ReadUInt32();

        Console.WriteLine($"Length      : {length}");
        Console.WriteLine($"Chunk Count : {chunkCount}");
        Console.WriteLine();

        uint[] offsets = new uint[chunkCount];

        for (int i = 0; i < chunkCount; i++)
            offsets[i] = reader.ReadUInt32();

        for (int i = 0; i < chunkCount; i++)
        {
            reader.BaseStream.Position = offsets[i];

            var chunk = new DxbcChunk();

            chunk.Name = reader.ReadFourCC();
            chunk.Size = reader.ReadUInt32();
            chunk.Offset = offsets[i];

            long dataStart = reader.BaseStream.Position;

            chunk.Data = reader.ReadBytes((int)chunk.Size);

            Chunks.Add(chunk);

            // Parse known chunks
            reader.BaseStream.Position = dataStart;

            switch (chunk.Name)
            {
                case var _ when chunk.Name == FourCC.ISGN:
                {
                    using var ms = new MemoryStream(chunk.Data);
                    using var r = new BinaryReader(ms);

                    var isgn = new IsgnChunk();
                    isgn.Read(r);
                    break;
                }

                case var _ when chunk.Name == FourCC.OSGN:
                    break;

                case var _ when chunk.Name == FourCC.SHDR:
                    Shader = new ShdrParser();
                    Shader.Parse(chunk.Data);
                    break;
            }
        }
    }
}