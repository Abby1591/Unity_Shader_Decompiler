Shader "Corpus/04 Vertex Fragment"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo", 2D) = "white" {}
        [Normal] _BumpMap ("Normal", 2D) = "bump" {}
        _DetailTex ("Detail", 2D) = "gray" {}
        _DetailScale ("Detail Scale", Float) = 4
        _Emission ("Emission", Color) = (0, 0, 0, 0)
        _Cutoff ("Alpha Cutoff", Range(0, 1)) = 0.5
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" "IgnoreProjector" = "False" }

        Pass
        {
            Name "FORWARD"
            Tags { "LightMode" = "ForwardBase" }
            Blend Off
            ZWrite On
            Cull Back

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma multi_compile_instancing
            #pragma target 4.0
            #pragma only_renderers d3d11

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            #include "UnityLightingCommon.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _BumpMap;
            sampler2D _DetailTex;
            float4 _DetailTex_ST;
            float _DetailScale;
            float4 _Color;
            float4 _Emission;
            float _Cutoff;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float4 color : COLOR;
                float2 uv : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float2 uv2 : TEXCOORD2;
                float2 uv3 : TEXCOORD3;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 color : COLOR;
                float2 uv : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float2 detailUV : TEXCOORD2;
                float3 normal : TEXCOORD3;
                float4 tangent : TEXCOORD4;
                float3 worldPos : TEXCOORD5;
                float4 screenPos : TEXCOORD6;
                UNITY_FOG_COORDS(7)
                UNITY_LIGHTING_COORDS(8, 9)
                UNITY_VERTEX_OUTPUT_STEREO
            };

            v2f vert(appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                o.pos = UnityObjectToClipPos(v.vertex);
                o.color = v.color;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv1 = v.uv1;
                o.detailUV = TRANSFORM_TEX(v.uv, _DetailTex) * _DetailScale;
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.tangent = float4(UnityObjectToWorldDir(v.tangent.xyz), v.tangent.w);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.screenPos = ComputeScreenPos(o.pos);
                UNITY_TRANSFER_FOG(o, o.pos);
                UNITY_TRANSFER_LIGHTING(o, v.uv1);
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float4 albedo = tex2D(_MainTex, i.uv) * _Color * i.color;
                float4 detail = tex2D(_DetailTex, i.detailUV);
                albedo.rgb *= lerp(1.0, detail.rgb * 2.0, 0.25);
                clip(albedo.a - _Cutoff);

                float3 normal = UnpackNormal(tex2D(_BumpMap, i.uv));
                float3 lightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                float3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                float3 halfDir = normalize(lightDir + viewDir);

                float ndotl = saturate(dot(normal, lightDir));
                float specular = pow(saturate(dot(normal, halfDir)), 32.0);
                UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);

                float3 ambient = ShadeSH9(float4(normal, 1.0));
                float3 color = albedo.rgb * (ambient + _LightColor0.rgb * ndotl * atten);
                color += _LightColor0.rgb * specular * atten * 0.25;
                color += _Emission.rgb;

                UNITY_APPLY_FOG(i.fogCoord, color);
                return float4(color, albedo.a);
            }
            ENDCG
        }
    }

    Fallback "Diffuse"
}
