Shader "Corpus/47 Lightmap"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo", 2D) = "white" {}
        _LightmapTex ("Lightmap", 2D) = "white" {}
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }

        Pass
        {
            Name "LIGHTMAP"
            Tags { "LightMode" = "ForwardBase" }
            Cull Back
            ZWrite On

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
            #pragma multi_compile DIRLIGHTMAP_OFF DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
            #pragma multi_compile DYNAMICLIGHTMAP_OFF DYNAMICLIGHTMAP_ON
            #pragma multi_compile LIGHTPROBE_SH
            #pragma multi_compile_fog
            #pragma target 3.0
            #pragma only_renderers d3d11
            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float2 uv2 : TEXCOORD2;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 lightmapUV : TEXCOORD1;
                float2 dynamicLightmapUV : TEXCOORD2;
                float3 normal : TEXCOORD3;
                float3 worldPos : TEXCOORD4;
                UNITY_FOG_COORDS(5)
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.lightmapUV = v.uv1 * unity_LightmapST.xy + unity_LightmapST.zw;
                o.dynamicLightmapUV = v.uv2 * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                UNITY_TRANSFER_FOG(o, o.pos);
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float4 albedo = tex2D(_MainTex, i.uv) * _Color;
                float3 normal = normalize(i.normal);
                float3 lightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));

                float3 color = albedo.rgb * (ShadeSH9(float4(normal, 1.0)) + _LightColor0.rgb * saturate(dot(normal, lightDir)));

                #ifdef LIGHTMAP_ON
                half3 baked = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.lightmapUV));
                color += albedo.rgb * baked;
                #endif

                #ifdef DYNAMICLIGHTMAP_ON
                half3 dynamicBaked = DecodeRealtimeLightmap(UNITY_SAMPLE_TEX2D(unity_DynamicLightmap, i.dynamicLightmapUV));
                color += albedo.rgb * dynamicBaked;
                #endif

                #ifdef DIRLIGHTMAP_COMBINED
                half3 direction = UNITY_SAMPLE_TEX2D(unity_LightmapInd, i.lightmapUV).rgb * 2.0 - 1.0;
                color += albedo.rgb * saturate(dot(normal, direction)) * 0.5;
                #endif

                UNITY_APPLY_FOG(i.fogCoord, color);
                return float4(color, albedo.a);
            }
            ENDCG
        }
    }

    FallBack "Diffuse"
}
