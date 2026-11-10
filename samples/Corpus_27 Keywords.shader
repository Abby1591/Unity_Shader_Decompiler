Shader "Corpus/27 Keywords"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "" {}
        [Toggle(_MODE_A)]
        _ModeA ("Mode A", Float) = 0
        [Toggle(_MODE_B)]
        _ModeB ("Mode B", Float) = 0
        [Toggle(_MODE_C)]
        _ModeC ("Mode C", Float) = 0
        [Toggle(_LOCAL_A)]
        _LocalA ("Local A", Float) = 0
        [Toggle(_FEATURE_A)]
        _FeatureA ("Feature A", Float) = 0
        [Toggle(_FEATURE_B)]
        _FeatureB ("Feature B", Float) = 0
        [Toggle(_LOCAL_FEATURE)]
        _LocalFeature ("Local Feature", Float) = 0
    }
    SubShader
    {
        Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
        LOD 0
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program1Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program1Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program771Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program771Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program1Output vert(program1Input i)
            {
                program1Output o = (program1Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program771Output frag(program771Input i)
            {
                program771Output o = (program771Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r0_xyzw_2 = (_LightColor0.xxyz * float4(0, 0.1, 0.1, 0.1));
                float r0_y_2 = r0_xyzw_2.y;
                float r0_z_2 = r0_xyzw_2.z;
                float r0_w_3 = r0_xyzw_2.w;
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                o.sv_Target0.xyz = (mad(r1_xyzw_3.xyzx, (mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx, float4(r0_y_2, r0_z_2, r0_w_3, r0_y_2))).xyz;
                o.sv_Target0.w = r1_xyzw_3.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program144Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program144Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1142Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1142Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program144Output vert(program144Input i)
            {
                program144Output o = (program144Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program1142Output frag(program1142Input i)
            {
                program1142Output o = (program1142Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 0.75, 1, 0), float4(-0.05, -0.05, -0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7), float4(1.1, 1.1, 1.1, 0), ((_LightColor0.xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float4 r0_xyzw_9 = (float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8) + -cb3_values[0].xyzx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_5 = r0_xyzw_9.y;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_9, r0_y_5, r0_z_5, r0_x_9), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program143Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program143Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1141Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1141Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program143Output vert(program143Input i)
            {
                program143Output o = (program143Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program1141Output frag(program1141Input i)
            {
                program1141Output o = (program1141Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 0.75, 1, 0), float4(0.05, -0.05, -0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float4 r0_xyzw_9 = (float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8) + -cb3_values[0].xyzx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_5 = r0_xyzw_9.y;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_9, r0_y_5, r0_z_5, r0_x_9), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program142Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program142Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1140Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1140Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program142Output vert(program142Input i)
            {
                program142Output o = (program142Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program1140Output frag(program1140Input i)
            {
                program1140Output o = (program1140Output)0;
                float4 r0_xyzw_3 = ((rsqrt(dot(cb2_values[0].xyzx, cb2_values[0].xyzx))).xxxx * cb2_values[0].xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r2_xyzw_2 = (r2_xyzw_1 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(unitWorldNormal_xyz_1.xyzx, float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3))), 0.5, 0.5)).xxxx * r2_xyzw_2.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r2_xyzw_2.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 0.75, 1, 0), float4(-0.05, -0.05, -0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(unitWorldNormal_xyz_1.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float4 r0_xyzw_9 = mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_5 = r0_xyzw_9.y;
                float r0_z_5 = r0_xyzw_9.z;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_y_5, r0_z_5, r0_x_9) + -cb3_values[0].xyzx);
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_6 = r0_xyzw_10.y;
                float r0_z_6 = r0_xyzw_10.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_10, r0_y_6, r0_z_6, r0_x_10), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program141Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program141Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1139Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1139Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program141Output vert(program141Input i)
            {
                program141Output o = (program141Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program1139Output frag(program1139Input i)
            {
                program1139Output o = (program1139Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 0.75, 1, 0), float4(-0.05, -0.05, -0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float4 r0_xyzw_9 = (float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8) + -cb3_values[0].xyzx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_5 = r0_xyzw_9.y;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_9, r0_y_5, r0_z_5, r0_x_9), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program140Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program140Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1126Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1126Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program140Output vert(program140Input i)
            {
                program140Output o = (program140Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program1126Output frag(program1126Input i)
            {
                program1126Output o = (program1126Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 0.75, 1, 0), float4(0.05, 0.05, 0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7), float4(1.1, 1.1, 1.1, 0), ((_LightColor0.xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float4 r0_xyzw_9 = (float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8) + -cb3_values[0].xyzx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_5 = r0_xyzw_9.y;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_9, r0_y_5, r0_z_5, r0_x_9), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program139Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program139Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1125Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1125Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program139Output vert(program139Input i)
            {
                program139Output o = (program139Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program1125Output frag(program1125Input i)
            {
                program1125Output o = (program1125Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 0.75, 1, 0), float4(0.15, 0.05, 0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float4 r0_xyzw_9 = (float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8) + -cb3_values[0].xyzx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_5 = r0_xyzw_9.y;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_9, r0_y_5, r0_z_5, r0_x_9), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program138Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program138Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1124Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1124Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program138Output vert(program138Input i)
            {
                program138Output o = (program138Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program1124Output frag(program1124Input i)
            {
                program1124Output o = (program1124Output)0;
                float4 r0_xyzw_3 = ((rsqrt(dot(cb2_values[0].xyzx, cb2_values[0].xyzx))).xxxx * cb2_values[0].xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r2_xyzw_2 = (r2_xyzw_1 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(unitWorldNormal_xyz_1.xyzx, float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3))), 0.5, 0.5)).xxxx * r2_xyzw_2.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r2_xyzw_2.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 0.75, 1, 0), float4(0.05, 0.05, 0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(unitWorldNormal_xyz_1.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float4 r0_xyzw_9 = mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_5 = r0_xyzw_9.y;
                float r0_z_5 = r0_xyzw_9.z;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_y_5, r0_z_5, r0_x_9) + -cb3_values[0].xyzx);
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_6 = r0_xyzw_10.y;
                float r0_z_6 = r0_xyzw_10.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_10, r0_y_6, r0_z_6, r0_x_10), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program137Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program137Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1123Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1123Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program137Output vert(program137Input i)
            {
                program137Output o = (program137Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program1123Output frag(program1123Input i)
            {
                program1123Output o = (program1123Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 0.75, 1, 0), float4(0.05, 0.05, 0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float4 r0_xyzw_9 = (float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8) + -cb3_values[0].xyzx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_5 = r0_xyzw_9.y;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_9, r0_y_5, r0_z_5, r0_x_9), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program136Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program136Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1110Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1110Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program136Output vert(program136Input i)
            {
                program136Output o = (program136Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program1110Output frag(program1110Input i)
            {
                program1110Output o = (program1110Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.82500005, 0.82500005, 1.1, 0), ((_LightColor0.xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = (float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7) + -cb3_values[0].xyzx);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program135Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program135Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1109Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1109Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program135Output vert(program135Input i)
            {
                program135Output o = (program135Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program1109Output frag(program1109Input i)
            {
                program1109Output o = (program1109Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 0.75, 1, 0), float4(0.1, 0, 0, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float4 r0_xyzw_9 = (float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8) + -cb3_values[0].xyzx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_5 = r0_xyzw_9.y;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_9, r0_y_5, r0_z_5, r0_x_9), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program134Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program134Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1108Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1108Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program134Output vert(program134Input i)
            {
                program134Output o = (program134Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program1108Output frag(program1108Input i)
            {
                program1108Output o = (program1108Output)0;
                float4 r0_xyzw_3 = ((rsqrt(dot(cb2_values[0].xyzx, cb2_values[0].xyzx))).xxxx * cb2_values[0].xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float4 r0_xyzw_2 = (unitWorldNormal_xyz_1.xxyz * float4(0, 0.02, 0.02, 0.02));
                float r0_y_2 = r0_xyzw_2.y;
                float r0_z_2 = r0_xyzw_2.z;
                float r0_w_3 = r0_xyzw_2.w;
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_6 = mad((((mad(saturate(dot(unitWorldNormal_xyz_1.xyzx, float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3))), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx)).xyzx, float4(0.75, 0.75, 1, 0), float4(r0_y_2, r0_z_2, r0_w_3, r0_y_2));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_3 = r0_xyzw_6.y;
                float r0_z_3 = r0_xyzw_6.z;
                float4 r0_xyzw_7 = mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_6, r0_y_3, r0_z_3, r0_x_6));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_4 = r0_xyzw_7.y;
                float r0_z_4 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = (float4(r0_x_7, r0_y_4, r0_z_4, r0_x_7) + -cb3_values[0].xyzx);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_5 = r0_xyzw_8.y;
                float r0_z_5 = r0_xyzw_8.z;
                float r0_w_4 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_5 = (-r0_w_4 + 1);
                float r0_w_6 = (r0_w_5 * cb1_values[5].z);
                float r0_w_7 = max(r0_w_6, 0);
                float r0_w_8 = saturate(mad(r0_w_7, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_8.xxxx, float4(r0_x_8, r0_y_5, r0_z_5, r0_x_8), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program133Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program133Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1107Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1107Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program133Output vert(program133Input i)
            {
                program133Output o = (program133Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program1107Output frag(program1107Input i)
            {
                program1107Output o = (program1107Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 0.75, 1, 0), ((_LightColor0.xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = (float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7) + -cb3_values[0].xyzx);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program132Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program132Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1046Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1046Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program132Output vert(program132Input i)
            {
                program132Output o = (program132Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program1046Output frag(program1046Input i)
            {
                program1046Output o = (program1046Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 1, 0.75, 0), float4(-0.05, -0.05, -0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7), float4(1.1, 1.1, 1.1, 0), ((_LightColor0.xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float4 r0_xyzw_9 = (float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8) + -cb3_values[0].xyzx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_5 = r0_xyzw_9.y;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_9, r0_y_5, r0_z_5, r0_x_9), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program131Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program131Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1045Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1045Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program131Output vert(program131Input i)
            {
                program131Output o = (program131Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program1045Output frag(program1045Input i)
            {
                program1045Output o = (program1045Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 1, 0.75, 0), float4(0.05, -0.05, -0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float4 r0_xyzw_9 = (float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8) + -cb3_values[0].xyzx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_5 = r0_xyzw_9.y;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_9, r0_y_5, r0_z_5, r0_x_9), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program130Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program130Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1044Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1044Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program130Output vert(program130Input i)
            {
                program130Output o = (program130Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program1044Output frag(program1044Input i)
            {
                program1044Output o = (program1044Output)0;
                float4 r0_xyzw_3 = ((rsqrt(dot(cb2_values[0].xyzx, cb2_values[0].xyzx))).xxxx * cb2_values[0].xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r2_xyzw_2 = (r2_xyzw_1 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(unitWorldNormal_xyz_1.xyzx, float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3))), 0.5, 0.5)).xxxx * r2_xyzw_2.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r2_xyzw_2.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 1, 0.75, 0), float4(-0.05, -0.05, -0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(unitWorldNormal_xyz_1.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float4 r0_xyzw_9 = mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_5 = r0_xyzw_9.y;
                float r0_z_5 = r0_xyzw_9.z;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_y_5, r0_z_5, r0_x_9) + -cb3_values[0].xyzx);
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_6 = r0_xyzw_10.y;
                float r0_z_6 = r0_xyzw_10.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_10, r0_y_6, r0_z_6, r0_x_10), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program129Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program129Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1043Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1043Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program129Output vert(program129Input i)
            {
                program129Output o = (program129Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program1043Output frag(program1043Input i)
            {
                program1043Output o = (program1043Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 1, 0.75, 0), float4(-0.05, -0.05, -0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float4 r0_xyzw_9 = (float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8) + -cb3_values[0].xyzx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_5 = r0_xyzw_9.y;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_9, r0_y_5, r0_z_5, r0_x_9), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program128Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program128Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1030Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1030Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program128Output vert(program128Input i)
            {
                program128Output o = (program128Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program1030Output frag(program1030Input i)
            {
                program1030Output o = (program1030Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 1, 0.75, 0), float4(0.05, 0.05, 0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7), float4(1.1, 1.1, 1.1, 0), ((_LightColor0.xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float4 r0_xyzw_9 = (float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8) + -cb3_values[0].xyzx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_5 = r0_xyzw_9.y;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_9, r0_y_5, r0_z_5, r0_x_9), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program127Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program127Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1029Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1029Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program127Output vert(program127Input i)
            {
                program127Output o = (program127Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program1029Output frag(program1029Input i)
            {
                program1029Output o = (program1029Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 1, 0.75, 0), float4(0.15, 0.05, 0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float4 r0_xyzw_9 = (float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8) + -cb3_values[0].xyzx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_5 = r0_xyzw_9.y;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_9, r0_y_5, r0_z_5, r0_x_9), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program126Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program126Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1028Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1028Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program126Output vert(program126Input i)
            {
                program126Output o = (program126Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program1028Output frag(program1028Input i)
            {
                program1028Output o = (program1028Output)0;
                float4 r0_xyzw_3 = ((rsqrt(dot(cb2_values[0].xyzx, cb2_values[0].xyzx))).xxxx * cb2_values[0].xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r2_xyzw_2 = (r2_xyzw_1 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(unitWorldNormal_xyz_1.xyzx, float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3))), 0.5, 0.5)).xxxx * r2_xyzw_2.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r2_xyzw_2.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 1, 0.75, 0), float4(0.05, 0.05, 0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(unitWorldNormal_xyz_1.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float4 r0_xyzw_9 = mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_5 = r0_xyzw_9.y;
                float r0_z_5 = r0_xyzw_9.z;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_y_5, r0_z_5, r0_x_9) + -cb3_values[0].xyzx);
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_6 = r0_xyzw_10.y;
                float r0_z_6 = r0_xyzw_10.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_10, r0_y_6, r0_z_6, r0_x_10), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program125Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program125Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1027Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1027Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program125Output vert(program125Input i)
            {
                program125Output o = (program125Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program1027Output frag(program1027Input i)
            {
                program1027Output o = (program1027Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 1, 0.75, 0), float4(0.05, 0.05, 0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float4 r0_xyzw_9 = (float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8) + -cb3_values[0].xyzx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_5 = r0_xyzw_9.y;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_9, r0_y_5, r0_z_5, r0_x_9), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program124Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program124Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1014Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1014Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program124Output vert(program124Input i)
            {
                program124Output o = (program124Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program1014Output frag(program1014Input i)
            {
                program1014Output o = (program1014Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.82500005, 1.1, 0.82500005, 0), ((_LightColor0.xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = (float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7) + -cb3_values[0].xyzx);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program123Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program123Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1013Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1013Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program123Output vert(program123Input i)
            {
                program123Output o = (program123Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program1013Output frag(program1013Input i)
            {
                program1013Output o = (program1013Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 1, 0.75, 0), float4(0.1, 0, 0, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float4 r0_xyzw_9 = (float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8) + -cb3_values[0].xyzx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_5 = r0_xyzw_9.y;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_9, r0_y_5, r0_z_5, r0_x_9), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program122Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program122Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1012Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1012Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program122Output vert(program122Input i)
            {
                program122Output o = (program122Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program1012Output frag(program1012Input i)
            {
                program1012Output o = (program1012Output)0;
                float4 r0_xyzw_3 = ((rsqrt(dot(cb2_values[0].xyzx, cb2_values[0].xyzx))).xxxx * cb2_values[0].xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float4 r0_xyzw_2 = (unitWorldNormal_xyz_1.xxyz * float4(0, 0.02, 0.02, 0.02));
                float r0_y_2 = r0_xyzw_2.y;
                float r0_z_2 = r0_xyzw_2.z;
                float r0_w_3 = r0_xyzw_2.w;
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_6 = mad((((mad(saturate(dot(unitWorldNormal_xyz_1.xyzx, float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3))), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx)).xyzx, float4(0.75, 1, 0.75, 0), float4(r0_y_2, r0_z_2, r0_w_3, r0_y_2));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_3 = r0_xyzw_6.y;
                float r0_z_3 = r0_xyzw_6.z;
                float4 r0_xyzw_7 = mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_6, r0_y_3, r0_z_3, r0_x_6));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_4 = r0_xyzw_7.y;
                float r0_z_4 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = (float4(r0_x_7, r0_y_4, r0_z_4, r0_x_7) + -cb3_values[0].xyzx);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_5 = r0_xyzw_8.y;
                float r0_z_5 = r0_xyzw_8.z;
                float r0_w_4 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_5 = (-r0_w_4 + 1);
                float r0_w_6 = (r0_w_5 * cb1_values[5].z);
                float r0_w_7 = max(r0_w_6, 0);
                float r0_w_8 = saturate(mad(r0_w_7, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_8.xxxx, float4(r0_x_8, r0_y_5, r0_z_5, r0_x_8), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program121Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program121Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1011Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1011Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program121Output vert(program121Input i)
            {
                program121Output o = (program121Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program1011Output frag(program1011Input i)
            {
                program1011Output o = (program1011Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 1, 0.75, 0), ((_LightColor0.xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = (float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7) + -cb3_values[0].xyzx);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program120Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program120Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program950Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program950Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program120Output vert(program120Input i)
            {
                program120Output o = (program120Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program950Output frag(program950Input i)
            {
                program950Output o = (program950Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(1, 0.75, 0.75, 0), float4(-0.05, -0.05, -0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7), float4(1.1, 1.1, 1.1, 0), ((_LightColor0.xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float4 r0_xyzw_9 = (float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8) + -cb3_values[0].xyzx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_5 = r0_xyzw_9.y;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_9, r0_y_5, r0_z_5, r0_x_9), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program119Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program119Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program949Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program949Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program119Output vert(program119Input i)
            {
                program119Output o = (program119Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program949Output frag(program949Input i)
            {
                program949Output o = (program949Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(1, 0.75, 0.75, 0), float4(0.05, -0.05, -0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float4 r0_xyzw_9 = (float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8) + -cb3_values[0].xyzx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_5 = r0_xyzw_9.y;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_9, r0_y_5, r0_z_5, r0_x_9), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program118Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program118Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program948Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program948Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program118Output vert(program118Input i)
            {
                program118Output o = (program118Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program948Output frag(program948Input i)
            {
                program948Output o = (program948Output)0;
                float4 r0_xyzw_3 = ((rsqrt(dot(cb2_values[0].xyzx, cb2_values[0].xyzx))).xxxx * cb2_values[0].xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r2_xyzw_2 = (r2_xyzw_1 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(unitWorldNormal_xyz_1.xyzx, float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3))), 0.5, 0.5)).xxxx * r2_xyzw_2.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r2_xyzw_2.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(1, 0.75, 0.75, 0), float4(-0.05, -0.05, -0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(unitWorldNormal_xyz_1.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float4 r0_xyzw_9 = mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_5 = r0_xyzw_9.y;
                float r0_z_5 = r0_xyzw_9.z;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_y_5, r0_z_5, r0_x_9) + -cb3_values[0].xyzx);
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_6 = r0_xyzw_10.y;
                float r0_z_6 = r0_xyzw_10.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_10, r0_y_6, r0_z_6, r0_x_10), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program117Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program117Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program947Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program947Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program117Output vert(program117Input i)
            {
                program117Output o = (program117Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program947Output frag(program947Input i)
            {
                program947Output o = (program947Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(1, 0.75, 0.75, 0), float4(-0.05, -0.05, -0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float4 r0_xyzw_9 = (float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8) + -cb3_values[0].xyzx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_5 = r0_xyzw_9.y;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_9, r0_y_5, r0_z_5, r0_x_9), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program116Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program116Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program934Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program934Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program116Output vert(program116Input i)
            {
                program116Output o = (program116Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program934Output frag(program934Input i)
            {
                program934Output o = (program934Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(1, 0.75, 0.75, 0), float4(0.05, 0.05, 0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7), float4(1.1, 1.1, 1.1, 0), ((_LightColor0.xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float4 r0_xyzw_9 = (float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8) + -cb3_values[0].xyzx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_5 = r0_xyzw_9.y;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_9, r0_y_5, r0_z_5, r0_x_9), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program115Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program115Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program933Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program933Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program115Output vert(program115Input i)
            {
                program115Output o = (program115Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program933Output frag(program933Input i)
            {
                program933Output o = (program933Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(1, 0.75, 0.75, 0), float4(0.15, 0.05, 0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float4 r0_xyzw_9 = (float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8) + -cb3_values[0].xyzx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_5 = r0_xyzw_9.y;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_9, r0_y_5, r0_z_5, r0_x_9), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program114Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program114Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program932Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program932Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program114Output vert(program114Input i)
            {
                program114Output o = (program114Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program932Output frag(program932Input i)
            {
                program932Output o = (program932Output)0;
                float4 r0_xyzw_3 = ((rsqrt(dot(cb2_values[0].xyzx, cb2_values[0].xyzx))).xxxx * cb2_values[0].xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r2_xyzw_2 = (r2_xyzw_1 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(unitWorldNormal_xyz_1.xyzx, float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3))), 0.5, 0.5)).xxxx * r2_xyzw_2.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r2_xyzw_2.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(1, 0.75, 0.75, 0), float4(0.05, 0.05, 0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(unitWorldNormal_xyz_1.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float4 r0_xyzw_9 = mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_5 = r0_xyzw_9.y;
                float r0_z_5 = r0_xyzw_9.z;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_y_5, r0_z_5, r0_x_9) + -cb3_values[0].xyzx);
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_6 = r0_xyzw_10.y;
                float r0_z_6 = r0_xyzw_10.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_10, r0_y_6, r0_z_6, r0_x_10), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program113Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program113Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program931Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program931Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program113Output vert(program113Input i)
            {
                program113Output o = (program113Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program931Output frag(program931Input i)
            {
                program931Output o = (program931Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(1, 0.75, 0.75, 0), float4(0.05, 0.05, 0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float4 r0_xyzw_9 = (float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8) + -cb3_values[0].xyzx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_5 = r0_xyzw_9.y;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_9, r0_y_5, r0_z_5, r0_x_9), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program112Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program112Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program918Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program918Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program112Output vert(program112Input i)
            {
                program112Output o = (program112Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program918Output frag(program918Input i)
            {
                program918Output o = (program918Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(1.1, 0.82500005, 0.82500005, 0), ((_LightColor0.xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = (float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7) + -cb3_values[0].xyzx);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program111Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program111Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program917Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program917Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program111Output vert(program111Input i)
            {
                program111Output o = (program111Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program917Output frag(program917Input i)
            {
                program917Output o = (program917Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(1, 0.75, 0.75, 0), float4(0.1, 0, 0, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float4 r0_xyzw_9 = (float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8) + -cb3_values[0].xyzx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_5 = r0_xyzw_9.y;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_9, r0_y_5, r0_z_5, r0_x_9), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program110Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program110Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program916Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program916Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program110Output vert(program110Input i)
            {
                program110Output o = (program110Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program916Output frag(program916Input i)
            {
                program916Output o = (program916Output)0;
                float4 r0_xyzw_3 = ((rsqrt(dot(cb2_values[0].xyzx, cb2_values[0].xyzx))).xxxx * cb2_values[0].xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float4 r0_xyzw_2 = (unitWorldNormal_xyz_1.xxyz * float4(0, 0.02, 0.02, 0.02));
                float r0_y_2 = r0_xyzw_2.y;
                float r0_z_2 = r0_xyzw_2.z;
                float r0_w_3 = r0_xyzw_2.w;
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_6 = mad((((mad(saturate(dot(unitWorldNormal_xyz_1.xyzx, float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3))), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx)).xyzx, float4(1, 0.75, 0.75, 0), float4(r0_y_2, r0_z_2, r0_w_3, r0_y_2));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_3 = r0_xyzw_6.y;
                float r0_z_3 = r0_xyzw_6.z;
                float4 r0_xyzw_7 = mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_6, r0_y_3, r0_z_3, r0_x_6));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_4 = r0_xyzw_7.y;
                float r0_z_4 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = (float4(r0_x_7, r0_y_4, r0_z_4, r0_x_7) + -cb3_values[0].xyzx);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_5 = r0_xyzw_8.y;
                float r0_z_5 = r0_xyzw_8.z;
                float r0_w_4 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_5 = (-r0_w_4 + 1);
                float r0_w_6 = (r0_w_5 * cb1_values[5].z);
                float r0_w_7 = max(r0_w_6, 0);
                float r0_w_8 = saturate(mad(r0_w_7, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_8.xxxx, float4(r0_x_8, r0_y_5, r0_z_5, r0_x_8), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program109Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program109Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program915Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program915Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program109Output vert(program109Input i)
            {
                program109Output o = (program109Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program915Output frag(program915Input i)
            {
                program915Output o = (program915Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(1, 0.75, 0.75, 0), ((_LightColor0.xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = (float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7) + -cb3_values[0].xyzx);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program108Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program108Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program854Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program854Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program108Output vert(program108Input i)
            {
                program108Output o = (program108Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program854Output frag(program854Input i)
            {
                program854Output o = (program854Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = mad(r1_xyzw_3.xyzx, (mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx, float4(-0.05, -0.05, -0.05, 0));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(1.1, 1.1, 1.1, 0), ((_LightColor0.xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = (float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7) + -cb3_values[0].xyzx);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program107Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program107Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program853Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program853Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program107Output vert(program107Input i)
            {
                program107Output o = (program107Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program853Output frag(program853Input i)
            {
                program853Output o = (program853Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = mad(r1_xyzw_3.xyzx, (mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx, float4(0.05, -0.05, -0.05, 0));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = (float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7) + -cb3_values[0].xyzx);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program106Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program106Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program852Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program852Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program106Output vert(program106Input i)
            {
                program106Output o = (program106Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program852Output frag(program852Input i)
            {
                program852Output o = (program852Output)0;
                float4 r0_xyzw_3 = ((rsqrt(dot(cb2_values[0].xyzx, cb2_values[0].xyzx))).xxxx * cb2_values[0].xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r2_xyzw_2 = (r2_xyzw_1 * _Color);
                float4 r0_xyzw_6 = mad(r2_xyzw_2.xyzx, (mad(saturate(dot(unitWorldNormal_xyz_1.xyzx, float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3))), 0.5, 0.5)).xxxx, float4(-0.05, -0.05, -0.05, 0));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r2_xyzw_2.w;
                float4 r0_xyzw_7 = mad(unitWorldNormal_xyz_1.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float4 r0_xyzw_9 = (float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8) + -cb3_values[0].xyzx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_5 = r0_xyzw_9.y;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_9, r0_y_5, r0_z_5, r0_x_9), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program105Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program105Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program851Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program851Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program105Output vert(program105Input i)
            {
                program105Output o = (program105Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program851Output frag(program851Input i)
            {
                program851Output o = (program851Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = mad(r1_xyzw_3.xyzx, (mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx, float4(-0.05, -0.05, -0.05, 0));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = (float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7) + -cb3_values[0].xyzx);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program104Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program104Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program838Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program838Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program104Output vert(program104Input i)
            {
                program104Output o = (program104Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program838Output frag(program838Input i)
            {
                program838Output o = (program838Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = mad(r1_xyzw_3.xyzx, (mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx, float4(0.05, 0.05, 0.05, 0));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(1.1, 1.1, 1.1, 0), ((_LightColor0.xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = (float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7) + -cb3_values[0].xyzx);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program103Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program103Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program837Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program837Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program103Output vert(program103Input i)
            {
                program103Output o = (program103Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program837Output frag(program837Input i)
            {
                program837Output o = (program837Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = mad(r1_xyzw_3.xyzx, (mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx, float4(0.15, 0.05, 0.05, 0));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = (float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7) + -cb3_values[0].xyzx);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program102Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program102Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program836Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program836Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program102Output vert(program102Input i)
            {
                program102Output o = (program102Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program836Output frag(program836Input i)
            {
                program836Output o = (program836Output)0;
                float4 r0_xyzw_3 = ((rsqrt(dot(cb2_values[0].xyzx, cb2_values[0].xyzx))).xxxx * cb2_values[0].xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r2_xyzw_2 = (r2_xyzw_1 * _Color);
                float4 r0_xyzw_6 = mad(r2_xyzw_2.xyzx, (mad(saturate(dot(unitWorldNormal_xyz_1.xyzx, float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3))), 0.5, 0.5)).xxxx, float4(0.05, 0.05, 0.05, 0));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r2_xyzw_2.w;
                float4 r0_xyzw_7 = mad(unitWorldNormal_xyz_1.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float4 r0_xyzw_9 = (float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8) + -cb3_values[0].xyzx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_5 = r0_xyzw_9.y;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_9, r0_y_5, r0_z_5, r0_x_9), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program101Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program101Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program835Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program835Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program101Output vert(program101Input i)
            {
                program101Output o = (program101Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program835Output frag(program835Input i)
            {
                program835Output o = (program835Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = mad(r1_xyzw_3.xyzx, (mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx, float4(0.05, 0.05, 0.05, 0));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = (float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7) + -cb3_values[0].xyzx);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program100Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program100Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program822Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program822Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program100Output vert(program100Input i)
            {
                program100Output o = (program100Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program822Output frag(program822Input i)
            {
                program822Output o = (program822Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(1.1, 1.1, 1.1, 0), ((_LightColor0.xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = (float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7) + -cb3_values[0].xyzx);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program99Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program99Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program821Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program821Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program99Output vert(program99Input i)
            {
                program99Output o = (program99Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program821Output frag(program821Input i)
            {
                program821Output o = (program821Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = mad(r1_xyzw_3.xyzx, (mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx, float4(0.1, 0, 0, 0));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = (float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7) + -cb3_values[0].xyzx);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float r0_w_3 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_w_5 = (r0_w_4 * cb1_values[5].z);
                float r0_w_6 = max(r0_w_5, 0);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_7.xxxx, float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program98Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program98Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program820Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program820Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program98Output vert(program98Input i)
            {
                program98Output o = (program98Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program820Output frag(program820Input i)
            {
                program820Output o = (program820Output)0;
                float4 r0_xyzw_3 = ((rsqrt(dot(cb2_values[0].xyzx, cb2_values[0].xyzx))).xxxx * cb2_values[0].xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float4 r0_xyzw_2 = (unitWorldNormal_xyz_1.xxyz * float4(0, 0.02, 0.02, 0.02));
                float r0_y_2 = r0_xyzw_2.y;
                float r0_z_2 = r0_xyzw_2.z;
                float r0_w_3 = r0_xyzw_2.w;
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = mad(r1_xyzw_3.xyzx, (mad(saturate(dot(unitWorldNormal_xyz_1.xyzx, float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3))), 0.5, 0.5)).xxxx, float4(r0_y_2, r0_z_2, r0_w_3, r0_y_2));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_3 = r0_xyzw_6.y;
                float r0_z_3 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_6, r0_y_3, r0_z_3, r0_x_6));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_4 = r0_xyzw_7.y;
                float r0_z_4 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = (float4(r0_x_7, r0_y_4, r0_z_4, r0_x_7) + -cb3_values[0].xyzx);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_5 = r0_xyzw_8.y;
                float r0_z_5 = r0_xyzw_8.z;
                float r0_w_4 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_5 = (-r0_w_4 + 1);
                float r0_w_6 = (r0_w_5 * cb1_values[5].z);
                float r0_w_7 = max(r0_w_6, 0);
                float r0_w_8 = saturate(mad(r0_w_7, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_8.xxxx, float4(r0_x_8, r0_y_5, r0_z_5, r0_x_8), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program97Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program97Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program819Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program819Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program97Output vert(program97Input i)
            {
                program97Output o = (program97Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program819Output frag(program819Input i)
            {
                program819Output o = (program819Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float r0_w_1 = dot(cb2_values[0].xyzx, cb2_values[0].xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r0_xyzw_2 = (_LightColor0.xxyz * float4(0, 0.1, 0.1, 0.1));
                float r0_y_2 = r0_xyzw_2.y;
                float r0_z_2 = r0_xyzw_2.z;
                float r0_w_3 = r0_xyzw_2.w;
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = mad(r1_xyzw_3.xyzx, (mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * cb2_values[0].xyzx)).xyzx)), 0.5, 0.5)).xxxx, float4(r0_y_2, r0_z_2, r0_w_3, r0_y_2));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_3 = r0_xyzw_6.y;
                float r0_z_3 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = (float4(r0_x_6, r0_y_3, r0_z_3, r0_x_6) + -cb3_values[0].xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_4 = r0_xyzw_7.y;
                float r0_z_4 = r0_xyzw_7.z;
                float r0_w_4 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_5 = (-r0_w_4 + 1);
                float r0_w_6 = (r0_w_5 * cb1_values[5].z);
                float r0_w_7 = max(r0_w_6, 0);
                float r0_w_8 = saturate(mad(r0_w_7, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_8.xxxx, float4(r0_x_7, r0_y_4, r0_z_4, r0_x_7), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program48Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program48Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1094Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1094Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program48Output vert(program48Input i)
            {
                program48Output o = (program48Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program1094Output frag(program1094Input i)
            {
                program1094Output o = (program1094Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 0.75, 1, 0), float4(-0.05, -0.05, -0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7), float4(1.1, 1.1, 1.1, 0), ((_LightColor0.xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program47Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program47Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1093Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1093Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program47Output vert(program47Input i)
            {
                program47Output o = (program47Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program1093Output frag(program1093Input i)
            {
                program1093Output o = (program1093Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 0.75, 1, 0), float4(0.05, -0.05, -0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program46Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program46Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1092Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1092Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program46Output vert(program46Input i)
            {
                program46Output o = (program46Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program1092Output frag(program1092Input i)
            {
                program1092Output o = (program1092Output)0;
                float4 lightDir_xyzw_3 = ((rsqrt(dot(unity_ObjectToWorld[0].xyzx, unity_ObjectToWorld[0].xyzx))).xxxx * unity_ObjectToWorld[0].xyzx);
                float lightDir_x_3 = lightDir_xyzw_3.x;
                float lightDir_y_1 = lightDir_xyzw_3.y;
                float lightDir_z_1 = lightDir_xyzw_3.z;
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r2_xyzw_2 = (r2_xyzw_1 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(unitWorldNormal_xyz_1.xyzx, float4(lightDir_x_3, lightDir_y_1, lightDir_z_1, lightDir_x_3))), 0.5, 0.5)).xxxx * r2_xyzw_2.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r2_xyzw_2.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 0.75, 1, 0), float4(-0.05, -0.05, -0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(unitWorldNormal_xyz_1.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                o.sv_Target0.xyz = (mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program45Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program45Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1091Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1091Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program45Output vert(program45Input i)
            {
                program45Output o = (program45Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program1091Output frag(program1091Input i)
            {
                program1091Output o = (program1091Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 0.75, 1, 0), float4(-0.05, -0.05, -0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program44Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program44Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1078Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1078Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program44Output vert(program44Input i)
            {
                program44Output o = (program44Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program1078Output frag(program1078Input i)
            {
                program1078Output o = (program1078Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 0.75, 1, 0), float4(0.05, 0.05, 0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7), float4(1.1, 1.1, 1.1, 0), ((_LightColor0.xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program43Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program43Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1077Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1077Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program43Output vert(program43Input i)
            {
                program43Output o = (program43Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program1077Output frag(program1077Input i)
            {
                program1077Output o = (program1077Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 0.75, 1, 0), float4(0.15, 0.05, 0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program42Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program42Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1076Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1076Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program42Output vert(program42Input i)
            {
                program42Output o = (program42Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program1076Output frag(program1076Input i)
            {
                program1076Output o = (program1076Output)0;
                float4 lightDir_xyzw_3 = ((rsqrt(dot(unity_ObjectToWorld[0].xyzx, unity_ObjectToWorld[0].xyzx))).xxxx * unity_ObjectToWorld[0].xyzx);
                float lightDir_x_3 = lightDir_xyzw_3.x;
                float lightDir_y_1 = lightDir_xyzw_3.y;
                float lightDir_z_1 = lightDir_xyzw_3.z;
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r2_xyzw_2 = (r2_xyzw_1 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(unitWorldNormal_xyz_1.xyzx, float4(lightDir_x_3, lightDir_y_1, lightDir_z_1, lightDir_x_3))), 0.5, 0.5)).xxxx * r2_xyzw_2.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r2_xyzw_2.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 0.75, 1, 0), float4(0.05, 0.05, 0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(unitWorldNormal_xyz_1.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                o.sv_Target0.xyz = (mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program41Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program41Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1075Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1075Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program41Output vert(program41Input i)
            {
                program41Output o = (program41Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program1075Output frag(program1075Input i)
            {
                program1075Output o = (program1075Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 0.75, 1, 0), float4(0.05, 0.05, 0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program40Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program40Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1062Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1062Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program40Output vert(program40Input i)
            {
                program40Output o = (program40Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program1062Output frag(program1062Input i)
            {
                program1062Output o = (program1062Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                o.sv_Target0.xyz = (mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.82500005, 0.82500005, 1.1, 0), ((_LightColor0.xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program39Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program39Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1061Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1061Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program39Output vert(program39Input i)
            {
                program39Output o = (program39Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program1061Output frag(program1061Input i)
            {
                program1061Output o = (program1061Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 0.75, 1, 0), float4(0.1, 0, 0, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program38Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program38Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1060Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1060Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program38Output vert(program38Input i)
            {
                program38Output o = (program38Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program1060Output frag(program1060Input i)
            {
                program1060Output o = (program1060Output)0;
                float4 lightDir_xyzw_3 = ((rsqrt(dot(unity_ObjectToWorld[0].xyzx, unity_ObjectToWorld[0].xyzx))).xxxx * unity_ObjectToWorld[0].xyzx);
                float lightDir_x_3 = lightDir_xyzw_3.x;
                float lightDir_y_1 = lightDir_xyzw_3.y;
                float lightDir_z_1 = lightDir_xyzw_3.z;
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float4 r0_xyzw_2 = (unitWorldNormal_xyz_1.xxyz * float4(0, 0.02, 0.02, 0.02));
                float r0_y_2 = r0_xyzw_2.y;
                float r0_z_2 = r0_xyzw_2.z;
                float r0_w_3 = r0_xyzw_2.w;
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_6 = mad((((mad(saturate(dot(unitWorldNormal_xyz_1.xyzx, float4(lightDir_x_3, lightDir_y_1, lightDir_z_1, lightDir_x_3))), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx)).xyzx, float4(0.75, 0.75, 1, 0), float4(r0_y_2, r0_z_2, r0_w_3, r0_y_2));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_3 = r0_xyzw_6.y;
                float r0_z_3 = r0_xyzw_6.z;
                o.sv_Target0.xyz = (mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_6, r0_y_3, r0_z_3, r0_x_6))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program37Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program37Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1059Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program1059Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program37Output vert(program37Input i)
            {
                program37Output o = (program37Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program1059Output frag(program1059Input i)
            {
                program1059Output o = (program1059Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                o.sv_Target0.xyz = (mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 0.75, 1, 0), ((_LightColor0.xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program36Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program36Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program998Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program998Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program36Output vert(program36Input i)
            {
                program36Output o = (program36Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program998Output frag(program998Input i)
            {
                program998Output o = (program998Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 1, 0.75, 0), float4(-0.05, -0.05, -0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7), float4(1.1, 1.1, 1.1, 0), ((_LightColor0.xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program35Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program35Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program997Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program997Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program35Output vert(program35Input i)
            {
                program35Output o = (program35Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program997Output frag(program997Input i)
            {
                program997Output o = (program997Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 1, 0.75, 0), float4(0.05, -0.05, -0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program34Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program34Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program996Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program996Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program34Output vert(program34Input i)
            {
                program34Output o = (program34Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program996Output frag(program996Input i)
            {
                program996Output o = (program996Output)0;
                float4 lightDir_xyzw_3 = ((rsqrt(dot(unity_ObjectToWorld[0].xyzx, unity_ObjectToWorld[0].xyzx))).xxxx * unity_ObjectToWorld[0].xyzx);
                float lightDir_x_3 = lightDir_xyzw_3.x;
                float lightDir_y_1 = lightDir_xyzw_3.y;
                float lightDir_z_1 = lightDir_xyzw_3.z;
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r2_xyzw_2 = (r2_xyzw_1 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(unitWorldNormal_xyz_1.xyzx, float4(lightDir_x_3, lightDir_y_1, lightDir_z_1, lightDir_x_3))), 0.5, 0.5)).xxxx * r2_xyzw_2.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r2_xyzw_2.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 1, 0.75, 0), float4(-0.05, -0.05, -0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(unitWorldNormal_xyz_1.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                o.sv_Target0.xyz = (mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program33Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program33Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program995Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program995Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program33Output vert(program33Input i)
            {
                program33Output o = (program33Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program995Output frag(program995Input i)
            {
                program995Output o = (program995Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 1, 0.75, 0), float4(-0.05, -0.05, -0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program32Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program32Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program982Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program982Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program32Output vert(program32Input i)
            {
                program32Output o = (program32Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program982Output frag(program982Input i)
            {
                program982Output o = (program982Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 1, 0.75, 0), float4(0.05, 0.05, 0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7), float4(1.1, 1.1, 1.1, 0), ((_LightColor0.xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program31Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program31Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program981Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program981Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program31Output vert(program31Input i)
            {
                program31Output o = (program31Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program981Output frag(program981Input i)
            {
                program981Output o = (program981Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 1, 0.75, 0), float4(0.15, 0.05, 0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program30Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program30Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program980Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program980Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program30Output vert(program30Input i)
            {
                program30Output o = (program30Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program980Output frag(program980Input i)
            {
                program980Output o = (program980Output)0;
                float4 lightDir_xyzw_3 = ((rsqrt(dot(unity_ObjectToWorld[0].xyzx, unity_ObjectToWorld[0].xyzx))).xxxx * unity_ObjectToWorld[0].xyzx);
                float lightDir_x_3 = lightDir_xyzw_3.x;
                float lightDir_y_1 = lightDir_xyzw_3.y;
                float lightDir_z_1 = lightDir_xyzw_3.z;
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r2_xyzw_2 = (r2_xyzw_1 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(unitWorldNormal_xyz_1.xyzx, float4(lightDir_x_3, lightDir_y_1, lightDir_z_1, lightDir_x_3))), 0.5, 0.5)).xxxx * r2_xyzw_2.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r2_xyzw_2.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 1, 0.75, 0), float4(0.05, 0.05, 0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(unitWorldNormal_xyz_1.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                o.sv_Target0.xyz = (mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program29Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program29Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program979Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program979Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program29Output vert(program29Input i)
            {
                program29Output o = (program29Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program979Output frag(program979Input i)
            {
                program979Output o = (program979Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 1, 0.75, 0), float4(0.05, 0.05, 0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program28Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program28Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program966Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program966Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program28Output vert(program28Input i)
            {
                program28Output o = (program28Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program966Output frag(program966Input i)
            {
                program966Output o = (program966Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                o.sv_Target0.xyz = (mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.82500005, 1.1, 0.82500005, 0), ((_LightColor0.xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program27Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program27Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program965Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program965Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program27Output vert(program27Input i)
            {
                program27Output o = (program27Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program965Output frag(program965Input i)
            {
                program965Output o = (program965Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 1, 0.75, 0), float4(0.1, 0, 0, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program26Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program26Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program964Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program964Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program26Output vert(program26Input i)
            {
                program26Output o = (program26Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program964Output frag(program964Input i)
            {
                program964Output o = (program964Output)0;
                float4 lightDir_xyzw_3 = ((rsqrt(dot(unity_ObjectToWorld[0].xyzx, unity_ObjectToWorld[0].xyzx))).xxxx * unity_ObjectToWorld[0].xyzx);
                float lightDir_x_3 = lightDir_xyzw_3.x;
                float lightDir_y_1 = lightDir_xyzw_3.y;
                float lightDir_z_1 = lightDir_xyzw_3.z;
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float4 r0_xyzw_2 = (unitWorldNormal_xyz_1.xxyz * float4(0, 0.02, 0.02, 0.02));
                float r0_y_2 = r0_xyzw_2.y;
                float r0_z_2 = r0_xyzw_2.z;
                float r0_w_3 = r0_xyzw_2.w;
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_6 = mad((((mad(saturate(dot(unitWorldNormal_xyz_1.xyzx, float4(lightDir_x_3, lightDir_y_1, lightDir_z_1, lightDir_x_3))), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx)).xyzx, float4(0.75, 1, 0.75, 0), float4(r0_y_2, r0_z_2, r0_w_3, r0_y_2));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_3 = r0_xyzw_6.y;
                float r0_z_3 = r0_xyzw_6.z;
                o.sv_Target0.xyz = (mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_6, r0_y_3, r0_z_3, r0_x_6))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program25Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program25Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program963Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program963Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program25Output vert(program25Input i)
            {
                program25Output o = (program25Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program963Output frag(program963Input i)
            {
                program963Output o = (program963Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                o.sv_Target0.xyz = (mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(0.75, 1, 0.75, 0), ((_LightColor0.xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program24Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program24Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program902Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program902Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program24Output vert(program24Input i)
            {
                program24Output o = (program24Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program902Output frag(program902Input i)
            {
                program902Output o = (program902Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(1, 0.75, 0.75, 0), float4(-0.05, -0.05, -0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7), float4(1.1, 1.1, 1.1, 0), ((_LightColor0.xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program23Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program23Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program901Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program901Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program23Output vert(program23Input i)
            {
                program23Output o = (program23Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program901Output frag(program901Input i)
            {
                program901Output o = (program901Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(1, 0.75, 0.75, 0), float4(0.05, -0.05, -0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program22Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program22Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program900Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program900Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program22Output vert(program22Input i)
            {
                program22Output o = (program22Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program900Output frag(program900Input i)
            {
                program900Output o = (program900Output)0;
                float4 lightDir_xyzw_3 = ((rsqrt(dot(unity_ObjectToWorld[0].xyzx, unity_ObjectToWorld[0].xyzx))).xxxx * unity_ObjectToWorld[0].xyzx);
                float lightDir_x_3 = lightDir_xyzw_3.x;
                float lightDir_y_1 = lightDir_xyzw_3.y;
                float lightDir_z_1 = lightDir_xyzw_3.z;
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r2_xyzw_2 = (r2_xyzw_1 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(unitWorldNormal_xyz_1.xyzx, float4(lightDir_x_3, lightDir_y_1, lightDir_z_1, lightDir_x_3))), 0.5, 0.5)).xxxx * r2_xyzw_2.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r2_xyzw_2.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(1, 0.75, 0.75, 0), float4(-0.05, -0.05, -0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(unitWorldNormal_xyz_1.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                o.sv_Target0.xyz = (mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program21Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program21Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program899Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program899Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program21Output vert(program21Input i)
            {
                program21Output o = (program21Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program899Output frag(program899Input i)
            {
                program899Output o = (program899Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(1, 0.75, 0.75, 0), float4(-0.05, -0.05, -0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program20Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program20Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program886Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program886Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program20Output vert(program20Input i)
            {
                program20Output o = (program20Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program886Output frag(program886Input i)
            {
                program886Output o = (program886Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(1, 0.75, 0.75, 0), float4(0.05, 0.05, 0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7), float4(1.1, 1.1, 1.1, 0), ((_LightColor0.xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program19Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program19Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program885Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program885Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program19Output vert(program19Input i)
            {
                program19Output o = (program19Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program885Output frag(program885Input i)
            {
                program885Output o = (program885Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(1, 0.75, 0.75, 0), float4(0.15, 0.05, 0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program18Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program18Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program884Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program884Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program18Output vert(program18Input i)
            {
                program18Output o = (program18Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program884Output frag(program884Input i)
            {
                program884Output o = (program884Output)0;
                float4 lightDir_xyzw_3 = ((rsqrt(dot(unity_ObjectToWorld[0].xyzx, unity_ObjectToWorld[0].xyzx))).xxxx * unity_ObjectToWorld[0].xyzx);
                float lightDir_x_3 = lightDir_xyzw_3.x;
                float lightDir_y_1 = lightDir_xyzw_3.y;
                float lightDir_z_1 = lightDir_xyzw_3.z;
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r2_xyzw_2 = (r2_xyzw_1 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(unitWorldNormal_xyz_1.xyzx, float4(lightDir_x_3, lightDir_y_1, lightDir_z_1, lightDir_x_3))), 0.5, 0.5)).xxxx * r2_xyzw_2.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r2_xyzw_2.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(1, 0.75, 0.75, 0), float4(0.05, 0.05, 0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(unitWorldNormal_xyz_1.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_4 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                o.sv_Target0.xyz = (mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_8, r0_y_4, r0_z_4, r0_x_8))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program17Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program17Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program883Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program883Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program17Output vert(program17Input i)
            {
                program17Output o = (program17Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program883Output frag(program883Input i)
            {
                program883Output o = (program883Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(1, 0.75, 0.75, 0), float4(0.05, 0.05, 0.05, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program16Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program16Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program870Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program870Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program16Output vert(program16Input i)
            {
                program16Output o = (program16Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program870Output frag(program870Input i)
            {
                program870Output o = (program870Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                o.sv_Target0.xyz = (mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(1.1, 0.82500005, 0.82500005, 0), ((_LightColor0.xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program15Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program15Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program869Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program869Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program15Output vert(program15Input i)
            {
                program15Output o = (program15Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program869Output frag(program869Input i)
            {
                program869Output o = (program869Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(1, 0.75, 0.75, 0), float4(0.1, 0, 0, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program14Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program14Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program868Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program868Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program14Output vert(program14Input i)
            {
                program14Output o = (program14Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program868Output frag(program868Input i)
            {
                program868Output o = (program868Output)0;
                float4 lightDir_xyzw_3 = ((rsqrt(dot(unity_ObjectToWorld[0].xyzx, unity_ObjectToWorld[0].xyzx))).xxxx * unity_ObjectToWorld[0].xyzx);
                float lightDir_x_3 = lightDir_xyzw_3.x;
                float lightDir_y_1 = lightDir_xyzw_3.y;
                float lightDir_z_1 = lightDir_xyzw_3.z;
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float4 r0_xyzw_2 = (unitWorldNormal_xyz_1.xxyz * float4(0, 0.02, 0.02, 0.02));
                float r0_y_2 = r0_xyzw_2.y;
                float r0_z_2 = r0_xyzw_2.z;
                float r0_w_3 = r0_xyzw_2.w;
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_6 = mad((((mad(saturate(dot(unitWorldNormal_xyz_1.xyzx, float4(lightDir_x_3, lightDir_y_1, lightDir_z_1, lightDir_x_3))), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx)).xyzx, float4(1, 0.75, 0.75, 0), float4(r0_y_2, r0_z_2, r0_w_3, r0_y_2));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_3 = r0_xyzw_6.y;
                float r0_z_3 = r0_xyzw_6.z;
                o.sv_Target0.xyz = (mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_6, r0_y_3, r0_z_3, r0_x_6))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program13Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program13Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program867Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program867Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program13Output vert(program13Input i)
            {
                program13Output o = (program13Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program867Output frag(program867Input i)
            {
                program867Output o = (program867Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                o.sv_Target0.xyz = (mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(1, 0.75, 0.75, 0), ((_LightColor0.xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program12Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program12Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program806Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program806Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program12Output vert(program12Input i)
            {
                program12Output o = (program12Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program806Output frag(program806Input i)
            {
                program806Output o = (program806Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = mad(r1_xyzw_3.xyzx, (mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx, float4(-0.05, -0.05, -0.05, 0));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                o.sv_Target0.xyz = (mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(1.1, 1.1, 1.1, 0), ((_LightColor0.xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program11Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program11Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program805Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program805Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program11Output vert(program11Input i)
            {
                program11Output o = (program11Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program805Output frag(program805Input i)
            {
                program805Output o = (program805Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = mad(r1_xyzw_3.xyzx, (mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx, float4(0.05, -0.05, -0.05, 0));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                o.sv_Target0.xyz = (mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program10Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program10Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program804Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program804Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program10Output vert(program10Input i)
            {
                program10Output o = (program10Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program804Output frag(program804Input i)
            {
                program804Output o = (program804Output)0;
                float4 lightDir_xyzw_3 = ((rsqrt(dot(unity_ObjectToWorld[0].xyzx, unity_ObjectToWorld[0].xyzx))).xxxx * unity_ObjectToWorld[0].xyzx);
                float lightDir_x_3 = lightDir_xyzw_3.x;
                float lightDir_y_1 = lightDir_xyzw_3.y;
                float lightDir_z_1 = lightDir_xyzw_3.z;
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r2_xyzw_2 = (r2_xyzw_1 * _Color);
                float4 r0_xyzw_6 = mad(r2_xyzw_2.xyzx, (mad(saturate(dot(unitWorldNormal_xyz_1.xyzx, float4(lightDir_x_3, lightDir_y_1, lightDir_z_1, lightDir_x_3))), 0.5, 0.5)).xxxx, float4(-0.05, -0.05, -0.05, 0));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r2_xyzw_2.w;
                float4 r0_xyzw_7 = mad(unitWorldNormal_xyz_1.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program9Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program9Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program803Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program803Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program9Output vert(program9Input i)
            {
                program9Output o = (program9Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program803Output frag(program803Input i)
            {
                program803Output o = (program803Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = mad(r1_xyzw_3.xyzx, (mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx, float4(-0.05, -0.05, -0.05, 0));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                o.sv_Target0.xyz = (mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program8Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program8Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program790Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program790Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program8Output vert(program8Input i)
            {
                program8Output o = (program8Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program790Output frag(program790Input i)
            {
                program790Output o = (program790Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = mad(r1_xyzw_3.xyzx, (mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx, float4(0.05, 0.05, 0.05, 0));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                o.sv_Target0.xyz = (mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(1.1, 1.1, 1.1, 0), ((_LightColor0.xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program7Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program7Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program789Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program789Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program7Output vert(program7Input i)
            {
                program7Output o = (program7Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program789Output frag(program789Input i)
            {
                program789Output o = (program789Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = mad(r1_xyzw_3.xyzx, (mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx, float4(0.15, 0.05, 0.05, 0));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                o.sv_Target0.xyz = (mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program6Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program6Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program788Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program788Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program6Output vert(program6Input i)
            {
                program6Output o = (program6Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program788Output frag(program788Input i)
            {
                program788Output o = (program788Output)0;
                float4 lightDir_xyzw_3 = ((rsqrt(dot(unity_ObjectToWorld[0].xyzx, unity_ObjectToWorld[0].xyzx))).xxxx * unity_ObjectToWorld[0].xyzx);
                float lightDir_x_3 = lightDir_xyzw_3.x;
                float lightDir_y_1 = lightDir_xyzw_3.y;
                float lightDir_z_1 = lightDir_xyzw_3.z;
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r2_xyzw_2 = (r2_xyzw_1 * _Color);
                float4 r0_xyzw_6 = mad(r2_xyzw_2.xyzx, (mad(saturate(dot(unitWorldNormal_xyz_1.xyzx, float4(lightDir_x_3, lightDir_y_1, lightDir_z_1, lightDir_x_3))), 0.5, 0.5)).xxxx, float4(0.05, 0.05, 0.05, 0));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r2_xyzw_2.w;
                float4 r0_xyzw_7 = mad(unitWorldNormal_xyz_1.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_3 = r0_xyzw_7.y;
                float r0_z_3 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_7, r0_y_3, r0_z_3, r0_x_7))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program5Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program5Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program787Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program787Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program5Output vert(program5Input i)
            {
                program5Output o = (program5Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program787Output frag(program787Input i)
            {
                program787Output o = (program787Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = mad(r1_xyzw_3.xyzx, (mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx, float4(0.05, 0.05, 0.05, 0));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                o.sv_Target0.xyz = (mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program4Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program4Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program774Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program774Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program4Output vert(program4Input i)
            {
                program4Output o = (program4Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program774Output frag(program774Input i)
            {
                program774Output o = (program774Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = ((mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                o.sv_Target0.xyz = (mad(float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6), float4(1.1, 1.1, 1.1, 0), ((_LightColor0.xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program3Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program3Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program773Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program773Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program3Output vert(program3Input i)
            {
                program3Output o = (program3Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program773Output frag(program773Input i)
            {
                program773Output o = (program773Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(unity_ObjectToWorld [0]);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = mad(r1_xyzw_3.xyzx, (mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx, float4(0.1, 0, 0, 0));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_2 = r0_xyzw_6.y;
                float r0_z_2 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                o.sv_Target0.xyz = (mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_6, r0_y_2, r0_z_2, r0_x_6))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program2Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program2Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program772Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program772Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program2Output vert(program2Input i)
            {
                program2Output o = (program2Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program772Output frag(program772Input i)
            {
                program772Output o = (program772Output)0;
                float4 lightDir_xyzw_3 = ((rsqrt(dot(unity_ObjectToWorld[0].xyzx, unity_ObjectToWorld[0].xyzx))).xxxx * unity_ObjectToWorld[0].xyzx);
                float lightDir_x_3 = lightDir_xyzw_3.x;
                float lightDir_y_1 = lightDir_xyzw_3.y;
                float lightDir_z_1 = lightDir_xyzw_3.z;
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float4 r0_xyzw_2 = (unitWorldNormal_xyz_1.xxyz * float4(0, 0.02, 0.02, 0.02));
                float r0_y_2 = r0_xyzw_2.y;
                float r0_z_2 = r0_xyzw_2.z;
                float r0_w_3 = r0_xyzw_2.w;
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_6 = mad(r1_xyzw_3.xyzx, (mad(saturate(dot(unitWorldNormal_xyz_1.xyzx, float4(lightDir_x_3, lightDir_y_1, lightDir_z_1, lightDir_x_3))), 0.5, 0.5)).xxxx, float4(r0_y_2, r0_z_2, r0_w_3, r0_y_2));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_3 = r0_xyzw_6.y;
                float r0_z_3 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                o.sv_Target0.xyz = (mad(_LightColor0.xyzx, float4(0.1, 0.1, 0.1, 0), float4(r0_x_6, r0_y_3, r0_z_3, r0_x_6))).xyz;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Diffuse"
}
