Shader "Corpus/46 Procedural"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _Scale ("Scale", Float) = 4
        _Speed ("Speed", Float) = 1
        _Threshold ("Threshold", Range(0, 1)) = 0.3
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }

        Pass
        {
            Name "PROCEDURAL"
            Cull Off
            ZWrite On

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 5.0
            #pragma only_renderers d3d11
            #include "UnityCG.cginc"
            #include "CorpusCommon.cginc"

            float4 _Color;
            float _Scale;
            float _Speed;
            float _Threshold;

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
            };

            v2f vert(appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord.xy;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                return o;
            }

            float CorpusScene(float3 p)
            {
                float d = length(p) - 1.0;
                d = min(d, length(p - float3(1.0, 0.5, 0.0)) - 0.4);
                d = min(d, length(p - float3(-1.0, -0.5, 0.0)) - 0.6);
                d += CorpusNoise(p.xz * 4.0) * 0.1;
                return d;
            }

            float4 frag(v2f i) : SV_Target
            {
                float2 uv = (i.uv - 0.5) * 2.0;
                float3 ro = float3(0, 0, -3);
                float3 rd = normalize(float3(uv, 1.5));

                float t = 0.0;
                float hit = 0.0;
                [loop]
                for (int stepIndex = 0; stepIndex < 64; stepIndex++)
                {
                    float3 p = ro + rd * t;
                    float d = CorpusScene(p);
                    if (d < 0.001)
                    {
                        hit = 1.0;
                        break;
                    }
                    t += d;
                    if (t > 20.0)
                        break;
                }

                float3 p = ro + rd * t;
                float3 n = normalize(float3(
                    CorpusScene(p + float3(0.01, 0, 0)) - CorpusScene(p - float3(0.01, 0, 0)),
                    CorpusScene(p + float3(0, 0.01, 0)) - CorpusScene(p - float3(0, 0.01, 0)),
                    CorpusScene(p + float3(0, 0, 0.01)) - CorpusScene(p - float3(0, 0, 0.01))));

                float3 lightDir = normalize(float3(0.5, 1.0, -0.5));
                float diffuse = saturate(dot(n, lightDir));
                float rim = pow(1.0 - saturate(dot(n, -rd)), 3.0);
                float fbm = CorpusFbm(i.uv * _Scale + _Time.y * _Speed, 5, 2.0, 0.5);
                float bands = smoothstep(0.2, 0.8, sin((p.y + fbm) * 20.0) * 0.5 + 0.5);

                float3 color = lerp(float3(0.1, 0.1, 0.2), _Color.rgb, diffuse);
                color += rim * 0.5;
                color *= bands;
                color += fbm * 0.2;
                color *= hit;

                float edge = fwidth(fbm);
                color += step(_Threshold, fbm) * edge * 4.0;

                if (hit < 0.5)
                    discard;
                clip(fbm - 0.05);

                float angle = atan2(uv.y, uv.x);
                color += (sin(angle) * 0.5 + 0.5) * 0.02;
                return float4(LinearToGammaSpace(saturate(color)), 1.0);
            }
            ENDCG
        }
    }

    FallBack Off
}
