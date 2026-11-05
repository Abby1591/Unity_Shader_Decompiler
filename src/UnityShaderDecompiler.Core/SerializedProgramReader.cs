using AssetStudio;
using UnityShaderDecompiler.Core.DXBC.Metadata;

namespace UnityShaderDecompiler.Core;

// Reads code records using serialized references instead of interpreting parameter records as code.
internal static class SerializedProgramReader
{
    // Keeps legacy inputs supported while requiring exact indices when references exist.
    internal static void Read(ShaderProgram program, BinaryReader reader, ShaderMetadata metadata,
        bool strict, TextWriter log)
    {
        int[] indices = metadata.SubShaders.SelectMany(sub => sub.Passes)
            .SelectMany(pass => pass.DirectXPrograms).Select(reference => reference.BlobIndex)
            .Distinct().Order().ToArray();
        if (indices.Length == 0)
        {
            program.Read(reader, 0);
            return;
        }
        foreach (int index in indices)
        {
            try
            {
                ReadEntry(program, reader, index);
            }
            catch (Exception error) when (error is IOException or InvalidDataException or ArgumentException or OverflowException)
            {
                if (strict)
                {
                    throw new InvalidDataException($"Failed to read serialized code record {index}.", error);
                }
                log.WriteLine($"Failed to read serialized code record {index}: {error.Message}");
            }
        }
    }

    // Bounds each code parser to its declared record and rejects unavailable segments.
    private static void ReadEntry(ShaderProgram program, BinaryReader reader, int index)
    {
        if (index < 0 || index >= program.entries.Length)
        {
            throw new InvalidDataException($"Serialized code index {index} is outside the blob table.");
        }
        ShaderSubProgramEntry entry = program.entries[index];
        if (entry.Segment != 0 || entry.Offset < 0 || entry.Length <= 0 ||
            (long)entry.Offset + entry.Length > reader.BaseStream.Length)
        {
            throw new InvalidDataException($"Invalid or unavailable serialized code record {index}.");
        }
        reader.BaseStream.Position = entry.Offset;
        byte[] bytes = reader.ReadBytes(entry.Length);
        using MemoryStream stream = new MemoryStream(bytes, writable: false);
        using BinaryReader bounded = new BinaryReader(stream);
        program.m_SubPrograms[index] = new ShaderSubProgram(bounded);
    }
}
