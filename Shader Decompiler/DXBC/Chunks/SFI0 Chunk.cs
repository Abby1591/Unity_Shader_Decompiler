namespace Parser.DXBC.Chunks;

// SFI0 stores the shader's required feature flags as one 64-bit bitmask.
public class Sfi0Chunk
{
    public ulong FeatureFlags { get; private set; }

    public void Read(BinaryReader reader)
    {
        if (reader.BaseStream.Length - reader.BaseStream.Position != sizeof(ulong))
            throw new InvalidDataException("SFI0 chunk must contain exactly 8 bytes of feature flags.");

        FeatureFlags = reader.ReadUInt64();
    }
}