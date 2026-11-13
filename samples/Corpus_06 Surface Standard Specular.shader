Shader "Corpus/06 Surface Standard Specular"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo", 2D) = "" {}
        _BumpMap ("Normal", 2D) = "" {}
        _SpecColor ("Specular", Color) = (0.2,0.2,0.2,1)
        _SpecGlossMap ("Specular Map", 2D) = "" {}
        _Glossiness ("Smoothness", Range(0, 1)) = 0.5
        _OcclusionMap ("Occlusion", 2D) = "" {}
        _EmissionColor ("Emission", Color) = (0,0,0,1)
    }
    SubShader
    {
        Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
        LOD 300
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
                float4 _SpecColor : packoffset(c3);
                float4 _Color : packoffset(c4);
                float4 _EmissionColor : packoffset(c5);
                float _Glossiness : packoffset(c6.x);
                float4 _MainTex_ST : packoffset(c7);
                float4 _BumpMap_ST : packoffset(c8);
                float4 _SpecGlossMap_ST : packoffset(c9);
                float4 _OcclusionMap_ST : packoffset(c10);
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
            SamplerState sampler_SpecGlossMap;
            SamplerState sampler_BumpMap;
            SamplerState sampler_OcclusionMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _SpecGlossMap;
            Texture2D _OcclusionMap;
            TextureCube t4;
            TextureCube t5;
            Texture3D t6;
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
                float4 texcoord7 : TEXCOORD7;
                float4 texcoord8 : TEXCOORD8;
            };
            struct program30Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord7 : TEXCOORD7;
                float4 texcoord8 : TEXCOORD8;
            };
            struct program30Output
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
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _SpecGlossMap_ST.xyxx, _SpecGlossMap_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _OcclusionMap_ST.xxxy, _OcclusionMap_ST.zzzw)).zw;
                o.texcoord2.w = worldPos_xyz_4.x;
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float3 unitWorldNormal_xyz_3 = (((rsqrt(dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2)))).xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = (((rsqrt(dot(worldTangent_xyz_6.xyzx, worldTangent_xyz_6.xyzx))).xxxx * worldTangent_xyz_6.xyzx)).xyz;
                float3 r3_xyz_3 = ((((i.tangent0.w * unity_WorldTransformParams.w)).xxxx * (mad(unitWorldNormal_xyz_3.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_3.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord2.y = r3_xyz_3.x;
                o.texcoord2.x = unitWorldTangent_xyz_7.z;
                o.texcoord2.z = unitWorldNormal_xyz_3.y;
                o.texcoord3.x = unitWorldTangent_xyz_7.x;
                o.texcoord4.x = unitWorldTangent_xyz_7.y;
                o.texcoord3.z = unitWorldNormal_xyz_3.z;
                o.texcoord4.z = unitWorldNormal_xyz_3.x;
                o.texcoord3.w = worldPos_xyz_4.y;
                o.texcoord4.w = worldPos_xyz_4.z;
                o.texcoord3.y = r3_xyz_3.y;
                o.texcoord4.y = r3_xyz_3.z;
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                o.texcoord8.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program30Output frag(program30Input i)
            {
                program30Output o = (program30Output)0;
                float TEXCOORD2_x_1 = i.texcoord2.w;
                float TEXCOORD3_y_1 = i.texcoord3.w;
                float TEXCOORD4_z_1 = i.texcoord4.w;
                float3 viewDir_xyz_1 = ((-float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float3 r3_xyz_1 = (_MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy)).xyz;
                float3 r3_xyz_2 = ((r3_xyz_1.xyzx * _Color.xyzx)).xyz;
                float4 r4_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord1.xyxx).xy);
                float3 r5_xyz_1 = (_SpecGlossMap.Sample(sampler_SpecGlossMap, (i.texcoord0.zwzz).xy)).xyz;
                float r5_x_2 = (r5_xyz_1.z * r5_xyz_1.x);
                float4 r5_xyzw_3 = mad(float4(r5_x_2, r5_xyz_1.y, r5_x_2, r5_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r5_x_3 = r5_xyzw_3.x;
                float r5_y_2 = r5_xyzw_3.y;
                float r1_w_1 = dot(float4(r5_x_3, r5_y_2, r5_x_3, r5_x_3), float4(r5_x_3, r5_y_2, r5_x_3, r5_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r5_z_2 = sqrt(r1_w_3);
                float3 r6_xyz_1 = ((r4_xyzw_1.xyzx * _SpecColor.xyzx)).xyz;
                float r1_w_4 = (_OcclusionMap.Sample(sampler_OcclusionMap, (i.texcoord1.zwzz).xy)).w;
                float r2_w_1 = (unity_ProbeVolumeParams.x == 1);
                float r7_x_10;
                float r7_y_10;
                float r7_z_10;
                float r7_w_4;
                if (r2_w_1)
                {
                    float r2_w_2 = (unity_ProbeVolumeParams.y == 1);
                    float3 r7_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord4.wwww, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.wwww, ((i.texcoord3.wwww * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r2_w_2.xxxx ? r7_xyz_5.xyzx : float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1))).xyz;
                    float4 r7_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r7_y_8 = r7_xyzw_8.y;
                    float r7_z_8 = r7_xyzw_8.z;
                    float r7_w_2 = r7_xyzw_8.w;
                    float r2_w_3 = mad(r7_y_8, 0.25, 0.75);
                    float r3_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r7_x_8 = max(r2_w_3, r3_w_1);
                    float4 r7_xyzw_9 = t6.Sample(sampler_linear_clamp1, (float4(r7_x_8, r7_z_8, r7_w_2, r7_x_8)).xyz);
                    r7_x_10 = r7_xyzw_9.x;
                    r7_y_10 = r7_xyzw_9.y;
                    r7_z_10 = r7_xyzw_9.z;
                    r7_w_4 = r7_xyzw_9.w;
                }
                else
                {
                    float4 r7_xyzw_10 = float4(1, 1, 1, 1);
                    r7_x_10 = r7_xyzw_10.x;
                    r7_y_10 = r7_xyzw_10.y;
                    r7_z_10 = r7_xyzw_10.z;
                    r7_w_4 = r7_xyzw_10.w;
                }
                float r2_w_5 = saturate(dot(float4(r7_x_10, r7_y_10, r7_z_10, r7_w_4), unity_OcclusionMaskSelector));
                float r7_x_11 = dot(i.texcoord2.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float r7_y_11 = dot(i.texcoord3.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float r7_z_11 = dot(i.texcoord4.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float r3_w_3 = dot(float4(r7_x_11, r7_y_11, r7_z_11, r7_x_11), float4(r7_x_11, r7_y_11, r7_z_11, r7_x_11));
                float r3_w_4 = rsqrt(r3_w_3);
                float4 r5_xyzw_4 = (r3_w_4.xxxx * float4(r7_x_11, r7_y_11, r7_z_11, r7_x_11));
                float r5_x_4 = r5_xyzw_4.x;
                float r5_y_3 = r5_xyzw_4.y;
                float r5_z_3 = r5_xyzw_4.z;
                float r3_w_5 = mad(-_Glossiness, r4_xyzw_1.w, 1);
                float r5_w_1 = dot(-unitViewDir_xyz_1.xyzx, float4(r5_x_4, r5_y_3, r5_z_3, r5_x_4));
                float r5_w_2 = (r5_w_1 + r5_w_1);
                float3 r7_xyz_12 = (mad(float4(r5_x_4, r5_y_3, r5_z_3, r5_x_4), -r5_w_2.xxxx, -unitViewDir_xyz_1.xyzx)).xyz;
                float3 r8_xyz_1 = ((r2_w_5.xxxx * _LightColor0.xyzx)).xyz;
                float r2_w_6 = (0 < unity_SpecCube0_ProbePosition.w);
                float3 r9_xyz_4;
                if (r2_w_6)
                {
                    float3 r9_xyz_2 = normalize(r7_xyz_12);
                    float3 r12_xyz_1 = ((float4(0, 0, 0, 0) < r9_xyz_2.xyzx)).xyz;
                    float3 r10_xyz_3 = ((r12_xyz_1.xyzx ? ((((-float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + unity_SpecCube0_BoxMax.xyzx)).xyzx / r9_xyz_2.xyzx)).xyzx : ((((-float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + unity_SpecCube0_BoxMin.xyzx)).xyzx / r9_xyz_2.xyzx)).xyzx)).xyz;
                    float r2_w_9 = min(r10_xyz_3.y, r10_xyz_3.x);
                    float r2_w_10 = min(r10_xyz_3.z, r2_w_9);
                    r9_xyz_4 = (mad(r9_xyz_2.xyzx, r2_w_10.xxxx, ((float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + -unity_SpecCube0_ProbePosition.xyzx)).xyzx)).xyz;
                }
                else
                {
                    r9_xyz_4 = r7_xyz_12.xyz;
                }
                float r2_w_12 = mad(-r3_w_5, 0.7, 1.7);
                float r2_w_13 = (r2_w_12 * r3_w_5);
                float r2_w_14 = (r2_w_13 * 6);
                float4 r9_xyzw_5 = t4.SampleLevel(sampler_linear_clamp, r9_xyz_4.xyz, r2_w_14);
                float r5_w_3 = (r9_xyzw_5.w + -1);
                float r5_w_4 = mad(unity_SpecCube0_HDR.w, r5_w_3, 1);
                float r5_w_5 = log2(r5_w_4);
                float r5_w_6 = (r5_w_5 * unity_SpecCube0_HDR.y);
                float r5_w_7 = exp2(r5_w_6);
                float r5_w_8 = (r5_w_7 * unity_SpecCube0_HDR.x);
                float r6_w_1 = (unity_SpecCube0_BoxMin.w < 0.99999);
                float3 r10_xyz_8 = ((r9_xyzw_5.xyzx * r5_w_8.xxxx)).xyz;
                if (r6_w_1)
                {
                    float r6_w_2 = (0 < unity_SpecCube1_ProbePosition.w);
                    float3 r7_xyz_14 = r7_xyz_12;
                    if (r6_w_2)
                    {
                        float3 r11_xyz_4 = normalize(r7_xyz_12);
                        float3 r14_xyz_1 = ((float4(0, 0, 0, 0) < r11_xyz_4.xyzx)).xyz;
                        float3 r12_xyz_5 = ((r14_xyz_1.xyzx ? ((((-float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + unity_SpecCube1_BoxMax.xyzx)).xyzx / r11_xyz_4.xyzx)).xyzx : ((((-float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + unity_SpecCube1_BoxMin.xyzx)).xyzx / r11_xyz_4.xyzx)).xyzx)).xyz;
                        float r6_w_5 = min(r12_xyz_5.y, r12_xyz_5.x);
                        float r6_w_6 = min(r12_xyz_5.z, r6_w_5);
                        r7_xyz_14 = (mad(r11_xyz_4.xyzx, r6_w_6.xxxx, ((float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + -unity_SpecCube1_ProbePosition.xyzx)).xyzx)).xyz;
                    }
                    float4 r7_xyzw_15 = t5.SampleLevel(sampler_linear_clamp, r7_xyz_14.xyz, r2_w_14);
                                        float4 r0_xyzw_10 = (r7_xyzw_15.xyzx * ((pow(mad(unity_SpecCube1_HDR.w, (r7_xyzw_15.w + -1), 1), unity_SpecCube1_HDR.y) * unity_SpecCube1_HDR.x)).xxxx);
                    float r0_x_10 = r0_xyzw_10.x;
                    float r0_y_4 = r0_xyzw_10.y;
                    float r0_z_4 = r0_xyzw_10.z;
                    r10_xyz_8 = (mad(unity_SpecCube0_BoxMin.wwww, (mad(r5_w_8.xxxx, r9_xyzw_5.xyzx, -float4(r0_x_10, r0_y_4, r0_z_4, r0_x_10))).xyzx, float4(r0_x_10, r0_y_4, r0_z_4, r0_x_10))).xyz;
                }
                float4 r0_xyzw_12 = (r1_w_4.xxxx * r10_xyz_8.xyzx);
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_6 = r0_xyzw_12.y;
                float r0_z_6 = r0_xyzw_12.z;
                float r1_w_5 = max(r6_xyz_1.y, r6_xyz_1.x);
                float r1_w_6 = max(r6_xyz_1.z, r1_w_5);
                float r1_w_7 = (-r1_w_6 + 1);
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r1_xyz_3 = ((r0_w_5.xxxx * r1_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r5_x_4, r5_y_3, r5_z_3, r5_x_4), unitViewDir_xyz_1.xyzx);
                float r2_x_2 = saturate(dot(float4(r5_x_4, r5_y_3, r5_z_3, r5_x_4), _WorldSpaceLightPos0.xyzx));
                float r2_y_2 = saturate(dot(float4(r5_x_4, r5_y_3, r5_z_3, r5_x_4), r1_xyz_3.xyzx));
                float r1_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r1_xyz_3.xyzx));
                float r1_y_4 = (r1_x_4 * r1_x_4);
                float r1_y_5 = dot(r1_y_4.xxxx, r3_w_5.xxxx);
                float r1_y_6 = (r1_y_5 + -0.5);
                float r1_z_4 = (-r2_x_2 + 1);
                float r2_z_2 = (r1_z_4 * r1_z_4);
                float r2_z_3 = (r2_z_2 * r2_z_2);
                float r1_z_5 = (r1_z_4 * r2_z_3);
                float r1_z_6 = mad(r1_y_6, r1_z_5, 1);
                float r2_z_4 = (-abs(r0_w_6) + 1);
                float r2_w_15 = (r2_z_4 * r2_z_4);
                float r2_w_16 = (r2_w_15 * r2_w_15);
                float r2_z_5 = (r2_z_4 * r2_w_16);
                float r1_y_7 = mad(r1_y_6, r2_z_5, 1);
                float r1_y_8 = (r1_y_7 * r1_z_6);
                float r1_y_9 = (r2_x_2 * r1_y_8);
                float r1_z_7 = (r3_w_5 * r3_w_5);
                float r1_z_8 = max(r1_z_7, 0.002);
                float r2_w_17 = (-r1_z_8 + 1);
                float r3_w_6 = mad(abs(r0_w_6), r2_w_17, r1_z_8);
                float r2_w_18 = mad(r2_x_2, r2_w_17, r1_z_8);
                float r0_w_7 = (abs(r0_w_6) * r2_w_18);
                float r0_w_8 = mad(r2_x_2, r3_w_6, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r2_w_19 = (r1_z_8 * r1_z_8);
                float r3_w_7 = mad(r2_y_2, r2_w_19, -r2_y_2);
                float r2_y_3 = mad(r3_w_7, r2_y_2, 1);
                float r2_w_20 = (r2_w_19 * 0.31830987);
                float r2_y_4 = mad(r2_y_3, r2_y_3, 1E-07);
                float r2_y_5 = (r2_w_20 / r2_y_4);
                float r0_w_11 = (r0_w_10 * r2_y_5);
                float r0_w_12 = (r0_w_11 * 3.1415927);
                float r0_w_13 = (r2_x_2 * r0_w_12);
                float r0_w_14 = max(r0_w_13, 0);
                float r1_z_9 = mad(r1_z_8, r1_z_8, 1);
                float r1_z_10 = ((float4(1, 1, 1, 1) / r1_z_9)).z;
                float r0_w_15 = (r0_w_14 * asfloat(asint((float)((dot(r6_xyz_1.xyzx, r6_xyz_1.xyzx) != 0))) & asint(1065353216)));
                float r1_w_8 = mad(_Glossiness, r4_xyzw_1.w, -r1_w_7);
                float r1_w_9 = saturate((r1_w_8 + 1));
                float4 r2_xyzw_6 = (r1_y_9.xxxx * r8_xyz_1.xyxz);
                float r2_x_6 = r2_xyzw_6.x;
                float r2_y_6 = r2_xyzw_6.y;
                float r2_w_21 = r2_xyzw_6.w;
                float4 r5_xyzw_5 = (r8_xyz_1.xyzx * r0_w_15.xxxx);
                float r5_x_5 = r5_xyzw_5.x;
                float r5_y_4 = r5_xyzw_5.y;
                float r5_z_4 = r5_xyzw_5.z;
                float r0_w_16 = (-r1_x_4 + 1);
                float r1_x_5 = (r0_w_16 * r0_w_16);
                float r1_x_6 = (r1_x_5 * r1_x_5);
                float4 r0_xyzw_13 = (float4(r0_x_12, r0_y_6, r0_z_6, r0_w_16) * float4(r1_z_10, r1_z_10, r1_z_10, r1_x_6));
                float4 r5_xyzw_6 = (float4(r5_x_5, r5_y_4, r5_z_4, r5_x_5) * (mad((mad(-_SpecColor.xyzx, r4_xyzw_1.xyzx, float4(1, 1, 1, 0))).xyzx, r0_xyzw_13.wwww, r6_xyz_1.xyzx)).xyzx);
                float r5_x_6 = r5_xyzw_6.x;
                float r5_y_5 = r5_xyzw_6.y;
                float r5_z_5 = r5_xyzw_6.z;
                float4 r2_xyzw_7 = mad(((r1_w_7.xxxx * r3_xyz_2.xyzx)).xyxz, float4(r2_x_6, r2_y_6, r2_x_6, r2_w_21), float4(r5_x_6, r5_y_5, r5_x_6, r5_z_5));
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_7 = r2_xyzw_7.y;
                float r2_w_22 = r2_xyzw_7.w;
                float4 r1_xyzw_7 = mad(-_SpecColor.xyzx, r4_xyzw_1.xyzx, r1_w_9.xxxx);
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_10 = r1_xyzw_7.y;
                float r1_z_11 = r1_xyzw_7.z;
                float4 r1_xyzw_8 = mad(r2_z_5.xxxx, float4(r1_x_7, r1_y_10, r1_z_11, r1_x_7), r6_xyz_1.xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_11 = r1_xyzw_8.y;
                float r1_z_12 = r1_xyzw_8.z;
                float4 r0_xyzw_14 = mad(r0_xyzw_13.xyzx, float4(r1_x_8, r1_y_11, r1_z_12, r1_x_8), float4(r2_x_7, r2_y_7, r2_w_22, r2_x_7));
                float r0_x_14 = r0_xyzw_14.x;
                float r0_y_8 = r0_xyzw_14.y;
                float r0_z_8 = r0_xyzw_14.z;
                o.sv_Target0.xyz = (mad(_EmissionColor.xyzx, r3_xyz_2.xyzx, float4(r0_x_14, r0_y_8, r0_z_8, r0_x_14))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0;
                float4 _SpecColor;
                float4 _Color;
                float4 _EmissionColor;
                float _Glossiness;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 _SpecGlossMap_ST;
                float4 _OcclusionMap_ST;
                float4 cb0_values[15];
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
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_MainTex;
            SamplerState sampler_SpecGlossMap;
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _SpecGlossMap;
            Texture2D _OcclusionMap;
            Texture3D t4;
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
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program89Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program89Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program43Output vert(program43Input i)
            {
                program43Output o = (program43Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[12].xxxy, cb0_values[12].zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, cb0_values[13].xyxx, cb0_values[13].zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, cb0_values[14].xxxy, cb0_values[14].zzzw)).zw;
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
                o.texcoord2.y = r3_xyz_3.x;
                o.texcoord2.x = unitWorldTangent_xyz_7.z;
                o.texcoord2.z = unitWorldNormal_xyz_3.y;
                o.texcoord3.x = unitWorldTangent_xyz_7.x;
                o.texcoord4.x = unitWorldTangent_xyz_7.y;
                o.texcoord3.z = unitWorldNormal_xyz_3.z;
                o.texcoord4.z = unitWorldNormal_xyz_3.x;
                o.texcoord3.y = r3_xyz_3.y;
                o.texcoord4.y = r3_xyz_3.z;
                o.texcoord5.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_4 = ((worldPos_xyzw_4.yyyy * _EmissionColor.xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(cb0_values[6].xyzx, worldPos_xyzw_4.zzzz, (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_4.xyzx)).xyzx)).xyz;
                o.texcoord6.xyz = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program89Output frag(program89Input i)
            {
                program89Output o = (program89Output)0;
                float3 r0_xyz_1 = ((-i.texcoord5.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord5.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_2 = normalize(viewDir_xyz_1);
                float3 r3_xyz_1 = (_MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy)).xyz;
                float4 r4_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord1.xyxx).xy);
                float3 r5_xyz_1 = (_SpecGlossMap.Sample(sampler_SpecGlossMap, (i.texcoord0.zwzz).xy)).xyz;
                float r5_x_2 = (r5_xyz_1.z * r5_xyz_1.x);
                float4 r5_xyzw_3 = mad(float4(r5_x_2, r5_xyz_1.y, r5_x_2, r5_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r5_x_3 = r5_xyzw_3.x;
                float r5_y_2 = r5_xyzw_3.y;
                float r1_w_3 = dot(float4(r5_x_3, r5_y_2, r5_x_3, r5_x_3), float4(r5_x_3, r5_y_2, r5_x_3, r5_x_3));
                float r1_w_4 = min(r1_w_3, 1);
                float r1_w_5 = (-r1_w_4 + 1);
                float r5_z_2 = sqrt(r1_w_5);
                float3 r6_xyz_1 = ((r4_xyzw_1.xyzx * _SpecColor.xyzx)).xyz;
                float3 r7_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord5.zzzz, (mad(cb0_values[4].xyzx, i.texcoord5.xxxx, ((i.texcoord5.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r1_w_6 = (unity_ProbeVolumeParams.x == 1);
                float r8_x_10;
                float r8_y_10;
                float r8_z_10;
                float r8_w_4;
                if (r1_w_6)
                {
                    float r1_w_7 = (unity_ProbeVolumeParams.y == 1);
                    float3 r8_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord5.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord5.xxxx, ((i.texcoord5.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r1_w_7.xxxx ? r8_xyz_5.xyzx : i.texcoord5.xyzx)).xyz;
                    float4 r8_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r8_y_8 = r8_xyzw_8.y;
                    float r8_z_8 = r8_xyzw_8.z;
                    float r8_w_2 = r8_xyzw_8.w;
                    float r1_w_8 = mad(r8_y_8, 0.25, 0.75);
                    float r2_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r8_x_8 = max(r1_w_8, r2_w_1);
                    float4 r8_xyzw_9 = t4.Sample(sampler_linear_clamp, (float4(r8_x_8, r8_z_8, r8_w_2, r8_x_8)).xyz);
                    r8_x_10 = r8_xyzw_9.x;
                    r8_y_10 = r8_xyzw_9.y;
                    r8_z_10 = r8_xyzw_9.z;
                    r8_w_4 = r8_xyzw_9.w;
                }
                else
                {
                    float4 r8_xyzw_10 = float4(1, 1, 1, 1);
                    r8_x_10 = r8_xyzw_10.x;
                    r8_y_10 = r8_xyzw_10.y;
                    r8_z_10 = r8_xyzw_10.z;
                    r8_w_4 = r8_xyzw_10.w;
                }
                float r1_w_10 = saturate(dot(float4(r8_x_10, r8_y_10, r8_z_10, r8_w_4), unity_OcclusionMaskSelector));
                float r2_w_3 = dot(r7_xyz_4.xyzx, r7_xyz_4.xyzx);
                float r2_w_4 = (_OcclusionMap.Sample(sampler_OcclusionMap, (r2_w_3.xxxx).xy)).w;
                float r1_w_11 = (r1_w_10 * r2_w_4);
                float r7_x_5 = dot(i.texcoord2.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float r7_y_5 = dot(i.texcoord3.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float r7_z_5 = dot(i.texcoord4.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float r2_w_5 = dot(float4(r7_x_5, r7_y_5, r7_z_5, r7_x_5), float4(r7_x_5, r7_y_5, r7_z_5, r7_x_5));
                float r2_w_6 = rsqrt(r2_w_5);
                float4 r5_xyzw_4 = (r2_w_6.xxxx * float4(r7_x_5, r7_y_5, r7_z_5, r7_x_5));
                float r5_x_4 = r5_xyzw_4.x;
                float r5_y_3 = r5_xyzw_4.y;
                float r5_z_3 = r5_xyzw_4.z;
                float3 r7_xyz_6 = ((r1_w_11.xxxx * _LightColor0.xyzx)).xyz;
                float r1_w_12 = max(r6_xyz_1.y, r6_xyz_1.x);
                float r1_w_13 = max(r6_xyz_1.z, r1_w_12);
                float r1_w_14 = (-r1_w_13 + 1);
                float r1_w_15 = mad(-cb0_values[10].x, r4_xyzw_1.w, 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_2.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r5_x_4, r5_y_3, r5_z_3, r5_x_4), unitViewDir_xyz_2.xyzx);
                float r2_x_3 = saturate(dot(float4(r5_x_4, r5_y_3, r5_z_3, r5_x_4), r1_xyz_1.xyzx));
                float r2_y_3 = saturate(dot(float4(r5_x_4, r5_y_3, r5_z_3, r5_x_4), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_15.xxxx);
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
                float r0_z_7 = (r1_w_15 * r1_w_15);
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
                float r0_w_11 = dot(r6_xyz_1.xyzx, r6_xyz_1.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * r7_xyz_6.xyzx);
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (r7_xyz_6.xxyz * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_16 = (r0_x_5 * r0_x_5);
                float r1_w_17 = (r1_w_16 * r1_w_16);
                float4 r2_xyzw_4 = mad(-_SpecColor.xyzx, r4_xyzw_1.xyzx, float4(1, 1, 1, 0));
                float r2_x_4 = r2_xyzw_4.x;
                float r2_y_4 = r2_xyzw_4.y;
                float r2_z_3 = r2_xyzw_4.z;
                float4 r2_xyzw_5 = mad(float4(r2_x_4, r2_y_4, r2_z_3, r2_x_4), ((r0_x_5 * r1_w_17)).xxxx, r6_xyz_1.xyzx);
                float r2_x_5 = r2_xyzw_5.x;
                float r2_y_5 = r2_xyzw_5.y;
                float r2_z_4 = r2_xyzw_5.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_5, r2_y_5, r2_z_4, r2_x_5));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(((r1_w_14.xxxx * ((r3_xyz_1.xyzx * cb0_values[8].xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="DEFERRED" "QUEUE"="Geometry" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _SpecColor : packoffset(c3);
                float4 _Color : packoffset(c4);
                float4 _EmissionColor : packoffset(c5);
                float _Glossiness : packoffset(c6.x);
                float4 _MainTex_ST : packoffset(c7);
                float4 _BumpMap_ST : packoffset(c8);
                float4 _SpecGlossMap_ST : packoffset(c9);
                float4 _OcclusionMap_ST : packoffset(c10);
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
            SamplerState sampler_SpecGlossMap;
            SamplerState sampler_BumpMap;
            SamplerState sampler_OcclusionMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _SpecGlossMap;
            Texture2D _OcclusionMap;
            struct program117Input
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
            struct program117Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program123Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program123Output
            {
                float4 sv_Target0 : SV_Target;
                float4 sv_Target1 : SV_Target1;
                float4 sv_Target2 : SV_Target2;
                float4 sv_Target3 : SV_Target3;
            };
            #pragma vertex vert
            program117Output vert(program117Input i)
            {
                program117Output o = (program117Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                float3 worldPos_xyz_4 = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _SpecGlossMap_ST.xyxx, _SpecGlossMap_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _OcclusionMap_ST.xxxy, _OcclusionMap_ST.zzzw)).zw;
                o.texcoord2.w = worldPos_xyz_4.x;
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float3 unitWorldNormal_xyz_3 = (((rsqrt(dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2)))).xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = (((rsqrt(dot(worldTangent_xyz_6.xyzx, worldTangent_xyz_6.xyzx))).xxxx * worldTangent_xyz_6.xyzx)).xyz;
                float3 r3_xyz_3 = ((((i.tangent0.w * unity_WorldTransformParams.w)).xxxx * (mad(unitWorldNormal_xyz_3.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_3.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord2.y = r3_xyz_3.x;
                o.texcoord2.x = unitWorldTangent_xyz_7.z;
                o.texcoord2.z = unitWorldNormal_xyz_3.y;
                o.texcoord3.x = unitWorldTangent_xyz_7.x;
                o.texcoord4.x = unitWorldTangent_xyz_7.y;
                o.texcoord3.z = unitWorldNormal_xyz_3.z;
                o.texcoord4.z = unitWorldNormal_xyz_3.x;
                o.texcoord3.w = worldPos_xyz_4.y;
                o.texcoord4.w = worldPos_xyz_4.z;
                o.texcoord3.y = r3_xyz_3.y;
                o.texcoord4.y = r3_xyz_3.z;
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program123Output frag(program123Input i)
            {
                program123Output o = (program123Output)0;
                float r0_x_1 = (_OcclusionMap.Sample(sampler_OcclusionMap, (i.texcoord1.zwzz).xy)).x;
                o.sv_Target0.w = r0_x_1;
                float4 r0_xyzw_2 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord1.xyxx).xy);
                float4 r0_xyzw_3 = (r0_xyzw_2.xyzx * _SpecColor.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_2 = r0_xyzw_3.y;
                float r0_z_2 = r0_xyzw_3.z;
                o.sv_Target1.w = (r0_xyzw_2.w * _Glossiness);
                float r0_w_2 = max(r0_y_2, r0_x_3);
                float r0_w_3 = max(r0_z_2, r0_w_2);
                o.sv_Target1.xyz = (float4(r0_x_3, r0_y_2, r0_z_2, r0_x_3)).xyz;
                float r0_y_3 = (_MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy)).y;
                float r0_z_3 = (_MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy)).z;
                float r0_w_4 = (_MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy)).w;
                float4 r0_xyzw_4 = (float4(r0_y_3, r0_y_3, r0_z_3, r0_w_4) * _Color.xxyz);
                float r0_y_4 = r0_xyzw_4.y;
                float r0_z_4 = r0_xyzw_4.z;
                float r0_w_5 = r0_xyzw_4.w;
                o.sv_Target0.xyz = ((((-r0_w_3 + 1)).xxxx * float4(r0_y_4, r0_z_4, r0_w_5, r0_y_4))).xyz;
                o.sv_Target3.xyz = (exp2(((float4(r0_y_4, r0_z_4, r0_w_5, r0_y_4) * _EmissionColor.xyzx)).xyzx)).xyz;
                float3 r0_xyz_6 = (_SpecGlossMap.Sample(sampler_SpecGlossMap, (i.texcoord0.zwzz).xy)).xyz;
                float r0_x_7 = (r0_xyz_6.z * r0_xyz_6.x);
                float4 r0_xyzw_8 = mad(float4(r0_x_7, r0_xyz_6.y, r0_x_7, r0_x_7), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_7 = r0_xyzw_8.y;
                float r0_w_6 = dot(float4(r0_x_8, r0_y_7, r0_x_8, r0_x_8), float4(r0_x_8, r0_y_7, r0_x_8, r0_x_8));
                float r0_w_7 = min(r0_w_6, 1);
                float r0_w_8 = (-r0_w_7 + 1);
                float r0_z_7 = sqrt(r0_w_8);
                float r1_x_1 = dot(i.texcoord2.xyzx, float4(r0_x_8, r0_y_7, r0_z_7, r0_x_8));
                float r1_y_1 = dot(i.texcoord3.xyzx, float4(r0_x_8, r0_y_7, r0_z_7, r0_x_8));
                float r1_z_1 = dot(i.texcoord4.xyzx, float4(r0_x_8, r0_y_7, r0_z_7, r0_x_8));
                float4 r0_xyzw_11 = ((rsqrt(dot(float4(r1_x_1, r1_y_1, r1_z_1, r1_x_1), float4(r1_x_1, r1_y_1, r1_z_1, r1_x_1)))).xxxx * float4(r1_x_1, r1_y_1, r1_z_1, r1_x_1));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_y_8 = r0_xyzw_11.y;
                float r0_z_8 = r0_xyzw_11.z;
                o.sv_Target2.xyz = (mad(float4(r0_x_11, r0_y_8, r0_z_8, r0_x_11), float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
                o.sv_Target2.w = 1;
                o.sv_Target3.w = 1;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Standard"
}
