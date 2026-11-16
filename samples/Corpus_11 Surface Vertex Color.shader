Shader "Corpus/11 Surface Vertex Color"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo", 2D) = "white" {}
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
            // Folded keyword variants (base state emitted): LIGHTPROBE_SH, SHADOWS_SCREEN, VERTEXLIGHT_ON
            HLSLPROGRAM
            #pragma target 3.5
            #pragma multi_compile _ LIGHTPROBE_SH SHADOWS_SCREEN VERTEXLIGHT_ON
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
                if (((unity_ProbeVolumeParams.x == 1)).x)
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
            Tags { "LIGHTMODE"="FORWARDADD" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            // Folded keyword variants (base state emitted): DIRECTIONAL_COOKIE, POINT, POINT_COOKIE, SHADOWS_CUBE, SHADOWS_DEPTH, SHADOWS_SCREEN, SHADOWS_SOFT, SPOT
            HLSLPROGRAM
            #pragma target 3.5
            #pragma multi_compile _ DIRECTIONAL_COOKIE POINT POINT_COOKIE SHADOWS_CUBE SHADOWS_DEPTH SHADOWS_SCREEN SHADOWS_SOFT SPOT
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
                if (((unity_ProbeVolumeParams.x == 1)).x)
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
            #pragma target 3.5
            #pragma multi_compile _ LIGHTPROBE_SH
            #pragma multi_compile _ UNITY_HDR_ON
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
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[21];
            };
            SamplerState sampler_MainTex1;
            Texture3D t1;
            #if defined(LIGHTPROBE_SH) && defined(UNITY_HDR_ON)
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
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex1, (i.texcoord0.xyxx).xy);
                float3 r0_xyz_3 = ((((r0_xyzw_1.xyzx * _Color.xyzx)).xyzx * i.color0.xyzx)).xyz;
                float r0_w_2 = (_VertexColorBoost + 1);
                float r1_w_1 = (i.color0.x * 0.5);
                o.sv_Target1.w = saturate(i.color0.y);
                float r3_x_5;
                float r3_y_5;
                float r3_z_4;
                if (((cb2_values[0].x == 1)).x)
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
                    float4 r3_xyzw_3 = t1.Sample(sampler_MainTex, (float4(r2_x_6, r2_z_8, r2_w_6, r2_x_6)).xyz);
                    float4 r4_xyzw_2 = t1.Sample(sampler_MainTex, (((float4(r2_x_6, r2_z_8, r2_w_6, r2_x_6) + float4(0.25, 0, 0, 0))).xyzx).xyz);
                    float4 r2_xyzw_7 = (float4(r2_x_6, r2_z_8, r2_w_6, r2_x_6) + float4(0.5, 0, 0, 0));
                    float r2_x_7 = r2_xyzw_7.x;
                    float r2_y_11 = r2_xyzw_7.y;
                    float r2_z_9 = r2_xyzw_7.z;
                    float r2_x_8 = (t1.Sample(sampler_MainTex, (float4(r2_x_7, r2_y_11, r2_z_9, r2_x_7)).xyz)).x;
                    float4 r2_xyzw_12 = t1.Sample(sampler_MainTex, (float4(r2_x_7, r2_y_11, r2_z_9, r2_x_7)).xyz);
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
            #elif defined(LIGHTPROBE_SH)
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
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex1, (i.texcoord0.xyxx).xy);
                float3 r0_xyz_3 = ((((r0_xyzw_1.xyzx * _Color.xyzx)).xyzx * i.color0.xyzx)).xyz;
                float r0_w_2 = (_VertexColorBoost + 1);
                float r1_w_1 = (i.color0.x * 0.5);
                o.sv_Target1.w = saturate(i.color0.y);
                float r3_x_5;
                float r3_y_5;
                float r3_z_4;
                if (((cb2_values[0].x == 1)).x)
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
                    float4 r3_xyzw_3 = t1.Sample(sampler_MainTex, (float4(r2_x_6, r2_z_8, r2_w_6, r2_x_6)).xyz);
                    float4 r4_xyzw_2 = t1.Sample(sampler_MainTex, (((float4(r2_x_6, r2_z_8, r2_w_6, r2_x_6) + float4(0.25, 0, 0, 0))).xyzx).xyz);
                    float4 r2_xyzw_7 = (float4(r2_x_6, r2_z_8, r2_w_6, r2_x_6) + float4(0.5, 0, 0, 0));
                    float r2_x_7 = r2_xyzw_7.x;
                    float r2_y_11 = r2_xyzw_7.y;
                    float r2_z_9 = r2_xyzw_7.z;
                    float r2_x_8 = (t1.Sample(sampler_MainTex, (float4(r2_x_7, r2_y_11, r2_z_9, r2_x_7)).xyz)).x;
                    float4 r2_xyzw_12 = t1.Sample(sampler_MainTex, (float4(r2_x_7, r2_y_11, r2_z_9, r2_x_7)).xyz);
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
            #elif defined(UNITY_HDR_ON)
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
            #else
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
            #endif
            ENDHLSL
        }
    }
    Fallback "Standard"
}
