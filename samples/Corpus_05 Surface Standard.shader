Shader "Corpus/05 Surface Standard"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo", 2D) = "" {}
        _BumpMap ("Normal", 2D) = "" {}
        _BumpScale ("Normal Scale", Float) = 1
        _Metallic ("Metallic", Range(0, 1)) = 0
        _Glossiness ("Smoothness", Range(0, 1)) = 0.5
        _MetallicGlossMap ("Metallic Map", 2D) = "" {}
        _OcclusionMap ("Occlusion", 2D) = "" {}
        _OcclusionStrength ("Occlusion Strength", Range(0, 1)) = 1
        _EmissionColor ("Emission", Color) = (0,0,0,1)
        _EmissionMap ("Emission Map", 2D) = "" {}
        _Cutoff ("Alpha Cutoff", Range(0, 1)) = 0.5
        _DetailMask ("Detail Mask", 2D) = "" {}
        _DetailAlbedo ("Detail Albedo", 2D) = "" {}
        _DetailNormal ("Detail Normal", 2D) = "" {}
    }
    SubShader
    {
        Tags { "PerformanceChecks"="False" "QUEUE"="Geometry" "RenderType"="Opaque" }
        LOD 300
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "PerformanceChecks"="False" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float _BumpScale : packoffset(c4.x);
                float _Metallic : packoffset(c4.y);
                float _Glossiness : packoffset(c4.z);
                float _OcclusionStrength : packoffset(c4.w);
                float _Cutoff : packoffset(c5.x);
                float4 _Color : packoffset(c6);
                float4 _EmissionColor : packoffset(c7);
                float4 _MainTex_ST : packoffset(c8);
                float4 _BumpMap_ST : packoffset(c9);
                float4 _MetallicGlossMap_ST : packoffset(c10);
                float4 _OcclusionMap_ST : packoffset(c11);
                float4 _EmissionMap_ST : packoffset(c12);
                float4 _DetailMask_ST : packoffset(c13);
                float4 _DetailAlbedo_ST : packoffset(c14);
                float4 _DetailNormal_ST : packoffset(c15);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0 : packoffset(c0);
                float4x4 unity_MatrixVP : packoffset(c17);
                float4 unity_OcclusionMaskSelector : packoffset(c46);
            };
            cbuffer _UnityReflectionProbesCB_b3
            {
                float4 unity_SpecCube0_BoxMax : packoffset(c0);
                float4 unity_SpecCube0_BoxMin : packoffset(c1);
                float4 unity_SpecCube0_ProbePosition : packoffset(c2);
                float4 unity_SpecCube0_HDR : packoffset(c3);
                float4 unity_SpecCube1_BoxMax : packoffset(c4);
                float4 unity_SpecCube1_BoxMin : packoffset(c5);
                float4 unity_SpecCube1_ProbePosition : packoffset(c6);
                float4 unity_SpecCube1_HDR : packoffset(c7);
            };
            cbuffer _UnityProbeVolumeCB_b4
            {
                float4 unity_ProbeVolumeParams : packoffset(c0);
                float4x4 unity_ProbeVolumeWorldToObject : packoffset(c1);
                float3 unity_ProbeVolumeSizeInv : packoffset(c5);
                float3 unity_ProbeVolumeMin : packoffset(c6);
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_MainTex;
            SamplerState sampler_EmissionMap;
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_DetailAlbedo;
            SamplerState sampler_DetailNormal;
            SamplerState sampler_BumpMap;
            SamplerState sampler_MetallicGlossMap;
            SamplerState sampler_DetailMask;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _MetallicGlossMap;
            Texture2D _OcclusionMap;
            Texture2D _EmissionMap;
            Texture2D _DetailMask;
            Texture2D _DetailAlbedo;
            Texture2D _DetailNormal;
            TextureCube t8;
            TextureCube t9;
            Texture3D t10;
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
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 color0 : COLOR0;
                float4 texcoord8 : TEXCOORD8;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program18Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 color0 : COLOR0;
                float4 texcoord8 : TEXCOORD8;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program18Output
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
                float3 worldPos_xyz_4 = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _MetallicGlossMap_ST.xyxx, _MetallicGlossMap_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _OcclusionMap_ST.xxxy, _OcclusionMap_ST.zzzw)).zw;
                o.texcoord2.xy = (mad(i.texcoord0.xyxx, _EmissionMap_ST.xyxx, _EmissionMap_ST.zwzz)).xy;
                o.texcoord2.zw = (mad(i.texcoord0.xxxy, _DetailMask_ST.xxxy, _DetailMask_ST.zzzw)).zw;
                o.texcoord3.xy = (mad(i.texcoord0.xyxx, _DetailAlbedo_ST.xyxx, _DetailAlbedo_ST.zwzz)).xy;
                o.texcoord3.zw = (mad(i.texcoord0.xxxy, _DetailNormal_ST.xxxy, _DetailNormal_ST.zzzw)).zw;
                o.texcoord4.w = worldPos_xyz_4.x;
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float3 unitWorldNormal_xyz_3 = (((rsqrt(dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2)))).xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = (((rsqrt(dot(worldTangent_xyz_6.xyzx, worldTangent_xyz_6.xyzx))).xxxx * worldTangent_xyz_6.xyzx)).xyz;
                float3 r3_xyz_3 = ((((i.tangent0.w * unity_WorldTransformParams.w)).xxxx * (mad(unitWorldNormal_xyz_3.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_3.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord4.y = r3_xyz_3.x;
                o.texcoord4.x = unitWorldTangent_xyz_7.z;
                o.texcoord4.z = unitWorldNormal_xyz_3.y;
                o.texcoord5.x = unitWorldTangent_xyz_7.x;
                o.texcoord6.x = unitWorldTangent_xyz_7.y;
                o.texcoord5.z = unitWorldNormal_xyz_3.z;
                o.texcoord6.z = unitWorldNormal_xyz_3.x;
                o.texcoord5.w = worldPos_xyz_4.y;
                o.texcoord6.w = worldPos_xyz_4.z;
                o.texcoord5.y = r3_xyz_3.y;
                o.texcoord6.y = r3_xyz_3.z;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord8.xyzw = float4(0, 0, 0, 0);
                o.texcoord9.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program18Output frag(program18Input i)
            {
                program18Output o = (program18Output)0;
                float TEXCOORD4_x_1 = i.texcoord4.w;
                float TEXCOORD5_y_1 = i.texcoord5.w;
                float TEXCOORD6_z_1 = i.texcoord6.w;
                float3 viewDir_xyz_1 = ((-float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1) + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float4 r3_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r3_xyz_2 = ((r3_xyzw_1.xyzx * _Color.xyzx)).xyz;
                float r1_w_1 = (_BumpMap.Sample(sampler_BumpMap, (i.texcoord2.zwzz).xy)).w;
                float3 r4_xyz_1 = (_MetallicGlossMap.Sample(sampler_MetallicGlossMap, (i.texcoord3.xyxx).xy)).xyz;
                float3 r4_xyz_3 = (mad(r1_w_1.xxxx, (mad(r4_xyz_1.xyzx, float4(2, 2, 2, 0), float4(-2, -2, -2, 0))).xyzx, float4(1, 1, 1, 0))).xyz;
                float2 r6_xy_1 = (_OcclusionMap.Sample(sampler_OcclusionMap, (i.texcoord1.xyxx).xy)).xy;
                float3 r7_xyz_1 = (_EmissionMap.Sample(sampler_EmissionMap, (i.texcoord0.zwzz).xy)).xyz;
                float r7_x_2 = (r7_xyz_1.z * r7_xyz_1.x);
                float2 r6_zw_1 = (mad(float4(r7_x_2, r7_x_2, r7_x_2, r7_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r7_xyzw_3 = (r6_zw_1.xyxx * _BumpScale.xxxx);
                float r7_x_3 = r7_xyzw_3.x;
                float r7_y_2 = r7_xyzw_3.y;
                float r2_w_1 = dot(float4(r7_x_3, r7_y_2, r7_x_3, r7_x_3), float4(r7_x_3, r7_y_2, r7_x_3, r7_x_3));
                float r2_w_2 = min(r2_w_1, 1);
                float r2_w_3 = (-r2_w_2 + 1);
                float r7_z_2 = sqrt(r2_w_3);
                float3 r8_xyz_1 = (_DetailMask.Sample(sampler_DetailMask, (i.texcoord3.zwzz).xy)).xyz;
                float r8_x_2 = (r8_xyz_1.z * r8_xyz_1.x);
                float2 r6_zw_2 = (mad(float4(r8_x_2, r8_x_2, r8_x_2, r8_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r8_xyzw_3 = (r6_zw_2.xyxx * _BumpScale.xxxx);
                float r8_x_3 = r8_xyzw_3.x;
                float r8_y_2 = r8_xyzw_3.y;
                float r2_w_4 = dot(float4(r8_x_3, r8_y_2, r8_x_3, r8_x_3), float4(r8_x_3, r8_y_2, r8_x_3, r8_x_3));
                float r2_w_5 = min(r2_w_4, 1);
                float r2_w_6 = (-r2_w_5 + 1);
                float r8_z_2 = sqrt(r2_w_6);
                float4 r7_xyzw_4 = mad(float4(r8_x_3, r8_y_2, r8_z_2, r8_x_3), r1_w_1.xxxx, float4(r7_x_3, r7_y_2, r7_z_2, r7_x_3));
                float r7_x_4 = r7_xyzw_4.x;
                float r7_y_3 = r7_xyzw_4.y;
                float r7_z_3 = r7_xyzw_4.z;
                float r1_w_2 = dot(float4(r7_x_4, r7_y_3, r7_z_3, r7_x_4), float4(r7_x_4, r7_y_3, r7_z_3, r7_x_4));
                float r1_w_3 = rsqrt(r1_w_2);
                float4 r7_xyzw_5 = (r1_w_3.xxxx * float4(r7_x_4, r7_y_3, r7_z_3, r7_x_4));
                float r7_x_5 = r7_xyzw_5.x;
                float r7_y_4 = r7_xyzw_5.y;
                float r7_z_4 = r7_xyzw_5.z;
                float r1_w_4 = (r6_xy_1.x * _Metallic);
                float r2_w_7 = (_DetailAlbedo.Sample(sampler_DetailAlbedo, (i.texcoord1.zwzz).xy)).w;
                float r2_w_8 = (r2_w_7 + -1);
                float r2_w_9 = mad(_OcclusionStrength, r2_w_8, 1);
                float4 r6_xyzw_2 = _DetailNormal.Sample(sampler_DetailNormal, (i.texcoord2.xyxx).xy);
                float r6_x_2 = r6_xyzw_2.x;
                float r6_z_3 = r6_xyzw_2.z;
                float r6_w_3 = r6_xyzw_2.w;
                float r3_w_2 = mad(r3_xyzw_1.w, _Color.w, -_Cutoff);
                float r3_w_3 = (r3_w_2 < 0);
                if (r3_w_3) discard;
                float r3_w_4 = (unity_ProbeVolumeParams.x == 1);
                float r8_x_13;
                float r8_y_12;
                float r8_z_12;
                float r8_w_4;
                if (r3_w_4)
                {
                    float r3_w_5 = (unity_ProbeVolumeParams.y == 1);
                    float4 r8_xyzw_5 = (i.texcoord5.wwww * unity_ProbeVolumeWorldToObject[1].xyzx);
                    float r8_x_5 = r8_xyzw_5.x;
                    float r8_y_4 = r8_xyzw_5.y;
                    float r8_z_4 = r8_xyzw_5.z;
                    float4 r8_xyzw_6 = mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord4.wwww, float4(r8_x_5, r8_y_4, r8_z_4, r8_x_5));
                    float r8_x_6 = r8_xyzw_6.x;
                    float r8_y_5 = r8_xyzw_6.y;
                    float r8_z_5 = r8_xyzw_6.z;
                    float4 r8_xyzw_7 = mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord6.wwww, float4(r8_x_6, r8_y_5, r8_z_5, r8_x_6));
                    float r8_x_7 = r8_xyzw_7.x;
                    float r8_y_6 = r8_xyzw_7.y;
                    float r8_z_6 = r8_xyzw_7.z;
                    float4 r8_xyzw_8 = (float4(r8_x_7, r8_y_6, r8_z_6, r8_x_7) + unity_ProbeVolumeWorldToObject[3].xyzx);
                    float r8_x_8 = r8_xyzw_8.x;
                    float r8_y_7 = r8_xyzw_8.y;
                    float r8_z_7 = r8_xyzw_8.z;
                    float4 unity_ProbeVolumeParamsSelect_xyzw_9 = (r3_w_5.xxxx ? float4(r8_x_8, r8_y_7, r8_z_7, r8_x_8) : float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1));
                    float unity_ProbeVolumeParamsSelect_x_9 = unity_ProbeVolumeParamsSelect_xyzw_9.x;
                    float unity_ProbeVolumeParamsSelect_y_8 = unity_ProbeVolumeParamsSelect_xyzw_9.y;
                    float unity_ProbeVolumeParamsSelect_z_8 = unity_ProbeVolumeParamsSelect_xyzw_9.z;
                    float4 r8_xyzw_10 = (float4(unity_ProbeVolumeParamsSelect_x_9, unity_ProbeVolumeParamsSelect_y_8, unity_ProbeVolumeParamsSelect_z_8, unity_ProbeVolumeParamsSelect_x_9) + -unity_ProbeVolumeMin.xyzx);
                    float r8_x_10 = r8_xyzw_10.x;
                    float r8_y_9 = r8_xyzw_10.y;
                    float r8_z_9 = r8_xyzw_10.z;
                    float r8_y_10 = ((float4(r8_x_10, r8_x_10, r8_y_9, r8_z_9) * unity_ProbeVolumeSizeInv.xxyz)).y;
                    float r8_z_10 = ((float4(r8_x_10, r8_x_10, r8_y_9, r8_z_9) * unity_ProbeVolumeSizeInv.xxyz)).z;
                    float r8_w_2 = ((float4(r8_x_10, r8_x_10, r8_y_9, r8_z_9) * unity_ProbeVolumeSizeInv.xxyz)).w;
                    float r3_w_6 = mad(r8_y_10, 0.25, 0.75);
                    float r4_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r8_x_11 = max(r3_w_6, r4_w_1);
                    float4 r8_xyzw_12 = t10.Sample(sampler_linear_clamp1, (float4(r8_x_11, r8_z_10, r8_w_2, r8_x_11)).xyz);
                    r8_x_13 = r8_xyzw_12.x;
                    r8_y_12 = r8_xyzw_12.y;
                    r8_z_12 = r8_xyzw_12.z;
                    r8_w_4 = r8_xyzw_12.w;
                }
                else
                {
                    float4 r8_xyzw_4 = float4(1, 1, 1, 1);
                    r8_x_13 = r8_xyzw_4.x;
                    r8_y_12 = r8_xyzw_4.y;
                    r8_z_12 = r8_xyzw_4.z;
                    r8_w_4 = r8_xyzw_4.w;
                }
                float r3_w_8 = saturate(dot(float4(r8_x_13, r8_y_12, r8_z_12, r8_w_4), unity_OcclusionMaskSelector));
                float r8_x_14 = dot(i.texcoord4.xyzx, float4(r7_x_5, r7_y_4, r7_z_4, r7_x_5));
                float r8_y_13 = dot(i.texcoord5.xyzx, float4(r7_x_5, r7_y_4, r7_z_4, r7_x_5));
                float r8_z_13 = dot(i.texcoord6.xyzx, float4(r7_x_5, r7_y_4, r7_z_4, r7_x_5));
                float r4_w_3 = dot(float4(r8_x_14, r8_y_13, r8_z_13, r8_x_14), float4(r8_x_14, r8_y_13, r8_z_13, r8_x_14));
                float r4_w_4 = rsqrt(r4_w_3);
                float4 r7_xyzw_6 = (r4_w_4.xxxx * float4(r8_x_14, r8_y_13, r8_z_13, r8_x_14));
                float r7_x_6 = r7_xyzw_6.x;
                float r7_y_5 = r7_xyzw_6.y;
                float r7_z_5 = r7_xyzw_6.z;
                float r4_w_5 = mad(-r6_xy_1.y, _Glossiness, 1);
                float r5_w_1 = dot(-unitViewDir_xyz_1.xyzx, float4(r7_x_6, r7_y_5, r7_z_5, r7_x_6));
                float r5_w_2 = (r5_w_1 + r5_w_1);
                float4 r8_xyzw_15 = mad(float4(r7_x_6, r7_y_5, r7_z_5, r7_x_6), -r5_w_2.xxxx, -unitViewDir_xyz_1.xyzx);
                float r8_x_15 = r8_xyzw_15.x;
                float r8_y_14 = r8_xyzw_15.y;
                float r8_z_14 = r8_xyzw_15.z;
                float3 r9_xyz_1 = ((r3_w_8.xxxx * _LightColor0.xyzx)).xyz;
                float r3_w_9 = (0 < unity_SpecCube0_ProbePosition.w);
                float3 r10_xyz_4;
                if (r3_w_9)
                {
                    float r3_w_10 = dot(float4(r8_x_15, r8_y_14, r8_z_14, r8_x_15), float4(r8_x_15, r8_y_14, r8_z_14, r8_x_15));
                    float r3_w_11 = rsqrt(r3_w_10);
                    float3 r10_xyz_2 = ((r3_w_11.xxxx * float4(r8_x_15, r8_y_14, r8_z_14, r8_x_15))).xyz;
                    float3 r13_xyz_1 = ((float4(0, 0, 0, 0) < r10_xyz_2.xyzx)).xyz;
                    float3 r11_xyz_3 = ((r13_xyz_1.xyzx ? ((((-float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1) + unity_SpecCube0_BoxMax.xyzx)).xyzx / r10_xyz_2.xyzx)).xyzx : ((((-float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1) + unity_SpecCube0_BoxMin.xyzx)).xyzx / r10_xyz_2.xyzx)).xyzx)).xyz;
                    float r3_w_12 = min(r11_xyz_3.y, r11_xyz_3.x);
                    float r3_w_13 = min(r11_xyz_3.z, r3_w_12);
                    r10_xyz_4 = (mad(r10_xyz_2.xyzx, r3_w_13.xxxx, ((float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1) + -unity_SpecCube0_ProbePosition.xyzx)).xyzx)).xyz;
                }
                else
                {
                    r10_xyz_4 = (float4(r8_x_15, r8_y_14, r8_z_14, r8_x_15)).xyz;
                }
                float r3_w_15 = mad(-r4_w_5, 0.7, 1.7);
                float r3_w_16 = (r3_w_15 * r4_w_5);
                float r3_w_17 = (r3_w_16 * 6);
                float4 r10_xyzw_5 = t8.SampleLevel(sampler_linear_clamp, r10_xyz_4.xyz, r3_w_17);
                float r5_w_3 = (r10_xyzw_5.w + -1);
                float r5_w_4 = mad(unity_SpecCube0_HDR.w, r5_w_3, 1);
                float r5_w_5 = log2(r5_w_4);
                float r5_w_6 = (r5_w_5 * unity_SpecCube0_HDR.y);
                float r5_w_7 = exp2(r5_w_6);
                float r5_w_8 = (r5_w_7 * unity_SpecCube0_HDR.x);
                float r7_w_1 = (unity_SpecCube0_BoxMin.w < 0.99999);
                float3 r11_xyz_8 = ((r10_xyzw_5.xyzx * r5_w_8.xxxx)).xyz;
                if (r7_w_1)
                {
                    float r7_w_2 = (0 < unity_SpecCube1_ProbePosition.w);
                    float r8_x_17 = r8_x_15;
                    float r8_y_16 = r8_y_14;
                    float r8_z_16 = r8_z_14;
                    if (r7_w_2)
                    {
                        float r7_w_3 = dot(float4(r8_x_15, r8_y_14, r8_z_14, r8_x_15), float4(r8_x_15, r8_y_14, r8_z_14, r8_x_15));
                        float r7_w_4 = rsqrt(r7_w_3);
                        float3 r12_xyz_4 = ((r7_w_4.xxxx * float4(r8_x_15, r8_y_14, r8_z_14, r8_x_15))).xyz;
                        float3 r15_xyz_1 = ((float4(0, 0, 0, 0) < r12_xyz_4.xyzx)).xyz;
                        float3 r13_xyz_5 = ((r15_xyz_1.xyzx ? ((((-float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1) + unity_SpecCube1_BoxMax.xyzx)).xyzx / r12_xyz_4.xyzx)).xyzx : ((((-float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1) + unity_SpecCube1_BoxMin.xyzx)).xyzx / r12_xyz_4.xyzx)).xyzx)).xyz;
                        float r7_w_5 = min(r13_xyz_5.y, r13_xyz_5.x);
                        float r7_w_6 = min(r13_xyz_5.z, r7_w_5);
                        float4 r8_xyzw_16 = mad(r12_xyz_4.xyzx, r7_w_6.xxxx, ((float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1) + -unity_SpecCube1_ProbePosition.xyzx)).xyzx);
                        float r8_x_16 = r8_xyzw_16.x;
                        float r8_y_15 = r8_xyzw_16.y;
                        float r8_z_15 = r8_xyzw_16.z;
                        r8_x_17 = r8_x_16;
                        r8_y_16 = r8_y_15;
                        r8_z_16 = r8_z_15;
                    }
                    float4 r8_xyzw_18 = t9.SampleLevel(sampler_linear_clamp, (float4(r8_x_17, r8_y_16, r8_z_16, r8_x_17)).xyz, r3_w_17);
                                        float4 r0_xyzw_10 = (r8_xyzw_18.xyzx * ((pow(mad(unity_SpecCube1_HDR.w, (r8_xyzw_18.w + -1), 1), unity_SpecCube1_HDR.y) * unity_SpecCube1_HDR.x)).xxxx);
                    float r0_x_10 = r0_xyzw_10.x;
                    float r0_y_4 = r0_xyzw_10.y;
                    float r0_z_4 = r0_xyzw_10.z;
                    float4 r8_xyzw_19 = mad(r5_w_8.xxxx, r10_xyzw_5.xyzx, -float4(r0_x_10, r0_y_4, r0_z_4, r0_x_10));
                    float r8_x_19 = r8_xyzw_19.x;
                    float r8_y_18 = r8_xyzw_19.y;
                    float r8_z_18 = r8_xyzw_19.z;
                    r11_xyz_8 = (mad(unity_SpecCube0_BoxMin.wwww, float4(r8_x_19, r8_y_18, r8_z_18, r8_x_19), float4(r0_x_10, r0_y_4, r0_z_4, r0_x_10))).xyz;
                }
                float4 r0_xyzw_12 = (r2_w_9.xxxx * r11_xyz_8.xyzx);
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_6 = r0_xyzw_12.y;
                float r0_z_6 = r0_xyzw_12.z;
                float3 r3_xyz_4 = (mad(r1_w_4.xxxx, (mad(r3_xyz_2.xyzx, r4_xyz_3.xyzx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_5 = mad(-r1_w_4, 0.96, 0.96);
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r1_xyz_3 = ((r0_w_5.xxxx * r1_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r7_x_6, r7_y_5, r7_z_5, r7_x_6), unitViewDir_xyz_1.xyzx);
                float r2_x_2 = saturate(dot(float4(r7_x_6, r7_y_5, r7_z_5, r7_x_6), _WorldSpaceLightPos0.xyzx));
                float r2_y_2 = saturate(dot(float4(r7_x_6, r7_y_5, r7_z_5, r7_x_6), r1_xyz_3.xyzx));
                float r1_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r1_xyz_3.xyzx));
                float r1_y_4 = (r1_x_4 * r1_x_4);
                float r1_y_5 = dot(r1_y_4.xxxx, r4_w_5.xxxx);
                float r1_y_6 = (r1_y_5 + -0.5);
                float r1_z_4 = (-r2_x_2 + 1);
                float r2_z_2 = (r1_z_4 * r1_z_4);
                float r2_z_3 = (r2_z_2 * r2_z_2);
                float r1_z_5 = (r1_z_4 * r2_z_3);
                float r1_z_6 = mad(r1_y_6, r1_z_5, 1);
                float r2_z_4 = (-abs(r0_w_6) + 1);
                float r2_w_10 = (r2_z_4 * r2_z_4);
                float r2_w_11 = (r2_w_10 * r2_w_10);
                float r2_z_5 = (r2_z_4 * r2_w_11);
                float r1_y_7 = mad(r1_y_6, r2_z_5, 1);
                float r1_y_8 = (r1_y_7 * r1_z_6);
                float r1_y_9 = (r2_x_2 * r1_y_8);
                float r1_z_7 = (r4_w_5 * r4_w_5);
                float r1_z_8 = max(r1_z_7, 0.002);
                float r2_w_12 = (-r1_z_8 + 1);
                float r3_w_18 = mad(abs(r0_w_6), r2_w_12, r1_z_8);
                float r2_w_13 = mad(r2_x_2, r2_w_12, r1_z_8);
                float r0_w_7 = (abs(r0_w_6) * r2_w_13);
                float r0_w_8 = mad(r2_x_2, r3_w_18, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r2_w_14 = (r1_z_8 * r1_z_8);
                float r3_w_19 = mad(r2_y_2, r2_w_14, -r2_y_2);
                float r2_y_3 = mad(r3_w_19, r2_y_2, 1);
                float r2_w_15 = (r2_w_14 * 0.31830987);
                float r2_y_4 = mad(r2_y_3, r2_y_3, 1E-07);
                float r2_y_5 = (r2_w_15 / r2_y_4);
                float r0_w_11 = (r0_w_10 * r2_y_5);
                float r0_w_12 = (r0_w_11 * 3.1415927);
                float r0_w_13 = (r2_x_2 * r0_w_12);
                float r0_w_14 = max(r0_w_13, 0);
                float r1_z_9 = mad(r1_z_8, r1_z_8, 1);
                float r1_z_10 = ((float4(1, 1, 1, 1) / r1_z_9)).z;
                float r0_w_15 = (r0_w_14 * asfloat(asint((float)((dot(r3_xyz_4.xyzx, r3_xyz_4.xyzx) != 0))) & asint(1065353216)));
                float r1_w_6 = mad(r6_xy_1.y, _Glossiness, -r1_w_5);
                float r1_w_7 = saturate((r1_w_6 + 1));
                float4 r2_xyzw_6 = (r1_y_9.xxxx * r9_xyz_1.xyxz);
                float r2_x_6 = r2_xyzw_6.x;
                float r2_y_6 = r2_xyzw_6.y;
                float r2_w_16 = r2_xyzw_6.w;
                float r0_w_16 = (-r1_x_4 + 1);
                float r1_x_5 = (r0_w_16 * r0_w_16);
                float r1_x_6 = (r1_x_5 * r1_x_5);
                float4 r0_xyzw_13 = (float4(r0_x_12, r0_y_6, r0_z_6, r0_w_16) * float4(r1_z_10, r1_z_10, r1_z_10, r1_x_6));
                float4 r7_xyzw_7 = (-r3_xyz_4.xyzx + float4(1, 1, 1, 0));
                float r7_x_7 = r7_xyzw_7.x;
                float r7_y_6 = r7_xyzw_7.y;
                float r7_z_6 = r7_xyzw_7.z;
                float4 r7_xyzw_8 = mad(float4(r7_x_7, r7_y_6, r7_z_6, r7_x_7), r0_xyzw_13.wwww, r3_xyz_4.xyzx);
                float r7_x_8 = r7_xyzw_8.x;
                float r7_y_7 = r7_xyzw_8.y;
                float r7_z_7 = r7_xyzw_8.z;
                float4 r2_xyzw_7 = mad(((r1_w_5.xxxx * ((r3_xyz_2.xyzx * r4_xyz_3.xyzx)).xyzx)).xyxz, float4(r2_x_6, r2_y_6, r2_x_6, r2_w_16), ((((r9_xyz_1.xyzx * r0_w_15.xxxx)).xyzx * float4(r7_x_8, r7_y_7, r7_z_7, r7_x_8))).xyxz);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_7 = r2_xyzw_7.y;
                float r2_w_17 = r2_xyzw_7.w;
                float4 r1_xyzw_7 = (-r3_xyz_4.xyzx + r1_w_7.xxxx);
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_10 = r1_xyzw_7.y;
                float r1_z_11 = r1_xyzw_7.z;
                float4 r1_xyzw_8 = mad(r2_z_5.xxxx, float4(r1_x_7, r1_y_10, r1_z_11, r1_x_7), r3_xyz_4.xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_11 = r1_xyzw_8.y;
                float r1_z_12 = r1_xyzw_8.z;
                float4 r0_xyzw_14 = mad(r0_xyzw_13.xyzx, float4(r1_x_8, r1_y_11, r1_z_12, r1_x_8), float4(r2_x_7, r2_y_7, r2_w_17, r2_x_7));
                float r0_x_14 = r0_xyzw_14.x;
                float r0_y_8 = r0_xyzw_14.y;
                float r0_z_8 = r0_xyzw_14.z;
                float4 r0_xyzw_15 = mad(float4(r6_x_2, r6_z_3, r6_w_3, r6_x_2), _EmissionColor.xyzx, float4(r0_x_14, r0_y_8, r0_z_8, r0_x_14));
                float r0_x_15 = r0_xyzw_15.x;
                float r0_y_9 = r0_xyzw_15.y;
                float r0_z_9 = r0_xyzw_15.z;
                float4 r1_xyzw_9 = mad(float4(r0_x_15, r0_y_9, r0_z_9, r0_x_15), i.color0.xyzx, -float4(r0_x_15, r0_y_9, r0_z_9, r0_x_15));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_12 = r1_xyzw_9.y;
                float r1_z_13 = r1_xyzw_9.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_9, r1_y_12, r1_z_13, r1_x_9), float4(0.1, 0.1, 0.1, 0), float4(r0_x_15, r0_y_9, r0_z_9, r0_x_15))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "PerformanceChecks"="False" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float _BumpScale : packoffset(c4.x);
                float _Metallic : packoffset(c4.y);
                float _Glossiness : packoffset(c4.z);
                float _OcclusionStrength : packoffset(c4.w);
                float _Cutoff : packoffset(c5.x);
                float4 _Color : packoffset(c6);
                float4 _EmissionColor : packoffset(c7);
                float4 _MainTex_ST : packoffset(c8);
                float4 _BumpMap_ST : packoffset(c9);
                float4 _MetallicGlossMap_ST : packoffset(c10);
                float4 _OcclusionMap_ST : packoffset(c11);
                float4 _EmissionMap_ST : packoffset(c12);
                float4 _DetailMask_ST : packoffset(c13);
                float4 _DetailAlbedo_ST : packoffset(c14);
                float4 _DetailNormal_ST : packoffset(c15);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[46];
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
            cbuffer cb4 : register(b4)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb4_values[21];
            };
            cbuffer cb5 : register(b5)
            {
                float4 cb5_values[8];
            };
            cbuffer cb6 : register(b6)
            {
                float4 cb6_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            SamplerState sampler_EmissionMap;
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_DetailAlbedo;
            SamplerState sampler_DetailNormal;
            SamplerState sampler_BumpMap;
            SamplerState sampler_MetallicGlossMap;
            SamplerState sampler_DetailMask;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _MetallicGlossMap;
            Texture2D _OcclusionMap;
            Texture2D _EmissionMap;
            Texture2D _DetailMask;
            Texture2D _DetailAlbedo;
            Texture2D _DetailNormal;
            Texture2D t8;
            TextureCube t9;
            TextureCube t10;
            Texture3D t11;
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
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 color0 : COLOR0;
                float3 texcoord7 : TEXCOORD7;
                float4 texcoord8 : TEXCOORD8;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program21Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 color0 : COLOR0;
                float3 texcoord7 : TEXCOORD7;
                float4 texcoord8 : TEXCOORD8;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program21Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program9Output vert(program9Input i)
            {
                program9Output o = (program9Output)0;
                float4 worldPos_xyzw_2 = mad(cb3_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb3_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb3_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb3_values[3].xyzw);
                float3 r0_xyz_4 = (mad(cb3_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb4_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb4_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb4_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb4_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb4_values[17], cb4_values[18], cb4_values[19], cb4_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _MetallicGlossMap_ST.xyxx, _MetallicGlossMap_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _OcclusionMap_ST.xxxy, _OcclusionMap_ST.zzzw)).zw;
                o.texcoord2.xy = (mad(i.texcoord0.xyxx, _EmissionMap_ST.xyxx, _EmissionMap_ST.zwzz)).xy;
                o.texcoord2.zw = (mad(i.texcoord0.xxxy, _DetailMask_ST.xxxy, _DetailMask_ST.zzzw)).zw;
                o.texcoord3.xy = (mad(i.texcoord0.xyxx, _DetailAlbedo_ST.xyxx, _DetailAlbedo_ST.zwzz)).xy;
                o.texcoord3.zw = (mad(i.texcoord0.xxxy, _DetailNormal_ST.xxxy, _DetailNormal_ST.zzzw)).zw;
                o.texcoord4.w = r0_xyz_4.x;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * cb3_values[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(cb3_values[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(cb3_values[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = (((rsqrt(dot(worldTangent_xyz_6.xyzx, worldTangent_xyz_6.xyzx))).xxxx * worldTangent_xyz_6.xyzx)).xyz;
                o.texcoord4.x = unitWorldTangent_xyz_7.z;
                float worldNormal_x_1 = dot(i.normal0.xyzx, cb3_values[4].xyzx);
                float worldNormal_y_1 = dot(i.normal0.xyzx, cb3_values[5].xyzx);
                float worldNormal_z_1 = dot(i.normal0.xyzx, cb3_values[6].xyzx);
                float4 unitWorldNormal_xyzw_2 = ((rsqrt(dot(float4(worldNormal_x_1, worldNormal_y_1, worldNormal_z_1, worldNormal_x_1), float4(worldNormal_x_1, worldNormal_y_1, worldNormal_z_1, worldNormal_x_1)))).xxxx * float4(worldNormal_x_1, worldNormal_y_1, worldNormal_z_1, worldNormal_z_1));
                float3 r4_xyz_3 = ((((i.tangent0.w * cb3_values[9].w)).xxxx * (mad(unitWorldNormal_xyzw_2.ywxy, unitWorldTangent_xyz_7.yzxy, ((unitWorldTangent_xyz_7.xyzx * unitWorldNormal_xyzw_2.wxyw)).xyzx)).xyzx)).xyz;
                o.texcoord4.y = r4_xyz_3.x;
                o.texcoord4.z = unitWorldNormal_xyzw_2.x;
                o.texcoord5.x = unitWorldTangent_xyz_7.x;
                o.texcoord6.x = unitWorldTangent_xyz_7.y;
                o.texcoord5.w = r0_xyz_4.y;
                o.texcoord6.w = r0_xyz_4.z;
                o.texcoord5.y = r4_xyz_3.y;
                o.texcoord6.y = r4_xyz_3.z;
                o.texcoord5.z = unitWorldNormal_xyzw_2.y;
                o.texcoord6.z = unitWorldNormal_xyzw_2.w;
                o.color0.xyzw = i.color0.xyzw;
                float4 r2_xyzw_8 = (unitWorldNormal_xyzw_2.ywzx * unitWorldNormal_xyzw_2);
                float r3_x_3 = dot(cb2_values[42].xyzw, r2_xyzw_8);
                float r3_y_3 = dot(cb2_values[43].xyzw, r2_xyzw_8);
                float r3_z_3 = dot(cb2_values[44].xyzw, r2_xyzw_8);
                o.texcoord7.xyz = (mad(cb2_values[45].xyzx, (mad(unitWorldNormal_xyzw_2.x, unitWorldNormal_xyzw_2.x, (unitWorldNormal_xyzw_2.y * unitWorldNormal_xyzw_2.y))).xxxx, float4(r3_x_3, r3_y_3, r3_z_3, r3_x_3))).xyz;
                float r0_w_4 = ((clipPos_xyzw_2.y * unity_WorldToObject[1].x) * 0.5);
                float4 r0_xyzw_13 = (clipPos_xyzw_2.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_13 = r0_xyzw_13.x;
                float r0_z_5 = r0_xyzw_13.z;
                o.texcoord8.zw = (clipPos_xyzw_2.zzzw).zw;
                o.texcoord8.xy = ((r0_z_5.xxxx + float4(r0_x_13, r0_w_4, r0_x_13, r0_x_13))).xy;
                o.texcoord9.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program21Output frag(program21Input i)
            {
                program21Output o = (program21Output)0;
                float TEXCOORD4_x_1 = i.texcoord4.w;
                float TEXCOORD5_y_1 = i.texcoord5.w;
                float TEXCOORD6_z_1 = i.texcoord6.w;
                float3 viewDir_xyz_1 = ((-float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1) + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float4 r3_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r3_xyz_2 = ((r3_xyzw_1.xyzx * _Color.xyzx)).xyz;
                float r1_w_1 = (_BumpMap.Sample(sampler_BumpMap, (i.texcoord2.zwzz).xy)).w;
                float3 r4_xyz_1 = (_MetallicGlossMap.Sample(sampler_MetallicGlossMap, (i.texcoord3.xyxx).xy)).xyz;
                float3 r4_xyz_3 = (mad(r1_w_1.xxxx, (mad(r4_xyz_1.xyzx, float4(2, 2, 2, 0), float4(-2, -2, -2, 0))).xyzx, float4(1, 1, 1, 0))).xyz;
                float2 r6_xy_1 = (_OcclusionMap.Sample(sampler_OcclusionMap, (i.texcoord1.xyxx).xy)).xy;
                float3 r7_xyz_1 = (_EmissionMap.Sample(sampler_EmissionMap, (i.texcoord0.zwzz).xy)).xyz;
                float r7_x_2 = (r7_xyz_1.z * r7_xyz_1.x);
                float2 r6_zw_1 = (mad(float4(r7_x_2, r7_x_2, r7_x_2, r7_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r7_xyzw_3 = (r6_zw_1.xyxx * _BumpScale.xxxx);
                float r7_x_3 = r7_xyzw_3.x;
                float r7_y_2 = r7_xyzw_3.y;
                float r2_w_1 = dot(float4(r7_x_3, r7_y_2, r7_x_3, r7_x_3), float4(r7_x_3, r7_y_2, r7_x_3, r7_x_3));
                float r2_w_2 = min(r2_w_1, 1);
                float r2_w_3 = (-r2_w_2 + 1);
                float r7_z_2 = sqrt(r2_w_3);
                float3 r8_xyz_1 = (_DetailMask.Sample(sampler_DetailMask, (i.texcoord3.zwzz).xy)).xyz;
                float r8_x_2 = (r8_xyz_1.z * r8_xyz_1.x);
                float2 r6_zw_2 = (mad(float4(r8_x_2, r8_x_2, r8_x_2, r8_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r8_xyzw_3 = (r6_zw_2.xyxx * _BumpScale.xxxx);
                float r8_x_3 = r8_xyzw_3.x;
                float r8_y_2 = r8_xyzw_3.y;
                float r2_w_4 = dot(float4(r8_x_3, r8_y_2, r8_x_3, r8_x_3), float4(r8_x_3, r8_y_2, r8_x_3, r8_x_3));
                float r2_w_5 = min(r2_w_4, 1);
                float r2_w_6 = (-r2_w_5 + 1);
                float r8_z_2 = sqrt(r2_w_6);
                float4 r7_xyzw_4 = mad(float4(r8_x_3, r8_y_2, r8_z_2, r8_x_3), r1_w_1.xxxx, float4(r7_x_3, r7_y_2, r7_z_2, r7_x_3));
                float r7_x_4 = r7_xyzw_4.x;
                float r7_y_3 = r7_xyzw_4.y;
                float r7_z_3 = r7_xyzw_4.z;
                float r1_w_2 = dot(float4(r7_x_4, r7_y_3, r7_z_3, r7_x_4), float4(r7_x_4, r7_y_3, r7_z_3, r7_x_4));
                float r1_w_3 = rsqrt(r1_w_2);
                float4 r7_xyzw_5 = (r1_w_3.xxxx * float4(r7_x_4, r7_y_3, r7_z_3, r7_x_4));
                float r7_x_5 = r7_xyzw_5.x;
                float r7_y_4 = r7_xyzw_5.y;
                float r7_z_4 = r7_xyzw_5.z;
                float r1_w_4 = (r6_xy_1.x * _Metallic);
                float r2_w_7 = (_DetailAlbedo.Sample(sampler_DetailAlbedo, (i.texcoord1.zwzz).xy)).w;
                float r2_w_8 = (r2_w_7 + -1);
                float r2_w_9 = mad(_OcclusionStrength, r2_w_8, 1);
                float4 r6_xyzw_2 = _DetailNormal.Sample(sampler_DetailNormal, (i.texcoord2.xyxx).xy);
                float r6_x_2 = r6_xyzw_2.x;
                float r6_z_3 = r6_xyzw_2.z;
                float r6_w_3 = r6_xyzw_2.w;
                float r3_w_2 = mad(r3_xyzw_1.w, _Color.w, -_Cutoff);
                float r3_w_3 = (r3_w_2 < 0);
                if (r3_w_3) discard;
                float r8_x_4 = cb4_values[9].z;
                float r8_y_3 = cb4_values[10].z;
                float r8_z_3 = cb4_values[11].z;
                float r3_w_4 = dot(viewDir_xyz_1.xyzx, float4(r8_x_4, r8_y_3, r8_z_3, r8_x_4));
                float4 r8_xyzw_5 = (float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1) + -cb3_values[25].xyzx);
                float r8_x_5 = r8_xyzw_5.x;
                float r8_y_4 = r8_xyzw_5.y;
                float r8_z_4 = r8_xyzw_5.z;
                float r4_w_1 = dot(float4(r8_x_5, r8_y_4, r8_z_4, r8_x_5), float4(r8_x_5, r8_y_4, r8_z_4, r8_x_5));
                float r4_w_2 = sqrt(r4_w_1);
                float r4_w_3 = (-r3_w_4 + r4_w_2);
                float r3_w_5 = mad(cb3_values[25].w, r4_w_3, r3_w_4);
                float r3_w_6 = saturate(mad(r3_w_5, cb3_values[24].z, cb3_values[24].w));
                float r4_w_4 = (cb6_values[0].x == 1);
                float r8_x_15;
                float r8_y_14;
                float r8_z_14;
                float r8_w_4;
                if (r4_w_4)
                {
                    float r5_w_1 = (cb6_values[0].y == 1);
                    float4 r8_xyzw_7 = (i.texcoord5.wwww * cb6_values[2].xyzx);
                    float r8_x_7 = r8_xyzw_7.x;
                    float r8_y_6 = r8_xyzw_7.y;
                    float r8_z_6 = r8_xyzw_7.z;
                    float4 r8_xyzw_8 = mad(cb6_values[1].xyzx, i.texcoord4.wwww, float4(r8_x_7, r8_y_6, r8_z_6, r8_x_7));
                    float r8_x_8 = r8_xyzw_8.x;
                    float r8_y_7 = r8_xyzw_8.y;
                    float r8_z_7 = r8_xyzw_8.z;
                    float4 r8_xyzw_9 = mad(cb6_values[3].xyzx, i.texcoord6.wwww, float4(r8_x_8, r8_y_7, r8_z_7, r8_x_8));
                    float r8_x_9 = r8_xyzw_9.x;
                    float r8_y_8 = r8_xyzw_9.y;
                    float r8_z_8 = r8_xyzw_9.z;
                    float4 r8_xyzw_10 = (float4(r8_x_9, r8_y_8, r8_z_8, r8_x_9) + cb6_values[4].xyzx);
                    float r8_x_10 = r8_xyzw_10.x;
                    float r8_y_9 = r8_xyzw_10.y;
                    float r8_z_9 = r8_xyzw_10.z;
                    float4 r8_xyzw_11 = (r5_w_1.xxxx ? float4(r8_x_10, r8_y_9, r8_z_9, r8_x_10) : float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1));
                    float r8_x_11 = r8_xyzw_11.x;
                    float r8_y_10 = r8_xyzw_11.y;
                    float r8_z_10 = r8_xyzw_11.z;
                    float4 r8_xyzw_12 = (float4(r8_x_11, r8_y_10, r8_z_10, r8_x_11) + -cb6_values[6].xyzx);
                    float r8_x_12 = r8_xyzw_12.x;
                    float r8_y_11 = r8_xyzw_12.y;
                    float r8_z_11 = r8_xyzw_12.z;
                    float r8_y_12 = ((float4(r8_x_12, r8_x_12, r8_y_11, r8_z_11) * cb6_values[5].xxyz)).y;
                    float r8_z_12 = ((float4(r8_x_12, r8_x_12, r8_y_11, r8_z_11) * cb6_values[5].xxyz)).z;
                    float r8_w_2 = ((float4(r8_x_12, r8_x_12, r8_y_11, r8_z_11) * cb6_values[5].xxyz)).w;
                    float r5_w_2 = mad(r8_y_12, 0.25, 0.75);
                    float r7_w_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r8_x_13 = max(r5_w_2, r7_w_1);
                    float4 r8_xyzw_14 = t11.Sample(sampler_linear_clamp1, (float4(r8_x_13, r8_z_12, r8_w_2, r8_x_13)).xyz);
                    r8_x_15 = r8_xyzw_14.x;
                    r8_y_14 = r8_xyzw_14.y;
                    r8_z_14 = r8_xyzw_14.z;
                    r8_w_4 = r8_xyzw_14.w;
                }
                else
                {
                    float4 r8_xyzw_6 = float4(1, 1, 1, 1);
                    r8_x_15 = r8_xyzw_6.x;
                    r8_y_14 = r8_xyzw_6.y;
                    r8_z_14 = r8_xyzw_6.z;
                    r8_w_4 = r8_xyzw_6.w;
                }
                float r5_w_4 = saturate(dot(float4(r8_x_15, r8_y_14, r8_z_14, r8_w_4), unity_OcclusionMaskSelector));
                float4 r8_xyzw_16 = (i.texcoord8.xyxx / i.texcoord8.wwww);
                float r8_x_16 = r8_xyzw_16.x;
                float r8_y_15 = r8_xyzw_16.y;
                float r7_w_3 = (t8.Sample(sampler_linear_clamp2, (float4(r8_x_16, r8_y_15, r8_x_16, r8_x_16)).xy)).w;
                float r5_w_5 = (r5_w_4 + -r7_w_3);
                float r3_w_7 = mad(r3_w_6, r5_w_5, r7_w_3);
                float r8_x_17 = dot(i.texcoord4.xyzx, float4(r7_x_5, r7_y_4, r7_z_4, r7_x_5));
                float r8_y_16 = dot(i.texcoord5.xyzx, float4(r7_x_5, r7_y_4, r7_z_4, r7_x_5));
                float r8_z_15 = dot(i.texcoord6.xyzx, float4(r7_x_5, r7_y_4, r7_z_4, r7_x_5));
                float r5_w_6 = dot(float4(r8_x_17, r8_y_16, r8_z_15, r8_x_17), float4(r8_x_17, r8_y_16, r8_z_15, r8_x_17));
                float r5_w_7 = rsqrt(r5_w_6);
                float4 r7_xyzw_6 = (r5_w_7.xxxx * float4(r8_x_17, r8_y_16, r8_z_15, r8_x_17));
                float r7_x_6 = r7_xyzw_6.x;
                float r7_y_5 = r7_xyzw_6.y;
                float r7_z_5 = r7_xyzw_6.z;
                float r5_w_8 = mad(-r6_xy_1.y, _Glossiness, 1);
                float r8_x_18 = dot(-unitViewDir_xyz_1.xyzx, float4(r7_x_6, r7_y_5, r7_z_5, r7_x_6));
                float4 r8_xyzw_20 = mad(float4(r7_x_6, r7_y_5, r7_z_5, r7_x_6), ((r8_x_18 + r8_x_18)).xxxx, -unitViewDir_xyz_1.xyzx);
                float r8_x_20 = r8_xyzw_20.x;
                float r8_y_17 = r8_xyzw_20.y;
                float r8_z_16 = r8_xyzw_20.z;
                float3 r9_xyz_1 = ((r3_w_7.xxxx * _LightColor0.xyzx)).xyz;
                float3 r11_xyz_4;
                if (r4_w_4)
                {
                    float r3_w_8 = (cb6_values[0].y == 1);
                    float3 r10_xyz_4 = (((mad(cb6_values[3].xyzx, i.texcoord6.wwww, (mad(cb6_values[1].xyzx, i.texcoord4.wwww, ((i.texcoord5.wwww * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r10_xyzw_7 = (((((r3_w_8.xxxx ? r10_xyz_4.xyzx : float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1))).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r10_y_7 = r10_xyzw_7.y;
                    float r10_z_7 = r10_xyzw_7.z;
                    float r10_w_1 = r10_xyzw_7.w;
                    float r3_w_9 = (r10_y_7 * 0.25);
                    float r4_w_5 = (cb6_values[0].z * 0.5);
                    float r8_w_5 = mad(-cb6_values[0].z, 0.5, 0.25);
                    float r3_w_10 = max(r3_w_9, r4_w_5);
                    float r10_x_7 = min(r8_w_5, r3_w_10);
                    float4 r11_xyzw_2 = t11.Sample(sampler_linear_clamp1, (float4(r10_x_7, r10_z_7, r10_w_1, r10_x_7)).xyz);
                    float4 r12_xyzw_2 = t11.Sample(sampler_linear_clamp1, (((float4(r10_x_7, r10_z_7, r10_w_1, r10_x_7) + float4(0.25, 0, 0, 0))).xyzx).xyz);
                    float4 r10_xyzw_9 = t11.Sample(sampler_linear_clamp1, (((float4(r10_x_7, r10_z_7, r10_w_1, r10_x_7) + float4(0.5, 0, 0, 0))).xyzx).xyz);
                    float r7_w_5 = 1;
                    float r11_x_3 = dot(r11_xyzw_2, float4(r7_x_6, r7_y_5, r7_z_5, r7_w_5));
                    float r11_y_3 = dot(r12_xyzw_2, float4(r7_x_6, r7_y_5, r7_z_5, r7_w_5));
                    float r11_z_3 = dot(r10_xyzw_9, float4(r7_x_6, r7_y_5, r7_z_5, r7_w_5));
                    r11_xyz_4 = float3(r11_x_3, r11_y_3, r11_z_3);
                }
                else
                {
                    float r7_w_4 = 1;
                    float r11_x_1 = dot(cb2_values[39].xyzw, float4(r7_x_6, r7_y_5, r7_z_5, r7_w_4));
                    float r11_y_1 = dot(cb2_values[40].xyzw, float4(r7_x_6, r7_y_5, r7_z_5, r7_w_4));
                    float r11_z_1 = dot(cb2_values[41].xyzw, float4(r7_x_6, r7_y_5, r7_z_5, r7_w_4));
                    r11_xyz_4 = float3(r11_x_1, r11_y_1, r11_z_1);
                }
                float r3_w_12 = (0 < cb5_values[2].w);
                float3 r11_xyz_8;
                if (r3_w_12)
                {
                    float r3_w_13 = dot(float4(r8_x_20, r8_y_17, r8_z_16, r8_x_20), float4(r8_x_20, r8_y_17, r8_z_16, r8_x_20));
                    float r3_w_14 = rsqrt(r3_w_13);
                    float3 r11_xyz_6 = ((r3_w_14.xxxx * float4(r8_x_20, r8_y_17, r8_z_16, r8_x_20))).xyz;
                    float3 r14_xyz_1 = ((float4(0, 0, 0, 0) < r11_xyz_6.xyzx)).xyz;
                    float3 r12_xyz_6 = ((r14_xyz_1.xyzx ? ((((-float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1) + cb5_values[0].xyzx)).xyzx / r11_xyz_6.xyzx)).xyzx : ((((-float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1) + cb5_values[1].xyzx)).xyzx / r11_xyz_6.xyzx)).xyzx)).xyz;
                    float r3_w_15 = min(r12_xyz_6.y, r12_xyz_6.x);
                    float r3_w_16 = min(r12_xyz_6.z, r3_w_15);
                    r11_xyz_8 = (mad(r11_xyz_6.xyzx, r3_w_16.xxxx, ((float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1) + -cb5_values[2].xyzx)).xyzx)).xyz;
                }
                else
                {
                    r11_xyz_8 = (float4(r8_x_20, r8_y_17, r8_z_16, r8_x_20)).xyz;
                }
                float r3_w_18 = mad(-r5_w_8, 0.7, 1.7);
                float r3_w_19 = (r3_w_18 * r5_w_8);
                float r3_w_20 = (r3_w_19 * 6);
                float4 r11_xyzw_9 = t9.SampleLevel(sampler_linear_clamp, r11_xyz_8.xyz, r3_w_20);
                float r4_w_7 = (r11_xyzw_9.w + -1);
                float r4_w_8 = mad(cb5_values[3].w, r4_w_7, 1);
                float r4_w_9 = log2(r4_w_8);
                float r4_w_10 = (r4_w_9 * cb5_values[3].y);
                float r4_w_11 = exp2(r4_w_10);
                float r4_w_12 = (r4_w_11 * cb5_values[3].x);
                float r7_w_7 = (cb5_values[1].w < 0.99999);
                float3 r12_xyz_11 = ((r11_xyzw_9.xyzx * r4_w_12.xxxx)).xyz;
                if (r7_w_7)
                {
                    float r7_w_8 = (0 < cb5_values[6].w);
                    float r8_x_22 = r8_x_20;
                    float r8_y_19 = r8_y_17;
                    float r8_z_18 = r8_z_16;
                    if (r7_w_8)
                    {
                        float r7_w_9 = dot(float4(r8_x_20, r8_y_17, r8_z_16, r8_x_20), float4(r8_x_20, r8_y_17, r8_z_16, r8_x_20));
                        float r7_w_10 = rsqrt(r7_w_9);
                        float3 r13_xyz_4 = ((r7_w_10.xxxx * float4(r8_x_20, r8_y_17, r8_z_16, r8_x_20))).xyz;
                        float3 r16_xyz_1 = ((float4(0, 0, 0, 0) < r13_xyz_4.xyzx)).xyz;
                        float3 r14_xyz_5 = ((r16_xyz_1.xyzx ? ((((-float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1) + cb5_values[4].xyzx)).xyzx / r13_xyz_4.xyzx)).xyzx : ((((-float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1) + cb5_values[5].xyzx)).xyzx / r13_xyz_4.xyzx)).xyzx)).xyz;
                        float r7_w_11 = min(r14_xyz_5.y, r14_xyz_5.x);
                        float r7_w_12 = min(r14_xyz_5.z, r7_w_11);
                        float4 r8_xyzw_21 = mad(r13_xyz_4.xyzx, r7_w_12.xxxx, ((float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1) + -cb5_values[6].xyzx)).xyzx);
                        float r8_x_21 = r8_xyzw_21.x;
                        float r8_y_18 = r8_xyzw_21.y;
                        float r8_z_17 = r8_xyzw_21.z;
                        r8_x_22 = r8_x_21;
                        r8_y_19 = r8_y_18;
                        r8_z_18 = r8_z_17;
                    }
                    float4 r8_xyzw_23 = t10.SampleLevel(sampler_linear_clamp, (float4(r8_x_22, r8_y_19, r8_z_18, r8_x_22)).xyz, r3_w_20);
                                        float4 r0_xyzw_10 = (r8_xyzw_23.xyzx * ((pow(mad(cb5_values[7].w, (r8_xyzw_23.w + -1), 1), cb5_values[7].y) * cb5_values[7].x)).xxxx);
                    float r0_x_10 = r0_xyzw_10.x;
                    float r0_y_4 = r0_xyzw_10.y;
                    float r0_z_4 = r0_xyzw_10.z;
                    float4 r8_xyzw_24 = mad(r4_w_12.xxxx, r11_xyzw_9.xyzx, -float4(r0_x_10, r0_y_4, r0_z_4, r0_x_10));
                    float r8_x_24 = r8_xyzw_24.x;
                    float r8_y_21 = r8_xyzw_24.y;
                    float r8_z_20 = r8_xyzw_24.z;
                    r12_xyz_11 = (mad(cb5_values[1].wwww, float4(r8_x_24, r8_y_21, r8_z_20, r8_x_24), float4(r0_x_10, r0_y_4, r0_z_4, r0_x_10))).xyz;
                }
                float4 r0_xyzw_12 = (r2_w_9.xxxx * r12_xyz_11.xyzx);
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_6 = r0_xyzw_12.y;
                float r0_z_6 = r0_xyzw_12.z;
                float3 r3_xyz_4 = (mad(r1_w_4.xxxx, (mad(r3_xyz_2.xyzx, r4_xyz_3.xyzx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_5 = mad(-r1_w_4, 0.96, 0.96);
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r1_xyz_3 = ((r0_w_5.xxxx * r1_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r7_x_6, r7_y_5, r7_z_5, r7_x_6), unitViewDir_xyz_1.xyzx);
                float r2_x_2 = saturate(dot(float4(r7_x_6, r7_y_5, r7_z_5, r7_x_6), _WorldSpaceLightPos0.xyzx));
                float r2_y_2 = saturate(dot(float4(r7_x_6, r7_y_5, r7_z_5, r7_x_6), r1_xyz_3.xyzx));
                float r1_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r1_xyz_3.xyzx));
                float r1_y_4 = (r1_x_4 * r1_x_4);
                float r1_y_5 = dot(r1_y_4.xxxx, r5_w_8.xxxx);
                float r1_y_6 = (r1_y_5 + -0.5);
                float r1_z_4 = (-r2_x_2 + 1);
                float r2_z_2 = (r1_z_4 * r1_z_4);
                float r2_z_3 = (r2_z_2 * r2_z_2);
                float r1_z_5 = (r1_z_4 * r2_z_3);
                float r1_z_6 = mad(r1_y_6, r1_z_5, 1);
                float r2_z_4 = (-abs(r0_w_6) + 1);
                float r3_w_21 = (r2_z_4 * r2_z_4);
                float r3_w_22 = (r3_w_21 * r3_w_21);
                float r2_z_5 = (r2_z_4 * r3_w_22);
                float r1_y_7 = mad(r1_y_6, r2_z_5, 1);
                float r1_y_8 = (r1_y_7 * r1_z_6);
                float r1_y_9 = (r2_x_2 * r1_y_8);
                float r1_z_7 = (r5_w_8 * r5_w_8);
                float r1_z_8 = max(r1_z_7, 0.002);
                float r3_w_23 = (-r1_z_8 + 1);
                float r4_w_13 = mad(abs(r0_w_6), r3_w_23, r1_z_8);
                float r3_w_24 = mad(r2_x_2, r3_w_23, r1_z_8);
                float r0_w_7 = (abs(r0_w_6) * r3_w_24);
                float r0_w_8 = mad(r2_x_2, r4_w_13, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r3_w_25 = (r1_z_8 * r1_z_8);
                float r4_w_14 = mad(r2_y_2, r3_w_25, -r2_y_2);
                float r2_y_3 = mad(r4_w_14, r2_y_2, 1);
                float r3_w_26 = (r3_w_25 * 0.31830987);
                float r2_y_4 = mad(r2_y_3, r2_y_3, 1E-07);
                float r2_y_5 = (r3_w_26 / r2_y_4);
                float r0_w_11 = (r0_w_10 * r2_y_5);
                float r0_w_12 = (r0_w_11 * 3.1415927);
                float r0_w_13 = (r2_x_2 * r0_w_12);
                float r0_w_14 = max(r0_w_13, 0);
                float r1_z_9 = mad(r1_z_8, r1_z_8, 1);
                float r1_z_10 = ((float4(1, 1, 1, 1) / r1_z_9)).z;
                float r0_w_15 = (r0_w_14 * asfloat(asint((float)((dot(r3_xyz_4.xyzx, r3_xyz_4.xyzx) != 0))) & asint(1065353216)));
                float r1_w_6 = mad(r6_xy_1.y, _Glossiness, -r1_w_5);
                float r1_w_7 = saturate((r1_w_6 + 1));
                float4 r2_xyzw_6 = mad((max(((r11_xyz_4.xyzx + i.texcoord7.xyzx)).xyzx, float4(0, 0, 0, 0))).xyxz, r2_w_9.xxxx, ((r1_y_9.xxxx * r9_xyz_1.xyzx)).xyxz);
                float r2_x_6 = r2_xyzw_6.x;
                float r2_y_6 = r2_xyzw_6.y;
                float r2_w_10 = r2_xyzw_6.w;
                float r0_w_16 = (-r1_x_4 + 1);
                float r1_x_5 = (r0_w_16 * r0_w_16);
                float r1_x_6 = (r1_x_5 * r1_x_5);
                float4 r0_xyzw_13 = (float4(r0_x_12, r0_y_6, r0_z_6, r0_w_16) * float4(r1_z_10, r1_z_10, r1_z_10, r1_x_6));
                float4 r7_xyzw_7 = (-r3_xyz_4.xyzx + float4(1, 1, 1, 0));
                float r7_x_7 = r7_xyzw_7.x;
                float r7_y_6 = r7_xyzw_7.y;
                float r7_z_6 = r7_xyzw_7.z;
                float4 r7_xyzw_8 = mad(float4(r7_x_7, r7_y_6, r7_z_6, r7_x_7), r0_xyzw_13.wwww, r3_xyz_4.xyzx);
                float r7_x_8 = r7_xyzw_8.x;
                float r7_y_7 = r7_xyzw_8.y;
                float r7_z_7 = r7_xyzw_8.z;
                float4 r2_xyzw_7 = mad(((r1_w_5.xxxx * ((r3_xyz_2.xyzx * r4_xyz_3.xyzx)).xyzx)).xyxz, float4(r2_x_6, r2_y_6, r2_x_6, r2_w_10), ((((r9_xyz_1.xyzx * r0_w_15.xxxx)).xyzx * float4(r7_x_8, r7_y_7, r7_z_7, r7_x_8))).xyxz);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_7 = r2_xyzw_7.y;
                float r2_w_11 = r2_xyzw_7.w;
                float4 r1_xyzw_7 = (-r3_xyz_4.xyzx + r1_w_7.xxxx);
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_10 = r1_xyzw_7.y;
                float r1_z_11 = r1_xyzw_7.z;
                float4 r1_xyzw_8 = mad(r2_z_5.xxxx, float4(r1_x_7, r1_y_10, r1_z_11, r1_x_7), r3_xyz_4.xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_11 = r1_xyzw_8.y;
                float r1_z_12 = r1_xyzw_8.z;
                float4 r0_xyzw_14 = mad(r0_xyzw_13.xyzx, float4(r1_x_8, r1_y_11, r1_z_12, r1_x_8), float4(r2_x_7, r2_y_7, r2_w_11, r2_x_7));
                float r0_x_14 = r0_xyzw_14.x;
                float r0_y_8 = r0_xyzw_14.y;
                float r0_z_8 = r0_xyzw_14.z;
                float4 r0_xyzw_15 = mad(float4(r6_x_2, r6_z_3, r6_w_3, r6_x_2), _EmissionColor.xyzx, float4(r0_x_14, r0_y_8, r0_z_8, r0_x_14));
                float r0_x_15 = r0_xyzw_15.x;
                float r0_y_9 = r0_xyzw_15.y;
                float r0_z_9 = r0_xyzw_15.z;
                float4 r1_xyzw_9 = mad(float4(r0_x_15, r0_y_9, r0_z_9, r0_x_15), i.color0.xyzx, -float4(r0_x_15, r0_y_9, r0_z_9, r0_x_15));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_12 = r1_xyzw_9.y;
                float r1_z_13 = r1_xyzw_9.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_9, r1_y_12, r1_z_13, r1_x_9), float4(0.1, 0.1, 0.1, 0), float4(r0_x_15, r0_y_9, r0_z_9, r0_x_15))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "PerformanceChecks"="False" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float _BumpScale : packoffset(c4.x);
                float _Metallic : packoffset(c4.y);
                float _Glossiness : packoffset(c4.z);
                float _OcclusionStrength : packoffset(c4.w);
                float _Cutoff : packoffset(c5.x);
                float4 _Color : packoffset(c6);
                float4 _EmissionColor : packoffset(c7);
                float4 _MainTex_ST : packoffset(c8);
                float4 _BumpMap_ST : packoffset(c9);
                float4 _MetallicGlossMap_ST : packoffset(c10);
                float4 _OcclusionMap_ST : packoffset(c11);
                float4 _EmissionMap_ST : packoffset(c12);
                float4 _DetailMask_ST : packoffset(c13);
                float4 _DetailAlbedo_ST : packoffset(c14);
                float4 _DetailNormal_ST : packoffset(c15);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[10];
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
            cbuffer _UnityProbeVolumeCB_b4
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
            SamplerState sampler_linear_clamp;
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            SamplerState sampler_EmissionMap;
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_DetailAlbedo;
            SamplerState sampler_DetailNormal;
            SamplerState sampler_BumpMap;
            SamplerState sampler_MetallicGlossMap;
            SamplerState sampler_DetailMask;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _MetallicGlossMap;
            Texture2D _OcclusionMap;
            Texture2D _EmissionMap;
            Texture2D _DetailMask;
            Texture2D _DetailAlbedo;
            Texture2D _DetailNormal;
            Texture2D t8;
            TextureCube t9;
            TextureCube t10;
            Texture3D t11;
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
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 color0 : COLOR0;
                float4 texcoord8 : TEXCOORD8;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program20Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 color0 : COLOR0;
                float4 texcoord8 : TEXCOORD8;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program20Output
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
                float3 r0_xyz_4 = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _MetallicGlossMap_ST.xyxx, _MetallicGlossMap_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _OcclusionMap_ST.xxxy, _OcclusionMap_ST.zzzw)).zw;
                o.texcoord2.xy = (mad(i.texcoord0.xyxx, _EmissionMap_ST.xyxx, _EmissionMap_ST.zwzz)).xy;
                o.texcoord2.zw = (mad(i.texcoord0.xxxy, _DetailMask_ST.xxxy, _DetailMask_ST.zzzw)).zw;
                o.texcoord3.xy = (mad(i.texcoord0.xyxx, _DetailAlbedo_ST.xyxx, _DetailAlbedo_ST.zwzz)).xy;
                o.texcoord3.zw = (mad(i.texcoord0.xxxy, _DetailNormal_ST.xxxy, _DetailNormal_ST.zzzw)).zw;
                o.texcoord4.w = r0_xyz_4.x;
                float r2_y_4 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float r2_z_4 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float r2_x_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float3 unitWorldNormal_xyz_5 = (((rsqrt(dot(float4(r2_x_4, r2_y_4, r2_z_4, r2_x_4), float4(r2_x_4, r2_y_4, r2_z_4, r2_x_4)))).xxxx * float4(r2_x_4, r2_y_4, r2_z_4, r2_x_4))).xyz;
                float3 worldTangent_xyz_1 = ((i.tangent0.yyyy * cb2_values[1].yzxy)).xyz;
                float3 worldTangent_xyz_2 = (mad(cb2_values[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_1.xyzx)).xyz;
                float3 worldTangent_xyz_3 = (mad(cb2_values[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_2.xyzx)).xyz;
                float3 unitWorldTangent_xyz_4 = (((rsqrt(dot(worldTangent_xyz_3.xyzx, worldTangent_xyz_3.xyzx))).xxxx * worldTangent_xyz_3.xyzx)).xyz;
                float3 r4_xyz_3 = ((((i.tangent0.w * cb2_values[9].w)).xxxx * (mad(unitWorldNormal_xyz_5.zxyz, unitWorldTangent_xyz_4.yzxy, ((unitWorldNormal_xyz_5.xyzx * unitWorldTangent_xyz_4.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord4.y = r4_xyz_3.x;
                o.texcoord4.x = unitWorldTangent_xyz_4.z;
                o.texcoord4.z = unitWorldNormal_xyz_5.y;
                o.texcoord5.x = unitWorldTangent_xyz_4.x;
                o.texcoord6.x = unitWorldTangent_xyz_4.y;
                o.texcoord5.z = unitWorldNormal_xyz_5.z;
                o.texcoord6.z = unitWorldNormal_xyz_5.x;
                o.texcoord5.w = r0_xyz_4.y;
                o.texcoord6.w = r0_xyz_4.z;
                o.texcoord5.y = r4_xyz_3.y;
                o.texcoord6.y = r4_xyz_3.z;
                o.color0.xyzw = i.color0.xyzw;
                float r0_w_4 = ((clipPos_xyzw_2.y * unity_WorldToObject[1].x) * 0.5);
                float4 r0_xyzw_11 = (clipPos_xyzw_2.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_z_5 = r0_xyzw_11.z;
                o.texcoord8.zw = (clipPos_xyzw_2.zzzw).zw;
                o.texcoord8.xy = ((r0_z_5.xxxx + float4(r0_x_11, r0_w_4, r0_x_11, r0_x_11))).xy;
                o.texcoord9.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program20Output frag(program20Input i)
            {
                program20Output o = (program20Output)0;
                float TEXCOORD4_x_1 = i.texcoord4.w;
                float TEXCOORD5_y_1 = i.texcoord5.w;
                float TEXCOORD6_z_1 = i.texcoord6.w;
                float3 viewDir_xyz_1 = ((-float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1) + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float4 r3_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r3_xyz_2 = ((r3_xyzw_1.xyzx * _Color.xyzx)).xyz;
                float r1_w_1 = (_BumpMap.Sample(sampler_BumpMap, (i.texcoord2.zwzz).xy)).w;
                float3 r4_xyz_1 = (_MetallicGlossMap.Sample(sampler_MetallicGlossMap, (i.texcoord3.xyxx).xy)).xyz;
                float3 r4_xyz_3 = (mad(r1_w_1.xxxx, (mad(r4_xyz_1.xyzx, float4(2, 2, 2, 0), float4(-2, -2, -2, 0))).xyzx, float4(1, 1, 1, 0))).xyz;
                float2 r6_xy_1 = (_OcclusionMap.Sample(sampler_OcclusionMap, (i.texcoord1.xyxx).xy)).xy;
                float3 r7_xyz_1 = (_EmissionMap.Sample(sampler_EmissionMap, (i.texcoord0.zwzz).xy)).xyz;
                float r7_x_2 = (r7_xyz_1.z * r7_xyz_1.x);
                float2 r6_zw_1 = (mad(float4(r7_x_2, r7_x_2, r7_x_2, r7_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r7_xyzw_3 = (r6_zw_1.xyxx * _BumpScale.xxxx);
                float r7_x_3 = r7_xyzw_3.x;
                float r7_y_2 = r7_xyzw_3.y;
                float r2_w_1 = dot(float4(r7_x_3, r7_y_2, r7_x_3, r7_x_3), float4(r7_x_3, r7_y_2, r7_x_3, r7_x_3));
                float r2_w_2 = min(r2_w_1, 1);
                float r2_w_3 = (-r2_w_2 + 1);
                float r7_z_2 = sqrt(r2_w_3);
                float3 r8_xyz_1 = (_DetailMask.Sample(sampler_DetailMask, (i.texcoord3.zwzz).xy)).xyz;
                float r8_x_2 = (r8_xyz_1.z * r8_xyz_1.x);
                float2 r6_zw_2 = (mad(float4(r8_x_2, r8_x_2, r8_x_2, r8_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r8_xyzw_3 = (r6_zw_2.xyxx * _BumpScale.xxxx);
                float r8_x_3 = r8_xyzw_3.x;
                float r8_y_2 = r8_xyzw_3.y;
                float r2_w_4 = dot(float4(r8_x_3, r8_y_2, r8_x_3, r8_x_3), float4(r8_x_3, r8_y_2, r8_x_3, r8_x_3));
                float r2_w_5 = min(r2_w_4, 1);
                float r2_w_6 = (-r2_w_5 + 1);
                float r8_z_2 = sqrt(r2_w_6);
                float4 r7_xyzw_4 = mad(float4(r8_x_3, r8_y_2, r8_z_2, r8_x_3), r1_w_1.xxxx, float4(r7_x_3, r7_y_2, r7_z_2, r7_x_3));
                float r7_x_4 = r7_xyzw_4.x;
                float r7_y_3 = r7_xyzw_4.y;
                float r7_z_3 = r7_xyzw_4.z;
                float r1_w_2 = dot(float4(r7_x_4, r7_y_3, r7_z_3, r7_x_4), float4(r7_x_4, r7_y_3, r7_z_3, r7_x_4));
                float r1_w_3 = rsqrt(r1_w_2);
                float4 r7_xyzw_5 = (r1_w_3.xxxx * float4(r7_x_4, r7_y_3, r7_z_3, r7_x_4));
                float r7_x_5 = r7_xyzw_5.x;
                float r7_y_4 = r7_xyzw_5.y;
                float r7_z_4 = r7_xyzw_5.z;
                float r1_w_4 = (r6_xy_1.x * _Metallic);
                float r2_w_7 = (_DetailAlbedo.Sample(sampler_DetailAlbedo, (i.texcoord1.zwzz).xy)).w;
                float r2_w_8 = (r2_w_7 + -1);
                float r2_w_9 = mad(_OcclusionStrength, r2_w_8, 1);
                float4 r6_xyzw_2 = _DetailNormal.Sample(sampler_DetailNormal, (i.texcoord2.xyxx).xy);
                float r6_x_2 = r6_xyzw_2.x;
                float r6_z_3 = r6_xyzw_2.z;
                float r6_w_3 = r6_xyzw_2.w;
                float r3_w_2 = mad(r3_xyzw_1.w, _Color.w, -_Cutoff);
                float r3_w_3 = (r3_w_2 < 0);
                if (r3_w_3) discard;
                float r8_x_4 = cb4_values[9].z;
                float r8_y_3 = cb4_values[10].z;
                float r8_z_3 = cb4_values[11].z;
                float r3_w_4 = dot(viewDir_xyz_1.xyzx, float4(r8_x_4, r8_y_3, r8_z_3, r8_x_4));
                float4 r8_xyzw_5 = (float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1) + -cb3_values[25].xyzx);
                float r8_x_5 = r8_xyzw_5.x;
                float r8_y_4 = r8_xyzw_5.y;
                float r8_z_4 = r8_xyzw_5.z;
                float r4_w_1 = dot(float4(r8_x_5, r8_y_4, r8_z_4, r8_x_5), float4(r8_x_5, r8_y_4, r8_z_4, r8_x_5));
                float r4_w_2 = sqrt(r4_w_1);
                float r4_w_3 = (-r3_w_4 + r4_w_2);
                float r3_w_5 = mad(cb3_values[25].w, r4_w_3, r3_w_4);
                float r3_w_6 = saturate(mad(r3_w_5, cb3_values[24].z, cb3_values[24].w));
                float r4_w_4 = (cb6_values[0].x == 1);
                float r8_x_15;
                float r8_y_14;
                float r8_z_14;
                float r8_w_4;
                if (r4_w_4)
                {
                    float r4_w_5 = (cb6_values[0].y == 1);
                    float4 r8_xyzw_7 = (i.texcoord5.wwww * cb6_values[2].xyzx);
                    float r8_x_7 = r8_xyzw_7.x;
                    float r8_y_6 = r8_xyzw_7.y;
                    float r8_z_6 = r8_xyzw_7.z;
                    float4 r8_xyzw_8 = mad(cb6_values[1].xyzx, i.texcoord4.wwww, float4(r8_x_7, r8_y_6, r8_z_6, r8_x_7));
                    float r8_x_8 = r8_xyzw_8.x;
                    float r8_y_7 = r8_xyzw_8.y;
                    float r8_z_7 = r8_xyzw_8.z;
                    float4 r8_xyzw_9 = mad(cb6_values[3].xyzx, i.texcoord6.wwww, float4(r8_x_8, r8_y_7, r8_z_7, r8_x_8));
                    float r8_x_9 = r8_xyzw_9.x;
                    float r8_y_8 = r8_xyzw_9.y;
                    float r8_z_8 = r8_xyzw_9.z;
                    float4 r8_xyzw_10 = (float4(r8_x_9, r8_y_8, r8_z_8, r8_x_9) + cb6_values[4].xyzx);
                    float r8_x_10 = r8_xyzw_10.x;
                    float r8_y_9 = r8_xyzw_10.y;
                    float r8_z_9 = r8_xyzw_10.z;
                    float4 r8_xyzw_11 = (r4_w_5.xxxx ? float4(r8_x_10, r8_y_9, r8_z_9, r8_x_10) : float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1));
                    float r8_x_11 = r8_xyzw_11.x;
                    float r8_y_10 = r8_xyzw_11.y;
                    float r8_z_10 = r8_xyzw_11.z;
                    float4 r8_xyzw_12 = (float4(r8_x_11, r8_y_10, r8_z_10, r8_x_11) + -cb6_values[6].xyzx);
                    float r8_x_12 = r8_xyzw_12.x;
                    float r8_y_11 = r8_xyzw_12.y;
                    float r8_z_11 = r8_xyzw_12.z;
                    float r8_y_12 = ((float4(r8_x_12, r8_x_12, r8_y_11, r8_z_11) * cb6_values[5].xxyz)).y;
                    float r8_z_12 = ((float4(r8_x_12, r8_x_12, r8_y_11, r8_z_11) * cb6_values[5].xxyz)).z;
                    float r8_w_2 = ((float4(r8_x_12, r8_x_12, r8_y_11, r8_z_11) * cb6_values[5].xxyz)).w;
                    float r4_w_6 = mad(r8_y_12, 0.25, 0.75);
                    float r5_w_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r8_x_13 = max(r4_w_6, r5_w_1);
                    float4 r8_xyzw_14 = t11.Sample(sampler_linear_clamp1, (float4(r8_x_13, r8_z_12, r8_w_2, r8_x_13)).xyz);
                    r8_x_15 = r8_xyzw_14.x;
                    r8_y_14 = r8_xyzw_14.y;
                    r8_z_14 = r8_xyzw_14.z;
                    r8_w_4 = r8_xyzw_14.w;
                }
                else
                {
                    float4 r8_xyzw_6 = float4(1, 1, 1, 1);
                    r8_x_15 = r8_xyzw_6.x;
                    r8_y_14 = r8_xyzw_6.y;
                    r8_z_14 = r8_xyzw_6.z;
                    r8_w_4 = r8_xyzw_6.w;
                }
                float r4_w_8 = saturate(dot(float4(r8_x_15, r8_y_14, r8_z_14, r8_w_4), unity_OcclusionMaskSelector));
                float4 r8_xyzw_16 = (i.texcoord8.xyxx / i.texcoord8.wwww);
                float r8_x_16 = r8_xyzw_16.x;
                float r8_y_15 = r8_xyzw_16.y;
                float r5_w_3 = (t8.Sample(sampler_linear_clamp2, (float4(r8_x_16, r8_y_15, r8_x_16, r8_x_16)).xy)).w;
                float r4_w_9 = (r4_w_8 + -r5_w_3);
                float r3_w_7 = mad(r3_w_6, r4_w_9, r5_w_3);
                float r8_x_17 = dot(i.texcoord4.xyzx, float4(r7_x_5, r7_y_4, r7_z_4, r7_x_5));
                float r8_y_16 = dot(i.texcoord5.xyzx, float4(r7_x_5, r7_y_4, r7_z_4, r7_x_5));
                float r8_z_15 = dot(i.texcoord6.xyzx, float4(r7_x_5, r7_y_4, r7_z_4, r7_x_5));
                float r4_w_10 = dot(float4(r8_x_17, r8_y_16, r8_z_15, r8_x_17), float4(r8_x_17, r8_y_16, r8_z_15, r8_x_17));
                float r4_w_11 = rsqrt(r4_w_10);
                float4 r7_xyzw_6 = (r4_w_11.xxxx * float4(r8_x_17, r8_y_16, r8_z_15, r8_x_17));
                float r7_x_6 = r7_xyzw_6.x;
                float r7_y_5 = r7_xyzw_6.y;
                float r7_z_5 = r7_xyzw_6.z;
                float r4_w_12 = mad(-r6_xy_1.y, _Glossiness, 1);
                float r5_w_4 = dot(-unitViewDir_xyz_1.xyzx, float4(r7_x_6, r7_y_5, r7_z_5, r7_x_6));
                float r5_w_5 = (r5_w_4 + r5_w_4);
                float4 r8_xyzw_18 = mad(float4(r7_x_6, r7_y_5, r7_z_5, r7_x_6), -r5_w_5.xxxx, -unitViewDir_xyz_1.xyzx);
                float r8_x_18 = r8_xyzw_18.x;
                float r8_y_17 = r8_xyzw_18.y;
                float r8_z_16 = r8_xyzw_18.z;
                float3 r9_xyz_1 = ((r3_w_7.xxxx * _LightColor0.xyzx)).xyz;
                float r3_w_8 = (0 < cb5_values[2].w);
                float3 r10_xyz_4;
                if (r3_w_8)
                {
                    float r3_w_9 = dot(float4(r8_x_18, r8_y_17, r8_z_16, r8_x_18), float4(r8_x_18, r8_y_17, r8_z_16, r8_x_18));
                    float r3_w_10 = rsqrt(r3_w_9);
                    float3 r10_xyz_2 = ((r3_w_10.xxxx * float4(r8_x_18, r8_y_17, r8_z_16, r8_x_18))).xyz;
                    float3 r13_xyz_1 = ((float4(0, 0, 0, 0) < r10_xyz_2.xyzx)).xyz;
                    float3 r11_xyz_3 = ((r13_xyz_1.xyzx ? ((((-float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1) + cb5_values[0].xyzx)).xyzx / r10_xyz_2.xyzx)).xyzx : ((((-float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1) + cb5_values[1].xyzx)).xyzx / r10_xyz_2.xyzx)).xyzx)).xyz;
                    float r3_w_11 = min(r11_xyz_3.y, r11_xyz_3.x);
                    float r3_w_12 = min(r11_xyz_3.z, r3_w_11);
                    r10_xyz_4 = (mad(r10_xyz_2.xyzx, r3_w_12.xxxx, ((float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1) + -cb5_values[2].xyzx)).xyzx)).xyz;
                }
                else
                {
                    r10_xyz_4 = (float4(r8_x_18, r8_y_17, r8_z_16, r8_x_18)).xyz;
                }
                float r3_w_14 = mad(-r4_w_12, 0.7, 1.7);
                float r3_w_15 = (r3_w_14 * r4_w_12);
                float r3_w_16 = (r3_w_15 * 6);
                float4 r10_xyzw_5 = t9.SampleLevel(sampler_linear_clamp, r10_xyz_4.xyz, r3_w_16);
                float r5_w_6 = (r10_xyzw_5.w + -1);
                float r5_w_7 = mad(cb5_values[3].w, r5_w_6, 1);
                float r5_w_8 = log2(r5_w_7);
                float r5_w_9 = (r5_w_8 * cb5_values[3].y);
                float r5_w_10 = exp2(r5_w_9);
                float r5_w_11 = (r5_w_10 * cb5_values[3].x);
                float r7_w_1 = (cb5_values[1].w < 0.99999);
                float3 r11_xyz_8 = ((r10_xyzw_5.xyzx * r5_w_11.xxxx)).xyz;
                if (r7_w_1)
                {
                    float r7_w_2 = (0 < cb5_values[6].w);
                    float r8_x_20 = r8_x_18;
                    float r8_y_19 = r8_y_17;
                    float r8_z_18 = r8_z_16;
                    if (r7_w_2)
                    {
                        float r7_w_3 = dot(float4(r8_x_18, r8_y_17, r8_z_16, r8_x_18), float4(r8_x_18, r8_y_17, r8_z_16, r8_x_18));
                        float r7_w_4 = rsqrt(r7_w_3);
                        float3 r12_xyz_4 = ((r7_w_4.xxxx * float4(r8_x_18, r8_y_17, r8_z_16, r8_x_18))).xyz;
                        float3 r15_xyz_1 = ((float4(0, 0, 0, 0) < r12_xyz_4.xyzx)).xyz;
                        float3 r13_xyz_5 = ((r15_xyz_1.xyzx ? ((((-float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1) + cb5_values[4].xyzx)).xyzx / r12_xyz_4.xyzx)).xyzx : ((((-float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1) + cb5_values[5].xyzx)).xyzx / r12_xyz_4.xyzx)).xyzx)).xyz;
                        float r7_w_5 = min(r13_xyz_5.y, r13_xyz_5.x);
                        float r7_w_6 = min(r13_xyz_5.z, r7_w_5);
                        float4 r8_xyzw_19 = mad(r12_xyz_4.xyzx, r7_w_6.xxxx, ((float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1) + -cb5_values[6].xyzx)).xyzx);
                        float r8_x_19 = r8_xyzw_19.x;
                        float r8_y_18 = r8_xyzw_19.y;
                        float r8_z_17 = r8_xyzw_19.z;
                        r8_x_20 = r8_x_19;
                        r8_y_19 = r8_y_18;
                        r8_z_18 = r8_z_17;
                    }
                    float4 r8_xyzw_21 = t10.SampleLevel(sampler_linear_clamp, (float4(r8_x_20, r8_y_19, r8_z_18, r8_x_20)).xyz, r3_w_16);
                                        float4 r0_xyzw_10 = (r8_xyzw_21.xyzx * ((pow(mad(cb5_values[7].w, (r8_xyzw_21.w + -1), 1), cb5_values[7].y) * cb5_values[7].x)).xxxx);
                    float r0_x_10 = r0_xyzw_10.x;
                    float r0_y_4 = r0_xyzw_10.y;
                    float r0_z_4 = r0_xyzw_10.z;
                    float4 r8_xyzw_22 = mad(r5_w_11.xxxx, r10_xyzw_5.xyzx, -float4(r0_x_10, r0_y_4, r0_z_4, r0_x_10));
                    float r8_x_22 = r8_xyzw_22.x;
                    float r8_y_21 = r8_xyzw_22.y;
                    float r8_z_20 = r8_xyzw_22.z;
                    r11_xyz_8 = (mad(cb5_values[1].wwww, float4(r8_x_22, r8_y_21, r8_z_20, r8_x_22), float4(r0_x_10, r0_y_4, r0_z_4, r0_x_10))).xyz;
                }
                float4 r0_xyzw_12 = (r2_w_9.xxxx * r11_xyz_8.xyzx);
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_6 = r0_xyzw_12.y;
                float r0_z_6 = r0_xyzw_12.z;
                float3 r3_xyz_4 = (mad(r1_w_4.xxxx, (mad(r3_xyz_2.xyzx, r4_xyz_3.xyzx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_5 = mad(-r1_w_4, 0.96, 0.96);
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r1_xyz_3 = ((r0_w_5.xxxx * r1_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r7_x_6, r7_y_5, r7_z_5, r7_x_6), unitViewDir_xyz_1.xyzx);
                float r2_x_2 = saturate(dot(float4(r7_x_6, r7_y_5, r7_z_5, r7_x_6), _WorldSpaceLightPos0.xyzx));
                float r2_y_2 = saturate(dot(float4(r7_x_6, r7_y_5, r7_z_5, r7_x_6), r1_xyz_3.xyzx));
                float r1_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r1_xyz_3.xyzx));
                float r1_y_4 = (r1_x_4 * r1_x_4);
                float r1_y_5 = dot(r1_y_4.xxxx, r4_w_12.xxxx);
                float r1_y_6 = (r1_y_5 + -0.5);
                float r1_z_4 = (-r2_x_2 + 1);
                float r2_z_2 = (r1_z_4 * r1_z_4);
                float r2_z_3 = (r2_z_2 * r2_z_2);
                float r1_z_5 = (r1_z_4 * r2_z_3);
                float r1_z_6 = mad(r1_y_6, r1_z_5, 1);
                float r2_z_4 = (-abs(r0_w_6) + 1);
                float r2_w_10 = (r2_z_4 * r2_z_4);
                float r2_w_11 = (r2_w_10 * r2_w_10);
                float r2_z_5 = (r2_z_4 * r2_w_11);
                float r1_y_7 = mad(r1_y_6, r2_z_5, 1);
                float r1_y_8 = (r1_y_7 * r1_z_6);
                float r1_y_9 = (r2_x_2 * r1_y_8);
                float r1_z_7 = (r4_w_12 * r4_w_12);
                float r1_z_8 = max(r1_z_7, 0.002);
                float r2_w_12 = (-r1_z_8 + 1);
                float r3_w_17 = mad(abs(r0_w_6), r2_w_12, r1_z_8);
                float r2_w_13 = mad(r2_x_2, r2_w_12, r1_z_8);
                float r0_w_7 = (abs(r0_w_6) * r2_w_13);
                float r0_w_8 = mad(r2_x_2, r3_w_17, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r2_w_14 = (r1_z_8 * r1_z_8);
                float r3_w_18 = mad(r2_y_2, r2_w_14, -r2_y_2);
                float r2_y_3 = mad(r3_w_18, r2_y_2, 1);
                float r2_w_15 = (r2_w_14 * 0.31830987);
                float r2_y_4 = mad(r2_y_3, r2_y_3, 1E-07);
                float r2_y_5 = (r2_w_15 / r2_y_4);
                float r0_w_11 = (r0_w_10 * r2_y_5);
                float r0_w_12 = (r0_w_11 * 3.1415927);
                float r0_w_13 = (r2_x_2 * r0_w_12);
                float r0_w_14 = max(r0_w_13, 0);
                float r1_z_9 = mad(r1_z_8, r1_z_8, 1);
                float r1_z_10 = ((float4(1, 1, 1, 1) / r1_z_9)).z;
                float r0_w_15 = (r0_w_14 * asfloat(asint((float)((dot(r3_xyz_4.xyzx, r3_xyz_4.xyzx) != 0))) & asint(1065353216)));
                float r1_w_6 = mad(r6_xy_1.y, _Glossiness, -r1_w_5);
                float r1_w_7 = saturate((r1_w_6 + 1));
                float4 r2_xyzw_6 = (r1_y_9.xxxx * r9_xyz_1.xyxz);
                float r2_x_6 = r2_xyzw_6.x;
                float r2_y_6 = r2_xyzw_6.y;
                float r2_w_16 = r2_xyzw_6.w;
                float r0_w_16 = (-r1_x_4 + 1);
                float r1_x_5 = (r0_w_16 * r0_w_16);
                float r1_x_6 = (r1_x_5 * r1_x_5);
                float4 r0_xyzw_13 = (float4(r0_x_12, r0_y_6, r0_z_6, r0_w_16) * float4(r1_z_10, r1_z_10, r1_z_10, r1_x_6));
                float4 r7_xyzw_7 = (-r3_xyz_4.xyzx + float4(1, 1, 1, 0));
                float r7_x_7 = r7_xyzw_7.x;
                float r7_y_6 = r7_xyzw_7.y;
                float r7_z_6 = r7_xyzw_7.z;
                float4 r7_xyzw_8 = mad(float4(r7_x_7, r7_y_6, r7_z_6, r7_x_7), r0_xyzw_13.wwww, r3_xyz_4.xyzx);
                float r7_x_8 = r7_xyzw_8.x;
                float r7_y_7 = r7_xyzw_8.y;
                float r7_z_7 = r7_xyzw_8.z;
                float4 r2_xyzw_7 = mad(((r1_w_5.xxxx * ((r3_xyz_2.xyzx * r4_xyz_3.xyzx)).xyzx)).xyxz, float4(r2_x_6, r2_y_6, r2_x_6, r2_w_16), ((((r9_xyz_1.xyzx * r0_w_15.xxxx)).xyzx * float4(r7_x_8, r7_y_7, r7_z_7, r7_x_8))).xyxz);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_7 = r2_xyzw_7.y;
                float r2_w_17 = r2_xyzw_7.w;
                float4 r1_xyzw_7 = (-r3_xyz_4.xyzx + r1_w_7.xxxx);
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_10 = r1_xyzw_7.y;
                float r1_z_11 = r1_xyzw_7.z;
                float4 r1_xyzw_8 = mad(r2_z_5.xxxx, float4(r1_x_7, r1_y_10, r1_z_11, r1_x_7), r3_xyz_4.xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_11 = r1_xyzw_8.y;
                float r1_z_12 = r1_xyzw_8.z;
                float4 r0_xyzw_14 = mad(r0_xyzw_13.xyzx, float4(r1_x_8, r1_y_11, r1_z_12, r1_x_8), float4(r2_x_7, r2_y_7, r2_w_17, r2_x_7));
                float r0_x_14 = r0_xyzw_14.x;
                float r0_y_8 = r0_xyzw_14.y;
                float r0_z_8 = r0_xyzw_14.z;
                float4 r0_xyzw_15 = mad(float4(r6_x_2, r6_z_3, r6_w_3, r6_x_2), _EmissionColor.xyzx, float4(r0_x_14, r0_y_8, r0_z_8, r0_x_14));
                float r0_x_15 = r0_xyzw_15.x;
                float r0_y_9 = r0_xyzw_15.y;
                float r0_z_9 = r0_xyzw_15.z;
                float4 r1_xyzw_9 = mad(float4(r0_x_15, r0_y_9, r0_z_9, r0_x_15), i.color0.xyzx, -float4(r0_x_15, r0_y_9, r0_z_9, r0_x_15));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_12 = r1_xyzw_9.y;
                float r1_z_13 = r1_xyzw_9.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_9, r1_y_12, r1_z_13, r1_x_9), float4(0.1, 0.1, 0.1, 0), float4(r0_x_15, r0_y_9, r0_z_9, r0_x_15))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "PerformanceChecks"="False" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float _BumpScale : packoffset(c4.x);
                float _Metallic : packoffset(c4.y);
                float _Glossiness : packoffset(c4.z);
                float _OcclusionStrength : packoffset(c4.w);
                float _Cutoff : packoffset(c5.x);
                float4 _Color : packoffset(c6);
                float4 _EmissionColor : packoffset(c7);
                float4 _MainTex_ST : packoffset(c8);
                float4 _BumpMap_ST : packoffset(c9);
                float4 _MetallicGlossMap_ST : packoffset(c10);
                float4 _OcclusionMap_ST : packoffset(c11);
                float4 _EmissionMap_ST : packoffset(c12);
                float4 _DetailMask_ST : packoffset(c13);
                float4 _DetailAlbedo_ST : packoffset(c14);
                float4 _DetailNormal_ST : packoffset(c15);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
                float4 cb1_values[46];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[42];
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
                float4 cb3_values[21];
            };
            cbuffer _UnityProbeVolumeCB_b4
            {
                float4 unity_ProbeVolumeParams : packoffset(c0);
                float4x4 unity_ProbeVolumeWorldToObject : packoffset(c1);
                float3 unity_ProbeVolumeSizeInv : packoffset(c5);
                float3 unity_ProbeVolumeMin : packoffset(c6);
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_MainTex;
            SamplerState sampler_EmissionMap;
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_DetailAlbedo;
            SamplerState sampler_DetailNormal;
            SamplerState sampler_BumpMap;
            SamplerState sampler_MetallicGlossMap;
            SamplerState sampler_DetailMask;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _MetallicGlossMap;
            Texture2D _OcclusionMap;
            Texture2D _EmissionMap;
            Texture2D _DetailMask;
            Texture2D _DetailAlbedo;
            Texture2D _DetailNormal;
            TextureCube t8;
            TextureCube t9;
            Texture3D t10;
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
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 color0 : COLOR0;
                float3 texcoord7 : TEXCOORD7;
                float4 texcoord8 : TEXCOORD8;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program19Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 color0 : COLOR0;
                float3 texcoord7 : TEXCOORD7;
                float4 texcoord8 : TEXCOORD8;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program19Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program7Output vert(program7Input i)
            {
                program7Output o = (program7Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float3 r0_xyz_4 = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _MetallicGlossMap_ST.xyxx, _MetallicGlossMap_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _OcclusionMap_ST.xxxy, _OcclusionMap_ST.zzzw)).zw;
                o.texcoord2.xy = (mad(i.texcoord0.xyxx, _EmissionMap_ST.xyxx, _EmissionMap_ST.zwzz)).xy;
                o.texcoord2.zw = (mad(i.texcoord0.xxxy, _DetailMask_ST.xxxy, _DetailMask_ST.zzzw)).zw;
                o.texcoord3.xy = (mad(i.texcoord0.xyxx, _DetailAlbedo_ST.xyxx, _DetailAlbedo_ST.zwzz)).xy;
                o.texcoord3.zw = (mad(i.texcoord0.xxxy, _DetailNormal_ST.xxxy, _DetailNormal_ST.zzzw)).zw;
                o.texcoord4.w = r0_xyz_4.x;
                float3 worldTangent_xyz_2 = ((i.tangent0.yyyy * cb2_values[1].yzxy)).xyz;
                float3 worldTangent_xyz_3 = (mad(cb2_values[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_2.xyzx)).xyz;
                float3 worldTangent_xyz_4 = (mad(cb2_values[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_3.xyzx)).xyz;
                float3 unitWorldTangent_xyz_5 = (((rsqrt(dot(worldTangent_xyz_4.xyzx, worldTangent_xyz_4.xyzx))).xxxx * worldTangent_xyz_4.xyzx)).xyz;
                o.texcoord4.x = unitWorldTangent_xyz_5.z;
                float worldNormal_x_4 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float4 unitWorldNormal_xyzw_5 = ((rsqrt(dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4)))).xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_z_4));
                float3 r3_xyz_3 = ((((i.tangent0.w * cb2_values[9].w)).xxxx * (mad(unitWorldNormal_xyzw_5.ywxy, unitWorldTangent_xyz_5.yzxy, ((unitWorldTangent_xyz_5.xyzx * unitWorldNormal_xyzw_5.wxyw)).xyzx)).xyzx)).xyz;
                o.texcoord4.y = r3_xyz_3.x;
                o.texcoord4.z = unitWorldNormal_xyzw_5.x;
                o.texcoord5.x = unitWorldTangent_xyz_5.x;
                o.texcoord6.x = unitWorldTangent_xyz_5.y;
                o.texcoord5.w = r0_xyz_4.y;
                o.texcoord6.w = r0_xyz_4.z;
                o.texcoord5.y = r3_xyz_3.y;
                o.texcoord6.y = r3_xyz_3.z;
                o.texcoord5.z = unitWorldNormal_xyzw_5.y;
                o.texcoord6.z = unitWorldNormal_xyzw_5.w;
                o.color0.xyzw = i.color0.xyzw;
                float4 r1_xyzw_6 = (unitWorldNormal_xyzw_5.ywzx * unitWorldNormal_xyzw_5);
                float r2_x_6 = dot(cb1_values[42].xyzw, r1_xyzw_6);
                float r2_y_6 = dot(cb1_values[43].xyzw, r1_xyzw_6);
                float r2_z_6 = dot(cb1_values[44].xyzw, r1_xyzw_6);
                o.texcoord7.xyz = (mad(cb1_values[45].xyzx, (mad(unitWorldNormal_xyzw_5.x, unitWorldNormal_xyzw_5.x, (unitWorldNormal_xyzw_5.y * unitWorldNormal_xyzw_5.y))).xxxx, float4(r2_x_6, r2_y_6, r2_z_6, r2_x_6))).xyz;
                o.texcoord8.xyzw = float4(0, 0, 0, 0);
                o.texcoord9.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program19Output frag(program19Input i)
            {
                program19Output o = (program19Output)0;
                float TEXCOORD4_x_1 = i.texcoord4.w;
                float TEXCOORD5_y_1 = i.texcoord5.w;
                float TEXCOORD6_z_1 = i.texcoord6.w;
                float3 viewDir_xyz_1 = ((-float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1) + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float4 r3_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r3_xyz_2 = ((r3_xyzw_1.xyzx * _Color.xyzx)).xyz;
                float r1_w_1 = (_BumpMap.Sample(sampler_BumpMap, (i.texcoord2.zwzz).xy)).w;
                float3 r4_xyz_1 = (_MetallicGlossMap.Sample(sampler_MetallicGlossMap, (i.texcoord3.xyxx).xy)).xyz;
                float3 r4_xyz_3 = (mad(r1_w_1.xxxx, (mad(r4_xyz_1.xyzx, float4(2, 2, 2, 0), float4(-2, -2, -2, 0))).xyzx, float4(1, 1, 1, 0))).xyz;
                float2 r6_xy_1 = (_OcclusionMap.Sample(sampler_OcclusionMap, (i.texcoord1.xyxx).xy)).xy;
                float3 r7_xyz_1 = (_EmissionMap.Sample(sampler_EmissionMap, (i.texcoord0.zwzz).xy)).xyz;
                float r7_x_2 = (r7_xyz_1.z * r7_xyz_1.x);
                float2 r6_zw_1 = (mad(float4(r7_x_2, r7_x_2, r7_x_2, r7_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r7_xyzw_3 = (r6_zw_1.xyxx * _BumpScale.xxxx);
                float r7_x_3 = r7_xyzw_3.x;
                float r7_y_2 = r7_xyzw_3.y;
                float r2_w_1 = dot(float4(r7_x_3, r7_y_2, r7_x_3, r7_x_3), float4(r7_x_3, r7_y_2, r7_x_3, r7_x_3));
                float r2_w_2 = min(r2_w_1, 1);
                float r2_w_3 = (-r2_w_2 + 1);
                float r7_z_2 = sqrt(r2_w_3);
                float3 r8_xyz_1 = (_DetailMask.Sample(sampler_DetailMask, (i.texcoord3.zwzz).xy)).xyz;
                float r8_x_2 = (r8_xyz_1.z * r8_xyz_1.x);
                float2 r6_zw_2 = (mad(float4(r8_x_2, r8_x_2, r8_x_2, r8_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r8_xyzw_3 = (r6_zw_2.xyxx * _BumpScale.xxxx);
                float r8_x_3 = r8_xyzw_3.x;
                float r8_y_2 = r8_xyzw_3.y;
                float r2_w_4 = dot(float4(r8_x_3, r8_y_2, r8_x_3, r8_x_3), float4(r8_x_3, r8_y_2, r8_x_3, r8_x_3));
                float r2_w_5 = min(r2_w_4, 1);
                float r2_w_6 = (-r2_w_5 + 1);
                float r8_z_2 = sqrt(r2_w_6);
                float4 r7_xyzw_4 = mad(float4(r8_x_3, r8_y_2, r8_z_2, r8_x_3), r1_w_1.xxxx, float4(r7_x_3, r7_y_2, r7_z_2, r7_x_3));
                float r7_x_4 = r7_xyzw_4.x;
                float r7_y_3 = r7_xyzw_4.y;
                float r7_z_3 = r7_xyzw_4.z;
                float r1_w_2 = dot(float4(r7_x_4, r7_y_3, r7_z_3, r7_x_4), float4(r7_x_4, r7_y_3, r7_z_3, r7_x_4));
                float r1_w_3 = rsqrt(r1_w_2);
                float4 r7_xyzw_5 = (r1_w_3.xxxx * float4(r7_x_4, r7_y_3, r7_z_3, r7_x_4));
                float r7_x_5 = r7_xyzw_5.x;
                float r7_y_4 = r7_xyzw_5.y;
                float r7_z_4 = r7_xyzw_5.z;
                float r1_w_4 = (r6_xy_1.x * _Metallic);
                float r2_w_7 = (_DetailAlbedo.Sample(sampler_DetailAlbedo, (i.texcoord1.zwzz).xy)).w;
                float r2_w_8 = (r2_w_7 + -1);
                float r2_w_9 = mad(_OcclusionStrength, r2_w_8, 1);
                float4 r6_xyzw_2 = _DetailNormal.Sample(sampler_DetailNormal, (i.texcoord2.xyxx).xy);
                float r6_x_2 = r6_xyzw_2.x;
                float r6_z_3 = r6_xyzw_2.z;
                float r6_w_3 = r6_xyzw_2.w;
                float r3_w_2 = mad(r3_xyzw_1.w, _Color.w, -_Cutoff);
                float r3_w_3 = (r3_w_2 < 0);
                if (r3_w_3) discard;
                float r3_w_4 = (unity_ProbeVolumeParams.x == 1);
                float r8_x_13;
                float r8_y_12;
                float r8_z_12;
                float r8_w_4;
                if (r3_w_4)
                {
                    float r4_w_1 = (unity_ProbeVolumeParams.y == 1);
                    float4 r8_xyzw_5 = (i.texcoord5.wwww * unity_ProbeVolumeWorldToObject[1].xyzx);
                    float r8_x_5 = r8_xyzw_5.x;
                    float r8_y_4 = r8_xyzw_5.y;
                    float r8_z_4 = r8_xyzw_5.z;
                    float4 r8_xyzw_6 = mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord4.wwww, float4(r8_x_5, r8_y_4, r8_z_4, r8_x_5));
                    float r8_x_6 = r8_xyzw_6.x;
                    float r8_y_5 = r8_xyzw_6.y;
                    float r8_z_5 = r8_xyzw_6.z;
                    float4 r8_xyzw_7 = mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord6.wwww, float4(r8_x_6, r8_y_5, r8_z_5, r8_x_6));
                    float r8_x_7 = r8_xyzw_7.x;
                    float r8_y_6 = r8_xyzw_7.y;
                    float r8_z_6 = r8_xyzw_7.z;
                    float4 r8_xyzw_8 = (float4(r8_x_7, r8_y_6, r8_z_6, r8_x_7) + unity_ProbeVolumeWorldToObject[3].xyzx);
                    float r8_x_8 = r8_xyzw_8.x;
                    float r8_y_7 = r8_xyzw_8.y;
                    float r8_z_7 = r8_xyzw_8.z;
                    float4 unity_ProbeVolumeParamsSelect_xyzw_9 = (r4_w_1.xxxx ? float4(r8_x_8, r8_y_7, r8_z_7, r8_x_8) : float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1));
                    float unity_ProbeVolumeParamsSelect_x_9 = unity_ProbeVolumeParamsSelect_xyzw_9.x;
                    float unity_ProbeVolumeParamsSelect_y_8 = unity_ProbeVolumeParamsSelect_xyzw_9.y;
                    float unity_ProbeVolumeParamsSelect_z_8 = unity_ProbeVolumeParamsSelect_xyzw_9.z;
                    float4 r8_xyzw_10 = (float4(unity_ProbeVolumeParamsSelect_x_9, unity_ProbeVolumeParamsSelect_y_8, unity_ProbeVolumeParamsSelect_z_8, unity_ProbeVolumeParamsSelect_x_9) + -unity_ProbeVolumeMin.xyzx);
                    float r8_x_10 = r8_xyzw_10.x;
                    float r8_y_9 = r8_xyzw_10.y;
                    float r8_z_9 = r8_xyzw_10.z;
                    float r8_y_10 = ((float4(r8_x_10, r8_x_10, r8_y_9, r8_z_9) * unity_ProbeVolumeSizeInv.xxyz)).y;
                    float r8_z_10 = ((float4(r8_x_10, r8_x_10, r8_y_9, r8_z_9) * unity_ProbeVolumeSizeInv.xxyz)).z;
                    float r8_w_2 = ((float4(r8_x_10, r8_x_10, r8_y_9, r8_z_9) * unity_ProbeVolumeSizeInv.xxyz)).w;
                    float r4_w_2 = mad(r8_y_10, 0.25, 0.75);
                    float r5_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r8_x_11 = max(r4_w_2, r5_w_1);
                    float4 r8_xyzw_12 = t10.Sample(sampler_linear_clamp1, (float4(r8_x_11, r8_z_10, r8_w_2, r8_x_11)).xyz);
                    r8_x_13 = r8_xyzw_12.x;
                    r8_y_12 = r8_xyzw_12.y;
                    r8_z_12 = r8_xyzw_12.z;
                    r8_w_4 = r8_xyzw_12.w;
                }
                else
                {
                    float4 r8_xyzw_4 = float4(1, 1, 1, 1);
                    r8_x_13 = r8_xyzw_4.x;
                    r8_y_12 = r8_xyzw_4.y;
                    r8_z_12 = r8_xyzw_4.z;
                    r8_w_4 = r8_xyzw_4.w;
                }
                float r4_w_4 = saturate(dot(float4(r8_x_13, r8_y_12, r8_z_12, r8_w_4), unity_OcclusionMaskSelector));
                float r8_x_14 = dot(i.texcoord4.xyzx, float4(r7_x_5, r7_y_4, r7_z_4, r7_x_5));
                float r8_y_13 = dot(i.texcoord5.xyzx, float4(r7_x_5, r7_y_4, r7_z_4, r7_x_5));
                float r8_z_13 = dot(i.texcoord6.xyzx, float4(r7_x_5, r7_y_4, r7_z_4, r7_x_5));
                float r5_w_3 = dot(float4(r8_x_14, r8_y_13, r8_z_13, r8_x_14), float4(r8_x_14, r8_y_13, r8_z_13, r8_x_14));
                float r5_w_4 = rsqrt(r5_w_3);
                float4 r7_xyzw_6 = (r5_w_4.xxxx * float4(r8_x_14, r8_y_13, r8_z_13, r8_x_14));
                float r7_x_6 = r7_xyzw_6.x;
                float r7_y_5 = r7_xyzw_6.y;
                float r7_z_5 = r7_xyzw_6.z;
                float r5_w_5 = mad(-r6_xy_1.y, _Glossiness, 1);
                float r8_x_15 = dot(-unitViewDir_xyz_1.xyzx, float4(r7_x_6, r7_y_5, r7_z_5, r7_x_6));
                float4 r8_xyzw_17 = mad(float4(r7_x_6, r7_y_5, r7_z_5, r7_x_6), ((r8_x_15 + r8_x_15)).xxxx, -unitViewDir_xyz_1.xyzx);
                float r8_x_17 = r8_xyzw_17.x;
                float r8_y_14 = r8_xyzw_17.y;
                float r8_z_14 = r8_xyzw_17.z;
                float3 r9_xyz_1 = ((r4_w_4.xxxx * _LightColor0.xyzx)).xyz;
                float3 r11_xyz_4;
                if (r3_w_4)
                {
                    float r3_w_5 = (unity_ProbeVolumeParams.y == 1);
                    float3 r10_xyz_4 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord6.wwww, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord4.wwww, ((i.texcoord5.wwww * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_5 = ((r3_w_5.xxxx ? r10_xyz_4.xyzx : float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1))).xyz;
                    float4 r10_xyzw_7 = (((unity_ProbeVolumeParamsSelect_xyz_5.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r10_y_7 = r10_xyzw_7.y;
                    float r10_z_7 = r10_xyzw_7.z;
                    float r10_w_1 = r10_xyzw_7.w;
                    float r3_w_6 = (r10_y_7 * 0.25);
                    float r4_w_5 = (unity_ProbeVolumeParams.z * 0.5);
                    float r8_w_5 = mad(-unity_ProbeVolumeParams.z, 0.5, 0.25);
                    float r3_w_7 = max(r3_w_6, r4_w_5);
                    float r10_x_7 = min(r8_w_5, r3_w_7);
                    float4 r11_xyzw_2 = t10.Sample(sampler_linear_clamp1, (float4(r10_x_7, r10_z_7, r10_w_1, r10_x_7)).xyz);
                    float4 r12_xyzw_2 = t10.Sample(sampler_linear_clamp1, (((float4(r10_x_7, r10_z_7, r10_w_1, r10_x_7) + float4(0.25, 0, 0, 0))).xyzx).xyz);
                    float4 r10_xyzw_9 = t10.Sample(sampler_linear_clamp1, (((float4(r10_x_7, r10_z_7, r10_w_1, r10_x_7) + float4(0.5, 0, 0, 0))).xyzx).xyz);
                    float r7_w_2 = 1;
                    float r11_x_3 = dot(r11_xyzw_2, float4(r7_x_6, r7_y_5, r7_z_5, r7_w_2));
                    float r11_y_3 = dot(r12_xyzw_2, float4(r7_x_6, r7_y_5, r7_z_5, r7_w_2));
                    float r11_z_3 = dot(r10_xyzw_9, float4(r7_x_6, r7_y_5, r7_z_5, r7_w_2));
                    r11_xyz_4 = float3(r11_x_3, r11_y_3, r11_z_3);
                }
                else
                {
                    float r7_w_1 = 1;
                    float r11_x_1 = dot(cb2_values[39].xyzw, float4(r7_x_6, r7_y_5, r7_z_5, r7_w_1));
                    float r11_y_1 = dot(cb2_values[40].xyzw, float4(r7_x_6, r7_y_5, r7_z_5, r7_w_1));
                    float r11_z_1 = dot(cb2_values[41].xyzw, float4(r7_x_6, r7_y_5, r7_z_5, r7_w_1));
                    r11_xyz_4 = float3(r11_x_1, r11_y_1, r11_z_1);
                }
                float r3_w_9 = (0 < unity_SpecCube0_ProbePosition.w);
                float3 r11_xyz_8;
                if (r3_w_9)
                {
                    float r3_w_10 = dot(float4(r8_x_17, r8_y_14, r8_z_14, r8_x_17), float4(r8_x_17, r8_y_14, r8_z_14, r8_x_17));
                    float r3_w_11 = rsqrt(r3_w_10);
                    float3 r11_xyz_6 = ((r3_w_11.xxxx * float4(r8_x_17, r8_y_14, r8_z_14, r8_x_17))).xyz;
                    float3 r14_xyz_1 = ((float4(0, 0, 0, 0) < r11_xyz_6.xyzx)).xyz;
                    float3 r12_xyz_6 = ((r14_xyz_1.xyzx ? ((((-float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1) + unity_SpecCube0_BoxMax.xyzx)).xyzx / r11_xyz_6.xyzx)).xyzx : ((((-float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1) + unity_SpecCube0_BoxMin.xyzx)).xyzx / r11_xyz_6.xyzx)).xyzx)).xyz;
                    float r3_w_12 = min(r12_xyz_6.y, r12_xyz_6.x);
                    float r3_w_13 = min(r12_xyz_6.z, r3_w_12);
                    r11_xyz_8 = (mad(r11_xyz_6.xyzx, r3_w_13.xxxx, ((float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1) + -unity_SpecCube0_ProbePosition.xyzx)).xyzx)).xyz;
                }
                else
                {
                    r11_xyz_8 = (float4(r8_x_17, r8_y_14, r8_z_14, r8_x_17)).xyz;
                }
                float r3_w_15 = mad(-r5_w_5, 0.7, 1.7);
                float r3_w_16 = (r3_w_15 * r5_w_5);
                float r3_w_17 = (r3_w_16 * 6);
                float4 r11_xyzw_9 = t8.SampleLevel(sampler_linear_clamp, r11_xyz_8.xyz, r3_w_17);
                float r4_w_7 = (r11_xyzw_9.w + -1);
                float r4_w_8 = mad(unity_SpecCube0_HDR.w, r4_w_7, 1);
                float r4_w_9 = log2(r4_w_8);
                float r4_w_10 = (r4_w_9 * unity_SpecCube0_HDR.y);
                float r4_w_11 = exp2(r4_w_10);
                float r4_w_12 = (r4_w_11 * unity_SpecCube0_HDR.x);
                float r7_w_4 = (unity_SpecCube0_BoxMin.w < 0.99999);
                float3 r12_xyz_11 = ((r11_xyzw_9.xyzx * r4_w_12.xxxx)).xyz;
                if (r7_w_4)
                {
                    float r7_w_5 = (0 < unity_SpecCube1_ProbePosition.w);
                    float r8_x_19 = r8_x_17;
                    float r8_y_16 = r8_y_14;
                    float r8_z_16 = r8_z_14;
                    if (r7_w_5)
                    {
                        float r7_w_6 = dot(float4(r8_x_17, r8_y_14, r8_z_14, r8_x_17), float4(r8_x_17, r8_y_14, r8_z_14, r8_x_17));
                        float r7_w_7 = rsqrt(r7_w_6);
                        float3 r13_xyz_4 = ((r7_w_7.xxxx * float4(r8_x_17, r8_y_14, r8_z_14, r8_x_17))).xyz;
                        float3 r16_xyz_1 = ((float4(0, 0, 0, 0) < r13_xyz_4.xyzx)).xyz;
                        float3 r14_xyz_5 = ((r16_xyz_1.xyzx ? ((((-float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1) + unity_SpecCube1_BoxMax.xyzx)).xyzx / r13_xyz_4.xyzx)).xyzx : ((((-float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1) + unity_SpecCube1_BoxMin.xyzx)).xyzx / r13_xyz_4.xyzx)).xyzx)).xyz;
                        float r7_w_8 = min(r14_xyz_5.y, r14_xyz_5.x);
                        float r7_w_9 = min(r14_xyz_5.z, r7_w_8);
                        float4 r8_xyzw_18 = mad(r13_xyz_4.xyzx, r7_w_9.xxxx, ((float4(TEXCOORD4_x_1, TEXCOORD5_y_1, TEXCOORD6_z_1, TEXCOORD4_x_1) + -unity_SpecCube1_ProbePosition.xyzx)).xyzx);
                        float r8_x_18 = r8_xyzw_18.x;
                        float r8_y_15 = r8_xyzw_18.y;
                        float r8_z_15 = r8_xyzw_18.z;
                        r8_x_19 = r8_x_18;
                        r8_y_16 = r8_y_15;
                        r8_z_16 = r8_z_15;
                    }
                    float4 r8_xyzw_20 = t9.SampleLevel(sampler_linear_clamp, (float4(r8_x_19, r8_y_16, r8_z_16, r8_x_19)).xyz, r3_w_17);
                                        float4 r0_xyzw_10 = (r8_xyzw_20.xyzx * ((pow(mad(unity_SpecCube1_HDR.w, (r8_xyzw_20.w + -1), 1), unity_SpecCube1_HDR.y) * unity_SpecCube1_HDR.x)).xxxx);
                    float r0_x_10 = r0_xyzw_10.x;
                    float r0_y_4 = r0_xyzw_10.y;
                    float r0_z_4 = r0_xyzw_10.z;
                    float4 r8_xyzw_21 = mad(r4_w_12.xxxx, r11_xyzw_9.xyzx, -float4(r0_x_10, r0_y_4, r0_z_4, r0_x_10));
                    float r8_x_21 = r8_xyzw_21.x;
                    float r8_y_18 = r8_xyzw_21.y;
                    float r8_z_18 = r8_xyzw_21.z;
                    r12_xyz_11 = (mad(unity_SpecCube0_BoxMin.wwww, float4(r8_x_21, r8_y_18, r8_z_18, r8_x_21), float4(r0_x_10, r0_y_4, r0_z_4, r0_x_10))).xyz;
                }
                float4 r0_xyzw_12 = (r2_w_9.xxxx * r12_xyz_11.xyzx);
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_6 = r0_xyzw_12.y;
                float r0_z_6 = r0_xyzw_12.z;
                float3 r3_xyz_4 = (mad(r1_w_4.xxxx, (mad(r3_xyz_2.xyzx, r4_xyz_3.xyzx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_5 = mad(-r1_w_4, 0.96, 0.96);
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r1_xyz_3 = ((r0_w_5.xxxx * r1_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r7_x_6, r7_y_5, r7_z_5, r7_x_6), unitViewDir_xyz_1.xyzx);
                float r2_x_2 = saturate(dot(float4(r7_x_6, r7_y_5, r7_z_5, r7_x_6), _WorldSpaceLightPos0.xyzx));
                float r2_y_2 = saturate(dot(float4(r7_x_6, r7_y_5, r7_z_5, r7_x_6), r1_xyz_3.xyzx));
                float r1_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r1_xyz_3.xyzx));
                float r1_y_4 = (r1_x_4 * r1_x_4);
                float r1_y_5 = dot(r1_y_4.xxxx, r5_w_5.xxxx);
                float r1_y_6 = (r1_y_5 + -0.5);
                float r1_z_4 = (-r2_x_2 + 1);
                float r2_z_2 = (r1_z_4 * r1_z_4);
                float r2_z_3 = (r2_z_2 * r2_z_2);
                float r1_z_5 = (r1_z_4 * r2_z_3);
                float r1_z_6 = mad(r1_y_6, r1_z_5, 1);
                float r2_z_4 = (-abs(r0_w_6) + 1);
                float r3_w_18 = (r2_z_4 * r2_z_4);
                float r3_w_19 = (r3_w_18 * r3_w_18);
                float r2_z_5 = (r2_z_4 * r3_w_19);
                float r1_y_7 = mad(r1_y_6, r2_z_5, 1);
                float r1_y_8 = (r1_y_7 * r1_z_6);
                float r1_y_9 = (r2_x_2 * r1_y_8);
                float r1_z_7 = (r5_w_5 * r5_w_5);
                float r1_z_8 = max(r1_z_7, 0.002);
                float r3_w_20 = (-r1_z_8 + 1);
                float r4_w_13 = mad(abs(r0_w_6), r3_w_20, r1_z_8);
                float r3_w_21 = mad(r2_x_2, r3_w_20, r1_z_8);
                float r0_w_7 = (abs(r0_w_6) * r3_w_21);
                float r0_w_8 = mad(r2_x_2, r4_w_13, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r3_w_22 = (r1_z_8 * r1_z_8);
                float r4_w_14 = mad(r2_y_2, r3_w_22, -r2_y_2);
                float r2_y_3 = mad(r4_w_14, r2_y_2, 1);
                float r3_w_23 = (r3_w_22 * 0.31830987);
                float r2_y_4 = mad(r2_y_3, r2_y_3, 1E-07);
                float r2_y_5 = (r3_w_23 / r2_y_4);
                float r0_w_11 = (r0_w_10 * r2_y_5);
                float r0_w_12 = (r0_w_11 * 3.1415927);
                float r0_w_13 = (r2_x_2 * r0_w_12);
                float r0_w_14 = max(r0_w_13, 0);
                float r1_z_9 = mad(r1_z_8, r1_z_8, 1);
                float r1_z_10 = ((float4(1, 1, 1, 1) / r1_z_9)).z;
                float r0_w_15 = (r0_w_14 * asfloat(asint((float)((dot(r3_xyz_4.xyzx, r3_xyz_4.xyzx) != 0))) & asint(1065353216)));
                float r1_w_6 = mad(r6_xy_1.y, _Glossiness, -r1_w_5);
                float r1_w_7 = saturate((r1_w_6 + 1));
                float4 r2_xyzw_6 = mad((max(((r11_xyz_4.xyzx + i.texcoord7.xyzx)).xyzx, float4(0, 0, 0, 0))).xyxz, r2_w_9.xxxx, ((r1_y_9.xxxx * r9_xyz_1.xyzx)).xyxz);
                float r2_x_6 = r2_xyzw_6.x;
                float r2_y_6 = r2_xyzw_6.y;
                float r2_w_10 = r2_xyzw_6.w;
                float r0_w_16 = (-r1_x_4 + 1);
                float r1_x_5 = (r0_w_16 * r0_w_16);
                float r1_x_6 = (r1_x_5 * r1_x_5);
                float4 r0_xyzw_13 = (float4(r0_x_12, r0_y_6, r0_z_6, r0_w_16) * float4(r1_z_10, r1_z_10, r1_z_10, r1_x_6));
                float4 r7_xyzw_7 = (-r3_xyz_4.xyzx + float4(1, 1, 1, 0));
                float r7_x_7 = r7_xyzw_7.x;
                float r7_y_6 = r7_xyzw_7.y;
                float r7_z_6 = r7_xyzw_7.z;
                float4 r7_xyzw_8 = mad(float4(r7_x_7, r7_y_6, r7_z_6, r7_x_7), r0_xyzw_13.wwww, r3_xyz_4.xyzx);
                float r7_x_8 = r7_xyzw_8.x;
                float r7_y_7 = r7_xyzw_8.y;
                float r7_z_7 = r7_xyzw_8.z;
                float4 r2_xyzw_7 = mad(((r1_w_5.xxxx * ((r3_xyz_2.xyzx * r4_xyz_3.xyzx)).xyzx)).xyxz, float4(r2_x_6, r2_y_6, r2_x_6, r2_w_10), ((((r9_xyz_1.xyzx * r0_w_15.xxxx)).xyzx * float4(r7_x_8, r7_y_7, r7_z_7, r7_x_8))).xyxz);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_7 = r2_xyzw_7.y;
                float r2_w_11 = r2_xyzw_7.w;
                float4 r1_xyzw_7 = (-r3_xyz_4.xyzx + r1_w_7.xxxx);
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_10 = r1_xyzw_7.y;
                float r1_z_11 = r1_xyzw_7.z;
                float4 r1_xyzw_8 = mad(r2_z_5.xxxx, float4(r1_x_7, r1_y_10, r1_z_11, r1_x_7), r3_xyz_4.xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_11 = r1_xyzw_8.y;
                float r1_z_12 = r1_xyzw_8.z;
                float4 r0_xyzw_14 = mad(r0_xyzw_13.xyzx, float4(r1_x_8, r1_y_11, r1_z_12, r1_x_8), float4(r2_x_7, r2_y_7, r2_w_11, r2_x_7));
                float r0_x_14 = r0_xyzw_14.x;
                float r0_y_8 = r0_xyzw_14.y;
                float r0_z_8 = r0_xyzw_14.z;
                float4 r0_xyzw_15 = mad(float4(r6_x_2, r6_z_3, r6_w_3, r6_x_2), _EmissionColor.xyzx, float4(r0_x_14, r0_y_8, r0_z_8, r0_x_14));
                float r0_x_15 = r0_xyzw_15.x;
                float r0_y_9 = r0_xyzw_15.y;
                float r0_z_9 = r0_xyzw_15.z;
                float4 r1_xyzw_9 = mad(float4(r0_x_15, r0_y_9, r0_z_9, r0_x_15), i.color0.xyzx, -float4(r0_x_15, r0_y_9, r0_z_9, r0_x_15));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_12 = r1_xyzw_9.y;
                float r1_z_13 = r1_xyzw_9.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_9, r1_y_12, r1_z_13, r1_x_9), float4(0.1, 0.1, 0.1, 0), float4(r0_x_15, r0_y_9, r0_z_9, r0_x_15))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "PerformanceChecks"="False" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0;
                float _BumpScale;
                float _Metallic;
                float _Glossiness;
                float _OcclusionStrength;
                float _Cutoff;
                float4 _Color;
                float4 _EmissionColor;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 _MetallicGlossMap_ST;
                float4 _OcclusionMap_ST;
                float4 _EmissionMap_ST;
                float4 _DetailMask_ST;
                float4 _DetailAlbedo_ST;
                float4 _DetailNormal_ST;
                float4 cb0_values[19];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0 : packoffset(c0);
                float4x4 unity_MatrixVP : packoffset(c17);
                float4 unity_OcclusionMaskSelector : packoffset(c46);
            };
            cbuffer _UnityProbeVolumeCB_b3
            {
                float4 unity_ProbeVolumeParams : packoffset(c0);
                float4x4 unity_ProbeVolumeWorldToObject : packoffset(c1);
                float3 unity_ProbeVolumeSizeInv : packoffset(c5);
                float3 unity_ProbeVolumeMin : packoffset(c6);
            };
            SamplerState sampler_DetailNormal;
            SamplerState sampler_DetailAlbedo;
            SamplerState sampler_MainTex;
            SamplerState sampler_EmissionMap;
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_BumpMap;
            SamplerState sampler_MetallicGlossMap;
            SamplerState sampler_DetailMask;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _MetallicGlossMap;
            Texture2D _OcclusionMap;
            Texture2D _EmissionMap;
            Texture2D _DetailMask;
            Texture2D _DetailAlbedo;
            Texture3D _DetailNormal;
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
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float3 texcoord7 : TEXCOORD7;
                float4 color0 : COLOR0;
                float3 texcoord8 : TEXCOORD8;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program50Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float3 texcoord7 : TEXCOORD7;
                float4 color0 : COLOR0;
                float3 texcoord8 : TEXCOORD8;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program50Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program27Output vert(program27Input i)
            {
                program27Output o = (program27Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _EmissionMap_ST.xyxx, _EmissionMap_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _DetailMask_ST.xxxy, _DetailMask_ST.zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _DetailAlbedo_ST.xyxx, _DetailAlbedo_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _DetailNormal_ST.xxxy, _DetailNormal_ST.zzzw)).zw;
                o.texcoord2.xy = (mad(i.texcoord0.xyxx, cb0_values[16].xyxx, cb0_values[16].zwzz)).xy;
                o.texcoord2.zw = (mad(i.texcoord0.xxxy, cb0_values[17].xxxy, cb0_values[17].zzzw)).zw;
                o.texcoord3.xy = (mad(i.texcoord0.xyxx, cb0_values[18].xyxx, cb0_values[18].zwzz)).xy;
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                float3 unitWorldNormal_xyz_3 = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_6 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_6.xxxx * (mad(unitWorldNormal_xyz_3.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_3.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord4.y = r3_xyz_3.x;
                o.texcoord4.x = unitWorldTangent_xyz_7.z;
                o.texcoord4.z = unitWorldNormal_xyz_3.y;
                o.texcoord5.x = unitWorldTangent_xyz_7.x;
                o.texcoord6.x = unitWorldTangent_xyz_7.y;
                o.texcoord5.z = unitWorldNormal_xyz_3.z;
                o.texcoord6.z = unitWorldNormal_xyz_3.x;
                o.texcoord5.y = r3_xyz_3.y;
                o.texcoord6.y = r3_xyz_3.z;
                o.texcoord7.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                float3 clipPos_xyz_4 = ((worldPos_xyzw_4.yyyy * cb0_values[5].xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(_Color.xyzx, worldPos_xyzw_4.zzzz, (mad(cb0_values[4].xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_4.xyzx)).xyzx)).xyz;
                o.texcoord8.xyz = (mad(_EmissionColor.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord9.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program50Output frag(program50Input i)
            {
                program50Output o = (program50Output)0;
                float3 r0_xyz_1 = ((-i.texcoord7.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord7.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_2 = normalize(viewDir_xyz_1);
                float4 r3_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r3_xyz_2 = ((r3_xyzw_1.xyzx * cb0_values[10].xyzx)).xyz;
                float r1_w_3 = (_BumpMap.Sample(sampler_BumpMap, (i.texcoord2.xyxx).xy)).w;
                float3 r4_xyz_1 = (_MetallicGlossMap.Sample(sampler_MetallicGlossMap, (i.texcoord2.zwzz).xy)).xyz;
                float3 r4_xyz_3 = (mad(r1_w_3.xxxx, (mad(r4_xyz_1.xyzx, float4(2, 2, 2, 0), float4(-2, -2, -2, 0))).xyzx, float4(1, 1, 1, 0))).xyz;
                float2 r6_xy_1 = (_OcclusionMap.Sample(sampler_OcclusionMap, (i.texcoord1.xyxx).xy)).xy;
                float3 r7_xyz_1 = (_EmissionMap.Sample(sampler_EmissionMap, (i.texcoord0.zwzz).xy)).xyz;
                float r7_x_2 = (r7_xyz_1.z * r7_xyz_1.x);
                float2 r6_zw_1 = (mad(float4(r7_x_2, r7_x_2, r7_x_2, r7_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r7_xyzw_3 = (r6_zw_1.xyxx * cb0_values[8].xxxx);
                float r7_x_3 = r7_xyzw_3.x;
                float r7_y_2 = r7_xyzw_3.y;
                float r2_w_1 = dot(float4(r7_x_3, r7_y_2, r7_x_3, r7_x_3), float4(r7_x_3, r7_y_2, r7_x_3, r7_x_3));
                float r2_w_2 = min(r2_w_1, 1);
                float r2_w_3 = (-r2_w_2 + 1);
                float r7_z_2 = sqrt(r2_w_3);
                float3 r8_xyz_1 = (_DetailMask.Sample(sampler_DetailMask, (i.texcoord3.xyxx).xy)).xyz;
                float r8_x_2 = (r8_xyz_1.z * r8_xyz_1.x);
                float2 r6_zw_2 = (mad(float4(r8_x_2, r8_x_2, r8_x_2, r8_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r8_xyzw_3 = (r6_zw_2.xyxx * cb0_values[8].xxxx);
                float r8_x_3 = r8_xyzw_3.x;
                float r8_y_2 = r8_xyzw_3.y;
                float r2_w_4 = dot(float4(r8_x_3, r8_y_2, r8_x_3, r8_x_3), float4(r8_x_3, r8_y_2, r8_x_3, r8_x_3));
                float r2_w_5 = min(r2_w_4, 1);
                float r2_w_6 = (-r2_w_5 + 1);
                float r8_z_2 = sqrt(r2_w_6);
                float4 r7_xyzw_4 = mad(float4(r8_x_3, r8_y_2, r8_z_2, r8_x_3), r1_w_3.xxxx, float4(r7_x_3, r7_y_2, r7_z_2, r7_x_3));
                float r7_x_4 = r7_xyzw_4.x;
                float r7_y_3 = r7_xyzw_4.y;
                float r7_z_3 = r7_xyzw_4.z;
                float r1_w_4 = dot(float4(r7_x_4, r7_y_3, r7_z_3, r7_x_4), float4(r7_x_4, r7_y_3, r7_z_3, r7_x_4));
                float r1_w_5 = rsqrt(r1_w_4);
                float4 r7_xyzw_5 = (r1_w_5.xxxx * float4(r7_x_4, r7_y_3, r7_z_3, r7_x_4));
                float r7_x_5 = r7_xyzw_5.x;
                float r7_y_4 = r7_xyzw_5.y;
                float r7_z_4 = r7_xyzw_5.z;
                float r1_w_6 = (r6_xy_1.x * cb0_values[8].y);
                float r2_w_7 = mad(r3_xyzw_1.w, cb0_values[10].w, -cb0_values[9].x);
                float r2_w_8 = (r2_w_7 < 0);
                if (r2_w_8) discard;
                float4 r6_xyzw_2 = (i.texcoord7.yyyy * cb0_values[5].xxyz);
                float r6_x_2 = r6_xyzw_2.x;
                float r6_z_3 = r6_xyzw_2.z;
                float r6_w_3 = r6_xyzw_2.w;
                float4 r6_xyzw_3 = mad(cb0_values[4].xxyz, i.texcoord7.xxxx, float4(r6_x_2, r6_x_2, r6_z_3, r6_w_3));
                float r6_x_3 = r6_xyzw_3.x;
                float r6_z_4 = r6_xyzw_3.z;
                float r6_w_4 = r6_xyzw_3.w;
                float4 r6_xyzw_4 = mad(cb0_values[6].xxyz, i.texcoord7.zzzz, float4(r6_x_3, r6_x_3, r6_z_4, r6_w_4));
                float r6_x_4 = r6_xyzw_4.x;
                float r6_z_5 = r6_xyzw_4.z;
                float r6_w_5 = r6_xyzw_4.w;
                float4 r6_xyzw_5 = (float4(r6_x_4, r6_x_4, r6_z_5, r6_w_5) + cb0_values[7].xxyz);
                float r6_x_5 = r6_xyzw_5.x;
                float r6_z_6 = r6_xyzw_5.z;
                float r6_w_6 = r6_xyzw_5.w;
                float r2_w_9 = (unity_ProbeVolumeParams.x == 1);
                float r8_x_13;
                float r8_y_12;
                float r8_z_12;
                float r8_w_4;
                if (r2_w_9)
                {
                    float r2_w_10 = (unity_ProbeVolumeParams.y == 1);
                    float4 r8_xyzw_5 = (i.texcoord7.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx);
                    float r8_x_5 = r8_xyzw_5.x;
                    float r8_y_4 = r8_xyzw_5.y;
                    float r8_z_4 = r8_xyzw_5.z;
                    float4 r8_xyzw_6 = mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord7.xxxx, float4(r8_x_5, r8_y_4, r8_z_4, r8_x_5));
                    float r8_x_6 = r8_xyzw_6.x;
                    float r8_y_5 = r8_xyzw_6.y;
                    float r8_z_5 = r8_xyzw_6.z;
                    float4 r8_xyzw_7 = mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord7.zzzz, float4(r8_x_6, r8_y_5, r8_z_5, r8_x_6));
                    float r8_x_7 = r8_xyzw_7.x;
                    float r8_y_6 = r8_xyzw_7.y;
                    float r8_z_6 = r8_xyzw_7.z;
                    float4 r8_xyzw_8 = (float4(r8_x_7, r8_y_6, r8_z_6, r8_x_7) + unity_ProbeVolumeWorldToObject[3].xyzx);
                    float r8_x_8 = r8_xyzw_8.x;
                    float r8_y_7 = r8_xyzw_8.y;
                    float r8_z_7 = r8_xyzw_8.z;
                    float4 unity_ProbeVolumeParamsSelect_xyzw_9 = (r2_w_10.xxxx ? float4(r8_x_8, r8_y_7, r8_z_7, r8_x_8) : i.texcoord7.xyzx);
                    float unity_ProbeVolumeParamsSelect_x_9 = unity_ProbeVolumeParamsSelect_xyzw_9.x;
                    float unity_ProbeVolumeParamsSelect_y_8 = unity_ProbeVolumeParamsSelect_xyzw_9.y;
                    float unity_ProbeVolumeParamsSelect_z_8 = unity_ProbeVolumeParamsSelect_xyzw_9.z;
                    float4 r8_xyzw_10 = (float4(unity_ProbeVolumeParamsSelect_x_9, unity_ProbeVolumeParamsSelect_y_8, unity_ProbeVolumeParamsSelect_z_8, unity_ProbeVolumeParamsSelect_x_9) + -unity_ProbeVolumeMin.xyzx);
                    float r8_x_10 = r8_xyzw_10.x;
                    float r8_y_9 = r8_xyzw_10.y;
                    float r8_z_9 = r8_xyzw_10.z;
                    float r8_y_10 = ((float4(r8_x_10, r8_x_10, r8_y_9, r8_z_9) * unity_ProbeVolumeSizeInv.xxyz)).y;
                    float r8_z_10 = ((float4(r8_x_10, r8_x_10, r8_y_9, r8_z_9) * unity_ProbeVolumeSizeInv.xxyz)).z;
                    float r8_w_2 = ((float4(r8_x_10, r8_x_10, r8_y_9, r8_z_9) * unity_ProbeVolumeSizeInv.xxyz)).w;
                    float r2_w_11 = mad(r8_y_10, 0.25, 0.75);
                    float r3_w_2 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r8_x_11 = max(r2_w_11, r3_w_2);
                    float4 r8_xyzw_12 = _DetailNormal.Sample(sampler_DetailNormal, (float4(r8_x_11, r8_z_10, r8_w_2, r8_x_11)).xyz);
                    r8_x_13 = r8_xyzw_12.x;
                    r8_y_12 = r8_xyzw_12.y;
                    r8_z_12 = r8_xyzw_12.z;
                    r8_w_4 = r8_xyzw_12.w;
                }
                else
                {
                    float4 r8_xyzw_4 = float4(1, 1, 1, 1);
                    r8_x_13 = r8_xyzw_4.x;
                    r8_y_12 = r8_xyzw_4.y;
                    r8_z_12 = r8_xyzw_4.z;
                    r8_w_4 = r8_xyzw_4.w;
                }
                float r2_w_13 = saturate(dot(float4(r8_x_13, r8_y_12, r8_z_12, r8_w_4), unity_OcclusionMaskSelector));
                float r3_w_4 = dot(float4(r6_x_5, r6_z_6, r6_w_6, r6_x_5), float4(r6_x_5, r6_z_6, r6_w_6, r6_x_5));
                float r3_w_5 = (_DetailAlbedo.Sample(sampler_DetailAlbedo, (r3_w_4.xxxx).xy)).w;
                float r2_w_14 = (r2_w_13 * r3_w_5);
                float r8_x_14 = dot(i.texcoord4.xyzx, float4(r7_x_5, r7_y_4, r7_z_4, r7_x_5));
                float r8_y_13 = dot(i.texcoord5.xyzx, float4(r7_x_5, r7_y_4, r7_z_4, r7_x_5));
                float r8_z_13 = dot(i.texcoord6.xyzx, float4(r7_x_5, r7_y_4, r7_z_4, r7_x_5));
                float r3_w_6 = dot(float4(r8_x_14, r8_y_13, r8_z_13, r8_x_14), float4(r8_x_14, r8_y_13, r8_z_13, r8_x_14));
                float r3_w_7 = rsqrt(r3_w_6);
                float4 r6_xyzw_6 = (r3_w_7.xxxx * float4(r8_x_14, r8_x_14, r8_y_13, r8_z_13));
                float r6_x_6 = r6_xyzw_6.x;
                float r6_z_7 = r6_xyzw_6.z;
                float r6_w_7 = r6_xyzw_6.w;
                float4 r7_xyzw_6 = (r2_w_14.xxxx * _LightColor0.xyzx);
                float r7_x_6 = r7_xyzw_6.x;
                float r7_y_5 = r7_xyzw_6.y;
                float r7_z_5 = r7_xyzw_6.z;
                float3 r3_xyz_4 = (mad(r1_w_6.xxxx, (mad(r3_xyz_2.xyzx, r4_xyz_3.xyzx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_7 = mad(-r1_w_6, 0.96, 0.96);
                float r1_w_8 = mad(-r6_xy_1.y, cb0_values[8].z, 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_2.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r6_x_6, r6_z_7, r6_w_7, r6_x_6), unitViewDir_xyz_2.xyzx);
                float r2_x_3 = saturate(dot(float4(r6_x_6, r6_z_7, r6_w_7, r6_x_6), r1_xyz_1.xyzx));
                float r2_y_3 = saturate(dot(float4(r6_x_6, r6_z_7, r6_w_7, r6_x_6), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_8.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_x_3 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_8 * r1_w_8);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(r0_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * mad(r2_x_3, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_x_3, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r2_y_3, r0_z_9, -r2_y_3), r2_y_3, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_x_3.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r3_xyz_4.xyzx, r3_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r7_x_6, r7_y_5, r7_z_5, r7_x_6));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r7_x_6, r7_x_6, r7_y_5, r7_z_5) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_9 = (r0_x_5 * r0_x_5);
                float r1_w_10 = (r1_w_9 * r1_w_9);
                float4 r2_xyzw_4 = (-r3_xyz_4.xyzx + float4(1, 1, 1, 0));
                float r2_x_4 = r2_xyzw_4.x;
                float r2_y_4 = r2_xyzw_4.y;
                float r2_z_3 = r2_xyzw_4.z;
                float4 r2_xyzw_5 = mad(float4(r2_x_4, r2_y_4, r2_z_3, r2_x_4), ((r0_x_5 * r1_w_10)).xxxx, r3_xyz_4.xyzx);
                float r2_x_5 = r2_xyzw_5.x;
                float r2_y_5 = r2_xyzw_5.y;
                float r2_z_4 = r2_xyzw_5.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_5, r2_y_5, r2_z_4, r2_x_5));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_7.xxxx * ((r3_xyz_2.xyzx * r4_xyz_3.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float4 r1_xyzw_12 = mad(float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8), i.color0.xyzx, -float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8));
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_6 = r1_xyzw_12.y;
                float r1_z_3 = r1_xyzw_12.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_12, r1_y_6, r1_z_3, r1_x_12), float4(0.1, 0.1, 0.1, 0), float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "PerformanceChecks"="False" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0;
                float _BumpScale;
                float _Metallic;
                float _Glossiness;
                float _OcclusionStrength;
                float _Cutoff;
                float4 _Color;
                float4 _EmissionColor;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 _MetallicGlossMap_ST;
                float4 _OcclusionMap_ST;
                float4 _EmissionMap_ST;
                float4 _DetailMask_ST;
                float4 _DetailAlbedo_ST;
                float4 _DetailNormal_ST;
                float4 cb0_values[19];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[3];
            };
            cbuffer _UnityProbeVolumeCB_b3
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
            SamplerState sampler_linear_clamp;
            SamplerComparisonState sampler_comparison_linear_clamp1;
            SamplerState sampler_DetailNormal;
            SamplerState sampler_DetailAlbedo;
            SamplerState sampler_MainTex;
            SamplerState sampler_EmissionMap;
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_BumpMap;
            SamplerState sampler_MetallicGlossMap;
            SamplerState sampler_DetailMask;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _MetallicGlossMap;
            Texture2D _OcclusionMap;
            Texture2D _EmissionMap;
            Texture2D _DetailMask;
            Texture2D _DetailAlbedo;
            TextureCube _DetailNormal;
            Texture3D t8;
            TextureCube t9;
            struct program39Input
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
            struct program39Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float3 texcoord7 : TEXCOORD7;
                float4 color0 : COLOR0;
                float3 texcoord8 : TEXCOORD8;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program62Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float3 texcoord7 : TEXCOORD7;
                float4 color0 : COLOR0;
                float3 texcoord8 : TEXCOORD8;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program62Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program39Output vert(program39Input i)
            {
                program39Output o = (program39Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _EmissionMap_ST.xyxx, _EmissionMap_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _DetailMask_ST.xxxy, _DetailMask_ST.zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _DetailAlbedo_ST.xyxx, _DetailAlbedo_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _DetailNormal_ST.xxxy, _DetailNormal_ST.zzzw)).zw;
                o.texcoord2.xy = (mad(i.texcoord0.xyxx, cb0_values[16].xyxx, cb0_values[16].zwzz)).xy;
                o.texcoord2.zw = (mad(i.texcoord0.xxxy, cb0_values[17].xxxy, cb0_values[17].zzzw)).zw;
                o.texcoord3.xy = (mad(i.texcoord0.xyxx, cb0_values[18].xyxx, cb0_values[18].zwzz)).xy;
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                float3 unitWorldNormal_xyz_3 = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_6 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_6.xxxx * (mad(unitWorldNormal_xyz_3.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_3.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord4.y = r3_xyz_3.x;
                o.texcoord4.x = unitWorldTangent_xyz_7.z;
                o.texcoord4.z = unitWorldNormal_xyz_3.y;
                o.texcoord5.x = unitWorldTangent_xyz_7.x;
                o.texcoord6.x = unitWorldTangent_xyz_7.y;
                o.texcoord5.z = unitWorldNormal_xyz_3.z;
                o.texcoord6.z = unitWorldNormal_xyz_3.x;
                o.texcoord5.y = r3_xyz_3.y;
                o.texcoord6.y = r3_xyz_3.z;
                o.texcoord7.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                float3 clipPos_xyz_4 = ((worldPos_xyzw_4.yyyy * cb0_values[5].xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(_Color.xyzx, worldPos_xyzw_4.zzzz, (mad(cb0_values[4].xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_4.xyzx)).xyzx)).xyz;
                o.texcoord8.xyz = (mad(_EmissionColor.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord9.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program62Output frag(program62Input i)
            {
                program62Output o = (program62Output)0;
                float3 r0_xyz_1 = ((-i.texcoord7.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord7.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_2 = ((r4_xyzw_1.xyzx * cb0_values[10].xyzx)).xyz;
                float r1_w_3 = (_BumpMap.Sample(sampler_BumpMap, (i.texcoord2.xyxx).xy)).w;
                float3 r5_xyz_1 = (_MetallicGlossMap.Sample(sampler_MetallicGlossMap, (i.texcoord2.zwzz).xy)).xyz;
                float3 r5_xyz_3 = (mad(r1_w_3.xxxx, (mad(r5_xyz_1.xyzx, float4(2, 2, 2, 0), float4(-2, -2, -2, 0))).xyzx, float4(1, 1, 1, 0))).xyz;
                float2 r7_xy_1 = (_OcclusionMap.Sample(sampler_OcclusionMap, (i.texcoord1.xyxx).xy)).xy;
                float3 r8_xyz_1 = (_EmissionMap.Sample(sampler_EmissionMap, (i.texcoord0.zwzz).xy)).xyz;
                float r8_x_2 = (r8_xyz_1.z * r8_xyz_1.x);
                float2 r7_zw_1 = (mad(float4(r8_x_2, r8_x_2, r8_x_2, r8_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r8_xyzw_3 = (r7_zw_1.xyxx * cb0_values[8].xxxx);
                float r8_x_3 = r8_xyzw_3.x;
                float r8_y_2 = r8_xyzw_3.y;
                float r2_w_1 = dot(float4(r8_x_3, r8_y_2, r8_x_3, r8_x_3), float4(r8_x_3, r8_y_2, r8_x_3, r8_x_3));
                float r2_w_2 = min(r2_w_1, 1);
                float r2_w_3 = (-r2_w_2 + 1);
                float r8_z_2 = sqrt(r2_w_3);
                float3 r9_xyz_1 = (_DetailMask.Sample(sampler_DetailMask, (i.texcoord3.xyxx).xy)).xyz;
                float r9_x_2 = (r9_xyz_1.z * r9_xyz_1.x);
                float2 r7_zw_2 = (mad(float4(r9_x_2, r9_x_2, r9_x_2, r9_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r9_xyzw_3 = (r7_zw_2.xyxx * cb0_values[8].xxxx);
                float r9_x_3 = r9_xyzw_3.x;
                float r9_y_2 = r9_xyzw_3.y;
                float r2_w_4 = dot(float4(r9_x_3, r9_y_2, r9_x_3, r9_x_3), float4(r9_x_3, r9_y_2, r9_x_3, r9_x_3));
                float r2_w_5 = min(r2_w_4, 1);
                float r2_w_6 = (-r2_w_5 + 1);
                float r9_z_2 = sqrt(r2_w_6);
                float4 r8_xyzw_4 = mad(float4(r9_x_3, r9_y_2, r9_z_2, r9_x_3), r1_w_3.xxxx, float4(r8_x_3, r8_y_2, r8_z_2, r8_x_3));
                float r8_x_4 = r8_xyzw_4.x;
                float r8_y_3 = r8_xyzw_4.y;
                float r8_z_3 = r8_xyzw_4.z;
                float r1_w_4 = dot(float4(r8_x_4, r8_y_3, r8_z_3, r8_x_4), float4(r8_x_4, r8_y_3, r8_z_3, r8_x_4));
                float r1_w_5 = rsqrt(r1_w_4);
                float4 r8_xyzw_5 = (r1_w_5.xxxx * float4(r8_x_4, r8_y_3, r8_z_3, r8_x_4));
                float r8_x_5 = r8_xyzw_5.x;
                float r8_y_4 = r8_xyzw_5.y;
                float r8_z_4 = r8_xyzw_5.z;
                float r1_w_6 = (r7_xy_1.x * cb0_values[8].y);
                float r2_w_7 = mad(r4_xyzw_1.w, cb0_values[10].w, -cb0_values[9].x);
                float r2_w_8 = (r2_w_7 < 0);
                if (r2_w_8) discard;
                float4 r7_xyzw_2 = (i.texcoord7.yyyy * cb0_values[5].xxyz);
                float r7_x_2 = r7_xyzw_2.x;
                float r7_z_3 = r7_xyzw_2.z;
                float r7_w_3 = r7_xyzw_2.w;
                float4 r7_xyzw_3 = mad(cb0_values[4].xxyz, i.texcoord7.xxxx, float4(r7_x_2, r7_x_2, r7_z_3, r7_w_3));
                float r7_x_3 = r7_xyzw_3.x;
                float r7_z_4 = r7_xyzw_3.z;
                float r7_w_4 = r7_xyzw_3.w;
                float4 r7_xyzw_4 = mad(cb0_values[6].xxyz, i.texcoord7.zzzz, float4(r7_x_3, r7_x_3, r7_z_4, r7_w_4));
                float r7_x_4 = r7_xyzw_4.x;
                float r7_z_5 = r7_xyzw_4.z;
                float r7_w_5 = r7_xyzw_4.w;
                float4 r7_xyzw_5 = (float4(r7_x_4, r7_x_4, r7_z_5, r7_w_5) + cb0_values[7].xxyz);
                float r7_x_5 = r7_xyzw_5.x;
                float r7_z_6 = r7_xyzw_5.z;
                float r7_w_6 = r7_xyzw_5.w;
                float r9_x_4 = cb4_values[9].z;
                float r9_y_3 = cb4_values[10].z;
                float r9_z_3 = cb4_values[11].z;
                float r2_x_2 = dot(viewDir_xyz_1.xyzx, float4(r9_x_4, r9_y_3, r9_z_3, r9_x_4));
                float4 r2_xyzw_2 = (i.texcoord7.xxyz + -cb3_values[25].xxyz);
                float r2_y_2 = r2_xyzw_2.y;
                float r2_z_2 = r2_xyzw_2.z;
                float r2_w_9 = r2_xyzw_2.w;
                float r2_y_3 = dot(float4(r2_y_2, r2_z_2, r2_w_9, r2_y_2), float4(r2_y_2, r2_z_2, r2_w_9, r2_y_2));
                float r2_y_4 = sqrt(r2_y_3);
                float r2_y_5 = (-r2_x_2 + r2_y_4);
                float r2_x_4 = saturate(mad(mad(cb3_values[25].w, r2_y_5, r2_x_2), cb3_values[24].z, cb3_values[24].w));
                float r2_y_6 = (cb5_values[0].x == 1);
                float r9_x_12;
                float r9_y_11;
                float r9_z_11;
                float r9_w_4;
                if (r2_y_6)
                {
                    float r2_y_7 = (cb5_values[0].y == 1);
                    float4 r9_xyzw_6 = (i.texcoord7.yyyy * cb5_values[2].xyzx);
                    float r9_x_6 = r9_xyzw_6.x;
                    float r9_y_5 = r9_xyzw_6.y;
                    float r9_z_5 = r9_xyzw_6.z;
                    float4 r9_xyzw_7 = mad(cb5_values[1].xyzx, i.texcoord7.xxxx, float4(r9_x_6, r9_y_5, r9_z_5, r9_x_6));
                    float r9_x_7 = r9_xyzw_7.x;
                    float r9_y_6 = r9_xyzw_7.y;
                    float r9_z_6 = r9_xyzw_7.z;
                    float4 r9_xyzw_8 = mad(cb5_values[3].xyzx, i.texcoord7.zzzz, float4(r9_x_7, r9_y_6, r9_z_6, r9_x_7));
                    float r9_x_8 = r9_xyzw_8.x;
                    float r9_y_7 = r9_xyzw_8.y;
                    float r9_z_7 = r9_xyzw_8.z;
                    float4 r9_xyzw_9 = (float4(r9_x_8, r9_y_7, r9_z_7, r9_x_8) + cb5_values[4].xyzx);
                    float r9_x_9 = r9_xyzw_9.x;
                    float r9_y_8 = r9_xyzw_9.y;
                    float r9_z_8 = r9_xyzw_9.z;
                    float4 r2_xyzw_8 = (r2_y_7.xxxx ? float4(r9_x_9, r9_x_9, r9_y_8, r9_z_8) : i.texcoord7.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float r2_w_10 = r2_xyzw_8.w;
                    float4 r2_xyzw_9 = (float4(r2_y_8, r2_y_8, r2_z_3, r2_w_10) + -cb5_values[6].xxyz);
                    float r2_y_9 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float r2_w_11 = r2_xyzw_9.w;
                    float r9_y_9 = ((float4(r2_y_9, r2_y_9, r2_z_4, r2_w_11) * cb5_values[5].xxyz)).y;
                    float r9_z_9 = ((float4(r2_y_9, r2_y_9, r2_z_4, r2_w_11) * cb5_values[5].xxyz)).z;
                    float r9_w_2 = ((float4(r2_y_9, r2_y_9, r2_z_4, r2_w_11) * cb5_values[5].xxyz)).w;
                    float r2_y_10 = mad(r9_y_9, 0.25, 0.75);
                    float r2_z_5 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r9_x_10 = max(r2_z_5, r2_y_10);
                    float4 r9_xyzw_11 = t8.Sample(sampler_linear_clamp, (float4(r9_x_10, r9_z_9, r9_w_2, r9_x_10)).xyz);
                    r9_x_12 = r9_xyzw_11.x;
                    r9_y_11 = r9_xyzw_11.y;
                    r9_z_11 = r9_xyzw_11.z;
                    r9_w_4 = r9_xyzw_11.w;
                }
                else
                {
                    float4 r9_xyzw_5 = float4(1, 1, 1, 1);
                    r9_x_12 = r9_xyzw_5.x;
                    r9_y_11 = r9_xyzw_5.y;
                    r9_z_11 = r9_xyzw_5.z;
                    r9_w_4 = r9_xyzw_5.w;
                }
                float r2_y_12 = saturate(dot(float4(r9_x_12, r9_y_11, r9_z_11, r9_w_4), unity_OcclusionMaskSelector));
                float r2_z_7 = (r2_x_4 < 0.99);
                float r2_z_19;
                if (r2_z_7)
                {
                    float4 r9_xyzw_13 = (i.texcoord7.xyzx + -cb2_values[1].xyzx);
                    float r9_x_13 = r9_xyzw_13.x;
                    float r9_y_12 = r9_xyzw_13.y;
                    float r9_z_12 = r9_xyzw_13.z;
                    float r2_z_9 = max(abs(r9_y_12), abs(r9_x_13));
                    float r2_z_10 = max(abs(r9_z_12), r2_z_9);
                    float r2_z_11 = (r2_z_10 + -cb2_values[2].z);
                    float r2_z_12 = max(r2_z_11, 1E-05);
                    float r2_z_13 = (r2_z_12 * cb2_values[2].w);
                    float r2_z_14 = (cb2_values[2].y / r2_z_13);
                    float r2_z_15 = (r2_z_14 + -cb2_values[2].x);
                    float r2_z_16 = (-r2_z_15 + 1);
                    float r10_x_2 = t9.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((float4(r9_x_13, r9_y_12, r9_z_12, r9_x_13) + float4(0.0078125, 0.0078125, 0.0078125, 0))).xyzx).xyz, r2_z_16);
                    float r10_y_2 = t9.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((float4(r9_x_13, r9_y_12, r9_z_12, r9_x_13) + float4(-0.0078125, -0.0078125, 0.0078125, 0))).xyzx).xyz, r2_z_16);
                    float r10_z_2 = t9.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((float4(r9_x_13, r9_y_12, r9_z_12, r9_x_13) + float4(-0.0078125, 0.0078125, -0.0078125, 0))).xyzx).xyz, r2_z_16);
                    float4 r9_xyzw_14 = (float4(r9_x_13, r9_y_12, r9_z_12, r9_x_13) + float4(0.0078125, -0.0078125, -0.0078125, 0));
                    float r9_x_14 = r9_xyzw_14.x;
                    float r9_y_13 = r9_xyzw_14.y;
                    float r9_z_13 = r9_xyzw_14.z;
                    float r10_w_1 = t9.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r9_x_14, r9_y_13, r9_z_13, r9_x_14)).xyz, r2_z_16);
                    float r2_z_17 = dot(float4(r10_x_2, r10_y_2, r10_z_2, r10_w_1), float4(0.25, 0.25, 0.25, 0.25));
                    float r2_w_13 = (-cb3_values[24].x + 1);
                    float r2_z_18 = mad(r2_z_17, r2_w_13, cb3_values[24].x);
                    r2_z_19 = r2_z_18;
                }
                else
                {
                    float r2_z_8 = 1;
                    r2_z_19 = r2_z_8;
                }
                float r2_y_13 = (-r2_z_19 + r2_y_12);
                float r2_y_14 = dot(float4(r7_x_5, r7_z_6, r7_w_6, r7_x_5), float4(r7_x_5, r7_z_6, r7_w_6, r7_x_5));
                float r2_y_15 = (_DetailAlbedo.Sample(sampler_DetailAlbedo, (r2_y_14.xxxx).xy)).y;
                float r2_z_20 = (_DetailNormal.Sample(sampler_DetailNormal, (float4(r7_x_5, r7_z_6, r7_w_6, r7_x_5)).xyz)).z;
                float r2_y_16 = (r2_z_20 * r2_y_15);
                float r9_x_16 = dot(i.texcoord4.xyzx, float4(r8_x_5, r8_y_4, r8_z_4, r8_x_5));
                float r9_y_15 = dot(i.texcoord5.xyzx, float4(r8_x_5, r8_y_4, r8_z_4, r8_x_5));
                float r9_z_15 = dot(i.texcoord6.xyzx, float4(r8_x_5, r8_y_4, r8_z_4, r8_x_5));
                float r2_y_17 = dot(float4(r9_x_16, r9_y_15, r9_z_15, r9_x_16), float4(r9_x_16, r9_y_15, r9_z_15, r9_x_16));
                float r2_y_18 = rsqrt(r2_y_17);
                float4 r2_xyzw_19 = (r2_y_18.xxxx * float4(r9_x_16, r9_x_16, r9_y_15, r9_z_15));
                float r2_y_19 = r2_xyzw_19.y;
                float r2_z_21 = r2_xyzw_19.z;
                float r2_w_15 = r2_xyzw_19.w;
                float4 r7_xyzw_6 = (((mad(r2_x_4, r2_y_13, r2_z_19) * r2_y_16)).xxxx * _LightColor0.xxyz);
                float r7_x_6 = r7_xyzw_6.x;
                float r7_z_7 = r7_xyzw_6.z;
                float r7_w_7 = r7_xyzw_6.w;
                float3 r4_xyz_4 = (mad(r1_w_6.xxxx, (mad(r4_xyz_2.xyzx, r5_xyz_3.xyzx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_7 = mad(-r1_w_6, 0.96, 0.96);
                float r1_w_8 = mad(-r7_xy_1.y, cb0_values[8].z, 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r2_y_19, r2_z_21, r2_w_15, r2_y_19), unitViewDir_xyz_1.xyzx);
                float r2_x_7 = saturate(dot(float4(r2_y_19, r2_z_21, r2_w_15, r2_y_19), r1_xyz_1.xyzx));
                float r2_y_20 = saturate(dot(float4(r2_y_19, r2_z_21, r2_w_15, r2_y_19), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_8.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_x_7 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_8 * r1_w_8);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(r0_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * mad(r2_x_7, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_x_7, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r2_y_20, r0_z_9, -r2_y_20), r2_y_20, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_x_7.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r7_x_6, r7_z_7, r7_w_7, r7_x_6));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r7_x_6, r7_x_6, r7_z_7, r7_w_7) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_9 = (r0_x_5 * r0_x_5);
                float r1_w_10 = (r1_w_9 * r1_w_9);
                float4 r2_xyzw_8 = (-r4_xyz_4.xyzx + float4(1, 1, 1, 0));
                float r2_x_8 = r2_xyzw_8.x;
                float r2_y_21 = r2_xyzw_8.y;
                float r2_z_22 = r2_xyzw_8.z;
                float4 r2_xyzw_9 = mad(float4(r2_x_8, r2_y_21, r2_z_22, r2_x_8), ((r0_x_5 * r1_w_10)).xxxx, r4_xyz_4.xyzx);
                float r2_x_9 = r2_xyzw_9.x;
                float r2_y_22 = r2_xyzw_9.y;
                float r2_z_23 = r2_xyzw_9.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_9, r2_y_22, r2_z_23, r2_x_9));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_7.xxxx * ((r4_xyz_2.xyzx * r5_xyz_3.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float4 r1_xyzw_12 = mad(float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8), i.color0.xyzx, -float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8));
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_6 = r1_xyzw_12.y;
                float r1_z_3 = r1_xyzw_12.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_12, r1_y_6, r1_z_3, r1_x_12), float4(0.1, 0.1, 0.1, 0), float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "PerformanceChecks"="False" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0;
                float _BumpScale;
                float _Metallic;
                float _Glossiness;
                float _OcclusionStrength;
                float _Cutoff;
                float4 _Color;
                float4 _EmissionColor;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 _MetallicGlossMap_ST;
                float4 _OcclusionMap_ST;
                float4 _EmissionMap_ST;
                float4 _DetailMask_ST;
                float4 _DetailAlbedo_ST;
                float4 _DetailNormal_ST;
                float4 cb0_values[19];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[3];
            };
            cbuffer _UnityProbeVolumeCB_b3
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
            SamplerState sampler_linear_clamp;
            SamplerComparisonState sampler_comparison_linear_clamp1;
            SamplerState sampler_DetailNormal;
            SamplerState sampler_DetailAlbedo;
            SamplerState sampler_MainTex;
            SamplerState sampler_EmissionMap;
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_BumpMap;
            SamplerState sampler_MetallicGlossMap;
            SamplerState sampler_DetailMask;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _MetallicGlossMap;
            Texture2D _OcclusionMap;
            Texture2D _EmissionMap;
            Texture2D _DetailMask;
            Texture2D _DetailAlbedo;
            TextureCube _DetailNormal;
            Texture3D t8;
            TextureCube t9;
            struct program38Input
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
            struct program38Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float3 texcoord7 : TEXCOORD7;
                float4 color0 : COLOR0;
                float3 texcoord8 : TEXCOORD8;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program61Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float3 texcoord7 : TEXCOORD7;
                float4 color0 : COLOR0;
                float3 texcoord8 : TEXCOORD8;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program61Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program38Output vert(program38Input i)
            {
                program38Output o = (program38Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _EmissionMap_ST.xyxx, _EmissionMap_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _DetailMask_ST.xxxy, _DetailMask_ST.zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _DetailAlbedo_ST.xyxx, _DetailAlbedo_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _DetailNormal_ST.xxxy, _DetailNormal_ST.zzzw)).zw;
                o.texcoord2.xy = (mad(i.texcoord0.xyxx, cb0_values[16].xyxx, cb0_values[16].zwzz)).xy;
                o.texcoord2.zw = (mad(i.texcoord0.xxxy, cb0_values[17].xxxy, cb0_values[17].zzzw)).zw;
                o.texcoord3.xy = (mad(i.texcoord0.xyxx, cb0_values[18].xyxx, cb0_values[18].zwzz)).xy;
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                float3 unitWorldNormal_xyz_3 = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_6 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_6.xxxx * (mad(unitWorldNormal_xyz_3.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_3.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord4.y = r3_xyz_3.x;
                o.texcoord4.x = unitWorldTangent_xyz_7.z;
                o.texcoord4.z = unitWorldNormal_xyz_3.y;
                o.texcoord5.x = unitWorldTangent_xyz_7.x;
                o.texcoord6.x = unitWorldTangent_xyz_7.y;
                o.texcoord5.z = unitWorldNormal_xyz_3.z;
                o.texcoord6.z = unitWorldNormal_xyz_3.x;
                o.texcoord5.y = r3_xyz_3.y;
                o.texcoord6.y = r3_xyz_3.z;
                o.texcoord7.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                float3 clipPos_xyz_4 = ((worldPos_xyzw_4.yyyy * cb0_values[5].xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(_Color.xyzx, worldPos_xyzw_4.zzzz, (mad(cb0_values[4].xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_4.xyzx)).xyzx)).xyz;
                o.texcoord8.xyz = (mad(_EmissionColor.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord9.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program61Output frag(program61Input i)
            {
                program61Output o = (program61Output)0;
                float3 r0_xyz_1 = ((-i.texcoord7.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord7.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_2 = ((r4_xyzw_1.xyzx * cb0_values[10].xyzx)).xyz;
                float r1_w_3 = (_BumpMap.Sample(sampler_BumpMap, (i.texcoord2.xyxx).xy)).w;
                float3 r5_xyz_1 = (_MetallicGlossMap.Sample(sampler_MetallicGlossMap, (i.texcoord2.zwzz).xy)).xyz;
                float3 r5_xyz_3 = (mad(r1_w_3.xxxx, (mad(r5_xyz_1.xyzx, float4(2, 2, 2, 0), float4(-2, -2, -2, 0))).xyzx, float4(1, 1, 1, 0))).xyz;
                float2 r7_xy_1 = (_OcclusionMap.Sample(sampler_OcclusionMap, (i.texcoord1.xyxx).xy)).xy;
                float3 r8_xyz_1 = (_EmissionMap.Sample(sampler_EmissionMap, (i.texcoord0.zwzz).xy)).xyz;
                float r8_x_2 = (r8_xyz_1.z * r8_xyz_1.x);
                float2 r7_zw_1 = (mad(float4(r8_x_2, r8_x_2, r8_x_2, r8_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r8_xyzw_3 = (r7_zw_1.xyxx * cb0_values[8].xxxx);
                float r8_x_3 = r8_xyzw_3.x;
                float r8_y_2 = r8_xyzw_3.y;
                float r2_w_1 = dot(float4(r8_x_3, r8_y_2, r8_x_3, r8_x_3), float4(r8_x_3, r8_y_2, r8_x_3, r8_x_3));
                float r2_w_2 = min(r2_w_1, 1);
                float r2_w_3 = (-r2_w_2 + 1);
                float r8_z_2 = sqrt(r2_w_3);
                float3 r9_xyz_1 = (_DetailMask.Sample(sampler_DetailMask, (i.texcoord3.xyxx).xy)).xyz;
                float r9_x_2 = (r9_xyz_1.z * r9_xyz_1.x);
                float2 r7_zw_2 = (mad(float4(r9_x_2, r9_x_2, r9_x_2, r9_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r9_xyzw_3 = (r7_zw_2.xyxx * cb0_values[8].xxxx);
                float r9_x_3 = r9_xyzw_3.x;
                float r9_y_2 = r9_xyzw_3.y;
                float r2_w_4 = dot(float4(r9_x_3, r9_y_2, r9_x_3, r9_x_3), float4(r9_x_3, r9_y_2, r9_x_3, r9_x_3));
                float r2_w_5 = min(r2_w_4, 1);
                float r2_w_6 = (-r2_w_5 + 1);
                float r9_z_2 = sqrt(r2_w_6);
                float4 r8_xyzw_4 = mad(float4(r9_x_3, r9_y_2, r9_z_2, r9_x_3), r1_w_3.xxxx, float4(r8_x_3, r8_y_2, r8_z_2, r8_x_3));
                float r8_x_4 = r8_xyzw_4.x;
                float r8_y_3 = r8_xyzw_4.y;
                float r8_z_3 = r8_xyzw_4.z;
                float r1_w_4 = dot(float4(r8_x_4, r8_y_3, r8_z_3, r8_x_4), float4(r8_x_4, r8_y_3, r8_z_3, r8_x_4));
                float r1_w_5 = rsqrt(r1_w_4);
                float4 r8_xyzw_5 = (r1_w_5.xxxx * float4(r8_x_4, r8_y_3, r8_z_3, r8_x_4));
                float r8_x_5 = r8_xyzw_5.x;
                float r8_y_4 = r8_xyzw_5.y;
                float r8_z_4 = r8_xyzw_5.z;
                float r1_w_6 = (r7_xy_1.x * cb0_values[8].y);
                float r2_w_7 = mad(r4_xyzw_1.w, cb0_values[10].w, -cb0_values[9].x);
                float r2_w_8 = (r2_w_7 < 0);
                if (r2_w_8) discard;
                float4 r7_xyzw_2 = (i.texcoord7.yyyy * cb0_values[5].xxyz);
                float r7_x_2 = r7_xyzw_2.x;
                float r7_z_3 = r7_xyzw_2.z;
                float r7_w_3 = r7_xyzw_2.w;
                float4 r7_xyzw_3 = mad(cb0_values[4].xxyz, i.texcoord7.xxxx, float4(r7_x_2, r7_x_2, r7_z_3, r7_w_3));
                float r7_x_3 = r7_xyzw_3.x;
                float r7_z_4 = r7_xyzw_3.z;
                float r7_w_4 = r7_xyzw_3.w;
                float4 r7_xyzw_4 = mad(cb0_values[6].xxyz, i.texcoord7.zzzz, float4(r7_x_3, r7_x_3, r7_z_4, r7_w_4));
                float r7_x_4 = r7_xyzw_4.x;
                float r7_z_5 = r7_xyzw_4.z;
                float r7_w_5 = r7_xyzw_4.w;
                float4 r7_xyzw_5 = (float4(r7_x_4, r7_x_4, r7_z_5, r7_w_5) + cb0_values[7].xxyz);
                float r7_x_5 = r7_xyzw_5.x;
                float r7_z_6 = r7_xyzw_5.z;
                float r7_w_6 = r7_xyzw_5.w;
                float r9_x_4 = cb4_values[9].z;
                float r9_y_3 = cb4_values[10].z;
                float r9_z_3 = cb4_values[11].z;
                float r2_x_2 = dot(viewDir_xyz_1.xyzx, float4(r9_x_4, r9_y_3, r9_z_3, r9_x_4));
                float4 r2_xyzw_2 = (i.texcoord7.xxyz + -cb3_values[25].xxyz);
                float r2_y_2 = r2_xyzw_2.y;
                float r2_z_2 = r2_xyzw_2.z;
                float r2_w_9 = r2_xyzw_2.w;
                float r2_y_3 = dot(float4(r2_y_2, r2_z_2, r2_w_9, r2_y_2), float4(r2_y_2, r2_z_2, r2_w_9, r2_y_2));
                float r2_y_4 = sqrt(r2_y_3);
                float r2_y_5 = (-r2_x_2 + r2_y_4);
                float r2_y_6 = (cb5_values[0].x == 1);
                float r9_x_12;
                float r9_y_11;
                float r9_z_11;
                float r9_w_4;
                if (r2_y_6)
                {
                    float r2_y_7 = (cb5_values[0].y == 1);
                    float4 r9_xyzw_6 = (i.texcoord7.yyyy * cb5_values[2].xyzx);
                    float r9_x_6 = r9_xyzw_6.x;
                    float r9_y_5 = r9_xyzw_6.y;
                    float r9_z_5 = r9_xyzw_6.z;
                    float4 r9_xyzw_7 = mad(cb5_values[1].xyzx, i.texcoord7.xxxx, float4(r9_x_6, r9_y_5, r9_z_5, r9_x_6));
                    float r9_x_7 = r9_xyzw_7.x;
                    float r9_y_6 = r9_xyzw_7.y;
                    float r9_z_6 = r9_xyzw_7.z;
                    float4 r9_xyzw_8 = mad(cb5_values[3].xyzx, i.texcoord7.zzzz, float4(r9_x_7, r9_y_6, r9_z_6, r9_x_7));
                    float r9_x_8 = r9_xyzw_8.x;
                    float r9_y_7 = r9_xyzw_8.y;
                    float r9_z_7 = r9_xyzw_8.z;
                    float4 r9_xyzw_9 = (float4(r9_x_8, r9_y_7, r9_z_7, r9_x_8) + cb5_values[4].xyzx);
                    float r9_x_9 = r9_xyzw_9.x;
                    float r9_y_8 = r9_xyzw_9.y;
                    float r9_z_8 = r9_xyzw_9.z;
                    float4 r2_xyzw_8 = (r2_y_7.xxxx ? float4(r9_x_9, r9_x_9, r9_y_8, r9_z_8) : i.texcoord7.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float r2_w_10 = r2_xyzw_8.w;
                    float4 r2_xyzw_9 = (float4(r2_y_8, r2_y_8, r2_z_3, r2_w_10) + -cb5_values[6].xxyz);
                    float r2_y_9 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float r2_w_11 = r2_xyzw_9.w;
                    float r9_y_9 = ((float4(r2_y_9, r2_y_9, r2_z_4, r2_w_11) * cb5_values[5].xxyz)).y;
                    float r9_z_9 = ((float4(r2_y_9, r2_y_9, r2_z_4, r2_w_11) * cb5_values[5].xxyz)).z;
                    float r9_w_2 = ((float4(r2_y_9, r2_y_9, r2_z_4, r2_w_11) * cb5_values[5].xxyz)).w;
                    float r2_y_10 = mad(r9_y_9, 0.25, 0.75);
                    float r2_z_5 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r9_x_10 = max(r2_z_5, r2_y_10);
                    float4 r9_xyzw_11 = t8.Sample(sampler_linear_clamp, (float4(r9_x_10, r9_z_9, r9_w_2, r9_x_10)).xyz);
                    r9_x_12 = r9_xyzw_11.x;
                    r9_y_11 = r9_xyzw_11.y;
                    r9_z_11 = r9_xyzw_11.z;
                    r9_w_4 = r9_xyzw_11.w;
                }
                else
                {
                    float4 r9_xyzw_5 = float4(1, 1, 1, 1);
                    r9_x_12 = r9_xyzw_5.x;
                    r9_y_11 = r9_xyzw_5.y;
                    r9_z_11 = r9_xyzw_5.z;
                    r9_w_4 = r9_xyzw_5.w;
                }
                float r2_y_12 = saturate(dot(float4(r9_x_12, r9_y_11, r9_z_11, r9_w_4), unity_OcclusionMaskSelector));
                float4 r9_xyzw_13 = (i.texcoord7.xyzx + -cb2_values[1].xyzx);
                float r9_x_13 = r9_xyzw_13.x;
                float r9_y_12 = r9_xyzw_13.y;
                float r9_z_12 = r9_xyzw_13.z;
                float r2_z_7 = max(abs(r9_y_12), abs(r9_x_13));
                float r2_z_8 = max(abs(r9_z_12), r2_z_7);
                float r2_z_9 = (r2_z_8 + -cb2_values[2].z);
                float r2_z_10 = max(r2_z_9, 1E-05);
                float r2_z_11 = (r2_z_10 * cb2_values[2].w);
                float r2_z_12 = (cb2_values[2].y / r2_z_11);
                float r2_z_13 = (r2_z_12 + -cb2_values[2].x);
                float r2_z_14 = (-r2_z_13 + 1);
                float r2_z_15 = t9.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r9_x_13, r9_y_12, r9_z_12, r9_x_13)).xyz, r2_z_14);
                float r2_w_13 = (-cb3_values[24].x + 1);
                float r2_z_16 = mad(r2_z_15, r2_w_13, cb3_values[24].x);
                float r2_y_13 = (-r2_z_16 + r2_y_12);
                float r2_y_14 = dot(float4(r7_x_5, r7_z_6, r7_w_6, r7_x_5), float4(r7_x_5, r7_z_6, r7_w_6, r7_x_5));
                float r2_y_15 = (_DetailAlbedo.Sample(sampler_DetailAlbedo, (r2_y_14.xxxx).xy)).y;
                float r2_z_17 = (_DetailNormal.Sample(sampler_DetailNormal, (float4(r7_x_5, r7_z_6, r7_w_6, r7_x_5)).xyz)).z;
                float r2_y_16 = (r2_z_17 * r2_y_15);
                float r9_x_14 = dot(i.texcoord4.xyzx, float4(r8_x_5, r8_y_4, r8_z_4, r8_x_5));
                float r9_y_13 = dot(i.texcoord5.xyzx, float4(r8_x_5, r8_y_4, r8_z_4, r8_x_5));
                float r9_z_13 = dot(i.texcoord6.xyzx, float4(r8_x_5, r8_y_4, r8_z_4, r8_x_5));
                float r2_y_17 = dot(float4(r9_x_14, r9_y_13, r9_z_13, r9_x_14), float4(r9_x_14, r9_y_13, r9_z_13, r9_x_14));
                float r2_y_18 = rsqrt(r2_y_17);
                float4 r2_xyzw_19 = (r2_y_18.xxxx * float4(r9_x_14, r9_x_14, r9_y_13, r9_z_13));
                float r2_y_19 = r2_xyzw_19.y;
                float r2_z_18 = r2_xyzw_19.z;
                float r2_w_14 = r2_xyzw_19.w;
                float4 r7_xyzw_6 = (((mad(saturate(mad(mad(cb3_values[25].w, r2_y_5, r2_x_2), cb3_values[24].z, cb3_values[24].w)), r2_y_13, r2_z_16) * r2_y_16)).xxxx * _LightColor0.xxyz);
                float r7_x_6 = r7_xyzw_6.x;
                float r7_z_7 = r7_xyzw_6.z;
                float r7_w_7 = r7_xyzw_6.w;
                float3 r4_xyz_4 = (mad(r1_w_6.xxxx, (mad(r4_xyz_2.xyzx, r5_xyz_3.xyzx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_7 = mad(-r1_w_6, 0.96, 0.96);
                float r1_w_8 = mad(-r7_xy_1.y, cb0_values[8].z, 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r2_y_19, r2_z_18, r2_w_14, r2_y_19), unitViewDir_xyz_1.xyzx);
                float r2_x_7 = saturate(dot(float4(r2_y_19, r2_z_18, r2_w_14, r2_y_19), r1_xyz_1.xyzx));
                float r2_y_20 = saturate(dot(float4(r2_y_19, r2_z_18, r2_w_14, r2_y_19), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_8.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_x_7 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_8 * r1_w_8);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(r0_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * mad(r2_x_7, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_x_7, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r2_y_20, r0_z_9, -r2_y_20), r2_y_20, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_x_7.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r7_x_6, r7_z_7, r7_w_7, r7_x_6));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r7_x_6, r7_x_6, r7_z_7, r7_w_7) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_9 = (r0_x_5 * r0_x_5);
                float r1_w_10 = (r1_w_9 * r1_w_9);
                float4 r2_xyzw_8 = (-r4_xyz_4.xyzx + float4(1, 1, 1, 0));
                float r2_x_8 = r2_xyzw_8.x;
                float r2_y_21 = r2_xyzw_8.y;
                float r2_z_19 = r2_xyzw_8.z;
                float4 r2_xyzw_9 = mad(float4(r2_x_8, r2_y_21, r2_z_19, r2_x_8), ((r0_x_5 * r1_w_10)).xxxx, r4_xyz_4.xyzx);
                float r2_x_9 = r2_xyzw_9.x;
                float r2_y_22 = r2_xyzw_9.y;
                float r2_z_20 = r2_xyzw_9.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_9, r2_y_22, r2_z_20, r2_x_9));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_7.xxxx * ((r4_xyz_2.xyzx * r5_xyz_3.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float4 r1_xyzw_12 = mad(float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8), i.color0.xyzx, -float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8));
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_6 = r1_xyzw_12.y;
                float r1_z_3 = r1_xyzw_12.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_12, r1_y_6, r1_z_3, r1_x_12), float4(0.1, 0.1, 0.1, 0), float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "PerformanceChecks"="False" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0;
                float _BumpScale;
                float _Metallic;
                float _Glossiness;
                float _OcclusionStrength;
                float _Cutoff;
                float4 _Color;
                float4 _EmissionColor;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 _MetallicGlossMap_ST;
                float4 _OcclusionMap_ST;
                float4 _EmissionMap_ST;
                float4 _DetailMask_ST;
                float4 _DetailAlbedo_ST;
                float4 _DetailNormal_ST;
                float4 cb0_values[19];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[3];
            };
            cbuffer _UnityProbeVolumeCB_b3
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
            SamplerState sampler_DetailNormal;
            SamplerComparisonState sampler_comparison_linear_clamp1;
            SamplerState sampler_DetailAlbedo;
            SamplerState sampler_MainTex;
            SamplerState sampler_EmissionMap;
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_BumpMap;
            SamplerState sampler_MetallicGlossMap;
            SamplerState sampler_DetailMask;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _MetallicGlossMap;
            Texture2D _OcclusionMap;
            Texture2D _EmissionMap;
            Texture2D _DetailMask;
            Texture2D _DetailAlbedo;
            Texture3D _DetailNormal;
            TextureCube t8;
            struct program37Input
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
            struct program37Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float3 texcoord7 : TEXCOORD7;
                float4 color0 : COLOR0;
                float3 texcoord8 : TEXCOORD8;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program60Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float3 texcoord7 : TEXCOORD7;
                float4 color0 : COLOR0;
                float3 texcoord8 : TEXCOORD8;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program60Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program37Output vert(program37Input i)
            {
                program37Output o = (program37Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _EmissionMap_ST.xyxx, _EmissionMap_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _DetailMask_ST.xxxy, _DetailMask_ST.zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _DetailAlbedo_ST.xyxx, _DetailAlbedo_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _DetailNormal_ST.xxxy, _DetailNormal_ST.zzzw)).zw;
                o.texcoord2.xy = (mad(i.texcoord0.xyxx, cb0_values[16].xyxx, cb0_values[16].zwzz)).xy;
                o.texcoord2.zw = (mad(i.texcoord0.xxxy, cb0_values[17].xxxy, cb0_values[17].zzzw)).zw;
                o.texcoord3.xy = (mad(i.texcoord0.xyxx, cb0_values[18].xyxx, cb0_values[18].zwzz)).xy;
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                float3 unitWorldNormal_xyz_3 = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_6 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_6.xxxx * (mad(unitWorldNormal_xyz_3.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_3.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord4.y = r3_xyz_3.x;
                o.texcoord4.x = unitWorldTangent_xyz_7.z;
                o.texcoord4.z = unitWorldNormal_xyz_3.y;
                o.texcoord5.x = unitWorldTangent_xyz_7.x;
                o.texcoord6.x = unitWorldTangent_xyz_7.y;
                o.texcoord5.z = unitWorldNormal_xyz_3.z;
                o.texcoord6.z = unitWorldNormal_xyz_3.x;
                o.texcoord5.y = r3_xyz_3.y;
                o.texcoord6.y = r3_xyz_3.z;
                o.texcoord7.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                float3 clipPos_xyz_4 = ((worldPos_xyzw_4.yyyy * cb0_values[5].xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(_Color.xyzx, worldPos_xyzw_4.zzzz, (mad(cb0_values[4].xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_4.xyzx)).xyzx)).xyz;
                o.texcoord8.xyz = (mad(_EmissionColor.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord9.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program60Output frag(program60Input i)
            {
                program60Output o = (program60Output)0;
                float3 r0_xyz_1 = ((-i.texcoord7.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord7.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_2 = ((r4_xyzw_1.xyzx * cb0_values[10].xyzx)).xyz;
                float r1_w_3 = (_BumpMap.Sample(sampler_BumpMap, (i.texcoord2.xyxx).xy)).w;
                float3 r5_xyz_1 = (_MetallicGlossMap.Sample(sampler_MetallicGlossMap, (i.texcoord2.zwzz).xy)).xyz;
                float3 r5_xyz_3 = (mad(r1_w_3.xxxx, (mad(r5_xyz_1.xyzx, float4(2, 2, 2, 0), float4(-2, -2, -2, 0))).xyzx, float4(1, 1, 1, 0))).xyz;
                float2 r7_xy_1 = (_OcclusionMap.Sample(sampler_OcclusionMap, (i.texcoord1.xyxx).xy)).xy;
                float3 r8_xyz_1 = (_EmissionMap.Sample(sampler_EmissionMap, (i.texcoord0.zwzz).xy)).xyz;
                float r8_x_2 = (r8_xyz_1.z * r8_xyz_1.x);
                float2 r7_zw_1 = (mad(float4(r8_x_2, r8_x_2, r8_x_2, r8_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r8_xyzw_3 = (r7_zw_1.xyxx * cb0_values[8].xxxx);
                float r8_x_3 = r8_xyzw_3.x;
                float r8_y_2 = r8_xyzw_3.y;
                float r2_w_1 = dot(float4(r8_x_3, r8_y_2, r8_x_3, r8_x_3), float4(r8_x_3, r8_y_2, r8_x_3, r8_x_3));
                float r2_w_2 = min(r2_w_1, 1);
                float r2_w_3 = (-r2_w_2 + 1);
                float r8_z_2 = sqrt(r2_w_3);
                float3 r9_xyz_1 = (_DetailMask.Sample(sampler_DetailMask, (i.texcoord3.xyxx).xy)).xyz;
                float r9_x_2 = (r9_xyz_1.z * r9_xyz_1.x);
                float2 r7_zw_2 = (mad(float4(r9_x_2, r9_x_2, r9_x_2, r9_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r9_xyzw_3 = (r7_zw_2.xyxx * cb0_values[8].xxxx);
                float r9_x_3 = r9_xyzw_3.x;
                float r9_y_2 = r9_xyzw_3.y;
                float r2_w_4 = dot(float4(r9_x_3, r9_y_2, r9_x_3, r9_x_3), float4(r9_x_3, r9_y_2, r9_x_3, r9_x_3));
                float r2_w_5 = min(r2_w_4, 1);
                float r2_w_6 = (-r2_w_5 + 1);
                float r9_z_2 = sqrt(r2_w_6);
                float4 r8_xyzw_4 = mad(float4(r9_x_3, r9_y_2, r9_z_2, r9_x_3), r1_w_3.xxxx, float4(r8_x_3, r8_y_2, r8_z_2, r8_x_3));
                float r8_x_4 = r8_xyzw_4.x;
                float r8_y_3 = r8_xyzw_4.y;
                float r8_z_3 = r8_xyzw_4.z;
                float r1_w_4 = dot(float4(r8_x_4, r8_y_3, r8_z_3, r8_x_4), float4(r8_x_4, r8_y_3, r8_z_3, r8_x_4));
                float r1_w_5 = rsqrt(r1_w_4);
                float4 r8_xyzw_5 = (r1_w_5.xxxx * float4(r8_x_4, r8_y_3, r8_z_3, r8_x_4));
                float r8_x_5 = r8_xyzw_5.x;
                float r8_y_4 = r8_xyzw_5.y;
                float r8_z_4 = r8_xyzw_5.z;
                float r1_w_6 = (r7_xy_1.x * cb0_values[8].y);
                float r2_w_7 = mad(r4_xyzw_1.w, cb0_values[10].w, -cb0_values[9].x);
                float r2_w_8 = (r2_w_7 < 0);
                if (r2_w_8) discard;
                float4 r7_xyzw_2 = (i.texcoord7.yyyy * cb0_values[5].xxyz);
                float r7_x_2 = r7_xyzw_2.x;
                float r7_z_3 = r7_xyzw_2.z;
                float r7_w_3 = r7_xyzw_2.w;
                float4 r7_xyzw_3 = mad(cb0_values[4].xxyz, i.texcoord7.xxxx, float4(r7_x_2, r7_x_2, r7_z_3, r7_w_3));
                float r7_x_3 = r7_xyzw_3.x;
                float r7_z_4 = r7_xyzw_3.z;
                float r7_w_4 = r7_xyzw_3.w;
                float4 r7_xyzw_4 = mad(cb0_values[6].xxyz, i.texcoord7.zzzz, float4(r7_x_3, r7_x_3, r7_z_4, r7_w_4));
                float r7_x_4 = r7_xyzw_4.x;
                float r7_z_5 = r7_xyzw_4.z;
                float r7_w_5 = r7_xyzw_4.w;
                float4 r7_xyzw_5 = (float4(r7_x_4, r7_x_4, r7_z_5, r7_w_5) + cb0_values[7].xxyz);
                float r7_x_5 = r7_xyzw_5.x;
                float r7_z_6 = r7_xyzw_5.z;
                float r7_w_6 = r7_xyzw_5.w;
                float r9_x_4 = cb4_values[9].z;
                float r9_y_3 = cb4_values[10].z;
                float r9_z_3 = cb4_values[11].z;
                float r2_x_2 = dot(viewDir_xyz_1.xyzx, float4(r9_x_4, r9_y_3, r9_z_3, r9_x_4));
                float4 r2_xyzw_2 = (i.texcoord7.xxyz + -cb3_values[25].xxyz);
                float r2_y_2 = r2_xyzw_2.y;
                float r2_z_2 = r2_xyzw_2.z;
                float r2_w_9 = r2_xyzw_2.w;
                float r2_y_3 = dot(float4(r2_y_2, r2_z_2, r2_w_9, r2_y_2), float4(r2_y_2, r2_z_2, r2_w_9, r2_y_2));
                float r2_y_4 = sqrt(r2_y_3);
                float r2_y_5 = (-r2_x_2 + r2_y_4);
                float r2_x_4 = saturate(mad(mad(cb3_values[25].w, r2_y_5, r2_x_2), cb3_values[24].z, cb3_values[24].w));
                float r2_y_6 = (cb5_values[0].x == 1);
                float r9_x_12;
                float r9_y_11;
                float r9_z_11;
                float r9_w_4;
                if (r2_y_6)
                {
                    float r2_y_7 = (cb5_values[0].y == 1);
                    float4 r9_xyzw_6 = (i.texcoord7.yyyy * cb5_values[2].xyzx);
                    float r9_x_6 = r9_xyzw_6.x;
                    float r9_y_5 = r9_xyzw_6.y;
                    float r9_z_5 = r9_xyzw_6.z;
                    float4 r9_xyzw_7 = mad(cb5_values[1].xyzx, i.texcoord7.xxxx, float4(r9_x_6, r9_y_5, r9_z_5, r9_x_6));
                    float r9_x_7 = r9_xyzw_7.x;
                    float r9_y_6 = r9_xyzw_7.y;
                    float r9_z_6 = r9_xyzw_7.z;
                    float4 r9_xyzw_8 = mad(cb5_values[3].xyzx, i.texcoord7.zzzz, float4(r9_x_7, r9_y_6, r9_z_6, r9_x_7));
                    float r9_x_8 = r9_xyzw_8.x;
                    float r9_y_7 = r9_xyzw_8.y;
                    float r9_z_7 = r9_xyzw_8.z;
                    float4 r9_xyzw_9 = (float4(r9_x_8, r9_y_7, r9_z_7, r9_x_8) + cb5_values[4].xyzx);
                    float r9_x_9 = r9_xyzw_9.x;
                    float r9_y_8 = r9_xyzw_9.y;
                    float r9_z_8 = r9_xyzw_9.z;
                    float4 r2_xyzw_8 = (r2_y_7.xxxx ? float4(r9_x_9, r9_x_9, r9_y_8, r9_z_8) : i.texcoord7.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float r2_w_10 = r2_xyzw_8.w;
                    float4 r2_xyzw_9 = (float4(r2_y_8, r2_y_8, r2_z_3, r2_w_10) + -cb5_values[6].xxyz);
                    float r2_y_9 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float r2_w_11 = r2_xyzw_9.w;
                    float r9_y_9 = ((float4(r2_y_9, r2_y_9, r2_z_4, r2_w_11) * cb5_values[5].xxyz)).y;
                    float r9_z_9 = ((float4(r2_y_9, r2_y_9, r2_z_4, r2_w_11) * cb5_values[5].xxyz)).z;
                    float r9_w_2 = ((float4(r2_y_9, r2_y_9, r2_z_4, r2_w_11) * cb5_values[5].xxyz)).w;
                    float r2_y_10 = mad(r9_y_9, 0.25, 0.75);
                    float r2_z_5 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r9_x_10 = max(r2_z_5, r2_y_10);
                    float4 r9_xyzw_11 = _DetailNormal.Sample(sampler_DetailNormal, (float4(r9_x_10, r9_z_9, r9_w_2, r9_x_10)).xyz);
                    r9_x_12 = r9_xyzw_11.x;
                    r9_y_11 = r9_xyzw_11.y;
                    r9_z_11 = r9_xyzw_11.z;
                    r9_w_4 = r9_xyzw_11.w;
                }
                else
                {
                    float4 r9_xyzw_5 = float4(1, 1, 1, 1);
                    r9_x_12 = r9_xyzw_5.x;
                    r9_y_11 = r9_xyzw_5.y;
                    r9_z_11 = r9_xyzw_5.z;
                    r9_w_4 = r9_xyzw_5.w;
                }
                float r2_y_12 = saturate(dot(float4(r9_x_12, r9_y_11, r9_z_11, r9_w_4), unity_OcclusionMaskSelector));
                float r2_z_7 = (r2_x_4 < 0.99);
                float r2_z_19;
                if (r2_z_7)
                {
                    float4 r9_xyzw_13 = (i.texcoord7.xyzx + -cb2_values[1].xyzx);
                    float r9_x_13 = r9_xyzw_13.x;
                    float r9_y_12 = r9_xyzw_13.y;
                    float r9_z_12 = r9_xyzw_13.z;
                    float r2_z_9 = max(abs(r9_y_12), abs(r9_x_13));
                    float r2_z_10 = max(abs(r9_z_12), r2_z_9);
                    float r2_z_11 = (r2_z_10 + -cb2_values[2].z);
                    float r2_z_12 = max(r2_z_11, 1E-05);
                    float r2_z_13 = (r2_z_12 * cb2_values[2].w);
                    float r2_z_14 = (cb2_values[2].y / r2_z_13);
                    float r2_z_15 = (r2_z_14 + -cb2_values[2].x);
                    float r2_z_16 = (-r2_z_15 + 1);
                    float r10_x_2 = t8.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((float4(r9_x_13, r9_y_12, r9_z_12, r9_x_13) + float4(0.0078125, 0.0078125, 0.0078125, 0))).xyzx).xyz, r2_z_16);
                    float r10_y_2 = t8.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((float4(r9_x_13, r9_y_12, r9_z_12, r9_x_13) + float4(-0.0078125, -0.0078125, 0.0078125, 0))).xyzx).xyz, r2_z_16);
                    float r10_z_2 = t8.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((float4(r9_x_13, r9_y_12, r9_z_12, r9_x_13) + float4(-0.0078125, 0.0078125, -0.0078125, 0))).xyzx).xyz, r2_z_16);
                    float4 r9_xyzw_14 = (float4(r9_x_13, r9_y_12, r9_z_12, r9_x_13) + float4(0.0078125, -0.0078125, -0.0078125, 0));
                    float r9_x_14 = r9_xyzw_14.x;
                    float r9_y_13 = r9_xyzw_14.y;
                    float r9_z_13 = r9_xyzw_14.z;
                    float r10_w_1 = t8.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r9_x_14, r9_y_13, r9_z_13, r9_x_14)).xyz, r2_z_16);
                    float r2_z_17 = dot(float4(r10_x_2, r10_y_2, r10_z_2, r10_w_1), float4(0.25, 0.25, 0.25, 0.25));
                    float r2_w_13 = (-cb3_values[24].x + 1);
                    float r2_z_18 = mad(r2_z_17, r2_w_13, cb3_values[24].x);
                    r2_z_19 = r2_z_18;
                }
                else
                {
                    float r2_z_8 = 1;
                    r2_z_19 = r2_z_8;
                }
                float r2_y_13 = (-r2_z_19 + r2_y_12);
                float r2_y_14 = dot(float4(r7_x_5, r7_z_6, r7_w_6, r7_x_5), float4(r7_x_5, r7_z_6, r7_w_6, r7_x_5));
                float r2_y_15 = (_DetailAlbedo.Sample(sampler_DetailAlbedo, (r2_y_14.xxxx).xy)).y;
                float r9_x_16 = dot(i.texcoord4.xyzx, float4(r8_x_5, r8_y_4, r8_z_4, r8_x_5));
                float r9_y_15 = dot(i.texcoord5.xyzx, float4(r8_x_5, r8_y_4, r8_z_4, r8_x_5));
                float r9_z_15 = dot(i.texcoord6.xyzx, float4(r8_x_5, r8_y_4, r8_z_4, r8_x_5));
                float r2_y_16 = dot(float4(r9_x_16, r9_y_15, r9_z_15, r9_x_16), float4(r9_x_16, r9_y_15, r9_z_15, r9_x_16));
                float r2_y_17 = rsqrt(r2_y_16);
                float4 r2_xyzw_18 = (r2_y_17.xxxx * float4(r9_x_16, r9_x_16, r9_y_15, r9_z_15));
                float r2_y_18 = r2_xyzw_18.y;
                float r2_z_20 = r2_xyzw_18.z;
                float r2_w_15 = r2_xyzw_18.w;
                float4 r7_xyzw_6 = (((mad(r2_x_4, r2_y_13, r2_z_19) * r2_y_15)).xxxx * _LightColor0.xxyz);
                float r7_x_6 = r7_xyzw_6.x;
                float r7_z_7 = r7_xyzw_6.z;
                float r7_w_7 = r7_xyzw_6.w;
                float3 r4_xyz_4 = (mad(r1_w_6.xxxx, (mad(r4_xyz_2.xyzx, r5_xyz_3.xyzx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_7 = mad(-r1_w_6, 0.96, 0.96);
                float r1_w_8 = mad(-r7_xy_1.y, cb0_values[8].z, 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r2_y_18, r2_z_20, r2_w_15, r2_y_18), unitViewDir_xyz_1.xyzx);
                float r2_x_7 = saturate(dot(float4(r2_y_18, r2_z_20, r2_w_15, r2_y_18), r1_xyz_1.xyzx));
                float r2_y_19 = saturate(dot(float4(r2_y_18, r2_z_20, r2_w_15, r2_y_18), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_8.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_x_7 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_8 * r1_w_8);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(r0_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * mad(r2_x_7, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_x_7, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r2_y_19, r0_z_9, -r2_y_19), r2_y_19, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_x_7.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r7_x_6, r7_z_7, r7_w_7, r7_x_6));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r7_x_6, r7_x_6, r7_z_7, r7_w_7) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_9 = (r0_x_5 * r0_x_5);
                float r1_w_10 = (r1_w_9 * r1_w_9);
                float4 r2_xyzw_8 = (-r4_xyz_4.xyzx + float4(1, 1, 1, 0));
                float r2_x_8 = r2_xyzw_8.x;
                float r2_y_20 = r2_xyzw_8.y;
                float r2_z_21 = r2_xyzw_8.z;
                float4 r2_xyzw_9 = mad(float4(r2_x_8, r2_y_20, r2_z_21, r2_x_8), ((r0_x_5 * r1_w_10)).xxxx, r4_xyz_4.xyzx);
                float r2_x_9 = r2_xyzw_9.x;
                float r2_y_21 = r2_xyzw_9.y;
                float r2_z_22 = r2_xyzw_9.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_9, r2_y_21, r2_z_22, r2_x_9));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_7.xxxx * ((r4_xyz_2.xyzx * r5_xyz_3.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float4 r1_xyzw_12 = mad(float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8), i.color0.xyzx, -float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8));
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_6 = r1_xyzw_12.y;
                float r1_z_3 = r1_xyzw_12.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_12, r1_y_6, r1_z_3, r1_x_12), float4(0.1, 0.1, 0.1, 0), float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "PerformanceChecks"="False" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0;
                float _BumpScale;
                float _Metallic;
                float _Glossiness;
                float _OcclusionStrength;
                float _Cutoff;
                float4 _Color;
                float4 _EmissionColor;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 _MetallicGlossMap_ST;
                float4 _OcclusionMap_ST;
                float4 _EmissionMap_ST;
                float4 _DetailMask_ST;
                float4 _DetailAlbedo_ST;
                float4 _DetailNormal_ST;
                float4 cb0_values[19];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[3];
            };
            cbuffer _UnityProbeVolumeCB_b3
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
            SamplerState sampler_DetailNormal;
            SamplerComparisonState sampler_comparison_linear_clamp1;
            SamplerState sampler_DetailAlbedo;
            SamplerState sampler_MainTex;
            SamplerState sampler_EmissionMap;
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_BumpMap;
            SamplerState sampler_MetallicGlossMap;
            SamplerState sampler_DetailMask;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _MetallicGlossMap;
            Texture2D _OcclusionMap;
            Texture2D _EmissionMap;
            Texture2D _DetailMask;
            Texture2D _DetailAlbedo;
            Texture3D _DetailNormal;
            TextureCube t8;
            struct program36Input
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
            struct program36Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float3 texcoord7 : TEXCOORD7;
                float4 color0 : COLOR0;
                float3 texcoord8 : TEXCOORD8;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program59Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float3 texcoord7 : TEXCOORD7;
                float4 color0 : COLOR0;
                float3 texcoord8 : TEXCOORD8;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program59Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program36Output vert(program36Input i)
            {
                program36Output o = (program36Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _EmissionMap_ST.xyxx, _EmissionMap_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _DetailMask_ST.xxxy, _DetailMask_ST.zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _DetailAlbedo_ST.xyxx, _DetailAlbedo_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _DetailNormal_ST.xxxy, _DetailNormal_ST.zzzw)).zw;
                o.texcoord2.xy = (mad(i.texcoord0.xyxx, cb0_values[16].xyxx, cb0_values[16].zwzz)).xy;
                o.texcoord2.zw = (mad(i.texcoord0.xxxy, cb0_values[17].xxxy, cb0_values[17].zzzw)).zw;
                o.texcoord3.xy = (mad(i.texcoord0.xyxx, cb0_values[18].xyxx, cb0_values[18].zwzz)).xy;
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                float3 unitWorldNormal_xyz_3 = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_6 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_6.xxxx * (mad(unitWorldNormal_xyz_3.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_3.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord4.y = r3_xyz_3.x;
                o.texcoord4.x = unitWorldTangent_xyz_7.z;
                o.texcoord4.z = unitWorldNormal_xyz_3.y;
                o.texcoord5.x = unitWorldTangent_xyz_7.x;
                o.texcoord6.x = unitWorldTangent_xyz_7.y;
                o.texcoord5.z = unitWorldNormal_xyz_3.z;
                o.texcoord6.z = unitWorldNormal_xyz_3.x;
                o.texcoord5.y = r3_xyz_3.y;
                o.texcoord6.y = r3_xyz_3.z;
                o.texcoord7.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                float3 clipPos_xyz_4 = ((worldPos_xyzw_4.yyyy * cb0_values[5].xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(_Color.xyzx, worldPos_xyzw_4.zzzz, (mad(cb0_values[4].xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_4.xyzx)).xyzx)).xyz;
                o.texcoord8.xyz = (mad(_EmissionColor.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord9.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program59Output frag(program59Input i)
            {
                program59Output o = (program59Output)0;
                float3 r0_xyz_1 = ((-i.texcoord7.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord7.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_2 = ((r4_xyzw_1.xyzx * cb0_values[10].xyzx)).xyz;
                float r1_w_3 = (_BumpMap.Sample(sampler_BumpMap, (i.texcoord2.xyxx).xy)).w;
                float3 r5_xyz_1 = (_MetallicGlossMap.Sample(sampler_MetallicGlossMap, (i.texcoord2.zwzz).xy)).xyz;
                float3 r5_xyz_3 = (mad(r1_w_3.xxxx, (mad(r5_xyz_1.xyzx, float4(2, 2, 2, 0), float4(-2, -2, -2, 0))).xyzx, float4(1, 1, 1, 0))).xyz;
                float2 r7_xy_1 = (_OcclusionMap.Sample(sampler_OcclusionMap, (i.texcoord1.xyxx).xy)).xy;
                float3 r8_xyz_1 = (_EmissionMap.Sample(sampler_EmissionMap, (i.texcoord0.zwzz).xy)).xyz;
                float r8_x_2 = (r8_xyz_1.z * r8_xyz_1.x);
                float2 r7_zw_1 = (mad(float4(r8_x_2, r8_x_2, r8_x_2, r8_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r8_xyzw_3 = (r7_zw_1.xyxx * cb0_values[8].xxxx);
                float r8_x_3 = r8_xyzw_3.x;
                float r8_y_2 = r8_xyzw_3.y;
                float r2_w_1 = dot(float4(r8_x_3, r8_y_2, r8_x_3, r8_x_3), float4(r8_x_3, r8_y_2, r8_x_3, r8_x_3));
                float r2_w_2 = min(r2_w_1, 1);
                float r2_w_3 = (-r2_w_2 + 1);
                float r8_z_2 = sqrt(r2_w_3);
                float3 r9_xyz_1 = (_DetailMask.Sample(sampler_DetailMask, (i.texcoord3.xyxx).xy)).xyz;
                float r9_x_2 = (r9_xyz_1.z * r9_xyz_1.x);
                float2 r7_zw_2 = (mad(float4(r9_x_2, r9_x_2, r9_x_2, r9_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r9_xyzw_3 = (r7_zw_2.xyxx * cb0_values[8].xxxx);
                float r9_x_3 = r9_xyzw_3.x;
                float r9_y_2 = r9_xyzw_3.y;
                float r2_w_4 = dot(float4(r9_x_3, r9_y_2, r9_x_3, r9_x_3), float4(r9_x_3, r9_y_2, r9_x_3, r9_x_3));
                float r2_w_5 = min(r2_w_4, 1);
                float r2_w_6 = (-r2_w_5 + 1);
                float r9_z_2 = sqrt(r2_w_6);
                float4 r8_xyzw_4 = mad(float4(r9_x_3, r9_y_2, r9_z_2, r9_x_3), r1_w_3.xxxx, float4(r8_x_3, r8_y_2, r8_z_2, r8_x_3));
                float r8_x_4 = r8_xyzw_4.x;
                float r8_y_3 = r8_xyzw_4.y;
                float r8_z_3 = r8_xyzw_4.z;
                float r1_w_4 = dot(float4(r8_x_4, r8_y_3, r8_z_3, r8_x_4), float4(r8_x_4, r8_y_3, r8_z_3, r8_x_4));
                float r1_w_5 = rsqrt(r1_w_4);
                float4 r8_xyzw_5 = (r1_w_5.xxxx * float4(r8_x_4, r8_y_3, r8_z_3, r8_x_4));
                float r8_x_5 = r8_xyzw_5.x;
                float r8_y_4 = r8_xyzw_5.y;
                float r8_z_4 = r8_xyzw_5.z;
                float r1_w_6 = (r7_xy_1.x * cb0_values[8].y);
                float r2_w_7 = mad(r4_xyzw_1.w, cb0_values[10].w, -cb0_values[9].x);
                float r2_w_8 = (r2_w_7 < 0);
                if (r2_w_8) discard;
                float4 r7_xyzw_2 = (i.texcoord7.yyyy * cb0_values[5].xxyz);
                float r7_x_2 = r7_xyzw_2.x;
                float r7_z_3 = r7_xyzw_2.z;
                float r7_w_3 = r7_xyzw_2.w;
                float4 r7_xyzw_3 = mad(cb0_values[4].xxyz, i.texcoord7.xxxx, float4(r7_x_2, r7_x_2, r7_z_3, r7_w_3));
                float r7_x_3 = r7_xyzw_3.x;
                float r7_z_4 = r7_xyzw_3.z;
                float r7_w_4 = r7_xyzw_3.w;
                float4 r7_xyzw_4 = mad(cb0_values[6].xxyz, i.texcoord7.zzzz, float4(r7_x_3, r7_x_3, r7_z_4, r7_w_4));
                float r7_x_4 = r7_xyzw_4.x;
                float r7_z_5 = r7_xyzw_4.z;
                float r7_w_5 = r7_xyzw_4.w;
                float4 r7_xyzw_5 = (float4(r7_x_4, r7_x_4, r7_z_5, r7_w_5) + cb0_values[7].xxyz);
                float r7_x_5 = r7_xyzw_5.x;
                float r7_z_6 = r7_xyzw_5.z;
                float r7_w_6 = r7_xyzw_5.w;
                float r9_x_4 = cb4_values[9].z;
                float r9_y_3 = cb4_values[10].z;
                float r9_z_3 = cb4_values[11].z;
                float r2_x_2 = dot(viewDir_xyz_1.xyzx, float4(r9_x_4, r9_y_3, r9_z_3, r9_x_4));
                float4 r2_xyzw_2 = (i.texcoord7.xxyz + -cb3_values[25].xxyz);
                float r2_y_2 = r2_xyzw_2.y;
                float r2_z_2 = r2_xyzw_2.z;
                float r2_w_9 = r2_xyzw_2.w;
                float r2_y_3 = dot(float4(r2_y_2, r2_z_2, r2_w_9, r2_y_2), float4(r2_y_2, r2_z_2, r2_w_9, r2_y_2));
                float r2_y_4 = sqrt(r2_y_3);
                float r2_y_5 = (-r2_x_2 + r2_y_4);
                float r2_y_6 = (cb5_values[0].x == 1);
                float r9_x_12;
                float r9_y_11;
                float r9_z_11;
                float r9_w_4;
                if (r2_y_6)
                {
                    float r2_y_7 = (cb5_values[0].y == 1);
                    float4 r9_xyzw_6 = (i.texcoord7.yyyy * cb5_values[2].xyzx);
                    float r9_x_6 = r9_xyzw_6.x;
                    float r9_y_5 = r9_xyzw_6.y;
                    float r9_z_5 = r9_xyzw_6.z;
                    float4 r9_xyzw_7 = mad(cb5_values[1].xyzx, i.texcoord7.xxxx, float4(r9_x_6, r9_y_5, r9_z_5, r9_x_6));
                    float r9_x_7 = r9_xyzw_7.x;
                    float r9_y_6 = r9_xyzw_7.y;
                    float r9_z_6 = r9_xyzw_7.z;
                    float4 r9_xyzw_8 = mad(cb5_values[3].xyzx, i.texcoord7.zzzz, float4(r9_x_7, r9_y_6, r9_z_6, r9_x_7));
                    float r9_x_8 = r9_xyzw_8.x;
                    float r9_y_7 = r9_xyzw_8.y;
                    float r9_z_7 = r9_xyzw_8.z;
                    float4 r9_xyzw_9 = (float4(r9_x_8, r9_y_7, r9_z_7, r9_x_8) + cb5_values[4].xyzx);
                    float r9_x_9 = r9_xyzw_9.x;
                    float r9_y_8 = r9_xyzw_9.y;
                    float r9_z_8 = r9_xyzw_9.z;
                    float4 r2_xyzw_8 = (r2_y_7.xxxx ? float4(r9_x_9, r9_x_9, r9_y_8, r9_z_8) : i.texcoord7.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float r2_w_10 = r2_xyzw_8.w;
                    float4 r2_xyzw_9 = (float4(r2_y_8, r2_y_8, r2_z_3, r2_w_10) + -cb5_values[6].xxyz);
                    float r2_y_9 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float r2_w_11 = r2_xyzw_9.w;
                    float r9_y_9 = ((float4(r2_y_9, r2_y_9, r2_z_4, r2_w_11) * cb5_values[5].xxyz)).y;
                    float r9_z_9 = ((float4(r2_y_9, r2_y_9, r2_z_4, r2_w_11) * cb5_values[5].xxyz)).z;
                    float r9_w_2 = ((float4(r2_y_9, r2_y_9, r2_z_4, r2_w_11) * cb5_values[5].xxyz)).w;
                    float r2_y_10 = mad(r9_y_9, 0.25, 0.75);
                    float r2_z_5 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r9_x_10 = max(r2_z_5, r2_y_10);
                    float4 r9_xyzw_11 = _DetailNormal.Sample(sampler_DetailNormal, (float4(r9_x_10, r9_z_9, r9_w_2, r9_x_10)).xyz);
                    r9_x_12 = r9_xyzw_11.x;
                    r9_y_11 = r9_xyzw_11.y;
                    r9_z_11 = r9_xyzw_11.z;
                    r9_w_4 = r9_xyzw_11.w;
                }
                else
                {
                    float4 r9_xyzw_5 = float4(1, 1, 1, 1);
                    r9_x_12 = r9_xyzw_5.x;
                    r9_y_11 = r9_xyzw_5.y;
                    r9_z_11 = r9_xyzw_5.z;
                    r9_w_4 = r9_xyzw_5.w;
                }
                float r2_y_12 = saturate(dot(float4(r9_x_12, r9_y_11, r9_z_11, r9_w_4), unity_OcclusionMaskSelector));
                float4 r9_xyzw_13 = (i.texcoord7.xyzx + -cb2_values[1].xyzx);
                float r9_x_13 = r9_xyzw_13.x;
                float r9_y_12 = r9_xyzw_13.y;
                float r9_z_12 = r9_xyzw_13.z;
                float r2_z_7 = max(abs(r9_y_12), abs(r9_x_13));
                float r2_z_8 = max(abs(r9_z_12), r2_z_7);
                float r2_z_9 = (r2_z_8 + -cb2_values[2].z);
                float r2_z_10 = max(r2_z_9, 1E-05);
                float r2_z_11 = (r2_z_10 * cb2_values[2].w);
                float r2_z_12 = (cb2_values[2].y / r2_z_11);
                float r2_z_13 = (r2_z_12 + -cb2_values[2].x);
                float r2_z_14 = (-r2_z_13 + 1);
                float r2_z_15 = t8.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r9_x_13, r9_y_12, r9_z_12, r9_x_13)).xyz, r2_z_14);
                float r2_w_13 = (-cb3_values[24].x + 1);
                float r2_z_16 = mad(r2_z_15, r2_w_13, cb3_values[24].x);
                float r2_y_13 = (-r2_z_16 + r2_y_12);
                float r2_y_14 = dot(float4(r7_x_5, r7_z_6, r7_w_6, r7_x_5), float4(r7_x_5, r7_z_6, r7_w_6, r7_x_5));
                float r2_y_15 = (_DetailAlbedo.Sample(sampler_DetailAlbedo, (r2_y_14.xxxx).xy)).y;
                float r9_x_14 = dot(i.texcoord4.xyzx, float4(r8_x_5, r8_y_4, r8_z_4, r8_x_5));
                float r9_y_13 = dot(i.texcoord5.xyzx, float4(r8_x_5, r8_y_4, r8_z_4, r8_x_5));
                float r9_z_13 = dot(i.texcoord6.xyzx, float4(r8_x_5, r8_y_4, r8_z_4, r8_x_5));
                float r2_y_16 = dot(float4(r9_x_14, r9_y_13, r9_z_13, r9_x_14), float4(r9_x_14, r9_y_13, r9_z_13, r9_x_14));
                float r2_y_17 = rsqrt(r2_y_16);
                float4 r2_xyzw_18 = (r2_y_17.xxxx * float4(r9_x_14, r9_x_14, r9_y_13, r9_z_13));
                float r2_y_18 = r2_xyzw_18.y;
                float r2_z_17 = r2_xyzw_18.z;
                float r2_w_14 = r2_xyzw_18.w;
                float4 r7_xyzw_6 = (((mad(saturate(mad(mad(cb3_values[25].w, r2_y_5, r2_x_2), cb3_values[24].z, cb3_values[24].w)), r2_y_13, r2_z_16) * r2_y_15)).xxxx * _LightColor0.xxyz);
                float r7_x_6 = r7_xyzw_6.x;
                float r7_z_7 = r7_xyzw_6.z;
                float r7_w_7 = r7_xyzw_6.w;
                float3 r4_xyz_4 = (mad(r1_w_6.xxxx, (mad(r4_xyz_2.xyzx, r5_xyz_3.xyzx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_7 = mad(-r1_w_6, 0.96, 0.96);
                float r1_w_8 = mad(-r7_xy_1.y, cb0_values[8].z, 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r2_y_18, r2_z_17, r2_w_14, r2_y_18), unitViewDir_xyz_1.xyzx);
                float r2_x_7 = saturate(dot(float4(r2_y_18, r2_z_17, r2_w_14, r2_y_18), r1_xyz_1.xyzx));
                float r2_y_19 = saturate(dot(float4(r2_y_18, r2_z_17, r2_w_14, r2_y_18), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_8.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_x_7 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_8 * r1_w_8);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(r0_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * mad(r2_x_7, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_x_7, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r2_y_19, r0_z_9, -r2_y_19), r2_y_19, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_x_7.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r7_x_6, r7_z_7, r7_w_7, r7_x_6));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r7_x_6, r7_x_6, r7_z_7, r7_w_7) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_9 = (r0_x_5 * r0_x_5);
                float r1_w_10 = (r1_w_9 * r1_w_9);
                float4 r2_xyzw_8 = (-r4_xyz_4.xyzx + float4(1, 1, 1, 0));
                float r2_x_8 = r2_xyzw_8.x;
                float r2_y_20 = r2_xyzw_8.y;
                float r2_z_18 = r2_xyzw_8.z;
                float4 r2_xyzw_9 = mad(float4(r2_x_8, r2_y_20, r2_z_18, r2_x_8), ((r0_x_5 * r1_w_10)).xxxx, r4_xyz_4.xyzx);
                float r2_x_9 = r2_xyzw_9.x;
                float r2_y_21 = r2_xyzw_9.y;
                float r2_z_19 = r2_xyzw_9.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_9, r2_y_21, r2_z_19, r2_x_9));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_7.xxxx * ((r4_xyz_2.xyzx * r5_xyz_3.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float4 r1_xyzw_12 = mad(float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8), i.color0.xyzx, -float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8));
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_6 = r1_xyzw_12.y;
                float r1_z_3 = r1_xyzw_12.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_12, r1_y_6, r1_z_3, r1_x_12), float4(0.1, 0.1, 0.1, 0), float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "PerformanceChecks"="False" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0;
                float _BumpScale;
                float _Metallic;
                float _Glossiness;
                float _OcclusionStrength;
                float _Cutoff;
                float4 _Color;
                float4 _EmissionColor;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 _MetallicGlossMap_ST;
                float4 _OcclusionMap_ST;
                float4 _EmissionMap_ST;
                float4 _DetailMask_ST;
                float4 _DetailAlbedo_ST;
                float4 _DetailNormal_ST;
                float4 cb0_values[19];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[10];
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
            SamplerState sampler_linear_clamp;
            SamplerState sampler_DetailAlbedo;
            SamplerState sampler_DetailNormal;
            SamplerState sampler_MainTex;
            SamplerState sampler_EmissionMap;
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_BumpMap;
            SamplerState sampler_MetallicGlossMap;
            SamplerState sampler_DetailMask;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _MetallicGlossMap;
            Texture2D _OcclusionMap;
            Texture2D _EmissionMap;
            Texture2D _DetailMask;
            Texture2D _DetailAlbedo;
            Texture2D _DetailNormal;
            Texture3D t8;
            struct program35Input
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
            struct program35Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float2 texcoord8 : TEXCOORD8;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float3 texcoord7 : TEXCOORD7;
                float4 color0 : COLOR0;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program58Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float2 texcoord8 : TEXCOORD8;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float3 texcoord7 : TEXCOORD7;
                float4 color0 : COLOR0;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program58Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program35Output vert(program35Input i)
            {
                program35Output o = (program35Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _EmissionMap_ST.xyxx, _EmissionMap_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _DetailMask_ST.xxxy, _DetailMask_ST.zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _DetailAlbedo_ST.xyxx, _DetailAlbedo_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _DetailNormal_ST.xxxy, _DetailNormal_ST.zzzw)).zw;
                o.texcoord2.xy = (mad(i.texcoord0.xyxx, cb0_values[16].xyxx, cb0_values[16].zwzz)).xy;
                o.texcoord2.zw = (mad(i.texcoord0.xxxy, cb0_values[17].xxxy, cb0_values[17].zzzw)).zw;
                float4 r2_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord7.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                o.texcoord8.xy = (mad(_EmissionColor.xxxy, r2_xyzw_4.wwww, (mad(_Color.xyxx, r2_xyzw_4.zzzz, (mad(cb0_values[4].xyxx, r2_xyzw_4.xxxx, ((r2_xyzw_4.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xxxy)).zw;
                o.texcoord3.xy = (mad(i.texcoord0.xyxx, cb0_values[18].xyxx, cb0_values[18].zwzz)).xy;
                float r0_y_7 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float r0_z_4 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float r0_x_7 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_w_4 = dot(float4(r0_x_7, r0_y_7, r0_z_4, r0_x_7), float4(r0_x_7, r0_y_7, r0_z_4, r0_x_7));
                float r0_w_5 = rsqrt(r0_w_4);
                float4 unitWorldNormal_xyzw_8 = (r0_w_5.xxxx * float4(r0_x_7, r0_y_7, r0_z_4, r0_x_7));
                float unitWorldNormal_x_8 = unitWorldNormal_xyzw_8.x;
                float unitWorldNormal_y_8 = unitWorldNormal_xyzw_8.y;
                float unitWorldNormal_z_5 = unitWorldNormal_xyzw_8.z;
                float3 worldTangent_xyz_5 = ((i.tangent0.yyyy * cb2_values[1].yzxy)).xyz;
                float3 worldTangent_xyz_6 = (mad(cb2_values[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_5.xyzx)).xyz;
                float3 worldTangent_xyz_7 = (mad(cb2_values[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_6.xyzx)).xyz;
                float3 unitWorldTangent_xyz_8 = normalize(worldTangent_xyz_7);
                float r0_w_8 = (i.tangent0.w * cb2_values[9].w);
                float3 r3_xyz_3 = ((r0_w_8.xxxx * (mad(float4(unitWorldNormal_z_5, unitWorldNormal_x_8, unitWorldNormal_y_8, unitWorldNormal_z_5), unitWorldTangent_xyz_8.yzxy, ((float4(unitWorldNormal_x_8, unitWorldNormal_y_8, unitWorldNormal_z_5, unitWorldNormal_x_8) * unitWorldTangent_xyz_8.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord4.y = r3_xyz_3.x;
                o.texcoord4.x = unitWorldTangent_xyz_8.z;
                o.texcoord4.z = unitWorldNormal_y_8;
                o.texcoord5.x = unitWorldTangent_xyz_8.x;
                o.texcoord6.x = unitWorldTangent_xyz_8.y;
                o.texcoord5.z = unitWorldNormal_z_5;
                o.texcoord6.z = unitWorldNormal_x_8;
                o.texcoord5.y = r3_xyz_3.y;
                o.texcoord6.y = r3_xyz_3.z;
                o.color0.xyzw = i.color0.xyzw;
                float r0_w_9 = ((clipPos_xyzw_2.y * unity_WorldToObject[1].x) * 0.5);
                float4 r0_xyzw_10 = (clipPos_xyzw_2.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_z_6 = r0_xyzw_10.z;
                o.texcoord9.zw = (clipPos_xyzw_2.zzzw).zw;
                o.texcoord9.xy = ((r0_z_6.xxxx + float4(r0_x_10, r0_w_9, r0_x_10, r0_x_10))).xy;
                return o;
            }
            #pragma fragment frag
            program58Output frag(program58Input i)
            {
                program58Output o = (program58Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord7.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_2 = ((r2_xyzw_1.xyzx * cb0_values[10].xyzx)).xyz;
                float r1_w_1 = (_BumpMap.Sample(sampler_BumpMap, (i.texcoord2.xyxx).xy)).w;
                float3 r3_xyz_1 = (_MetallicGlossMap.Sample(sampler_MetallicGlossMap, (i.texcoord2.zwzz).xy)).xyz;
                float3 r3_xyz_3 = (mad(r1_w_1.xxxx, (mad(r3_xyz_1.xyzx, float4(2, 2, 2, 0), float4(-2, -2, -2, 0))).xyzx, float4(1, 1, 1, 0))).xyz;
                float2 r5_xy_1 = (_OcclusionMap.Sample(sampler_OcclusionMap, (i.texcoord1.xyxx).xy)).xy;
                float3 r6_xyz_1 = (_EmissionMap.Sample(sampler_EmissionMap, (i.texcoord0.zwzz).xy)).xyz;
                float r6_x_2 = (r6_xyz_1.z * r6_xyz_1.x);
                float2 r5_zw_1 = (mad(float4(r6_x_2, r6_x_2, r6_x_2, r6_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r6_xyzw_3 = (r5_zw_1.xyxx * cb0_values[8].xxxx);
                float r6_x_3 = r6_xyzw_3.x;
                float r6_y_2 = r6_xyzw_3.y;
                float r3_w_1 = dot(float4(r6_x_3, r6_y_2, r6_x_3, r6_x_3), float4(r6_x_3, r6_y_2, r6_x_3, r6_x_3));
                float r3_w_2 = min(r3_w_1, 1);
                float r3_w_3 = (-r3_w_2 + 1);
                float r6_z_2 = sqrt(r3_w_3);
                float3 r7_xyz_1 = (_DetailMask.Sample(sampler_DetailMask, (i.texcoord3.xyxx).xy)).xyz;
                float r7_x_2 = (r7_xyz_1.z * r7_xyz_1.x);
                float2 r5_zw_2 = (mad(float4(r7_x_2, r7_x_2, r7_x_2, r7_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r7_xyzw_3 = (r5_zw_2.xyxx * cb0_values[8].xxxx);
                float r7_x_3 = r7_xyzw_3.x;
                float r7_y_2 = r7_xyzw_3.y;
                float r3_w_4 = dot(float4(r7_x_3, r7_y_2, r7_x_3, r7_x_3), float4(r7_x_3, r7_y_2, r7_x_3, r7_x_3));
                float r3_w_5 = min(r3_w_4, 1);
                float r3_w_6 = (-r3_w_5 + 1);
                float r7_z_2 = sqrt(r3_w_6);
                float4 r6_xyzw_4 = mad(float4(r7_x_3, r7_y_2, r7_z_2, r7_x_3), r1_w_1.xxxx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r6_x_4 = r6_xyzw_4.x;
                float r6_y_3 = r6_xyzw_4.y;
                float r6_z_3 = r6_xyzw_4.z;
                float r1_w_2 = dot(float4(r6_x_4, r6_y_3, r6_z_3, r6_x_4), float4(r6_x_4, r6_y_3, r6_z_3, r6_x_4));
                float r1_w_3 = rsqrt(r1_w_2);
                float4 r6_xyzw_5 = (r1_w_3.xxxx * float4(r6_x_4, r6_y_3, r6_z_3, r6_x_4));
                float r6_x_5 = r6_xyzw_5.x;
                float r6_y_4 = r6_xyzw_5.y;
                float r6_z_4 = r6_xyzw_5.z;
                float r1_w_4 = (r5_xy_1.x * cb0_values[8].y);
                float r2_w_2 = mad(r2_xyzw_1.w, cb0_values[10].w, -cb0_values[9].x);
                float r2_w_3 = (r2_w_2 < 0);
                if (r2_w_3) discard;
                float4 r5_xyzw_2 = (i.texcoord7.yyyy * cb0_values[5].xxyx);
                float r5_x_2 = r5_xyzw_2.x;
                float r5_z_3 = r5_xyzw_2.z;
                float4 r5_xyzw_3 = mad(cb0_values[4].xxyx, i.texcoord7.xxxx, float4(r5_x_2, r5_x_2, r5_z_3, r5_x_2));
                float r5_x_3 = r5_xyzw_3.x;
                float r5_z_4 = r5_xyzw_3.z;
                float4 r5_xyzw_4 = mad(cb0_values[6].xxyx, i.texcoord7.zzzz, float4(r5_x_3, r5_x_3, r5_z_4, r5_x_3));
                float r5_x_4 = r5_xyzw_4.x;
                float r5_z_5 = r5_xyzw_4.z;
                float4 r5_xyzw_5 = (float4(r5_x_4, r5_x_4, r5_z_5, r5_x_4) + cb0_values[7].xxyx);
                float r5_x_5 = r5_xyzw_5.x;
                float r5_z_6 = r5_xyzw_5.z;
                float r7_x_4 = cb4_values[9].z;
                float r7_y_3 = cb4_values[10].z;
                float r7_z_3 = cb4_values[11].z;
                float r2_w_4 = dot(viewDir_xyz_1.xyzx, float4(r7_x_4, r7_y_3, r7_z_3, r7_x_4));
                float4 r7_xyzw_5 = (i.texcoord7.xyzx + -cb3_values[25].xyzx);
                float r7_x_5 = r7_xyzw_5.x;
                float r7_y_4 = r7_xyzw_5.y;
                float r7_z_4 = r7_xyzw_5.z;
                float r3_w_7 = dot(float4(r7_x_5, r7_y_4, r7_z_4, r7_x_5), float4(r7_x_5, r7_y_4, r7_z_4, r7_x_5));
                float r3_w_8 = sqrt(r3_w_7);
                float r3_w_9 = (-r2_w_4 + r3_w_8);
                float r2_w_5 = mad(cb3_values[25].w, r3_w_9, r2_w_4);
                float r2_w_6 = saturate(mad(r2_w_5, cb3_values[24].z, cb3_values[24].w));
                float r3_w_10 = (cb5_values[0].x == 1);
                float r7_x_15;
                float r7_y_14;
                float r7_z_14;
                float r7_w_4;
                if (r3_w_10)
                {
                    float r3_w_11 = (cb5_values[0].y == 1);
                    float4 r7_xyzw_7 = (i.texcoord7.yyyy * cb5_values[2].xyzx);
                    float r7_x_7 = r7_xyzw_7.x;
                    float r7_y_6 = r7_xyzw_7.y;
                    float r7_z_6 = r7_xyzw_7.z;
                    float4 r7_xyzw_8 = mad(cb5_values[1].xyzx, i.texcoord7.xxxx, float4(r7_x_7, r7_y_6, r7_z_6, r7_x_7));
                    float r7_x_8 = r7_xyzw_8.x;
                    float r7_y_7 = r7_xyzw_8.y;
                    float r7_z_7 = r7_xyzw_8.z;
                    float4 r7_xyzw_9 = mad(cb5_values[3].xyzx, i.texcoord7.zzzz, float4(r7_x_8, r7_y_7, r7_z_7, r7_x_8));
                    float r7_x_9 = r7_xyzw_9.x;
                    float r7_y_8 = r7_xyzw_9.y;
                    float r7_z_8 = r7_xyzw_9.z;
                    float4 r7_xyzw_10 = (float4(r7_x_9, r7_y_8, r7_z_8, r7_x_9) + cb5_values[4].xyzx);
                    float r7_x_10 = r7_xyzw_10.x;
                    float r7_y_9 = r7_xyzw_10.y;
                    float r7_z_9 = r7_xyzw_10.z;
                    float4 r7_xyzw_11 = (r3_w_11.xxxx ? float4(r7_x_10, r7_y_9, r7_z_9, r7_x_10) : i.texcoord7.xyzx);
                    float r7_x_11 = r7_xyzw_11.x;
                    float r7_y_10 = r7_xyzw_11.y;
                    float r7_z_10 = r7_xyzw_11.z;
                    float4 r7_xyzw_12 = (float4(r7_x_11, r7_y_10, r7_z_10, r7_x_11) + -cb5_values[6].xyzx);
                    float r7_x_12 = r7_xyzw_12.x;
                    float r7_y_11 = r7_xyzw_12.y;
                    float r7_z_11 = r7_xyzw_12.z;
                    float r7_y_12 = ((float4(r7_x_12, r7_x_12, r7_y_11, r7_z_11) * cb5_values[5].xxyz)).y;
                    float r7_z_12 = ((float4(r7_x_12, r7_x_12, r7_y_11, r7_z_11) * cb5_values[5].xxyz)).z;
                    float r7_w_2 = ((float4(r7_x_12, r7_x_12, r7_y_11, r7_z_11) * cb5_values[5].xxyz)).w;
                    float r3_w_12 = mad(r7_y_12, 0.25, 0.75);
                    float r4_w_1 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r7_x_13 = max(r3_w_12, r4_w_1);
                    float4 r7_xyzw_14 = t8.Sample(sampler_linear_clamp, (float4(r7_x_13, r7_z_12, r7_w_2, r7_x_13)).xyz);
                    r7_x_15 = r7_xyzw_14.x;
                    r7_y_14 = r7_xyzw_14.y;
                    r7_z_14 = r7_xyzw_14.z;
                    r7_w_4 = r7_xyzw_14.w;
                }
                else
                {
                    float4 r7_xyzw_6 = float4(1, 1, 1, 1);
                    r7_x_15 = r7_xyzw_6.x;
                    r7_y_14 = r7_xyzw_6.y;
                    r7_z_14 = r7_xyzw_6.z;
                    r7_w_4 = r7_xyzw_6.w;
                }
                float r3_w_14 = saturate(dot(float4(r7_x_15, r7_y_14, r7_z_14, r7_w_4), unity_OcclusionMaskSelector));
                float4 r7_xyzw_16 = (i.texcoord9.xyxx / i.texcoord9.wwww);
                float r7_x_16 = r7_xyzw_16.x;
                float r7_y_15 = r7_xyzw_16.y;
                float r4_w_3 = (_DetailAlbedo.Sample(sampler_DetailAlbedo, (float4(r7_x_16, r7_y_15, r7_x_16, r7_x_16)).xy)).w;
                float r3_w_15 = (r3_w_14 + -r4_w_3);
                float r2_w_7 = mad(r2_w_6, r3_w_15, r4_w_3);
                float r3_w_16 = (_DetailNormal.Sample(sampler_DetailNormal, (float4(r5_x_5, r5_z_6, r5_x_5, r5_x_5)).xy)).w;
                float r2_w_8 = (r2_w_7 * r3_w_16);
                float r7_x_17 = dot(i.texcoord4.xyzx, float4(r6_x_5, r6_y_4, r6_z_4, r6_x_5));
                float r7_y_16 = dot(i.texcoord5.xyzx, float4(r6_x_5, r6_y_4, r6_z_4, r6_x_5));
                float r7_z_15 = dot(i.texcoord6.xyzx, float4(r6_x_5, r6_y_4, r6_z_4, r6_x_5));
                float r3_w_17 = dot(float4(r7_x_17, r7_y_16, r7_z_15, r7_x_17), float4(r7_x_17, r7_y_16, r7_z_15, r7_x_17));
                float r3_w_18 = rsqrt(r3_w_17);
                float4 r5_xyzw_6 = (r3_w_18.xxxx * float4(r7_x_17, r7_x_17, r7_y_16, r7_z_15));
                float r5_x_6 = r5_xyzw_6.x;
                float r5_z_7 = r5_xyzw_6.z;
                float r5_w_3 = r5_xyzw_6.w;
                float4 r6_xyzw_6 = (r2_w_8.xxxx * _LightColor0.xyzx);
                float r6_x_6 = r6_xyzw_6.x;
                float r6_y_5 = r6_xyzw_6.y;
                float r6_z_5 = r6_xyzw_6.z;
                float3 r2_xyz_4 = (mad(r1_w_4.xxxx, (mad(r2_xyz_2.xyzx, r3_xyz_3.xyzx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_5 = mad(-r1_w_4, 0.96, 0.96);
                float r1_w_6 = mad(-r5_xy_1.y, cb0_values[8].z, 1);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r5_x_6, r5_z_7, r5_w_3, r5_x_6), unitViewDir_xyz_1.xyzx);
                float r1_x_2 = saturate(dot(float4(r5_x_6, r5_z_7, r5_w_3, r5_x_6), _WorldSpaceLightPos0.xyzx));
                float r1_y_2 = saturate(dot(float4(r5_x_6, r5_z_7, r5_w_3, r5_x_6), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_6.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(r0_w_6) + 1);
                float r2_w_9 = (r1_z_4 * r1_z_4);
                float r2_w_10 = (r2_w_9 * r2_w_9);
                float r1_z_5 = (r1_z_4 * r2_w_10);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_6 * r1_w_6);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_z_6 = (-r0_z_8 + 1);
                float r1_w_7 = mad(abs(r0_w_6), r1_z_6, r0_z_8);
                float r1_z_7 = mad(r1_x_2, r1_z_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * r1_z_7);
                float r0_w_8 = mad(r1_x_2, r1_w_7, r0_w_7);
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
                float4 r0_xyzw_9 = (r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_3 = (r0_y_9.xxxx * float4(r6_x_6, r6_y_5, r6_z_5, r6_x_6));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_5 = r1_xyzw_3.y;
                float r1_z_9 = r1_xyzw_3.z;
                float4 r0_xyzw_10 = (float4(r6_x_6, r6_x_6, r6_y_5, r6_z_5) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_8 = (r0_x_5 * r0_x_5);
                float r1_w_9 = (r1_w_8 * r1_w_8);
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * (mad(((-r2_xyz_4.xyzx + float4(1, 1, 1, 0))).xyzx, ((r0_x_5 * r1_w_9)).xxxx, r2_xyz_4.xyzx)).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_5.xxxx * ((r2_xyz_2.xyzx * r3_xyz_3.xyzx)).xyzx)).xyzx, float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float4 r1_xyzw_4 = mad(float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8), i.color0.xyzx, -float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_6 = r1_xyzw_4.y;
                float r1_z_10 = r1_xyzw_4.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_4, r1_y_6, r1_z_10, r1_x_4), float4(0.1, 0.1, 0.1, 0), float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "PerformanceChecks"="False" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0;
                float _BumpScale;
                float _Metallic;
                float _Glossiness;
                float _OcclusionStrength;
                float _Cutoff;
                float4 _Color;
                float4 _EmissionColor;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 _MetallicGlossMap_ST;
                float4 _OcclusionMap_ST;
                float4 _EmissionMap_ST;
                float4 _DetailMask_ST;
                float4 _DetailAlbedo_ST;
                float4 _DetailNormal_ST;
                float4 cb0_values[7];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[10];
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
            SamplerState sampler_DetailNormal;
            SamplerState sampler_DetailAlbedo;
            SamplerState sampler_MainTex;
            SamplerState sampler_EmissionMap;
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_BumpMap;
            SamplerState sampler_MetallicGlossMap;
            SamplerState sampler_DetailMask;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _MetallicGlossMap;
            Texture2D _OcclusionMap;
            Texture2D _EmissionMap;
            Texture2D _DetailMask;
            Texture2D _DetailAlbedo;
            Texture3D _DetailNormal;
            struct program34Input
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
            struct program34Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float3 texcoord7 : TEXCOORD7;
                float4 color0 : COLOR0;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program57Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float3 texcoord7 : TEXCOORD7;
                float4 color0 : COLOR0;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program57Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program34Output vert(program34Input i)
            {
                program34Output o = (program34Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                o.texcoord7.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _MetallicGlossMap_ST.xyxx, _MetallicGlossMap_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _OcclusionMap_ST.xxxy, _OcclusionMap_ST.zzzw)).zw;
                o.texcoord2.xy = (mad(i.texcoord0.xyxx, _EmissionMap_ST.xyxx, _EmissionMap_ST.zwzz)).xy;
                o.texcoord2.zw = (mad(i.texcoord0.xxxy, _DetailMask_ST.xxxy, _DetailMask_ST.zzzw)).zw;
                o.texcoord3.xy = (mad(i.texcoord0.xyxx, _DetailAlbedo_ST.xyxx, _DetailAlbedo_ST.zwzz)).xy;
                float r1_y_2 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float r1_z_2 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float r1_x_2 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_2 = dot(float4(r1_x_2, r1_y_2, r1_z_2, r1_x_2), float4(r1_x_2, r1_y_2, r1_z_2, r1_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                float3 unitWorldNormal_xyz_3 = ((r1_w_3.xxxx * float4(r1_x_2, r1_y_2, r1_z_2, r1_x_2))).xyz;
                float3 worldTangent_xyz_1 = ((i.tangent0.yyyy * cb2_values[1].yzxy)).xyz;
                float3 worldTangent_xyz_2 = (mad(cb2_values[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_1.xyzx)).xyz;
                float3 worldTangent_xyz_3 = (mad(cb2_values[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_2.xyzx)).xyz;
                float3 unitWorldTangent_xyz_4 = normalize(worldTangent_xyz_3);
                float r1_w_6 = (i.tangent0.w * cb2_values[9].w);
                float3 r3_xyz_3 = ((r1_w_6.xxxx * (mad(unitWorldNormal_xyz_3.zxyz, unitWorldTangent_xyz_4.yzxy, ((unitWorldNormal_xyz_3.xyzx * unitWorldTangent_xyz_4.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord4.y = r3_xyz_3.x;
                o.texcoord4.x = unitWorldTangent_xyz_4.z;
                o.texcoord4.z = unitWorldNormal_xyz_3.y;
                o.texcoord5.x = unitWorldTangent_xyz_4.x;
                o.texcoord6.x = unitWorldTangent_xyz_4.y;
                o.texcoord5.z = unitWorldNormal_xyz_3.z;
                o.texcoord6.z = unitWorldNormal_xyz_3.x;
                o.texcoord5.y = r3_xyz_3.y;
                o.texcoord6.y = r3_xyz_3.z;
                o.color0.xyzw = i.color0.xyzw;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r1_xyzw_4 = (float4(clipPos_xyzw_7.x, clipPos_xyzw_7.x, clipPos_xyzw_7.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_z_4 = r1_xyzw_4.z;
                float r1_w_7 = r1_xyzw_4.w;
                o.texcoord9.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord9.xy = ((r1_z_4.xxxx + float4(r1_x_4, r1_w_7, r1_x_4, r1_x_4))).xy;
                return o;
            }
            #pragma fragment frag
            program57Output frag(program57Input i)
            {
                program57Output o = (program57Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord7.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_2 = ((r2_xyzw_1.xyzx * cb0_values[6].xyzx)).xyz;
                float r1_w_1 = (_BumpMap.Sample(sampler_BumpMap, (i.texcoord2.xyxx).xy)).w;
                float3 r3_xyz_1 = (_MetallicGlossMap.Sample(sampler_MetallicGlossMap, (i.texcoord2.zwzz).xy)).xyz;
                float3 r3_xyz_3 = (mad(r1_w_1.xxxx, (mad(r3_xyz_1.xyzx, float4(2, 2, 2, 0), float4(-2, -2, -2, 0))).xyzx, float4(1, 1, 1, 0))).xyz;
                float2 r5_xy_1 = (_OcclusionMap.Sample(sampler_OcclusionMap, (i.texcoord1.xyxx).xy)).xy;
                float3 r6_xyz_1 = (_EmissionMap.Sample(sampler_EmissionMap, (i.texcoord0.zwzz).xy)).xyz;
                float r6_x_2 = (r6_xyz_1.z * r6_xyz_1.x);
                float2 r5_zw_1 = (mad(float4(r6_x_2, r6_x_2, r6_x_2, r6_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r6_xyzw_3 = (r5_zw_1.xyxx * cb0_values[4].xxxx);
                float r6_x_3 = r6_xyzw_3.x;
                float r6_y_2 = r6_xyzw_3.y;
                float r3_w_1 = dot(float4(r6_x_3, r6_y_2, r6_x_3, r6_x_3), float4(r6_x_3, r6_y_2, r6_x_3, r6_x_3));
                float r3_w_2 = min(r3_w_1, 1);
                float r3_w_3 = (-r3_w_2 + 1);
                float r6_z_2 = sqrt(r3_w_3);
                float3 r7_xyz_1 = (_DetailMask.Sample(sampler_DetailMask, (i.texcoord3.xyxx).xy)).xyz;
                float r7_x_2 = (r7_xyz_1.z * r7_xyz_1.x);
                float2 r5_zw_2 = (mad(float4(r7_x_2, r7_x_2, r7_x_2, r7_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r7_xyzw_3 = (r5_zw_2.xyxx * cb0_values[4].xxxx);
                float r7_x_3 = r7_xyzw_3.x;
                float r7_y_2 = r7_xyzw_3.y;
                float r3_w_4 = dot(float4(r7_x_3, r7_y_2, r7_x_3, r7_x_3), float4(r7_x_3, r7_y_2, r7_x_3, r7_x_3));
                float r3_w_5 = min(r3_w_4, 1);
                float r3_w_6 = (-r3_w_5 + 1);
                float r7_z_2 = sqrt(r3_w_6);
                float4 r6_xyzw_4 = mad(float4(r7_x_3, r7_y_2, r7_z_2, r7_x_3), r1_w_1.xxxx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r6_x_4 = r6_xyzw_4.x;
                float r6_y_3 = r6_xyzw_4.y;
                float r6_z_3 = r6_xyzw_4.z;
                float r1_w_2 = dot(float4(r6_x_4, r6_y_3, r6_z_3, r6_x_4), float4(r6_x_4, r6_y_3, r6_z_3, r6_x_4));
                float r1_w_3 = rsqrt(r1_w_2);
                float4 r6_xyzw_5 = (r1_w_3.xxxx * float4(r6_x_4, r6_y_3, r6_z_3, r6_x_4));
                float r6_x_5 = r6_xyzw_5.x;
                float r6_y_4 = r6_xyzw_5.y;
                float r6_z_4 = r6_xyzw_5.z;
                float r1_w_4 = (r5_xy_1.x * cb0_values[4].y);
                float r2_w_2 = mad(r2_xyzw_1.w, cb0_values[6].w, -cb0_values[5].x);
                float r2_w_3 = (r2_w_2 < 0);
                if (r2_w_3) discard;
                float r7_x_4 = cb4_values[9].z;
                float r7_y_3 = cb4_values[10].z;
                float r7_z_3 = cb4_values[11].z;
                float r2_w_4 = dot(viewDir_xyz_1.xyzx, float4(r7_x_4, r7_y_3, r7_z_3, r7_x_4));
                float4 r5_xyzw_2 = (i.texcoord7.xxyz + -cb3_values[25].xxyz);
                float r5_x_2 = r5_xyzw_2.x;
                float r5_z_3 = r5_xyzw_2.z;
                float r5_w_3 = r5_xyzw_2.w;
                float r3_w_7 = dot(float4(r5_x_2, r5_z_3, r5_w_3, r5_x_2), float4(r5_x_2, r5_z_3, r5_w_3, r5_x_2));
                float r3_w_8 = sqrt(r3_w_7);
                float r3_w_9 = (-r2_w_4 + r3_w_8);
                float r2_w_5 = mad(cb3_values[25].w, r3_w_9, r2_w_4);
                float r2_w_6 = saturate(mad(r2_w_5, cb3_values[24].z, cb3_values[24].w));
                float r3_w_10 = (cb5_values[0].x == 1);
                float r7_x_8;
                float r7_y_7;
                float r7_z_7;
                float r7_w_4;
                if (r3_w_10)
                {
                    float r3_w_11 = (cb5_values[0].y == 1);
                    float4 r5_xyzw_3 = (i.texcoord7.yyyy * cb5_values[2].xxyz);
                    float r5_x_3 = r5_xyzw_3.x;
                    float r5_z_4 = r5_xyzw_3.z;
                    float r5_w_4 = r5_xyzw_3.w;
                    float4 r5_xyzw_4 = mad(cb5_values[1].xxyz, i.texcoord7.xxxx, float4(r5_x_3, r5_x_3, r5_z_4, r5_w_4));
                    float r5_x_4 = r5_xyzw_4.x;
                    float r5_z_5 = r5_xyzw_4.z;
                    float r5_w_5 = r5_xyzw_4.w;
                    float4 r5_xyzw_5 = mad(cb5_values[3].xxyz, i.texcoord7.zzzz, float4(r5_x_4, r5_x_4, r5_z_5, r5_w_5));
                    float r5_x_5 = r5_xyzw_5.x;
                    float r5_z_6 = r5_xyzw_5.z;
                    float r5_w_6 = r5_xyzw_5.w;
                    float4 r5_xyzw_6 = (float4(r5_x_5, r5_x_5, r5_z_6, r5_w_6) + cb5_values[4].xxyz);
                    float r5_x_6 = r5_xyzw_6.x;
                    float r5_z_7 = r5_xyzw_6.z;
                    float r5_w_7 = r5_xyzw_6.w;
                    float4 r5_xyzw_7 = (r3_w_11.xxxx ? float4(r5_x_6, r5_x_6, r5_z_7, r5_w_7) : i.texcoord7.xxyz);
                    float r5_x_7 = r5_xyzw_7.x;
                    float r5_z_8 = r5_xyzw_7.z;
                    float r5_w_8 = r5_xyzw_7.w;
                    float4 r5_xyzw_8 = (float4(r5_x_7, r5_x_7, r5_z_8, r5_w_8) + -cb5_values[6].xxyz);
                    float r5_x_8 = r5_xyzw_8.x;
                    float r5_z_9 = r5_xyzw_8.z;
                    float r5_w_9 = r5_xyzw_8.w;
                    float4 r7_xyzw_5 = (float4(r5_x_8, r5_x_8, r5_z_9, r5_w_9) * cb5_values[5].xxyz);
                    float r7_y_5 = r7_xyzw_5.y;
                    float r7_z_5 = r7_xyzw_5.z;
                    float r7_w_2 = r7_xyzw_5.w;
                    float r3_w_12 = mad(r7_y_5, 0.25, 0.75);
                    float r4_w_1 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r7_x_6 = max(r3_w_12, r4_w_1);
                    float4 r7_xyzw_7 = _DetailNormal.Sample(sampler_DetailNormal, (float4(r7_x_6, r7_z_5, r7_w_2, r7_x_6)).xyz);
                    r7_x_8 = r7_xyzw_7.x;
                    r7_y_7 = r7_xyzw_7.y;
                    r7_z_7 = r7_xyzw_7.z;
                    r7_w_4 = r7_xyzw_7.w;
                }
                else
                {
                    float r7_x_5 = (float4(1, 1, 1, 1)).x;
                    float4 r7_xyzw_4 = float4(1, 1, 1, 1);
                    float r7_y_4 = r7_xyzw_4.y;
                    float r7_z_4 = r7_xyzw_4.z;
                    float r7_w_1 = r7_xyzw_4.w;
                    r7_x_8 = r7_x_5;
                    r7_y_7 = r7_y_4;
                    r7_z_7 = r7_z_4;
                    r7_w_4 = r7_w_1;
                }
                float r3_w_14 = saturate(dot(float4(r7_x_8, r7_y_7, r7_z_7, r7_w_4), unity_OcclusionMaskSelector));
                float4 r5_xyzw_10 = (i.texcoord9.xxyx / i.texcoord9.wwww);
                float r5_x_10 = r5_xyzw_10.x;
                float r5_z_11 = r5_xyzw_10.z;
                float r4_w_3 = (_DetailAlbedo.Sample(sampler_DetailAlbedo, (float4(r5_x_10, r5_z_11, r5_x_10, r5_x_10)).xy)).w;
                float r3_w_15 = (r3_w_14 + -r4_w_3);
                float r2_w_7 = mad(r2_w_6, r3_w_15, r4_w_3);
                float r7_x_9 = dot(i.texcoord4.xyzx, float4(r6_x_5, r6_y_4, r6_z_4, r6_x_5));
                float r7_y_8 = dot(i.texcoord5.xyzx, float4(r6_x_5, r6_y_4, r6_z_4, r6_x_5));
                float r7_z_8 = dot(i.texcoord6.xyzx, float4(r6_x_5, r6_y_4, r6_z_4, r6_x_5));
                float r3_w_16 = dot(float4(r7_x_9, r7_y_8, r7_z_8, r7_x_9), float4(r7_x_9, r7_y_8, r7_z_8, r7_x_9));
                float r3_w_17 = rsqrt(r3_w_16);
                float4 r5_xyzw_11 = (r3_w_17.xxxx * float4(r7_x_9, r7_x_9, r7_y_8, r7_z_8));
                float r5_x_11 = r5_xyzw_11.x;
                float r5_z_12 = r5_xyzw_11.z;
                float r5_w_11 = r5_xyzw_11.w;
                float4 r6_xyzw_6 = (r2_w_7.xxxx * _LightColor0.xyzx);
                float r6_x_6 = r6_xyzw_6.x;
                float r6_y_5 = r6_xyzw_6.y;
                float r6_z_5 = r6_xyzw_6.z;
                float3 r2_xyz_4 = (mad(r1_w_4.xxxx, (mad(r2_xyz_2.xyzx, r3_xyz_3.xyzx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_5 = mad(-r1_w_4, 0.96, 0.96);
                float r1_w_6 = mad(-r5_xy_1.y, cb0_values[4].z, 1);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r5_x_11, r5_z_12, r5_w_11, r5_x_11), unitViewDir_xyz_1.xyzx);
                float r1_x_2 = saturate(dot(float4(r5_x_11, r5_z_12, r5_w_11, r5_x_11), _WorldSpaceLightPos0.xyzx));
                float r1_y_2 = saturate(dot(float4(r5_x_11, r5_z_12, r5_w_11, r5_x_11), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_6.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(r0_w_6) + 1);
                float r2_w_8 = (r1_z_4 * r1_z_4);
                float r2_w_9 = (r2_w_8 * r2_w_8);
                float r1_z_5 = (r1_z_4 * r2_w_9);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_6 * r1_w_6);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_z_6 = (-r0_z_8 + 1);
                float r1_w_7 = mad(abs(r0_w_6), r1_z_6, r0_z_8);
                float r1_z_7 = mad(r1_x_2, r1_z_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * r1_z_7);
                float r0_w_8 = mad(r1_x_2, r1_w_7, r0_w_7);
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
                float4 r0_xyzw_9 = (r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_3 = (r0_y_9.xxxx * float4(r6_x_6, r6_y_5, r6_z_5, r6_x_6));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_5 = r1_xyzw_3.y;
                float r1_z_9 = r1_xyzw_3.z;
                float4 r0_xyzw_10 = (float4(r6_x_6, r6_x_6, r6_y_5, r6_z_5) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_8 = (r0_x_5 * r0_x_5);
                float r1_w_9 = (r1_w_8 * r1_w_8);
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * (mad(((-r2_xyz_4.xyzx + float4(1, 1, 1, 0))).xyzx, ((r0_x_5 * r1_w_9)).xxxx, r2_xyz_4.xyzx)).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_5.xxxx * ((r2_xyz_2.xyzx * r3_xyz_3.xyzx)).xyzx)).xyzx, float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float4 r1_xyzw_4 = mad(float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8), i.color0.xyzx, -float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_6 = r1_xyzw_4.y;
                float r1_z_10 = r1_xyzw_4.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_4, r1_y_6, r1_z_10, r1_x_4), float4(0.1, 0.1, 0.1, 0), float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "PerformanceChecks"="False" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0;
                float _BumpScale;
                float _Metallic;
                float _Glossiness;
                float _OcclusionStrength;
                float _Cutoff;
                float4 _Color;
                float4 _EmissionColor;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 _MetallicGlossMap_ST;
                float4 _OcclusionMap_ST;
                float4 _EmissionMap_ST;
                float4 _DetailMask_ST;
                float4 _DetailAlbedo_ST;
                float4 _DetailNormal_ST;
                float4 cb0_values[24];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0 : packoffset(c0);
                float4x4 unity_MatrixVP : packoffset(c17);
                float4 unity_OcclusionMaskSelector : packoffset(c46);
            };
            cbuffer _UnityProbeVolumeCB_b3
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
            SamplerState sampler_linear_clamp;
            SamplerComparisonState sampler_comparison_linear_clamp1;
            SamplerState sampler_DetailAlbedo;
            SamplerState sampler_DetailNormal;
            SamplerState sampler_MainTex;
            SamplerState sampler_EmissionMap;
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_BumpMap;
            SamplerState sampler_MetallicGlossMap;
            SamplerState sampler_DetailMask;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _MetallicGlossMap;
            Texture2D _OcclusionMap;
            Texture2D _EmissionMap;
            Texture2D _DetailMask;
            Texture2D _DetailAlbedo;
            Texture2D _DetailNormal;
            Texture3D t8;
            Texture2D t9;
            struct program33Input
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
            struct program33Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float3 texcoord7 : TEXCOORD7;
                float4 color0 : COLOR0;
                float4 texcoord8 : TEXCOORD8;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program56Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float3 texcoord7 : TEXCOORD7;
                float4 color0 : COLOR0;
                float4 texcoord8 : TEXCOORD8;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program56Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program33Output vert(program33Input i)
            {
                program33Output o = (program33Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[17].xyxx, cb0_values[17].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[18].xxxy, cb0_values[18].zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, cb0_values[19].xyxx, cb0_values[19].zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, cb0_values[20].xxxy, cb0_values[20].zzzw)).zw;
                o.texcoord2.xy = (mad(i.texcoord0.xyxx, cb0_values[21].xyxx, cb0_values[21].zwzz)).xy;
                o.texcoord2.zw = (mad(i.texcoord0.xxxy, cb0_values[22].xxxy, cb0_values[22].zzzw)).zw;
                o.texcoord3.xy = (mad(i.texcoord0.xyxx, cb0_values[23].xyxx, cb0_values[23].zwzz)).xy;
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                float3 unitWorldNormal_xyz_3 = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_6 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_6.xxxx * (mad(unitWorldNormal_xyz_3.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_3.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord4.y = r3_xyz_3.x;
                o.texcoord4.x = unitWorldTangent_xyz_7.z;
                o.texcoord4.z = unitWorldNormal_xyz_3.y;
                o.texcoord5.x = unitWorldTangent_xyz_7.x;
                o.texcoord6.x = unitWorldTangent_xyz_7.y;
                o.texcoord5.z = unitWorldNormal_xyz_3.z;
                o.texcoord6.z = unitWorldNormal_xyz_3.x;
                o.texcoord5.y = r3_xyz_3.y;
                o.texcoord6.y = r3_xyz_3.z;
                o.texcoord7.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_4.yyyy * _MetallicGlossMap_ST);
                float4 clipPos_xyzw_5 = mad(_BumpMap_ST, worldPos_xyzw_4.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(_OcclusionMap_ST, worldPos_xyzw_4.zzzz, clipPos_xyzw_5);
                o.texcoord8.xyzw = mad(_EmissionMap_ST, worldPos_xyzw_4.wwww, clipPos_xyzw_6);
                o.texcoord9.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program56Output frag(program56Input i)
            {
                program56Output o = (program56Output)0;
                float3 r0_xyz_1 = ((-i.texcoord7.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord7.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_2 = ((r4_xyzw_1.xyzx * cb0_values[15].xyzx)).xyz;
                float r1_w_3 = (_BumpMap.Sample(sampler_BumpMap, (i.texcoord2.xyxx).xy)).w;
                float3 r5_xyz_1 = (_MetallicGlossMap.Sample(sampler_MetallicGlossMap, (i.texcoord2.zwzz).xy)).xyz;
                float3 r5_xyz_3 = (mad(r1_w_3.xxxx, (mad(r5_xyz_1.xyzx, float4(2, 2, 2, 0), float4(-2, -2, -2, 0))).xyzx, float4(1, 1, 1, 0))).xyz;
                float2 r7_xy_1 = (_OcclusionMap.Sample(sampler_OcclusionMap, (i.texcoord1.xyxx).xy)).xy;
                float3 r8_xyz_1 = (_EmissionMap.Sample(sampler_EmissionMap, (i.texcoord0.zwzz).xy)).xyz;
                float r8_x_2 = (r8_xyz_1.z * r8_xyz_1.x);
                float2 r7_zw_1 = (mad(float4(r8_x_2, r8_x_2, r8_x_2, r8_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r8_xyzw_3 = (r7_zw_1.xyxx * cb0_values[13].xxxx);
                float r8_x_3 = r8_xyzw_3.x;
                float r8_y_2 = r8_xyzw_3.y;
                float r2_w_1 = dot(float4(r8_x_3, r8_y_2, r8_x_3, r8_x_3), float4(r8_x_3, r8_y_2, r8_x_3, r8_x_3));
                float r2_w_2 = min(r2_w_1, 1);
                float r2_w_3 = (-r2_w_2 + 1);
                float r8_z_2 = sqrt(r2_w_3);
                float3 r9_xyz_1 = (_DetailMask.Sample(sampler_DetailMask, (i.texcoord3.xyxx).xy)).xyz;
                float r9_x_2 = (r9_xyz_1.z * r9_xyz_1.x);
                float2 r7_zw_2 = (mad(float4(r9_x_2, r9_x_2, r9_x_2, r9_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r9_xyzw_3 = (r7_zw_2.xyxx * cb0_values[13].xxxx);
                float r9_x_3 = r9_xyzw_3.x;
                float r9_y_2 = r9_xyzw_3.y;
                float r2_w_4 = dot(float4(r9_x_3, r9_y_2, r9_x_3, r9_x_3), float4(r9_x_3, r9_y_2, r9_x_3, r9_x_3));
                float r2_w_5 = min(r2_w_4, 1);
                float r2_w_6 = (-r2_w_5 + 1);
                float r9_z_2 = sqrt(r2_w_6);
                float4 r8_xyzw_4 = mad(float4(r9_x_3, r9_y_2, r9_z_2, r9_x_3), r1_w_3.xxxx, float4(r8_x_3, r8_y_2, r8_z_2, r8_x_3));
                float r8_x_4 = r8_xyzw_4.x;
                float r8_y_3 = r8_xyzw_4.y;
                float r8_z_3 = r8_xyzw_4.z;
                float r1_w_4 = dot(float4(r8_x_4, r8_y_3, r8_z_3, r8_x_4), float4(r8_x_4, r8_y_3, r8_z_3, r8_x_4));
                float r1_w_5 = rsqrt(r1_w_4);
                float4 r8_xyzw_5 = (r1_w_5.xxxx * float4(r8_x_4, r8_y_3, r8_z_3, r8_x_4));
                float r8_x_5 = r8_xyzw_5.x;
                float r8_y_4 = r8_xyzw_5.y;
                float r8_z_4 = r8_xyzw_5.z;
                float r1_w_6 = (r7_xy_1.x * cb0_values[13].y);
                float r2_w_7 = mad(r4_xyzw_1.w, cb0_values[15].w, -cb0_values[14].x);
                float r2_w_8 = (r2_w_7 < 0);
                if (r2_w_8) discard;
                float4 r9_xyzw_4 = (i.texcoord7.yyyy * cb0_values[10].xyzw);
                float4 r9_xyzw_5 = mad(cb0_values[9].xyzw, i.texcoord7.xxxx, r9_xyzw_4);
                float4 r9_xyzw_6 = mad(cb0_values[11].xyzw, i.texcoord7.zzzz, r9_xyzw_5);
                float4 r9_xyzw_7 = (r9_xyzw_6 + cb0_values[12].xyzw);
                float r10_x_1 = cb4_values[9].z;
                float r10_y_1 = cb4_values[10].z;
                float r10_z_1 = cb4_values[11].z;
                float r2_x_2 = dot(viewDir_xyz_1.xyzx, float4(r10_x_1, r10_y_1, r10_z_1, r10_x_1));
                float4 r2_xyzw_2 = (i.texcoord7.xxyz + -cb3_values[25].xxyz);
                float r2_y_2 = r2_xyzw_2.y;
                float r2_z_2 = r2_xyzw_2.z;
                float r2_w_9 = r2_xyzw_2.w;
                float r2_y_3 = dot(float4(r2_y_2, r2_z_2, r2_w_9, r2_y_2), float4(r2_y_2, r2_z_2, r2_w_9, r2_y_2));
                float r2_y_4 = sqrt(r2_y_3);
                float r2_y_5 = (-r2_x_2 + r2_y_4);
                float r2_x_4 = saturate(mad(mad(cb3_values[25].w, r2_y_5, r2_x_2), cb3_values[24].z, cb3_values[24].w));
                float r2_y_6 = (cb5_values[0].x == 1);
                float r10_x_5;
                float r10_y_5;
                float r10_z_5;
                float r10_w_4;
                if (r2_y_6)
                {
                    float r2_y_7 = (cb5_values[0].y == 1);
                    float4 r7_xyzw_2 = (i.texcoord7.yyyy * cb5_values[2].xxyz);
                    float r7_x_2 = r7_xyzw_2.x;
                    float r7_z_3 = r7_xyzw_2.z;
                    float r7_w_3 = r7_xyzw_2.w;
                    float4 r7_xyzw_3 = mad(cb5_values[1].xxyz, i.texcoord7.xxxx, float4(r7_x_2, r7_x_2, r7_z_3, r7_w_3));
                    float r7_x_3 = r7_xyzw_3.x;
                    float r7_z_4 = r7_xyzw_3.z;
                    float r7_w_4 = r7_xyzw_3.w;
                    float4 r7_xyzw_4 = mad(cb5_values[3].xxyz, i.texcoord7.zzzz, float4(r7_x_3, r7_x_3, r7_z_4, r7_w_4));
                    float r7_x_4 = r7_xyzw_4.x;
                    float r7_z_5 = r7_xyzw_4.z;
                    float r7_w_5 = r7_xyzw_4.w;
                    float4 r7_xyzw_5 = (float4(r7_x_4, r7_x_4, r7_z_5, r7_w_5) + cb5_values[4].xxyz);
                    float r7_x_5 = r7_xyzw_5.x;
                    float r7_z_6 = r7_xyzw_5.z;
                    float r7_w_6 = r7_xyzw_5.w;
                    float4 r2_xyzw_8 = (r2_y_7.xxxx ? float4(r7_x_5, r7_x_5, r7_z_6, r7_w_6) : i.texcoord7.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float r2_w_10 = r2_xyzw_8.w;
                    float4 r2_xyzw_9 = (float4(r2_y_8, r2_y_8, r2_z_3, r2_w_10) + -cb5_values[6].xxyz);
                    float r2_y_9 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float r2_w_11 = r2_xyzw_9.w;
                    float4 r10_xyzw_3 = (float4(r2_y_9, r2_y_9, r2_z_4, r2_w_11) * cb5_values[5].xxyz);
                    float r10_y_3 = r10_xyzw_3.y;
                    float r10_z_3 = r10_xyzw_3.z;
                    float r10_w_2 = r10_xyzw_3.w;
                    float r2_y_10 = mad(r10_y_3, 0.25, 0.75);
                    float r2_z_5 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r10_x_3 = max(r2_z_5, r2_y_10);
                    float4 r10_xyzw_4 = t8.Sample(sampler_linear_clamp, (float4(r10_x_3, r10_z_3, r10_w_2, r10_x_3)).xyz);
                    r10_x_5 = r10_xyzw_4.x;
                    r10_y_5 = r10_xyzw_4.y;
                    r10_z_5 = r10_xyzw_4.z;
                    r10_w_4 = r10_xyzw_4.w;
                }
                else
                {
                    float4 r10_xyzw_2 = float4(1, 1, 1, 1);
                    r10_x_5 = r10_xyzw_2.x;
                    r10_y_5 = r10_xyzw_2.y;
                    r10_z_5 = r10_xyzw_2.z;
                    r10_w_4 = r10_xyzw_2.w;
                }
                float r2_y_12 = saturate(dot(float4(r10_x_5, r10_y_5, r10_z_5, r10_w_4), unity_OcclusionMaskSelector));
                float r2_z_7 = (r2_x_4 < 0.99);
                float r2_z_15;
                if (r2_z_7)
                {
                    float4 r10_xyzw_6 = (i.texcoord7.yyyy * cb3_values[9].xyzw);
                    float4 r10_xyzw_7 = mad(cb3_values[8].xyzw, i.texcoord7.xxxx, r10_xyzw_6);
                    float4 r10_xyzw_8 = mad(cb3_values[10].xyzw, i.texcoord7.zzzz, r10_xyzw_7);
                    float4 r10_xyzw_9 = (r10_xyzw_8 + cb3_values[11].xyzw);
                    float4 r7_xyzw_7 = (r10_xyzw_9.xxyz / r10_xyzw_9.wwww);
                    float r7_x_7 = r7_xyzw_7.x;
                    float r7_z_8 = r7_xyzw_7.z;
                    float r7_w_8 = r7_xyzw_7.w;
                    float4 r2_xyzw_9 = mad(float4(r7_x_7, r7_x_7, r7_x_7, r7_z_8), cb0_values[8].zzzw, float4(0, 0, 0.5, 0.5));
                    float r2_z_9 = r2_xyzw_9.z;
                    float r2_w_13 = r2_xyzw_9.w;
                    float4 r2_xyzw_10 = floor(float4(r2_z_9, r2_z_9, r2_z_9, r2_w_13));
                    float r2_z_10 = r2_xyzw_10.z;
                    float r2_w_14 = r2_xyzw_10.w;
                    float4 r7_xyzw_8 = mad(float4(r7_x_7, r7_x_7, r7_z_8, r7_x_7), cb0_values[8].zzwz, -float4(r2_z_10, r2_z_10, r2_w_14, r2_z_10));
                    float r7_x_8 = r7_xyzw_8.x;
                    float r7_z_9 = r7_xyzw_8.z;
                    float4 r10_xyzw_10 = (float4(r7_x_8, r7_x_8, r7_z_9, r7_z_9) + float4(0.5, 1, 0.5, 1));
                    float2 r11_xw_1 = ((r10_xyzw_10.xxxz * r10_xyzw_10.xxxz)).xw;
                    float2 r10_xz_11 = (mad(r11_xw_1.xxyx, float4(0.5, 0, 0.5, 0), -float4(r7_x_8, r7_x_8, r7_z_9, r7_x_8))).xz;
                    float2 r12_zw_1 = (min(float4(r7_x_8, r7_x_8, r7_x_8, r7_z_9), float4(0, 0, 0, 0))).zw;
                    float2 r12_xy_2 = (mad(-r12_zw_1.xyxx, r12_zw_1.xyxx, ((-float4(r7_x_8, r7_z_9, r7_x_8, r7_x_8) + float4(1, 1, 0, 0))).xyxx)).xy;
                    float4 r7_xyzw_9 = max(float4(r7_x_8, r7_x_8, r7_z_9, r7_x_8), float4(0, 0, 0, 0));
                    float r7_x_9 = r7_xyzw_9.x;
                    float r7_z_10 = r7_xyzw_9.z;
                    float4 r7_xyzw_10 = mad(-float4(r7_x_9, r7_x_9, r7_z_10, r7_x_9), float4(r7_x_9, r7_x_9, r7_z_10, r7_x_9), r10_xyzw_10.yywy);
                    float r7_x_10 = r7_xyzw_10.x;
                    float r7_z_11 = r7_xyzw_10.z;
                    float r13_x_1 = r10_xz_11.x;
                    float r13_y_1 = r12_xy_2.x;
                    float r13_z_1 = r7_x_10;
                    float r13_w_1 = r11_xw_1.x;
                    float4 r13_xyzw_2 = (float4(r13_x_1, r13_y_1, r13_z_1, r13_w_1) * float4(0.44444, 0.44444, 0.44444, 0.22222));
                    float r11_x_2 = r10_xz_11.y;
                    float r11_y_1 = r12_xy_2.y;
                    float r11_z_1 = r7_z_11;
                    float4 r10_xyzw_12 = (float4(r11_x_2, r11_y_1, r11_z_1, r11_xw_1.y) * float4(0.44444, 0.44444, 0.44444, 0.22222));
                    float4 r11_xyzw_3 = (r13_xyzw_2.ywyw + r13_xyzw_2.xzxz);
                    float4 r12_xyzw_3 = (r10_xyzw_12.yyww + r10_xyzw_12.xxzz);
                    float4 r7_xyzw_11 = (r13_xyzw_2.yywy / r11_xyzw_3.zzwz);
                    float r7_x_11 = r7_xyzw_11.x;
                    float r7_z_12 = r7_xyzw_11.z;
                    float4 r7_xyzw_12 = (float4(r7_x_11, r7_x_11, r7_z_12, r7_x_11) + float4(-1.5, 0, 0.5, 0));
                    float r7_x_12 = r7_xyzw_12.x;
                    float r7_z_13 = r7_xyzw_12.z;
                    float4 r10_xyzw_13 = (r10_xyzw_12.ywyy / r12_xyzw_3.ywyy);
                    float r10_x_13 = r10_xyzw_13.x;
                    float r10_y_12 = r10_xyzw_13.y;
                    float4 r10_xyzw_14 = (float4(r10_x_13, r10_y_12, r10_x_13, r10_x_13) + float4(-1.5, 0.5, 0, 0));
                    float r10_x_14 = r10_xyzw_14.x;
                    float r10_y_13 = r10_xyzw_14.y;
                    float2 r13_xy_3 = ((float4(r7_x_12, r7_z_13, r7_x_12, r7_x_12) * cb0_values[8].xxxx)).xy;
                    float2 r13_zw_3 = ((float4(r10_x_14, r10_x_14, r10_x_14, r10_y_13) * cb0_values[8].yyyy)).zw;
                    float4 r10_xyzw_15 = (r11_xyzw_3 * r12_xyzw_3);
                    float4 r11_xyzw_4 = mad(float4(r2_z_10, r2_w_14, r2_z_10, r2_w_14), cb0_values[8].xyxy, float4(r13_xy_3.x, r13_zw_3.x, r13_xy_3.y, r13_zw_3.x));
                    float r3_w_1 = t9.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r11_xyzw_4.xyxx).xy, r7_w_8);
                    float r4_w_2 = t9.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r11_xyzw_4.zwzz).xy, r7_w_8);
                    float r4_w_3 = (r4_w_2 * r10_xyzw_15.y);
                    float r3_w_2 = mad(r10_xyzw_15.x, r3_w_1, r4_w_3);
                    float4 r11_xyzw_5 = mad(float4(r2_z_10, r2_w_14, r2_z_10, r2_w_14), cb0_values[8].xyxy, float4(r13_xy_3.x, r13_zw_3.y, r13_xy_3.y, r13_zw_3.y));
                    float r2_z_11 = t9.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r11_xyzw_5.xyxx).xy, r7_w_8);
                    float r2_z_12 = mad(r10_xyzw_15.z, r2_z_11, r3_w_2);
                    float r2_w_15 = t9.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r11_xyzw_5.zwzz).xy, r7_w_8);
                    float r2_z_13 = mad(r10_xyzw_15.w, r2_w_15, r2_z_12);
                    float r2_w_16 = (-cb3_values[24].x + 1);
                    float r2_z_14 = mad(r2_z_13, r2_w_16, cb3_values[24].x);
                    r2_z_15 = r2_z_14;
                }
                else
                {
                    float r2_z_8 = 1;
                    r2_z_15 = r2_z_8;
                }
                float r2_y_13 = (-r2_z_15 + r2_y_12);
                float r2_y_14 = (0 < r9_xyzw_7.z);
                float r2_y_15 = asfloat(asint(r2_y_14) & asint(1065353216));
                float4 r2_xyzw_16 = (r9_xyzw_7.xxxy / r9_xyzw_7.wwww);
                float r2_z_16 = r2_xyzw_16.z;
                float r2_w_18 = r2_xyzw_16.w;
                float4 r2_xyzw_17 = (float4(r2_z_16, r2_z_16, r2_z_16, r2_w_18) + float4(0, 0, 0.5, 0.5));
                float r2_z_17 = r2_xyzw_17.z;
                float r2_w_19 = r2_xyzw_17.w;
                float r2_z_18 = (_DetailAlbedo.Sample(sampler_DetailAlbedo, (float4(r2_z_17, r2_w_19, r2_z_17, r2_z_17)).xy)).z;
                float r2_y_16 = (r2_z_18 * r2_y_15);
                float r2_z_19 = dot(r9_xyzw_7.xyzx, r9_xyzw_7.xyzx);
                float r2_z_20 = (_DetailNormal.Sample(sampler_DetailNormal, (r2_z_19.xxxx).xy)).z;
                float r2_y_17 = (r2_z_20 * r2_y_16);
                float r9_x_8 = dot(i.texcoord4.xyzx, float4(r8_x_5, r8_y_4, r8_z_4, r8_x_5));
                float r9_y_7 = dot(i.texcoord5.xyzx, float4(r8_x_5, r8_y_4, r8_z_4, r8_x_5));
                float r9_z_7 = dot(i.texcoord6.xyzx, float4(r8_x_5, r8_y_4, r8_z_4, r8_x_5));
                float r2_y_18 = dot(float4(r9_x_8, r9_y_7, r9_z_7, r9_x_8), float4(r9_x_8, r9_y_7, r9_z_7, r9_x_8));
                float r2_y_19 = rsqrt(r2_y_18);
                float4 r2_xyzw_20 = (r2_y_19.xxxx * float4(r9_x_8, r9_x_8, r9_y_7, r9_z_7));
                float r2_y_20 = r2_xyzw_20.y;
                float r2_z_21 = r2_xyzw_20.z;
                float r2_w_20 = r2_xyzw_20.w;
                float4 r7_xyzw_14 = (((mad(r2_x_4, r2_y_13, r2_z_15) * r2_y_17)).xxxx * _LightColor0.xxyz);
                float r7_x_14 = r7_xyzw_14.x;
                float r7_z_15 = r7_xyzw_14.z;
                float r7_w_10 = r7_xyzw_14.w;
                float3 r4_xyz_4 = (mad(r1_w_6.xxxx, (mad(r4_xyz_2.xyzx, r5_xyz_3.xyzx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_7 = mad(-r1_w_6, 0.96, 0.96);
                float r1_w_8 = mad(-r7_xy_1.y, cb0_values[13].z, 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r2_y_20, r2_z_21, r2_w_20, r2_y_20), unitViewDir_xyz_1.xyzx);
                float r2_x_7 = saturate(dot(float4(r2_y_20, r2_z_21, r2_w_20, r2_y_20), r1_xyz_1.xyzx));
                float r2_y_21 = saturate(dot(float4(r2_y_20, r2_z_21, r2_w_20, r2_y_20), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_8.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_x_7 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_8 * r1_w_8);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(r0_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * mad(r2_x_7, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_x_7, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r2_y_21, r0_z_9, -r2_y_21), r2_y_21, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_x_7.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r7_x_14, r7_z_15, r7_w_10, r7_x_14));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r7_x_14, r7_x_14, r7_z_15, r7_w_10) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_9 = (r0_x_5 * r0_x_5);
                float r1_w_10 = (r1_w_9 * r1_w_9);
                float4 r2_xyzw_8 = (-r4_xyz_4.xyzx + float4(1, 1, 1, 0));
                float r2_x_8 = r2_xyzw_8.x;
                float r2_y_22 = r2_xyzw_8.y;
                float r2_z_22 = r2_xyzw_8.z;
                float4 r2_xyzw_9 = mad(float4(r2_x_8, r2_y_22, r2_z_22, r2_x_8), ((r0_x_5 * r1_w_10)).xxxx, r4_xyz_4.xyzx);
                float r2_x_9 = r2_xyzw_9.x;
                float r2_y_23 = r2_xyzw_9.y;
                float r2_z_23 = r2_xyzw_9.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_9, r2_y_23, r2_z_23, r2_x_9));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_7.xxxx * ((r4_xyz_2.xyzx * r5_xyz_3.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float4 r1_xyzw_12 = mad(float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8), i.color0.xyzx, -float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8));
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_6 = r1_xyzw_12.y;
                float r1_z_3 = r1_xyzw_12.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_12, r1_y_6, r1_z_3, r1_x_12), float4(0.1, 0.1, 0.1, 0), float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "PerformanceChecks"="False" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0;
                float _BumpScale;
                float _Metallic;
                float _Glossiness;
                float _OcclusionStrength;
                float _Cutoff;
                float4 _Color;
                float4 _EmissionColor;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 _MetallicGlossMap_ST;
                float4 _OcclusionMap_ST;
                float4 _EmissionMap_ST;
                float4 _DetailMask_ST;
                float4 _DetailAlbedo_ST;
                float4 _DetailNormal_ST;
                float4 cb0_values[19];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0 : packoffset(c0);
                float4x4 unity_MatrixVP : packoffset(c17);
                float4 unity_OcclusionMaskSelector : packoffset(c46);
            };
            cbuffer _UnityProbeVolumeCB_b3
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
            SamplerState sampler_linear_clamp;
            SamplerComparisonState sampler_comparison_linear_clamp1;
            SamplerState sampler_DetailAlbedo;
            SamplerState sampler_DetailNormal;
            SamplerState sampler_MainTex;
            SamplerState sampler_EmissionMap;
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_BumpMap;
            SamplerState sampler_MetallicGlossMap;
            SamplerState sampler_DetailMask;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _MetallicGlossMap;
            Texture2D _OcclusionMap;
            Texture2D _EmissionMap;
            Texture2D _DetailMask;
            Texture2D _DetailAlbedo;
            Texture2D _DetailNormal;
            Texture3D t8;
            Texture2D t9;
            struct program32Input
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
            struct program32Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float3 texcoord7 : TEXCOORD7;
                float4 color0 : COLOR0;
                float4 texcoord8 : TEXCOORD8;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program55Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float3 texcoord7 : TEXCOORD7;
                float4 color0 : COLOR0;
                float4 texcoord8 : TEXCOORD8;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program55Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program32Output vert(program32Input i)
            {
                program32Output o = (program32Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _EmissionMap_ST.xyxx, _EmissionMap_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _DetailMask_ST.xxxy, _DetailMask_ST.zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _DetailAlbedo_ST.xyxx, _DetailAlbedo_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _DetailNormal_ST.xxxy, _DetailNormal_ST.zzzw)).zw;
                o.texcoord2.xy = (mad(i.texcoord0.xyxx, cb0_values[16].xyxx, cb0_values[16].zwzz)).xy;
                o.texcoord2.zw = (mad(i.texcoord0.xxxy, cb0_values[17].xxxy, cb0_values[17].zzzw)).zw;
                o.texcoord3.xy = (mad(i.texcoord0.xyxx, cb0_values[18].xyxx, cb0_values[18].zwzz)).xy;
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                float3 unitWorldNormal_xyz_3 = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_6 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_6.xxxx * (mad(unitWorldNormal_xyz_3.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_3.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord4.y = r3_xyz_3.x;
                o.texcoord4.x = unitWorldTangent_xyz_7.z;
                o.texcoord4.z = unitWorldNormal_xyz_3.y;
                o.texcoord5.x = unitWorldTangent_xyz_7.x;
                o.texcoord6.x = unitWorldTangent_xyz_7.y;
                o.texcoord5.z = unitWorldNormal_xyz_3.z;
                o.texcoord6.z = unitWorldNormal_xyz_3.x;
                o.texcoord5.y = r3_xyz_3.y;
                o.texcoord6.y = r3_xyz_3.z;
                o.texcoord7.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_4.yyyy * cb0_values[5].xyzw);
                float4 clipPos_xyzw_5 = mad(cb0_values[4].xyzw, worldPos_xyzw_4.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(_Color, worldPos_xyzw_4.zzzz, clipPos_xyzw_5);
                o.texcoord8.xyzw = mad(_EmissionColor, worldPos_xyzw_4.wwww, clipPos_xyzw_6);
                o.texcoord9.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program55Output frag(program55Input i)
            {
                program55Output o = (program55Output)0;
                float3 r0_xyz_1 = ((-i.texcoord7.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord7.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_2 = ((r4_xyzw_1.xyzx * cb0_values[10].xyzx)).xyz;
                float r1_w_3 = (_BumpMap.Sample(sampler_BumpMap, (i.texcoord2.xyxx).xy)).w;
                float3 r5_xyz_1 = (_MetallicGlossMap.Sample(sampler_MetallicGlossMap, (i.texcoord2.zwzz).xy)).xyz;
                float3 r5_xyz_3 = (mad(r1_w_3.xxxx, (mad(r5_xyz_1.xyzx, float4(2, 2, 2, 0), float4(-2, -2, -2, 0))).xyzx, float4(1, 1, 1, 0))).xyz;
                float2 r7_xy_1 = (_OcclusionMap.Sample(sampler_OcclusionMap, (i.texcoord1.xyxx).xy)).xy;
                float3 r8_xyz_1 = (_EmissionMap.Sample(sampler_EmissionMap, (i.texcoord0.zwzz).xy)).xyz;
                float r8_x_2 = (r8_xyz_1.z * r8_xyz_1.x);
                float2 r7_zw_1 = (mad(float4(r8_x_2, r8_x_2, r8_x_2, r8_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r8_xyzw_3 = (r7_zw_1.xyxx * cb0_values[8].xxxx);
                float r8_x_3 = r8_xyzw_3.x;
                float r8_y_2 = r8_xyzw_3.y;
                float r2_w_1 = dot(float4(r8_x_3, r8_y_2, r8_x_3, r8_x_3), float4(r8_x_3, r8_y_2, r8_x_3, r8_x_3));
                float r2_w_2 = min(r2_w_1, 1);
                float r2_w_3 = (-r2_w_2 + 1);
                float r8_z_2 = sqrt(r2_w_3);
                float3 r9_xyz_1 = (_DetailMask.Sample(sampler_DetailMask, (i.texcoord3.xyxx).xy)).xyz;
                float r9_x_2 = (r9_xyz_1.z * r9_xyz_1.x);
                float2 r7_zw_2 = (mad(float4(r9_x_2, r9_x_2, r9_x_2, r9_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r9_xyzw_3 = (r7_zw_2.xyxx * cb0_values[8].xxxx);
                float r9_x_3 = r9_xyzw_3.x;
                float r9_y_2 = r9_xyzw_3.y;
                float r2_w_4 = dot(float4(r9_x_3, r9_y_2, r9_x_3, r9_x_3), float4(r9_x_3, r9_y_2, r9_x_3, r9_x_3));
                float r2_w_5 = min(r2_w_4, 1);
                float r2_w_6 = (-r2_w_5 + 1);
                float r9_z_2 = sqrt(r2_w_6);
                float4 r8_xyzw_4 = mad(float4(r9_x_3, r9_y_2, r9_z_2, r9_x_3), r1_w_3.xxxx, float4(r8_x_3, r8_y_2, r8_z_2, r8_x_3));
                float r8_x_4 = r8_xyzw_4.x;
                float r8_y_3 = r8_xyzw_4.y;
                float r8_z_3 = r8_xyzw_4.z;
                float r1_w_4 = dot(float4(r8_x_4, r8_y_3, r8_z_3, r8_x_4), float4(r8_x_4, r8_y_3, r8_z_3, r8_x_4));
                float r1_w_5 = rsqrt(r1_w_4);
                float4 r8_xyzw_5 = (r1_w_5.xxxx * float4(r8_x_4, r8_y_3, r8_z_3, r8_x_4));
                float r8_x_5 = r8_xyzw_5.x;
                float r8_y_4 = r8_xyzw_5.y;
                float r8_z_4 = r8_xyzw_5.z;
                float r1_w_6 = (r7_xy_1.x * cb0_values[8].y);
                float r2_w_7 = mad(r4_xyzw_1.w, cb0_values[10].w, -cb0_values[9].x);
                float r2_w_8 = (r2_w_7 < 0);
                if (r2_w_8) discard;
                float4 r9_xyzw_4 = (i.texcoord7.yyyy * cb0_values[5].xyzw);
                float4 r9_xyzw_5 = mad(cb0_values[4].xyzw, i.texcoord7.xxxx, r9_xyzw_4);
                float4 r9_xyzw_6 = mad(cb0_values[6].xyzw, i.texcoord7.zzzz, r9_xyzw_5);
                float4 r9_xyzw_7 = (r9_xyzw_6 + cb0_values[7].xyzw);
                float r10_x_1 = cb4_values[9].z;
                float r10_y_1 = cb4_values[10].z;
                float r10_z_1 = cb4_values[11].z;
                float r2_x_2 = dot(viewDir_xyz_1.xyzx, float4(r10_x_1, r10_y_1, r10_z_1, r10_x_1));
                float4 r2_xyzw_2 = (i.texcoord7.xxyz + -cb3_values[25].xxyz);
                float r2_y_2 = r2_xyzw_2.y;
                float r2_z_2 = r2_xyzw_2.z;
                float r2_w_9 = r2_xyzw_2.w;
                float r2_y_3 = dot(float4(r2_y_2, r2_z_2, r2_w_9, r2_y_2), float4(r2_y_2, r2_z_2, r2_w_9, r2_y_2));
                float r2_y_4 = sqrt(r2_y_3);
                float r2_y_5 = (-r2_x_2 + r2_y_4);
                float r2_y_6 = (cb5_values[0].x == 1);
                float r10_x_5;
                float r10_y_5;
                float r10_z_5;
                float r10_w_4;
                if (r2_y_6)
                {
                    float r2_y_7 = (cb5_values[0].y == 1);
                    float4 r7_xyzw_2 = (i.texcoord7.yyyy * cb5_values[2].xxyz);
                    float r7_x_2 = r7_xyzw_2.x;
                    float r7_z_3 = r7_xyzw_2.z;
                    float r7_w_3 = r7_xyzw_2.w;
                    float4 r7_xyzw_3 = mad(cb5_values[1].xxyz, i.texcoord7.xxxx, float4(r7_x_2, r7_x_2, r7_z_3, r7_w_3));
                    float r7_x_3 = r7_xyzw_3.x;
                    float r7_z_4 = r7_xyzw_3.z;
                    float r7_w_4 = r7_xyzw_3.w;
                    float4 r7_xyzw_4 = mad(cb5_values[3].xxyz, i.texcoord7.zzzz, float4(r7_x_3, r7_x_3, r7_z_4, r7_w_4));
                    float r7_x_4 = r7_xyzw_4.x;
                    float r7_z_5 = r7_xyzw_4.z;
                    float r7_w_5 = r7_xyzw_4.w;
                    float4 r7_xyzw_5 = (float4(r7_x_4, r7_x_4, r7_z_5, r7_w_5) + cb5_values[4].xxyz);
                    float r7_x_5 = r7_xyzw_5.x;
                    float r7_z_6 = r7_xyzw_5.z;
                    float r7_w_6 = r7_xyzw_5.w;
                    float4 r2_xyzw_8 = (r2_y_7.xxxx ? float4(r7_x_5, r7_x_5, r7_z_6, r7_w_6) : i.texcoord7.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float r2_w_10 = r2_xyzw_8.w;
                    float4 r2_xyzw_9 = (float4(r2_y_8, r2_y_8, r2_z_3, r2_w_10) + -cb5_values[6].xxyz);
                    float r2_y_9 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float r2_w_11 = r2_xyzw_9.w;
                    float4 r10_xyzw_3 = (float4(r2_y_9, r2_y_9, r2_z_4, r2_w_11) * cb5_values[5].xxyz);
                    float r10_y_3 = r10_xyzw_3.y;
                    float r10_z_3 = r10_xyzw_3.z;
                    float r10_w_2 = r10_xyzw_3.w;
                    float r2_y_10 = mad(r10_y_3, 0.25, 0.75);
                    float r2_z_5 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r10_x_3 = max(r2_z_5, r2_y_10);
                    float4 r10_xyzw_4 = t8.Sample(sampler_linear_clamp, (float4(r10_x_3, r10_z_3, r10_w_2, r10_x_3)).xyz);
                    r10_x_5 = r10_xyzw_4.x;
                    r10_y_5 = r10_xyzw_4.y;
                    r10_z_5 = r10_xyzw_4.z;
                    r10_w_4 = r10_xyzw_4.w;
                }
                else
                {
                    float4 r10_xyzw_2 = float4(1, 1, 1, 1);
                    r10_x_5 = r10_xyzw_2.x;
                    r10_y_5 = r10_xyzw_2.y;
                    r10_z_5 = r10_xyzw_2.z;
                    r10_w_4 = r10_xyzw_2.w;
                }
                float r2_y_12 = saturate(dot(float4(r10_x_5, r10_y_5, r10_z_5, r10_w_4), unity_OcclusionMaskSelector));
                float4 r10_xyzw_6 = (i.texcoord7.yyyy * cb3_values[9].xyzw);
                float4 r10_xyzw_7 = mad(cb3_values[8].xyzw, i.texcoord7.xxxx, r10_xyzw_6);
                float4 r10_xyzw_8 = mad(cb3_values[10].xyzw, i.texcoord7.zzzz, r10_xyzw_7);
                float4 r10_xyzw_9 = (r10_xyzw_8 + cb3_values[11].xyzw);
                float4 r7_xyzw_7 = (r10_xyzw_9.xxyz / r10_xyzw_9.wwww);
                float r7_x_7 = r7_xyzw_7.x;
                float r7_z_8 = r7_xyzw_7.z;
                float r7_w_8 = r7_xyzw_7.w;
                float r2_z_7 = t9.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r7_x_7, r7_z_8, r7_x_7, r7_x_7)).xy, r7_w_8);
                float r2_w_13 = (-cb3_values[24].x + 1);
                float r2_z_8 = mad(r2_z_7, r2_w_13, cb3_values[24].x);
                float r2_y_13 = (-r2_z_8 + r2_y_12);
                float r2_y_14 = (0 < r9_xyzw_7.z);
                float r2_y_15 = asfloat(asint(r2_y_14) & asint(1065353216));
                float4 r2_xyzw_9 = (r9_xyzw_7.xxxy / r9_xyzw_7.wwww);
                float r2_z_9 = r2_xyzw_9.z;
                float r2_w_14 = r2_xyzw_9.w;
                float4 r2_xyzw_10 = (float4(r2_z_9, r2_z_9, r2_z_9, r2_w_14) + float4(0, 0, 0.5, 0.5));
                float r2_z_10 = r2_xyzw_10.z;
                float r2_w_15 = r2_xyzw_10.w;
                float r2_z_11 = (_DetailAlbedo.Sample(sampler_DetailAlbedo, (float4(r2_z_10, r2_w_15, r2_z_10, r2_z_10)).xy)).z;
                float r2_y_16 = (r2_z_11 * r2_y_15);
                float r2_z_12 = dot(r9_xyzw_7.xyzx, r9_xyzw_7.xyzx);
                float r2_z_13 = (_DetailNormal.Sample(sampler_DetailNormal, (r2_z_12.xxxx).xy)).z;
                float r2_y_17 = (r2_z_13 * r2_y_16);
                float r9_x_8 = dot(i.texcoord4.xyzx, float4(r8_x_5, r8_y_4, r8_z_4, r8_x_5));
                float r9_y_7 = dot(i.texcoord5.xyzx, float4(r8_x_5, r8_y_4, r8_z_4, r8_x_5));
                float r9_z_7 = dot(i.texcoord6.xyzx, float4(r8_x_5, r8_y_4, r8_z_4, r8_x_5));
                float r2_y_18 = dot(float4(r9_x_8, r9_y_7, r9_z_7, r9_x_8), float4(r9_x_8, r9_y_7, r9_z_7, r9_x_8));
                float r2_y_19 = rsqrt(r2_y_18);
                float4 r2_xyzw_20 = (r2_y_19.xxxx * float4(r9_x_8, r9_x_8, r9_y_7, r9_z_7));
                float r2_y_20 = r2_xyzw_20.y;
                float r2_z_14 = r2_xyzw_20.z;
                float r2_w_16 = r2_xyzw_20.w;
                float4 r7_xyzw_8 = (((mad(saturate(mad(mad(cb3_values[25].w, r2_y_5, r2_x_2), cb3_values[24].z, cb3_values[24].w)), r2_y_13, r2_z_8) * r2_y_17)).xxxx * _LightColor0.xxyz);
                float r7_x_8 = r7_xyzw_8.x;
                float r7_z_9 = r7_xyzw_8.z;
                float r7_w_9 = r7_xyzw_8.w;
                float3 r4_xyz_4 = (mad(r1_w_6.xxxx, (mad(r4_xyz_2.xyzx, r5_xyz_3.xyzx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_7 = mad(-r1_w_6, 0.96, 0.96);
                float r1_w_8 = mad(-r7_xy_1.y, cb0_values[8].z, 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r2_y_20, r2_z_14, r2_w_16, r2_y_20), unitViewDir_xyz_1.xyzx);
                float r2_x_7 = saturate(dot(float4(r2_y_20, r2_z_14, r2_w_16, r2_y_20), r1_xyz_1.xyzx));
                float r2_y_21 = saturate(dot(float4(r2_y_20, r2_z_14, r2_w_16, r2_y_20), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_8.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_x_7 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_8 * r1_w_8);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(r0_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * mad(r2_x_7, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_x_7, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r2_y_21, r0_z_9, -r2_y_21), r2_y_21, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_x_7.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r7_x_8, r7_z_9, r7_w_9, r7_x_8));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r7_x_8, r7_x_8, r7_z_9, r7_w_9) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_9 = (r0_x_5 * r0_x_5);
                float r1_w_10 = (r1_w_9 * r1_w_9);
                float4 r2_xyzw_8 = (-r4_xyz_4.xyzx + float4(1, 1, 1, 0));
                float r2_x_8 = r2_xyzw_8.x;
                float r2_y_22 = r2_xyzw_8.y;
                float r2_z_15 = r2_xyzw_8.z;
                float r2_x_9 = (mad(float4(r2_x_8, r2_y_22, r2_z_15, r2_x_8), ((r0_x_5 * r1_w_10)).xxxx, r4_xyz_4.xyzx)).x;
                float4 r2_xyzw_23 = mad(float4(r2_x_8, r2_y_22, r2_z_15, r2_x_8), ((r0_x_5 * r1_w_10)).xxxx, r4_xyz_4.xyzx);
                float r2_y_23 = r2_xyzw_23.y;
                float r2_z_16 = r2_xyzw_23.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_9, r2_y_23, r2_z_16, r2_x_9));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_7.xxxx * ((r4_xyz_2.xyzx * r5_xyz_3.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float4 r1_xyzw_12 = mad(float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8), i.color0.xyzx, -float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8));
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_6 = r1_xyzw_12.y;
                float r1_z_3 = r1_xyzw_12.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_12, r1_y_6, r1_z_3, r1_x_12), float4(0.1, 0.1, 0.1, 0), float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "PerformanceChecks"="False" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0;
                float _BumpScale;
                float _Metallic;
                float _Glossiness;
                float _OcclusionStrength;
                float _Cutoff;
                float4 _Color;
                float4 _EmissionColor;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 _MetallicGlossMap_ST;
                float4 _OcclusionMap_ST;
                float4 _EmissionMap_ST;
                float4 _DetailMask_ST;
                float4 _DetailAlbedo_ST;
                float4 _DetailNormal_ST;
                float4 cb0_values[19];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0 : packoffset(c0);
                float4x4 unity_MatrixVP : packoffset(c17);
                float4 unity_OcclusionMaskSelector : packoffset(c46);
            };
            cbuffer _UnityProbeVolumeCB_b3
            {
                float4 unity_ProbeVolumeParams : packoffset(c0);
                float4x4 unity_ProbeVolumeWorldToObject : packoffset(c1);
                float3 unity_ProbeVolumeSizeInv : packoffset(c5);
                float3 unity_ProbeVolumeMin : packoffset(c6);
            };
            SamplerState sampler_DetailNormal;
            SamplerState sampler_DetailAlbedo;
            SamplerState sampler_MainTex;
            SamplerState sampler_EmissionMap;
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_BumpMap;
            SamplerState sampler_MetallicGlossMap;
            SamplerState sampler_DetailMask;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _MetallicGlossMap;
            Texture2D _OcclusionMap;
            Texture2D _EmissionMap;
            Texture2D _DetailMask;
            Texture2D _DetailAlbedo;
            Texture3D _DetailNormal;
            struct program31Input
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
            struct program31Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float2 texcoord8 : TEXCOORD8;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float3 texcoord7 : TEXCOORD7;
                float4 color0 : COLOR0;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program54Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float2 texcoord8 : TEXCOORD8;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float3 texcoord7 : TEXCOORD7;
                float4 color0 : COLOR0;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program54Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program31Output vert(program31Input i)
            {
                program31Output o = (program31Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _EmissionMap_ST.xyxx, _EmissionMap_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _DetailMask_ST.xxxy, _DetailMask_ST.zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _DetailAlbedo_ST.xyxx, _DetailAlbedo_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _DetailNormal_ST.xxxy, _DetailNormal_ST.zzzw)).zw;
                o.texcoord2.xy = (mad(i.texcoord0.xyxx, cb0_values[16].xyxx, cb0_values[16].zwzz)).xy;
                o.texcoord2.zw = (mad(i.texcoord0.xxxy, cb0_values[17].xxxy, cb0_values[17].zzzw)).zw;
                worldPos_xyzw_2 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                o.texcoord7.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float2 clipPos_xy_4 = ((worldPos_xyzw_2.yyyy * cb0_values[5].xyxx)).xy;
                float2 clipPos_xy_5 = (mad(cb0_values[4].xyxx, worldPos_xyzw_2.xxxx, clipPos_xy_4.xyxx)).xy;
                float2 clipPos_xy_6 = (mad(_Color.xyxx, worldPos_xyzw_2.zzzz, clipPos_xy_5.xyxx)).xy;
                o.texcoord8.xy = (mad(_EmissionColor.xxxy, worldPos_xyzw_2.wwww, clipPos_xy_6.xxxy)).zw;
                o.texcoord3.xy = (mad(i.texcoord0.xyxx, cb0_values[18].xyxx, cb0_values[18].zwzz)).xy;
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_4 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7));
                float r0_w_5 = rsqrt(r0_w_4);
                float4 unitWorldNormal_xyzw_8 = (r0_w_5.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7));
                float unitWorldNormal_x_8 = unitWorldNormal_xyzw_8.x;
                float unitWorldNormal_y_8 = unitWorldNormal_xyzw_8.y;
                float unitWorldNormal_z_5 = unitWorldNormal_xyzw_8.z;
                float3 worldTangent_xyz_3 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_4 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_3.xyzx)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_4.xyzx)).xyz;
                float3 unitWorldTangent_xyz_6 = normalize(worldTangent_xyz_5);
                float r0_w_8 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r2_xyz_6 = ((r0_w_8.xxxx * (mad(float4(unitWorldNormal_z_5, unitWorldNormal_x_8, unitWorldNormal_y_8, unitWorldNormal_z_5), unitWorldTangent_xyz_6.yzxy, ((float4(unitWorldNormal_x_8, unitWorldNormal_y_8, unitWorldNormal_z_5, unitWorldNormal_x_8) * unitWorldTangent_xyz_6.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord4.y = r2_xyz_6.x;
                o.texcoord4.x = unitWorldTangent_xyz_6.z;
                o.texcoord4.z = unitWorldNormal_y_8;
                o.texcoord5.x = unitWorldTangent_xyz_6.x;
                o.texcoord6.x = unitWorldTangent_xyz_6.y;
                o.texcoord5.z = unitWorldNormal_z_5;
                o.texcoord6.z = unitWorldNormal_x_8;
                o.texcoord5.y = r2_xyz_6.y;
                o.texcoord6.y = r2_xyz_6.z;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord9.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program54Output frag(program54Input i)
            {
                program54Output o = (program54Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord7.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_2 = ((r2_xyzw_1.xyzx * cb0_values[10].xyzx)).xyz;
                float r1_w_1 = (_BumpMap.Sample(sampler_BumpMap, (i.texcoord2.xyxx).xy)).w;
                float3 r3_xyz_1 = (_MetallicGlossMap.Sample(sampler_MetallicGlossMap, (i.texcoord2.zwzz).xy)).xyz;
                float3 r3_xyz_3 = (mad(r1_w_1.xxxx, (mad(r3_xyz_1.xyzx, float4(2, 2, 2, 0), float4(-2, -2, -2, 0))).xyzx, float4(1, 1, 1, 0))).xyz;
                float2 r5_xy_1 = (_OcclusionMap.Sample(sampler_OcclusionMap, (i.texcoord1.xyxx).xy)).xy;
                float3 r6_xyz_1 = (_EmissionMap.Sample(sampler_EmissionMap, (i.texcoord0.zwzz).xy)).xyz;
                float r6_x_2 = (r6_xyz_1.z * r6_xyz_1.x);
                float2 r5_zw_1 = (mad(float4(r6_x_2, r6_x_2, r6_x_2, r6_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r6_xyzw_3 = (r5_zw_1.xyxx * cb0_values[8].xxxx);
                float r6_x_3 = r6_xyzw_3.x;
                float r6_y_2 = r6_xyzw_3.y;
                float r3_w_1 = dot(float4(r6_x_3, r6_y_2, r6_x_3, r6_x_3), float4(r6_x_3, r6_y_2, r6_x_3, r6_x_3));
                float r3_w_2 = min(r3_w_1, 1);
                float r3_w_3 = (-r3_w_2 + 1);
                float r6_z_2 = sqrt(r3_w_3);
                float3 r7_xyz_1 = (_DetailMask.Sample(sampler_DetailMask, (i.texcoord3.xyxx).xy)).xyz;
                float r7_x_2 = (r7_xyz_1.z * r7_xyz_1.x);
                float2 r5_zw_2 = (mad(float4(r7_x_2, r7_x_2, r7_x_2, r7_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r7_xyzw_3 = (r5_zw_2.xyxx * cb0_values[8].xxxx);
                float r7_x_3 = r7_xyzw_3.x;
                float r7_y_2 = r7_xyzw_3.y;
                float r3_w_4 = dot(float4(r7_x_3, r7_y_2, r7_x_3, r7_x_3), float4(r7_x_3, r7_y_2, r7_x_3, r7_x_3));
                float r3_w_5 = min(r3_w_4, 1);
                float r3_w_6 = (-r3_w_5 + 1);
                float r7_z_2 = sqrt(r3_w_6);
                float4 r6_xyzw_4 = mad(float4(r7_x_3, r7_y_2, r7_z_2, r7_x_3), r1_w_1.xxxx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r6_x_4 = r6_xyzw_4.x;
                float r6_y_3 = r6_xyzw_4.y;
                float r6_z_3 = r6_xyzw_4.z;
                float r1_w_2 = dot(float4(r6_x_4, r6_y_3, r6_z_3, r6_x_4), float4(r6_x_4, r6_y_3, r6_z_3, r6_x_4));
                float r1_w_3 = rsqrt(r1_w_2);
                float4 r6_xyzw_5 = (r1_w_3.xxxx * float4(r6_x_4, r6_y_3, r6_z_3, r6_x_4));
                float r6_x_5 = r6_xyzw_5.x;
                float r6_y_4 = r6_xyzw_5.y;
                float r6_z_4 = r6_xyzw_5.z;
                float r1_w_4 = (r5_xy_1.x * cb0_values[8].y);
                float r2_w_2 = mad(r2_xyzw_1.w, cb0_values[10].w, -cb0_values[9].x);
                float r2_w_3 = (r2_w_2 < 0);
                if (r2_w_3) discard;
                float4 r5_xyzw_2 = (i.texcoord7.yyyy * cb0_values[5].xxyx);
                float r5_x_2 = r5_xyzw_2.x;
                float r5_z_3 = r5_xyzw_2.z;
                float4 r5_xyzw_3 = mad(cb0_values[4].xxyx, i.texcoord7.xxxx, float4(r5_x_2, r5_x_2, r5_z_3, r5_x_2));
                float r5_x_3 = r5_xyzw_3.x;
                float r5_z_4 = r5_xyzw_3.z;
                float4 r5_xyzw_4 = mad(cb0_values[6].xxyx, i.texcoord7.zzzz, float4(r5_x_3, r5_x_3, r5_z_4, r5_x_3));
                float r5_x_4 = r5_xyzw_4.x;
                float r5_z_5 = r5_xyzw_4.z;
                float4 r5_xyzw_5 = (float4(r5_x_4, r5_x_4, r5_z_5, r5_x_4) + cb0_values[7].xxyx);
                float r5_x_5 = r5_xyzw_5.x;
                float r5_z_6 = r5_xyzw_5.z;
                float r2_w_4 = (unity_ProbeVolumeParams.x == 1);
                float r7_x_13;
                float r7_y_12;
                float r7_z_12;
                float r7_w_4;
                if (r2_w_4)
                {
                    float r2_w_5 = (unity_ProbeVolumeParams.y == 1);
                    float4 r7_xyzw_5 = (i.texcoord7.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx);
                    float r7_x_5 = r7_xyzw_5.x;
                    float r7_y_4 = r7_xyzw_5.y;
                    float r7_z_4 = r7_xyzw_5.z;
                    float4 r7_xyzw_6 = mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord7.xxxx, float4(r7_x_5, r7_y_4, r7_z_4, r7_x_5));
                    float r7_x_6 = r7_xyzw_6.x;
                    float r7_y_5 = r7_xyzw_6.y;
                    float r7_z_5 = r7_xyzw_6.z;
                    float4 r7_xyzw_7 = mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord7.zzzz, float4(r7_x_6, r7_y_5, r7_z_5, r7_x_6));
                    float r7_x_7 = r7_xyzw_7.x;
                    float r7_y_6 = r7_xyzw_7.y;
                    float r7_z_6 = r7_xyzw_7.z;
                    float4 r7_xyzw_8 = (float4(r7_x_7, r7_y_6, r7_z_6, r7_x_7) + unity_ProbeVolumeWorldToObject[3].xyzx);
                    float r7_x_8 = r7_xyzw_8.x;
                    float r7_y_7 = r7_xyzw_8.y;
                    float r7_z_7 = r7_xyzw_8.z;
                    float4 unity_ProbeVolumeParamsSelect_xyzw_9 = (r2_w_5.xxxx ? float4(r7_x_8, r7_y_7, r7_z_7, r7_x_8) : i.texcoord7.xyzx);
                    float unity_ProbeVolumeParamsSelect_x_9 = unity_ProbeVolumeParamsSelect_xyzw_9.x;
                    float unity_ProbeVolumeParamsSelect_y_8 = unity_ProbeVolumeParamsSelect_xyzw_9.y;
                    float unity_ProbeVolumeParamsSelect_z_8 = unity_ProbeVolumeParamsSelect_xyzw_9.z;
                    float4 r7_xyzw_10 = (float4(unity_ProbeVolumeParamsSelect_x_9, unity_ProbeVolumeParamsSelect_y_8, unity_ProbeVolumeParamsSelect_z_8, unity_ProbeVolumeParamsSelect_x_9) + -unity_ProbeVolumeMin.xyzx);
                    float r7_x_10 = r7_xyzw_10.x;
                    float r7_y_9 = r7_xyzw_10.y;
                    float r7_z_9 = r7_xyzw_10.z;
                    float r7_y_10 = ((float4(r7_x_10, r7_x_10, r7_y_9, r7_z_9) * unity_ProbeVolumeSizeInv.xxyz)).y;
                    float r7_z_10 = ((float4(r7_x_10, r7_x_10, r7_y_9, r7_z_9) * unity_ProbeVolumeSizeInv.xxyz)).z;
                    float r7_w_2 = ((float4(r7_x_10, r7_x_10, r7_y_9, r7_z_9) * unity_ProbeVolumeSizeInv.xxyz)).w;
                    float r2_w_6 = mad(r7_y_10, 0.25, 0.75);
                    float r3_w_7 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r7_x_11 = max(r2_w_6, r3_w_7);
                    float4 r7_xyzw_12 = _DetailNormal.Sample(sampler_DetailNormal, (float4(r7_x_11, r7_z_10, r7_w_2, r7_x_11)).xyz);
                    r7_x_13 = r7_xyzw_12.x;
                    r7_y_12 = r7_xyzw_12.y;
                    r7_z_12 = r7_xyzw_12.z;
                    r7_w_4 = r7_xyzw_12.w;
                }
                else
                {
                    float4 r7_xyzw_4 = float4(1, 1, 1, 1);
                    r7_x_13 = r7_xyzw_4.x;
                    r7_y_12 = r7_xyzw_4.y;
                    r7_z_12 = r7_xyzw_4.z;
                    r7_w_4 = r7_xyzw_4.w;
                }
                float r2_w_8 = saturate(dot(float4(r7_x_13, r7_y_12, r7_z_12, r7_w_4), unity_OcclusionMaskSelector));
                float r3_w_9 = (_DetailAlbedo.Sample(sampler_DetailAlbedo, (float4(r5_x_5, r5_z_6, r5_x_5, r5_x_5)).xy)).w;
                float r2_w_9 = (r2_w_8 * r3_w_9);
                float r7_x_14 = dot(i.texcoord4.xyzx, float4(r6_x_5, r6_y_4, r6_z_4, r6_x_5));
                float r7_y_13 = dot(i.texcoord5.xyzx, float4(r6_x_5, r6_y_4, r6_z_4, r6_x_5));
                float r7_z_13 = dot(i.texcoord6.xyzx, float4(r6_x_5, r6_y_4, r6_z_4, r6_x_5));
                float r3_w_10 = dot(float4(r7_x_14, r7_y_13, r7_z_13, r7_x_14), float4(r7_x_14, r7_y_13, r7_z_13, r7_x_14));
                float r3_w_11 = rsqrt(r3_w_10);
                float4 r5_xyzw_6 = (r3_w_11.xxxx * float4(r7_x_14, r7_x_14, r7_y_13, r7_z_13));
                float r5_x_6 = r5_xyzw_6.x;
                float r5_z_7 = r5_xyzw_6.z;
                float r5_w_3 = r5_xyzw_6.w;
                float4 r6_xyzw_6 = (r2_w_9.xxxx * _LightColor0.xyzx);
                float r6_x_6 = r6_xyzw_6.x;
                float r6_y_5 = r6_xyzw_6.y;
                float r6_z_5 = r6_xyzw_6.z;
                float3 r2_xyz_4 = (mad(r1_w_4.xxxx, (mad(r2_xyz_2.xyzx, r3_xyz_3.xyzx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_5 = mad(-r1_w_4, 0.96, 0.96);
                float r1_w_6 = mad(-r5_xy_1.y, cb0_values[8].z, 1);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r5_x_6, r5_z_7, r5_w_3, r5_x_6), unitViewDir_xyz_1.xyzx);
                float r1_x_2 = saturate(dot(float4(r5_x_6, r5_z_7, r5_w_3, r5_x_6), _WorldSpaceLightPos0.xyzx));
                float r1_y_2 = saturate(dot(float4(r5_x_6, r5_z_7, r5_w_3, r5_x_6), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_6.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(r0_w_6) + 1);
                float r2_w_10 = (r1_z_4 * r1_z_4);
                float r2_w_11 = (r2_w_10 * r2_w_10);
                float r1_z_5 = (r1_z_4 * r2_w_11);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_6 * r1_w_6);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_z_6 = (-r0_z_8 + 1);
                float r1_w_7 = mad(abs(r0_w_6), r1_z_6, r0_z_8);
                float r1_z_7 = mad(r1_x_2, r1_z_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * r1_z_7);
                float r0_w_8 = mad(r1_x_2, r1_w_7, r0_w_7);
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
                float4 r0_xyzw_9 = (r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_3 = (r0_y_9.xxxx * float4(r6_x_6, r6_y_5, r6_z_5, r6_x_6));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_5 = r1_xyzw_3.y;
                float r1_z_9 = r1_xyzw_3.z;
                float4 r0_xyzw_10 = (float4(r6_x_6, r6_x_6, r6_y_5, r6_z_5) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_8 = (r0_x_5 * r0_x_5);
                float r1_w_9 = (r1_w_8 * r1_w_8);
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * (mad(((-r2_xyz_4.xyzx + float4(1, 1, 1, 0))).xyzx, ((r0_x_5 * r1_w_9)).xxxx, r2_xyz_4.xyzx)).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_5.xxxx * ((r2_xyz_2.xyzx * r3_xyz_3.xyzx)).xyzx)).xyzx, float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float4 r1_xyzw_4 = mad(float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8), i.color0.xyzx, -float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_6 = r1_xyzw_4.y;
                float r1_z_10 = r1_xyzw_4.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_4, r1_y_6, r1_z_10, r1_x_4), float4(0.1, 0.1, 0.1, 0), float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "PerformanceChecks"="False" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0;
                float _BumpScale;
                float _Metallic;
                float _Glossiness;
                float _OcclusionStrength;
                float _Cutoff;
                float4 _Color;
                float4 _EmissionColor;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 _MetallicGlossMap_ST;
                float4 _OcclusionMap_ST;
                float4 _EmissionMap_ST;
                float4 _DetailMask_ST;
                float4 _DetailAlbedo_ST;
                float4 _DetailNormal_ST;
                float4 cb0_values[19];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0 : packoffset(c0);
                float4x4 unity_MatrixVP : packoffset(c17);
                float4 unity_OcclusionMaskSelector : packoffset(c46);
            };
            cbuffer _UnityProbeVolumeCB_b3
            {
                float4 unity_ProbeVolumeParams : packoffset(c0);
                float4x4 unity_ProbeVolumeWorldToObject : packoffset(c1);
                float3 unity_ProbeVolumeSizeInv : packoffset(c5);
                float3 unity_ProbeVolumeMin : packoffset(c6);
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_DetailNormal;
            SamplerState sampler_DetailAlbedo;
            SamplerState sampler_MainTex;
            SamplerState sampler_EmissionMap;
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_BumpMap;
            SamplerState sampler_MetallicGlossMap;
            SamplerState sampler_DetailMask;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _MetallicGlossMap;
            Texture2D _OcclusionMap;
            Texture2D _EmissionMap;
            Texture2D _DetailMask;
            Texture2D _DetailAlbedo;
            TextureCube _DetailNormal;
            Texture3D t8;
            struct program30Input
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
            struct program30Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float3 texcoord7 : TEXCOORD7;
                float4 color0 : COLOR0;
                float3 texcoord8 : TEXCOORD8;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program53Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float3 texcoord7 : TEXCOORD7;
                float4 color0 : COLOR0;
                float3 texcoord8 : TEXCOORD8;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program53Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program30Output vert(program30Input i)
            {
                program30Output o = (program30Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _EmissionMap_ST.xyxx, _EmissionMap_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _DetailMask_ST.xxxy, _DetailMask_ST.zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _DetailAlbedo_ST.xyxx, _DetailAlbedo_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _DetailNormal_ST.xxxy, _DetailNormal_ST.zzzw)).zw;
                o.texcoord2.xy = (mad(i.texcoord0.xyxx, cb0_values[16].xyxx, cb0_values[16].zwzz)).xy;
                o.texcoord2.zw = (mad(i.texcoord0.xxxy, cb0_values[17].xxxy, cb0_values[17].zzzw)).zw;
                o.texcoord3.xy = (mad(i.texcoord0.xyxx, cb0_values[18].xyxx, cb0_values[18].zwzz)).xy;
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                float3 unitWorldNormal_xyz_3 = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_6 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_6.xxxx * (mad(unitWorldNormal_xyz_3.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_3.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord4.y = r3_xyz_3.x;
                o.texcoord4.x = unitWorldTangent_xyz_7.z;
                o.texcoord4.z = unitWorldNormal_xyz_3.y;
                o.texcoord5.x = unitWorldTangent_xyz_7.x;
                o.texcoord6.x = unitWorldTangent_xyz_7.y;
                o.texcoord5.z = unitWorldNormal_xyz_3.z;
                o.texcoord6.z = unitWorldNormal_xyz_3.x;
                o.texcoord5.y = r3_xyz_3.y;
                o.texcoord6.y = r3_xyz_3.z;
                o.texcoord7.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                float3 clipPos_xyz_4 = ((worldPos_xyzw_4.yyyy * cb0_values[5].xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(_Color.xyzx, worldPos_xyzw_4.zzzz, (mad(cb0_values[4].xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_4.xyzx)).xyzx)).xyz;
                o.texcoord8.xyz = (mad(_EmissionColor.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord9.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program53Output frag(program53Input i)
            {
                program53Output o = (program53Output)0;
                float3 r0_xyz_1 = ((-i.texcoord7.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord7.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_2 = normalize(viewDir_xyz_1);
                float4 r3_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r3_xyz_2 = ((r3_xyzw_1.xyzx * cb0_values[10].xyzx)).xyz;
                float r1_w_3 = (_BumpMap.Sample(sampler_BumpMap, (i.texcoord2.xyxx).xy)).w;
                float3 r4_xyz_1 = (_MetallicGlossMap.Sample(sampler_MetallicGlossMap, (i.texcoord2.zwzz).xy)).xyz;
                float3 r4_xyz_3 = (mad(r1_w_3.xxxx, (mad(r4_xyz_1.xyzx, float4(2, 2, 2, 0), float4(-2, -2, -2, 0))).xyzx, float4(1, 1, 1, 0))).xyz;
                float2 r6_xy_1 = (_OcclusionMap.Sample(sampler_OcclusionMap, (i.texcoord1.xyxx).xy)).xy;
                float3 r7_xyz_1 = (_EmissionMap.Sample(sampler_EmissionMap, (i.texcoord0.zwzz).xy)).xyz;
                float r7_x_2 = (r7_xyz_1.z * r7_xyz_1.x);
                float2 r6_zw_1 = (mad(float4(r7_x_2, r7_x_2, r7_x_2, r7_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r7_xyzw_3 = (r6_zw_1.xyxx * cb0_values[8].xxxx);
                float r7_x_3 = r7_xyzw_3.x;
                float r7_y_2 = r7_xyzw_3.y;
                float r2_w_1 = dot(float4(r7_x_3, r7_y_2, r7_x_3, r7_x_3), float4(r7_x_3, r7_y_2, r7_x_3, r7_x_3));
                float r2_w_2 = min(r2_w_1, 1);
                float r2_w_3 = (-r2_w_2 + 1);
                float r7_z_2 = sqrt(r2_w_3);
                float3 r8_xyz_1 = (_DetailMask.Sample(sampler_DetailMask, (i.texcoord3.xyxx).xy)).xyz;
                float r8_x_2 = (r8_xyz_1.z * r8_xyz_1.x);
                float2 r6_zw_2 = (mad(float4(r8_x_2, r8_x_2, r8_x_2, r8_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r8_xyzw_3 = (r6_zw_2.xyxx * cb0_values[8].xxxx);
                float r8_x_3 = r8_xyzw_3.x;
                float r8_y_2 = r8_xyzw_3.y;
                float r2_w_4 = dot(float4(r8_x_3, r8_y_2, r8_x_3, r8_x_3), float4(r8_x_3, r8_y_2, r8_x_3, r8_x_3));
                float r2_w_5 = min(r2_w_4, 1);
                float r2_w_6 = (-r2_w_5 + 1);
                float r8_z_2 = sqrt(r2_w_6);
                float4 r7_xyzw_4 = mad(float4(r8_x_3, r8_y_2, r8_z_2, r8_x_3), r1_w_3.xxxx, float4(r7_x_3, r7_y_2, r7_z_2, r7_x_3));
                float r7_x_4 = r7_xyzw_4.x;
                float r7_y_3 = r7_xyzw_4.y;
                float r7_z_3 = r7_xyzw_4.z;
                float r1_w_4 = dot(float4(r7_x_4, r7_y_3, r7_z_3, r7_x_4), float4(r7_x_4, r7_y_3, r7_z_3, r7_x_4));
                float r1_w_5 = rsqrt(r1_w_4);
                float4 r7_xyzw_5 = (r1_w_5.xxxx * float4(r7_x_4, r7_y_3, r7_z_3, r7_x_4));
                float r7_x_5 = r7_xyzw_5.x;
                float r7_y_4 = r7_xyzw_5.y;
                float r7_z_4 = r7_xyzw_5.z;
                float r1_w_6 = (r6_xy_1.x * cb0_values[8].y);
                float r2_w_7 = mad(r3_xyzw_1.w, cb0_values[10].w, -cb0_values[9].x);
                float r2_w_8 = (r2_w_7 < 0);
                if (r2_w_8) discard;
                float4 r6_xyzw_2 = (i.texcoord7.yyyy * cb0_values[5].xxyz);
                float r6_x_2 = r6_xyzw_2.x;
                float r6_z_3 = r6_xyzw_2.z;
                float r6_w_3 = r6_xyzw_2.w;
                float4 r6_xyzw_3 = mad(cb0_values[4].xxyz, i.texcoord7.xxxx, float4(r6_x_2, r6_x_2, r6_z_3, r6_w_3));
                float r6_x_3 = r6_xyzw_3.x;
                float r6_z_4 = r6_xyzw_3.z;
                float r6_w_4 = r6_xyzw_3.w;
                float4 r6_xyzw_4 = mad(cb0_values[6].xxyz, i.texcoord7.zzzz, float4(r6_x_3, r6_x_3, r6_z_4, r6_w_4));
                float r6_x_4 = r6_xyzw_4.x;
                float r6_z_5 = r6_xyzw_4.z;
                float r6_w_5 = r6_xyzw_4.w;
                float4 r6_xyzw_5 = (float4(r6_x_4, r6_x_4, r6_z_5, r6_w_5) + cb0_values[7].xxyz);
                float r6_x_5 = r6_xyzw_5.x;
                float r6_z_6 = r6_xyzw_5.z;
                float r6_w_6 = r6_xyzw_5.w;
                float r2_w_9 = (unity_ProbeVolumeParams.x == 1);
                float r8_x_13;
                float r8_y_12;
                float r8_z_12;
                float r8_w_4;
                if (r2_w_9)
                {
                    float r2_w_10 = (unity_ProbeVolumeParams.y == 1);
                    float4 r8_xyzw_5 = (i.texcoord7.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx);
                    float r8_x_5 = r8_xyzw_5.x;
                    float r8_y_4 = r8_xyzw_5.y;
                    float r8_z_4 = r8_xyzw_5.z;
                    float4 r8_xyzw_6 = mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord7.xxxx, float4(r8_x_5, r8_y_4, r8_z_4, r8_x_5));
                    float r8_x_6 = r8_xyzw_6.x;
                    float r8_y_5 = r8_xyzw_6.y;
                    float r8_z_5 = r8_xyzw_6.z;
                    float4 r8_xyzw_7 = mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord7.zzzz, float4(r8_x_6, r8_y_5, r8_z_5, r8_x_6));
                    float r8_x_7 = r8_xyzw_7.x;
                    float r8_y_6 = r8_xyzw_7.y;
                    float r8_z_6 = r8_xyzw_7.z;
                    float4 r8_xyzw_8 = (float4(r8_x_7, r8_y_6, r8_z_6, r8_x_7) + unity_ProbeVolumeWorldToObject[3].xyzx);
                    float r8_x_8 = r8_xyzw_8.x;
                    float r8_y_7 = r8_xyzw_8.y;
                    float r8_z_7 = r8_xyzw_8.z;
                    float4 unity_ProbeVolumeParamsSelect_xyzw_9 = (r2_w_10.xxxx ? float4(r8_x_8, r8_y_7, r8_z_7, r8_x_8) : i.texcoord7.xyzx);
                    float unity_ProbeVolumeParamsSelect_x_9 = unity_ProbeVolumeParamsSelect_xyzw_9.x;
                    float unity_ProbeVolumeParamsSelect_y_8 = unity_ProbeVolumeParamsSelect_xyzw_9.y;
                    float unity_ProbeVolumeParamsSelect_z_8 = unity_ProbeVolumeParamsSelect_xyzw_9.z;
                    float4 r8_xyzw_10 = (float4(unity_ProbeVolumeParamsSelect_x_9, unity_ProbeVolumeParamsSelect_y_8, unity_ProbeVolumeParamsSelect_z_8, unity_ProbeVolumeParamsSelect_x_9) + -unity_ProbeVolumeMin.xyzx);
                    float r8_x_10 = r8_xyzw_10.x;
                    float r8_y_9 = r8_xyzw_10.y;
                    float r8_z_9 = r8_xyzw_10.z;
                    float r8_y_10 = ((float4(r8_x_10, r8_x_10, r8_y_9, r8_z_9) * unity_ProbeVolumeSizeInv.xxyz)).y;
                    float r8_z_10 = ((float4(r8_x_10, r8_x_10, r8_y_9, r8_z_9) * unity_ProbeVolumeSizeInv.xxyz)).z;
                    float r8_w_2 = ((float4(r8_x_10, r8_x_10, r8_y_9, r8_z_9) * unity_ProbeVolumeSizeInv.xxyz)).w;
                    float r2_w_11 = mad(r8_y_10, 0.25, 0.75);
                    float r3_w_2 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r8_x_11 = max(r2_w_11, r3_w_2);
                    float4 r8_xyzw_12 = t8.Sample(sampler_linear_clamp, (float4(r8_x_11, r8_z_10, r8_w_2, r8_x_11)).xyz);
                    r8_x_13 = r8_xyzw_12.x;
                    r8_y_12 = r8_xyzw_12.y;
                    r8_z_12 = r8_xyzw_12.z;
                    r8_w_4 = r8_xyzw_12.w;
                }
                else
                {
                    float4 r8_xyzw_4 = float4(1, 1, 1, 1);
                    r8_x_13 = r8_xyzw_4.x;
                    r8_y_12 = r8_xyzw_4.y;
                    r8_z_12 = r8_xyzw_4.z;
                    r8_w_4 = r8_xyzw_4.w;
                }
                float r2_w_13 = saturate(dot(float4(r8_x_13, r8_y_12, r8_z_12, r8_w_4), unity_OcclusionMaskSelector));
                float r3_w_4 = dot(float4(r6_x_5, r6_z_6, r6_w_6, r6_x_5), float4(r6_x_5, r6_z_6, r6_w_6, r6_x_5));
                float r3_w_5 = (_DetailAlbedo.Sample(sampler_DetailAlbedo, (r3_w_4.xxxx).xy)).w;
                float r4_w_1 = (_DetailNormal.Sample(sampler_DetailNormal, (float4(r6_x_5, r6_z_6, r6_w_6, r6_x_5)).xyz)).w;
                float r3_w_6 = (r3_w_5 * r4_w_1);
                float r2_w_14 = (r2_w_13 * r3_w_6);
                float r8_x_14 = dot(i.texcoord4.xyzx, float4(r7_x_5, r7_y_4, r7_z_4, r7_x_5));
                float r8_y_13 = dot(i.texcoord5.xyzx, float4(r7_x_5, r7_y_4, r7_z_4, r7_x_5));
                float r8_z_13 = dot(i.texcoord6.xyzx, float4(r7_x_5, r7_y_4, r7_z_4, r7_x_5));
                float r3_w_7 = dot(float4(r8_x_14, r8_y_13, r8_z_13, r8_x_14), float4(r8_x_14, r8_y_13, r8_z_13, r8_x_14));
                float r3_w_8 = rsqrt(r3_w_7);
                float4 r6_xyzw_6 = (r3_w_8.xxxx * float4(r8_x_14, r8_x_14, r8_y_13, r8_z_13));
                float r6_x_6 = r6_xyzw_6.x;
                float r6_z_7 = r6_xyzw_6.z;
                float r6_w_7 = r6_xyzw_6.w;
                float4 r7_xyzw_6 = (r2_w_14.xxxx * _LightColor0.xyzx);
                float r7_x_6 = r7_xyzw_6.x;
                float r7_y_5 = r7_xyzw_6.y;
                float r7_z_5 = r7_xyzw_6.z;
                float3 r3_xyz_4 = (mad(r1_w_6.xxxx, (mad(r3_xyz_2.xyzx, r4_xyz_3.xyzx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_7 = mad(-r1_w_6, 0.96, 0.96);
                float r1_w_8 = mad(-r6_xy_1.y, cb0_values[8].z, 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_2.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r6_x_6, r6_z_7, r6_w_7, r6_x_6), unitViewDir_xyz_2.xyzx);
                float r2_x_3 = saturate(dot(float4(r6_x_6, r6_z_7, r6_w_7, r6_x_6), r1_xyz_1.xyzx));
                float r2_y_3 = saturate(dot(float4(r6_x_6, r6_z_7, r6_w_7, r6_x_6), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_8.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_x_3 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_8 * r1_w_8);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(r0_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * mad(r2_x_3, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_x_3, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r2_y_3, r0_z_9, -r2_y_3), r2_y_3, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_x_3.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r3_xyz_4.xyzx, r3_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r7_x_6, r7_y_5, r7_z_5, r7_x_6));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r7_x_6, r7_x_6, r7_y_5, r7_z_5) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_9 = (r0_x_5 * r0_x_5);
                float r1_w_10 = (r1_w_9 * r1_w_9);
                float4 r2_xyzw_4 = (-r3_xyz_4.xyzx + float4(1, 1, 1, 0));
                float r2_x_4 = r2_xyzw_4.x;
                float r2_y_4 = r2_xyzw_4.y;
                float r2_z_3 = r2_xyzw_4.z;
                float4 r2_xyzw_5 = mad(float4(r2_x_4, r2_y_4, r2_z_3, r2_x_4), ((r0_x_5 * r1_w_10)).xxxx, r3_xyz_4.xyzx);
                float r2_x_5 = r2_xyzw_5.x;
                float r2_y_5 = r2_xyzw_5.y;
                float r2_z_4 = r2_xyzw_5.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_5, r2_y_5, r2_z_4, r2_x_5));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_7.xxxx * ((r3_xyz_2.xyzx * r4_xyz_3.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float4 r1_xyzw_12 = mad(float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8), i.color0.xyzx, -float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8));
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_6 = r1_xyzw_12.y;
                float r1_z_3 = r1_xyzw_12.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_12, r1_y_6, r1_z_3, r1_x_12), float4(0.1, 0.1, 0.1, 0), float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "PerformanceChecks"="False" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0;
                float _BumpScale;
                float _Metallic;
                float _Glossiness;
                float _OcclusionStrength;
                float _Cutoff;
                float4 _Color;
                float4 _EmissionColor;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 _MetallicGlossMap_ST;
                float4 _OcclusionMap_ST;
                float4 _EmissionMap_ST;
                float4 _DetailMask_ST;
                float4 _DetailAlbedo_ST;
                float4 _DetailNormal_ST;
                float4 cb0_values[19];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0 : packoffset(c0);
                float4x4 unity_MatrixVP : packoffset(c17);
                float4 unity_OcclusionMaskSelector : packoffset(c46);
            };
            cbuffer _UnityProbeVolumeCB_b3
            {
                float4 unity_ProbeVolumeParams : packoffset(c0);
                float4x4 unity_ProbeVolumeWorldToObject : packoffset(c1);
                float3 unity_ProbeVolumeSizeInv : packoffset(c5);
                float3 unity_ProbeVolumeMin : packoffset(c6);
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_DetailAlbedo;
            SamplerState sampler_DetailNormal;
            SamplerState sampler_MainTex;
            SamplerState sampler_EmissionMap;
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_BumpMap;
            SamplerState sampler_MetallicGlossMap;
            SamplerState sampler_DetailMask;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _MetallicGlossMap;
            Texture2D _OcclusionMap;
            Texture2D _EmissionMap;
            Texture2D _DetailMask;
            Texture2D _DetailAlbedo;
            Texture2D _DetailNormal;
            Texture3D t8;
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
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float3 texcoord7 : TEXCOORD7;
                float4 color0 : COLOR0;
                float4 texcoord8 : TEXCOORD8;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program52Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float3 texcoord7 : TEXCOORD7;
                float4 color0 : COLOR0;
                float4 texcoord8 : TEXCOORD8;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program52Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program29Output vert(program29Input i)
            {
                program29Output o = (program29Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _EmissionMap_ST.xyxx, _EmissionMap_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _DetailMask_ST.xxxy, _DetailMask_ST.zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _DetailAlbedo_ST.xyxx, _DetailAlbedo_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _DetailNormal_ST.xxxy, _DetailNormal_ST.zzzw)).zw;
                o.texcoord2.xy = (mad(i.texcoord0.xyxx, cb0_values[16].xyxx, cb0_values[16].zwzz)).xy;
                o.texcoord2.zw = (mad(i.texcoord0.xxxy, cb0_values[17].xxxy, cb0_values[17].zzzw)).zw;
                o.texcoord3.xy = (mad(i.texcoord0.xyxx, cb0_values[18].xyxx, cb0_values[18].zwzz)).xy;
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                float3 unitWorldNormal_xyz_3 = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_6 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_6.xxxx * (mad(unitWorldNormal_xyz_3.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_3.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord4.y = r3_xyz_3.x;
                o.texcoord4.x = unitWorldTangent_xyz_7.z;
                o.texcoord4.z = unitWorldNormal_xyz_3.y;
                o.texcoord5.x = unitWorldTangent_xyz_7.x;
                o.texcoord6.x = unitWorldTangent_xyz_7.y;
                o.texcoord5.z = unitWorldNormal_xyz_3.z;
                o.texcoord6.z = unitWorldNormal_xyz_3.x;
                o.texcoord5.y = r3_xyz_3.y;
                o.texcoord6.y = r3_xyz_3.z;
                o.texcoord7.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_4.yyyy * cb0_values[5].xyzw);
                float4 clipPos_xyzw_5 = mad(cb0_values[4].xyzw, worldPos_xyzw_4.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(_Color, worldPos_xyzw_4.zzzz, clipPos_xyzw_5);
                o.texcoord8.xyzw = mad(_EmissionColor, worldPos_xyzw_4.wwww, clipPos_xyzw_6);
                o.texcoord9.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program52Output frag(program52Input i)
            {
                program52Output o = (program52Output)0;
                float3 r0_xyz_1 = ((-i.texcoord7.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord7.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_2 = normalize(viewDir_xyz_1);
                float4 r3_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r3_xyz_2 = ((r3_xyzw_1.xyzx * cb0_values[10].xyzx)).xyz;
                float r1_w_3 = (_BumpMap.Sample(sampler_BumpMap, (i.texcoord2.xyxx).xy)).w;
                float3 r4_xyz_1 = (_MetallicGlossMap.Sample(sampler_MetallicGlossMap, (i.texcoord2.zwzz).xy)).xyz;
                float3 r4_xyz_3 = (mad(r1_w_3.xxxx, (mad(r4_xyz_1.xyzx, float4(2, 2, 2, 0), float4(-2, -2, -2, 0))).xyzx, float4(1, 1, 1, 0))).xyz;
                float2 r6_xy_1 = (_OcclusionMap.Sample(sampler_OcclusionMap, (i.texcoord1.xyxx).xy)).xy;
                float3 r7_xyz_1 = (_EmissionMap.Sample(sampler_EmissionMap, (i.texcoord0.zwzz).xy)).xyz;
                float r7_x_2 = (r7_xyz_1.z * r7_xyz_1.x);
                float2 r6_zw_1 = (mad(float4(r7_x_2, r7_x_2, r7_x_2, r7_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r7_xyzw_3 = (r6_zw_1.xyxx * cb0_values[8].xxxx);
                float r7_x_3 = r7_xyzw_3.x;
                float r7_y_2 = r7_xyzw_3.y;
                float r2_w_1 = dot(float4(r7_x_3, r7_y_2, r7_x_3, r7_x_3), float4(r7_x_3, r7_y_2, r7_x_3, r7_x_3));
                float r2_w_2 = min(r2_w_1, 1);
                float r2_w_3 = (-r2_w_2 + 1);
                float r7_z_2 = sqrt(r2_w_3);
                float3 r8_xyz_1 = (_DetailMask.Sample(sampler_DetailMask, (i.texcoord3.xyxx).xy)).xyz;
                float r8_x_2 = (r8_xyz_1.z * r8_xyz_1.x);
                float2 r6_zw_2 = (mad(float4(r8_x_2, r8_x_2, r8_x_2, r8_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r8_xyzw_3 = (r6_zw_2.xyxx * cb0_values[8].xxxx);
                float r8_x_3 = r8_xyzw_3.x;
                float r8_y_2 = r8_xyzw_3.y;
                float r2_w_4 = dot(float4(r8_x_3, r8_y_2, r8_x_3, r8_x_3), float4(r8_x_3, r8_y_2, r8_x_3, r8_x_3));
                float r2_w_5 = min(r2_w_4, 1);
                float r2_w_6 = (-r2_w_5 + 1);
                float r8_z_2 = sqrt(r2_w_6);
                float4 r7_xyzw_4 = mad(float4(r8_x_3, r8_y_2, r8_z_2, r8_x_3), r1_w_3.xxxx, float4(r7_x_3, r7_y_2, r7_z_2, r7_x_3));
                float r7_x_4 = r7_xyzw_4.x;
                float r7_y_3 = r7_xyzw_4.y;
                float r7_z_3 = r7_xyzw_4.z;
                float r1_w_4 = dot(float4(r7_x_4, r7_y_3, r7_z_3, r7_x_4), float4(r7_x_4, r7_y_3, r7_z_3, r7_x_4));
                float r1_w_5 = rsqrt(r1_w_4);
                float4 r7_xyzw_5 = (r1_w_5.xxxx * float4(r7_x_4, r7_y_3, r7_z_3, r7_x_4));
                float r7_x_5 = r7_xyzw_5.x;
                float r7_y_4 = r7_xyzw_5.y;
                float r7_z_4 = r7_xyzw_5.z;
                float r1_w_6 = (r6_xy_1.x * cb0_values[8].y);
                float r2_w_7 = mad(r3_xyzw_1.w, cb0_values[10].w, -cb0_values[9].x);
                float r2_w_8 = (r2_w_7 < 0);
                if (r2_w_8) discard;
                float4 r8_xyzw_4 = (i.texcoord7.yyyy * cb0_values[5].xyzw);
                float4 r8_xyzw_5 = mad(cb0_values[4].xyzw, i.texcoord7.xxxx, r8_xyzw_4);
                float4 r8_xyzw_6 = mad(cb0_values[6].xyzw, i.texcoord7.zzzz, r8_xyzw_5);
                float4 r8_xyzw_7 = (r8_xyzw_6 + cb0_values[7].xyzw);
                float r2_w_9 = (unity_ProbeVolumeParams.x == 1);
                float4 r9_xyzw_4;
                if (r2_w_9)
                {
                    float r2_w_10 = (unity_ProbeVolumeParams.y == 1);
                    float4 r6_xyzw_2 = (i.texcoord7.yyyy * unity_ProbeVolumeWorldToObject[1].xxyz);
                    float r6_x_2 = r6_xyzw_2.x;
                    float r6_z_3 = r6_xyzw_2.z;
                    float r6_w_3 = r6_xyzw_2.w;
                    float4 r6_xyzw_3 = mad(unity_ProbeVolumeWorldToObject[0].xxyz, i.texcoord7.xxxx, float4(r6_x_2, r6_x_2, r6_z_3, r6_w_3));
                    float r6_x_3 = r6_xyzw_3.x;
                    float r6_z_4 = r6_xyzw_3.z;
                    float r6_w_4 = r6_xyzw_3.w;
                    float4 r6_xyzw_4 = mad(unity_ProbeVolumeWorldToObject[2].xxyz, i.texcoord7.zzzz, float4(r6_x_3, r6_x_3, r6_z_4, r6_w_4));
                    float r6_x_4 = r6_xyzw_4.x;
                    float r6_z_5 = r6_xyzw_4.z;
                    float r6_w_5 = r6_xyzw_4.w;
                    float4 r6_xyzw_5 = (float4(r6_x_4, r6_x_4, r6_z_5, r6_w_5) + unity_ProbeVolumeWorldToObject[3].xxyz);
                    float r6_x_5 = r6_xyzw_5.x;
                    float r6_z_6 = r6_xyzw_5.z;
                    float r6_w_6 = r6_xyzw_5.w;
                    float4 unity_ProbeVolumeParamsSelect_xyzw_6 = (r2_w_10.xxxx ? float4(r6_x_5, r6_x_5, r6_z_6, r6_w_6) : i.texcoord7.xxyz);
                    float unity_ProbeVolumeParamsSelect_x_6 = unity_ProbeVolumeParamsSelect_xyzw_6.x;
                    float unity_ProbeVolumeParamsSelect_z_7 = unity_ProbeVolumeParamsSelect_xyzw_6.z;
                    float unity_ProbeVolumeParamsSelect_w_7 = unity_ProbeVolumeParamsSelect_xyzw_6.w;
                    float4 r6_xyzw_7 = (float4(unity_ProbeVolumeParamsSelect_x_6, unity_ProbeVolumeParamsSelect_x_6, unity_ProbeVolumeParamsSelect_z_7, unity_ProbeVolumeParamsSelect_w_7) + -unity_ProbeVolumeMin.xxyz);
                    float r6_x_7 = r6_xyzw_7.x;
                    float r6_z_8 = r6_xyzw_7.z;
                    float r6_w_8 = r6_xyzw_7.w;
                    float3 r9_yzw_2 = ((float4(r6_x_7, r6_x_7, r6_z_8, r6_w_8) * unity_ProbeVolumeSizeInv.xxyz)).yzw;
                    float r2_w_11 = mad(r9_yzw_2.x, 0.25, 0.75);
                    float r3_w_2 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r9_x_2 = max(r2_w_11, r3_w_2);
                    float4 r9_xyzw_3 = t8.Sample(sampler_linear_clamp, (float4(r9_x_2, r9_yzw_2.y, r9_yzw_2.z, r9_x_2)).xyz);
                    r9_xyzw_4 = r9_xyzw_3;
                }
                else
                {
                    r9_xyzw_4 = float4(1, 1, 1, 1);
                }
                float r2_w_13 = saturate(dot(r9_xyzw_4, unity_OcclusionMaskSelector));
                float r3_w_4 = (0 < r8_xyzw_7.z);
                float r3_w_5 = asfloat(asint(r3_w_4) & asint(1065353216));
                float4 r6_xyzw_9 = (r8_xyzw_7.xxyx / r8_xyzw_7.wwww);
                float r6_x_9 = r6_xyzw_9.x;
                float r6_z_10 = r6_xyzw_9.z;
                float4 r6_xyzw_10 = (float4(r6_x_9, r6_x_9, r6_z_10, r6_x_9) + float4(0.5, 0, 0.5, 0));
                float r6_x_10 = r6_xyzw_10.x;
                float r6_z_11 = r6_xyzw_10.z;
                float r4_w_1 = (_DetailAlbedo.Sample(sampler_DetailAlbedo, (float4(r6_x_10, r6_z_11, r6_x_10, r6_x_10)).xy)).w;
                float r3_w_6 = (r3_w_5 * r4_w_1);
                float r4_w_2 = dot(r8_xyzw_7.xyzx, r8_xyzw_7.xyzx);
                float r4_w_3 = (_DetailNormal.Sample(sampler_DetailNormal, (r4_w_2.xxxx).xy)).w;
                float r3_w_7 = (r3_w_6 * r4_w_3);
                float r2_w_14 = (r2_w_13 * r3_w_7);
                float r8_x_8 = dot(i.texcoord4.xyzx, float4(r7_x_5, r7_y_4, r7_z_4, r7_x_5));
                float r8_y_7 = dot(i.texcoord5.xyzx, float4(r7_x_5, r7_y_4, r7_z_4, r7_x_5));
                float r8_z_7 = dot(i.texcoord6.xyzx, float4(r7_x_5, r7_y_4, r7_z_4, r7_x_5));
                float r3_w_8 = dot(float4(r8_x_8, r8_y_7, r8_z_7, r8_x_8), float4(r8_x_8, r8_y_7, r8_z_7, r8_x_8));
                float r3_w_9 = rsqrt(r3_w_8);
                float4 r6_xyzw_11 = (r3_w_9.xxxx * float4(r8_x_8, r8_x_8, r8_y_7, r8_z_7));
                float r6_x_11 = r6_xyzw_11.x;
                float r6_z_12 = r6_xyzw_11.z;
                float r6_w_10 = r6_xyzw_11.w;
                float4 r7_xyzw_6 = (r2_w_14.xxxx * _LightColor0.xyzx);
                float r7_x_6 = r7_xyzw_6.x;
                float r7_y_5 = r7_xyzw_6.y;
                float r7_z_5 = r7_xyzw_6.z;
                float3 r3_xyz_4 = (mad(r1_w_6.xxxx, (mad(r3_xyz_2.xyzx, r4_xyz_3.xyzx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_7 = mad(-r1_w_6, 0.96, 0.96);
                float r1_w_8 = mad(-r6_xy_1.y, cb0_values[8].z, 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_2.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r6_x_11, r6_z_12, r6_w_10, r6_x_11), unitViewDir_xyz_2.xyzx);
                float r2_x_3 = saturate(dot(float4(r6_x_11, r6_z_12, r6_w_10, r6_x_11), r1_xyz_1.xyzx));
                float r2_y_3 = saturate(dot(float4(r6_x_11, r6_z_12, r6_w_10, r6_x_11), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_8.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_x_3 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_8 * r1_w_8);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(r0_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * mad(r2_x_3, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_x_3, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r2_y_3, r0_z_9, -r2_y_3), r2_y_3, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_x_3.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r3_xyz_4.xyzx, r3_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r7_x_6, r7_y_5, r7_z_5, r7_x_6));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r7_x_6, r7_x_6, r7_y_5, r7_z_5) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_9 = (r0_x_5 * r0_x_5);
                float r1_w_10 = (r1_w_9 * r1_w_9);
                float4 r2_xyzw_4 = (-r3_xyz_4.xyzx + float4(1, 1, 1, 0));
                float r2_x_4 = r2_xyzw_4.x;
                float r2_y_4 = r2_xyzw_4.y;
                float r2_z_3 = r2_xyzw_4.z;
                float4 r2_xyzw_5 = mad(float4(r2_x_4, r2_y_4, r2_z_3, r2_x_4), ((r0_x_5 * r1_w_10)).xxxx, r3_xyz_4.xyzx);
                float r2_x_5 = r2_xyzw_5.x;
                float r2_y_5 = r2_xyzw_5.y;
                float r2_z_4 = r2_xyzw_5.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_5, r2_y_5, r2_z_4, r2_x_5));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_7.xxxx * ((r3_xyz_2.xyzx * r4_xyz_3.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float4 r1_xyzw_12 = mad(float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8), i.color0.xyzx, -float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8));
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_6 = r1_xyzw_12.y;
                float r1_z_3 = r1_xyzw_12.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_12, r1_y_6, r1_z_3, r1_x_12), float4(0.1, 0.1, 0.1, 0), float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "PerformanceChecks"="False" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0;
                float _BumpScale;
                float _Metallic;
                float _Glossiness;
                float _OcclusionStrength;
                float _Cutoff;
                float4 _Color;
                float4 _EmissionColor;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 _MetallicGlossMap_ST;
                float4 _OcclusionMap_ST;
                float4 _EmissionMap_ST;
                float4 _DetailMask_ST;
                float4 _DetailAlbedo_ST;
                float4 _DetailNormal_ST;
                float4 cb0_values[7];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0 : packoffset(c0);
                float4x4 unity_MatrixVP : packoffset(c17);
                float4 unity_OcclusionMaskSelector : packoffset(c46);
            };
            cbuffer _UnityProbeVolumeCB_b3
            {
                float4 unity_ProbeVolumeParams : packoffset(c0);
                float4x4 unity_ProbeVolumeWorldToObject : packoffset(c1);
                float3 unity_ProbeVolumeSizeInv : packoffset(c5);
                float3 unity_ProbeVolumeMin : packoffset(c6);
            };
            SamplerState sampler_DetailAlbedo;
            SamplerState sampler_MainTex;
            SamplerState sampler_EmissionMap;
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_BumpMap;
            SamplerState sampler_MetallicGlossMap;
            SamplerState sampler_DetailMask;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _MetallicGlossMap;
            Texture2D _OcclusionMap;
            Texture2D _EmissionMap;
            Texture2D _DetailMask;
            Texture3D _DetailAlbedo;
            struct program28Input
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
            struct program28Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float3 texcoord7 : TEXCOORD7;
                float4 color0 : COLOR0;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program51Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float3 texcoord7 : TEXCOORD7;
                float4 color0 : COLOR0;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program51Output
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
                o.texcoord7.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _MetallicGlossMap_ST.xyxx, _MetallicGlossMap_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _OcclusionMap_ST.xxxy, _OcclusionMap_ST.zzzw)).zw;
                o.texcoord2.xy = (mad(i.texcoord0.xyxx, _EmissionMap_ST.xyxx, _EmissionMap_ST.zwzz)).xy;
                o.texcoord2.zw = (mad(i.texcoord0.xxxy, _DetailMask_ST.xxxy, _DetailMask_ST.zzzw)).zw;
                o.texcoord3.xy = (mad(i.texcoord0.xyxx, _DetailAlbedo_ST.xyxx, _DetailAlbedo_ST.zwzz)).xy;
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                float3 unitWorldNormal_xyz_8 = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                float3 worldTangent_xyz_2 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_3 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_2.xyzx)).xyz;
                float3 worldTangent_xyz_4 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_3.xyzx)).xyz;
                float3 unitWorldTangent_xyz_5 = normalize(worldTangent_xyz_4);
                float r0_w_11 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r2_xyz_3 = ((r0_w_11.xxxx * (mad(unitWorldNormal_xyz_8.zxyz, unitWorldTangent_xyz_5.yzxy, ((unitWorldNormal_xyz_8.xyzx * unitWorldTangent_xyz_5.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord4.y = r2_xyz_3.x;
                o.texcoord4.x = unitWorldTangent_xyz_5.z;
                o.texcoord4.z = unitWorldNormal_xyz_8.y;
                o.texcoord5.x = unitWorldTangent_xyz_5.x;
                o.texcoord6.x = unitWorldTangent_xyz_5.y;
                o.texcoord5.z = unitWorldNormal_xyz_8.z;
                o.texcoord6.z = unitWorldNormal_xyz_8.x;
                o.texcoord5.y = r2_xyz_3.y;
                o.texcoord6.y = r2_xyz_3.z;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord9.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program51Output frag(program51Input i)
            {
                program51Output o = (program51Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord7.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_2 = ((r2_xyzw_1.xyzx * cb0_values[6].xyzx)).xyz;
                float r1_w_1 = (_BumpMap.Sample(sampler_BumpMap, (i.texcoord2.xyxx).xy)).w;
                float3 r3_xyz_1 = (_MetallicGlossMap.Sample(sampler_MetallicGlossMap, (i.texcoord2.zwzz).xy)).xyz;
                float3 r3_xyz_3 = (mad(r1_w_1.xxxx, (mad(r3_xyz_1.xyzx, float4(2, 2, 2, 0), float4(-2, -2, -2, 0))).xyzx, float4(1, 1, 1, 0))).xyz;
                float2 r5_xy_1 = (_OcclusionMap.Sample(sampler_OcclusionMap, (i.texcoord1.xyxx).xy)).xy;
                float3 r6_xyz_1 = (_EmissionMap.Sample(sampler_EmissionMap, (i.texcoord0.zwzz).xy)).xyz;
                float r6_x_2 = (r6_xyz_1.z * r6_xyz_1.x);
                float2 r5_zw_1 = (mad(float4(r6_x_2, r6_x_2, r6_x_2, r6_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r6_xyzw_3 = (r5_zw_1.xyxx * cb0_values[4].xxxx);
                float r6_x_3 = r6_xyzw_3.x;
                float r6_y_2 = r6_xyzw_3.y;
                float r3_w_1 = dot(float4(r6_x_3, r6_y_2, r6_x_3, r6_x_3), float4(r6_x_3, r6_y_2, r6_x_3, r6_x_3));
                float r3_w_2 = min(r3_w_1, 1);
                float r3_w_3 = (-r3_w_2 + 1);
                float r6_z_2 = sqrt(r3_w_3);
                float3 r7_xyz_1 = (_DetailMask.Sample(sampler_DetailMask, (i.texcoord3.xyxx).xy)).xyz;
                float r7_x_2 = (r7_xyz_1.z * r7_xyz_1.x);
                float2 r5_zw_2 = (mad(float4(r7_x_2, r7_x_2, r7_x_2, r7_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r7_xyzw_3 = (r5_zw_2.xyxx * cb0_values[4].xxxx);
                float r7_x_3 = r7_xyzw_3.x;
                float r7_y_2 = r7_xyzw_3.y;
                float r3_w_4 = dot(float4(r7_x_3, r7_y_2, r7_x_3, r7_x_3), float4(r7_x_3, r7_y_2, r7_x_3, r7_x_3));
                float r3_w_5 = min(r3_w_4, 1);
                float r3_w_6 = (-r3_w_5 + 1);
                float r7_z_2 = sqrt(r3_w_6);
                float4 r6_xyzw_4 = mad(float4(r7_x_3, r7_y_2, r7_z_2, r7_x_3), r1_w_1.xxxx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r6_x_4 = r6_xyzw_4.x;
                float r6_y_3 = r6_xyzw_4.y;
                float r6_z_3 = r6_xyzw_4.z;
                float r1_w_2 = dot(float4(r6_x_4, r6_y_3, r6_z_3, r6_x_4), float4(r6_x_4, r6_y_3, r6_z_3, r6_x_4));
                float r1_w_3 = rsqrt(r1_w_2);
                float4 r6_xyzw_5 = (r1_w_3.xxxx * float4(r6_x_4, r6_y_3, r6_z_3, r6_x_4));
                float r6_x_5 = r6_xyzw_5.x;
                float r6_y_4 = r6_xyzw_5.y;
                float r6_z_4 = r6_xyzw_5.z;
                float r1_w_4 = (r5_xy_1.x * cb0_values[4].y);
                float r2_w_2 = mad(r2_xyzw_1.w, cb0_values[6].w, -cb0_values[5].x);
                float r2_w_3 = (r2_w_2 < 0);
                if (r2_w_3) discard;
                float r2_w_4 = (unity_ProbeVolumeParams.x == 1);
                float r7_x_7;
                float r7_y_6;
                float r7_z_6;
                float r7_w_4;
                if (r2_w_4)
                {
                    float r2_w_5 = (unity_ProbeVolumeParams.y == 1);
                    float4 r5_xyzw_2 = (i.texcoord7.yyyy * unity_ProbeVolumeWorldToObject[1].xxyz);
                    float r5_x_2 = r5_xyzw_2.x;
                    float r5_z_3 = r5_xyzw_2.z;
                    float r5_w_3 = r5_xyzw_2.w;
                    float4 r5_xyzw_3 = mad(unity_ProbeVolumeWorldToObject[0].xxyz, i.texcoord7.xxxx, float4(r5_x_2, r5_x_2, r5_z_3, r5_w_3));
                    float r5_x_3 = r5_xyzw_3.x;
                    float r5_z_4 = r5_xyzw_3.z;
                    float r5_w_4 = r5_xyzw_3.w;
                    float4 r5_xyzw_4 = mad(unity_ProbeVolumeWorldToObject[2].xxyz, i.texcoord7.zzzz, float4(r5_x_3, r5_x_3, r5_z_4, r5_w_4));
                    float r5_x_4 = r5_xyzw_4.x;
                    float r5_z_5 = r5_xyzw_4.z;
                    float r5_w_5 = r5_xyzw_4.w;
                    float4 r5_xyzw_5 = (float4(r5_x_4, r5_x_4, r5_z_5, r5_w_5) + unity_ProbeVolumeWorldToObject[3].xxyz);
                    float r5_x_5 = r5_xyzw_5.x;
                    float r5_z_6 = r5_xyzw_5.z;
                    float r5_w_6 = r5_xyzw_5.w;
                    float4 unity_ProbeVolumeParamsSelect_xyzw_6 = (r2_w_5.xxxx ? float4(r5_x_5, r5_x_5, r5_z_6, r5_w_6) : i.texcoord7.xxyz);
                    float unity_ProbeVolumeParamsSelect_x_6 = unity_ProbeVolumeParamsSelect_xyzw_6.x;
                    float unity_ProbeVolumeParamsSelect_z_7 = unity_ProbeVolumeParamsSelect_xyzw_6.z;
                    float unity_ProbeVolumeParamsSelect_w_7 = unity_ProbeVolumeParamsSelect_xyzw_6.w;
                    float4 r5_xyzw_7 = (float4(unity_ProbeVolumeParamsSelect_x_6, unity_ProbeVolumeParamsSelect_x_6, unity_ProbeVolumeParamsSelect_z_7, unity_ProbeVolumeParamsSelect_w_7) + -unity_ProbeVolumeMin.xxyz);
                    float r5_x_7 = r5_xyzw_7.x;
                    float r5_z_8 = r5_xyzw_7.z;
                    float r5_w_8 = r5_xyzw_7.w;
                    float4 r7_xyzw_4 = (float4(r5_x_7, r5_x_7, r5_z_8, r5_w_8) * unity_ProbeVolumeSizeInv.xxyz);
                    float r7_y_4 = r7_xyzw_4.y;
                    float r7_z_4 = r7_xyzw_4.z;
                    float r7_w_2 = r7_xyzw_4.w;
                    float r2_w_6 = mad(r7_y_4, 0.25, 0.75);
                    float r3_w_7 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r7_x_5 = max(r2_w_6, r3_w_7);
                    float4 r7_xyzw_6 = _DetailAlbedo.Sample(sampler_DetailAlbedo, (float4(r7_x_5, r7_z_4, r7_w_2, r7_x_5)).xyz);
                    r7_x_7 = r7_xyzw_6.x;
                    r7_y_6 = r7_xyzw_6.y;
                    r7_z_6 = r7_xyzw_6.z;
                    r7_w_4 = r7_xyzw_6.w;
                }
                else
                {
                    float r7_x_4 = (float4(1, 1, 1, 1)).x;
                    float r7_y_3 = (float4(1, 1, 1, 1)).y;
                    float r7_z_3 = (float4(1, 1, 1, 1)).z;
                    float r7_w_1 = (float4(1, 1, 1, 1)).w;
                    r7_x_7 = r7_x_4;
                    r7_y_6 = r7_y_3;
                    r7_z_6 = r7_z_3;
                    r7_w_4 = r7_w_1;
                }
                float r2_w_8 = saturate(dot(float4(r7_x_7, r7_y_6, r7_z_6, r7_w_4), unity_OcclusionMaskSelector));
                float r7_x_8 = dot(i.texcoord4.xyzx, float4(r6_x_5, r6_y_4, r6_z_4, r6_x_5));
                float r7_y_7 = dot(i.texcoord5.xyzx, float4(r6_x_5, r6_y_4, r6_z_4, r6_x_5));
                float r7_z_7 = dot(i.texcoord6.xyzx, float4(r6_x_5, r6_y_4, r6_z_4, r6_x_5));
                float r3_w_9 = dot(float4(r7_x_8, r7_y_7, r7_z_7, r7_x_8), float4(r7_x_8, r7_y_7, r7_z_7, r7_x_8));
                float r3_w_10 = rsqrt(r3_w_9);
                float4 r5_xyzw_9 = (r3_w_10.xxxx * float4(r7_x_8, r7_x_8, r7_y_7, r7_z_7));
                float r5_x_9 = r5_xyzw_9.x;
                float r5_z_10 = r5_xyzw_9.z;
                float r5_w_10 = r5_xyzw_9.w;
                float4 r6_xyzw_6 = (r2_w_8.xxxx * _LightColor0.xyzx);
                float r6_x_6 = r6_xyzw_6.x;
                float r6_y_5 = r6_xyzw_6.y;
                float r6_z_5 = r6_xyzw_6.z;
                float3 r2_xyz_4 = (mad(r1_w_4.xxxx, (mad(r2_xyz_2.xyzx, r3_xyz_3.xyzx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_5 = mad(-r1_w_4, 0.96, 0.96);
                float r1_w_6 = mad(-r5_xy_1.y, cb0_values[4].z, 1);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r5_x_9, r5_z_10, r5_w_10, r5_x_9), unitViewDir_xyz_1.xyzx);
                float r1_x_2 = saturate(dot(float4(r5_x_9, r5_z_10, r5_w_10, r5_x_9), _WorldSpaceLightPos0.xyzx));
                float r1_y_2 = saturate(dot(float4(r5_x_9, r5_z_10, r5_w_10, r5_x_9), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_6.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(r0_w_6) + 1);
                float r2_w_9 = (r1_z_4 * r1_z_4);
                float r2_w_10 = (r2_w_9 * r2_w_9);
                float r1_z_5 = (r1_z_4 * r2_w_10);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_6 * r1_w_6);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_z_6 = (-r0_z_8 + 1);
                float r1_w_7 = mad(abs(r0_w_6), r1_z_6, r0_z_8);
                float r1_z_7 = mad(r1_x_2, r1_z_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * r1_z_7);
                float r0_w_8 = mad(r1_x_2, r1_w_7, r0_w_7);
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
                float4 r0_xyzw_9 = (r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_3 = (r0_y_9.xxxx * float4(r6_x_6, r6_y_5, r6_z_5, r6_x_6));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_5 = r1_xyzw_3.y;
                float r1_z_9 = r1_xyzw_3.z;
                float4 r0_xyzw_10 = (float4(r6_x_6, r6_x_6, r6_y_5, r6_z_5) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_8 = (r0_x_5 * r0_x_5);
                float r1_w_9 = (r1_w_8 * r1_w_8);
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * (mad(((-r2_xyz_4.xyzx + float4(1, 1, 1, 0))).xyzx, ((r0_x_5 * r1_w_9)).xxxx, r2_xyz_4.xyzx)).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_5.xxxx * ((r2_xyz_2.xyzx * r3_xyz_3.xyzx)).xyzx)).xyzx, float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float4 r1_xyzw_4 = mad(float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8), i.color0.xyzx, -float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_6 = r1_xyzw_4.y;
                float r1_z_10 = r1_xyzw_4.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_4, r1_y_6, r1_z_10, r1_x_4), float4(0.1, 0.1, 0.1, 0), float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="DEFERRED" "PerformanceChecks"="False" "QUEUE"="Geometry" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float _BumpScale : packoffset(c4.x);
                float _Metallic : packoffset(c4.y);
                float _Glossiness : packoffset(c4.z);
                float _OcclusionStrength : packoffset(c4.w);
                float _Cutoff : packoffset(c5.x);
                float4 _Color : packoffset(c6);
                float4 _EmissionColor : packoffset(c7);
                float4 _MainTex_ST : packoffset(c8);
                float4 _BumpMap_ST : packoffset(c9);
                float4 _MetallicGlossMap_ST : packoffset(c10);
                float4 _OcclusionMap_ST : packoffset(c11);
                float4 _EmissionMap_ST : packoffset(c12);
                float4 _DetailMask_ST : packoffset(c13);
                float4 _DetailAlbedo_ST : packoffset(c14);
                float4 _DetailNormal_ST : packoffset(c15);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            SamplerState sampler_EmissionMap;
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_DetailAlbedo;
            SamplerState sampler_DetailNormal;
            SamplerState sampler_BumpMap;
            SamplerState sampler_MetallicGlossMap;
            SamplerState sampler_DetailMask;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _MetallicGlossMap;
            Texture2D _OcclusionMap;
            Texture2D _EmissionMap;
            Texture2D _DetailMask;
            Texture2D _DetailAlbedo;
            Texture2D _DetailNormal;
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
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 color0 : COLOR0;
                float4 texcoord8 : TEXCOORD8;
            };
            struct program71Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 color0 : COLOR0;
                float4 texcoord8 : TEXCOORD8;
            };
            struct program71Output
            {
                float4 sv_Target0 : SV_Target;
                float4 sv_Target1 : SV_Target1;
                float4 sv_Target2 : SV_Target2;
                float4 sv_Target3 : SV_Target3;
            };
            #pragma vertex vert
            program65Output vert(program65Input i)
            {
                program65Output o = (program65Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                float3 worldPos_xyz_4 = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _MetallicGlossMap_ST.xyxx, _MetallicGlossMap_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _OcclusionMap_ST.xxxy, _OcclusionMap_ST.zzzw)).zw;
                o.texcoord2.xy = (mad(i.texcoord0.xyxx, _EmissionMap_ST.xyxx, _EmissionMap_ST.zwzz)).xy;
                o.texcoord2.zw = (mad(i.texcoord0.xxxy, _DetailMask_ST.xxxy, _DetailMask_ST.zzzw)).zw;
                o.texcoord3.xy = (mad(i.texcoord0.xyxx, _DetailAlbedo_ST.xyxx, _DetailAlbedo_ST.zwzz)).xy;
                o.texcoord3.zw = (mad(i.texcoord0.xxxy, _DetailNormal_ST.xxxy, _DetailNormal_ST.zzzw)).zw;
                o.texcoord4.w = worldPos_xyz_4.x;
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float3 unitWorldNormal_xyz_3 = (((rsqrt(dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2)))).xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = (((rsqrt(dot(worldTangent_xyz_6.xyzx, worldTangent_xyz_6.xyzx))).xxxx * worldTangent_xyz_6.xyzx)).xyz;
                float3 r3_xyz_3 = ((((i.tangent0.w * unity_WorldTransformParams.w)).xxxx * (mad(unitWorldNormal_xyz_3.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_3.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord4.y = r3_xyz_3.x;
                o.texcoord4.x = unitWorldTangent_xyz_7.z;
                o.texcoord4.z = unitWorldNormal_xyz_3.y;
                o.texcoord5.x = unitWorldTangent_xyz_7.x;
                o.texcoord6.x = unitWorldTangent_xyz_7.y;
                o.texcoord5.z = unitWorldNormal_xyz_3.z;
                o.texcoord6.z = unitWorldNormal_xyz_3.x;
                o.texcoord5.w = worldPos_xyz_4.y;
                o.texcoord6.w = worldPos_xyz_4.z;
                o.texcoord5.y = r3_xyz_3.y;
                o.texcoord6.y = r3_xyz_3.z;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord8.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program71Output frag(program71Input i)
            {
                program71Output o = (program71Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float r0_w_2 = mad(r0_xyzw_1.w, _Color.w, -_Cutoff);
                float3 r0_xyz_2 = ((r0_xyzw_1.xyzx * _Color.xyzx)).xyz;
                float r0_w_3 = (r0_w_2 < 0);
                if (r0_w_3) discard;
                float r0_w_4 = (_DetailAlbedo.Sample(sampler_DetailAlbedo, (i.texcoord1.zwzz).xy)).w;
                float r0_w_5 = (r0_w_4 + -1);
                o.sv_Target0.w = mad(_OcclusionStrength, r0_w_5, 1);
                float3 r1_xyz_1 = (_MetallicGlossMap.Sample(sampler_MetallicGlossMap, (i.texcoord3.xyxx).xy)).xyz;
                float r0_w_6 = (_BumpMap.Sample(sampler_BumpMap, (i.texcoord2.zwzz).xy)).w;
                float3 r1_xyz_3 = (mad(r0_w_6.xxxx, (mad(r1_xyz_1.xyzx, float4(2, 2, 2, 0), float4(-2, -2, -2, 0))).xyzx, float4(1, 1, 1, 0))).xyz;
                float2 r1_xy_4 = (_OcclusionMap.Sample(sampler_OcclusionMap, (i.texcoord1.xyxx).xy)).xy;
                float r1_x_5 = (r1_xy_4.x * _Metallic);
                o.sv_Target1.w = (r1_xy_4.y * _Glossiness);
                float r1_y_5 = mad(-r1_x_5, 0.96, 0.96);
                o.sv_Target1.xyz = (mad(r1_x_5.xxxx, (mad(r0_xyz_2.xyzx, r1_xyz_3.xyzx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                o.sv_Target0.xyz = ((r1_y_5.xxxx * ((r0_xyz_2.xyzx * r1_xyz_3.xyzx)).xyzx)).xyz;
                float3 r0_xyz_4 = (_EmissionMap.Sample(sampler_EmissionMap, (i.texcoord0.zwzz).xy)).xyz;
                float r0_x_5 = (r0_xyz_4.z * r0_xyz_4.x);
                float4 r0_xyzw_6 = mad(float4(r0_x_5, r0_xyz_4.y, r0_x_5, r0_x_5), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_5 = r0_xyzw_6.y;
                float4 r0_xyzw_7 = (float4(r0_x_6, r0_y_5, r0_x_6, r0_x_6) * _BumpScale.xxxx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_6 = r0_xyzw_7.y;
                float r0_z_5 = sqrt((min(dot(float4(r0_x_7, r0_y_6, r0_x_7, r0_x_7), float4(r0_x_7, r0_y_6, r0_x_7, r0_x_7)), 1) + 1));
                float4 r1_xyzw_9 = _DetailMask.Sample(sampler_DetailMask, (i.texcoord3.zwzz).xy);
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_6 = r1_xyzw_9.y;
                float r1_z_4 = r1_xyzw_9.z;
                float r1_x_10 = (r1_z_4 * r1_x_9);
                float4 r1_xyzw_11 = mad(float4(r1_x_10, r1_y_6, r1_x_10, r1_x_10), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_7 = r1_xyzw_11.y;
                float4 r1_xyzw_12 = (float4(r1_x_11, r1_y_7, r1_x_11, r1_x_11) * _BumpScale.xxxx);
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_8 = r1_xyzw_12.y;
                float r1_w_1 = dot(float4(r1_x_12, r1_y_8, r1_x_12, r1_x_12), float4(r1_x_12, r1_y_8, r1_x_12, r1_x_12));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r1_z_5 = sqrt(r1_w_3);
                float4 r0_xyzw_8 = mad(float4(r1_x_12, r1_y_8, r1_z_5, r1_x_12), r0_w_6.xxxx, float4(r0_x_7, r0_y_6, r0_z_5, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_7 = r0_xyzw_8.y;
                float r0_z_6 = r0_xyzw_8.z;
                float r0_w_7 = dot(float4(r0_x_8, r0_y_7, r0_z_6, r0_x_8), float4(r0_x_8, r0_y_7, r0_z_6, r0_x_8));
                float r0_w_8 = rsqrt(r0_w_7);
                float4 r0_xyzw_9 = (r0_w_8.xxxx * float4(r0_x_8, r0_y_7, r0_z_6, r0_x_8));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_8 = r0_xyzw_9.y;
                float r0_z_7 = r0_xyzw_9.z;
                float r1_x_13 = dot(i.texcoord4.xyzx, float4(r0_x_9, r0_y_8, r0_z_7, r0_x_9));
                float r1_y_9 = dot(i.texcoord5.xyzx, float4(r0_x_9, r0_y_8, r0_z_7, r0_x_9));
                float r1_z_6 = dot(i.texcoord6.xyzx, float4(r0_x_9, r0_y_8, r0_z_7, r0_x_9));
                float4 r0_xyzw_12 = ((rsqrt(dot(float4(r1_x_13, r1_y_9, r1_z_6, r1_x_13), float4(r1_x_13, r1_y_9, r1_z_6, r1_x_13)))).xxxx * float4(r1_x_13, r1_y_9, r1_z_6, r1_x_13));
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_9 = r0_xyzw_12.y;
                float r0_z_8 = r0_xyzw_12.z;
                o.sv_Target2.xyz = (mad(float4(r0_x_12, r0_y_9, r0_z_8, r0_x_12), float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
                o.sv_Target2.w = 1;
                float4 r0_xyzw_13 = _DetailNormal.Sample(sampler_DetailNormal, (i.texcoord2.xyxx).xy);
                float r0_x_13 = r0_xyzw_13.x;
                float r0_y_10 = r0_xyzw_13.y;
                float r0_z_9 = r0_xyzw_13.z;
                float4 r0_xyzw_14 = (float4(r0_x_13, r0_y_10, r0_z_9, r0_x_13) * _EmissionColor.xyzx);
                float r0_x_14 = r0_xyzw_14.x;
                float r0_y_11 = r0_xyzw_14.y;
                float r0_z_10 = r0_xyzw_14.z;
                o.sv_Target3.xyz = (exp2(-float4(r0_x_14, r0_y_11, r0_z_10, r0_x_14))).xyz;
                o.sv_Target3.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="DEFERRED" "PerformanceChecks"="False" "QUEUE"="Geometry" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float _BumpScale : packoffset(c4.x);
                float _Metallic : packoffset(c4.y);
                float _Glossiness : packoffset(c4.z);
                float _OcclusionStrength : packoffset(c4.w);
                float _Cutoff : packoffset(c5.x);
                float4 _Color : packoffset(c6);
                float4 _EmissionColor : packoffset(c7);
                float4 _MainTex_ST : packoffset(c8);
                float4 _BumpMap_ST : packoffset(c9);
                float4 _MetallicGlossMap_ST : packoffset(c10);
                float4 _OcclusionMap_ST : packoffset(c11);
                float4 _EmissionMap_ST : packoffset(c12);
                float4 _DetailMask_ST : packoffset(c13);
                float4 _DetailAlbedo_ST : packoffset(c14);
                float4 _DetailNormal_ST : packoffset(c15);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
                float4 cb1_values[46];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[10];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[21];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_MainTex;
            SamplerState sampler_EmissionMap;
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_DetailAlbedo;
            SamplerState sampler_DetailNormal;
            SamplerState sampler_BumpMap;
            SamplerState sampler_MetallicGlossMap;
            SamplerState sampler_DetailMask;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _MetallicGlossMap;
            Texture2D _OcclusionMap;
            Texture2D _EmissionMap;
            Texture2D _DetailMask;
            Texture2D _DetailAlbedo;
            Texture2D _DetailNormal;
            Texture3D t8;
            struct program68Input
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
            struct program68Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 color0 : COLOR0;
                float4 texcoord8 : TEXCOORD8;
                float3 texcoord9 : TEXCOORD9;
            };
            struct program74Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 color0 : COLOR0;
                float4 texcoord8 : TEXCOORD8;
                float3 texcoord9 : TEXCOORD9;
            };
            struct program74Output
            {
                float4 sv_Target0 : SV_Target;
                float4 sv_Target1 : SV_Target1;
                float4 sv_Target2 : SV_Target2;
                float4 sv_Target3 : SV_Target3;
            };
            #pragma vertex vert
            program68Output vert(program68Input i)
            {
                program68Output o = (program68Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float3 r0_xyz_4 = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _MetallicGlossMap_ST.xyxx, _MetallicGlossMap_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _OcclusionMap_ST.xxxy, _OcclusionMap_ST.zzzw)).zw;
                o.texcoord2.xy = (mad(i.texcoord0.xyxx, _EmissionMap_ST.xyxx, _EmissionMap_ST.zwzz)).xy;
                o.texcoord2.zw = (mad(i.texcoord0.xxxy, _DetailMask_ST.xxxy, _DetailMask_ST.zzzw)).zw;
                o.texcoord3.xy = (mad(i.texcoord0.xyxx, _DetailAlbedo_ST.xyxx, _DetailAlbedo_ST.zwzz)).xy;
                o.texcoord3.zw = (mad(i.texcoord0.xxxy, _DetailNormal_ST.xxxy, _DetailNormal_ST.zzzw)).zw;
                o.texcoord4.w = r0_xyz_4.x;
                float3 worldTangent_xyz_2 = ((i.tangent0.yyyy * cb2_values[1].yzxy)).xyz;
                float3 worldTangent_xyz_3 = (mad(cb2_values[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_2.xyzx)).xyz;
                float3 worldTangent_xyz_4 = (mad(cb2_values[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_3.xyzx)).xyz;
                float3 unitWorldTangent_xyz_5 = (((rsqrt(dot(worldTangent_xyz_4.xyzx, worldTangent_xyz_4.xyzx))).xxxx * worldTangent_xyz_4.xyzx)).xyz;
                o.texcoord4.x = unitWorldTangent_xyz_5.z;
                float worldNormal_x_4 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float4 unitWorldNormal_xyzw_5 = ((rsqrt(dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4)))).xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_z_4));
                float3 r3_xyz_3 = ((((i.tangent0.w * cb2_values[9].w)).xxxx * (mad(unitWorldNormal_xyzw_5.ywxy, unitWorldTangent_xyz_5.yzxy, ((unitWorldTangent_xyz_5.xyzx * unitWorldNormal_xyzw_5.wxyw)).xyzx)).xyzx)).xyz;
                o.texcoord4.y = r3_xyz_3.x;
                o.texcoord4.z = unitWorldNormal_xyzw_5.x;
                o.texcoord5.x = unitWorldTangent_xyz_5.x;
                o.texcoord6.x = unitWorldTangent_xyz_5.y;
                o.texcoord5.w = r0_xyz_4.y;
                o.texcoord6.w = r0_xyz_4.z;
                o.texcoord5.y = r3_xyz_3.y;
                o.texcoord6.y = r3_xyz_3.z;
                o.texcoord5.z = unitWorldNormal_xyzw_5.y;
                o.texcoord6.z = unitWorldNormal_xyzw_5.w;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord8.xyzw = float4(0, 0, 0, 0);
                float4 r1_xyzw_6 = (unitWorldNormal_xyzw_5.ywzx * unitWorldNormal_xyzw_5);
                float r2_x_6 = dot(cb1_values[42].xyzw, r1_xyzw_6);
                float r2_y_6 = dot(cb1_values[43].xyzw, r1_xyzw_6);
                float r2_z_6 = dot(cb1_values[44].xyzw, r1_xyzw_6);
                o.texcoord9.xyz = (mad(cb1_values[45].xyzx, (mad(unitWorldNormal_xyzw_5.x, unitWorldNormal_xyzw_5.x, (unitWorldNormal_xyzw_5.y * unitWorldNormal_xyzw_5.y))).xxxx, float4(r2_x_6, r2_y_6, r2_z_6, r2_x_6))).xyz;
                return o;
            }
            #pragma fragment frag
            program74Output frag(program74Input i)
            {
                program74Output o = (program74Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r0_xyz_2 = ((r0_xyzw_1.xyzx * _Color.xyzx)).xyz;
                float r1_x_1 = (_BumpMap.Sample(sampler_BumpMap, (i.texcoord2.zwzz).xy)).x;
                float3 r1_yzw_1 = (_MetallicGlossMap.Sample(sampler_MetallicGlossMap, (i.texcoord3.xyxx).xy)).yzw;
                float3 r1_yzw_2 = (mad(r1_yzw_1.xxyz, float4(0, 2, 2, 2), float4(0, -2, -2, -2))).yzw;
                float3 r1_yzw_3 = (mad(r1_x_1.xxxx, r1_yzw_2.xxyz, float4(0, 1, 1, 1))).yzw;
                float2 r3_xy_1 = (_OcclusionMap.Sample(sampler_OcclusionMap, (i.texcoord1.xyxx).xy)).xy;
                float3 r4_xyz_1 = (_EmissionMap.Sample(sampler_EmissionMap, (i.texcoord0.zwzz).xy)).xyz;
                float r4_x_2 = (r4_xyz_1.z * r4_xyz_1.x);
                float2 r3_zw_1 = (mad(float4(r4_x_2, r4_x_2, r4_x_2, r4_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r4_xyzw_3 = (r3_zw_1.xyxx * _BumpScale.xxxx);
                float r4_x_3 = r4_xyzw_3.x;
                float r4_y_2 = r4_xyzw_3.y;
                float r2_w_1 = dot(float4(r4_x_3, r4_y_2, r4_x_3, r4_x_3), float4(r4_x_3, r4_y_2, r4_x_3, r4_x_3));
                float r2_w_2 = min(r2_w_1, 1);
                float r2_w_3 = (-r2_w_2 + 1);
                float r4_z_2 = sqrt(r2_w_3);
                float3 r5_xyz_1 = (_DetailMask.Sample(sampler_DetailMask, (i.texcoord3.zwzz).xy)).xyz;
                float r5_x_2 = (r5_xyz_1.z * r5_xyz_1.x);
                float2 r3_zw_2 = (mad(float4(r5_x_2, r5_x_2, r5_x_2, r5_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r5_xyzw_3 = (r3_zw_2.xyxx * _BumpScale.xxxx);
                float r5_x_3 = r5_xyzw_3.x;
                float r5_y_2 = r5_xyzw_3.y;
                float r2_w_4 = dot(float4(r5_x_3, r5_y_2, r5_x_3, r5_x_3), float4(r5_x_3, r5_y_2, r5_x_3, r5_x_3));
                float r2_w_5 = min(r2_w_4, 1);
                float r2_w_6 = (-r2_w_5 + 1);
                float r5_z_2 = sqrt(r2_w_6);
                float4 r4_xyzw_4 = mad(float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3), r1_x_1.xxxx, float4(r4_x_3, r4_y_2, r4_z_2, r4_x_3));
                float r4_x_4 = r4_xyzw_4.x;
                float r4_y_3 = r4_xyzw_4.y;
                float r4_z_3 = r4_xyzw_4.z;
                float4 r4_xyzw_5 = ((rsqrt(dot(float4(r4_x_4, r4_y_3, r4_z_3, r4_x_4), float4(r4_x_4, r4_y_3, r4_z_3, r4_x_4)))).xxxx * float4(r4_x_4, r4_y_3, r4_z_3, r4_x_4));
                float r4_x_5 = r4_xyzw_5.x;
                float r4_y_4 = r4_xyzw_5.y;
                float r4_z_4 = r4_xyzw_5.z;
                float r1_x_4 = (r3_xy_1.x * _Metallic);
                o.sv_Target1.w = (r3_xy_1.y * _Glossiness);
                float r2_w_7 = (_DetailAlbedo.Sample(sampler_DetailAlbedo, (i.texcoord1.zwzz).xy)).w;
                float r2_w_8 = (r2_w_7 + -1);
                float r3_w_3 = mad(_OcclusionStrength, r2_w_8, 1);
                float4 r5_xyzw_4 = _DetailNormal.Sample(sampler_DetailNormal, (i.texcoord2.xyxx).xy);
                float r5_x_4 = r5_xyzw_4.x;
                float r5_y_3 = r5_xyzw_4.y;
                float r5_z_3 = r5_xyzw_4.z;
                float r0_w_2 = mad(r0_xyzw_1.w, _Color.w, -_Cutoff);
                float r0_w_3 = (r0_w_2 < 0);
                if (r0_w_3) discard;
                float r6_x_1 = dot(i.texcoord4.xyzx, float4(r4_x_5, r4_y_4, r4_z_4, r4_x_5));
                float r6_y_1 = dot(i.texcoord5.xyzx, float4(r4_x_5, r4_y_4, r4_z_4, r4_x_5));
                float r6_z_1 = dot(i.texcoord6.xyzx, float4(r4_x_5, r4_y_4, r4_z_4, r4_x_5));
                float r0_w_4 = dot(float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1), float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float r0_w_5 = rsqrt(r0_w_4);
                float4 r4_xyzw_6 = (r0_w_5.xxxx * float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float r4_x_6 = r4_xyzw_6.x;
                float r4_y_5 = r4_xyzw_6.y;
                float r4_z_5 = r4_xyzw_6.z;
                float r0_w_6 = (cb2_values[0].x == 1);
                float r7_x_4;
                float r7_y_5;
                float r7_z_5;
                if (r0_w_6)
                {
                    float r0_w_7 = (cb2_values[0].y == 1);
                    float3 r6_xyz_5 = (((mad(cb2_values[3].xyzx, i.texcoord6.wwww, (mad(cb2_values[1].xyzx, i.texcoord4.wwww, ((i.texcoord5.wwww * cb2_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb2_values[4].xyzx)).xyz;
                    float TEXCOORD4_y_2 = i.texcoord4.w;
                    float TEXCOORD5_z_2 = i.texcoord5.w;
                    float TEXCOORD6_w_1 = i.texcoord6.w;
                    float4 r6_xyzw_8 = (((((r0_w_7.xxxx ? r6_xyz_5.xyzx : float4(TEXCOORD4_y_2, TEXCOORD5_z_2, TEXCOORD6_w_1, TEXCOORD4_y_2))).xyzx + -cb2_values[6].xyzx)).xxyz * cb2_values[5].xxyz);
                    float r6_y_8 = r6_xyzw_8.y;
                    float r6_z_8 = r6_xyzw_8.z;
                    float r6_w_1 = r6_xyzw_8.w;
                    float r0_w_8 = (r6_y_8 * 0.25);
                    float r2_w_9 = (cb2_values[0].z * 0.5);
                    float r5_w_1 = mad(-cb2_values[0].z, 0.5, 0.25);
                    float r0_w_9 = max(r0_w_8, r2_w_9);
                    float r6_x_8 = min(r5_w_1, r0_w_9);
                    float4 r7_xyzw_2 = t8.Sample(sampler_linear_clamp, (float4(r6_x_8, r6_z_8, r6_w_1, r6_x_8)).xyz);
                    float4 r8_xyzw_2 = t8.Sample(sampler_linear_clamp, (((float4(r6_x_8, r6_z_8, r6_w_1, r6_x_8) + float4(0.25, 0, 0, 0))).xyzx).xyz);
                    float4 r6_xyzw_10 = t8.Sample(sampler_linear_clamp, (((float4(r6_x_8, r6_z_8, r6_w_1, r6_x_8) + float4(0.5, 0, 0, 0))).xyzx).xyz);
                    float r4_w_2 = 1;
                    float r7_x_3 = dot(r7_xyzw_2, float4(r4_x_6, r4_y_5, r4_z_5, r4_w_2));
                    float r7_y_4 = dot(r8_xyzw_2, float4(r4_x_6, r4_y_5, r4_z_5, r4_w_2));
                    float r7_z_4 = dot(r6_xyzw_10, float4(r4_x_6, r4_y_5, r4_z_5, r4_w_2));
                    r7_x_4 = r7_x_3;
                    r7_y_5 = r7_y_4;
                    r7_z_5 = r7_z_4;
                }
                else
                {
                    float r4_w_1 = 1;
                    float r7_x_1 = dot(cb1_values[39].xyzw, float4(r4_x_6, r4_y_5, r4_z_5, r4_w_1));
                    float r7_y_1 = dot(cb1_values[40].xyzw, float4(r4_x_6, r4_y_5, r4_z_5, r4_w_1));
                    float r7_z_1 = dot(cb1_values[41].xyzw, float4(r4_x_6, r4_y_5, r4_z_5, r4_w_1));
                    r7_x_4 = r7_x_1;
                    r7_y_5 = r7_y_1;
                    r7_z_5 = r7_z_1;
                }
                o.sv_Target1.xyz = (mad(r1_x_4.xxxx, (mad(r0_xyz_2.xyzx, r1_yzw_3.xyzx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float4 r3_xyzw_2 = ((mad(-r1_x_4, 0.96, 0.96)).xxxx * ((r0_xyz_2.xyzx * r1_yzw_3.xyzx)).xyzx);
                float r3_x_2 = r3_xyzw_2.x;
                float r3_y_2 = r3_xyzw_2.y;
                float r3_z_3 = r3_xyzw_2.z;
                float4 r0_xyzw_5 = (((r3_w_3.xxxx * (max(((float4(r7_x_4, r7_y_5, r7_z_5, r7_x_4) + i.texcoord9.xyzx)).xyzx, float4(0, 0, 0, 0))).xyzx)).xyzx * float4(r3_x_2, r3_y_2, r3_z_3, r3_x_2));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                o.sv_Target2.xyz = (mad(float4(r4_x_6, r4_y_5, r4_z_5, r4_x_6), float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
                o.sv_Target3.xyz = (mad(float4(r5_x_4, r5_y_3, r5_z_3, r5_x_4), _EmissionColor.xyzx, float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5))).xyz;
                o.sv_Target0.xyzw = float4(r3_x_2, r3_y_2, r3_z_3, r3_w_3);
                o.sv_Target2.w = 1;
                o.sv_Target3.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="DEFERRED" "PerformanceChecks"="False" "QUEUE"="Geometry" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float _BumpScale : packoffset(c4.x);
                float _Metallic : packoffset(c4.y);
                float _Glossiness : packoffset(c4.z);
                float _OcclusionStrength : packoffset(c4.w);
                float _Cutoff : packoffset(c5.x);
                float4 _Color : packoffset(c6);
                float4 _EmissionColor : packoffset(c7);
                float4 _MainTex_ST : packoffset(c8);
                float4 _BumpMap_ST : packoffset(c9);
                float4 _MetallicGlossMap_ST : packoffset(c10);
                float4 _OcclusionMap_ST : packoffset(c11);
                float4 _EmissionMap_ST : packoffset(c12);
                float4 _DetailMask_ST : packoffset(c13);
                float4 _DetailAlbedo_ST : packoffset(c14);
                float4 _DetailNormal_ST : packoffset(c15);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            SamplerState sampler_EmissionMap;
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_DetailAlbedo;
            SamplerState sampler_DetailNormal;
            SamplerState sampler_BumpMap;
            SamplerState sampler_MetallicGlossMap;
            SamplerState sampler_DetailMask;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _MetallicGlossMap;
            Texture2D _OcclusionMap;
            Texture2D _EmissionMap;
            Texture2D _DetailMask;
            Texture2D _DetailAlbedo;
            Texture2D _DetailNormal;
            struct program67Input
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
            struct program67Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 color0 : COLOR0;
                float4 texcoord8 : TEXCOORD8;
            };
            struct program73Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 color0 : COLOR0;
                float4 texcoord8 : TEXCOORD8;
            };
            struct program73Output
            {
                float4 sv_Target0 : SV_Target;
                float4 sv_Target1 : SV_Target1;
                float4 sv_Target2 : SV_Target2;
                float4 sv_Target3 : SV_Target3;
            };
            #pragma vertex vert
            program67Output vert(program67Input i)
            {
                program67Output o = (program67Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                float3 worldPos_xyz_4 = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _MetallicGlossMap_ST.xyxx, _MetallicGlossMap_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _OcclusionMap_ST.xxxy, _OcclusionMap_ST.zzzw)).zw;
                o.texcoord2.xy = (mad(i.texcoord0.xyxx, _EmissionMap_ST.xyxx, _EmissionMap_ST.zwzz)).xy;
                o.texcoord2.zw = (mad(i.texcoord0.xxxy, _DetailMask_ST.xxxy, _DetailMask_ST.zzzw)).zw;
                o.texcoord3.xy = (mad(i.texcoord0.xyxx, _DetailAlbedo_ST.xyxx, _DetailAlbedo_ST.zwzz)).xy;
                o.texcoord3.zw = (mad(i.texcoord0.xxxy, _DetailNormal_ST.xxxy, _DetailNormal_ST.zzzw)).zw;
                o.texcoord4.w = worldPos_xyz_4.x;
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float3 unitWorldNormal_xyz_3 = (((rsqrt(dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2)))).xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = (((rsqrt(dot(worldTangent_xyz_6.xyzx, worldTangent_xyz_6.xyzx))).xxxx * worldTangent_xyz_6.xyzx)).xyz;
                float3 r3_xyz_3 = ((((i.tangent0.w * unity_WorldTransformParams.w)).xxxx * (mad(unitWorldNormal_xyz_3.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_3.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord4.y = r3_xyz_3.x;
                o.texcoord4.x = unitWorldTangent_xyz_7.z;
                o.texcoord4.z = unitWorldNormal_xyz_3.y;
                o.texcoord5.x = unitWorldTangent_xyz_7.x;
                o.texcoord6.x = unitWorldTangent_xyz_7.y;
                o.texcoord5.z = unitWorldNormal_xyz_3.z;
                o.texcoord6.z = unitWorldNormal_xyz_3.x;
                o.texcoord5.w = worldPos_xyz_4.y;
                o.texcoord6.w = worldPos_xyz_4.z;
                o.texcoord5.y = r3_xyz_3.y;
                o.texcoord6.y = r3_xyz_3.z;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord8.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program73Output frag(program73Input i)
            {
                program73Output o = (program73Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float r0_w_2 = mad(r0_xyzw_1.w, _Color.w, -_Cutoff);
                float3 r0_xyz_2 = ((r0_xyzw_1.xyzx * _Color.xyzx)).xyz;
                float r0_w_3 = (r0_w_2 < 0);
                if (r0_w_3) discard;
                float r0_w_4 = (_DetailAlbedo.Sample(sampler_DetailAlbedo, (i.texcoord1.zwzz).xy)).w;
                float r0_w_5 = (r0_w_4 + -1);
                o.sv_Target0.w = mad(_OcclusionStrength, r0_w_5, 1);
                float3 r1_xyz_1 = (_MetallicGlossMap.Sample(sampler_MetallicGlossMap, (i.texcoord3.xyxx).xy)).xyz;
                float r0_w_6 = (_BumpMap.Sample(sampler_BumpMap, (i.texcoord2.zwzz).xy)).w;
                float3 r1_xyz_3 = (mad(r0_w_6.xxxx, (mad(r1_xyz_1.xyzx, float4(2, 2, 2, 0), float4(-2, -2, -2, 0))).xyzx, float4(1, 1, 1, 0))).xyz;
                float2 r1_xy_4 = (_OcclusionMap.Sample(sampler_OcclusionMap, (i.texcoord1.xyxx).xy)).xy;
                float r1_x_5 = (r1_xy_4.x * _Metallic);
                o.sv_Target1.w = (r1_xy_4.y * _Glossiness);
                float r1_y_5 = mad(-r1_x_5, 0.96, 0.96);
                o.sv_Target1.xyz = (mad(r1_x_5.xxxx, (mad(r0_xyz_2.xyzx, r1_xyz_3.xyzx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                o.sv_Target0.xyz = ((r1_y_5.xxxx * ((r0_xyz_2.xyzx * r1_xyz_3.xyzx)).xyzx)).xyz;
                float3 r0_xyz_4 = (_EmissionMap.Sample(sampler_EmissionMap, (i.texcoord0.zwzz).xy)).xyz;
                float r0_x_5 = (r0_xyz_4.z * r0_xyz_4.x);
                float4 r0_xyzw_6 = mad(float4(r0_x_5, r0_xyz_4.y, r0_x_5, r0_x_5), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_5 = r0_xyzw_6.y;
                float4 r0_xyzw_7 = (float4(r0_x_6, r0_y_5, r0_x_6, r0_x_6) * _BumpScale.xxxx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_6 = r0_xyzw_7.y;
                float r0_z_5 = sqrt((min(dot(float4(r0_x_7, r0_y_6, r0_x_7, r0_x_7), float4(r0_x_7, r0_y_6, r0_x_7, r0_x_7)), 1) + 1));
                float4 r1_xyzw_9 = _DetailMask.Sample(sampler_DetailMask, (i.texcoord3.zwzz).xy);
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_6 = r1_xyzw_9.y;
                float r1_z_4 = r1_xyzw_9.z;
                float r1_x_10 = (r1_z_4 * r1_x_9);
                float4 r1_xyzw_11 = mad(float4(r1_x_10, r1_y_6, r1_x_10, r1_x_10), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_7 = r1_xyzw_11.y;
                float4 r1_xyzw_12 = (float4(r1_x_11, r1_y_7, r1_x_11, r1_x_11) * _BumpScale.xxxx);
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_8 = r1_xyzw_12.y;
                float r1_w_1 = dot(float4(r1_x_12, r1_y_8, r1_x_12, r1_x_12), float4(r1_x_12, r1_y_8, r1_x_12, r1_x_12));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r1_z_5 = sqrt(r1_w_3);
                float4 r0_xyzw_8 = mad(float4(r1_x_12, r1_y_8, r1_z_5, r1_x_12), r0_w_6.xxxx, float4(r0_x_7, r0_y_6, r0_z_5, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_7 = r0_xyzw_8.y;
                float r0_z_6 = r0_xyzw_8.z;
                float r0_w_7 = dot(float4(r0_x_8, r0_y_7, r0_z_6, r0_x_8), float4(r0_x_8, r0_y_7, r0_z_6, r0_x_8));
                float r0_w_8 = rsqrt(r0_w_7);
                float4 r0_xyzw_9 = (r0_w_8.xxxx * float4(r0_x_8, r0_y_7, r0_z_6, r0_x_8));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_8 = r0_xyzw_9.y;
                float r0_z_7 = r0_xyzw_9.z;
                float r1_x_13 = dot(i.texcoord4.xyzx, float4(r0_x_9, r0_y_8, r0_z_7, r0_x_9));
                float r1_y_9 = dot(i.texcoord5.xyzx, float4(r0_x_9, r0_y_8, r0_z_7, r0_x_9));
                float r1_z_6 = dot(i.texcoord6.xyzx, float4(r0_x_9, r0_y_8, r0_z_7, r0_x_9));
                float4 r0_xyzw_12 = ((rsqrt(dot(float4(r1_x_13, r1_y_9, r1_z_6, r1_x_13), float4(r1_x_13, r1_y_9, r1_z_6, r1_x_13)))).xxxx * float4(r1_x_13, r1_y_9, r1_z_6, r1_x_13));
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_9 = r0_xyzw_12.y;
                float r0_z_8 = r0_xyzw_12.z;
                o.sv_Target2.xyz = (mad(float4(r0_x_12, r0_y_9, r0_z_8, r0_x_12), float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
                o.sv_Target2.w = 1;
                float4 r0_xyzw_13 = _DetailNormal.Sample(sampler_DetailNormal, (i.texcoord2.xyxx).xy);
                float r0_x_13 = r0_xyzw_13.x;
                float r0_y_10 = r0_xyzw_13.y;
                float r0_z_9 = r0_xyzw_13.z;
                o.sv_Target3.xyz = ((float4(r0_x_13, r0_y_10, r0_z_9, r0_x_13) * _EmissionColor.xyzx)).xyz;
                o.sv_Target3.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="DEFERRED" "PerformanceChecks"="False" "QUEUE"="Geometry" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float _BumpScale : packoffset(c4.x);
                float _Metallic : packoffset(c4.y);
                float _Glossiness : packoffset(c4.z);
                float _OcclusionStrength : packoffset(c4.w);
                float _Cutoff : packoffset(c5.x);
                float4 _Color : packoffset(c6);
                float4 _EmissionColor : packoffset(c7);
                float4 _MainTex_ST : packoffset(c8);
                float4 _BumpMap_ST : packoffset(c9);
                float4 _MetallicGlossMap_ST : packoffset(c10);
                float4 _OcclusionMap_ST : packoffset(c11);
                float4 _EmissionMap_ST : packoffset(c12);
                float4 _DetailMask_ST : packoffset(c13);
                float4 _DetailAlbedo_ST : packoffset(c14);
                float4 _DetailNormal_ST : packoffset(c15);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
                float4 cb1_values[46];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[10];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[21];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_MainTex;
            SamplerState sampler_EmissionMap;
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_DetailAlbedo;
            SamplerState sampler_DetailNormal;
            SamplerState sampler_BumpMap;
            SamplerState sampler_MetallicGlossMap;
            SamplerState sampler_DetailMask;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _MetallicGlossMap;
            Texture2D _OcclusionMap;
            Texture2D _EmissionMap;
            Texture2D _DetailMask;
            Texture2D _DetailAlbedo;
            Texture2D _DetailNormal;
            Texture3D t8;
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
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 color0 : COLOR0;
                float4 texcoord8 : TEXCOORD8;
                float3 texcoord9 : TEXCOORD9;
            };
            struct program72Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 color0 : COLOR0;
                float4 texcoord8 : TEXCOORD8;
                float3 texcoord9 : TEXCOORD9;
            };
            struct program72Output
            {
                float4 sv_Target0 : SV_Target;
                float4 sv_Target1 : SV_Target1;
                float4 sv_Target2 : SV_Target2;
                float4 sv_Target3 : SV_Target3;
            };
            #pragma vertex vert
            program66Output vert(program66Input i)
            {
                program66Output o = (program66Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float3 r0_xyz_4 = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _MetallicGlossMap_ST.xyxx, _MetallicGlossMap_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _OcclusionMap_ST.xxxy, _OcclusionMap_ST.zzzw)).zw;
                o.texcoord2.xy = (mad(i.texcoord0.xyxx, _EmissionMap_ST.xyxx, _EmissionMap_ST.zwzz)).xy;
                o.texcoord2.zw = (mad(i.texcoord0.xxxy, _DetailMask_ST.xxxy, _DetailMask_ST.zzzw)).zw;
                o.texcoord3.xy = (mad(i.texcoord0.xyxx, _DetailAlbedo_ST.xyxx, _DetailAlbedo_ST.zwzz)).xy;
                o.texcoord3.zw = (mad(i.texcoord0.xxxy, _DetailNormal_ST.xxxy, _DetailNormal_ST.zzzw)).zw;
                o.texcoord4.w = r0_xyz_4.x;
                float3 worldTangent_xyz_2 = ((i.tangent0.yyyy * cb2_values[1].yzxy)).xyz;
                float3 worldTangent_xyz_3 = (mad(cb2_values[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_2.xyzx)).xyz;
                float3 worldTangent_xyz_4 = (mad(cb2_values[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_3.xyzx)).xyz;
                float3 unitWorldTangent_xyz_5 = (((rsqrt(dot(worldTangent_xyz_4.xyzx, worldTangent_xyz_4.xyzx))).xxxx * worldTangent_xyz_4.xyzx)).xyz;
                o.texcoord4.x = unitWorldTangent_xyz_5.z;
                float worldNormal_x_4 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float4 unitWorldNormal_xyzw_5 = ((rsqrt(dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4)))).xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_z_4));
                float3 r3_xyz_3 = ((((i.tangent0.w * cb2_values[9].w)).xxxx * (mad(unitWorldNormal_xyzw_5.ywxy, unitWorldTangent_xyz_5.yzxy, ((unitWorldTangent_xyz_5.xyzx * unitWorldNormal_xyzw_5.wxyw)).xyzx)).xyzx)).xyz;
                o.texcoord4.y = r3_xyz_3.x;
                o.texcoord4.z = unitWorldNormal_xyzw_5.x;
                o.texcoord5.x = unitWorldTangent_xyz_5.x;
                o.texcoord6.x = unitWorldTangent_xyz_5.y;
                o.texcoord5.w = r0_xyz_4.y;
                o.texcoord6.w = r0_xyz_4.z;
                o.texcoord5.y = r3_xyz_3.y;
                o.texcoord6.y = r3_xyz_3.z;
                o.texcoord5.z = unitWorldNormal_xyzw_5.y;
                o.texcoord6.z = unitWorldNormal_xyzw_5.w;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord8.xyzw = float4(0, 0, 0, 0);
                float4 r1_xyzw_6 = (unitWorldNormal_xyzw_5.ywzx * unitWorldNormal_xyzw_5);
                float r2_x_6 = dot(cb1_values[42].xyzw, r1_xyzw_6);
                float r2_y_6 = dot(cb1_values[43].xyzw, r1_xyzw_6);
                float r2_z_6 = dot(cb1_values[44].xyzw, r1_xyzw_6);
                o.texcoord9.xyz = (mad(cb1_values[45].xyzx, (mad(unitWorldNormal_xyzw_5.x, unitWorldNormal_xyzw_5.x, (unitWorldNormal_xyzw_5.y * unitWorldNormal_xyzw_5.y))).xxxx, float4(r2_x_6, r2_y_6, r2_z_6, r2_x_6))).xyz;
                return o;
            }
            #pragma fragment frag
            program72Output frag(program72Input i)
            {
                program72Output o = (program72Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r0_xyz_2 = ((r0_xyzw_1.xyzx * _Color.xyzx)).xyz;
                float r1_x_1 = (_BumpMap.Sample(sampler_BumpMap, (i.texcoord2.zwzz).xy)).x;
                float3 r1_yzw_1 = (_MetallicGlossMap.Sample(sampler_MetallicGlossMap, (i.texcoord3.xyxx).xy)).yzw;
                float3 r1_yzw_2 = (mad(r1_yzw_1.xxyz, float4(0, 2, 2, 2), float4(0, -2, -2, -2))).yzw;
                float3 r1_yzw_3 = (mad(r1_x_1.xxxx, r1_yzw_2.xxyz, float4(0, 1, 1, 1))).yzw;
                float2 r3_xy_1 = (_OcclusionMap.Sample(sampler_OcclusionMap, (i.texcoord1.xyxx).xy)).xy;
                float3 r4_xyz_1 = (_EmissionMap.Sample(sampler_EmissionMap, (i.texcoord0.zwzz).xy)).xyz;
                float r4_x_2 = (r4_xyz_1.z * r4_xyz_1.x);
                float2 r3_zw_1 = (mad(float4(r4_x_2, r4_x_2, r4_x_2, r4_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r4_xyzw_3 = (r3_zw_1.xyxx * _BumpScale.xxxx);
                float r4_x_3 = r4_xyzw_3.x;
                float r4_y_2 = r4_xyzw_3.y;
                float r2_w_1 = dot(float4(r4_x_3, r4_y_2, r4_x_3, r4_x_3), float4(r4_x_3, r4_y_2, r4_x_3, r4_x_3));
                float r2_w_2 = min(r2_w_1, 1);
                float r2_w_3 = (-r2_w_2 + 1);
                float r4_z_2 = sqrt(r2_w_3);
                float3 r5_xyz_1 = (_DetailMask.Sample(sampler_DetailMask, (i.texcoord3.zwzz).xy)).xyz;
                float r5_x_2 = (r5_xyz_1.z * r5_xyz_1.x);
                float2 r3_zw_2 = (mad(float4(r5_x_2, r5_x_2, r5_x_2, r5_xyz_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r5_xyzw_3 = (r3_zw_2.xyxx * _BumpScale.xxxx);
                float r5_x_3 = r5_xyzw_3.x;
                float r5_y_2 = r5_xyzw_3.y;
                float r2_w_4 = dot(float4(r5_x_3, r5_y_2, r5_x_3, r5_x_3), float4(r5_x_3, r5_y_2, r5_x_3, r5_x_3));
                float r2_w_5 = min(r2_w_4, 1);
                float r2_w_6 = (-r2_w_5 + 1);
                float r5_z_2 = sqrt(r2_w_6);
                float4 r4_xyzw_4 = mad(float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3), r1_x_1.xxxx, float4(r4_x_3, r4_y_2, r4_z_2, r4_x_3));
                float r4_x_4 = r4_xyzw_4.x;
                float r4_y_3 = r4_xyzw_4.y;
                float r4_z_3 = r4_xyzw_4.z;
                float4 r4_xyzw_5 = ((rsqrt(dot(float4(r4_x_4, r4_y_3, r4_z_3, r4_x_4), float4(r4_x_4, r4_y_3, r4_z_3, r4_x_4)))).xxxx * float4(r4_x_4, r4_y_3, r4_z_3, r4_x_4));
                float r4_x_5 = r4_xyzw_5.x;
                float r4_y_4 = r4_xyzw_5.y;
                float r4_z_4 = r4_xyzw_5.z;
                float r1_x_4 = (r3_xy_1.x * _Metallic);
                o.sv_Target1.w = (r3_xy_1.y * _Glossiness);
                float r2_w_7 = (_DetailAlbedo.Sample(sampler_DetailAlbedo, (i.texcoord1.zwzz).xy)).w;
                float r2_w_8 = (r2_w_7 + -1);
                float r3_w_3 = mad(_OcclusionStrength, r2_w_8, 1);
                float4 r5_xyzw_4 = _DetailNormal.Sample(sampler_DetailNormal, (i.texcoord2.xyxx).xy);
                float r5_x_4 = r5_xyzw_4.x;
                float r5_y_3 = r5_xyzw_4.y;
                float r5_z_3 = r5_xyzw_4.z;
                float r0_w_2 = mad(r0_xyzw_1.w, _Color.w, -_Cutoff);
                float r0_w_3 = (r0_w_2 < 0);
                if (r0_w_3) discard;
                float r6_x_1 = dot(i.texcoord4.xyzx, float4(r4_x_5, r4_y_4, r4_z_4, r4_x_5));
                float r6_y_1 = dot(i.texcoord5.xyzx, float4(r4_x_5, r4_y_4, r4_z_4, r4_x_5));
                float r6_z_1 = dot(i.texcoord6.xyzx, float4(r4_x_5, r4_y_4, r4_z_4, r4_x_5));
                float r0_w_4 = dot(float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1), float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float r0_w_5 = rsqrt(r0_w_4);
                float4 r4_xyzw_6 = (r0_w_5.xxxx * float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float r4_x_6 = r4_xyzw_6.x;
                float r4_y_5 = r4_xyzw_6.y;
                float r4_z_5 = r4_xyzw_6.z;
                float r0_w_6 = (cb2_values[0].x == 1);
                float r7_x_4;
                float r7_y_5;
                float r7_z_5;
                if (r0_w_6)
                {
                    float r0_w_7 = (cb2_values[0].y == 1);
                    float3 r6_xyz_5 = (((mad(cb2_values[3].xyzx, i.texcoord6.wwww, (mad(cb2_values[1].xyzx, i.texcoord4.wwww, ((i.texcoord5.wwww * cb2_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb2_values[4].xyzx)).xyz;
                    float TEXCOORD4_y_2 = i.texcoord4.w;
                    float TEXCOORD5_z_2 = i.texcoord5.w;
                    float TEXCOORD6_w_1 = i.texcoord6.w;
                    float4 r6_xyzw_8 = (((((r0_w_7.xxxx ? r6_xyz_5.xyzx : float4(TEXCOORD4_y_2, TEXCOORD5_z_2, TEXCOORD6_w_1, TEXCOORD4_y_2))).xyzx + -cb2_values[6].xyzx)).xxyz * cb2_values[5].xxyz);
                    float r6_y_8 = r6_xyzw_8.y;
                    float r6_z_8 = r6_xyzw_8.z;
                    float r6_w_1 = r6_xyzw_8.w;
                    float r0_w_8 = (r6_y_8 * 0.25);
                    float r2_w_9 = (cb2_values[0].z * 0.5);
                    float r5_w_1 = mad(-cb2_values[0].z, 0.5, 0.25);
                    float r0_w_9 = max(r0_w_8, r2_w_9);
                    float r6_x_8 = min(r5_w_1, r0_w_9);
                    float4 r7_xyzw_2 = t8.Sample(sampler_linear_clamp, (float4(r6_x_8, r6_z_8, r6_w_1, r6_x_8)).xyz);
                    float4 r8_xyzw_2 = t8.Sample(sampler_linear_clamp, (((float4(r6_x_8, r6_z_8, r6_w_1, r6_x_8) + float4(0.25, 0, 0, 0))).xyzx).xyz);
                    float4 r6_xyzw_10 = t8.Sample(sampler_linear_clamp, (((float4(r6_x_8, r6_z_8, r6_w_1, r6_x_8) + float4(0.5, 0, 0, 0))).xyzx).xyz);
                    float r4_w_2 = 1;
                    float r7_x_3 = dot(r7_xyzw_2, float4(r4_x_6, r4_y_5, r4_z_5, r4_w_2));
                    float r7_y_4 = dot(r8_xyzw_2, float4(r4_x_6, r4_y_5, r4_z_5, r4_w_2));
                    float r7_z_4 = dot(r6_xyzw_10, float4(r4_x_6, r4_y_5, r4_z_5, r4_w_2));
                    r7_x_4 = r7_x_3;
                    r7_y_5 = r7_y_4;
                    r7_z_5 = r7_z_4;
                }
                else
                {
                    float r4_w_1 = 1;
                    float r7_x_1 = dot(cb1_values[39].xyzw, float4(r4_x_6, r4_y_5, r4_z_5, r4_w_1));
                    float r7_y_1 = dot(cb1_values[40].xyzw, float4(r4_x_6, r4_y_5, r4_z_5, r4_w_1));
                    float r7_z_1 = dot(cb1_values[41].xyzw, float4(r4_x_6, r4_y_5, r4_z_5, r4_w_1));
                    r7_x_4 = r7_x_1;
                    r7_y_5 = r7_y_1;
                    r7_z_5 = r7_z_1;
                }
                o.sv_Target1.xyz = (mad(r1_x_4.xxxx, (mad(r0_xyz_2.xyzx, r1_yzw_3.xyzx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float4 r3_xyzw_2 = ((mad(-r1_x_4, 0.96, 0.96)).xxxx * ((r0_xyz_2.xyzx * r1_yzw_3.xyzx)).xyzx);
                float r3_x_2 = r3_xyzw_2.x;
                float r3_y_2 = r3_xyzw_2.y;
                float r3_z_3 = r3_xyzw_2.z;
                float4 r0_xyzw_5 = (((r3_w_3.xxxx * (max(((float4(r7_x_4, r7_y_5, r7_z_5, r7_x_4) + i.texcoord9.xyzx)).xyzx, float4(0, 0, 0, 0))).xyzx)).xyzx * float4(r3_x_2, r3_y_2, r3_z_3, r3_x_2));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                o.sv_Target2.xyz = (mad(float4(r4_x_6, r4_y_5, r4_z_5, r4_x_6), float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
                float4 r0_xyzw_6 = mad(float4(r5_x_4, r5_y_3, r5_z_3, r5_x_4), _EmissionColor.xyzx, float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_5 = r0_xyzw_6.y;
                float r0_z_5 = r0_xyzw_6.z;
                o.sv_Target3.xyz = (exp2(-float4(r0_x_6, r0_y_5, r0_z_5, r0_x_6))).xyz;
                o.sv_Target0.xyzw = float4(r3_x_2, r3_y_2, r3_z_3, r3_w_3);
                o.sv_Target2.w = 1;
                o.sv_Target3.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="SHADOWCASTER" "PerformanceChecks"="False" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float _Cutoff : packoffset(c5.x);
                float4 _Color : packoffset(c6);
                float4 _MainTex_ST : packoffset(c8);
            };
            cbuffer _UnityLightingCB_b1
            {
                float4 _WorldSpaceLightPos0 : packoffset(c0);
            };
            cbuffer _UnityShadowsCB_b2
            {
                float4 unity_LightShadowBias : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b3
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b4
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program76Input
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
            struct program76Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program79Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program79Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program76Output vert(program76Input i)
            {
                program76Output o = (program76Output)0;
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
                float3 r2_xyz_1 = (mad(-worldPos_xyzw_4.xyzx, _WorldSpaceLightPos0.wwww, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r2_xyz_1.xyzx, r2_xyz_1.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_w_5 = dot(unitWorldNormal_xyz_2.xyzx, ((r0_w_4.xxxx * r2_xyz_1.xyzx)).xyzx);
                float r0_w_6 = mad(-r0_w_5, r0_w_5, 1);
                float r0_w_7 = sqrt(r0_w_6);
                float r0_w_8 = (r0_w_7 * unity_LightShadowBias.z);
                float r0_w_9 = (unity_LightShadowBias.z != 0);
                float3 unity_LightShadowBiasSelect_xyz_4 = ((r0_w_9.xxxx ? (mad(-unitWorldNormal_xyz_2.xyzx, r0_w_8.xxxx, worldPos_xyzw_4.xyzx)).xyzx : worldPos_xyzw_4.xyzx)).xyz;
                float4 r2_xyzw_3 = (unity_LightShadowBiasSelect_xyz_4.yyyy * unity_MatrixVP[1]);
                float4 r2_xyzw_4 = mad(unity_MatrixVP[0], unity_LightShadowBiasSelect_xyz_4.xxxx, r2_xyzw_3);
                float4 r0_xyzw_5 = mad(unity_MatrixVP[2], unity_LightShadowBiasSelect_xyz_4.zzzz, r2_xyzw_4);
                float4 r0_xyzw_6 = mad(unity_MatrixVP[3], worldPos_xyzw_4.wwww, r0_xyzw_5);
                float r0_z_7 = (r0_xyzw_6.z + max(min((unity_LightShadowBias.x / r0_xyzw_6.w), 0), -1));
                o.sv_Position0.xyw = (r0_xyzw_6.xyxw).xyw;
                o.sv_Position0.z = mad(unity_LightShadowBias.y, (-r0_z_7 + min(r0_xyzw_6.w, r0_z_7)), r0_z_7);
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float4 worldPos_xyzw_8 = (i.position0.yyyy * unity_ObjectToWorld[1].xyzx);
                float worldPos_x_8 = worldPos_xyzw_8.x;
                float worldPos_y_7 = worldPos_xyzw_8.y;
                float worldPos_z_8 = worldPos_xyzw_8.z;
                float4 worldPos_xyzw_9 = mad(unity_ObjectToWorld[0].xyzx, i.position0.xxxx, float4(worldPos_x_8, worldPos_y_7, worldPos_z_8, worldPos_x_8));
                float worldPos_x_9 = worldPos_xyzw_9.x;
                float worldPos_y_8 = worldPos_xyzw_9.y;
                float worldPos_z_9 = worldPos_xyzw_9.z;
                float4 worldPos_xyzw_10 = mad(unity_ObjectToWorld[2].xyzx, i.position0.zzzz, float4(worldPos_x_9, worldPos_y_8, worldPos_z_9, worldPos_x_9));
                float worldPos_x_10 = worldPos_xyzw_10.x;
                float worldPos_y_9 = worldPos_xyzw_10.y;
                float worldPos_z_10 = worldPos_xyzw_10.z;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, float4(worldPos_x_10, worldPos_y_9, worldPos_z_10, worldPos_x_10))).xyz;
                return o;
            }
            #pragma fragment frag
            program79Output frag(program79Input i)
            {
                program79Output o = (program79Output)0;
                float r0_x_1 = (_MainTex.Sample(sampler_MainTex, (i.texcoord1.xyxx).xy)).x;
                if ((mad(r0_x_1, _Color.w, -_Cutoff) < 0)) discard;
                o.sv_Target0.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="SHADOWCASTER" "PerformanceChecks"="False" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float _Cutoff : packoffset(c5.x);
                float4 _Color : packoffset(c6);
                float4 _MainTex_ST : packoffset(c8);
            };
            cbuffer _UnityLightingCB_b1
            {
                float4 _WorldSpaceLightPos0 : packoffset(c0);
            };
            cbuffer _UnityShadowsCB_b2
            {
                float4 unity_LightShadowBias : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b3
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b4
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program77Input
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
            struct program77Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program80Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program80Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program77Output vert(program77Input i)
            {
                program77Output o = (program77Output)0;
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
                float3 r2_xyz_1 = (mad(-worldPos_xyzw_4.xyzx, _WorldSpaceLightPos0.wwww, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r2_xyz_1.xyzx, r2_xyz_1.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_w_5 = dot(unitWorldNormal_xyz_2.xyzx, ((r0_w_4.xxxx * r2_xyz_1.xyzx)).xyzx);
                float r0_w_6 = mad(-r0_w_5, r0_w_5, 1);
                float r0_w_7 = sqrt(r0_w_6);
                float r0_w_8 = (r0_w_7 * unity_LightShadowBias.z);
                float r0_w_9 = (unity_LightShadowBias.z != 0);
                float3 unity_LightShadowBiasSelect_xyz_4 = ((r0_w_9.xxxx ? (mad(-unitWorldNormal_xyz_2.xyzx, r0_w_8.xxxx, worldPos_xyzw_4.xyzx)).xyzx : worldPos_xyzw_4.xyzx)).xyz;
                float4 r2_xyzw_3 = (unity_LightShadowBiasSelect_xyz_4.yyyy * unity_MatrixVP[1]);
                float4 r2_xyzw_4 = mad(unity_MatrixVP[0], unity_LightShadowBiasSelect_xyz_4.xxxx, r2_xyzw_3);
                float4 r0_xyzw_5 = mad(unity_MatrixVP[2], unity_LightShadowBiasSelect_xyz_4.zzzz, r2_xyzw_4);
                float4 r0_xyzw_6 = mad(unity_MatrixVP[3], worldPos_xyzw_4.wwww, r0_xyzw_5);
                o.sv_Position0.z = mad(unity_LightShadowBias.y, (-r0_xyzw_6.z + min(r0_xyzw_6.w, r0_xyzw_6.z)), r0_xyzw_6.z);
                o.sv_Position0.xyw = (r0_xyzw_6.xyxw).xyw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float3 worldPos_xyz_7 = ((i.position0.yyyy * unity_ObjectToWorld[1].xyzx)).xyz;
                float3 worldPos_xyz_8 = (mad(unity_ObjectToWorld[0].xyzx, i.position0.xxxx, worldPos_xyz_7.xyzx)).xyz;
                float3 worldPos_xyz_9 = (mad(unity_ObjectToWorld[2].xyzx, i.position0.zzzz, worldPos_xyz_8.xyzx)).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyz_9.xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program80Output frag(program80Input i)
            {
                program80Output o = (program80Output)0;
                float r0_x_1 = (_MainTex.Sample(sampler_MainTex, (i.texcoord1.xyxx).xy)).x;
                if ((mad(r0_x_1, _Color.w, -_Cutoff) < 0)) discard;
                o.sv_Target0.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Standard"
}
