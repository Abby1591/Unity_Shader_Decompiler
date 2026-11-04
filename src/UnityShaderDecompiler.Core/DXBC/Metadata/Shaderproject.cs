using System.IO;

namespace Parser.DXBC.Metadata;

/// <summary>
/// Stage 0.4 — everything downstream (Stage 1+) reads from this instead of
/// a bare blob.bin, so the pipeline always has metadata + dummy reference
/// alongside the actual DXBC-bearing blob.
/// </summary>
public sealed class ShaderProject
{
    public byte[] Blob { get; }
    public ShaderMetadata Metadata { get; }
    public string? DummyShaderSource { get; }
    public string FolderPath { get; }

    private ShaderProject(byte[] blob, ShaderMetadata metadata, string? dummySource, string folderPath)
    {
        Blob = blob;
        Metadata = metadata;
        DummyShaderSource = dummySource;
        FolderPath = folderPath;
    }

    /// <summary>
    /// Loads blob.bin + metadata.json + (optional) dummy.shader from a
    /// folder produced by Extract.py.
    /// </summary>
    public static ShaderProject LoadFromFolder(string folderPath)
    {
        string blobPath = Path.Combine(folderPath, "blob.bin");
        string metadataPath = Path.Combine(folderPath, "metadata.json");
        string dummyPath = Path.Combine(folderPath, "dummy.shader");

        if (!File.Exists(blobPath))
            throw new FileNotFoundException($"blob.bin not found in {folderPath}", blobPath);
        if (!File.Exists(metadataPath))
            throw new FileNotFoundException($"metadata.json not found in {folderPath}", metadataPath);

        byte[] blob = File.ReadAllBytes(blobPath);
        ShaderMetadata metadata = ShaderMetadata.Load(metadataPath);
        string? dummy = File.Exists(dummyPath) ? File.ReadAllText(dummyPath) : null;

        return new ShaderProject(blob, metadata, dummy, folderPath);
    }
}