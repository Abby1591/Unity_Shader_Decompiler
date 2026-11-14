Shader "Corpus/09 Surface Custom Lighting"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo", 2D) = "white" {}
        _RimColor ("Rim Color", Color) = (1, 1, 1, 1)
        _RimPower ("Rim Power", Range(0.1, 8)) = 3
        _Specular ("Specular", Range(0, 1)) = 0.5
        _Gloss ("Gloss", Range(0, 1)) = 0.5
        _Wrap ("Wrap", Range(0, 1)) = 0.5
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }
        LOD 250

        CGPROGRAM
        #pragma surface surf CorpusLighting fullforwardshadows exclude_path:deferred
        #pragma target 3.0
        #pragma only_renderers d3d11

        sampler2D _MainTex;
        fixed4 _Color;
        fixed4 _RimColor;
        half _RimPower;
        half _Specular;
        half _Gloss;
        half _Wrap;

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
            float3 worldNormal;
            float3 worldPos;
        };

        half4 LightingCorpusLighting(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
        {
            half ndotl = dot(s.Normal, lightDir);
            half wrapped = saturate((ndotl + _Wrap) / (1.0 + _Wrap));
            half3 halfDir = normalize(lightDir + viewDir);
            half spec = pow(saturate(dot(s.Normal, halfDir)), 64.0) * _Specular;
            half rim = pow(1.0 - saturate(dot(s.Normal, viewDir)), _RimPower);

            half4 c;
            c.rgb = s.Albedo * _LightColor0.rgb * (wrapped * atten);
            c.rgb += _LightColor0.rgb * spec * _Gloss * atten;
            c.rgb += s.Emission + _RimColor.rgb * rim * 0.1;
            c.a = s.Alpha;
            return c;
        }

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Emission = c.rgb * 0.02;
            o.Specular = _Specular;
            o.Gloss = _Gloss;
            o.Alpha = c.a;
        }
        ENDCG
    }

    FallBack "Diffuse"
}
