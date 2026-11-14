Shader "Corpus/07 Surface Lambert"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo", 2D) = "white" {}
        _LightMap ("Lightmap", 2D) = "white" {}
        _Cutoff ("Alpha Cutoff", Range(0, 1)) = 0.5
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Lambert exclude_path:deferred exclude_path:prepass
        #pragma target 3.0
        #pragma only_renderers d3d11
        #pragma multi_compile_instancing

        sampler2D _MainTex;
        sampler2D _LightMap;
        fixed4 _Color;
        half _Cutoff;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv2_LightMap;
            float3 worldNormal;
            float3 viewDir;
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
    }

    FallBack "Legacy Shaders/Diffuse"
}
