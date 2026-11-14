Shader "Corpus/43 Lighting Globals"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Texture", 2D) = "white" {}
        _Smoothness ("Smoothness", Range(0, 1)) = 0.5
        _Specular ("Specular", Range(0, 1)) = 0.5
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }

        Pass
        {
            Name "LIGHTING_GLOBALS"
            Tags { "LightMode" = "ForwardBase" }
            Cull Back
            ZWrite On

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
            float4 _Color;
            float _Smoothness;
            float _Specular;

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
                float3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                float3 lightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                float3 halfDir = normalize(lightDir + viewDir);

                UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);

                float3 ambient = unity_AmbientSky.rgb * 0.5 + unity_AmbientEquator.rgb * 0.25 + unity_AmbientGround.rgb * 0.25;
                ambient += ShadeSH9(float4(normal, 1.0));

                float3 vertexLights = Shade4PointLights(
                    unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
                    unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
                    unity_4LightAtten0, i.worldPos, normal);

                float ndotl = saturate(dot(normal, lightDir));
                float spec = pow(saturate(dot(normal, halfDir)), lerp(8.0, 128.0, _Smoothness)) * _Specular;

                float3 reflectDir = reflect(-viewDir, normal);
                float4 probe0 = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, reflectDir);
                float3 probeColor = DecodeHDR(probe0, unity_SpecCube0_HDR);
                float3 probeDir = reflectDir;
                float3 probePosition = unity_SpecCube0_ProbePosition.xyz;
                float3 boxMax = unity_SpecCube0_BoxMax.xyz;
                float3 boxMin = unity_SpecCube0_BoxMin.xyz;
                float3 probeExtra = 0.0;
                #if UNITY_LIGHT_PROBE_PROXY_VOLUME
                probeExtra = unity_ProbeVolumeParams.xyz + unity_ProbeVolumeMin + unity_ProbeVolumeSizeInv + unity_ProbeVolumeWorldToObject[0].xyz;
                #endif

                float3 color = albedo.rgb * (ambient + vertexLights + _LightColor0.rgb * ndotl * atten);
                color += _LightColor0.rgb * spec * atten;
                color += probeColor * _Smoothness * 0.2;
                color += (probeDir + probePosition + boxMax + boxMin + probeExtra) * 0.001;

                #if defined(FOG_LINEAR) || defined(FOG_EXP) || defined(FOG_EXP2)
                float fogFactor = unity_FogParams.x * i.fogCoord + unity_FogParams.y;
                color = lerp(color, unity_FogColor.rgb, saturate(fogFactor));
                #endif
                UNITY_APPLY_FOG(i.fogCoord, color);
                return float4(color, albedo.a);
            }
            ENDCG
        }
    }

    FallBack "Diffuse"
}
