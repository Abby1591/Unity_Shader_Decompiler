Shader "Corpus/11 Surface Vertex Color"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo", 2D) = "white" {}
        _Wave ("Wave", Float) = 0.1
        _VertexColorBoost ("Vertex Color Boost", Range(0, 2)) = 0.5
    }
    SubShader
    {
        Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
        LOD 350
        CGPROGRAM
        #include "UnityCG.cginc"
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.5

        float4 _Color;
        sampler2D _MainTex;
        float _VertexColorBoost;

        // Best-effort surface reconstruction from the compiled
        // passes. The passes are authoritative; vertex, finalcolor
        // and tessellation functions (if any) are not recovered.
        // Not reconstructed: vertex modifier and finalColor.

        struct Input
        {
            float2 uv_MainTex;
            float4 color : COLOR;
        };

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color * IN.color;
            o.Albedo = c.rgb * (1.0 + _VertexColorBoost);
            o.Metallic = IN.color.r * 0.5;
            o.Smoothness = saturate(IN.color.g);
            o.Alpha = c.a;
        }
        ENDCG

        // Compiled passes omitted for size. Rerun with
        // --keep-passes to include the verified passes.
    }
    Fallback "Standard"
}
