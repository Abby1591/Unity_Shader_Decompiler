Shader "Corpus/36 Dissolve"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo", 2D) = "white" {}
        _DissolveMap ("Dissolve Map", 2D) = "gray" {}
        _Cutoff ("Dissolve", Range(0, 1)) = 0.5
        _EdgeWidth ("Edge Width", Range(0, 0.5)) = 0.05
        [HDR]
        _EdgeColor ("Edge Color", Color) = (1,0.3,0,1)
        _Metallic ("Metallic", Range(0, 1)) = 0
        _Smoothness ("Smoothness", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
        LOD 0
        CGPROGRAM
        #include "UnityCG.cginc"
        #pragma surface surf Standard addshadow fullforwardshadows
        #pragma target 3.5

        float4 _Color;
        sampler2D _MainTex;
        sampler2D _DissolveMap;
        float _Cutoff;
        float _EdgeWidth;
        float4 _EdgeColor;
        float _Metallic;
        float _Smoothness;

        // Best-effort surface reconstruction from the compiled
        // passes. The passes are authoritative; vertex, finalcolor
        // and tessellation functions (if any) are not recovered.

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_DissolveMap;
        };

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 albedo = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            half dissolve = tex2D(_DissolveMap, IN.uv_DissolveMap).r;
            half edge = smoothstep(_Cutoff, _Cutoff + _EdgeWidth, dissolve);
            clip(dissolve - _Cutoff);
            o.Albedo = albedo.rgb * edge;
            o.Metallic = _Metallic;
            o.Smoothness = _Smoothness;
            o.Emission = _EdgeColor.rgb * (1.0 - edge) * _EdgeColor.a;
            o.Alpha = albedo.a;
        }
        ENDCG

        // Compiled passes omitted for size. Rerun with
        // --keep-passes to include the verified passes.
    }
    Fallback "Standard"
}
