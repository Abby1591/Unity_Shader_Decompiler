namespace Parser.DXBC.IR;

// Mirrors D3D10_SB_RESOURCE_DIMENSION. ShdrParser already captures the raw
// resourceDim bits from dcl_resource into instruction.ExtraData[0] — this is
// what those bits mean. Previously that value was captured but never
// interpreted anywhere in the IR.
public enum ResourceDimension
{
    Unknown = 0,
    Buffer = 1,
    Texture1D = 2,
    Texture2D = 3,
    Texture2DMS = 4,
    Texture3D = 5,
    TextureCube = 6,
    Texture1DArray = 7,
    Texture2DArray = 8,
    Texture2DMSArray = 9,
    TextureCubeArray = 10,
    RawBuffer = 11,
    StructuredBuffer = 12,
}

public static class ResourceDimensionExtensions
{
    public static ResourceDimension ToResourceDimension(this uint value)
    {
        return System.Enum.IsDefined(typeof(ResourceDimension), (int)value)
            ? (ResourceDimension)value
            : ResourceDimension.Unknown;
    }
}