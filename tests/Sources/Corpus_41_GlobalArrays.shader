Shader "Corpus/41 Global Arrays"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Texture", 2D) = "white" {}
        _ArrayCount ("Array Count", Int) = 4
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }

        Pass
        {
            Name "ARRAYS"
            Cull Off
            ZWrite On

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 5.0
            #pragma only_renderers d3d11
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            int _ArrayCount;

            float4 _Points[16];
            float4x4 _Matrices[8];
            float4 _Colors[4];
            half _Scalars[8];
            Texture2DArray _ArrayTex;
            SamplerState sampler_ArrayTex;
            StructuredBuffer<float4> _Structured;
            ByteAddressBuffer _RawBuffer;

            cbuffer CorpusConstantBuffer : register(b1)
            {
                float4 _CBColor : packoffset(c0);
                float4x4 _CBMatrix : packoffset(c1);
                float _CBFloat : packoffset(c5);
                int _CBInt : packoffset(c5.y);
                float2 _CBVector : packoffset(c5.z);
            };

            static const float3 kCorpusStaticColor = float3(0.25, 0.5, 0.75);
            static const int kCorpusCount = 6;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float3 normal : TEXCOORD2;
            };

            v2f vert(appdata v)
            {
                v2f o;
                float4 local = v.vertex;
                [unroll]
                for (int i = 0; i < 4; i++)
                    local.xyz += _Points[i].xyz * 0.001;

                local = mul(_CBMatrix, local);
                o.pos = UnityObjectToClipPos(local);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float4 tex = tex2D(_MainTex, i.uv);
                float4 arraySample = _ArrayTex.Sample(sampler_ArrayTex, float3(i.uv, 0.0));
                float4 structured = _Structured[0];
                uint raw0 = _RawBuffer.Load(0);

                float4 value = _CBColor + _CBMatrix[0] + _CBFloat + _CBInt + _CBVector.xyxy;
                value += _Colors[0] + _Colors[1] + _Colors[2] + _Colors[3];
                value += _Points[0] + _Points[1] + _Points[2] + _Points[3];
                value += _Matrices[0][0] + _Matrices[1][1] + _Matrices[2][2];
                value += structured + asfloat(raw0);
                value += arraySample + tex;
                value += _Scalars[0] + _Scalars[1] + _Scalars[2];
                value.rgb += kCorpusStaticColor * (float)kCorpusCount;
                value *= _Color;
                value.rgb += _Scalars[clamp(_ArrayCount, 0, 7)] * 0.1;
                return value;
            }
            ENDCG
        }
    }

    FallBack "Diffuse"
}
