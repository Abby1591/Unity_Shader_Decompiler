Shader "Corpus/37 Water"
{
    Properties
    {
        _Color ("Water Color", Color) = (0.1,0.3,0.5,1)
        _NormalMap ("Normal Map", 2D) = "" {}
        _NormalScale ("Normal Scale", Float) = 1
        _WaveMap ("Wave Map", 2D) = "" {}
        _WaveSpeed ("Wave Speed", Vector) = (0.5,0.5,0,0)
        _WaveScale ("Wave Scale", Float) = 1
        _ReflectionCube ("Reflection", 2D) = "" {}
        _ReflectionStrength ("Reflection Strength", Range(0, 1)) = 0.5
        _RefractionStrength ("Refraction Strength", Range(0, 0.2)) = 0.05
        _FresnelPower ("Fresnel Power", Range(0.1, 8)) = 4
        _DepthFade ("Depth Fade", Range(0.01, 10)) = 1
        _Specular ("Specular", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "IGNOREPROJECTOR"="true" "QUEUE"="Transparent" "RenderType"="Transparent" }
        LOD 0
        Pass
        {
            Cull Off
            ZTest Disabled
            ZWrite Off
            ZClip Off
            Stencil
            {
                ReadMask 0
                WriteMask 0
                Comp Disabled
                Pass Keep
                Fail Keep
                ZFail Keep
            }
            HLSLPROGRAM
            cbuffer cb0 : register(b0)
            {
                float4 cb0_values[12];
            };
            cbuffer cb1 : register(b1)
            {
                float4 cb1_values[8];
            };
            cbuffer cb2 : register(b2)
            {
                float4 cb2_values[21];
            };
            SamplerState sampler_WaveMap;
            SamplerState sampler_NormalMap;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_ReflectionCube;
            SamplerState sampler_linear_clamp4;
            Texture2D _NormalMap;
            Texture2D _WaveMap;
            TextureCube _ReflectionCube;
            Texture2D t3;
            Texture2D t4;
            struct program1Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program1Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
            };
            struct program3Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program1Output vert(program1Input i)
            {
                program1Output o = (program1Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float3 r0_xyz_4 = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1);
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                float4 clipPos_xyzw_4 = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                float r0_w_4 = (worldPos_xyzw_1.y * cb2_values[10].z);
                float r0_w_5 = mad(cb2_values[9].z, worldPos_xyzw_1.x, r0_w_4);
                float r0_w_6 = mad(cb2_values[11].z, worldPos_xyzw_1.z, r0_w_5);
                float r0_w_7 = mad(cb2_values[12].z, worldPos_xyzw_1.w, r0_w_6);
                o.texcoord5.x = -r0_w_7;
                o.texcoord0.xy = (i.texcoord0.xyxx).xy;
                float3 r1_xyz_2 = ((clipPos_xyzw_4.xwyx * float4(0.5, 0.5, -0.5, 0))).xyz;
                o.texcoord1.zw = (clipPos_xyzw_4.zzzw).zw;
                o.texcoord1.xy = ((r1_xyz_2.yyyy + r1_xyz_2.xzxx)).xy;
                float worldNormal_x_3 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord2.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord3.xyz = r0_xyz_4.xyz;
                o.texcoord4.xyz = ((-r0_xyz_4.xyzx + cb0_values[4].xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float2 r0_xy_1 = (mad(i.texcoord0.xyxx, float4(20, 20, 0, 0), cb1_values[0].yyyy)).xy;
                float2 r0_zw_1 = (floor(r0_xy_1.xxxy)).zw;
                float2 r1_xy_3 = (frac(((((r0_zw_1.xyxx + float4(1, 1, 0, 0))).xyxx * float4(0.1031, 0.1031, 0, 0))).xyxx)).xy;
                float r1_z_1 = dot(r1_xy_3.xyxx, ((r1_xy_3.yxxy + float4(33.33, 33.33, 33.33, 0))).xyzx);
                float2 r1_xy_4 = ((r1_z_1.xxxx + r1_xy_3.xyxx)).xy;
                float r1_y_5 = (r1_xy_4.y + r1_xy_4.x);
                float r1_x_5 = (r1_xy_4.x * r1_y_5);
                float4 r2_xyzw_2 = (r0_zw_1.yxyx + float4(0, 1, 1, 0));
                float2 r0_zw_2 = ((r0_zw_1.xxxy * float4(0, 0, 0.1031, 0.1031))).zw;
                float4 r0_xyzw_2 = frac(float4(r0_xy_1.x, r0_xy_1.y, r0_zw_2.x, r0_zw_2.y));
                float4 r2_xyzw_3 = (r2_xyzw_2 * float4(0.1031, 0.1031, 0.1031, 0.1031));
                float4 r2_xyzw_4 = frac(r2_xyzw_3);
                float4 r3_xyzw_1 = (r2_xyzw_4 + float4(33.33, 33.33, 33.33, 33.33));
                float r1_y_6 = dot(r2_xyzw_4.wzww, r3_xyzw_1.zwwz);
                float r1_z_2 = dot(r2_xyzw_4.yxyy, r3_xyzw_1.xyyx);
                float4 r1_xyzw_3 = (r1_z_2.xxxx + r2_xyzw_4.yyyx);
                float r1_z_3 = r1_xyzw_3.z;
                float r1_w_1 = r1_xyzw_3.w;
                float2 r2_xy_5 = ((r1_y_6.xxxx + r2_xyzw_4.wzww)).xy;
                float r1_y_7 = (r2_xy_5.y + r2_xy_5.x);
                float r1_y_8 = (r2_xy_5.x * r1_y_7);
                float4 r1_xyzw_6 = frac(float4(r1_x_5, r1_y_8, r1_x_5, r1_x_5));
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_9 = r1_xyzw_6.y;
                float2 r0_xy_4 = (((mad(-r0_xyzw_2.xyxx, float4(2, 2, 0, 0), float4(3, 3, 0, 0))).xyxx * ((r0_xyzw_2.xyxx * r0_xyzw_2.xyxx)).xyxx)).xy;
                float4 r2_xyzw_7 = (r0_xyzw_2.wzzw + float4(33.33, 33.33, 33.33, 0));
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_7 = r2_xyzw_7.y;
                float r2_z_5 = r2_xyzw_7.z;
                float r1_y_10 = dot(r0_xyzw_2.zwzz, float4(r2_x_7, r2_y_7, r2_z_5, r2_x_7));
                float2 r0_zw_4 = ((r0_xyzw_2.zzzw + r1_y_10.xxxx)).zw;
                float r0_w_5 = (r0_zw_4.y + r0_zw_4.x);
                float r0_z_5 = (r0_zw_4.x * r0_w_5);
                float r0_w_6 = (r1_w_1 + r1_z_3);
                float r0_w_7 = (r1_z_3 * r0_w_6);
                float4 r0_xyzw_6 = frac(float4(r0_z_5, r0_z_5, r0_z_5, r0_w_7));
                float r0_z_6 = r0_xyzw_6.z;
                float r0_w_8 = r0_xyzw_6.w;
                float r0_w_9 = (-r0_z_6 + r0_w_8);
                float r0_x_5 = mad(r0_xy_4.x, r0_w_9, r0_z_6);
                float r0_z_7 = (-r0_x_5 + mad(r0_xy_4.x, (-r1_y_9 + r1_x_6), r1_y_9));
                float4 r0_xyzw_5 = (cb0_values[9].zzwz * cb1_values[0].yyyy);
                float r0_y_5 = r0_xyzw_5.y;
                float r0_z_8 = r0_xyzw_5.z;
                float4 r1_xyzw_9 = mad(i.texcoord0.xyxx, cb0_values[5].xyxx, cb0_values[5].zwzz);
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_11 = r1_xyzw_9.y;
                float r0_y_6 = (mad(float4(r1_x_9, r1_x_9, r1_y_11, r1_x_9), float4(0, 1.37, 1.37, 0), -float4(r0_y_5, r0_y_5, r0_z_8, r0_y_5))).y;
                float r0_z_9 = (mad(float4(r1_x_9, r1_x_9, r1_y_11, r1_x_9), float4(0, 1.37, 1.37, 0), -float4(r0_y_5, r0_y_5, r0_z_8, r0_y_5))).z;
                float4 r1_xyzw_10 = mad(cb1_values[0].yyyy, cb0_values[9].xyxx, float4(r1_x_9, r1_y_11, r1_x_9, r1_x_9));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_12 = r1_xyzw_10.y;
                float4 r1_xyzw_11 = _NormalMap.Sample(sampler_NormalMap, (float4(r1_x_10, r1_y_12, r1_x_10, r1_x_10)).xy);
                float4 r2_xyzw_8 = _NormalMap.Sample(sampler_NormalMap, (float4(r0_y_6, r0_z_9, r0_y_6, r0_y_6)).xy);
                float r0_y_7 = (r1_xyzw_11.x + r2_xyzw_8.x);
                float r0_y_8 = (r0_y_7 * cb0_values[10].x);
                float2 r0_zw_10 = (mad(i.texcoord0.xxxy, cb0_values[4].xxxy, cb0_values[4].zzzw)).zw;
                float4 r0_xyzw_9 = mad(r0_y_8.xxxx, float4(0, 0.05, 0.05, 0), r0_zw_10.xxyx);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_11 = r0_xyzw_9.z;
                float4 r1_xyzw_12 = _WaveMap.Sample(sampler_WaveMap, (float4(r0_y_9, r0_z_11, r0_y_9, r0_y_9)).xy);
                float r1_x_13 = (r1_xyzw_12.w * r1_xyzw_12.x);
                float4 r0_xyzw_10 = mad(float4(r1_x_13, r1_x_13, r1_xyzw_12.y, r1_x_13), float4(0, 2, 2, 0), float4(0, -1, -1, 0));
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_12 = r0_xyzw_10.z;
                float4 r1_xyzw_14 = (float4(r0_y_10, r0_z_12, r0_y_10, r0_y_10) * cb0_values[8].xxxx);
                float r1_x_14 = r1_xyzw_14.x;
                float r1_y_15 = r1_xyzw_14.y;
                float r0_y_11 = dot(float4(r1_x_14, r1_y_15, r1_x_14, r1_x_14), float4(r1_x_14, r1_y_15, r1_x_14, r1_x_14));
                float r0_y_12 = min(r0_y_11, 1);
                float r0_y_13 = (-r0_y_12 + 1);
                float r1_z_6 = sqrt(r0_y_13);
                float4 r0_xyzw_14 = mad(float4(r1_x_14, r1_x_14, r1_y_15, r1_z_6), float4(0, 0.5, 0.5, 0.5), i.texcoord2.xxyz);
                float r0_y_14 = r0_xyzw_14.y;
                float r0_z_13 = r0_xyzw_14.z;
                float r0_w_11 = r0_xyzw_14.w;
                float4 r0_xyzw_15 = (float4(r0_y_14, r0_y_14, r0_z_13, r0_w_11) * (rsqrt(dot(float4(r0_y_14, r0_z_13, r0_w_11, r0_y_14), float4(r0_y_14, r0_z_13, r0_w_11, r0_y_14)))).xxxx);
                float r0_y_15 = r0_xyzw_15.y;
                float r0_z_14 = r0_xyzw_15.z;
                float r0_w_12 = r0_xyzw_15.w;
                float4 r1_xyzw_19 = ((rsqrt(dot(i.texcoord4.xyzx, i.texcoord4.xyzx))).xxxx * i.texcoord4.xyzx);
                float r1_x_19 = r1_xyzw_19.x;
                float r1_y_16 = r1_xyzw_19.y;
                float r1_z_7 = r1_xyzw_19.z;
                float r1_w_4 = dot(-float4(r1_x_19, r1_y_16, r1_z_7, r1_x_19), float4(r0_y_15, r0_z_14, r0_w_12, r0_y_15));
                float r1_w_5 = (r1_w_4 + r1_w_4);
                float4 r2_xyzw_9 = mad(float4(r0_y_15, r0_z_14, r0_w_12, r0_y_15), -r1_w_5.xxxx, -float4(r1_x_19, r1_y_16, r1_z_7, r1_x_19));
                float r2_x_9 = r2_xyzw_9.x;
                float r2_y_9 = r2_xyzw_9.y;
                float r2_z_7 = r2_xyzw_9.z;
                float4 r2_xyzw_10 = _ReflectionCube.Sample(sampler_ReflectionCube, (float4(r2_x_9, r2_y_9, r2_z_7, r2_x_9)).xyz);
                float2 r3_xy_3 = ((((float4(r0_y_15, r0_z_14, r0_y_15, r0_y_15) * cb0_values[10].zzzz)).xyxx * cb0_values[6].xyxx)).xy;
                float r3_z_2 = 0;
                float4 r3_xyzw_4 = (float4(r3_xy_3.x, r3_xy_3.y, r3_z_2, r3_xy_3.x) + i.texcoord1.xywx);
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_4 = r3_xyzw_4.y;
                float r3_z_3 = r3_xyzw_4.z;
                float4 r3_xyzw_6 = t3.Sample(sampler_linear_clamp2, (((float4(r3_x_4, r3_y_4, r3_x_4, r3_x_4) / r3_z_3.xxxx)).xyxx).xy);
                float4 r2_xyzw_11 = mad(-cb0_values[7].xyzx, r3_xyzw_6.xyzx, r2_xyzw_10.xyzx);
                float r2_x_11 = r2_xyzw_11.x;
                float r2_y_11 = r2_xyzw_11.y;
                float r2_z_9 = r2_xyzw_11.z;
                float4 r3_xyzw_7 = (r3_xyzw_6.xyzx * cb0_values[7].xyzx);
                float r3_x_7 = r3_xyzw_7.x;
                float r3_y_7 = r3_xyzw_7.y;
                float r3_z_5 = r3_xyzw_7.z;
                float r1_w_6 = saturate(dot(float4(r0_y_15, r0_z_14, r0_w_12, r0_y_15), float4(r1_x_19, r1_y_16, r1_z_7, r1_x_19)));
                float r1_w_7 = (-r1_w_6 + 1);
                float r1_w_8 = log2(r1_w_7);
                float r1_w_9 = (r1_w_8 * cb0_values[10].w);
                float r1_w_10 = exp2(r1_w_9);
                float r2_w_6 = (r1_w_10 * cb0_values[10].y);
                float r1_w_11 = (r1_w_10 + 0.4);
                float r1_w_12 = (r1_w_11 * cb0_values[7].w);
                float4 r2_xyzw_12 = mad(r2_w_6.xxxx, float4(r2_x_11, r2_y_11, r2_z_9, r2_x_11), float4(r3_x_7, r3_y_7, r3_z_5, r3_x_7));
                float r2_x_12 = r2_xyzw_12.x;
                float r2_y_12 = r2_xyzw_12.y;
                float r2_z_10 = r2_xyzw_12.z;
                float4 r3_xyzw_8 = mad(-i.texcoord3.xyzx, cb2_values[0].wwww, cb2_values[0].xyzx);
                float r3_x_8 = r3_xyzw_8.x;
                float r3_y_8 = r3_xyzw_8.y;
                float r3_z_6 = r3_xyzw_8.z;
                float r2_w_7 = dot(float4(r3_x_8, r3_y_8, r3_z_6, r3_x_8), float4(r3_x_8, r3_y_8, r3_z_6, r3_x_8));
                float r2_w_8 = rsqrt(r2_w_7);
                float4 r1_xyzw_20 = mad(float4(r3_x_8, r3_y_8, r3_z_6, r3_x_8), r2_w_8.xxxx, float4(r1_x_19, r1_y_16, r1_z_7, r1_x_19));
                float r1_x_20 = r1_xyzw_20.x;
                float r1_y_17 = r1_xyzw_20.y;
                float r1_z_8 = r1_xyzw_20.z;
                float4 r3_xyzw_9 = (r2_w_8.xxxx * float4(r3_x_8, r3_y_8, r3_z_6, r3_x_8));
                float r3_x_9 = r3_xyzw_9.x;
                float r3_y_9 = r3_xyzw_9.y;
                float r3_z_7 = r3_xyzw_9.z;
                float r2_w_9 = saturate(dot(float4(r0_y_15, r0_z_14, r0_w_12, r0_y_15), float4(r3_x_9, r3_y_9, r3_z_7, r3_x_9)));
                float4 r3_xyzw_10 = (r2_w_9.xxxx * cb0_values[2].xyzx);
                float r3_x_10 = r3_xyzw_10.x;
                float r3_y_10 = r3_xyzw_10.y;
                float r3_z_8 = r3_xyzw_10.z;
                float r2_w_10 = dot(float4(r1_x_20, r1_y_17, r1_z_8, r1_x_20), float4(r1_x_20, r1_y_17, r1_z_8, r1_x_20));
                float r2_w_11 = rsqrt(r2_w_10);
                float4 r1_xyzw_21 = (float4(r1_x_20, r1_y_17, r1_z_8, r1_x_20) * r2_w_11.xxxx);
                float r1_x_21 = r1_xyzw_21.x;
                float r1_y_18 = r1_xyzw_21.y;
                float r1_z_9 = r1_xyzw_21.z;
                float r0_y_16 = saturate(dot(float4(r0_y_15, r0_z_14, r0_w_12, r0_y_15), float4(r1_x_21, r1_y_18, r1_z_9, r1_x_21)));
                float r0_y_17 = log2(r0_y_16);
                float r0_y_18 = (r0_y_17 * 128);
                float r0_y_19 = exp2(r0_y_18);
                float r0_y_20 = (r0_y_19 * cb0_values[11].y);
                float4 r0_xyzw_21 = mad(float4(r3_x_10, r3_x_10, r3_y_10, r3_z_8), float4(0, 0.25, 0.25, 0.25), r0_y_20.xxxx);
                float r0_y_21 = r0_xyzw_21.y;
                float r0_z_15 = r0_xyzw_21.z;
                float r0_w_13 = r0_xyzw_21.w;
                float4 r0_xyzw_22 = (float4(r0_y_21, r0_y_21, r0_z_15, r0_w_13) + float4(r2_x_12, r2_x_12, r2_y_12, r2_z_10));
                float r0_y_22 = r0_xyzw_22.y;
                float r0_z_16 = r0_xyzw_22.z;
                float r0_w_14 = r0_xyzw_22.w;
                o.sv_Target0.xyz = (mad((mad(r0_xy_4.y, r0_z_7, r0_x_5)).xxxx, float4(0.02, 0.02, 0.02, 0), float4(r0_y_22, r0_z_16, r0_w_14, r0_y_22))).xyz;
                float4 r0_xyzw_7 = (i.texcoord1.xyxx / i.texcoord1.wwww);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_23 = r0_xyzw_7.y;
                float4 r0_xyzw_8 = t4.Sample(sampler_linear_clamp4, (float4(r0_x_7, r0_y_23, r0_x_7, r0_x_7)).xy);
                o.sv_Target0.w = (saturate((saturate((((float4(1, 1, 1, 1) / mad(cb1_values[7].z, r0_xyzw_8.x, cb1_values[7].w)) + -i.texcoord5.x) / cb0_values[11].x)) * r1_w_12))).w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
        }
    }
    Fallback "Legacy Shaders/Transparent/Diffuse"
}
