Shader "Corpus/07 Surface Lambert"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo", 2D) = "white" {}
        _LightMap ("Lightmap", 2D) = "white" {}
        _Cutoff ("Alpha Cutoff", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
        LOD 200
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            // Folded keyword variants (base state emitted): FOG_LINEAR, LIGHTPROBE_SH, SHADOWS_SCREEN, VERTEXLIGHT_ON
            HLSLPROGRAM
            #pragma target 3.5
            #pragma multi_compile _ FOG_LINEAR LIGHTPROBE_SH SHADOWS_SCREEN VERTEXLIGHT_ON
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _Color : packoffset(c4);
                float _Cutoff : packoffset(c5.x);
                float4 _MainTex_ST : packoffset(c6);
                float4 _LightMap_ST : packoffset(c7);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
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
            SamplerState sampler_LightMap;
            Texture2D _MainTex;
            Texture2D _LightMap;
            Texture3D t2;
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
                float4 color0 : COLOR0;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program30Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
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
                o.texcoord0.zw = (mad(i.texcoord1.xxxy, _LightMap_ST.xxxy, _LightMap_ST.zzzw)).zw;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program30Output frag(program30Input i)
            {
                program30Output o = (program30Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r0_xyzw_2 = (r0_xyzw_1 * _Color);
                float4 r1_xyzw_1 = _LightMap.Sample(sampler_LightMap, (i.texcoord0.zwzz).xy);
                float3 r0_xyz_4 = ((((r0_xyzw_2.xyzx * i.color0.xyzx)).xyzx * r1_xyzw_1.xyzx)).xyz;
                float r0_w_3 = mad(r0_xyzw_2.w, i.color0.w, -_Cutoff);
                float r0_w_4 = (r0_w_3 < 0);
                if (r0_w_4) discard;
                float r0_w_5 = (unity_ProbeVolumeParams.x == 1);
                float r2_x_10;
                float r2_y_10;
                float r2_z_10;
                float r2_w_4;
                if (r0_w_5)
                {
                    float r0_w_6 = (unity_ProbeVolumeParams.y == 1);
                    float3 r2_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_6.xxxx ? r2_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r2_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_8 = r2_xyzw_8.z;
                    float r2_w_2 = r2_xyzw_8.w;
                    float r0_w_7 = mad(r2_y_8, 0.25, 0.75);
                    float r1_w_2 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r2_x_8 = max(r0_w_7, r1_w_2);
                    float4 r2_xyzw_9 = t2.Sample(sampler_linear_clamp, (float4(r2_x_8, r2_z_8, r2_w_2, r2_x_8)).xyz);
                    r2_x_10 = r2_xyzw_9.x;
                    r2_y_10 = r2_xyzw_9.y;
                    r2_z_10 = r2_xyzw_9.z;
                    r2_w_4 = r2_xyzw_9.w;
                }
                else
                {
                    float4 r2_xyzw_10 = float4(1, 1, 1, 1);
                    r2_x_10 = r2_xyzw_10.x;
                    r2_y_10 = r2_xyzw_10.y;
                    r2_z_10 = r2_xyzw_10.z;
                    r2_w_4 = r2_xyzw_10.w;
                }
                float r0_w_9 = saturate(dot(float4(r2_x_10, r2_y_10, r2_z_10, r2_w_4), unity_OcclusionMaskSelector));
                float r0_w_10 = dot(i.texcoord1.xyzx, unity_ObjectToWorld[0].xyzx);
                float r0_w_11 = max(r0_w_10, 0);
                o.sv_Target0.xyz = (mad(((r0_xyz_4.xyzx * ((r0_w_9.xxxx * _LightColor0.xyzx)).xyzx)).xyzx, r0_w_11.xxxx, ((r0_xyz_4.xyzx * float4(0.05, 0.05, 0.05, 0))).xyzx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "QUEUE"="Geometry" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            // Folded keyword variants (base state emitted): DIRECTIONAL_COOKIE, FOG_LINEAR, POINT, POINT_COOKIE, SPOT
            HLSLPROGRAM
            #pragma target 3.5
            #pragma multi_compile _ DIRECTIONAL_COOKIE FOG_LINEAR POINT POINT_COOKIE SPOT
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0;
                float4 _Color;
                float _Cutoff;
                float4 _MainTex_ST;
                float4 _LightMap_ST;
                float4 cb0_values[6];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
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
            SamplerState sampler_LightMap;
            Texture2D _MainTex;
            Texture2D _LightMap;
            Texture3D t2;
            struct program41Input
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
            struct program41Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program59Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program59Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program41Output vert(program41Input i)
            {
                program41Output o = (program41Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord1.xxxy, _LightMap_ST.xxxy, _LightMap_ST.zzzw)).zw;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program59Output frag(program59Input i)
            {
                program59Output o = (program59Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r0_xyzw_2 = (r0_xyzw_1 * cb0_values[4].xyzw);
                float4 r1_xyzw_1 = _LightMap.Sample(sampler_LightMap, (i.texcoord0.zwzz).xy);
                float r0_w_3 = mad(r0_xyzw_2.w, i.color0.w, -cb0_values[5].x);
                float r0_w_4 = (r0_w_3 < 0);
                if (r0_w_4) discard;
                float r0_w_5 = (unity_ProbeVolumeParams.x == 1);
                float r1_x_11;
                float r1_y_12;
                float r1_z_11;
                float r1_w_5;
                if (r0_w_5)
                {
                    float r0_w_6 = (unity_ProbeVolumeParams.y == 1);
                    float3 r1_xyz_6 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_7 = ((r0_w_6.xxxx ? r1_xyz_6.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r1_xyzw_9 = (((unity_ProbeVolumeParamsSelect_xyz_7.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r1_y_9 = r1_xyzw_9.y;
                    float r1_z_9 = r1_xyzw_9.z;
                    float r1_w_3 = r1_xyzw_9.w;
                    float r0_w_7 = mad(r1_y_9, 0.25, 0.75);
                    float r1_y_10 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r1_x_9 = max(r0_w_7, r1_y_10);
                    float4 r1_xyzw_10 = t2.Sample(sampler_linear_clamp, (float4(r1_x_9, r1_z_9, r1_w_3, r1_x_9)).xyz);
                    r1_x_11 = r1_xyzw_10.x;
                    r1_y_12 = r1_xyzw_10.y;
                    r1_z_11 = r1_xyzw_10.z;
                    r1_w_5 = r1_xyzw_10.w;
                }
                else
                {
                    float4 r1_xyzw_11 = float4(1, 1, 1, 1);
                    r1_x_11 = r1_xyzw_11.x;
                    r1_y_12 = r1_xyzw_11.y;
                    r1_z_11 = r1_xyzw_11.z;
                    r1_w_5 = r1_xyzw_11.w;
                }
                float r0_w_9 = saturate(dot(float4(r1_x_11, r1_y_12, r1_z_11, r1_w_5), unity_OcclusionMaskSelector));
                float4 r1_xyzw_12 = (r0_w_9.xxxx * _LightColor0.xyzx);
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_13 = r1_xyzw_12.y;
                float r1_z_12 = r1_xyzw_12.z;
                float r0_w_10 = dot(i.texcoord1.xyzx, unity_ObjectToWorld[0].xyzx);
                float r0_w_11 = max(r0_w_10, 0);
                o.sv_Target0.xyz = ((r0_w_11.xxxx * ((((((r0_xyzw_2.xyzx * i.color0.xyzx)).xyzx * r1_xyzw_1.xyzx)).xyzx * float4(r1_x_12, r1_y_13, r1_z_12, r1_x_12))).xyzx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Legacy Shaders/Diffuse"
}
