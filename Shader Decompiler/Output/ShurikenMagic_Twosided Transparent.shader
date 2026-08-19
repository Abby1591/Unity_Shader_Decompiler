Shader "ShurikenMagic/Twosided Transparent"
{
    Properties
    {
        _Color ("Main Color", Color) = (1,1,1,1)
        _MainTex ("Base (RGB) Trans (A)", 2D) = "" {}
    }
    SubShader
    {
        Tags { "IGNOREPROJECTOR"="true" "QUEUE"="Transparent" "RenderType"="Transparent" }
        LOD 200
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDBASE" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcColor
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[6];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
            struct program6Input
            {
                float4 position0 : POSITION0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program6Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program14Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program14Output
            {
                float4 sv_Target0 : SV_Target0;
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
            program14Output frag(program14Input i)
            {
                program14Output o = (program14Output)0;
                float4 r0_xyzw_1 = t0.Sample(s1, i.texcoord0.xyxx);
                float4 r0_xyzw_2 = (r0_xyzw_1 * _Color);
                float r1_x_8;
                float r1_y_11;
                float r1_z_10;
                float r1_w_8;
                if ((unity_ProbeVolumeParams.x == 1))
                {
                    float3 r1_yzw_2 = ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xxyz)).yzw;
                    float3 r1_yzw_3 = (mad(unity_ProbeVolumeWorldToObject[0].xxyz, i.texcoord2.xxxx, r1_yzw_2.xxyz)).yzw;
                    float3 r1_yzw_4 = (mad(unity_ProbeVolumeWorldToObject[2].xxyz, i.texcoord2.zzzz, r1_yzw_3.xxyz)).yzw;
                    float3 r1_yzw_5 = ((r1_yzw_4.xxyz + unity_ProbeVolumeWorldToObject[3].xxyz)).yzw;
                    float4 unity_ProbeVolumeParamsSelect_xyzw_4 = (((unity_ProbeVolumeParams.y == 1)).xxxx ? r1_yzw_5.xyzx : i.texcoord2.xyzx);
                    float unity_ProbeVolumeParamsSelect_x_4 = unity_ProbeVolumeParamsSelect_xyzw_4.x;
                    float unity_ProbeVolumeParamsSelect_y_6 = unity_ProbeVolumeParamsSelect_xyzw_4.y;
                    float unity_ProbeVolumeParamsSelect_z_6 = unity_ProbeVolumeParamsSelect_xyzw_4.z;
                    float4 r1_xyzw_5 = (float4(unity_ProbeVolumeParamsSelect_x_4, unity_ProbeVolumeParamsSelect_y_6, unity_ProbeVolumeParamsSelect_z_6, unity_ProbeVolumeParamsSelect_x_4) + -unity_ProbeVolumeMin.xyzx);
                    float r1_x_5 = r1_xyzw_5.x;
                    float r1_y_7 = r1_xyzw_5.y;
                    float r1_z_7 = r1_xyzw_5.z;
                    float4 r1_xyzw_8 = (float4(r1_x_5, r1_x_5, r1_y_7, r1_z_7) * unity_ProbeVolumeSizeInv.xxyz);
                    float r1_y_8 = r1_xyzw_8.y;
                    float r1_z_8 = r1_xyzw_8.z;
                    float r1_w_6 = r1_xyzw_8.w;
                    float r1_y_9 = mad(r1_y_8, 0.25, 0.75);
                    float r1_x_6 = max(r1_y_9, mad(unity_ProbeVolumeParams.z, 0.5, 0.75));
                    float4 r1_xyzw_7 = t1.Sample(s0, float4(r1_x_6, r1_z_8, r1_w_6, r1_x_6));
                    r1_x_8 = r1_xyzw_7.x;
                    r1_y_11 = r1_xyzw_7.y;
                    r1_z_10 = r1_xyzw_7.z;
                    r1_w_8 = r1_xyzw_7.w;
                }
                else
                {
                    float4 r1_xyzw_2 = float4(1, 1, 1, 1);
                    r1_x_8 = r1_xyzw_2.x;
                    r1_y_11 = r1_xyzw_2.y;
                    r1_z_10 = r1_xyzw_2.z;
                    r1_w_8 = r1_xyzw_2.w;
                }
                float4 r1_xyzw_10 = ((dot(float4(r1_x_8, r1_y_11, r1_z_10, r1_w_8), unity_OcclusionMaskSelector)).xxxx * _LightColor0.xyzx);
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_12 = r1_xyzw_10.y;
                float r1_z_11 = r1_xyzw_10.z;
                float r1_w_9 = dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx);
                float r1_w_10 = max(r1_w_9, 0);
                o.sv_Target0.xyz = ((r1_w_10.xxxx * ((r0_xyzw_2.xyzx * float4(r1_x_10, r1_y_12, r1_z_11, r1_x_10))).xyzx)).xyz;
                o.sv_Target0.w = r0_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDBASE" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcColor
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[6];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[46];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[7];
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[21];
            };
            cbuffer cb5 : register(b5)
            {
                float4 cb5_values[2];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
            struct program11Input
            {
                float4 position0 : POSITION0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program11Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program17Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program17Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program11Output vert(program11Input i)
            {
                program11Output o = (program11Output)0;
                float4 worldPos_xyzw_2 = mad(cb3_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb3_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb3_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb3_values[3].xyzw);
                float3 r0_xyz_4 = (mad(cb3_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb4_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb4_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb4_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb4_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = clipPos_xyzw_2;
                float r0_w_4 = (clipPos_xyzw_2.z / unity_WorldToObject[1].y);
                float r0_w_5 = (-r0_w_4 + 1);
                float r0_w_6 = (r0_w_5 * unity_WorldToObject[1].z);
                float r0_w_7 = max(r0_w_6, 0);
                o.texcoord4.x = mad(r0_w_7, cb5_values[1].z, cb5_values[1].w);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_3 = dot(i.normal0.xyzx, cb3_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb3_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb3_values[6].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r0_w_9 = rsqrt(r0_w_8);
                float3 unitWorldNormal_xyz_4 = ((r0_w_9.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord1.xyz = (unitWorldNormal_xyz_4.xyzx).xyz;
                o.texcoord2.xyz = (r0_xyz_4.xyzx).xyz;
                float r0_w_10 = (unitWorldNormal_xyz_4.y * unitWorldNormal_xyz_4.y);
                float r0_w_11 = mad(unitWorldNormal_xyz_4.x, unitWorldNormal_xyz_4.x, -r0_w_10);
                float4 r2_xyzw_4 = (unitWorldNormal_xyz_4.yzzx * unitWorldNormal_xyz_4.xyzz);
                float r3_x_1 = dot(cb2_values[42].xyzw, r2_xyzw_4);
                float r3_y_1 = dot(cb2_values[43].xyzw, r2_xyzw_4);
                float r3_z_1 = dot(cb2_values[44].xyzw, r2_xyzw_4);
                float r1_w_3 = 1;
                float r3_x_2 = dot(cb2_values[39].xyzw, float4(unitWorldNormal_xyz_4.x, unitWorldNormal_xyz_4.y, unitWorldNormal_xyz_4.z, r1_w_3));
                float r3_y_2 = dot(cb2_values[40].xyzw, float4(unitWorldNormal_xyz_4.x, unitWorldNormal_xyz_4.y, unitWorldNormal_xyz_4.z, r1_w_3));
                float r3_z_2 = dot(cb2_values[41].xyzw, float4(unitWorldNormal_xyz_4.x, unitWorldNormal_xyz_4.y, unitWorldNormal_xyz_4.z, r1_w_3));
                float3 r2_xyz_9 = (((log2((max((((mad(cb2_values[45].xyzx, r0_w_11.xxxx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1))).xyzx + float4(r3_x_2, r3_y_2, r3_z_2, r3_x_2))).xyzx, float4(0, 0, 0, 0))).xyzx)).xyzx * float4(0.41666666, 0.41666666, 0.41666666, 0))).xyz;
                float4 r3_xyzw_3 = (-r0_xyz_4.yyyy + cb2_values[4].xyzw);
                float4 r3_xyzw_4 = (r3_xyzw_3 * r3_xyzw_3);
                float4 r5_xyzw_1 = (-r0_xyz_4.xxxx + cb2_values[3].xyzw);
                float4 r0_xyzw_5 = (-r0_xyz_4.zzzz + cb2_values[5].xyzw);
                float4 r1_xyzw_5 = mad(r0_xyzw_5, unitWorldNormal_xyz_4.zzzz, mad(r5_xyzw_1, unitWorldNormal_xyz_4.xxxx, (unitWorldNormal_xyz_4.yyyy * r3_xyzw_3)));
                float4 r3_xyzw_5 = mad(r5_xyzw_1, r5_xyzw_1, r3_xyzw_4);
                float4 r0_xyzw_6 = mad(r0_xyzw_5, r0_xyzw_5, r3_xyzw_5);
                float4 r0_xyzw_7 = max(r0_xyzw_6, float4(1E-06, 1E-06, 1E-06, 1E-06));
                float4 r3_xyzw_6 = rsqrt(r0_xyzw_7);
                float4 r0_xyzw_8 = mad(r0_xyzw_7, cb2_values[6].xyzw, float4(1, 1, 1, 1));
                float4 r0_xyzw_9 = (float4(1, 1, 1, 1) / r0_xyzw_8);
                float4 r1_xyzw_6 = (r1_xyzw_5 * r3_xyzw_6);
                float4 r1_xyzw_7 = max(r1_xyzw_6, float4(0, 0, 0, 0));
                float4 r0_xyzw_10 = (r0_xyzw_9 * r1_xyzw_7);
                float3 r0_xyz_12 = (mad(cb2_values[10].xyzx, r0_xyzw_10.wwww, (mad(cb2_values[9].xyzx, r0_xyzw_10.zzzz, (mad(cb2_values[7].xyzx, r0_xyzw_10.xxxx, ((r0_xyzw_10.yyyy * cb2_values[8].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord3.xyz = (((max((mad((exp2(r2_xyz_9.xyzx)).xyzx, float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0))).xyzx, float4(0, 0, 0, 0))).xyzx + r0_xyz_12.xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program17Output frag(program17Input i)
            {
                program17Output o = (program17Output)0;
                float4 r0_xyzw_1 = t0.Sample(s1, i.texcoord0.xyxx);
                float4 r0_xyzw_2 = (r0_xyzw_1 * _Color);
                float r1_x_8;
                float r1_y_11;
                float r1_z_10;
                float r1_w_8;
                if ((cb3_values[0].x == 1))
                {
                    float3 r1_yzw_2 = ((i.texcoord2.yyyy * cb3_values[2].xxyz)).yzw;
                    float3 r1_yzw_3 = (mad(cb3_values[1].xxyz, i.texcoord2.xxxx, r1_yzw_2.xxyz)).yzw;
                    float3 r1_yzw_4 = (mad(cb3_values[3].xxyz, i.texcoord2.zzzz, r1_yzw_3.xxyz)).yzw;
                    float3 r1_yzw_5 = ((r1_yzw_4.xxyz + cb3_values[4].xxyz)).yzw;
                    float4 r1_xyzw_4 = (((cb3_values[0].y == 1)).xxxx ? r1_yzw_5.xyzx : i.texcoord2.xyzx);
                    float r1_x_4 = r1_xyzw_4.x;
                    float r1_y_6 = r1_xyzw_4.y;
                    float r1_z_6 = r1_xyzw_4.z;
                    float4 r1_xyzw_5 = (float4(r1_x_4, r1_y_6, r1_z_6, r1_x_4) + -cb3_values[6].xyzx);
                    float r1_x_5 = r1_xyzw_5.x;
                    float r1_y_7 = r1_xyzw_5.y;
                    float r1_z_7 = r1_xyzw_5.z;
                    float4 r1_xyzw_8 = (float4(r1_x_5, r1_x_5, r1_y_7, r1_z_7) * cb3_values[5].xxyz);
                    float r1_y_8 = r1_xyzw_8.y;
                    float r1_z_8 = r1_xyzw_8.z;
                    float r1_w_6 = r1_xyzw_8.w;
                    float r1_y_9 = mad(r1_y_8, 0.25, 0.75);
                    float r1_x_6 = max(r1_y_9, mad(cb3_values[0].z, 0.5, 0.75));
                    float4 r1_xyzw_7 = t1.Sample(s0, float4(r1_x_6, r1_z_8, r1_w_6, r1_x_6));
                    r1_x_8 = r1_xyzw_7.x;
                    r1_y_11 = r1_xyzw_7.y;
                    r1_z_10 = r1_xyzw_7.z;
                    r1_w_8 = r1_xyzw_7.w;
                }
                else
                {
                    float4 r1_xyzw_2 = float4(1, 1, 1, 1);
                    r1_x_8 = r1_xyzw_2.x;
                    r1_y_11 = r1_xyzw_2.y;
                    r1_z_10 = r1_xyzw_2.z;
                    r1_w_8 = r1_xyzw_2.w;
                }
                float4 r1_xyzw_10 = ((dot(float4(r1_x_8, r1_y_11, r1_z_10, r1_w_8), unity_OcclusionMaskSelector)).xxxx * _LightColor0.xyzx);
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_12 = r1_xyzw_10.y;
                float r1_z_11 = r1_xyzw_10.z;
                float r1_w_9 = dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx);
                float r1_w_10 = max(r1_w_9, 0);
                float4 r1_xyzw_11 = (r0_xyzw_2.xyzx * float4(r1_x_10, r1_y_12, r1_z_11, r1_x_10));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_13 = r1_xyzw_11.y;
                float r1_z_12 = r1_xyzw_11.z;
                float TEXCOORD0_x_12 = i.texcoord4.x;
                o.sv_Target0.xyz = (mad(TEXCOORD0_x_12.xxxx, (((mad(float4(r1_x_11, r1_y_13, r1_z_12, r1_x_11), r1_w_10.xxxx, ((r0_xyzw_2.xyzx * i.texcoord3.xyzx)).xyzx)).xyzx + -unity_ProbeVolumeParams.xyzx)).xyzx, unity_ProbeVolumeParams.xyzx)).xyz;
                o.sv_Target0.w = r0_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDBASE" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcColor
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[6];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[46];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[7];
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[21];
            };
            cbuffer cb5 : register(b5)
            {
                float4 cb5_values[2];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
            struct program10Input
            {
                float4 position0 : POSITION0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program10Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program17Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program17Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program10Output vert(program10Input i)
            {
                program10Output o = (program10Output)0;
                float4 worldPos_xyzw_2 = mad(cb3_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb3_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb3_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb3_values[3].xyzw);
                o.texcoord2.xyz = (mad(cb3_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb4_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb4_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb4_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb4_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = clipPos_xyzw_7;
                o.texcoord4.x = mad(max((((clipPos_xyzw_7.z / unity_WorldToObject[1].y) + 1) * unity_WorldToObject[1].z), 0), cb5_values[1].z, cb5_values[1].w);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_12 = dot(i.normal0.xyzx, cb3_values[4].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, cb3_values[5].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, cb3_values[6].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12), float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12));
                float r0_w_9 = rsqrt(r0_w_8);
                float4 unitWorldNormal_xyzw_13 = (r0_w_9.xxxx * float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12));
                float unitWorldNormal_x_13 = unitWorldNormal_xyzw_13.x;
                float unitWorldNormal_y_9 = unitWorldNormal_xyzw_13.y;
                float unitWorldNormal_z_9 = unitWorldNormal_xyzw_13.z;
                o.texcoord1.xyz = (float4(unitWorldNormal_x_13, unitWorldNormal_y_9, unitWorldNormal_z_9, unitWorldNormal_x_13)).xyz;
                float4 r2_xyzw_1 = (float4(unitWorldNormal_y_9, unitWorldNormal_z_9, unitWorldNormal_z_9, unitWorldNormal_x_13) * float4(unitWorldNormal_x_13, unitWorldNormal_y_9, unitWorldNormal_z_9, unitWorldNormal_z_9));
                float r3_x_1 = dot(cb2_values[42].xyzw, r2_xyzw_1);
                float r3_y_1 = dot(cb2_values[43].xyzw, r2_xyzw_1);
                float r3_z_1 = dot(cb2_values[44].xyzw, r2_xyzw_1);
                float4 r1_xyzw_4 = mad(cb2_values[45].xyzx, (mad(unitWorldNormal_x_13, unitWorldNormal_x_13, (unitWorldNormal_y_9 * unitWorldNormal_y_9))).xxxx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_2 = r1_xyzw_4.y;
                float r1_z_2 = r1_xyzw_4.z;
                float r0_w_10 = 1;
                float r2_x_2 = dot(cb2_values[39].xyzw, float4(unitWorldNormal_x_13, unitWorldNormal_y_9, unitWorldNormal_z_9, r0_w_10));
                float r2_y_2 = dot(cb2_values[40].xyzw, float4(unitWorldNormal_x_13, unitWorldNormal_y_9, unitWorldNormal_z_9, r0_w_10));
                float r2_z_2 = dot(cb2_values[41].xyzw, float4(unitWorldNormal_x_13, unitWorldNormal_y_9, unitWorldNormal_z_9, r0_w_10));
                float4 r0_xyzw_14 = (float4(r1_x_4, r1_y_2, r1_z_2, r1_x_4) + float4(r2_x_2, r2_y_2, r2_z_2, r2_x_2));
                float r0_x_14 = r0_xyzw_14.x;
                float r0_y_10 = r0_xyzw_14.y;
                float r0_z_10 = r0_xyzw_14.z;
                float4 r0_xyzw_15 = max(float4(r0_x_14, r0_y_10, r0_z_10, r0_x_14), float4(0, 0, 0, 0));
                float r0_x_15 = r0_xyzw_15.x;
                float r0_y_11 = r0_xyzw_15.y;
                float r0_z_11 = r0_xyzw_15.z;
                float4 r0_xyzw_16 = log2(float4(r0_x_15, r0_y_11, r0_z_11, r0_x_15));
                float r0_x_16 = r0_xyzw_16.x;
                float r0_y_12 = r0_xyzw_16.y;
                float r0_z_12 = r0_xyzw_16.z;
                float4 r0_xyzw_17 = (float4(r0_x_16, r0_y_12, r0_z_12, r0_x_16) * float4(0.41666666, 0.41666666, 0.41666666, 0));
                float r0_x_17 = r0_xyzw_17.x;
                float r0_y_13 = r0_xyzw_17.y;
                float r0_z_13 = r0_xyzw_17.z;
                float4 r0_xyzw_18 = exp2(float4(r0_x_17, r0_y_13, r0_z_13, r0_x_17));
                float r0_x_18 = r0_xyzw_18.x;
                float r0_y_14 = r0_xyzw_18.y;
                float r0_z_14 = r0_xyzw_18.z;
                float4 r0_xyzw_19 = mad(float4(r0_x_18, r0_y_14, r0_z_14, r0_x_18), float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0));
                float r0_x_19 = r0_xyzw_19.x;
                float r0_y_15 = r0_xyzw_19.y;
                float r0_z_15 = r0_xyzw_19.z;
                o.texcoord3.xyz = (max(float4(r0_x_19, r0_y_15, r0_z_15, r0_x_19), float4(0, 0, 0, 0))).xyz;
                return o;
            }
            #pragma fragment frag
            program17Output frag(program17Input i)
            {
                program17Output o = (program17Output)0;
                float4 r0_xyzw_1 = t0.Sample(s1, i.texcoord0.xyxx);
                float4 r0_xyzw_2 = (r0_xyzw_1 * _Color);
                float r1_x_8;
                float r1_y_11;
                float r1_z_10;
                float r1_w_8;
                if ((cb3_values[0].x == 1))
                {
                    float3 r1_yzw_2 = ((i.texcoord2.yyyy * cb3_values[2].xxyz)).yzw;
                    float3 r1_yzw_3 = (mad(cb3_values[1].xxyz, i.texcoord2.xxxx, r1_yzw_2.xxyz)).yzw;
                    float3 r1_yzw_4 = (mad(cb3_values[3].xxyz, i.texcoord2.zzzz, r1_yzw_3.xxyz)).yzw;
                    float3 r1_yzw_5 = ((r1_yzw_4.xxyz + cb3_values[4].xxyz)).yzw;
                    float4 r1_xyzw_4 = (((cb3_values[0].y == 1)).xxxx ? r1_yzw_5.xyzx : i.texcoord2.xyzx);
                    float r1_x_4 = r1_xyzw_4.x;
                    float r1_y_6 = r1_xyzw_4.y;
                    float r1_z_6 = r1_xyzw_4.z;
                    float4 r1_xyzw_5 = (float4(r1_x_4, r1_y_6, r1_z_6, r1_x_4) + -cb3_values[6].xyzx);
                    float r1_x_5 = r1_xyzw_5.x;
                    float r1_y_7 = r1_xyzw_5.y;
                    float r1_z_7 = r1_xyzw_5.z;
                    float4 r1_xyzw_8 = (float4(r1_x_5, r1_x_5, r1_y_7, r1_z_7) * cb3_values[5].xxyz);
                    float r1_y_8 = r1_xyzw_8.y;
                    float r1_z_8 = r1_xyzw_8.z;
                    float r1_w_6 = r1_xyzw_8.w;
                    float r1_y_9 = mad(r1_y_8, 0.25, 0.75);
                    float r1_x_6 = max(r1_y_9, mad(cb3_values[0].z, 0.5, 0.75));
                    float4 r1_xyzw_7 = t1.Sample(s0, float4(r1_x_6, r1_z_8, r1_w_6, r1_x_6));
                    r1_x_8 = r1_xyzw_7.x;
                    r1_y_11 = r1_xyzw_7.y;
                    r1_z_10 = r1_xyzw_7.z;
                    r1_w_8 = r1_xyzw_7.w;
                }
                else
                {
                    float4 r1_xyzw_2 = float4(1, 1, 1, 1);
                    r1_x_8 = r1_xyzw_2.x;
                    r1_y_11 = r1_xyzw_2.y;
                    r1_z_10 = r1_xyzw_2.z;
                    r1_w_8 = r1_xyzw_2.w;
                }
                float4 r1_xyzw_10 = ((dot(float4(r1_x_8, r1_y_11, r1_z_10, r1_w_8), unity_OcclusionMaskSelector)).xxxx * _LightColor0.xyzx);
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_12 = r1_xyzw_10.y;
                float r1_z_11 = r1_xyzw_10.z;
                float r1_w_9 = dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx);
                float r1_w_10 = max(r1_w_9, 0);
                float4 r1_xyzw_11 = (r0_xyzw_2.xyzx * float4(r1_x_10, r1_y_12, r1_z_11, r1_x_10));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_13 = r1_xyzw_11.y;
                float r1_z_12 = r1_xyzw_11.z;
                float TEXCOORD0_x_12 = i.texcoord4.x;
                o.sv_Target0.xyz = (mad(TEXCOORD0_x_12.xxxx, (((mad(float4(r1_x_11, r1_y_13, r1_z_12, r1_x_11), r1_w_10.xxxx, ((r0_xyzw_2.xyzx * i.texcoord3.xyzx)).xyzx)).xyzx + -unity_ProbeVolumeParams.xyzx)).xyzx, unity_ProbeVolumeParams.xyzx)).xyz;
                o.sv_Target0.w = r0_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDBASE" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcColor
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[6];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityPerFrame : register(b2)
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
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[2];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
            struct program9Input
            {
                float4 position0 : POSITION0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program9Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program17Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program17Output
            {
                float4 sv_Target0 : SV_Target0;
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
                o.sv_Position0.xyzw = clipPos_xyzw_7;
                o.texcoord4.x = mad(max((((clipPos_xyzw_7.z / unity_WorldToObject[1].y) + 1) * unity_WorldToObject[1].z), 0), cb4_values[1].z, cb4_values[1].w);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_12 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12), float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12))).xyz;
                return o;
            }
            #pragma fragment frag
            program17Output frag(program17Input i)
            {
                program17Output o = (program17Output)0;
                float4 r0_xyzw_1 = t0.Sample(s1, i.texcoord0.xyxx);
                float4 r0_xyzw_2 = (r0_xyzw_1 * _Color);
                float r1_x_8;
                float r1_y_11;
                float r1_z_10;
                float r1_w_8;
                if ((cb3_values[0].x == 1))
                {
                    float3 r1_yzw_2 = ((i.texcoord2.yyyy * cb3_values[2].xxyz)).yzw;
                    float3 r1_yzw_3 = (mad(cb3_values[1].xxyz, i.texcoord2.xxxx, r1_yzw_2.xxyz)).yzw;
                    float3 r1_yzw_4 = (mad(cb3_values[3].xxyz, i.texcoord2.zzzz, r1_yzw_3.xxyz)).yzw;
                    float3 r1_yzw_5 = ((r1_yzw_4.xxyz + cb3_values[4].xxyz)).yzw;
                    float4 r1_xyzw_4 = (((cb3_values[0].y == 1)).xxxx ? r1_yzw_5.xyzx : i.texcoord2.xyzx);
                    float r1_x_4 = r1_xyzw_4.x;
                    float r1_y_6 = r1_xyzw_4.y;
                    float r1_z_6 = r1_xyzw_4.z;
                    float4 r1_xyzw_5 = (float4(r1_x_4, r1_y_6, r1_z_6, r1_x_4) + -cb3_values[6].xyzx);
                    float r1_x_5 = r1_xyzw_5.x;
                    float r1_y_7 = r1_xyzw_5.y;
                    float r1_z_7 = r1_xyzw_5.z;
                    float4 r1_xyzw_8 = (float4(r1_x_5, r1_x_5, r1_y_7, r1_z_7) * cb3_values[5].xxyz);
                    float r1_y_8 = r1_xyzw_8.y;
                    float r1_z_8 = r1_xyzw_8.z;
                    float r1_w_6 = r1_xyzw_8.w;
                    float r1_y_9 = mad(r1_y_8, 0.25, 0.75);
                    float r1_x_6 = max(r1_y_9, mad(cb3_values[0].z, 0.5, 0.75));
                    float4 r1_xyzw_7 = t1.Sample(s0, float4(r1_x_6, r1_z_8, r1_w_6, r1_x_6));
                    r1_x_8 = r1_xyzw_7.x;
                    r1_y_11 = r1_xyzw_7.y;
                    r1_z_10 = r1_xyzw_7.z;
                    r1_w_8 = r1_xyzw_7.w;
                }
                else
                {
                    float4 r1_xyzw_2 = float4(1, 1, 1, 1);
                    r1_x_8 = r1_xyzw_2.x;
                    r1_y_11 = r1_xyzw_2.y;
                    r1_z_10 = r1_xyzw_2.z;
                    r1_w_8 = r1_xyzw_2.w;
                }
                float4 r1_xyzw_10 = ((dot(float4(r1_x_8, r1_y_11, r1_z_10, r1_w_8), unity_OcclusionMaskSelector)).xxxx * _LightColor0.xyzx);
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_12 = r1_xyzw_10.y;
                float r1_z_11 = r1_xyzw_10.z;
                float r1_w_9 = dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx);
                float r1_w_10 = max(r1_w_9, 0);
                float4 r1_xyzw_11 = (r0_xyzw_2.xyzx * float4(r1_x_10, r1_y_12, r1_z_11, r1_x_10));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_13 = r1_xyzw_11.y;
                float r1_z_12 = r1_xyzw_11.z;
                float TEXCOORD0_x_12 = i.texcoord4.x;
                o.sv_Target0.xyz = (mad(TEXCOORD0_x_12.xxxx, (((mad(float4(r1_x_11, r1_y_13, r1_z_12, r1_x_11), r1_w_10.xxxx, ((r0_xyzw_2.xyzx * i.texcoord3.xyzx)).xyzx)).xyzx + -unity_ProbeVolumeParams.xyzx)).xyzx, unity_ProbeVolumeParams.xyzx)).xyz;
                o.sv_Target0.w = r0_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDBASE" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcColor
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[6];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityPerFrame : register(b2)
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
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[2];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
            struct program9Input
            {
                float4 position0 : POSITION0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program9Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program16Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program16Output
            {
                float4 sv_Target0 : SV_Target0;
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
                o.sv_Position0.xyzw = clipPos_xyzw_7;
                o.texcoord4.x = mad(max((((clipPos_xyzw_7.z / unity_WorldToObject[1].y) + 1) * unity_WorldToObject[1].z), 0), cb4_values[1].z, cb4_values[1].w);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_12 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12), float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12))).xyz;
                return o;
            }
            #pragma fragment frag
            program16Output frag(program16Input i)
            {
                program16Output o = (program16Output)0;
                float4 r0_xyzw_1 = t0.Sample(s1, i.texcoord0.xyxx);
                float4 r0_xyzw_2 = (r0_xyzw_1 * _Color);
                float r1_x_8;
                float r1_y_11;
                float r1_z_10;
                float r1_w_8;
                if ((cb3_values[0].x == 1))
                {
                    float3 r1_yzw_2 = ((i.texcoord2.yyyy * cb3_values[2].xxyz)).yzw;
                    float3 r1_yzw_3 = (mad(cb3_values[1].xxyz, i.texcoord2.xxxx, r1_yzw_2.xxyz)).yzw;
                    float3 r1_yzw_4 = (mad(cb3_values[3].xxyz, i.texcoord2.zzzz, r1_yzw_3.xxyz)).yzw;
                    float3 r1_yzw_5 = ((r1_yzw_4.xxyz + cb3_values[4].xxyz)).yzw;
                    float4 r1_xyzw_4 = (((cb3_values[0].y == 1)).xxxx ? r1_yzw_5.xyzx : i.texcoord2.xyzx);
                    float r1_x_4 = r1_xyzw_4.x;
                    float r1_y_6 = r1_xyzw_4.y;
                    float r1_z_6 = r1_xyzw_4.z;
                    float4 r1_xyzw_5 = (float4(r1_x_4, r1_y_6, r1_z_6, r1_x_4) + -cb3_values[6].xyzx);
                    float r1_x_5 = r1_xyzw_5.x;
                    float r1_y_7 = r1_xyzw_5.y;
                    float r1_z_7 = r1_xyzw_5.z;
                    float4 r1_xyzw_8 = (float4(r1_x_5, r1_x_5, r1_y_7, r1_z_7) * cb3_values[5].xxyz);
                    float r1_y_8 = r1_xyzw_8.y;
                    float r1_z_8 = r1_xyzw_8.z;
                    float r1_w_6 = r1_xyzw_8.w;
                    float r1_y_9 = mad(r1_y_8, 0.25, 0.75);
                    float r1_x_6 = max(r1_y_9, mad(cb3_values[0].z, 0.5, 0.75));
                    float4 r1_xyzw_7 = t1.Sample(s0, float4(r1_x_6, r1_z_8, r1_w_6, r1_x_6));
                    r1_x_8 = r1_xyzw_7.x;
                    r1_y_11 = r1_xyzw_7.y;
                    r1_z_10 = r1_xyzw_7.z;
                    r1_w_8 = r1_xyzw_7.w;
                }
                else
                {
                    float4 r1_xyzw_2 = float4(1, 1, 1, 1);
                    r1_x_8 = r1_xyzw_2.x;
                    r1_y_11 = r1_xyzw_2.y;
                    r1_z_10 = r1_xyzw_2.z;
                    r1_w_8 = r1_xyzw_2.w;
                }
                float4 r1_xyzw_10 = ((dot(float4(r1_x_8, r1_y_11, r1_z_10, r1_w_8), unity_OcclusionMaskSelector)).xxxx * _LightColor0.xyzx);
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_12 = r1_xyzw_10.y;
                float r1_z_11 = r1_xyzw_10.z;
                float r1_w_9 = dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx);
                float r1_w_10 = max(r1_w_9, 0);
                float TEXCOORD0_x_11 = i.texcoord4.x;
                o.sv_Target0.xyz = (mad(TEXCOORD0_x_11.xxxx, (mad(((r0_xyzw_2.xyzx * float4(r1_x_10, r1_y_12, r1_z_11, r1_x_10))).xyzx, r1_w_10.xxxx, -unity_ProbeVolumeParams.xyzx)).xyzx, unity_ProbeVolumeParams.xyzx)).xyz;
                o.sv_Target0.w = r0_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDBASE" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcColor
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[6];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityPerFrame : register(b2)
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
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
            struct program8Input
            {
                float4 position0 : POSITION0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program8Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program17Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program17Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program8Output vert(program8Input i)
            {
                program8Output o = (program8Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float3 r0_xyz_4 = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_2 = mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_w_4 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r0_w_5 = rsqrt(r0_w_4);
                float3 unitWorldNormal_xyz_3 = ((r0_w_5.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (unitWorldNormal_xyz_3.xyzx).xyz;
                o.texcoord2.xyz = (r0_xyz_4.xyzx).xyz;
                float r0_w_6 = (unitWorldNormal_xyz_3.y * unitWorldNormal_xyz_3.y);
                float r0_w_7 = mad(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.x, -r0_w_6);
                float4 r2_xyzw_4 = (unitWorldNormal_xyz_3.yzzx * unitWorldNormal_xyz_3.xyzz);
                float r3_x_1 = dot(cb1_values[42].xyzw, r2_xyzw_4);
                float r3_y_1 = dot(cb1_values[43].xyzw, r2_xyzw_4);
                float r3_z_1 = dot(cb1_values[44].xyzw, r2_xyzw_4);
                float r1_w_2 = 1;
                float r3_x_2 = dot(cb1_values[39].xyzw, float4(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.y, unitWorldNormal_xyz_3.z, r1_w_2));
                float r3_y_2 = dot(cb1_values[40].xyzw, float4(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.y, unitWorldNormal_xyz_3.z, r1_w_2));
                float r3_z_2 = dot(cb1_values[41].xyzw, float4(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.y, unitWorldNormal_xyz_3.z, r1_w_2));
                float3 r2_xyz_9 = (((log2((max((((mad(cb1_values[45].xyzx, r0_w_7.xxxx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1))).xyzx + float4(r3_x_2, r3_y_2, r3_z_2, r3_x_2))).xyzx, float4(0, 0, 0, 0))).xyzx)).xyzx * float4(0.41666666, 0.41666666, 0.41666666, 0))).xyz;
                float4 r3_xyzw_3 = (-r0_xyz_4.yyyy + unity_WorldToObject[0]);
                float4 r3_xyzw_4 = (r3_xyzw_3 * r3_xyzw_3);
                float4 r5_xyzw_1 = (-r0_xyz_4.xxxx + unity_ObjectToWorld[3]);
                float4 r0_xyzw_5 = (-r0_xyz_4.zzzz + unity_WorldToObject[1]);
                float4 r1_xyzw_4 = mad(r0_xyzw_5, unitWorldNormal_xyz_3.zzzz, mad(r5_xyzw_1, unitWorldNormal_xyz_3.xxxx, (unitWorldNormal_xyz_3.yyyy * r3_xyzw_3)));
                float4 r3_xyzw_5 = mad(r5_xyzw_1, r5_xyzw_1, r3_xyzw_4);
                float4 r0_xyzw_6 = mad(r0_xyzw_5, r0_xyzw_5, r3_xyzw_5);
                float4 r0_xyzw_7 = max(r0_xyzw_6, float4(1E-06, 1E-06, 1E-06, 1E-06));
                float4 r3_xyzw_6 = rsqrt(r0_xyzw_7);
                float4 r0_xyzw_8 = mad(r0_xyzw_7, unity_WorldToObject[2], float4(1, 1, 1, 1));
                float4 r0_xyzw_9 = (float4(1, 1, 1, 1) / r0_xyzw_8);
                float4 r1_xyzw_5 = (r1_xyzw_4 * r3_xyzw_6);
                float4 r1_xyzw_6 = max(r1_xyzw_5, float4(0, 0, 0, 0));
                float4 r0_xyzw_10 = (r0_xyzw_9 * r1_xyzw_6);
                float3 r0_xyz_12 = (mad(cb1_values[10].xyzx, r0_xyzw_10.wwww, (mad(cb1_values[9].xyzx, r0_xyzw_10.zzzz, (mad(unity_WorldToObject[3].xyzx, r0_xyzw_10.xxxx, ((r0_xyzw_10.yyyy * cb1_values[8].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord3.xyz = (((max((mad((exp2(r2_xyz_9.xyzx)).xyzx, float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0))).xyzx, float4(0, 0, 0, 0))).xyzx + r0_xyz_12.xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program17Output frag(program17Input i)
            {
                program17Output o = (program17Output)0;
                float4 r0_xyzw_1 = t0.Sample(s1, i.texcoord0.xyxx);
                float4 r0_xyzw_2 = (r0_xyzw_1 * _Color);
                float r1_x_8;
                float r1_y_11;
                float r1_z_10;
                float r1_w_8;
                if ((cb3_values[0].x == 1))
                {
                    float3 r1_yzw_2 = ((i.texcoord2.yyyy * cb3_values[2].xxyz)).yzw;
                    float3 r1_yzw_3 = (mad(cb3_values[1].xxyz, i.texcoord2.xxxx, r1_yzw_2.xxyz)).yzw;
                    float3 r1_yzw_4 = (mad(cb3_values[3].xxyz, i.texcoord2.zzzz, r1_yzw_3.xxyz)).yzw;
                    float3 r1_yzw_5 = ((r1_yzw_4.xxyz + cb3_values[4].xxyz)).yzw;
                    float4 r1_xyzw_4 = (((cb3_values[0].y == 1)).xxxx ? r1_yzw_5.xyzx : i.texcoord2.xyzx);
                    float r1_x_4 = r1_xyzw_4.x;
                    float r1_y_6 = r1_xyzw_4.y;
                    float r1_z_6 = r1_xyzw_4.z;
                    float4 r1_xyzw_5 = (float4(r1_x_4, r1_y_6, r1_z_6, r1_x_4) + -cb3_values[6].xyzx);
                    float r1_x_5 = r1_xyzw_5.x;
                    float r1_y_7 = r1_xyzw_5.y;
                    float r1_z_7 = r1_xyzw_5.z;
                    float4 r1_xyzw_8 = (float4(r1_x_5, r1_x_5, r1_y_7, r1_z_7) * cb3_values[5].xxyz);
                    float r1_y_8 = r1_xyzw_8.y;
                    float r1_z_8 = r1_xyzw_8.z;
                    float r1_w_6 = r1_xyzw_8.w;
                    float r1_y_9 = mad(r1_y_8, 0.25, 0.75);
                    float r1_x_6 = max(r1_y_9, mad(cb3_values[0].z, 0.5, 0.75));
                    float4 r1_xyzw_7 = t1.Sample(s0, float4(r1_x_6, r1_z_8, r1_w_6, r1_x_6));
                    r1_x_8 = r1_xyzw_7.x;
                    r1_y_11 = r1_xyzw_7.y;
                    r1_z_10 = r1_xyzw_7.z;
                    r1_w_8 = r1_xyzw_7.w;
                }
                else
                {
                    float4 r1_xyzw_2 = float4(1, 1, 1, 1);
                    r1_x_8 = r1_xyzw_2.x;
                    r1_y_11 = r1_xyzw_2.y;
                    r1_z_10 = r1_xyzw_2.z;
                    r1_w_8 = r1_xyzw_2.w;
                }
                float4 r1_xyzw_10 = ((dot(float4(r1_x_8, r1_y_11, r1_z_10, r1_w_8), unity_OcclusionMaskSelector)).xxxx * _LightColor0.xyzx);
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_12 = r1_xyzw_10.y;
                float r1_z_11 = r1_xyzw_10.z;
                float r1_w_9 = dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx);
                float r1_w_10 = max(r1_w_9, 0);
                float4 r1_xyzw_11 = (r0_xyzw_2.xyzx * float4(r1_x_10, r1_y_12, r1_z_11, r1_x_10));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_13 = r1_xyzw_11.y;
                float r1_z_12 = r1_xyzw_11.z;
                float TEXCOORD0_x_12 = i.texcoord4.x;
                o.sv_Target0.xyz = (mad(TEXCOORD0_x_12.xxxx, (((mad(float4(r1_x_11, r1_y_13, r1_z_12, r1_x_11), r1_w_10.xxxx, ((r0_xyzw_2.xyzx * i.texcoord3.xyzx)).xyzx)).xyzx + -unity_ProbeVolumeParams.xyzx)).xyzx, unity_ProbeVolumeParams.xyzx)).xyz;
                o.sv_Target0.w = r0_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDBASE" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcColor
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[6];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityPerFrame : register(b2)
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
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
            struct program8Input
            {
                float4 position0 : POSITION0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program8Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program15Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program15Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program8Output vert(program8Input i)
            {
                program8Output o = (program8Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float3 r0_xyz_4 = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_2 = mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_w_4 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r0_w_5 = rsqrt(r0_w_4);
                float3 unitWorldNormal_xyz_3 = ((r0_w_5.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (unitWorldNormal_xyz_3.xyzx).xyz;
                o.texcoord2.xyz = (r0_xyz_4.xyzx).xyz;
                float r0_w_6 = (unitWorldNormal_xyz_3.y * unitWorldNormal_xyz_3.y);
                float r0_w_7 = mad(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.x, -r0_w_6);
                float4 r2_xyzw_4 = (unitWorldNormal_xyz_3.yzzx * unitWorldNormal_xyz_3.xyzz);
                float r3_x_1 = dot(cb1_values[42].xyzw, r2_xyzw_4);
                float r3_y_1 = dot(cb1_values[43].xyzw, r2_xyzw_4);
                float r3_z_1 = dot(cb1_values[44].xyzw, r2_xyzw_4);
                float r1_w_2 = 1;
                float r3_x_2 = dot(cb1_values[39].xyzw, float4(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.y, unitWorldNormal_xyz_3.z, r1_w_2));
                float r3_y_2 = dot(cb1_values[40].xyzw, float4(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.y, unitWorldNormal_xyz_3.z, r1_w_2));
                float r3_z_2 = dot(cb1_values[41].xyzw, float4(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.y, unitWorldNormal_xyz_3.z, r1_w_2));
                float3 r2_xyz_9 = (((log2((max((((mad(cb1_values[45].xyzx, r0_w_7.xxxx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1))).xyzx + float4(r3_x_2, r3_y_2, r3_z_2, r3_x_2))).xyzx, float4(0, 0, 0, 0))).xyzx)).xyzx * float4(0.41666666, 0.41666666, 0.41666666, 0))).xyz;
                float4 r3_xyzw_3 = (-r0_xyz_4.yyyy + unity_WorldToObject[0]);
                float4 r3_xyzw_4 = (r3_xyzw_3 * r3_xyzw_3);
                float4 r5_xyzw_1 = (-r0_xyz_4.xxxx + unity_ObjectToWorld[3]);
                float4 r0_xyzw_5 = (-r0_xyz_4.zzzz + unity_WorldToObject[1]);
                float4 r1_xyzw_4 = mad(r0_xyzw_5, unitWorldNormal_xyz_3.zzzz, mad(r5_xyzw_1, unitWorldNormal_xyz_3.xxxx, (unitWorldNormal_xyz_3.yyyy * r3_xyzw_3)));
                float4 r3_xyzw_5 = mad(r5_xyzw_1, r5_xyzw_1, r3_xyzw_4);
                float4 r0_xyzw_6 = mad(r0_xyzw_5, r0_xyzw_5, r3_xyzw_5);
                float4 r0_xyzw_7 = max(r0_xyzw_6, float4(1E-06, 1E-06, 1E-06, 1E-06));
                float4 r3_xyzw_6 = rsqrt(r0_xyzw_7);
                float4 r0_xyzw_8 = mad(r0_xyzw_7, unity_WorldToObject[2], float4(1, 1, 1, 1));
                float4 r0_xyzw_9 = (float4(1, 1, 1, 1) / r0_xyzw_8);
                float4 r1_xyzw_5 = (r1_xyzw_4 * r3_xyzw_6);
                float4 r1_xyzw_6 = max(r1_xyzw_5, float4(0, 0, 0, 0));
                float4 r0_xyzw_10 = (r0_xyzw_9 * r1_xyzw_6);
                float3 r0_xyz_12 = (mad(cb1_values[10].xyzx, r0_xyzw_10.wwww, (mad(cb1_values[9].xyzx, r0_xyzw_10.zzzz, (mad(unity_WorldToObject[3].xyzx, r0_xyzw_10.xxxx, ((r0_xyzw_10.yyyy * cb1_values[8].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord3.xyz = (((max((mad((exp2(r2_xyz_9.xyzx)).xyzx, float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0))).xyzx, float4(0, 0, 0, 0))).xyzx + r0_xyz_12.xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program15Output frag(program15Input i)
            {
                program15Output o = (program15Output)0;
                float4 r0_xyzw_1 = t0.Sample(s1, i.texcoord0.xyxx);
                float4 r0_xyzw_2 = (r0_xyzw_1 * _Color);
                float r1_x_8;
                float r1_y_11;
                float r1_z_10;
                float r1_w_8;
                if ((unity_ProbeVolumeParams.x == 1))
                {
                    float3 r1_yzw_2 = ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xxyz)).yzw;
                    float3 r1_yzw_3 = (mad(unity_ProbeVolumeWorldToObject[0].xxyz, i.texcoord2.xxxx, r1_yzw_2.xxyz)).yzw;
                    float3 r1_yzw_4 = (mad(unity_ProbeVolumeWorldToObject[2].xxyz, i.texcoord2.zzzz, r1_yzw_3.xxyz)).yzw;
                    float3 r1_yzw_5 = ((r1_yzw_4.xxyz + unity_ProbeVolumeWorldToObject[3].xxyz)).yzw;
                    float4 unity_ProbeVolumeParamsSelect_xyzw_4 = (((unity_ProbeVolumeParams.y == 1)).xxxx ? r1_yzw_5.xyzx : i.texcoord2.xyzx);
                    float unity_ProbeVolumeParamsSelect_x_4 = unity_ProbeVolumeParamsSelect_xyzw_4.x;
                    float unity_ProbeVolumeParamsSelect_y_6 = unity_ProbeVolumeParamsSelect_xyzw_4.y;
                    float unity_ProbeVolumeParamsSelect_z_6 = unity_ProbeVolumeParamsSelect_xyzw_4.z;
                    float4 r1_xyzw_5 = (float4(unity_ProbeVolumeParamsSelect_x_4, unity_ProbeVolumeParamsSelect_y_6, unity_ProbeVolumeParamsSelect_z_6, unity_ProbeVolumeParamsSelect_x_4) + -unity_ProbeVolumeMin.xyzx);
                    float r1_x_5 = r1_xyzw_5.x;
                    float r1_y_7 = r1_xyzw_5.y;
                    float r1_z_7 = r1_xyzw_5.z;
                    float4 r1_xyzw_8 = (float4(r1_x_5, r1_x_5, r1_y_7, r1_z_7) * unity_ProbeVolumeSizeInv.xxyz);
                    float r1_y_8 = r1_xyzw_8.y;
                    float r1_z_8 = r1_xyzw_8.z;
                    float r1_w_6 = r1_xyzw_8.w;
                    float r1_y_9 = mad(r1_y_8, 0.25, 0.75);
                    float r1_x_6 = max(r1_y_9, mad(unity_ProbeVolumeParams.z, 0.5, 0.75));
                    float4 r1_xyzw_7 = t1.Sample(s0, float4(r1_x_6, r1_z_8, r1_w_6, r1_x_6));
                    r1_x_8 = r1_xyzw_7.x;
                    r1_y_11 = r1_xyzw_7.y;
                    r1_z_10 = r1_xyzw_7.z;
                    r1_w_8 = r1_xyzw_7.w;
                }
                else
                {
                    float4 r1_xyzw_2 = float4(1, 1, 1, 1);
                    r1_x_8 = r1_xyzw_2.x;
                    r1_y_11 = r1_xyzw_2.y;
                    r1_z_10 = r1_xyzw_2.z;
                    r1_w_8 = r1_xyzw_2.w;
                }
                float4 r1_xyzw_10 = ((dot(float4(r1_x_8, r1_y_11, r1_z_10, r1_w_8), unity_OcclusionMaskSelector)).xxxx * _LightColor0.xyzx);
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_12 = r1_xyzw_10.y;
                float r1_z_11 = r1_xyzw_10.z;
                float r1_w_9 = dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx);
                float r1_w_10 = max(r1_w_9, 0);
                float4 r1_xyzw_11 = (r0_xyzw_2.xyzx * float4(r1_x_10, r1_y_12, r1_z_11, r1_x_10));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_13 = r1_xyzw_11.y;
                float r1_z_12 = r1_xyzw_11.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_11, r1_y_13, r1_z_12, r1_x_11), r1_w_10.xxxx, ((r0_xyzw_2.xyzx * i.texcoord3.xyzx)).xyzx)).xyz;
                o.sv_Target0.w = r0_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDBASE" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcColor
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[6];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityPerFrame : register(b2)
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
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
            struct program7Input
            {
                float4 position0 : POSITION0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program7Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program17Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program17Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program7Output vert(program7Input i)
            {
                program7Output o = (program7Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                o.sv_Position0.xyzw = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                float3 unitWorldNormal_xyz_8 = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.texcoord1.xyz = (unitWorldNormal_xyz_8.xyzx).xyz;
                float4 r2_xyzw_1 = (unitWorldNormal_xyz_8.yzzx * unitWorldNormal_xyz_8.xyzz);
                float r3_x_1 = dot(cb1_values[42].xyzw, r2_xyzw_1);
                float r3_y_1 = dot(cb1_values[43].xyzw, r2_xyzw_1);
                float r3_z_1 = dot(cb1_values[44].xyzw, r2_xyzw_1);
                float4 r1_xyzw_4 = mad(cb1_values[45].xyzx, (mad(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.x, (unitWorldNormal_xyz_8.y * unitWorldNormal_xyz_8.y))).xxxx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_2 = r1_xyzw_4.y;
                float r1_z_2 = r1_xyzw_4.z;
                float r0_w_9 = 1;
                float r2_x_2 = dot(cb1_values[39].xyzw, float4(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.y, unitWorldNormal_xyz_8.z, r0_w_9));
                float r2_y_2 = dot(cb1_values[40].xyzw, float4(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.y, unitWorldNormal_xyz_8.z, r0_w_9));
                float r2_z_2 = dot(cb1_values[41].xyzw, float4(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.y, unitWorldNormal_xyz_8.z, r0_w_9));
                float3 r0_xyz_13 = (exp2((((log2((max(((float4(r1_x_4, r1_y_2, r1_z_2, r1_x_4) + float4(r2_x_2, r2_y_2, r2_z_2, r2_x_2))).xyzx, float4(0, 0, 0, 0))).xyzx)).xyzx * float4(0.41666666, 0.41666666, 0.41666666, 0))).xyzx)).xyz;
                o.texcoord3.xyz = (max((mad(r0_xyz_13.xyzx, float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0))).xyzx, float4(0, 0, 0, 0))).xyz;
                return o;
            }
            #pragma fragment frag
            program17Output frag(program17Input i)
            {
                program17Output o = (program17Output)0;
                float4 r0_xyzw_1 = t0.Sample(s1, i.texcoord0.xyxx);
                float4 r0_xyzw_2 = (r0_xyzw_1 * _Color);
                float r1_x_8;
                float r1_y_11;
                float r1_z_10;
                float r1_w_8;
                if ((cb3_values[0].x == 1))
                {
                    float3 r1_yzw_2 = ((i.texcoord2.yyyy * cb3_values[2].xxyz)).yzw;
                    float3 r1_yzw_3 = (mad(cb3_values[1].xxyz, i.texcoord2.xxxx, r1_yzw_2.xxyz)).yzw;
                    float3 r1_yzw_4 = (mad(cb3_values[3].xxyz, i.texcoord2.zzzz, r1_yzw_3.xxyz)).yzw;
                    float3 r1_yzw_5 = ((r1_yzw_4.xxyz + cb3_values[4].xxyz)).yzw;
                    float4 r1_xyzw_4 = (((cb3_values[0].y == 1)).xxxx ? r1_yzw_5.xyzx : i.texcoord2.xyzx);
                    float r1_x_4 = r1_xyzw_4.x;
                    float r1_y_6 = r1_xyzw_4.y;
                    float r1_z_6 = r1_xyzw_4.z;
                    float4 r1_xyzw_5 = (float4(r1_x_4, r1_y_6, r1_z_6, r1_x_4) + -cb3_values[6].xyzx);
                    float r1_x_5 = r1_xyzw_5.x;
                    float r1_y_7 = r1_xyzw_5.y;
                    float r1_z_7 = r1_xyzw_5.z;
                    float4 r1_xyzw_8 = (float4(r1_x_5, r1_x_5, r1_y_7, r1_z_7) * cb3_values[5].xxyz);
                    float r1_y_8 = r1_xyzw_8.y;
                    float r1_z_8 = r1_xyzw_8.z;
                    float r1_w_6 = r1_xyzw_8.w;
                    float r1_y_9 = mad(r1_y_8, 0.25, 0.75);
                    float r1_x_6 = max(r1_y_9, mad(cb3_values[0].z, 0.5, 0.75));
                    float4 r1_xyzw_7 = t1.Sample(s0, float4(r1_x_6, r1_z_8, r1_w_6, r1_x_6));
                    r1_x_8 = r1_xyzw_7.x;
                    r1_y_11 = r1_xyzw_7.y;
                    r1_z_10 = r1_xyzw_7.z;
                    r1_w_8 = r1_xyzw_7.w;
                }
                else
                {
                    float4 r1_xyzw_2 = float4(1, 1, 1, 1);
                    r1_x_8 = r1_xyzw_2.x;
                    r1_y_11 = r1_xyzw_2.y;
                    r1_z_10 = r1_xyzw_2.z;
                    r1_w_8 = r1_xyzw_2.w;
                }
                float4 r1_xyzw_10 = ((dot(float4(r1_x_8, r1_y_11, r1_z_10, r1_w_8), unity_OcclusionMaskSelector)).xxxx * _LightColor0.xyzx);
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_12 = r1_xyzw_10.y;
                float r1_z_11 = r1_xyzw_10.z;
                float r1_w_9 = dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx);
                float r1_w_10 = max(r1_w_9, 0);
                float4 r1_xyzw_11 = (r0_xyzw_2.xyzx * float4(r1_x_10, r1_y_12, r1_z_11, r1_x_10));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_13 = r1_xyzw_11.y;
                float r1_z_12 = r1_xyzw_11.z;
                float TEXCOORD0_x_12 = i.texcoord4.x;
                o.sv_Target0.xyz = (mad(TEXCOORD0_x_12.xxxx, (((mad(float4(r1_x_11, r1_y_13, r1_z_12, r1_x_11), r1_w_10.xxxx, ((r0_xyzw_2.xyzx * i.texcoord3.xyzx)).xyzx)).xyzx + -unity_ProbeVolumeParams.xyzx)).xyzx, unity_ProbeVolumeParams.xyzx)).xyz;
                o.sv_Target0.w = r0_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDBASE" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcColor
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[6];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityPerFrame : register(b2)
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
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
            struct program7Input
            {
                float4 position0 : POSITION0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program7Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program15Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program15Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program7Output vert(program7Input i)
            {
                program7Output o = (program7Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                o.sv_Position0.xyzw = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                float3 unitWorldNormal_xyz_8 = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.texcoord1.xyz = (unitWorldNormal_xyz_8.xyzx).xyz;
                float4 r2_xyzw_1 = (unitWorldNormal_xyz_8.yzzx * unitWorldNormal_xyz_8.xyzz);
                float r3_x_1 = dot(cb1_values[42].xyzw, r2_xyzw_1);
                float r3_y_1 = dot(cb1_values[43].xyzw, r2_xyzw_1);
                float r3_z_1 = dot(cb1_values[44].xyzw, r2_xyzw_1);
                float4 r1_xyzw_4 = mad(cb1_values[45].xyzx, (mad(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.x, (unitWorldNormal_xyz_8.y * unitWorldNormal_xyz_8.y))).xxxx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_2 = r1_xyzw_4.y;
                float r1_z_2 = r1_xyzw_4.z;
                float r0_w_9 = 1;
                float r2_x_2 = dot(cb1_values[39].xyzw, float4(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.y, unitWorldNormal_xyz_8.z, r0_w_9));
                float r2_y_2 = dot(cb1_values[40].xyzw, float4(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.y, unitWorldNormal_xyz_8.z, r0_w_9));
                float r2_z_2 = dot(cb1_values[41].xyzw, float4(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.y, unitWorldNormal_xyz_8.z, r0_w_9));
                float3 r0_xyz_13 = (exp2((((log2((max(((float4(r1_x_4, r1_y_2, r1_z_2, r1_x_4) + float4(r2_x_2, r2_y_2, r2_z_2, r2_x_2))).xyzx, float4(0, 0, 0, 0))).xyzx)).xyzx * float4(0.41666666, 0.41666666, 0.41666666, 0))).xyzx)).xyz;
                o.texcoord3.xyz = (max((mad(r0_xyz_13.xyzx, float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0))).xyzx, float4(0, 0, 0, 0))).xyz;
                return o;
            }
            #pragma fragment frag
            program15Output frag(program15Input i)
            {
                program15Output o = (program15Output)0;
                float4 r0_xyzw_1 = t0.Sample(s1, i.texcoord0.xyxx);
                float4 r0_xyzw_2 = (r0_xyzw_1 * _Color);
                float r1_x_8;
                float r1_y_11;
                float r1_z_10;
                float r1_w_8;
                if ((unity_ProbeVolumeParams.x == 1))
                {
                    float3 r1_yzw_2 = ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xxyz)).yzw;
                    float3 r1_yzw_3 = (mad(unity_ProbeVolumeWorldToObject[0].xxyz, i.texcoord2.xxxx, r1_yzw_2.xxyz)).yzw;
                    float3 r1_yzw_4 = (mad(unity_ProbeVolumeWorldToObject[2].xxyz, i.texcoord2.zzzz, r1_yzw_3.xxyz)).yzw;
                    float3 r1_yzw_5 = ((r1_yzw_4.xxyz + unity_ProbeVolumeWorldToObject[3].xxyz)).yzw;
                    float4 unity_ProbeVolumeParamsSelect_xyzw_4 = (((unity_ProbeVolumeParams.y == 1)).xxxx ? r1_yzw_5.xyzx : i.texcoord2.xyzx);
                    float unity_ProbeVolumeParamsSelect_x_4 = unity_ProbeVolumeParamsSelect_xyzw_4.x;
                    float unity_ProbeVolumeParamsSelect_y_6 = unity_ProbeVolumeParamsSelect_xyzw_4.y;
                    float unity_ProbeVolumeParamsSelect_z_6 = unity_ProbeVolumeParamsSelect_xyzw_4.z;
                    float4 r1_xyzw_5 = (float4(unity_ProbeVolumeParamsSelect_x_4, unity_ProbeVolumeParamsSelect_y_6, unity_ProbeVolumeParamsSelect_z_6, unity_ProbeVolumeParamsSelect_x_4) + -unity_ProbeVolumeMin.xyzx);
                    float r1_x_5 = r1_xyzw_5.x;
                    float r1_y_7 = r1_xyzw_5.y;
                    float r1_z_7 = r1_xyzw_5.z;
                    float4 r1_xyzw_8 = (float4(r1_x_5, r1_x_5, r1_y_7, r1_z_7) * unity_ProbeVolumeSizeInv.xxyz);
                    float r1_y_8 = r1_xyzw_8.y;
                    float r1_z_8 = r1_xyzw_8.z;
                    float r1_w_6 = r1_xyzw_8.w;
                    float r1_y_9 = mad(r1_y_8, 0.25, 0.75);
                    float r1_x_6 = max(r1_y_9, mad(unity_ProbeVolumeParams.z, 0.5, 0.75));
                    float4 r1_xyzw_7 = t1.Sample(s0, float4(r1_x_6, r1_z_8, r1_w_6, r1_x_6));
                    r1_x_8 = r1_xyzw_7.x;
                    r1_y_11 = r1_xyzw_7.y;
                    r1_z_10 = r1_xyzw_7.z;
                    r1_w_8 = r1_xyzw_7.w;
                }
                else
                {
                    float4 r1_xyzw_2 = float4(1, 1, 1, 1);
                    r1_x_8 = r1_xyzw_2.x;
                    r1_y_11 = r1_xyzw_2.y;
                    r1_z_10 = r1_xyzw_2.z;
                    r1_w_8 = r1_xyzw_2.w;
                }
                float4 r1_xyzw_10 = ((dot(float4(r1_x_8, r1_y_11, r1_z_10, r1_w_8), unity_OcclusionMaskSelector)).xxxx * _LightColor0.xyzx);
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_12 = r1_xyzw_10.y;
                float r1_z_11 = r1_xyzw_10.z;
                float r1_w_9 = dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx);
                float r1_w_10 = max(r1_w_9, 0);
                float4 r1_xyzw_11 = (r0_xyzw_2.xyzx * float4(r1_x_10, r1_y_12, r1_z_11, r1_x_10));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_13 = r1_xyzw_11.y;
                float r1_z_12 = r1_xyzw_11.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_11, r1_y_13, r1_z_12, r1_x_11), r1_w_10.xxxx, ((r0_xyzw_2.xyzx * i.texcoord3.xyzx)).xyzx)).xyz;
                o.sv_Target0.w = r0_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDBASE" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcColor
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[6];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[21];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[7];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
            struct program6Input
            {
                float4 position0 : POSITION0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program6Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program17Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program17Output
            {
                float4 sv_Target0 : SV_Target0;
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
            program17Output frag(program17Input i)
            {
                program17Output o = (program17Output)0;
                float4 r0_xyzw_1 = t0.Sample(s1, i.texcoord0.xyxx);
                float4 r0_xyzw_2 = (r0_xyzw_1 * _Color);
                float r1_x_8;
                float r1_y_11;
                float r1_z_10;
                float r1_w_8;
                if ((cb3_values[0].x == 1))
                {
                    float3 r1_yzw_2 = ((i.texcoord2.yyyy * cb3_values[2].xxyz)).yzw;
                    float3 r1_yzw_3 = (mad(cb3_values[1].xxyz, i.texcoord2.xxxx, r1_yzw_2.xxyz)).yzw;
                    float3 r1_yzw_4 = (mad(cb3_values[3].xxyz, i.texcoord2.zzzz, r1_yzw_3.xxyz)).yzw;
                    float3 r1_yzw_5 = ((r1_yzw_4.xxyz + cb3_values[4].xxyz)).yzw;
                    float4 r1_xyzw_4 = (((cb3_values[0].y == 1)).xxxx ? r1_yzw_5.xyzx : i.texcoord2.xyzx);
                    float r1_x_4 = r1_xyzw_4.x;
                    float r1_y_6 = r1_xyzw_4.y;
                    float r1_z_6 = r1_xyzw_4.z;
                    float4 r1_xyzw_5 = (float4(r1_x_4, r1_y_6, r1_z_6, r1_x_4) + -cb3_values[6].xyzx);
                    float r1_x_5 = r1_xyzw_5.x;
                    float r1_y_7 = r1_xyzw_5.y;
                    float r1_z_7 = r1_xyzw_5.z;
                    float4 r1_xyzw_8 = (float4(r1_x_5, r1_x_5, r1_y_7, r1_z_7) * cb3_values[5].xxyz);
                    float r1_y_8 = r1_xyzw_8.y;
                    float r1_z_8 = r1_xyzw_8.z;
                    float r1_w_6 = r1_xyzw_8.w;
                    float r1_y_9 = mad(r1_y_8, 0.25, 0.75);
                    float r1_x_6 = max(r1_y_9, mad(cb3_values[0].z, 0.5, 0.75));
                    float4 r1_xyzw_7 = t1.Sample(s0, float4(r1_x_6, r1_z_8, r1_w_6, r1_x_6));
                    r1_x_8 = r1_xyzw_7.x;
                    r1_y_11 = r1_xyzw_7.y;
                    r1_z_10 = r1_xyzw_7.z;
                    r1_w_8 = r1_xyzw_7.w;
                }
                else
                {
                    float4 r1_xyzw_2 = float4(1, 1, 1, 1);
                    r1_x_8 = r1_xyzw_2.x;
                    r1_y_11 = r1_xyzw_2.y;
                    r1_z_10 = r1_xyzw_2.z;
                    r1_w_8 = r1_xyzw_2.w;
                }
                float4 r1_xyzw_10 = ((dot(float4(r1_x_8, r1_y_11, r1_z_10, r1_w_8), unity_OcclusionMaskSelector)).xxxx * _LightColor0.xyzx);
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_12 = r1_xyzw_10.y;
                float r1_z_11 = r1_xyzw_10.z;
                float r1_w_9 = dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx);
                float r1_w_10 = max(r1_w_9, 0);
                float4 r1_xyzw_11 = (r0_xyzw_2.xyzx * float4(r1_x_10, r1_y_12, r1_z_11, r1_x_10));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_13 = r1_xyzw_11.y;
                float r1_z_12 = r1_xyzw_11.z;
                float TEXCOORD0_x_12 = i.texcoord4.x;
                o.sv_Target0.xyz = (mad(TEXCOORD0_x_12.xxxx, (((mad(float4(r1_x_11, r1_y_13, r1_z_12, r1_x_11), r1_w_10.xxxx, ((r0_xyzw_2.xyzx * i.texcoord3.xyzx)).xyzx)).xyzx + -unity_ProbeVolumeParams.xyzx)).xyzx, unity_ProbeVolumeParams.xyzx)).xyz;
                o.sv_Target0.w = r0_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDBASE" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcColor
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[6];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[21];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[7];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
            struct program6Input
            {
                float4 position0 : POSITION0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program6Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program16Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program16Output
            {
                float4 sv_Target0 : SV_Target0;
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
            program16Output frag(program16Input i)
            {
                program16Output o = (program16Output)0;
                float4 r0_xyzw_1 = t0.Sample(s1, i.texcoord0.xyxx);
                float4 r0_xyzw_2 = (r0_xyzw_1 * _Color);
                float r1_x_8;
                float r1_y_11;
                float r1_z_10;
                float r1_w_8;
                if ((cb3_values[0].x == 1))
                {
                    float3 r1_yzw_2 = ((i.texcoord2.yyyy * cb3_values[2].xxyz)).yzw;
                    float3 r1_yzw_3 = (mad(cb3_values[1].xxyz, i.texcoord2.xxxx, r1_yzw_2.xxyz)).yzw;
                    float3 r1_yzw_4 = (mad(cb3_values[3].xxyz, i.texcoord2.zzzz, r1_yzw_3.xxyz)).yzw;
                    float3 r1_yzw_5 = ((r1_yzw_4.xxyz + cb3_values[4].xxyz)).yzw;
                    float4 r1_xyzw_4 = (((cb3_values[0].y == 1)).xxxx ? r1_yzw_5.xyzx : i.texcoord2.xyzx);
                    float r1_x_4 = r1_xyzw_4.x;
                    float r1_y_6 = r1_xyzw_4.y;
                    float r1_z_6 = r1_xyzw_4.z;
                    float4 r1_xyzw_5 = (float4(r1_x_4, r1_y_6, r1_z_6, r1_x_4) + -cb3_values[6].xyzx);
                    float r1_x_5 = r1_xyzw_5.x;
                    float r1_y_7 = r1_xyzw_5.y;
                    float r1_z_7 = r1_xyzw_5.z;
                    float4 r1_xyzw_8 = (float4(r1_x_5, r1_x_5, r1_y_7, r1_z_7) * cb3_values[5].xxyz);
                    float r1_y_8 = r1_xyzw_8.y;
                    float r1_z_8 = r1_xyzw_8.z;
                    float r1_w_6 = r1_xyzw_8.w;
                    float r1_y_9 = mad(r1_y_8, 0.25, 0.75);
                    float r1_x_6 = max(r1_y_9, mad(cb3_values[0].z, 0.5, 0.75));
                    float4 r1_xyzw_7 = t1.Sample(s0, float4(r1_x_6, r1_z_8, r1_w_6, r1_x_6));
                    r1_x_8 = r1_xyzw_7.x;
                    r1_y_11 = r1_xyzw_7.y;
                    r1_z_10 = r1_xyzw_7.z;
                    r1_w_8 = r1_xyzw_7.w;
                }
                else
                {
                    float4 r1_xyzw_2 = float4(1, 1, 1, 1);
                    r1_x_8 = r1_xyzw_2.x;
                    r1_y_11 = r1_xyzw_2.y;
                    r1_z_10 = r1_xyzw_2.z;
                    r1_w_8 = r1_xyzw_2.w;
                }
                float4 r1_xyzw_10 = ((dot(float4(r1_x_8, r1_y_11, r1_z_10, r1_w_8), unity_OcclusionMaskSelector)).xxxx * _LightColor0.xyzx);
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_12 = r1_xyzw_10.y;
                float r1_z_11 = r1_xyzw_10.z;
                float r1_w_9 = dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx);
                float r1_w_10 = max(r1_w_9, 0);
                float TEXCOORD0_x_11 = i.texcoord4.x;
                o.sv_Target0.xyz = (mad(TEXCOORD0_x_11.xxxx, (mad(((r0_xyzw_2.xyzx * float4(r1_x_10, r1_y_12, r1_z_11, r1_x_10))).xyzx, r1_w_10.xxxx, -unity_ProbeVolumeParams.xyzx)).xyzx, unity_ProbeVolumeParams.xyzx)).xyz;
                o.sv_Target0.w = r0_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDBASE" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcColor
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[6];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
            struct program6Input
            {
                float4 position0 : POSITION0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program6Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program15Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program15Output
            {
                float4 sv_Target0 : SV_Target0;
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
            program15Output frag(program15Input i)
            {
                program15Output o = (program15Output)0;
                float4 r0_xyzw_1 = t0.Sample(s1, i.texcoord0.xyxx);
                float4 r0_xyzw_2 = (r0_xyzw_1 * _Color);
                float r1_x_8;
                float r1_y_11;
                float r1_z_10;
                float r1_w_8;
                if ((unity_ProbeVolumeParams.x == 1))
                {
                    float3 r1_yzw_2 = ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xxyz)).yzw;
                    float3 r1_yzw_3 = (mad(unity_ProbeVolumeWorldToObject[0].xxyz, i.texcoord2.xxxx, r1_yzw_2.xxyz)).yzw;
                    float3 r1_yzw_4 = (mad(unity_ProbeVolumeWorldToObject[2].xxyz, i.texcoord2.zzzz, r1_yzw_3.xxyz)).yzw;
                    float3 r1_yzw_5 = ((r1_yzw_4.xxyz + unity_ProbeVolumeWorldToObject[3].xxyz)).yzw;
                    float4 unity_ProbeVolumeParamsSelect_xyzw_4 = (((unity_ProbeVolumeParams.y == 1)).xxxx ? r1_yzw_5.xyzx : i.texcoord2.xyzx);
                    float unity_ProbeVolumeParamsSelect_x_4 = unity_ProbeVolumeParamsSelect_xyzw_4.x;
                    float unity_ProbeVolumeParamsSelect_y_6 = unity_ProbeVolumeParamsSelect_xyzw_4.y;
                    float unity_ProbeVolumeParamsSelect_z_6 = unity_ProbeVolumeParamsSelect_xyzw_4.z;
                    float4 r1_xyzw_5 = (float4(unity_ProbeVolumeParamsSelect_x_4, unity_ProbeVolumeParamsSelect_y_6, unity_ProbeVolumeParamsSelect_z_6, unity_ProbeVolumeParamsSelect_x_4) + -unity_ProbeVolumeMin.xyzx);
                    float r1_x_5 = r1_xyzw_5.x;
                    float r1_y_7 = r1_xyzw_5.y;
                    float r1_z_7 = r1_xyzw_5.z;
                    float4 r1_xyzw_8 = (float4(r1_x_5, r1_x_5, r1_y_7, r1_z_7) * unity_ProbeVolumeSizeInv.xxyz);
                    float r1_y_8 = r1_xyzw_8.y;
                    float r1_z_8 = r1_xyzw_8.z;
                    float r1_w_6 = r1_xyzw_8.w;
                    float r1_y_9 = mad(r1_y_8, 0.25, 0.75);
                    float r1_x_6 = max(r1_y_9, mad(unity_ProbeVolumeParams.z, 0.5, 0.75));
                    float4 r1_xyzw_7 = t1.Sample(s0, float4(r1_x_6, r1_z_8, r1_w_6, r1_x_6));
                    r1_x_8 = r1_xyzw_7.x;
                    r1_y_11 = r1_xyzw_7.y;
                    r1_z_10 = r1_xyzw_7.z;
                    r1_w_8 = r1_xyzw_7.w;
                }
                else
                {
                    float4 r1_xyzw_2 = float4(1, 1, 1, 1);
                    r1_x_8 = r1_xyzw_2.x;
                    r1_y_11 = r1_xyzw_2.y;
                    r1_z_10 = r1_xyzw_2.z;
                    r1_w_8 = r1_xyzw_2.w;
                }
                float4 r1_xyzw_10 = ((dot(float4(r1_x_8, r1_y_11, r1_z_10, r1_w_8), unity_OcclusionMaskSelector)).xxxx * _LightColor0.xyzx);
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_12 = r1_xyzw_10.y;
                float r1_z_11 = r1_xyzw_10.z;
                float r1_w_9 = dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx);
                float r1_w_10 = max(r1_w_9, 0);
                float4 r1_xyzw_11 = (r0_xyzw_2.xyzx * float4(r1_x_10, r1_y_12, r1_z_11, r1_x_10));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_13 = r1_xyzw_11.y;
                float r1_z_12 = r1_xyzw_11.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_11, r1_y_13, r1_z_12, r1_x_11), r1_w_10.xxxx, ((r0_xyzw_2.xyzx * i.texcoord3.xyzx)).xyzx)).xyz;
                o.sv_Target0.w = r0_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture3D t2 : register(t2);
            struct program22Input
            {
                float4 position0 : POSITION0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program22Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program34Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program34Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program22Output vert(program22Input i)
            {
                program22Output o = (program22Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_3 = ((worldPos_xyzw_4.yyyy * _MainTex_ST.xyzx)).xyz;
                float3 clipPos_xyz_4 = (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_3.xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(cb0_values[6].xyzx, worldPos_xyzw_4.zzzz, clipPos_xyz_4.xyzx)).xyz;
                o.texcoord3.xyz = (mad(cb0_values[7].xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program34Output frag(program34Input i)
            {
                program34Output o = (program34Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = t0.Sample(s2, i.texcoord0.xyxx);
                float4 r1_xyzw_2 = (r1_xyzw_1 * cb0_values[8].xyzw);
                float3 r2_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r2_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r2_w_1);
                    float4 r3_xyzw_9 = t2.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
                    r3_x_10 = r3_xyzw_9.x;
                    r3_y_10 = r3_xyzw_9.y;
                    r3_z_10 = r3_xyzw_9.z;
                    r3_w_4 = r3_xyzw_9.w;
                }
                else
                {
                    float4 r3_xyzw_10 = float4(1, 1, 1, 1);
                    r3_x_10 = r3_xyzw_10.x;
                    r3_y_10 = r3_xyzw_10.y;
                    r3_z_10 = r3_xyzw_10.z;
                    r3_w_4 = r3_xyzw_10.w;
                }
                float r0_w_7 = dot(float4(r3_x_10, r3_y_10, r3_z_10, r3_w_4), unity_OcclusionMaskSelector);
                float4 r2_xyzw_6 = t1.Sample(s1, (dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx)).xxxx);
                float r0_w_8 = (r0_w_7 * r2_xyzw_6.x);
                float4 r2_xyzw_7 = (r0_w_8.xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_6 = r2_xyzw_7.y;
                float r2_z_6 = r2_xyzw_7.z;
                float4 r0_xyzw_3 = (r1_xyzw_2.xxyz * float4(r2_x_7, r2_x_7, r2_y_6, r2_z_6));
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                o.sv_Target0.xyz = (((max(dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3))).xyz;
                o.sv_Target0.w = r1_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityPerFrame : register(b2)
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
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[2];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture3D t2 : register(t2);
            struct program29Input
            {
                float4 position0 : POSITION0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program29Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float texcoord4 : TEXCOORD4;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program42Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float texcoord4 : TEXCOORD4;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program42Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program29Output vert(program29Input i)
            {
                program29Output o = (program29Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = clipPos_xyzw_2;
                o.texcoord4.x = mad(max((((clipPos_xyzw_2.z / unity_WorldToObject[1].y) + 1) * unity_WorldToObject[1].z), 0), cb4_values[1].z, cb4_values[1].w);
                float4 r1_xyzw_7 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                o.texcoord3.xy = (mad(cb0_values[7].xxxy, r1_xyzw_7.wwww, (mad(cb0_values[6].xyxx, r1_xyzw_7.zzzz, (mad(_Color.xyxx, r1_xyzw_7.xxxx, ((r1_xyzw_7.yyyy * _MainTex_ST.xyxx)).xyxx)).xyxx)).xxxy)).zw;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_w_4 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7));
                float r0_w_5 = rsqrt(r0_w_4);
                o.texcoord1.xyz = ((r0_w_5.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program42Output frag(program42Input i)
            {
                program42Output o = (program42Output)0;
                float4 r0_xyzw_1 = t0.Sample(s2, i.texcoord0.xyxx);
                float4 r0_xyzw_2 = (r0_xyzw_1 * cb0_values[8].xyzw);
                float r1_z_1 = (unity_ProbeVolumeParams.x == 1);
                float r2_x_10;
                float r2_y_10;
                float r2_z_10;
                float r2_w_4;
                if (r1_z_1)
                {
                    float r1_z_2 = (unity_ProbeVolumeParams.y == 1);
                    float3 r2_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r1_z_2.xxxx ? r2_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r2_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_8 = r2_xyzw_8.z;
                    float r2_w_2 = r2_xyzw_8.w;
                    float r1_z_3 = mad(r2_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r2_x_8 = max(r1_w_1, r1_z_3);
                    float4 r2_xyzw_9 = t2.Sample(s0, float4(r2_x_8, r2_z_8, r2_w_2, r2_x_8));
                    r2_x_10 = r2_xyzw_9.x;
                    r2_y_10 = r2_xyzw_9.y;
                    r2_z_10 = r2_xyzw_9.z;
                    r2_w_4 = r2_xyzw_9.w;
                }
                else
                {
                    float4 r2_xyzw_10 = float4(1, 1, 1, 1);
                    r2_x_10 = r2_xyzw_10.x;
                    r2_y_10 = r2_xyzw_10.y;
                    r2_z_10 = r2_xyzw_10.z;
                    r2_w_4 = r2_xyzw_10.w;
                }
                float r1_z_5 = dot(float4(r2_x_10, r2_y_10, r2_z_10, r2_w_4), unity_OcclusionMaskSelector);
                float4 r2_xyzw_11 = t1.Sample(s1, (((mad(cb0_values[6].xyxx, i.texcoord2.zzzz, (mad(cb0_values[4].xyxx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx);
                float4 r1_xyzw_6 = (((r1_z_5 * r2_xyzw_11.w)).xxxx * _LightColor0.xyzx);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_5 = r1_xyzw_6.y;
                float r1_z_6 = r1_xyzw_6.z;
                float r1_w_3 = dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx);
                float r1_w_4 = max(r1_w_3, 0);
                float TEXCOORD1_x_7 = i.texcoord4.x;
                o.sv_Target0.xyz = ((((r1_w_4.xxxx * ((r0_xyzw_2.xyzx * float4(r1_x_6, r1_y_5, r1_z_6, r1_x_6))).xyzx)).xyzx * TEXCOORD1_x_7.xxxx)).xyz;
                o.sv_Target0.w = r0_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityPerFrame : register(b2)
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
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[2];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            SamplerState s3 : register(s3);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            TextureCube t2 : register(t2);
            Texture3D t3 : register(t3);
            struct program27Input
            {
                float4 position0 : POSITION0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program27Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program41Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program41Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program27Output vert(program27Input i)
            {
                program27Output o = (program27Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = clipPos_xyzw_2;
                o.texcoord4.x = mad(max((((clipPos_xyzw_2.z / unity_WorldToObject[1].y) + 1) * unity_WorldToObject[1].z), 0), cb4_values[1].z, cb4_values[1].w);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7))).xyz;
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 r1_xyzw_8 = (r0_xyzw_4.yyyy * _MainTex_ST);
                float4 r1_xyzw_9 = mad(_Color, r0_xyzw_4.xxxx, r1_xyzw_8);
                float4 r1_xyzw_10 = mad(cb0_values[6].xyzw, r0_xyzw_4.zzzz, r1_xyzw_9);
                o.texcoord3.xyzw = mad(cb0_values[7].xyzw, r0_xyzw_4.wwww, r1_xyzw_10);
                return o;
            }
            #pragma fragment frag
            program41Output frag(program41Input i)
            {
                program41Output o = (program41Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = t0.Sample(s3, i.texcoord0.xyxx);
                float4 r1_xyzw_2 = (r1_xyzw_1 * cb0_values[8].xyzw);
                float3 r2_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r2_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r2_w_1);
                    float4 r3_xyzw_9 = t3.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
                    r3_x_10 = r3_xyzw_9.x;
                    r3_y_10 = r3_xyzw_9.y;
                    r3_z_10 = r3_xyzw_9.z;
                    r3_w_4 = r3_xyzw_9.w;
                }
                else
                {
                    float4 r3_xyzw_10 = float4(1, 1, 1, 1);
                    r3_x_10 = r3_xyzw_10.x;
                    r3_y_10 = r3_xyzw_10.y;
                    r3_z_10 = r3_xyzw_10.z;
                    r3_w_4 = r3_xyzw_10.w;
                }
                float r0_w_7 = dot(float4(r3_x_10, r3_y_10, r3_z_10, r3_w_4), unity_OcclusionMaskSelector);
                float r2_w_3 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float4 r3_xyzw_11 = t1.Sample(s2, r2_w_3.xxxx);
                float4 r2_xyzw_5 = t2.Sample(s1, r2_xyz_4.xyzx);
                float r0_w_8 = (r0_w_7 * (r2_xyzw_5.w * r3_xyzw_11.x));
                float4 r2_xyzw_7 = (r0_w_8.xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_6 = r2_xyzw_7.y;
                float r2_z_6 = r2_xyzw_7.z;
                float4 r0_xyzw_3 = (r1_xyzw_2.xxyz * float4(r2_x_7, r2_x_7, r2_y_6, r2_z_6));
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                float4 r0_xyzw_5 = ((max(dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float TEXCOORD0_w_10 = i.texcoord4.x;
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5) * TEXCOORD0_w_10.xxxx)).xyz;
                o.sv_Target0.w = r1_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityPerFrame : register(b2)
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
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[2];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            SamplerState s3 : register(s3);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture2D t2 : register(t2);
            Texture3D t3 : register(t3);
            struct program27Input
            {
                float4 position0 : POSITION0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program27Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program40Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program40Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program27Output vert(program27Input i)
            {
                program27Output o = (program27Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = clipPos_xyzw_2;
                o.texcoord4.x = mad(max((((clipPos_xyzw_2.z / unity_WorldToObject[1].y) + 1) * unity_WorldToObject[1].z), 0), cb4_values[1].z, cb4_values[1].w);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7))).xyz;
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 r1_xyzw_8 = (r0_xyzw_4.yyyy * _MainTex_ST);
                float4 r1_xyzw_9 = mad(_Color, r0_xyzw_4.xxxx, r1_xyzw_8);
                float4 r1_xyzw_10 = mad(cb0_values[6].xyzw, r0_xyzw_4.zzzz, r1_xyzw_9);
                o.texcoord3.xyzw = mad(cb0_values[7].xyzw, r0_xyzw_4.wwww, r1_xyzw_10);
                return o;
            }
            #pragma fragment frag
            program40Output frag(program40Input i)
            {
                program40Output o = (program40Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = t0.Sample(s3, i.texcoord0.xyxx);
                float4 r1_xyzw_2 = (r1_xyzw_1 * cb0_values[8].xyzw);
                float4 r2_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord2.zzzz, mad(cb0_values[4].xyzw, i.texcoord2.xxxx, (i.texcoord2.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_11;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r3_y_9 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r3_y_9);
                    float4 r3_xyzw_9 = t3.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
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
                float r0_w_7 = dot(float4(r3_x_10, r3_y_11, r3_z_10, r3_w_4), unity_OcclusionMaskSelector);
                float4 r3_xyzw_12 = (r2_xyzw_4.xxyx / r2_xyzw_4.wwww);
                float r3_y_12 = r3_xyzw_12.y;
                float r3_z_11 = r3_xyzw_12.z;
                float4 r3_xyzw_13 = (float4(r3_y_12, r3_y_12, r3_z_11, r3_y_12) + float4(0, 0.5, 0.5, 0));
                float r3_y_13 = r3_xyzw_13.y;
                float r3_z_12 = r3_xyzw_13.z;
                float4 r4_xyzw_1 = t1.Sample(s1, float4(r3_y_13, r3_z_12, r3_y_13, r3_y_13));
                float r2_w_5 = (asfloat(asint((float)((0 < r2_xyzw_4.z))) & asint(1065353216)) * r4_xyzw_1.w);
                float r3_x_13 = (t2.Sample(s2, (dot(r2_xyzw_4.xyzx, r2_xyzw_4.xyzx)).xxxx)).x;
                float4 r3_xyzw_14 = t2.Sample(s2, (dot(r2_xyzw_4.xyzx, r2_xyzw_4.xyzx)).xxxx);
                float r3_y_14 = r3_xyzw_14.y;
                float r3_z_13 = r3_xyzw_14.z;
                float r3_w_5 = r3_xyzw_14.w;
                float r0_w_8 = (r0_w_7 * (r2_w_5 * r3_x_13));
                float4 r2_xyzw_7 = (r0_w_8.xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_5 = r2_xyzw_7.y;
                float r2_z_5 = r2_xyzw_7.z;
                float4 r0_xyzw_3 = (r1_xyzw_2.xxyz * float4(r2_x_7, r2_x_7, r2_y_5, r2_z_5));
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                float4 r0_xyzw_5 = ((max(dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float TEXCOORD0_w_10 = i.texcoord4.x;
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5) * TEXCOORD0_w_10.xxxx)).xyz;
                o.sv_Target0.w = r1_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityPerFrame : register(b2)
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
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[2];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture3D t2 : register(t2);
            struct program27Input
            {
                float4 position0 : POSITION0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program27Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program38Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program38Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program27Output vert(program27Input i)
            {
                program27Output o = (program27Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = clipPos_xyzw_2;
                o.texcoord4.x = mad(max((((clipPos_xyzw_2.z / unity_WorldToObject[1].y) + 1) * unity_WorldToObject[1].z), 0), cb4_values[1].z, cb4_values[1].w);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7))).xyz;
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 r1_xyzw_8 = (r0_xyzw_4.yyyy * _MainTex_ST);
                float4 r1_xyzw_9 = mad(_Color, r0_xyzw_4.xxxx, r1_xyzw_8);
                float4 r1_xyzw_10 = mad(cb0_values[6].xyzw, r0_xyzw_4.zzzz, r1_xyzw_9);
                o.texcoord3.xyzw = mad(cb0_values[7].xyzw, r0_xyzw_4.wwww, r1_xyzw_10);
                return o;
            }
            #pragma fragment frag
            program38Output frag(program38Input i)
            {
                program38Output o = (program38Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = t0.Sample(s2, i.texcoord0.xyxx);
                float4 r1_xyzw_2 = (r1_xyzw_1 * cb0_values[8].xyzw);
                float3 r2_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r2_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r2_w_1);
                    float4 r3_xyzw_9 = t2.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
                    r3_x_10 = r3_xyzw_9.x;
                    r3_y_10 = r3_xyzw_9.y;
                    r3_z_10 = r3_xyzw_9.z;
                    r3_w_4 = r3_xyzw_9.w;
                }
                else
                {
                    float4 r3_xyzw_10 = float4(1, 1, 1, 1);
                    r3_x_10 = r3_xyzw_10.x;
                    r3_y_10 = r3_xyzw_10.y;
                    r3_z_10 = r3_xyzw_10.z;
                    r3_w_4 = r3_xyzw_10.w;
                }
                float r0_w_7 = dot(float4(r3_x_10, r3_y_10, r3_z_10, r3_w_4), unity_OcclusionMaskSelector);
                float4 r2_xyzw_6 = t1.Sample(s1, (dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx)).xxxx);
                float r0_w_8 = (r0_w_7 * r2_xyzw_6.x);
                float4 r2_xyzw_7 = (r0_w_8.xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_6 = r2_xyzw_7.y;
                float r2_z_6 = r2_xyzw_7.z;
                float4 r0_xyzw_3 = (r1_xyzw_2.xxyz * float4(r2_x_7, r2_x_7, r2_y_6, r2_z_6));
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                float4 r0_xyzw_5 = ((max(dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float TEXCOORD0_w_10 = i.texcoord4.x;
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5) * TEXCOORD0_w_10.xxxx)).xyz;
                o.sv_Target0.w = r1_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityPerFrame : register(b2)
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
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[2];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            SamplerState s3 : register(s3);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            TextureCube t2 : register(t2);
            Texture3D t3 : register(t3);
            struct program26Input
            {
                float4 position0 : POSITION0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program26Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program41Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program41Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program26Output vert(program26Input i)
            {
                program26Output o = (program26Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = clipPos_xyzw_2;
                o.texcoord4.x = mad(max((((clipPos_xyzw_2.z / unity_WorldToObject[1].y) + 1) * unity_WorldToObject[1].z), 0), cb4_values[1].z, cb4_values[1].w);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7))).xyz;
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 r1_xyzw_8 = (r0_xyzw_4.yyyy * _MainTex_ST.xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_4 = r1_xyzw_8.y;
                float r1_z_4 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = mad(_Color.xyzx, r0_xyzw_4.xxxx, float4(r1_x_8, r1_y_4, r1_z_4, r1_x_8));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_5 = r1_xyzw_9.y;
                float r1_z_5 = r1_xyzw_9.z;
                o.texcoord3.xyz = (mad(cb0_values[7].xyzx, r0_xyzw_4.wwww, (mad(cb0_values[6].xyzx, r0_xyzw_4.zzzz, float4(r1_x_9, r1_y_5, r1_z_5, r1_x_9))).xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program41Output frag(program41Input i)
            {
                program41Output o = (program41Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = t0.Sample(s3, i.texcoord0.xyxx);
                float4 r1_xyzw_2 = (r1_xyzw_1 * cb0_values[8].xyzw);
                float3 r2_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r2_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r2_w_1);
                    float4 r3_xyzw_9 = t3.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
                    r3_x_10 = r3_xyzw_9.x;
                    r3_y_10 = r3_xyzw_9.y;
                    r3_z_10 = r3_xyzw_9.z;
                    r3_w_4 = r3_xyzw_9.w;
                }
                else
                {
                    float4 r3_xyzw_10 = float4(1, 1, 1, 1);
                    r3_x_10 = r3_xyzw_10.x;
                    r3_y_10 = r3_xyzw_10.y;
                    r3_z_10 = r3_xyzw_10.z;
                    r3_w_4 = r3_xyzw_10.w;
                }
                float r0_w_7 = dot(float4(r3_x_10, r3_y_10, r3_z_10, r3_w_4), unity_OcclusionMaskSelector);
                float r2_w_3 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float4 r3_xyzw_11 = t1.Sample(s2, r2_w_3.xxxx);
                float4 r2_xyzw_5 = t2.Sample(s1, r2_xyz_4.xyzx);
                float r0_w_8 = (r0_w_7 * (r2_xyzw_5.w * r3_xyzw_11.x));
                float4 r2_xyzw_7 = (r0_w_8.xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_6 = r2_xyzw_7.y;
                float r2_z_6 = r2_xyzw_7.z;
                float4 r0_xyzw_3 = (r1_xyzw_2.xxyz * float4(r2_x_7, r2_x_7, r2_y_6, r2_z_6));
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                float4 r0_xyzw_5 = ((max(dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float TEXCOORD0_w_10 = i.texcoord4.x;
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5) * TEXCOORD0_w_10.xxxx)).xyz;
                o.sv_Target0.w = r1_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityPerFrame : register(b2)
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
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[2];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            SamplerState s3 : register(s3);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture2D t2 : register(t2);
            Texture3D t3 : register(t3);
            struct program26Input
            {
                float4 position0 : POSITION0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program26Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program40Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program40Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program26Output vert(program26Input i)
            {
                program26Output o = (program26Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = clipPos_xyzw_2;
                o.texcoord4.x = mad(max((((clipPos_xyzw_2.z / unity_WorldToObject[1].y) + 1) * unity_WorldToObject[1].z), 0), cb4_values[1].z, cb4_values[1].w);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7))).xyz;
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 r1_xyzw_8 = (r0_xyzw_4.yyyy * _MainTex_ST.xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_4 = r1_xyzw_8.y;
                float r1_z_4 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = mad(_Color.xyzx, r0_xyzw_4.xxxx, float4(r1_x_8, r1_y_4, r1_z_4, r1_x_8));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_5 = r1_xyzw_9.y;
                float r1_z_5 = r1_xyzw_9.z;
                o.texcoord3.xyz = (mad(cb0_values[7].xyzx, r0_xyzw_4.wwww, (mad(cb0_values[6].xyzx, r0_xyzw_4.zzzz, float4(r1_x_9, r1_y_5, r1_z_5, r1_x_9))).xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program40Output frag(program40Input i)
            {
                program40Output o = (program40Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = t0.Sample(s3, i.texcoord0.xyxx);
                float4 r1_xyzw_2 = (r1_xyzw_1 * cb0_values[8].xyzw);
                float4 r2_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord2.zzzz, mad(cb0_values[4].xyzw, i.texcoord2.xxxx, (i.texcoord2.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_11;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r3_y_9 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r3_y_9);
                    float4 r3_xyzw_9 = t3.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
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
                float r0_w_7 = dot(float4(r3_x_10, r3_y_11, r3_z_10, r3_w_4), unity_OcclusionMaskSelector);
                float4 r3_xyzw_12 = (r2_xyzw_4.xxyx / r2_xyzw_4.wwww);
                float r3_y_12 = r3_xyzw_12.y;
                float r3_z_11 = r3_xyzw_12.z;
                float4 r3_xyzw_13 = (float4(r3_y_12, r3_y_12, r3_z_11, r3_y_12) + float4(0, 0.5, 0.5, 0));
                float r3_y_13 = r3_xyzw_13.y;
                float r3_z_12 = r3_xyzw_13.z;
                float4 r4_xyzw_1 = t1.Sample(s1, float4(r3_y_13, r3_z_12, r3_y_13, r3_y_13));
                float r2_w_5 = (asfloat(asint((float)((0 < r2_xyzw_4.z))) & asint(1065353216)) * r4_xyzw_1.w);
                float r3_x_13 = (t2.Sample(s2, (dot(r2_xyzw_4.xyzx, r2_xyzw_4.xyzx)).xxxx)).x;
                float4 r3_xyzw_14 = t2.Sample(s2, (dot(r2_xyzw_4.xyzx, r2_xyzw_4.xyzx)).xxxx);
                float r3_y_14 = r3_xyzw_14.y;
                float r3_z_13 = r3_xyzw_14.z;
                float r3_w_5 = r3_xyzw_14.w;
                float r0_w_8 = (r0_w_7 * (r2_w_5 * r3_x_13));
                float4 r2_xyzw_7 = (r0_w_8.xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_5 = r2_xyzw_7.y;
                float r2_z_5 = r2_xyzw_7.z;
                float4 r0_xyzw_3 = (r1_xyzw_2.xxyz * float4(r2_x_7, r2_x_7, r2_y_5, r2_z_5));
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                float4 r0_xyzw_5 = ((max(dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float TEXCOORD0_w_10 = i.texcoord4.x;
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5) * TEXCOORD0_w_10.xxxx)).xyz;
                o.sv_Target0.w = r1_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityPerFrame : register(b2)
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
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[2];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture3D t2 : register(t2);
            struct program26Input
            {
                float4 position0 : POSITION0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program26Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program38Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program38Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program26Output vert(program26Input i)
            {
                program26Output o = (program26Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = clipPos_xyzw_2;
                o.texcoord4.x = mad(max((((clipPos_xyzw_2.z / unity_WorldToObject[1].y) + 1) * unity_WorldToObject[1].z), 0), cb4_values[1].z, cb4_values[1].w);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7))).xyz;
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 r1_xyzw_8 = (r0_xyzw_4.yyyy * _MainTex_ST.xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_4 = r1_xyzw_8.y;
                float r1_z_4 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = mad(_Color.xyzx, r0_xyzw_4.xxxx, float4(r1_x_8, r1_y_4, r1_z_4, r1_x_8));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_5 = r1_xyzw_9.y;
                float r1_z_5 = r1_xyzw_9.z;
                o.texcoord3.xyz = (mad(cb0_values[7].xyzx, r0_xyzw_4.wwww, (mad(cb0_values[6].xyzx, r0_xyzw_4.zzzz, float4(r1_x_9, r1_y_5, r1_z_5, r1_x_9))).xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program38Output frag(program38Input i)
            {
                program38Output o = (program38Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = t0.Sample(s2, i.texcoord0.xyxx);
                float4 r1_xyzw_2 = (r1_xyzw_1 * cb0_values[8].xyzw);
                float3 r2_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r2_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r2_w_1);
                    float4 r3_xyzw_9 = t2.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
                    r3_x_10 = r3_xyzw_9.x;
                    r3_y_10 = r3_xyzw_9.y;
                    r3_z_10 = r3_xyzw_9.z;
                    r3_w_4 = r3_xyzw_9.w;
                }
                else
                {
                    float4 r3_xyzw_10 = float4(1, 1, 1, 1);
                    r3_x_10 = r3_xyzw_10.x;
                    r3_y_10 = r3_xyzw_10.y;
                    r3_z_10 = r3_xyzw_10.z;
                    r3_w_4 = r3_xyzw_10.w;
                }
                float r0_w_7 = dot(float4(r3_x_10, r3_y_10, r3_z_10, r3_w_4), unity_OcclusionMaskSelector);
                float4 r2_xyzw_6 = t1.Sample(s1, (dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx)).xxxx);
                float r0_w_8 = (r0_w_7 * r2_xyzw_6.x);
                float4 r2_xyzw_7 = (r0_w_8.xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_6 = r2_xyzw_7.y;
                float r2_z_6 = r2_xyzw_7.z;
                float4 r0_xyzw_3 = (r1_xyzw_2.xxyz * float4(r2_x_7, r2_x_7, r2_y_6, r2_z_6));
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                float4 r0_xyzw_5 = ((max(dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float TEXCOORD0_w_10 = i.texcoord4.x;
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5) * TEXCOORD0_w_10.xxxx)).xyz;
                o.sv_Target0.w = r1_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture3D t2 : register(t2);
            struct program25Input
            {
                float4 position0 : POSITION0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program25Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program42Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float texcoord4 : TEXCOORD4;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program42Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program25Output vert(program25Input i)
            {
                program25Output o = (program25Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                worldPos_xyzw_2 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float2 clipPos_xy_4 = ((worldPos_xyzw_2.yyyy * _MainTex_ST.xyxx)).xy;
                float2 clipPos_xy_5 = (mad(_Color.xyxx, worldPos_xyzw_2.xxxx, clipPos_xy_4.xyxx)).xy;
                float2 clipPos_xy_6 = (mad(cb0_values[6].xyxx, worldPos_xyzw_2.zzzz, clipPos_xy_5.xyxx)).xy;
                o.texcoord3.xy = (mad(cb0_values[7].xxxy, worldPos_xyzw_2.wwww, clipPos_xy_6.xxxy)).zw;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_4 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7));
                float r0_w_5 = rsqrt(r0_w_4);
                o.texcoord1.xyz = ((r0_w_5.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program42Output frag(program42Input i)
            {
                program42Output o = (program42Output)0;
                float4 r0_xyzw_1 = t0.Sample(s2, i.texcoord0.xyxx);
                float4 r0_xyzw_2 = (r0_xyzw_1 * cb0_values[8].xyzw);
                float r1_z_1 = (unity_ProbeVolumeParams.x == 1);
                float r2_x_10;
                float r2_y_10;
                float r2_z_10;
                float r2_w_4;
                if (r1_z_1)
                {
                    float r1_z_2 = (unity_ProbeVolumeParams.y == 1);
                    float3 r2_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r1_z_2.xxxx ? r2_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r2_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_8 = r2_xyzw_8.z;
                    float r2_w_2 = r2_xyzw_8.w;
                    float r1_z_3 = mad(r2_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r2_x_8 = max(r1_w_1, r1_z_3);
                    float4 r2_xyzw_9 = t2.Sample(s0, float4(r2_x_8, r2_z_8, r2_w_2, r2_x_8));
                    r2_x_10 = r2_xyzw_9.x;
                    r2_y_10 = r2_xyzw_9.y;
                    r2_z_10 = r2_xyzw_9.z;
                    r2_w_4 = r2_xyzw_9.w;
                }
                else
                {
                    float4 r2_xyzw_10 = float4(1, 1, 1, 1);
                    r2_x_10 = r2_xyzw_10.x;
                    r2_y_10 = r2_xyzw_10.y;
                    r2_z_10 = r2_xyzw_10.z;
                    r2_w_4 = r2_xyzw_10.w;
                }
                float r1_z_5 = dot(float4(r2_x_10, r2_y_10, r2_z_10, r2_w_4), unity_OcclusionMaskSelector);
                float4 r2_xyzw_11 = t1.Sample(s1, (((mad(cb0_values[6].xyxx, i.texcoord2.zzzz, (mad(cb0_values[4].xyxx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx);
                float4 r1_xyzw_6 = (((r1_z_5 * r2_xyzw_11.w)).xxxx * _LightColor0.xyzx);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_5 = r1_xyzw_6.y;
                float r1_z_6 = r1_xyzw_6.z;
                float r1_w_3 = dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx);
                float r1_w_4 = max(r1_w_3, 0);
                float TEXCOORD1_x_7 = i.texcoord4.x;
                o.sv_Target0.xyz = ((((r1_w_4.xxxx * ((r0_xyzw_2.xyzx * float4(r1_x_6, r1_y_5, r1_z_6, r1_x_6))).xyzx)).xyzx * TEXCOORD1_x_7.xxxx)).xyz;
                o.sv_Target0.w = r0_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture3D t2 : register(t2);
            struct program25Input
            {
                float4 position0 : POSITION0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program25Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program37Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program37Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program25Output vert(program25Input i)
            {
                program25Output o = (program25Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                worldPos_xyzw_2 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float2 clipPos_xy_4 = ((worldPos_xyzw_2.yyyy * _MainTex_ST.xyxx)).xy;
                float2 clipPos_xy_5 = (mad(_Color.xyxx, worldPos_xyzw_2.xxxx, clipPos_xy_4.xyxx)).xy;
                float2 clipPos_xy_6 = (mad(cb0_values[6].xyxx, worldPos_xyzw_2.zzzz, clipPos_xy_5.xyxx)).xy;
                o.texcoord3.xy = (mad(cb0_values[7].xxxy, worldPos_xyzw_2.wwww, clipPos_xy_6.xxxy)).zw;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_4 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7));
                float r0_w_5 = rsqrt(r0_w_4);
                o.texcoord1.xyz = ((r0_w_5.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program37Output frag(program37Input i)
            {
                program37Output o = (program37Output)0;
                float4 r0_xyzw_1 = t0.Sample(s2, i.texcoord0.xyxx);
                float4 r0_xyzw_2 = (r0_xyzw_1 * cb0_values[8].xyzw);
                float r1_z_1 = (unity_ProbeVolumeParams.x == 1);
                float r2_x_10;
                float r2_y_10;
                float r2_z_10;
                float r2_w_4;
                if (r1_z_1)
                {
                    float r1_z_2 = (unity_ProbeVolumeParams.y == 1);
                    float3 r2_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r1_z_2.xxxx ? r2_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r2_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_8 = r2_xyzw_8.z;
                    float r2_w_2 = r2_xyzw_8.w;
                    float r1_z_3 = mad(r2_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r2_x_8 = max(r1_w_1, r1_z_3);
                    float4 r2_xyzw_9 = t2.Sample(s0, float4(r2_x_8, r2_z_8, r2_w_2, r2_x_8));
                    r2_x_10 = r2_xyzw_9.x;
                    r2_y_10 = r2_xyzw_9.y;
                    r2_z_10 = r2_xyzw_9.z;
                    r2_w_4 = r2_xyzw_9.w;
                }
                else
                {
                    float4 r2_xyzw_10 = float4(1, 1, 1, 1);
                    r2_x_10 = r2_xyzw_10.x;
                    r2_y_10 = r2_xyzw_10.y;
                    r2_z_10 = r2_xyzw_10.z;
                    r2_w_4 = r2_xyzw_10.w;
                }
                float r1_z_5 = dot(float4(r2_x_10, r2_y_10, r2_z_10, r2_w_4), unity_OcclusionMaskSelector);
                float4 r2_xyzw_11 = t1.Sample(s1, (((mad(cb0_values[6].xyxx, i.texcoord2.zzzz, (mad(cb0_values[4].xyxx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx);
                float4 r1_xyzw_6 = (((r1_z_5 * r2_xyzw_11.w)).xxxx * _LightColor0.xyzx);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_5 = r1_xyzw_6.y;
                float r1_z_6 = r1_xyzw_6.z;
                float r1_w_3 = dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx);
                float r1_w_4 = max(r1_w_3, 0);
                o.sv_Target0.xyz = ((r1_w_4.xxxx * ((r0_xyzw_2.xyzx * float4(r1_x_6, r1_y_5, r1_z_6, r1_x_6))).xyzx)).xyz;
                o.sv_Target0.w = r0_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            SamplerState s3 : register(s3);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            TextureCube t2 : register(t2);
            Texture3D t3 : register(t3);
            struct program23Input
            {
                float4 position0 : POSITION0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program23Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program41Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program41Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program23Output vert(program23Input i)
            {
                program23Output o = (program23Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float clipPos_x_3 = ((worldPos_xyzw_4.yyyy * _MainTex_ST)).x;
                float clipPos_y_3 = ((worldPos_xyzw_4.yyyy * _MainTex_ST)).y;
                float clipPos_z_3 = ((worldPos_xyzw_4.yyyy * _MainTex_ST)).z;
                float clipPos_w_4 = ((worldPos_xyzw_4.yyyy * _MainTex_ST)).w;
                float4 clipPos_xyzw_4 = mad(_Color, worldPos_xyzw_4.xxxx, float4(clipPos_x_3, clipPos_y_3, clipPos_z_3, clipPos_w_4));
                float4 clipPos_xyzw_5 = mad(cb0_values[6].xyzw, worldPos_xyzw_4.zzzz, clipPos_xyzw_4);
                o.texcoord3.xyzw = mad(cb0_values[7].xyzw, worldPos_xyzw_4.wwww, clipPos_xyzw_5);
                return o;
            }
            #pragma fragment frag
            program41Output frag(program41Input i)
            {
                program41Output o = (program41Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = t0.Sample(s3, i.texcoord0.xyxx);
                float4 r1_xyzw_2 = (r1_xyzw_1 * cb0_values[8].xyzw);
                float3 r2_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r2_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r2_w_1);
                    float4 r3_xyzw_9 = t3.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
                    r3_x_10 = r3_xyzw_9.x;
                    r3_y_10 = r3_xyzw_9.y;
                    r3_z_10 = r3_xyzw_9.z;
                    r3_w_4 = r3_xyzw_9.w;
                }
                else
                {
                    float4 r3_xyzw_10 = float4(1, 1, 1, 1);
                    r3_x_10 = r3_xyzw_10.x;
                    r3_y_10 = r3_xyzw_10.y;
                    r3_z_10 = r3_xyzw_10.z;
                    r3_w_4 = r3_xyzw_10.w;
                }
                float r0_w_7 = dot(float4(r3_x_10, r3_y_10, r3_z_10, r3_w_4), unity_OcclusionMaskSelector);
                float r2_w_3 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float4 r3_xyzw_11 = t1.Sample(s2, r2_w_3.xxxx);
                float4 r2_xyzw_5 = t2.Sample(s1, r2_xyz_4.xyzx);
                float r0_w_8 = (r0_w_7 * (r2_xyzw_5.w * r3_xyzw_11.x));
                float4 r2_xyzw_7 = (r0_w_8.xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_6 = r2_xyzw_7.y;
                float r2_z_6 = r2_xyzw_7.z;
                float4 r0_xyzw_3 = (r1_xyzw_2.xxyz * float4(r2_x_7, r2_x_7, r2_y_6, r2_z_6));
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                float4 r0_xyzw_5 = ((max(dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float TEXCOORD0_w_10 = i.texcoord4.x;
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5) * TEXCOORD0_w_10.xxxx)).xyz;
                o.sv_Target0.w = r1_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            SamplerState s3 : register(s3);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture2D t2 : register(t2);
            Texture3D t3 : register(t3);
            struct program23Input
            {
                float4 position0 : POSITION0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program23Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program40Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program40Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program23Output vert(program23Input i)
            {
                program23Output o = (program23Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float clipPos_x_3 = ((worldPos_xyzw_4.yyyy * _MainTex_ST)).x;
                float clipPos_y_3 = ((worldPos_xyzw_4.yyyy * _MainTex_ST)).y;
                float clipPos_z_3 = ((worldPos_xyzw_4.yyyy * _MainTex_ST)).z;
                float clipPos_w_4 = ((worldPos_xyzw_4.yyyy * _MainTex_ST)).w;
                float4 clipPos_xyzw_4 = mad(_Color, worldPos_xyzw_4.xxxx, float4(clipPos_x_3, clipPos_y_3, clipPos_z_3, clipPos_w_4));
                float4 clipPos_xyzw_5 = mad(cb0_values[6].xyzw, worldPos_xyzw_4.zzzz, clipPos_xyzw_4);
                o.texcoord3.xyzw = mad(cb0_values[7].xyzw, worldPos_xyzw_4.wwww, clipPos_xyzw_5);
                return o;
            }
            #pragma fragment frag
            program40Output frag(program40Input i)
            {
                program40Output o = (program40Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = t0.Sample(s3, i.texcoord0.xyxx);
                float4 r1_xyzw_2 = (r1_xyzw_1 * cb0_values[8].xyzw);
                float4 r2_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord2.zzzz, mad(cb0_values[4].xyzw, i.texcoord2.xxxx, (i.texcoord2.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_11;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r3_y_9 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r3_y_9);
                    float4 r3_xyzw_9 = t3.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
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
                float r0_w_7 = dot(float4(r3_x_10, r3_y_11, r3_z_10, r3_w_4), unity_OcclusionMaskSelector);
                float4 r3_xyzw_12 = (r2_xyzw_4.xxyx / r2_xyzw_4.wwww);
                float r3_y_12 = r3_xyzw_12.y;
                float r3_z_11 = r3_xyzw_12.z;
                float4 r3_xyzw_13 = (float4(r3_y_12, r3_y_12, r3_z_11, r3_y_12) + float4(0, 0.5, 0.5, 0));
                float r3_y_13 = r3_xyzw_13.y;
                float r3_z_12 = r3_xyzw_13.z;
                float4 r4_xyzw_1 = t1.Sample(s1, float4(r3_y_13, r3_z_12, r3_y_13, r3_y_13));
                float r2_w_5 = (asfloat(asint((float)((0 < r2_xyzw_4.z))) & asint(1065353216)) * r4_xyzw_1.w);
                float r3_x_13 = (t2.Sample(s2, (dot(r2_xyzw_4.xyzx, r2_xyzw_4.xyzx)).xxxx)).x;
                float4 r3_xyzw_14 = t2.Sample(s2, (dot(r2_xyzw_4.xyzx, r2_xyzw_4.xyzx)).xxxx);
                float r3_y_14 = r3_xyzw_14.y;
                float r3_z_13 = r3_xyzw_14.z;
                float r3_w_5 = r3_xyzw_14.w;
                float r0_w_8 = (r0_w_7 * (r2_w_5 * r3_x_13));
                float4 r2_xyzw_7 = (r0_w_8.xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_5 = r2_xyzw_7.y;
                float r2_z_5 = r2_xyzw_7.z;
                float4 r0_xyzw_3 = (r1_xyzw_2.xxyz * float4(r2_x_7, r2_x_7, r2_y_5, r2_z_5));
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                float4 r0_xyzw_5 = ((max(dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float TEXCOORD0_w_10 = i.texcoord4.x;
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5) * TEXCOORD0_w_10.xxxx)).xyz;
                o.sv_Target0.w = r1_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture3D t2 : register(t2);
            struct program23Input
            {
                float4 position0 : POSITION0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program23Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program38Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program38Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program23Output vert(program23Input i)
            {
                program23Output o = (program23Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float clipPos_x_3 = ((worldPos_xyzw_4.yyyy * _MainTex_ST)).x;
                float clipPos_y_3 = ((worldPos_xyzw_4.yyyy * _MainTex_ST)).y;
                float clipPos_z_3 = ((worldPos_xyzw_4.yyyy * _MainTex_ST)).z;
                float clipPos_w_4 = ((worldPos_xyzw_4.yyyy * _MainTex_ST)).w;
                float4 clipPos_xyzw_4 = mad(_Color, worldPos_xyzw_4.xxxx, float4(clipPos_x_3, clipPos_y_3, clipPos_z_3, clipPos_w_4));
                float4 clipPos_xyzw_5 = mad(cb0_values[6].xyzw, worldPos_xyzw_4.zzzz, clipPos_xyzw_4);
                o.texcoord3.xyzw = mad(cb0_values[7].xyzw, worldPos_xyzw_4.wwww, clipPos_xyzw_5);
                return o;
            }
            #pragma fragment frag
            program38Output frag(program38Input i)
            {
                program38Output o = (program38Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = t0.Sample(s2, i.texcoord0.xyxx);
                float4 r1_xyzw_2 = (r1_xyzw_1 * cb0_values[8].xyzw);
                float3 r2_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r2_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r2_w_1);
                    float4 r3_xyzw_9 = t2.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
                    r3_x_10 = r3_xyzw_9.x;
                    r3_y_10 = r3_xyzw_9.y;
                    r3_z_10 = r3_xyzw_9.z;
                    r3_w_4 = r3_xyzw_9.w;
                }
                else
                {
                    float4 r3_xyzw_10 = float4(1, 1, 1, 1);
                    r3_x_10 = r3_xyzw_10.x;
                    r3_y_10 = r3_xyzw_10.y;
                    r3_z_10 = r3_xyzw_10.z;
                    r3_w_4 = r3_xyzw_10.w;
                }
                float r0_w_7 = dot(float4(r3_x_10, r3_y_10, r3_z_10, r3_w_4), unity_OcclusionMaskSelector);
                float4 r2_xyzw_6 = t1.Sample(s1, (dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx)).xxxx);
                float r0_w_8 = (r0_w_7 * r2_xyzw_6.x);
                float4 r2_xyzw_7 = (r0_w_8.xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_6 = r2_xyzw_7.y;
                float r2_z_6 = r2_xyzw_7.z;
                float4 r0_xyzw_3 = (r1_xyzw_2.xxyz * float4(r2_x_7, r2_x_7, r2_y_6, r2_z_6));
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                float4 r0_xyzw_5 = ((max(dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float TEXCOORD0_w_10 = i.texcoord4.x;
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5) * TEXCOORD0_w_10.xxxx)).xyz;
                o.sv_Target0.w = r1_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            SamplerState s3 : register(s3);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            TextureCube t2 : register(t2);
            Texture3D t3 : register(t3);
            struct program23Input
            {
                float4 position0 : POSITION0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program23Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program36Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program36Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program23Output vert(program23Input i)
            {
                program23Output o = (program23Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float clipPos_x_3 = ((worldPos_xyzw_4.yyyy * _MainTex_ST)).x;
                float clipPos_y_3 = ((worldPos_xyzw_4.yyyy * _MainTex_ST)).y;
                float clipPos_z_3 = ((worldPos_xyzw_4.yyyy * _MainTex_ST)).z;
                float clipPos_w_4 = ((worldPos_xyzw_4.yyyy * _MainTex_ST)).w;
                float4 clipPos_xyzw_4 = mad(_Color, worldPos_xyzw_4.xxxx, float4(clipPos_x_3, clipPos_y_3, clipPos_z_3, clipPos_w_4));
                float4 clipPos_xyzw_5 = mad(cb0_values[6].xyzw, worldPos_xyzw_4.zzzz, clipPos_xyzw_4);
                o.texcoord3.xyzw = mad(cb0_values[7].xyzw, worldPos_xyzw_4.wwww, clipPos_xyzw_5);
                return o;
            }
            #pragma fragment frag
            program36Output frag(program36Input i)
            {
                program36Output o = (program36Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = t0.Sample(s3, i.texcoord0.xyxx);
                float4 r1_xyzw_2 = (r1_xyzw_1 * cb0_values[8].xyzw);
                float3 r2_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r2_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r2_w_1);
                    float4 r3_xyzw_9 = t3.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
                    r3_x_10 = r3_xyzw_9.x;
                    r3_y_10 = r3_xyzw_9.y;
                    r3_z_10 = r3_xyzw_9.z;
                    r3_w_4 = r3_xyzw_9.w;
                }
                else
                {
                    float4 r3_xyzw_10 = float4(1, 1, 1, 1);
                    r3_x_10 = r3_xyzw_10.x;
                    r3_y_10 = r3_xyzw_10.y;
                    r3_z_10 = r3_xyzw_10.z;
                    r3_w_4 = r3_xyzw_10.w;
                }
                float r0_w_7 = dot(float4(r3_x_10, r3_y_10, r3_z_10, r3_w_4), unity_OcclusionMaskSelector);
                float r2_w_3 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float4 r3_xyzw_11 = t1.Sample(s2, r2_w_3.xxxx);
                float4 r2_xyzw_5 = t2.Sample(s1, r2_xyz_4.xyzx);
                float r0_w_8 = (r0_w_7 * (r2_xyzw_5.w * r3_xyzw_11.x));
                float4 r2_xyzw_7 = (r0_w_8.xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_6 = r2_xyzw_7.y;
                float r2_z_6 = r2_xyzw_7.z;
                float4 r0_xyzw_3 = (r1_xyzw_2.xxyz * float4(r2_x_7, r2_x_7, r2_y_6, r2_z_6));
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                o.sv_Target0.xyz = (((max(dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3))).xyz;
                o.sv_Target0.w = r1_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            SamplerState s3 : register(s3);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture2D t2 : register(t2);
            Texture3D t3 : register(t3);
            struct program23Input
            {
                float4 position0 : POSITION0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program23Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program35Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program35Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program23Output vert(program23Input i)
            {
                program23Output o = (program23Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float clipPos_x_3 = ((worldPos_xyzw_4.yyyy * _MainTex_ST)).x;
                float clipPos_y_3 = ((worldPos_xyzw_4.yyyy * _MainTex_ST)).y;
                float clipPos_z_3 = ((worldPos_xyzw_4.yyyy * _MainTex_ST)).z;
                float clipPos_w_4 = ((worldPos_xyzw_4.yyyy * _MainTex_ST)).w;
                float4 clipPos_xyzw_4 = mad(_Color, worldPos_xyzw_4.xxxx, float4(clipPos_x_3, clipPos_y_3, clipPos_z_3, clipPos_w_4));
                float4 clipPos_xyzw_5 = mad(cb0_values[6].xyzw, worldPos_xyzw_4.zzzz, clipPos_xyzw_4);
                o.texcoord3.xyzw = mad(cb0_values[7].xyzw, worldPos_xyzw_4.wwww, clipPos_xyzw_5);
                return o;
            }
            #pragma fragment frag
            program35Output frag(program35Input i)
            {
                program35Output o = (program35Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = t0.Sample(s3, i.texcoord0.xyxx);
                float4 r1_xyzw_2 = (r1_xyzw_1 * cb0_values[8].xyzw);
                float4 r2_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord2.zzzz, mad(cb0_values[4].xyzw, i.texcoord2.xxxx, (i.texcoord2.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_11;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r3_y_9 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r3_y_9);
                    float4 r3_xyzw_9 = t3.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
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
                float r0_w_7 = dot(float4(r3_x_10, r3_y_11, r3_z_10, r3_w_4), unity_OcclusionMaskSelector);
                float4 r3_xyzw_12 = (r2_xyzw_4.xxyx / r2_xyzw_4.wwww);
                float r3_y_12 = r3_xyzw_12.y;
                float r3_z_11 = r3_xyzw_12.z;
                float4 r3_xyzw_13 = (float4(r3_y_12, r3_y_12, r3_z_11, r3_y_12) + float4(0, 0.5, 0.5, 0));
                float r3_y_13 = r3_xyzw_13.y;
                float r3_z_12 = r3_xyzw_13.z;
                float4 r4_xyzw_1 = t1.Sample(s1, float4(r3_y_13, r3_z_12, r3_y_13, r3_y_13));
                float r2_w_5 = (asfloat(asint((float)((0 < r2_xyzw_4.z))) & asint(1065353216)) * r4_xyzw_1.w);
                float r3_x_13 = (t2.Sample(s2, (dot(r2_xyzw_4.xyzx, r2_xyzw_4.xyzx)).xxxx)).x;
                float4 r3_xyzw_14 = t2.Sample(s2, (dot(r2_xyzw_4.xyzx, r2_xyzw_4.xyzx)).xxxx);
                float r3_y_14 = r3_xyzw_14.y;
                float r3_z_13 = r3_xyzw_14.z;
                float r3_w_5 = r3_xyzw_14.w;
                float r0_w_8 = (r0_w_7 * (r2_w_5 * r3_x_13));
                float4 r2_xyzw_7 = (r0_w_8.xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_5 = r2_xyzw_7.y;
                float r2_z_5 = r2_xyzw_7.z;
                float4 r0_xyzw_3 = (r1_xyzw_2.xxyz * float4(r2_x_7, r2_x_7, r2_y_5, r2_z_5));
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                o.sv_Target0.xyz = (((max(dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3))).xyz;
                o.sv_Target0.w = r1_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture3D t2 : register(t2);
            struct program23Input
            {
                float4 position0 : POSITION0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program23Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program34Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program34Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program23Output vert(program23Input i)
            {
                program23Output o = (program23Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float clipPos_x_3 = ((worldPos_xyzw_4.yyyy * _MainTex_ST)).x;
                float clipPos_y_3 = ((worldPos_xyzw_4.yyyy * _MainTex_ST)).y;
                float clipPos_z_3 = ((worldPos_xyzw_4.yyyy * _MainTex_ST)).z;
                float clipPos_w_4 = ((worldPos_xyzw_4.yyyy * _MainTex_ST)).w;
                float4 clipPos_xyzw_4 = mad(_Color, worldPos_xyzw_4.xxxx, float4(clipPos_x_3, clipPos_y_3, clipPos_z_3, clipPos_w_4));
                float4 clipPos_xyzw_5 = mad(cb0_values[6].xyzw, worldPos_xyzw_4.zzzz, clipPos_xyzw_4);
                o.texcoord3.xyzw = mad(cb0_values[7].xyzw, worldPos_xyzw_4.wwww, clipPos_xyzw_5);
                return o;
            }
            #pragma fragment frag
            program34Output frag(program34Input i)
            {
                program34Output o = (program34Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = t0.Sample(s2, i.texcoord0.xyxx);
                float4 r1_xyzw_2 = (r1_xyzw_1 * cb0_values[8].xyzw);
                float3 r2_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r2_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r2_w_1);
                    float4 r3_xyzw_9 = t2.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
                    r3_x_10 = r3_xyzw_9.x;
                    r3_y_10 = r3_xyzw_9.y;
                    r3_z_10 = r3_xyzw_9.z;
                    r3_w_4 = r3_xyzw_9.w;
                }
                else
                {
                    float4 r3_xyzw_10 = float4(1, 1, 1, 1);
                    r3_x_10 = r3_xyzw_10.x;
                    r3_y_10 = r3_xyzw_10.y;
                    r3_z_10 = r3_xyzw_10.z;
                    r3_w_4 = r3_xyzw_10.w;
                }
                float r0_w_7 = dot(float4(r3_x_10, r3_y_10, r3_z_10, r3_w_4), unity_OcclusionMaskSelector);
                float4 r2_xyzw_6 = t1.Sample(s1, (dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx)).xxxx);
                float r0_w_8 = (r0_w_7 * r2_xyzw_6.x);
                float4 r2_xyzw_7 = (r0_w_8.xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_6 = r2_xyzw_7.y;
                float r2_z_6 = r2_xyzw_7.z;
                float4 r0_xyzw_3 = (r1_xyzw_2.xxyz * float4(r2_x_7, r2_x_7, r2_y_6, r2_z_6));
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                o.sv_Target0.xyz = (((max(dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3))).xyz;
                o.sv_Target0.w = r1_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            SamplerState s3 : register(s3);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            TextureCube t2 : register(t2);
            Texture3D t3 : register(t3);
            struct program22Input
            {
                float4 position0 : POSITION0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program22Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program41Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program41Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program22Output vert(program22Input i)
            {
                program22Output o = (program22Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_3 = ((worldPos_xyzw_4.yyyy * _MainTex_ST.xyzx)).xyz;
                float3 clipPos_xyz_4 = (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_3.xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(cb0_values[6].xyzx, worldPos_xyzw_4.zzzz, clipPos_xyz_4.xyzx)).xyz;
                o.texcoord3.xyz = (mad(cb0_values[7].xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program41Output frag(program41Input i)
            {
                program41Output o = (program41Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = t0.Sample(s3, i.texcoord0.xyxx);
                float4 r1_xyzw_2 = (r1_xyzw_1 * cb0_values[8].xyzw);
                float3 r2_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r2_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r2_w_1);
                    float4 r3_xyzw_9 = t3.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
                    r3_x_10 = r3_xyzw_9.x;
                    r3_y_10 = r3_xyzw_9.y;
                    r3_z_10 = r3_xyzw_9.z;
                    r3_w_4 = r3_xyzw_9.w;
                }
                else
                {
                    float4 r3_xyzw_10 = float4(1, 1, 1, 1);
                    r3_x_10 = r3_xyzw_10.x;
                    r3_y_10 = r3_xyzw_10.y;
                    r3_z_10 = r3_xyzw_10.z;
                    r3_w_4 = r3_xyzw_10.w;
                }
                float r0_w_7 = dot(float4(r3_x_10, r3_y_10, r3_z_10, r3_w_4), unity_OcclusionMaskSelector);
                float r2_w_3 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float4 r3_xyzw_11 = t1.Sample(s2, r2_w_3.xxxx);
                float4 r2_xyzw_5 = t2.Sample(s1, r2_xyz_4.xyzx);
                float r0_w_8 = (r0_w_7 * (r2_xyzw_5.w * r3_xyzw_11.x));
                float4 r2_xyzw_7 = (r0_w_8.xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_6 = r2_xyzw_7.y;
                float r2_z_6 = r2_xyzw_7.z;
                float4 r0_xyzw_3 = (r1_xyzw_2.xxyz * float4(r2_x_7, r2_x_7, r2_y_6, r2_z_6));
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                float4 r0_xyzw_5 = ((max(dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float TEXCOORD0_w_10 = i.texcoord4.x;
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5) * TEXCOORD0_w_10.xxxx)).xyz;
                o.sv_Target0.w = r1_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            SamplerState s3 : register(s3);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture2D t2 : register(t2);
            Texture3D t3 : register(t3);
            struct program22Input
            {
                float4 position0 : POSITION0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program22Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program40Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program40Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program22Output vert(program22Input i)
            {
                program22Output o = (program22Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_3 = ((worldPos_xyzw_4.yyyy * _MainTex_ST.xyzx)).xyz;
                float3 clipPos_xyz_4 = (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_3.xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(cb0_values[6].xyzx, worldPos_xyzw_4.zzzz, clipPos_xyz_4.xyzx)).xyz;
                o.texcoord3.xyz = (mad(cb0_values[7].xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program40Output frag(program40Input i)
            {
                program40Output o = (program40Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = t0.Sample(s3, i.texcoord0.xyxx);
                float4 r1_xyzw_2 = (r1_xyzw_1 * cb0_values[8].xyzw);
                float4 r2_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord2.zzzz, mad(cb0_values[4].xyzw, i.texcoord2.xxxx, (i.texcoord2.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_11;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r3_y_9 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r3_y_9);
                    float4 r3_xyzw_9 = t3.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
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
                float r0_w_7 = dot(float4(r3_x_10, r3_y_11, r3_z_10, r3_w_4), unity_OcclusionMaskSelector);
                float4 r3_xyzw_12 = (r2_xyzw_4.xxyx / r2_xyzw_4.wwww);
                float r3_y_12 = r3_xyzw_12.y;
                float r3_z_11 = r3_xyzw_12.z;
                float4 r3_xyzw_13 = (float4(r3_y_12, r3_y_12, r3_z_11, r3_y_12) + float4(0, 0.5, 0.5, 0));
                float r3_y_13 = r3_xyzw_13.y;
                float r3_z_12 = r3_xyzw_13.z;
                float4 r4_xyzw_1 = t1.Sample(s1, float4(r3_y_13, r3_z_12, r3_y_13, r3_y_13));
                float r2_w_5 = (asfloat(asint((float)((0 < r2_xyzw_4.z))) & asint(1065353216)) * r4_xyzw_1.w);
                float r3_x_13 = (t2.Sample(s2, (dot(r2_xyzw_4.xyzx, r2_xyzw_4.xyzx)).xxxx)).x;
                float4 r3_xyzw_14 = t2.Sample(s2, (dot(r2_xyzw_4.xyzx, r2_xyzw_4.xyzx)).xxxx);
                float r3_y_14 = r3_xyzw_14.y;
                float r3_z_13 = r3_xyzw_14.z;
                float r3_w_5 = r3_xyzw_14.w;
                float r0_w_8 = (r0_w_7 * (r2_w_5 * r3_x_13));
                float4 r2_xyzw_7 = (r0_w_8.xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_5 = r2_xyzw_7.y;
                float r2_z_5 = r2_xyzw_7.z;
                float4 r0_xyzw_3 = (r1_xyzw_2.xxyz * float4(r2_x_7, r2_x_7, r2_y_5, r2_z_5));
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                float4 r0_xyzw_5 = ((max(dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float TEXCOORD0_w_10 = i.texcoord4.x;
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5) * TEXCOORD0_w_10.xxxx)).xyz;
                o.sv_Target0.w = r1_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture3D t2 : register(t2);
            struct program22Input
            {
                float4 position0 : POSITION0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program22Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program38Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program38Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program22Output vert(program22Input i)
            {
                program22Output o = (program22Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_3 = ((worldPos_xyzw_4.yyyy * _MainTex_ST.xyzx)).xyz;
                float3 clipPos_xyz_4 = (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_3.xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(cb0_values[6].xyzx, worldPos_xyzw_4.zzzz, clipPos_xyz_4.xyzx)).xyz;
                o.texcoord3.xyz = (mad(cb0_values[7].xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program38Output frag(program38Input i)
            {
                program38Output o = (program38Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = t0.Sample(s2, i.texcoord0.xyxx);
                float4 r1_xyzw_2 = (r1_xyzw_1 * cb0_values[8].xyzw);
                float3 r2_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r2_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r2_w_1);
                    float4 r3_xyzw_9 = t2.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
                    r3_x_10 = r3_xyzw_9.x;
                    r3_y_10 = r3_xyzw_9.y;
                    r3_z_10 = r3_xyzw_9.z;
                    r3_w_4 = r3_xyzw_9.w;
                }
                else
                {
                    float4 r3_xyzw_10 = float4(1, 1, 1, 1);
                    r3_x_10 = r3_xyzw_10.x;
                    r3_y_10 = r3_xyzw_10.y;
                    r3_z_10 = r3_xyzw_10.z;
                    r3_w_4 = r3_xyzw_10.w;
                }
                float r0_w_7 = dot(float4(r3_x_10, r3_y_10, r3_z_10, r3_w_4), unity_OcclusionMaskSelector);
                float4 r2_xyzw_6 = t1.Sample(s1, (dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx)).xxxx);
                float r0_w_8 = (r0_w_7 * r2_xyzw_6.x);
                float4 r2_xyzw_7 = (r0_w_8.xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_6 = r2_xyzw_7.y;
                float r2_z_6 = r2_xyzw_7.z;
                float4 r0_xyzw_3 = (r1_xyzw_2.xxyz * float4(r2_x_7, r2_x_7, r2_y_6, r2_z_6));
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                float4 r0_xyzw_5 = ((max(dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float TEXCOORD0_w_10 = i.texcoord4.x;
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5) * TEXCOORD0_w_10.xxxx)).xyz;
                o.sv_Target0.w = r1_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            SamplerState s3 : register(s3);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            TextureCube t2 : register(t2);
            Texture3D t3 : register(t3);
            struct program22Input
            {
                float4 position0 : POSITION0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program22Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program36Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program36Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program22Output vert(program22Input i)
            {
                program22Output o = (program22Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_3 = ((worldPos_xyzw_4.yyyy * _MainTex_ST.xyzx)).xyz;
                float3 clipPos_xyz_4 = (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_3.xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(cb0_values[6].xyzx, worldPos_xyzw_4.zzzz, clipPos_xyz_4.xyzx)).xyz;
                o.texcoord3.xyz = (mad(cb0_values[7].xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program36Output frag(program36Input i)
            {
                program36Output o = (program36Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = t0.Sample(s3, i.texcoord0.xyxx);
                float4 r1_xyzw_2 = (r1_xyzw_1 * cb0_values[8].xyzw);
                float3 r2_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r2_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r2_w_1);
                    float4 r3_xyzw_9 = t3.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
                    r3_x_10 = r3_xyzw_9.x;
                    r3_y_10 = r3_xyzw_9.y;
                    r3_z_10 = r3_xyzw_9.z;
                    r3_w_4 = r3_xyzw_9.w;
                }
                else
                {
                    float4 r3_xyzw_10 = float4(1, 1, 1, 1);
                    r3_x_10 = r3_xyzw_10.x;
                    r3_y_10 = r3_xyzw_10.y;
                    r3_z_10 = r3_xyzw_10.z;
                    r3_w_4 = r3_xyzw_10.w;
                }
                float r0_w_7 = dot(float4(r3_x_10, r3_y_10, r3_z_10, r3_w_4), unity_OcclusionMaskSelector);
                float r2_w_3 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float4 r3_xyzw_11 = t1.Sample(s2, r2_w_3.xxxx);
                float4 r2_xyzw_5 = t2.Sample(s1, r2_xyz_4.xyzx);
                float r0_w_8 = (r0_w_7 * (r2_xyzw_5.w * r3_xyzw_11.x));
                float4 r2_xyzw_7 = (r0_w_8.xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_6 = r2_xyzw_7.y;
                float r2_z_6 = r2_xyzw_7.z;
                float4 r0_xyzw_3 = (r1_xyzw_2.xxyz * float4(r2_x_7, r2_x_7, r2_y_6, r2_z_6));
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                o.sv_Target0.xyz = (((max(dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3))).xyz;
                o.sv_Target0.w = r1_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            SamplerState s3 : register(s3);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture2D t2 : register(t2);
            Texture3D t3 : register(t3);
            struct program22Input
            {
                float4 position0 : POSITION0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program22Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program35Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program35Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program22Output vert(program22Input i)
            {
                program22Output o = (program22Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_3 = ((worldPos_xyzw_4.yyyy * _MainTex_ST.xyzx)).xyz;
                float3 clipPos_xyz_4 = (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_3.xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(cb0_values[6].xyzx, worldPos_xyzw_4.zzzz, clipPos_xyz_4.xyzx)).xyz;
                o.texcoord3.xyz = (mad(cb0_values[7].xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program35Output frag(program35Input i)
            {
                program35Output o = (program35Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = t0.Sample(s3, i.texcoord0.xyxx);
                float4 r1_xyzw_2 = (r1_xyzw_1 * cb0_values[8].xyzw);
                float4 r2_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord2.zzzz, mad(cb0_values[4].xyzw, i.texcoord2.xxxx, (i.texcoord2.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_11;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r3_y_9 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r3_y_9);
                    float4 r3_xyzw_9 = t3.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
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
                float r0_w_7 = dot(float4(r3_x_10, r3_y_11, r3_z_10, r3_w_4), unity_OcclusionMaskSelector);
                float4 r3_xyzw_12 = (r2_xyzw_4.xxyx / r2_xyzw_4.wwww);
                float r3_y_12 = r3_xyzw_12.y;
                float r3_z_11 = r3_xyzw_12.z;
                float4 r3_xyzw_13 = (float4(r3_y_12, r3_y_12, r3_z_11, r3_y_12) + float4(0, 0.5, 0.5, 0));
                float r3_y_13 = r3_xyzw_13.y;
                float r3_z_12 = r3_xyzw_13.z;
                float4 r4_xyzw_1 = t1.Sample(s1, float4(r3_y_13, r3_z_12, r3_y_13, r3_y_13));
                float r2_w_5 = (asfloat(asint((float)((0 < r2_xyzw_4.z))) & asint(1065353216)) * r4_xyzw_1.w);
                float r3_x_13 = (t2.Sample(s2, (dot(r2_xyzw_4.xyzx, r2_xyzw_4.xyzx)).xxxx)).x;
                float4 r3_xyzw_14 = t2.Sample(s2, (dot(r2_xyzw_4.xyzx, r2_xyzw_4.xyzx)).xxxx);
                float r3_y_14 = r3_xyzw_14.y;
                float r3_z_13 = r3_xyzw_14.z;
                float r3_w_5 = r3_xyzw_14.w;
                float r0_w_8 = (r0_w_7 * (r2_w_5 * r3_x_13));
                float4 r2_xyzw_7 = (r0_w_8.xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_5 = r2_xyzw_7.y;
                float r2_z_5 = r2_xyzw_7.z;
                float4 r0_xyzw_3 = (r1_xyzw_2.xxyz * float4(r2_x_7, r2_x_7, r2_y_5, r2_z_5));
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                o.sv_Target0.xyz = (((max(dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3))).xyz;
                o.sv_Target0.w = r1_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Transparent/VertexLit"
}
