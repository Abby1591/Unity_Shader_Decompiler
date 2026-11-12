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
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[46];
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
                float4 cb3_values[26];
            };
            cbuffer cb4 : register(b4)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb4_values[21];
            };
            cbuffer cb5 : register(b5)
            {
                float4 cb5_values[2];
            };
            cbuffer cb6 : register(b6)
            {
                float4 cb6_values[8];
            };
            cbuffer cb7 : register(b7)
            {
                float4 cb7_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            Texture2D t2;
            TextureCube t3;
            TextureCube t4;
            Texture3D t5;
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
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord4 : TEXCOORD4;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program37Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord4 : TEXCOORD4;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program37Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program17Output vert(program17Input i)
            {
                program17Output o = (program17Output)0;
                float4 worldPos_xyzw_2 = mad(cb3_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb3_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb3_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb3_values[3].xyzw);
                o.texcoord2.xyz = (mad(cb3_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb4_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb4_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb4_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb4_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = mul(float4x4(cb4_values[17], cb4_values[18], cb4_values[19], cb4_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _DissolveMap_ST.xxxy, _DissolveMap_ST.zzzw)).zw;
                o.texcoord4.x = clipPos_xyzw_7.z;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb3_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb3_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb3_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                float3 unitWorldNormal_xyz_3 = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = unitWorldNormal_xyz_3.xyz;
                float r1_w_4 = (unitWorldNormal_xyz_3.y * unitWorldNormal_xyz_3.y);
                float r1_w_5 = mad(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.x, -r1_w_4);
                float4 r2_xyzw_1 = (unitWorldNormal_xyz_3.yzzx * unitWorldNormal_xyz_3.xyzz);
                float r1_x_4 = dot(cb2_values[42].xyzw, r2_xyzw_1);
                float r1_y_4 = dot(cb2_values[43].xyzw, r2_xyzw_1);
                float r1_z_4 = dot(cb2_values[44].xyzw, r2_xyzw_1);
                o.texcoord3.xyz = (mad(cb2_values[45].xyzx, r1_w_5.xxxx, float4(r1_x_4, r1_y_4, r1_z_4, r1_x_4))).xyz;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r1_xyzw_5 = (float4(clipPos_xyzw_7.x, clipPos_xyzw_7.x, clipPos_xyzw_7.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_5 = r1_xyzw_5.x;
                float r1_z_5 = r1_xyzw_5.z;
                float r1_w_6 = r1_xyzw_5.w;
                o.texcoord5.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord5.xy = ((r1_z_5.xxxx + float4(r1_x_5, r1_w_6, r1_x_5, r1_x_5))).xy;
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program37Output frag(program37Input i)
            {
                program37Output o = (program37Output)0;
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
                float r5_x_1 = cb4_values[9].z;
                float r5_y_1 = cb4_values[10].z;
                float r5_z_1 = cb4_values[11].z;
                float r1_w_4 = dot(viewDir_xyz_1.xyzx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1));
                float3 r5_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_5 = dot(r5_xyz_2.xyzx, r5_xyz_2.xyzx);
                float r2_w_6 = sqrt(r2_w_5);
                float r2_w_7 = (-r1_w_4 + r2_w_6);
                float r1_w_5 = mad(cb3_values[25].w, r2_w_7, r1_w_4);
                float r1_w_6 = saturate(mad(r1_w_5, cb3_values[24].z, cb3_values[24].w));
                float r2_w_8 = (cb7_values[0].x == 1);
                float r5_x_12;
                float r5_y_13;
                float r5_z_12;
                float r5_w_4;
                if (r2_w_8)
                {
                    float r4_w_1 = (cb7_values[0].y == 1);
                    float3 r5_xyz_7 = (((mad(cb7_values[3].xyzx, i.texcoord2.zzzz, (mad(cb7_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb7_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb7_values[4].xyzx)).xyz;
                    float4 r5_xyzw_10 = (((((r4_w_1.xxxx ? r5_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb7_values[6].xyzx)).xxyz * cb7_values[5].xxyz);
                    float r5_y_10 = r5_xyzw_10.y;
                    float r5_z_10 = r5_xyzw_10.z;
                    float r5_w_2 = r5_xyzw_10.w;
                    float r4_w_2 = mad(r5_y_10, 0.25, 0.75);
                    float r5_y_11 = mad(cb7_values[0].z, 0.5, 0.75);
                    float r5_x_10 = max(r4_w_2, r5_y_11);
                    float4 r5_xyzw_11 = t5.Sample(sampler_linear_clamp1, (float4(r5_x_10, r5_z_10, r5_w_2, r5_x_10)).xyz);
                    r5_x_12 = r5_xyzw_11.x;
                    r5_y_13 = r5_xyzw_11.y;
                    r5_z_12 = r5_xyzw_11.z;
                    r5_w_4 = r5_xyzw_11.w;
                }
                else
                {
                    float4 r5_xyzw_3 = float4(1, 1, 1, 1);
                    r5_x_12 = r5_xyzw_3.x;
                    r5_y_13 = r5_xyzw_3.y;
                    r5_z_12 = r5_xyzw_3.z;
                    r5_w_4 = r5_xyzw_3.w;
                }
                float r4_w_4 = saturate(dot(float4(r5_x_12, r5_y_13, r5_z_12, r5_w_4), unity_OcclusionMaskSelector));
                float4 r5_xyzw_13 = (i.texcoord5.xyxx / i.texcoord5.wwww);
                float r5_x_13 = r5_xyzw_13.x;
                float r5_y_14 = r5_xyzw_13.y;
                float4 r5_xyzw_14 = t2.Sample(sampler_linear_clamp2, (float4(r5_x_13, r5_y_14, r5_x_13, r5_x_13)).xy);
                float r4_w_5 = (r4_w_4 + -r5_xyzw_14.x);
                float r1_w_7 = mad(r1_w_6, r4_w_5, r5_xyzw_14.x);
                float r4_w_6 = (-_Smoothness + 1);
                float r5_x_15 = dot(-unitViewDir_xyz_1.xyzx, i.texcoord1.xyzx);
                float4 r5_xyzw_17 = mad(i.texcoord1.xyzx, ((r5_x_15 + r5_x_15)).xxxx, -unitViewDir_xyz_1.xyzx);
                float r5_x_17 = r5_xyzw_17.x;
                float r5_y_16 = r5_xyzw_17.y;
                float r5_z_14 = r5_xyzw_17.z;
                float3 r6_xyz_1 = ((r1_w_7.xxxx * _LightColor0.xyzx)).xyz;
                float3 TEXCOORD1_xyz_1;
                float3 r8_xyz_4;
                if (r2_w_8)
                {
                    float r1_w_8 = (cb7_values[0].y == 1);
                    float3 r7_xyz_5 = (((mad(cb7_values[3].xyzx, i.texcoord2.zzzz, (mad(cb7_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb7_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb7_values[4].xyzx)).xyz;
                    float4 r7_xyzw_8 = (((((r1_w_8.xxxx ? r7_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb7_values[6].xyzx)).xxyz * cb7_values[5].xxyz);
                    float r7_y_8 = r7_xyzw_8.y;
                    float r7_z_8 = r7_xyzw_8.z;
                    float r7_w_2 = r7_xyzw_8.w;
                    float r1_w_9 = (r7_y_8 * 0.25);
                    float r2_w_9 = (cb7_values[0].z * 0.5);
                    float r5_w_6 = mad(-cb7_values[0].z, 0.5, 0.25);
                    float r1_w_10 = max(r1_w_9, r2_w_9);
                    float r7_x_8 = min(r5_w_6, r1_w_10);
                    float4 r8_xyzw_2 = t5.Sample(sampler_linear_clamp1, (float4(r7_x_8, r7_z_8, r7_w_2, r7_x_8)).xyz);
                    float4 r9_xyzw_2 = t5.Sample(sampler_linear_clamp1, (((float4(r7_x_8, r7_z_8, r7_w_2, r7_x_8) + float4(0.25, 0, 0, 0))).xyzx).xyz);
                    float4 r7_xyzw_10 = t5.Sample(sampler_linear_clamp1, (((float4(r7_x_8, r7_z_8, r7_w_2, r7_x_8) + float4(0.5, 0, 0, 0))).xyzx).xyz);
                    TEXCOORD1_xyz_1 = i.texcoord1.xyz;
                    float r10_w_1 = 1;
                    float r8_x_3 = dot(r8_xyzw_2, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r10_w_1));
                    float r8_y_3 = dot(r9_xyzw_2, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r10_w_1));
                    float r8_z_3 = dot(r7_xyzw_10, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r10_w_1));
                    r8_xyz_4 = float3(r8_x_3, r8_y_3, r8_z_3);
                }
                else
                {
                    TEXCOORD1_xyz_1 = i.texcoord1.xyz;
                    float r7_w_1 = 1;
                    float r8_x_1 = dot(cb2_values[39].xyzw, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r7_w_1));
                    float r8_y_1 = dot(cb2_values[40].xyzw, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r7_w_1));
                    float r8_z_1 = dot(cb2_values[41].xyzw, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r7_w_1));
                    r8_xyz_4 = float3(r8_x_1, r8_y_1, r8_z_1);
                }
                float r1_w_12 = (0 < cb6_values[2].w);
                float3 r8_xyz_8;
                if (r1_w_12)
                {
                    float r1_w_13 = dot(float4(r5_x_17, r5_y_16, r5_z_14, r5_x_17), float4(r5_x_17, r5_y_16, r5_z_14, r5_x_17));
                    float r1_w_14 = rsqrt(r1_w_13);
                    float3 r8_xyz_6 = ((r1_w_14.xxxx * float4(r5_x_17, r5_y_16, r5_z_14, r5_x_17))).xyz;
                    float3 r11_xyz_1 = ((float4(0, 0, 0, 0) < r8_xyz_6.xyzx)).xyz;
                    float3 r9_xyz_6 = ((r11_xyz_1.xyzx ? ((((-i.texcoord2.xyzx + cb6_values[0].xyzx)).xyzx / r8_xyz_6.xyzx)).xyzx : ((((-i.texcoord2.xyzx + cb6_values[1].xyzx)).xyzx / r8_xyz_6.xyzx)).xyzx)).xyz;
                    float r1_w_15 = min(r9_xyz_6.y, r9_xyz_6.x);
                    float r1_w_16 = min(r9_xyz_6.z, r1_w_15);
                    r8_xyz_8 = (mad(r8_xyz_6.xyzx, r1_w_16.xxxx, ((i.texcoord2.xyzx + -cb6_values[2].xyzx)).xyzx)).xyz;
                }
                else
                {
                    r8_xyz_8 = (float4(r5_x_17, r5_y_16, r5_z_14, r5_x_17)).xyz;
                }
                float r1_w_18 = mad(-r4_w_6, 0.7, 1.7);
                float r1_w_19 = (r1_w_18 * r4_w_6);
                float r1_w_20 = (r1_w_19 * 6);
                float4 r8_xyzw_9 = t3.SampleLevel(sampler_linear_clamp, r8_xyz_8.xyz, r1_w_20);
                float r2_w_11 = (r8_xyzw_9.w + -1);
                float r2_w_12 = mad(cb6_values[3].w, r2_w_11, 1);
                float r2_w_13 = log2(r2_w_12);
                float r2_w_14 = (r2_w_13 * cb6_values[3].y);
                float r2_w_15 = exp2(r2_w_14);
                float r2_w_16 = (r2_w_15 * cb6_values[3].x);
                float r5_w_8 = (cb6_values[1].w < 0.99999);
                float3 r9_xyz_11 = ((r8_xyzw_9.xyzx * r2_w_16.xxxx)).xyz;
                if (r5_w_8)
                {
                    float r5_w_9 = (0 < cb6_values[6].w);
                    float r5_x_19 = r5_x_17;
                    float r5_y_18 = r5_y_16;
                    float r5_z_16 = r5_z_14;
                    if (r5_w_9)
                    {
                        float r5_w_10 = dot(float4(r5_x_17, r5_y_16, r5_z_14, r5_x_17), float4(r5_x_17, r5_y_16, r5_z_14, r5_x_17));
                        float r5_w_11 = rsqrt(r5_w_10);
                        float3 r10_xyz_6 = ((r5_w_11.xxxx * float4(r5_x_17, r5_y_16, r5_z_14, r5_x_17))).xyz;
                        float3 r13_xyz_1 = ((float4(0, 0, 0, 0) < r10_xyz_6.xyzx)).xyz;
                        float3 r11_xyz_5 = ((r13_xyz_1.xyzx ? ((((-i.texcoord2.xyzx + cb6_values[4].xyzx)).xyzx / r10_xyz_6.xyzx)).xyzx : ((((-i.texcoord2.xyzx + cb6_values[5].xyzx)).xyzx / r10_xyz_6.xyzx)).xyzx)).xyz;
                        float r5_w_12 = min(r11_xyz_5.y, r11_xyz_5.x);
                        float r5_w_13 = min(r11_xyz_5.z, r5_w_12);
                        float4 r5_xyzw_18 = mad(r10_xyz_6.xyzx, r5_w_13.xxxx, ((i.texcoord2.xyzx + -cb6_values[6].xyzx)).xyzx);
                        float r5_x_18 = r5_xyzw_18.x;
                        float r5_y_17 = r5_xyzw_18.y;
                        float r5_z_15 = r5_xyzw_18.z;
                        r5_x_19 = r5_x_18;
                        r5_y_18 = r5_y_17;
                        r5_z_16 = r5_z_15;
                    }
                    float4 r5_xyzw_20 = t4.SampleLevel(sampler_linear_clamp, (float4(r5_x_19, r5_y_18, r5_z_16, r5_x_19)).xyz, r1_w_20);
                    float r1_w_21 = (r5_xyzw_20.w + -1);
                    float r1_w_22 = mad(cb6_values[7].w, r1_w_21, 1);
                    float r1_w_23 = log2(r1_w_22);
                    float r1_w_24 = (r1_w_23 * cb6_values[7].y);
                    float r1_w_25 = exp2(r1_w_24);
                    float r1_w_26 = (r1_w_25 * cb6_values[7].x);
                    float4 r5_xyzw_21 = (r5_xyzw_20.xyzx * r1_w_26.xxxx);
                    float r5_x_21 = r5_xyzw_21.x;
                    float r5_y_20 = r5_xyzw_21.y;
                    float r5_z_18 = r5_xyzw_21.z;
                    r9_xyz_11 = (mad(cb6_values[1].wwww, (mad(r2_w_16.xxxx, r8_xyzw_9.xyzx, -float4(r5_x_21, r5_y_20, r5_z_18, r5_x_21))).xyzx, float4(r5_x_21, r5_y_20, r5_z_18, r5_x_21))).xyz;
                }
                float r1_w_28 = dot(i.texcoord1.xyzx, i.texcoord1.xyzx);
                float r1_w_29 = rsqrt(r1_w_28);
                float4 unitClipPos_xyzw_23 = (r1_w_29.xxxx * i.texcoord1.xyzx);
                float unitClipPos_x_23 = unitClipPos_xyzw_23.x;
                float unitClipPos_y_22 = unitClipPos_xyzw_23.y;
                float unitClipPos_z_20 = unitClipPos_xyzw_23.z;
                float3 r2_xyz_4 = (mad(_Metallic.xxxx, (mad(r2_xyz_2.xyzx, r3_y_2.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_30 = mad(-_Metallic, 0.96, 0.96);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(float4(unitClipPos_x_23, unitClipPos_y_22, unitClipPos_z_20, unitClipPos_x_23), unitViewDir_xyz_1.xyzx);
                float r1_x_2 = saturate(dot(float4(unitClipPos_x_23, unitClipPos_y_22, unitClipPos_z_20, unitClipPos_x_23), _WorldSpaceLightPos0.xyzx));
                float r1_y_2 = saturate(dot(float4(unitClipPos_x_23, unitClipPos_y_22, unitClipPos_z_20, unitClipPos_x_23), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r4_w_6.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(nDotV_w_6) + 1);
                float r2_w_17 = (r1_z_4 * r1_z_4);
                float r2_w_18 = (r2_w_17 * r2_w_17);
                float r1_z_5 = (r1_z_4 * r2_w_18);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r4_w_6 * r4_w_6);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r2_w_19 = (-r0_z_8 + 1);
                float r3_y_3 = mad(abs(nDotV_w_6), r2_w_19, r0_z_8);
                float r2_w_20 = mad(r1_x_2, r2_w_19, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * r2_w_20);
                float r0_w_8 = mad(r1_x_2, r3_y_3, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r2_w_21 = (r0_z_8 * r0_z_8);
                float r3_y_4 = mad(r1_y_2, r2_w_21, -r1_y_2);
                float r1_y_3 = mad(r3_y_4, r1_y_2, 1);
                float r2_w_22 = (r2_w_21 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r1_y_5 = (r2_w_22 / r1_y_4);
                float r0_w_11 = (r0_w_10 * r1_y_5);
                float r0_w_12 = (r0_w_11 * 3.1415927);
                float4 r0_xyzw_9 = (r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_y_8, r0_w_12));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_w_13 = r0_xyzw_9.w;
                float r0_w_14 = max(r0_w_13, 0);
                float r0_z_9 = mad(r0_z_8, r0_z_8, 1);
                float r0_z_10 = ((float4(1, 1, 1, 1) / r0_z_9)).z;
                float r0_w_15 = (r0_w_14 * asfloat(asint((float)((dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx) != 0))) & asint(1065353216)));
                float4 r5_xyzw_24 = mad(r6_xyz_1.xyzx, r0_y_9.xxxx, (max(((r8_xyz_4.xyzx + i.texcoord3.xyzx)).xyzx, float4(0, 0, 0, 0))).xyzx);
                float r5_x_24 = r5_xyzw_24.x;
                float r5_y_23 = r5_xyzw_24.y;
                float r5_z_21 = r5_xyzw_24.z;
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
                float r0_x_9 = (mad(((r1_w_30.xxxx * ((r2_xyz_2.xyzx * r3_y_2.xxxx)).xyzx)).xyxz, float4(r5_x_24, r5_y_23, r5_x_24, r5_z_21), float4(r0_x_8, r0_y_13, r0_x_8, r0_w_17))).x;
                float4 r0_xyzw_14 = mad(((r1_w_30.xxxx * ((r2_xyz_2.xyzx * r3_y_2.xxxx)).xyzx)).xyxz, float4(r5_x_24, r5_y_23, r5_x_24, r5_z_21), float4(r0_x_8, r0_y_13, r0_x_8, r0_w_17));
                float r0_y_14 = r0_xyzw_14.y;
                float r0_w_18 = r0_xyzw_14.w;
                float4 r1_xyzw_8 = (-r2_xyz_4.xyxz + (saturate(((-r1_w_30 + _Smoothness) + 1))).xxxx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_w_31 = r1_xyzw_8.w;
                float4 r1_xyzw_9 = mad(r1_z_5.xxxx, float4(r1_x_8, r1_y_6, r1_w_31, r1_x_8), r2_xyz_4.xyzx);
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_7 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r0_xyzw_10 = mad(((r9_xyz_11.xyzx * r0_z_10.xxxx)).xyzx, float4(r1_x_9, r1_y_7, r1_z_6, r1_x_9), float4(r0_x_9, r0_y_14, r0_w_18, r0_x_9));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_15 = r0_xyzw_10.y;
                float r0_z_11 = r0_xyzw_10.z;
                float4 r0_xyzw_11 = mad(float4(r3_x_3, r3_z_2, r3_w_2, r3_x_3), _EdgeColor.wwww, float4(r0_x_10, r0_y_15, r0_z_11, r0_x_10));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_y_16 = r0_xyzw_11.y;
                float r0_z_12 = r0_xyzw_11.z;
                float r0_w_19 = (i.texcoord4.x / cb1_values[5].y);
                float r0_w_20 = (-r0_w_19 + 1);
                float r0_w_21 = (r0_w_20 * cb1_values[5].z);
                float r0_w_22 = max(r0_w_21, 0);
                float r0_w_23 = saturate(mad(r0_w_22, cb5_values[1].z, cb5_values[1].w));
                float4 r0_xyzw_12 = (float4(r0_x_11, r0_y_16, r0_z_12, r0_x_11) + -cb5_values[0].xyzx);
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_17 = r0_xyzw_12.y;
                float r0_z_13 = r0_xyzw_12.z;
                o.sv_Target0.xyz = (mad(r0_w_23.xxxx, float4(r0_x_12, r0_y_17, r0_z_13, r0_x_12), cb5_values[0].xyzx)).xyz;
                o.sv_Target0.w = 1;
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
                float4 unity_SpecCube0_BoxMax;
                float4 unity_SpecCube0_BoxMin;
                float4 unity_SpecCube0_ProbePosition;
                float4 unity_SpecCube0_HDR;
                float4 unity_SpecCube1_BoxMax;
                float4 unity_SpecCube1_BoxMin;
                float4 unity_SpecCube1_ProbePosition;
                float4 unity_SpecCube1_HDR;
                float4 cb3_values[26];
            };
            cbuffer _UnityProbeVolumeCB_b4
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb4_values[12];
            };
            cbuffer cb5 : register(b5)
            {
                float4 cb5_values[2];
            };
            cbuffer cb6 : register(b6)
            {
                float4 cb6_values[8];
            };
            cbuffer cb7 : register(b7)
            {
                float4 cb7_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            Texture2D t2;
            TextureCube t3;
            TextureCube t4;
            Texture3D t5;
            struct program16Input
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
            struct program16Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord4 : TEXCOORD4;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program36Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord4 : TEXCOORD4;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program36Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program16Output vert(program16Input i)
            {
                program16Output o = (program16Output)0;
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
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _DissolveMap_ST.xxxy, _DissolveMap_ST.zzzw)).zw;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord4.x = clipPos_xyzw_7.z;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r1_xyzw_3 = (float4(clipPos_xyzw_7.x, clipPos_xyzw_7.x, clipPos_xyzw_7.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_z_3 = r1_xyzw_3.z;
                float r1_w_4 = r1_xyzw_3.w;
                o.texcoord5.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord5.xy = ((r1_z_3.xxxx + float4(r1_x_3, r1_w_4, r1_x_3, r1_x_3))).xy;
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program36Output frag(program36Input i)
            {
                program36Output o = (program36Output)0;
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
                float r5_x_1 = cb4_values[9].z;
                float r5_y_1 = cb4_values[10].z;
                float r5_z_1 = cb4_values[11].z;
                float r1_w_4 = dot(viewDir_xyz_1.xyzx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1));
                float3 r5_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_5 = dot(r5_xyz_2.xyzx, r5_xyz_2.xyzx);
                float r2_w_6 = sqrt(r2_w_5);
                float r2_w_7 = (-r1_w_4 + r2_w_6);
                float r1_w_5 = mad(cb3_values[25].w, r2_w_7, r1_w_4);
                float r1_w_6 = saturate(mad(r1_w_5, cb3_values[24].z, cb3_values[24].w));
                float r2_w_8 = (cb7_values[0].x == 1);
                float r5_x_12;
                float r5_y_12;
                float r5_z_12;
                float r5_w_4;
                if (r2_w_8)
                {
                    float r2_w_9 = (cb7_values[0].y == 1);
                    float3 r5_xyz_7 = (((mad(cb7_values[3].xyzx, i.texcoord2.zzzz, (mad(cb7_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb7_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb7_values[4].xyzx)).xyz;
                    float4 r5_xyzw_10 = (((((r2_w_9.xxxx ? r5_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb7_values[6].xyzx)).xxyz * cb7_values[5].xxyz);
                    float r5_y_10 = r5_xyzw_10.y;
                    float r5_z_10 = r5_xyzw_10.z;
                    float r5_w_2 = r5_xyzw_10.w;
                    float r2_w_10 = mad(r5_y_10, 0.25, 0.75);
                    float r4_w_1 = mad(cb7_values[0].z, 0.5, 0.75);
                    float r5_x_10 = max(r2_w_10, r4_w_1);
                    float4 r5_xyzw_11 = t5.Sample(sampler_linear_clamp1, (float4(r5_x_10, r5_z_10, r5_w_2, r5_x_10)).xyz);
                    r5_x_12 = r5_xyzw_11.x;
                    r5_y_12 = r5_xyzw_11.y;
                    r5_z_12 = r5_xyzw_11.z;
                    r5_w_4 = r5_xyzw_11.w;
                }
                else
                {
                    float4 r5_xyzw_3 = float4(1, 1, 1, 1);
                    r5_x_12 = r5_xyzw_3.x;
                    r5_y_12 = r5_xyzw_3.y;
                    r5_z_12 = r5_xyzw_3.z;
                    r5_w_4 = r5_xyzw_3.w;
                }
                float r2_w_12 = saturate(dot(float4(r5_x_12, r5_y_12, r5_z_12, r5_w_4), unity_OcclusionMaskSelector));
                float4 r5_xyzw_14 = t2.Sample(sampler_linear_clamp2, (((i.texcoord5.xyxx / i.texcoord5.wwww)).xyxx).xy);
                float r2_w_13 = (r2_w_12 + -r5_xyzw_14.x);
                float r1_w_7 = mad(r1_w_6, r2_w_13, r5_xyzw_14.x);
                float r2_w_14 = (-_Smoothness + 1);
                float r4_w_3 = dot(-unitViewDir_xyz_1.xyzx, i.texcoord1.xyzx);
                float r4_w_4 = (r4_w_3 + r4_w_3);
                float4 r5_xyzw_15 = mad(i.texcoord1.xyzx, -r4_w_4.xxxx, -unitViewDir_xyz_1.xyzx);
                float r5_x_15 = r5_xyzw_15.x;
                float r5_y_15 = r5_xyzw_15.y;
                float r5_z_14 = r5_xyzw_15.z;
                float3 r6_xyz_1 = ((r1_w_7.xxxx * _LightColor0.xyzx)).xyz;
                float r1_w_8 = (0 < cb6_values[2].w);
                float3 r7_xyz_4;
                if (r1_w_8)
                {
                    float r1_w_9 = dot(float4(r5_x_15, r5_y_15, r5_z_14, r5_x_15), float4(r5_x_15, r5_y_15, r5_z_14, r5_x_15));
                    float r1_w_10 = rsqrt(r1_w_9);
                    float3 r7_xyz_2 = ((r1_w_10.xxxx * float4(r5_x_15, r5_y_15, r5_z_14, r5_x_15))).xyz;
                    float3 r10_xyz_1 = ((float4(0, 0, 0, 0) < r7_xyz_2.xyzx)).xyz;
                    float3 r8_xyz_3 = ((r10_xyz_1.xyzx ? ((((-i.texcoord2.xyzx + cb6_values[0].xyzx)).xyzx / r7_xyz_2.xyzx)).xyzx : ((((-i.texcoord2.xyzx + cb6_values[1].xyzx)).xyzx / r7_xyz_2.xyzx)).xyzx)).xyz;
                    float r1_w_11 = min(r8_xyz_3.y, r8_xyz_3.x);
                    float r1_w_12 = min(r8_xyz_3.z, r1_w_11);
                    r7_xyz_4 = (mad(r7_xyz_2.xyzx, r1_w_12.xxxx, ((i.texcoord2.xyzx + -cb6_values[2].xyzx)).xyzx)).xyz;
                }
                else
                {
                    r7_xyz_4 = (float4(r5_x_15, r5_y_15, r5_z_14, r5_x_15)).xyz;
                }
                float r1_w_14 = mad(-r2_w_14, 0.7, 1.7);
                float r1_w_15 = (r1_w_14 * r2_w_14);
                float r1_w_16 = (r1_w_15 * 6);
                float4 r7_xyzw_5 = t3.SampleLevel(sampler_linear_clamp, r7_xyz_4.xyz, r1_w_16);
                float r4_w_5 = (r7_xyzw_5.w + -1);
                float r4_w_6 = mad(cb6_values[3].w, r4_w_5, 1);
                float r4_w_7 = log2(r4_w_6);
                float r4_w_8 = (r4_w_7 * cb6_values[3].y);
                float r4_w_9 = exp2(r4_w_8);
                float r4_w_10 = (r4_w_9 * cb6_values[3].x);
                float r5_w_6 = (cb6_values[1].w < 0.99999);
                float3 r8_xyz_8 = ((r7_xyzw_5.xyzx * r4_w_10.xxxx)).xyz;
                if (r5_w_6)
                {
                    float r5_w_7 = (0 < cb6_values[6].w);
                    float r5_x_17 = r5_x_15;
                    float r5_y_17 = r5_y_15;
                    float r5_z_16 = r5_z_14;
                    if (r5_w_7)
                    {
                        float r5_w_8 = dot(float4(r5_x_15, r5_y_15, r5_z_14, r5_x_15), float4(r5_x_15, r5_y_15, r5_z_14, r5_x_15));
                        float r5_w_9 = rsqrt(r5_w_8);
                        float3 r9_xyz_4 = ((r5_w_9.xxxx * float4(r5_x_15, r5_y_15, r5_z_14, r5_x_15))).xyz;
                        float3 r12_xyz_1 = ((float4(0, 0, 0, 0) < r9_xyz_4.xyzx)).xyz;
                        float3 r10_xyz_5 = ((r12_xyz_1.xyzx ? ((((-i.texcoord2.xyzx + cb6_values[4].xyzx)).xyzx / r9_xyz_4.xyzx)).xyzx : ((((-i.texcoord2.xyzx + cb6_values[5].xyzx)).xyzx / r9_xyz_4.xyzx)).xyzx)).xyz;
                        float r5_w_10 = min(r10_xyz_5.y, r10_xyz_5.x);
                        float r5_w_11 = min(r10_xyz_5.z, r5_w_10);
                        float4 r5_xyzw_16 = mad(r9_xyz_4.xyzx, r5_w_11.xxxx, ((i.texcoord2.xyzx + -cb6_values[6].xyzx)).xyzx);
                        float r5_x_16 = r5_xyzw_16.x;
                        float r5_y_16 = r5_xyzw_16.y;
                        float r5_z_15 = r5_xyzw_16.z;
                        r5_x_17 = r5_x_16;
                        r5_y_17 = r5_y_16;
                        r5_z_16 = r5_z_15;
                    }
                    float4 r5_xyzw_18 = t4.SampleLevel(sampler_linear_clamp, (float4(r5_x_17, r5_y_17, r5_z_16, r5_x_17)).xyz, r1_w_16);
                    float r1_w_17 = (r5_xyzw_18.w + -1);
                    float r1_w_18 = mad(cb6_values[7].w, r1_w_17, 1);
                    float r1_w_19 = log2(r1_w_18);
                    float r1_w_20 = (r1_w_19 * cb6_values[7].y);
                    float r1_w_21 = exp2(r1_w_20);
                    float r1_w_22 = (r1_w_21 * cb6_values[7].x);
                    float4 r5_xyzw_19 = (r5_xyzw_18.xyzx * r1_w_22.xxxx);
                    float r5_x_19 = r5_xyzw_19.x;
                    float r5_y_19 = r5_xyzw_19.y;
                    float r5_z_18 = r5_xyzw_19.z;
                    r8_xyz_8 = (mad(cb6_values[1].wwww, (mad(r4_w_10.xxxx, r7_xyzw_5.xyzx, -float4(r5_x_19, r5_y_19, r5_z_18, r5_x_19))).xyzx, float4(r5_x_19, r5_y_19, r5_z_18, r5_x_19))).xyz;
                }
                float r1_w_24 = dot(i.texcoord1.xyzx, i.texcoord1.xyzx);
                float r1_w_25 = rsqrt(r1_w_24);
                float4 unitWorldNormal_xyzw_21 = (r1_w_25.xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_21 = unitWorldNormal_xyzw_21.x;
                float unitWorldNormal_y_21 = unitWorldNormal_xyzw_21.y;
                float unitWorldNormal_z_20 = unitWorldNormal_xyzw_21.z;
                float3 r2_xyz_4 = (mad(_Metallic.xxxx, (mad(r2_xyz_2.xyzx, r3_y_2.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_26 = mad(-_Metallic, 0.96, 0.96);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(float4(unitWorldNormal_x_21, unitWorldNormal_y_21, unitWorldNormal_z_20, unitWorldNormal_x_21), unitViewDir_xyz_1.xyzx);
                float r1_x_2 = saturate(dot(float4(unitWorldNormal_x_21, unitWorldNormal_y_21, unitWorldNormal_z_20, unitWorldNormal_x_21), _WorldSpaceLightPos0.xyzx));
                float r1_y_2 = saturate(dot(float4(unitWorldNormal_x_21, unitWorldNormal_y_21, unitWorldNormal_z_20, unitWorldNormal_x_21), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r2_w_14.xxxx);
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
                float r0_z_7 = (r2_w_14 * r2_w_14);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r2_w_15 = (-r0_z_8 + 1);
                float r3_y_5 = mad(abs(nDotV_w_6), r2_w_15, r0_z_8);
                float r2_w_16 = mad(r1_x_2, r2_w_15, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * r2_w_16);
                float r0_w_8 = mad(r1_x_2, r3_y_5, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r2_w_17 = (r0_z_8 * r0_z_8);
                float r3_y_6 = mad(r1_y_2, r2_w_17, -r1_y_2);
                float r1_y_3 = mad(r3_y_6, r1_y_2, 1);
                float r2_w_18 = (r2_w_17 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r1_y_5 = (r2_w_18 / r1_y_4);
                float r0_w_11 = (r0_w_10 * r1_y_5);
                float r0_w_12 = (r0_w_11 * 3.1415927);
                float4 r0_xyzw_9 = (r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_y_8, r0_w_12));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_w_13 = r0_xyzw_9.w;
                float r0_w_14 = max(r0_w_13, 0);
                float r0_z_9 = mad(r0_z_8, r0_z_8, 1);
                float r0_z_10 = ((float4(1, 1, 1, 1) / r0_z_9)).z;
                float r0_w_15 = (r0_w_14 * asfloat(asint((float)((dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx) != 0))) & asint(1065353216)));
                float4 r5_xyzw_22 = (r0_y_9.xxxx * r6_xyz_1.xyzx);
                float r5_x_22 = r5_xyzw_22.x;
                float r5_y_22 = r5_xyzw_22.y;
                float r5_z_21 = r5_xyzw_22.z;
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
                float r0_x_9 = (mad(((r1_w_26.xxxx * ((r2_xyz_2.xyzx * r3_y_2.xxxx)).xyzx)).xyxz, float4(r5_x_22, r5_y_22, r5_x_22, r5_z_21), float4(r0_x_8, r0_y_13, r0_x_8, r0_w_17))).x;
                float4 r0_xyzw_14 = mad(((r1_w_26.xxxx * ((r2_xyz_2.xyzx * r3_y_2.xxxx)).xyzx)).xyxz, float4(r5_x_22, r5_y_22, r5_x_22, r5_z_21), float4(r0_x_8, r0_y_13, r0_x_8, r0_w_17));
                float r0_y_14 = r0_xyzw_14.y;
                float r0_w_18 = r0_xyzw_14.w;
                float4 r1_xyzw_8 = (-r2_xyz_4.xyxz + (saturate(((-r1_w_26 + _Smoothness) + 1))).xxxx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_w_27 = r1_xyzw_8.w;
                float4 r1_xyzw_9 = mad(r1_z_5.xxxx, float4(r1_x_8, r1_y_6, r1_w_27, r1_x_8), r2_xyz_4.xyzx);
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_7 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r0_xyzw_10 = mad(((r8_xyz_8.xyzx * r0_z_10.xxxx)).xyzx, float4(r1_x_9, r1_y_7, r1_z_6, r1_x_9), float4(r0_x_9, r0_y_14, r0_w_18, r0_x_9));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_15 = r0_xyzw_10.y;
                float r0_z_11 = r0_xyzw_10.z;
                float4 r0_xyzw_11 = mad(float4(r3_x_3, r3_z_2, r3_w_2, r3_x_3), _EdgeColor.wwww, float4(r0_x_10, r0_y_15, r0_z_11, r0_x_10));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_y_16 = r0_xyzw_11.y;
                float r0_z_12 = r0_xyzw_11.z;
                float r0_w_19 = (i.texcoord4.x / cb1_values[5].y);
                float r0_w_20 = (-r0_w_19 + 1);
                float r0_w_21 = (r0_w_20 * cb1_values[5].z);
                float r0_w_22 = max(r0_w_21, 0);
                float r0_w_23 = saturate(mad(r0_w_22, cb5_values[1].z, cb5_values[1].w));
                float4 r0_xyzw_12 = (float4(r0_x_11, r0_y_16, r0_z_12, r0_x_11) + -cb5_values[0].xyzx);
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_17 = r0_xyzw_12.y;
                float r0_z_13 = r0_xyzw_12.z;
                o.sv_Target0.xyz = (mad(r0_w_23.xxxx, float4(r0_x_12, r0_y_17, r0_z_13, r0_x_12), cb5_values[0].xyzx)).xyz;
                o.sv_Target0.w = 1;
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
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[46];
            };
            cbuffer _UnityPerFrameCB_b2
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
            cbuffer _UnityProbeVolumeCB_b4
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
            SamplerState sampler_linear_clamp;
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_MainTex;
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            TextureCube t2;
            TextureCube t3;
            Texture3D t4;
            struct program15Input
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
            struct program15Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord4 : TEXCOORD4;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program35Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord4 : TEXCOORD4;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program35Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program15Output vert(program15Input i)
            {
                program15Output o = (program15Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord4.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _DissolveMap_ST.xxxy, _DissolveMap_ST.zzzw)).zw;
                float worldNormal_x_8 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                float3 unitWorldNormal_xyz_9 = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                o.texcoord1.xyz = unitWorldNormal_xyz_9.xyz;
                float r0_w_10 = (unitWorldNormal_xyz_9.y * unitWorldNormal_xyz_9.y);
                float r0_w_11 = mad(unitWorldNormal_xyz_9.x, unitWorldNormal_xyz_9.x, -r0_w_10);
                float4 r1_xyzw_2 = (unitWorldNormal_xyz_9.yzzx * unitWorldNormal_xyz_9.xyzz);
                float r0_x_10 = dot(cb1_values[42].xyzw, r1_xyzw_2);
                float r0_y_10 = dot(cb1_values[43].xyzw, r1_xyzw_2);
                float r0_z_10 = dot(cb1_values[44].xyzw, r1_xyzw_2);
                o.texcoord3.xyz = (mad(cb1_values[45].xyzx, r0_w_11.xxxx, float4(r0_x_10, r0_y_10, r0_z_10, r0_x_10))).xyz;
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program35Output frag(program35Input i)
            {
                program35Output o = (program35Output)0;
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
                float r1_w_4 = (cb5_values[0].x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r1_w_4)
                {
                    float r2_w_5 = (cb5_values[0].y == 1);
                    float3 r5_xyz_5 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r5_xyzw_8 = (((((r2_w_5.xxxx ? r5_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r2_w_6 = mad(r5_y_8, 0.25, 0.75);
                    float r4_w_1 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r5_x_8 = max(r2_w_6, r4_w_1);
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
                float r2_w_8 = saturate(dot(float4(r5_x_10, r5_y_10, r5_z_10, r5_w_4), unity_OcclusionMaskSelector));
                float r4_w_3 = (-_Smoothness + 1);
                float r5_x_11 = dot(-unitViewDir_xyz_1.xyzx, i.texcoord1.xyzx);
                float4 r5_xyzw_13 = mad(i.texcoord1.xyzx, ((r5_x_11 + r5_x_11)).xxxx, -unitViewDir_xyz_1.xyzx);
                float r5_x_13 = r5_xyzw_13.x;
                float r5_y_11 = r5_xyzw_13.y;
                float r5_z_11 = r5_xyzw_13.z;
                float3 r6_xyz_1 = ((r2_w_8.xxxx * _LightColor0.xyzx)).xyz;
                float3 TEXCOORD1_xyz_1;
                float3 r8_xyz_4;
                if (r1_w_4)
                {
                    float r1_w_5 = (cb5_values[0].y == 1);
                    float3 r7_xyz_5 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r7_xyzw_8 = (((((r1_w_5.xxxx ? r7_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r7_y_8 = r7_xyzw_8.y;
                    float r7_z_8 = r7_xyzw_8.z;
                    float r7_w_2 = r7_xyzw_8.w;
                    float r1_w_6 = (r7_y_8 * 0.25);
                    float r2_w_9 = (cb5_values[0].z * 0.5);
                    float r5_w_5 = mad(-cb5_values[0].z, 0.5, 0.25);
                    float r1_w_7 = max(r1_w_6, r2_w_9);
                    float r7_x_8 = min(r5_w_5, r1_w_7);
                    float4 r8_xyzw_2 = t4.Sample(sampler_linear_clamp1, (float4(r7_x_8, r7_z_8, r7_w_2, r7_x_8)).xyz);
                    float4 r9_xyzw_2 = t4.Sample(sampler_linear_clamp1, (((float4(r7_x_8, r7_z_8, r7_w_2, r7_x_8) + float4(0.25, 0, 0, 0))).xyzx).xyz);
                    float4 r7_xyzw_10 = t4.Sample(sampler_linear_clamp1, (((float4(r7_x_8, r7_z_8, r7_w_2, r7_x_8) + float4(0.5, 0, 0, 0))).xyzx).xyz);
                    TEXCOORD1_xyz_1 = i.texcoord1.xyz;
                    float r10_w_1 = 1;
                    float r8_x_3 = dot(r8_xyzw_2, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r10_w_1));
                    float r8_y_3 = dot(r9_xyzw_2, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r10_w_1));
                    float r8_z_3 = dot(r7_xyzw_10, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r10_w_1));
                    r8_xyz_4 = float3(r8_x_3, r8_y_3, r8_z_3);
                }
                else
                {
                    TEXCOORD1_xyz_1 = i.texcoord1.xyz;
                    float r7_w_1 = 1;
                    float r8_x_1 = dot(cb2_values[39].xyzw, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r7_w_1));
                    float r8_y_1 = dot(cb2_values[40].xyzw, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r7_w_1));
                    float r8_z_1 = dot(cb2_values[41].xyzw, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r7_w_1));
                    r8_xyz_4 = float3(r8_x_1, r8_y_1, r8_z_1);
                }
                float r1_w_9 = (0 < unity_ProbeVolumeWorldToObject[1].w);
                float3 r8_xyz_8;
                if (r1_w_9)
                {
                    float r1_w_10 = dot(float4(r5_x_13, r5_y_11, r5_z_11, r5_x_13), float4(r5_x_13, r5_y_11, r5_z_11, r5_x_13));
                    float r1_w_11 = rsqrt(r1_w_10);
                    float3 r8_xyz_6 = ((r1_w_11.xxxx * float4(r5_x_13, r5_y_11, r5_z_11, r5_x_13))).xyz;
                    float3 r11_xyz_1 = ((float4(0, 0, 0, 0) < r8_xyz_6.xyzx)).xyz;
                    float3 r9_xyz_6 = ((r11_xyz_1.xyzx ? ((((-i.texcoord2.xyzx + unity_ProbeVolumeParams.xyzx)).xyzx / r8_xyz_6.xyzx)).xyzx : ((((-i.texcoord2.xyzx + unity_ProbeVolumeWorldToObject[0].xyzx)).xyzx / r8_xyz_6.xyzx)).xyzx)).xyz;
                    float r1_w_12 = min(r9_xyz_6.y, r9_xyz_6.x);
                    float r1_w_13 = min(r9_xyz_6.z, r1_w_12);
                    r8_xyz_8 = (mad(r8_xyz_6.xyzx, r1_w_13.xxxx, ((i.texcoord2.xyzx + -unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyz;
                }
                else
                {
                    r8_xyz_8 = (float4(r5_x_13, r5_y_11, r5_z_11, r5_x_13)).xyz;
                }
                float r1_w_15 = mad(-r4_w_3, 0.7, 1.7);
                float r1_w_16 = (r1_w_15 * r4_w_3);
                float r1_w_17 = (r1_w_16 * 6);
                float4 r8_xyzw_9 = t2.SampleLevel(sampler_linear_clamp, r8_xyz_8.xyz, r1_w_17);
                float r2_w_11 = (r8_xyzw_9.w + -1);
                float r2_w_12 = mad(unity_ProbeVolumeWorldToObject[2].w, r2_w_11, 1);
                float r2_w_13 = log2(r2_w_12);
                float r2_w_14 = (r2_w_13 * unity_ProbeVolumeWorldToObject[2].y);
                float r2_w_15 = exp2(r2_w_14);
                float r2_w_16 = (r2_w_15 * unity_ProbeVolumeWorldToObject[2].x);
                float r5_w_7 = (unity_ProbeVolumeWorldToObject[0].w < 0.99999);
                float3 r9_xyz_11 = ((r8_xyzw_9.xyzx * r2_w_16.xxxx)).xyz;
                if (r5_w_7)
                {
                    float r5_w_8 = (0 < cb4_values[6].w);
                    float r5_x_15 = r5_x_13;
                    float r5_y_13 = r5_y_11;
                    float r5_z_13 = r5_z_11;
                    if (r5_w_8)
                    {
                        float r5_w_9 = dot(float4(r5_x_13, r5_y_11, r5_z_11, r5_x_13), float4(r5_x_13, r5_y_11, r5_z_11, r5_x_13));
                        float r5_w_10 = rsqrt(r5_w_9);
                        float3 r10_xyz_6 = ((r5_w_10.xxxx * float4(r5_x_13, r5_y_11, r5_z_11, r5_x_13))).xyz;
                        float3 r13_xyz_1 = ((float4(0, 0, 0, 0) < r10_xyz_6.xyzx)).xyz;
                        float3 r11_xyz_5 = ((r13_xyz_1.xyzx ? ((((-i.texcoord2.xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyzx / r10_xyz_6.xyzx)).xyzx : ((((-i.texcoord2.xyzx + unity_ProbeVolumeSizeInv.xyzx)).xyzx / r10_xyz_6.xyzx)).xyzx)).xyz;
                        float r5_w_11 = min(r11_xyz_5.y, r11_xyz_5.x);
                        float r5_w_12 = min(r11_xyz_5.z, r5_w_11);
                        float4 r5_xyzw_14 = mad(r10_xyz_6.xyzx, r5_w_12.xxxx, ((i.texcoord2.xyzx + -unity_ProbeVolumeMin.xyzx)).xyzx);
                        float r5_x_14 = r5_xyzw_14.x;
                        float r5_y_12 = r5_xyzw_14.y;
                        float r5_z_12 = r5_xyzw_14.z;
                        r5_x_15 = r5_x_14;
                        r5_y_13 = r5_y_12;
                        r5_z_13 = r5_z_12;
                    }
                    float4 r5_xyzw_16 = t3.SampleLevel(sampler_linear_clamp, (float4(r5_x_15, r5_y_13, r5_z_13, r5_x_15)).xyz, r1_w_17);
                    float r1_w_18 = (r5_xyzw_16.w + -1);
                    float r1_w_19 = mad(cb4_values[7].w, r1_w_18, 1);
                    float r1_w_20 = log2(r1_w_19);
                    float r1_w_21 = (r1_w_20 * cb4_values[7].y);
                    float r1_w_22 = exp2(r1_w_21);
                    float r1_w_23 = (r1_w_22 * cb4_values[7].x);
                    float4 r5_xyzw_17 = (r5_xyzw_16.xyzx * r1_w_23.xxxx);
                    float r5_x_17 = r5_xyzw_17.x;
                    float r5_y_15 = r5_xyzw_17.y;
                    float r5_z_15 = r5_xyzw_17.z;
                    r9_xyz_11 = (mad(unity_ProbeVolumeWorldToObject[0].wwww, (mad(r2_w_16.xxxx, r8_xyzw_9.xyzx, -float4(r5_x_17, r5_y_15, r5_z_15, r5_x_17))).xyzx, float4(r5_x_17, r5_y_15, r5_z_15, r5_x_17))).xyz;
                }
                float r1_w_25 = dot(i.texcoord1.xyzx, i.texcoord1.xyzx);
                float r1_w_26 = rsqrt(r1_w_25);
                float4 unitClipPos_xyzw_19 = (r1_w_26.xxxx * i.texcoord1.xyzx);
                float unitClipPos_x_19 = unitClipPos_xyzw_19.x;
                float unitClipPos_y_17 = unitClipPos_xyzw_19.y;
                float unitClipPos_z_17 = unitClipPos_xyzw_19.z;
                float3 r2_xyz_4 = (mad(_Metallic.xxxx, (mad(r2_xyz_2.xyzx, r3_y_2.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_27 = mad(-_Metallic, 0.96, 0.96);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(float4(unitClipPos_x_19, unitClipPos_y_17, unitClipPos_z_17, unitClipPos_x_19), unitViewDir_xyz_1.xyzx);
                float r1_x_2 = saturate(dot(float4(unitClipPos_x_19, unitClipPos_y_17, unitClipPos_z_17, unitClipPos_x_19), _WorldSpaceLightPos0.xyzx));
                float r1_y_2 = saturate(dot(float4(unitClipPos_x_19, unitClipPos_y_17, unitClipPos_z_17, unitClipPos_x_19), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r4_w_3.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(nDotV_w_6) + 1);
                float r2_w_17 = (r1_z_4 * r1_z_4);
                float r2_w_18 = (r2_w_17 * r2_w_17);
                float r1_z_5 = (r1_z_4 * r2_w_18);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r4_w_3 * r4_w_3);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r2_w_19 = (-r0_z_8 + 1);
                float r3_y_3 = mad(abs(nDotV_w_6), r2_w_19, r0_z_8);
                float r2_w_20 = mad(r1_x_2, r2_w_19, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * r2_w_20);
                float r0_w_8 = mad(r1_x_2, r3_y_3, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r2_w_21 = (r0_z_8 * r0_z_8);
                float r3_y_4 = mad(r1_y_2, r2_w_21, -r1_y_2);
                float r1_y_3 = mad(r3_y_4, r1_y_2, 1);
                float r2_w_22 = (r2_w_21 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r1_y_5 = (r2_w_22 / r1_y_4);
                float r0_w_11 = (r0_w_10 * r1_y_5);
                float r0_w_12 = (r0_w_11 * 3.1415927);
                float4 r0_xyzw_9 = (r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_y_8, r0_w_12));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_w_13 = r0_xyzw_9.w;
                float r0_w_14 = max(r0_w_13, 0);
                float r0_z_9 = mad(r0_z_8, r0_z_8, 1);
                float r0_z_10 = ((float4(1, 1, 1, 1) / r0_z_9)).z;
                float r0_w_15 = (r0_w_14 * asfloat(asint((float)((dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx) != 0))) & asint(1065353216)));
                float4 r5_xyzw_20 = mad(r6_xyz_1.xyzx, r0_y_9.xxxx, (max(((r8_xyz_4.xyzx + i.texcoord3.xyzx)).xyzx, float4(0, 0, 0, 0))).xyzx);
                float r5_x_20 = r5_xyzw_20.x;
                float r5_y_18 = r5_xyzw_20.y;
                float r5_z_18 = r5_xyzw_20.z;
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
                float r0_x_9 = (mad(((r1_w_27.xxxx * ((r2_xyz_2.xyzx * r3_y_2.xxxx)).xyzx)).xyxz, float4(r5_x_20, r5_y_18, r5_x_20, r5_z_18), float4(r0_x_8, r0_y_13, r0_x_8, r0_w_17))).x;
                float4 r0_xyzw_14 = mad(((r1_w_27.xxxx * ((r2_xyz_2.xyzx * r3_y_2.xxxx)).xyzx)).xyxz, float4(r5_x_20, r5_y_18, r5_x_20, r5_z_18), float4(r0_x_8, r0_y_13, r0_x_8, r0_w_17));
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
                float4 r0_xyzw_10 = mad(((r9_xyz_11.xyzx * r0_z_10.xxxx)).xyzx, float4(r1_x_9, r1_y_7, r1_z_6, r1_x_9), float4(r0_x_9, r0_y_14, r0_w_18, r0_x_9));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_15 = r0_xyzw_10.y;
                float r0_z_11 = r0_xyzw_10.z;
                float4 r0_xyzw_11 = mad(float4(r3_x_3, r3_z_2, r3_w_2, r3_x_3), _EdgeColor.wwww, float4(r0_x_10, r0_y_15, r0_z_11, r0_x_10));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_y_16 = r0_xyzw_11.y;
                float r0_z_12 = r0_xyzw_11.z;
                float r0_w_19 = (i.texcoord4.x / cb1_values[5].y);
                float r0_w_20 = (-r0_w_19 + 1);
                float r0_w_21 = (r0_w_20 * cb1_values[5].z);
                float r0_w_22 = max(r0_w_21, 0);
                float r0_w_23 = saturate(mad(r0_w_22, unity_SpecCube0_BoxMin.z, unity_SpecCube0_BoxMin.w));
                float4 r0_xyzw_12 = (float4(r0_x_11, r0_y_16, r0_z_12, r0_x_11) + -unity_SpecCube0_BoxMax.xyzx);
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_17 = r0_xyzw_12.y;
                float r0_z_13 = r0_xyzw_12.z;
                o.sv_Target0.xyz = (mad(r0_w_23.xxxx, float4(r0_x_12, r0_y_17, r0_z_13, r0_x_12), unity_SpecCube0_BoxMax.xyzx)).xyz;
                o.sv_Target0.w = 1;
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
            SamplerState sampler_linear_clamp;
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_MainTex;
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            TextureCube t2;
            TextureCube t3;
            Texture3D t4;
            struct program14Input
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
            struct program14Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord4 : TEXCOORD4;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program34Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord4 : TEXCOORD4;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program34Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program14Output vert(program14Input i)
            {
                program14Output o = (program14Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord4.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _DissolveMap_ST.xxxy, _DissolveMap_ST.zzzw)).zw;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program34Output frag(program34Input i)
            {
                program34Output o = (program34Output)0;
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
                float r1_w_4 = (cb5_values[0].x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r1_w_4)
                {
                    float r1_w_5 = (cb5_values[0].y == 1);
                    float3 r5_xyz_5 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r5_xyzw_8 = (((((r1_w_5.xxxx ? r5_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r1_w_6 = mad(r5_y_8, 0.25, 0.75);
                    float r2_w_5 = mad(cb5_values[0].z, 0.5, 0.75);
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
                float r1_w_9 = (0 < unity_ProbeVolumeWorldToObject[1].w);
                float3 r7_xyz_4;
                if (r1_w_9)
                {
                    float3 r7_xyz_2 = normalize(r5_xyz_11);
                    float3 r10_xyz_1 = ((float4(0, 0, 0, 0) < r7_xyz_2.xyzx)).xyz;
                    float3 r8_xyz_3 = ((r10_xyz_1.xyzx ? ((((-i.texcoord2.xyzx + unity_ProbeVolumeParams.xyzx)).xyzx / r7_xyz_2.xyzx)).xyzx : ((((-i.texcoord2.xyzx + unity_ProbeVolumeWorldToObject[0].xyzx)).xyzx / r7_xyz_2.xyzx)).xyzx)).xyz;
                    float r1_w_12 = min(r8_xyz_3.y, r8_xyz_3.x);
                    float r1_w_13 = min(r8_xyz_3.z, r1_w_12);
                    r7_xyz_4 = (mad(r7_xyz_2.xyzx, r1_w_13.xxxx, ((i.texcoord2.xyzx + -unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyz;
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
                float r4_w_4 = mad(unity_ProbeVolumeWorldToObject[2].w, r4_w_3, 1);
                float r4_w_5 = log2(r4_w_4);
                float r4_w_6 = (r4_w_5 * unity_ProbeVolumeWorldToObject[2].y);
                float r4_w_7 = exp2(r4_w_6);
                float r4_w_8 = (r4_w_7 * unity_ProbeVolumeWorldToObject[2].x);
                float r5_w_5 = (unity_ProbeVolumeWorldToObject[0].w < 0.99999);
                float3 r8_xyz_8 = ((r7_xyzw_5.xyzx * r4_w_8.xxxx)).xyz;
                if (r5_w_5)
                {
                    float r5_w_6 = (0 < cb4_values[6].w);
                    float3 r5_xyz_13 = r5_xyz_11;
                    if (r5_w_6)
                    {
                        float3 r9_xyz_4 = normalize(r5_xyz_11);
                        float3 r12_xyz_1 = ((float4(0, 0, 0, 0) < r9_xyz_4.xyzx)).xyz;
                        float3 r10_xyz_5 = ((r12_xyz_1.xyzx ? ((((-i.texcoord2.xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyzx / r9_xyz_4.xyzx)).xyzx : ((((-i.texcoord2.xyzx + unity_ProbeVolumeSizeInv.xyzx)).xyzx / r9_xyz_4.xyzx)).xyzx)).xyz;
                        float r5_w_9 = min(r10_xyz_5.y, r10_xyz_5.x);
                        float r5_w_10 = min(r10_xyz_5.z, r5_w_9);
                        r5_xyz_13 = (mad(r9_xyz_4.xyzx, r5_w_10.xxxx, ((i.texcoord2.xyzx + -unity_ProbeVolumeMin.xyzx)).xyzx)).xyz;
                    }
                    float4 r5_xyzw_14 = t3.SampleLevel(sampler_linear_clamp, r5_xyz_13.xyz, r1_w_17);
                    float r1_w_18 = (r5_xyzw_14.w + -1);
                    float r1_w_19 = mad(cb4_values[7].w, r1_w_18, 1);
                    float r1_w_20 = log2(r1_w_19);
                    float r1_w_21 = (r1_w_20 * cb4_values[7].y);
                    float r1_w_22 = exp2(r1_w_21);
                    float r1_w_23 = (r1_w_22 * cb4_values[7].x);
                    float3 r5_xyz_15 = ((r5_xyzw_14.xyzx * r1_w_23.xxxx)).xyz;
                    r8_xyz_8 = (mad(unity_ProbeVolumeWorldToObject[0].wwww, (mad(r4_w_8.xxxx, r7_xyzw_5.xyzx, -r5_xyz_15.xyzx)).xyzx, r5_xyz_15.xyzx)).xyz;
                }
                float3 unitClipPos_xyz_17 = normalize(i.texcoord1);
                float3 r2_xyz_4 = (mad(_Metallic.xxxx, (mad(r2_xyz_2.xyzx, r3_y_2.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_27 = mad(-_Metallic, 0.96, 0.96);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitClipPos_xyz_17.xyzx, unitViewDir_xyz_1.xyzx);
                float r1_x_2 = saturate(dot(unitClipPos_xyz_17.xyzx, _WorldSpaceLightPos0.xyzx));
                float r1_y_2 = saturate(dot(unitClipPos_xyz_17.xyzx, r0_xyz_3.xyzx));
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
                float4 r0_xyzw_11 = mad(float4(r3_x_3, r3_z_2, r3_w_2, r3_x_3), _EdgeColor.wwww, float4(r0_x_10, r0_y_15, r0_z_11, r0_x_10));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_y_16 = r0_xyzw_11.y;
                float r0_z_12 = r0_xyzw_11.z;
                float r0_w_19 = (i.texcoord4.x / cb1_values[5].y);
                float r0_w_20 = (-r0_w_19 + 1);
                float r0_w_21 = (r0_w_20 * cb1_values[5].z);
                float r0_w_22 = max(r0_w_21, 0);
                float r0_w_23 = saturate(mad(r0_w_22, unity_SpecCube0_BoxMin.z, unity_SpecCube0_BoxMin.w));
                float4 r0_xyzw_12 = (float4(r0_x_11, r0_y_16, r0_z_12, r0_x_11) + -unity_SpecCube0_BoxMax.xyzx);
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_17 = r0_xyzw_12.y;
                float r0_z_13 = r0_xyzw_12.z;
                o.sv_Target0.xyz = (mad(r0_w_23.xxxx, float4(r0_x_12, r0_y_17, r0_z_13, r0_x_12), unity_SpecCube0_BoxMax.xyzx)).xyz;
                o.sv_Target0.w = 1;
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
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[46];
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
                float4 cb3_values[26];
            };
            cbuffer cb4 : register(b4)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb4_values[21];
            };
            cbuffer cb5 : register(b5)
            {
                float4 cb5_values[8];
            };
            cbuffer cb6 : register(b6)
            {
                float4 cb6_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            Texture2D t2;
            TextureCube t3;
            TextureCube t4;
            Texture3D t5;
            struct program9Input
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
            struct program9Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program33Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program33Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program9Output vert(program9Input i)
            {
                program9Output o = (program9Output)0;
                float4 worldPos_xyzw_2 = mad(cb3_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb3_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb3_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb3_values[3].xyzw);
                o.texcoord2.xyz = (mad(cb3_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb4_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb4_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb4_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb4_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = mul(float4x4(cb4_values[17], cb4_values[18], cb4_values[19], cb4_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _DissolveMap_ST.xxxy, _DissolveMap_ST.zzzw)).zw;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb3_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb3_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb3_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                float3 unitWorldNormal_xyz_3 = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = unitWorldNormal_xyz_3.xyz;
                float r1_w_4 = (unitWorldNormal_xyz_3.y * unitWorldNormal_xyz_3.y);
                float r1_w_5 = mad(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.x, -r1_w_4);
                float4 r2_xyzw_1 = (unitWorldNormal_xyz_3.yzzx * unitWorldNormal_xyz_3.xyzz);
                float r1_x_4 = dot(cb2_values[42].xyzw, r2_xyzw_1);
                float r1_y_4 = dot(cb2_values[43].xyzw, r2_xyzw_1);
                float r1_z_4 = dot(cb2_values[44].xyzw, r2_xyzw_1);
                o.texcoord3.xyz = (mad(cb2_values[45].xyzx, r1_w_5.xxxx, float4(r1_x_4, r1_y_4, r1_z_4, r1_x_4))).xyz;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r1_xyzw_5 = (float4(clipPos_xyzw_7.x, clipPos_xyzw_7.x, clipPos_xyzw_7.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_5 = r1_xyzw_5.x;
                float r1_z_5 = r1_xyzw_5.z;
                float r1_w_6 = r1_xyzw_5.w;
                o.texcoord5.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord5.xy = ((r1_z_5.xxxx + float4(r1_x_5, r1_w_6, r1_x_5, r1_x_5))).xy;
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program33Output frag(program33Input i)
            {
                program33Output o = (program33Output)0;
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
                float r5_x_1 = cb4_values[9].z;
                float r5_y_1 = cb4_values[10].z;
                float r5_z_1 = cb4_values[11].z;
                float r1_w_4 = dot(viewDir_xyz_1.xyzx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1));
                float3 r5_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_5 = dot(r5_xyz_2.xyzx, r5_xyz_2.xyzx);
                float r2_w_6 = sqrt(r2_w_5);
                float r2_w_7 = (-r1_w_4 + r2_w_6);
                float r1_w_5 = mad(cb3_values[25].w, r2_w_7, r1_w_4);
                float r1_w_6 = saturate(mad(r1_w_5, cb3_values[24].z, cb3_values[24].w));
                float r2_w_8 = (cb6_values[0].x == 1);
                float r5_x_12;
                float r5_y_13;
                float r5_z_12;
                float r5_w_4;
                if (r2_w_8)
                {
                    float r4_w_1 = (cb6_values[0].y == 1);
                    float3 r5_xyz_7 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r5_xyzw_10 = (((((r4_w_1.xxxx ? r5_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r5_y_10 = r5_xyzw_10.y;
                    float r5_z_10 = r5_xyzw_10.z;
                    float r5_w_2 = r5_xyzw_10.w;
                    float r4_w_2 = mad(r5_y_10, 0.25, 0.75);
                    float r5_y_11 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r5_x_10 = max(r4_w_2, r5_y_11);
                    float4 r5_xyzw_11 = t5.Sample(sampler_linear_clamp1, (float4(r5_x_10, r5_z_10, r5_w_2, r5_x_10)).xyz);
                    r5_x_12 = r5_xyzw_11.x;
                    r5_y_13 = r5_xyzw_11.y;
                    r5_z_12 = r5_xyzw_11.z;
                    r5_w_4 = r5_xyzw_11.w;
                }
                else
                {
                    float4 r5_xyzw_3 = float4(1, 1, 1, 1);
                    r5_x_12 = r5_xyzw_3.x;
                    r5_y_13 = r5_xyzw_3.y;
                    r5_z_12 = r5_xyzw_3.z;
                    r5_w_4 = r5_xyzw_3.w;
                }
                float r4_w_4 = saturate(dot(float4(r5_x_12, r5_y_13, r5_z_12, r5_w_4), unity_OcclusionMaskSelector));
                float4 r5_xyzw_13 = (i.texcoord5.xyxx / i.texcoord5.wwww);
                float r5_x_13 = r5_xyzw_13.x;
                float r5_y_14 = r5_xyzw_13.y;
                float4 r5_xyzw_14 = t2.Sample(sampler_linear_clamp2, (float4(r5_x_13, r5_y_14, r5_x_13, r5_x_13)).xy);
                float r4_w_5 = (r4_w_4 + -r5_xyzw_14.x);
                float r1_w_7 = mad(r1_w_6, r4_w_5, r5_xyzw_14.x);
                float r4_w_6 = (-_Smoothness + 1);
                float r5_x_15 = dot(-unitViewDir_xyz_1.xyzx, i.texcoord1.xyzx);
                float4 r5_xyzw_17 = mad(i.texcoord1.xyzx, ((r5_x_15 + r5_x_15)).xxxx, -unitViewDir_xyz_1.xyzx);
                float r5_x_17 = r5_xyzw_17.x;
                float r5_y_16 = r5_xyzw_17.y;
                float r5_z_14 = r5_xyzw_17.z;
                float3 r6_xyz_1 = ((r1_w_7.xxxx * _LightColor0.xyzx)).xyz;
                float3 TEXCOORD1_xyz_1;
                float3 r8_xyz_4;
                if (r2_w_8)
                {
                    float r1_w_8 = (cb6_values[0].y == 1);
                    float3 r7_xyz_5 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r7_xyzw_8 = (((((r1_w_8.xxxx ? r7_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r7_y_8 = r7_xyzw_8.y;
                    float r7_z_8 = r7_xyzw_8.z;
                    float r7_w_2 = r7_xyzw_8.w;
                    float r1_w_9 = (r7_y_8 * 0.25);
                    float r2_w_9 = (cb6_values[0].z * 0.5);
                    float r5_w_6 = mad(-cb6_values[0].z, 0.5, 0.25);
                    float r1_w_10 = max(r1_w_9, r2_w_9);
                    float r7_x_8 = min(r5_w_6, r1_w_10);
                    float4 r8_xyzw_2 = t5.Sample(sampler_linear_clamp1, (float4(r7_x_8, r7_z_8, r7_w_2, r7_x_8)).xyz);
                    float4 r9_xyzw_2 = t5.Sample(sampler_linear_clamp1, (((float4(r7_x_8, r7_z_8, r7_w_2, r7_x_8) + float4(0.25, 0, 0, 0))).xyzx).xyz);
                    float4 r7_xyzw_10 = t5.Sample(sampler_linear_clamp1, (((float4(r7_x_8, r7_z_8, r7_w_2, r7_x_8) + float4(0.5, 0, 0, 0))).xyzx).xyz);
                    TEXCOORD1_xyz_1 = i.texcoord1.xyz;
                    float r10_w_1 = 1;
                    float r8_x_3 = dot(r8_xyzw_2, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r10_w_1));
                    float r8_y_3 = dot(r9_xyzw_2, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r10_w_1));
                    float r8_z_3 = dot(r7_xyzw_10, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r10_w_1));
                    r8_xyz_4 = float3(r8_x_3, r8_y_3, r8_z_3);
                }
                else
                {
                    TEXCOORD1_xyz_1 = i.texcoord1.xyz;
                    float r7_w_1 = 1;
                    float r8_x_1 = dot(cb2_values[39].xyzw, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r7_w_1));
                    float r8_y_1 = dot(cb2_values[40].xyzw, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r7_w_1));
                    float r8_z_1 = dot(cb2_values[41].xyzw, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r7_w_1));
                    r8_xyz_4 = float3(r8_x_1, r8_y_1, r8_z_1);
                }
                float r1_w_12 = (0 < cb5_values[2].w);
                float3 r8_xyz_8;
                if (r1_w_12)
                {
                    float r1_w_13 = dot(float4(r5_x_17, r5_y_16, r5_z_14, r5_x_17), float4(r5_x_17, r5_y_16, r5_z_14, r5_x_17));
                    float r1_w_14 = rsqrt(r1_w_13);
                    float3 r8_xyz_6 = ((r1_w_14.xxxx * float4(r5_x_17, r5_y_16, r5_z_14, r5_x_17))).xyz;
                    float3 r11_xyz_1 = ((float4(0, 0, 0, 0) < r8_xyz_6.xyzx)).xyz;
                    float3 r9_xyz_6 = ((r11_xyz_1.xyzx ? ((((-i.texcoord2.xyzx + cb5_values[0].xyzx)).xyzx / r8_xyz_6.xyzx)).xyzx : ((((-i.texcoord2.xyzx + cb5_values[1].xyzx)).xyzx / r8_xyz_6.xyzx)).xyzx)).xyz;
                    float r1_w_15 = min(r9_xyz_6.y, r9_xyz_6.x);
                    float r1_w_16 = min(r9_xyz_6.z, r1_w_15);
                    r8_xyz_8 = (mad(r8_xyz_6.xyzx, r1_w_16.xxxx, ((i.texcoord2.xyzx + -cb5_values[2].xyzx)).xyzx)).xyz;
                }
                else
                {
                    r8_xyz_8 = (float4(r5_x_17, r5_y_16, r5_z_14, r5_x_17)).xyz;
                }
                float r1_w_18 = mad(-r4_w_6, 0.7, 1.7);
                float r1_w_19 = (r1_w_18 * r4_w_6);
                float r1_w_20 = (r1_w_19 * 6);
                float4 r8_xyzw_9 = t3.SampleLevel(sampler_linear_clamp, r8_xyz_8.xyz, r1_w_20);
                float r2_w_11 = (r8_xyzw_9.w + -1);
                float r2_w_12 = mad(cb5_values[3].w, r2_w_11, 1);
                float r2_w_13 = log2(r2_w_12);
                float r2_w_14 = (r2_w_13 * cb5_values[3].y);
                float r2_w_15 = exp2(r2_w_14);
                float r2_w_16 = (r2_w_15 * cb5_values[3].x);
                float r5_w_8 = (cb5_values[1].w < 0.99999);
                float3 r9_xyz_11 = ((r8_xyzw_9.xyzx * r2_w_16.xxxx)).xyz;
                if (r5_w_8)
                {
                    float r5_w_9 = (0 < cb5_values[6].w);
                    float r5_x_19 = r5_x_17;
                    float r5_y_18 = r5_y_16;
                    float r5_z_16 = r5_z_14;
                    if (r5_w_9)
                    {
                        float r5_w_10 = dot(float4(r5_x_17, r5_y_16, r5_z_14, r5_x_17), float4(r5_x_17, r5_y_16, r5_z_14, r5_x_17));
                        float r5_w_11 = rsqrt(r5_w_10);
                        float3 r10_xyz_6 = ((r5_w_11.xxxx * float4(r5_x_17, r5_y_16, r5_z_14, r5_x_17))).xyz;
                        float3 r13_xyz_1 = ((float4(0, 0, 0, 0) < r10_xyz_6.xyzx)).xyz;
                        float3 r11_xyz_5 = ((r13_xyz_1.xyzx ? ((((-i.texcoord2.xyzx + cb5_values[4].xyzx)).xyzx / r10_xyz_6.xyzx)).xyzx : ((((-i.texcoord2.xyzx + cb5_values[5].xyzx)).xyzx / r10_xyz_6.xyzx)).xyzx)).xyz;
                        float r5_w_12 = min(r11_xyz_5.y, r11_xyz_5.x);
                        float r5_w_13 = min(r11_xyz_5.z, r5_w_12);
                        float4 r5_xyzw_18 = mad(r10_xyz_6.xyzx, r5_w_13.xxxx, ((i.texcoord2.xyzx + -cb5_values[6].xyzx)).xyzx);
                        float r5_x_18 = r5_xyzw_18.x;
                        float r5_y_17 = r5_xyzw_18.y;
                        float r5_z_15 = r5_xyzw_18.z;
                        r5_x_19 = r5_x_18;
                        r5_y_18 = r5_y_17;
                        r5_z_16 = r5_z_15;
                    }
                    float4 r5_xyzw_20 = t4.SampleLevel(sampler_linear_clamp, (float4(r5_x_19, r5_y_18, r5_z_16, r5_x_19)).xyz, r1_w_20);
                    float r1_w_21 = (r5_xyzw_20.w + -1);
                    float r1_w_22 = mad(cb5_values[7].w, r1_w_21, 1);
                    float r1_w_23 = log2(r1_w_22);
                    float r1_w_24 = (r1_w_23 * cb5_values[7].y);
                    float r1_w_25 = exp2(r1_w_24);
                    float r1_w_26 = (r1_w_25 * cb5_values[7].x);
                    float4 r5_xyzw_21 = (r5_xyzw_20.xyzx * r1_w_26.xxxx);
                    float r5_x_21 = r5_xyzw_21.x;
                    float r5_y_20 = r5_xyzw_21.y;
                    float r5_z_18 = r5_xyzw_21.z;
                    r9_xyz_11 = (mad(cb5_values[1].wwww, (mad(r2_w_16.xxxx, r8_xyzw_9.xyzx, -float4(r5_x_21, r5_y_20, r5_z_18, r5_x_21))).xyzx, float4(r5_x_21, r5_y_20, r5_z_18, r5_x_21))).xyz;
                }
                float r1_w_28 = dot(i.texcoord1.xyzx, i.texcoord1.xyzx);
                float r1_w_29 = rsqrt(r1_w_28);
                float4 unitWorldNormal_xyzw_23 = (r1_w_29.xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_23 = unitWorldNormal_xyzw_23.x;
                float unitWorldNormal_y_22 = unitWorldNormal_xyzw_23.y;
                float unitWorldNormal_z_20 = unitWorldNormal_xyzw_23.z;
                float3 r2_xyz_4 = (mad(_Metallic.xxxx, (mad(r2_xyz_2.xyzx, r3_y_2.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_30 = mad(-_Metallic, 0.96, 0.96);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(float4(unitWorldNormal_x_23, unitWorldNormal_y_22, unitWorldNormal_z_20, unitWorldNormal_x_23), unitViewDir_xyz_1.xyzx);
                float r1_x_2 = saturate(dot(float4(unitWorldNormal_x_23, unitWorldNormal_y_22, unitWorldNormal_z_20, unitWorldNormal_x_23), _WorldSpaceLightPos0.xyzx));
                float r1_y_2 = saturate(dot(float4(unitWorldNormal_x_23, unitWorldNormal_y_22, unitWorldNormal_z_20, unitWorldNormal_x_23), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r4_w_6.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(nDotV_w_6) + 1);
                float r2_w_17 = (r1_z_4 * r1_z_4);
                float r2_w_18 = (r2_w_17 * r2_w_17);
                float r1_z_5 = (r1_z_4 * r2_w_18);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r4_w_6 * r4_w_6);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r2_w_19 = (-r0_z_8 + 1);
                float r3_y_3 = mad(abs(nDotV_w_6), r2_w_19, r0_z_8);
                float r2_w_20 = mad(r1_x_2, r2_w_19, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * r2_w_20);
                float r0_w_8 = mad(r1_x_2, r3_y_3, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r2_w_21 = (r0_z_8 * r0_z_8);
                float r3_y_4 = mad(r1_y_2, r2_w_21, -r1_y_2);
                float r1_y_3 = mad(r3_y_4, r1_y_2, 1);
                float r2_w_22 = (r2_w_21 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r1_y_5 = (r2_w_22 / r1_y_4);
                float r0_w_11 = (r0_w_10 * r1_y_5);
                float r0_w_12 = (r0_w_11 * 3.1415927);
                float4 r0_xyzw_9 = (r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_y_8, r0_w_12));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_w_13 = r0_xyzw_9.w;
                float r0_w_14 = max(r0_w_13, 0);
                float r0_z_9 = mad(r0_z_8, r0_z_8, 1);
                float r0_z_10 = ((float4(1, 1, 1, 1) / r0_z_9)).z;
                float r0_w_15 = (r0_w_14 * asfloat(asint((float)((dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx) != 0))) & asint(1065353216)));
                float4 r5_xyzw_24 = mad(r6_xyz_1.xyzx, r0_y_9.xxxx, (max(((r8_xyz_4.xyzx + i.texcoord3.xyzx)).xyzx, float4(0, 0, 0, 0))).xyzx);
                float r5_x_24 = r5_xyzw_24.x;
                float r5_y_23 = r5_xyzw_24.y;
                float r5_z_21 = r5_xyzw_24.z;
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
                float r0_x_9 = (mad(((r1_w_30.xxxx * ((r2_xyz_2.xyzx * r3_y_2.xxxx)).xyzx)).xyxz, float4(r5_x_24, r5_y_23, r5_x_24, r5_z_21), float4(r0_x_8, r0_y_13, r0_x_8, r0_w_17))).x;
                float4 r0_xyzw_14 = mad(((r1_w_30.xxxx * ((r2_xyz_2.xyzx * r3_y_2.xxxx)).xyzx)).xyxz, float4(r5_x_24, r5_y_23, r5_x_24, r5_z_21), float4(r0_x_8, r0_y_13, r0_x_8, r0_w_17));
                float r0_y_14 = r0_xyzw_14.y;
                float r0_w_18 = r0_xyzw_14.w;
                float4 r1_xyzw_8 = (-r2_xyz_4.xyxz + (saturate(((-r1_w_30 + _Smoothness) + 1))).xxxx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_w_31 = r1_xyzw_8.w;
                float4 r1_xyzw_9 = mad(r1_z_5.xxxx, float4(r1_x_8, r1_y_6, r1_w_31, r1_x_8), r2_xyz_4.xyzx);
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_7 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r0_xyzw_10 = mad(((r9_xyz_11.xyzx * r0_z_10.xxxx)).xyzx, float4(r1_x_9, r1_y_7, r1_z_6, r1_x_9), float4(r0_x_9, r0_y_14, r0_w_18, r0_x_9));
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
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[7];
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
                float4 cb3_values[26];
            };
            cbuffer _UnityProbeVolumeCB_b4
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb4_values[12];
            };
            cbuffer cb5 : register(b5)
            {
                float4 cb5_values[8];
            };
            cbuffer cb6 : register(b6)
            {
                float4 cb6_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            Texture2D t2;
            TextureCube t3;
            TextureCube t4;
            Texture3D t5;
            struct program8Input
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
            struct program8Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program32Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program32Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program8Output vert(program8Input i)
            {
                program8Output o = (program8Output)0;
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
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _DissolveMap_ST.xxxy, _DissolveMap_ST.zzzw)).zw;
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
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program32Output frag(program32Input i)
            {
                program32Output o = (program32Output)0;
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
                float r5_x_1 = cb4_values[9].z;
                float r5_y_1 = cb4_values[10].z;
                float r5_z_1 = cb4_values[11].z;
                float r1_w_4 = dot(viewDir_xyz_1.xyzx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1));
                float3 r5_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_5 = dot(r5_xyz_2.xyzx, r5_xyz_2.xyzx);
                float r2_w_6 = sqrt(r2_w_5);
                float r2_w_7 = (-r1_w_4 + r2_w_6);
                float r1_w_5 = mad(cb3_values[25].w, r2_w_7, r1_w_4);
                float r1_w_6 = saturate(mad(r1_w_5, cb3_values[24].z, cb3_values[24].w));
                float r2_w_8 = (cb6_values[0].x == 1);
                float r5_x_12;
                float r5_y_12;
                float r5_z_12;
                float r5_w_4;
                if (r2_w_8)
                {
                    float r2_w_9 = (cb6_values[0].y == 1);
                    float3 r5_xyz_7 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r5_xyzw_10 = (((((r2_w_9.xxxx ? r5_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r5_y_10 = r5_xyzw_10.y;
                    float r5_z_10 = r5_xyzw_10.z;
                    float r5_w_2 = r5_xyzw_10.w;
                    float r2_w_10 = mad(r5_y_10, 0.25, 0.75);
                    float r4_w_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r5_x_10 = max(r2_w_10, r4_w_1);
                    float4 r5_xyzw_11 = t5.Sample(sampler_linear_clamp1, (float4(r5_x_10, r5_z_10, r5_w_2, r5_x_10)).xyz);
                    r5_x_12 = r5_xyzw_11.x;
                    r5_y_12 = r5_xyzw_11.y;
                    r5_z_12 = r5_xyzw_11.z;
                    r5_w_4 = r5_xyzw_11.w;
                }
                else
                {
                    float4 r5_xyzw_3 = float4(1, 1, 1, 1);
                    r5_x_12 = r5_xyzw_3.x;
                    r5_y_12 = r5_xyzw_3.y;
                    r5_z_12 = r5_xyzw_3.z;
                    r5_w_4 = r5_xyzw_3.w;
                }
                float r2_w_12 = saturate(dot(float4(r5_x_12, r5_y_12, r5_z_12, r5_w_4), unity_OcclusionMaskSelector));
                float4 r5_xyzw_14 = t2.Sample(sampler_linear_clamp2, (((i.texcoord5.xyxx / i.texcoord5.wwww)).xyxx).xy);
                float r2_w_13 = (r2_w_12 + -r5_xyzw_14.x);
                float r1_w_7 = mad(r1_w_6, r2_w_13, r5_xyzw_14.x);
                float r2_w_14 = (-_Smoothness + 1);
                float r4_w_3 = dot(-unitViewDir_xyz_1.xyzx, i.texcoord1.xyzx);
                float r4_w_4 = (r4_w_3 + r4_w_3);
                float4 r5_xyzw_15 = mad(i.texcoord1.xyzx, -r4_w_4.xxxx, -unitViewDir_xyz_1.xyzx);
                float r5_x_15 = r5_xyzw_15.x;
                float r5_y_15 = r5_xyzw_15.y;
                float r5_z_14 = r5_xyzw_15.z;
                float3 r6_xyz_1 = ((r1_w_7.xxxx * _LightColor0.xyzx)).xyz;
                float r1_w_8 = (0 < cb5_values[2].w);
                float3 r7_xyz_4;
                if (r1_w_8)
                {
                    float r1_w_9 = dot(float4(r5_x_15, r5_y_15, r5_z_14, r5_x_15), float4(r5_x_15, r5_y_15, r5_z_14, r5_x_15));
                    float r1_w_10 = rsqrt(r1_w_9);
                    float3 r7_xyz_2 = ((r1_w_10.xxxx * float4(r5_x_15, r5_y_15, r5_z_14, r5_x_15))).xyz;
                    float3 r10_xyz_1 = ((float4(0, 0, 0, 0) < r7_xyz_2.xyzx)).xyz;
                    float3 r8_xyz_3 = ((r10_xyz_1.xyzx ? ((((-i.texcoord2.xyzx + cb5_values[0].xyzx)).xyzx / r7_xyz_2.xyzx)).xyzx : ((((-i.texcoord2.xyzx + cb5_values[1].xyzx)).xyzx / r7_xyz_2.xyzx)).xyzx)).xyz;
                    float r1_w_11 = min(r8_xyz_3.y, r8_xyz_3.x);
                    float r1_w_12 = min(r8_xyz_3.z, r1_w_11);
                    r7_xyz_4 = (mad(r7_xyz_2.xyzx, r1_w_12.xxxx, ((i.texcoord2.xyzx + -cb5_values[2].xyzx)).xyzx)).xyz;
                }
                else
                {
                    r7_xyz_4 = (float4(r5_x_15, r5_y_15, r5_z_14, r5_x_15)).xyz;
                }
                float r1_w_14 = mad(-r2_w_14, 0.7, 1.7);
                float r1_w_15 = (r1_w_14 * r2_w_14);
                float r1_w_16 = (r1_w_15 * 6);
                float4 r7_xyzw_5 = t3.SampleLevel(sampler_linear_clamp, r7_xyz_4.xyz, r1_w_16);
                float r4_w_5 = (r7_xyzw_5.w + -1);
                float r4_w_6 = mad(cb5_values[3].w, r4_w_5, 1);
                float r4_w_7 = log2(r4_w_6);
                float r4_w_8 = (r4_w_7 * cb5_values[3].y);
                float r4_w_9 = exp2(r4_w_8);
                float r4_w_10 = (r4_w_9 * cb5_values[3].x);
                float r5_w_6 = (cb5_values[1].w < 0.99999);
                float3 r8_xyz_8 = ((r7_xyzw_5.xyzx * r4_w_10.xxxx)).xyz;
                if (r5_w_6)
                {
                    float r5_w_7 = (0 < cb5_values[6].w);
                    float r5_x_17 = r5_x_15;
                    float r5_y_17 = r5_y_15;
                    float r5_z_16 = r5_z_14;
                    if (r5_w_7)
                    {
                        float r5_w_8 = dot(float4(r5_x_15, r5_y_15, r5_z_14, r5_x_15), float4(r5_x_15, r5_y_15, r5_z_14, r5_x_15));
                        float r5_w_9 = rsqrt(r5_w_8);
                        float3 r9_xyz_4 = ((r5_w_9.xxxx * float4(r5_x_15, r5_y_15, r5_z_14, r5_x_15))).xyz;
                        float3 r12_xyz_1 = ((float4(0, 0, 0, 0) < r9_xyz_4.xyzx)).xyz;
                        float3 r10_xyz_5 = ((r12_xyz_1.xyzx ? ((((-i.texcoord2.xyzx + cb5_values[4].xyzx)).xyzx / r9_xyz_4.xyzx)).xyzx : ((((-i.texcoord2.xyzx + cb5_values[5].xyzx)).xyzx / r9_xyz_4.xyzx)).xyzx)).xyz;
                        float r5_w_10 = min(r10_xyz_5.y, r10_xyz_5.x);
                        float r5_w_11 = min(r10_xyz_5.z, r5_w_10);
                        float4 r5_xyzw_16 = mad(r9_xyz_4.xyzx, r5_w_11.xxxx, ((i.texcoord2.xyzx + -cb5_values[6].xyzx)).xyzx);
                        float r5_x_16 = r5_xyzw_16.x;
                        float r5_y_16 = r5_xyzw_16.y;
                        float r5_z_15 = r5_xyzw_16.z;
                        r5_x_17 = r5_x_16;
                        r5_y_17 = r5_y_16;
                        r5_z_16 = r5_z_15;
                    }
                    float4 r5_xyzw_18 = t4.SampleLevel(sampler_linear_clamp, (float4(r5_x_17, r5_y_17, r5_z_16, r5_x_17)).xyz, r1_w_16);
                    float r1_w_17 = (r5_xyzw_18.w + -1);
                    float r1_w_18 = mad(cb5_values[7].w, r1_w_17, 1);
                    float r1_w_19 = log2(r1_w_18);
                    float r1_w_20 = (r1_w_19 * cb5_values[7].y);
                    float r1_w_21 = exp2(r1_w_20);
                    float r1_w_22 = (r1_w_21 * cb5_values[7].x);
                    float4 r5_xyzw_19 = (r5_xyzw_18.xyzx * r1_w_22.xxxx);
                    float r5_x_19 = r5_xyzw_19.x;
                    float r5_y_19 = r5_xyzw_19.y;
                    float r5_z_18 = r5_xyzw_19.z;
                    r8_xyz_8 = (mad(cb5_values[1].wwww, (mad(r4_w_10.xxxx, r7_xyzw_5.xyzx, -float4(r5_x_19, r5_y_19, r5_z_18, r5_x_19))).xyzx, float4(r5_x_19, r5_y_19, r5_z_18, r5_x_19))).xyz;
                }
                float r1_w_24 = dot(i.texcoord1.xyzx, i.texcoord1.xyzx);
                float r1_w_25 = rsqrt(r1_w_24);
                float4 unitWorldNormal_xyzw_21 = (r1_w_25.xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_21 = unitWorldNormal_xyzw_21.x;
                float unitWorldNormal_y_21 = unitWorldNormal_xyzw_21.y;
                float unitWorldNormal_z_20 = unitWorldNormal_xyzw_21.z;
                float3 r2_xyz_4 = (mad(_Metallic.xxxx, (mad(r2_xyz_2.xyzx, r3_y_2.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_26 = mad(-_Metallic, 0.96, 0.96);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(float4(unitWorldNormal_x_21, unitWorldNormal_y_21, unitWorldNormal_z_20, unitWorldNormal_x_21), unitViewDir_xyz_1.xyzx);
                float r1_x_2 = saturate(dot(float4(unitWorldNormal_x_21, unitWorldNormal_y_21, unitWorldNormal_z_20, unitWorldNormal_x_21), _WorldSpaceLightPos0.xyzx));
                float r1_y_2 = saturate(dot(float4(unitWorldNormal_x_21, unitWorldNormal_y_21, unitWorldNormal_z_20, unitWorldNormal_x_21), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r2_w_14.xxxx);
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
                float r0_z_7 = (r2_w_14 * r2_w_14);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r2_w_15 = (-r0_z_8 + 1);
                float r3_y_5 = mad(abs(nDotV_w_6), r2_w_15, r0_z_8);
                float r2_w_16 = mad(r1_x_2, r2_w_15, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * r2_w_16);
                float r0_w_8 = mad(r1_x_2, r3_y_5, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r2_w_17 = (r0_z_8 * r0_z_8);
                float r3_y_6 = mad(r1_y_2, r2_w_17, -r1_y_2);
                float r1_y_3 = mad(r3_y_6, r1_y_2, 1);
                float r2_w_18 = (r2_w_17 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r1_y_5 = (r2_w_18 / r1_y_4);
                float r0_w_11 = (r0_w_10 * r1_y_5);
                float r0_w_12 = (r0_w_11 * 3.1415927);
                float4 r0_xyzw_9 = (r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_y_8, r0_w_12));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_w_13 = r0_xyzw_9.w;
                float r0_w_14 = max(r0_w_13, 0);
                float r0_z_9 = mad(r0_z_8, r0_z_8, 1);
                float r0_z_10 = ((float4(1, 1, 1, 1) / r0_z_9)).z;
                float r0_w_15 = (r0_w_14 * asfloat(asint((float)((dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx) != 0))) & asint(1065353216)));
                float4 r5_xyzw_22 = (r0_y_9.xxxx * r6_xyz_1.xyzx);
                float r5_x_22 = r5_xyzw_22.x;
                float r5_y_22 = r5_xyzw_22.y;
                float r5_z_21 = r5_xyzw_22.z;
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
                float r0_x_9 = (mad(((r1_w_26.xxxx * ((r2_xyz_2.xyzx * r3_y_2.xxxx)).xyzx)).xyxz, float4(r5_x_22, r5_y_22, r5_x_22, r5_z_21), float4(r0_x_8, r0_y_13, r0_x_8, r0_w_17))).x;
                float4 r0_xyzw_14 = mad(((r1_w_26.xxxx * ((r2_xyz_2.xyzx * r3_y_2.xxxx)).xyzx)).xyxz, float4(r5_x_22, r5_y_22, r5_x_22, r5_z_21), float4(r0_x_8, r0_y_13, r0_x_8, r0_w_17));
                float r0_y_14 = r0_xyzw_14.y;
                float r0_w_18 = r0_xyzw_14.w;
                float4 r1_xyzw_8 = (-r2_xyz_4.xyxz + (saturate(((-r1_w_26 + _Smoothness) + 1))).xxxx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_w_27 = r1_xyzw_8.w;
                float4 r1_xyzw_9 = mad(r1_z_5.xxxx, float4(r1_x_8, r1_y_6, r1_w_27, r1_x_8), r2_xyz_4.xyzx);
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
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[46];
            };
            cbuffer _UnityPerFrameCB_b2
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
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program31Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program31Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program7Output vert(program7Input i)
            {
                program7Output o = (program7Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _DissolveMap_ST.xxxy, _DissolveMap_ST.zzzw)).zw;
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                float3 unitWorldNormal_xyz_8 = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.texcoord1.xyz = unitWorldNormal_xyz_8.xyz;
                float r0_w_9 = (unitWorldNormal_xyz_8.y * unitWorldNormal_xyz_8.y);
                float r0_w_10 = mad(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.x, -r0_w_9);
                float4 r1_xyzw_2 = (unitWorldNormal_xyz_8.yzzx * unitWorldNormal_xyz_8.xyzz);
                float r0_x_9 = dot(cb1_values[42].xyzw, r1_xyzw_2);
                float r0_y_9 = dot(cb1_values[43].xyzw, r1_xyzw_2);
                float r0_z_9 = dot(cb1_values[44].xyzw, r1_xyzw_2);
                o.texcoord3.xyz = (mad(cb1_values[45].xyzx, r0_w_10.xxxx, float4(r0_x_9, r0_y_9, r0_z_9, r0_x_9))).xyz;
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program31Output frag(program31Input i)
            {
                program31Output o = (program31Output)0;
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
                    float r2_w_5 = (unity_ProbeVolumeParams.y == 1);
                    float3 r5_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r2_w_5.xxxx ? r5_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r5_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r2_w_6 = mad(r5_y_8, 0.25, 0.75);
                    float r4_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r5_x_8 = max(r2_w_6, r4_w_1);
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
                float r2_w_8 = saturate(dot(float4(r5_x_10, r5_y_10, r5_z_10, r5_w_4), unity_OcclusionMaskSelector));
                float r4_w_3 = (-_Smoothness + 1);
                float r5_x_11 = dot(-unitViewDir_xyz_1.xyzx, i.texcoord1.xyzx);
                float4 r5_xyzw_13 = mad(i.texcoord1.xyzx, ((r5_x_11 + r5_x_11)).xxxx, -unitViewDir_xyz_1.xyzx);
                float r5_x_13 = r5_xyzw_13.x;
                float r5_y_11 = r5_xyzw_13.y;
                float r5_z_11 = r5_xyzw_13.z;
                float3 r6_xyz_1 = ((r2_w_8.xxxx * _LightColor0.xyzx)).xyz;
                float3 TEXCOORD1_xyz_1;
                float3 r8_xyz_4;
                if (r1_w_4)
                {
                    float r1_w_5 = (unity_ProbeVolumeParams.y == 1);
                    float3 r7_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r1_w_5.xxxx ? r7_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r7_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r7_y_8 = r7_xyzw_8.y;
                    float r7_z_8 = r7_xyzw_8.z;
                    float r7_w_2 = r7_xyzw_8.w;
                    float r1_w_6 = (r7_y_8 * 0.25);
                    float r2_w_9 = (unity_ProbeVolumeParams.z * 0.5);
                    float r5_w_5 = mad(-unity_ProbeVolumeParams.z, 0.5, 0.25);
                    float r1_w_7 = max(r1_w_6, r2_w_9);
                    float r7_x_8 = min(r5_w_5, r1_w_7);
                    float4 r8_xyzw_2 = t4.Sample(sampler_linear_clamp1, (float4(r7_x_8, r7_z_8, r7_w_2, r7_x_8)).xyz);
                    float4 r9_xyzw_2 = t4.Sample(sampler_linear_clamp1, (((float4(r7_x_8, r7_z_8, r7_w_2, r7_x_8) + float4(0.25, 0, 0, 0))).xyzx).xyz);
                    float4 r7_xyzw_10 = t4.Sample(sampler_linear_clamp1, (((float4(r7_x_8, r7_z_8, r7_w_2, r7_x_8) + float4(0.5, 0, 0, 0))).xyzx).xyz);
                    TEXCOORD1_xyz_1 = i.texcoord1.xyz;
                    float r10_w_1 = 1;
                    float r8_x_3 = dot(r8_xyzw_2, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r10_w_1));
                    float r8_y_3 = dot(r9_xyzw_2, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r10_w_1));
                    float r8_z_3 = dot(r7_xyzw_10, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r10_w_1));
                    r8_xyz_4 = float3(r8_x_3, r8_y_3, r8_z_3);
                }
                else
                {
                    TEXCOORD1_xyz_1 = i.texcoord1.xyz;
                    float r7_w_1 = 1;
                    float r8_x_1 = dot(cb2_values[39].xyzw, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r7_w_1));
                    float r8_y_1 = dot(cb2_values[40].xyzw, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r7_w_1));
                    float r8_z_1 = dot(cb2_values[41].xyzw, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r7_w_1));
                    r8_xyz_4 = float3(r8_x_1, r8_y_1, r8_z_1);
                }
                float r1_w_9 = (0 < unity_SpecCube0_ProbePosition.w);
                float3 r8_xyz_8;
                if (r1_w_9)
                {
                    float r1_w_10 = dot(float4(r5_x_13, r5_y_11, r5_z_11, r5_x_13), float4(r5_x_13, r5_y_11, r5_z_11, r5_x_13));
                    float r1_w_11 = rsqrt(r1_w_10);
                    float3 r8_xyz_6 = ((r1_w_11.xxxx * float4(r5_x_13, r5_y_11, r5_z_11, r5_x_13))).xyz;
                    float3 r11_xyz_1 = ((float4(0, 0, 0, 0) < r8_xyz_6.xyzx)).xyz;
                    float3 r9_xyz_6 = ((r11_xyz_1.xyzx ? ((((-i.texcoord2.xyzx + unity_SpecCube0_BoxMax.xyzx)).xyzx / r8_xyz_6.xyzx)).xyzx : ((((-i.texcoord2.xyzx + unity_SpecCube0_BoxMin.xyzx)).xyzx / r8_xyz_6.xyzx)).xyzx)).xyz;
                    float r1_w_12 = min(r9_xyz_6.y, r9_xyz_6.x);
                    float r1_w_13 = min(r9_xyz_6.z, r1_w_12);
                    r8_xyz_8 = (mad(r8_xyz_6.xyzx, r1_w_13.xxxx, ((i.texcoord2.xyzx + -unity_SpecCube0_ProbePosition.xyzx)).xyzx)).xyz;
                }
                else
                {
                    r8_xyz_8 = (float4(r5_x_13, r5_y_11, r5_z_11, r5_x_13)).xyz;
                }
                float r1_w_15 = mad(-r4_w_3, 0.7, 1.7);
                float r1_w_16 = (r1_w_15 * r4_w_3);
                float r1_w_17 = (r1_w_16 * 6);
                float4 r8_xyzw_9 = t2.SampleLevel(sampler_linear_clamp, r8_xyz_8.xyz, r1_w_17);
                float r2_w_11 = (r8_xyzw_9.w + -1);
                float r2_w_12 = mad(unity_SpecCube0_HDR.w, r2_w_11, 1);
                float r2_w_13 = log2(r2_w_12);
                float r2_w_14 = (r2_w_13 * unity_SpecCube0_HDR.y);
                float r2_w_15 = exp2(r2_w_14);
                float r2_w_16 = (r2_w_15 * unity_SpecCube0_HDR.x);
                float r5_w_7 = (unity_SpecCube0_BoxMin.w < 0.99999);
                float3 r9_xyz_11 = ((r8_xyzw_9.xyzx * r2_w_16.xxxx)).xyz;
                if (r5_w_7)
                {
                    float r5_w_8 = (0 < unity_SpecCube1_ProbePosition.w);
                    float r5_x_15 = r5_x_13;
                    float r5_y_13 = r5_y_11;
                    float r5_z_13 = r5_z_11;
                    if (r5_w_8)
                    {
                        float r5_w_9 = dot(float4(r5_x_13, r5_y_11, r5_z_11, r5_x_13), float4(r5_x_13, r5_y_11, r5_z_11, r5_x_13));
                        float r5_w_10 = rsqrt(r5_w_9);
                        float3 r10_xyz_6 = ((r5_w_10.xxxx * float4(r5_x_13, r5_y_11, r5_z_11, r5_x_13))).xyz;
                        float3 r13_xyz_1 = ((float4(0, 0, 0, 0) < r10_xyz_6.xyzx)).xyz;
                        float3 r11_xyz_5 = ((r13_xyz_1.xyzx ? ((((-i.texcoord2.xyzx + unity_SpecCube1_BoxMax.xyzx)).xyzx / r10_xyz_6.xyzx)).xyzx : ((((-i.texcoord2.xyzx + unity_SpecCube1_BoxMin.xyzx)).xyzx / r10_xyz_6.xyzx)).xyzx)).xyz;
                        float r5_w_11 = min(r11_xyz_5.y, r11_xyz_5.x);
                        float r5_w_12 = min(r11_xyz_5.z, r5_w_11);
                        float4 r5_xyzw_14 = mad(r10_xyz_6.xyzx, r5_w_12.xxxx, ((i.texcoord2.xyzx + -unity_SpecCube1_ProbePosition.xyzx)).xyzx);
                        float r5_x_14 = r5_xyzw_14.x;
                        float r5_y_12 = r5_xyzw_14.y;
                        float r5_z_12 = r5_xyzw_14.z;
                        r5_x_15 = r5_x_14;
                        r5_y_13 = r5_y_12;
                        r5_z_13 = r5_z_12;
                    }
                    float4 r5_xyzw_16 = t3.SampleLevel(sampler_linear_clamp, (float4(r5_x_15, r5_y_13, r5_z_13, r5_x_15)).xyz, r1_w_17);
                    float r1_w_18 = (r5_xyzw_16.w + -1);
                    float r1_w_19 = mad(unity_SpecCube1_HDR.w, r1_w_18, 1);
                    float r1_w_20 = log2(r1_w_19);
                    float r1_w_21 = (r1_w_20 * unity_SpecCube1_HDR.y);
                    float r1_w_22 = exp2(r1_w_21);
                    float r1_w_23 = (r1_w_22 * unity_SpecCube1_HDR.x);
                    float4 r5_xyzw_17 = (r5_xyzw_16.xyzx * r1_w_23.xxxx);
                    float r5_x_17 = r5_xyzw_17.x;
                    float r5_y_15 = r5_xyzw_17.y;
                    float r5_z_15 = r5_xyzw_17.z;
                    r9_xyz_11 = (mad(unity_SpecCube0_BoxMin.wwww, (mad(r2_w_16.xxxx, r8_xyzw_9.xyzx, -float4(r5_x_17, r5_y_15, r5_z_15, r5_x_17))).xyzx, float4(r5_x_17, r5_y_15, r5_z_15, r5_x_17))).xyz;
                }
                float r1_w_25 = dot(i.texcoord1.xyzx, i.texcoord1.xyzx);
                float r1_w_26 = rsqrt(r1_w_25);
                float4 unitWorldNormal_xyzw_19 = (r1_w_26.xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_19 = unitWorldNormal_xyzw_19.x;
                float unitWorldNormal_y_17 = unitWorldNormal_xyzw_19.y;
                float unitWorldNormal_z_17 = unitWorldNormal_xyzw_19.z;
                float3 r2_xyz_4 = (mad(_Metallic.xxxx, (mad(r2_xyz_2.xyzx, r3_y_2.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_27 = mad(-_Metallic, 0.96, 0.96);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(float4(unitWorldNormal_x_19, unitWorldNormal_y_17, unitWorldNormal_z_17, unitWorldNormal_x_19), unitViewDir_xyz_1.xyzx);
                float r1_x_2 = saturate(dot(float4(unitWorldNormal_x_19, unitWorldNormal_y_17, unitWorldNormal_z_17, unitWorldNormal_x_19), _WorldSpaceLightPos0.xyzx));
                float r1_y_2 = saturate(dot(float4(unitWorldNormal_x_19, unitWorldNormal_y_17, unitWorldNormal_z_17, unitWorldNormal_x_19), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r4_w_3.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(nDotV_w_6) + 1);
                float r2_w_17 = (r1_z_4 * r1_z_4);
                float r2_w_18 = (r2_w_17 * r2_w_17);
                float r1_z_5 = (r1_z_4 * r2_w_18);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r4_w_3 * r4_w_3);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r2_w_19 = (-r0_z_8 + 1);
                float r3_y_3 = mad(abs(nDotV_w_6), r2_w_19, r0_z_8);
                float r2_w_20 = mad(r1_x_2, r2_w_19, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * r2_w_20);
                float r0_w_8 = mad(r1_x_2, r3_y_3, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r2_w_21 = (r0_z_8 * r0_z_8);
                float r3_y_4 = mad(r1_y_2, r2_w_21, -r1_y_2);
                float r1_y_3 = mad(r3_y_4, r1_y_2, 1);
                float r2_w_22 = (r2_w_21 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r1_y_5 = (r2_w_22 / r1_y_4);
                float r0_w_11 = (r0_w_10 * r1_y_5);
                float r0_w_12 = (r0_w_11 * 3.1415927);
                float4 r0_xyzw_9 = (r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_y_8, r0_w_12));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_w_13 = r0_xyzw_9.w;
                float r0_w_14 = max(r0_w_13, 0);
                float r0_z_9 = mad(r0_z_8, r0_z_8, 1);
                float r0_z_10 = ((float4(1, 1, 1, 1) / r0_z_9)).z;
                float r0_w_15 = (r0_w_14 * asfloat(asint((float)((dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx) != 0))) & asint(1065353216)));
                float4 r5_xyzw_20 = mad(r6_xyz_1.xyzx, r0_y_9.xxxx, (max(((r8_xyz_4.xyzx + i.texcoord3.xyzx)).xyzx, float4(0, 0, 0, 0))).xyzx);
                float r5_x_20 = r5_xyzw_20.x;
                float r5_y_18 = r5_xyzw_20.y;
                float r5_z_18 = r5_xyzw_20.z;
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
                float r0_x_9 = (mad(((r1_w_27.xxxx * ((r2_xyz_2.xyzx * r3_y_2.xxxx)).xyzx)).xyxz, float4(r5_x_20, r5_y_18, r5_x_20, r5_z_18), float4(r0_x_8, r0_y_13, r0_x_8, r0_w_17))).x;
                float4 r0_xyzw_14 = mad(((r1_w_27.xxxx * ((r2_xyz_2.xyzx * r3_y_2.xxxx)).xyzx)).xyxz, float4(r5_x_20, r5_y_18, r5_x_20, r5_z_18), float4(r0_x_8, r0_y_13, r0_x_8, r0_w_17));
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
                float4 r0_xyzw_10 = mad(((r9_xyz_11.xyzx * r0_z_10.xxxx)).xyzx, float4(r1_x_9, r1_y_7, r1_z_6, r1_x_9), float4(r0_x_9, r0_y_14, r0_w_18, r0_x_9));
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
                float4 cb0_values[13];
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
                float4 cb2_values[3];
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
            SamplerComparisonState sampler_comparison_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_linear_clamp3;
            SamplerState sampler_MainTex;
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            Texture2D t2;
            TextureCube t3;
            Texture3D t4;
            TextureCube t5;
            struct program68Input
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
            struct program68Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program114Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program114Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program68Output vert(program68Input i)
            {
                program68Output o = (program68Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord5.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[12].xxxy, cb0_values[12].zzzw)).zw;
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_4 = ((worldPos_xyzw_4.yyyy * _EdgeColor.xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(cb0_values[6].xyzx, worldPos_xyzw_4.zzzz, (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_4.xyzx)).xyzx)).xyz;
                o.texcoord3.xyz = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program114Output frag(program114Input i)
            {
                program114Output o = (program114Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_2 = ((r4_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float4 r5_xyzw_1 = _DissolveMap.Sample(sampler_DissolveMap, (i.texcoord0.zwzz).xy);
                float r1_w_3 = (r5_xyzw_1.x + -cb0_values[10].x);
                float r2_w_1 = ((float4(1, 1, 1, 1) / cb0_values[10].y)).w;
                float r2_w_2 = saturate((r1_w_3 * r2_w_1));
                float r3_w_1 = mad(r2_w_2, -2, 3);
                float r2_w_3 = (r2_w_2 * r2_w_2);
                float r2_w_4 = (r2_w_3 * r3_w_1);
                float r1_w_4 = (r1_w_3 < 0);
                if (r1_w_4) discard;
                float3 r6_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r7_x_1 = cb4_values[9].z;
                float r7_y_1 = cb4_values[10].z;
                float r7_z_1 = cb4_values[11].z;
                float r1_w_5 = dot(viewDir_xyz_1.xyzx, float4(r7_x_1, r7_y_1, r7_z_1, r7_x_1));
                float3 r2_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_6 = mad(cb3_values[25].w, (-r1_w_5 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_5);
                float r1_w_7 = saturate(mad(r1_w_6, cb3_values[24].z, cb3_values[24].w));
                float r7_x_9;
                float r7_y_9;
                float r7_z_9;
                float r7_w_4;
                if (((cb6_values[0].x == 1)).x)
                {
                    float3 r7_xyz_6 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (((cb6_values[0].y == 1)).xxxx ? r7_xyz_6.xyzx : i.texcoord2.xyzx);
                    float r2_x_8 = r2_xyzw_8.x;
                    float r2_y_3 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float4 r2_xyzw_9 = (float4(r2_x_8, r2_y_3, r2_z_3, r2_x_8) + -cb6_values[6].xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_4 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float4 r7_xyzw_7 = (float4(r2_x_9, r2_x_9, r2_y_4, r2_z_4) * cb6_values[5].xxyz);
                    float r7_y_7 = r7_xyzw_7.y;
                    float r7_z_7 = r7_xyzw_7.z;
                    float r7_w_2 = r7_xyzw_7.w;
                    float r2_y_5 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r7_x_7 = max(r2_y_5, mad(r7_y_7, 0.25, 0.75));
                    float4 r7_xyzw_8 = t4.Sample(sampler_linear_clamp, (float4(r7_x_7, r7_z_7, r7_w_2, r7_x_7)).xyz);
                    r7_x_9 = r7_xyzw_8.x;
                    r7_y_9 = r7_xyzw_8.y;
                    r7_z_9 = r7_xyzw_8.z;
                    r7_w_4 = r7_xyzw_8.w;
                }
                else
                {
                    float4 r7_xyzw_2 = float4(1, 1, 1, 1);
                    r7_x_9 = r7_xyzw_2.x;
                    r7_y_9 = r7_xyzw_2.y;
                    r7_z_9 = r7_xyzw_2.z;
                    r7_w_4 = r7_xyzw_2.w;
                }
                float r2_y_7 = (r1_w_7 < 0.99);
                float r2_y_19;
                if (r2_y_7)
                {
                    float3 r7_xyz_10 = ((i.texcoord2.xyzx + -cb2_values[1].xyzx)).xyz;
                    float r2_y_9 = max(abs(r7_xyz_10.y), abs(r7_xyz_10.x));
                    float r2_y_10 = max(abs(r7_xyz_10.z), r2_y_9);
                    float r2_y_11 = (r2_y_10 + -cb2_values[2].z);
                    float r2_y_12 = max(r2_y_11, 1E-05);
                    float r2_y_13 = (r2_y_12 * cb2_values[2].w);
                    float r2_y_14 = (cb2_values[2].y / r2_y_13);
                    float r2_y_15 = (r2_y_14 + -cb2_values[2].x);
                    float r2_y_16 = (-r2_y_15 + 1);
                    float r8_x_2 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r7_xyz_10.xyzx + float4(0.0078125, 0.0078125, 0.0078125, 0))).xyzx).xyz, r2_y_16);
                    float r8_y_2 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r7_xyz_10.xyzx + float4(-0.0078125, -0.0078125, 0.0078125, 0))).xyzx).xyz, r2_y_16);
                    float r8_z_2 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r7_xyz_10.xyzx + float4(-0.0078125, 0.0078125, -0.0078125, 0))).xyzx).xyz, r2_y_16);
                    float r8_w_1 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r7_xyz_10.xyzx + float4(0.0078125, -0.0078125, -0.0078125, 0))).xyzx).xyz, r2_y_16);
                    float r2_y_17 = dot(float4(r8_x_2, r8_y_2, r8_z_2, r8_w_1), float4(0.25, 0.25, 0.25, 0.25));
                    float r2_z_6 = (-cb3_values[24].x + 1);
                    float r2_y_18 = mad(r2_y_17, r2_z_6, cb3_values[24].x);
                    r2_y_19 = r2_y_18;
                }
                else
                {
                    float r2_y_8 = 1;
                    r2_y_19 = r2_y_8;
                }
                float r1_w_8 = mad(r1_w_7, (-r2_y_19 + saturate(dot(float4(r7_x_9, r7_y_9, r7_z_9, r7_w_4), unity_OcclusionMaskSelector))), r2_y_19);
                float4 r7_xyzw_13 = t2.Sample(sampler_linear_clamp3, ((dot(r6_xyz_4.xyzx, r6_xyz_4.xyzx)).xxxx).xy);
                float4 r6_xyzw_5 = t3.Sample(sampler_linear_clamp2, r6_xyz_4.xyz);
                float r1_w_9 = (r1_w_8 * (r6_xyzw_5.w * r7_xyzw_13.x));
                float4 r2_xyzw_16 = (r1_w_9.xxxx * _LightColor0.xyzx);
                float r2_x_16 = r2_xyzw_16.x;
                float r2_y_20 = r2_xyzw_16.y;
                float r2_z_8 = r2_xyzw_16.z;
                float3 unitClipPos_xyz_6 = normalize(i.texcoord1);
                float3 r4_xyz_4 = (mad(cb0_values[10].zzzz, (mad(r4_xyz_2.xyzx, r2_w_4.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_12 = mad(-cb0_values[10].z, 0.96, 0.96);
                float r1_w_13 = (-cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitClipPos_xyz_6.xyzx, unitViewDir_xyz_1.xyzx);
                float r2_w_5 = saturate(dot(unitClipPos_xyz_6.xyzx, r1_xyz_1.xyzx));
                float r3_x_2 = saturate(dot(unitClipPos_xyz_6.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_13.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_5 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(nDotV_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_13 * r1_w_13);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(nDotV_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * mad(r2_w_5, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_5, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r3_x_2, r0_z_9, -r3_x_2), r3_x_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_w_5.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r2_x_16, r2_y_20, r2_z_8, r2_x_16));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r2_x_16, r2_x_16, r2_y_20, r2_z_8) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_14 = (r0_x_5 * r0_x_5);
                float r1_w_15 = (r1_w_14 * r1_w_14);
                float4 r2_xyzw_17 = (-r4_xyz_4.xyzx + float4(1, 1, 1, 0));
                float r2_x_17 = r2_xyzw_17.x;
                float r2_y_21 = r2_xyzw_17.y;
                float r2_z_9 = r2_xyzw_17.z;
                float4 r2_xyzw_18 = mad(float4(r2_x_17, r2_y_21, r2_z_9, r2_x_17), ((r0_x_5 * r1_w_15)).xxxx, r4_xyz_4.xyzx);
                float r2_x_18 = r2_xyzw_18.x;
                float r2_y_22 = r2_xyzw_18.y;
                float r2_z_10 = r2_xyzw_18.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_18, r2_y_22, r2_z_10, r2_x_18));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_12.xxxx * ((r2_w_4.xxxx * r4_xyz_2.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float r0_w_15 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8) * r0_w_19.xxxx)).xyz;
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
                float4 cb0_values[13];
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
                float4 cb2_values[3];
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
            SamplerComparisonState sampler_comparison_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_linear_clamp3;
            SamplerState sampler_MainTex;
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            Texture2D t2;
            TextureCube t3;
            Texture3D t4;
            TextureCube t5;
            struct program67Input
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
            struct program67Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program113Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program113Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program67Output vert(program67Input i)
            {
                program67Output o = (program67Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord5.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[12].xxxy, cb0_values[12].zzzw)).zw;
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_4 = ((worldPos_xyzw_4.yyyy * _EdgeColor.xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(cb0_values[6].xyzx, worldPos_xyzw_4.zzzz, (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_4.xyzx)).xyzx)).xyz;
                o.texcoord3.xyz = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program113Output frag(program113Input i)
            {
                program113Output o = (program113Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_2 = ((r4_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float4 r5_xyzw_1 = _DissolveMap.Sample(sampler_DissolveMap, (i.texcoord0.zwzz).xy);
                float r1_w_3 = (r5_xyzw_1.x + -cb0_values[10].x);
                float r2_w_1 = ((float4(1, 1, 1, 1) / cb0_values[10].y)).w;
                float r2_w_2 = saturate((r1_w_3 * r2_w_1));
                float r3_w_1 = mad(r2_w_2, -2, 3);
                float r2_w_3 = (r2_w_2 * r2_w_2);
                float r2_w_4 = (r2_w_3 * r3_w_1);
                float r1_w_4 = (r1_w_3 < 0);
                if (r1_w_4) discard;
                float3 r6_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r7_x_1 = cb4_values[9].z;
                float r7_y_1 = cb4_values[10].z;
                float r7_z_1 = cb4_values[11].z;
                float r1_w_5 = dot(viewDir_xyz_1.xyzx, float4(r7_x_1, r7_y_1, r7_z_1, r7_x_1));
                float3 r2_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_6 = mad(cb3_values[25].w, (-r1_w_5 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_5);
                float r1_w_7 = saturate(mad(r1_w_6, cb3_values[24].z, cb3_values[24].w));
                float r7_x_9;
                float r7_y_9;
                float r7_z_9;
                float r7_w_4;
                if (((cb6_values[0].x == 1)).x)
                {
                    float3 r7_xyz_6 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (((cb6_values[0].y == 1)).xxxx ? r7_xyz_6.xyzx : i.texcoord2.xyzx);
                    float r2_x_8 = r2_xyzw_8.x;
                    float r2_y_3 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float4 r2_xyzw_9 = (float4(r2_x_8, r2_y_3, r2_z_3, r2_x_8) + -cb6_values[6].xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_4 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float4 r7_xyzw_7 = (float4(r2_x_9, r2_x_9, r2_y_4, r2_z_4) * cb6_values[5].xxyz);
                    float r7_y_7 = r7_xyzw_7.y;
                    float r7_z_7 = r7_xyzw_7.z;
                    float r7_w_2 = r7_xyzw_7.w;
                    float r2_y_5 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r7_x_7 = max(r2_y_5, mad(r7_y_7, 0.25, 0.75));
                    float4 r7_xyzw_8 = t4.Sample(sampler_linear_clamp, (float4(r7_x_7, r7_z_7, r7_w_2, r7_x_7)).xyz);
                    r7_x_9 = r7_xyzw_8.x;
                    r7_y_9 = r7_xyzw_8.y;
                    r7_z_9 = r7_xyzw_8.z;
                    r7_w_4 = r7_xyzw_8.w;
                }
                else
                {
                    float4 r7_xyzw_2 = float4(1, 1, 1, 1);
                    r7_x_9 = r7_xyzw_2.x;
                    r7_y_9 = r7_xyzw_2.y;
                    r7_z_9 = r7_xyzw_2.z;
                    r7_w_4 = r7_xyzw_2.w;
                }
                float3 r7_xyz_10 = ((i.texcoord2.xyzx + -cb2_values[1].xyzx)).xyz;
                float r2_y_7 = max(abs(r7_xyz_10.y), abs(r7_xyz_10.x));
                float r2_y_8 = max(abs(r7_xyz_10.z), r2_y_7);
                float r2_y_9 = (r2_y_8 + -cb2_values[2].z);
                float r2_y_10 = max(r2_y_9, 1E-05);
                float r2_y_11 = (r2_y_10 * cb2_values[2].w);
                float r2_y_12 = (cb2_values[2].y / r2_y_11);
                float r2_y_13 = (r2_y_12 + -cb2_values[2].x);
                float r2_y_14 = (-r2_y_13 + 1);
                float r2_y_15 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, r7_xyz_10.xyz, r2_y_14);
                float r2_z_6 = (-cb3_values[24].x + 1);
                float r2_y_16 = mad(r2_y_15, r2_z_6, cb3_values[24].x);
                float r1_w_8 = mad(r1_w_7, (-r2_y_16 + saturate(dot(float4(r7_x_9, r7_y_9, r7_z_9, r7_w_4), unity_OcclusionMaskSelector))), r2_y_16);
                float4 r7_xyzw_11 = t2.Sample(sampler_linear_clamp3, ((dot(r6_xyz_4.xyzx, r6_xyz_4.xyzx)).xxxx).xy);
                float4 r6_xyzw_5 = t3.Sample(sampler_linear_clamp2, r6_xyz_4.xyz);
                float r1_w_9 = (r1_w_8 * (r6_xyzw_5.w * r7_xyzw_11.x));
                float4 r2_xyzw_16 = (r1_w_9.xxxx * _LightColor0.xyzx);
                float r2_x_16 = r2_xyzw_16.x;
                float r2_y_17 = r2_xyzw_16.y;
                float r2_z_7 = r2_xyzw_16.z;
                float3 unitClipPos_xyz_6 = normalize(i.texcoord1);
                float3 r4_xyz_4 = (mad(cb0_values[10].zzzz, (mad(r4_xyz_2.xyzx, r2_w_4.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_12 = mad(-cb0_values[10].z, 0.96, 0.96);
                float r1_w_13 = (-cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitClipPos_xyz_6.xyzx, unitViewDir_xyz_1.xyzx);
                float r2_w_5 = saturate(dot(unitClipPos_xyz_6.xyzx, r1_xyz_1.xyzx));
                float r3_x_2 = saturate(dot(unitClipPos_xyz_6.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_13.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_5 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(nDotV_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_13 * r1_w_13);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(nDotV_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * mad(r2_w_5, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_5, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r3_x_2, r0_z_9, -r3_x_2), r3_x_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_w_5.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r2_x_16, r2_y_17, r2_z_7, r2_x_16));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r2_x_16, r2_x_16, r2_y_17, r2_z_7) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_14 = (r0_x_5 * r0_x_5);
                float r1_w_15 = (r1_w_14 * r1_w_14);
                float4 r2_xyzw_17 = (-r4_xyz_4.xyzx + float4(1, 1, 1, 0));
                float r2_x_17 = r2_xyzw_17.x;
                float r2_y_18 = r2_xyzw_17.y;
                float r2_z_8 = r2_xyzw_17.z;
                float4 r2_xyzw_18 = mad(float4(r2_x_17, r2_y_18, r2_z_8, r2_x_17), ((r0_x_5 * r1_w_15)).xxxx, r4_xyz_4.xyzx);
                float r2_x_18 = r2_xyzw_18.x;
                float r2_y_19 = r2_xyzw_18.y;
                float r2_z_9 = r2_xyzw_18.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_18, r2_y_19, r2_z_9, r2_x_18));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_12.xxxx * ((r2_w_4.xxxx * r4_xyz_2.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float r0_w_15 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8) * r0_w_19.xxxx)).xyz;
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
                float4 cb0_values[13];
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
                float4 cb2_values[3];
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
            SamplerComparisonState sampler_comparison_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            Texture2D t2;
            Texture3D t3;
            TextureCube t4;
            struct program66Input
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
            struct program66Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program112Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program112Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program66Output vert(program66Input i)
            {
                program66Output o = (program66Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord5.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[12].xxxy, cb0_values[12].zzzw)).zw;
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_4 = ((worldPos_xyzw_4.yyyy * _EdgeColor.xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(cb0_values[6].xyzx, worldPos_xyzw_4.zzzz, (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_4.xyzx)).xyzx)).xyz;
                o.texcoord3.xyz = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program112Output frag(program112Input i)
            {
                program112Output o = (program112Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_2 = ((r4_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float4 r5_xyzw_1 = _DissolveMap.Sample(sampler_DissolveMap, (i.texcoord0.zwzz).xy);
                float r1_w_3 = (r5_xyzw_1.x + -cb0_values[10].x);
                float r2_w_1 = ((float4(1, 1, 1, 1) / cb0_values[10].y)).w;
                float r2_w_2 = saturate((r1_w_3 * r2_w_1));
                float r3_w_1 = mad(r2_w_2, -2, 3);
                float r2_w_3 = (r2_w_2 * r2_w_2);
                float r2_w_4 = (r2_w_3 * r3_w_1);
                float r1_w_4 = (r1_w_3 < 0);
                if (r1_w_4) discard;
                float3 r6_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r7_x_1 = cb4_values[9].z;
                float r7_y_1 = cb4_values[10].z;
                float r7_z_1 = cb4_values[11].z;
                float r1_w_5 = dot(viewDir_xyz_1.xyzx, float4(r7_x_1, r7_y_1, r7_z_1, r7_x_1));
                float3 r2_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_6 = mad(cb3_values[25].w, (-r1_w_5 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_5);
                float r1_w_7 = saturate(mad(r1_w_6, cb3_values[24].z, cb3_values[24].w));
                float r7_x_9;
                float r7_y_9;
                float r7_z_9;
                float r7_w_4;
                if (((cb6_values[0].x == 1)).x)
                {
                    float3 r7_xyz_6 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (((cb6_values[0].y == 1)).xxxx ? r7_xyz_6.xyzx : i.texcoord2.xyzx);
                    float r2_x_8 = r2_xyzw_8.x;
                    float r2_y_3 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float4 r2_xyzw_9 = (float4(r2_x_8, r2_y_3, r2_z_3, r2_x_8) + -cb6_values[6].xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_4 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float4 r7_xyzw_7 = (float4(r2_x_9, r2_x_9, r2_y_4, r2_z_4) * cb6_values[5].xxyz);
                    float r7_y_7 = r7_xyzw_7.y;
                    float r7_z_7 = r7_xyzw_7.z;
                    float r7_w_2 = r7_xyzw_7.w;
                    float r2_y_5 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r7_x_7 = max(r2_y_5, mad(r7_y_7, 0.25, 0.75));
                    float4 r7_xyzw_8 = t3.Sample(sampler_linear_clamp, (float4(r7_x_7, r7_z_7, r7_w_2, r7_x_7)).xyz);
                    r7_x_9 = r7_xyzw_8.x;
                    r7_y_9 = r7_xyzw_8.y;
                    r7_z_9 = r7_xyzw_8.z;
                    r7_w_4 = r7_xyzw_8.w;
                }
                else
                {
                    float4 r7_xyzw_2 = float4(1, 1, 1, 1);
                    r7_x_9 = r7_xyzw_2.x;
                    r7_y_9 = r7_xyzw_2.y;
                    r7_z_9 = r7_xyzw_2.z;
                    r7_w_4 = r7_xyzw_2.w;
                }
                float r2_y_7 = (r1_w_7 < 0.99);
                float r2_y_19;
                if (r2_y_7)
                {
                    float3 r7_xyz_10 = ((i.texcoord2.xyzx + -cb2_values[1].xyzx)).xyz;
                    float r2_y_9 = max(abs(r7_xyz_10.y), abs(r7_xyz_10.x));
                    float r2_y_10 = max(abs(r7_xyz_10.z), r2_y_9);
                    float r2_y_11 = (r2_y_10 + -cb2_values[2].z);
                    float r2_y_12 = max(r2_y_11, 1E-05);
                    float r2_y_13 = (r2_y_12 * cb2_values[2].w);
                    float r2_y_14 = (cb2_values[2].y / r2_y_13);
                    float r2_y_15 = (r2_y_14 + -cb2_values[2].x);
                    float r2_y_16 = (-r2_y_15 + 1);
                    float r8_x_2 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r7_xyz_10.xyzx + float4(0.0078125, 0.0078125, 0.0078125, 0))).xyzx).xyz, r2_y_16);
                    float r8_y_2 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r7_xyz_10.xyzx + float4(-0.0078125, -0.0078125, 0.0078125, 0))).xyzx).xyz, r2_y_16);
                    float r8_z_2 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r7_xyz_10.xyzx + float4(-0.0078125, 0.0078125, -0.0078125, 0))).xyzx).xyz, r2_y_16);
                    float r8_w_1 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r7_xyz_10.xyzx + float4(0.0078125, -0.0078125, -0.0078125, 0))).xyzx).xyz, r2_y_16);
                    float r2_y_17 = dot(float4(r8_x_2, r8_y_2, r8_z_2, r8_w_1), float4(0.25, 0.25, 0.25, 0.25));
                    float r2_z_6 = (-cb3_values[24].x + 1);
                    float r2_y_18 = mad(r2_y_17, r2_z_6, cb3_values[24].x);
                    r2_y_19 = r2_y_18;
                }
                else
                {
                    float r2_y_8 = 1;
                    r2_y_19 = r2_y_8;
                }
                float r1_w_8 = mad(r1_w_7, (-r2_y_19 + saturate(dot(float4(r7_x_9, r7_y_9, r7_z_9, r7_w_4), unity_OcclusionMaskSelector))), r2_y_19);
                float4 r6_xyzw_5 = t2.Sample(sampler_linear_clamp2, ((dot(r6_xyz_4.xyzx, r6_xyz_4.xyzx)).xxxx).xy);
                float r1_w_9 = (r1_w_8 * r6_xyzw_5.x);
                float4 r2_xyzw_15 = (r1_w_9.xxxx * _LightColor0.xyzx);
                float r2_x_15 = r2_xyzw_15.x;
                float r2_y_20 = r2_xyzw_15.y;
                float r2_z_8 = r2_xyzw_15.z;
                float3 unitClipPos_xyz_6 = normalize(i.texcoord1);
                float3 r4_xyz_4 = (mad(cb0_values[10].zzzz, (mad(r4_xyz_2.xyzx, r2_w_4.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_12 = mad(-cb0_values[10].z, 0.96, 0.96);
                float r1_w_13 = (-cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitClipPos_xyz_6.xyzx, unitViewDir_xyz_1.xyzx);
                float r2_w_5 = saturate(dot(unitClipPos_xyz_6.xyzx, r1_xyz_1.xyzx));
                float r3_x_2 = saturate(dot(unitClipPos_xyz_6.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_13.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_5 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(nDotV_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_13 * r1_w_13);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(nDotV_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * mad(r2_w_5, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_5, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r3_x_2, r0_z_9, -r3_x_2), r3_x_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_w_5.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r2_x_15, r2_y_20, r2_z_8, r2_x_15));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r2_x_15, r2_x_15, r2_y_20, r2_z_8) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_14 = (r0_x_5 * r0_x_5);
                float r1_w_15 = (r1_w_14 * r1_w_14);
                float4 r2_xyzw_16 = (-r4_xyz_4.xyzx + float4(1, 1, 1, 0));
                float r2_x_16 = r2_xyzw_16.x;
                float r2_y_21 = r2_xyzw_16.y;
                float r2_z_9 = r2_xyzw_16.z;
                float4 r2_xyzw_17 = mad(float4(r2_x_16, r2_y_21, r2_z_9, r2_x_16), ((r0_x_5 * r1_w_15)).xxxx, r4_xyz_4.xyzx);
                float r2_x_17 = r2_xyzw_17.x;
                float r2_y_22 = r2_xyzw_17.y;
                float r2_z_10 = r2_xyzw_17.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_17, r2_y_22, r2_z_10, r2_x_17));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_12.xxxx * ((r2_w_4.xxxx * r4_xyz_2.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float r0_w_15 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8) * r0_w_19.xxxx)).xyz;
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
                float4 cb0_values[13];
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
                float4 cb2_values[3];
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
            SamplerComparisonState sampler_comparison_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            Texture2D t2;
            Texture3D t3;
            TextureCube t4;
            struct program65Input
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
            struct program65Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program111Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program111Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program65Output vert(program65Input i)
            {
                program65Output o = (program65Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord5.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[12].xxxy, cb0_values[12].zzzw)).zw;
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_4 = ((worldPos_xyzw_4.yyyy * _EdgeColor.xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(cb0_values[6].xyzx, worldPos_xyzw_4.zzzz, (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_4.xyzx)).xyzx)).xyz;
                o.texcoord3.xyz = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program111Output frag(program111Input i)
            {
                program111Output o = (program111Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_2 = ((r4_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float4 r5_xyzw_1 = _DissolveMap.Sample(sampler_DissolveMap, (i.texcoord0.zwzz).xy);
                float r1_w_3 = (r5_xyzw_1.x + -cb0_values[10].x);
                float r2_w_1 = ((float4(1, 1, 1, 1) / cb0_values[10].y)).w;
                float r2_w_2 = saturate((r1_w_3 * r2_w_1));
                float r3_w_1 = mad(r2_w_2, -2, 3);
                float r2_w_3 = (r2_w_2 * r2_w_2);
                float r2_w_4 = (r2_w_3 * r3_w_1);
                float r1_w_4 = (r1_w_3 < 0);
                if (r1_w_4) discard;
                float3 r6_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r7_x_1 = cb4_values[9].z;
                float r7_y_1 = cb4_values[10].z;
                float r7_z_1 = cb4_values[11].z;
                float r1_w_5 = dot(viewDir_xyz_1.xyzx, float4(r7_x_1, r7_y_1, r7_z_1, r7_x_1));
                float3 r2_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_6 = mad(cb3_values[25].w, (-r1_w_5 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_5);
                float r1_w_7 = saturate(mad(r1_w_6, cb3_values[24].z, cb3_values[24].w));
                float r7_x_9;
                float r7_y_9;
                float r7_z_9;
                float r7_w_4;
                if (((cb6_values[0].x == 1)).x)
                {
                    float3 r7_xyz_6 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (((cb6_values[0].y == 1)).xxxx ? r7_xyz_6.xyzx : i.texcoord2.xyzx);
                    float r2_x_8 = r2_xyzw_8.x;
                    float r2_y_3 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float4 r2_xyzw_9 = (float4(r2_x_8, r2_y_3, r2_z_3, r2_x_8) + -cb6_values[6].xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_4 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float4 r7_xyzw_7 = (float4(r2_x_9, r2_x_9, r2_y_4, r2_z_4) * cb6_values[5].xxyz);
                    float r7_y_7 = r7_xyzw_7.y;
                    float r7_z_7 = r7_xyzw_7.z;
                    float r7_w_2 = r7_xyzw_7.w;
                    float r2_y_5 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r7_x_7 = max(r2_y_5, mad(r7_y_7, 0.25, 0.75));
                    float4 r7_xyzw_8 = t3.Sample(sampler_linear_clamp, (float4(r7_x_7, r7_z_7, r7_w_2, r7_x_7)).xyz);
                    r7_x_9 = r7_xyzw_8.x;
                    r7_y_9 = r7_xyzw_8.y;
                    r7_z_9 = r7_xyzw_8.z;
                    r7_w_4 = r7_xyzw_8.w;
                }
                else
                {
                    float4 r7_xyzw_2 = float4(1, 1, 1, 1);
                    r7_x_9 = r7_xyzw_2.x;
                    r7_y_9 = r7_xyzw_2.y;
                    r7_z_9 = r7_xyzw_2.z;
                    r7_w_4 = r7_xyzw_2.w;
                }
                float3 r7_xyz_10 = ((i.texcoord2.xyzx + -cb2_values[1].xyzx)).xyz;
                float r2_y_7 = max(abs(r7_xyz_10.y), abs(r7_xyz_10.x));
                float r2_y_8 = max(abs(r7_xyz_10.z), r2_y_7);
                float r2_y_9 = (r2_y_8 + -cb2_values[2].z);
                float r2_y_10 = max(r2_y_9, 1E-05);
                float r2_y_11 = (r2_y_10 * cb2_values[2].w);
                float r2_y_12 = (cb2_values[2].y / r2_y_11);
                float r2_y_13 = (r2_y_12 + -cb2_values[2].x);
                float r2_y_14 = (-r2_y_13 + 1);
                float r2_y_15 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, r7_xyz_10.xyz, r2_y_14);
                float r2_z_6 = (-cb3_values[24].x + 1);
                float r2_y_16 = mad(r2_y_15, r2_z_6, cb3_values[24].x);
                float r1_w_8 = mad(r1_w_7, (-r2_y_16 + saturate(dot(float4(r7_x_9, r7_y_9, r7_z_9, r7_w_4), unity_OcclusionMaskSelector))), r2_y_16);
                float4 r6_xyzw_5 = t2.Sample(sampler_linear_clamp2, ((dot(r6_xyz_4.xyzx, r6_xyz_4.xyzx)).xxxx).xy);
                float r1_w_9 = (r1_w_8 * r6_xyzw_5.x);
                float4 r2_xyzw_15 = (r1_w_9.xxxx * _LightColor0.xyzx);
                float r2_x_15 = r2_xyzw_15.x;
                float r2_y_17 = r2_xyzw_15.y;
                float r2_z_7 = r2_xyzw_15.z;
                float3 unitClipPos_xyz_6 = normalize(i.texcoord1);
                float3 r4_xyz_4 = (mad(cb0_values[10].zzzz, (mad(r4_xyz_2.xyzx, r2_w_4.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_12 = mad(-cb0_values[10].z, 0.96, 0.96);
                float r1_w_13 = (-cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitClipPos_xyz_6.xyzx, unitViewDir_xyz_1.xyzx);
                float r2_w_5 = saturate(dot(unitClipPos_xyz_6.xyzx, r1_xyz_1.xyzx));
                float r3_x_2 = saturate(dot(unitClipPos_xyz_6.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_13.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_5 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(nDotV_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_13 * r1_w_13);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(nDotV_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * mad(r2_w_5, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_5, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r3_x_2, r0_z_9, -r3_x_2), r3_x_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_w_5.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r2_x_15, r2_y_17, r2_z_7, r2_x_15));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r2_x_15, r2_x_15, r2_y_17, r2_z_7) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_14 = (r0_x_5 * r0_x_5);
                float r1_w_15 = (r1_w_14 * r1_w_14);
                float4 r2_xyzw_16 = (-r4_xyz_4.xyzx + float4(1, 1, 1, 0));
                float r2_x_16 = r2_xyzw_16.x;
                float r2_y_18 = r2_xyzw_16.y;
                float r2_z_8 = r2_xyzw_16.z;
                float4 r2_xyzw_17 = mad(float4(r2_x_16, r2_y_18, r2_z_8, r2_x_16), ((r0_x_5 * r1_w_15)).xxxx, r4_xyz_4.xyzx);
                float r2_x_17 = r2_xyzw_17.x;
                float r2_y_19 = r2_xyzw_17.y;
                float r2_z_9 = r2_xyzw_17.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_17, r2_y_19, r2_z_9, r2_x_17));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_12.xxxx * ((r2_w_4.xxxx * r4_xyz_2.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float r0_w_15 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8) * r0_w_19.xxxx)).xyz;
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
                float4 cb0_values[13];
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
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            Texture2D t2;
            Texture2D t3;
            Texture3D t4;
            struct program64Input
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
            struct program64Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float texcoord5 : TEXCOORD5;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program110Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float texcoord5 : TEXCOORD5;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program110Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program64Output vert(program64Input i)
            {
                program64Output o = (program64Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[12].xxxy, cb0_values[12].zzzw)).zw;
                float worldNormal_x_4 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r2_w_4 = dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4));
                float r2_w_5 = rsqrt(r2_w_4);
                o.texcoord1.xyz = ((r2_w_5.xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4))).xyz;
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord3.xy = (mad(_MainTex_ST.xyxx, r0_xyzw_4.wwww, (mad(cb0_values[6].xyxx, r0_xyzw_4.zzzz, (mad(_Color.xyxx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * _EdgeColor.xyxx)).xyxx)).xyxx)).xyxx)).xy;
                o.texcoord5.x = clipPos_xyzw_2.z;
                o.texcoord4.zw = (clipPos_xyzw_2.zzzw).zw;
                float2 r1_xz_3 = ((clipPos_xyzw_2.xxwx * float4(0.5, 0, 0.5, 0))).xz;
                float r1_w_3 = ((clipPos_xyzw_2.y * unity_WorldToObject[1].x) * 0.5);
                o.texcoord4.xy = ((r1_xz_3.yyyy + float4(r1_xz_3.x, r1_w_3, r1_xz_3.x, r1_xz_3.x))).xy;
                return o;
            }
            #pragma fragment frag
            program110Output frag(program110Input i)
            {
                program110Output o = (program110Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_2 = ((r2_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float4 r3_xyzw_1 = _DissolveMap.Sample(sampler_DissolveMap, (i.texcoord0.zwzz).xy);
                float r1_w_1 = (r3_xyzw_1.x + -cb0_values[10].x);
                float r2_w_2 = ((float4(1, 1, 1, 1) / cb0_values[10].y)).w;
                float r2_w_3 = saturate((r1_w_1 * r2_w_2));
                float r2_w_4 = (r2_w_3 * r2_w_3);
                float r2_w_5 = (r2_w_4 * mad(r2_w_3, -2, 3));
                float r1_w_2 = (r1_w_1 < 0);
                if (r1_w_2) discard;
                float4 r3_xyzw_3 = (r2_w_5.xxxx * r2_xyz_2.xyzx);
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r3_z_2 = r3_xyzw_3.z;
                float r5_x_1 = cb4_values[9].z;
                float r5_y_1 = cb4_values[10].z;
                float r5_z_1 = cb4_values[11].z;
                float r1_w_3 = dot(viewDir_xyz_1.xyzx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1));
                float3 r5_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r3_w_2 = dot(r5_xyz_2.xyzx, r5_xyz_2.xyzx);
                float r3_w_3 = sqrt(r3_w_2);
                float r3_w_4 = (-r1_w_3 + r3_w_3);
                float r1_w_4 = mad(cb3_values[25].w, r3_w_4, r1_w_3);
                float r1_w_5 = saturate(mad(r1_w_4, cb3_values[24].z, cb3_values[24].w));
                float r3_w_5 = (cb6_values[0].x == 1);
                float r5_x_12;
                float r5_y_12;
                float r5_z_12;
                float r5_w_4;
                if (r3_w_5)
                {
                    float r3_w_6 = (cb6_values[0].y == 1);
                    float3 r5_xyz_7 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r5_xyzw_10 = (((((r3_w_6.xxxx ? r5_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r5_y_10 = r5_xyzw_10.y;
                    float r5_z_10 = r5_xyzw_10.z;
                    float r5_w_2 = r5_xyzw_10.w;
                    float r3_w_7 = mad(r5_y_10, 0.25, 0.75);
                    float r4_z_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r5_x_10 = max(r3_w_7, r4_z_1);
                    float4 r5_xyzw_11 = t4.Sample(sampler_linear_clamp, (float4(r5_x_10, r5_z_10, r5_w_2, r5_x_10)).xyz);
                    r5_x_12 = r5_xyzw_11.x;
                    r5_y_12 = r5_xyzw_11.y;
                    r5_z_12 = r5_xyzw_11.z;
                    r5_w_4 = r5_xyzw_11.w;
                }
                else
                {
                    float4 r5_xyzw_3 = float4(1, 1, 1, 1);
                    r5_x_12 = r5_xyzw_3.x;
                    r5_y_12 = r5_xyzw_3.y;
                    r5_z_12 = r5_xyzw_3.z;
                    r5_w_4 = r5_xyzw_3.w;
                }
                float r3_w_9 = saturate(dot(float4(r5_x_12, r5_y_12, r5_z_12, r5_w_4), unity_OcclusionMaskSelector));
                float4 r4_xyzw_3 = (i.texcoord4.xxxy / i.texcoord4.wwww);
                float r4_z_3 = r4_xyzw_3.z;
                float r4_w_1 = r4_xyzw_3.w;
                float4 r5_xyzw_13 = t2.Sample(sampler_linear_clamp1, (float4(r4_z_3, r4_w_1, r4_z_3, r4_z_3)).xy);
                float r3_w_10 = (r3_w_9 + -r5_xyzw_13.x);
                float r1_w_6 = mad(r1_w_5, r3_w_10, r5_xyzw_13.x);
                float4 r4_xyzw_5 = t3.Sample(sampler_linear_clamp2, ((((mad(cb0_values[6].xyxx, i.texcoord2.zzzz, (mad(cb0_values[4].xyxx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx).xy);
                float r1_w_7 = (r1_w_6 * r4_xyzw_5.w);
                float4 r4_xyzw_6 = (r1_w_7.xxxx * _LightColor0.xyzx);
                float r4_x_6 = r4_xyzw_6.x;
                float r4_y_6 = r4_xyzw_6.y;
                float r4_z_5 = r4_xyzw_6.z;
                float3 unitWorldNormal_xyz_14 = normalize(i.texcoord1);
                float3 r2_xyz_4 = (mad(cb0_values[10].zzzz, (mad(r2_xyz_2.xyzx, r2_w_5.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_10 = mad(-cb0_values[10].z, 0.96, 0.96);
                float4 r3_xyzw_4 = (r1_w_10.xxxx * float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r3_z_3 = r3_xyzw_4.z;
                float r1_w_11 = (-cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitWorldNormal_xyz_14.xyzx, unitViewDir_xyz_1.xyzx);
                float r1_x_2 = saturate(dot(unitWorldNormal_xyz_14.xyzx, _WorldSpaceLightPos0.xyzx));
                float r1_y_2 = saturate(dot(unitWorldNormal_xyz_14.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_11.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(nDotV_w_6) + 1);
                float r2_w_6 = (r1_z_4 * r1_z_4);
                float r2_w_7 = (r2_w_6 * r2_w_6);
                float r1_z_5 = (r1_z_4 * r2_w_7);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_11 * r1_w_11);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_z_6 = (-r0_z_8 + 1);
                float r1_w_12 = mad(abs(nDotV_w_6), r1_z_6, r0_z_8);
                float r1_z_7 = mad(r1_x_2, r1_z_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * r1_z_7);
                float r0_w_8 = mad(r1_x_2, r1_w_12, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_z_8 = mad(r1_y_2, r0_z_9, -r1_y_2);
                float r1_y_3 = mad(r1_z_8, r1_y_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r0_z_11 = (r0_z_10 / r1_y_4);
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_3 = (r0_y_9.xxxx * float4(r4_x_6, r4_y_6, r4_z_5, r4_x_6));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_5 = r1_xyzw_3.y;
                float r1_z_9 = r1_xyzw_3.z;
                float4 r0_xyzw_10 = (float4(r4_x_6, r4_x_6, r4_y_6, r4_z_5) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_13 = (r0_x_5 * r0_x_5);
                float r1_w_14 = (r1_w_13 * r1_w_13);
                float4 r4_xyzw_7 = (-r2_xyz_4.xyzx + float4(1, 1, 1, 0));
                float r4_x_7 = r4_xyzw_7.x;
                float r4_y_7 = r4_xyzw_7.y;
                float r4_z_6 = r4_xyzw_7.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * (mad(float4(r4_x_7, r4_y_7, r4_z_6, r4_x_7), ((r0_x_5 * r1_w_14)).xxxx, r2_xyz_4.xyzx)).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float r0_w_15 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8) * r0_w_19.xxxx)).xyz;
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
                float4 cb0_values[7];
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
            SamplerState sampler_MainTex;
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            Texture2D t2;
            Texture3D t3;
            struct program63Input
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
            struct program63Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program109Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program109Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program63Output vert(program63Input i)
            {
                program63Output o = (program63Output)0;
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
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _MainTex_ST.xxxy, _MainTex_ST.zzzw)).zw;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord5.x = clipPos_xyzw_7.z;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r1_xyzw_3 = (float4(clipPos_xyzw_7.x, clipPos_xyzw_7.x, clipPos_xyzw_7.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_z_3 = r1_xyzw_3.z;
                float r1_w_4 = r1_xyzw_3.w;
                o.texcoord4.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord4.xy = ((r1_z_3.xxxx + float4(r1_x_3, r1_w_4, r1_x_3, r1_x_3))).xy;
                return o;
            }
            #pragma fragment frag
            program109Output frag(program109Input i)
            {
                program109Output o = (program109Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_2 = ((r2_xyzw_1.xyzx * cb0_values[4].xyzx)).xyz;
                float4 r3_xyzw_1 = _DissolveMap.Sample(sampler_DissolveMap, (i.texcoord0.zwzz).xy);
                float r1_w_1 = (r3_xyzw_1.x + -cb0_values[6].x);
                float r2_w_2 = ((float4(1, 1, 1, 1) / cb0_values[6].y)).w;
                float r2_w_3 = saturate((r1_w_1 * r2_w_2));
                float r2_w_4 = (r2_w_3 * r2_w_3);
                float r2_w_5 = (r2_w_4 * mad(r2_w_3, -2, 3));
                float r1_w_2 = (r1_w_1 < 0);
                if (r1_w_2) discard;
                float4 r3_xyzw_3 = (r2_w_5.xxxx * r2_xyz_2.xyzx);
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r3_z_2 = r3_xyzw_3.z;
                float r4_x_1 = cb4_values[9].z;
                float r4_y_1 = cb4_values[10].z;
                float r4_z_1 = cb4_values[11].z;
                float r1_w_3 = dot(viewDir_xyz_1.xyzx, float4(r4_x_1, r4_y_1, r4_z_1, r4_x_1));
                float3 r4_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r3_w_2 = dot(r4_xyz_2.xyzx, r4_xyz_2.xyzx);
                float r3_w_3 = sqrt(r3_w_2);
                float r3_w_4 = (-r1_w_3 + r3_w_3);
                float r1_w_4 = mad(cb3_values[25].w, r3_w_4, r1_w_3);
                float r1_w_5 = saturate(mad(r1_w_4, cb3_values[24].z, cb3_values[24].w));
                float r3_w_5 = (cb6_values[0].x == 1);
                float r4_x_12;
                float r4_y_13;
                float r4_z_12;
                float r4_w_4;
                if (r3_w_5)
                {
                    float r3_w_6 = (cb6_values[0].y == 1);
                    float3 r4_xyz_7 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r4_xyzw_10 = (((((r3_w_6.xxxx ? r4_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r4_y_10 = r4_xyzw_10.y;
                    float r4_z_10 = r4_xyzw_10.z;
                    float r4_w_2 = r4_xyzw_10.w;
                    float r3_w_7 = mad(r4_y_10, 0.25, 0.75);
                    float r4_y_11 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r4_x_10 = max(r3_w_7, r4_y_11);
                    float4 r4_xyzw_11 = t3.Sample(sampler_linear_clamp, (float4(r4_x_10, r4_z_10, r4_w_2, r4_x_10)).xyz);
                    r4_x_12 = r4_xyzw_11.x;
                    r4_y_13 = r4_xyzw_11.y;
                    r4_z_12 = r4_xyzw_11.z;
                    r4_w_4 = r4_xyzw_11.w;
                }
                else
                {
                    float4 r4_xyzw_3 = float4(1, 1, 1, 1);
                    r4_x_12 = r4_xyzw_3.x;
                    r4_y_13 = r4_xyzw_3.y;
                    r4_z_12 = r4_xyzw_3.z;
                    r4_w_4 = r4_xyzw_3.w;
                }
                float r3_w_9 = saturate(dot(float4(r4_x_12, r4_y_13, r4_z_12, r4_w_4), unity_OcclusionMaskSelector));
                float4 r4_xyzw_13 = (i.texcoord4.xyxx / i.texcoord4.wwww);
                float r4_x_13 = r4_xyzw_13.x;
                float r4_y_14 = r4_xyzw_13.y;
                float4 r4_xyzw_14 = t2.Sample(sampler_linear_clamp1, (float4(r4_x_13, r4_y_14, r4_x_13, r4_x_13)).xy);
                float r3_w_10 = (r3_w_9 + -r4_xyzw_14.x);
                float r1_w_6 = mad(r1_w_5, r3_w_10, r4_xyzw_14.x);
                float4 r4_xyzw_15 = (r1_w_6.xxxx * _LightColor0.xyzx);
                float r4_x_15 = r4_xyzw_15.x;
                float r4_y_16 = r4_xyzw_15.y;
                float r4_z_14 = r4_xyzw_15.z;
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float3 r2_xyz_4 = (mad(cb0_values[6].zzzz, (mad(r2_xyz_2.xyzx, r2_w_5.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_9 = mad(-cb0_values[6].z, 0.96, 0.96);
                float4 r3_xyzw_4 = (r1_w_9.xxxx * float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r3_z_3 = r3_xyzw_4.z;
                float r1_w_10 = (-cb0_values[6].w + 1);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitWorldNormal_xyz_1.xyzx, unitViewDir_xyz_1.xyzx);
                float r1_x_2 = saturate(dot(unitWorldNormal_xyz_1.xyzx, _WorldSpaceLightPos0.xyzx));
                float r1_y_2 = saturate(dot(unitWorldNormal_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_10.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(nDotV_w_6) + 1);
                float r2_w_6 = (r1_z_4 * r1_z_4);
                float r2_w_7 = (r2_w_6 * r2_w_6);
                float r1_z_5 = (r1_z_4 * r2_w_7);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_10 * r1_w_10);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_z_6 = (-r0_z_8 + 1);
                float r1_w_11 = mad(abs(nDotV_w_6), r1_z_6, r0_z_8);
                float r1_z_7 = mad(r1_x_2, r1_z_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * r1_z_7);
                float r0_w_8 = mad(r1_x_2, r1_w_11, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_z_8 = mad(r1_y_2, r0_z_9, -r1_y_2);
                float r1_y_3 = mad(r1_z_8, r1_y_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r0_z_11 = (r0_z_10 / r1_y_4);
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_3 = (r0_y_9.xxxx * float4(r4_x_15, r4_y_16, r4_z_14, r4_x_15));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_5 = r1_xyzw_3.y;
                float r1_z_9 = r1_xyzw_3.z;
                float4 r0_xyzw_10 = (float4(r4_x_15, r4_x_15, r4_y_16, r4_z_14) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_12 = (r0_x_5 * r0_x_5);
                float r1_w_13 = (r1_w_12 * r1_w_12);
                float4 r4_xyzw_16 = (-r2_xyz_4.xyzx + float4(1, 1, 1, 0));
                float r4_x_16 = r4_xyzw_16.x;
                float r4_y_17 = r4_xyzw_16.y;
                float r4_z_15 = r4_xyzw_16.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * (mad(float4(r4_x_16, r4_y_17, r4_z_15, r4_x_16), ((r0_x_5 * r1_w_13)).xxxx, r2_xyz_4.xyzx)).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float r0_w_15 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8) * r0_w_19.xxxx)).xyz;
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
                float4 cb0_values[18];
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
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            Texture2D t2;
            Texture2D t3;
            Texture3D t4;
            Texture2D t5;
            struct program62Input
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
            struct program62Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program108Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program108Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program62Output vert(program62Input i)
            {
                program62Output o = (program62Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * unity_MatrixVP[1])));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord5.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[16].xyxx, cb0_values[16].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[17].xxxy, cb0_values[17].zzzw)).zw;
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float4 clipPos_xyzw_4 = (worldPos_xyzw_4.yyyy * cb0_values[10].xyzw);
                float4 clipPos_xyzw_5 = mad(cb0_values[9].xyzw, worldPos_xyzw_4.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb0_values[11].xyzw, worldPos_xyzw_4.zzzz, clipPos_xyzw_5);
                o.texcoord3.xyzw = mad(cb0_values[12].xyzw, worldPos_xyzw_4.wwww, clipPos_xyzw_6);
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program108Output frag(program108Input i)
            {
                program108Output o = (program108Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_2 = ((r4_xyzw_1.xyzx * cb0_values[13].xyzx)).xyz;
                float4 r5_xyzw_1 = _DissolveMap.Sample(sampler_DissolveMap, (i.texcoord0.zwzz).xy);
                float r1_w_3 = (r5_xyzw_1.x + -cb0_values[15].x);
                float r2_w_1 = ((float4(1, 1, 1, 1) / cb0_values[15].y)).w;
                float r2_w_2 = saturate((r1_w_3 * r2_w_1));
                float r3_w_1 = mad(r2_w_2, -2, 3);
                float r2_w_3 = (r2_w_2 * r2_w_2);
                float r2_w_4 = (r2_w_3 * r3_w_1);
                float r1_w_4 = (r1_w_3 < 0);
                if (r1_w_4) discard;
                float4 r6_xyzw_4 = (mad(cb0_values[11].xyzw, i.texcoord2.zzzz, mad(cb0_values[9].xyzw, i.texcoord2.xxxx, (i.texcoord2.yyyy * cb0_values[10].xyzw))) + cb0_values[12].xyzw);
                float r7_x_1 = cb4_values[9].z;
                float r7_y_1 = cb4_values[10].z;
                float r7_z_1 = cb4_values[11].z;
                float r1_w_5 = dot(viewDir_xyz_1.xyzx, float4(r7_x_1, r7_y_1, r7_z_1, r7_x_1));
                float3 r2_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_6 = mad(cb3_values[25].w, (-r1_w_5 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_5);
                float r1_w_7 = saturate(mad(r1_w_6, cb3_values[24].z, cb3_values[24].w));
                float r7_x_9;
                float r7_y_9;
                float r7_z_9;
                float r7_w_4;
                if (((cb6_values[0].x == 1)).x)
                {
                    float3 r7_xyz_6 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (((cb6_values[0].y == 1)).xxxx ? r7_xyz_6.xyzx : i.texcoord2.xyzx);
                    float r2_x_8 = r2_xyzw_8.x;
                    float r2_y_3 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float4 r2_xyzw_9 = (float4(r2_x_8, r2_y_3, r2_z_3, r2_x_8) + -cb6_values[6].xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_4 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float4 r7_xyzw_7 = (float4(r2_x_9, r2_x_9, r2_y_4, r2_z_4) * cb6_values[5].xxyz);
                    float r7_y_7 = r7_xyzw_7.y;
                    float r7_z_7 = r7_xyzw_7.z;
                    float r7_w_2 = r7_xyzw_7.w;
                    float r2_y_5 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r7_x_7 = max(r2_y_5, mad(r7_y_7, 0.25, 0.75));
                    float4 r7_xyzw_8 = t4.Sample(sampler_linear_clamp, (float4(r7_x_7, r7_z_7, r7_w_2, r7_x_7)).xyz);
                    r7_x_9 = r7_xyzw_8.x;
                    r7_y_9 = r7_xyzw_8.y;
                    r7_z_9 = r7_xyzw_8.z;
                    r7_w_4 = r7_xyzw_8.w;
                }
                else
                {
                    float4 r7_xyzw_2 = float4(1, 1, 1, 1);
                    r7_x_9 = r7_xyzw_2.x;
                    r7_y_9 = r7_xyzw_2.y;
                    r7_z_9 = r7_xyzw_2.z;
                    r7_w_4 = r7_xyzw_2.w;
                }
                float r2_y_7 = (r1_w_7 < 0.99);
                float r2_y_15;
                if (r2_y_7)
                {
                    float4 r7_xyzw_10 = (i.texcoord2.yyyy * cb3_values[9].xyzw);
                    float4 r7_xyzw_11 = mad(cb3_values[8].xyzw, i.texcoord2.xxxx, r7_xyzw_10);
                    float4 r7_xyzw_12 = mad(cb3_values[10].xyzw, i.texcoord2.zzzz, r7_xyzw_11);
                    float4 r7_xyzw_13 = (r7_xyzw_12 + cb3_values[11].xyzw);
                    float3 r7_xyz_14 = ((r7_xyzw_13.xyzx / r7_xyzw_13.wwww)).xyz;
                    float4 r2_xyzw_9 = mad(r7_xyz_14.xxyx, cb0_values[8].zzwz, float4(0, 0.5, 0.5, 0));
                    float r2_y_9 = r2_xyzw_9.y;
                    float r2_z_6 = r2_xyzw_9.z;
                    float4 r2_xyzw_10 = floor(float4(r2_y_9, r2_y_9, r2_z_6, r2_y_9));
                    float r2_y_10 = r2_xyzw_10.y;
                    float r2_z_7 = r2_xyzw_10.z;
                    float2 r7_xy_15 = (mad(r7_xyz_14.xyxx, cb0_values[8].zwzz, -float4(r2_y_10, r2_z_7, r2_y_10, r2_y_10))).xy;
                    float4 r8_xyzw_1 = (r7_xy_15.xxyy + float4(0.5, 1, 0.5, 1));
                    float2 r9_xw_1 = ((r8_xyzw_1.xxxz * r8_xyzw_1.xxxz)).xw;
                    float2 r8_xz_2 = (mad(r9_xw_1.xxyx, float4(0.5, 0, 0.5, 0), -r7_xy_15.xxyx)).xz;
                    float2 r10_zw_1 = (min(r7_xy_15.xxxy, float4(0, 0, 0, 0))).zw;
                    float2 r10_xy_2 = (mad(-r10_zw_1.xyxx, r10_zw_1.xyxx, ((-r7_xy_15.xyxx + float4(1, 1, 0, 0))).xyxx)).xy;
                    float2 r7_xy_16 = (max(r7_xy_15.xyxx, float4(0, 0, 0, 0))).xy;
                    float2 r7_xy_17 = (mad(-r7_xy_16.xyxx, r7_xy_16.xyxx, r8_xyzw_1.ywyy)).xy;
                    float r11_x_1 = r8_xz_2.x;
                    float r11_y_1 = r10_xy_2.x;
                    float r11_z_1 = r7_xy_17.x;
                    float r11_w_1 = r9_xw_1.x;
                    float4 r11_xyzw_2 = (float4(r11_x_1, r11_y_1, r11_z_1, r11_w_1) * float4(0.44444, 0.44444, 0.44444, 0.22222));
                    float r9_x_2 = r8_xz_2.y;
                    float r9_y_1 = r10_xy_2.y;
                    float r9_z_1 = r7_xy_17.y;
                    float4 r8_xyzw_3 = (float4(r9_x_2, r9_y_1, r9_z_1, r9_xw_1.y) * float4(0.44444, 0.44444, 0.44444, 0.22222));
                    float4 r9_xyzw_3 = (r11_xyzw_2.ywyw + r11_xyzw_2.xzxz);
                    float4 r10_xyzw_3 = (r8_xyzw_3.yyww + r8_xyzw_3.xxzz);
                    float4 r8_xyzw_4 = (r8_xyzw_3.ywyy / r10_xyzw_3.ywyy);
                    float r8_x_4 = r8_xyzw_4.x;
                    float r8_y_3 = r8_xyzw_4.y;
                    float4 r8_xyzw_5 = (float4(r8_x_4, r8_y_3, r8_x_4, r8_x_4) + float4(-1.5, 0.5, 0, 0));
                    float r8_x_5 = r8_xyzw_5.x;
                    float r8_y_4 = r8_xyzw_5.y;
                    float2 r11_xy_3 = ((((((r11_xyzw_2.ywyy / r9_xyzw_3.zwzz)).xyxx + float4(-1.5, 0.5, 0, 0))).xyxx * cb0_values[8].xxxx)).xy;
                    float2 r11_zw_3 = ((float4(r8_x_5, r8_x_5, r8_x_5, r8_y_4) * cb0_values[8].yyyy)).zw;
                    float4 r8_xyzw_6 = (r9_xyzw_3 * r10_xyzw_3);
                    float4 r9_xyzw_4 = mad(float4(r2_y_10, r2_z_7, r2_y_10, r2_z_7), cb0_values[8].xyxy, float4(r11_xy_3.x, r11_zw_3.x, r11_xy_3.y, r11_zw_3.x));
                    float r3_w_2 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r9_xyzw_4.xyxx).xy, r7_xyz_14.z);
                    float r4_w_2 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r9_xyzw_4.zwzz).xy, r7_xyz_14.z);
                    float r4_w_3 = (r4_w_2 * r8_xyzw_6.y);
                    float r3_w_3 = mad(r8_xyzw_6.x, r3_w_2, r4_w_3);
                    float4 r9_xyzw_5 = mad(float4(r2_y_10, r2_z_7, r2_y_10, r2_z_7), cb0_values[8].xyxy, float4(r11_xy_3.x, r11_zw_3.y, r11_xy_3.y, r11_zw_3.y));
                    float r2_y_11 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r9_xyzw_5.xyxx).xy, r7_xyz_14.z);
                    float r2_y_12 = mad(r8_xyzw_6.z, r2_y_11, r3_w_3);
                    float r2_z_8 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r9_xyzw_5.zwzz).xy, r7_xyz_14.z);
                    float r2_y_13 = mad(r8_xyzw_6.w, r2_z_8, r2_y_12);
                    float r2_z_9 = (-cb3_values[24].x + 1);
                    float r2_y_14 = mad(r2_y_13, r2_z_9, cb3_values[24].x);
                    r2_y_15 = r2_y_14;
                }
                else
                {
                    float r2_y_8 = 1;
                    r2_y_15 = r2_y_8;
                }
                float r1_w_8 = mad(r1_w_7, (-r2_y_15 + saturate(dot(float4(r7_x_9, r7_y_9, r7_z_9, r7_w_4), unity_OcclusionMaskSelector))), r2_y_15);
                float4 r2_xyzw_16 = (r6_xyzw_4.xxyx / r6_xyzw_4.wwww);
                float r2_y_16 = r2_xyzw_16.y;
                float r2_z_11 = r2_xyzw_16.z;
                float4 r2_xyzw_17 = (float4(r2_y_16, r2_y_16, r2_z_11, r2_y_16) + float4(0, 0.5, 0.5, 0));
                float r2_y_17 = r2_xyzw_17.y;
                float r2_z_12 = r2_xyzw_17.z;
                float4 r7_xyzw_21 = t2.Sample(sampler_linear_clamp2, (float4(r2_y_17, r2_z_12, r2_y_17, r2_y_17)).xy);
                float r2_y_18 = dot(r6_xyzw_4.xyzx, r6_xyzw_4.xyzx);
                float4 r6_xyzw_5 = t3.Sample(sampler_linear_clamp3, (r2_y_18.xxxx).xy);
                float r1_w_9 = (r1_w_8 * ((asfloat(asint((float)((0 < r6_xyzw_4.z))) & asint(1065353216)) * r7_xyzw_21.w) * r6_xyzw_5.x));
                float4 r2_xyzw_18 = (r1_w_9.xxxx * _LightColor0.xyzx);
                float r2_x_18 = r2_xyzw_18.x;
                float r2_y_19 = r2_xyzw_18.y;
                float r2_z_13 = r2_xyzw_18.z;
                float3 unitClipPos_xyz_6 = normalize(i.texcoord1);
                float3 r4_xyz_4 = (mad(cb0_values[15].zzzz, (mad(r4_xyz_2.xyzx, r2_w_4.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_12 = mad(-cb0_values[15].z, 0.96, 0.96);
                float r1_w_13 = (-cb0_values[15].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitClipPos_xyz_6.xyzx, unitViewDir_xyz_1.xyzx);
                float r2_w_5 = saturate(dot(unitClipPos_xyz_6.xyzx, r1_xyz_1.xyzx));
                float r3_x_2 = saturate(dot(unitClipPos_xyz_6.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_13.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_5 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(nDotV_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_13 * r1_w_13);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(nDotV_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * mad(r2_w_5, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_5, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r3_x_2, r0_z_9, -r3_x_2), r3_x_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_w_5.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r2_x_18, r2_y_19, r2_z_13, r2_x_18));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r2_x_18, r2_x_18, r2_y_19, r2_z_13) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_14 = (r0_x_5 * r0_x_5);
                float r1_w_15 = (r1_w_14 * r1_w_14);
                float4 r2_xyzw_19 = (-r4_xyz_4.xyzx + float4(1, 1, 1, 0));
                float r2_x_19 = r2_xyzw_19.x;
                float r2_y_20 = r2_xyzw_19.y;
                float r2_z_14 = r2_xyzw_19.z;
                float4 r2_xyzw_20 = mad(float4(r2_x_19, r2_y_20, r2_z_14, r2_x_19), ((r0_x_5 * r1_w_15)).xxxx, r4_xyz_4.xyzx);
                float r2_x_20 = r2_xyzw_20.x;
                float r2_y_21 = r2_xyzw_20.y;
                float r2_z_15 = r2_xyzw_20.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_20, r2_y_21, r2_z_15, r2_x_20));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_12.xxxx * ((r2_w_4.xxxx * r4_xyz_2.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float r0_w_15 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8) * r0_w_19.xxxx)).xyz;
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
                float4 cb0_values[13];
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
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            Texture2D t2;
            Texture2D t3;
            Texture3D t4;
            Texture2D t5;
            struct program61Input
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
            struct program61Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program107Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program107Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program61Output vert(program61Input i)
            {
                program61Output o = (program61Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * unity_MatrixVP[1])));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord5.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[12].xxxy, cb0_values[12].zzzw)).zw;
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float4 clipPos_xyzw_4 = (worldPos_xyzw_4.yyyy * _EdgeColor);
                float4 clipPos_xyzw_5 = mad(_Color, worldPos_xyzw_4.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb0_values[6].xyzw, worldPos_xyzw_4.zzzz, clipPos_xyzw_5);
                o.texcoord3.xyzw = mad(_MainTex_ST, worldPos_xyzw_4.wwww, clipPos_xyzw_6);
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program107Output frag(program107Input i)
            {
                program107Output o = (program107Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_2 = ((r4_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float4 r5_xyzw_1 = _DissolveMap.Sample(sampler_DissolveMap, (i.texcoord0.zwzz).xy);
                float r1_w_3 = (r5_xyzw_1.x + -cb0_values[10].x);
                float r2_w_1 = ((float4(1, 1, 1, 1) / cb0_values[10].y)).w;
                float r2_w_2 = saturate((r1_w_3 * r2_w_1));
                float r3_w_1 = mad(r2_w_2, -2, 3);
                float r2_w_3 = (r2_w_2 * r2_w_2);
                float r2_w_4 = (r2_w_3 * r3_w_1);
                float r1_w_4 = (r1_w_3 < 0);
                if (r1_w_4) discard;
                float4 r6_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord2.zzzz, mad(cb0_values[4].xyzw, i.texcoord2.xxxx, (i.texcoord2.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r7_x_1 = cb4_values[9].z;
                float r7_y_1 = cb4_values[10].z;
                float r7_z_1 = cb4_values[11].z;
                float r1_w_5 = dot(viewDir_xyz_1.xyzx, float4(r7_x_1, r7_y_1, r7_z_1, r7_x_1));
                float3 r2_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_6 = mad(cb3_values[25].w, (-r1_w_5 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_5);
                float r1_w_7 = saturate(mad(r1_w_6, cb3_values[24].z, cb3_values[24].w));
                float r7_x_9;
                float r7_y_9;
                float r7_z_9;
                float r7_w_4;
                if (((cb6_values[0].x == 1)).x)
                {
                    float3 r7_xyz_6 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (((cb6_values[0].y == 1)).xxxx ? r7_xyz_6.xyzx : i.texcoord2.xyzx);
                    float r2_x_8 = r2_xyzw_8.x;
                    float r2_y_3 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float4 r2_xyzw_9 = (float4(r2_x_8, r2_y_3, r2_z_3, r2_x_8) + -cb6_values[6].xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_4 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float4 r7_xyzw_7 = (float4(r2_x_9, r2_x_9, r2_y_4, r2_z_4) * cb6_values[5].xxyz);
                    float r7_y_7 = r7_xyzw_7.y;
                    float r7_z_7 = r7_xyzw_7.z;
                    float r7_w_2 = r7_xyzw_7.w;
                    float r2_y_5 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r7_x_7 = max(r2_y_5, mad(r7_y_7, 0.25, 0.75));
                    float4 r7_xyzw_8 = t4.Sample(sampler_linear_clamp, (float4(r7_x_7, r7_z_7, r7_w_2, r7_x_7)).xyz);
                    r7_x_9 = r7_xyzw_8.x;
                    r7_y_9 = r7_xyzw_8.y;
                    r7_z_9 = r7_xyzw_8.z;
                    r7_w_4 = r7_xyzw_8.w;
                }
                else
                {
                    float4 r7_xyzw_2 = float4(1, 1, 1, 1);
                    r7_x_9 = r7_xyzw_2.x;
                    r7_y_9 = r7_xyzw_2.y;
                    r7_z_9 = r7_xyzw_2.z;
                    r7_w_4 = r7_xyzw_2.w;
                }
                float4 r7_xyzw_10 = (i.texcoord2.yyyy * cb3_values[9].xyzw);
                float4 r7_xyzw_11 = mad(cb3_values[8].xyzw, i.texcoord2.xxxx, r7_xyzw_10);
                float4 r7_xyzw_12 = mad(cb3_values[10].xyzw, i.texcoord2.zzzz, r7_xyzw_11);
                float4 r7_xyzw_13 = (r7_xyzw_12 + cb3_values[11].xyzw);
                float3 r7_xyz_14 = ((r7_xyzw_13.xyzx / r7_xyzw_13.wwww)).xyz;
                float r2_y_7 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r7_xyz_14.xyxx).xy, r7_xyz_14.z);
                float r2_z_6 = (-cb3_values[24].x + 1);
                float r2_y_8 = mad(r2_y_7, r2_z_6, cb3_values[24].x);
                float r1_w_8 = mad(r1_w_7, (-r2_y_8 + saturate(dot(float4(r7_x_9, r7_y_9, r7_z_9, r7_w_4), unity_OcclusionMaskSelector))), r2_y_8);
                float4 r2_xyzw_9 = (r6_xyzw_4.xxyx / r6_xyzw_4.wwww);
                float r2_y_9 = r2_xyzw_9.y;
                float r2_z_7 = r2_xyzw_9.z;
                float4 r2_xyzw_10 = (float4(r2_y_9, r2_y_9, r2_z_7, r2_y_9) + float4(0, 0.5, 0.5, 0));
                float r2_y_10 = r2_xyzw_10.y;
                float r2_z_8 = r2_xyzw_10.z;
                float4 r7_xyzw_15 = t2.Sample(sampler_linear_clamp2, (float4(r2_y_10, r2_z_8, r2_y_10, r2_y_10)).xy);
                float r2_y_11 = dot(r6_xyzw_4.xyzx, r6_xyzw_4.xyzx);
                float4 r6_xyzw_5 = t3.Sample(sampler_linear_clamp3, (r2_y_11.xxxx).xy);
                float r1_w_9 = (r1_w_8 * ((asfloat(asint((float)((0 < r6_xyzw_4.z))) & asint(1065353216)) * r7_xyzw_15.w) * r6_xyzw_5.x));
                float4 r2_xyzw_18 = (r1_w_9.xxxx * _LightColor0.xyzx);
                float r2_x_18 = r2_xyzw_18.x;
                float r2_y_12 = r2_xyzw_18.y;
                float r2_z_9 = r2_xyzw_18.z;
                float3 unitClipPos_xyz_6 = normalize(i.texcoord1);
                float3 r4_xyz_4 = (mad(cb0_values[10].zzzz, (mad(r4_xyz_2.xyzx, r2_w_4.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_12 = mad(-cb0_values[10].z, 0.96, 0.96);
                float r1_w_13 = (-cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitClipPos_xyz_6.xyzx, unitViewDir_xyz_1.xyzx);
                float r2_w_5 = saturate(dot(unitClipPos_xyz_6.xyzx, r1_xyz_1.xyzx));
                float r3_x_2 = saturate(dot(unitClipPos_xyz_6.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_13.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_5 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(nDotV_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_13 * r1_w_13);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(nDotV_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * mad(r2_w_5, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_5, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r3_x_2, r0_z_9, -r3_x_2), r3_x_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_w_5.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r2_x_18, r2_y_12, r2_z_9, r2_x_18));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r2_x_18, r2_x_18, r2_y_12, r2_z_9) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_14 = (r0_x_5 * r0_x_5);
                float r1_w_15 = (r1_w_14 * r1_w_14);
                float4 r2_xyzw_19 = (-r4_xyz_4.xyzx + float4(1, 1, 1, 0));
                float r2_x_19 = r2_xyzw_19.x;
                float r2_y_13 = r2_xyzw_19.y;
                float r2_z_10 = r2_xyzw_19.z;
                float4 r2_xyzw_20 = mad(float4(r2_x_19, r2_y_13, r2_z_10, r2_x_19), ((r0_x_5 * r1_w_15)).xxxx, r4_xyz_4.xyzx);
                float r2_x_20 = r2_xyzw_20.x;
                float r2_y_14 = r2_xyzw_20.y;
                float r2_z_11 = r2_xyzw_20.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_20, r2_y_14, r2_z_11, r2_x_20));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_12.xxxx * ((r2_w_4.xxxx * r4_xyz_2.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float r0_w_15 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8) * r0_w_19.xxxx)).xyz;
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
                float4 cb0_values[13];
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
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            Texture2D t2;
            Texture3D t3;
            struct program60Input
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
            struct program60Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float texcoord5 : TEXCOORD5;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program106Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float texcoord5 : TEXCOORD5;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program106Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program60Output vert(program60Input i)
            {
                program60Output o = (program60Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord5.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[12].xxxy, cb0_values[12].zzzw)).zw;
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float2 clipPos_xy_4 = ((worldPos_xyzw_4.yyyy * _EdgeColor.xyxx)).xy;
                float2 clipPos_xy_5 = (mad(_Color.xyxx, worldPos_xyzw_4.xxxx, clipPos_xy_4.xyxx)).xy;
                float2 clipPos_xy_6 = (mad(cb0_values[6].xyxx, worldPos_xyzw_4.zzzz, clipPos_xy_5.xyxx)).xy;
                o.texcoord3.xy = (mad(_MainTex_ST.xyxx, worldPos_xyzw_4.wwww, clipPos_xy_6.xyxx)).xy;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program106Output frag(program106Input i)
            {
                program106Output o = (program106Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_2 = ((r2_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float4 r3_xyzw_1 = _DissolveMap.Sample(sampler_DissolveMap, (i.texcoord0.zwzz).xy);
                float r1_w_1 = (r3_xyzw_1.x + -cb0_values[10].x);
                float r2_w_2 = ((float4(1, 1, 1, 1) / cb0_values[10].y)).w;
                float r2_w_3 = saturate((r1_w_1 * r2_w_2));
                float r2_w_4 = (r2_w_3 * r2_w_3);
                float r2_w_5 = (r2_w_4 * mad(r2_w_3, -2, 3));
                float r1_w_2 = (r1_w_1 < 0);
                if (r1_w_2) discard;
                float4 r3_xyzw_3 = (r2_w_5.xxxx * r2_xyz_2.xyzx);
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r3_z_2 = r3_xyzw_3.z;
                float r1_w_3 = (cb4_values[0].x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r1_w_3)
                {
                    float r1_w_4 = (cb4_values[0].y == 1);
                    float3 r5_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord2.zzzz, (mad(cb4_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r5_xyzw_8 = (((((r1_w_4.xxxx ? r5_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r1_w_5 = mad(r5_y_8, 0.25, 0.75);
                    float r3_w_2 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r5_x_8 = max(r1_w_5, r3_w_2);
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
                float r1_w_7 = saturate(dot(float4(r5_x_10, r5_y_10, r5_z_10, r5_w_4), unity_OcclusionMaskSelector));
                float4 r4_xyzw_5 = t2.Sample(sampler_linear_clamp1, ((((mad(cb0_values[6].xyxx, i.texcoord2.zzzz, (mad(cb0_values[4].xyxx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx).xy);
                float r1_w_8 = (r1_w_7 * r4_xyzw_5.w);
                float4 r4_xyzw_6 = (r1_w_8.xxxx * _LightColor0.xyzx);
                float r4_x_6 = r4_xyzw_6.x;
                float r4_y_6 = r4_xyzw_6.y;
                float r4_z_2 = r4_xyzw_6.z;
                float3 unitWorldNormal_xyz_11 = normalize(i.texcoord1);
                float3 r2_xyz_4 = (mad(cb0_values[10].zzzz, (mad(r2_xyz_2.xyzx, r2_w_5.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_11 = mad(-cb0_values[10].z, 0.96, 0.96);
                float4 r3_xyzw_4 = (r1_w_11.xxxx * float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r3_z_3 = r3_xyzw_4.z;
                float r1_w_12 = (-cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitWorldNormal_xyz_11.xyzx, unitViewDir_xyz_1.xyzx);
                float r1_x_2 = saturate(dot(unitWorldNormal_xyz_11.xyzx, _WorldSpaceLightPos0.xyzx));
                float r1_y_2 = saturate(dot(unitWorldNormal_xyz_11.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_12.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(nDotV_w_6) + 1);
                float r2_w_6 = (r1_z_4 * r1_z_4);
                float r2_w_7 = (r2_w_6 * r2_w_6);
                float r1_z_5 = (r1_z_4 * r2_w_7);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_12 * r1_w_12);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_z_6 = (-r0_z_8 + 1);
                float r1_w_13 = mad(abs(nDotV_w_6), r1_z_6, r0_z_8);
                float r1_z_7 = mad(r1_x_2, r1_z_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * r1_z_7);
                float r0_w_8 = mad(r1_x_2, r1_w_13, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_z_8 = mad(r1_y_2, r0_z_9, -r1_y_2);
                float r1_y_3 = mad(r1_z_8, r1_y_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r0_z_11 = (r0_z_10 / r1_y_4);
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_3 = (r0_y_9.xxxx * float4(r4_x_6, r4_y_6, r4_z_2, r4_x_6));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_5 = r1_xyzw_3.y;
                float r1_z_9 = r1_xyzw_3.z;
                float4 r0_xyzw_10 = (float4(r4_x_6, r4_x_6, r4_y_6, r4_z_2) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_14 = (r0_x_5 * r0_x_5);
                float r1_w_15 = (r1_w_14 * r1_w_14);
                float4 r4_xyzw_7 = (-r2_xyz_4.xyzx + float4(1, 1, 1, 0));
                float r4_x_7 = r4_xyzw_7.x;
                float r4_y_7 = r4_xyzw_7.y;
                float r4_z_3 = r4_xyzw_7.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * (mad(float4(r4_x_7, r4_y_7, r4_z_3, r4_x_7), ((r0_x_5 * r1_w_15)).xxxx, r2_xyz_4.xyzx)).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float r0_w_15 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w));
                o.sv_Target0.xyz = ((float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8) * r0_w_19.xxxx)).xyz;
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
                float4 cb0_values[13];
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
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            Texture2D t2;
            TextureCube t3;
            Texture3D t4;
            struct program59Input
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
            struct program59Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program105Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program105Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program59Output vert(program59Input i)
            {
                program59Output o = (program59Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord5.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[12].xxxy, cb0_values[12].zzzw)).zw;
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_4 = ((worldPos_xyzw_4.yyyy * _EdgeColor.xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(cb0_values[6].xyzx, worldPos_xyzw_4.zzzz, (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_4.xyzx)).xyzx)).xyz;
                o.texcoord3.xyz = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program105Output frag(program105Input i)
            {
                program105Output o = (program105Output)0;
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
                float r1_w_5 = (cb4_values[0].x == 1);
                float r6_x_10;
                float r6_y_10;
                float r6_z_10;
                float r6_w_4;
                if (r1_w_5)
                {
                    float r1_w_6 = (cb4_values[0].y == 1);
                    float3 r6_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord2.zzzz, (mad(cb4_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r6_xyzw_8 = (((((r1_w_6.xxxx ? r6_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r6_y_8 = r6_xyzw_8.y;
                    float r6_z_8 = r6_xyzw_8.z;
                    float r6_w_2 = r6_xyzw_8.w;
                    float r1_w_7 = mad(r6_y_8, 0.25, 0.75);
                    float r3_w_3 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r6_x_8 = max(r1_w_7, r3_w_3);
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
                float r1_w_9 = saturate(dot(float4(r6_x_10, r6_y_10, r6_z_10, r6_w_4), unity_OcclusionMaskSelector));
                float r3_w_5 = dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx);
                float4 r6_xyzw_11 = t2.Sample(sampler_linear_clamp2, (r3_w_5.xxxx).xy);
                float4 r5_xyzw_5 = t3.Sample(sampler_linear_clamp1, r5_xyz_4.xyz);
                float r3_w_6 = (r5_xyzw_5.w * r6_xyzw_11.x);
                float r1_w_10 = (r1_w_9 * r3_w_6);
                float3 r5_xyz_6 = ((r1_w_10.xxxx * _LightColor0.xyzx)).xyz;
                float3 unitClipPos_xyz_12 = normalize(i.texcoord1);
                float3 r3_xyz_4 = (mad(cb0_values[10].zzzz, (mad(r3_xyz_2.xyzx, r2_w_4.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_13 = mad(-cb0_values[10].z, 0.96, 0.96);
                float r1_w_14 = (-cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_2.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitClipPos_xyz_12.xyzx, unitViewDir_xyz_2.xyzx);
                float r2_x_3 = saturate(dot(unitClipPos_xyz_12.xyzx, r1_xyz_1.xyzx));
                float r2_y_3 = saturate(dot(unitClipPos_xyz_12.xyzx, r0_xyz_3.xyzx));
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
                float4 r0_xyzw_8 = mad(((r1_w_13.xxxx * ((r2_w_4.xxxx * r3_xyz_2.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float r0_w_15 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w));
                o.sv_Target0.xyz = ((float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8) * r0_w_19.xxxx)).xyz;
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
                float4 cb0_values[13];
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
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            Texture2D t2;
            Texture2D t3;
            Texture3D t4;
            struct program58Input
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
            struct program58Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program104Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program104Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program58Output vert(program58Input i)
            {
                program58Output o = (program58Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * unity_MatrixVP[1])));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord5.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[12].xxxy, cb0_values[12].zzzw)).zw;
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float4 clipPos_xyzw_4 = (worldPos_xyzw_4.yyyy * _EdgeColor);
                float4 clipPos_xyzw_5 = mad(_Color, worldPos_xyzw_4.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb0_values[6].xyzw, worldPos_xyzw_4.zzzz, clipPos_xyzw_5);
                o.texcoord3.xyzw = mad(_MainTex_ST, worldPos_xyzw_4.wwww, clipPos_xyzw_6);
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program104Output frag(program104Input i)
            {
                program104Output o = (program104Output)0;
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
                float4 r5_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord2.zzzz, mad(cb0_values[4].xyzw, i.texcoord2.xxxx, (i.texcoord2.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r1_w_5 = (cb4_values[0].x == 1);
                float r6_x_10;
                float r6_y_10;
                float r6_z_10;
                float r6_w_4;
                if (r1_w_5)
                {
                    float r1_w_6 = (cb4_values[0].y == 1);
                    float3 r6_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord2.zzzz, (mad(cb4_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r6_xyzw_8 = (((((r1_w_6.xxxx ? r6_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r6_y_8 = r6_xyzw_8.y;
                    float r6_z_8 = r6_xyzw_8.z;
                    float r6_w_2 = r6_xyzw_8.w;
                    float r1_w_7 = mad(r6_y_8, 0.25, 0.75);
                    float r3_w_3 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r6_x_8 = max(r1_w_7, r3_w_3);
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
                float r1_w_9 = saturate(dot(float4(r6_x_10, r6_y_10, r6_z_10, r6_w_4), unity_OcclusionMaskSelector));
                float r3_w_5 = (0 < r5_xyzw_4.z);
                float r3_w_6 = asfloat(asint(r3_w_5) & asint(1065353216));
                float4 r6_xyzw_13 = t2.Sample(sampler_linear_clamp1, (((((r5_xyzw_4.xyxx / r5_xyzw_4.wwww)).xyxx + float4(0.5, 0.5, 0, 0))).xyxx).xy);
                float r3_w_7 = (r3_w_6 * r6_xyzw_13.w);
                float r4_w_2 = dot(r5_xyzw_4.xyzx, r5_xyzw_4.xyzx);
                float4 r5_xyzw_5 = t3.Sample(sampler_linear_clamp2, (r4_w_2.xxxx).xy);
                float r3_w_8 = (r3_w_7 * r5_xyzw_5.x);
                float r1_w_10 = (r1_w_9 * r3_w_8);
                float3 r5_xyz_6 = ((r1_w_10.xxxx * _LightColor0.xyzx)).xyz;
                float r1_w_11 = dot(i.texcoord1.xyzx, i.texcoord1.xyzx);
                float r1_w_12 = rsqrt(r1_w_11);
                float4 unitClipPos_xyzw_14 = (r1_w_12.xxxx * i.texcoord1.xyzx);
                float unitClipPos_x_14 = unitClipPos_xyzw_14.x;
                float unitClipPos_y_14 = unitClipPos_xyzw_14.y;
                float unitClipPos_z_12 = unitClipPos_xyzw_14.z;
                float3 r3_xyz_4 = (mad(cb0_values[10].zzzz, (mad(r3_xyz_2.xyzx, r2_w_4.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_13 = mad(-cb0_values[10].z, 0.96, 0.96);
                float r1_w_14 = (-cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_2.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(float4(unitClipPos_x_14, unitClipPos_y_14, unitClipPos_z_12, unitClipPos_x_14), unitViewDir_xyz_2.xyzx);
                float r2_x_3 = saturate(dot(float4(unitClipPos_x_14, unitClipPos_y_14, unitClipPos_z_12, unitClipPos_x_14), r1_xyz_1.xyzx));
                float r2_y_3 = saturate(dot(float4(unitClipPos_x_14, unitClipPos_y_14, unitClipPos_z_12, unitClipPos_x_14), r0_xyz_3.xyzx));
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
                float4 r0_xyzw_8 = mad(((r1_w_13.xxxx * ((r2_w_4.xxxx * r3_xyz_2.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float r0_w_15 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w));
                o.sv_Target0.xyz = ((float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8) * r0_w_19.xxxx)).xyz;
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
                float4 cb0_values[7];
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
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            Texture3D t2;
            struct program57Input
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
            struct program57Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program103Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program103Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program57Output vert(program57Input i)
            {
                program57Output o = (program57Output)0;
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
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _MainTex_ST.xxxy, _MainTex_ST.zzzw)).zw;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program103Output frag(program103Input i)
            {
                program103Output o = (program103Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_2 = ((r2_xyzw_1.xyzx * cb0_values[4].xyzx)).xyz;
                float4 r3_xyzw_1 = _DissolveMap.Sample(sampler_DissolveMap, (i.texcoord0.zwzz).xy);
                float r1_w_1 = (r3_xyzw_1.x + -cb0_values[6].x);
                float r2_w_2 = ((float4(1, 1, 1, 1) / cb0_values[6].y)).w;
                float r2_w_3 = saturate((r1_w_1 * r2_w_2));
                float r2_w_4 = (r2_w_3 * r2_w_3);
                float r2_w_5 = (r2_w_4 * mad(r2_w_3, -2, 3));
                float r1_w_2 = (r1_w_1 < 0);
                if (r1_w_2) discard;
                float4 r3_xyzw_3 = (r2_w_5.xxxx * r2_xyz_2.xyzx);
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r3_z_2 = r3_xyzw_3.z;
                float r1_w_3 = (cb4_values[0].x == 1);
                float r4_x_10;
                float r4_y_10;
                float r4_z_10;
                float r4_w_4;
                if (r1_w_3)
                {
                    float r1_w_4 = (cb4_values[0].y == 1);
                    float3 r4_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord2.zzzz, (mad(cb4_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r4_xyzw_8 = (((((r1_w_4.xxxx ? r4_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r4_y_8 = r4_xyzw_8.y;
                    float r4_z_8 = r4_xyzw_8.z;
                    float r4_w_2 = r4_xyzw_8.w;
                    float r1_w_5 = mad(r4_y_8, 0.25, 0.75);
                    float r3_w_2 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r4_x_8 = max(r1_w_5, r3_w_2);
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
                float r1_w_7 = saturate(dot(float4(r4_x_10, r4_y_10, r4_z_10, r4_w_4), unity_OcclusionMaskSelector));
                float3 r4_xyz_11 = ((r1_w_7.xxxx * _LightColor0.xyzx)).xyz;
                float3 unitClipPos_xyz_1 = normalize(i.texcoord1);
                float3 r2_xyz_4 = (mad(cb0_values[6].zzzz, (mad(r2_xyz_2.xyzx, r2_w_5.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_10 = mad(-cb0_values[6].z, 0.96, 0.96);
                float4 r3_xyzw_4 = (r1_w_10.xxxx * float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r3_z_3 = r3_xyzw_4.z;
                float r1_w_11 = (-cb0_values[6].w + 1);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitClipPos_xyz_1.xyzx, unitViewDir_xyz_1.xyzx);
                float r1_x_2 = saturate(dot(unitClipPos_xyz_1.xyzx, _WorldSpaceLightPos0.xyzx));
                float r1_y_2 = saturate(dot(unitClipPos_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_11.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(nDotV_w_6) + 1);
                float r2_w_6 = (r1_z_4 * r1_z_4);
                float r2_w_7 = (r2_w_6 * r2_w_6);
                float r1_z_5 = (r1_z_4 * r2_w_7);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_11 * r1_w_11);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_z_6 = (-r0_z_8 + 1);
                float r1_w_12 = mad(abs(nDotV_w_6), r1_z_6, r0_z_8);
                float r1_z_7 = mad(r1_x_2, r1_z_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * r1_z_7);
                float r0_w_8 = mad(r1_x_2, r1_w_12, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_z_8 = mad(r1_y_2, r0_z_9, -r1_y_2);
                float r1_y_3 = mad(r1_z_8, r1_y_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r0_z_11 = (r0_z_10 / r1_y_4);
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_3 = (r0_y_9.xxxx * r4_xyz_11.xyzx);
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_5 = r1_xyzw_3.y;
                float r1_z_9 = r1_xyzw_3.z;
                float4 r0_xyzw_10 = (r4_xyz_11.xxyz * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_13 = (r0_x_5 * r0_x_5);
                float r1_w_14 = (r1_w_13 * r1_w_13);
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * (mad(((-r2_xyz_4.xyzx + float4(1, 1, 1, 0))).xyzx, ((r0_x_5 * r1_w_14)).xxxx, r2_xyz_4.xyzx)).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float r0_w_15 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w));
                o.sv_Target0.xyz = ((float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8) * r0_w_19.xxxx)).xyz;
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
                float4 cb0_values[13];
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
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            Texture2D t2;
            Texture3D t3;
            struct program56Input
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
            struct program56Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program102Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program102Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program56Output vert(program56Input i)
            {
                program56Output o = (program56Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord5.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[12].xxxy, cb0_values[12].zzzw)).zw;
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_4 = ((worldPos_xyzw_4.yyyy * _EdgeColor.xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(cb0_values[6].xyzx, worldPos_xyzw_4.zzzz, (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_4.xyzx)).xyzx)).xyz;
                o.texcoord3.xyz = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program102Output frag(program102Input i)
            {
                program102Output o = (program102Output)0;
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
                float r1_w_5 = (cb4_values[0].x == 1);
                float r6_x_10;
                float r6_y_10;
                float r6_z_10;
                float r6_w_4;
                if (r1_w_5)
                {
                    float r1_w_6 = (cb4_values[0].y == 1);
                    float3 r6_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord2.zzzz, (mad(cb4_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r6_xyzw_8 = (((((r1_w_6.xxxx ? r6_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r6_y_8 = r6_xyzw_8.y;
                    float r6_z_8 = r6_xyzw_8.z;
                    float r6_w_2 = r6_xyzw_8.w;
                    float r1_w_7 = mad(r6_y_8, 0.25, 0.75);
                    float r3_w_3 = mad(cb4_values[0].z, 0.5, 0.75);
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
                float3 unitClipPos_xyz_11 = normalize(i.texcoord1);
                float3 r3_xyz_4 = (mad(cb0_values[10].zzzz, (mad(r3_xyz_2.xyzx, r2_w_4.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_13 = mad(-cb0_values[10].z, 0.96, 0.96);
                float r1_w_14 = (-cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_2.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitClipPos_xyz_11.xyzx, unitViewDir_xyz_2.xyzx);
                float r2_x_3 = saturate(dot(unitClipPos_xyz_11.xyzx, r1_xyz_1.xyzx));
                float r2_y_3 = saturate(dot(unitClipPos_xyz_11.xyzx, r0_xyz_3.xyzx));
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
                float4 r0_xyzw_8 = mad(((r1_w_13.xxxx * ((r2_w_4.xxxx * r3_xyz_2.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_19 = r0_xyzw_8.z;
                float r0_w_15 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w));
                o.sv_Target0.xyz = ((float4(r0_x_8, r0_y_12, r0_z_19, r0_x_8) * r0_w_19.xxxx)).xyz;
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
                float4 cb0_values[13];
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
                float4 cb2_values[3];
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
            SamplerComparisonState sampler_comparison_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_linear_clamp3;
            SamplerState sampler_MainTex;
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            Texture2D t2;
            TextureCube t3;
            Texture3D t4;
            TextureCube t5;
            struct program55Input
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
            struct program55Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program101Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program101Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program55Output vert(program55Input i)
            {
                program55Output o = (program55Output)0;
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
            program101Output frag(program101Input i)
            {
                program101Output o = (program101Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_2 = ((r4_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float4 r5_xyzw_1 = _DissolveMap.Sample(sampler_DissolveMap, (i.texcoord0.zwzz).xy);
                float r1_w_3 = (r5_xyzw_1.x + -cb0_values[10].x);
                float r2_w_1 = ((float4(1, 1, 1, 1) / cb0_values[10].y)).w;
                float r2_w_2 = saturate((r1_w_3 * r2_w_1));
                float r3_w_1 = mad(r2_w_2, -2, 3);
                float r2_w_3 = (r2_w_2 * r2_w_2);
                float r2_w_4 = (r2_w_3 * r3_w_1);
                float r1_w_4 = (r1_w_3 < 0);
                if (r1_w_4) discard;
                float3 r6_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r7_x_1 = cb4_values[9].z;
                float r7_y_1 = cb4_values[10].z;
                float r7_z_1 = cb4_values[11].z;
                float r1_w_5 = dot(viewDir_xyz_1.xyzx, float4(r7_x_1, r7_y_1, r7_z_1, r7_x_1));
                float3 r2_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_6 = mad(cb3_values[25].w, (-r1_w_5 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_5);
                float r1_w_7 = saturate(mad(r1_w_6, cb3_values[24].z, cb3_values[24].w));
                float r7_x_9;
                float r7_y_9;
                float r7_z_9;
                float r7_w_4;
                if (((cb5_values[0].x == 1)).x)
                {
                    float3 r7_xyz_6 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (((cb5_values[0].y == 1)).xxxx ? r7_xyz_6.xyzx : i.texcoord2.xyzx);
                    float r2_x_8 = r2_xyzw_8.x;
                    float r2_y_3 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float4 r2_xyzw_9 = (float4(r2_x_8, r2_y_3, r2_z_3, r2_x_8) + -cb5_values[6].xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_4 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float4 r7_xyzw_7 = (float4(r2_x_9, r2_x_9, r2_y_4, r2_z_4) * cb5_values[5].xxyz);
                    float r7_y_7 = r7_xyzw_7.y;
                    float r7_z_7 = r7_xyzw_7.z;
                    float r7_w_2 = r7_xyzw_7.w;
                    float r2_y_5 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r7_x_7 = max(r2_y_5, mad(r7_y_7, 0.25, 0.75));
                    float4 r7_xyzw_8 = t4.Sample(sampler_linear_clamp, (float4(r7_x_7, r7_z_7, r7_w_2, r7_x_7)).xyz);
                    r7_x_9 = r7_xyzw_8.x;
                    r7_y_9 = r7_xyzw_8.y;
                    r7_z_9 = r7_xyzw_8.z;
                    r7_w_4 = r7_xyzw_8.w;
                }
                else
                {
                    float4 r7_xyzw_2 = float4(1, 1, 1, 1);
                    r7_x_9 = r7_xyzw_2.x;
                    r7_y_9 = r7_xyzw_2.y;
                    r7_z_9 = r7_xyzw_2.z;
                    r7_w_4 = r7_xyzw_2.w;
                }
                float r2_y_7 = (r1_w_7 < 0.99);
                float r2_y_19;
                if (r2_y_7)
                {
                    float3 r7_xyz_10 = ((i.texcoord2.xyzx + -cb2_values[1].xyzx)).xyz;
                    float r2_y_9 = max(abs(r7_xyz_10.y), abs(r7_xyz_10.x));
                    float r2_y_10 = max(abs(r7_xyz_10.z), r2_y_9);
                    float r2_y_11 = (r2_y_10 + -cb2_values[2].z);
                    float r2_y_12 = max(r2_y_11, 1E-05);
                    float r2_y_13 = (r2_y_12 * cb2_values[2].w);
                    float r2_y_14 = (cb2_values[2].y / r2_y_13);
                    float r2_y_15 = (r2_y_14 + -cb2_values[2].x);
                    float r2_y_16 = (-r2_y_15 + 1);
                    float r8_x_2 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r7_xyz_10.xyzx + float4(0.0078125, 0.0078125, 0.0078125, 0))).xyzx).xyz, r2_y_16);
                    float r8_y_2 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r7_xyz_10.xyzx + float4(-0.0078125, -0.0078125, 0.0078125, 0))).xyzx).xyz, r2_y_16);
                    float r8_z_2 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r7_xyz_10.xyzx + float4(-0.0078125, 0.0078125, -0.0078125, 0))).xyzx).xyz, r2_y_16);
                    float r8_w_1 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r7_xyz_10.xyzx + float4(0.0078125, -0.0078125, -0.0078125, 0))).xyzx).xyz, r2_y_16);
                    float r2_y_17 = dot(float4(r8_x_2, r8_y_2, r8_z_2, r8_w_1), float4(0.25, 0.25, 0.25, 0.25));
                    float r2_z_6 = (-cb3_values[24].x + 1);
                    float r2_y_18 = mad(r2_y_17, r2_z_6, cb3_values[24].x);
                    r2_y_19 = r2_y_18;
                }
                else
                {
                    float r2_y_8 = 1;
                    r2_y_19 = r2_y_8;
                }
                float r1_w_8 = mad(r1_w_7, (-r2_y_19 + saturate(dot(float4(r7_x_9, r7_y_9, r7_z_9, r7_w_4), unity_OcclusionMaskSelector))), r2_y_19);
                float4 r7_xyzw_13 = t2.Sample(sampler_linear_clamp3, ((dot(r6_xyz_4.xyzx, r6_xyz_4.xyzx)).xxxx).xy);
                float4 r6_xyzw_5 = t3.Sample(sampler_linear_clamp2, r6_xyz_4.xyz);
                float r1_w_9 = (r1_w_8 * (r6_xyzw_5.w * r7_xyzw_13.x));
                float4 r2_xyzw_16 = (r1_w_9.xxxx * _LightColor0.xyzx);
                float r2_x_16 = r2_xyzw_16.x;
                float r2_y_20 = r2_xyzw_16.y;
                float r2_z_8 = r2_xyzw_16.z;
                float3 unitWorldNormal_xyz_6 = normalize(i.texcoord1);
                float3 r4_xyz_4 = (mad(cb0_values[10].zzzz, (mad(r4_xyz_2.xyzx, r2_w_4.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_12 = mad(-cb0_values[10].z, 0.96, 0.96);
                float r1_w_13 = (-cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitWorldNormal_xyz_6.xyzx, unitViewDir_xyz_1.xyzx);
                float r2_w_5 = saturate(dot(unitWorldNormal_xyz_6.xyzx, r1_xyz_1.xyzx));
                float r3_x_2 = saturate(dot(unitWorldNormal_xyz_6.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_13.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_5 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(nDotV_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_13 * r1_w_13);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(nDotV_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * mad(r2_w_5, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_5, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r3_x_2, r0_z_9, -r3_x_2), r3_x_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_w_5.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r2_x_16, r2_y_20, r2_z_8, r2_x_16));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r2_x_16, r2_x_16, r2_y_20, r2_z_8) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_14 = (r0_x_5 * r0_x_5);
                float r1_w_15 = (r1_w_14 * r1_w_14);
                float4 r2_xyzw_17 = (-r4_xyz_4.xyzx + float4(1, 1, 1, 0));
                float r2_x_17 = r2_xyzw_17.x;
                float r2_y_21 = r2_xyzw_17.y;
                float r2_z_9 = r2_xyzw_17.z;
                float4 r2_xyzw_18 = mad(float4(r2_x_17, r2_y_21, r2_z_9, r2_x_17), ((r0_x_5 * r1_w_15)).xxxx, r4_xyz_4.xyzx);
                float r2_x_18 = r2_xyzw_18.x;
                float r2_y_22 = r2_xyzw_18.y;
                float r2_z_10 = r2_xyzw_18.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_18, r2_y_22, r2_z_10, r2_x_18));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(((r1_w_12.xxxx * ((r2_w_4.xxxx * r4_xyz_2.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7))).xyz;
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
                float4 cb0_values[13];
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
                float4 cb2_values[3];
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
            SamplerComparisonState sampler_comparison_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_linear_clamp3;
            SamplerState sampler_MainTex;
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            Texture2D t2;
            TextureCube t3;
            Texture3D t4;
            TextureCube t5;
            struct program54Input
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
            struct program54Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program100Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program100Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program54Output vert(program54Input i)
            {
                program54Output o = (program54Output)0;
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
            program100Output frag(program100Input i)
            {
                program100Output o = (program100Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_2 = ((r4_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float4 r5_xyzw_1 = _DissolveMap.Sample(sampler_DissolveMap, (i.texcoord0.zwzz).xy);
                float r1_w_3 = (r5_xyzw_1.x + -cb0_values[10].x);
                float r2_w_1 = ((float4(1, 1, 1, 1) / cb0_values[10].y)).w;
                float r2_w_2 = saturate((r1_w_3 * r2_w_1));
                float r3_w_1 = mad(r2_w_2, -2, 3);
                float r2_w_3 = (r2_w_2 * r2_w_2);
                float r2_w_4 = (r2_w_3 * r3_w_1);
                float r1_w_4 = (r1_w_3 < 0);
                if (r1_w_4) discard;
                float3 r6_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r7_x_1 = cb4_values[9].z;
                float r7_y_1 = cb4_values[10].z;
                float r7_z_1 = cb4_values[11].z;
                float r1_w_5 = dot(viewDir_xyz_1.xyzx, float4(r7_x_1, r7_y_1, r7_z_1, r7_x_1));
                float3 r2_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_6 = mad(cb3_values[25].w, (-r1_w_5 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_5);
                float r1_w_7 = saturate(mad(r1_w_6, cb3_values[24].z, cb3_values[24].w));
                float r7_x_9;
                float r7_y_9;
                float r7_z_9;
                float r7_w_4;
                if (((cb5_values[0].x == 1)).x)
                {
                    float3 r7_xyz_6 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (((cb5_values[0].y == 1)).xxxx ? r7_xyz_6.xyzx : i.texcoord2.xyzx);
                    float r2_x_8 = r2_xyzw_8.x;
                    float r2_y_3 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float4 r2_xyzw_9 = (float4(r2_x_8, r2_y_3, r2_z_3, r2_x_8) + -cb5_values[6].xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_4 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float4 r7_xyzw_7 = (float4(r2_x_9, r2_x_9, r2_y_4, r2_z_4) * cb5_values[5].xxyz);
                    float r7_y_7 = r7_xyzw_7.y;
                    float r7_z_7 = r7_xyzw_7.z;
                    float r7_w_2 = r7_xyzw_7.w;
                    float r2_y_5 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r7_x_7 = max(r2_y_5, mad(r7_y_7, 0.25, 0.75));
                    float4 r7_xyzw_8 = t4.Sample(sampler_linear_clamp, (float4(r7_x_7, r7_z_7, r7_w_2, r7_x_7)).xyz);
                    r7_x_9 = r7_xyzw_8.x;
                    r7_y_9 = r7_xyzw_8.y;
                    r7_z_9 = r7_xyzw_8.z;
                    r7_w_4 = r7_xyzw_8.w;
                }
                else
                {
                    float4 r7_xyzw_2 = float4(1, 1, 1, 1);
                    r7_x_9 = r7_xyzw_2.x;
                    r7_y_9 = r7_xyzw_2.y;
                    r7_z_9 = r7_xyzw_2.z;
                    r7_w_4 = r7_xyzw_2.w;
                }
                float3 r7_xyz_10 = ((i.texcoord2.xyzx + -cb2_values[1].xyzx)).xyz;
                float r2_y_7 = max(abs(r7_xyz_10.y), abs(r7_xyz_10.x));
                float r2_y_8 = max(abs(r7_xyz_10.z), r2_y_7);
                float r2_y_9 = (r2_y_8 + -cb2_values[2].z);
                float r2_y_10 = max(r2_y_9, 1E-05);
                float r2_y_11 = (r2_y_10 * cb2_values[2].w);
                float r2_y_12 = (cb2_values[2].y / r2_y_11);
                float r2_y_13 = (r2_y_12 + -cb2_values[2].x);
                float r2_y_14 = (-r2_y_13 + 1);
                float r2_y_15 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, r7_xyz_10.xyz, r2_y_14);
                float r2_z_6 = (-cb3_values[24].x + 1);
                float r2_y_16 = mad(r2_y_15, r2_z_6, cb3_values[24].x);
                float r1_w_8 = mad(r1_w_7, (-r2_y_16 + saturate(dot(float4(r7_x_9, r7_y_9, r7_z_9, r7_w_4), unity_OcclusionMaskSelector))), r2_y_16);
                float4 r7_xyzw_11 = t2.Sample(sampler_linear_clamp3, ((dot(r6_xyz_4.xyzx, r6_xyz_4.xyzx)).xxxx).xy);
                float4 r6_xyzw_5 = t3.Sample(sampler_linear_clamp2, r6_xyz_4.xyz);
                float r1_w_9 = (r1_w_8 * (r6_xyzw_5.w * r7_xyzw_11.x));
                float4 r2_xyzw_16 = (r1_w_9.xxxx * _LightColor0.xyzx);
                float r2_x_16 = r2_xyzw_16.x;
                float r2_y_17 = r2_xyzw_16.y;
                float r2_z_7 = r2_xyzw_16.z;
                float3 unitWorldNormal_xyz_6 = normalize(i.texcoord1);
                float3 r4_xyz_4 = (mad(cb0_values[10].zzzz, (mad(r4_xyz_2.xyzx, r2_w_4.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_12 = mad(-cb0_values[10].z, 0.96, 0.96);
                float r1_w_13 = (-cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitWorldNormal_xyz_6.xyzx, unitViewDir_xyz_1.xyzx);
                float r2_w_5 = saturate(dot(unitWorldNormal_xyz_6.xyzx, r1_xyz_1.xyzx));
                float r3_x_2 = saturate(dot(unitWorldNormal_xyz_6.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_13.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_5 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(nDotV_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_13 * r1_w_13);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(nDotV_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * mad(r2_w_5, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_5, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r3_x_2, r0_z_9, -r3_x_2), r3_x_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_w_5.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r2_x_16, r2_y_17, r2_z_7, r2_x_16));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r2_x_16, r2_x_16, r2_y_17, r2_z_7) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_14 = (r0_x_5 * r0_x_5);
                float r1_w_15 = (r1_w_14 * r1_w_14);
                float4 r2_xyzw_17 = (-r4_xyz_4.xyzx + float4(1, 1, 1, 0));
                float r2_x_17 = r2_xyzw_17.x;
                float r2_y_18 = r2_xyzw_17.y;
                float r2_z_8 = r2_xyzw_17.z;
                float4 r2_xyzw_18 = mad(float4(r2_x_17, r2_y_18, r2_z_8, r2_x_17), ((r0_x_5 * r1_w_15)).xxxx, r4_xyz_4.xyzx);
                float r2_x_18 = r2_xyzw_18.x;
                float r2_y_19 = r2_xyzw_18.y;
                float r2_z_9 = r2_xyzw_18.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_18, r2_y_19, r2_z_9, r2_x_18));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(((r1_w_12.xxxx * ((r2_w_4.xxxx * r4_xyz_2.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7))).xyz;
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
                float4 cb0_values[13];
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
                float4 cb2_values[3];
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
            SamplerComparisonState sampler_comparison_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            Texture2D t2;
            Texture3D t3;
            TextureCube t4;
            struct program53Input
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
            struct program53Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program99Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program99Output
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
            program99Output frag(program99Input i)
            {
                program99Output o = (program99Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_2 = ((r4_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float4 r5_xyzw_1 = _DissolveMap.Sample(sampler_DissolveMap, (i.texcoord0.zwzz).xy);
                float r1_w_3 = (r5_xyzw_1.x + -cb0_values[10].x);
                float r2_w_1 = ((float4(1, 1, 1, 1) / cb0_values[10].y)).w;
                float r2_w_2 = saturate((r1_w_3 * r2_w_1));
                float r3_w_1 = mad(r2_w_2, -2, 3);
                float r2_w_3 = (r2_w_2 * r2_w_2);
                float r2_w_4 = (r2_w_3 * r3_w_1);
                float r1_w_4 = (r1_w_3 < 0);
                if (r1_w_4) discard;
                float3 r6_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r7_x_1 = cb4_values[9].z;
                float r7_y_1 = cb4_values[10].z;
                float r7_z_1 = cb4_values[11].z;
                float r1_w_5 = dot(viewDir_xyz_1.xyzx, float4(r7_x_1, r7_y_1, r7_z_1, r7_x_1));
                float3 r2_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_6 = mad(cb3_values[25].w, (-r1_w_5 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_5);
                float r1_w_7 = saturate(mad(r1_w_6, cb3_values[24].z, cb3_values[24].w));
                float r7_x_9;
                float r7_y_9;
                float r7_z_9;
                float r7_w_4;
                if (((cb5_values[0].x == 1)).x)
                {
                    float3 r7_xyz_6 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (((cb5_values[0].y == 1)).xxxx ? r7_xyz_6.xyzx : i.texcoord2.xyzx);
                    float r2_x_8 = r2_xyzw_8.x;
                    float r2_y_3 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float4 r2_xyzw_9 = (float4(r2_x_8, r2_y_3, r2_z_3, r2_x_8) + -cb5_values[6].xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_4 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float4 r7_xyzw_7 = (float4(r2_x_9, r2_x_9, r2_y_4, r2_z_4) * cb5_values[5].xxyz);
                    float r7_y_7 = r7_xyzw_7.y;
                    float r7_z_7 = r7_xyzw_7.z;
                    float r7_w_2 = r7_xyzw_7.w;
                    float r2_y_5 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r7_x_7 = max(r2_y_5, mad(r7_y_7, 0.25, 0.75));
                    float4 r7_xyzw_8 = t3.Sample(sampler_linear_clamp, (float4(r7_x_7, r7_z_7, r7_w_2, r7_x_7)).xyz);
                    r7_x_9 = r7_xyzw_8.x;
                    r7_y_9 = r7_xyzw_8.y;
                    r7_z_9 = r7_xyzw_8.z;
                    r7_w_4 = r7_xyzw_8.w;
                }
                else
                {
                    float4 r7_xyzw_2 = float4(1, 1, 1, 1);
                    r7_x_9 = r7_xyzw_2.x;
                    r7_y_9 = r7_xyzw_2.y;
                    r7_z_9 = r7_xyzw_2.z;
                    r7_w_4 = r7_xyzw_2.w;
                }
                float r2_y_7 = (r1_w_7 < 0.99);
                float r2_y_19;
                if (r2_y_7)
                {
                    float3 r7_xyz_10 = ((i.texcoord2.xyzx + -cb2_values[1].xyzx)).xyz;
                    float r2_y_9 = max(abs(r7_xyz_10.y), abs(r7_xyz_10.x));
                    float r2_y_10 = max(abs(r7_xyz_10.z), r2_y_9);
                    float r2_y_11 = (r2_y_10 + -cb2_values[2].z);
                    float r2_y_12 = max(r2_y_11, 1E-05);
                    float r2_y_13 = (r2_y_12 * cb2_values[2].w);
                    float r2_y_14 = (cb2_values[2].y / r2_y_13);
                    float r2_y_15 = (r2_y_14 + -cb2_values[2].x);
                    float r2_y_16 = (-r2_y_15 + 1);
                    float r8_x_2 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r7_xyz_10.xyzx + float4(0.0078125, 0.0078125, 0.0078125, 0))).xyzx).xyz, r2_y_16);
                    float r8_y_2 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r7_xyz_10.xyzx + float4(-0.0078125, -0.0078125, 0.0078125, 0))).xyzx).xyz, r2_y_16);
                    float r8_z_2 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r7_xyz_10.xyzx + float4(-0.0078125, 0.0078125, -0.0078125, 0))).xyzx).xyz, r2_y_16);
                    float r8_w_1 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r7_xyz_10.xyzx + float4(0.0078125, -0.0078125, -0.0078125, 0))).xyzx).xyz, r2_y_16);
                    float r2_y_17 = dot(float4(r8_x_2, r8_y_2, r8_z_2, r8_w_1), float4(0.25, 0.25, 0.25, 0.25));
                    float r2_z_6 = (-cb3_values[24].x + 1);
                    float r2_y_18 = mad(r2_y_17, r2_z_6, cb3_values[24].x);
                    r2_y_19 = r2_y_18;
                }
                else
                {
                    float r2_y_8 = 1;
                    r2_y_19 = r2_y_8;
                }
                float r1_w_8 = mad(r1_w_7, (-r2_y_19 + saturate(dot(float4(r7_x_9, r7_y_9, r7_z_9, r7_w_4), unity_OcclusionMaskSelector))), r2_y_19);
                float4 r6_xyzw_5 = t2.Sample(sampler_linear_clamp2, ((dot(r6_xyz_4.xyzx, r6_xyz_4.xyzx)).xxxx).xy);
                float r1_w_9 = (r1_w_8 * r6_xyzw_5.x);
                float4 r2_xyzw_15 = (r1_w_9.xxxx * _LightColor0.xyzx);
                float r2_x_15 = r2_xyzw_15.x;
                float r2_y_20 = r2_xyzw_15.y;
                float r2_z_8 = r2_xyzw_15.z;
                float3 unitWorldNormal_xyz_6 = normalize(i.texcoord1);
                float3 r4_xyz_4 = (mad(cb0_values[10].zzzz, (mad(r4_xyz_2.xyzx, r2_w_4.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_12 = mad(-cb0_values[10].z, 0.96, 0.96);
                float r1_w_13 = (-cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitWorldNormal_xyz_6.xyzx, unitViewDir_xyz_1.xyzx);
                float r2_w_5 = saturate(dot(unitWorldNormal_xyz_6.xyzx, r1_xyz_1.xyzx));
                float r3_x_2 = saturate(dot(unitWorldNormal_xyz_6.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_13.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_5 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(nDotV_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_13 * r1_w_13);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(nDotV_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * mad(r2_w_5, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_5, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r3_x_2, r0_z_9, -r3_x_2), r3_x_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_w_5.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r2_x_15, r2_y_20, r2_z_8, r2_x_15));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r2_x_15, r2_x_15, r2_y_20, r2_z_8) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_14 = (r0_x_5 * r0_x_5);
                float r1_w_15 = (r1_w_14 * r1_w_14);
                float4 r2_xyzw_16 = (-r4_xyz_4.xyzx + float4(1, 1, 1, 0));
                float r2_x_16 = r2_xyzw_16.x;
                float r2_y_21 = r2_xyzw_16.y;
                float r2_z_9 = r2_xyzw_16.z;
                float4 r2_xyzw_17 = mad(float4(r2_x_16, r2_y_21, r2_z_9, r2_x_16), ((r0_x_5 * r1_w_15)).xxxx, r4_xyz_4.xyzx);
                float r2_x_17 = r2_xyzw_17.x;
                float r2_y_22 = r2_xyzw_17.y;
                float r2_z_10 = r2_xyzw_17.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_17, r2_y_22, r2_z_10, r2_x_17));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(((r1_w_12.xxxx * ((r2_w_4.xxxx * r4_xyz_2.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7))).xyz;
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
                float4 cb0_values[13];
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
                float4 cb2_values[3];
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
            SamplerComparisonState sampler_comparison_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            Texture2D t2;
            Texture3D t3;
            TextureCube t4;
            struct program52Input
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
            struct program52Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program98Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program98Output
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
            program98Output frag(program98Input i)
            {
                program98Output o = (program98Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_2 = ((r4_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float4 r5_xyzw_1 = _DissolveMap.Sample(sampler_DissolveMap, (i.texcoord0.zwzz).xy);
                float r1_w_3 = (r5_xyzw_1.x + -cb0_values[10].x);
                float r2_w_1 = ((float4(1, 1, 1, 1) / cb0_values[10].y)).w;
                float r2_w_2 = saturate((r1_w_3 * r2_w_1));
                float r3_w_1 = mad(r2_w_2, -2, 3);
                float r2_w_3 = (r2_w_2 * r2_w_2);
                float r2_w_4 = (r2_w_3 * r3_w_1);
                float r1_w_4 = (r1_w_3 < 0);
                if (r1_w_4) discard;
                float3 r6_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r7_x_1 = cb4_values[9].z;
                float r7_y_1 = cb4_values[10].z;
                float r7_z_1 = cb4_values[11].z;
                float r1_w_5 = dot(viewDir_xyz_1.xyzx, float4(r7_x_1, r7_y_1, r7_z_1, r7_x_1));
                float3 r2_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_6 = mad(cb3_values[25].w, (-r1_w_5 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_5);
                float r1_w_7 = saturate(mad(r1_w_6, cb3_values[24].z, cb3_values[24].w));
                float r7_x_9;
                float r7_y_9;
                float r7_z_9;
                float r7_w_4;
                if (((cb5_values[0].x == 1)).x)
                {
                    float3 r7_xyz_6 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (((cb5_values[0].y == 1)).xxxx ? r7_xyz_6.xyzx : i.texcoord2.xyzx);
                    float r2_x_8 = r2_xyzw_8.x;
                    float r2_y_3 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float4 r2_xyzw_9 = (float4(r2_x_8, r2_y_3, r2_z_3, r2_x_8) + -cb5_values[6].xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_4 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float4 r7_xyzw_7 = (float4(r2_x_9, r2_x_9, r2_y_4, r2_z_4) * cb5_values[5].xxyz);
                    float r7_y_7 = r7_xyzw_7.y;
                    float r7_z_7 = r7_xyzw_7.z;
                    float r7_w_2 = r7_xyzw_7.w;
                    float r2_y_5 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r7_x_7 = max(r2_y_5, mad(r7_y_7, 0.25, 0.75));
                    float4 r7_xyzw_8 = t3.Sample(sampler_linear_clamp, (float4(r7_x_7, r7_z_7, r7_w_2, r7_x_7)).xyz);
                    r7_x_9 = r7_xyzw_8.x;
                    r7_y_9 = r7_xyzw_8.y;
                    r7_z_9 = r7_xyzw_8.z;
                    r7_w_4 = r7_xyzw_8.w;
                }
                else
                {
                    float4 r7_xyzw_2 = float4(1, 1, 1, 1);
                    r7_x_9 = r7_xyzw_2.x;
                    r7_y_9 = r7_xyzw_2.y;
                    r7_z_9 = r7_xyzw_2.z;
                    r7_w_4 = r7_xyzw_2.w;
                }
                float3 r7_xyz_10 = ((i.texcoord2.xyzx + -cb2_values[1].xyzx)).xyz;
                float r2_y_7 = max(abs(r7_xyz_10.y), abs(r7_xyz_10.x));
                float r2_y_8 = max(abs(r7_xyz_10.z), r2_y_7);
                float r2_y_9 = (r2_y_8 + -cb2_values[2].z);
                float r2_y_10 = max(r2_y_9, 1E-05);
                float r2_y_11 = (r2_y_10 * cb2_values[2].w);
                float r2_y_12 = (cb2_values[2].y / r2_y_11);
                float r2_y_13 = (r2_y_12 + -cb2_values[2].x);
                float r2_y_14 = (-r2_y_13 + 1);
                float r2_y_15 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, r7_xyz_10.xyz, r2_y_14);
                float r2_z_6 = (-cb3_values[24].x + 1);
                float r2_y_16 = mad(r2_y_15, r2_z_6, cb3_values[24].x);
                float r1_w_8 = mad(r1_w_7, (-r2_y_16 + saturate(dot(float4(r7_x_9, r7_y_9, r7_z_9, r7_w_4), unity_OcclusionMaskSelector))), r2_y_16);
                float4 r6_xyzw_5 = t2.Sample(sampler_linear_clamp2, ((dot(r6_xyz_4.xyzx, r6_xyz_4.xyzx)).xxxx).xy);
                float r1_w_9 = (r1_w_8 * r6_xyzw_5.x);
                float4 r2_xyzw_15 = (r1_w_9.xxxx * _LightColor0.xyzx);
                float r2_x_15 = r2_xyzw_15.x;
                float r2_y_17 = r2_xyzw_15.y;
                float r2_z_7 = r2_xyzw_15.z;
                float3 unitWorldNormal_xyz_6 = normalize(i.texcoord1);
                float3 r4_xyz_4 = (mad(cb0_values[10].zzzz, (mad(r4_xyz_2.xyzx, r2_w_4.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_12 = mad(-cb0_values[10].z, 0.96, 0.96);
                float r1_w_13 = (-cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitWorldNormal_xyz_6.xyzx, unitViewDir_xyz_1.xyzx);
                float r2_w_5 = saturate(dot(unitWorldNormal_xyz_6.xyzx, r1_xyz_1.xyzx));
                float r3_x_2 = saturate(dot(unitWorldNormal_xyz_6.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_13.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_5 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(nDotV_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_13 * r1_w_13);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(nDotV_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * mad(r2_w_5, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_5, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r3_x_2, r0_z_9, -r3_x_2), r3_x_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_w_5.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r2_x_15, r2_y_17, r2_z_7, r2_x_15));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r2_x_15, r2_x_15, r2_y_17, r2_z_7) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_14 = (r0_x_5 * r0_x_5);
                float r1_w_15 = (r1_w_14 * r1_w_14);
                float4 r2_xyzw_16 = (-r4_xyz_4.xyzx + float4(1, 1, 1, 0));
                float r2_x_16 = r2_xyzw_16.x;
                float r2_y_18 = r2_xyzw_16.y;
                float r2_z_8 = r2_xyzw_16.z;
                float4 r2_xyzw_17 = mad(float4(r2_x_16, r2_y_18, r2_z_8, r2_x_16), ((r0_x_5 * r1_w_15)).xxxx, r4_xyz_4.xyzx);
                float r2_x_17 = r2_xyzw_17.x;
                float r2_y_19 = r2_xyzw_17.y;
                float r2_z_9 = r2_xyzw_17.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_17, r2_y_19, r2_z_9, r2_x_17));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(((r1_w_12.xxxx * ((r2_w_4.xxxx * r4_xyz_2.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7))).xyz;
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
                float4 cb0_values[13];
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
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            Texture2D t2;
            Texture2D t3;
            Texture3D t4;
            struct program51Input
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
            struct program51Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program97Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program97Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program51Output vert(program51Input i)
            {
                program51Output o = (program51Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[12].xxxy, cb0_values[12].zzzw)).zw;
                float worldNormal_x_4 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r2_w_4 = dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4));
                float r2_w_5 = rsqrt(r2_w_4);
                o.texcoord1.xyz = ((r2_w_5.xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4))).xyz;
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord3.xy = (mad(_MainTex_ST.xyxx, r0_xyzw_4.wwww, (mad(cb0_values[6].xyxx, r0_xyzw_4.zzzz, (mad(_Color.xyxx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * _EdgeColor.xyxx)).xyxx)).xyxx)).xyxx)).xy;
                float r0_w_5 = ((clipPos_xyzw_2.y * unity_WorldToObject[1].x) * 0.5);
                float4 r0_xyzw_8 = (clipPos_xyzw_2.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_z_5 = r0_xyzw_8.z;
                o.texcoord4.zw = (clipPos_xyzw_2.zzzw).zw;
                o.texcoord4.xy = ((r0_z_5.xxxx + float4(r0_x_8, r0_w_5, r0_x_8, r0_x_8))).xy;
                return o;
            }
            #pragma fragment frag
            program97Output frag(program97Input i)
            {
                program97Output o = (program97Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_2 = ((r2_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float4 r3_xyzw_1 = _DissolveMap.Sample(sampler_DissolveMap, (i.texcoord0.zwzz).xy);
                float r1_w_1 = (r3_xyzw_1.x + -cb0_values[10].x);
                float r2_w_2 = ((float4(1, 1, 1, 1) / cb0_values[10].y)).w;
                float r2_w_3 = saturate((r1_w_1 * r2_w_2));
                float r2_w_4 = (r2_w_3 * r2_w_3);
                float r2_w_5 = (r2_w_4 * mad(r2_w_3, -2, 3));
                float r1_w_2 = (r1_w_1 < 0);
                if (r1_w_2) discard;
                float4 r3_xyzw_3 = (r2_w_5.xxxx * r2_xyz_2.xyzx);
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r3_z_2 = r3_xyzw_3.z;
                float r5_x_1 = cb4_values[9].z;
                float r5_y_1 = cb4_values[10].z;
                float r5_z_1 = cb4_values[11].z;
                float r1_w_3 = dot(viewDir_xyz_1.xyzx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1));
                float3 r5_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r3_w_2 = dot(r5_xyz_2.xyzx, r5_xyz_2.xyzx);
                float r3_w_3 = sqrt(r3_w_2);
                float r3_w_4 = (-r1_w_3 + r3_w_3);
                float r1_w_4 = mad(cb3_values[25].w, r3_w_4, r1_w_3);
                float r1_w_5 = saturate(mad(r1_w_4, cb3_values[24].z, cb3_values[24].w));
                float r3_w_5 = (cb5_values[0].x == 1);
                float r5_x_12;
                float r5_y_12;
                float r5_z_12;
                float r5_w_4;
                if (r3_w_5)
                {
                    float r3_w_6 = (cb5_values[0].y == 1);
                    float3 r5_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r5_xyzw_10 = (((((r3_w_6.xxxx ? r5_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r5_y_10 = r5_xyzw_10.y;
                    float r5_z_10 = r5_xyzw_10.z;
                    float r5_w_2 = r5_xyzw_10.w;
                    float r3_w_7 = mad(r5_y_10, 0.25, 0.75);
                    float r4_z_1 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r5_x_10 = max(r3_w_7, r4_z_1);
                    float4 r5_xyzw_11 = t4.Sample(sampler_linear_clamp, (float4(r5_x_10, r5_z_10, r5_w_2, r5_x_10)).xyz);
                    r5_x_12 = r5_xyzw_11.x;
                    r5_y_12 = r5_xyzw_11.y;
                    r5_z_12 = r5_xyzw_11.z;
                    r5_w_4 = r5_xyzw_11.w;
                }
                else
                {
                    float4 r5_xyzw_3 = float4(1, 1, 1, 1);
                    r5_x_12 = r5_xyzw_3.x;
                    r5_y_12 = r5_xyzw_3.y;
                    r5_z_12 = r5_xyzw_3.z;
                    r5_w_4 = r5_xyzw_3.w;
                }
                float r3_w_9 = saturate(dot(float4(r5_x_12, r5_y_12, r5_z_12, r5_w_4), unity_OcclusionMaskSelector));
                float4 r4_xyzw_3 = (i.texcoord4.xxxy / i.texcoord4.wwww);
                float r4_z_3 = r4_xyzw_3.z;
                float r4_w_1 = r4_xyzw_3.w;
                float4 r5_xyzw_13 = t2.Sample(sampler_linear_clamp1, (float4(r4_z_3, r4_w_1, r4_z_3, r4_z_3)).xy);
                float r3_w_10 = (r3_w_9 + -r5_xyzw_13.x);
                float r1_w_6 = mad(r1_w_5, r3_w_10, r5_xyzw_13.x);
                float4 r4_xyzw_5 = t3.Sample(sampler_linear_clamp2, ((((mad(cb0_values[6].xyxx, i.texcoord2.zzzz, (mad(cb0_values[4].xyxx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx).xy);
                float r1_w_7 = (r1_w_6 * r4_xyzw_5.w);
                float4 r4_xyzw_6 = (r1_w_7.xxxx * _LightColor0.xyzx);
                float r4_x_6 = r4_xyzw_6.x;
                float r4_y_6 = r4_xyzw_6.y;
                float r4_z_5 = r4_xyzw_6.z;
                float3 unitWorldNormal_xyz_14 = normalize(i.texcoord1);
                float3 r2_xyz_4 = (mad(cb0_values[10].zzzz, (mad(r2_xyz_2.xyzx, r2_w_5.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_10 = mad(-cb0_values[10].z, 0.96, 0.96);
                float4 r3_xyzw_4 = (r1_w_10.xxxx * float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r3_z_3 = r3_xyzw_4.z;
                float r1_w_11 = (-cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitWorldNormal_xyz_14.xyzx, unitViewDir_xyz_1.xyzx);
                float r1_x_2 = saturate(dot(unitWorldNormal_xyz_14.xyzx, _WorldSpaceLightPos0.xyzx));
                float r1_y_2 = saturate(dot(unitWorldNormal_xyz_14.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_11.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(nDotV_w_6) + 1);
                float r2_w_6 = (r1_z_4 * r1_z_4);
                float r2_w_7 = (r2_w_6 * r2_w_6);
                float r1_z_5 = (r1_z_4 * r2_w_7);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_11 * r1_w_11);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_z_6 = (-r0_z_8 + 1);
                float r1_w_12 = mad(abs(nDotV_w_6), r1_z_6, r0_z_8);
                float r1_z_7 = mad(r1_x_2, r1_z_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * r1_z_7);
                float r0_w_8 = mad(r1_x_2, r1_w_12, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_z_8 = mad(r1_y_2, r0_z_9, -r1_y_2);
                float r1_y_3 = mad(r1_z_8, r1_y_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r0_z_11 = (r0_z_10 / r1_y_4);
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_3 = (r0_y_9.xxxx * float4(r4_x_6, r4_y_6, r4_z_5, r4_x_6));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_5 = r1_xyzw_3.y;
                float r1_z_9 = r1_xyzw_3.z;
                float4 r0_xyzw_10 = (float4(r4_x_6, r4_x_6, r4_y_6, r4_z_5) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_13 = (r0_x_5 * r0_x_5);
                float r1_w_14 = (r1_w_13 * r1_w_13);
                float4 r4_xyzw_7 = (-r2_xyz_4.xyzx + float4(1, 1, 1, 0));
                float r4_x_7 = r4_xyzw_7.x;
                float r4_y_7 = r4_xyzw_7.y;
                float r4_z_6 = r4_xyzw_7.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * (mad(float4(r4_x_7, r4_y_7, r4_z_6, r4_x_7), ((r0_x_5 * r1_w_14)).xxxx, r2_xyz_4.xyzx)).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7))).xyz;
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
                float4 cb0_values[7];
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
            SamplerState sampler_MainTex;
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            Texture2D t2;
            Texture3D t3;
            struct program50Input
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
            struct program50Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program96Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program96Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program50Output vert(program50Input i)
            {
                program50Output o = (program50Output)0;
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
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _MainTex_ST.xxxy, _MainTex_ST.zzzw)).zw;
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
                o.texcoord4.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord4.xy = ((r1_z_3.xxxx + float4(r1_x_3, r1_w_4, r1_x_3, r1_x_3))).xy;
                return o;
            }
            #pragma fragment frag
            program96Output frag(program96Input i)
            {
                program96Output o = (program96Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_2 = ((r2_xyzw_1.xyzx * cb0_values[4].xyzx)).xyz;
                float4 r3_xyzw_1 = _DissolveMap.Sample(sampler_DissolveMap, (i.texcoord0.zwzz).xy);
                float r1_w_1 = (r3_xyzw_1.x + -cb0_values[6].x);
                float r2_w_2 = ((float4(1, 1, 1, 1) / cb0_values[6].y)).w;
                float r2_w_3 = saturate((r1_w_1 * r2_w_2));
                float r2_w_4 = (r2_w_3 * r2_w_3);
                float r2_w_5 = (r2_w_4 * mad(r2_w_3, -2, 3));
                float r1_w_2 = (r1_w_1 < 0);
                if (r1_w_2) discard;
                float4 r3_xyzw_3 = (r2_w_5.xxxx * r2_xyz_2.xyzx);
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r3_z_2 = r3_xyzw_3.z;
                float r4_x_1 = cb4_values[9].z;
                float r4_y_1 = cb4_values[10].z;
                float r4_z_1 = cb4_values[11].z;
                float r1_w_3 = dot(viewDir_xyz_1.xyzx, float4(r4_x_1, r4_y_1, r4_z_1, r4_x_1));
                float3 r4_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r3_w_2 = dot(r4_xyz_2.xyzx, r4_xyz_2.xyzx);
                float r3_w_3 = sqrt(r3_w_2);
                float r3_w_4 = (-r1_w_3 + r3_w_3);
                float r1_w_4 = mad(cb3_values[25].w, r3_w_4, r1_w_3);
                float r1_w_5 = saturate(mad(r1_w_4, cb3_values[24].z, cb3_values[24].w));
                float r3_w_5 = (cb5_values[0].x == 1);
                float r4_x_12;
                float r4_y_13;
                float r4_z_12;
                float r4_w_4;
                if (r3_w_5)
                {
                    float r3_w_6 = (cb5_values[0].y == 1);
                    float3 r4_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r4_xyzw_10 = (((((r3_w_6.xxxx ? r4_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r4_y_10 = r4_xyzw_10.y;
                    float r4_z_10 = r4_xyzw_10.z;
                    float r4_w_2 = r4_xyzw_10.w;
                    float r3_w_7 = mad(r4_y_10, 0.25, 0.75);
                    float r4_y_11 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r4_x_10 = max(r3_w_7, r4_y_11);
                    float4 r4_xyzw_11 = t3.Sample(sampler_linear_clamp, (float4(r4_x_10, r4_z_10, r4_w_2, r4_x_10)).xyz);
                    r4_x_12 = r4_xyzw_11.x;
                    r4_y_13 = r4_xyzw_11.y;
                    r4_z_12 = r4_xyzw_11.z;
                    r4_w_4 = r4_xyzw_11.w;
                }
                else
                {
                    float4 r4_xyzw_3 = float4(1, 1, 1, 1);
                    r4_x_12 = r4_xyzw_3.x;
                    r4_y_13 = r4_xyzw_3.y;
                    r4_z_12 = r4_xyzw_3.z;
                    r4_w_4 = r4_xyzw_3.w;
                }
                float r3_w_9 = saturate(dot(float4(r4_x_12, r4_y_13, r4_z_12, r4_w_4), unity_OcclusionMaskSelector));
                float4 r4_xyzw_13 = (i.texcoord4.xyxx / i.texcoord4.wwww);
                float r4_x_13 = r4_xyzw_13.x;
                float r4_y_14 = r4_xyzw_13.y;
                float4 r4_xyzw_14 = t2.Sample(sampler_linear_clamp1, (float4(r4_x_13, r4_y_14, r4_x_13, r4_x_13)).xy);
                float r3_w_10 = (r3_w_9 + -r4_xyzw_14.x);
                float r1_w_6 = mad(r1_w_5, r3_w_10, r4_xyzw_14.x);
                float4 r4_xyzw_15 = (r1_w_6.xxxx * _LightColor0.xyzx);
                float r4_x_15 = r4_xyzw_15.x;
                float r4_y_16 = r4_xyzw_15.y;
                float r4_z_14 = r4_xyzw_15.z;
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float3 r2_xyz_4 = (mad(cb0_values[6].zzzz, (mad(r2_xyz_2.xyzx, r2_w_5.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_9 = mad(-cb0_values[6].z, 0.96, 0.96);
                float4 r3_xyzw_4 = (r1_w_9.xxxx * float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r3_z_3 = r3_xyzw_4.z;
                float r1_w_10 = (-cb0_values[6].w + 1);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitWorldNormal_xyz_1.xyzx, unitViewDir_xyz_1.xyzx);
                float r1_x_2 = saturate(dot(unitWorldNormal_xyz_1.xyzx, _WorldSpaceLightPos0.xyzx));
                float r1_y_2 = saturate(dot(unitWorldNormal_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_10.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(nDotV_w_6) + 1);
                float r2_w_6 = (r1_z_4 * r1_z_4);
                float r2_w_7 = (r2_w_6 * r2_w_6);
                float r1_z_5 = (r1_z_4 * r2_w_7);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_10 * r1_w_10);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_z_6 = (-r0_z_8 + 1);
                float r1_w_11 = mad(abs(nDotV_w_6), r1_z_6, r0_z_8);
                float r1_z_7 = mad(r1_x_2, r1_z_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * r1_z_7);
                float r0_w_8 = mad(r1_x_2, r1_w_11, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_z_8 = mad(r1_y_2, r0_z_9, -r1_y_2);
                float r1_y_3 = mad(r1_z_8, r1_y_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r0_z_11 = (r0_z_10 / r1_y_4);
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_3 = (r0_y_9.xxxx * float4(r4_x_15, r4_y_16, r4_z_14, r4_x_15));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_5 = r1_xyzw_3.y;
                float r1_z_9 = r1_xyzw_3.z;
                float4 r0_xyzw_10 = (float4(r4_x_15, r4_x_15, r4_y_16, r4_z_14) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_12 = (r0_x_5 * r0_x_5);
                float r1_w_13 = (r1_w_12 * r1_w_12);
                float4 r4_xyzw_16 = (-r2_xyz_4.xyzx + float4(1, 1, 1, 0));
                float r4_x_16 = r4_xyzw_16.x;
                float r4_y_17 = r4_xyzw_16.y;
                float r4_z_15 = r4_xyzw_16.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * (mad(float4(r4_x_16, r4_y_17, r4_z_15, r4_x_16), ((r0_x_5 * r1_w_13)).xxxx, r2_xyz_4.xyzx)).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7))).xyz;
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
                float4 cb0_values[18];
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
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            Texture2D t2;
            Texture2D t3;
            Texture3D t4;
            Texture2D t5;
            struct program49Input
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
            struct program49Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program95Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program95Output
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
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[16].xyxx, cb0_values[16].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[17].xxxy, cb0_values[17].zzzw)).zw;
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float clipPos_x_3 = ((worldPos_xyzw_4.yyyy * cb0_values[10].xyzw)).x;
                float clipPos_y_3 = ((worldPos_xyzw_4.yyyy * cb0_values[10].xyzw)).y;
                float clipPos_z_3 = ((worldPos_xyzw_4.yyyy * cb0_values[10].xyzw)).z;
                float clipPos_w_4 = ((worldPos_xyzw_4.yyyy * cb0_values[10].xyzw)).w;
                float4 clipPos_xyzw_4 = mad(cb0_values[9].xyzw, worldPos_xyzw_4.xxxx, float4(clipPos_x_3, clipPos_y_3, clipPos_z_3, clipPos_w_4));
                float4 clipPos_xyzw_5 = mad(cb0_values[11].xyzw, worldPos_xyzw_4.zzzz, clipPos_xyzw_4);
                o.texcoord3.xyzw = mad(cb0_values[12].xyzw, worldPos_xyzw_4.wwww, clipPos_xyzw_5);
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program95Output frag(program95Input i)
            {
                program95Output o = (program95Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_2 = ((r4_xyzw_1.xyzx * cb0_values[13].xyzx)).xyz;
                float4 r5_xyzw_1 = _DissolveMap.Sample(sampler_DissolveMap, (i.texcoord0.zwzz).xy);
                float r1_w_3 = (r5_xyzw_1.x + -cb0_values[15].x);
                float r2_w_1 = ((float4(1, 1, 1, 1) / cb0_values[15].y)).w;
                float r2_w_2 = saturate((r1_w_3 * r2_w_1));
                float r3_w_1 = mad(r2_w_2, -2, 3);
                float r2_w_3 = (r2_w_2 * r2_w_2);
                float r2_w_4 = (r2_w_3 * r3_w_1);
                float r1_w_4 = (r1_w_3 < 0);
                if (r1_w_4) discard;
                float4 r6_xyzw_4 = (mad(cb0_values[11].xyzw, i.texcoord2.zzzz, mad(cb0_values[9].xyzw, i.texcoord2.xxxx, (i.texcoord2.yyyy * cb0_values[10].xyzw))) + cb0_values[12].xyzw);
                float r7_x_1 = cb4_values[9].z;
                float r7_y_1 = cb4_values[10].z;
                float r7_z_1 = cb4_values[11].z;
                float r1_w_5 = dot(viewDir_xyz_1.xyzx, float4(r7_x_1, r7_y_1, r7_z_1, r7_x_1));
                float3 r2_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_6 = mad(cb3_values[25].w, (-r1_w_5 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_5);
                float r1_w_7 = saturate(mad(r1_w_6, cb3_values[24].z, cb3_values[24].w));
                float r7_x_9;
                float r7_y_9;
                float r7_z_9;
                float r7_w_4;
                if (((cb5_values[0].x == 1)).x)
                {
                    float3 r7_xyz_6 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (((cb5_values[0].y == 1)).xxxx ? r7_xyz_6.xyzx : i.texcoord2.xyzx);
                    float r2_x_8 = r2_xyzw_8.x;
                    float r2_y_3 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float4 r2_xyzw_9 = (float4(r2_x_8, r2_y_3, r2_z_3, r2_x_8) + -cb5_values[6].xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_4 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float4 r7_xyzw_7 = (float4(r2_x_9, r2_x_9, r2_y_4, r2_z_4) * cb5_values[5].xxyz);
                    float r7_y_7 = r7_xyzw_7.y;
                    float r7_z_7 = r7_xyzw_7.z;
                    float r7_w_2 = r7_xyzw_7.w;
                    float r2_y_5 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r7_x_7 = max(r2_y_5, mad(r7_y_7, 0.25, 0.75));
                    float4 r7_xyzw_8 = t4.Sample(sampler_linear_clamp, (float4(r7_x_7, r7_z_7, r7_w_2, r7_x_7)).xyz);
                    r7_x_9 = r7_xyzw_8.x;
                    r7_y_9 = r7_xyzw_8.y;
                    r7_z_9 = r7_xyzw_8.z;
                    r7_w_4 = r7_xyzw_8.w;
                }
                else
                {
                    float4 r7_xyzw_2 = float4(1, 1, 1, 1);
                    r7_x_9 = r7_xyzw_2.x;
                    r7_y_9 = r7_xyzw_2.y;
                    r7_z_9 = r7_xyzw_2.z;
                    r7_w_4 = r7_xyzw_2.w;
                }
                float r2_y_7 = (r1_w_7 < 0.99);
                float r2_y_15;
                if (r2_y_7)
                {
                    float4 r7_xyzw_10 = (i.texcoord2.yyyy * cb3_values[9].xyzw);
                    float4 r7_xyzw_11 = mad(cb3_values[8].xyzw, i.texcoord2.xxxx, r7_xyzw_10);
                    float4 r7_xyzw_12 = mad(cb3_values[10].xyzw, i.texcoord2.zzzz, r7_xyzw_11);
                    float4 r7_xyzw_13 = (r7_xyzw_12 + cb3_values[11].xyzw);
                    float3 r7_xyz_14 = ((r7_xyzw_13.xyzx / r7_xyzw_13.wwww)).xyz;
                    float4 r2_xyzw_9 = mad(r7_xyz_14.xxyx, cb0_values[8].zzwz, float4(0, 0.5, 0.5, 0));
                    float r2_y_9 = r2_xyzw_9.y;
                    float r2_z_6 = r2_xyzw_9.z;
                    float4 r2_xyzw_10 = floor(float4(r2_y_9, r2_y_9, r2_z_6, r2_y_9));
                    float r2_y_10 = r2_xyzw_10.y;
                    float r2_z_7 = r2_xyzw_10.z;
                    float2 r7_xy_15 = (mad(r7_xyz_14.xyxx, cb0_values[8].zwzz, -float4(r2_y_10, r2_z_7, r2_y_10, r2_y_10))).xy;
                    float4 r8_xyzw_1 = (r7_xy_15.xxyy + float4(0.5, 1, 0.5, 1));
                    float2 r9_xw_1 = ((r8_xyzw_1.xxxz * r8_xyzw_1.xxxz)).xw;
                    float2 r8_xz_2 = (mad(r9_xw_1.xxyx, float4(0.5, 0, 0.5, 0), -r7_xy_15.xxyx)).xz;
                    float2 r10_zw_1 = (min(r7_xy_15.xxxy, float4(0, 0, 0, 0))).zw;
                    float2 r10_xy_2 = (mad(-r10_zw_1.xyxx, r10_zw_1.xyxx, ((-r7_xy_15.xyxx + float4(1, 1, 0, 0))).xyxx)).xy;
                    float2 r7_xy_16 = (max(r7_xy_15.xyxx, float4(0, 0, 0, 0))).xy;
                    float2 r7_xy_17 = (mad(-r7_xy_16.xyxx, r7_xy_16.xyxx, r8_xyzw_1.ywyy)).xy;
                    float r11_x_1 = r8_xz_2.x;
                    float r11_y_1 = r10_xy_2.x;
                    float r11_z_1 = r7_xy_17.x;
                    float r11_w_1 = r9_xw_1.x;
                    float4 r11_xyzw_2 = (float4(r11_x_1, r11_y_1, r11_z_1, r11_w_1) * float4(0.44444, 0.44444, 0.44444, 0.22222));
                    float r9_x_2 = r8_xz_2.y;
                    float r9_y_1 = r10_xy_2.y;
                    float r9_z_1 = r7_xy_17.y;
                    float4 r8_xyzw_3 = (float4(r9_x_2, r9_y_1, r9_z_1, r9_xw_1.y) * float4(0.44444, 0.44444, 0.44444, 0.22222));
                    float4 r9_xyzw_3 = (r11_xyzw_2.ywyw + r11_xyzw_2.xzxz);
                    float4 r10_xyzw_3 = (r8_xyzw_3.yyww + r8_xyzw_3.xxzz);
                    float4 r8_xyzw_4 = (r8_xyzw_3.ywyy / r10_xyzw_3.ywyy);
                    float r8_x_4 = r8_xyzw_4.x;
                    float r8_y_3 = r8_xyzw_4.y;
                    float4 r8_xyzw_5 = (float4(r8_x_4, r8_y_3, r8_x_4, r8_x_4) + float4(-1.5, 0.5, 0, 0));
                    float r8_x_5 = r8_xyzw_5.x;
                    float r8_y_4 = r8_xyzw_5.y;
                    float2 r11_xy_3 = ((((((r11_xyzw_2.ywyy / r9_xyzw_3.zwzz)).xyxx + float4(-1.5, 0.5, 0, 0))).xyxx * cb0_values[8].xxxx)).xy;
                    float2 r11_zw_3 = ((float4(r8_x_5, r8_x_5, r8_x_5, r8_y_4) * cb0_values[8].yyyy)).zw;
                    float4 r8_xyzw_6 = (r9_xyzw_3 * r10_xyzw_3);
                    float4 r9_xyzw_4 = mad(float4(r2_y_10, r2_z_7, r2_y_10, r2_z_7), cb0_values[8].xyxy, float4(r11_xy_3.x, r11_zw_3.x, r11_xy_3.y, r11_zw_3.x));
                    float r3_w_2 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r9_xyzw_4.xyxx).xy, r7_xyz_14.z);
                    float r4_w_2 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r9_xyzw_4.zwzz).xy, r7_xyz_14.z);
                    float r4_w_3 = (r4_w_2 * r8_xyzw_6.y);
                    float r3_w_3 = mad(r8_xyzw_6.x, r3_w_2, r4_w_3);
                    float4 r9_xyzw_5 = mad(float4(r2_y_10, r2_z_7, r2_y_10, r2_z_7), cb0_values[8].xyxy, float4(r11_xy_3.x, r11_zw_3.y, r11_xy_3.y, r11_zw_3.y));
                    float r2_y_11 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r9_xyzw_5.xyxx).xy, r7_xyz_14.z);
                    float r2_y_12 = mad(r8_xyzw_6.z, r2_y_11, r3_w_3);
                    float r2_z_8 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r9_xyzw_5.zwzz).xy, r7_xyz_14.z);
                    float r2_y_13 = mad(r8_xyzw_6.w, r2_z_8, r2_y_12);
                    float r2_z_9 = (-cb3_values[24].x + 1);
                    float r2_y_14 = mad(r2_y_13, r2_z_9, cb3_values[24].x);
                    r2_y_15 = r2_y_14;
                }
                else
                {
                    float r2_y_8 = 1;
                    r2_y_15 = r2_y_8;
                }
                float r1_w_8 = mad(r1_w_7, (-r2_y_15 + saturate(dot(float4(r7_x_9, r7_y_9, r7_z_9, r7_w_4), unity_OcclusionMaskSelector))), r2_y_15);
                float4 r2_xyzw_16 = (r6_xyzw_4.xxyx / r6_xyzw_4.wwww);
                float r2_y_16 = r2_xyzw_16.y;
                float r2_z_11 = r2_xyzw_16.z;
                float4 r2_xyzw_17 = (float4(r2_y_16, r2_y_16, r2_z_11, r2_y_16) + float4(0, 0.5, 0.5, 0));
                float r2_y_17 = r2_xyzw_17.y;
                float r2_z_12 = r2_xyzw_17.z;
                float4 r7_xyzw_21 = t2.Sample(sampler_linear_clamp2, (float4(r2_y_17, r2_z_12, r2_y_17, r2_y_17)).xy);
                float r2_y_18 = dot(r6_xyzw_4.xyzx, r6_xyzw_4.xyzx);
                float4 r6_xyzw_5 = t3.Sample(sampler_linear_clamp3, (r2_y_18.xxxx).xy);
                float r1_w_9 = (r1_w_8 * ((asfloat(asint((float)((0 < r6_xyzw_4.z))) & asint(1065353216)) * r7_xyzw_21.w) * r6_xyzw_5.x));
                float4 r2_xyzw_18 = (r1_w_9.xxxx * _LightColor0.xyzx);
                float r2_x_18 = r2_xyzw_18.x;
                float r2_y_19 = r2_xyzw_18.y;
                float r2_z_13 = r2_xyzw_18.z;
                float3 unitWorldNormal_xyz_6 = normalize(i.texcoord1);
                float3 r4_xyz_4 = (mad(cb0_values[15].zzzz, (mad(r4_xyz_2.xyzx, r2_w_4.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_12 = mad(-cb0_values[15].z, 0.96, 0.96);
                float r1_w_13 = (-cb0_values[15].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitWorldNormal_xyz_6.xyzx, unitViewDir_xyz_1.xyzx);
                float r2_w_5 = saturate(dot(unitWorldNormal_xyz_6.xyzx, r1_xyz_1.xyzx));
                float r3_x_2 = saturate(dot(unitWorldNormal_xyz_6.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_13.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_5 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(nDotV_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_13 * r1_w_13);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(nDotV_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * mad(r2_w_5, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_5, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r3_x_2, r0_z_9, -r3_x_2), r3_x_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_w_5.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r2_x_18, r2_y_19, r2_z_13, r2_x_18));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r2_x_18, r2_x_18, r2_y_19, r2_z_13) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_14 = (r0_x_5 * r0_x_5);
                float r1_w_15 = (r1_w_14 * r1_w_14);
                float4 r2_xyzw_19 = (-r4_xyz_4.xyzx + float4(1, 1, 1, 0));
                float r2_x_19 = r2_xyzw_19.x;
                float r2_y_20 = r2_xyzw_19.y;
                float r2_z_14 = r2_xyzw_19.z;
                float4 r2_xyzw_20 = mad(float4(r2_x_19, r2_y_20, r2_z_14, r2_x_19), ((r0_x_5 * r1_w_15)).xxxx, r4_xyz_4.xyzx);
                float r2_x_20 = r2_xyzw_20.x;
                float r2_y_21 = r2_xyzw_20.y;
                float r2_z_15 = r2_xyzw_20.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_20, r2_y_21, r2_z_15, r2_x_20));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(((r1_w_12.xxxx * ((r2_w_4.xxxx * r4_xyz_2.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7))).xyz;
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
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            Texture2D t2;
            Texture2D t3;
            Texture3D t4;
            Texture2D t5;
            struct program48Input
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
            struct program48Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program94Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program94Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program48Output vert(program48Input i)
            {
                program48Output o = (program48Output)0;
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
                float clipPos_x_3 = ((worldPos_xyzw_4.yyyy * _EdgeColor)).x;
                float clipPos_y_3 = ((worldPos_xyzw_4.yyyy * _EdgeColor)).y;
                float clipPos_z_3 = ((worldPos_xyzw_4.yyyy * _EdgeColor)).z;
                float clipPos_w_4 = ((worldPos_xyzw_4.yyyy * _EdgeColor)).w;
                float4 clipPos_xyzw_4 = mad(_Color, worldPos_xyzw_4.xxxx, float4(clipPos_x_3, clipPos_y_3, clipPos_z_3, clipPos_w_4));
                float4 clipPos_xyzw_5 = mad(cb0_values[6].xyzw, worldPos_xyzw_4.zzzz, clipPos_xyzw_4);
                o.texcoord3.xyzw = mad(_MainTex_ST, worldPos_xyzw_4.wwww, clipPos_xyzw_5);
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program94Output frag(program94Input i)
            {
                program94Output o = (program94Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_2 = ((r4_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float4 r5_xyzw_1 = _DissolveMap.Sample(sampler_DissolveMap, (i.texcoord0.zwzz).xy);
                float r1_w_3 = (r5_xyzw_1.x + -cb0_values[10].x);
                float r2_w_1 = ((float4(1, 1, 1, 1) / cb0_values[10].y)).w;
                float r2_w_2 = saturate((r1_w_3 * r2_w_1));
                float r3_w_1 = mad(r2_w_2, -2, 3);
                float r2_w_3 = (r2_w_2 * r2_w_2);
                float r2_w_4 = (r2_w_3 * r3_w_1);
                float r1_w_4 = (r1_w_3 < 0);
                if (r1_w_4) discard;
                float4 r6_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord2.zzzz, mad(cb0_values[4].xyzw, i.texcoord2.xxxx, (i.texcoord2.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r7_x_1 = cb4_values[9].z;
                float r7_y_1 = cb4_values[10].z;
                float r7_z_1 = cb4_values[11].z;
                float r1_w_5 = dot(viewDir_xyz_1.xyzx, float4(r7_x_1, r7_y_1, r7_z_1, r7_x_1));
                float3 r2_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_6 = mad(cb3_values[25].w, (-r1_w_5 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_5);
                float r1_w_7 = saturate(mad(r1_w_6, cb3_values[24].z, cb3_values[24].w));
                float r7_x_9;
                float r7_y_9;
                float r7_z_9;
                float r7_w_4;
                if (((cb5_values[0].x == 1)).x)
                {
                    float3 r7_xyz_6 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (((cb5_values[0].y == 1)).xxxx ? r7_xyz_6.xyzx : i.texcoord2.xyzx);
                    float r2_x_8 = r2_xyzw_8.x;
                    float r2_y_3 = r2_xyzw_8.y;
                    float r2_z_3 = r2_xyzw_8.z;
                    float4 r2_xyzw_9 = (float4(r2_x_8, r2_y_3, r2_z_3, r2_x_8) + -cb5_values[6].xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_4 = r2_xyzw_9.y;
                    float r2_z_4 = r2_xyzw_9.z;
                    float4 r7_xyzw_7 = (float4(r2_x_9, r2_x_9, r2_y_4, r2_z_4) * cb5_values[5].xxyz);
                    float r7_y_7 = r7_xyzw_7.y;
                    float r7_z_7 = r7_xyzw_7.z;
                    float r7_w_2 = r7_xyzw_7.w;
                    float r2_y_5 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r7_x_7 = max(r2_y_5, mad(r7_y_7, 0.25, 0.75));
                    float4 r7_xyzw_8 = t4.Sample(sampler_linear_clamp, (float4(r7_x_7, r7_z_7, r7_w_2, r7_x_7)).xyz);
                    r7_x_9 = r7_xyzw_8.x;
                    r7_y_9 = r7_xyzw_8.y;
                    r7_z_9 = r7_xyzw_8.z;
                    r7_w_4 = r7_xyzw_8.w;
                }
                else
                {
                    float4 r7_xyzw_2 = float4(1, 1, 1, 1);
                    r7_x_9 = r7_xyzw_2.x;
                    r7_y_9 = r7_xyzw_2.y;
                    r7_z_9 = r7_xyzw_2.z;
                    r7_w_4 = r7_xyzw_2.w;
                }
                float4 r7_xyzw_10 = (i.texcoord2.yyyy * cb3_values[9].xyzw);
                float4 r7_xyzw_11 = mad(cb3_values[8].xyzw, i.texcoord2.xxxx, r7_xyzw_10);
                float4 r7_xyzw_12 = mad(cb3_values[10].xyzw, i.texcoord2.zzzz, r7_xyzw_11);
                float4 r7_xyzw_13 = (r7_xyzw_12 + cb3_values[11].xyzw);
                float3 r7_xyz_14 = ((r7_xyzw_13.xyzx / r7_xyzw_13.wwww)).xyz;
                float r2_y_7 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r7_xyz_14.xyxx).xy, r7_xyz_14.z);
                float r2_z_6 = (-cb3_values[24].x + 1);
                float r2_y_8 = mad(r2_y_7, r2_z_6, cb3_values[24].x);
                float r1_w_8 = mad(r1_w_7, (-r2_y_8 + saturate(dot(float4(r7_x_9, r7_y_9, r7_z_9, r7_w_4), unity_OcclusionMaskSelector))), r2_y_8);
                float4 r2_xyzw_9 = (r6_xyzw_4.xxyx / r6_xyzw_4.wwww);
                float r2_y_9 = r2_xyzw_9.y;
                float r2_z_7 = r2_xyzw_9.z;
                float4 r2_xyzw_10 = (float4(r2_y_9, r2_y_9, r2_z_7, r2_y_9) + float4(0, 0.5, 0.5, 0));
                float r2_y_10 = r2_xyzw_10.y;
                float r2_z_8 = r2_xyzw_10.z;
                float4 r7_xyzw_15 = t2.Sample(sampler_linear_clamp2, (float4(r2_y_10, r2_z_8, r2_y_10, r2_y_10)).xy);
                float r2_y_11 = dot(r6_xyzw_4.xyzx, r6_xyzw_4.xyzx);
                float4 r6_xyzw_5 = t3.Sample(sampler_linear_clamp3, (r2_y_11.xxxx).xy);
                float r1_w_9 = (r1_w_8 * ((asfloat(asint((float)((0 < r6_xyzw_4.z))) & asint(1065353216)) * r7_xyzw_15.w) * r6_xyzw_5.x));
                float4 r2_xyzw_18 = (r1_w_9.xxxx * _LightColor0.xyzx);
                float r2_x_18 = r2_xyzw_18.x;
                float r2_y_12 = r2_xyzw_18.y;
                float r2_z_9 = r2_xyzw_18.z;
                float3 unitWorldNormal_xyz_6 = normalize(i.texcoord1);
                float3 r4_xyz_4 = (mad(cb0_values[10].zzzz, (mad(r4_xyz_2.xyzx, r2_w_4.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_12 = mad(-cb0_values[10].z, 0.96, 0.96);
                float r1_w_13 = (-cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitWorldNormal_xyz_6.xyzx, unitViewDir_xyz_1.xyzx);
                float r2_w_5 = saturate(dot(unitWorldNormal_xyz_6.xyzx, r1_xyz_1.xyzx));
                float r3_x_2 = saturate(dot(unitWorldNormal_xyz_6.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_13.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_5 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(nDotV_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_13 * r1_w_13);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(nDotV_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * mad(r2_w_5, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_5, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r3_x_2, r0_z_9, -r3_x_2), r3_x_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_w_5.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r2_x_18, r2_y_12, r2_z_9, r2_x_18));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r2_x_18, r2_x_18, r2_y_12, r2_z_9) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_14 = (r0_x_5 * r0_x_5);
                float r1_w_15 = (r1_w_14 * r1_w_14);
                float4 r2_xyzw_19 = (-r4_xyz_4.xyzx + float4(1, 1, 1, 0));
                float r2_x_19 = r2_xyzw_19.x;
                float r2_y_13 = r2_xyzw_19.y;
                float r2_z_10 = r2_xyzw_19.z;
                float4 r2_xyzw_20 = mad(float4(r2_x_19, r2_y_13, r2_z_10, r2_x_19), ((r0_x_5 * r1_w_15)).xxxx, r4_xyz_4.xyzx);
                float r2_x_20 = r2_xyzw_20.x;
                float r2_y_14 = r2_xyzw_20.y;
                float r2_z_11 = r2_xyzw_20.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * float4(r2_x_20, r2_y_14, r2_z_11, r2_x_20));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(((r1_w_12.xxxx * ((r2_w_4.xxxx * r4_xyz_2.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7))).xyz;
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
            struct program47Input
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
            struct program47Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program93Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program93Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program47Output vert(program47Input i)
            {
                program47Output o = (program47Output)0;
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
                float2 clipPos_xy_3 = ((worldPos_xyzw_4.yyyy * _EdgeColor.xyxx)).xy;
                float2 clipPos_xy_5 = (mad(_Color.xyxx, worldPos_xyzw_4.xxxx, clipPos_xy_3.xyxx)).xy;
                float2 clipPos_xy_6 = (mad(cb0_values[6].xyxx, worldPos_xyzw_4.zzzz, clipPos_xy_5.xyxx)).xy;
                o.texcoord3.xy = (mad(_MainTex_ST.xyxx, worldPos_xyzw_4.wwww, clipPos_xy_6.xyxx)).xy;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program93Output frag(program93Input i)
            {
                program93Output o = (program93Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_2 = ((r2_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float4 r3_xyzw_1 = _DissolveMap.Sample(sampler_DissolveMap, (i.texcoord0.zwzz).xy);
                float r1_w_1 = (r3_xyzw_1.x + -cb0_values[10].x);
                float r2_w_2 = ((float4(1, 1, 1, 1) / cb0_values[10].y)).w;
                float r2_w_3 = saturate((r1_w_1 * r2_w_2));
                float r2_w_4 = (r2_w_3 * r2_w_3);
                float r2_w_5 = (r2_w_4 * mad(r2_w_3, -2, 3));
                float r1_w_2 = (r1_w_1 < 0);
                if (r1_w_2) discard;
                float4 r3_xyzw_3 = (r2_w_5.xxxx * r2_xyz_2.xyzx);
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r3_z_2 = r3_xyzw_3.z;
                float r1_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r1_w_3)
                {
                    float r1_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r5_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r1_w_4.xxxx ? r5_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r5_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r1_w_5 = mad(r5_y_8, 0.25, 0.75);
                    float r3_w_2 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r5_x_8 = max(r1_w_5, r3_w_2);
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
                float r1_w_7 = saturate(dot(float4(r5_x_10, r5_y_10, r5_z_10, r5_w_4), unity_OcclusionMaskSelector));
                float4 r4_xyzw_5 = t2.Sample(sampler_linear_clamp1, ((((mad(cb0_values[6].xyxx, i.texcoord2.zzzz, (mad(cb0_values[4].xyxx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx).xy);
                float r1_w_8 = (r1_w_7 * r4_xyzw_5.w);
                float4 r4_xyzw_6 = (r1_w_8.xxxx * _LightColor0.xyzx);
                float r4_x_6 = r4_xyzw_6.x;
                float r4_y_6 = r4_xyzw_6.y;
                float r4_z_2 = r4_xyzw_6.z;
                float3 unitWorldNormal_xyz_11 = normalize(i.texcoord1);
                float3 r2_xyz_4 = (mad(cb0_values[10].zzzz, (mad(r2_xyz_2.xyzx, r2_w_5.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_11 = mad(-cb0_values[10].z, 0.96, 0.96);
                float4 r3_xyzw_4 = (r1_w_11.xxxx * float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r3_z_3 = r3_xyzw_4.z;
                float r1_w_12 = (-cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitWorldNormal_xyz_11.xyzx, unitViewDir_xyz_1.xyzx);
                float r1_x_2 = saturate(dot(unitWorldNormal_xyz_11.xyzx, _WorldSpaceLightPos0.xyzx));
                float r1_y_2 = saturate(dot(unitWorldNormal_xyz_11.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_12.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(nDotV_w_6) + 1);
                float r2_w_6 = (r1_z_4 * r1_z_4);
                float r2_w_7 = (r2_w_6 * r2_w_6);
                float r1_z_5 = (r1_z_4 * r2_w_7);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_12 * r1_w_12);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_z_6 = (-r0_z_8 + 1);
                float r1_w_13 = mad(abs(nDotV_w_6), r1_z_6, r0_z_8);
                float r1_z_7 = mad(r1_x_2, r1_z_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * r1_z_7);
                float r0_w_8 = mad(r1_x_2, r1_w_13, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_z_8 = mad(r1_y_2, r0_z_9, -r1_y_2);
                float r1_y_3 = mad(r1_z_8, r1_y_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r0_z_11 = (r0_z_10 / r1_y_4);
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_3 = (r0_y_9.xxxx * float4(r4_x_6, r4_y_6, r4_z_2, r4_x_6));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_5 = r1_xyzw_3.y;
                float r1_z_9 = r1_xyzw_3.z;
                float4 r0_xyzw_10 = (float4(r4_x_6, r4_x_6, r4_y_6, r4_z_2) * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_14 = (r0_x_5 * r0_x_5);
                float r1_w_15 = (r1_w_14 * r1_w_14);
                float4 r4_xyzw_7 = (-r2_xyz_4.xyzx + float4(1, 1, 1, 0));
                float r4_x_7 = r4_xyzw_7.x;
                float r4_y_7 = r4_xyzw_7.y;
                float r4_z_3 = r4_xyzw_7.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * (mad(float4(r4_x_7, r4_y_7, r4_z_3, r4_x_7), ((r0_x_5 * r1_w_15)).xxxx, r2_xyz_4.xyzx)).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7))).xyz;
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
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            Texture2D t2;
            TextureCube t3;
            Texture3D t4;
            struct program46Input
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
            struct program46Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program92Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program92Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program46Output vert(program46Input i)
            {
                program46Output o = (program46Output)0;
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
            program92Output frag(program92Input i)
            {
                program92Output o = (program92Output)0;
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
                float r1_w_9 = saturate(dot(float4(r6_x_10, r6_y_10, r6_z_10, r6_w_4), unity_OcclusionMaskSelector));
                float r3_w_5 = dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx);
                float4 r6_xyzw_11 = t2.Sample(sampler_linear_clamp2, (r3_w_5.xxxx).xy);
                float4 r5_xyzw_5 = t3.Sample(sampler_linear_clamp1, r5_xyz_4.xyz);
                float r3_w_6 = (r5_xyzw_5.w * r6_xyzw_11.x);
                float r1_w_10 = (r1_w_9 * r3_w_6);
                float3 r5_xyz_6 = ((r1_w_10.xxxx * _LightColor0.xyzx)).xyz;
                float3 unitWorldNormal_xyz_12 = normalize(i.texcoord1);
                float3 r3_xyz_4 = (mad(cb0_values[10].zzzz, (mad(r3_xyz_2.xyzx, r2_w_4.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_13 = mad(-cb0_values[10].z, 0.96, 0.96);
                float r1_w_14 = (-cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_2.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitWorldNormal_xyz_12.xyzx, unitViewDir_xyz_2.xyzx);
                float r2_x_3 = saturate(dot(unitWorldNormal_xyz_12.xyzx, r1_xyz_1.xyzx));
                float r2_y_3 = saturate(dot(unitWorldNormal_xyz_12.xyzx, r0_xyz_3.xyzx));
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
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            Texture2D t2;
            Texture2D t3;
            Texture3D t4;
            struct program45Input
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
            struct program45Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program91Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program91Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program45Output vert(program45Input i)
            {
                program45Output o = (program45Output)0;
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
                float clipPos_x_3 = ((worldPos_xyzw_4.yyyy * _EdgeColor)).x;
                float clipPos_y_3 = ((worldPos_xyzw_4.yyyy * _EdgeColor)).y;
                float clipPos_z_3 = ((worldPos_xyzw_4.yyyy * _EdgeColor)).z;
                float clipPos_w_4 = ((worldPos_xyzw_4.yyyy * _EdgeColor)).w;
                float4 clipPos_xyzw_4 = mad(_Color, worldPos_xyzw_4.xxxx, float4(clipPos_x_3, clipPos_y_3, clipPos_z_3, clipPos_w_4));
                float4 clipPos_xyzw_5 = mad(cb0_values[6].xyzw, worldPos_xyzw_4.zzzz, clipPos_xyzw_4);
                o.texcoord3.xyzw = mad(_MainTex_ST, worldPos_xyzw_4.wwww, clipPos_xyzw_5);
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program91Output frag(program91Input i)
            {
                program91Output o = (program91Output)0;
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
                float4 r5_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord2.zzzz, mad(cb0_values[4].xyzw, i.texcoord2.xxxx, (i.texcoord2.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
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
                float r1_w_9 = saturate(dot(float4(r6_x_10, r6_y_10, r6_z_10, r6_w_4), unity_OcclusionMaskSelector));
                float r3_w_5 = (0 < r5_xyzw_4.z);
                float r3_w_6 = asfloat(asint(r3_w_5) & asint(1065353216));
                float4 r6_xyzw_13 = t2.Sample(sampler_linear_clamp1, (((((r5_xyzw_4.xyxx / r5_xyzw_4.wwww)).xyxx + float4(0.5, 0.5, 0, 0))).xyxx).xy);
                float r3_w_7 = (r3_w_6 * r6_xyzw_13.w);
                float r4_w_2 = dot(r5_xyzw_4.xyzx, r5_xyzw_4.xyzx);
                float4 r5_xyzw_5 = t3.Sample(sampler_linear_clamp2, (r4_w_2.xxxx).xy);
                float r3_w_8 = (r3_w_7 * r5_xyzw_5.x);
                float r1_w_10 = (r1_w_9 * r3_w_8);
                float3 r5_xyz_6 = ((r1_w_10.xxxx * _LightColor0.xyzx)).xyz;
                float r1_w_11 = dot(i.texcoord1.xyzx, i.texcoord1.xyzx);
                float r1_w_12 = rsqrt(r1_w_11);
                float4 unitWorldNormal_xyzw_14 = (r1_w_12.xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_14 = unitWorldNormal_xyzw_14.x;
                float unitWorldNormal_y_14 = unitWorldNormal_xyzw_14.y;
                float unitWorldNormal_z_12 = unitWorldNormal_xyzw_14.z;
                float3 r3_xyz_4 = (mad(cb0_values[10].zzzz, (mad(r3_xyz_2.xyzx, r2_w_4.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_13 = mad(-cb0_values[10].z, 0.96, 0.96);
                float r1_w_14 = (-cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_2.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(float4(unitWorldNormal_x_14, unitWorldNormal_y_14, unitWorldNormal_z_12, unitWorldNormal_x_14), unitViewDir_xyz_2.xyzx);
                float r2_x_3 = saturate(dot(float4(unitWorldNormal_x_14, unitWorldNormal_y_14, unitWorldNormal_z_12, unitWorldNormal_x_14), r1_xyz_1.xyzx));
                float r2_y_3 = saturate(dot(float4(unitWorldNormal_x_14, unitWorldNormal_y_14, unitWorldNormal_z_12, unitWorldNormal_x_14), r0_xyz_3.xyzx));
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
                float4 cb0_values[7];
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
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            Texture3D t2;
            struct program44Input
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
            struct program44Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program90Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program90Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program44Output vert(program44Input i)
            {
                program44Output o = (program44Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _MainTex_ST.xxxy, _MainTex_ST.zzzw)).zw;
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
            program90Output frag(program90Input i)
            {
                program90Output o = (program90Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_2 = ((r2_xyzw_1.xyzx * cb0_values[4].xyzx)).xyz;
                float4 r3_xyzw_1 = _DissolveMap.Sample(sampler_DissolveMap, (i.texcoord0.zwzz).xy);
                float r1_w_1 = (r3_xyzw_1.x + -cb0_values[6].x);
                float r2_w_2 = ((float4(1, 1, 1, 1) / cb0_values[6].y)).w;
                float r2_w_3 = saturate((r1_w_1 * r2_w_2));
                float r2_w_4 = (r2_w_3 * r2_w_3);
                float r2_w_5 = (r2_w_4 * mad(r2_w_3, -2, 3));
                float r1_w_2 = (r1_w_1 < 0);
                if (r1_w_2) discard;
                float4 r3_xyzw_3 = (r2_w_5.xxxx * r2_xyz_2.xyzx);
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r3_z_2 = r3_xyzw_3.z;
                float r1_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r4_x_10;
                float r4_y_10;
                float r4_z_10;
                float r4_w_4;
                if (r1_w_3)
                {
                    float r1_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r4_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r1_w_4.xxxx ? r4_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r4_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r4_y_8 = r4_xyzw_8.y;
                    float r4_z_8 = r4_xyzw_8.z;
                    float r4_w_2 = r4_xyzw_8.w;
                    float r1_w_5 = mad(r4_y_8, 0.25, 0.75);
                    float r3_w_2 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r4_x_8 = max(r1_w_5, r3_w_2);
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
                float r1_w_7 = saturate(dot(float4(r4_x_10, r4_y_10, r4_z_10, r4_w_4), unity_OcclusionMaskSelector));
                float3 r4_xyz_11 = ((r1_w_7.xxxx * _LightColor0.xyzx)).xyz;
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float3 r2_xyz_4 = (mad(cb0_values[6].zzzz, (mad(r2_xyz_2.xyzx, r2_w_5.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_10 = mad(-cb0_values[6].z, 0.96, 0.96);
                float4 r3_xyzw_4 = (r1_w_10.xxxx * float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r3_z_3 = r3_xyzw_4.z;
                float r1_w_11 = (-cb0_values[6].w + 1);
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float nDotV_w_6 = dot(unitWorldNormal_xyz_1.xyzx, unitViewDir_xyz_1.xyzx);
                float r1_x_2 = saturate(dot(unitWorldNormal_xyz_1.xyzx, _WorldSpaceLightPos0.xyzx));
                float r1_y_2 = saturate(dot(unitWorldNormal_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(_WorldSpaceLightPos0.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_11.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(nDotV_w_6) + 1);
                float r2_w_6 = (r1_z_4 * r1_z_4);
                float r2_w_7 = (r2_w_6 * r2_w_6);
                float r1_z_5 = (r1_z_4 * r2_w_7);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_11 * r1_w_11);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_z_6 = (-r0_z_8 + 1);
                float r1_w_12 = mad(abs(nDotV_w_6), r1_z_6, r0_z_8);
                float r1_z_7 = mad(r1_x_2, r1_z_6, r0_z_8);
                float r0_w_7 = (abs(nDotV_w_6) * r1_z_7);
                float r0_w_8 = mad(r1_x_2, r1_w_12, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_z_8 = mad(r1_y_2, r0_z_9, -r1_y_2);
                float r1_y_3 = mad(r1_z_8, r1_y_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r0_z_11 = (r0_z_10 / r1_y_4);
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_z_15 = max(r0_z_14, 0);
                float r0_w_11 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_16 = (r0_w_13 * r0_z_15);
                float4 r1_xyzw_3 = (r0_y_9.xxxx * r4_xyz_11.xyzx);
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_5 = r1_xyzw_3.y;
                float r1_z_9 = r1_xyzw_3.z;
                float4 r0_xyzw_10 = (r4_xyz_11.xxyz * r0_z_16.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_17 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_13 = (r0_x_5 * r0_x_5);
                float r1_w_14 = (r1_w_13 * r1_w_13);
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_17, r0_w_14, r0_y_10) * (mad(((-r2_xyz_4.xyzx + float4(1, 1, 1, 0))).xyzx, ((r0_x_5 * r1_w_14)).xxxx, r2_xyz_4.xyzx)).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_18 = r0_xyzw_7.z;
                o.sv_Target0.xyz = (mad(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_7, r0_y_11, r0_z_18, r0_x_7))).xyz;
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
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[46];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[7];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[21];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_MainTex;
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            Texture3D t2;
            struct program120Input
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
            struct program120Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
            };
            struct program126Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
            };
            struct program126Output
            {
                float4 sv_Target0 : SV_Target;
                float4 sv_Target1 : SV_Target1;
                float4 sv_Target2 : SV_Target2;
                float4 sv_Target3 : SV_Target3;
            };
            #pragma vertex vert
            program120Output vert(program120Input i)
            {
                program120Output o = (program120Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _DissolveMap_ST.xxxy, _DissolveMap_ST.zzzw)).zw;
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                float3 unitWorldNormal_xyz_8 = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.texcoord1.xyz = unitWorldNormal_xyz_8.xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                float r0_w_9 = (unitWorldNormal_xyz_8.y * unitWorldNormal_xyz_8.y);
                float r0_w_10 = mad(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.x, -r0_w_9);
                float4 r1_xyzw_2 = (unitWorldNormal_xyz_8.yzzx * unitWorldNormal_xyz_8.xyzz);
                float r0_x_9 = dot(cb1_values[42].xyzw, r1_xyzw_2);
                float r0_y_9 = dot(cb1_values[43].xyzw, r1_xyzw_2);
                float r0_z_9 = dot(cb1_values[44].xyzw, r1_xyzw_2);
                o.texcoord5.xyz = (mad(cb1_values[45].xyzx, r0_w_10.xxxx, float4(r0_x_9, r0_y_9, r0_z_9, r0_x_9))).xyz;
                return o;
            }
            #pragma fragment frag
            program126Output frag(program126Input i)
            {
                program126Output o = (program126Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r0_xyz_2 = ((r0_xyzw_1.xyzx * _Color.xyzx)).xyz;
                float4 r1_xyzw_1 = _DissolveMap.Sample(sampler_DissolveMap, (i.texcoord0.zwzz).xy);
                float r0_w_2 = (r1_xyzw_1.x + -_Cutoff);
                float r1_x_3 = (saturate((r0_w_2 * (float4(1, 1, 1, 1) / _EdgeWidth)))).x;
                float r1_y_2 = mad(r1_x_3, -2, 3);
                float r1_x_4 = (r1_x_3 * r1_x_3);
                float r1_z_2 = (r1_x_4 * r1_y_2);
                float r0_w_3 = (r0_w_2 < 0);
                if (r0_w_3) discard;
                float r0_w_4 = mad(-r1_y_2, r1_x_4, 1);
                float4 r1_xyzw_5 = (r0_w_4.xxxx * _EdgeColor.xyxz);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_3 = r1_xyzw_5.y;
                float r1_w_2 = r1_xyzw_5.w;
                float r0_w_5 = (cb2_values[0].x == 1);
                float3 TEXCOORD1_xyz_1;
                float3 r4_xyz_4;
                if (r0_w_5)
                {
                    float r0_w_6 = (cb2_values[0].y == 1);
                    float3 r3_xyz_5 = (((mad(cb2_values[3].xyzx, i.texcoord2.zzzz, (mad(cb2_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb2_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb2_values[4].xyzx)).xyz;
                    float4 r3_xyzw_8 = (((((r0_w_6.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb2_values[6].xyzx)).xxyz * cb2_values[5].xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_7 = (r3_y_8 * 0.25);
                    float r2_w_1 = (cb2_values[0].z * 0.5);
                    float r3_y_9 = mad(-cb2_values[0].z, 0.5, 0.25);
                    float r0_w_8 = max(r0_w_7, r2_w_1);
                    float r3_x_8 = min(r3_y_9, r0_w_8);
                    float4 r4_xyzw_2 = t2.Sample(sampler_linear_clamp, (float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8)).xyz);
                    float4 r5_xyzw_2 = t2.Sample(sampler_linear_clamp, (((float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8) + float4(0.25, 0, 0, 0))).xyzx).xyz);
                    float4 r3_xyzw_9 = (float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8) + float4(0.5, 0, 0, 0));
                    float r3_x_9 = r3_xyzw_9.x;
                    float r3_y_10 = r3_xyzw_9.y;
                    float r3_z_9 = r3_xyzw_9.z;
                    float4 r3_xyzw_10 = t2.Sample(sampler_linear_clamp, (float4(r3_x_9, r3_y_10, r3_z_9, r3_x_9)).xyz);
                    TEXCOORD1_xyz_1 = i.texcoord1.xyz;
                    float r6_w_1 = 1;
                    float r4_x_3 = dot(r4_xyzw_2, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r6_w_1));
                    float r4_y_3 = dot(r5_xyzw_2, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r6_w_1));
                    float r4_z_3 = dot(r3_xyzw_10, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r6_w_1));
                    r4_xyz_4 = float3(r4_x_3, r4_y_3, r4_z_3);
                }
                else
                {
                    TEXCOORD1_xyz_1 = i.texcoord1.xyz;
                    float r3_w_1 = 1;
                    float r4_x_1 = dot(cb1_values[39].xyzw, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r3_w_1));
                    float r4_y_1 = dot(cb1_values[40].xyzw, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r3_w_1));
                    float r4_z_1 = dot(cb1_values[41].xyzw, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r3_w_1));
                    r4_xyz_4 = float3(r4_x_1, r4_y_1, r4_z_1);
                }
                float4 r3_xyzw_12 = (r4_xyz_4.xyzx + i.texcoord5.xyzx);
                float r3_x_12 = r3_xyzw_12.x;
                float r3_y_13 = r3_xyzw_12.y;
                float r3_z_12 = r3_xyzw_12.z;
                float4 r3_xyzw_13 = max(float4(r3_x_12, r3_y_13, r3_z_12, r3_x_12), float4(0, 0, 0, 0));
                float r3_x_13 = r3_xyzw_13.x;
                float r3_y_14 = r3_xyzw_13.y;
                float r3_z_13 = r3_xyzw_13.z;
                o.sv_Target1.xyz = (mad(_Metallic.xxxx, (mad(r0_xyz_2.xyzx, r1_z_2.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float4 r0_xyzw_5 = ((mad(-_Metallic, 0.96, 0.96)).xxxx * ((r0_xyz_2.xyzx * r1_z_2.xxxx)).xyzx);
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                o.sv_Target3.xyz = (mad(float4(r1_x_5, r1_y_3, r1_w_2, r1_x_5), _EdgeColor.wwww, ((float4(r3_x_13, r3_y_14, r3_z_13, r3_x_13) * float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5))).xyzx)).xyz;
                o.sv_Target0.xyz = (float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5)).xyz;
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
            struct program119Input
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
            struct program119Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program125Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program125Output
            {
                float4 sv_Target0 : SV_Target;
                float4 sv_Target1 : SV_Target1;
                float4 sv_Target2 : SV_Target2;
                float4 sv_Target3 : SV_Target3;
            };
            #pragma vertex vert
            program119Output vert(program119Input i)
            {
                program119Output o = (program119Output)0;
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
            program125Output frag(program125Input i)
            {
                program125Output o = (program125Output)0;
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
                o.sv_Target3.xyz = ((float4(r0_x_6, r0_y_5, r0_w_2, r0_x_6) * _EdgeColor.wwww)).xyz;
                float4 r1_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r0_xyzw_7 = (r1_xyzw_1.xyxz * _Color.xyxz);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_6 = r0_xyzw_7.y;
                float r0_w_3 = r0_xyzw_7.w;
                float4 r0_xyzw_8 = mad(float4(r0_x_7, r0_y_6, r0_w_3, r0_x_7), r0_z_2.xxxx, float4(-0.04, -0.04, -0.04, 0));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_7 = r0_xyzw_8.y;
                float r0_z_3 = r0_xyzw_8.z;
                o.sv_Target1.xyz = (mad(_Metallic.xxxx, float4(r0_x_8, r0_y_7, r0_z_3, r0_x_8), float4(0.04, 0.04, 0.04, 0))).xyz;
                o.sv_Target0.xyz = (((mad(-_Metallic, 0.96, 0.96)).xxxx * ((r0_z_2.xxxx * float4(r0_x_7, r0_y_6, r0_w_3, r0_x_7))).xyzx)).xyz;
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
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb1_values[46];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[7];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[21];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_MainTex;
            SamplerState sampler_DissolveMap;
            Texture2D _MainTex;
            Texture2D _DissolveMap;
            Texture3D t2;
            struct program118Input
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
            struct program118Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
            };
            struct program124Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
            };
            struct program124Output
            {
                float4 sv_Target0 : SV_Target;
                float4 sv_Target1 : SV_Target1;
                float4 sv_Target2 : SV_Target2;
                float4 sv_Target3 : SV_Target3;
            };
            #pragma vertex vert
            program118Output vert(program118Input i)
            {
                program118Output o = (program118Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _DissolveMap_ST.xxxy, _DissolveMap_ST.zzzw)).zw;
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                float3 unitWorldNormal_xyz_8 = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.texcoord1.xyz = unitWorldNormal_xyz_8.xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                float r0_w_9 = (unitWorldNormal_xyz_8.y * unitWorldNormal_xyz_8.y);
                float r0_w_10 = mad(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.x, -r0_w_9);
                float4 r1_xyzw_2 = (unitWorldNormal_xyz_8.yzzx * unitWorldNormal_xyz_8.xyzz);
                float r0_x_9 = dot(cb1_values[42].xyzw, r1_xyzw_2);
                float r0_y_9 = dot(cb1_values[43].xyzw, r1_xyzw_2);
                float r0_z_9 = dot(cb1_values[44].xyzw, r1_xyzw_2);
                o.texcoord5.xyz = (mad(cb1_values[45].xyzx, r0_w_10.xxxx, float4(r0_x_9, r0_y_9, r0_z_9, r0_x_9))).xyz;
                return o;
            }
            #pragma fragment frag
            program124Output frag(program124Input i)
            {
                program124Output o = (program124Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r0_xyz_2 = ((r0_xyzw_1.xyzx * _Color.xyzx)).xyz;
                float4 r1_xyzw_1 = _DissolveMap.Sample(sampler_DissolveMap, (i.texcoord0.zwzz).xy);
                float r0_w_2 = (r1_xyzw_1.x + -_Cutoff);
                float r1_x_3 = (saturate((r0_w_2 * (float4(1, 1, 1, 1) / _EdgeWidth)))).x;
                float r1_y_2 = mad(r1_x_3, -2, 3);
                float r1_x_4 = (r1_x_3 * r1_x_3);
                float r1_z_2 = (r1_x_4 * r1_y_2);
                float r0_w_3 = (r0_w_2 < 0);
                if (r0_w_3) discard;
                float r0_w_4 = mad(-r1_y_2, r1_x_4, 1);
                float4 r1_xyzw_5 = (r0_w_4.xxxx * _EdgeColor.xyxz);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_3 = r1_xyzw_5.y;
                float r1_w_2 = r1_xyzw_5.w;
                float r0_w_5 = (cb2_values[0].x == 1);
                float3 TEXCOORD1_xyz_1;
                float3 r4_xyz_4;
                if (r0_w_5)
                {
                    float r0_w_6 = (cb2_values[0].y == 1);
                    float3 r3_xyz_5 = (((mad(cb2_values[3].xyzx, i.texcoord2.zzzz, (mad(cb2_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb2_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb2_values[4].xyzx)).xyz;
                    float4 r3_xyzw_8 = (((((r0_w_6.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb2_values[6].xyzx)).xxyz * cb2_values[5].xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_7 = (r3_y_8 * 0.25);
                    float r2_w_1 = (cb2_values[0].z * 0.5);
                    float r3_y_9 = mad(-cb2_values[0].z, 0.5, 0.25);
                    float r0_w_8 = max(r0_w_7, r2_w_1);
                    float r3_x_8 = min(r3_y_9, r0_w_8);
                    float4 r4_xyzw_2 = t2.Sample(sampler_linear_clamp, (float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8)).xyz);
                    float4 r5_xyzw_2 = t2.Sample(sampler_linear_clamp, (((float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8) + float4(0.25, 0, 0, 0))).xyzx).xyz);
                    float4 r3_xyzw_9 = (float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8) + float4(0.5, 0, 0, 0));
                    float r3_x_9 = r3_xyzw_9.x;
                    float r3_y_10 = r3_xyzw_9.y;
                    float r3_z_9 = r3_xyzw_9.z;
                    float4 r3_xyzw_10 = t2.Sample(sampler_linear_clamp, (float4(r3_x_9, r3_y_10, r3_z_9, r3_x_9)).xyz);
                    TEXCOORD1_xyz_1 = i.texcoord1.xyz;
                    float r6_w_1 = 1;
                    float r4_x_3 = dot(r4_xyzw_2, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r6_w_1));
                    float r4_y_3 = dot(r5_xyzw_2, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r6_w_1));
                    float r4_z_3 = dot(r3_xyzw_10, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r6_w_1));
                    r4_xyz_4 = float3(r4_x_3, r4_y_3, r4_z_3);
                }
                else
                {
                    TEXCOORD1_xyz_1 = i.texcoord1.xyz;
                    float r3_w_1 = 1;
                    float r4_x_1 = dot(cb1_values[39].xyzw, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r3_w_1));
                    float r4_y_1 = dot(cb1_values[40].xyzw, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r3_w_1));
                    float r4_z_1 = dot(cb1_values[41].xyzw, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r3_w_1));
                    r4_xyz_4 = float3(r4_x_1, r4_y_1, r4_z_1);
                }
                float4 r3_xyzw_12 = (r4_xyz_4.xyzx + i.texcoord5.xyzx);
                float r3_x_12 = r3_xyzw_12.x;
                float r3_y_13 = r3_xyzw_12.y;
                float r3_z_12 = r3_xyzw_12.z;
                float4 r3_xyzw_13 = max(float4(r3_x_12, r3_y_13, r3_z_12, r3_x_12), float4(0, 0, 0, 0));
                float r3_x_13 = r3_xyzw_13.x;
                float r3_y_14 = r3_xyzw_13.y;
                float r3_z_13 = r3_xyzw_13.z;
                o.sv_Target1.xyz = (mad(_Metallic.xxxx, (mad(r0_xyz_2.xyzx, r1_z_2.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float4 r0_xyzw_5 = ((mad(-_Metallic, 0.96, 0.96)).xxxx * ((r0_xyz_2.xyzx * r1_z_2.xxxx)).xyzx);
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float4 r1_xyzw_6 = mad(float4(r1_x_5, r1_y_3, r1_w_2, r1_x_5), _EdgeColor.wwww, ((float4(r3_x_13, r3_y_14, r3_z_13, r3_x_13) * float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5))).xyzx);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                o.sv_Target3.xyz = (exp2(-float4(r1_x_6, r1_y_4, r1_z_3, r1_x_6))).xyz;
                o.sv_Target0.xyz = (float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5)).xyz;
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
            struct program129Input
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
            struct program129Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program132Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program132Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program129Output vert(program129Input i)
            {
                program129Output o = (program129Output)0;
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
                o.sv_Position0.z = mad(unity_LightShadowBias.y, (-r0_xyzw_6.z + min(r0_xyzw_6.w, r0_xyzw_6.z)), r0_xyzw_6.z);
                o.sv_Position0.xyw = (r0_xyzw_6.xyxw).xyw;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _DissolveMap_ST.xyxx, _DissolveMap_ST.zwzz)).xy;
                float3 worldPos_xyz_7 = ((i.position0.yyyy * unity_ObjectToWorld[1].xyzx)).xyz;
                float3 worldPos_xyz_8 = (mad(unity_ObjectToWorld[0].xyzx, i.position0.xxxx, worldPos_xyz_7.xyzx)).xyz;
                float3 worldPos_xyz_9 = (mad(unity_ObjectToWorld[2].xyzx, i.position0.zzzz, worldPos_xyz_8.xyzx)).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyz_9.xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program132Output frag(program132Input i)
            {
                program132Output o = (program132Output)0;
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
