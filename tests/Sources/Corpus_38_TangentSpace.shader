Shader "Corpus/38 Tangent Space"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo", 2D) = "white" {}
        _BumpMap ("Normal", 2D) = "bump" {}
        _BumpScale ("Normal Scale", Float) = 1
        _ParallaxMap ("Height", 2D) = "black" {}
        _Parallax ("Parallax", Range(0, 0.1)) = 0.02
        _DetailMask ("Detail Mask", 2D) = "white" {}
        _DetailAlbedo ("Detail Albedo", 2D) = "gray" {}
        _DetailNormal ("Detail Normal", 2D) = "bump" {}
        _DetailScale ("Detail Scale", Float) = 4
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }

        Pass
        {
            Name "TANGENT_SPACE"
            Cull Back
            ZWrite On

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 4.0
            #pragma only_renderers d3d11
            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _BumpMap;
            float4 _BumpMap_ST;
            sampler2D _ParallaxMap;
            float4 _ParallaxMap_ST;
            sampler2D _DetailMask;
            sampler2D _DetailAlbedo;
            sampler2D _DetailNormal;
            float4 _DetailAlbedo_ST;
            float4 _DetailNormal_ST;
            float4 _Color;
            float _BumpScale;
            float _Parallax;
            float _DetailScale;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 bumpUV : TEXCOORD1;
                float2 parallaxUV : TEXCOORD2;
                float3 tangent : TEXCOORD3;
                float3 bitangent : TEXCOORD4;
                float3 normal : TEXCOORD5;
                float3 worldPos : TEXCOORD6;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.bumpUV = TRANSFORM_TEX(v.uv, _BumpMap);
                o.parallaxUV = TRANSFORM_TEX(v.uv, _ParallaxMap);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.tangent = UnityObjectToWorldDir(v.tangent.xyz);
                o.bitangent = cross(o.normal, o.tangent) * v.tangent.w * unity_WorldTransformParams.w;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float3x3 TBN = float3x3(normalize(i.tangent), normalize(i.bitangent), normalize(i.normal));
                float3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                float3 viewTangent = float3(dot(viewDir, TBN[0]), dot(viewDir, TBN[1]), dot(viewDir, TBN[2]));

                float height = tex2D(_ParallaxMap, i.parallaxUV).r;
                float2 parallaxOffset = (height - 0.5) * _Parallax * viewTangent.xy;
                float2 uv = i.uv + parallaxOffset;
                float2 bumpUV = i.bumpUV + parallaxOffset;

                float4 albedo = tex2D(_MainTex, uv) * _Color;
                float3 normalTangent = UnpackNormalWithScale(tex2D(_BumpMap, bumpUV), _BumpScale);

                float detailMask = tex2D(_DetailMask, uv).r;
                float3 detailAlbedo = tex2D(_DetailAlbedo, uv * _DetailScale).rgb * 2.0 - 1.0;
                float3 detailNormal = UnpackNormalWithScale(tex2D(_DetailNormal, uv * _DetailScale), _BumpScale);
                albedo.rgb *= lerp(1.0, detailAlbedo, detailMask);
                normalTangent = normalize(normalTangent + detailNormal * detailMask);

                float3 normalWorld = normalize(mul(normalTangent, TBN));
                float3 lightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                float ndotl = saturate(dot(normalWorld, lightDir));
                float3 color = albedo.rgb * (ShadeSH9(float4(normalWorld, 1.0)) + _LightColor0.rgb * ndotl);
                return float4(color, albedo.a);
            }
            ENDCG
        }
    }

    FallBack "Bumped Diffuse"
}
