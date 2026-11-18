Shader "Corpus/06 Surface Standard Specular"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo", 2D) = "white" {}
        [Normal]
        _BumpMap ("Normal", 2D) = "bump" {}
        _SpecColor ("Specular", Color) = (0.2,0.2,0.2,1)
        _SpecGlossMap ("Specular Map", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0, 1)) = 0.5
        _OcclusionMap ("Occlusion", 2D) = "white" {}
        [HDR]
        _EmissionColor ("Emission", Color) = (0,0,0,1)
    }
    SubShader
    {
        Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
        LOD 300
        CGPROGRAM
        #include "UnityCG.cginc"
        #pragma surface surf StandardSpecular fullforwardshadows
        #pragma target 4.5

        float4 _Color;
        sampler2D _MainTex;
        sampler2D _BumpMap;
        float4 _SpecColor;
        sampler2D _SpecGlossMap;
        float _Glossiness;
        sampler2D _OcclusionMap;
        float4 _EmissionColor;

        // Best-effort surface reconstruction from the compiled
        // passes. The passes are authoritative; vertex, finalcolor
        // and tessellation functions (if any) are not recovered.

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float2 uv_SpecGlossMap;
            float2 uv_OcclusionMap;
        };

        void surf(Input IN, inout SurfaceOutputStandardSpecular o)
        {
            fixed4 albedo = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            fixed4 specGloss = tex2D(_SpecGlossMap, IN.uv_SpecGlossMap);
            o.Albedo = albedo.rgb;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            o.Specular = _SpecColor.rgb * specGloss.rgb;
            o.Smoothness = _Glossiness * specGloss.a;
            o.Occlusion = tex2D(_OcclusionMap, IN.uv_OcclusionMap).g;
            o.Emission = _EmissionColor.rgb * albedo.rgb;
            o.Alpha = albedo.a;
        }
        ENDCG

        // Compiled passes omitted for size. Rerun with
        // --keep-passes to include the verified passes.
    }
    Fallback "Standard"
}
