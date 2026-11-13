Shader "Corpus/34 Outline"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "" {}
        _Color ("Color", Color) = (1,1,1,1)
        _OutlineColor ("Outline Color", Color) = (0,0,0,1)
        _OutlineWidth ("Outline Width", Range(0, 0.2)) = 0.02
    }
    SubShader
    {
        Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
        LOD 0
        Pass
        {
            Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
            Cull Front
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _OutlineColor : packoffset(c2);
                float _OutlineWidth : packoffset(c3.x);
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
            struct program1Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
            };
            struct program1Output
            {
                float4 sv_Position0 : SV_POSITION;
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_POSITION;
            };
            struct program3Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program1Output vert(program1Input i)
            {
                program1Output o = (program1Output)0;
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
                float3 r0_xyz_3 = (mad(unitWorldNormal_xyz_2.xyzx, _OutlineWidth.xxxx, worldPos_xyzw_4.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(unity_MatrixVP[2], r0_xyz_3.zzzz, mad(unity_MatrixVP[0], r0_xyz_3.xxxx, (r0_xyz_3.yyyy * unity_MatrixVP[1])));
                o.sv_Position0.xyzw = mad(unity_MatrixVP[3], worldPos_xyzw_4.wwww, r0_xyzw_4);
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                o.sv_Target0.xyzw = _OutlineColor;
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
            // Folded keyword variants (base state emitted): FOG_LINEAR, LIGHTPROBE_SH, SHADOWS_SCREEN
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_SHAr : packoffset(c39);
                float4 unity_SHAg : packoffset(c40);
                float4 unity_SHAb : packoffset(c41);
                float4 unity_SHBr : packoffset(c42);
                float4 unity_SHBg : packoffset(c43);
                float4 unity_SHBb : packoffset(c44);
                float4 unity_SHC : packoffset(c45);
                float4 unity_OcclusionMaskSelector : packoffset(c46);
            };
            cbuffer _UnityPerFrameCB_b2
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
            struct program6Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program6Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program26Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program26Output
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
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
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
                float4 lightDir_xyzw_3 = ((rsqrt(dot(unity_ObjectToWorld[0].xyzx, unity_ObjectToWorld[0].xyzx))).xxxx * unity_ObjectToWorld[0].xyzx);
                float lightDir_x_3 = lightDir_xyzw_3.x;
                float lightDir_y_1 = lightDir_xyzw_3.y;
                float lightDir_z_1 = lightDir_xyzw_3.z;
                float r2_w_1 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_11;
                float r3_z_10;
                float r3_w_4;
                if (r2_w_1)
                {
                    float r2_w_2 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r2_w_2.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r2_w_3 = mad(r3_y_8, 0.25, 0.75);
                    float r3_y_9 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r2_w_3, r3_y_9);
                    float4 r3_xyzw_9 = t1.Sample(sampler_linear_clamp, (float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8)).xyz);
                    r3_x_10 = r3_xyzw_9.x;
                    r3_y_11 = r3_xyzw_9.y;
                    r3_z_10 = r3_xyzw_9.z;
                    r3_w_4 = r3_xyzw_9.w;
                }
                else
                {
                    float4 r3_xyzw_10 = float4(1, 1, 1, 1);
                    r3_x_10 = r3_xyzw_10.x;
                    r3_y_11 = r3_xyzw_10.y;
                    r3_z_10 = r3_xyzw_10.z;
                    r3_w_4 = r3_xyzw_10.w;
                }
                float r2_w_5 = saturate(dot(float4(r3_x_10, r3_y_11, r3_z_10, r3_w_4), unity_OcclusionMaskSelector));
                float r1_w_1 = 1;
                float r3_x_11 = dot(unity_SHAr, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r3_y_12 = dot(unity_SHAg, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float r3_z_11 = dot(unity_SHAb, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r1_w_1));
                float4 r4_xyzw_1 = (float4(unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1, unitWorldNormal_x_3) * float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1));
                float r5_x_1 = dot(unity_SHBr, r4_xyzw_1);
                float r5_y_1 = dot(unity_SHBg, r4_xyzw_1);
                float r5_z_1 = dot(unity_SHBb, r4_xyzw_1);
                float r1_w_2 = (unitWorldNormal_y_1 * unitWorldNormal_y_1);
                float r1_w_3 = mad(unitWorldNormal_x_3, unitWorldNormal_x_3, -r1_w_2);
                float4 r3_xyzw_12 = (float4(r3_x_11, r3_y_12, r3_z_11, r3_x_11) + (mad(unity_SHC.xyzx, r1_w_3.xxxx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1))).xyzx);
                float r3_x_12 = r3_xyzw_12.x;
                float r3_y_13 = r3_xyzw_12.y;
                float r3_z_12 = r3_xyzw_12.z;
                float4 r1_xyzw_5 = ((saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), float4(lightDir_x_3, lightDir_y_1, lightDir_z_1, lightDir_x_3)))).xxxx * _LightColor0.xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_2 = r1_xyzw_5.y;
                float r1_z_2 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = mad(float4(r1_x_5, r1_y_2, r1_z_2, r1_x_5), r2_w_5.xxxx, float4(r3_x_12, r3_y_13, r3_z_12, r3_x_12));
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_3 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                o.sv_Target0.xyz = ((r0_xyzw_2.xyzx * float4(r1_x_6, r1_y_3, r1_z_3, r1_x_6))).xyz;
                o.sv_Target0.w = r0_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Diffuse"
}
