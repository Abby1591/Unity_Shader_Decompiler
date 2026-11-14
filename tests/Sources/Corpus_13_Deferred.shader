Shader "Corpus/13 Deferred"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo", 2D) = "white" {}
        _SpecColor ("Specular", Color) = (0.2, 0.2, 0.2, 1)
        _Shininess ("Smoothness", Range(0, 1)) = 0.5
        [HDR] _EmissionColor ("Emission", Color) = (0, 0, 0, 1)
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }

        Pass
        {
            Name "DEFERRED"
            Tags { "LightMode" = "Deferred" }
            ZWrite On

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 5.0
            #pragma only_renderers d3d11
            #pragma multi_compile _ UNITY_HDR_ON
            #pragma multi_compile _ _DEFERRED_USE_ORTHOGRAPHIC_PROJECTION

            #include "UnityCG.cginc"
            #include "UnityGBuffer.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Color;
            fixed4 _SpecColor;
            fixed4 _EmissionColor;
            half _Shininess;

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
            };

            struct gbuffer_out
            {
                float4 g0 : SV_Target0;
                float4 g1 : SV_Target1;
                float4 g2 : SV_Target2;
                float4 g3 : SV_Target3;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                return o;
            }

            gbuffer_out frag(v2f i)
            {
                float4 albedo = tex2D(_MainTex, i.uv) * _Color;

                UnityStandardData data;
                data.diffuseColor = albedo.rgb;
                data.occlusion = 1.0;
                data.specularColor = _SpecColor.rgb;
                data.smoothness = _Shininess;
                data.normalWorld = normalize(i.normal);

                gbuffer_out o;
                UnityStandardDataToGbuffer(data, o.g0, o.g1, o.g2);
                o.g3 = float4(_EmissionColor.rgb * albedo.rgb, 1.0);
                return o;
            }
            ENDCG
        }

        Pass
        {
            Name "FORWARD"
            Tags { "LightMode" = "ForwardBase" }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma target 4.0
            #pragma only_renderers d3d11

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            #include "UnityLightingCommon.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Color;
            fixed4 _EmissionColor;

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
                UNITY_FOG_COORDS(3)
                UNITY_LIGHTING_COORDS(4, 5)
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                UNITY_TRANSFER_FOG(o, o.pos);
                TRANSFER_VERTEX_TO_FRAGMENT(o);
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float4 albedo = tex2D(_MainTex, i.uv) * _Color;
                float3 normal = normalize(i.normal);
                float3 lightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);
                float3 color = albedo.rgb * (ShadeSH9(float4(normal, 1.0)) + _LightColor0.rgb * saturate(dot(normal, lightDir)) * atten);
                color += _EmissionColor.rgb * albedo.rgb;
                UNITY_APPLY_FOG(i.fogCoord, color);
                return float4(color, albedo.a);
            }
            ENDCG
        }
    }

    FallBack "Standard"
}
