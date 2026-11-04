using System;

// Stores serialized variant validation data.
[Serializable]
internal sealed class ShaderVariantManifestData
{
    public int schemaVersion;
    public string shaderSha256;
    public ShaderVariantPassData[] passes;
}
