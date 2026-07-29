namespace Parser.DXBC.Chunks;

// Mirrors D3D_RESOURCE_RETURN_TYPE (d3dcommon.h). Values verified against
// Microsoft's published enumeration.
public enum ResourceReturnType
{
    UNorm = 1,
    SNorm = 2,
    SInt = 3,
    UInt = 4,
    Float = 5,
    Mixed = 6,
    Double = 7,
    Continued = 8,
}

public static class ResourceReturnTypeExtensions
{
    public static ResourceReturnType? ToResourceReturnType(this uint value)
    {
        return System.Enum.IsDefined(typeof(ResourceReturnType), (int)value)
            ? (ResourceReturnType)value
            : null;
    }
}