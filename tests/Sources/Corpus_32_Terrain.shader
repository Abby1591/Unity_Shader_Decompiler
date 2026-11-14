Shader "Corpus/32 Terrain"
{
    Properties
    {
        _Control ("Splat Control", 2D) = "white" {}
        _Splat0 ("Splat 0", 2D) = "white" {}
        _Splat1 ("Splat 1", 2D) = "white" {}
        _Splat2 ("Splat 2", 2D) = "white" {}
        _Splat3 ("Splat 3", 2D) = "white" {}
        _Normal0 ("Normal 0", 2D) = "bump" {}
        _Normal1 ("Normal 1", 2D) = "bump" {}
        _Normal2 ("Normal 2", 2D) = "bump" {}
        _Normal3 ("Normal 3", 2D) = "bump" {}
        _Metallic ("Metallic", Range(0, 1)) = 0
        _Smoothness ("Smoothness", Range(0, 1)) = 0.2
        _HeightBlend ("Height Blend", Range(0, 1)) = 0.5
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" "TerrainCompatible" = "True" }

        Pass
        {
            Name "TERRAIN"
            Cull Back
            ZWrite On

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog
            #pragma target 4.0
            #pragma only_renderers d3d11
            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            sampler2D _Control;
            float4 _Control_ST;
            sampler2D _Splat0;
            sampler2D _Splat1;
            sampler2D _Splat2;
            sampler2D _Splat3;
            sampler2D _Normal0;
            sampler2D _Normal1;
            sampler2D _Normal2;
            sampler2D _Normal3;
            float4 _Splat0_ST;
            float4 _Splat1_ST;
            float4 _Splat2_ST;
            float4 _Splat3_ST;
            float _Metallic;
            float _Smoothness;
            float _HeightBlend;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 controlUV : TEXCOORD0;
                float2 splatUV0 : TEXCOORD1;
                float2 splatUV1 : TEXCOORD2;
                float2 splatUV2 : TEXCOORD3;
                float2 splatUV3 : TEXCOORD4;
                float3 normal : TEXCOORD5;
                float3 worldPos : TEXCOORD6;
                UNITY_FOG_COORDS(7)
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.controlUV = TRANSFORM_TEX(v.uv, _Control);
                o.splatUV0 = TRANSFORM_TEX(v.uv, _Splat0);
                o.splatUV1 = TRANSFORM_TEX(v.uv, _Splat1);
                o.splatUV2 = TRANSFORM_TEX(v.uv, _Splat2);
                o.splatUV3 = TRANSFORM_TEX(v.uv, _Splat3);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                UNITY_TRANSFER_FOG(o, o.pos);
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float4 control = tex2D(_Control, i.controlUV);
                float4 splat0 = tex2D(_Splat0, i.splatUV0);
                float4 splat1 = tex2D(_Splat1, i.splatUV1);
                float4 splat2 = tex2D(_Splat2, i.splatUV2);
                float4 splat3 = tex2D(_Splat3, i.splatUV3);

                float4 weights = control;
                weights *= weights;
                weights *= weights;
                weights /= max(dot(weights, 1.0), 1e-5);

                float3 albedo = splat0.rgb * weights.r + splat1.rgb * weights.g + splat2.rgb * weights.b + splat3.rgb * weights.a;
                float3 normal0 = UnpackNormal(tex2D(_Normal0, i.splatUV0));
                float3 normal1 = UnpackNormal(tex2D(_Normal1, i.splatUV1));
                float3 normal2 = UnpackNormal(tex2D(_Normal2, i.splatUV2));
                float3 normal3 = UnpackNormal(tex2D(_Normal3, i.splatUV3));
                float3 normal = normalize(normal0 * weights.r + normal1 * weights.g + normal2 * weights.b + normal3 * weights.a + float3(0, 0, _HeightBlend));

                float3 lightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                float3 worldNormal = normalize(i.normal + normal * 0.5);
                float ndotl = saturate(dot(worldNormal, lightDir));
                float3 color = albedo * (ShadeSH9(float4(worldNormal, 1.0)) + _LightColor0.rgb * ndotl);
                color *= 1.0 - _Metallic * 0.5;
                color += _Smoothness * 0.05;

                UNITY_APPLY_FOG(i.fogCoord, color);
                return float4(color, 1.0);
            }
            ENDCG
        }
    }

    FallBack "Diffuse"
}
