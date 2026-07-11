namespace Parser.DXBC.IR;

// Mirrors the D3D_NAME enum (d3dcommon.h). This is what dcl_input_sgv's and
// dcl_output_siv's trailing ExtraData DWORD actually encodes — it was being
// stored as a raw uint with no decoding. Values below are the stable public
// D3D_NAME numbering.
public enum SystemValueType
{
    Undefined = 0,
    Position = 1,
    ClipDistance = 2,
    CullDistance = 3,
    RenderTargetArrayIndex = 4,
    ViewportArrayIndex = 5,
    VertexID = 6,
    PrimitiveID = 7,
    InstanceID = 8,
    IsFrontFace = 9,
    SampleIndex = 10,

    FinalQuadEdgeTessFactor = 11,
    FinalQuadInsideTessFactor = 15,
    FinalTriEdgeTessFactor = 16,
    FinalTriInsideTessFactor = 19,
    FinalLineDetailTessFactor = 20,
    FinalLineDensityTessFactor = 21,

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

public static class SystemValueTypeExtensions
{
    // dcl_input_sgv/dcl_output_siv store this as a plain uint today
    // (IRInputDeclaration.SystemValue / IROutputDeclaration.SystemValue).
    // Use this to interpret it rather than comparing magic numbers inline.
    public static SystemValueType ToSystemValueType(this uint value)
    {
        return System.Enum.IsDefined(typeof(SystemValueType), (int)value)
            ? (SystemValueType)value
            : SystemValueType.Undefined;
    }
}