Shader "Corpus/36 Dissolve"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo", 2D) = "white" {}
        _DissolveMap ("Dissolve Map", 2D) = "gray" {}
        _Cutoff ("Dissolve", Range(0, 1)) = 0.5
        _EdgeWidth ("Edge Width", Range(0, 0.5)) = 0.05
        [HDR] _EdgeColor ("Edge Color", Color) = (1, 0.3, 0, 1)
        _Metallic ("Metallic", Range(0, 1)) = 0
        _Smoothness ("Smoothness", Range(0, 1)) = 0.5
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows addshadow
        #pragma target 4.0
        #pragma only_renderers d3d11
        #include "UnityCG.cginc"

        sampler2D _MainTex;
        sampler2D _DissolveMap;
        fixed4 _Color;
        fixed4 _EdgeColor;
        half _Cutoff;
        half _EdgeWidth;
        half _Metallic;
        half _Smoothness;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_DissolveMap;
            float3 worldPos;
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
    }

    FallBack "Standard"
}
