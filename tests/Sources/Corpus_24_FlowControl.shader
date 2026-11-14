Shader "Corpus/24 Flow Control"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Iterations ("Iterations", Int) = 8
        _Threshold ("Threshold", Range(0, 1)) = 0.5
        _Mode ("Mode", Int) = 0
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }

        Pass
        {
            Name "FLOW"
            Cull Off
            ZWrite On

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 4.0
            #pragma only_renderers d3d11
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            int _Iterations;
            float _Threshold;
            int _Mode;

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord.xy;
                return o;
            }

            float DynamicLoop(float seed)
            {
                float value = seed;
                [loop]
                for (int i = 0; i < _Iterations; i++)
                {
                    value = value * 0.5 + 0.25;
                }
                return value;
            }

            float UnrolledLoop(float seed)
            {
                float value = seed;
                [unroll]
                for (int i = 0; i < 8; i++)
                    value = value * 0.5 + 0.125;
                return value;
            }

            float Branchy(float value)
            {
                [branch]
                if (value > _Threshold)
                    return value * 2.0;
                return value * 0.5;
            }

            float Flattened(float value)
            {
                [flatten]
                if (value > 0.5)
                    value = 1.0 - value;
                return value;
            }

            float Switchy(int mode, float value)
            {
                [forcecase]
                switch (mode)
                {
                    case 0: value += 0.1; break;
                    case 1: value += 0.2; break;
                    case 2: value += 0.3; break;
                    case 3: value += 0.4; break;
                    default: value += 0.5; break;
                }
                return value;
            }

            float4 frag(v2f i) : SV_Target
            {
                float value = tex2D(_MainTex, i.uv).r;
                value = DynamicLoop(value);
                value = UnrolledLoop(value);
                value = Branchy(value);
                value = Flattened(value);
                value = Switchy(_Mode, value);

                // A nested loop with an early return.
                for (int y = 0; y < 4; y++)
                {
                    for (int x = 0; x < 4; x++)
                    {
                        if (x * y > _Iterations)
                            return float4(value.xxx, 1.0);
                        value += tex2D(_MainTex, i.uv + float2(x, y) * 0.01).r * 0.01;
                    }
                }

                // do-while and discard.
                int guard = 0;
                do
                {
                    value = frac(value * 1.37 + 0.11);
                    guard++;
                } while (guard < 3);

                float alpha = tex2D(_MainTex, i.uv).a;
                clip(alpha - _Threshold);
                if (value < 0.01)
                    discard;

                return float4(frac(value).xxx, 1.0);
            }
            ENDCG
        }
    }

    FallBack "Diffuse"
}
