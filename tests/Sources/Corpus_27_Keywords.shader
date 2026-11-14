Shader "Corpus/27 Keywords"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Texture", 2D) = "white" {}
        [Toggle(_MODE_A)] _ModeA ("Mode A", Float) = 0
        [Toggle(_MODE_B)] _ModeB ("Mode B", Float) = 0
        [Toggle(_MODE_C)] _ModeC ("Mode C", Float) = 0
        [Toggle(_LOCAL_A)] _LocalA ("Local A", Float) = 0
        [Toggle(_FEATURE_A)] _FeatureA ("Feature A", Float) = 0
        [Toggle(_FEATURE_B)] _FeatureB ("Feature B", Float) = 0
        [Toggle(_LOCAL_FEATURE)] _LocalFeature ("Local Feature", Float) = 0
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }

        Pass
        {
            Name "KEYWORD_VARIANTS"
            Tags { "LightMode" = "ForwardBase" }
            Cull Back
            ZWrite On

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile _ _MODE_A _MODE_B _MODE_C
            #pragma multi_compile_local _ _LOCAL_A _LOCAL_B
            #pragma shader_feature _ _FEATURE_A _FEATURE_B
            #pragma shader_feature_local _ _LOCAL_FEATURE
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma multi_compile_instancing
            #pragma target 4.0
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
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
                UNITY_FOG_COORDS(3)
                UNITY_VERTEX_OUTPUT_STEREO
            };

            v2f vert(appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                UNITY_TRANSFER_FOG(o, o.pos);
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float4 c = tex2D(_MainTex, i.uv) * _Color;
                float3 n = normalize(i.normal);
                float3 l = normalize(UnityWorldSpaceLightDir(i.worldPos));

                float3 color = c.rgb;
                color *= 0.5 + 0.5 * saturate(dot(n, l));

                #if defined(_MODE_A)
                    color = lerp(color, color * float3(1.0, 0.5, 0.5), 0.5);
                #elif defined(_MODE_B)
                    color = lerp(color, color * float3(0.5, 1.0, 0.5), 0.5);
                #elif defined(_MODE_C)
                    color = lerp(color, color * float3(0.5, 0.5, 1.0), 0.5);
                #endif

                #ifdef _LOCAL_A
                    color += 0.05;
                #endif
                #ifdef _LOCAL_B
                    color -= 0.05;
                #endif
                #ifdef _FEATURE_A
                    color += n * 0.02;
                #endif
                #ifdef _FEATURE_B
                    color += float3(0.1, 0.0, 0.0);
                #endif
                #ifdef _LOCAL_FEATURE
                    color *= 1.1;
                #endif

                color += _LightColor0.rgb * 0.1;
                UNITY_APPLY_FOG(i.fogCoord, color);
                return float4(color, c.a);
            }
            ENDCG
        }
    }

    FallBack "Diffuse"
}
