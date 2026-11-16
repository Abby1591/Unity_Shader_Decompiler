Shader "Corpus/10 Surface Tessellation"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo", 2D) = "white" {}
        _Tess ("Tessellation", Range(1, 32)) = 4
        _Disp ("Displacement", Range(0, 1)) = 0.1
        _Phong ("Phong Strength", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
        LOD 400
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            // Folded keyword variants (base state emitted): FOG_LINEAR, LIGHTPROBE_SH, SHADOWS_SCREEN, VERTEXLIGHT_ON
            HLSLPROGRAM
            #pragma target 5.0
            #pragma multi_compile _ FOG_LINEAR LIGHTPROBE_SH SHADOWS_SCREEN VERTEXLIGHT_ON
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _Color : packoffset(c4);
                float _Tess : packoffset(c5.x);
                float _Disp : packoffset(c5.y);
                float _Phong : packoffset(c5.z);
                float4 _MainTex_ST : packoffset(c6);
            };
            cbuffer _UnityPerCameraCB_b1
            {
                float4 _Time : packoffset(c0);
                float3 _WorldSpaceCameraPos : packoffset(c4);
            };
            cbuffer _UnityLightingCB_b2
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
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
            struct program1Input
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
            struct program1Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program25Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program25Output
            {
                float4 sv_Target0 : SV_Target;
            };
            struct program34Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
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
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program46Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
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
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            #pragma vertex vert
            program1Output vert(program1Input i)
            {
                program1Output o = (program1Output)0;
                o.internaltesspos0.xyzw = i.position0.xyzw;
                o.tangent0.xyzw = i.tangent0.xyzw;
                o.normal0.xyz = i.normal0.xyz;
                o.texcoord0.xyzw = i.texcoord0.xyzw;
                o.texcoord1.xyzw = i.texcoord1.xyzw;
                o.texcoord2.xyzw = i.texcoord2.xyzw;
                o.texcoord3.xyzw = i.texcoord3.xyzw;
                o.color0.xyzw = i.color0.xyzw;
                return o;
            }
            #pragma fragment frag
            program25Output frag(program25Input i)
            {
                program25Output o = (program25Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r1_xyz_1 = ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyz;
                float3 r2_xyz_1 = (_MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy)).xyz;
                float r1_w_1 = (unity_ProbeVolumeParams.x == 1);
                float r4_x_10;
                float r4_y_10;
                float r4_z_10;
                float r4_w_4;
                if (r1_w_1)
                {
                    float r1_w_2 = (unity_ProbeVolumeParams.y == 1);
                    float3 r4_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r1_w_2.xxxx ? r4_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r4_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r4_y_8 = r4_xyzw_8.y;
                    float r4_z_8 = r4_xyzw_8.z;
                    float r4_w_2 = r4_xyzw_8.w;
                    float r1_w_3 = mad(r4_y_8, 0.25, 0.75);
                    float r2_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r4_x_8 = max(r1_w_3, r2_w_1);
                    float4 r4_xyzw_9 = t3.Sample(sampler_linear_clamp1, (float4(r4_x_8, r4_z_8, r4_w_2, r4_x_8)).xyz);
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
                float r1_w_5 = saturate(dot(float4(r4_x_10, r4_y_10, r4_z_10, r4_w_4), unity_OcclusionMaskSelector));
                float r2_w_3 = dot(-r1_xyz_1.xyzx, i.texcoord1.xyzx);
                float r2_w_4 = (r2_w_3 + r2_w_3);
                float3 r4_xyz_11 = (mad(i.texcoord1.xyzx, -r2_w_4.xxxx, -r1_xyz_1.xyzx)).xyz;
                float3 r5_xyz_1 = ((r1_w_5.xxxx * _LightColor0.xyzx)).xyz;
                float r1_w_6 = (0 < unity_SpecCube0_ProbePosition.w);
                float3 r6_xyz_4;
                if (r1_w_6)
                {
                    float3 r6_xyz_2 = normalize(r4_xyz_11);
                    float3 r9_xyz_1 = ((float4(0, 0, 0, 0) < r6_xyz_2.xyzx)).xyz;
                    float3 r7_xyz_3 = ((r9_xyz_1.xyzx ? ((((-i.texcoord2.xyzx + unity_SpecCube0_BoxMax.xyzx)).xyzx / r6_xyz_2.xyzx)).xyzx : ((((-i.texcoord2.xyzx + unity_SpecCube0_BoxMin.xyzx)).xyzx / r6_xyz_2.xyzx)).xyzx)).xyz;
                    float r1_w_9 = min(r7_xyz_3.y, r7_xyz_3.x);
                    float r1_w_10 = min(r7_xyz_3.z, r1_w_9);
                    r6_xyz_4 = (mad(r6_xyz_2.xyzx, r1_w_10.xxxx, ((i.texcoord2.xyzx + -unity_SpecCube0_ProbePosition.xyzx)).xyzx)).xyz;
                }
                else
                {
                    r6_xyz_4 = r4_xyz_11.xyz;
                }
                float4 r6_xyzw_5 = t1.SampleLevel(sampler_linear_clamp, r6_xyz_4.xyz, 4.05);
                float r1_w_12 = (r6_xyzw_5.w + -1);
                float r1_w_13 = mad(unity_SpecCube0_HDR.w, r1_w_12, 1);
                float r1_w_14 = log2(r1_w_13);
                float r1_w_15 = (r1_w_14 * unity_SpecCube0_HDR.y);
                float r1_w_16 = exp2(r1_w_15);
                float r1_w_17 = (r1_w_16 * unity_SpecCube0_HDR.x);
                float r2_w_5 = (unity_SpecCube0_BoxMin.w < 0.99999);
                float3 r7_xyz_8 = ((r6_xyzw_5.xyzx * r1_w_17.xxxx)).xyz;
                if (r2_w_5)
                {
                    float r2_w_6 = (0 < unity_SpecCube1_ProbePosition.w);
                    float3 r4_xyz_13 = r4_xyz_11;
                    if (r2_w_6)
                    {
                        float3 r8_xyz_4 = normalize(r4_xyz_11);
                        float3 r11_xyz_1 = ((float4(0, 0, 0, 0) < r8_xyz_4.xyzx)).xyz;
                        float3 r9_xyz_5 = ((r11_xyz_1.xyzx ? ((((-i.texcoord2.xyzx + unity_SpecCube1_BoxMax.xyzx)).xyzx / r8_xyz_4.xyzx)).xyzx : ((((-i.texcoord2.xyzx + unity_SpecCube1_BoxMin.xyzx)).xyzx / r8_xyz_4.xyzx)).xyzx)).xyz;
                        float r2_w_9 = min(r9_xyz_5.y, r9_xyz_5.x);
                        float r2_w_10 = min(r9_xyz_5.z, r2_w_9);
                        r4_xyz_13 = (mad(r8_xyz_4.xyzx, r2_w_10.xxxx, ((i.texcoord2.xyzx + -unity_SpecCube1_ProbePosition.xyzx)).xyzx)).xyz;
                    }
                    float4 r4_xyzw_14 = t2.SampleLevel(sampler_linear_clamp, r4_xyz_13.xyz, 4.05);
                    float r2_w_12 = (r4_xyzw_14.w + -1);
                    float r2_w_13 = mad(unity_SpecCube1_HDR.w, r2_w_12, 1);
                    float r2_w_14 = log2(r2_w_13);
                    float r2_w_15 = (r2_w_14 * unity_SpecCube1_HDR.y);
                    float r2_w_16 = exp2(r2_w_15);
                    float r2_w_17 = (r2_w_16 * unity_SpecCube1_HDR.x);
                    float3 r4_xyz_15 = ((r4_xyzw_14.xyzx * r2_w_17.xxxx)).xyz;
                    r7_xyz_8 = (mad(unity_SpecCube0_BoxMin.wwww, (mad(r1_w_17.xxxx, r6_xyzw_5.xyzx, -r4_xyz_15.xyzx)).xyzx, r4_xyz_15.xyzx)).xyz;
                }
                float3 r4_xyz_17 = normalize(i.texcoord1);
                float3 r2_xyz_3 = (mad((mad(r2_xyz_1.xyzx, _Color.xyzx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.1, 0.1, 0.1, 0), float4(0.04, 0.04, 0.04, 0))).xyz;
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unity_ObjectToWorld[0].xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(r4_xyz_17.xyzx, r1_xyz_1.xyzx);
                float r1_x_2 = saturate(dot(r4_xyz_17.xyzx, unity_ObjectToWorld[0].xyzx));
                float r1_y_2 = saturate(dot(r4_xyz_17.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(unity_ObjectToWorld[0].xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = mad(r0_x_4, r0_x_4, -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_4, r0_z_5, 1);
                float r1_z_4 = (-abs(r0_w_6) + 1);
                float r1_w_20 = (r1_z_4 * r1_z_4);
                float r1_w_21 = (r1_w_20 * r1_w_20);
                float r1_z_5 = (r1_z_4 * r1_w_21);
                float r0_y_5 = mad(r0_y_4, r1_z_5, 1);
                float r0_y_6 = (r0_y_5 * r0_z_6);
                float r0_z_7 = mad(abs(r0_w_6), 0.75, 0.25);
                float r1_w_22 = mad(r1_x_2, 0.75, 0.25);
                float r0_w_7 = (abs(r0_w_6) * r1_w_22);
                float r0_z_8 = mad(r1_x_2, r0_z_7, r0_w_7);
                float r0_z_9 = (r0_z_8 + 1E-05);
                float r0_w_8 = (r1_y_2 * r1_y_2);
                float r0_w_9 = mad(r0_w_8, -0.9375, 1);
                float r0_w_10 = mad(r0_w_9, r0_w_9, 1E-07);
                float4 r0_xyzw_10 = (float4(0, 0, 0.5, 0.019894367) / float4(r0_z_9, r0_z_9, r0_z_9, r0_w_10));
                float r0_z_10 = r0_xyzw_10.z;
                float r0_w_11 = r0_xyzw_10.w;
                float r0_z_11 = (r0_w_11 * r0_z_10);
                float r0_z_12 = (r0_z_11 * 3.1415927);
                float4 r0_xyzw_7 = (r1_x_2.xxxx * float4(r0_y_6, r0_y_6, r0_z_12, r0_y_6));
                float r0_y_7 = r0_xyzw_7.y;
                float r0_z_13 = r0_xyzw_7.z;
                float r0_w_12 = dot(r2_xyz_3.xyzx, r2_xyz_3.xyzx);
                float r0_w_13 = (r0_w_12 != 0);
                float r0_w_14 = asfloat(asint(r0_w_13) & asint(1065353216));
                float r0_z_14 = (r0_w_14 * r0_z_13);
                float4 r1_xyzw_3 = (r0_y_7.xxxx * r5_xyz_1.xyxz);
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_3 = r1_xyzw_3.y;
                float r1_w_23 = r1_xyzw_3.w;
                float4 r0_xyzw_8 = (r5_xyz_1.xxyz * r0_z_14.xxxx);
                float r0_y_8 = r0_xyzw_8.y;
                float r0_z_15 = r0_xyzw_8.z;
                float r0_w_15 = r0_xyzw_8.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r2_w_19 = (r0_x_5 * r0_x_5);
                float r2_w_20 = (r2_w_19 * r2_w_19);
                float r0_x_7 = ((float4(r0_y_8, r0_z_15, r0_w_15, r0_y_8) * (mad(((-r2_xyz_3.xyzx + float4(1, 1, 1, 0))).xyzx, ((r0_x_5 * r2_w_20)).xxxx, r2_xyz_3.xyzx)).xyzx)).x;
                float4 r0_xyzw_9 = (float4(r0_y_8, r0_z_15, r0_w_15, r0_y_8) * (mad(((-r2_xyz_3.xyzx + float4(1, 1, 1, 0))).xyzx, ((r0_x_5 * r2_w_20)).xxxx, r2_xyz_3.xyzx)).xyzx);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_16 = r0_xyzw_9.z;
                float r0_x_8 = (mad(((((r2_xyz_1.xyzx * _Color.xyzx)).xyzx * float4(0.86399996, 0.86399996, 0.86399996, 0))).xyzx, float4(r1_x_3, r1_y_3, r1_w_23, r1_x_3), float4(r0_x_7, r0_y_9, r0_z_16, r0_x_7))).x;
                float r0_y_10 = (mad(((((r2_xyz_1.xyzx * _Color.xyzx)).xyzx * float4(0.86399996, 0.86399996, 0.86399996, 0))).xyzx, float4(r1_x_3, r1_y_3, r1_w_23, r1_x_3), float4(r0_x_7, r0_y_9, r0_z_16, r0_x_7))).y;
                float r0_z_17 = (mad(((((r2_xyz_1.xyzx * _Color.xyzx)).xyzx * float4(0.86399996, 0.86399996, 0.86399996, 0))).xyzx, float4(r1_x_3, r1_y_3, r1_w_23, r1_x_3), float4(r0_x_7, r0_y_9, r0_z_16, r0_x_7))).z;
                float4 r1_xyzw_4 = (r7_xyz_8.xyxz * float4(0.9411765, 0.9411765, 0, 0.9411765));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_4 = r1_xyzw_4.y;
                float r1_w_24 = r1_xyzw_4.w;
                o.sv_Target0.xyz = (mad(float4(r1_x_4, r1_y_4, r1_w_24, r1_x_4), (mad(r1_z_5.xxxx, ((-r2_xyz_3.xyzx + float4(0.63600004, 0.63600004, 0.63600004, 0))).xyzx, r2_xyz_3.xyzx)).xyzx, float4(r0_x_8, r0_y_10, r0_z_17, r0_x_8))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            program34Output hull(program34Input i, uint inputforkinstanceid0)
            {
                program34Output o = (program34Output)0;
                // TODO: unhandled IR node — hs_fork_phase
                float r0_y_1 = inputforkinstanceid0.x;
                o.internaltesspos0.x = max(_Tess, 1);
                return o;
            }
            program46Output domain(program46Input i, float4 inputcontrolpoint1_0, float4 inputcontrolpoint1_2, float4 inputdomainpoint0, float4 inputcontrolpoint0_0, float4 inputcontrolpoint2_0, float4 inputcontrolpoint0_2, float4 inputcontrolpoint2_2, float4 inputcontrolpoint1_3, float4 inputcontrolpoint0_3, float4 inputcontrolpoint2_3)
            {
                program46Output o = (program46Output)0;
                float4 r1_xyzw_3 = mad(inputcontrolpoint2_0.xyzw, inputdomainpoint0.zzzz, mad(inputcontrolpoint0_0.xyzw, inputdomainpoint0.xxxx, (inputdomainpoint0.yyyy * inputcontrolpoint1_0.xyzw)));
                float r0_y_1 = dot(r1_xyzw_3.xyzx, inputcontrolpoint1_2.xyzx);
                float4 r0_xyzw_3 = mad(-inputcontrolpoint1_2.xyzx, ((dot(inputcontrolpoint1_0.xyzx, inputcontrolpoint1_2.xyzx) + r0_y_1)).xxxx, r1_xyzw_3.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_2 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = (float4(r0_x_3, r0_y_2, r0_z_1, r0_x_3) * inputdomainpoint0.yyyy);
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_3 = r0_xyzw_4.y;
                float r0_z_2 = r0_xyzw_4.z;
                float r0_w_1 = dot(inputcontrolpoint0_0.xyzx, inputcontrolpoint0_2.xyzx);
                float r0_w_2 = (-r0_w_1 + dot(r1_xyzw_3.xyzx, inputcontrolpoint0_2.xyzx));
                float4 r2_xyzw_2 = mad(-inputcontrolpoint0_2.xyzx, r0_w_2.xxxx, r1_xyzw_3.xyzx);
                float r2_x_2 = r2_xyzw_2.x;
                float r2_y_1 = r2_xyzw_2.y;
                float r2_z_1 = r2_xyzw_2.z;
                float4 r0_xyzw_5 = mad(float4(r2_x_2, r2_y_1, r2_z_1, r2_x_2), inputdomainpoint0.xxxx, float4(r0_x_4, r0_y_3, r0_z_2, r0_x_4));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_3 = r0_xyzw_5.z;
                float r0_w_3 = dot(inputcontrolpoint2_0.xyzx, inputcontrolpoint2_2.xyzx);
                float r0_w_4 = (-r0_w_3 + dot(r1_xyzw_3.xyzx, inputcontrolpoint2_2.xyzx));
                float4 r2_xyzw_4 = mad(-inputcontrolpoint2_2.xyzx, r0_w_4.xxxx, r1_xyzw_3.xyzx);
                float r2_x_4 = r2_xyzw_4.x;
                float r2_y_2 = r2_xyzw_4.y;
                float r2_z_2 = r2_xyzw_4.z;
                float4 r0_xyzw_6 = mad(float4(r2_x_4, r2_y_2, r2_z_2, r2_x_4), inputdomainpoint0.zzzz, float4(r0_x_5, r0_y_4, r0_z_3, r0_x_5));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_5 = r0_xyzw_6.y;
                float r0_z_4 = r0_xyzw_6.z;
                float r0_w_5 = (-_Phong + 1);
                float4 r0_xyzw_7 = mad(_Phong.xxxx, float4(r0_x_6, r0_y_5, r0_z_4, r0_x_6), ((r1_xyzw_3.xyzx * r0_w_5.xxxx)).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_6 = r0_xyzw_7.y;
                float r0_z_5 = r0_xyzw_7.z;
                float2 r1_xy_7 = (mad(inputcontrolpoint2_3.xyxx, inputdomainpoint0.zzzz, (mad(inputcontrolpoint0_3.xyxx, inputdomainpoint0.xxxx, ((inputdomainpoint0.yyyy * inputcontrolpoint1_3.xyxx)).xyxx)).xyxx)).xy;
                float r0_w_6 = (r1_xy_7.y * 10);
                float r0_w_7 = mad(-_Time.y, 0.5, r0_w_6);
                float r0_w_8 = cos(r0_w_7);
                float r1_z_5 = mad(r1_xy_7.x, 12, _Time.y);
                o.texcoord0.xy = (mad(r1_xy_7.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float r0_w_9 = (r0_w_8 * sin(r1_z_5));
                float4 r1_xyzw_9 = (inputdomainpoint0.yyyy * inputcontrolpoint1_2.xyzx);
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_8 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r1_xyzw_10 = mad(inputcontrolpoint0_2.xyzx, inputdomainpoint0.xxxx, float4(r1_x_9, r1_y_8, r1_z_6, r1_x_9));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_9 = r1_xyzw_10.y;
                float r1_z_7 = r1_xyzw_10.z;
                float4 r1_xyzw_11 = mad(inputcontrolpoint2_2.xyzx, inputdomainpoint0.zzzz, float4(r1_x_10, r1_y_9, r1_z_7, r1_x_10));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_10 = r1_xyzw_11.y;
                float r1_z_8 = r1_xyzw_11.z;
                float4 r2_xyzw_5 = (r0_w_9.xxxx * float4(r1_x_11, r1_y_10, r1_z_8, r1_x_11));
                float r2_x_5 = r2_xyzw_5.x;
                float r2_y_3 = r2_xyzw_5.y;
                float r2_z_3 = r2_xyzw_5.z;
                float4 r0_xyzw_8 = mad(float4(r2_x_5, r2_y_3, r2_z_3, r2_x_5), _Disp.xxxx, float4(r0_x_7, r0_y_6, r0_z_5, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_7 = r0_xyzw_8.y;
                float r0_z_6 = r0_xyzw_8.z;
                float4 r2_xyzw_6 = (r0_y_7.xxxx * unity_ObjectToWorld[1]);
                float4 r2_xyzw_7 = mad(unity_ObjectToWorld[0], r0_x_8.xxxx, r2_xyzw_6);
                float4 r0_xyzw_9 = mad(unity_ObjectToWorld[2], r0_z_6.xxxx, r2_xyzw_7);
                float4 r2_xyzw_8 = (r0_xyzw_9 + unity_ObjectToWorld[3]);
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, r1_xyzw_3.wwww, r0_xyzw_9.xyzx)).xyz;
                float4 r0_xyzw_10 = (r2_xyzw_8.yyyy * unity_MatrixVP[1]);
                float4 r0_xyzw_11 = mad(unity_MatrixVP[0], r2_xyzw_8.xxxx, r0_xyzw_10);
                float4 r0_xyzw_12 = mad(unity_MatrixVP[2], r2_xyzw_8.zzzz, r0_xyzw_11);
                o.sv_Position0.xyzw = mad(unity_MatrixVP[3], r2_xyzw_8.wwww, r0_xyzw_12);
                float r0_x_13 = dot(float4(r1_x_11, r1_y_10, r1_z_8, r1_x_11), unity_WorldToObject[0].xyzx);
                float r0_y_12 = dot(float4(r1_x_11, r1_y_10, r1_z_8, r1_x_11), unity_WorldToObject[1].xyzx);
                float r0_z_11 = dot(float4(r1_x_11, r1_y_10, r1_z_8, r1_x_11), unity_WorldToObject[2].xyzx);
                float r0_w_14 = dot(float4(r0_x_13, r0_y_12, r0_z_11, r0_x_13), float4(r0_x_13, r0_y_12, r0_z_11, r0_x_13));
                float r0_w_15 = rsqrt(r0_w_14);
                o.texcoord1.xyz = ((r0_w_15.xxxx * float4(r0_x_13, r0_y_12, r0_z_11, r0_x_13))).xyz;
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
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
            // Folded keyword variants (base state emitted): DIRECTIONAL_COOKIE, FOG_LINEAR, POINT, POINT_COOKIE, SHADOWS_CUBE, SHADOWS_DEPTH, SHADOWS_SCREEN, SHADOWS_SOFT, SPOT
            HLSLPROGRAM
            #pragma target 5.0
            #pragma multi_compile _ DIRECTIONAL_COOKIE FOG_LINEAR POINT POINT_COOKIE SHADOWS_CUBE SHADOWS_DEPTH SHADOWS_SCREEN SHADOWS_SOFT SPOT
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0;
                float4 _Color;
                float _Tess;
                float _Disp;
                float _Phong;
                float4 _MainTex_ST;
                float4 cb0_values[5];
            };
            cbuffer _UnityPerCameraCB_b1
            {
                float4 _Time : packoffset(c0);
                float3 _WorldSpaceCameraPos : packoffset(c4);
            };
            cbuffer _UnityLightingCB_b2
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_OcclusionMaskSelector : packoffset(c46);
            };
            cbuffer _UnityProbeVolumeCB_b3
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
            struct program1Input
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
            struct program1Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program97Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program97Output
            {
                float4 sv_Target0 : SV_Target;
            };
            struct program34Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
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
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program153Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program153Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            #pragma vertex vert
            program1Output vert(program1Input i)
            {
                program1Output o = (program1Output)0;
                o.internaltesspos0.xyzw = i.position0.xyzw;
                o.tangent0.xyzw = i.tangent0.xyzw;
                o.normal0.xyz = i.normal0.xyz;
                o.texcoord0.xyzw = i.texcoord0.xyzw;
                o.texcoord1.xyzw = i.texcoord1.xyzw;
                o.texcoord2.xyzw = i.texcoord2.xyzw;
                o.texcoord3.xyzw = i.texcoord3.xyzw;
                o.color0.xyzw = i.color0.xyzw;
                return o;
            }
            #pragma fragment frag
            program97Output frag(program97Input i)
            {
                program97Output o = (program97Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r2_xyz_1 = (_MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy)).xyz;
                float r1_w_1 = (unity_ProbeVolumeParams.x == 1);
                float r4_x_10;
                float r4_y_10;
                float r4_z_10;
                float r4_w_4;
                if (r1_w_1)
                {
                    float r1_w_2 = (unity_ProbeVolumeParams.y == 1);
                    float3 r4_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r1_w_2.xxxx ? r4_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r4_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r4_y_8 = r4_xyzw_8.y;
                    float r4_z_8 = r4_xyzw_8.z;
                    float r4_w_2 = r4_xyzw_8.w;
                    float r1_w_3 = mad(r4_y_8, 0.25, 0.75);
                    float r2_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r4_x_8 = max(r1_w_3, r2_w_1);
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
                float r1_w_5 = saturate(dot(float4(r4_x_10, r4_y_10, r4_z_10, r4_w_4), unity_OcclusionMaskSelector));
                float3 r4_xyz_11 = ((r1_w_5.xxxx * _LightColor0.xyzx)).xyz;
                float3 r5_xyz_1 = normalize(i.texcoord1);
                float3 r2_xyz_3 = (mad((mad(r2_xyz_1.xyzx, cb0_values[4].xyzx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.1, 0.1, 0.1, 0), float4(0.04, 0.04, 0.04, 0))).xyz;
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unity_ObjectToWorld[0].xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = max(r0_w_3, 0.001);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 r0_xyz_3 = ((r0_w_5.xxxx * r0_xyz_2.xyzx)).xyz;
                float r0_w_6 = dot(r5_xyz_1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx);
                float r1_x_2 = saturate(dot(r5_xyz_1.xyzx, unity_ObjectToWorld[0].xyzx));
                float r1_y_2 = saturate(dot(r5_xyz_1.xyzx, r0_xyz_3.xyzx));
                float r0_x_4 = saturate(dot(unity_ObjectToWorld[0].xyzx, r0_xyz_3.xyzx));
                float r0_y_4 = mad(r0_x_4, r0_x_4, -0.5);
                float r0_z_4 = (-r1_x_2 + 1);
                float r1_z_2 = (r0_z_4 * r0_z_4);
                float r1_z_3 = (r1_z_2 * r1_z_2);
                float r0_z_5 = (r0_z_4 * r1_z_3);
                float r0_z_6 = mad(r0_y_4, r0_z_5, 1);
                float r1_z_4 = (-abs(r0_w_6) + 1);
                float r1_w_8 = (r1_z_4 * r1_z_4);
                float r1_w_9 = (r1_w_8 * r1_w_8);
                float r1_z_5 = (r1_z_4 * r1_w_9);
                float r0_y_5 = mad(r0_y_4, r1_z_5, 1);
                float r0_y_6 = (r0_y_5 * r0_z_6);
                float r0_z_7 = mad(abs(r0_w_6), 0.75, 0.25);
                float r1_z_6 = mad(r1_x_2, 0.75, 0.25);
                float r0_w_7 = (abs(r0_w_6) * r1_z_6);
                float r0_z_8 = mad(r1_x_2, r0_z_7, r0_w_7);
                float r0_z_9 = (r0_z_8 + 1E-05);
                float r0_w_8 = (r1_y_2 * r1_y_2);
                float r0_w_9 = mad(r0_w_8, -0.9375, 1);
                float r0_w_10 = mad(r0_w_9, r0_w_9, 1E-07);
                float4 r0_xyzw_10 = (float4(0, 0, 0.5, 0.019894367) / float4(r0_z_9, r0_z_9, r0_z_9, r0_w_10));
                float r0_z_10 = r0_xyzw_10.z;
                float r0_w_11 = r0_xyzw_10.w;
                float r0_z_11 = (r0_w_11 * r0_z_10);
                float r0_z_12 = (r0_z_11 * 3.1415927);
                float4 r0_xyzw_7 = (r1_x_2.xxxx * float4(r0_y_6, r0_y_6, r0_z_12, r0_y_6));
                float r0_y_7 = r0_xyzw_7.y;
                float r0_z_13 = r0_xyzw_7.z;
                float r0_w_12 = dot(r2_xyz_3.xyzx, r2_xyz_3.xyzx);
                float r0_w_13 = (r0_w_12 != 0);
                float r0_w_14 = asfloat(asint(r0_w_13) & asint(1065353216));
                float r0_z_14 = (r0_w_14 * r0_z_13);
                float4 r1_xyzw_3 = (r0_y_7.xxxx * r4_xyz_11.xyzx);
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_3 = r1_xyzw_3.y;
                float r1_z_7 = r1_xyzw_3.z;
                float4 r0_xyzw_8 = (r4_xyz_11.xxyz * r0_z_14.xxxx);
                float r0_y_8 = r0_xyzw_8.y;
                float r0_z_15 = r0_xyzw_8.z;
                float r0_w_15 = r0_xyzw_8.w;
                float r0_x_5 = (-r0_x_4 + 1);
                float r1_w_10 = (r0_x_5 * r0_x_5);
                float r1_w_11 = (r1_w_10 * r1_w_10);
                float r0_x_7 = ((float4(r0_y_8, r0_z_15, r0_w_15, r0_y_8) * (mad(((-r2_xyz_3.xyzx + float4(1, 1, 1, 0))).xyzx, ((r0_x_5 * r1_w_11)).xxxx, r2_xyz_3.xyzx)).xyzx)).x;
                float4 r0_xyzw_9 = (float4(r0_y_8, r0_z_15, r0_w_15, r0_y_8) * (mad(((-r2_xyz_3.xyzx + float4(1, 1, 1, 0))).xyzx, ((r0_x_5 * r1_w_11)).xxxx, r2_xyz_3.xyzx)).xyzx);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_16 = r0_xyzw_9.z;
                o.sv_Target0.xyz = (mad(((((r2_xyz_1.xyzx * cb0_values[4].xyzx)).xyzx * float4(0.86399996, 0.86399996, 0.86399996, 0))).xyzx, float4(r1_x_3, r1_y_3, r1_z_7, r1_x_3), float4(r0_x_7, r0_y_9, r0_z_16, r0_x_7))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            program34Output hull(program34Input i, uint inputforkinstanceid0)
            {
                program34Output o = (program34Output)0;
                // TODO: unhandled IR node — hs_fork_phase
                float r0_y_1 = inputforkinstanceid0.x;
                o.internaltesspos0.x = max(_Tess, 1);
                return o;
            }
            program153Output domain(program153Input i, float4 inputcontrolpoint1_0, float4 inputcontrolpoint1_2, float4 inputdomainpoint0, float4 inputcontrolpoint0_0, float4 inputcontrolpoint2_0, float4 inputcontrolpoint0_2, float4 inputcontrolpoint2_2, float4 inputcontrolpoint1_3, float4 inputcontrolpoint0_3, float4 inputcontrolpoint2_3)
            {
                program153Output o = (program153Output)0;
                float4 r1_xyzw_3 = mad(inputcontrolpoint2_0.xyzw, inputdomainpoint0.zzzz, mad(inputcontrolpoint0_0.xyzw, inputdomainpoint0.xxxx, (inputdomainpoint0.yyyy * inputcontrolpoint1_0.xyzw)));
                float r0_y_1 = dot(r1_xyzw_3.xyzx, inputcontrolpoint1_2.xyzx);
                float4 r0_xyzw_3 = mad(-inputcontrolpoint1_2.xyzx, ((dot(inputcontrolpoint1_0.xyzx, inputcontrolpoint1_2.xyzx) + r0_y_1)).xxxx, r1_xyzw_3.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_2 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = (float4(r0_x_3, r0_y_2, r0_z_1, r0_x_3) * inputdomainpoint0.yyyy);
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_3 = r0_xyzw_4.y;
                float r0_z_2 = r0_xyzw_4.z;
                float r0_w_1 = dot(inputcontrolpoint0_0.xyzx, inputcontrolpoint0_2.xyzx);
                float r0_w_2 = (-r0_w_1 + dot(r1_xyzw_3.xyzx, inputcontrolpoint0_2.xyzx));
                float4 r2_xyzw_2 = mad(-inputcontrolpoint0_2.xyzx, r0_w_2.xxxx, r1_xyzw_3.xyzx);
                float r2_x_2 = r2_xyzw_2.x;
                float r2_y_1 = r2_xyzw_2.y;
                float r2_z_1 = r2_xyzw_2.z;
                float4 r0_xyzw_5 = mad(float4(r2_x_2, r2_y_1, r2_z_1, r2_x_2), inputdomainpoint0.xxxx, float4(r0_x_4, r0_y_3, r0_z_2, r0_x_4));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_3 = r0_xyzw_5.z;
                float r0_w_3 = dot(inputcontrolpoint2_0.xyzx, inputcontrolpoint2_2.xyzx);
                float r0_w_4 = (-r0_w_3 + dot(r1_xyzw_3.xyzx, inputcontrolpoint2_2.xyzx));
                float4 r2_xyzw_4 = mad(-inputcontrolpoint2_2.xyzx, r0_w_4.xxxx, r1_xyzw_3.xyzx);
                float r2_x_4 = r2_xyzw_4.x;
                float r2_y_2 = r2_xyzw_4.y;
                float r2_z_2 = r2_xyzw_4.z;
                float4 r0_xyzw_6 = mad(float4(r2_x_4, r2_y_2, r2_z_2, r2_x_4), inputdomainpoint0.zzzz, float4(r0_x_5, r0_y_4, r0_z_3, r0_x_5));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_5 = r0_xyzw_6.y;
                float r0_z_4 = r0_xyzw_6.z;
                float r0_w_5 = (-_Phong + 1);
                float4 r0_xyzw_7 = mad(_Phong.xxxx, float4(r0_x_6, r0_y_5, r0_z_4, r0_x_6), ((r1_xyzw_3.xyzx * r0_w_5.xxxx)).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_6 = r0_xyzw_7.y;
                float r0_z_5 = r0_xyzw_7.z;
                float2 r1_xy_7 = (mad(inputcontrolpoint2_3.xyxx, inputdomainpoint0.zzzz, (mad(inputcontrolpoint0_3.xyxx, inputdomainpoint0.xxxx, ((inputdomainpoint0.yyyy * inputcontrolpoint1_3.xyxx)).xyxx)).xyxx)).xy;
                float r0_w_6 = (r1_xy_7.y * 10);
                float r0_w_7 = mad(-_Time.y, 0.5, r0_w_6);
                float r0_w_8 = cos(r0_w_7);
                float r1_z_5 = mad(r1_xy_7.x, 12, _Time.y);
                o.texcoord0.xy = (mad(r1_xy_7.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float r0_w_9 = (r0_w_8 * sin(r1_z_5));
                float4 r1_xyzw_9 = (inputdomainpoint0.yyyy * inputcontrolpoint1_2.xyzx);
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_8 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r1_xyzw_10 = mad(inputcontrolpoint0_2.xyzx, inputdomainpoint0.xxxx, float4(r1_x_9, r1_y_8, r1_z_6, r1_x_9));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_9 = r1_xyzw_10.y;
                float r1_z_7 = r1_xyzw_10.z;
                float4 r1_xyzw_11 = mad(inputcontrolpoint2_2.xyzx, inputdomainpoint0.zzzz, float4(r1_x_10, r1_y_9, r1_z_7, r1_x_10));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_10 = r1_xyzw_11.y;
                float r1_z_8 = r1_xyzw_11.z;
                float4 r2_xyzw_5 = (r0_w_9.xxxx * float4(r1_x_11, r1_y_10, r1_z_8, r1_x_11));
                float r2_x_5 = r2_xyzw_5.x;
                float r2_y_3 = r2_xyzw_5.y;
                float r2_z_3 = r2_xyzw_5.z;
                float4 r0_xyzw_8 = mad(float4(r2_x_5, r2_y_3, r2_z_3, r2_x_5), _Disp.xxxx, float4(r0_x_7, r0_y_6, r0_z_5, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_7 = r0_xyzw_8.y;
                float r0_z_6 = r0_xyzw_8.z;
                float4 r2_xyzw_6 = (r0_y_7.xxxx * unity_ObjectToWorld[1]);
                float4 r2_xyzw_7 = mad(unity_ObjectToWorld[0], r0_x_8.xxxx, r2_xyzw_6);
                float4 r0_xyzw_9 = mad(unity_ObjectToWorld[2], r0_z_6.xxxx, r2_xyzw_7);
                float4 r2_xyzw_8 = (r0_xyzw_9 + unity_ObjectToWorld[3]);
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, r1_xyzw_3.wwww, r0_xyzw_9.xyzx)).xyz;
                float4 r0_xyzw_10 = (r2_xyzw_8.yyyy * unity_MatrixVP[1]);
                float4 r0_xyzw_11 = mad(unity_MatrixVP[0], r2_xyzw_8.xxxx, r0_xyzw_10);
                float4 r0_xyzw_12 = mad(unity_MatrixVP[2], r2_xyzw_8.zzzz, r0_xyzw_11);
                o.sv_Position0.xyzw = mad(unity_MatrixVP[3], r2_xyzw_8.wwww, r0_xyzw_12);
                float r0_x_13 = dot(float4(r1_x_11, r1_y_10, r1_z_8, r1_x_11), unity_WorldToObject[0].xyzx);
                float r0_y_12 = dot(float4(r1_x_11, r1_y_10, r1_z_8, r1_x_11), unity_WorldToObject[1].xyzx);
                float r0_z_11 = dot(float4(r1_x_11, r1_y_10, r1_z_8, r1_x_11), unity_WorldToObject[2].xyzx);
                float r0_w_14 = dot(float4(r0_x_13, r0_y_12, r0_z_11, r0_x_13), float4(r0_x_13, r0_y_12, r0_z_11, r0_x_13));
                float r0_w_15 = rsqrt(r0_w_14);
                o.texcoord1.xyz = ((r0_w_15.xxxx * float4(r0_x_13, r0_y_12, r0_z_11, r0_x_13))).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
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
            #pragma target 5.0
            #pragma multi_compile _ LIGHTPROBE_SH
            #pragma multi_compile _ UNITY_HDR_ON
            cbuffer _GlobalsCB_b0
            {
                float4 _Color : packoffset(c4);
                float _Tess : packoffset(c5.x);
                float _Disp : packoffset(c5.y);
                float _Phong : packoffset(c5.z);
                float4 _MainTex_ST : packoffset(c6);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
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
            SamplerState sampler_MainTex1;
            Texture3D t1;
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[21];
            };
            #if defined(LIGHTPROBE_SH) && defined(UNITY_HDR_ON)
            struct program181Input
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
            struct program181Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program187Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
            };
            struct program187Output
            {
                float4 sv_Target0 : SV_Target;
                float4 sv_Target1 : SV_Target1;
                float4 sv_Target2 : SV_Target2;
                float4 sv_Target3 : SV_Target3;
            };
            struct program192Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program192Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program198Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program198Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
            };
            #pragma vertex vert
            program181Output vert(program181Input i)
            {
                program181Output o = (program181Output)0;
                o.internaltesspos0.xyzw = i.position0.xyzw;
                o.tangent0.xyzw = i.tangent0.xyzw;
                o.normal0.xyz = i.normal0.xyz;
                o.texcoord0.xyzw = i.texcoord0.xyzw;
                o.texcoord1.xyzw = i.texcoord1.xyzw;
                o.texcoord2.xyzw = i.texcoord2.xyzw;
                o.texcoord3.xyzw = i.texcoord3.xyzw;
                o.color0.xyzw = i.color0.xyzw;
                return o;
            }
            #pragma fragment frag
            program187Output frag(program187Input i)
            {
                program187Output o = (program187Output)0;
                float3 r0_xyz_1 = (_MainTex.Sample(sampler_MainTex1, (i.texcoord0.xyxx).xy)).xyz;
                float r0_w_1 = (cb2_values[0].x == 1);
                float3 TEXCOORD1_xyz_1;
                float3 r3_xyz_4;
                if (r0_w_1)
                {
                    float r0_w_2 = (cb2_values[0].y == 1);
                    float3 r2_xyz_5 = (((mad(cb2_values[3].xyzx, i.texcoord2.zzzz, (mad(cb2_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb2_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb2_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (((((r0_w_2.xxxx ? r2_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb2_values[6].xyzx)).xxyz * cb2_values[5].xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_8 = r2_xyzw_8.z;
                    float r2_w_2 = r2_xyzw_8.w;
                    float r0_w_3 = (r2_y_8 * 0.25);
                    float r1_w_1 = (cb2_values[0].z * 0.5);
                    float r2_y_9 = mad(-cb2_values[0].z, 0.5, 0.25);
                    float r0_w_4 = max(r0_w_3, r1_w_1);
                    float r2_x_8 = min(r2_y_9, r0_w_4);
                    float4 r3_xyzw_2 = t1.Sample(sampler_MainTex, (float4(r2_x_8, r2_z_8, r2_w_2, r2_x_8)).xyz);
                    float4 r4_xyzw_2 = t1.Sample(sampler_MainTex, (((float4(r2_x_8, r2_z_8, r2_w_2, r2_x_8) + float4(0.25, 0, 0, 0))).xyzx).xyz);
                    float4 r2_xyzw_9 = (float4(r2_x_8, r2_z_8, r2_w_2, r2_x_8) + float4(0.5, 0, 0, 0));
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_10 = r2_xyzw_9.y;
                    float r2_z_9 = r2_xyzw_9.z;
                    float4 r2_xyzw_10 = t1.Sample(sampler_MainTex, (float4(r2_x_9, r2_y_10, r2_z_9, r2_x_9)).xyz);
                    TEXCOORD1_xyz_1 = i.texcoord1.xyz;
                    float r5_w_1 = 1;
                    float r3_x_3 = dot(r3_xyzw_2, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r5_w_1));
                    float r3_y_3 = dot(r4_xyzw_2, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r5_w_1));
                    float r3_z_3 = dot(r2_xyzw_10, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r5_w_1));
                    r3_xyz_4 = float3(r3_x_3, r3_y_3, r3_z_3);
                }
                else
                {
                    TEXCOORD1_xyz_1 = i.texcoord1.xyz;
                    float r2_w_1 = 1;
                    float r3_x_1 = dot(cb1_values[39].xyzw, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r2_w_1));
                    float r3_y_1 = dot(cb1_values[40].xyzw, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r2_w_1));
                    float r3_z_1 = dot(cb1_values[41].xyzw, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r2_w_1));
                    r3_xyz_4 = float3(r3_x_1, r3_y_1, r3_z_1);
                }
                float4 r2_xyzw_12 = (r3_xyz_4.xyzx + i.texcoord5.xyzx);
                float r2_x_12 = r2_xyzw_12.x;
                float r2_y_13 = r2_xyzw_12.y;
                float r2_z_12 = r2_xyzw_12.z;
                float4 r2_xyzw_13 = max(float4(r2_x_12, r2_y_13, r2_z_12, r2_x_12), float4(0, 0, 0, 0));
                float r2_x_13 = r2_xyzw_13.x;
                float r2_y_14 = r2_xyzw_13.y;
                float r2_z_13 = r2_xyzw_13.z;
                o.sv_Target1.xyz = (mad((mad(r0_xyz_1.xyzx, _Color.xyzx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.1, 0.1, 0.1, 0), float4(0.04, 0.04, 0.04, 0))).xyz;
                float3 r0_xyz_3 = ((((r0_xyz_1.xyzx * _Color.xyzx)).xyzx * float4(0.86399996, 0.86399996, 0.86399996, 0))).xyz;
                o.sv_Target3.xyz = ((float4(r2_x_13, r2_y_14, r2_z_13, r2_x_13) * r0_xyz_3.xyzx)).xyz;
                o.sv_Target0.xyz = r0_xyz_3.xyz;
                o.sv_Target0.w = 1;
                o.sv_Target1.w = 0.5;
                o.sv_Target2.xyz = (mad(i.texcoord1.xyzx, float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
                o.sv_Target2.w = 1;
                o.sv_Target3.w = 1;
                return o;
            }
            program192Output hull(program192Input i, uint inputforkinstanceid0)
            {
                program192Output o = (program192Output)0;
                // TODO: unhandled IR node — hs_fork_phase
                float r0_y_1 = inputforkinstanceid0.x;
                o.internaltesspos0.x = max(_Tess, 1);
                return o;
            }
            program198Output domain(program198Input i, float4 inputcontrolpoint1_0, float4 inputcontrolpoint1_2, float4 inputdomainpoint0, float4 inputcontrolpoint0_0, float4 inputcontrolpoint2_0, float4 inputcontrolpoint0_2, float4 inputcontrolpoint2_2, float4 inputcontrolpoint1_3, float4 inputcontrolpoint0_3, float4 inputcontrolpoint2_3)
            {
                program198Output o = (program198Output)0;
                float4 r1_xyzw_3 = mad(inputcontrolpoint2_0.xyzw, inputdomainpoint0.zzzz, mad(inputcontrolpoint0_0.xyzw, inputdomainpoint0.xxxx, (inputdomainpoint0.yyyy * inputcontrolpoint1_0.xyzw)));
                float r0_y_1 = dot(r1_xyzw_3.xyzx, inputcontrolpoint1_2.xyzx);
                float4 r0_xyzw_3 = mad(-inputcontrolpoint1_2.xyzx, ((dot(inputcontrolpoint1_0.xyzx, inputcontrolpoint1_2.xyzx) + r0_y_1)).xxxx, r1_xyzw_3.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_2 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = (float4(r0_x_3, r0_y_2, r0_z_1, r0_x_3) * inputdomainpoint0.yyyy);
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_3 = r0_xyzw_4.y;
                float r0_z_2 = r0_xyzw_4.z;
                float r0_w_1 = dot(inputcontrolpoint0_0.xyzx, inputcontrolpoint0_2.xyzx);
                float r0_w_2 = (-r0_w_1 + dot(r1_xyzw_3.xyzx, inputcontrolpoint0_2.xyzx));
                float4 r2_xyzw_2 = mad(-inputcontrolpoint0_2.xyzx, r0_w_2.xxxx, r1_xyzw_3.xyzx);
                float r2_x_2 = r2_xyzw_2.x;
                float r2_y_1 = r2_xyzw_2.y;
                float r2_z_1 = r2_xyzw_2.z;
                float4 r0_xyzw_5 = mad(float4(r2_x_2, r2_y_1, r2_z_1, r2_x_2), inputdomainpoint0.xxxx, float4(r0_x_4, r0_y_3, r0_z_2, r0_x_4));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_3 = r0_xyzw_5.z;
                float r0_w_3 = dot(inputcontrolpoint2_0.xyzx, inputcontrolpoint2_2.xyzx);
                float r0_w_4 = (-r0_w_3 + dot(r1_xyzw_3.xyzx, inputcontrolpoint2_2.xyzx));
                float4 r2_xyzw_4 = mad(-inputcontrolpoint2_2.xyzx, r0_w_4.xxxx, r1_xyzw_3.xyzx);
                float r2_x_4 = r2_xyzw_4.x;
                float r2_y_2 = r2_xyzw_4.y;
                float r2_z_2 = r2_xyzw_4.z;
                float4 r0_xyzw_6 = mad(float4(r2_x_4, r2_y_2, r2_z_2, r2_x_4), inputdomainpoint0.zzzz, float4(r0_x_5, r0_y_4, r0_z_3, r0_x_5));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_5 = r0_xyzw_6.y;
                float r0_z_4 = r0_xyzw_6.z;
                float r0_w_5 = (-_Phong + 1);
                float4 r0_xyzw_7 = mad(_Phong.xxxx, float4(r0_x_6, r0_y_5, r0_z_4, r0_x_6), ((r1_xyzw_3.xyzx * r0_w_5.xxxx)).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_6 = r0_xyzw_7.y;
                float r0_z_5 = r0_xyzw_7.z;
                float2 r1_xy_7 = (mad(inputcontrolpoint2_3.xyxx, inputdomainpoint0.zzzz, (mad(inputcontrolpoint0_3.xyxx, inputdomainpoint0.xxxx, ((inputdomainpoint0.yyyy * inputcontrolpoint1_3.xyxx)).xyxx)).xyxx)).xy;
                float r0_w_6 = (r1_xy_7.y * 10);
                float r0_w_7 = mad(-_Time.y, 0.5, r0_w_6);
                float r0_w_8 = cos(r0_w_7);
                float r1_z_5 = mad(r1_xy_7.x, 12, _Time.y);
                o.texcoord0.xy = (mad(r1_xy_7.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float r0_w_9 = (r0_w_8 * sin(r1_z_5));
                float4 r1_xyzw_9 = (inputdomainpoint0.yyyy * inputcontrolpoint1_2.xyzx);
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_8 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r1_xyzw_10 = mad(inputcontrolpoint0_2.xyzx, inputdomainpoint0.xxxx, float4(r1_x_9, r1_y_8, r1_z_6, r1_x_9));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_9 = r1_xyzw_10.y;
                float r1_z_7 = r1_xyzw_10.z;
                float4 r1_xyzw_11 = mad(inputcontrolpoint2_2.xyzx, inputdomainpoint0.zzzz, float4(r1_x_10, r1_y_9, r1_z_7, r1_x_10));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_10 = r1_xyzw_11.y;
                float r1_z_8 = r1_xyzw_11.z;
                float4 r2_xyzw_5 = (r0_w_9.xxxx * float4(r1_x_11, r1_y_10, r1_z_8, r1_x_11));
                float r2_x_5 = r2_xyzw_5.x;
                float r2_y_3 = r2_xyzw_5.y;
                float r2_z_3 = r2_xyzw_5.z;
                float4 r0_xyzw_8 = mad(float4(r2_x_5, r2_y_3, r2_z_3, r2_x_5), _Disp.xxxx, float4(r0_x_7, r0_y_6, r0_z_5, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_7 = r0_xyzw_8.y;
                float r0_z_6 = r0_xyzw_8.z;
                float4 r2_xyzw_6 = (r0_y_7.xxxx * cb3_values[1].xyzw);
                float4 r2_xyzw_7 = mad(cb3_values[0].xyzw, r0_x_8.xxxx, r2_xyzw_6);
                float4 r0_xyzw_9 = mad(cb3_values[2].xyzw, r0_z_6.xxxx, r2_xyzw_7);
                float4 r2_xyzw_8 = (r0_xyzw_9 + cb3_values[3].xyzw);
                o.texcoord2.xyz = (mad(cb3_values[3].xyzx, r1_xyzw_3.wwww, r0_xyzw_9.xyzx)).xyz;
                float4 r0_xyzw_10 = (r2_xyzw_8.yyyy * cb4_values[18].xyzw);
                float4 r0_xyzw_11 = mad(cb4_values[17].xyzw, r2_xyzw_8.xxxx, r0_xyzw_10);
                float4 r0_xyzw_12 = mad(cb4_values[19].xyzw, r2_xyzw_8.zzzz, r0_xyzw_11);
                o.sv_Position0.xyzw = mad(cb4_values[20].xyzw, r2_xyzw_8.wwww, r0_xyzw_12);
                float r0_x_13 = dot(float4(r1_x_11, r1_y_10, r1_z_8, r1_x_11), cb3_values[4].xyzx);
                float r0_y_12 = dot(float4(r1_x_11, r1_y_10, r1_z_8, r1_x_11), cb3_values[5].xyzx);
                float r0_z_11 = dot(float4(r1_x_11, r1_y_10, r1_z_8, r1_x_11), cb3_values[6].xyzx);
                float r0_w_14 = dot(float4(r0_x_13, r0_y_12, r0_z_11, r0_x_13), float4(r0_x_13, r0_y_12, r0_z_11, r0_x_13));
                float r0_w_15 = rsqrt(r0_w_14);
                float4 r0_xyzw_14 = (r0_w_15.xxxx * float4(r0_x_13, r0_y_12, r0_z_11, r0_x_13));
                float r0_x_14 = r0_xyzw_14.x;
                float r0_y_13 = r0_xyzw_14.y;
                float r0_z_12 = r0_xyzw_14.z;
                o.texcoord1.xyz = (float4(r0_x_14, r0_y_13, r0_z_12, r0_x_14)).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                float r0_w_16 = (r0_y_13 * r0_y_13);
                float r0_w_17 = mad(r0_x_14, r0_x_14, -r0_w_16);
                float4 r1_xyzw_12 = (float4(r0_y_13, r0_z_12, r0_z_12, r0_x_14) * float4(r0_x_14, r0_y_13, r0_z_12, r0_z_12));
                float r0_x_15 = dot(cb2_values[42].xyzw, r1_xyzw_12);
                float r0_y_14 = dot(cb2_values[43].xyzw, r1_xyzw_12);
                float r0_z_13 = dot(cb2_values[44].xyzw, r1_xyzw_12);
                o.texcoord5.xyz = (mad(cb2_values[45].xyzx, r0_w_17.xxxx, float4(r0_x_15, r0_y_14, r0_z_13, r0_x_15))).xyz;
                return o;
            }
            #elif defined(LIGHTPROBE_SH)
            struct program179Input
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
            struct program179Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program185Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
            };
            struct program185Output
            {
                float4 sv_Target0 : SV_Target;
                float4 sv_Target1 : SV_Target1;
                float4 sv_Target2 : SV_Target2;
                float4 sv_Target3 : SV_Target3;
            };
            struct program190Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program190Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program196Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program196Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
            };
            #pragma vertex vert
            program179Output vert(program179Input i)
            {
                program179Output o = (program179Output)0;
                o.internaltesspos0.xyzw = i.position0.xyzw;
                o.tangent0.xyzw = i.tangent0.xyzw;
                o.normal0.xyz = i.normal0.xyz;
                o.texcoord0.xyzw = i.texcoord0.xyzw;
                o.texcoord1.xyzw = i.texcoord1.xyzw;
                o.texcoord2.xyzw = i.texcoord2.xyzw;
                o.texcoord3.xyzw = i.texcoord3.xyzw;
                o.color0.xyzw = i.color0.xyzw;
                return o;
            }
            #pragma fragment frag
            program185Output frag(program185Input i)
            {
                program185Output o = (program185Output)0;
                float3 r0_xyz_1 = (_MainTex.Sample(sampler_MainTex1, (i.texcoord0.xyxx).xy)).xyz;
                float r0_w_1 = (cb2_values[0].x == 1);
                float3 TEXCOORD1_xyz_1;
                float3 r3_xyz_4;
                if (r0_w_1)
                {
                    float r0_w_2 = (cb2_values[0].y == 1);
                    float3 r2_xyz_5 = (((mad(cb2_values[3].xyzx, i.texcoord2.zzzz, (mad(cb2_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb2_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb2_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (((((r0_w_2.xxxx ? r2_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb2_values[6].xyzx)).xxyz * cb2_values[5].xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_8 = r2_xyzw_8.z;
                    float r2_w_2 = r2_xyzw_8.w;
                    float r0_w_3 = (r2_y_8 * 0.25);
                    float r1_w_1 = (cb2_values[0].z * 0.5);
                    float r2_y_9 = mad(-cb2_values[0].z, 0.5, 0.25);
                    float r0_w_4 = max(r0_w_3, r1_w_1);
                    float r2_x_8 = min(r2_y_9, r0_w_4);
                    float4 r3_xyzw_2 = t1.Sample(sampler_MainTex, (float4(r2_x_8, r2_z_8, r2_w_2, r2_x_8)).xyz);
                    float4 r4_xyzw_2 = t1.Sample(sampler_MainTex, (((float4(r2_x_8, r2_z_8, r2_w_2, r2_x_8) + float4(0.25, 0, 0, 0))).xyzx).xyz);
                    float4 r2_xyzw_9 = (float4(r2_x_8, r2_z_8, r2_w_2, r2_x_8) + float4(0.5, 0, 0, 0));
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_10 = r2_xyzw_9.y;
                    float r2_z_9 = r2_xyzw_9.z;
                    float4 r2_xyzw_10 = t1.Sample(sampler_MainTex, (float4(r2_x_9, r2_y_10, r2_z_9, r2_x_9)).xyz);
                    TEXCOORD1_xyz_1 = i.texcoord1.xyz;
                    float r5_w_1 = 1;
                    float r3_x_3 = dot(r3_xyzw_2, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r5_w_1));
                    float r3_y_3 = dot(r4_xyzw_2, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r5_w_1));
                    float r3_z_3 = dot(r2_xyzw_10, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r5_w_1));
                    r3_xyz_4 = float3(r3_x_3, r3_y_3, r3_z_3);
                }
                else
                {
                    TEXCOORD1_xyz_1 = i.texcoord1.xyz;
                    float r2_w_1 = 1;
                    float r3_x_1 = dot(cb1_values[39].xyzw, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r2_w_1));
                    float r3_y_1 = dot(cb1_values[40].xyzw, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r2_w_1));
                    float r3_z_1 = dot(cb1_values[41].xyzw, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r2_w_1));
                    r3_xyz_4 = float3(r3_x_1, r3_y_1, r3_z_1);
                }
                float4 r2_xyzw_12 = (r3_xyz_4.xyzx + i.texcoord5.xyzx);
                float r2_x_12 = r2_xyzw_12.x;
                float r2_y_13 = r2_xyzw_12.y;
                float r2_z_12 = r2_xyzw_12.z;
                float4 r2_xyzw_13 = max(float4(r2_x_12, r2_y_13, r2_z_12, r2_x_12), float4(0, 0, 0, 0));
                float r2_x_13 = r2_xyzw_13.x;
                float r2_y_14 = r2_xyzw_13.y;
                float r2_z_13 = r2_xyzw_13.z;
                o.sv_Target1.xyz = (mad((mad(r0_xyz_1.xyzx, _Color.xyzx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.1, 0.1, 0.1, 0), float4(0.04, 0.04, 0.04, 0))).xyz;
                float3 r0_xyz_3 = ((((r0_xyz_1.xyzx * _Color.xyzx)).xyzx * float4(0.86399996, 0.86399996, 0.86399996, 0))).xyz;
                o.sv_Target3.xyz = (exp2(((float4(r2_x_13, r2_y_14, r2_z_13, r2_x_13) * r0_xyz_3.xyzx)).xyzx)).xyz;
                o.sv_Target0.xyz = r0_xyz_3.xyz;
                o.sv_Target0.w = 1;
                o.sv_Target1.w = 0.5;
                o.sv_Target2.xyz = (mad(i.texcoord1.xyzx, float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
                o.sv_Target2.w = 1;
                o.sv_Target3.w = 1;
                return o;
            }
            program190Output hull(program190Input i, uint inputforkinstanceid0)
            {
                program190Output o = (program190Output)0;
                // TODO: unhandled IR node — hs_fork_phase
                float r0_y_1 = inputforkinstanceid0.x;
                o.internaltesspos0.x = max(_Tess, 1);
                return o;
            }
            program196Output domain(program196Input i, float4 inputcontrolpoint1_0, float4 inputcontrolpoint1_2, float4 inputdomainpoint0, float4 inputcontrolpoint0_0, float4 inputcontrolpoint2_0, float4 inputcontrolpoint0_2, float4 inputcontrolpoint2_2, float4 inputcontrolpoint1_3, float4 inputcontrolpoint0_3, float4 inputcontrolpoint2_3)
            {
                program196Output o = (program196Output)0;
                float4 r1_xyzw_3 = mad(inputcontrolpoint2_0.xyzw, inputdomainpoint0.zzzz, mad(inputcontrolpoint0_0.xyzw, inputdomainpoint0.xxxx, (inputdomainpoint0.yyyy * inputcontrolpoint1_0.xyzw)));
                float r0_y_1 = dot(r1_xyzw_3.xyzx, inputcontrolpoint1_2.xyzx);
                float4 r0_xyzw_3 = mad(-inputcontrolpoint1_2.xyzx, ((dot(inputcontrolpoint1_0.xyzx, inputcontrolpoint1_2.xyzx) + r0_y_1)).xxxx, r1_xyzw_3.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_2 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = (float4(r0_x_3, r0_y_2, r0_z_1, r0_x_3) * inputdomainpoint0.yyyy);
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_3 = r0_xyzw_4.y;
                float r0_z_2 = r0_xyzw_4.z;
                float r0_w_1 = dot(inputcontrolpoint0_0.xyzx, inputcontrolpoint0_2.xyzx);
                float r0_w_2 = (-r0_w_1 + dot(r1_xyzw_3.xyzx, inputcontrolpoint0_2.xyzx));
                float4 r2_xyzw_2 = mad(-inputcontrolpoint0_2.xyzx, r0_w_2.xxxx, r1_xyzw_3.xyzx);
                float r2_x_2 = r2_xyzw_2.x;
                float r2_y_1 = r2_xyzw_2.y;
                float r2_z_1 = r2_xyzw_2.z;
                float4 r0_xyzw_5 = mad(float4(r2_x_2, r2_y_1, r2_z_1, r2_x_2), inputdomainpoint0.xxxx, float4(r0_x_4, r0_y_3, r0_z_2, r0_x_4));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_3 = r0_xyzw_5.z;
                float r0_w_3 = dot(inputcontrolpoint2_0.xyzx, inputcontrolpoint2_2.xyzx);
                float r0_w_4 = (-r0_w_3 + dot(r1_xyzw_3.xyzx, inputcontrolpoint2_2.xyzx));
                float4 r2_xyzw_4 = mad(-inputcontrolpoint2_2.xyzx, r0_w_4.xxxx, r1_xyzw_3.xyzx);
                float r2_x_4 = r2_xyzw_4.x;
                float r2_y_2 = r2_xyzw_4.y;
                float r2_z_2 = r2_xyzw_4.z;
                float4 r0_xyzw_6 = mad(float4(r2_x_4, r2_y_2, r2_z_2, r2_x_4), inputdomainpoint0.zzzz, float4(r0_x_5, r0_y_4, r0_z_3, r0_x_5));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_5 = r0_xyzw_6.y;
                float r0_z_4 = r0_xyzw_6.z;
                float r0_w_5 = (-_Phong + 1);
                float4 r0_xyzw_7 = mad(_Phong.xxxx, float4(r0_x_6, r0_y_5, r0_z_4, r0_x_6), ((r1_xyzw_3.xyzx * r0_w_5.xxxx)).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_6 = r0_xyzw_7.y;
                float r0_z_5 = r0_xyzw_7.z;
                float2 r1_xy_7 = (mad(inputcontrolpoint2_3.xyxx, inputdomainpoint0.zzzz, (mad(inputcontrolpoint0_3.xyxx, inputdomainpoint0.xxxx, ((inputdomainpoint0.yyyy * inputcontrolpoint1_3.xyxx)).xyxx)).xyxx)).xy;
                float r0_w_6 = (r1_xy_7.y * 10);
                float r0_w_7 = mad(-_Time.y, 0.5, r0_w_6);
                float r0_w_8 = cos(r0_w_7);
                float r1_z_5 = mad(r1_xy_7.x, 12, _Time.y);
                o.texcoord0.xy = (mad(r1_xy_7.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float r0_w_9 = (r0_w_8 * sin(r1_z_5));
                float4 r1_xyzw_9 = (inputdomainpoint0.yyyy * inputcontrolpoint1_2.xyzx);
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_8 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r1_xyzw_10 = mad(inputcontrolpoint0_2.xyzx, inputdomainpoint0.xxxx, float4(r1_x_9, r1_y_8, r1_z_6, r1_x_9));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_9 = r1_xyzw_10.y;
                float r1_z_7 = r1_xyzw_10.z;
                float4 r1_xyzw_11 = mad(inputcontrolpoint2_2.xyzx, inputdomainpoint0.zzzz, float4(r1_x_10, r1_y_9, r1_z_7, r1_x_10));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_10 = r1_xyzw_11.y;
                float r1_z_8 = r1_xyzw_11.z;
                float4 r2_xyzw_5 = (r0_w_9.xxxx * float4(r1_x_11, r1_y_10, r1_z_8, r1_x_11));
                float r2_x_5 = r2_xyzw_5.x;
                float r2_y_3 = r2_xyzw_5.y;
                float r2_z_3 = r2_xyzw_5.z;
                float4 r0_xyzw_8 = mad(float4(r2_x_5, r2_y_3, r2_z_3, r2_x_5), _Disp.xxxx, float4(r0_x_7, r0_y_6, r0_z_5, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_7 = r0_xyzw_8.y;
                float r0_z_6 = r0_xyzw_8.z;
                float4 r2_xyzw_6 = (r0_y_7.xxxx * cb3_values[1].xyzw);
                float4 r2_xyzw_7 = mad(cb3_values[0].xyzw, r0_x_8.xxxx, r2_xyzw_6);
                float4 r0_xyzw_9 = mad(cb3_values[2].xyzw, r0_z_6.xxxx, r2_xyzw_7);
                float4 r2_xyzw_8 = (r0_xyzw_9 + cb3_values[3].xyzw);
                o.texcoord2.xyz = (mad(cb3_values[3].xyzx, r1_xyzw_3.wwww, r0_xyzw_9.xyzx)).xyz;
                float4 r0_xyzw_10 = (r2_xyzw_8.yyyy * cb4_values[18].xyzw);
                float4 r0_xyzw_11 = mad(cb4_values[17].xyzw, r2_xyzw_8.xxxx, r0_xyzw_10);
                float4 r0_xyzw_12 = mad(cb4_values[19].xyzw, r2_xyzw_8.zzzz, r0_xyzw_11);
                o.sv_Position0.xyzw = mad(cb4_values[20].xyzw, r2_xyzw_8.wwww, r0_xyzw_12);
                float r0_x_13 = dot(float4(r1_x_11, r1_y_10, r1_z_8, r1_x_11), cb3_values[4].xyzx);
                float r0_y_12 = dot(float4(r1_x_11, r1_y_10, r1_z_8, r1_x_11), cb3_values[5].xyzx);
                float r0_z_11 = dot(float4(r1_x_11, r1_y_10, r1_z_8, r1_x_11), cb3_values[6].xyzx);
                float r0_w_14 = dot(float4(r0_x_13, r0_y_12, r0_z_11, r0_x_13), float4(r0_x_13, r0_y_12, r0_z_11, r0_x_13));
                float r0_w_15 = rsqrt(r0_w_14);
                float4 r0_xyzw_14 = (r0_w_15.xxxx * float4(r0_x_13, r0_y_12, r0_z_11, r0_x_13));
                float r0_x_14 = r0_xyzw_14.x;
                float r0_y_13 = r0_xyzw_14.y;
                float r0_z_12 = r0_xyzw_14.z;
                o.texcoord1.xyz = (float4(r0_x_14, r0_y_13, r0_z_12, r0_x_14)).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                float r0_w_16 = (r0_y_13 * r0_y_13);
                float r0_w_17 = mad(r0_x_14, r0_x_14, -r0_w_16);
                float4 r1_xyzw_12 = (float4(r0_y_13, r0_z_12, r0_z_12, r0_x_14) * float4(r0_x_14, r0_y_13, r0_z_12, r0_z_12));
                float r0_x_15 = dot(cb2_values[42].xyzw, r1_xyzw_12);
                float r0_y_14 = dot(cb2_values[43].xyzw, r1_xyzw_12);
                float r0_z_13 = dot(cb2_values[44].xyzw, r1_xyzw_12);
                o.texcoord5.xyz = (mad(cb2_values[45].xyzx, r0_w_17.xxxx, float4(r0_x_15, r0_y_14, r0_z_13, r0_x_15))).xyz;
                return o;
            }
            #elif defined(UNITY_HDR_ON)
            struct program180Input
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
            struct program180Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program186Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program186Output
            {
                float4 sv_Target0 : SV_Target;
                float4 sv_Target1 : SV_Target1;
                float4 sv_Target2 : SV_Target2;
                float4 sv_Target3 : SV_Target3;
            };
            struct program191Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program191Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program197Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program197Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            #pragma vertex vert
            program180Output vert(program180Input i)
            {
                program180Output o = (program180Output)0;
                o.internaltesspos0.xyzw = i.position0.xyzw;
                o.tangent0.xyzw = i.tangent0.xyzw;
                o.normal0.xyz = i.normal0.xyz;
                o.texcoord0.xyzw = i.texcoord0.xyzw;
                o.texcoord1.xyzw = i.texcoord1.xyzw;
                o.texcoord2.xyzw = i.texcoord2.xyzw;
                o.texcoord3.xyzw = i.texcoord3.xyzw;
                o.color0.xyzw = i.color0.xyzw;
                return o;
            }
            #pragma fragment frag
            program186Output frag(program186Input i)
            {
                program186Output o = (program186Output)0;
                float3 r0_xyz_1 = (_MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy)).xyz;
                o.sv_Target1.xyz = (mad((mad(r0_xyz_1.xyzx, _Color.xyzx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.1, 0.1, 0.1, 0), float4(0.04, 0.04, 0.04, 0))).xyz;
                o.sv_Target0.xyz = ((((r0_xyz_1.xyzx * _Color.xyzx)).xyzx * float4(0.86399996, 0.86399996, 0.86399996, 0))).xyz;
                o.sv_Target0.w = 1;
                o.sv_Target1.w = 0.5;
                o.sv_Target2.xyz = (mad(i.texcoord1.xyzx, float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
                o.sv_Target2.w = 1;
                o.sv_Target3.xyzw = float4(0, 0, 0, 1);
                return o;
            }
            program191Output hull(program191Input i, uint inputforkinstanceid0)
            {
                program191Output o = (program191Output)0;
                // TODO: unhandled IR node — hs_fork_phase
                float r0_y_1 = inputforkinstanceid0.x;
                o.internaltesspos0.x = max(_Tess, 1);
                return o;
            }
            program197Output domain(program197Input i, float4 inputcontrolpoint1_0, float4 inputcontrolpoint1_2, float4 inputdomainpoint0, float4 inputcontrolpoint0_0, float4 inputcontrolpoint2_0, float4 inputcontrolpoint0_2, float4 inputcontrolpoint2_2, float4 inputcontrolpoint1_3, float4 inputcontrolpoint0_3, float4 inputcontrolpoint2_3)
            {
                program197Output o = (program197Output)0;
                float4 r1_xyzw_3 = mad(inputcontrolpoint2_0.xyzw, inputdomainpoint0.zzzz, mad(inputcontrolpoint0_0.xyzw, inputdomainpoint0.xxxx, (inputdomainpoint0.yyyy * inputcontrolpoint1_0.xyzw)));
                float r0_y_1 = dot(r1_xyzw_3.xyzx, inputcontrolpoint1_2.xyzx);
                float4 r0_xyzw_3 = mad(-inputcontrolpoint1_2.xyzx, ((dot(inputcontrolpoint1_0.xyzx, inputcontrolpoint1_2.xyzx) + r0_y_1)).xxxx, r1_xyzw_3.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_2 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = (float4(r0_x_3, r0_y_2, r0_z_1, r0_x_3) * inputdomainpoint0.yyyy);
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_3 = r0_xyzw_4.y;
                float r0_z_2 = r0_xyzw_4.z;
                float r0_w_1 = dot(inputcontrolpoint0_0.xyzx, inputcontrolpoint0_2.xyzx);
                float r0_w_2 = (-r0_w_1 + dot(r1_xyzw_3.xyzx, inputcontrolpoint0_2.xyzx));
                float4 r2_xyzw_2 = mad(-inputcontrolpoint0_2.xyzx, r0_w_2.xxxx, r1_xyzw_3.xyzx);
                float r2_x_2 = r2_xyzw_2.x;
                float r2_y_1 = r2_xyzw_2.y;
                float r2_z_1 = r2_xyzw_2.z;
                float4 r0_xyzw_5 = mad(float4(r2_x_2, r2_y_1, r2_z_1, r2_x_2), inputdomainpoint0.xxxx, float4(r0_x_4, r0_y_3, r0_z_2, r0_x_4));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_3 = r0_xyzw_5.z;
                float r0_w_3 = dot(inputcontrolpoint2_0.xyzx, inputcontrolpoint2_2.xyzx);
                float r0_w_4 = (-r0_w_3 + dot(r1_xyzw_3.xyzx, inputcontrolpoint2_2.xyzx));
                float4 r2_xyzw_4 = mad(-inputcontrolpoint2_2.xyzx, r0_w_4.xxxx, r1_xyzw_3.xyzx);
                float r2_x_4 = r2_xyzw_4.x;
                float r2_y_2 = r2_xyzw_4.y;
                float r2_z_2 = r2_xyzw_4.z;
                float4 r0_xyzw_6 = mad(float4(r2_x_4, r2_y_2, r2_z_2, r2_x_4), inputdomainpoint0.zzzz, float4(r0_x_5, r0_y_4, r0_z_3, r0_x_5));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_5 = r0_xyzw_6.y;
                float r0_z_4 = r0_xyzw_6.z;
                float r0_w_5 = (-_Phong + 1);
                float4 r0_xyzw_7 = mad(_Phong.xxxx, float4(r0_x_6, r0_y_5, r0_z_4, r0_x_6), ((r1_xyzw_3.xyzx * r0_w_5.xxxx)).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_6 = r0_xyzw_7.y;
                float r0_z_5 = r0_xyzw_7.z;
                float2 r1_xy_7 = (mad(inputcontrolpoint2_3.xyxx, inputdomainpoint0.zzzz, (mad(inputcontrolpoint0_3.xyxx, inputdomainpoint0.xxxx, ((inputdomainpoint0.yyyy * inputcontrolpoint1_3.xyxx)).xyxx)).xyxx)).xy;
                float r0_w_6 = (r1_xy_7.y * 10);
                float r0_w_7 = mad(-_Time.y, 0.5, r0_w_6);
                float r0_w_8 = cos(r0_w_7);
                float r1_z_5 = mad(r1_xy_7.x, 12, _Time.y);
                o.texcoord0.xy = (mad(r1_xy_7.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float r0_w_9 = (r0_w_8 * sin(r1_z_5));
                float4 r1_xyzw_9 = (inputdomainpoint0.yyyy * inputcontrolpoint1_2.xyzx);
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_8 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r1_xyzw_10 = mad(inputcontrolpoint0_2.xyzx, inputdomainpoint0.xxxx, float4(r1_x_9, r1_y_8, r1_z_6, r1_x_9));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_9 = r1_xyzw_10.y;
                float r1_z_7 = r1_xyzw_10.z;
                float4 r1_xyzw_11 = mad(inputcontrolpoint2_2.xyzx, inputdomainpoint0.zzzz, float4(r1_x_10, r1_y_9, r1_z_7, r1_x_10));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_10 = r1_xyzw_11.y;
                float r1_z_8 = r1_xyzw_11.z;
                float4 r2_xyzw_5 = (r0_w_9.xxxx * float4(r1_x_11, r1_y_10, r1_z_8, r1_x_11));
                float r2_x_5 = r2_xyzw_5.x;
                float r2_y_3 = r2_xyzw_5.y;
                float r2_z_3 = r2_xyzw_5.z;
                float4 r0_xyzw_8 = mad(float4(r2_x_5, r2_y_3, r2_z_3, r2_x_5), _Disp.xxxx, float4(r0_x_7, r0_y_6, r0_z_5, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_7 = r0_xyzw_8.y;
                float r0_z_6 = r0_xyzw_8.z;
                float4 r2_xyzw_6 = (r0_y_7.xxxx * unity_ObjectToWorld[1]);
                float4 r2_xyzw_7 = mad(unity_ObjectToWorld[0], r0_x_8.xxxx, r2_xyzw_6);
                float4 r0_xyzw_9 = mad(unity_ObjectToWorld[2], r0_z_6.xxxx, r2_xyzw_7);
                float4 r2_xyzw_8 = (r0_xyzw_9 + unity_ObjectToWorld[3]);
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, r1_xyzw_3.wwww, r0_xyzw_9.xyzx)).xyz;
                float4 r0_xyzw_10 = (r2_xyzw_8.yyyy * unity_MatrixVP[1]);
                float4 r0_xyzw_11 = mad(unity_MatrixVP[0], r2_xyzw_8.xxxx, r0_xyzw_10);
                float4 r0_xyzw_12 = mad(unity_MatrixVP[2], r2_xyzw_8.zzzz, r0_xyzw_11);
                o.sv_Position0.xyzw = mad(unity_MatrixVP[3], r2_xyzw_8.wwww, r0_xyzw_12);
                float r0_x_13 = dot(float4(r1_x_11, r1_y_10, r1_z_8, r1_x_11), unity_WorldToObject[0].xyzx);
                float r0_y_12 = dot(float4(r1_x_11, r1_y_10, r1_z_8, r1_x_11), unity_WorldToObject[1].xyzx);
                float r0_z_11 = dot(float4(r1_x_11, r1_y_10, r1_z_8, r1_x_11), unity_WorldToObject[2].xyzx);
                float r0_w_14 = dot(float4(r0_x_13, r0_y_12, r0_z_11, r0_x_13), float4(r0_x_13, r0_y_12, r0_z_11, r0_x_13));
                float r0_w_15 = rsqrt(r0_w_14);
                o.texcoord1.xyz = ((r0_w_15.xxxx * float4(r0_x_13, r0_y_12, r0_z_11, r0_x_13))).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #else
            struct program178Input
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
            struct program178Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program184Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program184Output
            {
                float4 sv_Target0 : SV_Target;
                float4 sv_Target1 : SV_Target1;
                float4 sv_Target2 : SV_Target2;
                float4 sv_Target3 : SV_Target3;
            };
            struct program189Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program189Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program195Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program195Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            #pragma vertex vert
            program178Output vert(program178Input i)
            {
                program178Output o = (program178Output)0;
                o.internaltesspos0.xyzw = i.position0.xyzw;
                o.tangent0.xyzw = i.tangent0.xyzw;
                o.normal0.xyz = i.normal0.xyz;
                o.texcoord0.xyzw = i.texcoord0.xyzw;
                o.texcoord1.xyzw = i.texcoord1.xyzw;
                o.texcoord2.xyzw = i.texcoord2.xyzw;
                o.texcoord3.xyzw = i.texcoord3.xyzw;
                o.color0.xyzw = i.color0.xyzw;
                return o;
            }
            #pragma fragment frag
            program184Output frag(program184Input i)
            {
                program184Output o = (program184Output)0;
                float3 r0_xyz_1 = (_MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy)).xyz;
                o.sv_Target1.xyz = (mad((mad(r0_xyz_1.xyzx, _Color.xyzx, float4(-0.04, -0.04, -0.04, 0))).xyzx, float4(0.1, 0.1, 0.1, 0), float4(0.04, 0.04, 0.04, 0))).xyz;
                o.sv_Target0.xyz = ((((r0_xyz_1.xyzx * _Color.xyzx)).xyzx * float4(0.86399996, 0.86399996, 0.86399996, 0))).xyz;
                o.sv_Target0.w = 1;
                o.sv_Target1.w = 0.5;
                o.sv_Target2.xyz = (mad(i.texcoord1.xyzx, float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
                o.sv_Target2.w = 1;
                o.sv_Target3.xyzw = float4(1, 1, 1, 1);
                return o;
            }
            program189Output hull(program189Input i, uint inputforkinstanceid0)
            {
                program189Output o = (program189Output)0;
                // TODO: unhandled IR node — hs_fork_phase
                float r0_y_1 = inputforkinstanceid0.x;
                o.internaltesspos0.x = max(_Tess, 1);
                return o;
            }
            program195Output domain(program195Input i, float4 inputcontrolpoint1_0, float4 inputcontrolpoint1_2, float4 inputdomainpoint0, float4 inputcontrolpoint0_0, float4 inputcontrolpoint2_0, float4 inputcontrolpoint0_2, float4 inputcontrolpoint2_2, float4 inputcontrolpoint1_3, float4 inputcontrolpoint0_3, float4 inputcontrolpoint2_3)
            {
                program195Output o = (program195Output)0;
                float4 r1_xyzw_3 = mad(inputcontrolpoint2_0.xyzw, inputdomainpoint0.zzzz, mad(inputcontrolpoint0_0.xyzw, inputdomainpoint0.xxxx, (inputdomainpoint0.yyyy * inputcontrolpoint1_0.xyzw)));
                float r0_y_1 = dot(r1_xyzw_3.xyzx, inputcontrolpoint1_2.xyzx);
                float4 r0_xyzw_3 = mad(-inputcontrolpoint1_2.xyzx, ((dot(inputcontrolpoint1_0.xyzx, inputcontrolpoint1_2.xyzx) + r0_y_1)).xxxx, r1_xyzw_3.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_2 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = (float4(r0_x_3, r0_y_2, r0_z_1, r0_x_3) * inputdomainpoint0.yyyy);
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_3 = r0_xyzw_4.y;
                float r0_z_2 = r0_xyzw_4.z;
                float r0_w_1 = dot(inputcontrolpoint0_0.xyzx, inputcontrolpoint0_2.xyzx);
                float r0_w_2 = (-r0_w_1 + dot(r1_xyzw_3.xyzx, inputcontrolpoint0_2.xyzx));
                float4 r2_xyzw_2 = mad(-inputcontrolpoint0_2.xyzx, r0_w_2.xxxx, r1_xyzw_3.xyzx);
                float r2_x_2 = r2_xyzw_2.x;
                float r2_y_1 = r2_xyzw_2.y;
                float r2_z_1 = r2_xyzw_2.z;
                float4 r0_xyzw_5 = mad(float4(r2_x_2, r2_y_1, r2_z_1, r2_x_2), inputdomainpoint0.xxxx, float4(r0_x_4, r0_y_3, r0_z_2, r0_x_4));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_3 = r0_xyzw_5.z;
                float r0_w_3 = dot(inputcontrolpoint2_0.xyzx, inputcontrolpoint2_2.xyzx);
                float r0_w_4 = (-r0_w_3 + dot(r1_xyzw_3.xyzx, inputcontrolpoint2_2.xyzx));
                float4 r2_xyzw_4 = mad(-inputcontrolpoint2_2.xyzx, r0_w_4.xxxx, r1_xyzw_3.xyzx);
                float r2_x_4 = r2_xyzw_4.x;
                float r2_y_2 = r2_xyzw_4.y;
                float r2_z_2 = r2_xyzw_4.z;
                float4 r0_xyzw_6 = mad(float4(r2_x_4, r2_y_2, r2_z_2, r2_x_4), inputdomainpoint0.zzzz, float4(r0_x_5, r0_y_4, r0_z_3, r0_x_5));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_5 = r0_xyzw_6.y;
                float r0_z_4 = r0_xyzw_6.z;
                float r0_w_5 = (-_Phong + 1);
                float4 r0_xyzw_7 = mad(_Phong.xxxx, float4(r0_x_6, r0_y_5, r0_z_4, r0_x_6), ((r1_xyzw_3.xyzx * r0_w_5.xxxx)).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_6 = r0_xyzw_7.y;
                float r0_z_5 = r0_xyzw_7.z;
                float2 r1_xy_7 = (mad(inputcontrolpoint2_3.xyxx, inputdomainpoint0.zzzz, (mad(inputcontrolpoint0_3.xyxx, inputdomainpoint0.xxxx, ((inputdomainpoint0.yyyy * inputcontrolpoint1_3.xyxx)).xyxx)).xyxx)).xy;
                float r0_w_6 = (r1_xy_7.y * 10);
                float r0_w_7 = mad(-_Time.y, 0.5, r0_w_6);
                float r0_w_8 = cos(r0_w_7);
                float r1_z_5 = mad(r1_xy_7.x, 12, _Time.y);
                o.texcoord0.xy = (mad(r1_xy_7.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float r0_w_9 = (r0_w_8 * sin(r1_z_5));
                float4 r1_xyzw_9 = (inputdomainpoint0.yyyy * inputcontrolpoint1_2.xyzx);
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_8 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r1_xyzw_10 = mad(inputcontrolpoint0_2.xyzx, inputdomainpoint0.xxxx, float4(r1_x_9, r1_y_8, r1_z_6, r1_x_9));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_9 = r1_xyzw_10.y;
                float r1_z_7 = r1_xyzw_10.z;
                float4 r1_xyzw_11 = mad(inputcontrolpoint2_2.xyzx, inputdomainpoint0.zzzz, float4(r1_x_10, r1_y_9, r1_z_7, r1_x_10));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_10 = r1_xyzw_11.y;
                float r1_z_8 = r1_xyzw_11.z;
                float4 r2_xyzw_5 = (r0_w_9.xxxx * float4(r1_x_11, r1_y_10, r1_z_8, r1_x_11));
                float r2_x_5 = r2_xyzw_5.x;
                float r2_y_3 = r2_xyzw_5.y;
                float r2_z_3 = r2_xyzw_5.z;
                float4 r0_xyzw_8 = mad(float4(r2_x_5, r2_y_3, r2_z_3, r2_x_5), _Disp.xxxx, float4(r0_x_7, r0_y_6, r0_z_5, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_7 = r0_xyzw_8.y;
                float r0_z_6 = r0_xyzw_8.z;
                float4 r2_xyzw_6 = (r0_y_7.xxxx * unity_ObjectToWorld[1]);
                float4 r2_xyzw_7 = mad(unity_ObjectToWorld[0], r0_x_8.xxxx, r2_xyzw_6);
                float4 r0_xyzw_9 = mad(unity_ObjectToWorld[2], r0_z_6.xxxx, r2_xyzw_7);
                float4 r2_xyzw_8 = (r0_xyzw_9 + unity_ObjectToWorld[3]);
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, r1_xyzw_3.wwww, r0_xyzw_9.xyzx)).xyz;
                float4 r0_xyzw_10 = (r2_xyzw_8.yyyy * unity_MatrixVP[1]);
                float4 r0_xyzw_11 = mad(unity_MatrixVP[0], r2_xyzw_8.xxxx, r0_xyzw_10);
                float4 r0_xyzw_12 = mad(unity_MatrixVP[2], r2_xyzw_8.zzzz, r0_xyzw_11);
                o.sv_Position0.xyzw = mad(unity_MatrixVP[3], r2_xyzw_8.wwww, r0_xyzw_12);
                float r0_x_13 = dot(float4(r1_x_11, r1_y_10, r1_z_8, r1_x_11), unity_WorldToObject[0].xyzx);
                float r0_y_12 = dot(float4(r1_x_11, r1_y_10, r1_z_8, r1_x_11), unity_WorldToObject[1].xyzx);
                float r0_z_11 = dot(float4(r1_x_11, r1_y_10, r1_z_8, r1_x_11), unity_WorldToObject[2].xyzx);
                float r0_w_14 = dot(float4(r0_x_13, r0_y_12, r0_z_11, r0_x_13), float4(r0_x_13, r0_y_12, r0_z_11, r0_x_13));
                float r0_w_15 = rsqrt(r0_w_14);
                o.texcoord1.xyz = ((r0_w_15.xxxx * float4(r0_x_13, r0_y_12, r0_z_11, r0_x_13))).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #endif
            ENDHLSL
        }
    }
    Fallback "Standard"
}
