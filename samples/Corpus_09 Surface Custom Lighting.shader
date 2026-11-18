Shader "Corpus/09 Surface Custom Lighting"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo", 2D) = "white" {}
        _RimColor ("Rim Color", Color) = (1,1,1,1)
        _RimPower ("Rim Power", Range(0.1, 8)) = 3
        _Specular ("Specular", Range(0, 1)) = 0.5
        _Gloss ("Gloss", Range(0, 1)) = 0.5
        _Wrap ("Wrap", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
        LOD 250
        CGPROGRAM
        #include "UnityCG.cginc"
        #pragma surface surf Custom exclude_path:deferred fullforwardshadows
        #pragma target 3.5

        float4 _Color;
        sampler2D _MainTex;
        float4 _RimColor;
        float _RimPower;
        float _Specular;
        float _Gloss;
        float _Wrap;

        // Best-effort surface reconstruction from the compiled
        // passes. The passes are authoritative; vertex, finalcolor
        // and tessellation functions (if any) are not recovered.
        // Not reconstructed: custom lighting is reconstructed heuristically.

        struct Input
        {
            float2 uv_MainTex;
        };

        half4 LightingCustom(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
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

        // Compiled passes omitted for size. Rerun with
        // --keep-passes to include the verified passes.
    }
    Fallback "Diffuse"
}
