using System.Text.Json;
using AssetStudio;
using UnityShaderDecompiler.Core;
using UnityShaderDecompiler.Core.DXBC.Metadata;

namespace UnityShaderDecompiler.Tests;

// Separates serialized code references from unrelated parameter records.
public sealed class SerializedProgramReaderTests
{
    // Does not interpret an unreferenced, deliberately invalid record as shader code.
    [Fact]
    public void UnreferencedRecordsAreNotParsed()
    {
        using TempDirectory folder = new TempDirectory();
        ShaderMetadata metadata = Metadata(folder, 0);
        byte[] blob = Blob();
        BitConverter.GetBytes(1).CopyTo(blob, 20); // Invalid length for the second record.
        using BinaryReader reader = new BinaryReader(new MemoryStream(blob));
        ShaderProgram program = new ShaderProgram(reader, new[] { 2022, 3, 62 });
        SerializedProgramReader.Read(program, reader, metadata, true, TextWriter.Null);
        Assert.NotNull(program.m_SubPrograms[0]);
        Assert.Null(program.m_SubPrograms[1]);
    }

    // Fails explicitly if the same invalid record is referenced as shader code.
    [Theory]
    [InlineData(1)]
    [InlineData(2)]
    public void InvalidReferencedRecordStopsReading(int index)
    {
        using TempDirectory folder = new TempDirectory();
        ShaderMetadata metadata = Metadata(folder, index);
        byte[] blob = Blob();
        BitConverter.GetBytes(1).CopyTo(blob, 20);
        using BinaryReader reader = new BinaryReader(new MemoryStream(blob));
        ShaderProgram program = new ShaderProgram(reader, new[] { 2022, 3, 62 });
        InvalidDataException error = Assert.Throws<InvalidDataException>(() =>
            SerializedProgramReader.Read(program, reader, metadata, true, TextWriter.Null));
        Assert.Contains($"serialized code record {index}", error.Message);
    }

    // Creates two bounded code records without requiring native compilation.
    private static byte[] Blob()
    {
        return RuntimeVariantEmissionTests.BuildBlob(new List<(ShaderGpuProgramType, byte[])>
        {
            (ShaderGpuProgramType.DX11VertexSM40, new byte[] { 1 }),
            (ShaderGpuProgramType.DX11PixelSM40, new byte[] { 2 }),
        });
    }

    // Names the only code record that the caller is allowed to parse.
    private static ShaderMetadata Metadata(TempDirectory folder, int index)
    {
        string path = Path.Combine(folder.Path, "metadata.json");
        File.WriteAllText(path, JsonSerializer.Serialize(new
        {
            name = "Test/CodeRecords", subShaders = new[] { new { passes = new[] { new
            {
                directXPrograms = new[] { new { blobIndex = index, stage = "Vertex", keywords = Array.Empty<string>(), keywordMask = Array.Empty<string>() } },
            } } } },
        }));
        return ShaderMetadata.Load(path);
    }
}
