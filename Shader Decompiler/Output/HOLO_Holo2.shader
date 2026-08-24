Shader "HOLO/Holo2"
{
    Properties
    {
        _MainTex ("Not used confusing", 2D) = "" {}
        _originalDiffuse ("Original Diffuse Map", 2D) = "" {}
        _Diffuse ("Diffuse Map", 2D) = "" {}
        _diff_Color ("Diffuse Color Mult", Color) = (1,1,1,1)
        _N_map ("Noise", 2D) = "" {}
        _M_map ("Mask", 2D) = "" {}
        [Toggle]
        _mask_type ("Use Map as Mask", Float) = 1
        _intensity ("Intensity", Float) = 0
        _deform ("Deformation Intensity", Float) = 1
        _Color ("Outline Color Mult", Color) = (1,1,1,1)
        _Opacity ("Base Opacity", Range(0, 1)) = 0
        _Bias ("Bias", Range(0, 1)) = 0
        _Scale ("Scale ", Range(0, 10)) = 0
        _Power ("Power", Range(0, 3)) = 0
        _Speed ("Speed", Range(0, 1)) = 0
        _t ("Extra Option", Range(0, 1)) = 0
        _noise_details ("G/H Noise Details Amount ", Range(1, 16)) = 0
        [Toggle]
        _X ("Active X Axe", Float) = 1
        [Toggle]
        _Y ("Active X Axe", Float) = 1
        [Toggle]
        _glitchColor ("Display G/H Color", Float) = 1
        [Toggle]
        _monochrom ("Monochromatic", Float) = 1
        [Toggle]
        _OriginalUVSwitch ("Switch to Orginal UVs on/off", Float) = 0
        _Distance ("Distance", Float) = 0
        _Amplitude ("Amplitude", Float) = 0
        _Speed_Up ("_Speed_Up", Float) = 0
        _Amount ("Amount", Range(0, 1)) = 0
        _cut_level ("Cut Level", Range(0, 1)) = 0
    }
    SubShader
    {
        Tags { "IGNOREPROJECTOR"="true" "QUEUE"="Transparent" "RenderType"="Transparent" }
        LOD 0
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite On
            Blend SrcAlpha OneMinusSrcColor
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _Color;
                float4 _diff_Color;
                float4 _Diffuse_ST;
                float4 _N_map_ST;
                float4 _M_map_ST;
                float _intensity;
                float _deform;
                float _Bias;
                float _Scale;
                float _Power;
                float _Speed;
                float _t;
                float _X;
                float _Y;
                float _glitchColor;
                float _monochrom;
                float _Opacity;
                float _noise_details;
                float _Distance;
                float _Amplitude;
                float _Speed_Up;
                float _Amount;
                float _OriginalUVSwitch;
                float4 cb0_values[8];
            };
            cbuffer UnityPerCamera : register(b1)
            {
                float4 _Time;
                float3 _WorldSpaceCameraPos;
            };
            cbuffer UnityPerDraw : register(b2)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
            };
            cbuffer UnityPerFrame : register(b3)
            {
                float4x4 unity_MatrixV;
                float4x4 unity_MatrixVP;
            };
            SamplerState sampler_MainTex : register(s0);
            Texture2D _MainTex : register(t0);
            SamplerState sampler_Diffuse : register(s1);
            SamplerState sampler_MainTex2 : register(s2);
            SamplerState sampler_originalDiffuse : register(s3);
            Texture2D _originalDiffuse : register(t1);
            Texture2D _Diffuse : register(t2);
            Texture2D _N_map : register(t3);
            struct program1Input
            {
                float4 position0 : POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 normal0 : NORMAL0;
            };
            struct program1Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 normal0 : NORMAL0;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 normal0 : NORMAL0;
                float4 texcoord6 : TEXCOORD6;
                uint sv_Isfrontface0 : SV_IsFrontFace0;
            };
            struct program3Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program1Output vert(program1Input i)
            {
                program1Output o = (program1Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4x4 objectToView = mul(unity_ObjectToWorld, unity_MatrixV);
                float r0_w_1 = (_Speed * _Time.x);
                float r0_w_2 = (r0_w_1 * 60);
                float r0_w_3 = (sin(r0_w_2) * _M_map_ST.y);
                float r1_w_1 = (cos(r0_w_2) * _M_map_ST.w);
                float4 uvMMap_xyzw_2 = mad(i.texcoord0.xyxx, r0_w_3.xxxx, r1_w_1.xxxx);
                float uvMMap_x_2 = uvMMap_xyzw_2.x;
                float uvMMap_y_1 = uvMMap_xyzw_2.y;
                float4 sampleMMap_xyzw_3 = _MainTex.SampleLevel(sampler_MainTex, (float4(uvMMap_x_2, uvMMap_y_1, uvMMap_x_2, uvMMap_x_2)).xy, 0);
                float r0_w_4 = (int)(_noise_details);
                float4 r4_xyzw_3 = (_Time.xxyx * float4(0, 0.1, 0.1, 0));
                float r4_y_3 = r4_xyzw_3.y;
                float r4_z_2 = r4_xyzw_3.z;
                float TEXCOORD0_x_2 = (i.texcoord0.xyxx).x;
                float TEXCOORD0_y_1 = (i.texcoord0.xyxx).y;
                float2 r5_zw_1 = (float4(0, 0, 0, 0)).zw;
                float r1_w_2 = r0_w_4;
                float3 r5_yzw_2 = float3(TEXCOORD0_y_1, r5_zw_1.x, r5_zw_1.y);
                float r1_w_3 = r1_w_2;
                float r5_x_3 = TEXCOORD0_x_2;
                float r2_w_1;
                float2 r6_xy_3;
                float2 r6_zw_3;
                float2 noiseAccum_zw_3;
                float r5_x_5;
                float r5_y_4;
                float r1_w_7;
                [loop]
                while (true)
                {
                    r2_w_1 = (0 >= r1_w_3);
                    if (r2_w_1) break;
                    r6_xy_3 = (floor(float4(r5_x_3, r5_yzw_2.x, r5_x_3, r5_x_3))).xy;
                    r6_zw_3 = ((float4(r4_y_3, r4_y_3, r4_y_3, r4_z_2) * r6_xy_3.xxxy)).zw;
                    noiseAccum_zw_3 = ((r5_yzw_2.yyyz + (sin((mad(r6_xy_3.xxxx, r6_xy_3.yyyy, r6_zw_3.xyxx)).xyxx)).xxxy)).zw;
                    float4 r5_xyzw_5 = (float4(r5_x_3, r5_yzw_2.x, r5_x_3, r5_x_3) * float4(2.5, 2.5, 0, 0));
                    r5_x_5 = r5_xyzw_5.x;
                    r5_y_4 = r5_xyzw_5.y;
                    r1_w_7 = (r1_w_3 + -1);
                    r5_yzw_2 = float3(r5_y_4, noiseAccum_zw_3.x, noiseAccum_zw_3.y);
                    r1_w_3 = r1_w_7;
                    r5_x_3 = r5_x_5;
                }
                float4 r4_xyzw_4 = (cb0_values[7].yyxy * float4(0, 0.001, 0.1, 0));
                float r4_y_4 = r4_xyzw_4.y;
                float r4_z_3 = r4_xyzw_4.z;
                float4 r4_xyzw_5 = (r4_y_4.xxxx * r5_yzw_2.yyyz);
                float r4_y_5 = r4_xyzw_5.y;
                float r4_w_2 = r4_xyzw_5.w;
                float4 r4_xyzw_6 = (r4_z_3.xxxx * float4(r4_y_5, r4_y_5, r4_w_2, r4_y_5));
                float r4_y_6 = r4_xyzw_6.y;
                float r4_z_4 = r4_xyzw_6.z;
                float r4_x_4 = ((sampleMMap_xyzw_3.xxxx * float4(r4_y_6, r4_z_4, r4_y_6, r4_y_6))).x;
                float r4_y_7 = ((sampleMMap_xyzw_3.xxxx * float4(r4_y_6, r4_z_4, r4_y_6, r4_y_6))).y;
                float r0_w_5 = (i.position0.y * _Y);
                float r0_w_6 = mad(_Time.y, _Speed_Up, r0_w_5);
                float r1_w_4 = (i.position0.x * _X);
                float r0_w_7 = mad(r1_w_4, _Amplitude, r0_w_6);
                float r0_w_8 = sin(r0_w_7);
                float r0_w_9 = (r0_w_8 * _Distance);
                float r0_w_10 = (r0_w_9 * _Amount);
                float r1_w_5 = (r0_w_10 * _X);
                float r1_w_6 = (r4_x_4 * r1_w_5);
                float r5_x_4 = mad(r1_w_6, i.normal0.x, i.position0.x);
                float r0_w_11 = (r0_w_10 * _Y);
                float r0_w_12 = (r4_y_7 * r0_w_11);
                float r5_y_3 = mad(r0_w_12, i.normal0.y, i.position0.y);
                float r4_x_5 = ((r5_y_3.xxxx * unity_ObjectToWorld[1])).x;
                float4 r4_xyzw_8 = (r5_y_3.xxxx * unity_ObjectToWorld[1]);
                float r4_y_8 = r4_xyzw_8.y;
                float r4_z_5 = r4_xyzw_8.z;
                float r4_w_3 = r4_xyzw_8.w;
                float r4_x_6 = (mad(unity_ObjectToWorld[0], r5_x_4.xxxx, float4(r4_x_5, r4_y_8, r4_z_5, r4_w_3))).x;
                float4 r4_xyzw_9 = mad(unity_ObjectToWorld[0], r5_x_4.xxxx, float4(r4_x_5, r4_y_8, r4_z_5, r4_w_3));
                float r4_y_9 = r4_xyzw_9.y;
                float r4_z_6 = r4_xyzw_9.z;
                float r4_w_4 = r4_xyzw_9.w;
                float4 worldPos_xyzw_7 = mad(unity_ObjectToWorld[2], i.position0.zzzz, float4(r4_x_6, r4_y_9, r4_z_6, r4_w_4));
                float4 r6_xyzw_2 = (worldPos_xyzw_7 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(r6_xyzw_2);
                float4 worldPos_xyzw_8 = mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_7.xyzx);
                float worldPos_x_8 = worldPos_xyzw_8.x;
                float worldPos_y_11 = worldPos_xyzw_8.y;
                float worldPos_z_8 = worldPos_xyzw_8.z;
                float3 viewNormal_xyz_5 = (mad(objectToView[0].xyz.xyzx, i.normal0.xxxx, ((objectToView[1].xyz.xyzx * i.normal0.yyyy)).xyzx)).xyz;
                float3 viewNormal_xyz_6 = (mad(objectToView[2].xyz.xyzx, i.normal0.zzzz, viewNormal_xyz_5.xyzx)).xyz;
                float3 viewNormal_xyz_7 = (mad(objectToView[3].xyz.xyzx, i.normal0.wwww, viewNormal_xyz_6.xyzx)).xyz;
                float2 unitViewNormal_xy_8 = normalize(viewNormal_xyz_7);
                float worldNormal_x_6 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_6 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_6 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_z_10 = dot(float4(worldNormal_x_6, worldNormal_y_6, worldNormal_z_6, worldNormal_x_6), float4(worldNormal_x_6, worldNormal_y_6, worldNormal_z_6, worldNormal_x_6));
                float r0_z_11 = rsqrt(r0_z_10);
                float3 unitWorldNormal_xyz_7 = ((r0_z_11.xxxx * float4(worldNormal_x_6, worldNormal_y_6, worldNormal_z_6, worldNormal_x_6))).xyz;
                o.texcoord2.xy = (mad(unitViewNormal_xy_8.xyxx, float4(0.5, 0.5, 0, 0), float4(0.5, 0.5, 0, 0))).xy;
                float4 dirToSurface_xyzw_9 = (float4(worldPos_x_8, worldPos_y_11, worldPos_z_8, worldPos_x_8) + -_WorldSpaceCameraPos.xyzx);
                float dirToSurface_x_9 = dirToSurface_xyzw_9.x;
                float dirToSurface_y_9 = dirToSurface_xyzw_9.y;
                float dirToSurface_z_12 = dirToSurface_xyzw_9.z;
                float r0_w_13 = dot(float4(dirToSurface_x_9, dirToSurface_y_9, dirToSurface_z_12, dirToSurface_x_9), float4(dirToSurface_x_9, dirToSurface_y_9, dirToSurface_z_12, dirToSurface_x_9));
                float r0_w_14 = rsqrt(r0_w_13);
                float4 unitDirToSurface_xyzw_10 = (r0_w_14.xxxx * float4(dirToSurface_x_9, dirToSurface_y_9, dirToSurface_z_12, dirToSurface_x_9));
                float unitDirToSurface_x_10 = unitDirToSurface_xyzw_10.x;
                float unitDirToSurface_y_10 = unitDirToSurface_xyzw_10.y;
                float unitDirToSurface_z_13 = unitDirToSurface_xyzw_10.z;
                float nDotV_x_11 = dot(float4(unitDirToSurface_x_10, unitDirToSurface_y_10, unitDirToSurface_z_13, unitDirToSurface_x_10), unitWorldNormal_xyz_7.xyzx);
                float r0_y_11 = (_Scale * _Bias);
                                float fresnel_x_15 = pow((nDotV_x_11 + _t), _Power);
                o.texcoord4.x = (fresnel_x_15 * r0_y_11);
                o.texcoord0.xyzw = i.texcoord0.xyzw;
                o.texcoord1.xyzw = float4(0, 0, 0, 0);
                o.texcoord4.yzw = (float4(0, 0, 0, 0)).yzw;
                o.normal0.xyzw = float4(0, 0, 0, 0);
                o.texcoord6.zw = (i.position0.zzzw).zw;
                o.texcoord6.xy = (float4(r5_x_4, r5_y_3, r5_x_4, r5_x_4)).xy;
                o.texcoord2.z = 0;
                o.texcoord3.xyz = unitWorldNormal_xyz_7.xyz;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float4 r0_xyzw_2 = (((_Speed * _Time.x)).xxxx * float4(30, 60, 120, 0));
                float r0_x_2 = r0_xyzw_2.x;
                float r0_y_1 = r0_xyzw_2.y;
                float r0_z_1 = r0_xyzw_2.z;
                float r1_x_1 = sin(r0_y_1);
                float r0_y_2 = ((r0_x_2.xxxx * _N_map_ST.zzzw)).y;
                float r0_w_1 = ((r0_x_2.xxxx * _N_map_ST.zzzw)).w;
                float4 uvNMap_xyzw_3 = mad(i.texcoord0.xxxy, _N_map_ST.xxxy, float4(r0_y_2, r0_y_2, r0_y_2, r0_w_1));
                float uvNMap_y_3 = uvNMap_xyzw_3.y;
                float uvNMap_w_2 = uvNMap_xyzw_3.w;
                float4 sampleNMap_xyzw_1 = _MainTex.Sample(sampler_MainTex2, (float4(uvNMap_y_3, uvNMap_w_2, uvNMap_y_3, uvNMap_y_3)).xy);
                float r0_y_4 = (r1_x_1 * _M_map_ST.y);
                float r0_w_3 = (cos(r0_y_1) * _M_map_ST.w);
                float4 uvMMap_xyzw_5 = mad(i.texcoord0.xxxy, r0_y_4.xxxx, r0_w_3.xxxx);
                float uvMMap_y_5 = uvMMap_xyzw_5.y;
                float uvMMap_w_4 = uvMMap_xyzw_5.w;
                float4 sampleMMap_xyzw_2 = _originalDiffuse.Sample(sampler_originalDiffuse, (float4(uvMMap_y_5, uvMMap_w_4, uvMMap_y_5, uvMMap_y_5)).xy);
                float4 r0_xyzw_6 = (_OriginalUVSwitch.xxxx == float4(0, 0, 0, 1));
                float r0_y_6 = r0_xyzw_6.y;
                float r0_w_5 = r0_xyzw_6.w;
                float4 sampleDiffuse_xyzw_3;
                if (r0_y_6)
                {
                    float2 uvDiffuse_yz_1 = (mad(i.texcoord2.xxyx, _Diffuse_ST.yyyy, _Diffuse_ST.wwww)).yz;
                    float4 sampleDiffuse_xyzw_2 = _Diffuse.Sample(sampler_Diffuse, (uvDiffuse_yz_1.xyxx).xy);
                    sampleDiffuse_xyzw_3 = sampleDiffuse_xyzw_2;
                }
                else
                {
                    sampleDiffuse_xyzw_3 = float4(0, 0, 0, 0);
                }
                float4 sampleDiffuse_xyzw_5 = sampleDiffuse_xyzw_3;
                if (r0_w_5)
                {
                    float4 r4_xyzw_4 = _N_map.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                    sampleDiffuse_xyzw_5 = r4_xyzw_4;
                }
                float r0_y_7 = (sampleMMap_xyzw_2.x * sampleNMap_xyzw_1.x);
                float4 r0_xyzw_3 = sin(float4(r0_x_2, r0_x_2, r0_z_1, r0_x_2));
                float r0_x_3 = r0_xyzw_3.x;
                float r0_z_2 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = (float4(r0_x_3, r0_x_3, r0_z_2, r0_x_3) * r0_y_7.xxxx);
                float r0_x_4 = r0_xyzw_4.x;
                float r0_z_3 = r0_xyzw_4.z;
                float r0_w_6 = (r0_x_4 * i.texcoord0.x);
                float2 r1_yz_3 = (mad(r0_w_6.xxxx, _intensity.xxxx, i.texcoord0.xxyx)).yz;
                float r0_w_7 = (r1_yz_3.y * _Amplitude);
                float r0_w_8 = mad(_Time.y, _Speed_Up, r0_w_7);
                float r0_w_9 = sin(r0_w_8);
                float r0_w_10 = (r0_w_9 * _Distance);
                float r0_w_11 = (r0_w_10 * _Amount);
                float r1_w_1 = (int)(_noise_details);
                float4 r2_xyzw_3 = (_Time.xyxx * float4(0.1, 0.1, 0, 0));
                float r2_x_3 = r2_xyzw_3.x;
                float r2_y_2 = r2_xyzw_3.y;
                float2 r2_zw_2 = (r1_yz_3.xxxy).zw;
                float2 r3_xy_2 = (float4(0, 0, 0, 0)).xy;
                float r3_z_2 = r1_w_1;
                float2 r2_zw_3 = r2_zw_2.xy;
                float3 r3_xyz_3 = float3(r3_xy_2.x, r3_xy_2.y, r3_z_2);
                float r3_w_3;
                float2 r5_xy_1;
                float2 r5_zw_1;
                float2 noiseAccum_xy_4;
                float2 r2_zw_4;
                float r3_z_4;
                [loop]
                while (true)
                {
                    r3_w_3 = (0 >= r3_xyz_3.z);
                    if (r3_w_3) break;
                    r5_xy_1 = (floor(r2_zw_3.xyxx)).xy;
                    r5_zw_1 = ((float4(r2_x_3, r2_x_3, r2_x_3, r2_y_2) * r5_xy_1.xxxy)).zw;
                    noiseAccum_xy_4 = ((r3_xyz_3.xyxx + (sin((mad(r5_xy_1.xxxx, r5_xy_1.yyyy, r5_zw_1.xyxx)).xyxx)).xyxx)).xy;
                    r2_zw_4 = ((r2_zw_3.xxxy * float4(0, 0, 2.5, 2.5))).zw;
                    r3_z_4 = (r3_xyz_3.z + -1);
                    r2_zw_3 = r2_zw_4.xy;
                    r3_xyz_3 = float3(noiseAccum_xy_4.x, noiseAccum_xy_4.y, r3_z_4);
                }
                float2 r1_yz_4 = ((r3_xyz_3.xxyx * _glitchColor.xxxx)).yz;
                float2 r1_yz_5 = ((r0_w_11.xxxx * r1_yz_4.xxyx)).yz;
                float4 r0_xyzw_5 = (float4(r0_x_4, r0_y_7, r0_z_3, r0_x_4) * float4(r1_yz_5.x, r1_x_1, r1_yz_5.x, r1_yz_5.x));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_8 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float r0_y_9 = (r1_yz_5.y * r0_y_8);
                float r0_x_6 = ((float4(r0_x_5, r0_y_9, r0_z_4, r0_x_5) * _intensity.xxxx)).x;
                float4 r0_xyzw_10 = (float4(r0_x_5, r0_y_9, r0_z_4, r0_x_5) * _intensity.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_5 = r0_xyzw_10.z;
                float r1_y_6 = mad(r0_y_10, 0.375, _Color.y);
                float4 r1_xyzw_2 = mad(float4(r0_x_6, r0_x_6, r0_z_5, r0_x_6), float4(0.1875, 0, 0.75, 0), _Color.xxzx);
                float r1_x_2 = r1_xyzw_2.x;
                float r1_z_6 = r1_xyzw_2.z;
                float r4_w_6 = (sampleDiffuse_xyzw_5.w * _Opacity);
                float4 r0_xyzw_7 = (float4(sampleDiffuse_xyzw_5.x, sampleDiffuse_xyzw_5.y, sampleDiffuse_xyzw_5.z, r4_w_6) * _diff_Color);
                float r1_w_2 = (_monochrom == 1);
                float r2_x_5 = (r1_z_6 + (r1_y_6 + r1_x_2));
                float r2_y_3 = (r0_xyzw_7.y + r0_xyzw_7.x);
                float r2_y_4 = mad(sampleDiffuse_xyzw_5.z, _diff_Color.z, r2_y_3);
                float4 r2_xyzw_6 = (float4(r2_x_5, r2_y_4, r2_x_5, r2_x_5) * float4(0.33333334, 0.33333334, 0, 0));
                float r2_x_6 = r2_xyzw_6.x;
                float r2_y_5 = r2_xyzw_6.y;
                float4 monochromSelect_xyzw_8 = (r1_w_2.xxxx ? r2_y_5.xxxx : r0_xyzw_7.xyzx);
                float monochromSelect_x_8 = monochromSelect_xyzw_8.x;
                float monochromSelect_y_12 = monochromSelect_xyzw_8.y;
                float monochromSelect_z_7 = monochromSelect_xyzw_8.z;
                float4 monochromSelect_xyzw_3 = (r1_w_2.xxxx ? r2_x_6.xxxx : float4(r1_x_2, r1_y_6, r1_z_6, r1_x_2));
                float monochromSelect_x_3 = monochromSelect_xyzw_3.x;
                float monochromSelect_y_7 = monochromSelect_xyzw_3.y;
                monochromSelect_z_7 = monochromSelect_xyzw_3.z;
                float4 r1_xyzw_4 = (-float4(monochromSelect_x_8, monochromSelect_y_12, monochromSelect_z_7, monochromSelect_x_8) + float4(monochromSelect_x_3, monochromSelect_y_7, monochromSelect_z_7, monochromSelect_x_3));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_8 = r1_xyzw_4.y;
                float r1_z_8 = r1_xyzw_4.z;
                float r1_w_3 = (-r0_xyzw_7.w + _Color.w);
                o.sv_Target0.xyzw = mad(i.texcoord4.xxxx, float4(r1_x_4, r1_y_8, r1_z_8, r1_w_3), float4(monochromSelect_x_8, monochromSelect_y_12, monochromSelect_z_7, r0_xyzw_7.w));
                return o;
            }
            ENDHLSL
        }
    }
    CustomEditor "Glitch_Editor_lite"
}
