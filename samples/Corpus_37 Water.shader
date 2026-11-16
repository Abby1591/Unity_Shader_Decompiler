Shader "Corpus/37 Water"
{
    Properties
    {
        _Color ("Water Color", Color) = (0.1,0.3,0.5,1)
        _NormalMap ("Normal Map", 2D) = "bump" {}
        _NormalScale ("Normal Scale", Float) = 1
        _WaveMap ("Wave Map", 2D) = "gray" {}
        _WaveSpeed ("Wave Speed", Vector) = (0.5,0.5,0,0)
        _WaveScale ("Wave Scale", Float) = 1
        _ReflectionCube ("Reflection", Cube) = "black" {}
        _ReflectionStrength ("Reflection Strength", Range(0, 1)) = 0.5
        _RefractionStrength ("Refraction Strength", Range(0, 0.2)) = 0.05
        _FresnelPower ("Fresnel Power", Range(0.1, 8)) = 4
        _DepthFade ("Depth Fade", Range(0.01, 10)) = 1
        _Specular ("Specular", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "IGNOREPROJECTOR"="true" "QUEUE"="Transparent" "RenderType"="Transparent" }
        GrabPass { "_WaterGrab" }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            HLSLPROGRAM
            #pragma target 3.5
            cbuffer _UnityPerCameraCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _NormalMap_ST : packoffset(c4);
                float4 _WaveMap_ST : packoffset(c5);
                float4 _WaterGrab_TexelSize : packoffset(c6);
                float4 _Color : packoffset(c7);
                float _NormalScale : packoffset(c8.x);
                float4 _WaveSpeed : packoffset(c9);
                float _WaveScale : packoffset(c10.x);
                float _ReflectionStrength : packoffset(c10.y);
                float _RefractionStrength : packoffset(c10.z);
                float _FresnelPower : packoffset(c10.w);
                float _DepthFade : packoffset(c11.x);
                float _Specular : packoffset(c11.y);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0 : packoffset(c0);
                float4x4 unity_MatrixV : packoffset(c9);
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_WaveMap;
            SamplerState sampler_NormalMap;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_ReflectionCube;
            SamplerState sampler_linear_clamp4;
            Texture2D _NormalMap;
            Texture2D _WaveMap;
            TextureCube _ReflectionCube;
            Texture2D _WaterGrab;
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
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                float3 worldPos_xyz_4 = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_1);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                float4 clipPos_xyzw_4 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                float r0_w_4 = (worldPos_xyzw_1.y * unity_MatrixV[1].z);
                float r0_w_5 = mad(unity_MatrixV[0].z, worldPos_xyzw_1.x, r0_w_4);
                float r0_w_6 = mad(unity_MatrixV[2].z, worldPos_xyzw_1.z, r0_w_5);
                float r0_w_7 = mad(unity_MatrixV[3].z, worldPos_xyzw_1.w, r0_w_6);
                o.texcoord5.x = -r0_w_7;
                o.texcoord0.xy = (i.texcoord0.xyxx).xy;
                float3 r1_xyz_2 = ((clipPos_xyzw_4.xwyx * float4(0.5, 0.5, -0.5, 0))).xyz;
                o.texcoord1.zw = (clipPos_xyzw_4.zzzw).zw;
                o.texcoord1.xy = ((r1_xyz_2.yyyy + r1_xyz_2.xzxx)).xy;
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord2.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord3.xyz = worldPos_xyz_4.xyz;
                o.texcoord4.xyz = ((-worldPos_xyz_4.xyzx + _NormalMap_ST.xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float2 r0_xy_1 = (mad(i.texcoord0.xyxx, float4(20, 20, 0, 0), unity_ObjectToWorld[0].yyyy)).xy;
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
                float4 r0_xyzw_5 = (_WaveSpeed.zzwz * unity_ObjectToWorld[0].yyyy);
                float r0_y_5 = r0_xyzw_5.y;
                float r0_z_8 = r0_xyzw_5.z;
                float4 uvWaveMap_xyzw_9 = mad(i.texcoord0.xyxx, _WaveMap_ST.xyxx, _WaveMap_ST.zwzz);
                float uvWaveMap_x_9 = uvWaveMap_xyzw_9.x;
                float uvWaveMap_y_11 = uvWaveMap_xyzw_9.y;
                float r0_y_6 = (mad(float4(uvWaveMap_x_9, uvWaveMap_x_9, uvWaveMap_y_11, uvWaveMap_x_9), float4(0, 1.37, 1.37, 0), -float4(r0_y_5, r0_y_5, r0_z_8, r0_y_5))).y;
                float r0_z_9 = (mad(float4(uvWaveMap_x_9, uvWaveMap_x_9, uvWaveMap_y_11, uvWaveMap_x_9), float4(0, 1.37, 1.37, 0), -float4(r0_y_5, r0_y_5, r0_z_8, r0_y_5))).z;
                float4 r1_xyzw_10 = mad(unity_ObjectToWorld[0].yyyy, _WaveSpeed.xyxx, float4(uvWaveMap_x_9, uvWaveMap_y_11, uvWaveMap_x_9, uvWaveMap_x_9));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_12 = r1_xyzw_10.y;
                float4 r1_xyzw_11 = _NormalMap.Sample(sampler_NormalMap, (float4(r1_x_10, r1_y_12, r1_x_10, r1_x_10)).xy);
                float4 r2_xyzw_8 = _NormalMap.Sample(sampler_NormalMap, (float4(r0_y_6, r0_z_9, r0_y_6, r0_y_6)).xy);
                float r0_y_7 = (r1_xyzw_11.x + r2_xyzw_8.x);
                float r0_y_8 = (r0_y_7 * _WaveScale);
                float2 uvNormalMap_zw_10 = (mad(i.texcoord0.xxxy, _NormalMap_ST.xxxy, _NormalMap_ST.zzzw)).zw;
                float4 r0_xyzw_9 = mad(r0_y_8.xxxx, float4(0, 0.05, 0.05, 0), uvNormalMap_zw_10.xxyx);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_11 = r0_xyzw_9.z;
                float4 r1_xyzw_12 = _WaveMap.Sample(sampler_WaveMap, (float4(r0_y_9, r0_z_11, r0_y_9, r0_y_9)).xy);
                float r1_x_13 = (r1_xyzw_12.w * r1_xyzw_12.x);
                float4 r0_xyzw_10 = mad(float4(r1_x_13, r1_x_13, r1_xyzw_12.y, r1_x_13), float4(0, 2, 2, 0), float4(0, -1, -1, 0));
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_12 = r0_xyzw_10.z;
                float4 r1_xyzw_14 = (float4(r0_y_10, r0_z_12, r0_y_10, r0_y_10) * _NormalScale.xxxx);
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
                float4 unitWorldPos_xyzw_19 = ((rsqrt(dot(i.texcoord4.xyzx, i.texcoord4.xyzx))).xxxx * i.texcoord4.xyzx);
                float unitWorldPos_x_19 = unitWorldPos_xyzw_19.x;
                float unitWorldPos_y_16 = unitWorldPos_xyzw_19.y;
                float unitWorldPos_z_7 = unitWorldPos_xyzw_19.z;
                float r1_w_4 = dot(-float4(unitWorldPos_x_19, unitWorldPos_y_16, unitWorldPos_z_7, unitWorldPos_x_19), float4(r0_y_15, r0_z_14, r0_w_12, r0_y_15));
                float r1_w_5 = (r1_w_4 + r1_w_4);
                float4 r2_xyzw_9 = mad(float4(r0_y_15, r0_z_14, r0_w_12, r0_y_15), -r1_w_5.xxxx, -float4(unitWorldPos_x_19, unitWorldPos_y_16, unitWorldPos_z_7, unitWorldPos_x_19));
                float r2_x_9 = r2_xyzw_9.x;
                float r2_y_9 = r2_xyzw_9.y;
                float r2_z_7 = r2_xyzw_9.z;
                float4 r2_xyzw_10 = _ReflectionCube.Sample(sampler_ReflectionCube, (float4(r2_x_9, r2_y_9, r2_z_7, r2_x_9)).xyz);
                float2 r3_xy_3 = ((((float4(r0_y_15, r0_z_14, r0_y_15, r0_y_15) * _RefractionStrength.xxxx)).xyxx * _WaterGrab_TexelSize.xyxx)).xy;
                float r3_z_2 = 0;
                float4 r3_xyzw_4 = (float4(r3_xy_3.x, r3_xy_3.y, r3_z_2, r3_xy_3.x) + i.texcoord1.xywx);
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_4 = r3_xyzw_4.y;
                float r3_z_3 = r3_xyzw_4.z;
                float4 r3_xyzw_6 = _WaterGrab.Sample(sampler_linear_clamp2, (((float4(r3_x_4, r3_y_4, r3_x_4, r3_x_4) / r3_z_3.xxxx)).xyxx).xy);
                float4 r2_xyzw_11 = mad(-_Color.xyzx, r3_xyzw_6.xyzx, r2_xyzw_10.xyzx);
                float r2_x_11 = r2_xyzw_11.x;
                float r2_y_11 = r2_xyzw_11.y;
                float r2_z_9 = r2_xyzw_11.z;
                float4 r3_xyzw_7 = (r3_xyzw_6.xyzx * _Color.xyzx);
                float r3_x_7 = r3_xyzw_7.x;
                float r3_y_7 = r3_xyzw_7.y;
                float r3_z_5 = r3_xyzw_7.z;
                float r1_w_6 = saturate(dot(float4(r0_y_15, r0_z_14, r0_w_12, r0_y_15), float4(unitWorldPos_x_19, unitWorldPos_y_16, unitWorldPos_z_7, unitWorldPos_x_19)));
                float r1_w_7 = (-r1_w_6 + 1);
                float r1_w_8 = log2(r1_w_7);
                float r1_w_9 = (r1_w_8 * _FresnelPower);
                float fresnel_w_10 = exp2(r1_w_9);
                float r2_w_6 = (fresnel_w_10 * _ReflectionStrength);
                float r1_w_11 = (fresnel_w_10 + 0.4);
                float r1_w_12 = (r1_w_11 * _Color.w);
                float4 r2_xyzw_12 = mad(r2_w_6.xxxx, float4(r2_x_11, r2_y_11, r2_z_9, r2_x_11), float4(r3_x_7, r3_y_7, r3_z_5, r3_x_7));
                float r2_x_12 = r2_xyzw_12.x;
                float r2_y_12 = r2_xyzw_12.y;
                float r2_z_10 = r2_xyzw_12.z;
                float4 r3_xyzw_8 = mad(-i.texcoord3.xyzx, _WorldSpaceLightPos0.wwww, _WorldSpaceLightPos0.xyzx);
                float r3_x_8 = r3_xyzw_8.x;
                float r3_y_8 = r3_xyzw_8.y;
                float r3_z_6 = r3_xyzw_8.z;
                float r2_w_7 = dot(float4(r3_x_8, r3_y_8, r3_z_6, r3_x_8), float4(r3_x_8, r3_y_8, r3_z_6, r3_x_8));
                float r2_w_8 = rsqrt(r2_w_7);
                float4 r1_xyzw_20 = mad(float4(r3_x_8, r3_y_8, r3_z_6, r3_x_8), r2_w_8.xxxx, float4(unitWorldPos_x_19, unitWorldPos_y_16, unitWorldPos_z_7, unitWorldPos_x_19));
                float r1_x_20 = r1_xyzw_20.x;
                float r1_y_17 = r1_xyzw_20.y;
                float r1_z_8 = r1_xyzw_20.z;
                float4 r3_xyzw_9 = (r2_w_8.xxxx * float4(r3_x_8, r3_y_8, r3_z_6, r3_x_8));
                float r3_x_9 = r3_xyzw_9.x;
                float r3_y_9 = r3_xyzw_9.y;
                float r3_z_7 = r3_xyzw_9.z;
                float r2_w_9 = saturate(dot(float4(r0_y_15, r0_z_14, r0_w_12, r0_y_15), float4(r3_x_9, r3_y_9, r3_z_7, r3_x_9)));
                float4 r3_xyzw_10 = (r2_w_9.xxxx * _LightColor0.xyzx);
                float r3_x_10 = r3_xyzw_10.x;
                float r3_y_10 = r3_xyzw_10.y;
                float r3_z_8 = r3_xyzw_10.z;
                float r2_w_10 = dot(float4(r1_x_20, r1_y_17, r1_z_8, r1_x_20), float4(r1_x_20, r1_y_17, r1_z_8, r1_x_20));
                float r2_w_11 = rsqrt(r2_w_10);
                float4 unitFresnel_xyzw_21 = (float4(r1_x_20, r1_y_17, r1_z_8, r1_x_20) * r2_w_11.xxxx);
                float unitFresnel_x_21 = unitFresnel_xyzw_21.x;
                float unitFresnel_y_18 = unitFresnel_xyzw_21.y;
                float unitFresnel_z_9 = unitFresnel_xyzw_21.z;
                float r0_y_16 = saturate(dot(float4(r0_y_15, r0_z_14, r0_w_12, r0_y_15), float4(unitFresnel_x_21, unitFresnel_y_18, unitFresnel_z_9, unitFresnel_x_21)));
                float r0_y_17 = log2(r0_y_16);
                float r0_y_18 = (r0_y_17 * 128);
                float r0_y_19 = exp2(r0_y_18);
                float r0_y_20 = (r0_y_19 * _Specular);
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
                float4 sampleNormalMap_xyzw_8 = t4.Sample(sampler_linear_clamp4, (float4(r0_x_7, r0_y_23, r0_x_7, r0_x_7)).xy);
                o.sv_Target0.w = (saturate((saturate((((float4(1, 1, 1, 1) / mad(unity_WorldToObject[3].z, sampleNormalMap_xyzw_8.x, unity_WorldToObject[3].w)) + -i.texcoord5.x) / _DepthFade)) * r1_w_12))).w;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Legacy Shaders/Transparent/Diffuse"
}
