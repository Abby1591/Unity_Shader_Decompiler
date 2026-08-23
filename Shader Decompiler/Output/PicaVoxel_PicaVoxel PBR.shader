Shader "PicaVoxel/PicaVoxel PBR"
{
    Properties
    {
        _Metallic ("Metallic", Range(0, 1)) = 0
        _Gloss ("Gloss", Range(0, 1)) = 0
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

        uniform float _Gloss;
        uniform float _Metallic;
        uniform float4 _Tint;

        struct Input
        {
            float4 vertexColor : COLOR;
        };

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            o.Albedo = (IN.vertexColor.rgb * _Tint.rgb);
            o.Metallic = _Metallic;
            o.Smoothness = _Gloss;
            o.Alpha = 1;
        }
        ENDCG

        // Compiled passes omitted for size. Rerun with
        // --keep-passes to include the verified passes.
    }
    Fallback "PicaVoxel/PicaVoxel Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
