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
    }
    Fallback "Standard"
}
