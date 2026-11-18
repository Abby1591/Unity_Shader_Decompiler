Shader "Corpus/10 Surface Tessellation"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo", 2D) = "white" {}
        _Tess ("Tessellation", Range(1, 32)) = 4
        _Disp ("Displacement", Range(0, 1)) = 0.1
        _Phong ("Phong Strength", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
        LOD 400
        CGPROGRAM
        #include "UnityCG.cginc"
        #pragma surface surf Standard fullforwardshadows
        #pragma target 5.0

        float4 _Color;
        sampler2D _MainTex;

        // Best-effort surface reconstruction from the compiled
        // passes. The passes are authoritative; vertex, finalcolor
        // and tessellation functions (if any) are not recovered.
        // Not reconstructed: tessellation (tessEdge/disp).

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Metallic = 0.1;
            o.Smoothness = 0.5;
            o.Alpha = c.a;
        }
        ENDCG

        // Compiled passes omitted for size. Rerun with
        // --keep-passes to include the verified passes.
    }
    Fallback "Standard"
}
