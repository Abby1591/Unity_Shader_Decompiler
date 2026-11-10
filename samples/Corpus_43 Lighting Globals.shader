Shader "Corpus/43 Lighting Globals"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "" {}
        _Smoothness ("Smoothness", Range(0, 1)) = 0.5
        _Specular ("Specular", Range(0, 1)) = 0.5
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
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
                float _Smoothness : packoffset(c6.x);
                float _Specular : packoffset(c6.y);
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
            cbuffer _UnityPerFrameCB_b3
            {
                float4 unity_AmbientSky : packoffset(c1);
                float4 unity_AmbientEquator : packoffset(c2);
                float4 unity_AmbientGround : packoffset(c3);
            };
            cbuffer _UnityReflectionProbesCB_b4
            {
                float4 unity_SpecCube0_BoxMax : packoffset(c0);
                float4 unity_SpecCube0_BoxMin : packoffset(c1);
                float4 unity_SpecCube0_ProbePosition : packoffset(c2);
                float4 unity_SpecCube0_HDR : packoffset(c3);
            };
            cbuffer _UnityProbeVolumeCB_b5
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
            TextureCube t1;
            Texture3D t2;
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
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_2 = normalize(viewDir_xyz_1);
                float r2_w_3 = dot(_WorldSpaceLightPos0.xyzx, _WorldSpaceLightPos0.xyzx);
                float r2_w_4 = rsqrt(r2_w_3);
                float3 lightDir_xyz_1 = ((r2_w_4.xxxx * _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r4_xyz_1 = (mad(_WorldSpaceLightPos0.xyzx, r2_w_4.xxxx, unitViewDir_xyz_2.xyzx)).xyz;
                float r2_w_5 = dot(r4_xyz_1.xyzx, r4_xyz_1.xyzx);
                float r2_w_6 = rsqrt(r2_w_5);
                float r2_w_7 = (unity_ProbeVolumeParams.x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r2_w_7)
                {
                    float r2_w_8 = (unity_ProbeVolumeParams.y == 1);
                    float3 r5_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r2_w_8.xxxx ? r5_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r5_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r2_w_9 = mad(r5_y_8, 0.25, 0.75);
                    float r3_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r5_x_8 = max(r2_w_9, r3_w_1);
                    float4 r5_xyzw_9 = t2.Sample(sampler_linear_clamp1, (float4(r5_x_8, r5_z_8, r5_w_2, r5_x_8)).xyz);
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
                float r2_w_11 = saturate(dot(float4(r5_x_10, r5_y_10, r5_z_10, r5_w_4), unity_OcclusionMaskSelector));
                float r1_w_1 = 1;
                float r6_x_1 = dot(unity_SHAr, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r6_y_1 = dot(unity_SHAg, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r6_z_1 = dot(unity_SHAb, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float4 r7_xyzw_1 = (float4(unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1, unitWorldNormal_x_3) * float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1));
                float r8_x_1 = dot(unity_SHBr, r7_xyzw_1);
                float r8_y_1 = dot(unity_SHBg, r7_xyzw_1);
                float r8_z_1 = dot(unity_SHBb, r7_xyzw_1);
                float r1_w_2 = (unitWorldNormal_y_1 * unitWorldNormal_y_1);
                float r1_w_3 = mad(unitWorldNormal_x_3, unitWorldNormal_x_3, -r1_w_2);
                float3 r6_xyz_2 = ((float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1) + (mad(unity_SHC.xyzx, r1_w_3.xxxx, float4(r8_x_1, r8_y_1, r8_z_1, r8_x_1))).xyzx)).xyz;
                float3 r5_xyz_14 = (((mad(unity_AmbientGround.xyzx, float4(0.25, 0.25, 0.25, 0), (mad(unity_AmbientSky.xyzx, float4(0.5, 0.5, 0.5, 0), ((unity_AmbientEquator.xyzx * float4(0.25, 0.25, 0.25, 0))).xyzx)).xyzx)).xyzx + r6_xyz_2.xyzx)).xyz;
                float4 r6_xyzw_3 = (-i.texcoord2.xxxx + unity_4LightPosX0);
                float4 r7_xyzw_3 = (-i.texcoord2.yyyy + unity_4LightPosY0);
                float4 r8_xyzw_2 = (-i.texcoord2.zzzz + unity_4LightPosZ0);
                float4 r9_xyzw_4 = max(mad(r8_xyzw_2, r8_xyzw_2, mad(r6_xyzw_3, r6_xyzw_3, (r7_xyzw_3 * r7_xyzw_3))), float4(1E-06, 1E-06, 1E-06, 1E-06));
                float4 r7_xyzw_4 = (unitWorldNormal_y_1.xxxx * r7_xyzw_3);
                float4 r6_xyzw_4 = mad(r6_xyzw_3, unitWorldNormal_x_3.xxxx, r7_xyzw_4);
                float4 r6_xyzw_5 = mad(r8_xyzw_2, unitWorldNormal_z_1.xxxx, r6_xyzw_4);
                float4 r7_xyzw_5 = rsqrt(r9_xyzw_4);
                float4 r6_xyzw_6 = (r6_xyzw_5 * r7_xyzw_5);
                float4 r6_xyzw_7 = max(r6_xyzw_6, float4(0, 0, 0, 0));
                float4 r7_xyzw_6 = mad(r9_xyzw_4, unity_4LightAtten0, float4(1, 1, 1, 1));
                float4 r7_xyzw_7 = (float4(1, 1, 1, 1) / r7_xyzw_6);
                float4 r6_xyzw_8 = (r6_xyzw_7 * r7_xyzw_7);
                float3 r6_xyz_10 = (mad(cb2_values[10].xyzx, r6_xyzw_8.wwww, (mad(cb2_values[9].xyzx, r6_xyzw_8.zzzz, (mad(cb2_values[7].xyzx, r6_xyzw_8.xxxx, ((r6_xyzw_8.yyyy * cb2_values[8].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                float r1_w_4 = saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx));
                float r3_y_2 = mad(_Smoothness, 120, 8);
                float r3_y_3 = dot(-unitViewDir_xyz_2.xyzx, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3));
                float r3_y_4 = (r3_y_3 + r3_y_3);
                float4 r1_xyzw_4 = mad(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), -r3_y_4.xxxx, -unitViewDir_xyz_2.xyzx);
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_2 = r1_xyzw_4.y;
                float r1_z_2 = r1_xyzw_4.z;
                float4 r4_xyzw_3 = t1.Sample(sampler_linear_clamp, (float4(r1_x_4, r1_y_2, r1_z_2, r1_x_4)).xyz);
                                float4 r2_xyzw_9 = (r4_xyzw_3.xyzx * ((pow(mad(unity_SpecCube0_HDR.w, (r4_xyzw_3.w + -1), 1), unity_SpecCube0_HDR.y) * unity_SpecCube0_HDR.x)).xxxx);
                float r2_x_9 = r2_xyzw_9.x;
                float r2_y_3 = r2_xyzw_9.y;
                float r2_z_3 = r2_xyzw_9.z;
                float4 r3_xyzw_5 = (unity_ProbeVolumeParams.xxyz + unity_ProbeVolumeMin.xxyz);
                float r3_y_5 = r3_xyzw_5.y;
                float r3_z_2 = r3_xyzw_5.z;
                float r3_w_3 = r3_xyzw_5.w;
                float4 r3_xyzw_6 = (float4(r3_y_5, r3_y_5, r3_z_2, r3_w_3) + unity_ProbeVolumeSizeInv.xxyz);
                float r3_y_6 = r3_xyzw_6.y;
                float r3_z_3 = r3_xyzw_6.z;
                float r3_w_4 = r3_xyzw_6.w;
                float r4_x_4 = unity_ProbeVolumeWorldToObject[0].x;
                float r4_y_4 = unity_ProbeVolumeWorldToObject[1].x;
                float r4_z_4 = unity_ProbeVolumeWorldToObject[2].x;
                float4 r3_xyzw_7 = (float4(r3_y_6, r3_y_6, r3_z_3, r3_w_4) + float4(r4_x_4, r4_x_4, r4_y_4, r4_z_4));
                float r3_y_7 = r3_xyzw_7.y;
                float r3_z_4 = r3_xyzw_7.z;
                float r3_w_5 = r3_xyzw_7.w;
                                float3 r5_xyz_16 = ((((pow(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r2_w_6.xxxx * r4_xyz_1.xyzx)).xyzx)), r3_y_2) * _Specular)).xxxx * _LightColor0.xyzx)).xyz;
                float3 r5_xyz_17 = ((r2_w_11.xxxx * r5_xyz_16.xyzx)).xyz;
                float3 r0_xyz_3 = (mad(r0_xyzw_2.xyzx, (mad(((r1_w_4.xxxx * _LightColor0.xyzx)).xyzx, r2_w_11.xxxx, ((r5_xyz_14.xyzx + r6_xyz_10.xyzx)).xyzx)).xyzx, r5_xyz_17.xyzx)).xyz;
                float4 r2_xyzw_10 = (float4(r2_x_9, r2_y_3, r2_z_3, r2_x_9) * _Smoothness.xxxx);
                float r2_x_10 = r2_xyzw_10.x;
                float r2_y_4 = r2_xyzw_10.y;
                float r2_z_4 = r2_xyzw_10.z;
                float4 r1_xyzw_5 = (float4(r1_x_4, r1_y_2, r1_z_2, r1_x_4) + unity_SpecCube0_ProbePosition.xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_3 = r1_xyzw_5.y;
                float r1_z_3 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = (float4(r1_x_5, r1_y_3, r1_z_3, r1_x_5) + unity_SpecCube0_BoxMax.xyzx);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_4 = r1_xyzw_6.z;
                float4 r1_xyzw_7 = (float4(r1_x_6, r1_y_4, r1_z_4, r1_x_6) + unity_SpecCube0_BoxMin.xyzx);
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_5 = r1_xyzw_7.y;
                float r1_z_5 = r1_xyzw_7.z;
                float4 r1_xyzw_8 = (float4(r3_y_7, r3_z_4, r3_w_5, r3_y_7) + float4(r1_x_7, r1_y_5, r1_z_5, r1_x_7));
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_z_6 = r1_xyzw_8.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_8, r1_y_6, r1_z_6, r1_x_8), float4(0.001, 0.001, 0.001, 0), (mad(float4(r2_x_10, r2_y_4, r2_z_4, r2_x_10), float4(0.2, 0.2, 0.2, 0), r0_xyz_3.xyzx)).xyzx)).xyz;
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
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
                float _Smoothness : packoffset(c6.x);
                float _Specular : packoffset(c6.y);
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
                float4 unity_AmbientSky;
                float4 unity_AmbientEquator;
                float4 unity_AmbientGround;
                float4 cb3_values[26];
            };
            cbuffer _UnityReflectionProbesCB_b4
            {
                float4 unity_SpecCube0_BoxMax;
                float4 unity_SpecCube0_BoxMin;
                float4 unity_SpecCube0_ProbePosition;
                float4 unity_SpecCube0_HDR;
                float4 cb4_values[12];
            };
            cbuffer _UnityProbeVolumeCB_b5
            {
                float4 unity_ProbeVolumeParams : packoffset(c0);
                float4x4 unity_ProbeVolumeWorldToObject : packoffset(c1);
                float3 unity_ProbeVolumeSizeInv : packoffset(c5);
                float3 unity_ProbeVolumeMin : packoffset(c6);
            };
            cbuffer cb6 : register(b6)
            {
                float4 cb6_values[4];
            };
            cbuffer cb7 : register(b7)
            {
                float4 cb7_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            TextureCube t2;
            Texture3D t3;
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
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float r2_w_3 = dot(_WorldSpaceLightPos0.xyzx, _WorldSpaceLightPos0.xyzx);
                float r2_w_4 = rsqrt(r2_w_3);
                float3 lightDir_xyz_1 = ((r2_w_4.xxxx * _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r5_xyz_1 = (mad(_WorldSpaceLightPos0.xyzx, r2_w_4.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r2_w_5 = dot(r5_xyz_1.xyzx, r5_xyz_1.xyzx);
                float r2_w_6 = rsqrt(r2_w_5);
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r2_x_2 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float4 r2_xyzw_2 = (i.texcoord2.xxyz + -cb3_values[25].xxyz);
                float r2_y_2 = r2_xyzw_2.y;
                float r2_z_2 = r2_xyzw_2.z;
                float r2_w_7 = r2_xyzw_2.w;
                float r2_y_3 = dot(float4(r2_y_2, r2_z_2, r2_w_7, r2_y_2), float4(r2_y_2, r2_z_2, r2_w_7, r2_y_2));
                float r2_y_4 = sqrt(r2_y_3);
                float r2_y_5 = (-r2_x_2 + r2_y_4);
                float r2_y_6 = (cb7_values[0].x == 1);
                float r6_x_9;
                float r6_y_9;
                float r6_z_9;
                float r6_w_4;
                if (r2_y_6)
                {
                    float r2_y_7 = (cb7_values[0].y == 1);
                    float3 r6_xyz_6 = (((mad(cb7_values[3].xyzx, i.texcoord2.zzzz, (mad(cb7_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb7_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb7_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (r2_y_7.xxxx ? r6_xyz_6.xxyz : i.texcoord2.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float r2_w_8 = r2_xyzw_8.w;
                    float4 r2_xyzw_9 = (float4(r2_y_8, r2_y_8, r2_z_3, r2_w_8) + -cb7_values[6].xxyz);
                    float r2_y_9 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float r2_w_9 = r2_xyzw_9.w;
                    float4 r6_xyzw_7 = (float4(r2_y_9, r2_y_9, r2_z_4, r2_w_9) * cb7_values[5].xxyz);
                    float r6_y_7 = r6_xyzw_7.y;
                    float r6_z_7 = r6_xyzw_7.z;
                    float r6_w_2 = r6_xyzw_7.w;
                    float r2_y_10 = mad(r6_y_7, 0.25, 0.75);
                    float r2_z_5 = mad(cb7_values[0].z, 0.5, 0.75);
                    float r6_x_7 = max(r2_z_5, r2_y_10);
                    float4 r6_xyzw_8 = t3.Sample(sampler_linear_clamp1, (float4(r6_x_7, r6_z_7, r6_w_2, r6_x_7)).xyz);
                    r6_x_9 = r6_xyzw_8.x;
                    r6_y_9 = r6_xyzw_8.y;
                    r6_z_9 = r6_xyzw_8.z;
                    r6_w_4 = r6_xyzw_8.w;
                }
                else
                {
                    float4 r6_xyzw_2 = float4(1, 1, 1, 1);
                    r6_x_9 = r6_xyzw_2.x;
                    r6_y_9 = r6_xyzw_2.y;
                    r6_z_9 = r6_xyzw_2.z;
                    r6_w_4 = r6_xyzw_2.w;
                }
                float r2_y_12 = saturate(dot(float4(r6_x_9, r6_y_9, r6_z_9, r6_w_4), unity_OcclusionMaskSelector));
                float4 r2_xyzw_7 = (i.texcoord5.xxxy / i.texcoord5.wwww);
                float r2_z_7 = r2_xyzw_7.z;
                float r2_w_11 = r2_xyzw_7.w;
                float4 r6_xyzw_10 = t1.Sample(sampler_linear_clamp2, (float4(r2_z_7, r2_w_11, r2_z_7, r2_z_7)).xy);
                float r2_y_13 = (r2_y_12 + -r6_xyzw_10.x);
                float r2_x_5 = mad(saturate(mad(mad(cb3_values[25].w, r2_y_5, r2_x_2), cb3_values[24].z, cb3_values[24].w)), r2_y_13, r6_xyzw_10.x);
                float4 r2_xyzw_14 = (unity_SpecCube0_ProbePosition.xxyz * float4(0, 0.25, 0.25, 0.25));
                float r2_y_14 = r2_xyzw_14.y;
                float r2_z_8 = r2_xyzw_14.z;
                float r2_w_12 = r2_xyzw_14.w;
                float4 r2_xyzw_15 = mad(unity_SpecCube0_BoxMin.xxyz, float4(0, 0.5, 0.5, 0.5), float4(r2_y_14, r2_y_14, r2_z_8, r2_w_12));
                float r2_y_15 = r2_xyzw_15.y;
                float r2_z_9 = r2_xyzw_15.z;
                float r2_w_13 = r2_xyzw_15.w;
                float4 r2_xyzw_16 = mad(unity_SpecCube0_HDR.xxyz, float4(0, 0.25, 0.25, 0.25), float4(r2_y_15, r2_y_15, r2_z_9, r2_w_13));
                float r2_y_16 = r2_xyzw_16.y;
                float r2_z_10 = r2_xyzw_16.z;
                float r2_w_14 = r2_xyzw_16.w;
                float r1_w_1 = 1;
                float r6_x_11 = dot(unity_SHAr, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r6_y_11 = dot(unity_SHAg, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r6_z_11 = dot(unity_SHAb, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float4 r7_xyzw_1 = (float4(unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1, unitWorldNormal_x_3) * float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1));
                float r8_x_1 = dot(unity_SHBr, r7_xyzw_1);
                float r8_y_1 = dot(unity_SHBg, r7_xyzw_1);
                float r8_z_1 = dot(unity_SHBb, r7_xyzw_1);
                float r1_w_2 = (unitWorldNormal_y_1 * unitWorldNormal_y_1);
                float r1_w_3 = mad(unitWorldNormal_x_3, unitWorldNormal_x_3, -r1_w_2);
                float4 r2_xyzw_17 = (float4(r2_y_16, r2_y_16, r2_z_10, r2_w_14) + ((float4(r6_x_11, r6_y_11, r6_z_11, r6_x_11) + (mad(unity_SHC.xyzx, r1_w_3.xxxx, float4(r8_x_1, r8_y_1, r8_z_1, r8_x_1))).xyzx)).xxyz);
                float r2_y_17 = r2_xyzw_17.y;
                float r2_z_11 = r2_xyzw_17.z;
                float r2_w_15 = r2_xyzw_17.w;
                float4 r6_xyzw_13 = (-i.texcoord2.xxxx + unity_4LightPosX0);
                float4 r7_xyzw_3 = (-i.texcoord2.yyyy + unity_4LightPosY0);
                float4 r8_xyzw_2 = (-i.texcoord2.zzzz + unity_4LightPosZ0);
                float4 r9_xyzw_4 = max(mad(r8_xyzw_2, r8_xyzw_2, mad(r6_xyzw_13, r6_xyzw_13, (r7_xyzw_3 * r7_xyzw_3))), float4(1E-06, 1E-06, 1E-06, 1E-06));
                float4 r7_xyzw_4 = (unitWorldNormal_y_1.xxxx * r7_xyzw_3);
                float4 r6_xyzw_14 = mad(r6_xyzw_13, unitWorldNormal_x_3.xxxx, r7_xyzw_4);
                float4 r6_xyzw_15 = mad(r8_xyzw_2, unitWorldNormal_z_1.xxxx, r6_xyzw_14);
                float4 r7_xyzw_5 = rsqrt(r9_xyzw_4);
                float4 r6_xyzw_16 = (r6_xyzw_15 * r7_xyzw_5);
                float4 r6_xyzw_17 = max(r6_xyzw_16, float4(0, 0, 0, 0));
                float4 r7_xyzw_6 = mad(r9_xyzw_4, unity_4LightAtten0, float4(1, 1, 1, 1));
                float4 r7_xyzw_7 = (float4(1, 1, 1, 1) / r7_xyzw_6);
                float4 r6_xyzw_18 = (r6_xyzw_17 * r7_xyzw_7);
                float3 r6_xyz_20 = (mad(cb2_values[10].xyzx, r6_xyzw_18.wwww, (mad(cb2_values[9].xyzx, r6_xyzw_18.zzzz, (mad(cb2_values[7].xyzx, r6_xyzw_18.xxxx, ((r6_xyzw_18.yyyy * cb2_values[8].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                float r1_w_4 = saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx));
                float r3_w_1 = saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r2_w_6.xxxx * r5_xyz_1.xyzx)).xyzx));
                float r3_w_2 = log2(r3_w_1);
                float r3_w_3 = (r3_w_2 * mad(_Smoothness, 120, 8));
                float r3_w_4 = exp2(r3_w_3);
                float r3_w_5 = (r3_w_4 * _Specular);
                float r4_x_3 = dot(-unitViewDir_xyz_1.xyzx, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3));
                float4 r1_xyzw_4 = mad(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r4_x_3 + r4_x_3)).xxxx, -unitViewDir_xyz_1.xyzx);
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_2 = r1_xyzw_4.y;
                float r1_z_2 = r1_xyzw_4.z;
                float4 r4_xyzw_5 = t2.Sample(sampler_linear_clamp, (float4(r1_x_4, r1_y_2, r1_z_2, r1_x_4)).xyz);
                                float4 r3_xyzw_8 = (r4_xyzw_5.xyzx * ((pow(mad(cb6_values[3].w, (r4_xyzw_5.w + -1), 1), cb6_values[3].y) * cb6_values[3].x)).xxxx);
                float r3_x_8 = r3_xyzw_8.x;
                float r3_y_2 = r3_xyzw_8.y;
                float r3_z_2 = r3_xyzw_8.z;
                float4 r4_xyzw_6 = (cb7_values[0].xyzx + cb7_values[6].xyzx);
                float r4_x_6 = r4_xyzw_6.x;
                float r4_y_3 = r4_xyzw_6.y;
                float r4_z_3 = r4_xyzw_6.z;
                float4 r4_xyzw_7 = (float4(r4_x_6, r4_y_3, r4_z_3, r4_x_6) + cb7_values[5].xyzx);
                float r4_x_7 = r4_xyzw_7.x;
                float r4_y_4 = r4_xyzw_7.y;
                float r4_z_4 = r4_xyzw_7.z;
                float r5_x_3 = cb7_values[1].x;
                float r5_y_3 = cb7_values[2].x;
                float r5_z_3 = cb7_values[3].x;
                float4 r4_xyzw_8 = (float4(r4_x_7, r4_y_4, r4_z_4, r4_x_7) + float4(r5_x_3, r5_y_3, r5_z_3, r5_x_3));
                float r4_x_8 = r4_xyzw_8.x;
                float r4_y_5 = r4_xyzw_8.y;
                float r4_z_5 = r4_xyzw_8.z;
                float4 r2_xyzw_18 = (float4(r2_y_17, r2_y_17, r2_z_11, r2_w_15) + r6_xyz_20.xxyz);
                float r2_y_18 = r2_xyzw_18.y;
                float r2_z_12 = r2_xyzw_18.z;
                float r2_w_16 = r2_xyzw_18.w;
                float4 r2_xyzw_19 = mad(((r1_w_4.xxxx * _LightColor0.xyzx)).xxyz, r2_x_5.xxxx, float4(r2_y_18, r2_y_18, r2_z_12, r2_w_16));
                float r2_y_19 = r2_xyzw_19.y;
                float r2_z_13 = r2_xyzw_19.z;
                float r2_w_17 = r2_xyzw_19.w;
                float4 r2_xyzw_6 = (float4(r3_x_8, r3_y_2, r3_z_2, r3_x_8) * _Smoothness.xxxx);
                float r2_x_6 = r2_xyzw_6.x;
                float r2_y_20 = r2_xyzw_6.y;
                float r2_z_14 = r2_xyzw_6.z;
                float3 r0_xyz_4 = (mad(float4(r2_x_6, r2_y_20, r2_z_14, r2_x_6), float4(0.2, 0.2, 0.2, 0), (mad(r0_xyzw_2.xyzx, float4(r2_y_19, r2_z_13, r2_w_17, r2_y_19), ((r2_x_5.xxxx * ((r3_w_5.xxxx * _LightColor0.xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                float4 r1_xyzw_5 = (float4(r1_x_4, r1_y_2, r1_z_2, r1_x_4) + cb6_values[2].xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_3 = r1_xyzw_5.y;
                float r1_z_3 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = (float4(r1_x_5, r1_y_3, r1_z_3, r1_x_5) + cb6_values[0].xyzx);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_4 = r1_xyzw_6.z;
                float4 r1_xyzw_7 = (float4(r1_x_6, r1_y_4, r1_z_4, r1_x_6) + cb6_values[1].xyzx);
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_5 = r1_xyzw_7.y;
                float r1_z_5 = r1_xyzw_7.z;
                float4 r1_xyzw_8 = (float4(r4_x_8, r4_y_5, r4_z_5, r4_x_8) + float4(r1_x_7, r1_y_5, r1_z_5, r1_x_7));
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_z_6 = r1_xyzw_8.z;
                float3 r0_xyz_5 = (mad(float4(r1_x_8, r1_y_6, r1_z_6, r1_x_8), float4(0.001, 0.001, 0.001, 0), r0_xyz_4.xyzx)).xyz;
                float r1_y_7 = ((-r0_xyz_5.xxyz + unity_ProbeVolumeParams.xxyz)).y;
                float r1_z_7 = ((-r0_xyz_5.xxyz + unity_ProbeVolumeParams.xxyz)).z;
                float r1_w_5 = ((-r0_xyz_5.xxyz + unity_ProbeVolumeParams.xxyz)).w;
                float r1_x_14 = saturate(mad(max((((i.texcoord3.x / cb1_values[5].y) + 1) * cb1_values[5].z), 0), unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w));
                o.sv_Target0.xyz = (mad(r1_x_14.xxxx, (((mad((saturate(mad(unity_ProbeVolumeWorldToObject[0].x, i.texcoord3.x, unity_ProbeVolumeWorldToObject[0].y))).xxxx, float4(r1_y_7, r1_z_7, r1_w_5, r1_y_7), r0_xyz_5.xyzx)).xyzx + -unity_ProbeVolumeParams.xyzx)).xyzx, unity_ProbeVolumeParams.xyzx)).xyz;
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
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
                float _Smoothness : packoffset(c6.x);
                float _Specular : packoffset(c6.y);
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
                float4 unity_AmbientSky;
                float4 unity_AmbientEquator;
                float4 unity_AmbientGround;
                float4 cb3_values[21];
            };
            cbuffer _UnityReflectionProbesCB_b4
            {
                float4 unity_SpecCube0_BoxMax : packoffset(c0);
                float4 unity_SpecCube0_BoxMin : packoffset(c1);
                float4 unity_SpecCube0_ProbePosition : packoffset(c2);
                float4 unity_SpecCube0_HDR : packoffset(c3);
            };
            cbuffer _UnityProbeVolumeCB_b5
            {
                float4 unity_ProbeVolumeParams : packoffset(c0);
                float4x4 unity_ProbeVolumeWorldToObject : packoffset(c1);
                float3 unity_ProbeVolumeSizeInv : packoffset(c5);
                float3 unity_ProbeVolumeMin : packoffset(c6);
            };
            cbuffer cb6 : register(b6)
            {
                float4 cb6_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            TextureCube t1;
            Texture3D t2;
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
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_2 = normalize(viewDir_xyz_1);
                float r2_w_3 = dot(_WorldSpaceLightPos0.xyzx, _WorldSpaceLightPos0.xyzx);
                float r2_w_4 = rsqrt(r2_w_3);
                float3 lightDir_xyz_1 = ((r2_w_4.xxxx * _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r4_xyz_1 = (mad(_WorldSpaceLightPos0.xyzx, r2_w_4.xxxx, unitViewDir_xyz_2.xyzx)).xyz;
                float r2_w_5 = dot(r4_xyz_1.xyzx, r4_xyz_1.xyzx);
                float r2_w_6 = rsqrt(r2_w_5);
                float r2_w_7 = (cb6_values[0].x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r2_w_7)
                {
                    float r2_w_8 = (cb6_values[0].y == 1);
                    float3 r5_xyz_5 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r5_xyzw_8 = (((((r2_w_8.xxxx ? r5_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r2_w_9 = mad(r5_y_8, 0.25, 0.75);
                    float r3_w_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r5_x_8 = max(r2_w_9, r3_w_1);
                    float4 r5_xyzw_9 = t2.Sample(sampler_linear_clamp1, (float4(r5_x_8, r5_z_8, r5_w_2, r5_x_8)).xyz);
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
                float r2_w_11 = saturate(dot(float4(r5_x_10, r5_y_10, r5_z_10, r5_w_4), unity_OcclusionMaskSelector));
                float r1_w_1 = 1;
                float r6_x_1 = dot(unity_SHAr, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r6_y_1 = dot(unity_SHAg, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r6_z_1 = dot(unity_SHAb, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float4 r7_xyzw_1 = (float4(unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1, unitWorldNormal_x_3) * float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1));
                float r8_x_1 = dot(unity_SHBr, r7_xyzw_1);
                float r8_y_1 = dot(unity_SHBg, r7_xyzw_1);
                float r8_z_1 = dot(unity_SHBb, r7_xyzw_1);
                float r1_w_2 = (unitWorldNormal_y_1 * unitWorldNormal_y_1);
                float r1_w_3 = mad(unitWorldNormal_x_3, unitWorldNormal_x_3, -r1_w_2);
                float3 r6_xyz_2 = ((float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1) + (mad(unity_SHC.xyzx, r1_w_3.xxxx, float4(r8_x_1, r8_y_1, r8_z_1, r8_x_1))).xyzx)).xyz;
                float3 r5_xyz_14 = (((mad(unity_AmbientGround.xyzx, float4(0.25, 0.25, 0.25, 0), (mad(unity_AmbientSky.xyzx, float4(0.5, 0.5, 0.5, 0), ((unity_AmbientEquator.xyzx * float4(0.25, 0.25, 0.25, 0))).xyzx)).xyzx)).xyzx + r6_xyz_2.xyzx)).xyz;
                float4 r6_xyzw_3 = (-i.texcoord2.xxxx + unity_4LightPosX0);
                float4 r7_xyzw_3 = (-i.texcoord2.yyyy + unity_4LightPosY0);
                float4 r8_xyzw_2 = (-i.texcoord2.zzzz + unity_4LightPosZ0);
                float4 r9_xyzw_4 = max(mad(r8_xyzw_2, r8_xyzw_2, mad(r6_xyzw_3, r6_xyzw_3, (r7_xyzw_3 * r7_xyzw_3))), float4(1E-06, 1E-06, 1E-06, 1E-06));
                float4 r7_xyzw_4 = (unitWorldNormal_y_1.xxxx * r7_xyzw_3);
                float4 r6_xyzw_4 = mad(r6_xyzw_3, unitWorldNormal_x_3.xxxx, r7_xyzw_4);
                float4 r6_xyzw_5 = mad(r8_xyzw_2, unitWorldNormal_z_1.xxxx, r6_xyzw_4);
                float4 r7_xyzw_5 = rsqrt(r9_xyzw_4);
                float4 r6_xyzw_6 = (r6_xyzw_5 * r7_xyzw_5);
                float4 r6_xyzw_7 = max(r6_xyzw_6, float4(0, 0, 0, 0));
                float4 r7_xyzw_6 = mad(r9_xyzw_4, unity_4LightAtten0, float4(1, 1, 1, 1));
                float4 r7_xyzw_7 = (float4(1, 1, 1, 1) / r7_xyzw_6);
                float4 r6_xyzw_8 = (r6_xyzw_7 * r7_xyzw_7);
                float3 r6_xyz_10 = (mad(cb2_values[10].xyzx, r6_xyzw_8.wwww, (mad(cb2_values[9].xyzx, r6_xyzw_8.zzzz, (mad(cb2_values[7].xyzx, r6_xyzw_8.xxxx, ((r6_xyzw_8.yyyy * cb2_values[8].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                float r1_w_4 = saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx));
                float r3_y_2 = mad(_Smoothness, 120, 8);
                float r3_y_3 = dot(-unitViewDir_xyz_2.xyzx, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3));
                float r3_y_4 = (r3_y_3 + r3_y_3);
                float4 r1_xyzw_4 = mad(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), -r3_y_4.xxxx, -unitViewDir_xyz_2.xyzx);
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_2 = r1_xyzw_4.y;
                float r1_z_2 = r1_xyzw_4.z;
                float4 r4_xyzw_3 = t1.Sample(sampler_linear_clamp, (float4(r1_x_4, r1_y_2, r1_z_2, r1_x_4)).xyz);
                                float4 r2_xyzw_9 = (r4_xyzw_3.xyzx * ((pow(mad(unity_ProbeVolumeWorldToObject[2].w, (r4_xyzw_3.w + -1), 1), unity_ProbeVolumeWorldToObject[2].y) * unity_ProbeVolumeWorldToObject[2].x)).xxxx);
                float r2_x_9 = r2_xyzw_9.x;
                float r2_y_3 = r2_xyzw_9.y;
                float r2_z_3 = r2_xyzw_9.z;
                float4 r3_xyzw_5 = (cb6_values[0].xxyz + cb6_values[6].xxyz);
                float r3_y_5 = r3_xyzw_5.y;
                float r3_z_2 = r3_xyzw_5.z;
                float r3_w_3 = r3_xyzw_5.w;
                float4 r3_xyzw_6 = (float4(r3_y_5, r3_y_5, r3_z_2, r3_w_3) + cb6_values[5].xxyz);
                float r3_y_6 = r3_xyzw_6.y;
                float r3_z_3 = r3_xyzw_6.z;
                float r3_w_4 = r3_xyzw_6.w;
                float r4_x_4 = cb6_values[1].x;
                float r4_y_4 = cb6_values[2].x;
                float r4_z_4 = cb6_values[3].x;
                float4 r3_xyzw_7 = (float4(r3_y_6, r3_y_6, r3_z_3, r3_w_4) + float4(r4_x_4, r4_x_4, r4_y_4, r4_z_4));
                float r3_y_7 = r3_xyzw_7.y;
                float r3_z_4 = r3_xyzw_7.z;
                float r3_w_5 = r3_xyzw_7.w;
                                float3 r5_xyz_16 = ((((pow(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r2_w_6.xxxx * r4_xyz_1.xyzx)).xyzx)), r3_y_2) * _Specular)).xxxx * _LightColor0.xyzx)).xyz;
                float3 r5_xyz_17 = ((r2_w_11.xxxx * r5_xyz_16.xyzx)).xyz;
                float3 r0_xyz_3 = (mad(r0_xyzw_2.xyzx, (mad(((r1_w_4.xxxx * _LightColor0.xyzx)).xyzx, r2_w_11.xxxx, ((r5_xyz_14.xyzx + r6_xyz_10.xyzx)).xyzx)).xyzx, r5_xyz_17.xyzx)).xyz;
                float4 r2_xyzw_10 = (float4(r2_x_9, r2_y_3, r2_z_3, r2_x_9) * _Smoothness.xxxx);
                float r2_x_10 = r2_xyzw_10.x;
                float r2_y_4 = r2_xyzw_10.y;
                float r2_z_4 = r2_xyzw_10.z;
                float4 r1_xyzw_5 = (float4(r1_x_4, r1_y_2, r1_z_2, r1_x_4) + unity_ProbeVolumeWorldToObject[1].xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_3 = r1_xyzw_5.y;
                float r1_z_3 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = (float4(r1_x_5, r1_y_3, r1_z_3, r1_x_5) + unity_ProbeVolumeParams.xyzx);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_4 = r1_xyzw_6.z;
                float4 r1_xyzw_7 = (float4(r1_x_6, r1_y_4, r1_z_4, r1_x_6) + unity_ProbeVolumeWorldToObject[0].xyzx);
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_5 = r1_xyzw_7.y;
                float r1_z_5 = r1_xyzw_7.z;
                float4 r1_xyzw_8 = (float4(r3_y_7, r3_z_4, r3_w_5, r3_y_7) + float4(r1_x_7, r1_y_5, r1_z_5, r1_x_7));
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_z_6 = r1_xyzw_8.z;
                float3 r0_xyz_5 = (mad(float4(r1_x_8, r1_y_6, r1_z_6, r1_x_8), float4(0.001, 0.001, 0.001, 0), (mad(float4(r2_x_10, r2_y_4, r2_z_4, r2_x_10), float4(0.2, 0.2, 0.2, 0), r0_xyz_3.xyzx)).xyzx)).xyz;
                float r1_y_7 = ((-r0_xyz_5.xxyz + unity_SpecCube0_BoxMax.xxyz)).y;
                float r1_z_7 = ((-r0_xyz_5.xxyz + unity_SpecCube0_BoxMax.xxyz)).z;
                float r1_w_5 = ((-r0_xyz_5.xxyz + unity_SpecCube0_BoxMax.xxyz)).w;
                float r1_x_14 = saturate(mad(max((((i.texcoord3.x / cb1_values[5].y) + 1) * cb1_values[5].z), 0), unity_SpecCube0_BoxMin.z, unity_SpecCube0_BoxMin.w));
                o.sv_Target0.xyz = (mad(r1_x_14.xxxx, (((mad((saturate(mad(unity_SpecCube0_BoxMin.x, i.texcoord3.x, unity_SpecCube0_BoxMin.y))).xxxx, float4(r1_y_7, r1_z_7, r1_w_5, r1_y_7), r0_xyz_5.xyzx)).xyzx + -unity_SpecCube0_BoxMax.xyzx)).xyzx, unity_SpecCube0_BoxMax.xyzx)).xyz;
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
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
                float _Smoothness : packoffset(c6.x);
                float _Specular : packoffset(c6.y);
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
            cbuffer _UnityPerFrameCB_b3
            {
                float4 unity_AmbientSky;
                float4 unity_AmbientEquator;
                float4 unity_AmbientGround;
                float4 cb3_values[26];
            };
            cbuffer _UnityReflectionProbesCB_b4
            {
                float4 unity_SpecCube0_BoxMax;
                float4 unity_SpecCube0_BoxMin;
                float4 unity_SpecCube0_ProbePosition;
                float4 unity_SpecCube0_HDR;
                float4 cb4_values[12];
            };
            cbuffer _UnityProbeVolumeCB_b5
            {
                float4 unity_ProbeVolumeParams : packoffset(c0);
                float4x4 unity_ProbeVolumeWorldToObject : packoffset(c1);
                float3 unity_ProbeVolumeSizeInv : packoffset(c5);
                float3 unity_ProbeVolumeMin : packoffset(c6);
            };
            cbuffer cb6 : register(b6)
            {
                float4 cb6_values[4];
            };
            cbuffer cb7 : register(b7)
            {
                float4 cb7_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            TextureCube t2;
            Texture3D t3;
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
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float r2_w_3 = dot(_WorldSpaceLightPos0.xyzx, _WorldSpaceLightPos0.xyzx);
                float r2_w_4 = rsqrt(r2_w_3);
                float3 lightDir_xyz_1 = ((r2_w_4.xxxx * _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r5_xyz_1 = (mad(_WorldSpaceLightPos0.xyzx, r2_w_4.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r2_w_5 = dot(r5_xyz_1.xyzx, r5_xyz_1.xyzx);
                float r2_w_6 = rsqrt(r2_w_5);
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r2_x_2 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float4 r2_xyzw_2 = (i.texcoord2.xxyz + -cb3_values[25].xxyz);
                float r2_y_2 = r2_xyzw_2.y;
                float r2_z_2 = r2_xyzw_2.z;
                float r2_w_7 = r2_xyzw_2.w;
                float r2_y_3 = dot(float4(r2_y_2, r2_z_2, r2_w_7, r2_y_2), float4(r2_y_2, r2_z_2, r2_w_7, r2_y_2));
                float r2_y_4 = sqrt(r2_y_3);
                float r2_y_5 = (-r2_x_2 + r2_y_4);
                float r2_y_6 = (cb7_values[0].x == 1);
                float r6_x_9;
                float r6_y_9;
                float r6_z_9;
                float r6_w_4;
                if (r2_y_6)
                {
                    float r2_y_7 = (cb7_values[0].y == 1);
                    float3 r6_xyz_6 = (((mad(cb7_values[3].xyzx, i.texcoord2.zzzz, (mad(cb7_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb7_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb7_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (r2_y_7.xxxx ? r6_xyz_6.xxyz : i.texcoord2.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float r2_w_8 = r2_xyzw_8.w;
                    float4 r2_xyzw_9 = (float4(r2_y_8, r2_y_8, r2_z_3, r2_w_8) + -cb7_values[6].xxyz);
                    float r2_y_9 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float r2_w_9 = r2_xyzw_9.w;
                    float4 r6_xyzw_7 = (float4(r2_y_9, r2_y_9, r2_z_4, r2_w_9) * cb7_values[5].xxyz);
                    float r6_y_7 = r6_xyzw_7.y;
                    float r6_z_7 = r6_xyzw_7.z;
                    float r6_w_2 = r6_xyzw_7.w;
                    float r2_y_10 = mad(r6_y_7, 0.25, 0.75);
                    float r2_z_5 = mad(cb7_values[0].z, 0.5, 0.75);
                    float r6_x_7 = max(r2_z_5, r2_y_10);
                    float4 r6_xyzw_8 = t3.Sample(sampler_linear_clamp1, (float4(r6_x_7, r6_z_7, r6_w_2, r6_x_7)).xyz);
                    r6_x_9 = r6_xyzw_8.x;
                    r6_y_9 = r6_xyzw_8.y;
                    r6_z_9 = r6_xyzw_8.z;
                    r6_w_4 = r6_xyzw_8.w;
                }
                else
                {
                    float4 r6_xyzw_2 = float4(1, 1, 1, 1);
                    r6_x_9 = r6_xyzw_2.x;
                    r6_y_9 = r6_xyzw_2.y;
                    r6_z_9 = r6_xyzw_2.z;
                    r6_w_4 = r6_xyzw_2.w;
                }
                float r2_y_12 = saturate(dot(float4(r6_x_9, r6_y_9, r6_z_9, r6_w_4), unity_OcclusionMaskSelector));
                float4 r2_xyzw_7 = (i.texcoord5.xxxy / i.texcoord5.wwww);
                float r2_z_7 = r2_xyzw_7.z;
                float r2_w_11 = r2_xyzw_7.w;
                float4 r6_xyzw_10 = t1.Sample(sampler_linear_clamp2, (float4(r2_z_7, r2_w_11, r2_z_7, r2_z_7)).xy);
                float r2_y_13 = (r2_y_12 + -r6_xyzw_10.x);
                float r2_x_5 = mad(saturate(mad(mad(cb3_values[25].w, r2_y_5, r2_x_2), cb3_values[24].z, cb3_values[24].w)), r2_y_13, r6_xyzw_10.x);
                float4 r2_xyzw_14 = (unity_SpecCube0_ProbePosition.xxyz * float4(0, 0.25, 0.25, 0.25));
                float r2_y_14 = r2_xyzw_14.y;
                float r2_z_8 = r2_xyzw_14.z;
                float r2_w_12 = r2_xyzw_14.w;
                float4 r2_xyzw_15 = mad(unity_SpecCube0_BoxMin.xxyz, float4(0, 0.5, 0.5, 0.5), float4(r2_y_14, r2_y_14, r2_z_8, r2_w_12));
                float r2_y_15 = r2_xyzw_15.y;
                float r2_z_9 = r2_xyzw_15.z;
                float r2_w_13 = r2_xyzw_15.w;
                float4 r2_xyzw_16 = mad(unity_SpecCube0_HDR.xxyz, float4(0, 0.25, 0.25, 0.25), float4(r2_y_15, r2_y_15, r2_z_9, r2_w_13));
                float r2_y_16 = r2_xyzw_16.y;
                float r2_z_10 = r2_xyzw_16.z;
                float r2_w_14 = r2_xyzw_16.w;
                float r1_w_1 = 1;
                float r6_x_11 = dot(unity_SHAr, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r6_y_11 = dot(unity_SHAg, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r6_z_11 = dot(unity_SHAb, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float4 r7_xyzw_1 = (float4(unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1, unitWorldNormal_x_3) * float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1));
                float r8_x_1 = dot(unity_SHBr, r7_xyzw_1);
                float r8_y_1 = dot(unity_SHBg, r7_xyzw_1);
                float r8_z_1 = dot(unity_SHBb, r7_xyzw_1);
                float r1_w_2 = (unitWorldNormal_y_1 * unitWorldNormal_y_1);
                float r1_w_3 = mad(unitWorldNormal_x_3, unitWorldNormal_x_3, -r1_w_2);
                float4 r2_xyzw_17 = (float4(r2_y_16, r2_y_16, r2_z_10, r2_w_14) + ((float4(r6_x_11, r6_y_11, r6_z_11, r6_x_11) + (mad(unity_SHC.xyzx, r1_w_3.xxxx, float4(r8_x_1, r8_y_1, r8_z_1, r8_x_1))).xyzx)).xxyz);
                float r2_y_17 = r2_xyzw_17.y;
                float r2_z_11 = r2_xyzw_17.z;
                float r2_w_15 = r2_xyzw_17.w;
                float4 r6_xyzw_13 = (-i.texcoord2.xxxx + unity_4LightPosX0);
                float4 r7_xyzw_3 = (-i.texcoord2.yyyy + unity_4LightPosY0);
                float4 r8_xyzw_2 = (-i.texcoord2.zzzz + unity_4LightPosZ0);
                float4 r9_xyzw_4 = max(mad(r8_xyzw_2, r8_xyzw_2, mad(r6_xyzw_13, r6_xyzw_13, (r7_xyzw_3 * r7_xyzw_3))), float4(1E-06, 1E-06, 1E-06, 1E-06));
                float4 r7_xyzw_4 = (unitWorldNormal_y_1.xxxx * r7_xyzw_3);
                float4 r6_xyzw_14 = mad(r6_xyzw_13, unitWorldNormal_x_3.xxxx, r7_xyzw_4);
                float4 r6_xyzw_15 = mad(r8_xyzw_2, unitWorldNormal_z_1.xxxx, r6_xyzw_14);
                float4 r7_xyzw_5 = rsqrt(r9_xyzw_4);
                float4 r6_xyzw_16 = (r6_xyzw_15 * r7_xyzw_5);
                float4 r6_xyzw_17 = max(r6_xyzw_16, float4(0, 0, 0, 0));
                float4 r7_xyzw_6 = mad(r9_xyzw_4, unity_4LightAtten0, float4(1, 1, 1, 1));
                float4 r7_xyzw_7 = (float4(1, 1, 1, 1) / r7_xyzw_6);
                float4 r6_xyzw_18 = (r6_xyzw_17 * r7_xyzw_7);
                float3 r6_xyz_20 = (mad(cb2_values[10].xyzx, r6_xyzw_18.wwww, (mad(cb2_values[9].xyzx, r6_xyzw_18.zzzz, (mad(cb2_values[7].xyzx, r6_xyzw_18.xxxx, ((r6_xyzw_18.yyyy * cb2_values[8].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                float r1_w_4 = saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx));
                float r3_w_1 = saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r2_w_6.xxxx * r5_xyz_1.xyzx)).xyzx));
                float r3_w_2 = log2(r3_w_1);
                float r3_w_3 = (r3_w_2 * mad(_Smoothness, 120, 8));
                float r3_w_4 = exp2(r3_w_3);
                float r3_w_5 = (r3_w_4 * _Specular);
                float r4_x_3 = dot(-unitViewDir_xyz_1.xyzx, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3));
                float4 r1_xyzw_4 = mad(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r4_x_3 + r4_x_3)).xxxx, -unitViewDir_xyz_1.xyzx);
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_2 = r1_xyzw_4.y;
                float r1_z_2 = r1_xyzw_4.z;
                float4 r4_xyzw_5 = t2.Sample(sampler_linear_clamp, (float4(r1_x_4, r1_y_2, r1_z_2, r1_x_4)).xyz);
                                float4 r3_xyzw_8 = (r4_xyzw_5.xyzx * ((pow(mad(cb6_values[3].w, (r4_xyzw_5.w + -1), 1), cb6_values[3].y) * cb6_values[3].x)).xxxx);
                float r3_x_8 = r3_xyzw_8.x;
                float r3_y_2 = r3_xyzw_8.y;
                float r3_z_2 = r3_xyzw_8.z;
                float4 r4_xyzw_6 = (cb7_values[0].xyzx + cb7_values[6].xyzx);
                float r4_x_6 = r4_xyzw_6.x;
                float r4_y_3 = r4_xyzw_6.y;
                float r4_z_3 = r4_xyzw_6.z;
                float4 r4_xyzw_7 = (float4(r4_x_6, r4_y_3, r4_z_3, r4_x_6) + cb7_values[5].xyzx);
                float r4_x_7 = r4_xyzw_7.x;
                float r4_y_4 = r4_xyzw_7.y;
                float r4_z_4 = r4_xyzw_7.z;
                float r5_x_3 = cb7_values[1].x;
                float r5_y_3 = cb7_values[2].x;
                float r5_z_3 = cb7_values[3].x;
                float4 r4_xyzw_8 = (float4(r4_x_7, r4_y_4, r4_z_4, r4_x_7) + float4(r5_x_3, r5_y_3, r5_z_3, r5_x_3));
                float r4_x_8 = r4_xyzw_8.x;
                float r4_y_5 = r4_xyzw_8.y;
                float r4_z_5 = r4_xyzw_8.z;
                float4 r2_xyzw_18 = (float4(r2_y_17, r2_y_17, r2_z_11, r2_w_15) + r6_xyz_20.xxyz);
                float r2_y_18 = r2_xyzw_18.y;
                float r2_z_12 = r2_xyzw_18.z;
                float r2_w_16 = r2_xyzw_18.w;
                float4 r2_xyzw_19 = mad(((r1_w_4.xxxx * _LightColor0.xyzx)).xxyz, r2_x_5.xxxx, float4(r2_y_18, r2_y_18, r2_z_12, r2_w_16));
                float r2_y_19 = r2_xyzw_19.y;
                float r2_z_13 = r2_xyzw_19.z;
                float r2_w_17 = r2_xyzw_19.w;
                float4 r2_xyzw_6 = (float4(r3_x_8, r3_y_2, r3_z_2, r3_x_8) * _Smoothness.xxxx);
                float r2_x_6 = r2_xyzw_6.x;
                float r2_y_20 = r2_xyzw_6.y;
                float r2_z_14 = r2_xyzw_6.z;
                float3 r0_xyz_4 = (mad(float4(r2_x_6, r2_y_20, r2_z_14, r2_x_6), float4(0.2, 0.2, 0.2, 0), (mad(r0_xyzw_2.xyzx, float4(r2_y_19, r2_z_13, r2_w_17, r2_y_19), ((r2_x_5.xxxx * ((r3_w_5.xxxx * _LightColor0.xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                float4 r1_xyzw_5 = (float4(r1_x_4, r1_y_2, r1_z_2, r1_x_4) + cb6_values[2].xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_3 = r1_xyzw_5.y;
                float r1_z_3 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = (float4(r1_x_5, r1_y_3, r1_z_3, r1_x_5) + cb6_values[0].xyzx);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_4 = r1_xyzw_6.z;
                float4 r1_xyzw_7 = (float4(r1_x_6, r1_y_4, r1_z_4, r1_x_6) + cb6_values[1].xyzx);
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_5 = r1_xyzw_7.y;
                float r1_z_5 = r1_xyzw_7.z;
                float4 r1_xyzw_8 = (float4(r4_x_8, r4_y_5, r4_z_5, r4_x_8) + float4(r1_x_7, r1_y_5, r1_z_5, r1_x_7));
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_z_6 = r1_xyzw_8.z;
                float3 r0_xyz_5 = (mad(float4(r1_x_8, r1_y_6, r1_z_6, r1_x_8), float4(0.001, 0.001, 0.001, 0), r0_xyz_4.xyzx)).xyz;
                float r1_y_7 = ((-r0_xyz_5.xxyz + unity_ProbeVolumeParams.xxyz)).y;
                float r1_z_7 = ((-r0_xyz_5.xxyz + unity_ProbeVolumeParams.xxyz)).z;
                float r1_w_5 = ((-r0_xyz_5.xxyz + unity_ProbeVolumeParams.xxyz)).w;
                float r1_x_14 = saturate(mad(max((((i.texcoord3.x / cb1_values[5].y) + 1) * cb1_values[5].z), 0), unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w));
                o.sv_Target0.xyz = (mad(r1_x_14.xxxx, (((mad((saturate(mad(unity_ProbeVolumeWorldToObject[0].x, i.texcoord3.x, unity_ProbeVolumeWorldToObject[0].y))).xxxx, float4(r1_y_7, r1_z_7, r1_w_5, r1_y_7), r0_xyz_5.xyzx)).xyzx + -unity_ProbeVolumeParams.xyzx)).xyzx, unity_ProbeVolumeParams.xyzx)).xyz;
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
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
                float _Smoothness : packoffset(c6.x);
                float _Specular : packoffset(c6.y);
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
            cbuffer _UnityPerFrameCB_b3
            {
                float4 unity_AmbientSky : packoffset(c1);
                float4 unity_AmbientEquator : packoffset(c2);
                float4 unity_AmbientGround : packoffset(c3);
            };
            cbuffer _UnityReflectionProbesCB_b4
            {
                float4 unity_SpecCube0_BoxMax : packoffset(c0);
                float4 unity_SpecCube0_BoxMin : packoffset(c1);
                float4 unity_SpecCube0_ProbePosition : packoffset(c2);
                float4 unity_SpecCube0_HDR : packoffset(c3);
            };
            cbuffer _UnityProbeVolumeCB_b5
            {
                float4 unity_ProbeVolumeParams : packoffset(c0);
                float4x4 unity_ProbeVolumeWorldToObject : packoffset(c1);
                float3 unity_ProbeVolumeSizeInv : packoffset(c5);
                float3 unity_ProbeVolumeMin : packoffset(c6);
            };
            cbuffer cb6 : register(b6)
            {
                float4 cb6_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            TextureCube t1;
            Texture3D t2;
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
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_2 = normalize(viewDir_xyz_1);
                float r2_w_3 = dot(_WorldSpaceLightPos0.xyzx, _WorldSpaceLightPos0.xyzx);
                float r2_w_4 = rsqrt(r2_w_3);
                float3 lightDir_xyz_1 = ((r2_w_4.xxxx * _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r4_xyz_1 = (mad(_WorldSpaceLightPos0.xyzx, r2_w_4.xxxx, unitViewDir_xyz_2.xyzx)).xyz;
                float r2_w_5 = dot(r4_xyz_1.xyzx, r4_xyz_1.xyzx);
                float r2_w_6 = rsqrt(r2_w_5);
                float r2_w_7 = (cb6_values[0].x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r2_w_7)
                {
                    float r2_w_8 = (cb6_values[0].y == 1);
                    float3 r5_xyz_5 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r5_xyzw_8 = (((((r2_w_8.xxxx ? r5_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r2_w_9 = mad(r5_y_8, 0.25, 0.75);
                    float r3_w_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r5_x_8 = max(r2_w_9, r3_w_1);
                    float4 r5_xyzw_9 = t2.Sample(sampler_linear_clamp1, (float4(r5_x_8, r5_z_8, r5_w_2, r5_x_8)).xyz);
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
                float r2_w_11 = saturate(dot(float4(r5_x_10, r5_y_10, r5_z_10, r5_w_4), unity_OcclusionMaskSelector));
                float r1_w_1 = 1;
                float r6_x_1 = dot(unity_SHAr, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r6_y_1 = dot(unity_SHAg, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r6_z_1 = dot(unity_SHAb, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float4 r7_xyzw_1 = (float4(unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1, unitWorldNormal_x_3) * float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1));
                float r8_x_1 = dot(unity_SHBr, r7_xyzw_1);
                float r8_y_1 = dot(unity_SHBg, r7_xyzw_1);
                float r8_z_1 = dot(unity_SHBb, r7_xyzw_1);
                float r1_w_2 = (unitWorldNormal_y_1 * unitWorldNormal_y_1);
                float r1_w_3 = mad(unitWorldNormal_x_3, unitWorldNormal_x_3, -r1_w_2);
                float3 r6_xyz_2 = ((float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1) + (mad(unity_SHC.xyzx, r1_w_3.xxxx, float4(r8_x_1, r8_y_1, r8_z_1, r8_x_1))).xyzx)).xyz;
                float3 r5_xyz_14 = (((mad(unity_AmbientGround.xyzx, float4(0.25, 0.25, 0.25, 0), (mad(unity_AmbientSky.xyzx, float4(0.5, 0.5, 0.5, 0), ((unity_AmbientEquator.xyzx * float4(0.25, 0.25, 0.25, 0))).xyzx)).xyzx)).xyzx + r6_xyz_2.xyzx)).xyz;
                float4 r6_xyzw_3 = (-i.texcoord2.xxxx + unity_4LightPosX0);
                float4 r7_xyzw_3 = (-i.texcoord2.yyyy + unity_4LightPosY0);
                float4 r8_xyzw_2 = (-i.texcoord2.zzzz + unity_4LightPosZ0);
                float4 r9_xyzw_4 = max(mad(r8_xyzw_2, r8_xyzw_2, mad(r6_xyzw_3, r6_xyzw_3, (r7_xyzw_3 * r7_xyzw_3))), float4(1E-06, 1E-06, 1E-06, 1E-06));
                float4 r7_xyzw_4 = (unitWorldNormal_y_1.xxxx * r7_xyzw_3);
                float4 r6_xyzw_4 = mad(r6_xyzw_3, unitWorldNormal_x_3.xxxx, r7_xyzw_4);
                float4 r6_xyzw_5 = mad(r8_xyzw_2, unitWorldNormal_z_1.xxxx, r6_xyzw_4);
                float4 r7_xyzw_5 = rsqrt(r9_xyzw_4);
                float4 r6_xyzw_6 = (r6_xyzw_5 * r7_xyzw_5);
                float4 r6_xyzw_7 = max(r6_xyzw_6, float4(0, 0, 0, 0));
                float4 r7_xyzw_6 = mad(r9_xyzw_4, unity_4LightAtten0, float4(1, 1, 1, 1));
                float4 r7_xyzw_7 = (float4(1, 1, 1, 1) / r7_xyzw_6);
                float4 r6_xyzw_8 = (r6_xyzw_7 * r7_xyzw_7);
                float3 r6_xyz_10 = (mad(cb2_values[10].xyzx, r6_xyzw_8.wwww, (mad(cb2_values[9].xyzx, r6_xyzw_8.zzzz, (mad(cb2_values[7].xyzx, r6_xyzw_8.xxxx, ((r6_xyzw_8.yyyy * cb2_values[8].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                float r1_w_4 = saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx));
                float r3_y_2 = mad(_Smoothness, 120, 8);
                float r3_y_3 = dot(-unitViewDir_xyz_2.xyzx, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3));
                float r3_y_4 = (r3_y_3 + r3_y_3);
                float4 r1_xyzw_4 = mad(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), -r3_y_4.xxxx, -unitViewDir_xyz_2.xyzx);
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_2 = r1_xyzw_4.y;
                float r1_z_2 = r1_xyzw_4.z;
                float4 r4_xyzw_3 = t1.Sample(sampler_linear_clamp, (float4(r1_x_4, r1_y_2, r1_z_2, r1_x_4)).xyz);
                                float4 r2_xyzw_9 = (r4_xyzw_3.xyzx * ((pow(mad(unity_ProbeVolumeWorldToObject[2].w, (r4_xyzw_3.w + -1), 1), unity_ProbeVolumeWorldToObject[2].y) * unity_ProbeVolumeWorldToObject[2].x)).xxxx);
                float r2_x_9 = r2_xyzw_9.x;
                float r2_y_3 = r2_xyzw_9.y;
                float r2_z_3 = r2_xyzw_9.z;
                float4 r3_xyzw_5 = (cb6_values[0].xxyz + cb6_values[6].xxyz);
                float r3_y_5 = r3_xyzw_5.y;
                float r3_z_2 = r3_xyzw_5.z;
                float r3_w_3 = r3_xyzw_5.w;
                float4 r3_xyzw_6 = (float4(r3_y_5, r3_y_5, r3_z_2, r3_w_3) + cb6_values[5].xxyz);
                float r3_y_6 = r3_xyzw_6.y;
                float r3_z_3 = r3_xyzw_6.z;
                float r3_w_4 = r3_xyzw_6.w;
                float r4_x_4 = cb6_values[1].x;
                float r4_y_4 = cb6_values[2].x;
                float r4_z_4 = cb6_values[3].x;
                float4 r3_xyzw_7 = (float4(r3_y_6, r3_y_6, r3_z_3, r3_w_4) + float4(r4_x_4, r4_x_4, r4_y_4, r4_z_4));
                float r3_y_7 = r3_xyzw_7.y;
                float r3_z_4 = r3_xyzw_7.z;
                float r3_w_5 = r3_xyzw_7.w;
                                float3 r5_xyz_16 = ((((pow(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r2_w_6.xxxx * r4_xyz_1.xyzx)).xyzx)), r3_y_2) * _Specular)).xxxx * _LightColor0.xyzx)).xyz;
                float3 r5_xyz_17 = ((r2_w_11.xxxx * r5_xyz_16.xyzx)).xyz;
                float3 r0_xyz_3 = (mad(r0_xyzw_2.xyzx, (mad(((r1_w_4.xxxx * _LightColor0.xyzx)).xyzx, r2_w_11.xxxx, ((r5_xyz_14.xyzx + r6_xyz_10.xyzx)).xyzx)).xyzx, r5_xyz_17.xyzx)).xyz;
                float4 r2_xyzw_10 = (float4(r2_x_9, r2_y_3, r2_z_3, r2_x_9) * _Smoothness.xxxx);
                float r2_x_10 = r2_xyzw_10.x;
                float r2_y_4 = r2_xyzw_10.y;
                float r2_z_4 = r2_xyzw_10.z;
                float4 r1_xyzw_5 = (float4(r1_x_4, r1_y_2, r1_z_2, r1_x_4) + unity_ProbeVolumeWorldToObject[1].xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_3 = r1_xyzw_5.y;
                float r1_z_3 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = (float4(r1_x_5, r1_y_3, r1_z_3, r1_x_5) + unity_ProbeVolumeParams.xyzx);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_4 = r1_xyzw_6.z;
                float4 r1_xyzw_7 = (float4(r1_x_6, r1_y_4, r1_z_4, r1_x_6) + unity_ProbeVolumeWorldToObject[0].xyzx);
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_5 = r1_xyzw_7.y;
                float r1_z_5 = r1_xyzw_7.z;
                float4 r1_xyzw_8 = (float4(r3_y_7, r3_z_4, r3_w_5, r3_y_7) + float4(r1_x_7, r1_y_5, r1_z_5, r1_x_7));
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_z_6 = r1_xyzw_8.z;
                float3 r0_xyz_5 = (mad(float4(r1_x_8, r1_y_6, r1_z_6, r1_x_8), float4(0.001, 0.001, 0.001, 0), (mad(float4(r2_x_10, r2_y_4, r2_z_4, r2_x_10), float4(0.2, 0.2, 0.2, 0), r0_xyz_3.xyzx)).xyzx)).xyz;
                float r1_y_7 = ((-r0_xyz_5.xxyz + unity_SpecCube0_BoxMax.xxyz)).y;
                float r1_z_7 = ((-r0_xyz_5.xxyz + unity_SpecCube0_BoxMax.xxyz)).z;
                float r1_w_5 = ((-r0_xyz_5.xxyz + unity_SpecCube0_BoxMax.xxyz)).w;
                float r1_x_14 = saturate(mad(max((((i.texcoord3.x / cb1_values[5].y) + 1) * cb1_values[5].z), 0), unity_SpecCube0_BoxMin.z, unity_SpecCube0_BoxMin.w));
                o.sv_Target0.xyz = (mad(r1_x_14.xxxx, (((mad((saturate(mad(unity_SpecCube0_BoxMin.x, i.texcoord3.x, unity_SpecCube0_BoxMin.y))).xxxx, float4(r1_y_7, r1_z_7, r1_w_5, r1_y_7), r0_xyz_5.xyzx)).xyzx + -unity_SpecCube0_BoxMax.xyzx)).xyzx, unity_SpecCube0_BoxMax.xyzx)).xyz;
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
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
                float _Smoothness : packoffset(c6.x);
                float _Specular : packoffset(c6.y);
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
                float4 unity_AmbientSky;
                float4 unity_AmbientEquator;
                float4 unity_AmbientGround;
                float4 cb3_values[26];
            };
            cbuffer _UnityReflectionProbesCB_b4
            {
                float4 unity_SpecCube0_BoxMax;
                float4 unity_SpecCube0_BoxMin;
                float4 unity_SpecCube0_ProbePosition;
                float4 unity_SpecCube0_HDR;
                float4 cb4_values[12];
            };
            cbuffer _UnityProbeVolumeCB_b5
            {
                float4 unity_ProbeVolumeParams : packoffset(c0);
                float4x4 unity_ProbeVolumeWorldToObject : packoffset(c1);
                float3 unity_ProbeVolumeSizeInv : packoffset(c5);
                float3 unity_ProbeVolumeMin : packoffset(c6);
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
            TextureCube t2;
            Texture3D t3;
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
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float r2_w_3 = dot(_WorldSpaceLightPos0.xyzx, _WorldSpaceLightPos0.xyzx);
                float r2_w_4 = rsqrt(r2_w_3);
                float3 lightDir_xyz_1 = ((r2_w_4.xxxx * _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r5_xyz_1 = (mad(_WorldSpaceLightPos0.xyzx, r2_w_4.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r2_w_5 = dot(r5_xyz_1.xyzx, r5_xyz_1.xyzx);
                float r2_w_6 = rsqrt(r2_w_5);
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r2_x_2 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float4 r2_xyzw_2 = (i.texcoord2.xxyz + -cb3_values[25].xxyz);
                float r2_y_2 = r2_xyzw_2.y;
                float r2_z_2 = r2_xyzw_2.z;
                float r2_w_7 = r2_xyzw_2.w;
                float r2_y_3 = dot(float4(r2_y_2, r2_z_2, r2_w_7, r2_y_2), float4(r2_y_2, r2_z_2, r2_w_7, r2_y_2));
                float r2_y_4 = sqrt(r2_y_3);
                float r2_y_5 = (-r2_x_2 + r2_y_4);
                float r2_y_6 = (cb6_values[0].x == 1);
                float r6_x_9;
                float r6_y_9;
                float r6_z_9;
                float r6_w_4;
                if (r2_y_6)
                {
                    float r2_y_7 = (cb6_values[0].y == 1);
                    float3 r6_xyz_6 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (r2_y_7.xxxx ? r6_xyz_6.xxyz : i.texcoord2.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float r2_w_8 = r2_xyzw_8.w;
                    float4 r2_xyzw_9 = (float4(r2_y_8, r2_y_8, r2_z_3, r2_w_8) + -cb6_values[6].xxyz);
                    float r2_y_9 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float r2_w_9 = r2_xyzw_9.w;
                    float4 r6_xyzw_7 = (float4(r2_y_9, r2_y_9, r2_z_4, r2_w_9) * cb6_values[5].xxyz);
                    float r6_y_7 = r6_xyzw_7.y;
                    float r6_z_7 = r6_xyzw_7.z;
                    float r6_w_2 = r6_xyzw_7.w;
                    float r2_y_10 = mad(r6_y_7, 0.25, 0.75);
                    float r2_z_5 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r6_x_7 = max(r2_z_5, r2_y_10);
                    float4 r6_xyzw_8 = t3.Sample(sampler_linear_clamp1, (float4(r6_x_7, r6_z_7, r6_w_2, r6_x_7)).xyz);
                    r6_x_9 = r6_xyzw_8.x;
                    r6_y_9 = r6_xyzw_8.y;
                    r6_z_9 = r6_xyzw_8.z;
                    r6_w_4 = r6_xyzw_8.w;
                }
                else
                {
                    float4 r6_xyzw_2 = float4(1, 1, 1, 1);
                    r6_x_9 = r6_xyzw_2.x;
                    r6_y_9 = r6_xyzw_2.y;
                    r6_z_9 = r6_xyzw_2.z;
                    r6_w_4 = r6_xyzw_2.w;
                }
                float r2_y_12 = saturate(dot(float4(r6_x_9, r6_y_9, r6_z_9, r6_w_4), unity_OcclusionMaskSelector));
                float4 r2_xyzw_7 = (i.texcoord5.xxxy / i.texcoord5.wwww);
                float r2_z_7 = r2_xyzw_7.z;
                float r2_w_11 = r2_xyzw_7.w;
                float4 r6_xyzw_10 = t1.Sample(sampler_linear_clamp2, (float4(r2_z_7, r2_w_11, r2_z_7, r2_z_7)).xy);
                float r2_y_13 = (r2_y_12 + -r6_xyzw_10.x);
                float r2_x_5 = mad(saturate(mad(mad(cb3_values[25].w, r2_y_5, r2_x_2), cb3_values[24].z, cb3_values[24].w)), r2_y_13, r6_xyzw_10.x);
                float4 r2_xyzw_14 = (unity_SpecCube0_ProbePosition.xxyz * float4(0, 0.25, 0.25, 0.25));
                float r2_y_14 = r2_xyzw_14.y;
                float r2_z_8 = r2_xyzw_14.z;
                float r2_w_12 = r2_xyzw_14.w;
                float4 r2_xyzw_15 = mad(unity_SpecCube0_BoxMin.xxyz, float4(0, 0.5, 0.5, 0.5), float4(r2_y_14, r2_y_14, r2_z_8, r2_w_12));
                float r2_y_15 = r2_xyzw_15.y;
                float r2_z_9 = r2_xyzw_15.z;
                float r2_w_13 = r2_xyzw_15.w;
                float4 r2_xyzw_16 = mad(unity_SpecCube0_HDR.xxyz, float4(0, 0.25, 0.25, 0.25), float4(r2_y_15, r2_y_15, r2_z_9, r2_w_13));
                float r2_y_16 = r2_xyzw_16.y;
                float r2_z_10 = r2_xyzw_16.z;
                float r2_w_14 = r2_xyzw_16.w;
                float r1_w_1 = 1;
                float r6_x_11 = dot(unity_SHAr, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r6_y_11 = dot(unity_SHAg, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r6_z_11 = dot(unity_SHAb, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float4 r7_xyzw_1 = (float4(unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1, unitWorldNormal_x_3) * float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1));
                float r8_x_1 = dot(unity_SHBr, r7_xyzw_1);
                float r8_y_1 = dot(unity_SHBg, r7_xyzw_1);
                float r8_z_1 = dot(unity_SHBb, r7_xyzw_1);
                float r1_w_2 = (unitWorldNormal_y_1 * unitWorldNormal_y_1);
                float r1_w_3 = mad(unitWorldNormal_x_3, unitWorldNormal_x_3, -r1_w_2);
                float4 r2_xyzw_17 = (float4(r2_y_16, r2_y_16, r2_z_10, r2_w_14) + ((float4(r6_x_11, r6_y_11, r6_z_11, r6_x_11) + (mad(unity_SHC.xyzx, r1_w_3.xxxx, float4(r8_x_1, r8_y_1, r8_z_1, r8_x_1))).xyzx)).xxyz);
                float r2_y_17 = r2_xyzw_17.y;
                float r2_z_11 = r2_xyzw_17.z;
                float r2_w_15 = r2_xyzw_17.w;
                float4 r6_xyzw_13 = (-i.texcoord2.xxxx + unity_4LightPosX0);
                float4 r7_xyzw_3 = (-i.texcoord2.yyyy + unity_4LightPosY0);
                float4 r8_xyzw_2 = (-i.texcoord2.zzzz + unity_4LightPosZ0);
                float4 r9_xyzw_4 = max(mad(r8_xyzw_2, r8_xyzw_2, mad(r6_xyzw_13, r6_xyzw_13, (r7_xyzw_3 * r7_xyzw_3))), float4(1E-06, 1E-06, 1E-06, 1E-06));
                float4 r7_xyzw_4 = (unitWorldNormal_y_1.xxxx * r7_xyzw_3);
                float4 r6_xyzw_14 = mad(r6_xyzw_13, unitWorldNormal_x_3.xxxx, r7_xyzw_4);
                float4 r6_xyzw_15 = mad(r8_xyzw_2, unitWorldNormal_z_1.xxxx, r6_xyzw_14);
                float4 r7_xyzw_5 = rsqrt(r9_xyzw_4);
                float4 r6_xyzw_16 = (r6_xyzw_15 * r7_xyzw_5);
                float4 r6_xyzw_17 = max(r6_xyzw_16, float4(0, 0, 0, 0));
                float4 r7_xyzw_6 = mad(r9_xyzw_4, unity_4LightAtten0, float4(1, 1, 1, 1));
                float4 r7_xyzw_7 = (float4(1, 1, 1, 1) / r7_xyzw_6);
                float4 r6_xyzw_18 = (r6_xyzw_17 * r7_xyzw_7);
                float3 r6_xyz_20 = (mad(cb2_values[10].xyzx, r6_xyzw_18.wwww, (mad(cb2_values[9].xyzx, r6_xyzw_18.zzzz, (mad(cb2_values[7].xyzx, r6_xyzw_18.xxxx, ((r6_xyzw_18.yyyy * cb2_values[8].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                float r1_w_4 = saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx));
                float r3_w_1 = saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r2_w_6.xxxx * r5_xyz_1.xyzx)).xyzx));
                float r3_w_2 = log2(r3_w_1);
                float r3_w_3 = (r3_w_2 * mad(_Smoothness, 120, 8));
                float r3_w_4 = exp2(r3_w_3);
                float r3_w_5 = (r3_w_4 * _Specular);
                float r4_x_3 = dot(-unitViewDir_xyz_1.xyzx, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3));
                float4 r1_xyzw_4 = mad(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r4_x_3 + r4_x_3)).xxxx, -unitViewDir_xyz_1.xyzx);
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_2 = r1_xyzw_4.y;
                float r1_z_2 = r1_xyzw_4.z;
                float4 r4_xyzw_5 = t2.Sample(sampler_linear_clamp, (float4(r1_x_4, r1_y_2, r1_z_2, r1_x_4)).xyz);
                                float4 r3_xyzw_8 = (r4_xyzw_5.xyzx * ((pow(mad(unity_ProbeVolumeWorldToObject[2].w, (r4_xyzw_5.w + -1), 1), unity_ProbeVolumeWorldToObject[2].y) * unity_ProbeVolumeWorldToObject[2].x)).xxxx);
                float r3_x_8 = r3_xyzw_8.x;
                float r3_y_2 = r3_xyzw_8.y;
                float r3_z_2 = r3_xyzw_8.z;
                float4 r4_xyzw_6 = (cb6_values[0].xyzx + cb6_values[6].xyzx);
                float r4_x_6 = r4_xyzw_6.x;
                float r4_y_3 = r4_xyzw_6.y;
                float r4_z_3 = r4_xyzw_6.z;
                float4 r4_xyzw_7 = (float4(r4_x_6, r4_y_3, r4_z_3, r4_x_6) + cb6_values[5].xyzx);
                float r4_x_7 = r4_xyzw_7.x;
                float r4_y_4 = r4_xyzw_7.y;
                float r4_z_4 = r4_xyzw_7.z;
                float r5_x_3 = cb6_values[1].x;
                float r5_y_3 = cb6_values[2].x;
                float r5_z_3 = cb6_values[3].x;
                float4 r4_xyzw_8 = (float4(r4_x_7, r4_y_4, r4_z_4, r4_x_7) + float4(r5_x_3, r5_y_3, r5_z_3, r5_x_3));
                float r4_x_8 = r4_xyzw_8.x;
                float r4_y_5 = r4_xyzw_8.y;
                float r4_z_5 = r4_xyzw_8.z;
                float4 r2_xyzw_18 = (float4(r2_y_17, r2_y_17, r2_z_11, r2_w_15) + r6_xyz_20.xxyz);
                float r2_y_18 = r2_xyzw_18.y;
                float r2_z_12 = r2_xyzw_18.z;
                float r2_w_16 = r2_xyzw_18.w;
                float4 r2_xyzw_19 = mad(((r1_w_4.xxxx * _LightColor0.xyzx)).xxyz, r2_x_5.xxxx, float4(r2_y_18, r2_y_18, r2_z_12, r2_w_16));
                float r2_y_19 = r2_xyzw_19.y;
                float r2_z_13 = r2_xyzw_19.z;
                float r2_w_17 = r2_xyzw_19.w;
                float4 r2_xyzw_6 = (float4(r3_x_8, r3_y_2, r3_z_2, r3_x_8) * _Smoothness.xxxx);
                float r2_x_6 = r2_xyzw_6.x;
                float r2_y_20 = r2_xyzw_6.y;
                float r2_z_14 = r2_xyzw_6.z;
                float3 r0_xyz_4 = (mad(float4(r2_x_6, r2_y_20, r2_z_14, r2_x_6), float4(0.2, 0.2, 0.2, 0), (mad(r0_xyzw_2.xyzx, float4(r2_y_19, r2_z_13, r2_w_17, r2_y_19), ((r2_x_5.xxxx * ((r3_w_5.xxxx * _LightColor0.xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                float4 r1_xyzw_5 = (float4(r1_x_4, r1_y_2, r1_z_2, r1_x_4) + unity_ProbeVolumeWorldToObject[1].xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_3 = r1_xyzw_5.y;
                float r1_z_3 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = (float4(r1_x_5, r1_y_3, r1_z_3, r1_x_5) + unity_ProbeVolumeParams.xyzx);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_4 = r1_xyzw_6.z;
                float4 r1_xyzw_7 = (float4(r1_x_6, r1_y_4, r1_z_4, r1_x_6) + unity_ProbeVolumeWorldToObject[0].xyzx);
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_5 = r1_xyzw_7.y;
                float r1_z_5 = r1_xyzw_7.z;
                float4 r1_xyzw_8 = (float4(r4_x_8, r4_y_5, r4_z_5, r4_x_8) + float4(r1_x_7, r1_y_5, r1_z_5, r1_x_7));
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_z_6 = r1_xyzw_8.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_8, r1_y_6, r1_z_6, r1_x_8), float4(0.001, 0.001, 0.001, 0), r0_xyz_4.xyzx)).xyz;
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
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
                float _Smoothness : packoffset(c6.x);
                float _Specular : packoffset(c6.y);
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
                float4 unity_AmbientSky;
                float4 unity_AmbientEquator;
                float4 unity_AmbientGround;
                float4 cb3_values[21];
            };
            cbuffer _UnityReflectionProbesCB_b4
            {
                float4 unity_SpecCube0_BoxMax : packoffset(c0);
                float4 unity_SpecCube0_BoxMin : packoffset(c1);
                float4 unity_SpecCube0_ProbePosition : packoffset(c2);
                float4 unity_SpecCube0_HDR : packoffset(c3);
            };
            cbuffer _UnityProbeVolumeCB_b5
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
            TextureCube t1;
            Texture3D t2;
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
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_2 = normalize(viewDir_xyz_1);
                float r2_w_3 = dot(_WorldSpaceLightPos0.xyzx, _WorldSpaceLightPos0.xyzx);
                float r2_w_4 = rsqrt(r2_w_3);
                float3 lightDir_xyz_1 = ((r2_w_4.xxxx * _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r4_xyz_1 = (mad(_WorldSpaceLightPos0.xyzx, r2_w_4.xxxx, unitViewDir_xyz_2.xyzx)).xyz;
                float r2_w_5 = dot(r4_xyz_1.xyzx, r4_xyz_1.xyzx);
                float r2_w_6 = rsqrt(r2_w_5);
                float r2_w_7 = (unity_ProbeVolumeParams.x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r2_w_7)
                {
                    float r2_w_8 = (unity_ProbeVolumeParams.y == 1);
                    float3 r5_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r2_w_8.xxxx ? r5_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r5_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r2_w_9 = mad(r5_y_8, 0.25, 0.75);
                    float r3_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r5_x_8 = max(r2_w_9, r3_w_1);
                    float4 r5_xyzw_9 = t2.Sample(sampler_linear_clamp1, (float4(r5_x_8, r5_z_8, r5_w_2, r5_x_8)).xyz);
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
                float r2_w_11 = saturate(dot(float4(r5_x_10, r5_y_10, r5_z_10, r5_w_4), unity_OcclusionMaskSelector));
                float r1_w_1 = 1;
                float r6_x_1 = dot(unity_SHAr, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r6_y_1 = dot(unity_SHAg, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r6_z_1 = dot(unity_SHAb, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float4 r7_xyzw_1 = (float4(unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1, unitWorldNormal_x_3) * float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1));
                float r8_x_1 = dot(unity_SHBr, r7_xyzw_1);
                float r8_y_1 = dot(unity_SHBg, r7_xyzw_1);
                float r8_z_1 = dot(unity_SHBb, r7_xyzw_1);
                float r1_w_2 = (unitWorldNormal_y_1 * unitWorldNormal_y_1);
                float r1_w_3 = mad(unitWorldNormal_x_3, unitWorldNormal_x_3, -r1_w_2);
                float3 r6_xyz_2 = ((float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1) + (mad(unity_SHC.xyzx, r1_w_3.xxxx, float4(r8_x_1, r8_y_1, r8_z_1, r8_x_1))).xyzx)).xyz;
                float3 r5_xyz_14 = (((mad(unity_AmbientGround.xyzx, float4(0.25, 0.25, 0.25, 0), (mad(unity_AmbientSky.xyzx, float4(0.5, 0.5, 0.5, 0), ((unity_AmbientEquator.xyzx * float4(0.25, 0.25, 0.25, 0))).xyzx)).xyzx)).xyzx + r6_xyz_2.xyzx)).xyz;
                float4 r6_xyzw_3 = (-i.texcoord2.xxxx + unity_4LightPosX0);
                float4 r7_xyzw_3 = (-i.texcoord2.yyyy + unity_4LightPosY0);
                float4 r8_xyzw_2 = (-i.texcoord2.zzzz + unity_4LightPosZ0);
                float4 r9_xyzw_4 = max(mad(r8_xyzw_2, r8_xyzw_2, mad(r6_xyzw_3, r6_xyzw_3, (r7_xyzw_3 * r7_xyzw_3))), float4(1E-06, 1E-06, 1E-06, 1E-06));
                float4 r7_xyzw_4 = (unitWorldNormal_y_1.xxxx * r7_xyzw_3);
                float4 r6_xyzw_4 = mad(r6_xyzw_3, unitWorldNormal_x_3.xxxx, r7_xyzw_4);
                float4 r6_xyzw_5 = mad(r8_xyzw_2, unitWorldNormal_z_1.xxxx, r6_xyzw_4);
                float4 r7_xyzw_5 = rsqrt(r9_xyzw_4);
                float4 r6_xyzw_6 = (r6_xyzw_5 * r7_xyzw_5);
                float4 r6_xyzw_7 = max(r6_xyzw_6, float4(0, 0, 0, 0));
                float4 r7_xyzw_6 = mad(r9_xyzw_4, unity_4LightAtten0, float4(1, 1, 1, 1));
                float4 r7_xyzw_7 = (float4(1, 1, 1, 1) / r7_xyzw_6);
                float4 r6_xyzw_8 = (r6_xyzw_7 * r7_xyzw_7);
                float3 r6_xyz_10 = (mad(cb2_values[10].xyzx, r6_xyzw_8.wwww, (mad(cb2_values[9].xyzx, r6_xyzw_8.zzzz, (mad(cb2_values[7].xyzx, r6_xyzw_8.xxxx, ((r6_xyzw_8.yyyy * cb2_values[8].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                float r1_w_4 = saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx));
                float r3_y_2 = mad(_Smoothness, 120, 8);
                float r3_y_3 = dot(-unitViewDir_xyz_2.xyzx, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3));
                float r3_y_4 = (r3_y_3 + r3_y_3);
                float4 r1_xyzw_4 = mad(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), -r3_y_4.xxxx, -unitViewDir_xyz_2.xyzx);
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_2 = r1_xyzw_4.y;
                float r1_z_2 = r1_xyzw_4.z;
                float4 r4_xyzw_3 = t1.Sample(sampler_linear_clamp, (float4(r1_x_4, r1_y_2, r1_z_2, r1_x_4)).xyz);
                                float4 r2_xyzw_9 = (r4_xyzw_3.xyzx * ((pow(mad(unity_SpecCube0_HDR.w, (r4_xyzw_3.w + -1), 1), unity_SpecCube0_HDR.y) * unity_SpecCube0_HDR.x)).xxxx);
                float r2_x_9 = r2_xyzw_9.x;
                float r2_y_3 = r2_xyzw_9.y;
                float r2_z_3 = r2_xyzw_9.z;
                float4 r3_xyzw_5 = (unity_ProbeVolumeParams.xxyz + unity_ProbeVolumeMin.xxyz);
                float r3_y_5 = r3_xyzw_5.y;
                float r3_z_2 = r3_xyzw_5.z;
                float r3_w_3 = r3_xyzw_5.w;
                float4 r3_xyzw_6 = (float4(r3_y_5, r3_y_5, r3_z_2, r3_w_3) + unity_ProbeVolumeSizeInv.xxyz);
                float r3_y_6 = r3_xyzw_6.y;
                float r3_z_3 = r3_xyzw_6.z;
                float r3_w_4 = r3_xyzw_6.w;
                float r4_x_4 = unity_ProbeVolumeWorldToObject[0].x;
                float r4_y_4 = unity_ProbeVolumeWorldToObject[1].x;
                float r4_z_4 = unity_ProbeVolumeWorldToObject[2].x;
                float4 r3_xyzw_7 = (float4(r3_y_6, r3_y_6, r3_z_3, r3_w_4) + float4(r4_x_4, r4_x_4, r4_y_4, r4_z_4));
                float r3_y_7 = r3_xyzw_7.y;
                float r3_z_4 = r3_xyzw_7.z;
                float r3_w_5 = r3_xyzw_7.w;
                                float3 r5_xyz_16 = ((((pow(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r2_w_6.xxxx * r4_xyz_1.xyzx)).xyzx)), r3_y_2) * _Specular)).xxxx * _LightColor0.xyzx)).xyz;
                float3 r5_xyz_17 = ((r2_w_11.xxxx * r5_xyz_16.xyzx)).xyz;
                float3 r0_xyz_3 = (mad(r0_xyzw_2.xyzx, (mad(((r1_w_4.xxxx * _LightColor0.xyzx)).xyzx, r2_w_11.xxxx, ((r5_xyz_14.xyzx + r6_xyz_10.xyzx)).xyzx)).xyzx, r5_xyz_17.xyzx)).xyz;
                float4 r2_xyzw_10 = (float4(r2_x_9, r2_y_3, r2_z_3, r2_x_9) * _Smoothness.xxxx);
                float r2_x_10 = r2_xyzw_10.x;
                float r2_y_4 = r2_xyzw_10.y;
                float r2_z_4 = r2_xyzw_10.z;
                float4 r1_xyzw_5 = (float4(r1_x_4, r1_y_2, r1_z_2, r1_x_4) + unity_SpecCube0_ProbePosition.xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_3 = r1_xyzw_5.y;
                float r1_z_3 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = (float4(r1_x_5, r1_y_3, r1_z_3, r1_x_5) + unity_SpecCube0_BoxMax.xyzx);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_4 = r1_xyzw_6.z;
                float4 r1_xyzw_7 = (float4(r1_x_6, r1_y_4, r1_z_4, r1_x_6) + unity_SpecCube0_BoxMin.xyzx);
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_5 = r1_xyzw_7.y;
                float r1_z_5 = r1_xyzw_7.z;
                float4 r1_xyzw_8 = (float4(r3_y_7, r3_z_4, r3_w_5, r3_y_7) + float4(r1_x_7, r1_y_5, r1_z_5, r1_x_7));
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_z_6 = r1_xyzw_8.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_8, r1_y_6, r1_z_6, r1_x_8), float4(0.001, 0.001, 0.001, 0), (mad(float4(r2_x_10, r2_y_4, r2_z_4, r2_x_10), float4(0.2, 0.2, 0.2, 0), r0_xyz_3.xyzx)).xyzx)).xyz;
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
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
                float _Smoothness : packoffset(c6.x);
                float _Specular : packoffset(c6.y);
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
            cbuffer _UnityPerFrameCB_b3
            {
                float4 unity_AmbientSky;
                float4 unity_AmbientEquator;
                float4 unity_AmbientGround;
                float4 cb3_values[26];
            };
            cbuffer _UnityReflectionProbesCB_b4
            {
                float4 unity_SpecCube0_BoxMax;
                float4 unity_SpecCube0_BoxMin;
                float4 unity_SpecCube0_ProbePosition;
                float4 unity_SpecCube0_HDR;
                float4 cb4_values[12];
            };
            cbuffer _UnityProbeVolumeCB_b5
            {
                float4 unity_ProbeVolumeParams : packoffset(c0);
                float4x4 unity_ProbeVolumeWorldToObject : packoffset(c1);
                float3 unity_ProbeVolumeSizeInv : packoffset(c5);
                float3 unity_ProbeVolumeMin : packoffset(c6);
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
            TextureCube t2;
            Texture3D t3;
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
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float r2_w_3 = dot(_WorldSpaceLightPos0.xyzx, _WorldSpaceLightPos0.xyzx);
                float r2_w_4 = rsqrt(r2_w_3);
                float3 lightDir_xyz_1 = ((r2_w_4.xxxx * _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r5_xyz_1 = (mad(_WorldSpaceLightPos0.xyzx, r2_w_4.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r2_w_5 = dot(r5_xyz_1.xyzx, r5_xyz_1.xyzx);
                float r2_w_6 = rsqrt(r2_w_5);
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r2_x_2 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float4 r2_xyzw_2 = (i.texcoord2.xxyz + -cb3_values[25].xxyz);
                float r2_y_2 = r2_xyzw_2.y;
                float r2_z_2 = r2_xyzw_2.z;
                float r2_w_7 = r2_xyzw_2.w;
                float r2_y_3 = dot(float4(r2_y_2, r2_z_2, r2_w_7, r2_y_2), float4(r2_y_2, r2_z_2, r2_w_7, r2_y_2));
                float r2_y_4 = sqrt(r2_y_3);
                float r2_y_5 = (-r2_x_2 + r2_y_4);
                float r2_y_6 = (cb6_values[0].x == 1);
                float r6_x_9;
                float r6_y_9;
                float r6_z_9;
                float r6_w_4;
                if (r2_y_6)
                {
                    float r2_y_7 = (cb6_values[0].y == 1);
                    float3 r6_xyz_6 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (r2_y_7.xxxx ? r6_xyz_6.xxyz : i.texcoord2.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float r2_w_8 = r2_xyzw_8.w;
                    float4 r2_xyzw_9 = (float4(r2_y_8, r2_y_8, r2_z_3, r2_w_8) + -cb6_values[6].xxyz);
                    float r2_y_9 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float r2_w_9 = r2_xyzw_9.w;
                    float4 r6_xyzw_7 = (float4(r2_y_9, r2_y_9, r2_z_4, r2_w_9) * cb6_values[5].xxyz);
                    float r6_y_7 = r6_xyzw_7.y;
                    float r6_z_7 = r6_xyzw_7.z;
                    float r6_w_2 = r6_xyzw_7.w;
                    float r2_y_10 = mad(r6_y_7, 0.25, 0.75);
                    float r2_z_5 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r6_x_7 = max(r2_z_5, r2_y_10);
                    float4 r6_xyzw_8 = t3.Sample(sampler_linear_clamp1, (float4(r6_x_7, r6_z_7, r6_w_2, r6_x_7)).xyz);
                    r6_x_9 = r6_xyzw_8.x;
                    r6_y_9 = r6_xyzw_8.y;
                    r6_z_9 = r6_xyzw_8.z;
                    r6_w_4 = r6_xyzw_8.w;
                }
                else
                {
                    float4 r6_xyzw_2 = float4(1, 1, 1, 1);
                    r6_x_9 = r6_xyzw_2.x;
                    r6_y_9 = r6_xyzw_2.y;
                    r6_z_9 = r6_xyzw_2.z;
                    r6_w_4 = r6_xyzw_2.w;
                }
                float r2_y_12 = saturate(dot(float4(r6_x_9, r6_y_9, r6_z_9, r6_w_4), unity_OcclusionMaskSelector));
                float4 r2_xyzw_7 = (i.texcoord5.xxxy / i.texcoord5.wwww);
                float r2_z_7 = r2_xyzw_7.z;
                float r2_w_11 = r2_xyzw_7.w;
                float4 r6_xyzw_10 = t1.Sample(sampler_linear_clamp2, (float4(r2_z_7, r2_w_11, r2_z_7, r2_z_7)).xy);
                float r2_y_13 = (r2_y_12 + -r6_xyzw_10.x);
                float r2_x_5 = mad(saturate(mad(mad(cb3_values[25].w, r2_y_5, r2_x_2), cb3_values[24].z, cb3_values[24].w)), r2_y_13, r6_xyzw_10.x);
                float4 r2_xyzw_14 = (unity_SpecCube0_ProbePosition.xxyz * float4(0, 0.25, 0.25, 0.25));
                float r2_y_14 = r2_xyzw_14.y;
                float r2_z_8 = r2_xyzw_14.z;
                float r2_w_12 = r2_xyzw_14.w;
                float4 r2_xyzw_15 = mad(unity_SpecCube0_BoxMin.xxyz, float4(0, 0.5, 0.5, 0.5), float4(r2_y_14, r2_y_14, r2_z_8, r2_w_12));
                float r2_y_15 = r2_xyzw_15.y;
                float r2_z_9 = r2_xyzw_15.z;
                float r2_w_13 = r2_xyzw_15.w;
                float4 r2_xyzw_16 = mad(unity_SpecCube0_HDR.xxyz, float4(0, 0.25, 0.25, 0.25), float4(r2_y_15, r2_y_15, r2_z_9, r2_w_13));
                float r2_y_16 = r2_xyzw_16.y;
                float r2_z_10 = r2_xyzw_16.z;
                float r2_w_14 = r2_xyzw_16.w;
                float r1_w_1 = 1;
                float r6_x_11 = dot(unity_SHAr, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r6_y_11 = dot(unity_SHAg, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r6_z_11 = dot(unity_SHAb, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float4 r7_xyzw_1 = (float4(unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1, unitWorldNormal_x_3) * float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1));
                float r8_x_1 = dot(unity_SHBr, r7_xyzw_1);
                float r8_y_1 = dot(unity_SHBg, r7_xyzw_1);
                float r8_z_1 = dot(unity_SHBb, r7_xyzw_1);
                float r1_w_2 = (unitWorldNormal_y_1 * unitWorldNormal_y_1);
                float r1_w_3 = mad(unitWorldNormal_x_3, unitWorldNormal_x_3, -r1_w_2);
                float4 r2_xyzw_17 = (float4(r2_y_16, r2_y_16, r2_z_10, r2_w_14) + ((float4(r6_x_11, r6_y_11, r6_z_11, r6_x_11) + (mad(unity_SHC.xyzx, r1_w_3.xxxx, float4(r8_x_1, r8_y_1, r8_z_1, r8_x_1))).xyzx)).xxyz);
                float r2_y_17 = r2_xyzw_17.y;
                float r2_z_11 = r2_xyzw_17.z;
                float r2_w_15 = r2_xyzw_17.w;
                float4 r6_xyzw_13 = (-i.texcoord2.xxxx + unity_4LightPosX0);
                float4 r7_xyzw_3 = (-i.texcoord2.yyyy + unity_4LightPosY0);
                float4 r8_xyzw_2 = (-i.texcoord2.zzzz + unity_4LightPosZ0);
                float4 r9_xyzw_4 = max(mad(r8_xyzw_2, r8_xyzw_2, mad(r6_xyzw_13, r6_xyzw_13, (r7_xyzw_3 * r7_xyzw_3))), float4(1E-06, 1E-06, 1E-06, 1E-06));
                float4 r7_xyzw_4 = (unitWorldNormal_y_1.xxxx * r7_xyzw_3);
                float4 r6_xyzw_14 = mad(r6_xyzw_13, unitWorldNormal_x_3.xxxx, r7_xyzw_4);
                float4 r6_xyzw_15 = mad(r8_xyzw_2, unitWorldNormal_z_1.xxxx, r6_xyzw_14);
                float4 r7_xyzw_5 = rsqrt(r9_xyzw_4);
                float4 r6_xyzw_16 = (r6_xyzw_15 * r7_xyzw_5);
                float4 r6_xyzw_17 = max(r6_xyzw_16, float4(0, 0, 0, 0));
                float4 r7_xyzw_6 = mad(r9_xyzw_4, unity_4LightAtten0, float4(1, 1, 1, 1));
                float4 r7_xyzw_7 = (float4(1, 1, 1, 1) / r7_xyzw_6);
                float4 r6_xyzw_18 = (r6_xyzw_17 * r7_xyzw_7);
                float3 r6_xyz_20 = (mad(cb2_values[10].xyzx, r6_xyzw_18.wwww, (mad(cb2_values[9].xyzx, r6_xyzw_18.zzzz, (mad(cb2_values[7].xyzx, r6_xyzw_18.xxxx, ((r6_xyzw_18.yyyy * cb2_values[8].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                float r1_w_4 = saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), lightDir_xyz_1.xyzx));
                float r3_w_1 = saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r2_w_6.xxxx * r5_xyz_1.xyzx)).xyzx));
                float r3_w_2 = log2(r3_w_1);
                float r3_w_3 = (r3_w_2 * mad(_Smoothness, 120, 8));
                float r3_w_4 = exp2(r3_w_3);
                float r3_w_5 = (r3_w_4 * _Specular);
                float r4_x_3 = dot(-unitViewDir_xyz_1.xyzx, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3));
                float4 r1_xyzw_4 = mad(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r4_x_3 + r4_x_3)).xxxx, -unitViewDir_xyz_1.xyzx);
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_2 = r1_xyzw_4.y;
                float r1_z_2 = r1_xyzw_4.z;
                float4 r4_xyzw_5 = t2.Sample(sampler_linear_clamp, (float4(r1_x_4, r1_y_2, r1_z_2, r1_x_4)).xyz);
                                float4 r3_xyzw_8 = (r4_xyzw_5.xyzx * ((pow(mad(unity_ProbeVolumeWorldToObject[2].w, (r4_xyzw_5.w + -1), 1), unity_ProbeVolumeWorldToObject[2].y) * unity_ProbeVolumeWorldToObject[2].x)).xxxx);
                float r3_x_8 = r3_xyzw_8.x;
                float r3_y_2 = r3_xyzw_8.y;
                float r3_z_2 = r3_xyzw_8.z;
                float4 r4_xyzw_6 = (cb6_values[0].xyzx + cb6_values[6].xyzx);
                float r4_x_6 = r4_xyzw_6.x;
                float r4_y_3 = r4_xyzw_6.y;
                float r4_z_3 = r4_xyzw_6.z;
                float4 r4_xyzw_7 = (float4(r4_x_6, r4_y_3, r4_z_3, r4_x_6) + cb6_values[5].xyzx);
                float r4_x_7 = r4_xyzw_7.x;
                float r4_y_4 = r4_xyzw_7.y;
                float r4_z_4 = r4_xyzw_7.z;
                float r5_x_3 = cb6_values[1].x;
                float r5_y_3 = cb6_values[2].x;
                float r5_z_3 = cb6_values[3].x;
                float4 r4_xyzw_8 = (float4(r4_x_7, r4_y_4, r4_z_4, r4_x_7) + float4(r5_x_3, r5_y_3, r5_z_3, r5_x_3));
                float r4_x_8 = r4_xyzw_8.x;
                float r4_y_5 = r4_xyzw_8.y;
                float r4_z_5 = r4_xyzw_8.z;
                float4 r2_xyzw_18 = (float4(r2_y_17, r2_y_17, r2_z_11, r2_w_15) + r6_xyz_20.xxyz);
                float r2_y_18 = r2_xyzw_18.y;
                float r2_z_12 = r2_xyzw_18.z;
                float r2_w_16 = r2_xyzw_18.w;
                float4 r2_xyzw_19 = mad(((r1_w_4.xxxx * _LightColor0.xyzx)).xxyz, r2_x_5.xxxx, float4(r2_y_18, r2_y_18, r2_z_12, r2_w_16));
                float r2_y_19 = r2_xyzw_19.y;
                float r2_z_13 = r2_xyzw_19.z;
                float r2_w_17 = r2_xyzw_19.w;
                float4 r2_xyzw_6 = (float4(r3_x_8, r3_y_2, r3_z_2, r3_x_8) * _Smoothness.xxxx);
                float r2_x_6 = r2_xyzw_6.x;
                float r2_y_20 = r2_xyzw_6.y;
                float r2_z_14 = r2_xyzw_6.z;
                float3 r0_xyz_4 = (mad(float4(r2_x_6, r2_y_20, r2_z_14, r2_x_6), float4(0.2, 0.2, 0.2, 0), (mad(r0_xyzw_2.xyzx, float4(r2_y_19, r2_z_13, r2_w_17, r2_y_19), ((r2_x_5.xxxx * ((r3_w_5.xxxx * _LightColor0.xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                float4 r1_xyzw_5 = (float4(r1_x_4, r1_y_2, r1_z_2, r1_x_4) + unity_ProbeVolumeWorldToObject[1].xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_3 = r1_xyzw_5.y;
                float r1_z_3 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = (float4(r1_x_5, r1_y_3, r1_z_3, r1_x_5) + unity_ProbeVolumeParams.xyzx);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_4 = r1_xyzw_6.z;
                float4 r1_xyzw_7 = (float4(r1_x_6, r1_y_4, r1_z_4, r1_x_6) + unity_ProbeVolumeWorldToObject[0].xyzx);
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_5 = r1_xyzw_7.y;
                float r1_z_5 = r1_xyzw_7.z;
                float4 r1_xyzw_8 = (float4(r4_x_8, r4_y_5, r4_z_5, r4_x_8) + float4(r1_x_7, r1_y_5, r1_z_5, r1_x_7));
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_z_6 = r1_xyzw_8.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_8, r1_y_6, r1_z_6, r1_x_8), float4(0.001, 0.001, 0.001, 0), r0_xyz_4.xyzx)).xyz;
                o.sv_Target0.w = r0_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Diffuse"
}
