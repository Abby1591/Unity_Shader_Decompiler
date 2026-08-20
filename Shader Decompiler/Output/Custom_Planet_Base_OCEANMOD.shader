Shader "Custom/Planet_Base_OCEANMOD"
{
    Properties
    {
        _Oceancolor ("Ocean Color", Color) = (0.5,0.5,0.5,0)
        _OceanGlossiness ("Ocean Glossiness", Color) = (0.5,0.5,0.5,0)
        _OceanAO ("Ocean AO", Color) = (0.5,0.5,0.5,0)
        _OceanEmission ("Ocean Emission", Color) = (0.5,0.5,0.5,0)
        _AOalbedo ("AO in albedy", Range(0, 2)) = 0
        _SmoothnessShift ("Smoothness shift", Range(-1, 1)) = 0
        _AOsmoothness ("AO in smoothness", Range(-1, 1)) = 0
        _AOintensity ("AO intensity", Range(0.2, 5)) = 1
        _EmissionScale ("Emission Scale", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 300
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Oceancolor;
                float4 _OceanGlossiness;
                float4 _OceanAO;
                float4 _OceanEmission;
                float _AOalbedo;
                float _AOsmoothness;
                float _SmoothnessShift;
                float _EmissionScale;
                float _AOintensity;
                float4 cb0_values[10];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[21];
            };
            cbuffer UnityLighting : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer UnityReflectionProbes : register(b3)
            {
                float4 unity_SpecCube0_BoxMax;
                float4 unity_SpecCube0_BoxMin;
                float4 unity_SpecCube0_ProbePosition;
                float4 unity_SpecCube0_HDR;
                float4 unity_SpecCube1_BoxMax;
                float4 unity_SpecCube1_BoxMin;
                float4 unity_SpecCube1_ProbePosition;
                float4 unity_SpecCube1_HDR;
                float4 cb3_values[8];
            };
            cbuffer UnityProbeVolume : register(b4)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb4_values[7];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            TextureCube t0 : register(t0);
            TextureCube t1 : register(t1);
            Texture3D t2 : register(t2);
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
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program30Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program30Output
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
                o.texcoord1.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord0.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program30Output frag(program30Input i)
            {
                program30Output o = (program30Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_1 = log2(_OceanAO.x);
                float r1_w_2 = (r1_w_1 * _AOintensity);
                float r1_w_3 = exp2(r1_w_2);
                float r2_x_1 = (-r1_w_3 + 1);
                float r2_y_1 = (r2_x_1 * _AOalbedo);
                float r2_y_2 = r2_y_1;
                float4 r2_xyzw_3 = mad(r2_y_2.xxxx, -_Oceancolor.xxyz, _Oceancolor.xxyz);
                float r2_y_3 = r2_xyzw_3.y;
                float r2_z_1 = r2_xyzw_3.z;
                float r2_w_1 = r2_xyzw_3.w;
                float r2_x_3 = (mad(r2_x_1, _AOsmoothness, _OceanGlossiness.x) + _SmoothnessShift);
                float r3_x_8;
                float r3_y_11;
                float r3_z_10;
                float r3_w_8;
                if ((unity_ProbeVolumeParams.x == 1))
                {
                    float3 r3_yzw_2 = ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xxyz)).yzw;
                    float3 r3_yzw_3 = (mad(unity_ProbeVolumeWorldToObject[0].xxyz, i.texcoord1.xxxx, r3_yzw_2.xxyz)).yzw;
                    float3 r3_yzw_4 = (mad(unity_ProbeVolumeWorldToObject[2].xxyz, i.texcoord1.zzzz, r3_yzw_3.xxyz)).yzw;
                    float3 r3_yzw_5 = ((r3_yzw_4.xxyz + unity_ProbeVolumeWorldToObject[3].xxyz)).yzw;
                    float4 unity_ProbeVolumeParamsSelect_xyzw_4 = (((unity_ProbeVolumeParams.y == 1)).xxxx ? r3_yzw_5.xyzx : i.texcoord1.xyzx);
                    float unity_ProbeVolumeParamsSelect_x_4 = unity_ProbeVolumeParamsSelect_xyzw_4.x;
                    float unity_ProbeVolumeParamsSelect_y_6 = unity_ProbeVolumeParamsSelect_xyzw_4.y;
                    float unity_ProbeVolumeParamsSelect_z_6 = unity_ProbeVolumeParamsSelect_xyzw_4.z;
                    float4 r3_xyzw_5 = (float4(unity_ProbeVolumeParamsSelect_x_4, unity_ProbeVolumeParamsSelect_y_6, unity_ProbeVolumeParamsSelect_z_6, unity_ProbeVolumeParamsSelect_x_4) + -unity_ProbeVolumeMin.xyzx);
                    float r3_x_5 = r3_xyzw_5.x;
                    float r3_y_7 = r3_xyzw_5.y;
                    float r3_z_7 = r3_xyzw_5.z;
                    float4 r3_xyzw_8 = (float4(r3_x_5, r3_x_5, r3_y_7, r3_z_7) * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_6 = r3_xyzw_8.w;
                    float r3_y_9 = mad(r3_y_8, 0.25, 0.75);
                    float r3_x_6 = max(r3_y_9, mad(unity_ProbeVolumeParams.z, 0.5, 0.75));
                    float4 r3_xyzw_7 = t2.Sample(s1, float4(r3_x_6, r3_z_8, r3_w_6, r3_x_6));
                    r3_x_8 = r3_xyzw_7.x;
                    r3_y_11 = r3_xyzw_7.y;
                    r3_z_10 = r3_xyzw_7.z;
                    r3_w_8 = r3_xyzw_7.w;
                }
                else
                {
                    float4 r3_xyzw_2 = float4(1, 1, 1, 1);
                    r3_x_8 = r3_xyzw_2.x;
                    r3_y_11 = r3_xyzw_2.y;
                    r3_z_10 = r3_xyzw_2.z;
                    r3_w_8 = r3_xyzw_2.w;
                }
                float r3_y_12 = (-r2_x_3 + 1);
                float r3_z_11 = dot(-unitViewDir_xyz_1.xyzx, i.texcoord0.xyzx);
                float r3_z_12 = (r3_z_11 + r3_z_11);
                float4 r4_xyzw_3 = mad(i.texcoord0.xyzx, -r3_z_12.xxxx, -unitViewDir_xyz_1.xyzx);
                float r4_x_3 = r4_xyzw_3.x;
                float r4_y_1 = r4_xyzw_3.y;
                float r4_z_1 = r4_xyzw_3.z;
                float4 r3_xyzw_10 = ((dot(float4(r3_x_8, r3_y_11, r3_z_10, r3_w_8), unity_OcclusionMaskSelector)).xxxx * _LightColor0.xxyz);
                float r3_x_10 = r3_xyzw_10.x;
                float r3_z_13 = r3_xyzw_10.z;
                float r3_w_9 = r3_xyzw_10.w;
                float r4_w_1 = (0 < unity_SpecCube0_ProbePosition.w);
                float3 r5_xyz_4;
                if (r4_w_1)
                {
                    float r4_w_2 = dot(float4(r4_x_3, r4_y_1, r4_z_1, r4_x_3), float4(r4_x_3, r4_y_1, r4_z_1, r4_x_3));
                    float r4_w_3 = rsqrt(r4_w_2);
                    float3 r5_xyz_2 = ((r4_w_3.xxxx * float4(r4_x_3, r4_y_1, r4_z_1, r4_x_3))).xyz;
                    float3 r8_xyz_1 = ((float4(0, 0, 0, 0) < r5_xyz_2.xyzx)).xyz;
                    float3 r6_xyz_3 = ((r8_xyz_1.xyzx ? ((((-i.texcoord1.xyzx + unity_SpecCube0_BoxMax.xyzx)).xyzx / r5_xyz_2.xyzx)).xyzx : ((((-i.texcoord1.xyzx + unity_SpecCube0_BoxMin.xyzx)).xyzx / r5_xyz_2.xyzx)).xyzx)).xyz;
                    float r4_w_4 = min(r6_xyz_3.y, r6_xyz_3.x);
                    float r4_w_5 = min(r6_xyz_3.z, r4_w_4);
                    r5_xyz_4 = (mad(r5_xyz_2.xyzx, r4_w_5.xxxx, ((i.texcoord1.xyzx + -unity_SpecCube0_ProbePosition.xyzx)).xyzx)).xyz;
                }
                else
                {
                    r5_xyz_4 = (float4(r4_x_3, r4_y_1, r4_z_1, r4_x_3)).xyz;
                }
                float r4_w_7 = mad(-r3_y_12, 0.7, 1.7);
                float r4_w_8 = (r3_y_12 * r4_w_7);
                float r4_w_9 = (r4_w_8 * 6);
                float4 r5_xyzw_5 = t0.SampleLevel(s0, r5_xyz_4.xyzx, r4_w_9);
                float r5_w_2 = (r5_xyzw_5.w + -1);
                float r5_w_3 = mad(unity_SpecCube0_HDR.w, r5_w_2, 1);
                float r5_w_4 = (r5_w_3 * unity_SpecCube0_HDR.x);
                float r6_w_1 = (unity_SpecCube0_BoxMin.w < 0.99999);
                float3 r6_xyz_8 = ((r5_xyzw_5.xyzx * r5_w_4.xxxx)).xyz;
                if (r6_w_1)
                {
                    float r6_w_2 = (0 < unity_SpecCube1_ProbePosition.w);
                    float r4_x_5 = r4_x_3;
                    float r4_y_3 = r4_y_1;
                    float r4_z_3 = r4_z_1;
                    if (r6_w_2)
                    {
                        float r6_w_3 = dot(float4(r4_x_3, r4_y_1, r4_z_1, r4_x_3), float4(r4_x_3, r4_y_1, r4_z_1, r4_x_3));
                        float r6_w_4 = rsqrt(r6_w_3);
                        float3 r7_xyz_4 = ((float4(r4_x_3, r4_y_1, r4_z_1, r4_x_3) * r6_w_4.xxxx)).xyz;
                        float3 r10_xyz_1 = ((float4(0, 0, 0, 0) < r7_xyz_4.xyzx)).xyz;
                        float3 r8_xyz_5 = ((r10_xyz_1.xyzx ? ((((-i.texcoord1.xyzx + unity_SpecCube1_BoxMax.xyzx)).xyzx / r7_xyz_4.xyzx)).xyzx : ((((-i.texcoord1.xyzx + unity_SpecCube1_BoxMin.xyzx)).xyzx / r7_xyz_4.xyzx)).xyzx)).xyz;
                        float r6_w_5 = min(r8_xyz_5.y, r8_xyz_5.x);
                        float r6_w_6 = min(r8_xyz_5.z, r6_w_5);
                        float4 r4_xyzw_4 = mad(r7_xyz_4.xyzx, r6_w_6.xxxx, ((i.texcoord1.xyzx + -unity_SpecCube1_ProbePosition.xyzx)).xyzx);
                        float r4_x_4 = r4_xyzw_4.x;
                        float r4_y_2 = r4_xyzw_4.y;
                        float r4_z_2 = r4_xyzw_4.z;
                        r4_x_5 = r4_x_4;
                        r4_y_3 = r4_y_2;
                        r4_z_3 = r4_z_2;
                    }
                    float4 r4_xyzw_6 = t1.SampleLevel(s0, float4(r4_x_5, r4_y_3, r4_z_3, r4_x_5), r4_w_9);
                    float r4_w_11 = (r4_xyzw_6.w + -1);
                    float r4_w_12 = mad(unity_SpecCube1_HDR.w, r4_w_11, 1);
                    float r4_w_13 = (r4_w_12 * unity_SpecCube1_HDR.x);
                    float4 r4_xyzw_7 = (r4_xyzw_6.xyzx * r4_w_13.xxxx);
                    float r4_x_7 = r4_xyzw_7.x;
                    float r4_y_5 = r4_xyzw_7.y;
                    float r4_z_5 = r4_xyzw_7.z;
                    r6_xyz_8 = (mad(unity_SpecCube0_BoxMin.wwww, (mad(r5_w_4.xxxx, r5_xyzw_5.xyzx, -float4(r4_x_7, r4_y_5, r4_z_5, r4_x_7))).xyzx, float4(r4_x_7, r4_y_5, r4_z_5, r4_x_7))).xyz;
                }
                float4 r4_xyzw_9 = (r1_w_3.xxxx * r6_xyz_8.xyzx);
                float r4_x_9 = r4_xyzw_9.x;
                float r4_y_7 = r4_xyzw_9.y;
                float r4_z_7 = r4_xyzw_9.z;
                float r1_w_4 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r1_w_5 = rsqrt(r1_w_4);
                float3 unitWorldNormal_xyz_8 = ((r1_w_5.xxxx * i.texcoord0.xyzx)).xyz;
                float4 r2_xyzw_4 = (float4(r2_y_3, r2_y_3, r2_z_1, r2_w_1) * float4(0, 0.7790837, 0.7790837, 0.7790837));
                float r2_y_4 = r2_xyzw_4.y;
                float r2_z_2 = r2_xyzw_4.z;
                float r2_w_2 = r2_xyzw_4.w;
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitWorldNormal_xyz_8.xyzx, unitViewDir_xyz_1.xyzx);
                float r1_x_2 = dot(unitWorldNormal_xyz_8.xyzx, _WorldSpaceLightPos0.xyzx);
                float r1_y_2 = dot(unitWorldNormal_xyz_8.xyzx, r0_xyz_3.xyzx);
                float r0_x_4 = dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r3_y_12.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(nDotV_w_6) + 1);
                float r1_w_6 = (r1_z_4 * r1_z_4);
                float r1_w_7 = (r1_w_6 * r1_w_6);
                float r1_z_5 = (r1_z_4 * r1_w_7);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r3_y_12 * r3_y_12);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_w_8 = (-r0_z_8 + 1);
                float r4_w_15 = mad(abs(nDotV_w_6), r1_w_8, r0_z_8);
                float r1_w_9 = mad(r1_x_2, r1_w_8, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * r1_w_9);
                float r0_w_8 = mad(r1_x_2, r4_w_15, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r1_w_10 = (r0_z_8 * r0_z_8);
                float r4_w_16 = mad(r1_y_2, r1_w_10, -r1_y_2);
                float r1_y_3 = mad(r4_w_16, r1_y_2, 1);
                float r1_w_11 = (r1_w_10 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r1_y_5 = (r1_w_11 / r1_y_4);
                float r0_w_11 = (r0_w_10 * r1_y_5);
                float4 r0_xyzw_9 = (float4(r0_z_8, r0_z_8, r0_z_8, r0_w_11) * float4(0, 0, 0.28, 3.1415927));
                float r0_z_9 = r0_xyzw_9.z;
                float r0_w_12 = r0_xyzw_9.w;
                float r0_w_13 = max(r0_w_12, 0.0001);
                float r0_w_14 = sqrt(r0_w_13);
                float r0_y_9 = ((r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_y_8, r0_w_14))).y;
                float r0_w_15 = ((r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_y_8, r0_w_14))).w;
                float r0_z_10 = mad(-r0_z_9, r3_y_12, 1);
                float4 r3_xyzw_11 = (float4(r3_x_10, r3_z_13, r3_w_9, r3_x_10) * r0_w_15.xxxx);
                float r3_x_11 = r3_xyzw_11.x;
                float r3_y_13 = r3_xyzw_11.y;
                float r3_z_14 = r3_xyzw_11.z;
                float r0_x_5 = (-r0_x_4 + 1);
                float r0_y_10 = (r0_x_5 * r0_x_5);
                float r0_y_11 = (r0_y_10 * r0_y_10);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r0_y_11), 0.7790837, 0.2209163)).xxxx * float4(r3_x_11, r3_y_13, r3_x_11, r3_z_14));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_w_16 = r0_xyzw_8.w;
                float r0_x_9 = (mad(float4(r2_y_4, r2_z_2, r2_y_4, r2_w_2), ((r0_y_9.xxxx * float4(r3_x_10, r3_z_13, r3_w_9, r3_x_10))).xyxz, float4(r0_x_8, r0_y_12, r0_x_8, r0_w_16))).x;
                float4 r0_xyzw_13 = mad(float4(r2_y_4, r2_z_2, r2_y_4, r2_w_2), ((r0_y_9.xxxx * float4(r3_x_10, r3_z_13, r3_w_9, r3_x_10))).xyxz, float4(r0_x_8, r0_y_12, r0_x_8, r0_w_16));
                float r0_y_13 = r0_xyzw_13.y;
                float r0_w_17 = r0_xyzw_13.w;
                float r2_x_4 = ((float4(r4_x_9, r4_y_7, r4_z_7, r4_x_9) * r0_z_10.xxxx)).x;
                float4 r2_xyzw_5 = (float4(r4_x_9, r4_y_7, r4_z_7, r4_x_9) * r0_z_10.xxxx);
                float r2_y_5 = r2_xyzw_5.y;
                float r2_z_3 = r2_xyzw_5.z;
                float r0_z_11 = (min((r2_x_3 + 0.22091627), 1) + -0.2209163);
                float r0_z_12 = mad(r1_z_5, r0_z_11, 0.2209163);
                float4 r0_xyzw_10 = mad(float4(r2_x_4, r2_y_5, r2_z_3, r2_x_4), r0_z_12.xxxx, float4(r0_x_9, r0_y_13, r0_w_17, r0_x_9));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_14 = r0_xyzw_10.y;
                float r0_z_13 = r0_xyzw_10.z;
                o.sv_Target0.xyz = (mad(_OceanEmission.xyzx, _EmissionScale.xxxx, float4(r0_x_10, r0_y_14, r0_z_13, r0_x_10))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Oceancolor;
                float4 _OceanGlossiness;
                float4 _OceanAO;
                float4 _OceanEmission;
                float _AOalbedo;
                float _AOsmoothness;
                float _SmoothnessShift;
                float _EmissionScale;
                float _AOintensity;
                float4 cb0_values[10];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[46];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer cb3 : register(b3)
            {
                float4 unity_SpecCube0_BoxMax;
                float4 unity_SpecCube0_BoxMin;
                float4 unity_SpecCube0_ProbePosition;
                float4 unity_SpecCube0_HDR;
                float4 unity_SpecCube1_BoxMax;
                float4 unity_SpecCube1_BoxMin;
                float4 unity_SpecCube1_ProbePosition;
                float4 unity_SpecCube1_HDR;
                float4 cb3_values[26];
            };
            cbuffer UnityProbeVolume : register(b4)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb4_values[12];
            };
            cbuffer cb5 : register(b5)
            {
                float4 cb5_values[2];
            };
            cbuffer cb6 : register(b6)
            {
                float4 cb6_values[8];
            };
            cbuffer cb7 : register(b7)
            {
                float4 cb7_values[7];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            TextureCube t1 : register(t1);
            TextureCube t2 : register(t2);
            Texture3D t3 : register(t3);
            struct program17Input
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
            struct program17Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program37Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program37Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program17Output vert(program17Input i)
            {
                program17Output o = (program17Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                o.texcoord1.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                float3 unitWorldNormal_xyz_3 = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord0.xyz = (unitWorldNormal_xyz_3.xyzx).xyz;
                float r1_w_4 = (unitWorldNormal_xyz_3.y * unitWorldNormal_xyz_3.y);
                float r1_w_5 = mad(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.x, -r1_w_4);
                float4 r2_xyzw_1 = (unitWorldNormal_xyz_3.yzzx * unitWorldNormal_xyz_3.xyzz);
                float r1_x_4 = dot(cb1_values[42].xyzw, r2_xyzw_1);
                float r1_y_4 = dot(cb1_values[43].xyzw, r2_xyzw_1);
                float r1_z_4 = dot(cb1_values[44].xyzw, r2_xyzw_1);
                o.texcoord2.xyz = (mad(cb1_values[45].xyzx, r1_w_5.xxxx, float4(r1_x_4, r1_y_4, r1_z_4, r1_x_4))).xyz;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r1_xyzw_5 = (float4(clipPos_xyzw_7.x, clipPos_xyzw_7.x, clipPos_xyzw_7.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_5 = r1_xyzw_5.x;
                float r1_z_5 = r1_xyzw_5.z;
                float r1_w_6 = r1_xyzw_5.w;
                o.texcoord4.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord4.xy = ((r1_z_5.xxxx + float4(r1_x_5, r1_w_6, r1_x_5, r1_x_5))).xy;
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program37Output frag(program37Input i)
            {
                program37Output o = (program37Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_1 = log2(_OceanAO.x);
                float r1_w_2 = (r1_w_1 * _AOintensity);
                float r1_w_3 = exp2(r1_w_2);
                float r2_x_1 = (-r1_w_3 + 1);
                float r2_y_1 = (r2_x_1 * _AOalbedo);
                float r2_y_2 = r2_y_1;
                float4 r2_xyzw_3 = mad(r2_y_2.xxxx, -_Oceancolor.xxyz, _Oceancolor.xxyz);
                float r2_y_3 = r2_xyzw_3.y;
                float r2_z_1 = r2_xyzw_3.z;
                float r2_w_1 = r2_xyzw_3.w;
                float r2_x_3 = (mad(r2_x_1, _AOsmoothness, _OceanGlossiness.x) + _SmoothnessShift);
                float r3_x_1 = cb4_values[9].z;
                float r3_y_1 = cb4_values[10].z;
                float r3_z_1 = cb4_values[11].z;
                float r3_x_2 = dot(viewDir_xyz_1.xyzx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float4 r3_xyzw_2 = (i.texcoord1.xxyz + -cb3_values[25].xxyz);
                float r3_y_2 = r3_xyzw_2.y;
                float r3_z_2 = r3_xyzw_2.z;
                float r3_w_1 = r3_xyzw_2.w;
                float r3_y_3 = dot(float4(r3_y_2, r3_z_2, r3_w_1, r3_y_2), float4(r3_y_2, r3_z_2, r3_w_1, r3_y_2));
                float r3_y_4 = sqrt(r3_y_3);
                float r3_y_5 = (-r3_x_2 + r3_y_4);
                float r3_y_6 = (cb7_values[0].x == 1);
                float r4_x_10;
                float r4_y_10;
                float r4_z_10;
                float r4_w_4;
                if (r3_y_6)
                {
                    float r3_z_3 = (cb7_values[0].y == 1);
                    float3 r4_xyz_5 = (((mad(cb7_values[3].xyzx, i.texcoord1.zzzz, (mad(cb7_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb7_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb7_values[4].xyzx)).xyz;
                    float4 r4_xyzw_8 = (((((r3_z_3.xxxx ? r4_xyz_5.xyzx : i.texcoord1.xyzx)).xyzx + -cb7_values[6].xyzx)).xxyz * cb7_values[5].xxyz);
                    float r4_y_8 = r4_xyzw_8.y;
                    float r4_z_8 = r4_xyzw_8.z;
                    float r4_w_2 = r4_xyzw_8.w;
                    float r3_z_4 = mad(r4_y_8, 0.25, 0.75);
                    float r3_w_2 = mad(cb7_values[0].z, 0.5, 0.75);
                    float r4_x_8 = max(r3_w_2, r3_z_4);
                    float4 r4_xyzw_9 = t3.Sample(s1, float4(r4_x_8, r4_z_8, r4_w_2, r4_x_8));
                    r4_x_10 = r4_xyzw_9.x;
                    r4_y_10 = r4_xyzw_9.y;
                    r4_z_10 = r4_xyzw_9.z;
                    r4_w_4 = r4_xyzw_9.w;
                }
                else
                {
                    float4 r4_xyzw_10 = float4(1, 1, 1, 1);
                    r4_x_10 = r4_xyzw_10.x;
                    r4_y_10 = r4_xyzw_10.y;
                    r4_z_10 = r4_xyzw_10.z;
                    r4_w_4 = r4_xyzw_10.w;
                }
                float r3_z_6 = dot(float4(r4_x_10, r4_y_10, r4_z_10, r4_w_4), unity_OcclusionMaskSelector);
                float4 r4_xyzw_12 = t0.Sample(s2, ((i.texcoord4.xyxx / i.texcoord4.wwww)).xyxx);
                float r3_z_7 = (r3_z_6 + -r4_xyzw_12.x);
                float r3_z_8 = (-r2_x_3 + 1);
                float r3_w_4 = dot(-unitViewDir_xyz_1.xyzx, i.texcoord0.xyzx);
                float r3_w_5 = (r3_w_4 + r3_w_4);
                float4 r4_xyzw_13 = mad(i.texcoord0.xyzx, -r3_w_5.xxxx, -unitViewDir_xyz_1.xyzx);
                float r4_x_13 = r4_xyzw_13.x;
                float r4_y_13 = r4_xyzw_13.y;
                float r4_z_12 = r4_xyzw_13.z;
                float3 r5_xyz_1 = (((mad(mad(mad(cb3_values[25].w, r3_y_5, r3_x_2), cb3_values[24].z, cb3_values[24].w), r3_z_7, r4_xyzw_12.x)).xxxx * _LightColor0.xyzx)).xyz;
                float3 TEXCOORD0_xyz_1;
                float3 r7_xyz_4;
                if ((r3_y_6 != 0))
                {
                    float3 r6_xyz_5 = (((mad(cb7_values[3].xyzx, i.texcoord1.zzzz, (mad(cb7_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb7_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb7_values[4].xyzx)).xyz;
                    float4 r3_xyzw_7 = (((cb7_values[0].y == 1)).xxxx ? r6_xyz_5.xyxz : i.texcoord1.xyxz);
                    float r3_x_7 = r3_xyzw_7.x;
                    float r3_y_7 = r3_xyzw_7.y;
                    float r3_w_6 = r3_xyzw_7.w;
                    float4 r3_xyzw_8 = (float4(r3_x_7, r3_y_7, r3_x_7, r3_w_6) + -cb7_values[6].xyxz);
                    float r3_x_8 = r3_xyzw_8.x;
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_w_7 = r3_xyzw_8.w;
                    float4 r6_xyzw_6 = (float4(r3_x_8, r3_x_8, r3_y_8, r3_w_7) * cb7_values[5].xxyz);
                    float r6_y_6 = r6_xyzw_6.y;
                    float r6_z_6 = r6_xyzw_6.z;
                    float r6_w_2 = r6_xyzw_6.w;
                    float r3_y_9 = (cb7_values[0].z * 0.5);
                    float r3_w_8 = mad(-cb7_values[0].z, 0.5, 0.25);
                    float r6_x_6 = min(r3_w_8, max(r3_y_9, (r6_y_6 * 0.25)));
                    float4 r7_xyzw_2 = t3.Sample(s1, float4(r6_x_6, r6_z_6, r6_w_2, r6_x_6));
                    float4 r3_xyzw_11 = (float4(r6_x_6, r6_z_6, r6_x_6, r6_w_2) + float4(0.25, 0, 0, 0));
                    float r3_x_11 = r3_xyzw_11.x;
                    float r3_y_10 = r3_xyzw_11.y;
                    float r3_w_9 = r3_xyzw_11.w;
                    float4 r8_xyzw_1 = t3.Sample(s1, float4(r3_x_11, r3_y_10, r3_w_9, r3_x_11));
                    float4 r3_xyzw_12 = (float4(r6_x_6, r6_z_6, r6_x_6, r6_w_2) + float4(0.5, 0, 0, 0));
                    float r3_x_12 = r3_xyzw_12.x;
                    float r3_y_11 = r3_xyzw_12.y;
                    float r3_w_10 = r3_xyzw_12.w;
                    float4 r6_xyzw_7 = t3.Sample(s1, float4(r3_x_12, r3_y_11, r3_w_10, r3_x_12));
                    TEXCOORD0_xyz_1 = (i.texcoord0.xyzx).xyz;
                    float r9_w_1 = 1;
                    float r7_x_3 = dot(r7_xyzw_2, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r9_w_1));
                    float r7_y_3 = dot(r8_xyzw_1, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r9_w_1));
                    float r7_z_3 = dot(r6_xyzw_7, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r9_w_1));
                    r7_xyz_4 = float3(r7_x_3, r7_y_3, r7_z_3);
                }
                else
                {
                    TEXCOORD0_xyz_1 = (i.texcoord0.xyzx).xyz;
                    float r6_w_1 = 1;
                    float r7_x_1 = dot(cb2_values[39].xyzw, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r6_w_1));
                    float r7_y_1 = dot(cb2_values[40].xyzw, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r6_w_1));
                    float r7_z_1 = dot(cb2_values[41].xyzw, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r6_w_1));
                    r7_xyz_4 = float3(r7_x_1, r7_y_1, r7_z_1);
                }
                float4 r3_xyzw_14 = (r7_xyz_4.xyxz + i.texcoord2.xyxz);
                float r3_x_14 = r3_xyzw_14.x;
                float r3_y_13 = r3_xyzw_14.y;
                float r3_w_12 = r3_xyzw_14.w;
                float4 r3_xyzw_15 = max(float4(r3_x_14, r3_y_13, r3_x_14, r3_w_12), float4(0, 0, 0, 0));
                float r3_x_15 = r3_xyzw_15.x;
                float r3_y_14 = r3_xyzw_15.y;
                float r3_w_13 = r3_xyzw_15.w;
                float4 r3_xyzw_16 = log2(float4(r3_x_15, r3_y_14, r3_x_15, r3_w_13));
                float r3_x_16 = r3_xyzw_16.x;
                float r3_y_15 = r3_xyzw_16.y;
                float r3_w_14 = r3_xyzw_16.w;
                float4 r3_xyzw_17 = (float4(r3_x_16, r3_y_15, r3_x_16, r3_w_14) * float4(0.41666666, 0.41666666, 0, 0.41666666));
                float r3_x_17 = r3_xyzw_17.x;
                float r3_y_16 = r3_xyzw_17.y;
                float r3_w_15 = r3_xyzw_17.w;
                float4 r3_xyzw_18 = exp2(float4(r3_x_17, r3_y_16, r3_x_17, r3_w_15));
                float r3_x_18 = r3_xyzw_18.x;
                float r3_y_17 = r3_xyzw_18.y;
                float r3_w_16 = r3_xyzw_18.w;
                float4 r3_xyzw_19 = mad(float4(r3_x_18, r3_y_17, r3_x_18, r3_w_16), float4(1.055, 1.055, 0, 1.055), float4(-0.055, -0.055, 0, -0.055));
                float r3_x_19 = r3_xyzw_19.x;
                float r3_y_18 = r3_xyzw_19.y;
                float r3_w_17 = r3_xyzw_19.w;
                float4 r3_xyzw_20 = max(float4(r3_x_19, r3_y_18, r3_x_19, r3_w_17), float4(0, 0, 0, 0));
                float r3_x_20 = r3_xyzw_20.x;
                float r3_y_19 = r3_xyzw_20.y;
                float r3_w_18 = r3_xyzw_20.w;
                float r4_w_6 = (0 < cb6_values[2].w);
                float3 r6_xyz_12;
                if (r4_w_6)
                {
                    float r4_w_7 = dot(float4(r4_x_13, r4_y_13, r4_z_12, r4_x_13), float4(r4_x_13, r4_y_13, r4_z_12, r4_x_13));
                    float r4_w_8 = rsqrt(r4_w_7);
                    float3 r6_xyz_10 = ((r4_w_8.xxxx * float4(r4_x_13, r4_y_13, r4_z_12, r4_x_13))).xyz;
                    float3 r9_xyz_3 = ((float4(0, 0, 0, 0) < r6_xyz_10.xyzx)).xyz;
                    float3 r7_xyz_7 = ((r9_xyz_3.xyzx ? ((((-i.texcoord1.xyzx + cb6_values[0].xyzx)).xyzx / r6_xyz_10.xyzx)).xyzx : ((((-i.texcoord1.xyzx + cb6_values[1].xyzx)).xyzx / r6_xyz_10.xyzx)).xyzx)).xyz;
                    float r4_w_9 = min(r7_xyz_7.y, r7_xyz_7.x);
                    float r4_w_10 = min(r7_xyz_7.z, r4_w_9);
                    r6_xyz_12 = (mad(r6_xyz_10.xyzx, r4_w_10.xxxx, ((i.texcoord1.xyzx + -cb6_values[2].xyzx)).xyzx)).xyz;
                }
                else
                {
                    r6_xyz_12 = (float4(r4_x_13, r4_y_13, r4_z_12, r4_x_13)).xyz;
                }
                float r4_w_12 = mad(-r3_z_8, 0.7, 1.7);
                float r4_w_13 = (r3_z_8 * r4_w_12);
                float r4_w_14 = (r4_w_13 * 6);
                float4 r6_xyzw_13 = t1.SampleLevel(s0, r6_xyz_12.xyzx, r4_w_14);
                float r5_w_1 = (r6_xyzw_13.w + -1);
                float r5_w_2 = mad(cb6_values[3].w, r5_w_1, 1);
                float r5_w_3 = (r5_w_2 * cb6_values[3].x);
                float r6_w_6 = (cb6_values[1].w < 0.99999);
                float3 r7_xyz_12 = ((r6_xyzw_13.xyzx * r5_w_3.xxxx)).xyz;
                if (r6_w_6)
                {
                    float r6_w_7 = (0 < cb6_values[6].w);
                    float r4_x_15 = r4_x_13;
                    float r4_y_15 = r4_y_13;
                    float r4_z_14 = r4_z_12;
                    if (r6_w_7)
                    {
                        float r6_w_8 = dot(float4(r4_x_13, r4_y_13, r4_z_12, r4_x_13), float4(r4_x_13, r4_y_13, r4_z_12, r4_x_13));
                        float r6_w_9 = rsqrt(r6_w_8);
                        float3 r8_xyz_6 = ((float4(r4_x_13, r4_y_13, r4_z_12, r4_x_13) * r6_w_9.xxxx)).xyz;
                        float3 r11_xyz_1 = ((float4(0, 0, 0, 0) < r8_xyz_6.xyzx)).xyz;
                        float3 r9_xyz_7 = ((r11_xyz_1.xyzx ? ((((-i.texcoord1.xyzx + cb6_values[4].xyzx)).xyzx / r8_xyz_6.xyzx)).xyzx : ((((-i.texcoord1.xyzx + cb6_values[5].xyzx)).xyzx / r8_xyz_6.xyzx)).xyzx)).xyz;
                        float r6_w_10 = min(r9_xyz_7.y, r9_xyz_7.x);
                        float r6_w_11 = min(r9_xyz_7.z, r6_w_10);
                        float4 r4_xyzw_14 = mad(r8_xyz_6.xyzx, r6_w_11.xxxx, ((i.texcoord1.xyzx + -cb6_values[6].xyzx)).xyzx);
                        float r4_x_14 = r4_xyzw_14.x;
                        float r4_y_14 = r4_xyzw_14.y;
                        float r4_z_13 = r4_xyzw_14.z;
                        r4_x_15 = r4_x_14;
                        r4_y_15 = r4_y_14;
                        r4_z_14 = r4_z_13;
                    }
                    float4 r4_xyzw_16 = t2.SampleLevel(s0, float4(r4_x_15, r4_y_15, r4_z_14, r4_x_15), r4_w_14);
                    float r4_w_16 = (r4_xyzw_16.w + -1);
                    float r4_w_17 = mad(cb6_values[7].w, r4_w_16, 1);
                    float r4_w_18 = (r4_w_17 * cb6_values[7].x);
                    float4 r4_xyzw_17 = (r4_xyzw_16.xyzx * r4_w_18.xxxx);
                    float r4_x_17 = r4_xyzw_17.x;
                    float r4_y_17 = r4_xyzw_17.y;
                    float r4_z_16 = r4_xyzw_17.z;
                    r7_xyz_12 = (mad(cb6_values[1].wwww, (mad(r5_w_3.xxxx, r6_xyzw_13.xyzx, -float4(r4_x_17, r4_y_17, r4_z_16, r4_x_17))).xyzx, float4(r4_x_17, r4_y_17, r4_z_16, r4_x_17))).xyz;
                }
                float4 r4_xyzw_19 = (r1_w_3.xxxx * r7_xyz_12.xyzx);
                float r4_x_19 = r4_xyzw_19.x;
                float r4_y_19 = r4_xyzw_19.y;
                float r4_z_18 = r4_xyzw_19.z;
                float r4_w_20 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r4_w_21 = rsqrt(r4_w_20);
                float3 unitClipPos_xyz_16 = ((r4_w_21.xxxx * i.texcoord0.xyzx)).xyz;
                float4 r2_xyzw_4 = (float4(r2_y_3, r2_y_3, r2_z_1, r2_w_1) * float4(0, 0.7790837, 0.7790837, 0.7790837));
                float r2_y_4 = r2_xyzw_4.y;
                float r2_z_2 = r2_xyzw_4.z;
                float r2_w_2 = r2_xyzw_4.w;
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitClipPos_xyz_16.xyzx, unitViewDir_xyz_1.xyzx);
                float r1_x_2 = dot(unitClipPos_xyz_16.xyzx, _WorldSpaceLightPos0.xyzx);
                float r1_y_2 = dot(unitClipPos_xyz_16.xyzx, r0_xyz_3.xyzx);
                float r0_x_4 = dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r3_z_8.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(nDotV_w_6) + 1);
                float r4_w_22 = (r1_z_4 * r1_z_4);
                float r4_w_23 = (r4_w_22 * r4_w_22);
                float r1_z_5 = (r1_z_4 * r4_w_23);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r3_z_8 * r3_z_8);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r4_w_24 = (-r0_z_8 + 1);
                float r5_w_4 = mad(abs(nDotV_w_6), r4_w_24, r0_z_8);
                float r4_w_25 = mad(r1_x_2, r4_w_24, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * r4_w_25);
                float r0_w_8 = mad(r1_x_2, r5_w_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r4_w_26 = (r0_z_8 * r0_z_8);
                float r5_w_5 = mad(r1_y_2, r4_w_26, -r1_y_2);
                float r1_y_3 = mad(r5_w_5, r1_y_2, 1);
                float r4_w_27 = (r4_w_26 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r1_y_5 = (r4_w_27 / r1_y_4);
                float r0_w_11 = (r0_w_10 * r1_y_5);
                float4 r0_xyzw_9 = (float4(r0_z_8, r0_z_8, r0_z_8, r0_w_11) * float4(0, 0, 0.28, 3.1415927));
                float r0_z_9 = r0_xyzw_9.z;
                float r0_w_12 = r0_xyzw_9.w;
                float r0_w_13 = max(r0_w_12, 0.0001);
                float r0_w_14 = sqrt(r0_w_13);
                float r0_y_9 = ((r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_y_8, r0_w_14))).y;
                float r0_w_15 = ((r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_y_8, r0_w_14))).w;
                float r0_z_10 = mad(-r0_z_9, r3_z_8, 1);
                float4 r3_xyzw_21 = mad(float4(r3_x_20, r3_y_19, r3_w_18, r3_x_20), r1_w_3.xxxx, ((r0_y_9.xxxx * r5_xyz_1.xyzx)).xyzx);
                float r3_x_21 = r3_xyzw_21.x;
                float r3_y_20 = r3_xyzw_21.y;
                float r3_z_9 = r3_xyzw_21.z;
                float r0_x_5 = (-r0_x_4 + 1);
                float r0_y_10 = (r0_x_5 * r0_x_5);
                float r0_y_11 = (r0_y_10 * r0_y_10);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r0_y_11), 0.7790837, 0.2209163)).xxxx * ((r5_xyz_1.xyzx * r0_w_15.xxxx)).xyxz);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_w_16 = r0_xyzw_8.w;
                float r0_x_9 = (mad(float4(r2_y_4, r2_z_2, r2_y_4, r2_w_2), float4(r3_x_21, r3_y_20, r3_x_21, r3_z_9), float4(r0_x_8, r0_y_12, r0_x_8, r0_w_16))).x;
                float4 r0_xyzw_13 = mad(float4(r2_y_4, r2_z_2, r2_y_4, r2_w_2), float4(r3_x_21, r3_y_20, r3_x_21, r3_z_9), float4(r0_x_8, r0_y_12, r0_x_8, r0_w_16));
                float r0_y_13 = r0_xyzw_13.y;
                float r0_w_17 = r0_xyzw_13.w;
                float r2_x_4 = ((float4(r4_x_19, r4_y_19, r4_z_18, r4_x_19) * r0_z_10.xxxx)).x;
                float4 r2_xyzw_5 = (float4(r4_x_19, r4_y_19, r4_z_18, r4_x_19) * r0_z_10.xxxx);
                float r2_y_5 = r2_xyzw_5.y;
                float r2_z_3 = r2_xyzw_5.z;
                float r0_z_11 = (min((r2_x_3 + 0.22091627), 1) + -0.2209163);
                float r0_z_12 = mad(r1_z_5, r0_z_11, 0.2209163);
                float4 r0_xyzw_10 = mad(float4(r2_x_4, r2_y_5, r2_z_3, r2_x_4), r0_z_12.xxxx, float4(r0_x_9, r0_y_13, r0_w_17, r0_x_9));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_14 = r0_xyzw_10.y;
                float r0_z_13 = r0_xyzw_10.z;
                float4 r0_xyzw_11 = mad(_OceanEmission.xyzx, _EmissionScale.xxxx, float4(r0_x_10, r0_y_14, r0_z_13, r0_x_10));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_y_15 = r0_xyzw_11.y;
                float r0_z_14 = r0_xyzw_11.z;
                float r0_w_18 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_19 = (-r0_w_18 + 1);
                float r0_w_20 = (r0_w_19 * cb1_values[5].z);
                float r0_w_21 = max(r0_w_20, 0);
                float r0_w_22 = mad(r0_w_21, cb5_values[1].z, cb5_values[1].w);
                float4 r0_xyzw_12 = (float4(r0_x_11, r0_y_15, r0_z_14, r0_x_11) + -cb5_values[0].xyzx);
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_16 = r0_xyzw_12.y;
                float r0_z_15 = r0_xyzw_12.z;
                o.sv_Target0.xyz = (mad(r0_w_22.xxxx, float4(r0_x_12, r0_y_16, r0_z_15, r0_x_12), cb5_values[0].xyzx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Oceancolor;
                float4 _OceanGlossiness;
                float4 _OceanAO;
                float4 _OceanEmission;
                float _AOalbedo;
                float _AOsmoothness;
                float _SmoothnessShift;
                float _EmissionScale;
                float _AOintensity;
                float4 cb0_values[10];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer UnityReflectionProbes : register(b3)
            {
                float4 unity_SpecCube0_BoxMax;
                float4 unity_SpecCube0_BoxMin;
                float4 unity_SpecCube0_ProbePosition;
                float4 unity_SpecCube0_HDR;
                float4 unity_SpecCube1_BoxMax;
                float4 unity_SpecCube1_BoxMin;
                float4 unity_SpecCube1_ProbePosition;
                float4 unity_SpecCube1_HDR;
                float4 cb3_values[26];
            };
            cbuffer UnityProbeVolume : register(b4)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb4_values[12];
            };
            cbuffer cb5 : register(b5)
            {
                float4 cb5_values[2];
            };
            cbuffer cb6 : register(b6)
            {
                float4 cb6_values[8];
            };
            cbuffer cb7 : register(b7)
            {
                float4 cb7_values[7];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            TextureCube t1 : register(t1);
            TextureCube t2 : register(t2);
            Texture3D t3 : register(t3);
            struct program16Input
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
            struct program16Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program36Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program36Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program16Output vert(program16Input i)
            {
                program16Output o = (program16Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord3.x = clipPos_xyzw_7.z;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r1_xyzw_3 = (float4(clipPos_xyzw_7.x, clipPos_xyzw_7.x, clipPos_xyzw_7.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_z_3 = r1_xyzw_3.z;
                float r1_w_4 = r1_xyzw_3.w;
                o.texcoord4.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord4.xy = ((r1_z_3.xxxx + float4(r1_x_3, r1_w_4, r1_x_3, r1_x_3))).xy;
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program36Output frag(program36Input i)
            {
                program36Output o = (program36Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_1 = log2(_OceanAO.x);
                float r1_w_2 = (r1_w_1 * _AOintensity);
                float r1_w_3 = exp2(r1_w_2);
                float r2_x_1 = (-r1_w_3 + 1);
                float r2_y_1 = (r2_x_1 * _AOalbedo);
                float r2_y_2 = r2_y_1;
                float4 r2_xyzw_3 = mad(r2_y_2.xxxx, -_Oceancolor.xxyz, _Oceancolor.xxyz);
                float r2_y_3 = r2_xyzw_3.y;
                float r2_z_1 = r2_xyzw_3.z;
                float r2_w_1 = r2_xyzw_3.w;
                float r2_x_3 = (mad(r2_x_1, _AOsmoothness, _OceanGlossiness.x) + _SmoothnessShift);
                float r3_x_1 = cb4_values[9].z;
                float r3_y_1 = cb4_values[10].z;
                float r3_z_1 = cb4_values[11].z;
                float r3_x_2 = dot(viewDir_xyz_1.xyzx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float4 r3_xyzw_2 = (i.texcoord1.xxyz + -cb3_values[25].xxyz);
                float r3_y_2 = r3_xyzw_2.y;
                float r3_z_2 = r3_xyzw_2.z;
                float r3_w_1 = r3_xyzw_2.w;
                float r3_y_3 = dot(float4(r3_y_2, r3_z_2, r3_w_1, r3_y_2), float4(r3_y_2, r3_z_2, r3_w_1, r3_y_2));
                float r3_y_4 = sqrt(r3_y_3);
                float r3_y_5 = (-r3_x_2 + r3_y_4);
                float r3_y_6 = (cb7_values[0].x == 1);
                float r4_x_8;
                float r4_y_8;
                float r4_z_8;
                float r4_w_4;
                if (r3_y_6)
                {
                    float r3_y_7 = (cb7_values[0].y == 1);
                    float3 r4_xyz_5 = (((mad(cb7_values[3].xyzx, i.texcoord1.zzzz, (mad(cb7_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb7_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb7_values[4].xyzx)).xyz;
                    float4 r3_xyzw_8 = (r3_y_7.xxxx ? r4_xyz_5.xxyz : i.texcoord1.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_3 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float4 r3_xyzw_9 = (float4(r3_y_8, r3_y_8, r3_z_3, r3_w_2) + -cb7_values[6].xxyz);
                    float r3_y_9 = r3_xyzw_9.y;
                    float r3_z_4 = r3_xyzw_9.z;
                    float r3_w_3 = r3_xyzw_9.w;
                    float4 r4_xyzw_6 = (float4(r3_y_9, r3_y_9, r3_z_4, r3_w_3) * cb7_values[5].xxyz);
                    float r4_y_6 = r4_xyzw_6.y;
                    float r4_z_6 = r4_xyzw_6.z;
                    float r4_w_2 = r4_xyzw_6.w;
                    float r3_y_10 = mad(r4_y_6, 0.25, 0.75);
                    float r3_z_5 = mad(cb7_values[0].z, 0.5, 0.75);
                    float r4_x_6 = max(r3_z_5, r3_y_10);
                    float4 r4_xyzw_7 = t3.Sample(s1, float4(r4_x_6, r4_z_6, r4_w_2, r4_x_6));
                    r4_x_8 = r4_xyzw_7.x;
                    r4_y_8 = r4_xyzw_7.y;
                    r4_z_8 = r4_xyzw_7.z;
                    r4_w_4 = r4_xyzw_7.w;
                }
                else
                {
                    float4 r4_xyzw_8 = float4(1, 1, 1, 1);
                    r4_x_8 = r4_xyzw_8.x;
                    r4_y_8 = r4_xyzw_8.y;
                    r4_z_8 = r4_xyzw_8.z;
                    r4_w_4 = r4_xyzw_8.w;
                }
                float r3_y_12 = dot(float4(r4_x_8, r4_y_8, r4_z_8, r4_w_4), unity_OcclusionMaskSelector);
                float4 r3_xyzw_7 = (i.texcoord4.xxxy / i.texcoord4.wwww);
                float r3_z_7 = r3_xyzw_7.z;
                float r3_w_5 = r3_xyzw_7.w;
                float4 r4_xyzw_9 = t0.Sample(s2, float4(r3_z_7, r3_w_5, r3_z_7, r3_z_7));
                float r3_y_13 = (r3_y_12 + -r4_xyzw_9.x);
                float r3_y_14 = (-r2_x_3 + 1);
                float r3_z_8 = dot(-unitViewDir_xyz_1.xyzx, i.texcoord0.xyzx);
                float r3_z_9 = (r3_z_8 + r3_z_8);
                float3 r4_xyz_10 = (mad(i.texcoord0.xyzx, -r3_z_9.xxxx, -unitViewDir_xyz_1.xyzx)).xyz;
                float4 r3_xyzw_6 = ((mad(mad(mad(cb3_values[25].w, r3_y_5, r3_x_2), cb3_values[24].z, cb3_values[24].w), r3_y_13, r4_xyzw_9.x)).xxxx * _LightColor0.xxyz);
                float r3_x_6 = r3_xyzw_6.x;
                float r3_z_10 = r3_xyzw_6.z;
                float r3_w_6 = r3_xyzw_6.w;
                float r4_w_6 = (0 < cb6_values[2].w);
                float3 r5_xyz_4;
                if (r4_w_6)
                {
                    float r4_w_7 = dot(r4_xyz_10.xyzx, r4_xyz_10.xyzx);
                    float r4_w_8 = rsqrt(r4_w_7);
                    float3 r5_xyz_2 = ((r4_w_8.xxxx * r4_xyz_10.xyzx)).xyz;
                    float3 r8_xyz_1 = ((float4(0, 0, 0, 0) < r5_xyz_2.xyzx)).xyz;
                    float3 r6_xyz_3 = ((r8_xyz_1.xyzx ? ((((-i.texcoord1.xyzx + cb6_values[0].xyzx)).xyzx / r5_xyz_2.xyzx)).xyzx : ((((-i.texcoord1.xyzx + cb6_values[1].xyzx)).xyzx / r5_xyz_2.xyzx)).xyzx)).xyz;
                    float r4_w_9 = min(r6_xyz_3.y, r6_xyz_3.x);
                    float r4_w_10 = min(r6_xyz_3.z, r4_w_9);
                    r5_xyz_4 = (mad(r5_xyz_2.xyzx, r4_w_10.xxxx, ((i.texcoord1.xyzx + -cb6_values[2].xyzx)).xyzx)).xyz;
                }
                else
                {
                    r5_xyz_4 = (r4_xyz_10.xyzx).xyz;
                }
                float r4_w_12 = mad(-r3_y_14, 0.7, 1.7);
                float r4_w_13 = (r3_y_14 * r4_w_12);
                float r4_w_14 = (r4_w_13 * 6);
                float4 r5_xyzw_5 = t1.SampleLevel(s0, r5_xyz_4.xyzx, r4_w_14);
                float r5_w_2 = (r5_xyzw_5.w + -1);
                float r5_w_3 = mad(cb6_values[3].w, r5_w_2, 1);
                float r5_w_4 = (r5_w_3 * cb6_values[3].x);
                float r6_w_1 = (cb6_values[1].w < 0.99999);
                float3 r6_xyz_8 = ((r5_xyzw_5.xyzx * r5_w_4.xxxx)).xyz;
                if (r6_w_1)
                {
                    float r6_w_2 = (0 < cb6_values[6].w);
                    float3 r4_xyz_12 = r4_xyz_10;
                    if (r6_w_2)
                    {
                        float r6_w_3 = dot(r4_xyz_10.xyzx, r4_xyz_10.xyzx);
                        float r6_w_4 = rsqrt(r6_w_3);
                        float3 r7_xyz_4 = ((r4_xyz_10.xyzx * r6_w_4.xxxx)).xyz;
                        float3 r10_xyz_1 = ((float4(0, 0, 0, 0) < r7_xyz_4.xyzx)).xyz;
                        float3 r8_xyz_5 = ((r10_xyz_1.xyzx ? ((((-i.texcoord1.xyzx + cb6_values[4].xyzx)).xyzx / r7_xyz_4.xyzx)).xyzx : ((((-i.texcoord1.xyzx + cb6_values[5].xyzx)).xyzx / r7_xyz_4.xyzx)).xyzx)).xyz;
                        float r6_w_5 = min(r8_xyz_5.y, r8_xyz_5.x);
                        float r6_w_6 = min(r8_xyz_5.z, r6_w_5);
                        r4_xyz_12 = (mad(r7_xyz_4.xyzx, r6_w_6.xxxx, ((i.texcoord1.xyzx + -cb6_values[6].xyzx)).xyzx)).xyz;
                    }
                    float4 r4_xyzw_13 = t2.SampleLevel(s0, r4_xyz_12.xyzx, r4_w_14);
                    float r4_w_16 = (r4_xyzw_13.w + -1);
                    float r4_w_17 = mad(cb6_values[7].w, r4_w_16, 1);
                    float r4_w_18 = (r4_w_17 * cb6_values[7].x);
                    float3 r4_xyz_14 = ((r4_xyzw_13.xyzx * r4_w_18.xxxx)).xyz;
                    r6_xyz_8 = (mad(cb6_values[1].wwww, (mad(r5_w_4.xxxx, r5_xyzw_5.xyzx, -r4_xyz_14.xyzx)).xyzx, r4_xyz_14.xyzx)).xyz;
                }
                float r1_w_4 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r1_w_5 = rsqrt(r1_w_4);
                float3 unitWorldNormal_xyz_8 = ((r1_w_5.xxxx * i.texcoord0.xyzx)).xyz;
                float4 r2_xyzw_4 = (float4(r2_y_3, r2_y_3, r2_z_1, r2_w_1) * float4(0, 0.7790837, 0.7790837, 0.7790837));
                float r2_y_4 = r2_xyzw_4.y;
                float r2_z_2 = r2_xyzw_4.z;
                float r2_w_2 = r2_xyzw_4.w;
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitWorldNormal_xyz_8.xyzx, unitViewDir_xyz_1.xyzx);
                float r1_x_2 = dot(unitWorldNormal_xyz_8.xyzx, _WorldSpaceLightPos0.xyzx);
                float r1_y_2 = dot(unitWorldNormal_xyz_8.xyzx, r0_xyz_3.xyzx);
                float r0_x_4 = dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r3_y_14.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(nDotV_w_6) + 1);
                float r1_w_6 = (r1_z_4 * r1_z_4);
                float r1_w_7 = (r1_w_6 * r1_w_6);
                float r1_z_5 = (r1_z_4 * r1_w_7);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r3_y_14 * r3_y_14);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_w_8 = (-r0_z_8 + 1);
                float r4_w_20 = mad(abs(nDotV_w_6), r1_w_8, r0_z_8);
                float r1_w_9 = mad(r1_x_2, r1_w_8, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * r1_w_9);
                float r0_w_8 = mad(r1_x_2, r4_w_20, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r1_w_10 = (r0_z_8 * r0_z_8);
                float r4_w_21 = mad(r1_y_2, r1_w_10, -r1_y_2);
                float r1_y_3 = mad(r4_w_21, r1_y_2, 1);
                float r1_w_11 = (r1_w_10 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r1_y_5 = (r1_w_11 / r1_y_4);
                float r0_w_11 = (r0_w_10 * r1_y_5);
                float4 r0_xyzw_9 = (float4(r0_z_8, r0_z_8, r0_z_8, r0_w_11) * float4(0, 0, 0.28, 3.1415927));
                float r0_z_9 = r0_xyzw_9.z;
                float r0_w_12 = r0_xyzw_9.w;
                float r0_w_13 = max(r0_w_12, 0.0001);
                float r0_w_14 = sqrt(r0_w_13);
                float r0_y_9 = ((r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_y_8, r0_w_14))).y;
                float r0_w_15 = ((r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_y_8, r0_w_14))).w;
                float r0_z_10 = mad(-r0_z_9, r3_y_14, 1);
                float r3_x_7 = ((float4(r3_x_6, r3_z_10, r3_w_6, r3_x_6) * r0_w_15.xxxx)).x;
                float4 r3_xyzw_15 = (float4(r3_x_6, r3_z_10, r3_w_6, r3_x_6) * r0_w_15.xxxx);
                float r3_y_15 = r3_xyzw_15.y;
                float r3_z_11 = r3_xyzw_15.z;
                float r0_x_5 = (-r0_x_4 + 1);
                float r0_y_10 = (r0_x_5 * r0_x_5);
                float r0_y_11 = (r0_y_10 * r0_y_10);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r0_y_11), 0.7790837, 0.2209163)).xxxx * float4(r3_x_7, r3_y_15, r3_x_7, r3_z_11));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_w_16 = r0_xyzw_8.w;
                float r0_x_9 = (mad(float4(r2_y_4, r2_z_2, r2_y_4, r2_w_2), ((r0_y_9.xxxx * float4(r3_x_6, r3_z_10, r3_w_6, r3_x_6))).xyxz, float4(r0_x_8, r0_y_12, r0_x_8, r0_w_16))).x;
                float4 r0_xyzw_13 = mad(float4(r2_y_4, r2_z_2, r2_y_4, r2_w_2), ((r0_y_9.xxxx * float4(r3_x_6, r3_z_10, r3_w_6, r3_x_6))).xyxz, float4(r0_x_8, r0_y_12, r0_x_8, r0_w_16));
                float r0_y_13 = r0_xyzw_13.y;
                float r0_w_17 = r0_xyzw_13.w;
                float r2_x_4 = ((((r1_w_3.xxxx * r6_xyz_8.xyzx)).xyzx * r0_z_10.xxxx)).x;
                float4 r2_xyzw_5 = (((r1_w_3.xxxx * r6_xyz_8.xyzx)).xyzx * r0_z_10.xxxx);
                float r2_y_5 = r2_xyzw_5.y;
                float r2_z_3 = r2_xyzw_5.z;
                float r0_z_11 = (min((r2_x_3 + 0.22091627), 1) + -0.2209163);
                float r0_z_12 = mad(r1_z_5, r0_z_11, 0.2209163);
                float4 r0_xyzw_10 = mad(float4(r2_x_4, r2_y_5, r2_z_3, r2_x_4), r0_z_12.xxxx, float4(r0_x_9, r0_y_13, r0_w_17, r0_x_9));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_14 = r0_xyzw_10.y;
                float r0_z_13 = r0_xyzw_10.z;
                float4 r0_xyzw_11 = mad(_OceanEmission.xyzx, _EmissionScale.xxxx, float4(r0_x_10, r0_y_14, r0_z_13, r0_x_10));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_y_15 = r0_xyzw_11.y;
                float r0_z_14 = r0_xyzw_11.z;
                float r0_w_18 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_19 = (-r0_w_18 + 1);
                float r0_w_20 = (r0_w_19 * cb1_values[5].z);
                float r0_w_21 = max(r0_w_20, 0);
                float r0_w_22 = mad(r0_w_21, cb5_values[1].z, cb5_values[1].w);
                float4 r0_xyzw_12 = (float4(r0_x_11, r0_y_15, r0_z_14, r0_x_11) + -cb5_values[0].xyzx);
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_16 = r0_xyzw_12.y;
                float r0_z_15 = r0_xyzw_12.z;
                o.sv_Target0.xyz = (mad(r0_w_22.xxxx, float4(r0_x_12, r0_y_16, r0_z_15, r0_x_12), cb5_values[0].xyzx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Oceancolor;
                float4 _OceanGlossiness;
                float4 _OceanAO;
                float4 _OceanEmission;
                float _AOalbedo;
                float _AOsmoothness;
                float _SmoothnessShift;
                float _EmissionScale;
                float _AOintensity;
                float4 cb0_values[46];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer UnityReflectionProbes : register(b3)
            {
                float4 unity_SpecCube0_BoxMax;
                float4 unity_SpecCube0_BoxMin;
                float4 unity_SpecCube0_ProbePosition;
                float4 unity_SpecCube0_HDR;
                float4 unity_SpecCube1_BoxMax;
                float4 unity_SpecCube1_BoxMin;
                float4 unity_SpecCube1_ProbePosition;
                float4 unity_SpecCube1_HDR;
                float4 cb3_values[2];
            };
            cbuffer UnityProbeVolume : register(b4)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb4_values[8];
            };
            cbuffer cb5 : register(b5)
            {
                float4 cb5_values[7];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            TextureCube t0 : register(t0);
            TextureCube t1 : register(t1);
            Texture3D t2 : register(t2);
            struct program15Input
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
            struct program15Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program35Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program35Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program15Output vert(program15Input i)
            {
                program15Output o = (program15Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                float worldNormal_x_8 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                float3 unitWorldNormal_xyz_9 = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                o.texcoord0.xyz = (unitWorldNormal_xyz_9.xyzx).xyz;
                float r0_w_10 = (unitWorldNormal_xyz_9.y * unitWorldNormal_xyz_9.y);
                float r0_w_11 = mad(unitWorldNormal_xyz_9.x, unitWorldNormal_xyz_9.x, -r0_w_10);
                float4 r1_xyzw_2 = (unitWorldNormal_xyz_9.yzzx * unitWorldNormal_xyz_9.xyzz);
                float r0_x_10 = dot(cb0_values[42].xyzw, r1_xyzw_2);
                float r0_y_10 = dot(cb0_values[43].xyzw, r1_xyzw_2);
                float r0_z_10 = dot(cb0_values[44].xyzw, r1_xyzw_2);
                o.texcoord2.xyz = (mad(cb0_values[45].xyzx, r0_w_11.xxxx, float4(r0_x_10, r0_y_10, r0_z_10, r0_x_10))).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program35Output frag(program35Input i)
            {
                program35Output o = (program35Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_1 = log2(_OceanAO.x);
                float r1_w_2 = (r1_w_1 * _AOintensity);
                float r1_w_3 = exp2(r1_w_2);
                float r2_x_1 = (-r1_w_3 + 1);
                float r2_y_1 = (r2_x_1 * _AOalbedo);
                float r2_y_2 = r2_y_1;
                float4 r2_xyzw_3 = mad(r2_y_2.xxxx, -_Oceancolor.xxyz, _Oceancolor.xxyz);
                float r2_y_3 = r2_xyzw_3.y;
                float r2_z_1 = r2_xyzw_3.z;
                float r2_w_1 = r2_xyzw_3.w;
                float r2_x_3 = (mad(r2_x_1, _AOsmoothness, _OceanGlossiness.x) + _SmoothnessShift);
                float r3_x_1 = (cb5_values[0].x == 1);
                float r4_x_8;
                float r4_y_8;
                float r4_z_8;
                float r4_w_4;
                if (r3_x_1)
                {
                    float r3_y_1 = (cb5_values[0].y == 1);
                    float3 r4_xyz_5 = (((mad(cb5_values[3].xyzx, i.texcoord1.zzzz, (mad(cb5_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r3_xyzw_2 = (r3_y_1.xxxx ? r4_xyz_5.xxyz : i.texcoord1.xxyz);
                    float r3_y_2 = r3_xyzw_2.y;
                    float r3_z_1 = r3_xyzw_2.z;
                    float r3_w_1 = r3_xyzw_2.w;
                    float4 r3_xyzw_3 = (float4(r3_y_2, r3_y_2, r3_z_1, r3_w_1) + -cb5_values[6].xxyz);
                    float r3_y_3 = r3_xyzw_3.y;
                    float r3_z_2 = r3_xyzw_3.z;
                    float r3_w_2 = r3_xyzw_3.w;
                    float4 r4_xyzw_6 = (float4(r3_y_3, r3_y_3, r3_z_2, r3_w_2) * cb5_values[5].xxyz);
                    float r4_y_6 = r4_xyzw_6.y;
                    float r4_z_6 = r4_xyzw_6.z;
                    float r4_w_2 = r4_xyzw_6.w;
                    float r3_y_4 = mad(r4_y_6, 0.25, 0.75);
                    float r3_z_3 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r4_x_6 = max(r3_z_3, r3_y_4);
                    float4 r4_xyzw_7 = t2.Sample(s1, float4(r4_x_6, r4_z_6, r4_w_2, r4_x_6));
                    r4_x_8 = r4_xyzw_7.x;
                    r4_y_8 = r4_xyzw_7.y;
                    r4_z_8 = r4_xyzw_7.z;
                    r4_w_4 = r4_xyzw_7.w;
                }
                else
                {
                    float4 r4_xyzw_8 = float4(1, 1, 1, 1);
                    r4_x_8 = r4_xyzw_8.x;
                    r4_y_8 = r4_xyzw_8.y;
                    r4_z_8 = r4_xyzw_8.z;
                    r4_w_4 = r4_xyzw_8.w;
                }
                float r3_y_6 = dot(float4(r4_x_8, r4_y_8, r4_z_8, r4_w_4), unity_OcclusionMaskSelector);
                float r3_z_5 = (-r2_x_3 + 1);
                float r3_w_4 = dot(-unitViewDir_xyz_1.xyzx, i.texcoord0.xyzx);
                float r3_w_5 = (r3_w_4 + r3_w_4);
                float3 r4_xyz_9 = (mad(i.texcoord0.xyzx, -r3_w_5.xxxx, -unitViewDir_xyz_1.xyzx)).xyz;
                float3 r5_xyz_1 = ((r3_y_6.xxxx * _LightColor0.xyzx)).xyz;
                float3 TEXCOORD0_xyz_1;
                float3 r7_xyz_4;
                if ((r3_x_1 != 0))
                {
                    float3 r6_xyz_5 = (((mad(cb5_values[3].xyzx, i.texcoord1.zzzz, (mad(cb5_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float r3_x_3 = ((((cb5_values[0].y == 1)).xxxx ? r6_xyz_5.xyxz : i.texcoord1.xyxz)).x;
                    float4 r3_xyzw_7 = (((cb5_values[0].y == 1)).xxxx ? r6_xyz_5.xyxz : i.texcoord1.xyxz);
                    float r3_y_7 = r3_xyzw_7.y;
                    float r3_w_6 = r3_xyzw_7.w;
                    float4 r3_xyzw_4 = (float4(r3_x_3, r3_y_7, r3_x_3, r3_w_6) + -cb5_values[6].xyxz);
                    float r3_x_4 = r3_xyzw_4.x;
                    float r3_y_8 = r3_xyzw_4.y;
                    float r3_w_7 = r3_xyzw_4.w;
                    float4 r6_xyzw_6 = (float4(r3_x_4, r3_x_4, r3_y_8, r3_w_7) * cb5_values[5].xxyz);
                    float r6_y_6 = r6_xyzw_6.y;
                    float r6_z_6 = r6_xyzw_6.z;
                    float r6_w_2 = r6_xyzw_6.w;
                    float r3_y_9 = (cb5_values[0].z * 0.5);
                    float r3_w_8 = mad(-cb5_values[0].z, 0.5, 0.25);
                    float r6_x_6 = min(r3_w_8, max(r3_y_9, (r6_y_6 * 0.25)));
                    float4 r7_xyzw_2 = t2.Sample(s1, float4(r6_x_6, r6_z_6, r6_w_2, r6_x_6));
                    float r3_x_7 = ((float4(r6_x_6, r6_z_6, r6_x_6, r6_w_2) + float4(0.25, 0, 0, 0))).x;
                    float4 r3_xyzw_10 = (float4(r6_x_6, r6_z_6, r6_x_6, r6_w_2) + float4(0.25, 0, 0, 0));
                    float r3_y_10 = r3_xyzw_10.y;
                    float r3_w_9 = r3_xyzw_10.w;
                    float4 r8_xyzw_1 = t2.Sample(s1, float4(r3_x_7, r3_y_10, r3_w_9, r3_x_7));
                    float4 r3_xyzw_8 = (float4(r6_x_6, r6_z_6, r6_x_6, r6_w_2) + float4(0.5, 0, 0, 0));
                    float r3_x_8 = r3_xyzw_8.x;
                    float r3_y_11 = r3_xyzw_8.y;
                    float r3_w_10 = r3_xyzw_8.w;
                    float4 r6_xyzw_7 = t2.Sample(s1, float4(r3_x_8, r3_y_11, r3_w_10, r3_x_8));
                    TEXCOORD0_xyz_1 = (i.texcoord0.xyzx).xyz;
                    float r9_w_1 = 1;
                    float r7_x_3 = dot(r7_xyzw_2, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r9_w_1));
                    float r7_y_3 = dot(r8_xyzw_1, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r9_w_1));
                    float r7_z_3 = dot(r6_xyzw_7, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r9_w_1));
                    r7_xyz_4 = float3(r7_x_3, r7_y_3, r7_z_3);
                }
                else
                {
                    TEXCOORD0_xyz_1 = (i.texcoord0.xyzx).xyz;
                    float r6_w_1 = 1;
                    float r7_x_1 = dot(cb2_values[39].xyzw, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r6_w_1));
                    float r7_y_1 = dot(cb2_values[40].xyzw, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r6_w_1));
                    float r7_z_1 = dot(cb2_values[41].xyzw, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r6_w_1));
                    r7_xyz_4 = float3(r7_x_1, r7_y_1, r7_z_1);
                }
                float r3_x_10 = ((r7_xyz_4.xyxz + i.texcoord2.xyxz)).x;
                float4 r3_xyzw_13 = (r7_xyz_4.xyxz + i.texcoord2.xyxz);
                float r3_y_13 = r3_xyzw_13.y;
                float r3_w_12 = r3_xyzw_13.w;
                float4 r3_xyzw_11 = max(float4(r3_x_10, r3_y_13, r3_x_10, r3_w_12), float4(0, 0, 0, 0));
                float r3_x_11 = r3_xyzw_11.x;
                float r3_y_14 = r3_xyzw_11.y;
                float r3_w_13 = r3_xyzw_11.w;
                float4 r3_xyzw_12 = log2(float4(r3_x_11, r3_y_14, r3_x_11, r3_w_13));
                float r3_x_12 = r3_xyzw_12.x;
                float r3_y_15 = r3_xyzw_12.y;
                float r3_w_14 = r3_xyzw_12.w;
                float r3_x_13 = ((float4(r3_x_12, r3_y_15, r3_x_12, r3_w_14) * float4(0.41666666, 0.41666666, 0, 0.41666666))).x;
                float4 r3_xyzw_16 = (float4(r3_x_12, r3_y_15, r3_x_12, r3_w_14) * float4(0.41666666, 0.41666666, 0, 0.41666666));
                float r3_y_16 = r3_xyzw_16.y;
                float r3_w_15 = r3_xyzw_16.w;
                float4 r3_xyzw_14 = exp2(float4(r3_x_13, r3_y_16, r3_x_13, r3_w_15));
                float r3_x_14 = r3_xyzw_14.x;
                float r3_y_17 = r3_xyzw_14.y;
                float r3_w_16 = r3_xyzw_14.w;
                float4 r3_xyzw_15 = mad(float4(r3_x_14, r3_y_17, r3_x_14, r3_w_16), float4(1.055, 1.055, 0, 1.055), float4(-0.055, -0.055, 0, -0.055));
                float r3_x_15 = r3_xyzw_15.x;
                float r3_y_18 = r3_xyzw_15.y;
                float r3_w_17 = r3_xyzw_15.w;
                float r3_x_16 = (max(float4(r3_x_15, r3_y_18, r3_x_15, r3_w_17), float4(0, 0, 0, 0))).x;
                float4 r3_xyzw_19 = max(float4(r3_x_15, r3_y_18, r3_x_15, r3_w_17), float4(0, 0, 0, 0));
                float r3_y_19 = r3_xyzw_19.y;
                float r3_w_18 = r3_xyzw_19.w;
                float r4_w_5 = (0 < unity_ProbeVolumeWorldToObject[1].w);
                float3 r6_xyz_12;
                if (r4_w_5)
                {
                    float r4_w_6 = dot(r4_xyz_9.xyzx, r4_xyz_9.xyzx);
                    float r4_w_7 = rsqrt(r4_w_6);
                    float3 r6_xyz_10 = ((r4_w_7.xxxx * r4_xyz_9.xyzx)).xyz;
                    float3 r9_xyz_3 = ((float4(0, 0, 0, 0) < r6_xyz_10.xyzx)).xyz;
                    float3 r7_xyz_7 = ((r9_xyz_3.xyzx ? ((((-i.texcoord1.xyzx + unity_ProbeVolumeParams.xyzx)).xyzx / r6_xyz_10.xyzx)).xyzx : ((((-i.texcoord1.xyzx + unity_ProbeVolumeWorldToObject[0].xyzx)).xyzx / r6_xyz_10.xyzx)).xyzx)).xyz;
                    float r4_w_8 = min(r7_xyz_7.y, r7_xyz_7.x);
                    float r4_w_9 = min(r7_xyz_7.z, r4_w_8);
                    r6_xyz_12 = (mad(r6_xyz_10.xyzx, r4_w_9.xxxx, ((i.texcoord1.xyzx + -unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyz;
                }
                else
                {
                    r6_xyz_12 = (r4_xyz_9.xyzx).xyz;
                }
                float r4_w_11 = mad(-r3_z_5, 0.7, 1.7);
                float r4_w_12 = (r3_z_5 * r4_w_11);
                float r4_w_13 = (r4_w_12 * 6);
                float4 r6_xyzw_13 = t0.SampleLevel(s0, r6_xyz_12.xyzx, r4_w_13);
                float r5_w_1 = (r6_xyzw_13.w + -1);
                float r5_w_2 = mad(unity_ProbeVolumeWorldToObject[2].w, r5_w_1, 1);
                float r5_w_3 = (r5_w_2 * unity_ProbeVolumeWorldToObject[2].x);
                float r6_w_6 = (unity_ProbeVolumeWorldToObject[0].w < 0.99999);
                float3 r7_xyz_12 = ((r6_xyzw_13.xyzx * r5_w_3.xxxx)).xyz;
                if (r6_w_6)
                {
                    float r6_w_7 = (0 < cb4_values[6].w);
                    float3 r4_xyz_11 = r4_xyz_9;
                    if (r6_w_7)
                    {
                        float r6_w_8 = dot(r4_xyz_9.xyzx, r4_xyz_9.xyzx);
                        float r6_w_9 = rsqrt(r6_w_8);
                        float3 r8_xyz_6 = ((r4_xyz_9.xyzx * r6_w_9.xxxx)).xyz;
                        float3 r11_xyz_1 = ((float4(0, 0, 0, 0) < r8_xyz_6.xyzx)).xyz;
                        float3 r9_xyz_7 = ((r11_xyz_1.xyzx ? ((((-i.texcoord1.xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyzx / r8_xyz_6.xyzx)).xyzx : ((((-i.texcoord1.xyzx + unity_ProbeVolumeSizeInv.xyzx)).xyzx / r8_xyz_6.xyzx)).xyzx)).xyz;
                        float r6_w_10 = min(r9_xyz_7.y, r9_xyz_7.x);
                        float r6_w_11 = min(r9_xyz_7.z, r6_w_10);
                        r4_xyz_11 = (mad(r8_xyz_6.xyzx, r6_w_11.xxxx, ((i.texcoord1.xyzx + -unity_ProbeVolumeMin.xyzx)).xyzx)).xyz;
                    }
                    float4 r4_xyzw_12 = t1.SampleLevel(s0, r4_xyz_11.xyzx, r4_w_13);
                    float r4_w_15 = (r4_xyzw_12.w + -1);
                    float r4_w_16 = mad(cb4_values[7].w, r4_w_15, 1);
                    float r4_w_17 = (r4_w_16 * cb4_values[7].x);
                    float3 r4_xyz_13 = ((r4_xyzw_12.xyzx * r4_w_17.xxxx)).xyz;
                    r7_xyz_12 = (mad(unity_ProbeVolumeWorldToObject[0].wwww, (mad(r5_w_3.xxxx, r6_xyzw_13.xyzx, -r4_xyz_13.xyzx)).xyzx, r4_xyz_13.xyzx)).xyz;
                }
                float r4_w_19 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r4_w_20 = rsqrt(r4_w_19);
                float3 unitClipPos_xyz_16 = ((r4_w_20.xxxx * i.texcoord0.xyzx)).xyz;
                float4 r2_xyzw_4 = (float4(r2_y_3, r2_y_3, r2_z_1, r2_w_1) * float4(0, 0.7790837, 0.7790837, 0.7790837));
                float r2_y_4 = r2_xyzw_4.y;
                float r2_z_2 = r2_xyzw_4.z;
                float r2_w_2 = r2_xyzw_4.w;
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitClipPos_xyz_16.xyzx, unitViewDir_xyz_1.xyzx);
                float r1_x_2 = dot(unitClipPos_xyz_16.xyzx, _WorldSpaceLightPos0.xyzx);
                float r1_y_2 = dot(unitClipPos_xyz_16.xyzx, r0_xyz_3.xyzx);
                float r0_x_4 = dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r3_z_5.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(nDotV_w_6) + 1);
                float r4_w_21 = (r1_z_4 * r1_z_4);
                float r4_w_22 = (r4_w_21 * r4_w_21);
                float r1_z_5 = (r1_z_4 * r4_w_22);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r3_z_5 * r3_z_5);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r4_w_23 = (-r0_z_8 + 1);
                float r5_w_4 = mad(abs(nDotV_w_6), r4_w_23, r0_z_8);
                float r4_w_24 = mad(r1_x_2, r4_w_23, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * r4_w_24);
                float r0_w_8 = mad(r1_x_2, r5_w_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r4_w_25 = (r0_z_8 * r0_z_8);
                float r5_w_5 = mad(r1_y_2, r4_w_25, -r1_y_2);
                float r1_y_3 = mad(r5_w_5, r1_y_2, 1);
                float r4_w_26 = (r4_w_25 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r1_y_5 = (r4_w_26 / r1_y_4);
                float r0_w_11 = (r0_w_10 * r1_y_5);
                float4 r0_xyzw_9 = (float4(r0_z_8, r0_z_8, r0_z_8, r0_w_11) * float4(0, 0, 0.28, 3.1415927));
                float r0_z_9 = r0_xyzw_9.z;
                float r0_w_12 = r0_xyzw_9.w;
                float r0_w_13 = max(r0_w_12, 0.0001);
                float r0_w_14 = sqrt(r0_w_13);
                float r0_y_9 = ((r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_y_8, r0_w_14))).y;
                float r0_w_15 = ((r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_y_8, r0_w_14))).w;
                float r0_z_10 = mad(-r0_z_9, r3_z_5, 1);
                float4 r3_xyzw_17 = mad(float4(r3_x_16, r3_y_19, r3_w_18, r3_x_16), r1_w_3.xxxx, ((r0_y_9.xxxx * r5_xyz_1.xyzx)).xyzx);
                float r3_x_17 = r3_xyzw_17.x;
                float r3_y_20 = r3_xyzw_17.y;
                float r3_z_6 = r3_xyzw_17.z;
                float r0_x_5 = (-r0_x_4 + 1);
                float r0_y_10 = (r0_x_5 * r0_x_5);
                float r0_y_11 = (r0_y_10 * r0_y_10);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r0_y_11), 0.7790837, 0.2209163)).xxxx * ((r5_xyz_1.xyzx * r0_w_15.xxxx)).xyxz);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_w_16 = r0_xyzw_8.w;
                float r0_x_9 = (mad(float4(r2_y_4, r2_z_2, r2_y_4, r2_w_2), float4(r3_x_17, r3_y_20, r3_x_17, r3_z_6), float4(r0_x_8, r0_y_12, r0_x_8, r0_w_16))).x;
                float4 r0_xyzw_13 = mad(float4(r2_y_4, r2_z_2, r2_y_4, r2_w_2), float4(r3_x_17, r3_y_20, r3_x_17, r3_z_6), float4(r0_x_8, r0_y_12, r0_x_8, r0_w_16));
                float r0_y_13 = r0_xyzw_13.y;
                float r0_w_17 = r0_xyzw_13.w;
                float r2_x_4 = ((((r1_w_3.xxxx * r7_xyz_12.xyzx)).xyzx * r0_z_10.xxxx)).x;
                float4 r2_xyzw_5 = (((r1_w_3.xxxx * r7_xyz_12.xyzx)).xyzx * r0_z_10.xxxx);
                float r2_y_5 = r2_xyzw_5.y;
                float r2_z_3 = r2_xyzw_5.z;
                float r0_z_11 = (min((r2_x_3 + 0.22091627), 1) + -0.2209163);
                float r0_z_12 = mad(r1_z_5, r0_z_11, 0.2209163);
                float4 r0_xyzw_10 = mad(float4(r2_x_4, r2_y_5, r2_z_3, r2_x_4), r0_z_12.xxxx, float4(r0_x_9, r0_y_13, r0_w_17, r0_x_9));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_14 = r0_xyzw_10.y;
                float r0_z_13 = r0_xyzw_10.z;
                float4 r0_xyzw_11 = mad(_OceanEmission.xyzx, _EmissionScale.xxxx, float4(r0_x_10, r0_y_14, r0_z_13, r0_x_10));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_y_15 = r0_xyzw_11.y;
                float r0_z_14 = r0_xyzw_11.z;
                float r0_w_18 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_19 = (-r0_w_18 + 1);
                float r0_w_20 = (r0_w_19 * cb1_values[5].z);
                float r0_w_21 = max(r0_w_20, 0);
                float r0_w_22 = mad(r0_w_21, unity_SpecCube0_BoxMin.z, unity_SpecCube0_BoxMin.w);
                float4 r0_xyzw_12 = (float4(r0_x_11, r0_y_15, r0_z_14, r0_x_11) + -unity_SpecCube0_BoxMax.xyzx);
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_16 = r0_xyzw_12.y;
                float r0_z_15 = r0_xyzw_12.z;
                o.sv_Target0.xyz = (mad(r0_w_22.xxxx, float4(r0_x_12, r0_y_16, r0_z_15, r0_x_12), unity_SpecCube0_BoxMax.xyzx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Oceancolor;
                float4 _OceanGlossiness;
                float4 _OceanAO;
                float4 _OceanEmission;
                float _AOalbedo;
                float _AOsmoothness;
                float _SmoothnessShift;
                float _EmissionScale;
                float _AOintensity;
                float4 cb0_values[10];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[21];
            };
            cbuffer UnityLighting : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer UnityReflectionProbes : register(b3)
            {
                float4 unity_SpecCube0_BoxMax;
                float4 unity_SpecCube0_BoxMin;
                float4 unity_SpecCube0_ProbePosition;
                float4 unity_SpecCube0_HDR;
                float4 unity_SpecCube1_BoxMax;
                float4 unity_SpecCube1_BoxMin;
                float4 unity_SpecCube1_ProbePosition;
                float4 unity_SpecCube1_HDR;
                float4 cb3_values[2];
            };
            cbuffer UnityProbeVolume : register(b4)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb4_values[8];
            };
            cbuffer cb5 : register(b5)
            {
                float4 cb5_values[7];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            TextureCube t0 : register(t0);
            TextureCube t1 : register(t1);
            Texture3D t2 : register(t2);
            struct program14Input
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
            struct program14Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program34Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program34Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program14Output vert(program14Input i)
            {
                program14Output o = (program14Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord1.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord0.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program34Output frag(program34Input i)
            {
                program34Output o = (program34Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_1 = log2(_OceanAO.x);
                float r1_w_2 = (r1_w_1 * _AOintensity);
                float r1_w_3 = exp2(r1_w_2);
                float r2_x_1 = (-r1_w_3 + 1);
                float r2_y_1 = (r2_x_1 * _AOalbedo);
                float r2_y_2 = r2_y_1;
                float4 r2_xyzw_3 = mad(r2_y_2.xxxx, -_Oceancolor.xxyz, _Oceancolor.xxyz);
                float r2_y_3 = r2_xyzw_3.y;
                float r2_z_1 = r2_xyzw_3.z;
                float r2_w_1 = r2_xyzw_3.w;
                float r2_x_3 = (mad(r2_x_1, _AOsmoothness, _OceanGlossiness.x) + _SmoothnessShift);
                float r3_x_8;
                float r3_y_11;
                float r3_z_10;
                float r3_w_8;
                if ((cb5_values[0].x == 1))
                {
                    float3 r3_yzw_2 = ((i.texcoord1.yyyy * cb5_values[2].xxyz)).yzw;
                    float3 r3_yzw_3 = (mad(cb5_values[1].xxyz, i.texcoord1.xxxx, r3_yzw_2.xxyz)).yzw;
                    float3 r3_yzw_4 = (mad(cb5_values[3].xxyz, i.texcoord1.zzzz, r3_yzw_3.xxyz)).yzw;
                    float3 r3_yzw_5 = ((r3_yzw_4.xxyz + cb5_values[4].xxyz)).yzw;
                    float4 r3_xyzw_4 = (((cb5_values[0].y == 1)).xxxx ? r3_yzw_5.xyzx : i.texcoord1.xyzx);
                    float r3_x_4 = r3_xyzw_4.x;
                    float r3_y_6 = r3_xyzw_4.y;
                    float r3_z_6 = r3_xyzw_4.z;
                    float4 r3_xyzw_5 = (float4(r3_x_4, r3_y_6, r3_z_6, r3_x_4) + -cb5_values[6].xyzx);
                    float r3_x_5 = r3_xyzw_5.x;
                    float r3_y_7 = r3_xyzw_5.y;
                    float r3_z_7 = r3_xyzw_5.z;
                    float4 r3_xyzw_8 = (float4(r3_x_5, r3_x_5, r3_y_7, r3_z_7) * cb5_values[5].xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_6 = r3_xyzw_8.w;
                    float r3_y_9 = mad(r3_y_8, 0.25, 0.75);
                    float r3_x_6 = max(r3_y_9, mad(cb5_values[0].z, 0.5, 0.75));
                    float4 r3_xyzw_7 = t2.Sample(s1, float4(r3_x_6, r3_z_8, r3_w_6, r3_x_6));
                    r3_x_8 = r3_xyzw_7.x;
                    r3_y_11 = r3_xyzw_7.y;
                    r3_z_10 = r3_xyzw_7.z;
                    r3_w_8 = r3_xyzw_7.w;
                }
                else
                {
                    float4 r3_xyzw_2 = float4(1, 1, 1, 1);
                    r3_x_8 = r3_xyzw_2.x;
                    r3_y_11 = r3_xyzw_2.y;
                    r3_z_10 = r3_xyzw_2.z;
                    r3_w_8 = r3_xyzw_2.w;
                }
                float r3_y_12 = (-r2_x_3 + 1);
                float r3_z_11 = dot(-unitViewDir_xyz_1.xyzx, i.texcoord0.xyzx);
                float r3_z_12 = (r3_z_11 + r3_z_11);
                float4 r4_xyzw_3 = mad(i.texcoord0.xyzx, -r3_z_12.xxxx, -unitViewDir_xyz_1.xyzx);
                float r4_x_3 = r4_xyzw_3.x;
                float r4_y_1 = r4_xyzw_3.y;
                float r4_z_1 = r4_xyzw_3.z;
                float4 r3_xyzw_10 = ((dot(float4(r3_x_8, r3_y_11, r3_z_10, r3_w_8), unity_OcclusionMaskSelector)).xxxx * _LightColor0.xxyz);
                float r3_x_10 = r3_xyzw_10.x;
                float r3_z_13 = r3_xyzw_10.z;
                float r3_w_9 = r3_xyzw_10.w;
                float r4_w_1 = (0 < unity_ProbeVolumeWorldToObject[1].w);
                float3 r5_xyz_4;
                if (r4_w_1)
                {
                    float r4_w_2 = dot(float4(r4_x_3, r4_y_1, r4_z_1, r4_x_3), float4(r4_x_3, r4_y_1, r4_z_1, r4_x_3));
                    float r4_w_3 = rsqrt(r4_w_2);
                    float3 r5_xyz_2 = ((r4_w_3.xxxx * float4(r4_x_3, r4_y_1, r4_z_1, r4_x_3))).xyz;
                    float3 r8_xyz_1 = ((float4(0, 0, 0, 0) < r5_xyz_2.xyzx)).xyz;
                    float3 r6_xyz_3 = ((r8_xyz_1.xyzx ? ((((-i.texcoord1.xyzx + unity_ProbeVolumeParams.xyzx)).xyzx / r5_xyz_2.xyzx)).xyzx : ((((-i.texcoord1.xyzx + unity_ProbeVolumeWorldToObject[0].xyzx)).xyzx / r5_xyz_2.xyzx)).xyzx)).xyz;
                    float r4_w_4 = min(r6_xyz_3.y, r6_xyz_3.x);
                    float r4_w_5 = min(r6_xyz_3.z, r4_w_4);
                    r5_xyz_4 = (mad(r5_xyz_2.xyzx, r4_w_5.xxxx, ((i.texcoord1.xyzx + -unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyz;
                }
                else
                {
                    r5_xyz_4 = (float4(r4_x_3, r4_y_1, r4_z_1, r4_x_3)).xyz;
                }
                float r4_w_7 = mad(-r3_y_12, 0.7, 1.7);
                float r4_w_8 = (r3_y_12 * r4_w_7);
                float r4_w_9 = (r4_w_8 * 6);
                float4 r5_xyzw_5 = t0.SampleLevel(s0, r5_xyz_4.xyzx, r4_w_9);
                float r5_w_2 = (r5_xyzw_5.w + -1);
                float r5_w_3 = mad(unity_ProbeVolumeWorldToObject[2].w, r5_w_2, 1);
                float r5_w_4 = (r5_w_3 * unity_ProbeVolumeWorldToObject[2].x);
                float r6_w_1 = (unity_ProbeVolumeWorldToObject[0].w < 0.99999);
                float3 r6_xyz_8 = ((r5_xyzw_5.xyzx * r5_w_4.xxxx)).xyz;
                if (r6_w_1)
                {
                    float r6_w_2 = (0 < cb4_values[6].w);
                    float r4_x_5 = r4_x_3;
                    float r4_y_3 = r4_y_1;
                    float r4_z_3 = r4_z_1;
                    if (r6_w_2)
                    {
                        float r6_w_3 = dot(float4(r4_x_3, r4_y_1, r4_z_1, r4_x_3), float4(r4_x_3, r4_y_1, r4_z_1, r4_x_3));
                        float r6_w_4 = rsqrt(r6_w_3);
                        float3 r7_xyz_4 = ((float4(r4_x_3, r4_y_1, r4_z_1, r4_x_3) * r6_w_4.xxxx)).xyz;
                        float3 r10_xyz_1 = ((float4(0, 0, 0, 0) < r7_xyz_4.xyzx)).xyz;
                        float3 r8_xyz_5 = ((r10_xyz_1.xyzx ? ((((-i.texcoord1.xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyzx / r7_xyz_4.xyzx)).xyzx : ((((-i.texcoord1.xyzx + unity_ProbeVolumeSizeInv.xyzx)).xyzx / r7_xyz_4.xyzx)).xyzx)).xyz;
                        float r6_w_5 = min(r8_xyz_5.y, r8_xyz_5.x);
                        float r6_w_6 = min(r8_xyz_5.z, r6_w_5);
                        float4 r4_xyzw_4 = mad(r7_xyz_4.xyzx, r6_w_6.xxxx, ((i.texcoord1.xyzx + -unity_ProbeVolumeMin.xyzx)).xyzx);
                        float r4_x_4 = r4_xyzw_4.x;
                        float r4_y_2 = r4_xyzw_4.y;
                        float r4_z_2 = r4_xyzw_4.z;
                        r4_x_5 = r4_x_4;
                        r4_y_3 = r4_y_2;
                        r4_z_3 = r4_z_2;
                    }
                    float4 r4_xyzw_6 = t1.SampleLevel(s0, float4(r4_x_5, r4_y_3, r4_z_3, r4_x_5), r4_w_9);
                    float r4_w_11 = (r4_xyzw_6.w + -1);
                    float r4_w_12 = mad(cb4_values[7].w, r4_w_11, 1);
                    float r4_w_13 = (r4_w_12 * cb4_values[7].x);
                    float4 r4_xyzw_7 = (r4_xyzw_6.xyzx * r4_w_13.xxxx);
                    float r4_x_7 = r4_xyzw_7.x;
                    float r4_y_5 = r4_xyzw_7.y;
                    float r4_z_5 = r4_xyzw_7.z;
                    r6_xyz_8 = (mad(unity_ProbeVolumeWorldToObject[0].wwww, (mad(r5_w_4.xxxx, r5_xyzw_5.xyzx, -float4(r4_x_7, r4_y_5, r4_z_5, r4_x_7))).xyzx, float4(r4_x_7, r4_y_5, r4_z_5, r4_x_7))).xyz;
                }
                float4 r4_xyzw_9 = (r1_w_3.xxxx * r6_xyz_8.xyzx);
                float r4_x_9 = r4_xyzw_9.x;
                float r4_y_7 = r4_xyzw_9.y;
                float r4_z_7 = r4_xyzw_9.z;
                float r1_w_4 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r1_w_5 = rsqrt(r1_w_4);
                float3 unitClipPos_xyz_8 = ((r1_w_5.xxxx * i.texcoord0.xyzx)).xyz;
                float4 r2_xyzw_4 = (float4(r2_y_3, r2_y_3, r2_z_1, r2_w_1) * float4(0, 0.7790837, 0.7790837, 0.7790837));
                float r2_y_4 = r2_xyzw_4.y;
                float r2_z_2 = r2_xyzw_4.z;
                float r2_w_2 = r2_xyzw_4.w;
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitClipPos_xyz_8.xyzx, unitViewDir_xyz_1.xyzx);
                float r1_x_2 = dot(unitClipPos_xyz_8.xyzx, _WorldSpaceLightPos0.xyzx);
                float r1_y_2 = dot(unitClipPos_xyz_8.xyzx, r0_xyz_3.xyzx);
                float r0_x_4 = dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r3_y_12.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(nDotV_w_6) + 1);
                float r1_w_6 = (r1_z_4 * r1_z_4);
                float r1_w_7 = (r1_w_6 * r1_w_6);
                float r1_z_5 = (r1_z_4 * r1_w_7);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r3_y_12 * r3_y_12);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_w_8 = (-r0_z_8 + 1);
                float r4_w_15 = mad(abs(nDotV_w_6), r1_w_8, r0_z_8);
                float r1_w_9 = mad(r1_x_2, r1_w_8, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * r1_w_9);
                float r0_w_8 = mad(r1_x_2, r4_w_15, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r1_w_10 = (r0_z_8 * r0_z_8);
                float r4_w_16 = mad(r1_y_2, r1_w_10, -r1_y_2);
                float r1_y_3 = mad(r4_w_16, r1_y_2, 1);
                float r1_w_11 = (r1_w_10 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r1_y_5 = (r1_w_11 / r1_y_4);
                float r0_w_11 = (r0_w_10 * r1_y_5);
                float4 r0_xyzw_9 = (float4(r0_z_8, r0_z_8, r0_z_8, r0_w_11) * float4(0, 0, 0.28, 3.1415927));
                float r0_z_9 = r0_xyzw_9.z;
                float r0_w_12 = r0_xyzw_9.w;
                float r0_w_13 = max(r0_w_12, 0.0001);
                float r0_w_14 = sqrt(r0_w_13);
                float r0_y_9 = ((r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_y_8, r0_w_14))).y;
                float r0_w_15 = ((r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_y_8, r0_w_14))).w;
                float r0_z_10 = mad(-r0_z_9, r3_y_12, 1);
                float4 r3_xyzw_11 = (float4(r3_x_10, r3_z_13, r3_w_9, r3_x_10) * r0_w_15.xxxx);
                float r3_x_11 = r3_xyzw_11.x;
                float r3_y_13 = r3_xyzw_11.y;
                float r3_z_14 = r3_xyzw_11.z;
                float r0_x_5 = (-r0_x_4 + 1);
                float r0_y_10 = (r0_x_5 * r0_x_5);
                float r0_y_11 = (r0_y_10 * r0_y_10);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r0_y_11), 0.7790837, 0.2209163)).xxxx * float4(r3_x_11, r3_y_13, r3_x_11, r3_z_14));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_w_16 = r0_xyzw_8.w;
                float r0_x_9 = (mad(float4(r2_y_4, r2_z_2, r2_y_4, r2_w_2), ((r0_y_9.xxxx * float4(r3_x_10, r3_z_13, r3_w_9, r3_x_10))).xyxz, float4(r0_x_8, r0_y_12, r0_x_8, r0_w_16))).x;
                float4 r0_xyzw_13 = mad(float4(r2_y_4, r2_z_2, r2_y_4, r2_w_2), ((r0_y_9.xxxx * float4(r3_x_10, r3_z_13, r3_w_9, r3_x_10))).xyxz, float4(r0_x_8, r0_y_12, r0_x_8, r0_w_16));
                float r0_y_13 = r0_xyzw_13.y;
                float r0_w_17 = r0_xyzw_13.w;
                float r2_x_4 = ((float4(r4_x_9, r4_y_7, r4_z_7, r4_x_9) * r0_z_10.xxxx)).x;
                float4 r2_xyzw_5 = (float4(r4_x_9, r4_y_7, r4_z_7, r4_x_9) * r0_z_10.xxxx);
                float r2_y_5 = r2_xyzw_5.y;
                float r2_z_3 = r2_xyzw_5.z;
                float r0_z_11 = (min((r2_x_3 + 0.22091627), 1) + -0.2209163);
                float r0_z_12 = mad(r1_z_5, r0_z_11, 0.2209163);
                float4 r0_xyzw_10 = mad(float4(r2_x_4, r2_y_5, r2_z_3, r2_x_4), r0_z_12.xxxx, float4(r0_x_9, r0_y_13, r0_w_17, r0_x_9));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_14 = r0_xyzw_10.y;
                float r0_z_13 = r0_xyzw_10.z;
                float4 r0_xyzw_11 = mad(_OceanEmission.xyzx, _EmissionScale.xxxx, float4(r0_x_10, r0_y_14, r0_z_13, r0_x_10));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_y_15 = r0_xyzw_11.y;
                float r0_z_14 = r0_xyzw_11.z;
                float r0_w_18 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_19 = (-r0_w_18 + 1);
                float r0_w_20 = (r0_w_19 * cb1_values[5].z);
                float r0_w_21 = max(r0_w_20, 0);
                float r0_w_22 = mad(r0_w_21, unity_SpecCube0_BoxMin.z, unity_SpecCube0_BoxMin.w);
                float4 r0_xyzw_12 = (float4(r0_x_11, r0_y_15, r0_z_14, r0_x_11) + -unity_SpecCube0_BoxMax.xyzx);
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_16 = r0_xyzw_12.y;
                float r0_z_15 = r0_xyzw_12.z;
                o.sv_Target0.xyz = (mad(r0_w_22.xxxx, float4(r0_x_12, r0_y_16, r0_z_15, r0_x_12), unity_SpecCube0_BoxMax.xyzx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Oceancolor;
                float4 _OceanGlossiness;
                float4 _OceanAO;
                float4 _OceanEmission;
                float _AOalbedo;
                float _AOsmoothness;
                float _SmoothnessShift;
                float _EmissionScale;
                float _AOintensity;
                float4 cb0_values[10];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[46];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer cb3 : register(b3)
            {
                float4 unity_SpecCube0_BoxMax;
                float4 unity_SpecCube0_BoxMin;
                float4 unity_SpecCube0_ProbePosition;
                float4 unity_SpecCube0_HDR;
                float4 unity_SpecCube1_BoxMax;
                float4 unity_SpecCube1_BoxMin;
                float4 unity_SpecCube1_ProbePosition;
                float4 unity_SpecCube1_HDR;
                float4 cb3_values[26];
            };
            cbuffer UnityProbeVolume : register(b4)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb4_values[12];
            };
            cbuffer cb5 : register(b5)
            {
                float4 cb5_values[8];
            };
            cbuffer cb6 : register(b6)
            {
                float4 cb6_values[7];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            TextureCube t1 : register(t1);
            TextureCube t2 : register(t2);
            Texture3D t3 : register(t3);
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
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program33Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program33Output
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
                o.texcoord1.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                float3 unitWorldNormal_xyz_3 = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord0.xyz = (unitWorldNormal_xyz_3.xyzx).xyz;
                float r1_w_4 = (unitWorldNormal_xyz_3.y * unitWorldNormal_xyz_3.y);
                float r1_w_5 = mad(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.x, -r1_w_4);
                float4 r2_xyzw_1 = (unitWorldNormal_xyz_3.yzzx * unitWorldNormal_xyz_3.xyzz);
                float r1_x_4 = dot(cb1_values[42].xyzw, r2_xyzw_1);
                float r1_y_4 = dot(cb1_values[43].xyzw, r2_xyzw_1);
                float r1_z_4 = dot(cb1_values[44].xyzw, r2_xyzw_1);
                o.texcoord2.xyz = (mad(cb1_values[45].xyzx, r1_w_5.xxxx, float4(r1_x_4, r1_y_4, r1_z_4, r1_x_4))).xyz;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r1_xyzw_5 = (float4(clipPos_xyzw_7.x, clipPos_xyzw_7.x, clipPos_xyzw_7.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_5 = r1_xyzw_5.x;
                float r1_z_5 = r1_xyzw_5.z;
                float r1_w_6 = r1_xyzw_5.w;
                o.texcoord4.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord4.xy = ((r1_z_5.xxxx + float4(r1_x_5, r1_w_6, r1_x_5, r1_x_5))).xy;
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program33Output frag(program33Input i)
            {
                program33Output o = (program33Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_1 = log2(_OceanAO.x);
                float r1_w_2 = (r1_w_1 * _AOintensity);
                float r1_w_3 = exp2(r1_w_2);
                float r2_x_1 = (-r1_w_3 + 1);
                float r2_y_1 = (r2_x_1 * _AOalbedo);
                float r2_y_2 = r2_y_1;
                float4 r2_xyzw_3 = mad(r2_y_2.xxxx, -_Oceancolor.xxyz, _Oceancolor.xxyz);
                float r2_y_3 = r2_xyzw_3.y;
                float r2_z_1 = r2_xyzw_3.z;
                float r2_w_1 = r2_xyzw_3.w;
                float r2_x_3 = (mad(r2_x_1, _AOsmoothness, _OceanGlossiness.x) + _SmoothnessShift);
                float r3_x_1 = cb4_values[9].z;
                float r3_y_1 = cb4_values[10].z;
                float r3_z_1 = cb4_values[11].z;
                float r3_x_2 = dot(viewDir_xyz_1.xyzx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float4 r3_xyzw_2 = (i.texcoord1.xxyz + -cb3_values[25].xxyz);
                float r3_y_2 = r3_xyzw_2.y;
                float r3_z_2 = r3_xyzw_2.z;
                float r3_w_1 = r3_xyzw_2.w;
                float r3_y_3 = dot(float4(r3_y_2, r3_z_2, r3_w_1, r3_y_2), float4(r3_y_2, r3_z_2, r3_w_1, r3_y_2));
                float r3_y_4 = sqrt(r3_y_3);
                float r3_y_5 = (-r3_x_2 + r3_y_4);
                float r3_y_6 = (cb6_values[0].x == 1);
                float r4_x_10;
                float r4_y_10;
                float r4_z_10;
                float r4_w_4;
                if (r3_y_6)
                {
                    float r3_z_3 = (cb6_values[0].y == 1);
                    float3 r4_xyz_5 = (((mad(cb6_values[3].xyzx, i.texcoord1.zzzz, (mad(cb6_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r4_xyzw_8 = (((((r3_z_3.xxxx ? r4_xyz_5.xyzx : i.texcoord1.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r4_y_8 = r4_xyzw_8.y;
                    float r4_z_8 = r4_xyzw_8.z;
                    float r4_w_2 = r4_xyzw_8.w;
                    float r3_z_4 = mad(r4_y_8, 0.25, 0.75);
                    float r3_w_2 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r4_x_8 = max(r3_w_2, r3_z_4);
                    float4 r4_xyzw_9 = t3.Sample(s1, float4(r4_x_8, r4_z_8, r4_w_2, r4_x_8));
                    r4_x_10 = r4_xyzw_9.x;
                    r4_y_10 = r4_xyzw_9.y;
                    r4_z_10 = r4_xyzw_9.z;
                    r4_w_4 = r4_xyzw_9.w;
                }
                else
                {
                    float4 r4_xyzw_10 = float4(1, 1, 1, 1);
                    r4_x_10 = r4_xyzw_10.x;
                    r4_y_10 = r4_xyzw_10.y;
                    r4_z_10 = r4_xyzw_10.z;
                    r4_w_4 = r4_xyzw_10.w;
                }
                float r3_z_6 = dot(float4(r4_x_10, r4_y_10, r4_z_10, r4_w_4), unity_OcclusionMaskSelector);
                float4 r4_xyzw_12 = t0.Sample(s2, ((i.texcoord4.xyxx / i.texcoord4.wwww)).xyxx);
                float r3_z_7 = (r3_z_6 + -r4_xyzw_12.x);
                float r3_z_8 = (-r2_x_3 + 1);
                float r3_w_4 = dot(-unitViewDir_xyz_1.xyzx, i.texcoord0.xyzx);
                float r3_w_5 = (r3_w_4 + r3_w_4);
                float4 r4_xyzw_13 = mad(i.texcoord0.xyzx, -r3_w_5.xxxx, -unitViewDir_xyz_1.xyzx);
                float r4_x_13 = r4_xyzw_13.x;
                float r4_y_13 = r4_xyzw_13.y;
                float r4_z_12 = r4_xyzw_13.z;
                float3 r5_xyz_1 = (((mad(mad(mad(cb3_values[25].w, r3_y_5, r3_x_2), cb3_values[24].z, cb3_values[24].w), r3_z_7, r4_xyzw_12.x)).xxxx * _LightColor0.xyzx)).xyz;
                float3 TEXCOORD0_xyz_1;
                float3 r7_xyz_4;
                if ((r3_y_6 != 0))
                {
                    float3 r6_xyz_5 = (((mad(cb6_values[3].xyzx, i.texcoord1.zzzz, (mad(cb6_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r3_xyzw_7 = (((cb6_values[0].y == 1)).xxxx ? r6_xyz_5.xyxz : i.texcoord1.xyxz);
                    float r3_x_7 = r3_xyzw_7.x;
                    float r3_y_7 = r3_xyzw_7.y;
                    float r3_w_6 = r3_xyzw_7.w;
                    float4 r3_xyzw_8 = (float4(r3_x_7, r3_y_7, r3_x_7, r3_w_6) + -cb6_values[6].xyxz);
                    float r3_x_8 = r3_xyzw_8.x;
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_w_7 = r3_xyzw_8.w;
                    float4 r6_xyzw_6 = (float4(r3_x_8, r3_x_8, r3_y_8, r3_w_7) * cb6_values[5].xxyz);
                    float r6_y_6 = r6_xyzw_6.y;
                    float r6_z_6 = r6_xyzw_6.z;
                    float r6_w_2 = r6_xyzw_6.w;
                    float r3_y_9 = (cb6_values[0].z * 0.5);
                    float r3_w_8 = mad(-cb6_values[0].z, 0.5, 0.25);
                    float r6_x_6 = min(r3_w_8, max(r3_y_9, (r6_y_6 * 0.25)));
                    float4 r7_xyzw_2 = t3.Sample(s1, float4(r6_x_6, r6_z_6, r6_w_2, r6_x_6));
                    float4 r3_xyzw_11 = (float4(r6_x_6, r6_z_6, r6_x_6, r6_w_2) + float4(0.25, 0, 0, 0));
                    float r3_x_11 = r3_xyzw_11.x;
                    float r3_y_10 = r3_xyzw_11.y;
                    float r3_w_9 = r3_xyzw_11.w;
                    float4 r8_xyzw_1 = t3.Sample(s1, float4(r3_x_11, r3_y_10, r3_w_9, r3_x_11));
                    float4 r3_xyzw_12 = (float4(r6_x_6, r6_z_6, r6_x_6, r6_w_2) + float4(0.5, 0, 0, 0));
                    float r3_x_12 = r3_xyzw_12.x;
                    float r3_y_11 = r3_xyzw_12.y;
                    float r3_w_10 = r3_xyzw_12.w;
                    float4 r6_xyzw_7 = t3.Sample(s1, float4(r3_x_12, r3_y_11, r3_w_10, r3_x_12));
                    TEXCOORD0_xyz_1 = (i.texcoord0.xyzx).xyz;
                    float r9_w_1 = 1;
                    float r7_x_3 = dot(r7_xyzw_2, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r9_w_1));
                    float r7_y_3 = dot(r8_xyzw_1, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r9_w_1));
                    float r7_z_3 = dot(r6_xyzw_7, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r9_w_1));
                    r7_xyz_4 = float3(r7_x_3, r7_y_3, r7_z_3);
                }
                else
                {
                    TEXCOORD0_xyz_1 = (i.texcoord0.xyzx).xyz;
                    float r6_w_1 = 1;
                    float r7_x_1 = dot(cb2_values[39].xyzw, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r6_w_1));
                    float r7_y_1 = dot(cb2_values[40].xyzw, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r6_w_1));
                    float r7_z_1 = dot(cb2_values[41].xyzw, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r6_w_1));
                    r7_xyz_4 = float3(r7_x_1, r7_y_1, r7_z_1);
                }
                float4 r3_xyzw_14 = (r7_xyz_4.xyxz + i.texcoord2.xyxz);
                float r3_x_14 = r3_xyzw_14.x;
                float r3_y_13 = r3_xyzw_14.y;
                float r3_w_12 = r3_xyzw_14.w;
                float4 r3_xyzw_15 = max(float4(r3_x_14, r3_y_13, r3_x_14, r3_w_12), float4(0, 0, 0, 0));
                float r3_x_15 = r3_xyzw_15.x;
                float r3_y_14 = r3_xyzw_15.y;
                float r3_w_13 = r3_xyzw_15.w;
                float4 r3_xyzw_16 = log2(float4(r3_x_15, r3_y_14, r3_x_15, r3_w_13));
                float r3_x_16 = r3_xyzw_16.x;
                float r3_y_15 = r3_xyzw_16.y;
                float r3_w_14 = r3_xyzw_16.w;
                float4 r3_xyzw_17 = (float4(r3_x_16, r3_y_15, r3_x_16, r3_w_14) * float4(0.41666666, 0.41666666, 0, 0.41666666));
                float r3_x_17 = r3_xyzw_17.x;
                float r3_y_16 = r3_xyzw_17.y;
                float r3_w_15 = r3_xyzw_17.w;
                float4 r3_xyzw_18 = exp2(float4(r3_x_17, r3_y_16, r3_x_17, r3_w_15));
                float r3_x_18 = r3_xyzw_18.x;
                float r3_y_17 = r3_xyzw_18.y;
                float r3_w_16 = r3_xyzw_18.w;
                float4 r3_xyzw_19 = mad(float4(r3_x_18, r3_y_17, r3_x_18, r3_w_16), float4(1.055, 1.055, 0, 1.055), float4(-0.055, -0.055, 0, -0.055));
                float r3_x_19 = r3_xyzw_19.x;
                float r3_y_18 = r3_xyzw_19.y;
                float r3_w_17 = r3_xyzw_19.w;
                float4 r3_xyzw_20 = max(float4(r3_x_19, r3_y_18, r3_x_19, r3_w_17), float4(0, 0, 0, 0));
                float r3_x_20 = r3_xyzw_20.x;
                float r3_y_19 = r3_xyzw_20.y;
                float r3_w_18 = r3_xyzw_20.w;
                float r4_w_6 = (0 < cb5_values[2].w);
                float3 r6_xyz_12;
                if (r4_w_6)
                {
                    float r4_w_7 = dot(float4(r4_x_13, r4_y_13, r4_z_12, r4_x_13), float4(r4_x_13, r4_y_13, r4_z_12, r4_x_13));
                    float r4_w_8 = rsqrt(r4_w_7);
                    float3 r6_xyz_10 = ((r4_w_8.xxxx * float4(r4_x_13, r4_y_13, r4_z_12, r4_x_13))).xyz;
                    float3 r9_xyz_3 = ((float4(0, 0, 0, 0) < r6_xyz_10.xyzx)).xyz;
                    float3 r7_xyz_7 = ((r9_xyz_3.xyzx ? ((((-i.texcoord1.xyzx + cb5_values[0].xyzx)).xyzx / r6_xyz_10.xyzx)).xyzx : ((((-i.texcoord1.xyzx + cb5_values[1].xyzx)).xyzx / r6_xyz_10.xyzx)).xyzx)).xyz;
                    float r4_w_9 = min(r7_xyz_7.y, r7_xyz_7.x);
                    float r4_w_10 = min(r7_xyz_7.z, r4_w_9);
                    r6_xyz_12 = (mad(r6_xyz_10.xyzx, r4_w_10.xxxx, ((i.texcoord1.xyzx + -cb5_values[2].xyzx)).xyzx)).xyz;
                }
                else
                {
                    r6_xyz_12 = (float4(r4_x_13, r4_y_13, r4_z_12, r4_x_13)).xyz;
                }
                float r4_w_12 = mad(-r3_z_8, 0.7, 1.7);
                float r4_w_13 = (r3_z_8 * r4_w_12);
                float r4_w_14 = (r4_w_13 * 6);
                float4 r6_xyzw_13 = t1.SampleLevel(s0, r6_xyz_12.xyzx, r4_w_14);
                float r5_w_1 = (r6_xyzw_13.w + -1);
                float r5_w_2 = mad(cb5_values[3].w, r5_w_1, 1);
                float r5_w_3 = (r5_w_2 * cb5_values[3].x);
                float r6_w_6 = (cb5_values[1].w < 0.99999);
                float3 r7_xyz_12 = ((r6_xyzw_13.xyzx * r5_w_3.xxxx)).xyz;
                if (r6_w_6)
                {
                    float r6_w_7 = (0 < cb5_values[6].w);
                    float r4_x_15 = r4_x_13;
                    float r4_y_15 = r4_y_13;
                    float r4_z_14 = r4_z_12;
                    if (r6_w_7)
                    {
                        float r6_w_8 = dot(float4(r4_x_13, r4_y_13, r4_z_12, r4_x_13), float4(r4_x_13, r4_y_13, r4_z_12, r4_x_13));
                        float r6_w_9 = rsqrt(r6_w_8);
                        float3 r8_xyz_6 = ((float4(r4_x_13, r4_y_13, r4_z_12, r4_x_13) * r6_w_9.xxxx)).xyz;
                        float3 r11_xyz_1 = ((float4(0, 0, 0, 0) < r8_xyz_6.xyzx)).xyz;
                        float3 r9_xyz_7 = ((r11_xyz_1.xyzx ? ((((-i.texcoord1.xyzx + cb5_values[4].xyzx)).xyzx / r8_xyz_6.xyzx)).xyzx : ((((-i.texcoord1.xyzx + cb5_values[5].xyzx)).xyzx / r8_xyz_6.xyzx)).xyzx)).xyz;
                        float r6_w_10 = min(r9_xyz_7.y, r9_xyz_7.x);
                        float r6_w_11 = min(r9_xyz_7.z, r6_w_10);
                        float4 r4_xyzw_14 = mad(r8_xyz_6.xyzx, r6_w_11.xxxx, ((i.texcoord1.xyzx + -cb5_values[6].xyzx)).xyzx);
                        float r4_x_14 = r4_xyzw_14.x;
                        float r4_y_14 = r4_xyzw_14.y;
                        float r4_z_13 = r4_xyzw_14.z;
                        r4_x_15 = r4_x_14;
                        r4_y_15 = r4_y_14;
                        r4_z_14 = r4_z_13;
                    }
                    float4 r4_xyzw_16 = t2.SampleLevel(s0, float4(r4_x_15, r4_y_15, r4_z_14, r4_x_15), r4_w_14);
                    float r4_w_16 = (r4_xyzw_16.w + -1);
                    float r4_w_17 = mad(cb5_values[7].w, r4_w_16, 1);
                    float r4_w_18 = (r4_w_17 * cb5_values[7].x);
                    float4 r4_xyzw_17 = (r4_xyzw_16.xyzx * r4_w_18.xxxx);
                    float r4_x_17 = r4_xyzw_17.x;
                    float r4_y_17 = r4_xyzw_17.y;
                    float r4_z_16 = r4_xyzw_17.z;
                    r7_xyz_12 = (mad(cb5_values[1].wwww, (mad(r5_w_3.xxxx, r6_xyzw_13.xyzx, -float4(r4_x_17, r4_y_17, r4_z_16, r4_x_17))).xyzx, float4(r4_x_17, r4_y_17, r4_z_16, r4_x_17))).xyz;
                }
                float4 r4_xyzw_19 = (r1_w_3.xxxx * r7_xyz_12.xyzx);
                float r4_x_19 = r4_xyzw_19.x;
                float r4_y_19 = r4_xyzw_19.y;
                float r4_z_18 = r4_xyzw_19.z;
                float r4_w_20 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r4_w_21 = rsqrt(r4_w_20);
                float3 unitWorldNormal_xyz_16 = ((r4_w_21.xxxx * i.texcoord0.xyzx)).xyz;
                float4 r2_xyzw_4 = (float4(r2_y_3, r2_y_3, r2_z_1, r2_w_1) * float4(0, 0.7790837, 0.7790837, 0.7790837));
                float r2_y_4 = r2_xyzw_4.y;
                float r2_z_2 = r2_xyzw_4.z;
                float r2_w_2 = r2_xyzw_4.w;
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitWorldNormal_xyz_16.xyzx, unitViewDir_xyz_1.xyzx);
                float r1_x_2 = dot(unitWorldNormal_xyz_16.xyzx, _WorldSpaceLightPos0.xyzx);
                float r1_y_2 = dot(unitWorldNormal_xyz_16.xyzx, r0_xyz_3.xyzx);
                float r0_x_4 = dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r3_z_8.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(nDotV_w_6) + 1);
                float r4_w_22 = (r1_z_4 * r1_z_4);
                float r4_w_23 = (r4_w_22 * r4_w_22);
                float r1_z_5 = (r1_z_4 * r4_w_23);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r3_z_8 * r3_z_8);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r4_w_24 = (-r0_z_8 + 1);
                float r5_w_4 = mad(abs(nDotV_w_6), r4_w_24, r0_z_8);
                float r4_w_25 = mad(r1_x_2, r4_w_24, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * r4_w_25);
                float r0_w_8 = mad(r1_x_2, r5_w_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r4_w_26 = (r0_z_8 * r0_z_8);
                float r5_w_5 = mad(r1_y_2, r4_w_26, -r1_y_2);
                float r1_y_3 = mad(r5_w_5, r1_y_2, 1);
                float r4_w_27 = (r4_w_26 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r1_y_5 = (r4_w_27 / r1_y_4);
                float r0_w_11 = (r0_w_10 * r1_y_5);
                float4 r0_xyzw_9 = (float4(r0_z_8, r0_z_8, r0_z_8, r0_w_11) * float4(0, 0, 0.28, 3.1415927));
                float r0_z_9 = r0_xyzw_9.z;
                float r0_w_12 = r0_xyzw_9.w;
                float r0_w_13 = max(r0_w_12, 0.0001);
                float r0_w_14 = sqrt(r0_w_13);
                float r0_y_9 = ((r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_y_8, r0_w_14))).y;
                float r0_w_15 = ((r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_y_8, r0_w_14))).w;
                float r0_z_10 = mad(-r0_z_9, r3_z_8, 1);
                float4 r3_xyzw_21 = mad(float4(r3_x_20, r3_y_19, r3_w_18, r3_x_20), r1_w_3.xxxx, ((r0_y_9.xxxx * r5_xyz_1.xyzx)).xyzx);
                float r3_x_21 = r3_xyzw_21.x;
                float r3_y_20 = r3_xyzw_21.y;
                float r3_z_9 = r3_xyzw_21.z;
                float r0_x_5 = (-r0_x_4 + 1);
                float r0_y_10 = (r0_x_5 * r0_x_5);
                float r0_y_11 = (r0_y_10 * r0_y_10);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r0_y_11), 0.7790837, 0.2209163)).xxxx * ((r5_xyz_1.xyzx * r0_w_15.xxxx)).xyxz);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_w_16 = r0_xyzw_8.w;
                float r0_x_9 = (mad(float4(r2_y_4, r2_z_2, r2_y_4, r2_w_2), float4(r3_x_21, r3_y_20, r3_x_21, r3_z_9), float4(r0_x_8, r0_y_12, r0_x_8, r0_w_16))).x;
                float4 r0_xyzw_13 = mad(float4(r2_y_4, r2_z_2, r2_y_4, r2_w_2), float4(r3_x_21, r3_y_20, r3_x_21, r3_z_9), float4(r0_x_8, r0_y_12, r0_x_8, r0_w_16));
                float r0_y_13 = r0_xyzw_13.y;
                float r0_w_17 = r0_xyzw_13.w;
                float r2_x_4 = ((float4(r4_x_19, r4_y_19, r4_z_18, r4_x_19) * r0_z_10.xxxx)).x;
                float4 r2_xyzw_5 = (float4(r4_x_19, r4_y_19, r4_z_18, r4_x_19) * r0_z_10.xxxx);
                float r2_y_5 = r2_xyzw_5.y;
                float r2_z_3 = r2_xyzw_5.z;
                float r0_z_11 = (min((r2_x_3 + 0.22091627), 1) + -0.2209163);
                float r0_z_12 = mad(r1_z_5, r0_z_11, 0.2209163);
                float4 r0_xyzw_10 = mad(float4(r2_x_4, r2_y_5, r2_z_3, r2_x_4), r0_z_12.xxxx, float4(r0_x_9, r0_y_13, r0_w_17, r0_x_9));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_14 = r0_xyzw_10.y;
                float r0_z_13 = r0_xyzw_10.z;
                o.sv_Target0.xyz = (mad(_OceanEmission.xyzx, _EmissionScale.xxxx, float4(r0_x_10, r0_y_14, r0_z_13, r0_x_10))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Oceancolor;
                float4 _OceanGlossiness;
                float4 _OceanAO;
                float4 _OceanEmission;
                float _AOalbedo;
                float _AOsmoothness;
                float _SmoothnessShift;
                float _EmissionScale;
                float _AOintensity;
                float4 cb0_values[10];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer UnityReflectionProbes : register(b3)
            {
                float4 unity_SpecCube0_BoxMax;
                float4 unity_SpecCube0_BoxMin;
                float4 unity_SpecCube0_ProbePosition;
                float4 unity_SpecCube0_HDR;
                float4 unity_SpecCube1_BoxMax;
                float4 unity_SpecCube1_BoxMin;
                float4 unity_SpecCube1_ProbePosition;
                float4 unity_SpecCube1_HDR;
                float4 cb3_values[26];
            };
            cbuffer UnityProbeVolume : register(b4)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb4_values[12];
            };
            cbuffer cb5 : register(b5)
            {
                float4 cb5_values[8];
            };
            cbuffer cb6 : register(b6)
            {
                float4 cb6_values[7];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            TextureCube t1 : register(t1);
            TextureCube t2 : register(t2);
            Texture3D t3 : register(t3);
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
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program32Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program32Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program8Output vert(program8Input i)
            {
                program8Output o = (program8Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r1_xyzw_3 = (float4(clipPos_xyzw_7.x, clipPos_xyzw_7.x, clipPos_xyzw_7.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_z_3 = r1_xyzw_3.z;
                float r1_w_4 = r1_xyzw_3.w;
                o.texcoord4.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord4.xy = ((r1_z_3.xxxx + float4(r1_x_3, r1_w_4, r1_x_3, r1_x_3))).xy;
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program32Output frag(program32Input i)
            {
                program32Output o = (program32Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_1 = log2(_OceanAO.x);
                float r1_w_2 = (r1_w_1 * _AOintensity);
                float r1_w_3 = exp2(r1_w_2);
                float r2_x_1 = (-r1_w_3 + 1);
                float r2_y_1 = (r2_x_1 * _AOalbedo);
                float r2_y_2 = r2_y_1;
                float4 r2_xyzw_3 = mad(r2_y_2.xxxx, -_Oceancolor.xxyz, _Oceancolor.xxyz);
                float r2_y_3 = r2_xyzw_3.y;
                float r2_z_1 = r2_xyzw_3.z;
                float r2_w_1 = r2_xyzw_3.w;
                float r2_x_3 = (mad(r2_x_1, _AOsmoothness, _OceanGlossiness.x) + _SmoothnessShift);
                float r3_x_1 = cb4_values[9].z;
                float r3_y_1 = cb4_values[10].z;
                float r3_z_1 = cb4_values[11].z;
                float r3_x_2 = dot(viewDir_xyz_1.xyzx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float4 r3_xyzw_2 = (i.texcoord1.xxyz + -cb3_values[25].xxyz);
                float r3_y_2 = r3_xyzw_2.y;
                float r3_z_2 = r3_xyzw_2.z;
                float r3_w_1 = r3_xyzw_2.w;
                float r3_y_3 = dot(float4(r3_y_2, r3_z_2, r3_w_1, r3_y_2), float4(r3_y_2, r3_z_2, r3_w_1, r3_y_2));
                float r3_y_4 = sqrt(r3_y_3);
                float r3_y_5 = (-r3_x_2 + r3_y_4);
                float r3_y_6 = (cb6_values[0].x == 1);
                float r4_x_8;
                float r4_y_8;
                float r4_z_8;
                float r4_w_4;
                if (r3_y_6)
                {
                    float r3_y_7 = (cb6_values[0].y == 1);
                    float3 r4_xyz_5 = (((mad(cb6_values[3].xyzx, i.texcoord1.zzzz, (mad(cb6_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r3_xyzw_8 = (r3_y_7.xxxx ? r4_xyz_5.xxyz : i.texcoord1.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_3 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float4 r3_xyzw_9 = (float4(r3_y_8, r3_y_8, r3_z_3, r3_w_2) + -cb6_values[6].xxyz);
                    float r3_y_9 = r3_xyzw_9.y;
                    float r3_z_4 = r3_xyzw_9.z;
                    float r3_w_3 = r3_xyzw_9.w;
                    float4 r4_xyzw_6 = (float4(r3_y_9, r3_y_9, r3_z_4, r3_w_3) * cb6_values[5].xxyz);
                    float r4_y_6 = r4_xyzw_6.y;
                    float r4_z_6 = r4_xyzw_6.z;
                    float r4_w_2 = r4_xyzw_6.w;
                    float r3_y_10 = mad(r4_y_6, 0.25, 0.75);
                    float r3_z_5 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r4_x_6 = max(r3_z_5, r3_y_10);
                    float4 r4_xyzw_7 = t3.Sample(s1, float4(r4_x_6, r4_z_6, r4_w_2, r4_x_6));
                    r4_x_8 = r4_xyzw_7.x;
                    r4_y_8 = r4_xyzw_7.y;
                    r4_z_8 = r4_xyzw_7.z;
                    r4_w_4 = r4_xyzw_7.w;
                }
                else
                {
                    float4 r4_xyzw_8 = float4(1, 1, 1, 1);
                    r4_x_8 = r4_xyzw_8.x;
                    r4_y_8 = r4_xyzw_8.y;
                    r4_z_8 = r4_xyzw_8.z;
                    r4_w_4 = r4_xyzw_8.w;
                }
                float r3_y_12 = dot(float4(r4_x_8, r4_y_8, r4_z_8, r4_w_4), unity_OcclusionMaskSelector);
                float4 r3_xyzw_7 = (i.texcoord4.xxxy / i.texcoord4.wwww);
                float r3_z_7 = r3_xyzw_7.z;
                float r3_w_5 = r3_xyzw_7.w;
                float4 r4_xyzw_9 = t0.Sample(s2, float4(r3_z_7, r3_w_5, r3_z_7, r3_z_7));
                float r3_y_13 = (r3_y_12 + -r4_xyzw_9.x);
                float r3_y_14 = (-r2_x_3 + 1);
                float r3_z_8 = dot(-unitViewDir_xyz_1.xyzx, i.texcoord0.xyzx);
                float r3_z_9 = (r3_z_8 + r3_z_8);
                float3 r4_xyz_10 = (mad(i.texcoord0.xyzx, -r3_z_9.xxxx, -unitViewDir_xyz_1.xyzx)).xyz;
                float4 r3_xyzw_6 = ((mad(mad(mad(cb3_values[25].w, r3_y_5, r3_x_2), cb3_values[24].z, cb3_values[24].w), r3_y_13, r4_xyzw_9.x)).xxxx * _LightColor0.xxyz);
                float r3_x_6 = r3_xyzw_6.x;
                float r3_z_10 = r3_xyzw_6.z;
                float r3_w_6 = r3_xyzw_6.w;
                float r4_w_6 = (0 < cb5_values[2].w);
                float3 r5_xyz_4;
                if (r4_w_6)
                {
                    float r4_w_7 = dot(r4_xyz_10.xyzx, r4_xyz_10.xyzx);
                    float r4_w_8 = rsqrt(r4_w_7);
                    float3 r5_xyz_2 = ((r4_w_8.xxxx * r4_xyz_10.xyzx)).xyz;
                    float3 r8_xyz_1 = ((float4(0, 0, 0, 0) < r5_xyz_2.xyzx)).xyz;
                    float3 r6_xyz_3 = ((r8_xyz_1.xyzx ? ((((-i.texcoord1.xyzx + cb5_values[0].xyzx)).xyzx / r5_xyz_2.xyzx)).xyzx : ((((-i.texcoord1.xyzx + cb5_values[1].xyzx)).xyzx / r5_xyz_2.xyzx)).xyzx)).xyz;
                    float r4_w_9 = min(r6_xyz_3.y, r6_xyz_3.x);
                    float r4_w_10 = min(r6_xyz_3.z, r4_w_9);
                    r5_xyz_4 = (mad(r5_xyz_2.xyzx, r4_w_10.xxxx, ((i.texcoord1.xyzx + -cb5_values[2].xyzx)).xyzx)).xyz;
                }
                else
                {
                    r5_xyz_4 = (r4_xyz_10.xyzx).xyz;
                }
                float r4_w_12 = mad(-r3_y_14, 0.7, 1.7);
                float r4_w_13 = (r3_y_14 * r4_w_12);
                float r4_w_14 = (r4_w_13 * 6);
                float4 r5_xyzw_5 = t1.SampleLevel(s0, r5_xyz_4.xyzx, r4_w_14);
                float r5_w_2 = (r5_xyzw_5.w + -1);
                float r5_w_3 = mad(cb5_values[3].w, r5_w_2, 1);
                float r5_w_4 = (r5_w_3 * cb5_values[3].x);
                float r6_w_1 = (cb5_values[1].w < 0.99999);
                float3 r6_xyz_8 = ((r5_xyzw_5.xyzx * r5_w_4.xxxx)).xyz;
                if (r6_w_1)
                {
                    float r6_w_2 = (0 < cb5_values[6].w);
                    float3 r4_xyz_12 = r4_xyz_10;
                    if (r6_w_2)
                    {
                        float r6_w_3 = dot(r4_xyz_10.xyzx, r4_xyz_10.xyzx);
                        float r6_w_4 = rsqrt(r6_w_3);
                        float3 r7_xyz_4 = ((r4_xyz_10.xyzx * r6_w_4.xxxx)).xyz;
                        float3 r10_xyz_1 = ((float4(0, 0, 0, 0) < r7_xyz_4.xyzx)).xyz;
                        float3 r8_xyz_5 = ((r10_xyz_1.xyzx ? ((((-i.texcoord1.xyzx + cb5_values[4].xyzx)).xyzx / r7_xyz_4.xyzx)).xyzx : ((((-i.texcoord1.xyzx + cb5_values[5].xyzx)).xyzx / r7_xyz_4.xyzx)).xyzx)).xyz;
                        float r6_w_5 = min(r8_xyz_5.y, r8_xyz_5.x);
                        float r6_w_6 = min(r8_xyz_5.z, r6_w_5);
                        r4_xyz_12 = (mad(r7_xyz_4.xyzx, r6_w_6.xxxx, ((i.texcoord1.xyzx + -cb5_values[6].xyzx)).xyzx)).xyz;
                    }
                    float4 r4_xyzw_13 = t2.SampleLevel(s0, r4_xyz_12.xyzx, r4_w_14);
                    float r4_w_16 = (r4_xyzw_13.w + -1);
                    float r4_w_17 = mad(cb5_values[7].w, r4_w_16, 1);
                    float r4_w_18 = (r4_w_17 * cb5_values[7].x);
                    float3 r4_xyz_14 = ((r4_xyzw_13.xyzx * r4_w_18.xxxx)).xyz;
                    r6_xyz_8 = (mad(cb5_values[1].wwww, (mad(r5_w_4.xxxx, r5_xyzw_5.xyzx, -r4_xyz_14.xyzx)).xyzx, r4_xyz_14.xyzx)).xyz;
                }
                float r1_w_4 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r1_w_5 = rsqrt(r1_w_4);
                float3 unitWorldNormal_xyz_8 = ((r1_w_5.xxxx * i.texcoord0.xyzx)).xyz;
                float4 r2_xyzw_4 = (float4(r2_y_3, r2_y_3, r2_z_1, r2_w_1) * float4(0, 0.7790837, 0.7790837, 0.7790837));
                float r2_y_4 = r2_xyzw_4.y;
                float r2_z_2 = r2_xyzw_4.z;
                float r2_w_2 = r2_xyzw_4.w;
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitWorldNormal_xyz_8.xyzx, unitViewDir_xyz_1.xyzx);
                float r1_x_2 = dot(unitWorldNormal_xyz_8.xyzx, _WorldSpaceLightPos0.xyzx);
                float r1_y_2 = dot(unitWorldNormal_xyz_8.xyzx, r0_xyz_3.xyzx);
                float r0_x_4 = dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r3_y_14.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(nDotV_w_6) + 1);
                float r1_w_6 = (r1_z_4 * r1_z_4);
                float r1_w_7 = (r1_w_6 * r1_w_6);
                float r1_z_5 = (r1_z_4 * r1_w_7);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r3_y_14 * r3_y_14);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_w_8 = (-r0_z_8 + 1);
                float r4_w_20 = mad(abs(nDotV_w_6), r1_w_8, r0_z_8);
                float r1_w_9 = mad(r1_x_2, r1_w_8, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * r1_w_9);
                float r0_w_8 = mad(r1_x_2, r4_w_20, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r1_w_10 = (r0_z_8 * r0_z_8);
                float r4_w_21 = mad(r1_y_2, r1_w_10, -r1_y_2);
                float r1_y_3 = mad(r4_w_21, r1_y_2, 1);
                float r1_w_11 = (r1_w_10 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r1_y_5 = (r1_w_11 / r1_y_4);
                float r0_w_11 = (r0_w_10 * r1_y_5);
                float4 r0_xyzw_9 = (float4(r0_z_8, r0_z_8, r0_z_8, r0_w_11) * float4(0, 0, 0.28, 3.1415927));
                float r0_z_9 = r0_xyzw_9.z;
                float r0_w_12 = r0_xyzw_9.w;
                float r0_w_13 = max(r0_w_12, 0.0001);
                float r0_w_14 = sqrt(r0_w_13);
                float r0_y_9 = ((r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_y_8, r0_w_14))).y;
                float r0_w_15 = ((r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_y_8, r0_w_14))).w;
                float r0_z_10 = mad(-r0_z_9, r3_y_14, 1);
                float r3_x_7 = ((float4(r3_x_6, r3_z_10, r3_w_6, r3_x_6) * r0_w_15.xxxx)).x;
                float4 r3_xyzw_15 = (float4(r3_x_6, r3_z_10, r3_w_6, r3_x_6) * r0_w_15.xxxx);
                float r3_y_15 = r3_xyzw_15.y;
                float r3_z_11 = r3_xyzw_15.z;
                float r0_x_5 = (-r0_x_4 + 1);
                float r0_y_10 = (r0_x_5 * r0_x_5);
                float r0_y_11 = (r0_y_10 * r0_y_10);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r0_y_11), 0.7790837, 0.2209163)).xxxx * float4(r3_x_7, r3_y_15, r3_x_7, r3_z_11));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_w_16 = r0_xyzw_8.w;
                float r0_x_9 = (mad(float4(r2_y_4, r2_z_2, r2_y_4, r2_w_2), ((r0_y_9.xxxx * float4(r3_x_6, r3_z_10, r3_w_6, r3_x_6))).xyxz, float4(r0_x_8, r0_y_12, r0_x_8, r0_w_16))).x;
                float4 r0_xyzw_13 = mad(float4(r2_y_4, r2_z_2, r2_y_4, r2_w_2), ((r0_y_9.xxxx * float4(r3_x_6, r3_z_10, r3_w_6, r3_x_6))).xyxz, float4(r0_x_8, r0_y_12, r0_x_8, r0_w_16));
                float r0_y_13 = r0_xyzw_13.y;
                float r0_w_17 = r0_xyzw_13.w;
                float r2_x_4 = ((((r1_w_3.xxxx * r6_xyz_8.xyzx)).xyzx * r0_z_10.xxxx)).x;
                float4 r2_xyzw_5 = (((r1_w_3.xxxx * r6_xyz_8.xyzx)).xyzx * r0_z_10.xxxx);
                float r2_y_5 = r2_xyzw_5.y;
                float r2_z_3 = r2_xyzw_5.z;
                float r0_z_11 = (min((r2_x_3 + 0.22091627), 1) + -0.2209163);
                float r0_z_12 = mad(r1_z_5, r0_z_11, 0.2209163);
                float4 r0_xyzw_10 = mad(float4(r2_x_4, r2_y_5, r2_z_3, r2_x_4), r0_z_12.xxxx, float4(r0_x_9, r0_y_13, r0_w_17, r0_x_9));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_14 = r0_xyzw_10.y;
                float r0_z_13 = r0_xyzw_10.z;
                o.sv_Target0.xyz = (mad(_OceanEmission.xyzx, _EmissionScale.xxxx, float4(r0_x_10, r0_y_14, r0_z_13, r0_x_10))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Oceancolor;
                float4 _OceanGlossiness;
                float4 _OceanAO;
                float4 _OceanEmission;
                float _AOalbedo;
                float _AOsmoothness;
                float _SmoothnessShift;
                float _EmissionScale;
                float _AOintensity;
                float4 cb0_values[46];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer UnityReflectionProbes : register(b3)
            {
                float4 unity_SpecCube0_BoxMax;
                float4 unity_SpecCube0_BoxMin;
                float4 unity_SpecCube0_ProbePosition;
                float4 unity_SpecCube0_HDR;
                float4 unity_SpecCube1_BoxMax;
                float4 unity_SpecCube1_BoxMin;
                float4 unity_SpecCube1_ProbePosition;
                float4 unity_SpecCube1_HDR;
                float4 cb3_values[8];
            };
            cbuffer UnityProbeVolume : register(b4)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb4_values[7];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            TextureCube t0 : register(t0);
            TextureCube t1 : register(t1);
            Texture3D t2 : register(t2);
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
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program31Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program31Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program7Output vert(program7Input i)
            {
                program7Output o = (program7Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                float3 unitWorldNormal_xyz_8 = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.texcoord0.xyz = (unitWorldNormal_xyz_8.xyzx).xyz;
                float r0_w_9 = (unitWorldNormal_xyz_8.y * unitWorldNormal_xyz_8.y);
                float r0_w_10 = mad(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.x, -r0_w_9);
                float4 r1_xyzw_2 = (unitWorldNormal_xyz_8.yzzx * unitWorldNormal_xyz_8.xyzz);
                float r0_x_9 = dot(cb0_values[42].xyzw, r1_xyzw_2);
                float r0_y_9 = dot(cb0_values[43].xyzw, r1_xyzw_2);
                float r0_z_9 = dot(cb0_values[44].xyzw, r1_xyzw_2);
                o.texcoord2.xyz = (mad(cb0_values[45].xyzx, r0_w_10.xxxx, float4(r0_x_9, r0_y_9, r0_z_9, r0_x_9))).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program31Output frag(program31Input i)
            {
                program31Output o = (program31Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_1 = log2(_OceanAO.x);
                float r1_w_2 = (r1_w_1 * _AOintensity);
                float r1_w_3 = exp2(r1_w_2);
                float r2_x_1 = (-r1_w_3 + 1);
                float r2_y_1 = (r2_x_1 * _AOalbedo);
                float r2_y_2 = r2_y_1;
                float4 r2_xyzw_3 = mad(r2_y_2.xxxx, -_Oceancolor.xxyz, _Oceancolor.xxyz);
                float r2_y_3 = r2_xyzw_3.y;
                float r2_z_1 = r2_xyzw_3.z;
                float r2_w_1 = r2_xyzw_3.w;
                float r2_x_3 = (mad(r2_x_1, _AOsmoothness, _OceanGlossiness.x) + _SmoothnessShift);
                float r3_x_1 = (unity_ProbeVolumeParams.x == 1);
                float r4_x_8;
                float r4_y_8;
                float r4_z_8;
                float r4_w_4;
                if (r3_x_1)
                {
                    float r3_y_1 = (unity_ProbeVolumeParams.y == 1);
                    float3 r4_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float4 unity_ProbeVolumeParamsSelect_xyzw_2 = (r3_y_1.xxxx ? r4_xyz_5.xxyz : i.texcoord1.xxyz);
                    float unity_ProbeVolumeParamsSelect_y_2 = unity_ProbeVolumeParamsSelect_xyzw_2.y;
                    float unity_ProbeVolumeParamsSelect_z_1 = unity_ProbeVolumeParamsSelect_xyzw_2.z;
                    float unity_ProbeVolumeParamsSelect_w_1 = unity_ProbeVolumeParamsSelect_xyzw_2.w;
                    float4 r3_xyzw_3 = (float4(unity_ProbeVolumeParamsSelect_y_2, unity_ProbeVolumeParamsSelect_y_2, unity_ProbeVolumeParamsSelect_z_1, unity_ProbeVolumeParamsSelect_w_1) + -unity_ProbeVolumeMin.xxyz);
                    float r3_y_3 = r3_xyzw_3.y;
                    float r3_z_2 = r3_xyzw_3.z;
                    float r3_w_2 = r3_xyzw_3.w;
                    float4 r4_xyzw_6 = (float4(r3_y_3, r3_y_3, r3_z_2, r3_w_2) * unity_ProbeVolumeSizeInv.xxyz);
                    float r4_y_6 = r4_xyzw_6.y;
                    float r4_z_6 = r4_xyzw_6.z;
                    float r4_w_2 = r4_xyzw_6.w;
                    float r3_y_4 = mad(r4_y_6, 0.25, 0.75);
                    float r3_z_3 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r4_x_6 = max(r3_z_3, r3_y_4);
                    float4 r4_xyzw_7 = t2.Sample(s1, float4(r4_x_6, r4_z_6, r4_w_2, r4_x_6));
                    r4_x_8 = r4_xyzw_7.x;
                    r4_y_8 = r4_xyzw_7.y;
                    r4_z_8 = r4_xyzw_7.z;
                    r4_w_4 = r4_xyzw_7.w;
                }
                else
                {
                    float4 r4_xyzw_8 = float4(1, 1, 1, 1);
                    r4_x_8 = r4_xyzw_8.x;
                    r4_y_8 = r4_xyzw_8.y;
                    r4_z_8 = r4_xyzw_8.z;
                    r4_w_4 = r4_xyzw_8.w;
                }
                float r3_y_6 = dot(float4(r4_x_8, r4_y_8, r4_z_8, r4_w_4), unity_OcclusionMaskSelector);
                float r3_z_5 = (-r2_x_3 + 1);
                float r3_w_4 = dot(-unitViewDir_xyz_1.xyzx, i.texcoord0.xyzx);
                float r3_w_5 = (r3_w_4 + r3_w_4);
                float3 r4_xyz_9 = (mad(i.texcoord0.xyzx, -r3_w_5.xxxx, -unitViewDir_xyz_1.xyzx)).xyz;
                float3 r5_xyz_1 = ((r3_y_6.xxxx * _LightColor0.xyzx)).xyz;
                float3 TEXCOORD0_xyz_1;
                float3 r7_xyz_4;
                if ((r3_x_1 != 0))
                {
                    float3 r6_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float4 unity_ProbeVolumeParamsSelect_xyzw_3 = (((unity_ProbeVolumeParams.y == 1)).xxxx ? r6_xyz_5.xyxz : i.texcoord1.xyxz);
                    float unity_ProbeVolumeParamsSelect_x_3 = unity_ProbeVolumeParamsSelect_xyzw_3.x;
                    float unity_ProbeVolumeParamsSelect_y_7 = unity_ProbeVolumeParamsSelect_xyzw_3.y;
                    float unity_ProbeVolumeParamsSelect_w_6 = unity_ProbeVolumeParamsSelect_xyzw_3.w;
                    float4 r3_xyzw_4 = (float4(unity_ProbeVolumeParamsSelect_x_3, unity_ProbeVolumeParamsSelect_y_7, unity_ProbeVolumeParamsSelect_x_3, unity_ProbeVolumeParamsSelect_w_6) + -unity_ProbeVolumeMin.xyxz);
                    float r3_x_4 = r3_xyzw_4.x;
                    float r3_y_8 = r3_xyzw_4.y;
                    float r3_w_7 = r3_xyzw_4.w;
                    float4 r6_xyzw_6 = (float4(r3_x_4, r3_x_4, r3_y_8, r3_w_7) * unity_ProbeVolumeSizeInv.xxyz);
                    float r6_y_6 = r6_xyzw_6.y;
                    float r6_z_6 = r6_xyzw_6.z;
                    float r6_w_2 = r6_xyzw_6.w;
                    float r3_y_9 = (unity_ProbeVolumeParams.z * 0.5);
                    float r3_w_8 = mad(-unity_ProbeVolumeParams.z, 0.5, 0.25);
                    float r6_x_6 = min(r3_w_8, max(r3_y_9, (r6_y_6 * 0.25)));
                    float4 r7_xyzw_2 = t2.Sample(s1, float4(r6_x_6, r6_z_6, r6_w_2, r6_x_6));
                    float4 r3_xyzw_7 = (float4(r6_x_6, r6_z_6, r6_x_6, r6_w_2) + float4(0.25, 0, 0, 0));
                    float r3_x_7 = r3_xyzw_7.x;
                    float r3_y_10 = r3_xyzw_7.y;
                    float r3_w_9 = r3_xyzw_7.w;
                    float4 r8_xyzw_1 = t2.Sample(s1, float4(r3_x_7, r3_y_10, r3_w_9, r3_x_7));
                    float4 r3_xyzw_8 = (float4(r6_x_6, r6_z_6, r6_x_6, r6_w_2) + float4(0.5, 0, 0, 0));
                    float r3_x_8 = r3_xyzw_8.x;
                    float r3_y_11 = r3_xyzw_8.y;
                    float r3_w_10 = r3_xyzw_8.w;
                    float4 r6_xyzw_7 = t2.Sample(s1, float4(r3_x_8, r3_y_11, r3_w_10, r3_x_8));
                    TEXCOORD0_xyz_1 = (i.texcoord0.xyzx).xyz;
                    float r9_w_1 = 1;
                    float r7_x_3 = dot(r7_xyzw_2, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r9_w_1));
                    float r7_y_3 = dot(r8_xyzw_1, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r9_w_1));
                    float r7_z_3 = dot(r6_xyzw_7, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r9_w_1));
                    r7_xyz_4 = float3(r7_x_3, r7_y_3, r7_z_3);
                }
                else
                {
                    TEXCOORD0_xyz_1 = (i.texcoord0.xyzx).xyz;
                    float r6_w_1 = 1;
                    float r7_x_1 = dot(cb2_values[39].xyzw, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r6_w_1));
                    float r7_y_1 = dot(cb2_values[40].xyzw, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r6_w_1));
                    float r7_z_1 = dot(cb2_values[41].xyzw, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r6_w_1));
                    r7_xyz_4 = float3(r7_x_1, r7_y_1, r7_z_1);
                }
                float4 r3_xyzw_10 = (r7_xyz_4.xyxz + i.texcoord2.xyxz);
                float r3_x_10 = r3_xyzw_10.x;
                float r3_y_13 = r3_xyzw_10.y;
                float r3_w_12 = r3_xyzw_10.w;
                float4 r3_xyzw_11 = max(float4(r3_x_10, r3_y_13, r3_x_10, r3_w_12), float4(0, 0, 0, 0));
                float r3_x_11 = r3_xyzw_11.x;
                float r3_y_14 = r3_xyzw_11.y;
                float r3_w_13 = r3_xyzw_11.w;
                float4 r3_xyzw_12 = log2(float4(r3_x_11, r3_y_14, r3_x_11, r3_w_13));
                float r3_x_12 = r3_xyzw_12.x;
                float r3_y_15 = r3_xyzw_12.y;
                float r3_w_14 = r3_xyzw_12.w;
                float4 r3_xyzw_13 = (float4(r3_x_12, r3_y_15, r3_x_12, r3_w_14) * float4(0.41666666, 0.41666666, 0, 0.41666666));
                float r3_x_13 = r3_xyzw_13.x;
                float r3_y_16 = r3_xyzw_13.y;
                float r3_w_15 = r3_xyzw_13.w;
                float4 r3_xyzw_14 = exp2(float4(r3_x_13, r3_y_16, r3_x_13, r3_w_15));
                float r3_x_14 = r3_xyzw_14.x;
                float r3_y_17 = r3_xyzw_14.y;
                float r3_w_16 = r3_xyzw_14.w;
                float4 r3_xyzw_15 = mad(float4(r3_x_14, r3_y_17, r3_x_14, r3_w_16), float4(1.055, 1.055, 0, 1.055), float4(-0.055, -0.055, 0, -0.055));
                float r3_x_15 = r3_xyzw_15.x;
                float r3_y_18 = r3_xyzw_15.y;
                float r3_w_17 = r3_xyzw_15.w;
                float4 r3_xyzw_16 = max(float4(r3_x_15, r3_y_18, r3_x_15, r3_w_17), float4(0, 0, 0, 0));
                float r3_x_16 = r3_xyzw_16.x;
                float r3_y_19 = r3_xyzw_16.y;
                float r3_w_18 = r3_xyzw_16.w;
                float r4_w_5 = (0 < unity_SpecCube0_ProbePosition.w);
                float3 r6_xyz_12;
                if (r4_w_5)
                {
                    float r4_w_6 = dot(r4_xyz_9.xyzx, r4_xyz_9.xyzx);
                    float r4_w_7 = rsqrt(r4_w_6);
                    float3 r6_xyz_10 = ((r4_w_7.xxxx * r4_xyz_9.xyzx)).xyz;
                    float3 r9_xyz_3 = ((float4(0, 0, 0, 0) < r6_xyz_10.xyzx)).xyz;
                    float3 r7_xyz_7 = ((r9_xyz_3.xyzx ? ((((-i.texcoord1.xyzx + unity_SpecCube0_BoxMax.xyzx)).xyzx / r6_xyz_10.xyzx)).xyzx : ((((-i.texcoord1.xyzx + unity_SpecCube0_BoxMin.xyzx)).xyzx / r6_xyz_10.xyzx)).xyzx)).xyz;
                    float r4_w_8 = min(r7_xyz_7.y, r7_xyz_7.x);
                    float r4_w_9 = min(r7_xyz_7.z, r4_w_8);
                    r6_xyz_12 = (mad(r6_xyz_10.xyzx, r4_w_9.xxxx, ((i.texcoord1.xyzx + -unity_SpecCube0_ProbePosition.xyzx)).xyzx)).xyz;
                }
                else
                {
                    r6_xyz_12 = (r4_xyz_9.xyzx).xyz;
                }
                float r4_w_11 = mad(-r3_z_5, 0.7, 1.7);
                float r4_w_12 = (r3_z_5 * r4_w_11);
                float r4_w_13 = (r4_w_12 * 6);
                float4 r6_xyzw_13 = t0.SampleLevel(s0, r6_xyz_12.xyzx, r4_w_13);
                float r5_w_1 = (r6_xyzw_13.w + -1);
                float r5_w_2 = mad(unity_SpecCube0_HDR.w, r5_w_1, 1);
                float r5_w_3 = (r5_w_2 * unity_SpecCube0_HDR.x);
                float r6_w_6 = (unity_SpecCube0_BoxMin.w < 0.99999);
                float3 r7_xyz_12 = ((r6_xyzw_13.xyzx * r5_w_3.xxxx)).xyz;
                if (r6_w_6)
                {
                    float r6_w_7 = (0 < unity_SpecCube1_ProbePosition.w);
                    float3 r4_xyz_11 = r4_xyz_9;
                    if (r6_w_7)
                    {
                        float r6_w_8 = dot(r4_xyz_9.xyzx, r4_xyz_9.xyzx);
                        float r6_w_9 = rsqrt(r6_w_8);
                        float3 r8_xyz_6 = ((r4_xyz_9.xyzx * r6_w_9.xxxx)).xyz;
                        float3 r11_xyz_1 = ((float4(0, 0, 0, 0) < r8_xyz_6.xyzx)).xyz;
                        float3 r9_xyz_7 = ((r11_xyz_1.xyzx ? ((((-i.texcoord1.xyzx + unity_SpecCube1_BoxMax.xyzx)).xyzx / r8_xyz_6.xyzx)).xyzx : ((((-i.texcoord1.xyzx + unity_SpecCube1_BoxMin.xyzx)).xyzx / r8_xyz_6.xyzx)).xyzx)).xyz;
                        float r6_w_10 = min(r9_xyz_7.y, r9_xyz_7.x);
                        float r6_w_11 = min(r9_xyz_7.z, r6_w_10);
                        r4_xyz_11 = (mad(r8_xyz_6.xyzx, r6_w_11.xxxx, ((i.texcoord1.xyzx + -unity_SpecCube1_ProbePosition.xyzx)).xyzx)).xyz;
                    }
                    float4 r4_xyzw_12 = t1.SampleLevel(s0, r4_xyz_11.xyzx, r4_w_13);
                    float r4_w_15 = (r4_xyzw_12.w + -1);
                    float r4_w_16 = mad(unity_SpecCube1_HDR.w, r4_w_15, 1);
                    float r4_w_17 = (r4_w_16 * unity_SpecCube1_HDR.x);
                    float3 r4_xyz_13 = ((r4_xyzw_12.xyzx * r4_w_17.xxxx)).xyz;
                    r7_xyz_12 = (mad(unity_SpecCube0_BoxMin.wwww, (mad(r5_w_3.xxxx, r6_xyzw_13.xyzx, -r4_xyz_13.xyzx)).xyzx, r4_xyz_13.xyzx)).xyz;
                }
                float r4_w_19 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r4_w_20 = rsqrt(r4_w_19);
                float3 unitWorldNormal_xyz_16 = ((r4_w_20.xxxx * i.texcoord0.xyzx)).xyz;
                float4 r2_xyzw_4 = (float4(r2_y_3, r2_y_3, r2_z_1, r2_w_1) * float4(0, 0.7790837, 0.7790837, 0.7790837));
                float r2_y_4 = r2_xyzw_4.y;
                float r2_z_2 = r2_xyzw_4.z;
                float r2_w_2 = r2_xyzw_4.w;
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitWorldNormal_xyz_16.xyzx, unitViewDir_xyz_1.xyzx);
                float r1_x_2 = dot(unitWorldNormal_xyz_16.xyzx, _WorldSpaceLightPos0.xyzx);
                float r1_y_2 = dot(unitWorldNormal_xyz_16.xyzx, r0_xyz_3.xyzx);
                float r0_x_4 = dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r3_z_5.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(nDotV_w_6) + 1);
                float r4_w_21 = (r1_z_4 * r1_z_4);
                float r4_w_22 = (r4_w_21 * r4_w_21);
                float r1_z_5 = (r1_z_4 * r4_w_22);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r3_z_5 * r3_z_5);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r4_w_23 = (-r0_z_8 + 1);
                float r5_w_4 = mad(abs(nDotV_w_6), r4_w_23, r0_z_8);
                float r4_w_24 = mad(r1_x_2, r4_w_23, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * r4_w_24);
                float r0_w_8 = mad(r1_x_2, r5_w_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r4_w_25 = (r0_z_8 * r0_z_8);
                float r5_w_5 = mad(r1_y_2, r4_w_25, -r1_y_2);
                float r1_y_3 = mad(r5_w_5, r1_y_2, 1);
                float r4_w_26 = (r4_w_25 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r1_y_5 = (r4_w_26 / r1_y_4);
                float r0_w_11 = (r0_w_10 * r1_y_5);
                float4 r0_xyzw_9 = (float4(r0_z_8, r0_z_8, r0_z_8, r0_w_11) * float4(0, 0, 0.28, 3.1415927));
                float r0_z_9 = r0_xyzw_9.z;
                float r0_w_12 = r0_xyzw_9.w;
                float r0_w_13 = max(r0_w_12, 0.0001);
                float r0_w_14 = sqrt(r0_w_13);
                float r0_y_9 = ((r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_y_8, r0_w_14))).y;
                float r0_w_15 = ((r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_y_8, r0_w_14))).w;
                float r0_z_10 = mad(-r0_z_9, r3_z_5, 1);
                float4 r3_xyzw_17 = mad(float4(r3_x_16, r3_y_19, r3_w_18, r3_x_16), r1_w_3.xxxx, ((r0_y_9.xxxx * r5_xyz_1.xyzx)).xyzx);
                float r3_x_17 = r3_xyzw_17.x;
                float r3_y_20 = r3_xyzw_17.y;
                float r3_z_6 = r3_xyzw_17.z;
                float r0_x_5 = (-r0_x_4 + 1);
                float r0_y_10 = (r0_x_5 * r0_x_5);
                float r0_y_11 = (r0_y_10 * r0_y_10);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r0_y_11), 0.7790837, 0.2209163)).xxxx * ((r5_xyz_1.xyzx * r0_w_15.xxxx)).xyxz);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_w_16 = r0_xyzw_8.w;
                float r0_x_9 = (mad(float4(r2_y_4, r2_z_2, r2_y_4, r2_w_2), float4(r3_x_17, r3_y_20, r3_x_17, r3_z_6), float4(r0_x_8, r0_y_12, r0_x_8, r0_w_16))).x;
                float4 r0_xyzw_13 = mad(float4(r2_y_4, r2_z_2, r2_y_4, r2_w_2), float4(r3_x_17, r3_y_20, r3_x_17, r3_z_6), float4(r0_x_8, r0_y_12, r0_x_8, r0_w_16));
                float r0_y_13 = r0_xyzw_13.y;
                float r0_w_17 = r0_xyzw_13.w;
                float r2_x_4 = ((((r1_w_3.xxxx * r7_xyz_12.xyzx)).xyzx * r0_z_10.xxxx)).x;
                float4 r2_xyzw_5 = (((r1_w_3.xxxx * r7_xyz_12.xyzx)).xyzx * r0_z_10.xxxx);
                float r2_y_5 = r2_xyzw_5.y;
                float r2_z_3 = r2_xyzw_5.z;
                float r0_z_11 = (min((r2_x_3 + 0.22091627), 1) + -0.2209163);
                float r0_z_12 = mad(r1_z_5, r0_z_11, 0.2209163);
                float4 r0_xyzw_10 = mad(float4(r2_x_4, r2_y_5, r2_z_3, r2_x_4), r0_z_12.xxxx, float4(r0_x_9, r0_y_13, r0_w_17, r0_x_9));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_14 = r0_xyzw_10.y;
                float r0_z_13 = r0_xyzw_10.z;
                o.sv_Target0.xyz = (mad(_OceanEmission.xyzx, _EmissionScale.xxxx, float4(r0_x_10, r0_y_14, r0_z_13, r0_x_10))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[14];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb3_values[7];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
            struct program41Input
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
            struct program41Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program87Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program87Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program41Output vert(program41Input i)
            {
                program41Output o = (program41Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = (mad(unity_WorldToObject[3].xyzx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyzx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program87Output frag(program87Input i)
            {
                program87Output o = (program87Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r1_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r1_w_2 = rsqrt(r1_w_1);
                float3 unitViewDir_xyz_2 = ((r1_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_3 = log2(cb0_values[10].x);
                float r1_w_4 = (r1_w_3 * cb0_values[13].x);
                float r1_w_5 = exp2(r1_w_4);
                float r1_w_6 = (-r1_w_5 + 1);
                float r2_w_1 = (r1_w_6 * cb0_values[12].x);
                float r2_w_2 = r2_w_1;
                float r1_w_7 = mad(r1_w_6, cb0_values[12].y, cb0_values[9].x);
                float r1_w_8 = (r1_w_7 + cb0_values[12].z);
                float3 r4_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord1.zzzz, (mad(cb0_values[4].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r2_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r2_w_3)
                {
                    float r2_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r5_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r2_w_4.xxxx ? r5_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r5_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r2_w_5 = mad(r5_y_8, 0.25, 0.75);
                    float r3_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r5_x_8 = max(r2_w_5, r3_w_1);
                    float4 r5_xyzw_9 = t1.Sample(s0, float4(r5_x_8, r5_z_8, r5_w_2, r5_x_8));
                    r5_x_10 = r5_xyzw_9.x;
                    r5_y_10 = r5_xyzw_9.y;
                    r5_z_10 = r5_xyzw_9.z;
                    r5_w_4 = r5_xyzw_9.w;
                }
                else
                {
                    float4 r5_xyzw_10 = float4(1, 1, 1, 1);
                    r5_x_10 = r5_xyzw_10.x;
                    r5_y_10 = r5_xyzw_10.y;
                    r5_z_10 = r5_xyzw_10.z;
                    r5_w_4 = r5_xyzw_10.w;
                }
                float r2_w_7 = dot(float4(r5_x_10, r5_y_10, r5_z_10, r5_w_4), unity_OcclusionMaskSelector);
                float r3_w_3 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float4 r4_xyzw_5 = t0.Sample(s1, r3_w_3.xxxx);
                float r2_w_8 = (r2_w_7 * r4_xyzw_5.x);
                float3 r4_xyz_6 = ((r2_w_8.xxxx * _LightColor0.xyzx)).xyz;
                float r2_w_9 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r2_w_10 = rsqrt(r2_w_9);
                float3 unitWorldNormal_xyz_11 = ((r2_w_10.xxxx * i.texcoord0.xyzx)).xyz;
                float r1_w_9 = (-r1_w_8 + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_2.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitWorldNormal_xyz_11.xyzx, unitViewDir_xyz_2.xyzx);
                float r2_x_3 = dot(unitWorldNormal_xyz_11.xyzx, r1_xyz_1.xyzx);
                float r2_y_3 = dot(unitWorldNormal_xyz_11.xyzx, r0_xyz_3.xyzx);
                float r0_x_4 = dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_9.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_x_3 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(nDotV_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_9 * r1_w_9);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(nDotV_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * mad(r2_x_3, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_x_3, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r2_y_3, r0_z_9, -r2_y_3), r2_y_3, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float r0_z_14 = max(r0_z_13, 0.0001);
                float r0_z_15 = sqrt(r0_z_14);
                float4 r0_xyzw_9 = (r2_x_3.xxxx * float4(r0_y_8, r0_y_8, r0_z_15, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_16 = r0_xyzw_9.z;
                float4 r1_xyzw_11 = (r0_y_9.xxxx * r4_xyz_6.xyzx);
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (r4_xyz_6.xxyz * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_11 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_10 = (r0_x_5 * r0_x_5);
                float r1_w_11 = (r1_w_10 * r1_w_10);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r1_w_11), 0.7790837, 0.2209163)).xxxx * float4(r0_y_10, r0_z_17, r0_w_11, r0_y_10));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_11 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                o.sv_Target0.xyz = (mad((((mad(r2_w_2.xxxx, -cb0_values[8].xyzx, cb0_values[8].xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[14];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerComparisonState s1 : register(s1);
            SamplerState s2 : register(s2);
            SamplerState s3 : register(s3);
            Texture2D t0 : register(t0);
            TextureCube t1 : register(t1);
            Texture3D t2 : register(t2);
            TextureCube t3 : register(t3);
            struct program66Input
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
            struct program66Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program112Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program112Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program66Output vert(program66Input i)
            {
                program66Output o = (program66Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                o.texcoord4.x = clipPos_xyzw_2.z;
                float worldNormal_x_3 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord0.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = (mad(unity_WorldToObject[3].xyzx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyzx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program112Output frag(program112Input i)
            {
                program112Output o = (program112Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r1_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r1_w_2 = rsqrt(r1_w_1);
                float3 unitViewDir_xyz_1 = ((r1_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_3 = log2(cb0_values[10].x);
                float r1_w_4 = (r1_w_3 * cb0_values[13].x);
                float r1_w_5 = exp2(r1_w_4);
                float r1_w_6 = (-r1_w_5 + 1);
                float r2_w_1 = (r1_w_6 * cb0_values[12].x);
                float r2_w_2 = r2_w_1;
                float r1_w_7 = mad(r1_w_6, cb0_values[12].y, cb0_values[9].x);
                float r1_w_8 = (r1_w_7 + cb0_values[12].z);
                float3 r5_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord1.zzzz, (mad(cb0_values[4].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r2_x_2 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float4 r2_xyzw_2 = (i.texcoord1.xxyz + -cb3_values[25].xxyz);
                float r2_y_2 = r2_xyzw_2.y;
                float r2_z_2 = r2_xyzw_2.z;
                float r2_w_3 = r2_xyzw_2.w;
                float r2_y_3 = dot(float4(r2_y_2, r2_z_2, r2_w_3, r2_y_2), float4(r2_y_2, r2_z_2, r2_w_3, r2_y_2));
                float r2_y_4 = sqrt(r2_y_3);
                float r2_y_5 = (-r2_x_2 + r2_y_4);
                float r2_x_4 = mad(mad(cb3_values[25].w, r2_y_5, r2_x_2), cb3_values[24].z, cb3_values[24].w);
                float r2_y_6 = (cb6_values[0].x == 1);
                float r6_x_9;
                float r6_y_9;
                float r6_z_9;
                float r6_w_4;
                if (r2_y_6)
                {
                    float r2_y_7 = (cb6_values[0].y == 1);
                    float3 r6_xyz_6 = (((mad(cb6_values[3].xyzx, i.texcoord1.zzzz, (mad(cb6_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (r2_y_7.xxxx ? r6_xyz_6.xxyz : i.texcoord1.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float r2_w_4 = r2_xyzw_8.w;
                    float4 r2_xyzw_9 = (float4(r2_y_8, r2_y_8, r2_z_3, r2_w_4) + -cb6_values[6].xxyz);
                    float r2_y_9 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float r2_w_5 = r2_xyzw_9.w;
                    float4 r6_xyzw_7 = (float4(r2_y_9, r2_y_9, r2_z_4, r2_w_5) * cb6_values[5].xxyz);
                    float r6_y_7 = r6_xyzw_7.y;
                    float r6_z_7 = r6_xyzw_7.z;
                    float r6_w_2 = r6_xyzw_7.w;
                    float r2_y_10 = mad(r6_y_7, 0.25, 0.75);
                    float r2_z_5 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r6_x_7 = max(r2_z_5, r2_y_10);
                    float4 r6_xyzw_8 = t2.Sample(s0, float4(r6_x_7, r6_z_7, r6_w_2, r6_x_7));
                    r6_x_9 = r6_xyzw_8.x;
                    r6_y_9 = r6_xyzw_8.y;
                    r6_z_9 = r6_xyzw_8.z;
                    r6_w_4 = r6_xyzw_8.w;
                }
                else
                {
                    float4 r6_xyzw_2 = float4(1, 1, 1, 1);
                    r6_x_9 = r6_xyzw_2.x;
                    r6_y_9 = r6_xyzw_2.y;
                    r6_z_9 = r6_xyzw_2.z;
                    r6_w_4 = r6_xyzw_2.w;
                }
                float r2_y_12 = dot(float4(r6_x_9, r6_y_9, r6_z_9, r6_w_4), unity_OcclusionMaskSelector);
                float r2_z_7 = (r2_x_4 < 0.99);
                float r2_z_19;
                if (r2_z_7)
                {
                    float3 r6_xyz_10 = ((i.texcoord1.xyzx + -cb2_values[1].xyzx)).xyz;
                    float r2_z_9 = max(abs(r6_xyz_10.y), abs(r6_xyz_10.x));
                    float r2_z_10 = max(abs(r6_xyz_10.z), r2_z_9);
                    float r2_z_11 = (r2_z_10 + -cb2_values[2].z);
                    float r2_z_12 = max(r2_z_11, 1E-05);
                    float r2_z_13 = (r2_z_12 * cb2_values[2].w);
                    float r2_z_14 = (cb2_values[2].y / r2_z_13);
                    float r2_z_15 = (r2_z_14 + -cb2_values[2].x);
                    float r2_z_16 = (-r2_z_15 + 1);
                    float r7_x_2 = t3.SampleCmpLevelZero(s1, (((r6_xyz_10.xyzx + float4(0.0078125, 0.0078125, 0.0078125, 0))).xyzx).xyz, r2_z_16);
                    float r7_y_2 = t3.SampleCmpLevelZero(s1, (((r6_xyz_10.xyzx + float4(-0.0078125, -0.0078125, 0.0078125, 0))).xyzx).xyz, r2_z_16);
                    float r7_z_2 = t3.SampleCmpLevelZero(s1, (((r6_xyz_10.xyzx + float4(-0.0078125, 0.0078125, -0.0078125, 0))).xyzx).xyz, r2_z_16);
                    float r7_w_1 = t3.SampleCmpLevelZero(s1, (((r6_xyz_10.xyzx + float4(0.0078125, -0.0078125, -0.0078125, 0))).xyzx).xyz, r2_z_16);
                    float r2_z_17 = dot(float4(r7_x_2, r7_y_2, r7_z_2, r7_w_1), float4(0.25, 0.25, 0.25, 0.25));
                    float r2_w_7 = (-cb3_values[24].x + 1);
                    float r2_z_18 = mad(r2_z_17, r2_w_7, cb3_values[24].x);
                    r2_z_19 = r2_z_18;
                }
                else
                {
                    float r2_z_8 = 1;
                    r2_z_19 = r2_z_8;
                }
                float r2_y_13 = (-r2_z_19 + r2_y_12);
                float r2_y_14 = dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx);
                float4 r6_xyzw_13 = t0.Sample(s3, r2_y_14.xxxx);
                float4 r5_xyzw_5 = t1.Sample(s2, r5_xyz_4.xyzx);
                float r2_y_15 = (r5_xyzw_5.w * r6_xyzw_13.x);
                float4 r2_xyzw_7 = (((mad(r2_x_4, r2_y_13, r2_z_19) * r2_y_15)).xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_16 = r2_xyzw_7.y;
                float r2_z_20 = r2_xyzw_7.z;
                float r2_w_9 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r2_w_10 = rsqrt(r2_w_9);
                float3 unitClipPos_xyz_6 = ((r2_w_10.xxxx * i.texcoord0.xyzx)).xyz;
                float r1_w_9 = (-r1_w_8 + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitClipPos_xyz_6.xyzx, unitViewDir_xyz_1.xyzx);
                float r2_w_11 = dot(unitClipPos_xyz_6.xyzx, r1_xyz_1.xyzx);
                float r3_x_2 = dot(unitClipPos_xyz_6.xyzx, r0_xyz_3.xyzx);
                float r0_x_4 = dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_9.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_11 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(nDotV_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_9 * r1_w_9);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(nDotV_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * mad(r2_w_11, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_11, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r3_x_2, r0_z_9, -r3_x_2), r3_x_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float r0_z_14 = max(r0_z_13, 0.0001);
                float r0_z_15 = sqrt(r0_z_14);
                float4 r0_xyzw_9 = (r2_w_11.xxxx * float4(r0_y_8, r0_y_8, r0_z_15, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_16 = r0_xyzw_9.z;
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r2_x_7, r2_y_16, r2_z_20, r2_x_7));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r2_x_7, r2_x_7, r2_y_16, r2_z_20) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_11 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_10 = (r0_x_5 * r0_x_5);
                float r1_w_11 = (r1_w_10 * r1_w_10);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r1_w_11), 0.7790837, 0.2209163)).xxxx * float4(r0_y_10, r0_z_17, r0_w_11, r0_y_10));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_11 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                float r0_x_9 = (mad((((mad(r2_w_2.xxxx, -cb0_values[8].xyzx, cb0_values[8].xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8))).x;
                float4 r0_xyzw_12 = mad((((mad(r2_w_2.xxxx, -cb0_values[8].xyzx, cb0_values[8].xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8));
                float r0_y_12 = r0_xyzw_12.y;
                float r0_z_19 = r0_xyzw_12.z;
                float r0_w_12 = (i.texcoord4.x / cb1_values[5].y);
                float r0_w_13 = (-r0_w_12 + 1);
                float r0_w_14 = (r0_w_13 * cb1_values[5].z);
                float r0_w_15 = max(r0_w_14, 0);
                float r0_w_16 = mad(r0_w_15, cb5_values[1].z, cb5_values[1].w);
                o.sv_Target0.xyz = ((float4(r0_x_9, r0_y_12, r0_z_19, r0_x_9) * r0_w_16.xxxx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[14];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerComparisonState s1 : register(s1);
            SamplerState s2 : register(s2);
            SamplerState s3 : register(s3);
            Texture2D t0 : register(t0);
            TextureCube t1 : register(t1);
            Texture3D t2 : register(t2);
            TextureCube t3 : register(t3);
            struct program65Input
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
            struct program65Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program111Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program111Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program65Output vert(program65Input i)
            {
                program65Output o = (program65Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                o.texcoord4.x = clipPos_xyzw_2.z;
                float worldNormal_x_3 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord0.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = (mad(unity_WorldToObject[3].xyzx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyzx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program111Output frag(program111Input i)
            {
                program111Output o = (program111Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r1_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r1_w_2 = rsqrt(r1_w_1);
                float3 unitViewDir_xyz_1 = ((r1_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_3 = log2(cb0_values[10].x);
                float r1_w_4 = (r1_w_3 * cb0_values[13].x);
                float r1_w_5 = exp2(r1_w_4);
                float r1_w_6 = (-r1_w_5 + 1);
                float r2_w_1 = (r1_w_6 * cb0_values[12].x);
                float r2_w_2 = r2_w_1;
                float r1_w_7 = mad(r1_w_6, cb0_values[12].y, cb0_values[9].x);
                float r1_w_8 = (r1_w_7 + cb0_values[12].z);
                float3 r5_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord1.zzzz, (mad(cb0_values[4].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r2_x_2 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float4 r2_xyzw_2 = (i.texcoord1.xxyz + -cb3_values[25].xxyz);
                float r2_y_2 = r2_xyzw_2.y;
                float r2_z_2 = r2_xyzw_2.z;
                float r2_w_3 = r2_xyzw_2.w;
                float r2_y_3 = dot(float4(r2_y_2, r2_z_2, r2_w_3, r2_y_2), float4(r2_y_2, r2_z_2, r2_w_3, r2_y_2));
                float r2_y_4 = sqrt(r2_y_3);
                float r2_y_5 = (-r2_x_2 + r2_y_4);
                float r2_y_6 = (cb6_values[0].x == 1);
                float r6_x_9;
                float r6_y_9;
                float r6_z_9;
                float r6_w_4;
                if (r2_y_6)
                {
                    float r2_y_7 = (cb6_values[0].y == 1);
                    float3 r6_xyz_6 = (((mad(cb6_values[3].xyzx, i.texcoord1.zzzz, (mad(cb6_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (r2_y_7.xxxx ? r6_xyz_6.xxyz : i.texcoord1.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float r2_w_4 = r2_xyzw_8.w;
                    float4 r2_xyzw_9 = (float4(r2_y_8, r2_y_8, r2_z_3, r2_w_4) + -cb6_values[6].xxyz);
                    float r2_y_9 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float r2_w_5 = r2_xyzw_9.w;
                    float4 r6_xyzw_7 = (float4(r2_y_9, r2_y_9, r2_z_4, r2_w_5) * cb6_values[5].xxyz);
                    float r6_y_7 = r6_xyzw_7.y;
                    float r6_z_7 = r6_xyzw_7.z;
                    float r6_w_2 = r6_xyzw_7.w;
                    float r2_y_10 = mad(r6_y_7, 0.25, 0.75);
                    float r2_z_5 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r6_x_7 = max(r2_z_5, r2_y_10);
                    float4 r6_xyzw_8 = t2.Sample(s0, float4(r6_x_7, r6_z_7, r6_w_2, r6_x_7));
                    r6_x_9 = r6_xyzw_8.x;
                    r6_y_9 = r6_xyzw_8.y;
                    r6_z_9 = r6_xyzw_8.z;
                    r6_w_4 = r6_xyzw_8.w;
                }
                else
                {
                    float4 r6_xyzw_2 = float4(1, 1, 1, 1);
                    r6_x_9 = r6_xyzw_2.x;
                    r6_y_9 = r6_xyzw_2.y;
                    r6_z_9 = r6_xyzw_2.z;
                    r6_w_4 = r6_xyzw_2.w;
                }
                float r2_y_12 = dot(float4(r6_x_9, r6_y_9, r6_z_9, r6_w_4), unity_OcclusionMaskSelector);
                float3 r6_xyz_10 = ((i.texcoord1.xyzx + -cb2_values[1].xyzx)).xyz;
                float r2_z_7 = max(abs(r6_xyz_10.y), abs(r6_xyz_10.x));
                float r2_z_8 = max(abs(r6_xyz_10.z), r2_z_7);
                float r2_z_9 = (r2_z_8 + -cb2_values[2].z);
                float r2_z_10 = max(r2_z_9, 1E-05);
                float r2_z_11 = (r2_z_10 * cb2_values[2].w);
                float r2_z_12 = (cb2_values[2].y / r2_z_11);
                float r2_z_13 = (r2_z_12 + -cb2_values[2].x);
                float r2_z_14 = (-r2_z_13 + 1);
                float r2_z_15 = t3.SampleCmpLevelZero(s1, (r6_xyz_10.xyzx).xyz, r2_z_14);
                float r2_w_7 = (-cb3_values[24].x + 1);
                float r2_z_16 = mad(r2_z_15, r2_w_7, cb3_values[24].x);
                float r2_y_13 = (-r2_z_16 + r2_y_12);
                float r2_y_14 = dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx);
                float4 r6_xyzw_11 = t0.Sample(s3, r2_y_14.xxxx);
                float4 r5_xyzw_5 = t1.Sample(s2, r5_xyz_4.xyzx);
                float r2_y_15 = (r5_xyzw_5.w * r6_xyzw_11.x);
                float4 r2_xyzw_7 = (((mad(mad(mad(cb3_values[25].w, r2_y_5, r2_x_2), cb3_values[24].z, cb3_values[24].w), r2_y_13, r2_z_16) * r2_y_15)).xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_16 = r2_xyzw_7.y;
                float r2_z_17 = r2_xyzw_7.z;
                float r2_w_8 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r2_w_9 = rsqrt(r2_w_8);
                float3 unitClipPos_xyz_6 = ((r2_w_9.xxxx * i.texcoord0.xyzx)).xyz;
                float r1_w_9 = (-r1_w_8 + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitClipPos_xyz_6.xyzx, unitViewDir_xyz_1.xyzx);
                float r2_w_10 = dot(unitClipPos_xyz_6.xyzx, r1_xyz_1.xyzx);
                float r3_x_2 = dot(unitClipPos_xyz_6.xyzx, r0_xyz_3.xyzx);
                float r0_x_4 = dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_9.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_10 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(nDotV_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_9 * r1_w_9);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(nDotV_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * mad(r2_w_10, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_10, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r3_x_2, r0_z_9, -r3_x_2), r3_x_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float r0_z_14 = max(r0_z_13, 0.0001);
                float r0_z_15 = sqrt(r0_z_14);
                float4 r0_xyzw_9 = (r2_w_10.xxxx * float4(r0_y_8, r0_y_8, r0_z_15, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_16 = r0_xyzw_9.z;
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r2_x_7, r2_y_16, r2_z_17, r2_x_7));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r2_x_7, r2_x_7, r2_y_16, r2_z_17) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_11 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_10 = (r0_x_5 * r0_x_5);
                float r1_w_11 = (r1_w_10 * r1_w_10);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r1_w_11), 0.7790837, 0.2209163)).xxxx * float4(r0_y_10, r0_z_17, r0_w_11, r0_y_10));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_11 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                float r0_x_9 = (mad((((mad(r2_w_2.xxxx, -cb0_values[8].xyzx, cb0_values[8].xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8))).x;
                float4 r0_xyzw_12 = mad((((mad(r2_w_2.xxxx, -cb0_values[8].xyzx, cb0_values[8].xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8));
                float r0_y_12 = r0_xyzw_12.y;
                float r0_z_19 = r0_xyzw_12.z;
                float r0_w_12 = (i.texcoord4.x / cb1_values[5].y);
                float r0_w_13 = (-r0_w_12 + 1);
                float r0_w_14 = (r0_w_13 * cb1_values[5].z);
                float r0_w_15 = max(r0_w_14, 0);
                float r0_w_16 = mad(r0_w_15, cb5_values[1].z, cb5_values[1].w);
                o.sv_Target0.xyz = ((float4(r0_x_9, r0_y_12, r0_z_19, r0_x_9) * r0_w_16.xxxx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[14];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerComparisonState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
            TextureCube t2 : register(t2);
            struct program64Input
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
            struct program64Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program110Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program110Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program64Output vert(program64Input i)
            {
                program64Output o = (program64Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                o.texcoord4.x = clipPos_xyzw_2.z;
                float worldNormal_x_3 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord0.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = (mad(unity_WorldToObject[3].xyzx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyzx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program110Output frag(program110Input i)
            {
                program110Output o = (program110Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r1_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r1_w_2 = rsqrt(r1_w_1);
                float3 unitViewDir_xyz_1 = ((r1_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_3 = log2(cb0_values[10].x);
                float r1_w_4 = (r1_w_3 * cb0_values[13].x);
                float r1_w_5 = exp2(r1_w_4);
                float r1_w_6 = (-r1_w_5 + 1);
                float r2_w_1 = (r1_w_6 * cb0_values[12].x);
                float r2_w_2 = r2_w_1;
                float r1_w_7 = mad(r1_w_6, cb0_values[12].y, cb0_values[9].x);
                float r1_w_8 = (r1_w_7 + cb0_values[12].z);
                float3 r5_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord1.zzzz, (mad(cb0_values[4].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r2_x_2 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float4 r2_xyzw_2 = (i.texcoord1.xxyz + -cb3_values[25].xxyz);
                float r2_y_2 = r2_xyzw_2.y;
                float r2_z_2 = r2_xyzw_2.z;
                float r2_w_3 = r2_xyzw_2.w;
                float r2_y_3 = dot(float4(r2_y_2, r2_z_2, r2_w_3, r2_y_2), float4(r2_y_2, r2_z_2, r2_w_3, r2_y_2));
                float r2_y_4 = sqrt(r2_y_3);
                float r2_y_5 = (-r2_x_2 + r2_y_4);
                float r2_x_4 = mad(mad(cb3_values[25].w, r2_y_5, r2_x_2), cb3_values[24].z, cb3_values[24].w);
                float r2_y_6 = (cb6_values[0].x == 1);
                float r6_x_9;
                float r6_y_9;
                float r6_z_9;
                float r6_w_4;
                if (r2_y_6)
                {
                    float r2_y_7 = (cb6_values[0].y == 1);
                    float3 r6_xyz_6 = (((mad(cb6_values[3].xyzx, i.texcoord1.zzzz, (mad(cb6_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (r2_y_7.xxxx ? r6_xyz_6.xxyz : i.texcoord1.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float r2_w_4 = r2_xyzw_8.w;
                    float4 r2_xyzw_9 = (float4(r2_y_8, r2_y_8, r2_z_3, r2_w_4) + -cb6_values[6].xxyz);
                    float r2_y_9 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float r2_w_5 = r2_xyzw_9.w;
                    float4 r6_xyzw_7 = (float4(r2_y_9, r2_y_9, r2_z_4, r2_w_5) * cb6_values[5].xxyz);
                    float r6_y_7 = r6_xyzw_7.y;
                    float r6_z_7 = r6_xyzw_7.z;
                    float r6_w_2 = r6_xyzw_7.w;
                    float r2_y_10 = mad(r6_y_7, 0.25, 0.75);
                    float r2_z_5 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r6_x_7 = max(r2_z_5, r2_y_10);
                    float4 r6_xyzw_8 = t1.Sample(s0, float4(r6_x_7, r6_z_7, r6_w_2, r6_x_7));
                    r6_x_9 = r6_xyzw_8.x;
                    r6_y_9 = r6_xyzw_8.y;
                    r6_z_9 = r6_xyzw_8.z;
                    r6_w_4 = r6_xyzw_8.w;
                }
                else
                {
                    float4 r6_xyzw_2 = float4(1, 1, 1, 1);
                    r6_x_9 = r6_xyzw_2.x;
                    r6_y_9 = r6_xyzw_2.y;
                    r6_z_9 = r6_xyzw_2.z;
                    r6_w_4 = r6_xyzw_2.w;
                }
                float r2_y_12 = dot(float4(r6_x_9, r6_y_9, r6_z_9, r6_w_4), unity_OcclusionMaskSelector);
                float r2_z_7 = (r2_x_4 < 0.99);
                float r2_z_19;
                if (r2_z_7)
                {
                    float3 r6_xyz_10 = ((i.texcoord1.xyzx + -cb2_values[1].xyzx)).xyz;
                    float r2_z_9 = max(abs(r6_xyz_10.y), abs(r6_xyz_10.x));
                    float r2_z_10 = max(abs(r6_xyz_10.z), r2_z_9);
                    float r2_z_11 = (r2_z_10 + -cb2_values[2].z);
                    float r2_z_12 = max(r2_z_11, 1E-05);
                    float r2_z_13 = (r2_z_12 * cb2_values[2].w);
                    float r2_z_14 = (cb2_values[2].y / r2_z_13);
                    float r2_z_15 = (r2_z_14 + -cb2_values[2].x);
                    float r2_z_16 = (-r2_z_15 + 1);
                    float r7_x_2 = t2.SampleCmpLevelZero(s1, (((r6_xyz_10.xyzx + float4(0.0078125, 0.0078125, 0.0078125, 0))).xyzx).xyz, r2_z_16);
                    float r7_y_2 = t2.SampleCmpLevelZero(s1, (((r6_xyz_10.xyzx + float4(-0.0078125, -0.0078125, 0.0078125, 0))).xyzx).xyz, r2_z_16);
                    float r7_z_2 = t2.SampleCmpLevelZero(s1, (((r6_xyz_10.xyzx + float4(-0.0078125, 0.0078125, -0.0078125, 0))).xyzx).xyz, r2_z_16);
                    float r7_w_1 = t2.SampleCmpLevelZero(s1, (((r6_xyz_10.xyzx + float4(0.0078125, -0.0078125, -0.0078125, 0))).xyzx).xyz, r2_z_16);
                    float r2_z_17 = dot(float4(r7_x_2, r7_y_2, r7_z_2, r7_w_1), float4(0.25, 0.25, 0.25, 0.25));
                    float r2_w_7 = (-cb3_values[24].x + 1);
                    float r2_z_18 = mad(r2_z_17, r2_w_7, cb3_values[24].x);
                    r2_z_19 = r2_z_18;
                }
                else
                {
                    float r2_z_8 = 1;
                    r2_z_19 = r2_z_8;
                }
                float r2_y_13 = (-r2_z_19 + r2_y_12);
                float r2_y_14 = dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx);
                float4 r5_xyzw_5 = t0.Sample(s2, r2_y_14.xxxx);
                float4 r2_xyzw_7 = (((mad(r2_x_4, r2_y_13, r2_z_19) * r5_xyzw_5.x)).xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_15 = r2_xyzw_7.y;
                float r2_z_20 = r2_xyzw_7.z;
                float r2_w_9 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r2_w_10 = rsqrt(r2_w_9);
                float3 unitClipPos_xyz_6 = ((r2_w_10.xxxx * i.texcoord0.xyzx)).xyz;
                float r1_w_9 = (-r1_w_8 + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitClipPos_xyz_6.xyzx, unitViewDir_xyz_1.xyzx);
                float r2_w_11 = dot(unitClipPos_xyz_6.xyzx, r1_xyz_1.xyzx);
                float r3_x_2 = dot(unitClipPos_xyz_6.xyzx, r0_xyz_3.xyzx);
                float r0_x_4 = dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_9.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_11 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(nDotV_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_9 * r1_w_9);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(nDotV_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * mad(r2_w_11, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_11, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r3_x_2, r0_z_9, -r3_x_2), r3_x_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float r0_z_14 = max(r0_z_13, 0.0001);
                float r0_z_15 = sqrt(r0_z_14);
                float4 r0_xyzw_9 = (r2_w_11.xxxx * float4(r0_y_8, r0_y_8, r0_z_15, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_16 = r0_xyzw_9.z;
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r2_x_7, r2_y_15, r2_z_20, r2_x_7));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r2_x_7, r2_x_7, r2_y_15, r2_z_20) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_11 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_10 = (r0_x_5 * r0_x_5);
                float r1_w_11 = (r1_w_10 * r1_w_10);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r1_w_11), 0.7790837, 0.2209163)).xxxx * float4(r0_y_10, r0_z_17, r0_w_11, r0_y_10));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_11 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                float r0_x_9 = (mad((((mad(r2_w_2.xxxx, -cb0_values[8].xyzx, cb0_values[8].xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8))).x;
                float4 r0_xyzw_12 = mad((((mad(r2_w_2.xxxx, -cb0_values[8].xyzx, cb0_values[8].xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8));
                float r0_y_12 = r0_xyzw_12.y;
                float r0_z_19 = r0_xyzw_12.z;
                float r0_w_12 = (i.texcoord4.x / cb1_values[5].y);
                float r0_w_13 = (-r0_w_12 + 1);
                float r0_w_14 = (r0_w_13 * cb1_values[5].z);
                float r0_w_15 = max(r0_w_14, 0);
                float r0_w_16 = mad(r0_w_15, cb5_values[1].z, cb5_values[1].w);
                o.sv_Target0.xyz = ((float4(r0_x_9, r0_y_12, r0_z_19, r0_x_9) * r0_w_16.xxxx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[14];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerComparisonState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
            TextureCube t2 : register(t2);
            struct program63Input
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
            struct program63Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program109Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program109Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program63Output vert(program63Input i)
            {
                program63Output o = (program63Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                o.texcoord4.x = clipPos_xyzw_2.z;
                float worldNormal_x_3 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord0.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = (mad(unity_WorldToObject[3].xyzx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyzx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program109Output frag(program109Input i)
            {
                program109Output o = (program109Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r1_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r1_w_2 = rsqrt(r1_w_1);
                float3 unitViewDir_xyz_1 = ((r1_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_3 = log2(cb0_values[10].x);
                float r1_w_4 = (r1_w_3 * cb0_values[13].x);
                float r1_w_5 = exp2(r1_w_4);
                float r1_w_6 = (-r1_w_5 + 1);
                float r2_w_1 = (r1_w_6 * cb0_values[12].x);
                float r2_w_2 = r2_w_1;
                float r1_w_7 = mad(r1_w_6, cb0_values[12].y, cb0_values[9].x);
                float r1_w_8 = (r1_w_7 + cb0_values[12].z);
                float3 r5_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord1.zzzz, (mad(cb0_values[4].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r2_x_2 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float4 r2_xyzw_2 = (i.texcoord1.xxyz + -cb3_values[25].xxyz);
                float r2_y_2 = r2_xyzw_2.y;
                float r2_z_2 = r2_xyzw_2.z;
                float r2_w_3 = r2_xyzw_2.w;
                float r2_y_3 = dot(float4(r2_y_2, r2_z_2, r2_w_3, r2_y_2), float4(r2_y_2, r2_z_2, r2_w_3, r2_y_2));
                float r2_y_4 = sqrt(r2_y_3);
                float r2_y_5 = (-r2_x_2 + r2_y_4);
                float r2_y_6 = (cb6_values[0].x == 1);
                float r6_x_9;
                float r6_y_9;
                float r6_z_9;
                float r6_w_4;
                if (r2_y_6)
                {
                    float r2_y_7 = (cb6_values[0].y == 1);
                    float3 r6_xyz_6 = (((mad(cb6_values[3].xyzx, i.texcoord1.zzzz, (mad(cb6_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (r2_y_7.xxxx ? r6_xyz_6.xxyz : i.texcoord1.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float r2_w_4 = r2_xyzw_8.w;
                    float4 r2_xyzw_9 = (float4(r2_y_8, r2_y_8, r2_z_3, r2_w_4) + -cb6_values[6].xxyz);
                    float r2_y_9 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float r2_w_5 = r2_xyzw_9.w;
                    float4 r6_xyzw_7 = (float4(r2_y_9, r2_y_9, r2_z_4, r2_w_5) * cb6_values[5].xxyz);
                    float r6_y_7 = r6_xyzw_7.y;
                    float r6_z_7 = r6_xyzw_7.z;
                    float r6_w_2 = r6_xyzw_7.w;
                    float r2_y_10 = mad(r6_y_7, 0.25, 0.75);
                    float r2_z_5 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r6_x_7 = max(r2_z_5, r2_y_10);
                    float4 r6_xyzw_8 = t1.Sample(s0, float4(r6_x_7, r6_z_7, r6_w_2, r6_x_7));
                    r6_x_9 = r6_xyzw_8.x;
                    r6_y_9 = r6_xyzw_8.y;
                    r6_z_9 = r6_xyzw_8.z;
                    r6_w_4 = r6_xyzw_8.w;
                }
                else
                {
                    float4 r6_xyzw_2 = float4(1, 1, 1, 1);
                    r6_x_9 = r6_xyzw_2.x;
                    r6_y_9 = r6_xyzw_2.y;
                    r6_z_9 = r6_xyzw_2.z;
                    r6_w_4 = r6_xyzw_2.w;
                }
                float r2_y_12 = dot(float4(r6_x_9, r6_y_9, r6_z_9, r6_w_4), unity_OcclusionMaskSelector);
                float3 r6_xyz_10 = ((i.texcoord1.xyzx + -cb2_values[1].xyzx)).xyz;
                float r2_z_7 = max(abs(r6_xyz_10.y), abs(r6_xyz_10.x));
                float r2_z_8 = max(abs(r6_xyz_10.z), r2_z_7);
                float r2_z_9 = (r2_z_8 + -cb2_values[2].z);
                float r2_z_10 = max(r2_z_9, 1E-05);
                float r2_z_11 = (r2_z_10 * cb2_values[2].w);
                float r2_z_12 = (cb2_values[2].y / r2_z_11);
                float r2_z_13 = (r2_z_12 + -cb2_values[2].x);
                float r2_z_14 = (-r2_z_13 + 1);
                float r2_z_15 = t2.SampleCmpLevelZero(s1, (r6_xyz_10.xyzx).xyz, r2_z_14);
                float r2_w_7 = (-cb3_values[24].x + 1);
                float r2_z_16 = mad(r2_z_15, r2_w_7, cb3_values[24].x);
                float r2_y_13 = (-r2_z_16 + r2_y_12);
                float r2_y_14 = dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx);
                float4 r5_xyzw_5 = t0.Sample(s2, r2_y_14.xxxx);
                float4 r2_xyzw_7 = (((mad(mad(mad(cb3_values[25].w, r2_y_5, r2_x_2), cb3_values[24].z, cb3_values[24].w), r2_y_13, r2_z_16) * r5_xyzw_5.x)).xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_15 = r2_xyzw_7.y;
                float r2_z_17 = r2_xyzw_7.z;
                float r2_w_8 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r2_w_9 = rsqrt(r2_w_8);
                float3 unitClipPos_xyz_6 = ((r2_w_9.xxxx * i.texcoord0.xyzx)).xyz;
                float r1_w_9 = (-r1_w_8 + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitClipPos_xyz_6.xyzx, unitViewDir_xyz_1.xyzx);
                float r2_w_10 = dot(unitClipPos_xyz_6.xyzx, r1_xyz_1.xyzx);
                float r3_x_2 = dot(unitClipPos_xyz_6.xyzx, r0_xyz_3.xyzx);
                float r0_x_4 = dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_9.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_10 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(nDotV_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_9 * r1_w_9);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(nDotV_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * mad(r2_w_10, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_10, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r3_x_2, r0_z_9, -r3_x_2), r3_x_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float r0_z_14 = max(r0_z_13, 0.0001);
                float r0_z_15 = sqrt(r0_z_14);
                float4 r0_xyzw_9 = (r2_w_10.xxxx * float4(r0_y_8, r0_y_8, r0_z_15, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_16 = r0_xyzw_9.z;
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r2_x_7, r2_y_15, r2_z_17, r2_x_7));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r2_x_7, r2_x_7, r2_y_15, r2_z_17) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_11 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_10 = (r0_x_5 * r0_x_5);
                float r1_w_11 = (r1_w_10 * r1_w_10);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r1_w_11), 0.7790837, 0.2209163)).xxxx * float4(r0_y_10, r0_z_17, r0_w_11, r0_y_10));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_11 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                float r0_x_9 = (mad((((mad(r2_w_2.xxxx, -cb0_values[8].xyzx, cb0_values[8].xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8))).x;
                float4 r0_xyzw_12 = mad((((mad(r2_w_2.xxxx, -cb0_values[8].xyzx, cb0_values[8].xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8));
                float r0_y_12 = r0_xyzw_12.y;
                float r0_z_19 = r0_xyzw_12.z;
                float r0_w_12 = (i.texcoord4.x / cb1_values[5].y);
                float r0_w_13 = (-r0_w_12 + 1);
                float r0_w_14 = (r0_w_13 * cb1_values[5].z);
                float r0_w_15 = max(r0_w_14, 0);
                float r0_w_16 = mad(r0_w_15, cb5_values[1].z, cb5_values[1].w);
                o.sv_Target0.xyz = ((float4(r0_x_9, r0_y_12, r0_z_19, r0_x_9) * r0_w_16.xxxx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[14];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[6];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer cb3 : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture3D t2 : register(t2);
            struct program62Input
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
            struct program62Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float texcoord4 : TEXCOORD4;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program108Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float texcoord4 : TEXCOORD4;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program108Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program62Output vert(program62Input i)
            {
                program62Output o = (program62Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                float worldNormal_x_4 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r2_w_4 = dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4));
                float r2_w_5 = rsqrt(r2_w_4);
                o.texcoord0.xyz = ((r2_w_5.xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4))).xyz;
                o.texcoord1.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xy = (mad(unity_WorldToObject[3].xyxx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyxx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyxx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyxx)).xyxx)).xyxx)).xyxx)).xy;
                o.texcoord4.x = clipPos_xyzw_2.z;
                o.texcoord3.zw = (clipPos_xyzw_2.zzzw).zw;
                float2 r1_xz_3 = ((clipPos_xyzw_2.xxwx * float4(0.5, 0, 0.5, 0))).xz;
                float r1_w_3 = ((clipPos_xyzw_2.y * cb1_values[5].x) * 0.5);
                o.texcoord3.xy = ((r1_xz_3.yyyy + float4(r1_xz_3.x, r1_w_3, r1_xz_3.x, r1_xz_3.x))).xy;
                return o;
            }
            #pragma fragment frag
            program108Output frag(program108Input i)
            {
                program108Output o = (program108Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_1 = log2(cb0_values[10].x);
                float r1_w_2 = (r1_w_1 * cb0_values[13].x);
                float r1_w_3 = exp2(r1_w_2);
                float r1_w_4 = (-r1_w_3 + 1);
                float4 r2_xyzw_3 = mad(((r1_w_4 * cb0_values[12].x)).xxxx, -cb0_values[8].xyzx, cb0_values[8].xyzx);
                float r2_x_3 = r2_xyzw_3.x;
                float r2_y_1 = r2_xyzw_3.y;
                float r2_z_1 = r2_xyzw_3.z;
                float r1_w_5 = mad(r1_w_4, cb0_values[12].y, cb0_values[9].x);
                float r1_w_6 = (r1_w_5 + cb0_values[12].z);
                float r4_x_1 = cb4_values[9].z;
                float r4_y_1 = cb4_values[10].z;
                float r4_z_1 = cb4_values[11].z;
                float r2_w_1 = dot(viewDir_xyz_1.xyzx, float4(r4_x_1, r4_y_1, r4_z_1, r4_x_1));
                float3 r4_xyz_2 = ((i.texcoord1.xyzx + -cb3_values[25].xyzx)).xyz;
                float r3_z_1 = dot(r4_xyz_2.xyzx, r4_xyz_2.xyzx);
                float r3_z_2 = sqrt(r3_z_1);
                float r3_z_3 = (-r2_w_1 + r3_z_2);
                float r2_w_2 = mad(cb3_values[25].w, r3_z_3, r2_w_1);
                float r2_w_3 = mad(r2_w_2, cb3_values[24].z, cb3_values[24].w);
                float r3_z_4 = (cb6_values[0].x == 1);
                float r4_x_12;
                float r4_y_12;
                float r4_z_12;
                float r4_w_4;
                if (r3_z_4)
                {
                    float r3_z_5 = (cb6_values[0].y == 1);
                    float3 r4_xyz_7 = (((mad(cb6_values[3].xyzx, i.texcoord1.zzzz, (mad(cb6_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r4_xyzw_10 = (((((r3_z_5.xxxx ? r4_xyz_7.xyzx : i.texcoord1.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r4_y_10 = r4_xyzw_10.y;
                    float r4_z_10 = r4_xyzw_10.z;
                    float r4_w_2 = r4_xyzw_10.w;
                    float r3_z_6 = mad(r4_y_10, 0.25, 0.75);
                    float r3_w_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r4_x_10 = max(r3_w_1, r3_z_6);
                    float4 r4_xyzw_11 = t2.Sample(s0, float4(r4_x_10, r4_z_10, r4_w_2, r4_x_10));
                    r4_x_12 = r4_xyzw_11.x;
                    r4_y_12 = r4_xyzw_11.y;
                    r4_z_12 = r4_xyzw_11.z;
                    r4_w_4 = r4_xyzw_11.w;
                }
                else
                {
                    float4 r4_xyzw_3 = float4(1, 1, 1, 1);
                    r4_x_12 = r4_xyzw_3.x;
                    r4_y_12 = r4_xyzw_3.y;
                    r4_z_12 = r4_xyzw_3.z;
                    r4_w_4 = r4_xyzw_3.w;
                }
                float r3_z_8 = dot(float4(r4_x_12, r4_y_12, r4_z_12, r4_w_4), unity_OcclusionMaskSelector);
                float4 r4_xyzw_14 = t0.Sample(s1, ((i.texcoord3.xyxx / i.texcoord3.wwww)).xyxx);
                float r3_z_9 = (r3_z_8 + -r4_xyzw_14.x);
                float r2_w_4 = mad(r2_w_3, r3_z_9, r4_xyzw_14.x);
                float4 r3_xyzw_5 = t1.Sample(s2, (((mad(cb0_values[6].xyxx, i.texcoord1.zzzz, (mad(cb0_values[4].xyxx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx);
                float r2_w_5 = (r2_w_4 * r3_xyzw_5.w);
                float4 r3_xyzw_6 = (r2_w_5.xxxx * _LightColor0.xyzx);
                float r3_x_6 = r3_xyzw_6.x;
                float r3_y_6 = r3_xyzw_6.y;
                float r3_z_11 = r3_xyzw_6.z;
                float r2_w_6 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r2_w_7 = rsqrt(r2_w_6);
                float4 unitWorldNormal_xyzw_15 = (r2_w_7.xxxx * i.texcoord0.xyzx);
                float unitWorldNormal_x_15 = unitWorldNormal_xyzw_15.x;
                float unitWorldNormal_y_15 = unitWorldNormal_xyzw_15.y;
                float unitWorldNormal_z_14 = unitWorldNormal_xyzw_15.z;
                float4 r2_xyzw_4 = (float4(r2_x_3, r2_y_1, r2_z_1, r2_x_3) * float4(0.7790837, 0.7790837, 0.7790837, 0));
                float r2_x_4 = r2_xyzw_4.x;
                float r2_y_2 = r2_xyzw_4.y;
                float r2_z_2 = r2_xyzw_4.z;
                float r1_w_7 = (-r1_w_6 + 1);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(float4(unitWorldNormal_x_15, unitWorldNormal_y_15, unitWorldNormal_z_14, unitWorldNormal_x_15), unitViewDir_xyz_1.xyzx);
                float r1_x_2 = dot(float4(unitWorldNormal_x_15, unitWorldNormal_y_15, unitWorldNormal_z_14, unitWorldNormal_x_15), _WorldSpaceLightPos0.xyzx);
                float r1_y_2 = dot(float4(unitWorldNormal_x_15, unitWorldNormal_y_15, unitWorldNormal_z_14, unitWorldNormal_x_15), r0_xyz_3.xyzx);
                float r0_x_4 = dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_7.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(nDotV_w_6) + 1);
                float r2_w_8 = (r1_z_4 * r1_z_4);
                float r2_w_9 = (r2_w_8 * r2_w_8);
                float r1_z_5 = (r1_z_4 * r2_w_9);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_7 * r1_w_7);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_z_6 = (-r0_z_8 + 1);
                float r1_w_8 = mad(abs(nDotV_w_6), r1_z_6, r0_z_8);
                float r1_z_7 = mad(r1_x_2, r1_z_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * r1_z_7);
                float r0_w_8 = mad(r1_x_2, r1_w_8, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_z_8 = mad(r1_y_2, r0_z_9, -r1_y_2);
                float r1_y_3 = mad(r1_z_8, r1_y_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r0_z_11 = (r0_z_10 / r1_y_4);
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float r0_z_14 = max(r0_z_13, 0.0001);
                float r0_z_15 = sqrt(r0_z_14);
                float4 r0_xyzw_9 = (r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_z_15, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_16 = r0_xyzw_9.z;
                float4 r1_xyzw_3 = (r0_y_9.xxxx * float4(r3_x_6, r3_y_6, r3_z_11, r3_x_6));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_5 = r1_xyzw_3.y;
                float r1_z_9 = r1_xyzw_3.z;
                float4 r0_xyzw_10 = (float4(r3_x_6, r3_x_6, r3_y_6, r3_z_11) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_11 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_9 = (r0_x_5 * r0_x_5);
                float r1_w_10 = (r1_w_9 * r1_w_9);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r1_w_10), 0.7790837, 0.2209163)).xxxx * float4(r0_y_10, r0_z_17, r0_w_11, r0_y_10));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_11 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                float r0_x_9 = (mad(float4(r2_x_4, r2_y_2, r2_z_2, r2_x_4), float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8))).x;
                float4 r0_xyzw_12 = mad(float4(r2_x_4, r2_y_2, r2_z_2, r2_x_4), float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8));
                float r0_y_12 = r0_xyzw_12.y;
                float r0_z_19 = r0_xyzw_12.z;
                float r0_w_12 = (i.texcoord4.x / cb1_values[5].y);
                float r0_w_13 = (-r0_w_12 + 1);
                float r0_w_14 = (r0_w_13 * cb1_values[5].z);
                float r0_w_15 = max(r0_w_14, 0);
                float r0_w_16 = mad(r0_w_15, cb5_values[1].z, cb5_values[1].w);
                o.sv_Target0.xyz = ((float4(r0_x_9, r0_y_12, r0_z_19, r0_x_9) * r0_w_16.xxxx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[10];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
            struct program61Input
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
            struct program61Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program107Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program107Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program61Output vert(program61Input i)
            {
                program61Output o = (program61Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord4.x = clipPos_xyzw_7.z;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r1_xyzw_3 = (float4(clipPos_xyzw_7.x, clipPos_xyzw_7.x, clipPos_xyzw_7.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_z_3 = r1_xyzw_3.z;
                float r1_w_4 = r1_xyzw_3.w;
                o.texcoord3.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord3.xy = ((r1_z_3.xxxx + float4(r1_x_3, r1_w_4, r1_x_3, r1_x_3))).xy;
                return o;
            }
            #pragma fragment frag
            program107Output frag(program107Input i)
            {
                program107Output o = (program107Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_1 = log2(cb0_values[6].x);
                float r1_w_2 = (r1_w_1 * cb0_values[9].x);
                float r1_w_3 = exp2(r1_w_2);
                float r1_w_4 = (-r1_w_3 + 1);
                float4 r2_xyzw_3 = mad(((r1_w_4 * cb0_values[8].x)).xxxx, -cb0_values[4].xyzx, cb0_values[4].xyzx);
                float r2_x_3 = r2_xyzw_3.x;
                float r2_y_1 = r2_xyzw_3.y;
                float r2_z_1 = r2_xyzw_3.z;
                float r1_w_5 = mad(r1_w_4, cb0_values[8].y, cb0_values[5].x);
                float r1_w_6 = (r1_w_5 + cb0_values[8].z);
                float r3_x_1 = cb4_values[9].z;
                float r3_y_1 = cb4_values[10].z;
                float r3_z_1 = cb4_values[11].z;
                float r2_w_1 = dot(viewDir_xyz_1.xyzx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float3 r3_xyz_2 = ((i.texcoord1.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = mad(cb3_values[25].w, (-r2_w_1 + sqrt(dot(r3_xyz_2.xyzx, r3_xyz_2.xyzx))), r2_w_1);
                float r2_w_3 = mad(r2_w_2, cb3_values[24].z, cb3_values[24].w);
                float r3_x_13;
                float r3_y_13;
                float r3_z_12;
                float r3_w_8;
                if ((cb6_values[0].x == 1))
                {
                    float4 r3_xyzw_4 = (i.texcoord1.yyyy * cb6_values[2].xxyz);
                    float r3_y_4 = r3_xyzw_4.y;
                    float r3_z_4 = r3_xyzw_4.z;
                    float r3_w_2 = r3_xyzw_4.w;
                    float4 r3_xyzw_5 = mad(cb6_values[1].xxyz, i.texcoord1.xxxx, float4(r3_y_4, r3_y_4, r3_z_4, r3_w_2));
                    float r3_y_5 = r3_xyzw_5.y;
                    float r3_z_5 = r3_xyzw_5.z;
                    float r3_w_3 = r3_xyzw_5.w;
                    float4 r3_xyzw_6 = mad(cb6_values[3].xxyz, i.texcoord1.zzzz, float4(r3_y_5, r3_y_5, r3_z_5, r3_w_3));
                    float r3_y_6 = r3_xyzw_6.y;
                    float r3_z_6 = r3_xyzw_6.z;
                    float r3_w_4 = r3_xyzw_6.w;
                    float4 r3_xyzw_7 = (float4(r3_y_6, r3_y_6, r3_z_6, r3_w_4) + cb6_values[4].xxyz);
                    float r3_y_7 = r3_xyzw_7.y;
                    float r3_z_7 = r3_xyzw_7.z;
                    float r3_w_5 = r3_xyzw_7.w;
                    float4 r3_xyzw_9 = (((cb6_values[0].y == 1)).xxxx ? float4(r3_y_7, r3_z_7, r3_w_5, r3_y_7) : i.texcoord1.xyzx);
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
                    float4 r3_xyzw_12 = t1.Sample(s0, float4(r3_x_11, r3_z_10, r3_w_6, r3_x_11));
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
                float4 r3_xyzw_14 = (i.texcoord3.xxyx / i.texcoord3.wwww);
                float r3_y_14 = r3_xyzw_14.y;
                float r3_z_13 = r3_xyzw_14.z;
                float4 r4_xyzw_3 = t0.Sample(s1, float4(r3_y_14, r3_z_13, r3_y_14, r3_y_14));
                float r2_w_4 = mad(r2_w_3, (dot(float4(r3_x_13, r3_y_13, r3_z_12, r3_w_8), unity_OcclusionMaskSelector) + -r4_xyzw_3.x), r4_xyzw_3.x);
                float4 r3_xyzw_16 = (r2_w_4.xxxx * _LightColor0.xyzx);
                float r3_x_16 = r3_xyzw_16.x;
                float r3_y_15 = r3_xyzw_16.y;
                float r3_z_14 = r3_xyzw_16.z;
                float r2_w_5 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r2_w_6 = rsqrt(r2_w_5);
                float4 unitWorldNormal_xyzw_4 = (r2_w_6.xxxx * i.texcoord0.xyzx);
                float unitWorldNormal_x_4 = unitWorldNormal_xyzw_4.x;
                float unitWorldNormal_y_2 = unitWorldNormal_xyzw_4.y;
                float unitWorldNormal_z_2 = unitWorldNormal_xyzw_4.z;
                float4 r2_xyzw_4 = (float4(r2_x_3, r2_y_1, r2_z_1, r2_x_3) * float4(0.7790837, 0.7790837, 0.7790837, 0));
                float r2_x_4 = r2_xyzw_4.x;
                float r2_y_2 = r2_xyzw_4.y;
                float r2_z_2 = r2_xyzw_4.z;
                float r1_w_7 = (-r1_w_6 + 1);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(float4(unitWorldNormal_x_4, unitWorldNormal_y_2, unitWorldNormal_z_2, unitWorldNormal_x_4), unitViewDir_xyz_1.xyzx);
                float r1_x_2 = dot(float4(unitWorldNormal_x_4, unitWorldNormal_y_2, unitWorldNormal_z_2, unitWorldNormal_x_4), _WorldSpaceLightPos0.xyzx);
                float r1_y_2 = dot(float4(unitWorldNormal_x_4, unitWorldNormal_y_2, unitWorldNormal_z_2, unitWorldNormal_x_4), r0_xyz_3.xyzx);
                float r0_x_4 = dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_7.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(nDotV_w_6) + 1);
                float r2_w_7 = (r1_z_4 * r1_z_4);
                float r2_w_8 = (r2_w_7 * r2_w_7);
                float r1_z_5 = (r1_z_4 * r2_w_8);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_7 * r1_w_7);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_z_6 = (-r0_z_8 + 1);
                float r1_w_8 = mad(abs(nDotV_w_6), r1_z_6, r0_z_8);
                float r1_z_7 = mad(r1_x_2, r1_z_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * r1_z_7);
                float r0_w_8 = mad(r1_x_2, r1_w_8, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_z_8 = mad(r1_y_2, r0_z_9, -r1_y_2);
                float r1_y_3 = mad(r1_z_8, r1_y_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r0_z_11 = (r0_z_10 / r1_y_4);
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float r0_z_14 = max(r0_z_13, 0.0001);
                float r0_z_15 = sqrt(r0_z_14);
                float4 r0_xyzw_9 = (r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_z_15, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_16 = r0_xyzw_9.z;
                float4 r1_xyzw_3 = (r0_y_9.xxxx * float4(r3_x_16, r3_y_15, r3_z_14, r3_x_16));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_5 = r1_xyzw_3.y;
                float r1_z_9 = r1_xyzw_3.z;
                float4 r0_xyzw_10 = (float4(r3_x_16, r3_x_16, r3_y_15, r3_z_14) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_11 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_9 = (r0_x_5 * r0_x_5);
                float r1_w_10 = (r1_w_9 * r1_w_9);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r1_w_10), 0.7790837, 0.2209163)).xxxx * float4(r0_y_10, r0_z_17, r0_w_11, r0_y_10));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_11 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                float r0_x_9 = (mad(float4(r2_x_4, r2_y_2, r2_z_2, r2_x_4), float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8))).x;
                float4 r0_xyzw_12 = mad(float4(r2_x_4, r2_y_2, r2_z_2, r2_x_4), float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8));
                float r0_y_12 = r0_xyzw_12.y;
                float r0_z_19 = r0_xyzw_12.z;
                float r0_w_12 = (i.texcoord4.x / cb1_values[5].y);
                float r0_w_13 = (-r0_w_12 + 1);
                float r0_w_14 = (r0_w_13 * cb1_values[5].z);
                float r0_w_15 = max(r0_w_14, 0);
                float r0_w_16 = mad(r0_w_15, cb5_values[1].z, cb5_values[1].w);
                o.sv_Target0.xyz = ((float4(r0_x_9, r0_y_12, r0_z_19, r0_x_9) * r0_w_16.xxxx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[19];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerComparisonState s1 : register(s1);
            SamplerState s2 : register(s2);
            SamplerState s3 : register(s3);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture3D t2 : register(t2);
            Texture2D t3 : register(t3);
            struct program60Input
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
            struct program60Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program106Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program106Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program60Output vert(program60Input i)
            {
                program60Output o = (program60Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                o.texcoord4.x = clipPos_xyzw_2.z;
                float worldNormal_x_3 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord0.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 r1_xyzw_4 = (r0_xyzw_4.yyyy * cb0_values[10].xyzw);
                float4 r1_xyzw_5 = mad(cb0_values[9].xyzw, r0_xyzw_4.xxxx, r1_xyzw_4);
                float4 r1_xyzw_6 = mad(cb0_values[11].xyzw, r0_xyzw_4.zzzz, r1_xyzw_5);
                o.texcoord2.xyzw = mad(cb0_values[12].xyzw, r0_xyzw_4.wwww, r1_xyzw_6);
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program106Output frag(program106Input i)
            {
                program106Output o = (program106Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r1_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r1_w_2 = rsqrt(r1_w_1);
                float3 unitViewDir_xyz_1 = ((r1_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_3 = log2(cb0_values[15].x);
                float r1_w_4 = (r1_w_3 * cb0_values[18].x);
                float r1_w_5 = exp2(r1_w_4);
                float r1_w_6 = (-r1_w_5 + 1);
                float r2_w_1 = (r1_w_6 * cb0_values[17].x);
                float r2_w_2 = r2_w_1;
                float r1_w_7 = mad(r1_w_6, cb0_values[17].y, cb0_values[14].x);
                float r1_w_8 = (r1_w_7 + cb0_values[17].z);
                float4 r5_xyzw_4 = (mad(cb0_values[11].xyzw, i.texcoord1.zzzz, mad(cb0_values[9].xyzw, i.texcoord1.xxxx, (i.texcoord1.yyyy * cb0_values[10].xyzw))) + cb0_values[12].xyzw);
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r2_x_2 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float4 r2_xyzw_2 = (i.texcoord1.xxyz + -cb3_values[25].xxyz);
                float r2_y_2 = r2_xyzw_2.y;
                float r2_z_2 = r2_xyzw_2.z;
                float r2_w_3 = r2_xyzw_2.w;
                float r2_y_3 = dot(float4(r2_y_2, r2_z_2, r2_w_3, r2_y_2), float4(r2_y_2, r2_z_2, r2_w_3, r2_y_2));
                float r2_y_4 = sqrt(r2_y_3);
                float r2_y_5 = (-r2_x_2 + r2_y_4);
                float r2_x_4 = mad(mad(cb3_values[25].w, r2_y_5, r2_x_2), cb3_values[24].z, cb3_values[24].w);
                float r2_y_6 = (cb6_values[0].x == 1);
                float r6_x_9;
                float r6_y_9;
                float r6_z_9;
                float r6_w_4;
                if (r2_y_6)
                {
                    float r2_y_7 = (cb6_values[0].y == 1);
                    float3 r6_xyz_6 = (((mad(cb6_values[3].xyzx, i.texcoord1.zzzz, (mad(cb6_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (r2_y_7.xxxx ? r6_xyz_6.xxyz : i.texcoord1.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float r2_w_4 = r2_xyzw_8.w;
                    float4 r2_xyzw_9 = (float4(r2_y_8, r2_y_8, r2_z_3, r2_w_4) + -cb6_values[6].xxyz);
                    float r2_y_9 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float r2_w_5 = r2_xyzw_9.w;
                    float4 r6_xyzw_7 = (float4(r2_y_9, r2_y_9, r2_z_4, r2_w_5) * cb6_values[5].xxyz);
                    float r6_y_7 = r6_xyzw_7.y;
                    float r6_z_7 = r6_xyzw_7.z;
                    float r6_w_2 = r6_xyzw_7.w;
                    float r2_y_10 = mad(r6_y_7, 0.25, 0.75);
                    float r2_z_5 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r6_x_7 = max(r2_z_5, r2_y_10);
                    float4 r6_xyzw_8 = t2.Sample(s0, float4(r6_x_7, r6_z_7, r6_w_2, r6_x_7));
                    r6_x_9 = r6_xyzw_8.x;
                    r6_y_9 = r6_xyzw_8.y;
                    r6_z_9 = r6_xyzw_8.z;
                    r6_w_4 = r6_xyzw_8.w;
                }
                else
                {
                    float4 r6_xyzw_2 = float4(1, 1, 1, 1);
                    r6_x_9 = r6_xyzw_2.x;
                    r6_y_9 = r6_xyzw_2.y;
                    r6_z_9 = r6_xyzw_2.z;
                    r6_w_4 = r6_xyzw_2.w;
                }
                float r2_y_12 = dot(float4(r6_x_9, r6_y_9, r6_z_9, r6_w_4), unity_OcclusionMaskSelector);
                float r2_z_7 = (r2_x_4 < 0.99);
                float r2_z_15;
                if (r2_z_7)
                {
                    float4 r6_xyzw_10 = (i.texcoord1.yyyy * cb3_values[9].xyzw);
                    float4 r6_xyzw_11 = mad(cb3_values[8].xyzw, i.texcoord1.xxxx, r6_xyzw_10);
                    float4 r6_xyzw_12 = mad(cb3_values[10].xyzw, i.texcoord1.zzzz, r6_xyzw_11);
                    float4 r6_xyzw_13 = (r6_xyzw_12 + cb3_values[11].xyzw);
                    float3 r6_xyz_14 = ((r6_xyzw_13.xyzx / r6_xyzw_13.wwww)).xyz;
                    float r2_z_9 = (mad(r6_xyz_14.xxxy, cb0_values[8].zzzw, float4(0, 0, 0.5, 0.5))).z;
                    float r2_w_7 = (mad(r6_xyz_14.xxxy, cb0_values[8].zzzw, float4(0, 0, 0.5, 0.5))).w;
                    float4 r2_xyzw_10 = floor(float4(r2_z_9, r2_z_9, r2_z_9, r2_w_7));
                    float r2_z_10 = r2_xyzw_10.z;
                    float r2_w_8 = r2_xyzw_10.w;
                    float2 r6_xy_15 = (mad(r6_xyz_14.xyxx, cb0_values[8].zwzz, -float4(r2_z_10, r2_w_8, r2_z_10, r2_z_10))).xy;
                    float4 r7_xyzw_1 = (r6_xy_15.xxyy + float4(0.5, 1, 0.5, 1));
                    float2 r8_xw_1 = ((r7_xyzw_1.xxxz * r7_xyzw_1.xxxz)).xw;
                    float2 r7_xz_2 = (mad(r8_xw_1.xxyx, float4(0.5, 0, 0.5, 0), -r6_xy_15.xxyx)).xz;
                    float2 r9_zw_1 = (min(r6_xy_15.xxxy, float4(0, 0, 0, 0))).zw;
                    float2 r9_xy_2 = (mad(-r9_zw_1.xyxx, r9_zw_1.xyxx, ((-r6_xy_15.xyxx + float4(1, 1, 0, 0))).xyxx)).xy;
                    float2 r6_xy_16 = (max(r6_xy_15.xyxx, float4(0, 0, 0, 0))).xy;
                    float2 r6_xy_17 = (mad(-r6_xy_16.xyxx, r6_xy_16.xyxx, r7_xyzw_1.ywyy)).xy;
                    float r10_x_1 = r7_xz_2.x;
                    float r10_y_1 = r9_xy_2.x;
                    float r10_z_1 = r6_xy_17.x;
                    float r10_w_1 = r8_xw_1.x;
                    float4 r10_xyzw_2 = (float4(r10_x_1, r10_y_1, r10_z_1, r10_w_1) * float4(0.44444, 0.44444, 0.44444, 0.22222));
                    float r8_x_2 = r7_xz_2.y;
                    float r8_y_1 = r9_xy_2.y;
                    float r8_z_1 = r6_xy_17.y;
                    float4 r7_xyzw_3 = (float4(r8_x_2, r8_y_1, r8_z_1, r8_xw_1.y) * float4(0.44444, 0.44444, 0.44444, 0.22222));
                    float4 r8_xyzw_3 = (r10_xyzw_2.ywyw + r10_xyzw_2.xzxz);
                    float4 r9_xyzw_3 = (r7_xyzw_3.yyww + r7_xyzw_3.xxzz);
                    float4 r7_xyzw_4 = (r7_xyzw_3.ywyy / r9_xyzw_3.ywyy);
                    float r7_x_4 = r7_xyzw_4.x;
                    float r7_y_3 = r7_xyzw_4.y;
                    float4 r7_xyzw_5 = (float4(r7_x_4, r7_y_3, r7_x_4, r7_x_4) + float4(-1.5, 0.5, 0, 0));
                    float r7_x_5 = r7_xyzw_5.x;
                    float r7_y_4 = r7_xyzw_5.y;
                    float2 r10_xy_3 = ((((((r10_xyzw_2.ywyy / r8_xyzw_3.zwzz)).xyxx + float4(-1.5, 0.5, 0, 0))).xyxx * cb0_values[8].xxxx)).xy;
                    float2 r10_zw_3 = ((float4(r7_x_5, r7_x_5, r7_x_5, r7_y_4) * cb0_values[8].yyyy)).zw;
                    float4 r7_xyzw_6 = (r8_xyzw_3 * r9_xyzw_3);
                    float4 r8_xyzw_4 = mad(float4(r2_z_10, r2_w_8, r2_z_10, r2_w_8), cb0_values[8].xyxy, float4(r10_xy_3.x, r10_zw_3.x, r10_xy_3.y, r10_zw_3.x));
                    float r3_w_1 = t3.SampleCmpLevelZero(s1, (r8_xyzw_4.xyxx).xy, r6_xyz_14.z);
                    float r4_w_1 = t3.SampleCmpLevelZero(s1, (r8_xyzw_4.zwzz).xy, r6_xyz_14.z);
                    float r4_w_2 = (r4_w_1 * r7_xyzw_6.y);
                    float r3_w_2 = mad(r7_xyzw_6.x, r3_w_1, r4_w_2);
                    float4 r8_xyzw_5 = mad(float4(r2_z_10, r2_w_8, r2_z_10, r2_w_8), cb0_values[8].xyxy, float4(r10_xy_3.x, r10_zw_3.y, r10_xy_3.y, r10_zw_3.y));
                    float r2_z_11 = t3.SampleCmpLevelZero(s1, (r8_xyzw_5.xyxx).xy, r6_xyz_14.z);
                    float r2_z_12 = mad(r7_xyzw_6.z, r2_z_11, r3_w_2);
                    float r2_w_9 = t3.SampleCmpLevelZero(s1, (r8_xyzw_5.zwzz).xy, r6_xyz_14.z);
                    float r2_z_13 = mad(r7_xyzw_6.w, r2_w_9, r2_z_12);
                    float r2_w_10 = (-cb3_values[24].x + 1);
                    float r2_z_14 = mad(r2_z_13, r2_w_10, cb3_values[24].x);
                    r2_z_15 = r2_z_14;
                }
                else
                {
                    float r2_z_8 = 1;
                    r2_z_15 = r2_z_8;
                }
                float r2_y_13 = (-r2_z_15 + r2_y_12);
                float r2_y_14 = (0 < r5_xyzw_4.z);
                float r2_y_15 = asfloat(asint(r2_y_14) & asint(1065353216));
                float4 r2_xyzw_16 = (r5_xyzw_4.xxxy / r5_xyzw_4.wwww);
                float r2_z_16 = r2_xyzw_16.z;
                float r2_w_12 = r2_xyzw_16.w;
                float4 r2_xyzw_17 = (float4(r2_z_16, r2_z_16, r2_z_16, r2_w_12) + float4(0, 0, 0.5, 0.5));
                float r2_z_17 = r2_xyzw_17.z;
                float r2_w_13 = r2_xyzw_17.w;
                float4 r6_xyzw_21 = t0.Sample(s2, float4(r2_z_17, r2_w_13, r2_z_17, r2_z_17));
                float r2_y_16 = (r2_y_15 * r6_xyzw_21.w);
                float r2_z_18 = dot(r5_xyzw_4.xyzx, r5_xyzw_4.xyzx);
                float4 r5_xyzw_5 = t1.Sample(s3, r2_z_18.xxxx);
                float r2_y_17 = (r2_y_16 * r5_xyzw_5.x);
                float4 r2_xyzw_7 = (((mad(r2_x_4, r2_y_13, r2_z_15) * r2_y_17)).xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_18 = r2_xyzw_7.y;
                float r2_z_19 = r2_xyzw_7.z;
                float r2_w_14 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r2_w_15 = rsqrt(r2_w_14);
                float3 unitClipPos_xyz_6 = ((r2_w_15.xxxx * i.texcoord0.xyzx)).xyz;
                float r1_w_9 = (-r1_w_8 + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitClipPos_xyz_6.xyzx, unitViewDir_xyz_1.xyzx);
                float r2_w_16 = dot(unitClipPos_xyz_6.xyzx, r1_xyz_1.xyzx);
                float r3_x_2 = dot(unitClipPos_xyz_6.xyzx, r0_xyz_3.xyzx);
                float r0_x_4 = dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_9.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_16 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(nDotV_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_9 * r1_w_9);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(nDotV_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * mad(r2_w_16, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_16, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r3_x_2, r0_z_9, -r3_x_2), r3_x_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float r0_z_14 = max(r0_z_13, 0.0001);
                float r0_z_15 = sqrt(r0_z_14);
                float4 r0_xyzw_9 = (r2_w_16.xxxx * float4(r0_y_8, r0_y_8, r0_z_15, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_16 = r0_xyzw_9.z;
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r2_x_7, r2_y_18, r2_z_19, r2_x_7));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r2_x_7, r2_x_7, r2_y_18, r2_z_19) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_11 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_10 = (r0_x_5 * r0_x_5);
                float r1_w_11 = (r1_w_10 * r1_w_10);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r1_w_11), 0.7790837, 0.2209163)).xxxx * float4(r0_y_10, r0_z_17, r0_w_11, r0_y_10));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_11 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                float r0_x_9 = (mad((((mad(r2_w_2.xxxx, -cb0_values[13].xyzx, cb0_values[13].xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8))).x;
                float4 r0_xyzw_12 = mad((((mad(r2_w_2.xxxx, -cb0_values[13].xyzx, cb0_values[13].xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8));
                float r0_y_12 = r0_xyzw_12.y;
                float r0_z_19 = r0_xyzw_12.z;
                float r0_w_12 = (i.texcoord4.x / cb1_values[5].y);
                float r0_w_13 = (-r0_w_12 + 1);
                float r0_w_14 = (r0_w_13 * cb1_values[5].z);
                float r0_w_15 = max(r0_w_14, 0);
                float r0_w_16 = mad(r0_w_15, cb5_values[1].z, cb5_values[1].w);
                o.sv_Target0.xyz = ((float4(r0_x_9, r0_y_12, r0_z_19, r0_x_9) * r0_w_16.xxxx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[14];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerComparisonState s1 : register(s1);
            SamplerState s2 : register(s2);
            SamplerState s3 : register(s3);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture3D t2 : register(t2);
            Texture2D t3 : register(t3);
            struct program59Input
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
            struct program59Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program105Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program105Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program59Output vert(program59Input i)
            {
                program59Output o = (program59Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                o.texcoord4.x = clipPos_xyzw_2.z;
                float worldNormal_x_3 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord0.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 r1_xyzw_4 = (r0_xyzw_4.yyyy * unity_WorldToObject[1]);
                float4 r1_xyzw_5 = mad(unity_WorldToObject[0], r0_xyzw_4.xxxx, r1_xyzw_4);
                float4 r1_xyzw_6 = mad(unity_WorldToObject[2], r0_xyzw_4.zzzz, r1_xyzw_5);
                o.texcoord2.xyzw = mad(unity_WorldToObject[3], r0_xyzw_4.wwww, r1_xyzw_6);
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program105Output frag(program105Input i)
            {
                program105Output o = (program105Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r1_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r1_w_2 = rsqrt(r1_w_1);
                float3 unitViewDir_xyz_1 = ((r1_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_3 = log2(cb0_values[10].x);
                float r1_w_4 = (r1_w_3 * cb0_values[13].x);
                float r1_w_5 = exp2(r1_w_4);
                float r1_w_6 = (-r1_w_5 + 1);
                float r2_w_1 = (r1_w_6 * cb0_values[12].x);
                float r2_w_2 = r2_w_1;
                float r1_w_7 = mad(r1_w_6, cb0_values[12].y, cb0_values[9].x);
                float r1_w_8 = (r1_w_7 + cb0_values[12].z);
                float4 r5_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord1.zzzz, mad(cb0_values[4].xyzw, i.texcoord1.xxxx, (i.texcoord1.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r2_x_2 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float4 r2_xyzw_2 = (i.texcoord1.xxyz + -cb3_values[25].xxyz);
                float r2_y_2 = r2_xyzw_2.y;
                float r2_z_2 = r2_xyzw_2.z;
                float r2_w_3 = r2_xyzw_2.w;
                float r2_y_3 = dot(float4(r2_y_2, r2_z_2, r2_w_3, r2_y_2), float4(r2_y_2, r2_z_2, r2_w_3, r2_y_2));
                float r2_y_4 = sqrt(r2_y_3);
                float r2_y_5 = (-r2_x_2 + r2_y_4);
                float r2_y_6 = (cb6_values[0].x == 1);
                float r6_x_9;
                float r6_y_9;
                float r6_z_9;
                float r6_w_4;
                if (r2_y_6)
                {
                    float r2_y_7 = (cb6_values[0].y == 1);
                    float3 r6_xyz_6 = (((mad(cb6_values[3].xyzx, i.texcoord1.zzzz, (mad(cb6_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (r2_y_7.xxxx ? r6_xyz_6.xxyz : i.texcoord1.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float r2_w_4 = r2_xyzw_8.w;
                    float4 r2_xyzw_9 = (float4(r2_y_8, r2_y_8, r2_z_3, r2_w_4) + -cb6_values[6].xxyz);
                    float r2_y_9 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float r2_w_5 = r2_xyzw_9.w;
                    float4 r6_xyzw_7 = (float4(r2_y_9, r2_y_9, r2_z_4, r2_w_5) * cb6_values[5].xxyz);
                    float r6_y_7 = r6_xyzw_7.y;
                    float r6_z_7 = r6_xyzw_7.z;
                    float r6_w_2 = r6_xyzw_7.w;
                    float r2_y_10 = mad(r6_y_7, 0.25, 0.75);
                    float r2_z_5 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r6_x_7 = max(r2_z_5, r2_y_10);
                    float4 r6_xyzw_8 = t2.Sample(s0, float4(r6_x_7, r6_z_7, r6_w_2, r6_x_7));
                    r6_x_9 = r6_xyzw_8.x;
                    r6_y_9 = r6_xyzw_8.y;
                    r6_z_9 = r6_xyzw_8.z;
                    r6_w_4 = r6_xyzw_8.w;
                }
                else
                {
                    float4 r6_xyzw_2 = float4(1, 1, 1, 1);
                    r6_x_9 = r6_xyzw_2.x;
                    r6_y_9 = r6_xyzw_2.y;
                    r6_z_9 = r6_xyzw_2.z;
                    r6_w_4 = r6_xyzw_2.w;
                }
                float r2_y_12 = dot(float4(r6_x_9, r6_y_9, r6_z_9, r6_w_4), unity_OcclusionMaskSelector);
                float4 r6_xyzw_10 = (i.texcoord1.yyyy * cb3_values[9].xyzw);
                float4 r6_xyzw_11 = mad(cb3_values[8].xyzw, i.texcoord1.xxxx, r6_xyzw_10);
                float4 r6_xyzw_12 = mad(cb3_values[10].xyzw, i.texcoord1.zzzz, r6_xyzw_11);
                float4 r6_xyzw_13 = (r6_xyzw_12 + cb3_values[11].xyzw);
                float3 r6_xyz_14 = ((r6_xyzw_13.xyzx / r6_xyzw_13.wwww)).xyz;
                float r2_z_7 = t3.SampleCmpLevelZero(s1, (r6_xyz_14.xyxx).xy, r6_xyz_14.z);
                float r2_w_7 = (-cb3_values[24].x + 1);
                float r2_z_8 = mad(r2_z_7, r2_w_7, cb3_values[24].x);
                float r2_y_13 = (-r2_z_8 + r2_y_12);
                float r2_y_14 = (0 < r5_xyzw_4.z);
                float r2_y_15 = asfloat(asint(r2_y_14) & asint(1065353216));
                float r2_z_9 = ((r5_xyzw_4.xxxy / r5_xyzw_4.wwww)).z;
                float r2_w_8 = ((r5_xyzw_4.xxxy / r5_xyzw_4.wwww)).w;
                float4 r2_xyzw_10 = (float4(r2_z_9, r2_z_9, r2_z_9, r2_w_8) + float4(0, 0, 0.5, 0.5));
                float r2_z_10 = r2_xyzw_10.z;
                float r2_w_9 = r2_xyzw_10.w;
                float4 r6_xyzw_15 = t0.Sample(s2, float4(r2_z_10, r2_w_9, r2_z_10, r2_z_10));
                float r2_y_16 = (r2_y_15 * r6_xyzw_15.w);
                float r2_z_11 = dot(r5_xyzw_4.xyzx, r5_xyzw_4.xyzx);
                float4 r5_xyzw_5 = t1.Sample(s3, r2_z_11.xxxx);
                float r2_y_17 = (r2_y_16 * r5_xyzw_5.x);
                float4 r2_xyzw_7 = (((mad(mad(mad(cb3_values[25].w, r2_y_5, r2_x_2), cb3_values[24].z, cb3_values[24].w), r2_y_13, r2_z_8) * r2_y_17)).xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_18 = r2_xyzw_7.y;
                float r2_z_12 = r2_xyzw_7.z;
                float r2_w_10 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r2_w_11 = rsqrt(r2_w_10);
                float3 unitClipPos_xyz_6 = ((r2_w_11.xxxx * i.texcoord0.xyzx)).xyz;
                float r1_w_9 = (-r1_w_8 + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitClipPos_xyz_6.xyzx, unitViewDir_xyz_1.xyzx);
                float r2_w_12 = dot(unitClipPos_xyz_6.xyzx, r1_xyz_1.xyzx);
                float r3_x_2 = dot(unitClipPos_xyz_6.xyzx, r0_xyz_3.xyzx);
                float r0_x_4 = dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_9.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_12 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(nDotV_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_9 * r1_w_9);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(nDotV_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * mad(r2_w_12, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_12, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r3_x_2, r0_z_9, -r3_x_2), r3_x_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float r0_z_14 = max(r0_z_13, 0.0001);
                float r0_z_15 = sqrt(r0_z_14);
                float4 r0_xyzw_9 = (r2_w_12.xxxx * float4(r0_y_8, r0_y_8, r0_z_15, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_16 = r0_xyzw_9.z;
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r2_x_7, r2_y_18, r2_z_12, r2_x_7));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r2_x_7, r2_x_7, r2_y_18, r2_z_12) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_11 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_10 = (r0_x_5 * r0_x_5);
                float r1_w_11 = (r1_w_10 * r1_w_10);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r1_w_11), 0.7790837, 0.2209163)).xxxx * float4(r0_y_10, r0_z_17, r0_w_11, r0_y_10));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_11 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                float r0_x_9 = (mad((((mad(r2_w_2.xxxx, -cb0_values[8].xyzx, cb0_values[8].xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8))).x;
                float4 r0_xyzw_12 = mad((((mad(r2_w_2.xxxx, -cb0_values[8].xyzx, cb0_values[8].xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8));
                float r0_y_12 = r0_xyzw_12.y;
                float r0_z_19 = r0_xyzw_12.z;
                float r0_w_12 = (i.texcoord4.x / cb1_values[5].y);
                float r0_w_13 = (-r0_w_12 + 1);
                float r0_w_14 = (r0_w_13 * cb1_values[5].z);
                float r0_w_15 = max(r0_w_14, 0);
                float r0_w_16 = mad(r0_w_15, cb5_values[1].z, cb5_values[1].w);
                o.sv_Target0.xyz = ((float4(r0_x_9, r0_y_12, r0_z_19, r0_x_9) * r0_w_16.xxxx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[14];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb3_values[2];
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[7];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
            struct program58Input
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
            struct program58Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float texcoord4 : TEXCOORD4;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program104Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float texcoord4 : TEXCOORD4;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program104Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program58Output vert(program58Input i)
            {
                program58Output o = (program58Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                o.texcoord4.x = clipPos_xyzw_2.z;
                float worldNormal_x_3 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord0.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xy = (mad(unity_WorldToObject[3].xyxx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyxx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyxx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyxx)).xyxx)).xyxx)).xyxx)).xy;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program104Output frag(program104Input i)
            {
                program104Output o = (program104Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_1 = log2(cb0_values[10].x);
                float r1_w_2 = (r1_w_1 * cb0_values[13].x);
                float r1_w_3 = exp2(r1_w_2);
                float r1_w_4 = (-r1_w_3 + 1);
                float4 r2_xyzw_3 = mad(((r1_w_4 * cb0_values[12].x)).xxxx, -cb0_values[8].xyzx, cb0_values[8].xyzx);
                float r2_x_3 = r2_xyzw_3.x;
                float r2_y_1 = r2_xyzw_3.y;
                float r2_z_1 = r2_xyzw_3.z;
                float r1_w_5 = mad(r1_w_4, cb0_values[12].y, cb0_values[9].x);
                float r1_w_6 = (r1_w_5 + cb0_values[12].z);
                float r2_w_1 = (cb4_values[0].x == 1);
                float r4_x_10;
                float r4_y_10;
                float r4_z_10;
                float r4_w_4;
                if (r2_w_1)
                {
                    float r2_w_2 = (cb4_values[0].y == 1);
                    float3 r4_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord1.zzzz, (mad(cb4_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r4_xyzw_8 = (((((r2_w_2.xxxx ? r4_xyz_5.xyzx : i.texcoord1.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r4_y_8 = r4_xyzw_8.y;
                    float r4_z_8 = r4_xyzw_8.z;
                    float r4_w_2 = r4_xyzw_8.w;
                    float r2_w_3 = mad(r4_y_8, 0.25, 0.75);
                    float r3_z_1 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r4_x_8 = max(r2_w_3, r3_z_1);
                    float4 r4_xyzw_9 = t1.Sample(s0, float4(r4_x_8, r4_z_8, r4_w_2, r4_x_8));
                    r4_x_10 = r4_xyzw_9.x;
                    r4_y_10 = r4_xyzw_9.y;
                    r4_z_10 = r4_xyzw_9.z;
                    r4_w_4 = r4_xyzw_9.w;
                }
                else
                {
                    float4 r4_xyzw_10 = float4(1, 1, 1, 1);
                    r4_x_10 = r4_xyzw_10.x;
                    r4_y_10 = r4_xyzw_10.y;
                    r4_z_10 = r4_xyzw_10.z;
                    r4_w_4 = r4_xyzw_10.w;
                }
                float r2_w_5 = dot(float4(r4_x_10, r4_y_10, r4_z_10, r4_w_4), unity_OcclusionMaskSelector);
                float4 r3_xyzw_5 = t0.Sample(s1, (((mad(cb0_values[6].xyxx, i.texcoord1.zzzz, (mad(cb0_values[4].xyxx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx);
                float r2_w_6 = (r2_w_5 * r3_xyzw_5.w);
                float4 r3_xyzw_6 = (r2_w_6.xxxx * _LightColor0.xyzx);
                float r3_x_6 = r3_xyzw_6.x;
                float r3_y_6 = r3_xyzw_6.y;
                float r3_z_4 = r3_xyzw_6.z;
                float r2_w_7 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r2_w_8 = rsqrt(r2_w_7);
                float3 unitWorldNormal_xyz_11 = ((r2_w_8.xxxx * i.texcoord0.xyzx)).xyz;
                float4 r2_xyzw_4 = (float4(r2_x_3, r2_y_1, r2_z_1, r2_x_3) * float4(0.7790837, 0.7790837, 0.7790837, 0));
                float r2_x_4 = r2_xyzw_4.x;
                float r2_y_2 = r2_xyzw_4.y;
                float r2_z_2 = r2_xyzw_4.z;
                float r1_w_7 = (-r1_w_6 + 1);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitWorldNormal_xyz_11.xyzx, unitViewDir_xyz_1.xyzx);
                float r1_x_2 = dot(unitWorldNormal_xyz_11.xyzx, _WorldSpaceLightPos0.xyzx);
                float r1_y_2 = dot(unitWorldNormal_xyz_11.xyzx, r0_xyz_3.xyzx);
                float r0_x_4 = dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_7.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(nDotV_w_6) + 1);
                float r2_w_9 = (r1_z_4 * r1_z_4);
                float r2_w_10 = (r2_w_9 * r2_w_9);
                float r1_z_5 = (r1_z_4 * r2_w_10);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_7 * r1_w_7);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_z_6 = (-r0_z_8 + 1);
                float r1_w_8 = mad(abs(nDotV_w_6), r1_z_6, r0_z_8);
                float r1_z_7 = mad(r1_x_2, r1_z_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * r1_z_7);
                float r0_w_8 = mad(r1_x_2, r1_w_8, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_z_8 = mad(r1_y_2, r0_z_9, -r1_y_2);
                float r1_y_3 = mad(r1_z_8, r1_y_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r0_z_11 = (r0_z_10 / r1_y_4);
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float r0_z_14 = max(r0_z_13, 0.0001);
                float r0_z_15 = sqrt(r0_z_14);
                float4 r0_xyzw_9 = (r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_z_15, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_16 = r0_xyzw_9.z;
                float4 r1_xyzw_3 = (r0_y_9.xxxx * float4(r3_x_6, r3_y_6, r3_z_4, r3_x_6));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_5 = r1_xyzw_3.y;
                float r1_z_9 = r1_xyzw_3.z;
                float4 r0_xyzw_10 = (float4(r3_x_6, r3_x_6, r3_y_6, r3_z_4) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_11 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_9 = (r0_x_5 * r0_x_5);
                float r1_w_10 = (r1_w_9 * r1_w_9);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r1_w_10), 0.7790837, 0.2209163)).xxxx * float4(r0_y_10, r0_z_17, r0_w_11, r0_y_10));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_11 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                float r0_x_9 = (mad(float4(r2_x_4, r2_y_2, r2_z_2, r2_x_4), float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8))).x;
                float4 r0_xyzw_12 = mad(float4(r2_x_4, r2_y_2, r2_z_2, r2_x_4), float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8));
                float r0_y_12 = r0_xyzw_12.y;
                float r0_z_19 = r0_xyzw_12.z;
                float r0_w_12 = (i.texcoord4.x / cb1_values[5].y);
                float r0_w_13 = (-r0_w_12 + 1);
                float r0_w_14 = (r0_w_13 * cb1_values[5].z);
                float r0_w_15 = max(r0_w_14, 0);
                float r0_w_16 = mad(r0_w_15, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w);
                o.sv_Target0.xyz = ((float4(r0_x_9, r0_y_12, r0_z_19, r0_x_9) * r0_w_16.xxxx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[14];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb3_values[2];
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[7];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            TextureCube t1 : register(t1);
            Texture3D t2 : register(t2);
            struct program57Input
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
            struct program57Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program103Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program103Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program57Output vert(program57Input i)
            {
                program57Output o = (program57Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                o.texcoord4.x = clipPos_xyzw_2.z;
                float worldNormal_x_3 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord0.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = (mad(unity_WorldToObject[3].xyzx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyzx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program103Output frag(program103Input i)
            {
                program103Output o = (program103Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r1_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r1_w_2 = rsqrt(r1_w_1);
                float3 unitViewDir_xyz_2 = ((r1_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_3 = log2(cb0_values[10].x);
                float r1_w_4 = (r1_w_3 * cb0_values[13].x);
                float r1_w_5 = exp2(r1_w_4);
                float r1_w_6 = (-r1_w_5 + 1);
                float r2_w_1 = (r1_w_6 * cb0_values[12].x);
                float r2_w_2 = r2_w_1;
                float r1_w_7 = mad(r1_w_6, cb0_values[12].y, cb0_values[9].x);
                float r1_w_8 = (r1_w_7 + cb0_values[12].z);
                float3 r4_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord1.zzzz, (mad(cb0_values[4].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r2_w_3 = (cb4_values[0].x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r2_w_3)
                {
                    float r2_w_4 = (cb4_values[0].y == 1);
                    float3 r5_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord1.zzzz, (mad(cb4_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r5_xyzw_8 = (((((r2_w_4.xxxx ? r5_xyz_5.xyzx : i.texcoord1.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r2_w_5 = mad(r5_y_8, 0.25, 0.75);
                    float r3_w_1 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r5_x_8 = max(r2_w_5, r3_w_1);
                    float4 r5_xyzw_9 = t2.Sample(s0, float4(r5_x_8, r5_z_8, r5_w_2, r5_x_8));
                    r5_x_10 = r5_xyzw_9.x;
                    r5_y_10 = r5_xyzw_9.y;
                    r5_z_10 = r5_xyzw_9.z;
                    r5_w_4 = r5_xyzw_9.w;
                }
                else
                {
                    float4 r5_xyzw_10 = float4(1, 1, 1, 1);
                    r5_x_10 = r5_xyzw_10.x;
                    r5_y_10 = r5_xyzw_10.y;
                    r5_z_10 = r5_xyzw_10.z;
                    r5_w_4 = r5_xyzw_10.w;
                }
                float r2_w_7 = dot(float4(r5_x_10, r5_y_10, r5_z_10, r5_w_4), unity_OcclusionMaskSelector);
                float r3_w_3 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float4 r5_xyzw_11 = t0.Sample(s2, r3_w_3.xxxx);
                float4 r4_xyzw_5 = t1.Sample(s1, r4_xyz_4.xyzx);
                float r3_w_4 = (r4_xyzw_5.w * r5_xyzw_11.x);
                float r2_w_8 = (r2_w_7 * r3_w_4);
                float3 r4_xyz_6 = ((r2_w_8.xxxx * _LightColor0.xyzx)).xyz;
                float r2_w_9 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r2_w_10 = rsqrt(r2_w_9);
                float3 unitClipPos_xyz_12 = ((r2_w_10.xxxx * i.texcoord0.xyzx)).xyz;
                float r1_w_9 = (-r1_w_8 + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_2.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitClipPos_xyz_12.xyzx, unitViewDir_xyz_2.xyzx);
                float r2_x_3 = dot(unitClipPos_xyz_12.xyzx, r1_xyz_1.xyzx);
                float r2_y_3 = dot(unitClipPos_xyz_12.xyzx, r0_xyz_3.xyzx);
                float r0_x_4 = dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_9.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_x_3 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(nDotV_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_9 * r1_w_9);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(nDotV_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * mad(r2_x_3, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_x_3, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r2_y_3, r0_z_9, -r2_y_3), r2_y_3, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float r0_z_14 = max(r0_z_13, 0.0001);
                float r0_z_15 = sqrt(r0_z_14);
                float4 r0_xyzw_9 = (r2_x_3.xxxx * float4(r0_y_8, r0_y_8, r0_z_15, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_16 = r0_xyzw_9.z;
                float4 r1_xyzw_11 = (r0_y_9.xxxx * r4_xyz_6.xyzx);
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (r4_xyz_6.xxyz * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_11 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_10 = (r0_x_5 * r0_x_5);
                float r1_w_11 = (r1_w_10 * r1_w_10);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r1_w_11), 0.7790837, 0.2209163)).xxxx * float4(r0_y_10, r0_z_17, r0_w_11, r0_y_10));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_11 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                float r0_x_9 = (mad((((mad(r2_w_2.xxxx, -cb0_values[8].xyzx, cb0_values[8].xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8))).x;
                float4 r0_xyzw_12 = mad((((mad(r2_w_2.xxxx, -cb0_values[8].xyzx, cb0_values[8].xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8));
                float r0_y_12 = r0_xyzw_12.y;
                float r0_z_19 = r0_xyzw_12.z;
                float r0_w_12 = (i.texcoord4.x / cb1_values[5].y);
                float r0_w_13 = (-r0_w_12 + 1);
                float r0_w_14 = (r0_w_13 * cb1_values[5].z);
                float r0_w_15 = max(r0_w_14, 0);
                float r0_w_16 = mad(r0_w_15, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w);
                o.sv_Target0.xyz = ((float4(r0_x_9, r0_y_12, r0_z_19, r0_x_9) * r0_w_16.xxxx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[14];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb3_values[2];
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[7];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture3D t2 : register(t2);
            struct program56Input
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
            struct program56Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program102Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program102Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program56Output vert(program56Input i)
            {
                program56Output o = (program56Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                o.texcoord4.x = clipPos_xyzw_2.z;
                float worldNormal_x_3 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord0.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 r1_xyzw_4 = (r0_xyzw_4.yyyy * unity_WorldToObject[1]);
                float4 r1_xyzw_5 = mad(unity_WorldToObject[0], r0_xyzw_4.xxxx, r1_xyzw_4);
                float4 r1_xyzw_6 = mad(unity_WorldToObject[2], r0_xyzw_4.zzzz, r1_xyzw_5);
                o.texcoord2.xyzw = mad(unity_WorldToObject[3], r0_xyzw_4.wwww, r1_xyzw_6);
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program102Output frag(program102Input i)
            {
                program102Output o = (program102Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r1_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r1_w_2 = rsqrt(r1_w_1);
                float3 unitViewDir_xyz_2 = ((r1_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_3 = log2(cb0_values[10].x);
                float r1_w_4 = (r1_w_3 * cb0_values[13].x);
                float r1_w_5 = exp2(r1_w_4);
                float r1_w_6 = (-r1_w_5 + 1);
                float r2_w_1 = (r1_w_6 * cb0_values[12].x);
                float r2_w_2 = r2_w_1;
                float r1_w_7 = mad(r1_w_6, cb0_values[12].y, cb0_values[9].x);
                float r1_w_8 = (r1_w_7 + cb0_values[12].z);
                float4 r4_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord1.zzzz, mad(cb0_values[4].xyzw, i.texcoord1.xxxx, (i.texcoord1.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r2_w_3 = (cb4_values[0].x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r2_w_3)
                {
                    float r2_w_4 = (cb4_values[0].y == 1);
                    float3 r5_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord1.zzzz, (mad(cb4_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r5_xyzw_8 = (((((r2_w_4.xxxx ? r5_xyz_5.xyzx : i.texcoord1.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r2_w_5 = mad(r5_y_8, 0.25, 0.75);
                    float r3_w_1 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r5_x_8 = max(r2_w_5, r3_w_1);
                    float4 r5_xyzw_9 = t2.Sample(s0, float4(r5_x_8, r5_z_8, r5_w_2, r5_x_8));
                    r5_x_10 = r5_xyzw_9.x;
                    r5_y_10 = r5_xyzw_9.y;
                    r5_z_10 = r5_xyzw_9.z;
                    r5_w_4 = r5_xyzw_9.w;
                }
                else
                {
                    float4 r5_xyzw_10 = float4(1, 1, 1, 1);
                    r5_x_10 = r5_xyzw_10.x;
                    r5_y_10 = r5_xyzw_10.y;
                    r5_z_10 = r5_xyzw_10.z;
                    r5_w_4 = r5_xyzw_10.w;
                }
                float r2_w_7 = dot(float4(r5_x_10, r5_y_10, r5_z_10, r5_w_4), unity_OcclusionMaskSelector);
                float r3_w_3 = (0 < r4_xyzw_4.z);
                float r3_w_4 = asfloat(asint(r3_w_3) & asint(1065353216));
                float4 r5_xyzw_13 = t0.Sample(s1, ((((r4_xyzw_4.xyxx / r4_xyzw_4.wwww)).xyxx + float4(0.5, 0.5, 0, 0))).xyxx);
                float r3_w_5 = (r3_w_4 * r5_xyzw_13.w);
                float4 r4_xyzw_6 = t1.Sample(s2, (dot(r4_xyzw_4.xyzx, r4_xyzw_4.xyzx)).xxxx);
                float r3_w_6 = (r3_w_5 * r4_xyzw_6.x);
                float r2_w_8 = (r2_w_7 * r3_w_6);
                float4 r4_xyzw_7 = (r2_w_8.xxxx * _LightColor0.xyzx);
                float r4_x_7 = r4_xyzw_7.x;
                float r4_y_6 = r4_xyzw_7.y;
                float r4_z_6 = r4_xyzw_7.z;
                float r2_w_9 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r2_w_10 = rsqrt(r2_w_9);
                float4 unitClipPos_xyzw_14 = (r2_w_10.xxxx * i.texcoord0.xyzx);
                float unitClipPos_x_14 = unitClipPos_xyzw_14.x;
                float unitClipPos_y_14 = unitClipPos_xyzw_14.y;
                float unitClipPos_z_12 = unitClipPos_xyzw_14.z;
                float r1_w_9 = (-r1_w_8 + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_2.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(float4(unitClipPos_x_14, unitClipPos_y_14, unitClipPos_z_12, unitClipPos_x_14), unitViewDir_xyz_2.xyzx);
                float r2_x_3 = dot(float4(unitClipPos_x_14, unitClipPos_y_14, unitClipPos_z_12, unitClipPos_x_14), r1_xyz_1.xyzx);
                float r2_y_3 = dot(float4(unitClipPos_x_14, unitClipPos_y_14, unitClipPos_z_12, unitClipPos_x_14), r0_xyz_3.xyzx);
                float r0_x_4 = dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_9.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_x_3 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(nDotV_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_9 * r1_w_9);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(nDotV_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * mad(r2_x_3, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_x_3, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r2_y_3, r0_z_9, -r2_y_3), r2_y_3, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float r0_z_14 = max(r0_z_13, 0.0001);
                float r0_z_15 = sqrt(r0_z_14);
                float4 r0_xyzw_9 = (r2_x_3.xxxx * float4(r0_y_8, r0_y_8, r0_z_15, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_16 = r0_xyzw_9.z;
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r4_x_7, r4_y_6, r4_z_6, r4_x_7));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r4_x_7, r4_x_7, r4_y_6, r4_z_6) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_11 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_10 = (r0_x_5 * r0_x_5);
                float r1_w_11 = (r1_w_10 * r1_w_10);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r1_w_11), 0.7790837, 0.2209163)).xxxx * float4(r0_y_10, r0_z_17, r0_w_11, r0_y_10));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_11 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                float r0_x_9 = (mad((((mad(r2_w_2.xxxx, -cb0_values[8].xyzx, cb0_values[8].xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8))).x;
                float4 r0_xyzw_12 = mad((((mad(r2_w_2.xxxx, -cb0_values[8].xyzx, cb0_values[8].xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8));
                float r0_y_12 = r0_xyzw_12.y;
                float r0_z_19 = r0_xyzw_12.z;
                float r0_w_12 = (i.texcoord4.x / cb1_values[5].y);
                float r0_w_13 = (-r0_w_12 + 1);
                float r0_w_14 = (r0_w_13 * cb1_values[5].z);
                float r0_w_15 = max(r0_w_14, 0);
                float r0_w_16 = mad(r0_w_15, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w);
                o.sv_Target0.xyz = ((float4(r0_x_9, r0_y_12, r0_z_19, r0_x_9) * r0_w_16.xxxx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[10];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[21];
            };
            cbuffer UnityLighting : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb3_values[2];
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[7];
            };
            SamplerState s0 : register(s0);
            Texture3D t0 : register(t0);
            struct program55Input
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
            struct program55Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program101Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program101Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program55Output vert(program55Input i)
            {
                program55Output o = (program55Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord1.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord4.x = clipPos_xyzw_7.z;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord0.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program101Output frag(program101Input i)
            {
                program101Output o = (program101Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_1 = log2(cb0_values[6].x);
                float r1_w_2 = (r1_w_1 * cb0_values[9].x);
                float r1_w_3 = exp2(r1_w_2);
                float r1_w_4 = (-r1_w_3 + 1);
                float4 r2_xyzw_3 = mad(((r1_w_4 * cb0_values[8].x)).xxxx, -cb0_values[4].xyzx, cb0_values[4].xyzx);
                float r2_x_3 = r2_xyzw_3.x;
                float r2_y_1 = r2_xyzw_3.y;
                float r2_z_1 = r2_xyzw_3.z;
                float r1_w_5 = mad(r1_w_4, cb0_values[8].y, cb0_values[5].x);
                float r1_w_6 = (r1_w_5 + cb0_values[8].z);
                float r2_w_1 = (cb4_values[0].x == 1);
                float r3_x_10;
                float r3_y_11;
                float r3_z_10;
                float r3_w_4;
                if (r2_w_1)
                {
                    float r2_w_2 = (cb4_values[0].y == 1);
                    float3 r3_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord1.zzzz, (mad(cb4_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r3_xyzw_8 = (((((r2_w_2.xxxx ? r3_xyz_5.xyzx : i.texcoord1.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r2_w_3 = mad(r3_y_8, 0.25, 0.75);
                    float r3_y_9 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r3_x_8 = max(r2_w_3, r3_y_9);
                    float4 r3_xyzw_9 = t0.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
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
                float r2_w_5 = dot(float4(r3_x_10, r3_y_11, r3_z_10, r3_w_4), unity_OcclusionMaskSelector);
                float4 r3_xyzw_11 = (r2_w_5.xxxx * _LightColor0.xyzx);
                float r3_x_11 = r3_xyzw_11.x;
                float r3_y_12 = r3_xyzw_11.y;
                float r3_z_11 = r3_xyzw_11.z;
                float r2_w_6 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r2_w_7 = rsqrt(r2_w_6);
                float3 unitClipPos_xyz_1 = ((r2_w_7.xxxx * i.texcoord0.xyzx)).xyz;
                float4 r2_xyzw_4 = (float4(r2_x_3, r2_y_1, r2_z_1, r2_x_3) * float4(0.7790837, 0.7790837, 0.7790837, 0));
                float r2_x_4 = r2_xyzw_4.x;
                float r2_y_2 = r2_xyzw_4.y;
                float r2_z_2 = r2_xyzw_4.z;
                float r1_w_7 = (-r1_w_6 + 1);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitClipPos_xyz_1.xyzx, unitViewDir_xyz_1.xyzx);
                float r1_x_2 = dot(unitClipPos_xyz_1.xyzx, _WorldSpaceLightPos0.xyzx);
                float r1_y_2 = dot(unitClipPos_xyz_1.xyzx, r0_xyz_3.xyzx);
                float r0_x_4 = dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_7.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(nDotV_w_6) + 1);
                float r2_w_8 = (r1_z_4 * r1_z_4);
                float r2_w_9 = (r2_w_8 * r2_w_8);
                float r1_z_5 = (r1_z_4 * r2_w_9);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_7 * r1_w_7);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_z_6 = (-r0_z_8 + 1);
                float r1_w_8 = mad(abs(nDotV_w_6), r1_z_6, r0_z_8);
                float r1_z_7 = mad(r1_x_2, r1_z_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * r1_z_7);
                float r0_w_8 = mad(r1_x_2, r1_w_8, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_z_8 = mad(r1_y_2, r0_z_9, -r1_y_2);
                float r1_y_3 = mad(r1_z_8, r1_y_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r0_z_11 = (r0_z_10 / r1_y_4);
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float r0_z_14 = max(r0_z_13, 0.0001);
                float r0_z_15 = sqrt(r0_z_14);
                float4 r0_xyzw_9 = (r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_z_15, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_16 = r0_xyzw_9.z;
                float4 r1_xyzw_3 = (r0_y_9.xxxx * float4(r3_x_11, r3_y_12, r3_z_11, r3_x_11));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_5 = r1_xyzw_3.y;
                float r1_z_9 = r1_xyzw_3.z;
                float4 r0_xyzw_10 = (float4(r3_x_11, r3_x_11, r3_y_12, r3_z_11) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_11 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_9 = (r0_x_5 * r0_x_5);
                float r1_w_10 = (r1_w_9 * r1_w_9);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r1_w_10), 0.7790837, 0.2209163)).xxxx * float4(r0_y_10, r0_z_17, r0_w_11, r0_y_10));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_11 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                float r0_x_9 = (mad(float4(r2_x_4, r2_y_2, r2_z_2, r2_x_4), float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8))).x;
                float4 r0_xyzw_12 = mad(float4(r2_x_4, r2_y_2, r2_z_2, r2_x_4), float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8));
                float r0_y_12 = r0_xyzw_12.y;
                float r0_z_19 = r0_xyzw_12.z;
                float r0_w_12 = (i.texcoord4.x / cb1_values[5].y);
                float r0_w_13 = (-r0_w_12 + 1);
                float r0_w_14 = (r0_w_13 * cb1_values[5].z);
                float r0_w_15 = max(r0_w_14, 0);
                float r0_w_16 = mad(r0_w_15, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w);
                o.sv_Target0.xyz = ((float4(r0_x_9, r0_y_12, r0_z_19, r0_x_9) * r0_w_16.xxxx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[14];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb3_values[2];
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[7];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
            struct program54Input
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
            struct program54Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program100Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program100Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program54Output vert(program54Input i)
            {
                program54Output o = (program54Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                o.texcoord4.x = clipPos_xyzw_2.z;
                float worldNormal_x_3 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord0.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = (mad(unity_WorldToObject[3].xyzx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyzx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program100Output frag(program100Input i)
            {
                program100Output o = (program100Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r1_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r1_w_2 = rsqrt(r1_w_1);
                float3 unitViewDir_xyz_2 = ((r1_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_3 = log2(cb0_values[10].x);
                float r1_w_4 = (r1_w_3 * cb0_values[13].x);
                float r1_w_5 = exp2(r1_w_4);
                float r1_w_6 = (-r1_w_5 + 1);
                float r2_w_1 = (r1_w_6 * cb0_values[12].x);
                float r2_w_2 = r2_w_1;
                float r1_w_7 = mad(r1_w_6, cb0_values[12].y, cb0_values[9].x);
                float r1_w_8 = (r1_w_7 + cb0_values[12].z);
                float3 r4_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord1.zzzz, (mad(cb0_values[4].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r2_w_3 = (cb4_values[0].x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r2_w_3)
                {
                    float r2_w_4 = (cb4_values[0].y == 1);
                    float3 r5_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord1.zzzz, (mad(cb4_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r5_xyzw_8 = (((((r2_w_4.xxxx ? r5_xyz_5.xyzx : i.texcoord1.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r2_w_5 = mad(r5_y_8, 0.25, 0.75);
                    float r3_w_1 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r5_x_8 = max(r2_w_5, r3_w_1);
                    float4 r5_xyzw_9 = t1.Sample(s0, float4(r5_x_8, r5_z_8, r5_w_2, r5_x_8));
                    r5_x_10 = r5_xyzw_9.x;
                    r5_y_10 = r5_xyzw_9.y;
                    r5_z_10 = r5_xyzw_9.z;
                    r5_w_4 = r5_xyzw_9.w;
                }
                else
                {
                    float4 r5_xyzw_10 = float4(1, 1, 1, 1);
                    r5_x_10 = r5_xyzw_10.x;
                    r5_y_10 = r5_xyzw_10.y;
                    r5_z_10 = r5_xyzw_10.z;
                    r5_w_4 = r5_xyzw_10.w;
                }
                float r2_w_7 = dot(float4(r5_x_10, r5_y_10, r5_z_10, r5_w_4), unity_OcclusionMaskSelector);
                float r3_w_3 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float4 r4_xyzw_5 = t0.Sample(s1, r3_w_3.xxxx);
                float r2_w_8 = (r2_w_7 * r4_xyzw_5.x);
                float3 r4_xyz_6 = ((r2_w_8.xxxx * _LightColor0.xyzx)).xyz;
                float r2_w_9 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r2_w_10 = rsqrt(r2_w_9);
                float3 unitClipPos_xyz_11 = ((r2_w_10.xxxx * i.texcoord0.xyzx)).xyz;
                float r1_w_9 = (-r1_w_8 + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_2.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitClipPos_xyz_11.xyzx, unitViewDir_xyz_2.xyzx);
                float r2_x_3 = dot(unitClipPos_xyz_11.xyzx, r1_xyz_1.xyzx);
                float r2_y_3 = dot(unitClipPos_xyz_11.xyzx, r0_xyz_3.xyzx);
                float r0_x_4 = dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_9.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_x_3 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(nDotV_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_9 * r1_w_9);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(nDotV_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * mad(r2_x_3, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_x_3, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r2_y_3, r0_z_9, -r2_y_3), r2_y_3, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float r0_z_14 = max(r0_z_13, 0.0001);
                float r0_z_15 = sqrt(r0_z_14);
                float4 r0_xyzw_9 = (r2_x_3.xxxx * float4(r0_y_8, r0_y_8, r0_z_15, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_16 = r0_xyzw_9.z;
                float4 r1_xyzw_11 = (r0_y_9.xxxx * r4_xyz_6.xyzx);
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (r4_xyz_6.xxyz * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_11 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_10 = (r0_x_5 * r0_x_5);
                float r1_w_11 = (r1_w_10 * r1_w_10);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r1_w_11), 0.7790837, 0.2209163)).xxxx * float4(r0_y_10, r0_z_17, r0_w_11, r0_y_10));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_11 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                float r0_x_9 = (mad((((mad(r2_w_2.xxxx, -cb0_values[8].xyzx, cb0_values[8].xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8))).x;
                float4 r0_xyzw_12 = mad((((mad(r2_w_2.xxxx, -cb0_values[8].xyzx, cb0_values[8].xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8));
                float r0_y_12 = r0_xyzw_12.y;
                float r0_z_19 = r0_xyzw_12.z;
                float r0_w_12 = (i.texcoord4.x / cb1_values[5].y);
                float r0_w_13 = (-r0_w_12 + 1);
                float r0_w_14 = (r0_w_13 * cb1_values[5].z);
                float r0_w_15 = max(r0_w_14, 0);
                float r0_w_16 = mad(r0_w_15, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w);
                o.sv_Target0.xyz = ((float4(r0_x_9, r0_y_12, r0_z_19, r0_x_9) * r0_w_16.xxxx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[14];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerComparisonState s1 : register(s1);
            SamplerState s2 : register(s2);
            SamplerState s3 : register(s3);
            Texture2D t0 : register(t0);
            TextureCube t1 : register(t1);
            Texture3D t2 : register(t2);
            TextureCube t3 : register(t3);
            struct program53Input
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
            struct program53Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program99Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program99Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program53Output vert(program53Input i)
            {
                program53Output o = (program53Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = (mad(unity_WorldToObject[3].xyzx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyzx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program99Output frag(program99Input i)
            {
                program99Output o = (program99Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r1_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r1_w_2 = rsqrt(r1_w_1);
                float3 unitViewDir_xyz_1 = ((r1_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_3 = log2(cb0_values[10].x);
                float r1_w_4 = (r1_w_3 * cb0_values[13].x);
                float r1_w_5 = exp2(r1_w_4);
                float r1_w_6 = (-r1_w_5 + 1);
                float r2_w_1 = (r1_w_6 * cb0_values[12].x);
                float r2_w_2 = r2_w_1;
                float r1_w_7 = mad(r1_w_6, cb0_values[12].y, cb0_values[9].x);
                float r1_w_8 = (r1_w_7 + cb0_values[12].z);
                float3 r5_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord1.zzzz, (mad(cb0_values[4].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r2_x_2 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float4 r2_xyzw_2 = (i.texcoord1.xxyz + -cb3_values[25].xxyz);
                float r2_y_2 = r2_xyzw_2.y;
                float r2_z_2 = r2_xyzw_2.z;
                float r2_w_3 = r2_xyzw_2.w;
                float r2_y_3 = dot(float4(r2_y_2, r2_z_2, r2_w_3, r2_y_2), float4(r2_y_2, r2_z_2, r2_w_3, r2_y_2));
                float r2_y_4 = sqrt(r2_y_3);
                float r2_y_5 = (-r2_x_2 + r2_y_4);
                float r2_x_4 = mad(mad(cb3_values[25].w, r2_y_5, r2_x_2), cb3_values[24].z, cb3_values[24].w);
                float r2_y_6 = (cb5_values[0].x == 1);
                float r6_x_9;
                float r6_y_9;
                float r6_z_9;
                float r6_w_4;
                if (r2_y_6)
                {
                    float r2_y_7 = (cb5_values[0].y == 1);
                    float3 r6_xyz_6 = (((mad(cb5_values[3].xyzx, i.texcoord1.zzzz, (mad(cb5_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (r2_y_7.xxxx ? r6_xyz_6.xxyz : i.texcoord1.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float r2_w_4 = r2_xyzw_8.w;
                    float4 r2_xyzw_9 = (float4(r2_y_8, r2_y_8, r2_z_3, r2_w_4) + -cb5_values[6].xxyz);
                    float r2_y_9 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float r2_w_5 = r2_xyzw_9.w;
                    float4 r6_xyzw_7 = (float4(r2_y_9, r2_y_9, r2_z_4, r2_w_5) * cb5_values[5].xxyz);
                    float r6_y_7 = r6_xyzw_7.y;
                    float r6_z_7 = r6_xyzw_7.z;
                    float r6_w_2 = r6_xyzw_7.w;
                    float r2_y_10 = mad(r6_y_7, 0.25, 0.75);
                    float r2_z_5 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r6_x_7 = max(r2_z_5, r2_y_10);
                    float4 r6_xyzw_8 = t2.Sample(s0, float4(r6_x_7, r6_z_7, r6_w_2, r6_x_7));
                    r6_x_9 = r6_xyzw_8.x;
                    r6_y_9 = r6_xyzw_8.y;
                    r6_z_9 = r6_xyzw_8.z;
                    r6_w_4 = r6_xyzw_8.w;
                }
                else
                {
                    float4 r6_xyzw_2 = float4(1, 1, 1, 1);
                    r6_x_9 = r6_xyzw_2.x;
                    r6_y_9 = r6_xyzw_2.y;
                    r6_z_9 = r6_xyzw_2.z;
                    r6_w_4 = r6_xyzw_2.w;
                }
                float r2_y_12 = dot(float4(r6_x_9, r6_y_9, r6_z_9, r6_w_4), unity_OcclusionMaskSelector);
                float r2_z_7 = (r2_x_4 < 0.99);
                float r2_z_19;
                if (r2_z_7)
                {
                    float3 r6_xyz_10 = ((i.texcoord1.xyzx + -cb2_values[1].xyzx)).xyz;
                    float r2_z_9 = max(abs(r6_xyz_10.y), abs(r6_xyz_10.x));
                    float r2_z_10 = max(abs(r6_xyz_10.z), r2_z_9);
                    float r2_z_11 = (r2_z_10 + -cb2_values[2].z);
                    float r2_z_12 = max(r2_z_11, 1E-05);
                    float r2_z_13 = (r2_z_12 * cb2_values[2].w);
                    float r2_z_14 = (cb2_values[2].y / r2_z_13);
                    float r2_z_15 = (r2_z_14 + -cb2_values[2].x);
                    float r2_z_16 = (-r2_z_15 + 1);
                    float r7_x_2 = t3.SampleCmpLevelZero(s1, (((r6_xyz_10.xyzx + float4(0.0078125, 0.0078125, 0.0078125, 0))).xyzx).xyz, r2_z_16);
                    float r7_y_2 = t3.SampleCmpLevelZero(s1, (((r6_xyz_10.xyzx + float4(-0.0078125, -0.0078125, 0.0078125, 0))).xyzx).xyz, r2_z_16);
                    float r7_z_2 = t3.SampleCmpLevelZero(s1, (((r6_xyz_10.xyzx + float4(-0.0078125, 0.0078125, -0.0078125, 0))).xyzx).xyz, r2_z_16);
                    float r7_w_1 = t3.SampleCmpLevelZero(s1, (((r6_xyz_10.xyzx + float4(0.0078125, -0.0078125, -0.0078125, 0))).xyzx).xyz, r2_z_16);
                    float r2_z_17 = dot(float4(r7_x_2, r7_y_2, r7_z_2, r7_w_1), float4(0.25, 0.25, 0.25, 0.25));
                    float r2_w_7 = (-cb3_values[24].x + 1);
                    float r2_z_18 = mad(r2_z_17, r2_w_7, cb3_values[24].x);
                    r2_z_19 = r2_z_18;
                }
                else
                {
                    float r2_z_8 = 1;
                    r2_z_19 = r2_z_8;
                }
                float r2_y_13 = (-r2_z_19 + r2_y_12);
                float r2_y_14 = dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx);
                float4 r6_xyzw_13 = t0.Sample(s3, r2_y_14.xxxx);
                float4 r5_xyzw_5 = t1.Sample(s2, r5_xyz_4.xyzx);
                float r2_y_15 = (r5_xyzw_5.w * r6_xyzw_13.x);
                float4 r2_xyzw_7 = (((mad(r2_x_4, r2_y_13, r2_z_19) * r2_y_15)).xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_16 = r2_xyzw_7.y;
                float r2_z_20 = r2_xyzw_7.z;
                float r2_w_9 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r2_w_10 = rsqrt(r2_w_9);
                float3 unitWorldNormal_xyz_6 = ((r2_w_10.xxxx * i.texcoord0.xyzx)).xyz;
                float r1_w_9 = (-r1_w_8 + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitWorldNormal_xyz_6.xyzx, unitViewDir_xyz_1.xyzx);
                float r2_w_11 = dot(unitWorldNormal_xyz_6.xyzx, r1_xyz_1.xyzx);
                float r3_x_2 = dot(unitWorldNormal_xyz_6.xyzx, r0_xyz_3.xyzx);
                float r0_x_4 = dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_9.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_11 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(nDotV_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_9 * r1_w_9);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(nDotV_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * mad(r2_w_11, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_11, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r3_x_2, r0_z_9, -r3_x_2), r3_x_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float r0_z_14 = max(r0_z_13, 0.0001);
                float r0_z_15 = sqrt(r0_z_14);
                float4 r0_xyzw_9 = (r2_w_11.xxxx * float4(r0_y_8, r0_y_8, r0_z_15, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_16 = r0_xyzw_9.z;
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r2_x_7, r2_y_16, r2_z_20, r2_x_7));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r2_x_7, r2_x_7, r2_y_16, r2_z_20) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_11 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_10 = (r0_x_5 * r0_x_5);
                float r1_w_11 = (r1_w_10 * r1_w_10);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r1_w_11), 0.7790837, 0.2209163)).xxxx * float4(r0_y_10, r0_z_17, r0_w_11, r0_y_10));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_11 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                o.sv_Target0.xyz = (mad((((mad(r2_w_2.xxxx, -cb0_values[8].xyzx, cb0_values[8].xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[14];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerComparisonState s1 : register(s1);
            SamplerState s2 : register(s2);
            SamplerState s3 : register(s3);
            Texture2D t0 : register(t0);
            TextureCube t1 : register(t1);
            Texture3D t2 : register(t2);
            TextureCube t3 : register(t3);
            struct program52Input
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
            struct program52Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program98Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program98Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program52Output vert(program52Input i)
            {
                program52Output o = (program52Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = (mad(unity_WorldToObject[3].xyzx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyzx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program98Output frag(program98Input i)
            {
                program98Output o = (program98Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r1_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r1_w_2 = rsqrt(r1_w_1);
                float3 unitViewDir_xyz_1 = ((r1_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_3 = log2(cb0_values[10].x);
                float r1_w_4 = (r1_w_3 * cb0_values[13].x);
                float r1_w_5 = exp2(r1_w_4);
                float r1_w_6 = (-r1_w_5 + 1);
                float r2_w_1 = (r1_w_6 * cb0_values[12].x);
                float r2_w_2 = r2_w_1;
                float r1_w_7 = mad(r1_w_6, cb0_values[12].y, cb0_values[9].x);
                float r1_w_8 = (r1_w_7 + cb0_values[12].z);
                float3 r5_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord1.zzzz, (mad(cb0_values[4].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r2_x_2 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float4 r2_xyzw_2 = (i.texcoord1.xxyz + -cb3_values[25].xxyz);
                float r2_y_2 = r2_xyzw_2.y;
                float r2_z_2 = r2_xyzw_2.z;
                float r2_w_3 = r2_xyzw_2.w;
                float r2_y_3 = dot(float4(r2_y_2, r2_z_2, r2_w_3, r2_y_2), float4(r2_y_2, r2_z_2, r2_w_3, r2_y_2));
                float r2_y_4 = sqrt(r2_y_3);
                float r2_y_5 = (-r2_x_2 + r2_y_4);
                float r2_y_6 = (cb5_values[0].x == 1);
                float r6_x_9;
                float r6_y_9;
                float r6_z_9;
                float r6_w_4;
                if (r2_y_6)
                {
                    float r2_y_7 = (cb5_values[0].y == 1);
                    float3 r6_xyz_6 = (((mad(cb5_values[3].xyzx, i.texcoord1.zzzz, (mad(cb5_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (r2_y_7.xxxx ? r6_xyz_6.xxyz : i.texcoord1.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float r2_w_4 = r2_xyzw_8.w;
                    float4 r2_xyzw_9 = (float4(r2_y_8, r2_y_8, r2_z_3, r2_w_4) + -cb5_values[6].xxyz);
                    float r2_y_9 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float r2_w_5 = r2_xyzw_9.w;
                    float4 r6_xyzw_7 = (float4(r2_y_9, r2_y_9, r2_z_4, r2_w_5) * cb5_values[5].xxyz);
                    float r6_y_7 = r6_xyzw_7.y;
                    float r6_z_7 = r6_xyzw_7.z;
                    float r6_w_2 = r6_xyzw_7.w;
                    float r2_y_10 = mad(r6_y_7, 0.25, 0.75);
                    float r2_z_5 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r6_x_7 = max(r2_z_5, r2_y_10);
                    float4 r6_xyzw_8 = t2.Sample(s0, float4(r6_x_7, r6_z_7, r6_w_2, r6_x_7));
                    r6_x_9 = r6_xyzw_8.x;
                    r6_y_9 = r6_xyzw_8.y;
                    r6_z_9 = r6_xyzw_8.z;
                    r6_w_4 = r6_xyzw_8.w;
                }
                else
                {
                    float4 r6_xyzw_2 = float4(1, 1, 1, 1);
                    r6_x_9 = r6_xyzw_2.x;
                    r6_y_9 = r6_xyzw_2.y;
                    r6_z_9 = r6_xyzw_2.z;
                    r6_w_4 = r6_xyzw_2.w;
                }
                float r2_y_12 = dot(float4(r6_x_9, r6_y_9, r6_z_9, r6_w_4), unity_OcclusionMaskSelector);
                float3 r6_xyz_10 = ((i.texcoord1.xyzx + -cb2_values[1].xyzx)).xyz;
                float r2_z_7 = max(abs(r6_xyz_10.y), abs(r6_xyz_10.x));
                float r2_z_8 = max(abs(r6_xyz_10.z), r2_z_7);
                float r2_z_9 = (r2_z_8 + -cb2_values[2].z);
                float r2_z_10 = max(r2_z_9, 1E-05);
                float r2_z_11 = (r2_z_10 * cb2_values[2].w);
                float r2_z_12 = (cb2_values[2].y / r2_z_11);
                float r2_z_13 = (r2_z_12 + -cb2_values[2].x);
                float r2_z_14 = (-r2_z_13 + 1);
                float r2_z_15 = t3.SampleCmpLevelZero(s1, (r6_xyz_10.xyzx).xyz, r2_z_14);
                float r2_w_7 = (-cb3_values[24].x + 1);
                float r2_z_16 = mad(r2_z_15, r2_w_7, cb3_values[24].x);
                float r2_y_13 = (-r2_z_16 + r2_y_12);
                float r2_y_14 = dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx);
                float4 r6_xyzw_11 = t0.Sample(s3, r2_y_14.xxxx);
                float4 r5_xyzw_5 = t1.Sample(s2, r5_xyz_4.xyzx);
                float r2_y_15 = (r5_xyzw_5.w * r6_xyzw_11.x);
                float4 r2_xyzw_7 = (((mad(mad(mad(cb3_values[25].w, r2_y_5, r2_x_2), cb3_values[24].z, cb3_values[24].w), r2_y_13, r2_z_16) * r2_y_15)).xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_16 = r2_xyzw_7.y;
                float r2_z_17 = r2_xyzw_7.z;
                float r2_w_8 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r2_w_9 = rsqrt(r2_w_8);
                float3 unitWorldNormal_xyz_6 = ((r2_w_9.xxxx * i.texcoord0.xyzx)).xyz;
                float r1_w_9 = (-r1_w_8 + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitWorldNormal_xyz_6.xyzx, unitViewDir_xyz_1.xyzx);
                float r2_w_10 = dot(unitWorldNormal_xyz_6.xyzx, r1_xyz_1.xyzx);
                float r3_x_2 = dot(unitWorldNormal_xyz_6.xyzx, r0_xyz_3.xyzx);
                float r0_x_4 = dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_9.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_10 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(nDotV_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_9 * r1_w_9);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(nDotV_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * mad(r2_w_10, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_10, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r3_x_2, r0_z_9, -r3_x_2), r3_x_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float r0_z_14 = max(r0_z_13, 0.0001);
                float r0_z_15 = sqrt(r0_z_14);
                float4 r0_xyzw_9 = (r2_w_10.xxxx * float4(r0_y_8, r0_y_8, r0_z_15, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_16 = r0_xyzw_9.z;
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r2_x_7, r2_y_16, r2_z_17, r2_x_7));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r2_x_7, r2_x_7, r2_y_16, r2_z_17) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_11 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_10 = (r0_x_5 * r0_x_5);
                float r1_w_11 = (r1_w_10 * r1_w_10);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r1_w_11), 0.7790837, 0.2209163)).xxxx * float4(r0_y_10, r0_z_17, r0_w_11, r0_y_10));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_11 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                o.sv_Target0.xyz = (mad((((mad(r2_w_2.xxxx, -cb0_values[8].xyzx, cb0_values[8].xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[14];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerComparisonState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
            TextureCube t2 : register(t2);
            struct program51Input
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
            struct program51Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program97Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program97Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program51Output vert(program51Input i)
            {
                program51Output o = (program51Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = (mad(unity_WorldToObject[3].xyzx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyzx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program97Output frag(program97Input i)
            {
                program97Output o = (program97Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r1_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r1_w_2 = rsqrt(r1_w_1);
                float3 unitViewDir_xyz_1 = ((r1_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_3 = log2(cb0_values[10].x);
                float r1_w_4 = (r1_w_3 * cb0_values[13].x);
                float r1_w_5 = exp2(r1_w_4);
                float r1_w_6 = (-r1_w_5 + 1);
                float r2_w_1 = (r1_w_6 * cb0_values[12].x);
                float r2_w_2 = r2_w_1;
                float r1_w_7 = mad(r1_w_6, cb0_values[12].y, cb0_values[9].x);
                float r1_w_8 = (r1_w_7 + cb0_values[12].z);
                float3 r5_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord1.zzzz, (mad(cb0_values[4].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r2_x_2 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float4 r2_xyzw_2 = (i.texcoord1.xxyz + -cb3_values[25].xxyz);
                float r2_y_2 = r2_xyzw_2.y;
                float r2_z_2 = r2_xyzw_2.z;
                float r2_w_3 = r2_xyzw_2.w;
                float r2_y_3 = dot(float4(r2_y_2, r2_z_2, r2_w_3, r2_y_2), float4(r2_y_2, r2_z_2, r2_w_3, r2_y_2));
                float r2_y_4 = sqrt(r2_y_3);
                float r2_y_5 = (-r2_x_2 + r2_y_4);
                float r2_x_4 = mad(mad(cb3_values[25].w, r2_y_5, r2_x_2), cb3_values[24].z, cb3_values[24].w);
                float r2_y_6 = (cb5_values[0].x == 1);
                float r6_x_9;
                float r6_y_9;
                float r6_z_9;
                float r6_w_4;
                if (r2_y_6)
                {
                    float r2_y_7 = (cb5_values[0].y == 1);
                    float3 r6_xyz_6 = (((mad(cb5_values[3].xyzx, i.texcoord1.zzzz, (mad(cb5_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (r2_y_7.xxxx ? r6_xyz_6.xxyz : i.texcoord1.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float r2_w_4 = r2_xyzw_8.w;
                    float4 r2_xyzw_9 = (float4(r2_y_8, r2_y_8, r2_z_3, r2_w_4) + -cb5_values[6].xxyz);
                    float r2_y_9 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float r2_w_5 = r2_xyzw_9.w;
                    float4 r6_xyzw_7 = (float4(r2_y_9, r2_y_9, r2_z_4, r2_w_5) * cb5_values[5].xxyz);
                    float r6_y_7 = r6_xyzw_7.y;
                    float r6_z_7 = r6_xyzw_7.z;
                    float r6_w_2 = r6_xyzw_7.w;
                    float r2_y_10 = mad(r6_y_7, 0.25, 0.75);
                    float r2_z_5 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r6_x_7 = max(r2_z_5, r2_y_10);
                    float4 r6_xyzw_8 = t1.Sample(s0, float4(r6_x_7, r6_z_7, r6_w_2, r6_x_7));
                    r6_x_9 = r6_xyzw_8.x;
                    r6_y_9 = r6_xyzw_8.y;
                    r6_z_9 = r6_xyzw_8.z;
                    r6_w_4 = r6_xyzw_8.w;
                }
                else
                {
                    float4 r6_xyzw_2 = float4(1, 1, 1, 1);
                    r6_x_9 = r6_xyzw_2.x;
                    r6_y_9 = r6_xyzw_2.y;
                    r6_z_9 = r6_xyzw_2.z;
                    r6_w_4 = r6_xyzw_2.w;
                }
                float r2_y_12 = dot(float4(r6_x_9, r6_y_9, r6_z_9, r6_w_4), unity_OcclusionMaskSelector);
                float r2_z_7 = (r2_x_4 < 0.99);
                float r2_z_19;
                if (r2_z_7)
                {
                    float3 r6_xyz_10 = ((i.texcoord1.xyzx + -cb2_values[1].xyzx)).xyz;
                    float r2_z_9 = max(abs(r6_xyz_10.y), abs(r6_xyz_10.x));
                    float r2_z_10 = max(abs(r6_xyz_10.z), r2_z_9);
                    float r2_z_11 = (r2_z_10 + -cb2_values[2].z);
                    float r2_z_12 = max(r2_z_11, 1E-05);
                    float r2_z_13 = (r2_z_12 * cb2_values[2].w);
                    float r2_z_14 = (cb2_values[2].y / r2_z_13);
                    float r2_z_15 = (r2_z_14 + -cb2_values[2].x);
                    float r2_z_16 = (-r2_z_15 + 1);
                    float r7_x_2 = t2.SampleCmpLevelZero(s1, (((r6_xyz_10.xyzx + float4(0.0078125, 0.0078125, 0.0078125, 0))).xyzx).xyz, r2_z_16);
                    float r7_y_2 = t2.SampleCmpLevelZero(s1, (((r6_xyz_10.xyzx + float4(-0.0078125, -0.0078125, 0.0078125, 0))).xyzx).xyz, r2_z_16);
                    float r7_z_2 = t2.SampleCmpLevelZero(s1, (((r6_xyz_10.xyzx + float4(-0.0078125, 0.0078125, -0.0078125, 0))).xyzx).xyz, r2_z_16);
                    float r7_w_1 = t2.SampleCmpLevelZero(s1, (((r6_xyz_10.xyzx + float4(0.0078125, -0.0078125, -0.0078125, 0))).xyzx).xyz, r2_z_16);
                    float r2_z_17 = dot(float4(r7_x_2, r7_y_2, r7_z_2, r7_w_1), float4(0.25, 0.25, 0.25, 0.25));
                    float r2_w_7 = (-cb3_values[24].x + 1);
                    float r2_z_18 = mad(r2_z_17, r2_w_7, cb3_values[24].x);
                    r2_z_19 = r2_z_18;
                }
                else
                {
                    float r2_z_8 = 1;
                    r2_z_19 = r2_z_8;
                }
                float r2_y_13 = (-r2_z_19 + r2_y_12);
                float r2_y_14 = dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx);
                float4 r5_xyzw_5 = t0.Sample(s2, r2_y_14.xxxx);
                float4 r2_xyzw_7 = (((mad(r2_x_4, r2_y_13, r2_z_19) * r5_xyzw_5.x)).xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_15 = r2_xyzw_7.y;
                float r2_z_20 = r2_xyzw_7.z;
                float r2_w_9 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r2_w_10 = rsqrt(r2_w_9);
                float3 unitWorldNormal_xyz_6 = ((r2_w_10.xxxx * i.texcoord0.xyzx)).xyz;
                float r1_w_9 = (-r1_w_8 + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitWorldNormal_xyz_6.xyzx, unitViewDir_xyz_1.xyzx);
                float r2_w_11 = dot(unitWorldNormal_xyz_6.xyzx, r1_xyz_1.xyzx);
                float r3_x_2 = dot(unitWorldNormal_xyz_6.xyzx, r0_xyz_3.xyzx);
                float r0_x_4 = dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_9.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_11 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(nDotV_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_9 * r1_w_9);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(nDotV_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * mad(r2_w_11, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_11, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r3_x_2, r0_z_9, -r3_x_2), r3_x_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float r0_z_14 = max(r0_z_13, 0.0001);
                float r0_z_15 = sqrt(r0_z_14);
                float4 r0_xyzw_9 = (r2_w_11.xxxx * float4(r0_y_8, r0_y_8, r0_z_15, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_16 = r0_xyzw_9.z;
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r2_x_7, r2_y_15, r2_z_20, r2_x_7));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r2_x_7, r2_x_7, r2_y_15, r2_z_20) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_11 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_10 = (r0_x_5 * r0_x_5);
                float r1_w_11 = (r1_w_10 * r1_w_10);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r1_w_11), 0.7790837, 0.2209163)).xxxx * float4(r0_y_10, r0_z_17, r0_w_11, r0_y_10));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_11 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                o.sv_Target0.xyz = (mad((((mad(r2_w_2.xxxx, -cb0_values[8].xyzx, cb0_values[8].xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[14];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerComparisonState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
            TextureCube t2 : register(t2);
            struct program50Input
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
            struct program50Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program96Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program96Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program50Output vert(program50Input i)
            {
                program50Output o = (program50Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = (mad(unity_WorldToObject[3].xyzx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyzx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program96Output frag(program96Input i)
            {
                program96Output o = (program96Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r1_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r1_w_2 = rsqrt(r1_w_1);
                float3 unitViewDir_xyz_1 = ((r1_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_3 = log2(cb0_values[10].x);
                float r1_w_4 = (r1_w_3 * cb0_values[13].x);
                float r1_w_5 = exp2(r1_w_4);
                float r1_w_6 = (-r1_w_5 + 1);
                float r2_w_1 = (r1_w_6 * cb0_values[12].x);
                float r2_w_2 = r2_w_1;
                float r1_w_7 = mad(r1_w_6, cb0_values[12].y, cb0_values[9].x);
                float r1_w_8 = (r1_w_7 + cb0_values[12].z);
                float3 r5_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord1.zzzz, (mad(cb0_values[4].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r2_x_2 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float4 r2_xyzw_2 = (i.texcoord1.xxyz + -cb3_values[25].xxyz);
                float r2_y_2 = r2_xyzw_2.y;
                float r2_z_2 = r2_xyzw_2.z;
                float r2_w_3 = r2_xyzw_2.w;
                float r2_y_3 = dot(float4(r2_y_2, r2_z_2, r2_w_3, r2_y_2), float4(r2_y_2, r2_z_2, r2_w_3, r2_y_2));
                float r2_y_4 = sqrt(r2_y_3);
                float r2_y_5 = (-r2_x_2 + r2_y_4);
                float r2_y_6 = (cb5_values[0].x == 1);
                float r6_x_9;
                float r6_y_9;
                float r6_z_9;
                float r6_w_4;
                if (r2_y_6)
                {
                    float r2_y_7 = (cb5_values[0].y == 1);
                    float3 r6_xyz_6 = (((mad(cb5_values[3].xyzx, i.texcoord1.zzzz, (mad(cb5_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (r2_y_7.xxxx ? r6_xyz_6.xxyz : i.texcoord1.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float r2_w_4 = r2_xyzw_8.w;
                    float4 r2_xyzw_9 = (float4(r2_y_8, r2_y_8, r2_z_3, r2_w_4) + -cb5_values[6].xxyz);
                    float r2_y_9 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float r2_w_5 = r2_xyzw_9.w;
                    float4 r6_xyzw_7 = (float4(r2_y_9, r2_y_9, r2_z_4, r2_w_5) * cb5_values[5].xxyz);
                    float r6_y_7 = r6_xyzw_7.y;
                    float r6_z_7 = r6_xyzw_7.z;
                    float r6_w_2 = r6_xyzw_7.w;
                    float r2_y_10 = mad(r6_y_7, 0.25, 0.75);
                    float r2_z_5 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r6_x_7 = max(r2_z_5, r2_y_10);
                    float4 r6_xyzw_8 = t1.Sample(s0, float4(r6_x_7, r6_z_7, r6_w_2, r6_x_7));
                    r6_x_9 = r6_xyzw_8.x;
                    r6_y_9 = r6_xyzw_8.y;
                    r6_z_9 = r6_xyzw_8.z;
                    r6_w_4 = r6_xyzw_8.w;
                }
                else
                {
                    float4 r6_xyzw_2 = float4(1, 1, 1, 1);
                    r6_x_9 = r6_xyzw_2.x;
                    r6_y_9 = r6_xyzw_2.y;
                    r6_z_9 = r6_xyzw_2.z;
                    r6_w_4 = r6_xyzw_2.w;
                }
                float r2_y_12 = dot(float4(r6_x_9, r6_y_9, r6_z_9, r6_w_4), unity_OcclusionMaskSelector);
                float3 r6_xyz_10 = ((i.texcoord1.xyzx + -cb2_values[1].xyzx)).xyz;
                float r2_z_7 = max(abs(r6_xyz_10.y), abs(r6_xyz_10.x));
                float r2_z_8 = max(abs(r6_xyz_10.z), r2_z_7);
                float r2_z_9 = (r2_z_8 + -cb2_values[2].z);
                float r2_z_10 = max(r2_z_9, 1E-05);
                float r2_z_11 = (r2_z_10 * cb2_values[2].w);
                float r2_z_12 = (cb2_values[2].y / r2_z_11);
                float r2_z_13 = (r2_z_12 + -cb2_values[2].x);
                float r2_z_14 = (-r2_z_13 + 1);
                float r2_z_15 = t2.SampleCmpLevelZero(s1, (r6_xyz_10.xyzx).xyz, r2_z_14);
                float r2_w_7 = (-cb3_values[24].x + 1);
                float r2_z_16 = mad(r2_z_15, r2_w_7, cb3_values[24].x);
                float r2_y_13 = (-r2_z_16 + r2_y_12);
                float r2_y_14 = dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx);
                float4 r5_xyzw_5 = t0.Sample(s2, r2_y_14.xxxx);
                float4 r2_xyzw_7 = (((mad(mad(mad(cb3_values[25].w, r2_y_5, r2_x_2), cb3_values[24].z, cb3_values[24].w), r2_y_13, r2_z_16) * r5_xyzw_5.x)).xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_15 = r2_xyzw_7.y;
                float r2_z_17 = r2_xyzw_7.z;
                float r2_w_8 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r2_w_9 = rsqrt(r2_w_8);
                float3 unitWorldNormal_xyz_6 = ((r2_w_9.xxxx * i.texcoord0.xyzx)).xyz;
                float r1_w_9 = (-r1_w_8 + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitWorldNormal_xyz_6.xyzx, unitViewDir_xyz_1.xyzx);
                float r2_w_10 = dot(unitWorldNormal_xyz_6.xyzx, r1_xyz_1.xyzx);
                float r3_x_2 = dot(unitWorldNormal_xyz_6.xyzx, r0_xyz_3.xyzx);
                float r0_x_4 = dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_9.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_10 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(nDotV_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_9 * r1_w_9);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(nDotV_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * mad(r2_w_10, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_10, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r3_x_2, r0_z_9, -r3_x_2), r3_x_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float r0_z_14 = max(r0_z_13, 0.0001);
                float r0_z_15 = sqrt(r0_z_14);
                float4 r0_xyzw_9 = (r2_w_10.xxxx * float4(r0_y_8, r0_y_8, r0_z_15, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_16 = r0_xyzw_9.z;
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r2_x_7, r2_y_15, r2_z_17, r2_x_7));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r2_x_7, r2_x_7, r2_y_15, r2_z_17) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_11 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_10 = (r0_x_5 * r0_x_5);
                float r1_w_11 = (r1_w_10 * r1_w_10);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r1_w_11), 0.7790837, 0.2209163)).xxxx * float4(r0_y_10, r0_z_17, r0_w_11, r0_y_10));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_11 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                o.sv_Target0.xyz = (mad((((mad(r2_w_2.xxxx, -cb0_values[8].xyzx, cb0_values[8].xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[14];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[6];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer cb3 : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture3D t2 : register(t2);
            struct program49Input
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
            struct program49Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program95Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program95Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program49Output vert(program49Input i)
            {
                program49Output o = (program49Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                float worldNormal_x_4 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r2_w_4 = dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4));
                float r2_w_5 = rsqrt(r2_w_4);
                o.texcoord0.xyz = ((r2_w_5.xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4))).xyz;
                o.texcoord1.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xy = (mad(unity_WorldToObject[3].xyxx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyxx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyxx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyxx)).xyxx)).xyxx)).xyxx)).xy;
                float r0_w_5 = ((clipPos_xyzw_2.y * cb1_values[5].x) * 0.5);
                float4 r0_xyzw_8 = (clipPos_xyzw_2.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_z_5 = r0_xyzw_8.z;
                o.texcoord3.zw = (clipPos_xyzw_2.zzzw).zw;
                o.texcoord3.xy = ((r0_z_5.xxxx + float4(r0_x_8, r0_w_5, r0_x_8, r0_x_8))).xy;
                return o;
            }
            #pragma fragment frag
            program95Output frag(program95Input i)
            {
                program95Output o = (program95Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_1 = log2(cb0_values[10].x);
                float r1_w_2 = (r1_w_1 * cb0_values[13].x);
                float r1_w_3 = exp2(r1_w_2);
                float r1_w_4 = (-r1_w_3 + 1);
                float4 r2_xyzw_3 = mad(((r1_w_4 * cb0_values[12].x)).xxxx, -cb0_values[8].xyzx, cb0_values[8].xyzx);
                float r2_x_3 = r2_xyzw_3.x;
                float r2_y_1 = r2_xyzw_3.y;
                float r2_z_1 = r2_xyzw_3.z;
                float r1_w_5 = mad(r1_w_4, cb0_values[12].y, cb0_values[9].x);
                float r1_w_6 = (r1_w_5 + cb0_values[12].z);
                float r4_x_1 = cb4_values[9].z;
                float r4_y_1 = cb4_values[10].z;
                float r4_z_1 = cb4_values[11].z;
                float r2_w_1 = dot(viewDir_xyz_1.xyzx, float4(r4_x_1, r4_y_1, r4_z_1, r4_x_1));
                float3 r4_xyz_2 = ((i.texcoord1.xyzx + -cb3_values[25].xyzx)).xyz;
                float r3_z_1 = dot(r4_xyz_2.xyzx, r4_xyz_2.xyzx);
                float r3_z_2 = sqrt(r3_z_1);
                float r3_z_3 = (-r2_w_1 + r3_z_2);
                float r2_w_2 = mad(cb3_values[25].w, r3_z_3, r2_w_1);
                float r2_w_3 = mad(r2_w_2, cb3_values[24].z, cb3_values[24].w);
                float r3_z_4 = (cb5_values[0].x == 1);
                float r4_x_12;
                float r4_y_12;
                float r4_z_12;
                float r4_w_4;
                if (r3_z_4)
                {
                    float r3_z_5 = (cb5_values[0].y == 1);
                    float3 r4_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord1.zzzz, (mad(cb5_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r4_xyzw_10 = (((((r3_z_5.xxxx ? r4_xyz_7.xyzx : i.texcoord1.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r4_y_10 = r4_xyzw_10.y;
                    float r4_z_10 = r4_xyzw_10.z;
                    float r4_w_2 = r4_xyzw_10.w;
                    float r3_z_6 = mad(r4_y_10, 0.25, 0.75);
                    float r3_w_1 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r4_x_10 = max(r3_w_1, r3_z_6);
                    float4 r4_xyzw_11 = t2.Sample(s0, float4(r4_x_10, r4_z_10, r4_w_2, r4_x_10));
                    r4_x_12 = r4_xyzw_11.x;
                    r4_y_12 = r4_xyzw_11.y;
                    r4_z_12 = r4_xyzw_11.z;
                    r4_w_4 = r4_xyzw_11.w;
                }
                else
                {
                    float4 r4_xyzw_3 = float4(1, 1, 1, 1);
                    r4_x_12 = r4_xyzw_3.x;
                    r4_y_12 = r4_xyzw_3.y;
                    r4_z_12 = r4_xyzw_3.z;
                    r4_w_4 = r4_xyzw_3.w;
                }
                float r3_z_8 = dot(float4(r4_x_12, r4_y_12, r4_z_12, r4_w_4), unity_OcclusionMaskSelector);
                float4 r4_xyzw_14 = t0.Sample(s1, ((i.texcoord3.xyxx / i.texcoord3.wwww)).xyxx);
                float r3_z_9 = (r3_z_8 + -r4_xyzw_14.x);
                float r2_w_4 = mad(r2_w_3, r3_z_9, r4_xyzw_14.x);
                float4 r3_xyzw_5 = t1.Sample(s2, (((mad(cb0_values[6].xyxx, i.texcoord1.zzzz, (mad(cb0_values[4].xyxx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx);
                float r2_w_5 = (r2_w_4 * r3_xyzw_5.w);
                float4 r3_xyzw_6 = (r2_w_5.xxxx * _LightColor0.xyzx);
                float r3_x_6 = r3_xyzw_6.x;
                float r3_y_6 = r3_xyzw_6.y;
                float r3_z_11 = r3_xyzw_6.z;
                float r2_w_6 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r2_w_7 = rsqrt(r2_w_6);
                float4 unitWorldNormal_xyzw_15 = (r2_w_7.xxxx * i.texcoord0.xyzx);
                float unitWorldNormal_x_15 = unitWorldNormal_xyzw_15.x;
                float unitWorldNormal_y_15 = unitWorldNormal_xyzw_15.y;
                float unitWorldNormal_z_14 = unitWorldNormal_xyzw_15.z;
                float4 r2_xyzw_4 = (float4(r2_x_3, r2_y_1, r2_z_1, r2_x_3) * float4(0.7790837, 0.7790837, 0.7790837, 0));
                float r2_x_4 = r2_xyzw_4.x;
                float r2_y_2 = r2_xyzw_4.y;
                float r2_z_2 = r2_xyzw_4.z;
                float r1_w_7 = (-r1_w_6 + 1);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(float4(unitWorldNormal_x_15, unitWorldNormal_y_15, unitWorldNormal_z_14, unitWorldNormal_x_15), unitViewDir_xyz_1.xyzx);
                float r1_x_2 = dot(float4(unitWorldNormal_x_15, unitWorldNormal_y_15, unitWorldNormal_z_14, unitWorldNormal_x_15), _WorldSpaceLightPos0.xyzx);
                float r1_y_2 = dot(float4(unitWorldNormal_x_15, unitWorldNormal_y_15, unitWorldNormal_z_14, unitWorldNormal_x_15), r0_xyz_3.xyzx);
                float r0_x_4 = dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_7.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(nDotV_w_6) + 1);
                float r2_w_8 = (r1_z_4 * r1_z_4);
                float r2_w_9 = (r2_w_8 * r2_w_8);
                float r1_z_5 = (r1_z_4 * r2_w_9);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_7 * r1_w_7);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_z_6 = (-r0_z_8 + 1);
                float r1_w_8 = mad(abs(nDotV_w_6), r1_z_6, r0_z_8);
                float r1_z_7 = mad(r1_x_2, r1_z_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * r1_z_7);
                float r0_w_8 = mad(r1_x_2, r1_w_8, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_z_8 = mad(r1_y_2, r0_z_9, -r1_y_2);
                float r1_y_3 = mad(r1_z_8, r1_y_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r0_z_11 = (r0_z_10 / r1_y_4);
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float r0_z_14 = max(r0_z_13, 0.0001);
                float r0_z_15 = sqrt(r0_z_14);
                float4 r0_xyzw_9 = (r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_z_15, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_16 = r0_xyzw_9.z;
                float4 r1_xyzw_3 = (r0_y_9.xxxx * float4(r3_x_6, r3_y_6, r3_z_11, r3_x_6));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_5 = r1_xyzw_3.y;
                float r1_z_9 = r1_xyzw_3.z;
                float4 r0_xyzw_10 = (float4(r3_x_6, r3_x_6, r3_y_6, r3_z_11) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_11 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_9 = (r0_x_5 * r0_x_5);
                float r1_w_10 = (r1_w_9 * r1_w_9);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r1_w_10), 0.7790837, 0.2209163)).xxxx * float4(r0_y_10, r0_z_17, r0_w_11, r0_y_10));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_11 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                o.sv_Target0.xyz = (mad(float4(r2_x_4, r2_y_2, r2_z_2, r2_x_4), float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[10];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
            struct program48Input
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
            struct program48Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program94Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program94Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program48Output vert(program48Input i)
            {
                program48Output o = (program48Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r1_xyzw_3 = (float4(clipPos_xyzw_7.x, clipPos_xyzw_7.x, clipPos_xyzw_7.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_z_3 = r1_xyzw_3.z;
                float r1_w_4 = r1_xyzw_3.w;
                o.texcoord3.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord3.xy = ((r1_z_3.xxxx + float4(r1_x_3, r1_w_4, r1_x_3, r1_x_3))).xy;
                return o;
            }
            #pragma fragment frag
            program94Output frag(program94Input i)
            {
                program94Output o = (program94Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_1 = log2(cb0_values[6].x);
                float r1_w_2 = (r1_w_1 * cb0_values[9].x);
                float r1_w_3 = exp2(r1_w_2);
                float r1_w_4 = (-r1_w_3 + 1);
                float4 r2_xyzw_3 = mad(((r1_w_4 * cb0_values[8].x)).xxxx, -cb0_values[4].xyzx, cb0_values[4].xyzx);
                float r2_x_3 = r2_xyzw_3.x;
                float r2_y_1 = r2_xyzw_3.y;
                float r2_z_1 = r2_xyzw_3.z;
                float r1_w_5 = mad(r1_w_4, cb0_values[8].y, cb0_values[5].x);
                float r1_w_6 = (r1_w_5 + cb0_values[8].z);
                float r3_x_1 = cb4_values[9].z;
                float r3_y_1 = cb4_values[10].z;
                float r3_z_1 = cb4_values[11].z;
                float r2_w_1 = dot(viewDir_xyz_1.xyzx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float3 r3_xyz_2 = ((i.texcoord1.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = mad(cb3_values[25].w, (-r2_w_1 + sqrt(dot(r3_xyz_2.xyzx, r3_xyz_2.xyzx))), r2_w_1);
                float r2_w_3 = mad(r2_w_2, cb3_values[24].z, cb3_values[24].w);
                float r3_x_13;
                float r3_y_13;
                float r3_z_12;
                float r3_w_8;
                if ((cb5_values[0].x == 1))
                {
                    float4 r3_xyzw_4 = (i.texcoord1.yyyy * cb5_values[2].xxyz);
                    float r3_y_4 = r3_xyzw_4.y;
                    float r3_z_4 = r3_xyzw_4.z;
                    float r3_w_2 = r3_xyzw_4.w;
                    float4 r3_xyzw_5 = mad(cb5_values[1].xxyz, i.texcoord1.xxxx, float4(r3_y_4, r3_y_4, r3_z_4, r3_w_2));
                    float r3_y_5 = r3_xyzw_5.y;
                    float r3_z_5 = r3_xyzw_5.z;
                    float r3_w_3 = r3_xyzw_5.w;
                    float4 r3_xyzw_6 = mad(cb5_values[3].xxyz, i.texcoord1.zzzz, float4(r3_y_5, r3_y_5, r3_z_5, r3_w_3));
                    float r3_y_6 = r3_xyzw_6.y;
                    float r3_z_6 = r3_xyzw_6.z;
                    float r3_w_4 = r3_xyzw_6.w;
                    float4 r3_xyzw_7 = (float4(r3_y_6, r3_y_6, r3_z_6, r3_w_4) + cb5_values[4].xxyz);
                    float r3_y_7 = r3_xyzw_7.y;
                    float r3_z_7 = r3_xyzw_7.z;
                    float r3_w_5 = r3_xyzw_7.w;
                    float4 r3_xyzw_9 = (((cb5_values[0].y == 1)).xxxx ? float4(r3_y_7, r3_z_7, r3_w_5, r3_y_7) : i.texcoord1.xyzx);
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
                    float4 r3_xyzw_12 = t1.Sample(s0, float4(r3_x_11, r3_z_10, r3_w_6, r3_x_11));
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
                float4 r3_xyzw_14 = (i.texcoord3.xxyx / i.texcoord3.wwww);
                float r3_y_14 = r3_xyzw_14.y;
                float r3_z_13 = r3_xyzw_14.z;
                float4 r4_xyzw_3 = t0.Sample(s1, float4(r3_y_14, r3_z_13, r3_y_14, r3_y_14));
                float r2_w_4 = mad(r2_w_3, (dot(float4(r3_x_13, r3_y_13, r3_z_12, r3_w_8), unity_OcclusionMaskSelector) + -r4_xyzw_3.x), r4_xyzw_3.x);
                float4 r3_xyzw_16 = (r2_w_4.xxxx * _LightColor0.xyzx);
                float r3_x_16 = r3_xyzw_16.x;
                float r3_y_15 = r3_xyzw_16.y;
                float r3_z_14 = r3_xyzw_16.z;
                float r2_w_5 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r2_w_6 = rsqrt(r2_w_5);
                float4 unitWorldNormal_xyzw_4 = (r2_w_6.xxxx * i.texcoord0.xyzx);
                float unitWorldNormal_x_4 = unitWorldNormal_xyzw_4.x;
                float unitWorldNormal_y_2 = unitWorldNormal_xyzw_4.y;
                float unitWorldNormal_z_2 = unitWorldNormal_xyzw_4.z;
                float4 r2_xyzw_4 = (float4(r2_x_3, r2_y_1, r2_z_1, r2_x_3) * float4(0.7790837, 0.7790837, 0.7790837, 0));
                float r2_x_4 = r2_xyzw_4.x;
                float r2_y_2 = r2_xyzw_4.y;
                float r2_z_2 = r2_xyzw_4.z;
                float r1_w_7 = (-r1_w_6 + 1);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(float4(unitWorldNormal_x_4, unitWorldNormal_y_2, unitWorldNormal_z_2, unitWorldNormal_x_4), unitViewDir_xyz_1.xyzx);
                float r1_x_2 = dot(float4(unitWorldNormal_x_4, unitWorldNormal_y_2, unitWorldNormal_z_2, unitWorldNormal_x_4), _WorldSpaceLightPos0.xyzx);
                float r1_y_2 = dot(float4(unitWorldNormal_x_4, unitWorldNormal_y_2, unitWorldNormal_z_2, unitWorldNormal_x_4), r0_xyz_3.xyzx);
                float r0_x_4 = dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_7.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(nDotV_w_6) + 1);
                float r2_w_7 = (r1_z_4 * r1_z_4);
                float r2_w_8 = (r2_w_7 * r2_w_7);
                float r1_z_5 = (r1_z_4 * r2_w_8);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_7 * r1_w_7);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_z_6 = (-r0_z_8 + 1);
                float r1_w_8 = mad(abs(nDotV_w_6), r1_z_6, r0_z_8);
                float r1_z_7 = mad(r1_x_2, r1_z_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * r1_z_7);
                float r0_w_8 = mad(r1_x_2, r1_w_8, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_z_8 = mad(r1_y_2, r0_z_9, -r1_y_2);
                float r1_y_3 = mad(r1_z_8, r1_y_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r0_z_11 = (r0_z_10 / r1_y_4);
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float r0_z_14 = max(r0_z_13, 0.0001);
                float r0_z_15 = sqrt(r0_z_14);
                float4 r0_xyzw_9 = (r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_z_15, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_16 = r0_xyzw_9.z;
                float4 r1_xyzw_3 = (r0_y_9.xxxx * float4(r3_x_16, r3_y_15, r3_z_14, r3_x_16));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_5 = r1_xyzw_3.y;
                float r1_z_9 = r1_xyzw_3.z;
                float4 r0_xyzw_10 = (float4(r3_x_16, r3_x_16, r3_y_15, r3_z_14) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_11 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_9 = (r0_x_5 * r0_x_5);
                float r1_w_10 = (r1_w_9 * r1_w_9);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r1_w_10), 0.7790837, 0.2209163)).xxxx * float4(r0_y_10, r0_z_17, r0_w_11, r0_y_10));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_11 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                o.sv_Target0.xyz = (mad(float4(r2_x_4, r2_y_2, r2_z_2, r2_x_4), float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[19];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerComparisonState s1 : register(s1);
            SamplerState s2 : register(s2);
            SamplerState s3 : register(s3);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture3D t2 : register(t2);
            Texture2D t3 : register(t3);
            struct program47Input
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
            struct program47Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program93Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program93Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program47Output vert(program47Input i)
            {
                program47Output o = (program47Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 r1_xyzw_3 = (r0_xyzw_4.yyyy * cb0_values[10].xyzw);
                float4 r1_xyzw_4 = mad(cb0_values[9].xyzw, r0_xyzw_4.xxxx, r1_xyzw_3);
                float4 r1_xyzw_5 = mad(cb0_values[11].xyzw, r0_xyzw_4.zzzz, r1_xyzw_4);
                o.texcoord2.xyzw = mad(cb0_values[12].xyzw, r0_xyzw_4.wwww, r1_xyzw_5);
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program93Output frag(program93Input i)
            {
                program93Output o = (program93Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r1_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r1_w_2 = rsqrt(r1_w_1);
                float3 unitViewDir_xyz_1 = ((r1_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_3 = log2(cb0_values[15].x);
                float r1_w_4 = (r1_w_3 * cb0_values[18].x);
                float r1_w_5 = exp2(r1_w_4);
                float r1_w_6 = (-r1_w_5 + 1);
                float r2_w_1 = (r1_w_6 * cb0_values[17].x);
                float r2_w_2 = r2_w_1;
                float r1_w_7 = mad(r1_w_6, cb0_values[17].y, cb0_values[14].x);
                float r1_w_8 = (r1_w_7 + cb0_values[17].z);
                float4 r5_xyzw_4 = (mad(cb0_values[11].xyzw, i.texcoord1.zzzz, mad(cb0_values[9].xyzw, i.texcoord1.xxxx, (i.texcoord1.yyyy * cb0_values[10].xyzw))) + cb0_values[12].xyzw);
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r2_x_2 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float4 r2_xyzw_2 = (i.texcoord1.xxyz + -cb3_values[25].xxyz);
                float r2_y_2 = r2_xyzw_2.y;
                float r2_z_2 = r2_xyzw_2.z;
                float r2_w_3 = r2_xyzw_2.w;
                float r2_y_3 = dot(float4(r2_y_2, r2_z_2, r2_w_3, r2_y_2), float4(r2_y_2, r2_z_2, r2_w_3, r2_y_2));
                float r2_y_4 = sqrt(r2_y_3);
                float r2_y_5 = (-r2_x_2 + r2_y_4);
                float r2_x_4 = mad(mad(cb3_values[25].w, r2_y_5, r2_x_2), cb3_values[24].z, cb3_values[24].w);
                float r2_y_6 = (cb5_values[0].x == 1);
                float r6_x_9;
                float r6_y_9;
                float r6_z_9;
                float r6_w_4;
                if (r2_y_6)
                {
                    float r2_y_7 = (cb5_values[0].y == 1);
                    float3 r6_xyz_6 = (((mad(cb5_values[3].xyzx, i.texcoord1.zzzz, (mad(cb5_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (r2_y_7.xxxx ? r6_xyz_6.xxyz : i.texcoord1.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float r2_w_4 = r2_xyzw_8.w;
                    float4 r2_xyzw_9 = (float4(r2_y_8, r2_y_8, r2_z_3, r2_w_4) + -cb5_values[6].xxyz);
                    float r2_y_9 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float r2_w_5 = r2_xyzw_9.w;
                    float4 r6_xyzw_7 = (float4(r2_y_9, r2_y_9, r2_z_4, r2_w_5) * cb5_values[5].xxyz);
                    float r6_y_7 = r6_xyzw_7.y;
                    float r6_z_7 = r6_xyzw_7.z;
                    float r6_w_2 = r6_xyzw_7.w;
                    float r2_y_10 = mad(r6_y_7, 0.25, 0.75);
                    float r2_z_5 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r6_x_7 = max(r2_z_5, r2_y_10);
                    float4 r6_xyzw_8 = t2.Sample(s0, float4(r6_x_7, r6_z_7, r6_w_2, r6_x_7));
                    r6_x_9 = r6_xyzw_8.x;
                    r6_y_9 = r6_xyzw_8.y;
                    r6_z_9 = r6_xyzw_8.z;
                    r6_w_4 = r6_xyzw_8.w;
                }
                else
                {
                    float4 r6_xyzw_2 = float4(1, 1, 1, 1);
                    r6_x_9 = r6_xyzw_2.x;
                    r6_y_9 = r6_xyzw_2.y;
                    r6_z_9 = r6_xyzw_2.z;
                    r6_w_4 = r6_xyzw_2.w;
                }
                float r2_y_12 = dot(float4(r6_x_9, r6_y_9, r6_z_9, r6_w_4), unity_OcclusionMaskSelector);
                float r2_z_7 = (r2_x_4 < 0.99);
                float r2_z_15;
                if (r2_z_7)
                {
                    float4 r6_xyzw_10 = (i.texcoord1.yyyy * cb3_values[9].xyzw);
                    float4 r6_xyzw_11 = mad(cb3_values[8].xyzw, i.texcoord1.xxxx, r6_xyzw_10);
                    float4 r6_xyzw_12 = mad(cb3_values[10].xyzw, i.texcoord1.zzzz, r6_xyzw_11);
                    float4 r6_xyzw_13 = (r6_xyzw_12 + cb3_values[11].xyzw);
                    float3 r6_xyz_14 = ((r6_xyzw_13.xyzx / r6_xyzw_13.wwww)).xyz;
                    float r2_z_9 = (mad(r6_xyz_14.xxxy, cb0_values[8].zzzw, float4(0, 0, 0.5, 0.5))).z;
                    float r2_w_7 = (mad(r6_xyz_14.xxxy, cb0_values[8].zzzw, float4(0, 0, 0.5, 0.5))).w;
                    float4 r2_xyzw_10 = floor(float4(r2_z_9, r2_z_9, r2_z_9, r2_w_7));
                    float r2_z_10 = r2_xyzw_10.z;
                    float r2_w_8 = r2_xyzw_10.w;
                    float2 r6_xy_15 = (mad(r6_xyz_14.xyxx, cb0_values[8].zwzz, -float4(r2_z_10, r2_w_8, r2_z_10, r2_z_10))).xy;
                    float4 r7_xyzw_1 = (r6_xy_15.xxyy + float4(0.5, 1, 0.5, 1));
                    float2 r8_xw_1 = ((r7_xyzw_1.xxxz * r7_xyzw_1.xxxz)).xw;
                    float2 r7_xz_2 = (mad(r8_xw_1.xxyx, float4(0.5, 0, 0.5, 0), -r6_xy_15.xxyx)).xz;
                    float2 r9_zw_1 = (min(r6_xy_15.xxxy, float4(0, 0, 0, 0))).zw;
                    float2 r9_xy_2 = (mad(-r9_zw_1.xyxx, r9_zw_1.xyxx, ((-r6_xy_15.xyxx + float4(1, 1, 0, 0))).xyxx)).xy;
                    float2 r6_xy_16 = (max(r6_xy_15.xyxx, float4(0, 0, 0, 0))).xy;
                    float2 r6_xy_17 = (mad(-r6_xy_16.xyxx, r6_xy_16.xyxx, r7_xyzw_1.ywyy)).xy;
                    float r10_x_1 = r7_xz_2.x;
                    float r10_y_1 = r9_xy_2.x;
                    float r10_z_1 = r6_xy_17.x;
                    float r10_w_1 = r8_xw_1.x;
                    float4 r10_xyzw_2 = (float4(r10_x_1, r10_y_1, r10_z_1, r10_w_1) * float4(0.44444, 0.44444, 0.44444, 0.22222));
                    float r8_x_2 = r7_xz_2.y;
                    float r8_y_1 = r9_xy_2.y;
                    float r8_z_1 = r6_xy_17.y;
                    float4 r7_xyzw_3 = (float4(r8_x_2, r8_y_1, r8_z_1, r8_xw_1.y) * float4(0.44444, 0.44444, 0.44444, 0.22222));
                    float4 r8_xyzw_3 = (r10_xyzw_2.ywyw + r10_xyzw_2.xzxz);
                    float4 r9_xyzw_3 = (r7_xyzw_3.yyww + r7_xyzw_3.xxzz);
                    float4 r7_xyzw_4 = (r7_xyzw_3.ywyy / r9_xyzw_3.ywyy);
                    float r7_x_4 = r7_xyzw_4.x;
                    float r7_y_3 = r7_xyzw_4.y;
                    float4 r7_xyzw_5 = (float4(r7_x_4, r7_y_3, r7_x_4, r7_x_4) + float4(-1.5, 0.5, 0, 0));
                    float r7_x_5 = r7_xyzw_5.x;
                    float r7_y_4 = r7_xyzw_5.y;
                    float2 r10_xy_3 = ((((((r10_xyzw_2.ywyy / r8_xyzw_3.zwzz)).xyxx + float4(-1.5, 0.5, 0, 0))).xyxx * cb0_values[8].xxxx)).xy;
                    float2 r10_zw_3 = ((float4(r7_x_5, r7_x_5, r7_x_5, r7_y_4) * cb0_values[8].yyyy)).zw;
                    float4 r7_xyzw_6 = (r8_xyzw_3 * r9_xyzw_3);
                    float4 r8_xyzw_4 = mad(float4(r2_z_10, r2_w_8, r2_z_10, r2_w_8), cb0_values[8].xyxy, float4(r10_xy_3.x, r10_zw_3.x, r10_xy_3.y, r10_zw_3.x));
                    float r3_w_1 = t3.SampleCmpLevelZero(s1, (r8_xyzw_4.xyxx).xy, r6_xyz_14.z);
                    float r4_w_1 = t3.SampleCmpLevelZero(s1, (r8_xyzw_4.zwzz).xy, r6_xyz_14.z);
                    float r4_w_2 = (r4_w_1 * r7_xyzw_6.y);
                    float r3_w_2 = mad(r7_xyzw_6.x, r3_w_1, r4_w_2);
                    float4 r8_xyzw_5 = mad(float4(r2_z_10, r2_w_8, r2_z_10, r2_w_8), cb0_values[8].xyxy, float4(r10_xy_3.x, r10_zw_3.y, r10_xy_3.y, r10_zw_3.y));
                    float r2_z_11 = t3.SampleCmpLevelZero(s1, (r8_xyzw_5.xyxx).xy, r6_xyz_14.z);
                    float r2_z_12 = mad(r7_xyzw_6.z, r2_z_11, r3_w_2);
                    float r2_w_9 = t3.SampleCmpLevelZero(s1, (r8_xyzw_5.zwzz).xy, r6_xyz_14.z);
                    float r2_z_13 = mad(r7_xyzw_6.w, r2_w_9, r2_z_12);
                    float r2_w_10 = (-cb3_values[24].x + 1);
                    float r2_z_14 = mad(r2_z_13, r2_w_10, cb3_values[24].x);
                    r2_z_15 = r2_z_14;
                }
                else
                {
                    float r2_z_8 = 1;
                    r2_z_15 = r2_z_8;
                }
                float r2_y_13 = (-r2_z_15 + r2_y_12);
                float r2_y_14 = (0 < r5_xyzw_4.z);
                float r2_y_15 = asfloat(asint(r2_y_14) & asint(1065353216));
                float4 r2_xyzw_16 = (r5_xyzw_4.xxxy / r5_xyzw_4.wwww);
                float r2_z_16 = r2_xyzw_16.z;
                float r2_w_12 = r2_xyzw_16.w;
                float4 r2_xyzw_17 = (float4(r2_z_16, r2_z_16, r2_z_16, r2_w_12) + float4(0, 0, 0.5, 0.5));
                float r2_z_17 = r2_xyzw_17.z;
                float r2_w_13 = r2_xyzw_17.w;
                float4 r6_xyzw_21 = t0.Sample(s2, float4(r2_z_17, r2_w_13, r2_z_17, r2_z_17));
                float r2_y_16 = (r2_y_15 * r6_xyzw_21.w);
                float r2_z_18 = dot(r5_xyzw_4.xyzx, r5_xyzw_4.xyzx);
                float4 r5_xyzw_5 = t1.Sample(s3, r2_z_18.xxxx);
                float r2_y_17 = (r2_y_16 * r5_xyzw_5.x);
                float4 r2_xyzw_7 = (((mad(r2_x_4, r2_y_13, r2_z_15) * r2_y_17)).xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_18 = r2_xyzw_7.y;
                float r2_z_19 = r2_xyzw_7.z;
                float r2_w_14 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r2_w_15 = rsqrt(r2_w_14);
                float3 unitWorldNormal_xyz_6 = ((r2_w_15.xxxx * i.texcoord0.xyzx)).xyz;
                float r1_w_9 = (-r1_w_8 + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitWorldNormal_xyz_6.xyzx, unitViewDir_xyz_1.xyzx);
                float r2_w_16 = dot(unitWorldNormal_xyz_6.xyzx, r1_xyz_1.xyzx);
                float r3_x_2 = dot(unitWorldNormal_xyz_6.xyzx, r0_xyz_3.xyzx);
                float r0_x_4 = dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_9.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_16 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(nDotV_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_9 * r1_w_9);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(nDotV_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * mad(r2_w_16, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_16, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r3_x_2, r0_z_9, -r3_x_2), r3_x_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float r0_z_14 = max(r0_z_13, 0.0001);
                float r0_z_15 = sqrt(r0_z_14);
                float4 r0_xyzw_9 = (r2_w_16.xxxx * float4(r0_y_8, r0_y_8, r0_z_15, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_16 = r0_xyzw_9.z;
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r2_x_7, r2_y_18, r2_z_19, r2_x_7));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r2_x_7, r2_x_7, r2_y_18, r2_z_19) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_11 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_10 = (r0_x_5 * r0_x_5);
                float r1_w_11 = (r1_w_10 * r1_w_10);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r1_w_11), 0.7790837, 0.2209163)).xxxx * float4(r0_y_10, r0_z_17, r0_w_11, r0_y_10));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_11 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                o.sv_Target0.xyz = (mad((((mad(r2_w_2.xxxx, -cb0_values[13].xyzx, cb0_values[13].xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[14];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerComparisonState s1 : register(s1);
            SamplerState s2 : register(s2);
            SamplerState s3 : register(s3);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture3D t2 : register(t2);
            Texture2D t3 : register(t3);
            struct program46Input
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
            struct program46Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program92Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program92Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program46Output vert(program46Input i)
            {
                program46Output o = (program46Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 r1_xyzw_3 = (r0_xyzw_4.yyyy * unity_WorldToObject[1]);
                float4 r1_xyzw_4 = mad(unity_WorldToObject[0], r0_xyzw_4.xxxx, r1_xyzw_3);
                float4 r1_xyzw_5 = mad(unity_WorldToObject[2], r0_xyzw_4.zzzz, r1_xyzw_4);
                o.texcoord2.xyzw = mad(unity_WorldToObject[3], r0_xyzw_4.wwww, r1_xyzw_5);
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program92Output frag(program92Input i)
            {
                program92Output o = (program92Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r1_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r1_w_2 = rsqrt(r1_w_1);
                float3 unitViewDir_xyz_1 = ((r1_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_3 = log2(cb0_values[10].x);
                float r1_w_4 = (r1_w_3 * cb0_values[13].x);
                float r1_w_5 = exp2(r1_w_4);
                float r1_w_6 = (-r1_w_5 + 1);
                float r2_w_1 = (r1_w_6 * cb0_values[12].x);
                float r2_w_2 = r2_w_1;
                float r1_w_7 = mad(r1_w_6, cb0_values[12].y, cb0_values[9].x);
                float r1_w_8 = (r1_w_7 + cb0_values[12].z);
                float4 r5_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord1.zzzz, mad(cb0_values[4].xyzw, i.texcoord1.xxxx, (i.texcoord1.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r2_x_2 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float4 r2_xyzw_2 = (i.texcoord1.xxyz + -cb3_values[25].xxyz);
                float r2_y_2 = r2_xyzw_2.y;
                float r2_z_2 = r2_xyzw_2.z;
                float r2_w_3 = r2_xyzw_2.w;
                float r2_y_3 = dot(float4(r2_y_2, r2_z_2, r2_w_3, r2_y_2), float4(r2_y_2, r2_z_2, r2_w_3, r2_y_2));
                float r2_y_4 = sqrt(r2_y_3);
                float r2_y_5 = (-r2_x_2 + r2_y_4);
                float r2_y_6 = (cb5_values[0].x == 1);
                float r6_x_9;
                float r6_y_9;
                float r6_z_9;
                float r6_w_4;
                if (r2_y_6)
                {
                    float r2_y_7 = (cb5_values[0].y == 1);
                    float3 r6_xyz_6 = (((mad(cb5_values[3].xyzx, i.texcoord1.zzzz, (mad(cb5_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (r2_y_7.xxxx ? r6_xyz_6.xxyz : i.texcoord1.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float r2_w_4 = r2_xyzw_8.w;
                    float4 r2_xyzw_9 = (float4(r2_y_8, r2_y_8, r2_z_3, r2_w_4) + -cb5_values[6].xxyz);
                    float r2_y_9 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float r2_w_5 = r2_xyzw_9.w;
                    float4 r6_xyzw_7 = (float4(r2_y_9, r2_y_9, r2_z_4, r2_w_5) * cb5_values[5].xxyz);
                    float r6_y_7 = r6_xyzw_7.y;
                    float r6_z_7 = r6_xyzw_7.z;
                    float r6_w_2 = r6_xyzw_7.w;
                    float r2_y_10 = mad(r6_y_7, 0.25, 0.75);
                    float r2_z_5 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r6_x_7 = max(r2_z_5, r2_y_10);
                    float4 r6_xyzw_8 = t2.Sample(s0, float4(r6_x_7, r6_z_7, r6_w_2, r6_x_7));
                    r6_x_9 = r6_xyzw_8.x;
                    r6_y_9 = r6_xyzw_8.y;
                    r6_z_9 = r6_xyzw_8.z;
                    r6_w_4 = r6_xyzw_8.w;
                }
                else
                {
                    float4 r6_xyzw_2 = float4(1, 1, 1, 1);
                    r6_x_9 = r6_xyzw_2.x;
                    r6_y_9 = r6_xyzw_2.y;
                    r6_z_9 = r6_xyzw_2.z;
                    r6_w_4 = r6_xyzw_2.w;
                }
                float r2_y_12 = dot(float4(r6_x_9, r6_y_9, r6_z_9, r6_w_4), unity_OcclusionMaskSelector);
                float4 r6_xyzw_10 = (i.texcoord1.yyyy * cb3_values[9].xyzw);
                float4 r6_xyzw_11 = mad(cb3_values[8].xyzw, i.texcoord1.xxxx, r6_xyzw_10);
                float4 r6_xyzw_12 = mad(cb3_values[10].xyzw, i.texcoord1.zzzz, r6_xyzw_11);
                float4 r6_xyzw_13 = (r6_xyzw_12 + cb3_values[11].xyzw);
                float3 r6_xyz_14 = ((r6_xyzw_13.xyzx / r6_xyzw_13.wwww)).xyz;
                float r2_z_7 = t3.SampleCmpLevelZero(s1, (r6_xyz_14.xyxx).xy, r6_xyz_14.z);
                float r2_w_7 = (-cb3_values[24].x + 1);
                float r2_z_8 = mad(r2_z_7, r2_w_7, cb3_values[24].x);
                float r2_y_13 = (-r2_z_8 + r2_y_12);
                float r2_y_14 = (0 < r5_xyzw_4.z);
                float r2_y_15 = asfloat(asint(r2_y_14) & asint(1065353216));
                float r2_z_9 = ((r5_xyzw_4.xxxy / r5_xyzw_4.wwww)).z;
                float r2_w_8 = ((r5_xyzw_4.xxxy / r5_xyzw_4.wwww)).w;
                float4 r2_xyzw_10 = (float4(r2_z_9, r2_z_9, r2_z_9, r2_w_8) + float4(0, 0, 0.5, 0.5));
                float r2_z_10 = r2_xyzw_10.z;
                float r2_w_9 = r2_xyzw_10.w;
                float4 r6_xyzw_15 = t0.Sample(s2, float4(r2_z_10, r2_w_9, r2_z_10, r2_z_10));
                float r2_y_16 = (r2_y_15 * r6_xyzw_15.w);
                float r2_z_11 = dot(r5_xyzw_4.xyzx, r5_xyzw_4.xyzx);
                float4 r5_xyzw_5 = t1.Sample(s3, r2_z_11.xxxx);
                float r2_y_17 = (r2_y_16 * r5_xyzw_5.x);
                float4 r2_xyzw_7 = (((mad(mad(mad(cb3_values[25].w, r2_y_5, r2_x_2), cb3_values[24].z, cb3_values[24].w), r2_y_13, r2_z_8) * r2_y_17)).xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_18 = r2_xyzw_7.y;
                float r2_z_12 = r2_xyzw_7.z;
                float r2_w_10 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r2_w_11 = rsqrt(r2_w_10);
                float3 unitWorldNormal_xyz_6 = ((r2_w_11.xxxx * i.texcoord0.xyzx)).xyz;
                float r1_w_9 = (-r1_w_8 + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitWorldNormal_xyz_6.xyzx, unitViewDir_xyz_1.xyzx);
                float r2_w_12 = dot(unitWorldNormal_xyz_6.xyzx, r1_xyz_1.xyzx);
                float r3_x_2 = dot(unitWorldNormal_xyz_6.xyzx, r0_xyz_3.xyzx);
                float r0_x_4 = dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_9.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_12 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(nDotV_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_9 * r1_w_9);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(nDotV_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * mad(r2_w_12, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_12, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r3_x_2, r0_z_9, -r3_x_2), r3_x_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float r0_z_14 = max(r0_z_13, 0.0001);
                float r0_z_15 = sqrt(r0_z_14);
                float4 r0_xyzw_9 = (r2_w_12.xxxx * float4(r0_y_8, r0_y_8, r0_z_15, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_16 = r0_xyzw_9.z;
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r2_x_7, r2_y_18, r2_z_12, r2_x_7));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r2_x_7, r2_x_7, r2_y_18, r2_z_12) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_11 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_10 = (r0_x_5 * r0_x_5);
                float r1_w_11 = (r1_w_10 * r1_w_10);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r1_w_11), 0.7790837, 0.2209163)).xxxx * float4(r0_y_10, r0_z_17, r0_w_11, r0_y_10));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_11 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                o.sv_Target0.xyz = (mad((((mad(r2_w_2.xxxx, -cb0_values[8].xyzx, cb0_values[8].xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[14];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb3_values[7];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
            struct program45Input
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
            struct program45Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program91Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program91Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program45Output vert(program45Input i)
            {
                program45Output o = (program45Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xy = (mad(unity_WorldToObject[3].xyxx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyxx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyxx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyxx)).xyxx)).xyxx)).xyxx)).xy;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program91Output frag(program91Input i)
            {
                program91Output o = (program91Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_1 = log2(cb0_values[10].x);
                float r1_w_2 = (r1_w_1 * cb0_values[13].x);
                float r1_w_3 = exp2(r1_w_2);
                float r1_w_4 = (-r1_w_3 + 1);
                float4 r2_xyzw_3 = mad(((r1_w_4 * cb0_values[12].x)).xxxx, -cb0_values[8].xyzx, cb0_values[8].xyzx);
                float r2_x_3 = r2_xyzw_3.x;
                float r2_y_1 = r2_xyzw_3.y;
                float r2_z_1 = r2_xyzw_3.z;
                float r1_w_5 = mad(r1_w_4, cb0_values[12].y, cb0_values[9].x);
                float r1_w_6 = (r1_w_5 + cb0_values[12].z);
                float r2_w_1 = (unity_ProbeVolumeParams.x == 1);
                float r4_x_10;
                float r4_y_10;
                float r4_z_10;
                float r4_w_4;
                if (r2_w_1)
                {
                    float r2_w_2 = (unity_ProbeVolumeParams.y == 1);
                    float3 r4_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r2_w_2.xxxx ? r4_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r4_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r4_y_8 = r4_xyzw_8.y;
                    float r4_z_8 = r4_xyzw_8.z;
                    float r4_w_2 = r4_xyzw_8.w;
                    float r2_w_3 = mad(r4_y_8, 0.25, 0.75);
                    float r3_z_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r4_x_8 = max(r2_w_3, r3_z_1);
                    float4 r4_xyzw_9 = t1.Sample(s0, float4(r4_x_8, r4_z_8, r4_w_2, r4_x_8));
                    r4_x_10 = r4_xyzw_9.x;
                    r4_y_10 = r4_xyzw_9.y;
                    r4_z_10 = r4_xyzw_9.z;
                    r4_w_4 = r4_xyzw_9.w;
                }
                else
                {
                    float4 r4_xyzw_10 = float4(1, 1, 1, 1);
                    r4_x_10 = r4_xyzw_10.x;
                    r4_y_10 = r4_xyzw_10.y;
                    r4_z_10 = r4_xyzw_10.z;
                    r4_w_4 = r4_xyzw_10.w;
                }
                float r2_w_5 = dot(float4(r4_x_10, r4_y_10, r4_z_10, r4_w_4), unity_OcclusionMaskSelector);
                float4 r3_xyzw_5 = t0.Sample(s1, (((mad(cb0_values[6].xyxx, i.texcoord1.zzzz, (mad(cb0_values[4].xyxx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx);
                float r2_w_6 = (r2_w_5 * r3_xyzw_5.w);
                float4 r3_xyzw_6 = (r2_w_6.xxxx * _LightColor0.xyzx);
                float r3_x_6 = r3_xyzw_6.x;
                float r3_y_6 = r3_xyzw_6.y;
                float r3_z_4 = r3_xyzw_6.z;
                float r2_w_7 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r2_w_8 = rsqrt(r2_w_7);
                float3 unitWorldNormal_xyz_11 = ((r2_w_8.xxxx * i.texcoord0.xyzx)).xyz;
                float4 r2_xyzw_4 = (float4(r2_x_3, r2_y_1, r2_z_1, r2_x_3) * float4(0.7790837, 0.7790837, 0.7790837, 0));
                float r2_x_4 = r2_xyzw_4.x;
                float r2_y_2 = r2_xyzw_4.y;
                float r2_z_2 = r2_xyzw_4.z;
                float r1_w_7 = (-r1_w_6 + 1);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitWorldNormal_xyz_11.xyzx, unitViewDir_xyz_1.xyzx);
                float r1_x_2 = dot(unitWorldNormal_xyz_11.xyzx, _WorldSpaceLightPos0.xyzx);
                float r1_y_2 = dot(unitWorldNormal_xyz_11.xyzx, r0_xyz_3.xyzx);
                float r0_x_4 = dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_7.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(nDotV_w_6) + 1);
                float r2_w_9 = (r1_z_4 * r1_z_4);
                float r2_w_10 = (r2_w_9 * r2_w_9);
                float r1_z_5 = (r1_z_4 * r2_w_10);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_7 * r1_w_7);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_z_6 = (-r0_z_8 + 1);
                float r1_w_8 = mad(abs(nDotV_w_6), r1_z_6, r0_z_8);
                float r1_z_7 = mad(r1_x_2, r1_z_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * r1_z_7);
                float r0_w_8 = mad(r1_x_2, r1_w_8, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_z_8 = mad(r1_y_2, r0_z_9, -r1_y_2);
                float r1_y_3 = mad(r1_z_8, r1_y_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r0_z_11 = (r0_z_10 / r1_y_4);
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float r0_z_14 = max(r0_z_13, 0.0001);
                float r0_z_15 = sqrt(r0_z_14);
                float4 r0_xyzw_9 = (r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_z_15, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_16 = r0_xyzw_9.z;
                float4 r1_xyzw_3 = (r0_y_9.xxxx * float4(r3_x_6, r3_y_6, r3_z_4, r3_x_6));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_5 = r1_xyzw_3.y;
                float r1_z_9 = r1_xyzw_3.z;
                float4 r0_xyzw_10 = (float4(r3_x_6, r3_x_6, r3_y_6, r3_z_4) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_11 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_9 = (r0_x_5 * r0_x_5);
                float r1_w_10 = (r1_w_9 * r1_w_9);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r1_w_10), 0.7790837, 0.2209163)).xxxx * float4(r0_y_10, r0_z_17, r0_w_11, r0_y_10));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_11 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                o.sv_Target0.xyz = (mad(float4(r2_x_4, r2_y_2, r2_z_2, r2_x_4), float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[14];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb3_values[7];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            TextureCube t1 : register(t1);
            Texture3D t2 : register(t2);
            struct program44Input
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
            struct program44Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program90Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program90Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program44Output vert(program44Input i)
            {
                program44Output o = (program44Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = (mad(unity_WorldToObject[3].xyzx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyzx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program90Output frag(program90Input i)
            {
                program90Output o = (program90Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r1_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r1_w_2 = rsqrt(r1_w_1);
                float3 unitViewDir_xyz_2 = ((r1_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_3 = log2(cb0_values[10].x);
                float r1_w_4 = (r1_w_3 * cb0_values[13].x);
                float r1_w_5 = exp2(r1_w_4);
                float r1_w_6 = (-r1_w_5 + 1);
                float r2_w_1 = (r1_w_6 * cb0_values[12].x);
                float r2_w_2 = r2_w_1;
                float r1_w_7 = mad(r1_w_6, cb0_values[12].y, cb0_values[9].x);
                float r1_w_8 = (r1_w_7 + cb0_values[12].z);
                float3 r4_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord1.zzzz, (mad(cb0_values[4].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r2_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r2_w_3)
                {
                    float r2_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r5_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r2_w_4.xxxx ? r5_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r5_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r2_w_5 = mad(r5_y_8, 0.25, 0.75);
                    float r3_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r5_x_8 = max(r2_w_5, r3_w_1);
                    float4 r5_xyzw_9 = t2.Sample(s0, float4(r5_x_8, r5_z_8, r5_w_2, r5_x_8));
                    r5_x_10 = r5_xyzw_9.x;
                    r5_y_10 = r5_xyzw_9.y;
                    r5_z_10 = r5_xyzw_9.z;
                    r5_w_4 = r5_xyzw_9.w;
                }
                else
                {
                    float4 r5_xyzw_10 = float4(1, 1, 1, 1);
                    r5_x_10 = r5_xyzw_10.x;
                    r5_y_10 = r5_xyzw_10.y;
                    r5_z_10 = r5_xyzw_10.z;
                    r5_w_4 = r5_xyzw_10.w;
                }
                float r2_w_7 = dot(float4(r5_x_10, r5_y_10, r5_z_10, r5_w_4), unity_OcclusionMaskSelector);
                float r3_w_3 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float4 r5_xyzw_11 = t0.Sample(s2, r3_w_3.xxxx);
                float4 r4_xyzw_5 = t1.Sample(s1, r4_xyz_4.xyzx);
                float r3_w_4 = (r4_xyzw_5.w * r5_xyzw_11.x);
                float r2_w_8 = (r2_w_7 * r3_w_4);
                float3 r4_xyz_6 = ((r2_w_8.xxxx * _LightColor0.xyzx)).xyz;
                float r2_w_9 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r2_w_10 = rsqrt(r2_w_9);
                float3 unitWorldNormal_xyz_12 = ((r2_w_10.xxxx * i.texcoord0.xyzx)).xyz;
                float r1_w_9 = (-r1_w_8 + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_2.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitWorldNormal_xyz_12.xyzx, unitViewDir_xyz_2.xyzx);
                float r2_x_3 = dot(unitWorldNormal_xyz_12.xyzx, r1_xyz_1.xyzx);
                float r2_y_3 = dot(unitWorldNormal_xyz_12.xyzx, r0_xyz_3.xyzx);
                float r0_x_4 = dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_9.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_x_3 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(nDotV_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_9 * r1_w_9);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(nDotV_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * mad(r2_x_3, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_x_3, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r2_y_3, r0_z_9, -r2_y_3), r2_y_3, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float r0_z_14 = max(r0_z_13, 0.0001);
                float r0_z_15 = sqrt(r0_z_14);
                float4 r0_xyzw_9 = (r2_x_3.xxxx * float4(r0_y_8, r0_y_8, r0_z_15, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_16 = r0_xyzw_9.z;
                float4 r1_xyzw_11 = (r0_y_9.xxxx * r4_xyz_6.xyzx);
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (r4_xyz_6.xxyz * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_11 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_10 = (r0_x_5 * r0_x_5);
                float r1_w_11 = (r1_w_10 * r1_w_10);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r1_w_11), 0.7790837, 0.2209163)).xxxx * float4(r0_y_10, r0_z_17, r0_w_11, r0_y_10));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_11 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                o.sv_Target0.xyz = (mad((((mad(r2_w_2.xxxx, -cb0_values[8].xyzx, cb0_values[8].xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[14];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb3_values[7];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture3D t2 : register(t2);
            struct program43Input
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
            struct program43Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program89Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program89Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program43Output vert(program43Input i)
            {
                program43Output o = (program43Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 r1_xyzw_3 = (r0_xyzw_4.yyyy * unity_WorldToObject[1]);
                float4 r1_xyzw_4 = mad(unity_WorldToObject[0], r0_xyzw_4.xxxx, r1_xyzw_3);
                float4 r1_xyzw_5 = mad(unity_WorldToObject[2], r0_xyzw_4.zzzz, r1_xyzw_4);
                o.texcoord2.xyzw = mad(unity_WorldToObject[3], r0_xyzw_4.wwww, r1_xyzw_5);
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program89Output frag(program89Input i)
            {
                program89Output o = (program89Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r1_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r1_w_2 = rsqrt(r1_w_1);
                float3 unitViewDir_xyz_2 = ((r1_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_3 = log2(cb0_values[10].x);
                float r1_w_4 = (r1_w_3 * cb0_values[13].x);
                float r1_w_5 = exp2(r1_w_4);
                float r1_w_6 = (-r1_w_5 + 1);
                float r2_w_1 = (r1_w_6 * cb0_values[12].x);
                float r2_w_2 = r2_w_1;
                float r1_w_7 = mad(r1_w_6, cb0_values[12].y, cb0_values[9].x);
                float r1_w_8 = (r1_w_7 + cb0_values[12].z);
                float4 r4_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord1.zzzz, mad(cb0_values[4].xyzw, i.texcoord1.xxxx, (i.texcoord1.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r2_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r2_w_3)
                {
                    float r2_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r5_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r2_w_4.xxxx ? r5_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r5_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r2_w_5 = mad(r5_y_8, 0.25, 0.75);
                    float r3_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r5_x_8 = max(r2_w_5, r3_w_1);
                    float4 r5_xyzw_9 = t2.Sample(s0, float4(r5_x_8, r5_z_8, r5_w_2, r5_x_8));
                    r5_x_10 = r5_xyzw_9.x;
                    r5_y_10 = r5_xyzw_9.y;
                    r5_z_10 = r5_xyzw_9.z;
                    r5_w_4 = r5_xyzw_9.w;
                }
                else
                {
                    float4 r5_xyzw_10 = float4(1, 1, 1, 1);
                    r5_x_10 = r5_xyzw_10.x;
                    r5_y_10 = r5_xyzw_10.y;
                    r5_z_10 = r5_xyzw_10.z;
                    r5_w_4 = r5_xyzw_10.w;
                }
                float r2_w_7 = dot(float4(r5_x_10, r5_y_10, r5_z_10, r5_w_4), unity_OcclusionMaskSelector);
                float r3_w_3 = (0 < r4_xyzw_4.z);
                float r3_w_4 = asfloat(asint(r3_w_3) & asint(1065353216));
                float4 r5_xyzw_13 = t0.Sample(s1, ((((r4_xyzw_4.xyxx / r4_xyzw_4.wwww)).xyxx + float4(0.5, 0.5, 0, 0))).xyxx);
                float r3_w_5 = (r3_w_4 * r5_xyzw_13.w);
                float4 r4_xyzw_6 = t1.Sample(s2, (dot(r4_xyzw_4.xyzx, r4_xyzw_4.xyzx)).xxxx);
                float r3_w_6 = (r3_w_5 * r4_xyzw_6.x);
                float r2_w_8 = (r2_w_7 * r3_w_6);
                float4 r4_xyzw_7 = (r2_w_8.xxxx * _LightColor0.xyzx);
                float r4_x_7 = r4_xyzw_7.x;
                float r4_y_6 = r4_xyzw_7.y;
                float r4_z_6 = r4_xyzw_7.z;
                float r2_w_9 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r2_w_10 = rsqrt(r2_w_9);
                float4 unitWorldNormal_xyzw_14 = (r2_w_10.xxxx * i.texcoord0.xyzx);
                float unitWorldNormal_x_14 = unitWorldNormal_xyzw_14.x;
                float unitWorldNormal_y_14 = unitWorldNormal_xyzw_14.y;
                float unitWorldNormal_z_12 = unitWorldNormal_xyzw_14.z;
                float r1_w_9 = (-r1_w_8 + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_2.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(float4(unitWorldNormal_x_14, unitWorldNormal_y_14, unitWorldNormal_z_12, unitWorldNormal_x_14), unitViewDir_xyz_2.xyzx);
                float r2_x_3 = dot(float4(unitWorldNormal_x_14, unitWorldNormal_y_14, unitWorldNormal_z_12, unitWorldNormal_x_14), r1_xyz_1.xyzx);
                float r2_y_3 = dot(float4(unitWorldNormal_x_14, unitWorldNormal_y_14, unitWorldNormal_z_12, unitWorldNormal_x_14), r0_xyz_3.xyzx);
                float r0_x_4 = dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_9.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_x_3 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(nDotV_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_9 * r1_w_9);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(nDotV_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * mad(r2_x_3, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_x_3, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r2_y_3, r0_z_9, -r2_y_3), r2_y_3, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float r0_z_14 = max(r0_z_13, 0.0001);
                float r0_z_15 = sqrt(r0_z_14);
                float4 r0_xyzw_9 = (r2_x_3.xxxx * float4(r0_y_8, r0_y_8, r0_z_15, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_16 = r0_xyzw_9.z;
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r4_x_7, r4_y_6, r4_z_6, r4_x_7));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r4_x_7, r4_x_7, r4_y_6, r4_z_6) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_11 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_10 = (r0_x_5 * r0_x_5);
                float r1_w_11 = (r1_w_10 * r1_w_10);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r1_w_11), 0.7790837, 0.2209163)).xxxx * float4(r0_y_10, r0_z_17, r0_w_11, r0_y_10));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_11 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                o.sv_Target0.xyz = (mad((((mad(r2_w_2.xxxx, -cb0_values[8].xyzx, cb0_values[8].xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[10];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[21];
            };
            cbuffer UnityLighting : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[47];
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb3_values[7];
            };
            SamplerState s0 : register(s0);
            Texture3D t0 : register(t0);
            struct program42Input
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
            struct program42Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program88Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program88Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program42Output vert(program42Input i)
            {
                program42Output o = (program42Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord1.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord0.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program88Output frag(program88Input i)
            {
                program88Output o = (program88Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r1_w_1 = log2(cb0_values[6].x);
                float r1_w_2 = (r1_w_1 * cb0_values[9].x);
                float r1_w_3 = exp2(r1_w_2);
                float r1_w_4 = (-r1_w_3 + 1);
                float4 r2_xyzw_3 = mad(((r1_w_4 * cb0_values[8].x)).xxxx, -cb0_values[4].xyzx, cb0_values[4].xyzx);
                float r2_x_3 = r2_xyzw_3.x;
                float r2_y_1 = r2_xyzw_3.y;
                float r2_z_1 = r2_xyzw_3.z;
                float r1_w_5 = mad(r1_w_4, cb0_values[8].y, cb0_values[5].x);
                float r1_w_6 = (r1_w_5 + cb0_values[8].z);
                float r2_w_1 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_11;
                float r3_z_10;
                float r3_w_4;
                if (r2_w_1)
                {
                    float r2_w_2 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r2_w_2.xxxx ? r3_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r2_w_3 = mad(r3_y_8, 0.25, 0.75);
                    float r3_y_9 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r2_w_3, r3_y_9);
                    float4 r3_xyzw_9 = t0.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
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
                float r2_w_5 = dot(float4(r3_x_10, r3_y_11, r3_z_10, r3_w_4), unity_OcclusionMaskSelector);
                float4 r3_xyzw_11 = (r2_w_5.xxxx * _LightColor0.xyzx);
                float r3_x_11 = r3_xyzw_11.x;
                float r3_y_12 = r3_xyzw_11.y;
                float r3_z_11 = r3_xyzw_11.z;
                float r2_w_6 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r2_w_7 = rsqrt(r2_w_6);
                float3 unitWorldNormal_xyz_1 = ((r2_w_7.xxxx * i.texcoord0.xyzx)).xyz;
                float4 r2_xyzw_4 = (float4(r2_x_3, r2_y_1, r2_z_1, r2_x_3) * float4(0.7790837, 0.7790837, 0.7790837, 0));
                float r2_x_4 = r2_xyzw_4.x;
                float r2_y_2 = r2_xyzw_4.y;
                float r2_z_2 = r2_xyzw_4.z;
                float r1_w_7 = (-r1_w_6 + 1);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitWorldNormal_xyz_1.xyzx, unitViewDir_xyz_1.xyzx);
                float r1_x_2 = dot(unitWorldNormal_xyz_1.xyzx, _WorldSpaceLightPos0.xyzx);
                float r1_y_2 = dot(unitWorldNormal_xyz_1.xyzx, r0_xyz_3.xyzx);
                float r0_x_4 = dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_7.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(nDotV_w_6) + 1);
                float r2_w_8 = (r1_z_4 * r1_z_4);
                float r2_w_9 = (r2_w_8 * r2_w_8);
                float r1_z_5 = (r1_z_4 * r2_w_9);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_7 * r1_w_7);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_z_6 = (-r0_z_8 + 1);
                float r1_w_8 = mad(abs(nDotV_w_6), r1_z_6, r0_z_8);
                float r1_z_7 = mad(r1_x_2, r1_z_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * r1_z_7);
                float r0_w_8 = mad(r1_x_2, r1_w_8, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_z_8 = mad(r1_y_2, r0_z_9, -r1_y_2);
                float r1_y_3 = mad(r1_z_8, r1_y_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r0_z_11 = (r0_z_10 / r1_y_4);
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float r0_z_14 = max(r0_z_13, 0.0001);
                float r0_z_15 = sqrt(r0_z_14);
                float4 r0_xyzw_9 = (r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_z_15, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_16 = r0_xyzw_9.z;
                float4 r1_xyzw_3 = (r0_y_9.xxxx * float4(r3_x_11, r3_y_12, r3_z_11, r3_x_11));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_5 = r1_xyzw_3.y;
                float r1_z_9 = r1_xyzw_3.z;
                float4 r0_xyzw_10 = (float4(r3_x_11, r3_x_11, r3_y_12, r3_z_11) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_11 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_9 = (r0_x_5 * r0_x_5);
                float r1_w_10 = (r1_w_9 * r1_w_9);
                float4 r0_xyzw_8 = ((mad((r0_x_5 * r1_w_10), 0.7790837, 0.2209163)).xxxx * float4(r0_y_10, r0_z_17, r0_w_11, r0_y_10));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_11 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                o.sv_Target0.xyz = (mad(float4(r2_x_4, r2_y_2, r2_z_2, r2_x_4), float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_8, r0_y_11, r0_z_18, r0_x_8))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="DEFERRED" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 _Oceancolor;
                float4 _OceanGlossiness;
                float4 _OceanAO;
                float4 _OceanEmission;
                float _AOalbedo;
                float _AOsmoothness;
                float _SmoothnessShift;
                float _EmissionScale;
                float _AOintensity;
                float4 cb0_values[10];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4x4 unity_MatrixVP;
                float4 cb1_values[21];
            };
            struct program113Input
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
            struct program113Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program119Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program119Output
            {
                float4 sv_Target0 : SV_Target0;
                float4 sv_Target1 : SV_Target1;
                float4 sv_Target2 : SV_Target2;
                float4 sv_Target3 : SV_Target3;
            };
            #pragma vertex vert
            program113Output vert(program113Input i)
            {
                program113Output o = (program113Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord1.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord0.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program119Output frag(program119Input i)
            {
                program119Output o = (program119Output)0;
                float r0_x_3 = exp2((log2(_OceanAO.x) * _AOintensity));
                float r0_y_1 = (-r0_x_3 + 1);
                o.sv_Target0.w = r0_x_3;
                float r0_y_2 = mad(r0_y_1, _AOsmoothness, _OceanGlossiness.x);
                o.sv_Target1.w = (r0_y_2 + _SmoothnessShift);
                float4 r0_xyzw_6 = mad(((r0_y_1 * _AOalbedo)).xxxx, -_Oceancolor.xyzx, _Oceancolor.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_3 = r0_xyzw_6.y;
                float r0_z_1 = r0_xyzw_6.z;
                o.sv_Target0.xyz = ((float4(r0_x_6, r0_y_3, r0_z_1, r0_x_6) * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyz;
                o.sv_Target1.xyz = (float4(0.2209163, 0.2209163, 0.2209163, 0)).xyz;
                o.sv_Target2.xyz = (mad(i.texcoord0.xyzx, float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
                o.sv_Target2.w = 1;
                float4 r0_xyzw_7 = (_OceanEmission.xyzx * _EmissionScale.xxxx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_4 = r0_xyzw_7.y;
                float r0_z_2 = r0_xyzw_7.z;
                o.sv_Target3.xyz = (exp2(-float4(r0_x_7, r0_y_4, r0_z_2, r0_x_7))).xyz;
                o.sv_Target3.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="DEFERRED" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 _Oceancolor;
                float4 _OceanGlossiness;
                float4 _OceanAO;
                float4 _OceanEmission;
                float _AOalbedo;
                float _AOsmoothness;
                float _SmoothnessShift;
                float _EmissionScale;
                float _AOintensity;
                float4 cb0_values[46];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4x4 unity_MatrixVP;
                float4 cb1_values[42];
            };
            cbuffer cb2 : register(b2)
            {
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            Texture3D t0 : register(t0);
            struct program116Input
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
            struct program116Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
            };
            struct program122Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
            };
            struct program122Output
            {
                float4 sv_Target0 : SV_Target0;
                float4 sv_Target1 : SV_Target1;
                float4 sv_Target2 : SV_Target2;
                float4 sv_Target3 : SV_Target3;
            };
            #pragma vertex vert
            program116Output vert(program116Input i)
            {
                program116Output o = (program116Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                float3 unitWorldNormal_xyz_8 = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.texcoord0.xyz = (unitWorldNormal_xyz_8.xyzx).xyz;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                float r0_w_9 = (unitWorldNormal_xyz_8.y * unitWorldNormal_xyz_8.y);
                float r0_w_10 = mad(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.x, -r0_w_9);
                float4 r1_xyzw_2 = (unitWorldNormal_xyz_8.yzzx * unitWorldNormal_xyz_8.xyzz);
                float r0_x_9 = dot(cb0_values[42].xyzw, r1_xyzw_2);
                float r0_y_9 = dot(cb0_values[43].xyzw, r1_xyzw_2);
                float r0_z_9 = dot(cb0_values[44].xyzw, r1_xyzw_2);
                o.texcoord4.xyz = (mad(cb0_values[45].xyzx, r0_w_10.xxxx, float4(r0_x_9, r0_y_9, r0_z_9, r0_x_9))).xyz;
                return o;
            }
            #pragma fragment frag
            program122Output frag(program122Input i)
            {
                program122Output o = (program122Output)0;
                float r0_w_1 = exp2((log2(_OceanAO.x) * _AOintensity));
                float r1_x_1 = (-r0_w_1 + 1);
                float r1_y_1 = (r1_x_1 * _AOalbedo);
                float r1_y_2 = r1_y_1;
                float4 r1_xyzw_3 = mad(r1_y_2.xxxx, -_Oceancolor.xxyz, _Oceancolor.xxyz);
                float r1_y_3 = r1_xyzw_3.y;
                float r1_z_1 = r1_xyzw_3.z;
                float r1_w_1 = r1_xyzw_3.w;
                o.sv_Target1.w = (mad(r1_x_1, _AOsmoothness, _OceanGlossiness.x) + _SmoothnessShift);
                float3 TEXCOORD0_xyz_1;
                float r3_x_5;
                float r3_y_4;
                float r3_z_4;
                if ((cb2_values[0].x == 1))
                {
                    float3 r2_xyz_5 = (((mad(cb2_values[3].xyzx, i.texcoord1.zzzz, (mad(cb2_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb2_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb2_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (((((((cb2_values[0].y == 1)).xxxx ? r2_xyz_5.xyzx : i.texcoord1.xyzx)).xyzx + -cb2_values[6].xyzx)).xxyz * cb2_values[5].xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_8 = r2_xyzw_8.z;
                    float r2_w_2 = r2_xyzw_8.w;
                    float r2_y_9 = (cb2_values[0].z * 0.5);
                    float r2_x_8 = min(mad(-cb2_values[0].z, 0.5, 0.25), max((r2_y_8 * 0.25), r2_y_9));
                    float4 r3_xyzw_3 = t0.Sample(s0, float4(r2_x_8, r2_z_8, r2_w_2, r2_x_8));
                    float4 r4_xyzw_2 = t0.Sample(s0, ((float4(r2_x_8, r2_z_8, r2_w_2, r2_x_8) + float4(0.25, 0, 0, 0))).xyzx);
                    float4 r2_xyzw_9 = (float4(r2_x_8, r2_z_8, r2_w_2, r2_x_8) + float4(0.5, 0, 0, 0));
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_10 = r2_xyzw_9.y;
                    float r2_z_9 = r2_xyzw_9.z;
                    float4 r2_xyzw_10 = t0.Sample(s0, float4(r2_x_9, r2_y_10, r2_z_9, r2_x_9));
                    TEXCOORD0_xyz_1 = (i.texcoord0.xyzx).xyz;
                    float r5_w_1 = 1;
                    float r3_x_4 = dot(r3_xyzw_3, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    float r3_y_3 = dot(r4_xyzw_2, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    float r3_z_3 = dot(r2_xyzw_10, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    r3_x_5 = r3_x_4;
                    r3_y_4 = r3_y_3;
                    r3_z_4 = r3_z_3;
                }
                else
                {
                    TEXCOORD0_xyz_1 = (i.texcoord0.xyzx).xyz;
                    float r2_w_1 = 1;
                    float r3_x_1 = dot(cb1_values[39].xyzw, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r2_w_1));
                    float r3_y_1 = dot(cb1_values[40].xyzw, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r2_w_1));
                    float r3_z_1 = dot(cb1_values[41].xyzw, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r2_w_1));
                    r3_x_5 = r3_x_1;
                    r3_y_4 = r3_y_1;
                    r3_z_4 = r3_z_1;
                }
                float4 r2_xyzw_12 = (float4(r3_x_5, r3_y_4, r3_z_4, r3_x_5) + i.texcoord4.xyzx);
                float r2_x_12 = r2_xyzw_12.x;
                float r2_y_13 = r2_xyzw_12.y;
                float r2_z_12 = r2_xyzw_12.z;
                float4 r2_xyzw_13 = max(float4(r2_x_12, r2_y_13, r2_z_12, r2_x_12), float4(0, 0, 0, 0));
                float r2_x_13 = r2_xyzw_13.x;
                float r2_y_14 = r2_xyzw_13.y;
                float r2_z_13 = r2_xyzw_13.z;
                float4 r2_xyzw_14 = log2(float4(r2_x_13, r2_y_14, r2_z_13, r2_x_13));
                float r2_x_14 = r2_xyzw_14.x;
                float r2_y_15 = r2_xyzw_14.y;
                float r2_z_14 = r2_xyzw_14.z;
                float4 r2_xyzw_15 = (float4(r2_x_14, r2_y_15, r2_z_14, r2_x_14) * float4(0.41666666, 0.41666666, 0.41666666, 0));
                float r2_x_15 = r2_xyzw_15.x;
                float r2_y_16 = r2_xyzw_15.y;
                float r2_z_15 = r2_xyzw_15.z;
                float4 r2_xyzw_16 = exp2(float4(r2_x_15, r2_y_16, r2_z_15, r2_x_15));
                float r2_x_16 = r2_xyzw_16.x;
                float r2_y_17 = r2_xyzw_16.y;
                float r2_z_16 = r2_xyzw_16.z;
                float4 r2_xyzw_17 = mad(float4(r2_x_16, r2_y_17, r2_z_16, r2_x_16), float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0));
                float r2_x_17 = r2_xyzw_17.x;
                float r2_y_18 = r2_xyzw_17.y;
                float r2_z_17 = r2_xyzw_17.z;
                float4 r2_xyzw_18 = max(float4(r2_x_17, r2_y_18, r2_z_17, r2_x_17), float4(0, 0, 0, 0));
                float r2_x_18 = r2_xyzw_18.x;
                float r2_y_19 = r2_xyzw_18.y;
                float r2_z_18 = r2_xyzw_18.z;
                float4 r2_xyzw_19 = (r0_w_1.xxxx * float4(r2_x_18, r2_y_19, r2_z_18, r2_x_18));
                float r2_x_19 = r2_xyzw_19.x;
                float r2_y_20 = r2_xyzw_19.y;
                float r2_z_19 = r2_xyzw_19.z;
                float4 r0_xyzw_3 = (float4(r1_y_3, r1_z_1, r1_w_1, r1_y_3) * float4(0.7790837, 0.7790837, 0.7790837, 0));
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float4 r1_xyzw_8 = (float4(r2_x_19, r2_y_20, r2_z_19, r2_x_19) * float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3));
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_4 = r1_xyzw_8.y;
                float r1_z_2 = r1_xyzw_8.z;
                o.sv_Target3.xyz = (mad(_OceanEmission.xyzx, _EmissionScale.xxxx, float4(r1_x_8, r1_y_4, r1_z_2, r1_x_8))).xyz;
                o.sv_Target0.xyzw = float4(r0_x_3, r0_y_1, r0_z_1, r0_w_1);
                o.sv_Target1.xyz = (float4(0.2209163, 0.2209163, 0.2209163, 0)).xyz;
                o.sv_Target2.xyz = (mad(i.texcoord0.xyzx, float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
                o.sv_Target2.w = 1;
                o.sv_Target3.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="DEFERRED" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 _Oceancolor;
                float4 _OceanGlossiness;
                float4 _OceanAO;
                float4 _OceanEmission;
                float _AOalbedo;
                float _AOsmoothness;
                float _SmoothnessShift;
                float _EmissionScale;
                float _AOintensity;
                float4 cb0_values[10];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4x4 unity_MatrixVP;
                float4 cb1_values[21];
            };
            struct program115Input
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
            struct program115Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program121Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program121Output
            {
                float4 sv_Target0 : SV_Target0;
                float4 sv_Target1 : SV_Target1;
                float4 sv_Target2 : SV_Target2;
                float4 sv_Target3 : SV_Target3;
            };
            #pragma vertex vert
            program115Output vert(program115Input i)
            {
                program115Output o = (program115Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord1.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord0.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program121Output frag(program121Input i)
            {
                program121Output o = (program121Output)0;
                float r0_x_3 = exp2((log2(_OceanAO.x) * _AOintensity));
                float r0_y_1 = (-r0_x_3 + 1);
                o.sv_Target0.w = r0_x_3;
                float r0_y_2 = mad(r0_y_1, _AOsmoothness, _OceanGlossiness.x);
                o.sv_Target1.w = (r0_y_2 + _SmoothnessShift);
                float4 r0_xyzw_6 = mad(((r0_y_1 * _AOalbedo)).xxxx, -_Oceancolor.xyzx, _Oceancolor.xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_3 = r0_xyzw_6.y;
                float r0_z_1 = r0_xyzw_6.z;
                o.sv_Target0.xyz = ((float4(r0_x_6, r0_y_3, r0_z_1, r0_x_6) * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyz;
                o.sv_Target1.xyz = (float4(0.2209163, 0.2209163, 0.2209163, 0)).xyz;
                o.sv_Target2.xyz = (mad(i.texcoord0.xyzx, float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
                o.sv_Target2.w = 1;
                o.sv_Target3.xyz = ((_OceanEmission.xyzx * _EmissionScale.xxxx)).xyz;
                o.sv_Target3.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="DEFERRED" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 _Oceancolor;
                float4 _OceanGlossiness;
                float4 _OceanAO;
                float4 _OceanEmission;
                float _AOalbedo;
                float _AOsmoothness;
                float _SmoothnessShift;
                float _EmissionScale;
                float _AOintensity;
                float4 cb0_values[46];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4x4 unity_MatrixVP;
                float4 cb1_values[42];
            };
            cbuffer cb2 : register(b2)
            {
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            Texture3D t0 : register(t0);
            struct program114Input
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
            struct program114Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
            };
            struct program120Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
            };
            struct program120Output
            {
                float4 sv_Target0 : SV_Target0;
                float4 sv_Target1 : SV_Target1;
                float4 sv_Target2 : SV_Target2;
                float4 sv_Target3 : SV_Target3;
            };
            #pragma vertex vert
            program114Output vert(program114Input i)
            {
                program114Output o = (program114Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                float3 unitWorldNormal_xyz_8 = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.texcoord0.xyz = (unitWorldNormal_xyz_8.xyzx).xyz;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                float r0_w_9 = (unitWorldNormal_xyz_8.y * unitWorldNormal_xyz_8.y);
                float r0_w_10 = mad(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.x, -r0_w_9);
                float4 r1_xyzw_2 = (unitWorldNormal_xyz_8.yzzx * unitWorldNormal_xyz_8.xyzz);
                float r0_x_9 = dot(cb0_values[42].xyzw, r1_xyzw_2);
                float r0_y_9 = dot(cb0_values[43].xyzw, r1_xyzw_2);
                float r0_z_9 = dot(cb0_values[44].xyzw, r1_xyzw_2);
                o.texcoord4.xyz = (mad(cb0_values[45].xyzx, r0_w_10.xxxx, float4(r0_x_9, r0_y_9, r0_z_9, r0_x_9))).xyz;
                return o;
            }
            #pragma fragment frag
            program120Output frag(program120Input i)
            {
                program120Output o = (program120Output)0;
                float r0_w_1 = exp2((log2(_OceanAO.x) * _AOintensity));
                float r1_x_1 = (-r0_w_1 + 1);
                float r1_y_1 = (r1_x_1 * _AOalbedo);
                float r1_y_2 = r1_y_1;
                float4 r1_xyzw_3 = mad(r1_y_2.xxxx, -_Oceancolor.xxyz, _Oceancolor.xxyz);
                float r1_y_3 = r1_xyzw_3.y;
                float r1_z_1 = r1_xyzw_3.z;
                float r1_w_1 = r1_xyzw_3.w;
                o.sv_Target1.w = (mad(r1_x_1, _AOsmoothness, _OceanGlossiness.x) + _SmoothnessShift);
                float3 TEXCOORD0_xyz_1;
                float r3_x_5;
                float r3_y_4;
                float r3_z_4;
                if ((cb2_values[0].x == 1))
                {
                    float3 r2_xyz_5 = (((mad(cb2_values[3].xyzx, i.texcoord1.zzzz, (mad(cb2_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb2_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb2_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (((((((cb2_values[0].y == 1)).xxxx ? r2_xyz_5.xyzx : i.texcoord1.xyzx)).xyzx + -cb2_values[6].xyzx)).xxyz * cb2_values[5].xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_8 = r2_xyzw_8.z;
                    float r2_w_2 = r2_xyzw_8.w;
                    float r2_y_9 = (cb2_values[0].z * 0.5);
                    float r2_x_8 = min(mad(-cb2_values[0].z, 0.5, 0.25), max((r2_y_8 * 0.25), r2_y_9));
                    float4 r3_xyzw_3 = t0.Sample(s0, float4(r2_x_8, r2_z_8, r2_w_2, r2_x_8));
                    float4 r4_xyzw_2 = t0.Sample(s0, ((float4(r2_x_8, r2_z_8, r2_w_2, r2_x_8) + float4(0.25, 0, 0, 0))).xyzx);
                    float4 r2_xyzw_9 = (float4(r2_x_8, r2_z_8, r2_w_2, r2_x_8) + float4(0.5, 0, 0, 0));
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_10 = r2_xyzw_9.y;
                    float r2_z_9 = r2_xyzw_9.z;
                    float4 r2_xyzw_10 = t0.Sample(s0, float4(r2_x_9, r2_y_10, r2_z_9, r2_x_9));
                    TEXCOORD0_xyz_1 = (i.texcoord0.xyzx).xyz;
                    float r5_w_1 = 1;
                    float r3_x_4 = dot(r3_xyzw_3, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    float r3_y_3 = dot(r4_xyzw_2, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    float r3_z_3 = dot(r2_xyzw_10, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    r3_x_5 = r3_x_4;
                    r3_y_4 = r3_y_3;
                    r3_z_4 = r3_z_3;
                }
                else
                {
                    TEXCOORD0_xyz_1 = (i.texcoord0.xyzx).xyz;
                    float r2_w_1 = 1;
                    float r3_x_1 = dot(cb1_values[39].xyzw, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r2_w_1));
                    float r3_y_1 = dot(cb1_values[40].xyzw, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r2_w_1));
                    float r3_z_1 = dot(cb1_values[41].xyzw, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r2_w_1));
                    r3_x_5 = r3_x_1;
                    r3_y_4 = r3_y_1;
                    r3_z_4 = r3_z_1;
                }
                float4 r2_xyzw_12 = (float4(r3_x_5, r3_y_4, r3_z_4, r3_x_5) + i.texcoord4.xyzx);
                float r2_x_12 = r2_xyzw_12.x;
                float r2_y_13 = r2_xyzw_12.y;
                float r2_z_12 = r2_xyzw_12.z;
                float4 r2_xyzw_13 = max(float4(r2_x_12, r2_y_13, r2_z_12, r2_x_12), float4(0, 0, 0, 0));
                float r2_x_13 = r2_xyzw_13.x;
                float r2_y_14 = r2_xyzw_13.y;
                float r2_z_13 = r2_xyzw_13.z;
                float4 r2_xyzw_14 = log2(float4(r2_x_13, r2_y_14, r2_z_13, r2_x_13));
                float r2_x_14 = r2_xyzw_14.x;
                float r2_y_15 = r2_xyzw_14.y;
                float r2_z_14 = r2_xyzw_14.z;
                float4 r2_xyzw_15 = (float4(r2_x_14, r2_y_15, r2_z_14, r2_x_14) * float4(0.41666666, 0.41666666, 0.41666666, 0));
                float r2_x_15 = r2_xyzw_15.x;
                float r2_y_16 = r2_xyzw_15.y;
                float r2_z_15 = r2_xyzw_15.z;
                float4 r2_xyzw_16 = exp2(float4(r2_x_15, r2_y_16, r2_z_15, r2_x_15));
                float r2_x_16 = r2_xyzw_16.x;
                float r2_y_17 = r2_xyzw_16.y;
                float r2_z_16 = r2_xyzw_16.z;
                float4 r2_xyzw_17 = mad(float4(r2_x_16, r2_y_17, r2_z_16, r2_x_16), float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0));
                float r2_x_17 = r2_xyzw_17.x;
                float r2_y_18 = r2_xyzw_17.y;
                float r2_z_17 = r2_xyzw_17.z;
                float4 r2_xyzw_18 = max(float4(r2_x_17, r2_y_18, r2_z_17, r2_x_17), float4(0, 0, 0, 0));
                float r2_x_18 = r2_xyzw_18.x;
                float r2_y_19 = r2_xyzw_18.y;
                float r2_z_18 = r2_xyzw_18.z;
                float4 r2_xyzw_19 = (r0_w_1.xxxx * float4(r2_x_18, r2_y_19, r2_z_18, r2_x_18));
                float r2_x_19 = r2_xyzw_19.x;
                float r2_y_20 = r2_xyzw_19.y;
                float r2_z_19 = r2_xyzw_19.z;
                float4 r0_xyzw_3 = (float4(r1_y_3, r1_z_1, r1_w_1, r1_y_3) * float4(0.7790837, 0.7790837, 0.7790837, 0));
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float4 r1_xyzw_8 = (float4(r2_x_19, r2_y_20, r2_z_19, r2_x_19) * float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3));
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_4 = r1_xyzw_8.y;
                float r1_z_2 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = mad(_OceanEmission.xyzx, _EmissionScale.xxxx, float4(r1_x_8, r1_y_4, r1_z_2, r1_x_8));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_5 = r1_xyzw_9.y;
                float r1_z_3 = r1_xyzw_9.z;
                o.sv_Target3.xyz = (exp2(-float4(r1_x_9, r1_y_5, r1_z_3, r1_x_9))).xyz;
                o.sv_Target0.xyzw = float4(r0_x_3, r0_y_1, r0_z_1, r0_w_1);
                o.sv_Target1.xyz = (float4(0.2209163, 0.2209163, 0.2209163, 0)).xyz;
                o.sv_Target2.xyz = (mad(i.texcoord0.xyzx, float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
                o.sv_Target2.w = 1;
                o.sv_Target3.w = 1;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Diffuse"
}
