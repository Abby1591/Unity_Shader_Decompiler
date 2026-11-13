Shader "Corpus/04 Vertex Fragment"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo", 2D) = "" {}
        _BumpMap ("Normal", 2D) = "" {}
        _DetailTex ("Detail", 2D) = "" {}
        _DetailScale ("Detail Scale", Float) = 4
        _Emission ("Emission", Color) = (0,0,0,0)
        _Cutoff ("Alpha Cutoff", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "IGNOREPROJECTOR"="False" "QUEUE"="Geometry" "RenderType"="Opaque" }
        LOD 0
        Pass
        {
            Tags { "IGNOREPROJECTOR"="False" "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            // Folded keyword variants (base state emitted): FOG_LINEAR, LIGHTPROBE_SH, SHADOWS_SCREEN
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _DetailTex_ST : packoffset(c5);
                float _DetailScale : packoffset(c6.x);
                float4 _Color : packoffset(c7);
                float4 _Emission : packoffset(c8);
                float _Cutoff : packoffset(c9.x);
            };
            cbuffer _UnityPerCameraCB_b1
            {
                float3 _WorldSpaceCameraPos : packoffset(c4);
                float4 _ProjectionParams : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b2
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
            SamplerState sampler_DetailTex;
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _DetailTex;
            Texture3D t3;
            struct program1Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float4 tangent0 : TANGENT0;
                float4 color0 : COLOR0;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
            };
            struct program1Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 color0 : COLOR0;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program21Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 color0 : COLOR0;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 texcoord9 : TEXCOORD9;
            };
            struct program21Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program1Output vert(program1Input i)
            {
                program1Output o = (program1Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord5.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord1.xy = (i.texcoord1.xxxy).zw;
                float2 uvDetailTex_xy_2 = (mad(i.texcoord0.xyxx, _DetailTex_ST.xyxx, _DetailTex_ST.zwzz)).xy;
                o.texcoord2.xy = ((uvDetailTex_xy_2.xyxx * _DetailScale.xxxx)).xy;
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_2, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_2, worldNormal_x_3));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord3.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_2, worldNormal_x_3))).xyz;
                float4 worldTangent_xyzw_4 = (i.tangent0.yyyy * unity_ObjectToWorld[1].xyzx);
                float worldTangent_x_4 = worldTangent_xyzw_4.x;
                float worldTangent_y_4 = worldTangent_xyzw_4.y;
                float worldTangent_z_3 = worldTangent_xyzw_4.z;
                float4 worldTangent_xyzw_5 = mad(unity_ObjectToWorld[0].xyzx, i.tangent0.xxxx, float4(worldTangent_x_4, worldTangent_y_4, worldTangent_z_3, worldTangent_x_4));
                float worldTangent_x_5 = worldTangent_xyzw_5.x;
                float worldTangent_y_5 = worldTangent_xyzw_5.y;
                float worldTangent_z_4 = worldTangent_xyzw_5.z;
                float4 worldTangent_xyzw_6 = mad(unity_ObjectToWorld[2].xyzx, i.tangent0.zzzz, float4(worldTangent_x_5, worldTangent_y_5, worldTangent_z_4, worldTangent_x_5));
                float worldTangent_x_6 = worldTangent_xyzw_6.x;
                float worldTangent_y_6 = worldTangent_xyzw_6.y;
                float worldTangent_z_5 = worldTangent_xyzw_6.z;
                float r1_w_4 = dot(float4(worldTangent_x_6, worldTangent_y_6, worldTangent_z_5, worldTangent_x_6), float4(worldTangent_x_6, worldTangent_y_6, worldTangent_z_5, worldTangent_x_6));
                float r1_w_5 = rsqrt(r1_w_4);
                o.texcoord4.xyz = ((r1_w_5.xxxx * float4(worldTangent_x_6, worldTangent_y_6, worldTangent_z_5, worldTangent_x_6))).xyz;
                o.texcoord4.w = i.tangent0.w;
                float r0_y_8 = (clipPos_xyzw_7.y * _ProjectionParams.x);
                float4 r1_xyzw_7 = (float4(clipPos_xyzw_7.x, clipPos_xyzw_7.x, clipPos_xyzw_7.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_z_6 = r1_xyzw_7.z;
                float r1_w_6 = r1_xyzw_7.w;
                o.texcoord6.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord6.xy = ((r1_z_6.xxxx + float4(r1_x_7, r1_w_6, r1_x_7, r1_x_7))).xy;
                o.texcoord9.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program21Output frag(program21Input i)
            {
                program21Output o = (program21Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r0_xyzw_2 = (r0_xyzw_1 * _Color);
                float4 r1_xyzw_1 = (r0_xyzw_2 * i.color0.xyzw);
                float4 r2_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord2.xyxx).xy);
                float r0_w_3 = mad(r0_xyzw_2.w, i.color0.w, -_Cutoff);
                float r0_w_4 = (r0_w_3 < 0);
                if (r0_w_4) discard;
                float4 r2_xyzw_2 = _DetailTex.Sample(sampler_DetailTex, (i.texcoord0.xyxx).xy);
                float r2_x_3 = (r2_xyzw_2.w * r2_xyzw_2.x);
                float4 r2_xyzw_4 = mad(float4(r2_x_3, r2_xyzw_2.y, r2_x_3, r2_x_3), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r2_x_4 = r2_xyzw_4.x;
                float r2_y_3 = r2_xyzw_4.y;
                float r0_w_5 = dot(float4(r2_x_4, r2_y_3, r2_x_4, r2_x_4), float4(r2_x_4, r2_y_3, r2_x_4, r2_x_4));
                float r0_w_6 = min(r0_w_5, 1);
                float r0_w_7 = (-r0_w_6 + 1);
                float r2_z_3 = sqrt(r0_w_7);
                float3 lightDir_xyz_2 = normalize(unity_ObjectToWorld [0]);
                float3 viewDir_xyz_1 = ((-i.texcoord5.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_10 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_11 = rsqrt(r0_w_10);
                float3 r3_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_11.xxxx, lightDir_xyz_2.xyzx)).xyz;
                float3 halfVector_xyz_3 = normalize(r3_xyz_2);
                float r0_w_14 = saturate(dot(float4(r2_x_4, r2_y_3, r2_z_3, r2_x_4), lightDir_xyz_2.xyzx));
                float r1_y_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_13;
                float r3_y_13;
                float r3_z_13;
                float r3_w_4;
                if (r1_y_3)
                {
                    float r1_y_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_8 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord5.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord5.xxxx, ((i.texcoord5.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_9 = ((r1_y_4.xxxx ? r3_xyz_8.xyzx : i.texcoord5.xyzx)).xyz;
                    float4 r3_xyzw_11 = (((unity_ProbeVolumeParamsSelect_xyz_9.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_11 = r3_xyzw_11.y;
                    float r3_z_11 = r3_xyzw_11.z;
                    float r3_w_2 = r3_xyzw_11.w;
                    float r1_y_5 = mad(r3_y_11, 0.25, 0.75);
                    float r1_z_3 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_11 = max(r1_z_3, r1_y_5);
                    float4 r3_xyzw_12 = t3.Sample(sampler_linear_clamp, (float4(r3_x_11, r3_z_11, r3_w_2, r3_x_11)).xyz);
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
                float r1_y_7 = saturate(dot(float4(r3_x_13, r3_y_13, r3_z_13, r3_w_4), unity_OcclusionMaskSelector));
                float r2_w_3 = 1;
                float r3_x_14 = dot(unity_SHAr, float4(r2_x_4, r2_y_3, r2_z_3, r2_w_3));
                float r3_y_14 = dot(unity_SHAg, float4(r2_x_4, r2_y_3, r2_z_3, r2_w_3));
                float r3_z_14 = dot(unity_SHAb, float4(r2_x_4, r2_y_3, r2_z_3, r2_w_3));
                float4 r4_xyzw_1 = (float4(r2_y_3, r2_z_3, r2_z_3, r2_x_4) * float4(r2_x_4, r2_y_3, r2_z_3, r2_z_3));
                float r5_x_1 = dot(unity_SHBr, r4_xyzw_1);
                float r5_y_1 = dot(unity_SHBg, r4_xyzw_1);
                float r5_z_1 = dot(unity_SHBb, r4_xyzw_1);
                float r1_z_5 = (r2_y_3 * r2_y_3);
                float r1_z_6 = mad(r2_x_4, r2_x_4, -r1_z_5);
                float4 r2_xyzw_5 = mad(unity_SHC.xyzx, r1_z_6.xxxx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1));
                float r2_x_5 = r2_xyzw_5.x;
                float r2_y_4 = r2_xyzw_5.y;
                float r2_z_4 = r2_xyzw_5.z;
                float4 r2_xyzw_6 = (float4(r2_x_5, r2_y_4, r2_z_4, r2_x_5) + float4(r3_x_14, r3_y_14, r3_z_14, r3_x_14));
                float r2_x_6 = r2_xyzw_6.x;
                float r2_y_5 = r2_xyzw_6.y;
                float r2_z_5 = r2_xyzw_6.z;
                float4 r2_xyzw_7 = mad(((r0_w_14.xxxx * _LightColor0.xyzx)).xyzx, r1_y_7.xxxx, float4(r2_x_6, r2_y_5, r2_z_5, r2_x_6));
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_6 = r2_xyzw_7.y;
                float r2_z_6 = r2_xyzw_7.z;
                                float4 r1_xyzw_7 = (r1_y_7.xxxx * (((pow(saturate(dot(float4(r2_x_4, r2_y_3, r2_z_3, r2_x_4), halfVector_xyz_3.xyzx)), 32)).xxxx * _LightColor0.xyzx)).xyzx);
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_8 = r1_xyzw_7.y;
                float r1_z_7 = r1_xyzw_7.z;
                float4 r1_xyzw_8 = (float4(r1_x_7, r1_y_8, r1_z_7, r1_x_7) * float4(0.25, 0.25, 0.25, 0));
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_9 = r1_xyzw_8.y;
                float r1_z_8 = r1_xyzw_8.z;
                float3 r0_xyz_6 = (mad((((mad((mad(r2_xyzw_1.xyzx, float4(2, 2, 2, 0), float4(-1, -1, -1, 0))).xyzx, float4(0.25, 0.25, 0.25, 0), float4(1, 1, 1, 0))).xyzx * r1_xyzw_1.xyzx)).xyzx, float4(r2_x_7, r2_y_6, r2_z_6, r2_x_7), float4(r1_x_8, r1_y_9, r1_z_8, r1_x_8))).xyz;
                o.sv_Target0.xyz = ((r0_xyz_6.xyzx + _Emission.xyzx)).xyz;
                o.sv_Target0.w = r1_xyzw_1.w;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Diffuse"
}
