Shader "Corpus/05 Surface Standard"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo", 2D) = "white" {}
        [Normal] _BumpMap ("Normal", 2D) = "bump" {}
        _BumpScale ("Normal Scale", Float) = 1
        _Metallic ("Metallic", Range(0, 1)) = 0
        _Glossiness ("Smoothness", Range(0, 1)) = 0.5
        _MetallicGlossMap ("Metallic Map", 2D) = "white" {}
        _OcclusionMap ("Occlusion", 2D) = "white" {}
        _OcclusionStrength ("Occlusion Strength", Range(0, 1)) = 1
        [HDR] _EmissionColor ("Emission", Color) = (0, 0, 0, 1)
        _EmissionMap ("Emission Map", 2D) = "white" {}
        _Cutoff ("Alpha Cutoff", Range(0, 1)) = 0.5
        _DetailMask ("Detail Mask", 2D) = "white" {}
        _DetailAlbedo ("Detail Albedo", 2D) = "gray" {}
        _DetailNormal ("Detail Normal", 2D) = "bump" {}
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" "PerformanceChecks" = "False" }
        LOD 300

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows addshadow vertex:vert finalcolor:finalColor
        #pragma target 4.5
        #pragma only_renderers d3d11
        #pragma multi_compile_instancing

        sampler2D _MainTex;
        sampler2D _BumpMap;
        sampler2D _MetallicGlossMap;
        sampler2D _OcclusionMap;
        sampler2D _EmissionMap;
        sampler2D _DetailMask;
        sampler2D _DetailAlbedo;
        sampler2D _DetailNormal;

        half _BumpScale;
        half _Metallic;
        half _Glossiness;
        half _OcclusionStrength;
        half _Cutoff;
        fixed4 _Color;
        fixed4 _EmissionColor;

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
            float3 worldPos;
            float3 viewDir;
            float4 screenPos;
            float4 color : COLOR;
            INTERNAL_DATA
        };

        void vert(inout appdata_full v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input, o);
            o.color = v.color;
        }

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 albedo = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            fixed4 detailMask = tex2D(_DetailMask, IN.uv_DetailMask);
            fixed3 detailAlbedo = tex2D(_DetailAlbedo, IN.uv_DetailAlbedo).rgb * 2.0 - 1.0;
            albedo.rgb *= lerp(1.0, detailAlbedo, detailMask.r);

            half4 metallicGloss = tex2D(_MetallicGlossMap, IN.uv_MetallicGlossMap);
            o.Albedo = albedo.rgb;
            o.Normal = UnpackNormalWithScale(tex2D(_BumpMap, IN.uv_BumpMap), _BumpScale);
            o.Normal = normalize(o.Normal + UnpackNormalWithScale(tex2D(_DetailNormal, IN.uv_DetailNormal), _BumpScale) * detailMask.r);
            o.Metallic = metallicGloss.r * _Metallic;
            o.Smoothness = metallicGloss.a * _Glossiness;
            o.Occlusion = lerp(1.0, tex2D(_OcclusionMap, IN.uv_OcclusionMap).g, _OcclusionStrength);
            o.Emission = tex2D(_EmissionMap, IN.uv_EmissionMap).rgb * _EmissionColor.rgb;
            o.Alpha = albedo.a;
            clip(o.Alpha - _Cutoff);

            float3 worldNormal = WorldNormalVector(IN, o.Normal);
            o.Emission += worldNormal * 0.0;
        }

        void finalColor(Input IN, SurfaceOutputStandard o, inout fixed4 color)
        {
            color.rgb = lerp(color.rgb, color.rgb * IN.color.rgb, 0.1);
        }
        ENDCG
    }

    FallBack "Standard"
}
