Shader "Corpus/19 Hull Domain"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Texture", 2D) = "white" {}
        _Tess ("Tessellation", Range(1, 32)) = 4
        _Displacement ("Displacement", Range(0, 1)) = 0.1
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }

        Pass
        {
            Name "TESSELLATION"
            Cull Back
            ZWrite On

            CGPROGRAM
            #pragma vertex vert
            #pragma hull hull
            #pragma domain domain
            #pragma fragment frag
            #pragma target 5.0
            #pragma only_renderers d3d11
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float _Tess;
            float _Displacement;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2h
            {
                float4 pos : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct h2d
            {
                float4 pos : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct d2f
            {
                float4 pos : SV_POSITION;
                float3 normal : TEXCOORD0;
                float2 uv : TEXCOORD1;
            };

            struct hs_const
            {
                float edges[3] : SV_TessFactor;
                float inside : SV_InsideTessFactor;
            };

            v2h vert(appdata v)
            {
                v2h o;
                o.pos = v.vertex;
                o.normal = v.normal;
                o.uv = v.uv;
                return o;
            }

            hs_const hull_const(InputPatch<v2h, 3> patch, uint patchID : SV_PrimitiveID)
            {
                hs_const o;
                o.edges[0] = _Tess;
                o.edges[1] = _Tess;
                o.edges[2] = _Tess;
                o.inside = _Tess;
                return o;
            }

            [domain("tri")]
            [partitioning("fractional_odd")]
            [outputtopology("triangle_cw")]
            [outputcontrolpoints(3)]
            [patchconstantfunc("hull_const")]
            h2d hull(InputPatch<v2h, 3> patch, uint i : SV_OutputControlPointID)
            {
                h2d o;
                o.pos = patch[i].pos;
                o.normal = patch[i].normal;
                o.uv = patch[i].uv;
                return o;
            }

            [domain("tri")]
            d2f domain(hs_const CONST, float3 bary : SV_DomainLocation, const OutputPatch<h2d, 3> patch)
            {
                d2f o;
                float3 pos = patch[0].pos.xyz * bary.x + patch[1].pos.xyz * bary.y + patch[2].pos.xyz * bary.z;
                float3 normal = normalize(patch[0].normal * bary.x + patch[1].normal * bary.y + patch[2].normal * bary.z);
                pos += normal * sin(pos.x * 8.0 + _Time.y) * _Displacement;
                o.pos = UnityObjectToClipPos(float4(pos, 1.0));
                o.normal = UnityObjectToWorldNormal(normal);
                float2 uv = patch[0].uv * bary.x + patch[1].uv * bary.y + patch[2].uv * bary.z;
                o.uv = TRANSFORM_TEX(uv, _MainTex);
                return o;
            }

            float4 frag(d2f i) : SV_Target
            {
                float4 c = tex2D(_MainTex, i.uv) * _Color;
                float3 n = normalize(i.normal);
                float3 l = normalize(UnityWorldSpaceLightDir(float3(0, 0, 0)));
                c.rgb *= saturate(dot(n, l)) * 0.5 + 0.5;
                return c;
            }
            ENDCG
        }
    }

    FallBack "Diffuse"
}
