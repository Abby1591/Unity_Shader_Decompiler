Shader "PicaVoxel/PicaVoxel PBR OneMinus Alpha Emissive"
{
    Properties
    {
        _Metallic ("Metallic", Range(0, 1)) = 0
        _Gloss ("Gloss", Range(0, 1)) = 0.8
        _GlowAmount ("Glow Amount", Range(1, 100)) = 1
        _Tint ("Tint", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 0
        CGPROGRAM
        #include "UnityCG.cginc"
        #pragma surface surf Standard
        #pragma target 3.0

        struct Input
        {
            float4 vertexColor : COLOR;
        };

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            o.Albedo = (IN.vertexColor.rgb * _Tint.rgb);
            o.Metallic = _Metallic;
            o.Smoothness = _Gloss;
            o.Emission = (IN.vertexColor.rgb * _Tint.rgb) * (1 - IN.vertexColor.a) * _GlowAmount;
            o.Alpha = 1;
        }
        ENDCG

        // Compiled passes omitted for size. Rerun with
        // --keep-passes to include the verified passes.
    }
    Fallback "PicaVoxel/PicaVoxel Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
