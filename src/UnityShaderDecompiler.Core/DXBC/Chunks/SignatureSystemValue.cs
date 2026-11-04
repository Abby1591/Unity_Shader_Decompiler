namespace Parser.DXBC.Chunks;

// The D3D_NAME (d3dcommon.h) numbering that signature chunks (ISGN/OSGN)
// use for SystemValue fields — distinct from the D3D10_SB_NAME numbering
// the instruction stream encodes.
public enum SignatureSystemValue
{
    Undefined = 0,
    Position = 1,
    ClipDistance = 2,
    CullDistance = 3,
    RenderTargetArrayIndex = 4,
    ViewportArrayIndex = 5,
    VertexId = 6,
    PrimitiveId = 7,
    InstanceId = 8,
    IsFrontFace = 9,
    SampleIndex = 10,
    FinalQuadEdgeTessfactor = 11,
    FinalQuadInsideTessfactor = 12,
    FinalTriEdgeTessfactor = 13,
    FinalTriInsideTessfactor = 14,
    FinalLineDetailTessfactor = 15,
    FinalLineDensityTessfactor = 16,
    Barycentrics = 23,
    ShadingRate = 24,
    CullPrimitive = 25,
    Target = 64,
    Depth = 65,
    Coverage = 66,
    DepthGreaterEqual = 67,
    DepthLessEqual = 68,
    StencilRef = 69,
    InnerCoverage = 70,
}

public static class SignatureSystemValueExtensions
{
    public static SignatureSystemValue ToSignatureSystemValue(this uint value) =>
        System.Enum.IsDefined(typeof(SignatureSystemValue), (int)value)
            ? (SignatureSystemValue)value
            : SignatureSystemValue.Undefined;
}