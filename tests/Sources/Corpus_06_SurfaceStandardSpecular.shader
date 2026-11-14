Shader "Corpus/06 Surface Standard Specular"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo", 2D) = "white" {}
        [Normal] _BumpMap ("Normal", 2D) = "bump" {}
        _SpecColor ("Specular", Color) = (0.2, 0.2, 0.2, 1)
        _SpecGlossMap ("Specular Map", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0, 1)) = 0.5
        _OcclusionMap ("Occlusion", 2D) = "white" {}
        [HDR] _EmissionColor ("Emission", Color) = (0, 0, 0, 1)
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }
        LOD 300

        CGPROGRAM
        #pragma surface surf StandardSpecular fullforwardshadows
        #pragma target 4.5
        #pragma only_renderers d3d11

        sampler2D _MainTex;
        sampler2D _BumpMap;
        sampler2D _SpecGlossMap;
        sampler2D _OcclusionMap;
        fixed4 _Color;
        fixed4 _EmissionColor;
        half _Glossiness;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float2 uv_SpecGlossMap;
            float2 uv_OcclusionMap;
            float3 worldPos;
            INTERNAL_DATA
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
            o.Emission += WorldNormalVector(IN, o.Normal) * 0.0;
        }
        ENDCG
    }

    FallBack "Standard"
}
