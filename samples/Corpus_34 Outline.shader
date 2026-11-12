Shader "Corpus/34 Outline"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "" {}
        _Color ("Color", Color) = (1,1,1,1)
        _OutlineColor ("Outline Color", Color) = (0,0,0,1)
        _OutlineWidth ("Outline Width", Range(0, 0.2)) = 0.02
    }
    SubShader
    {
        Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
        LOD 0
        Pass
        {
            Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
            Cull Front
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _OutlineColor : packoffset(c2);
                float _OutlineWidth : packoffset(c3.x);
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
            struct program1Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
            };
            struct program1Output
            {
                float4 sv_Position0 : SV_POSITION;
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_POSITION;
            };
            struct program3Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program1Output vert(program1Input i)
            {
                program1Output o = (program1Output)0;
                float worldNormal_x_1 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_1 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_1 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_1 = dot(float4(worldNormal_x_1, worldNormal_y_1, worldNormal_z_1, worldNormal_x_1), float4(worldNormal_x_1, worldNormal_y_1, worldNormal_z_1, worldNormal_x_1));
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitWorldNormal_xyz_2 = ((r0_w_2.xxxx * float4(worldNormal_x_1, worldNormal_y_1, worldNormal_z_1, worldNormal_x_1))).xyz;
                float4 worldPos_xyzw_1 = (i.position0.yyyy * unity_ObjectToWorld[1]);
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, worldPos_xyzw_1);
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 r0_xyz_3 = (mad(unitWorldNormal_xyz_2.xyzx, _OutlineWidth.xxxx, worldPos_xyzw_4.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(unity_MatrixVP[2], r0_xyz_3.zzzz, mad(unity_MatrixVP[0], r0_xyz_3.xxxx, (r0_xyz_3.yyyy * unity_MatrixVP[1])));
                o.sv_Position0.xyzw = mad(unity_MatrixVP[3], worldPos_xyzw_4.wwww, r0_xyzw_4);
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                o.sv_Target0.xyzw = _OutlineColor;
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
                float4 unity_SHAr : packoffset(c39);
                float4 unity_SHAg : packoffset(c40);
                float4 unity_SHAb : packoffset(c41);
                float4 unity_SHBr : packoffset(c42);
                float4 unity_SHBg : packoffset(c43);
                float4 unity_SHBb : packoffset(c44);
                float4 unity_SHC : packoffset(c45);
                float4 unity_OcclusionMaskSelector : packoffset(c46);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 unity_ProbeVolumeParams : packoffset(c0);
                float4x4 unity_ProbeVolumeWorldToObject : packoffset(c1);
                float3 unity_ProbeVolumeSizeInv : packoffset(c5);
                float3 unity_ProbeVolumeMin : packoffset(c6);
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture3D t1;
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
                float4 texcoord5 : TEXCOORD5;
            };
            struct program26Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program26Output
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
            program26Output frag(program26Input i)
            {
                program26Output o = (program26Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r0_xyzw_2 = (r0_xyzw_1 * _Color);
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float4 lightDir_xyzw_3 = ((rsqrt(dot(unity_ObjectToWorld[0].xyzx, unity_ObjectToWorld[0].xyzx))).xxxx * unity_ObjectToWorld[0].xyzx);
                float lightDir_x_3 = lightDir_xyzw_3.x;
                float lightDir_y_1 = lightDir_xyzw_3.y;
                float lightDir_z_1 = lightDir_xyzw_3.z;
                float r2_w_1 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_11;
                float r3_z_10;
                float r3_w_4;
                if (r2_w_1)
                {
                    float r2_w_2 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r2_w_2.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r2_w_3 = mad(r3_y_8, 0.25, 0.75);
                    float r3_y_9 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r2_w_3, r3_y_9);
                    float4 r3_xyzw_9 = t1.Sample(sampler_linear_clamp, (float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8)).xyz);
                    r3_x_10 = r3_xyzw_9.x;
                    r3_y_11 = r3_xyzw_9.y;
                    r3_z_10 = r3_xyzw_9.z;
                    r3_w_4 = r3_xyzw_9.w;
                }
                else
                {
                    float4 r3_xyzw_10 = float4(1, 1, 1, 1);
                    r3_x_10 = r3_xyzw_10.x;
                    r3_y_11 = r3_xyzw_10.y;
                    r3_z_10 = r3_xyzw_10.z;
                    r3_w_4 = r3_xyzw_10.w;
                }
                float r2_w_5 = saturate(dot(float4(r3_x_10, r3_y_11, r3_z_10, r3_w_4), unity_OcclusionMaskSelector));
                float r1_w_1 = 1;
                float r3_x_11 = dot(unity_SHAr, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r3_y_12 = dot(unity_SHAg, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r3_z_11 = dot(unity_SHAb, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float4 r4_xyzw_1 = (float4(unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1, unitWorldNormal_x_3) * float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1));
                float r5_x_1 = dot(unity_SHBr, r4_xyzw_1);
                float r5_y_1 = dot(unity_SHBg, r4_xyzw_1);
                float r5_z_1 = dot(unity_SHBb, r4_xyzw_1);
                float r1_w_2 = (unitWorldNormal_y_1 * unitWorldNormal_y_1);
                float r1_w_3 = mad(unitWorldNormal_x_3, unitWorldNormal_x_3, -r1_w_2);
                float4 r3_xyzw_12 = (float4(r3_x_11, r3_y_12, r3_z_11, r3_x_11) + (mad(unity_SHC.xyzx, r1_w_3.xxxx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1))).xyzx);
                float r3_x_12 = r3_xyzw_12.x;
                float r3_y_13 = r3_xyzw_12.y;
                float r3_z_12 = r3_xyzw_12.z;
                float4 r1_xyzw_5 = ((saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), float4(lightDir_x_3, lightDir_y_1, lightDir_z_1, lightDir_x_3)))).xxxx * _LightColor0.xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_2 = r1_xyzw_5.y;
                float r1_z_2 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = mad(float4(r1_x_5, r1_y_2, r1_z_2, r1_x_5), r2_w_5.xxxx, float4(r3_x_12, r3_y_13, r3_z_12, r3_x_12));
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_3 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                o.sv_Target0.xyz = ((r0_xyzw_2.xyzx * float4(r1_x_6, r1_y_3, r1_z_3, r1_x_6))).xyz;
                o.sv_Target0.w = r0_xyzw_2.w;
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
                float4 unity_SHAr;
                float4 unity_SHAg;
                float4 unity_SHAb;
                float4 unity_SHBr;
                float4 unity_SHBg;
                float4 unity_SHBb;
                float4 unity_SHC;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[47];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[26];
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[12];
            };
            cbuffer cb5 : register(b5)
            {
                float4 cb5_values[2];
            };
            cbuffer cb6 : register(b6)
            {
                float4 cb6_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            Texture3D t2;
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
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program33Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program33Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program17Output vert(program17Input i)
            {
                program17Output o = (program17Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord5.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_z_8 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r0_z_9 = rsqrt(r0_z_8);
                o.texcoord1.xyz = ((r0_z_9.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r0_xyzw_8 = (clipPos_xyzw_7.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_z_10 = r0_xyzw_8.z;
                float r0_w_8 = (r0_y_8 * 0.5);
                o.texcoord5.xy = ((r0_z_10.xxxx + float4(r0_x_8, r0_w_8, r0_x_8, r0_x_8))).xy;
                return o;
            }
            #pragma fragment frag
            program33Output frag(program33Input i)
            {
                program33Output o = (program33Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r0_xyzw_2 = (r0_xyzw_1 * _Color);
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float4 r2_xyzw_3 = ((rsqrt(dot(unity_ProbeVolumeParams.xyzx, unity_ProbeVolumeParams.xyzx))).xxxx * unity_ProbeVolumeParams.xyzx);
                float r2_x_3 = r2_xyzw_3.x;
                float r2_y_1 = r2_xyzw_3.y;
                float r2_z_1 = r2_xyzw_3.z;
                float r4_x_1 = cb4_values[9].z;
                float r4_y_1 = cb4_values[10].z;
                float r4_z_1 = cb4_values[11].z;
                float r2_w_1 = dot(((-i.texcoord2.xyzx + cb1_values[4].xyzx)).xyzx, float4(r4_x_1, r4_y_1, r4_z_1, r4_x_1));
                float3 r3_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = mad(cb3_values[25].w, (-r2_w_1 + sqrt(dot(r3_xyz_2.xyzx, r3_xyz_2.xyzx))), r2_w_1);
                float r2_w_3 = saturate(mad(r2_w_2, cb3_values[24].z, cb3_values[24].w));
                float r3_x_13;
                float r3_y_13;
                float r3_z_12;
                float r3_w_8;
                if (((cb6_values[0].x == 1)).x)
                {
                    float4 r3_xyzw_4 = (i.texcoord2.yyyy * cb6_values[2].xxyz);
                    float r3_y_4 = r3_xyzw_4.y;
                    float r3_z_4 = r3_xyzw_4.z;
                    float r3_w_2 = r3_xyzw_4.w;
                    float4 r3_xyzw_5 = mad(cb6_values[1].xxyz, i.texcoord2.xxxx, float4(r3_y_4, r3_y_4, r3_z_4, r3_w_2));
                    float r3_y_5 = r3_xyzw_5.y;
                    float r3_z_5 = r3_xyzw_5.z;
                    float r3_w_3 = r3_xyzw_5.w;
                    float4 r3_xyzw_6 = mad(cb6_values[3].xxyz, i.texcoord2.zzzz, float4(r3_y_5, r3_y_5, r3_z_5, r3_w_3));
                    float r3_y_6 = r3_xyzw_6.y;
                    float r3_z_6 = r3_xyzw_6.z;
                    float r3_w_4 = r3_xyzw_6.w;
                    float4 r3_xyzw_7 = (float4(r3_y_6, r3_y_6, r3_z_6, r3_w_4) + cb6_values[4].xxyz);
                    float r3_y_7 = r3_xyzw_7.y;
                    float r3_z_7 = r3_xyzw_7.z;
                    float r3_w_5 = r3_xyzw_7.w;
                    float4 r3_xyzw_9 = (((cb6_values[0].y == 1)).xxxx ? float4(r3_y_7, r3_z_7, r3_w_5, r3_y_7) : i.texcoord2.xyzx);
                    float r3_x_9 = r3_xyzw_9.x;
                    float r3_y_8 = r3_xyzw_9.y;
                    float r3_z_8 = r3_xyzw_9.z;
                    float4 r3_xyzw_10 = (float4(r3_x_9, r3_y_8, r3_z_8, r3_x_9) + -cb6_values[6].xyzx);
                    float r3_x_10 = r3_xyzw_10.x;
                    float r3_y_9 = r3_xyzw_10.y;
                    float r3_z_9 = r3_xyzw_10.z;
                    float r3_y_10 = ((float4(r3_x_10, r3_x_10, r3_y_9, r3_z_9) * cb6_values[5].xxyz)).y;
                    float r3_z_10 = ((float4(r3_x_10, r3_x_10, r3_y_9, r3_z_9) * cb6_values[5].xxyz)).z;
                    float r3_w_6 = ((float4(r3_x_10, r3_x_10, r3_y_9, r3_z_9) * cb6_values[5].xxyz)).w;
                    float r3_y_11 = mad(r3_y_10, 0.25, 0.75);
                    float r3_x_11 = max(r3_y_11, mad(cb6_values[0].z, 0.5, 0.75));
                    float4 r3_xyzw_12 = t2.Sample(sampler_linear_clamp, (float4(r3_x_11, r3_z_10, r3_w_6, r3_x_11)).xyz);
                    r3_x_13 = r3_xyzw_12.x;
                    r3_y_13 = r3_xyzw_12.y;
                    r3_z_12 = r3_xyzw_12.z;
                    r3_w_8 = r3_xyzw_12.w;
                }
                else
                {
                    float r3_x_7 = (float4(1, 1, 1, 1)).x;
                    float4 r3_xyzw_3 = float4(1, 1, 1, 1);
                    float r3_y_3 = r3_xyzw_3.y;
                    float r3_z_3 = r3_xyzw_3.z;
                    float r3_w_1 = r3_xyzw_3.w;
                    r3_x_13 = r3_x_7;
                    r3_y_13 = r3_y_3;
                    r3_z_12 = r3_z_3;
                    r3_w_8 = r3_w_1;
                }
                float4 r3_xyzw_14 = (i.texcoord5.xxyx / i.texcoord5.wwww);
                float r3_y_14 = r3_xyzw_14.y;
                float r3_z_13 = r3_xyzw_14.z;
                float4 r4_xyzw_4 = t1.Sample(sampler_linear_clamp1, (float4(r3_y_14, r3_z_13, r3_y_14, r3_y_14)).xy);
                float r2_w_4 = mad(r2_w_3, (saturate(dot(float4(r3_x_13, r3_y_13, r3_z_12, r3_w_8), cb2_values[46].xyzw)) + -r4_xyzw_4.x), r4_xyzw_4.x);
                float r1_w_1 = 1;
                float r3_x_16 = dot(cb2_values[39].xyzw, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r3_y_15 = dot(cb2_values[40].xyzw, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r3_z_14 = dot(cb2_values[41].xyzw, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float4 r4_xyzw_5 = (float4(unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1, unitWorldNormal_x_3) * float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1));
                float r5_x_1 = dot(cb2_values[42].xyzw, r4_xyzw_5);
                float r5_y_1 = dot(cb2_values[43].xyzw, r4_xyzw_5);
                float r5_z_1 = dot(cb2_values[44].xyzw, r4_xyzw_5);
                float r1_w_2 = (unitWorldNormal_y_1 * unitWorldNormal_y_1);
                float r1_w_3 = mad(unitWorldNormal_x_3, unitWorldNormal_x_3, -r1_w_2);
                float4 r4_xyzw_6 = mad(cb2_values[45].xyzx, r1_w_3.xxxx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1));
                float r4_x_6 = r4_xyzw_6.x;
                float r4_y_4 = r4_xyzw_6.y;
                float r4_z_4 = r4_xyzw_6.z;
                float4 r3_xyzw_17 = (float4(r3_x_16, r3_y_15, r3_z_14, r3_x_16) + float4(r4_x_6, r4_y_4, r4_z_4, r4_x_6));
                float r3_x_17 = r3_xyzw_17.x;
                float r3_y_16 = r3_xyzw_17.y;
                float r3_z_15 = r3_xyzw_17.z;
                float4 r1_xyzw_5 = ((saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), float4(r2_x_3, r2_y_1, r2_z_1, r2_x_3)))).xxxx * _LightColor0.xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_2 = r1_xyzw_5.y;
                float r1_z_2 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = mad(float4(r1_x_5, r1_y_2, r1_z_2, r1_x_5), r2_w_4.xxxx, float4(r3_x_17, r3_y_16, r3_z_15, r3_x_17));
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_3 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                float r1_w_4 = (i.texcoord3.x / cb1_values[5].y);
                float r1_w_5 = (-r1_w_4 + 1);
                float r1_w_6 = (r1_w_5 * cb1_values[5].z);
                float r1_w_7 = max(r1_w_6, 0);
                float r1_w_8 = saturate(mad(r1_w_7, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = (mad(r1_w_8.xxxx, (mad(r0_xyzw_2.xyzx, float4(r1_x_6, r1_y_3, r1_z_3, r1_x_6), -cb5_values[0].xyzx)).xyzx, cb5_values[0].xyzx)).xyz;
                o.sv_Target0.w = r0_xyzw_2.w;
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
                float4 unity_SHAr;
                float4 unity_SHAg;
                float4 unity_SHAb;
                float4 unity_SHBr;
                float4 unity_SHBg;
                float4 unity_SHBb;
                float4 unity_SHC;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[47];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[21];
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture3D t1;
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
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program31Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program31Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program16Output vert(program16Input i)
            {
                program16Output o = (program16Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord5.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_z_8 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r0_z_9 = rsqrt(r0_z_8);
                o.texcoord1.xyz = ((r0_z_9.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r0_xyzw_8 = (clipPos_xyzw_7.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_z_10 = r0_xyzw_8.z;
                float r0_w_8 = (r0_y_8 * 0.5);
                o.texcoord5.xy = ((r0_z_10.xxxx + float4(r0_x_8, r0_w_8, r0_x_8, r0_x_8))).xy;
                return o;
            }
            #pragma fragment frag
            program31Output frag(program31Input i)
            {
                program31Output o = (program31Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r0_xyzw_2 = (r0_xyzw_1 * _Color);
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float4 r2_xyzw_3 = ((rsqrt(dot(unity_ProbeVolumeParams.xyzx, unity_ProbeVolumeParams.xyzx))).xxxx * unity_ProbeVolumeParams.xyzx);
                float r2_x_3 = r2_xyzw_3.x;
                float r2_y_1 = r2_xyzw_3.y;
                float r2_z_1 = r2_xyzw_3.z;
                float r2_w_1 = (cb4_values[0].x == 1);
                float r3_x_10;
                float r3_y_11;
                float r3_z_10;
                float r3_w_4;
                if (r2_w_1)
                {
                    float r2_w_2 = (cb4_values[0].y == 1);
                    float3 r3_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord2.zzzz, (mad(cb4_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r3_xyzw_8 = (((((r2_w_2.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r2_w_3 = mad(r3_y_8, 0.25, 0.75);
                    float r3_y_9 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r3_x_8 = max(r2_w_3, r3_y_9);
                    float4 r3_xyzw_9 = t1.Sample(sampler_linear_clamp, (float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8)).xyz);
                    r3_x_10 = r3_xyzw_9.x;
                    r3_y_11 = r3_xyzw_9.y;
                    r3_z_10 = r3_xyzw_9.z;
                    r3_w_4 = r3_xyzw_9.w;
                }
                else
                {
                    float4 r3_xyzw_10 = float4(1, 1, 1, 1);
                    r3_x_10 = r3_xyzw_10.x;
                    r3_y_11 = r3_xyzw_10.y;
                    r3_z_10 = r3_xyzw_10.z;
                    r3_w_4 = r3_xyzw_10.w;
                }
                float r2_w_5 = saturate(dot(float4(r3_x_10, r3_y_11, r3_z_10, r3_w_4), cb2_values[46].xyzw));
                float r1_w_1 = 1;
                float r3_x_11 = dot(cb2_values[39].xyzw, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r3_y_12 = dot(cb2_values[40].xyzw, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r3_z_11 = dot(cb2_values[41].xyzw, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float4 r4_xyzw_1 = (float4(unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1, unitWorldNormal_x_3) * float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1));
                float r5_x_1 = dot(cb2_values[42].xyzw, r4_xyzw_1);
                float r5_y_1 = dot(cb2_values[43].xyzw, r4_xyzw_1);
                float r5_z_1 = dot(cb2_values[44].xyzw, r4_xyzw_1);
                float r1_w_2 = (unitWorldNormal_y_1 * unitWorldNormal_y_1);
                float r1_w_3 = mad(unitWorldNormal_x_3, unitWorldNormal_x_3, -r1_w_2);
                float4 r3_xyzw_12 = (float4(r3_x_11, r3_y_12, r3_z_11, r3_x_11) + (mad(cb2_values[45].xyzx, r1_w_3.xxxx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1))).xyzx);
                float r3_x_12 = r3_xyzw_12.x;
                float r3_y_13 = r3_xyzw_12.y;
                float r3_z_12 = r3_xyzw_12.z;
                float4 r1_xyzw_5 = ((saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), float4(r2_x_3, r2_y_1, r2_z_1, r2_x_3)))).xxxx * _LightColor0.xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_2 = r1_xyzw_5.y;
                float r1_z_2 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = mad(float4(r1_x_5, r1_y_2, r1_z_2, r1_x_5), r2_w_5.xxxx, float4(r3_x_12, r3_y_13, r3_z_12, r3_x_12));
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_3 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                float r1_w_4 = (i.texcoord3.x / cb1_values[5].y);
                float r1_w_5 = (-r1_w_4 + 1);
                float r1_w_6 = (r1_w_5 * cb1_values[5].z);
                float r1_w_7 = max(r1_w_6, 0);
                float r1_w_8 = saturate(mad(r1_w_7, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r1_w_8.xxxx, (mad(r0_xyzw_2.xyzx, float4(r1_x_6, r1_y_3, r1_z_3, r1_x_6), -cb3_values[0].xyzx)).xyzx, cb3_values[0].xyzx)).xyz;
                o.sv_Target0.w = r0_xyzw_2.w;
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
                float4 unity_SHAr;
                float4 unity_SHAg;
                float4 unity_SHAb;
                float4 unity_SHBr;
                float4 unity_SHBg;
                float4 unity_SHBb;
                float4 unity_SHC;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[47];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[26];
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[12];
            };
            cbuffer cb5 : register(b5)
            {
                float4 cb5_values[2];
            };
            cbuffer cb6 : register(b6)
            {
                float4 cb6_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            Texture3D t2;
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
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program32Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program32Output
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
            program32Output frag(program32Input i)
            {
                program32Output o = (program32Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r0_xyzw_2 = (r0_xyzw_1 * _Color);
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float4 r2_xyzw_3 = ((rsqrt(dot(unity_ProbeVolumeParams.xyzx, unity_ProbeVolumeParams.xyzx))).xxxx * unity_ProbeVolumeParams.xyzx);
                float r2_x_3 = r2_xyzw_3.x;
                float r2_y_1 = r2_xyzw_3.y;
                float r2_z_1 = r2_xyzw_3.z;
                float r4_x_1 = cb4_values[9].z;
                float r4_y_1 = cb4_values[10].z;
                float r4_z_1 = cb4_values[11].z;
                float r2_w_1 = dot(((-i.texcoord2.xyzx + cb1_values[4].xyzx)).xyzx, float4(r4_x_1, r4_y_1, r4_z_1, r4_x_1));
                float3 r3_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = mad(cb3_values[25].w, (-r2_w_1 + sqrt(dot(r3_xyz_2.xyzx, r3_xyz_2.xyzx))), r2_w_1);
                float r2_w_3 = saturate(mad(r2_w_2, cb3_values[24].z, cb3_values[24].w));
                float r3_x_13;
                float r3_y_13;
                float r3_z_12;
                float r3_w_8;
                if (((cb6_values[0].x == 1)).x)
                {
                    float4 r3_xyzw_4 = (i.texcoord2.yyyy * cb6_values[2].xxyz);
                    float r3_y_4 = r3_xyzw_4.y;
                    float r3_z_4 = r3_xyzw_4.z;
                    float r3_w_2 = r3_xyzw_4.w;
                    float4 r3_xyzw_5 = mad(cb6_values[1].xxyz, i.texcoord2.xxxx, float4(r3_y_4, r3_y_4, r3_z_4, r3_w_2));
                    float r3_y_5 = r3_xyzw_5.y;
                    float r3_z_5 = r3_xyzw_5.z;
                    float r3_w_3 = r3_xyzw_5.w;
                    float4 r3_xyzw_6 = mad(cb6_values[3].xxyz, i.texcoord2.zzzz, float4(r3_y_5, r3_y_5, r3_z_5, r3_w_3));
                    float r3_y_6 = r3_xyzw_6.y;
                    float r3_z_6 = r3_xyzw_6.z;
                    float r3_w_4 = r3_xyzw_6.w;
                    float4 r3_xyzw_7 = (float4(r3_y_6, r3_y_6, r3_z_6, r3_w_4) + cb6_values[4].xxyz);
                    float r3_y_7 = r3_xyzw_7.y;
                    float r3_z_7 = r3_xyzw_7.z;
                    float r3_w_5 = r3_xyzw_7.w;
                    float4 r3_xyzw_9 = (((cb6_values[0].y == 1)).xxxx ? float4(r3_y_7, r3_z_7, r3_w_5, r3_y_7) : i.texcoord2.xyzx);
                    float r3_x_9 = r3_xyzw_9.x;
                    float r3_y_8 = r3_xyzw_9.y;
                    float r3_z_8 = r3_xyzw_9.z;
                    float4 r3_xyzw_10 = (float4(r3_x_9, r3_y_8, r3_z_8, r3_x_9) + -cb6_values[6].xyzx);
                    float r3_x_10 = r3_xyzw_10.x;
                    float r3_y_9 = r3_xyzw_10.y;
                    float r3_z_9 = r3_xyzw_10.z;
                    float r3_y_10 = ((float4(r3_x_10, r3_x_10, r3_y_9, r3_z_9) * cb6_values[5].xxyz)).y;
                    float r3_z_10 = ((float4(r3_x_10, r3_x_10, r3_y_9, r3_z_9) * cb6_values[5].xxyz)).z;
                    float r3_w_6 = ((float4(r3_x_10, r3_x_10, r3_y_9, r3_z_9) * cb6_values[5].xxyz)).w;
                    float r3_y_11 = mad(r3_y_10, 0.25, 0.75);
                    float r3_x_11 = max(r3_y_11, mad(cb6_values[0].z, 0.5, 0.75));
                    float4 r3_xyzw_12 = t2.Sample(sampler_linear_clamp, (float4(r3_x_11, r3_z_10, r3_w_6, r3_x_11)).xyz);
                    r3_x_13 = r3_xyzw_12.x;
                    r3_y_13 = r3_xyzw_12.y;
                    r3_z_12 = r3_xyzw_12.z;
                    r3_w_8 = r3_xyzw_12.w;
                }
                else
                {
                    float r3_x_7 = (float4(1, 1, 1, 1)).x;
                    float4 r3_xyzw_3 = float4(1, 1, 1, 1);
                    float r3_y_3 = r3_xyzw_3.y;
                    float r3_z_3 = r3_xyzw_3.z;
                    float r3_w_1 = r3_xyzw_3.w;
                    r3_x_13 = r3_x_7;
                    r3_y_13 = r3_y_3;
                    r3_z_12 = r3_z_3;
                    r3_w_8 = r3_w_1;
                }
                float4 r3_xyzw_14 = (i.texcoord5.xxyx / i.texcoord5.wwww);
                float r3_y_14 = r3_xyzw_14.y;
                float r3_z_13 = r3_xyzw_14.z;
                float4 r4_xyzw_4 = t1.Sample(sampler_linear_clamp1, (float4(r3_y_14, r3_z_13, r3_y_14, r3_y_14)).xy);
                float r2_w_4 = mad(r2_w_3, (saturate(dot(float4(r3_x_13, r3_y_13, r3_z_12, r3_w_8), cb2_values[46].xyzw)) + -r4_xyzw_4.x), r4_xyzw_4.x);
                float r1_w_1 = 1;
                float r3_x_16 = dot(cb2_values[39].xyzw, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r3_y_15 = dot(cb2_values[40].xyzw, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r3_z_14 = dot(cb2_values[41].xyzw, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float4 r4_xyzw_5 = (float4(unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1, unitWorldNormal_x_3) * float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1));
                float r5_x_1 = dot(cb2_values[42].xyzw, r4_xyzw_5);
                float r5_y_1 = dot(cb2_values[43].xyzw, r4_xyzw_5);
                float r5_z_1 = dot(cb2_values[44].xyzw, r4_xyzw_5);
                float r1_w_2 = (unitWorldNormal_y_1 * unitWorldNormal_y_1);
                float r1_w_3 = mad(unitWorldNormal_x_3, unitWorldNormal_x_3, -r1_w_2);
                float4 r4_xyzw_6 = mad(cb2_values[45].xyzx, r1_w_3.xxxx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1));
                float r4_x_6 = r4_xyzw_6.x;
                float r4_y_4 = r4_xyzw_6.y;
                float r4_z_4 = r4_xyzw_6.z;
                float4 r3_xyzw_17 = (float4(r3_x_16, r3_y_15, r3_z_14, r3_x_16) + float4(r4_x_6, r4_y_4, r4_z_4, r4_x_6));
                float r3_x_17 = r3_xyzw_17.x;
                float r3_y_16 = r3_xyzw_17.y;
                float r3_z_15 = r3_xyzw_17.z;
                float4 r1_xyzw_5 = ((saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), float4(r2_x_3, r2_y_1, r2_z_1, r2_x_3)))).xxxx * _LightColor0.xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_2 = r1_xyzw_5.y;
                float r1_z_2 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = mad(float4(r1_x_5, r1_y_2, r1_z_2, r1_x_5), r2_w_4.xxxx, float4(r3_x_17, r3_y_16, r3_z_15, r3_x_17));
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_3 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                float r1_w_4 = (i.texcoord3.x / cb1_values[5].y);
                float r1_w_5 = (-r1_w_4 + 1);
                float r1_w_6 = (r1_w_5 * cb1_values[5].z);
                float r1_w_7 = max(r1_w_6, 0);
                float r1_w_8 = saturate(mad(r1_w_7, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = (mad(r1_w_8.xxxx, (mad(r0_xyzw_2.xyzx, float4(r1_x_6, r1_y_3, r1_z_3, r1_x_6), -cb5_values[0].xyzx)).xyzx, cb5_values[0].xyzx)).xyz;
                o.sv_Target0.w = r0_xyzw_2.w;
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
                float4 unity_SHAr;
                float4 unity_SHAg;
                float4 unity_SHAb;
                float4 unity_SHBr;
                float4 unity_SHBg;
                float4 unity_SHBb;
                float4 unity_SHC;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[47];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture3D t1;
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
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program30Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program30Output
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
            program30Output frag(program30Input i)
            {
                program30Output o = (program30Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r0_xyzw_2 = (r0_xyzw_1 * _Color);
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float4 r2_xyzw_3 = ((rsqrt(dot(unity_ProbeVolumeParams.xyzx, unity_ProbeVolumeParams.xyzx))).xxxx * unity_ProbeVolumeParams.xyzx);
                float r2_x_3 = r2_xyzw_3.x;
                float r2_y_1 = r2_xyzw_3.y;
                float r2_z_1 = r2_xyzw_3.z;
                float r2_w_1 = (cb4_values[0].x == 1);
                float r3_x_10;
                float r3_y_11;
                float r3_z_10;
                float r3_w_4;
                if (r2_w_1)
                {
                    float r2_w_2 = (cb4_values[0].y == 1);
                    float3 r3_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord2.zzzz, (mad(cb4_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r3_xyzw_8 = (((((r2_w_2.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r2_w_3 = mad(r3_y_8, 0.25, 0.75);
                    float r3_y_9 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r3_x_8 = max(r2_w_3, r3_y_9);
                    float4 r3_xyzw_9 = t1.Sample(sampler_linear_clamp, (float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8)).xyz);
                    r3_x_10 = r3_xyzw_9.x;
                    r3_y_11 = r3_xyzw_9.y;
                    r3_z_10 = r3_xyzw_9.z;
                    r3_w_4 = r3_xyzw_9.w;
                }
                else
                {
                    float4 r3_xyzw_10 = float4(1, 1, 1, 1);
                    r3_x_10 = r3_xyzw_10.x;
                    r3_y_11 = r3_xyzw_10.y;
                    r3_z_10 = r3_xyzw_10.z;
                    r3_w_4 = r3_xyzw_10.w;
                }
                float r2_w_5 = saturate(dot(float4(r3_x_10, r3_y_11, r3_z_10, r3_w_4), cb2_values[46].xyzw));
                float r1_w_1 = 1;
                float r3_x_11 = dot(cb2_values[39].xyzw, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r3_y_12 = dot(cb2_values[40].xyzw, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r3_z_11 = dot(cb2_values[41].xyzw, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float4 r4_xyzw_1 = (float4(unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1, unitWorldNormal_x_3) * float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1));
                float r5_x_1 = dot(cb2_values[42].xyzw, r4_xyzw_1);
                float r5_y_1 = dot(cb2_values[43].xyzw, r4_xyzw_1);
                float r5_z_1 = dot(cb2_values[44].xyzw, r4_xyzw_1);
                float r1_w_2 = (unitWorldNormal_y_1 * unitWorldNormal_y_1);
                float r1_w_3 = mad(unitWorldNormal_x_3, unitWorldNormal_x_3, -r1_w_2);
                float4 r3_xyzw_12 = (float4(r3_x_11, r3_y_12, r3_z_11, r3_x_11) + (mad(cb2_values[45].xyzx, r1_w_3.xxxx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1))).xyzx);
                float r3_x_12 = r3_xyzw_12.x;
                float r3_y_13 = r3_xyzw_12.y;
                float r3_z_12 = r3_xyzw_12.z;
                float4 r1_xyzw_5 = ((saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), float4(r2_x_3, r2_y_1, r2_z_1, r2_x_3)))).xxxx * _LightColor0.xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_2 = r1_xyzw_5.y;
                float r1_z_2 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = mad(float4(r1_x_5, r1_y_2, r1_z_2, r1_x_5), r2_w_5.xxxx, float4(r3_x_12, r3_y_13, r3_z_12, r3_x_12));
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_3 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                float r1_w_4 = (i.texcoord3.x / cb1_values[5].y);
                float r1_w_5 = (-r1_w_4 + 1);
                float r1_w_6 = (r1_w_5 * cb1_values[5].z);
                float r1_w_7 = max(r1_w_6, 0);
                float r1_w_8 = saturate(mad(r1_w_7, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r1_w_8.xxxx, (mad(r0_xyzw_2.xyzx, float4(r1_x_6, r1_y_3, r1_z_3, r1_x_6), -cb3_values[0].xyzx)).xyzx, cb3_values[0].xyzx)).xyz;
                o.sv_Target0.w = r0_xyzw_2.w;
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
                float4 unity_SHAr;
                float4 unity_SHAg;
                float4 unity_SHAb;
                float4 unity_SHBr;
                float4 unity_SHBg;
                float4 unity_SHBb;
                float4 unity_SHC;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[5];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[47];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[26];
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[12];
            };
            cbuffer cb5 : register(b5)
            {
                float4 cb5_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            Texture3D t2;
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
                float4 texcoord5 : TEXCOORD5;
            };
            struct program29Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program29Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program9Output vert(program9Input i)
            {
                program9Output o = (program9Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r1_xyzw_3 = (float4(clipPos_xyzw_7.x, clipPos_xyzw_7.x, clipPos_xyzw_7.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_z_3 = r1_xyzw_3.z;
                float r1_w_4 = r1_xyzw_3.w;
                o.texcoord5.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord5.xy = ((r1_z_3.xxxx + float4(r1_x_3, r1_w_4, r1_x_3, r1_x_3))).xy;
                return o;
            }
            #pragma fragment frag
            program29Output frag(program29Input i)
            {
                program29Output o = (program29Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r0_xyzw_2 = (r0_xyzw_1 * _Color);
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float4 r2_xyzw_3 = ((rsqrt(dot(unity_ProbeVolumeParams.xyzx, unity_ProbeVolumeParams.xyzx))).xxxx * unity_ProbeVolumeParams.xyzx);
                float r2_x_3 = r2_xyzw_3.x;
                float r2_y_1 = r2_xyzw_3.y;
                float r2_z_1 = r2_xyzw_3.z;
                float r4_x_1 = cb4_values[9].z;
                float r4_y_1 = cb4_values[10].z;
                float r4_z_1 = cb4_values[11].z;
                float r2_w_1 = dot(((-i.texcoord2.xyzx + cb1_values[4].xyzx)).xyzx, float4(r4_x_1, r4_y_1, r4_z_1, r4_x_1));
                float3 r3_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = mad(cb3_values[25].w, (-r2_w_1 + sqrt(dot(r3_xyz_2.xyzx, r3_xyz_2.xyzx))), r2_w_1);
                float r2_w_3 = saturate(mad(r2_w_2, cb3_values[24].z, cb3_values[24].w));
                float r3_x_13;
                float r3_y_13;
                float r3_z_12;
                float r3_w_8;
                if (((cb5_values[0].x == 1)).x)
                {
                    float4 r3_xyzw_4 = (i.texcoord2.yyyy * cb5_values[2].xxyz);
                    float r3_y_4 = r3_xyzw_4.y;
                    float r3_z_4 = r3_xyzw_4.z;
                    float r3_w_2 = r3_xyzw_4.w;
                    float4 r3_xyzw_5 = mad(cb5_values[1].xxyz, i.texcoord2.xxxx, float4(r3_y_4, r3_y_4, r3_z_4, r3_w_2));
                    float r3_y_5 = r3_xyzw_5.y;
                    float r3_z_5 = r3_xyzw_5.z;
                    float r3_w_3 = r3_xyzw_5.w;
                    float4 r3_xyzw_6 = mad(cb5_values[3].xxyz, i.texcoord2.zzzz, float4(r3_y_5, r3_y_5, r3_z_5, r3_w_3));
                    float r3_y_6 = r3_xyzw_6.y;
                    float r3_z_6 = r3_xyzw_6.z;
                    float r3_w_4 = r3_xyzw_6.w;
                    float4 r3_xyzw_7 = (float4(r3_y_6, r3_y_6, r3_z_6, r3_w_4) + cb5_values[4].xxyz);
                    float r3_y_7 = r3_xyzw_7.y;
                    float r3_z_7 = r3_xyzw_7.z;
                    float r3_w_5 = r3_xyzw_7.w;
                    float4 r3_xyzw_9 = (((cb5_values[0].y == 1)).xxxx ? float4(r3_y_7, r3_z_7, r3_w_5, r3_y_7) : i.texcoord2.xyzx);
                    float r3_x_9 = r3_xyzw_9.x;
                    float r3_y_8 = r3_xyzw_9.y;
                    float r3_z_8 = r3_xyzw_9.z;
                    float4 r3_xyzw_10 = (float4(r3_x_9, r3_y_8, r3_z_8, r3_x_9) + -cb5_values[6].xyzx);
                    float r3_x_10 = r3_xyzw_10.x;
                    float r3_y_9 = r3_xyzw_10.y;
                    float r3_z_9 = r3_xyzw_10.z;
                    float r3_y_10 = ((float4(r3_x_10, r3_x_10, r3_y_9, r3_z_9) * cb5_values[5].xxyz)).y;
                    float r3_z_10 = ((float4(r3_x_10, r3_x_10, r3_y_9, r3_z_9) * cb5_values[5].xxyz)).z;
                    float r3_w_6 = ((float4(r3_x_10, r3_x_10, r3_y_9, r3_z_9) * cb5_values[5].xxyz)).w;
                    float r3_y_11 = mad(r3_y_10, 0.25, 0.75);
                    float r3_x_11 = max(r3_y_11, mad(cb5_values[0].z, 0.5, 0.75));
                    float4 r3_xyzw_12 = t2.Sample(sampler_linear_clamp, (float4(r3_x_11, r3_z_10, r3_w_6, r3_x_11)).xyz);
                    r3_x_13 = r3_xyzw_12.x;
                    r3_y_13 = r3_xyzw_12.y;
                    r3_z_12 = r3_xyzw_12.z;
                    r3_w_8 = r3_xyzw_12.w;
                }
                else
                {
                    float r3_x_7 = (float4(1, 1, 1, 1)).x;
                    float4 r3_xyzw_3 = float4(1, 1, 1, 1);
                    float r3_y_3 = r3_xyzw_3.y;
                    float r3_z_3 = r3_xyzw_3.z;
                    float r3_w_1 = r3_xyzw_3.w;
                    r3_x_13 = r3_x_7;
                    r3_y_13 = r3_y_3;
                    r3_z_12 = r3_z_3;
                    r3_w_8 = r3_w_1;
                }
                float4 r3_xyzw_14 = (i.texcoord5.xxyx / i.texcoord5.wwww);
                float r3_y_14 = r3_xyzw_14.y;
                float r3_z_13 = r3_xyzw_14.z;
                float4 r4_xyzw_4 = t1.Sample(sampler_linear_clamp1, (float4(r3_y_14, r3_z_13, r3_y_14, r3_y_14)).xy);
                float r2_w_4 = mad(r2_w_3, (saturate(dot(float4(r3_x_13, r3_y_13, r3_z_12, r3_w_8), cb2_values[46].xyzw)) + -r4_xyzw_4.x), r4_xyzw_4.x);
                float r1_w_1 = 1;
                float r3_x_16 = dot(cb2_values[39].xyzw, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r3_y_15 = dot(cb2_values[40].xyzw, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r3_z_14 = dot(cb2_values[41].xyzw, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float4 r4_xyzw_5 = (float4(unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1, unitWorldNormal_x_3) * float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1));
                float r5_x_1 = dot(cb2_values[42].xyzw, r4_xyzw_5);
                float r5_y_1 = dot(cb2_values[43].xyzw, r4_xyzw_5);
                float r5_z_1 = dot(cb2_values[44].xyzw, r4_xyzw_5);
                float r1_w_2 = (unitWorldNormal_y_1 * unitWorldNormal_y_1);
                float r1_w_3 = mad(unitWorldNormal_x_3, unitWorldNormal_x_3, -r1_w_2);
                float4 r4_xyzw_6 = mad(cb2_values[45].xyzx, r1_w_3.xxxx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1));
                float r4_x_6 = r4_xyzw_6.x;
                float r4_y_4 = r4_xyzw_6.y;
                float r4_z_4 = r4_xyzw_6.z;
                float4 r3_xyzw_17 = (float4(r3_x_16, r3_y_15, r3_z_14, r3_x_16) + float4(r4_x_6, r4_y_4, r4_z_4, r4_x_6));
                float r3_x_17 = r3_xyzw_17.x;
                float r3_y_16 = r3_xyzw_17.y;
                float r3_z_15 = r3_xyzw_17.z;
                float4 r1_xyzw_5 = ((saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), float4(r2_x_3, r2_y_1, r2_z_1, r2_x_3)))).xxxx * _LightColor0.xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_2 = r1_xyzw_5.y;
                float r1_z_2 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = mad(float4(r1_x_5, r1_y_2, r1_z_2, r1_x_5), r2_w_4.xxxx, float4(r3_x_17, r3_y_16, r3_z_15, r3_x_17));
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_3 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                o.sv_Target0.xyz = ((r0_xyzw_2.xyzx * float4(r1_x_6, r1_y_3, r1_z_3, r1_x_6))).xyz;
                o.sv_Target0.w = r0_xyzw_2.w;
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
                float4 unity_SHAr : packoffset(c39);
                float4 unity_SHAg : packoffset(c40);
                float4 unity_SHAb : packoffset(c41);
                float4 unity_SHBr : packoffset(c42);
                float4 unity_SHBg : packoffset(c43);
                float4 unity_SHBb : packoffset(c44);
                float4 unity_SHC : packoffset(c45);
                float4 unity_OcclusionMaskSelector : packoffset(c46);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[7];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[21];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture3D t1;
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
                float4 texcoord5 : TEXCOORD5;
            };
            struct program27Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program27Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program8Output vert(program8Input i)
            {
                program8Output o = (program8Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r1_xyzw_3 = (float4(clipPos_xyzw_7.x, clipPos_xyzw_7.x, clipPos_xyzw_7.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_z_3 = r1_xyzw_3.z;
                float r1_w_4 = r1_xyzw_3.w;
                o.texcoord5.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord5.xy = ((r1_z_3.xxxx + float4(r1_x_3, r1_w_4, r1_x_3, r1_x_3))).xy;
                return o;
            }
            #pragma fragment frag
            program27Output frag(program27Input i)
            {
                program27Output o = (program27Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r0_xyzw_2 = (r0_xyzw_1 * _Color);
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float4 lightDir_xyzw_3 = ((rsqrt(dot(unity_ObjectToWorld[0].xyzx, unity_ObjectToWorld[0].xyzx))).xxxx * unity_ObjectToWorld[0].xyzx);
                float lightDir_x_3 = lightDir_xyzw_3.x;
                float lightDir_y_1 = lightDir_xyzw_3.y;
                float lightDir_z_1 = lightDir_xyzw_3.z;
                float r2_w_1 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_11;
                float r3_z_10;
                float r3_w_4;
                if (r2_w_1)
                {
                    float r2_w_2 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r2_w_2.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r2_w_3 = mad(r3_y_8, 0.25, 0.75);
                    float r3_y_9 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r2_w_3, r3_y_9);
                    float4 r3_xyzw_9 = t1.Sample(sampler_linear_clamp, (float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8)).xyz);
                    r3_x_10 = r3_xyzw_9.x;
                    r3_y_11 = r3_xyzw_9.y;
                    r3_z_10 = r3_xyzw_9.z;
                    r3_w_4 = r3_xyzw_9.w;
                }
                else
                {
                    float4 r3_xyzw_10 = float4(1, 1, 1, 1);
                    r3_x_10 = r3_xyzw_10.x;
                    r3_y_11 = r3_xyzw_10.y;
                    r3_z_10 = r3_xyzw_10.z;
                    r3_w_4 = r3_xyzw_10.w;
                }
                float r2_w_5 = saturate(dot(float4(r3_x_10, r3_y_11, r3_z_10, r3_w_4), unity_OcclusionMaskSelector));
                float r1_w_1 = 1;
                float r3_x_11 = dot(unity_SHAr, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r3_y_12 = dot(unity_SHAg, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r3_z_11 = dot(unity_SHAb, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float4 r4_xyzw_1 = (float4(unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1, unitWorldNormal_x_3) * float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1));
                float r5_x_1 = dot(unity_SHBr, r4_xyzw_1);
                float r5_y_1 = dot(unity_SHBg, r4_xyzw_1);
                float r5_z_1 = dot(unity_SHBb, r4_xyzw_1);
                float r1_w_2 = (unitWorldNormal_y_1 * unitWorldNormal_y_1);
                float r1_w_3 = mad(unitWorldNormal_x_3, unitWorldNormal_x_3, -r1_w_2);
                float4 r3_xyzw_12 = (float4(r3_x_11, r3_y_12, r3_z_11, r3_x_11) + (mad(unity_SHC.xyzx, r1_w_3.xxxx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1))).xyzx);
                float r3_x_12 = r3_xyzw_12.x;
                float r3_y_13 = r3_xyzw_12.y;
                float r3_z_12 = r3_xyzw_12.z;
                float4 r1_xyzw_5 = ((saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), float4(lightDir_x_3, lightDir_y_1, lightDir_z_1, lightDir_x_3)))).xxxx * _LightColor0.xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_2 = r1_xyzw_5.y;
                float r1_z_2 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = mad(float4(r1_x_5, r1_y_2, r1_z_2, r1_x_5), r2_w_5.xxxx, float4(r3_x_12, r3_y_13, r3_z_12, r3_x_12));
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_3 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                o.sv_Target0.xyz = ((r0_xyzw_2.xyzx * float4(r1_x_6, r1_y_3, r1_z_3, r1_x_6))).xyz;
                o.sv_Target0.w = r0_xyzw_2.w;
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
                float4 unity_SHAr;
                float4 unity_SHAg;
                float4 unity_SHAb;
                float4 unity_SHBr;
                float4 unity_SHBg;
                float4 unity_SHBb;
                float4 unity_SHC;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[5];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[47];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[26];
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[12];
            };
            cbuffer cb5 : register(b5)
            {
                float4 cb5_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            Texture3D t2;
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
                float4 texcoord5 : TEXCOORD5;
            };
            struct program28Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program28Output
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
            program28Output frag(program28Input i)
            {
                program28Output o = (program28Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r0_xyzw_2 = (r0_xyzw_1 * _Color);
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float4 r2_xyzw_3 = ((rsqrt(dot(unity_ProbeVolumeParams.xyzx, unity_ProbeVolumeParams.xyzx))).xxxx * unity_ProbeVolumeParams.xyzx);
                float r2_x_3 = r2_xyzw_3.x;
                float r2_y_1 = r2_xyzw_3.y;
                float r2_z_1 = r2_xyzw_3.z;
                float r4_x_1 = cb4_values[9].z;
                float r4_y_1 = cb4_values[10].z;
                float r4_z_1 = cb4_values[11].z;
                float r2_w_1 = dot(((-i.texcoord2.xyzx + cb1_values[4].xyzx)).xyzx, float4(r4_x_1, r4_y_1, r4_z_1, r4_x_1));
                float3 r3_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = mad(cb3_values[25].w, (-r2_w_1 + sqrt(dot(r3_xyz_2.xyzx, r3_xyz_2.xyzx))), r2_w_1);
                float r2_w_3 = saturate(mad(r2_w_2, cb3_values[24].z, cb3_values[24].w));
                float r3_x_13;
                float r3_y_13;
                float r3_z_12;
                float r3_w_8;
                if (((cb5_values[0].x == 1)).x)
                {
                    float4 r3_xyzw_4 = (i.texcoord2.yyyy * cb5_values[2].xxyz);
                    float r3_y_4 = r3_xyzw_4.y;
                    float r3_z_4 = r3_xyzw_4.z;
                    float r3_w_2 = r3_xyzw_4.w;
                    float4 r3_xyzw_5 = mad(cb5_values[1].xxyz, i.texcoord2.xxxx, float4(r3_y_4, r3_y_4, r3_z_4, r3_w_2));
                    float r3_y_5 = r3_xyzw_5.y;
                    float r3_z_5 = r3_xyzw_5.z;
                    float r3_w_3 = r3_xyzw_5.w;
                    float4 r3_xyzw_6 = mad(cb5_values[3].xxyz, i.texcoord2.zzzz, float4(r3_y_5, r3_y_5, r3_z_5, r3_w_3));
                    float r3_y_6 = r3_xyzw_6.y;
                    float r3_z_6 = r3_xyzw_6.z;
                    float r3_w_4 = r3_xyzw_6.w;
                    float4 r3_xyzw_7 = (float4(r3_y_6, r3_y_6, r3_z_6, r3_w_4) + cb5_values[4].xxyz);
                    float r3_y_7 = r3_xyzw_7.y;
                    float r3_z_7 = r3_xyzw_7.z;
                    float r3_w_5 = r3_xyzw_7.w;
                    float4 r3_xyzw_9 = (((cb5_values[0].y == 1)).xxxx ? float4(r3_y_7, r3_z_7, r3_w_5, r3_y_7) : i.texcoord2.xyzx);
                    float r3_x_9 = r3_xyzw_9.x;
                    float r3_y_8 = r3_xyzw_9.y;
                    float r3_z_8 = r3_xyzw_9.z;
                    float4 r3_xyzw_10 = (float4(r3_x_9, r3_y_8, r3_z_8, r3_x_9) + -cb5_values[6].xyzx);
                    float r3_x_10 = r3_xyzw_10.x;
                    float r3_y_9 = r3_xyzw_10.y;
                    float r3_z_9 = r3_xyzw_10.z;
                    float r3_y_10 = ((float4(r3_x_10, r3_x_10, r3_y_9, r3_z_9) * cb5_values[5].xxyz)).y;
                    float r3_z_10 = ((float4(r3_x_10, r3_x_10, r3_y_9, r3_z_9) * cb5_values[5].xxyz)).z;
                    float r3_w_6 = ((float4(r3_x_10, r3_x_10, r3_y_9, r3_z_9) * cb5_values[5].xxyz)).w;
                    float r3_y_11 = mad(r3_y_10, 0.25, 0.75);
                    float r3_x_11 = max(r3_y_11, mad(cb5_values[0].z, 0.5, 0.75));
                    float4 r3_xyzw_12 = t2.Sample(sampler_linear_clamp, (float4(r3_x_11, r3_z_10, r3_w_6, r3_x_11)).xyz);
                    r3_x_13 = r3_xyzw_12.x;
                    r3_y_13 = r3_xyzw_12.y;
                    r3_z_12 = r3_xyzw_12.z;
                    r3_w_8 = r3_xyzw_12.w;
                }
                else
                {
                    float r3_x_7 = (float4(1, 1, 1, 1)).x;
                    float4 r3_xyzw_3 = float4(1, 1, 1, 1);
                    float r3_y_3 = r3_xyzw_3.y;
                    float r3_z_3 = r3_xyzw_3.z;
                    float r3_w_1 = r3_xyzw_3.w;
                    r3_x_13 = r3_x_7;
                    r3_y_13 = r3_y_3;
                    r3_z_12 = r3_z_3;
                    r3_w_8 = r3_w_1;
                }
                float4 r3_xyzw_14 = (i.texcoord5.xxyx / i.texcoord5.wwww);
                float r3_y_14 = r3_xyzw_14.y;
                float r3_z_13 = r3_xyzw_14.z;
                float4 r4_xyzw_4 = t1.Sample(sampler_linear_clamp1, (float4(r3_y_14, r3_z_13, r3_y_14, r3_y_14)).xy);
                float r2_w_4 = mad(r2_w_3, (saturate(dot(float4(r3_x_13, r3_y_13, r3_z_12, r3_w_8), cb2_values[46].xyzw)) + -r4_xyzw_4.x), r4_xyzw_4.x);
                float r1_w_1 = 1;
                float r3_x_16 = dot(cb2_values[39].xyzw, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r3_y_15 = dot(cb2_values[40].xyzw, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r3_z_14 = dot(cb2_values[41].xyzw, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float4 r4_xyzw_5 = (float4(unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1, unitWorldNormal_x_3) * float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1));
                float r5_x_1 = dot(cb2_values[42].xyzw, r4_xyzw_5);
                float r5_y_1 = dot(cb2_values[43].xyzw, r4_xyzw_5);
                float r5_z_1 = dot(cb2_values[44].xyzw, r4_xyzw_5);
                float r1_w_2 = (unitWorldNormal_y_1 * unitWorldNormal_y_1);
                float r1_w_3 = mad(unitWorldNormal_x_3, unitWorldNormal_x_3, -r1_w_2);
                float4 r4_xyzw_6 = mad(cb2_values[45].xyzx, r1_w_3.xxxx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1));
                float r4_x_6 = r4_xyzw_6.x;
                float r4_y_4 = r4_xyzw_6.y;
                float r4_z_4 = r4_xyzw_6.z;
                float4 r3_xyzw_17 = (float4(r3_x_16, r3_y_15, r3_z_14, r3_x_16) + float4(r4_x_6, r4_y_4, r4_z_4, r4_x_6));
                float r3_x_17 = r3_xyzw_17.x;
                float r3_y_16 = r3_xyzw_17.y;
                float r3_z_15 = r3_xyzw_17.z;
                float4 r1_xyzw_5 = ((saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), float4(r2_x_3, r2_y_1, r2_z_1, r2_x_3)))).xxxx * _LightColor0.xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_2 = r1_xyzw_5.y;
                float r1_z_2 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = mad(float4(r1_x_5, r1_y_2, r1_z_2, r1_x_5), r2_w_4.xxxx, float4(r3_x_17, r3_y_16, r3_z_15, r3_x_17));
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_3 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                o.sv_Target0.xyz = ((r0_xyzw_2.xyzx * float4(r1_x_6, r1_y_3, r1_z_3, r1_x_6))).xyz;
                o.sv_Target0.w = r0_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Diffuse"
}
