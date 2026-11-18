Shader "Corpus/07 Surface Lambert"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo", 2D) = "white" {}
        _LightMap ("Lightmap", 2D) = "white" {}
        _Cutoff ("Alpha Cutoff", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
        LOD 200
        CGPROGRAM
        #include "UnityCG.cginc"
        #pragma surface surf Lambert exclude_path:deferred fullforwardshadows
        #pragma target 3.5

        float4 _Color;
        sampler2D _MainTex;
        sampler2D _LightMap;
        float _Cutoff;

        // Best-effort surface reconstruction from the compiled
        // passes. The passes are authoritative; vertex, finalcolor
        // and tessellation functions (if any) are not recovered.

        struct Input
        {
            float2 uv_MainTex;
            float2 uv2_LightMap;
            float4 color : COLOR;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color * IN.color;
            o.Albedo = c.rgb * tex2D(_LightMap, IN.uv2_LightMap).rgb;
            o.Emission = o.Albedo * 0.05;
            o.Alpha = c.a;
            o.Gloss = 0.0;
            o.Specular = 0.0;
            clip(o.Alpha - _Cutoff);
        }
        ENDCG

        // Compiled passes omitted for size. Rerun with
        // --keep-passes to include the verified passes.
    }
    Fallback "Legacy Shaders/Diffuse"
}
