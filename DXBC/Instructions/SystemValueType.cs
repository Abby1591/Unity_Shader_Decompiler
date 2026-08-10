namespace Parser.DXBC.IR;

// There are TWO distinct system-value enums in the D3D formats, and they are
// NOT the same enum — this file carries both so neither set of values gets
// mangled by sharing a single numeric space:
//
//   1. D3D10_SB_NAME (d3d11tokenizedprogramformat.h) is what the instruction
//      stream encodes. dcl_input_sgv / dcl_output_siv each end with a
//      trailing NameToken DWORD, and that NameToken is a D3D10_SB_NAME value
//      (this is what IRInputDeclaration.SystemValue /
//      IROutputDeclaration.SystemValue currently hold). It goes 0-25 and its
//      tess-factors are PER-EDGE (11-22).
//
//   2. D3D_NAME (d3dcommon.h) is what the signature chunks encode. The
//      ISGN/OSGN SystemValue field (SignatureElement.SystemValue) is a
//      D3D_NAME value. It groups tess-factors (11-16) and adds the 64-70
//      rasterizer-interpreted outputs (SV_Target, SV_Depth, SV_Coverage...)
//      that never appear in the instruction stream.
//
// 0-10 are numerically identical in both. They diverge at the tess factors.
public enum SystemValueType
{
    // D3D10_SB_NAME (d3d11tokenizedprogramformat.h / D3D12TokenizedProgramFormat.hpp)
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

    FinalQuadUEq0EdgeTessFactor = 11,
    FinalQuadVEq0EdgeTessFactor = 12,
    FinalQuadUEq1EdgeTessFactor = 13,
    FinalQuadVEq1EdgeTessFactor = 14,
    FinalQuadUInsideTessFactor = 15,
    FinalQuadVInsideTessFactor = 16,
    FinalTriUEq0EdgeTessFactor = 17,
    FinalTriVEq0EdgeTessFactor = 18,
    FinalTriWEq0EdgeTessFactor = 19,
    FinalTriInsideTessFactor = 20,
    FinalLineDetailTessFactor = 21,
    FinalLineDensityTessFactor = 22,

    Barycentrics = 23,
    ShadingRate = 24,
    CullPrimitive = 25,
}

// D3D_NAME (d3dcommon.h) — the numbering used by ISGN/OSGN/PSGN signature
// chunk SystemValue fields (SignatureElement.SystemValue).
public enum SignatureSystemValue
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
    FinalQuadInsideTessFactor = 12,
    FinalTriEdgeTessFactor = 13,
    FinalTriInsideTessFactor = 14,
    FinalLineDetailTessFactor = 15,
    FinalLineDensityTessFactor = 16,

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
    // dcl_input_sgv / dcl_output_siv store the system value as a plain uint
    // today (IRInputDeclaration.SystemValue / IROutputDeclaration.SystemValue).
    // The trailing NameToken is a D3D10_SB_NAME value — use this to interpret
    // it rather than comparing magic numbers inline.
    public static SystemValueType ToSystemValueType(this uint value)
    {
        return System.Enum.IsDefined(typeof(SystemValueType), (int)value)
            ? (SystemValueType)value
            : SystemValueType.Undefined;
    }

    // SignatureElement.SystemValue comes from an ISGN/OSGN/PSGN signature
    // chunk, whose SystemValue field is a D3D_NAME (d3dcommon.h) value.
    public static SignatureSystemValue ToSignatureSystemValue(this uint value)
    {
        return System.Enum.IsDefined(typeof(SignatureSystemValue), (int)value)
            ? (SignatureSystemValue)value
            : SignatureSystemValue.Undefined;
    }
}
