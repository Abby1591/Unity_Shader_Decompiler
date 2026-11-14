Shader "Corpus/35 Hologram"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (0.1, 0.8, 1, 1)
        _FresnelPower ("Fresnel Power", Range(0.1, 8)) = 3
        _ScanlineDensity ("Scanline Density", Range(1, 200)) = 80
        _ScanlineSpeed ("Scanline Speed", Range(-10, 10)) = 3
        _FlickerSpeed ("Flicker Speed", Range(0, 20)) = 7
        _NoiseStrength ("Noise Strength", Range(0, 1)) = 0.2
        _Alpha ("Alpha", Range(0, 1)) = 0.6
    }

    SubShader
    {
        Tags { "Queue" = "Transparent" "RenderType" = "Transparent" "IgnoreProjector" = "True" }
        Blend One One
        ZWrite Off
        Cull Off

        Pass
        {
            Name "HOLOGRAM"
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0
            #pragma only_renderers d3d11
            #include "UnityCG.cginc"
            #include "CorpusCommon.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float _FresnelPower;
            float _ScanlineDensity;
            float _ScanlineSpeed;
            float _FlickerSpeed;
            float _NoiseStrength;
            float _Alpha;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
                float3 viewDir : TEXCOORD3;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.viewDir = UnityWorldSpaceViewDir(o.worldPos);
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float4 tex = tex2D(_MainTex, i.uv);
                float fresnel = CorpusFresnel(i.normal, i.viewDir, _FresnelPower);
                float scan = sin((i.worldPos.y + _Time.y * _ScanlineSpeed) * _ScanlineDensity) * 0.5 + 0.5;
                float flicker = 0.7 + 0.3 * sin(_Time.y * _FlickerSpeed);
                float noise = CorpusNoise(i.uv * 32.0 + _Time.y);

                float3 color = _Color.rgb * tex.rgb;
                color += _Color.rgb * fresnel * 2.0;
                color *= lerp(1.0, scan, 0.7);
                color *= lerp(1.0, noise, _NoiseStrength);
                color *= flicker;
                float alpha = saturate((fresnel + scan * 0.3) * _Alpha * tex.a);
                return float4(color * alpha, alpha);
            }
            ENDCG
        }
    }

    FallBack "Legacy Shaders/Transparent/VertexLit"
}
