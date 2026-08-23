Shader "HOLO/Holo_adv"
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
        _intensity ("Intensity", Range(0, 10)) = 0
        _deform ("Deformation intensity", Float) = 1
        _Color ("Outline Color Mult", Color) = (1,1,1,1)
        _Opacity ("Base Opacity", Range(0, 1)) = 0
        _Bias ("Bias", Range(0, 1)) = 0
        _Scale ("Scale ", Range(0, 10)) = 0
        _Power ("Power", Range(0, 3)) = 0
        _Speed ("Speed", Range(0, 1)) = 0
        _t ("Extra Option", Range(0, 1)) = 0
        [Toggle]
        _X ("Active X Axe", Float) = 1
        [Toggle]
        _Y ("Active Y Axe", Float) = 1
        [Toggle]
        _glitchColor ("Glitch/Diffuse Color", Float) = 1
        _glitchColor_c ("G/H Color", Color) = (1,1,1,1)
        [Toggle]
        _dist_chrom ("Chromatic ", Float) = 1
        _noise_details ("G/H Noise Details Amount", Range(1, 16)) = 0
        _cut_level ("Cut Level", Range(0, 6)) = 0
        _OrigineX ("OrigineX", Range(0, 1)) = 0
        _OrigineY ("OrigineY", Range(0, 1)) = 0
        _Circle_wave ("Wave Circles", Range(0, 100)) = 5
        _Speed_wave ("Wave Speed", Float) = 0
        _Zoom ("Zoom", Range(0.5, 200)) = 1
        _Speed_face ("_Speed_face", Range(0.01, 10)) = 1
        _Rotation ("Rotation", Range(0, 1)) = 0
        [Toggle]
        _monochrom ("Monochromatic", Float) = 1
        [Toggle]
        _OriginalUVSwitch ("Switch to Orginal UVs on/off", Float) = 0
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
                float4 _M_map_ST;
                float _intensity;
                float _deform;
                float _Bias;
                float _Scale;
                float _Power;
                float _Speed;
                float _t;
                float _noise_details;
                float _cut_level;
                float _X;
                float _Y;
                float _mask_type;
                float _dist_chrom;
                float _glitchColor;
                float4 _glitchColor_c;
                float _Opacity;
                float _OrigineX;
                float _OrigineY;
                float _Speed_wave;
                float _Circle_wave;
                float _Zoom;
                float _Speed_face;
                float _Rotation;
                float _monochrom;
                float _OriginalUVSwitch;
                float4 cb0_values[13];
            };
            cbuffer UnityPerCamera : register(b1)
            {
                float4 _Time;
                float4 _SinTime;
                float4 _CosTime;
                float3 _WorldSpaceCameraPos;
                float4 _ScreenParams;
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
            SamplerState sampler_linear_clamp : register(s0);
            Texture2D t0 : register(t0);
            SamplerState sampler_linear_clamp1 : register(s1);
            SamplerState sampler_linear_clamp2 : register(s2);
            SamplerState sampler_linear_clamp3 : register(s3);
            Texture2D t1 : register(t1);
            Texture2D t2 : register(t2);
            Texture2D t3 : register(t3);
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
                float4 texcoord5 : TEXCOORD5;
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
                float4 texcoord5 : TEXCOORD5;
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
                float4x4 objectToView = mul(unity_ObjectToWorld, unity_MatrixV);
                float r0_w_1 = (_Speed * _Time.x);
                float r0_w_2 = (r0_w_1 * 60);
                float r0_w_3 = (sin(r0_w_2) + 1);
                float r1_w_1 = (_Speed_wave * _Time.x);
                float4 r4_xyzw_2 = (-i.texcoord0.xyxx + cb0_values[12].yzyy);
                float r4_x_2 = r4_xyzw_2.x;
                float r4_y_1 = r4_xyzw_2.y;
                float4 r4_xyzw_3 = (float4(r4_x_2, r4_y_1, r4_x_2, r4_x_2) * float4(r4_x_2, r4_y_1, r4_x_2, r4_x_2));
                float r4_x_3 = r4_xyzw_3.x;
                float r4_y_2 = r4_xyzw_3.y;
                float r2_w_1 = (r4_y_2 + r4_x_3);
                float r1_w_2 = mad(r2_w_1, _Circle_wave, r1_w_1);
                float r1_w_3 = sin(r1_w_2);
                float r1_w_4 = (r1_w_3 + 1);
                float r1_w_5 = (r1_w_4 * 0.5);
                float r2_w_2 = (-_mask_type + 1);
                float r3_w_1 = (cos(r0_w_2) * _M_map_ST.y);
                float r0_w_4 = (r0_w_3 * _M_map_ST.w);
                float4 uvMMap_xyzw_4 = mad(i.texcoord0.xyxx, r3_w_1.xxxx, r0_w_4.xxxx);
                float uvMMap_x_4 = uvMMap_xyzw_4.x;
                float uvMMap_y_3 = uvMMap_xyzw_4.y;
                float4 sampleMMap_xyzw_5 = t0.SampleLevel(sampler_linear_clamp, (float4(uvMMap_x_4, uvMMap_y_3, uvMMap_x_4, uvMMap_x_4)).xy, 0);
                float r0_w_5 = (sampleMMap_xyzw_5.x * _mask_type);
                float r0_w_6 = mad(r1_w_5, r2_w_2, r0_w_5);
                float r1_w_6 = (int)(_noise_details);
                float4 r4_xyzw_6 = (_Time.xyzx * float4(0.1, 0.1, 0.1, 0));
                float r4_x_6 = r4_xyzw_6.x;
                float r4_y_5 = r4_xyzw_6.y;
                float r4_z_2 = r4_xyzw_6.z;
                float TEXCOORD0_x_2 = (i.texcoord0.xyxx).x;
                float TEXCOORD0_y_1 = (i.texcoord0.xyxx).y;
                float r5_z_1 = 0;
                float r2_w_3 = r1_w_6;
                float3 noiseAccum_xyz_2 = (float4(0, 0, 0, 0)).xyz;
                float2 r5_yz_2 = float2(TEXCOORD0_y_1, r5_z_1);
                float r2_w_4 = r2_w_3;
                float r5_x_3 = TEXCOORD0_x_2;
                float r3_w_3;
                float3 r7_xyz_5;
                float3 noiseAccum_xyz_4;
                float r5_x_8;
                float r5_y_7;
                float r5_z_7;
                float r2_w_5;
                [loop]
                while (true)
                {
                    r3_w_3 = (0 >= r2_w_4);
                    if (r3_w_3) break;
                    r7_xyz_5 = (floor(float4(r5_x_3, r5_yz_2.x, r5_yz_2.y, r5_x_3))).xyz;
                    noiseAccum_xyz_4 = ((noiseAccum_xyz_2.xyzx + (sin((mad(r7_xyz_5.xxzx, r7_xyz_5.yyyy, ((float4(r4_x_6, r4_y_5, r4_z_2, r4_x_6) * r7_xyz_5.xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                    float4 r5_xyzw_8 = (float4(r5_x_3, r5_yz_2.x, r5_yz_2.y, r5_x_3) * float4(2.5, 2.5, 2.5, 0));
                    r5_x_8 = r5_xyzw_8.x;
                    r5_y_7 = r5_xyzw_8.y;
                    r5_z_7 = r5_xyzw_8.z;
                    r2_w_5 = (r2_w_4 + -1);
                    noiseAccum_xyz_2 = noiseAccum_xyz_4;
                    r5_yz_2 = float2(r5_y_7, r5_z_7);
                    r2_w_4 = r2_w_5;
                    r5_x_3 = r5_x_8;
                }
                float4 r4_xyzw_7 = (cb0_values[7].yxyy * float4(0.001, 0.1, 0, 0));
                float r4_x_7 = r4_xyzw_7.x;
                float r4_y_6 = r4_xyzw_7.y;
                float4 r4_xyzw_8 = (r4_x_7.xxxx * noiseAccum_xyz_2.xxyz);
                float r4_x_8 = r4_xyzw_8.x;
                float r4_z_3 = r4_xyzw_8.z;
                float r4_w_2 = r4_xyzw_8.w;
                float4 r4_xyzw_9 = (r0_w_6.xxxx * float4(r4_x_8, r4_x_8, r4_z_3, r4_w_2));
                float r4_x_9 = r4_xyzw_9.x;
                float r4_z_4 = r4_xyzw_9.z;
                float r4_w_3 = r4_xyzw_9.w;
                float4 r4_xyzw_10 = (r4_y_6.xxxx * float4(r4_x_9, r4_z_4, r4_w_3, r4_x_9));
                float r4_x_10 = r4_xyzw_10.x;
                float r4_y_7 = r4_xyzw_10.y;
                float r4_z_5 = r4_xyzw_10.z;
                float4 r4_xyzw_11 = (float4(r4_x_10, r4_y_7, r4_x_10, r4_x_10) * cb0_values[9].yzyy);
                float r4_x_11 = r4_xyzw_11.x;
                float r4_y_8 = r4_xyzw_11.y;
                float4 r4_xyzw_12 = (float4(r4_x_11, r4_y_8, r4_z_5, r4_x_11) * i.normal0.xyzx);
                float r4_x_12 = r4_xyzw_12.x;
                float r4_y_9 = r4_xyzw_12.y;
                float r4_z_6 = r4_xyzw_12.z;
                float4 r4_xyzw_13 = mad(float4(r4_x_12, r4_y_9, r4_z_6, r4_x_12), float4(10, 10, 10, 0), i.position0.xyzx);
                float r4_x_13 = r4_xyzw_13.x;
                float r4_y_10 = r4_xyzw_13.y;
                float r4_z_7 = r4_xyzw_13.z;
                float4 r5_xyzw_4 = (r4_y_10.xxxx * unity_ObjectToWorld[1]);
                float4 r5_xyzw_5 = mad(unity_ObjectToWorld[0], r4_x_13.xxxx, r5_xyzw_4);
                float4 r5_xyzw_6 = mad(unity_ObjectToWorld[2], r4_z_7.xxxx, r5_xyzw_5);
                float4 r6_xyzw_3 = (r5_xyzw_6 + unity_ObjectToWorld[3]);
                float4 r7_xyzw_2 = (r6_xyzw_3.yyyy * unity_MatrixVP[1]);
                float4 r7_xyzw_3 = mad(unity_MatrixVP[0], r6_xyzw_3.xxxx, r7_xyzw_2);
                float4 r7_xyzw_4 = mad(unity_MatrixVP[2], r6_xyzw_3.zzzz, r7_xyzw_3);
                o.sv_Position0.xyzw = mad(unity_MatrixVP[3], r6_xyzw_3.wwww, r7_xyzw_4);
                float4 worldPos_xyzw_7 = mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, r5_xyzw_6.xyzx);
                float worldPos_x_7 = worldPos_xyzw_7.x;
                float worldPos_y_6 = worldPos_xyzw_7.y;
                float worldPos_z_6 = worldPos_xyzw_7.z;
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
                float4 dirToSurface_xyzw_9 = (float4(worldPos_x_7, worldPos_y_6, worldPos_z_6, worldPos_x_7) + -_WorldSpaceCameraPos.xyzx);
                float dirToSurface_x_9 = dirToSurface_xyzw_9.x;
                float dirToSurface_y_9 = dirToSurface_xyzw_9.y;
                float dirToSurface_z_12 = dirToSurface_xyzw_9.z;
                float r0_w_7 = dot(float4(dirToSurface_x_9, dirToSurface_y_9, dirToSurface_z_12, dirToSurface_x_9), float4(dirToSurface_x_9, dirToSurface_y_9, dirToSurface_z_12, dirToSurface_x_9));
                float r0_w_8 = rsqrt(r0_w_7);
                float4 unitDirToSurface_xyzw_10 = (r0_w_8.xxxx * float4(dirToSurface_x_9, dirToSurface_y_9, dirToSurface_z_12, dirToSurface_x_9));
                float unitDirToSurface_x_10 = unitDirToSurface_xyzw_10.x;
                float unitDirToSurface_y_10 = unitDirToSurface_xyzw_10.y;
                float unitDirToSurface_z_13 = unitDirToSurface_xyzw_10.z;
                float nDotV_x_11 = dot(float4(unitDirToSurface_x_10, unitDirToSurface_y_10, unitDirToSurface_z_13, unitDirToSurface_x_10), unitWorldNormal_xyz_7.xyzx);
                float r0_y_11 = (_Scale * _Bias);
                                float fresnel_x_15 = pow((nDotV_x_11 + _t), _Power);
                o.texcoord4.x = (fresnel_x_15 * r0_y_11);
                o.texcoord5.xyz = (float4(worldPos_x_7, worldPos_y_6, worldPos_z_6, worldPos_x_7)).xyz;
                o.texcoord5.w = 0;
                o.texcoord0.xyzw = i.texcoord0.xyzw;
                o.texcoord1.xyzw = float4(0, 0, 0, 0);
                o.texcoord4.yzw = (float4(0, 0, 0, 0)).yzw;
                o.normal0.xyzw = float4(0, 0, 0, 0);
                o.texcoord6.w = i.position0.w;
                o.texcoord6.xyz = (float4(r4_x_13, r4_y_10, r4_z_7, r4_x_13)).xyz;
                o.texcoord2.z = 0;
                o.texcoord3.xyz = unitWorldNormal_xyz_7.xyz;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float r0_x_3 = sin(((_Speed * _Time.x) * 60));
                float r0_y_1 = (_Speed_wave * _Time.x);
                float2 r0_zw_1 = ((-i.texcoord0.xxxy + cb0_values[12].yyyz)).zw;
                float2 r0_zw_2 = ((r0_zw_1.xxxy * r0_zw_1.xxxy)).zw;
                float r0_z_3 = (r0_zw_2.y + r0_zw_2.x);
                float r0_y_2 = mad(r0_z_3, _Circle_wave, r0_y_1);
                float r0_y_3 = sin(r0_y_2);
                float2 r0_xy_4 = ((float4(r0_x_3, r0_y_3, r0_x_3, r0_x_3) + float4(1, 1, 0, 0))).xy;
                float r0_y_5 = (r0_xy_4.y * 0.5);
                float r0_z_4 = (_Rotation * 1.57);
                float r2_x_1 = sin(r0_z_4);
                float r4_x_1 = -r2_x_1;
                float r4_y_1 = cos(r0_z_4);
                float r3_y_1 = dot(float4(r4_y_1, r4_x_1, r4_y_1, r4_y_1), i.texcoord0.xyxx);
                float r4_z_1 = r2_x_1;
                float r0_z_5 = dot(float4(r4_z_1, r4_y_1, r4_z_1, r4_z_1), i.texcoord0.xyxx);
                float2 r1_yz_1 = ((i.sv_Position0.xxyx / _ScreenParams.xxyx)).yz;
                float r0_w_3 = (_CosTime.x * 100);
                float r2_x_2 = (r0_w_3 * _Speed_face);
                float r0_w_4 = (_SinTime.x * 100);
                float r2_y_1 = (r0_w_4 * _Speed_face);
                float4 r2_xyzw_3 = (float4(r2_x_2, r2_y_1, r2_x_2, r2_x_2) / _Zoom.xxxx);
                float r2_x_3 = r2_xyzw_3.x;
                float r2_y_2 = r2_xyzw_3.y;
                float2 r1_yz_2 = ((r1_yz_1.xxyx + float4(r2_x_3, r2_x_3, r2_y_2, r2_x_3))).yz;
                float4 r2_xyzw_4 = t0.Sample(sampler_linear_clamp2, (r1_yz_2.xyxx).xy);
                float r0_w_5 = (-_mask_type + 1);
                float TEXCOORD0_x_2 = i.texcoord0.x;
                float4 r1_xyzw_4 = t1.Sample(sampler_linear_clamp3, ((mad(float4(TEXCOORD0_x_2, r3_y_1, TEXCOORD0_x_2, TEXCOORD0_x_2), ((cos(r0_x_3) * _M_map_ST.y)).xxxx, ((r0_xy_4.x * _M_map_ST.w)).xxxx)).xyxx).xy);
                float2 r0_yw_6 = ((_OriginalUVSwitch.xxxx == float4(0, 0, 0, 1))).yw;
                float sampleDiffuse_x_8;
                float sampleDiffuse_y_8;
                float sampleDiffuse_z_6;
                float sampleDiffuse_w_4;
                if (r0_yw_6.x)
                {
                    float2 uvDiffuse_xy_6 = (mad(i.texcoord2.xyxx, _Diffuse_ST.yyyy, _Diffuse_ST.wwww)).xy;
                    float4 sampleDiffuse_xyzw_7 = t2.Sample(sampler_linear_clamp, (uvDiffuse_xy_6.xyxx).xy);
                    sampleDiffuse_x_8 = sampleDiffuse_xyzw_7.x;
                    sampleDiffuse_y_8 = sampleDiffuse_xyzw_7.y;
                    sampleDiffuse_z_6 = sampleDiffuse_xyzw_7.z;
                    sampleDiffuse_w_4 = sampleDiffuse_xyzw_7.w;
                }
                else
                {
                    float4 r1_xyzw_5 = float4(0, 0, 0, 0);
                    sampleDiffuse_x_8 = r1_xyzw_5.x;
                    sampleDiffuse_y_8 = r1_xyzw_5.y;
                    sampleDiffuse_z_6 = r1_xyzw_5.z;
                    sampleDiffuse_w_4 = r1_xyzw_5.w;
                }
                float sampleDiffuse_x_10 = sampleDiffuse_x_8;
                float sampleDiffuse_y_10 = sampleDiffuse_y_8;
                float sampleDiffuse_z_8 = sampleDiffuse_z_6;
                float sampleDiffuse_w_6 = sampleDiffuse_w_4;
                if (r0_yw_6.y)
                {
                    float4 r1_xyzw_9 = t3.Sample(sampler_linear_clamp1, (float4(TEXCOORD0_x_2, r3_y_1, TEXCOORD0_x_2, TEXCOORD0_x_2)).xy);
                    sampleDiffuse_x_10 = r1_xyzw_9.x;
                    sampleDiffuse_y_10 = r1_xyzw_9.y;
                    sampleDiffuse_z_8 = r1_xyzw_9.z;
                    sampleDiffuse_w_6 = r1_xyzw_9.w;
                }
                float r0_x_9 = ((mad(r0_y_5, r0_w_5, (r1_xyzw_4.x * _mask_type)) * r2_xyzw_4.x) * 0.84147096);
                float r0_y_7 = (r0_x_9 * i.texcoord0.x);
                float4 r0_xyzw_8 = mad(r0_y_7.xxxx, _intensity.xxxx, float4(TEXCOORD0_x_2, TEXCOORD0_x_2, TEXCOORD0_x_2, r3_y_1));
                float r0_y_8 = r0_xyzw_8.y;
                float r0_w_7 = r0_xyzw_8.w;
                float r2_y_4 = ((_Time.xxyx * float4(0, 0.1, 0.1, 0))).y;
                float r2_z_2 = ((_Time.xxyx * float4(0, 0.1, 0.1, 0))).z;
                float r3_x_3 = r0_y_8;
                float r3_y_2 = r0_w_7;
                float2 r3_zw_1 = (float4(0, 0, 0, 0)).zw;
                float r2_w_2 = (int)(_noise_details);
                float2 noiseAccum_zw_2 = r3_zw_1.xy;
                float r2_w_3 = r2_w_2;
                float r3_x_4 = r3_x_3;
                float r3_y_3 = r3_y_2;
                float r4_x_5;
                float r4_y_4;
                float r4_z_4;
                float r4_w_1;
                float r4_x_6;
                float r4_y_5;
                float r4_x_7;
                float r4_y_6;
                float noiseAccum_z_5;
                float noiseAccum_w_4;
                float r3_x_7;
                float r3_y_6;
                float r2_w_4;
                [loop]
                while (true)
                {
                    if ((0 >= r2_w_3)) break;
                    float4 r4_xyzw_5 = floor(float4(r3_x_4, r3_y_3, r3_x_4, r3_x_4));
                    r4_x_5 = r4_xyzw_5.x;
                    r4_y_4 = r4_xyzw_5.y;
                    float4 r4_xyzw_4 = (float4(r2_y_4, r2_y_4, r2_y_4, r2_z_2) * float4(r4_x_5, r4_x_5, r4_x_5, r4_y_4));
                    r4_z_4 = r4_xyzw_4.z;
                    r4_w_1 = r4_xyzw_4.w;
                    float4 r4_xyzw_6 = mad(r4_x_5.xxxx, r4_y_4.xxxx, float4(r4_z_4, r4_w_1, r4_z_4, r4_z_4));
                    r4_x_6 = r4_xyzw_6.x;
                    r4_y_5 = r4_xyzw_6.y;
                    float4 r4_xyzw_7 = sin(float4(r4_x_6, r4_y_5, r4_x_6, r4_x_6));
                    r4_x_7 = r4_xyzw_7.x;
                    r4_y_6 = r4_xyzw_7.y;
                    float4 noiseAccum_xyzw_5 = (noiseAccum_zw_2.xxxy + float4(r4_x_7, r4_x_7, r4_x_7, r4_y_6));
                    noiseAccum_z_5 = noiseAccum_xyzw_5.z;
                    noiseAccum_w_4 = noiseAccum_xyzw_5.w;
                    float4 r3_xyzw_7 = (float4(r3_x_4, r3_y_3, r3_x_4, r3_x_4) * float4(2.5, 2.5, 0, 0));
                    r3_x_7 = r3_xyzw_7.x;
                    r3_y_6 = r3_xyzw_7.y;
                    r2_w_4 = (r2_w_3 + -1);
                    noiseAccum_zw_2 = float2(noiseAccum_z_5, noiseAccum_w_4);
                    r2_w_3 = r2_w_4;
                    r3_x_4 = r3_x_7;
                    r3_y_3 = r3_y_6;
                }
                float4 r0_xyzw_9 = (noiseAccum_zw_2.xxxy * _glitchColor.xxxx);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_w_8 = r0_xyzw_9.w;
                float2 r0_xy_10 = ((float4(r0_y_9, r0_w_8, r0_y_9, r0_y_9) * r0_x_9.xxxx)).xy;
                float4 r0_xyzw_11 = (r0_xy_10.xxxy * _intensity.xxxx);
                float r0_y_11 = r0_xyzw_11.y;
                float r0_w_9 = r0_xyzw_11.w;
                float4 r2_xyzw_6 = mad(float4(r0_y_11, r0_w_9, r0_y_11, r0_y_11), float4(0.25, 0.5, 0, 0), _Color.xyxx);
                float r2_x_6 = r2_xyzw_6.x;
                float r2_y_5 = r2_xyzw_6.y;
                float r2_z_3 = mad(r0_xy_10.x, _intensity, _Color.z);
                float r0_x_12 = (r2_z_3 + (r2_y_5 + r2_x_6));
                float r0_y_12 = (r0_x_12 * 4);
                float r0_y_13 = (r0_y_12 * _cut_level);
                float r0_y_14 = mad(-r0_y_13, r0_z_5, 1);
                float r0_y_15 = (i.texcoord6.y < r0_y_14);
                if (r0_y_15) discard;
                float r0_x_13 = (r0_x_12 * 0.33333334);
                float r1_w_7 = (sampleDiffuse_w_6 * _Opacity);
                float4 r3_xyzw_5 = (float4(sampleDiffuse_x_10, sampleDiffuse_y_10, sampleDiffuse_z_8, r1_w_7) * _diff_Color);
                float r0_y_16 = (r3_xyzw_5.y + r3_xyzw_5.x);
                float r0_y_17 = mad(sampleDiffuse_z_8, _diff_Color.z, r0_y_16);
                float r0_y_18 = (r0_y_17 * 0.33333334);
                float r0_z_6 = (-_dist_chrom + 1);
                float r0_w_10 = (r0_z_6 * r0_x_13);
                float4 r1_xyzw_11 = mad(float4(r2_x_6, r2_y_5, r2_z_3, r2_x_6), _dist_chrom.xxxx, r0_w_10.xxxx);
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_11 = r1_xyzw_11.y;
                float r1_z_9 = r1_xyzw_11.z;
                float r0_w_11 = (r0_z_6 * r0_y_18);
                float4 r2_xyzw_7 = mad(r3_xyzw_5.xyzx, _dist_chrom.xxxx, r0_w_11.xxxx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_6 = r2_xyzw_7.y;
                float r2_z_4 = r2_xyzw_7.z;
                float r4_x_4 = (mad(_glitchColor_c.xyzx, r0_z_6.xxxx, _dist_chrom.xxxx)).x;
                float4 r4_xyzw_3 = mad(_glitchColor_c.xyzx, r0_z_6.xxxx, _dist_chrom.xxxx);
                float r4_y_3 = r4_xyzw_3.y;
                float r4_z_3 = r4_xyzw_3.z;
                float4 r1_xyzw_12 = (float4(r1_x_11, r1_y_11, r1_z_9, r1_x_11) * float4(r4_x_4, r4_y_3, r4_z_3, r4_x_4));
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_12 = r1_xyzw_12.y;
                float r1_z_10 = r1_xyzw_12.z;
                float r0_z_7 = (_monochrom == 1);
                float4 monochromSelect_xyzw_6 = (r0_z_7.xxxx ? r0_y_18.xxxx : float4(r2_x_7, r2_y_6, r2_z_4, r2_x_7));
                float monochromSelect_x_6 = monochromSelect_xyzw_6.x;
                float monochromSelect_y_5 = monochromSelect_xyzw_6.y;
                float monochromSelect_z_4 = monochromSelect_xyzw_6.z;
                float4 monochromSelect_xyzw_14 = (r0_z_7.xxxx ? r0_x_13.xxxx : float4(r1_x_12, r1_y_12, r1_z_10, r1_x_12));
                float monochromSelect_x_14 = monochromSelect_xyzw_14.x;
                float monochromSelect_y_19 = monochromSelect_xyzw_14.y;
                float monochromSelect_z_8 = monochromSelect_xyzw_14.z;
                float4 r0_xyzw_15 = (-float4(monochromSelect_x_6, monochromSelect_y_5, monochromSelect_z_4, monochromSelect_x_6) + float4(monochromSelect_x_14, monochromSelect_y_19, monochromSelect_z_8, monochromSelect_x_14));
                float r0_x_15 = r0_xyzw_15.x;
                float r0_y_20 = r0_xyzw_15.y;
                float r0_z_9 = r0_xyzw_15.z;
                float r0_w_12 = (-r3_xyzw_5.w + _Color.w);
                o.sv_Target0.xyzw = mad(i.texcoord4.xxxx, float4(r0_x_15, r0_y_20, r0_z_9, r0_w_12), float4(monochromSelect_x_6, monochromSelect_y_5, monochromSelect_z_4, r3_xyzw_5.w));
                return o;
            }
            ENDHLSL
        }
    }
    CustomEditor "Glitch_Editor"
}
