using System;

// Stores serialized variant validation data.
[Serializable]
internal sealed class ShaderVariantPassData
{
    public int passIndex;
    public ShaderVariantData[] variants;
}
