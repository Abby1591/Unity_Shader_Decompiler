Shader "Corpus/23 Integer Math"
{
    Properties
    {
        _IntA ("Int A", Int) = 7
        _IntB ("Int B", Int) = 3
        _UInt ("UInt", Int) = 255
        _Float ("Float", Float) = 1.5
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }

        Pass
        {
            Name "INTEGER"
            Cull Off
            ZWrite On

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 5.0
            #pragma only_renderers d3d11
            #include "UnityCG.cginc"

            int _IntA;
            int _IntB;
            uint _UInt;
            float _Float;

            struct v2f { float4 pos : SV_POSITION; float2 uv : TEXCOORD0; };

            v2f vert(appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord.xy;
                return o;
            }

            int CorpusFactorial(int n)
            {
                int result = 1;
                [unroll]
                for (int i = 2; i <= n; i++)
                    result *= i;
                return result;
            }

            uint CorpusRotateLeft(uint value, uint count)
            {
                count &= 31;
                return (value << count) | (value >> (32 - count));
            }

            float4 frag(v2f i) : SV_Target
            {
                int a = _IntA;
                int b = _IntB;
                uint u = _UInt;
                int2 iv = int2((int)(i.uv.x * 10.0), (int)(i.uv.y * 10.0));
                uint2 uv2 = (uint2)iv;

                int add = a + b;
                int sub = a - b;
                int mul = a * b;
                int div = a / max(b, 1);
                int mod = a % max(b, 1);
                int neg = -a;
                int shl = a << 2;
                int shr = a >> 1;
                uint ushl = u << 3;
                uint ushr = u >> 2;
                uint andBits = u & 0xF0u;
                uint orBits = u | 0x0Fu;
                uint xorBits = u ^ 0xAAu;
                uint notBits = ~u;
                int firstHigh = firstbithigh(a);
                int firstLow = firstbitlow(a);
                uint count = countbits(u);
                uint reversed = reversebits(u);
                uint packed = f32tof16(_Float);
                float unpacked = f16tof32(packed);
                float asFloat = asfloat(u);
                uint asUint = asuint(_Float);
                int asInt = asint(u);
                bool isPositive = a > 0;
                int clampInt = clamp(a, 0, 10);
                int maxInt = max(a, b);
                int minInt = min(a, b);

                float value = (float)(add + sub + mul + div + mod + neg + shl + shr);
                value += (float)(ushl + ushr + andBits + orBits + xorBits + notBits);
                value += (float)(firstHigh + firstLow + (int)count + (int)reversed);
                value += unpacked + asFloat + (float)(asUint + (uint)asInt);
                value += (float)CorpusFactorial(clamp(a, 0, 6));
                value += (float)CorpusRotateLeft(u, uv2.x);
                value += isPositive ? 1.0 : 0.0;
                value += (float)(clampInt + maxInt + minInt);

                return float4(frac(value * 0.01).xxx, 1.0);
            }
            ENDCG
        }
    }

    FallBack "Diffuse"
}
