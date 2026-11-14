Shader "Corpus/18 Geometry Shader"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Texture", 2D) = "white" {}
        _Extrude ("Extrude", Range(0, 1)) = 0.1
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }

        Pass
        {
            Name "GEOMETRY"
            Cull Off
            ZWrite On

            CGPROGRAM
            #pragma vertex vert
            #pragma geometry geom
            #pragma fragment frag
            #pragma target 5.0
            #pragma only_renderers d3d11
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float _Extrude;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            struct v2g
            {
                float4 pos : SV_POSITION;
                float3 normal : TEXCOORD0;
                float2 uv : TEXCOORD1;
                float4 color : COLOR;
            };

            struct g2f
            {
                float4 pos : SV_POSITION;
                float3 normal : TEXCOORD0;
                float2 uv : TEXCOORD1;
                float4 color : COLOR;
            };

            v2g vert(appdata v)
            {
                v2g o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = v.color;
                return o;
            }

            [maxvertexcount(3)]
            void geom(triangle v2g input[3], uint primitiveID : SV_PrimitiveID, inout TriangleStream<g2f> stream)
            {
                float3 center = (input[0].pos.xyz + input[1].pos.xyz + input[2].pos.xyz) / 3.0;
                float3 normal = normalize(cross(input[1].pos.xyz - input[0].pos.xyz, input[2].pos.xyz - input[0].pos.xyz));

                [unroll]
                for (int i = 0; i < 3; i++)
                {
                    g2f o;
                    o.pos = input[i].pos;
                    o.pos.xyz += normal * _Extrude * 0.01;
                    o.normal = input[i].normal;
                    o.uv = input[i].uv;
                    o.color = input[i].color * (primitiveID % 2 == 0 ? 1.0 : 0.5);
                    stream.Append(o);
                }
                stream.RestartStrip();
                center *= 0.0;
            }

            float4 frag(g2f i) : SV_Target
            {
                float4 c = tex2D(_MainTex, i.uv) * _Color * i.color;
                c.rgb *= saturate(dot(normalize(i.normal), float3(0, 1, 0)) * 0.5 + 0.5);
                return c;
            }
            ENDCG
        }
    }

    FallBack "Diffuse"
}
