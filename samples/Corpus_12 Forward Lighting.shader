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
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
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
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
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
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            Texture3D t2;
            struct program13Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program13Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program29Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program29Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program13Output vert(program13Input i)
            {
                program13Output o = (program13Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord5.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_z_8 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r0_z_9 = rsqrt(r0_z_8);
                o.texcoord1.xyz = ((r0_z_9.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r0_xyzw_8 = (clipPos_xyzw_7.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_z_10 = r0_xyzw_8.z;
                float r0_w_8 = (r0_y_8 * 0.5);
                o.texcoord5.xy = ((r0_z_10.xxxx + float4(r0_x_8, r0_w_8, r0_x_8, r0_x_8))).xy;
                return o;
            }
            #pragma fragment frag
            program29Output frag(program29Input i)
            {
                program29Output o = (program29Output)0;
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
                float3 r4_xyz_1 = (mad(viewDir_xyz_1.xyzx, r2_w_2.xxxx, float4(lightDir_x_3, lightDir_y_1, lightDir_z_1, lightDir_x_3))).xyz;
                float3 halfVector_xyz_2 = normalize(r4_xyz_1);
                float r2_y_2 = saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), halfVector_xyz_2.xyzx));
                float r2_y_3 = log2(r2_y_2);
                float r2_y_4 = (r2_y_3 * 64);
                float r2_y_5 = exp2(r2_y_4);
                float r2_y_6 = (r2_y_5 * _SpecColor.x);
                float r4_x_3 = cb4_values[9].z;
                float r4_y_3 = cb4_values[10].z;
                float r4_z_3 = cb4_values[11].z;
                float r2_z_2 = dot(viewDir_xyz_1.xyzx, float4(r4_x_3, r4_y_3, r4_z_3, r4_x_3));
                float3 r3_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_5 = dot(r3_xyz_2.xyzx, r3_xyz_2.xyzx);
                float r2_w_6 = sqrt(r2_w_5);
                float r2_w_7 = (-r2_z_2 + r2_w_6);
                float r2_z_3 = mad(cb3_values[25].w, r2_w_7, r2_z_2);
                float r2_z_4 = saturate(mad(r2_z_3, cb3_values[24].z, cb3_values[24].w));
                float r2_w_8 = (cb6_values[0].x == 1);
                float r3_x_12;
                float r3_y_13;
                float r3_z_12;
                float r3_w_4;
                if (r2_w_8)
                {
                    float r2_w_9 = (cb6_values[0].y == 1);
                    float3 r3_xyz_7 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r3_xyzw_10 = (((((r2_w_9.xxxx ? r3_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r3_y_10 = r3_xyzw_10.y;
                    float r3_z_10 = r3_xyzw_10.z;
                    float r3_w_2 = r3_xyzw_10.w;
                    float r2_w_10 = mad(r3_y_10, 0.25, 0.75);
                    float r3_y_11 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r3_x_10 = max(r2_w_10, r3_y_11);
                    float4 r3_xyzw_11 = t2.Sample(sampler_linear_clamp, (float4(r3_x_10, r3_z_10, r3_w_2, r3_x_10)).xyz);
                    r3_x_12 = r3_xyzw_11.x;
                    r3_y_13 = r3_xyzw_11.y;
                    r3_z_12 = r3_xyzw_11.z;
                    r3_w_4 = r3_xyzw_11.w;
                }
                else
                {
                    float4 r3_xyzw_3 = float4(1, 1, 1, 1);
                    r3_x_12 = r3_xyzw_3.x;
                    r3_y_13 = r3_xyzw_3.y;
                    r3_z_12 = r3_xyzw_3.z;
                    r3_w_4 = r3_xyzw_3.w;
                }
                float r2_w_12 = saturate(dot(float4(r3_x_12, r3_y_13, r3_z_12, r3_w_4), unity_OcclusionMaskSelector));
                float4 r3_xyzw_13 = (i.texcoord5.xyxx / i.texcoord5.wwww);
                float r3_x_13 = r3_xyzw_13.x;
                float r3_y_14 = r3_xyzw_13.y;
                float4 r3_xyzw_14 = t1.Sample(sampler_linear_clamp1, (float4(r3_x_13, r3_y_14, r3_x_13, r3_x_13)).xy);
                float r2_w_13 = (r2_w_12 + -r3_xyzw_14.x);
                float r2_z_5 = mad(r2_z_4, r2_w_13, r3_xyzw_14.x);
                float r1_w_1 = 1;
                float r3_x_15 = dot(unity_SHAr, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r3_y_16 = dot(unity_SHAg, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r3_z_14 = dot(unity_SHAb, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float4 r4_xyzw_4 = (float4(unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1, unitWorldNormal_x_3) * float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1));
                float r5_x_1 = dot(unity_SHBr, r4_xyzw_4);
                float r5_y_1 = dot(unity_SHBg, r4_xyzw_4);
                float r5_z_1 = dot(unity_SHBb, r4_xyzw_4);
                float r1_w_2 = (unitWorldNormal_y_1 * unitWorldNormal_y_1);
                float r1_w_3 = mad(unitWorldNormal_x_3, unitWorldNormal_x_3, -r1_w_2);
                float4 r3_xyzw_16 = (float4(r3_x_15, r3_y_16, r3_z_14, r3_x_15) + (mad(unity_SHC.xyzx, r1_w_3.xxxx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1))).xyzx);
                float r3_x_16 = r3_xyzw_16.x;
                float r3_y_17 = r3_xyzw_16.y;
                float r3_z_15 = r3_xyzw_16.z;
                float4 r4_xyzw_6 = (-i.texcoord2.xxxx + unity_4LightPosX0);
                float4 r5_xyzw_2 = (-i.texcoord2.yyyy + unity_4LightPosY0);
                float4 r6_xyzw_1 = (-i.texcoord2.zzzz + unity_4LightPosZ0);
                float4 r7_xyzw_4 = max(mad(r6_xyzw_1, r6_xyzw_1, mad(r4_xyzw_6, r4_xyzw_6, (r5_xyzw_2 * r5_xyzw_2))), float4(1E-06, 1E-06, 1E-06, 1E-06));
                float4 r5_xyzw_3 = (unitWorldNormal_y_1.xxxx * r5_xyzw_2);
                float4 r4_xyzw_7 = mad(r4_xyzw_6, unitWorldNormal_x_3.xxxx, r5_xyzw_3);
                float4 r1_xyzw_4 = mad(r6_xyzw_1, unitWorldNormal_z_1.xxxx, r4_xyzw_7);
                float4 r4_xyzw_8 = rsqrt(r7_xyzw_4);
                float4 r1_xyzw_5 = (r1_xyzw_4 * r4_xyzw_8);
                float4 r1_xyzw_6 = max(r1_xyzw_5, float4(0, 0, 0, 0));
                float4 r4_xyzw_9 = mad(r7_xyzw_4, unity_4LightAtten0, float4(1, 1, 1, 1));
                float4 r4_xyzw_10 = (float4(1, 1, 1, 1) / r4_xyzw_9);
                float4 r1_xyzw_7 = (r1_xyzw_6 * r4_xyzw_10);
                float4 r1_xyzw_8 = mad(cb2_values[9].xyzx, r1_xyzw_7.zzzz, (mad(cb2_values[7].xyzx, r1_xyzw_7.xxxx, ((r1_xyzw_7.yyyy * cb2_values[8].xyzx)).xyzx)).xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_z_6 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = mad(cb2_values[10].xyzx, r1_xyzw_7.wwww, float4(r1_x_8, r1_y_6, r1_z_6, r1_x_8));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_7 = r1_xyzw_9.y;
                float r1_z_7 = r1_xyzw_9.z;
                float4 r1_xyzw_10 = (float4(r1_x_9, r1_y_7, r1_z_7, r1_x_9) + float4(r3_x_16, r3_y_17, r3_z_15, r3_x_16));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_8 = r1_xyzw_10.y;
                float r1_z_8 = r1_xyzw_10.z;
                float4 r3_xyzw_17 = ((saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), float4(lightDir_x_3, lightDir_y_1, lightDir_z_1, lightDir_x_3)))).xxxx * _LightColor0.xyzx);
                float r3_x_17 = r3_xyzw_17.x;
                float r3_y_18 = r3_xyzw_17.y;
                float r3_z_16 = r3_xyzw_17.z;
                float4 r1_xyzw_11 = mad(float4(r3_x_17, r3_y_18, r3_z_16, r3_x_17), r2_z_5.xxxx, float4(r1_x_10, r1_y_8, r1_z_8, r1_x_10));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_9 = r1_xyzw_11.y;
                float r1_z_9 = r1_xyzw_11.z;
                float4 r2_xyzw_5 = (r2_y_6.xxxx * _LightColor0.xyxz);
                float r2_x_5 = r2_xyzw_5.x;
                float r2_y_7 = r2_xyzw_5.y;
                float r2_w_14 = r2_xyzw_5.w;
                float4 r2_xyzw_6 = (r2_z_5.xxxx * float4(r2_x_5, r2_y_7, r2_w_14, r2_x_5));
                float r2_x_6 = r2_xyzw_6.x;
                float r2_y_8 = r2_xyzw_6.y;
                float r2_z_6 = r2_xyzw_6.z;
                float r1_x_16 = saturate(mad(max((((i.texcoord3.x / cb1_values[5].y) + 1) * cb1_values[5].z), 0), cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = (mad(r1_x_16.xxxx, (((((mad(r0_xyzw_2.xyzx, float4(r1_x_11, r1_y_9, r1_z_9, r1_x_11), float4(r2_x_6, r2_y_8, r2_z_6, r2_x_6))).xyzx + _Emission.xyzx)).xyzx + -cb5_values[0].xyzx)).xyzx, cb5_values[0].xyzx)).xyz;
                o.sv_Target0.w = r0_xyzw_2.w;
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
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
                float4 _Emission : packoffset(c6);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
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
            cbuffer cb3 : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb3_values[21];
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture3D t1;
            struct program12Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program12Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program27Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program27Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program12Output vert(program12Input i)
            {
                program12Output o = (program12Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord5.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_z_8 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r0_z_9 = rsqrt(r0_z_8);
                o.texcoord1.xyz = ((r0_z_9.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r0_xyzw_8 = (clipPos_xyzw_7.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_z_10 = r0_xyzw_8.z;
                float r0_w_8 = (r0_y_8 * 0.5);
                o.texcoord5.xy = ((r0_z_10.xxxx + float4(r0_x_8, r0_w_8, r0_x_8, r0_x_8))).xy;
                return o;
            }
            #pragma fragment frag
            program27Output frag(program27Input i)
            {
                program27Output o = (program27Output)0;
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
                float r2_z_2 = (cb4_values[0].x == 1);
                float r3_x_13;
                float r3_y_13;
                float r3_z_13;
                float r3_w_4;
                if (r2_z_2)
                {
                    float r2_z_3 = (cb4_values[0].y == 1);
                    float3 r3_xyz_8 = (((mad(cb4_values[3].xyzx, i.texcoord2.zzzz, (mad(cb4_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r3_xyzw_11 = (((((r2_z_3.xxxx ? r3_xyz_8.xyzx : i.texcoord2.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r3_y_11 = r3_xyzw_11.y;
                    float r3_z_11 = r3_xyzw_11.z;
                    float r3_w_2 = r3_xyzw_11.w;
                    float r2_z_4 = mad(r3_y_11, 0.25, 0.75);
                    float r2_w_5 = mad(cb4_values[0].z, 0.5, 0.75);
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
                float r1_x_16 = saturate(mad(max((((i.texcoord3.x / cb1_values[5].y) + 1) * cb1_values[5].z), 0), unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w));
                o.sv_Target0.xyz = (mad(r1_x_16.xxxx, (((((mad(r0_xyzw_2.xyzx, float4(r1_x_11, r1_y_9, r1_z_9, r1_x_11), float4(r2_x_6, r2_y_8, r2_z_7, r2_x_6))).xyzx + _Emission.xyzx)).xyzx + -unity_ProbeVolumeParams.xyzx)).xyzx, unity_ProbeVolumeParams.xyzx)).xyz;
                o.sv_Target0.w = r0_xyzw_2.w;
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
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
                float4 _Emission : packoffset(c6);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
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
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            Texture3D t2;
            struct program11Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program11Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program28Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program28Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program11Output vert(program11Input i)
            {
                program11Output o = (program11Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program28Output frag(program28Input i)
            {
                program28Output o = (program28Output)0;
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
                float3 r4_xyz_1 = (mad(viewDir_xyz_1.xyzx, r2_w_2.xxxx, float4(lightDir_x_3, lightDir_y_1, lightDir_z_1, lightDir_x_3))).xyz;
                float3 halfVector_xyz_2 = normalize(r4_xyz_1);
                float r2_y_2 = saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), halfVector_xyz_2.xyzx));
                float r2_y_3 = log2(r2_y_2);
                float r2_y_4 = (r2_y_3 * 64);
                float r2_y_5 = exp2(r2_y_4);
                float r2_y_6 = (r2_y_5 * _SpecColor.x);
                float r4_x_3 = cb4_values[9].z;
                float r4_y_3 = cb4_values[10].z;
                float r4_z_3 = cb4_values[11].z;
                float r2_z_2 = dot(viewDir_xyz_1.xyzx, float4(r4_x_3, r4_y_3, r4_z_3, r4_x_3));
                float3 r3_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_5 = dot(r3_xyz_2.xyzx, r3_xyz_2.xyzx);
                float r2_w_6 = sqrt(r2_w_5);
                float r2_w_7 = (-r2_z_2 + r2_w_6);
                float r2_z_3 = mad(cb3_values[25].w, r2_w_7, r2_z_2);
                float r2_z_4 = saturate(mad(r2_z_3, cb3_values[24].z, cb3_values[24].w));
                float r2_w_8 = (cb6_values[0].x == 1);
                float r3_x_12;
                float r3_y_13;
                float r3_z_12;
                float r3_w_4;
                if (r2_w_8)
                {
                    float r2_w_9 = (cb6_values[0].y == 1);
                    float3 r3_xyz_7 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r3_xyzw_10 = (((((r2_w_9.xxxx ? r3_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r3_y_10 = r3_xyzw_10.y;
                    float r3_z_10 = r3_xyzw_10.z;
                    float r3_w_2 = r3_xyzw_10.w;
                    float r2_w_10 = mad(r3_y_10, 0.25, 0.75);
                    float r3_y_11 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r3_x_10 = max(r2_w_10, r3_y_11);
                    float4 r3_xyzw_11 = t2.Sample(sampler_linear_clamp, (float4(r3_x_10, r3_z_10, r3_w_2, r3_x_10)).xyz);
                    r3_x_12 = r3_xyzw_11.x;
                    r3_y_13 = r3_xyzw_11.y;
                    r3_z_12 = r3_xyzw_11.z;
                    r3_w_4 = r3_xyzw_11.w;
                }
                else
                {
                    float4 r3_xyzw_3 = float4(1, 1, 1, 1);
                    r3_x_12 = r3_xyzw_3.x;
                    r3_y_13 = r3_xyzw_3.y;
                    r3_z_12 = r3_xyzw_3.z;
                    r3_w_4 = r3_xyzw_3.w;
                }
                float r2_w_12 = saturate(dot(float4(r3_x_12, r3_y_13, r3_z_12, r3_w_4), unity_OcclusionMaskSelector));
                float4 r3_xyzw_13 = (i.texcoord5.xyxx / i.texcoord5.wwww);
                float r3_x_13 = r3_xyzw_13.x;
                float r3_y_14 = r3_xyzw_13.y;
                float4 r3_xyzw_14 = t1.Sample(sampler_linear_clamp1, (float4(r3_x_13, r3_y_14, r3_x_13, r3_x_13)).xy);
                float r2_w_13 = (r2_w_12 + -r3_xyzw_14.x);
                float r2_z_5 = mad(r2_z_4, r2_w_13, r3_xyzw_14.x);
                float r1_w_1 = 1;
                float r3_x_15 = dot(unity_SHAr, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r3_y_16 = dot(unity_SHAg, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r3_z_14 = dot(unity_SHAb, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float4 r4_xyzw_4 = (float4(unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1, unitWorldNormal_x_3) * float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1));
                float r5_x_1 = dot(unity_SHBr, r4_xyzw_4);
                float r5_y_1 = dot(unity_SHBg, r4_xyzw_4);
                float r5_z_1 = dot(unity_SHBb, r4_xyzw_4);
                float r1_w_2 = (unitWorldNormal_y_1 * unitWorldNormal_y_1);
                float r1_w_3 = mad(unitWorldNormal_x_3, unitWorldNormal_x_3, -r1_w_2);
                float4 r3_xyzw_16 = (float4(r3_x_15, r3_y_16, r3_z_14, r3_x_15) + (mad(unity_SHC.xyzx, r1_w_3.xxxx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1))).xyzx);
                float r3_x_16 = r3_xyzw_16.x;
                float r3_y_17 = r3_xyzw_16.y;
                float r3_z_15 = r3_xyzw_16.z;
                float4 r4_xyzw_6 = (-i.texcoord2.xxxx + unity_4LightPosX0);
                float4 r5_xyzw_2 = (-i.texcoord2.yyyy + unity_4LightPosY0);
                float4 r6_xyzw_1 = (-i.texcoord2.zzzz + unity_4LightPosZ0);
                float4 r7_xyzw_4 = max(mad(r6_xyzw_1, r6_xyzw_1, mad(r4_xyzw_6, r4_xyzw_6, (r5_xyzw_2 * r5_xyzw_2))), float4(1E-06, 1E-06, 1E-06, 1E-06));
                float4 r5_xyzw_3 = (unitWorldNormal_y_1.xxxx * r5_xyzw_2);
                float4 r4_xyzw_7 = mad(r4_xyzw_6, unitWorldNormal_x_3.xxxx, r5_xyzw_3);
                float4 r1_xyzw_4 = mad(r6_xyzw_1, unitWorldNormal_z_1.xxxx, r4_xyzw_7);
                float4 r4_xyzw_8 = rsqrt(r7_xyzw_4);
                float4 r1_xyzw_5 = (r1_xyzw_4 * r4_xyzw_8);
                float4 r1_xyzw_6 = max(r1_xyzw_5, float4(0, 0, 0, 0));
                float4 r4_xyzw_9 = mad(r7_xyzw_4, unity_4LightAtten0, float4(1, 1, 1, 1));
                float4 r4_xyzw_10 = (float4(1, 1, 1, 1) / r4_xyzw_9);
                float4 r1_xyzw_7 = (r1_xyzw_6 * r4_xyzw_10);
                float4 r1_xyzw_8 = mad(cb2_values[9].xyzx, r1_xyzw_7.zzzz, (mad(cb2_values[7].xyzx, r1_xyzw_7.xxxx, ((r1_xyzw_7.yyyy * cb2_values[8].xyzx)).xyzx)).xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_z_6 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = mad(cb2_values[10].xyzx, r1_xyzw_7.wwww, float4(r1_x_8, r1_y_6, r1_z_6, r1_x_8));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_7 = r1_xyzw_9.y;
                float r1_z_7 = r1_xyzw_9.z;
                float4 r1_xyzw_10 = (float4(r1_x_9, r1_y_7, r1_z_7, r1_x_9) + float4(r3_x_16, r3_y_17, r3_z_15, r3_x_16));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_8 = r1_xyzw_10.y;
                float r1_z_8 = r1_xyzw_10.z;
                float4 r3_xyzw_17 = ((saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), float4(lightDir_x_3, lightDir_y_1, lightDir_z_1, lightDir_x_3)))).xxxx * _LightColor0.xyzx);
                float r3_x_17 = r3_xyzw_17.x;
                float r3_y_18 = r3_xyzw_17.y;
                float r3_z_16 = r3_xyzw_17.z;
                float4 r1_xyzw_11 = mad(float4(r3_x_17, r3_y_18, r3_z_16, r3_x_17), r2_z_5.xxxx, float4(r1_x_10, r1_y_8, r1_z_8, r1_x_10));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_9 = r1_xyzw_11.y;
                float r1_z_9 = r1_xyzw_11.z;
                float4 r2_xyzw_5 = (r2_y_6.xxxx * _LightColor0.xyxz);
                float r2_x_5 = r2_xyzw_5.x;
                float r2_y_7 = r2_xyzw_5.y;
                float r2_w_14 = r2_xyzw_5.w;
                float4 r2_xyzw_6 = (r2_z_5.xxxx * float4(r2_x_5, r2_y_7, r2_w_14, r2_x_5));
                float r2_x_6 = r2_xyzw_6.x;
                float r2_y_8 = r2_xyzw_6.y;
                float r2_z_6 = r2_xyzw_6.z;
                float r1_x_16 = saturate(mad(max((((i.texcoord3.x / cb1_values[5].y) + 1) * cb1_values[5].z), 0), cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = (mad(r1_x_16.xxxx, (((((mad(r0_xyzw_2.xyzx, float4(r1_x_11, r1_y_9, r1_z_9, r1_x_11), float4(r2_x_6, r2_y_8, r2_z_6, r2_x_6))).xyzx + _Emission.xyzx)).xyzx + -cb5_values[0].xyzx)).xyzx, cb5_values[0].xyzx)).xyz;
                o.sv_Target0.w = r0_xyzw_2.w;
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
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
                float4 _Emission : packoffset(c6);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
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
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture3D t1;
            struct program10Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program10Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program26Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program26Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program10Output vert(program10Input i)
            {
                program10Output o = (program10Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program26Output frag(program26Input i)
            {
                program26Output o = (program26Output)0;
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
                float r2_z_2 = (cb4_values[0].x == 1);
                float r3_x_13;
                float r3_y_13;
                float r3_z_13;
                float r3_w_4;
                if (r2_z_2)
                {
                    float r2_z_3 = (cb4_values[0].y == 1);
                    float3 r3_xyz_8 = (((mad(cb4_values[3].xyzx, i.texcoord2.zzzz, (mad(cb4_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r3_xyzw_11 = (((((r2_z_3.xxxx ? r3_xyz_8.xyzx : i.texcoord2.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r3_y_11 = r3_xyzw_11.y;
                    float r3_z_11 = r3_xyzw_11.z;
                    float r3_w_2 = r3_xyzw_11.w;
                    float r2_z_4 = mad(r3_y_11, 0.25, 0.75);
                    float r2_w_5 = mad(cb4_values[0].z, 0.5, 0.75);
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
                float r1_x_16 = saturate(mad(max((((i.texcoord3.x / cb1_values[5].y) + 1) * cb1_values[5].z), 0), unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w));
                o.sv_Target0.xyz = (mad(r1_x_16.xxxx, (((((mad(r0_xyzw_2.xyzx, float4(r1_x_11, r1_y_9, r1_z_9, r1_x_11), float4(r2_x_6, r2_y_8, r2_z_7, r2_x_6))).xyzx + _Emission.xyzx)).xyzx + -unity_ProbeVolumeParams.xyzx)).xyzx, unity_ProbeVolumeParams.xyzx)).xyz;
                o.sv_Target0.w = r0_xyzw_2.w;
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
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            Texture3D t2;
            struct program5Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program5Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program25Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program25Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program5Output vert(program5Input i)
            {
                program5Output o = (program5Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r1_xyzw_3 = (float4(clipPos_xyzw_7.x, clipPos_xyzw_7.x, clipPos_xyzw_7.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_z_3 = r1_xyzw_3.z;
                float r1_w_4 = r1_xyzw_3.w;
                o.texcoord5.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord5.xy = ((r1_z_3.xxxx + float4(r1_x_3, r1_w_4, r1_x_3, r1_x_3))).xy;
                return o;
            }
            #pragma fragment frag
            program25Output frag(program25Input i)
            {
                program25Output o = (program25Output)0;
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
                float3 r4_xyz_1 = (mad(viewDir_xyz_1.xyzx, r2_w_2.xxxx, float4(lightDir_x_3, lightDir_y_1, lightDir_z_1, lightDir_x_3))).xyz;
                float3 halfVector_xyz_2 = normalize(r4_xyz_1);
                float r2_y_2 = saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), halfVector_xyz_2.xyzx));
                float r2_y_3 = log2(r2_y_2);
                float r2_y_4 = (r2_y_3 * 64);
                float r2_y_5 = exp2(r2_y_4);
                float r2_y_6 = (r2_y_5 * _SpecColor.x);
                float r4_x_3 = cb4_values[9].z;
                float r4_y_3 = cb4_values[10].z;
                float r4_z_3 = cb4_values[11].z;
                float r2_z_2 = dot(viewDir_xyz_1.xyzx, float4(r4_x_3, r4_y_3, r4_z_3, r4_x_3));
                float3 r3_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_5 = dot(r3_xyz_2.xyzx, r3_xyz_2.xyzx);
                float r2_w_6 = sqrt(r2_w_5);
                float r2_w_7 = (-r2_z_2 + r2_w_6);
                float r2_z_3 = mad(cb3_values[25].w, r2_w_7, r2_z_2);
                float r2_z_4 = saturate(mad(r2_z_3, cb3_values[24].z, cb3_values[24].w));
                float r2_w_8 = (cb5_values[0].x == 1);
                float r3_x_12;
                float r3_y_13;
                float r3_z_12;
                float r3_w_4;
                if (r2_w_8)
                {
                    float r2_w_9 = (cb5_values[0].y == 1);
                    float3 r3_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r3_xyzw_10 = (((((r2_w_9.xxxx ? r3_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r3_y_10 = r3_xyzw_10.y;
                    float r3_z_10 = r3_xyzw_10.z;
                    float r3_w_2 = r3_xyzw_10.w;
                    float r2_w_10 = mad(r3_y_10, 0.25, 0.75);
                    float r3_y_11 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r3_x_10 = max(r2_w_10, r3_y_11);
                    float4 r3_xyzw_11 = t2.Sample(sampler_linear_clamp, (float4(r3_x_10, r3_z_10, r3_w_2, r3_x_10)).xyz);
                    r3_x_12 = r3_xyzw_11.x;
                    r3_y_13 = r3_xyzw_11.y;
                    r3_z_12 = r3_xyzw_11.z;
                    r3_w_4 = r3_xyzw_11.w;
                }
                else
                {
                    float4 r3_xyzw_3 = float4(1, 1, 1, 1);
                    r3_x_12 = r3_xyzw_3.x;
                    r3_y_13 = r3_xyzw_3.y;
                    r3_z_12 = r3_xyzw_3.z;
                    r3_w_4 = r3_xyzw_3.w;
                }
                float r2_w_12 = saturate(dot(float4(r3_x_12, r3_y_13, r3_z_12, r3_w_4), unity_OcclusionMaskSelector));
                float4 r3_xyzw_13 = (i.texcoord5.xyxx / i.texcoord5.wwww);
                float r3_x_13 = r3_xyzw_13.x;
                float r3_y_14 = r3_xyzw_13.y;
                float4 r3_xyzw_14 = t1.Sample(sampler_linear_clamp1, (float4(r3_x_13, r3_y_14, r3_x_13, r3_x_13)).xy);
                float r2_w_13 = (r2_w_12 + -r3_xyzw_14.x);
                float r2_z_5 = mad(r2_z_4, r2_w_13, r3_xyzw_14.x);
                float r1_w_1 = 1;
                float r3_x_15 = dot(unity_SHAr, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r3_y_16 = dot(unity_SHAg, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r3_z_14 = dot(unity_SHAb, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float4 r4_xyzw_4 = (float4(unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1, unitWorldNormal_x_3) * float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1));
                float r5_x_1 = dot(unity_SHBr, r4_xyzw_4);
                float r5_y_1 = dot(unity_SHBg, r4_xyzw_4);
                float r5_z_1 = dot(unity_SHBb, r4_xyzw_4);
                float r1_w_2 = (unitWorldNormal_y_1 * unitWorldNormal_y_1);
                float r1_w_3 = mad(unitWorldNormal_x_3, unitWorldNormal_x_3, -r1_w_2);
                float4 r3_xyzw_16 = (float4(r3_x_15, r3_y_16, r3_z_14, r3_x_15) + (mad(unity_SHC.xyzx, r1_w_3.xxxx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1))).xyzx);
                float r3_x_16 = r3_xyzw_16.x;
                float r3_y_17 = r3_xyzw_16.y;
                float r3_z_15 = r3_xyzw_16.z;
                float4 r4_xyzw_6 = (-i.texcoord2.xxxx + unity_4LightPosX0);
                float4 r5_xyzw_2 = (-i.texcoord2.yyyy + unity_4LightPosY0);
                float4 r6_xyzw_1 = (-i.texcoord2.zzzz + unity_4LightPosZ0);
                float4 r7_xyzw_4 = max(mad(r6_xyzw_1, r6_xyzw_1, mad(r4_xyzw_6, r4_xyzw_6, (r5_xyzw_2 * r5_xyzw_2))), float4(1E-06, 1E-06, 1E-06, 1E-06));
                float4 r5_xyzw_3 = (unitWorldNormal_y_1.xxxx * r5_xyzw_2);
                float4 r4_xyzw_7 = mad(r4_xyzw_6, unitWorldNormal_x_3.xxxx, r5_xyzw_3);
                float4 r1_xyzw_4 = mad(r6_xyzw_1, unitWorldNormal_z_1.xxxx, r4_xyzw_7);
                float4 r4_xyzw_8 = rsqrt(r7_xyzw_4);
                float4 r1_xyzw_5 = (r1_xyzw_4 * r4_xyzw_8);
                float4 r1_xyzw_6 = max(r1_xyzw_5, float4(0, 0, 0, 0));
                float4 r4_xyzw_9 = mad(r7_xyzw_4, unity_4LightAtten0, float4(1, 1, 1, 1));
                float4 r4_xyzw_10 = (float4(1, 1, 1, 1) / r4_xyzw_9);
                float4 r1_xyzw_7 = (r1_xyzw_6 * r4_xyzw_10);
                float4 r1_xyzw_8 = mad(cb2_values[9].xyzx, r1_xyzw_7.zzzz, (mad(cb2_values[7].xyzx, r1_xyzw_7.xxxx, ((r1_xyzw_7.yyyy * cb2_values[8].xyzx)).xyzx)).xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_z_6 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = mad(cb2_values[10].xyzx, r1_xyzw_7.wwww, float4(r1_x_8, r1_y_6, r1_z_6, r1_x_8));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_7 = r1_xyzw_9.y;
                float r1_z_7 = r1_xyzw_9.z;
                float4 r1_xyzw_10 = (float4(r1_x_9, r1_y_7, r1_z_7, r1_x_9) + float4(r3_x_16, r3_y_17, r3_z_15, r3_x_16));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_8 = r1_xyzw_10.y;
                float r1_z_8 = r1_xyzw_10.z;
                float4 r3_xyzw_17 = ((saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), float4(lightDir_x_3, lightDir_y_1, lightDir_z_1, lightDir_x_3)))).xxxx * _LightColor0.xyzx);
                float r3_x_17 = r3_xyzw_17.x;
                float r3_y_18 = r3_xyzw_17.y;
                float r3_z_16 = r3_xyzw_17.z;
                float4 r1_xyzw_11 = mad(float4(r3_x_17, r3_y_18, r3_z_16, r3_x_17), r2_z_5.xxxx, float4(r1_x_10, r1_y_8, r1_z_8, r1_x_10));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_9 = r1_xyzw_11.y;
                float r1_z_9 = r1_xyzw_11.z;
                float4 r2_xyzw_5 = (r2_y_6.xxxx * _LightColor0.xyxz);
                float r2_x_5 = r2_xyzw_5.x;
                float r2_y_7 = r2_xyzw_5.y;
                float r2_w_14 = r2_xyzw_5.w;
                float4 r2_xyzw_6 = (r2_z_5.xxxx * float4(r2_x_5, r2_y_7, r2_w_14, r2_x_5));
                float r2_x_6 = r2_xyzw_6.x;
                float r2_y_8 = r2_xyzw_6.y;
                float r2_z_6 = r2_xyzw_6.z;
                o.sv_Target0.xyz = (((mad(r0_xyzw_2.xyzx, float4(r1_x_11, r1_y_9, r1_z_9, r1_x_11), float4(r2_x_6, r2_y_8, r2_z_6, r2_x_6))).xyzx + _Emission.xyzx)).xyz;
                o.sv_Target0.w = r0_xyzw_2.w;
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
            cbuffer cb3 : register(b3)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb3_values[21];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture3D t1;
            struct program4Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program4Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program23Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program23Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program4Output vert(program4Input i)
            {
                program4Output o = (program4Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r1_xyzw_3 = (float4(clipPos_xyzw_7.x, clipPos_xyzw_7.x, clipPos_xyzw_7.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_z_3 = r1_xyzw_3.z;
                float r1_w_4 = r1_xyzw_3.w;
                o.texcoord5.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord5.xy = ((r1_z_3.xxxx + float4(r1_x_3, r1_w_4, r1_x_3, r1_x_3))).xy;
                return o;
            }
            #pragma fragment frag
            program23Output frag(program23Input i)
            {
                program23Output o = (program23Output)0;
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
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
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
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            Texture3D t2;
            struct program3Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program3Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program24Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program24Output
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
            program24Output frag(program24Input i)
            {
                program24Output o = (program24Output)0;
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
                float3 r4_xyz_1 = (mad(viewDir_xyz_1.xyzx, r2_w_2.xxxx, float4(lightDir_x_3, lightDir_y_1, lightDir_z_1, lightDir_x_3))).xyz;
                float3 halfVector_xyz_2 = normalize(r4_xyz_1);
                float r2_y_2 = saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), halfVector_xyz_2.xyzx));
                float r2_y_3 = log2(r2_y_2);
                float r2_y_4 = (r2_y_3 * 64);
                float r2_y_5 = exp2(r2_y_4);
                float r2_y_6 = (r2_y_5 * _SpecColor.x);
                float r4_x_3 = cb4_values[9].z;
                float r4_y_3 = cb4_values[10].z;
                float r4_z_3 = cb4_values[11].z;
                float r2_z_2 = dot(viewDir_xyz_1.xyzx, float4(r4_x_3, r4_y_3, r4_z_3, r4_x_3));
                float3 r3_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_5 = dot(r3_xyz_2.xyzx, r3_xyz_2.xyzx);
                float r2_w_6 = sqrt(r2_w_5);
                float r2_w_7 = (-r2_z_2 + r2_w_6);
                float r2_z_3 = mad(cb3_values[25].w, r2_w_7, r2_z_2);
                float r2_z_4 = saturate(mad(r2_z_3, cb3_values[24].z, cb3_values[24].w));
                float r2_w_8 = (cb5_values[0].x == 1);
                float r3_x_12;
                float r3_y_13;
                float r3_z_12;
                float r3_w_4;
                if (r2_w_8)
                {
                    float r2_w_9 = (cb5_values[0].y == 1);
                    float3 r3_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r3_xyzw_10 = (((((r2_w_9.xxxx ? r3_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r3_y_10 = r3_xyzw_10.y;
                    float r3_z_10 = r3_xyzw_10.z;
                    float r3_w_2 = r3_xyzw_10.w;
                    float r2_w_10 = mad(r3_y_10, 0.25, 0.75);
                    float r3_y_11 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r3_x_10 = max(r2_w_10, r3_y_11);
                    float4 r3_xyzw_11 = t2.Sample(sampler_linear_clamp, (float4(r3_x_10, r3_z_10, r3_w_2, r3_x_10)).xyz);
                    r3_x_12 = r3_xyzw_11.x;
                    r3_y_13 = r3_xyzw_11.y;
                    r3_z_12 = r3_xyzw_11.z;
                    r3_w_4 = r3_xyzw_11.w;
                }
                else
                {
                    float4 r3_xyzw_3 = float4(1, 1, 1, 1);
                    r3_x_12 = r3_xyzw_3.x;
                    r3_y_13 = r3_xyzw_3.y;
                    r3_z_12 = r3_xyzw_3.z;
                    r3_w_4 = r3_xyzw_3.w;
                }
                float r2_w_12 = saturate(dot(float4(r3_x_12, r3_y_13, r3_z_12, r3_w_4), unity_OcclusionMaskSelector));
                float4 r3_xyzw_13 = (i.texcoord5.xyxx / i.texcoord5.wwww);
                float r3_x_13 = r3_xyzw_13.x;
                float r3_y_14 = r3_xyzw_13.y;
                float4 r3_xyzw_14 = t1.Sample(sampler_linear_clamp1, (float4(r3_x_13, r3_y_14, r3_x_13, r3_x_13)).xy);
                float r2_w_13 = (r2_w_12 + -r3_xyzw_14.x);
                float r2_z_5 = mad(r2_z_4, r2_w_13, r3_xyzw_14.x);
                float r1_w_1 = 1;
                float r3_x_15 = dot(unity_SHAr, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r3_y_16 = dot(unity_SHAg, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r3_z_14 = dot(unity_SHAb, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float4 r4_xyzw_4 = (float4(unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1, unitWorldNormal_x_3) * float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1));
                float r5_x_1 = dot(unity_SHBr, r4_xyzw_4);
                float r5_y_1 = dot(unity_SHBg, r4_xyzw_4);
                float r5_z_1 = dot(unity_SHBb, r4_xyzw_4);
                float r1_w_2 = (unitWorldNormal_y_1 * unitWorldNormal_y_1);
                float r1_w_3 = mad(unitWorldNormal_x_3, unitWorldNormal_x_3, -r1_w_2);
                float4 r3_xyzw_16 = (float4(r3_x_15, r3_y_16, r3_z_14, r3_x_15) + (mad(unity_SHC.xyzx, r1_w_3.xxxx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1))).xyzx);
                float r3_x_16 = r3_xyzw_16.x;
                float r3_y_17 = r3_xyzw_16.y;
                float r3_z_15 = r3_xyzw_16.z;
                float4 r4_xyzw_6 = (-i.texcoord2.xxxx + unity_4LightPosX0);
                float4 r5_xyzw_2 = (-i.texcoord2.yyyy + unity_4LightPosY0);
                float4 r6_xyzw_1 = (-i.texcoord2.zzzz + unity_4LightPosZ0);
                float4 r7_xyzw_4 = max(mad(r6_xyzw_1, r6_xyzw_1, mad(r4_xyzw_6, r4_xyzw_6, (r5_xyzw_2 * r5_xyzw_2))), float4(1E-06, 1E-06, 1E-06, 1E-06));
                float4 r5_xyzw_3 = (unitWorldNormal_y_1.xxxx * r5_xyzw_2);
                float4 r4_xyzw_7 = mad(r4_xyzw_6, unitWorldNormal_x_3.xxxx, r5_xyzw_3);
                float4 r1_xyzw_4 = mad(r6_xyzw_1, unitWorldNormal_z_1.xxxx, r4_xyzw_7);
                float4 r4_xyzw_8 = rsqrt(r7_xyzw_4);
                float4 r1_xyzw_5 = (r1_xyzw_4 * r4_xyzw_8);
                float4 r1_xyzw_6 = max(r1_xyzw_5, float4(0, 0, 0, 0));
                float4 r4_xyzw_9 = mad(r7_xyzw_4, unity_4LightAtten0, float4(1, 1, 1, 1));
                float4 r4_xyzw_10 = (float4(1, 1, 1, 1) / r4_xyzw_9);
                float4 r1_xyzw_7 = (r1_xyzw_6 * r4_xyzw_10);
                float4 r1_xyzw_8 = mad(cb2_values[9].xyzx, r1_xyzw_7.zzzz, (mad(cb2_values[7].xyzx, r1_xyzw_7.xxxx, ((r1_xyzw_7.yyyy * cb2_values[8].xyzx)).xyzx)).xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_z_6 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = mad(cb2_values[10].xyzx, r1_xyzw_7.wwww, float4(r1_x_8, r1_y_6, r1_z_6, r1_x_8));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_7 = r1_xyzw_9.y;
                float r1_z_7 = r1_xyzw_9.z;
                float4 r1_xyzw_10 = (float4(r1_x_9, r1_y_7, r1_z_7, r1_x_9) + float4(r3_x_16, r3_y_17, r3_z_15, r3_x_16));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_8 = r1_xyzw_10.y;
                float r1_z_8 = r1_xyzw_10.z;
                float4 r3_xyzw_17 = ((saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), float4(lightDir_x_3, lightDir_y_1, lightDir_z_1, lightDir_x_3)))).xxxx * _LightColor0.xyzx);
                float r3_x_17 = r3_xyzw_17.x;
                float r3_y_18 = r3_xyzw_17.y;
                float r3_z_16 = r3_xyzw_17.z;
                float4 r1_xyzw_11 = mad(float4(r3_x_17, r3_y_18, r3_z_16, r3_x_17), r2_z_5.xxxx, float4(r1_x_10, r1_y_8, r1_z_8, r1_x_10));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_9 = r1_xyzw_11.y;
                float r1_z_9 = r1_xyzw_11.z;
                float4 r2_xyzw_5 = (r2_y_6.xxxx * _LightColor0.xyxz);
                float r2_x_5 = r2_xyzw_5.x;
                float r2_y_7 = r2_xyzw_5.y;
                float r2_w_14 = r2_xyzw_5.w;
                float4 r2_xyzw_6 = (r2_z_5.xxxx * float4(r2_x_5, r2_y_7, r2_w_14, r2_x_5));
                float r2_x_6 = r2_xyzw_6.x;
                float r2_y_8 = r2_xyzw_6.y;
                float r2_z_6 = r2_xyzw_6.z;
                o.sv_Target0.xyz = (((mad(r0_xyzw_2.xyzx, float4(r1_x_11, r1_y_9, r1_z_9, r1_x_11), float4(r2_x_6, r2_y_8, r2_z_6, r2_x_6))).xyzx + _Emission.xyzx)).xyz;
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
                float4 _MainTex_ST;
                float4 _Color;
                float4 _Emission;
                float4 cb0_values[10];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[7];
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
            SamplerComparisonState sampler_comparison_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_linear_clamp3;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            TextureCube t2;
            Texture3D t3;
            TextureCube t4;
            struct program60Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program60Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program106Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program106Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program60Output vert(program60Input i)
            {
                program60Output o = (program60Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[8].xyxx, cb0_values[8].zwzz)).xy;
                float worldNormal_x_3 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                float3 r1_xyz_4 = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = r1_xyz_4.xyz;
                o.texcoord5.xyz = ((r1_xyz_4.xyzx + -unity_ObjectToWorld[1].xyzx)).xyz;
                o.texcoord4.xyz = (mad(cb0_values[7].xyzx, r0_xyzw_4.wwww, (mad(_Emission.xyzx, r0_xyzw_4.zzzz, (mad(_MainTex_ST.xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * _Color.xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program106Output frag(program106Input i)
            {
                program106Output o = (program106Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float3 r2_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r2_xyz_2 = normalize(r2_xyz_1);
                float3 r3_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_6 = dot(r3_xyz_1.xyzx, r3_xyz_1.xyzx);
                float r0_w_7 = rsqrt(r0_w_6);
                float3 r4_xyz_1 = (mad(r3_xyz_1.xyzx, r0_w_7.xxxx, r2_xyz_2.xyzx)).xyz;
                float r0_w_8 = dot(r4_xyz_1.xyzx, r4_xyz_1.xyzx);
                float r0_w_9 = rsqrt(r0_w_8);
                float3 r5_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r0_w_10 = dot(r3_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float3 r3_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_1 = dot(r3_xyz_2.xyzx, r3_xyz_2.xyzx);
                float r1_w_2 = sqrt(r1_w_1);
                float r1_w_3 = (-r0_w_10 + r1_w_2);
                float r0_w_11 = mad(cb3_values[25].w, r1_w_3, r0_w_10);
                float r0_w_12 = saturate(mad(r0_w_11, cb3_values[24].z, cb3_values[24].w));
                float r1_w_4 = (cb6_values[0].x == 1);
                float r3_x_12;
                float r3_y_12;
                float r3_z_12;
                float r3_w_4;
                if (r1_w_4)
                {
                    float r1_w_5 = (cb6_values[0].y == 1);
                    float3 r3_xyz_7 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r3_xyzw_10 = (((((r1_w_5.xxxx ? r3_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r3_y_10 = r3_xyzw_10.y;
                    float r3_z_10 = r3_xyzw_10.z;
                    float r3_w_2 = r3_xyzw_10.w;
                    float r1_w_6 = mad(r3_y_10, 0.25, 0.75);
                    float r2_w_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r3_x_10 = max(r1_w_6, r2_w_1);
                    float4 r3_xyzw_11 = t3.Sample(sampler_linear_clamp, (float4(r3_x_10, r3_z_10, r3_w_2, r3_x_10)).xyz);
                    r3_x_12 = r3_xyzw_11.x;
                    r3_y_12 = r3_xyzw_11.y;
                    r3_z_12 = r3_xyzw_11.z;
                    r3_w_4 = r3_xyzw_11.w;
                }
                else
                {
                    float4 r3_xyzw_3 = float4(1, 1, 1, 1);
                    r3_x_12 = r3_xyzw_3.x;
                    r3_y_12 = r3_xyzw_3.y;
                    r3_z_12 = r3_xyzw_3.z;
                    r3_w_4 = r3_xyzw_3.w;
                }
                float r1_w_8 = saturate(dot(float4(r3_x_12, r3_y_12, r3_z_12, r3_w_4), unity_OcclusionMaskSelector));
                float r2_w_3 = (r0_w_12 < 0.99);
                float r2_w_15;
                if (r2_w_3)
                {
                    float3 r3_xyz_13 = ((i.texcoord2.xyzx + -cb2_values[1].xyzx)).xyz;
                    float r2_w_5 = max(abs(r3_xyz_13.y), abs(r3_xyz_13.x));
                    float r2_w_6 = max(abs(r3_xyz_13.z), r2_w_5);
                    float r2_w_7 = (r2_w_6 + -cb2_values[2].z);
                    float r2_w_8 = max(r2_w_7, 1E-05);
                    float r2_w_9 = (r2_w_8 * cb2_values[2].w);
                    float r2_w_10 = (cb2_values[2].y / r2_w_9);
                    float r2_w_11 = (r2_w_10 + -cb2_values[2].x);
                    float r2_w_12 = (-r2_w_11 + 1);
                    float r6_x_3 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r3_xyz_13.xyzx + float4(0.0078125, 0.0078125, 0.0078125, 0))).xyzx).xyz, r2_w_12);
                    float r6_y_3 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r3_xyz_13.xyzx + float4(-0.0078125, -0.0078125, 0.0078125, 0))).xyzx).xyz, r2_w_12);
                    float r6_z_3 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r3_xyz_13.xyzx + float4(-0.0078125, 0.0078125, -0.0078125, 0))).xyzx).xyz, r2_w_12);
                    float r6_w_1 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r3_xyz_13.xyzx + float4(0.0078125, -0.0078125, -0.0078125, 0))).xyzx).xyz, r2_w_12);
                    float r2_w_13 = dot(float4(r6_x_3, r6_y_3, r6_z_3, r6_w_1), float4(0.25, 0.25, 0.25, 0.25));
                    float r2_w_14 = mad(r2_w_13, (-cb3_values[24].x + 1), cb3_values[24].x);
                    r2_w_15 = r2_w_14;
                }
                else
                {
                    float r2_w_4 = 1;
                    r2_w_15 = r2_w_4;
                }
                float r1_w_9 = (r1_w_8 + -r2_w_15);
                float r0_w_13 = mad(r0_w_12, r1_w_9, r2_w_15);
                float r1_w_10 = dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx);
                float4 r3_xyzw_17 = t1.Sample(sampler_linear_clamp3, (r1_w_10.xxxx).xy);
                float4 r5_xyzw_5 = t2.Sample(sampler_linear_clamp2, r5_xyz_4.xyz);
                float r1_w_11 = (r3_xyzw_17.x * r5_xyzw_5.w);
                float r0_w_14 = (r0_w_13 * r1_w_11);
                float r1_w_12 = saturate(dot(unitWorldNormal_xyz_1.xyzx, r2_xyz_2.xyzx));
                                float r1_x_6 = (pow(saturate(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_9.xxxx * r4_xyz_1.xyzx)).xyzx)), 64) * _SpecColor.x);
                float r0_w_15 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((((r0_w_14.xxxx * (((mad(((r0_xyzw_1.xyzx * cb0_values[9].xyzx)).xyzx, r1_w_12.xxxx, r1_x_6.xxxx)).xyzx * _LightColor0.xyzx)).xyzx)).xyzx * r0_w_19.xxxx)).xyz;
                o.sv_Target0.w = 0;
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
                float4 _MainTex_ST;
                float4 _Color;
                float4 _Emission;
                float4 cb0_values[10];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[7];
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
            SamplerComparisonState sampler_comparison_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_linear_clamp3;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            TextureCube t2;
            Texture3D t3;
            TextureCube t4;
            struct program59Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program59Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program105Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program105Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program59Output vert(program59Input i)
            {
                program59Output o = (program59Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[8].xyxx, cb0_values[8].zwzz)).xy;
                float worldNormal_x_3 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                float3 r1_xyz_4 = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = r1_xyz_4.xyz;
                o.texcoord5.xyz = ((r1_xyz_4.xyzx + -unity_ObjectToWorld[1].xyzx)).xyz;
                o.texcoord4.xyz = (mad(cb0_values[7].xyzx, r0_xyzw_4.wwww, (mad(_Emission.xyzx, r0_xyzw_4.zzzz, (mad(_MainTex_ST.xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * _Color.xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program105Output frag(program105Input i)
            {
                program105Output o = (program105Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float3 r2_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r2_xyz_2 = normalize(r2_xyz_1);
                float3 r3_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_6 = dot(r3_xyz_1.xyzx, r3_xyz_1.xyzx);
                float r0_w_7 = rsqrt(r0_w_6);
                float3 r4_xyz_1 = (mad(r3_xyz_1.xyzx, r0_w_7.xxxx, r2_xyz_2.xyzx)).xyz;
                float r0_w_8 = dot(r4_xyz_1.xyzx, r4_xyz_1.xyzx);
                float r0_w_9 = rsqrt(r0_w_8);
                float3 r5_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r0_w_10 = dot(r3_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float3 r3_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_1 = dot(r3_xyz_2.xyzx, r3_xyz_2.xyzx);
                float r1_w_2 = sqrt(r1_w_1);
                float r1_w_3 = (-r0_w_10 + r1_w_2);
                float r0_w_11 = mad(cb3_values[25].w, r1_w_3, r0_w_10);
                float r0_w_12 = saturate(mad(r0_w_11, cb3_values[24].z, cb3_values[24].w));
                float r1_w_4 = (cb6_values[0].x == 1);
                float r3_x_12;
                float r3_y_12;
                float r3_z_12;
                float r3_w_4;
                if (r1_w_4)
                {
                    float r1_w_5 = (cb6_values[0].y == 1);
                    float3 r3_xyz_7 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r3_xyzw_10 = (((((r1_w_5.xxxx ? r3_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r3_y_10 = r3_xyzw_10.y;
                    float r3_z_10 = r3_xyzw_10.z;
                    float r3_w_2 = r3_xyzw_10.w;
                    float r1_w_6 = mad(r3_y_10, 0.25, 0.75);
                    float r2_w_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r3_x_10 = max(r1_w_6, r2_w_1);
                    float4 r3_xyzw_11 = t3.Sample(sampler_linear_clamp, (float4(r3_x_10, r3_z_10, r3_w_2, r3_x_10)).xyz);
                    r3_x_12 = r3_xyzw_11.x;
                    r3_y_12 = r3_xyzw_11.y;
                    r3_z_12 = r3_xyzw_11.z;
                    r3_w_4 = r3_xyzw_11.w;
                }
                else
                {
                    float4 r3_xyzw_3 = float4(1, 1, 1, 1);
                    r3_x_12 = r3_xyzw_3.x;
                    r3_y_12 = r3_xyzw_3.y;
                    r3_z_12 = r3_xyzw_3.z;
                    r3_w_4 = r3_xyzw_3.w;
                }
                float r1_w_8 = saturate(dot(float4(r3_x_12, r3_y_12, r3_z_12, r3_w_4), unity_OcclusionMaskSelector));
                float3 r3_xyz_13 = ((i.texcoord2.xyzx + -cb2_values[1].xyzx)).xyz;
                float r2_w_3 = max(abs(r3_xyz_13.y), abs(r3_xyz_13.x));
                float r2_w_4 = max(abs(r3_xyz_13.z), r2_w_3);
                float r2_w_5 = (r2_w_4 + -cb2_values[2].z);
                float r2_w_6 = max(r2_w_5, 1E-05);
                float r2_w_7 = (r2_w_6 * cb2_values[2].w);
                float r2_w_8 = (cb2_values[2].y / r2_w_7);
                float r2_w_9 = (r2_w_8 + -cb2_values[2].x);
                float r2_w_10 = (-r2_w_9 + 1);
                float r2_w_11 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, r3_xyz_13.xyz, r2_w_10);
                float r2_w_12 = mad(r2_w_11, (-cb3_values[24].x + 1), cb3_values[24].x);
                float r1_w_9 = (r1_w_8 + -r2_w_12);
                float r0_w_13 = mad(r0_w_12, r1_w_9, r2_w_12);
                float r1_w_10 = dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx);
                float4 r3_xyzw_15 = t1.Sample(sampler_linear_clamp3, (r1_w_10.xxxx).xy);
                float4 r5_xyzw_5 = t2.Sample(sampler_linear_clamp2, r5_xyz_4.xyz);
                float r1_w_11 = (r3_xyzw_15.x * r5_xyzw_5.w);
                float r0_w_14 = (r0_w_13 * r1_w_11);
                float r1_w_12 = saturate(dot(unitWorldNormal_xyz_1.xyzx, r2_xyz_2.xyzx));
                                float r1_x_6 = (pow(saturate(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_9.xxxx * r4_xyz_1.xyzx)).xyzx)), 64) * _SpecColor.x);
                float r0_w_15 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((((r0_w_14.xxxx * (((mad(((r0_xyzw_1.xyzx * cb0_values[9].xyzx)).xyzx, r1_w_12.xxxx, r1_x_6.xxxx)).xyzx * _LightColor0.xyzx)).xyzx)).xyzx * r0_w_19.xxxx)).xyz;
                o.sv_Target0.w = 0;
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
                float4 _MainTex_ST;
                float4 _Color;
                float4 _Emission;
                float4 cb0_values[10];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[7];
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
            SamplerComparisonState sampler_comparison_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            Texture3D t2;
            TextureCube t3;
            struct program58Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program58Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program104Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program104Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program58Output vert(program58Input i)
            {
                program58Output o = (program58Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[8].xyxx, cb0_values[8].zwzz)).xy;
                float worldNormal_x_3 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                float3 r1_xyz_4 = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = r1_xyz_4.xyz;
                o.texcoord5.xyz = ((r1_xyz_4.xyzx + -unity_ObjectToWorld[1].xyzx)).xyz;
                o.texcoord4.xyz = (mad(cb0_values[7].xyzx, r0_xyzw_4.wwww, (mad(_Emission.xyzx, r0_xyzw_4.zzzz, (mad(_MainTex_ST.xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * _Color.xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program104Output frag(program104Input i)
            {
                program104Output o = (program104Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float3 r2_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r2_xyz_2 = normalize(r2_xyz_1);
                float3 r3_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_6 = dot(r3_xyz_1.xyzx, r3_xyz_1.xyzx);
                float r0_w_7 = rsqrt(r0_w_6);
                float3 r4_xyz_1 = (mad(r3_xyz_1.xyzx, r0_w_7.xxxx, r2_xyz_2.xyzx)).xyz;
                float r0_w_8 = dot(r4_xyz_1.xyzx, r4_xyz_1.xyzx);
                float r0_w_9 = rsqrt(r0_w_8);
                float3 r5_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r0_w_10 = dot(r3_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float3 r3_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_1 = dot(r3_xyz_2.xyzx, r3_xyz_2.xyzx);
                float r1_w_2 = sqrt(r1_w_1);
                float r1_w_3 = (-r0_w_10 + r1_w_2);
                float r0_w_11 = mad(cb3_values[25].w, r1_w_3, r0_w_10);
                float r0_w_12 = saturate(mad(r0_w_11, cb3_values[24].z, cb3_values[24].w));
                float r1_w_4 = (cb6_values[0].x == 1);
                float r3_x_12;
                float r3_y_12;
                float r3_z_12;
                float r3_w_4;
                if (r1_w_4)
                {
                    float r1_w_5 = (cb6_values[0].y == 1);
                    float3 r3_xyz_7 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r3_xyzw_10 = (((((r1_w_5.xxxx ? r3_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r3_y_10 = r3_xyzw_10.y;
                    float r3_z_10 = r3_xyzw_10.z;
                    float r3_w_2 = r3_xyzw_10.w;
                    float r1_w_6 = mad(r3_y_10, 0.25, 0.75);
                    float r2_w_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r3_x_10 = max(r1_w_6, r2_w_1);
                    float4 r3_xyzw_11 = t2.Sample(sampler_linear_clamp, (float4(r3_x_10, r3_z_10, r3_w_2, r3_x_10)).xyz);
                    r3_x_12 = r3_xyzw_11.x;
                    r3_y_12 = r3_xyzw_11.y;
                    r3_z_12 = r3_xyzw_11.z;
                    r3_w_4 = r3_xyzw_11.w;
                }
                else
                {
                    float4 r3_xyzw_3 = float4(1, 1, 1, 1);
                    r3_x_12 = r3_xyzw_3.x;
                    r3_y_12 = r3_xyzw_3.y;
                    r3_z_12 = r3_xyzw_3.z;
                    r3_w_4 = r3_xyzw_3.w;
                }
                float r1_w_8 = saturate(dot(float4(r3_x_12, r3_y_12, r3_z_12, r3_w_4), unity_OcclusionMaskSelector));
                float r2_w_3 = (r0_w_12 < 0.99);
                float r2_w_15;
                if (r2_w_3)
                {
                    float3 r3_xyz_13 = ((i.texcoord2.xyzx + -cb2_values[1].xyzx)).xyz;
                    float r2_w_5 = max(abs(r3_xyz_13.y), abs(r3_xyz_13.x));
                    float r2_w_6 = max(abs(r3_xyz_13.z), r2_w_5);
                    float r2_w_7 = (r2_w_6 + -cb2_values[2].z);
                    float r2_w_8 = max(r2_w_7, 1E-05);
                    float r2_w_9 = (r2_w_8 * cb2_values[2].w);
                    float r2_w_10 = (cb2_values[2].y / r2_w_9);
                    float r2_w_11 = (r2_w_10 + -cb2_values[2].x);
                    float r2_w_12 = (-r2_w_11 + 1);
                    float r6_x_3 = t3.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r3_xyz_13.xyzx + float4(0.0078125, 0.0078125, 0.0078125, 0))).xyzx).xyz, r2_w_12);
                    float r6_y_3 = t3.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r3_xyz_13.xyzx + float4(-0.0078125, -0.0078125, 0.0078125, 0))).xyzx).xyz, r2_w_12);
                    float r6_z_3 = t3.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r3_xyz_13.xyzx + float4(-0.0078125, 0.0078125, -0.0078125, 0))).xyzx).xyz, r2_w_12);
                    float r6_w_1 = t3.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r3_xyz_13.xyzx + float4(0.0078125, -0.0078125, -0.0078125, 0))).xyzx).xyz, r2_w_12);
                    float r2_w_13 = dot(float4(r6_x_3, r6_y_3, r6_z_3, r6_w_1), float4(0.25, 0.25, 0.25, 0.25));
                    float r2_w_14 = mad(r2_w_13, (-cb3_values[24].x + 1), cb3_values[24].x);
                    r2_w_15 = r2_w_14;
                }
                else
                {
                    float r2_w_4 = 1;
                    r2_w_15 = r2_w_4;
                }
                float r1_w_9 = (r1_w_8 + -r2_w_15);
                float r0_w_13 = mad(r0_w_12, r1_w_9, r2_w_15);
                float r1_w_10 = dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx);
                float4 r3_xyzw_17 = t1.Sample(sampler_linear_clamp2, (r1_w_10.xxxx).xy);
                float r0_w_14 = (r0_w_13 * r3_xyzw_17.x);
                float r1_w_11 = saturate(dot(unitWorldNormal_xyz_1.xyzx, r2_xyz_2.xyzx));
                                float r1_x_6 = (pow(saturate(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_9.xxxx * r4_xyz_1.xyzx)).xyzx)), 64) * _SpecColor.x);
                float r0_w_15 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((((r0_w_14.xxxx * (((mad(((r0_xyzw_1.xyzx * cb0_values[9].xyzx)).xyzx, r1_w_11.xxxx, r1_x_6.xxxx)).xyzx * _LightColor0.xyzx)).xyzx)).xyzx * r0_w_19.xxxx)).xyz;
                o.sv_Target0.w = 0;
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
                float4 _MainTex_ST;
                float4 _Color;
                float4 _Emission;
                float4 cb0_values[10];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[7];
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
            SamplerComparisonState sampler_comparison_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            Texture3D t2;
            TextureCube t3;
            struct program57Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program57Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program103Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program103Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program57Output vert(program57Input i)
            {
                program57Output o = (program57Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[8].xyxx, cb0_values[8].zwzz)).xy;
                float worldNormal_x_3 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                float3 r1_xyz_4 = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = r1_xyz_4.xyz;
                o.texcoord5.xyz = ((r1_xyz_4.xyzx + -unity_ObjectToWorld[1].xyzx)).xyz;
                o.texcoord4.xyz = (mad(cb0_values[7].xyzx, r0_xyzw_4.wwww, (mad(_Emission.xyzx, r0_xyzw_4.zzzz, (mad(_MainTex_ST.xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * _Color.xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program103Output frag(program103Input i)
            {
                program103Output o = (program103Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float3 r2_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r2_xyz_2 = normalize(r2_xyz_1);
                float3 r3_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_6 = dot(r3_xyz_1.xyzx, r3_xyz_1.xyzx);
                float r0_w_7 = rsqrt(r0_w_6);
                float3 r4_xyz_1 = (mad(r3_xyz_1.xyzx, r0_w_7.xxxx, r2_xyz_2.xyzx)).xyz;
                float r0_w_8 = dot(r4_xyz_1.xyzx, r4_xyz_1.xyzx);
                float r0_w_9 = rsqrt(r0_w_8);
                float3 r5_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r0_w_10 = dot(r3_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float3 r3_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_1 = dot(r3_xyz_2.xyzx, r3_xyz_2.xyzx);
                float r1_w_2 = sqrt(r1_w_1);
                float r1_w_3 = (-r0_w_10 + r1_w_2);
                float r0_w_11 = mad(cb3_values[25].w, r1_w_3, r0_w_10);
                float r0_w_12 = saturate(mad(r0_w_11, cb3_values[24].z, cb3_values[24].w));
                float r1_w_4 = (cb6_values[0].x == 1);
                float r3_x_12;
                float r3_y_12;
                float r3_z_12;
                float r3_w_4;
                if (r1_w_4)
                {
                    float r1_w_5 = (cb6_values[0].y == 1);
                    float3 r3_xyz_7 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r3_xyzw_10 = (((((r1_w_5.xxxx ? r3_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r3_y_10 = r3_xyzw_10.y;
                    float r3_z_10 = r3_xyzw_10.z;
                    float r3_w_2 = r3_xyzw_10.w;
                    float r1_w_6 = mad(r3_y_10, 0.25, 0.75);
                    float r2_w_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r3_x_10 = max(r1_w_6, r2_w_1);
                    float4 r3_xyzw_11 = t2.Sample(sampler_linear_clamp, (float4(r3_x_10, r3_z_10, r3_w_2, r3_x_10)).xyz);
                    r3_x_12 = r3_xyzw_11.x;
                    r3_y_12 = r3_xyzw_11.y;
                    r3_z_12 = r3_xyzw_11.z;
                    r3_w_4 = r3_xyzw_11.w;
                }
                else
                {
                    float4 r3_xyzw_3 = float4(1, 1, 1, 1);
                    r3_x_12 = r3_xyzw_3.x;
                    r3_y_12 = r3_xyzw_3.y;
                    r3_z_12 = r3_xyzw_3.z;
                    r3_w_4 = r3_xyzw_3.w;
                }
                float r1_w_8 = saturate(dot(float4(r3_x_12, r3_y_12, r3_z_12, r3_w_4), unity_OcclusionMaskSelector));
                float3 r3_xyz_13 = ((i.texcoord2.xyzx + -cb2_values[1].xyzx)).xyz;
                float r2_w_3 = max(abs(r3_xyz_13.y), abs(r3_xyz_13.x));
                float r2_w_4 = max(abs(r3_xyz_13.z), r2_w_3);
                float r2_w_5 = (r2_w_4 + -cb2_values[2].z);
                float r2_w_6 = max(r2_w_5, 1E-05);
                float r2_w_7 = (r2_w_6 * cb2_values[2].w);
                float r2_w_8 = (cb2_values[2].y / r2_w_7);
                float r2_w_9 = (r2_w_8 + -cb2_values[2].x);
                float r2_w_10 = (-r2_w_9 + 1);
                float r2_w_11 = t3.SampleCmpLevelZero(sampler_comparison_linear_clamp1, r3_xyz_13.xyz, r2_w_10);
                float r2_w_12 = mad(r2_w_11, (-cb3_values[24].x + 1), cb3_values[24].x);
                float r1_w_9 = (r1_w_8 + -r2_w_12);
                float r0_w_13 = mad(r0_w_12, r1_w_9, r2_w_12);
                float r1_w_10 = dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx);
                float4 r3_xyzw_15 = t1.Sample(sampler_linear_clamp2, (r1_w_10.xxxx).xy);
                float r0_w_14 = (r0_w_13 * r3_xyzw_15.x);
                float r1_w_11 = saturate(dot(unitWorldNormal_xyz_1.xyzx, r2_xyz_2.xyzx));
                                float r1_x_6 = (pow(saturate(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_9.xxxx * r4_xyz_1.xyzx)).xyzx)), 64) * _SpecColor.x);
                float r0_w_15 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((((r0_w_14.xxxx * (((mad(((r0_xyzw_1.xyzx * cb0_values[9].xyzx)).xyzx, r1_w_11.xxxx, r1_x_6.xxxx)).xyzx * _LightColor0.xyzx)).xyzx)).xyzx * r0_w_19.xxxx)).xyz;
                o.sv_Target0.w = 0;
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
                float4 _MainTex_ST;
                float4 _Color;
                float4 _Emission;
                float4 cb0_values[10];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[7];
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
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            Texture2D t2;
            Texture3D t3;
            struct program56Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program56Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float2 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program102Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float2 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program102Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program56Output vert(program56Input i)
            {
                program56Output o = (program56Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_2.z;
                o.texcoord5.zw = (clipPos_xyzw_2.zzzw).zw;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[8].xyxx, cb0_values[8].zwzz)).xy;
                float worldNormal_x_4 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_z_3 = dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4));
                float r1_z_4 = rsqrt(r1_z_3);
                o.texcoord1.xyz = ((r1_z_4.xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4))).xyz;
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord4.xy = (mad(cb0_values[7].xyxx, r0_xyzw_4.wwww, (mad(_Emission.xyxx, r0_xyzw_4.zzzz, (mad(_MainTex_ST.xyxx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * _Color.xyxx)).xyxx)).xyxx)).xyxx)).xy;
                float4 r1_xyzw_3 = (clipPos_xyzw_2.xxwx * float4(0.5, 0, 0.5, 0));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_z_5 = r1_xyzw_3.z;
                float r1_w_3 = ((clipPos_xyzw_2.y * unity_WorldToObject[1].x) * 0.5);
                o.texcoord5.xy = ((r1_z_5.xxxx + float4(r1_x_3, r1_w_3, r1_x_3, r1_x_3))).xy;
                return o;
            }
            #pragma fragment frag
            program102Output frag(program102Input i)
            {
                program102Output o = (program102Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float3 lightDir_xyz_1 = normalize(_WorldSpaceLightPos0);
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_6 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_7 = rsqrt(r0_w_6);
                float3 r4_xyz_1 = (mad(viewDir_xyz_1.xyzx, r0_w_7.xxxx, lightDir_xyz_1.xyzx)).xyz;
                float3 halfVector_xyz_2 = normalize(r4_xyz_1);
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r0_w_10 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float3 r3_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_1 = dot(r3_xyz_2.xyzx, r3_xyz_2.xyzx);
                float r1_w_2 = sqrt(r1_w_1);
                float r1_w_3 = (-r0_w_10 + r1_w_2);
                float r0_w_11 = mad(cb3_values[25].w, r1_w_3, r0_w_10);
                float r0_w_12 = saturate(mad(r0_w_11, cb3_values[24].z, cb3_values[24].w));
                float r1_w_4 = (cb6_values[0].x == 1);
                float r3_x_12;
                float r3_y_12;
                float r3_z_12;
                float r3_w_4;
                if (r1_w_4)
                {
                    float r1_w_5 = (cb6_values[0].y == 1);
                    float3 r3_xyz_7 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r3_xyzw_10 = (((((r1_w_5.xxxx ? r3_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r3_y_10 = r3_xyzw_10.y;
                    float r3_z_10 = r3_xyzw_10.z;
                    float r3_w_2 = r3_xyzw_10.w;
                    float r1_w_6 = mad(r3_y_10, 0.25, 0.75);
                    float r2_w_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r3_x_10 = max(r1_w_6, r2_w_1);
                    float4 r3_xyzw_11 = t3.Sample(sampler_linear_clamp, (float4(r3_x_10, r3_z_10, r3_w_2, r3_x_10)).xyz);
                    r3_x_12 = r3_xyzw_11.x;
                    r3_y_12 = r3_xyzw_11.y;
                    r3_z_12 = r3_xyzw_11.z;
                    r3_w_4 = r3_xyzw_11.w;
                }
                else
                {
                    float4 r3_xyzw_3 = float4(1, 1, 1, 1);
                    r3_x_12 = r3_xyzw_3.x;
                    r3_y_12 = r3_xyzw_3.y;
                    r3_z_12 = r3_xyzw_3.z;
                    r3_w_4 = r3_xyzw_3.w;
                }
                float r1_w_8 = saturate(dot(float4(r3_x_12, r3_y_12, r3_z_12, r3_w_4), unity_OcclusionMaskSelector));
                float4 r3_xyzw_14 = t1.Sample(sampler_linear_clamp1, (((i.texcoord5.xyxx / i.texcoord5.wwww)).xyxx).xy);
                float r1_w_9 = (r1_w_8 + -r3_xyzw_14.x);
                float r0_w_13 = mad(r0_w_12, r1_w_9, r3_xyzw_14.x);
                float4 r3_xyzw_15 = t2.Sample(sampler_linear_clamp2, ((((mad(cb0_values[6].xyxx, i.texcoord2.zzzz, (mad(cb0_values[4].xyxx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx).xy);
                float r0_w_14 = (r0_w_13 * r3_xyzw_15.w);
                float r1_w_10 = saturate(dot(unitWorldNormal_xyz_1.xyzx, lightDir_xyz_1.xyzx));
                                float r1_x_6 = (pow(saturate(dot(unitWorldNormal_xyz_1.xyzx, halfVector_xyz_2.xyzx)), 64) * _SpecColor.x);
                float r0_w_15 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((((r0_w_14.xxxx * (((mad(((r0_xyzw_1.xyzx * cb0_values[9].xyzx)).xyzx, r1_w_10.xxxx, r1_x_6.xxxx)).xyzx * _LightColor0.xyzx)).xyzx)).xyzx * r0_w_19.xxxx)).xyz;
                o.sv_Target0.w = 0;
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
                float4 _MainTex_ST;
                float4 _Color;
                float4 _Emission;
                float4 cb0_values[15];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[12];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[7];
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
            SamplerComparisonState sampler_comparison_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_linear_clamp3;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            Texture2D t2;
            Texture3D t3;
            Texture2D t4;
            struct program55Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program55Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program100Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program100Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program55Output vert(program55Input i)
            {
                program55Output o = (program55Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[13].xyxx, cb0_values[13].zwzz)).xy;
                float worldNormal_x_3 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 r1_xyzw_4 = (r0_xyzw_4.yyyy * cb0_values[10].xyzw);
                float4 r1_xyzw_5 = mad(cb0_values[9].xyzw, r0_xyzw_4.xxxx, r1_xyzw_4);
                float4 r1_xyzw_6 = mad(cb0_values[11].xyzw, r0_xyzw_4.zzzz, r1_xyzw_5);
                o.texcoord4.xyzw = mad(cb0_values[12].xyzw, r0_xyzw_4.wwww, r1_xyzw_6);
                float4 r1_xyzw_7 = (r0_xyzw_4.yyyy * cb1_values[9].xyzw);
                float4 r1_xyzw_8 = mad(cb1_values[8].xyzw, r0_xyzw_4.xxxx, r1_xyzw_7);
                float4 r1_xyzw_9 = mad(cb1_values[10].xyzw, r0_xyzw_4.zzzz, r1_xyzw_8);
                o.texcoord5.xyzw = mad(cb1_values[11].xyzw, r0_xyzw_4.wwww, r1_xyzw_9);
                return o;
            }
            #pragma fragment frag
            program100Output frag(program100Input i)
            {
                program100Output o = (program100Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float3 r2_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r2_xyz_2 = normalize(r2_xyz_1);
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_6 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_7 = rsqrt(r0_w_6);
                float3 r4_xyz_1 = (mad(viewDir_xyz_1.xyzx, r0_w_7.xxxx, r2_xyz_2.xyzx)).xyz;
                float r0_w_8 = dot(r4_xyz_1.xyzx, r4_xyz_1.xyzx);
                float r0_w_9 = rsqrt(r0_w_8);
                float4 r5_xyzw_4 = (mad(cb0_values[11].xyzw, i.texcoord2.zzzz, mad(cb0_values[9].xyzw, i.texcoord2.xxxx, (i.texcoord2.yyyy * cb0_values[10].xyzw))) + cb0_values[12].xyzw);
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r0_w_10 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float3 r3_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_1 = dot(r3_xyz_2.xyzx, r3_xyz_2.xyzx);
                float r1_w_2 = sqrt(r1_w_1);
                float r1_w_3 = (-r0_w_10 + r1_w_2);
                float r0_w_11 = mad(cb3_values[25].w, r1_w_3, r0_w_10);
                float r0_w_12 = saturate(mad(r0_w_11, cb3_values[24].z, cb3_values[24].w));
                float r1_w_4 = (cb6_values[0].x == 1);
                float r3_x_12;
                float r3_y_12;
                float r3_z_12;
                float r3_w_4;
                if (r1_w_4)
                {
                    float r1_w_5 = (cb6_values[0].y == 1);
                    float3 r3_xyz_7 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r3_xyzw_10 = (((((r1_w_5.xxxx ? r3_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r3_y_10 = r3_xyzw_10.y;
                    float r3_z_10 = r3_xyzw_10.z;
                    float r3_w_2 = r3_xyzw_10.w;
                    float r1_w_6 = mad(r3_y_10, 0.25, 0.75);
                    float r2_w_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r3_x_10 = max(r1_w_6, r2_w_1);
                    float4 r3_xyzw_11 = t3.Sample(sampler_linear_clamp, (float4(r3_x_10, r3_z_10, r3_w_2, r3_x_10)).xyz);
                    r3_x_12 = r3_xyzw_11.x;
                    r3_y_12 = r3_xyzw_11.y;
                    r3_z_12 = r3_xyzw_11.z;
                    r3_w_4 = r3_xyzw_11.w;
                }
                else
                {
                    float4 r3_xyzw_3 = float4(1, 1, 1, 1);
                    r3_x_12 = r3_xyzw_3.x;
                    r3_y_12 = r3_xyzw_3.y;
                    r3_z_12 = r3_xyzw_3.z;
                    r3_w_4 = r3_xyzw_3.w;
                }
                float r1_w_8 = saturate(dot(float4(r3_x_12, r3_y_12, r3_z_12, r3_w_4), unity_OcclusionMaskSelector));
                float r2_w_3 = (r0_w_12 < 0.99);
                float r2_w_10;
                if (r2_w_3)
                {
                    float4 r3_xyzw_13 = (i.texcoord2.yyyy * cb3_values[9].xyzw);
                    float4 r3_xyzw_14 = mad(cb3_values[8].xyzw, i.texcoord2.xxxx, r3_xyzw_13);
                    float4 r3_xyzw_15 = mad(cb3_values[10].xyzw, i.texcoord2.zzzz, r3_xyzw_14);
                    float4 r3_xyzw_16 = (r3_xyzw_15 + cb3_values[11].xyzw);
                    float3 r3_xyz_17 = ((r3_xyzw_16.xyzx / r3_xyzw_16.wwww)).xyz;
                    float2 r6_xy_3 = (floor((mad(r3_xyz_17.xyxx, cb0_values[8].zwzz, float4(0.5, 0.5, 0, 0))).xyxx)).xy;
                    float2 r3_xy_18 = (mad(r3_xyz_17.xyxx, cb0_values[8].zwzz, -r6_xy_3.xyxx)).xy;
                    float4 r7_xyzw_1 = (r3_xy_18.xxyy + float4(0.5, 1, 0.5, 1));
                    float2 r8_xw_1 = ((r7_xyzw_1.xxxz * r7_xyzw_1.xxxz)).xw;
                    float4 r6_xyzw_2 = mad(r8_xw_1.xxxy, float4(0, 0, 0.5, 0.5), -r3_xy_18.xxxy);
                    float r6_z_2 = r6_xyzw_2.z;
                    float r6_w_1 = r6_xyzw_2.w;
                    float2 r7_xz_2 = ((-r3_xy_18.xxyx + float4(1, 0, 1, 0))).xz;
                    float2 r9_xy_1 = (min(r3_xy_18.xyxx, float4(0, 0, 0, 0))).xy;
                    float2 r7_xz_3 = (mad(-r9_xy_1.xxyx, r9_xy_1.xxyx, r7_xz_2.xxyx)).xz;
                    float2 r3_xy_19 = (max(r3_xy_18.xyxx, float4(0, 0, 0, 0))).xy;
                    float2 r3_xy_20 = (mad(-r3_xy_19.xyxx, r3_xy_19.xyxx, r7_xyzw_1.ywyy)).xy;
                    float r9_x_2 = r6_z_2;
                    float r9_y_2 = r7_xz_3.x;
                    float r9_z_1 = r3_xy_20.x;
                    float r9_w_1 = r8_xw_1.x;
                    float4 r9_xyzw_3 = (float4(r9_x_2, r9_y_2, r9_z_1, r9_w_1) * float4(0.44444, 0.44444, 0.44444, 0.22222));
                    float r8_x_2 = r6_w_1;
                    float r8_y_1 = r7_xz_3.y;
                    float r8_z_1 = r3_xy_20.y;
                    float4 r7_xyzw_4 = (float4(r8_x_2, r8_y_1, r8_z_1, r8_xw_1.y) * float4(0.44444, 0.44444, 0.44444, 0.22222));
                    float4 r8_xyzw_3 = (r9_xyzw_3.ywyw + r9_xyzw_3.xzxz);
                    float4 r10_xyzw_1 = (r7_xyzw_4.yyww + r7_xyzw_4.xxzz);
                    float4 r6_xyzw_3 = (r7_xyzw_4.yyyw / r10_xyzw_1.yyyw);
                    float r6_z_3 = r6_xyzw_3.z;
                    float r6_w_2 = r6_xyzw_3.w;
                    float4 r6_xyzw_4 = (float4(r6_z_3, r6_z_3, r6_z_3, r6_w_2) + float4(0, 0, -1.5, 0.5));
                    float r6_z_4 = r6_xyzw_4.z;
                    float r6_w_3 = r6_xyzw_4.w;
                    float4 r7_xyzw_5 = (((((r9_xyzw_3.ywyy / r8_xyzw_3.zwzz)).xyxx + float4(-1.5, 0.5, 0, 0))).xyxx * cb0_values[8].xxxx);
                    float r7_x_5 = r7_xyzw_5.x;
                    float r7_y_3 = r7_xyzw_5.y;
                    float r7_z_5 = ((float4(r6_z_4, r6_z_4, r6_z_4, r6_w_3) * cb0_values[8].yyyy)).z;
                    float r7_w_3 = ((float4(r6_z_4, r6_z_4, r6_z_4, r6_w_3) * cb0_values[8].yyyy)).w;
                    float4 r8_xyzw_4 = (r8_xyzw_3 * r10_xyzw_1);
                    float4 r9_xyzw_4 = mad(r6_xy_3.xyxy, cb0_values[8].xyxy, float4(r7_x_5, r7_z_5, r7_y_3, r7_z_5));
                    float r2_w_5 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r9_xyzw_4.xyxx).xy, r3_xyz_17.z);
                    float r3_x_23 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r9_xyzw_4.zwzz).xy, r3_xyz_17.z);
                    float r2_w_6 = mad(r8_xyzw_4.x, r2_w_5, (r3_x_23 * r8_xyzw_4.y));
                    float r6_x_4 = (mad(r6_xy_3.xyxy, cb0_values[8].xyxy, float4(r7_x_5, r7_w_3, r7_y_3, r7_w_3))).x;
                    float r6_y_4 = (mad(r6_xy_3.xyxy, cb0_values[8].xyxy, float4(r7_x_5, r7_w_3, r7_y_3, r7_w_3))).y;
                    float4 r6_xyzw_5 = mad(r6_xy_3.xyxy, cb0_values[8].xyxy, float4(r7_x_5, r7_w_3, r7_y_3, r7_w_3));
                    float r6_z_5 = r6_xyzw_5.z;
                    float r6_w_4 = r6_xyzw_5.w;
                    float r3_x_25 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r6_x_4, r6_y_4, r6_x_4, r6_x_4)).xy, r3_xyz_17.z);
                    float r2_w_7 = mad(r8_xyzw_4.z, r3_x_25, r2_w_6);
                    float r3_x_26 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r6_z_5, r6_w_4, r6_z_5, r6_z_5)).xy, r3_xyz_17.z);
                    float r2_w_8 = mad(r8_xyzw_4.w, r3_x_26, r2_w_7);
                    float r2_w_9 = mad(r2_w_8, (-cb3_values[24].x + 1), cb3_values[24].x);
                    r2_w_10 = r2_w_9;
                }
                else
                {
                    float r2_w_4 = 1;
                    r2_w_10 = r2_w_4;
                }
                float r1_w_9 = (r1_w_8 + -r2_w_10);
                float r0_w_13 = mad(r0_w_12, r1_w_9, r2_w_10);
                float r1_w_10 = (0 < r5_xyzw_4.z);
                float r1_w_11 = asfloat(asint(r1_w_10) & asint(1065353216));
                float4 r3_xyzw_29 = (r5_xyzw_4.xyxx / r5_xyzw_4.wwww);
                float r3_x_29 = r3_xyzw_29.x;
                float r3_y_24 = r3_xyzw_29.y;
                float4 r3_xyzw_30 = (float4(r3_x_29, r3_y_24, r3_x_29, r3_x_29) + float4(0.5, 0.5, 0, 0));
                float r3_x_30 = r3_xyzw_30.x;
                float r3_y_25 = r3_xyzw_30.y;
                float4 r3_xyzw_31 = t1.Sample(sampler_linear_clamp2, (float4(r3_x_30, r3_y_25, r3_x_30, r3_x_30)).xy);
                float r1_w_12 = (r1_w_11 * r3_xyzw_31.w);
                float r2_w_11 = dot(r5_xyzw_4.xyzx, r5_xyzw_4.xyzx);
                float4 r3_xyzw_32 = t2.Sample(sampler_linear_clamp3, (r2_w_11.xxxx).xy);
                float r1_w_13 = (r1_w_12 * r3_xyzw_32.x);
                float r0_w_14 = (r0_w_13 * r1_w_13);
                float r1_w_14 = saturate(dot(unitWorldNormal_xyz_1.xyzx, r2_xyz_2.xyzx));
                                float r1_x_6 = (pow(saturate(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_9.xxxx * r4_xyz_1.xyzx)).xyzx)), 64) * _SpecColor.x);
                float r0_w_15 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((((r0_w_14.xxxx * (((mad(((r0_xyzw_1.xyzx * cb0_values[14].xyzx)).xyzx, r1_w_14.xxxx, r1_x_6.xxxx)).xyzx * _LightColor0.xyzx)).xyzx)).xyzx * r0_w_19.xxxx)).xyz;
                o.sv_Target0.w = 0;
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
                float4 _MainTex_ST;
                float4 _Color;
                float4 _Emission;
                float4 cb0_values[10];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[12];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[7];
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
            SamplerComparisonState sampler_comparison_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_linear_clamp3;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            Texture2D t2;
            Texture3D t3;
            Texture2D t4;
            struct program54Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program54Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program99Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program99Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program54Output vert(program54Input i)
            {
                program54Output o = (program54Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[8].xyxx, cb0_values[8].zwzz)).xy;
                float worldNormal_x_3 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 r1_xyzw_4 = (r0_xyzw_4.yyyy * _Color);
                float4 r1_xyzw_5 = mad(_MainTex_ST, r0_xyzw_4.xxxx, r1_xyzw_4);
                float4 r1_xyzw_6 = mad(_Emission, r0_xyzw_4.zzzz, r1_xyzw_5);
                o.texcoord4.xyzw = mad(cb0_values[7].xyzw, r0_xyzw_4.wwww, r1_xyzw_6);
                float4 r1_xyzw_7 = (r0_xyzw_4.yyyy * cb1_values[9].xyzw);
                float4 r1_xyzw_8 = mad(cb1_values[8].xyzw, r0_xyzw_4.xxxx, r1_xyzw_7);
                float4 r1_xyzw_9 = mad(cb1_values[10].xyzw, r0_xyzw_4.zzzz, r1_xyzw_8);
                o.texcoord5.xyzw = mad(cb1_values[11].xyzw, r0_xyzw_4.wwww, r1_xyzw_9);
                return o;
            }
            #pragma fragment frag
            program99Output frag(program99Input i)
            {
                program99Output o = (program99Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float3 r2_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r2_xyz_2 = normalize(r2_xyz_1);
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_6 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_7 = rsqrt(r0_w_6);
                float3 r4_xyz_1 = (mad(viewDir_xyz_1.xyzx, r0_w_7.xxxx, r2_xyz_2.xyzx)).xyz;
                float r0_w_8 = dot(r4_xyz_1.xyzx, r4_xyz_1.xyzx);
                float r0_w_9 = rsqrt(r0_w_8);
                float4 r5_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord2.zzzz, mad(cb0_values[4].xyzw, i.texcoord2.xxxx, (i.texcoord2.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r0_w_10 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float3 r3_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_1 = dot(r3_xyz_2.xyzx, r3_xyz_2.xyzx);
                float r1_w_2 = sqrt(r1_w_1);
                float r1_w_3 = (-r0_w_10 + r1_w_2);
                float r0_w_11 = mad(cb3_values[25].w, r1_w_3, r0_w_10);
                float r0_w_12 = saturate(mad(r0_w_11, cb3_values[24].z, cb3_values[24].w));
                float r1_w_4 = (cb6_values[0].x == 1);
                float r3_x_12;
                float r3_y_12;
                float r3_z_12;
                float r3_w_4;
                if (r1_w_4)
                {
                    float r1_w_5 = (cb6_values[0].y == 1);
                    float3 r3_xyz_7 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r3_xyzw_10 = (((((r1_w_5.xxxx ? r3_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r3_y_10 = r3_xyzw_10.y;
                    float r3_z_10 = r3_xyzw_10.z;
                    float r3_w_2 = r3_xyzw_10.w;
                    float r1_w_6 = mad(r3_y_10, 0.25, 0.75);
                    float r2_w_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r3_x_10 = max(r1_w_6, r2_w_1);
                    float4 r3_xyzw_11 = t3.Sample(sampler_linear_clamp, (float4(r3_x_10, r3_z_10, r3_w_2, r3_x_10)).xyz);
                    r3_x_12 = r3_xyzw_11.x;
                    r3_y_12 = r3_xyzw_11.y;
                    r3_z_12 = r3_xyzw_11.z;
                    r3_w_4 = r3_xyzw_11.w;
                }
                else
                {
                    float4 r3_xyzw_3 = float4(1, 1, 1, 1);
                    r3_x_12 = r3_xyzw_3.x;
                    r3_y_12 = r3_xyzw_3.y;
                    r3_z_12 = r3_xyzw_3.z;
                    r3_w_4 = r3_xyzw_3.w;
                }
                float r1_w_8 = saturate(dot(float4(r3_x_12, r3_y_12, r3_z_12, r3_w_4), unity_OcclusionMaskSelector));
                float4 r3_xyzw_13 = (i.texcoord2.yyyy * cb3_values[9].xyzw);
                float4 r3_xyzw_14 = mad(cb3_values[8].xyzw, i.texcoord2.xxxx, r3_xyzw_13);
                float4 r3_xyzw_15 = mad(cb3_values[10].xyzw, i.texcoord2.zzzz, r3_xyzw_14);
                float4 r3_xyzw_16 = (r3_xyzw_15 + cb3_values[11].xyzw);
                float3 r3_xyz_17 = ((r3_xyzw_16.xyzx / r3_xyzw_16.wwww)).xyz;
                float r2_w_3 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r3_xyz_17.xyxx).xy, r3_xyz_17.z);
                float r2_w_4 = mad(r2_w_3, (-cb3_values[24].x + 1), cb3_values[24].x);
                float r1_w_9 = (r1_w_8 + -r2_w_4);
                float r0_w_13 = mad(r0_w_12, r1_w_9, r2_w_4);
                float r1_w_10 = (0 < r5_xyzw_4.z);
                float r1_w_11 = asfloat(asint(r1_w_10) & asint(1065353216));
                float4 r3_xyzw_19 = (r5_xyzw_4.xyxx / r5_xyzw_4.wwww);
                float r3_x_19 = r3_xyzw_19.x;
                float r3_y_18 = r3_xyzw_19.y;
                float4 r3_xyzw_20 = (float4(r3_x_19, r3_y_18, r3_x_19, r3_x_19) + float4(0.5, 0.5, 0, 0));
                float r3_x_20 = r3_xyzw_20.x;
                float r3_y_19 = r3_xyzw_20.y;
                float4 r3_xyzw_21 = t1.Sample(sampler_linear_clamp2, (float4(r3_x_20, r3_y_19, r3_x_20, r3_x_20)).xy);
                float r1_w_12 = (r1_w_11 * r3_xyzw_21.w);
                float r2_w_5 = dot(r5_xyzw_4.xyzx, r5_xyzw_4.xyzx);
                float4 r3_xyzw_22 = t2.Sample(sampler_linear_clamp3, (r2_w_5.xxxx).xy);
                float r1_w_13 = (r1_w_12 * r3_xyzw_22.x);
                float r0_w_14 = (r0_w_13 * r1_w_13);
                float r1_w_14 = saturate(dot(unitWorldNormal_xyz_1.xyzx, r2_xyz_2.xyzx));
                                float r1_x_6 = (pow(saturate(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_9.xxxx * r4_xyz_1.xyzx)).xyzx)), 64) * _SpecColor.x);
                float r0_w_15 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((((r0_w_14.xxxx * (((mad(((r0_xyzw_1.xyzx * cb0_values[9].xyzx)).xyzx, r1_w_14.xxxx, r1_x_6.xxxx)).xyzx * _LightColor0.xyzx)).xyzx)).xyzx * r0_w_19.xxxx)).xyz;
                o.sv_Target0.w = 0;
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
                float4 _MainTex_ST;
                float4 _Color;
                float4 _Emission;
                float4 cb0_values[10];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
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
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            Texture3D t2;
            struct program53Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program53Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float2 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program98Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float2 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program98Output
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
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[8].xyxx, cb0_values[8].zwzz)).xy;
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float2 clipPos_xy_4 = ((worldPos_xyzw_4.yyyy * _Color.xyxx)).xy;
                float2 clipPos_xy_5 = (mad(_MainTex_ST.xyxx, worldPos_xyzw_4.xxxx, clipPos_xy_4.xyxx)).xy;
                float2 clipPos_xy_6 = (mad(_Emission.xyxx, worldPos_xyzw_4.zzzz, clipPos_xy_5.xyxx)).xy;
                o.texcoord4.xy = (mad(cb0_values[7].xyxx, worldPos_xyzw_4.wwww, clipPos_xy_6.xyxx)).xy;
                return o;
            }
            #pragma fragment frag
            program98Output frag(program98Input i)
            {
                program98Output o = (program98Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float3 lightDir_xyz_1 = normalize(_WorldSpaceLightPos0);
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_6 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_7 = rsqrt(r0_w_6);
                float3 r3_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_7.xxxx, lightDir_xyz_1.xyzx)).xyz;
                float3 halfVector_xyz_3 = normalize(r3_xyz_2);
                float r0_w_10 = (cb4_values[0].x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r0_w_10)
                {
                    float r0_w_11 = (cb4_values[0].y == 1);
                    float3 r5_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord2.zzzz, (mad(cb4_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r5_xyzw_8 = (((((r0_w_11.xxxx ? r5_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r0_w_12 = mad(r5_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(cb4_values[0].z, 0.5, 0.75);
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
                float4 r4_xyzw_5 = t1.Sample(sampler_linear_clamp1, ((((mad(cb0_values[6].xyxx, i.texcoord2.zzzz, (mad(cb0_values[4].xyxx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx).xy);
                float r0_w_15 = (r0_w_14 * r4_xyzw_5.w);
                float r1_w_3 = saturate(dot(unitWorldNormal_xyz_1.xyzx, lightDir_xyz_1.xyzx));
                                float r1_x_6 = (pow(saturate(dot(unitWorldNormal_xyz_1.xyzx, halfVector_xyz_3.xyzx)), 64) * _SpecColor.x);
                float r0_w_16 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_17 = (-r0_w_16 + 1);
                float r0_w_18 = (r0_w_17 * cb1_values[5].z);
                float r0_w_19 = max(r0_w_18, 0);
                float r0_w_20 = saturate(mad(r0_w_19, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w));
                o.sv_Target0.xyz = ((((r0_w_15.xxxx * (((mad(((r0_xyzw_1.xyzx * cb0_values[9].xyzx)).xyzx, r1_w_3.xxxx, r1_x_6.xxxx)).xyzx * _LightColor0.xyzx)).xyzx)).xyzx * r0_w_20.xxxx)).xyz;
                o.sv_Target0.w = 0;
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
                float4 _MainTex_ST;
                float4 _Color;
                float4 _Emission;
                float4 cb0_values[10];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
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
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            TextureCube t2;
            Texture3D t3;
            struct program52Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program52Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program97Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program97Output
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
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[8].xyxx, cb0_values[8].zwzz)).xy;
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_4 = ((worldPos_xyzw_4.yyyy * _Color.xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(_Emission.xyzx, worldPos_xyzw_4.zzzz, (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_4.xyzx)).xyzx)).xyz;
                o.texcoord4.xyz = (mad(cb0_values[7].xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program97Output frag(program97Input i)
            {
                program97Output o = (program97Output)0;
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
                float r0_w_10 = (cb4_values[0].x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r0_w_10)
                {
                    float r0_w_11 = (cb4_values[0].y == 1);
                    float3 r5_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord2.zzzz, (mad(cb4_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r5_xyzw_8 = (((((r0_w_11.xxxx ? r5_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r0_w_12 = mad(r5_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r5_x_8 = max(r0_w_12, r1_w_1);
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
                float r0_w_14 = saturate(dot(float4(r5_x_10, r5_y_10, r5_z_10, r5_w_4), unity_OcclusionMaskSelector));
                float r1_w_3 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float4 r5_xyzw_11 = t1.Sample(sampler_linear_clamp2, (r1_w_3.xxxx).xy);
                float4 r4_xyzw_5 = t2.Sample(sampler_linear_clamp1, r4_xyz_4.xyz);
                float r1_w_4 = (r4_xyzw_5.w * r5_xyzw_11.x);
                float r0_w_15 = (r0_w_14 * r1_w_4);
                float r1_w_5 = saturate(dot(unitWorldNormal_xyz_1.xyzx, r2_xyz_2.xyzx));
                                float r1_x_6 = (pow(saturate(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_9.xxxx * r3_xyz_2.xyzx)).xyzx)), 64) * _SpecColor.x);
                float r0_w_16 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_17 = (-r0_w_16 + 1);
                float r0_w_18 = (r0_w_17 * cb1_values[5].z);
                float r0_w_19 = max(r0_w_18, 0);
                float r0_w_20 = saturate(mad(r0_w_19, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w));
                o.sv_Target0.xyz = ((((r0_w_15.xxxx * (((mad(((r0_xyzw_1.xyzx * cb0_values[9].xyzx)).xyzx, r1_w_5.xxxx, r1_x_6.xxxx)).xyzx * _LightColor0.xyzx)).xyzx)).xyzx * r0_w_20.xxxx)).xyz;
                o.sv_Target0.w = 0;
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
                float4 _MainTex_ST;
                float4 _Color;
                float4 _Emission;
                float4 cb0_values[10];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
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
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            Texture2D t2;
            Texture3D t3;
            struct program51Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program51Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program96Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program96Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program51Output vert(program51Input i)
            {
                program51Output o = (program51Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * unity_MatrixVP[1])));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[8].xyxx, cb0_values[8].zwzz)).xy;
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float4 clipPos_xyzw_4 = (worldPos_xyzw_4.yyyy * _Color);
                float4 clipPos_xyzw_5 = mad(_MainTex_ST, worldPos_xyzw_4.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(_Emission, worldPos_xyzw_4.zzzz, clipPos_xyzw_5);
                o.texcoord4.xyzw = mad(cb0_values[7].xyzw, worldPos_xyzw_4.wwww, clipPos_xyzw_6);
                return o;
            }
            #pragma fragment frag
            program96Output frag(program96Input i)
            {
                program96Output o = (program96Output)0;
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
                float4 r4_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord2.zzzz, mad(cb0_values[4].xyzw, i.texcoord2.xxxx, (i.texcoord2.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r0_w_10 = (cb4_values[0].x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r0_w_10)
                {
                    float r0_w_11 = (cb4_values[0].y == 1);
                    float3 r5_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord2.zzzz, (mad(cb4_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r5_xyzw_8 = (((((r0_w_11.xxxx ? r5_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r0_w_12 = mad(r5_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r5_x_8 = max(r0_w_12, r1_w_1);
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
                float r0_w_14 = saturate(dot(float4(r5_x_10, r5_y_10, r5_z_10, r5_w_4), unity_OcclusionMaskSelector));
                float r1_w_3 = (0 < r4_xyzw_4.z);
                float r1_w_4 = asfloat(asint(r1_w_3) & asint(1065353216));
                float4 r5_xyzw_13 = t1.Sample(sampler_linear_clamp1, (((((r4_xyzw_4.xyxx / r4_xyzw_4.wwww)).xyxx + float4(0.5, 0.5, 0, 0))).xyxx).xy);
                float r1_w_5 = (r1_w_4 * r5_xyzw_13.w);
                float r2_w_1 = dot(r4_xyzw_4.xyzx, r4_xyzw_4.xyzx);
                float4 r4_xyzw_5 = t2.Sample(sampler_linear_clamp2, (r2_w_1.xxxx).xy);
                float r1_w_6 = (r1_w_5 * r4_xyzw_5.x);
                float r0_w_15 = (r0_w_14 * r1_w_6);
                float r1_w_7 = saturate(dot(unitWorldNormal_xyz_1.xyzx, r2_xyz_2.xyzx));
                                float r1_x_6 = (pow(saturate(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_9.xxxx * r3_xyz_2.xyzx)).xyzx)), 64) * _SpecColor.x);
                float r0_w_16 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_17 = (-r0_w_16 + 1);
                float r0_w_18 = (r0_w_17 * cb1_values[5].z);
                float r0_w_19 = max(r0_w_18, 0);
                float r0_w_20 = saturate(mad(r0_w_19, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w));
                o.sv_Target0.xyz = ((((r0_w_15.xxxx * (((mad(((r0_xyzw_1.xyzx * cb0_values[9].xyzx)).xyzx, r1_w_7.xxxx, r1_x_6.xxxx)).xyzx * _LightColor0.xyzx)).xyzx)).xyzx * r0_w_20.xxxx)).xyz;
                o.sv_Target0.w = 0;
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
                float4 _MainTex_ST;
                float4 _Color;
                float4 _Emission;
                float4 cb0_values[6];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
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
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture3D t1;
            struct program50Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program50Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program95Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program95Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program50Output vert(program50Input i)
            {
                program50Output o = (program50Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program95Output frag(program95Input i)
            {
                program95Output o = (program95Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float3 lightDir_xyz_1 = normalize(_WorldSpaceLightPos0);
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_6 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_7 = rsqrt(r0_w_6);
                float3 r3_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_7.xxxx, lightDir_xyz_1.xyzx)).xyz;
                float3 halfVector_xyz_3 = normalize(r3_xyz_2);
                float r0_w_10 = (cb4_values[0].x == 1);
                float r4_x_10;
                float r4_y_10;
                float r4_z_10;
                float r4_w_4;
                if (r0_w_10)
                {
                    float r0_w_11 = (cb4_values[0].y == 1);
                    float3 r4_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord2.zzzz, (mad(cb4_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r4_xyzw_8 = (((((r0_w_11.xxxx ? r4_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r4_y_8 = r4_xyzw_8.y;
                    float r4_z_8 = r4_xyzw_8.z;
                    float r4_w_2 = r4_xyzw_8.w;
                    float r0_w_12 = mad(r4_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r4_x_8 = max(r0_w_12, r1_w_1);
                    float4 r4_xyzw_9 = t1.Sample(sampler_linear_clamp, (float4(r4_x_8, r4_z_8, r4_w_2, r4_x_8)).xyz);
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
                float r0_w_14 = saturate(dot(float4(r4_x_10, r4_y_10, r4_z_10, r4_w_4), unity_OcclusionMaskSelector));
                float r1_w_3 = saturate(dot(unitWorldNormal_xyz_1.xyzx, lightDir_xyz_1.xyzx));
                                float r1_x_6 = (pow(saturate(dot(unitWorldNormal_xyz_1.xyzx, halfVector_xyz_3.xyzx)), 64) * _SpecColor.x);
                float r0_w_15 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w));
                o.sv_Target0.xyz = ((((r0_w_14.xxxx * (((mad(((r0_xyzw_1.xyzx * cb0_values[5].xyzx)).xyzx, r1_w_3.xxxx, r1_x_6.xxxx)).xyzx * _LightColor0.xyzx)).xyzx)).xyzx * r0_w_19.xxxx)).xyz;
                o.sv_Target0.w = 0;
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
                float4 _MainTex_ST;
                float4 _Color;
                float4 _Emission;
                float4 cb0_values[10];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
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
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            Texture3D t2;
            struct program49Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program49Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program94Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program94Output
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
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord3.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[8].xyxx, cb0_values[8].zwzz)).xy;
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_4 = ((worldPos_xyzw_4.yyyy * _Color.xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(_Emission.xyzx, worldPos_xyzw_4.zzzz, (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_4.xyzx)).xyzx)).xyz;
                o.texcoord4.xyz = (mad(cb0_values[7].xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program94Output frag(program94Input i)
            {
                program94Output o = (program94Output)0;
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
                float r0_w_10 = (cb4_values[0].x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r0_w_10)
                {
                    float r0_w_11 = (cb4_values[0].y == 1);
                    float3 r5_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord2.zzzz, (mad(cb4_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r5_xyzw_8 = (((((r0_w_11.xxxx ? r5_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r0_w_12 = mad(r5_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(cb4_values[0].z, 0.5, 0.75);
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
                float r0_w_16 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_17 = (-r0_w_16 + 1);
                float r0_w_18 = (r0_w_17 * cb1_values[5].z);
                float r0_w_19 = max(r0_w_18, 0);
                float r0_w_20 = saturate(mad(r0_w_19, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w));
                o.sv_Target0.xyz = ((((r0_w_15.xxxx * (((mad(((r0_xyzw_1.xyzx * cb0_values[9].xyzx)).xyzx, r1_w_4.xxxx, r1_x_6.xxxx)).xyzx * _LightColor0.xyzx)).xyzx)).xyzx * r0_w_20.xxxx)).xyz;
                o.sv_Target0.w = 0;
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
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[7];
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
            SamplerComparisonState sampler_comparison_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_linear_clamp3;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            TextureCube t2;
            Texture3D t3;
            TextureCube t4;
            struct program48Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program48Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program93Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program93Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program48Output vert(program48Input i)
            {
                program48Output o = (program48Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[8].xyxx, cb0_values[8].zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float3 r1_xyz_3 = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = r1_xyz_3.xyz;
                o.texcoord5.xyz = ((r1_xyz_3.xyzx + -unity_ObjectToWorld[1].xyzx)).xyz;
                o.texcoord4.xyz = (mad(cb0_values[7].xyzx, r0_xyzw_4.wwww, (mad(_Emission.xyzx, r0_xyzw_4.zzzz, (mad(_MainTex_ST.xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * _Color.xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program93Output frag(program93Input i)
            {
                program93Output o = (program93Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float3 r2_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r2_xyz_2 = normalize(r2_xyz_1);
                float3 r3_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_6 = dot(r3_xyz_1.xyzx, r3_xyz_1.xyzx);
                float r0_w_7 = rsqrt(r0_w_6);
                float3 r4_xyz_1 = (mad(r3_xyz_1.xyzx, r0_w_7.xxxx, r2_xyz_2.xyzx)).xyz;
                float r0_w_8 = dot(r4_xyz_1.xyzx, r4_xyz_1.xyzx);
                float r0_w_9 = rsqrt(r0_w_8);
                float3 r5_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r0_w_10 = dot(r3_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float3 r3_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_1 = dot(r3_xyz_2.xyzx, r3_xyz_2.xyzx);
                float r1_w_2 = sqrt(r1_w_1);
                float r1_w_3 = (-r0_w_10 + r1_w_2);
                float r0_w_11 = mad(cb3_values[25].w, r1_w_3, r0_w_10);
                float r0_w_12 = saturate(mad(r0_w_11, cb3_values[24].z, cb3_values[24].w));
                float r1_w_4 = (cb5_values[0].x == 1);
                float r3_x_12;
                float r3_y_12;
                float r3_z_12;
                float r3_w_4;
                if (r1_w_4)
                {
                    float r1_w_5 = (cb5_values[0].y == 1);
                    float3 r3_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r3_xyzw_10 = (((((r1_w_5.xxxx ? r3_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r3_y_10 = r3_xyzw_10.y;
                    float r3_z_10 = r3_xyzw_10.z;
                    float r3_w_2 = r3_xyzw_10.w;
                    float r1_w_6 = mad(r3_y_10, 0.25, 0.75);
                    float r2_w_1 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r3_x_10 = max(r1_w_6, r2_w_1);
                    float4 r3_xyzw_11 = t3.Sample(sampler_linear_clamp, (float4(r3_x_10, r3_z_10, r3_w_2, r3_x_10)).xyz);
                    r3_x_12 = r3_xyzw_11.x;
                    r3_y_12 = r3_xyzw_11.y;
                    r3_z_12 = r3_xyzw_11.z;
                    r3_w_4 = r3_xyzw_11.w;
                }
                else
                {
                    float4 r3_xyzw_3 = float4(1, 1, 1, 1);
                    r3_x_12 = r3_xyzw_3.x;
                    r3_y_12 = r3_xyzw_3.y;
                    r3_z_12 = r3_xyzw_3.z;
                    r3_w_4 = r3_xyzw_3.w;
                }
                float r1_w_8 = saturate(dot(float4(r3_x_12, r3_y_12, r3_z_12, r3_w_4), unity_OcclusionMaskSelector));
                float r2_w_3 = (r0_w_12 < 0.99);
                float r2_w_15;
                if (r2_w_3)
                {
                    float3 r3_xyz_13 = ((i.texcoord2.xyzx + -cb2_values[1].xyzx)).xyz;
                    float r2_w_5 = max(abs(r3_xyz_13.y), abs(r3_xyz_13.x));
                    float r2_w_6 = max(abs(r3_xyz_13.z), r2_w_5);
                    float r2_w_7 = (r2_w_6 + -cb2_values[2].z);
                    float r2_w_8 = max(r2_w_7, 1E-05);
                    float r2_w_9 = (r2_w_8 * cb2_values[2].w);
                    float r2_w_10 = (cb2_values[2].y / r2_w_9);
                    float r2_w_11 = (r2_w_10 + -cb2_values[2].x);
                    float r2_w_12 = (-r2_w_11 + 1);
                    float r6_x_3 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r3_xyz_13.xyzx + float4(0.0078125, 0.0078125, 0.0078125, 0))).xyzx).xyz, r2_w_12);
                    float r6_y_3 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r3_xyz_13.xyzx + float4(-0.0078125, -0.0078125, 0.0078125, 0))).xyzx).xyz, r2_w_12);
                    float r6_z_3 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r3_xyz_13.xyzx + float4(-0.0078125, 0.0078125, -0.0078125, 0))).xyzx).xyz, r2_w_12);
                    float r6_w_1 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r3_xyz_13.xyzx + float4(0.0078125, -0.0078125, -0.0078125, 0))).xyzx).xyz, r2_w_12);
                    float r2_w_13 = dot(float4(r6_x_3, r6_y_3, r6_z_3, r6_w_1), float4(0.25, 0.25, 0.25, 0.25));
                    float r2_w_14 = mad(r2_w_13, (-cb3_values[24].x + 1), cb3_values[24].x);
                    r2_w_15 = r2_w_14;
                }
                else
                {
                    float r2_w_4 = 1;
                    r2_w_15 = r2_w_4;
                }
                float r1_w_9 = (r1_w_8 + -r2_w_15);
                float r0_w_13 = mad(r0_w_12, r1_w_9, r2_w_15);
                float r1_w_10 = dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx);
                float4 r3_xyzw_17 = t1.Sample(sampler_linear_clamp3, (r1_w_10.xxxx).xy);
                float4 r5_xyzw_5 = t2.Sample(sampler_linear_clamp2, r5_xyz_4.xyz);
                float r1_w_11 = (r3_xyzw_17.x * r5_xyzw_5.w);
                float r0_w_14 = (r0_w_13 * r1_w_11);
                float r1_w_12 = saturate(dot(unitWorldNormal_xyz_1.xyzx, r2_xyz_2.xyzx));
                                float r1_x_6 = (pow(saturate(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_9.xxxx * r4_xyz_1.xyzx)).xyzx)), 64) * _SpecColor.x);
                o.sv_Target0.xyz = ((r0_w_14.xxxx * (((mad(((r0_xyzw_1.xyzx * cb0_values[9].xyzx)).xyzx, r1_w_12.xxxx, r1_x_6.xxxx)).xyzx * _LightColor0.xyzx)).xyzx)).xyz;
                o.sv_Target0.w = 0;
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
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[7];
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
            SamplerComparisonState sampler_comparison_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_linear_clamp3;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            TextureCube t2;
            Texture3D t3;
            TextureCube t4;
            struct program47Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program47Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program92Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program92Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program47Output vert(program47Input i)
            {
                program47Output o = (program47Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[8].xyxx, cb0_values[8].zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float3 r1_xyz_3 = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = r1_xyz_3.xyz;
                o.texcoord5.xyz = ((r1_xyz_3.xyzx + -unity_ObjectToWorld[1].xyzx)).xyz;
                o.texcoord4.xyz = (mad(cb0_values[7].xyzx, r0_xyzw_4.wwww, (mad(_Emission.xyzx, r0_xyzw_4.zzzz, (mad(_MainTex_ST.xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * _Color.xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program92Output frag(program92Input i)
            {
                program92Output o = (program92Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float3 r2_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r2_xyz_2 = normalize(r2_xyz_1);
                float3 r3_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_6 = dot(r3_xyz_1.xyzx, r3_xyz_1.xyzx);
                float r0_w_7 = rsqrt(r0_w_6);
                float3 r4_xyz_1 = (mad(r3_xyz_1.xyzx, r0_w_7.xxxx, r2_xyz_2.xyzx)).xyz;
                float r0_w_8 = dot(r4_xyz_1.xyzx, r4_xyz_1.xyzx);
                float r0_w_9 = rsqrt(r0_w_8);
                float3 r5_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r0_w_10 = dot(r3_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float3 r3_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_1 = dot(r3_xyz_2.xyzx, r3_xyz_2.xyzx);
                float r1_w_2 = sqrt(r1_w_1);
                float r1_w_3 = (-r0_w_10 + r1_w_2);
                float r0_w_11 = mad(cb3_values[25].w, r1_w_3, r0_w_10);
                float r0_w_12 = saturate(mad(r0_w_11, cb3_values[24].z, cb3_values[24].w));
                float r1_w_4 = (cb5_values[0].x == 1);
                float r3_x_12;
                float r3_y_12;
                float r3_z_12;
                float r3_w_4;
                if (r1_w_4)
                {
                    float r1_w_5 = (cb5_values[0].y == 1);
                    float3 r3_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r3_xyzw_10 = (((((r1_w_5.xxxx ? r3_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r3_y_10 = r3_xyzw_10.y;
                    float r3_z_10 = r3_xyzw_10.z;
                    float r3_w_2 = r3_xyzw_10.w;
                    float r1_w_6 = mad(r3_y_10, 0.25, 0.75);
                    float r2_w_1 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r3_x_10 = max(r1_w_6, r2_w_1);
                    float4 r3_xyzw_11 = t3.Sample(sampler_linear_clamp, (float4(r3_x_10, r3_z_10, r3_w_2, r3_x_10)).xyz);
                    r3_x_12 = r3_xyzw_11.x;
                    r3_y_12 = r3_xyzw_11.y;
                    r3_z_12 = r3_xyzw_11.z;
                    r3_w_4 = r3_xyzw_11.w;
                }
                else
                {
                    float4 r3_xyzw_3 = float4(1, 1, 1, 1);
                    r3_x_12 = r3_xyzw_3.x;
                    r3_y_12 = r3_xyzw_3.y;
                    r3_z_12 = r3_xyzw_3.z;
                    r3_w_4 = r3_xyzw_3.w;
                }
                float r1_w_8 = saturate(dot(float4(r3_x_12, r3_y_12, r3_z_12, r3_w_4), unity_OcclusionMaskSelector));
                float3 r3_xyz_13 = ((i.texcoord2.xyzx + -cb2_values[1].xyzx)).xyz;
                float r2_w_3 = max(abs(r3_xyz_13.y), abs(r3_xyz_13.x));
                float r2_w_4 = max(abs(r3_xyz_13.z), r2_w_3);
                float r2_w_5 = (r2_w_4 + -cb2_values[2].z);
                float r2_w_6 = max(r2_w_5, 1E-05);
                float r2_w_7 = (r2_w_6 * cb2_values[2].w);
                float r2_w_8 = (cb2_values[2].y / r2_w_7);
                float r2_w_9 = (r2_w_8 + -cb2_values[2].x);
                float r2_w_10 = (-r2_w_9 + 1);
                float r2_w_11 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, r3_xyz_13.xyz, r2_w_10);
                float r2_w_12 = mad(r2_w_11, (-cb3_values[24].x + 1), cb3_values[24].x);
                float r1_w_9 = (r1_w_8 + -r2_w_12);
                float r0_w_13 = mad(r0_w_12, r1_w_9, r2_w_12);
                float r1_w_10 = dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx);
                float4 r3_xyzw_15 = t1.Sample(sampler_linear_clamp3, (r1_w_10.xxxx).xy);
                float4 r5_xyzw_5 = t2.Sample(sampler_linear_clamp2, r5_xyz_4.xyz);
                float r1_w_11 = (r3_xyzw_15.x * r5_xyzw_5.w);
                float r0_w_14 = (r0_w_13 * r1_w_11);
                float r1_w_12 = saturate(dot(unitWorldNormal_xyz_1.xyzx, r2_xyz_2.xyzx));
                                float r1_x_6 = (pow(saturate(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_9.xxxx * r4_xyz_1.xyzx)).xyzx)), 64) * _SpecColor.x);
                o.sv_Target0.xyz = ((r0_w_14.xxxx * (((mad(((r0_xyzw_1.xyzx * cb0_values[9].xyzx)).xyzx, r1_w_12.xxxx, r1_x_6.xxxx)).xyzx * _LightColor0.xyzx)).xyzx)).xyz;
                o.sv_Target0.w = 0;
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
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[7];
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
            SamplerComparisonState sampler_comparison_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            Texture3D t2;
            TextureCube t3;
            struct program46Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program46Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program91Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program91Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program46Output vert(program46Input i)
            {
                program46Output o = (program46Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[8].xyxx, cb0_values[8].zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float3 r1_xyz_3 = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = r1_xyz_3.xyz;
                o.texcoord5.xyz = ((r1_xyz_3.xyzx + -unity_ObjectToWorld[1].xyzx)).xyz;
                o.texcoord4.xyz = (mad(cb0_values[7].xyzx, r0_xyzw_4.wwww, (mad(_Emission.xyzx, r0_xyzw_4.zzzz, (mad(_MainTex_ST.xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * _Color.xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program91Output frag(program91Input i)
            {
                program91Output o = (program91Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float3 r2_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r2_xyz_2 = normalize(r2_xyz_1);
                float3 r3_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_6 = dot(r3_xyz_1.xyzx, r3_xyz_1.xyzx);
                float r0_w_7 = rsqrt(r0_w_6);
                float3 r4_xyz_1 = (mad(r3_xyz_1.xyzx, r0_w_7.xxxx, r2_xyz_2.xyzx)).xyz;
                float r0_w_8 = dot(r4_xyz_1.xyzx, r4_xyz_1.xyzx);
                float r0_w_9 = rsqrt(r0_w_8);
                float3 r5_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r0_w_10 = dot(r3_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float3 r3_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_1 = dot(r3_xyz_2.xyzx, r3_xyz_2.xyzx);
                float r1_w_2 = sqrt(r1_w_1);
                float r1_w_3 = (-r0_w_10 + r1_w_2);
                float r0_w_11 = mad(cb3_values[25].w, r1_w_3, r0_w_10);
                float r0_w_12 = saturate(mad(r0_w_11, cb3_values[24].z, cb3_values[24].w));
                float r1_w_4 = (cb5_values[0].x == 1);
                float r3_x_12;
                float r3_y_12;
                float r3_z_12;
                float r3_w_4;
                if (r1_w_4)
                {
                    float r1_w_5 = (cb5_values[0].y == 1);
                    float3 r3_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r3_xyzw_10 = (((((r1_w_5.xxxx ? r3_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r3_y_10 = r3_xyzw_10.y;
                    float r3_z_10 = r3_xyzw_10.z;
                    float r3_w_2 = r3_xyzw_10.w;
                    float r1_w_6 = mad(r3_y_10, 0.25, 0.75);
                    float r2_w_1 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r3_x_10 = max(r1_w_6, r2_w_1);
                    float4 r3_xyzw_11 = t2.Sample(sampler_linear_clamp, (float4(r3_x_10, r3_z_10, r3_w_2, r3_x_10)).xyz);
                    r3_x_12 = r3_xyzw_11.x;
                    r3_y_12 = r3_xyzw_11.y;
                    r3_z_12 = r3_xyzw_11.z;
                    r3_w_4 = r3_xyzw_11.w;
                }
                else
                {
                    float4 r3_xyzw_3 = float4(1, 1, 1, 1);
                    r3_x_12 = r3_xyzw_3.x;
                    r3_y_12 = r3_xyzw_3.y;
                    r3_z_12 = r3_xyzw_3.z;
                    r3_w_4 = r3_xyzw_3.w;
                }
                float r1_w_8 = saturate(dot(float4(r3_x_12, r3_y_12, r3_z_12, r3_w_4), unity_OcclusionMaskSelector));
                float r2_w_3 = (r0_w_12 < 0.99);
                float r2_w_15;
                if (r2_w_3)
                {
                    float3 r3_xyz_13 = ((i.texcoord2.xyzx + -cb2_values[1].xyzx)).xyz;
                    float r2_w_5 = max(abs(r3_xyz_13.y), abs(r3_xyz_13.x));
                    float r2_w_6 = max(abs(r3_xyz_13.z), r2_w_5);
                    float r2_w_7 = (r2_w_6 + -cb2_values[2].z);
                    float r2_w_8 = max(r2_w_7, 1E-05);
                    float r2_w_9 = (r2_w_8 * cb2_values[2].w);
                    float r2_w_10 = (cb2_values[2].y / r2_w_9);
                    float r2_w_11 = (r2_w_10 + -cb2_values[2].x);
                    float r2_w_12 = (-r2_w_11 + 1);
                    float r6_x_3 = t3.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r3_xyz_13.xyzx + float4(0.0078125, 0.0078125, 0.0078125, 0))).xyzx).xyz, r2_w_12);
                    float r6_y_3 = t3.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r3_xyz_13.xyzx + float4(-0.0078125, -0.0078125, 0.0078125, 0))).xyzx).xyz, r2_w_12);
                    float r6_z_3 = t3.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r3_xyz_13.xyzx + float4(-0.0078125, 0.0078125, -0.0078125, 0))).xyzx).xyz, r2_w_12);
                    float r6_w_1 = t3.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r3_xyz_13.xyzx + float4(0.0078125, -0.0078125, -0.0078125, 0))).xyzx).xyz, r2_w_12);
                    float r2_w_13 = dot(float4(r6_x_3, r6_y_3, r6_z_3, r6_w_1), float4(0.25, 0.25, 0.25, 0.25));
                    float r2_w_14 = mad(r2_w_13, (-cb3_values[24].x + 1), cb3_values[24].x);
                    r2_w_15 = r2_w_14;
                }
                else
                {
                    float r2_w_4 = 1;
                    r2_w_15 = r2_w_4;
                }
                float r1_w_9 = (r1_w_8 + -r2_w_15);
                float r0_w_13 = mad(r0_w_12, r1_w_9, r2_w_15);
                float r1_w_10 = dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx);
                float4 r3_xyzw_17 = t1.Sample(sampler_linear_clamp2, (r1_w_10.xxxx).xy);
                float r0_w_14 = (r0_w_13 * r3_xyzw_17.x);
                float r1_w_11 = saturate(dot(unitWorldNormal_xyz_1.xyzx, r2_xyz_2.xyzx));
                                float r1_x_6 = (pow(saturate(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_9.xxxx * r4_xyz_1.xyzx)).xyzx)), 64) * _SpecColor.x);
                o.sv_Target0.xyz = ((r0_w_14.xxxx * (((mad(((r0_xyzw_1.xyzx * cb0_values[9].xyzx)).xyzx, r1_w_11.xxxx, r1_x_6.xxxx)).xyzx * _LightColor0.xyzx)).xyzx)).xyz;
                o.sv_Target0.w = 0;
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
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[7];
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
            SamplerComparisonState sampler_comparison_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            Texture3D t2;
            TextureCube t3;
            struct program45Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program45Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program90Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program90Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program45Output vert(program45Input i)
            {
                program45Output o = (program45Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[8].xyxx, cb0_values[8].zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float3 r1_xyz_3 = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = r1_xyz_3.xyz;
                o.texcoord5.xyz = ((r1_xyz_3.xyzx + -unity_ObjectToWorld[1].xyzx)).xyz;
                o.texcoord4.xyz = (mad(cb0_values[7].xyzx, r0_xyzw_4.wwww, (mad(_Emission.xyzx, r0_xyzw_4.zzzz, (mad(_MainTex_ST.xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * _Color.xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program90Output frag(program90Input i)
            {
                program90Output o = (program90Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float3 r2_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r2_xyz_2 = normalize(r2_xyz_1);
                float3 r3_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_6 = dot(r3_xyz_1.xyzx, r3_xyz_1.xyzx);
                float r0_w_7 = rsqrt(r0_w_6);
                float3 r4_xyz_1 = (mad(r3_xyz_1.xyzx, r0_w_7.xxxx, r2_xyz_2.xyzx)).xyz;
                float r0_w_8 = dot(r4_xyz_1.xyzx, r4_xyz_1.xyzx);
                float r0_w_9 = rsqrt(r0_w_8);
                float3 r5_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r0_w_10 = dot(r3_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float3 r3_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_1 = dot(r3_xyz_2.xyzx, r3_xyz_2.xyzx);
                float r1_w_2 = sqrt(r1_w_1);
                float r1_w_3 = (-r0_w_10 + r1_w_2);
                float r0_w_11 = mad(cb3_values[25].w, r1_w_3, r0_w_10);
                float r0_w_12 = saturate(mad(r0_w_11, cb3_values[24].z, cb3_values[24].w));
                float r1_w_4 = (cb5_values[0].x == 1);
                float r3_x_12;
                float r3_y_12;
                float r3_z_12;
                float r3_w_4;
                if (r1_w_4)
                {
                    float r1_w_5 = (cb5_values[0].y == 1);
                    float3 r3_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r3_xyzw_10 = (((((r1_w_5.xxxx ? r3_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r3_y_10 = r3_xyzw_10.y;
                    float r3_z_10 = r3_xyzw_10.z;
                    float r3_w_2 = r3_xyzw_10.w;
                    float r1_w_6 = mad(r3_y_10, 0.25, 0.75);
                    float r2_w_1 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r3_x_10 = max(r1_w_6, r2_w_1);
                    float4 r3_xyzw_11 = t2.Sample(sampler_linear_clamp, (float4(r3_x_10, r3_z_10, r3_w_2, r3_x_10)).xyz);
                    r3_x_12 = r3_xyzw_11.x;
                    r3_y_12 = r3_xyzw_11.y;
                    r3_z_12 = r3_xyzw_11.z;
                    r3_w_4 = r3_xyzw_11.w;
                }
                else
                {
                    float4 r3_xyzw_3 = float4(1, 1, 1, 1);
                    r3_x_12 = r3_xyzw_3.x;
                    r3_y_12 = r3_xyzw_3.y;
                    r3_z_12 = r3_xyzw_3.z;
                    r3_w_4 = r3_xyzw_3.w;
                }
                float r1_w_8 = saturate(dot(float4(r3_x_12, r3_y_12, r3_z_12, r3_w_4), unity_OcclusionMaskSelector));
                float3 r3_xyz_13 = ((i.texcoord2.xyzx + -cb2_values[1].xyzx)).xyz;
                float r2_w_3 = max(abs(r3_xyz_13.y), abs(r3_xyz_13.x));
                float r2_w_4 = max(abs(r3_xyz_13.z), r2_w_3);
                float r2_w_5 = (r2_w_4 + -cb2_values[2].z);
                float r2_w_6 = max(r2_w_5, 1E-05);
                float r2_w_7 = (r2_w_6 * cb2_values[2].w);
                float r2_w_8 = (cb2_values[2].y / r2_w_7);
                float r2_w_9 = (r2_w_8 + -cb2_values[2].x);
                float r2_w_10 = (-r2_w_9 + 1);
                float r2_w_11 = t3.SampleCmpLevelZero(sampler_comparison_linear_clamp1, r3_xyz_13.xyz, r2_w_10);
                float r2_w_12 = mad(r2_w_11, (-cb3_values[24].x + 1), cb3_values[24].x);
                float r1_w_9 = (r1_w_8 + -r2_w_12);
                float r0_w_13 = mad(r0_w_12, r1_w_9, r2_w_12);
                float r1_w_10 = dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx);
                float4 r3_xyzw_15 = t1.Sample(sampler_linear_clamp2, (r1_w_10.xxxx).xy);
                float r0_w_14 = (r0_w_13 * r3_xyzw_15.x);
                float r1_w_11 = saturate(dot(unitWorldNormal_xyz_1.xyzx, r2_xyz_2.xyzx));
                                float r1_x_6 = (pow(saturate(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_9.xxxx * r4_xyz_1.xyzx)).xyzx)), 64) * _SpecColor.x);
                o.sv_Target0.xyz = ((r0_w_14.xxxx * (((mad(((r0_xyzw_1.xyzx * cb0_values[9].xyzx)).xyzx, r1_w_11.xxxx, r1_x_6.xxxx)).xyzx * _LightColor0.xyzx)).xyzx)).xyz;
                o.sv_Target0.w = 0;
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
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[7];
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
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            Texture2D t2;
            Texture3D t3;
            struct program44Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program44Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program89Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program89Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program44Output vert(program44Input i)
            {
                program44Output o = (program44Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                float4 r2_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                o.texcoord4.xy = (mad(cb0_values[7].xxxy, r2_xyzw_4.wwww, (mad(_Emission.xyxx, r2_xyzw_4.zzzz, (mad(_MainTex_ST.xyxx, r2_xyzw_4.xxxx, ((r2_xyzw_4.yyyy * _Color.xyxx)).xyxx)).xyxx)).xxxy)).zw;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[8].xyxx, cb0_values[8].zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_w_4 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7));
                float r0_w_5 = rsqrt(r0_w_4);
                o.texcoord1.xyz = ((r0_w_5.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7))).xyz;
                float r0_w_6 = ((clipPos_xyzw_2.y * unity_WorldToObject[1].x) * 0.5);
                float4 r0_xyzw_9 = (clipPos_xyzw_2.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                o.texcoord5.zw = (clipPos_xyzw_2.zzzw).zw;
                o.texcoord5.xy = ((r0_z_5.xxxx + float4(r0_x_9, r0_w_6, r0_x_9, r0_x_9))).xy;
                return o;
            }
            #pragma fragment frag
            program89Output frag(program89Input i)
            {
                program89Output o = (program89Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float3 lightDir_xyz_1 = normalize(_WorldSpaceLightPos0);
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_6 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_7 = rsqrt(r0_w_6);
                float3 r4_xyz_1 = (mad(viewDir_xyz_1.xyzx, r0_w_7.xxxx, lightDir_xyz_1.xyzx)).xyz;
                float3 halfVector_xyz_2 = normalize(r4_xyz_1);
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r0_w_10 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float3 r3_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_1 = dot(r3_xyz_2.xyzx, r3_xyz_2.xyzx);
                float r1_w_2 = sqrt(r1_w_1);
                float r1_w_3 = (-r0_w_10 + r1_w_2);
                float r0_w_11 = mad(cb3_values[25].w, r1_w_3, r0_w_10);
                float r0_w_12 = saturate(mad(r0_w_11, cb3_values[24].z, cb3_values[24].w));
                float r1_w_4 = (cb5_values[0].x == 1);
                float r3_x_12;
                float r3_y_12;
                float r3_z_12;
                float r3_w_4;
                if (r1_w_4)
                {
                    float r1_w_5 = (cb5_values[0].y == 1);
                    float3 r3_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r3_xyzw_10 = (((((r1_w_5.xxxx ? r3_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r3_y_10 = r3_xyzw_10.y;
                    float r3_z_10 = r3_xyzw_10.z;
                    float r3_w_2 = r3_xyzw_10.w;
                    float r1_w_6 = mad(r3_y_10, 0.25, 0.75);
                    float r2_w_1 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r3_x_10 = max(r1_w_6, r2_w_1);
                    float4 r3_xyzw_11 = t3.Sample(sampler_linear_clamp, (float4(r3_x_10, r3_z_10, r3_w_2, r3_x_10)).xyz);
                    r3_x_12 = r3_xyzw_11.x;
                    r3_y_12 = r3_xyzw_11.y;
                    r3_z_12 = r3_xyzw_11.z;
                    r3_w_4 = r3_xyzw_11.w;
                }
                else
                {
                    float4 r3_xyzw_3 = float4(1, 1, 1, 1);
                    r3_x_12 = r3_xyzw_3.x;
                    r3_y_12 = r3_xyzw_3.y;
                    r3_z_12 = r3_xyzw_3.z;
                    r3_w_4 = r3_xyzw_3.w;
                }
                float r1_w_8 = saturate(dot(float4(r3_x_12, r3_y_12, r3_z_12, r3_w_4), unity_OcclusionMaskSelector));
                float4 r3_xyzw_14 = t1.Sample(sampler_linear_clamp1, (((i.texcoord5.xyxx / i.texcoord5.wwww)).xyxx).xy);
                float r1_w_9 = (r1_w_8 + -r3_xyzw_14.x);
                float r0_w_13 = mad(r0_w_12, r1_w_9, r3_xyzw_14.x);
                float4 r3_xyzw_15 = t2.Sample(sampler_linear_clamp2, ((((mad(cb0_values[6].xyxx, i.texcoord2.zzzz, (mad(cb0_values[4].xyxx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx).xy);
                float r0_w_14 = (r0_w_13 * r3_xyzw_15.w);
                float r1_w_10 = saturate(dot(unitWorldNormal_xyz_1.xyzx, lightDir_xyz_1.xyzx));
                                float r1_x_6 = (pow(saturate(dot(unitWorldNormal_xyz_1.xyzx, halfVector_xyz_2.xyzx)), 64) * _SpecColor.x);
                o.sv_Target0.xyz = ((r0_w_14.xxxx * (((mad(((r0_xyzw_1.xyzx * cb0_values[9].xyzx)).xyzx, r1_w_10.xxxx, r1_x_6.xxxx)).xyzx * _LightColor0.xyzx)).xyzx)).xyz;
                o.sv_Target0.w = 0;
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
                float4 _MainTex_ST;
                float4 _Color;
                float4 _Emission;
                float4 cb0_values[15];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[12];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[7];
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
            SamplerComparisonState sampler_comparison_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_linear_clamp3;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            Texture2D t2;
            Texture3D t3;
            Texture2D t4;
            struct program43Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program43Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program87Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program87Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program43Output vert(program43Input i)
            {
                program43Output o = (program43Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[13].xyxx, cb0_values[13].zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 r1_xyzw_3 = (r0_xyzw_4.yyyy * cb0_values[10].xyzw);
                float4 r1_xyzw_4 = mad(cb0_values[9].xyzw, r0_xyzw_4.xxxx, r1_xyzw_3);
                float4 r1_xyzw_5 = mad(cb0_values[11].xyzw, r0_xyzw_4.zzzz, r1_xyzw_4);
                o.texcoord4.xyzw = mad(cb0_values[12].xyzw, r0_xyzw_4.wwww, r1_xyzw_5);
                float4 r1_xyzw_6 = (r0_xyzw_4.yyyy * cb1_values[9].xyzw);
                float4 r1_xyzw_7 = mad(cb1_values[8].xyzw, r0_xyzw_4.xxxx, r1_xyzw_6);
                float4 r1_xyzw_8 = mad(cb1_values[10].xyzw, r0_xyzw_4.zzzz, r1_xyzw_7);
                o.texcoord5.xyzw = mad(cb1_values[11].xyzw, r0_xyzw_4.wwww, r1_xyzw_8);
                return o;
            }
            #pragma fragment frag
            program87Output frag(program87Input i)
            {
                program87Output o = (program87Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float3 r2_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r2_xyz_2 = normalize(r2_xyz_1);
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_6 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_7 = rsqrt(r0_w_6);
                float3 r4_xyz_1 = (mad(viewDir_xyz_1.xyzx, r0_w_7.xxxx, r2_xyz_2.xyzx)).xyz;
                float r0_w_8 = dot(r4_xyz_1.xyzx, r4_xyz_1.xyzx);
                float r0_w_9 = rsqrt(r0_w_8);
                float4 r5_xyzw_4 = (mad(cb0_values[11].xyzw, i.texcoord2.zzzz, mad(cb0_values[9].xyzw, i.texcoord2.xxxx, (i.texcoord2.yyyy * cb0_values[10].xyzw))) + cb0_values[12].xyzw);
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r0_w_10 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float3 r3_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_1 = dot(r3_xyz_2.xyzx, r3_xyz_2.xyzx);
                float r1_w_2 = sqrt(r1_w_1);
                float r1_w_3 = (-r0_w_10 + r1_w_2);
                float r0_w_11 = mad(cb3_values[25].w, r1_w_3, r0_w_10);
                float r0_w_12 = saturate(mad(r0_w_11, cb3_values[24].z, cb3_values[24].w));
                float r1_w_4 = (cb5_values[0].x == 1);
                float r3_x_12;
                float r3_y_12;
                float r3_z_12;
                float r3_w_4;
                if (r1_w_4)
                {
                    float r1_w_5 = (cb5_values[0].y == 1);
                    float3 r3_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r3_xyzw_10 = (((((r1_w_5.xxxx ? r3_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r3_y_10 = r3_xyzw_10.y;
                    float r3_z_10 = r3_xyzw_10.z;
                    float r3_w_2 = r3_xyzw_10.w;
                    float r1_w_6 = mad(r3_y_10, 0.25, 0.75);
                    float r2_w_1 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r3_x_10 = max(r1_w_6, r2_w_1);
                    float4 r3_xyzw_11 = t3.Sample(sampler_linear_clamp, (float4(r3_x_10, r3_z_10, r3_w_2, r3_x_10)).xyz);
                    r3_x_12 = r3_xyzw_11.x;
                    r3_y_12 = r3_xyzw_11.y;
                    r3_z_12 = r3_xyzw_11.z;
                    r3_w_4 = r3_xyzw_11.w;
                }
                else
                {
                    float4 r3_xyzw_3 = float4(1, 1, 1, 1);
                    r3_x_12 = r3_xyzw_3.x;
                    r3_y_12 = r3_xyzw_3.y;
                    r3_z_12 = r3_xyzw_3.z;
                    r3_w_4 = r3_xyzw_3.w;
                }
                float r1_w_8 = saturate(dot(float4(r3_x_12, r3_y_12, r3_z_12, r3_w_4), unity_OcclusionMaskSelector));
                float r2_w_3 = (r0_w_12 < 0.99);
                float r2_w_10;
                if (r2_w_3)
                {
                    float4 r3_xyzw_13 = (i.texcoord2.yyyy * cb3_values[9].xyzw);
                    float4 r3_xyzw_14 = mad(cb3_values[8].xyzw, i.texcoord2.xxxx, r3_xyzw_13);
                    float4 r3_xyzw_15 = mad(cb3_values[10].xyzw, i.texcoord2.zzzz, r3_xyzw_14);
                    float4 r3_xyzw_16 = (r3_xyzw_15 + cb3_values[11].xyzw);
                    float3 r3_xyz_17 = ((r3_xyzw_16.xyzx / r3_xyzw_16.wwww)).xyz;
                    float2 r6_xy_3 = (floor((mad(r3_xyz_17.xyxx, cb0_values[8].zwzz, float4(0.5, 0.5, 0, 0))).xyxx)).xy;
                    float2 r3_xy_18 = (mad(r3_xyz_17.xyxx, cb0_values[8].zwzz, -r6_xy_3.xyxx)).xy;
                    float4 r7_xyzw_1 = (r3_xy_18.xxyy + float4(0.5, 1, 0.5, 1));
                    float2 r8_xw_1 = ((r7_xyzw_1.xxxz * r7_xyzw_1.xxxz)).xw;
                    float4 r6_xyzw_2 = mad(r8_xw_1.xxxy, float4(0, 0, 0.5, 0.5), -r3_xy_18.xxxy);
                    float r6_z_2 = r6_xyzw_2.z;
                    float r6_w_1 = r6_xyzw_2.w;
                    float2 r7_xz_2 = ((-r3_xy_18.xxyx + float4(1, 0, 1, 0))).xz;
                    float2 r9_xy_1 = (min(r3_xy_18.xyxx, float4(0, 0, 0, 0))).xy;
                    float2 r7_xz_3 = (mad(-r9_xy_1.xxyx, r9_xy_1.xxyx, r7_xz_2.xxyx)).xz;
                    float2 r3_xy_19 = (max(r3_xy_18.xyxx, float4(0, 0, 0, 0))).xy;
                    float2 r3_xy_20 = (mad(-r3_xy_19.xyxx, r3_xy_19.xyxx, r7_xyzw_1.ywyy)).xy;
                    float r9_x_2 = r6_z_2;
                    float r9_y_2 = r7_xz_3.x;
                    float r9_z_1 = r3_xy_20.x;
                    float r9_w_1 = r8_xw_1.x;
                    float4 r9_xyzw_3 = (float4(r9_x_2, r9_y_2, r9_z_1, r9_w_1) * float4(0.44444, 0.44444, 0.44444, 0.22222));
                    float r8_x_2 = r6_w_1;
                    float r8_y_1 = r7_xz_3.y;
                    float r8_z_1 = r3_xy_20.y;
                    float4 r7_xyzw_4 = (float4(r8_x_2, r8_y_1, r8_z_1, r8_xw_1.y) * float4(0.44444, 0.44444, 0.44444, 0.22222));
                    float4 r8_xyzw_3 = (r9_xyzw_3.ywyw + r9_xyzw_3.xzxz);
                    float4 r10_xyzw_1 = (r7_xyzw_4.yyww + r7_xyzw_4.xxzz);
                    float4 r6_xyzw_3 = (r7_xyzw_4.yyyw / r10_xyzw_1.yyyw);
                    float r6_z_3 = r6_xyzw_3.z;
                    float r6_w_2 = r6_xyzw_3.w;
                    float4 r6_xyzw_4 = (float4(r6_z_3, r6_z_3, r6_z_3, r6_w_2) + float4(0, 0, -1.5, 0.5));
                    float r6_z_4 = r6_xyzw_4.z;
                    float r6_w_3 = r6_xyzw_4.w;
                    float4 r7_xyzw_5 = (((((r9_xyzw_3.ywyy / r8_xyzw_3.zwzz)).xyxx + float4(-1.5, 0.5, 0, 0))).xyxx * cb0_values[8].xxxx);
                    float r7_x_5 = r7_xyzw_5.x;
                    float r7_y_3 = r7_xyzw_5.y;
                    float r7_z_5 = ((float4(r6_z_4, r6_z_4, r6_z_4, r6_w_3) * cb0_values[8].yyyy)).z;
                    float r7_w_3 = ((float4(r6_z_4, r6_z_4, r6_z_4, r6_w_3) * cb0_values[8].yyyy)).w;
                    float4 r8_xyzw_4 = (r8_xyzw_3 * r10_xyzw_1);
                    float4 r9_xyzw_4 = mad(r6_xy_3.xyxy, cb0_values[8].xyxy, float4(r7_x_5, r7_z_5, r7_y_3, r7_z_5));
                    float r2_w_5 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r9_xyzw_4.xyxx).xy, r3_xyz_17.z);
                    float r3_x_23 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r9_xyzw_4.zwzz).xy, r3_xyz_17.z);
                    float r2_w_6 = mad(r8_xyzw_4.x, r2_w_5, (r3_x_23 * r8_xyzw_4.y));
                    float r6_x_4 = (mad(r6_xy_3.xyxy, cb0_values[8].xyxy, float4(r7_x_5, r7_w_3, r7_y_3, r7_w_3))).x;
                    float r6_y_4 = (mad(r6_xy_3.xyxy, cb0_values[8].xyxy, float4(r7_x_5, r7_w_3, r7_y_3, r7_w_3))).y;
                    float4 r6_xyzw_5 = mad(r6_xy_3.xyxy, cb0_values[8].xyxy, float4(r7_x_5, r7_w_3, r7_y_3, r7_w_3));
                    float r6_z_5 = r6_xyzw_5.z;
                    float r6_w_4 = r6_xyzw_5.w;
                    float r3_x_25 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r6_x_4, r6_y_4, r6_x_4, r6_x_4)).xy, r3_xyz_17.z);
                    float r2_w_7 = mad(r8_xyzw_4.z, r3_x_25, r2_w_6);
                    float r3_x_26 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r6_z_5, r6_w_4, r6_z_5, r6_z_5)).xy, r3_xyz_17.z);
                    float r2_w_8 = mad(r8_xyzw_4.w, r3_x_26, r2_w_7);
                    float r2_w_9 = mad(r2_w_8, (-cb3_values[24].x + 1), cb3_values[24].x);
                    r2_w_10 = r2_w_9;
                }
                else
                {
                    float r2_w_4 = 1;
                    r2_w_10 = r2_w_4;
                }
                float r1_w_9 = (r1_w_8 + -r2_w_10);
                float r0_w_13 = mad(r0_w_12, r1_w_9, r2_w_10);
                float r1_w_10 = (0 < r5_xyzw_4.z);
                float r1_w_11 = asfloat(asint(r1_w_10) & asint(1065353216));
                float4 r3_xyzw_29 = (r5_xyzw_4.xyxx / r5_xyzw_4.wwww);
                float r3_x_29 = r3_xyzw_29.x;
                float r3_y_24 = r3_xyzw_29.y;
                float4 r3_xyzw_30 = (float4(r3_x_29, r3_y_24, r3_x_29, r3_x_29) + float4(0.5, 0.5, 0, 0));
                float r3_x_30 = r3_xyzw_30.x;
                float r3_y_25 = r3_xyzw_30.y;
                float4 r3_xyzw_31 = t1.Sample(sampler_linear_clamp2, (float4(r3_x_30, r3_y_25, r3_x_30, r3_x_30)).xy);
                float r1_w_12 = (r1_w_11 * r3_xyzw_31.w);
                float r2_w_11 = dot(r5_xyzw_4.xyzx, r5_xyzw_4.xyzx);
                float4 r3_xyzw_32 = t2.Sample(sampler_linear_clamp3, (r2_w_11.xxxx).xy);
                float r1_w_13 = (r1_w_12 * r3_xyzw_32.x);
                float r0_w_14 = (r0_w_13 * r1_w_13);
                float r1_w_14 = saturate(dot(unitWorldNormal_xyz_1.xyzx, r2_xyz_2.xyzx));
                                float r1_x_6 = (pow(saturate(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_9.xxxx * r4_xyz_1.xyzx)).xyzx)), 64) * _SpecColor.x);
                o.sv_Target0.xyz = ((r0_w_14.xxxx * (((mad(((r0_xyzw_1.xyzx * cb0_values[14].xyzx)).xyzx, r1_w_14.xxxx, r1_x_6.xxxx)).xyzx * _LightColor0.xyzx)).xyzx)).xyz;
                o.sv_Target0.w = 0;
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
                float4 _MainTex_ST;
                float4 _Color;
                float4 _Emission;
                float4 cb0_values[10];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[12];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[7];
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
            SamplerComparisonState sampler_comparison_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_linear_clamp3;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            Texture2D t2;
            Texture3D t3;
            Texture2D t4;
            struct program42Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program42Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program86Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program86Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program42Output vert(program42Input i)
            {
                program42Output o = (program42Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[8].xyxx, cb0_values[8].zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 r1_xyzw_3 = (r0_xyzw_4.yyyy * _Color);
                float4 r1_xyzw_4 = mad(_MainTex_ST, r0_xyzw_4.xxxx, r1_xyzw_3);
                float4 r1_xyzw_5 = mad(_Emission, r0_xyzw_4.zzzz, r1_xyzw_4);
                o.texcoord4.xyzw = mad(cb0_values[7].xyzw, r0_xyzw_4.wwww, r1_xyzw_5);
                float4 r1_xyzw_6 = (r0_xyzw_4.yyyy * cb1_values[9].xyzw);
                float4 r1_xyzw_7 = mad(cb1_values[8].xyzw, r0_xyzw_4.xxxx, r1_xyzw_6);
                float4 r1_xyzw_8 = mad(cb1_values[10].xyzw, r0_xyzw_4.zzzz, r1_xyzw_7);
                o.texcoord5.xyzw = mad(cb1_values[11].xyzw, r0_xyzw_4.wwww, r1_xyzw_8);
                return o;
            }
            #pragma fragment frag
            program86Output frag(program86Input i)
            {
                program86Output o = (program86Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float3 r2_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r2_xyz_2 = normalize(r2_xyz_1);
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_6 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_7 = rsqrt(r0_w_6);
                float3 r4_xyz_1 = (mad(viewDir_xyz_1.xyzx, r0_w_7.xxxx, r2_xyz_2.xyzx)).xyz;
                float r0_w_8 = dot(r4_xyz_1.xyzx, r4_xyz_1.xyzx);
                float r0_w_9 = rsqrt(r0_w_8);
                float4 r5_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord2.zzzz, mad(cb0_values[4].xyzw, i.texcoord2.xxxx, (i.texcoord2.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r0_w_10 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float3 r3_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_1 = dot(r3_xyz_2.xyzx, r3_xyz_2.xyzx);
                float r1_w_2 = sqrt(r1_w_1);
                float r1_w_3 = (-r0_w_10 + r1_w_2);
                float r0_w_11 = mad(cb3_values[25].w, r1_w_3, r0_w_10);
                float r0_w_12 = saturate(mad(r0_w_11, cb3_values[24].z, cb3_values[24].w));
                float r1_w_4 = (cb5_values[0].x == 1);
                float r3_x_12;
                float r3_y_12;
                float r3_z_12;
                float r3_w_4;
                if (r1_w_4)
                {
                    float r1_w_5 = (cb5_values[0].y == 1);
                    float3 r3_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r3_xyzw_10 = (((((r1_w_5.xxxx ? r3_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r3_y_10 = r3_xyzw_10.y;
                    float r3_z_10 = r3_xyzw_10.z;
                    float r3_w_2 = r3_xyzw_10.w;
                    float r1_w_6 = mad(r3_y_10, 0.25, 0.75);
                    float r2_w_1 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r3_x_10 = max(r1_w_6, r2_w_1);
                    float4 r3_xyzw_11 = t3.Sample(sampler_linear_clamp, (float4(r3_x_10, r3_z_10, r3_w_2, r3_x_10)).xyz);
                    r3_x_12 = r3_xyzw_11.x;
                    r3_y_12 = r3_xyzw_11.y;
                    r3_z_12 = r3_xyzw_11.z;
                    r3_w_4 = r3_xyzw_11.w;
                }
                else
                {
                    float4 r3_xyzw_3 = float4(1, 1, 1, 1);
                    r3_x_12 = r3_xyzw_3.x;
                    r3_y_12 = r3_xyzw_3.y;
                    r3_z_12 = r3_xyzw_3.z;
                    r3_w_4 = r3_xyzw_3.w;
                }
                float r1_w_8 = saturate(dot(float4(r3_x_12, r3_y_12, r3_z_12, r3_w_4), unity_OcclusionMaskSelector));
                float4 r3_xyzw_13 = (i.texcoord2.yyyy * cb3_values[9].xyzw);
                float4 r3_xyzw_14 = mad(cb3_values[8].xyzw, i.texcoord2.xxxx, r3_xyzw_13);
                float4 r3_xyzw_15 = mad(cb3_values[10].xyzw, i.texcoord2.zzzz, r3_xyzw_14);
                float4 r3_xyzw_16 = (r3_xyzw_15 + cb3_values[11].xyzw);
                float3 r3_xyz_17 = ((r3_xyzw_16.xyzx / r3_xyzw_16.wwww)).xyz;
                float r2_w_3 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r3_xyz_17.xyxx).xy, r3_xyz_17.z);
                float r2_w_4 = mad(r2_w_3, (-cb3_values[24].x + 1), cb3_values[24].x);
                float r1_w_9 = (r1_w_8 + -r2_w_4);
                float r0_w_13 = mad(r0_w_12, r1_w_9, r2_w_4);
                float r1_w_10 = (0 < r5_xyzw_4.z);
                float r1_w_11 = asfloat(asint(r1_w_10) & asint(1065353216));
                float4 r3_xyzw_19 = (r5_xyzw_4.xyxx / r5_xyzw_4.wwww);
                float r3_x_19 = r3_xyzw_19.x;
                float r3_y_18 = r3_xyzw_19.y;
                float4 r3_xyzw_20 = (float4(r3_x_19, r3_y_18, r3_x_19, r3_x_19) + float4(0.5, 0.5, 0, 0));
                float r3_x_20 = r3_xyzw_20.x;
                float r3_y_19 = r3_xyzw_20.y;
                float4 r3_xyzw_21 = t1.Sample(sampler_linear_clamp2, (float4(r3_x_20, r3_y_19, r3_x_20, r3_x_20)).xy);
                float r1_w_12 = (r1_w_11 * r3_xyzw_21.w);
                float r2_w_5 = dot(r5_xyzw_4.xyzx, r5_xyzw_4.xyzx);
                float4 r3_xyzw_22 = t2.Sample(sampler_linear_clamp3, (r2_w_5.xxxx).xy);
                float r1_w_13 = (r1_w_12 * r3_xyzw_22.x);
                float r0_w_14 = (r0_w_13 * r1_w_13);
                float r1_w_14 = saturate(dot(unitWorldNormal_xyz_1.xyzx, r2_xyz_2.xyzx));
                                float r1_x_6 = (pow(saturate(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_9.xxxx * r4_xyz_1.xyzx)).xyzx)), 64) * _SpecColor.x);
                o.sv_Target0.xyz = ((r0_w_14.xxxx * (((mad(((r0_xyzw_1.xyzx * cb0_values[9].xyzx)).xyzx, r1_w_14.xxxx, r1_x_6.xxxx)).xyzx * _LightColor0.xyzx)).xyzx)).xyz;
                o.sv_Target0.w = 0;
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
            struct program41Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program41Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program85Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program85Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program41Output vert(program41Input i)
            {
                program41Output o = (program41Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                worldPos_xyzw_2 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float2 clipPos_xy_4 = ((worldPos_xyzw_2.yyyy * _Color.xyxx)).xy;
                float2 clipPos_xy_5 = (mad(_MainTex_ST.xyxx, worldPos_xyzw_2.xxxx, clipPos_xy_4.xyxx)).xy;
                float2 clipPos_xy_6 = (mad(_Emission.xyxx, worldPos_xyzw_2.zzzz, clipPos_xy_5.xyxx)).xy;
                o.texcoord4.xy = (mad(cb0_values[7].xxxy, worldPos_xyzw_2.wwww, clipPos_xy_6.xxxy)).zw;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[8].xyxx, cb0_values[8].zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_4 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7));
                float r0_w_5 = rsqrt(r0_w_4);
                o.texcoord1.xyz = ((r0_w_5.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program85Output frag(program85Input i)
            {
                program85Output o = (program85Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 unitClipPos_xyz_1 = normalize(i.texcoord1);
                float3 lightDir_xyz_1 = normalize(_WorldSpaceLightPos0);
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_6 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_7 = rsqrt(r0_w_6);
                float3 r3_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_7.xxxx, lightDir_xyz_1.xyzx)).xyz;
                float3 halfVector_xyz_3 = normalize(r3_xyz_2);
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
                float4 r4_xyzw_5 = t1.Sample(sampler_linear_clamp1, ((((mad(cb0_values[6].xyxx, i.texcoord2.zzzz, (mad(cb0_values[4].xyxx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx).xy);
                float r0_w_15 = (r0_w_14 * r4_xyzw_5.w);
                float r1_w_3 = saturate(dot(unitClipPos_xyz_1.xyzx, lightDir_xyz_1.xyzx));
                                float r1_x_6 = (pow(saturate(dot(unitClipPos_xyz_1.xyzx, halfVector_xyz_3.xyzx)), 64) * _SpecColor.x);
                o.sv_Target0.xyz = ((r0_w_15.xxxx * (((mad(((r0_xyzw_1.xyzx * cb0_values[9].xyzx)).xyzx, r1_w_3.xxxx, r1_x_6.xxxx)).xyzx * _LightColor0.xyzx)).xyzx)).xyz;
                o.sv_Target0.w = 0;
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
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            TextureCube t2;
            Texture3D t3;
            struct program40Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program40Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program84Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program84Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program40Output vert(program40Input i)
            {
                program40Output o = (program40Output)0;
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
            program84Output frag(program84Input i)
            {
                program84Output o = (program84Output)0;
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
                float r0_w_14 = saturate(dot(float4(r5_x_10, r5_y_10, r5_z_10, r5_w_4), unity_OcclusionMaskSelector));
                float r1_w_3 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float4 r5_xyzw_11 = t1.Sample(sampler_linear_clamp2, (r1_w_3.xxxx).xy);
                float4 r4_xyzw_5 = t2.Sample(sampler_linear_clamp1, r4_xyz_4.xyz);
                float r1_w_4 = (r4_xyzw_5.w * r5_xyzw_11.x);
                float r0_w_15 = (r0_w_14 * r1_w_4);
                float r1_w_5 = saturate(dot(unitWorldNormal_xyz_1.xyzx, r2_xyz_2.xyzx));
                                float r1_x_6 = (pow(saturate(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_9.xxxx * r3_xyz_2.xyzx)).xyzx)), 64) * _SpecColor.x);
                o.sv_Target0.xyz = ((r0_w_15.xxxx * (((mad(((r0_xyzw_1.xyzx * cb0_values[9].xyzx)).xyzx, r1_w_5.xxxx, r1_x_6.xxxx)).xyzx * _LightColor0.xyzx)).xyzx)).xyz;
                o.sv_Target0.w = 0;
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
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            Texture2D t2;
            Texture3D t3;
            struct program39Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program39Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program83Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program83Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program39Output vert(program39Input i)
            {
                program39Output o = (program39Output)0;
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
                float clipPos_x_3 = ((worldPos_xyzw_4.yyyy * _Color)).x;
                float clipPos_y_3 = ((worldPos_xyzw_4.yyyy * _Color)).y;
                float clipPos_z_3 = ((worldPos_xyzw_4.yyyy * _Color)).z;
                float clipPos_w_4 = ((worldPos_xyzw_4.yyyy * _Color)).w;
                float4 clipPos_xyzw_4 = mad(_MainTex_ST, worldPos_xyzw_4.xxxx, float4(clipPos_x_3, clipPos_y_3, clipPos_z_3, clipPos_w_4));
                float4 clipPos_xyzw_5 = mad(_Emission, worldPos_xyzw_4.zzzz, clipPos_xyzw_4);
                o.texcoord4.xyzw = mad(cb0_values[7].xyzw, worldPos_xyzw_4.wwww, clipPos_xyzw_5);
                return o;
            }
            #pragma fragment frag
            program83Output frag(program83Input i)
            {
                program83Output o = (program83Output)0;
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
                float4 r4_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord2.zzzz, mad(cb0_values[4].xyzw, i.texcoord2.xxxx, (i.texcoord2.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
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
                float r0_w_14 = saturate(dot(float4(r5_x_10, r5_y_10, r5_z_10, r5_w_4), unity_OcclusionMaskSelector));
                float r1_w_3 = (0 < r4_xyzw_4.z);
                float r1_w_4 = asfloat(asint(r1_w_3) & asint(1065353216));
                float4 r5_xyzw_13 = t1.Sample(sampler_linear_clamp1, (((((r4_xyzw_4.xyxx / r4_xyzw_4.wwww)).xyxx + float4(0.5, 0.5, 0, 0))).xyxx).xy);
                float r1_w_5 = (r1_w_4 * r5_xyzw_13.w);
                float r2_w_1 = dot(r4_xyzw_4.xyzx, r4_xyzw_4.xyzx);
                float4 r4_xyzw_5 = t2.Sample(sampler_linear_clamp2, (r2_w_1.xxxx).xy);
                float r1_w_6 = (r1_w_5 * r4_xyzw_5.x);
                float r0_w_15 = (r0_w_14 * r1_w_6);
                float r1_w_7 = saturate(dot(unitWorldNormal_xyz_1.xyzx, r2_xyz_2.xyzx));
                                float r1_x_6 = (pow(saturate(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_9.xxxx * r3_xyz_2.xyzx)).xyzx)), 64) * _SpecColor.x);
                o.sv_Target0.xyz = ((r0_w_15.xxxx * (((mad(((r0_xyzw_1.xyzx * cb0_values[9].xyzx)).xyzx, r1_w_7.xxxx, r1_x_6.xxxx)).xyzx * _LightColor0.xyzx)).xyzx)).xyz;
                o.sv_Target0.w = 0;
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
                float4 _MainTex_ST;
                float4 _Color;
                float4 _Emission;
                float4 cb0_values[6];
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
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture3D t1;
            struct program38Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program38Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program82Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program82Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program38Output vert(program38Input i)
            {
                program38Output o = (program38Output)0;
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
                return o;
            }
            #pragma fragment frag
            program82Output frag(program82Input i)
            {
                program82Output o = (program82Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float3 lightDir_xyz_1 = normalize(_WorldSpaceLightPos0);
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_6 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_7 = rsqrt(r0_w_6);
                float3 r3_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_7.xxxx, lightDir_xyz_1.xyzx)).xyz;
                float3 halfVector_xyz_3 = normalize(r3_xyz_2);
                float r0_w_10 = (unity_ProbeVolumeParams.x == 1);
                float r4_x_10;
                float r4_y_10;
                float r4_z_10;
                float r4_w_4;
                if (r0_w_10)
                {
                    float r0_w_11 = (unity_ProbeVolumeParams.y == 1);
                    float3 r4_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_11.xxxx ? r4_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r4_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r4_y_8 = r4_xyzw_8.y;
                    float r4_z_8 = r4_xyzw_8.z;
                    float r4_w_2 = r4_xyzw_8.w;
                    float r0_w_12 = mad(r4_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r4_x_8 = max(r0_w_12, r1_w_1);
                    float4 r4_xyzw_9 = t1.Sample(sampler_linear_clamp, (float4(r4_x_8, r4_z_8, r4_w_2, r4_x_8)).xyz);
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
                float r0_w_14 = saturate(dot(float4(r4_x_10, r4_y_10, r4_z_10, r4_w_4), unity_OcclusionMaskSelector));
                float r1_w_3 = saturate(dot(unitWorldNormal_xyz_1.xyzx, lightDir_xyz_1.xyzx));
                                float r1_x_6 = (pow(saturate(dot(unitWorldNormal_xyz_1.xyzx, halfVector_xyz_3.xyzx)), 64) * _SpecColor.x);
                o.sv_Target0.xyz = ((r0_w_14.xxxx * (((mad(((r0_xyzw_1.xyzx * cb0_values[5].xyzx)).xyzx, r1_w_3.xxxx, r1_x_6.xxxx)).xyzx * _LightColor0.xyzx)).xyzx)).xyz;
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
        Pass
        {
            Tags { "LIGHTMODE"="Vertex" "QUEUE"="Geometry" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
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
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb2_values[2];
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
            struct program109Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
            };
            struct program109Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
            };
            struct program113Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
            };
            struct program113Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program109Output vert(program109Input i)
            {
                program109Output o = (program109Output)0;
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float3 r0_xyz_4 = (mad(unity_WorldToObject[3].xyzx, unity_MatrixInvV[0].wwww, (mad(unity_WorldToObject[2].xyzx, unity_MatrixInvV[0].zzzz, (mad(unity_WorldToObject[0].xyzx, unity_MatrixInvV[0].xxxx, ((unity_WorldToObject[1].xyzx * unity_MatrixInvV[0].yyyy)).xyzx)).xyzx)).xyzx)).xyz;
                float3 r1_xyz_4 = (mad(unity_WorldToObject[3].xyzx, unity_MatrixInvV[1].wwww, (mad(unity_WorldToObject[2].xyzx, unity_MatrixInvV[1].zzzz, (mad(unity_WorldToObject[0].xyzx, unity_MatrixInvV[1].xxxx, ((unity_WorldToObject[1].xyzx * unity_MatrixInvV[1].yyyy)).xyzx)).xyzx)).xyzx)).xyz;
                float3 r2_xyz_4 = (mad(unity_WorldToObject[3].xyzx, unity_MatrixInvV[2].wwww, (mad(unity_WorldToObject[2].xyzx, unity_MatrixInvV[2].zzzz, (mad(unity_WorldToObject[0].xyzx, unity_MatrixInvV[2].xxxx, ((unity_WorldToObject[1].xyzx * unity_MatrixInvV[2].yyyy)).xyzx)).xyzx)).xyzx)).xyz;
                float4 worldPos_xyzw_4 = UnityObjectToWorldPos(i.position0.xyz);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_4.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[0], worldPos_xyzw_4.xxxx, clipPos_xyzw_1);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_4.zzzz, clipPos_xyzw_2);
                float4 clipPos_xyzw_4 = mad(unity_MatrixVP[3], worldPos_xyzw_4.wwww, clipPos_xyzw_3);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float3 clipPos_xyz_1 = ((worldPos_xyzw_4.yyyy * unity_MatrixV[1].xyzx)).xyz;
                float3 clipPos_xyz_2 = (mad(unity_MatrixV[0].xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_1.xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(unity_MatrixV[2].xyzx, worldPos_xyzw_4.zzzz, clipPos_xyz_2.xyzx)).xyz;
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
                float3 r5_xyz_4;
                float r1_w_3;
                float r1_w_4;
                float r2_w_1;
                float3 r5_xyz_5;
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
                    r5_xyz_4 = (mad(-clipPos_xyz_6.xyzx, cb1_values[r0_w_4 + 15].wwww, cb1_values[r0_w_4 + 15].xyzx)).xyz;
                    r1_w_3 = dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx);
                    r1_w_4 = max(r1_w_3, 1E-06);
                    r2_w_1 = rsqrt(r1_w_4);
                    r5_xyz_5 = ((r2_w_1.xxxx * r5_xyz_4.xyzx)).xyz;
                    r1_w_5 = mad(r1_w_4, cb1_values[r0_w_4 + 23].z, 1);
                    r1_w_6 = ((float4(1, 1, 1, 1) / r1_w_5)).w;
                    r2_w_2 = dot(r5_xyz_5.xyzx, cb1_values[r0_w_4 + 31].xyzx);
                    r2_w_3 = max(r2_w_2, 0);
                    r2_w_4 = (r2_w_3 + -cb1_values[r0_w_4 + 23].x);
                    r2_w_5 = saturate((r2_w_4 * cb1_values[r0_w_4 + 23].y));
                    r1_w_7 = (r1_w_6 * r2_w_5);
                    r2_w_6 = dot(r0_xyz_6.xyzx, r5_xyz_5.xyzx);
                    r2_w_7 = max(r2_w_6, 0);
                    r1_w_8 = (r1_w_7 * r2_w_7);
                    r0_w_5 = (r0_w_4 + 1);
                    r0_w_4 = r0_w_5;
                    r2_xyz_6 = (mad(cb1_values[r0_w_4 + 7].xyzx, r1_w_8.xxxx, r2_xyz_6.xyzx)).xyz;
                }
                o.color0.xyz = r2_xyz_6.xyz;
                o.sv_Position0.xyzw = clipPos_xyzw_4;
                o.color0.w = 1;
                o.texcoord1.x = clipPos_xyzw_4.z;
                return o;
            }
            #pragma fragment frag
            program113Output frag(program113Input i)
            {
                program113Output o = (program113Output)0;
                float r0_x_5 = saturate(mad(max((((i.texcoord1.x / cb1_values[5].y) + 1) * cb1_values[5].z), 0), cb2_values[1].z, cb2_values[1].w));
                float4 r1_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_2 = (r1_xyzw_1 * _Color);
                float3 r0_yzw_1 = (mad(r1_xyzw_2.xxyz, i.color0.xxyz, -cb2_values[0].xxyz)).yzw;
                o.sv_Target0.w = (r1_xyzw_2.w * i.color0.w);
                o.sv_Target0.xyz = (mad(r0_x_5.xxxx, r0_yzw_1.xyzx, cb2_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Diffuse"
}
