Shader "Corpus/12 Forward Lighting"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo", 2D) = "" {}
        _SpecColor ("Specular", Color) = (0.2,0.2,0.2,1)
        _Shininess ("Shininess", Range(0.01, 1)) = 0.1
        _Emission ("Emission", Color) = (0,0,0,0)
    }
    SubShader
    {
        Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
        LOD 0
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            // Folded keyword variants (base state emitted): FOG_LINEAR, LIGHTPROBE_SH, SHADOWS_SCREEN
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _SpecColor : packoffset(c3);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
                float4 _Emission : packoffset(c6);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0;
                float4 unity_4LightPosX0;
                float4 unity_4LightPosY0;
                float4 unity_4LightPosZ0;
                float4 unity_4LightAtten0;
                float4 unity_LightColor[8];
                float4x4 unity_MatrixVP;
                float4 unity_SHAr;
                float4 unity_SHAg;
                float4 unity_SHAb;
                float4 unity_SHBr;
                float4 unity_SHBg;
                float4 unity_SHBb;
                float4 unity_SHC;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[11];
            };
            cbuffer _UnityProbeVolumeCB_b3
            {
                float4 unity_ProbeVolumeParams : packoffset(c0);
                float4x4 unity_ProbeVolumeWorldToObject : packoffset(c1);
                float3 unity_ProbeVolumeSizeInv : packoffset(c5);
                float3 unity_ProbeVolumeMin : packoffset(c6);
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture3D t1;
            struct program2Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program2Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program22Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program22Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program2Output vert(program2Input i)
            {
                program2Output o = (program2Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program22Output frag(program22Input i)
            {
                program22Output o = (program22Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r0_xyzw_2 = (r0_xyzw_1 * _Color);
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float4 lightDir_xyzw_3 = ((rsqrt(dot(_WorldSpaceLightPos0.xyzx, _WorldSpaceLightPos0.xyzx))).xxxx * _WorldSpaceLightPos0.xyzx);
                float lightDir_x_3 = lightDir_xyzw_3.x;
                float lightDir_y_1 = lightDir_xyzw_3.y;
                float lightDir_z_1 = lightDir_xyzw_3.z;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r2_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r2_w_2 = rsqrt(r2_w_1);
                float3 r3_xyz_2 = (mad(viewDir_xyz_1.xyzx, r2_w_2.xxxx, float4(lightDir_x_3, lightDir_y_1, lightDir_z_1, lightDir_x_3))).xyz;
                float3 halfVector_xyz_3 = normalize(r3_xyz_2);
                float r2_y_2 = saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), halfVector_xyz_3.xyzx));
                float r2_y_3 = log2(r2_y_2);
                float r2_y_4 = (r2_y_3 * 64);
                float r2_y_5 = exp2(r2_y_4);
                float r2_y_6 = (r2_y_5 * _SpecColor.x);
                float r2_z_2 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_13;
                float r3_y_13;
                float r3_z_13;
                float r3_w_4;
                if (r2_z_2)
                {
                    float r2_z_3 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_8 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_9 = ((r2_z_3.xxxx ? r3_xyz_8.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r3_xyzw_11 = (((unity_ProbeVolumeParamsSelect_xyz_9.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_11 = r3_xyzw_11.y;
                    float r3_z_11 = r3_xyzw_11.z;
                    float r3_w_2 = r3_xyzw_11.w;
                    float r2_z_4 = mad(r3_y_11, 0.25, 0.75);
                    float r2_w_5 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_11 = max(r2_w_5, r2_z_4);
                    float4 r3_xyzw_12 = t1.Sample(sampler_linear_clamp, (float4(r3_x_11, r3_z_11, r3_w_2, r3_x_11)).xyz);
                    r3_x_13 = r3_xyzw_12.x;
                    r3_y_13 = r3_xyzw_12.y;
                    r3_z_13 = r3_xyzw_12.z;
                    r3_w_4 = r3_xyzw_12.w;
                }
                else
                {
                    float4 r3_xyzw_4 = float4(1, 1, 1, 1);
                    r3_x_13 = r3_xyzw_4.x;
                    r3_y_13 = r3_xyzw_4.y;
                    r3_z_13 = r3_xyzw_4.z;
                    r3_w_4 = r3_xyzw_4.w;
                }
                float r2_z_6 = saturate(dot(float4(r3_x_13, r3_y_13, r3_z_13, r3_w_4), unity_OcclusionMaskSelector));
                float r1_w_1 = 1;
                float r3_x_14 = dot(unity_SHAr, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r3_y_14 = dot(unity_SHAg, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r3_z_14 = dot(unity_SHAb, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float4 r4_xyzw_1 = (float4(unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1, unitWorldNormal_x_3) * float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1));
                float r5_x_1 = dot(unity_SHBr, r4_xyzw_1);
                float r5_y_1 = dot(unity_SHBg, r4_xyzw_1);
                float r5_z_1 = dot(unity_SHBb, r4_xyzw_1);
                float r1_w_2 = (unitWorldNormal_y_1 * unitWorldNormal_y_1);
                float r1_w_3 = mad(unitWorldNormal_x_3, unitWorldNormal_x_3, -r1_w_2);
                float4 r4_xyzw_3 = (-i.texcoord2.xxxx + unity_4LightPosX0);
                float4 r5_xyzw_2 = (-i.texcoord2.yyyy + unity_4LightPosY0);
                float4 r6_xyzw_1 = (-i.texcoord2.zzzz + unity_4LightPosZ0);
                float4 r7_xyzw_4 = max(mad(r6_xyzw_1, r6_xyzw_1, mad(r4_xyzw_3, r4_xyzw_3, (r5_xyzw_2 * r5_xyzw_2))), float4(1E-06, 1E-06, 1E-06, 1E-06));
                float4 r5_xyzw_3 = (unitWorldNormal_y_1.xxxx * r5_xyzw_2);
                float4 r4_xyzw_4 = mad(r4_xyzw_3, unitWorldNormal_x_3.xxxx, r5_xyzw_3);
                float4 r1_xyzw_4 = mad(r6_xyzw_1, unitWorldNormal_z_1.xxxx, r4_xyzw_4);
                float4 r4_xyzw_5 = rsqrt(r7_xyzw_4);
                float4 r1_xyzw_5 = (r1_xyzw_4 * r4_xyzw_5);
                float4 r1_xyzw_6 = max(r1_xyzw_5, float4(0, 0, 0, 0));
                float4 r4_xyzw_6 = mad(r7_xyzw_4, unity_4LightAtten0, float4(1, 1, 1, 1));
                float4 r4_xyzw_7 = (float4(1, 1, 1, 1) / r4_xyzw_6);
                float4 r1_xyzw_7 = (r1_xyzw_6 * r4_xyzw_7);
                float4 r1_xyzw_8 = mad(cb2_values[9].xyzx, r1_xyzw_7.zzzz, (mad(cb2_values[7].xyzx, r1_xyzw_7.xxxx, ((r1_xyzw_7.yyyy * cb2_values[8].xyzx)).xyzx)).xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_z_6 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = mad(cb2_values[10].xyzx, r1_xyzw_7.wwww, float4(r1_x_8, r1_y_6, r1_z_6, r1_x_8));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_7 = r1_xyzw_9.y;
                float r1_z_7 = r1_xyzw_9.z;
                float4 r1_xyzw_10 = (float4(r1_x_9, r1_y_7, r1_z_7, r1_x_9) + ((float4(r3_x_14, r3_y_14, r3_z_14, r3_x_14) + (mad(unity_SHC.xyzx, r1_w_3.xxxx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1))).xyzx)).xyzx);
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_8 = r1_xyzw_10.y;
                float r1_z_8 = r1_xyzw_10.z;
                float4 r1_xyzw_11 = mad((((saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), float4(lightDir_x_3, lightDir_y_1, lightDir_z_1, lightDir_x_3)))).xxxx * _LightColor0.xyzx)).xyzx, r2_z_6.xxxx, float4(r1_x_10, r1_y_8, r1_z_8, r1_x_10));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_9 = r1_xyzw_11.y;
                float r1_z_9 = r1_xyzw_11.z;
                float4 r2_xyzw_5 = (r2_y_6.xxxx * _LightColor0.xyxz);
                float r2_x_5 = r2_xyzw_5.x;
                float r2_y_7 = r2_xyzw_5.y;
                float r2_w_7 = r2_xyzw_5.w;
                float4 r2_xyzw_6 = (r2_z_6.xxxx * float4(r2_x_5, r2_y_7, r2_w_7, r2_x_5));
                float r2_x_6 = r2_xyzw_6.x;
                float r2_y_8 = r2_xyzw_6.y;
                float r2_z_7 = r2_xyzw_6.z;
                o.sv_Target0.xyz = (((mad(r0_xyzw_2.xyzx, float4(r1_x_11, r1_y_9, r1_z_9, r1_x_11), float4(r2_x_6, r2_y_8, r2_z_7, r2_x_6))).xyzx + _Emission.xyzx)).xyz;
                o.sv_Target0.w = r0_xyzw_2.w;
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
            // Folded keyword variants (base state emitted): DIRECTIONAL, DIRECTIONAL_COOKIE, FOG_LINEAR, POINT_COOKIE, SHADOWS_CUBE, SHADOWS_DEPTH, SHADOWS_SCREEN, SHADOWS_SOFT, SPOT
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0;
                float4 _SpecColor;
                float4 _MainTex_ST;
                float4 _Color;
                float4 _Emission;
                float4 cb0_values[10];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
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
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            Texture3D t2;
            struct program37Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program37Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program81Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program81Output
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
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[8].xyxx, cb0_values[8].zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_3 = ((worldPos_xyzw_4.yyyy * _Color.xyzx)).xyz;
                float3 clipPos_xyz_4 = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_3.xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(_Emission.xyzx, worldPos_xyzw_4.zzzz, clipPos_xyz_4.xyzx)).xyz;
                o.texcoord4.xyz = (mad(cb0_values[7].xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program81Output frag(program81Input i)
            {
                program81Output o = (program81Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float3 r2_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r2_xyz_2 = normalize(r2_xyz_1);
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_6 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_7 = rsqrt(r0_w_6);
                float3 r3_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_7.xxxx, r2_xyz_2.xyzx)).xyz;
                float r0_w_8 = dot(r3_xyz_2.xyzx, r3_xyz_2.xyzx);
                float r0_w_9 = rsqrt(r0_w_8);
                float3 r4_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_10 = (unity_ProbeVolumeParams.x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r0_w_10)
                {
                    float r0_w_11 = (unity_ProbeVolumeParams.y == 1);
                    float3 r5_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_11.xxxx ? r5_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r5_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r0_w_12 = mad(r5_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r5_x_8 = max(r0_w_12, r1_w_1);
                    float4 r5_xyzw_9 = t2.Sample(sampler_linear_clamp, (float4(r5_x_8, r5_z_8, r5_w_2, r5_x_8)).xyz);
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
                float r0_w_14 = saturate(dot(float4(r5_x_10, r5_y_10, r5_z_10, r5_w_4), unity_OcclusionMaskSelector));
                float r1_w_3 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float4 r4_xyzw_5 = t1.Sample(sampler_linear_clamp1, (r1_w_3.xxxx).xy);
                float r0_w_15 = (r0_w_14 * r4_xyzw_5.x);
                float r1_w_4 = saturate(dot(unitWorldNormal_xyz_1.xyzx, r2_xyz_2.xyzx));
                                float r1_x_6 = (pow(saturate(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_9.xxxx * r3_xyz_2.xyzx)).xyzx)), 64) * _SpecColor.x);
                o.sv_Target0.xyz = ((r0_w_15.xxxx * (((mad(((r0_xyzw_1.xyzx * cb0_values[9].xyzx)).xyzx, r1_w_4.xxxx, r1_x_6.xxxx)).xyzx * _LightColor0.xyzx)).xyzx)).xyz;
                o.sv_Target0.w = 0;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="Vertex" "QUEUE"="Geometry" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
            // Folded keyword variants (base state emitted): FOG_LINEAR
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityLightingCB_b1
            {
                float4 unity_LightColor[8];
                float4 unity_LightPosition[8];
                float4 unity_LightAtten[8];
                float4 unity_SpotDirection[8];
                float4 cb1_values[65];
            };
            cbuffer _UnityPerDrawCB_b2
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b3
            {
                float4 glstate_lightmodel_ambient : packoffset(c0);
                float4x4 unity_MatrixV : packoffset(c9);
                float4x4 unity_MatrixInvV : packoffset(c13);
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program108Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
            };
            struct program108Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 color0 : COLOR0;
            };
            struct program112Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 color0 : COLOR0;
            };
            struct program112Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program108Output vert(program108Input i)
            {
                program108Output o = (program108Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float3 r0_xyz_4 = (mad(unity_WorldToObject[3].xyzx, unity_MatrixInvV[0].wwww, (mad(unity_WorldToObject[2].xyzx, unity_MatrixInvV[0].zzzz, (mad(unity_WorldToObject[0].xyzx, unity_MatrixInvV[0].xxxx, ((unity_WorldToObject[1].xyzx * unity_MatrixInvV[0].yyyy)).xyzx)).xyzx)).xyzx)).xyz;
                float3 r1_xyz_4 = (mad(unity_WorldToObject[3].xyzx, unity_MatrixInvV[1].wwww, (mad(unity_WorldToObject[2].xyzx, unity_MatrixInvV[1].zzzz, (mad(unity_WorldToObject[0].xyzx, unity_MatrixInvV[1].xxxx, ((unity_WorldToObject[1].xyzx * unity_MatrixInvV[1].yyyy)).xyzx)).xyzx)).xyzx)).xyz;
                float3 r2_xyz_4 = (mad(unity_WorldToObject[3].xyzx, unity_MatrixInvV[2].wwww, (mad(unity_WorldToObject[2].xyzx, unity_MatrixInvV[2].zzzz, (mad(unity_WorldToObject[0].xyzx, unity_MatrixInvV[2].xxxx, ((unity_WorldToObject[1].xyzx * unity_MatrixInvV[2].yyyy)).xyzx)).xyzx)).xyzx)).xyz;
                float4 worldPos_xyzw_4 = UnityObjectToWorldPos(i.position0.xyz);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_4);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float3 clipPos_xyz_4 = ((worldPos_xyzw_4.yyyy * unity_MatrixV[1].xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(unity_MatrixV[2].xyzx, worldPos_xyzw_4.zzzz, (mad(unity_MatrixV[0].xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_4.xyzx)).xyzx)).xyz;
                float3 clipPos_xyz_6 = (mad(unity_MatrixV[3].xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                float r0_x_5 = dot(r0_xyz_4.xyzx, i.normal0.xyzx);
                float r0_y_5 = dot(r1_xyz_4.xyzx, i.normal0.xyzx);
                float r0_z_5 = dot(r2_xyz_4.xyzx, i.normal0.xyzx);
                float r0_w_1 = dot(float4(r0_x_5, r0_y_5, r0_z_5, r0_x_5), float4(r0_x_5, r0_y_5, r0_z_5, r0_x_5));
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r0_xyz_6 = ((r0_w_2.xxxx * float4(r0_x_5, r0_y_5, r0_z_5, r0_x_5))).xyz;
                float r0_w_3 = 0;
                float r0_w_4 = r0_w_3;
                float3 r2_xyz_6 = (((glstate_lightmodel_ambient.xyzx + glstate_lightmodel_ambient.xyzx)).xyzx).xyz;
                float r1_w_2;
                float3 r4_xyz_7;
                float r1_w_3;
                float r1_w_4;
                float r2_w_1;
                float3 r4_xyz_8;
                float r1_w_5;
                float r1_w_6;
                float r2_w_2;
                float r2_w_3;
                float r2_w_4;
                float r2_w_5;
                float r1_w_7;
                float r2_w_6;
                float r2_w_7;
                float r1_w_8;
                float r0_w_5;
                [loop]
                while (true)
                {
                    r1_w_2 = (r0_w_4 >= 4);
                    if (r1_w_2) break;
                    r4_xyz_7 = (mad(-clipPos_xyz_6.xyzx, cb1_values[r0_w_4 + 15].wwww, cb1_values[r0_w_4 + 15].xyzx)).xyz;
                    r1_w_3 = dot(r4_xyz_7.xyzx, r4_xyz_7.xyzx);
                    r1_w_4 = max(r1_w_3, 1E-06);
                    r2_w_1 = rsqrt(r1_w_4);
                    r4_xyz_8 = ((r2_w_1.xxxx * r4_xyz_7.xyzx)).xyz;
                    r1_w_5 = mad(r1_w_4, cb1_values[r0_w_4 + 23].z, 1);
                    r1_w_6 = ((float4(1, 1, 1, 1) / r1_w_5)).w;
                    r2_w_2 = dot(r4_xyz_8.xyzx, cb1_values[r0_w_4 + 31].xyzx);
                    r2_w_3 = max(r2_w_2, 0);
                    r2_w_4 = (r2_w_3 + -cb1_values[r0_w_4 + 23].x);
                    r2_w_5 = saturate((r2_w_4 * cb1_values[r0_w_4 + 23].y));
                    r1_w_7 = (r1_w_6 * r2_w_5);
                    r2_w_6 = dot(r0_xyz_6.xyzx, r4_xyz_8.xyzx);
                    r2_w_7 = max(r2_w_6, 0);
                    r1_w_8 = (r1_w_7 * r2_w_7);
                    r0_w_5 = (r0_w_4 + 1);
                    r0_w_4 = r0_w_5;
                    r2_xyz_6 = (mad(cb1_values[r0_w_4 + 7].xyzx, r1_w_8.xxxx, r2_xyz_6.xyzx)).xyz;
                }
                o.color0.xyz = r2_xyz_6.xyz;
                o.color0.w = 1;
                return o;
            }
            #pragma fragment frag
            program112Output frag(program112Input i)
            {
                program112Output o = (program112Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                o.sv_Target0.xyzw = ((r0_xyzw_1 * _Color) * i.color0.xyzw);
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Diffuse"
}
