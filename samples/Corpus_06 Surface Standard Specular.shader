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
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
                float4 cb1_values[6];
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
            SamplerState sampler_linear_clamp;
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            SamplerState sampler_SpecGlossMap;
            SamplerState sampler_BumpMap;
            SamplerState sampler_OcclusionMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _SpecGlossMap;
            Texture2D _OcclusionMap;
            Texture2D t4;
            TextureCube t5;
            TextureCube t6;
            Texture3D t7;
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
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
                float4 texcoord8 : TEXCOORD8;
            };
            struct program37Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
                float4 texcoord8 : TEXCOORD8;
            };
            struct program37Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program17Output vert(program17Input i)
            {
                program17Output o = (program17Output)0;
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
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _SpecGlossMap_ST.xyxx, _SpecGlossMap_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _OcclusionMap_ST.xxxy, _OcclusionMap_ST.zzzw)).zw;
                o.texcoord2.w = r0_xyz_4.x;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * cb3_values[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(cb3_values[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(cb3_values[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = (((rsqrt(dot(worldTangent_xyz_6.xyzx, worldTangent_xyz_6.xyzx))).xxxx * worldTangent_xyz_6.xyzx)).xyz;
                o.texcoord2.x = unitWorldTangent_xyz_7.z;
                float worldNormal_x_1 = dot(i.normal0.xyzx, cb3_values[4].xyzx);
                float worldNormal_y_1 = dot(i.normal0.xyzx, cb3_values[5].xyzx);
                float worldNormal_z_1 = dot(i.normal0.xyzx, cb3_values[6].xyzx);
                float4 unitWorldNormal_xyzw_2 = ((rsqrt(dot(float4(worldNormal_x_1, worldNormal_y_1, worldNormal_z_1, worldNormal_x_1), float4(worldNormal_x_1, worldNormal_y_1, worldNormal_z_1, worldNormal_x_1)))).xxxx * float4(worldNormal_x_1, worldNormal_y_1, worldNormal_z_1, worldNormal_z_1));
                float3 r4_xyz_3 = ((((i.tangent0.w * cb3_values[9].w)).xxxx * (mad(unitWorldNormal_xyzw_2.ywxy, unitWorldTangent_xyz_7.yzxy, ((unitWorldTangent_xyz_7.xyzx * unitWorldNormal_xyzw_2.wxyw)).xyzx)).xyzx)).xyz;
                o.texcoord2.y = r4_xyz_3.x;
                o.texcoord2.z = unitWorldNormal_xyzw_2.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.x;
                o.texcoord4.x = unitWorldTangent_xyz_7.y;
                o.texcoord3.w = r0_xyz_4.y;
                o.texcoord4.w = r0_xyz_4.z;
                o.texcoord3.y = r4_xyz_3.y;
                o.texcoord4.y = r4_xyz_3.z;
                o.texcoord3.z = unitWorldNormal_xyzw_2.y;
                o.texcoord4.z = unitWorldNormal_xyzw_2.w;
                float4 r2_xyzw_8 = (unitWorldNormal_xyzw_2.ywzx * unitWorldNormal_xyzw_2);
                float r3_x_3 = dot(cb2_values[42].xyzw, r2_xyzw_8);
                float r3_y_3 = dot(cb2_values[43].xyzw, r2_xyzw_8);
                float r3_z_3 = dot(cb2_values[44].xyzw, r2_xyzw_8);
                o.texcoord5.xyz = (mad(cb2_values[45].xyzx, (mad(unitWorldNormal_xyzw_2.x, unitWorldNormal_xyzw_2.x, (unitWorldNormal_xyzw_2.y * unitWorldNormal_xyzw_2.y))).xxxx, float4(r3_x_3, r3_y_3, r3_z_3, r3_x_3))).xyz;
                o.texcoord6.x = clipPos_xyzw_2.z;
                float r0_w_4 = ((clipPos_xyzw_2.y * unity_WorldToObject[1].x) * 0.5);
                float4 r0_xyzw_13 = (clipPos_xyzw_2.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_13 = r0_xyzw_13.x;
                float r0_z_5 = r0_xyzw_13.z;
                o.texcoord7.zw = (clipPos_xyzw_2.zzzw).zw;
                o.texcoord7.xy = ((r0_z_5.xxxx + float4(r0_x_13, r0_w_4, r0_x_13, r0_x_13))).xy;
                o.texcoord8.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program37Output frag(program37Input i)
            {
                program37Output o = (program37Output)0;
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
                float r7_x_1 = cb4_values[9].z;
                float r7_y_1 = cb4_values[10].z;
                float r7_z_1 = cb4_values[11].z;
                float r2_w_1 = dot(viewDir_xyz_1.xyzx, float4(r7_x_1, r7_y_1, r7_z_1, r7_x_1));
                float3 r7_xyz_2 = ((float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + -cb3_values[25].xyzx)).xyz;
                float r3_w_1 = dot(r7_xyz_2.xyzx, r7_xyz_2.xyzx);
                float r3_w_2 = sqrt(r3_w_1);
                float r3_w_3 = (-r2_w_1 + r3_w_2);
                float r2_w_2 = mad(cb3_values[25].w, r3_w_3, r2_w_1);
                float r2_w_3 = saturate(mad(r2_w_2, cb3_values[24].z, cb3_values[24].w));
                float r3_w_4 = (cb7_values[0].x == 1);
                float r7_x_12;
                float r7_y_12;
                float r7_z_12;
                float r7_w_4;
                if (r3_w_4)
                {
                    float r5_w_1 = (cb7_values[0].y == 1);
                    float3 r7_xyz_7 = (((mad(cb7_values[3].xyzx, i.texcoord4.wwww, (mad(cb7_values[1].xyzx, i.texcoord2.wwww, ((i.texcoord3.wwww * cb7_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb7_values[4].xyzx)).xyz;
                    float4 r7_xyzw_10 = (((((r5_w_1.xxxx ? r7_xyz_7.xyzx : float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1))).xyzx + -cb7_values[6].xyzx)).xxyz * cb7_values[5].xxyz);
                    float r7_y_10 = r7_xyzw_10.y;
                    float r7_z_10 = r7_xyzw_10.z;
                    float r7_w_2 = r7_xyzw_10.w;
                    float r5_w_2 = mad(r7_y_10, 0.25, 0.75);
                    float r6_w_1 = mad(cb7_values[0].z, 0.5, 0.75);
                    float r7_x_10 = max(r5_w_2, r6_w_1);
                    float4 r7_xyzw_11 = t7.Sample(sampler_linear_clamp1, (float4(r7_x_10, r7_z_10, r7_w_2, r7_x_10)).xyz);
                    r7_x_12 = r7_xyzw_11.x;
                    r7_y_12 = r7_xyzw_11.y;
                    r7_z_12 = r7_xyzw_11.z;
                    r7_w_4 = r7_xyzw_11.w;
                }
                else
                {
                    float4 r7_xyzw_3 = float4(1, 1, 1, 1);
                    r7_x_12 = r7_xyzw_3.x;
                    r7_y_12 = r7_xyzw_3.y;
                    r7_z_12 = r7_xyzw_3.z;
                    r7_w_4 = r7_xyzw_3.w;
                }
                float r5_w_4 = saturate(dot(float4(r7_x_12, r7_y_12, r7_z_12, r7_w_4), unity_OcclusionMaskSelector));
                float r6_w_3 = (t4.Sample(sampler_linear_clamp2, (((i.texcoord7.xyxx / i.texcoord7.wwww)).xyxx).xy)).w;
                float r5_w_5 = (r5_w_4 + -r6_w_3);
                float r2_w_4 = mad(r2_w_3, r5_w_5, r6_w_3);
                float r7_x_14 = dot(i.texcoord2.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float r7_y_14 = dot(i.texcoord3.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float r7_z_13 = dot(i.texcoord4.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float4 r5_xyzw_6 = ((rsqrt(dot(float4(r7_x_14, r7_y_14, r7_z_13, r7_x_14), float4(r7_x_14, r7_y_14, r7_z_13, r7_x_14)))).xxxx * float4(r7_x_14, r7_y_14, r7_z_13, r7_x_14));
                float r5_x_6 = r5_xyzw_6.x;
                float r5_y_3 = r5_xyzw_6.y;
                float r5_z_3 = r5_xyzw_6.z;
                float r6_w_4 = mad(-_Glossiness, r4_xyzw_1.w, 1);
                float r7_x_15 = dot(-unitViewDir_xyz_1.xyzx, float4(r5_x_6, r5_y_3, r5_z_3, r5_x_6));
                float4 r7_xyzw_17 = mad(float4(r5_x_6, r5_y_3, r5_z_3, r5_x_6), ((r7_x_15 + r7_x_15)).xxxx, -unitViewDir_xyz_1.xyzx);
                float r7_x_17 = r7_xyzw_17.x;
                float r7_y_15 = r7_xyzw_17.y;
                float r7_z_14 = r7_xyzw_17.z;
                float3 r8_xyz_1 = ((r2_w_4.xxxx * _LightColor0.xyzx)).xyz;
                float3 r10_xyz_4;
                if (r3_w_4)
                {
                    float r2_w_5 = (cb7_values[0].y == 1);
                    float3 r9_xyz_4 = (((mad(cb7_values[3].xyzx, i.texcoord4.wwww, (mad(cb7_values[1].xyzx, i.texcoord2.wwww, ((i.texcoord3.wwww * cb7_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb7_values[4].xyzx)).xyz;
                    float4 r9_xyzw_7 = (((((r2_w_5.xxxx ? r9_xyz_4.xyzx : float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1))).xyzx + -cb7_values[6].xyzx)).xxyz * cb7_values[5].xxyz);
                    float r9_y_7 = r9_xyzw_7.y;
                    float r9_z_7 = r9_xyzw_7.z;
                    float r9_w_1 = r9_xyzw_7.w;
                    float r2_w_6 = (r9_y_7 * 0.25);
                    float r3_w_5 = (cb7_values[0].z * 0.5);
                    float r7_w_5 = mad(-cb7_values[0].z, 0.5, 0.25);
                    float r2_w_7 = max(r2_w_6, r3_w_5);
                    float r9_x_7 = min(r7_w_5, r2_w_7);
                    float4 r10_xyzw_2 = t7.Sample(sampler_linear_clamp1, (float4(r9_x_7, r9_z_7, r9_w_1, r9_x_7)).xyz);
                    float4 r11_xyzw_2 = t7.Sample(sampler_linear_clamp1, (((float4(r9_x_7, r9_z_7, r9_w_1, r9_x_7) + float4(0.25, 0, 0, 0))).xyzx).xyz);
                    float4 r9_xyzw_9 = t7.Sample(sampler_linear_clamp1, (((float4(r9_x_7, r9_z_7, r9_w_1, r9_x_7) + float4(0.5, 0, 0, 0))).xyzx).xyz);
                    float r5_w_7 = 1;
                    float r10_x_3 = dot(r10_xyzw_2, float4(r5_x_6, r5_y_3, r5_z_3, r5_w_7));
                    float r10_y_3 = dot(r11_xyzw_2, float4(r5_x_6, r5_y_3, r5_z_3, r5_w_7));
                    float r10_z_3 = dot(r9_xyzw_9, float4(r5_x_6, r5_y_3, r5_z_3, r5_w_7));
                    r10_xyz_4 = float3(r10_x_3, r10_y_3, r10_z_3);
                }
                else
                {
                    float r5_w_6 = 1;
                    float r10_x_1 = dot(cb2_values[39].xyzw, float4(r5_x_6, r5_y_3, r5_z_3, r5_w_6));
                    float r10_y_1 = dot(cb2_values[40].xyzw, float4(r5_x_6, r5_y_3, r5_z_3, r5_w_6));
                    float r10_z_1 = dot(cb2_values[41].xyzw, float4(r5_x_6, r5_y_3, r5_z_3, r5_w_6));
                    r10_xyz_4 = float3(r10_x_1, r10_y_1, r10_z_1);
                }
                float r2_w_9 = (0 < cb6_values[2].w);
                float3 r10_xyz_8;
                if (r2_w_9)
                {
                    float r2_w_10 = dot(float4(r7_x_17, r7_y_15, r7_z_14, r7_x_17), float4(r7_x_17, r7_y_15, r7_z_14, r7_x_17));
                    float r2_w_11 = rsqrt(r2_w_10);
                    float3 r10_xyz_6 = ((r2_w_11.xxxx * float4(r7_x_17, r7_y_15, r7_z_14, r7_x_17))).xyz;
                    float3 r13_xyz_1 = ((float4(0, 0, 0, 0) < r10_xyz_6.xyzx)).xyz;
                    float3 r11_xyz_6 = ((r13_xyz_1.xyzx ? ((((-float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + cb6_values[0].xyzx)).xyzx / r10_xyz_6.xyzx)).xyzx : ((((-float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + cb6_values[1].xyzx)).xyzx / r10_xyz_6.xyzx)).xyzx)).xyz;
                    float r2_w_12 = min(r11_xyz_6.y, r11_xyz_6.x);
                    float r2_w_13 = min(r11_xyz_6.z, r2_w_12);
                    r10_xyz_8 = (mad(r10_xyz_6.xyzx, r2_w_13.xxxx, ((float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + -cb6_values[2].xyzx)).xyzx)).xyz;
                }
                else
                {
                    r10_xyz_8 = (float4(r7_x_17, r7_y_15, r7_z_14, r7_x_17)).xyz;
                }
                float r2_w_15 = mad(-r6_w_4, 0.7, 1.7);
                float r2_w_16 = (r2_w_15 * r6_w_4);
                float r2_w_17 = (r2_w_16 * 6);
                float4 r10_xyzw_9 = t5.SampleLevel(sampler_linear_clamp, r10_xyz_8.xyz, r2_w_17);
                float r3_w_7 = (r10_xyzw_9.w + -1);
                float r3_w_8 = mad(cb6_values[3].w, r3_w_7, 1);
                float r3_w_9 = log2(r3_w_8);
                float r3_w_10 = (r3_w_9 * cb6_values[3].y);
                float r3_w_11 = exp2(r3_w_10);
                float r3_w_12 = (r3_w_11 * cb6_values[3].x);
                float r5_w_9 = (cb6_values[1].w < 0.99999);
                float3 r11_xyz_11 = ((r10_xyzw_9.xyzx * r3_w_12.xxxx)).xyz;
                if (r5_w_9)
                {
                    float r5_w_10 = (0 < cb6_values[6].w);
                    float r7_x_19 = r7_x_17;
                    float r7_y_17 = r7_y_15;
                    float r7_z_16 = r7_z_14;
                    if (r5_w_10)
                    {
                        float r5_w_11 = dot(float4(r7_x_17, r7_y_15, r7_z_14, r7_x_17), float4(r7_x_17, r7_y_15, r7_z_14, r7_x_17));
                        float r5_w_12 = rsqrt(r5_w_11);
                        float3 r12_xyz_4 = ((r5_w_12.xxxx * float4(r7_x_17, r7_y_15, r7_z_14, r7_x_17))).xyz;
                        float3 r15_xyz_1 = ((float4(0, 0, 0, 0) < r12_xyz_4.xyzx)).xyz;
                        float3 r13_xyz_5 = ((r15_xyz_1.xyzx ? ((((-float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + cb6_values[4].xyzx)).xyzx / r12_xyz_4.xyzx)).xyzx : ((((-float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + cb6_values[5].xyzx)).xyzx / r12_xyz_4.xyzx)).xyzx)).xyz;
                        float r5_w_13 = min(r13_xyz_5.y, r13_xyz_5.x);
                        float r5_w_14 = min(r13_xyz_5.z, r5_w_13);
                        float4 r7_xyzw_18 = mad(r12_xyz_4.xyzx, r5_w_14.xxxx, ((float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + -cb6_values[6].xyzx)).xyzx);
                        float r7_x_18 = r7_xyzw_18.x;
                        float r7_y_16 = r7_xyzw_18.y;
                        float r7_z_15 = r7_xyzw_18.z;
                        r7_x_19 = r7_x_18;
                        r7_y_17 = r7_y_16;
                        r7_z_16 = r7_z_15;
                    }
                    float4 r7_xyzw_20 = t6.SampleLevel(sampler_linear_clamp, (float4(r7_x_19, r7_y_17, r7_z_16, r7_x_19)).xyz, r2_w_17);
                                        float4 r0_xyzw_10 = (r7_xyzw_20.xyzx * ((pow(mad(cb6_values[7].w, (r7_xyzw_20.w + -1), 1), cb6_values[7].y) * cb6_values[7].x)).xxxx);
                    float r0_x_10 = r0_xyzw_10.x;
                    float r0_y_4 = r0_xyzw_10.y;
                    float r0_z_4 = r0_xyzw_10.z;
                    float4 r7_xyzw_21 = mad(r3_w_12.xxxx, r10_xyzw_9.xyzx, -float4(r0_x_10, r0_y_4, r0_z_4, r0_x_10));
                    float r7_x_21 = r7_xyzw_21.x;
                    float r7_y_19 = r7_xyzw_21.y;
                    float r7_z_18 = r7_xyzw_21.z;
                    r11_xyz_11 = (mad(cb6_values[1].wwww, float4(r7_x_21, r7_y_19, r7_z_18, r7_x_21), float4(r0_x_10, r0_y_4, r0_z_4, r0_x_10))).xyz;
                }
                float4 r0_xyzw_12 = (r1_w_4.xxxx * r11_xyz_11.xyzx);
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_6 = r0_xyzw_12.y;
                float r0_z_6 = r0_xyzw_12.z;
                float r2_w_18 = max(r6_xyz_1.y, r6_xyz_1.x);
                float r2_w_19 = max(r6_xyz_1.z, r2_w_18);
                float r2_w_20 = (-r2_w_19 + 1);
                float4 r7_xyzw_23 = (r2_w_20.xxxx * r3_xyz_2.xyzx);
                float r7_x_23 = r7_xyzw_23.x;
                float r7_y_21 = r7_xyzw_23.y;
                float r7_z_20 = r7_xyzw_23.z;
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r1_xyz_3 = ((r0_w_5.xxxx * r1_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r5_x_6, r5_y_3, r5_z_3, r5_x_6), unitViewDir_xyz_1.xyzx);
                float r2_x_2 = saturate(dot(float4(r5_x_6, r5_y_3, r5_z_3, r5_x_6), _WorldSpaceLightPos0.xyzx));
                float r2_y_2 = saturate(dot(float4(r5_x_6, r5_y_3, r5_z_3, r5_x_6), r1_xyz_3.xyzx));
                float r1_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r1_xyz_3.xyzx));
                float r1_y_4 = (r1_x_4 * r1_x_4);
                float r1_y_5 = dot(r1_y_4.xxxx, r6_w_4.xxxx);
                float r1_y_6 = (r1_y_5 + -0.5);
                float r1_z_4 = (-r2_x_2 + 1);
                float r2_z_2 = (r1_z_4 * r1_z_4);
                float r2_z_3 = (r2_z_2 * r2_z_2);
                float r1_z_5 = (r1_z_4 * r2_z_3);
                float r1_z_6 = mad(r1_y_6, r1_z_5, 1);
                float r2_z_4 = (-abs(r0_w_6) + 1);
                float r3_w_13 = (r2_z_4 * r2_z_4);
                float r3_w_14 = (r3_w_13 * r3_w_13);
                float r2_z_5 = (r2_z_4 * r3_w_14);
                float r1_y_7 = mad(r1_y_6, r2_z_5, 1);
                float r1_y_8 = (r1_y_7 * r1_z_6);
                float r1_y_9 = (r2_x_2 * r1_y_8);
                float r1_z_7 = (r6_w_4 * r6_w_4);
                float r1_z_8 = max(r1_z_7, 0.002);
                float r3_w_15 = (-r1_z_8 + 1);
                float r3_w_16 = mad(r2_x_2, r3_w_15, r1_z_8);
                float r0_w_7 = (abs(r0_w_6) * r3_w_16);
                float r0_w_8 = mad(r2_x_2, mad(abs(r0_w_6), r3_w_15, r1_z_8), r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r3_w_17 = (r1_z_8 * r1_z_8);
                float r2_y_3 = mad(mad(r2_y_2, r3_w_17, -r2_y_2), r2_y_2, 1);
                float r3_w_18 = (r3_w_17 * 0.31830987);
                float r2_y_4 = mad(r2_y_3, r2_y_3, 1E-07);
                float r2_y_5 = (r3_w_18 / r2_y_4);
                float r0_w_11 = (r0_w_10 * r2_y_5);
                float r0_w_12 = (r0_w_11 * 3.1415927);
                float r0_w_13 = (r2_x_2 * r0_w_12);
                float r0_w_14 = max(r0_w_13, 0);
                float r1_z_9 = mad(r1_z_8, r1_z_8, 1);
                float r1_z_10 = ((float4(1, 1, 1, 1) / r1_z_9)).z;
                float r0_w_15 = (r0_w_14 * asfloat(asint((float)((dot(r6_xyz_1.xyzx, r6_xyz_1.xyzx) != 0))) & asint(1065353216)));
                float4 r5_xyzw_9 = (r1_y_9.xxxx * r8_xyz_1.xyzx);
                float r5_x_9 = r5_xyzw_9.x;
                float r5_y_4 = r5_xyzw_9.y;
                float r5_z_4 = r5_xyzw_9.z;
                float4 r5_xyzw_10 = mad((max(((r10_xyz_4.xyzx + i.texcoord5.xyzx)).xyzx, float4(0, 0, 0, 0))).xyzx, r1_w_4.xxxx, float4(r5_x_9, r5_y_4, r5_z_4, r5_x_9));
                float r5_x_10 = r5_xyzw_10.x;
                float r5_y_5 = r5_xyzw_10.y;
                float r5_z_5 = r5_xyzw_10.z;
                float r0_w_16 = (-r1_x_4 + 1);
                float r1_x_5 = (r0_w_16 * r0_w_16);
                float r1_x_6 = (r1_x_5 * r1_x_5);
                float4 r0_xyzw_13 = (float4(r0_x_12, r0_y_6, r0_z_6, r0_w_16) * float4(r1_z_10, r1_z_10, r1_z_10, r1_x_6));
                float4 r1_xyzw_7 = mad(-_SpecColor.xyxz, r4_xyzw_1.xyxz, float4(1, 1, 0, 1));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_10 = r1_xyzw_7.y;
                float r1_w_5 = r1_xyzw_7.w;
                float4 r1_xyzw_8 = mad(float4(r1_x_7, r1_y_10, r1_x_7, r1_w_5), r0_xyzw_13.wwww, r6_xyz_1.xyxz);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_11 = r1_xyzw_8.y;
                float r1_w_6 = r1_xyzw_8.w;
                float4 r1_xyzw_9 = (float4(r1_x_8, r1_y_11, r1_x_8, r1_w_6) * ((r8_xyz_1.xyzx * r0_w_15.xxxx)).xyxz);
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_12 = r1_xyzw_9.y;
                float r1_w_7 = r1_xyzw_9.w;
                float4 r1_xyzw_10 = mad(float4(r7_x_23, r7_y_21, r7_x_23, r7_z_20), float4(r5_x_10, r5_y_5, r5_x_10, r5_z_5), float4(r1_x_9, r1_y_12, r1_x_9, r1_w_7));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_13 = r1_xyzw_10.y;
                float r1_w_8 = r1_xyzw_10.w;
                float4 r2_xyzw_8 = mad(-_SpecColor.xyxz, r4_xyzw_1.xyxz, (saturate((mad(_Glossiness, r4_xyzw_1.w, -r2_w_20) + 1))).xxxx);
                float r2_x_8 = r2_xyzw_8.x;
                float r2_y_6 = r2_xyzw_8.y;
                float r2_w_21 = r2_xyzw_8.w;
                float4 r2_xyzw_9 = mad(r2_z_5.xxxx, float4(r2_x_8, r2_y_6, r2_w_21, r2_x_8), r6_xyz_1.xyzx);
                float r2_x_9 = r2_xyzw_9.x;
                float r2_y_7 = r2_xyzw_9.y;
                float r2_z_6 = r2_xyzw_9.z;
                float4 r0_xyzw_14 = mad(r0_xyzw_13.xyzx, float4(r2_x_9, r2_y_7, r2_z_6, r2_x_9), float4(r1_x_10, r1_y_13, r1_w_8, r1_x_10));
                float r0_x_14 = r0_xyzw_14.x;
                float r0_y_8 = r0_xyzw_14.y;
                float r0_z_8 = r0_xyzw_14.z;
                float4 r0_xyzw_15 = mad(_EmissionColor.xyzx, r3_xyz_2.xyzx, float4(r0_x_14, r0_y_8, r0_z_8, r0_x_14));
                float r0_x_15 = r0_xyzw_15.x;
                float r0_y_9 = r0_xyzw_15.y;
                float r0_z_9 = r0_xyzw_15.z;
                float r0_w_18 = (i.texcoord6.x / cb1_values[5].y);
                float r0_w_19 = (-r0_w_18 + 1);
                float r0_w_20 = (r0_w_19 * cb1_values[5].z);
                float r0_w_21 = max(r0_w_20, 0);
                float r0_w_22 = saturate(mad(r0_w_21, cb5_values[1].z, cb5_values[1].w));
                float4 r0_xyzw_16 = (float4(r0_x_15, r0_y_9, r0_z_9, r0_x_15) + -cb5_values[0].xyzx);
                float r0_x_16 = r0_xyzw_16.x;
                float r0_y_10 = r0_xyzw_16.y;
                float r0_z_10 = r0_xyzw_16.z;
                o.sv_Target0.xyz = (mad(r0_w_22.xxxx, float4(r0_x_16, r0_y_10, r0_z_10, r0_x_16), cb5_values[0].xyzx)).xyz;
                o.sv_Target0.w = 1;
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
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
                float4 cb1_values[6];
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
            SamplerState sampler_linear_clamp;
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            SamplerState sampler_SpecGlossMap;
            SamplerState sampler_BumpMap;
            SamplerState sampler_OcclusionMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _SpecGlossMap;
            Texture2D _OcclusionMap;
            Texture2D t4;
            TextureCube t5;
            TextureCube t6;
            Texture3D t7;
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
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
                float4 texcoord8 : TEXCOORD8;
            };
            struct program36Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
                float4 texcoord8 : TEXCOORD8;
            };
            struct program36Output
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
                float3 r0_xyz_4 = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _SpecGlossMap_ST.xyxx, _SpecGlossMap_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _OcclusionMap_ST.xxxy, _OcclusionMap_ST.zzzw)).zw;
                o.texcoord2.w = r0_xyz_4.x;
                float r2_y_4 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float r2_z_4 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float r2_x_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float3 unitWorldNormal_xyz_5 = (((rsqrt(dot(float4(r2_x_4, r2_y_4, r2_z_4, r2_x_4), float4(r2_x_4, r2_y_4, r2_z_4, r2_x_4)))).xxxx * float4(r2_x_4, r2_y_4, r2_z_4, r2_x_4))).xyz;
                float3 worldTangent_xyz_1 = ((i.tangent0.yyyy * cb2_values[1].yzxy)).xyz;
                float3 worldTangent_xyz_2 = (mad(cb2_values[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_1.xyzx)).xyz;
                float3 worldTangent_xyz_3 = (mad(cb2_values[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_2.xyzx)).xyz;
                float3 unitWorldTangent_xyz_4 = (((rsqrt(dot(worldTangent_xyz_3.xyzx, worldTangent_xyz_3.xyzx))).xxxx * worldTangent_xyz_3.xyzx)).xyz;
                float3 r4_xyz_3 = ((((i.tangent0.w * cb2_values[9].w)).xxxx * (mad(unitWorldNormal_xyz_5.zxyz, unitWorldTangent_xyz_4.yzxy, ((unitWorldNormal_xyz_5.xyzx * unitWorldTangent_xyz_4.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord2.y = r4_xyz_3.x;
                o.texcoord2.x = unitWorldTangent_xyz_4.z;
                o.texcoord2.z = unitWorldNormal_xyz_5.y;
                o.texcoord3.x = unitWorldTangent_xyz_4.x;
                o.texcoord4.x = unitWorldTangent_xyz_4.y;
                o.texcoord3.z = unitWorldNormal_xyz_5.z;
                o.texcoord4.z = unitWorldNormal_xyz_5.x;
                o.texcoord3.w = r0_xyz_4.y;
                o.texcoord4.w = r0_xyz_4.z;
                o.texcoord3.y = r4_xyz_3.y;
                o.texcoord4.y = r4_xyz_3.z;
                o.texcoord6.x = clipPos_xyzw_2.z;
                float r0_w_4 = ((clipPos_xyzw_2.y * unity_WorldToObject[1].x) * 0.5);
                float4 r0_xyzw_11 = (clipPos_xyzw_2.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_z_5 = r0_xyzw_11.z;
                o.texcoord7.zw = (clipPos_xyzw_2.zzzw).zw;
                o.texcoord7.xy = ((r0_z_5.xxxx + float4(r0_x_11, r0_w_4, r0_x_11, r0_x_11))).xy;
                o.texcoord8.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program36Output frag(program36Input i)
            {
                program36Output o = (program36Output)0;
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
                float r7_x_1 = cb4_values[9].z;
                float r7_y_1 = cb4_values[10].z;
                float r7_z_1 = cb4_values[11].z;
                float r2_w_1 = dot(viewDir_xyz_1.xyzx, float4(r7_x_1, r7_y_1, r7_z_1, r7_x_1));
                float3 r7_xyz_2 = ((float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + -cb3_values[25].xyzx)).xyz;
                float r3_w_1 = dot(r7_xyz_2.xyzx, r7_xyz_2.xyzx);
                float r3_w_2 = sqrt(r3_w_1);
                float r3_w_3 = (-r2_w_1 + r3_w_2);
                float r2_w_2 = mad(cb3_values[25].w, r3_w_3, r2_w_1);
                float r2_w_3 = saturate(mad(r2_w_2, cb3_values[24].z, cb3_values[24].w));
                float r3_w_4 = (cb7_values[0].x == 1);
                float r7_x_12;
                float r7_y_12;
                float r7_z_12;
                float r7_w_4;
                if (r3_w_4)
                {
                    float r3_w_5 = (cb7_values[0].y == 1);
                    float3 r7_xyz_7 = (((mad(cb7_values[3].xyzx, i.texcoord4.wwww, (mad(cb7_values[1].xyzx, i.texcoord2.wwww, ((i.texcoord3.wwww * cb7_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb7_values[4].xyzx)).xyz;
                    float4 r7_xyzw_10 = (((((r3_w_5.xxxx ? r7_xyz_7.xyzx : float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1))).xyzx + -cb7_values[6].xyzx)).xxyz * cb7_values[5].xxyz);
                    float r7_y_10 = r7_xyzw_10.y;
                    float r7_z_10 = r7_xyzw_10.z;
                    float r7_w_2 = r7_xyzw_10.w;
                    float r3_w_6 = mad(r7_y_10, 0.25, 0.75);
                    float r5_w_1 = mad(cb7_values[0].z, 0.5, 0.75);
                    float r7_x_10 = max(r3_w_6, r5_w_1);
                    float4 r7_xyzw_11 = t7.Sample(sampler_linear_clamp1, (float4(r7_x_10, r7_z_10, r7_w_2, r7_x_10)).xyz);
                    r7_x_12 = r7_xyzw_11.x;
                    r7_y_12 = r7_xyzw_11.y;
                    r7_z_12 = r7_xyzw_11.z;
                    r7_w_4 = r7_xyzw_11.w;
                }
                else
                {
                    float4 r7_xyzw_3 = float4(1, 1, 1, 1);
                    r7_x_12 = r7_xyzw_3.x;
                    r7_y_12 = r7_xyzw_3.y;
                    r7_z_12 = r7_xyzw_3.z;
                    r7_w_4 = r7_xyzw_3.w;
                }
                float r3_w_8 = saturate(dot(float4(r7_x_12, r7_y_12, r7_z_12, r7_w_4), unity_OcclusionMaskSelector));
                float r5_w_3 = (t4.Sample(sampler_linear_clamp2, (((i.texcoord7.xyxx / i.texcoord7.wwww)).xyxx).xy)).w;
                float r3_w_9 = (r3_w_8 + -r5_w_3);
                float r2_w_4 = mad(r2_w_3, r3_w_9, r5_w_3);
                float r7_x_14 = dot(i.texcoord2.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float r7_y_14 = dot(i.texcoord3.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float r7_z_13 = dot(i.texcoord4.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float r3_w_10 = dot(float4(r7_x_14, r7_y_14, r7_z_13, r7_x_14), float4(r7_x_14, r7_y_14, r7_z_13, r7_x_14));
                float r3_w_11 = rsqrt(r3_w_10);
                float4 r5_xyzw_4 = (r3_w_11.xxxx * float4(r7_x_14, r7_y_14, r7_z_13, r7_x_14));
                float r5_x_4 = r5_xyzw_4.x;
                float r5_y_3 = r5_xyzw_4.y;
                float r5_z_3 = r5_xyzw_4.z;
                float r3_w_12 = mad(-_Glossiness, r4_xyzw_1.w, 1);
                float r5_w_4 = dot(-unitViewDir_xyz_1.xyzx, float4(r5_x_4, r5_y_3, r5_z_3, r5_x_4));
                float r5_w_5 = (r5_w_4 + r5_w_4);
                float4 r7_xyzw_15 = mad(float4(r5_x_4, r5_y_3, r5_z_3, r5_x_4), -r5_w_5.xxxx, -unitViewDir_xyz_1.xyzx);
                float r7_x_15 = r7_xyzw_15.x;
                float r7_y_15 = r7_xyzw_15.y;
                float r7_z_14 = r7_xyzw_15.z;
                float3 r8_xyz_1 = ((r2_w_4.xxxx * _LightColor0.xyzx)).xyz;
                float r2_w_5 = (0 < cb6_values[2].w);
                float3 r9_xyz_4;
                if (r2_w_5)
                {
                    float r2_w_6 = dot(float4(r7_x_15, r7_y_15, r7_z_14, r7_x_15), float4(r7_x_15, r7_y_15, r7_z_14, r7_x_15));
                    float r2_w_7 = rsqrt(r2_w_6);
                    float3 r9_xyz_2 = ((r2_w_7.xxxx * float4(r7_x_15, r7_y_15, r7_z_14, r7_x_15))).xyz;
                    float3 r12_xyz_1 = ((float4(0, 0, 0, 0) < r9_xyz_2.xyzx)).xyz;
                    float3 r10_xyz_3 = ((r12_xyz_1.xyzx ? ((((-float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + cb6_values[0].xyzx)).xyzx / r9_xyz_2.xyzx)).xyzx : ((((-float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + cb6_values[1].xyzx)).xyzx / r9_xyz_2.xyzx)).xyzx)).xyz;
                    float r2_w_8 = min(r10_xyz_3.y, r10_xyz_3.x);
                    float r2_w_9 = min(r10_xyz_3.z, r2_w_8);
                    r9_xyz_4 = (mad(r9_xyz_2.xyzx, r2_w_9.xxxx, ((float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + -cb6_values[2].xyzx)).xyzx)).xyz;
                }
                else
                {
                    r9_xyz_4 = (float4(r7_x_15, r7_y_15, r7_z_14, r7_x_15)).xyz;
                }
                float r2_w_11 = mad(-r3_w_12, 0.7, 1.7);
                float r2_w_12 = (r2_w_11 * r3_w_12);
                float r2_w_13 = (r2_w_12 * 6);
                float4 r9_xyzw_5 = t5.SampleLevel(sampler_linear_clamp, r9_xyz_4.xyz, r2_w_13);
                float r5_w_6 = (r9_xyzw_5.w + -1);
                float r5_w_7 = mad(cb6_values[3].w, r5_w_6, 1);
                float r5_w_8 = log2(r5_w_7);
                float r5_w_9 = (r5_w_8 * cb6_values[3].y);
                float r5_w_10 = exp2(r5_w_9);
                float r5_w_11 = (r5_w_10 * cb6_values[3].x);
                float r6_w_1 = (cb6_values[1].w < 0.99999);
                float3 r10_xyz_8 = ((r9_xyzw_5.xyzx * r5_w_11.xxxx)).xyz;
                if (r6_w_1)
                {
                    float r6_w_2 = (0 < cb6_values[6].w);
                    float r7_x_17 = r7_x_15;
                    float r7_y_17 = r7_y_15;
                    float r7_z_16 = r7_z_14;
                    if (r6_w_2)
                    {
                        float r6_w_3 = dot(float4(r7_x_15, r7_y_15, r7_z_14, r7_x_15), float4(r7_x_15, r7_y_15, r7_z_14, r7_x_15));
                        float r6_w_4 = rsqrt(r6_w_3);
                        float3 r11_xyz_4 = ((r6_w_4.xxxx * float4(r7_x_15, r7_y_15, r7_z_14, r7_x_15))).xyz;
                        float3 r14_xyz_1 = ((float4(0, 0, 0, 0) < r11_xyz_4.xyzx)).xyz;
                        float3 r12_xyz_5 = ((r14_xyz_1.xyzx ? ((((-float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + cb6_values[4].xyzx)).xyzx / r11_xyz_4.xyzx)).xyzx : ((((-float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + cb6_values[5].xyzx)).xyzx / r11_xyz_4.xyzx)).xyzx)).xyz;
                        float r6_w_5 = min(r12_xyz_5.y, r12_xyz_5.x);
                        float r6_w_6 = min(r12_xyz_5.z, r6_w_5);
                        float4 r7_xyzw_16 = mad(r11_xyz_4.xyzx, r6_w_6.xxxx, ((float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + -cb6_values[6].xyzx)).xyzx);
                        float r7_x_16 = r7_xyzw_16.x;
                        float r7_y_16 = r7_xyzw_16.y;
                        float r7_z_15 = r7_xyzw_16.z;
                        r7_x_17 = r7_x_16;
                        r7_y_17 = r7_y_16;
                        r7_z_16 = r7_z_15;
                    }
                    float4 r7_xyzw_18 = t6.SampleLevel(sampler_linear_clamp, (float4(r7_x_17, r7_y_17, r7_z_16, r7_x_17)).xyz, r2_w_13);
                                        float4 r0_xyzw_10 = (r7_xyzw_18.xyzx * ((pow(mad(cb6_values[7].w, (r7_xyzw_18.w + -1), 1), cb6_values[7].y) * cb6_values[7].x)).xxxx);
                    float r0_x_10 = r0_xyzw_10.x;
                    float r0_y_4 = r0_xyzw_10.y;
                    float r0_z_4 = r0_xyzw_10.z;
                    float4 r7_xyzw_19 = mad(r5_w_11.xxxx, r9_xyzw_5.xyzx, -float4(r0_x_10, r0_y_4, r0_z_4, r0_x_10));
                    float r7_x_19 = r7_xyzw_19.x;
                    float r7_y_19 = r7_xyzw_19.y;
                    float r7_z_18 = r7_xyzw_19.z;
                    r10_xyz_8 = (mad(cb6_values[1].wwww, float4(r7_x_19, r7_y_19, r7_z_18, r7_x_19), float4(r0_x_10, r0_y_4, r0_z_4, r0_x_10))).xyz;
                }
                float4 r0_xyzw_12 = (r1_w_4.xxxx * r10_xyz_8.xyzx);
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_6 = r0_xyzw_12.y;
                float r0_z_6 = r0_xyzw_12.z;
                float r1_w_5 = max(r6_xyz_1.y, r6_xyz_1.x);
                float r1_w_6 = max(r6_xyz_1.z, r1_w_5);
                float r1_w_7 = (-r1_w_6 + 1);
                float4 r7_xyzw_21 = (r1_w_7.xxxx * r3_xyz_2.xyzx);
                float r7_x_21 = r7_xyzw_21.x;
                float r7_y_21 = r7_xyzw_21.y;
                float r7_z_20 = r7_xyzw_21.z;
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
                float r1_y_5 = dot(r1_y_4.xxxx, r3_w_12.xxxx);
                float r1_y_6 = (r1_y_5 + -0.5);
                float r1_z_4 = (-r2_x_2 + 1);
                float r2_z_2 = (r1_z_4 * r1_z_4);
                float r2_z_3 = (r2_z_2 * r2_z_2);
                float r1_z_5 = (r1_z_4 * r2_z_3);
                float r1_z_6 = mad(r1_y_6, r1_z_5, 1);
                float r2_z_4 = (-abs(r0_w_6) + 1);
                float r2_w_14 = (r2_z_4 * r2_z_4);
                float r2_w_15 = (r2_w_14 * r2_w_14);
                float r2_z_5 = (r2_z_4 * r2_w_15);
                float r1_y_7 = mad(r1_y_6, r2_z_5, 1);
                float r1_y_8 = (r1_y_7 * r1_z_6);
                float r1_y_9 = (r2_x_2 * r1_y_8);
                float r1_z_7 = (r3_w_12 * r3_w_12);
                float r1_z_8 = max(r1_z_7, 0.002);
                float r2_w_16 = (-r1_z_8 + 1);
                float r3_w_13 = mad(abs(r0_w_6), r2_w_16, r1_z_8);
                float r2_w_17 = mad(r2_x_2, r2_w_16, r1_z_8);
                float r0_w_7 = (abs(r0_w_6) * r2_w_17);
                float r0_w_8 = mad(r2_x_2, r3_w_13, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r2_w_18 = (r1_z_8 * r1_z_8);
                float r3_w_14 = mad(r2_y_2, r2_w_18, -r2_y_2);
                float r2_y_3 = mad(r3_w_14, r2_y_2, 1);
                float r2_w_19 = (r2_w_18 * 0.31830987);
                float r2_y_4 = mad(r2_y_3, r2_y_3, 1E-07);
                float r2_y_5 = (r2_w_19 / r2_y_4);
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
                float r2_w_20 = r2_xyzw_6.w;
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
                float4 r2_xyzw_7 = mad(float4(r7_x_21, r7_y_21, r7_x_21, r7_z_20), float4(r2_x_6, r2_y_6, r2_x_6, r2_w_20), float4(r5_x_6, r5_y_5, r5_x_6, r5_z_5));
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_7 = r2_xyzw_7.y;
                float r2_w_21 = r2_xyzw_7.w;
                float4 r1_xyzw_7 = mad(-_SpecColor.xyzx, r4_xyzw_1.xyzx, r1_w_9.xxxx);
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_10 = r1_xyzw_7.y;
                float r1_z_11 = r1_xyzw_7.z;
                float4 r1_xyzw_8 = mad(r2_z_5.xxxx, float4(r1_x_7, r1_y_10, r1_z_11, r1_x_7), r6_xyz_1.xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_11 = r1_xyzw_8.y;
                float r1_z_12 = r1_xyzw_8.z;
                float4 r0_xyzw_14 = mad(r0_xyzw_13.xyzx, float4(r1_x_8, r1_y_11, r1_z_12, r1_x_8), float4(r2_x_7, r2_y_7, r2_w_21, r2_x_7));
                float r0_x_14 = r0_xyzw_14.x;
                float r0_y_8 = r0_xyzw_14.y;
                float r0_z_8 = r0_xyzw_14.z;
                float4 r0_xyzw_15 = mad(_EmissionColor.xyzx, r3_xyz_2.xyzx, float4(r0_x_14, r0_y_8, r0_z_8, r0_x_14));
                float r0_x_15 = r0_xyzw_15.x;
                float r0_y_9 = r0_xyzw_15.y;
                float r0_z_9 = r0_xyzw_15.z;
                float r0_w_18 = (i.texcoord6.x / cb1_values[5].y);
                float r0_w_19 = (-r0_w_18 + 1);
                float r0_w_20 = (r0_w_19 * cb1_values[5].z);
                float r0_w_21 = max(r0_w_20, 0);
                float r0_w_22 = saturate(mad(r0_w_21, cb5_values[1].z, cb5_values[1].w));
                float4 r0_xyzw_16 = (float4(r0_x_15, r0_y_9, r0_z_9, r0_x_15) + -cb5_values[0].xyzx);
                float r0_x_16 = r0_xyzw_16.x;
                float r0_y_10 = r0_xyzw_16.y;
                float r0_z_10 = r0_xyzw_16.z;
                o.sv_Target0.xyz = (mad(r0_w_22.xxxx, float4(r0_x_16, r0_y_10, r0_z_10, r0_x_16), cb5_values[0].xyzx)).xyz;
                o.sv_Target0.w = 1;
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
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
                float4 texcoord8 : TEXCOORD8;
            };
            struct program35Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
                float4 texcoord8 : TEXCOORD8;
            };
            struct program35Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program15Output vert(program15Input i)
            {
                program15Output o = (program15Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float3 r0_xyz_4 = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord6.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _SpecGlossMap_ST.xyxx, _SpecGlossMap_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _OcclusionMap_ST.xxxy, _OcclusionMap_ST.zzzw)).zw;
                o.texcoord2.w = r0_xyz_4.x;
                float3 worldTangent_xyz_3 = ((i.tangent0.yyyy * cb2_values[1].yzxy)).xyz;
                float3 worldTangent_xyz_4 = (mad(cb2_values[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_3.xyzx)).xyz;
                float3 worldTangent_xyz_5 = (mad(cb2_values[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_4.xyzx)).xyz;
                float3 unitWorldTangent_xyz_6 = (((rsqrt(dot(worldTangent_xyz_5.xyzx, worldTangent_xyz_5.xyzx))).xxxx * worldTangent_xyz_5.xyzx)).xyz;
                o.texcoord2.x = unitWorldTangent_xyz_6.z;
                float worldNormal_x_4 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float4 unitWorldNormal_xyzw_5 = ((rsqrt(dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4)))).xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_z_4));
                float3 r3_xyz_3 = ((((i.tangent0.w * cb2_values[9].w)).xxxx * (mad(unitWorldNormal_xyzw_5.ywxy, unitWorldTangent_xyz_6.yzxy, ((unitWorldTangent_xyz_6.xyzx * unitWorldNormal_xyzw_5.wxyw)).xyzx)).xyzx)).xyz;
                o.texcoord2.y = r3_xyz_3.x;
                o.texcoord2.z = unitWorldNormal_xyzw_5.x;
                o.texcoord3.x = unitWorldTangent_xyz_6.x;
                o.texcoord4.x = unitWorldTangent_xyz_6.y;
                o.texcoord3.w = r0_xyz_4.y;
                o.texcoord4.w = r0_xyz_4.z;
                o.texcoord3.y = r3_xyz_3.y;
                o.texcoord4.y = r3_xyz_3.z;
                o.texcoord3.z = unitWorldNormal_xyzw_5.y;
                o.texcoord4.z = unitWorldNormal_xyzw_5.w;
                float4 r1_xyzw_7 = (unitWorldNormal_xyzw_5.ywzx * unitWorldNormal_xyzw_5);
                float r2_x_6 = dot(cb1_values[42].xyzw, r1_xyzw_7);
                float r2_y_6 = dot(cb1_values[43].xyzw, r1_xyzw_7);
                float r2_z_6 = dot(cb1_values[44].xyzw, r1_xyzw_7);
                o.texcoord5.xyz = (mad(cb1_values[45].xyzx, (mad(unitWorldNormal_xyzw_5.x, unitWorldNormal_xyzw_5.x, (unitWorldNormal_xyzw_5.y * unitWorldNormal_xyzw_5.y))).xxxx, float4(r2_x_6, r2_y_6, r2_z_6, r2_x_6))).xyz;
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                o.texcoord8.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program35Output frag(program35Input i)
            {
                program35Output o = (program35Output)0;
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
                float r2_w_1 = (cb5_values[0].x == 1);
                float r7_x_10;
                float r7_y_10;
                float r7_z_10;
                float r7_w_4;
                if (r2_w_1)
                {
                    float r3_w_1 = (cb5_values[0].y == 1);
                    float3 r7_xyz_5 = (((mad(cb5_values[3].xyzx, i.texcoord4.wwww, (mad(cb5_values[1].xyzx, i.texcoord2.wwww, ((i.texcoord3.wwww * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r7_xyzw_8 = (((((r3_w_1.xxxx ? r7_xyz_5.xyzx : float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1))).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r7_y_8 = r7_xyzw_8.y;
                    float r7_z_8 = r7_xyzw_8.z;
                    float r7_w_2 = r7_xyzw_8.w;
                    float r3_w_2 = mad(r7_y_8, 0.25, 0.75);
                    float r5_w_1 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r7_x_8 = max(r3_w_2, r5_w_1);
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
                float r3_w_4 = saturate(dot(float4(r7_x_10, r7_y_10, r7_z_10, r7_w_4), unity_OcclusionMaskSelector));
                float r7_x_11 = dot(i.texcoord2.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float r7_y_11 = dot(i.texcoord3.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float r7_z_11 = dot(i.texcoord4.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float4 r5_xyzw_6 = ((rsqrt(dot(float4(r7_x_11, r7_y_11, r7_z_11, r7_x_11), float4(r7_x_11, r7_y_11, r7_z_11, r7_x_11)))).xxxx * float4(r7_x_11, r7_y_11, r7_z_11, r7_x_11));
                float r5_x_6 = r5_xyzw_6.x;
                float r5_y_3 = r5_xyzw_6.y;
                float r5_z_3 = r5_xyzw_6.z;
                float r6_w_1 = mad(-_Glossiness, r4_xyzw_1.w, 1);
                float r7_x_12 = dot(-unitViewDir_xyz_1.xyzx, float4(r5_x_6, r5_y_3, r5_z_3, r5_x_6));
                float4 r7_xyzw_14 = mad(float4(r5_x_6, r5_y_3, r5_z_3, r5_x_6), ((r7_x_12 + r7_x_12)).xxxx, -unitViewDir_xyz_1.xyzx);
                float r7_x_14 = r7_xyzw_14.x;
                float r7_y_12 = r7_xyzw_14.y;
                float r7_z_12 = r7_xyzw_14.z;
                float3 r8_xyz_1 = ((r3_w_4.xxxx * _LightColor0.xyzx)).xyz;
                float3 r10_xyz_4;
                if (r2_w_1)
                {
                    float r2_w_2 = (cb5_values[0].y == 1);
                    float3 r9_xyz_4 = (((mad(cb5_values[3].xyzx, i.texcoord4.wwww, (mad(cb5_values[1].xyzx, i.texcoord2.wwww, ((i.texcoord3.wwww * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r9_xyzw_7 = (((((r2_w_2.xxxx ? r9_xyz_4.xyzx : float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1))).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r9_y_7 = r9_xyzw_7.y;
                    float r9_z_7 = r9_xyzw_7.z;
                    float r9_w_1 = r9_xyzw_7.w;
                    float r2_w_3 = (r9_y_7 * 0.25);
                    float r3_w_5 = (cb5_values[0].z * 0.5);
                    float r7_w_5 = mad(-cb5_values[0].z, 0.5, 0.25);
                    float r2_w_4 = max(r2_w_3, r3_w_5);
                    float r9_x_7 = min(r7_w_5, r2_w_4);
                    float4 r10_xyzw_2 = t6.Sample(sampler_linear_clamp1, (float4(r9_x_7, r9_z_7, r9_w_1, r9_x_7)).xyz);
                    float4 r11_xyzw_2 = t6.Sample(sampler_linear_clamp1, (((float4(r9_x_7, r9_z_7, r9_w_1, r9_x_7) + float4(0.25, 0, 0, 0))).xyzx).xyz);
                    float4 r9_xyzw_9 = t6.Sample(sampler_linear_clamp1, (((float4(r9_x_7, r9_z_7, r9_w_1, r9_x_7) + float4(0.5, 0, 0, 0))).xyzx).xyz);
                    float r5_w_4 = 1;
                    float r10_x_3 = dot(r10_xyzw_2, float4(r5_x_6, r5_y_3, r5_z_3, r5_w_4));
                    float r10_y_3 = dot(r11_xyzw_2, float4(r5_x_6, r5_y_3, r5_z_3, r5_w_4));
                    float r10_z_3 = dot(r9_xyzw_9, float4(r5_x_6, r5_y_3, r5_z_3, r5_w_4));
                    r10_xyz_4 = float3(r10_x_3, r10_y_3, r10_z_3);
                }
                else
                {
                    float r5_w_3 = 1;
                    float r10_x_1 = dot(cb2_values[39].xyzw, float4(r5_x_6, r5_y_3, r5_z_3, r5_w_3));
                    float r10_y_1 = dot(cb2_values[40].xyzw, float4(r5_x_6, r5_y_3, r5_z_3, r5_w_3));
                    float r10_z_1 = dot(cb2_values[41].xyzw, float4(r5_x_6, r5_y_3, r5_z_3, r5_w_3));
                    r10_xyz_4 = float3(r10_x_1, r10_y_1, r10_z_1);
                }
                float r2_w_6 = (0 < unity_ProbeVolumeWorldToObject[1].w);
                float3 r10_xyz_8;
                if (r2_w_6)
                {
                    float r2_w_7 = dot(float4(r7_x_14, r7_y_12, r7_z_12, r7_x_14), float4(r7_x_14, r7_y_12, r7_z_12, r7_x_14));
                    float r2_w_8 = rsqrt(r2_w_7);
                    float3 r10_xyz_6 = ((r2_w_8.xxxx * float4(r7_x_14, r7_y_12, r7_z_12, r7_x_14))).xyz;
                    float3 r13_xyz_1 = ((float4(0, 0, 0, 0) < r10_xyz_6.xyzx)).xyz;
                    float3 r11_xyz_6 = ((r13_xyz_1.xyzx ? ((((-float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + unity_ProbeVolumeParams.xyzx)).xyzx / r10_xyz_6.xyzx)).xyzx : ((((-float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + unity_ProbeVolumeWorldToObject[0].xyzx)).xyzx / r10_xyz_6.xyzx)).xyzx)).xyz;
                    float r2_w_9 = min(r11_xyz_6.y, r11_xyz_6.x);
                    float r2_w_10 = min(r11_xyz_6.z, r2_w_9);
                    r10_xyz_8 = (mad(r10_xyz_6.xyzx, r2_w_10.xxxx, ((float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + -unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyz;
                }
                else
                {
                    r10_xyz_8 = (float4(r7_x_14, r7_y_12, r7_z_12, r7_x_14)).xyz;
                }
                float r2_w_12 = mad(-r6_w_1, 0.7, 1.7);
                float r2_w_13 = (r2_w_12 * r6_w_1);
                float r2_w_14 = (r2_w_13 * 6);
                float4 r10_xyzw_9 = t4.SampleLevel(sampler_linear_clamp, r10_xyz_8.xyz, r2_w_14);
                float r3_w_7 = (r10_xyzw_9.w + -1);
                float r3_w_8 = mad(unity_ProbeVolumeWorldToObject[2].w, r3_w_7, 1);
                float r3_w_9 = log2(r3_w_8);
                float r3_w_10 = (r3_w_9 * unity_ProbeVolumeWorldToObject[2].y);
                float r3_w_11 = exp2(r3_w_10);
                float r3_w_12 = (r3_w_11 * unity_ProbeVolumeWorldToObject[2].x);
                float r5_w_6 = (unity_ProbeVolumeWorldToObject[0].w < 0.99999);
                float3 r11_xyz_11 = ((r10_xyzw_9.xyzx * r3_w_12.xxxx)).xyz;
                if (r5_w_6)
                {
                    float r5_w_7 = (0 < cb4_values[6].w);
                    float r7_x_16 = r7_x_14;
                    float r7_y_14 = r7_y_12;
                    float r7_z_14 = r7_z_12;
                    if (r5_w_7)
                    {
                        float r5_w_8 = dot(float4(r7_x_14, r7_y_12, r7_z_12, r7_x_14), float4(r7_x_14, r7_y_12, r7_z_12, r7_x_14));
                        float r5_w_9 = rsqrt(r5_w_8);
                        float3 r12_xyz_4 = ((r5_w_9.xxxx * float4(r7_x_14, r7_y_12, r7_z_12, r7_x_14))).xyz;
                        float3 r15_xyz_1 = ((float4(0, 0, 0, 0) < r12_xyz_4.xyzx)).xyz;
                        float3 r13_xyz_5 = ((r15_xyz_1.xyzx ? ((((-float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + unity_ProbeVolumeWorldToObject[3].xyzx)).xyzx / r12_xyz_4.xyzx)).xyzx : ((((-float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + unity_ProbeVolumeSizeInv.xyzx)).xyzx / r12_xyz_4.xyzx)).xyzx)).xyz;
                        float r5_w_10 = min(r13_xyz_5.y, r13_xyz_5.x);
                        float r5_w_11 = min(r13_xyz_5.z, r5_w_10);
                        float4 r7_xyzw_15 = mad(r12_xyz_4.xyzx, r5_w_11.xxxx, ((float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + -unity_ProbeVolumeMin.xyzx)).xyzx);
                        float r7_x_15 = r7_xyzw_15.x;
                        float r7_y_13 = r7_xyzw_15.y;
                        float r7_z_13 = r7_xyzw_15.z;
                        r7_x_16 = r7_x_15;
                        r7_y_14 = r7_y_13;
                        r7_z_14 = r7_z_13;
                    }
                    float4 r7_xyzw_17 = t5.SampleLevel(sampler_linear_clamp, (float4(r7_x_16, r7_y_14, r7_z_14, r7_x_16)).xyz, r2_w_14);
                                        float4 r0_xyzw_10 = (r7_xyzw_17.xyzx * ((pow(mad(cb4_values[7].w, (r7_xyzw_17.w + -1), 1), cb4_values[7].y) * cb4_values[7].x)).xxxx);
                    float r0_x_10 = r0_xyzw_10.x;
                    float r0_y_4 = r0_xyzw_10.y;
                    float r0_z_4 = r0_xyzw_10.z;
                    float4 r7_xyzw_18 = mad(r3_w_12.xxxx, r10_xyzw_9.xyzx, -float4(r0_x_10, r0_y_4, r0_z_4, r0_x_10));
                    float r7_x_18 = r7_xyzw_18.x;
                    float r7_y_16 = r7_xyzw_18.y;
                    float r7_z_16 = r7_xyzw_18.z;
                    r11_xyz_11 = (mad(unity_ProbeVolumeWorldToObject[0].wwww, float4(r7_x_18, r7_y_16, r7_z_16, r7_x_18), float4(r0_x_10, r0_y_4, r0_z_4, r0_x_10))).xyz;
                }
                float4 r0_xyzw_12 = (r1_w_4.xxxx * r11_xyz_11.xyzx);
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_6 = r0_xyzw_12.y;
                float r0_z_6 = r0_xyzw_12.z;
                float r2_w_15 = max(r6_xyz_1.y, r6_xyz_1.x);
                float r2_w_16 = max(r6_xyz_1.z, r2_w_15);
                float r2_w_17 = (-r2_w_16 + 1);
                float4 r7_xyzw_20 = (r2_w_17.xxxx * r3_xyz_2.xyzx);
                float r7_x_20 = r7_xyzw_20.x;
                float r7_y_18 = r7_xyzw_20.y;
                float r7_z_18 = r7_xyzw_20.z;
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r1_xyz_3 = ((r0_w_5.xxxx * r1_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r5_x_6, r5_y_3, r5_z_3, r5_x_6), unitViewDir_xyz_1.xyzx);
                float r2_x_2 = saturate(dot(float4(r5_x_6, r5_y_3, r5_z_3, r5_x_6), _WorldSpaceLightPos0.xyzx));
                float r2_y_2 = saturate(dot(float4(r5_x_6, r5_y_3, r5_z_3, r5_x_6), r1_xyz_3.xyzx));
                float r1_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r1_xyz_3.xyzx));
                float r1_y_4 = (r1_x_4 * r1_x_4);
                float r1_y_5 = dot(r1_y_4.xxxx, r6_w_1.xxxx);
                float r1_y_6 = (r1_y_5 + -0.5);
                float r1_z_4 = (-r2_x_2 + 1);
                float r2_z_2 = (r1_z_4 * r1_z_4);
                float r2_z_3 = (r2_z_2 * r2_z_2);
                float r1_z_5 = (r1_z_4 * r2_z_3);
                float r1_z_6 = mad(r1_y_6, r1_z_5, 1);
                float r2_z_4 = (-abs(r0_w_6) + 1);
                float r3_w_13 = (r2_z_4 * r2_z_4);
                float r3_w_14 = (r3_w_13 * r3_w_13);
                float r2_z_5 = (r2_z_4 * r3_w_14);
                float r1_y_7 = mad(r1_y_6, r2_z_5, 1);
                float r1_y_8 = (r1_y_7 * r1_z_6);
                float r1_y_9 = (r2_x_2 * r1_y_8);
                float r1_z_7 = (r6_w_1 * r6_w_1);
                float r1_z_8 = max(r1_z_7, 0.002);
                float r3_w_15 = (-r1_z_8 + 1);
                float r3_w_16 = mad(r2_x_2, r3_w_15, r1_z_8);
                float r0_w_7 = (abs(r0_w_6) * r3_w_16);
                float r0_w_8 = mad(r2_x_2, mad(abs(r0_w_6), r3_w_15, r1_z_8), r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r3_w_17 = (r1_z_8 * r1_z_8);
                float r2_y_3 = mad(mad(r2_y_2, r3_w_17, -r2_y_2), r2_y_2, 1);
                float r3_w_18 = (r3_w_17 * 0.31830987);
                float r2_y_4 = mad(r2_y_3, r2_y_3, 1E-07);
                float r2_y_5 = (r3_w_18 / r2_y_4);
                float r0_w_11 = (r0_w_10 * r2_y_5);
                float r0_w_12 = (r0_w_11 * 3.1415927);
                float r0_w_13 = (r2_x_2 * r0_w_12);
                float r0_w_14 = max(r0_w_13, 0);
                float r1_z_9 = mad(r1_z_8, r1_z_8, 1);
                float r1_z_10 = ((float4(1, 1, 1, 1) / r1_z_9)).z;
                float r0_w_15 = (r0_w_14 * asfloat(asint((float)((dot(r6_xyz_1.xyzx, r6_xyz_1.xyzx) != 0))) & asint(1065353216)));
                float4 r5_xyzw_9 = (r1_y_9.xxxx * r8_xyz_1.xyzx);
                float r5_x_9 = r5_xyzw_9.x;
                float r5_y_4 = r5_xyzw_9.y;
                float r5_z_4 = r5_xyzw_9.z;
                float4 r5_xyzw_10 = mad((max(((r10_xyz_4.xyzx + i.texcoord5.xyzx)).xyzx, float4(0, 0, 0, 0))).xyzx, r1_w_4.xxxx, float4(r5_x_9, r5_y_4, r5_z_4, r5_x_9));
                float r5_x_10 = r5_xyzw_10.x;
                float r5_y_5 = r5_xyzw_10.y;
                float r5_z_5 = r5_xyzw_10.z;
                float r0_w_16 = (-r1_x_4 + 1);
                float r1_x_5 = (r0_w_16 * r0_w_16);
                float r1_x_6 = (r1_x_5 * r1_x_5);
                float4 r0_xyzw_13 = (float4(r0_x_12, r0_y_6, r0_z_6, r0_w_16) * float4(r1_z_10, r1_z_10, r1_z_10, r1_x_6));
                float4 r1_xyzw_7 = mad(-_SpecColor.xyxz, r4_xyzw_1.xyxz, float4(1, 1, 0, 1));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_10 = r1_xyzw_7.y;
                float r1_w_5 = r1_xyzw_7.w;
                float4 r1_xyzw_8 = mad(float4(r1_x_7, r1_y_10, r1_x_7, r1_w_5), r0_xyzw_13.wwww, r6_xyz_1.xyxz);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_11 = r1_xyzw_8.y;
                float r1_w_6 = r1_xyzw_8.w;
                float4 r1_xyzw_9 = (float4(r1_x_8, r1_y_11, r1_x_8, r1_w_6) * ((r8_xyz_1.xyzx * r0_w_15.xxxx)).xyxz);
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_12 = r1_xyzw_9.y;
                float r1_w_7 = r1_xyzw_9.w;
                float4 r1_xyzw_10 = mad(float4(r7_x_20, r7_y_18, r7_x_20, r7_z_18), float4(r5_x_10, r5_y_5, r5_x_10, r5_z_5), float4(r1_x_9, r1_y_12, r1_x_9, r1_w_7));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_13 = r1_xyzw_10.y;
                float r1_w_8 = r1_xyzw_10.w;
                float4 r2_xyzw_8 = mad(-_SpecColor.xyxz, r4_xyzw_1.xyxz, (saturate((mad(_Glossiness, r4_xyzw_1.w, -r2_w_17) + 1))).xxxx);
                float r2_x_8 = r2_xyzw_8.x;
                float r2_y_6 = r2_xyzw_8.y;
                float r2_w_18 = r2_xyzw_8.w;
                float4 r2_xyzw_9 = mad(r2_z_5.xxxx, float4(r2_x_8, r2_y_6, r2_w_18, r2_x_8), r6_xyz_1.xyzx);
                float r2_x_9 = r2_xyzw_9.x;
                float r2_y_7 = r2_xyzw_9.y;
                float r2_z_6 = r2_xyzw_9.z;
                float4 r0_xyzw_14 = mad(r0_xyzw_13.xyzx, float4(r2_x_9, r2_y_7, r2_z_6, r2_x_9), float4(r1_x_10, r1_y_13, r1_w_8, r1_x_10));
                float r0_x_14 = r0_xyzw_14.x;
                float r0_y_8 = r0_xyzw_14.y;
                float r0_z_8 = r0_xyzw_14.z;
                float4 r0_xyzw_15 = mad(_EmissionColor.xyzx, r3_xyz_2.xyzx, float4(r0_x_14, r0_y_8, r0_z_8, r0_x_14));
                float r0_x_15 = r0_xyzw_15.x;
                float r0_y_9 = r0_xyzw_15.y;
                float r0_z_9 = r0_xyzw_15.z;
                float r0_w_18 = (i.texcoord6.x / cb1_values[5].y);
                float r0_w_19 = (-r0_w_18 + 1);
                float r0_w_20 = (r0_w_19 * cb1_values[5].z);
                float r0_w_21 = max(r0_w_20, 0);
                float r0_w_22 = saturate(mad(r0_w_21, unity_SpecCube0_BoxMin.z, unity_SpecCube0_BoxMin.w));
                float4 r0_xyzw_16 = (float4(r0_x_15, r0_y_9, r0_z_9, r0_x_15) + -unity_SpecCube0_BoxMax.xyzx);
                float r0_x_16 = r0_xyzw_16.x;
                float r0_y_10 = r0_xyzw_16.y;
                float r0_z_10 = r0_xyzw_16.z;
                o.sv_Target0.xyz = (mad(r0_w_22.xxxx, float4(r0_x_16, r0_y_10, r0_z_10, r0_x_16), unity_SpecCube0_BoxMax.xyzx)).xyz;
                o.sv_Target0.w = 1;
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
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
                float4 cb1_values[6];
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
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
                float4 texcoord8 : TEXCOORD8;
            };
            struct program34Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
                float4 texcoord8 : TEXCOORD8;
            };
            struct program34Output
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
                float3 worldPos_xyz_4 = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord6.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _SpecGlossMap_ST.xyxx, _SpecGlossMap_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _OcclusionMap_ST.xxxy, _OcclusionMap_ST.zzzw)).zw;
                o.texcoord2.w = worldPos_xyz_4.x;
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float3 unitWorldNormal_xyz_4 = (((rsqrt(dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3)))).xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = (((rsqrt(dot(worldTangent_xyz_6.xyzx, worldTangent_xyz_6.xyzx))).xxxx * worldTangent_xyz_6.xyzx)).xyz;
                float3 r3_xyz_3 = ((((i.tangent0.w * unity_WorldTransformParams.w)).xxxx * (mad(unitWorldNormal_xyz_4.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_4.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord2.y = r3_xyz_3.x;
                o.texcoord2.x = unitWorldTangent_xyz_7.z;
                o.texcoord2.z = unitWorldNormal_xyz_4.y;
                o.texcoord3.x = unitWorldTangent_xyz_7.x;
                o.texcoord4.x = unitWorldTangent_xyz_7.y;
                o.texcoord3.z = unitWorldNormal_xyz_4.z;
                o.texcoord4.z = unitWorldNormal_xyz_4.x;
                o.texcoord3.w = worldPos_xyz_4.y;
                o.texcoord4.w = worldPos_xyz_4.z;
                o.texcoord3.y = r3_xyz_3.y;
                o.texcoord4.y = r3_xyz_3.z;
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                o.texcoord8.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program34Output frag(program34Input i)
            {
                program34Output o = (program34Output)0;
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
                float r2_w_1 = (cb5_values[0].x == 1);
                float r7_x_10;
                float r7_y_10;
                float r7_z_10;
                float r7_w_4;
                if (r2_w_1)
                {
                    float r2_w_2 = (cb5_values[0].y == 1);
                    float3 r7_xyz_5 = (((mad(cb5_values[3].xyzx, i.texcoord4.wwww, (mad(cb5_values[1].xyzx, i.texcoord2.wwww, ((i.texcoord3.wwww * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r7_xyzw_8 = (((((r2_w_2.xxxx ? r7_xyz_5.xyzx : float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1))).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r7_y_8 = r7_xyzw_8.y;
                    float r7_z_8 = r7_xyzw_8.z;
                    float r7_w_2 = r7_xyzw_8.w;
                    float r2_w_3 = mad(r7_y_8, 0.25, 0.75);
                    float r3_w_1 = mad(cb5_values[0].z, 0.5, 0.75);
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
                float r2_w_6 = (0 < unity_ProbeVolumeWorldToObject[1].w);
                float3 r9_xyz_4;
                if (r2_w_6)
                {
                    float3 r9_xyz_2 = normalize(r7_xyz_12);
                    float3 r12_xyz_1 = ((float4(0, 0, 0, 0) < r9_xyz_2.xyzx)).xyz;
                    float3 r10_xyz_3 = ((r12_xyz_1.xyzx ? ((((-float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + unity_ProbeVolumeParams.xyzx)).xyzx / r9_xyz_2.xyzx)).xyzx : ((((-float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + unity_ProbeVolumeWorldToObject[0].xyzx)).xyzx / r9_xyz_2.xyzx)).xyzx)).xyz;
                    float r2_w_9 = min(r10_xyz_3.y, r10_xyz_3.x);
                    float r2_w_10 = min(r10_xyz_3.z, r2_w_9);
                    r9_xyz_4 = (mad(r9_xyz_2.xyzx, r2_w_10.xxxx, ((float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + -unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyz;
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
                float r5_w_4 = mad(unity_ProbeVolumeWorldToObject[2].w, r5_w_3, 1);
                float r5_w_5 = log2(r5_w_4);
                float r5_w_6 = (r5_w_5 * unity_ProbeVolumeWorldToObject[2].y);
                float r5_w_7 = exp2(r5_w_6);
                float r5_w_8 = (r5_w_7 * unity_ProbeVolumeWorldToObject[2].x);
                float r6_w_1 = (unity_ProbeVolumeWorldToObject[0].w < 0.99999);
                float3 r10_xyz_8 = ((r9_xyzw_5.xyzx * r5_w_8.xxxx)).xyz;
                if (r6_w_1)
                {
                    float r6_w_2 = (0 < cb4_values[6].w);
                    float3 r7_xyz_14 = r7_xyz_12;
                    if (r6_w_2)
                    {
                        float3 r11_xyz_4 = normalize(r7_xyz_12);
                        float3 r14_xyz_1 = ((float4(0, 0, 0, 0) < r11_xyz_4.xyzx)).xyz;
                        float3 r12_xyz_5 = ((r14_xyz_1.xyzx ? ((((-float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + unity_ProbeVolumeWorldToObject[3].xyzx)).xyzx / r11_xyz_4.xyzx)).xyzx : ((((-float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + unity_ProbeVolumeSizeInv.xyzx)).xyzx / r11_xyz_4.xyzx)).xyzx)).xyz;
                        float r6_w_5 = min(r12_xyz_5.y, r12_xyz_5.x);
                        float r6_w_6 = min(r12_xyz_5.z, r6_w_5);
                        r7_xyz_14 = (mad(r11_xyz_4.xyzx, r6_w_6.xxxx, ((float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + -unity_ProbeVolumeMin.xyzx)).xyzx)).xyz;
                    }
                    float4 r7_xyzw_15 = t5.SampleLevel(sampler_linear_clamp, r7_xyz_14.xyz, r2_w_14);
                                        float4 r0_xyzw_10 = (r7_xyzw_15.xyzx * ((pow(mad(cb4_values[7].w, (r7_xyzw_15.w + -1), 1), cb4_values[7].y) * cb4_values[7].x)).xxxx);
                    float r0_x_10 = r0_xyzw_10.x;
                    float r0_y_4 = r0_xyzw_10.y;
                    float r0_z_4 = r0_xyzw_10.z;
                    r10_xyz_8 = (mad(unity_ProbeVolumeWorldToObject[0].wwww, (mad(r5_w_8.xxxx, r9_xyzw_5.xyzx, -float4(r0_x_10, r0_y_4, r0_z_4, r0_x_10))).xyzx, float4(r0_x_10, r0_y_4, r0_z_4, r0_x_10))).xyz;
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
                float4 r0_xyzw_15 = mad(_EmissionColor.xyzx, r3_xyz_2.xyzx, float4(r0_x_14, r0_y_8, r0_z_8, r0_x_14));
                float r0_x_15 = r0_xyzw_15.x;
                float r0_y_9 = r0_xyzw_15.y;
                float r0_z_9 = r0_xyzw_15.z;
                float r0_w_18 = (i.texcoord6.x / cb1_values[5].y);
                float r0_w_19 = (-r0_w_18 + 1);
                float r0_w_20 = (r0_w_19 * cb1_values[5].z);
                float r0_w_21 = max(r0_w_20, 0);
                float r0_w_22 = saturate(mad(r0_w_21, unity_SpecCube0_BoxMin.z, unity_SpecCube0_BoxMin.w));
                float4 r0_xyzw_16 = (float4(r0_x_15, r0_y_9, r0_z_9, r0_x_15) + -unity_SpecCube0_BoxMax.xyzx);
                float r0_x_16 = r0_xyzw_16.x;
                float r0_y_10 = r0_xyzw_16.y;
                float r0_z_10 = r0_xyzw_16.z;
                o.sv_Target0.xyz = (mad(r0_w_22.xxxx, float4(r0_x_16, r0_y_10, r0_z_10, r0_x_16), unity_SpecCube0_BoxMax.xyzx)).xyz;
                o.sv_Target0.w = 1;
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
            SamplerState sampler_SpecGlossMap;
            SamplerState sampler_BumpMap;
            SamplerState sampler_OcclusionMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _SpecGlossMap;
            Texture2D _OcclusionMap;
            Texture2D t4;
            TextureCube t5;
            TextureCube t6;
            Texture3D t7;
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
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord7 : TEXCOORD7;
                float4 texcoord8 : TEXCOORD8;
            };
            struct program33Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord7 : TEXCOORD7;
                float4 texcoord8 : TEXCOORD8;
            };
            struct program33Output
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
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _SpecGlossMap_ST.xyxx, _SpecGlossMap_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _OcclusionMap_ST.xxxy, _OcclusionMap_ST.zzzw)).zw;
                o.texcoord2.w = r0_xyz_4.x;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * cb3_values[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(cb3_values[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(cb3_values[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = (((rsqrt(dot(worldTangent_xyz_6.xyzx, worldTangent_xyz_6.xyzx))).xxxx * worldTangent_xyz_6.xyzx)).xyz;
                o.texcoord2.x = unitWorldTangent_xyz_7.z;
                float worldNormal_x_1 = dot(i.normal0.xyzx, cb3_values[4].xyzx);
                float worldNormal_y_1 = dot(i.normal0.xyzx, cb3_values[5].xyzx);
                float worldNormal_z_1 = dot(i.normal0.xyzx, cb3_values[6].xyzx);
                float4 unitWorldNormal_xyzw_2 = ((rsqrt(dot(float4(worldNormal_x_1, worldNormal_y_1, worldNormal_z_1, worldNormal_x_1), float4(worldNormal_x_1, worldNormal_y_1, worldNormal_z_1, worldNormal_x_1)))).xxxx * float4(worldNormal_x_1, worldNormal_y_1, worldNormal_z_1, worldNormal_z_1));
                float3 r4_xyz_3 = ((((i.tangent0.w * cb3_values[9].w)).xxxx * (mad(unitWorldNormal_xyzw_2.ywxy, unitWorldTangent_xyz_7.yzxy, ((unitWorldTangent_xyz_7.xyzx * unitWorldNormal_xyzw_2.wxyw)).xyzx)).xyzx)).xyz;
                o.texcoord2.y = r4_xyz_3.x;
                o.texcoord2.z = unitWorldNormal_xyzw_2.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.x;
                o.texcoord4.x = unitWorldTangent_xyz_7.y;
                o.texcoord3.w = r0_xyz_4.y;
                o.texcoord4.w = r0_xyz_4.z;
                o.texcoord3.y = r4_xyz_3.y;
                o.texcoord4.y = r4_xyz_3.z;
                o.texcoord3.z = unitWorldNormal_xyzw_2.y;
                o.texcoord4.z = unitWorldNormal_xyzw_2.w;
                float4 r2_xyzw_8 = (unitWorldNormal_xyzw_2.ywzx * unitWorldNormal_xyzw_2);
                float r3_x_3 = dot(cb2_values[42].xyzw, r2_xyzw_8);
                float r3_y_3 = dot(cb2_values[43].xyzw, r2_xyzw_8);
                float r3_z_3 = dot(cb2_values[44].xyzw, r2_xyzw_8);
                o.texcoord5.xyz = (mad(cb2_values[45].xyzx, (mad(unitWorldNormal_xyzw_2.x, unitWorldNormal_xyzw_2.x, (unitWorldNormal_xyzw_2.y * unitWorldNormal_xyzw_2.y))).xxxx, float4(r3_x_3, r3_y_3, r3_z_3, r3_x_3))).xyz;
                float r0_w_4 = ((clipPos_xyzw_2.y * unity_WorldToObject[1].x) * 0.5);
                float4 r0_xyzw_13 = (clipPos_xyzw_2.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_13 = r0_xyzw_13.x;
                float r0_z_5 = r0_xyzw_13.z;
                o.texcoord7.zw = (clipPos_xyzw_2.zzzw).zw;
                o.texcoord7.xy = ((r0_z_5.xxxx + float4(r0_x_13, r0_w_4, r0_x_13, r0_x_13))).xy;
                o.texcoord8.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program33Output frag(program33Input i)
            {
                program33Output o = (program33Output)0;
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
                float r7_x_1 = cb4_values[9].z;
                float r7_y_1 = cb4_values[10].z;
                float r7_z_1 = cb4_values[11].z;
                float r2_w_1 = dot(viewDir_xyz_1.xyzx, float4(r7_x_1, r7_y_1, r7_z_1, r7_x_1));
                float3 r7_xyz_2 = ((float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + -cb3_values[25].xyzx)).xyz;
                float r3_w_1 = dot(r7_xyz_2.xyzx, r7_xyz_2.xyzx);
                float r3_w_2 = sqrt(r3_w_1);
                float r3_w_3 = (-r2_w_1 + r3_w_2);
                float r2_w_2 = mad(cb3_values[25].w, r3_w_3, r2_w_1);
                float r2_w_3 = saturate(mad(r2_w_2, cb3_values[24].z, cb3_values[24].w));
                float r3_w_4 = (cb6_values[0].x == 1);
                float r7_x_12;
                float r7_y_12;
                float r7_z_12;
                float r7_w_4;
                if (r3_w_4)
                {
                    float r5_w_1 = (cb6_values[0].y == 1);
                    float3 r7_xyz_7 = (((mad(cb6_values[3].xyzx, i.texcoord4.wwww, (mad(cb6_values[1].xyzx, i.texcoord2.wwww, ((i.texcoord3.wwww * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r7_xyzw_10 = (((((r5_w_1.xxxx ? r7_xyz_7.xyzx : float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1))).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r7_y_10 = r7_xyzw_10.y;
                    float r7_z_10 = r7_xyzw_10.z;
                    float r7_w_2 = r7_xyzw_10.w;
                    float r5_w_2 = mad(r7_y_10, 0.25, 0.75);
                    float r6_w_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r7_x_10 = max(r5_w_2, r6_w_1);
                    float4 r7_xyzw_11 = t7.Sample(sampler_linear_clamp1, (float4(r7_x_10, r7_z_10, r7_w_2, r7_x_10)).xyz);
                    r7_x_12 = r7_xyzw_11.x;
                    r7_y_12 = r7_xyzw_11.y;
                    r7_z_12 = r7_xyzw_11.z;
                    r7_w_4 = r7_xyzw_11.w;
                }
                else
                {
                    float4 r7_xyzw_3 = float4(1, 1, 1, 1);
                    r7_x_12 = r7_xyzw_3.x;
                    r7_y_12 = r7_xyzw_3.y;
                    r7_z_12 = r7_xyzw_3.z;
                    r7_w_4 = r7_xyzw_3.w;
                }
                float r5_w_4 = saturate(dot(float4(r7_x_12, r7_y_12, r7_z_12, r7_w_4), unity_OcclusionMaskSelector));
                float r6_w_3 = (t4.Sample(sampler_linear_clamp2, (((i.texcoord7.xyxx / i.texcoord7.wwww)).xyxx).xy)).w;
                float r5_w_5 = (r5_w_4 + -r6_w_3);
                float r2_w_4 = mad(r2_w_3, r5_w_5, r6_w_3);
                float r7_x_14 = dot(i.texcoord2.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float r7_y_14 = dot(i.texcoord3.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float r7_z_13 = dot(i.texcoord4.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float4 r5_xyzw_6 = ((rsqrt(dot(float4(r7_x_14, r7_y_14, r7_z_13, r7_x_14), float4(r7_x_14, r7_y_14, r7_z_13, r7_x_14)))).xxxx * float4(r7_x_14, r7_y_14, r7_z_13, r7_x_14));
                float r5_x_6 = r5_xyzw_6.x;
                float r5_y_3 = r5_xyzw_6.y;
                float r5_z_3 = r5_xyzw_6.z;
                float r6_w_4 = mad(-_Glossiness, r4_xyzw_1.w, 1);
                float r7_x_15 = dot(-unitViewDir_xyz_1.xyzx, float4(r5_x_6, r5_y_3, r5_z_3, r5_x_6));
                float4 r7_xyzw_17 = mad(float4(r5_x_6, r5_y_3, r5_z_3, r5_x_6), ((r7_x_15 + r7_x_15)).xxxx, -unitViewDir_xyz_1.xyzx);
                float r7_x_17 = r7_xyzw_17.x;
                float r7_y_15 = r7_xyzw_17.y;
                float r7_z_14 = r7_xyzw_17.z;
                float3 r8_xyz_1 = ((r2_w_4.xxxx * _LightColor0.xyzx)).xyz;
                float3 r10_xyz_4;
                if (r3_w_4)
                {
                    float r2_w_5 = (cb6_values[0].y == 1);
                    float3 r9_xyz_4 = (((mad(cb6_values[3].xyzx, i.texcoord4.wwww, (mad(cb6_values[1].xyzx, i.texcoord2.wwww, ((i.texcoord3.wwww * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r9_xyzw_7 = (((((r2_w_5.xxxx ? r9_xyz_4.xyzx : float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1))).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r9_y_7 = r9_xyzw_7.y;
                    float r9_z_7 = r9_xyzw_7.z;
                    float r9_w_1 = r9_xyzw_7.w;
                    float r2_w_6 = (r9_y_7 * 0.25);
                    float r3_w_5 = (cb6_values[0].z * 0.5);
                    float r7_w_5 = mad(-cb6_values[0].z, 0.5, 0.25);
                    float r2_w_7 = max(r2_w_6, r3_w_5);
                    float r9_x_7 = min(r7_w_5, r2_w_7);
                    float4 r10_xyzw_2 = t7.Sample(sampler_linear_clamp1, (float4(r9_x_7, r9_z_7, r9_w_1, r9_x_7)).xyz);
                    float4 r11_xyzw_2 = t7.Sample(sampler_linear_clamp1, (((float4(r9_x_7, r9_z_7, r9_w_1, r9_x_7) + float4(0.25, 0, 0, 0))).xyzx).xyz);
                    float4 r9_xyzw_9 = t7.Sample(sampler_linear_clamp1, (((float4(r9_x_7, r9_z_7, r9_w_1, r9_x_7) + float4(0.5, 0, 0, 0))).xyzx).xyz);
                    float r5_w_7 = 1;
                    float r10_x_3 = dot(r10_xyzw_2, float4(r5_x_6, r5_y_3, r5_z_3, r5_w_7));
                    float r10_y_3 = dot(r11_xyzw_2, float4(r5_x_6, r5_y_3, r5_z_3, r5_w_7));
                    float r10_z_3 = dot(r9_xyzw_9, float4(r5_x_6, r5_y_3, r5_z_3, r5_w_7));
                    r10_xyz_4 = float3(r10_x_3, r10_y_3, r10_z_3);
                }
                else
                {
                    float r5_w_6 = 1;
                    float r10_x_1 = dot(cb2_values[39].xyzw, float4(r5_x_6, r5_y_3, r5_z_3, r5_w_6));
                    float r10_y_1 = dot(cb2_values[40].xyzw, float4(r5_x_6, r5_y_3, r5_z_3, r5_w_6));
                    float r10_z_1 = dot(cb2_values[41].xyzw, float4(r5_x_6, r5_y_3, r5_z_3, r5_w_6));
                    r10_xyz_4 = float3(r10_x_1, r10_y_1, r10_z_1);
                }
                float r2_w_9 = (0 < cb5_values[2].w);
                float3 r10_xyz_8;
                if (r2_w_9)
                {
                    float r2_w_10 = dot(float4(r7_x_17, r7_y_15, r7_z_14, r7_x_17), float4(r7_x_17, r7_y_15, r7_z_14, r7_x_17));
                    float r2_w_11 = rsqrt(r2_w_10);
                    float3 r10_xyz_6 = ((r2_w_11.xxxx * float4(r7_x_17, r7_y_15, r7_z_14, r7_x_17))).xyz;
                    float3 r13_xyz_1 = ((float4(0, 0, 0, 0) < r10_xyz_6.xyzx)).xyz;
                    float3 r11_xyz_6 = ((r13_xyz_1.xyzx ? ((((-float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + cb5_values[0].xyzx)).xyzx / r10_xyz_6.xyzx)).xyzx : ((((-float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + cb5_values[1].xyzx)).xyzx / r10_xyz_6.xyzx)).xyzx)).xyz;
                    float r2_w_12 = min(r11_xyz_6.y, r11_xyz_6.x);
                    float r2_w_13 = min(r11_xyz_6.z, r2_w_12);
                    r10_xyz_8 = (mad(r10_xyz_6.xyzx, r2_w_13.xxxx, ((float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + -cb5_values[2].xyzx)).xyzx)).xyz;
                }
                else
                {
                    r10_xyz_8 = (float4(r7_x_17, r7_y_15, r7_z_14, r7_x_17)).xyz;
                }
                float r2_w_15 = mad(-r6_w_4, 0.7, 1.7);
                float r2_w_16 = (r2_w_15 * r6_w_4);
                float r2_w_17 = (r2_w_16 * 6);
                float4 r10_xyzw_9 = t5.SampleLevel(sampler_linear_clamp, r10_xyz_8.xyz, r2_w_17);
                float r3_w_7 = (r10_xyzw_9.w + -1);
                float r3_w_8 = mad(cb5_values[3].w, r3_w_7, 1);
                float r3_w_9 = log2(r3_w_8);
                float r3_w_10 = (r3_w_9 * cb5_values[3].y);
                float r3_w_11 = exp2(r3_w_10);
                float r3_w_12 = (r3_w_11 * cb5_values[3].x);
                float r5_w_9 = (cb5_values[1].w < 0.99999);
                float3 r11_xyz_11 = ((r10_xyzw_9.xyzx * r3_w_12.xxxx)).xyz;
                if (r5_w_9)
                {
                    float r5_w_10 = (0 < cb5_values[6].w);
                    float r7_x_19 = r7_x_17;
                    float r7_y_17 = r7_y_15;
                    float r7_z_16 = r7_z_14;
                    if (r5_w_10)
                    {
                        float r5_w_11 = dot(float4(r7_x_17, r7_y_15, r7_z_14, r7_x_17), float4(r7_x_17, r7_y_15, r7_z_14, r7_x_17));
                        float r5_w_12 = rsqrt(r5_w_11);
                        float3 r12_xyz_4 = ((r5_w_12.xxxx * float4(r7_x_17, r7_y_15, r7_z_14, r7_x_17))).xyz;
                        float3 r15_xyz_1 = ((float4(0, 0, 0, 0) < r12_xyz_4.xyzx)).xyz;
                        float3 r13_xyz_5 = ((r15_xyz_1.xyzx ? ((((-float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + cb5_values[4].xyzx)).xyzx / r12_xyz_4.xyzx)).xyzx : ((((-float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + cb5_values[5].xyzx)).xyzx / r12_xyz_4.xyzx)).xyzx)).xyz;
                        float r5_w_13 = min(r13_xyz_5.y, r13_xyz_5.x);
                        float r5_w_14 = min(r13_xyz_5.z, r5_w_13);
                        float4 r7_xyzw_18 = mad(r12_xyz_4.xyzx, r5_w_14.xxxx, ((float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + -cb5_values[6].xyzx)).xyzx);
                        float r7_x_18 = r7_xyzw_18.x;
                        float r7_y_16 = r7_xyzw_18.y;
                        float r7_z_15 = r7_xyzw_18.z;
                        r7_x_19 = r7_x_18;
                        r7_y_17 = r7_y_16;
                        r7_z_16 = r7_z_15;
                    }
                    float4 r7_xyzw_20 = t6.SampleLevel(sampler_linear_clamp, (float4(r7_x_19, r7_y_17, r7_z_16, r7_x_19)).xyz, r2_w_17);
                                        float4 r0_xyzw_10 = (r7_xyzw_20.xyzx * ((pow(mad(cb5_values[7].w, (r7_xyzw_20.w + -1), 1), cb5_values[7].y) * cb5_values[7].x)).xxxx);
                    float r0_x_10 = r0_xyzw_10.x;
                    float r0_y_4 = r0_xyzw_10.y;
                    float r0_z_4 = r0_xyzw_10.z;
                    float4 r7_xyzw_21 = mad(r3_w_12.xxxx, r10_xyzw_9.xyzx, -float4(r0_x_10, r0_y_4, r0_z_4, r0_x_10));
                    float r7_x_21 = r7_xyzw_21.x;
                    float r7_y_19 = r7_xyzw_21.y;
                    float r7_z_18 = r7_xyzw_21.z;
                    r11_xyz_11 = (mad(cb5_values[1].wwww, float4(r7_x_21, r7_y_19, r7_z_18, r7_x_21), float4(r0_x_10, r0_y_4, r0_z_4, r0_x_10))).xyz;
                }
                float4 r0_xyzw_12 = (r1_w_4.xxxx * r11_xyz_11.xyzx);
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_6 = r0_xyzw_12.y;
                float r0_z_6 = r0_xyzw_12.z;
                float r2_w_18 = max(r6_xyz_1.y, r6_xyz_1.x);
                float r2_w_19 = max(r6_xyz_1.z, r2_w_18);
                float r2_w_20 = (-r2_w_19 + 1);
                float4 r7_xyzw_23 = (r2_w_20.xxxx * r3_xyz_2.xyzx);
                float r7_x_23 = r7_xyzw_23.x;
                float r7_y_21 = r7_xyzw_23.y;
                float r7_z_20 = r7_xyzw_23.z;
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r1_xyz_3 = ((r0_w_5.xxxx * r1_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r5_x_6, r5_y_3, r5_z_3, r5_x_6), unitViewDir_xyz_1.xyzx);
                float r2_x_2 = saturate(dot(float4(r5_x_6, r5_y_3, r5_z_3, r5_x_6), _WorldSpaceLightPos0.xyzx));
                float r2_y_2 = saturate(dot(float4(r5_x_6, r5_y_3, r5_z_3, r5_x_6), r1_xyz_3.xyzx));
                float r1_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r1_xyz_3.xyzx));
                float r1_y_4 = (r1_x_4 * r1_x_4);
                float r1_y_5 = dot(r1_y_4.xxxx, r6_w_4.xxxx);
                float r1_y_6 = (r1_y_5 + -0.5);
                float r1_z_4 = (-r2_x_2 + 1);
                float r2_z_2 = (r1_z_4 * r1_z_4);
                float r2_z_3 = (r2_z_2 * r2_z_2);
                float r1_z_5 = (r1_z_4 * r2_z_3);
                float r1_z_6 = mad(r1_y_6, r1_z_5, 1);
                float r2_z_4 = (-abs(r0_w_6) + 1);
                float r3_w_13 = (r2_z_4 * r2_z_4);
                float r3_w_14 = (r3_w_13 * r3_w_13);
                float r2_z_5 = (r2_z_4 * r3_w_14);
                float r1_y_7 = mad(r1_y_6, r2_z_5, 1);
                float r1_y_8 = (r1_y_7 * r1_z_6);
                float r1_y_9 = (r2_x_2 * r1_y_8);
                float r1_z_7 = (r6_w_4 * r6_w_4);
                float r1_z_8 = max(r1_z_7, 0.002);
                float r3_w_15 = (-r1_z_8 + 1);
                float r3_w_16 = mad(r2_x_2, r3_w_15, r1_z_8);
                float r0_w_7 = (abs(r0_w_6) * r3_w_16);
                float r0_w_8 = mad(r2_x_2, mad(abs(r0_w_6), r3_w_15, r1_z_8), r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r3_w_17 = (r1_z_8 * r1_z_8);
                float r2_y_3 = mad(mad(r2_y_2, r3_w_17, -r2_y_2), r2_y_2, 1);
                float r3_w_18 = (r3_w_17 * 0.31830987);
                float r2_y_4 = mad(r2_y_3, r2_y_3, 1E-07);
                float r2_y_5 = (r3_w_18 / r2_y_4);
                float r0_w_11 = (r0_w_10 * r2_y_5);
                float r0_w_12 = (r0_w_11 * 3.1415927);
                float r0_w_13 = (r2_x_2 * r0_w_12);
                float r0_w_14 = max(r0_w_13, 0);
                float r1_z_9 = mad(r1_z_8, r1_z_8, 1);
                float r1_z_10 = ((float4(1, 1, 1, 1) / r1_z_9)).z;
                float r0_w_15 = (r0_w_14 * asfloat(asint((float)((dot(r6_xyz_1.xyzx, r6_xyz_1.xyzx) != 0))) & asint(1065353216)));
                float4 r5_xyzw_9 = (r1_y_9.xxxx * r8_xyz_1.xyzx);
                float r5_x_9 = r5_xyzw_9.x;
                float r5_y_4 = r5_xyzw_9.y;
                float r5_z_4 = r5_xyzw_9.z;
                float4 r5_xyzw_10 = mad((max(((r10_xyz_4.xyzx + i.texcoord5.xyzx)).xyzx, float4(0, 0, 0, 0))).xyzx, r1_w_4.xxxx, float4(r5_x_9, r5_y_4, r5_z_4, r5_x_9));
                float r5_x_10 = r5_xyzw_10.x;
                float r5_y_5 = r5_xyzw_10.y;
                float r5_z_5 = r5_xyzw_10.z;
                float r0_w_16 = (-r1_x_4 + 1);
                float r1_x_5 = (r0_w_16 * r0_w_16);
                float r1_x_6 = (r1_x_5 * r1_x_5);
                float4 r0_xyzw_13 = (float4(r0_x_12, r0_y_6, r0_z_6, r0_w_16) * float4(r1_z_10, r1_z_10, r1_z_10, r1_x_6));
                float4 r1_xyzw_7 = mad(-_SpecColor.xyxz, r4_xyzw_1.xyxz, float4(1, 1, 0, 1));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_10 = r1_xyzw_7.y;
                float r1_w_5 = r1_xyzw_7.w;
                float4 r1_xyzw_8 = mad(float4(r1_x_7, r1_y_10, r1_x_7, r1_w_5), r0_xyzw_13.wwww, r6_xyz_1.xyxz);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_11 = r1_xyzw_8.y;
                float r1_w_6 = r1_xyzw_8.w;
                float4 r1_xyzw_9 = (float4(r1_x_8, r1_y_11, r1_x_8, r1_w_6) * ((r8_xyz_1.xyzx * r0_w_15.xxxx)).xyxz);
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_12 = r1_xyzw_9.y;
                float r1_w_7 = r1_xyzw_9.w;
                float4 r1_xyzw_10 = mad(float4(r7_x_23, r7_y_21, r7_x_23, r7_z_20), float4(r5_x_10, r5_y_5, r5_x_10, r5_z_5), float4(r1_x_9, r1_y_12, r1_x_9, r1_w_7));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_13 = r1_xyzw_10.y;
                float r1_w_8 = r1_xyzw_10.w;
                float4 r2_xyzw_8 = mad(-_SpecColor.xyxz, r4_xyzw_1.xyxz, (saturate((mad(_Glossiness, r4_xyzw_1.w, -r2_w_20) + 1))).xxxx);
                float r2_x_8 = r2_xyzw_8.x;
                float r2_y_6 = r2_xyzw_8.y;
                float r2_w_21 = r2_xyzw_8.w;
                float4 r2_xyzw_9 = mad(r2_z_5.xxxx, float4(r2_x_8, r2_y_6, r2_w_21, r2_x_8), r6_xyz_1.xyzx);
                float r2_x_9 = r2_xyzw_9.x;
                float r2_y_7 = r2_xyzw_9.y;
                float r2_z_6 = r2_xyzw_9.z;
                float4 r0_xyzw_14 = mad(r0_xyzw_13.xyzx, float4(r2_x_9, r2_y_7, r2_z_6, r2_x_9), float4(r1_x_10, r1_y_13, r1_w_8, r1_x_10));
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
            SamplerState sampler_SpecGlossMap;
            SamplerState sampler_BumpMap;
            SamplerState sampler_OcclusionMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _SpecGlossMap;
            Texture2D _OcclusionMap;
            Texture2D t4;
            TextureCube t5;
            TextureCube t6;
            Texture3D t7;
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
                float4 texcoord7 : TEXCOORD7;
                float4 texcoord8 : TEXCOORD8;
            };
            struct program32Input
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
            struct program32Output
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
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _SpecGlossMap_ST.xyxx, _SpecGlossMap_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _OcclusionMap_ST.xxxy, _OcclusionMap_ST.zzzw)).zw;
                o.texcoord2.w = r0_xyz_4.x;
                float r2_y_4 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float r2_z_4 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float r2_x_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float3 unitWorldNormal_xyz_5 = (((rsqrt(dot(float4(r2_x_4, r2_y_4, r2_z_4, r2_x_4), float4(r2_x_4, r2_y_4, r2_z_4, r2_x_4)))).xxxx * float4(r2_x_4, r2_y_4, r2_z_4, r2_x_4))).xyz;
                float3 worldTangent_xyz_1 = ((i.tangent0.yyyy * cb2_values[1].yzxy)).xyz;
                float3 worldTangent_xyz_2 = (mad(cb2_values[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_1.xyzx)).xyz;
                float3 worldTangent_xyz_3 = (mad(cb2_values[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_2.xyzx)).xyz;
                float3 unitWorldTangent_xyz_4 = (((rsqrt(dot(worldTangent_xyz_3.xyzx, worldTangent_xyz_3.xyzx))).xxxx * worldTangent_xyz_3.xyzx)).xyz;
                float3 r4_xyz_3 = ((((i.tangent0.w * cb2_values[9].w)).xxxx * (mad(unitWorldNormal_xyz_5.zxyz, unitWorldTangent_xyz_4.yzxy, ((unitWorldNormal_xyz_5.xyzx * unitWorldTangent_xyz_4.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord2.y = r4_xyz_3.x;
                o.texcoord2.x = unitWorldTangent_xyz_4.z;
                o.texcoord2.z = unitWorldNormal_xyz_5.y;
                o.texcoord3.x = unitWorldTangent_xyz_4.x;
                o.texcoord4.x = unitWorldTangent_xyz_4.y;
                o.texcoord3.z = unitWorldNormal_xyz_5.z;
                o.texcoord4.z = unitWorldNormal_xyz_5.x;
                o.texcoord3.w = r0_xyz_4.y;
                o.texcoord4.w = r0_xyz_4.z;
                o.texcoord3.y = r4_xyz_3.y;
                o.texcoord4.y = r4_xyz_3.z;
                float r0_w_4 = ((clipPos_xyzw_2.y * unity_WorldToObject[1].x) * 0.5);
                float4 r0_xyzw_11 = (clipPos_xyzw_2.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_z_5 = r0_xyzw_11.z;
                o.texcoord7.zw = (clipPos_xyzw_2.zzzw).zw;
                o.texcoord7.xy = ((r0_z_5.xxxx + float4(r0_x_11, r0_w_4, r0_x_11, r0_x_11))).xy;
                o.texcoord8.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program32Output frag(program32Input i)
            {
                program32Output o = (program32Output)0;
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
                float r7_x_1 = cb4_values[9].z;
                float r7_y_1 = cb4_values[10].z;
                float r7_z_1 = cb4_values[11].z;
                float r2_w_1 = dot(viewDir_xyz_1.xyzx, float4(r7_x_1, r7_y_1, r7_z_1, r7_x_1));
                float3 r7_xyz_2 = ((float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + -cb3_values[25].xyzx)).xyz;
                float r3_w_1 = dot(r7_xyz_2.xyzx, r7_xyz_2.xyzx);
                float r3_w_2 = sqrt(r3_w_1);
                float r3_w_3 = (-r2_w_1 + r3_w_2);
                float r2_w_2 = mad(cb3_values[25].w, r3_w_3, r2_w_1);
                float r2_w_3 = saturate(mad(r2_w_2, cb3_values[24].z, cb3_values[24].w));
                float r3_w_4 = (cb6_values[0].x == 1);
                float r7_x_12;
                float r7_y_12;
                float r7_z_12;
                float r7_w_4;
                if (r3_w_4)
                {
                    float r3_w_5 = (cb6_values[0].y == 1);
                    float3 r7_xyz_7 = (((mad(cb6_values[3].xyzx, i.texcoord4.wwww, (mad(cb6_values[1].xyzx, i.texcoord2.wwww, ((i.texcoord3.wwww * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r7_xyzw_10 = (((((r3_w_5.xxxx ? r7_xyz_7.xyzx : float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1))).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r7_y_10 = r7_xyzw_10.y;
                    float r7_z_10 = r7_xyzw_10.z;
                    float r7_w_2 = r7_xyzw_10.w;
                    float r3_w_6 = mad(r7_y_10, 0.25, 0.75);
                    float r5_w_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r7_x_10 = max(r3_w_6, r5_w_1);
                    float4 r7_xyzw_11 = t7.Sample(sampler_linear_clamp1, (float4(r7_x_10, r7_z_10, r7_w_2, r7_x_10)).xyz);
                    r7_x_12 = r7_xyzw_11.x;
                    r7_y_12 = r7_xyzw_11.y;
                    r7_z_12 = r7_xyzw_11.z;
                    r7_w_4 = r7_xyzw_11.w;
                }
                else
                {
                    float4 r7_xyzw_3 = float4(1, 1, 1, 1);
                    r7_x_12 = r7_xyzw_3.x;
                    r7_y_12 = r7_xyzw_3.y;
                    r7_z_12 = r7_xyzw_3.z;
                    r7_w_4 = r7_xyzw_3.w;
                }
                float r3_w_8 = saturate(dot(float4(r7_x_12, r7_y_12, r7_z_12, r7_w_4), unity_OcclusionMaskSelector));
                float r5_w_3 = (t4.Sample(sampler_linear_clamp2, (((i.texcoord7.xyxx / i.texcoord7.wwww)).xyxx).xy)).w;
                float r3_w_9 = (r3_w_8 + -r5_w_3);
                float r2_w_4 = mad(r2_w_3, r3_w_9, r5_w_3);
                float r7_x_14 = dot(i.texcoord2.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float r7_y_14 = dot(i.texcoord3.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float r7_z_13 = dot(i.texcoord4.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float r3_w_10 = dot(float4(r7_x_14, r7_y_14, r7_z_13, r7_x_14), float4(r7_x_14, r7_y_14, r7_z_13, r7_x_14));
                float r3_w_11 = rsqrt(r3_w_10);
                float4 r5_xyzw_4 = (r3_w_11.xxxx * float4(r7_x_14, r7_y_14, r7_z_13, r7_x_14));
                float r5_x_4 = r5_xyzw_4.x;
                float r5_y_3 = r5_xyzw_4.y;
                float r5_z_3 = r5_xyzw_4.z;
                float r3_w_12 = mad(-_Glossiness, r4_xyzw_1.w, 1);
                float r5_w_4 = dot(-unitViewDir_xyz_1.xyzx, float4(r5_x_4, r5_y_3, r5_z_3, r5_x_4));
                float r5_w_5 = (r5_w_4 + r5_w_4);
                float4 r7_xyzw_15 = mad(float4(r5_x_4, r5_y_3, r5_z_3, r5_x_4), -r5_w_5.xxxx, -unitViewDir_xyz_1.xyzx);
                float r7_x_15 = r7_xyzw_15.x;
                float r7_y_15 = r7_xyzw_15.y;
                float r7_z_14 = r7_xyzw_15.z;
                float3 r8_xyz_1 = ((r2_w_4.xxxx * _LightColor0.xyzx)).xyz;
                float r2_w_5 = (0 < cb5_values[2].w);
                float3 r9_xyz_4;
                if (r2_w_5)
                {
                    float r2_w_6 = dot(float4(r7_x_15, r7_y_15, r7_z_14, r7_x_15), float4(r7_x_15, r7_y_15, r7_z_14, r7_x_15));
                    float r2_w_7 = rsqrt(r2_w_6);
                    float3 r9_xyz_2 = ((r2_w_7.xxxx * float4(r7_x_15, r7_y_15, r7_z_14, r7_x_15))).xyz;
                    float3 r12_xyz_1 = ((float4(0, 0, 0, 0) < r9_xyz_2.xyzx)).xyz;
                    float3 r10_xyz_3 = ((r12_xyz_1.xyzx ? ((((-float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + cb5_values[0].xyzx)).xyzx / r9_xyz_2.xyzx)).xyzx : ((((-float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + cb5_values[1].xyzx)).xyzx / r9_xyz_2.xyzx)).xyzx)).xyz;
                    float r2_w_8 = min(r10_xyz_3.y, r10_xyz_3.x);
                    float r2_w_9 = min(r10_xyz_3.z, r2_w_8);
                    r9_xyz_4 = (mad(r9_xyz_2.xyzx, r2_w_9.xxxx, ((float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + -cb5_values[2].xyzx)).xyzx)).xyz;
                }
                else
                {
                    r9_xyz_4 = (float4(r7_x_15, r7_y_15, r7_z_14, r7_x_15)).xyz;
                }
                float r2_w_11 = mad(-r3_w_12, 0.7, 1.7);
                float r2_w_12 = (r2_w_11 * r3_w_12);
                float r2_w_13 = (r2_w_12 * 6);
                float4 r9_xyzw_5 = t5.SampleLevel(sampler_linear_clamp, r9_xyz_4.xyz, r2_w_13);
                float r5_w_6 = (r9_xyzw_5.w + -1);
                float r5_w_7 = mad(cb5_values[3].w, r5_w_6, 1);
                float r5_w_8 = log2(r5_w_7);
                float r5_w_9 = (r5_w_8 * cb5_values[3].y);
                float r5_w_10 = exp2(r5_w_9);
                float r5_w_11 = (r5_w_10 * cb5_values[3].x);
                float r6_w_1 = (cb5_values[1].w < 0.99999);
                float3 r10_xyz_8 = ((r9_xyzw_5.xyzx * r5_w_11.xxxx)).xyz;
                if (r6_w_1)
                {
                    float r6_w_2 = (0 < cb5_values[6].w);
                    float r7_x_17 = r7_x_15;
                    float r7_y_17 = r7_y_15;
                    float r7_z_16 = r7_z_14;
                    if (r6_w_2)
                    {
                        float r6_w_3 = dot(float4(r7_x_15, r7_y_15, r7_z_14, r7_x_15), float4(r7_x_15, r7_y_15, r7_z_14, r7_x_15));
                        float r6_w_4 = rsqrt(r6_w_3);
                        float3 r11_xyz_4 = ((r6_w_4.xxxx * float4(r7_x_15, r7_y_15, r7_z_14, r7_x_15))).xyz;
                        float3 r14_xyz_1 = ((float4(0, 0, 0, 0) < r11_xyz_4.xyzx)).xyz;
                        float3 r12_xyz_5 = ((r14_xyz_1.xyzx ? ((((-float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + cb5_values[4].xyzx)).xyzx / r11_xyz_4.xyzx)).xyzx : ((((-float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + cb5_values[5].xyzx)).xyzx / r11_xyz_4.xyzx)).xyzx)).xyz;
                        float r6_w_5 = min(r12_xyz_5.y, r12_xyz_5.x);
                        float r6_w_6 = min(r12_xyz_5.z, r6_w_5);
                        float4 r7_xyzw_16 = mad(r11_xyz_4.xyzx, r6_w_6.xxxx, ((float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + -cb5_values[6].xyzx)).xyzx);
                        float r7_x_16 = r7_xyzw_16.x;
                        float r7_y_16 = r7_xyzw_16.y;
                        float r7_z_15 = r7_xyzw_16.z;
                        r7_x_17 = r7_x_16;
                        r7_y_17 = r7_y_16;
                        r7_z_16 = r7_z_15;
                    }
                    float4 r7_xyzw_18 = t6.SampleLevel(sampler_linear_clamp, (float4(r7_x_17, r7_y_17, r7_z_16, r7_x_17)).xyz, r2_w_13);
                                        float4 r0_xyzw_10 = (r7_xyzw_18.xyzx * ((pow(mad(cb5_values[7].w, (r7_xyzw_18.w + -1), 1), cb5_values[7].y) * cb5_values[7].x)).xxxx);
                    float r0_x_10 = r0_xyzw_10.x;
                    float r0_y_4 = r0_xyzw_10.y;
                    float r0_z_4 = r0_xyzw_10.z;
                    float4 r7_xyzw_19 = mad(r5_w_11.xxxx, r9_xyzw_5.xyzx, -float4(r0_x_10, r0_y_4, r0_z_4, r0_x_10));
                    float r7_x_19 = r7_xyzw_19.x;
                    float r7_y_19 = r7_xyzw_19.y;
                    float r7_z_18 = r7_xyzw_19.z;
                    r10_xyz_8 = (mad(cb5_values[1].wwww, float4(r7_x_19, r7_y_19, r7_z_18, r7_x_19), float4(r0_x_10, r0_y_4, r0_z_4, r0_x_10))).xyz;
                }
                float4 r0_xyzw_12 = (r1_w_4.xxxx * r10_xyz_8.xyzx);
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_6 = r0_xyzw_12.y;
                float r0_z_6 = r0_xyzw_12.z;
                float r1_w_5 = max(r6_xyz_1.y, r6_xyz_1.x);
                float r1_w_6 = max(r6_xyz_1.z, r1_w_5);
                float r1_w_7 = (-r1_w_6 + 1);
                float4 r7_xyzw_21 = (r1_w_7.xxxx * r3_xyz_2.xyzx);
                float r7_x_21 = r7_xyzw_21.x;
                float r7_y_21 = r7_xyzw_21.y;
                float r7_z_20 = r7_xyzw_21.z;
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
                float r1_y_5 = dot(r1_y_4.xxxx, r3_w_12.xxxx);
                float r1_y_6 = (r1_y_5 + -0.5);
                float r1_z_4 = (-r2_x_2 + 1);
                float r2_z_2 = (r1_z_4 * r1_z_4);
                float r2_z_3 = (r2_z_2 * r2_z_2);
                float r1_z_5 = (r1_z_4 * r2_z_3);
                float r1_z_6 = mad(r1_y_6, r1_z_5, 1);
                float r2_z_4 = (-abs(r0_w_6) + 1);
                float r2_w_14 = (r2_z_4 * r2_z_4);
                float r2_w_15 = (r2_w_14 * r2_w_14);
                float r2_z_5 = (r2_z_4 * r2_w_15);
                float r1_y_7 = mad(r1_y_6, r2_z_5, 1);
                float r1_y_8 = (r1_y_7 * r1_z_6);
                float r1_y_9 = (r2_x_2 * r1_y_8);
                float r1_z_7 = (r3_w_12 * r3_w_12);
                float r1_z_8 = max(r1_z_7, 0.002);
                float r2_w_16 = (-r1_z_8 + 1);
                float r3_w_13 = mad(abs(r0_w_6), r2_w_16, r1_z_8);
                float r2_w_17 = mad(r2_x_2, r2_w_16, r1_z_8);
                float r0_w_7 = (abs(r0_w_6) * r2_w_17);
                float r0_w_8 = mad(r2_x_2, r3_w_13, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r2_w_18 = (r1_z_8 * r1_z_8);
                float r3_w_14 = mad(r2_y_2, r2_w_18, -r2_y_2);
                float r2_y_3 = mad(r3_w_14, r2_y_2, 1);
                float r2_w_19 = (r2_w_18 * 0.31830987);
                float r2_y_4 = mad(r2_y_3, r2_y_3, 1E-07);
                float r2_y_5 = (r2_w_19 / r2_y_4);
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
                float r2_w_20 = r2_xyzw_6.w;
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
                float4 r2_xyzw_7 = mad(float4(r7_x_21, r7_y_21, r7_x_21, r7_z_20), float4(r2_x_6, r2_y_6, r2_x_6, r2_w_20), float4(r5_x_6, r5_y_5, r5_x_6, r5_z_5));
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_7 = r2_xyzw_7.y;
                float r2_w_21 = r2_xyzw_7.w;
                float4 r1_xyzw_7 = mad(-_SpecColor.xyzx, r4_xyzw_1.xyzx, r1_w_9.xxxx);
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_10 = r1_xyzw_7.y;
                float r1_z_11 = r1_xyzw_7.z;
                float4 r1_xyzw_8 = mad(r2_z_5.xxxx, float4(r1_x_7, r1_y_10, r1_z_11, r1_x_7), r6_xyz_1.xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_11 = r1_xyzw_8.y;
                float r1_z_12 = r1_xyzw_8.z;
                float4 r0_xyzw_14 = mad(r0_xyzw_13.xyzx, float4(r1_x_8, r1_y_11, r1_z_12, r1_x_8), float4(r2_x_7, r2_y_7, r2_w_21, r2_x_7));
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
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord7 : TEXCOORD7;
                float4 texcoord8 : TEXCOORD8;
            };
            struct program31Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord7 : TEXCOORD7;
                float4 texcoord8 : TEXCOORD8;
            };
            struct program31Output
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
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _SpecGlossMap_ST.xyxx, _SpecGlossMap_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _OcclusionMap_ST.xxxy, _OcclusionMap_ST.zzzw)).zw;
                o.texcoord2.w = r0_xyz_4.x;
                float3 worldTangent_xyz_2 = ((i.tangent0.yyyy * cb2_values[1].yzxy)).xyz;
                float3 worldTangent_xyz_3 = (mad(cb2_values[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_2.xyzx)).xyz;
                float3 worldTangent_xyz_4 = (mad(cb2_values[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_3.xyzx)).xyz;
                float3 unitWorldTangent_xyz_5 = (((rsqrt(dot(worldTangent_xyz_4.xyzx, worldTangent_xyz_4.xyzx))).xxxx * worldTangent_xyz_4.xyzx)).xyz;
                o.texcoord2.x = unitWorldTangent_xyz_5.z;
                float worldNormal_x_4 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float4 unitWorldNormal_xyzw_5 = ((rsqrt(dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4)))).xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_z_4));
                float3 r3_xyz_3 = ((((i.tangent0.w * cb2_values[9].w)).xxxx * (mad(unitWorldNormal_xyzw_5.ywxy, unitWorldTangent_xyz_5.yzxy, ((unitWorldTangent_xyz_5.xyzx * unitWorldNormal_xyzw_5.wxyw)).xyzx)).xyzx)).xyz;
                o.texcoord2.y = r3_xyz_3.x;
                o.texcoord2.z = unitWorldNormal_xyzw_5.x;
                o.texcoord3.x = unitWorldTangent_xyz_5.x;
                o.texcoord4.x = unitWorldTangent_xyz_5.y;
                o.texcoord3.w = r0_xyz_4.y;
                o.texcoord4.w = r0_xyz_4.z;
                o.texcoord3.y = r3_xyz_3.y;
                o.texcoord4.y = r3_xyz_3.z;
                o.texcoord3.z = unitWorldNormal_xyzw_5.y;
                o.texcoord4.z = unitWorldNormal_xyzw_5.w;
                float4 r1_xyzw_6 = (unitWorldNormal_xyzw_5.ywzx * unitWorldNormal_xyzw_5);
                float r2_x_6 = dot(cb1_values[42].xyzw, r1_xyzw_6);
                float r2_y_6 = dot(cb1_values[43].xyzw, r1_xyzw_6);
                float r2_z_6 = dot(cb1_values[44].xyzw, r1_xyzw_6);
                o.texcoord5.xyz = (mad(cb1_values[45].xyzx, (mad(unitWorldNormal_xyzw_5.x, unitWorldNormal_xyzw_5.x, (unitWorldNormal_xyzw_5.y * unitWorldNormal_xyzw_5.y))).xxxx, float4(r2_x_6, r2_y_6, r2_z_6, r2_x_6))).xyz;
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                o.texcoord8.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program31Output frag(program31Input i)
            {
                program31Output o = (program31Output)0;
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
                    float r3_w_1 = (unity_ProbeVolumeParams.y == 1);
                    float3 r7_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord4.wwww, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.wwww, ((i.texcoord3.wwww * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r3_w_1.xxxx ? r7_xyz_5.xyzx : float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1))).xyz;
                    float4 r7_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r7_y_8 = r7_xyzw_8.y;
                    float r7_z_8 = r7_xyzw_8.z;
                    float r7_w_2 = r7_xyzw_8.w;
                    float r3_w_2 = mad(r7_y_8, 0.25, 0.75);
                    float r5_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r7_x_8 = max(r3_w_2, r5_w_1);
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
                float r3_w_4 = saturate(dot(float4(r7_x_10, r7_y_10, r7_z_10, r7_w_4), unity_OcclusionMaskSelector));
                float r7_x_11 = dot(i.texcoord2.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float r7_y_11 = dot(i.texcoord3.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float r7_z_11 = dot(i.texcoord4.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float4 r5_xyzw_6 = ((rsqrt(dot(float4(r7_x_11, r7_y_11, r7_z_11, r7_x_11), float4(r7_x_11, r7_y_11, r7_z_11, r7_x_11)))).xxxx * float4(r7_x_11, r7_y_11, r7_z_11, r7_x_11));
                float r5_x_6 = r5_xyzw_6.x;
                float r5_y_3 = r5_xyzw_6.y;
                float r5_z_3 = r5_xyzw_6.z;
                float r6_w_1 = mad(-_Glossiness, r4_xyzw_1.w, 1);
                float r7_x_12 = dot(-unitViewDir_xyz_1.xyzx, float4(r5_x_6, r5_y_3, r5_z_3, r5_x_6));
                float4 r7_xyzw_14 = mad(float4(r5_x_6, r5_y_3, r5_z_3, r5_x_6), ((r7_x_12 + r7_x_12)).xxxx, -unitViewDir_xyz_1.xyzx);
                float r7_x_14 = r7_xyzw_14.x;
                float r7_y_12 = r7_xyzw_14.y;
                float r7_z_12 = r7_xyzw_14.z;
                float3 r8_xyz_1 = ((r3_w_4.xxxx * _LightColor0.xyzx)).xyz;
                float3 r10_xyz_4;
                if (r2_w_1)
                {
                    float r2_w_2 = (unity_ProbeVolumeParams.y == 1);
                    float3 r9_xyz_4 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord4.wwww, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.wwww, ((i.texcoord3.wwww * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_5 = ((r2_w_2.xxxx ? r9_xyz_4.xyzx : float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1))).xyz;
                    float4 r9_xyzw_7 = (((unity_ProbeVolumeParamsSelect_xyz_5.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r9_y_7 = r9_xyzw_7.y;
                    float r9_z_7 = r9_xyzw_7.z;
                    float r9_w_1 = r9_xyzw_7.w;
                    float r2_w_3 = (r9_y_7 * 0.25);
                    float r3_w_5 = (unity_ProbeVolumeParams.z * 0.5);
                    float r7_w_5 = mad(-unity_ProbeVolumeParams.z, 0.5, 0.25);
                    float r2_w_4 = max(r2_w_3, r3_w_5);
                    float r9_x_7 = min(r7_w_5, r2_w_4);
                    float4 r10_xyzw_2 = t6.Sample(sampler_linear_clamp1, (float4(r9_x_7, r9_z_7, r9_w_1, r9_x_7)).xyz);
                    float4 r11_xyzw_2 = t6.Sample(sampler_linear_clamp1, (((float4(r9_x_7, r9_z_7, r9_w_1, r9_x_7) + float4(0.25, 0, 0, 0))).xyzx).xyz);
                    float4 r9_xyzw_9 = t6.Sample(sampler_linear_clamp1, (((float4(r9_x_7, r9_z_7, r9_w_1, r9_x_7) + float4(0.5, 0, 0, 0))).xyzx).xyz);
                    float r5_w_4 = 1;
                    float r10_x_3 = dot(r10_xyzw_2, float4(r5_x_6, r5_y_3, r5_z_3, r5_w_4));
                    float r10_y_3 = dot(r11_xyzw_2, float4(r5_x_6, r5_y_3, r5_z_3, r5_w_4));
                    float r10_z_3 = dot(r9_xyzw_9, float4(r5_x_6, r5_y_3, r5_z_3, r5_w_4));
                    r10_xyz_4 = float3(r10_x_3, r10_y_3, r10_z_3);
                }
                else
                {
                    float r5_w_3 = 1;
                    float r10_x_1 = dot(cb2_values[39].xyzw, float4(r5_x_6, r5_y_3, r5_z_3, r5_w_3));
                    float r10_y_1 = dot(cb2_values[40].xyzw, float4(r5_x_6, r5_y_3, r5_z_3, r5_w_3));
                    float r10_z_1 = dot(cb2_values[41].xyzw, float4(r5_x_6, r5_y_3, r5_z_3, r5_w_3));
                    r10_xyz_4 = float3(r10_x_1, r10_y_1, r10_z_1);
                }
                float r2_w_6 = (0 < unity_SpecCube0_ProbePosition.w);
                float3 r10_xyz_8;
                if (r2_w_6)
                {
                    float r2_w_7 = dot(float4(r7_x_14, r7_y_12, r7_z_12, r7_x_14), float4(r7_x_14, r7_y_12, r7_z_12, r7_x_14));
                    float r2_w_8 = rsqrt(r2_w_7);
                    float3 r10_xyz_6 = ((r2_w_8.xxxx * float4(r7_x_14, r7_y_12, r7_z_12, r7_x_14))).xyz;
                    float3 r13_xyz_1 = ((float4(0, 0, 0, 0) < r10_xyz_6.xyzx)).xyz;
                    float3 r11_xyz_6 = ((r13_xyz_1.xyzx ? ((((-float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + unity_SpecCube0_BoxMax.xyzx)).xyzx / r10_xyz_6.xyzx)).xyzx : ((((-float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + unity_SpecCube0_BoxMin.xyzx)).xyzx / r10_xyz_6.xyzx)).xyzx)).xyz;
                    float r2_w_9 = min(r11_xyz_6.y, r11_xyz_6.x);
                    float r2_w_10 = min(r11_xyz_6.z, r2_w_9);
                    r10_xyz_8 = (mad(r10_xyz_6.xyzx, r2_w_10.xxxx, ((float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + -unity_SpecCube0_ProbePosition.xyzx)).xyzx)).xyz;
                }
                else
                {
                    r10_xyz_8 = (float4(r7_x_14, r7_y_12, r7_z_12, r7_x_14)).xyz;
                }
                float r2_w_12 = mad(-r6_w_1, 0.7, 1.7);
                float r2_w_13 = (r2_w_12 * r6_w_1);
                float r2_w_14 = (r2_w_13 * 6);
                float4 r10_xyzw_9 = t4.SampleLevel(sampler_linear_clamp, r10_xyz_8.xyz, r2_w_14);
                float r3_w_7 = (r10_xyzw_9.w + -1);
                float r3_w_8 = mad(unity_SpecCube0_HDR.w, r3_w_7, 1);
                float r3_w_9 = log2(r3_w_8);
                float r3_w_10 = (r3_w_9 * unity_SpecCube0_HDR.y);
                float r3_w_11 = exp2(r3_w_10);
                float r3_w_12 = (r3_w_11 * unity_SpecCube0_HDR.x);
                float r5_w_6 = (unity_SpecCube0_BoxMin.w < 0.99999);
                float3 r11_xyz_11 = ((r10_xyzw_9.xyzx * r3_w_12.xxxx)).xyz;
                if (r5_w_6)
                {
                    float r5_w_7 = (0 < unity_SpecCube1_ProbePosition.w);
                    float r7_x_16 = r7_x_14;
                    float r7_y_14 = r7_y_12;
                    float r7_z_14 = r7_z_12;
                    if (r5_w_7)
                    {
                        float r5_w_8 = dot(float4(r7_x_14, r7_y_12, r7_z_12, r7_x_14), float4(r7_x_14, r7_y_12, r7_z_12, r7_x_14));
                        float r5_w_9 = rsqrt(r5_w_8);
                        float3 r12_xyz_4 = ((r5_w_9.xxxx * float4(r7_x_14, r7_y_12, r7_z_12, r7_x_14))).xyz;
                        float3 r15_xyz_1 = ((float4(0, 0, 0, 0) < r12_xyz_4.xyzx)).xyz;
                        float3 r13_xyz_5 = ((r15_xyz_1.xyzx ? ((((-float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + unity_SpecCube1_BoxMax.xyzx)).xyzx / r12_xyz_4.xyzx)).xyzx : ((((-float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + unity_SpecCube1_BoxMin.xyzx)).xyzx / r12_xyz_4.xyzx)).xyzx)).xyz;
                        float r5_w_10 = min(r13_xyz_5.y, r13_xyz_5.x);
                        float r5_w_11 = min(r13_xyz_5.z, r5_w_10);
                        float4 r7_xyzw_15 = mad(r12_xyz_4.xyzx, r5_w_11.xxxx, ((float4(TEXCOORD2_x_1, TEXCOORD3_y_1, TEXCOORD4_z_1, TEXCOORD2_x_1) + -unity_SpecCube1_ProbePosition.xyzx)).xyzx);
                        float r7_x_15 = r7_xyzw_15.x;
                        float r7_y_13 = r7_xyzw_15.y;
                        float r7_z_13 = r7_xyzw_15.z;
                        r7_x_16 = r7_x_15;
                        r7_y_14 = r7_y_13;
                        r7_z_14 = r7_z_13;
                    }
                    float4 r7_xyzw_17 = t5.SampleLevel(sampler_linear_clamp, (float4(r7_x_16, r7_y_14, r7_z_14, r7_x_16)).xyz, r2_w_14);
                                        float4 r0_xyzw_10 = (r7_xyzw_17.xyzx * ((pow(mad(unity_SpecCube1_HDR.w, (r7_xyzw_17.w + -1), 1), unity_SpecCube1_HDR.y) * unity_SpecCube1_HDR.x)).xxxx);
                    float r0_x_10 = r0_xyzw_10.x;
                    float r0_y_4 = r0_xyzw_10.y;
                    float r0_z_4 = r0_xyzw_10.z;
                    float4 r7_xyzw_18 = mad(r3_w_12.xxxx, r10_xyzw_9.xyzx, -float4(r0_x_10, r0_y_4, r0_z_4, r0_x_10));
                    float r7_x_18 = r7_xyzw_18.x;
                    float r7_y_16 = r7_xyzw_18.y;
                    float r7_z_16 = r7_xyzw_18.z;
                    r11_xyz_11 = (mad(unity_SpecCube0_BoxMin.wwww, float4(r7_x_18, r7_y_16, r7_z_16, r7_x_18), float4(r0_x_10, r0_y_4, r0_z_4, r0_x_10))).xyz;
                }
                float4 r0_xyzw_12 = (r1_w_4.xxxx * r11_xyz_11.xyzx);
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_6 = r0_xyzw_12.y;
                float r0_z_6 = r0_xyzw_12.z;
                float r2_w_15 = max(r6_xyz_1.y, r6_xyz_1.x);
                float r2_w_16 = max(r6_xyz_1.z, r2_w_15);
                float r2_w_17 = (-r2_w_16 + 1);
                float4 r7_xyzw_20 = (r2_w_17.xxxx * r3_xyz_2.xyzx);
                float r7_x_20 = r7_xyzw_20.x;
                float r7_y_18 = r7_xyzw_20.y;
                float r7_z_18 = r7_xyzw_20.z;
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r1_xyz_3 = ((r0_w_5.xxxx * r1_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r5_x_6, r5_y_3, r5_z_3, r5_x_6), unitViewDir_xyz_1.xyzx);
                float r2_x_2 = saturate(dot(float4(r5_x_6, r5_y_3, r5_z_3, r5_x_6), _WorldSpaceLightPos0.xyzx));
                float r2_y_2 = saturate(dot(float4(r5_x_6, r5_y_3, r5_z_3, r5_x_6), r1_xyz_3.xyzx));
                float r1_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r1_xyz_3.xyzx));
                float r1_y_4 = (r1_x_4 * r1_x_4);
                float r1_y_5 = dot(r1_y_4.xxxx, r6_w_1.xxxx);
                float r1_y_6 = (r1_y_5 + -0.5);
                float r1_z_4 = (-r2_x_2 + 1);
                float r2_z_2 = (r1_z_4 * r1_z_4);
                float r2_z_3 = (r2_z_2 * r2_z_2);
                float r1_z_5 = (r1_z_4 * r2_z_3);
                float r1_z_6 = mad(r1_y_6, r1_z_5, 1);
                float r2_z_4 = (-abs(r0_w_6) + 1);
                float r3_w_13 = (r2_z_4 * r2_z_4);
                float r3_w_14 = (r3_w_13 * r3_w_13);
                float r2_z_5 = (r2_z_4 * r3_w_14);
                float r1_y_7 = mad(r1_y_6, r2_z_5, 1);
                float r1_y_8 = (r1_y_7 * r1_z_6);
                float r1_y_9 = (r2_x_2 * r1_y_8);
                float r1_z_7 = (r6_w_1 * r6_w_1);
                float r1_z_8 = max(r1_z_7, 0.002);
                float r3_w_15 = (-r1_z_8 + 1);
                float r3_w_16 = mad(r2_x_2, r3_w_15, r1_z_8);
                float r0_w_7 = (abs(r0_w_6) * r3_w_16);
                float r0_w_8 = mad(r2_x_2, mad(abs(r0_w_6), r3_w_15, r1_z_8), r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r3_w_17 = (r1_z_8 * r1_z_8);
                float r2_y_3 = mad(mad(r2_y_2, r3_w_17, -r2_y_2), r2_y_2, 1);
                float r3_w_18 = (r3_w_17 * 0.31830987);
                float r2_y_4 = mad(r2_y_3, r2_y_3, 1E-07);
                float r2_y_5 = (r3_w_18 / r2_y_4);
                float r0_w_11 = (r0_w_10 * r2_y_5);
                float r0_w_12 = (r0_w_11 * 3.1415927);
                float r0_w_13 = (r2_x_2 * r0_w_12);
                float r0_w_14 = max(r0_w_13, 0);
                float r1_z_9 = mad(r1_z_8, r1_z_8, 1);
                float r1_z_10 = ((float4(1, 1, 1, 1) / r1_z_9)).z;
                float r0_w_15 = (r0_w_14 * asfloat(asint((float)((dot(r6_xyz_1.xyzx, r6_xyz_1.xyzx) != 0))) & asint(1065353216)));
                float4 r5_xyzw_9 = (r1_y_9.xxxx * r8_xyz_1.xyzx);
                float r5_x_9 = r5_xyzw_9.x;
                float r5_y_4 = r5_xyzw_9.y;
                float r5_z_4 = r5_xyzw_9.z;
                float4 r5_xyzw_10 = mad((max(((r10_xyz_4.xyzx + i.texcoord5.xyzx)).xyzx, float4(0, 0, 0, 0))).xyzx, r1_w_4.xxxx, float4(r5_x_9, r5_y_4, r5_z_4, r5_x_9));
                float r5_x_10 = r5_xyzw_10.x;
                float r5_y_5 = r5_xyzw_10.y;
                float r5_z_5 = r5_xyzw_10.z;
                float r0_w_16 = (-r1_x_4 + 1);
                float r1_x_5 = (r0_w_16 * r0_w_16);
                float r1_x_6 = (r1_x_5 * r1_x_5);
                float4 r0_xyzw_13 = (float4(r0_x_12, r0_y_6, r0_z_6, r0_w_16) * float4(r1_z_10, r1_z_10, r1_z_10, r1_x_6));
                float4 r1_xyzw_7 = mad(-_SpecColor.xyxz, r4_xyzw_1.xyxz, float4(1, 1, 0, 1));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_10 = r1_xyzw_7.y;
                float r1_w_5 = r1_xyzw_7.w;
                float4 r1_xyzw_8 = mad(float4(r1_x_7, r1_y_10, r1_x_7, r1_w_5), r0_xyzw_13.wwww, r6_xyz_1.xyxz);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_11 = r1_xyzw_8.y;
                float r1_w_6 = r1_xyzw_8.w;
                float4 r1_xyzw_9 = (float4(r1_x_8, r1_y_11, r1_x_8, r1_w_6) * ((r8_xyz_1.xyzx * r0_w_15.xxxx)).xyxz);
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_12 = r1_xyzw_9.y;
                float r1_w_7 = r1_xyzw_9.w;
                float4 r1_xyzw_10 = mad(float4(r7_x_20, r7_y_18, r7_x_20, r7_z_18), float4(r5_x_10, r5_y_5, r5_x_10, r5_z_5), float4(r1_x_9, r1_y_12, r1_x_9, r1_w_7));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_13 = r1_xyzw_10.y;
                float r1_w_8 = r1_xyzw_10.w;
                float4 r2_xyzw_8 = mad(-_SpecColor.xyxz, r4_xyzw_1.xyxz, (saturate((mad(_Glossiness, r4_xyzw_1.w, -r2_w_17) + 1))).xxxx);
                float r2_x_8 = r2_xyzw_8.x;
                float r2_y_6 = r2_xyzw_8.y;
                float r2_w_18 = r2_xyzw_8.w;
                float4 r2_xyzw_9 = mad(r2_z_5.xxxx, float4(r2_x_8, r2_y_6, r2_w_18, r2_x_8), r6_xyz_1.xyzx);
                float r2_x_9 = r2_xyzw_9.x;
                float r2_y_7 = r2_xyzw_9.y;
                float r2_z_6 = r2_xyzw_9.z;
                float4 r0_xyzw_14 = mad(r0_xyzw_13.xyzx, float4(r2_x_9, r2_y_7, r2_z_6, r2_x_9), float4(r1_x_10, r1_y_13, r1_w_8, r1_x_10));
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
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
                float4 cb1_values[6];
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
                float4 cb5_values[2];
            };
            cbuffer cb6 : register(b6)
            {
                float4 cb6_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerComparisonState sampler_comparison_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_MainTex;
            SamplerState sampler_SpecGlossMap;
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _SpecGlossMap;
            Texture2D _OcclusionMap;
            TextureCube t4;
            Texture3D t5;
            TextureCube t6;
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
                float3 texcoord2 : TEXCOORD2;
                float texcoord8 : TEXCOORD8;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program114Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float texcoord8 : TEXCOORD8;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program114Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program68Output vert(program68Input i)
            {
                program68Output o = (program68Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord8.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[12].xxxy, cb0_values[12].zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, cb0_values[13].xyxx, cb0_values[13].zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, cb0_values[14].xxxy, cb0_values[14].zzzw)).zw;
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                float3 unitWorldNormal_xyz_4 = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_7 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_7.xxxx * (mad(unitWorldNormal_xyz_4.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_4.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord2.y = r3_xyz_3.x;
                o.texcoord2.x = unitWorldTangent_xyz_7.z;
                o.texcoord2.z = unitWorldNormal_xyz_4.y;
                o.texcoord3.x = unitWorldTangent_xyz_7.x;
                o.texcoord4.x = unitWorldTangent_xyz_7.y;
                o.texcoord3.z = unitWorldNormal_xyz_4.z;
                o.texcoord4.z = unitWorldNormal_xyz_4.x;
                o.texcoord3.y = r3_xyz_3.y;
                o.texcoord4.y = r3_xyz_3.z;
                o.texcoord5.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_6 = (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, ((worldPos_xyzw_4.yyyy * _EmissionColor.xyzx)).xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(cb0_values[6].xyzx, worldPos_xyzw_4.zzzz, clipPos_xyz_6.xyzx)).xyz;
                o.texcoord6.xyz = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program114Output frag(program114Input i)
            {
                program114Output o = (program114Output)0;
                float3 r0_xyz_1 = ((-i.texcoord5.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord5.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float3 r4_xyz_1 = (_MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy)).xyz;
                float4 r5_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord1.xyxx).xy);
                float3 r6_xyz_1 = (_SpecGlossMap.Sample(sampler_SpecGlossMap, (i.texcoord0.zwzz).xy)).xyz;
                float r6_x_2 = (r6_xyz_1.z * r6_xyz_1.x);
                float4 r6_xyzw_3 = mad(float4(r6_x_2, r6_xyz_1.y, r6_x_2, r6_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r6_x_3 = r6_xyzw_3.x;
                float r6_y_2 = r6_xyzw_3.y;
                float r1_w_3 = dot(float4(r6_x_3, r6_y_2, r6_x_3, r6_x_3), float4(r6_x_3, r6_y_2, r6_x_3, r6_x_3));
                float r1_w_4 = min(r1_w_3, 1);
                float r1_w_5 = (-r1_w_4 + 1);
                float r6_z_2 = sqrt(r1_w_5);
                float3 r7_xyz_1 = ((r5_xyzw_1.xyzx * _SpecColor.xyzx)).xyz;
                float3 r8_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord5.zzzz, (mad(cb0_values[4].xyzx, i.texcoord5.xxxx, ((i.texcoord5.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r9_x_1 = cb4_values[9].z;
                float r9_y_1 = cb4_values[10].z;
                float r9_z_1 = cb4_values[11].z;
                float r1_w_6 = dot(viewDir_xyz_1.xyzx, float4(r9_x_1, r9_y_1, r9_z_1, r9_x_1));
                float3 r2_xyz_2 = ((i.texcoord5.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_7 = mad(cb3_values[25].w, (-r1_w_6 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_6);
                float r1_w_8 = saturate(mad(r1_w_7, cb3_values[24].z, cb3_values[24].w));
                float r2_x_13;
                float r2_y_13;
                float r2_z_12;
                float r2_w_8;
                if ((cb6_values[0].x == 1))
                {
                    float4 r2_xyzw_4 = (i.texcoord5.yyyy * cb6_values[2].xxyz);
                    float r2_y_4 = r2_xyzw_4.y;
                    float r2_z_4 = r2_xyzw_4.z;
                    float r2_w_2 = r2_xyzw_4.w;
                    float4 r2_xyzw_5 = mad(cb6_values[1].xxyz, i.texcoord5.xxxx, float4(r2_y_4, r2_y_4, r2_z_4, r2_w_2));
                    float r2_y_5 = r2_xyzw_5.y;
                    float r2_z_5 = r2_xyzw_5.z;
                    float r2_w_3 = r2_xyzw_5.w;
                    float4 r2_xyzw_6 = mad(cb6_values[3].xxyz, i.texcoord5.zzzz, float4(r2_y_5, r2_y_5, r2_z_5, r2_w_3));
                    float r2_y_6 = r2_xyzw_6.y;
                    float r2_z_6 = r2_xyzw_6.z;
                    float r2_w_4 = r2_xyzw_6.w;
                    float4 r2_xyzw_7 = (float4(r2_y_6, r2_y_6, r2_z_6, r2_w_4) + cb6_values[4].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_5 = r2_xyzw_7.w;
                    float4 r2_xyzw_9 = (((cb6_values[0].y == 1)).xxxx ? float4(r2_y_7, r2_z_7, r2_w_5, r2_y_7) : i.texcoord5.xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_8 = r2_xyzw_9.y;
                    float r2_z_8 = r2_xyzw_9.z;
                    float4 r2_xyzw_10 = (float4(r2_x_9, r2_y_8, r2_z_8, r2_x_9) + -cb6_values[6].xyzx);
                    float r2_x_10 = r2_xyzw_10.x;
                    float r2_y_9 = r2_xyzw_10.y;
                    float r2_z_9 = r2_xyzw_10.z;
                    float r2_y_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).y;
                    float r2_z_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).z;
                    float r2_w_6 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).w;
                    float r2_y_11 = mad(r2_y_10, 0.25, 0.75);
                    float r3_w_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r2_x_11 = max(r2_y_11, r3_w_1);
                    float4 r2_xyzw_12 = t5.Sample(sampler_linear_clamp, (float4(r2_x_11, r2_z_10, r2_w_6, r2_x_11)).xyz);
                    r2_x_13 = r2_xyzw_12.x;
                    r2_y_13 = r2_xyzw_12.y;
                    r2_z_12 = r2_xyzw_12.z;
                    r2_w_8 = r2_xyzw_12.w;
                }
                else
                {
                    float r2_x_7 = (float4(1, 1, 1, 1)).x;
                    float4 r2_xyzw_3 = float4(1, 1, 1, 1);
                    float r2_y_3 = r2_xyzw_3.y;
                    float r2_z_3 = r2_xyzw_3.z;
                    float r2_w_1 = r2_xyzw_3.w;
                    r2_x_13 = r2_x_7;
                    r2_y_13 = r2_y_3;
                    r2_z_12 = r2_z_3;
                    r2_w_8 = r2_w_1;
                }
                float r2_y_14 = (r1_w_8 < 0.99);
                float r2_y_20;
                if (r2_y_14)
                {
                    float4 r2_xyzw_16 = (i.texcoord5.xxyz + -cb2_values[1].xxyz);
                    float r2_y_16 = r2_xyzw_16.y;
                    float r2_z_13 = r2_xyzw_16.z;
                    float r2_w_9 = r2_xyzw_16.w;
                    float r3_w_3 = max(abs(r2_z_13), abs(r2_y_16));
                    float r3_w_4 = max(abs(r2_w_9), r3_w_3);
                    float r3_w_5 = (r3_w_4 + -cb2_values[2].z);
                    float r3_w_6 = max(r3_w_5, 1E-05);
                    float r3_w_7 = (r3_w_6 * cb2_values[2].w);
                    float r3_w_8 = (cb2_values[2].y / r3_w_7);
                    float r3_w_9 = (r3_w_8 + -cb2_values[2].x);
                    float r3_w_10 = (-r3_w_9 + 1);
                    float r9_x_3 = t6.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((float4(r2_y_16, r2_z_13, r2_w_9, r2_y_16) + float4(0.0078125, 0.0078125, 0.0078125, 0))).xyzx).xyz, r3_w_10);
                    float r9_y_3 = t6.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((float4(r2_y_16, r2_z_13, r2_w_9, r2_y_16) + float4(-0.0078125, -0.0078125, 0.0078125, 0))).xyzx).xyz, r3_w_10);
                    float r9_z_3 = t6.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((float4(r2_y_16, r2_z_13, r2_w_9, r2_y_16) + float4(-0.0078125, 0.0078125, -0.0078125, 0))).xyzx).xyz, r3_w_10);
                    float4 r2_xyzw_17 = (float4(r2_y_16, r2_y_16, r2_z_13, r2_w_9) + float4(0, 0.0078125, -0.0078125, -0.0078125));
                    float r2_y_17 = r2_xyzw_17.y;
                    float r2_z_14 = r2_xyzw_17.z;
                    float r2_w_10 = r2_xyzw_17.w;
                    float r9_w_1 = t6.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r2_y_17, r2_z_14, r2_w_10, r2_y_17)).xyz, r3_w_10);
                    float r2_y_18 = dot(float4(r9_x_3, r9_y_3, r9_z_3, r9_w_1), float4(0.25, 0.25, 0.25, 0.25));
                    float r2_z_15 = (-cb3_values[24].x + 1);
                    float r2_y_19 = mad(r2_y_18, r2_z_15, cb3_values[24].x);
                    r2_y_20 = r2_y_19;
                }
                else
                {
                    float r2_y_15 = 1;
                    r2_y_20 = r2_y_15;
                }
                float r1_w_9 = mad(r1_w_8, (-r2_y_20 + saturate(dot(float4(r2_x_13, r2_y_13, r2_z_12, r2_w_8), unity_OcclusionMaskSelector))), r2_y_20);
                float r2_x_17 = (_OcclusionMap.Sample(sampler_OcclusionMap, ((dot(r8_xyz_4.xyzx, r8_xyz_4.xyzx)).xxxx).xy)).x;
                float r2_y_21 = (t4.Sample(sampler_linear_clamp2, r8_xyz_4.xyz)).y;
                float r1_w_10 = (r1_w_9 * (r2_y_21 * r2_x_17));
                float r2_x_19 = dot(i.texcoord2.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_y_22 = dot(i.texcoord3.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_z_17 = dot(i.texcoord4.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_w_12 = dot(float4(r2_x_19, r2_y_22, r2_z_17, r2_x_19), float4(r2_x_19, r2_y_22, r2_z_17, r2_x_19));
                float r2_w_13 = rsqrt(r2_w_12);
                float4 r2_xyzw_20 = (r2_w_13.xxxx * float4(r2_x_19, r2_y_22, r2_z_17, r2_x_19));
                float r2_x_20 = r2_xyzw_20.x;
                float r2_y_23 = r2_xyzw_20.y;
                float r2_z_18 = r2_xyzw_20.z;
                float4 r6_xyzw_4 = (r1_w_10.xxxx * _LightColor0.xyzx);
                float r6_x_4 = r6_xyzw_4.x;
                float r6_y_3 = r6_xyzw_4.y;
                float r6_z_3 = r6_xyzw_4.z;
                float r1_w_11 = max(r7_xyz_1.y, r7_xyz_1.x);
                float r1_w_12 = max(r7_xyz_1.z, r1_w_11);
                float r1_w_13 = (-r1_w_12 + 1);
                float r1_w_14 = mad(-cb0_values[10].x, r5_xyzw_1.w, 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r2_x_20, r2_y_23, r2_z_18, r2_x_20), unitViewDir_xyz_1.xyzx);
                float r2_w_14 = saturate(dot(float4(r2_x_20, r2_y_23, r2_z_18, r2_x_20), r1_xyz_1.xyzx));
                float r2_x_21 = saturate(dot(float4(r2_x_20, r2_y_23, r2_z_18, r2_x_20), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_14.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_14 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_14 * r1_w_14);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(r0_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * mad(r2_w_14, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_14, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r2_x_21, r0_z_9, -r2_x_21), r2_x_21, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_w_14.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r7_xyz_1.xyzx, r7_xyz_1.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r6_x_4, r6_y_3, r6_z_3, r6_x_4));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r6_x_4, r6_x_4, r6_y_3, r6_z_3) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_15 = (r0_x_5 * r0_x_5);
                float r1_w_16 = (r1_w_15 * r1_w_15);
                float4 r2_xyzw_22 = mad(-_SpecColor.xyzx, r5_xyzw_1.xyzx, float4(1, 1, 1, 0));
                float r2_x_22 = r2_xyzw_22.x;
                float r2_y_24 = r2_xyzw_22.y;
                float r2_z_19 = r2_xyzw_22.z;
                float4 r2_xyzw_23 = mad(float4(r2_x_22, r2_y_24, r2_z_19, r2_x_22), ((r0_x_5 * r1_w_16)).xxxx, r7_xyz_1.xyzx);
                float r2_x_23 = r2_xyzw_23.x;
                float r2_y_25 = r2_xyzw_23.y;
                float r2_z_20 = r2_xyzw_23.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_23, r2_y_25, r2_z_20, r2_x_23));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_13.xxxx * ((r4_xyz_1.xyzx * cb0_values[8].xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float r0_w_15 = (i.texcoord8.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8) * r0_w_19.xxxx)).xyz;
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
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
                float4 cb1_values[6];
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
                float4 cb5_values[2];
            };
            cbuffer cb6 : register(b6)
            {
                float4 cb6_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerComparisonState sampler_comparison_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_MainTex;
            SamplerState sampler_SpecGlossMap;
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _SpecGlossMap;
            Texture2D _OcclusionMap;
            TextureCube t4;
            Texture3D t5;
            TextureCube t6;
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
                float3 texcoord2 : TEXCOORD2;
                float texcoord8 : TEXCOORD8;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program113Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float texcoord8 : TEXCOORD8;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program113Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program67Output vert(program67Input i)
            {
                program67Output o = (program67Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord8.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[12].xxxy, cb0_values[12].zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, cb0_values[13].xyxx, cb0_values[13].zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, cb0_values[14].xxxy, cb0_values[14].zzzw)).zw;
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                float3 unitWorldNormal_xyz_4 = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_7 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_7.xxxx * (mad(unitWorldNormal_xyz_4.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_4.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord2.y = r3_xyz_3.x;
                o.texcoord2.x = unitWorldTangent_xyz_7.z;
                o.texcoord2.z = unitWorldNormal_xyz_4.y;
                o.texcoord3.x = unitWorldTangent_xyz_7.x;
                o.texcoord4.x = unitWorldTangent_xyz_7.y;
                o.texcoord3.z = unitWorldNormal_xyz_4.z;
                o.texcoord4.z = unitWorldNormal_xyz_4.x;
                o.texcoord3.y = r3_xyz_3.y;
                o.texcoord4.y = r3_xyz_3.z;
                o.texcoord5.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_6 = (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, ((worldPos_xyzw_4.yyyy * _EmissionColor.xyzx)).xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(cb0_values[6].xyzx, worldPos_xyzw_4.zzzz, clipPos_xyz_6.xyzx)).xyz;
                o.texcoord6.xyz = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program113Output frag(program113Input i)
            {
                program113Output o = (program113Output)0;
                float3 r0_xyz_1 = ((-i.texcoord5.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord5.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float3 r4_xyz_1 = (_MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy)).xyz;
                float4 r5_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord1.xyxx).xy);
                float3 r6_xyz_1 = (_SpecGlossMap.Sample(sampler_SpecGlossMap, (i.texcoord0.zwzz).xy)).xyz;
                float r6_x_2 = (r6_xyz_1.z * r6_xyz_1.x);
                float4 r6_xyzw_3 = mad(float4(r6_x_2, r6_xyz_1.y, r6_x_2, r6_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r6_x_3 = r6_xyzw_3.x;
                float r6_y_2 = r6_xyzw_3.y;
                float r1_w_3 = dot(float4(r6_x_3, r6_y_2, r6_x_3, r6_x_3), float4(r6_x_3, r6_y_2, r6_x_3, r6_x_3));
                float r1_w_4 = min(r1_w_3, 1);
                float r1_w_5 = (-r1_w_4 + 1);
                float r6_z_2 = sqrt(r1_w_5);
                float3 r7_xyz_1 = ((r5_xyzw_1.xyzx * _SpecColor.xyzx)).xyz;
                float3 r8_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord5.zzzz, (mad(cb0_values[4].xyzx, i.texcoord5.xxxx, ((i.texcoord5.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r9_x_1 = cb4_values[9].z;
                float r9_y_1 = cb4_values[10].z;
                float r9_z_1 = cb4_values[11].z;
                float r1_w_6 = dot(viewDir_xyz_1.xyzx, float4(r9_x_1, r9_y_1, r9_z_1, r9_x_1));
                float3 r2_xyz_2 = ((i.texcoord5.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_7 = mad(cb3_values[25].w, (-r1_w_6 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_6);
                float r1_w_8 = saturate(mad(r1_w_7, cb3_values[24].z, cb3_values[24].w));
                float r2_x_13;
                float r2_y_13;
                float r2_z_12;
                float r2_w_8;
                if ((cb6_values[0].x == 1))
                {
                    float4 r2_xyzw_4 = (i.texcoord5.yyyy * cb6_values[2].xxyz);
                    float r2_y_4 = r2_xyzw_4.y;
                    float r2_z_4 = r2_xyzw_4.z;
                    float r2_w_2 = r2_xyzw_4.w;
                    float4 r2_xyzw_5 = mad(cb6_values[1].xxyz, i.texcoord5.xxxx, float4(r2_y_4, r2_y_4, r2_z_4, r2_w_2));
                    float r2_y_5 = r2_xyzw_5.y;
                    float r2_z_5 = r2_xyzw_5.z;
                    float r2_w_3 = r2_xyzw_5.w;
                    float4 r2_xyzw_6 = mad(cb6_values[3].xxyz, i.texcoord5.zzzz, float4(r2_y_5, r2_y_5, r2_z_5, r2_w_3));
                    float r2_y_6 = r2_xyzw_6.y;
                    float r2_z_6 = r2_xyzw_6.z;
                    float r2_w_4 = r2_xyzw_6.w;
                    float4 r2_xyzw_7 = (float4(r2_y_6, r2_y_6, r2_z_6, r2_w_4) + cb6_values[4].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_5 = r2_xyzw_7.w;
                    float4 r2_xyzw_9 = (((cb6_values[0].y == 1)).xxxx ? float4(r2_y_7, r2_z_7, r2_w_5, r2_y_7) : i.texcoord5.xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_8 = r2_xyzw_9.y;
                    float r2_z_8 = r2_xyzw_9.z;
                    float4 r2_xyzw_10 = (float4(r2_x_9, r2_y_8, r2_z_8, r2_x_9) + -cb6_values[6].xyzx);
                    float r2_x_10 = r2_xyzw_10.x;
                    float r2_y_9 = r2_xyzw_10.y;
                    float r2_z_9 = r2_xyzw_10.z;
                    float r2_y_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).y;
                    float r2_z_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).z;
                    float r2_w_6 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).w;
                    float r2_y_11 = mad(r2_y_10, 0.25, 0.75);
                    float r3_w_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r2_x_11 = max(r2_y_11, r3_w_1);
                    float4 r2_xyzw_12 = t5.Sample(sampler_linear_clamp, (float4(r2_x_11, r2_z_10, r2_w_6, r2_x_11)).xyz);
                    r2_x_13 = r2_xyzw_12.x;
                    r2_y_13 = r2_xyzw_12.y;
                    r2_z_12 = r2_xyzw_12.z;
                    r2_w_8 = r2_xyzw_12.w;
                }
                else
                {
                    float r2_x_7 = (float4(1, 1, 1, 1)).x;
                    float4 r2_xyzw_3 = float4(1, 1, 1, 1);
                    float r2_y_3 = r2_xyzw_3.y;
                    float r2_z_3 = r2_xyzw_3.z;
                    float r2_w_1 = r2_xyzw_3.w;
                    r2_x_13 = r2_x_7;
                    r2_y_13 = r2_y_3;
                    r2_z_12 = r2_z_3;
                    r2_w_8 = r2_w_1;
                }
                float4 r2_xyzw_14 = (i.texcoord5.xxyz + -cb2_values[1].xxyz);
                float r2_y_14 = r2_xyzw_14.y;
                float r2_z_13 = r2_xyzw_14.z;
                float r2_w_9 = r2_xyzw_14.w;
                float r3_w_3 = max(abs(r2_z_13), abs(r2_y_14));
                float r3_w_4 = max(abs(r2_w_9), r3_w_3);
                float r3_w_5 = (r3_w_4 + -cb2_values[2].z);
                float r3_w_6 = max(r3_w_5, 1E-05);
                float r3_w_7 = (r3_w_6 * cb2_values[2].w);
                float r3_w_8 = (cb2_values[2].y / r3_w_7);
                float r3_w_9 = (r3_w_8 + -cb2_values[2].x);
                float r3_w_10 = (-r3_w_9 + 1);
                float r2_y_15 = t6.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r2_y_14, r2_z_13, r2_w_9, r2_y_14)).xyz, r3_w_10);
                float r2_z_14 = (-cb3_values[24].x + 1);
                float r2_y_16 = mad(r2_y_15, r2_z_14, cb3_values[24].x);
                float r1_w_9 = mad(r1_w_8, (-r2_y_16 + saturate(dot(float4(r2_x_13, r2_y_13, r2_z_12, r2_w_8), unity_OcclusionMaskSelector))), r2_y_16);
                float r2_x_17 = (_OcclusionMap.Sample(sampler_OcclusionMap, ((dot(r8_xyz_4.xyzx, r8_xyz_4.xyzx)).xxxx).xy)).x;
                float r2_y_17 = (t4.Sample(sampler_linear_clamp2, r8_xyz_4.xyz)).y;
                float r1_w_10 = (r1_w_9 * (r2_y_17 * r2_x_17));
                float r2_x_19 = dot(i.texcoord2.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_y_18 = dot(i.texcoord3.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_z_15 = dot(i.texcoord4.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_w_10 = dot(float4(r2_x_19, r2_y_18, r2_z_15, r2_x_19), float4(r2_x_19, r2_y_18, r2_z_15, r2_x_19));
                float r2_w_11 = rsqrt(r2_w_10);
                float4 r2_xyzw_20 = (r2_w_11.xxxx * float4(r2_x_19, r2_y_18, r2_z_15, r2_x_19));
                float r2_x_20 = r2_xyzw_20.x;
                float r2_y_19 = r2_xyzw_20.y;
                float r2_z_16 = r2_xyzw_20.z;
                float4 r6_xyzw_4 = (r1_w_10.xxxx * _LightColor0.xyzx);
                float r6_x_4 = r6_xyzw_4.x;
                float r6_y_3 = r6_xyzw_4.y;
                float r6_z_3 = r6_xyzw_4.z;
                float r1_w_11 = max(r7_xyz_1.y, r7_xyz_1.x);
                float r1_w_12 = max(r7_xyz_1.z, r1_w_11);
                float r1_w_13 = (-r1_w_12 + 1);
                float r1_w_14 = mad(-cb0_values[10].x, r5_xyzw_1.w, 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r2_x_20, r2_y_19, r2_z_16, r2_x_20), unitViewDir_xyz_1.xyzx);
                float r2_w_12 = saturate(dot(float4(r2_x_20, r2_y_19, r2_z_16, r2_x_20), r1_xyz_1.xyzx));
                float r2_x_21 = saturate(dot(float4(r2_x_20, r2_y_19, r2_z_16, r2_x_20), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_14.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_12 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_14 * r1_w_14);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(r0_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * mad(r2_w_12, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_12, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r2_x_21, r0_z_9, -r2_x_21), r2_x_21, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_w_12.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r7_xyz_1.xyzx, r7_xyz_1.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r6_x_4, r6_y_3, r6_z_3, r6_x_4));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r6_x_4, r6_x_4, r6_y_3, r6_z_3) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_15 = (r0_x_5 * r0_x_5);
                float r1_w_16 = (r1_w_15 * r1_w_15);
                float4 r2_xyzw_22 = mad(-_SpecColor.xyzx, r5_xyzw_1.xyzx, float4(1, 1, 1, 0));
                float r2_x_22 = r2_xyzw_22.x;
                float r2_y_20 = r2_xyzw_22.y;
                float r2_z_17 = r2_xyzw_22.z;
                float4 r2_xyzw_23 = mad(float4(r2_x_22, r2_y_20, r2_z_17, r2_x_22), ((r0_x_5 * r1_w_16)).xxxx, r7_xyz_1.xyzx);
                float r2_x_23 = r2_xyzw_23.x;
                float r2_y_21 = r2_xyzw_23.y;
                float r2_z_18 = r2_xyzw_23.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_23, r2_y_21, r2_z_18, r2_x_23));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_13.xxxx * ((r4_xyz_1.xyzx * cb0_values[8].xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float r0_w_15 = (i.texcoord8.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8) * r0_w_19.xxxx)).xyz;
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
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
                float4 cb1_values[6];
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
                float4 cb5_values[2];
            };
            cbuffer cb6 : register(b6)
            {
                float4 cb6_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerComparisonState sampler_comparison_linear_clamp1;
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_MainTex;
            SamplerState sampler_SpecGlossMap;
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _SpecGlossMap;
            Texture2D _OcclusionMap;
            Texture3D t4;
            TextureCube t5;
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
                float3 texcoord2 : TEXCOORD2;
                float texcoord8 : TEXCOORD8;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program112Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float texcoord8 : TEXCOORD8;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program112Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program66Output vert(program66Input i)
            {
                program66Output o = (program66Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord8.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[12].xxxy, cb0_values[12].zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, cb0_values[13].xyxx, cb0_values[13].zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, cb0_values[14].xxxy, cb0_values[14].zzzw)).zw;
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                float3 unitWorldNormal_xyz_4 = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_7 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_7.xxxx * (mad(unitWorldNormal_xyz_4.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_4.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord2.y = r3_xyz_3.x;
                o.texcoord2.x = unitWorldTangent_xyz_7.z;
                o.texcoord2.z = unitWorldNormal_xyz_4.y;
                o.texcoord3.x = unitWorldTangent_xyz_7.x;
                o.texcoord4.x = unitWorldTangent_xyz_7.y;
                o.texcoord3.z = unitWorldNormal_xyz_4.z;
                o.texcoord4.z = unitWorldNormal_xyz_4.x;
                o.texcoord3.y = r3_xyz_3.y;
                o.texcoord4.y = r3_xyz_3.z;
                o.texcoord5.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_6 = (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, ((worldPos_xyzw_4.yyyy * _EmissionColor.xyzx)).xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(cb0_values[6].xyzx, worldPos_xyzw_4.zzzz, clipPos_xyz_6.xyzx)).xyz;
                o.texcoord6.xyz = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program112Output frag(program112Input i)
            {
                program112Output o = (program112Output)0;
                float3 r0_xyz_1 = ((-i.texcoord5.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord5.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float3 r4_xyz_1 = (_MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy)).xyz;
                float4 r5_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord1.xyxx).xy);
                float3 r6_xyz_1 = (_SpecGlossMap.Sample(sampler_SpecGlossMap, (i.texcoord0.zwzz).xy)).xyz;
                float r6_x_2 = (r6_xyz_1.z * r6_xyz_1.x);
                float4 r6_xyzw_3 = mad(float4(r6_x_2, r6_xyz_1.y, r6_x_2, r6_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r6_x_3 = r6_xyzw_3.x;
                float r6_y_2 = r6_xyzw_3.y;
                float r1_w_3 = dot(float4(r6_x_3, r6_y_2, r6_x_3, r6_x_3), float4(r6_x_3, r6_y_2, r6_x_3, r6_x_3));
                float r1_w_4 = min(r1_w_3, 1);
                float r1_w_5 = (-r1_w_4 + 1);
                float r6_z_2 = sqrt(r1_w_5);
                float3 r7_xyz_1 = ((r5_xyzw_1.xyzx * _SpecColor.xyzx)).xyz;
                float3 r8_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord5.zzzz, (mad(cb0_values[4].xyzx, i.texcoord5.xxxx, ((i.texcoord5.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r9_x_1 = cb4_values[9].z;
                float r9_y_1 = cb4_values[10].z;
                float r9_z_1 = cb4_values[11].z;
                float r1_w_6 = dot(viewDir_xyz_1.xyzx, float4(r9_x_1, r9_y_1, r9_z_1, r9_x_1));
                float3 r2_xyz_2 = ((i.texcoord5.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_7 = mad(cb3_values[25].w, (-r1_w_6 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_6);
                float r1_w_8 = saturate(mad(r1_w_7, cb3_values[24].z, cb3_values[24].w));
                float r2_x_13;
                float r2_y_13;
                float r2_z_12;
                float r2_w_8;
                if ((cb6_values[0].x == 1))
                {
                    float4 r2_xyzw_4 = (i.texcoord5.yyyy * cb6_values[2].xxyz);
                    float r2_y_4 = r2_xyzw_4.y;
                    float r2_z_4 = r2_xyzw_4.z;
                    float r2_w_2 = r2_xyzw_4.w;
                    float4 r2_xyzw_5 = mad(cb6_values[1].xxyz, i.texcoord5.xxxx, float4(r2_y_4, r2_y_4, r2_z_4, r2_w_2));
                    float r2_y_5 = r2_xyzw_5.y;
                    float r2_z_5 = r2_xyzw_5.z;
                    float r2_w_3 = r2_xyzw_5.w;
                    float4 r2_xyzw_6 = mad(cb6_values[3].xxyz, i.texcoord5.zzzz, float4(r2_y_5, r2_y_5, r2_z_5, r2_w_3));
                    float r2_y_6 = r2_xyzw_6.y;
                    float r2_z_6 = r2_xyzw_6.z;
                    float r2_w_4 = r2_xyzw_6.w;
                    float4 r2_xyzw_7 = (float4(r2_y_6, r2_y_6, r2_z_6, r2_w_4) + cb6_values[4].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_5 = r2_xyzw_7.w;
                    float4 r2_xyzw_9 = (((cb6_values[0].y == 1)).xxxx ? float4(r2_y_7, r2_z_7, r2_w_5, r2_y_7) : i.texcoord5.xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_8 = r2_xyzw_9.y;
                    float r2_z_8 = r2_xyzw_9.z;
                    float4 r2_xyzw_10 = (float4(r2_x_9, r2_y_8, r2_z_8, r2_x_9) + -cb6_values[6].xyzx);
                    float r2_x_10 = r2_xyzw_10.x;
                    float r2_y_9 = r2_xyzw_10.y;
                    float r2_z_9 = r2_xyzw_10.z;
                    float r2_y_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).y;
                    float r2_z_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).z;
                    float r2_w_6 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).w;
                    float r2_y_11 = mad(r2_y_10, 0.25, 0.75);
                    float r3_w_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r2_x_11 = max(r2_y_11, r3_w_1);
                    float4 r2_xyzw_12 = t4.Sample(sampler_linear_clamp, (float4(r2_x_11, r2_z_10, r2_w_6, r2_x_11)).xyz);
                    r2_x_13 = r2_xyzw_12.x;
                    r2_y_13 = r2_xyzw_12.y;
                    r2_z_12 = r2_xyzw_12.z;
                    r2_w_8 = r2_xyzw_12.w;
                }
                else
                {
                    float r2_x_7 = (float4(1, 1, 1, 1)).x;
                    float4 r2_xyzw_3 = float4(1, 1, 1, 1);
                    float r2_y_3 = r2_xyzw_3.y;
                    float r2_z_3 = r2_xyzw_3.z;
                    float r2_w_1 = r2_xyzw_3.w;
                    r2_x_13 = r2_x_7;
                    r2_y_13 = r2_y_3;
                    r2_z_12 = r2_z_3;
                    r2_w_8 = r2_w_1;
                }
                float r2_y_14 = (r1_w_8 < 0.99);
                float r2_y_20;
                if (r2_y_14)
                {
                    float4 r2_xyzw_16 = (i.texcoord5.xxyz + -cb2_values[1].xxyz);
                    float r2_y_16 = r2_xyzw_16.y;
                    float r2_z_13 = r2_xyzw_16.z;
                    float r2_w_9 = r2_xyzw_16.w;
                    float r3_w_3 = max(abs(r2_z_13), abs(r2_y_16));
                    float r3_w_4 = max(abs(r2_w_9), r3_w_3);
                    float r3_w_5 = (r3_w_4 + -cb2_values[2].z);
                    float r3_w_6 = max(r3_w_5, 1E-05);
                    float r3_w_7 = (r3_w_6 * cb2_values[2].w);
                    float r3_w_8 = (cb2_values[2].y / r3_w_7);
                    float r3_w_9 = (r3_w_8 + -cb2_values[2].x);
                    float r3_w_10 = (-r3_w_9 + 1);
                    float r9_x_3 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((float4(r2_y_16, r2_z_13, r2_w_9, r2_y_16) + float4(0.0078125, 0.0078125, 0.0078125, 0))).xyzx).xyz, r3_w_10);
                    float r9_y_3 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((float4(r2_y_16, r2_z_13, r2_w_9, r2_y_16) + float4(-0.0078125, -0.0078125, 0.0078125, 0))).xyzx).xyz, r3_w_10);
                    float r9_z_3 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((float4(r2_y_16, r2_z_13, r2_w_9, r2_y_16) + float4(-0.0078125, 0.0078125, -0.0078125, 0))).xyzx).xyz, r3_w_10);
                    float4 r2_xyzw_17 = (float4(r2_y_16, r2_y_16, r2_z_13, r2_w_9) + float4(0, 0.0078125, -0.0078125, -0.0078125));
                    float r2_y_17 = r2_xyzw_17.y;
                    float r2_z_14 = r2_xyzw_17.z;
                    float r2_w_10 = r2_xyzw_17.w;
                    float r9_w_1 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r2_y_17, r2_z_14, r2_w_10, r2_y_17)).xyz, r3_w_10);
                    float r2_y_18 = dot(float4(r9_x_3, r9_y_3, r9_z_3, r9_w_1), float4(0.25, 0.25, 0.25, 0.25));
                    float r2_z_15 = (-cb3_values[24].x + 1);
                    float r2_y_19 = mad(r2_y_18, r2_z_15, cb3_values[24].x);
                    r2_y_20 = r2_y_19;
                }
                else
                {
                    float r2_y_15 = 1;
                    r2_y_20 = r2_y_15;
                }
                float r1_w_9 = mad(r1_w_8, (-r2_y_20 + saturate(dot(float4(r2_x_13, r2_y_13, r2_z_12, r2_w_8), unity_OcclusionMaskSelector))), r2_y_20);
                float r2_x_17 = (_OcclusionMap.Sample(sampler_OcclusionMap, ((dot(r8_xyz_4.xyzx, r8_xyz_4.xyzx)).xxxx).xy)).x;
                float r1_w_10 = (r1_w_9 * r2_x_17);
                float r2_x_18 = dot(i.texcoord2.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_y_21 = dot(i.texcoord3.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_z_17 = dot(i.texcoord4.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_w_12 = dot(float4(r2_x_18, r2_y_21, r2_z_17, r2_x_18), float4(r2_x_18, r2_y_21, r2_z_17, r2_x_18));
                float r2_w_13 = rsqrt(r2_w_12);
                float4 r2_xyzw_19 = (r2_w_13.xxxx * float4(r2_x_18, r2_y_21, r2_z_17, r2_x_18));
                float r2_x_19 = r2_xyzw_19.x;
                float r2_y_22 = r2_xyzw_19.y;
                float r2_z_18 = r2_xyzw_19.z;
                float4 r6_xyzw_4 = (r1_w_10.xxxx * _LightColor0.xyzx);
                float r6_x_4 = r6_xyzw_4.x;
                float r6_y_3 = r6_xyzw_4.y;
                float r6_z_3 = r6_xyzw_4.z;
                float r1_w_11 = max(r7_xyz_1.y, r7_xyz_1.x);
                float r1_w_12 = max(r7_xyz_1.z, r1_w_11);
                float r1_w_13 = (-r1_w_12 + 1);
                float r1_w_14 = mad(-cb0_values[10].x, r5_xyzw_1.w, 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r2_x_19, r2_y_22, r2_z_18, r2_x_19), unitViewDir_xyz_1.xyzx);
                float r2_w_14 = saturate(dot(float4(r2_x_19, r2_y_22, r2_z_18, r2_x_19), r1_xyz_1.xyzx));
                float r2_x_20 = saturate(dot(float4(r2_x_19, r2_y_22, r2_z_18, r2_x_19), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_14.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_14 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_14 * r1_w_14);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(r0_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * mad(r2_w_14, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_14, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r2_x_20, r0_z_9, -r2_x_20), r2_x_20, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_w_14.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r7_xyz_1.xyzx, r7_xyz_1.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r6_x_4, r6_y_3, r6_z_3, r6_x_4));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r6_x_4, r6_x_4, r6_y_3, r6_z_3) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_15 = (r0_x_5 * r0_x_5);
                float r1_w_16 = (r1_w_15 * r1_w_15);
                float4 r2_xyzw_21 = mad(-_SpecColor.xyzx, r5_xyzw_1.xyzx, float4(1, 1, 1, 0));
                float r2_x_21 = r2_xyzw_21.x;
                float r2_y_23 = r2_xyzw_21.y;
                float r2_z_19 = r2_xyzw_21.z;
                float4 r2_xyzw_22 = mad(float4(r2_x_21, r2_y_23, r2_z_19, r2_x_21), ((r0_x_5 * r1_w_16)).xxxx, r7_xyz_1.xyzx);
                float r2_x_22 = r2_xyzw_22.x;
                float r2_y_24 = r2_xyzw_22.y;
                float r2_z_20 = r2_xyzw_22.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_22, r2_y_24, r2_z_20, r2_x_22));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_13.xxxx * ((r4_xyz_1.xyzx * cb0_values[8].xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float r0_w_15 = (i.texcoord8.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8) * r0_w_19.xxxx)).xyz;
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
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
                float4 cb1_values[6];
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
                float4 cb5_values[2];
            };
            cbuffer cb6 : register(b6)
            {
                float4 cb6_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerComparisonState sampler_comparison_linear_clamp1;
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_MainTex;
            SamplerState sampler_SpecGlossMap;
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _SpecGlossMap;
            Texture2D _OcclusionMap;
            Texture3D t4;
            TextureCube t5;
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
                float3 texcoord2 : TEXCOORD2;
                float texcoord8 : TEXCOORD8;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program111Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float texcoord8 : TEXCOORD8;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program111Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program65Output vert(program65Input i)
            {
                program65Output o = (program65Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord8.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[12].xxxy, cb0_values[12].zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, cb0_values[13].xyxx, cb0_values[13].zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, cb0_values[14].xxxy, cb0_values[14].zzzw)).zw;
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                float3 unitWorldNormal_xyz_4 = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_7 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_7.xxxx * (mad(unitWorldNormal_xyz_4.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_4.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord2.y = r3_xyz_3.x;
                o.texcoord2.x = unitWorldTangent_xyz_7.z;
                o.texcoord2.z = unitWorldNormal_xyz_4.y;
                o.texcoord3.x = unitWorldTangent_xyz_7.x;
                o.texcoord4.x = unitWorldTangent_xyz_7.y;
                o.texcoord3.z = unitWorldNormal_xyz_4.z;
                o.texcoord4.z = unitWorldNormal_xyz_4.x;
                o.texcoord3.y = r3_xyz_3.y;
                o.texcoord4.y = r3_xyz_3.z;
                o.texcoord5.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_6 = (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, ((worldPos_xyzw_4.yyyy * _EmissionColor.xyzx)).xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(cb0_values[6].xyzx, worldPos_xyzw_4.zzzz, clipPos_xyz_6.xyzx)).xyz;
                o.texcoord6.xyz = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program111Output frag(program111Input i)
            {
                program111Output o = (program111Output)0;
                float3 r0_xyz_1 = ((-i.texcoord5.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord5.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float3 r4_xyz_1 = (_MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy)).xyz;
                float4 r5_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord1.xyxx).xy);
                float3 r6_xyz_1 = (_SpecGlossMap.Sample(sampler_SpecGlossMap, (i.texcoord0.zwzz).xy)).xyz;
                float r6_x_2 = (r6_xyz_1.z * r6_xyz_1.x);
                float4 r6_xyzw_3 = mad(float4(r6_x_2, r6_xyz_1.y, r6_x_2, r6_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r6_x_3 = r6_xyzw_3.x;
                float r6_y_2 = r6_xyzw_3.y;
                float r1_w_3 = dot(float4(r6_x_3, r6_y_2, r6_x_3, r6_x_3), float4(r6_x_3, r6_y_2, r6_x_3, r6_x_3));
                float r1_w_4 = min(r1_w_3, 1);
                float r1_w_5 = (-r1_w_4 + 1);
                float r6_z_2 = sqrt(r1_w_5);
                float3 r7_xyz_1 = ((r5_xyzw_1.xyzx * _SpecColor.xyzx)).xyz;
                float3 r8_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord5.zzzz, (mad(cb0_values[4].xyzx, i.texcoord5.xxxx, ((i.texcoord5.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r9_x_1 = cb4_values[9].z;
                float r9_y_1 = cb4_values[10].z;
                float r9_z_1 = cb4_values[11].z;
                float r1_w_6 = dot(viewDir_xyz_1.xyzx, float4(r9_x_1, r9_y_1, r9_z_1, r9_x_1));
                float3 r2_xyz_2 = ((i.texcoord5.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_7 = mad(cb3_values[25].w, (-r1_w_6 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_6);
                float r1_w_8 = saturate(mad(r1_w_7, cb3_values[24].z, cb3_values[24].w));
                float r2_x_13;
                float r2_y_13;
                float r2_z_12;
                float r2_w_8;
                if ((cb6_values[0].x == 1))
                {
                    float4 r2_xyzw_4 = (i.texcoord5.yyyy * cb6_values[2].xxyz);
                    float r2_y_4 = r2_xyzw_4.y;
                    float r2_z_4 = r2_xyzw_4.z;
                    float r2_w_2 = r2_xyzw_4.w;
                    float4 r2_xyzw_5 = mad(cb6_values[1].xxyz, i.texcoord5.xxxx, float4(r2_y_4, r2_y_4, r2_z_4, r2_w_2));
                    float r2_y_5 = r2_xyzw_5.y;
                    float r2_z_5 = r2_xyzw_5.z;
                    float r2_w_3 = r2_xyzw_5.w;
                    float4 r2_xyzw_6 = mad(cb6_values[3].xxyz, i.texcoord5.zzzz, float4(r2_y_5, r2_y_5, r2_z_5, r2_w_3));
                    float r2_y_6 = r2_xyzw_6.y;
                    float r2_z_6 = r2_xyzw_6.z;
                    float r2_w_4 = r2_xyzw_6.w;
                    float4 r2_xyzw_7 = (float4(r2_y_6, r2_y_6, r2_z_6, r2_w_4) + cb6_values[4].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_5 = r2_xyzw_7.w;
                    float4 r2_xyzw_9 = (((cb6_values[0].y == 1)).xxxx ? float4(r2_y_7, r2_z_7, r2_w_5, r2_y_7) : i.texcoord5.xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_8 = r2_xyzw_9.y;
                    float r2_z_8 = r2_xyzw_9.z;
                    float4 r2_xyzw_10 = (float4(r2_x_9, r2_y_8, r2_z_8, r2_x_9) + -cb6_values[6].xyzx);
                    float r2_x_10 = r2_xyzw_10.x;
                    float r2_y_9 = r2_xyzw_10.y;
                    float r2_z_9 = r2_xyzw_10.z;
                    float r2_y_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).y;
                    float r2_z_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).z;
                    float r2_w_6 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).w;
                    float r2_y_11 = mad(r2_y_10, 0.25, 0.75);
                    float r3_w_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r2_x_11 = max(r2_y_11, r3_w_1);
                    float4 r2_xyzw_12 = t4.Sample(sampler_linear_clamp, (float4(r2_x_11, r2_z_10, r2_w_6, r2_x_11)).xyz);
                    r2_x_13 = r2_xyzw_12.x;
                    r2_y_13 = r2_xyzw_12.y;
                    r2_z_12 = r2_xyzw_12.z;
                    r2_w_8 = r2_xyzw_12.w;
                }
                else
                {
                    float r2_x_7 = (float4(1, 1, 1, 1)).x;
                    float4 r2_xyzw_3 = float4(1, 1, 1, 1);
                    float r2_y_3 = r2_xyzw_3.y;
                    float r2_z_3 = r2_xyzw_3.z;
                    float r2_w_1 = r2_xyzw_3.w;
                    r2_x_13 = r2_x_7;
                    r2_y_13 = r2_y_3;
                    r2_z_12 = r2_z_3;
                    r2_w_8 = r2_w_1;
                }
                float4 r2_xyzw_14 = (i.texcoord5.xxyz + -cb2_values[1].xxyz);
                float r2_y_14 = r2_xyzw_14.y;
                float r2_z_13 = r2_xyzw_14.z;
                float r2_w_9 = r2_xyzw_14.w;
                float r3_w_3 = max(abs(r2_z_13), abs(r2_y_14));
                float r3_w_4 = max(abs(r2_w_9), r3_w_3);
                float r3_w_5 = (r3_w_4 + -cb2_values[2].z);
                float r3_w_6 = max(r3_w_5, 1E-05);
                float r3_w_7 = (r3_w_6 * cb2_values[2].w);
                float r3_w_8 = (cb2_values[2].y / r3_w_7);
                float r3_w_9 = (r3_w_8 + -cb2_values[2].x);
                float r3_w_10 = (-r3_w_9 + 1);
                float r2_y_15 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r2_y_14, r2_z_13, r2_w_9, r2_y_14)).xyz, r3_w_10);
                float r2_z_14 = (-cb3_values[24].x + 1);
                float r2_y_16 = mad(r2_y_15, r2_z_14, cb3_values[24].x);
                float r1_w_9 = mad(r1_w_8, (-r2_y_16 + saturate(dot(float4(r2_x_13, r2_y_13, r2_z_12, r2_w_8), unity_OcclusionMaskSelector))), r2_y_16);
                float r2_x_17 = (_OcclusionMap.Sample(sampler_OcclusionMap, ((dot(r8_xyz_4.xyzx, r8_xyz_4.xyzx)).xxxx).xy)).x;
                float r1_w_10 = (r1_w_9 * r2_x_17);
                float r2_x_18 = dot(i.texcoord2.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_y_17 = dot(i.texcoord3.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_z_15 = dot(i.texcoord4.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_w_10 = dot(float4(r2_x_18, r2_y_17, r2_z_15, r2_x_18), float4(r2_x_18, r2_y_17, r2_z_15, r2_x_18));
                float r2_w_11 = rsqrt(r2_w_10);
                float4 r2_xyzw_19 = (r2_w_11.xxxx * float4(r2_x_18, r2_y_17, r2_z_15, r2_x_18));
                float r2_x_19 = r2_xyzw_19.x;
                float r2_y_18 = r2_xyzw_19.y;
                float r2_z_16 = r2_xyzw_19.z;
                float4 r6_xyzw_4 = (r1_w_10.xxxx * _LightColor0.xyzx);
                float r6_x_4 = r6_xyzw_4.x;
                float r6_y_3 = r6_xyzw_4.y;
                float r6_z_3 = r6_xyzw_4.z;
                float r1_w_11 = max(r7_xyz_1.y, r7_xyz_1.x);
                float r1_w_12 = max(r7_xyz_1.z, r1_w_11);
                float r1_w_13 = (-r1_w_12 + 1);
                float r1_w_14 = mad(-cb0_values[10].x, r5_xyzw_1.w, 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r2_x_19, r2_y_18, r2_z_16, r2_x_19), unitViewDir_xyz_1.xyzx);
                float r2_w_12 = saturate(dot(float4(r2_x_19, r2_y_18, r2_z_16, r2_x_19), r1_xyz_1.xyzx));
                float r2_x_20 = saturate(dot(float4(r2_x_19, r2_y_18, r2_z_16, r2_x_19), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_14.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_12 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_14 * r1_w_14);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(r0_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * mad(r2_w_12, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_12, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r2_x_20, r0_z_9, -r2_x_20), r2_x_20, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_w_12.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r7_xyz_1.xyzx, r7_xyz_1.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r6_x_4, r6_y_3, r6_z_3, r6_x_4));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r6_x_4, r6_x_4, r6_y_3, r6_z_3) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_15 = (r0_x_5 * r0_x_5);
                float r1_w_16 = (r1_w_15 * r1_w_15);
                float4 r2_xyzw_21 = mad(-_SpecColor.xyzx, r5_xyzw_1.xyzx, float4(1, 1, 1, 0));
                float r2_x_21 = r2_xyzw_21.x;
                float r2_y_19 = r2_xyzw_21.y;
                float r2_z_17 = r2_xyzw_21.z;
                float4 r2_xyzw_22 = mad(float4(r2_x_21, r2_y_19, r2_z_17, r2_x_21), ((r0_x_5 * r1_w_16)).xxxx, r7_xyz_1.xyzx);
                float r2_x_22 = r2_xyzw_22.x;
                float r2_y_20 = r2_xyzw_22.y;
                float r2_z_18 = r2_xyzw_22.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_22, r2_y_20, r2_z_18, r2_x_22));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_13.xxxx * ((r4_xyz_1.xyzx * cb0_values[8].xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float r0_w_15 = (i.texcoord8.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8) * r0_w_19.xxxx)).xyz;
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
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
                float4 cb1_values[6];
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
                float4 cb5_values[2];
            };
            cbuffer cb6 : register(b6)
            {
                float4 cb6_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            SamplerState sampler_SpecGlossMap;
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _SpecGlossMap;
            Texture2D _OcclusionMap;
            Texture2D t4;
            Texture3D t5;
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
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float2 texcoord6 : TEXCOORD6;
                float texcoord8 : TEXCOORD8;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program110Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float2 texcoord6 : TEXCOORD6;
                float texcoord8 : TEXCOORD8;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program110Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program64Output vert(program64Input i)
            {
                program64Output o = (program64Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[12].xxxy, cb0_values[12].zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, cb0_values[13].xyxx, cb0_values[13].zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, cb0_values[14].xxxy, cb0_values[14].zzzw)).zw;
                float r2_y_4 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float r2_z_4 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float r2_x_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r2_w_4 = dot(float4(r2_x_4, r2_y_4, r2_z_4, r2_x_4), float4(r2_x_4, r2_y_4, r2_z_4, r2_x_4));
                float r2_w_5 = rsqrt(r2_w_4);
                float3 unitWorldNormal_xyz_5 = ((r2_w_5.xxxx * float4(r2_x_4, r2_y_4, r2_z_4, r2_x_4))).xyz;
                float3 worldTangent_xyz_1 = ((i.tangent0.yyyy * cb2_values[1].yzxy)).xyz;
                float3 worldTangent_xyz_2 = (mad(cb2_values[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_1.xyzx)).xyz;
                float3 worldTangent_xyz_3 = (mad(cb2_values[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_2.xyzx)).xyz;
                float3 unitWorldTangent_xyz_4 = normalize(worldTangent_xyz_3);
                float r2_w_8 = (i.tangent0.w * cb2_values[9].w);
                float3 r4_xyz_3 = ((r2_w_8.xxxx * (mad(unitWorldNormal_xyz_5.zxyz, unitWorldTangent_xyz_4.yzxy, ((unitWorldNormal_xyz_5.xyzx * unitWorldTangent_xyz_4.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord2.y = r4_xyz_3.x;
                o.texcoord2.x = unitWorldTangent_xyz_4.z;
                o.texcoord2.z = unitWorldNormal_xyz_5.y;
                o.texcoord3.x = unitWorldTangent_xyz_4.x;
                o.texcoord4.x = unitWorldTangent_xyz_4.y;
                o.texcoord3.z = unitWorldNormal_xyz_5.z;
                o.texcoord4.z = unitWorldNormal_xyz_5.x;
                o.texcoord3.y = r4_xyz_3.y;
                o.texcoord4.y = r4_xyz_3.z;
                o.texcoord5.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord6.xy = (mad(_MainTex_ST.xyxx, r0_xyzw_4.wwww, (mad(cb0_values[6].xyxx, r0_xyzw_4.zzzz, (mad(_Color.xyxx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * _EmissionColor.xyxx)).xyxx)).xyxx)).xyxx)).xy;
                o.texcoord8.x = clipPos_xyzw_2.z;
                o.texcoord7.zw = (clipPos_xyzw_2.zzzw).zw;
                float2 r1_xz_3 = ((clipPos_xyzw_2.xxwx * float4(0.5, 0, 0.5, 0))).xz;
                float r1_w_3 = ((clipPos_xyzw_2.y * unity_WorldToObject[1].x) * 0.5);
                o.texcoord7.xy = ((r1_xz_3.yyyy + float4(r1_xz_3.x, r1_w_3, r1_xz_3.x, r1_xz_3.x))).xy;
                return o;
            }
            #pragma fragment frag
            program110Output frag(program110Input i)
            {
                program110Output o = (program110Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord5.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float3 r2_xyz_1 = (_MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy)).xyz;
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord1.xyxx).xy);
                float3 r4_xyz_1 = (_SpecGlossMap.Sample(sampler_SpecGlossMap, (i.texcoord0.zwzz).xy)).xyz;
                float r4_x_2 = (r4_xyz_1.z * r4_xyz_1.x);
                float4 r4_xyzw_3 = mad(float4(r4_x_2, r4_xyz_1.y, r4_x_2, r4_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r4_x_3 = r4_xyzw_3.x;
                float r4_y_2 = r4_xyzw_3.y;
                float r1_w_1 = dot(float4(r4_x_3, r4_y_2, r4_x_3, r4_x_3), float4(r4_x_3, r4_y_2, r4_x_3, r4_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r4_z_2 = sqrt(r1_w_3);
                float3 r5_xyz_1 = ((r3_xyzw_1.xyzx * _SpecColor.xyzx)).xyz;
                float r7_x_1 = cb4_values[9].z;
                float r7_y_1 = cb4_values[10].z;
                float r7_z_1 = cb4_values[11].z;
                float r1_w_4 = dot(viewDir_xyz_1.xyzx, float4(r7_x_1, r7_y_1, r7_z_1, r7_x_1));
                float3 r7_xyz_2 = ((i.texcoord5.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_1 = dot(r7_xyz_2.xyzx, r7_xyz_2.xyzx);
                float r2_w_2 = sqrt(r2_w_1);
                float r2_w_3 = (-r1_w_4 + r2_w_2);
                float r1_w_5 = mad(cb3_values[25].w, r2_w_3, r1_w_4);
                float r1_w_6 = saturate(mad(r1_w_5, cb3_values[24].z, cb3_values[24].w));
                float r2_w_4 = (cb6_values[0].x == 1);
                float r7_x_12;
                float r7_y_12;
                float r7_z_12;
                float r7_w_4;
                if (r2_w_4)
                {
                    float r2_w_5 = (cb6_values[0].y == 1);
                    float3 r7_xyz_7 = (((mad(cb6_values[3].xyzx, i.texcoord5.zzzz, (mad(cb6_values[1].xyzx, i.texcoord5.xxxx, ((i.texcoord5.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r7_xyzw_10 = (((((r2_w_5.xxxx ? r7_xyz_7.xyzx : i.texcoord5.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r7_y_10 = r7_xyzw_10.y;
                    float r7_z_10 = r7_xyzw_10.z;
                    float r7_w_2 = r7_xyzw_10.w;
                    float r2_w_6 = mad(r7_y_10, 0.25, 0.75);
                    float r4_w_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r7_x_10 = max(r2_w_6, r4_w_1);
                    float4 r7_xyzw_11 = t5.Sample(sampler_linear_clamp, (float4(r7_x_10, r7_z_10, r7_w_2, r7_x_10)).xyz);
                    r7_x_12 = r7_xyzw_11.x;
                    r7_y_12 = r7_xyzw_11.y;
                    r7_z_12 = r7_xyzw_11.z;
                    r7_w_4 = r7_xyzw_11.w;
                }
                else
                {
                    float4 r7_xyzw_3 = float4(1, 1, 1, 1);
                    r7_x_12 = r7_xyzw_3.x;
                    r7_y_12 = r7_xyzw_3.y;
                    r7_z_12 = r7_xyzw_3.z;
                    r7_w_4 = r7_xyzw_3.w;
                }
                float r2_w_8 = saturate(dot(float4(r7_x_12, r7_y_12, r7_z_12, r7_w_4), unity_OcclusionMaskSelector));
                float2 r6_zw_1 = ((i.texcoord7.xxxy / i.texcoord7.wwww)).zw;
                float r4_w_3 = (_OcclusionMap.Sample(sampler_OcclusionMap, (r6_zw_1.xyxx).xy)).w;
                float r2_w_9 = (r2_w_8 + -r4_w_3);
                float r1_w_7 = mad(r1_w_6, r2_w_9, r4_w_3);
                float r2_w_10 = (t4.Sample(sampler_linear_clamp2, ((((mad(cb0_values[6].xyxx, i.texcoord5.zzzz, (mad(cb0_values[4].xyxx, i.texcoord5.xxxx, ((i.texcoord5.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx).xy)).w;
                float r1_w_8 = (r1_w_7 * r2_w_10);
                float r6_x_5 = dot(i.texcoord2.xyzx, float4(r4_x_3, r4_y_2, r4_z_2, r4_x_3));
                float r6_y_5 = dot(i.texcoord3.xyzx, float4(r4_x_3, r4_y_2, r4_z_2, r4_x_3));
                float r6_z_2 = dot(i.texcoord4.xyzx, float4(r4_x_3, r4_y_2, r4_z_2, r4_x_3));
                float r2_w_11 = dot(float4(r6_x_5, r6_y_5, r6_z_2, r6_x_5), float4(r6_x_5, r6_y_5, r6_z_2, r6_x_5));
                float r2_w_12 = rsqrt(r2_w_11);
                float4 r4_xyzw_4 = (r2_w_12.xxxx * float4(r6_x_5, r6_y_5, r6_z_2, r6_x_5));
                float r4_x_4 = r4_xyzw_4.x;
                float r4_y_3 = r4_xyzw_4.y;
                float r4_z_3 = r4_xyzw_4.z;
                float4 r6_xyzw_6 = (r1_w_8.xxxx * _LightColor0.xyzx);
                float r6_x_6 = r6_xyzw_6.x;
                float r6_y_6 = r6_xyzw_6.y;
                float r6_z_3 = r6_xyzw_6.z;
                float r1_w_9 = max(r5_xyz_1.y, r5_xyz_1.x);
                float r1_w_10 = max(r5_xyz_1.z, r1_w_9);
                float r1_w_11 = (-r1_w_10 + 1);
                float r1_w_12 = mad(-cb0_values[10].x, r3_xyzw_1.w, 1);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r4_x_4, r4_y_3, r4_z_3, r4_x_4), unitViewDir_xyz_1.xyzx);
                float r1_x_2 = saturate(dot(float4(r4_x_4, r4_y_3, r4_z_3, r4_x_4), _WorldSpaceLightPos0.xyzx));
                float r1_y_2 = saturate(dot(float4(r4_x_4, r4_y_3, r4_z_3, r4_x_4), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_12.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(r0_w_6) + 1);
                float r2_w_13 = (r1_z_4 * r1_z_4);
                float r2_w_14 = (r2_w_13 * r2_w_13);
                float r1_z_5 = (r1_z_4 * r2_w_14);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_12 * r1_w_12);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_z_6 = (-r0_z_8 + 1);
                float r1_w_13 = mad(abs(r0_w_6), r1_z_6, r0_z_8);
                float r1_z_7 = mad(r1_x_2, r1_z_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * r1_z_7);
                float r0_w_8 = mad(r1_x_2, r1_w_13, r0_w_7);
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
                float r0_w_11 = dot(r5_xyz_1.xyzx, r5_xyz_1.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_3 = (r0_y_9.xxxx * float4(r6_x_6, r6_y_6, r6_z_3, r6_x_6));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_5 = r1_xyzw_3.y;
                float r1_z_9 = r1_xyzw_3.z;
                float4 r0_xyzw_10 = (float4(r6_x_6, r6_x_6, r6_y_6, r6_z_3) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_14 = (r0_x_5 * r0_x_5);
                float r1_w_15 = (r1_w_14 * r1_w_14);
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * (mad((mad(-_SpecColor.xyzx, r3_xyzw_1.xyzx, float4(1, 1, 1, 0))).xyzx, ((r0_x_5 * r1_w_15)).xxxx, r5_xyz_1.xyzx)).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_11.xxxx * ((r2_xyz_1.xyzx * cb0_values[8].xyzx)).xyzx)).xyzx, float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float r0_w_15 = (i.texcoord8.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8) * r0_w_19.xxxx)).xyz;
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
                float4 cb0_values[7];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
                float4 cb1_values[6];
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
                float4 cb5_values[2];
            };
            cbuffer cb6 : register(b6)
            {
                float4 cb6_values[7];
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
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float texcoord8 : TEXCOORD8;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program109Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float texcoord8 : TEXCOORD8;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program109Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program63Output vert(program63Input i)
            {
                program63Output o = (program63Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                o.texcoord5.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _SpecGlossMap_ST.xyxx, _SpecGlossMap_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _OcclusionMap_ST.xxxy, _OcclusionMap_ST.zzzw)).zw;
                o.texcoord8.x = clipPos_xyzw_7.z;
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
                o.texcoord2.y = r3_xyz_3.x;
                o.texcoord2.x = unitWorldTangent_xyz_4.z;
                o.texcoord2.z = unitWorldNormal_xyz_3.y;
                o.texcoord3.x = unitWorldTangent_xyz_4.x;
                o.texcoord4.x = unitWorldTangent_xyz_4.y;
                o.texcoord3.z = unitWorldNormal_xyz_3.z;
                o.texcoord4.z = unitWorldNormal_xyz_3.x;
                o.texcoord3.y = r3_xyz_3.y;
                o.texcoord4.y = r3_xyz_3.z;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r1_xyzw_4 = (float4(clipPos_xyzw_7.x, clipPos_xyzw_7.x, clipPos_xyzw_7.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_z_4 = r1_xyzw_4.z;
                float r1_w_7 = r1_xyzw_4.w;
                o.texcoord7.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord7.xy = ((r1_z_4.xxxx + float4(r1_x_4, r1_w_7, r1_x_4, r1_x_4))).xy;
                return o;
            }
            #pragma fragment frag
            program109Output frag(program109Input i)
            {
                program109Output o = (program109Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord5.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float3 r2_xyz_1 = (_MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy)).xyz;
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord1.xyxx).xy);
                float3 r4_xyz_1 = (_SpecGlossMap.Sample(sampler_SpecGlossMap, (i.texcoord0.zwzz).xy)).xyz;
                float r4_x_2 = (r4_xyz_1.z * r4_xyz_1.x);
                float4 r4_xyzw_3 = mad(float4(r4_x_2, r4_xyz_1.y, r4_x_2, r4_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r4_x_3 = r4_xyzw_3.x;
                float r4_y_2 = r4_xyzw_3.y;
                float r1_w_1 = dot(float4(r4_x_3, r4_y_2, r4_x_3, r4_x_3), float4(r4_x_3, r4_y_2, r4_x_3, r4_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r4_z_2 = sqrt(r1_w_3);
                float3 r5_xyz_1 = ((r3_xyzw_1.xyzx * _SpecColor.xyzx)).xyz;
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r1_w_4 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float3 r6_xyz_2 = ((i.texcoord5.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_1 = dot(r6_xyz_2.xyzx, r6_xyz_2.xyzx);
                float r2_w_2 = sqrt(r2_w_1);
                float r2_w_3 = (-r1_w_4 + r2_w_2);
                float r1_w_5 = mad(cb3_values[25].w, r2_w_3, r1_w_4);
                float r1_w_6 = saturate(mad(r1_w_5, cb3_values[24].z, cb3_values[24].w));
                float r2_w_4 = (cb6_values[0].x == 1);
                float r6_x_12;
                float r6_y_12;
                float r6_z_12;
                float r6_w_4;
                if (r2_w_4)
                {
                    float r2_w_5 = (cb6_values[0].y == 1);
                    float3 r6_xyz_7 = (((mad(cb6_values[3].xyzx, i.texcoord5.zzzz, (mad(cb6_values[1].xyzx, i.texcoord5.xxxx, ((i.texcoord5.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r6_xyzw_10 = (((((r2_w_5.xxxx ? r6_xyz_7.xyzx : i.texcoord5.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r6_y_10 = r6_xyzw_10.y;
                    float r6_z_10 = r6_xyzw_10.z;
                    float r6_w_2 = r6_xyzw_10.w;
                    float r2_w_6 = mad(r6_y_10, 0.25, 0.75);
                    float r4_w_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r6_x_10 = max(r2_w_6, r4_w_1);
                    float4 r6_xyzw_11 = t4.Sample(sampler_linear_clamp, (float4(r6_x_10, r6_z_10, r6_w_2, r6_x_10)).xyz);
                    r6_x_12 = r6_xyzw_11.x;
                    r6_y_12 = r6_xyzw_11.y;
                    r6_z_12 = r6_xyzw_11.z;
                    r6_w_4 = r6_xyzw_11.w;
                }
                else
                {
                    float4 r6_xyzw_3 = float4(1, 1, 1, 1);
                    r6_x_12 = r6_xyzw_3.x;
                    r6_y_12 = r6_xyzw_3.y;
                    r6_z_12 = r6_xyzw_3.z;
                    r6_w_4 = r6_xyzw_3.w;
                }
                float r2_w_8 = saturate(dot(float4(r6_x_12, r6_y_12, r6_z_12, r6_w_4), unity_OcclusionMaskSelector));
                float r4_w_3 = (_OcclusionMap.Sample(sampler_OcclusionMap, (((i.texcoord7.xyxx / i.texcoord7.wwww)).xyxx).xy)).w;
                float r2_w_9 = (r2_w_8 + -r4_w_3);
                float r1_w_7 = mad(r1_w_6, r2_w_9, r4_w_3);
                float r6_x_14 = dot(i.texcoord2.xyzx, float4(r4_x_3, r4_y_2, r4_z_2, r4_x_3));
                float r6_y_14 = dot(i.texcoord3.xyzx, float4(r4_x_3, r4_y_2, r4_z_2, r4_x_3));
                float r6_z_13 = dot(i.texcoord4.xyzx, float4(r4_x_3, r4_y_2, r4_z_2, r4_x_3));
                float r2_w_10 = dot(float4(r6_x_14, r6_y_14, r6_z_13, r6_x_14), float4(r6_x_14, r6_y_14, r6_z_13, r6_x_14));
                float r2_w_11 = rsqrt(r2_w_10);
                float4 r4_xyzw_4 = (r2_w_11.xxxx * float4(r6_x_14, r6_y_14, r6_z_13, r6_x_14));
                float r4_x_4 = r4_xyzw_4.x;
                float r4_y_3 = r4_xyzw_4.y;
                float r4_z_3 = r4_xyzw_4.z;
                float4 r6_xyzw_15 = (r1_w_7.xxxx * _LightColor0.xyzx);
                float r6_x_15 = r6_xyzw_15.x;
                float r6_y_15 = r6_xyzw_15.y;
                float r6_z_14 = r6_xyzw_15.z;
                float r1_w_8 = max(r5_xyz_1.y, r5_xyz_1.x);
                float r1_w_9 = max(r5_xyz_1.z, r1_w_8);
                float r1_w_10 = (-r1_w_9 + 1);
                float r1_w_11 = mad(-cb0_values[6].x, r3_xyzw_1.w, 1);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r4_x_4, r4_y_3, r4_z_3, r4_x_4), unitViewDir_xyz_1.xyzx);
                float r1_x_2 = saturate(dot(float4(r4_x_4, r4_y_3, r4_z_3, r4_x_4), _WorldSpaceLightPos0.xyzx));
                float r1_y_2 = saturate(dot(float4(r4_x_4, r4_y_3, r4_z_3, r4_x_4), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_11.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(r0_w_6) + 1);
                float r2_w_12 = (r1_z_4 * r1_z_4);
                float r2_w_13 = (r2_w_12 * r2_w_12);
                float r1_z_5 = (r1_z_4 * r2_w_13);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_11 * r1_w_11);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_z_6 = (-r0_z_8 + 1);
                float r1_w_12 = mad(abs(r0_w_6), r1_z_6, r0_z_8);
                float r1_z_7 = mad(r1_x_2, r1_z_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * r1_z_7);
                float r0_w_8 = mad(r1_x_2, r1_w_12, r0_w_7);
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
                float r0_w_11 = dot(r5_xyz_1.xyzx, r5_xyz_1.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_3 = (r0_y_9.xxxx * float4(r6_x_15, r6_y_15, r6_z_14, r6_x_15));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_5 = r1_xyzw_3.y;
                float r1_z_9 = r1_xyzw_3.z;
                float4 r0_xyzw_10 = (float4(r6_x_15, r6_x_15, r6_y_15, r6_z_14) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_13 = (r0_x_5 * r0_x_5);
                float r1_w_14 = (r1_w_13 * r1_w_13);
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * (mad((mad(-_SpecColor.xyzx, r3_xyzw_1.xyzx, float4(1, 1, 1, 0))).xyzx, ((r0_x_5 * r1_w_14)).xxxx, r5_xyz_1.xyzx)).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_10.xxxx * ((r2_xyz_1.xyzx * cb0_values[4].xyzx)).xyzx)).xyzx, float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float r0_w_15 = (i.texcoord8.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8) * r0_w_19.xxxx)).xyz;
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
                float4 cb0_values[20];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
                float4 cb1_values[6];
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
                float4 cb5_values[2];
            };
            cbuffer cb6 : register(b6)
            {
                float4 cb6_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerComparisonState sampler_comparison_linear_clamp1;
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_linear_clamp3;
            SamplerState sampler_MainTex;
            SamplerState sampler_SpecGlossMap;
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _SpecGlossMap;
            Texture2D _OcclusionMap;
            Texture2D t4;
            Texture3D t5;
            Texture2D t6;
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
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float texcoord8 : TEXCOORD8;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program108Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float texcoord8 : TEXCOORD8;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program108Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program62Output vert(program62Input i)
            {
                program62Output o = (program62Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * unity_MatrixVP[1])));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord8.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[16].xyxx, cb0_values[16].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[17].xxxy, cb0_values[17].zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, cb0_values[18].xyxx, cb0_values[18].zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, cb0_values[19].xxxy, cb0_values[19].zzzw)).zw;
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                float3 unitWorldNormal_xyz_4 = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_7 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_7.xxxx * (mad(unitWorldNormal_xyz_4.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_4.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord2.y = r3_xyz_3.x;
                o.texcoord2.x = unitWorldTangent_xyz_7.z;
                o.texcoord2.z = unitWorldNormal_xyz_4.y;
                o.texcoord3.x = unitWorldTangent_xyz_7.x;
                o.texcoord4.x = unitWorldTangent_xyz_7.y;
                o.texcoord3.z = unitWorldNormal_xyz_4.z;
                o.texcoord4.z = unitWorldNormal_xyz_4.x;
                o.texcoord3.y = r3_xyz_3.y;
                o.texcoord4.y = r3_xyz_3.z;
                o.texcoord5.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float4 clipPos_xyzw_5 = (worldPos_xyzw_4.yyyy * _OcclusionMap_ST);
                float4 clipPos_xyzw_6 = mad(_SpecGlossMap_ST, worldPos_xyzw_4.xxxx, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb0_values[11].xyzw, worldPos_xyzw_4.zzzz, clipPos_xyzw_6);
                o.texcoord6.xyzw = mad(cb0_values[12].xyzw, worldPos_xyzw_4.wwww, clipPos_xyzw_7);
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program108Output frag(program108Input i)
            {
                program108Output o = (program108Output)0;
                float3 r0_xyz_1 = ((-i.texcoord5.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord5.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float3 r4_xyz_1 = (_MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy)).xyz;
                float4 r5_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord1.xyxx).xy);
                float3 r6_xyz_1 = (_SpecGlossMap.Sample(sampler_SpecGlossMap, (i.texcoord0.zwzz).xy)).xyz;
                float r6_x_2 = (r6_xyz_1.z * r6_xyz_1.x);
                float4 r6_xyzw_3 = mad(float4(r6_x_2, r6_xyz_1.y, r6_x_2, r6_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r6_x_3 = r6_xyzw_3.x;
                float r6_y_2 = r6_xyzw_3.y;
                float r1_w_3 = dot(float4(r6_x_3, r6_y_2, r6_x_3, r6_x_3), float4(r6_x_3, r6_y_2, r6_x_3, r6_x_3));
                float r1_w_4 = min(r1_w_3, 1);
                float r1_w_5 = (-r1_w_4 + 1);
                float r6_z_2 = sqrt(r1_w_5);
                float3 r7_xyz_1 = ((r5_xyzw_1.xyzx * _SpecColor.xyzx)).xyz;
                float4 r8_xyzw_4 = (mad(cb0_values[11].xyzw, i.texcoord5.zzzz, mad(cb0_values[9].xyzw, i.texcoord5.xxxx, (i.texcoord5.yyyy * cb0_values[10].xyzw))) + cb0_values[12].xyzw);
                float r9_x_1 = cb4_values[9].z;
                float r9_y_1 = cb4_values[10].z;
                float r9_z_1 = cb4_values[11].z;
                float r1_w_6 = dot(viewDir_xyz_1.xyzx, float4(r9_x_1, r9_y_1, r9_z_1, r9_x_1));
                float3 r2_xyz_2 = ((i.texcoord5.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_7 = mad(cb3_values[25].w, (-r1_w_6 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_6);
                float r1_w_8 = saturate(mad(r1_w_7, cb3_values[24].z, cb3_values[24].w));
                float r2_x_13;
                float r2_y_13;
                float r2_z_12;
                float r2_w_8;
                if ((cb6_values[0].x == 1))
                {
                    float4 r2_xyzw_4 = (i.texcoord5.yyyy * cb6_values[2].xxyz);
                    float r2_y_4 = r2_xyzw_4.y;
                    float r2_z_4 = r2_xyzw_4.z;
                    float r2_w_2 = r2_xyzw_4.w;
                    float4 r2_xyzw_5 = mad(cb6_values[1].xxyz, i.texcoord5.xxxx, float4(r2_y_4, r2_y_4, r2_z_4, r2_w_2));
                    float r2_y_5 = r2_xyzw_5.y;
                    float r2_z_5 = r2_xyzw_5.z;
                    float r2_w_3 = r2_xyzw_5.w;
                    float4 r2_xyzw_6 = mad(cb6_values[3].xxyz, i.texcoord5.zzzz, float4(r2_y_5, r2_y_5, r2_z_5, r2_w_3));
                    float r2_y_6 = r2_xyzw_6.y;
                    float r2_z_6 = r2_xyzw_6.z;
                    float r2_w_4 = r2_xyzw_6.w;
                    float4 r2_xyzw_7 = (float4(r2_y_6, r2_y_6, r2_z_6, r2_w_4) + cb6_values[4].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_5 = r2_xyzw_7.w;
                    float4 r2_xyzw_9 = (((cb6_values[0].y == 1)).xxxx ? float4(r2_y_7, r2_z_7, r2_w_5, r2_y_7) : i.texcoord5.xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_8 = r2_xyzw_9.y;
                    float r2_z_8 = r2_xyzw_9.z;
                    float4 r2_xyzw_10 = (float4(r2_x_9, r2_y_8, r2_z_8, r2_x_9) + -cb6_values[6].xyzx);
                    float r2_x_10 = r2_xyzw_10.x;
                    float r2_y_9 = r2_xyzw_10.y;
                    float r2_z_9 = r2_xyzw_10.z;
                    float r2_y_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).y;
                    float r2_z_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).z;
                    float r2_w_6 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).w;
                    float r2_y_11 = mad(r2_y_10, 0.25, 0.75);
                    float r3_w_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r2_x_11 = max(r2_y_11, r3_w_1);
                    float4 r2_xyzw_12 = t5.Sample(sampler_linear_clamp, (float4(r2_x_11, r2_z_10, r2_w_6, r2_x_11)).xyz);
                    r2_x_13 = r2_xyzw_12.x;
                    r2_y_13 = r2_xyzw_12.y;
                    r2_z_12 = r2_xyzw_12.z;
                    r2_w_8 = r2_xyzw_12.w;
                }
                else
                {
                    float r2_x_7 = (float4(1, 1, 1, 1)).x;
                    float4 r2_xyzw_3 = float4(1, 1, 1, 1);
                    float r2_y_3 = r2_xyzw_3.y;
                    float r2_z_3 = r2_xyzw_3.z;
                    float r2_w_1 = r2_xyzw_3.w;
                    r2_x_13 = r2_x_7;
                    r2_y_13 = r2_y_3;
                    r2_z_12 = r2_z_3;
                    r2_w_8 = r2_w_1;
                }
                float r2_y_14 = (r1_w_8 < 0.99);
                float r2_y_27;
                if (r2_y_14)
                {
                    float4 r9_xyzw_2 = (i.texcoord5.yyyy * cb3_values[9].xyzw);
                    float4 r9_xyzw_3 = mad(cb3_values[8].xyzw, i.texcoord5.xxxx, r9_xyzw_2);
                    float4 r9_xyzw_4 = mad(cb3_values[10].xyzw, i.texcoord5.zzzz, r9_xyzw_3);
                    float4 r9_xyzw_5 = (r9_xyzw_4 + cb3_values[11].xyzw);
                    float4 r2_xyzw_16 = (r9_xyzw_5.xxyz / r9_xyzw_5.wwww);
                    float r2_y_16 = r2_xyzw_16.y;
                    float r2_z_13 = r2_xyzw_16.z;
                    float r2_w_9 = r2_xyzw_16.w;
                    float2 r9_xy_7 = (floor((mad(float4(r2_y_16, r2_z_13, r2_y_16, r2_y_16), cb0_values[8].zwzz, float4(0.5, 0.5, 0, 0))).xyxx)).xy;
                    float4 r2_xyzw_17 = mad(float4(r2_y_16, r2_y_16, r2_z_13, r2_y_16), cb0_values[8].zzwz, -r9_xy_7.xxyx);
                    float r2_y_17 = r2_xyzw_17.y;
                    float r2_z_14 = r2_xyzw_17.z;
                    float4 r10_xyzw_1 = (float4(r2_y_17, r2_y_17, r2_z_14, r2_z_14) + float4(0.5, 1, 0.5, 1));
                    float2 r11_xw_1 = ((r10_xyzw_1.xxxz * r10_xyzw_1.xxxz)).xw;
                    float4 r9_xyzw_6 = mad(r11_xw_1.xxxy, float4(0, 0, 0.5, 0.5), -float4(r2_y_17, r2_y_17, r2_y_17, r2_z_14));
                    float r9_z_6 = r9_xyzw_6.z;
                    float r9_w_5 = r9_xyzw_6.w;
                    float2 r10_xz_2 = ((-float4(r2_y_17, r2_y_17, r2_z_14, r2_y_17) + float4(1, 0, 1, 0))).xz;
                    float2 r12_xy_1 = (min(float4(r2_y_17, r2_z_14, r2_y_17, r2_y_17), float4(0, 0, 0, 0))).xy;
                    float2 r10_xz_3 = (mad(-r12_xy_1.xxyx, r12_xy_1.xxyx, r10_xz_2.xxyx)).xz;
                    float4 r2_xyzw_18 = max(float4(r2_y_17, r2_y_17, r2_z_14, r2_y_17), float4(0, 0, 0, 0));
                    float r2_y_18 = r2_xyzw_18.y;
                    float r2_z_15 = r2_xyzw_18.z;
                    float4 r2_xyzw_19 = mad(-float4(r2_y_18, r2_y_18, r2_z_15, r2_y_18), float4(r2_y_18, r2_y_18, r2_z_15, r2_y_18), r10_xyzw_1.yywy);
                    float r2_y_19 = r2_xyzw_19.y;
                    float r2_z_16 = r2_xyzw_19.z;
                    float r12_x_2 = r9_z_6;
                    float r12_y_2 = r10_xz_3.x;
                    float r12_z_1 = r2_y_19;
                    float r12_w_1 = r11_xw_1.x;
                    float4 r12_xyzw_3 = (float4(r12_x_2, r12_y_2, r12_z_1, r12_w_1) * float4(0.44444, 0.44444, 0.44444, 0.22222));
                    float r11_x_2 = r9_w_5;
                    float r11_y_1 = r10_xz_3.y;
                    float r11_z_1 = r2_z_16;
                    float4 r10_xyzw_4 = (float4(r11_x_2, r11_y_1, r11_z_1, r11_xw_1.y) * float4(0.44444, 0.44444, 0.44444, 0.22222));
                    float4 r11_xyzw_3 = (r12_xyzw_3.ywyw + r12_xyzw_3.xzxz);
                    float4 r13_xyzw_1 = (r10_xyzw_4.yyww + r10_xyzw_4.xxzz);
                    float4 r2_xyzw_20 = (r12_xyzw_3.yywy / r11_xyzw_3.zzwz);
                    float r2_y_20 = r2_xyzw_20.y;
                    float r2_z_17 = r2_xyzw_20.z;
                    float4 r2_xyzw_21 = (float4(r2_y_20, r2_y_20, r2_z_17, r2_y_20) + float4(0, -1.5, 0.5, 0));
                    float r2_y_21 = r2_xyzw_21.y;
                    float r2_z_18 = r2_xyzw_21.z;
                    float4 r9_xyzw_7 = (r10_xyzw_4.yyyw / r13_xyzw_1.yyyw);
                    float r9_z_7 = r9_xyzw_7.z;
                    float r9_w_6 = r9_xyzw_7.w;
                    float4 r9_xyzw_8 = (float4(r9_z_7, r9_z_7, r9_z_7, r9_w_6) + float4(0, 0, -1.5, 0.5));
                    float r9_z_8 = r9_xyzw_8.z;
                    float r9_w_7 = r9_xyzw_8.w;
                    float4 r10_xyzw_5 = (float4(r2_y_21, r2_z_18, r2_y_21, r2_y_21) * cb0_values[8].xxxx);
                    float r10_x_5 = r10_xyzw_5.x;
                    float r10_y_3 = r10_xyzw_5.y;
                    float r10_z_5 = ((float4(r9_z_8, r9_z_8, r9_z_8, r9_w_7) * cb0_values[8].yyyy)).z;
                    float r10_w_3 = ((float4(r9_z_8, r9_z_8, r9_z_8, r9_w_7) * cb0_values[8].yyyy)).w;
                    float4 r11_xyzw_4 = (r11_xyzw_3 * r13_xyzw_1);
                    float4 r12_xyzw_4 = mad(r9_xy_7.xyxy, cb0_values[8].xyxy, float4(r10_x_5, r10_z_5, r10_y_3, r10_z_5));
                    float r2_y_22 = t6.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r12_xyzw_4.xyxx).xy, r2_w_9);
                    float r2_z_19 = t6.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r12_xyzw_4.zwzz).xy, r2_w_9);
                    float r2_z_20 = (r2_z_19 * r11_xyzw_4.y);
                    float r2_y_23 = mad(r11_xyzw_4.x, r2_y_22, r2_z_20);
                    float r9_x_8 = (mad(r9_xy_7.xyxy, cb0_values[8].xyxy, float4(r10_x_5, r10_w_3, r10_y_3, r10_w_3))).x;
                    float r9_y_8 = (mad(r9_xy_7.xyxy, cb0_values[8].xyxy, float4(r10_x_5, r10_w_3, r10_y_3, r10_w_3))).y;
                    float4 r9_xyzw_9 = mad(r9_xy_7.xyxy, cb0_values[8].xyxy, float4(r10_x_5, r10_w_3, r10_y_3, r10_w_3));
                    float r9_z_9 = r9_xyzw_9.z;
                    float r9_w_8 = r9_xyzw_9.w;
                    float r2_z_21 = t6.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r9_x_8, r9_y_8, r9_x_8, r9_x_8)).xy, r2_w_9);
                    float r2_y_24 = mad(r11_xyzw_4.z, r2_z_21, r2_y_23);
                    float r2_z_22 = t6.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r9_z_9, r9_w_8, r9_z_9, r9_z_9)).xy, r2_w_9);
                    float r2_y_25 = mad(r11_xyzw_4.w, r2_z_22, r2_y_24);
                    float r2_z_23 = (-cb3_values[24].x + 1);
                    float r2_y_26 = mad(r2_y_25, r2_z_23, cb3_values[24].x);
                    r2_y_27 = r2_y_26;
                }
                else
                {
                    float r2_y_15 = 1;
                    r2_y_27 = r2_y_15;
                }
                float r1_w_9 = mad(r1_w_8, (-r2_y_27 + saturate(dot(float4(r2_x_13, r2_y_13, r2_z_12, r2_w_8), unity_OcclusionMaskSelector))), r2_y_27);
                float4 r2_xyzw_28 = (r8_xyzw_4.xxyx / r8_xyzw_4.wwww);
                float r2_y_28 = r2_xyzw_28.y;
                float r2_z_25 = r2_xyzw_28.z;
                float4 r2_xyzw_29 = (float4(r2_y_28, r2_y_28, r2_z_25, r2_y_28) + float4(0, 0.5, 0.5, 0));
                float r2_y_29 = r2_xyzw_29.y;
                float r2_z_26 = r2_xyzw_29.z;
                float r2_y_30 = (_OcclusionMap.Sample(sampler_OcclusionMap, (float4(r2_y_29, r2_z_26, r2_y_29, r2_y_29)).xy)).y;
                float r2_y_31 = dot(r8_xyzw_4.xyzx, r8_xyzw_4.xyzx);
                float r2_y_32 = (t4.Sample(sampler_linear_clamp3, (r2_y_31.xxxx).xy)).y;
                float r1_w_10 = (r1_w_9 * (r2_y_32 * (r2_y_30 * asfloat(asint((float)((0 < r8_xyzw_4.z))) & asint(1065353216)))));
                float r2_x_20 = dot(i.texcoord2.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_y_33 = dot(i.texcoord3.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_z_27 = dot(i.texcoord4.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_w_11 = dot(float4(r2_x_20, r2_y_33, r2_z_27, r2_x_20), float4(r2_x_20, r2_y_33, r2_z_27, r2_x_20));
                float r2_w_12 = rsqrt(r2_w_11);
                float r2_x_21 = ((r2_w_12.xxxx * float4(r2_x_20, r2_y_33, r2_z_27, r2_x_20))).x;
                float4 r2_xyzw_34 = (r2_w_12.xxxx * float4(r2_x_20, r2_y_33, r2_z_27, r2_x_20));
                float r2_y_34 = r2_xyzw_34.y;
                float r2_z_28 = r2_xyzw_34.z;
                float4 r6_xyzw_4 = (r1_w_10.xxxx * _LightColor0.xyzx);
                float r6_x_4 = r6_xyzw_4.x;
                float r6_y_3 = r6_xyzw_4.y;
                float r6_z_3 = r6_xyzw_4.z;
                float r1_w_11 = max(r7_xyz_1.y, r7_xyz_1.x);
                float r1_w_12 = max(r7_xyz_1.z, r1_w_11);
                float r1_w_13 = (-r1_w_12 + 1);
                float r1_w_14 = mad(-cb0_values[15].x, r5_xyzw_1.w, 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r2_x_21, r2_y_34, r2_z_28, r2_x_21), unitViewDir_xyz_1.xyzx);
                float r2_w_13 = saturate(dot(float4(r2_x_21, r2_y_34, r2_z_28, r2_x_21), r1_xyz_1.xyzx));
                float r2_x_22 = saturate(dot(float4(r2_x_21, r2_y_34, r2_z_28, r2_x_21), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_14.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_13 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_14 * r1_w_14);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(r0_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * mad(r2_w_13, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_13, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r2_x_22, r0_z_9, -r2_x_22), r2_x_22, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_w_13.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r7_xyz_1.xyzx, r7_xyz_1.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r6_x_4, r6_y_3, r6_z_3, r6_x_4));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r6_x_4, r6_x_4, r6_y_3, r6_z_3) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_15 = (r0_x_5 * r0_x_5);
                float r1_w_16 = (r1_w_15 * r1_w_15);
                float4 r2_xyzw_23 = mad(-_SpecColor.xyzx, r5_xyzw_1.xyzx, float4(1, 1, 1, 0));
                float r2_x_23 = r2_xyzw_23.x;
                float r2_y_35 = r2_xyzw_23.y;
                float r2_z_29 = r2_xyzw_23.z;
                float4 r2_xyzw_24 = mad(float4(r2_x_23, r2_y_35, r2_z_29, r2_x_23), ((r0_x_5 * r1_w_16)).xxxx, r7_xyz_1.xyzx);
                float r2_x_24 = r2_xyzw_24.x;
                float r2_y_36 = r2_xyzw_24.y;
                float r2_z_30 = r2_xyzw_24.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_24, r2_y_36, r2_z_30, r2_x_24));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_13.xxxx * ((r4_xyz_1.xyzx * cb0_values[13].xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float r0_w_15 = (i.texcoord8.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8) * r0_w_19.xxxx)).xyz;
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
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
                float4 cb1_values[6];
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
                float4 cb5_values[2];
            };
            cbuffer cb6 : register(b6)
            {
                float4 cb6_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerComparisonState sampler_comparison_linear_clamp1;
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_linear_clamp3;
            SamplerState sampler_MainTex;
            SamplerState sampler_SpecGlossMap;
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _SpecGlossMap;
            Texture2D _OcclusionMap;
            Texture2D t4;
            Texture3D t5;
            Texture2D t6;
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
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float texcoord8 : TEXCOORD8;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program107Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float texcoord8 : TEXCOORD8;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program107Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program61Output vert(program61Input i)
            {
                program61Output o = (program61Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * unity_MatrixVP[1])));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord8.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[12].xxxy, cb0_values[12].zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, cb0_values[13].xyxx, cb0_values[13].zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, cb0_values[14].xxxy, cb0_values[14].zzzw)).zw;
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                float3 unitWorldNormal_xyz_4 = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_7 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_7.xxxx * (mad(unitWorldNormal_xyz_4.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_4.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord2.y = r3_xyz_3.x;
                o.texcoord2.x = unitWorldTangent_xyz_7.z;
                o.texcoord2.z = unitWorldNormal_xyz_4.y;
                o.texcoord3.x = unitWorldTangent_xyz_7.x;
                o.texcoord4.x = unitWorldTangent_xyz_7.y;
                o.texcoord3.z = unitWorldNormal_xyz_4.z;
                o.texcoord4.z = unitWorldNormal_xyz_4.x;
                o.texcoord3.y = r3_xyz_3.y;
                o.texcoord4.y = r3_xyz_3.z;
                o.texcoord5.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float4 clipPos_xyzw_5 = (worldPos_xyzw_4.yyyy * _EmissionColor);
                float4 clipPos_xyzw_6 = mad(_Color, worldPos_xyzw_4.xxxx, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb0_values[6].xyzw, worldPos_xyzw_4.zzzz, clipPos_xyzw_6);
                o.texcoord6.xyzw = mad(_MainTex_ST, worldPos_xyzw_4.wwww, clipPos_xyzw_7);
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program107Output frag(program107Input i)
            {
                program107Output o = (program107Output)0;
                float3 r0_xyz_1 = ((-i.texcoord5.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord5.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float3 r4_xyz_1 = (_MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy)).xyz;
                float4 r5_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord1.xyxx).xy);
                float3 r6_xyz_1 = (_SpecGlossMap.Sample(sampler_SpecGlossMap, (i.texcoord0.zwzz).xy)).xyz;
                float r6_x_2 = (r6_xyz_1.z * r6_xyz_1.x);
                float4 r6_xyzw_3 = mad(float4(r6_x_2, r6_xyz_1.y, r6_x_2, r6_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r6_x_3 = r6_xyzw_3.x;
                float r6_y_2 = r6_xyzw_3.y;
                float r1_w_3 = dot(float4(r6_x_3, r6_y_2, r6_x_3, r6_x_3), float4(r6_x_3, r6_y_2, r6_x_3, r6_x_3));
                float r1_w_4 = min(r1_w_3, 1);
                float r1_w_5 = (-r1_w_4 + 1);
                float r6_z_2 = sqrt(r1_w_5);
                float3 r7_xyz_1 = ((r5_xyzw_1.xyzx * _SpecColor.xyzx)).xyz;
                float4 r8_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord5.zzzz, mad(cb0_values[4].xyzw, i.texcoord5.xxxx, (i.texcoord5.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r9_x_1 = cb4_values[9].z;
                float r9_y_1 = cb4_values[10].z;
                float r9_z_1 = cb4_values[11].z;
                float r1_w_6 = dot(viewDir_xyz_1.xyzx, float4(r9_x_1, r9_y_1, r9_z_1, r9_x_1));
                float3 r2_xyz_2 = ((i.texcoord5.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_7 = mad(cb3_values[25].w, (-r1_w_6 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_6);
                float r1_w_8 = saturate(mad(r1_w_7, cb3_values[24].z, cb3_values[24].w));
                float r2_x_13;
                float r2_y_13;
                float r2_z_12;
                float r2_w_8;
                if ((cb6_values[0].x == 1))
                {
                    float4 r2_xyzw_4 = (i.texcoord5.yyyy * cb6_values[2].xxyz);
                    float r2_y_4 = r2_xyzw_4.y;
                    float r2_z_4 = r2_xyzw_4.z;
                    float r2_w_2 = r2_xyzw_4.w;
                    float4 r2_xyzw_5 = mad(cb6_values[1].xxyz, i.texcoord5.xxxx, float4(r2_y_4, r2_y_4, r2_z_4, r2_w_2));
                    float r2_y_5 = r2_xyzw_5.y;
                    float r2_z_5 = r2_xyzw_5.z;
                    float r2_w_3 = r2_xyzw_5.w;
                    float4 r2_xyzw_6 = mad(cb6_values[3].xxyz, i.texcoord5.zzzz, float4(r2_y_5, r2_y_5, r2_z_5, r2_w_3));
                    float r2_y_6 = r2_xyzw_6.y;
                    float r2_z_6 = r2_xyzw_6.z;
                    float r2_w_4 = r2_xyzw_6.w;
                    float4 r2_xyzw_7 = (float4(r2_y_6, r2_y_6, r2_z_6, r2_w_4) + cb6_values[4].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_5 = r2_xyzw_7.w;
                    float4 r2_xyzw_9 = (((cb6_values[0].y == 1)).xxxx ? float4(r2_y_7, r2_z_7, r2_w_5, r2_y_7) : i.texcoord5.xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_8 = r2_xyzw_9.y;
                    float r2_z_8 = r2_xyzw_9.z;
                    float4 r2_xyzw_10 = (float4(r2_x_9, r2_y_8, r2_z_8, r2_x_9) + -cb6_values[6].xyzx);
                    float r2_x_10 = r2_xyzw_10.x;
                    float r2_y_9 = r2_xyzw_10.y;
                    float r2_z_9 = r2_xyzw_10.z;
                    float r2_y_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).y;
                    float r2_z_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).z;
                    float r2_w_6 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).w;
                    float r2_y_11 = mad(r2_y_10, 0.25, 0.75);
                    float r3_w_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r2_x_11 = max(r2_y_11, r3_w_1);
                    float4 r2_xyzw_12 = t5.Sample(sampler_linear_clamp, (float4(r2_x_11, r2_z_10, r2_w_6, r2_x_11)).xyz);
                    r2_x_13 = r2_xyzw_12.x;
                    r2_y_13 = r2_xyzw_12.y;
                    r2_z_12 = r2_xyzw_12.z;
                    r2_w_8 = r2_xyzw_12.w;
                }
                else
                {
                    float r2_x_7 = (float4(1, 1, 1, 1)).x;
                    float4 r2_xyzw_3 = float4(1, 1, 1, 1);
                    float r2_y_3 = r2_xyzw_3.y;
                    float r2_z_3 = r2_xyzw_3.z;
                    float r2_w_1 = r2_xyzw_3.w;
                    r2_x_13 = r2_x_7;
                    r2_y_13 = r2_y_3;
                    r2_z_12 = r2_z_3;
                    r2_w_8 = r2_w_1;
                }
                float4 r9_xyzw_2 = (i.texcoord5.yyyy * cb3_values[9].xyzw);
                float4 r9_xyzw_3 = mad(cb3_values[8].xyzw, i.texcoord5.xxxx, r9_xyzw_2);
                float4 r9_xyzw_4 = mad(cb3_values[10].xyzw, i.texcoord5.zzzz, r9_xyzw_3);
                float4 r9_xyzw_5 = (r9_xyzw_4 + cb3_values[11].xyzw);
                float4 r2_xyzw_14 = (r9_xyzw_5.xxyz / r9_xyzw_5.wwww);
                float r2_y_14 = r2_xyzw_14.y;
                float r2_z_13 = r2_xyzw_14.z;
                float r2_w_9 = r2_xyzw_14.w;
                float r2_y_15 = t6.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r2_y_14, r2_z_13, r2_y_14, r2_y_14)).xy, r2_w_9);
                float r2_z_14 = (-cb3_values[24].x + 1);
                float r2_y_16 = mad(r2_y_15, r2_z_14, cb3_values[24].x);
                float r1_w_9 = mad(r1_w_8, (-r2_y_16 + saturate(dot(float4(r2_x_13, r2_y_13, r2_z_12, r2_w_8), unity_OcclusionMaskSelector))), r2_y_16);
                float4 r2_xyzw_17 = (r8_xyzw_4.xxyx / r8_xyzw_4.wwww);
                float r2_y_17 = r2_xyzw_17.y;
                float r2_z_15 = r2_xyzw_17.z;
                float4 r2_xyzw_18 = (float4(r2_y_17, r2_y_17, r2_z_15, r2_y_17) + float4(0, 0.5, 0.5, 0));
                float r2_y_18 = r2_xyzw_18.y;
                float r2_z_16 = r2_xyzw_18.z;
                float r2_y_19 = (_OcclusionMap.Sample(sampler_OcclusionMap, (float4(r2_y_18, r2_z_16, r2_y_18, r2_y_18)).xy)).y;
                float r2_y_20 = dot(r8_xyzw_4.xyzx, r8_xyzw_4.xyzx);
                float r2_y_21 = (t4.Sample(sampler_linear_clamp3, (r2_y_20.xxxx).xy)).y;
                float r1_w_10 = (r1_w_9 * (r2_y_21 * (r2_y_19 * asfloat(asint((float)((0 < r8_xyzw_4.z))) & asint(1065353216)))));
                float r2_x_20 = dot(i.texcoord2.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_y_22 = dot(i.texcoord3.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_z_17 = dot(i.texcoord4.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_w_10 = dot(float4(r2_x_20, r2_y_22, r2_z_17, r2_x_20), float4(r2_x_20, r2_y_22, r2_z_17, r2_x_20));
                float r2_w_11 = rsqrt(r2_w_10);
                float4 r2_xyzw_21 = (r2_w_11.xxxx * float4(r2_x_20, r2_y_22, r2_z_17, r2_x_20));
                float r2_x_21 = r2_xyzw_21.x;
                float r2_y_23 = r2_xyzw_21.y;
                float r2_z_18 = r2_xyzw_21.z;
                float4 r6_xyzw_4 = (r1_w_10.xxxx * _LightColor0.xyzx);
                float r6_x_4 = r6_xyzw_4.x;
                float r6_y_3 = r6_xyzw_4.y;
                float r6_z_3 = r6_xyzw_4.z;
                float r1_w_11 = max(r7_xyz_1.y, r7_xyz_1.x);
                float r1_w_12 = max(r7_xyz_1.z, r1_w_11);
                float r1_w_13 = (-r1_w_12 + 1);
                float r1_w_14 = mad(-cb0_values[10].x, r5_xyzw_1.w, 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r2_x_21, r2_y_23, r2_z_18, r2_x_21), unitViewDir_xyz_1.xyzx);
                float r2_w_12 = saturate(dot(float4(r2_x_21, r2_y_23, r2_z_18, r2_x_21), r1_xyz_1.xyzx));
                float r2_x_22 = saturate(dot(float4(r2_x_21, r2_y_23, r2_z_18, r2_x_21), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_14.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_12 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_14 * r1_w_14);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(r0_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * mad(r2_w_12, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_12, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r2_x_22, r0_z_9, -r2_x_22), r2_x_22, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_w_12.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r7_xyz_1.xyzx, r7_xyz_1.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r6_x_4, r6_y_3, r6_z_3, r6_x_4));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r6_x_4, r6_x_4, r6_y_3, r6_z_3) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_15 = (r0_x_5 * r0_x_5);
                float r1_w_16 = (r1_w_15 * r1_w_15);
                float4 r2_xyzw_23 = mad(-_SpecColor.xyzx, r5_xyzw_1.xyzx, float4(1, 1, 1, 0));
                float r2_x_23 = r2_xyzw_23.x;
                float r2_y_24 = r2_xyzw_23.y;
                float r2_z_19 = r2_xyzw_23.z;
                float4 r2_xyzw_24 = mad(float4(r2_x_23, r2_y_24, r2_z_19, r2_x_23), ((r0_x_5 * r1_w_16)).xxxx, r7_xyz_1.xyzx);
                float r2_x_24 = r2_xyzw_24.x;
                float r2_y_25 = r2_xyzw_24.y;
                float r2_z_20 = r2_xyzw_24.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_24, r2_y_25, r2_z_20, r2_x_24));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_13.xxxx * ((r4_xyz_1.xyzx * cb0_values[8].xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float r0_w_15 = (i.texcoord8.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8) * r0_w_19.xxxx)).xyz;
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
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
                float4 cb1_values[6];
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
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[7];
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
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float2 texcoord6 : TEXCOORD6;
                float texcoord8 : TEXCOORD8;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program106Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float2 texcoord6 : TEXCOORD6;
                float texcoord8 : TEXCOORD8;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program106Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program60Output vert(program60Input i)
            {
                program60Output o = (program60Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord8.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[12].xxxy, cb0_values[12].zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, cb0_values[13].xyxx, cb0_values[13].zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, cb0_values[14].xxxy, cb0_values[14].zzzw)).zw;
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                float3 unitWorldNormal_xyz_4 = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_7 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_7.xxxx * (mad(unitWorldNormal_xyz_4.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_4.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord2.y = r3_xyz_3.x;
                o.texcoord2.x = unitWorldTangent_xyz_7.z;
                o.texcoord2.z = unitWorldNormal_xyz_4.y;
                o.texcoord3.x = unitWorldTangent_xyz_7.x;
                o.texcoord4.x = unitWorldTangent_xyz_7.y;
                o.texcoord3.z = unitWorldNormal_xyz_4.z;
                o.texcoord4.z = unitWorldNormal_xyz_4.x;
                o.texcoord3.y = r3_xyz_3.y;
                o.texcoord4.y = r3_xyz_3.z;
                o.texcoord5.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float2 clipPos_xy_5 = (mad(_Color.xyxx, worldPos_xyzw_4.xxxx, ((worldPos_xyzw_4.yyyy * _EmissionColor.xyxx)).xyxx)).xy;
                float2 clipPos_xy_6 = (mad(cb0_values[6].xyxx, worldPos_xyzw_4.zzzz, clipPos_xy_5.xyxx)).xy;
                o.texcoord6.xy = (mad(_MainTex_ST.xyxx, worldPos_xyzw_4.wwww, clipPos_xy_6.xyxx)).xy;
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program106Output frag(program106Input i)
            {
                program106Output o = (program106Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord5.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float3 r2_xyz_1 = (_MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy)).xyz;
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord1.xyxx).xy);
                float3 r4_xyz_1 = (_SpecGlossMap.Sample(sampler_SpecGlossMap, (i.texcoord0.zwzz).xy)).xyz;
                float r4_x_2 = (r4_xyz_1.z * r4_xyz_1.x);
                float4 r4_xyzw_3 = mad(float4(r4_x_2, r4_xyz_1.y, r4_x_2, r4_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r4_x_3 = r4_xyzw_3.x;
                float r4_y_2 = r4_xyzw_3.y;
                float r1_w_1 = dot(float4(r4_x_3, r4_y_2, r4_x_3, r4_x_3), float4(r4_x_3, r4_y_2, r4_x_3, r4_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r4_z_2 = sqrt(r1_w_3);
                float3 r5_xyz_1 = ((r3_xyzw_1.xyzx * _SpecColor.xyzx)).xyz;
                float r1_w_4 = (cb4_values[0].x == 1);
                float r7_x_10;
                float r7_y_10;
                float r7_z_10;
                float r7_w_4;
                if (r1_w_4)
                {
                    float r1_w_5 = (cb4_values[0].y == 1);
                    float3 r7_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord5.zzzz, (mad(cb4_values[1].xyzx, i.texcoord5.xxxx, ((i.texcoord5.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r7_xyzw_8 = (((((r1_w_5.xxxx ? r7_xyz_5.xyzx : i.texcoord5.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r7_y_8 = r7_xyzw_8.y;
                    float r7_z_8 = r7_xyzw_8.z;
                    float r7_w_2 = r7_xyzw_8.w;
                    float r1_w_6 = mad(r7_y_8, 0.25, 0.75);
                    float r2_w_1 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r7_x_8 = max(r1_w_6, r2_w_1);
                    float4 r7_xyzw_9 = t4.Sample(sampler_linear_clamp, (float4(r7_x_8, r7_z_8, r7_w_2, r7_x_8)).xyz);
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
                float r1_w_8 = saturate(dot(float4(r7_x_10, r7_y_10, r7_z_10, r7_w_4), unity_OcclusionMaskSelector));
                float r2_w_3 = (_OcclusionMap.Sample(sampler_OcclusionMap, ((((mad(cb0_values[6].xyxx, i.texcoord5.zzzz, (mad(cb0_values[4].xyxx, i.texcoord5.xxxx, ((i.texcoord5.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx).xy)).w;
                float r1_w_9 = (r1_w_8 * r2_w_3);
                float r6_x_5 = dot(i.texcoord2.xyzx, float4(r4_x_3, r4_y_2, r4_z_2, r4_x_3));
                float r6_y_5 = dot(i.texcoord3.xyzx, float4(r4_x_3, r4_y_2, r4_z_2, r4_x_3));
                float r6_z_1 = dot(i.texcoord4.xyzx, float4(r4_x_3, r4_y_2, r4_z_2, r4_x_3));
                float r2_w_4 = dot(float4(r6_x_5, r6_y_5, r6_z_1, r6_x_5), float4(r6_x_5, r6_y_5, r6_z_1, r6_x_5));
                float r2_w_5 = rsqrt(r2_w_4);
                float4 r4_xyzw_4 = (r2_w_5.xxxx * float4(r6_x_5, r6_y_5, r6_z_1, r6_x_5));
                float r4_x_4 = r4_xyzw_4.x;
                float r4_y_3 = r4_xyzw_4.y;
                float r4_z_3 = r4_xyzw_4.z;
                float4 r6_xyzw_6 = (r1_w_9.xxxx * _LightColor0.xyzx);
                float r6_x_6 = r6_xyzw_6.x;
                float r6_y_6 = r6_xyzw_6.y;
                float r6_z_2 = r6_xyzw_6.z;
                float r1_w_10 = max(r5_xyz_1.y, r5_xyz_1.x);
                float r1_w_11 = max(r5_xyz_1.z, r1_w_10);
                float r1_w_12 = (-r1_w_11 + 1);
                float r1_w_13 = mad(-cb0_values[10].x, r3_xyzw_1.w, 1);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r4_x_4, r4_y_3, r4_z_3, r4_x_4), unitViewDir_xyz_1.xyzx);
                float r1_x_2 = saturate(dot(float4(r4_x_4, r4_y_3, r4_z_3, r4_x_4), _WorldSpaceLightPos0.xyzx));
                float r1_y_2 = saturate(dot(float4(r4_x_4, r4_y_3, r4_z_3, r4_x_4), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_13.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(r0_w_6) + 1);
                float r2_w_6 = (r1_z_4 * r1_z_4);
                float r2_w_7 = (r2_w_6 * r2_w_6);
                float r1_z_5 = (r1_z_4 * r2_w_7);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_13 * r1_w_13);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_z_6 = (-r0_z_8 + 1);
                float r1_w_14 = mad(abs(r0_w_6), r1_z_6, r0_z_8);
                float r1_z_7 = mad(r1_x_2, r1_z_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * r1_z_7);
                float r0_w_8 = mad(r1_x_2, r1_w_14, r0_w_7);
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
                float r0_w_11 = dot(r5_xyz_1.xyzx, r5_xyz_1.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_3 = (r0_y_9.xxxx * float4(r6_x_6, r6_y_6, r6_z_2, r6_x_6));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_5 = r1_xyzw_3.y;
                float r1_z_9 = r1_xyzw_3.z;
                float4 r0_xyzw_10 = (float4(r6_x_6, r6_x_6, r6_y_6, r6_z_2) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_15 = (r0_x_5 * r0_x_5);
                float r1_w_16 = (r1_w_15 * r1_w_15);
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * (mad((mad(-_SpecColor.xyzx, r3_xyzw_1.xyzx, float4(1, 1, 1, 0))).xyzx, ((r0_x_5 * r1_w_16)).xxxx, r5_xyz_1.xyzx)).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_12.xxxx * ((r2_xyz_1.xyzx * cb0_values[8].xyzx)).xyzx)).xyzx, float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float r0_w_15 = (i.texcoord8.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w));
                o.sv_Target0.xyz = ((float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8) * r0_w_19.xxxx)).xyz;
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
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
                float4 cb1_values[6];
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
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_MainTex;
            SamplerState sampler_SpecGlossMap;
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _SpecGlossMap;
            Texture2D _OcclusionMap;
            TextureCube t4;
            Texture3D t5;
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
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float texcoord8 : TEXCOORD8;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program105Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float texcoord8 : TEXCOORD8;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program105Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program59Output vert(program59Input i)
            {
                program59Output o = (program59Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord8.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[12].xxxy, cb0_values[12].zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, cb0_values[13].xyxx, cb0_values[13].zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, cb0_values[14].xxxy, cb0_values[14].zzzw)).zw;
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                float3 unitWorldNormal_xyz_4 = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_7 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_7.xxxx * (mad(unitWorldNormal_xyz_4.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_4.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord2.y = r3_xyz_3.x;
                o.texcoord2.x = unitWorldTangent_xyz_7.z;
                o.texcoord2.z = unitWorldNormal_xyz_4.y;
                o.texcoord3.x = unitWorldTangent_xyz_7.x;
                o.texcoord4.x = unitWorldTangent_xyz_7.y;
                o.texcoord3.z = unitWorldNormal_xyz_4.z;
                o.texcoord4.z = unitWorldNormal_xyz_4.x;
                o.texcoord3.y = r3_xyz_3.y;
                o.texcoord4.y = r3_xyz_3.z;
                o.texcoord5.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_6 = (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, ((worldPos_xyzw_4.yyyy * _EmissionColor.xyzx)).xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(cb0_values[6].xyzx, worldPos_xyzw_4.zzzz, clipPos_xyz_6.xyzx)).xyz;
                o.texcoord6.xyz = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program105Output frag(program105Input i)
            {
                program105Output o = (program105Output)0;
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
                float r1_w_6 = (cb4_values[0].x == 1);
                float r8_x_10;
                float r8_y_10;
                float r8_z_10;
                float r8_w_4;
                if (r1_w_6)
                {
                    float r1_w_7 = (cb4_values[0].y == 1);
                    float3 r8_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord5.zzzz, (mad(cb4_values[1].xyzx, i.texcoord5.xxxx, ((i.texcoord5.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r8_xyzw_8 = (((((r1_w_7.xxxx ? r8_xyz_5.xyzx : i.texcoord5.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r8_y_8 = r8_xyzw_8.y;
                    float r8_z_8 = r8_xyzw_8.z;
                    float r8_w_2 = r8_xyzw_8.w;
                    float r1_w_8 = mad(r8_y_8, 0.25, 0.75);
                    float r2_w_1 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r8_x_8 = max(r1_w_8, r2_w_1);
                    float4 r8_xyzw_9 = t5.Sample(sampler_linear_clamp, (float4(r8_x_8, r8_z_8, r8_w_2, r8_x_8)).xyz);
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
                float r3_w_1 = (t4.Sample(sampler_linear_clamp1, r7_xyz_4.xyz)).w;
                float r2_w_5 = (r2_w_4 * r3_w_1);
                float r1_w_11 = (r1_w_10 * r2_w_5);
                float r7_x_5 = dot(i.texcoord2.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float r7_y_5 = dot(i.texcoord3.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float r7_z_5 = dot(i.texcoord4.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float r2_w_6 = dot(float4(r7_x_5, r7_y_5, r7_z_5, r7_x_5), float4(r7_x_5, r7_y_5, r7_z_5, r7_x_5));
                float r2_w_7 = rsqrt(r2_w_6);
                float4 r5_xyzw_4 = (r2_w_7.xxxx * float4(r7_x_5, r7_y_5, r7_z_5, r7_x_5));
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
                float4 r0_xyzw_8 = mad(((r1_w_14.xxxx * ((r3_xyz_1.xyzx * cb0_values[8].xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float r0_w_15 = (i.texcoord8.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w));
                o.sv_Target0.xyz = ((float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8) * r0_w_19.xxxx)).xyz;
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
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
                float4 cb1_values[6];
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
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            SamplerState sampler_SpecGlossMap;
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _SpecGlossMap;
            Texture2D _OcclusionMap;
            Texture2D t4;
            Texture3D t5;
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
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float texcoord8 : TEXCOORD8;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program104Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float texcoord8 : TEXCOORD8;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program104Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program58Output vert(program58Input i)
            {
                program58Output o = (program58Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * unity_MatrixVP[1])));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord8.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[12].xxxy, cb0_values[12].zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, cb0_values[13].xyxx, cb0_values[13].zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, cb0_values[14].xxxy, cb0_values[14].zzzw)).zw;
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                float3 unitWorldNormal_xyz_4 = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_7 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_7.xxxx * (mad(unitWorldNormal_xyz_4.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_4.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord2.y = r3_xyz_3.x;
                o.texcoord2.x = unitWorldTangent_xyz_7.z;
                o.texcoord2.z = unitWorldNormal_xyz_4.y;
                o.texcoord3.x = unitWorldTangent_xyz_7.x;
                o.texcoord4.x = unitWorldTangent_xyz_7.y;
                o.texcoord3.z = unitWorldNormal_xyz_4.z;
                o.texcoord4.z = unitWorldNormal_xyz_4.x;
                o.texcoord3.y = r3_xyz_3.y;
                o.texcoord4.y = r3_xyz_3.z;
                o.texcoord5.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float4 clipPos_xyzw_5 = (worldPos_xyzw_4.yyyy * _EmissionColor);
                float4 clipPos_xyzw_6 = mad(_Color, worldPos_xyzw_4.xxxx, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb0_values[6].xyzw, worldPos_xyzw_4.zzzz, clipPos_xyzw_6);
                o.texcoord6.xyzw = mad(_MainTex_ST, worldPos_xyzw_4.wwww, clipPos_xyzw_7);
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program104Output frag(program104Input i)
            {
                program104Output o = (program104Output)0;
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
                float4 r7_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord5.zzzz, mad(cb0_values[4].xyzw, i.texcoord5.xxxx, (i.texcoord5.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r1_w_6 = (cb4_values[0].x == 1);
                float r8_x_10;
                float r8_y_10;
                float r8_z_10;
                float r8_w_4;
                if (r1_w_6)
                {
                    float r1_w_7 = (cb4_values[0].y == 1);
                    float3 r8_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord5.zzzz, (mad(cb4_values[1].xyzx, i.texcoord5.xxxx, ((i.texcoord5.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r8_xyzw_8 = (((((r1_w_7.xxxx ? r8_xyz_5.xyzx : i.texcoord5.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r8_y_8 = r8_xyzw_8.y;
                    float r8_z_8 = r8_xyzw_8.z;
                    float r8_w_2 = r8_xyzw_8.w;
                    float r1_w_8 = mad(r8_y_8, 0.25, 0.75);
                    float r2_w_1 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r8_x_8 = max(r1_w_8, r2_w_1);
                    float4 r8_xyzw_9 = t5.Sample(sampler_linear_clamp, (float4(r8_x_8, r8_z_8, r8_w_2, r8_x_8)).xyz);
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
                float r2_w_3 = (0 < r7_xyzw_4.z);
                float r2_w_4 = asfloat(asint(r2_w_3) & asint(1065353216));
                float r3_w_1 = (_OcclusionMap.Sample(sampler_OcclusionMap, (((((r7_xyzw_4.xyxx / r7_xyzw_4.wwww)).xyxx + float4(0.5, 0.5, 0, 0))).xyxx).xy)).w;
                float r2_w_5 = (r2_w_4 * r3_w_1);
                float r3_w_2 = dot(r7_xyzw_4.xyzx, r7_xyzw_4.xyzx);
                float r3_w_3 = (t4.Sample(sampler_linear_clamp2, (r3_w_2.xxxx).xy)).w;
                float r2_w_6 = (r2_w_5 * r3_w_3);
                float r1_w_11 = (r1_w_10 * r2_w_6);
                float r7_x_5 = dot(i.texcoord2.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float r7_y_5 = dot(i.texcoord3.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float r7_z_5 = dot(i.texcoord4.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float r2_w_7 = dot(float4(r7_x_5, r7_y_5, r7_z_5, r7_x_5), float4(r7_x_5, r7_y_5, r7_z_5, r7_x_5));
                float r2_w_8 = rsqrt(r2_w_7);
                float4 r5_xyzw_4 = (r2_w_8.xxxx * float4(r7_x_5, r7_y_5, r7_z_5, r7_x_5));
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
                float4 r0_xyzw_8 = mad(((r1_w_14.xxxx * ((r3_xyz_1.xyzx * cb0_values[8].xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float r0_w_15 = (i.texcoord8.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w));
                o.sv_Target0.xyz = ((float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8) * r0_w_19.xxxx)).xyz;
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
                float4 cb0_values[7];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
                float4 cb1_values[6];
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
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[7];
            };
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_MainTex;
            SamplerState sampler_SpecGlossMap;
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _SpecGlossMap;
            Texture3D _OcclusionMap;
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
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float texcoord8 : TEXCOORD8;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program103Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float texcoord8 : TEXCOORD8;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program103Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program57Output vert(program57Input i)
            {
                program57Output o = (program57Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord5.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord8.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _SpecGlossMap_ST.xyxx, _SpecGlossMap_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _OcclusionMap_ST.xxxy, _OcclusionMap_ST.zzzw)).zw;
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                float3 unitWorldNormal_xyz_9 = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                float3 worldTangent_xyz_2 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_3 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_2.xyzx)).xyz;
                float3 worldTangent_xyz_4 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_3.xyzx)).xyz;
                float3 unitWorldTangent_xyz_5 = normalize(worldTangent_xyz_4);
                float r0_w_12 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r2_xyz_3 = ((r0_w_12.xxxx * (mad(unitWorldNormal_xyz_9.zxyz, unitWorldTangent_xyz_5.yzxy, ((unitWorldNormal_xyz_9.xyzx * unitWorldTangent_xyz_5.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord2.y = r2_xyz_3.x;
                o.texcoord2.x = unitWorldTangent_xyz_5.z;
                o.texcoord2.z = unitWorldNormal_xyz_9.y;
                o.texcoord3.x = unitWorldTangent_xyz_5.x;
                o.texcoord4.x = unitWorldTangent_xyz_5.y;
                o.texcoord3.z = unitWorldNormal_xyz_9.z;
                o.texcoord4.z = unitWorldNormal_xyz_9.x;
                o.texcoord3.y = r2_xyz_3.y;
                o.texcoord4.y = r2_xyz_3.z;
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program103Output frag(program103Input i)
            {
                program103Output o = (program103Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord5.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float3 r2_xyz_1 = (_MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy)).xyz;
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord1.xyxx).xy);
                float3 r4_xyz_1 = (_SpecGlossMap.Sample(sampler_SpecGlossMap, (i.texcoord0.zwzz).xy)).xyz;
                float r4_x_2 = (r4_xyz_1.z * r4_xyz_1.x);
                float4 r4_xyzw_3 = mad(float4(r4_x_2, r4_xyz_1.y, r4_x_2, r4_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r4_x_3 = r4_xyzw_3.x;
                float r4_y_2 = r4_xyzw_3.y;
                float r1_w_1 = dot(float4(r4_x_3, r4_y_2, r4_x_3, r4_x_3), float4(r4_x_3, r4_y_2, r4_x_3, r4_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r4_z_2 = sqrt(r1_w_3);
                float3 r5_xyz_1 = ((r3_xyzw_1.xyzx * _SpecColor.xyzx)).xyz;
                float r1_w_4 = (cb4_values[0].x == 1);
                float r6_x_10;
                float r6_y_10;
                float r6_z_10;
                float r6_w_4;
                if (r1_w_4)
                {
                    float r1_w_5 = (cb4_values[0].y == 1);
                    float3 r6_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord5.zzzz, (mad(cb4_values[1].xyzx, i.texcoord5.xxxx, ((i.texcoord5.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r6_xyzw_8 = (((((r1_w_5.xxxx ? r6_xyz_5.xyzx : i.texcoord5.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r6_y_8 = r6_xyzw_8.y;
                    float r6_z_8 = r6_xyzw_8.z;
                    float r6_w_2 = r6_xyzw_8.w;
                    float r1_w_6 = mad(r6_y_8, 0.25, 0.75);
                    float r2_w_1 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r6_x_8 = max(r1_w_6, r2_w_1);
                    float4 r6_xyzw_9 = _OcclusionMap.Sample(sampler_OcclusionMap, (float4(r6_x_8, r6_z_8, r6_w_2, r6_x_8)).xyz);
                    r6_x_10 = r6_xyzw_9.x;
                    r6_y_10 = r6_xyzw_9.y;
                    r6_z_10 = r6_xyzw_9.z;
                    r6_w_4 = r6_xyzw_9.w;
                }
                else
                {
                    float4 r6_xyzw_10 = float4(1, 1, 1, 1);
                    r6_x_10 = r6_xyzw_10.x;
                    r6_y_10 = r6_xyzw_10.y;
                    r6_z_10 = r6_xyzw_10.z;
                    r6_w_4 = r6_xyzw_10.w;
                }
                float r1_w_8 = saturate(dot(float4(r6_x_10, r6_y_10, r6_z_10, r6_w_4), unity_OcclusionMaskSelector));
                float r6_x_11 = dot(i.texcoord2.xyzx, float4(r4_x_3, r4_y_2, r4_z_2, r4_x_3));
                float r6_y_11 = dot(i.texcoord3.xyzx, float4(r4_x_3, r4_y_2, r4_z_2, r4_x_3));
                float r6_z_11 = dot(i.texcoord4.xyzx, float4(r4_x_3, r4_y_2, r4_z_2, r4_x_3));
                float r2_w_3 = dot(float4(r6_x_11, r6_y_11, r6_z_11, r6_x_11), float4(r6_x_11, r6_y_11, r6_z_11, r6_x_11));
                float r2_w_4 = rsqrt(r2_w_3);
                float4 r4_xyzw_4 = (r2_w_4.xxxx * float4(r6_x_11, r6_y_11, r6_z_11, r6_x_11));
                float r4_x_4 = r4_xyzw_4.x;
                float r4_y_3 = r4_xyzw_4.y;
                float r4_z_3 = r4_xyzw_4.z;
                float3 r6_xyz_12 = ((r1_w_8.xxxx * _LightColor0.xyzx)).xyz;
                float r1_w_9 = max(r5_xyz_1.y, r5_xyz_1.x);
                float r1_w_10 = max(r5_xyz_1.z, r1_w_9);
                float r1_w_11 = (-r1_w_10 + 1);
                float r1_w_12 = mad(-cb0_values[6].x, r3_xyzw_1.w, 1);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r4_x_4, r4_y_3, r4_z_3, r4_x_4), unitViewDir_xyz_1.xyzx);
                float r1_x_2 = saturate(dot(float4(r4_x_4, r4_y_3, r4_z_3, r4_x_4), _WorldSpaceLightPos0.xyzx));
                float r1_y_2 = saturate(dot(float4(r4_x_4, r4_y_3, r4_z_3, r4_x_4), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_12.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(r0_w_6) + 1);
                float r2_w_5 = (r1_z_4 * r1_z_4);
                float r2_w_6 = (r2_w_5 * r2_w_5);
                float r1_z_5 = (r1_z_4 * r2_w_6);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_12 * r1_w_12);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_z_6 = (-r0_z_8 + 1);
                float r1_w_13 = mad(abs(r0_w_6), r1_z_6, r0_z_8);
                float r1_z_7 = mad(r1_x_2, r1_z_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * r1_z_7);
                float r0_w_8 = mad(r1_x_2, r1_w_13, r0_w_7);
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
                float r0_w_11 = dot(r5_xyz_1.xyzx, r5_xyz_1.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_3 = (r0_y_9.xxxx * r6_xyz_12.xyzx);
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_5 = r1_xyzw_3.y;
                float r1_z_9 = r1_xyzw_3.z;
                float4 r0_xyzw_10 = (r6_xyz_12.xxyz * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_14 = (r0_x_5 * r0_x_5);
                float r1_w_15 = (r1_w_14 * r1_w_14);
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * (mad((mad(-_SpecColor.xyzx, r3_xyzw_1.xyzx, float4(1, 1, 1, 0))).xyzx, ((r0_x_5 * r1_w_15)).xxxx, r5_xyz_1.xyzx)).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_11.xxxx * ((r2_xyz_1.xyzx * cb0_values[4].xyzx)).xyzx)).xyzx, float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float r0_w_15 = (i.texcoord8.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w));
                o.sv_Target0.xyz = ((float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8) * r0_w_19.xxxx)).xyz;
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
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
                float4 cb1_values[6];
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
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[7];
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
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float texcoord8 : TEXCOORD8;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program102Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float texcoord8 : TEXCOORD8;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program102Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program56Output vert(program56Input i)
            {
                program56Output o = (program56Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord8.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[12].xxxy, cb0_values[12].zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, cb0_values[13].xyxx, cb0_values[13].zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, cb0_values[14].xxxy, cb0_values[14].zzzw)).zw;
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                float3 unitWorldNormal_xyz_4 = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_7 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_7.xxxx * (mad(unitWorldNormal_xyz_4.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_4.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord2.y = r3_xyz_3.x;
                o.texcoord2.x = unitWorldTangent_xyz_7.z;
                o.texcoord2.z = unitWorldNormal_xyz_4.y;
                o.texcoord3.x = unitWorldTangent_xyz_7.x;
                o.texcoord4.x = unitWorldTangent_xyz_7.y;
                o.texcoord3.z = unitWorldNormal_xyz_4.z;
                o.texcoord4.z = unitWorldNormal_xyz_4.x;
                o.texcoord3.y = r3_xyz_3.y;
                o.texcoord4.y = r3_xyz_3.z;
                o.texcoord5.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_6 = (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, ((worldPos_xyzw_4.yyyy * _EmissionColor.xyzx)).xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(cb0_values[6].xyzx, worldPos_xyzw_4.zzzz, clipPos_xyz_6.xyzx)).xyz;
                o.texcoord6.xyz = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program102Output frag(program102Input i)
            {
                program102Output o = (program102Output)0;
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
                float r1_w_6 = (cb4_values[0].x == 1);
                float r8_x_10;
                float r8_y_10;
                float r8_z_10;
                float r8_w_4;
                if (r1_w_6)
                {
                    float r1_w_7 = (cb4_values[0].y == 1);
                    float3 r8_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord5.zzzz, (mad(cb4_values[1].xyzx, i.texcoord5.xxxx, ((i.texcoord5.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r8_xyzw_8 = (((((r1_w_7.xxxx ? r8_xyz_5.xyzx : i.texcoord5.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r8_y_8 = r8_xyzw_8.y;
                    float r8_z_8 = r8_xyzw_8.z;
                    float r8_w_2 = r8_xyzw_8.w;
                    float r1_w_8 = mad(r8_y_8, 0.25, 0.75);
                    float r2_w_1 = mad(cb4_values[0].z, 0.5, 0.75);
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
                float4 r0_xyzw_8 = mad(((r1_w_14.xxxx * ((r3_xyz_1.xyzx * cb0_values[8].xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float r0_w_15 = (i.texcoord8.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w));
                o.sv_Target0.xyz = ((float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8) * r0_w_19.xxxx)).xyz;
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
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_MainTex;
            SamplerState sampler_SpecGlossMap;
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _SpecGlossMap;
            Texture2D _OcclusionMap;
            TextureCube t4;
            Texture3D t5;
            TextureCube t6;
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
            struct program101Input
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
            struct program101Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program55Output vert(program55Input i)
            {
                program55Output o = (program55Output)0;
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
            program101Output frag(program101Input i)
            {
                program101Output o = (program101Output)0;
                float3 r0_xyz_1 = ((-i.texcoord5.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord5.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float3 r4_xyz_1 = (_MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy)).xyz;
                float4 r5_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord1.xyxx).xy);
                float3 r6_xyz_1 = (_SpecGlossMap.Sample(sampler_SpecGlossMap, (i.texcoord0.zwzz).xy)).xyz;
                float r6_x_2 = (r6_xyz_1.z * r6_xyz_1.x);
                float4 r6_xyzw_3 = mad(float4(r6_x_2, r6_xyz_1.y, r6_x_2, r6_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r6_x_3 = r6_xyzw_3.x;
                float r6_y_2 = r6_xyzw_3.y;
                float r1_w_3 = dot(float4(r6_x_3, r6_y_2, r6_x_3, r6_x_3), float4(r6_x_3, r6_y_2, r6_x_3, r6_x_3));
                float r1_w_4 = min(r1_w_3, 1);
                float r1_w_5 = (-r1_w_4 + 1);
                float r6_z_2 = sqrt(r1_w_5);
                float3 r7_xyz_1 = ((r5_xyzw_1.xyzx * _SpecColor.xyzx)).xyz;
                float3 r8_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord5.zzzz, (mad(cb0_values[4].xyzx, i.texcoord5.xxxx, ((i.texcoord5.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r9_x_1 = cb4_values[9].z;
                float r9_y_1 = cb4_values[10].z;
                float r9_z_1 = cb4_values[11].z;
                float r1_w_6 = dot(viewDir_xyz_1.xyzx, float4(r9_x_1, r9_y_1, r9_z_1, r9_x_1));
                float3 r2_xyz_2 = ((i.texcoord5.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_7 = mad(cb3_values[25].w, (-r1_w_6 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_6);
                float r1_w_8 = saturate(mad(r1_w_7, cb3_values[24].z, cb3_values[24].w));
                float r2_x_13;
                float r2_y_13;
                float r2_z_12;
                float r2_w_8;
                if ((cb5_values[0].x == 1))
                {
                    float4 r2_xyzw_4 = (i.texcoord5.yyyy * cb5_values[2].xxyz);
                    float r2_y_4 = r2_xyzw_4.y;
                    float r2_z_4 = r2_xyzw_4.z;
                    float r2_w_2 = r2_xyzw_4.w;
                    float4 r2_xyzw_5 = mad(cb5_values[1].xxyz, i.texcoord5.xxxx, float4(r2_y_4, r2_y_4, r2_z_4, r2_w_2));
                    float r2_y_5 = r2_xyzw_5.y;
                    float r2_z_5 = r2_xyzw_5.z;
                    float r2_w_3 = r2_xyzw_5.w;
                    float4 r2_xyzw_6 = mad(cb5_values[3].xxyz, i.texcoord5.zzzz, float4(r2_y_5, r2_y_5, r2_z_5, r2_w_3));
                    float r2_y_6 = r2_xyzw_6.y;
                    float r2_z_6 = r2_xyzw_6.z;
                    float r2_w_4 = r2_xyzw_6.w;
                    float4 r2_xyzw_7 = (float4(r2_y_6, r2_y_6, r2_z_6, r2_w_4) + cb5_values[4].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_5 = r2_xyzw_7.w;
                    float4 r2_xyzw_9 = (((cb5_values[0].y == 1)).xxxx ? float4(r2_y_7, r2_z_7, r2_w_5, r2_y_7) : i.texcoord5.xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_8 = r2_xyzw_9.y;
                    float r2_z_8 = r2_xyzw_9.z;
                    float4 r2_xyzw_10 = (float4(r2_x_9, r2_y_8, r2_z_8, r2_x_9) + -cb5_values[6].xyzx);
                    float r2_x_10 = r2_xyzw_10.x;
                    float r2_y_9 = r2_xyzw_10.y;
                    float r2_z_9 = r2_xyzw_10.z;
                    float r2_y_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).y;
                    float r2_z_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).z;
                    float r2_w_6 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).w;
                    float r2_y_11 = mad(r2_y_10, 0.25, 0.75);
                    float r3_w_1 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r2_x_11 = max(r2_y_11, r3_w_1);
                    float4 r2_xyzw_12 = t5.Sample(sampler_linear_clamp, (float4(r2_x_11, r2_z_10, r2_w_6, r2_x_11)).xyz);
                    r2_x_13 = r2_xyzw_12.x;
                    r2_y_13 = r2_xyzw_12.y;
                    r2_z_12 = r2_xyzw_12.z;
                    r2_w_8 = r2_xyzw_12.w;
                }
                else
                {
                    float r2_x_7 = (float4(1, 1, 1, 1)).x;
                    float4 r2_xyzw_3 = float4(1, 1, 1, 1);
                    float r2_y_3 = r2_xyzw_3.y;
                    float r2_z_3 = r2_xyzw_3.z;
                    float r2_w_1 = r2_xyzw_3.w;
                    r2_x_13 = r2_x_7;
                    r2_y_13 = r2_y_3;
                    r2_z_12 = r2_z_3;
                    r2_w_8 = r2_w_1;
                }
                float r2_y_14 = (r1_w_8 < 0.99);
                float r2_y_20;
                if (r2_y_14)
                {
                    float4 r2_xyzw_16 = (i.texcoord5.xxyz + -cb2_values[1].xxyz);
                    float r2_y_16 = r2_xyzw_16.y;
                    float r2_z_13 = r2_xyzw_16.z;
                    float r2_w_9 = r2_xyzw_16.w;
                    float r3_w_3 = max(abs(r2_z_13), abs(r2_y_16));
                    float r3_w_4 = max(abs(r2_w_9), r3_w_3);
                    float r3_w_5 = (r3_w_4 + -cb2_values[2].z);
                    float r3_w_6 = max(r3_w_5, 1E-05);
                    float r3_w_7 = (r3_w_6 * cb2_values[2].w);
                    float r3_w_8 = (cb2_values[2].y / r3_w_7);
                    float r3_w_9 = (r3_w_8 + -cb2_values[2].x);
                    float r3_w_10 = (-r3_w_9 + 1);
                    float r9_x_3 = t6.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((float4(r2_y_16, r2_z_13, r2_w_9, r2_y_16) + float4(0.0078125, 0.0078125, 0.0078125, 0))).xyzx).xyz, r3_w_10);
                    float r9_y_3 = t6.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((float4(r2_y_16, r2_z_13, r2_w_9, r2_y_16) + float4(-0.0078125, -0.0078125, 0.0078125, 0))).xyzx).xyz, r3_w_10);
                    float r9_z_3 = t6.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((float4(r2_y_16, r2_z_13, r2_w_9, r2_y_16) + float4(-0.0078125, 0.0078125, -0.0078125, 0))).xyzx).xyz, r3_w_10);
                    float4 r2_xyzw_17 = (float4(r2_y_16, r2_y_16, r2_z_13, r2_w_9) + float4(0, 0.0078125, -0.0078125, -0.0078125));
                    float r2_y_17 = r2_xyzw_17.y;
                    float r2_z_14 = r2_xyzw_17.z;
                    float r2_w_10 = r2_xyzw_17.w;
                    float r9_w_1 = t6.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r2_y_17, r2_z_14, r2_w_10, r2_y_17)).xyz, r3_w_10);
                    float r2_y_18 = dot(float4(r9_x_3, r9_y_3, r9_z_3, r9_w_1), float4(0.25, 0.25, 0.25, 0.25));
                    float r2_z_15 = (-cb3_values[24].x + 1);
                    float r2_y_19 = mad(r2_y_18, r2_z_15, cb3_values[24].x);
                    r2_y_20 = r2_y_19;
                }
                else
                {
                    float r2_y_15 = 1;
                    r2_y_20 = r2_y_15;
                }
                float r1_w_9 = mad(r1_w_8, (-r2_y_20 + saturate(dot(float4(r2_x_13, r2_y_13, r2_z_12, r2_w_8), unity_OcclusionMaskSelector))), r2_y_20);
                float r2_x_17 = (_OcclusionMap.Sample(sampler_OcclusionMap, ((dot(r8_xyz_4.xyzx, r8_xyz_4.xyzx)).xxxx).xy)).x;
                float r2_y_21 = (t4.Sample(sampler_linear_clamp2, r8_xyz_4.xyz)).y;
                float r1_w_10 = (r1_w_9 * (r2_y_21 * r2_x_17));
                float r2_x_19 = dot(i.texcoord2.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_y_22 = dot(i.texcoord3.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_z_17 = dot(i.texcoord4.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_w_12 = dot(float4(r2_x_19, r2_y_22, r2_z_17, r2_x_19), float4(r2_x_19, r2_y_22, r2_z_17, r2_x_19));
                float r2_w_13 = rsqrt(r2_w_12);
                float4 r2_xyzw_20 = (r2_w_13.xxxx * float4(r2_x_19, r2_y_22, r2_z_17, r2_x_19));
                float r2_x_20 = r2_xyzw_20.x;
                float r2_y_23 = r2_xyzw_20.y;
                float r2_z_18 = r2_xyzw_20.z;
                float4 r6_xyzw_4 = (r1_w_10.xxxx * _LightColor0.xyzx);
                float r6_x_4 = r6_xyzw_4.x;
                float r6_y_3 = r6_xyzw_4.y;
                float r6_z_3 = r6_xyzw_4.z;
                float r1_w_11 = max(r7_xyz_1.y, r7_xyz_1.x);
                float r1_w_12 = max(r7_xyz_1.z, r1_w_11);
                float r1_w_13 = (-r1_w_12 + 1);
                float r1_w_14 = mad(-cb0_values[10].x, r5_xyzw_1.w, 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r2_x_20, r2_y_23, r2_z_18, r2_x_20), unitViewDir_xyz_1.xyzx);
                float r2_w_14 = saturate(dot(float4(r2_x_20, r2_y_23, r2_z_18, r2_x_20), r1_xyz_1.xyzx));
                float r2_x_21 = saturate(dot(float4(r2_x_20, r2_y_23, r2_z_18, r2_x_20), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_14.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_14 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_14 * r1_w_14);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(r0_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * mad(r2_w_14, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_14, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r2_x_21, r0_z_9, -r2_x_21), r2_x_21, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_w_14.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r7_xyz_1.xyzx, r7_xyz_1.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r6_x_4, r6_y_3, r6_z_3, r6_x_4));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r6_x_4, r6_x_4, r6_y_3, r6_z_3) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_15 = (r0_x_5 * r0_x_5);
                float r1_w_16 = (r1_w_15 * r1_w_15);
                float4 r2_xyzw_22 = mad(-_SpecColor.xyzx, r5_xyzw_1.xyzx, float4(1, 1, 1, 0));
                float r2_x_22 = r2_xyzw_22.x;
                float r2_y_24 = r2_xyzw_22.y;
                float r2_z_19 = r2_xyzw_22.z;
                float4 r2_xyzw_23 = mad(float4(r2_x_22, r2_y_24, r2_z_19, r2_x_22), ((r0_x_5 * r1_w_16)).xxxx, r7_xyz_1.xyzx);
                float r2_x_23 = r2_xyzw_23.x;
                float r2_y_25 = r2_xyzw_23.y;
                float r2_z_20 = r2_xyzw_23.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_23, r2_y_25, r2_z_20, r2_x_23));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(((r1_w_13.xxxx * ((r4_xyz_1.xyzx * cb0_values[8].xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7))).xyz;
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
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_MainTex;
            SamplerState sampler_SpecGlossMap;
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _SpecGlossMap;
            Texture2D _OcclusionMap;
            TextureCube t4;
            Texture3D t5;
            TextureCube t6;
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
            struct program100Input
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
            struct program100Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program54Output vert(program54Input i)
            {
                program54Output o = (program54Output)0;
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
            program100Output frag(program100Input i)
            {
                program100Output o = (program100Output)0;
                float3 r0_xyz_1 = ((-i.texcoord5.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord5.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float3 r4_xyz_1 = (_MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy)).xyz;
                float4 r5_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord1.xyxx).xy);
                float3 r6_xyz_1 = (_SpecGlossMap.Sample(sampler_SpecGlossMap, (i.texcoord0.zwzz).xy)).xyz;
                float r6_x_2 = (r6_xyz_1.z * r6_xyz_1.x);
                float4 r6_xyzw_3 = mad(float4(r6_x_2, r6_xyz_1.y, r6_x_2, r6_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r6_x_3 = r6_xyzw_3.x;
                float r6_y_2 = r6_xyzw_3.y;
                float r1_w_3 = dot(float4(r6_x_3, r6_y_2, r6_x_3, r6_x_3), float4(r6_x_3, r6_y_2, r6_x_3, r6_x_3));
                float r1_w_4 = min(r1_w_3, 1);
                float r1_w_5 = (-r1_w_4 + 1);
                float r6_z_2 = sqrt(r1_w_5);
                float3 r7_xyz_1 = ((r5_xyzw_1.xyzx * _SpecColor.xyzx)).xyz;
                float3 r8_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord5.zzzz, (mad(cb0_values[4].xyzx, i.texcoord5.xxxx, ((i.texcoord5.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r9_x_1 = cb4_values[9].z;
                float r9_y_1 = cb4_values[10].z;
                float r9_z_1 = cb4_values[11].z;
                float r1_w_6 = dot(viewDir_xyz_1.xyzx, float4(r9_x_1, r9_y_1, r9_z_1, r9_x_1));
                float3 r2_xyz_2 = ((i.texcoord5.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_7 = mad(cb3_values[25].w, (-r1_w_6 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_6);
                float r1_w_8 = saturate(mad(r1_w_7, cb3_values[24].z, cb3_values[24].w));
                float r2_x_13;
                float r2_y_13;
                float r2_z_12;
                float r2_w_8;
                if ((cb5_values[0].x == 1))
                {
                    float4 r2_xyzw_4 = (i.texcoord5.yyyy * cb5_values[2].xxyz);
                    float r2_y_4 = r2_xyzw_4.y;
                    float r2_z_4 = r2_xyzw_4.z;
                    float r2_w_2 = r2_xyzw_4.w;
                    float4 r2_xyzw_5 = mad(cb5_values[1].xxyz, i.texcoord5.xxxx, float4(r2_y_4, r2_y_4, r2_z_4, r2_w_2));
                    float r2_y_5 = r2_xyzw_5.y;
                    float r2_z_5 = r2_xyzw_5.z;
                    float r2_w_3 = r2_xyzw_5.w;
                    float4 r2_xyzw_6 = mad(cb5_values[3].xxyz, i.texcoord5.zzzz, float4(r2_y_5, r2_y_5, r2_z_5, r2_w_3));
                    float r2_y_6 = r2_xyzw_6.y;
                    float r2_z_6 = r2_xyzw_6.z;
                    float r2_w_4 = r2_xyzw_6.w;
                    float4 r2_xyzw_7 = (float4(r2_y_6, r2_y_6, r2_z_6, r2_w_4) + cb5_values[4].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_5 = r2_xyzw_7.w;
                    float4 r2_xyzw_9 = (((cb5_values[0].y == 1)).xxxx ? float4(r2_y_7, r2_z_7, r2_w_5, r2_y_7) : i.texcoord5.xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_8 = r2_xyzw_9.y;
                    float r2_z_8 = r2_xyzw_9.z;
                    float4 r2_xyzw_10 = (float4(r2_x_9, r2_y_8, r2_z_8, r2_x_9) + -cb5_values[6].xyzx);
                    float r2_x_10 = r2_xyzw_10.x;
                    float r2_y_9 = r2_xyzw_10.y;
                    float r2_z_9 = r2_xyzw_10.z;
                    float r2_y_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).y;
                    float r2_z_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).z;
                    float r2_w_6 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).w;
                    float r2_y_11 = mad(r2_y_10, 0.25, 0.75);
                    float r3_w_1 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r2_x_11 = max(r2_y_11, r3_w_1);
                    float4 r2_xyzw_12 = t5.Sample(sampler_linear_clamp, (float4(r2_x_11, r2_z_10, r2_w_6, r2_x_11)).xyz);
                    r2_x_13 = r2_xyzw_12.x;
                    r2_y_13 = r2_xyzw_12.y;
                    r2_z_12 = r2_xyzw_12.z;
                    r2_w_8 = r2_xyzw_12.w;
                }
                else
                {
                    float r2_x_7 = (float4(1, 1, 1, 1)).x;
                    float4 r2_xyzw_3 = float4(1, 1, 1, 1);
                    float r2_y_3 = r2_xyzw_3.y;
                    float r2_z_3 = r2_xyzw_3.z;
                    float r2_w_1 = r2_xyzw_3.w;
                    r2_x_13 = r2_x_7;
                    r2_y_13 = r2_y_3;
                    r2_z_12 = r2_z_3;
                    r2_w_8 = r2_w_1;
                }
                float4 r2_xyzw_14 = (i.texcoord5.xxyz + -cb2_values[1].xxyz);
                float r2_y_14 = r2_xyzw_14.y;
                float r2_z_13 = r2_xyzw_14.z;
                float r2_w_9 = r2_xyzw_14.w;
                float r3_w_3 = max(abs(r2_z_13), abs(r2_y_14));
                float r3_w_4 = max(abs(r2_w_9), r3_w_3);
                float r3_w_5 = (r3_w_4 + -cb2_values[2].z);
                float r3_w_6 = max(r3_w_5, 1E-05);
                float r3_w_7 = (r3_w_6 * cb2_values[2].w);
                float r3_w_8 = (cb2_values[2].y / r3_w_7);
                float r3_w_9 = (r3_w_8 + -cb2_values[2].x);
                float r3_w_10 = (-r3_w_9 + 1);
                float r2_y_15 = t6.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r2_y_14, r2_z_13, r2_w_9, r2_y_14)).xyz, r3_w_10);
                float r2_z_14 = (-cb3_values[24].x + 1);
                float r2_y_16 = mad(r2_y_15, r2_z_14, cb3_values[24].x);
                float r1_w_9 = mad(r1_w_8, (-r2_y_16 + saturate(dot(float4(r2_x_13, r2_y_13, r2_z_12, r2_w_8), unity_OcclusionMaskSelector))), r2_y_16);
                float r2_x_17 = (_OcclusionMap.Sample(sampler_OcclusionMap, ((dot(r8_xyz_4.xyzx, r8_xyz_4.xyzx)).xxxx).xy)).x;
                float r2_y_17 = (t4.Sample(sampler_linear_clamp2, r8_xyz_4.xyz)).y;
                float r1_w_10 = (r1_w_9 * (r2_y_17 * r2_x_17));
                float r2_x_19 = dot(i.texcoord2.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_y_18 = dot(i.texcoord3.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_z_15 = dot(i.texcoord4.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_w_10 = dot(float4(r2_x_19, r2_y_18, r2_z_15, r2_x_19), float4(r2_x_19, r2_y_18, r2_z_15, r2_x_19));
                float r2_w_11 = rsqrt(r2_w_10);
                float4 r2_xyzw_20 = (r2_w_11.xxxx * float4(r2_x_19, r2_y_18, r2_z_15, r2_x_19));
                float r2_x_20 = r2_xyzw_20.x;
                float r2_y_19 = r2_xyzw_20.y;
                float r2_z_16 = r2_xyzw_20.z;
                float4 r6_xyzw_4 = (r1_w_10.xxxx * _LightColor0.xyzx);
                float r6_x_4 = r6_xyzw_4.x;
                float r6_y_3 = r6_xyzw_4.y;
                float r6_z_3 = r6_xyzw_4.z;
                float r1_w_11 = max(r7_xyz_1.y, r7_xyz_1.x);
                float r1_w_12 = max(r7_xyz_1.z, r1_w_11);
                float r1_w_13 = (-r1_w_12 + 1);
                float r1_w_14 = mad(-cb0_values[10].x, r5_xyzw_1.w, 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r2_x_20, r2_y_19, r2_z_16, r2_x_20), unitViewDir_xyz_1.xyzx);
                float r2_w_12 = saturate(dot(float4(r2_x_20, r2_y_19, r2_z_16, r2_x_20), r1_xyz_1.xyzx));
                float r2_x_21 = saturate(dot(float4(r2_x_20, r2_y_19, r2_z_16, r2_x_20), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_14.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_12 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_14 * r1_w_14);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(r0_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * mad(r2_w_12, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_12, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r2_x_21, r0_z_9, -r2_x_21), r2_x_21, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_w_12.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r7_xyz_1.xyzx, r7_xyz_1.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r6_x_4, r6_y_3, r6_z_3, r6_x_4));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r6_x_4, r6_x_4, r6_y_3, r6_z_3) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_15 = (r0_x_5 * r0_x_5);
                float r1_w_16 = (r1_w_15 * r1_w_15);
                float4 r2_xyzw_22 = mad(-_SpecColor.xyzx, r5_xyzw_1.xyzx, float4(1, 1, 1, 0));
                float r2_x_22 = r2_xyzw_22.x;
                float r2_y_20 = r2_xyzw_22.y;
                float r2_z_17 = r2_xyzw_22.z;
                float4 r2_xyzw_23 = mad(float4(r2_x_22, r2_y_20, r2_z_17, r2_x_22), ((r0_x_5 * r1_w_16)).xxxx, r7_xyz_1.xyzx);
                float r2_x_23 = r2_xyzw_23.x;
                float r2_y_21 = r2_xyzw_23.y;
                float r2_z_18 = r2_xyzw_23.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_23, r2_y_21, r2_z_18, r2_x_23));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(((r1_w_13.xxxx * ((r4_xyz_1.xyzx * cb0_values[8].xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7))).xyz;
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
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_MainTex;
            SamplerState sampler_SpecGlossMap;
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _SpecGlossMap;
            Texture2D _OcclusionMap;
            Texture3D t4;
            TextureCube t5;
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
            struct program99Input
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
            struct program99Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program53Output vert(program53Input i)
            {
                program53Output o = (program53Output)0;
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
            program99Output frag(program99Input i)
            {
                program99Output o = (program99Output)0;
                float3 r0_xyz_1 = ((-i.texcoord5.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord5.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float3 r4_xyz_1 = (_MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy)).xyz;
                float4 r5_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord1.xyxx).xy);
                float3 r6_xyz_1 = (_SpecGlossMap.Sample(sampler_SpecGlossMap, (i.texcoord0.zwzz).xy)).xyz;
                float r6_x_2 = (r6_xyz_1.z * r6_xyz_1.x);
                float4 r6_xyzw_3 = mad(float4(r6_x_2, r6_xyz_1.y, r6_x_2, r6_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r6_x_3 = r6_xyzw_3.x;
                float r6_y_2 = r6_xyzw_3.y;
                float r1_w_3 = dot(float4(r6_x_3, r6_y_2, r6_x_3, r6_x_3), float4(r6_x_3, r6_y_2, r6_x_3, r6_x_3));
                float r1_w_4 = min(r1_w_3, 1);
                float r1_w_5 = (-r1_w_4 + 1);
                float r6_z_2 = sqrt(r1_w_5);
                float3 r7_xyz_1 = ((r5_xyzw_1.xyzx * _SpecColor.xyzx)).xyz;
                float3 r8_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord5.zzzz, (mad(cb0_values[4].xyzx, i.texcoord5.xxxx, ((i.texcoord5.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r9_x_1 = cb4_values[9].z;
                float r9_y_1 = cb4_values[10].z;
                float r9_z_1 = cb4_values[11].z;
                float r1_w_6 = dot(viewDir_xyz_1.xyzx, float4(r9_x_1, r9_y_1, r9_z_1, r9_x_1));
                float3 r2_xyz_2 = ((i.texcoord5.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_7 = mad(cb3_values[25].w, (-r1_w_6 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_6);
                float r1_w_8 = saturate(mad(r1_w_7, cb3_values[24].z, cb3_values[24].w));
                float r2_x_13;
                float r2_y_13;
                float r2_z_12;
                float r2_w_8;
                if ((cb5_values[0].x == 1))
                {
                    float4 r2_xyzw_4 = (i.texcoord5.yyyy * cb5_values[2].xxyz);
                    float r2_y_4 = r2_xyzw_4.y;
                    float r2_z_4 = r2_xyzw_4.z;
                    float r2_w_2 = r2_xyzw_4.w;
                    float4 r2_xyzw_5 = mad(cb5_values[1].xxyz, i.texcoord5.xxxx, float4(r2_y_4, r2_y_4, r2_z_4, r2_w_2));
                    float r2_y_5 = r2_xyzw_5.y;
                    float r2_z_5 = r2_xyzw_5.z;
                    float r2_w_3 = r2_xyzw_5.w;
                    float4 r2_xyzw_6 = mad(cb5_values[3].xxyz, i.texcoord5.zzzz, float4(r2_y_5, r2_y_5, r2_z_5, r2_w_3));
                    float r2_y_6 = r2_xyzw_6.y;
                    float r2_z_6 = r2_xyzw_6.z;
                    float r2_w_4 = r2_xyzw_6.w;
                    float4 r2_xyzw_7 = (float4(r2_y_6, r2_y_6, r2_z_6, r2_w_4) + cb5_values[4].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_5 = r2_xyzw_7.w;
                    float4 r2_xyzw_9 = (((cb5_values[0].y == 1)).xxxx ? float4(r2_y_7, r2_z_7, r2_w_5, r2_y_7) : i.texcoord5.xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_8 = r2_xyzw_9.y;
                    float r2_z_8 = r2_xyzw_9.z;
                    float4 r2_xyzw_10 = (float4(r2_x_9, r2_y_8, r2_z_8, r2_x_9) + -cb5_values[6].xyzx);
                    float r2_x_10 = r2_xyzw_10.x;
                    float r2_y_9 = r2_xyzw_10.y;
                    float r2_z_9 = r2_xyzw_10.z;
                    float r2_y_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).y;
                    float r2_z_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).z;
                    float r2_w_6 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).w;
                    float r2_y_11 = mad(r2_y_10, 0.25, 0.75);
                    float r3_w_1 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r2_x_11 = max(r2_y_11, r3_w_1);
                    float4 r2_xyzw_12 = t4.Sample(sampler_linear_clamp, (float4(r2_x_11, r2_z_10, r2_w_6, r2_x_11)).xyz);
                    r2_x_13 = r2_xyzw_12.x;
                    r2_y_13 = r2_xyzw_12.y;
                    r2_z_12 = r2_xyzw_12.z;
                    r2_w_8 = r2_xyzw_12.w;
                }
                else
                {
                    float r2_x_7 = (float4(1, 1, 1, 1)).x;
                    float4 r2_xyzw_3 = float4(1, 1, 1, 1);
                    float r2_y_3 = r2_xyzw_3.y;
                    float r2_z_3 = r2_xyzw_3.z;
                    float r2_w_1 = r2_xyzw_3.w;
                    r2_x_13 = r2_x_7;
                    r2_y_13 = r2_y_3;
                    r2_z_12 = r2_z_3;
                    r2_w_8 = r2_w_1;
                }
                float r2_y_14 = (r1_w_8 < 0.99);
                float r2_y_20;
                if (r2_y_14)
                {
                    float4 r2_xyzw_16 = (i.texcoord5.xxyz + -cb2_values[1].xxyz);
                    float r2_y_16 = r2_xyzw_16.y;
                    float r2_z_13 = r2_xyzw_16.z;
                    float r2_w_9 = r2_xyzw_16.w;
                    float r3_w_3 = max(abs(r2_z_13), abs(r2_y_16));
                    float r3_w_4 = max(abs(r2_w_9), r3_w_3);
                    float r3_w_5 = (r3_w_4 + -cb2_values[2].z);
                    float r3_w_6 = max(r3_w_5, 1E-05);
                    float r3_w_7 = (r3_w_6 * cb2_values[2].w);
                    float r3_w_8 = (cb2_values[2].y / r3_w_7);
                    float r3_w_9 = (r3_w_8 + -cb2_values[2].x);
                    float r3_w_10 = (-r3_w_9 + 1);
                    float r9_x_3 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((float4(r2_y_16, r2_z_13, r2_w_9, r2_y_16) + float4(0.0078125, 0.0078125, 0.0078125, 0))).xyzx).xyz, r3_w_10);
                    float r9_y_3 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((float4(r2_y_16, r2_z_13, r2_w_9, r2_y_16) + float4(-0.0078125, -0.0078125, 0.0078125, 0))).xyzx).xyz, r3_w_10);
                    float r9_z_3 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((float4(r2_y_16, r2_z_13, r2_w_9, r2_y_16) + float4(-0.0078125, 0.0078125, -0.0078125, 0))).xyzx).xyz, r3_w_10);
                    float4 r2_xyzw_17 = (float4(r2_y_16, r2_y_16, r2_z_13, r2_w_9) + float4(0, 0.0078125, -0.0078125, -0.0078125));
                    float r2_y_17 = r2_xyzw_17.y;
                    float r2_z_14 = r2_xyzw_17.z;
                    float r2_w_10 = r2_xyzw_17.w;
                    float r9_w_1 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r2_y_17, r2_z_14, r2_w_10, r2_y_17)).xyz, r3_w_10);
                    float r2_y_18 = dot(float4(r9_x_3, r9_y_3, r9_z_3, r9_w_1), float4(0.25, 0.25, 0.25, 0.25));
                    float r2_z_15 = (-cb3_values[24].x + 1);
                    float r2_y_19 = mad(r2_y_18, r2_z_15, cb3_values[24].x);
                    r2_y_20 = r2_y_19;
                }
                else
                {
                    float r2_y_15 = 1;
                    r2_y_20 = r2_y_15;
                }
                float r1_w_9 = mad(r1_w_8, (-r2_y_20 + saturate(dot(float4(r2_x_13, r2_y_13, r2_z_12, r2_w_8), unity_OcclusionMaskSelector))), r2_y_20);
                float r2_x_17 = (_OcclusionMap.Sample(sampler_OcclusionMap, ((dot(r8_xyz_4.xyzx, r8_xyz_4.xyzx)).xxxx).xy)).x;
                float r1_w_10 = (r1_w_9 * r2_x_17);
                float r2_x_18 = dot(i.texcoord2.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_y_21 = dot(i.texcoord3.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_z_17 = dot(i.texcoord4.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_w_12 = dot(float4(r2_x_18, r2_y_21, r2_z_17, r2_x_18), float4(r2_x_18, r2_y_21, r2_z_17, r2_x_18));
                float r2_w_13 = rsqrt(r2_w_12);
                float4 r2_xyzw_19 = (r2_w_13.xxxx * float4(r2_x_18, r2_y_21, r2_z_17, r2_x_18));
                float r2_x_19 = r2_xyzw_19.x;
                float r2_y_22 = r2_xyzw_19.y;
                float r2_z_18 = r2_xyzw_19.z;
                float4 r6_xyzw_4 = (r1_w_10.xxxx * _LightColor0.xyzx);
                float r6_x_4 = r6_xyzw_4.x;
                float r6_y_3 = r6_xyzw_4.y;
                float r6_z_3 = r6_xyzw_4.z;
                float r1_w_11 = max(r7_xyz_1.y, r7_xyz_1.x);
                float r1_w_12 = max(r7_xyz_1.z, r1_w_11);
                float r1_w_13 = (-r1_w_12 + 1);
                float r1_w_14 = mad(-cb0_values[10].x, r5_xyzw_1.w, 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r2_x_19, r2_y_22, r2_z_18, r2_x_19), unitViewDir_xyz_1.xyzx);
                float r2_w_14 = saturate(dot(float4(r2_x_19, r2_y_22, r2_z_18, r2_x_19), r1_xyz_1.xyzx));
                float r2_x_20 = saturate(dot(float4(r2_x_19, r2_y_22, r2_z_18, r2_x_19), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_14.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_14 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_14 * r1_w_14);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(r0_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * mad(r2_w_14, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_14, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r2_x_20, r0_z_9, -r2_x_20), r2_x_20, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_w_14.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r7_xyz_1.xyzx, r7_xyz_1.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r6_x_4, r6_y_3, r6_z_3, r6_x_4));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r6_x_4, r6_x_4, r6_y_3, r6_z_3) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_15 = (r0_x_5 * r0_x_5);
                float r1_w_16 = (r1_w_15 * r1_w_15);
                float4 r2_xyzw_21 = mad(-_SpecColor.xyzx, r5_xyzw_1.xyzx, float4(1, 1, 1, 0));
                float r2_x_21 = r2_xyzw_21.x;
                float r2_y_23 = r2_xyzw_21.y;
                float r2_z_19 = r2_xyzw_21.z;
                float4 r2_xyzw_22 = mad(float4(r2_x_21, r2_y_23, r2_z_19, r2_x_21), ((r0_x_5 * r1_w_16)).xxxx, r7_xyz_1.xyzx);
                float r2_x_22 = r2_xyzw_22.x;
                float r2_y_24 = r2_xyzw_22.y;
                float r2_z_20 = r2_xyzw_22.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_22, r2_y_24, r2_z_20, r2_x_22));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(((r1_w_13.xxxx * ((r4_xyz_1.xyzx * cb0_values[8].xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7))).xyz;
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
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_MainTex;
            SamplerState sampler_SpecGlossMap;
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _SpecGlossMap;
            Texture2D _OcclusionMap;
            Texture3D t4;
            TextureCube t5;
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
            struct program98Input
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
            struct program98Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program52Output vert(program52Input i)
            {
                program52Output o = (program52Output)0;
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
            program98Output frag(program98Input i)
            {
                program98Output o = (program98Output)0;
                float3 r0_xyz_1 = ((-i.texcoord5.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord5.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float3 r4_xyz_1 = (_MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy)).xyz;
                float4 r5_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord1.xyxx).xy);
                float3 r6_xyz_1 = (_SpecGlossMap.Sample(sampler_SpecGlossMap, (i.texcoord0.zwzz).xy)).xyz;
                float r6_x_2 = (r6_xyz_1.z * r6_xyz_1.x);
                float4 r6_xyzw_3 = mad(float4(r6_x_2, r6_xyz_1.y, r6_x_2, r6_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r6_x_3 = r6_xyzw_3.x;
                float r6_y_2 = r6_xyzw_3.y;
                float r1_w_3 = dot(float4(r6_x_3, r6_y_2, r6_x_3, r6_x_3), float4(r6_x_3, r6_y_2, r6_x_3, r6_x_3));
                float r1_w_4 = min(r1_w_3, 1);
                float r1_w_5 = (-r1_w_4 + 1);
                float r6_z_2 = sqrt(r1_w_5);
                float3 r7_xyz_1 = ((r5_xyzw_1.xyzx * _SpecColor.xyzx)).xyz;
                float3 r8_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord5.zzzz, (mad(cb0_values[4].xyzx, i.texcoord5.xxxx, ((i.texcoord5.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r9_x_1 = cb4_values[9].z;
                float r9_y_1 = cb4_values[10].z;
                float r9_z_1 = cb4_values[11].z;
                float r1_w_6 = dot(viewDir_xyz_1.xyzx, float4(r9_x_1, r9_y_1, r9_z_1, r9_x_1));
                float3 r2_xyz_2 = ((i.texcoord5.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_7 = mad(cb3_values[25].w, (-r1_w_6 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_6);
                float r1_w_8 = saturate(mad(r1_w_7, cb3_values[24].z, cb3_values[24].w));
                float r2_x_13;
                float r2_y_13;
                float r2_z_12;
                float r2_w_8;
                if ((cb5_values[0].x == 1))
                {
                    float4 r2_xyzw_4 = (i.texcoord5.yyyy * cb5_values[2].xxyz);
                    float r2_y_4 = r2_xyzw_4.y;
                    float r2_z_4 = r2_xyzw_4.z;
                    float r2_w_2 = r2_xyzw_4.w;
                    float4 r2_xyzw_5 = mad(cb5_values[1].xxyz, i.texcoord5.xxxx, float4(r2_y_4, r2_y_4, r2_z_4, r2_w_2));
                    float r2_y_5 = r2_xyzw_5.y;
                    float r2_z_5 = r2_xyzw_5.z;
                    float r2_w_3 = r2_xyzw_5.w;
                    float4 r2_xyzw_6 = mad(cb5_values[3].xxyz, i.texcoord5.zzzz, float4(r2_y_5, r2_y_5, r2_z_5, r2_w_3));
                    float r2_y_6 = r2_xyzw_6.y;
                    float r2_z_6 = r2_xyzw_6.z;
                    float r2_w_4 = r2_xyzw_6.w;
                    float4 r2_xyzw_7 = (float4(r2_y_6, r2_y_6, r2_z_6, r2_w_4) + cb5_values[4].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_5 = r2_xyzw_7.w;
                    float4 r2_xyzw_9 = (((cb5_values[0].y == 1)).xxxx ? float4(r2_y_7, r2_z_7, r2_w_5, r2_y_7) : i.texcoord5.xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_8 = r2_xyzw_9.y;
                    float r2_z_8 = r2_xyzw_9.z;
                    float4 r2_xyzw_10 = (float4(r2_x_9, r2_y_8, r2_z_8, r2_x_9) + -cb5_values[6].xyzx);
                    float r2_x_10 = r2_xyzw_10.x;
                    float r2_y_9 = r2_xyzw_10.y;
                    float r2_z_9 = r2_xyzw_10.z;
                    float r2_y_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).y;
                    float r2_z_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).z;
                    float r2_w_6 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).w;
                    float r2_y_11 = mad(r2_y_10, 0.25, 0.75);
                    float r3_w_1 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r2_x_11 = max(r2_y_11, r3_w_1);
                    float4 r2_xyzw_12 = t4.Sample(sampler_linear_clamp, (float4(r2_x_11, r2_z_10, r2_w_6, r2_x_11)).xyz);
                    r2_x_13 = r2_xyzw_12.x;
                    r2_y_13 = r2_xyzw_12.y;
                    r2_z_12 = r2_xyzw_12.z;
                    r2_w_8 = r2_xyzw_12.w;
                }
                else
                {
                    float r2_x_7 = (float4(1, 1, 1, 1)).x;
                    float4 r2_xyzw_3 = float4(1, 1, 1, 1);
                    float r2_y_3 = r2_xyzw_3.y;
                    float r2_z_3 = r2_xyzw_3.z;
                    float r2_w_1 = r2_xyzw_3.w;
                    r2_x_13 = r2_x_7;
                    r2_y_13 = r2_y_3;
                    r2_z_12 = r2_z_3;
                    r2_w_8 = r2_w_1;
                }
                float4 r2_xyzw_14 = (i.texcoord5.xxyz + -cb2_values[1].xxyz);
                float r2_y_14 = r2_xyzw_14.y;
                float r2_z_13 = r2_xyzw_14.z;
                float r2_w_9 = r2_xyzw_14.w;
                float r3_w_3 = max(abs(r2_z_13), abs(r2_y_14));
                float r3_w_4 = max(abs(r2_w_9), r3_w_3);
                float r3_w_5 = (r3_w_4 + -cb2_values[2].z);
                float r3_w_6 = max(r3_w_5, 1E-05);
                float r3_w_7 = (r3_w_6 * cb2_values[2].w);
                float r3_w_8 = (cb2_values[2].y / r3_w_7);
                float r3_w_9 = (r3_w_8 + -cb2_values[2].x);
                float r3_w_10 = (-r3_w_9 + 1);
                float r2_y_15 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r2_y_14, r2_z_13, r2_w_9, r2_y_14)).xyz, r3_w_10);
                float r2_z_14 = (-cb3_values[24].x + 1);
                float r2_y_16 = mad(r2_y_15, r2_z_14, cb3_values[24].x);
                float r1_w_9 = mad(r1_w_8, (-r2_y_16 + saturate(dot(float4(r2_x_13, r2_y_13, r2_z_12, r2_w_8), unity_OcclusionMaskSelector))), r2_y_16);
                float r2_x_17 = (_OcclusionMap.Sample(sampler_OcclusionMap, ((dot(r8_xyz_4.xyzx, r8_xyz_4.xyzx)).xxxx).xy)).x;
                float r1_w_10 = (r1_w_9 * r2_x_17);
                float r2_x_18 = dot(i.texcoord2.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_y_17 = dot(i.texcoord3.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_z_15 = dot(i.texcoord4.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_w_10 = dot(float4(r2_x_18, r2_y_17, r2_z_15, r2_x_18), float4(r2_x_18, r2_y_17, r2_z_15, r2_x_18));
                float r2_w_11 = rsqrt(r2_w_10);
                float4 r2_xyzw_19 = (r2_w_11.xxxx * float4(r2_x_18, r2_y_17, r2_z_15, r2_x_18));
                float r2_x_19 = r2_xyzw_19.x;
                float r2_y_18 = r2_xyzw_19.y;
                float r2_z_16 = r2_xyzw_19.z;
                float4 r6_xyzw_4 = (r1_w_10.xxxx * _LightColor0.xyzx);
                float r6_x_4 = r6_xyzw_4.x;
                float r6_y_3 = r6_xyzw_4.y;
                float r6_z_3 = r6_xyzw_4.z;
                float r1_w_11 = max(r7_xyz_1.y, r7_xyz_1.x);
                float r1_w_12 = max(r7_xyz_1.z, r1_w_11);
                float r1_w_13 = (-r1_w_12 + 1);
                float r1_w_14 = mad(-cb0_values[10].x, r5_xyzw_1.w, 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r2_x_19, r2_y_18, r2_z_16, r2_x_19), unitViewDir_xyz_1.xyzx);
                float r2_w_12 = saturate(dot(float4(r2_x_19, r2_y_18, r2_z_16, r2_x_19), r1_xyz_1.xyzx));
                float r2_x_20 = saturate(dot(float4(r2_x_19, r2_y_18, r2_z_16, r2_x_19), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_14.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_12 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_14 * r1_w_14);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(r0_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * mad(r2_w_12, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_12, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r2_x_20, r0_z_9, -r2_x_20), r2_x_20, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_w_12.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r7_xyz_1.xyzx, r7_xyz_1.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r6_x_4, r6_y_3, r6_z_3, r6_x_4));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r6_x_4, r6_x_4, r6_y_3, r6_z_3) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_15 = (r0_x_5 * r0_x_5);
                float r1_w_16 = (r1_w_15 * r1_w_15);
                float4 r2_xyzw_21 = mad(-_SpecColor.xyzx, r5_xyzw_1.xyzx, float4(1, 1, 1, 0));
                float r2_x_21 = r2_xyzw_21.x;
                float r2_y_19 = r2_xyzw_21.y;
                float r2_z_17 = r2_xyzw_21.z;
                float4 r2_xyzw_22 = mad(float4(r2_x_21, r2_y_19, r2_z_17, r2_x_21), ((r0_x_5 * r1_w_16)).xxxx, r7_xyz_1.xyzx);
                float r2_x_22 = r2_xyzw_22.x;
                float r2_y_20 = r2_xyzw_22.y;
                float r2_z_18 = r2_xyzw_22.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_22, r2_y_20, r2_z_18, r2_x_22));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(((r1_w_13.xxxx * ((r4_xyz_1.xyzx * cb0_values[8].xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7))).xyz;
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
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            SamplerState sampler_SpecGlossMap;
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _SpecGlossMap;
            Texture2D _OcclusionMap;
            Texture2D t4;
            Texture3D t5;
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
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float2 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program97Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float2 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program97Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program51Output vert(program51Input i)
            {
                program51Output o = (program51Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[12].xxxy, cb0_values[12].zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, cb0_values[13].xyxx, cb0_values[13].zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, cb0_values[14].xxxy, cb0_values[14].zzzw)).zw;
                float r2_y_4 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float r2_z_4 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float r2_x_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r2_w_4 = dot(float4(r2_x_4, r2_y_4, r2_z_4, r2_x_4), float4(r2_x_4, r2_y_4, r2_z_4, r2_x_4));
                float r2_w_5 = rsqrt(r2_w_4);
                float3 unitWorldNormal_xyz_5 = ((r2_w_5.xxxx * float4(r2_x_4, r2_y_4, r2_z_4, r2_x_4))).xyz;
                float3 worldTangent_xyz_1 = ((i.tangent0.yyyy * cb2_values[1].yzxy)).xyz;
                float3 worldTangent_xyz_2 = (mad(cb2_values[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_1.xyzx)).xyz;
                float3 worldTangent_xyz_3 = (mad(cb2_values[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_2.xyzx)).xyz;
                float3 unitWorldTangent_xyz_4 = normalize(worldTangent_xyz_3);
                float r2_w_8 = (i.tangent0.w * cb2_values[9].w);
                float3 r4_xyz_3 = ((r2_w_8.xxxx * (mad(unitWorldNormal_xyz_5.zxyz, unitWorldTangent_xyz_4.yzxy, ((unitWorldNormal_xyz_5.xyzx * unitWorldTangent_xyz_4.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord2.y = r4_xyz_3.x;
                o.texcoord2.x = unitWorldTangent_xyz_4.z;
                o.texcoord2.z = unitWorldNormal_xyz_5.y;
                o.texcoord3.x = unitWorldTangent_xyz_4.x;
                o.texcoord4.x = unitWorldTangent_xyz_4.y;
                o.texcoord3.z = unitWorldNormal_xyz_5.z;
                o.texcoord4.z = unitWorldNormal_xyz_5.x;
                o.texcoord3.y = r4_xyz_3.y;
                o.texcoord4.y = r4_xyz_3.z;
                o.texcoord5.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord6.xy = (mad(_MainTex_ST.xyxx, r0_xyzw_4.wwww, (mad(cb0_values[6].xyxx, r0_xyzw_4.zzzz, (mad(_Color.xyxx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * _EmissionColor.xyxx)).xyxx)).xyxx)).xyxx)).xy;
                float r0_w_5 = ((clipPos_xyzw_2.y * unity_WorldToObject[1].x) * 0.5);
                float4 r0_xyzw_8 = (clipPos_xyzw_2.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_z_5 = r0_xyzw_8.z;
                o.texcoord7.zw = (clipPos_xyzw_2.zzzw).zw;
                o.texcoord7.xy = ((r0_z_5.xxxx + float4(r0_x_8, r0_w_5, r0_x_8, r0_x_8))).xy;
                return o;
            }
            #pragma fragment frag
            program97Output frag(program97Input i)
            {
                program97Output o = (program97Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord5.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float3 r2_xyz_1 = (_MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy)).xyz;
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord1.xyxx).xy);
                float3 r4_xyz_1 = (_SpecGlossMap.Sample(sampler_SpecGlossMap, (i.texcoord0.zwzz).xy)).xyz;
                float r4_x_2 = (r4_xyz_1.z * r4_xyz_1.x);
                float4 r4_xyzw_3 = mad(float4(r4_x_2, r4_xyz_1.y, r4_x_2, r4_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r4_x_3 = r4_xyzw_3.x;
                float r4_y_2 = r4_xyzw_3.y;
                float r1_w_1 = dot(float4(r4_x_3, r4_y_2, r4_x_3, r4_x_3), float4(r4_x_3, r4_y_2, r4_x_3, r4_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r4_z_2 = sqrt(r1_w_3);
                float3 r5_xyz_1 = ((r3_xyzw_1.xyzx * _SpecColor.xyzx)).xyz;
                float r7_x_1 = cb4_values[9].z;
                float r7_y_1 = cb4_values[10].z;
                float r7_z_1 = cb4_values[11].z;
                float r1_w_4 = dot(viewDir_xyz_1.xyzx, float4(r7_x_1, r7_y_1, r7_z_1, r7_x_1));
                float3 r7_xyz_2 = ((i.texcoord5.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_1 = dot(r7_xyz_2.xyzx, r7_xyz_2.xyzx);
                float r2_w_2 = sqrt(r2_w_1);
                float r2_w_3 = (-r1_w_4 + r2_w_2);
                float r1_w_5 = mad(cb3_values[25].w, r2_w_3, r1_w_4);
                float r1_w_6 = saturate(mad(r1_w_5, cb3_values[24].z, cb3_values[24].w));
                float r2_w_4 = (cb5_values[0].x == 1);
                float r7_x_12;
                float r7_y_12;
                float r7_z_12;
                float r7_w_4;
                if (r2_w_4)
                {
                    float r2_w_5 = (cb5_values[0].y == 1);
                    float3 r7_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord5.zzzz, (mad(cb5_values[1].xyzx, i.texcoord5.xxxx, ((i.texcoord5.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r7_xyzw_10 = (((((r2_w_5.xxxx ? r7_xyz_7.xyzx : i.texcoord5.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r7_y_10 = r7_xyzw_10.y;
                    float r7_z_10 = r7_xyzw_10.z;
                    float r7_w_2 = r7_xyzw_10.w;
                    float r2_w_6 = mad(r7_y_10, 0.25, 0.75);
                    float r4_w_1 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r7_x_10 = max(r2_w_6, r4_w_1);
                    float4 r7_xyzw_11 = t5.Sample(sampler_linear_clamp, (float4(r7_x_10, r7_z_10, r7_w_2, r7_x_10)).xyz);
                    r7_x_12 = r7_xyzw_11.x;
                    r7_y_12 = r7_xyzw_11.y;
                    r7_z_12 = r7_xyzw_11.z;
                    r7_w_4 = r7_xyzw_11.w;
                }
                else
                {
                    float4 r7_xyzw_3 = float4(1, 1, 1, 1);
                    r7_x_12 = r7_xyzw_3.x;
                    r7_y_12 = r7_xyzw_3.y;
                    r7_z_12 = r7_xyzw_3.z;
                    r7_w_4 = r7_xyzw_3.w;
                }
                float r2_w_8 = saturate(dot(float4(r7_x_12, r7_y_12, r7_z_12, r7_w_4), unity_OcclusionMaskSelector));
                float2 r6_zw_1 = ((i.texcoord7.xxxy / i.texcoord7.wwww)).zw;
                float r4_w_3 = (_OcclusionMap.Sample(sampler_OcclusionMap, (r6_zw_1.xyxx).xy)).w;
                float r2_w_9 = (r2_w_8 + -r4_w_3);
                float r1_w_7 = mad(r1_w_6, r2_w_9, r4_w_3);
                float r2_w_10 = (t4.Sample(sampler_linear_clamp2, ((((mad(cb0_values[6].xyxx, i.texcoord5.zzzz, (mad(cb0_values[4].xyxx, i.texcoord5.xxxx, ((i.texcoord5.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx).xy)).w;
                float r1_w_8 = (r1_w_7 * r2_w_10);
                float r6_x_5 = dot(i.texcoord2.xyzx, float4(r4_x_3, r4_y_2, r4_z_2, r4_x_3));
                float r6_y_5 = dot(i.texcoord3.xyzx, float4(r4_x_3, r4_y_2, r4_z_2, r4_x_3));
                float r6_z_2 = dot(i.texcoord4.xyzx, float4(r4_x_3, r4_y_2, r4_z_2, r4_x_3));
                float r2_w_11 = dot(float4(r6_x_5, r6_y_5, r6_z_2, r6_x_5), float4(r6_x_5, r6_y_5, r6_z_2, r6_x_5));
                float r2_w_12 = rsqrt(r2_w_11);
                float4 r4_xyzw_4 = (r2_w_12.xxxx * float4(r6_x_5, r6_y_5, r6_z_2, r6_x_5));
                float r4_x_4 = r4_xyzw_4.x;
                float r4_y_3 = r4_xyzw_4.y;
                float r4_z_3 = r4_xyzw_4.z;
                float4 r6_xyzw_6 = (r1_w_8.xxxx * _LightColor0.xyzx);
                float r6_x_6 = r6_xyzw_6.x;
                float r6_y_6 = r6_xyzw_6.y;
                float r6_z_3 = r6_xyzw_6.z;
                float r1_w_9 = max(r5_xyz_1.y, r5_xyz_1.x);
                float r1_w_10 = max(r5_xyz_1.z, r1_w_9);
                float r1_w_11 = (-r1_w_10 + 1);
                float r1_w_12 = mad(-cb0_values[10].x, r3_xyzw_1.w, 1);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r4_x_4, r4_y_3, r4_z_3, r4_x_4), unitViewDir_xyz_1.xyzx);
                float r1_x_2 = saturate(dot(float4(r4_x_4, r4_y_3, r4_z_3, r4_x_4), _WorldSpaceLightPos0.xyzx));
                float r1_y_2 = saturate(dot(float4(r4_x_4, r4_y_3, r4_z_3, r4_x_4), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_12.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(r0_w_6) + 1);
                float r2_w_13 = (r1_z_4 * r1_z_4);
                float r2_w_14 = (r2_w_13 * r2_w_13);
                float r1_z_5 = (r1_z_4 * r2_w_14);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_12 * r1_w_12);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_z_6 = (-r0_z_8 + 1);
                float r1_w_13 = mad(abs(r0_w_6), r1_z_6, r0_z_8);
                float r1_z_7 = mad(r1_x_2, r1_z_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * r1_z_7);
                float r0_w_8 = mad(r1_x_2, r1_w_13, r0_w_7);
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
                float r0_w_11 = dot(r5_xyz_1.xyzx, r5_xyz_1.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_3 = (r0_y_9.xxxx * float4(r6_x_6, r6_y_6, r6_z_3, r6_x_6));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_5 = r1_xyzw_3.y;
                float r1_z_9 = r1_xyzw_3.z;
                float4 r0_xyzw_10 = (float4(r6_x_6, r6_x_6, r6_y_6, r6_z_3) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_14 = (r0_x_5 * r0_x_5);
                float r1_w_15 = (r1_w_14 * r1_w_14);
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * (mad((mad(-_SpecColor.xyzx, r3_xyzw_1.xyzx, float4(1, 1, 1, 0))).xyzx, ((r0_x_5 * r1_w_15)).xxxx, r5_xyz_1.xyzx)).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(((r1_w_11.xxxx * ((r2_xyz_1.xyzx * cb0_values[8].xyzx)).xyzx)).xyzx, float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7))).xyz;
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
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program96Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program96Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program50Output vert(program50Input i)
            {
                program50Output o = (program50Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                o.texcoord5.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _SpecGlossMap_ST.xyxx, _SpecGlossMap_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _OcclusionMap_ST.xxxy, _OcclusionMap_ST.zzzw)).zw;
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
                o.texcoord2.y = r3_xyz_3.x;
                o.texcoord2.x = unitWorldTangent_xyz_4.z;
                o.texcoord2.z = unitWorldNormal_xyz_3.y;
                o.texcoord3.x = unitWorldTangent_xyz_4.x;
                o.texcoord4.x = unitWorldTangent_xyz_4.y;
                o.texcoord3.z = unitWorldNormal_xyz_3.z;
                o.texcoord4.z = unitWorldNormal_xyz_3.x;
                o.texcoord3.y = r3_xyz_3.y;
                o.texcoord4.y = r3_xyz_3.z;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r1_xyzw_4 = (float4(clipPos_xyzw_7.x, clipPos_xyzw_7.x, clipPos_xyzw_7.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_z_4 = r1_xyzw_4.z;
                float r1_w_7 = r1_xyzw_4.w;
                o.texcoord7.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord7.xy = ((r1_z_4.xxxx + float4(r1_x_4, r1_w_7, r1_x_4, r1_x_4))).xy;
                return o;
            }
            #pragma fragment frag
            program96Output frag(program96Input i)
            {
                program96Output o = (program96Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord5.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float3 r2_xyz_1 = (_MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy)).xyz;
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord1.xyxx).xy);
                float3 r4_xyz_1 = (_SpecGlossMap.Sample(sampler_SpecGlossMap, (i.texcoord0.zwzz).xy)).xyz;
                float r4_x_2 = (r4_xyz_1.z * r4_xyz_1.x);
                float4 r4_xyzw_3 = mad(float4(r4_x_2, r4_xyz_1.y, r4_x_2, r4_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r4_x_3 = r4_xyzw_3.x;
                float r4_y_2 = r4_xyzw_3.y;
                float r1_w_1 = dot(float4(r4_x_3, r4_y_2, r4_x_3, r4_x_3), float4(r4_x_3, r4_y_2, r4_x_3, r4_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r4_z_2 = sqrt(r1_w_3);
                float3 r5_xyz_1 = ((r3_xyzw_1.xyzx * _SpecColor.xyzx)).xyz;
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r1_w_4 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float3 r6_xyz_2 = ((i.texcoord5.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_1 = dot(r6_xyz_2.xyzx, r6_xyz_2.xyzx);
                float r2_w_2 = sqrt(r2_w_1);
                float r2_w_3 = (-r1_w_4 + r2_w_2);
                float r1_w_5 = mad(cb3_values[25].w, r2_w_3, r1_w_4);
                float r1_w_6 = saturate(mad(r1_w_5, cb3_values[24].z, cb3_values[24].w));
                float r2_w_4 = (cb5_values[0].x == 1);
                float r6_x_12;
                float r6_y_12;
                float r6_z_12;
                float r6_w_4;
                if (r2_w_4)
                {
                    float r2_w_5 = (cb5_values[0].y == 1);
                    float3 r6_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord5.zzzz, (mad(cb5_values[1].xyzx, i.texcoord5.xxxx, ((i.texcoord5.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r6_xyzw_10 = (((((r2_w_5.xxxx ? r6_xyz_7.xyzx : i.texcoord5.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r6_y_10 = r6_xyzw_10.y;
                    float r6_z_10 = r6_xyzw_10.z;
                    float r6_w_2 = r6_xyzw_10.w;
                    float r2_w_6 = mad(r6_y_10, 0.25, 0.75);
                    float r4_w_1 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r6_x_10 = max(r2_w_6, r4_w_1);
                    float4 r6_xyzw_11 = t4.Sample(sampler_linear_clamp, (float4(r6_x_10, r6_z_10, r6_w_2, r6_x_10)).xyz);
                    r6_x_12 = r6_xyzw_11.x;
                    r6_y_12 = r6_xyzw_11.y;
                    r6_z_12 = r6_xyzw_11.z;
                    r6_w_4 = r6_xyzw_11.w;
                }
                else
                {
                    float4 r6_xyzw_3 = float4(1, 1, 1, 1);
                    r6_x_12 = r6_xyzw_3.x;
                    r6_y_12 = r6_xyzw_3.y;
                    r6_z_12 = r6_xyzw_3.z;
                    r6_w_4 = r6_xyzw_3.w;
                }
                float r2_w_8 = saturate(dot(float4(r6_x_12, r6_y_12, r6_z_12, r6_w_4), unity_OcclusionMaskSelector));
                float r4_w_3 = (_OcclusionMap.Sample(sampler_OcclusionMap, (((i.texcoord7.xyxx / i.texcoord7.wwww)).xyxx).xy)).w;
                float r2_w_9 = (r2_w_8 + -r4_w_3);
                float r1_w_7 = mad(r1_w_6, r2_w_9, r4_w_3);
                float r6_x_14 = dot(i.texcoord2.xyzx, float4(r4_x_3, r4_y_2, r4_z_2, r4_x_3));
                float r6_y_14 = dot(i.texcoord3.xyzx, float4(r4_x_3, r4_y_2, r4_z_2, r4_x_3));
                float r6_z_13 = dot(i.texcoord4.xyzx, float4(r4_x_3, r4_y_2, r4_z_2, r4_x_3));
                float r2_w_10 = dot(float4(r6_x_14, r6_y_14, r6_z_13, r6_x_14), float4(r6_x_14, r6_y_14, r6_z_13, r6_x_14));
                float r2_w_11 = rsqrt(r2_w_10);
                float4 r4_xyzw_4 = (r2_w_11.xxxx * float4(r6_x_14, r6_y_14, r6_z_13, r6_x_14));
                float r4_x_4 = r4_xyzw_4.x;
                float r4_y_3 = r4_xyzw_4.y;
                float r4_z_3 = r4_xyzw_4.z;
                float4 r6_xyzw_15 = (r1_w_7.xxxx * _LightColor0.xyzx);
                float r6_x_15 = r6_xyzw_15.x;
                float r6_y_15 = r6_xyzw_15.y;
                float r6_z_14 = r6_xyzw_15.z;
                float r1_w_8 = max(r5_xyz_1.y, r5_xyz_1.x);
                float r1_w_9 = max(r5_xyz_1.z, r1_w_8);
                float r1_w_10 = (-r1_w_9 + 1);
                float r1_w_11 = mad(-cb0_values[6].x, r3_xyzw_1.w, 1);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r4_x_4, r4_y_3, r4_z_3, r4_x_4), unitViewDir_xyz_1.xyzx);
                float r1_x_2 = saturate(dot(float4(r4_x_4, r4_y_3, r4_z_3, r4_x_4), _WorldSpaceLightPos0.xyzx));
                float r1_y_2 = saturate(dot(float4(r4_x_4, r4_y_3, r4_z_3, r4_x_4), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_11.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(r0_w_6) + 1);
                float r2_w_12 = (r1_z_4 * r1_z_4);
                float r2_w_13 = (r2_w_12 * r2_w_12);
                float r1_z_5 = (r1_z_4 * r2_w_13);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_11 * r1_w_11);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_z_6 = (-r0_z_8 + 1);
                float r1_w_12 = mad(abs(r0_w_6), r1_z_6, r0_z_8);
                float r1_z_7 = mad(r1_x_2, r1_z_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * r1_z_7);
                float r0_w_8 = mad(r1_x_2, r1_w_12, r0_w_7);
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
                float r0_w_11 = dot(r5_xyz_1.xyzx, r5_xyz_1.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_3 = (r0_y_9.xxxx * float4(r6_x_15, r6_y_15, r6_z_14, r6_x_15));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_5 = r1_xyzw_3.y;
                float r1_z_9 = r1_xyzw_3.z;
                float4 r0_xyzw_10 = (float4(r6_x_15, r6_x_15, r6_y_15, r6_z_14) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_13 = (r0_x_5 * r0_x_5);
                float r1_w_14 = (r1_w_13 * r1_w_13);
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * (mad((mad(-_SpecColor.xyzx, r3_xyzw_1.xyzx, float4(1, 1, 1, 0))).xyzx, ((r0_x_5 * r1_w_14)).xxxx, r5_xyz_1.xyzx)).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(((r1_w_10.xxxx * ((r2_xyz_1.xyzx * cb0_values[4].xyzx)).xyzx)).xyzx, float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7))).xyz;
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
                float4 cb0_values[20];
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
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_linear_clamp3;
            SamplerState sampler_MainTex;
            SamplerState sampler_SpecGlossMap;
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _SpecGlossMap;
            Texture2D _OcclusionMap;
            Texture2D t4;
            Texture3D t5;
            Texture2D t6;
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
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program95Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program95Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program49Output vert(program49Input i)
            {
                program49Output o = (program49Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[16].xyxx, cb0_values[16].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[17].xxxy, cb0_values[17].zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, cb0_values[18].xyxx, cb0_values[18].zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, cb0_values[19].xxxy, cb0_values[19].zzzw)).zw;
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
                float4 clipPos_xyzw_4 = (worldPos_xyzw_4.yyyy * _OcclusionMap_ST);
                float4 clipPos_xyzw_5 = mad(_SpecGlossMap_ST, worldPos_xyzw_4.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb0_values[11].xyzw, worldPos_xyzw_4.zzzz, clipPos_xyzw_5);
                o.texcoord6.xyzw = mad(cb0_values[12].xyzw, worldPos_xyzw_4.wwww, clipPos_xyzw_6);
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program95Output frag(program95Input i)
            {
                program95Output o = (program95Output)0;
                float3 r0_xyz_1 = ((-i.texcoord5.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord5.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float3 r4_xyz_1 = (_MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy)).xyz;
                float4 r5_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord1.xyxx).xy);
                float3 r6_xyz_1 = (_SpecGlossMap.Sample(sampler_SpecGlossMap, (i.texcoord0.zwzz).xy)).xyz;
                float r6_x_2 = (r6_xyz_1.z * r6_xyz_1.x);
                float4 r6_xyzw_3 = mad(float4(r6_x_2, r6_xyz_1.y, r6_x_2, r6_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r6_x_3 = r6_xyzw_3.x;
                float r6_y_2 = r6_xyzw_3.y;
                float r1_w_3 = dot(float4(r6_x_3, r6_y_2, r6_x_3, r6_x_3), float4(r6_x_3, r6_y_2, r6_x_3, r6_x_3));
                float r1_w_4 = min(r1_w_3, 1);
                float r1_w_5 = (-r1_w_4 + 1);
                float r6_z_2 = sqrt(r1_w_5);
                float3 r7_xyz_1 = ((r5_xyzw_1.xyzx * _SpecColor.xyzx)).xyz;
                float4 r8_xyzw_4 = (mad(cb0_values[11].xyzw, i.texcoord5.zzzz, mad(cb0_values[9].xyzw, i.texcoord5.xxxx, (i.texcoord5.yyyy * cb0_values[10].xyzw))) + cb0_values[12].xyzw);
                float r9_x_1 = cb4_values[9].z;
                float r9_y_1 = cb4_values[10].z;
                float r9_z_1 = cb4_values[11].z;
                float r1_w_6 = dot(viewDir_xyz_1.xyzx, float4(r9_x_1, r9_y_1, r9_z_1, r9_x_1));
                float3 r2_xyz_2 = ((i.texcoord5.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_7 = mad(cb3_values[25].w, (-r1_w_6 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_6);
                float r1_w_8 = saturate(mad(r1_w_7, cb3_values[24].z, cb3_values[24].w));
                float r2_x_13;
                float r2_y_13;
                float r2_z_12;
                float r2_w_8;
                if ((cb5_values[0].x == 1))
                {
                    float4 r2_xyzw_4 = (i.texcoord5.yyyy * cb5_values[2].xxyz);
                    float r2_y_4 = r2_xyzw_4.y;
                    float r2_z_4 = r2_xyzw_4.z;
                    float r2_w_2 = r2_xyzw_4.w;
                    float4 r2_xyzw_5 = mad(cb5_values[1].xxyz, i.texcoord5.xxxx, float4(r2_y_4, r2_y_4, r2_z_4, r2_w_2));
                    float r2_y_5 = r2_xyzw_5.y;
                    float r2_z_5 = r2_xyzw_5.z;
                    float r2_w_3 = r2_xyzw_5.w;
                    float4 r2_xyzw_6 = mad(cb5_values[3].xxyz, i.texcoord5.zzzz, float4(r2_y_5, r2_y_5, r2_z_5, r2_w_3));
                    float r2_y_6 = r2_xyzw_6.y;
                    float r2_z_6 = r2_xyzw_6.z;
                    float r2_w_4 = r2_xyzw_6.w;
                    float4 r2_xyzw_7 = (float4(r2_y_6, r2_y_6, r2_z_6, r2_w_4) + cb5_values[4].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_5 = r2_xyzw_7.w;
                    float4 r2_xyzw_9 = (((cb5_values[0].y == 1)).xxxx ? float4(r2_y_7, r2_z_7, r2_w_5, r2_y_7) : i.texcoord5.xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_8 = r2_xyzw_9.y;
                    float r2_z_8 = r2_xyzw_9.z;
                    float4 r2_xyzw_10 = (float4(r2_x_9, r2_y_8, r2_z_8, r2_x_9) + -cb5_values[6].xyzx);
                    float r2_x_10 = r2_xyzw_10.x;
                    float r2_y_9 = r2_xyzw_10.y;
                    float r2_z_9 = r2_xyzw_10.z;
                    float r2_y_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).y;
                    float r2_z_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).z;
                    float r2_w_6 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).w;
                    float r2_y_11 = mad(r2_y_10, 0.25, 0.75);
                    float r3_w_1 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r2_x_11 = max(r2_y_11, r3_w_1);
                    float4 r2_xyzw_12 = t5.Sample(sampler_linear_clamp, (float4(r2_x_11, r2_z_10, r2_w_6, r2_x_11)).xyz);
                    r2_x_13 = r2_xyzw_12.x;
                    r2_y_13 = r2_xyzw_12.y;
                    r2_z_12 = r2_xyzw_12.z;
                    r2_w_8 = r2_xyzw_12.w;
                }
                else
                {
                    float r2_x_7 = (float4(1, 1, 1, 1)).x;
                    float4 r2_xyzw_3 = float4(1, 1, 1, 1);
                    float r2_y_3 = r2_xyzw_3.y;
                    float r2_z_3 = r2_xyzw_3.z;
                    float r2_w_1 = r2_xyzw_3.w;
                    r2_x_13 = r2_x_7;
                    r2_y_13 = r2_y_3;
                    r2_z_12 = r2_z_3;
                    r2_w_8 = r2_w_1;
                }
                float r2_y_14 = (r1_w_8 < 0.99);
                float r2_y_27;
                if (r2_y_14)
                {
                    float4 r9_xyzw_2 = (i.texcoord5.yyyy * cb3_values[9].xyzw);
                    float4 r9_xyzw_3 = mad(cb3_values[8].xyzw, i.texcoord5.xxxx, r9_xyzw_2);
                    float4 r9_xyzw_4 = mad(cb3_values[10].xyzw, i.texcoord5.zzzz, r9_xyzw_3);
                    float4 r9_xyzw_5 = (r9_xyzw_4 + cb3_values[11].xyzw);
                    float4 r2_xyzw_16 = (r9_xyzw_5.xxyz / r9_xyzw_5.wwww);
                    float r2_y_16 = r2_xyzw_16.y;
                    float r2_z_13 = r2_xyzw_16.z;
                    float r2_w_9 = r2_xyzw_16.w;
                    float2 r9_xy_7 = (floor((mad(float4(r2_y_16, r2_z_13, r2_y_16, r2_y_16), cb0_values[8].zwzz, float4(0.5, 0.5, 0, 0))).xyxx)).xy;
                    float4 r2_xyzw_17 = mad(float4(r2_y_16, r2_y_16, r2_z_13, r2_y_16), cb0_values[8].zzwz, -r9_xy_7.xxyx);
                    float r2_y_17 = r2_xyzw_17.y;
                    float r2_z_14 = r2_xyzw_17.z;
                    float4 r10_xyzw_1 = (float4(r2_y_17, r2_y_17, r2_z_14, r2_z_14) + float4(0.5, 1, 0.5, 1));
                    float2 r11_xw_1 = ((r10_xyzw_1.xxxz * r10_xyzw_1.xxxz)).xw;
                    float4 r9_xyzw_6 = mad(r11_xw_1.xxxy, float4(0, 0, 0.5, 0.5), -float4(r2_y_17, r2_y_17, r2_y_17, r2_z_14));
                    float r9_z_6 = r9_xyzw_6.z;
                    float r9_w_5 = r9_xyzw_6.w;
                    float2 r10_xz_2 = ((-float4(r2_y_17, r2_y_17, r2_z_14, r2_y_17) + float4(1, 0, 1, 0))).xz;
                    float2 r12_xy_1 = (min(float4(r2_y_17, r2_z_14, r2_y_17, r2_y_17), float4(0, 0, 0, 0))).xy;
                    float2 r10_xz_3 = (mad(-r12_xy_1.xxyx, r12_xy_1.xxyx, r10_xz_2.xxyx)).xz;
                    float4 r2_xyzw_18 = max(float4(r2_y_17, r2_y_17, r2_z_14, r2_y_17), float4(0, 0, 0, 0));
                    float r2_y_18 = r2_xyzw_18.y;
                    float r2_z_15 = r2_xyzw_18.z;
                    float4 r2_xyzw_19 = mad(-float4(r2_y_18, r2_y_18, r2_z_15, r2_y_18), float4(r2_y_18, r2_y_18, r2_z_15, r2_y_18), r10_xyzw_1.yywy);
                    float r2_y_19 = r2_xyzw_19.y;
                    float r2_z_16 = r2_xyzw_19.z;
                    float r12_x_2 = r9_z_6;
                    float r12_y_2 = r10_xz_3.x;
                    float r12_z_1 = r2_y_19;
                    float r12_w_1 = r11_xw_1.x;
                    float4 r12_xyzw_3 = (float4(r12_x_2, r12_y_2, r12_z_1, r12_w_1) * float4(0.44444, 0.44444, 0.44444, 0.22222));
                    float r11_x_2 = r9_w_5;
                    float r11_y_1 = r10_xz_3.y;
                    float r11_z_1 = r2_z_16;
                    float4 r10_xyzw_4 = (float4(r11_x_2, r11_y_1, r11_z_1, r11_xw_1.y) * float4(0.44444, 0.44444, 0.44444, 0.22222));
                    float4 r11_xyzw_3 = (r12_xyzw_3.ywyw + r12_xyzw_3.xzxz);
                    float4 r13_xyzw_1 = (r10_xyzw_4.yyww + r10_xyzw_4.xxzz);
                    float4 r2_xyzw_20 = (r12_xyzw_3.yywy / r11_xyzw_3.zzwz);
                    float r2_y_20 = r2_xyzw_20.y;
                    float r2_z_17 = r2_xyzw_20.z;
                    float4 r2_xyzw_21 = (float4(r2_y_20, r2_y_20, r2_z_17, r2_y_20) + float4(0, -1.5, 0.5, 0));
                    float r2_y_21 = r2_xyzw_21.y;
                    float r2_z_18 = r2_xyzw_21.z;
                    float4 r9_xyzw_7 = (r10_xyzw_4.yyyw / r13_xyzw_1.yyyw);
                    float r9_z_7 = r9_xyzw_7.z;
                    float r9_w_6 = r9_xyzw_7.w;
                    float4 r9_xyzw_8 = (float4(r9_z_7, r9_z_7, r9_z_7, r9_w_6) + float4(0, 0, -1.5, 0.5));
                    float r9_z_8 = r9_xyzw_8.z;
                    float r9_w_7 = r9_xyzw_8.w;
                    float4 r10_xyzw_5 = (float4(r2_y_21, r2_z_18, r2_y_21, r2_y_21) * cb0_values[8].xxxx);
                    float r10_x_5 = r10_xyzw_5.x;
                    float r10_y_3 = r10_xyzw_5.y;
                    float r10_z_5 = ((float4(r9_z_8, r9_z_8, r9_z_8, r9_w_7) * cb0_values[8].yyyy)).z;
                    float r10_w_3 = ((float4(r9_z_8, r9_z_8, r9_z_8, r9_w_7) * cb0_values[8].yyyy)).w;
                    float4 r11_xyzw_4 = (r11_xyzw_3 * r13_xyzw_1);
                    float4 r12_xyzw_4 = mad(r9_xy_7.xyxy, cb0_values[8].xyxy, float4(r10_x_5, r10_z_5, r10_y_3, r10_z_5));
                    float r2_y_22 = t6.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r12_xyzw_4.xyxx).xy, r2_w_9);
                    float r2_z_19 = t6.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r12_xyzw_4.zwzz).xy, r2_w_9);
                    float r2_z_20 = (r2_z_19 * r11_xyzw_4.y);
                    float r2_y_23 = mad(r11_xyzw_4.x, r2_y_22, r2_z_20);
                    float r9_x_8 = (mad(r9_xy_7.xyxy, cb0_values[8].xyxy, float4(r10_x_5, r10_w_3, r10_y_3, r10_w_3))).x;
                    float r9_y_8 = (mad(r9_xy_7.xyxy, cb0_values[8].xyxy, float4(r10_x_5, r10_w_3, r10_y_3, r10_w_3))).y;
                    float4 r9_xyzw_9 = mad(r9_xy_7.xyxy, cb0_values[8].xyxy, float4(r10_x_5, r10_w_3, r10_y_3, r10_w_3));
                    float r9_z_9 = r9_xyzw_9.z;
                    float r9_w_8 = r9_xyzw_9.w;
                    float r2_z_21 = t6.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r9_x_8, r9_y_8, r9_x_8, r9_x_8)).xy, r2_w_9);
                    float r2_y_24 = mad(r11_xyzw_4.z, r2_z_21, r2_y_23);
                    float r2_z_22 = t6.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r9_z_9, r9_w_8, r9_z_9, r9_z_9)).xy, r2_w_9);
                    float r2_y_25 = mad(r11_xyzw_4.w, r2_z_22, r2_y_24);
                    float r2_z_23 = (-cb3_values[24].x + 1);
                    float r2_y_26 = mad(r2_y_25, r2_z_23, cb3_values[24].x);
                    r2_y_27 = r2_y_26;
                }
                else
                {
                    float r2_y_15 = 1;
                    r2_y_27 = r2_y_15;
                }
                float r1_w_9 = mad(r1_w_8, (-r2_y_27 + saturate(dot(float4(r2_x_13, r2_y_13, r2_z_12, r2_w_8), unity_OcclusionMaskSelector))), r2_y_27);
                float4 r2_xyzw_28 = (r8_xyzw_4.xxyx / r8_xyzw_4.wwww);
                float r2_y_28 = r2_xyzw_28.y;
                float r2_z_25 = r2_xyzw_28.z;
                float4 r2_xyzw_29 = (float4(r2_y_28, r2_y_28, r2_z_25, r2_y_28) + float4(0, 0.5, 0.5, 0));
                float r2_y_29 = r2_xyzw_29.y;
                float r2_z_26 = r2_xyzw_29.z;
                float r2_y_30 = (_OcclusionMap.Sample(sampler_OcclusionMap, (float4(r2_y_29, r2_z_26, r2_y_29, r2_y_29)).xy)).y;
                float r2_y_31 = dot(r8_xyzw_4.xyzx, r8_xyzw_4.xyzx);
                float r2_y_32 = (t4.Sample(sampler_linear_clamp3, (r2_y_31.xxxx).xy)).y;
                float r1_w_10 = (r1_w_9 * (r2_y_32 * (r2_y_30 * asfloat(asint((float)((0 < r8_xyzw_4.z))) & asint(1065353216)))));
                float r2_x_20 = dot(i.texcoord2.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_y_33 = dot(i.texcoord3.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_z_27 = dot(i.texcoord4.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_w_11 = dot(float4(r2_x_20, r2_y_33, r2_z_27, r2_x_20), float4(r2_x_20, r2_y_33, r2_z_27, r2_x_20));
                float r2_w_12 = rsqrt(r2_w_11);
                float r2_x_21 = ((r2_w_12.xxxx * float4(r2_x_20, r2_y_33, r2_z_27, r2_x_20))).x;
                float4 r2_xyzw_34 = (r2_w_12.xxxx * float4(r2_x_20, r2_y_33, r2_z_27, r2_x_20));
                float r2_y_34 = r2_xyzw_34.y;
                float r2_z_28 = r2_xyzw_34.z;
                float4 r6_xyzw_4 = (r1_w_10.xxxx * _LightColor0.xyzx);
                float r6_x_4 = r6_xyzw_4.x;
                float r6_y_3 = r6_xyzw_4.y;
                float r6_z_3 = r6_xyzw_4.z;
                float r1_w_11 = max(r7_xyz_1.y, r7_xyz_1.x);
                float r1_w_12 = max(r7_xyz_1.z, r1_w_11);
                float r1_w_13 = (-r1_w_12 + 1);
                float r1_w_14 = mad(-cb0_values[15].x, r5_xyzw_1.w, 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r2_x_21, r2_y_34, r2_z_28, r2_x_21), unitViewDir_xyz_1.xyzx);
                float r2_w_13 = saturate(dot(float4(r2_x_21, r2_y_34, r2_z_28, r2_x_21), r1_xyz_1.xyzx));
                float r2_x_22 = saturate(dot(float4(r2_x_21, r2_y_34, r2_z_28, r2_x_21), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_14.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_13 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_14 * r1_w_14);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(r0_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * mad(r2_w_13, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_13, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r2_x_22, r0_z_9, -r2_x_22), r2_x_22, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_w_13.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r7_xyz_1.xyzx, r7_xyz_1.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r6_x_4, r6_y_3, r6_z_3, r6_x_4));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r6_x_4, r6_x_4, r6_y_3, r6_z_3) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_15 = (r0_x_5 * r0_x_5);
                float r1_w_16 = (r1_w_15 * r1_w_15);
                float4 r2_xyzw_23 = mad(-_SpecColor.xyzx, r5_xyzw_1.xyzx, float4(1, 1, 1, 0));
                float r2_x_23 = r2_xyzw_23.x;
                float r2_y_35 = r2_xyzw_23.y;
                float r2_z_29 = r2_xyzw_23.z;
                float4 r2_xyzw_24 = mad(float4(r2_x_23, r2_y_35, r2_z_29, r2_x_23), ((r0_x_5 * r1_w_16)).xxxx, r7_xyz_1.xyzx);
                float r2_x_24 = r2_xyzw_24.x;
                float r2_y_36 = r2_xyzw_24.y;
                float r2_z_30 = r2_xyzw_24.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_24, r2_y_36, r2_z_30, r2_x_24));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(((r1_w_13.xxxx * ((r4_xyz_1.xyzx * cb0_values[13].xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7))).xyz;
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
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_linear_clamp3;
            SamplerState sampler_MainTex;
            SamplerState sampler_SpecGlossMap;
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _SpecGlossMap;
            Texture2D _OcclusionMap;
            Texture2D t4;
            Texture3D t5;
            Texture2D t6;
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
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program94Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program94Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program48Output vert(program48Input i)
            {
                program48Output o = (program48Output)0;
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
                float4 clipPos_xyzw_4 = (worldPos_xyzw_4.yyyy * _EmissionColor);
                float4 clipPos_xyzw_5 = mad(_Color, worldPos_xyzw_4.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb0_values[6].xyzw, worldPos_xyzw_4.zzzz, clipPos_xyzw_5);
                o.texcoord6.xyzw = mad(_MainTex_ST, worldPos_xyzw_4.wwww, clipPos_xyzw_6);
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program94Output frag(program94Input i)
            {
                program94Output o = (program94Output)0;
                float3 r0_xyz_1 = ((-i.texcoord5.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord5.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float3 r4_xyz_1 = (_MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy)).xyz;
                float4 r5_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord1.xyxx).xy);
                float3 r6_xyz_1 = (_SpecGlossMap.Sample(sampler_SpecGlossMap, (i.texcoord0.zwzz).xy)).xyz;
                float r6_x_2 = (r6_xyz_1.z * r6_xyz_1.x);
                float4 r6_xyzw_3 = mad(float4(r6_x_2, r6_xyz_1.y, r6_x_2, r6_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r6_x_3 = r6_xyzw_3.x;
                float r6_y_2 = r6_xyzw_3.y;
                float r1_w_3 = dot(float4(r6_x_3, r6_y_2, r6_x_3, r6_x_3), float4(r6_x_3, r6_y_2, r6_x_3, r6_x_3));
                float r1_w_4 = min(r1_w_3, 1);
                float r1_w_5 = (-r1_w_4 + 1);
                float r6_z_2 = sqrt(r1_w_5);
                float3 r7_xyz_1 = ((r5_xyzw_1.xyzx * _SpecColor.xyzx)).xyz;
                float4 r8_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord5.zzzz, mad(cb0_values[4].xyzw, i.texcoord5.xxxx, (i.texcoord5.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r9_x_1 = cb4_values[9].z;
                float r9_y_1 = cb4_values[10].z;
                float r9_z_1 = cb4_values[11].z;
                float r1_w_6 = dot(viewDir_xyz_1.xyzx, float4(r9_x_1, r9_y_1, r9_z_1, r9_x_1));
                float3 r2_xyz_2 = ((i.texcoord5.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_7 = mad(cb3_values[25].w, (-r1_w_6 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_6);
                float r1_w_8 = saturate(mad(r1_w_7, cb3_values[24].z, cb3_values[24].w));
                float r2_x_13;
                float r2_y_13;
                float r2_z_12;
                float r2_w_8;
                if ((cb5_values[0].x == 1))
                {
                    float4 r2_xyzw_4 = (i.texcoord5.yyyy * cb5_values[2].xxyz);
                    float r2_y_4 = r2_xyzw_4.y;
                    float r2_z_4 = r2_xyzw_4.z;
                    float r2_w_2 = r2_xyzw_4.w;
                    float4 r2_xyzw_5 = mad(cb5_values[1].xxyz, i.texcoord5.xxxx, float4(r2_y_4, r2_y_4, r2_z_4, r2_w_2));
                    float r2_y_5 = r2_xyzw_5.y;
                    float r2_z_5 = r2_xyzw_5.z;
                    float r2_w_3 = r2_xyzw_5.w;
                    float4 r2_xyzw_6 = mad(cb5_values[3].xxyz, i.texcoord5.zzzz, float4(r2_y_5, r2_y_5, r2_z_5, r2_w_3));
                    float r2_y_6 = r2_xyzw_6.y;
                    float r2_z_6 = r2_xyzw_6.z;
                    float r2_w_4 = r2_xyzw_6.w;
                    float4 r2_xyzw_7 = (float4(r2_y_6, r2_y_6, r2_z_6, r2_w_4) + cb5_values[4].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_5 = r2_xyzw_7.w;
                    float4 r2_xyzw_9 = (((cb5_values[0].y == 1)).xxxx ? float4(r2_y_7, r2_z_7, r2_w_5, r2_y_7) : i.texcoord5.xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_8 = r2_xyzw_9.y;
                    float r2_z_8 = r2_xyzw_9.z;
                    float4 r2_xyzw_10 = (float4(r2_x_9, r2_y_8, r2_z_8, r2_x_9) + -cb5_values[6].xyzx);
                    float r2_x_10 = r2_xyzw_10.x;
                    float r2_y_9 = r2_xyzw_10.y;
                    float r2_z_9 = r2_xyzw_10.z;
                    float r2_y_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).y;
                    float r2_z_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).z;
                    float r2_w_6 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).w;
                    float r2_y_11 = mad(r2_y_10, 0.25, 0.75);
                    float r3_w_1 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r2_x_11 = max(r2_y_11, r3_w_1);
                    float4 r2_xyzw_12 = t5.Sample(sampler_linear_clamp, (float4(r2_x_11, r2_z_10, r2_w_6, r2_x_11)).xyz);
                    r2_x_13 = r2_xyzw_12.x;
                    r2_y_13 = r2_xyzw_12.y;
                    r2_z_12 = r2_xyzw_12.z;
                    r2_w_8 = r2_xyzw_12.w;
                }
                else
                {
                    float r2_x_7 = (float4(1, 1, 1, 1)).x;
                    float4 r2_xyzw_3 = float4(1, 1, 1, 1);
                    float r2_y_3 = r2_xyzw_3.y;
                    float r2_z_3 = r2_xyzw_3.z;
                    float r2_w_1 = r2_xyzw_3.w;
                    r2_x_13 = r2_x_7;
                    r2_y_13 = r2_y_3;
                    r2_z_12 = r2_z_3;
                    r2_w_8 = r2_w_1;
                }
                float4 r9_xyzw_2 = (i.texcoord5.yyyy * cb3_values[9].xyzw);
                float4 r9_xyzw_3 = mad(cb3_values[8].xyzw, i.texcoord5.xxxx, r9_xyzw_2);
                float4 r9_xyzw_4 = mad(cb3_values[10].xyzw, i.texcoord5.zzzz, r9_xyzw_3);
                float4 r9_xyzw_5 = (r9_xyzw_4 + cb3_values[11].xyzw);
                float4 r2_xyzw_14 = (r9_xyzw_5.xxyz / r9_xyzw_5.wwww);
                float r2_y_14 = r2_xyzw_14.y;
                float r2_z_13 = r2_xyzw_14.z;
                float r2_w_9 = r2_xyzw_14.w;
                float r2_y_15 = t6.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r2_y_14, r2_z_13, r2_y_14, r2_y_14)).xy, r2_w_9);
                float r2_z_14 = (-cb3_values[24].x + 1);
                float r2_y_16 = mad(r2_y_15, r2_z_14, cb3_values[24].x);
                float r1_w_9 = mad(r1_w_8, (-r2_y_16 + saturate(dot(float4(r2_x_13, r2_y_13, r2_z_12, r2_w_8), unity_OcclusionMaskSelector))), r2_y_16);
                float4 r2_xyzw_17 = (r8_xyzw_4.xxyx / r8_xyzw_4.wwww);
                float r2_y_17 = r2_xyzw_17.y;
                float r2_z_15 = r2_xyzw_17.z;
                float4 r2_xyzw_18 = (float4(r2_y_17, r2_y_17, r2_z_15, r2_y_17) + float4(0, 0.5, 0.5, 0));
                float r2_y_18 = r2_xyzw_18.y;
                float r2_z_16 = r2_xyzw_18.z;
                float r2_y_19 = (_OcclusionMap.Sample(sampler_OcclusionMap, (float4(r2_y_18, r2_z_16, r2_y_18, r2_y_18)).xy)).y;
                float r2_y_20 = dot(r8_xyzw_4.xyzx, r8_xyzw_4.xyzx);
                float r2_y_21 = (t4.Sample(sampler_linear_clamp3, (r2_y_20.xxxx).xy)).y;
                float r1_w_10 = (r1_w_9 * (r2_y_21 * (r2_y_19 * asfloat(asint((float)((0 < r8_xyzw_4.z))) & asint(1065353216)))));
                float r2_x_20 = dot(i.texcoord2.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_y_22 = dot(i.texcoord3.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_z_17 = dot(i.texcoord4.xyzx, float4(r6_x_3, r6_y_2, r6_z_2, r6_x_3));
                float r2_w_10 = dot(float4(r2_x_20, r2_y_22, r2_z_17, r2_x_20), float4(r2_x_20, r2_y_22, r2_z_17, r2_x_20));
                float r2_w_11 = rsqrt(r2_w_10);
                float4 r2_xyzw_21 = (r2_w_11.xxxx * float4(r2_x_20, r2_y_22, r2_z_17, r2_x_20));
                float r2_x_21 = r2_xyzw_21.x;
                float r2_y_23 = r2_xyzw_21.y;
                float r2_z_18 = r2_xyzw_21.z;
                float4 r6_xyzw_4 = (r1_w_10.xxxx * _LightColor0.xyzx);
                float r6_x_4 = r6_xyzw_4.x;
                float r6_y_3 = r6_xyzw_4.y;
                float r6_z_3 = r6_xyzw_4.z;
                float r1_w_11 = max(r7_xyz_1.y, r7_xyz_1.x);
                float r1_w_12 = max(r7_xyz_1.z, r1_w_11);
                float r1_w_13 = (-r1_w_12 + 1);
                float r1_w_14 = mad(-cb0_values[10].x, r5_xyzw_1.w, 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r2_x_21, r2_y_23, r2_z_18, r2_x_21), unitViewDir_xyz_1.xyzx);
                float r2_w_12 = saturate(dot(float4(r2_x_21, r2_y_23, r2_z_18, r2_x_21), r1_xyz_1.xyzx));
                float r2_x_22 = saturate(dot(float4(r2_x_21, r2_y_23, r2_z_18, r2_x_21), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_14.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_12 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_14 * r1_w_14);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(r0_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * mad(r2_w_12, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_12, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r2_x_22, r0_z_9, -r2_x_22), r2_x_22, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_w_12.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r7_xyz_1.xyzx, r7_xyz_1.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r6_x_4, r6_y_3, r6_z_3, r6_x_4));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r6_x_4, r6_x_4, r6_y_3, r6_z_3) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_15 = (r0_x_5 * r0_x_5);
                float r1_w_16 = (r1_w_15 * r1_w_15);
                float4 r2_xyzw_23 = mad(-_SpecColor.xyzx, r5_xyzw_1.xyzx, float4(1, 1, 1, 0));
                float r2_x_23 = r2_xyzw_23.x;
                float r2_y_24 = r2_xyzw_23.y;
                float r2_z_19 = r2_xyzw_23.z;
                float4 r2_xyzw_24 = mad(float4(r2_x_23, r2_y_24, r2_z_19, r2_x_23), ((r0_x_5 * r1_w_16)).xxxx, r7_xyz_1.xyzx);
                float r2_x_24 = r2_xyzw_24.x;
                float r2_y_25 = r2_xyzw_24.y;
                float r2_z_20 = r2_xyzw_24.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_24, r2_y_25, r2_z_20, r2_x_24));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(((r1_w_13.xxxx * ((r4_xyz_1.xyzx * cb0_values[8].xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7))).xyz;
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
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float2 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program93Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float2 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program93Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program47Output vert(program47Input i)
            {
                program47Output o = (program47Output)0;
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
                float2 clipPos_xy_4 = ((worldPos_xyzw_4.yyyy * _EmissionColor.xyxx)).xy;
                float2 clipPos_xy_5 = (mad(_Color.xyxx, worldPos_xyzw_4.xxxx, clipPos_xy_4.xyxx)).xy;
                float2 clipPos_xy_6 = (mad(cb0_values[6].xyxx, worldPos_xyzw_4.zzzz, clipPos_xy_5.xyxx)).xy;
                o.texcoord6.xy = (mad(_MainTex_ST.xyxx, worldPos_xyzw_4.wwww, clipPos_xy_6.xyxx)).xy;
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program93Output frag(program93Input i)
            {
                program93Output o = (program93Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord5.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float3 r2_xyz_1 = (_MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy)).xyz;
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord1.xyxx).xy);
                float3 r4_xyz_1 = (_SpecGlossMap.Sample(sampler_SpecGlossMap, (i.texcoord0.zwzz).xy)).xyz;
                float r4_x_2 = (r4_xyz_1.z * r4_xyz_1.x);
                float4 r4_xyzw_3 = mad(float4(r4_x_2, r4_xyz_1.y, r4_x_2, r4_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r4_x_3 = r4_xyzw_3.x;
                float r4_y_2 = r4_xyzw_3.y;
                float r1_w_1 = dot(float4(r4_x_3, r4_y_2, r4_x_3, r4_x_3), float4(r4_x_3, r4_y_2, r4_x_3, r4_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r4_z_2 = sqrt(r1_w_3);
                float3 r5_xyz_1 = ((r3_xyzw_1.xyzx * _SpecColor.xyzx)).xyz;
                float r1_w_4 = (unity_ProbeVolumeParams.x == 1);
                float r7_x_10;
                float r7_y_10;
                float r7_z_10;
                float r7_w_4;
                if (r1_w_4)
                {
                    float r1_w_5 = (unity_ProbeVolumeParams.y == 1);
                    float3 r7_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord5.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord5.xxxx, ((i.texcoord5.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r1_w_5.xxxx ? r7_xyz_5.xyzx : i.texcoord5.xyzx)).xyz;
                    float4 r7_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r7_y_8 = r7_xyzw_8.y;
                    float r7_z_8 = r7_xyzw_8.z;
                    float r7_w_2 = r7_xyzw_8.w;
                    float r1_w_6 = mad(r7_y_8, 0.25, 0.75);
                    float r2_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r7_x_8 = max(r1_w_6, r2_w_1);
                    float4 r7_xyzw_9 = t4.Sample(sampler_linear_clamp, (float4(r7_x_8, r7_z_8, r7_w_2, r7_x_8)).xyz);
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
                float r1_w_8 = saturate(dot(float4(r7_x_10, r7_y_10, r7_z_10, r7_w_4), unity_OcclusionMaskSelector));
                float r2_w_3 = (_OcclusionMap.Sample(sampler_OcclusionMap, ((((mad(cb0_values[6].xyxx, i.texcoord5.zzzz, (mad(cb0_values[4].xyxx, i.texcoord5.xxxx, ((i.texcoord5.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx).xy)).w;
                float r1_w_9 = (r1_w_8 * r2_w_3);
                float r6_x_5 = dot(i.texcoord2.xyzx, float4(r4_x_3, r4_y_2, r4_z_2, r4_x_3));
                float r6_y_5 = dot(i.texcoord3.xyzx, float4(r4_x_3, r4_y_2, r4_z_2, r4_x_3));
                float r6_z_1 = dot(i.texcoord4.xyzx, float4(r4_x_3, r4_y_2, r4_z_2, r4_x_3));
                float r2_w_4 = dot(float4(r6_x_5, r6_y_5, r6_z_1, r6_x_5), float4(r6_x_5, r6_y_5, r6_z_1, r6_x_5));
                float r2_w_5 = rsqrt(r2_w_4);
                float4 r4_xyzw_4 = (r2_w_5.xxxx * float4(r6_x_5, r6_y_5, r6_z_1, r6_x_5));
                float r4_x_4 = r4_xyzw_4.x;
                float r4_y_3 = r4_xyzw_4.y;
                float r4_z_3 = r4_xyzw_4.z;
                float4 r6_xyzw_6 = (r1_w_9.xxxx * _LightColor0.xyzx);
                float r6_x_6 = r6_xyzw_6.x;
                float r6_y_6 = r6_xyzw_6.y;
                float r6_z_2 = r6_xyzw_6.z;
                float r1_w_10 = max(r5_xyz_1.y, r5_xyz_1.x);
                float r1_w_11 = max(r5_xyz_1.z, r1_w_10);
                float r1_w_12 = (-r1_w_11 + 1);
                float r1_w_13 = mad(-cb0_values[10].x, r3_xyzw_1.w, 1);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r4_x_4, r4_y_3, r4_z_3, r4_x_4), unitViewDir_xyz_1.xyzx);
                float r1_x_2 = saturate(dot(float4(r4_x_4, r4_y_3, r4_z_3, r4_x_4), _WorldSpaceLightPos0.xyzx));
                float r1_y_2 = saturate(dot(float4(r4_x_4, r4_y_3, r4_z_3, r4_x_4), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_13.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(r0_w_6) + 1);
                float r2_w_6 = (r1_z_4 * r1_z_4);
                float r2_w_7 = (r2_w_6 * r2_w_6);
                float r1_z_5 = (r1_z_4 * r2_w_7);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_13 * r1_w_13);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_z_6 = (-r0_z_8 + 1);
                float r1_w_14 = mad(abs(r0_w_6), r1_z_6, r0_z_8);
                float r1_z_7 = mad(r1_x_2, r1_z_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * r1_z_7);
                float r0_w_8 = mad(r1_x_2, r1_w_14, r0_w_7);
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
                float r0_w_11 = dot(r5_xyz_1.xyzx, r5_xyz_1.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_3 = (r0_y_9.xxxx * float4(r6_x_6, r6_y_6, r6_z_2, r6_x_6));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_5 = r1_xyzw_3.y;
                float r1_z_9 = r1_xyzw_3.z;
                float4 r0_xyzw_10 = (float4(r6_x_6, r6_x_6, r6_y_6, r6_z_2) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_15 = (r0_x_5 * r0_x_5);
                float r1_w_16 = (r1_w_15 * r1_w_15);
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * (mad((mad(-_SpecColor.xyzx, r3_xyzw_1.xyzx, float4(1, 1, 1, 0))).xyzx, ((r0_x_5 * r1_w_16)).xxxx, r5_xyz_1.xyzx)).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(((r1_w_12.xxxx * ((r2_xyz_1.xyzx * cb0_values[8].xyzx)).xyzx)).xyzx, float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7))).xyz;
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
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_MainTex;
            SamplerState sampler_SpecGlossMap;
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _SpecGlossMap;
            Texture2D _OcclusionMap;
            TextureCube t4;
            Texture3D t5;
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
            struct program92Input
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
            struct program92Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program46Output vert(program46Input i)
            {
                program46Output o = (program46Output)0;
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
            program92Output frag(program92Input i)
            {
                program92Output o = (program92Output)0;
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
                    float4 r8_xyzw_9 = t5.Sample(sampler_linear_clamp, (float4(r8_x_8, r8_z_8, r8_w_2, r8_x_8)).xyz);
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
                float r3_w_1 = (t4.Sample(sampler_linear_clamp1, r7_xyz_4.xyz)).w;
                float r2_w_5 = (r2_w_4 * r3_w_1);
                float r1_w_11 = (r1_w_10 * r2_w_5);
                float r7_x_5 = dot(i.texcoord2.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float r7_y_5 = dot(i.texcoord3.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float r7_z_5 = dot(i.texcoord4.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float r2_w_6 = dot(float4(r7_x_5, r7_y_5, r7_z_5, r7_x_5), float4(r7_x_5, r7_y_5, r7_z_5, r7_x_5));
                float r2_w_7 = rsqrt(r2_w_6);
                float4 r5_xyzw_4 = (r2_w_7.xxxx * float4(r7_x_5, r7_y_5, r7_z_5, r7_x_5));
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
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            SamplerState sampler_SpecGlossMap;
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _SpecGlossMap;
            Texture2D _OcclusionMap;
            Texture2D t4;
            Texture3D t5;
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
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program91Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program91Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program45Output vert(program45Input i)
            {
                program45Output o = (program45Output)0;
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
                float4 clipPos_xyzw_4 = (worldPos_xyzw_4.yyyy * _EmissionColor);
                float4 clipPos_xyzw_5 = mad(_Color, worldPos_xyzw_4.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb0_values[6].xyzw, worldPos_xyzw_4.zzzz, clipPos_xyzw_5);
                o.texcoord6.xyzw = mad(_MainTex_ST, worldPos_xyzw_4.wwww, clipPos_xyzw_6);
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program91Output frag(program91Input i)
            {
                program91Output o = (program91Output)0;
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
                float4 r7_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord5.zzzz, mad(cb0_values[4].xyzw, i.texcoord5.xxxx, (i.texcoord5.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
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
                    float4 r8_xyzw_9 = t5.Sample(sampler_linear_clamp, (float4(r8_x_8, r8_z_8, r8_w_2, r8_x_8)).xyz);
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
                float r2_w_3 = (0 < r7_xyzw_4.z);
                float r2_w_4 = asfloat(asint(r2_w_3) & asint(1065353216));
                float r3_w_1 = (_OcclusionMap.Sample(sampler_OcclusionMap, (((((r7_xyzw_4.xyxx / r7_xyzw_4.wwww)).xyxx + float4(0.5, 0.5, 0, 0))).xyxx).xy)).w;
                float r2_w_5 = (r2_w_4 * r3_w_1);
                float r3_w_2 = dot(r7_xyzw_4.xyzx, r7_xyzw_4.xyzx);
                float r3_w_3 = (t4.Sample(sampler_linear_clamp2, (r3_w_2.xxxx).xy)).w;
                float r2_w_6 = (r2_w_5 * r3_w_3);
                float r1_w_11 = (r1_w_10 * r2_w_6);
                float r7_x_5 = dot(i.texcoord2.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float r7_y_5 = dot(i.texcoord3.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float r7_z_5 = dot(i.texcoord4.xyzx, float4(r5_x_3, r5_y_2, r5_z_2, r5_x_3));
                float r2_w_7 = dot(float4(r7_x_5, r7_y_5, r7_z_5, r7_x_5), float4(r7_x_5, r7_y_5, r7_z_5, r7_x_5));
                float r2_w_8 = rsqrt(r2_w_7);
                float4 r5_xyzw_4 = (r2_w_8.xxxx * float4(r7_x_5, r7_y_5, r7_z_5, r7_x_5));
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
            SamplerState sampler_OcclusionMap;
            SamplerState sampler_MainTex;
            SamplerState sampler_SpecGlossMap;
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _SpecGlossMap;
            Texture3D _OcclusionMap;
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
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program90Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program90Output
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
                o.texcoord5.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _SpecGlossMap_ST.xyxx, _SpecGlossMap_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _OcclusionMap_ST.xxxy, _OcclusionMap_ST.zzzw)).zw;
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
                o.texcoord2.y = r2_xyz_3.x;
                o.texcoord2.x = unitWorldTangent_xyz_5.z;
                o.texcoord2.z = unitWorldNormal_xyz_8.y;
                o.texcoord3.x = unitWorldTangent_xyz_5.x;
                o.texcoord4.x = unitWorldTangent_xyz_5.y;
                o.texcoord3.z = unitWorldNormal_xyz_8.z;
                o.texcoord4.z = unitWorldNormal_xyz_8.x;
                o.texcoord3.y = r2_xyz_3.y;
                o.texcoord4.y = r2_xyz_3.z;
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program90Output frag(program90Input i)
            {
                program90Output o = (program90Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord5.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float3 r2_xyz_1 = (_MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy)).xyz;
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord1.xyxx).xy);
                float3 r4_xyz_1 = (_SpecGlossMap.Sample(sampler_SpecGlossMap, (i.texcoord0.zwzz).xy)).xyz;
                float r4_x_2 = (r4_xyz_1.z * r4_xyz_1.x);
                float4 r4_xyzw_3 = mad(float4(r4_x_2, r4_xyz_1.y, r4_x_2, r4_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r4_x_3 = r4_xyzw_3.x;
                float r4_y_2 = r4_xyzw_3.y;
                float r1_w_1 = dot(float4(r4_x_3, r4_y_2, r4_x_3, r4_x_3), float4(r4_x_3, r4_y_2, r4_x_3, r4_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r4_z_2 = sqrt(r1_w_3);
                float3 r5_xyz_1 = ((r3_xyzw_1.xyzx * _SpecColor.xyzx)).xyz;
                float r1_w_4 = (unity_ProbeVolumeParams.x == 1);
                float r6_x_10;
                float r6_y_10;
                float r6_z_10;
                float r6_w_4;
                if (r1_w_4)
                {
                    float r1_w_5 = (unity_ProbeVolumeParams.y == 1);
                    float3 r6_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord5.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord5.xxxx, ((i.texcoord5.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r1_w_5.xxxx ? r6_xyz_5.xyzx : i.texcoord5.xyzx)).xyz;
                    float4 r6_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r6_y_8 = r6_xyzw_8.y;
                    float r6_z_8 = r6_xyzw_8.z;
                    float r6_w_2 = r6_xyzw_8.w;
                    float r1_w_6 = mad(r6_y_8, 0.25, 0.75);
                    float r2_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r6_x_8 = max(r1_w_6, r2_w_1);
                    float4 r6_xyzw_9 = _OcclusionMap.Sample(sampler_OcclusionMap, (float4(r6_x_8, r6_z_8, r6_w_2, r6_x_8)).xyz);
                    r6_x_10 = r6_xyzw_9.x;
                    r6_y_10 = r6_xyzw_9.y;
                    r6_z_10 = r6_xyzw_9.z;
                    r6_w_4 = r6_xyzw_9.w;
                }
                else
                {
                    float4 r6_xyzw_10 = float4(1, 1, 1, 1);
                    r6_x_10 = r6_xyzw_10.x;
                    r6_y_10 = r6_xyzw_10.y;
                    r6_z_10 = r6_xyzw_10.z;
                    r6_w_4 = r6_xyzw_10.w;
                }
                float r1_w_8 = saturate(dot(float4(r6_x_10, r6_y_10, r6_z_10, r6_w_4), unity_OcclusionMaskSelector));
                float r6_x_11 = dot(i.texcoord2.xyzx, float4(r4_x_3, r4_y_2, r4_z_2, r4_x_3));
                float r6_y_11 = dot(i.texcoord3.xyzx, float4(r4_x_3, r4_y_2, r4_z_2, r4_x_3));
                float r6_z_11 = dot(i.texcoord4.xyzx, float4(r4_x_3, r4_y_2, r4_z_2, r4_x_3));
                float r2_w_3 = dot(float4(r6_x_11, r6_y_11, r6_z_11, r6_x_11), float4(r6_x_11, r6_y_11, r6_z_11, r6_x_11));
                float r2_w_4 = rsqrt(r2_w_3);
                float4 r4_xyzw_4 = (r2_w_4.xxxx * float4(r6_x_11, r6_y_11, r6_z_11, r6_x_11));
                float r4_x_4 = r4_xyzw_4.x;
                float r4_y_3 = r4_xyzw_4.y;
                float r4_z_3 = r4_xyzw_4.z;
                float3 r6_xyz_12 = ((r1_w_8.xxxx * _LightColor0.xyzx)).xyz;
                float r1_w_9 = max(r5_xyz_1.y, r5_xyz_1.x);
                float r1_w_10 = max(r5_xyz_1.z, r1_w_9);
                float r1_w_11 = (-r1_w_10 + 1);
                float r1_w_12 = mad(-cb0_values[6].x, r3_xyzw_1.w, 1);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(r4_x_4, r4_y_3, r4_z_3, r4_x_4), unitViewDir_xyz_1.xyzx);
                float r1_x_2 = saturate(dot(float4(r4_x_4, r4_y_3, r4_z_3, r4_x_4), _WorldSpaceLightPos0.xyzx));
                float r1_y_2 = saturate(dot(float4(r4_x_4, r4_y_3, r4_z_3, r4_x_4), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_12.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(r0_w_6) + 1);
                float r2_w_5 = (r1_z_4 * r1_z_4);
                float r2_w_6 = (r2_w_5 * r2_w_5);
                float r1_z_5 = (r1_z_4 * r2_w_6);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_12 * r1_w_12);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_z_6 = (-r0_z_8 + 1);
                float r1_w_13 = mad(abs(r0_w_6), r1_z_6, r0_z_8);
                float r1_z_7 = mad(r1_x_2, r1_z_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * r1_z_7);
                float r0_w_8 = mad(r1_x_2, r1_w_13, r0_w_7);
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
                float r0_w_11 = dot(r5_xyz_1.xyzx, r5_xyz_1.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_3 = (r0_y_9.xxxx * r6_xyz_12.xyzx);
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_5 = r1_xyzw_3.y;
                float r1_z_9 = r1_xyzw_3.z;
                float4 r0_xyzw_10 = (r6_xyz_12.xxyz * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_14 = (r0_x_5 * r0_x_5);
                float r1_w_15 = (r1_w_14 * r1_w_14);
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * (mad((mad(-_SpecColor.xyzx, r3_xyzw_1.xyzx, float4(1, 1, 1, 0))).xyzx, ((r0_x_5 * r1_w_15)).xxxx, r5_xyz_1.xyzx)).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(((r1_w_11.xxxx * ((r2_xyz_1.xyzx * cb0_values[4].xyzx)).xyzx)).xyzx, float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7))).xyz;
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
            SamplerState sampler_SpecGlossMap;
            SamplerState sampler_BumpMap;
            SamplerState sampler_OcclusionMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _SpecGlossMap;
            Texture2D _OcclusionMap;
            Texture3D t4;
            struct program120Input
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
            struct program120Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord6 : TEXCOORD6;
                float3 texcoord7 : TEXCOORD7;
            };
            struct program126Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord6 : TEXCOORD6;
                float3 texcoord7 : TEXCOORD7;
            };
            struct program126Output
            {
                float4 sv_Target0 : SV_Target;
                float4 sv_Target1 : SV_Target1;
                float4 sv_Target2 : SV_Target2;
                float4 sv_Target3 : SV_Target3;
            };
            #pragma vertex vert
            program120Output vert(program120Input i)
            {
                program120Output o = (program120Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float3 r0_xyz_4 = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _SpecGlossMap_ST.xyxx, _SpecGlossMap_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _OcclusionMap_ST.xxxy, _OcclusionMap_ST.zzzw)).zw;
                o.texcoord2.w = r0_xyz_4.x;
                float3 worldTangent_xyz_2 = ((i.tangent0.yyyy * cb2_values[1].yzxy)).xyz;
                float3 worldTangent_xyz_3 = (mad(cb2_values[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_2.xyzx)).xyz;
                float3 worldTangent_xyz_4 = (mad(cb2_values[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_3.xyzx)).xyz;
                float3 unitWorldTangent_xyz_5 = (((rsqrt(dot(worldTangent_xyz_4.xyzx, worldTangent_xyz_4.xyzx))).xxxx * worldTangent_xyz_4.xyzx)).xyz;
                o.texcoord2.x = unitWorldTangent_xyz_5.z;
                float worldNormal_x_4 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float4 unitWorldNormal_xyzw_5 = ((rsqrt(dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4)))).xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_z_4));
                float3 r3_xyz_3 = ((((i.tangent0.w * cb2_values[9].w)).xxxx * (mad(unitWorldNormal_xyzw_5.ywxy, unitWorldTangent_xyz_5.yzxy, ((unitWorldTangent_xyz_5.xyzx * unitWorldNormal_xyzw_5.wxyw)).xyzx)).xyzx)).xyz;
                o.texcoord2.y = r3_xyz_3.x;
                o.texcoord2.z = unitWorldNormal_xyzw_5.x;
                o.texcoord3.x = unitWorldTangent_xyz_5.x;
                o.texcoord4.x = unitWorldTangent_xyz_5.y;
                o.texcoord3.w = r0_xyz_4.y;
                o.texcoord4.w = r0_xyz_4.z;
                o.texcoord3.y = r3_xyz_3.y;
                o.texcoord4.y = r3_xyz_3.z;
                o.texcoord3.z = unitWorldNormal_xyzw_5.y;
                o.texcoord4.z = unitWorldNormal_xyzw_5.w;
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                float4 r1_xyzw_6 = (unitWorldNormal_xyzw_5.ywzx * unitWorldNormal_xyzw_5);
                float r2_x_6 = dot(cb1_values[42].xyzw, r1_xyzw_6);
                float r2_y_6 = dot(cb1_values[43].xyzw, r1_xyzw_6);
                float r2_z_6 = dot(cb1_values[44].xyzw, r1_xyzw_6);
                o.texcoord7.xyz = (mad(cb1_values[45].xyzx, (mad(unitWorldNormal_xyzw_5.x, unitWorldNormal_xyzw_5.x, (unitWorldNormal_xyzw_5.y * unitWorldNormal_xyzw_5.y))).xxxx, float4(r2_x_6, r2_y_6, r2_z_6, r2_x_6))).xyz;
                return o;
            }
            #pragma fragment frag
            program126Output frag(program126Input i)
            {
                program126Output o = (program126Output)0;
                float3 r0_xyz_1 = (_MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy)).xyz;
                float3 r0_xyz_2 = ((r0_xyz_1.xyzx * _Color.xyzx)).xyz;
                float4 r1_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord1.xyxx).xy);
                float3 r2_xyz_1 = (_SpecGlossMap.Sample(sampler_SpecGlossMap, (i.texcoord0.zwzz).xy)).xyz;
                float r2_x_2 = (r2_xyz_1.z * r2_xyz_1.x);
                float4 r2_xyzw_3 = mad(float4(r2_x_2, r2_xyz_1.y, r2_x_2, r2_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r2_x_3 = r2_xyzw_3.x;
                float r2_y_2 = r2_xyzw_3.y;
                float r0_w_1 = dot(float4(r2_x_3, r2_y_2, r2_x_3, r2_x_3), float4(r2_x_3, r2_y_2, r2_x_3, r2_x_3));
                float r0_w_2 = min(r0_w_1, 1);
                float r0_w_3 = (-r0_w_2 + 1);
                float r2_z_2 = sqrt(r0_w_3);
                float3 r1_xyz_2 = ((r1_xyzw_1.xyzx * _SpecColor.xyzx)).xyz;
                o.sv_Target1.w = (r1_xyzw_1.w * _Glossiness);
                float r0_w_4 = (_OcclusionMap.Sample(sampler_OcclusionMap, (i.texcoord1.zwzz).xy)).w;
                float r3_x_1 = dot(i.texcoord2.xyzx, float4(r2_x_3, r2_y_2, r2_z_2, r2_x_3));
                float r3_y_1 = dot(i.texcoord3.xyzx, float4(r2_x_3, r2_y_2, r2_z_2, r2_x_3));
                float r3_z_1 = dot(i.texcoord4.xyzx, float4(r2_x_3, r2_y_2, r2_z_2, r2_x_3));
                float r1_w_2 = dot(float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1), float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float r1_w_3 = rsqrt(r1_w_2);
                float4 r2_xyzw_4 = (r1_w_3.xxxx * float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float r2_x_4 = r2_xyzw_4.x;
                float r2_y_3 = r2_xyzw_4.y;
                float r2_z_3 = r2_xyzw_4.z;
                float r1_w_4 = (cb2_values[0].x == 1);
                float3 r4_xyz_5;
                if (r1_w_4)
                {
                    float r1_w_5 = (cb2_values[0].y == 1);
                    float3 r3_xyz_5 = (((mad(cb2_values[3].xyzx, i.texcoord4.wwww, (mad(cb2_values[1].xyzx, i.texcoord2.wwww, ((i.texcoord3.wwww * cb2_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb2_values[4].xyzx)).xyz;
                    float TEXCOORD2_y_2 = i.texcoord2.w;
                    float TEXCOORD3_z_2 = i.texcoord3.w;
                    float TEXCOORD4_w_1 = i.texcoord4.w;
                    float4 r3_xyzw_8 = (((((r1_w_5.xxxx ? r3_xyz_5.xyzx : float4(TEXCOORD2_y_2, TEXCOORD3_z_2, TEXCOORD4_w_1, TEXCOORD2_y_2))).xyzx + -cb2_values[6].xyzx)).xxyz * cb2_values[5].xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_1 = r3_xyzw_8.w;
                    float r1_w_6 = (r3_y_8 * 0.25);
                    float r3_y_9 = (cb2_values[0].z * 0.5);
                    float r1_w_7 = max(r1_w_6, r3_y_9);
                    float r3_x_8 = min(mad(-cb2_values[0].z, 0.5, 0.25), r1_w_7);
                    float4 r4_xyzw_3 = t4.Sample(sampler_linear_clamp, (float4(r3_x_8, r3_z_8, r3_w_1, r3_x_8)).xyz);
                    float4 r5_xyzw_2 = t4.Sample(sampler_linear_clamp, (((float4(r3_x_8, r3_z_8, r3_w_1, r3_x_8) + float4(0.25, 0, 0, 0))).xyzx).xyz);
                    float4 r3_xyzw_9 = (float4(r3_x_8, r3_z_8, r3_w_1, r3_x_8) + float4(0.5, 0, 0, 0));
                    float r3_x_9 = r3_xyzw_9.x;
                    float r3_y_10 = r3_xyzw_9.y;
                    float r3_z_9 = r3_xyzw_9.z;
                    float4 r3_xyzw_10 = t4.Sample(sampler_linear_clamp, (float4(r3_x_9, r3_y_10, r3_z_9, r3_x_9)).xyz);
                    float r2_w_2 = 1;
                    float r4_x_4 = dot(r4_xyzw_3, float4(r2_x_4, r2_y_3, r2_z_3, r2_w_2));
                    float r4_y_4 = dot(r5_xyzw_2, float4(r2_x_4, r2_y_3, r2_z_3, r2_w_2));
                    float r4_z_4 = dot(r3_xyzw_10, float4(r2_x_4, r2_y_3, r2_z_3, r2_w_2));
                    r4_xyz_5 = float3(r4_x_4, r4_y_4, r4_z_4);
                }
                else
                {
                    float r2_w_1 = 1;
                    float r4_x_1 = dot(cb1_values[39].xyzw, float4(r2_x_4, r2_y_3, r2_z_3, r2_w_1));
                    float r4_y_1 = dot(cb1_values[40].xyzw, float4(r2_x_4, r2_y_3, r2_z_3, r2_w_1));
                    float r4_z_1 = dot(cb1_values[41].xyzw, float4(r2_x_4, r2_y_3, r2_z_3, r2_w_1));
                    r4_xyz_5 = float3(r4_x_1, r4_y_1, r4_z_1);
                }
                float4 r3_xyzw_12 = (r4_xyz_5.xyzx + i.texcoord7.xyzx);
                float r3_x_12 = r3_xyzw_12.x;
                float r3_y_13 = r3_xyzw_12.y;
                float r3_z_12 = r3_xyzw_12.z;
                float4 r3_xyzw_13 = max(float4(r3_x_12, r3_y_13, r3_z_12, r3_x_12), float4(0, 0, 0, 0));
                float r3_x_13 = r3_xyzw_13.x;
                float r3_y_14 = r3_xyzw_13.y;
                float r3_z_13 = r3_xyzw_13.z;
                float4 r3_xyzw_14 = (r0_w_4.xxxx * float4(r3_x_13, r3_y_14, r3_z_13, r3_x_13));
                float r3_x_14 = r3_xyzw_14.x;
                float r3_y_15 = r3_xyzw_14.y;
                float r3_z_14 = r3_xyzw_14.z;
                float r1_w_9 = max(r1_xyz_2.y, r1_xyz_2.x);
                float r1_w_10 = max(r1_xyz_2.z, r1_w_9);
                float r1_w_11 = (-r1_w_10 + 1);
                float3 r4_xyz_6 = ((r0_xyz_2.xyzx * r1_w_11.xxxx)).xyz;
                float4 r3_xyzw_15 = (float4(r3_x_14, r3_y_15, r3_z_14, r3_x_14) * r4_xyz_6.xyzx);
                float r3_x_15 = r3_xyzw_15.x;
                float r3_y_16 = r3_xyzw_15.y;
                float r3_z_15 = r3_xyzw_15.z;
                o.sv_Target2.xyz = (mad(float4(r2_x_4, r2_y_3, r2_z_3, r2_x_4), float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
                o.sv_Target3.xyz = (mad(_EmissionColor.xyzx, r0_xyz_2.xyzx, float4(r3_x_15, r3_y_16, r3_z_15, r3_x_15))).xyz;
                o.sv_Target0.w = r0_w_4;
                o.sv_Target0.xyz = r4_xyz_6.xyz;
                o.sv_Target1.xyz = r1_xyz_2.xyz;
                o.sv_Target2.w = 1;
                o.sv_Target3.w = 1;
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
            struct program119Input
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
            struct program119Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program125Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program125Output
            {
                float4 sv_Target0 : SV_Target;
                float4 sv_Target1 : SV_Target1;
                float4 sv_Target2 : SV_Target2;
                float4 sv_Target3 : SV_Target3;
            };
            #pragma vertex vert
            program119Output vert(program119Input i)
            {
                program119Output o = (program119Output)0;
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
            program125Output frag(program125Input i)
            {
                program125Output o = (program125Output)0;
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
                o.sv_Target3.xyz = ((float4(r0_y_4, r0_z_4, r0_w_5, r0_y_4) * _EmissionColor.xyzx)).xyz;
                float3 r0_xyz_5 = (_SpecGlossMap.Sample(sampler_SpecGlossMap, (i.texcoord0.zwzz).xy)).xyz;
                float r0_x_6 = (r0_xyz_5.z * r0_xyz_5.x);
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_xyz_5.y, r0_x_6, r0_x_6), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_6 = r0_xyzw_7.y;
                float r0_w_6 = dot(float4(r0_x_7, r0_y_6, r0_x_7, r0_x_7), float4(r0_x_7, r0_y_6, r0_x_7, r0_x_7));
                float r0_w_7 = min(r0_w_6, 1);
                float r0_w_8 = (-r0_w_7 + 1);
                float r0_z_6 = sqrt(r0_w_8);
                float r1_x_1 = dot(i.texcoord2.xyzx, float4(r0_x_7, r0_y_6, r0_z_6, r0_x_7));
                float r1_y_1 = dot(i.texcoord3.xyzx, float4(r0_x_7, r0_y_6, r0_z_6, r0_x_7));
                float r1_z_1 = dot(i.texcoord4.xyzx, float4(r0_x_7, r0_y_6, r0_z_6, r0_x_7));
                float4 r0_xyzw_10 = ((rsqrt(dot(float4(r1_x_1, r1_y_1, r1_z_1, r1_x_1), float4(r1_x_1, r1_y_1, r1_z_1, r1_x_1)))).xxxx * float4(r1_x_1, r1_y_1, r1_z_1, r1_x_1));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_7 = r0_xyzw_10.y;
                float r0_z_7 = r0_xyzw_10.z;
                o.sv_Target2.xyz = (mad(float4(r0_x_10, r0_y_7, r0_z_7, r0_x_10), float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
                o.sv_Target2.w = 1;
                o.sv_Target3.w = 1;
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
            SamplerState sampler_SpecGlossMap;
            SamplerState sampler_BumpMap;
            SamplerState sampler_OcclusionMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _SpecGlossMap;
            Texture2D _OcclusionMap;
            Texture3D t4;
            struct program118Input
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
            struct program118Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord6 : TEXCOORD6;
                float3 texcoord7 : TEXCOORD7;
            };
            struct program124Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord6 : TEXCOORD6;
                float3 texcoord7 : TEXCOORD7;
            };
            struct program124Output
            {
                float4 sv_Target0 : SV_Target;
                float4 sv_Target1 : SV_Target1;
                float4 sv_Target2 : SV_Target2;
                float4 sv_Target3 : SV_Target3;
            };
            #pragma vertex vert
            program118Output vert(program118Input i)
            {
                program118Output o = (program118Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float3 r0_xyz_4 = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _SpecGlossMap_ST.xyxx, _SpecGlossMap_ST.zwzz)).xy;
                o.texcoord1.zw = (mad(i.texcoord0.xxxy, _OcclusionMap_ST.xxxy, _OcclusionMap_ST.zzzw)).zw;
                o.texcoord2.w = r0_xyz_4.x;
                float3 worldTangent_xyz_2 = ((i.tangent0.yyyy * cb2_values[1].yzxy)).xyz;
                float3 worldTangent_xyz_3 = (mad(cb2_values[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_2.xyzx)).xyz;
                float3 worldTangent_xyz_4 = (mad(cb2_values[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_3.xyzx)).xyz;
                float3 unitWorldTangent_xyz_5 = (((rsqrt(dot(worldTangent_xyz_4.xyzx, worldTangent_xyz_4.xyzx))).xxxx * worldTangent_xyz_4.xyzx)).xyz;
                o.texcoord2.x = unitWorldTangent_xyz_5.z;
                float worldNormal_x_4 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float4 unitWorldNormal_xyzw_5 = ((rsqrt(dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4)))).xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_z_4));
                float3 r3_xyz_3 = ((((i.tangent0.w * cb2_values[9].w)).xxxx * (mad(unitWorldNormal_xyzw_5.ywxy, unitWorldTangent_xyz_5.yzxy, ((unitWorldTangent_xyz_5.xyzx * unitWorldNormal_xyzw_5.wxyw)).xyzx)).xyzx)).xyz;
                o.texcoord2.y = r3_xyz_3.x;
                o.texcoord2.z = unitWorldNormal_xyzw_5.x;
                o.texcoord3.x = unitWorldTangent_xyz_5.x;
                o.texcoord4.x = unitWorldTangent_xyz_5.y;
                o.texcoord3.w = r0_xyz_4.y;
                o.texcoord4.w = r0_xyz_4.z;
                o.texcoord3.y = r3_xyz_3.y;
                o.texcoord4.y = r3_xyz_3.z;
                o.texcoord3.z = unitWorldNormal_xyzw_5.y;
                o.texcoord4.z = unitWorldNormal_xyzw_5.w;
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                float4 r1_xyzw_6 = (unitWorldNormal_xyzw_5.ywzx * unitWorldNormal_xyzw_5);
                float r2_x_6 = dot(cb1_values[42].xyzw, r1_xyzw_6);
                float r2_y_6 = dot(cb1_values[43].xyzw, r1_xyzw_6);
                float r2_z_6 = dot(cb1_values[44].xyzw, r1_xyzw_6);
                o.texcoord7.xyz = (mad(cb1_values[45].xyzx, (mad(unitWorldNormal_xyzw_5.x, unitWorldNormal_xyzw_5.x, (unitWorldNormal_xyzw_5.y * unitWorldNormal_xyzw_5.y))).xxxx, float4(r2_x_6, r2_y_6, r2_z_6, r2_x_6))).xyz;
                return o;
            }
            #pragma fragment frag
            program124Output frag(program124Input i)
            {
                program124Output o = (program124Output)0;
                float3 r0_xyz_1 = (_MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy)).xyz;
                float3 r0_xyz_2 = ((r0_xyz_1.xyzx * _Color.xyzx)).xyz;
                float4 r1_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord1.xyxx).xy);
                float3 r2_xyz_1 = (_SpecGlossMap.Sample(sampler_SpecGlossMap, (i.texcoord0.zwzz).xy)).xyz;
                float r2_x_2 = (r2_xyz_1.z * r2_xyz_1.x);
                float4 r2_xyzw_3 = mad(float4(r2_x_2, r2_xyz_1.y, r2_x_2, r2_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r2_x_3 = r2_xyzw_3.x;
                float r2_y_2 = r2_xyzw_3.y;
                float r0_w_1 = dot(float4(r2_x_3, r2_y_2, r2_x_3, r2_x_3), float4(r2_x_3, r2_y_2, r2_x_3, r2_x_3));
                float r0_w_2 = min(r0_w_1, 1);
                float r0_w_3 = (-r0_w_2 + 1);
                float r2_z_2 = sqrt(r0_w_3);
                float3 r1_xyz_2 = ((r1_xyzw_1.xyzx * _SpecColor.xyzx)).xyz;
                o.sv_Target1.w = (r1_xyzw_1.w * _Glossiness);
                float r0_w_4 = (_OcclusionMap.Sample(sampler_OcclusionMap, (i.texcoord1.zwzz).xy)).w;
                float r3_x_1 = dot(i.texcoord2.xyzx, float4(r2_x_3, r2_y_2, r2_z_2, r2_x_3));
                float r3_y_1 = dot(i.texcoord3.xyzx, float4(r2_x_3, r2_y_2, r2_z_2, r2_x_3));
                float r3_z_1 = dot(i.texcoord4.xyzx, float4(r2_x_3, r2_y_2, r2_z_2, r2_x_3));
                float r1_w_2 = dot(float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1), float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float r1_w_3 = rsqrt(r1_w_2);
                float4 r2_xyzw_4 = (r1_w_3.xxxx * float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float r2_x_4 = r2_xyzw_4.x;
                float r2_y_3 = r2_xyzw_4.y;
                float r2_z_3 = r2_xyzw_4.z;
                float r1_w_4 = (cb2_values[0].x == 1);
                float3 r4_xyz_5;
                if (r1_w_4)
                {
                    float r1_w_5 = (cb2_values[0].y == 1);
                    float3 r3_xyz_5 = (((mad(cb2_values[3].xyzx, i.texcoord4.wwww, (mad(cb2_values[1].xyzx, i.texcoord2.wwww, ((i.texcoord3.wwww * cb2_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb2_values[4].xyzx)).xyz;
                    float TEXCOORD2_y_2 = i.texcoord2.w;
                    float TEXCOORD3_z_2 = i.texcoord3.w;
                    float TEXCOORD4_w_1 = i.texcoord4.w;
                    float4 r3_xyzw_8 = (((((r1_w_5.xxxx ? r3_xyz_5.xyzx : float4(TEXCOORD2_y_2, TEXCOORD3_z_2, TEXCOORD4_w_1, TEXCOORD2_y_2))).xyzx + -cb2_values[6].xyzx)).xxyz * cb2_values[5].xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_1 = r3_xyzw_8.w;
                    float r1_w_6 = (r3_y_8 * 0.25);
                    float r3_y_9 = (cb2_values[0].z * 0.5);
                    float r1_w_7 = max(r1_w_6, r3_y_9);
                    float r3_x_8 = min(mad(-cb2_values[0].z, 0.5, 0.25), r1_w_7);
                    float4 r4_xyzw_3 = t4.Sample(sampler_linear_clamp, (float4(r3_x_8, r3_z_8, r3_w_1, r3_x_8)).xyz);
                    float4 r5_xyzw_2 = t4.Sample(sampler_linear_clamp, (((float4(r3_x_8, r3_z_8, r3_w_1, r3_x_8) + float4(0.25, 0, 0, 0))).xyzx).xyz);
                    float4 r3_xyzw_9 = (float4(r3_x_8, r3_z_8, r3_w_1, r3_x_8) + float4(0.5, 0, 0, 0));
                    float r3_x_9 = r3_xyzw_9.x;
                    float r3_y_10 = r3_xyzw_9.y;
                    float r3_z_9 = r3_xyzw_9.z;
                    float4 r3_xyzw_10 = t4.Sample(sampler_linear_clamp, (float4(r3_x_9, r3_y_10, r3_z_9, r3_x_9)).xyz);
                    float r2_w_2 = 1;
                    float r4_x_4 = dot(r4_xyzw_3, float4(r2_x_4, r2_y_3, r2_z_3, r2_w_2));
                    float r4_y_4 = dot(r5_xyzw_2, float4(r2_x_4, r2_y_3, r2_z_3, r2_w_2));
                    float r4_z_4 = dot(r3_xyzw_10, float4(r2_x_4, r2_y_3, r2_z_3, r2_w_2));
                    r4_xyz_5 = float3(r4_x_4, r4_y_4, r4_z_4);
                }
                else
                {
                    float r2_w_1 = 1;
                    float r4_x_1 = dot(cb1_values[39].xyzw, float4(r2_x_4, r2_y_3, r2_z_3, r2_w_1));
                    float r4_y_1 = dot(cb1_values[40].xyzw, float4(r2_x_4, r2_y_3, r2_z_3, r2_w_1));
                    float r4_z_1 = dot(cb1_values[41].xyzw, float4(r2_x_4, r2_y_3, r2_z_3, r2_w_1));
                    r4_xyz_5 = float3(r4_x_1, r4_y_1, r4_z_1);
                }
                float4 r3_xyzw_12 = (r4_xyz_5.xyzx + i.texcoord7.xyzx);
                float r3_x_12 = r3_xyzw_12.x;
                float r3_y_13 = r3_xyzw_12.y;
                float r3_z_12 = r3_xyzw_12.z;
                float4 r3_xyzw_13 = max(float4(r3_x_12, r3_y_13, r3_z_12, r3_x_12), float4(0, 0, 0, 0));
                float r3_x_13 = r3_xyzw_13.x;
                float r3_y_14 = r3_xyzw_13.y;
                float r3_z_13 = r3_xyzw_13.z;
                float4 r3_xyzw_14 = (r0_w_4.xxxx * float4(r3_x_13, r3_y_14, r3_z_13, r3_x_13));
                float r3_x_14 = r3_xyzw_14.x;
                float r3_y_15 = r3_xyzw_14.y;
                float r3_z_14 = r3_xyzw_14.z;
                float r1_w_9 = max(r1_xyz_2.y, r1_xyz_2.x);
                float r1_w_10 = max(r1_xyz_2.z, r1_w_9);
                float r1_w_11 = (-r1_w_10 + 1);
                float3 r4_xyz_6 = ((r0_xyz_2.xyzx * r1_w_11.xxxx)).xyz;
                float4 r3_xyzw_15 = (float4(r3_x_14, r3_y_15, r3_z_14, r3_x_14) * r4_xyz_6.xyzx);
                float r3_x_15 = r3_xyzw_15.x;
                float r3_y_16 = r3_xyzw_15.y;
                float r3_z_15 = r3_xyzw_15.z;
                o.sv_Target2.xyz = (mad(float4(r2_x_4, r2_y_3, r2_z_3, r2_x_4), float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
                o.sv_Target3.xyz = (exp2((mad(_EmissionColor.xyzx, r0_xyz_2.xyzx, float4(r3_x_15, r3_y_16, r3_z_15, r3_x_15))).xyzx)).xyz;
                o.sv_Target0.w = r0_w_4;
                o.sv_Target0.xyz = r4_xyz_6.xyz;
                o.sv_Target1.xyz = r1_xyz_2.xyz;
                o.sv_Target2.w = 1;
                o.sv_Target3.w = 1;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Standard"
}
