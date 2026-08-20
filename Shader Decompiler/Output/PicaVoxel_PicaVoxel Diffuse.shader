Shader "PicaVoxel/PicaVoxel Diffuse"
{
    Properties
    {
        _Tint ("Tint", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        CGPROGRAM
        #include "UnityCG.cginc"
        #pragma surface surf Lambert

        struct Input
        {
            float4 vertexColor : COLOR;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = (IN.vertexColor.rgb * _Tint.rgb);
            o.Alpha = 1;
        }
        ENDCG

        // Compiled passes omitted for size. Rerun with
        // --keep-passes to include the verified passes.
    }
    Fallback "VertexLit"
}
