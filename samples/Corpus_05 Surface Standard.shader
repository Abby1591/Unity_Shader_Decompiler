Shader "Corpus/05 Surface Standard"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo", 2D) = "white" {}
        [Normal]
        _BumpMap ("Normal", 2D) = "bump" {}
        _BumpScale ("Normal Scale", Float) = 1
        _Metallic ("Metallic", Range(0, 1)) = 0
        _Glossiness ("Smoothness", Range(0, 1)) = 0.5
        _MetallicGlossMap ("Metallic Map", 2D) = "white" {}
        _OcclusionMap ("Occlusion", 2D) = "white" {}
        _OcclusionStrength ("Occlusion Strength", Range(0, 1)) = 1
        [HDR]
        _EmissionColor ("Emission", Color) = (0,0,0,1)
        _EmissionMap ("Emission Map", 2D) = "white" {}
        _Cutoff ("Alpha Cutoff", Range(0, 1)) = 0.5
        _DetailMask ("Detail Mask", 2D) = "white" {}
        _DetailAlbedo ("Detail Albedo", 2D) = "gray" {}
        _DetailNormal ("Detail Normal", 2D) = "bump" {}
    }
    SubShader
    {
        Tags { "PerformanceChecks"="False" "QUEUE"="Geometry" "RenderType"="Opaque" }
        LOD 300
        CGPROGRAM
        #include "UnityCG.cginc"
        #pragma surface surf Standard addshadow fullforwardshadows
        #pragma target 4.5

        float4 _Color;
        sampler2D _MainTex;
        sampler2D _BumpMap;
        float _BumpScale;
        float _Metallic;
        float _Glossiness;
        sampler2D _MetallicGlossMap;
        sampler2D _OcclusionMap;
        float _OcclusionStrength;
        float4 _EmissionColor;
        sampler2D _EmissionMap;
        float _Cutoff;
        sampler2D _DetailMask;
        sampler2D _DetailAlbedo;
        sampler2D _DetailNormal;

        // Best-effort surface reconstruction from the compiled
        // passes. The passes are authoritative; vertex, finalcolor
        // and tessellation functions (if any) are not recovered.

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float2 uv_MetallicGlossMap;
            float2 uv_OcclusionMap;
            float2 uv_EmissionMap;
            float2 uv_DetailMask;
            float2 uv_DetailAlbedo;
            float2 uv_DetailNormal;
        };

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            fixed4 detailMask = tex2D(_DetailMask, IN.uv_DetailMask);
            fixed3 detailAlbedo = tex2D(_DetailAlbedo, IN.uv_DetailAlbedo).rgb * 2.0 - 1.0;
            c.rgb *= lerp(1.0, detailAlbedo, detailMask.r);
            o.Albedo = c.rgb;
            o.Normal = UnpackNormalWithScale(tex2D(_BumpMap, IN.uv_BumpMap), _BumpScale);
            o.Normal = normalize(o.Normal + UnpackNormalWithScale(tex2D(_DetailNormal, IN.uv_DetailNormal), _BumpScale) * detailMask.r);
            half4 metallicGloss = tex2D(_MetallicGlossMap, IN.uv_MetallicGlossMap);
            o.Metallic = metallicGloss.r * _Metallic;
            o.Smoothness = metallicGloss.a * _Glossiness;
            o.Occlusion = lerp(1.0, tex2D(_OcclusionMap, IN.uv_OcclusionMap).g, _OcclusionStrength);
            o.Emission = tex2D(_EmissionMap, IN.uv_EmissionMap).rgb * _EmissionColor.rgb;
            o.Alpha = c.a;
            clip(o.Alpha - _Cutoff);
        }
        ENDCG

        // Compiled passes omitted for size. Rerun with
        // --keep-passes to include the verified passes.
    }
    Fallback "Standard"
}
