Shader "Corpus/11 Surface Vertex Color"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo", 2D) = "" {}
        _Wave ("Wave", Float) = 0.1
        _VertexColorBoost ("Vertex Color Boost", Range(0, 2)) = 0.5
    }
    SubShader
    {
        Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
        LOD 350
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
                float _Wave : packoffset(c5.x);
                float _VertexColorBoost : packoffset(c5.y);
                float4 _MainTex_ST : packoffset(c6);
            };
            cbuffer _UnityPerCameraCB_b1
            {
                float4 _Time : packoffset(c0);
                float3 _WorldSpaceCameraPos : packoffset(c4);
            };
            cbuffer _UnityPerDrawCB_b2
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_OcclusionMaskSelector : packoffset(c46);
            };
            cbuffer _UnityPerFrameCB_b3
            {
                float4 unity_SpecCube0_BoxMax : packoffset(c0);
                float4 unity_SpecCube0_BoxMin : packoffset(c1);
                float4 unity_SpecCube0_ProbePosition : packoffset(c2);
                float4 unity_SpecCube0_HDR : packoffset(c3);
                float4 unity_SpecCube1_BoxMax : packoffset(c4);
                float4 unity_SpecCube1_BoxMin : packoffset(c5);
                float4 unity_SpecCube1_ProbePosition : packoffset(c6);
                float4 unity_SpecCube1_HDR : packoffset(c7);
                float4x4 unity_MatrixVP : packoffset(c17);
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
            Texture2D _MainTex;
            TextureCube t1;
            TextureCube t2;
            Texture3D t3;
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
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program18Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program18Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program6Output vert(program6Input i)
            {
                program6Output o = (program6Output)0;
                float4 r0_xyzw_3 = ((sin(mad(i.position0.x, 8, _Time.y))).xxxx * i.normal0.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = mad(float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3), _Wave.xxxx, i.position0.xyzx);
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_2 = r0_xyzw_4.y;
                float r0_z_2 = r0_xyzw_4.z;
                float4 r0_xyzw_5 = mad(unity_ObjectToWorld[2], r0_z_2.xxxx, mad(unity_ObjectToWorld[0], r0_x_4.xxxx, (r0_y_2.xxxx * unity_ObjectToWorld[1])));
                float4 r1_xyzw_3 = (r0_xyzw_5 + unity_ObjectToWorld[3]);
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, r0_xyzw_5.xyzx)).xyz;
                float4 r0_xyzw_6 = (r1_xyzw_3.yyyy * unity_MatrixVP[1]);
                float4 r0_xyzw_7 = mad(unity_MatrixVP[0], r1_xyzw_3.xxxx, r0_xyzw_6);
                float4 r0_xyzw_8 = mad(unity_MatrixVP[2], r1_xyzw_3.zzzz, r0_xyzw_7);
                o.sv_Position0.xyzw = mad(unity_MatrixVP[3], r1_xyzw_3.wwww, r0_xyzw_8);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_9 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_5 = dot(float4(worldNormal_x_9, worldNormal_y_7, worldNormal_z_7, worldNormal_x_9), float4(worldNormal_x_9, worldNormal_y_7, worldNormal_z_7, worldNormal_x_9));
                float r0_w_6 = rsqrt(r0_w_5);
                o.texcoord1.xyz = ((r0_w_6.xxxx * float4(worldNormal_x_9, worldNormal_y_7, worldNormal_z_7, worldNormal_x_9))).xyz;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program18Output frag(program18Input i)
            {
                program18Output o = (program18Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_3 = ((((r2_xyzw_1.xyzx * _Color.xyzx)).xyzx * i.color0.xyzx)).xyz;
                float r1_w_1 = (_VertexColorBoost + 1);
                float r2_w_2 = (i.color0.x * 0.5);
                float r3_w_1 = saturate(i.color0.y);
                float r4_x_8;
                float r4_y_11;
                float r4_z_10;
                float r4_w_8;
                if ((unity_ProbeVolumeParams.x == 1))
                {
                    float3 r4_yzw_2 = ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xxyz)).yzw;
                    float3 r4_yzw_3 = (mad(unity_ProbeVolumeWorldToObject[0].xxyz, i.texcoord2.xxxx, r4_yzw_2.xxyz)).yzw;
                    float3 r4_yzw_4 = (mad(unity_ProbeVolumeWorldToObject[2].xxyz, i.texcoord2.zzzz, r4_yzw_3.xxyz)).yzw;
                    float3 r4_yzw_5 = ((r4_yzw_4.xxyz + unity_ProbeVolumeWorldToObject[3].xxyz)).yzw;
                    float4 unity_ProbeVolumeParamsSelect_xyzw_4 = (((unity_ProbeVolumeParams.y == 1)).xxxx ? r4_yzw_5.xyzx : i.texcoord2.xyzx);
                    float unity_ProbeVolumeParamsSelect_x_4 = unity_ProbeVolumeParamsSelect_xyzw_4.x;
                    float unity_ProbeVolumeParamsSelect_y_6 = unity_ProbeVolumeParamsSelect_xyzw_4.y;
                    float unity_ProbeVolumeParamsSelect_z_6 = unity_ProbeVolumeParamsSelect_xyzw_4.z;
                    float4 r4_xyzw_5 = (float4(unity_ProbeVolumeParamsSelect_x_4, unity_ProbeVolumeParamsSelect_y_6, unity_ProbeVolumeParamsSelect_z_6, unity_ProbeVolumeParamsSelect_x_4) + -unity_ProbeVolumeMin.xyzx);
                    float r4_x_5 = r4_xyzw_5.x;
                    float r4_y_7 = r4_xyzw_5.y;
                    float r4_z_7 = r4_xyzw_5.z;
                    float4 r4_xyzw_8 = (float4(r4_x_5, r4_x_5, r4_y_7, r4_z_7) * unity_ProbeVolumeSizeInv.xxyz);
                    float r4_y_8 = r4_xyzw_8.y;
                    float r4_z_8 = r4_xyzw_8.z;
                    float r4_w_6 = r4_xyzw_8.w;
                    float r4_y_9 = mad(r4_y_8, 0.25, 0.75);
                    float r4_x_6 = max(r4_y_9, mad(unity_ProbeVolumeParams.z, 0.5, 0.75));
                    float4 r4_xyzw_7 = t3.Sample(sampler_linear_clamp1, (float4(r4_x_6, r4_z_8, r4_w_6, r4_x_6)).xyz);
                    r4_x_8 = r4_xyzw_7.x;
                    r4_y_11 = r4_xyzw_7.y;
                    r4_z_10 = r4_xyzw_7.z;
                    r4_w_8 = r4_xyzw_7.w;
                }
                else
                {
                    float4 r4_xyzw_2 = float4(1, 1, 1, 1);
                    r4_x_8 = r4_xyzw_2.x;
                    r4_y_11 = r4_xyzw_2.y;
                    r4_z_10 = r4_xyzw_2.z;
                    r4_w_8 = r4_xyzw_2.w;
                }
                float r4_y_12 = (-r3_w_1 + 1);
                float r4_z_11 = dot(-r1_xyz_1.xyzx, i.texcoord1.xyzx);
                float r4_z_12 = (r4_z_11 + r4_z_11);
                float4 r5_xyzw_3 = mad(i.texcoord1.xyzx, -r4_z_12.xxxx, -r1_xyz_1.xyzx);
                float r5_x_3 = r5_xyzw_3.x;
                float r5_y_1 = r5_xyzw_3.y;
                float r5_z_1 = r5_xyzw_3.z;
                float4 r4_xyzw_10 = ((saturate(dot(float4(r4_x_8, r4_y_11, r4_z_10, r4_w_8), unity_OcclusionMaskSelector))).xxxx * _LightColor0.xxyz);
                float r4_x_10 = r4_xyzw_10.x;
                float r4_z_13 = r4_xyzw_10.z;
                float r4_w_9 = r4_xyzw_10.w;
                float r5_w_1 = (0 < unity_SpecCube0_ProbePosition.w);
                float3 r6_xyz_4;
                if (r5_w_1)
                {
                    float r5_w_2 = dot(float4(r5_x_3, r5_y_1, r5_z_1, r5_x_3), float4(r5_x_3, r5_y_1, r5_z_1, r5_x_3));
                    float r5_w_3 = rsqrt(r5_w_2);
                    float3 r6_xyz_2 = ((r5_w_3.xxxx * float4(r5_x_3, r5_y_1, r5_z_1, r5_x_3))).xyz;
                    float3 r9_xyz_1 = ((float4(0, 0, 0, 0) < r6_xyz_2.xyzx)).xyz;
                    float3 r7_xyz_3 = ((r9_xyz_1.xyzx ? ((((-i.texcoord2.xyzx + unity_SpecCube0_BoxMax.xyzx)).xyzx / r6_xyz_2.xyzx)).xyzx : ((((-i.texcoord2.xyzx + unity_SpecCube0_BoxMin.xyzx)).xyzx / r6_xyz_2.xyzx)).xyzx)).xyz;
                    float r5_w_4 = min(r7_xyz_3.y, r7_xyz_3.x);
                    float r5_w_5 = min(r7_xyz_3.z, r5_w_4);
                    r6_xyz_4 = (mad(r6_xyz_2.xyzx, r5_w_5.xxxx, ((i.texcoord2.xyzx + -unity_SpecCube0_ProbePosition.xyzx)).xyzx)).xyz;
                }
                else
                {
                    r6_xyz_4 = (float4(r5_x_3, r5_y_1, r5_z_1, r5_x_3)).xyz;
                }
                float r5_w_7 = mad(-r4_y_12, 0.7, 1.7);
                float r5_w_8 = (r4_y_12 * r5_w_7);
                float r5_w_9 = (r5_w_8 * 6);
                float4 r6_xyzw_5 = t1.SampleLevel(sampler_linear_clamp, r6_xyz_4.xyz, r5_w_9);
                float r6_w_2 = (r6_xyzw_5.w + -1);
                float r6_w_3 = mad(unity_SpecCube0_HDR.w, r6_w_2, 1);
                float r6_w_4 = log2(r6_w_3);
                float r6_w_5 = (r6_w_4 * unity_SpecCube0_HDR.y);
                float r6_w_6 = exp2(r6_w_5);
                float r6_w_7 = (r6_w_6 * unity_SpecCube0_HDR.x);
                float r7_w_1 = (unity_SpecCube0_BoxMin.w < 0.99999);
                float3 r7_xyz_8 = ((r6_xyzw_5.xyzx * r6_w_7.xxxx)).xyz;
                if (r7_w_1)
                {
                    float r7_w_2 = (0 < unity_SpecCube1_ProbePosition.w);
                    float r5_x_5 = r5_x_3;
                    float r5_y_3 = r5_y_1;
                    float r5_z_3 = r5_z_1;
                    if (r7_w_2)
                    {
                        float r7_w_3 = dot(float4(r5_x_3, r5_y_1, r5_z_1, r5_x_3), float4(r5_x_3, r5_y_1, r5_z_1, r5_x_3));
                        float r7_w_4 = rsqrt(r7_w_3);
                        float3 r8_xyz_4 = ((float4(r5_x_3, r5_y_1, r5_z_1, r5_x_3) * r7_w_4.xxxx)).xyz;
                        float3 r11_xyz_1 = ((float4(0, 0, 0, 0) < r8_xyz_4.xyzx)).xyz;
                        float3 r9_xyz_5 = ((r11_xyz_1.xyzx ? ((((-i.texcoord2.xyzx + unity_SpecCube1_BoxMax.xyzx)).xyzx / r8_xyz_4.xyzx)).xyzx : ((((-i.texcoord2.xyzx + unity_SpecCube1_BoxMin.xyzx)).xyzx / r8_xyz_4.xyzx)).xyzx)).xyz;
                        float r7_w_5 = min(r9_xyz_5.y, r9_xyz_5.x);
                        float r7_w_6 = min(r9_xyz_5.z, r7_w_5);
                        float4 r5_xyzw_4 = mad(r8_xyz_4.xyzx, r7_w_6.xxxx, ((i.texcoord2.xyzx + -unity_SpecCube1_ProbePosition.xyzx)).xyzx);
                        float r5_x_4 = r5_xyzw_4.x;
                        float r5_y_2 = r5_xyzw_4.y;
                        float r5_z_2 = r5_xyzw_4.z;
                        r5_x_5 = r5_x_4;
                        r5_y_3 = r5_y_2;
                        r5_z_3 = r5_z_2;
                    }
                    float4 r5_xyzw_6 = t2.SampleLevel(sampler_linear_clamp, (float4(r5_x_5, r5_y_3, r5_z_3, r5_x_5)).xyz, r5_w_9);
                    float r5_w_11 = (r5_xyzw_6.w + -1);
                    float r5_w_12 = mad(unity_SpecCube1_HDR.w, r5_w_11, 1);
                    float r5_w_13 = log2(r5_w_12);
                    float r5_w_14 = (r5_w_13 * unity_SpecCube1_HDR.y);
                    float r5_w_15 = exp2(r5_w_14);
                    float r5_w_16 = (r5_w_15 * unity_SpecCube1_HDR.x);
                    float4 r5_xyzw_7 = (r5_xyzw_6.xyzx * r5_w_16.xxxx);
                    float r5_x_7 = r5_xyzw_7.x;
                    float r5_y_5 = r5_xyzw_7.y;
                    float r5_z_5 = r5_xyzw_7.z;
                    r7_xyz_8 = (mad(unity_SpecCube0_BoxMin.wwww, (mad(r6_w_7.xxxx, r6_xyzw_5.xyzx, -float4(r5_x_7, r5_y_5, r5_z_5, r5_x_7))).xyzx, float4(r5_x_7, r5_y_5, r5_z_5, r5_x_7))).xyz;
                }
                float4 unitWorldNormal_xyzw_11 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_11 = unitWorldNormal_xyzw_11.x;
                float unitWorldNormal_y_7 = unitWorldNormal_xyzw_11.y;
                float unitWorldNormal_z_7 = unitWorldNormal_xyzw_11.z;
                float3 r2_xyz_5 = (mad(r2_w_2.xxxx, (mad(r2_xyz_3.xyzx, r1_w_1.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_2 = mad(-i.color0.x, 0.48, 0.96);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unity_ObjectToWorld[0].xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(unitWorldNormal_x_11, unitWorldNormal_y_7, unitWorldNormal_z_7, unitWorldNormal_x_11), r1_xyz_1.xyzx);
                float r1_x_2 = saturate(dot(float4(unitWorldNormal_x_11, unitWorldNormal_y_7, unitWorldNormal_z_7, unitWorldNormal_x_11), unity_ObjectToWorld[0].xyzx));
                float r1_y_2 = saturate(dot(float4(unitWorldNormal_x_11, unitWorldNormal_y_7, unitWorldNormal_z_7, unitWorldNormal_x_11), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(unity_ObjectToWorld[0].xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r4_y_12.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(r0_w_6) + 1);
                float r2_w_3 = (r1_z_4 * r1_z_4);
                float r2_w_4 = (r2_w_3 * r2_w_3);
                float r1_z_5 = (r1_z_4 * r2_w_4);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r4_y_12 * r4_y_12);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r2_w_5 = (-r0_z_8 + 1);
                float r4_y_13 = mad(abs(r0_w_6), r2_w_5, r0_z_8);
                float r2_w_6 = mad(r1_x_2, r2_w_5, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * r2_w_6);
                float r0_w_8 = mad(r1_x_2, r4_y_13, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r2_w_7 = (r0_z_8 * r0_z_8);
                float r4_y_14 = mad(r1_y_2, r2_w_7, -r1_y_2);
                float r1_y_3 = mad(r4_y_14, r1_y_2, 1);
                float r2_w_8 = (r2_w_7 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r1_y_5 = (r2_w_8 / r1_y_4);
                float r0_w_11 = (r0_w_10 * r1_y_5);
                float r0_w_12 = (r0_w_11 * 3.1415927);
                float4 r0_xyzw_9 = (r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_y_8, r0_w_12));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_w_13 = r0_xyzw_9.w;
                float r0_z_9 = mad(r0_z_8, r0_z_8, 1);
                float r0_z_10 = ((float4(1, 1, 1, 1) / r0_z_9)).z;
                float r0_w_14 = (r0_w_13 * asfloat(asint((float)((dot(r2_xyz_5.xyzx, r2_xyz_5.xyzx) != 0))) & asint(1065353216)));
                float4 r5_xyzw_12 = (r0_y_9.xxxx * float4(r4_x_10, r4_z_13, r4_w_9, r4_x_10));
                float r5_x_12 = r5_xyzw_12.x;
                float r5_y_8 = r5_xyzw_12.y;
                float r5_z_8 = r5_xyzw_12.z;
                float4 r4_xyzw_11 = (float4(r4_x_10, r4_z_13, r4_w_9, r4_x_10) * r0_w_14.xxxx);
                float r4_x_11 = r4_xyzw_11.x;
                float r4_y_15 = r4_xyzw_11.y;
                float r4_z_14 = r4_xyzw_11.z;
                float r0_x_5 = (-r0_x_4 + 1);
                float r0_y_10 = (r0_x_5 * r0_x_5);
                float r0_y_11 = (r0_y_10 * r0_y_10);
                float4 r0_xyzw_7 = mad(((-r2_xyz_5.xyzx + float4(1, 1, 1, 0))).xyxz, ((r0_x_5 * r0_y_11)).xxxx, r2_xyz_5.xyxz);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_12 = r0_xyzw_7.y;
                float r0_w_15 = r0_xyzw_7.w;
                float4 r0_xyzw_8 = (float4(r0_x_7, r0_y_12, r0_x_7, r0_w_15) * float4(r4_x_11, r4_y_15, r4_x_11, r4_z_14));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_13 = r0_xyzw_8.y;
                float r0_w_16 = r0_xyzw_8.w;
                float r0_x_9 = (mad(((r1_w_2.xxxx * ((r1_w_1.xxxx * r2_xyz_3.xyzx)).xyzx)).xyxz, float4(r5_x_12, r5_y_8, r5_x_12, r5_z_8), float4(r0_x_8, r0_y_13, r0_x_8, r0_w_16))).x;
                float4 r0_xyzw_14 = mad(((r1_w_2.xxxx * ((r1_w_1.xxxx * r2_xyz_3.xyzx)).xyzx)).xyxz, float4(r5_x_12, r5_y_8, r5_x_12, r5_z_8), float4(r0_x_8, r0_y_13, r0_x_8, r0_w_16));
                float r0_y_14 = r0_xyzw_14.y;
                float r0_w_17 = r0_xyzw_14.w;
                float4 r1_xyzw_8 = (-r2_xyz_5.xyxz + (saturate(((-r1_w_2 + r3_w_1) + 1))).xxxx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_w_3 = r1_xyzw_8.w;
                float4 r1_xyzw_9 = mad(r1_z_5.xxxx, float4(r1_x_8, r1_y_6, r1_w_3, r1_x_8), r2_xyz_5.xyzx);
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_7 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r0_xyzw_10 = mad(((r7_xyz_8.xyzx * r0_z_10.xxxx)).xyzx, float4(r1_x_9, r1_y_7, r1_z_6, r1_x_9), float4(r0_x_9, r0_y_14, r0_w_17, r0_x_9));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_15 = r0_xyzw_10.y;
                float r0_z_11 = r0_xyzw_10.z;
                float4 r1_xyzw_10 = mad(float4(r0_x_10, r0_y_15, r0_z_11, r0_x_10), i.color0.xyzx, -float4(r0_x_10, r0_y_15, r0_z_11, r0_x_10));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_8 = r1_xyzw_10.y;
                float r1_z_7 = r1_xyzw_10.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_10, r1_y_8, r1_z_7, r1_x_10), float4(0.25, 0.25, 0.25, 0), float4(r0_x_10, r0_y_15, r0_z_11, r0_x_10))).xyz;
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
                float _Wave : packoffset(c5.x);
                float _VertexColorBoost : packoffset(c5.y);
                float4 _MainTex_ST : packoffset(c6);
            };
            cbuffer _UnityPerCameraCB_b1
            {
                float4 _Time;
                float3 _WorldSpaceCameraPos;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerDrawCB_b2
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[46];
            };
            cbuffer _UnityPerFrameCB_b3
            {
                float4 unity_SpecCube0_BoxMax;
                float4 unity_SpecCube0_BoxMin;
                float4 unity_SpecCube0_ProbePosition;
                float4 unity_SpecCube0_HDR;
                float4 unity_SpecCube1_BoxMax;
                float4 unity_SpecCube1_BoxMin;
                float4 unity_SpecCube1_ProbePosition;
                float4 unity_SpecCube1_HDR;
                float4x4 unity_MatrixVP;
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
            Texture2D _MainTex;
            Texture2D t1;
            TextureCube t2;
            TextureCube t3;
            Texture3D t4;
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
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program21Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program21Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program9Output vert(program9Input i)
            {
                program9Output o = (program9Output)0;
                float4 r0_xyzw_3 = ((sin(mad(i.position0.x, 8, _Time.y))).xxxx * i.normal0.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = mad(float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3), _Wave.xxxx, i.position0.xyzx);
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_2 = r0_xyzw_4.y;
                float r0_z_2 = r0_xyzw_4.z;
                float4 r0_xyzw_5 = mad(cb3_values[2].xyzw, r0_z_2.xxxx, mad(cb3_values[0].xyzw, r0_x_4.xxxx, (r0_y_2.xxxx * cb3_values[1].xyzw)));
                float4 r1_xyzw_3 = (r0_xyzw_5 + cb3_values[3].xyzw);
                o.texcoord2.xyz = (mad(cb3_values[3].xyzx, i.position0.wwww, r0_xyzw_5.xyzx)).xyz;
                float4 r0_xyzw_6 = (r1_xyzw_3.yyyy * cb4_values[18].xyzw);
                float4 r0_xyzw_7 = mad(cb4_values[17].xyzw, r1_xyzw_3.xxxx, r0_xyzw_6);
                float4 r0_xyzw_8 = mad(cb4_values[19].xyzw, r1_xyzw_3.zzzz, r0_xyzw_7);
                float4 r0_xyzw_9 = mad(cb4_values[20].xyzw, r1_xyzw_3.wwww, r0_xyzw_8);
                o.sv_Position0.xyzw = r0_xyzw_9;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_4 = dot(i.normal0.xyzx, cb3_values[4].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, cb3_values[5].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, cb3_values[6].xyzx);
                float r1_w_4 = dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4));
                float r1_w_5 = rsqrt(r1_w_4);
                float3 unitWorldNormal_xyz_5 = ((r1_w_5.xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4))).xyz;
                o.texcoord1.xyz = unitWorldNormal_xyz_5.xyz;
                o.color0.xyzw = i.color0.xyzw;
                float r1_w_6 = (unitWorldNormal_xyz_5.y * unitWorldNormal_xyz_5.y);
                float r1_w_7 = mad(unitWorldNormal_xyz_5.x, unitWorldNormal_xyz_5.x, -r1_w_6);
                float4 r2_xyzw_1 = (unitWorldNormal_xyz_5.yzzx * unitWorldNormal_xyz_5.xyzz);
                float r1_x_6 = dot(cb2_values[42].xyzw, r2_xyzw_1);
                float r1_y_6 = dot(cb2_values[43].xyzw, r2_xyzw_1);
                float r1_z_6 = dot(cb2_values[44].xyzw, r2_xyzw_1);
                o.texcoord3.xyz = (mad(cb2_values[45].xyzx, r1_w_7.xxxx, float4(r1_x_6, r1_y_6, r1_z_6, r1_x_6))).xyz;
                float r0_y_8 = (r0_xyzw_9.y * cb1_values[5].x);
                float4 r1_xyzw_7 = (float4(r0_xyzw_9.x, r0_xyzw_9.x, r0_xyzw_9.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_z_7 = r1_xyzw_7.z;
                float r1_w_8 = r1_xyzw_7.w;
                o.texcoord4.zw = (r0_xyzw_9.zzzw).zw;
                o.texcoord4.xy = ((r1_z_7.xxxx + float4(r1_x_7, r1_w_8, r1_x_7, r1_x_7))).xy;
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program21Output frag(program21Input i)
            {
                program21Output o = (program21Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_3 = ((((r2_xyzw_1.xyzx * _Color.xyzx)).xyzx * i.color0.xyzx)).xyz;
                float r1_w_1 = (_VertexColorBoost + 1);
                float r2_w_2 = (i.color0.x * 0.5);
                float r3_w_1 = saturate(i.color0.y);
                float r4_x_1 = cb4_values[9].z;
                float r4_y_1 = cb4_values[10].z;
                float r4_z_1 = cb4_values[11].z;
                float r4_x_2 = dot(r0_xyz_1.xyzx, float4(r4_x_1, r4_y_1, r4_z_1, r4_x_1));
                float4 r4_xyzw_2 = (i.texcoord2.xxyz + -cb3_values[25].xxyz);
                float r4_y_2 = r4_xyzw_2.y;
                float r4_z_2 = r4_xyzw_2.z;
                float r4_w_1 = r4_xyzw_2.w;
                float r4_y_3 = dot(float4(r4_y_2, r4_z_2, r4_w_1, r4_y_2), float4(r4_y_2, r4_z_2, r4_w_1, r4_y_2));
                float r4_y_4 = sqrt(r4_y_3);
                float r4_y_5 = (-r4_x_2 + r4_y_4);
                float r4_y_6 = (cb6_values[0].x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r4_y_6)
                {
                    float r4_z_3 = (cb6_values[0].y == 1);
                    float3 r5_xyz_5 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r5_xyzw_8 = (((((r4_z_3.xxxx ? r5_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r4_z_4 = mad(r5_y_8, 0.25, 0.75);
                    float r4_w_2 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r5_x_8 = max(r4_w_2, r4_z_4);
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
                float r4_z_6 = saturate(dot(float4(r5_x_10, r5_y_10, r5_z_10, r5_w_4), unity_OcclusionMaskSelector));
                float4 r5_xyzw_12 = t1.Sample(sampler_linear_clamp2, (((i.texcoord4.xyxx / i.texcoord4.wwww)).xyxx).xy);
                float r4_z_7 = (r4_z_6 + -r5_xyzw_12.x);
                float r4_z_8 = (-r3_w_1 + 1);
                float r4_w_4 = dot(-r1_xyz_1.xyzx, i.texcoord1.xyzx);
                float r4_w_5 = (r4_w_4 + r4_w_4);
                float4 r5_xyzw_13 = mad(i.texcoord1.xyzx, -r4_w_5.xxxx, -r1_xyz_1.xyzx);
                float r5_x_13 = r5_xyzw_13.x;
                float r5_y_13 = r5_xyzw_13.y;
                float r5_z_12 = r5_xyzw_13.z;
                float3 r6_xyz_1 = (((mad(saturate(mad(mad(cb3_values[25].w, r4_y_5, r4_x_2), cb3_values[24].z, cb3_values[24].w)), r4_z_7, r5_xyzw_12.x)).xxxx * _LightColor0.xyzx)).xyz;
                float3 TEXCOORD1_xyz_1;
                float3 r8_xyz_4;
                if ((r4_y_6 != 0))
                {
                    float3 r7_xyz_5 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r4_xyzw_7 = (((cb6_values[0].y == 1)).xxxx ? r7_xyz_5.xyxz : i.texcoord2.xyxz);
                    float r4_x_7 = r4_xyzw_7.x;
                    float r4_y_7 = r4_xyzw_7.y;
                    float r4_w_6 = r4_xyzw_7.w;
                    float4 r4_xyzw_8 = (float4(r4_x_7, r4_y_7, r4_x_7, r4_w_6) + -cb6_values[6].xyxz);
                    float r4_x_8 = r4_xyzw_8.x;
                    float r4_y_8 = r4_xyzw_8.y;
                    float r4_w_7 = r4_xyzw_8.w;
                    float4 r7_xyzw_6 = (float4(r4_x_8, r4_x_8, r4_y_8, r4_w_7) * cb6_values[5].xxyz);
                    float r7_y_6 = r7_xyzw_6.y;
                    float r7_z_6 = r7_xyzw_6.z;
                    float r7_w_2 = r7_xyzw_6.w;
                    float r4_y_9 = (cb6_values[0].z * 0.5);
                    float r4_w_8 = mad(-cb6_values[0].z, 0.5, 0.25);
                    float r7_x_6 = min(r4_w_8, max(r4_y_9, (r7_y_6 * 0.25)));
                    float4 r8_xyzw_2 = t4.Sample(sampler_linear_clamp1, (float4(r7_x_6, r7_z_6, r7_w_2, r7_x_6)).xyz);
                    float4 r4_xyzw_11 = (float4(r7_x_6, r7_z_6, r7_x_6, r7_w_2) + float4(0.25, 0, 0, 0));
                    float r4_x_11 = r4_xyzw_11.x;
                    float r4_y_10 = r4_xyzw_11.y;
                    float r4_w_9 = r4_xyzw_11.w;
                    float4 r9_xyzw_1 = t4.Sample(sampler_linear_clamp1, (float4(r4_x_11, r4_y_10, r4_w_9, r4_x_11)).xyz);
                    float4 r4_xyzw_12 = (float4(r7_x_6, r7_z_6, r7_x_6, r7_w_2) + float4(0.5, 0, 0, 0));
                    float r4_x_12 = r4_xyzw_12.x;
                    float r4_y_11 = r4_xyzw_12.y;
                    float r4_w_10 = r4_xyzw_12.w;
                    float4 r7_xyzw_7 = t4.Sample(sampler_linear_clamp1, (float4(r4_x_12, r4_y_11, r4_w_10, r4_x_12)).xyz);
                    TEXCOORD1_xyz_1 = i.texcoord1.xyz;
                    float r10_w_1 = 1;
                    float r8_x_3 = dot(r8_xyzw_2, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r10_w_1));
                    float r8_y_3 = dot(r9_xyzw_1, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r10_w_1));
                    float r8_z_3 = dot(r7_xyzw_7, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r10_w_1));
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
                float4 r4_xyzw_14 = (r8_xyz_4.xyxz + i.texcoord3.xyxz);
                float r4_x_14 = r4_xyzw_14.x;
                float r4_y_13 = r4_xyzw_14.y;
                float r4_w_12 = r4_xyzw_14.w;
                float4 r4_xyzw_15 = max(float4(r4_x_14, r4_y_13, r4_x_14, r4_w_12), float4(0, 0, 0, 0));
                float r4_x_15 = r4_xyzw_15.x;
                float r4_y_14 = r4_xyzw_15.y;
                float r4_w_13 = r4_xyzw_15.w;
                float r5_w_6 = (0 < cb5_values[2].w);
                float3 r7_xyz_12;
                if (r5_w_6)
                {
                    float r5_w_7 = dot(float4(r5_x_13, r5_y_13, r5_z_12, r5_x_13), float4(r5_x_13, r5_y_13, r5_z_12, r5_x_13));
                    float r5_w_8 = rsqrt(r5_w_7);
                    float3 r7_xyz_10 = ((r5_w_8.xxxx * float4(r5_x_13, r5_y_13, r5_z_12, r5_x_13))).xyz;
                    float3 r10_xyz_3 = ((float4(0, 0, 0, 0) < r7_xyz_10.xyzx)).xyz;
                    float3 r8_xyz_7 = ((r10_xyz_3.xyzx ? ((((-i.texcoord2.xyzx + cb5_values[0].xyzx)).xyzx / r7_xyz_10.xyzx)).xyzx : ((((-i.texcoord2.xyzx + cb5_values[1].xyzx)).xyzx / r7_xyz_10.xyzx)).xyzx)).xyz;
                    float r5_w_9 = min(r8_xyz_7.y, r8_xyz_7.x);
                    float r5_w_10 = min(r8_xyz_7.z, r5_w_9);
                    r7_xyz_12 = (mad(r7_xyz_10.xyzx, r5_w_10.xxxx, ((i.texcoord2.xyzx + -cb5_values[2].xyzx)).xyzx)).xyz;
                }
                else
                {
                    r7_xyz_12 = (float4(r5_x_13, r5_y_13, r5_z_12, r5_x_13)).xyz;
                }
                float r5_w_12 = mad(-r4_z_8, 0.7, 1.7);
                float r5_w_13 = (r4_z_8 * r5_w_12);
                float r5_w_14 = (r5_w_13 * 6);
                float4 r7_xyzw_13 = t2.SampleLevel(sampler_linear_clamp, r7_xyz_12.xyz, r5_w_14);
                float r6_w_1 = (r7_xyzw_13.w + -1);
                float r6_w_2 = mad(cb5_values[3].w, r6_w_1, 1);
                float r6_w_3 = log2(r6_w_2);
                float r6_w_4 = (r6_w_3 * cb5_values[3].y);
                float r6_w_5 = exp2(r6_w_4);
                float r6_w_6 = (r6_w_5 * cb5_values[3].x);
                float r7_w_6 = (cb5_values[1].w < 0.99999);
                float3 r8_xyz_12 = ((r7_xyzw_13.xyzx * r6_w_6.xxxx)).xyz;
                if (r7_w_6)
                {
                    float r7_w_7 = (0 < cb5_values[6].w);
                    float r5_x_15 = r5_x_13;
                    float r5_y_15 = r5_y_13;
                    float r5_z_14 = r5_z_12;
                    if (r7_w_7)
                    {
                        float r7_w_8 = dot(float4(r5_x_13, r5_y_13, r5_z_12, r5_x_13), float4(r5_x_13, r5_y_13, r5_z_12, r5_x_13));
                        float r7_w_9 = rsqrt(r7_w_8);
                        float3 r9_xyz_6 = ((float4(r5_x_13, r5_y_13, r5_z_12, r5_x_13) * r7_w_9.xxxx)).xyz;
                        float3 r12_xyz_1 = ((float4(0, 0, 0, 0) < r9_xyz_6.xyzx)).xyz;
                        float3 r10_xyz_7 = ((r12_xyz_1.xyzx ? ((((-i.texcoord2.xyzx + cb5_values[4].xyzx)).xyzx / r9_xyz_6.xyzx)).xyzx : ((((-i.texcoord2.xyzx + cb5_values[5].xyzx)).xyzx / r9_xyz_6.xyzx)).xyzx)).xyz;
                        float r7_w_10 = min(r10_xyz_7.y, r10_xyz_7.x);
                        float r7_w_11 = min(r10_xyz_7.z, r7_w_10);
                        float4 r5_xyzw_14 = mad(r9_xyz_6.xyzx, r7_w_11.xxxx, ((i.texcoord2.xyzx + -cb5_values[6].xyzx)).xyzx);
                        float r5_x_14 = r5_xyzw_14.x;
                        float r5_y_14 = r5_xyzw_14.y;
                        float r5_z_13 = r5_xyzw_14.z;
                        r5_x_15 = r5_x_14;
                        r5_y_15 = r5_y_14;
                        r5_z_14 = r5_z_13;
                    }
                    float4 r5_xyzw_16 = t3.SampleLevel(sampler_linear_clamp, (float4(r5_x_15, r5_y_15, r5_z_14, r5_x_15)).xyz, r5_w_14);
                    float r5_w_16 = (r5_xyzw_16.w + -1);
                    float r5_w_17 = mad(cb5_values[7].w, r5_w_16, 1);
                    float r5_w_18 = log2(r5_w_17);
                    float r5_w_19 = (r5_w_18 * cb5_values[7].y);
                    float r5_w_20 = exp2(r5_w_19);
                    float r5_w_21 = (r5_w_20 * cb5_values[7].x);
                    float4 r5_xyzw_17 = (r5_xyzw_16.xyzx * r5_w_21.xxxx);
                    float r5_x_17 = r5_xyzw_17.x;
                    float r5_y_17 = r5_xyzw_17.y;
                    float r5_z_16 = r5_xyzw_17.z;
                    r8_xyz_12 = (mad(cb5_values[1].wwww, (mad(r6_w_6.xxxx, r7_xyzw_13.xyzx, -float4(r5_x_17, r5_y_17, r5_z_16, r5_x_17))).xyzx, float4(r5_x_17, r5_y_17, r5_z_16, r5_x_17))).xyz;
                }
                float4 unitWorldNormal_xyzw_21 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_21 = unitWorldNormal_xyzw_21.x;
                float unitWorldNormal_y_19 = unitWorldNormal_xyzw_21.y;
                float unitWorldNormal_z_18 = unitWorldNormal_xyzw_21.z;
                float3 r2_xyz_5 = (mad(r2_w_2.xxxx, (mad(r2_xyz_3.xyzx, r1_w_1.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_2 = mad(-i.color0.x, 0.48, 0.96);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unity_ObjectToWorld[0].xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(unitWorldNormal_x_21, unitWorldNormal_y_19, unitWorldNormal_z_18, unitWorldNormal_x_21), r1_xyz_1.xyzx);
                float r1_x_2 = saturate(dot(float4(unitWorldNormal_x_21, unitWorldNormal_y_19, unitWorldNormal_z_18, unitWorldNormal_x_21), unity_ObjectToWorld[0].xyzx));
                float r1_y_2 = saturate(dot(float4(unitWorldNormal_x_21, unitWorldNormal_y_19, unitWorldNormal_z_18, unitWorldNormal_x_21), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(unity_ObjectToWorld[0].xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r4_z_8.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(r0_w_6) + 1);
                float r2_w_3 = (r1_z_4 * r1_z_4);
                float r2_w_4 = (r2_w_3 * r2_w_3);
                float r1_z_5 = (r1_z_4 * r2_w_4);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r4_z_8 * r4_z_8);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r2_w_5 = (-r0_z_8 + 1);
                float r4_z_9 = mad(abs(r0_w_6), r2_w_5, r0_z_8);
                float r2_w_6 = mad(r1_x_2, r2_w_5, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * r2_w_6);
                float r0_w_8 = mad(r1_x_2, r4_z_9, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r2_w_7 = (r0_z_8 * r0_z_8);
                float r4_z_10 = mad(r1_y_2, r2_w_7, -r1_y_2);
                float r1_y_3 = mad(r4_z_10, r1_y_2, 1);
                float r2_w_8 = (r2_w_7 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r1_y_5 = (r2_w_8 / r1_y_4);
                float r0_w_11 = (r0_w_10 * r1_y_5);
                float r0_w_12 = (r0_w_11 * 3.1415927);
                float4 r0_xyzw_9 = (r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_y_8, r0_w_12));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_w_13 = r0_xyzw_9.w;
                float r0_z_9 = mad(r0_z_8, r0_z_8, 1);
                float r0_z_10 = ((float4(1, 1, 1, 1) / r0_z_9)).z;
                float r0_w_14 = (r0_w_13 * asfloat(asint((float)((dot(r2_xyz_5.xyzx, r2_xyz_5.xyzx) != 0))) & asint(1065353216)));
                float4 r4_xyzw_16 = mad(r6_xyz_1.xyzx, r0_y_9.xxxx, float4(r4_x_15, r4_y_14, r4_w_13, r4_x_15));
                float r4_x_16 = r4_xyzw_16.x;
                float r4_y_15 = r4_xyzw_16.y;
                float r4_z_11 = r4_xyzw_16.z;
                float4 r5_xyzw_22 = (r6_xyz_1.xyzx * r0_w_14.xxxx);
                float r5_x_22 = r5_xyzw_22.x;
                float r5_y_20 = r5_xyzw_22.y;
                float r5_z_19 = r5_xyzw_22.z;
                float r0_x_5 = (-r0_x_4 + 1);
                float r0_y_10 = (r0_x_5 * r0_x_5);
                float r0_y_11 = (r0_y_10 * r0_y_10);
                float4 r0_xyzw_7 = mad(((-r2_xyz_5.xyzx + float4(1, 1, 1, 0))).xyxz, ((r0_x_5 * r0_y_11)).xxxx, r2_xyz_5.xyxz);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_12 = r0_xyzw_7.y;
                float r0_w_15 = r0_xyzw_7.w;
                float4 r0_xyzw_8 = (float4(r0_x_7, r0_y_12, r0_x_7, r0_w_15) * float4(r5_x_22, r5_y_20, r5_x_22, r5_z_19));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_13 = r0_xyzw_8.y;
                float r0_w_16 = r0_xyzw_8.w;
                float r0_x_9 = (mad(((r1_w_2.xxxx * ((r1_w_1.xxxx * r2_xyz_3.xyzx)).xyzx)).xyxz, float4(r4_x_16, r4_y_15, r4_x_16, r4_z_11), float4(r0_x_8, r0_y_13, r0_x_8, r0_w_16))).x;
                float4 r0_xyzw_14 = mad(((r1_w_2.xxxx * ((r1_w_1.xxxx * r2_xyz_3.xyzx)).xyzx)).xyxz, float4(r4_x_16, r4_y_15, r4_x_16, r4_z_11), float4(r0_x_8, r0_y_13, r0_x_8, r0_w_16));
                float r0_y_14 = r0_xyzw_14.y;
                float r0_w_17 = r0_xyzw_14.w;
                float4 r1_xyzw_8 = (-r2_xyz_5.xyxz + (saturate(((-r1_w_2 + r3_w_1) + 1))).xxxx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_w_3 = r1_xyzw_8.w;
                float4 r1_xyzw_9 = mad(r1_z_5.xxxx, float4(r1_x_8, r1_y_6, r1_w_3, r1_x_8), r2_xyz_5.xyzx);
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_7 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r0_xyzw_10 = mad(((r8_xyz_12.xyzx * r0_z_10.xxxx)).xyzx, float4(r1_x_9, r1_y_7, r1_z_6, r1_x_9), float4(r0_x_9, r0_y_14, r0_w_17, r0_x_9));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_15 = r0_xyzw_10.y;
                float r0_z_11 = r0_xyzw_10.z;
                float4 r1_xyzw_10 = mad(float4(r0_x_10, r0_y_15, r0_z_11, r0_x_10), i.color0.xyzx, -float4(r0_x_10, r0_y_15, r0_z_11, r0_x_10));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_8 = r1_xyzw_10.y;
                float r1_z_7 = r1_xyzw_10.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_10, r1_y_8, r1_z_7, r1_x_10), float4(0.25, 0.25, 0.25, 0), float4(r0_x_10, r0_y_15, r0_z_11, r0_x_10))).xyz;
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
                float _Wave : packoffset(c5.x);
                float _VertexColorBoost : packoffset(c5.y);
                float4 _MainTex_ST : packoffset(c6);
            };
            cbuffer _UnityPerCameraCB_b1
            {
                float4 _Time;
                float3 _WorldSpaceCameraPos;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerDrawCB_b2
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_OcclusionMaskSelector : packoffset(c46);
            };
            cbuffer _UnityPerFrameCB_b3
            {
                float4 unity_SpecCube0_BoxMax;
                float4 unity_SpecCube0_BoxMin;
                float4 unity_SpecCube0_ProbePosition;
                float4 unity_SpecCube0_HDR;
                float4 unity_SpecCube1_BoxMax;
                float4 unity_SpecCube1_BoxMin;
                float4 unity_SpecCube1_ProbePosition;
                float4 unity_SpecCube1_HDR;
                float4x4 unity_MatrixVP;
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
            Texture2D _MainTex;
            Texture2D t1;
            TextureCube t2;
            TextureCube t3;
            Texture3D t4;
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
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program20Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program20Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program8Output vert(program8Input i)
            {
                program8Output o = (program8Output)0;
                float4 r0_xyzw_3 = ((sin(mad(i.position0.x, 8, _Time.y))).xxxx * i.normal0.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = mad(float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3), _Wave.xxxx, i.position0.xyzx);
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_2 = r0_xyzw_4.y;
                float r0_z_2 = r0_xyzw_4.z;
                float4 r0_xyzw_5 = mad(unity_ObjectToWorld[2], r0_z_2.xxxx, mad(unity_ObjectToWorld[0], r0_x_4.xxxx, (r0_y_2.xxxx * unity_ObjectToWorld[1])));
                float4 r1_xyzw_3 = (r0_xyzw_5 + unity_ObjectToWorld[3]);
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, r0_xyzw_5.xyzx)).xyz;
                float4 r0_xyzw_6 = (r1_xyzw_3.yyyy * unity_MatrixVP[1]);
                float4 r0_xyzw_7 = mad(unity_MatrixVP[0], r1_xyzw_3.xxxx, r0_xyzw_6);
                float4 r0_xyzw_8 = mad(unity_MatrixVP[2], r1_xyzw_3.zzzz, r0_xyzw_7);
                float4 r0_xyzw_9 = mad(unity_MatrixVP[3], r1_xyzw_3.wwww, r0_xyzw_8);
                o.sv_Position0.xyzw = r0_xyzw_9;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_4 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_4 = dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4));
                float r1_w_5 = rsqrt(r1_w_4);
                o.texcoord1.xyz = ((r1_w_5.xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4))).xyz;
                o.color0.xyzw = i.color0.xyzw;
                float r0_y_8 = (r0_xyzw_9.y * cb1_values[5].x);
                float4 r1_xyzw_5 = (float4(r0_xyzw_9.x, r0_xyzw_9.x, r0_xyzw_9.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_5 = r1_xyzw_5.x;
                float r1_z_5 = r1_xyzw_5.z;
                float r1_w_6 = r1_xyzw_5.w;
                o.texcoord4.zw = (r0_xyzw_9.zzzw).zw;
                o.texcoord4.xy = ((r1_z_5.xxxx + float4(r1_x_5, r1_w_6, r1_x_5, r1_x_5))).xy;
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program20Output frag(program20Input i)
            {
                program20Output o = (program20Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_3 = ((((r2_xyzw_1.xyzx * _Color.xyzx)).xyzx * i.color0.xyzx)).xyz;
                float r1_w_1 = (_VertexColorBoost + 1);
                float r2_w_2 = (i.color0.x * 0.5);
                float r3_w_1 = saturate(i.color0.y);
                float r4_x_1 = cb4_values[9].z;
                float r4_y_1 = cb4_values[10].z;
                float r4_z_1 = cb4_values[11].z;
                float r4_x_2 = dot(r0_xyz_1.xyzx, float4(r4_x_1, r4_y_1, r4_z_1, r4_x_1));
                float4 r4_xyzw_2 = (i.texcoord2.xxyz + -cb3_values[25].xxyz);
                float r4_y_2 = r4_xyzw_2.y;
                float r4_z_2 = r4_xyzw_2.z;
                float r4_w_1 = r4_xyzw_2.w;
                float r4_y_3 = dot(float4(r4_y_2, r4_z_2, r4_w_1, r4_y_2), float4(r4_y_2, r4_z_2, r4_w_1, r4_y_2));
                float r4_y_4 = sqrt(r4_y_3);
                float r4_y_5 = (-r4_x_2 + r4_y_4);
                float r4_y_6 = (cb6_values[0].x == 1);
                float r5_x_8;
                float r5_y_8;
                float r5_z_8;
                float r5_w_4;
                if (r4_y_6)
                {
                    float r4_y_7 = (cb6_values[0].y == 1);
                    float3 r5_xyz_5 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r4_xyzw_8 = (r4_y_7.xxxx ? r5_xyz_5.xxyz : i.texcoord2.xxyz);
                    float r4_y_8 = r4_xyzw_8.y;
                    float r4_z_3 = r4_xyzw_8.z;
                    float r4_w_2 = r4_xyzw_8.w;
                    float4 r4_xyzw_9 = (float4(r4_y_8, r4_y_8, r4_z_3, r4_w_2) + -cb6_values[6].xxyz);
                    float r4_y_9 = r4_xyzw_9.y;
                    float r4_z_4 = r4_xyzw_9.z;
                    float r4_w_3 = r4_xyzw_9.w;
                    float4 r5_xyzw_6 = (float4(r4_y_9, r4_y_9, r4_z_4, r4_w_3) * cb6_values[5].xxyz);
                    float r5_y_6 = r5_xyzw_6.y;
                    float r5_z_6 = r5_xyzw_6.z;
                    float r5_w_2 = r5_xyzw_6.w;
                    float r4_y_10 = mad(r5_y_6, 0.25, 0.75);
                    float r4_z_5 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r5_x_6 = max(r4_z_5, r4_y_10);
                    float4 r5_xyzw_7 = t4.Sample(sampler_linear_clamp1, (float4(r5_x_6, r5_z_6, r5_w_2, r5_x_6)).xyz);
                    r5_x_8 = r5_xyzw_7.x;
                    r5_y_8 = r5_xyzw_7.y;
                    r5_z_8 = r5_xyzw_7.z;
                    r5_w_4 = r5_xyzw_7.w;
                }
                else
                {
                    float4 r5_xyzw_8 = float4(1, 1, 1, 1);
                    r5_x_8 = r5_xyzw_8.x;
                    r5_y_8 = r5_xyzw_8.y;
                    r5_z_8 = r5_xyzw_8.z;
                    r5_w_4 = r5_xyzw_8.w;
                }
                float r4_y_12 = saturate(dot(float4(r5_x_8, r5_y_8, r5_z_8, r5_w_4), unity_OcclusionMaskSelector));
                float4 r4_xyzw_7 = (i.texcoord4.xxxy / i.texcoord4.wwww);
                float r4_z_7 = r4_xyzw_7.z;
                float r4_w_5 = r4_xyzw_7.w;
                float4 r5_xyzw_9 = t1.Sample(sampler_linear_clamp2, (float4(r4_z_7, r4_w_5, r4_z_7, r4_z_7)).xy);
                float r4_y_13 = (r4_y_12 + -r5_xyzw_9.x);
                float r4_y_14 = (-r3_w_1 + 1);
                float r4_z_8 = dot(-r1_xyz_1.xyzx, i.texcoord1.xyzx);
                float r4_z_9 = (r4_z_8 + r4_z_8);
                float3 r5_xyz_10 = (mad(i.texcoord1.xyzx, -r4_z_9.xxxx, -r1_xyz_1.xyzx)).xyz;
                float4 r4_xyzw_6 = ((mad(saturate(mad(mad(cb3_values[25].w, r4_y_5, r4_x_2), cb3_values[24].z, cb3_values[24].w)), r4_y_13, r5_xyzw_9.x)).xxxx * _LightColor0.xxyz);
                float r4_x_6 = r4_xyzw_6.x;
                float r4_z_10 = r4_xyzw_6.z;
                float r4_w_6 = r4_xyzw_6.w;
                float r5_w_6 = (0 < cb5_values[2].w);
                float3 r6_xyz_4;
                if (r5_w_6)
                {
                    float3 r6_xyz_2 = normalize(r5_xyz_10);
                    float3 r9_xyz_1 = ((float4(0, 0, 0, 0) < r6_xyz_2.xyzx)).xyz;
                    float3 r7_xyz_3 = ((r9_xyz_1.xyzx ? ((((-i.texcoord2.xyzx + cb5_values[0].xyzx)).xyzx / r6_xyz_2.xyzx)).xyzx : ((((-i.texcoord2.xyzx + cb5_values[1].xyzx)).xyzx / r6_xyz_2.xyzx)).xyzx)).xyz;
                    float r5_w_9 = min(r7_xyz_3.y, r7_xyz_3.x);
                    float r5_w_10 = min(r7_xyz_3.z, r5_w_9);
                    r6_xyz_4 = (mad(r6_xyz_2.xyzx, r5_w_10.xxxx, ((i.texcoord2.xyzx + -cb5_values[2].xyzx)).xyzx)).xyz;
                }
                else
                {
                    r6_xyz_4 = r5_xyz_10.xyz;
                }
                float r5_w_12 = mad(-r4_y_14, 0.7, 1.7);
                float r5_w_13 = (r4_y_14 * r5_w_12);
                float r5_w_14 = (r5_w_13 * 6);
                float4 r6_xyzw_5 = t2.SampleLevel(sampler_linear_clamp, r6_xyz_4.xyz, r5_w_14);
                float r6_w_2 = (r6_xyzw_5.w + -1);
                float r6_w_3 = mad(cb5_values[3].w, r6_w_2, 1);
                float r6_w_4 = log2(r6_w_3);
                float r6_w_5 = (r6_w_4 * cb5_values[3].y);
                float r6_w_6 = exp2(r6_w_5);
                float r6_w_7 = (r6_w_6 * cb5_values[3].x);
                float r7_w_1 = (cb5_values[1].w < 0.99999);
                float3 r7_xyz_8 = ((r6_xyzw_5.xyzx * r6_w_7.xxxx)).xyz;
                if (r7_w_1)
                {
                    float r7_w_2 = (0 < cb5_values[6].w);
                    float3 r5_xyz_12 = r5_xyz_10;
                    if (r7_w_2)
                    {
                        float r7_w_3 = dot(r5_xyz_10.xyzx, r5_xyz_10.xyzx);
                        float r7_w_4 = rsqrt(r7_w_3);
                        float3 r8_xyz_4 = ((r5_xyz_10.xyzx * r7_w_4.xxxx)).xyz;
                        float3 r11_xyz_1 = ((float4(0, 0, 0, 0) < r8_xyz_4.xyzx)).xyz;
                        float3 r9_xyz_5 = ((r11_xyz_1.xyzx ? ((((-i.texcoord2.xyzx + cb5_values[4].xyzx)).xyzx / r8_xyz_4.xyzx)).xyzx : ((((-i.texcoord2.xyzx + cb5_values[5].xyzx)).xyzx / r8_xyz_4.xyzx)).xyzx)).xyz;
                        float r7_w_5 = min(r9_xyz_5.y, r9_xyz_5.x);
                        float r7_w_6 = min(r9_xyz_5.z, r7_w_5);
                        r5_xyz_12 = (mad(r8_xyz_4.xyzx, r7_w_6.xxxx, ((i.texcoord2.xyzx + -cb5_values[6].xyzx)).xyzx)).xyz;
                    }
                    float4 r5_xyzw_13 = t3.SampleLevel(sampler_linear_clamp, r5_xyz_12.xyz, r5_w_14);
                    float r5_w_16 = (r5_xyzw_13.w + -1);
                    float r5_w_17 = mad(cb5_values[7].w, r5_w_16, 1);
                    float r5_w_18 = log2(r5_w_17);
                    float r5_w_19 = (r5_w_18 * cb5_values[7].y);
                    float r5_w_20 = exp2(r5_w_19);
                    float r5_w_21 = (r5_w_20 * cb5_values[7].x);
                    float3 r5_xyz_14 = ((r5_xyzw_13.xyzx * r5_w_21.xxxx)).xyz;
                    r7_xyz_8 = (mad(cb5_values[1].wwww, (mad(r6_w_7.xxxx, r6_xyzw_5.xyzx, -r5_xyz_14.xyzx)).xyzx, r5_xyz_14.xyzx)).xyz;
                }
                float4 unitWorldNormal_xyzw_18 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_18 = unitWorldNormal_xyzw_18.x;
                float unitWorldNormal_y_16 = unitWorldNormal_xyzw_18.y;
                float unitWorldNormal_z_16 = unitWorldNormal_xyzw_18.z;
                float3 r2_xyz_5 = (mad(r2_w_2.xxxx, (mad(r2_xyz_3.xyzx, r1_w_1.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_2 = mad(-i.color0.x, 0.48, 0.96);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unity_ObjectToWorld[0].xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(unitWorldNormal_x_18, unitWorldNormal_y_16, unitWorldNormal_z_16, unitWorldNormal_x_18), r1_xyz_1.xyzx);
                float r1_x_2 = saturate(dot(float4(unitWorldNormal_x_18, unitWorldNormal_y_16, unitWorldNormal_z_16, unitWorldNormal_x_18), unity_ObjectToWorld[0].xyzx));
                float r1_y_2 = saturate(dot(float4(unitWorldNormal_x_18, unitWorldNormal_y_16, unitWorldNormal_z_16, unitWorldNormal_x_18), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(unity_ObjectToWorld[0].xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r4_y_14.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(r0_w_6) + 1);
                float r2_w_3 = (r1_z_4 * r1_z_4);
                float r2_w_4 = (r2_w_3 * r2_w_3);
                float r1_z_5 = (r1_z_4 * r2_w_4);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r4_y_14 * r4_y_14);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r2_w_5 = (-r0_z_8 + 1);
                float r4_y_15 = mad(abs(r0_w_6), r2_w_5, r0_z_8);
                float r2_w_6 = mad(r1_x_2, r2_w_5, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * r2_w_6);
                float r0_w_8 = mad(r1_x_2, r4_y_15, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r2_w_7 = (r0_z_8 * r0_z_8);
                float r4_y_16 = mad(r1_y_2, r2_w_7, -r1_y_2);
                float r1_y_3 = mad(r4_y_16, r1_y_2, 1);
                float r2_w_8 = (r2_w_7 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r1_y_5 = (r2_w_8 / r1_y_4);
                float r0_w_11 = (r0_w_10 * r1_y_5);
                float r0_w_12 = (r0_w_11 * 3.1415927);
                float4 r0_xyzw_9 = (r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_y_8, r0_w_12));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_w_13 = r0_xyzw_9.w;
                float r0_z_9 = mad(r0_z_8, r0_z_8, 1);
                float r0_z_10 = ((float4(1, 1, 1, 1) / r0_z_9)).z;
                float r0_w_14 = (r0_w_13 * asfloat(asint((float)((dot(r2_xyz_5.xyzx, r2_xyz_5.xyzx) != 0))) & asint(1065353216)));
                float4 r5_xyzw_19 = (r0_y_9.xxxx * float4(r4_x_6, r4_z_10, r4_w_6, r4_x_6));
                float r5_x_19 = r5_xyzw_19.x;
                float r5_y_17 = r5_xyzw_19.y;
                float r5_z_17 = r5_xyzw_19.z;
                float r4_x_7 = ((float4(r4_x_6, r4_z_10, r4_w_6, r4_x_6) * r0_w_14.xxxx)).x;
                float4 r4_xyzw_17 = (float4(r4_x_6, r4_z_10, r4_w_6, r4_x_6) * r0_w_14.xxxx);
                float r4_y_17 = r4_xyzw_17.y;
                float r4_z_11 = r4_xyzw_17.z;
                float r0_x_5 = (-r0_x_4 + 1);
                float r0_y_10 = (r0_x_5 * r0_x_5);
                float r0_y_11 = (r0_y_10 * r0_y_10);
                float4 r0_xyzw_7 = mad(((-r2_xyz_5.xyzx + float4(1, 1, 1, 0))).xyxz, ((r0_x_5 * r0_y_11)).xxxx, r2_xyz_5.xyxz);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_12 = r0_xyzw_7.y;
                float r0_w_15 = r0_xyzw_7.w;
                float4 r0_xyzw_8 = (float4(r0_x_7, r0_y_12, r0_x_7, r0_w_15) * float4(r4_x_7, r4_y_17, r4_x_7, r4_z_11));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_13 = r0_xyzw_8.y;
                float r0_w_16 = r0_xyzw_8.w;
                float r0_x_9 = (mad(((r1_w_2.xxxx * ((r1_w_1.xxxx * r2_xyz_3.xyzx)).xyzx)).xyxz, float4(r5_x_19, r5_y_17, r5_x_19, r5_z_17), float4(r0_x_8, r0_y_13, r0_x_8, r0_w_16))).x;
                float4 r0_xyzw_14 = mad(((r1_w_2.xxxx * ((r1_w_1.xxxx * r2_xyz_3.xyzx)).xyzx)).xyxz, float4(r5_x_19, r5_y_17, r5_x_19, r5_z_17), float4(r0_x_8, r0_y_13, r0_x_8, r0_w_16));
                float r0_y_14 = r0_xyzw_14.y;
                float r0_w_17 = r0_xyzw_14.w;
                float4 r1_xyzw_8 = (-r2_xyz_5.xyxz + (saturate(((-r1_w_2 + r3_w_1) + 1))).xxxx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_w_3 = r1_xyzw_8.w;
                float4 r1_xyzw_9 = mad(r1_z_5.xxxx, float4(r1_x_8, r1_y_6, r1_w_3, r1_x_8), r2_xyz_5.xyzx);
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_7 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r0_xyzw_10 = mad(((r7_xyz_8.xyzx * r0_z_10.xxxx)).xyzx, float4(r1_x_9, r1_y_7, r1_z_6, r1_x_9), float4(r0_x_9, r0_y_14, r0_w_17, r0_x_9));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_15 = r0_xyzw_10.y;
                float r0_z_11 = r0_xyzw_10.z;
                float4 r1_xyzw_10 = mad(float4(r0_x_10, r0_y_15, r0_z_11, r0_x_10), i.color0.xyzx, -float4(r0_x_10, r0_y_15, r0_z_11, r0_x_10));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_8 = r1_xyzw_10.y;
                float r1_z_7 = r1_xyzw_10.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_10, r1_y_8, r1_z_7, r1_x_10), float4(0.25, 0.25, 0.25, 0), float4(r0_x_10, r0_y_15, r0_z_11, r0_x_10))).xyz;
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
                float _Wave : packoffset(c5.x);
                float _VertexColorBoost : packoffset(c5.y);
                float4 _MainTex_ST : packoffset(c6);
            };
            cbuffer _UnityPerCameraCB_b1
            {
                float4 _Time : packoffset(c0);
                float3 _WorldSpaceCameraPos : packoffset(c4);
            };
            cbuffer _UnityPerDrawCB_b2
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[46];
            };
            cbuffer _UnityPerFrameCB_b3
            {
                float4 unity_SpecCube0_BoxMax;
                float4 unity_SpecCube0_BoxMin;
                float4 unity_SpecCube0_ProbePosition;
                float4 unity_SpecCube0_HDR;
                float4 unity_SpecCube1_BoxMax;
                float4 unity_SpecCube1_BoxMin;
                float4 unity_SpecCube1_ProbePosition;
                float4 unity_SpecCube1_HDR;
                float4x4 unity_MatrixVP;
                float4 cb3_values[7];
            };
            cbuffer cb4 : register(b4)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb4_values[21];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            TextureCube t1;
            TextureCube t2;
            Texture3D t3;
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
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program19Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program19Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program7Output vert(program7Input i)
            {
                program7Output o = (program7Output)0;
                float4 r0_xyzw_3 = ((sin(mad(i.position0.x, 8, _Time.y))).xxxx * i.normal0.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = mad(float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3), _Wave.xxxx, i.position0.xyzx);
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_2 = r0_xyzw_4.y;
                float r0_z_2 = r0_xyzw_4.z;
                float4 r0_xyzw_5 = mad(cb3_values[2].xyzw, r0_z_2.xxxx, mad(cb3_values[0].xyzw, r0_x_4.xxxx, (r0_y_2.xxxx * cb3_values[1].xyzw)));
                float4 r1_xyzw_3 = (r0_xyzw_5 + cb3_values[3].xyzw);
                o.texcoord2.xyz = (mad(cb3_values[3].xyzx, i.position0.wwww, r0_xyzw_5.xyzx)).xyz;
                float4 r0_xyzw_6 = (r1_xyzw_3.yyyy * cb4_values[18].xyzw);
                float4 r0_xyzw_7 = mad(cb4_values[17].xyzw, r1_xyzw_3.xxxx, r0_xyzw_6);
                float4 r0_xyzw_8 = mad(cb4_values[19].xyzw, r1_xyzw_3.zzzz, r0_xyzw_7);
                o.sv_Position0.xyzw = mad(cb4_values[20].xyzw, r1_xyzw_3.wwww, r0_xyzw_8);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_9 = dot(i.normal0.xyzx, cb3_values[4].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, cb3_values[5].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, cb3_values[6].xyzx);
                float r0_w_5 = dot(float4(worldNormal_x_9, worldNormal_y_7, worldNormal_z_7, worldNormal_x_9), float4(worldNormal_x_9, worldNormal_y_7, worldNormal_z_7, worldNormal_x_9));
                float r0_w_6 = rsqrt(r0_w_5);
                float4 unitWorldNormal_xyzw_10 = (r0_w_6.xxxx * float4(worldNormal_x_9, worldNormal_y_7, worldNormal_z_7, worldNormal_x_9));
                float unitWorldNormal_x_10 = unitWorldNormal_xyzw_10.x;
                float unitWorldNormal_y_8 = unitWorldNormal_xyzw_10.y;
                float unitWorldNormal_z_8 = unitWorldNormal_xyzw_10.z;
                o.texcoord1.xyz = (float4(unitWorldNormal_x_10, unitWorldNormal_y_8, unitWorldNormal_z_8, unitWorldNormal_x_10)).xyz;
                o.color0.xyzw = i.color0.xyzw;
                float r0_w_7 = (unitWorldNormal_y_8 * unitWorldNormal_y_8);
                float r0_w_8 = mad(unitWorldNormal_x_10, unitWorldNormal_x_10, -r0_w_7);
                float4 r1_xyzw_4 = (float4(unitWorldNormal_y_8, unitWorldNormal_z_8, unitWorldNormal_z_8, unitWorldNormal_x_10) * float4(unitWorldNormal_x_10, unitWorldNormal_y_8, unitWorldNormal_z_8, unitWorldNormal_z_8));
                float r0_x_11 = dot(cb2_values[42].xyzw, r1_xyzw_4);
                float r0_y_9 = dot(cb2_values[43].xyzw, r1_xyzw_4);
                float r0_z_9 = dot(cb2_values[44].xyzw, r1_xyzw_4);
                o.texcoord3.xyz = (mad(cb2_values[45].xyzx, r0_w_8.xxxx, float4(r0_x_11, r0_y_9, r0_z_9, r0_x_11))).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program19Output frag(program19Input i)
            {
                program19Output o = (program19Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_3 = ((((r2_xyzw_1.xyzx * _Color.xyzx)).xyzx * i.color0.xyzx)).xyz;
                float r1_w_1 = (_VertexColorBoost + 1);
                float r2_w_2 = (i.color0.x * 0.5);
                float r3_w_1 = saturate(i.color0.y);
                float r4_x_1 = (unity_ProbeVolumeParams.x == 1);
                float r5_x_8;
                float r5_y_8;
                float r5_z_8;
                float r5_w_4;
                if (r4_x_1)
                {
                    float r4_y_1 = (unity_ProbeVolumeParams.y == 1);
                    float3 r5_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float4 unity_ProbeVolumeParamsSelect_xyzw_2 = (r4_y_1.xxxx ? r5_xyz_5.xxyz : i.texcoord2.xxyz);
                    float unity_ProbeVolumeParamsSelect_y_2 = unity_ProbeVolumeParamsSelect_xyzw_2.y;
                    float unity_ProbeVolumeParamsSelect_z_1 = unity_ProbeVolumeParamsSelect_xyzw_2.z;
                    float unity_ProbeVolumeParamsSelect_w_1 = unity_ProbeVolumeParamsSelect_xyzw_2.w;
                    float4 r4_xyzw_3 = (float4(unity_ProbeVolumeParamsSelect_y_2, unity_ProbeVolumeParamsSelect_y_2, unity_ProbeVolumeParamsSelect_z_1, unity_ProbeVolumeParamsSelect_w_1) + -unity_ProbeVolumeMin.xxyz);
                    float r4_y_3 = r4_xyzw_3.y;
                    float r4_z_2 = r4_xyzw_3.z;
                    float r4_w_2 = r4_xyzw_3.w;
                    float4 r5_xyzw_6 = (float4(r4_y_3, r4_y_3, r4_z_2, r4_w_2) * unity_ProbeVolumeSizeInv.xxyz);
                    float r5_y_6 = r5_xyzw_6.y;
                    float r5_z_6 = r5_xyzw_6.z;
                    float r5_w_2 = r5_xyzw_6.w;
                    float r4_y_4 = mad(r5_y_6, 0.25, 0.75);
                    float r4_z_3 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r5_x_6 = max(r4_z_3, r4_y_4);
                    float4 r5_xyzw_7 = t3.Sample(sampler_linear_clamp1, (float4(r5_x_6, r5_z_6, r5_w_2, r5_x_6)).xyz);
                    r5_x_8 = r5_xyzw_7.x;
                    r5_y_8 = r5_xyzw_7.y;
                    r5_z_8 = r5_xyzw_7.z;
                    r5_w_4 = r5_xyzw_7.w;
                }
                else
                {
                    float4 r5_xyzw_8 = float4(1, 1, 1, 1);
                    r5_x_8 = r5_xyzw_8.x;
                    r5_y_8 = r5_xyzw_8.y;
                    r5_z_8 = r5_xyzw_8.z;
                    r5_w_4 = r5_xyzw_8.w;
                }
                float r4_y_6 = saturate(dot(float4(r5_x_8, r5_y_8, r5_z_8, r5_w_4), unity_OcclusionMaskSelector));
                float r4_z_5 = (-r3_w_1 + 1);
                float r4_w_4 = dot(-r1_xyz_1.xyzx, i.texcoord1.xyzx);
                float r4_w_5 = (r4_w_4 + r4_w_4);
                float3 r5_xyz_9 = (mad(i.texcoord1.xyzx, -r4_w_5.xxxx, -r1_xyz_1.xyzx)).xyz;
                float3 r6_xyz_1 = ((r4_y_6.xxxx * _LightColor0.xyzx)).xyz;
                float3 TEXCOORD1_xyz_1;
                float3 r8_xyz_4;
                if ((r4_x_1 != 0))
                {
                    float3 r7_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float4 unity_ProbeVolumeParamsSelect_xyzw_3 = (((unity_ProbeVolumeParams.y == 1)).xxxx ? r7_xyz_5.xyxz : i.texcoord2.xyxz);
                    float unity_ProbeVolumeParamsSelect_x_3 = unity_ProbeVolumeParamsSelect_xyzw_3.x;
                    float unity_ProbeVolumeParamsSelect_y_7 = unity_ProbeVolumeParamsSelect_xyzw_3.y;
                    float unity_ProbeVolumeParamsSelect_w_6 = unity_ProbeVolumeParamsSelect_xyzw_3.w;
                    float4 r4_xyzw_4 = (float4(unity_ProbeVolumeParamsSelect_x_3, unity_ProbeVolumeParamsSelect_y_7, unity_ProbeVolumeParamsSelect_x_3, unity_ProbeVolumeParamsSelect_w_6) + -unity_ProbeVolumeMin.xyxz);
                    float r4_x_4 = r4_xyzw_4.x;
                    float r4_y_8 = r4_xyzw_4.y;
                    float r4_w_7 = r4_xyzw_4.w;
                    float4 r7_xyzw_6 = (float4(r4_x_4, r4_x_4, r4_y_8, r4_w_7) * unity_ProbeVolumeSizeInv.xxyz);
                    float r7_y_6 = r7_xyzw_6.y;
                    float r7_z_6 = r7_xyzw_6.z;
                    float r7_w_2 = r7_xyzw_6.w;
                    float r4_y_9 = (unity_ProbeVolumeParams.z * 0.5);
                    float r4_w_8 = mad(-unity_ProbeVolumeParams.z, 0.5, 0.25);
                    float r7_x_6 = min(r4_w_8, max(r4_y_9, (r7_y_6 * 0.25)));
                    float4 r8_xyzw_2 = t3.Sample(sampler_linear_clamp1, (float4(r7_x_6, r7_z_6, r7_w_2, r7_x_6)).xyz);
                    float4 r4_xyzw_7 = (float4(r7_x_6, r7_z_6, r7_x_6, r7_w_2) + float4(0.25, 0, 0, 0));
                    float r4_x_7 = r4_xyzw_7.x;
                    float r4_y_10 = r4_xyzw_7.y;
                    float r4_w_9 = r4_xyzw_7.w;
                    float4 r9_xyzw_1 = t3.Sample(sampler_linear_clamp1, (float4(r4_x_7, r4_y_10, r4_w_9, r4_x_7)).xyz);
                    float4 r4_xyzw_8 = (float4(r7_x_6, r7_z_6, r7_x_6, r7_w_2) + float4(0.5, 0, 0, 0));
                    float r4_x_8 = r4_xyzw_8.x;
                    float r4_y_11 = r4_xyzw_8.y;
                    float r4_w_10 = r4_xyzw_8.w;
                    float4 r7_xyzw_7 = t3.Sample(sampler_linear_clamp1, (float4(r4_x_8, r4_y_11, r4_w_10, r4_x_8)).xyz);
                    TEXCOORD1_xyz_1 = i.texcoord1.xyz;
                    float r10_w_1 = 1;
                    float r8_x_3 = dot(r8_xyzw_2, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r10_w_1));
                    float r8_y_3 = dot(r9_xyzw_1, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r10_w_1));
                    float r8_z_3 = dot(r7_xyzw_7, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r10_w_1));
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
                float4 r4_xyzw_10 = (r8_xyz_4.xyxz + i.texcoord3.xyxz);
                float r4_x_10 = r4_xyzw_10.x;
                float r4_y_13 = r4_xyzw_10.y;
                float r4_w_12 = r4_xyzw_10.w;
                float4 r4_xyzw_11 = max(float4(r4_x_10, r4_y_13, r4_x_10, r4_w_12), float4(0, 0, 0, 0));
                float r4_x_11 = r4_xyzw_11.x;
                float r4_y_14 = r4_xyzw_11.y;
                float r4_w_13 = r4_xyzw_11.w;
                float r5_w_5 = (0 < unity_SpecCube0_ProbePosition.w);
                float3 r7_xyz_12;
                if (r5_w_5)
                {
                    float3 r7_xyz_10 = normalize(r5_xyz_9);
                    float3 r10_xyz_3 = ((float4(0, 0, 0, 0) < r7_xyz_10.xyzx)).xyz;
                    float3 r8_xyz_7 = ((r10_xyz_3.xyzx ? ((((-i.texcoord2.xyzx + unity_SpecCube0_BoxMax.xyzx)).xyzx / r7_xyz_10.xyzx)).xyzx : ((((-i.texcoord2.xyzx + unity_SpecCube0_BoxMin.xyzx)).xyzx / r7_xyz_10.xyzx)).xyzx)).xyz;
                    float r5_w_8 = min(r8_xyz_7.y, r8_xyz_7.x);
                    float r5_w_9 = min(r8_xyz_7.z, r5_w_8);
                    r7_xyz_12 = (mad(r7_xyz_10.xyzx, r5_w_9.xxxx, ((i.texcoord2.xyzx + -unity_SpecCube0_ProbePosition.xyzx)).xyzx)).xyz;
                }
                else
                {
                    r7_xyz_12 = r5_xyz_9.xyz;
                }
                float r5_w_11 = mad(-r4_z_5, 0.7, 1.7);
                float r5_w_12 = (r4_z_5 * r5_w_11);
                float r5_w_13 = (r5_w_12 * 6);
                float4 r7_xyzw_13 = t1.SampleLevel(sampler_linear_clamp, r7_xyz_12.xyz, r5_w_13);
                float r6_w_1 = (r7_xyzw_13.w + -1);
                float r6_w_2 = mad(unity_SpecCube0_HDR.w, r6_w_1, 1);
                float r6_w_3 = log2(r6_w_2);
                float r6_w_4 = (r6_w_3 * unity_SpecCube0_HDR.y);
                float r6_w_5 = exp2(r6_w_4);
                float r6_w_6 = (r6_w_5 * unity_SpecCube0_HDR.x);
                float r7_w_6 = (unity_SpecCube0_BoxMin.w < 0.99999);
                float3 r8_xyz_12 = ((r7_xyzw_13.xyzx * r6_w_6.xxxx)).xyz;
                if (r7_w_6)
                {
                    float r7_w_7 = (0 < unity_SpecCube1_ProbePosition.w);
                    float3 r5_xyz_11 = r5_xyz_9;
                    if (r7_w_7)
                    {
                        float r7_w_8 = dot(r5_xyz_9.xyzx, r5_xyz_9.xyzx);
                        float r7_w_9 = rsqrt(r7_w_8);
                        float3 r9_xyz_6 = ((r5_xyz_9.xyzx * r7_w_9.xxxx)).xyz;
                        float3 r12_xyz_1 = ((float4(0, 0, 0, 0) < r9_xyz_6.xyzx)).xyz;
                        float3 r10_xyz_7 = ((r12_xyz_1.xyzx ? ((((-i.texcoord2.xyzx + unity_SpecCube1_BoxMax.xyzx)).xyzx / r9_xyz_6.xyzx)).xyzx : ((((-i.texcoord2.xyzx + unity_SpecCube1_BoxMin.xyzx)).xyzx / r9_xyz_6.xyzx)).xyzx)).xyz;
                        float r7_w_10 = min(r10_xyz_7.y, r10_xyz_7.x);
                        float r7_w_11 = min(r10_xyz_7.z, r7_w_10);
                        r5_xyz_11 = (mad(r9_xyz_6.xyzx, r7_w_11.xxxx, ((i.texcoord2.xyzx + -unity_SpecCube1_ProbePosition.xyzx)).xyzx)).xyz;
                    }
                    float4 r5_xyzw_12 = t2.SampleLevel(sampler_linear_clamp, r5_xyz_11.xyz, r5_w_13);
                    float r5_w_15 = (r5_xyzw_12.w + -1);
                    float r5_w_16 = mad(unity_SpecCube1_HDR.w, r5_w_15, 1);
                    float r5_w_17 = log2(r5_w_16);
                    float r5_w_18 = (r5_w_17 * unity_SpecCube1_HDR.y);
                    float r5_w_19 = exp2(r5_w_18);
                    float r5_w_20 = (r5_w_19 * unity_SpecCube1_HDR.x);
                    float3 r5_xyz_13 = ((r5_xyzw_12.xyzx * r5_w_20.xxxx)).xyz;
                    r8_xyz_12 = (mad(unity_SpecCube0_BoxMin.wwww, (mad(r6_w_6.xxxx, r7_xyzw_13.xyzx, -r5_xyz_13.xyzx)).xyzx, r5_xyz_13.xyzx)).xyz;
                }
                float4 unitWorldNormal_xyzw_17 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_17 = unitWorldNormal_xyzw_17.x;
                float unitWorldNormal_y_15 = unitWorldNormal_xyzw_17.y;
                float unitWorldNormal_z_15 = unitWorldNormal_xyzw_17.z;
                float3 r2_xyz_5 = (mad(r2_w_2.xxxx, (mad(r2_xyz_3.xyzx, r1_w_1.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_2 = mad(-i.color0.x, 0.48, 0.96);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unity_ObjectToWorld[0].xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(unitWorldNormal_x_17, unitWorldNormal_y_15, unitWorldNormal_z_15, unitWorldNormal_x_17), r1_xyz_1.xyzx);
                float r1_x_2 = saturate(dot(float4(unitWorldNormal_x_17, unitWorldNormal_y_15, unitWorldNormal_z_15, unitWorldNormal_x_17), unity_ObjectToWorld[0].xyzx));
                float r1_y_2 = saturate(dot(float4(unitWorldNormal_x_17, unitWorldNormal_y_15, unitWorldNormal_z_15, unitWorldNormal_x_17), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(unity_ObjectToWorld[0].xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r4_z_5.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(r0_w_6) + 1);
                float r2_w_3 = (r1_z_4 * r1_z_4);
                float r2_w_4 = (r2_w_3 * r2_w_3);
                float r1_z_5 = (r1_z_4 * r2_w_4);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r4_z_5 * r4_z_5);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r2_w_5 = (-r0_z_8 + 1);
                float r4_z_6 = mad(abs(r0_w_6), r2_w_5, r0_z_8);
                float r2_w_6 = mad(r1_x_2, r2_w_5, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * r2_w_6);
                float r0_w_8 = mad(r1_x_2, r4_z_6, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r2_w_7 = (r0_z_8 * r0_z_8);
                float r4_z_7 = mad(r1_y_2, r2_w_7, -r1_y_2);
                float r1_y_3 = mad(r4_z_7, r1_y_2, 1);
                float r2_w_8 = (r2_w_7 * 0.31830987);
                float r1_y_4 = mad(r1_y_3, r1_y_3, 1E-07);
                float r1_y_5 = (r2_w_8 / r1_y_4);
                float r0_w_11 = (r0_w_10 * r1_y_5);
                float r0_w_12 = (r0_w_11 * 3.1415927);
                float4 r0_xyzw_9 = (r1_x_2.xxxx * float4(r0_y_8, r0_y_8, r0_y_8, r0_w_12));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_w_13 = r0_xyzw_9.w;
                float r0_z_9 = mad(r0_z_8, r0_z_8, 1);
                float r0_z_10 = ((float4(1, 1, 1, 1) / r0_z_9)).z;
                float r0_w_14 = (r0_w_13 * asfloat(asint((float)((dot(r2_xyz_5.xyzx, r2_xyz_5.xyzx) != 0))) & asint(1065353216)));
                float4 r4_xyzw_12 = mad(r6_xyz_1.xyzx, r0_y_9.xxxx, float4(r4_x_11, r4_y_14, r4_w_13, r4_x_11));
                float r4_x_12 = r4_xyzw_12.x;
                float r4_y_15 = r4_xyzw_12.y;
                float r4_z_8 = r4_xyzw_12.z;
                float4 r5_xyzw_18 = (r6_xyz_1.xyzx * r0_w_14.xxxx);
                float r5_x_18 = r5_xyzw_18.x;
                float r5_y_16 = r5_xyzw_18.y;
                float r5_z_16 = r5_xyzw_18.z;
                float r0_x_5 = (-r0_x_4 + 1);
                float r0_y_10 = (r0_x_5 * r0_x_5);
                float r0_y_11 = (r0_y_10 * r0_y_10);
                float4 r0_xyzw_7 = mad(((-r2_xyz_5.xyzx + float4(1, 1, 1, 0))).xyxz, ((r0_x_5 * r0_y_11)).xxxx, r2_xyz_5.xyxz);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_12 = r0_xyzw_7.y;
                float r0_w_15 = r0_xyzw_7.w;
                float4 r0_xyzw_8 = (float4(r0_x_7, r0_y_12, r0_x_7, r0_w_15) * float4(r5_x_18, r5_y_16, r5_x_18, r5_z_16));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_13 = r0_xyzw_8.y;
                float r0_w_16 = r0_xyzw_8.w;
                float r0_x_9 = (mad(((r1_w_2.xxxx * ((r1_w_1.xxxx * r2_xyz_3.xyzx)).xyzx)).xyxz, float4(r4_x_12, r4_y_15, r4_x_12, r4_z_8), float4(r0_x_8, r0_y_13, r0_x_8, r0_w_16))).x;
                float4 r0_xyzw_14 = mad(((r1_w_2.xxxx * ((r1_w_1.xxxx * r2_xyz_3.xyzx)).xyzx)).xyxz, float4(r4_x_12, r4_y_15, r4_x_12, r4_z_8), float4(r0_x_8, r0_y_13, r0_x_8, r0_w_16));
                float r0_y_14 = r0_xyzw_14.y;
                float r0_w_17 = r0_xyzw_14.w;
                float4 r1_xyzw_8 = (-r2_xyz_5.xyxz + (saturate(((-r1_w_2 + r3_w_1) + 1))).xxxx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_w_3 = r1_xyzw_8.w;
                float4 r1_xyzw_9 = mad(r1_z_5.xxxx, float4(r1_x_8, r1_y_6, r1_w_3, r1_x_8), r2_xyz_5.xyzx);
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_7 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r0_xyzw_10 = mad(((r8_xyz_12.xyzx * r0_z_10.xxxx)).xyzx, float4(r1_x_9, r1_y_7, r1_z_6, r1_x_9), float4(r0_x_9, r0_y_14, r0_w_17, r0_x_9));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_15 = r0_xyzw_10.y;
                float r0_z_11 = r0_xyzw_10.z;
                float4 r1_xyzw_10 = mad(float4(r0_x_10, r0_y_15, r0_z_11, r0_x_10), i.color0.xyzx, -float4(r0_x_10, r0_y_15, r0_z_11, r0_x_10));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_8 = r1_xyzw_10.y;
                float r1_z_7 = r1_xyzw_10.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_10, r1_y_8, r1_z_7, r1_x_10), float4(0.25, 0.25, 0.25, 0), float4(r0_x_10, r0_y_15, r0_z_11, r0_x_10))).xyz;
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
                float _Wave;
                float _VertexColorBoost;
                float4 _MainTex_ST;
                float4 cb0_values[11];
            };
            cbuffer _UnityPerCameraCB_b1
            {
                float4 _Time : packoffset(c0);
                float3 _WorldSpaceCameraPos : packoffset(c4);
            };
            cbuffer _UnityPerDrawCB_b2
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_OcclusionMaskSelector : packoffset(c46);
            };
            cbuffer _UnityPerFrameCB_b3
            {
                float4 unity_ProbeVolumeParams : packoffset(c0);
                float4x4 unity_ProbeVolumeWorldToObject : packoffset(c1);
                float3 unity_ProbeVolumeSizeInv : packoffset(c5);
                float3 unity_ProbeVolumeMin : packoffset(c6);
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            Texture3D t2;
            struct program27Input
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
            struct program27Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program50Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program50Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program27Output vert(program27Input i)
            {
                program27Output o = (program27Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 r0_xyzw_3 = ((sin(mad(i.position0.x, 8, _Time.y))).xxxx * i.normal0.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = mad(float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3), cb0_values[9].xxxx, i.position0.xyzx);
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_2 = r0_xyzw_4.y;
                float r0_z_2 = r0_xyzw_4.z;
                float4 r0_xyzw_5 = mad(unity_ObjectToWorld[2], r0_z_2.xxxx, mad(unity_ObjectToWorld[0], r0_x_4.xxxx, (r0_y_2.xxxx * unity_ObjectToWorld[1])));
                float4 r1_xyzw_3 = (r0_xyzw_5 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(r1_xyzw_3);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                float worldNormal_x_4 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_4 = dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4));
                float r1_w_5 = rsqrt(r1_w_4);
                o.texcoord1.xyz = ((r1_w_5.xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, r0_xyzw_5.xyzx)).xyz;
                float4 worldPos_xyzw_6 = mad(unity_ObjectToWorld[3], i.position0.wwww, r0_xyzw_5);
                o.color0.xyzw = i.color0.xyzw;
                float3 clipPos_xyz_5 = ((worldPos_xyzw_6.yyyy * cb0_values[5].xyzx)).xyz;
                float3 clipPos_xyz_6 = (mad(_Color.xyzx, worldPos_xyzw_6.xxxx, clipPos_xyz_5.xyzx)).xyz;
                float4 clipPos_xyzw_7 = mad(_MainTex_ST.xyzx, worldPos_xyzw_6.zzzz, clipPos_xyz_6.xyzx);
                float clipPos_x_7 = clipPos_xyzw_7.x;
                float clipPos_y_5 = clipPos_xyzw_7.y;
                float clipPos_z_5 = clipPos_xyzw_7.z;
                o.texcoord3.xyz = (mad(cb0_values[7].xyzx, worldPos_xyzw_6.wwww, float4(clipPos_x_7, clipPos_y_5, clipPos_z_5, clipPos_x_7))).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program50Output frag(program50Input i)
            {
                program50Output o = (program50Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + unity_ObjectToWorld[0].xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 r2_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float3 r2_xyz_2 = normalize(r2_xyz_1);
                float4 r3_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r3_xyz_3 = ((((r3_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * i.color0.xyzx)).xyz;
                float r1_w_3 = (cb0_values[9].y + 1);
                float r2_w_1 = (i.color0.x * 0.5);
                float r3_w_2 = saturate(i.color0.y);
                float3 r5_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r4_w_1 = (unity_ProbeVolumeParams.x == 1);
                float r6_x_10;
                float r6_y_10;
                float r6_z_10;
                float r6_w_4;
                if (r4_w_1)
                {
                    float r4_w_2 = (unity_ProbeVolumeParams.y == 1);
                    float3 r6_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r4_w_2.xxxx ? r6_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r6_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r6_y_8 = r6_xyzw_8.y;
                    float r6_z_8 = r6_xyzw_8.z;
                    float r6_w_2 = r6_xyzw_8.w;
                    float r4_w_3 = mad(r6_y_8, 0.25, 0.75);
                    float r5_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r6_x_8 = max(r4_w_3, r5_w_1);
                    float4 r6_xyzw_9 = t2.Sample(sampler_linear_clamp, (float4(r6_x_8, r6_z_8, r6_w_2, r6_x_8)).xyz);
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
                float r4_w_5 = saturate(dot(float4(r6_x_10, r6_y_10, r6_z_10, r6_w_4), unity_OcclusionMaskSelector));
                float4 r5_xyzw_6 = t1.Sample(sampler_linear_clamp1, ((dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx)).xxxx).xy);
                float r4_w_6 = (r4_w_5 * r5_xyzw_6.x);
                float4 r5_xyzw_7 = (r4_w_6.xxxx * _LightColor0.xyzx);
                float r5_x_7 = r5_xyzw_7.x;
                float r5_y_6 = r5_xyzw_7.y;
                float r5_z_6 = r5_xyzw_7.z;
                float3 unitWorldNormal_xyz_11 = normalize(i.texcoord1);
                float3 r3_xyz_5 = (mad(r2_w_1.xxxx, (mad(r3_xyz_3.xyzx, r1_w_3.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_4 = mad(-i.color0.x, 0.48, 0.96);
                float r1_w_5 = (-r3_w_2 + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, r2_xyz_2.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(unitWorldNormal_xyz_11.xyzx, r2_xyz_2.xyzx);
                float r2_x_3 = saturate(dot(unitWorldNormal_xyz_11.xyzx, r1_xyz_1.xyzx));
                float r2_y_3 = saturate(dot(unitWorldNormal_xyz_11.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_5.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_x_3 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_5 * r1_w_5);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(r0_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * mad(r2_x_3, r1_x_6, r0_z_8));
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
                float r0_w_11 = dot(r3_xyz_5.xyzx, r3_xyz_5.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_15 = (r0_w_13 * r0_z_14);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r5_x_7, r5_y_6, r5_z_6, r5_x_7));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r5_x_7, r5_x_7, r5_y_6, r5_z_6) * r0_z_15.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_16 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_6 = (r0_x_5 * r0_x_5);
                float r1_w_7 = (r1_w_6 * r1_w_6);
                float4 r2_xyzw_4 = (-r3_xyz_5.xyzx + float4(1, 1, 1, 0));
                float r2_x_4 = r2_xyzw_4.x;
                float r2_y_4 = r2_xyzw_4.y;
                float r2_z_3 = r2_xyzw_4.z;
                float4 r2_xyzw_5 = mad(float4(r2_x_4, r2_y_4, r2_z_3, r2_x_4), ((r0_x_5 * r1_w_7)).xxxx, r3_xyz_5.xyzx);
                float r2_x_5 = r2_xyzw_5.x;
                float r2_y_5 = r2_xyzw_5.y;
                float r2_z_4 = r2_xyzw_5.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_16, r0_w_14, r0_y_10) * float4(r2_x_5, r2_y_5, r2_z_4, r2_x_5));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_17 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_4.xxxx * ((r1_w_3.xxxx * r3_xyz_3.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_17, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                float4 r1_xyzw_12 = mad(float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8), i.color0.xyzx, -float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8));
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_6 = r1_xyzw_12.y;
                float r1_z_3 = r1_xyzw_12.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_12, r1_y_6, r1_z_3, r1_x_12), float4(0.25, 0.25, 0.25, 0), float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8))).xyz;
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
                float _Wave;
                float _VertexColorBoost;
                float4 _MainTex_ST;
                float4 cb0_values[11];
            };
            cbuffer _UnityPerCameraCB_b1
            {
                float4 _Time : packoffset(c0);
                float3 _WorldSpaceCameraPos : packoffset(c4);
            };
            cbuffer _UnityPerDrawCB_b2
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[3];
            };
            cbuffer _UnityPerFrameCB_b3
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
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
            struct program39Input
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
            struct program39Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program62Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program62Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program39Output vert(program39Input i)
            {
                program39Output o = (program39Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 r0_xyzw_3 = ((sin(mad(i.position0.x, 8, _Time.y))).xxxx * i.normal0.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = mad(float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3), cb0_values[9].xxxx, i.position0.xyzx);
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_2 = r0_xyzw_4.y;
                float r0_z_2 = r0_xyzw_4.z;
                float4 r0_xyzw_5 = mad(unity_ObjectToWorld[2], r0_z_2.xxxx, mad(unity_ObjectToWorld[0], r0_x_4.xxxx, (r0_y_2.xxxx * unity_ObjectToWorld[1])));
                float4 r1_xyzw_3 = (r0_xyzw_5 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(r1_xyzw_3);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                float worldNormal_x_4 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_4 = dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4));
                float r1_w_5 = rsqrt(r1_w_4);
                o.texcoord1.xyz = ((r1_w_5.xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, r0_xyzw_5.xyzx)).xyz;
                float4 worldPos_xyzw_6 = mad(unity_ObjectToWorld[3], i.position0.wwww, r0_xyzw_5);
                o.color0.xyzw = i.color0.xyzw;
                float3 clipPos_xyz_5 = ((worldPos_xyzw_6.yyyy * cb0_values[5].xyzx)).xyz;
                float3 clipPos_xyz_6 = (mad(_Color.xyzx, worldPos_xyzw_6.xxxx, clipPos_xyz_5.xyzx)).xyz;
                float4 clipPos_xyzw_7 = mad(_MainTex_ST.xyzx, worldPos_xyzw_6.zzzz, clipPos_xyz_6.xyzx);
                float clipPos_x_7 = clipPos_xyzw_7.x;
                float clipPos_y_5 = clipPos_xyzw_7.y;
                float clipPos_z_5 = clipPos_xyzw_7.z;
                o.texcoord3.xyz = (mad(cb0_values[7].xyzx, worldPos_xyzw_6.wwww, float4(clipPos_x_7, clipPos_y_5, clipPos_z_5, clipPos_x_7))).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program62Output frag(program62Input i)
            {
                program62Output o = (program62Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + unity_ObjectToWorld[0].xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 r2_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float3 r3_xyz_1 = normalize(r2_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_3 = ((((r4_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * i.color0.xyzx)).xyz;
                float r1_w_3 = (cb0_values[9].y + 1);
                float r2_w_1 = (i.color0.x * 0.5);
                float r3_w_1 = saturate(i.color0.y);
                float3 r6_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r7_x_1 = cb4_values[9].z;
                float r7_y_1 = cb4_values[10].z;
                float r7_z_1 = cb4_values[11].z;
                float r2_x_2 = dot(r2_xyz_1.xyzx, float4(r7_x_1, r7_y_1, r7_z_1, r7_x_1));
                float3 r7_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_y_2 = dot(r7_xyz_2.xyzx, r7_xyz_2.xyzx);
                float r2_y_3 = sqrt(r2_y_2);
                float r2_y_4 = (-r2_x_2 + r2_y_3);
                float r2_x_4 = saturate(mad(mad(cb3_values[25].w, r2_y_4, r2_x_2), cb3_values[24].z, cb3_values[24].w));
                float r2_y_5 = (cb5_values[0].x == 1);
                float r7_x_12;
                float r7_y_12;
                float r7_z_12;
                float r7_w_4;
                if (r2_y_5)
                {
                    float r2_y_6 = (cb5_values[0].y == 1);
                    float3 r7_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r7_xyzw_10 = (((((r2_y_6.xxxx ? r7_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r7_y_10 = r7_xyzw_10.y;
                    float r7_z_10 = r7_xyzw_10.z;
                    float r7_w_2 = r7_xyzw_10.w;
                    float r2_y_7 = mad(r7_y_10, 0.25, 0.75);
                    float r2_z_2 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r7_x_10 = max(r2_z_2, r2_y_7);
                    float4 r7_xyzw_11 = t3.Sample(sampler_linear_clamp, (float4(r7_x_10, r7_z_10, r7_w_2, r7_x_10)).xyz);
                    r7_x_12 = r7_xyzw_11.x;
                    r7_y_12 = r7_xyzw_11.y;
                    r7_z_12 = r7_xyzw_11.z;
                    r7_w_4 = r7_xyzw_11.w;
                }
                else
                {
                    float4 r7_xyzw_3 = float4(1, 1, 1, 1);
                    r7_x_12 = r7_xyzw_3.x;
                    r7_y_12 = r7_xyzw_3.y;
                    r7_z_12 = r7_xyzw_3.z;
                    r7_w_4 = r7_xyzw_3.w;
                }
                float r2_y_9 = saturate(dot(float4(r7_x_12, r7_y_12, r7_z_12, r7_w_4), unity_OcclusionMaskSelector));
                float r2_z_4 = (r2_x_4 < 0.99);
                float r2_z_16;
                if (r2_z_4)
                {
                    float3 r7_xyz_13 = ((i.texcoord2.xyzx + -cb2_values[1].xyzx)).xyz;
                    float r2_z_6 = max(abs(r7_xyz_13.y), abs(r7_xyz_13.x));
                    float r2_z_7 = max(abs(r7_xyz_13.z), r2_z_6);
                    float r2_z_8 = (r2_z_7 + -cb2_values[2].z);
                    float r2_z_9 = max(r2_z_8, 1E-05);
                    float r2_z_10 = (r2_z_9 * cb2_values[2].w);
                    float r2_z_11 = (cb2_values[2].y / r2_z_10);
                    float r2_z_12 = (r2_z_11 + -cb2_values[2].x);
                    float r2_z_13 = (-r2_z_12 + 1);
                    float r8_x_2 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r7_xyz_13.xyzx + float4(0.0078125, 0.0078125, 0.0078125, 0))).xyzx).xyz, r2_z_13);
                    float r8_y_2 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r7_xyz_13.xyzx + float4(-0.0078125, -0.0078125, 0.0078125, 0))).xyzx).xyz, r2_z_13);
                    float r8_z_2 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r7_xyz_13.xyzx + float4(-0.0078125, 0.0078125, -0.0078125, 0))).xyzx).xyz, r2_z_13);
                    float r8_w_1 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r7_xyz_13.xyzx + float4(0.0078125, -0.0078125, -0.0078125, 0))).xyzx).xyz, r2_z_13);
                    float r2_z_14 = dot(float4(r8_x_2, r8_y_2, r8_z_2, r8_w_1), float4(0.25, 0.25, 0.25, 0.25));
                    float r4_w_2 = (-cb3_values[24].x + 1);
                    float r2_z_15 = mad(r2_z_14, r4_w_2, cb3_values[24].x);
                    r2_z_16 = r2_z_15;
                }
                else
                {
                    float r2_z_5 = 1;
                    r2_z_16 = r2_z_5;
                }
                float r2_y_10 = (-r2_z_16 + r2_y_9);
                float r2_y_11 = dot(r6_xyz_4.xyzx, r6_xyz_4.xyzx);
                float4 r7_xyzw_16 = t1.Sample(sampler_linear_clamp3, (r2_y_11.xxxx).xy);
                float4 r6_xyzw_5 = t2.Sample(sampler_linear_clamp2, r6_xyz_4.xyz);
                float r2_y_12 = (r6_xyzw_5.w * r7_xyzw_16.x);
                float4 r2_xyzw_7 = (((mad(r2_x_4, r2_y_10, r2_z_16) * r2_y_12)).xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_13 = r2_xyzw_7.y;
                float r2_z_17 = r2_xyzw_7.z;
                float3 unitWorldNormal_xyz_6 = normalize(i.texcoord1);
                float3 r4_xyz_5 = (mad(r2_w_1.xxxx, (mad(r4_xyz_3.xyzx, r1_w_3.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_4 = mad(-i.color0.x, 0.48, 0.96);
                float r1_w_5 = (-r3_w_1 + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, r3_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(unitWorldNormal_xyz_6.xyzx, r3_xyz_1.xyzx);
                float r2_w_2 = saturate(dot(unitWorldNormal_xyz_6.xyzx, r1_xyz_1.xyzx));
                float r3_x_2 = saturate(dot(unitWorldNormal_xyz_6.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_5.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_2 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_5 * r1_w_5);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(r0_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * mad(r2_w_2, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_2, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r3_x_2, r0_z_9, -r3_x_2), r3_x_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_w_2.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_w_11 = dot(r4_xyz_5.xyzx, r4_xyz_5.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_15 = (r0_w_13 * r0_z_14);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r2_x_7, r2_y_13, r2_z_17, r2_x_7));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r2_x_7, r2_x_7, r2_y_13, r2_z_17) * r0_z_15.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_16 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_6 = (r0_x_5 * r0_x_5);
                float r1_w_7 = (r1_w_6 * r1_w_6);
                float4 r2_xyzw_8 = (-r4_xyz_5.xyzx + float4(1, 1, 1, 0));
                float r2_x_8 = r2_xyzw_8.x;
                float r2_y_14 = r2_xyzw_8.y;
                float r2_z_18 = r2_xyzw_8.z;
                float4 r2_xyzw_9 = mad(float4(r2_x_8, r2_y_14, r2_z_18, r2_x_8), ((r0_x_5 * r1_w_7)).xxxx, r4_xyz_5.xyzx);
                float r2_x_9 = r2_xyzw_9.x;
                float r2_y_15 = r2_xyzw_9.y;
                float r2_z_19 = r2_xyzw_9.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_16, r0_w_14, r0_y_10) * float4(r2_x_9, r2_y_15, r2_z_19, r2_x_9));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_17 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_4.xxxx * ((r1_w_3.xxxx * r4_xyz_3.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_17, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                float4 r1_xyzw_12 = mad(float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8), i.color0.xyzx, -float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8));
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_6 = r1_xyzw_12.y;
                float r1_z_3 = r1_xyzw_12.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_12, r1_y_6, r1_z_3, r1_x_12), float4(0.25, 0.25, 0.25, 0), float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8))).xyz;
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
                float _Wave;
                float _VertexColorBoost;
                float4 _MainTex_ST;
                float4 cb0_values[11];
            };
            cbuffer _UnityPerCameraCB_b1
            {
                float4 _Time : packoffset(c0);
                float3 _WorldSpaceCameraPos : packoffset(c4);
            };
            cbuffer _UnityPerDrawCB_b2
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[3];
            };
            cbuffer _UnityPerFrameCB_b3
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
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
            struct program38Input
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
            struct program38Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program61Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program61Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program38Output vert(program38Input i)
            {
                program38Output o = (program38Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 r0_xyzw_3 = ((sin(mad(i.position0.x, 8, _Time.y))).xxxx * i.normal0.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = mad(float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3), cb0_values[9].xxxx, i.position0.xyzx);
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_2 = r0_xyzw_4.y;
                float r0_z_2 = r0_xyzw_4.z;
                float4 r0_xyzw_5 = mad(unity_ObjectToWorld[2], r0_z_2.xxxx, mad(unity_ObjectToWorld[0], r0_x_4.xxxx, (r0_y_2.xxxx * unity_ObjectToWorld[1])));
                float4 r1_xyzw_3 = (r0_xyzw_5 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(r1_xyzw_3);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                float worldNormal_x_4 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_4 = dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4));
                float r1_w_5 = rsqrt(r1_w_4);
                o.texcoord1.xyz = ((r1_w_5.xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, r0_xyzw_5.xyzx)).xyz;
                float4 worldPos_xyzw_6 = mad(unity_ObjectToWorld[3], i.position0.wwww, r0_xyzw_5);
                o.color0.xyzw = i.color0.xyzw;
                float3 clipPos_xyz_5 = ((worldPos_xyzw_6.yyyy * cb0_values[5].xyzx)).xyz;
                float3 clipPos_xyz_6 = (mad(_Color.xyzx, worldPos_xyzw_6.xxxx, clipPos_xyz_5.xyzx)).xyz;
                float4 clipPos_xyzw_7 = mad(_MainTex_ST.xyzx, worldPos_xyzw_6.zzzz, clipPos_xyz_6.xyzx);
                float clipPos_x_7 = clipPos_xyzw_7.x;
                float clipPos_y_5 = clipPos_xyzw_7.y;
                float clipPos_z_5 = clipPos_xyzw_7.z;
                o.texcoord3.xyz = (mad(cb0_values[7].xyzx, worldPos_xyzw_6.wwww, float4(clipPos_x_7, clipPos_y_5, clipPos_z_5, clipPos_x_7))).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program61Output frag(program61Input i)
            {
                program61Output o = (program61Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + unity_ObjectToWorld[0].xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 r2_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float3 r3_xyz_1 = normalize(r2_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_3 = ((((r4_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * i.color0.xyzx)).xyz;
                float r1_w_3 = (cb0_values[9].y + 1);
                float r2_w_1 = (i.color0.x * 0.5);
                float r3_w_1 = saturate(i.color0.y);
                float3 r6_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r7_x_1 = cb4_values[9].z;
                float r7_y_1 = cb4_values[10].z;
                float r7_z_1 = cb4_values[11].z;
                float r2_x_2 = dot(r2_xyz_1.xyzx, float4(r7_x_1, r7_y_1, r7_z_1, r7_x_1));
                float3 r7_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_y_2 = dot(r7_xyz_2.xyzx, r7_xyz_2.xyzx);
                float r2_y_3 = sqrt(r2_y_2);
                float r2_y_4 = (-r2_x_2 + r2_y_3);
                float r2_y_5 = (cb5_values[0].x == 1);
                float r7_x_12;
                float r7_y_12;
                float r7_z_12;
                float r7_w_4;
                if (r2_y_5)
                {
                    float r2_y_6 = (cb5_values[0].y == 1);
                    float3 r7_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r7_xyzw_10 = (((((r2_y_6.xxxx ? r7_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r7_y_10 = r7_xyzw_10.y;
                    float r7_z_10 = r7_xyzw_10.z;
                    float r7_w_2 = r7_xyzw_10.w;
                    float r2_y_7 = mad(r7_y_10, 0.25, 0.75);
                    float r2_z_2 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r7_x_10 = max(r2_z_2, r2_y_7);
                    float4 r7_xyzw_11 = t3.Sample(sampler_linear_clamp, (float4(r7_x_10, r7_z_10, r7_w_2, r7_x_10)).xyz);
                    r7_x_12 = r7_xyzw_11.x;
                    r7_y_12 = r7_xyzw_11.y;
                    r7_z_12 = r7_xyzw_11.z;
                    r7_w_4 = r7_xyzw_11.w;
                }
                else
                {
                    float4 r7_xyzw_3 = float4(1, 1, 1, 1);
                    r7_x_12 = r7_xyzw_3.x;
                    r7_y_12 = r7_xyzw_3.y;
                    r7_z_12 = r7_xyzw_3.z;
                    r7_w_4 = r7_xyzw_3.w;
                }
                float r2_y_9 = saturate(dot(float4(r7_x_12, r7_y_12, r7_z_12, r7_w_4), unity_OcclusionMaskSelector));
                float3 r7_xyz_13 = ((i.texcoord2.xyzx + -cb2_values[1].xyzx)).xyz;
                float r2_z_4 = max(abs(r7_xyz_13.y), abs(r7_xyz_13.x));
                float r2_z_5 = max(abs(r7_xyz_13.z), r2_z_4);
                float r2_z_6 = (r2_z_5 + -cb2_values[2].z);
                float r2_z_7 = max(r2_z_6, 1E-05);
                float r2_z_8 = (r2_z_7 * cb2_values[2].w);
                float r2_z_9 = (cb2_values[2].y / r2_z_8);
                float r2_z_10 = (r2_z_9 + -cb2_values[2].x);
                float r2_z_11 = (-r2_z_10 + 1);
                float r2_z_12 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, r7_xyz_13.xyz, r2_z_11);
                float r4_w_2 = (-cb3_values[24].x + 1);
                float r2_z_13 = mad(r2_z_12, r4_w_2, cb3_values[24].x);
                float r2_y_10 = (-r2_z_13 + r2_y_9);
                float r2_y_11 = dot(r6_xyz_4.xyzx, r6_xyz_4.xyzx);
                float4 r7_xyzw_14 = t1.Sample(sampler_linear_clamp3, (r2_y_11.xxxx).xy);
                float4 r6_xyzw_5 = t2.Sample(sampler_linear_clamp2, r6_xyz_4.xyz);
                float r2_y_12 = (r6_xyzw_5.w * r7_xyzw_14.x);
                float4 r2_xyzw_7 = (((mad(saturate(mad(mad(cb3_values[25].w, r2_y_4, r2_x_2), cb3_values[24].z, cb3_values[24].w)), r2_y_10, r2_z_13) * r2_y_12)).xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_13 = r2_xyzw_7.y;
                float r2_z_14 = r2_xyzw_7.z;
                float3 unitWorldNormal_xyz_6 = normalize(i.texcoord1);
                float3 r4_xyz_5 = (mad(r2_w_1.xxxx, (mad(r4_xyz_3.xyzx, r1_w_3.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_4 = mad(-i.color0.x, 0.48, 0.96);
                float r1_w_5 = (-r3_w_1 + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, r3_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(unitWorldNormal_xyz_6.xyzx, r3_xyz_1.xyzx);
                float r2_w_2 = saturate(dot(unitWorldNormal_xyz_6.xyzx, r1_xyz_1.xyzx));
                float r3_x_2 = saturate(dot(unitWorldNormal_xyz_6.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_5.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_2 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_5 * r1_w_5);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(r0_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * mad(r2_w_2, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_2, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r3_x_2, r0_z_9, -r3_x_2), r3_x_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_w_2.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_w_11 = dot(r4_xyz_5.xyzx, r4_xyz_5.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_15 = (r0_w_13 * r0_z_14);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r2_x_7, r2_y_13, r2_z_14, r2_x_7));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r2_x_7, r2_x_7, r2_y_13, r2_z_14) * r0_z_15.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_16 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_6 = (r0_x_5 * r0_x_5);
                float r1_w_7 = (r1_w_6 * r1_w_6);
                float4 r2_xyzw_8 = (-r4_xyz_5.xyzx + float4(1, 1, 1, 0));
                float r2_x_8 = r2_xyzw_8.x;
                float r2_y_14 = r2_xyzw_8.y;
                float r2_z_15 = r2_xyzw_8.z;
                float4 r2_xyzw_9 = mad(float4(r2_x_8, r2_y_14, r2_z_15, r2_x_8), ((r0_x_5 * r1_w_7)).xxxx, r4_xyz_5.xyzx);
                float r2_x_9 = r2_xyzw_9.x;
                float r2_y_15 = r2_xyzw_9.y;
                float r2_z_16 = r2_xyzw_9.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_16, r0_w_14, r0_y_10) * float4(r2_x_9, r2_y_15, r2_z_16, r2_x_9));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_17 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_4.xxxx * ((r1_w_3.xxxx * r4_xyz_3.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_17, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                float4 r1_xyzw_12 = mad(float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8), i.color0.xyzx, -float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8));
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_6 = r1_xyzw_12.y;
                float r1_z_3 = r1_xyzw_12.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_12, r1_y_6, r1_z_3, r1_x_12), float4(0.25, 0.25, 0.25, 0), float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8))).xyz;
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
                float _Wave;
                float _VertexColorBoost;
                float4 _MainTex_ST;
                float4 cb0_values[11];
            };
            cbuffer _UnityPerCameraCB_b1
            {
                float4 _Time : packoffset(c0);
                float3 _WorldSpaceCameraPos : packoffset(c4);
            };
            cbuffer _UnityPerDrawCB_b2
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[3];
            };
            cbuffer _UnityPerFrameCB_b3
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
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
            struct program37Input
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
            struct program37Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program60Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program60Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program37Output vert(program37Input i)
            {
                program37Output o = (program37Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 r0_xyzw_3 = ((sin(mad(i.position0.x, 8, _Time.y))).xxxx * i.normal0.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = mad(float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3), cb0_values[9].xxxx, i.position0.xyzx);
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_2 = r0_xyzw_4.y;
                float r0_z_2 = r0_xyzw_4.z;
                float4 r0_xyzw_5 = mad(unity_ObjectToWorld[2], r0_z_2.xxxx, mad(unity_ObjectToWorld[0], r0_x_4.xxxx, (r0_y_2.xxxx * unity_ObjectToWorld[1])));
                float4 r1_xyzw_3 = (r0_xyzw_5 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(r1_xyzw_3);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                float worldNormal_x_4 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_4 = dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4));
                float r1_w_5 = rsqrt(r1_w_4);
                o.texcoord1.xyz = ((r1_w_5.xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, r0_xyzw_5.xyzx)).xyz;
                float4 worldPos_xyzw_6 = mad(unity_ObjectToWorld[3], i.position0.wwww, r0_xyzw_5);
                o.color0.xyzw = i.color0.xyzw;
                float3 clipPos_xyz_5 = ((worldPos_xyzw_6.yyyy * cb0_values[5].xyzx)).xyz;
                float3 clipPos_xyz_6 = (mad(_Color.xyzx, worldPos_xyzw_6.xxxx, clipPos_xyz_5.xyzx)).xyz;
                float4 clipPos_xyzw_7 = mad(_MainTex_ST.xyzx, worldPos_xyzw_6.zzzz, clipPos_xyz_6.xyzx);
                float clipPos_x_7 = clipPos_xyzw_7.x;
                float clipPos_y_5 = clipPos_xyzw_7.y;
                float clipPos_z_5 = clipPos_xyzw_7.z;
                o.texcoord3.xyz = (mad(cb0_values[7].xyzx, worldPos_xyzw_6.wwww, float4(clipPos_x_7, clipPos_y_5, clipPos_z_5, clipPos_x_7))).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program60Output frag(program60Input i)
            {
                program60Output o = (program60Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + unity_ObjectToWorld[0].xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 r2_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float3 r3_xyz_1 = normalize(r2_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_3 = ((((r4_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * i.color0.xyzx)).xyz;
                float r1_w_3 = (cb0_values[9].y + 1);
                float r2_w_1 = (i.color0.x * 0.5);
                float r3_w_1 = saturate(i.color0.y);
                float3 r6_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r7_x_1 = cb4_values[9].z;
                float r7_y_1 = cb4_values[10].z;
                float r7_z_1 = cb4_values[11].z;
                float r2_x_2 = dot(r2_xyz_1.xyzx, float4(r7_x_1, r7_y_1, r7_z_1, r7_x_1));
                float3 r7_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_y_2 = dot(r7_xyz_2.xyzx, r7_xyz_2.xyzx);
                float r2_y_3 = sqrt(r2_y_2);
                float r2_y_4 = (-r2_x_2 + r2_y_3);
                float r2_x_4 = saturate(mad(mad(cb3_values[25].w, r2_y_4, r2_x_2), cb3_values[24].z, cb3_values[24].w));
                float r2_y_5 = (cb5_values[0].x == 1);
                float r7_x_12;
                float r7_y_12;
                float r7_z_12;
                float r7_w_4;
                if (r2_y_5)
                {
                    float r2_y_6 = (cb5_values[0].y == 1);
                    float3 r7_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r7_xyzw_10 = (((((r2_y_6.xxxx ? r7_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r7_y_10 = r7_xyzw_10.y;
                    float r7_z_10 = r7_xyzw_10.z;
                    float r7_w_2 = r7_xyzw_10.w;
                    float r2_y_7 = mad(r7_y_10, 0.25, 0.75);
                    float r2_z_2 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r7_x_10 = max(r2_z_2, r2_y_7);
                    float4 r7_xyzw_11 = t2.Sample(sampler_linear_clamp, (float4(r7_x_10, r7_z_10, r7_w_2, r7_x_10)).xyz);
                    r7_x_12 = r7_xyzw_11.x;
                    r7_y_12 = r7_xyzw_11.y;
                    r7_z_12 = r7_xyzw_11.z;
                    r7_w_4 = r7_xyzw_11.w;
                }
                else
                {
                    float4 r7_xyzw_3 = float4(1, 1, 1, 1);
                    r7_x_12 = r7_xyzw_3.x;
                    r7_y_12 = r7_xyzw_3.y;
                    r7_z_12 = r7_xyzw_3.z;
                    r7_w_4 = r7_xyzw_3.w;
                }
                float r2_y_9 = saturate(dot(float4(r7_x_12, r7_y_12, r7_z_12, r7_w_4), unity_OcclusionMaskSelector));
                float r2_z_4 = (r2_x_4 < 0.99);
                float r2_z_16;
                if (r2_z_4)
                {
                    float3 r7_xyz_13 = ((i.texcoord2.xyzx + -cb2_values[1].xyzx)).xyz;
                    float r2_z_6 = max(abs(r7_xyz_13.y), abs(r7_xyz_13.x));
                    float r2_z_7 = max(abs(r7_xyz_13.z), r2_z_6);
                    float r2_z_8 = (r2_z_7 + -cb2_values[2].z);
                    float r2_z_9 = max(r2_z_8, 1E-05);
                    float r2_z_10 = (r2_z_9 * cb2_values[2].w);
                    float r2_z_11 = (cb2_values[2].y / r2_z_10);
                    float r2_z_12 = (r2_z_11 + -cb2_values[2].x);
                    float r2_z_13 = (-r2_z_12 + 1);
                    float r8_x_2 = t3.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r7_xyz_13.xyzx + float4(0.0078125, 0.0078125, 0.0078125, 0))).xyzx).xyz, r2_z_13);
                    float r8_y_2 = t3.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r7_xyz_13.xyzx + float4(-0.0078125, -0.0078125, 0.0078125, 0))).xyzx).xyz, r2_z_13);
                    float r8_z_2 = t3.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r7_xyz_13.xyzx + float4(-0.0078125, 0.0078125, -0.0078125, 0))).xyzx).xyz, r2_z_13);
                    float r8_w_1 = t3.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r7_xyz_13.xyzx + float4(0.0078125, -0.0078125, -0.0078125, 0))).xyzx).xyz, r2_z_13);
                    float r2_z_14 = dot(float4(r8_x_2, r8_y_2, r8_z_2, r8_w_1), float4(0.25, 0.25, 0.25, 0.25));
                    float r4_w_2 = (-cb3_values[24].x + 1);
                    float r2_z_15 = mad(r2_z_14, r4_w_2, cb3_values[24].x);
                    r2_z_16 = r2_z_15;
                }
                else
                {
                    float r2_z_5 = 1;
                    r2_z_16 = r2_z_5;
                }
                float r2_y_10 = (-r2_z_16 + r2_y_9);
                float r2_y_11 = dot(r6_xyz_4.xyzx, r6_xyz_4.xyzx);
                float4 r6_xyzw_5 = t1.Sample(sampler_linear_clamp2, (r2_y_11.xxxx).xy);
                float4 r2_xyzw_7 = (((mad(r2_x_4, r2_y_10, r2_z_16) * r6_xyzw_5.x)).xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_12 = r2_xyzw_7.y;
                float r2_z_17 = r2_xyzw_7.z;
                float3 unitWorldNormal_xyz_6 = normalize(i.texcoord1);
                float3 r4_xyz_5 = (mad(r2_w_1.xxxx, (mad(r4_xyz_3.xyzx, r1_w_3.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_4 = mad(-i.color0.x, 0.48, 0.96);
                float r1_w_5 = (-r3_w_1 + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, r3_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(unitWorldNormal_xyz_6.xyzx, r3_xyz_1.xyzx);
                float r2_w_2 = saturate(dot(unitWorldNormal_xyz_6.xyzx, r1_xyz_1.xyzx));
                float r3_x_2 = saturate(dot(unitWorldNormal_xyz_6.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_5.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_2 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_5 * r1_w_5);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(r0_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * mad(r2_w_2, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_2, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r3_x_2, r0_z_9, -r3_x_2), r3_x_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_w_2.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_w_11 = dot(r4_xyz_5.xyzx, r4_xyz_5.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_15 = (r0_w_13 * r0_z_14);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r2_x_7, r2_y_12, r2_z_17, r2_x_7));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r2_x_7, r2_x_7, r2_y_12, r2_z_17) * r0_z_15.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_16 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_6 = (r0_x_5 * r0_x_5);
                float r1_w_7 = (r1_w_6 * r1_w_6);
                float4 r2_xyzw_8 = (-r4_xyz_5.xyzx + float4(1, 1, 1, 0));
                float r2_x_8 = r2_xyzw_8.x;
                float r2_y_13 = r2_xyzw_8.y;
                float r2_z_18 = r2_xyzw_8.z;
                float4 r2_xyzw_9 = mad(float4(r2_x_8, r2_y_13, r2_z_18, r2_x_8), ((r0_x_5 * r1_w_7)).xxxx, r4_xyz_5.xyzx);
                float r2_x_9 = r2_xyzw_9.x;
                float r2_y_14 = r2_xyzw_9.y;
                float r2_z_19 = r2_xyzw_9.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_16, r0_w_14, r0_y_10) * float4(r2_x_9, r2_y_14, r2_z_19, r2_x_9));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_17 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_4.xxxx * ((r1_w_3.xxxx * r4_xyz_3.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_17, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                float4 r1_xyzw_12 = mad(float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8), i.color0.xyzx, -float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8));
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_6 = r1_xyzw_12.y;
                float r1_z_3 = r1_xyzw_12.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_12, r1_y_6, r1_z_3, r1_x_12), float4(0.25, 0.25, 0.25, 0), float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8))).xyz;
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
                float _Wave;
                float _VertexColorBoost;
                float4 _MainTex_ST;
                float4 cb0_values[11];
            };
            cbuffer _UnityPerCameraCB_b1
            {
                float4 _Time : packoffset(c0);
                float3 _WorldSpaceCameraPos : packoffset(c4);
            };
            cbuffer _UnityPerDrawCB_b2
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[3];
            };
            cbuffer _UnityPerFrameCB_b3
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
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
            struct program36Input
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
            struct program36Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program59Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program59Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program36Output vert(program36Input i)
            {
                program36Output o = (program36Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 r0_xyzw_3 = ((sin(mad(i.position0.x, 8, _Time.y))).xxxx * i.normal0.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = mad(float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3), cb0_values[9].xxxx, i.position0.xyzx);
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_2 = r0_xyzw_4.y;
                float r0_z_2 = r0_xyzw_4.z;
                float4 r0_xyzw_5 = mad(unity_ObjectToWorld[2], r0_z_2.xxxx, mad(unity_ObjectToWorld[0], r0_x_4.xxxx, (r0_y_2.xxxx * unity_ObjectToWorld[1])));
                float4 r1_xyzw_3 = (r0_xyzw_5 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(r1_xyzw_3);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                float worldNormal_x_4 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_4 = dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4));
                float r1_w_5 = rsqrt(r1_w_4);
                o.texcoord1.xyz = ((r1_w_5.xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, r0_xyzw_5.xyzx)).xyz;
                float4 worldPos_xyzw_6 = mad(unity_ObjectToWorld[3], i.position0.wwww, r0_xyzw_5);
                o.color0.xyzw = i.color0.xyzw;
                float3 clipPos_xyz_5 = ((worldPos_xyzw_6.yyyy * cb0_values[5].xyzx)).xyz;
                float3 clipPos_xyz_6 = (mad(_Color.xyzx, worldPos_xyzw_6.xxxx, clipPos_xyz_5.xyzx)).xyz;
                float4 clipPos_xyzw_7 = mad(_MainTex_ST.xyzx, worldPos_xyzw_6.zzzz, clipPos_xyz_6.xyzx);
                float clipPos_x_7 = clipPos_xyzw_7.x;
                float clipPos_y_5 = clipPos_xyzw_7.y;
                float clipPos_z_5 = clipPos_xyzw_7.z;
                o.texcoord3.xyz = (mad(cb0_values[7].xyzx, worldPos_xyzw_6.wwww, float4(clipPos_x_7, clipPos_y_5, clipPos_z_5, clipPos_x_7))).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program59Output frag(program59Input i)
            {
                program59Output o = (program59Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + unity_ObjectToWorld[0].xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 r2_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float3 r3_xyz_1 = normalize(r2_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_3 = ((((r4_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * i.color0.xyzx)).xyz;
                float r1_w_3 = (cb0_values[9].y + 1);
                float r2_w_1 = (i.color0.x * 0.5);
                float r3_w_1 = saturate(i.color0.y);
                float3 r6_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r7_x_1 = cb4_values[9].z;
                float r7_y_1 = cb4_values[10].z;
                float r7_z_1 = cb4_values[11].z;
                float r2_x_2 = dot(r2_xyz_1.xyzx, float4(r7_x_1, r7_y_1, r7_z_1, r7_x_1));
                float3 r7_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_y_2 = dot(r7_xyz_2.xyzx, r7_xyz_2.xyzx);
                float r2_y_3 = sqrt(r2_y_2);
                float r2_y_4 = (-r2_x_2 + r2_y_3);
                float r2_y_5 = (cb5_values[0].x == 1);
                float r7_x_12;
                float r7_y_12;
                float r7_z_12;
                float r7_w_4;
                if (r2_y_5)
                {
                    float r2_y_6 = (cb5_values[0].y == 1);
                    float3 r7_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r7_xyzw_10 = (((((r2_y_6.xxxx ? r7_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r7_y_10 = r7_xyzw_10.y;
                    float r7_z_10 = r7_xyzw_10.z;
                    float r7_w_2 = r7_xyzw_10.w;
                    float r2_y_7 = mad(r7_y_10, 0.25, 0.75);
                    float r2_z_2 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r7_x_10 = max(r2_z_2, r2_y_7);
                    float4 r7_xyzw_11 = t2.Sample(sampler_linear_clamp, (float4(r7_x_10, r7_z_10, r7_w_2, r7_x_10)).xyz);
                    r7_x_12 = r7_xyzw_11.x;
                    r7_y_12 = r7_xyzw_11.y;
                    r7_z_12 = r7_xyzw_11.z;
                    r7_w_4 = r7_xyzw_11.w;
                }
                else
                {
                    float4 r7_xyzw_3 = float4(1, 1, 1, 1);
                    r7_x_12 = r7_xyzw_3.x;
                    r7_y_12 = r7_xyzw_3.y;
                    r7_z_12 = r7_xyzw_3.z;
                    r7_w_4 = r7_xyzw_3.w;
                }
                float r2_y_9 = saturate(dot(float4(r7_x_12, r7_y_12, r7_z_12, r7_w_4), unity_OcclusionMaskSelector));
                float3 r7_xyz_13 = ((i.texcoord2.xyzx + -cb2_values[1].xyzx)).xyz;
                float r2_z_4 = max(abs(r7_xyz_13.y), abs(r7_xyz_13.x));
                float r2_z_5 = max(abs(r7_xyz_13.z), r2_z_4);
                float r2_z_6 = (r2_z_5 + -cb2_values[2].z);
                float r2_z_7 = max(r2_z_6, 1E-05);
                float r2_z_8 = (r2_z_7 * cb2_values[2].w);
                float r2_z_9 = (cb2_values[2].y / r2_z_8);
                float r2_z_10 = (r2_z_9 + -cb2_values[2].x);
                float r2_z_11 = (-r2_z_10 + 1);
                float r2_z_12 = t3.SampleCmpLevelZero(sampler_comparison_linear_clamp1, r7_xyz_13.xyz, r2_z_11);
                float r4_w_2 = (-cb3_values[24].x + 1);
                float r2_z_13 = mad(r2_z_12, r4_w_2, cb3_values[24].x);
                float r2_y_10 = (-r2_z_13 + r2_y_9);
                float r2_y_11 = dot(r6_xyz_4.xyzx, r6_xyz_4.xyzx);
                float4 r6_xyzw_5 = t1.Sample(sampler_linear_clamp2, (r2_y_11.xxxx).xy);
                float4 r2_xyzw_7 = (((mad(saturate(mad(mad(cb3_values[25].w, r2_y_4, r2_x_2), cb3_values[24].z, cb3_values[24].w)), r2_y_10, r2_z_13) * r6_xyzw_5.x)).xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_12 = r2_xyzw_7.y;
                float r2_z_14 = r2_xyzw_7.z;
                float3 unitWorldNormal_xyz_6 = normalize(i.texcoord1);
                float3 r4_xyz_5 = (mad(r2_w_1.xxxx, (mad(r4_xyz_3.xyzx, r1_w_3.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_4 = mad(-i.color0.x, 0.48, 0.96);
                float r1_w_5 = (-r3_w_1 + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, r3_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(unitWorldNormal_xyz_6.xyzx, r3_xyz_1.xyzx);
                float r2_w_2 = saturate(dot(unitWorldNormal_xyz_6.xyzx, r1_xyz_1.xyzx));
                float r3_x_2 = saturate(dot(unitWorldNormal_xyz_6.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_5.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_2 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_5 * r1_w_5);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(r0_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * mad(r2_w_2, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_2, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r3_x_2, r0_z_9, -r3_x_2), r3_x_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_w_2.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_w_11 = dot(r4_xyz_5.xyzx, r4_xyz_5.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_15 = (r0_w_13 * r0_z_14);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r2_x_7, r2_y_12, r2_z_14, r2_x_7));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r2_x_7, r2_x_7, r2_y_12, r2_z_14) * r0_z_15.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_16 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_6 = (r0_x_5 * r0_x_5);
                float r1_w_7 = (r1_w_6 * r1_w_6);
                float4 r2_xyzw_8 = (-r4_xyz_5.xyzx + float4(1, 1, 1, 0));
                float r2_x_8 = r2_xyzw_8.x;
                float r2_y_13 = r2_xyzw_8.y;
                float r2_z_15 = r2_xyzw_8.z;
                float4 r2_xyzw_9 = mad(float4(r2_x_8, r2_y_13, r2_z_15, r2_x_8), ((r0_x_5 * r1_w_7)).xxxx, r4_xyz_5.xyzx);
                float r2_x_9 = r2_xyzw_9.x;
                float r2_y_14 = r2_xyzw_9.y;
                float r2_z_16 = r2_xyzw_9.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_16, r0_w_14, r0_y_10) * float4(r2_x_9, r2_y_14, r2_z_16, r2_x_9));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_17 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_4.xxxx * ((r1_w_3.xxxx * r4_xyz_3.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_17, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                float4 r1_xyzw_12 = mad(float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8), i.color0.xyzx, -float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8));
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_6 = r1_xyzw_12.y;
                float r1_z_3 = r1_xyzw_12.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_12, r1_y_6, r1_z_3, r1_x_12), float4(0.25, 0.25, 0.25, 0), float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8))).xyz;
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
                float _Wave;
                float _VertexColorBoost;
                float4 _MainTex_ST;
                float4 cb0_values[11];
            };
            cbuffer _UnityPerCameraCB_b1
            {
                float4 _Time;
                float3 _WorldSpaceCameraPos;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerDrawCB_b2
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_OcclusionMaskSelector : packoffset(c46);
            };
            cbuffer _UnityPerFrameCB_b3
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
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
            struct program35Input
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
            struct program35Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program58Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program58Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program35Output vert(program35Input i)
            {
                program35Output o = (program35Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 r0_xyzw_3 = ((sin(mad(i.position0.x, 8, _Time.y))).xxxx * i.normal0.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = mad(float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3), cb0_values[9].xxxx, i.position0.xyzx);
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_2 = r0_xyzw_4.y;
                float r0_z_2 = r0_xyzw_4.z;
                float4 r0_xyzw_5 = mad(unity_ObjectToWorld[2], r0_z_2.xxxx, mad(unity_ObjectToWorld[0], r0_x_4.xxxx, (r0_y_2.xxxx * unity_ObjectToWorld[1])));
                float4 r1_xyzw_3 = (r0_xyzw_5 + unity_ObjectToWorld[3]);
                float4 r1_xyzw_4 = mad(unity_MatrixVP[3], r1_xyzw_3.wwww, mad(unity_MatrixVP[2], r1_xyzw_3.zzzz, mad(unity_MatrixVP[0], r1_xyzw_3.xxxx, (r1_xyzw_3.yyyy * unity_MatrixVP[1]))));
                o.sv_Position0.xyzw = UnityObjectToClipPos(r1_xyzw_3);
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, r0_xyzw_5);
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, r0_xyzw_5.xyzx)).xyz;
                float4 clipPos_xyzw_6 = (worldPos_xyzw_4.yyyy * cb0_values[5].xyxx);
                float clipPos_x_6 = clipPos_xyzw_6.x;
                float clipPos_y_4 = clipPos_xyzw_6.y;
                float4 clipPos_xyzw_7 = mad(_Color.xyxx, worldPos_xyzw_4.xxxx, float4(clipPos_x_6, clipPos_y_4, clipPos_x_6, clipPos_x_6));
                float clipPos_x_7 = clipPos_xyzw_7.x;
                float clipPos_y_5 = clipPos_xyzw_7.y;
                float4 clipPos_xyzw_8 = mad(_MainTex_ST.xyxx, worldPos_xyzw_4.zzzz, float4(clipPos_x_7, clipPos_y_5, clipPos_x_7, clipPos_x_7));
                float clipPos_x_8 = clipPos_xyzw_8.x;
                float clipPos_y_6 = clipPos_xyzw_8.y;
                o.texcoord3.xy = (mad(cb0_values[7].xxxy, worldPos_xyzw_4.wwww, float4(clipPos_x_8, clipPos_x_8, clipPos_x_8, clipPos_y_6))).zw;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                float worldNormal_x_9 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_2 = dot(float4(worldNormal_x_9, worldNormal_y_7, worldNormal_z_4, worldNormal_x_9), float4(worldNormal_x_9, worldNormal_y_7, worldNormal_z_4, worldNormal_x_9));
                float r0_w_3 = rsqrt(r0_w_2);
                o.texcoord1.xyz = ((r0_w_3.xxxx * float4(worldNormal_x_9, worldNormal_y_7, worldNormal_z_4, worldNormal_x_9))).xyz;
                o.color0.xyzw = i.color0.xyzw;
                float r0_w_4 = ((r1_xyzw_4.y * cb1_values[5].x) * 0.5);
                float4 r0_xyzw_11 = (r1_xyzw_4.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_z_5 = r0_xyzw_11.z;
                o.texcoord4.zw = (r1_xyzw_4.zzzw).zw;
                o.texcoord4.xy = ((r0_z_5.xxxx + float4(r0_x_11, r0_w_4, r0_x_11, r0_x_11))).xy;
                return o;
            }
            #pragma fragment frag
            program58Output frag(program58Input i)
            {
                program58Output o = (program58Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_3 = ((((r2_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * i.color0.xyzx)).xyz;
                float r1_w_1 = (cb0_values[9].y + 1);
                float r2_w_2 = (i.color0.x * 0.5);
                float r3_w_1 = saturate(i.color0.y);
                float r5_x_1 = cb4_values[9].z;
                float r5_y_1 = cb4_values[10].z;
                float r5_z_1 = cb4_values[11].z;
                float r4_z_1 = dot(r0_xyz_1.xyzx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1));
                float3 r5_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r4_w_1 = dot(r5_xyz_2.xyzx, r5_xyz_2.xyzx);
                float r4_w_2 = sqrt(r4_w_1);
                float r4_w_3 = (-r4_z_1 + r4_w_2);
                float r4_z_2 = mad(cb3_values[25].w, r4_w_3, r4_z_1);
                float r4_z_3 = saturate(mad(r4_z_2, cb3_values[24].z, cb3_values[24].w));
                float r4_w_4 = (cb5_values[0].x == 1);
                float r5_x_12;
                float r5_y_13;
                float r5_z_12;
                float r5_w_4;
                if (r4_w_4)
                {
                    float r4_w_5 = (cb5_values[0].y == 1);
                    float3 r5_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r5_xyzw_10 = (((((r4_w_5.xxxx ? r5_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r5_y_10 = r5_xyzw_10.y;
                    float r5_z_10 = r5_xyzw_10.z;
                    float r5_w_2 = r5_xyzw_10.w;
                    float r4_w_6 = mad(r5_y_10, 0.25, 0.75);
                    float r5_y_11 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r5_x_10 = max(r4_w_6, r5_y_11);
                    float4 r5_xyzw_11 = t3.Sample(sampler_linear_clamp, (float4(r5_x_10, r5_z_10, r5_w_2, r5_x_10)).xyz);
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
                float r4_w_8 = saturate(dot(float4(r5_x_12, r5_y_13, r5_z_12, r5_w_4), unity_OcclusionMaskSelector));
                float4 r5_xyzw_13 = (i.texcoord4.xyxx / i.texcoord4.wwww);
                float r5_x_13 = r5_xyzw_13.x;
                float r5_y_14 = r5_xyzw_13.y;
                float4 r5_xyzw_14 = t1.Sample(sampler_linear_clamp1, (float4(r5_x_13, r5_y_14, r5_x_13, r5_x_13)).xy);
                float r4_w_9 = (r4_w_8 + -r5_xyzw_14.x);
                float r4_z_4 = mad(r4_z_3, r4_w_9, r5_xyzw_14.x);
                float4 r5_xyzw_15 = t2.Sample(sampler_linear_clamp2, ((((mad(cb0_values[6].xyxx, i.texcoord2.zzzz, (mad(cb0_values[4].xyxx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx).xy);
                float4 r4_xyzw_6 = (((r4_z_4 * r5_xyzw_15.w)).xxxx * _LightColor0.xyzx);
                float r4_x_6 = r4_xyzw_6.x;
                float r4_y_5 = r4_xyzw_6.y;
                float r4_z_5 = r4_xyzw_6.z;
                float r4_w_10 = dot(i.texcoord1.xyzx, i.texcoord1.xyzx);
                float r4_w_11 = rsqrt(r4_w_10);
                float4 unitClipPos_xyzw_16 = (r4_w_11.xxxx * i.texcoord1.xyzx);
                float unitClipPos_x_16 = unitClipPos_xyzw_16.x;
                float unitClipPos_y_17 = unitClipPos_xyzw_16.y;
                float unitClipPos_z_15 = unitClipPos_xyzw_16.z;
                float3 r2_xyz_5 = (mad(r2_w_2.xxxx, (mad(r2_xyz_3.xyzx, r1_w_1.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_2 = mad(-i.color0.x, 0.48, 0.96);
                float r1_w_3 = (-r3_w_1 + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unity_ObjectToWorld[0].xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(unitClipPos_x_16, unitClipPos_y_17, unitClipPos_z_15, unitClipPos_x_16), ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx);
                float r1_x_2 = saturate(dot(float4(unitClipPos_x_16, unitClipPos_y_17, unitClipPos_z_15, unitClipPos_x_16), unity_ObjectToWorld[0].xyzx));
                float r1_y_2 = saturate(dot(float4(unitClipPos_x_16, unitClipPos_y_17, unitClipPos_z_15, unitClipPos_x_16), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(unity_ObjectToWorld[0].xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_3.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(r0_w_6) + 1);
                float r2_w_3 = (r1_z_4 * r1_z_4);
                float r2_w_4 = (r2_w_3 * r2_w_3);
                float r1_z_5 = (r1_z_4 * r2_w_4);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_3 * r1_w_3);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_z_6 = (-r0_z_8 + 1);
                float r1_w_4 = mad(abs(r0_w_6), r1_z_6, r0_z_8);
                float r1_z_7 = mad(r1_x_2, r1_z_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * r1_z_7);
                float r0_w_8 = mad(r1_x_2, r1_w_4, r0_w_7);
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
                float r0_w_11 = dot(r2_xyz_5.xyzx, r2_xyz_5.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_15 = (r0_w_13 * r0_z_14);
                float4 r1_xyzw_3 = (r0_y_9.xxxx * float4(r4_x_6, r4_y_5, r4_z_5, r4_x_6));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_5 = r1_xyzw_3.y;
                float r1_z_9 = r1_xyzw_3.z;
                float4 r0_xyzw_10 = (float4(r4_x_6, r4_x_6, r4_y_5, r4_z_5) * r0_z_15.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_16 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_5 = (r0_x_5 * r0_x_5);
                float r1_w_6 = (r1_w_5 * r1_w_5);
                float4 r4_xyzw_7 = (-r2_xyz_5.xyzx + float4(1, 1, 1, 0));
                float r4_x_7 = r4_xyzw_7.x;
                float r4_y_6 = r4_xyzw_7.y;
                float r4_z_6 = r4_xyzw_7.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_16, r0_w_14, r0_y_10) * (mad(float4(r4_x_7, r4_y_6, r4_z_6, r4_x_7), ((r0_x_5 * r1_w_6)).xxxx, r2_xyz_5.xyzx)).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_17 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_2.xxxx * ((r1_w_1.xxxx * r2_xyz_3.xyzx)).xyzx)).xyzx, float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_7, r0_y_11, r0_z_17, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                float4 r1_xyzw_4 = mad(float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8), i.color0.xyzx, -float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_6 = r1_xyzw_4.y;
                float r1_z_10 = r1_xyzw_4.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_4, r1_y_6, r1_z_10, r1_x_4), float4(0.25, 0.25, 0.25, 0), float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8))).xyz;
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
                float _Wave;
                float _VertexColorBoost;
                float4 _MainTex_ST;
                float4 cb0_values[6];
            };
            cbuffer _UnityPerCameraCB_b1
            {
                float4 _Time;
                float3 _WorldSpaceCameraPos;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerDrawCB_b2
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_OcclusionMaskSelector : packoffset(c46);
            };
            cbuffer _UnityPerFrameCB_b3
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
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
            struct program34Input
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
            struct program34Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program57Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program57Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program34Output vert(program34Input i)
            {
                program34Output o = (program34Output)0;
                float4 r0_xyzw_3 = ((sin(mad(i.position0.x, 8, _Time.y))).xxxx * i.normal0.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = mad(float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3), _Wave.xxxx, i.position0.xyzx);
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_2 = r0_xyzw_4.y;
                float r0_z_2 = r0_xyzw_4.z;
                float4 r0_xyzw_5 = mad(unity_ObjectToWorld[2], r0_z_2.xxxx, mad(unity_ObjectToWorld[0], r0_x_4.xxxx, (r0_y_2.xxxx * unity_ObjectToWorld[1])));
                float4 r1_xyzw_3 = (r0_xyzw_5 + unity_ObjectToWorld[3]);
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, r0_xyzw_5.xyzx)).xyz;
                float4 r0_xyzw_6 = (r1_xyzw_3.yyyy * unity_MatrixVP[1]);
                float4 r0_xyzw_7 = mad(unity_MatrixVP[0], r1_xyzw_3.xxxx, r0_xyzw_6);
                float4 r0_xyzw_8 = mad(unity_MatrixVP[2], r1_xyzw_3.zzzz, r0_xyzw_7);
                float4 r0_xyzw_9 = mad(unity_MatrixVP[3], r1_xyzw_3.wwww, r0_xyzw_8);
                o.sv_Position0.xyzw = r0_xyzw_9;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_4 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_4 = dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4));
                float r1_w_5 = rsqrt(r1_w_4);
                o.texcoord1.xyz = ((r1_w_5.xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4))).xyz;
                o.color0.xyzw = i.color0.xyzw;
                float r0_y_8 = (r0_xyzw_9.y * cb1_values[5].x);
                float4 r1_xyzw_5 = (float4(r0_xyzw_9.x, r0_xyzw_9.x, r0_xyzw_9.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_5 = r1_xyzw_5.x;
                float r1_z_5 = r1_xyzw_5.z;
                float r1_w_6 = r1_xyzw_5.w;
                o.texcoord4.zw = (r0_xyzw_9.zzzw).zw;
                o.texcoord4.xy = ((r1_z_5.xxxx + float4(r1_x_5, r1_w_6, r1_x_5, r1_x_5))).xy;
                return o;
            }
            #pragma fragment frag
            program57Output frag(program57Input i)
            {
                program57Output o = (program57Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_3 = ((((r2_xyzw_1.xyzx * cb0_values[4].xyzx)).xyzx * i.color0.xyzx)).xyz;
                float r1_w_1 = (cb0_values[5].y + 1);
                float r2_w_2 = (i.color0.x * 0.5);
                float r3_w_1 = saturate(i.color0.y);
                float r4_x_1 = cb4_values[9].z;
                float r4_y_1 = cb4_values[10].z;
                float r4_z_1 = cb4_values[11].z;
                float r4_x_2 = dot(r0_xyz_1.xyzx, float4(r4_x_1, r4_y_1, r4_z_1, r4_x_1));
                float4 r4_xyzw_2 = (i.texcoord2.xxyz + -cb3_values[25].xxyz);
                float r4_y_2 = r4_xyzw_2.y;
                float r4_z_2 = r4_xyzw_2.z;
                float r4_w_1 = r4_xyzw_2.w;
                float r4_y_3 = dot(float4(r4_y_2, r4_z_2, r4_w_1, r4_y_2), float4(r4_y_2, r4_z_2, r4_w_1, r4_y_2));
                float r4_y_4 = sqrt(r4_y_3);
                float r4_y_5 = (-r4_x_2 + r4_y_4);
                float r4_y_6 = (cb5_values[0].x == 1);
                float r5_x_8;
                float r5_y_8;
                float r5_z_8;
                float r5_w_4;
                if (r4_y_6)
                {
                    float r4_y_7 = (cb5_values[0].y == 1);
                    float3 r5_xyz_5 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r4_xyzw_8 = (r4_y_7.xxxx ? r5_xyz_5.xxyz : i.texcoord2.xxyz);
                    float r4_y_8 = r4_xyzw_8.y;
                    float r4_z_3 = r4_xyzw_8.z;
                    float r4_w_2 = r4_xyzw_8.w;
                    float4 r4_xyzw_9 = (float4(r4_y_8, r4_y_8, r4_z_3, r4_w_2) + -cb5_values[6].xxyz);
                    float r4_y_9 = r4_xyzw_9.y;
                    float r4_z_4 = r4_xyzw_9.z;
                    float r4_w_3 = r4_xyzw_9.w;
                    float4 r5_xyzw_6 = (float4(r4_y_9, r4_y_9, r4_z_4, r4_w_3) * cb5_values[5].xxyz);
                    float r5_y_6 = r5_xyzw_6.y;
                    float r5_z_6 = r5_xyzw_6.z;
                    float r5_w_2 = r5_xyzw_6.w;
                    float r4_y_10 = mad(r5_y_6, 0.25, 0.75);
                    float r4_z_5 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r5_x_6 = max(r4_z_5, r4_y_10);
                    float4 r5_xyzw_7 = t2.Sample(sampler_linear_clamp, (float4(r5_x_6, r5_z_6, r5_w_2, r5_x_6)).xyz);
                    r5_x_8 = r5_xyzw_7.x;
                    r5_y_8 = r5_xyzw_7.y;
                    r5_z_8 = r5_xyzw_7.z;
                    r5_w_4 = r5_xyzw_7.w;
                }
                else
                {
                    float4 r5_xyzw_8 = float4(1, 1, 1, 1);
                    r5_x_8 = r5_xyzw_8.x;
                    r5_y_8 = r5_xyzw_8.y;
                    r5_z_8 = r5_xyzw_8.z;
                    r5_w_4 = r5_xyzw_8.w;
                }
                float r4_y_12 = saturate(dot(float4(r5_x_8, r5_y_8, r5_z_8, r5_w_4), unity_OcclusionMaskSelector));
                float4 r4_xyzw_7 = (i.texcoord4.xxxy / i.texcoord4.wwww);
                float r4_z_7 = r4_xyzw_7.z;
                float r4_w_5 = r4_xyzw_7.w;
                float4 r5_xyzw_9 = t1.Sample(sampler_linear_clamp1, (float4(r4_z_7, r4_w_5, r4_z_7, r4_z_7)).xy);
                float r4_y_13 = (r4_y_12 + -r5_xyzw_9.x);
                float4 r4_xyzw_6 = ((mad(saturate(mad(mad(cb3_values[25].w, r4_y_5, r4_x_2), cb3_values[24].z, cb3_values[24].w)), r4_y_13, r5_xyzw_9.x)).xxxx * _LightColor0.xyzx);
                float r4_x_6 = r4_xyzw_6.x;
                float r4_y_14 = r4_xyzw_6.y;
                float r4_z_8 = r4_xyzw_6.z;
                float3 unitWorldNormal_xyz_10 = normalize(i.texcoord1);
                float3 r2_xyz_5 = (mad(r2_w_2.xxxx, (mad(r2_xyz_3.xyzx, r1_w_1.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_2 = mad(-i.color0.x, 0.48, 0.96);
                float r1_w_3 = (-r3_w_1 + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unity_ObjectToWorld[0].xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(unitWorldNormal_xyz_10.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx);
                float r1_x_2 = saturate(dot(unitWorldNormal_xyz_10.xyzx, unity_ObjectToWorld[0].xyzx));
                float r1_y_2 = saturate(dot(unitWorldNormal_xyz_10.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(unity_ObjectToWorld[0].xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_3.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(r0_w_6) + 1);
                float r2_w_3 = (r1_z_4 * r1_z_4);
                float r2_w_4 = (r2_w_3 * r2_w_3);
                float r1_z_5 = (r1_z_4 * r2_w_4);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_3 * r1_w_3);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_z_6 = (-r0_z_8 + 1);
                float r1_w_4 = mad(abs(r0_w_6), r1_z_6, r0_z_8);
                float r1_z_7 = mad(r1_x_2, r1_z_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * r1_z_7);
                float r0_w_8 = mad(r1_x_2, r1_w_4, r0_w_7);
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
                float r0_w_11 = dot(r2_xyz_5.xyzx, r2_xyz_5.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_15 = (r0_w_13 * r0_z_14);
                float4 r1_xyzw_3 = (r0_y_9.xxxx * float4(r4_x_6, r4_y_14, r4_z_8, r4_x_6));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_5 = r1_xyzw_3.y;
                float r1_z_9 = r1_xyzw_3.z;
                float4 r0_xyzw_10 = (float4(r4_x_6, r4_x_6, r4_y_14, r4_z_8) * r0_z_15.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_16 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_5 = (r0_x_5 * r0_x_5);
                float r1_w_6 = (r1_w_5 * r1_w_5);
                float r4_x_7 = ((-r2_xyz_5.xyzx + float4(1, 1, 1, 0))).x;
                float4 r4_xyzw_15 = (-r2_xyz_5.xyzx + float4(1, 1, 1, 0));
                float r4_y_15 = r4_xyzw_15.y;
                float r4_z_9 = r4_xyzw_15.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_16, r0_w_14, r0_y_10) * (mad(float4(r4_x_7, r4_y_15, r4_z_9, r4_x_7), ((r0_x_5 * r1_w_6)).xxxx, r2_xyz_5.xyzx)).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_17 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_2.xxxx * ((r1_w_1.xxxx * r2_xyz_3.xyzx)).xyzx)).xyzx, float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_7, r0_y_11, r0_z_17, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                float4 r1_xyzw_4 = mad(float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8), i.color0.xyzx, -float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_6 = r1_xyzw_4.y;
                float r1_z_10 = r1_xyzw_4.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_4, r1_y_6, r1_z_10, r1_x_4), float4(0.25, 0.25, 0.25, 0), float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8))).xyz;
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
                float _Wave;
                float _VertexColorBoost;
                float4 _MainTex_ST;
                float4 cb0_values[16];
            };
            cbuffer _UnityPerCameraCB_b1
            {
                float4 _Time : packoffset(c0);
                float3 _WorldSpaceCameraPos : packoffset(c4);
            };
            cbuffer _UnityPerDrawCB_b2
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_OcclusionMaskSelector : packoffset(c46);
            };
            cbuffer _UnityPerFrameCB_b3
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
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
            struct program33Input
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
            struct program33Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program56Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program56Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program33Output vert(program33Input i)
            {
                program33Output o = (program33Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 r0_xyzw_3 = ((sin(mad(i.position0.x, 8, _Time.y))).xxxx * i.normal0.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = mad(float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3), cb0_values[14].xxxx, i.position0.xyzx);
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_2 = r0_xyzw_4.y;
                float r0_z_2 = r0_xyzw_4.z;
                float4 r0_xyzw_5 = mad(unity_ObjectToWorld[2], r0_z_2.xxxx, mad(unity_ObjectToWorld[0], r0_x_4.xxxx, (r0_y_2.xxxx * unity_ObjectToWorld[1])));
                float4 r1_xyzw_3 = (r0_xyzw_5 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(r1_xyzw_3);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[15].xyxx, cb0_values[15].zwzz)).xy;
                float worldNormal_x_4 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_4 = dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4));
                float r1_w_5 = rsqrt(r1_w_4);
                o.texcoord1.xyz = ((r1_w_5.xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, r0_xyzw_5.xyzx)).xyz;
                float4 worldPos_xyzw_6 = mad(unity_ObjectToWorld[3], i.position0.wwww, r0_xyzw_5);
                o.color0.xyzw = i.color0.xyzw;
                float4 clipPos_xyzw_5 = (worldPos_xyzw_6.yyyy * cb0_values[10].xyzw);
                float4 clipPos_xyzw_6 = mad(cb0_values[9].xyzw, worldPos_xyzw_6.xxxx, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb0_values[11].xyzw, worldPos_xyzw_6.zzzz, clipPos_xyzw_6);
                o.texcoord3.xyzw = mad(cb0_values[12].xyzw, worldPos_xyzw_6.wwww, clipPos_xyzw_7);
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program56Output frag(program56Input i)
            {
                program56Output o = (program56Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + unity_ObjectToWorld[0].xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 r2_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float3 r3_xyz_1 = normalize(r2_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_3 = ((((r4_xyzw_1.xyzx * cb0_values[13].xyzx)).xyzx * i.color0.xyzx)).xyz;
                float r1_w_3 = (cb0_values[14].y + 1);
                float r2_w_1 = (i.color0.x * 0.5);
                float r3_w_1 = saturate(i.color0.y);
                float4 r6_xyzw_4 = (mad(cb0_values[11].xyzw, i.texcoord2.zzzz, mad(cb0_values[9].xyzw, i.texcoord2.xxxx, (i.texcoord2.yyyy * cb0_values[10].xyzw))) + cb0_values[12].xyzw);
                float r7_x_1 = cb4_values[9].z;
                float r7_y_1 = cb4_values[10].z;
                float r7_z_1 = cb4_values[11].z;
                float r2_x_2 = dot(r2_xyz_1.xyzx, float4(r7_x_1, r7_y_1, r7_z_1, r7_x_1));
                float3 r7_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_y_2 = dot(r7_xyz_2.xyzx, r7_xyz_2.xyzx);
                float r2_y_3 = sqrt(r2_y_2);
                float r2_y_4 = (-r2_x_2 + r2_y_3);
                float r2_x_4 = saturate(mad(mad(cb3_values[25].w, r2_y_4, r2_x_2), cb3_values[24].z, cb3_values[24].w));
                float r2_y_5 = (cb5_values[0].x == 1);
                float r7_x_12;
                float r7_y_12;
                float r7_z_12;
                float r7_w_4;
                if (r2_y_5)
                {
                    float r2_y_6 = (cb5_values[0].y == 1);
                    float3 r7_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r7_xyzw_10 = (((((r2_y_6.xxxx ? r7_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r7_y_10 = r7_xyzw_10.y;
                    float r7_z_10 = r7_xyzw_10.z;
                    float r7_w_2 = r7_xyzw_10.w;
                    float r2_y_7 = mad(r7_y_10, 0.25, 0.75);
                    float r2_z_2 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r7_x_10 = max(r2_z_2, r2_y_7);
                    float4 r7_xyzw_11 = t3.Sample(sampler_linear_clamp, (float4(r7_x_10, r7_z_10, r7_w_2, r7_x_10)).xyz);
                    r7_x_12 = r7_xyzw_11.x;
                    r7_y_12 = r7_xyzw_11.y;
                    r7_z_12 = r7_xyzw_11.z;
                    r7_w_4 = r7_xyzw_11.w;
                }
                else
                {
                    float4 r7_xyzw_3 = float4(1, 1, 1, 1);
                    r7_x_12 = r7_xyzw_3.x;
                    r7_y_12 = r7_xyzw_3.y;
                    r7_z_12 = r7_xyzw_3.z;
                    r7_w_4 = r7_xyzw_3.w;
                }
                float r2_y_9 = saturate(dot(float4(r7_x_12, r7_y_12, r7_z_12, r7_w_4), unity_OcclusionMaskSelector));
                float r2_z_4 = (r2_x_4 < 0.99);
                float r2_z_11;
                if (r2_z_4)
                {
                    float4 r7_xyzw_13 = (i.texcoord2.yyyy * cb3_values[9].xyzw);
                    float4 r7_xyzw_14 = mad(cb3_values[8].xyzw, i.texcoord2.xxxx, r7_xyzw_13);
                    float4 r7_xyzw_15 = mad(cb3_values[10].xyzw, i.texcoord2.zzzz, r7_xyzw_14);
                    float4 r7_xyzw_16 = (r7_xyzw_15 + cb3_values[11].xyzw);
                    float3 r7_xyz_17 = ((r7_xyzw_16.xyzx / r7_xyzw_16.wwww)).xyz;
                    float2 r8_xy_2 = (floor((mad(r7_xyz_17.xyxx, cb0_values[8].zwzz, float4(0.5, 0.5, 0, 0))).xyxx)).xy;
                    float2 r7_xy_18 = (mad(r7_xyz_17.xyxx, cb0_values[8].zwzz, -r8_xy_2.xyxx)).xy;
                    float4 r9_xyzw_1 = (r7_xy_18.xxyy + float4(0.5, 1, 0.5, 1));
                    float2 r10_xw_1 = ((r9_xyzw_1.xxxz * r9_xyzw_1.xxxz)).xw;
                    float2 r8_zw_1 = (mad(r10_xw_1.xxxy, float4(0, 0, 0.5, 0.5), -r7_xy_18.xxxy)).zw;
                    float2 r9_xz_2 = ((-r7_xy_18.xxyx + float4(1, 0, 1, 0))).xz;
                    float2 r11_xy_1 = (min(r7_xy_18.xyxx, float4(0, 0, 0, 0))).xy;
                    float2 r9_xz_3 = (mad(-r11_xy_1.xxyx, r11_xy_1.xxyx, r9_xz_2.xxyx)).xz;
                    float2 r7_xy_19 = (max(r7_xy_18.xyxx, float4(0, 0, 0, 0))).xy;
                    float2 r7_xy_20 = (mad(-r7_xy_19.xyxx, r7_xy_19.xyxx, r9_xyzw_1.ywyy)).xy;
                    float r11_x_2 = r8_zw_1.x;
                    float r11_y_2 = r9_xz_3.x;
                    float r11_z_1 = r7_xy_20.x;
                    float r11_w_1 = r10_xw_1.x;
                    float4 r11_xyzw_3 = (float4(r11_x_2, r11_y_2, r11_z_1, r11_w_1) * float4(0.44444, 0.44444, 0.44444, 0.22222));
                    float r10_x_2 = r8_zw_1.y;
                    float r10_y_1 = r9_xz_3.y;
                    float r10_z_1 = r7_xy_20.y;
                    float4 r9_xyzw_4 = (float4(r10_x_2, r10_y_1, r10_z_1, r10_xw_1.y) * float4(0.44444, 0.44444, 0.44444, 0.22222));
                    float4 r10_xyzw_3 = (r11_xyzw_3.ywyw + r11_xyzw_3.xzxz);
                    float4 r12_xyzw_1 = (r9_xyzw_4.yyww + r9_xyzw_4.xxzz);
                    float2 r8_zw_2 = ((r9_xyzw_4.yyyw / r12_xyzw_1.yyyw)).zw;
                    float2 r8_zw_3 = ((r8_zw_2.xxxy + float4(0, 0, -1.5, 0.5))).zw;
                    float4 r9_xyzw_5 = (((((r11_xyzw_3.ywyy / r10_xyzw_3.zwzz)).xyxx + float4(-1.5, 0.5, 0, 0))).xyxx * cb0_values[8].xxxx);
                    float r9_x_5 = r9_xyzw_5.x;
                    float r9_y_3 = r9_xyzw_5.y;
                    float r9_z_5 = ((r8_zw_3.xxxy * cb0_values[8].yyyy)).z;
                    float r9_w_3 = ((r8_zw_3.xxxy * cb0_values[8].yyyy)).w;
                    float4 r10_xyzw_4 = (r10_xyzw_3 * r12_xyzw_1);
                    float4 r11_xyzw_4 = mad(r8_xy_2.xyxy, cb0_values[8].xyxy, float4(r9_x_5, r9_z_5, r9_y_3, r9_z_5));
                    float r2_z_6 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r11_xyzw_4.xyxx).xy, r7_xyz_17.z);
                    float r4_w_2 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r11_xyzw_4.zwzz).xy, r7_xyz_17.z);
                    float r4_w_3 = (r4_w_2 * r10_xyzw_4.y);
                    float r2_z_7 = mad(r10_xyzw_4.x, r2_z_6, r4_w_3);
                    float4 r8_xyzw_3 = mad(r8_xy_2.xyxy, cb0_values[8].xyxy, float4(r9_x_5, r9_w_3, r9_y_3, r9_w_3));
                    float r4_w_4 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r8_xyzw_3.xyxx).xy, r7_xyz_17.z);
                    float r2_z_8 = mad(r10_xyzw_4.z, r4_w_4, r2_z_7);
                    float r4_w_5 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r8_xyzw_3.zwzz).xy, r7_xyz_17.z);
                    float r2_z_9 = mad(r10_xyzw_4.w, r4_w_5, r2_z_8);
                    float r4_w_6 = (-cb3_values[24].x + 1);
                    float r2_z_10 = mad(r2_z_9, r4_w_6, cb3_values[24].x);
                    r2_z_11 = r2_z_10;
                }
                else
                {
                    float r2_z_5 = 1;
                    r2_z_11 = r2_z_5;
                }
                float r2_y_10 = (-r2_z_11 + r2_y_9);
                float r2_y_11 = (0 < r6_xyzw_4.z);
                float r2_y_12 = asfloat(asint(r2_y_11) & asint(1065353216));
                float4 r7_xyzw_26 = t1.Sample(sampler_linear_clamp2, (((((r6_xyzw_4.xyxx / r6_xyzw_4.wwww)).xyxx + float4(0.5, 0.5, 0, 0))).xyxx).xy);
                float r2_y_13 = (r2_y_12 * r7_xyzw_26.w);
                float r2_z_12 = dot(r6_xyzw_4.xyzx, r6_xyzw_4.xyzx);
                float4 r6_xyzw_5 = t2.Sample(sampler_linear_clamp3, (r2_z_12.xxxx).xy);
                float r2_y_14 = (r2_y_13 * r6_xyzw_5.x);
                float4 r2_xyzw_7 = (((mad(r2_x_4, r2_y_10, r2_z_11) * r2_y_14)).xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_15 = r2_xyzw_7.y;
                float r2_z_13 = r2_xyzw_7.z;
                float3 unitWorldNormal_xyz_6 = normalize(i.texcoord1);
                float3 r4_xyz_5 = (mad(r2_w_1.xxxx, (mad(r4_xyz_3.xyzx, r1_w_3.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_4 = mad(-i.color0.x, 0.48, 0.96);
                float r1_w_5 = (-r3_w_1 + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, r3_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(unitWorldNormal_xyz_6.xyzx, r3_xyz_1.xyzx);
                float r2_w_2 = saturate(dot(unitWorldNormal_xyz_6.xyzx, r1_xyz_1.xyzx));
                float r3_x_2 = saturate(dot(unitWorldNormal_xyz_6.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_5.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_2 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_5 * r1_w_5);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(r0_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * mad(r2_w_2, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_2, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r3_x_2, r0_z_9, -r3_x_2), r3_x_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_w_2.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_w_11 = dot(r4_xyz_5.xyzx, r4_xyz_5.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_15 = (r0_w_13 * r0_z_14);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r2_x_7, r2_y_15, r2_z_13, r2_x_7));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r2_x_7, r2_x_7, r2_y_15, r2_z_13) * r0_z_15.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_16 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_6 = (r0_x_5 * r0_x_5);
                float r1_w_7 = (r1_w_6 * r1_w_6);
                float4 r2_xyzw_8 = (-r4_xyz_5.xyzx + float4(1, 1, 1, 0));
                float r2_x_8 = r2_xyzw_8.x;
                float r2_y_16 = r2_xyzw_8.y;
                float r2_z_14 = r2_xyzw_8.z;
                float4 r2_xyzw_9 = mad(float4(r2_x_8, r2_y_16, r2_z_14, r2_x_8), ((r0_x_5 * r1_w_7)).xxxx, r4_xyz_5.xyzx);
                float r2_x_9 = r2_xyzw_9.x;
                float r2_y_17 = r2_xyzw_9.y;
                float r2_z_15 = r2_xyzw_9.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_16, r0_w_14, r0_y_10) * float4(r2_x_9, r2_y_17, r2_z_15, r2_x_9));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_17 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_4.xxxx * ((r1_w_3.xxxx * r4_xyz_3.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_17, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                float4 r1_xyzw_12 = mad(float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8), i.color0.xyzx, -float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8));
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_6 = r1_xyzw_12.y;
                float r1_z_3 = r1_xyzw_12.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_12, r1_y_6, r1_z_3, r1_x_12), float4(0.25, 0.25, 0.25, 0), float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8))).xyz;
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
                float _Wave;
                float _VertexColorBoost;
                float4 _MainTex_ST;
                float4 cb0_values[11];
            };
            cbuffer _UnityPerCameraCB_b1
            {
                float4 _Time : packoffset(c0);
                float3 _WorldSpaceCameraPos : packoffset(c4);
            };
            cbuffer _UnityPerDrawCB_b2
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_OcclusionMaskSelector : packoffset(c46);
            };
            cbuffer _UnityPerFrameCB_b3
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
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
            struct program32Input
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
            struct program32Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program55Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program55Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program32Output vert(program32Input i)
            {
                program32Output o = (program32Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 r0_xyzw_3 = ((sin(mad(i.position0.x, 8, _Time.y))).xxxx * i.normal0.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = mad(float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3), cb0_values[9].xxxx, i.position0.xyzx);
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_2 = r0_xyzw_4.y;
                float r0_z_2 = r0_xyzw_4.z;
                float4 r0_xyzw_5 = mad(unity_ObjectToWorld[2], r0_z_2.xxxx, mad(unity_ObjectToWorld[0], r0_x_4.xxxx, (r0_y_2.xxxx * unity_ObjectToWorld[1])));
                float4 r1_xyzw_3 = (r0_xyzw_5 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(r1_xyzw_3);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                float worldNormal_x_4 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_4 = dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4));
                float r1_w_5 = rsqrt(r1_w_4);
                o.texcoord1.xyz = ((r1_w_5.xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, r0_xyzw_5.xyzx)).xyz;
                float4 worldPos_xyzw_6 = mad(unity_ObjectToWorld[3], i.position0.wwww, r0_xyzw_5);
                o.color0.xyzw = i.color0.xyzw;
                float4 clipPos_xyzw_5 = (worldPos_xyzw_6.yyyy * cb0_values[5].xyzw);
                float4 clipPos_xyzw_6 = mad(_Color, worldPos_xyzw_6.xxxx, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(_MainTex_ST, worldPos_xyzw_6.zzzz, clipPos_xyzw_6);
                o.texcoord3.xyzw = mad(cb0_values[7].xyzw, worldPos_xyzw_6.wwww, clipPos_xyzw_7);
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program55Output frag(program55Input i)
            {
                program55Output o = (program55Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + unity_ObjectToWorld[0].xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 r2_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float3 r3_xyz_1 = normalize(r2_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_3 = ((((r4_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * i.color0.xyzx)).xyz;
                float r1_w_3 = (cb0_values[9].y + 1);
                float r2_w_1 = (i.color0.x * 0.5);
                float r3_w_1 = saturate(i.color0.y);
                float4 r6_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord2.zzzz, mad(cb0_values[4].xyzw, i.texcoord2.xxxx, (i.texcoord2.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r7_x_1 = cb4_values[9].z;
                float r7_y_1 = cb4_values[10].z;
                float r7_z_1 = cb4_values[11].z;
                float r2_x_2 = dot(r2_xyz_1.xyzx, float4(r7_x_1, r7_y_1, r7_z_1, r7_x_1));
                float3 r7_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_y_2 = dot(r7_xyz_2.xyzx, r7_xyz_2.xyzx);
                float r2_y_3 = sqrt(r2_y_2);
                float r2_y_4 = (-r2_x_2 + r2_y_3);
                float r2_y_5 = (cb5_values[0].x == 1);
                float r7_x_12;
                float r7_y_12;
                float r7_z_12;
                float r7_w_4;
                if (r2_y_5)
                {
                    float r2_y_6 = (cb5_values[0].y == 1);
                    float3 r7_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r7_xyzw_10 = (((((r2_y_6.xxxx ? r7_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r7_y_10 = r7_xyzw_10.y;
                    float r7_z_10 = r7_xyzw_10.z;
                    float r7_w_2 = r7_xyzw_10.w;
                    float r2_y_7 = mad(r7_y_10, 0.25, 0.75);
                    float r2_z_2 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r7_x_10 = max(r2_z_2, r2_y_7);
                    float4 r7_xyzw_11 = t3.Sample(sampler_linear_clamp, (float4(r7_x_10, r7_z_10, r7_w_2, r7_x_10)).xyz);
                    r7_x_12 = r7_xyzw_11.x;
                    r7_y_12 = r7_xyzw_11.y;
                    r7_z_12 = r7_xyzw_11.z;
                    r7_w_4 = r7_xyzw_11.w;
                }
                else
                {
                    float4 r7_xyzw_3 = float4(1, 1, 1, 1);
                    r7_x_12 = r7_xyzw_3.x;
                    r7_y_12 = r7_xyzw_3.y;
                    r7_z_12 = r7_xyzw_3.z;
                    r7_w_4 = r7_xyzw_3.w;
                }
                float r2_y_9 = saturate(dot(float4(r7_x_12, r7_y_12, r7_z_12, r7_w_4), unity_OcclusionMaskSelector));
                float4 r7_xyzw_13 = (i.texcoord2.yyyy * cb3_values[9].xyzw);
                float4 r7_xyzw_14 = mad(cb3_values[8].xyzw, i.texcoord2.xxxx, r7_xyzw_13);
                float4 r7_xyzw_15 = mad(cb3_values[10].xyzw, i.texcoord2.zzzz, r7_xyzw_14);
                float4 r7_xyzw_16 = (r7_xyzw_15 + cb3_values[11].xyzw);
                float3 r7_xyz_17 = ((r7_xyzw_16.xyzx / r7_xyzw_16.wwww)).xyz;
                float r2_z_4 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r7_xyz_17.xyxx).xy, r7_xyz_17.z);
                float r4_w_2 = (-cb3_values[24].x + 1);
                float r2_z_5 = mad(r2_z_4, r4_w_2, cb3_values[24].x);
                float r2_y_10 = (-r2_z_5 + r2_y_9);
                float r2_y_11 = (0 < r6_xyzw_4.z);
                float r2_y_12 = asfloat(asint(r2_y_11) & asint(1065353216));
                float4 r7_xyzw_20 = t1.Sample(sampler_linear_clamp2, (((((r6_xyzw_4.xyxx / r6_xyzw_4.wwww)).xyxx + float4(0.5, 0.5, 0, 0))).xyxx).xy);
                float r2_y_13 = (r2_y_12 * r7_xyzw_20.w);
                float r2_z_6 = dot(r6_xyzw_4.xyzx, r6_xyzw_4.xyzx);
                float4 r6_xyzw_5 = t2.Sample(sampler_linear_clamp3, (r2_z_6.xxxx).xy);
                float r2_y_14 = (r2_y_13 * r6_xyzw_5.x);
                float4 r2_xyzw_7 = (((mad(saturate(mad(mad(cb3_values[25].w, r2_y_4, r2_x_2), cb3_values[24].z, cb3_values[24].w)), r2_y_10, r2_z_5) * r2_y_14)).xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_15 = r2_xyzw_7.y;
                float r2_z_7 = r2_xyzw_7.z;
                float3 unitWorldNormal_xyz_6 = normalize(i.texcoord1);
                float3 r4_xyz_5 = (mad(r2_w_1.xxxx, (mad(r4_xyz_3.xyzx, r1_w_3.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_4 = mad(-i.color0.x, 0.48, 0.96);
                float r1_w_5 = (-r3_w_1 + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, r3_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(unitWorldNormal_xyz_6.xyzx, r3_xyz_1.xyzx);
                float r2_w_2 = saturate(dot(unitWorldNormal_xyz_6.xyzx, r1_xyz_1.xyzx));
                float r3_x_2 = saturate(dot(unitWorldNormal_xyz_6.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_5.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_w_2 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_5 * r1_w_5);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(r0_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * mad(r2_w_2, r1_x_6, r0_z_8));
                float r0_w_8 = mad(r2_w_2, r1_y_4, r0_w_7);
                float r0_w_9 = (r0_w_8 + 1E-05);
                float r0_w_10 = (0.5 / r0_w_9);
                float r0_z_9 = (r0_z_8 * r0_z_8);
                float r1_x_9 = mad(mad(r3_x_2, r0_z_9, -r3_x_2), r3_x_2, 1);
                float r0_z_10 = (r0_z_9 * 0.31830987);
                float r0_z_11 = (r0_z_10 / mad(r1_x_9, r1_x_9, 1E-07));
                float r0_z_12 = (r0_z_11 * r0_w_10);
                float r0_z_13 = (r0_z_12 * 3.1415927);
                float4 r0_xyzw_9 = (r2_w_2.xxxx * float4(r0_y_8, r0_y_8, r0_z_13, r0_y_8));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_w_11 = dot(r4_xyz_5.xyzx, r4_xyz_5.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_15 = (r0_w_13 * r0_z_14);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r2_x_7, r2_y_15, r2_z_7, r2_x_7));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r2_x_7, r2_x_7, r2_y_15, r2_z_7) * r0_z_15.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_16 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_6 = (r0_x_5 * r0_x_5);
                float r1_w_7 = (r1_w_6 * r1_w_6);
                float4 r2_xyzw_8 = (-r4_xyz_5.xyzx + float4(1, 1, 1, 0));
                float r2_x_8 = r2_xyzw_8.x;
                float r2_y_16 = r2_xyzw_8.y;
                float r2_z_8 = r2_xyzw_8.z;
                float4 r2_xyzw_9 = mad(float4(r2_x_8, r2_y_16, r2_z_8, r2_x_8), ((r0_x_5 * r1_w_7)).xxxx, r4_xyz_5.xyzx);
                float r2_x_9 = r2_xyzw_9.x;
                float r2_y_17 = r2_xyzw_9.y;
                float r2_z_9 = r2_xyzw_9.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_16, r0_w_14, r0_y_10) * float4(r2_x_9, r2_y_17, r2_z_9, r2_x_9));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_17 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_4.xxxx * ((r1_w_3.xxxx * r4_xyz_3.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_17, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                float4 r1_xyzw_12 = mad(float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8), i.color0.xyzx, -float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8));
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_6 = r1_xyzw_12.y;
                float r1_z_3 = r1_xyzw_12.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_12, r1_y_6, r1_z_3, r1_x_12), float4(0.25, 0.25, 0.25, 0), float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8))).xyz;
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
                float _Wave;
                float _VertexColorBoost;
                float4 _MainTex_ST;
                float4 cb0_values[11];
            };
            cbuffer _UnityPerCameraCB_b1
            {
                float4 _Time : packoffset(c0);
                float3 _WorldSpaceCameraPos : packoffset(c4);
            };
            cbuffer _UnityPerDrawCB_b2
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_OcclusionMaskSelector : packoffset(c46);
            };
            cbuffer _UnityPerFrameCB_b3
            {
                float4 unity_ProbeVolumeParams : packoffset(c0);
                float4x4 unity_ProbeVolumeWorldToObject : packoffset(c1);
                float3 unity_ProbeVolumeSizeInv : packoffset(c5);
                float3 unity_ProbeVolumeMin : packoffset(c6);
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            Texture3D t2;
            struct program31Input
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
            struct program31Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program54Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program54Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program31Output vert(program31Input i)
            {
                program31Output o = (program31Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 r0_xyzw_3 = ((sin(mad(i.position0.x, 8, _Time.y))).xxxx * i.normal0.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = mad(float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3), cb0_values[9].xxxx, i.position0.xyzx);
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_2 = r0_xyzw_4.y;
                float r0_z_2 = r0_xyzw_4.z;
                float4 r0_xyzw_5 = mad(unity_ObjectToWorld[2], r0_z_2.xxxx, mad(unity_ObjectToWorld[0], r0_x_4.xxxx, (r0_y_2.xxxx * unity_ObjectToWorld[1])));
                float4 r1_xyzw_3 = (r0_xyzw_5 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(r1_xyzw_3);
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, r0_xyzw_5);
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, r0_xyzw_5.xyzx)).xyz;
                float4 clipPos_xyzw_6 = (worldPos_xyzw_4.yyyy * cb0_values[5].xyxx);
                float clipPos_x_6 = clipPos_xyzw_6.x;
                float clipPos_y_4 = clipPos_xyzw_6.y;
                float4 clipPos_xyzw_7 = mad(_Color.xyxx, worldPos_xyzw_4.xxxx, float4(clipPos_x_6, clipPos_y_4, clipPos_x_6, clipPos_x_6));
                float clipPos_x_7 = clipPos_xyzw_7.x;
                float clipPos_y_5 = clipPos_xyzw_7.y;
                float4 clipPos_xyzw_8 = mad(_MainTex_ST.xyxx, worldPos_xyzw_4.zzzz, float4(clipPos_x_7, clipPos_y_5, clipPos_x_7, clipPos_x_7));
                float clipPos_x_8 = clipPos_xyzw_8.x;
                float clipPos_y_6 = clipPos_xyzw_8.y;
                o.texcoord3.xy = (mad(cb0_values[7].xxxy, worldPos_xyzw_4.wwww, float4(clipPos_x_8, clipPos_x_8, clipPos_x_8, clipPos_y_6))).zw;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                float worldNormal_x_9 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_2 = dot(float4(worldNormal_x_9, worldNormal_y_7, worldNormal_z_4, worldNormal_x_9), float4(worldNormal_x_9, worldNormal_y_7, worldNormal_z_4, worldNormal_x_9));
                float r0_w_3 = rsqrt(r0_w_2);
                o.texcoord1.xyz = ((r0_w_3.xxxx * float4(worldNormal_x_9, worldNormal_y_7, worldNormal_z_4, worldNormal_x_9))).xyz;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program54Output frag(program54Input i)
            {
                program54Output o = (program54Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_3 = ((((r2_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * i.color0.xyzx)).xyz;
                float r1_w_1 = (cb0_values[9].y + 1);
                float r2_w_2 = (i.color0.x * 0.5);
                float r3_w_1 = saturate(i.color0.y);
                float r4_z_1 = (unity_ProbeVolumeParams.x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r4_z_1)
                {
                    float r4_z_2 = (unity_ProbeVolumeParams.y == 1);
                    float3 r5_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r4_z_2.xxxx ? r5_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r5_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r4_z_3 = mad(r5_y_8, 0.25, 0.75);
                    float r4_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r5_x_8 = max(r4_w_1, r4_z_3);
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
                float r4_z_5 = saturate(dot(float4(r5_x_10, r5_y_10, r5_z_10, r5_w_4), unity_OcclusionMaskSelector));
                float4 r5_xyzw_11 = t1.Sample(sampler_linear_clamp1, ((((mad(cb0_values[6].xyxx, i.texcoord2.zzzz, (mad(cb0_values[4].xyxx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx).xy);
                float4 r4_xyzw_6 = (((r4_z_5 * r5_xyzw_11.w)).xxxx * _LightColor0.xyzx);
                float r4_x_6 = r4_xyzw_6.x;
                float r4_y_5 = r4_xyzw_6.y;
                float r4_z_6 = r4_xyzw_6.z;
                float3 unitClipPos_xyz_12 = normalize(i.texcoord1);
                float3 r2_xyz_5 = (mad(r2_w_2.xxxx, (mad(r2_xyz_3.xyzx, r1_w_1.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_2 = mad(-i.color0.x, 0.48, 0.96);
                float r1_w_3 = (-r3_w_1 + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unity_ObjectToWorld[0].xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(unitClipPos_xyz_12.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx);
                float r1_x_2 = saturate(dot(unitClipPos_xyz_12.xyzx, unity_ObjectToWorld[0].xyzx));
                float r1_y_2 = saturate(dot(unitClipPos_xyz_12.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(unity_ObjectToWorld[0].xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_3.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(r0_w_6) + 1);
                float r2_w_3 = (r1_z_4 * r1_z_4);
                float r2_w_4 = (r2_w_3 * r2_w_3);
                float r1_z_5 = (r1_z_4 * r2_w_4);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_3 * r1_w_3);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_z_6 = (-r0_z_8 + 1);
                float r1_w_4 = mad(abs(r0_w_6), r1_z_6, r0_z_8);
                float r1_z_7 = mad(r1_x_2, r1_z_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * r1_z_7);
                float r0_w_8 = mad(r1_x_2, r1_w_4, r0_w_7);
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
                float r0_w_11 = dot(r2_xyz_5.xyzx, r2_xyz_5.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_15 = (r0_w_13 * r0_z_14);
                float4 r1_xyzw_3 = (r0_y_9.xxxx * float4(r4_x_6, r4_y_5, r4_z_6, r4_x_6));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_5 = r1_xyzw_3.y;
                float r1_z_9 = r1_xyzw_3.z;
                float4 r0_xyzw_10 = (float4(r4_x_6, r4_x_6, r4_y_5, r4_z_6) * r0_z_15.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_16 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_5 = (r0_x_5 * r0_x_5);
                float r1_w_6 = (r1_w_5 * r1_w_5);
                float4 r4_xyzw_7 = (-r2_xyz_5.xyzx + float4(1, 1, 1, 0));
                float r4_x_7 = r4_xyzw_7.x;
                float r4_y_6 = r4_xyzw_7.y;
                float r4_z_7 = r4_xyzw_7.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_16, r0_w_14, r0_y_10) * (mad(float4(r4_x_7, r4_y_6, r4_z_7, r4_x_7), ((r0_x_5 * r1_w_6)).xxxx, r2_xyz_5.xyzx)).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_17 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_2.xxxx * ((r1_w_1.xxxx * r2_xyz_3.xyzx)).xyzx)).xyzx, float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_7, r0_y_11, r0_z_17, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                float4 r1_xyzw_4 = mad(float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8), i.color0.xyzx, -float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_6 = r1_xyzw_4.y;
                float r1_z_10 = r1_xyzw_4.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_4, r1_y_6, r1_z_10, r1_x_4), float4(0.25, 0.25, 0.25, 0), float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8))).xyz;
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
                float _Wave;
                float _VertexColorBoost;
                float4 _MainTex_ST;
                float4 cb0_values[11];
            };
            cbuffer _UnityPerCameraCB_b1
            {
                float4 _Time : packoffset(c0);
                float3 _WorldSpaceCameraPos : packoffset(c4);
            };
            cbuffer _UnityPerDrawCB_b2
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_OcclusionMaskSelector : packoffset(c46);
            };
            cbuffer _UnityPerFrameCB_b3
            {
                float4 unity_ProbeVolumeParams : packoffset(c0);
                float4x4 unity_ProbeVolumeWorldToObject : packoffset(c1);
                float3 unity_ProbeVolumeSizeInv : packoffset(c5);
                float3 unity_ProbeVolumeMin : packoffset(c6);
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            TextureCube t2;
            Texture3D t3;
            struct program30Input
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
            struct program30Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program53Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program53Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program30Output vert(program30Input i)
            {
                program30Output o = (program30Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 r0_xyzw_3 = ((sin(mad(i.position0.x, 8, _Time.y))).xxxx * i.normal0.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = mad(float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3), cb0_values[9].xxxx, i.position0.xyzx);
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_2 = r0_xyzw_4.y;
                float r0_z_2 = r0_xyzw_4.z;
                float4 r0_xyzw_5 = mad(unity_ObjectToWorld[2], r0_z_2.xxxx, mad(unity_ObjectToWorld[0], r0_x_4.xxxx, (r0_y_2.xxxx * unity_ObjectToWorld[1])));
                float4 r1_xyzw_3 = (r0_xyzw_5 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(r1_xyzw_3);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                float worldNormal_x_4 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_4 = dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4));
                float r1_w_5 = rsqrt(r1_w_4);
                o.texcoord1.xyz = ((r1_w_5.xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, r0_xyzw_5.xyzx)).xyz;
                float4 worldPos_xyzw_6 = mad(unity_ObjectToWorld[3], i.position0.wwww, r0_xyzw_5);
                o.color0.xyzw = i.color0.xyzw;
                float3 clipPos_xyz_5 = ((worldPos_xyzw_6.yyyy * cb0_values[5].xyzx)).xyz;
                float3 clipPos_xyz_6 = (mad(_Color.xyzx, worldPos_xyzw_6.xxxx, clipPos_xyz_5.xyzx)).xyz;
                float4 clipPos_xyzw_7 = mad(_MainTex_ST.xyzx, worldPos_xyzw_6.zzzz, clipPos_xyz_6.xyzx);
                float clipPos_x_7 = clipPos_xyzw_7.x;
                float clipPos_y_5 = clipPos_xyzw_7.y;
                float clipPos_z_5 = clipPos_xyzw_7.z;
                o.texcoord3.xyz = (mad(cb0_values[7].xyzx, worldPos_xyzw_6.wwww, float4(clipPos_x_7, clipPos_y_5, clipPos_z_5, clipPos_x_7))).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program53Output frag(program53Input i)
            {
                program53Output o = (program53Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + unity_ObjectToWorld[0].xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 r2_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float3 r2_xyz_2 = normalize(r2_xyz_1);
                float4 r3_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r3_xyz_3 = ((((r3_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * i.color0.xyzx)).xyz;
                float r1_w_3 = (cb0_values[9].y + 1);
                float r2_w_1 = (i.color0.x * 0.5);
                float r3_w_2 = saturate(i.color0.y);
                float3 r5_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r4_w_1 = (unity_ProbeVolumeParams.x == 1);
                float r6_x_10;
                float r6_y_10;
                float r6_z_10;
                float r6_w_4;
                if (r4_w_1)
                {
                    float r4_w_2 = (unity_ProbeVolumeParams.y == 1);
                    float3 r6_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r4_w_2.xxxx ? r6_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r6_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r6_y_8 = r6_xyzw_8.y;
                    float r6_z_8 = r6_xyzw_8.z;
                    float r6_w_2 = r6_xyzw_8.w;
                    float r4_w_3 = mad(r6_y_8, 0.25, 0.75);
                    float r5_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r6_x_8 = max(r4_w_3, r5_w_1);
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
                float r4_w_5 = saturate(dot(float4(r6_x_10, r6_y_10, r6_z_10, r6_w_4), unity_OcclusionMaskSelector));
                float r5_w_3 = dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx);
                float4 r6_xyzw_11 = t1.Sample(sampler_linear_clamp2, (r5_w_3.xxxx).xy);
                float4 r5_xyzw_5 = t2.Sample(sampler_linear_clamp1, r5_xyz_4.xyz);
                float r4_w_6 = (r4_w_5 * (r5_xyzw_5.w * r6_xyzw_11.x));
                float4 r5_xyzw_7 = (r4_w_6.xxxx * _LightColor0.xyzx);
                float r5_x_7 = r5_xyzw_7.x;
                float r5_y_6 = r5_xyzw_7.y;
                float r5_z_6 = r5_xyzw_7.z;
                float3 unitWorldNormal_xyz_12 = normalize(i.texcoord1);
                float3 r3_xyz_5 = (mad(r2_w_1.xxxx, (mad(r3_xyz_3.xyzx, r1_w_3.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_4 = mad(-i.color0.x, 0.48, 0.96);
                float r1_w_5 = (-r3_w_2 + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, r2_xyz_2.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(unitWorldNormal_xyz_12.xyzx, r2_xyz_2.xyzx);
                float r2_x_3 = saturate(dot(unitWorldNormal_xyz_12.xyzx, r1_xyz_1.xyzx));
                float r2_y_3 = saturate(dot(unitWorldNormal_xyz_12.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_5.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_x_3 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_5 * r1_w_5);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(r0_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * mad(r2_x_3, r1_x_6, r0_z_8));
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
                float r0_w_11 = dot(r3_xyz_5.xyzx, r3_xyz_5.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_15 = (r0_w_13 * r0_z_14);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r5_x_7, r5_y_6, r5_z_6, r5_x_7));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r5_x_7, r5_x_7, r5_y_6, r5_z_6) * r0_z_15.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_16 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_6 = (r0_x_5 * r0_x_5);
                float r1_w_7 = (r1_w_6 * r1_w_6);
                float4 r2_xyzw_4 = (-r3_xyz_5.xyzx + float4(1, 1, 1, 0));
                float r2_x_4 = r2_xyzw_4.x;
                float r2_y_4 = r2_xyzw_4.y;
                float r2_z_3 = r2_xyzw_4.z;
                float4 r2_xyzw_5 = mad(float4(r2_x_4, r2_y_4, r2_z_3, r2_x_4), ((r0_x_5 * r1_w_7)).xxxx, r3_xyz_5.xyzx);
                float r2_x_5 = r2_xyzw_5.x;
                float r2_y_5 = r2_xyzw_5.y;
                float r2_z_4 = r2_xyzw_5.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_16, r0_w_14, r0_y_10) * float4(r2_x_5, r2_y_5, r2_z_4, r2_x_5));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_17 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_4.xxxx * ((r1_w_3.xxxx * r3_xyz_3.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_17, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                float4 r1_xyzw_12 = mad(float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8), i.color0.xyzx, -float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8));
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_6 = r1_xyzw_12.y;
                float r1_z_3 = r1_xyzw_12.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_12, r1_y_6, r1_z_3, r1_x_12), float4(0.25, 0.25, 0.25, 0), float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8))).xyz;
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
                float _Wave;
                float _VertexColorBoost;
                float4 _MainTex_ST;
                float4 cb0_values[11];
            };
            cbuffer _UnityPerCameraCB_b1
            {
                float4 _Time : packoffset(c0);
                float3 _WorldSpaceCameraPos : packoffset(c4);
            };
            cbuffer _UnityPerDrawCB_b2
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_OcclusionMaskSelector : packoffset(c46);
            };
            cbuffer _UnityPerFrameCB_b3
            {
                float4 unity_ProbeVolumeParams : packoffset(c0);
                float4x4 unity_ProbeVolumeWorldToObject : packoffset(c1);
                float3 unity_ProbeVolumeSizeInv : packoffset(c5);
                float3 unity_ProbeVolumeMin : packoffset(c6);
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
            Texture2D t2;
            Texture3D t3;
            struct program29Input
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
            struct program29Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program52Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program52Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program29Output vert(program29Input i)
            {
                program29Output o = (program29Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 r0_xyzw_3 = ((sin(mad(i.position0.x, 8, _Time.y))).xxxx * i.normal0.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = mad(float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3), cb0_values[9].xxxx, i.position0.xyzx);
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_2 = r0_xyzw_4.y;
                float r0_z_2 = r0_xyzw_4.z;
                float4 r0_xyzw_5 = mad(unity_ObjectToWorld[2], r0_z_2.xxxx, mad(unity_ObjectToWorld[0], r0_x_4.xxxx, (r0_y_2.xxxx * unity_ObjectToWorld[1])));
                float4 r1_xyzw_3 = (r0_xyzw_5 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(r1_xyzw_3);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                float worldNormal_x_4 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_4 = dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4));
                float r1_w_5 = rsqrt(r1_w_4);
                o.texcoord1.xyz = ((r1_w_5.xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, r0_xyzw_5.xyzx)).xyz;
                float4 worldPos_xyzw_6 = mad(unity_ObjectToWorld[3], i.position0.wwww, r0_xyzw_5);
                o.color0.xyzw = i.color0.xyzw;
                float4 clipPos_xyzw_5 = (worldPos_xyzw_6.yyyy * cb0_values[5].xyzw);
                float4 clipPos_xyzw_6 = mad(_Color, worldPos_xyzw_6.xxxx, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(_MainTex_ST, worldPos_xyzw_6.zzzz, clipPos_xyzw_6);
                o.texcoord3.xyzw = mad(cb0_values[7].xyzw, worldPos_xyzw_6.wwww, clipPos_xyzw_7);
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program52Output frag(program52Input i)
            {
                program52Output o = (program52Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + unity_ObjectToWorld[0].xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 r2_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float3 r2_xyz_2 = normalize(r2_xyz_1);
                float4 r3_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r3_xyz_3 = ((((r3_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * i.color0.xyzx)).xyz;
                float r1_w_3 = (cb0_values[9].y + 1);
                float r2_w_1 = (i.color0.x * 0.5);
                float r3_w_2 = saturate(i.color0.y);
                float4 r5_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord2.zzzz, mad(cb0_values[4].xyzw, i.texcoord2.xxxx, (i.texcoord2.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r4_w_1 = (unity_ProbeVolumeParams.x == 1);
                float r6_x_10;
                float r6_y_11;
                float r6_z_10;
                float r6_w_4;
                if (r4_w_1)
                {
                    float r4_w_2 = (unity_ProbeVolumeParams.y == 1);
                    float3 r6_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r4_w_2.xxxx ? r6_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r6_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r6_y_8 = r6_xyzw_8.y;
                    float r6_z_8 = r6_xyzw_8.z;
                    float r6_w_2 = r6_xyzw_8.w;
                    float r4_w_3 = mad(r6_y_8, 0.25, 0.75);
                    float r6_y_9 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r6_x_8 = max(r4_w_3, r6_y_9);
                    float4 r6_xyzw_9 = t3.Sample(sampler_linear_clamp, (float4(r6_x_8, r6_z_8, r6_w_2, r6_x_8)).xyz);
                    r6_x_10 = r6_xyzw_9.x;
                    r6_y_11 = r6_xyzw_9.y;
                    r6_z_10 = r6_xyzw_9.z;
                    r6_w_4 = r6_xyzw_9.w;
                }
                else
                {
                    float4 r6_xyzw_10 = float4(1, 1, 1, 1);
                    r6_x_10 = r6_xyzw_10.x;
                    r6_y_11 = r6_xyzw_10.y;
                    r6_z_10 = r6_xyzw_10.z;
                    r6_w_4 = r6_xyzw_10.w;
                }
                float r4_w_5 = saturate(dot(float4(r6_x_10, r6_y_11, r6_z_10, r6_w_4), unity_OcclusionMaskSelector));
                float4 r6_xyzw_12 = (r5_xyzw_4.xxyx / r5_xyzw_4.wwww);
                float r6_y_12 = r6_xyzw_12.y;
                float r6_z_11 = r6_xyzw_12.z;
                float4 r6_xyzw_13 = (float4(r6_y_12, r6_y_12, r6_z_11, r6_y_12) + float4(0, 0.5, 0.5, 0));
                float r6_y_13 = r6_xyzw_13.y;
                float r6_z_12 = r6_xyzw_13.z;
                float4 r7_xyzw_1 = t1.Sample(sampler_linear_clamp1, (float4(r6_y_13, r6_z_12, r6_y_13, r6_y_13)).xy);
                float r5_w_5 = (asfloat(asint((float)((0 < r5_xyzw_4.z))) & asint(1065353216)) * r7_xyzw_1.w);
                float r6_x_13 = (t2.Sample(sampler_linear_clamp2, ((dot(r5_xyzw_4.xyzx, r5_xyzw_4.xyzx)).xxxx).xy)).x;
                float4 r6_xyzw_14 = t2.Sample(sampler_linear_clamp2, ((dot(r5_xyzw_4.xyzx, r5_xyzw_4.xyzx)).xxxx).xy);
                float r6_y_14 = r6_xyzw_14.y;
                float r6_z_13 = r6_xyzw_14.z;
                float r6_w_5 = r6_xyzw_14.w;
                float r4_w_6 = (r4_w_5 * (r5_w_5 * r6_x_13));
                float4 r5_xyzw_7 = (r4_w_6.xxxx * _LightColor0.xyzx);
                float r5_x_7 = r5_xyzw_7.x;
                float r5_y_5 = r5_xyzw_7.y;
                float r5_z_5 = r5_xyzw_7.z;
                float r4_w_7 = dot(i.texcoord1.xyzx, i.texcoord1.xyzx);
                float r4_w_8 = rsqrt(r4_w_7);
                float4 unitWorldNormal_xyzw_14 = (r4_w_8.xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_14 = unitWorldNormal_xyzw_14.x;
                float unitWorldNormal_y_15 = unitWorldNormal_xyzw_14.y;
                float unitWorldNormal_z_14 = unitWorldNormal_xyzw_14.z;
                float3 r3_xyz_5 = (mad(r2_w_1.xxxx, (mad(r3_xyz_3.xyzx, r1_w_3.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_4 = mad(-i.color0.x, 0.48, 0.96);
                float r1_w_5 = (-r3_w_2 + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, r2_xyz_2.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(unitWorldNormal_x_14, unitWorldNormal_y_15, unitWorldNormal_z_14, unitWorldNormal_x_14), r2_xyz_2.xyzx);
                float r2_x_3 = saturate(dot(float4(unitWorldNormal_x_14, unitWorldNormal_y_15, unitWorldNormal_z_14, unitWorldNormal_x_14), r1_xyz_1.xyzx));
                float r2_y_3 = saturate(dot(float4(unitWorldNormal_x_14, unitWorldNormal_y_15, unitWorldNormal_z_14, unitWorldNormal_x_14), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(r1_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_5.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r2_x_3 + 1);
                float r1_x_2 = (r0_z_4 * r0_z_4);
                float r0_z_5 = (r0_z_4 * (r1_x_2 * r1_x_2));
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_x_4 = (-abs(r0_w_6) + 1);
                float r1_y_2 = (r1_x_4 * r1_x_4);
                float r1_y_3 = (r1_y_2 * r1_y_2);
                float r0_y_7 = mad(r0_y_6, (r1_x_4 * r1_y_3), 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_5 * r1_w_5);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_x_6 = (-r0_z_8 + 1);
                float r1_y_4 = mad(abs(r0_w_6), r1_x_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * mad(r2_x_3, r1_x_6, r0_z_8));
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
                float r0_w_11 = dot(r3_xyz_5.xyzx, r3_xyz_5.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_15 = (r0_w_13 * r0_z_14);
                float4 r1_xyzw_11 = (r0_y_9.xxxx * float4(r5_x_7, r5_y_5, r5_z_5, r5_x_7));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_5 = r1_xyzw_11.y;
                float r1_z_2 = r1_xyzw_11.z;
                float4 r0_xyzw_10 = (float4(r5_x_7, r5_x_7, r5_y_5, r5_z_5) * r0_z_15.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_16 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_6 = (r0_x_5 * r0_x_5);
                float r1_w_7 = (r1_w_6 * r1_w_6);
                float4 r2_xyzw_4 = (-r3_xyz_5.xyzx + float4(1, 1, 1, 0));
                float r2_x_4 = r2_xyzw_4.x;
                float r2_y_4 = r2_xyzw_4.y;
                float r2_z_3 = r2_xyzw_4.z;
                float4 r2_xyzw_5 = mad(float4(r2_x_4, r2_y_4, r2_z_3, r2_x_4), ((r0_x_5 * r1_w_7)).xxxx, r3_xyz_5.xyzx);
                float r2_x_5 = r2_xyzw_5.x;
                float r2_y_5 = r2_xyzw_5.y;
                float r2_z_4 = r2_xyzw_5.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_16, r0_w_14, r0_y_10) * float4(r2_x_5, r2_y_5, r2_z_4, r2_x_5));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_17 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_4.xxxx * ((r1_w_3.xxxx * r3_xyz_3.xyzx)).xyzx)).xyzx, float4(r1_x_11, r1_y_5, r1_z_2, r1_x_11), float4(r0_x_7, r0_y_11, r0_z_17, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                float4 r1_xyzw_12 = mad(float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8), i.color0.xyzx, -float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8));
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_6 = r1_xyzw_12.y;
                float r1_z_3 = r1_xyzw_12.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_12, r1_y_6, r1_z_3, r1_x_12), float4(0.25, 0.25, 0.25, 0), float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8))).xyz;
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
                float _Wave;
                float _VertexColorBoost;
                float4 _MainTex_ST;
                float4 cb0_values[6];
            };
            cbuffer _UnityPerCameraCB_b1
            {
                float4 _Time : packoffset(c0);
                float3 _WorldSpaceCameraPos : packoffset(c4);
            };
            cbuffer _UnityPerDrawCB_b2
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_OcclusionMaskSelector : packoffset(c46);
            };
            cbuffer _UnityPerFrameCB_b3
            {
                float4 unity_ProbeVolumeParams : packoffset(c0);
                float4x4 unity_ProbeVolumeWorldToObject : packoffset(c1);
                float3 unity_ProbeVolumeSizeInv : packoffset(c5);
                float3 unity_ProbeVolumeMin : packoffset(c6);
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture3D t1;
            struct program28Input
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
            struct program28Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program51Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program51Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program28Output vert(program28Input i)
            {
                program28Output o = (program28Output)0;
                float4 r0_xyzw_3 = ((sin(mad(i.position0.x, 8, _Time.y))).xxxx * i.normal0.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = mad(float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3), _Wave.xxxx, i.position0.xyzx);
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_2 = r0_xyzw_4.y;
                float r0_z_2 = r0_xyzw_4.z;
                float4 r0_xyzw_5 = mad(unity_ObjectToWorld[2], r0_z_2.xxxx, mad(unity_ObjectToWorld[0], r0_x_4.xxxx, (r0_y_2.xxxx * unity_ObjectToWorld[1])));
                float4 r1_xyzw_3 = (r0_xyzw_5 + unity_ObjectToWorld[3]);
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, r0_xyzw_5.xyzx)).xyz;
                float4 r0_xyzw_6 = (r1_xyzw_3.yyyy * unity_MatrixVP[1]);
                float4 r0_xyzw_7 = mad(unity_MatrixVP[0], r1_xyzw_3.xxxx, r0_xyzw_6);
                float4 r0_xyzw_8 = mad(unity_MatrixVP[2], r1_xyzw_3.zzzz, r0_xyzw_7);
                o.sv_Position0.xyzw = mad(unity_MatrixVP[3], r1_xyzw_3.wwww, r0_xyzw_8);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_9 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_5 = dot(float4(worldNormal_x_9, worldNormal_y_7, worldNormal_z_7, worldNormal_x_9), float4(worldNormal_x_9, worldNormal_y_7, worldNormal_z_7, worldNormal_x_9));
                float r0_w_6 = rsqrt(r0_w_5);
                o.texcoord1.xyz = ((r0_w_6.xxxx * float4(worldNormal_x_9, worldNormal_y_7, worldNormal_z_7, worldNormal_x_9))).xyz;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program51Output frag(program51Input i)
            {
                program51Output o = (program51Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_3 = ((((r2_xyzw_1.xyzx * cb0_values[4].xyzx)).xyzx * i.color0.xyzx)).xyz;
                float r1_w_1 = (cb0_values[5].y + 1);
                float r2_w_2 = (i.color0.x * 0.5);
                float r3_w_1 = saturate(i.color0.y);
                float r4_x_8;
                float r4_y_11;
                float r4_z_10;
                float r4_w_8;
                if ((unity_ProbeVolumeParams.x == 1))
                {
                    float3 r4_yzw_2 = ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xxyz)).yzw;
                    float3 r4_yzw_3 = (mad(unity_ProbeVolumeWorldToObject[0].xxyz, i.texcoord2.xxxx, r4_yzw_2.xxyz)).yzw;
                    float3 r4_yzw_4 = (mad(unity_ProbeVolumeWorldToObject[2].xxyz, i.texcoord2.zzzz, r4_yzw_3.xxyz)).yzw;
                    float3 r4_yzw_5 = ((r4_yzw_4.xxyz + unity_ProbeVolumeWorldToObject[3].xxyz)).yzw;
                    float4 unity_ProbeVolumeParamsSelect_xyzw_4 = (((unity_ProbeVolumeParams.y == 1)).xxxx ? r4_yzw_5.xyzx : i.texcoord2.xyzx);
                    float unity_ProbeVolumeParamsSelect_x_4 = unity_ProbeVolumeParamsSelect_xyzw_4.x;
                    float unity_ProbeVolumeParamsSelect_y_6 = unity_ProbeVolumeParamsSelect_xyzw_4.y;
                    float unity_ProbeVolumeParamsSelect_z_6 = unity_ProbeVolumeParamsSelect_xyzw_4.z;
                    float4 r4_xyzw_5 = (float4(unity_ProbeVolumeParamsSelect_x_4, unity_ProbeVolumeParamsSelect_y_6, unity_ProbeVolumeParamsSelect_z_6, unity_ProbeVolumeParamsSelect_x_4) + -unity_ProbeVolumeMin.xyzx);
                    float r4_x_5 = r4_xyzw_5.x;
                    float r4_y_7 = r4_xyzw_5.y;
                    float r4_z_7 = r4_xyzw_5.z;
                    float4 r4_xyzw_8 = (float4(r4_x_5, r4_x_5, r4_y_7, r4_z_7) * unity_ProbeVolumeSizeInv.xxyz);
                    float r4_y_8 = r4_xyzw_8.y;
                    float r4_z_8 = r4_xyzw_8.z;
                    float r4_w_6 = r4_xyzw_8.w;
                    float r4_y_9 = mad(r4_y_8, 0.25, 0.75);
                    float r4_x_6 = max(r4_y_9, mad(unity_ProbeVolumeParams.z, 0.5, 0.75));
                    float4 r4_xyzw_7 = t1.Sample(sampler_linear_clamp, (float4(r4_x_6, r4_z_8, r4_w_6, r4_x_6)).xyz);
                    r4_x_8 = r4_xyzw_7.x;
                    r4_y_11 = r4_xyzw_7.y;
                    r4_z_10 = r4_xyzw_7.z;
                    r4_w_8 = r4_xyzw_7.w;
                }
                else
                {
                    float4 r4_xyzw_2 = float4(1, 1, 1, 1);
                    r4_x_8 = r4_xyzw_2.x;
                    r4_y_11 = r4_xyzw_2.y;
                    r4_z_10 = r4_xyzw_2.z;
                    r4_w_8 = r4_xyzw_2.w;
                }
                float4 r4_xyzw_10 = ((saturate(dot(float4(r4_x_8, r4_y_11, r4_z_10, r4_w_8), unity_OcclusionMaskSelector))).xxxx * _LightColor0.xyzx);
                float r4_x_10 = r4_xyzw_10.x;
                float r4_y_12 = r4_xyzw_10.y;
                float r4_z_11 = r4_xyzw_10.z;
                float r4_w_9 = dot(i.texcoord1.xyzx, i.texcoord1.xyzx);
                float r4_w_10 = rsqrt(r4_w_9);
                float4 unitWorldNormal_xyzw_3 = (r4_w_10.xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float3 r2_xyz_5 = (mad(r2_w_2.xxxx, (mad(r2_xyz_3.xyzx, r1_w_1.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float r1_w_2 = mad(-i.color0.x, 0.48, 0.96);
                float r1_w_3 = (-r3_w_1 + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unity_ObjectToWorld[0].xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx);
                float r1_x_2 = saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), unity_ObjectToWorld[0].xyzx));
                float r1_y_2 = saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(unity_ObjectToWorld[0].xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_y_5 = dot(r0_y_4.xxxx, r1_w_3.xxxx);
                float r0_y_6 = (r0_y_5 + -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_6, r0_z_5, 1);
                float r1_z_4 = (-abs(r0_w_6) + 1);
                float r2_w_3 = (r1_z_4 * r1_z_4);
                float r2_w_4 = (r2_w_3 * r2_w_3);
                float r1_z_5 = (r1_z_4 * r2_w_4);
                float r0_y_7 = mad(r0_y_6, r1_z_5, 1);
                float r0_y_8 = (r0_y_7 * r0_z_6);
                float r0_z_7 = (r1_w_3 * r1_w_3);
                float r0_z_8 = max(r0_z_7, 0.002);
                float r1_z_6 = (-r0_z_8 + 1);
                float r1_w_4 = mad(abs(r0_w_6), r1_z_6, r0_z_8);
                float r1_z_7 = mad(r1_x_2, r1_z_6, r0_z_8);
                float r0_w_7 = (abs(r0_w_6) * r1_z_7);
                float r0_w_8 = mad(r1_x_2, r1_w_4, r0_w_7);
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
                float r0_w_11 = dot(r2_xyz_5.xyzx, r2_xyz_5.xyzx);
                float r0_w_12 = (r0_w_11 != 0);
                float r0_w_13 = asfloat(asint(r0_w_12) & asint(1065353216));
                float r0_z_15 = (r0_w_13 * r0_z_14);
                float4 r1_xyzw_3 = (r0_y_9.xxxx * float4(r4_x_10, r4_y_12, r4_z_11, r4_x_10));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_5 = r1_xyzw_3.y;
                float r1_z_9 = r1_xyzw_3.z;
                float4 r0_xyzw_10 = (float4(r4_x_10, r4_x_10, r4_y_12, r4_z_11) * r0_z_15.xxxx);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_16 = r0_xyzw_10.z;
                float r0_w_14 = r0_xyzw_10.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_5 = (r0_x_5 * r0_x_5);
                float r1_w_6 = (r1_w_5 * r1_w_5);
                float4 r4_xyzw_11 = (-r2_xyz_5.xyzx + float4(1, 1, 1, 0));
                float r4_x_11 = r4_xyzw_11.x;
                float r4_y_13 = r4_xyzw_11.y;
                float r4_z_12 = r4_xyzw_11.z;
                float4 r0_xyzw_7 = (float4(r0_y_10, r0_z_16, r0_w_14, r0_y_10) * (mad(float4(r4_x_11, r4_y_13, r4_z_12, r4_x_11), ((r0_x_5 * r1_w_6)).xxxx, r2_xyz_5.xyzx)).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_11 = r0_xyzw_7.y;
                float r0_z_17 = r0_xyzw_7.z;
                float4 r0_xyzw_8 = mad(((r1_w_2.xxxx * ((r1_w_1.xxxx * r2_xyz_3.xyzx)).xyzx)).xyzx, float4(r1_x_3, r1_y_5, r1_z_9, r1_x_3), float4(r0_x_7, r0_y_11, r0_z_17, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_18 = r0_xyzw_8.z;
                float4 r1_xyzw_4 = mad(float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8), i.color0.xyzx, -float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_6 = r1_xyzw_4.y;
                float r1_z_10 = r1_xyzw_4.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_4, r1_y_6, r1_z_10, r1_x_4), float4(0.25, 0.25, 0.25, 0), float4(r0_x_8, r0_y_12, r0_z_18, r0_x_8))).xyz;
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
                float _Wave : packoffset(c5.x);
                float _VertexColorBoost : packoffset(c5.y);
                float4 _MainTex_ST : packoffset(c6);
            };
            cbuffer _UnityPerCameraCB_b1
            {
                float4 _Time : packoffset(c0);
            };
            cbuffer _UnityPerDrawCB_b2
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b3
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
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
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program71Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program71Output
            {
                float4 sv_Target0 : SV_Target;
                float4 sv_Target1 : SV_Target1;
                float4 sv_Target2 : SV_Target2;
                float4 sv_Target3 : SV_Target3;
            };
            #pragma vertex vert
            program65Output vert(program65Input i)
            {
                program65Output o = (program65Output)0;
                float4 r0_xyzw_3 = ((sin(mad(i.position0.x, 8, _Time.y))).xxxx * i.normal0.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = mad(float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3), _Wave.xxxx, i.position0.xyzx);
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_2 = r0_xyzw_4.y;
                float r0_z_2 = r0_xyzw_4.z;
                float4 r0_xyzw_5 = mad(unity_ObjectToWorld[2], r0_z_2.xxxx, mad(unity_ObjectToWorld[0], r0_x_4.xxxx, (r0_y_2.xxxx * unity_ObjectToWorld[1])));
                float4 r1_xyzw_3 = (r0_xyzw_5 + unity_ObjectToWorld[3]);
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, r0_xyzw_5.xyzx)).xyz;
                float4 r0_xyzw_6 = (r1_xyzw_3.yyyy * unity_MatrixVP[1]);
                float4 r0_xyzw_7 = mad(unity_MatrixVP[0], r1_xyzw_3.xxxx, r0_xyzw_6);
                float4 r0_xyzw_8 = mad(unity_MatrixVP[2], r1_xyzw_3.zzzz, r0_xyzw_7);
                o.sv_Position0.xyzw = mad(unity_MatrixVP[3], r1_xyzw_3.wwww, r0_xyzw_8);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_9 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_5 = dot(float4(worldNormal_x_9, worldNormal_y_7, worldNormal_z_7, worldNormal_x_9), float4(worldNormal_x_9, worldNormal_y_7, worldNormal_z_7, worldNormal_x_9));
                float r0_w_6 = rsqrt(r0_w_5);
                o.texcoord1.xyz = ((r0_w_6.xxxx * float4(worldNormal_x_9, worldNormal_y_7, worldNormal_z_7, worldNormal_x_9))).xyz;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program71Output frag(program71Input i)
            {
                program71Output o = (program71Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r0_xyz_3 = ((((r0_xyzw_1.xyzx * _Color.xyzx)).xyzx * i.color0.xyzx)).xyz;
                float r0_w_2 = (_VertexColorBoost + 1);
                float r0_w_3 = mad(-i.color0.x, 0.48, 0.96);
                o.sv_Target0.xyz = ((r0_w_3.xxxx * ((r0_w_2.xxxx * r0_xyz_3.xyzx)).xyzx)).xyz;
                o.sv_Target0.w = 1;
                float r0_w_4 = (i.color0.x * 0.5);
                o.sv_Target1.xyz = (mad(r0_w_4.xxxx, (mad(r0_xyz_3.xyzx, r0_w_2.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                o.sv_Target1.w = saturate(i.color0.y);
                o.sv_Target2.xyz = (mad(i.texcoord1.xyzx, float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
                o.sv_Target2.w = 1;
                o.sv_Target3.xyzw = float4(1, 1, 1, 1);
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
                float _Wave : packoffset(c5.x);
                float _VertexColorBoost : packoffset(c5.y);
                float4 _MainTex_ST : packoffset(c6);
            };
            cbuffer _UnityPerCameraCB_b1
            {
                float4 _Time;
                float4 cb1_values[42];
            };
            cbuffer _UnityPerDrawCB_b2
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb2_values[46];
            };
            cbuffer _UnityPerFrameCB_b3
            {
                float4x4 unity_MatrixVP;
                float4 cb3_values[7];
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[21];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture3D t1;
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
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
            };
            struct program74Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
            };
            struct program74Output
            {
                float4 sv_Target0 : SV_Target;
                float4 sv_Target1 : SV_Target1;
                float4 sv_Target2 : SV_Target2;
                float4 sv_Target3 : SV_Target3;
            };
            #pragma vertex vert
            program68Output vert(program68Input i)
            {
                program68Output o = (program68Output)0;
                float4 r0_xyzw_3 = ((sin(mad(i.position0.x, 8, _Time.y))).xxxx * i.normal0.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = mad(float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3), _Wave.xxxx, i.position0.xyzx);
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_2 = r0_xyzw_4.y;
                float r0_z_2 = r0_xyzw_4.z;
                float4 r0_xyzw_5 = mad(cb3_values[2].xyzw, r0_z_2.xxxx, mad(cb3_values[0].xyzw, r0_x_4.xxxx, (r0_y_2.xxxx * cb3_values[1].xyzw)));
                float4 r1_xyzw_3 = (r0_xyzw_5 + cb3_values[3].xyzw);
                o.texcoord2.xyz = (mad(cb3_values[3].xyzx, i.position0.wwww, r0_xyzw_5.xyzx)).xyz;
                float4 r0_xyzw_6 = (r1_xyzw_3.yyyy * cb4_values[18].xyzw);
                float4 r0_xyzw_7 = mad(cb4_values[17].xyzw, r1_xyzw_3.xxxx, r0_xyzw_6);
                float4 r0_xyzw_8 = mad(cb4_values[19].xyzw, r1_xyzw_3.zzzz, r0_xyzw_7);
                o.sv_Position0.xyzw = mad(cb4_values[20].xyzw, r1_xyzw_3.wwww, r0_xyzw_8);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_9 = dot(i.normal0.xyzx, cb3_values[4].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, cb3_values[5].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, cb3_values[6].xyzx);
                float r0_w_5 = dot(float4(worldNormal_x_9, worldNormal_y_7, worldNormal_z_7, worldNormal_x_9), float4(worldNormal_x_9, worldNormal_y_7, worldNormal_z_7, worldNormal_x_9));
                float r0_w_6 = rsqrt(r0_w_5);
                float4 unitWorldNormal_xyzw_10 = (r0_w_6.xxxx * float4(worldNormal_x_9, worldNormal_y_7, worldNormal_z_7, worldNormal_x_9));
                float unitWorldNormal_x_10 = unitWorldNormal_xyzw_10.x;
                float unitWorldNormal_y_8 = unitWorldNormal_xyzw_10.y;
                float unitWorldNormal_z_8 = unitWorldNormal_xyzw_10.z;
                o.texcoord1.xyz = (float4(unitWorldNormal_x_10, unitWorldNormal_y_8, unitWorldNormal_z_8, unitWorldNormal_x_10)).xyz;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                float r0_w_7 = (unitWorldNormal_y_8 * unitWorldNormal_y_8);
                float r0_w_8 = mad(unitWorldNormal_x_10, unitWorldNormal_x_10, -r0_w_7);
                float4 r1_xyzw_4 = (float4(unitWorldNormal_y_8, unitWorldNormal_z_8, unitWorldNormal_z_8, unitWorldNormal_x_10) * float4(unitWorldNormal_x_10, unitWorldNormal_y_8, unitWorldNormal_z_8, unitWorldNormal_z_8));
                float r0_x_11 = dot(cb2_values[42].xyzw, r1_xyzw_4);
                float r0_y_9 = dot(cb2_values[43].xyzw, r1_xyzw_4);
                float r0_z_9 = dot(cb2_values[44].xyzw, r1_xyzw_4);
                o.texcoord5.xyz = (mad(cb2_values[45].xyzx, r0_w_8.xxxx, float4(r0_x_11, r0_y_9, r0_z_9, r0_x_11))).xyz;
                return o;
            }
            #pragma fragment frag
            program74Output frag(program74Input i)
            {
                program74Output o = (program74Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r0_xyz_3 = ((((r0_xyzw_1.xyzx * _Color.xyzx)).xyzx * i.color0.xyzx)).xyz;
                float r0_w_2 = (_VertexColorBoost + 1);
                float r1_w_1 = (i.color0.x * 0.5);
                o.sv_Target1.w = saturate(i.color0.y);
                float r3_x_5;
                float r3_y_5;
                float r3_z_4;
                if ((cb2_values[0].x == 1))
                {
                    float3 r2_yzw_2 = ((i.texcoord2.yyyy * cb2_values[2].xxyz)).yzw;
                    float3 r2_yzw_3 = (mad(cb2_values[1].xxyz, i.texcoord2.xxxx, r2_yzw_2.xxyz)).yzw;
                    float3 r2_yzw_4 = (mad(cb2_values[3].xxyz, i.texcoord2.zzzz, r2_yzw_3.xxyz)).yzw;
                    float3 r2_yzw_5 = ((r2_yzw_4.xxyz + cb2_values[4].xxyz)).yzw;
                    float4 r2_xyzw_4 = (((cb2_values[0].y == 1)).xxxx ? r2_yzw_5.xyzx : i.texcoord2.xyzx);
                    float r2_x_4 = r2_xyzw_4.x;
                    float r2_y_6 = r2_xyzw_4.y;
                    float r2_z_6 = r2_xyzw_4.z;
                    float4 r2_xyzw_5 = (float4(r2_x_4, r2_y_6, r2_z_6, r2_x_4) + -cb2_values[6].xyzx);
                    float r2_x_5 = r2_xyzw_5.x;
                    float r2_y_7 = r2_xyzw_5.y;
                    float r2_z_7 = r2_xyzw_5.z;
                    float4 r2_xyzw_8 = (float4(r2_x_5, r2_x_5, r2_y_7, r2_z_7) * cb2_values[5].xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_8 = r2_xyzw_8.z;
                    float r2_w_6 = r2_xyzw_8.w;
                    float r2_y_9 = (r2_y_8 * 0.25);
                    float r3_y_2 = mad(-cb2_values[0].z, 0.5, 0.25);
                    float r2_y_10 = max(r2_y_9, (cb2_values[0].z * 0.5));
                    float r2_x_6 = min(r3_y_2, r2_y_10);
                    float4 r3_xyzw_3 = t1.Sample(sampler_linear_clamp, (float4(r2_x_6, r2_z_8, r2_w_6, r2_x_6)).xyz);
                    float4 r4_xyzw_2 = t1.Sample(sampler_linear_clamp, (((float4(r2_x_6, r2_z_8, r2_w_6, r2_x_6) + float4(0.25, 0, 0, 0))).xyzx).xyz);
                    float4 r2_xyzw_7 = (float4(r2_x_6, r2_z_8, r2_w_6, r2_x_6) + float4(0.5, 0, 0, 0));
                    float r2_x_7 = r2_xyzw_7.x;
                    float r2_y_11 = r2_xyzw_7.y;
                    float r2_z_9 = r2_xyzw_7.z;
                    float r2_x_8 = (t1.Sample(sampler_linear_clamp, (float4(r2_x_7, r2_y_11, r2_z_9, r2_x_7)).xyz)).x;
                    float4 r2_xyzw_12 = t1.Sample(sampler_linear_clamp, (float4(r2_x_7, r2_y_11, r2_z_9, r2_x_7)).xyz);
                    float r2_y_12 = r2_xyzw_12.y;
                    float r2_z_10 = r2_xyzw_12.z;
                    float r2_w_7 = r2_xyzw_12.w;
                    float3 TEXCOORD1_xyz_1 = i.texcoord1.xyz;
                    float r5_w_1 = 1;
                    float r3_x_4 = dot(r3_xyzw_3, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r5_w_1));
                    float r3_y_4 = dot(r4_xyzw_2, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r5_w_1));
                    float r3_z_3 = dot(float4(r2_x_8, r2_y_12, r2_z_10, r2_w_7), float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r5_w_1));
                    r3_x_5 = r3_x_4;
                    r3_y_5 = r3_y_4;
                    r3_z_4 = r3_z_3;
                }
                else
                {
                    float TEXCOORD1_x_2 = i.texcoord1.x;
                    float TEXCOORD1_y_1 = i.texcoord1.y;
                    float TEXCOORD1_z_1 = i.texcoord1.z;
                    float r2_w_1 = 1;
                    float r3_x_1 = dot(cb1_values[39].xyzw, float4(TEXCOORD1_x_2, TEXCOORD1_y_1, TEXCOORD1_z_1, r2_w_1));
                    float r3_y_1 = dot(cb1_values[40].xyzw, float4(TEXCOORD1_x_2, TEXCOORD1_y_1, TEXCOORD1_z_1, r2_w_1));
                    float r3_z_1 = dot(cb1_values[41].xyzw, float4(TEXCOORD1_x_2, TEXCOORD1_y_1, TEXCOORD1_z_1, r2_w_1));
                    r3_x_5 = r3_x_1;
                    r3_y_5 = r3_y_1;
                    r3_z_4 = r3_z_1;
                }
                float4 r2_xyzw_10 = (float4(r3_x_5, r3_y_5, r3_z_4, r3_x_5) + i.texcoord5.xyzx);
                float r2_x_10 = r2_xyzw_10.x;
                float r2_y_14 = r2_xyzw_10.y;
                float r2_z_12 = r2_xyzw_10.z;
                float4 r2_xyzw_11 = max(float4(r2_x_10, r2_y_14, r2_z_12, r2_x_10), float4(0, 0, 0, 0));
                float r2_x_11 = r2_xyzw_11.x;
                float r2_y_15 = r2_xyzw_11.y;
                float r2_z_13 = r2_xyzw_11.z;
                o.sv_Target1.xyz = (mad(r1_w_1.xxxx, (mad(r0_xyz_3.xyzx, r0_w_2.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float4 r0_xyzw_6 = ((mad(-i.color0.x, 0.48, 0.96)).xxxx * ((r0_w_2.xxxx * r0_xyz_3.xyzx)).xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_5 = r0_xyzw_6.y;
                float r0_z_5 = r0_xyzw_6.z;
                o.sv_Target3.xyz = ((float4(r2_x_11, r2_y_15, r2_z_13, r2_x_11) * float4(r0_x_6, r0_y_5, r0_z_5, r0_x_6))).xyz;
                o.sv_Target0.xyz = (float4(r0_x_6, r0_y_5, r0_z_5, r0_x_6)).xyz;
                o.sv_Target0.w = 1;
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
                float _Wave : packoffset(c5.x);
                float _VertexColorBoost : packoffset(c5.y);
                float4 _MainTex_ST : packoffset(c6);
            };
            cbuffer _UnityPerCameraCB_b1
            {
                float4 _Time : packoffset(c0);
            };
            cbuffer _UnityPerDrawCB_b2
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b3
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
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
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program73Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program73Output
            {
                float4 sv_Target0 : SV_Target;
                float4 sv_Target1 : SV_Target1;
                float4 sv_Target2 : SV_Target2;
                float4 sv_Target3 : SV_Target3;
            };
            #pragma vertex vert
            program67Output vert(program67Input i)
            {
                program67Output o = (program67Output)0;
                float4 r0_xyzw_3 = ((sin(mad(i.position0.x, 8, _Time.y))).xxxx * i.normal0.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = mad(float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3), _Wave.xxxx, i.position0.xyzx);
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_2 = r0_xyzw_4.y;
                float r0_z_2 = r0_xyzw_4.z;
                float4 r0_xyzw_5 = mad(unity_ObjectToWorld[2], r0_z_2.xxxx, mad(unity_ObjectToWorld[0], r0_x_4.xxxx, (r0_y_2.xxxx * unity_ObjectToWorld[1])));
                float4 r1_xyzw_3 = (r0_xyzw_5 + unity_ObjectToWorld[3]);
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, r0_xyzw_5.xyzx)).xyz;
                float4 r0_xyzw_6 = (r1_xyzw_3.yyyy * unity_MatrixVP[1]);
                float4 r0_xyzw_7 = mad(unity_MatrixVP[0], r1_xyzw_3.xxxx, r0_xyzw_6);
                float4 r0_xyzw_8 = mad(unity_MatrixVP[2], r1_xyzw_3.zzzz, r0_xyzw_7);
                o.sv_Position0.xyzw = mad(unity_MatrixVP[3], r1_xyzw_3.wwww, r0_xyzw_8);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_9 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_5 = dot(float4(worldNormal_x_9, worldNormal_y_7, worldNormal_z_7, worldNormal_x_9), float4(worldNormal_x_9, worldNormal_y_7, worldNormal_z_7, worldNormal_x_9));
                float r0_w_6 = rsqrt(r0_w_5);
                o.texcoord1.xyz = ((r0_w_6.xxxx * float4(worldNormal_x_9, worldNormal_y_7, worldNormal_z_7, worldNormal_x_9))).xyz;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program73Output frag(program73Input i)
            {
                program73Output o = (program73Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r0_xyz_3 = ((((r0_xyzw_1.xyzx * _Color.xyzx)).xyzx * i.color0.xyzx)).xyz;
                float r0_w_2 = (_VertexColorBoost + 1);
                float r0_w_3 = mad(-i.color0.x, 0.48, 0.96);
                o.sv_Target0.xyz = ((r0_w_3.xxxx * ((r0_w_2.xxxx * r0_xyz_3.xyzx)).xyzx)).xyz;
                o.sv_Target0.w = 1;
                float r0_w_4 = (i.color0.x * 0.5);
                o.sv_Target1.xyz = (mad(r0_w_4.xxxx, (mad(r0_xyz_3.xyzx, r0_w_2.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                o.sv_Target1.w = saturate(i.color0.y);
                o.sv_Target2.xyz = (mad(i.texcoord1.xyzx, float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
                o.sv_Target2.w = 1;
                o.sv_Target3.xyzw = float4(0, 0, 0, 1);
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
                float _Wave : packoffset(c5.x);
                float _VertexColorBoost : packoffset(c5.y);
                float4 _MainTex_ST : packoffset(c6);
            };
            cbuffer _UnityPerCameraCB_b1
            {
                float4 _Time;
                float4 cb1_values[42];
            };
            cbuffer _UnityPerDrawCB_b2
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb2_values[46];
            };
            cbuffer _UnityPerFrameCB_b3
            {
                float4x4 unity_MatrixVP;
                float4 cb3_values[7];
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[21];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture3D t1;
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
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
            };
            struct program72Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
            };
            struct program72Output
            {
                float4 sv_Target0 : SV_Target;
                float4 sv_Target1 : SV_Target1;
                float4 sv_Target2 : SV_Target2;
                float4 sv_Target3 : SV_Target3;
            };
            #pragma vertex vert
            program66Output vert(program66Input i)
            {
                program66Output o = (program66Output)0;
                float4 r0_xyzw_3 = ((sin(mad(i.position0.x, 8, _Time.y))).xxxx * i.normal0.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = mad(float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3), _Wave.xxxx, i.position0.xyzx);
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_2 = r0_xyzw_4.y;
                float r0_z_2 = r0_xyzw_4.z;
                float4 r0_xyzw_5 = mad(cb3_values[2].xyzw, r0_z_2.xxxx, mad(cb3_values[0].xyzw, r0_x_4.xxxx, (r0_y_2.xxxx * cb3_values[1].xyzw)));
                float4 r1_xyzw_3 = (r0_xyzw_5 + cb3_values[3].xyzw);
                o.texcoord2.xyz = (mad(cb3_values[3].xyzx, i.position0.wwww, r0_xyzw_5.xyzx)).xyz;
                float4 r0_xyzw_6 = (r1_xyzw_3.yyyy * cb4_values[18].xyzw);
                float4 r0_xyzw_7 = mad(cb4_values[17].xyzw, r1_xyzw_3.xxxx, r0_xyzw_6);
                float4 r0_xyzw_8 = mad(cb4_values[19].xyzw, r1_xyzw_3.zzzz, r0_xyzw_7);
                o.sv_Position0.xyzw = mad(cb4_values[20].xyzw, r1_xyzw_3.wwww, r0_xyzw_8);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_9 = dot(i.normal0.xyzx, cb3_values[4].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, cb3_values[5].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, cb3_values[6].xyzx);
                float r0_w_5 = dot(float4(worldNormal_x_9, worldNormal_y_7, worldNormal_z_7, worldNormal_x_9), float4(worldNormal_x_9, worldNormal_y_7, worldNormal_z_7, worldNormal_x_9));
                float r0_w_6 = rsqrt(r0_w_5);
                float4 unitWorldNormal_xyzw_10 = (r0_w_6.xxxx * float4(worldNormal_x_9, worldNormal_y_7, worldNormal_z_7, worldNormal_x_9));
                float unitWorldNormal_x_10 = unitWorldNormal_xyzw_10.x;
                float unitWorldNormal_y_8 = unitWorldNormal_xyzw_10.y;
                float unitWorldNormal_z_8 = unitWorldNormal_xyzw_10.z;
                o.texcoord1.xyz = (float4(unitWorldNormal_x_10, unitWorldNormal_y_8, unitWorldNormal_z_8, unitWorldNormal_x_10)).xyz;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                float r0_w_7 = (unitWorldNormal_y_8 * unitWorldNormal_y_8);
                float r0_w_8 = mad(unitWorldNormal_x_10, unitWorldNormal_x_10, -r0_w_7);
                float4 r1_xyzw_4 = (float4(unitWorldNormal_y_8, unitWorldNormal_z_8, unitWorldNormal_z_8, unitWorldNormal_x_10) * float4(unitWorldNormal_x_10, unitWorldNormal_y_8, unitWorldNormal_z_8, unitWorldNormal_z_8));
                float r0_x_11 = dot(cb2_values[42].xyzw, r1_xyzw_4);
                float r0_y_9 = dot(cb2_values[43].xyzw, r1_xyzw_4);
                float r0_z_9 = dot(cb2_values[44].xyzw, r1_xyzw_4);
                o.texcoord5.xyz = (mad(cb2_values[45].xyzx, r0_w_8.xxxx, float4(r0_x_11, r0_y_9, r0_z_9, r0_x_11))).xyz;
                return o;
            }
            #pragma fragment frag
            program72Output frag(program72Input i)
            {
                program72Output o = (program72Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r0_xyz_3 = ((((r0_xyzw_1.xyzx * _Color.xyzx)).xyzx * i.color0.xyzx)).xyz;
                float r0_w_2 = (_VertexColorBoost + 1);
                float r1_w_1 = (i.color0.x * 0.5);
                o.sv_Target1.w = saturate(i.color0.y);
                float r3_x_5;
                float r3_y_5;
                float r3_z_4;
                if ((cb2_values[0].x == 1))
                {
                    float3 r2_yzw_2 = ((i.texcoord2.yyyy * cb2_values[2].xxyz)).yzw;
                    float3 r2_yzw_3 = (mad(cb2_values[1].xxyz, i.texcoord2.xxxx, r2_yzw_2.xxyz)).yzw;
                    float3 r2_yzw_4 = (mad(cb2_values[3].xxyz, i.texcoord2.zzzz, r2_yzw_3.xxyz)).yzw;
                    float3 r2_yzw_5 = ((r2_yzw_4.xxyz + cb2_values[4].xxyz)).yzw;
                    float4 r2_xyzw_4 = (((cb2_values[0].y == 1)).xxxx ? r2_yzw_5.xyzx : i.texcoord2.xyzx);
                    float r2_x_4 = r2_xyzw_4.x;
                    float r2_y_6 = r2_xyzw_4.y;
                    float r2_z_6 = r2_xyzw_4.z;
                    float4 r2_xyzw_5 = (float4(r2_x_4, r2_y_6, r2_z_6, r2_x_4) + -cb2_values[6].xyzx);
                    float r2_x_5 = r2_xyzw_5.x;
                    float r2_y_7 = r2_xyzw_5.y;
                    float r2_z_7 = r2_xyzw_5.z;
                    float4 r2_xyzw_8 = (float4(r2_x_5, r2_x_5, r2_y_7, r2_z_7) * cb2_values[5].xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_8 = r2_xyzw_8.z;
                    float r2_w_6 = r2_xyzw_8.w;
                    float r2_y_9 = (r2_y_8 * 0.25);
                    float r3_y_2 = mad(-cb2_values[0].z, 0.5, 0.25);
                    float r2_y_10 = max(r2_y_9, (cb2_values[0].z * 0.5));
                    float r2_x_6 = min(r3_y_2, r2_y_10);
                    float4 r3_xyzw_3 = t1.Sample(sampler_linear_clamp, (float4(r2_x_6, r2_z_8, r2_w_6, r2_x_6)).xyz);
                    float4 r4_xyzw_2 = t1.Sample(sampler_linear_clamp, (((float4(r2_x_6, r2_z_8, r2_w_6, r2_x_6) + float4(0.25, 0, 0, 0))).xyzx).xyz);
                    float4 r2_xyzw_7 = (float4(r2_x_6, r2_z_8, r2_w_6, r2_x_6) + float4(0.5, 0, 0, 0));
                    float r2_x_7 = r2_xyzw_7.x;
                    float r2_y_11 = r2_xyzw_7.y;
                    float r2_z_9 = r2_xyzw_7.z;
                    float r2_x_8 = (t1.Sample(sampler_linear_clamp, (float4(r2_x_7, r2_y_11, r2_z_9, r2_x_7)).xyz)).x;
                    float4 r2_xyzw_12 = t1.Sample(sampler_linear_clamp, (float4(r2_x_7, r2_y_11, r2_z_9, r2_x_7)).xyz);
                    float r2_y_12 = r2_xyzw_12.y;
                    float r2_z_10 = r2_xyzw_12.z;
                    float r2_w_7 = r2_xyzw_12.w;
                    float3 TEXCOORD1_xyz_1 = i.texcoord1.xyz;
                    float r5_w_1 = 1;
                    float r3_x_4 = dot(r3_xyzw_3, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r5_w_1));
                    float r3_y_4 = dot(r4_xyzw_2, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r5_w_1));
                    float r3_z_3 = dot(float4(r2_x_8, r2_y_12, r2_z_10, r2_w_7), float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r5_w_1));
                    r3_x_5 = r3_x_4;
                    r3_y_5 = r3_y_4;
                    r3_z_4 = r3_z_3;
                }
                else
                {
                    float TEXCOORD1_x_2 = i.texcoord1.x;
                    float TEXCOORD1_y_1 = i.texcoord1.y;
                    float TEXCOORD1_z_1 = i.texcoord1.z;
                    float r2_w_1 = 1;
                    float r3_x_1 = dot(cb1_values[39].xyzw, float4(TEXCOORD1_x_2, TEXCOORD1_y_1, TEXCOORD1_z_1, r2_w_1));
                    float r3_y_1 = dot(cb1_values[40].xyzw, float4(TEXCOORD1_x_2, TEXCOORD1_y_1, TEXCOORD1_z_1, r2_w_1));
                    float r3_z_1 = dot(cb1_values[41].xyzw, float4(TEXCOORD1_x_2, TEXCOORD1_y_1, TEXCOORD1_z_1, r2_w_1));
                    r3_x_5 = r3_x_1;
                    r3_y_5 = r3_y_1;
                    r3_z_4 = r3_z_1;
                }
                float4 r2_xyzw_10 = (float4(r3_x_5, r3_y_5, r3_z_4, r3_x_5) + i.texcoord5.xyzx);
                float r2_x_10 = r2_xyzw_10.x;
                float r2_y_14 = r2_xyzw_10.y;
                float r2_z_12 = r2_xyzw_10.z;
                float4 r2_xyzw_11 = max(float4(r2_x_10, r2_y_14, r2_z_12, r2_x_10), float4(0, 0, 0, 0));
                float r2_x_11 = r2_xyzw_11.x;
                float r2_y_15 = r2_xyzw_11.y;
                float r2_z_13 = r2_xyzw_11.z;
                o.sv_Target1.xyz = (mad(r1_w_1.xxxx, (mad(r0_xyz_3.xyzx, r0_w_2.xxxx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.04, 0.04, 0.04, 0))).xyz;
                float4 r0_xyzw_6 = ((mad(-i.color0.x, 0.48, 0.96)).xxxx * ((r0_w_2.xxxx * r0_xyz_3.xyzx)).xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_5 = r0_xyzw_6.y;
                float r0_z_5 = r0_xyzw_6.z;
                o.sv_Target3.xyz = (exp2(((float4(r2_x_11, r2_y_15, r2_z_13, r2_x_11) * float4(r0_x_6, r0_y_5, r0_z_5, r0_x_6))).xyzx)).xyz;
                o.sv_Target0.xyz = (float4(r0_x_6, r0_y_5, r0_z_5, r0_x_6)).xyz;
                o.sv_Target0.w = 1;
                o.sv_Target2.xyz = (mad(i.texcoord1.xyzx, float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
                o.sv_Target2.w = 1;
                o.sv_Target3.w = 1;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Standard"
}
