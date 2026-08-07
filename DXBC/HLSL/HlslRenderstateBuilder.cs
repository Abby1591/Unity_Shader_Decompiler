using System.Text.Json;

namespace Parser.DXBC.Hlsl.Ast;

// Stage 6 — Pass Generation.
//
// Turns the "renderState" object metadata.py already extracted (flat
// field names matching libs/metadata.py's _render_state — see that file
// for the Unity field paths these came from) into the typed nodes in
// HlslAst.cs. Nothing here talks to raw Unity JSON directly; that
// boundary stays in ShaderMetadata/PassMetadata so this stays a pure
// "normalized JSON in, typed AST out" step.
public static class HlslRenderStateBuilder
{
    public static HlslRenderState Build(JsonElement renderState)
    {
        if (renderState.ValueKind != JsonValueKind.Object)
            return new HlslRenderState();

        var state = new HlslRenderState
        {
            Cull = EnumOr(renderState, "cull", HlslCullMode.Back),
            ZTest = EnumOr(renderState, "zTest", HlslCompareFunction.LessEqual),
            ZWrite = BoolOr(renderState, "zWrite", true),
            ZClip = BoolOr(renderState, "zClip", true),
            Lighting = BoolOr(renderState, "lighting", false),
            FogMode = EnumOr(renderState, "fogMode", HlslFogMode.None),
            AlphaToMask = BoolOr(renderState, "alphaToMask", false),
            OffsetFactor = FloatOr(renderState, "offsetFactor", 0f),
            OffsetUnits = FloatOr(renderState, "offsetUnits", 0f),
            Conservative = BoolOr(renderState, "conservative", false),

            StencilRef = IntOr(renderState, "stencilRef", 0),
            StencilReadMask = IntOr(renderState, "stencilReadMask", 255),
            StencilWriteMask = IntOr(renderState, "stencilWriteMask", 255),
            StencilFront = BuildStencilFace(renderState, "stencilOpFront"),
            StencilBack = BuildStencilFace(renderState, "stencilOpBack"),

            SeparateBlend = BoolOr(renderState, "separateBlend", false),
            Blend = BuildBlend(renderState, "blend"),
        };

        state.BlendTargets.Add(state.Blend);
        return state;
    }

    private static HlslStencilFaceState BuildStencilFace(JsonElement parent, string key)
    {
        if (!parent.TryGetProperty(key, out var face) || face.ValueKind != JsonValueKind.Object)
            return new HlslStencilFaceState();

        // metadata.py passes m_StencilOpFront/Back through raw (each
        // sub-field still wrapped as {"m_Value": N}), unlike the flat
        // scalar fields elsewhere in renderState — unwrap here.
        return new HlslStencilFaceState
        {
            Comp = EnumOrWrapped(face, "m_Comp", HlslCompareFunction.Always),
            Fail = EnumOrWrapped(face, "m_Fail", HlslStencilOp.Keep),
            ZFail = EnumOrWrapped(face, "m_ZFail", HlslStencilOp.Keep),
            Pass = EnumOrWrapped(face, "m_Pass", HlslStencilOp.Keep),
        };
    }

    private static HlslBlendState BuildBlend(JsonElement parent, string key)
    {
        if (!parent.TryGetProperty(key, out var blend) || blend.ValueKind != JsonValueKind.Object)
            return new HlslBlendState();

        return new HlslBlendState
        {
            SrcBlend = EnumOr(blend, "srcBlend", HlslBlendMode.One),
            DstBlend = EnumOr(blend, "dstBlend", HlslBlendMode.Zero),
            SrcBlendAlpha = EnumOr(blend, "srcBlendAlpha", HlslBlendMode.One),
            DstBlendAlpha = EnumOr(blend, "dstBlendAlpha", HlslBlendMode.Zero),
            BlendOp = EnumOr(blend, "blendOp", HlslBlendOp.Add),
            BlendOpAlpha = EnumOr(blend, "blendOpAlpha", HlslBlendOp.Add),
            ColorMask = blend.TryGetProperty("colorMask", out var cm) && cm.ValueKind == JsonValueKind.Number
                ? cm.GetInt32()
                : null,
        };
    }

    // -- scalar helpers, all null-safe against a field being absent, an
    //    unexpected type showing up (fall back to the default rather than
    //    throw), or an enum value outside the range we know about --

    private static TEnum EnumOr<TEnum>(JsonElement el, string key, TEnum fallback) where TEnum : struct, System.Enum
    {
        if (el.TryGetProperty(key, out var v) && v.ValueKind == JsonValueKind.Number && v.TryGetInt32(out int i))
            return System.Enum.IsDefined(typeof(TEnum), i) ? (TEnum)(object)i : fallback;
        return fallback;
    }

    // Same as EnumOr but for values still wrapped as {"m_Value": N}
    // (metadata.py leaves stencil sub-fields wrapped — see BuildStencilFace).
    private static TEnum EnumOrWrapped<TEnum>(JsonElement el, string key, TEnum fallback) where TEnum : struct, System.Enum
    {
        if (el.TryGetProperty(key, out var wrapper) && wrapper.ValueKind == JsonValueKind.Object
            && wrapper.TryGetProperty("m_Value", out var v) && v.ValueKind == JsonValueKind.Number
            && v.TryGetInt32(out int i))
        {
            return System.Enum.IsDefined(typeof(TEnum), i) ? (TEnum)(object)i : fallback;
        }
        return fallback;
    }

    private static bool BoolOr(JsonElement el, string key, bool fallback)
    {
        if (!el.TryGetProperty(key, out var v)) return fallback;
        return v.ValueKind switch
        {
            JsonValueKind.True => true,
            JsonValueKind.False => false,
            JsonValueKind.Number => v.GetInt32() != 0, // Unity often stores bools as 0/1
            _ => fallback,
        };
    }

    private static float FloatOr(JsonElement el, string key, float fallback) =>
        el.TryGetProperty(key, out var v) && v.ValueKind == JsonValueKind.Number && v.TryGetSingle(out float f)
            ? f
            : fallback;

    private static int IntOr(JsonElement el, string key, int fallback) =>
        el.TryGetProperty(key, out var v) && v.ValueKind == JsonValueKind.Number && v.TryGetInt32(out int i)
            ? i
            : fallback;
}