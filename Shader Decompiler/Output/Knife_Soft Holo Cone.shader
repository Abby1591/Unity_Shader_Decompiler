Shader "Knife/Soft Holo Cone"
{
    Properties
    {
        _Softness ("Softness", Range(0, 1)) = 0
        _Color ("Color", Color) = (0,0,0,0)
        _Mask ("Mask", 2D) = "" {}
        _DepthFadeDistance ("DepthFadeDistance", Float) = 0
        _MaskSoftness ("MaskSoftness", Range(0, 1)) = 0
        _MaskSoftness2 ("MaskSoftness 2", Range(0, 1)) = 0
        _Mask2 ("Mask 2", 2D) = "" {}
        _Mask2Speed ("Mask2Speed", Vector) = (0,0,0,0)
        _Alpha ("Alpha", Range(0, 1)) = 1
        _texcoord ("", 2D) = "" {}
        __dirty ("", Float) = 1
    }
    SubShader
    {
        Tags { "IGNOREPROJECTOR"="true" "IsEmissive"="true" "QUEUE"="Transparent+0" "RenderType"="Transparent" }
        LOD 0
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "IsEmissive"="true" "LIGHTMODE"="FORWARDBASE" "QUEUE"="Transparent+0" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcColor
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _Color;
                float _MaskSoftness2;
                float2 _Mask2Speed;
                float4 _Mask2_ST;
                float _MaskSoftness;
                float4 _Mask_ST;
                float _Softness;
                float _DepthFadeDistance;
                float _Alpha;
                float4 _texcoord_ST;
            };
            cbuffer _UnityPerCameraCB : register(b1)
            {
                float4 _Time;
                float3 _WorldSpaceCameraPos;
                float4 _ProjectionParams;
                float4 _ZBufferParams;
            };
            cbuffer _UnityPerDrawCB : register(b2)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
            };
            cbuffer _UnityPerFrameCB : register(b3)
            {
                float4x4 unity_MatrixVP;
            };
            SamplerState sampler_Mask;
            SamplerState sampler_Mask2;
            SamplerState sampler_texcoord;
            Texture2D _Mask;
            Texture2D _Mask2;
            Texture2D _texcoord;
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
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program11Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program11Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program3Output vert(program3Input i)
            {
                program3Output o = (program3Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _texcoord_ST.xyxx, _texcoord_ST.zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float r0_y_8 = (clipPos_xyzw_7.y * _ProjectionParams.x);
                float4 r1_xyzw_3 = (float4(clipPos_xyzw_7.x, clipPos_xyzw_7.x, clipPos_xyzw_7.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_z_3 = r1_xyzw_3.z;
                float r1_w_4 = r1_xyzw_3.w;
                o.texcoord3.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord3.xy = ((r1_z_3.xxxx + float4(r1_x_3, r1_w_4, r1_x_3, r1_x_3))).xy;
                o.texcoord4.xyz = (float4(0, 0, 0, 0)).xyz;
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program11Output frag(program11Input i)
            {
                program11Output o = (program11Output)0;
                #define LinearEyeDepth(d) (1.0 / (_ZBufferParams.z * (d) + _ZBufferParams.w))
                float2 uvMask2_xy_1 = (mad(i.texcoord0.xyxx, _Mask2_ST.xyxx, _Mask2_ST.zwzz)).xy;
                float4 r0_xyzw_3 = _Mask.Sample(sampler_Mask, ((mad(_Time.yyyy, _Mask2Speed.xyxx, uvMask2_xy_1.xyxx)).xyxx).xy);
                float r0_y_4 = ((float4(1, 1, 1, 1) / _MaskSoftness2)).y;
                float r0_x_4 = saturate((r0_y_4 * r0_xyzw_3.x));
                float r0_y_5 = mad(r0_x_4, -2, 3);
                float4 uvMask_xyzw_6 = mad(i.texcoord0.xxyx, _Mask_ST.xxyx, _Mask_ST.zzwz);
                float uvMask_y_6 = uvMask_xyzw_6.y;
                float uvMask_z_2 = uvMask_xyzw_6.z;
                float4 sampleMask_xyzw_1 = _Mask2.Sample(sampler_Mask2, (float4(uvMask_y_6, uvMask_z_2, uvMask_y_6, uvMask_y_6)).xy);
                float r0_y_7 = ((float4(1, 1, 1, 1) / _MaskSoftness)).y;
                float r0_y_8 = saturate((r0_y_7 * sampleMask_xyzw_1.x));
                float r0_z_3 = mad(r0_y_8, -2, 3);
                float r0_y_9 = (r0_y_8 * r0_y_8);
                float r0_y_10 = (r0_y_9 * r0_z_3);
                float4 viewDir_xyzw_11 = (-i.texcoord2.xxyz + _WorldSpaceCameraPos.xxyz);
                float viewDir_y_11 = viewDir_xyzw_11.y;
                float viewDir_z_4 = viewDir_xyzw_11.z;
                float viewDir_w_2 = viewDir_xyzw_11.w;
                float4 unitViewDir_xyzw_12 = (float4(viewDir_y_11, viewDir_y_11, viewDir_z_4, viewDir_w_2) * (rsqrt(dot(float4(viewDir_y_11, viewDir_z_4, viewDir_w_2, viewDir_y_11), float4(viewDir_y_11, viewDir_z_4, viewDir_w_2, viewDir_y_11)))).xxxx);
                float unitViewDir_y_12 = unitViewDir_xyzw_12.y;
                float unitViewDir_z_5 = unitViewDir_xyzw_12.z;
                float unitViewDir_w_3 = unitViewDir_xyzw_12.w;
                float r0_y_13 = dot(i.texcoord1.xyzx, float4(unitViewDir_y_12, unitViewDir_z_5, unitViewDir_w_3, unitViewDir_y_12));
                float r0_z_6 = ((float4(1, 1, 1, 1) / _Softness)).z;
                float r0_y_14 = saturate((r0_z_6 * abs(r0_y_13)));
                float r0_z_7 = mad(r0_y_14, -2, 3);
                float r0_y_15 = (r0_y_14 * r0_y_14);
                float r0_y_16 = (r0_y_15 * r0_z_7);
                float r0_y_17 = (i.texcoord3.w + 1E-11);
                float4 r0_xyzw_18 = (i.texcoord3.xxyz / r0_y_17.xxxx);
                float r0_y_18 = r0_xyzw_18.y;
                float r0_z_8 = r0_xyzw_18.z;
                float r0_w_4 = r0_xyzw_18.w;
                float4 r1_xyzw_4 = _texcoord.Sample(sampler_texcoord, (float4(r0_y_18, r0_z_8, r0_y_18, r0_y_18)).xy);
                float r0_y_20 = LinearEyeDepth(r0_w_4);
                float r0_z_10 = LinearEyeDepth(r1_xyzw_4.x);
                float r0_y_21 = (-r0_y_20 + r0_z_10);
                float r0_y_22 = (r0_y_21 / _DepthFadeDistance);
                float r0_y_23 = min(abs(r0_y_22), 1);
                o.sv_Target0.w = ((r0_y_23 * (r0_y_16 * ((r0_y_10 * ((r0_x_4 * r0_x_4) * r0_y_5)) * _Color.w))) * _Alpha);
                o.sv_Target0.xyz = _Color.xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "IsEmissive"="true" "LIGHTMODE"="FORWARDBASE" "QUEUE"="Transparent+0" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcColor
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _Color;
                float _MaskSoftness2;
                float2 _Mask2Speed;
                float4 _Mask2_ST;
                float _MaskSoftness;
                float4 _Mask_ST;
                float _Softness;
                float _DepthFadeDistance;
                float _Alpha;
                float4 _texcoord_ST;
            };
            cbuffer _UnityPerCameraCB : register(b1)
            {
                float4 _Time;
                float3 _WorldSpaceCameraPos;
                float4 _ProjectionParams;
                float4 _ZBufferParams;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerDrawCB : register(b2)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb2_values[46];
            };
            cbuffer _UnityPerFrameCB : register(b3)
            {
                float4x4 unity_MatrixVP;
                float4 cb3_values[7];
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[21];
            };
            SamplerState sampler_Mask;
            SamplerState sampler_Mask2;
            SamplerState sampler_texcoord;
            Texture2D _Mask;
            Texture2D _Mask2;
            Texture2D _texcoord;
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
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program14Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program14Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program7Output vert(program7Input i)
            {
                program7Output o = (program7Output)0;
                float4 worldPos_xyzw_2 = mad(cb3_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb3_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb3_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb3_values[3].xyzw);
                o.texcoord2.xyz = (mad(cb3_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb4_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb4_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb4_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb4_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = mul(float4x4(cb4_values[17], cb4_values[18], cb4_values[19], cb4_values[20]), worldPos_xyzw_1);
                o.texcoord5.x = clipPos_xyzw_7.z;
                o.texcoord3.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _texcoord_ST.xyxx, _texcoord_ST.zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb3_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb3_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb3_values[6].xyzx);
                float r0_z_8 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r0_z_9 = rsqrt(r0_z_8);
                float3 unitWorldNormal_xyz_3 = ((r0_z_9.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = unitWorldNormal_xyz_3.xyz;
                float r0_y_8 = (clipPos_xyzw_7.y * _ProjectionParams.x);
                float4 r0_xyzw_8 = (clipPos_xyzw_7.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_z_10 = r0_xyzw_8.z;
                float r0_w_8 = (r0_y_8 * 0.5);
                o.texcoord3.xy = ((r0_z_10.xxxx + float4(r0_x_8, r0_w_8, r0_x_8, r0_x_8))).xy;
                float4 r2_xyzw_1 = (unitWorldNormal_xyz_3.yzzx * unitWorldNormal_xyz_3.xyzz);
                float r3_x_1 = dot(cb2_values[42].xyzw, r2_xyzw_1);
                float r3_y_1 = dot(cb2_values[43].xyzw, r2_xyzw_1);
                float r3_z_1 = dot(cb2_values[44].xyzw, r2_xyzw_1);
                float4 r0_xyzw_11 = mad(cb2_values[45].xyzx, (mad(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.x, (unitWorldNormal_xyz_3.y * unitWorldNormal_xyz_3.y))).xxxx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_y_9 = r0_xyzw_11.y;
                float r0_z_11 = r0_xyzw_11.z;
                float r1_w_2 = 1;
                float r2_x_2 = dot(cb2_values[39].xyzw, float4(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.y, unitWorldNormal_xyz_3.z, r1_w_2));
                float r2_y_2 = dot(cb2_values[40].xyzw, float4(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.y, unitWorldNormal_xyz_3.z, r1_w_2));
                float r2_z_2 = dot(cb2_values[41].xyzw, float4(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.y, unitWorldNormal_xyz_3.z, r1_w_2));
                float4 r0_xyzw_12 = (float4(r0_x_11, r0_y_9, r0_z_11, r0_x_11) + float4(r2_x_2, r2_y_2, r2_z_2, r2_x_2));
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_10 = r0_xyzw_12.y;
                float r0_z_12 = r0_xyzw_12.z;
                float4 r0_xyzw_13 = max(float4(r0_x_12, r0_y_10, r0_z_12, r0_x_12), float4(0, 0, 0, 0));
                float r0_x_13 = r0_xyzw_13.x;
                float r0_y_11 = r0_xyzw_13.y;
                float r0_z_13 = r0_xyzw_13.z;
                float4 r0_xyzw_14 = log2(float4(r0_x_13, r0_y_11, r0_z_13, r0_x_13));
                float r0_x_14 = r0_xyzw_14.x;
                float r0_y_12 = r0_xyzw_14.y;
                float r0_z_14 = r0_xyzw_14.z;
                float4 r0_xyzw_15 = (float4(r0_x_14, r0_y_12, r0_z_14, r0_x_14) * float4(0.41666666, 0.41666666, 0.41666666, 0));
                float r0_x_15 = r0_xyzw_15.x;
                float r0_y_13 = r0_xyzw_15.y;
                float r0_z_15 = r0_xyzw_15.z;
                float4 r0_xyzw_16 = exp2(float4(r0_x_15, r0_y_13, r0_z_15, r0_x_15));
                float r0_x_16 = r0_xyzw_16.x;
                float r0_y_14 = r0_xyzw_16.y;
                float r0_z_16 = r0_xyzw_16.z;
                float4 r0_xyzw_17 = mad(float4(r0_x_16, r0_y_14, r0_z_16, r0_x_16), float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0));
                float r0_x_17 = r0_xyzw_17.x;
                float r0_y_15 = r0_xyzw_17.y;
                float r0_z_17 = r0_xyzw_17.z;
                o.texcoord4.xyz = (max(float4(r0_x_17, r0_y_15, r0_z_17, r0_x_17), float4(0, 0, 0, 0))).xyz;
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program14Output frag(program14Input i)
            {
                program14Output o = (program14Output)0;
                #define LinearEyeDepth(d) (1.0 / (_ZBufferParams.z * (d) + _ZBufferParams.w))
                float2 uvMask2_xy_1 = (mad(i.texcoord0.xyxx, _Mask2_ST.xyxx, _Mask2_ST.zwzz)).xy;
                float4 r0_xyzw_3 = _Mask.Sample(sampler_Mask, ((mad(_Time.yyyy, _Mask2Speed.xyxx, uvMask2_xy_1.xyxx)).xyxx).xy);
                float r0_y_4 = ((float4(1, 1, 1, 1) / _MaskSoftness2)).y;
                float r0_x_4 = saturate((r0_y_4 * r0_xyzw_3.x));
                float r0_y_5 = mad(r0_x_4, -2, 3);
                float4 uvMask_xyzw_6 = mad(i.texcoord0.xxyx, _Mask_ST.xxyx, _Mask_ST.zzwz);
                float uvMask_y_6 = uvMask_xyzw_6.y;
                float uvMask_z_2 = uvMask_xyzw_6.z;
                float4 sampleMask_xyzw_1 = _Mask2.Sample(sampler_Mask2, (float4(uvMask_y_6, uvMask_z_2, uvMask_y_6, uvMask_y_6)).xy);
                float r0_y_7 = ((float4(1, 1, 1, 1) / _MaskSoftness)).y;
                float r0_y_8 = saturate((r0_y_7 * sampleMask_xyzw_1.x));
                float r0_z_3 = mad(r0_y_8, -2, 3);
                float r0_y_9 = (r0_y_8 * r0_y_8);
                float r0_y_10 = (r0_y_9 * r0_z_3);
                float4 viewDir_xyzw_11 = (-i.texcoord2.xxyz + _WorldSpaceCameraPos.xxyz);
                float viewDir_y_11 = viewDir_xyzw_11.y;
                float viewDir_z_4 = viewDir_xyzw_11.z;
                float viewDir_w_2 = viewDir_xyzw_11.w;
                float4 unitViewDir_xyzw_12 = (float4(viewDir_y_11, viewDir_y_11, viewDir_z_4, viewDir_w_2) * (rsqrt(dot(float4(viewDir_y_11, viewDir_z_4, viewDir_w_2, viewDir_y_11), float4(viewDir_y_11, viewDir_z_4, viewDir_w_2, viewDir_y_11)))).xxxx);
                float unitViewDir_y_12 = unitViewDir_xyzw_12.y;
                float unitViewDir_z_5 = unitViewDir_xyzw_12.z;
                float unitViewDir_w_3 = unitViewDir_xyzw_12.w;
                float r0_y_13 = dot(i.texcoord1.xyzx, float4(unitViewDir_y_12, unitViewDir_z_5, unitViewDir_w_3, unitViewDir_y_12));
                float r0_z_6 = ((float4(1, 1, 1, 1) / _Softness)).z;
                float r0_y_14 = saturate((r0_z_6 * abs(r0_y_13)));
                float r0_z_7 = mad(r0_y_14, -2, 3);
                float r0_y_15 = (r0_y_14 * r0_y_14);
                float r0_y_16 = (r0_y_15 * r0_z_7);
                float r0_y_17 = (i.texcoord3.w + 1E-11);
                float4 r0_xyzw_18 = (i.texcoord3.xxyz / r0_y_17.xxxx);
                float r0_y_18 = r0_xyzw_18.y;
                float r0_z_8 = r0_xyzw_18.z;
                float r0_w_4 = r0_xyzw_18.w;
                float4 r1_xyzw_4 = _texcoord.Sample(sampler_texcoord, (float4(r0_y_18, r0_z_8, r0_y_18, r0_y_18)).xy);
                float r0_y_20 = LinearEyeDepth(r0_w_4);
                float r0_z_10 = LinearEyeDepth(r1_xyzw_4.x);
                float r0_y_21 = (-r0_y_20 + r0_z_10);
                float r0_y_22 = (r0_y_21 / _DepthFadeDistance);
                float r0_y_23 = min(abs(r0_y_22), 1);
                o.sv_Target0.w = ((r0_y_23 * (r0_y_16 * ((r0_y_10 * ((r0_x_4 * r0_x_4) * r0_y_5)) * _Color.w))) * _Alpha);
                float r0_x_15 = saturate(mad(max((((i.texcoord5.x / cb1_values[5].y) + 1) * cb1_values[5].z), 0), cb2_values[1].z, cb2_values[1].w));
                float4 r0_xyzw_24 = (_Color.xxyz + -cb2_values[0].xxyz);
                float r0_y_24 = r0_xyzw_24.y;
                float r0_z_11 = r0_xyzw_24.z;
                float r0_w_5 = r0_xyzw_24.w;
                o.sv_Target0.xyz = (mad(r0_x_15.xxxx, float4(r0_y_24, r0_z_11, r0_w_5, r0_y_24), cb2_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "IsEmissive"="true" "LIGHTMODE"="FORWARDBASE" "QUEUE"="Transparent+0" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcColor
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _Color;
                float _MaskSoftness2;
                float2 _Mask2Speed;
                float4 _Mask2_ST;
                float _MaskSoftness;
                float4 _Mask_ST;
                float _Softness;
                float _DepthFadeDistance;
                float _Alpha;
                float4 _texcoord_ST;
            };
            cbuffer _UnityPerCameraCB : register(b1)
            {
                float4 _Time;
                float3 _WorldSpaceCameraPos;
                float4 _ProjectionParams;
                float4 _ZBufferParams;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerDrawCB : register(b2)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb2_values[2];
            };
            cbuffer _UnityPerFrameCB : register(b3)
            {
                float4x4 unity_MatrixVP;
            };
            SamplerState sampler_Mask;
            SamplerState sampler_Mask2;
            SamplerState sampler_texcoord;
            Texture2D _Mask;
            Texture2D _Mask2;
            Texture2D _texcoord;
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
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program13Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program13Output
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
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord5.x = clipPos_xyzw_7.z;
                o.texcoord3.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _texcoord_ST.xyxx, _texcoord_ST.zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_z_8 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r0_z_9 = rsqrt(r0_z_8);
                o.texcoord1.xyz = ((r0_z_9.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float r0_y_8 = (clipPos_xyzw_7.y * _ProjectionParams.x);
                float4 r0_xyzw_8 = (clipPos_xyzw_7.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_z_10 = r0_xyzw_8.z;
                float r0_w_8 = (r0_y_8 * 0.5);
                o.texcoord3.xy = ((r0_z_10.xxxx + float4(r0_x_8, r0_w_8, r0_x_8, r0_x_8))).xy;
                o.texcoord4.xyz = (float4(0, 0, 0, 0)).xyz;
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program13Output frag(program13Input i)
            {
                program13Output o = (program13Output)0;
                #define LinearEyeDepth(d) (1.0 / (_ZBufferParams.z * (d) + _ZBufferParams.w))
                float2 uvMask2_xy_1 = (mad(i.texcoord0.xyxx, _Mask2_ST.xyxx, _Mask2_ST.zwzz)).xy;
                float4 r0_xyzw_3 = _Mask.Sample(sampler_Mask, ((mad(_Time.yyyy, _Mask2Speed.xyxx, uvMask2_xy_1.xyxx)).xyxx).xy);
                float r0_y_4 = ((float4(1, 1, 1, 1) / _MaskSoftness2)).y;
                float r0_x_4 = saturate((r0_y_4 * r0_xyzw_3.x));
                float r0_y_5 = mad(r0_x_4, -2, 3);
                float4 uvMask_xyzw_6 = mad(i.texcoord0.xxyx, _Mask_ST.xxyx, _Mask_ST.zzwz);
                float uvMask_y_6 = uvMask_xyzw_6.y;
                float uvMask_z_2 = uvMask_xyzw_6.z;
                float4 sampleMask_xyzw_1 = _Mask2.Sample(sampler_Mask2, (float4(uvMask_y_6, uvMask_z_2, uvMask_y_6, uvMask_y_6)).xy);
                float r0_y_7 = ((float4(1, 1, 1, 1) / _MaskSoftness)).y;
                float r0_y_8 = saturate((r0_y_7 * sampleMask_xyzw_1.x));
                float r0_z_3 = mad(r0_y_8, -2, 3);
                float r0_y_9 = (r0_y_8 * r0_y_8);
                float r0_y_10 = (r0_y_9 * r0_z_3);
                float4 viewDir_xyzw_11 = (-i.texcoord2.xxyz + _WorldSpaceCameraPos.xxyz);
                float viewDir_y_11 = viewDir_xyzw_11.y;
                float viewDir_z_4 = viewDir_xyzw_11.z;
                float viewDir_w_2 = viewDir_xyzw_11.w;
                float4 unitViewDir_xyzw_12 = (float4(viewDir_y_11, viewDir_y_11, viewDir_z_4, viewDir_w_2) * (rsqrt(dot(float4(viewDir_y_11, viewDir_z_4, viewDir_w_2, viewDir_y_11), float4(viewDir_y_11, viewDir_z_4, viewDir_w_2, viewDir_y_11)))).xxxx);
                float unitViewDir_y_12 = unitViewDir_xyzw_12.y;
                float unitViewDir_z_5 = unitViewDir_xyzw_12.z;
                float unitViewDir_w_3 = unitViewDir_xyzw_12.w;
                float r0_y_13 = dot(i.texcoord1.xyzx, float4(unitViewDir_y_12, unitViewDir_z_5, unitViewDir_w_3, unitViewDir_y_12));
                float r0_z_6 = ((float4(1, 1, 1, 1) / _Softness)).z;
                float r0_y_14 = saturate((r0_z_6 * abs(r0_y_13)));
                float r0_z_7 = mad(r0_y_14, -2, 3);
                float r0_y_15 = (r0_y_14 * r0_y_14);
                float r0_y_16 = (r0_y_15 * r0_z_7);
                float r0_y_17 = (i.texcoord3.w + 1E-11);
                float4 r0_xyzw_18 = (i.texcoord3.xxyz / r0_y_17.xxxx);
                float r0_y_18 = r0_xyzw_18.y;
                float r0_z_8 = r0_xyzw_18.z;
                float r0_w_4 = r0_xyzw_18.w;
                float4 r1_xyzw_4 = _texcoord.Sample(sampler_texcoord, (float4(r0_y_18, r0_z_8, r0_y_18, r0_y_18)).xy);
                float r0_y_20 = LinearEyeDepth(r0_w_4);
                float r0_z_10 = LinearEyeDepth(r1_xyzw_4.x);
                float r0_y_21 = (-r0_y_20 + r0_z_10);
                float r0_y_22 = (r0_y_21 / _DepthFadeDistance);
                float r0_y_23 = min(abs(r0_y_22), 1);
                o.sv_Target0.w = ((r0_y_23 * (r0_y_16 * ((r0_y_10 * ((r0_x_4 * r0_x_4) * r0_y_5)) * _Color.w))) * _Alpha);
                float r0_x_15 = saturate(mad(max((((i.texcoord5.x / cb1_values[5].y) + 1) * cb1_values[5].z), 0), cb2_values[1].z, cb2_values[1].w));
                float4 r0_xyzw_24 = (_Color.xxyz + -cb2_values[0].xxyz);
                float r0_y_24 = r0_xyzw_24.y;
                float r0_z_11 = r0_xyzw_24.z;
                float r0_w_5 = r0_xyzw_24.w;
                o.sv_Target0.xyz = (mad(r0_x_15.xxxx, float4(r0_y_24, r0_z_11, r0_w_5, r0_y_24), cb2_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "IsEmissive"="true" "LIGHTMODE"="FORWARDBASE" "QUEUE"="Transparent+0" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcColor
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _Color;
                float _MaskSoftness2;
                float2 _Mask2Speed;
                float4 _Mask2_ST;
                float _MaskSoftness;
                float4 _Mask_ST;
                float _Softness;
                float _DepthFadeDistance;
                float _Alpha;
                float4 _texcoord_ST;
            };
            cbuffer _UnityPerCameraCB : register(b1)
            {
                float4 _Time;
                float3 _WorldSpaceCameraPos;
                float4 _ProjectionParams;
                float4 _ZBufferParams;
            };
            cbuffer _UnityPerDrawCB : register(b2)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb2_values[46];
            };
            cbuffer _UnityPerFrameCB : register(b3)
            {
                float4x4 unity_MatrixVP;
                float4 cb3_values[7];
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[21];
            };
            SamplerState sampler_Mask;
            SamplerState sampler_Mask2;
            SamplerState sampler_texcoord;
            Texture2D _Mask;
            Texture2D _Mask2;
            Texture2D _texcoord;
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
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program12Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program12Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program4Output vert(program4Input i)
            {
                program4Output o = (program4Output)0;
                float4 worldPos_xyzw_2 = mad(cb3_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb3_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb3_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb3_values[3].xyzw);
                o.texcoord2.xyz = (mad(cb3_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb4_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb4_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb4_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb4_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = mul(float4x4(cb4_values[17], cb4_values[18], cb4_values[19], cb4_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _texcoord_ST.xyxx, _texcoord_ST.zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb3_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb3_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb3_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                float3 unitWorldNormal_xyz_3 = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = unitWorldNormal_xyz_3.xyz;
                float r0_y_8 = (clipPos_xyzw_7.y * _ProjectionParams.x);
                float3 r2_xzw_1 = ((float4(clipPos_xyzw_7.x, clipPos_xyzw_7.x, clipPos_xyzw_7.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5))).xzw;
                o.texcoord3.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord3.xy = ((r2_xzw_1.yyyy + r2_xzw_1.xzxx)).xy;
                float4 r2_xyzw_2 = (unitWorldNormal_xyz_3.yzzx * unitWorldNormal_xyz_3.xyzz);
                float r3_x_1 = dot(cb2_values[42].xyzw, r2_xyzw_2);
                float r3_y_1 = dot(cb2_values[43].xyzw, r2_xyzw_2);
                float r3_z_1 = dot(cb2_values[44].xyzw, r2_xyzw_2);
                float4 r0_xyzw_10 = mad(cb2_values[45].xyzx, (mad(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.x, (unitWorldNormal_xyz_3.y * unitWorldNormal_xyz_3.y))).xxxx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_9 = r0_xyzw_10.y;
                float r0_z_8 = r0_xyzw_10.z;
                float r1_w_4 = 1;
                float r2_x_3 = dot(cb2_values[39].xyzw, float4(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.y, unitWorldNormal_xyz_3.z, r1_w_4));
                float r2_y_2 = dot(cb2_values[40].xyzw, float4(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.y, unitWorldNormal_xyz_3.z, r1_w_4));
                float r2_z_3 = dot(cb2_values[41].xyzw, float4(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.y, unitWorldNormal_xyz_3.z, r1_w_4));
                float4 r0_xyzw_11 = (float4(r0_x_10, r0_y_9, r0_z_8, r0_x_10) + float4(r2_x_3, r2_y_2, r2_z_3, r2_x_3));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_y_10 = r0_xyzw_11.y;
                float r0_z_9 = r0_xyzw_11.z;
                float4 r0_xyzw_12 = max(float4(r0_x_11, r0_y_10, r0_z_9, r0_x_11), float4(0, 0, 0, 0));
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_11 = r0_xyzw_12.y;
                float r0_z_10 = r0_xyzw_12.z;
                float4 r0_xyzw_13 = log2(float4(r0_x_12, r0_y_11, r0_z_10, r0_x_12));
                float r0_x_13 = r0_xyzw_13.x;
                float r0_y_12 = r0_xyzw_13.y;
                float r0_z_11 = r0_xyzw_13.z;
                float4 r0_xyzw_14 = (float4(r0_x_13, r0_y_12, r0_z_11, r0_x_13) * float4(0.41666666, 0.41666666, 0.41666666, 0));
                float r0_x_14 = r0_xyzw_14.x;
                float r0_y_13 = r0_xyzw_14.y;
                float r0_z_12 = r0_xyzw_14.z;
                float4 r0_xyzw_15 = exp2(float4(r0_x_14, r0_y_13, r0_z_12, r0_x_14));
                float r0_x_15 = r0_xyzw_15.x;
                float r0_y_14 = r0_xyzw_15.y;
                float r0_z_13 = r0_xyzw_15.z;
                float4 r0_xyzw_16 = mad(float4(r0_x_15, r0_y_14, r0_z_13, r0_x_15), float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0));
                float r0_x_16 = r0_xyzw_16.x;
                float r0_y_15 = r0_xyzw_16.y;
                float r0_z_14 = r0_xyzw_16.z;
                o.texcoord4.xyz = (max(float4(r0_x_16, r0_y_15, r0_z_14, r0_x_16), float4(0, 0, 0, 0))).xyz;
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program12Output frag(program12Input i)
            {
                program12Output o = (program12Output)0;
                #define LinearEyeDepth(d) (1.0 / (_ZBufferParams.z * (d) + _ZBufferParams.w))
                float2 uvMask2_xy_1 = (mad(i.texcoord0.xyxx, _Mask2_ST.xyxx, _Mask2_ST.zwzz)).xy;
                float4 r0_xyzw_3 = _Mask.Sample(sampler_Mask, ((mad(_Time.yyyy, _Mask2Speed.xyxx, uvMask2_xy_1.xyxx)).xyxx).xy);
                float r0_y_4 = ((float4(1, 1, 1, 1) / _MaskSoftness2)).y;
                float r0_x_4 = saturate((r0_y_4 * r0_xyzw_3.x));
                float r0_y_5 = mad(r0_x_4, -2, 3);
                float4 uvMask_xyzw_6 = mad(i.texcoord0.xxyx, _Mask_ST.xxyx, _Mask_ST.zzwz);
                float uvMask_y_6 = uvMask_xyzw_6.y;
                float uvMask_z_2 = uvMask_xyzw_6.z;
                float4 sampleMask_xyzw_1 = _Mask2.Sample(sampler_Mask2, (float4(uvMask_y_6, uvMask_z_2, uvMask_y_6, uvMask_y_6)).xy);
                float r0_y_7 = ((float4(1, 1, 1, 1) / _MaskSoftness)).y;
                float r0_y_8 = saturate((r0_y_7 * sampleMask_xyzw_1.x));
                float r0_z_3 = mad(r0_y_8, -2, 3);
                float r0_y_9 = (r0_y_8 * r0_y_8);
                float r0_y_10 = (r0_y_9 * r0_z_3);
                float4 viewDir_xyzw_11 = (-i.texcoord2.xxyz + _WorldSpaceCameraPos.xxyz);
                float viewDir_y_11 = viewDir_xyzw_11.y;
                float viewDir_z_4 = viewDir_xyzw_11.z;
                float viewDir_w_2 = viewDir_xyzw_11.w;
                float4 unitViewDir_xyzw_12 = (float4(viewDir_y_11, viewDir_y_11, viewDir_z_4, viewDir_w_2) * (rsqrt(dot(float4(viewDir_y_11, viewDir_z_4, viewDir_w_2, viewDir_y_11), float4(viewDir_y_11, viewDir_z_4, viewDir_w_2, viewDir_y_11)))).xxxx);
                float unitViewDir_y_12 = unitViewDir_xyzw_12.y;
                float unitViewDir_z_5 = unitViewDir_xyzw_12.z;
                float unitViewDir_w_3 = unitViewDir_xyzw_12.w;
                float r0_y_13 = dot(i.texcoord1.xyzx, float4(unitViewDir_y_12, unitViewDir_z_5, unitViewDir_w_3, unitViewDir_y_12));
                float r0_z_6 = ((float4(1, 1, 1, 1) / _Softness)).z;
                float r0_y_14 = saturate((r0_z_6 * abs(r0_y_13)));
                float r0_z_7 = mad(r0_y_14, -2, 3);
                float r0_y_15 = (r0_y_14 * r0_y_14);
                float r0_y_16 = (r0_y_15 * r0_z_7);
                float r0_y_17 = (i.texcoord3.w + 1E-11);
                float4 r0_xyzw_18 = (i.texcoord3.xxyz / r0_y_17.xxxx);
                float r0_y_18 = r0_xyzw_18.y;
                float r0_z_8 = r0_xyzw_18.z;
                float r0_w_4 = r0_xyzw_18.w;
                float4 r1_xyzw_4 = _texcoord.Sample(sampler_texcoord, (float4(r0_y_18, r0_z_8, r0_y_18, r0_y_18)).xy);
                float r0_y_20 = LinearEyeDepth(r0_w_4);
                float r0_z_10 = LinearEyeDepth(r1_xyzw_4.x);
                float r0_y_21 = (-r0_y_20 + r0_z_10);
                float r0_y_22 = (r0_y_21 / _DepthFadeDistance);
                float r0_y_23 = min(abs(r0_y_22), 1);
                o.sv_Target0.w = ((r0_y_23 * (r0_y_16 * ((r0_y_10 * ((r0_x_4 * r0_x_4) * r0_y_5)) * _Color.w))) * _Alpha);
                o.sv_Target0.xyz = _Color.xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "IsEmissive"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent+0" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _Color;
                float _MaskSoftness2;
                float2 _Mask2Speed;
                float4 _Mask2_ST;
                float _MaskSoftness;
                float4 _Mask_ST;
                float _Softness;
                float _DepthFadeDistance;
                float _Alpha;
                float4 _texcoord_ST;
                float4 cb0_values[17];
            };
            cbuffer _UnityPerCameraCB : register(b1)
            {
                float4 _Time;
                float3 _WorldSpaceCameraPos;
                float4 _ProjectionParams;
                float4 _ZBufferParams;
            };
            cbuffer _UnityPerDrawCB : register(b2)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
            };
            cbuffer _UnityPerFrameCB : register(b3)
            {
                float4x4 unity_MatrixVP;
            };
            SamplerState sampler_Mask;
            SamplerState sampler_Mask2;
            SamplerState sampler_texcoord;
            Texture2D _Mask;
            Texture2D _Mask2;
            Texture2D _texcoord;
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
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
            };
            struct program29Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
            };
            struct program29Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program17Output vert(program17Input i)
            {
                program17Output o = (program17Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[16].xyxx, cb0_values[16].zwzz)).xy;
                float worldNormal_x_4 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r2_w_4 = dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4));
                float r2_w_5 = rsqrt(r2_w_4);
                o.texcoord1.xyz = ((r2_w_5.xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float r1_y_3 = (clipPos_xyzw_2.y * _ProjectionParams.x);
                float4 r2_xyzw_5 = (float4(clipPos_xyzw_2.x, clipPos_xyzw_2.x, clipPos_xyzw_2.w, r1_y_3) * float4(0.5, 0, 0.5, 0.5));
                float r2_x_5 = r2_xyzw_5.x;
                float r2_z_5 = r2_xyzw_5.z;
                float r2_w_6 = r2_xyzw_5.w;
                o.texcoord3.zw = (clipPos_xyzw_2.zzzw).zw;
                o.texcoord3.xy = ((r2_z_5.xxxx + float4(r2_x_5, r2_w_6, r2_x_5, r2_x_5))).xy;
                float clipPos_x_3 = ((worldPos_xyzw_4.yyyy * cb0_values[3].xyzx)).x;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_4.yyyy * cb0_values[3].xyzx);
                float clipPos_y_4 = clipPos_xyzw_4.y;
                float clipPos_z_3 = clipPos_xyzw_4.z;
                float clipPos_x_4 = (mad(cb0_values[2].xyzx, worldPos_xyzw_4.xxxx, float4(clipPos_x_3, clipPos_y_4, clipPos_z_3, clipPos_x_3))).x;
                float4 clipPos_xyzw_5 = mad(cb0_values[2].xyzx, worldPos_xyzw_4.xxxx, float4(clipPos_x_3, clipPos_y_4, clipPos_z_3, clipPos_x_3));
                float clipPos_y_5 = clipPos_xyzw_5.y;
                float clipPos_z_4 = clipPos_xyzw_5.z;
                float3 clipPos_xyz_5 = (mad(_Color.xyzx, worldPos_xyzw_4.zzzz, float4(clipPos_x_4, clipPos_y_5, clipPos_z_4, clipPos_x_4))).xyz;
                o.texcoord4.xyz = (mad(cb0_values[5].xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program29Output frag(program29Input i)
            {
                program29Output o = (program29Output)0;
                #define LinearEyeDepth(d) (1.0 / (_ZBufferParams.z * (d) + _ZBufferParams.w))
                float4 r0_xyzw_3 = _Mask.Sample(sampler_Mask, ((mad(_Time.yyyy, cb0_values[9].yzyy, (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xyxx)).xyxx).xy);
                float r0_y_4 = ((float4(1, 1, 1, 1) / _Softness)).y;
                float r0_x_4 = saturate((r0_y_4 * r0_xyzw_3.x));
                float r0_y_5 = mad(r0_x_4, -2, 3);
                float4 uvTexcoord_xyzw_6 = mad(i.texcoord0.xxyx, _texcoord_ST.xxyx, _texcoord_ST.zzwz);
                float uvTexcoord_y_6 = uvTexcoord_xyzw_6.y;
                float uvTexcoord_z_2 = uvTexcoord_xyzw_6.z;
                float4 sampleTexcoord_xyzw_1 = _Mask2.Sample(sampler_Mask2, (float4(uvTexcoord_y_6, uvTexcoord_z_2, uvTexcoord_y_6, uvTexcoord_y_6)).xy);
                float r0_y_7 = ((float4(1, 1, 1, 1) / _DepthFadeDistance)).y;
                float r0_y_8 = saturate((r0_y_7 * sampleTexcoord_xyzw_1.x));
                float r0_z_3 = mad(r0_y_8, -2, 3);
                float r0_y_9 = (r0_y_8 * r0_y_8);
                float r0_y_10 = (r0_y_9 * r0_z_3);
                float4 viewDir_xyzw_11 = (-i.texcoord2.xxyz + _WorldSpaceCameraPos.xxyz);
                float viewDir_y_11 = viewDir_xyzw_11.y;
                float viewDir_z_4 = viewDir_xyzw_11.z;
                float viewDir_w_2 = viewDir_xyzw_11.w;
                float4 unitViewDir_xyzw_12 = (float4(viewDir_y_11, viewDir_y_11, viewDir_z_4, viewDir_w_2) * (rsqrt(dot(float4(viewDir_y_11, viewDir_z_4, viewDir_w_2, viewDir_y_11), float4(viewDir_y_11, viewDir_z_4, viewDir_w_2, viewDir_y_11)))).xxxx);
                float unitViewDir_y_12 = unitViewDir_xyzw_12.y;
                float unitViewDir_z_5 = unitViewDir_xyzw_12.z;
                float unitViewDir_w_3 = unitViewDir_xyzw_12.w;
                float r0_y_13 = dot(i.texcoord1.xyzx, float4(unitViewDir_y_12, unitViewDir_z_5, unitViewDir_w_3, unitViewDir_y_12));
                float r0_z_6 = ((float4(1, 1, 1, 1) / cb0_values[13].x)).z;
                float r0_y_14 = saturate((r0_z_6 * abs(r0_y_13)));
                float r0_z_7 = mad(r0_y_14, -2, 3);
                float r0_y_15 = (r0_y_14 * r0_y_14);
                float r0_y_16 = (r0_y_15 * r0_z_7);
                float r0_y_17 = (i.texcoord3.w + 1E-11);
                float4 r0_xyzw_18 = (i.texcoord3.xxyz / r0_y_17.xxxx);
                float r0_y_18 = r0_xyzw_18.y;
                float r0_z_8 = r0_xyzw_18.z;
                float r0_w_4 = r0_xyzw_18.w;
                float4 r1_xyzw_4 = _texcoord.Sample(sampler_texcoord, (float4(r0_y_18, r0_z_8, r0_y_18, r0_y_18)).xy);
                float r0_y_20 = LinearEyeDepth(r0_w_4);
                float r0_z_10 = LinearEyeDepth(r1_xyzw_4.x);
                float r0_y_21 = (-r0_y_20 + r0_z_10);
                float r0_y_22 = (r0_y_21 / cb0_values[15].x);
                float r0_y_23 = min(abs(r0_y_22), 1);
                o.sv_Target0.w = ((r0_y_23 * (r0_y_16 * ((r0_y_10 * ((r0_x_4 * r0_x_4) * r0_y_5)) * _Mask_ST.w))) * cb0_values[15].y);
                o.sv_Target0.xyz = (float4(0, 0, 0, 0)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "IsEmissive"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent+0" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _Color;
                float _MaskSoftness2;
                float2 _Mask2Speed;
                float4 _Mask2_ST;
                float _MaskSoftness;
                float4 _Mask_ST;
                float _Softness;
                float _DepthFadeDistance;
                float _Alpha;
                float4 _texcoord_ST;
                float4 cb0_values[17];
            };
            cbuffer _UnityPerCameraCB : register(b1)
            {
                float4 _Time;
                float3 _WorldSpaceCameraPos;
                float4 _ProjectionParams;
                float4 _ZBufferParams;
            };
            cbuffer _UnityPerDrawCB : register(b2)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
            };
            cbuffer _UnityPerFrameCB : register(b3)
            {
                float4x4 unity_MatrixVP;
            };
            SamplerState sampler_Mask;
            SamplerState sampler_Mask2;
            SamplerState sampler_texcoord;
            Texture2D _Mask;
            Texture2D _Mask2;
            Texture2D _texcoord;
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
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program38Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program38Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program26Output vert(program26Input i)
            {
                program26Output o = (program26Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float2 clipPos_xy_4 = ((worldPos_xyzw_4.yyyy * cb0_values[3].xyxx)).xy;
                float2 clipPos_xy_5 = (mad(cb0_values[2].xyxx, worldPos_xyzw_4.xxxx, clipPos_xy_4.xyxx)).xy;
                float2 clipPos_xy_6 = (mad(_Color.xyxx, worldPos_xyzw_4.zzzz, clipPos_xy_5.xyxx)).xy;
                o.texcoord4.xy = (mad(cb0_values[5].xxxy, worldPos_xyzw_4.wwww, clipPos_xy_6.xxxy)).zw;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[16].xyxx, cb0_values[16].zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_4 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7));
                float r0_w_5 = rsqrt(r0_w_4);
                o.texcoord1.xyz = ((r0_w_5.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7))).xyz;
                o.texcoord5.x = clipPos_xyzw_2.z;
                float r0_w_6 = ((clipPos_xyzw_2.y * _ProjectionParams.x) * 0.5);
                float4 r0_xyzw_9 = (clipPos_xyzw_2.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                o.texcoord3.zw = (clipPos_xyzw_2.zzzw).zw;
                o.texcoord3.xy = ((r0_z_5.xxxx + float4(r0_x_9, r0_w_6, r0_x_9, r0_x_9))).xy;
                return o;
            }
            #pragma fragment frag
            program38Output frag(program38Input i)
            {
                program38Output o = (program38Output)0;
                #define LinearEyeDepth(d) (1.0 / (_ZBufferParams.z * (d) + _ZBufferParams.w))
                float4 r0_xyzw_3 = _Mask.Sample(sampler_Mask, ((mad(_Time.yyyy, cb0_values[9].yzyy, (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xyxx)).xyxx).xy);
                float r0_y_4 = ((float4(1, 1, 1, 1) / _Softness)).y;
                float r0_x_4 = saturate((r0_y_4 * r0_xyzw_3.x));
                float r0_y_5 = mad(r0_x_4, -2, 3);
                float4 uvTexcoord_xyzw_6 = mad(i.texcoord0.xxyx, _texcoord_ST.xxyx, _texcoord_ST.zzwz);
                float uvTexcoord_y_6 = uvTexcoord_xyzw_6.y;
                float uvTexcoord_z_2 = uvTexcoord_xyzw_6.z;
                float4 sampleTexcoord_xyzw_1 = _Mask2.Sample(sampler_Mask2, (float4(uvTexcoord_y_6, uvTexcoord_z_2, uvTexcoord_y_6, uvTexcoord_y_6)).xy);
                float r0_y_7 = ((float4(1, 1, 1, 1) / _DepthFadeDistance)).y;
                float r0_y_8 = saturate((r0_y_7 * sampleTexcoord_xyzw_1.x));
                float r0_z_3 = mad(r0_y_8, -2, 3);
                float r0_y_9 = (r0_y_8 * r0_y_8);
                float r0_y_10 = (r0_y_9 * r0_z_3);
                float4 viewDir_xyzw_11 = (-i.texcoord2.xxyz + _WorldSpaceCameraPos.xxyz);
                float viewDir_y_11 = viewDir_xyzw_11.y;
                float viewDir_z_4 = viewDir_xyzw_11.z;
                float viewDir_w_2 = viewDir_xyzw_11.w;
                float4 unitViewDir_xyzw_12 = (float4(viewDir_y_11, viewDir_y_11, viewDir_z_4, viewDir_w_2) * (rsqrt(dot(float4(viewDir_y_11, viewDir_z_4, viewDir_w_2, viewDir_y_11), float4(viewDir_y_11, viewDir_z_4, viewDir_w_2, viewDir_y_11)))).xxxx);
                float unitViewDir_y_12 = unitViewDir_xyzw_12.y;
                float unitViewDir_z_5 = unitViewDir_xyzw_12.z;
                float unitViewDir_w_3 = unitViewDir_xyzw_12.w;
                float r0_y_13 = dot(i.texcoord1.xyzx, float4(unitViewDir_y_12, unitViewDir_z_5, unitViewDir_w_3, unitViewDir_y_12));
                float r0_z_6 = ((float4(1, 1, 1, 1) / cb0_values[13].x)).z;
                float r0_y_14 = saturate((r0_z_6 * abs(r0_y_13)));
                float r0_z_7 = mad(r0_y_14, -2, 3);
                float r0_y_15 = (r0_y_14 * r0_y_14);
                float r0_y_16 = (r0_y_15 * r0_z_7);
                float r0_y_17 = (i.texcoord3.w + 1E-11);
                float4 r0_xyzw_18 = (i.texcoord3.xxyz / r0_y_17.xxxx);
                float r0_y_18 = r0_xyzw_18.y;
                float r0_z_8 = r0_xyzw_18.z;
                float r0_w_4 = r0_xyzw_18.w;
                float4 r1_xyzw_4 = _texcoord.Sample(sampler_texcoord, (float4(r0_y_18, r0_z_8, r0_y_18, r0_y_18)).xy);
                float r0_y_20 = LinearEyeDepth(r0_w_4);
                float r0_z_10 = LinearEyeDepth(r1_xyzw_4.x);
                float r0_y_21 = (-r0_y_20 + r0_z_10);
                float r0_y_22 = (r0_y_21 / cb0_values[15].x);
                float r0_y_23 = min(abs(r0_y_22), 1);
                o.sv_Target0.w = ((r0_y_23 * (r0_y_16 * ((r0_y_10 * ((r0_x_4 * r0_x_4) * r0_y_5)) * _Mask_ST.w))) * cb0_values[15].y);
                o.sv_Target0.xyz = (float4(0, 0, 0, 0)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "IsEmissive"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent+0" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _Color;
                float _MaskSoftness2;
                float2 _Mask2Speed;
                float4 _Mask2_ST;
                float _MaskSoftness;
                float4 _Mask_ST;
                float _Softness;
                float _DepthFadeDistance;
                float _Alpha;
                float4 _texcoord_ST;
                float4 cb0_values[17];
            };
            cbuffer _UnityPerCameraCB : register(b1)
            {
                float4 _Time;
                float3 _WorldSpaceCameraPos;
                float4 _ProjectionParams;
                float4 _ZBufferParams;
            };
            cbuffer _UnityPerDrawCB : register(b2)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
            };
            cbuffer _UnityPerFrameCB : register(b3)
            {
                float4x4 unity_MatrixVP;
            };
            SamplerState sampler_Mask;
            SamplerState sampler_Mask2;
            SamplerState sampler_texcoord;
            Texture2D _Mask;
            Texture2D _Mask2;
            Texture2D _texcoord;
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
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program36Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program36Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program24Output vert(program24Input i)
            {
                program24Output o = (program24Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * unity_MatrixVP[1])));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord5.x = clipPos_xyzw_2.z;
                o.texcoord3.zw = (clipPos_xyzw_2.zzzw).zw;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[16].xyxx, cb0_values[16].zwzz)).xy;
                float worldNormal_x_4 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_z_3 = dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4));
                float r1_z_4 = rsqrt(r1_z_3);
                o.texcoord1.xyz = ((r1_z_4.xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float r1_y_3 = (clipPos_xyzw_2.y * _ProjectionParams.x);
                float4 r1_xyzw_3 = (clipPos_xyzw_2.xxwx * float4(0.5, 0, 0.5, 0));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_z_5 = r1_xyzw_3.z;
                float r1_w_3 = (r1_y_3 * 0.5);
                o.texcoord3.xy = ((r1_z_5.xxxx + float4(r1_x_3, r1_w_3, r1_x_3, r1_x_3))).xy;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_4.yyyy * cb0_values[3].xyzw);
                float4 clipPos_xyzw_5 = mad(cb0_values[2].xyzw, worldPos_xyzw_4.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(_Color, worldPos_xyzw_4.zzzz, clipPos_xyzw_5);
                o.texcoord4.xyzw = mad(cb0_values[5].xyzw, worldPos_xyzw_4.wwww, clipPos_xyzw_6);
                return o;
            }
            #pragma fragment frag
            program36Output frag(program36Input i)
            {
                program36Output o = (program36Output)0;
                #define LinearEyeDepth(d) (1.0 / (_ZBufferParams.z * (d) + _ZBufferParams.w))
                float4 r0_xyzw_3 = _Mask.Sample(sampler_Mask, ((mad(_Time.yyyy, cb0_values[9].yzyy, (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xyxx)).xyxx).xy);
                float r0_y_4 = ((float4(1, 1, 1, 1) / _Softness)).y;
                float r0_x_4 = saturate((r0_y_4 * r0_xyzw_3.x));
                float r0_y_5 = mad(r0_x_4, -2, 3);
                float4 uvTexcoord_xyzw_6 = mad(i.texcoord0.xxyx, _texcoord_ST.xxyx, _texcoord_ST.zzwz);
                float uvTexcoord_y_6 = uvTexcoord_xyzw_6.y;
                float uvTexcoord_z_2 = uvTexcoord_xyzw_6.z;
                float4 sampleTexcoord_xyzw_1 = _Mask2.Sample(sampler_Mask2, (float4(uvTexcoord_y_6, uvTexcoord_z_2, uvTexcoord_y_6, uvTexcoord_y_6)).xy);
                float r0_y_7 = ((float4(1, 1, 1, 1) / _DepthFadeDistance)).y;
                float r0_y_8 = saturate((r0_y_7 * sampleTexcoord_xyzw_1.x));
                float r0_z_3 = mad(r0_y_8, -2, 3);
                float r0_y_9 = (r0_y_8 * r0_y_8);
                float r0_y_10 = (r0_y_9 * r0_z_3);
                float4 viewDir_xyzw_11 = (-i.texcoord2.xxyz + _WorldSpaceCameraPos.xxyz);
                float viewDir_y_11 = viewDir_xyzw_11.y;
                float viewDir_z_4 = viewDir_xyzw_11.z;
                float viewDir_w_2 = viewDir_xyzw_11.w;
                float4 unitViewDir_xyzw_12 = (float4(viewDir_y_11, viewDir_y_11, viewDir_z_4, viewDir_w_2) * (rsqrt(dot(float4(viewDir_y_11, viewDir_z_4, viewDir_w_2, viewDir_y_11), float4(viewDir_y_11, viewDir_z_4, viewDir_w_2, viewDir_y_11)))).xxxx);
                float unitViewDir_y_12 = unitViewDir_xyzw_12.y;
                float unitViewDir_z_5 = unitViewDir_xyzw_12.z;
                float unitViewDir_w_3 = unitViewDir_xyzw_12.w;
                float r0_y_13 = dot(i.texcoord1.xyzx, float4(unitViewDir_y_12, unitViewDir_z_5, unitViewDir_w_3, unitViewDir_y_12));
                float r0_z_6 = ((float4(1, 1, 1, 1) / cb0_values[13].x)).z;
                float r0_y_14 = saturate((r0_z_6 * abs(r0_y_13)));
                float r0_z_7 = mad(r0_y_14, -2, 3);
                float r0_y_15 = (r0_y_14 * r0_y_14);
                float r0_y_16 = (r0_y_15 * r0_z_7);
                float r0_y_17 = (i.texcoord3.w + 1E-11);
                float4 r0_xyzw_18 = (i.texcoord3.xxyz / r0_y_17.xxxx);
                float r0_y_18 = r0_xyzw_18.y;
                float r0_z_8 = r0_xyzw_18.z;
                float r0_w_4 = r0_xyzw_18.w;
                float4 r1_xyzw_4 = _texcoord.Sample(sampler_texcoord, (float4(r0_y_18, r0_z_8, r0_y_18, r0_y_18)).xy);
                float r0_y_20 = LinearEyeDepth(r0_w_4);
                float r0_z_10 = LinearEyeDepth(r1_xyzw_4.x);
                float r0_y_21 = (-r0_y_20 + r0_z_10);
                float r0_y_22 = (r0_y_21 / cb0_values[15].x);
                float r0_y_23 = min(abs(r0_y_22), 1);
                o.sv_Target0.w = ((r0_y_23 * (r0_y_16 * ((r0_y_10 * ((r0_x_4 * r0_x_4) * r0_y_5)) * _Mask_ST.w))) * cb0_values[15].y);
                o.sv_Target0.xyz = (float4(0, 0, 0, 0)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "IsEmissive"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent+0" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _Color;
                float _MaskSoftness2;
                float2 _Mask2Speed;
                float4 _Mask2_ST;
                float _MaskSoftness;
                float4 _Mask_ST;
                float _Softness;
                float _DepthFadeDistance;
                float _Alpha;
                float4 _texcoord_ST;
            };
            cbuffer _UnityPerCameraCB : register(b1)
            {
                float4 _Time;
                float3 _WorldSpaceCameraPos;
                float4 _ProjectionParams;
                float4 _ZBufferParams;
            };
            cbuffer _UnityPerDrawCB : register(b2)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
            };
            cbuffer _UnityPerFrameCB : register(b3)
            {
                float4x4 unity_MatrixVP;
            };
            SamplerState sampler_Mask;
            SamplerState sampler_Mask2;
            SamplerState sampler_texcoord;
            Texture2D _Mask;
            Texture2D _Mask2;
            Texture2D _texcoord;
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
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program35Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program35Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program23Output vert(program23Input i)
            {
                program23Output o = (program23Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord5.x = clipPos_xyzw_7.z;
                o.texcoord3.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _texcoord_ST.xyxx, _texcoord_ST.zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_z_8 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r0_z_9 = rsqrt(r0_z_8);
                o.texcoord1.xyz = ((r0_z_9.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float r0_y_8 = (clipPos_xyzw_7.y * _ProjectionParams.x);
                float4 r0_xyzw_8 = (clipPos_xyzw_7.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_z_10 = r0_xyzw_8.z;
                float r0_w_8 = (r0_y_8 * 0.5);
                o.texcoord3.xy = ((r0_z_10.xxxx + float4(r0_x_8, r0_w_8, r0_x_8, r0_x_8))).xy;
                return o;
            }
            #pragma fragment frag
            program35Output frag(program35Input i)
            {
                program35Output o = (program35Output)0;
                #define LinearEyeDepth(d) (1.0 / (_ZBufferParams.z * (d) + _ZBufferParams.w))
                float2 uvMask2_xy_1 = (mad(i.texcoord0.xyxx, _Mask2_ST.xyxx, _Mask2_ST.zwzz)).xy;
                float4 r0_xyzw_3 = _Mask.Sample(sampler_Mask, ((mad(_Time.yyyy, _Mask2Speed.xyxx, uvMask2_xy_1.xyxx)).xyxx).xy);
                float r0_y_4 = ((float4(1, 1, 1, 1) / _MaskSoftness2)).y;
                float r0_x_4 = saturate((r0_y_4 * r0_xyzw_3.x));
                float r0_y_5 = mad(r0_x_4, -2, 3);
                float4 uvMask_xyzw_6 = mad(i.texcoord0.xxyx, _Mask_ST.xxyx, _Mask_ST.zzwz);
                float uvMask_y_6 = uvMask_xyzw_6.y;
                float uvMask_z_2 = uvMask_xyzw_6.z;
                float4 sampleMask_xyzw_1 = _Mask2.Sample(sampler_Mask2, (float4(uvMask_y_6, uvMask_z_2, uvMask_y_6, uvMask_y_6)).xy);
                float r0_y_7 = ((float4(1, 1, 1, 1) / _MaskSoftness)).y;
                float r0_y_8 = saturate((r0_y_7 * sampleMask_xyzw_1.x));
                float r0_z_3 = mad(r0_y_8, -2, 3);
                float r0_y_9 = (r0_y_8 * r0_y_8);
                float r0_y_10 = (r0_y_9 * r0_z_3);
                float4 viewDir_xyzw_11 = (-i.texcoord2.xxyz + _WorldSpaceCameraPos.xxyz);
                float viewDir_y_11 = viewDir_xyzw_11.y;
                float viewDir_z_4 = viewDir_xyzw_11.z;
                float viewDir_w_2 = viewDir_xyzw_11.w;
                float4 unitViewDir_xyzw_12 = (float4(viewDir_y_11, viewDir_y_11, viewDir_z_4, viewDir_w_2) * (rsqrt(dot(float4(viewDir_y_11, viewDir_z_4, viewDir_w_2, viewDir_y_11), float4(viewDir_y_11, viewDir_z_4, viewDir_w_2, viewDir_y_11)))).xxxx);
                float unitViewDir_y_12 = unitViewDir_xyzw_12.y;
                float unitViewDir_z_5 = unitViewDir_xyzw_12.z;
                float unitViewDir_w_3 = unitViewDir_xyzw_12.w;
                float r0_y_13 = dot(i.texcoord1.xyzx, float4(unitViewDir_y_12, unitViewDir_z_5, unitViewDir_w_3, unitViewDir_y_12));
                float r0_z_6 = ((float4(1, 1, 1, 1) / _Softness)).z;
                float r0_y_14 = saturate((r0_z_6 * abs(r0_y_13)));
                float r0_z_7 = mad(r0_y_14, -2, 3);
                float r0_y_15 = (r0_y_14 * r0_y_14);
                float r0_y_16 = (r0_y_15 * r0_z_7);
                float r0_y_17 = (i.texcoord3.w + 1E-11);
                float4 r0_xyzw_18 = (i.texcoord3.xxyz / r0_y_17.xxxx);
                float r0_y_18 = r0_xyzw_18.y;
                float r0_z_8 = r0_xyzw_18.z;
                float r0_w_4 = r0_xyzw_18.w;
                float4 r1_xyzw_4 = _texcoord.Sample(sampler_texcoord, (float4(r0_y_18, r0_z_8, r0_y_18, r0_y_18)).xy);
                float r0_y_20 = LinearEyeDepth(r0_w_4);
                float r0_z_10 = LinearEyeDepth(r1_xyzw_4.x);
                float r0_y_21 = (-r0_y_20 + r0_z_10);
                float r0_y_22 = (r0_y_21 / _DepthFadeDistance);
                float r0_y_23 = min(abs(r0_y_22), 1);
                o.sv_Target0.w = ((r0_y_23 * (r0_y_16 * ((r0_y_10 * ((r0_x_4 * r0_x_4) * r0_y_5)) * _Color.w))) * _Alpha);
                o.sv_Target0.xyz = (float4(0, 0, 0, 0)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "IsEmissive"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent+0" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _Color;
                float _MaskSoftness2;
                float2 _Mask2Speed;
                float4 _Mask2_ST;
                float _MaskSoftness;
                float4 _Mask_ST;
                float _Softness;
                float _DepthFadeDistance;
                float _Alpha;
                float4 _texcoord_ST;
                float4 cb0_values[17];
            };
            cbuffer _UnityPerCameraCB : register(b1)
            {
                float4 _Time;
                float3 _WorldSpaceCameraPos;
                float4 _ProjectionParams;
                float4 _ZBufferParams;
            };
            cbuffer _UnityPerDrawCB : register(b2)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
            };
            cbuffer _UnityPerFrameCB : register(b3)
            {
                float4x4 unity_MatrixVP;
            };
            SamplerState sampler_Mask;
            SamplerState sampler_Mask2;
            SamplerState sampler_texcoord;
            Texture2D _Mask;
            Texture2D _Mask2;
            Texture2D _texcoord;
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
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
            };
            struct program34Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
            };
            struct program34Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program22Output vert(program22Input i)
            {
                program22Output o = (program22Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord5.x = clipPos_xyzw_2.z;
                o.texcoord3.zw = (clipPos_xyzw_2.zzzw).zw;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[16].xyxx, cb0_values[16].zwzz)).xy;
                float worldNormal_x_4 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_z_3 = dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4));
                float r1_z_4 = rsqrt(r1_z_3);
                o.texcoord1.xyz = ((r1_z_4.xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float r1_y_3 = (clipPos_xyzw_2.y * _ProjectionParams.x);
                float4 r1_xyzw_3 = (clipPos_xyzw_2.xxwx * float4(0.5, 0, 0.5, 0));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_z_5 = r1_xyzw_3.z;
                float r1_w_3 = (r1_y_3 * 0.5);
                o.texcoord3.xy = ((r1_z_5.xxxx + float4(r1_x_3, r1_w_3, r1_x_3, r1_x_3))).xy;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_4.yyyy * cb0_values[3].xyzx);
                float clipPos_x_4 = clipPos_xyzw_4.x;
                float clipPos_y_4 = clipPos_xyzw_4.y;
                float clipPos_z_6 = clipPos_xyzw_4.z;
                float4 clipPos_xyzw_5 = mad(cb0_values[2].xyzx, worldPos_xyzw_4.xxxx, float4(clipPos_x_4, clipPos_y_4, clipPos_z_6, clipPos_x_4));
                float clipPos_x_5 = clipPos_xyzw_5.x;
                float clipPos_y_5 = clipPos_xyzw_5.y;
                float clipPos_z_7 = clipPos_xyzw_5.z;
                float3 clipPos_xyz_5 = (mad(_Color.xyzx, worldPos_xyzw_4.zzzz, float4(clipPos_x_5, clipPos_y_5, clipPos_z_7, clipPos_x_5))).xyz;
                o.texcoord4.xyz = (mad(cb0_values[5].xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program34Output frag(program34Input i)
            {
                program34Output o = (program34Output)0;
                #define LinearEyeDepth(d) (1.0 / (_ZBufferParams.z * (d) + _ZBufferParams.w))
                float4 r0_xyzw_3 = _Mask.Sample(sampler_Mask, ((mad(_Time.yyyy, cb0_values[9].yzyy, (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xyxx)).xyxx).xy);
                float r0_y_4 = ((float4(1, 1, 1, 1) / _Softness)).y;
                float r0_x_4 = saturate((r0_y_4 * r0_xyzw_3.x));
                float r0_y_5 = mad(r0_x_4, -2, 3);
                float4 uvTexcoord_xyzw_6 = mad(i.texcoord0.xxyx, _texcoord_ST.xxyx, _texcoord_ST.zzwz);
                float uvTexcoord_y_6 = uvTexcoord_xyzw_6.y;
                float uvTexcoord_z_2 = uvTexcoord_xyzw_6.z;
                float4 sampleTexcoord_xyzw_1 = _Mask2.Sample(sampler_Mask2, (float4(uvTexcoord_y_6, uvTexcoord_z_2, uvTexcoord_y_6, uvTexcoord_y_6)).xy);
                float r0_y_7 = ((float4(1, 1, 1, 1) / _DepthFadeDistance)).y;
                float r0_y_8 = saturate((r0_y_7 * sampleTexcoord_xyzw_1.x));
                float r0_z_3 = mad(r0_y_8, -2, 3);
                float r0_y_9 = (r0_y_8 * r0_y_8);
                float r0_y_10 = (r0_y_9 * r0_z_3);
                float4 viewDir_xyzw_11 = (-i.texcoord2.xxyz + _WorldSpaceCameraPos.xxyz);
                float viewDir_y_11 = viewDir_xyzw_11.y;
                float viewDir_z_4 = viewDir_xyzw_11.z;
                float viewDir_w_2 = viewDir_xyzw_11.w;
                float4 unitViewDir_xyzw_12 = (float4(viewDir_y_11, viewDir_y_11, viewDir_z_4, viewDir_w_2) * (rsqrt(dot(float4(viewDir_y_11, viewDir_z_4, viewDir_w_2, viewDir_y_11), float4(viewDir_y_11, viewDir_z_4, viewDir_w_2, viewDir_y_11)))).xxxx);
                float unitViewDir_y_12 = unitViewDir_xyzw_12.y;
                float unitViewDir_z_5 = unitViewDir_xyzw_12.z;
                float unitViewDir_w_3 = unitViewDir_xyzw_12.w;
                float r0_y_13 = dot(i.texcoord1.xyzx, float4(unitViewDir_y_12, unitViewDir_z_5, unitViewDir_w_3, unitViewDir_y_12));
                float r0_z_6 = ((float4(1, 1, 1, 1) / cb0_values[13].x)).z;
                float r0_y_14 = saturate((r0_z_6 * abs(r0_y_13)));
                float r0_z_7 = mad(r0_y_14, -2, 3);
                float r0_y_15 = (r0_y_14 * r0_y_14);
                float r0_y_16 = (r0_y_15 * r0_z_7);
                float r0_y_17 = (i.texcoord3.w + 1E-11);
                float4 r0_xyzw_18 = (i.texcoord3.xxyz / r0_y_17.xxxx);
                float r0_y_18 = r0_xyzw_18.y;
                float r0_z_8 = r0_xyzw_18.z;
                float r0_w_4 = r0_xyzw_18.w;
                float4 r1_xyzw_4 = _texcoord.Sample(sampler_texcoord, (float4(r0_y_18, r0_z_8, r0_y_18, r0_y_18)).xy);
                float r0_y_20 = LinearEyeDepth(r0_w_4);
                float r0_z_10 = LinearEyeDepth(r1_xyzw_4.x);
                float r0_y_21 = (-r0_y_20 + r0_z_10);
                float r0_y_22 = (r0_y_21 / cb0_values[15].x);
                float r0_y_23 = min(abs(r0_y_22), 1);
                o.sv_Target0.w = ((r0_y_23 * (r0_y_16 * ((r0_y_10 * ((r0_x_4 * r0_x_4) * r0_y_5)) * _Mask_ST.w))) * cb0_values[15].y);
                o.sv_Target0.xyz = (float4(0, 0, 0, 0)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "IsEmissive"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent+0" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _Color;
                float _MaskSoftness2;
                float2 _Mask2Speed;
                float4 _Mask2_ST;
                float _MaskSoftness;
                float4 _Mask_ST;
                float _Softness;
                float _DepthFadeDistance;
                float _Alpha;
                float4 _texcoord_ST;
                float4 cb0_values[17];
            };
            cbuffer _UnityPerCameraCB : register(b1)
            {
                float4 _Time;
                float3 _WorldSpaceCameraPos;
                float4 _ProjectionParams;
                float4 _ZBufferParams;
            };
            cbuffer _UnityPerDrawCB : register(b2)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
            };
            cbuffer _UnityPerFrameCB : register(b3)
            {
                float4x4 unity_MatrixVP;
            };
            SamplerState sampler_Mask;
            SamplerState sampler_Mask2;
            SamplerState sampler_texcoord;
            Texture2D _Mask;
            Texture2D _Mask2;
            Texture2D _texcoord;
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
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program33Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program33Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program21Output vert(program21Input i)
            {
                program21Output o = (program21Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float2 clipPos_xy_4 = ((worldPos_xyzw_4.yyyy * cb0_values[3].xyxx)).xy;
                float2 clipPos_xy_5 = (mad(cb0_values[2].xyxx, worldPos_xyzw_4.xxxx, clipPos_xy_4.xyxx)).xy;
                float2 clipPos_xy_6 = (mad(_Color.xyxx, worldPos_xyzw_4.zzzz, clipPos_xy_5.xyxx)).xy;
                o.texcoord4.xy = (mad(cb0_values[5].xxxy, worldPos_xyzw_4.wwww, clipPos_xy_6.xxxy)).zw;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[16].xyxx, cb0_values[16].zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_4 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7));
                float r0_w_5 = rsqrt(r0_w_4);
                o.texcoord1.xyz = ((r0_w_5.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7))).xyz;
                float r0_w_6 = ((clipPos_xyzw_2.y * _ProjectionParams.x) * 0.5);
                float4 r0_xyzw_9 = (clipPos_xyzw_2.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                o.texcoord3.zw = (clipPos_xyzw_2.zzzw).zw;
                o.texcoord3.xy = ((r0_z_5.xxxx + float4(r0_x_9, r0_w_6, r0_x_9, r0_x_9))).xy;
                return o;
            }
            #pragma fragment frag
            program33Output frag(program33Input i)
            {
                program33Output o = (program33Output)0;
                #define LinearEyeDepth(d) (1.0 / (_ZBufferParams.z * (d) + _ZBufferParams.w))
                float4 r0_xyzw_3 = _Mask.Sample(sampler_Mask, ((mad(_Time.yyyy, cb0_values[9].yzyy, (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xyxx)).xyxx).xy);
                float r0_y_4 = ((float4(1, 1, 1, 1) / _Softness)).y;
                float r0_x_4 = saturate((r0_y_4 * r0_xyzw_3.x));
                float r0_y_5 = mad(r0_x_4, -2, 3);
                float4 uvTexcoord_xyzw_6 = mad(i.texcoord0.xxyx, _texcoord_ST.xxyx, _texcoord_ST.zzwz);
                float uvTexcoord_y_6 = uvTexcoord_xyzw_6.y;
                float uvTexcoord_z_2 = uvTexcoord_xyzw_6.z;
                float4 sampleTexcoord_xyzw_1 = _Mask2.Sample(sampler_Mask2, (float4(uvTexcoord_y_6, uvTexcoord_z_2, uvTexcoord_y_6, uvTexcoord_y_6)).xy);
                float r0_y_7 = ((float4(1, 1, 1, 1) / _DepthFadeDistance)).y;
                float r0_y_8 = saturate((r0_y_7 * sampleTexcoord_xyzw_1.x));
                float r0_z_3 = mad(r0_y_8, -2, 3);
                float r0_y_9 = (r0_y_8 * r0_y_8);
                float r0_y_10 = (r0_y_9 * r0_z_3);
                float4 viewDir_xyzw_11 = (-i.texcoord2.xxyz + _WorldSpaceCameraPos.xxyz);
                float viewDir_y_11 = viewDir_xyzw_11.y;
                float viewDir_z_4 = viewDir_xyzw_11.z;
                float viewDir_w_2 = viewDir_xyzw_11.w;
                float4 unitViewDir_xyzw_12 = (float4(viewDir_y_11, viewDir_y_11, viewDir_z_4, viewDir_w_2) * (rsqrt(dot(float4(viewDir_y_11, viewDir_z_4, viewDir_w_2, viewDir_y_11), float4(viewDir_y_11, viewDir_z_4, viewDir_w_2, viewDir_y_11)))).xxxx);
                float unitViewDir_y_12 = unitViewDir_xyzw_12.y;
                float unitViewDir_z_5 = unitViewDir_xyzw_12.z;
                float unitViewDir_w_3 = unitViewDir_xyzw_12.w;
                float r0_y_13 = dot(i.texcoord1.xyzx, float4(unitViewDir_y_12, unitViewDir_z_5, unitViewDir_w_3, unitViewDir_y_12));
                float r0_z_6 = ((float4(1, 1, 1, 1) / cb0_values[13].x)).z;
                float r0_y_14 = saturate((r0_z_6 * abs(r0_y_13)));
                float r0_z_7 = mad(r0_y_14, -2, 3);
                float r0_y_15 = (r0_y_14 * r0_y_14);
                float r0_y_16 = (r0_y_15 * r0_z_7);
                float r0_y_17 = (i.texcoord3.w + 1E-11);
                float4 r0_xyzw_18 = (i.texcoord3.xxyz / r0_y_17.xxxx);
                float r0_y_18 = r0_xyzw_18.y;
                float r0_z_8 = r0_xyzw_18.z;
                float r0_w_4 = r0_xyzw_18.w;
                float4 r1_xyzw_4 = _texcoord.Sample(sampler_texcoord, (float4(r0_y_18, r0_z_8, r0_y_18, r0_y_18)).xy);
                float r0_y_20 = LinearEyeDepth(r0_w_4);
                float r0_z_10 = LinearEyeDepth(r1_xyzw_4.x);
                float r0_y_21 = (-r0_y_20 + r0_z_10);
                float r0_y_22 = (r0_y_21 / cb0_values[15].x);
                float r0_y_23 = min(abs(r0_y_22), 1);
                o.sv_Target0.w = ((r0_y_23 * (r0_y_16 * ((r0_y_10 * ((r0_x_4 * r0_x_4) * r0_y_5)) * _Mask_ST.w))) * cb0_values[15].y);
                o.sv_Target0.xyz = (float4(0, 0, 0, 0)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "IsEmissive"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent+0" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _Color;
                float _MaskSoftness2;
                float2 _Mask2Speed;
                float4 _Mask2_ST;
                float _MaskSoftness;
                float4 _Mask_ST;
                float _Softness;
                float _DepthFadeDistance;
                float _Alpha;
                float4 _texcoord_ST;
                float4 cb0_values[17];
            };
            cbuffer _UnityPerCameraCB : register(b1)
            {
                float4 _Time;
                float3 _WorldSpaceCameraPos;
                float4 _ProjectionParams;
                float4 _ZBufferParams;
            };
            cbuffer _UnityPerDrawCB : register(b2)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
            };
            cbuffer _UnityPerFrameCB : register(b3)
            {
                float4x4 unity_MatrixVP;
            };
            SamplerState sampler_Mask;
            SamplerState sampler_Mask2;
            SamplerState sampler_texcoord;
            Texture2D _Mask;
            Texture2D _Mask2;
            Texture2D _texcoord;
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
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program31Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program31Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program19Output vert(program19Input i)
            {
                program19Output o = (program19Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * unity_MatrixVP[1])));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[16].xyxx, cb0_values[16].zwzz)).xy;
                float worldNormal_x_4 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r2_w_4 = dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4));
                float r2_w_5 = rsqrt(r2_w_4);
                o.texcoord1.xyz = ((r2_w_5.xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float r1_y_3 = (clipPos_xyzw_2.y * _ProjectionParams.x);
                float4 r2_xyzw_5 = (float4(clipPos_xyzw_2.x, clipPos_xyzw_2.x, clipPos_xyzw_2.w, r1_y_3) * float4(0.5, 0, 0.5, 0.5));
                float r2_x_5 = r2_xyzw_5.x;
                float r2_z_5 = r2_xyzw_5.z;
                float r2_w_6 = r2_xyzw_5.w;
                o.texcoord3.zw = (clipPos_xyzw_2.zzzw).zw;
                o.texcoord3.xy = ((r2_z_5.xxxx + float4(r2_x_5, r2_w_6, r2_x_5, r2_x_5))).xy;
                float clipPos_x_3 = ((worldPos_xyzw_4.yyyy * cb0_values[3].xyzw)).x;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_4.yyyy * cb0_values[3].xyzw);
                float clipPos_y_4 = clipPos_xyzw_4.y;
                float clipPos_z_3 = clipPos_xyzw_4.z;
                float clipPos_w_3 = clipPos_xyzw_4.w;
                float clipPos_x_4 = (mad(cb0_values[2].xyzw, worldPos_xyzw_4.xxxx, float4(clipPos_x_3, clipPos_y_4, clipPos_z_3, clipPos_w_3))).x;
                float4 clipPos_xyzw_5 = mad(cb0_values[2].xyzw, worldPos_xyzw_4.xxxx, float4(clipPos_x_3, clipPos_y_4, clipPos_z_3, clipPos_w_3));
                float clipPos_y_5 = clipPos_xyzw_5.y;
                float clipPos_z_4 = clipPos_xyzw_5.z;
                float clipPos_w_4 = clipPos_xyzw_5.w;
                float clipPos_x_5 = (mad(_Color, worldPos_xyzw_4.zzzz, float4(clipPos_x_4, clipPos_y_5, clipPos_z_4, clipPos_w_4))).x;
                float4 clipPos_xyzw_6 = mad(_Color, worldPos_xyzw_4.zzzz, float4(clipPos_x_4, clipPos_y_5, clipPos_z_4, clipPos_w_4));
                float clipPos_y_6 = clipPos_xyzw_6.y;
                float clipPos_z_5 = clipPos_xyzw_6.z;
                float clipPos_w_5 = clipPos_xyzw_6.w;
                o.texcoord4.xyzw = mad(cb0_values[5].xyzw, worldPos_xyzw_4.wwww, float4(clipPos_x_5, clipPos_y_6, clipPos_z_5, clipPos_w_5));
                return o;
            }
            #pragma fragment frag
            program31Output frag(program31Input i)
            {
                program31Output o = (program31Output)0;
                #define LinearEyeDepth(d) (1.0 / (_ZBufferParams.z * (d) + _ZBufferParams.w))
                float4 r0_xyzw_3 = _Mask.Sample(sampler_Mask, ((mad(_Time.yyyy, cb0_values[9].yzyy, (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xyxx)).xyxx).xy);
                float r0_y_4 = ((float4(1, 1, 1, 1) / _Softness)).y;
                float r0_x_4 = saturate((r0_y_4 * r0_xyzw_3.x));
                float r0_y_5 = mad(r0_x_4, -2, 3);
                float4 uvTexcoord_xyzw_6 = mad(i.texcoord0.xxyx, _texcoord_ST.xxyx, _texcoord_ST.zzwz);
                float uvTexcoord_y_6 = uvTexcoord_xyzw_6.y;
                float uvTexcoord_z_2 = uvTexcoord_xyzw_6.z;
                float4 sampleTexcoord_xyzw_1 = _Mask2.Sample(sampler_Mask2, (float4(uvTexcoord_y_6, uvTexcoord_z_2, uvTexcoord_y_6, uvTexcoord_y_6)).xy);
                float r0_y_7 = ((float4(1, 1, 1, 1) / _DepthFadeDistance)).y;
                float r0_y_8 = saturate((r0_y_7 * sampleTexcoord_xyzw_1.x));
                float r0_z_3 = mad(r0_y_8, -2, 3);
                float r0_y_9 = (r0_y_8 * r0_y_8);
                float r0_y_10 = (r0_y_9 * r0_z_3);
                float4 viewDir_xyzw_11 = (-i.texcoord2.xxyz + _WorldSpaceCameraPos.xxyz);
                float viewDir_y_11 = viewDir_xyzw_11.y;
                float viewDir_z_4 = viewDir_xyzw_11.z;
                float viewDir_w_2 = viewDir_xyzw_11.w;
                float4 unitViewDir_xyzw_12 = (float4(viewDir_y_11, viewDir_y_11, viewDir_z_4, viewDir_w_2) * (rsqrt(dot(float4(viewDir_y_11, viewDir_z_4, viewDir_w_2, viewDir_y_11), float4(viewDir_y_11, viewDir_z_4, viewDir_w_2, viewDir_y_11)))).xxxx);
                float unitViewDir_y_12 = unitViewDir_xyzw_12.y;
                float unitViewDir_z_5 = unitViewDir_xyzw_12.z;
                float unitViewDir_w_3 = unitViewDir_xyzw_12.w;
                float r0_y_13 = dot(i.texcoord1.xyzx, float4(unitViewDir_y_12, unitViewDir_z_5, unitViewDir_w_3, unitViewDir_y_12));
                float r0_z_6 = ((float4(1, 1, 1, 1) / cb0_values[13].x)).z;
                float r0_y_14 = saturate((r0_z_6 * abs(r0_y_13)));
                float r0_z_7 = mad(r0_y_14, -2, 3);
                float r0_y_15 = (r0_y_14 * r0_y_14);
                float r0_y_16 = (r0_y_15 * r0_z_7);
                float r0_y_17 = (i.texcoord3.w + 1E-11);
                float4 r0_xyzw_18 = (i.texcoord3.xxyz / r0_y_17.xxxx);
                float r0_y_18 = r0_xyzw_18.y;
                float r0_z_8 = r0_xyzw_18.z;
                float r0_w_4 = r0_xyzw_18.w;
                float4 r1_xyzw_4 = _texcoord.Sample(sampler_texcoord, (float4(r0_y_18, r0_z_8, r0_y_18, r0_y_18)).xy);
                float r0_y_20 = LinearEyeDepth(r0_w_4);
                float r0_z_10 = LinearEyeDepth(r1_xyzw_4.x);
                float r0_y_21 = (-r0_y_20 + r0_z_10);
                float r0_y_22 = (r0_y_21 / cb0_values[15].x);
                float r0_y_23 = min(abs(r0_y_22), 1);
                o.sv_Target0.w = ((r0_y_23 * (r0_y_16 * ((r0_y_10 * ((r0_x_4 * r0_x_4) * r0_y_5)) * _Mask_ST.w))) * cb0_values[15].y);
                o.sv_Target0.xyz = (float4(0, 0, 0, 0)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "IsEmissive"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent+0" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _Color;
                float _MaskSoftness2;
                float2 _Mask2Speed;
                float4 _Mask2_ST;
                float _MaskSoftness;
                float4 _Mask_ST;
                float _Softness;
                float _DepthFadeDistance;
                float _Alpha;
                float4 _texcoord_ST;
            };
            cbuffer _UnityPerCameraCB : register(b1)
            {
                float4 _Time;
                float3 _WorldSpaceCameraPos;
                float4 _ProjectionParams;
                float4 _ZBufferParams;
            };
            cbuffer _UnityPerDrawCB : register(b2)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
            };
            cbuffer _UnityPerFrameCB : register(b3)
            {
                float4x4 unity_MatrixVP;
            };
            SamplerState sampler_Mask;
            SamplerState sampler_Mask2;
            SamplerState sampler_texcoord;
            Texture2D _Mask;
            Texture2D _Mask2;
            Texture2D _texcoord;
            struct program18Input
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
            struct program18Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program30Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program30Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program18Output vert(program18Input i)
            {
                program18Output o = (program18Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _texcoord_ST.xyxx, _texcoord_ST.zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float r0_y_8 = (clipPos_xyzw_7.y * _ProjectionParams.x);
                float4 r1_xyzw_3 = (float4(clipPos_xyzw_7.x, clipPos_xyzw_7.x, clipPos_xyzw_7.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_z_3 = r1_xyzw_3.z;
                float r1_w_4 = r1_xyzw_3.w;
                o.texcoord3.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord3.xy = ((r1_z_3.xxxx + float4(r1_x_3, r1_w_4, r1_x_3, r1_x_3))).xy;
                return o;
            }
            #pragma fragment frag
            program30Output frag(program30Input i)
            {
                program30Output o = (program30Output)0;
                #define LinearEyeDepth(d) (1.0 / (_ZBufferParams.z * (d) + _ZBufferParams.w))
                float2 uvMask2_xy_1 = (mad(i.texcoord0.xyxx, _Mask2_ST.xyxx, _Mask2_ST.zwzz)).xy;
                float4 r0_xyzw_3 = _Mask.Sample(sampler_Mask, ((mad(_Time.yyyy, _Mask2Speed.xyxx, uvMask2_xy_1.xyxx)).xyxx).xy);
                float r0_y_4 = ((float4(1, 1, 1, 1) / _MaskSoftness2)).y;
                float r0_x_4 = saturate((r0_y_4 * r0_xyzw_3.x));
                float r0_y_5 = mad(r0_x_4, -2, 3);
                float4 uvMask_xyzw_6 = mad(i.texcoord0.xxyx, _Mask_ST.xxyx, _Mask_ST.zzwz);
                float uvMask_y_6 = uvMask_xyzw_6.y;
                float uvMask_z_2 = uvMask_xyzw_6.z;
                float4 sampleMask_xyzw_1 = _Mask2.Sample(sampler_Mask2, (float4(uvMask_y_6, uvMask_z_2, uvMask_y_6, uvMask_y_6)).xy);
                float r0_y_7 = ((float4(1, 1, 1, 1) / _MaskSoftness)).y;
                float r0_y_8 = saturate((r0_y_7 * sampleMask_xyzw_1.x));
                float r0_z_3 = mad(r0_y_8, -2, 3);
                float r0_y_9 = (r0_y_8 * r0_y_8);
                float r0_y_10 = (r0_y_9 * r0_z_3);
                float4 viewDir_xyzw_11 = (-i.texcoord2.xxyz + _WorldSpaceCameraPos.xxyz);
                float viewDir_y_11 = viewDir_xyzw_11.y;
                float viewDir_z_4 = viewDir_xyzw_11.z;
                float viewDir_w_2 = viewDir_xyzw_11.w;
                float4 unitViewDir_xyzw_12 = (float4(viewDir_y_11, viewDir_y_11, viewDir_z_4, viewDir_w_2) * (rsqrt(dot(float4(viewDir_y_11, viewDir_z_4, viewDir_w_2, viewDir_y_11), float4(viewDir_y_11, viewDir_z_4, viewDir_w_2, viewDir_y_11)))).xxxx);
                float unitViewDir_y_12 = unitViewDir_xyzw_12.y;
                float unitViewDir_z_5 = unitViewDir_xyzw_12.z;
                float unitViewDir_w_3 = unitViewDir_xyzw_12.w;
                float r0_y_13 = dot(i.texcoord1.xyzx, float4(unitViewDir_y_12, unitViewDir_z_5, unitViewDir_w_3, unitViewDir_y_12));
                float r0_z_6 = ((float4(1, 1, 1, 1) / _Softness)).z;
                float r0_y_14 = saturate((r0_z_6 * abs(r0_y_13)));
                float r0_z_7 = mad(r0_y_14, -2, 3);
                float r0_y_15 = (r0_y_14 * r0_y_14);
                float r0_y_16 = (r0_y_15 * r0_z_7);
                float r0_y_17 = (i.texcoord3.w + 1E-11);
                float4 r0_xyzw_18 = (i.texcoord3.xxyz / r0_y_17.xxxx);
                float r0_y_18 = r0_xyzw_18.y;
                float r0_z_8 = r0_xyzw_18.z;
                float r0_w_4 = r0_xyzw_18.w;
                float4 r1_xyzw_4 = _texcoord.Sample(sampler_texcoord, (float4(r0_y_18, r0_z_8, r0_y_18, r0_y_18)).xy);
                float r0_y_20 = LinearEyeDepth(r0_w_4);
                float r0_z_10 = LinearEyeDepth(r1_xyzw_4.x);
                float r0_y_21 = (-r0_y_20 + r0_z_10);
                float r0_y_22 = (r0_y_21 / _DepthFadeDistance);
                float r0_y_23 = min(abs(r0_y_22), 1);
                o.sv_Target0.w = ((r0_y_23 * (r0_y_16 * ((r0_y_10 * ((r0_x_4 * r0_x_4) * r0_y_5)) * _Color.w))) * _Alpha);
                o.sv_Target0.xyz = (float4(0, 0, 0, 0)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "IsEmissive"="true" "LIGHTMODE"="SHADOWCASTER" "QUEUE"="Transparent+0" "RenderType"="Transparent" "SHADOWSUPPORT"="true" }
            Cull Off
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _UnityPerCameraCB : register(b0)
            {
                float4 _Time;
                float4 _Color;
                float3 _WorldSpaceCameraPos;
                float4 _ProjectionParams;
                float _MaskSoftness2;
                float2 _Mask2Speed;
                float4 _Mask2_ST;
                float _MaskSoftness;
                float4 _ZBufferParams;
                float4 _Mask_ST;
                float _Softness;
                float _DepthFadeDistance;
                float _Alpha;
            };
            cbuffer _UnityLightingCB : register(b1)
            {
                float4 _WorldSpaceLightPos0;
            };
            cbuffer _UnityShadowsCB : register(b2)
            {
                float4 unity_LightShadowBias;
            };
            cbuffer _UnityPerDrawCB : register(b3)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
            };
            cbuffer _UnityPerFrameCB : register(b4)
            {
                float4x4 unity_MatrixVP;
            };
            SamplerState sampler_Mask;
            SamplerState sampler_Mask2;
            SamplerState sampler_texcoord;
            SamplerState sampler_linear_clamp3;
            Texture2D _Mask;
            Texture2D _Mask2;
            Texture2D _texcoord;
            Texture3D t3;
            struct program40Input
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
            struct program40Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
            };
            struct program43Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
            };
            struct program43Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program40Output vert(program40Input i)
            {
                program40Output o = (program40Output)0;
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
                o.texcoord4.xyz = unitWorldNormal_xyz_2.xyz;
                float4 unity_LightShadowBiasSelect_xyzw_4 = (((unity_LightShadowBias.z != 0)).xxxx ? (mad(-unitWorldNormal_xyz_2.xyzx, r0_w_8.xxxx, worldPos_xyzw_4.xyzx)).xyzx : worldPos_xyzw_4.xyzx);
                float unity_LightShadowBiasSelect_x_4 = unity_LightShadowBiasSelect_xyzw_4.x;
                float unity_LightShadowBiasSelect_y_3 = unity_LightShadowBiasSelect_xyzw_4.y;
                float unity_LightShadowBiasSelect_z_3 = unity_LightShadowBiasSelect_xyzw_4.z;
                float4 r2_xyzw_4 = (unity_LightShadowBiasSelect_y_3.xxxx * unity_MatrixVP[1]);
                float4 r2_xyzw_5 = mad(unity_MatrixVP[0], unity_LightShadowBiasSelect_x_4.xxxx, r2_xyzw_4);
                float4 r0_xyzw_5 = mad(unity_MatrixVP[2], unity_LightShadowBiasSelect_z_3.xxxx, r2_xyzw_5);
                float4 r0_xyzw_6 = mad(unity_MatrixVP[3], worldPos_xyzw_4.wwww, r0_xyzw_5);
                float r1_x_8 = (r0_xyzw_6.z + max(min((unity_LightShadowBias.x / r0_xyzw_6.w), 0), -1));
                float r1_y_5 = min(r0_xyzw_6.w, r1_x_8);
                float r1_y_6 = (-r1_x_8 + r1_y_5);
                float r0_z_6 = mad(unity_LightShadowBias.y, r1_y_6, r1_x_8);
                o.sv_Position0.xyzw = float4(r0_xyzw_6.x, r0_xyzw_6.y, r0_z_6, r0_xyzw_6.w);
                o.texcoord3.zw = (float4(r0_z_6, r0_z_6, r0_z_6, r0_xyzw_6.w)).zw;
                o.texcoord1.xy = (i.texcoord0.xyxx).xy;
                float4 worldPos_xyzw_9 = (i.position0.yyyy * unity_ObjectToWorld[1].xyzx);
                float worldPos_x_9 = worldPos_xyzw_9.x;
                float worldPos_y_7 = worldPos_xyzw_9.y;
                float worldPos_z_5 = worldPos_xyzw_9.z;
                float4 worldPos_xyzw_10 = mad(unity_ObjectToWorld[0].xyzx, i.position0.xxxx, float4(worldPos_x_9, worldPos_y_7, worldPos_z_5, worldPos_x_9));
                float worldPos_x_10 = worldPos_xyzw_10.x;
                float worldPos_y_8 = worldPos_xyzw_10.y;
                float worldPos_z_6 = worldPos_xyzw_10.z;
                float4 worldPos_xyzw_11 = mad(unity_ObjectToWorld[2].xyzx, i.position0.zzzz, float4(worldPos_x_10, worldPos_y_8, worldPos_z_6, worldPos_x_10));
                float worldPos_x_11 = worldPos_xyzw_11.x;
                float worldPos_y_9 = worldPos_xyzw_11.y;
                float worldPos_z_7 = worldPos_xyzw_11.z;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, float4(worldPos_x_11, worldPos_y_9, worldPos_z_7, worldPos_x_11))).xyz;
                float r0_y_6 = (r0_xyzw_6.y * _ProjectionParams.x);
                float2 r0_xz_7 = ((r0_xyzw_6.xxwx * float4(0.5, 0, 0.5, 0))).xz;
                float r0_w_11 = (r0_y_6 * 0.5);
                o.texcoord3.xy = ((r0_xz_7.yyyy + float4(r0_xz_7.x, r0_w_11, r0_xz_7.x, r0_xz_7.x))).xy;
                return o;
            }
            #pragma fragment frag
            program43Output frag(program43Input i)
            {
                program43Output o = (program43Output)0;
                #define LinearEyeDepth(d) (1.0 / (_ZBufferParams.z * (d) + _ZBufferParams.w))
                float2 uvMask2_xy_1 = (mad(i.texcoord1.xyxx, _Mask2_ST.xyxx, _Mask2_ST.zwzz)).xy;
                float4 r0_xyzw_3 = _Mask.Sample(sampler_Mask, ((mad(_Time.yyyy, _Mask2Speed.xyxx, uvMask2_xy_1.xyxx)).xyxx).xy);
                float r0_y_4 = ((float4(1, 1, 1, 1) / _MaskSoftness2)).y;
                float r0_x_4 = saturate((r0_y_4 * r0_xyzw_3.x));
                float r0_y_5 = mad(r0_x_4, -2, 3);
                float4 uvMask_xyzw_6 = mad(i.texcoord1.xxyx, _Mask_ST.xxyx, _Mask_ST.zzwz);
                float uvMask_y_6 = uvMask_xyzw_6.y;
                float uvMask_z_2 = uvMask_xyzw_6.z;
                float4 sampleMask_xyzw_1 = _Mask2.Sample(sampler_Mask2, (float4(uvMask_y_6, uvMask_z_2, uvMask_y_6, uvMask_y_6)).xy);
                float r0_y_7 = ((float4(1, 1, 1, 1) / _MaskSoftness)).y;
                float r0_y_8 = saturate((r0_y_7 * sampleMask_xyzw_1.x));
                float r0_z_3 = mad(r0_y_8, -2, 3);
                float r0_y_9 = (r0_y_8 * r0_y_8);
                float r0_y_10 = (r0_y_9 * r0_z_3);
                float4 viewDir_xyzw_11 = (-i.texcoord2.xxyz + _WorldSpaceCameraPos.xxyz);
                float viewDir_y_11 = viewDir_xyzw_11.y;
                float viewDir_z_4 = viewDir_xyzw_11.z;
                float viewDir_w_2 = viewDir_xyzw_11.w;
                float4 unitViewDir_xyzw_12 = (float4(viewDir_y_11, viewDir_y_11, viewDir_z_4, viewDir_w_2) * (rsqrt(dot(float4(viewDir_y_11, viewDir_z_4, viewDir_w_2, viewDir_y_11), float4(viewDir_y_11, viewDir_z_4, viewDir_w_2, viewDir_y_11)))).xxxx);
                float unitViewDir_y_12 = unitViewDir_xyzw_12.y;
                float unitViewDir_z_5 = unitViewDir_xyzw_12.z;
                float unitViewDir_w_3 = unitViewDir_xyzw_12.w;
                float r0_y_13 = dot(i.texcoord4.xyzx, float4(unitViewDir_y_12, unitViewDir_z_5, unitViewDir_w_3, unitViewDir_y_12));
                float r0_z_6 = ((float4(1, 1, 1, 1) / _Softness)).z;
                float r0_y_14 = saturate((r0_z_6 * abs(r0_y_13)));
                float r0_z_7 = mad(r0_y_14, -2, 3);
                float r0_y_15 = (r0_y_14 * r0_y_14);
                float r0_y_16 = (r0_y_15 * r0_z_7);
                float r0_y_17 = (i.texcoord3.w + 1E-11);
                float4 r0_xyzw_18 = (i.texcoord3.xxyz / r0_y_17.xxxx);
                float r0_y_18 = r0_xyzw_18.y;
                float r0_z_8 = r0_xyzw_18.z;
                float r0_w_4 = r0_xyzw_18.w;
                float4 r1_xyzw_4 = _texcoord.Sample(sampler_texcoord, (float4(r0_y_18, r0_z_8, r0_y_18, r0_y_18)).xy);
                float r0_y_20 = LinearEyeDepth(r0_w_4);
                float r0_z_10 = LinearEyeDepth(r1_xyzw_4.x);
                float r0_y_21 = (-r0_y_20 + r0_z_10);
                float r0_y_22 = (r0_y_21 / _DepthFadeDistance);
                float r0_y_23 = min(abs(r0_y_22), 1);
                float r0_x_11 = ((r0_y_23 * (r0_y_16 * ((r0_y_10 * ((r0_x_4 * r0_x_4) * r0_y_5)) * _Color.w))) * _Alpha);
                float r0_z_11 = (r0_x_11 * 0.9375);
                float4 r0_xyzw_12 = (i.sv_Position0.xyxx * float4(0.25, 0.25, 0, 0));
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_24 = r0_xyzw_12.y;
                float4 r0_xyzw_13 = t3.Sample(sampler_linear_clamp3, (float4(r0_x_12, r0_y_24, r0_z_11, r0_x_12)).xyz);
                if (((r0_xyzw_13.w + -0.01) < 0)) discard;
                o.sv_Target0.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "IsEmissive"="true" "LIGHTMODE"="SHADOWCASTER" "QUEUE"="Transparent+0" "RenderType"="Transparent" "SHADOWSUPPORT"="true" }
            Cull Off
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _UnityPerCameraCB : register(b0)
            {
                float4 _Time;
                float4 _Color;
                float3 _WorldSpaceCameraPos;
                float4 _ProjectionParams;
                float _MaskSoftness2;
                float2 _Mask2Speed;
                float4 _Mask2_ST;
                float _MaskSoftness;
                float4 _ZBufferParams;
                float4 _Mask_ST;
                float _Softness;
                float _DepthFadeDistance;
                float _Alpha;
            };
            cbuffer _UnityLightingCB : register(b1)
            {
                float4 _WorldSpaceLightPos0;
            };
            cbuffer _UnityShadowsCB : register(b2)
            {
                float4 unity_LightShadowBias;
            };
            cbuffer _UnityPerDrawCB : register(b3)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
            };
            cbuffer _UnityPerFrameCB : register(b4)
            {
                float4x4 unity_MatrixVP;
            };
            SamplerState sampler_Mask;
            SamplerState sampler_Mask2;
            SamplerState sampler_texcoord;
            SamplerState sampler_linear_clamp3;
            Texture2D _Mask;
            Texture2D _Mask2;
            Texture2D _texcoord;
            Texture3D t3;
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
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
            };
            struct program44Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
            };
            struct program44Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program41Output vert(program41Input i)
            {
                program41Output o = (program41Output)0;
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
                o.texcoord4.xyz = unitWorldNormal_xyz_2.xyz;
                float4 unity_LightShadowBiasSelect_xyzw_4 = (((unity_LightShadowBias.z != 0)).xxxx ? (mad(-unitWorldNormal_xyz_2.xyzx, r0_w_8.xxxx, worldPos_xyzw_4.xyzx)).xyzx : worldPos_xyzw_4.xyzx);
                float unity_LightShadowBiasSelect_x_4 = unity_LightShadowBiasSelect_xyzw_4.x;
                float unity_LightShadowBiasSelect_y_3 = unity_LightShadowBiasSelect_xyzw_4.y;
                float unity_LightShadowBiasSelect_z_3 = unity_LightShadowBiasSelect_xyzw_4.z;
                float4 r2_xyzw_4 = (unity_LightShadowBiasSelect_y_3.xxxx * unity_MatrixVP[1]);
                float4 r2_xyzw_5 = mad(unity_MatrixVP[0], unity_LightShadowBiasSelect_x_4.xxxx, r2_xyzw_4);
                float4 r0_xyzw_5 = mad(unity_MatrixVP[2], unity_LightShadowBiasSelect_z_3.xxxx, r2_xyzw_5);
                float4 r0_xyzw_6 = mad(unity_MatrixVP[3], worldPos_xyzw_4.wwww, r0_xyzw_5);
                float r0_z_6 = mad(unity_LightShadowBias.y, (-r0_xyzw_6.z + min(r0_xyzw_6.w, r0_xyzw_6.z)), r0_xyzw_6.z);
                o.sv_Position0.xyzw = float4(r0_xyzw_6.x, r0_xyzw_6.y, r0_z_6, r0_xyzw_6.w);
                o.texcoord3.zw = (float4(r0_z_6, r0_z_6, r0_z_6, r0_xyzw_6.w)).zw;
                o.texcoord1.xy = (i.texcoord0.xyxx).xy;
                float4 worldPos_xyzw_7 = (i.position0.yyyy * unity_ObjectToWorld[1].xyzx);
                float worldPos_x_7 = worldPos_xyzw_7.x;
                float worldPos_y_5 = worldPos_xyzw_7.y;
                float worldPos_z_5 = worldPos_xyzw_7.z;
                float4 worldPos_xyzw_8 = mad(unity_ObjectToWorld[0].xyzx, i.position0.xxxx, float4(worldPos_x_7, worldPos_y_5, worldPos_z_5, worldPos_x_7));
                float worldPos_x_8 = worldPos_xyzw_8.x;
                float worldPos_y_6 = worldPos_xyzw_8.y;
                float worldPos_z_6 = worldPos_xyzw_8.z;
                float4 worldPos_xyzw_9 = mad(unity_ObjectToWorld[2].xyzx, i.position0.zzzz, float4(worldPos_x_8, worldPos_y_6, worldPos_z_6, worldPos_x_8));
                float worldPos_x_9 = worldPos_xyzw_9.x;
                float worldPos_y_7 = worldPos_xyzw_9.y;
                float worldPos_z_7 = worldPos_xyzw_9.z;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, float4(worldPos_x_9, worldPos_y_7, worldPos_z_7, worldPos_x_9))).xyz;
                float r0_y_6 = (r0_xyzw_6.y * _ProjectionParams.x);
                float2 r0_xz_7 = ((r0_xyzw_6.xxwx * float4(0.5, 0, 0.5, 0))).xz;
                float r0_w_11 = (r0_y_6 * 0.5);
                o.texcoord3.xy = ((r0_xz_7.yyyy + float4(r0_xz_7.x, r0_w_11, r0_xz_7.x, r0_xz_7.x))).xy;
                return o;
            }
            #pragma fragment frag
            program44Output frag(program44Input i)
            {
                program44Output o = (program44Output)0;
                #define LinearEyeDepth(d) (1.0 / (_ZBufferParams.z * (d) + _ZBufferParams.w))
                float2 uvMask2_xy_1 = (mad(i.texcoord1.xyxx, _Mask2_ST.xyxx, _Mask2_ST.zwzz)).xy;
                float4 r0_xyzw_3 = _Mask.Sample(sampler_Mask, ((mad(_Time.yyyy, _Mask2Speed.xyxx, uvMask2_xy_1.xyxx)).xyxx).xy);
                float r0_y_4 = ((float4(1, 1, 1, 1) / _MaskSoftness2)).y;
                float r0_x_4 = saturate((r0_y_4 * r0_xyzw_3.x));
                float r0_y_5 = mad(r0_x_4, -2, 3);
                float4 uvMask_xyzw_6 = mad(i.texcoord1.xxyx, _Mask_ST.xxyx, _Mask_ST.zzwz);
                float uvMask_y_6 = uvMask_xyzw_6.y;
                float uvMask_z_2 = uvMask_xyzw_6.z;
                float4 sampleMask_xyzw_1 = _Mask2.Sample(sampler_Mask2, (float4(uvMask_y_6, uvMask_z_2, uvMask_y_6, uvMask_y_6)).xy);
                float r0_y_7 = ((float4(1, 1, 1, 1) / _MaskSoftness)).y;
                float r0_y_8 = saturate((r0_y_7 * sampleMask_xyzw_1.x));
                float r0_z_3 = mad(r0_y_8, -2, 3);
                float r0_y_9 = (r0_y_8 * r0_y_8);
                float r0_y_10 = (r0_y_9 * r0_z_3);
                float4 viewDir_xyzw_11 = (-i.texcoord2.xxyz + _WorldSpaceCameraPos.xxyz);
                float viewDir_y_11 = viewDir_xyzw_11.y;
                float viewDir_z_4 = viewDir_xyzw_11.z;
                float viewDir_w_2 = viewDir_xyzw_11.w;
                float4 unitViewDir_xyzw_12 = (float4(viewDir_y_11, viewDir_y_11, viewDir_z_4, viewDir_w_2) * (rsqrt(dot(float4(viewDir_y_11, viewDir_z_4, viewDir_w_2, viewDir_y_11), float4(viewDir_y_11, viewDir_z_4, viewDir_w_2, viewDir_y_11)))).xxxx);
                float unitViewDir_y_12 = unitViewDir_xyzw_12.y;
                float unitViewDir_z_5 = unitViewDir_xyzw_12.z;
                float unitViewDir_w_3 = unitViewDir_xyzw_12.w;
                float r0_y_13 = dot(i.texcoord4.xyzx, float4(unitViewDir_y_12, unitViewDir_z_5, unitViewDir_w_3, unitViewDir_y_12));
                float r0_z_6 = ((float4(1, 1, 1, 1) / _Softness)).z;
                float r0_y_14 = saturate((r0_z_6 * abs(r0_y_13)));
                float r0_z_7 = mad(r0_y_14, -2, 3);
                float r0_y_15 = (r0_y_14 * r0_y_14);
                float r0_y_16 = (r0_y_15 * r0_z_7);
                float r0_y_17 = (i.texcoord3.w + 1E-11);
                float4 r0_xyzw_18 = (i.texcoord3.xxyz / r0_y_17.xxxx);
                float r0_y_18 = r0_xyzw_18.y;
                float r0_z_8 = r0_xyzw_18.z;
                float r0_w_4 = r0_xyzw_18.w;
                float4 r1_xyzw_4 = _texcoord.Sample(sampler_texcoord, (float4(r0_y_18, r0_z_8, r0_y_18, r0_y_18)).xy);
                float r0_y_20 = LinearEyeDepth(r0_w_4);
                float r0_z_10 = LinearEyeDepth(r1_xyzw_4.x);
                float r0_y_21 = (-r0_y_20 + r0_z_10);
                float r0_y_22 = (r0_y_21 / _DepthFadeDistance);
                float r0_y_23 = min(abs(r0_y_22), 1);
                float r0_x_11 = ((r0_y_23 * (r0_y_16 * ((r0_y_10 * ((r0_x_4 * r0_x_4) * r0_y_5)) * _Color.w))) * _Alpha);
                float r0_z_11 = (r0_x_11 * 0.9375);
                float4 r0_xyzw_12 = (i.sv_Position0.xyxx * float4(0.25, 0.25, 0, 0));
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_24 = r0_xyzw_12.y;
                float4 r0_xyzw_13 = t3.Sample(sampler_linear_clamp3, (float4(r0_x_12, r0_y_24, r0_z_11, r0_x_12)).xyz);
                if (((r0_xyzw_13.w + -0.01) < 0)) discard;
                o.sv_Target0.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Diffuse"
    CustomEditor "ASEMaterialInspector"
}
