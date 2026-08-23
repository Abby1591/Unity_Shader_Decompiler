Shader "Custom/Planet_Clouds_Atmosphere"
{
    Properties
    {
        _MainTex ("Clouds Base (RGB)", 2D) = "" {}
        _AlphaScale ("Clouds alpha Scale", Range(0, 2)) = 1
        _BumpMap ("Clouds normal Map", 2D) = "" {}
        _BumpScale ("Clouds bump Scale", Range(0, 1)) = 1
        _DisplacementClouds ("Clouds displacement", Range(0, 0.05)) = 0.005
        _Highatmospherecolor ("High atmosphere color", Color) = (0.5,0.5,0.5,0)
        _Lowatmospherecolor ("Low atmosphere color", Color) = (0.5,0.5,0.5,1)
        _Inneratmosphere ("Inner atmosphere", Color) = (0.5,0.5,0.5,1)
        _Outeratmospherelimit ("Outer atmosphere limit", Range(0, 1)) = 0.548887
        _Outeratmopsheredensity ("Outer atmopshere density", Range(0, 1)) = 1
        _Inneratmopsheredensity ("Inner atmopshere density", Range(0, 1)) = 0.08092485
        _Innerouterlimit ("Inner outer limit", Range(0, 1)) = 0.6647399
        _Inneroutersmoothness ("Inner outer smoothness", Range(0, 1)) = 0.2572428
        _DisplacementAtmosphere ("Displacement atmosphere", Range(0, 0.1)) = 0.1
    }
    SubShader
    {
        Tags { "QUEUE"="Transparent" "RenderType"="Transparent" }
        LOD 300
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One OneMinusSrcColor
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float _BumpScale;
                float _AlphaScale;
                float _DisplacementClouds;
                float4 _MainTex_ST;
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float3 _WorldSpaceCameraPos;
                float4 unity_WorldTransformParams;
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
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
            };
            cbuffer UnityProbeVolume : register(b4)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
            };
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_linear_clamp1 : register(s1);
            SamplerState sampler_linear_clamp2 : register(s2);
            SamplerState sampler_linear_clamp3 : register(s3);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            TextureCube t2 : register(t2);
            TextureCube t3 : register(t3);
            Texture3D t4 : register(t4);
            struct program3Input
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
            struct program3Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program13Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program13Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program3Output vert(program3Input i)
            {
                program3Output o = (program3Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float3 r0_xyz_1 = (mad(i.normal0.xyzx, _DisplacementClouds.xxxx, i.position0.xyzx)).xyz;
                float4 r0_xyzw_2 = mad(unity_ObjectToWorld[2], r0_xyz_1.zzzz, mad(unity_ObjectToWorld[0], r0_xyz_1.xxxx, (r0_xyz_1.yyyy * unity_ObjectToWorld[1])));
                float4 r1_xyzw_3 = (r0_xyzw_2 + unity_ObjectToWorld[3]);
                float3 worldPos_xyz_3 = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, r0_xyzw_2.xyzx)).xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(r1_xyzw_3);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord1.w = worldPos_xyz_3.x;
                float worldNormal_y_4 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_4 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float3 unitWorldNormal_xyz_5 = (((rsqrt(dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4)))).xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = (((rsqrt(dot(worldTangent_xyz_6.xyzx, worldTangent_xyz_6.xyzx))).xxxx * worldTangent_xyz_6.xyzx)).xyz;
                float3 r3_xyz_3 = ((((i.tangent0.w * unity_WorldTransformParams.w)).xxxx * (mad(unitWorldNormal_xyz_5.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_5.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_5.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_5.z;
                o.texcoord3.z = unitWorldNormal_xyz_5.x;
                o.texcoord2.w = worldPos_xyz_3.y;
                o.texcoord3.w = worldPos_xyz_3.z;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program13Output frag(program13Input i)
            {
                program13Output o = (program13Output)0;
                float TEXCOORD1_x_1 = i.texcoord1.w;
                float TEXCOORD2_y_1 = i.texcoord2.w;
                float TEXCOORD3_z_1 = i.texcoord3.w;
                float3 viewDir_xyz_1 = ((-float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1) + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float4 r3_xyzw_1 = t0.Sample(sampler_linear_clamp2, (i.texcoord0.xyxx).xy);
                float4 r4_xyzw_1 = t1.Sample(sampler_linear_clamp3, (i.texcoord0.xyxx).xy);
                float r1_w_1 = (r3_xyzw_1.w * _AlphaScale);
                float r4_x_2 = (r4_xyzw_1.w * r4_xyzw_1.x);
                float4 r4_xyzw_3 = mad(float4(r4_x_2, r4_xyzw_1.y, r4_x_2, r4_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r4_x_3 = r4_xyzw_3.x;
                float r4_y_2 = r4_xyzw_3.y;
                float4 r4_xyzw_4 = (float4(r4_x_3, r4_y_2, r4_x_3, r4_x_3) * _BumpScale.xxxx);
                float r4_x_4 = r4_xyzw_4.x;
                float r4_y_3 = r4_xyzw_4.y;
                float r2_w_1 = dot(float4(r4_x_4, r4_y_3, r4_x_4, r4_x_4), float4(r4_x_4, r4_y_3, r4_x_4, r4_x_4));
                float r2_w_2 = min(r2_w_1, 1);
                float r2_w_3 = (-r2_w_2 + 1);
                float r4_z_2 = sqrt(r2_w_3);
                float r2_w_4 = dot(float4(r4_x_4, r4_y_3, r4_z_2, r4_x_4), float4(r4_x_4, r4_y_3, r4_z_2, r4_x_4));
                float r2_w_5 = rsqrt(r2_w_4);
                float4 r4_xyzw_5 = (r2_w_5.xxxx * float4(r4_x_4, r4_y_3, r4_z_2, r4_x_4));
                float r4_x_5 = r4_xyzw_5.x;
                float r4_y_4 = r4_xyzw_5.y;
                float r4_z_3 = r4_xyzw_5.z;
                float r2_w_6 = (unity_ProbeVolumeParams.x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r2_w_6)
                {
                    float r2_w_7 = (unity_ProbeVolumeParams.y == 1);
                    float3 r5_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord3.wwww, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.wwww, ((i.texcoord2.wwww * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r2_w_7.xxxx ? r5_xyz_5.xyzx : float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1))).xyz;
                    float4 r5_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r2_w_8 = mad(r5_y_8, 0.25, 0.75);
                    float r3_w_2 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r5_x_8 = max(r2_w_8, r3_w_2);
                    float4 r5_xyzw_9 = t4.Sample(sampler_linear_clamp1, (float4(r5_x_8, r5_z_8, r5_w_2, r5_x_8)).xyz);
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
                float r2_w_10 = dot(float4(r5_x_10, r5_y_10, r5_z_10, r5_w_4), unity_OcclusionMaskSelector);
                float r5_x_11 = dot(i.texcoord1.xyzx, float4(r4_x_5, r4_y_4, r4_z_3, r4_x_5));
                float r5_y_11 = dot(i.texcoord2.xyzx, float4(r4_x_5, r4_y_4, r4_z_3, r4_x_5));
                float r5_z_11 = dot(i.texcoord3.xyzx, float4(r4_x_5, r4_y_4, r4_z_3, r4_x_5));
                float r3_w_4 = dot(float4(r5_x_11, r5_y_11, r5_z_11, r5_x_11), float4(r5_x_11, r5_y_11, r5_z_11, r5_x_11));
                float r3_w_5 = rsqrt(r3_w_4);
                float4 r4_xyzw_6 = (r3_w_5.xxxx * float4(r5_x_11, r5_y_11, r5_z_11, r5_x_11));
                float r4_x_6 = r4_xyzw_6.x;
                float r4_y_5 = r4_xyzw_6.y;
                float r4_z_4 = r4_xyzw_6.z;
                float r3_w_6 = dot(-unitViewDir_xyz_1.xyzx, float4(r4_x_6, r4_y_5, r4_z_4, r4_x_6));
                float r3_w_7 = (r3_w_6 + r3_w_6);
                float3 r5_xyz_12 = (mad(float4(r4_x_6, r4_y_5, r4_z_4, r4_x_6), -r3_w_7.xxxx, -unitViewDir_xyz_1.xyzx)).xyz;
                float3 r6_xyz_1 = ((r2_w_10.xxxx * _LightColor0.xyzx)).xyz;
                float r2_w_11 = (0 < unity_SpecCube0_ProbePosition.w);
                float3 r7_xyz_4;
                if (r2_w_11)
                {
                    float3 r7_xyz_2 = normalize(r5_xyz_12);
                    float3 r10_xyz_1 = ((float4(0, 0, 0, 0) < r7_xyz_2.xyzx)).xyz;
                    float3 r8_xyz_3 = ((r10_xyz_1.xyzx ? ((((-float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1) + unity_SpecCube0_BoxMax.xyzx)).xyzx / r7_xyz_2.xyzx)).xyzx : ((((-float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1) + unity_SpecCube0_BoxMin.xyzx)).xyzx / r7_xyz_2.xyzx)).xyzx)).xyz;
                    float r2_w_14 = min(r8_xyz_3.y, r8_xyz_3.x);
                    float r2_w_15 = min(r8_xyz_3.z, r2_w_14);
                    r7_xyz_4 = (mad(r7_xyz_2.xyzx, r2_w_15.xxxx, ((float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1) + -unity_SpecCube0_ProbePosition.xyzx)).xyzx)).xyz;
                }
                else
                {
                    r7_xyz_4 = r5_xyz_12.xyz;
                }
                float4 r7_xyzw_5 = t2.SampleLevel(sampler_linear_clamp, r7_xyz_4.xyz, 6);
                float r2_w_17 = (r7_xyzw_5.w + -1);
                float r2_w_18 = mad(unity_SpecCube0_HDR.w, r2_w_17, 1);
                float r2_w_19 = (r2_w_18 * unity_SpecCube0_HDR.x);
                float r3_w_8 = (unity_SpecCube0_BoxMin.w < 0.99999);
                float3 r8_xyz_8 = ((r7_xyzw_5.xyzx * r2_w_19.xxxx)).xyz;
                if (r3_w_8)
                {
                    float r3_w_9 = (0 < unity_SpecCube1_ProbePosition.w);
                    float3 r5_xyz_14 = r5_xyz_12;
                    if (r3_w_9)
                    {
                        float3 r9_xyz_4 = normalize(r5_xyz_12);
                        float3 r12_xyz_1 = ((float4(0, 0, 0, 0) < r9_xyz_4.xyzx)).xyz;
                        float3 r10_xyz_5 = ((r12_xyz_1.xyzx ? ((((-float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1) + unity_SpecCube1_BoxMax.xyzx)).xyzx / r9_xyz_4.xyzx)).xyzx : ((((-float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1) + unity_SpecCube1_BoxMin.xyzx)).xyzx / r9_xyz_4.xyzx)).xyzx)).xyz;
                        float r3_w_12 = min(r10_xyz_5.y, r10_xyz_5.x);
                        float r3_w_13 = min(r10_xyz_5.z, r3_w_12);
                        r5_xyz_14 = (mad(r9_xyz_4.xyzx, r3_w_13.xxxx, ((float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1) + -unity_SpecCube1_ProbePosition.xyzx)).xyzx)).xyz;
                    }
                    float4 r5_xyzw_15 = t3.SampleLevel(sampler_linear_clamp, r5_xyz_14.xyz, 6);
                    float4 r0_xyzw_7 = (r5_xyzw_15.xyzx * ((mad(unity_SpecCube1_HDR.w, (r5_xyzw_15.w + -1), 1) * unity_SpecCube1_HDR.x)).xxxx);
                    float r0_x_7 = r0_xyzw_7.x;
                    float r0_y_4 = r0_xyzw_7.y;
                    float r0_z_4 = r0_xyzw_7.z;
                    r8_xyz_8 = (mad(unity_SpecCube0_BoxMin.wwww, (mad(r2_w_19.xxxx, r7_xyzw_5.xyzx, -float4(r0_x_7, r0_y_4, r0_z_4, r0_x_7))).xyzx, float4(r0_x_7, r0_y_4, r0_z_4, r0_x_7))).xyz;
                }
                float4 r0_xyzw_9 = (r1_w_1.xxxx * r3_xyzw_1.xyzx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_6 = r0_xyzw_9.y;
                float r0_z_6 = r0_xyzw_9.z;
                o.sv_Target0.w = mad(r1_w_1, 0.7790837, 0.22091627);
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float r0_w_6 = dot(float4(r4_x_6, r4_y_5, r4_z_4, r4_x_6), unitViewDir_xyz_1.xyzx);
                float r1_w_2 = dot(float4(r4_x_6, r4_y_5, r4_z_4, r4_x_6), _WorldSpaceLightPos0.xyzx);
                float r1_x_4 = dot(_WorldSpaceLightPos0.xyzx, ((r0_w_5.xxxx * r1_xyz_2.xyzx)).xyzx);
                float r1_y_4 = dot(r1_x_4.xxxx, r1_x_4.xxxx);
                float r1_y_5 = (r1_y_4 + -0.5);
                float r1_z_4 = (-r1_w_2 + 1);
                float r2_x_2 = (r1_z_4 * r1_z_4);
                float r1_z_5 = (r1_z_4 * (r2_x_2 * r2_x_2));
                float r1_z_6 = mad(r1_y_5, r1_z_5, 1);
                float r2_x_4 = (-abs(r0_w_6) + 1);
                float r2_y_2 = (r2_x_4 * r2_x_4);
                float r2_y_3 = (r2_y_2 * r2_y_2);
                float r2_x_5 = (r2_x_4 * r2_y_3);
                float r1_y_6 = mad(r1_y_5, r2_x_5, 1);
                float r1_y_7 = (r1_y_6 * r1_z_6);
                float r1_y_8 = (r1_w_2 * r1_y_7);
                float r0_w_7 = (abs(r0_w_6) + r1_w_2);
                float r0_w_8 = (r0_w_7 + 1E-05);
                float r0_w_9 = (0.5 / r0_w_8);
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_y_6, r0_z_6, r0_w_9) * float4(0.7790837, 0.7790837, 0.7790837, 0.9999999));
                float r0_w_11 = max(r0_xyzw_10.w, 0.0001);
                float r0_w_12 = sqrt(r0_w_11);
                float r0_w_13 = (r1_w_2 * r0_w_12);
                float4 r1_xyzw_9 = (r1_y_8.xxxx * r6_xyz_1.xxyz);
                float r1_y_9 = r1_xyzw_9.y;
                float r1_z_7 = r1_xyzw_9.z;
                float r1_w_3 = r1_xyzw_9.w;
                float4 r2_xyzw_4 = (r6_xyz_1.xxyz * r0_w_13.xxxx);
                float r2_y_4 = r2_xyzw_4.y;
                float r2_z_2 = r2_xyzw_4.z;
                float r2_w_20 = r2_xyzw_4.w;
                float r0_w_14 = (-r1_x_4 + 1);
                float r1_x_5 = (r0_w_14 * r0_w_14);
                float r0_w_15 = (r0_w_14 * (r1_x_5 * r1_x_5));
                float r0_w_16 = mad(r0_w_15, 0.7790837, 0.2209163);
                float4 r2_xyzw_5 = (r0_w_16.xxxx * float4(r2_y_4, r2_y_4, r2_z_2, r2_w_20));
                float r2_y_5 = r2_xyzw_5.y;
                float r2_z_3 = r2_xyzw_5.z;
                float r2_w_21 = r2_xyzw_5.w;
                float4 r0_xyzw_11 = mad(r0_xyzw_10.xyzx, float4(r1_y_9, r1_z_7, r1_w_3, r1_y_9), float4(r2_y_5, r2_z_3, r2_w_21, r2_y_5));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_y_8 = r0_xyzw_11.y;
                float r0_z_8 = r0_xyzw_11.z;
                float4 r1_xyzw_7 = (r8_xyz_8.xyzx * float4(0.72, 0.72, 0.72, 0));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_10 = r1_xyzw_7.y;
                float r1_z_8 = r1_xyzw_7.z;
                float r0_w_17 = mad(r2_x_5, -2.9802322E-08, 0.2209163);
                o.sv_Target0.xyz = (mad(float4(r1_x_7, r1_y_10, r1_z_8, r1_x_7), r0_w_17.xxxx, float4(r0_x_11, r0_y_8, r0_z_8, r0_x_11))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One OneMinusSrcColor
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float _BumpScale;
                float _AlphaScale;
                float _DisplacementClouds;
                float4 _MainTex_ST;
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float3 _WorldSpaceCameraPos;
                float4 unity_WorldTransformParams;
                float4 cb1_values[46];
            };
            cbuffer UnityPerFrame : register(b2)
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
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_linear_clamp1 : register(s1);
            SamplerState sampler_linear_clamp2 : register(s2);
            SamplerState sampler_linear_clamp3 : register(s3);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            TextureCube t2 : register(t2);
            TextureCube t3 : register(t3);
            Texture3D t4 : register(t4);
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
                float texcoord5 : TEXCOORD5;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program16Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program16Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program7Output vert(program7Input i)
            {
                program7Output o = (program7Output)0;
                float3 r0_xyz_1 = (mad(i.normal0.xyzx, _DisplacementClouds.xxxx, i.position0.xyzx)).xyz;
                float4 r0_xyzw_2 = mad(cb2_values[2].xyzw, r0_xyz_1.zzzz, mad(cb2_values[0].xyzw, r0_xyz_1.xxxx, (r0_xyz_1.yyyy * cb2_values[1].xyzw)));
                float4 r1_xyzw_3 = (r0_xyzw_2 + cb2_values[3].xyzw);
                float3 r0_xyz_3 = (mad(cb2_values[3].xyzx, i.position0.wwww, r0_xyzw_2.xyzx)).xyz;
                float4 r1_xyzw_4 = mad(cb3_values[20].xyzw, r1_xyzw_3.wwww, mad(cb3_values[19].xyzw, r1_xyzw_3.zzzz, mad(cb3_values[17].xyzw, r1_xyzw_3.xxxx, (r1_xyzw_3.yyyy * cb3_values[18].xyzw))));
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), r1_xyzw_3);
                o.texcoord5.x = r1_xyzw_4.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord1.w = r0_xyz_3.x;
                float3 worldTangent_xyz_5 = ((i.tangent0.yyyy * cb2_values[1].yzxy)).xyz;
                float3 worldTangent_xyz_6 = (mad(cb2_values[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_5.xyzx)).xyz;
                float3 worldTangent_xyz_7 = (mad(cb2_values[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_6.xyzx)).xyz;
                float3 unitWorldTangent_xyz_8 = (((rsqrt(dot(worldTangent_xyz_7.xyzx, worldTangent_xyz_7.xyzx))).xxxx * worldTangent_xyz_7.xyzx)).xyz;
                o.texcoord1.x = unitWorldTangent_xyz_8.z;
                float worldNormal_x_4 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float4 unitWorldNormal_xyzw_5 = ((rsqrt(dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4)))).xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_z_4));
                float3 r3_xyz_3 = ((((i.tangent0.w * cb2_values[9].w)).xxxx * (mad(unitWorldNormal_xyzw_5.ywxy, unitWorldTangent_xyz_8.yzxy, ((unitWorldTangent_xyz_8.xyzx * unitWorldNormal_xyzw_5.wxyw)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.z = unitWorldNormal_xyzw_5.x;
                o.texcoord2.x = unitWorldTangent_xyz_8.x;
                o.texcoord3.x = unitWorldTangent_xyz_8.y;
                o.texcoord2.w = r0_xyz_3.y;
                o.texcoord3.w = r0_xyz_3.z;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord2.z = unitWorldNormal_xyzw_5.y;
                o.texcoord3.z = unitWorldNormal_xyzw_5.w;
                float4 r1_xyzw_9 = (unitWorldNormal_xyzw_5.ywzx * unitWorldNormal_xyzw_5);
                float r2_x_6 = dot(cb1_values[42].xyzw, r1_xyzw_9);
                float r2_y_6 = dot(cb1_values[43].xyzw, r1_xyzw_9);
                float r2_z_6 = dot(cb1_values[44].xyzw, r1_xyzw_9);
                o.texcoord4.xyz = (mad(cb1_values[45].xyzx, (mad(unitWorldNormal_xyzw_5.x, unitWorldNormal_xyzw_5.x, (unitWorldNormal_xyzw_5.y * unitWorldNormal_xyzw_5.y))).xxxx, float4(r2_x_6, r2_y_6, r2_z_6, r2_x_6))).xyz;
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program16Output frag(program16Input i)
            {
                program16Output o = (program16Output)0;
                float TEXCOORD1_x_1 = i.texcoord1.w;
                float TEXCOORD2_y_1 = i.texcoord2.w;
                float TEXCOORD3_z_1 = i.texcoord3.w;
                float3 viewDir_xyz_1 = ((-float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1) + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float4 r3_xyzw_1 = t0.Sample(sampler_linear_clamp2, (i.texcoord0.xyxx).xy);
                float4 r4_xyzw_1 = t1.Sample(sampler_linear_clamp3, (i.texcoord0.xyxx).xy);
                float r1_w_1 = (r3_xyzw_1.w * _AlphaScale);
                float r4_x_2 = (r4_xyzw_1.w * r4_xyzw_1.x);
                float4 r4_xyzw_3 = mad(float4(r4_x_2, r4_xyzw_1.y, r4_x_2, r4_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r4_x_3 = r4_xyzw_3.x;
                float r4_y_2 = r4_xyzw_3.y;
                float4 r4_xyzw_4 = (float4(r4_x_3, r4_y_2, r4_x_3, r4_x_3) * _BumpScale.xxxx);
                float r4_x_4 = r4_xyzw_4.x;
                float r4_y_3 = r4_xyzw_4.y;
                float r2_w_1 = dot(float4(r4_x_4, r4_y_3, r4_x_4, r4_x_4), float4(r4_x_4, r4_y_3, r4_x_4, r4_x_4));
                float r2_w_2 = min(r2_w_1, 1);
                float r2_w_3 = (-r2_w_2 + 1);
                float r4_z_2 = sqrt(r2_w_3);
                float r2_w_4 = dot(float4(r4_x_4, r4_y_3, r4_z_2, r4_x_4), float4(r4_x_4, r4_y_3, r4_z_2, r4_x_4));
                float r2_w_5 = rsqrt(r2_w_4);
                float4 r4_xyzw_5 = (r2_w_5.xxxx * float4(r4_x_4, r4_y_3, r4_z_2, r4_x_4));
                float r4_x_5 = r4_xyzw_5.x;
                float r4_y_4 = r4_xyzw_5.y;
                float r4_z_3 = r4_xyzw_5.z;
                float r2_w_6 = (cb5_values[0].x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r2_w_6)
                {
                    float r3_w_2 = (cb5_values[0].y == 1);
                    float3 r5_xyz_5 = (((mad(cb5_values[3].xyzx, i.texcoord3.wwww, (mad(cb5_values[1].xyzx, i.texcoord1.wwww, ((i.texcoord2.wwww * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r5_xyzw_8 = (((((r3_w_2.xxxx ? r5_xyz_5.xyzx : float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1))).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r3_w_3 = mad(r5_y_8, 0.25, 0.75);
                    float r4_w_2 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r5_x_8 = max(r3_w_3, r4_w_2);
                    float4 r5_xyzw_9 = t4.Sample(sampler_linear_clamp1, (float4(r5_x_8, r5_z_8, r5_w_2, r5_x_8)).xyz);
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
                float r3_w_5 = dot(float4(r5_x_10, r5_y_10, r5_z_10, r5_w_4), unity_OcclusionMaskSelector);
                float r5_x_11 = dot(i.texcoord1.xyzx, float4(r4_x_5, r4_y_4, r4_z_3, r4_x_5));
                float r5_y_11 = dot(i.texcoord2.xyzx, float4(r4_x_5, r4_y_4, r4_z_3, r4_x_5));
                float r5_z_11 = dot(i.texcoord3.xyzx, float4(r4_x_5, r4_y_4, r4_z_3, r4_x_5));
                float4 r4_xyzw_8 = ((rsqrt(dot(float4(r5_x_11, r5_y_11, r5_z_11, r5_x_11), float4(r5_x_11, r5_y_11, r5_z_11, r5_x_11)))).xxxx * float4(r5_x_11, r5_y_11, r5_z_11, r5_x_11));
                float r4_x_8 = r4_xyzw_8.x;
                float r4_y_5 = r4_xyzw_8.y;
                float r4_z_4 = r4_xyzw_8.z;
                float r5_x_12 = dot(-unitViewDir_xyz_1.xyzx, float4(r4_x_8, r4_y_5, r4_z_4, r4_x_8));
                float4 r5_xyzw_14 = mad(float4(r4_x_8, r4_y_5, r4_z_4, r4_x_8), ((r5_x_12 + r5_x_12)).xxxx, -unitViewDir_xyz_1.xyzx);
                float r5_x_14 = r5_xyzw_14.x;
                float r5_y_12 = r5_xyzw_14.y;
                float r5_z_12 = r5_xyzw_14.z;
                float3 r6_xyz_1 = ((r3_w_5.xxxx * _LightColor0.xyzx)).xyz;
                float3 r8_xyz_4;
                if (r2_w_6)
                {
                    float r2_w_7 = (cb5_values[0].y == 1);
                    float3 r7_xyz_4 = (((mad(cb5_values[3].xyzx, i.texcoord3.wwww, (mad(cb5_values[1].xyzx, i.texcoord1.wwww, ((i.texcoord2.wwww * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r7_xyzw_7 = (((((r2_w_7.xxxx ? r7_xyz_4.xyzx : float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1))).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r7_y_7 = r7_xyzw_7.y;
                    float r7_z_7 = r7_xyzw_7.z;
                    float r7_w_1 = r7_xyzw_7.w;
                    float r2_w_8 = (r7_y_7 * 0.25);
                    float r3_w_6 = (cb5_values[0].z * 0.5);
                    float r5_w_5 = mad(-cb5_values[0].z, 0.5, 0.25);
                    float r2_w_9 = max(r2_w_8, r3_w_6);
                    float r7_x_7 = min(r5_w_5, r2_w_9);
                    float4 r8_xyzw_2 = t4.Sample(sampler_linear_clamp1, (float4(r7_x_7, r7_z_7, r7_w_1, r7_x_7)).xyz);
                    float4 r9_xyzw_2 = t4.Sample(sampler_linear_clamp1, (((float4(r7_x_7, r7_z_7, r7_w_1, r7_x_7) + float4(0.25, 0, 0, 0))).xyzx).xyz);
                    float4 r7_xyzw_9 = t4.Sample(sampler_linear_clamp1, (((float4(r7_x_7, r7_z_7, r7_w_1, r7_x_7) + float4(0.5, 0, 0, 0))).xyzx).xyz);
                    float r4_w_5 = 1;
                    float r8_x_3 = dot(r8_xyzw_2, float4(r4_x_8, r4_y_5, r4_z_4, r4_w_5));
                    float r8_y_3 = dot(r9_xyzw_2, float4(r4_x_8, r4_y_5, r4_z_4, r4_w_5));
                    float r8_z_3 = dot(r7_xyzw_9, float4(r4_x_8, r4_y_5, r4_z_4, r4_w_5));
                    r8_xyz_4 = float3(r8_x_3, r8_y_3, r8_z_3);
                }
                else
                {
                    float r4_w_4 = 1;
                    float r8_x_1 = dot(cb2_values[39].xyzw, float4(r4_x_8, r4_y_5, r4_z_4, r4_w_4));
                    float r8_y_1 = dot(cb2_values[40].xyzw, float4(r4_x_8, r4_y_5, r4_z_4, r4_w_4));
                    float r8_z_1 = dot(cb2_values[41].xyzw, float4(r4_x_8, r4_y_5, r4_z_4, r4_w_4));
                    r8_xyz_4 = float3(r8_x_1, r8_y_1, r8_z_1);
                }
                                float3 r7_xyz_15 = (pow(max((r8_xyz_4.xyzx + i.texcoord4.xyzx).xyz, float3(0, 0, 0)), float3(0.41666666, 0.41666666, 0.41666666)));
                float r2_w_11 = (0 < unity_ProbeVolumeWorldToObject[1].w);
                float3 r8_xyz_8;
                if (r2_w_11)
                {
                    float r2_w_12 = dot(float4(r5_x_14, r5_y_12, r5_z_12, r5_x_14), float4(r5_x_14, r5_y_12, r5_z_12, r5_x_14));
                    float r2_w_13 = rsqrt(r2_w_12);
                    float3 r8_xyz_6 = ((r2_w_13.xxxx * float4(r5_x_14, r5_y_12, r5_z_12, r5_x_14))).xyz;
                    float3 r11_xyz_1 = ((float4(0, 0, 0, 0) < r8_xyz_6.xyzx)).xyz;
                    float3 r9_xyz_6 = ((r11_xyz_1.xyzx ? ((((-float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1) + unity_ProbeVolumeParams.xyzx)).xyzx / r8_xyz_6.xyzx)).xyzx : ((((-float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1) + unity_ProbeVolumeWorldToObject[0].xyzx)).xyzx / r8_xyz_6.xyzx)).xyzx)).xyz;
                    float r2_w_14 = min(r9_xyz_6.y, r9_xyz_6.x);
                    float r2_w_15 = min(r9_xyz_6.z, r2_w_14);
                    r8_xyz_8 = (mad(r8_xyz_6.xyzx, r2_w_15.xxxx, ((float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1) + -unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyz;
                }
                else
                {
                    r8_xyz_8 = (float4(r5_x_14, r5_y_12, r5_z_12, r5_x_14)).xyz;
                }
                float4 r8_xyzw_9 = t2.SampleLevel(sampler_linear_clamp, r8_xyz_8.xyz, 6);
                float r2_w_17 = (r8_xyzw_9.w + -1);
                float r2_w_18 = mad(unity_ProbeVolumeWorldToObject[2].w, r2_w_17, 1);
                float r2_w_19 = (r2_w_18 * unity_ProbeVolumeWorldToObject[2].x);
                float r3_w_8 = (unity_ProbeVolumeWorldToObject[0].w < 0.99999);
                float3 r9_xyz_11 = ((r8_xyzw_9.xyzx * r2_w_19.xxxx)).xyz;
                if (r3_w_8)
                {
                    float r3_w_9 = (0 < cb4_values[6].w);
                    float r5_x_16 = r5_x_14;
                    float r5_y_14 = r5_y_12;
                    float r5_z_14 = r5_z_12;
                    if (r3_w_9)
                    {
                        float r3_w_10 = dot(float4(r5_x_14, r5_y_12, r5_z_12, r5_x_14), float4(r5_x_14, r5_y_12, r5_z_12, r5_x_14));
                        float r3_w_11 = rsqrt(r3_w_10);
                        float3 r10_xyz_4 = ((r3_w_11.xxxx * float4(r5_x_14, r5_y_12, r5_z_12, r5_x_14))).xyz;
                        float3 r13_xyz_1 = ((float4(0, 0, 0, 0) < r10_xyz_4.xyzx)).xyz;
                        float3 r11_xyz_5 = ((r13_xyz_1.xyzx ? ((((-float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1) + unity_ProbeVolumeWorldToObject[3].xyzx)).xyzx / r10_xyz_4.xyzx)).xyzx : ((((-float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1) + unity_ProbeVolumeSizeInv.xyzx)).xyzx / r10_xyz_4.xyzx)).xyzx)).xyz;
                        float r3_w_12 = min(r11_xyz_5.y, r11_xyz_5.x);
                        float r3_w_13 = min(r11_xyz_5.z, r3_w_12);
                        float4 r5_xyzw_15 = mad(r10_xyz_4.xyzx, r3_w_13.xxxx, ((float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1) + -unity_ProbeVolumeMin.xyzx)).xyzx);
                        float r5_x_15 = r5_xyzw_15.x;
                        float r5_y_13 = r5_xyzw_15.y;
                        float r5_z_13 = r5_xyzw_15.z;
                        r5_x_16 = r5_x_15;
                        r5_y_14 = r5_y_13;
                        r5_z_14 = r5_z_13;
                    }
                    float4 r5_xyzw_17 = t3.SampleLevel(sampler_linear_clamp, (float4(r5_x_16, r5_y_14, r5_z_14, r5_x_16)).xyz, 6);
                    float4 r0_xyzw_7 = (r5_xyzw_17.xyzx * ((mad(cb4_values[7].w, (r5_xyzw_17.w + -1), 1) * cb4_values[7].x)).xxxx);
                    float r0_x_7 = r0_xyzw_7.x;
                    float r0_y_4 = r0_xyzw_7.y;
                    float r0_z_4 = r0_xyzw_7.z;
                    float4 r5_xyzw_18 = mad(r2_w_19.xxxx, r8_xyzw_9.xyzx, -float4(r0_x_7, r0_y_4, r0_z_4, r0_x_7));
                    float r5_x_18 = r5_xyzw_18.x;
                    float r5_y_16 = r5_xyzw_18.y;
                    float r5_z_16 = r5_xyzw_18.z;
                    r9_xyz_11 = (mad(unity_ProbeVolumeWorldToObject[0].wwww, float4(r5_x_18, r5_y_16, r5_z_16, r5_x_18), float4(r0_x_7, r0_y_4, r0_z_4, r0_x_7))).xyz;
                }
                float4 r0_xyzw_9 = (r1_w_1.xxxx * r3_xyzw_1.xyzx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_6 = r0_xyzw_9.y;
                float r0_z_6 = r0_xyzw_9.z;
                o.sv_Target0.w = mad(r1_w_1, 0.7790837, 0.22091627);
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float r0_w_6 = dot(float4(r4_x_8, r4_y_5, r4_z_4, r4_x_8), unitViewDir_xyz_1.xyzx);
                float r1_w_2 = dot(float4(r4_x_8, r4_y_5, r4_z_4, r4_x_8), _WorldSpaceLightPos0.xyzx);
                float r1_x_4 = dot(_WorldSpaceLightPos0.xyzx, ((r0_w_5.xxxx * r1_xyz_2.xyzx)).xyzx);
                float r1_y_4 = dot(r1_x_4.xxxx, r1_x_4.xxxx);
                float r1_y_5 = (r1_y_4 + -0.5);
                float r1_z_4 = (-r1_w_2 + 1);
                float r2_x_2 = (r1_z_4 * r1_z_4);
                float r1_z_5 = (r1_z_4 * (r2_x_2 * r2_x_2));
                float r1_z_6 = mad(r1_y_5, r1_z_5, 1);
                float r2_x_4 = (-abs(r0_w_6) + 1);
                float r2_y_2 = (r2_x_4 * r2_x_4);
                float r2_y_3 = (r2_y_2 * r2_y_2);
                float r2_x_5 = (r2_x_4 * r2_y_3);
                float r1_y_6 = mad(r1_y_5, r2_x_5, 1);
                float r1_y_7 = (r1_y_6 * r1_z_6);
                float r1_y_8 = (r1_w_2 * r1_y_7);
                float r0_w_7 = (abs(r0_w_6) + r1_w_2);
                float r0_w_8 = (r0_w_7 + 1E-05);
                float r0_w_9 = (0.5 / r0_w_8);
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_y_6, r0_z_6, r0_w_9) * float4(0.7790837, 0.7790837, 0.7790837, 0.9999999));
                float r0_w_11 = max(r0_xyzw_10.w, 0.0001);
                float r0_w_12 = sqrt(r0_w_11);
                float r0_w_13 = (r1_w_2 * r0_w_12);
                float4 r1_xyzw_9 = mad(r6_xyz_1.xxyz, r1_y_8.xxxx, (max((mad(r7_xyz_15.xyzx, float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0))).xyzx, float4(0, 0, 0, 0))).xxyz);
                float r1_y_9 = r1_xyzw_9.y;
                float r1_z_7 = r1_xyzw_9.z;
                float r1_w_3 = r1_xyzw_9.w;
                float4 r2_xyzw_4 = (r6_xyz_1.xxyz * r0_w_13.xxxx);
                float r2_y_4 = r2_xyzw_4.y;
                float r2_z_2 = r2_xyzw_4.z;
                float r2_w_20 = r2_xyzw_4.w;
                float r0_w_14 = (-r1_x_4 + 1);
                float r1_x_5 = (r0_w_14 * r0_w_14);
                float r0_w_15 = (r0_w_14 * (r1_x_5 * r1_x_5));
                float r0_w_16 = mad(r0_w_15, 0.7790837, 0.2209163);
                float4 r2_xyzw_5 = (r0_w_16.xxxx * float4(r2_y_4, r2_y_4, r2_z_2, r2_w_20));
                float r2_y_5 = r2_xyzw_5.y;
                float r2_z_3 = r2_xyzw_5.z;
                float r2_w_21 = r2_xyzw_5.w;
                float4 r0_xyzw_11 = mad(r0_xyzw_10.xyzx, float4(r1_y_9, r1_z_7, r1_w_3, r1_y_9), float4(r2_y_5, r2_z_3, r2_w_21, r2_y_5));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_y_8 = r0_xyzw_11.y;
                float r0_z_8 = r0_xyzw_11.z;
                float4 r1_xyzw_7 = (r9_xyz_11.xyzx * float4(0.72, 0.72, 0.72, 0));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_10 = r1_xyzw_7.y;
                float r1_z_8 = r1_xyzw_7.z;
                float r0_w_17 = mad(r2_x_5, -2.9802322E-08, 0.2209163);
                float4 r0_xyzw_12 = mad(float4(r1_x_7, r1_y_10, r1_z_8, r1_x_7), r0_w_17.xxxx, float4(r0_x_11, r0_y_8, r0_z_8, r0_x_11));
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_9 = r0_xyzw_12.y;
                float r0_z_9 = r0_xyzw_12.z;
                float r0_w_18 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_19 = (-r0_w_18 + 1);
                float r0_w_20 = (r0_w_19 * cb1_values[5].z);
                float r0_w_21 = max(r0_w_20, 0);
                float r0_w_22 = mad(r0_w_21, unity_SpecCube0_BoxMin.z, unity_SpecCube0_BoxMin.w);
                float4 r0_xyzw_13 = (float4(r0_x_12, r0_y_9, r0_z_9, r0_x_12) + -unity_SpecCube0_BoxMax.xyzx);
                float r0_x_13 = r0_xyzw_13.x;
                float r0_y_10 = r0_xyzw_13.y;
                float r0_z_10 = r0_xyzw_13.z;
                o.sv_Target0.xyz = (mad(r0_w_22.xxxx, float4(r0_x_13, r0_y_10, r0_z_10, r0_x_13), unity_SpecCube0_BoxMax.xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One OneMinusSrcColor
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float _BumpScale;
                float _AlphaScale;
                float _DisplacementClouds;
                float4 _MainTex_ST;
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float3 _WorldSpaceCameraPos;
                float4 unity_WorldTransformParams;
                float4 cb1_values[6];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
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
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_linear_clamp1 : register(s1);
            SamplerState sampler_linear_clamp2 : register(s2);
            SamplerState sampler_linear_clamp3 : register(s3);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            TextureCube t2 : register(t2);
            TextureCube t3 : register(t3);
            Texture3D t4 : register(t4);
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
                float texcoord5 : TEXCOORD5;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program15Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord7 : TEXCOORD7;
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
                float3 r0_xyz_1 = (mad(i.normal0.xyzx, _DisplacementClouds.xxxx, i.position0.xyzx)).xyz;
                float4 r0_xyzw_2 = mad(unity_ObjectToWorld[2], r0_xyz_1.zzzz, mad(unity_ObjectToWorld[0], r0_xyz_1.xxxx, (r0_xyz_1.yyyy * unity_ObjectToWorld[1])));
                float4 r1_xyzw_3 = (r0_xyzw_2 + unity_ObjectToWorld[3]);
                float3 worldPos_xyz_3 = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, r0_xyzw_2.xyzx)).xyz;
                float4 r1_xyzw_4 = mad(unity_MatrixVP[3], r1_xyzw_3.wwww, mad(unity_MatrixVP[2], r1_xyzw_3.zzzz, mad(unity_MatrixVP[0], r1_xyzw_3.xxxx, (r1_xyzw_3.yyyy * unity_MatrixVP[1]))));
                o.sv_Position0.xyzw = UnityObjectToClipPos(r1_xyzw_3);
                o.texcoord5.x = r1_xyzw_4.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord1.w = worldPos_xyz_3.x;
                float worldNormal_y_5 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_5 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_5 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float3 unitWorldNormal_xyz_6 = (((rsqrt(dot(float4(worldNormal_x_5, worldNormal_y_5, worldNormal_z_5, worldNormal_x_5), float4(worldNormal_x_5, worldNormal_y_5, worldNormal_z_5, worldNormal_x_5)))).xxxx * float4(worldNormal_x_5, worldNormal_y_5, worldNormal_z_5, worldNormal_x_5))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = (((rsqrt(dot(worldTangent_xyz_6.xyzx, worldTangent_xyz_6.xyzx))).xxxx * worldTangent_xyz_6.xyzx)).xyz;
                float3 r3_xyz_3 = ((((i.tangent0.w * unity_WorldTransformParams.w)).xxxx * (mad(unitWorldNormal_xyz_6.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_6.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_6.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_6.z;
                o.texcoord3.z = unitWorldNormal_xyz_6.x;
                o.texcoord2.w = worldPos_xyz_3.y;
                o.texcoord3.w = worldPos_xyz_3.z;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program15Output frag(program15Input i)
            {
                program15Output o = (program15Output)0;
                float TEXCOORD1_x_1 = i.texcoord1.w;
                float TEXCOORD2_y_1 = i.texcoord2.w;
                float TEXCOORD3_z_1 = i.texcoord3.w;
                float3 viewDir_xyz_1 = ((-float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1) + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float4 r3_xyzw_1 = t0.Sample(sampler_linear_clamp2, (i.texcoord0.xyxx).xy);
                float4 r4_xyzw_1 = t1.Sample(sampler_linear_clamp3, (i.texcoord0.xyxx).xy);
                float r1_w_1 = (r3_xyzw_1.w * _AlphaScale);
                float r4_x_2 = (r4_xyzw_1.w * r4_xyzw_1.x);
                float4 r4_xyzw_3 = mad(float4(r4_x_2, r4_xyzw_1.y, r4_x_2, r4_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r4_x_3 = r4_xyzw_3.x;
                float r4_y_2 = r4_xyzw_3.y;
                float4 r4_xyzw_4 = (float4(r4_x_3, r4_y_2, r4_x_3, r4_x_3) * _BumpScale.xxxx);
                float r4_x_4 = r4_xyzw_4.x;
                float r4_y_3 = r4_xyzw_4.y;
                float r2_w_1 = dot(float4(r4_x_4, r4_y_3, r4_x_4, r4_x_4), float4(r4_x_4, r4_y_3, r4_x_4, r4_x_4));
                float r2_w_2 = min(r2_w_1, 1);
                float r2_w_3 = (-r2_w_2 + 1);
                float r4_z_2 = sqrt(r2_w_3);
                float r2_w_4 = dot(float4(r4_x_4, r4_y_3, r4_z_2, r4_x_4), float4(r4_x_4, r4_y_3, r4_z_2, r4_x_4));
                float r2_w_5 = rsqrt(r2_w_4);
                float4 r4_xyzw_5 = (r2_w_5.xxxx * float4(r4_x_4, r4_y_3, r4_z_2, r4_x_4));
                float r4_x_5 = r4_xyzw_5.x;
                float r4_y_4 = r4_xyzw_5.y;
                float r4_z_3 = r4_xyzw_5.z;
                float r2_w_6 = (cb5_values[0].x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r2_w_6)
                {
                    float r2_w_7 = (cb5_values[0].y == 1);
                    float3 r5_xyz_5 = (((mad(cb5_values[3].xyzx, i.texcoord3.wwww, (mad(cb5_values[1].xyzx, i.texcoord1.wwww, ((i.texcoord2.wwww * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r5_xyzw_8 = (((((r2_w_7.xxxx ? r5_xyz_5.xyzx : float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1))).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r2_w_8 = mad(r5_y_8, 0.25, 0.75);
                    float r3_w_2 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r5_x_8 = max(r2_w_8, r3_w_2);
                    float4 r5_xyzw_9 = t4.Sample(sampler_linear_clamp1, (float4(r5_x_8, r5_z_8, r5_w_2, r5_x_8)).xyz);
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
                float r2_w_10 = dot(float4(r5_x_10, r5_y_10, r5_z_10, r5_w_4), unity_OcclusionMaskSelector);
                float r5_x_11 = dot(i.texcoord1.xyzx, float4(r4_x_5, r4_y_4, r4_z_3, r4_x_5));
                float r5_y_11 = dot(i.texcoord2.xyzx, float4(r4_x_5, r4_y_4, r4_z_3, r4_x_5));
                float r5_z_11 = dot(i.texcoord3.xyzx, float4(r4_x_5, r4_y_4, r4_z_3, r4_x_5));
                float r3_w_4 = dot(float4(r5_x_11, r5_y_11, r5_z_11, r5_x_11), float4(r5_x_11, r5_y_11, r5_z_11, r5_x_11));
                float r3_w_5 = rsqrt(r3_w_4);
                float4 r4_xyzw_6 = (r3_w_5.xxxx * float4(r5_x_11, r5_y_11, r5_z_11, r5_x_11));
                float r4_x_6 = r4_xyzw_6.x;
                float r4_y_5 = r4_xyzw_6.y;
                float r4_z_4 = r4_xyzw_6.z;
                float r3_w_6 = dot(-unitViewDir_xyz_1.xyzx, float4(r4_x_6, r4_y_5, r4_z_4, r4_x_6));
                float r3_w_7 = (r3_w_6 + r3_w_6);
                float3 r5_xyz_12 = (mad(float4(r4_x_6, r4_y_5, r4_z_4, r4_x_6), -r3_w_7.xxxx, -unitViewDir_xyz_1.xyzx)).xyz;
                float3 r6_xyz_1 = ((r2_w_10.xxxx * _LightColor0.xyzx)).xyz;
                float r2_w_11 = (0 < unity_ProbeVolumeWorldToObject[1].w);
                float3 r7_xyz_4;
                if (r2_w_11)
                {
                    float3 r7_xyz_2 = normalize(r5_xyz_12);
                    float3 r10_xyz_1 = ((float4(0, 0, 0, 0) < r7_xyz_2.xyzx)).xyz;
                    float3 r8_xyz_3 = ((r10_xyz_1.xyzx ? ((((-float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1) + unity_ProbeVolumeParams.xyzx)).xyzx / r7_xyz_2.xyzx)).xyzx : ((((-float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1) + unity_ProbeVolumeWorldToObject[0].xyzx)).xyzx / r7_xyz_2.xyzx)).xyzx)).xyz;
                    float r2_w_14 = min(r8_xyz_3.y, r8_xyz_3.x);
                    float r2_w_15 = min(r8_xyz_3.z, r2_w_14);
                    r7_xyz_4 = (mad(r7_xyz_2.xyzx, r2_w_15.xxxx, ((float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1) + -unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyz;
                }
                else
                {
                    r7_xyz_4 = r5_xyz_12.xyz;
                }
                float4 r7_xyzw_5 = t2.SampleLevel(sampler_linear_clamp, r7_xyz_4.xyz, 6);
                float r2_w_17 = (r7_xyzw_5.w + -1);
                float r2_w_18 = mad(unity_ProbeVolumeWorldToObject[2].w, r2_w_17, 1);
                float r2_w_19 = (r2_w_18 * unity_ProbeVolumeWorldToObject[2].x);
                float r3_w_8 = (unity_ProbeVolumeWorldToObject[0].w < 0.99999);
                float3 r8_xyz_8 = ((r7_xyzw_5.xyzx * r2_w_19.xxxx)).xyz;
                if (r3_w_8)
                {
                    float r3_w_9 = (0 < cb4_values[6].w);
                    float3 r5_xyz_14 = r5_xyz_12;
                    if (r3_w_9)
                    {
                        float3 r9_xyz_4 = normalize(r5_xyz_12);
                        float3 r12_xyz_1 = ((float4(0, 0, 0, 0) < r9_xyz_4.xyzx)).xyz;
                        float3 r10_xyz_5 = ((r12_xyz_1.xyzx ? ((((-float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1) + unity_ProbeVolumeWorldToObject[3].xyzx)).xyzx / r9_xyz_4.xyzx)).xyzx : ((((-float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1) + unity_ProbeVolumeSizeInv.xyzx)).xyzx / r9_xyz_4.xyzx)).xyzx)).xyz;
                        float r3_w_12 = min(r10_xyz_5.y, r10_xyz_5.x);
                        float r3_w_13 = min(r10_xyz_5.z, r3_w_12);
                        r5_xyz_14 = (mad(r9_xyz_4.xyzx, r3_w_13.xxxx, ((float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1) + -unity_ProbeVolumeMin.xyzx)).xyzx)).xyz;
                    }
                    float4 r5_xyzw_15 = t3.SampleLevel(sampler_linear_clamp, r5_xyz_14.xyz, 6);
                    float4 r0_xyzw_7 = (r5_xyzw_15.xyzx * ((mad(cb4_values[7].w, (r5_xyzw_15.w + -1), 1) * cb4_values[7].x)).xxxx);
                    float r0_x_7 = r0_xyzw_7.x;
                    float r0_y_4 = r0_xyzw_7.y;
                    float r0_z_4 = r0_xyzw_7.z;
                    r8_xyz_8 = (mad(unity_ProbeVolumeWorldToObject[0].wwww, (mad(r2_w_19.xxxx, r7_xyzw_5.xyzx, -float4(r0_x_7, r0_y_4, r0_z_4, r0_x_7))).xyzx, float4(r0_x_7, r0_y_4, r0_z_4, r0_x_7))).xyz;
                }
                float4 r0_xyzw_9 = (r1_w_1.xxxx * r3_xyzw_1.xyzx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_6 = r0_xyzw_9.y;
                float r0_z_6 = r0_xyzw_9.z;
                o.sv_Target0.w = mad(r1_w_1, 0.7790837, 0.22091627);
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float r0_w_6 = dot(float4(r4_x_6, r4_y_5, r4_z_4, r4_x_6), unitViewDir_xyz_1.xyzx);
                float r1_w_2 = dot(float4(r4_x_6, r4_y_5, r4_z_4, r4_x_6), _WorldSpaceLightPos0.xyzx);
                float r1_x_4 = dot(_WorldSpaceLightPos0.xyzx, ((r0_w_5.xxxx * r1_xyz_2.xyzx)).xyzx);
                float r1_y_4 = dot(r1_x_4.xxxx, r1_x_4.xxxx);
                float r1_y_5 = (r1_y_4 + -0.5);
                float r1_z_4 = (-r1_w_2 + 1);
                float r2_x_2 = (r1_z_4 * r1_z_4);
                float r1_z_5 = (r1_z_4 * (r2_x_2 * r2_x_2));
                float r1_z_6 = mad(r1_y_5, r1_z_5, 1);
                float r2_x_4 = (-abs(r0_w_6) + 1);
                float r2_y_2 = (r2_x_4 * r2_x_4);
                float r2_y_3 = (r2_y_2 * r2_y_2);
                float r2_x_5 = (r2_x_4 * r2_y_3);
                float r1_y_6 = mad(r1_y_5, r2_x_5, 1);
                float r1_y_7 = (r1_y_6 * r1_z_6);
                float r1_y_8 = (r1_w_2 * r1_y_7);
                float r0_w_7 = (abs(r0_w_6) + r1_w_2);
                float r0_w_8 = (r0_w_7 + 1E-05);
                float r0_w_9 = (0.5 / r0_w_8);
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_y_6, r0_z_6, r0_w_9) * float4(0.7790837, 0.7790837, 0.7790837, 0.9999999));
                float r0_w_11 = max(r0_xyzw_10.w, 0.0001);
                float r0_w_12 = sqrt(r0_w_11);
                float r0_w_13 = (r1_w_2 * r0_w_12);
                float4 r1_xyzw_9 = (r1_y_8.xxxx * r6_xyz_1.xxyz);
                float r1_y_9 = r1_xyzw_9.y;
                float r1_z_7 = r1_xyzw_9.z;
                float r1_w_3 = r1_xyzw_9.w;
                float4 r2_xyzw_4 = (r6_xyz_1.xxyz * r0_w_13.xxxx);
                float r2_y_4 = r2_xyzw_4.y;
                float r2_z_2 = r2_xyzw_4.z;
                float r2_w_20 = r2_xyzw_4.w;
                float r0_w_14 = (-r1_x_4 + 1);
                float r1_x_5 = (r0_w_14 * r0_w_14);
                float r0_w_15 = (r0_w_14 * (r1_x_5 * r1_x_5));
                float r0_w_16 = mad(r0_w_15, 0.7790837, 0.2209163);
                float4 r2_xyzw_5 = (r0_w_16.xxxx * float4(r2_y_4, r2_y_4, r2_z_2, r2_w_20));
                float r2_y_5 = r2_xyzw_5.y;
                float r2_z_3 = r2_xyzw_5.z;
                float r2_w_21 = r2_xyzw_5.w;
                float4 r0_xyzw_11 = mad(r0_xyzw_10.xyzx, float4(r1_y_9, r1_z_7, r1_w_3, r1_y_9), float4(r2_y_5, r2_z_3, r2_w_21, r2_y_5));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_y_8 = r0_xyzw_11.y;
                float r0_z_8 = r0_xyzw_11.z;
                float4 r1_xyzw_7 = (r8_xyz_8.xyzx * float4(0.72, 0.72, 0.72, 0));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_10 = r1_xyzw_7.y;
                float r1_z_8 = r1_xyzw_7.z;
                float r0_w_17 = mad(r2_x_5, -2.9802322E-08, 0.2209163);
                float4 r0_xyzw_12 = mad(float4(r1_x_7, r1_y_10, r1_z_8, r1_x_7), r0_w_17.xxxx, float4(r0_x_11, r0_y_8, r0_z_8, r0_x_11));
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_9 = r0_xyzw_12.y;
                float r0_z_9 = r0_xyzw_12.z;
                float r0_w_18 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_19 = (-r0_w_18 + 1);
                float r0_w_20 = (r0_w_19 * cb1_values[5].z);
                float r0_w_21 = max(r0_w_20, 0);
                float r0_w_22 = mad(r0_w_21, unity_SpecCube0_BoxMin.z, unity_SpecCube0_BoxMin.w);
                float4 r0_xyzw_13 = (float4(r0_x_12, r0_y_9, r0_z_9, r0_x_12) + -unity_SpecCube0_BoxMax.xyzx);
                float r0_x_13 = r0_xyzw_13.x;
                float r0_y_10 = r0_xyzw_13.y;
                float r0_z_10 = r0_xyzw_13.z;
                o.sv_Target0.xyz = (mad(r0_w_22.xxxx, float4(r0_x_13, r0_y_10, r0_z_10, r0_x_13), unity_SpecCube0_BoxMax.xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One OneMinusSrcColor
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float _BumpScale;
                float _AlphaScale;
                float _DisplacementClouds;
                float4 _MainTex_ST;
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float3 _WorldSpaceCameraPos;
                float4 unity_WorldTransformParams;
                float4 cb1_values[46];
            };
            cbuffer UnityPerFrame : register(b2)
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
            cbuffer UnityProbeVolume : register(b4)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
            };
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_linear_clamp1 : register(s1);
            SamplerState sampler_linear_clamp2 : register(s2);
            SamplerState sampler_linear_clamp3 : register(s3);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            TextureCube t2 : register(t2);
            TextureCube t3 : register(t3);
            Texture3D t4 : register(t4);
            struct program4Input
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
            struct program4Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program14Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program14Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program4Output vert(program4Input i)
            {
                program4Output o = (program4Output)0;
                float3 r0_xyz_1 = (mad(i.normal0.xyzx, _DisplacementClouds.xxxx, i.position0.xyzx)).xyz;
                float4 r0_xyzw_2 = mad(cb2_values[2].xyzw, r0_xyz_1.zzzz, mad(cb2_values[0].xyzw, r0_xyz_1.xxxx, (r0_xyz_1.yyyy * cb2_values[1].xyzw)));
                float4 r1_xyzw_3 = (r0_xyzw_2 + cb2_values[3].xyzw);
                float3 r0_xyz_3 = (mad(cb2_values[3].xyzx, i.position0.wwww, r0_xyzw_2.xyzx)).xyz;
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), r1_xyzw_3);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord1.w = r0_xyz_3.x;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * cb2_values[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(cb2_values[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(cb2_values[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = (((rsqrt(dot(worldTangent_xyz_6.xyzx, worldTangent_xyz_6.xyzx))).xxxx * worldTangent_xyz_6.xyzx)).xyz;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                float worldNormal_x_4 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float4 unitWorldNormal_xyzw_5 = ((rsqrt(dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4)))).xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_z_4));
                float3 r3_xyz_3 = ((((i.tangent0.w * cb2_values[9].w)).xxxx * (mad(unitWorldNormal_xyzw_5.ywxy, unitWorldTangent_xyz_7.yzxy, ((unitWorldTangent_xyz_7.xyzx * unitWorldNormal_xyzw_5.wxyw)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.z = unitWorldNormal_xyzw_5.x;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.w = r0_xyz_3.y;
                o.texcoord3.w = r0_xyz_3.z;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord2.z = unitWorldNormal_xyzw_5.y;
                o.texcoord3.z = unitWorldNormal_xyzw_5.w;
                float4 r1_xyzw_8 = (unitWorldNormal_xyzw_5.ywzx * unitWorldNormal_xyzw_5);
                float r2_x_6 = dot(cb1_values[42].xyzw, r1_xyzw_8);
                float r2_y_6 = dot(cb1_values[43].xyzw, r1_xyzw_8);
                float r2_z_6 = dot(cb1_values[44].xyzw, r1_xyzw_8);
                o.texcoord4.xyz = (mad(cb1_values[45].xyzx, (mad(unitWorldNormal_xyzw_5.x, unitWorldNormal_xyzw_5.x, (unitWorldNormal_xyzw_5.y * unitWorldNormal_xyzw_5.y))).xxxx, float4(r2_x_6, r2_y_6, r2_z_6, r2_x_6))).xyz;
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program14Output frag(program14Input i)
            {
                program14Output o = (program14Output)0;
                float TEXCOORD1_x_1 = i.texcoord1.w;
                float TEXCOORD2_y_1 = i.texcoord2.w;
                float TEXCOORD3_z_1 = i.texcoord3.w;
                float3 viewDir_xyz_1 = ((-float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1) + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float4 r3_xyzw_1 = t0.Sample(sampler_linear_clamp2, (i.texcoord0.xyxx).xy);
                float4 r4_xyzw_1 = t1.Sample(sampler_linear_clamp3, (i.texcoord0.xyxx).xy);
                float r1_w_1 = (r3_xyzw_1.w * _AlphaScale);
                float r4_x_2 = (r4_xyzw_1.w * r4_xyzw_1.x);
                float4 r4_xyzw_3 = mad(float4(r4_x_2, r4_xyzw_1.y, r4_x_2, r4_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r4_x_3 = r4_xyzw_3.x;
                float r4_y_2 = r4_xyzw_3.y;
                float4 r4_xyzw_4 = (float4(r4_x_3, r4_y_2, r4_x_3, r4_x_3) * _BumpScale.xxxx);
                float r4_x_4 = r4_xyzw_4.x;
                float r4_y_3 = r4_xyzw_4.y;
                float r2_w_1 = dot(float4(r4_x_4, r4_y_3, r4_x_4, r4_x_4), float4(r4_x_4, r4_y_3, r4_x_4, r4_x_4));
                float r2_w_2 = min(r2_w_1, 1);
                float r2_w_3 = (-r2_w_2 + 1);
                float r4_z_2 = sqrt(r2_w_3);
                float r2_w_4 = dot(float4(r4_x_4, r4_y_3, r4_z_2, r4_x_4), float4(r4_x_4, r4_y_3, r4_z_2, r4_x_4));
                float r2_w_5 = rsqrt(r2_w_4);
                float4 r4_xyzw_5 = (r2_w_5.xxxx * float4(r4_x_4, r4_y_3, r4_z_2, r4_x_4));
                float r4_x_5 = r4_xyzw_5.x;
                float r4_y_4 = r4_xyzw_5.y;
                float r4_z_3 = r4_xyzw_5.z;
                float r2_w_6 = (unity_ProbeVolumeParams.x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r2_w_6)
                {
                    float r3_w_2 = (unity_ProbeVolumeParams.y == 1);
                    float3 r5_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord3.wwww, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.wwww, ((i.texcoord2.wwww * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r3_w_2.xxxx ? r5_xyz_5.xyzx : float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1))).xyz;
                    float4 r5_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r3_w_3 = mad(r5_y_8, 0.25, 0.75);
                    float r4_w_2 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r5_x_8 = max(r3_w_3, r4_w_2);
                    float4 r5_xyzw_9 = t4.Sample(sampler_linear_clamp1, (float4(r5_x_8, r5_z_8, r5_w_2, r5_x_8)).xyz);
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
                float r3_w_5 = dot(float4(r5_x_10, r5_y_10, r5_z_10, r5_w_4), unity_OcclusionMaskSelector);
                float r5_x_11 = dot(i.texcoord1.xyzx, float4(r4_x_5, r4_y_4, r4_z_3, r4_x_5));
                float r5_y_11 = dot(i.texcoord2.xyzx, float4(r4_x_5, r4_y_4, r4_z_3, r4_x_5));
                float r5_z_11 = dot(i.texcoord3.xyzx, float4(r4_x_5, r4_y_4, r4_z_3, r4_x_5));
                float4 r4_xyzw_8 = ((rsqrt(dot(float4(r5_x_11, r5_y_11, r5_z_11, r5_x_11), float4(r5_x_11, r5_y_11, r5_z_11, r5_x_11)))).xxxx * float4(r5_x_11, r5_y_11, r5_z_11, r5_x_11));
                float r4_x_8 = r4_xyzw_8.x;
                float r4_y_5 = r4_xyzw_8.y;
                float r4_z_4 = r4_xyzw_8.z;
                float r5_x_12 = dot(-unitViewDir_xyz_1.xyzx, float4(r4_x_8, r4_y_5, r4_z_4, r4_x_8));
                float4 r5_xyzw_14 = mad(float4(r4_x_8, r4_y_5, r4_z_4, r4_x_8), ((r5_x_12 + r5_x_12)).xxxx, -unitViewDir_xyz_1.xyzx);
                float r5_x_14 = r5_xyzw_14.x;
                float r5_y_12 = r5_xyzw_14.y;
                float r5_z_12 = r5_xyzw_14.z;
                float3 r6_xyz_1 = ((r3_w_5.xxxx * _LightColor0.xyzx)).xyz;
                float3 r8_xyz_4;
                if (r2_w_6)
                {
                    float r2_w_7 = (unity_ProbeVolumeParams.y == 1);
                    float3 r7_xyz_4 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord3.wwww, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.wwww, ((i.texcoord2.wwww * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_5 = ((r2_w_7.xxxx ? r7_xyz_4.xyzx : float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1))).xyz;
                    float4 r7_xyzw_7 = (((unity_ProbeVolumeParamsSelect_xyz_5.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r7_y_7 = r7_xyzw_7.y;
                    float r7_z_7 = r7_xyzw_7.z;
                    float r7_w_1 = r7_xyzw_7.w;
                    float r2_w_8 = (r7_y_7 * 0.25);
                    float r3_w_6 = (unity_ProbeVolumeParams.z * 0.5);
                    float r5_w_5 = mad(-unity_ProbeVolumeParams.z, 0.5, 0.25);
                    float r2_w_9 = max(r2_w_8, r3_w_6);
                    float r7_x_7 = min(r5_w_5, r2_w_9);
                    float4 r8_xyzw_2 = t4.Sample(sampler_linear_clamp1, (float4(r7_x_7, r7_z_7, r7_w_1, r7_x_7)).xyz);
                    float4 r9_xyzw_2 = t4.Sample(sampler_linear_clamp1, (((float4(r7_x_7, r7_z_7, r7_w_1, r7_x_7) + float4(0.25, 0, 0, 0))).xyzx).xyz);
                    float4 r7_xyzw_9 = t4.Sample(sampler_linear_clamp1, (((float4(r7_x_7, r7_z_7, r7_w_1, r7_x_7) + float4(0.5, 0, 0, 0))).xyzx).xyz);
                    float r4_w_5 = 1;
                    float r8_x_3 = dot(r8_xyzw_2, float4(r4_x_8, r4_y_5, r4_z_4, r4_w_5));
                    float r8_y_3 = dot(r9_xyzw_2, float4(r4_x_8, r4_y_5, r4_z_4, r4_w_5));
                    float r8_z_3 = dot(r7_xyzw_9, float4(r4_x_8, r4_y_5, r4_z_4, r4_w_5));
                    r8_xyz_4 = float3(r8_x_3, r8_y_3, r8_z_3);
                }
                else
                {
                    float r4_w_4 = 1;
                    float r8_x_1 = dot(cb2_values[39].xyzw, float4(r4_x_8, r4_y_5, r4_z_4, r4_w_4));
                    float r8_y_1 = dot(cb2_values[40].xyzw, float4(r4_x_8, r4_y_5, r4_z_4, r4_w_4));
                    float r8_z_1 = dot(cb2_values[41].xyzw, float4(r4_x_8, r4_y_5, r4_z_4, r4_w_4));
                    r8_xyz_4 = float3(r8_x_1, r8_y_1, r8_z_1);
                }
                                float3 r7_xyz_15 = (pow(max((r8_xyz_4.xyzx + i.texcoord4.xyzx).xyz, float3(0, 0, 0)), float3(0.41666666, 0.41666666, 0.41666666)));
                float r2_w_11 = (0 < unity_SpecCube0_ProbePosition.w);
                float3 r8_xyz_8;
                if (r2_w_11)
                {
                    float r2_w_12 = dot(float4(r5_x_14, r5_y_12, r5_z_12, r5_x_14), float4(r5_x_14, r5_y_12, r5_z_12, r5_x_14));
                    float r2_w_13 = rsqrt(r2_w_12);
                    float3 r8_xyz_6 = ((r2_w_13.xxxx * float4(r5_x_14, r5_y_12, r5_z_12, r5_x_14))).xyz;
                    float3 r11_xyz_1 = ((float4(0, 0, 0, 0) < r8_xyz_6.xyzx)).xyz;
                    float3 r9_xyz_6 = ((r11_xyz_1.xyzx ? ((((-float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1) + unity_SpecCube0_BoxMax.xyzx)).xyzx / r8_xyz_6.xyzx)).xyzx : ((((-float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1) + unity_SpecCube0_BoxMin.xyzx)).xyzx / r8_xyz_6.xyzx)).xyzx)).xyz;
                    float r2_w_14 = min(r9_xyz_6.y, r9_xyz_6.x);
                    float r2_w_15 = min(r9_xyz_6.z, r2_w_14);
                    r8_xyz_8 = (mad(r8_xyz_6.xyzx, r2_w_15.xxxx, ((float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1) + -unity_SpecCube0_ProbePosition.xyzx)).xyzx)).xyz;
                }
                else
                {
                    r8_xyz_8 = (float4(r5_x_14, r5_y_12, r5_z_12, r5_x_14)).xyz;
                }
                float4 r8_xyzw_9 = t2.SampleLevel(sampler_linear_clamp, r8_xyz_8.xyz, 6);
                float r2_w_17 = (r8_xyzw_9.w + -1);
                float r2_w_18 = mad(unity_SpecCube0_HDR.w, r2_w_17, 1);
                float r2_w_19 = (r2_w_18 * unity_SpecCube0_HDR.x);
                float r3_w_8 = (unity_SpecCube0_BoxMin.w < 0.99999);
                float3 r9_xyz_11 = ((r8_xyzw_9.xyzx * r2_w_19.xxxx)).xyz;
                if (r3_w_8)
                {
                    float r3_w_9 = (0 < unity_SpecCube1_ProbePosition.w);
                    float r5_x_16 = r5_x_14;
                    float r5_y_14 = r5_y_12;
                    float r5_z_14 = r5_z_12;
                    if (r3_w_9)
                    {
                        float r3_w_10 = dot(float4(r5_x_14, r5_y_12, r5_z_12, r5_x_14), float4(r5_x_14, r5_y_12, r5_z_12, r5_x_14));
                        float r3_w_11 = rsqrt(r3_w_10);
                        float3 r10_xyz_4 = ((r3_w_11.xxxx * float4(r5_x_14, r5_y_12, r5_z_12, r5_x_14))).xyz;
                        float3 r13_xyz_1 = ((float4(0, 0, 0, 0) < r10_xyz_4.xyzx)).xyz;
                        float3 r11_xyz_5 = ((r13_xyz_1.xyzx ? ((((-float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1) + unity_SpecCube1_BoxMax.xyzx)).xyzx / r10_xyz_4.xyzx)).xyzx : ((((-float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1) + unity_SpecCube1_BoxMin.xyzx)).xyzx / r10_xyz_4.xyzx)).xyzx)).xyz;
                        float r3_w_12 = min(r11_xyz_5.y, r11_xyz_5.x);
                        float r3_w_13 = min(r11_xyz_5.z, r3_w_12);
                        float4 r5_xyzw_15 = mad(r10_xyz_4.xyzx, r3_w_13.xxxx, ((float4(TEXCOORD1_x_1, TEXCOORD2_y_1, TEXCOORD3_z_1, TEXCOORD1_x_1) + -unity_SpecCube1_ProbePosition.xyzx)).xyzx);
                        float r5_x_15 = r5_xyzw_15.x;
                        float r5_y_13 = r5_xyzw_15.y;
                        float r5_z_13 = r5_xyzw_15.z;
                        r5_x_16 = r5_x_15;
                        r5_y_14 = r5_y_13;
                        r5_z_14 = r5_z_13;
                    }
                    float4 r5_xyzw_17 = t3.SampleLevel(sampler_linear_clamp, (float4(r5_x_16, r5_y_14, r5_z_14, r5_x_16)).xyz, 6);
                    float4 r0_xyzw_7 = (r5_xyzw_17.xyzx * ((mad(unity_SpecCube1_HDR.w, (r5_xyzw_17.w + -1), 1) * unity_SpecCube1_HDR.x)).xxxx);
                    float r0_x_7 = r0_xyzw_7.x;
                    float r0_y_4 = r0_xyzw_7.y;
                    float r0_z_4 = r0_xyzw_7.z;
                    float4 r5_xyzw_18 = mad(r2_w_19.xxxx, r8_xyzw_9.xyzx, -float4(r0_x_7, r0_y_4, r0_z_4, r0_x_7));
                    float r5_x_18 = r5_xyzw_18.x;
                    float r5_y_16 = r5_xyzw_18.y;
                    float r5_z_16 = r5_xyzw_18.z;
                    r9_xyz_11 = (mad(unity_SpecCube0_BoxMin.wwww, float4(r5_x_18, r5_y_16, r5_z_16, r5_x_18), float4(r0_x_7, r0_y_4, r0_z_4, r0_x_7))).xyz;
                }
                float4 r0_xyzw_9 = (r1_w_1.xxxx * r3_xyzw_1.xyzx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_6 = r0_xyzw_9.y;
                float r0_z_6 = r0_xyzw_9.z;
                o.sv_Target0.w = mad(r1_w_1, 0.7790837, 0.22091627);
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float r0_w_6 = dot(float4(r4_x_8, r4_y_5, r4_z_4, r4_x_8), unitViewDir_xyz_1.xyzx);
                float r1_w_2 = dot(float4(r4_x_8, r4_y_5, r4_z_4, r4_x_8), _WorldSpaceLightPos0.xyzx);
                float r1_x_4 = dot(_WorldSpaceLightPos0.xyzx, ((r0_w_5.xxxx * r1_xyz_2.xyzx)).xyzx);
                float r1_y_4 = dot(r1_x_4.xxxx, r1_x_4.xxxx);
                float r1_y_5 = (r1_y_4 + -0.5);
                float r1_z_4 = (-r1_w_2 + 1);
                float r2_x_2 = (r1_z_4 * r1_z_4);
                float r1_z_5 = (r1_z_4 * (r2_x_2 * r2_x_2));
                float r1_z_6 = mad(r1_y_5, r1_z_5, 1);
                float r2_x_4 = (-abs(r0_w_6) + 1);
                float r2_y_2 = (r2_x_4 * r2_x_4);
                float r2_y_3 = (r2_y_2 * r2_y_2);
                float r2_x_5 = (r2_x_4 * r2_y_3);
                float r1_y_6 = mad(r1_y_5, r2_x_5, 1);
                float r1_y_7 = (r1_y_6 * r1_z_6);
                float r1_y_8 = (r1_w_2 * r1_y_7);
                float r0_w_7 = (abs(r0_w_6) + r1_w_2);
                float r0_w_8 = (r0_w_7 + 1E-05);
                float r0_w_9 = (0.5 / r0_w_8);
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_y_6, r0_z_6, r0_w_9) * float4(0.7790837, 0.7790837, 0.7790837, 0.9999999));
                float r0_w_11 = max(r0_xyzw_10.w, 0.0001);
                float r0_w_12 = sqrt(r0_w_11);
                float r0_w_13 = (r1_w_2 * r0_w_12);
                float4 r1_xyzw_9 = mad(r6_xyz_1.xxyz, r1_y_8.xxxx, (max((mad(r7_xyz_15.xyzx, float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0))).xyzx, float4(0, 0, 0, 0))).xxyz);
                float r1_y_9 = r1_xyzw_9.y;
                float r1_z_7 = r1_xyzw_9.z;
                float r1_w_3 = r1_xyzw_9.w;
                float4 r2_xyzw_4 = (r6_xyz_1.xxyz * r0_w_13.xxxx);
                float r2_y_4 = r2_xyzw_4.y;
                float r2_z_2 = r2_xyzw_4.z;
                float r2_w_20 = r2_xyzw_4.w;
                float r0_w_14 = (-r1_x_4 + 1);
                float r1_x_5 = (r0_w_14 * r0_w_14);
                float r0_w_15 = (r0_w_14 * (r1_x_5 * r1_x_5));
                float r0_w_16 = mad(r0_w_15, 0.7790837, 0.2209163);
                float4 r2_xyzw_5 = (r0_w_16.xxxx * float4(r2_y_4, r2_y_4, r2_z_2, r2_w_20));
                float r2_y_5 = r2_xyzw_5.y;
                float r2_z_3 = r2_xyzw_5.z;
                float r2_w_21 = r2_xyzw_5.w;
                float4 r0_xyzw_11 = mad(r0_xyzw_10.xyzx, float4(r1_y_9, r1_z_7, r1_w_3, r1_y_9), float4(r2_y_5, r2_z_3, r2_w_21, r2_y_5));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_y_8 = r0_xyzw_11.y;
                float r0_z_8 = r0_xyzw_11.z;
                float4 r1_xyzw_7 = (r9_xyz_11.xyzx * float4(0.72, 0.72, 0.72, 0));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_10 = r1_xyzw_7.y;
                float r1_z_8 = r1_xyzw_7.z;
                float r0_w_17 = mad(r2_x_5, -2.9802322E-08, 0.2209163);
                o.sv_Target0.xyz = (mad(float4(r1_x_7, r1_y_10, r1_z_8, r1_x_7), r0_w_17.xxxx, float4(r0_x_11, r0_y_8, r0_z_8, r0_x_11))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Highatmospherecolor;
                float _BumpScale;
                float4 _Lowatmospherecolor;
                float _AlphaScale;
                float _DisplacementClouds;
                float4 _MainTex_ST;
                float _Outeratmopsheredensity;
                float _Inneratmopsheredensity;
                float _Innerouterlimit;
                float _Inneroutersmoothness;
                float _Outeratmospherelimit;
                float4 _Inneratmosphere;
                float _DisplacementAtmosphere;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float3 _WorldSpaceCameraPos;
                float4 unity_WorldTransformParams;
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
            };
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_linear_clamp1 : register(s1);
            SamplerState sampler_linear_clamp2 : register(s2);
            SamplerState sampler_linear_clamp3 : register(s3);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture2D t2 : register(t2);
            Texture3D t3 : register(t3);
            struct program19Input
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
            struct program19Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
            };
            struct program37Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
            };
            struct program37Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program19Output vert(program19Input i)
            {
                program19Output o = (program19Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float3 r0_xyz_1 = (mad(i.normal0.xyzx, cb0_values[8].zzzz, i.position0.xyzx)).xyz;
                float4 r0_xyzw_2 = mad(unity_ObjectToWorld[2], r0_xyz_1.zzzz, mad(unity_ObjectToWorld[0], r0_xyz_1.xxxx, (r0_xyz_1.yyyy * unity_ObjectToWorld[1])));
                float4 r1_xyzw_3 = (r0_xyzw_2 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(r1_xyzw_3);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_y_4 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_4 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_4 = dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4));
                float r1_w_5 = rsqrt(r1_w_4);
                float3 unitWorldNormal_xyz_5 = ((r1_w_5.xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_8 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_8.xxxx * (mad(unitWorldNormal_xyz_5.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_5.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_5.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_5.z;
                o.texcoord3.z = unitWorldNormal_xyz_5.x;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord4.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, r0_xyzw_2.xyzx)).xyz;
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[3], i.position0.wwww, r0_xyzw_2);
                float3 clipPos_xyz_6 = ((worldPos_xyzw_3.yyyy * _MainTex_ST.xyzx)).xyz;
                float3 clipPos_xyz_7 = (mad(_Lowatmospherecolor.xyzx, worldPos_xyzw_3.xxxx, clipPos_xyz_6.xyzx)).xyz;
                float3 clipPos_xyz_4 = (mad(cb0_values[6].xyzx, worldPos_xyzw_3.zzzz, clipPos_xyz_7.xyzx)).xyz;
                o.texcoord5.xyz = (mad(_Inneratmosphere.xyzx, worldPos_xyzw_3.wwww, clipPos_xyz_4.xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program37Output frag(program37Input i)
            {
                program37Output o = (program37Output)0;
                float3 r0_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 r2_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float3 r2_xyz_2 = normalize(r2_xyz_1);
                float4 r3_xyzw_1 = t0.Sample(sampler_linear_clamp2, (i.texcoord0.xyxx).xy);
                float4 r4_xyzw_1 = t1.Sample(sampler_linear_clamp3, (i.texcoord0.xyxx).xy);
                float r1_w_3 = (r3_xyzw_1.w * cb0_values[8].y);
                float r4_x_2 = (r4_xyzw_1.w * r4_xyzw_1.x);
                float4 r4_xyzw_3 = mad(float4(r4_x_2, r4_xyzw_1.y, r4_x_2, r4_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r4_x_3 = r4_xyzw_3.x;
                float r4_y_2 = r4_xyzw_3.y;
                float4 r4_xyzw_4 = (float4(r4_x_3, r4_y_2, r4_x_3, r4_x_3) * cb0_values[8].xxxx);
                float r4_x_4 = r4_xyzw_4.x;
                float r4_y_3 = r4_xyzw_4.y;
                float r2_w_1 = dot(float4(r4_x_4, r4_y_3, r4_x_4, r4_x_4), float4(r4_x_4, r4_y_3, r4_x_4, r4_x_4));
                float r2_w_2 = min(r2_w_1, 1);
                float r2_w_3 = (-r2_w_2 + 1);
                float r4_z_2 = sqrt(r2_w_3);
                float r2_w_4 = dot(float4(r4_x_4, r4_y_3, r4_z_2, r4_x_4), float4(r4_x_4, r4_y_3, r4_z_2, r4_x_4));
                float r2_w_5 = rsqrt(r2_w_4);
                float4 r4_xyzw_5 = (r2_w_5.xxxx * float4(r4_x_4, r4_y_3, r4_z_2, r4_x_4));
                float r4_x_5 = r4_xyzw_5.x;
                float r4_y_4 = r4_xyzw_5.y;
                float r4_z_3 = r4_xyzw_5.z;
                float3 r5_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord4.zzzz, (mad(cb0_values[4].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r2_w_6 = (unity_ProbeVolumeParams.x == 1);
                float r6_x_10;
                float r6_y_10;
                float r6_z_10;
                float r6_w_4;
                if (r2_w_6)
                {
                    float r2_w_7 = (unity_ProbeVolumeParams.y == 1);
                    float3 r6_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord4.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r2_w_7.xxxx ? r6_xyz_5.xyzx : i.texcoord4.xyzx)).xyz;
                    float4 r6_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r6_y_8 = r6_xyzw_8.y;
                    float r6_z_8 = r6_xyzw_8.z;
                    float r6_w_2 = r6_xyzw_8.w;
                    float r2_w_8 = mad(r6_y_8, 0.25, 0.75);
                    float r3_w_2 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r6_x_8 = max(r2_w_8, r3_w_2);
                    float4 r6_xyzw_9 = t3.Sample(sampler_linear_clamp, (float4(r6_x_8, r6_z_8, r6_w_2, r6_x_8)).xyz);
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
                float r2_w_10 = dot(float4(r6_x_10, r6_y_10, r6_z_10, r6_w_4), unity_OcclusionMaskSelector);
                float r3_w_4 = dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx);
                float4 r5_xyzw_5 = t2.Sample(sampler_linear_clamp1, (r3_w_4.xxxx).xy);
                float r2_w_11 = (r2_w_10 * r5_xyzw_5.x);
                float r5_x_6 = dot(i.texcoord1.xyzx, float4(r4_x_5, r4_y_4, r4_z_3, r4_x_5));
                float r5_y_6 = dot(i.texcoord2.xyzx, float4(r4_x_5, r4_y_4, r4_z_3, r4_x_5));
                float r5_z_6 = dot(i.texcoord3.xyzx, float4(r4_x_5, r4_y_4, r4_z_3, r4_x_5));
                float r3_w_5 = dot(float4(r5_x_6, r5_y_6, r5_z_6, r5_x_6), float4(r5_x_6, r5_y_6, r5_z_6, r5_x_6));
                float r3_w_6 = rsqrt(r3_w_5);
                float4 r4_xyzw_6 = (r3_w_6.xxxx * float4(r5_x_6, r5_y_6, r5_z_6, r5_x_6));
                float r4_x_6 = r4_xyzw_6.x;
                float r4_y_5 = r4_xyzw_6.y;
                float r4_z_4 = r4_xyzw_6.z;
                float3 r5_xyz_7 = ((r2_w_11.xxxx * _LightColor0.xyzx)).xyz;
                o.sv_Target0.w = mad(r1_w_3, 0.7790837, 0.22091627);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, r2_xyz_2.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float r0_w_6 = dot(float4(r4_x_6, r4_y_5, r4_z_4, r4_x_6), r2_xyz_2.xyzx);
                float r1_w_4 = dot(float4(r4_x_6, r4_y_5, r4_z_4, r4_x_6), r1_xyz_1.xyzx);
                float r0_x_4 = dot(r1_xyz_1.xyzx, ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyzx);
                float r0_y_4 = dot(r0_x_4.xxxx, r0_x_4.xxxx);
                float r0_y_5 = (r0_y_4 + -0.5);
                float r0_z_4 = (-r1_w_4 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_5, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_6 = mad(r0_y_5, (r1_x_4 * r1_y_3), 1);
                float r0_y_7 = (r0_y_6 * r0_z_6);
                float r0_z_7 = (abs(r0_w_6) + r1_w_4);
                float r0_z_8 = (r0_z_7 + 1E-05);
                float r0_z_9 = (0.5 / r0_z_8);
                float r0_z_10 = (r0_z_9 * 0.9999999);
                float r0_z_11 = max(r0_z_10, 0.0001);
                float r0_z_12 = sqrt(r0_z_11);
                float4 r0_xyzw_8 = (r1_w_4.xxxx * float4(r0_y_7, r0_y_7, r0_z_12, r0_y_7));
                float r0_y_8 = r0_xyzw_8.y;
                float r0_z_13 = r0_xyzw_8.z;
                float4 r1_xyzw_6 = (r0_y_8.xxxx * r5_xyz_7.xyzx);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_2 = r1_xyzw_6.z;
                float4 r0_xyzw_9 = (r5_xyz_7.xxyz * r0_z_13.xxxx);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_w_7 = r0_xyzw_9.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_5 = (r0_x_5 * r0_x_5);
                float r1_w_6 = (r1_w_5 * r1_w_5);
                float r0_x_8 = (((mad((r0_x_5 * r1_w_6), 0.7790837, 0.2209163)).xxxx * float4(r0_y_9, r0_z_14, r0_w_7, r0_y_9))).x;
                float4 r0_xyzw_10 = ((mad((r0_x_5 * r1_w_6), 0.7790837, 0.2209163)).xxxx * float4(r0_y_9, r0_z_14, r0_w_7, r0_y_9));
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_15 = r0_xyzw_10.z;
                o.sv_Target0.xyz = (mad(((((r1_w_3.xxxx * r3_xyzw_1.xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_6, r1_y_4, r1_z_2, r1_x_6), float4(r0_x_8, r0_y_10, r0_z_15, r0_x_8))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Highatmospherecolor;
                float _BumpScale;
                float4 _Lowatmospherecolor;
                float _AlphaScale;
                float _DisplacementClouds;
                float4 _MainTex_ST;
                float _Outeratmopsheredensity;
                float _Inneratmopsheredensity;
                float _Innerouterlimit;
                float _Inneroutersmoothness;
                float _Outeratmospherelimit;
                float4 _Inneratmosphere;
                float _DisplacementAtmosphere;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float3 _WorldSpaceCameraPos;
                float4 unity_WorldTransformParams;
                float4 cb1_values[6];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[7];
            };
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_linear_clamp1 : register(s1);
            SamplerState sampler_linear_clamp2 : register(s2);
            SamplerState sampler_linear_clamp3 : register(s3);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture2D t2 : register(t2);
            Texture3D t3 : register(t3);
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
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float texcoord6 : TEXCOORD6;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
            };
            struct program46Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float texcoord6 : TEXCOORD6;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
            };
            struct program46Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program28Output vert(program28Input i)
            {
                program28Output o = (program28Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float3 r0_xyz_1 = (mad(i.normal0.xyzx, cb0_values[8].zzzz, i.position0.xyzx)).xyz;
                float4 r0_xyzw_2 = mad(unity_ObjectToWorld[2], r0_xyz_1.zzzz, mad(unity_ObjectToWorld[0], r0_xyz_1.xxxx, (r0_xyz_1.yyyy * unity_ObjectToWorld[1])));
                float4 r1_xyzw_3 = (r0_xyzw_2 + unity_ObjectToWorld[3]);
                float4 r1_xyzw_4 = mad(unity_MatrixVP[3], r1_xyzw_3.wwww, mad(unity_MatrixVP[2], r1_xyzw_3.zzzz, mad(unity_MatrixVP[0], r1_xyzw_3.xxxx, (r1_xyzw_3.yyyy * unity_MatrixVP[1]))));
                o.sv_Position0.xyzw = UnityObjectToClipPos(r1_xyzw_3);
                o.texcoord6.x = r1_xyzw_4.z;
                float4 worldPos_xyzw_5 = mad(unity_ObjectToWorld[3], i.position0.wwww, r0_xyzw_2);
                o.texcoord4.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, r0_xyzw_2.xyzx)).xyz;
                float2 clipPos_xy_3 = ((worldPos_xyzw_5.yyyy * _MainTex_ST.xyxx)).xy;
                float2 clipPos_xy_4 = (mad(_Lowatmospherecolor.xyxx, worldPos_xyzw_5.xxxx, clipPos_xy_3.xyxx)).xy;
                float2 clipPos_xy_5 = (mad(cb0_values[6].xyxx, worldPos_xyzw_5.zzzz, clipPos_xy_4.xyxx)).xy;
                o.texcoord5.xy = (mad(_Inneratmosphere.xxxy, worldPos_xyzw_5.wwww, clipPos_xy_5.xxxy)).zw;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_y_6 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_6 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_2 = dot(float4(worldNormal_x_6, worldNormal_y_6, worldNormal_z_3, worldNormal_x_6), float4(worldNormal_x_6, worldNormal_y_6, worldNormal_z_3, worldNormal_x_6));
                float r0_w_3 = rsqrt(r0_w_2);
                float4 unitWorldNormal_xyzw_7 = (r0_w_3.xxxx * float4(worldNormal_x_6, worldNormal_y_6, worldNormal_z_3, worldNormal_x_6));
                float unitWorldNormal_x_7 = unitWorldNormal_xyzw_7.x;
                float unitWorldNormal_y_7 = unitWorldNormal_xyzw_7.y;
                float unitWorldNormal_z_4 = unitWorldNormal_xyzw_7.z;
                float3 worldTangent_xyz_6 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_7 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_6.xyzx)).xyz;
                float3 worldTangent_xyz_8 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_7.xyzx)).xyz;
                float3 unitWorldTangent_xyz_9 = normalize(worldTangent_xyz_8);
                float r0_w_6 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r2_xyz_6 = ((r0_w_6.xxxx * (mad(float4(unitWorldNormal_z_4, unitWorldNormal_x_7, unitWorldNormal_y_7, unitWorldNormal_z_4), unitWorldTangent_xyz_9.yzxy, ((float4(unitWorldNormal_x_7, unitWorldNormal_y_7, unitWorldNormal_z_4, unitWorldNormal_x_7) * unitWorldTangent_xyz_9.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r2_xyz_6.x;
                o.texcoord1.x = unitWorldTangent_xyz_9.z;
                o.texcoord1.z = unitWorldNormal_y_7;
                o.texcoord2.x = unitWorldTangent_xyz_9.x;
                o.texcoord3.x = unitWorldTangent_xyz_9.y;
                o.texcoord2.z = unitWorldNormal_z_4;
                o.texcoord3.z = unitWorldNormal_x_7;
                o.texcoord2.y = r2_xyz_6.y;
                o.texcoord3.y = r2_xyz_6.z;
                return o;
            }
            #pragma fragment frag
            program46Output frag(program46Input i)
            {
                program46Output o = (program46Output)0;
                float3 r0_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r2_xyzw_1 = t0.Sample(sampler_linear_clamp2, (i.texcoord0.xyxx).xy);
                float4 r3_xyzw_1 = t1.Sample(sampler_linear_clamp3, (i.texcoord0.xyxx).xy);
                float r1_w_1 = (r2_xyzw_1.w * cb0_values[8].y);
                float r3_x_2 = (r3_xyzw_1.w * r3_xyzw_1.x);
                float4 r3_xyzw_3 = mad(float4(r3_x_2, r3_xyzw_1.y, r3_x_2, r3_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float4 r3_xyzw_4 = (float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3) * cb0_values[8].xxxx);
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r2_w_2 = dot(float4(r3_x_4, r3_y_3, r3_x_4, r3_x_4), float4(r3_x_4, r3_y_3, r3_x_4, r3_x_4));
                float r2_w_3 = min(r2_w_2, 1);
                float r2_w_4 = (-r2_w_3 + 1);
                float r3_z_2 = sqrt(r2_w_4);
                float r2_w_5 = dot(float4(r3_x_4, r3_y_3, r3_z_2, r3_x_4), float4(r3_x_4, r3_y_3, r3_z_2, r3_x_4));
                float r2_w_6 = rsqrt(r2_w_5);
                float4 r3_xyzw_5 = (r2_w_6.xxxx * float4(r3_x_4, r3_y_3, r3_z_2, r3_x_4));
                float r3_x_5 = r3_xyzw_5.x;
                float r3_y_4 = r3_xyzw_5.y;
                float r3_z_3 = r3_xyzw_5.z;
                float r2_w_7 = (cb4_values[0].x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r2_w_7)
                {
                    float r2_w_8 = (cb4_values[0].y == 1);
                    float3 r5_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord4.zzzz, (mad(cb4_values[1].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r5_xyzw_8 = (((((r2_w_8.xxxx ? r5_xyz_5.xyzx : i.texcoord4.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r2_w_9 = mad(r5_y_8, 0.25, 0.75);
                    float r3_w_2 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r5_x_8 = max(r2_w_9, r3_w_2);
                    float4 r5_xyzw_9 = t3.Sample(sampler_linear_clamp, (float4(r5_x_8, r5_z_8, r5_w_2, r5_x_8)).xyz);
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
                float r2_w_11 = dot(float4(r5_x_10, r5_y_10, r5_z_10, r5_w_4), unity_OcclusionMaskSelector);
                float4 r4_xyzw_5 = t2.Sample(sampler_linear_clamp1, ((((mad(cb0_values[6].xyxx, i.texcoord4.zzzz, (mad(cb0_values[4].xyxx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx).xy);
                float r2_w_12 = (r2_w_11 * r4_xyzw_5.w);
                float r4_x_6 = dot(i.texcoord1.xyzx, float4(r3_x_5, r3_y_4, r3_z_3, r3_x_5));
                float r4_y_6 = dot(i.texcoord2.xyzx, float4(r3_x_5, r3_y_4, r3_z_3, r3_x_5));
                float r4_z_2 = dot(i.texcoord3.xyzx, float4(r3_x_5, r3_y_4, r3_z_3, r3_x_5));
                float4 r3_xyzw_8 = ((rsqrt(dot(float4(r4_x_6, r4_y_6, r4_z_2, r4_x_6), float4(r4_x_6, r4_y_6, r4_z_2, r4_x_6)))).xxxx * float4(r4_x_6, r4_y_6, r4_z_2, r4_x_6));
                float r3_x_8 = r3_xyzw_8.x;
                float r3_y_5 = r3_xyzw_8.y;
                float r3_z_4 = r3_xyzw_8.z;
                float4 r4_xyzw_7 = (r2_w_12.xxxx * _LightColor0.xyzx);
                float r4_x_7 = r4_xyzw_7.x;
                float r4_y_7 = r4_xyzw_7.y;
                float r4_z_3 = r4_xyzw_7.z;
                o.sv_Target0.w = mad(r1_w_1, 0.7790837, 0.22091627);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float r0_w_6 = dot(float4(r3_x_8, r3_y_5, r3_z_4, r3_x_8), ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx);
                float r1_x_2 = dot(float4(r3_x_8, r3_y_5, r3_z_4, r3_x_8), _WorldSpaceLightPos0.xyzx);
                float r0_x_4 = dot(_WorldSpaceLightPos0.xyzx, ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyzx);
                float r0_y_4 = dot(r0_x_4.xxxx, r0_x_4.xxxx);
                float r0_y_5 = (r0_y_4 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_y_2 = (r0_z_4 * r0_z_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_z_5 = (r0_z_4 * r1_y_3);
                float r0_z_6 = mad(r0_y_5, r0_z_5, 1);
                float r1_y_4 = (-abs(r0_w_6) + 1);
                float r1_z_2 = (r1_y_4 * r1_y_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r1_y_5 = (r1_y_4 * r1_z_3);
                float r0_y_6 = mad(r0_y_5, r1_y_5, 1);
                float r0_y_7 = (r0_y_6 * r0_z_6);
                float r0_z_7 = (abs(r0_w_6) + r1_x_2);
                float r0_z_8 = (r0_z_7 + 1E-05);
                float r0_z_9 = (0.5 / r0_z_8);
                float r0_z_10 = (r0_z_9 * 0.9999999);
                float r0_z_11 = max(r0_z_10, 0.0001);
                float r0_z_12 = sqrt(r0_z_11);
                float4 r0_xyzw_8 = (r1_x_2.xxxx * float4(r0_y_7, r0_y_7, r0_z_12, r0_y_7));
                float r0_y_8 = r0_xyzw_8.y;
                float r0_z_13 = r0_xyzw_8.z;
                float4 r1_xyzw_3 = (r0_y_8.xxxx * float4(r4_x_7, r4_y_7, r4_z_3, r4_x_7));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_6 = r1_xyzw_3.y;
                float r1_z_4 = r1_xyzw_3.z;
                float4 r0_xyzw_9 = (float4(r4_x_7, r4_x_7, r4_y_7, r4_z_3) * r0_z_13.xxxx);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_w_7 = r0_xyzw_9.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_2 = (r0_x_5 * r0_x_5);
                float r1_w_3 = (r1_w_2 * r1_w_2);
                float r0_x_8 = (((mad((r0_x_5 * r1_w_3), 0.7790837, 0.2209163)).xxxx * float4(r0_y_9, r0_z_14, r0_w_7, r0_y_9))).x;
                float4 r0_xyzw_10 = ((mad((r0_x_5 * r1_w_3), 0.7790837, 0.2209163)).xxxx * float4(r0_y_9, r0_z_14, r0_w_7, r0_y_9));
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_15 = r0_xyzw_10.z;
                float r0_x_9 = (mad(((((r1_w_1.xxxx * r2_xyzw_1.xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_3, r1_y_6, r1_z_4, r1_x_3), float4(r0_x_8, r0_y_10, r0_z_15, r0_x_8))).x;
                float4 r0_xyzw_11 = mad(((((r1_w_1.xxxx * r2_xyzw_1.xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_3, r1_y_6, r1_z_4, r1_x_3), float4(r0_x_8, r0_y_10, r0_z_15, r0_x_8));
                float r0_y_11 = r0_xyzw_11.y;
                float r0_z_16 = r0_xyzw_11.z;
                float r0_w_8 = (i.texcoord6.x / cb1_values[5].y);
                float r0_w_9 = (-r0_w_8 + 1);
                float r0_w_10 = (r0_w_9 * cb1_values[5].z);
                float r0_w_11 = max(r0_w_10, 0);
                float r0_w_12 = mad(r0_w_11, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w);
                o.sv_Target0.xyz = ((float4(r0_x_9, r0_y_11, r0_z_16, r0_x_9) * r0_w_12.xxxx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Highatmospherecolor;
                float _BumpScale;
                float4 _Lowatmospherecolor;
                float _AlphaScale;
                float _DisplacementClouds;
                float4 _MainTex_ST;
                float _Outeratmopsheredensity;
                float _Inneratmopsheredensity;
                float _Innerouterlimit;
                float _Inneroutersmoothness;
                float _Outeratmospherelimit;
                float4 _Inneratmosphere;
                float _DisplacementAtmosphere;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float3 _WorldSpaceCameraPos;
                float4 unity_WorldTransformParams;
                float4 cb1_values[6];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[7];
            };
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_linear_clamp1 : register(s1);
            SamplerState sampler_linear_clamp2 : register(s2);
            SamplerState sampler_linear_clamp3 : register(s3);
            SamplerState sampler_linear_clamp4 : register(s4);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture2D t2 : register(t2);
            TextureCube t3 : register(t3);
            Texture3D t4 : register(t4);
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
                float texcoord6 : TEXCOORD6;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
            };
            struct program45Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord6 : TEXCOORD6;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
            };
            struct program45Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program27Output vert(program27Input i)
            {
                program27Output o = (program27Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float3 r0_xyz_1 = (mad(i.normal0.xyzx, cb0_values[8].zzzz, i.position0.xyzx)).xyz;
                float4 r0_xyzw_2 = mad(unity_ObjectToWorld[2], r0_xyz_1.zzzz, mad(unity_ObjectToWorld[0], r0_xyz_1.xxxx, (r0_xyz_1.yyyy * unity_ObjectToWorld[1])));
                float4 r1_xyzw_3 = (r0_xyzw_2 + unity_ObjectToWorld[3]);
                float4 r1_xyzw_4 = mad(unity_MatrixVP[3], r1_xyzw_3.wwww, mad(unity_MatrixVP[2], r1_xyzw_3.zzzz, mad(unity_MatrixVP[0], r1_xyzw_3.xxxx, (r1_xyzw_3.yyyy * unity_MatrixVP[1]))));
                o.sv_Position0.xyzw = UnityObjectToClipPos(r1_xyzw_3);
                o.texcoord6.x = r1_xyzw_4.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_y_5 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_5 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_5 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_5 = dot(float4(worldNormal_x_5, worldNormal_y_5, worldNormal_z_5, worldNormal_x_5), float4(worldNormal_x_5, worldNormal_y_5, worldNormal_z_5, worldNormal_x_5));
                float r1_w_6 = rsqrt(r1_w_5);
                float3 unitWorldNormal_xyz_6 = ((r1_w_6.xxxx * float4(worldNormal_x_5, worldNormal_y_5, worldNormal_z_5, worldNormal_x_5))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_9 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_9.xxxx * (mad(unitWorldNormal_xyz_6.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_6.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_6.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_6.z;
                o.texcoord3.z = unitWorldNormal_xyz_6.x;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord4.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, r0_xyzw_2.xyzx)).xyz;
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[3], i.position0.wwww, r0_xyzw_2);
                float3 clipPos_xyz_7 = ((worldPos_xyzw_3.yyyy * _MainTex_ST.xyzx)).xyz;
                float3 clipPos_xyz_8 = (mad(_Lowatmospherecolor.xyzx, worldPos_xyzw_3.xxxx, clipPos_xyz_7.xyzx)).xyz;
                float3 clipPos_xyz_4 = (mad(cb0_values[6].xyzx, worldPos_xyzw_3.zzzz, clipPos_xyz_8.xyzx)).xyz;
                o.texcoord5.xyz = (mad(_Inneratmosphere.xyzx, worldPos_xyzw_3.wwww, clipPos_xyz_4.xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program45Output frag(program45Input i)
            {
                program45Output o = (program45Output)0;
                float3 r0_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 r2_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float3 r2_xyz_2 = normalize(r2_xyz_1);
                float4 r3_xyzw_1 = t0.Sample(sampler_linear_clamp3, (i.texcoord0.xyxx).xy);
                float4 r4_xyzw_1 = t1.Sample(sampler_linear_clamp4, (i.texcoord0.xyxx).xy);
                float r1_w_3 = (r3_xyzw_1.w * cb0_values[8].y);
                float r4_x_2 = (r4_xyzw_1.w * r4_xyzw_1.x);
                float4 r4_xyzw_3 = mad(float4(r4_x_2, r4_xyzw_1.y, r4_x_2, r4_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r4_x_3 = r4_xyzw_3.x;
                float r4_y_2 = r4_xyzw_3.y;
                float4 r4_xyzw_4 = (float4(r4_x_3, r4_y_2, r4_x_3, r4_x_3) * cb0_values[8].xxxx);
                float r4_x_4 = r4_xyzw_4.x;
                float r4_y_3 = r4_xyzw_4.y;
                float r2_w_1 = dot(float4(r4_x_4, r4_y_3, r4_x_4, r4_x_4), float4(r4_x_4, r4_y_3, r4_x_4, r4_x_4));
                float r2_w_2 = min(r2_w_1, 1);
                float r2_w_3 = (-r2_w_2 + 1);
                float r4_z_2 = sqrt(r2_w_3);
                float r2_w_4 = dot(float4(r4_x_4, r4_y_3, r4_z_2, r4_x_4), float4(r4_x_4, r4_y_3, r4_z_2, r4_x_4));
                float r2_w_5 = rsqrt(r2_w_4);
                float4 r4_xyzw_5 = (r2_w_5.xxxx * float4(r4_x_4, r4_y_3, r4_z_2, r4_x_4));
                float r4_x_5 = r4_xyzw_5.x;
                float r4_y_4 = r4_xyzw_5.y;
                float r4_z_3 = r4_xyzw_5.z;
                float3 r5_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord4.zzzz, (mad(cb0_values[4].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r2_w_6 = (cb4_values[0].x == 1);
                float r6_x_10;
                float r6_y_10;
                float r6_z_10;
                float r6_w_4;
                if (r2_w_6)
                {
                    float r2_w_7 = (cb4_values[0].y == 1);
                    float3 r6_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord4.zzzz, (mad(cb4_values[1].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r6_xyzw_8 = (((((r2_w_7.xxxx ? r6_xyz_5.xyzx : i.texcoord4.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r6_y_8 = r6_xyzw_8.y;
                    float r6_z_8 = r6_xyzw_8.z;
                    float r6_w_2 = r6_xyzw_8.w;
                    float r2_w_8 = mad(r6_y_8, 0.25, 0.75);
                    float r3_w_2 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r6_x_8 = max(r2_w_8, r3_w_2);
                    float4 r6_xyzw_9 = t4.Sample(sampler_linear_clamp, (float4(r6_x_8, r6_z_8, r6_w_2, r6_x_8)).xyz);
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
                float r2_w_10 = dot(float4(r6_x_10, r6_y_10, r6_z_10, r6_w_4), unity_OcclusionMaskSelector);
                float r3_w_4 = dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx);
                float4 r6_xyzw_11 = t2.Sample(sampler_linear_clamp2, (r3_w_4.xxxx).xy);
                float4 r5_xyzw_5 = t3.Sample(sampler_linear_clamp1, r5_xyz_4.xyz);
                float r3_w_5 = (r5_xyzw_5.w * r6_xyzw_11.x);
                float r2_w_11 = (r2_w_10 * r3_w_5);
                float r5_x_6 = dot(i.texcoord1.xyzx, float4(r4_x_5, r4_y_4, r4_z_3, r4_x_5));
                float r5_y_6 = dot(i.texcoord2.xyzx, float4(r4_x_5, r4_y_4, r4_z_3, r4_x_5));
                float r5_z_6 = dot(i.texcoord3.xyzx, float4(r4_x_5, r4_y_4, r4_z_3, r4_x_5));
                float r3_w_6 = dot(float4(r5_x_6, r5_y_6, r5_z_6, r5_x_6), float4(r5_x_6, r5_y_6, r5_z_6, r5_x_6));
                float r3_w_7 = rsqrt(r3_w_6);
                float4 r4_xyzw_6 = (r3_w_7.xxxx * float4(r5_x_6, r5_y_6, r5_z_6, r5_x_6));
                float r4_x_6 = r4_xyzw_6.x;
                float r4_y_5 = r4_xyzw_6.y;
                float r4_z_4 = r4_xyzw_6.z;
                float3 r5_xyz_7 = ((r2_w_11.xxxx * _LightColor0.xyzx)).xyz;
                o.sv_Target0.w = mad(r1_w_3, 0.7790837, 0.22091627);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, r2_xyz_2.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float r0_w_6 = dot(float4(r4_x_6, r4_y_5, r4_z_4, r4_x_6), r2_xyz_2.xyzx);
                float r1_w_4 = dot(float4(r4_x_6, r4_y_5, r4_z_4, r4_x_6), r1_xyz_1.xyzx);
                float r0_x_4 = dot(r1_xyz_1.xyzx, ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyzx);
                float r0_y_4 = dot(r0_x_4.xxxx, r0_x_4.xxxx);
                float r0_y_5 = (r0_y_4 + -0.5);
                float r0_z_4 = (-r1_w_4 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_5, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_6 = mad(r0_y_5, (r1_x_4 * r1_y_3), 1);
                float r0_y_7 = (r0_y_6 * r0_z_6);
                float r0_z_7 = (abs(r0_w_6) + r1_w_4);
                float r0_z_8 = (r0_z_7 + 1E-05);
                float r0_z_9 = (0.5 / r0_z_8);
                float r0_z_10 = (r0_z_9 * 0.9999999);
                float r0_z_11 = max(r0_z_10, 0.0001);
                float r0_z_12 = sqrt(r0_z_11);
                float4 r0_xyzw_8 = (r1_w_4.xxxx * float4(r0_y_7, r0_y_7, r0_z_12, r0_y_7));
                float r0_y_8 = r0_xyzw_8.y;
                float r0_z_13 = r0_xyzw_8.z;
                float4 r1_xyzw_6 = (r0_y_8.xxxx * r5_xyz_7.xyzx);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_2 = r1_xyzw_6.z;
                float4 r0_xyzw_9 = (r5_xyz_7.xxyz * r0_z_13.xxxx);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_w_7 = r0_xyzw_9.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_5 = (r0_x_5 * r0_x_5);
                float r1_w_6 = (r1_w_5 * r1_w_5);
                float r0_x_8 = (((mad((r0_x_5 * r1_w_6), 0.7790837, 0.2209163)).xxxx * float4(r0_y_9, r0_z_14, r0_w_7, r0_y_9))).x;
                float4 r0_xyzw_10 = ((mad((r0_x_5 * r1_w_6), 0.7790837, 0.2209163)).xxxx * float4(r0_y_9, r0_z_14, r0_w_7, r0_y_9));
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_15 = r0_xyzw_10.z;
                float r0_x_9 = (mad(((((r1_w_3.xxxx * r3_xyzw_1.xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_6, r1_y_4, r1_z_2, r1_x_6), float4(r0_x_8, r0_y_10, r0_z_15, r0_x_8))).x;
                float4 r0_xyzw_11 = mad(((((r1_w_3.xxxx * r3_xyzw_1.xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_6, r1_y_4, r1_z_2, r1_x_6), float4(r0_x_8, r0_y_10, r0_z_15, r0_x_8));
                float r0_y_11 = r0_xyzw_11.y;
                float r0_z_16 = r0_xyzw_11.z;
                float r0_w_8 = (i.texcoord6.x / cb1_values[5].y);
                float r0_w_9 = (-r0_w_8 + 1);
                float r0_w_10 = (r0_w_9 * cb1_values[5].z);
                float r0_w_11 = max(r0_w_10, 0);
                float r0_w_12 = mad(r0_w_11, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w);
                o.sv_Target0.xyz = ((float4(r0_x_9, r0_y_11, r0_z_16, r0_x_9) * r0_w_12.xxxx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Highatmospherecolor;
                float _BumpScale;
                float4 _Lowatmospherecolor;
                float _AlphaScale;
                float _DisplacementClouds;
                float4 _MainTex_ST;
                float _Outeratmopsheredensity;
                float _Inneratmopsheredensity;
                float _Innerouterlimit;
                float _Inneroutersmoothness;
                float _Outeratmospherelimit;
                float4 _Inneratmosphere;
                float _DisplacementAtmosphere;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float3 _WorldSpaceCameraPos;
                float4 unity_WorldTransformParams;
                float4 cb1_values[6];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[7];
            };
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_linear_clamp1 : register(s1);
            SamplerState sampler_linear_clamp2 : register(s2);
            SamplerState sampler_linear_clamp3 : register(s3);
            SamplerState sampler_linear_clamp4 : register(s4);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture2D t2 : register(t2);
            Texture2D t3 : register(t3);
            Texture3D t4 : register(t4);
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
                float texcoord6 : TEXCOORD6;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program44Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord6 : TEXCOORD6;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program44Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program26Output vert(program26Input i)
            {
                program26Output o = (program26Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float3 r0_xyz_1 = (mad(i.normal0.xyzx, cb0_values[8].zzzz, i.position0.xyzx)).xyz;
                float4 r0_xyzw_2 = mad(unity_ObjectToWorld[2], r0_xyz_1.zzzz, mad(unity_ObjectToWorld[0], r0_xyz_1.xxxx, (r0_xyz_1.yyyy * unity_ObjectToWorld[1])));
                float4 r1_xyzw_3 = (r0_xyzw_2 + unity_ObjectToWorld[3]);
                float4 r1_xyzw_4 = mad(unity_MatrixVP[3], r1_xyzw_3.wwww, mad(unity_MatrixVP[2], r1_xyzw_3.zzzz, mad(unity_MatrixVP[0], r1_xyzw_3.xxxx, (r1_xyzw_3.yyyy * unity_MatrixVP[1]))));
                o.sv_Position0.xyzw = UnityObjectToClipPos(r1_xyzw_3);
                o.texcoord6.x = r1_xyzw_4.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_y_5 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_5 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_5 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_5 = dot(float4(worldNormal_x_5, worldNormal_y_5, worldNormal_z_5, worldNormal_x_5), float4(worldNormal_x_5, worldNormal_y_5, worldNormal_z_5, worldNormal_x_5));
                float r1_w_6 = rsqrt(r1_w_5);
                float3 unitWorldNormal_xyz_6 = ((r1_w_6.xxxx * float4(worldNormal_x_5, worldNormal_y_5, worldNormal_z_5, worldNormal_x_5))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_9 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_9.xxxx * (mad(unitWorldNormal_xyz_6.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_6.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_6.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_6.z;
                o.texcoord3.z = unitWorldNormal_xyz_6.x;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord4.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, r0_xyzw_2.xyzx)).xyz;
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[3], i.position0.wwww, r0_xyzw_2);
                float4 clipPos_xyzw_7 = (worldPos_xyzw_3.yyyy * _MainTex_ST);
                float4 clipPos_xyzw_8 = mad(_Lowatmospherecolor, worldPos_xyzw_3.xxxx, clipPos_xyzw_7);
                float4 clipPos_xyzw_9 = mad(cb0_values[6].xyzw, worldPos_xyzw_3.zzzz, clipPos_xyzw_8);
                o.texcoord5.xyzw = mad(_Inneratmosphere, worldPos_xyzw_3.wwww, clipPos_xyzw_9);
                return o;
            }
            #pragma fragment frag
            program44Output frag(program44Input i)
            {
                program44Output o = (program44Output)0;
                float3 r0_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 r2_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float3 r2_xyz_2 = normalize(r2_xyz_1);
                float4 r3_xyzw_1 = t0.Sample(sampler_linear_clamp3, (i.texcoord0.xyxx).xy);
                float4 r4_xyzw_1 = t1.Sample(sampler_linear_clamp4, (i.texcoord0.xyxx).xy);
                float r1_w_3 = (r3_xyzw_1.w * cb0_values[8].y);
                float r4_x_2 = (r4_xyzw_1.w * r4_xyzw_1.x);
                float4 r4_xyzw_3 = mad(float4(r4_x_2, r4_xyzw_1.y, r4_x_2, r4_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r4_x_3 = r4_xyzw_3.x;
                float r4_y_2 = r4_xyzw_3.y;
                float4 r4_xyzw_4 = (float4(r4_x_3, r4_y_2, r4_x_3, r4_x_3) * cb0_values[8].xxxx);
                float r4_x_4 = r4_xyzw_4.x;
                float r4_y_3 = r4_xyzw_4.y;
                float r2_w_1 = dot(float4(r4_x_4, r4_y_3, r4_x_4, r4_x_4), float4(r4_x_4, r4_y_3, r4_x_4, r4_x_4));
                float r2_w_2 = min(r2_w_1, 1);
                float r2_w_3 = (-r2_w_2 + 1);
                float r4_z_2 = sqrt(r2_w_3);
                float r2_w_4 = dot(float4(r4_x_4, r4_y_3, r4_z_2, r4_x_4), float4(r4_x_4, r4_y_3, r4_z_2, r4_x_4));
                float r2_w_5 = rsqrt(r2_w_4);
                float4 r4_xyzw_5 = (r2_w_5.xxxx * float4(r4_x_4, r4_y_3, r4_z_2, r4_x_4));
                float r4_x_5 = r4_xyzw_5.x;
                float r4_y_4 = r4_xyzw_5.y;
                float r4_z_3 = r4_xyzw_5.z;
                float4 r5_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord4.zzzz, mad(cb0_values[4].xyzw, i.texcoord4.xxxx, (i.texcoord4.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r2_w_6 = (cb4_values[0].x == 1);
                float r6_x_10;
                float r6_y_10;
                float r6_z_10;
                float r6_w_4;
                if (r2_w_6)
                {
                    float r2_w_7 = (cb4_values[0].y == 1);
                    float3 r6_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord4.zzzz, (mad(cb4_values[1].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r6_xyzw_8 = (((((r2_w_7.xxxx ? r6_xyz_5.xyzx : i.texcoord4.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r6_y_8 = r6_xyzw_8.y;
                    float r6_z_8 = r6_xyzw_8.z;
                    float r6_w_2 = r6_xyzw_8.w;
                    float r2_w_8 = mad(r6_y_8, 0.25, 0.75);
                    float r3_w_2 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r6_x_8 = max(r2_w_8, r3_w_2);
                    float4 r6_xyzw_9 = t4.Sample(sampler_linear_clamp, (float4(r6_x_8, r6_z_8, r6_w_2, r6_x_8)).xyz);
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
                float r2_w_10 = dot(float4(r6_x_10, r6_y_10, r6_z_10, r6_w_4), unity_OcclusionMaskSelector);
                float r3_w_4 = (0 < r5_xyzw_4.z);
                float r3_w_5 = asfloat(asint(r3_w_4) & asint(1065353216));
                float4 r6_xyzw_13 = t2.Sample(sampler_linear_clamp1, (((((r5_xyzw_4.xyxx / r5_xyzw_4.wwww)).xyxx + float4(0.5, 0.5, 0, 0))).xyxx).xy);
                float r3_w_6 = (r3_w_5 * r6_xyzw_13.w);
                float r4_w_2 = dot(r5_xyzw_4.xyzx, r5_xyzw_4.xyzx);
                float4 r5_xyzw_5 = t3.Sample(sampler_linear_clamp2, (r4_w_2.xxxx).xy);
                float r3_w_7 = (r3_w_6 * r5_xyzw_5.x);
                float r2_w_11 = (r2_w_10 * r3_w_7);
                float r5_x_6 = dot(i.texcoord1.xyzx, float4(r4_x_5, r4_y_4, r4_z_3, r4_x_5));
                float r5_y_6 = dot(i.texcoord2.xyzx, float4(r4_x_5, r4_y_4, r4_z_3, r4_x_5));
                float r5_z_6 = dot(i.texcoord3.xyzx, float4(r4_x_5, r4_y_4, r4_z_3, r4_x_5));
                float r3_w_8 = dot(float4(r5_x_6, r5_y_6, r5_z_6, r5_x_6), float4(r5_x_6, r5_y_6, r5_z_6, r5_x_6));
                float r3_w_9 = rsqrt(r3_w_8);
                float4 r4_xyzw_6 = (r3_w_9.xxxx * float4(r5_x_6, r5_y_6, r5_z_6, r5_x_6));
                float r4_x_6 = r4_xyzw_6.x;
                float r4_y_5 = r4_xyzw_6.y;
                float r4_z_4 = r4_xyzw_6.z;
                float3 r5_xyz_7 = ((r2_w_11.xxxx * _LightColor0.xyzx)).xyz;
                o.sv_Target0.w = mad(r1_w_3, 0.7790837, 0.22091627);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, r2_xyz_2.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float r0_w_6 = dot(float4(r4_x_6, r4_y_5, r4_z_4, r4_x_6), r2_xyz_2.xyzx);
                float r1_w_4 = dot(float4(r4_x_6, r4_y_5, r4_z_4, r4_x_6), r1_xyz_1.xyzx);
                float r0_x_4 = dot(r1_xyz_1.xyzx, ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyzx);
                float r0_y_4 = dot(r0_x_4.xxxx, r0_x_4.xxxx);
                float r0_y_5 = (r0_y_4 + -0.5);
                float r0_z_4 = (-r1_w_4 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_5, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_6 = mad(r0_y_5, (r1_x_4 * r1_y_3), 1);
                float r0_y_7 = (r0_y_6 * r0_z_6);
                float r0_z_7 = (abs(r0_w_6) + r1_w_4);
                float r0_z_8 = (r0_z_7 + 1E-05);
                float r0_z_9 = (0.5 / r0_z_8);
                float r0_z_10 = (r0_z_9 * 0.9999999);
                float r0_z_11 = max(r0_z_10, 0.0001);
                float r0_z_12 = sqrt(r0_z_11);
                float4 r0_xyzw_8 = (r1_w_4.xxxx * float4(r0_y_7, r0_y_7, r0_z_12, r0_y_7));
                float r0_y_8 = r0_xyzw_8.y;
                float r0_z_13 = r0_xyzw_8.z;
                float4 r1_xyzw_6 = (r0_y_8.xxxx * r5_xyz_7.xyzx);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_2 = r1_xyzw_6.z;
                float4 r0_xyzw_9 = (r5_xyz_7.xxyz * r0_z_13.xxxx);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_w_7 = r0_xyzw_9.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_5 = (r0_x_5 * r0_x_5);
                float r1_w_6 = (r1_w_5 * r1_w_5);
                float r0_x_8 = (((mad((r0_x_5 * r1_w_6), 0.7790837, 0.2209163)).xxxx * float4(r0_y_9, r0_z_14, r0_w_7, r0_y_9))).x;
                float4 r0_xyzw_10 = ((mad((r0_x_5 * r1_w_6), 0.7790837, 0.2209163)).xxxx * float4(r0_y_9, r0_z_14, r0_w_7, r0_y_9));
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_15 = r0_xyzw_10.z;
                float r0_x_9 = (mad(((((r1_w_3.xxxx * r3_xyzw_1.xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_6, r1_y_4, r1_z_2, r1_x_6), float4(r0_x_8, r0_y_10, r0_z_15, r0_x_8))).x;
                float4 r0_xyzw_11 = mad(((((r1_w_3.xxxx * r3_xyzw_1.xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_6, r1_y_4, r1_z_2, r1_x_6), float4(r0_x_8, r0_y_10, r0_z_15, r0_x_8));
                float r0_y_11 = r0_xyzw_11.y;
                float r0_z_16 = r0_xyzw_11.z;
                float r0_w_8 = (i.texcoord6.x / cb1_values[5].y);
                float r0_w_9 = (-r0_w_8 + 1);
                float r0_w_10 = (r0_w_9 * cb1_values[5].z);
                float r0_w_11 = max(r0_w_10, 0);
                float r0_w_12 = mad(r0_w_11, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w);
                o.sv_Target0.xyz = ((float4(r0_x_9, r0_y_11, r0_z_16, r0_x_9) * r0_w_12.xxxx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Highatmospherecolor;
                float _BumpScale;
                float4 _Lowatmospherecolor;
                float _AlphaScale;
                float _DisplacementClouds;
                float4 _MainTex_ST;
                float _Outeratmopsheredensity;
                float _Inneratmopsheredensity;
                float _Innerouterlimit;
                float _Inneroutersmoothness;
                float _Outeratmospherelimit;
                float4 _Inneratmosphere;
                float _DisplacementAtmosphere;
                float4 cb0_values[5];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float3 _WorldSpaceCameraPos;
                float4 unity_WorldTransformParams;
                float4 cb1_values[6];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[7];
            };
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_linear_clamp1 : register(s1);
            SamplerState sampler_linear_clamp2 : register(s2);
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
                float texcoord6 : TEXCOORD6;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
            };
            struct program43Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord6 : TEXCOORD6;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
            };
            struct program43Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program25Output vert(program25Input i)
            {
                program25Output o = (program25Output)0;
                float3 r0_xyz_1 = (mad(i.normal0.xyzx, _DisplacementClouds.xxxx, i.position0.xyzx)).xyz;
                float4 r0_xyzw_2 = mad(unity_ObjectToWorld[2], r0_xyz_1.zzzz, mad(unity_ObjectToWorld[0], r0_xyz_1.xxxx, (r0_xyz_1.yyyy * unity_ObjectToWorld[1])));
                float4 r1_xyzw_3 = (r0_xyzw_2 + unity_ObjectToWorld[3]);
                o.texcoord4.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, r0_xyzw_2.xyzx)).xyz;
                float4 r0_xyzw_3 = (r1_xyzw_3.yyyy * unity_MatrixVP[1]);
                float4 r0_xyzw_4 = mad(unity_MatrixVP[0], r1_xyzw_3.xxxx, r0_xyzw_3);
                float4 r0_xyzw_5 = mad(unity_MatrixVP[2], r1_xyzw_3.zzzz, r0_xyzw_4);
                float4 r0_xyzw_6 = mad(unity_MatrixVP[3], r1_xyzw_3.wwww, r0_xyzw_5);
                o.sv_Position0.xyzw = r0_xyzw_6;
                o.texcoord6.x = r0_xyzw_6.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_6 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_7 = rsqrt(r0_w_6);
                float3 unitWorldNormal_xyz_8 = ((r0_w_7.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r0_w_10 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r2_xyz_3 = ((r0_w_10.xxxx * (mad(unitWorldNormal_xyz_8.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_8.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r2_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_8.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_8.z;
                o.texcoord3.z = unitWorldNormal_xyz_8.x;
                o.texcoord2.y = r2_xyz_3.y;
                o.texcoord3.y = r2_xyz_3.z;
                return o;
            }
            #pragma fragment frag
            program43Output frag(program43Input i)
            {
                program43Output o = (program43Output)0;
                float3 r0_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r2_xyzw_1 = t0.Sample(sampler_linear_clamp1, (i.texcoord0.xyxx).xy);
                float4 r3_xyzw_1 = t1.Sample(sampler_linear_clamp2, (i.texcoord0.xyxx).xy);
                float r1_w_1 = (r2_xyzw_1.w * cb0_values[4].y);
                float r3_x_2 = (r3_xyzw_1.w * r3_xyzw_1.x);
                float4 r3_xyzw_3 = mad(float4(r3_x_2, r3_xyzw_1.y, r3_x_2, r3_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float4 r3_xyzw_4 = (float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3) * cb0_values[4].xxxx);
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r2_w_2 = dot(float4(r3_x_4, r3_y_3, r3_x_4, r3_x_4), float4(r3_x_4, r3_y_3, r3_x_4, r3_x_4));
                float r2_w_3 = min(r2_w_2, 1);
                float r2_w_4 = (-r2_w_3 + 1);
                float r3_z_2 = sqrt(r2_w_4);
                float r2_w_5 = dot(float4(r3_x_4, r3_y_3, r3_z_2, r3_x_4), float4(r3_x_4, r3_y_3, r3_z_2, r3_x_4));
                float r2_w_6 = rsqrt(r2_w_5);
                float4 r3_xyzw_5 = (r2_w_6.xxxx * float4(r3_x_4, r3_y_3, r3_z_2, r3_x_4));
                float r3_x_5 = r3_xyzw_5.x;
                float r3_y_4 = r3_xyzw_5.y;
                float r3_z_3 = r3_xyzw_5.z;
                float r2_w_7 = (cb4_values[0].x == 1);
                float r4_x_10;
                float r4_y_10;
                float r4_z_10;
                float r4_w_4;
                if (r2_w_7)
                {
                    float r2_w_8 = (cb4_values[0].y == 1);
                    float3 r4_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord4.zzzz, (mad(cb4_values[1].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r4_xyzw_8 = (((((r2_w_8.xxxx ? r4_xyz_5.xyzx : i.texcoord4.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r4_y_8 = r4_xyzw_8.y;
                    float r4_z_8 = r4_xyzw_8.z;
                    float r4_w_2 = r4_xyzw_8.w;
                    float r2_w_9 = mad(r4_y_8, 0.25, 0.75);
                    float r3_w_2 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r4_x_8 = max(r2_w_9, r3_w_2);
                    float4 r4_xyzw_9 = t2.Sample(sampler_linear_clamp, (float4(r4_x_8, r4_z_8, r4_w_2, r4_x_8)).xyz);
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
                float r2_w_11 = dot(float4(r4_x_10, r4_y_10, r4_z_10, r4_w_4), unity_OcclusionMaskSelector);
                float r4_x_11 = dot(i.texcoord1.xyzx, float4(r3_x_5, r3_y_4, r3_z_3, r3_x_5));
                float r4_y_11 = dot(i.texcoord2.xyzx, float4(r3_x_5, r3_y_4, r3_z_3, r3_x_5));
                float r4_z_11 = dot(i.texcoord3.xyzx, float4(r3_x_5, r3_y_4, r3_z_3, r3_x_5));
                float4 r3_xyzw_8 = ((rsqrt(dot(float4(r4_x_11, r4_y_11, r4_z_11, r4_x_11), float4(r4_x_11, r4_y_11, r4_z_11, r4_x_11)))).xxxx * float4(r4_x_11, r4_y_11, r4_z_11, r4_x_11));
                float r3_x_8 = r3_xyzw_8.x;
                float r3_y_5 = r3_xyzw_8.y;
                float r3_z_4 = r3_xyzw_8.z;
                float3 r4_xyz_12 = ((r2_w_11.xxxx * _LightColor0.xyzx)).xyz;
                o.sv_Target0.w = mad(r1_w_1, 0.7790837, 0.22091627);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float r0_w_6 = dot(float4(r3_x_8, r3_y_5, r3_z_4, r3_x_8), ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx);
                float r1_x_2 = dot(float4(r3_x_8, r3_y_5, r3_z_4, r3_x_8), _WorldSpaceLightPos0.xyzx);
                float r0_x_4 = dot(_WorldSpaceLightPos0.xyzx, ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyzx);
                float r0_y_4 = dot(r0_x_4.xxxx, r0_x_4.xxxx);
                float r0_y_5 = (r0_y_4 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_y_2 = (r0_z_4 * r0_z_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_z_5 = (r0_z_4 * r1_y_3);
                float r0_z_6 = mad(r0_y_5, r0_z_5, 1);
                float r1_y_4 = (-abs(r0_w_6) + 1);
                float r1_z_2 = (r1_y_4 * r1_y_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r1_y_5 = (r1_y_4 * r1_z_3);
                float r0_y_6 = mad(r0_y_5, r1_y_5, 1);
                float r0_y_7 = (r0_y_6 * r0_z_6);
                float r0_z_7 = (abs(r0_w_6) + r1_x_2);
                float r0_z_8 = (r0_z_7 + 1E-05);
                float r0_z_9 = (0.5 / r0_z_8);
                float r0_z_10 = (r0_z_9 * 0.9999999);
                float r0_z_11 = max(r0_z_10, 0.0001);
                float r0_z_12 = sqrt(r0_z_11);
                float4 r0_xyzw_8 = (r1_x_2.xxxx * float4(r0_y_7, r0_y_7, r0_z_12, r0_y_7));
                float r0_y_8 = r0_xyzw_8.y;
                float r0_z_13 = r0_xyzw_8.z;
                float4 r1_xyzw_3 = (r0_y_8.xxxx * r4_xyz_12.xyzx);
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_6 = r1_xyzw_3.y;
                float r1_z_4 = r1_xyzw_3.z;
                float4 r0_xyzw_9 = (r4_xyz_12.xxyz * r0_z_13.xxxx);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_w_7 = r0_xyzw_9.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_2 = (r0_x_5 * r0_x_5);
                float r1_w_3 = (r1_w_2 * r1_w_2);
                float r0_x_8 = (((mad((r0_x_5 * r1_w_3), 0.7790837, 0.2209163)).xxxx * float4(r0_y_9, r0_z_14, r0_w_7, r0_y_9))).x;
                float4 r0_xyzw_10 = ((mad((r0_x_5 * r1_w_3), 0.7790837, 0.2209163)).xxxx * float4(r0_y_9, r0_z_14, r0_w_7, r0_y_9));
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_15 = r0_xyzw_10.z;
                float r0_x_9 = (mad(((((r1_w_1.xxxx * r2_xyzw_1.xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_3, r1_y_6, r1_z_4, r1_x_3), float4(r0_x_8, r0_y_10, r0_z_15, r0_x_8))).x;
                float4 r0_xyzw_11 = mad(((((r1_w_1.xxxx * r2_xyzw_1.xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_3, r1_y_6, r1_z_4, r1_x_3), float4(r0_x_8, r0_y_10, r0_z_15, r0_x_8));
                float r0_y_11 = r0_xyzw_11.y;
                float r0_z_16 = r0_xyzw_11.z;
                float r0_w_8 = (i.texcoord6.x / cb1_values[5].y);
                float r0_w_9 = (-r0_w_8 + 1);
                float r0_w_10 = (r0_w_9 * cb1_values[5].z);
                float r0_w_11 = max(r0_w_10, 0);
                float r0_w_12 = mad(r0_w_11, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w);
                o.sv_Target0.xyz = ((float4(r0_x_9, r0_y_11, r0_z_16, r0_x_9) * r0_w_12.xxxx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Highatmospherecolor;
                float _BumpScale;
                float4 _Lowatmospherecolor;
                float _AlphaScale;
                float _DisplacementClouds;
                float4 _MainTex_ST;
                float _Outeratmopsheredensity;
                float _Inneratmopsheredensity;
                float _Innerouterlimit;
                float _Inneroutersmoothness;
                float _Outeratmospherelimit;
                float4 _Inneratmosphere;
                float _DisplacementAtmosphere;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float3 _WorldSpaceCameraPos;
                float4 unity_WorldTransformParams;
                float4 cb1_values[6];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[7];
            };
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_linear_clamp1 : register(s1);
            SamplerState sampler_linear_clamp2 : register(s2);
            SamplerState sampler_linear_clamp3 : register(s3);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture2D t2 : register(t2);
            Texture3D t3 : register(t3);
            struct program24Input
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
            struct program24Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord6 : TEXCOORD6;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
            };
            struct program42Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord6 : TEXCOORD6;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
            };
            struct program42Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program24Output vert(program24Input i)
            {
                program24Output o = (program24Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float3 r0_xyz_1 = (mad(i.normal0.xyzx, cb0_values[8].zzzz, i.position0.xyzx)).xyz;
                float4 r0_xyzw_2 = mad(unity_ObjectToWorld[2], r0_xyz_1.zzzz, mad(unity_ObjectToWorld[0], r0_xyz_1.xxxx, (r0_xyz_1.yyyy * unity_ObjectToWorld[1])));
                float4 r1_xyzw_3 = (r0_xyzw_2 + unity_ObjectToWorld[3]);
                float4 r1_xyzw_4 = mad(unity_MatrixVP[3], r1_xyzw_3.wwww, mad(unity_MatrixVP[2], r1_xyzw_3.zzzz, mad(unity_MatrixVP[0], r1_xyzw_3.xxxx, (r1_xyzw_3.yyyy * unity_MatrixVP[1]))));
                o.sv_Position0.xyzw = UnityObjectToClipPos(r1_xyzw_3);
                o.texcoord6.x = r1_xyzw_4.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_y_5 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_5 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_5 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_5 = dot(float4(worldNormal_x_5, worldNormal_y_5, worldNormal_z_5, worldNormal_x_5), float4(worldNormal_x_5, worldNormal_y_5, worldNormal_z_5, worldNormal_x_5));
                float r1_w_6 = rsqrt(r1_w_5);
                float3 unitWorldNormal_xyz_6 = ((r1_w_6.xxxx * float4(worldNormal_x_5, worldNormal_y_5, worldNormal_z_5, worldNormal_x_5))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_9 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_9.xxxx * (mad(unitWorldNormal_xyz_6.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_6.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_6.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_6.z;
                o.texcoord3.z = unitWorldNormal_xyz_6.x;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord4.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, r0_xyzw_2.xyzx)).xyz;
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[3], i.position0.wwww, r0_xyzw_2);
                float3 clipPos_xyz_7 = ((worldPos_xyzw_3.yyyy * _MainTex_ST.xyzx)).xyz;
                float3 clipPos_xyz_8 = (mad(_Lowatmospherecolor.xyzx, worldPos_xyzw_3.xxxx, clipPos_xyz_7.xyzx)).xyz;
                float3 clipPos_xyz_4 = (mad(cb0_values[6].xyzx, worldPos_xyzw_3.zzzz, clipPos_xyz_8.xyzx)).xyz;
                o.texcoord5.xyz = (mad(_Inneratmosphere.xyzx, worldPos_xyzw_3.wwww, clipPos_xyz_4.xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program42Output frag(program42Input i)
            {
                program42Output o = (program42Output)0;
                float3 r0_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 r2_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float3 r2_xyz_2 = normalize(r2_xyz_1);
                float4 r3_xyzw_1 = t0.Sample(sampler_linear_clamp2, (i.texcoord0.xyxx).xy);
                float4 r4_xyzw_1 = t1.Sample(sampler_linear_clamp3, (i.texcoord0.xyxx).xy);
                float r1_w_3 = (r3_xyzw_1.w * cb0_values[8].y);
                float r4_x_2 = (r4_xyzw_1.w * r4_xyzw_1.x);
                float4 r4_xyzw_3 = mad(float4(r4_x_2, r4_xyzw_1.y, r4_x_2, r4_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r4_x_3 = r4_xyzw_3.x;
                float r4_y_2 = r4_xyzw_3.y;
                float4 r4_xyzw_4 = (float4(r4_x_3, r4_y_2, r4_x_3, r4_x_3) * cb0_values[8].xxxx);
                float r4_x_4 = r4_xyzw_4.x;
                float r4_y_3 = r4_xyzw_4.y;
                float r2_w_1 = dot(float4(r4_x_4, r4_y_3, r4_x_4, r4_x_4), float4(r4_x_4, r4_y_3, r4_x_4, r4_x_4));
                float r2_w_2 = min(r2_w_1, 1);
                float r2_w_3 = (-r2_w_2 + 1);
                float r4_z_2 = sqrt(r2_w_3);
                float r2_w_4 = dot(float4(r4_x_4, r4_y_3, r4_z_2, r4_x_4), float4(r4_x_4, r4_y_3, r4_z_2, r4_x_4));
                float r2_w_5 = rsqrt(r2_w_4);
                float4 r4_xyzw_5 = (r2_w_5.xxxx * float4(r4_x_4, r4_y_3, r4_z_2, r4_x_4));
                float r4_x_5 = r4_xyzw_5.x;
                float r4_y_4 = r4_xyzw_5.y;
                float r4_z_3 = r4_xyzw_5.z;
                float3 r5_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord4.zzzz, (mad(cb0_values[4].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r2_w_6 = (cb4_values[0].x == 1);
                float r6_x_10;
                float r6_y_10;
                float r6_z_10;
                float r6_w_4;
                if (r2_w_6)
                {
                    float r2_w_7 = (cb4_values[0].y == 1);
                    float3 r6_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord4.zzzz, (mad(cb4_values[1].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r6_xyzw_8 = (((((r2_w_7.xxxx ? r6_xyz_5.xyzx : i.texcoord4.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r6_y_8 = r6_xyzw_8.y;
                    float r6_z_8 = r6_xyzw_8.z;
                    float r6_w_2 = r6_xyzw_8.w;
                    float r2_w_8 = mad(r6_y_8, 0.25, 0.75);
                    float r3_w_2 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r6_x_8 = max(r2_w_8, r3_w_2);
                    float4 r6_xyzw_9 = t3.Sample(sampler_linear_clamp, (float4(r6_x_8, r6_z_8, r6_w_2, r6_x_8)).xyz);
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
                float r2_w_10 = dot(float4(r6_x_10, r6_y_10, r6_z_10, r6_w_4), unity_OcclusionMaskSelector);
                float r3_w_4 = dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx);
                float4 r5_xyzw_5 = t2.Sample(sampler_linear_clamp1, (r3_w_4.xxxx).xy);
                float r2_w_11 = (r2_w_10 * r5_xyzw_5.x);
                float r5_x_6 = dot(i.texcoord1.xyzx, float4(r4_x_5, r4_y_4, r4_z_3, r4_x_5));
                float r5_y_6 = dot(i.texcoord2.xyzx, float4(r4_x_5, r4_y_4, r4_z_3, r4_x_5));
                float r5_z_6 = dot(i.texcoord3.xyzx, float4(r4_x_5, r4_y_4, r4_z_3, r4_x_5));
                float r3_w_5 = dot(float4(r5_x_6, r5_y_6, r5_z_6, r5_x_6), float4(r5_x_6, r5_y_6, r5_z_6, r5_x_6));
                float r3_w_6 = rsqrt(r3_w_5);
                float4 r4_xyzw_6 = (r3_w_6.xxxx * float4(r5_x_6, r5_y_6, r5_z_6, r5_x_6));
                float r4_x_6 = r4_xyzw_6.x;
                float r4_y_5 = r4_xyzw_6.y;
                float r4_z_4 = r4_xyzw_6.z;
                float3 r5_xyz_7 = ((r2_w_11.xxxx * _LightColor0.xyzx)).xyz;
                o.sv_Target0.w = mad(r1_w_3, 0.7790837, 0.22091627);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, r2_xyz_2.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float r0_w_6 = dot(float4(r4_x_6, r4_y_5, r4_z_4, r4_x_6), r2_xyz_2.xyzx);
                float r1_w_4 = dot(float4(r4_x_6, r4_y_5, r4_z_4, r4_x_6), r1_xyz_1.xyzx);
                float r0_x_4 = dot(r1_xyz_1.xyzx, ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyzx);
                float r0_y_4 = dot(r0_x_4.xxxx, r0_x_4.xxxx);
                float r0_y_5 = (r0_y_4 + -0.5);
                float r0_z_4 = (-r1_w_4 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_5, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_6 = mad(r0_y_5, (r1_x_4 * r1_y_3), 1);
                float r0_y_7 = (r0_y_6 * r0_z_6);
                float r0_z_7 = (abs(r0_w_6) + r1_w_4);
                float r0_z_8 = (r0_z_7 + 1E-05);
                float r0_z_9 = (0.5 / r0_z_8);
                float r0_z_10 = (r0_z_9 * 0.9999999);
                float r0_z_11 = max(r0_z_10, 0.0001);
                float r0_z_12 = sqrt(r0_z_11);
                float4 r0_xyzw_8 = (r1_w_4.xxxx * float4(r0_y_7, r0_y_7, r0_z_12, r0_y_7));
                float r0_y_8 = r0_xyzw_8.y;
                float r0_z_13 = r0_xyzw_8.z;
                float4 r1_xyzw_6 = (r0_y_8.xxxx * r5_xyz_7.xyzx);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_2 = r1_xyzw_6.z;
                float4 r0_xyzw_9 = (r5_xyz_7.xxyz * r0_z_13.xxxx);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_w_7 = r0_xyzw_9.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_5 = (r0_x_5 * r0_x_5);
                float r1_w_6 = (r1_w_5 * r1_w_5);
                float r0_x_8 = (((mad((r0_x_5 * r1_w_6), 0.7790837, 0.2209163)).xxxx * float4(r0_y_9, r0_z_14, r0_w_7, r0_y_9))).x;
                float4 r0_xyzw_10 = ((mad((r0_x_5 * r1_w_6), 0.7790837, 0.2209163)).xxxx * float4(r0_y_9, r0_z_14, r0_w_7, r0_y_9));
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_15 = r0_xyzw_10.z;
                float r0_x_9 = (mad(((((r1_w_3.xxxx * r3_xyzw_1.xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_6, r1_y_4, r1_z_2, r1_x_6), float4(r0_x_8, r0_y_10, r0_z_15, r0_x_8))).x;
                float4 r0_xyzw_11 = mad(((((r1_w_3.xxxx * r3_xyzw_1.xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_6, r1_y_4, r1_z_2, r1_x_6), float4(r0_x_8, r0_y_10, r0_z_15, r0_x_8));
                float r0_y_11 = r0_xyzw_11.y;
                float r0_z_16 = r0_xyzw_11.z;
                float r0_w_8 = (i.texcoord6.x / cb1_values[5].y);
                float r0_w_9 = (-r0_w_8 + 1);
                float r0_w_10 = (r0_w_9 * cb1_values[5].z);
                float r0_w_11 = max(r0_w_10, 0);
                float r0_w_12 = mad(r0_w_11, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w);
                o.sv_Target0.xyz = ((float4(r0_x_9, r0_y_11, r0_z_16, r0_x_9) * r0_w_12.xxxx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Highatmospherecolor;
                float _BumpScale;
                float4 _Lowatmospherecolor;
                float _AlphaScale;
                float _DisplacementClouds;
                float4 _MainTex_ST;
                float _Outeratmopsheredensity;
                float _Inneratmopsheredensity;
                float _Innerouterlimit;
                float _Inneroutersmoothness;
                float _Outeratmospherelimit;
                float4 _Inneratmosphere;
                float _DisplacementAtmosphere;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float3 _WorldSpaceCameraPos;
                float4 unity_WorldTransformParams;
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
            };
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_linear_clamp1 : register(s1);
            SamplerState sampler_linear_clamp2 : register(s2);
            SamplerState sampler_linear_clamp3 : register(s3);
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
                float2 texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
            };
            struct program41Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
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
                float3 r0_xyz_1 = (mad(i.normal0.xyzx, cb0_values[8].zzzz, i.position0.xyzx)).xyz;
                float4 r0_xyzw_2 = mad(unity_ObjectToWorld[2], r0_xyz_1.zzzz, mad(unity_ObjectToWorld[0], r0_xyz_1.xxxx, (r0_xyz_1.yyyy * unity_ObjectToWorld[1])));
                float4 r1_xyzw_3 = (r0_xyzw_2 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(r1_xyzw_3);
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, r0_xyzw_2);
                o.texcoord4.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, r0_xyzw_2.xyzx)).xyz;
                float2 clipPos_xy_3 = ((worldPos_xyzw_4.yyyy * _MainTex_ST.xyxx)).xy;
                float2 clipPos_xy_4 = (mad(_Lowatmospherecolor.xyxx, worldPos_xyzw_4.xxxx, clipPos_xy_3.xyxx)).xy;
                float2 clipPos_xy_5 = (mad(cb0_values[6].xyxx, worldPos_xyzw_4.zzzz, clipPos_xy_4.xyxx)).xy;
                o.texcoord5.xy = (mad(_Inneratmosphere.xxxy, worldPos_xyzw_4.wwww, clipPos_xy_5.xxxy)).zw;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_y_6 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_6 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_2 = dot(float4(worldNormal_x_6, worldNormal_y_6, worldNormal_z_3, worldNormal_x_6), float4(worldNormal_x_6, worldNormal_y_6, worldNormal_z_3, worldNormal_x_6));
                float r0_w_3 = rsqrt(r0_w_2);
                float4 unitWorldNormal_xyzw_7 = (r0_w_3.xxxx * float4(worldNormal_x_6, worldNormal_y_6, worldNormal_z_3, worldNormal_x_6));
                float unitWorldNormal_x_7 = unitWorldNormal_xyzw_7.x;
                float unitWorldNormal_y_7 = unitWorldNormal_xyzw_7.y;
                float unitWorldNormal_z_4 = unitWorldNormal_xyzw_7.z;
                float3 worldTangent_xyz_5 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_5.xyzx)).xyz;
                float3 worldTangent_xyz_7 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_6.xyzx)).xyz;
                float3 unitWorldTangent_xyz_8 = normalize(worldTangent_xyz_7);
                float r0_w_6 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r2_xyz_6 = ((r0_w_6.xxxx * (mad(float4(unitWorldNormal_z_4, unitWorldNormal_x_7, unitWorldNormal_y_7, unitWorldNormal_z_4), unitWorldTangent_xyz_8.yzxy, ((float4(unitWorldNormal_x_7, unitWorldNormal_y_7, unitWorldNormal_z_4, unitWorldNormal_x_7) * unitWorldTangent_xyz_8.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r2_xyz_6.x;
                o.texcoord1.x = unitWorldTangent_xyz_8.z;
                o.texcoord1.z = unitWorldNormal_y_7;
                o.texcoord2.x = unitWorldTangent_xyz_8.x;
                o.texcoord3.x = unitWorldTangent_xyz_8.y;
                o.texcoord2.z = unitWorldNormal_z_4;
                o.texcoord3.z = unitWorldNormal_x_7;
                o.texcoord2.y = r2_xyz_6.y;
                o.texcoord3.y = r2_xyz_6.z;
                return o;
            }
            #pragma fragment frag
            program41Output frag(program41Input i)
            {
                program41Output o = (program41Output)0;
                float3 r0_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r2_xyzw_1 = t0.Sample(sampler_linear_clamp2, (i.texcoord0.xyxx).xy);
                float4 r3_xyzw_1 = t1.Sample(sampler_linear_clamp3, (i.texcoord0.xyxx).xy);
                float r1_w_1 = (r2_xyzw_1.w * cb0_values[8].y);
                float r3_x_2 = (r3_xyzw_1.w * r3_xyzw_1.x);
                float4 r3_xyzw_3 = mad(float4(r3_x_2, r3_xyzw_1.y, r3_x_2, r3_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float4 r3_xyzw_4 = (float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3) * cb0_values[8].xxxx);
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r2_w_2 = dot(float4(r3_x_4, r3_y_3, r3_x_4, r3_x_4), float4(r3_x_4, r3_y_3, r3_x_4, r3_x_4));
                float r2_w_3 = min(r2_w_2, 1);
                float r2_w_4 = (-r2_w_3 + 1);
                float r3_z_2 = sqrt(r2_w_4);
                float r2_w_5 = dot(float4(r3_x_4, r3_y_3, r3_z_2, r3_x_4), float4(r3_x_4, r3_y_3, r3_z_2, r3_x_4));
                float r2_w_6 = rsqrt(r2_w_5);
                float4 r3_xyzw_5 = (r2_w_6.xxxx * float4(r3_x_4, r3_y_3, r3_z_2, r3_x_4));
                float r3_x_5 = r3_xyzw_5.x;
                float r3_y_4 = r3_xyzw_5.y;
                float r3_z_3 = r3_xyzw_5.z;
                float r2_w_7 = (unity_ProbeVolumeParams.x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r2_w_7)
                {
                    float r2_w_8 = (unity_ProbeVolumeParams.y == 1);
                    float3 r5_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord4.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r2_w_8.xxxx ? r5_xyz_5.xyzx : i.texcoord4.xyzx)).xyz;
                    float4 r5_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r2_w_9 = mad(r5_y_8, 0.25, 0.75);
                    float r3_w_2 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r5_x_8 = max(r2_w_9, r3_w_2);
                    float4 r5_xyzw_9 = t3.Sample(sampler_linear_clamp, (float4(r5_x_8, r5_z_8, r5_w_2, r5_x_8)).xyz);
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
                float r2_w_11 = dot(float4(r5_x_10, r5_y_10, r5_z_10, r5_w_4), unity_OcclusionMaskSelector);
                float4 r4_xyzw_5 = t2.Sample(sampler_linear_clamp1, ((((mad(cb0_values[6].xyxx, i.texcoord4.zzzz, (mad(cb0_values[4].xyxx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx).xy);
                float r2_w_12 = (r2_w_11 * r4_xyzw_5.w);
                float r4_x_6 = dot(i.texcoord1.xyzx, float4(r3_x_5, r3_y_4, r3_z_3, r3_x_5));
                float r4_y_6 = dot(i.texcoord2.xyzx, float4(r3_x_5, r3_y_4, r3_z_3, r3_x_5));
                float r4_z_2 = dot(i.texcoord3.xyzx, float4(r3_x_5, r3_y_4, r3_z_3, r3_x_5));
                float4 r3_xyzw_8 = ((rsqrt(dot(float4(r4_x_6, r4_y_6, r4_z_2, r4_x_6), float4(r4_x_6, r4_y_6, r4_z_2, r4_x_6)))).xxxx * float4(r4_x_6, r4_y_6, r4_z_2, r4_x_6));
                float r3_x_8 = r3_xyzw_8.x;
                float r3_y_5 = r3_xyzw_8.y;
                float r3_z_4 = r3_xyzw_8.z;
                float4 r4_xyzw_7 = (r2_w_12.xxxx * _LightColor0.xyzx);
                float r4_x_7 = r4_xyzw_7.x;
                float r4_y_7 = r4_xyzw_7.y;
                float r4_z_3 = r4_xyzw_7.z;
                o.sv_Target0.w = mad(r1_w_1, 0.7790837, 0.22091627);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float r0_w_6 = dot(float4(r3_x_8, r3_y_5, r3_z_4, r3_x_8), ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx);
                float r1_x_2 = dot(float4(r3_x_8, r3_y_5, r3_z_4, r3_x_8), _WorldSpaceLightPos0.xyzx);
                float r0_x_4 = dot(_WorldSpaceLightPos0.xyzx, ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyzx);
                float r0_y_4 = dot(r0_x_4.xxxx, r0_x_4.xxxx);
                float r0_y_5 = (r0_y_4 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_y_2 = (r0_z_4 * r0_z_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_z_5 = (r0_z_4 * r1_y_3);
                float r0_z_6 = mad(r0_y_5, r0_z_5, 1);
                float r1_y_4 = (-abs(r0_w_6) + 1);
                float r1_z_2 = (r1_y_4 * r1_y_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r1_y_5 = (r1_y_4 * r1_z_3);
                float r0_y_6 = mad(r0_y_5, r1_y_5, 1);
                float r0_y_7 = (r0_y_6 * r0_z_6);
                float r0_z_7 = (abs(r0_w_6) + r1_x_2);
                float r0_z_8 = (r0_z_7 + 1E-05);
                float r0_z_9 = (0.5 / r0_z_8);
                float r0_z_10 = (r0_z_9 * 0.9999999);
                float r0_z_11 = max(r0_z_10, 0.0001);
                float r0_z_12 = sqrt(r0_z_11);
                float4 r0_xyzw_8 = (r1_x_2.xxxx * float4(r0_y_7, r0_y_7, r0_z_12, r0_y_7));
                float r0_y_8 = r0_xyzw_8.y;
                float r0_z_13 = r0_xyzw_8.z;
                float4 r1_xyzw_3 = (r0_y_8.xxxx * float4(r4_x_7, r4_y_7, r4_z_3, r4_x_7));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_6 = r1_xyzw_3.y;
                float r1_z_4 = r1_xyzw_3.z;
                float4 r0_xyzw_9 = (float4(r4_x_7, r4_x_7, r4_y_7, r4_z_3) * r0_z_13.xxxx);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_w_7 = r0_xyzw_9.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_2 = (r0_x_5 * r0_x_5);
                float r1_w_3 = (r1_w_2 * r1_w_2);
                float r0_x_8 = (((mad((r0_x_5 * r1_w_3), 0.7790837, 0.2209163)).xxxx * float4(r0_y_9, r0_z_14, r0_w_7, r0_y_9))).x;
                float4 r0_xyzw_10 = ((mad((r0_x_5 * r1_w_3), 0.7790837, 0.2209163)).xxxx * float4(r0_y_9, r0_z_14, r0_w_7, r0_y_9));
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_15 = r0_xyzw_10.z;
                o.sv_Target0.xyz = (mad(((((r1_w_1.xxxx * r2_xyzw_1.xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_3, r1_y_6, r1_z_4, r1_x_3), float4(r0_x_8, r0_y_10, r0_z_15, r0_x_8))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Highatmospherecolor;
                float _BumpScale;
                float4 _Lowatmospherecolor;
                float _AlphaScale;
                float _DisplacementClouds;
                float4 _MainTex_ST;
                float _Outeratmopsheredensity;
                float _Inneratmopsheredensity;
                float _Innerouterlimit;
                float _Inneroutersmoothness;
                float _Outeratmospherelimit;
                float4 _Inneratmosphere;
                float _DisplacementAtmosphere;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float3 _WorldSpaceCameraPos;
                float4 unity_WorldTransformParams;
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
            };
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_linear_clamp1 : register(s1);
            SamplerState sampler_linear_clamp2 : register(s2);
            SamplerState sampler_linear_clamp3 : register(s3);
            SamplerState sampler_linear_clamp4 : register(s4);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture2D t2 : register(t2);
            TextureCube t3 : register(t3);
            Texture3D t4 : register(t4);
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
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
            };
            struct program40Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
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
                float3 r0_xyz_1 = (mad(i.normal0.xyzx, cb0_values[8].zzzz, i.position0.xyzx)).xyz;
                float4 r0_xyzw_2 = mad(unity_ObjectToWorld[2], r0_xyz_1.zzzz, mad(unity_ObjectToWorld[0], r0_xyz_1.xxxx, (r0_xyz_1.yyyy * unity_ObjectToWorld[1])));
                float4 r1_xyzw_3 = (r0_xyzw_2 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(r1_xyzw_3);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_y_4 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_4 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_4 = dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4));
                float r1_w_5 = rsqrt(r1_w_4);
                float3 unitWorldNormal_xyz_5 = ((r1_w_5.xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_8 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_8.xxxx * (mad(unitWorldNormal_xyz_5.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_5.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_5.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_5.z;
                o.texcoord3.z = unitWorldNormal_xyz_5.x;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord4.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, r0_xyzw_2.xyzx)).xyz;
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[3], i.position0.wwww, r0_xyzw_2);
                float3 clipPos_xyz_6 = ((worldPos_xyzw_3.yyyy * _MainTex_ST.xyzx)).xyz;
                float3 clipPos_xyz_7 = (mad(_Lowatmospherecolor.xyzx, worldPos_xyzw_3.xxxx, clipPos_xyz_6.xyzx)).xyz;
                float3 clipPos_xyz_4 = (mad(cb0_values[6].xyzx, worldPos_xyzw_3.zzzz, clipPos_xyz_7.xyzx)).xyz;
                o.texcoord5.xyz = (mad(_Inneratmosphere.xyzx, worldPos_xyzw_3.wwww, clipPos_xyz_4.xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program40Output frag(program40Input i)
            {
                program40Output o = (program40Output)0;
                float3 r0_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 r2_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float3 r2_xyz_2 = normalize(r2_xyz_1);
                float4 r3_xyzw_1 = t0.Sample(sampler_linear_clamp3, (i.texcoord0.xyxx).xy);
                float4 r4_xyzw_1 = t1.Sample(sampler_linear_clamp4, (i.texcoord0.xyxx).xy);
                float r1_w_3 = (r3_xyzw_1.w * cb0_values[8].y);
                float r4_x_2 = (r4_xyzw_1.w * r4_xyzw_1.x);
                float4 r4_xyzw_3 = mad(float4(r4_x_2, r4_xyzw_1.y, r4_x_2, r4_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r4_x_3 = r4_xyzw_3.x;
                float r4_y_2 = r4_xyzw_3.y;
                float4 r4_xyzw_4 = (float4(r4_x_3, r4_y_2, r4_x_3, r4_x_3) * cb0_values[8].xxxx);
                float r4_x_4 = r4_xyzw_4.x;
                float r4_y_3 = r4_xyzw_4.y;
                float r2_w_1 = dot(float4(r4_x_4, r4_y_3, r4_x_4, r4_x_4), float4(r4_x_4, r4_y_3, r4_x_4, r4_x_4));
                float r2_w_2 = min(r2_w_1, 1);
                float r2_w_3 = (-r2_w_2 + 1);
                float r4_z_2 = sqrt(r2_w_3);
                float r2_w_4 = dot(float4(r4_x_4, r4_y_3, r4_z_2, r4_x_4), float4(r4_x_4, r4_y_3, r4_z_2, r4_x_4));
                float r2_w_5 = rsqrt(r2_w_4);
                float4 r4_xyzw_5 = (r2_w_5.xxxx * float4(r4_x_4, r4_y_3, r4_z_2, r4_x_4));
                float r4_x_5 = r4_xyzw_5.x;
                float r4_y_4 = r4_xyzw_5.y;
                float r4_z_3 = r4_xyzw_5.z;
                float3 r5_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord4.zzzz, (mad(cb0_values[4].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r2_w_6 = (unity_ProbeVolumeParams.x == 1);
                float r6_x_10;
                float r6_y_10;
                float r6_z_10;
                float r6_w_4;
                if (r2_w_6)
                {
                    float r2_w_7 = (unity_ProbeVolumeParams.y == 1);
                    float3 r6_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord4.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r2_w_7.xxxx ? r6_xyz_5.xyzx : i.texcoord4.xyzx)).xyz;
                    float4 r6_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r6_y_8 = r6_xyzw_8.y;
                    float r6_z_8 = r6_xyzw_8.z;
                    float r6_w_2 = r6_xyzw_8.w;
                    float r2_w_8 = mad(r6_y_8, 0.25, 0.75);
                    float r3_w_2 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r6_x_8 = max(r2_w_8, r3_w_2);
                    float4 r6_xyzw_9 = t4.Sample(sampler_linear_clamp, (float4(r6_x_8, r6_z_8, r6_w_2, r6_x_8)).xyz);
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
                float r2_w_10 = dot(float4(r6_x_10, r6_y_10, r6_z_10, r6_w_4), unity_OcclusionMaskSelector);
                float r3_w_4 = dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx);
                float4 r6_xyzw_11 = t2.Sample(sampler_linear_clamp2, (r3_w_4.xxxx).xy);
                float4 r5_xyzw_5 = t3.Sample(sampler_linear_clamp1, r5_xyz_4.xyz);
                float r3_w_5 = (r5_xyzw_5.w * r6_xyzw_11.x);
                float r2_w_11 = (r2_w_10 * r3_w_5);
                float r5_x_6 = dot(i.texcoord1.xyzx, float4(r4_x_5, r4_y_4, r4_z_3, r4_x_5));
                float r5_y_6 = dot(i.texcoord2.xyzx, float4(r4_x_5, r4_y_4, r4_z_3, r4_x_5));
                float r5_z_6 = dot(i.texcoord3.xyzx, float4(r4_x_5, r4_y_4, r4_z_3, r4_x_5));
                float r3_w_6 = dot(float4(r5_x_6, r5_y_6, r5_z_6, r5_x_6), float4(r5_x_6, r5_y_6, r5_z_6, r5_x_6));
                float r3_w_7 = rsqrt(r3_w_6);
                float4 r4_xyzw_6 = (r3_w_7.xxxx * float4(r5_x_6, r5_y_6, r5_z_6, r5_x_6));
                float r4_x_6 = r4_xyzw_6.x;
                float r4_y_5 = r4_xyzw_6.y;
                float r4_z_4 = r4_xyzw_6.z;
                float3 r5_xyz_7 = ((r2_w_11.xxxx * _LightColor0.xyzx)).xyz;
                o.sv_Target0.w = mad(r1_w_3, 0.7790837, 0.22091627);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, r2_xyz_2.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float r0_w_6 = dot(float4(r4_x_6, r4_y_5, r4_z_4, r4_x_6), r2_xyz_2.xyzx);
                float r1_w_4 = dot(float4(r4_x_6, r4_y_5, r4_z_4, r4_x_6), r1_xyz_1.xyzx);
                float r0_x_4 = dot(r1_xyz_1.xyzx, ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyzx);
                float r0_y_4 = dot(r0_x_4.xxxx, r0_x_4.xxxx);
                float r0_y_5 = (r0_y_4 + -0.5);
                float r0_z_4 = (-r1_w_4 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_5, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_6 = mad(r0_y_5, (r1_x_4 * r1_y_3), 1);
                float r0_y_7 = (r0_y_6 * r0_z_6);
                float r0_z_7 = (abs(r0_w_6) + r1_w_4);
                float r0_z_8 = (r0_z_7 + 1E-05);
                float r0_z_9 = (0.5 / r0_z_8);
                float r0_z_10 = (r0_z_9 * 0.9999999);
                float r0_z_11 = max(r0_z_10, 0.0001);
                float r0_z_12 = sqrt(r0_z_11);
                float4 r0_xyzw_8 = (r1_w_4.xxxx * float4(r0_y_7, r0_y_7, r0_z_12, r0_y_7));
                float r0_y_8 = r0_xyzw_8.y;
                float r0_z_13 = r0_xyzw_8.z;
                float4 r1_xyzw_6 = (r0_y_8.xxxx * r5_xyz_7.xyzx);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_2 = r1_xyzw_6.z;
                float4 r0_xyzw_9 = (r5_xyz_7.xxyz * r0_z_13.xxxx);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_w_7 = r0_xyzw_9.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_5 = (r0_x_5 * r0_x_5);
                float r1_w_6 = (r1_w_5 * r1_w_5);
                float r0_x_8 = (((mad((r0_x_5 * r1_w_6), 0.7790837, 0.2209163)).xxxx * float4(r0_y_9, r0_z_14, r0_w_7, r0_y_9))).x;
                float4 r0_xyzw_10 = ((mad((r0_x_5 * r1_w_6), 0.7790837, 0.2209163)).xxxx * float4(r0_y_9, r0_z_14, r0_w_7, r0_y_9));
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_15 = r0_xyzw_10.z;
                o.sv_Target0.xyz = (mad(((((r1_w_3.xxxx * r3_xyzw_1.xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_6, r1_y_4, r1_z_2, r1_x_6), float4(r0_x_8, r0_y_10, r0_z_15, r0_x_8))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Highatmospherecolor;
                float _BumpScale;
                float4 _Lowatmospherecolor;
                float _AlphaScale;
                float _DisplacementClouds;
                float4 _MainTex_ST;
                float _Outeratmopsheredensity;
                float _Inneratmopsheredensity;
                float _Innerouterlimit;
                float _Inneroutersmoothness;
                float _Outeratmospherelimit;
                float4 _Inneratmosphere;
                float _DisplacementAtmosphere;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float3 _WorldSpaceCameraPos;
                float4 unity_WorldTransformParams;
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
            };
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_linear_clamp1 : register(s1);
            SamplerState sampler_linear_clamp2 : register(s2);
            SamplerState sampler_linear_clamp3 : register(s3);
            SamplerState sampler_linear_clamp4 : register(s4);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture2D t2 : register(t2);
            Texture2D t3 : register(t3);
            Texture3D t4 : register(t4);
            struct program21Input
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
            struct program21Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program39Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program39Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program21Output vert(program21Input i)
            {
                program21Output o = (program21Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float3 r0_xyz_1 = (mad(i.normal0.xyzx, cb0_values[8].zzzz, i.position0.xyzx)).xyz;
                float4 r0_xyzw_2 = mad(unity_ObjectToWorld[2], r0_xyz_1.zzzz, mad(unity_ObjectToWorld[0], r0_xyz_1.xxxx, (r0_xyz_1.yyyy * unity_ObjectToWorld[1])));
                float4 r1_xyzw_3 = (r0_xyzw_2 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(r1_xyzw_3);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_y_4 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_4 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_4 = dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4));
                float r1_w_5 = rsqrt(r1_w_4);
                float3 unitWorldNormal_xyz_5 = ((r1_w_5.xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_8 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_8.xxxx * (mad(unitWorldNormal_xyz_5.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_5.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_5.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_5.z;
                o.texcoord3.z = unitWorldNormal_xyz_5.x;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord4.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, r0_xyzw_2.xyzx)).xyz;
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[3], i.position0.wwww, r0_xyzw_2);
                float4 clipPos_xyzw_6 = (worldPos_xyzw_3.yyyy * _MainTex_ST);
                float4 clipPos_xyzw_7 = mad(_Lowatmospherecolor, worldPos_xyzw_3.xxxx, clipPos_xyzw_6);
                float4 clipPos_xyzw_8 = mad(cb0_values[6].xyzw, worldPos_xyzw_3.zzzz, clipPos_xyzw_7);
                o.texcoord5.xyzw = mad(_Inneratmosphere, worldPos_xyzw_3.wwww, clipPos_xyzw_8);
                return o;
            }
            #pragma fragment frag
            program39Output frag(program39Input i)
            {
                program39Output o = (program39Output)0;
                float3 r0_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 r2_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float3 r2_xyz_2 = normalize(r2_xyz_1);
                float4 r3_xyzw_1 = t0.Sample(sampler_linear_clamp3, (i.texcoord0.xyxx).xy);
                float4 r4_xyzw_1 = t1.Sample(sampler_linear_clamp4, (i.texcoord0.xyxx).xy);
                float r1_w_3 = (r3_xyzw_1.w * cb0_values[8].y);
                float r4_x_2 = (r4_xyzw_1.w * r4_xyzw_1.x);
                float4 r4_xyzw_3 = mad(float4(r4_x_2, r4_xyzw_1.y, r4_x_2, r4_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r4_x_3 = r4_xyzw_3.x;
                float r4_y_2 = r4_xyzw_3.y;
                float4 r4_xyzw_4 = (float4(r4_x_3, r4_y_2, r4_x_3, r4_x_3) * cb0_values[8].xxxx);
                float r4_x_4 = r4_xyzw_4.x;
                float r4_y_3 = r4_xyzw_4.y;
                float r2_w_1 = dot(float4(r4_x_4, r4_y_3, r4_x_4, r4_x_4), float4(r4_x_4, r4_y_3, r4_x_4, r4_x_4));
                float r2_w_2 = min(r2_w_1, 1);
                float r2_w_3 = (-r2_w_2 + 1);
                float r4_z_2 = sqrt(r2_w_3);
                float r2_w_4 = dot(float4(r4_x_4, r4_y_3, r4_z_2, r4_x_4), float4(r4_x_4, r4_y_3, r4_z_2, r4_x_4));
                float r2_w_5 = rsqrt(r2_w_4);
                float4 r4_xyzw_5 = (r2_w_5.xxxx * float4(r4_x_4, r4_y_3, r4_z_2, r4_x_4));
                float r4_x_5 = r4_xyzw_5.x;
                float r4_y_4 = r4_xyzw_5.y;
                float r4_z_3 = r4_xyzw_5.z;
                float4 r5_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord4.zzzz, mad(cb0_values[4].xyzw, i.texcoord4.xxxx, (i.texcoord4.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r2_w_6 = (unity_ProbeVolumeParams.x == 1);
                float r6_x_10;
                float r6_y_10;
                float r6_z_10;
                float r6_w_4;
                if (r2_w_6)
                {
                    float r2_w_7 = (unity_ProbeVolumeParams.y == 1);
                    float3 r6_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord4.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r2_w_7.xxxx ? r6_xyz_5.xyzx : i.texcoord4.xyzx)).xyz;
                    float4 r6_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r6_y_8 = r6_xyzw_8.y;
                    float r6_z_8 = r6_xyzw_8.z;
                    float r6_w_2 = r6_xyzw_8.w;
                    float r2_w_8 = mad(r6_y_8, 0.25, 0.75);
                    float r3_w_2 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r6_x_8 = max(r2_w_8, r3_w_2);
                    float4 r6_xyzw_9 = t4.Sample(sampler_linear_clamp, (float4(r6_x_8, r6_z_8, r6_w_2, r6_x_8)).xyz);
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
                float r2_w_10 = dot(float4(r6_x_10, r6_y_10, r6_z_10, r6_w_4), unity_OcclusionMaskSelector);
                float r3_w_4 = (0 < r5_xyzw_4.z);
                float r3_w_5 = asfloat(asint(r3_w_4) & asint(1065353216));
                float4 r6_xyzw_13 = t2.Sample(sampler_linear_clamp1, (((((r5_xyzw_4.xyxx / r5_xyzw_4.wwww)).xyxx + float4(0.5, 0.5, 0, 0))).xyxx).xy);
                float r3_w_6 = (r3_w_5 * r6_xyzw_13.w);
                float r4_w_2 = dot(r5_xyzw_4.xyzx, r5_xyzw_4.xyzx);
                float4 r5_xyzw_5 = t3.Sample(sampler_linear_clamp2, (r4_w_2.xxxx).xy);
                float r3_w_7 = (r3_w_6 * r5_xyzw_5.x);
                float r2_w_11 = (r2_w_10 * r3_w_7);
                float r5_x_6 = dot(i.texcoord1.xyzx, float4(r4_x_5, r4_y_4, r4_z_3, r4_x_5));
                float r5_y_6 = dot(i.texcoord2.xyzx, float4(r4_x_5, r4_y_4, r4_z_3, r4_x_5));
                float r5_z_6 = dot(i.texcoord3.xyzx, float4(r4_x_5, r4_y_4, r4_z_3, r4_x_5));
                float r3_w_8 = dot(float4(r5_x_6, r5_y_6, r5_z_6, r5_x_6), float4(r5_x_6, r5_y_6, r5_z_6, r5_x_6));
                float r3_w_9 = rsqrt(r3_w_8);
                float4 r4_xyzw_6 = (r3_w_9.xxxx * float4(r5_x_6, r5_y_6, r5_z_6, r5_x_6));
                float r4_x_6 = r4_xyzw_6.x;
                float r4_y_5 = r4_xyzw_6.y;
                float r4_z_4 = r4_xyzw_6.z;
                float3 r5_xyz_7 = ((r2_w_11.xxxx * _LightColor0.xyzx)).xyz;
                o.sv_Target0.w = mad(r1_w_3, 0.7790837, 0.22091627);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, r2_xyz_2.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float r0_w_6 = dot(float4(r4_x_6, r4_y_5, r4_z_4, r4_x_6), r2_xyz_2.xyzx);
                float r1_w_4 = dot(float4(r4_x_6, r4_y_5, r4_z_4, r4_x_6), r1_xyz_1.xyzx);
                float r0_x_4 = dot(r1_xyz_1.xyzx, ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyzx);
                float r0_y_4 = dot(r0_x_4.xxxx, r0_x_4.xxxx);
                float r0_y_5 = (r0_y_4 + -0.5);
                float r0_z_4 = (-r1_w_4 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_5, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_6 = mad(r0_y_5, (r1_x_4 * r1_y_3), 1);
                float r0_y_7 = (r0_y_6 * r0_z_6);
                float r0_z_7 = (abs(r0_w_6) + r1_w_4);
                float r0_z_8 = (r0_z_7 + 1E-05);
                float r0_z_9 = (0.5 / r0_z_8);
                float r0_z_10 = (r0_z_9 * 0.9999999);
                float r0_z_11 = max(r0_z_10, 0.0001);
                float r0_z_12 = sqrt(r0_z_11);
                float4 r0_xyzw_8 = (r1_w_4.xxxx * float4(r0_y_7, r0_y_7, r0_z_12, r0_y_7));
                float r0_y_8 = r0_xyzw_8.y;
                float r0_z_13 = r0_xyzw_8.z;
                float4 r1_xyzw_6 = (r0_y_8.xxxx * r5_xyz_7.xyzx);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_2 = r1_xyzw_6.z;
                float4 r0_xyzw_9 = (r5_xyz_7.xxyz * r0_z_13.xxxx);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_w_7 = r0_xyzw_9.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_5 = (r0_x_5 * r0_x_5);
                float r1_w_6 = (r1_w_5 * r1_w_5);
                float r0_x_8 = (((mad((r0_x_5 * r1_w_6), 0.7790837, 0.2209163)).xxxx * float4(r0_y_9, r0_z_14, r0_w_7, r0_y_9))).x;
                float4 r0_xyzw_10 = ((mad((r0_x_5 * r1_w_6), 0.7790837, 0.2209163)).xxxx * float4(r0_y_9, r0_z_14, r0_w_7, r0_y_9));
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_15 = r0_xyzw_10.z;
                o.sv_Target0.xyz = (mad(((((r1_w_3.xxxx * r3_xyzw_1.xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_6, r1_y_4, r1_z_2, r1_x_6), float4(r0_x_8, r0_y_10, r0_z_15, r0_x_8))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Highatmospherecolor;
                float _BumpScale;
                float4 _Lowatmospherecolor;
                float _AlphaScale;
                float _DisplacementClouds;
                float4 _MainTex_ST;
                float _Outeratmopsheredensity;
                float _Inneratmopsheredensity;
                float _Innerouterlimit;
                float _Inneroutersmoothness;
                float _Outeratmospherelimit;
                float4 _Inneratmosphere;
                float _DisplacementAtmosphere;
                float4 cb0_values[5];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float3 _WorldSpaceCameraPos;
                float4 unity_WorldTransformParams;
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
            };
            cbuffer UnityProbeVolume : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
            };
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_linear_clamp1 : register(s1);
            SamplerState sampler_linear_clamp2 : register(s2);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture3D t2 : register(t2);
            struct program20Input
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
            struct program20Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
            };
            struct program38Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
            };
            struct program38Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program20Output vert(program20Input i)
            {
                program20Output o = (program20Output)0;
                float3 r0_xyz_1 = (mad(i.normal0.xyzx, _DisplacementClouds.xxxx, i.position0.xyzx)).xyz;
                float4 r0_xyzw_2 = mad(unity_ObjectToWorld[2], r0_xyz_1.zzzz, mad(unity_ObjectToWorld[0], r0_xyz_1.xxxx, (r0_xyz_1.yyyy * unity_ObjectToWorld[1])));
                float4 r1_xyzw_3 = (r0_xyzw_2 + unity_ObjectToWorld[3]);
                o.texcoord4.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, r0_xyzw_2.xyzx)).xyz;
                float4 r0_xyzw_3 = (r1_xyzw_3.yyyy * unity_MatrixVP[1]);
                float4 r0_xyzw_4 = mad(unity_MatrixVP[0], r1_xyzw_3.xxxx, r0_xyzw_3);
                float4 r0_xyzw_5 = mad(unity_MatrixVP[2], r1_xyzw_3.zzzz, r0_xyzw_4);
                o.sv_Position0.xyzw = mad(unity_MatrixVP[3], r1_xyzw_3.wwww, r0_xyzw_5);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_y_6 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_6 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_6 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_5 = dot(float4(worldNormal_x_6, worldNormal_y_6, worldNormal_z_6, worldNormal_x_6), float4(worldNormal_x_6, worldNormal_y_6, worldNormal_z_6, worldNormal_x_6));
                float r0_w_6 = rsqrt(r0_w_5);
                float3 unitWorldNormal_xyz_7 = ((r0_w_6.xxxx * float4(worldNormal_x_6, worldNormal_y_6, worldNormal_z_6, worldNormal_x_6))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r0_w_9 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r2_xyz_3 = ((r0_w_9.xxxx * (mad(unitWorldNormal_xyz_7.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_7.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r2_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_7.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_7.z;
                o.texcoord3.z = unitWorldNormal_xyz_7.x;
                o.texcoord2.y = r2_xyz_3.y;
                o.texcoord3.y = r2_xyz_3.z;
                return o;
            }
            #pragma fragment frag
            program38Output frag(program38Input i)
            {
                program38Output o = (program38Output)0;
                float3 r0_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r2_xyzw_1 = t0.Sample(sampler_linear_clamp1, (i.texcoord0.xyxx).xy);
                float4 r3_xyzw_1 = t1.Sample(sampler_linear_clamp2, (i.texcoord0.xyxx).xy);
                float r1_w_1 = (r2_xyzw_1.w * cb0_values[4].y);
                float r3_x_2 = (r3_xyzw_1.w * r3_xyzw_1.x);
                float4 r3_xyzw_3 = mad(float4(r3_x_2, r3_xyzw_1.y, r3_x_2, r3_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float4 r3_xyzw_4 = (float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3) * cb0_values[4].xxxx);
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r2_w_2 = dot(float4(r3_x_4, r3_y_3, r3_x_4, r3_x_4), float4(r3_x_4, r3_y_3, r3_x_4, r3_x_4));
                float r2_w_3 = min(r2_w_2, 1);
                float r2_w_4 = (-r2_w_3 + 1);
                float r3_z_2 = sqrt(r2_w_4);
                float r2_w_5 = dot(float4(r3_x_4, r3_y_3, r3_z_2, r3_x_4), float4(r3_x_4, r3_y_3, r3_z_2, r3_x_4));
                float r2_w_6 = rsqrt(r2_w_5);
                float4 r3_xyzw_5 = (r2_w_6.xxxx * float4(r3_x_4, r3_y_3, r3_z_2, r3_x_4));
                float r3_x_5 = r3_xyzw_5.x;
                float r3_y_4 = r3_xyzw_5.y;
                float r3_z_3 = r3_xyzw_5.z;
                float r2_w_7 = (unity_ProbeVolumeParams.x == 1);
                float r4_x_10;
                float r4_y_10;
                float r4_z_10;
                float r4_w_4;
                if (r2_w_7)
                {
                    float r2_w_8 = (unity_ProbeVolumeParams.y == 1);
                    float3 r4_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord4.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r2_w_8.xxxx ? r4_xyz_5.xyzx : i.texcoord4.xyzx)).xyz;
                    float4 r4_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r4_y_8 = r4_xyzw_8.y;
                    float r4_z_8 = r4_xyzw_8.z;
                    float r4_w_2 = r4_xyzw_8.w;
                    float r2_w_9 = mad(r4_y_8, 0.25, 0.75);
                    float r3_w_2 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r4_x_8 = max(r2_w_9, r3_w_2);
                    float4 r4_xyzw_9 = t2.Sample(sampler_linear_clamp, (float4(r4_x_8, r4_z_8, r4_w_2, r4_x_8)).xyz);
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
                float r2_w_11 = dot(float4(r4_x_10, r4_y_10, r4_z_10, r4_w_4), unity_OcclusionMaskSelector);
                float r4_x_11 = dot(i.texcoord1.xyzx, float4(r3_x_5, r3_y_4, r3_z_3, r3_x_5));
                float r4_y_11 = dot(i.texcoord2.xyzx, float4(r3_x_5, r3_y_4, r3_z_3, r3_x_5));
                float r4_z_11 = dot(i.texcoord3.xyzx, float4(r3_x_5, r3_y_4, r3_z_3, r3_x_5));
                float4 r3_xyzw_8 = ((rsqrt(dot(float4(r4_x_11, r4_y_11, r4_z_11, r4_x_11), float4(r4_x_11, r4_y_11, r4_z_11, r4_x_11)))).xxxx * float4(r4_x_11, r4_y_11, r4_z_11, r4_x_11));
                float r3_x_8 = r3_xyzw_8.x;
                float r3_y_5 = r3_xyzw_8.y;
                float r3_z_4 = r3_xyzw_8.z;
                float3 r4_xyz_12 = ((r2_w_11.xxxx * _LightColor0.xyzx)).xyz;
                o.sv_Target0.w = mad(r1_w_1, 0.7790837, 0.22091627);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float r0_w_6 = dot(float4(r3_x_8, r3_y_5, r3_z_4, r3_x_8), ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx);
                float r1_x_2 = dot(float4(r3_x_8, r3_y_5, r3_z_4, r3_x_8), _WorldSpaceLightPos0.xyzx);
                float r0_x_4 = dot(_WorldSpaceLightPos0.xyzx, ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyzx);
                float r0_y_4 = dot(r0_x_4.xxxx, r0_x_4.xxxx);
                float r0_y_5 = (r0_y_4 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_y_2 = (r0_z_4 * r0_z_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_z_5 = (r0_z_4 * r1_y_3);
                float r0_z_6 = mad(r0_y_5, r0_z_5, 1);
                float r1_y_4 = (-abs(r0_w_6) + 1);
                float r1_z_2 = (r1_y_4 * r1_y_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r1_y_5 = (r1_y_4 * r1_z_3);
                float r0_y_6 = mad(r0_y_5, r1_y_5, 1);
                float r0_y_7 = (r0_y_6 * r0_z_6);
                float r0_z_7 = (abs(r0_w_6) + r1_x_2);
                float r0_z_8 = (r0_z_7 + 1E-05);
                float r0_z_9 = (0.5 / r0_z_8);
                float r0_z_10 = (r0_z_9 * 0.9999999);
                float r0_z_11 = max(r0_z_10, 0.0001);
                float r0_z_12 = sqrt(r0_z_11);
                float4 r0_xyzw_8 = (r1_x_2.xxxx * float4(r0_y_7, r0_y_7, r0_z_12, r0_y_7));
                float r0_y_8 = r0_xyzw_8.y;
                float r0_z_13 = r0_xyzw_8.z;
                float4 r1_xyzw_3 = (r0_y_8.xxxx * r4_xyz_12.xyzx);
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_6 = r1_xyzw_3.y;
                float r1_z_4 = r1_xyzw_3.z;
                float4 r0_xyzw_9 = (r4_xyz_12.xxyz * r0_z_13.xxxx);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_w_7 = r0_xyzw_9.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_2 = (r0_x_5 * r0_x_5);
                float r1_w_3 = (r1_w_2 * r1_w_2);
                float r0_x_8 = (((mad((r0_x_5 * r1_w_3), 0.7790837, 0.2209163)).xxxx * float4(r0_y_9, r0_z_14, r0_w_7, r0_y_9))).x;
                float4 r0_xyzw_10 = ((mad((r0_x_5 * r1_w_3), 0.7790837, 0.2209163)).xxxx * float4(r0_y_9, r0_z_14, r0_w_7, r0_y_9));
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_15 = r0_xyzw_10.z;
                o.sv_Target0.xyz = (mad(((((r1_w_1.xxxx * r2_xyzw_1.xyzx)).xyzx * float4(0.7790837, 0.7790837, 0.7790837, 0))).xyzx, float4(r1_x_3, r1_y_6, r1_z_4, r1_x_3), float4(r0_x_8, r0_y_10, r0_z_15, r0_x_8))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Transparent" "RenderType"="Transparent" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcColor
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Highatmospherecolor;
                float4 _Lowatmospherecolor;
                float _Outeratmopsheredensity;
                float _Inneratmopsheredensity;
                float _Innerouterlimit;
                float _Inneroutersmoothness;
                float _Outeratmospherelimit;
                float4 _Inneratmosphere;
                float _DisplacementAtmosphere;
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float3 _WorldSpaceCameraPos;
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
            };
            struct program48Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
            };
            struct program48Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
            };
            struct program57Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
            };
            struct program57Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program48Output vert(program48Input i)
            {
                program48Output o = (program48Output)0;
                float4 r0_xyzw_3 = ((rsqrt(dot(i.normal0.xyzx, i.normal0.xyzx))).xxxx * i.normal0.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = (float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3) * _DisplacementAtmosphere.xxxx);
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_2 = r0_xyzw_4.y;
                float r0_z_2 = r0_xyzw_4.z;
                float r0_w_1 = 0;
                float4 r0_xyzw_5 = (float4(r0_x_4, r0_y_2, r0_z_2, r0_w_1) + i.position0.xyzw);
                float4 r1_xyzw_3 = mad(unity_ObjectToWorld[2], r0_xyzw_5.zzzz, mad(unity_ObjectToWorld[0], r0_xyzw_5.xxxx, (r0_xyzw_5.yyyy * unity_ObjectToWorld[1])));
                o.texcoord0.xyzw = mad(unity_ObjectToWorld[3], r0_xyzw_5.wwww, r1_xyzw_3);
                float4 r0_xyzw_6 = (r1_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = mad(unity_MatrixVP[3], r0_xyzw_6.wwww, mad(unity_MatrixVP[2], r0_xyzw_6.zzzz, mad(unity_MatrixVP[0], r0_xyzw_6.xxxx, (r0_xyzw_6.yyyy * unity_MatrixVP[1]))));
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_5 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_5 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_4 = dot(float4(worldNormal_x_7, worldNormal_y_5, worldNormal_z_5, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_5, worldNormal_z_5, worldNormal_x_7));
                float r0_w_5 = rsqrt(r0_w_4);
                o.texcoord1.xyz = ((r0_w_5.xxxx * float4(worldNormal_x_7, worldNormal_y_5, worldNormal_z_5, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program57Output frag(program57Input i)
            {
                program57Output o = (program57Output)0;
                float3 r0_xyz_1 = ((-i.texcoord0.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float r0_x_5 = (max(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0) + 1);
                float r0_y_3 = (-_Inneroutersmoothness + _Innerouterlimit);
                float r0_y_4 = max(r0_y_3, 0);
                float r0_z_3 = (-r0_y_4 + r0_x_5);
                float r0_w_5 = (_Inneroutersmoothness + _Innerouterlimit);
                float r0_w_6 = min(r0_w_5, 1);
                float r0_y_5 = (-r0_y_4 + r0_w_6);
                float r0_y_6 = ((float4(1, 1, 1, 1) / r0_y_5)).y;
                float r0_y_7 = (r0_y_6 * r0_z_3);
                float r0_z_4 = mad(r0_y_7, -2, 3);
                float r0_y_8 = (r0_y_7 * r0_y_7);
                float r0_y_9 = (r0_y_8 * r0_z_4);
                float r0_z_5 = ((float4(1, 1, 1, 1) / _Outeratmospherelimit)).z;
                                float r0_x_9 = (r0_z_5 * pow(r0_x_5, 7));
                float r0_z_6 = mad(r0_x_9, -2, 3);
                float r0_x_10 = (r0_x_9 * r0_x_9);
                float r0_w_7 = (r0_x_10 * r0_z_6);
                float4 r0_xyzw_10 = mad(r0_y_9.xxxx, (((mad(r0_w_7.xxxx, ((_Highatmospherecolor.xyzx + -_Lowatmospherecolor.xyzx)).xyzx, _Lowatmospherecolor.xyzx)).xyzx + -_Inneratmosphere.xyzx)).xxyz, _Inneratmosphere.xxyz);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_7 = r0_xyzw_10.z;
                float r0_w_8 = r0_xyzw_10.w;
                float3 lightDir_xyz_4 = normalize(_WorldSpaceLightPos0);
                float nDotL_x_2 = dot(unitWorldNormal_xyz_1.xyzx, lightDir_xyz_4.xyzx);
                float r1_y_2 = mad(nDotL_x_2, 0.875, 0.125);
                o.sv_Target0.w = (mad(r0_y_9, mad(mad(-r0_z_6, r0_x_10, 1), _Outeratmopsheredensity, -_Inneratmopsheredensity), _Inneratmopsheredensity) * (nDotL_x_2 + nDotL_x_2));
                float4 r1_xyzw_4 = ((max(r1_y_2, 0)).xxxx * _LightColor0.xyzx);
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_3 = r1_xyzw_4.y;
                float r1_z_2 = r1_xyzw_4.z;
                o.sv_Target0.xyz = ((float4(r0_y_10, r0_z_7, r0_w_8, r0_y_10) * float4(r1_x_4, r1_y_3, r1_z_2, r1_x_4))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Offset -1, -1
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4 _Highatmospherecolor;
                float4x4 unity_WorldToObject;
                float _BumpScale;
                float4 _Lowatmospherecolor;
                float _AlphaScale;
                float _DisplacementClouds;
                float4 _MainTex_ST;
                float _Outeratmopsheredensity;
                float _Inneratmopsheredensity;
                float _Innerouterlimit;
                float _Inneroutersmoothness;
                float _Outeratmospherelimit;
                float4 _Inneratmosphere;
                float _DisplacementAtmosphere;
                float4 cb0_values[12];
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
                float4 cb2_values[21];
            };
            SamplerState sampler_linear_clamp : register(s0);
            Texture2D t0 : register(t0);
            struct program63Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
            };
            struct program63Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program72Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program72Output
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
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                o.texcoord0.xyzw = r0_xyzw_4;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_WorldToObject[1].xyzx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[0].xyzx, r0_xyzw_4.zzzz, (mad(unity_ObjectToWorld[2].xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_ObjectToWorld[3].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program72Output frag(program72Input i)
            {
                program72Output o = (program72Output)0;
                float3 r0_xyz_1 = ((-i.texcoord0.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float r0_x_5 = (max(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0) + 1);
                float r0_y_3 = (-cb0_values[9].w + cb0_values[9].z);
                float r0_y_4 = max(r0_y_3, 0);
                float r0_z_3 = (-r0_y_4 + r0_x_5);
                float r0_w_5 = (cb0_values[9].w + cb0_values[9].z);
                float r0_w_6 = min(r0_w_5, 1);
                float r0_y_5 = (-r0_y_4 + r0_w_6);
                float r0_y_6 = ((float4(1, 1, 1, 1) / r0_y_5)).y;
                float r0_y_7 = (r0_y_6 * r0_z_3);
                float r0_z_4 = mad(r0_y_7, -2, 3);
                float r0_y_8 = (r0_y_7 * r0_y_7);
                float r0_y_9 = (r0_y_8 * r0_z_4);
                float r0_z_5 = ((float4(1, 1, 1, 1) / cb0_values[10].x)).z;
                                float r0_x_9 = (r0_z_5 * pow(r0_x_5, 7));
                float r0_z_6 = mad(r0_x_9, -2, 3);
                float r0_x_10 = (r0_x_9 * r0_x_9);
                float r0_w_7 = (r0_x_10 * r0_z_6);
                float4 r0_xyzw_10 = mad(r0_y_9.xxxx, (((mad(r0_w_7.xxxx, ((_Inneratmosphere.xyzx + -cb0_values[8].xyzx)).xyzx, cb0_values[8].xyzx)).xyzx + -cb0_values[11].xyzx)).xxyz, cb0_values[11].xxyz);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_7 = r0_xyzw_10.z;
                float r0_w_8 = r0_xyzw_10.w;
                float3 r2_xyz_4 = (mad(_WorldSpaceLightPos0.wwww, -i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r1_w_1 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float r1_w_2 = rsqrt(r1_w_1);
                float r1_x_2 = dot(unitWorldNormal_xyz_1.xyzx, ((r1_w_2.xxxx * r2_xyz_4.xyzx)).xyzx);
                float r1_y_2 = mad(r1_x_2, 0.875, 0.125);
                float r0_x_14 = (mad(r0_y_9, mad(mad(-r0_z_6, r0_x_10, 1), cb0_values[9].x, -cb0_values[9].y), cb0_values[9].y) * (r1_x_2 + r1_x_2));
                float r1_y_3 = dot(i.texcoord2.xyzx, i.texcoord2.xyzx);
                float4 r2_xyzw_6 = t0.Sample(sampler_linear_clamp, (r1_y_3.xxxx).xy);
                float4 r1_xyzw_4 = (r2_xyzw_6.xxxx * cb0_values[6].xxyz);
                float r1_y_4 = r1_xyzw_4.y;
                float r1_z_2 = r1_xyzw_4.z;
                float r1_w_3 = r1_xyzw_4.w;
                float4 r1_xyzw_5 = (float4(r1_y_4, r1_z_2, r1_w_3, r1_y_4) * (max(r1_y_2, 0)).xxxx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_5 = r1_xyzw_5.y;
                float r1_z_3 = r1_xyzw_5.z;
                float4 r0_xyzw_11 = (float4(r0_y_10, r0_y_10, r0_z_7, r0_w_8) * float4(r1_x_5, r1_x_5, r1_y_5, r1_z_3));
                float r0_y_11 = r0_xyzw_11.y;
                float r0_z_8 = r0_xyzw_11.z;
                float r0_w_9 = r0_xyzw_11.w;
                o.sv_Target0.xyz = ((r0_x_14.xxxx * float4(r0_y_11, r0_z_8, r0_w_9, r0_y_11))).xyz;
                o.sv_Target0.w = 0;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Offset -1, -1
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4 _Highatmospherecolor;
                float4x4 unity_WorldToObject;
                float _BumpScale;
                float4 _Lowatmospherecolor;
                float _AlphaScale;
                float _DisplacementClouds;
                float4 _MainTex_ST;
                float _Outeratmopsheredensity;
                float _Inneratmopsheredensity;
                float _Innerouterlimit;
                float _Inneroutersmoothness;
                float _Outeratmospherelimit;
                float4 _Inneratmosphere;
                float _DisplacementAtmosphere;
                float4 cb0_values[12];
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
                float4 cb2_values[21];
            };
            SamplerState sampler_linear_clamp : register(s0);
            Texture2D t0 : register(t0);
            struct program67Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
            };
            struct program67Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct program76Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct program76Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program67Output vert(program67Input i)
            {
                program67Output o = (program67Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                o.texcoord0.xyzw = r0_xyzw_4;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xy = (mad(unity_WorldToObject[1].xyxx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[0].xyxx, r0_xyzw_4.zzzz, (mad(unity_ObjectToWorld[2].xyxx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_ObjectToWorld[3].xyxx)).xyxx)).xyxx)).xyxx)).xy;
                return o;
            }
            #pragma fragment frag
            program76Output frag(program76Input i)
            {
                program76Output o = (program76Output)0;
                float3 r0_xyz_1 = ((-i.texcoord0.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float r0_x_5 = (max(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0) + 1);
                float r0_y_3 = (-cb0_values[9].w + cb0_values[9].z);
                float r0_y_4 = max(r0_y_3, 0);
                float r0_z_3 = (-r0_y_4 + r0_x_5);
                float r0_w_5 = (cb0_values[9].w + cb0_values[9].z);
                float r0_w_6 = min(r0_w_5, 1);
                float r0_y_5 = (-r0_y_4 + r0_w_6);
                float r0_y_6 = ((float4(1, 1, 1, 1) / r0_y_5)).y;
                float r0_y_7 = (r0_y_6 * r0_z_3);
                float r0_z_4 = mad(r0_y_7, -2, 3);
                float r0_y_8 = (r0_y_7 * r0_y_7);
                float r0_y_9 = (r0_y_8 * r0_z_4);
                float r0_z_5 = ((float4(1, 1, 1, 1) / cb0_values[10].x)).z;
                                float r0_x_9 = (r0_z_5 * pow(r0_x_5, 7));
                float r0_z_6 = mad(r0_x_9, -2, 3);
                float r0_x_10 = (r0_x_9 * r0_x_9);
                float r0_w_7 = (r0_x_10 * r0_z_6);
                float4 r0_xyzw_10 = mad(r0_y_9.xxxx, (((mad(r0_w_7.xxxx, ((_Inneratmosphere.xyzx + -cb0_values[8].xyzx)).xyzx, cb0_values[8].xyzx)).xyzx + -cb0_values[11].xyzx)).xxyz, cb0_values[11].xxyz);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_7 = r0_xyzw_10.z;
                float r0_w_8 = r0_xyzw_10.w;
                float3 r2_xyz_4 = (mad(_WorldSpaceLightPos0.wwww, -i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r1_w_1 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float r1_w_2 = rsqrt(r1_w_1);
                float r1_x_2 = dot(unitWorldNormal_xyz_1.xyzx, ((r1_w_2.xxxx * r2_xyz_4.xyzx)).xyzx);
                float r1_y_2 = mad(r1_x_2, 0.875, 0.125);
                float r0_x_14 = (mad(r0_y_9, mad(mad(-r0_z_6, r0_x_10, 1), cb0_values[9].x, -cb0_values[9].y), cb0_values[9].y) * (r1_x_2 + r1_x_2));
                float4 r2_xyzw_6 = t0.Sample(sampler_linear_clamp, (i.texcoord2.xyxx).xy);
                float4 r1_xyzw_3 = (r2_xyzw_6.wwww * cb0_values[6].xxyz);
                float r1_y_3 = r1_xyzw_3.y;
                float r1_z_2 = r1_xyzw_3.z;
                float r1_w_3 = r1_xyzw_3.w;
                float4 r1_xyzw_5 = (float4(r1_y_3, r1_z_2, r1_w_3, r1_y_3) * (max(r1_y_2, 0)).xxxx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_4 = r1_xyzw_5.y;
                float r1_z_3 = r1_xyzw_5.z;
                float4 r0_xyzw_11 = (float4(r0_y_10, r0_y_10, r0_z_7, r0_w_8) * float4(r1_x_5, r1_x_5, r1_y_4, r1_z_3));
                float r0_y_11 = r0_xyzw_11.y;
                float r0_z_8 = r0_xyzw_11.z;
                float r0_w_9 = r0_xyzw_11.w;
                o.sv_Target0.xyz = ((r0_x_14.xxxx * float4(r0_y_11, r0_z_8, r0_w_9, r0_y_11))).xyz;
                o.sv_Target0.w = 0;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Offset -1, -1
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4 _Highatmospherecolor;
                float4x4 unity_WorldToObject;
                float _BumpScale;
                float4 _Lowatmospherecolor;
                float _AlphaScale;
                float _DisplacementClouds;
                float4 _MainTex_ST;
                float _Outeratmopsheredensity;
                float _Inneratmopsheredensity;
                float _Innerouterlimit;
                float _Inneroutersmoothness;
                float _Outeratmospherelimit;
                float4 _Inneratmosphere;
                float _DisplacementAtmosphere;
                float4 cb0_values[12];
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
                float4 cb2_values[21];
            };
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_linear_clamp1 : register(s1);
            Texture2D t0 : register(t0);
            TextureCube t1 : register(t1);
            struct program66Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
            };
            struct program66Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program75Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program75Output
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
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                o.texcoord0.xyzw = r0_xyzw_4;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_WorldToObject[1].xyzx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[0].xyzx, r0_xyzw_4.zzzz, (mad(unity_ObjectToWorld[2].xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_ObjectToWorld[3].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program75Output frag(program75Input i)
            {
                program75Output o = (program75Output)0;
                float3 r0_xyz_1 = ((-i.texcoord0.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float r0_x_5 = (max(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0) + 1);
                float r0_y_3 = (-cb0_values[9].w + cb0_values[9].z);
                float r0_y_4 = max(r0_y_3, 0);
                float r0_z_3 = (-r0_y_4 + r0_x_5);
                float r0_w_5 = (cb0_values[9].w + cb0_values[9].z);
                float r0_w_6 = min(r0_w_5, 1);
                float r0_y_5 = (-r0_y_4 + r0_w_6);
                float r0_y_6 = ((float4(1, 1, 1, 1) / r0_y_5)).y;
                float r0_y_7 = (r0_y_6 * r0_z_3);
                float r0_z_4 = mad(r0_y_7, -2, 3);
                float r0_y_8 = (r0_y_7 * r0_y_7);
                float r0_y_9 = (r0_y_8 * r0_z_4);
                float r0_z_5 = ((float4(1, 1, 1, 1) / cb0_values[10].x)).z;
                                float r0_x_9 = (r0_z_5 * pow(r0_x_5, 7));
                float r0_z_6 = mad(r0_x_9, -2, 3);
                float r0_x_10 = (r0_x_9 * r0_x_9);
                float r0_w_7 = (r0_x_10 * r0_z_6);
                float4 r0_xyzw_10 = mad(r0_y_9.xxxx, (((mad(r0_w_7.xxxx, ((_Inneratmosphere.xyzx + -cb0_values[8].xyzx)).xyzx, cb0_values[8].xyzx)).xyzx + -cb0_values[11].xyzx)).xxyz, cb0_values[11].xxyz);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_7 = r0_xyzw_10.z;
                float r0_w_8 = r0_xyzw_10.w;
                float3 r2_xyz_4 = (mad(_WorldSpaceLightPos0.wwww, -i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r1_w_1 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float r1_w_2 = rsqrt(r1_w_1);
                float r1_x_2 = dot(unitWorldNormal_xyz_1.xyzx, ((r1_w_2.xxxx * r2_xyz_4.xyzx)).xyzx);
                float r1_y_2 = mad(r1_x_2, 0.875, 0.125);
                float r0_x_14 = (mad(r0_y_9, mad(mad(-r0_z_6, r0_x_10, 1), cb0_values[9].x, -cb0_values[9].y), cb0_values[9].y) * (r1_x_2 + r1_x_2));
                float r1_y_3 = dot(i.texcoord2.xyzx, i.texcoord2.xyzx);
                float4 r2_xyzw_6 = t0.Sample(sampler_linear_clamp1, (r1_y_3.xxxx).xy);
                float4 r3_xyzw_1 = t1.Sample(sampler_linear_clamp, i.texcoord2.xyz);
                float r1_y_4 = (r2_xyzw_6.x * r3_xyzw_1.w);
                float4 r1_xyzw_5 = (r1_y_4.xxxx * cb0_values[6].xxyz);
                float r1_y_5 = r1_xyzw_5.y;
                float r1_z_2 = r1_xyzw_5.z;
                float r1_w_3 = r1_xyzw_5.w;
                float r1_x_5 = ((float4(r1_y_5, r1_z_2, r1_w_3, r1_y_5) * (max(r1_y_2, 0)).xxxx)).x;
                float4 r1_xyzw_6 = (float4(r1_y_5, r1_z_2, r1_w_3, r1_y_5) * (max(r1_y_2, 0)).xxxx);
                float r1_y_6 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                float4 r0_xyzw_11 = (float4(r0_y_10, r0_y_10, r0_z_7, r0_w_8) * float4(r1_x_5, r1_x_5, r1_y_6, r1_z_3));
                float r0_y_11 = r0_xyzw_11.y;
                float r0_z_8 = r0_xyzw_11.z;
                float r0_w_9 = r0_xyzw_11.w;
                o.sv_Target0.xyz = ((r0_x_14.xxxx * float4(r0_y_11, r0_z_8, r0_w_9, r0_y_11))).xyz;
                o.sv_Target0.w = 0;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Offset -1, -1
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4 _Highatmospherecolor;
                float4x4 unity_WorldToObject;
                float _BumpScale;
                float4 _Lowatmospherecolor;
                float _AlphaScale;
                float _DisplacementClouds;
                float4 _MainTex_ST;
                float _Outeratmopsheredensity;
                float _Inneratmopsheredensity;
                float _Innerouterlimit;
                float _Inneroutersmoothness;
                float _Outeratmospherelimit;
                float4 _Inneratmosphere;
                float _DisplacementAtmosphere;
                float4 cb0_values[12];
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
                float4 cb2_values[21];
            };
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_linear_clamp1 : register(s1);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            struct program65Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
            };
            struct program65Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
            };
            struct program74Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
            };
            struct program74Output
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
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                o.texcoord0.xyzw = r0_xyzw_4;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float4 r1_xyzw_3 = (r0_xyzw_4.yyyy * unity_ObjectToWorld[3]);
                float4 r1_xyzw_4 = mad(unity_ObjectToWorld[2], r0_xyzw_4.xxxx, r1_xyzw_3);
                float4 r1_xyzw_5 = mad(unity_WorldToObject[0], r0_xyzw_4.zzzz, r1_xyzw_4);
                o.texcoord2.xyzw = mad(unity_WorldToObject[1], r0_xyzw_4.wwww, r1_xyzw_5);
                return o;
            }
            #pragma fragment frag
            program74Output frag(program74Input i)
            {
                program74Output o = (program74Output)0;
                float4 r0_xyzw_3 = t0.Sample(sampler_linear_clamp, (((((i.texcoord2.xyxx / i.texcoord2.wwww)).xyxx + float4(0.5, 0.5, 0, 0))).xyxx).xy);
                float r0_y_4 = dot(i.texcoord2.xyzx, i.texcoord2.xyzx);
                float4 r1_xyzw_1 = t1.Sample(sampler_linear_clamp1, (r0_y_4.xxxx).xy);
                float4 r0_xyzw_8 = ((((r0_xyzw_3.w * asfloat(asint((float)((0 < i.texcoord2.z))) & asint(1065353216))) * r1_xyzw_1.x)).xxxx * cb0_values[6].xyzx);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_5 = r0_xyzw_8.y;
                float r0_z_2 = r0_xyzw_8.z;
                float3 r1_xyz_2 = (mad(_WorldSpaceLightPos0.wwww, -i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_2 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_3 = rsqrt(r0_w_2);
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float r0_w_6 = dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_3.xxxx * r1_xyz_2.xyzx)).xyzx);
                float r0_w_7 = (r0_w_6 + r0_w_6);
                float4 r0_xyzw_9 = (float4(r0_x_8, r0_y_5, r0_z_2, r0_x_8) * (max(mad(r0_w_6, 0.875, 0.125), 0)).xxxx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_6 = r0_xyzw_9.y;
                float r0_z_3 = r0_xyzw_9.z;
                float4 r1_xyzw_6 = (-i.texcoord0.xyzx + _WorldSpaceCameraPos.xyzx);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_4 = r1_xyzw_6.z;
                float r1_w_2 = dot(float4(r1_x_6, r1_y_4, r1_z_4, r1_x_6), float4(r1_x_6, r1_y_4, r1_z_4, r1_x_6));
                float r1_w_3 = rsqrt(r1_w_2);
                float4 r1_xyzw_7 = (r1_w_3.xxxx * float4(r1_x_6, r1_y_4, r1_z_4, r1_x_6));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_5 = r1_xyzw_7.y;
                float r1_z_5 = r1_xyzw_7.z;
                float r1_x_10 = (max(dot(unitWorldNormal_xyz_1.xyzx, float4(r1_x_7, r1_y_5, r1_z_5, r1_x_7)), 0) + 1);
                float r1_y_6 = (-cb0_values[9].w + cb0_values[9].z);
                float r1_y_7 = max(r1_y_6, 0);
                float r1_z_6 = (-r1_y_7 + r1_x_10);
                float r1_w_4 = (cb0_values[9].w + cb0_values[9].z);
                float r1_w_5 = min(r1_w_4, 1);
                float r1_y_8 = (-r1_y_7 + r1_w_5);
                float r1_y_9 = ((float4(1, 1, 1, 1) / r1_y_8)).y;
                float r1_y_10 = (r1_y_9 * r1_z_6);
                float r1_z_7 = mad(r1_y_10, -2, 3);
                float r1_y_11 = (r1_y_10 * r1_y_10);
                float r1_y_12 = (r1_y_11 * r1_z_7);
                float r1_z_8 = ((float4(1, 1, 1, 1) / cb0_values[10].x)).z;
                                float r1_x_14 = (r1_z_8 * pow(r1_x_10, 7));
                float r1_z_9 = mad(r1_x_14, -2, 3);
                float r1_x_15 = (r1_x_14 * r1_x_14);
                float r1_w_6 = (r1_x_15 * r1_z_9);
                float r0_w_8 = (r0_w_7 * mad(r1_y_12, mad(mad(-r1_z_9, r1_x_15, 1), cb0_values[9].x, -cb0_values[9].y), cb0_values[9].y));
                float4 r1_xyzw_19 = mad(r1_w_6.xxxx, ((_Inneratmosphere.xyzx + -cb0_values[8].xyzx)).xxyz, cb0_values[8].xxyz);
                float r1_x_19 = r1_xyzw_19.x;
                float r1_z_10 = r1_xyzw_19.z;
                float r1_w_7 = r1_xyzw_19.w;
                float4 r1_xyzw_20 = (float4(r1_x_19, r1_x_19, r1_z_10, r1_w_7) + -cb0_values[11].xxyz);
                float r1_x_20 = r1_xyzw_20.x;
                float r1_z_11 = r1_xyzw_20.z;
                float r1_w_8 = r1_xyzw_20.w;
                float4 r1_xyzw_21 = mad(r1_y_12.xxxx, float4(r1_x_20, r1_z_11, r1_w_8, r1_x_20), cb0_values[11].xyzx);
                float r1_x_21 = r1_xyzw_21.x;
                float r1_y_13 = r1_xyzw_21.y;
                float r1_z_12 = r1_xyzw_21.z;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_y_6, r0_z_3, r0_x_9) * float4(r1_x_21, r1_y_13, r1_z_12, r1_x_21));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_7 = r0_xyzw_10.y;
                float r0_z_4 = r0_xyzw_10.z;
                o.sv_Target0.xyz = ((r0_w_8.xxxx * float4(r0_x_10, r0_y_7, r0_z_4, r0_x_10))).xyz;
                o.sv_Target0.w = 0;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Offset -1, -1
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4 _Highatmospherecolor;
                float4x4 unity_WorldToObject;
                float _BumpScale;
                float4 _Lowatmospherecolor;
                float _AlphaScale;
                float _DisplacementClouds;
                float4 _MainTex_ST;
                float _Outeratmopsheredensity;
                float _Inneratmopsheredensity;
                float _Innerouterlimit;
                float _Inneroutersmoothness;
                float _Outeratmospherelimit;
                float4 _Inneratmosphere;
                float _DisplacementAtmosphere;
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
            };
            cbuffer UnityLighting : register(b2)
            {
                float4 _WorldSpaceLightPos0;
            };
            struct program64Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
            };
            struct program64Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
            };
            struct program73Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
            };
            struct program73Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program64Output vert(program64Input i)
            {
                program64Output o = (program64Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.texcoord0.xyzw = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program73Output frag(program73Input i)
            {
                program73Output o = (program73Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord0.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float3 unitViewDir_xyz_2 = normalize(viewDir_xyz_1);
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float nDotV_x_3 = dot(unitWorldNormal_xyz_1.xyzx, unitViewDir_xyz_2.xyzx);
                float r0_x_5 = (max(nDotV_x_3, 0) + 1);
                float r0_y_3 = (-_Inneroutersmoothness + _Innerouterlimit);
                float r0_y_4 = max(r0_y_3, 0);
                float r0_z_3 = (-r0_y_4 + r0_x_5);
                float r0_w_5 = (_Inneroutersmoothness + _Innerouterlimit);
                float r0_w_6 = min(r0_w_5, 1);
                float r0_y_5 = (-r0_y_4 + r0_w_6);
                float r0_y_6 = ((float4(1, 1, 1, 1) / r0_y_5)).y;
                float r0_y_7 = (r0_y_6 * r0_z_3);
                float r0_z_4 = mad(r0_y_7, -2, 3);
                float r0_y_8 = (r0_y_7 * r0_y_7);
                float r0_y_9 = (r0_y_8 * r0_z_4);
                float r0_z_5 = ((float4(1, 1, 1, 1) / _Outeratmospherelimit)).z;
                                float r0_x_9 = (r0_z_5 * pow(r0_x_5, 7));
                float r0_z_6 = mad(r0_x_9, -2, 3);
                float r0_x_10 = (r0_x_9 * r0_x_9);
                float r0_w_7 = (r0_x_10 * r0_z_6);
                float4 r0_xyzw_10 = mad(r0_y_9.xxxx, (((mad(r0_w_7.xxxx, ((_Highatmospherecolor.xyzx + -_Lowatmospherecolor.xyzx)).xyzx, _Lowatmospherecolor.xyzx)).xyzx + -_Inneratmosphere.xyzx)).xxyz, _Inneratmosphere.xxyz);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_7 = r0_xyzw_10.z;
                float r0_w_8 = r0_xyzw_10.w;
                float3 r2_xyz_4 = (mad(_WorldSpaceLightPos0.wwww, -i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r1_w_1 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float r1_w_2 = rsqrt(r1_w_1);
                float r1_x_2 = dot(unitWorldNormal_xyz_1.xyzx, ((r1_w_2.xxxx * r2_xyz_4.xyzx)).xyzx);
                float r1_y_2 = mad(r1_x_2, 0.875, 0.125);
                float r0_x_14 = (mad(r0_y_9, mad(mad(-r0_z_6, r0_x_10, 1), _Outeratmopsheredensity, -_Inneratmopsheredensity), _Inneratmopsheredensity) * (r1_x_2 + r1_x_2));
                float4 r1_xyzw_5 = ((max(r1_y_2, 0)).xxxx * _LightColor0.xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_3 = r1_xyzw_5.y;
                float r1_z_2 = r1_xyzw_5.z;
                float4 r0_xyzw_11 = (float4(r0_y_10, r0_y_10, r0_z_7, r0_w_8) * float4(r1_x_5, r1_x_5, r1_y_3, r1_z_2));
                float r0_y_11 = r0_xyzw_11.y;
                float r0_z_8 = r0_xyzw_11.z;
                float r0_w_9 = r0_xyzw_11.w;
                o.sv_Target0.xyz = ((r0_x_14.xxxx * float4(r0_y_11, r0_z_8, r0_w_9, r0_y_11))).xyz;
                o.sv_Target0.w = 0;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Diffuse"
}
