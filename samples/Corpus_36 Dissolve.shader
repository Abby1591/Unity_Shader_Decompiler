Shader "Corpus/36 Dissolve"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo", 2D) = "" {}
        _DissolveMap ("Dissolve Map", 2D) = "" {}
        _Cutoff ("Dissolve", Range(0, 1)) = 0.5
        _EdgeWidth ("Edge Width", Range(0, 0.5)) = 0.05
        _EdgeColor ("Edge Color", Color) = (1,0.3,0,1)
        _Metallic ("Metallic", Range(0, 1)) = 0
        _Smoothness ("Smoothness", Range(0, 1)) = 0.5
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
                float4 _Color : packoffset(c4);
                float4 _EdgeColor : packoffset(c5);
                float _Cutoff : packoffset(c6.x);
                float _EdgeWidth : packoffset(c6.y);
                float _Metallic : packoffset(c6.z);
                float _Smoothness : packoffset(c6.w);
                float4 _MainTex_ST : packoffset(c7);
                float4 _DissolveMap_ST : packoffset(c8);
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
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            TextureCube t2;
            TextureCube t3;
            Texture3D t4;
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
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program30Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
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
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _DissolveMap_ST.xxxy, _DissolveMap_ST.zzzw)).zw;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program30Output frag(program30Input i)
            {
                program30Output o = (program30Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_2 = ((r2_xyzw_1.xyzx * _Color.xyzx)).xyz;
                float4 r3_xyzw_1 = _DissolveMap.Sample(sampler_DissolveMap, (i.texcoord0.zwzz).xy);
                float r1_w_1 = (r3_xyzw_1.x + -_Cutoff);
                float r2_w_2 = ((float4(1, 1, 1, 1) / _EdgeWidth)).w;
                float r2_w_3 = saturate((r1_w_1 * r2_w_2));
                float r3_x_2 = mad(r2_w_3, -2, 3);
                float r2_w_4 = (r2_w_3 * r2_w_3);
                float r3_y_2 = (r2_w_4 * r3_x_2);
                float r1_w_2 = (r1_w_1 < 0);
                if (r1_w_2) discard;
                float r1_w_3 = mad(-r3_x_2, r2_w_4, 1);
                float4 r3_xyzw_3 = (r1_w_3.xxxx * _EdgeColor.xxyz);
                float r3_x_3 = r3_xyzw_3.x;
                float r3_z_2 = r3_xyzw_3.z;
                float r3_w_2 = r3_xyzw_3.w;
                float r1_w_4 = (unity_ProbeVolumeParams.x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r1_w_4)
                {
                    float r1_w_5 = (unity_ProbeVolumeParams.y == 1);
                    float3 r5_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r1_w_5.xxxx ? r5_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r5_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r1_w_6 = mad(r5_y_8, 0.25, 0.75);
                    float r2_w_5 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r5_x_8 = max(r1_w_6, r2_w_5);
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
                float r1_w_8 = saturate(dot(float4(r5_x_10, r5_y_10, r5_z_10, r5_w_4), unity_OcclusionMaskSelector));
                float r2_w_7 = (-_Smoothness + 1);
                float r4_w_1 = dot(-unitViewDir_xyz_1.xyzx, i.texcoord1.xyzx);
                float r4_w_2 = (r4_w_1 + r4_w_1);
                float3 r5_xyz_11 = (mad(i.texcoord1.xyzx, -r4_w_2.xxxx, -unitViewDir_xyz_1.xyzx)).xyz;
                float3 r6_xyz_1 = ((r1_w_8.xxxx * _LightColor0.xyzx)).xyz;
                float r1_w_9 = (0 < unity_SpecCube0_ProbePosition.w);
                float3 r7_xyz_4;
                if (r1_w_9)
                {
                    float3 r7_xyz_2 = normalize(r5_xyz_11);
                    float3 r10_xyz_1 = ((float4(0, 0, 0, 0) < r7_xyz_2.xyzx)).xyz;
                    float3 r8_xyz_3 = ((r10_xyz_1.xyzx ? ((((-i.texcoord2.xyzx + unity_SpecCube0_BoxMax.xyzx)).xyzx / r7_xyz_2.xyzx)).xyzx : ((((-i.texcoord2.xyzx + unity_SpecCube0_BoxMin.xyzx)).xyzx / r7_xyz_2.xyzx)).xyzx)).xyz;
                    float r1_w_12 = min(r8_xyz_3.y, r8_xyz_3.x);
                    float r1_w_13 = min(r8_xyz_3.z, r1_w_12);
                    r7_xyz_4 = (mad(r7_xyz_2.xyzx, r1_w_13.xxxx, ((i.texcoord2.xyzx + -unity_SpecCube0_ProbePosition.xyzx)).xyzx)).xyz;
                }
                else
                {
                    r7_xyz_4 = r5_xyz_11.xyz;
                }
                float r1_w_15 = mad(-r2_w_7, 0.7, 1.7);
                float r1_w_16 = (r1_w_15 * r2_w_7);
                float r1_w_17 = (r1_w_16 * 6);
                float4 r7_xyzw_5 = t2.SampleLevel(sampler_linear_clamp, r7_xyz_4.xyz, r1_w_17);
                float r4_w_3 = (r7_xyzw_5.w + -1);
                float r4_w_4 = mad(unity_SpecCube0_HDR.w, r4_w_3, 1);
                float r4_w_5 = log2(r4_w_4);
                float r4_w_6 = (r4_w_5 * unity_SpecCube0_HDR.y);
                float r4_w_7 = exp2(r4_w_6);
                float r4_w_8 = (r4_w_7 * unity_SpecCube0_HDR.x);
                float r5_w_5 = (unity_SpecCube0_BoxMin.w < 0.99999);
                float3 r8_xyz_8 = ((r7_xyzw_5.xyzx * r4_w_8.xxxx)).xyz;
                if (r5_w_5)
                {
                    float r5_w_6 = (0 < unity_SpecCube1_ProbePosition.w);
                    float3 r5_xyz_13 = r5_xyz_11;
                    if (r5_w_6)
                    {
                        float3 r9_xyz_4 = normalize(r5_xyz_11);
                        float3 r12_xyz_1 = ((float4(0, 0, 0, 0) < r9_xyz_4.xyzx)).xyz;
                        float3 r10_xyz_5 = ((r12_xyz_1.xyzx ? ((((-i.texcoord2.xyzx + unity_SpecCube1_BoxMax.xyzx)).xyzx / r9_xyz_4.xyzx)).xyzx : ((((-i.texcoord2.xyzx + unity_SpecCube1_BoxMin.xyzx)).xyzx / r9_xyz_4.xyzx)).xyzx)).xyz;
                        float r5_w_9 = min(r10_xyz_5.y, r10_xyz_5.x);
                        float r5_w_10 = min(r10_xyz_5.z, r5_w_9);
                        r5_xyz_13 = (mad(r9_xyz_4.xyzx, r5_w_10.xxxx, ((i.texcoord2.xyzx + -unity_SpecCube1_ProbePosition.xyzx)).xyzx)).xyz;
                    }
                    float4 r5_xyzw_14 = t3.SampleLevel(sampler_linear_clamp, r5_xyz_13.xyz, r1_w_17);
                    float r1_w_18 = (r5_xyzw_14.w + -1);
                    float r1_w_19 = mad(unity_SpecCube1_HDR.w, r1_w_18, 1);
                    float r1_w_20 = log2(r1_w_19);
                    float r1_w_21 = (r1_w_20 * unity_SpecCube1_HDR.y);
                    float r1_w_22 = exp2(r1_w_21);
                    float r1_w_23 = (r1_w_22 * unity_SpecCube1_HDR.x);
                    float3 r5_xyz_15 = ((r5_xyzw_14.xyzx * r1_w_23.xxxx)).xyz;
                    r8_xyz_8 = (mad(unity_SpecCube0_BoxMin.wwww, (mad(r4_w_8.xxxx, r7_xyzw_5.xyzx, -r5_xyz_15.xyzx)).xyzx, r5_xyz_15.xyzx)).xyz;
                }
                float3 unitWorldNormal_xyz_17 = normalize(i.texcoord1);
                float3 r2_xyz_4 = (mad(_Metallic.xxxx, (mad(r2_xyz_2.xyzx, r3_y_2.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_27 = mad(-_Metallic, 0.96, 0.96);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitWorldNormal_xyz_17.xyzx, unitViewDir_xyz_1.xyzx);
                float r1_x_2 = saturate(dot(unitWorldNormal_xyz_17.xyzx, _WorldSpaceLightPos0.xyzx));
                float r1_y_2 = saturate(dot(unitWorldNormal_xyz_17.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r2_w_7.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(nDotV_w_6) + 1);
                float r3_y_3 = (r1_z_4 * r1_z_4);
                float r3_y_4 = (r3_y_3 * r3_y_3);
                float r1_z_5 = (r1_z_4 * r3_y_4);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r2_w_7 * r2_w_7);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r2_w_8 = (-r0_z_8 + 1);
                float r3_y_5 = mad(abs(nDotV_w_6), r2_w_8, r0_z_8);
                float r2_w_9 = mad(r1_x_2, r2_w_8, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * r2_w_9);
                float r0_w_8 = mad(r1_x_2, r3_y_5, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r2_w_10 = (r0_z_8 * r0_z_8);
                float r3_y_6 = mad(r1_y_2, r2_w_10, -r1_y_2);
                float r1_y_3 = mad(r3_y_6, r1_y_2, 1);
                float r2_w_11 = (r2_w_10 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r1_y_5 = (r2_w_11 / r1_y_4);
                float r0_w_11 = (r0_w_10 * r1_y_5);
                float r0_w_12 = (r0_w_11 * 3.1415927);
                float4 r0_xyzw_9 = (r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_y_8, r0_w_12));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_w_13 = r0_xyzw_9.w;
                float r0_w_14 = max(r0_w_13, 0);
                float r0_z_9 = mad(r0_z_8, r0_z_8, 1);
                float r0_z_10 = ((float4(1, 1, 1, 1) / r0_z_9)).z;
                float r0_w_15 = (r0_w_14 * asfloat(asint((float)((dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx) != 0))) & asint(1065353216)));
                float r0_x_5 = (-r0_x_4 + 1);
                float r0_y_10 = (r0_x_5 * r0_x_5);
                float r0_y_11 = (r0_y_10 * r0_y_10);
                float4 r0_xyzw_7 = mad(((-r2_xyz_4.xyzx + float4(1, 1, 1, 0))).xyxz, ((r0_x_5 * r0_y_11)).xxxx, r2_xyz_4.xyxz);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_12 = r0_xyzw_7.y;
                float r0_w_16 = r0_xyzw_7.w;
                float4 r0_xyzw_8 = (float4(r0_x_7, r0_y_12, r0_x_7, r0_w_16) * ((r6_xyz_1.xyzx * r0_w_15.xxxx)).xyxz);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_13 = r0_xyzw_8.y;
                float r0_w_17 = r0_xyzw_8.w;
                float r0_x_9 = (mad(((r1_w_27.xxxx * ((r2_xyz_2.xyzx * r3_y_2.xxxx)).xyzx)).xyxz, ((r0_y_9.xxxx * r6_xyz_1.xyzx)).xyxz, float4(r0_x_8, r0_y_13, r0_x_8, r0_w_17))).x;
                float4 r0_xyzw_14 = mad(((r1_w_27.xxxx * ((r2_xyz_2.xyzx * r3_y_2.xxxx)).xyzx)).xyxz, ((r0_y_9.xxxx * r6_xyz_1.xyzx)).xyxz, float4(r0_x_8, r0_y_13, r0_x_8, r0_w_17));
                float r0_y_14 = r0_xyzw_14.y;
                float r0_w_18 = r0_xyzw_14.w;
                float4 r1_xyzw_8 = (-r2_xyz_4.xyxz + (saturate(((-r1_w_27 + _Smoothness) + 1))).xxxx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_w_28 = r1_xyzw_8.w;
                float4 r1_xyzw_9 = mad(r1_z_5.xxxx, float4(r1_x_8, r1_y_6, r1_w_28, r1_x_8), r2_xyz_4.xyzx);
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_7 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r0_xyzw_10 = mad(((r8_xyz_8.xyzx * r0_z_10.xxxx)).xyzx, float4(r1_x_9, r1_y_7, r1_z_6, r1_x_9), float4(r0_x_9, r0_y_14, r0_w_18, r0_x_9));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_15 = r0_xyzw_10.y;
                float r0_z_11 = r0_xyzw_10.z;
                o.sv_Target0.xyz = (mad(float4(r3_x_3, r3_z_2, r3_w_2, r3_x_3), _EdgeColor.wwww, float4(r0_x_10, r0_y_15, r0_z_11, r0_x_10))).xyz;
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
                float4 _Color;
                float4 _EdgeColor;
                float _Cutoff;
                float _EdgeWidth;
                float _Metallic;
                float _Smoothness;
                float4 _MainTex_ST;
                float4 _DissolveMap_ST_b0;
                float4 cb0_values[13];
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
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            Texture2D t2;
            Texture3D t3;
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
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program89Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
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
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_3 = ((worldPos_xyzw_4.yyyy * _EdgeColor.xyzx)).xyz;
                float3 clipPos_xyz_4 = (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_3.xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(cb0_values[6].xyzx, worldPos_xyzw_4.zzzz, clipPos_xyz_4.xyzx)).xyz;
                o.texcoord3.xyz = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program89Output frag(program89Input i)
            {
                program89Output o = (program89Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_2 = normalize(viewDir_xyz_1);
                float4 r3_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r3_xyz_2 = ((r3_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float4 r4_xyzw_1 = _DissolveMap.Sample(sampler_DissolveMap, (i.texcoord0.zwzz).xy);
                float r1_w_3 = (r4_xyzw_1.x + -cb0_values[10].x);
                float r2_w_1 = ((float4(1, 1, 1, 1) / cb0_values[10].y)).w;
                float r2_w_2 = saturate((r1_w_3 * r2_w_1));
                float r3_w_2 = mad(r2_w_2, -2, 3);
                float r2_w_3 = (r2_w_2 * r2_w_2);
                float r2_w_4 = (r2_w_3 * r3_w_2);
                float r1_w_4 = (r1_w_3 < 0);
                if (r1_w_4) discard;
                float3 r5_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r1_w_5 = (unity_ProbeVolumeParams.x == 1);
                float r6_x_10;
                float r6_y_10;
                float r6_z_10;
                float r6_w_4;
                if (r1_w_5)
                {
                    float r1_w_6 = (unity_ProbeVolumeParams.y == 1);
                    float3 r6_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r1_w_6.xxxx ? r6_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r6_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r6_y_8 = r6_xyzw_8.y;
                    float r6_z_8 = r6_xyzw_8.z;
                    float r6_w_2 = r6_xyzw_8.w;
                    float r1_w_7 = mad(r6_y_8, 0.25, 0.75);
                    float r3_w_3 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r6_x_8 = max(r1_w_7, r3_w_3);
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
                float r1_w_9 = saturate(dot(float4(r6_x_10, r6_y_10, r6_z_10, r6_w_4), unity_OcclusionMaskSelector));
                float r3_w_5 = dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx);
                float4 r5_xyzw_5 = t2.Sample(sampler_linear_clamp1, (r3_w_5.xxxx).xy);
                float r1_w_10 = (r1_w_9 * r5_xyzw_5.x);
                float3 r5_xyz_6 = ((r1_w_10.xxxx * _LightColor0.xyzx)).xyz;
                float3 unitWorldNormal_xyz_11 = normalize(i.texcoord1);
                float3 r3_xyz_4 = (mad(cb0_values[10].zzzz, (mad(r3_xyz_2.xyzx, r2_w_4.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_13 = mad(-cb0_values[10].z, 0.96, 0.96);
                float r1_w_14 = (-cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_2.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitWorldNormal_xyz_11.xyzx, unitViewDir_xyz_2.xyzx);
                float r2_x_3 = saturate(dot(unitWorldNormal_xyz_11.xyzx, r1_xyz_1.xyzx));
                float r2_y_3 = saturate(dot(unitWorldNormal_xyz_11.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_14.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_x_3 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(nDotV_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_14 * r1_w_14);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(nDotV_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * mad(r2_x_3, r1_x_6, r0_z_8));
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
                float r0_w_11 = dot(r3_xyz_4.xyzx, r3_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * r5_xyz_6.xyzx);
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (r5_xyz_6.xxyz * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_15 = (r0_x_5 * r0_x_5);
                float r1_w_16 = (r1_w_15 * r1_w_15);
                float4 r2_xyzw_4 = (-r3_xyz_4.xyzx + float4(1, 1, 1, 0));
                float r2_x_4 = r2_xyzw_4.x;
                float r2_y_4 = r2_xyzw_4.y;
                float r2_z_3 = r2_xyzw_4.z;
                float4 r2_xyzw_5 = mad(float4(r2_x_4, r2_y_4, r2_z_3, r2_x_4), ((r0_x_5 * r1_w_16)).xxxx, r3_xyz_4.xyzx);
                float r2_x_5 = r2_xyzw_5.x;
                float r2_y_5 = r2_xyzw_5.y;
                float r2_z_4 = r2_xyzw_5.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_5, r2_y_5, r2_z_4, r2_x_5));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(((r1_w_13.xxxx * ((r2_w_4.xxxx * r3_xyz_2.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7))).xyz;
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
                float4 _Color : packoffset(c4);
                float4 _EdgeColor : packoffset(c5);
                float _Cutoff : packoffset(c6.x);
                float _EdgeWidth : packoffset(c6.y);
                float _Metallic : packoffset(c6.z);
                float _Smoothness : packoffset(c6.w);
                float4 _MainTex_ST : packoffset(c7);
                float4 _DissolveMap_ST : packoffset(c8);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
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
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program123Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
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
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _DissolveMap_ST.xxxy, _DissolveMap_ST.zzzw)).zw;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program123Output frag(program123Input i)
            {
                program123Output o = (program123Output)0;
                float4 r0_xyzw_1 = _DissolveMap.Sample(sampler_DissolveMap, (i.texcoord0.zwzz).xy);
                float r0_x_2 = (r0_xyzw_1.x + -_Cutoff);
                float r0_y_2 = (r0_x_2 < 0);
                if (r0_y_2) discard;
                float r0_y_3 = ((float4(1, 1, 1, 1) / _EdgeWidth)).y;
                float r0_x_3 = saturate((r0_y_3 * r0_x_2));
                float r0_y_4 = mad(r0_x_3, -2, 3);
                float r0_x_4 = (r0_x_3 * r0_x_3);
                float r0_z_2 = (r0_x_4 * r0_y_4);
                float4 r0_xyzw_6 = ((mad(-r0_y_4, r0_x_4, 1)).xxxx * _EdgeColor.xyxz);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_5 = r0_xyzw_6.y;
                float r0_w_2 = r0_xyzw_6.w;
                float4 r0_xyzw_7 = (float4(r0_x_6, r0_y_5, r0_x_6, r0_w_2) * _EdgeColor.wwww);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_6 = r0_xyzw_7.y;
                float r0_w_3 = r0_xyzw_7.w;
                o.sv_Target3.xyz = (exp2(-float4(r0_x_7, r0_y_6, r0_w_3, r0_x_7))).xyz;
                float4 r1_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r0_xyzw_8 = (r1_xyzw_1.xyxz * _Color.xyxz);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_7 = r0_xyzw_8.y;
                float r0_w_4 = r0_xyzw_8.w;
                float4 r0_xyzw_9 = mad(float4(r0_x_8, r0_y_7, r0_w_4, r0_x_8), r0_z_2.xxxx, float4(-0.04, -0.04, -0.04, 0));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_8 = r0_xyzw_9.y;
                float r0_z_3 = r0_xyzw_9.z;
                o.sv_Target1.xyz = (mad(_Metallic.xxxx, float4(r0_x_9, r0_y_8, r0_z_3, r0_x_9), float4(0.04, 0.04, 0.04, 0))).xyz;
                o.sv_Target0.xyz = (((mad(-_Metallic, 0.96, 0.96)).xxxx * ((r0_z_2.xxxx * float4(r0_x_8, r0_y_7, r0_w_4, r0_x_8))).xyzx)).xyz;
                o.sv_Target0.w = 1;
                o.sv_Target1.w = _Smoothness;
                o.sv_Target2.xyz = (mad(i.texcoord1.xyzx, float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
                o.sv_Target2.w = 1;
                o.sv_Target3.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="SHADOWCASTER" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float _Cutoff : packoffset(c6.x);
                float4 _DissolveMap_ST : packoffset(c7);
            };
            cbuffer _UnityLightingCB_b1
            {
                float4 _WorldSpaceLightPos0 : packoffset(c0);
            };
            cbuffer _UnityShadowsCB_b2
            {
                float4 unity_LightShadowBias : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b3
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b4
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program128Input
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
            struct program128Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program131Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program131Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program128Output vert(program128Input i)
            {
                program128Output o = (program128Output)0;
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
                float r0_w_9 = (unity_LightShadowBias.z != 0);
                float3 unity_LightShadowBiasSelect_xyz_4 = ((r0_w_9.xxxx ? (mad(-unitWorldNormal_xyz_2.xyzx, r0_w_8.xxxx, worldPos_xyzw_4.xyzx)).xyzx : worldPos_xyzw_4.xyzx)).xyz;
                float4 r2_xyzw_3 = (unity_LightShadowBiasSelect_xyz_4.yyyy * unity_MatrixVP[1]);
                float4 r2_xyzw_4 = mad(unity_MatrixVP[0], unity_LightShadowBiasSelect_xyz_4.xxxx, r2_xyzw_3);
                float4 r0_xyzw_5 = mad(unity_MatrixVP[2], unity_LightShadowBiasSelect_xyz_4.zzzz, r2_xyzw_4);
                float4 r0_xyzw_6 = mad(unity_MatrixVP[3], worldPos_xyzw_4.wwww, r0_xyzw_5);
                float r0_z_7 = (r0_xyzw_6.z + max(min((unity_LightShadowBias.x / r0_xyzw_6.w), 0), -1));
                o.sv_Position0.xyw = (r0_xyzw_6.xyxw).xyw;
                o.sv_Position0.z = mad(unity_LightShadowBias.y, (-r0_z_7 + min(r0_xyzw_6.w, r0_z_7)), r0_z_7);
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _DissolveMap_ST.xyxx, _DissolveMap_ST.zwzz)).xy;
                float4 worldPos_xyzw_8 = (i.position0.yyyy * unity_ObjectToWorld[1].xyzx);
                float worldPos_x_8 = worldPos_xyzw_8.x;
                float worldPos_y_7 = worldPos_xyzw_8.y;
                float worldPos_z_8 = worldPos_xyzw_8.z;
                float4 worldPos_xyzw_9 = mad(unity_ObjectToWorld[0].xyzx, i.position0.xxxx, float4(worldPos_x_8, worldPos_y_7, worldPos_z_8, worldPos_x_8));
                float worldPos_x_9 = worldPos_xyzw_9.x;
                float worldPos_y_8 = worldPos_xyzw_9.y;
                float worldPos_z_9 = worldPos_xyzw_9.z;
                float4 worldPos_xyzw_10 = mad(unity_ObjectToWorld[2].xyzx, i.position0.zzzz, float4(worldPos_x_9, worldPos_y_8, worldPos_z_9, worldPos_x_9));
                float worldPos_x_10 = worldPos_xyzw_10.x;
                float worldPos_y_9 = worldPos_xyzw_10.y;
                float worldPos_z_10 = worldPos_xyzw_10.z;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, float4(worldPos_x_10, worldPos_y_9, worldPos_z_10, worldPos_x_10))).xyz;
                return o;
            }
            #pragma fragment frag
            program131Output frag(program131Input i)
            {
                program131Output o = (program131Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord1.xyxx).xy);
                if ((((r0_xyzw_1.x + -_Cutoff) < 0)).x) discard;
                o.sv_Target0.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Standard"
}
