Shader "Corpus/07 Surface Lambert"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo", 2D) = "" {}
        _LightMap ("Lightmap", 2D) = "" {}
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
            HLSLPROGRAM
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
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
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
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[47];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[26];
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[21];
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
            SamplerState sampler_LightMap;
            Texture2D _MainTex;
            Texture2D _LightMap;
            Texture2D t2;
            Texture3D t3;
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
                float4 color0 : COLOR0;
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
                float4 color0 : COLOR0;
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
                o.texcoord0.zw = (mad(i.texcoord1.xxxy, _LightMap_ST.xxxy, _LightMap_ST.zzzw)).zw;
                o.texcoord4.x = clipPos_xyzw_7.z;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb3_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb3_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb3_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                float3 unitWorldNormal_xyz_3 = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = unitWorldNormal_xyz_3.xyz;
                o.color0.xyzw = i.color0.xyzw;
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
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r0_xyzw_2 = (r0_xyzw_1 * _Color);
                float4 r1_xyzw_1 = _LightMap.Sample(sampler_LightMap, (i.texcoord0.zwzz).xy);
                float3 r0_xyz_4 = ((((r0_xyzw_2.xyzx * i.color0.xyzx)).xyzx * r1_xyzw_1.xyzx)).xyz;
                float r0_w_3 = mad(r0_xyzw_2.w, i.color0.w, -_Cutoff);
                float r0_w_4 = (r0_w_3 < 0);
                if (r0_w_4) discard;
                float r2_x_1 = cb4_values[9].z;
                float r2_y_1 = cb4_values[10].z;
                float r2_z_1 = cb4_values[11].z;
                float r0_w_5 = dot(((-i.texcoord2.xyzx + cb1_values[4].xyzx)).xyzx, float4(r2_x_1, r2_y_1, r2_z_1, r2_x_1));
                float3 r1_xyz_3 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r0_w_6 = mad(cb3_values[25].w, (-r0_w_5 + sqrt(dot(r1_xyz_3.xyzx, r1_xyz_3.xyzx))), r0_w_5);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[24].z, cb3_values[24].w));
                float r1_x_7 = (cb6_values[0].x == 1);
                float r2_x_9;
                float r2_y_9;
                float r2_z_9;
                float r2_w_4;
                if (r1_x_7)
                {
                    float r1_y_4 = (cb6_values[0].y == 1);
                    float3 r2_xyz_6 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r1_xyzw_5 = (r1_y_4.xxxx ? r2_xyz_6.xxyz : i.texcoord2.xxyz);
                    float r1_y_5 = r1_xyzw_5.y;
                    float r1_z_4 = r1_xyzw_5.z;
                    float r1_w_2 = r1_xyzw_5.w;
                    float4 r1_xyzw_6 = (float4(r1_y_5, r1_y_5, r1_z_4, r1_w_2) + -cb6_values[6].xxyz);
                    float r1_y_6 = r1_xyzw_6.y;
                    float r1_z_5 = r1_xyzw_6.z;
                    float r1_w_3 = r1_xyzw_6.w;
                    float4 r2_xyzw_7 = (float4(r1_y_6, r1_y_6, r1_z_5, r1_w_3) * cb6_values[5].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_2 = r2_xyzw_7.w;
                    float r1_y_7 = mad(r2_y_7, 0.25, 0.75);
                    float r1_z_6 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r2_x_7 = max(r1_z_6, r1_y_7);
                    float4 r2_xyzw_8 = t3.Sample(sampler_linear_clamp, (float4(r2_x_7, r2_z_7, r2_w_2, r2_x_7)).xyz);
                    r2_x_9 = r2_xyzw_8.x;
                    r2_y_9 = r2_xyzw_8.y;
                    r2_z_9 = r2_xyzw_8.z;
                    r2_w_4 = r2_xyzw_8.w;
                }
                else
                {
                    float4 r2_xyzw_2 = float4(1, 1, 1, 1);
                    r2_x_9 = r2_xyzw_2.x;
                    r2_y_9 = r2_xyzw_2.y;
                    r2_z_9 = r2_xyzw_2.z;
                    r2_w_4 = r2_xyzw_2.w;
                }
                float r1_y_9 = saturate(dot(float4(r2_x_9, r2_y_9, r2_z_9, r2_w_4), cb2_values[46].xyzw));
                float4 r1_xyzw_8 = (i.texcoord5.xxxy / i.texcoord5.wwww);
                float r1_z_8 = r1_xyzw_8.z;
                float r1_w_5 = r1_xyzw_8.w;
                float4 r2_xyzw_10 = t2.Sample(sampler_linear_clamp1, (float4(r1_z_8, r1_w_5, r1_z_8, r1_z_8)).xy);
                float r1_y_10 = (r1_y_9 + -r2_xyzw_10.x);
                float r0_w_8 = mad(r0_w_7, r1_y_10, r2_xyzw_10.x);
                float4 r1_xyzw_11 = (r0_w_8.xxxx * _LightColor0.xxyz);
                float r1_y_11 = r1_xyzw_11.y;
                float r1_z_9 = r1_xyzw_11.z;
                float r1_w_6 = r1_xyzw_11.w;
                float3 r3_xyz_4;
                if ((r1_x_7 != 0))
                {
                    float r0_w_9 = (cb6_values[0].y == 1);
                    float3 r2_xyz_15 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r2_xyzw_18 = (((((r0_w_9.xxxx ? r2_xyz_15.xyzx : i.texcoord2.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r2_y_18 = r2_xyzw_18.y;
                    float r2_z_18 = r2_xyzw_18.z;
                    float r2_w_7 = r2_xyzw_18.w;
                    float r0_w_10 = (r2_y_18 * 0.25);
                    float r2_y_19 = mad(-cb6_values[0].z, 0.5, 0.25);
                    float r0_w_11 = max(r0_w_10, (cb6_values[0].z * 0.5));
                    float r2_x_18 = min(r2_y_19, r0_w_11);
                    float4 r3_xyzw_2 = t3.Sample(sampler_linear_clamp, (float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18)).xyz);
                    float4 r4_xyzw_2 = t3.Sample(sampler_linear_clamp, (((float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18) + float4(0.25, 0, 0, 0))).xyzx).xyz);
                    float4 r2_xyzw_19 = (float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18) + float4(0.5, 0, 0, 0));
                    float r2_x_19 = r2_xyzw_19.x;
                    float r2_y_20 = r2_xyzw_19.y;
                    float r2_z_19 = r2_xyzw_19.z;
                    float4 r2_xyzw_20 = t3.Sample(sampler_linear_clamp, (float4(r2_x_19, r2_y_20, r2_z_19, r2_x_19)).xyz);
                    float3 TEXCOORD1_xyz_1 = i.texcoord1.xyz;
                    float r5_w_1 = 1;
                    float r3_x_3 = dot(r3_xyzw_2, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r5_w_1));
                    float r3_y_3 = dot(r4_xyzw_2, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r5_w_1));
                    float r3_z_3 = dot(r2_xyzw_20, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r5_w_1));
                    r3_xyz_4 = float3(r3_x_3, r3_y_3, r3_z_3);
                }
                else
                {
                    float3 TEXCOORD1_xyz_11 = i.texcoord1.xyz;
                    float r2_w_6 = 1;
                    float r3_x_1 = dot(cb2_values[39].xyzw, float4(TEXCOORD1_xyz_11.x, TEXCOORD1_xyz_11.y, TEXCOORD1_xyz_11.z, r2_w_6));
                    float r3_y_1 = dot(cb2_values[40].xyzw, float4(TEXCOORD1_xyz_11.x, TEXCOORD1_xyz_11.y, TEXCOORD1_xyz_11.z, r2_w_6));
                    float r3_z_1 = dot(cb2_values[41].xyzw, float4(TEXCOORD1_xyz_11.x, TEXCOORD1_xyz_11.y, TEXCOORD1_xyz_11.z, r2_w_6));
                    r3_xyz_4 = float3(r3_x_1, r3_y_1, r3_z_1);
                }
                float4 r2_xyzw_22 = (r3_xyz_4.xyzx + i.texcoord3.xyzx);
                float r2_x_22 = r2_xyzw_22.x;
                float r2_y_23 = r2_xyzw_22.y;
                float r2_z_22 = r2_xyzw_22.z;
                float4 r2_xyzw_23 = max(float4(r2_x_22, r2_y_23, r2_z_22, r2_x_22), float4(0, 0, 0, 0));
                float r2_x_23 = r2_xyzw_23.x;
                float r2_y_24 = r2_xyzw_23.y;
                float r2_z_23 = r2_xyzw_23.z;
                float r0_w_13 = dot(i.texcoord1.xyzx, unity_ProbeVolumeParams.xyzx);
                float r0_w_14 = max(r0_w_13, 0);
                float4 r1_xyzw_10 = (r0_xyz_4.xyzx * float4(r1_y_11, r1_z_9, r1_w_6, r1_y_11));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_12 = r1_xyzw_10.y;
                float r1_z_10 = r1_xyzw_10.z;
                float4 r2_xyzw_24 = (r0_xyz_4.xyzx * float4(r2_x_23, r2_y_24, r2_z_23, r2_x_23));
                float r2_x_24 = r2_xyzw_24.x;
                float r2_y_25 = r2_xyzw_24.y;
                float r2_z_24 = r2_xyzw_24.z;
                float r1_x_11 = (mad(float4(r1_x_10, r1_y_12, r1_z_10, r1_x_10), r0_w_14.xxxx, float4(r2_x_24, r2_y_25, r2_z_24, r2_x_24))).x;
                float4 r1_xyzw_13 = mad(float4(r1_x_10, r1_y_12, r1_z_10, r1_x_10), r0_w_14.xxxx, float4(r2_x_24, r2_y_25, r2_z_24, r2_x_24));
                float r1_y_13 = r1_xyzw_13.y;
                float r1_z_11 = r1_xyzw_13.z;
                float r0_w_15 = (i.texcoord4.x / cb1_values[5].y);
                float r0_w_16 = (-r0_w_15 + 1);
                float r0_w_17 = (r0_w_16 * cb1_values[5].z);
                float r0_w_18 = max(r0_w_17, 0);
                float r0_w_19 = saturate(mad(r0_w_18, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_19.xxxx, (((mad(r0_xyz_4.xyzx, float4(0.05, 0.05, 0.05, 0), float4(r1_x_11, r1_y_13, r1_z_11, r1_x_11))).xyzx + -cb5_values[0].xyzx)).xyzx, cb5_values[0].xyzx)).xyz;
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
                float _Cutoff : packoffset(c5.x);
                float4 _MainTex_ST : packoffset(c6);
                float4 _LightMap_ST : packoffset(c7);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[47];
            };
            cbuffer cb3 : register(b3)
            {
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
            SamplerState sampler_LightMap;
            Texture2D _MainTex;
            Texture2D _LightMap;
            Texture2D t2;
            Texture3D t3;
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
                float4 color0 : COLOR0;
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
                float4 color0 : COLOR0;
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
                o.texcoord0.zw = (mad(i.texcoord1.xxxy, _LightMap_ST.xxxy, _LightMap_ST.zzzw)).zw;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord4.x = clipPos_xyzw_7.z;
                o.color0.xyzw = i.color0.xyzw;
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
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r0_xyzw_2 = (r0_xyzw_1 * _Color);
                float4 r1_xyzw_1 = _LightMap.Sample(sampler_LightMap, (i.texcoord0.zwzz).xy);
                float3 r0_xyz_4 = ((((r0_xyzw_2.xyzx * i.color0.xyzx)).xyzx * r1_xyzw_1.xyzx)).xyz;
                float r0_w_3 = mad(r0_xyzw_2.w, i.color0.w, -_Cutoff);
                float r0_w_4 = (r0_w_3 < 0);
                if (r0_w_4) discard;
                float r3_x_1 = cb4_values[9].z;
                float r3_y_1 = cb4_values[10].z;
                float r3_z_1 = cb4_values[11].z;
                float r0_w_5 = dot(((-i.texcoord2.xyzx + cb1_values[4].xyzx)).xyzx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float3 r2_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_2 = dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx);
                float r1_w_3 = sqrt(r1_w_2);
                float r1_w_4 = (-r0_w_5 + r1_w_3);
                float r0_w_6 = mad(cb3_values[25].w, r1_w_4, r0_w_5);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[24].z, cb3_values[24].w));
                float r1_w_5 = (cb6_values[0].x == 1);
                float r2_x_12;
                float r2_y_13;
                float r2_z_12;
                float r2_w_4;
                if (r1_w_5)
                {
                    float r1_w_6 = (cb6_values[0].y == 1);
                    float3 r2_xyz_7 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r2_xyzw_10 = (((((r1_w_6.xxxx ? r2_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r2_y_10 = r2_xyzw_10.y;
                    float r2_z_10 = r2_xyzw_10.z;
                    float r2_w_2 = r2_xyzw_10.w;
                    float r1_w_7 = mad(r2_y_10, 0.25, 0.75);
                    float r2_y_11 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r2_x_10 = max(r1_w_7, r2_y_11);
                    float4 r2_xyzw_11 = t3.Sample(sampler_linear_clamp, (float4(r2_x_10, r2_z_10, r2_w_2, r2_x_10)).xyz);
                    r2_x_12 = r2_xyzw_11.x;
                    r2_y_13 = r2_xyzw_11.y;
                    r2_z_12 = r2_xyzw_11.z;
                    r2_w_4 = r2_xyzw_11.w;
                }
                else
                {
                    float4 r2_xyzw_3 = float4(1, 1, 1, 1);
                    r2_x_12 = r2_xyzw_3.x;
                    r2_y_13 = r2_xyzw_3.y;
                    r2_z_12 = r2_xyzw_3.z;
                    r2_w_4 = r2_xyzw_3.w;
                }
                float r1_w_9 = saturate(dot(float4(r2_x_12, r2_y_13, r2_z_12, r2_w_4), cb2_values[46].xyzw));
                float4 r2_xyzw_13 = (i.texcoord5.xyxx / i.texcoord5.wwww);
                float r2_x_13 = r2_xyzw_13.x;
                float r2_y_14 = r2_xyzw_13.y;
                float4 r2_xyzw_14 = t2.Sample(sampler_linear_clamp1, (float4(r2_x_13, r2_y_14, r2_x_13, r2_x_13)).xy);
                float r1_w_10 = (r1_w_9 + -r2_xyzw_14.x);
                float r0_w_8 = mad(r0_w_7, r1_w_10, r2_xyzw_14.x);
                float4 r2_xyzw_15 = (r0_w_8.xxxx * _LightColor0.xyzx);
                float r2_x_15 = r2_xyzw_15.x;
                float r2_y_16 = r2_xyzw_15.y;
                float r2_z_14 = r2_xyzw_15.z;
                float r0_w_9 = dot(i.texcoord1.xyzx, unity_ProbeVolumeParams.xyzx);
                float r0_w_10 = max(r0_w_9, 0);
                float r0_w_11 = (i.texcoord4.x / cb1_values[5].y);
                float r0_w_12 = (-r0_w_11 + 1);
                float r0_w_13 = (r0_w_12 * cb1_values[5].z);
                float r0_w_14 = max(r0_w_13, 0);
                float r0_w_15 = saturate(mad(r0_w_14, cb5_values[1].z, cb5_values[1].w));
                float3 r0_xyz_7 = (((mad(((r0_xyz_4.xyzx * float4(r2_x_15, r2_y_16, r2_z_14, r2_x_15))).xyzx, r0_w_10.xxxx, ((r0_xyz_4.xyzx * float4(0.05, 0.05, 0.05, 0))).xyzx)).xyzx + -cb5_values[0].xyzx)).xyz;
                o.sv_Target0.xyz = (mad(r0_w_15.xxxx, r0_xyz_7.xyzx, cb5_values[0].xyzx)).xyz;
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
                float _Cutoff : packoffset(c5.x);
                float4 _MainTex_ST : packoffset(c6);
                float4 _LightMap_ST : packoffset(c7);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[46];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[47];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[21];
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_MainTex;
            SamplerState sampler_LightMap;
            Texture2D _MainTex;
            Texture2D _LightMap;
            Texture3D t2;
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
                float4 color0 : COLOR0;
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
                float4 color0 : COLOR0;
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
                o.texcoord0.zw = (mad(i.texcoord1.xxxy, _LightMap_ST.xxxy, _LightMap_ST.zzzw)).zw;
                float worldNormal_x_8 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                float3 unitWorldNormal_xyz_9 = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                o.texcoord1.xyz = unitWorldNormal_xyz_9.xyz;
                o.color0.xyzw = i.color0.xyzw;
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
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r0_xyzw_2 = (r0_xyzw_1 * _Color);
                float4 r1_xyzw_1 = _LightMap.Sample(sampler_LightMap, (i.texcoord0.zwzz).xy);
                float3 r0_xyz_4 = ((((r0_xyzw_2.xyzx * i.color0.xyzx)).xyzx * r1_xyzw_1.xyzx)).xyz;
                float r0_w_3 = mad(r0_xyzw_2.w, i.color0.w, -_Cutoff);
                float r0_w_4 = (r0_w_3 < 0);
                if (r0_w_4) discard;
                float r0_w_5 = (cb4_values[0].x == 1);
                float r1_x_8;
                float r1_y_12;
                float r1_z_11;
                float r1_w_9;
                if (r0_w_5)
                {
                    float3 r1_yzw_3 = ((i.texcoord2.yyyy * cb4_values[2].xxyz)).yzw;
                    float3 r1_yzw_4 = (mad(cb4_values[1].xxyz, i.texcoord2.xxxx, r1_yzw_3.xxyz)).yzw;
                    float3 r1_yzw_5 = (mad(cb4_values[3].xxyz, i.texcoord2.zzzz, r1_yzw_4.xxyz)).yzw;
                    float3 r1_yzw_6 = ((r1_yzw_5.xxyz + cb4_values[4].xxyz)).yzw;
                    float4 r1_xyzw_4 = (((cb4_values[0].y == 1)).xxxx ? r1_yzw_6.xyzx : i.texcoord2.xyzx);
                    float r1_x_4 = r1_xyzw_4.x;
                    float r1_y_7 = r1_xyzw_4.y;
                    float r1_z_7 = r1_xyzw_4.z;
                    float4 r1_xyzw_5 = (float4(r1_x_4, r1_y_7, r1_z_7, r1_x_4) + -cb4_values[6].xyzx);
                    float r1_x_5 = r1_xyzw_5.x;
                    float r1_y_8 = r1_xyzw_5.y;
                    float r1_z_8 = r1_xyzw_5.z;
                    float4 r1_xyzw_9 = (float4(r1_x_5, r1_x_5, r1_y_8, r1_z_8) * cb4_values[5].xxyz);
                    float r1_y_9 = r1_xyzw_9.y;
                    float r1_z_9 = r1_xyzw_9.z;
                    float r1_w_7 = r1_xyzw_9.w;
                    float r1_y_10 = mad(r1_y_9, 0.25, 0.75);
                    float r1_x_6 = max(r1_y_10, mad(cb4_values[0].z, 0.5, 0.75));
                    float4 r1_xyzw_7 = t2.Sample(sampler_linear_clamp, (float4(r1_x_6, r1_z_9, r1_w_7, r1_x_6)).xyz);
                    r1_x_8 = r1_xyzw_7.x;
                    r1_y_12 = r1_xyzw_7.y;
                    r1_z_11 = r1_xyzw_7.z;
                    r1_w_9 = r1_xyzw_7.w;
                }
                else
                {
                    float4 r1_xyzw_8 = float4(1, 1, 1, 1);
                    r1_x_8 = r1_xyzw_8.x;
                    r1_y_12 = r1_xyzw_8.y;
                    r1_z_11 = r1_xyzw_8.z;
                    r1_w_9 = r1_xyzw_8.w;
                }
                float4 r1_xyzw_10 = ((saturate(dot(float4(r1_x_8, r1_y_12, r1_z_11, r1_w_9), cb2_values[46].xyzw))).xxxx * _LightColor0.xyzx);
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_13 = r1_xyzw_10.y;
                float r1_z_12 = r1_xyzw_10.z;
                float3 r3_xyz_4;
                if (r0_w_5)
                {
                    float r0_w_6 = (cb4_values[0].y == 1);
                    float4 r2_xyzw_4 = (i.texcoord2.yyyy * cb4_values[2].xyzx);
                    float r2_x_4 = r2_xyzw_4.x;
                    float r2_y_2 = r2_xyzw_4.y;
                    float r2_z_2 = r2_xyzw_4.z;
                    float4 r2_xyzw_5 = mad(cb4_values[1].xyzx, i.texcoord2.xxxx, float4(r2_x_4, r2_y_2, r2_z_2, r2_x_4));
                    float r2_x_5 = r2_xyzw_5.x;
                    float r2_y_3 = r2_xyzw_5.y;
                    float r2_z_3 = r2_xyzw_5.z;
                    float4 r2_xyzw_6 = mad(cb4_values[3].xyzx, i.texcoord2.zzzz, float4(r2_x_5, r2_y_3, r2_z_3, r2_x_5));
                    float r2_x_6 = r2_xyzw_6.x;
                    float r2_y_4 = r2_xyzw_6.y;
                    float r2_z_4 = r2_xyzw_6.z;
                    float4 r2_xyzw_7 = (float4(r2_x_6, r2_y_4, r2_z_4, r2_x_6) + cb4_values[4].xyzx);
                    float r2_x_7 = r2_xyzw_7.x;
                    float r2_y_5 = r2_xyzw_7.y;
                    float r2_z_5 = r2_xyzw_7.z;
                    float4 r2_xyzw_8 = (r0_w_6.xxxx ? float4(r2_x_7, r2_y_5, r2_z_5, r2_x_7) : i.texcoord2.xyzx);
                    float r2_x_8 = r2_xyzw_8.x;
                    float r2_y_6 = r2_xyzw_8.y;
                    float r2_z_6 = r2_xyzw_8.z;
                    float4 r2_xyzw_9 = (float4(r2_x_8, r2_y_6, r2_z_6, r2_x_8) + -cb4_values[6].xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_7 = r2_xyzw_9.y;
                    float r2_z_7 = r2_xyzw_9.z;
                    float r2_y_8 = ((float4(r2_x_9, r2_x_9, r2_y_7, r2_z_7) * cb4_values[5].xxyz)).y;
                    float r2_z_8 = ((float4(r2_x_9, r2_x_9, r2_y_7, r2_z_7) * cb4_values[5].xxyz)).z;
                    float r2_w_2 = ((float4(r2_x_9, r2_x_9, r2_y_7, r2_z_7) * cb4_values[5].xxyz)).w;
                    float r0_w_7 = (r2_y_8 * 0.25);
                    float r1_w_10 = (cb4_values[0].z * 0.5);
                    float r2_y_9 = mad(-cb4_values[0].z, 0.5, 0.25);
                    float r0_w_8 = max(r0_w_7, r1_w_10);
                    float r2_x_10 = min(r2_y_9, r0_w_8);
                    float4 r3_xyzw_2 = t2.Sample(sampler_linear_clamp, (float4(r2_x_10, r2_z_8, r2_w_2, r2_x_10)).xyz);
                    float4 r4_xyzw_2 = t2.Sample(sampler_linear_clamp, (((float4(r2_x_10, r2_z_8, r2_w_2, r2_x_10) + float4(0.25, 0, 0, 0))).xyzx).xyz);
                    float4 r2_xyzw_11 = (float4(r2_x_10, r2_z_8, r2_w_2, r2_x_10) + float4(0.5, 0, 0, 0));
                    float r2_x_11 = r2_xyzw_11.x;
                    float r2_y_10 = r2_xyzw_11.y;
                    float r2_z_9 = r2_xyzw_11.z;
                    float4 r2_xyzw_12 = t2.Sample(sampler_linear_clamp, (float4(r2_x_11, r2_y_10, r2_z_9, r2_x_11)).xyz);
                    float3 TEXCOORD1_xyz_1 = i.texcoord1.xyz;
                    float r5_w_1 = 1;
                    float r3_x_3 = dot(r3_xyzw_2, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r5_w_1));
                    float r3_y_3 = dot(r4_xyzw_2, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r5_w_1));
                    float r3_z_3 = dot(r2_xyzw_12, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r5_w_1));
                    r3_xyz_4 = float3(r3_x_3, r3_y_3, r3_z_3);
                }
                else
                {
                    float TEXCOORD1_x_3 = i.texcoord1.x;
                    float TEXCOORD1_y_1 = i.texcoord1.y;
                    float TEXCOORD1_z_1 = i.texcoord1.z;
                    float r2_w_1 = 1;
                    float r3_x_1 = dot(cb2_values[39].xyzw, float4(TEXCOORD1_x_3, TEXCOORD1_y_1, TEXCOORD1_z_1, r2_w_1));
                    float r3_y_1 = dot(cb2_values[40].xyzw, float4(TEXCOORD1_x_3, TEXCOORD1_y_1, TEXCOORD1_z_1, r2_w_1));
                    float r3_z_1 = dot(cb2_values[41].xyzw, float4(TEXCOORD1_x_3, TEXCOORD1_y_1, TEXCOORD1_z_1, r2_w_1));
                    r3_xyz_4 = float3(r3_x_1, r3_y_1, r3_z_1);
                }
                float4 r2_xyzw_14 = (r3_xyz_4.xyzx + i.texcoord3.xyzx);
                float r2_x_14 = r2_xyzw_14.x;
                float r2_y_13 = r2_xyzw_14.y;
                float r2_z_12 = r2_xyzw_14.z;
                float4 r2_xyzw_15 = max(float4(r2_x_14, r2_y_13, r2_z_12, r2_x_14), float4(0, 0, 0, 0));
                float r2_x_15 = r2_xyzw_15.x;
                float r2_y_14 = r2_xyzw_15.y;
                float r2_z_13 = r2_xyzw_15.z;
                float r0_w_10 = dot(i.texcoord1.xyzx, unity_ProbeVolumeParams.xyzx);
                float r0_w_11 = max(r0_w_10, 0);
                float4 r1_xyzw_11 = (r0_xyz_4.xyzx * float4(r1_x_10, r1_y_13, r1_z_12, r1_x_10));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_14 = r1_xyzw_11.y;
                float r1_z_13 = r1_xyzw_11.z;
                float4 r2_xyzw_16 = (r0_xyz_4.xyzx * float4(r2_x_15, r2_y_14, r2_z_13, r2_x_15));
                float r2_x_16 = r2_xyzw_16.x;
                float r2_y_15 = r2_xyzw_16.y;
                float r2_z_14 = r2_xyzw_16.z;
                float4 r1_xyzw_12 = mad(float4(r1_x_11, r1_y_14, r1_z_13, r1_x_11), r0_w_11.xxxx, float4(r2_x_16, r2_y_15, r2_z_14, r2_x_16));
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_15 = r1_xyzw_12.y;
                float r1_z_14 = r1_xyzw_12.z;
                float r0_w_12 = (i.texcoord4.x / cb1_values[5].y);
                float r0_w_13 = (-r0_w_12 + 1);
                float r0_w_14 = (r0_w_13 * cb1_values[5].z);
                float r0_w_15 = max(r0_w_14, 0);
                float r0_w_16 = saturate(mad(r0_w_15, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_16.xxxx, (((mad(r0_xyz_4.xyzx, float4(0.05, 0.05, 0.05, 0), float4(r1_x_12, r1_y_15, r1_z_14, r1_x_12))).xyzx + -cb3_values[0].xyzx)).xyzx, cb3_values[0].xyzx)).xyz;
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
                float _Cutoff : packoffset(c5.x);
                float4 _MainTex_ST : packoffset(c6);
                float4 _LightMap_ST : packoffset(c7);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[47];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_MainTex;
            SamplerState sampler_LightMap;
            Texture2D _MainTex;
            Texture2D _LightMap;
            Texture3D t2;
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
                float4 color0 : COLOR0;
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
                float4 color0 : COLOR0;
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
                o.texcoord0.zw = (mad(i.texcoord1.xxxy, _LightMap_ST.xxxy, _LightMap_ST.zzzw)).zw;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program34Output frag(program34Input i)
            {
                program34Output o = (program34Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r0_xyzw_2 = (r0_xyzw_1 * _Color);
                float4 r1_xyzw_1 = _LightMap.Sample(sampler_LightMap, (i.texcoord0.zwzz).xy);
                float3 r0_xyz_4 = ((((r0_xyzw_2.xyzx * i.color0.xyzx)).xyzx * r1_xyzw_1.xyzx)).xyz;
                float r0_w_3 = mad(r0_xyzw_2.w, i.color0.w, -_Cutoff);
                float r0_w_4 = (r0_w_3 < 0);
                if (r0_w_4) discard;
                float r0_w_5 = (cb4_values[0].x == 1);
                float r2_x_10;
                float r2_y_10;
                float r2_z_10;
                float r2_w_4;
                if (r0_w_5)
                {
                    float r0_w_6 = (cb4_values[0].y == 1);
                    float3 r2_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord2.zzzz, (mad(cb4_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (((((r0_w_6.xxxx ? r2_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_8 = r2_xyzw_8.z;
                    float r2_w_2 = r2_xyzw_8.w;
                    float r0_w_7 = mad(r2_y_8, 0.25, 0.75);
                    float r1_w_2 = mad(cb4_values[0].z, 0.5, 0.75);
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
                float r0_w_9 = saturate(dot(float4(r2_x_10, r2_y_10, r2_z_10, r2_w_4), cb2_values[46].xyzw));
                float r0_w_10 = dot(i.texcoord1.xyzx, unity_ProbeVolumeParams.xyzx);
                float r0_w_11 = max(r0_w_10, 0);
                float r0_w_12 = (i.texcoord4.x / cb1_values[5].y);
                float r0_w_13 = (-r0_w_12 + 1);
                float r0_w_14 = (r0_w_13 * cb1_values[5].z);
                float r0_w_15 = max(r0_w_14, 0);
                float r0_w_16 = saturate(mad(r0_w_15, cb3_values[1].z, cb3_values[1].w));
                float3 r0_xyz_7 = (((mad(((r0_xyz_4.xyzx * ((r0_w_9.xxxx * _LightColor0.xyzx)).xyzx)).xyzx, r0_w_11.xxxx, ((r0_xyz_4.xyzx * float4(0.05, 0.05, 0.05, 0))).xyzx)).xyzx + -cb3_values[0].xyzx)).xyz;
                o.sv_Target0.xyz = (mad(r0_w_16.xxxx, r0_xyz_7.xyzx, cb3_values[0].xyzx)).xyz;
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
                float _Cutoff : packoffset(c5.x);
                float4 _MainTex_ST : packoffset(c6);
                float4 _LightMap_ST : packoffset(c7);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[5];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[47];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[26];
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[21];
            };
            cbuffer cb5 : register(b5)
            {
                float4 cb5_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_MainTex;
            SamplerState sampler_LightMap;
            Texture2D _MainTex;
            Texture2D _LightMap;
            Texture2D t2;
            Texture3D t3;
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
                float4 color0 : COLOR0;
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
                float4 color0 : COLOR0;
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
                o.texcoord0.zw = (mad(i.texcoord1.xxxy, _LightMap_ST.xxxy, _LightMap_ST.zzzw)).zw;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb3_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb3_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb3_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                float3 unitWorldNormal_xyz_3 = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = unitWorldNormal_xyz_3.xyz;
                o.color0.xyzw = i.color0.xyzw;
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
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r0_xyzw_2 = (r0_xyzw_1 * _Color);
                float4 r1_xyzw_1 = _LightMap.Sample(sampler_LightMap, (i.texcoord0.zwzz).xy);
                float3 r0_xyz_4 = ((((r0_xyzw_2.xyzx * i.color0.xyzx)).xyzx * r1_xyzw_1.xyzx)).xyz;
                float r0_w_3 = mad(r0_xyzw_2.w, i.color0.w, -_Cutoff);
                float r0_w_4 = (r0_w_3 < 0);
                if (r0_w_4) discard;
                float r2_x_1 = cb4_values[9].z;
                float r2_y_1 = cb4_values[10].z;
                float r2_z_1 = cb4_values[11].z;
                float r0_w_5 = dot(((-i.texcoord2.xyzx + cb1_values[4].xyzx)).xyzx, float4(r2_x_1, r2_y_1, r2_z_1, r2_x_1));
                float3 r1_xyz_3 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r0_w_6 = mad(cb3_values[25].w, (-r0_w_5 + sqrt(dot(r1_xyz_3.xyzx, r1_xyz_3.xyzx))), r0_w_5);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[24].z, cb3_values[24].w));
                float r1_x_7 = (cb5_values[0].x == 1);
                float r2_x_9;
                float r2_y_9;
                float r2_z_9;
                float r2_w_4;
                if (r1_x_7)
                {
                    float r1_y_4 = (cb5_values[0].y == 1);
                    float3 r2_xyz_6 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r1_xyzw_5 = (r1_y_4.xxxx ? r2_xyz_6.xxyz : i.texcoord2.xxyz);
                    float r1_y_5 = r1_xyzw_5.y;
                    float r1_z_4 = r1_xyzw_5.z;
                    float r1_w_2 = r1_xyzw_5.w;
                    float4 r1_xyzw_6 = (float4(r1_y_5, r1_y_5, r1_z_4, r1_w_2) + -cb5_values[6].xxyz);
                    float r1_y_6 = r1_xyzw_6.y;
                    float r1_z_5 = r1_xyzw_6.z;
                    float r1_w_3 = r1_xyzw_6.w;
                    float4 r2_xyzw_7 = (float4(r1_y_6, r1_y_6, r1_z_5, r1_w_3) * cb5_values[5].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_2 = r2_xyzw_7.w;
                    float r1_y_7 = mad(r2_y_7, 0.25, 0.75);
                    float r1_z_6 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r2_x_7 = max(r1_z_6, r1_y_7);
                    float4 r2_xyzw_8 = t3.Sample(sampler_linear_clamp, (float4(r2_x_7, r2_z_7, r2_w_2, r2_x_7)).xyz);
                    r2_x_9 = r2_xyzw_8.x;
                    r2_y_9 = r2_xyzw_8.y;
                    r2_z_9 = r2_xyzw_8.z;
                    r2_w_4 = r2_xyzw_8.w;
                }
                else
                {
                    float4 r2_xyzw_2 = float4(1, 1, 1, 1);
                    r2_x_9 = r2_xyzw_2.x;
                    r2_y_9 = r2_xyzw_2.y;
                    r2_z_9 = r2_xyzw_2.z;
                    r2_w_4 = r2_xyzw_2.w;
                }
                float r1_y_9 = saturate(dot(float4(r2_x_9, r2_y_9, r2_z_9, r2_w_4), cb2_values[46].xyzw));
                float4 r1_xyzw_8 = (i.texcoord5.xxxy / i.texcoord5.wwww);
                float r1_z_8 = r1_xyzw_8.z;
                float r1_w_5 = r1_xyzw_8.w;
                float4 r2_xyzw_10 = t2.Sample(sampler_linear_clamp1, (float4(r1_z_8, r1_w_5, r1_z_8, r1_z_8)).xy);
                float r1_y_10 = (r1_y_9 + -r2_xyzw_10.x);
                float r0_w_8 = mad(r0_w_7, r1_y_10, r2_xyzw_10.x);
                float4 r1_xyzw_11 = (r0_w_8.xxxx * _LightColor0.xxyz);
                float r1_y_11 = r1_xyzw_11.y;
                float r1_z_9 = r1_xyzw_11.z;
                float r1_w_6 = r1_xyzw_11.w;
                float3 r3_xyz_4;
                if ((r1_x_7 != 0))
                {
                    float r0_w_9 = (cb5_values[0].y == 1);
                    float3 r2_xyz_15 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r2_xyzw_18 = (((((r0_w_9.xxxx ? r2_xyz_15.xyzx : i.texcoord2.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r2_y_18 = r2_xyzw_18.y;
                    float r2_z_18 = r2_xyzw_18.z;
                    float r2_w_7 = r2_xyzw_18.w;
                    float r0_w_10 = (r2_y_18 * 0.25);
                    float r2_y_19 = mad(-cb5_values[0].z, 0.5, 0.25);
                    float r0_w_11 = max(r0_w_10, (cb5_values[0].z * 0.5));
                    float r2_x_18 = min(r2_y_19, r0_w_11);
                    float4 r3_xyzw_2 = t3.Sample(sampler_linear_clamp, (float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18)).xyz);
                    float4 r4_xyzw_2 = t3.Sample(sampler_linear_clamp, (((float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18) + float4(0.25, 0, 0, 0))).xyzx).xyz);
                    float4 r2_xyzw_19 = (float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18) + float4(0.5, 0, 0, 0));
                    float r2_x_19 = r2_xyzw_19.x;
                    float r2_y_20 = r2_xyzw_19.y;
                    float r2_z_19 = r2_xyzw_19.z;
                    float4 r2_xyzw_20 = t3.Sample(sampler_linear_clamp, (float4(r2_x_19, r2_y_20, r2_z_19, r2_x_19)).xyz);
                    float3 TEXCOORD1_xyz_1 = i.texcoord1.xyz;
                    float r5_w_1 = 1;
                    float r3_x_3 = dot(r3_xyzw_2, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r5_w_1));
                    float r3_y_3 = dot(r4_xyzw_2, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r5_w_1));
                    float r3_z_3 = dot(r2_xyzw_20, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r5_w_1));
                    r3_xyz_4 = float3(r3_x_3, r3_y_3, r3_z_3);
                }
                else
                {
                    float3 TEXCOORD1_xyz_11 = i.texcoord1.xyz;
                    float r2_w_6 = 1;
                    float r3_x_1 = dot(cb2_values[39].xyzw, float4(TEXCOORD1_xyz_11.x, TEXCOORD1_xyz_11.y, TEXCOORD1_xyz_11.z, r2_w_6));
                    float r3_y_1 = dot(cb2_values[40].xyzw, float4(TEXCOORD1_xyz_11.x, TEXCOORD1_xyz_11.y, TEXCOORD1_xyz_11.z, r2_w_6));
                    float r3_z_1 = dot(cb2_values[41].xyzw, float4(TEXCOORD1_xyz_11.x, TEXCOORD1_xyz_11.y, TEXCOORD1_xyz_11.z, r2_w_6));
                    r3_xyz_4 = float3(r3_x_1, r3_y_1, r3_z_1);
                }
                float4 r2_xyzw_22 = (r3_xyz_4.xyzx + i.texcoord3.xyzx);
                float r2_x_22 = r2_xyzw_22.x;
                float r2_y_23 = r2_xyzw_22.y;
                float r2_z_22 = r2_xyzw_22.z;
                float4 r2_xyzw_23 = max(float4(r2_x_22, r2_y_23, r2_z_22, r2_x_22), float4(0, 0, 0, 0));
                float r2_x_23 = r2_xyzw_23.x;
                float r2_y_24 = r2_xyzw_23.y;
                float r2_z_23 = r2_xyzw_23.z;
                float r0_w_13 = dot(i.texcoord1.xyzx, unity_ProbeVolumeParams.xyzx);
                float r0_w_14 = max(r0_w_13, 0);
                float4 r1_xyzw_10 = (r0_xyz_4.xyzx * float4(r1_y_11, r1_z_9, r1_w_6, r1_y_11));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_12 = r1_xyzw_10.y;
                float r1_z_10 = r1_xyzw_10.z;
                float4 r2_xyzw_24 = (r0_xyz_4.xyzx * float4(r2_x_23, r2_y_24, r2_z_23, r2_x_23));
                float r2_x_24 = r2_xyzw_24.x;
                float r2_y_25 = r2_xyzw_24.y;
                float r2_z_24 = r2_xyzw_24.z;
                float r1_x_11 = (mad(float4(r1_x_10, r1_y_12, r1_z_10, r1_x_10), r0_w_14.xxxx, float4(r2_x_24, r2_y_25, r2_z_24, r2_x_24))).x;
                float4 r1_xyzw_13 = mad(float4(r1_x_10, r1_y_12, r1_z_10, r1_x_10), r0_w_14.xxxx, float4(r2_x_24, r2_y_25, r2_z_24, r2_x_24));
                float r1_y_13 = r1_xyzw_13.y;
                float r1_z_11 = r1_xyzw_13.z;
                o.sv_Target0.xyz = (mad(r0_xyz_4.xyzx, float4(0.05, 0.05, 0.05, 0), float4(r1_x_11, r1_y_13, r1_z_11, r1_x_11))).xyz;
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
                float _Cutoff : packoffset(c5.x);
                float4 _MainTex_ST : packoffset(c6);
                float4 _LightMap_ST : packoffset(c7);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[5];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[47];
            };
            cbuffer cb3 : register(b3)
            {
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
            SamplerState sampler_LightMap;
            Texture2D _MainTex;
            Texture2D _LightMap;
            Texture2D t2;
            Texture3D t3;
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
                float4 color0 : COLOR0;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program32Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
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
                o.texcoord0.zw = (mad(i.texcoord1.xxxy, _LightMap_ST.xxxy, _LightMap_ST.zzzw)).zw;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.color0.xyzw = i.color0.xyzw;
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
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r0_xyzw_2 = (r0_xyzw_1 * _Color);
                float4 r1_xyzw_1 = _LightMap.Sample(sampler_LightMap, (i.texcoord0.zwzz).xy);
                float3 r0_xyz_4 = ((((r0_xyzw_2.xyzx * i.color0.xyzx)).xyzx * r1_xyzw_1.xyzx)).xyz;
                float r0_w_3 = mad(r0_xyzw_2.w, i.color0.w, -_Cutoff);
                float r0_w_4 = (r0_w_3 < 0);
                if (r0_w_4) discard;
                float r3_x_1 = cb4_values[9].z;
                float r3_y_1 = cb4_values[10].z;
                float r3_z_1 = cb4_values[11].z;
                float r0_w_5 = dot(((-i.texcoord2.xyzx + cb1_values[4].xyzx)).xyzx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float3 r2_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_2 = dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx);
                float r1_w_3 = sqrt(r1_w_2);
                float r1_w_4 = (-r0_w_5 + r1_w_3);
                float r0_w_6 = mad(cb3_values[25].w, r1_w_4, r0_w_5);
                float r0_w_7 = saturate(mad(r0_w_6, cb3_values[24].z, cb3_values[24].w));
                float r1_w_5 = (cb5_values[0].x == 1);
                float r2_x_12;
                float r2_y_13;
                float r2_z_12;
                float r2_w_4;
                if (r1_w_5)
                {
                    float r1_w_6 = (cb5_values[0].y == 1);
                    float3 r2_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r2_xyzw_10 = (((((r1_w_6.xxxx ? r2_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r2_y_10 = r2_xyzw_10.y;
                    float r2_z_10 = r2_xyzw_10.z;
                    float r2_w_2 = r2_xyzw_10.w;
                    float r1_w_7 = mad(r2_y_10, 0.25, 0.75);
                    float r2_y_11 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r2_x_10 = max(r1_w_7, r2_y_11);
                    float4 r2_xyzw_11 = t3.Sample(sampler_linear_clamp, (float4(r2_x_10, r2_z_10, r2_w_2, r2_x_10)).xyz);
                    r2_x_12 = r2_xyzw_11.x;
                    r2_y_13 = r2_xyzw_11.y;
                    r2_z_12 = r2_xyzw_11.z;
                    r2_w_4 = r2_xyzw_11.w;
                }
                else
                {
                    float4 r2_xyzw_3 = float4(1, 1, 1, 1);
                    r2_x_12 = r2_xyzw_3.x;
                    r2_y_13 = r2_xyzw_3.y;
                    r2_z_12 = r2_xyzw_3.z;
                    r2_w_4 = r2_xyzw_3.w;
                }
                float r1_w_9 = saturate(dot(float4(r2_x_12, r2_y_13, r2_z_12, r2_w_4), cb2_values[46].xyzw));
                float4 r2_xyzw_13 = (i.texcoord5.xyxx / i.texcoord5.wwww);
                float r2_x_13 = r2_xyzw_13.x;
                float r2_y_14 = r2_xyzw_13.y;
                float4 r2_xyzw_14 = t2.Sample(sampler_linear_clamp1, (float4(r2_x_13, r2_y_14, r2_x_13, r2_x_13)).xy);
                float r1_w_10 = (r1_w_9 + -r2_xyzw_14.x);
                float r0_w_8 = mad(r0_w_7, r1_w_10, r2_xyzw_14.x);
                float4 r2_xyzw_15 = (r0_w_8.xxxx * _LightColor0.xyzx);
                float r2_x_15 = r2_xyzw_15.x;
                float r2_y_16 = r2_xyzw_15.y;
                float r2_z_14 = r2_xyzw_15.z;
                float r0_w_9 = dot(i.texcoord1.xyzx, unity_ProbeVolumeParams.xyzx);
                float r0_w_10 = max(r0_w_9, 0);
                o.sv_Target0.xyz = (mad(((r0_xyz_4.xyzx * float4(r2_x_15, r2_y_16, r2_z_14, r2_x_15))).xyzx, r0_w_10.xxxx, ((r0_xyz_4.xyzx * float4(0.05, 0.05, 0.05, 0))).xyzx)).xyz;
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
                float _Cutoff : packoffset(c5.x);
                float4 _MainTex_ST : packoffset(c6);
                float4 _LightMap_ST : packoffset(c7);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[46];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[7];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[21];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_MainTex;
            SamplerState sampler_LightMap;
            Texture2D _MainTex;
            Texture2D _LightMap;
            Texture3D t2;
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
                float4 color0 : COLOR0;
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
                float4 color0 : COLOR0;
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
                o.texcoord0.zw = (mad(i.texcoord1.xxxy, _LightMap_ST.xxxy, _LightMap_ST.zzzw)).zw;
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                float3 unitWorldNormal_xyz_8 = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.texcoord1.xyz = unitWorldNormal_xyz_8.xyz;
                o.color0.xyzw = i.color0.xyzw;
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
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r0_xyzw_2 = (r0_xyzw_1 * _Color);
                float4 r1_xyzw_1 = _LightMap.Sample(sampler_LightMap, (i.texcoord0.zwzz).xy);
                float3 r0_xyz_4 = ((((r0_xyzw_2.xyzx * i.color0.xyzx)).xyzx * r1_xyzw_1.xyzx)).xyz;
                float r0_w_3 = mad(r0_xyzw_2.w, i.color0.w, -_Cutoff);
                float r0_w_4 = (r0_w_3 < 0);
                if (r0_w_4) discard;
                float r0_w_5 = (unity_ProbeVolumeParams.x == 1);
                float r1_x_8;
                float r1_y_12;
                float r1_z_11;
                float r1_w_9;
                if (r0_w_5)
                {
                    float3 r1_yzw_3 = ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xxyz)).yzw;
                    float3 r1_yzw_4 = (mad(unity_ProbeVolumeWorldToObject[0].xxyz, i.texcoord2.xxxx, r1_yzw_3.xxyz)).yzw;
                    float3 r1_yzw_5 = (mad(unity_ProbeVolumeWorldToObject[2].xxyz, i.texcoord2.zzzz, r1_yzw_4.xxyz)).yzw;
                    float3 r1_yzw_6 = ((r1_yzw_5.xxyz + unity_ProbeVolumeWorldToObject[3].xxyz)).yzw;
                    float4 unity_ProbeVolumeParamsSelect_xyzw_4 = (((unity_ProbeVolumeParams.y == 1)).xxxx ? r1_yzw_6.xyzx : i.texcoord2.xyzx);
                    float unity_ProbeVolumeParamsSelect_x_4 = unity_ProbeVolumeParamsSelect_xyzw_4.x;
                    float unity_ProbeVolumeParamsSelect_y_7 = unity_ProbeVolumeParamsSelect_xyzw_4.y;
                    float unity_ProbeVolumeParamsSelect_z_7 = unity_ProbeVolumeParamsSelect_xyzw_4.z;
                    float4 r1_xyzw_5 = (float4(unity_ProbeVolumeParamsSelect_x_4, unity_ProbeVolumeParamsSelect_y_7, unity_ProbeVolumeParamsSelect_z_7, unity_ProbeVolumeParamsSelect_x_4) + -unity_ProbeVolumeMin.xyzx);
                    float r1_x_5 = r1_xyzw_5.x;
                    float r1_y_8 = r1_xyzw_5.y;
                    float r1_z_8 = r1_xyzw_5.z;
                    float4 r1_xyzw_9 = (float4(r1_x_5, r1_x_5, r1_y_8, r1_z_8) * unity_ProbeVolumeSizeInv.xxyz);
                    float r1_y_9 = r1_xyzw_9.y;
                    float r1_z_9 = r1_xyzw_9.z;
                    float r1_w_7 = r1_xyzw_9.w;
                    float r1_y_10 = mad(r1_y_9, 0.25, 0.75);
                    float r1_x_6 = max(r1_y_10, mad(unity_ProbeVolumeParams.z, 0.5, 0.75));
                    float4 r1_xyzw_7 = t2.Sample(sampler_linear_clamp, (float4(r1_x_6, r1_z_9, r1_w_7, r1_x_6)).xyz);
                    r1_x_8 = r1_xyzw_7.x;
                    r1_y_12 = r1_xyzw_7.y;
                    r1_z_11 = r1_xyzw_7.z;
                    r1_w_9 = r1_xyzw_7.w;
                }
                else
                {
                    float4 r1_xyzw_8 = float4(1, 1, 1, 1);
                    r1_x_8 = r1_xyzw_8.x;
                    r1_y_12 = r1_xyzw_8.y;
                    r1_z_11 = r1_xyzw_8.z;
                    r1_w_9 = r1_xyzw_8.w;
                }
                float4 r1_xyzw_10 = ((saturate(dot(float4(r1_x_8, r1_y_12, r1_z_11, r1_w_9), unity_OcclusionMaskSelector))).xxxx * _LightColor0.xyzx);
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_13 = r1_xyzw_10.y;
                float r1_z_12 = r1_xyzw_10.z;
                float3 r3_xyz_4;
                if (r0_w_5)
                {
                    float r0_w_6 = (unity_ProbeVolumeParams.y == 1);
                    float4 r2_xyzw_4 = (i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx);
                    float r2_x_4 = r2_xyzw_4.x;
                    float r2_y_2 = r2_xyzw_4.y;
                    float r2_z_2 = r2_xyzw_4.z;
                    float4 r2_xyzw_5 = mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, float4(r2_x_4, r2_y_2, r2_z_2, r2_x_4));
                    float r2_x_5 = r2_xyzw_5.x;
                    float r2_y_3 = r2_xyzw_5.y;
                    float r2_z_3 = r2_xyzw_5.z;
                    float4 r2_xyzw_6 = mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, float4(r2_x_5, r2_y_3, r2_z_3, r2_x_5));
                    float r2_x_6 = r2_xyzw_6.x;
                    float r2_y_4 = r2_xyzw_6.y;
                    float r2_z_4 = r2_xyzw_6.z;
                    float4 r2_xyzw_7 = (float4(r2_x_6, r2_y_4, r2_z_4, r2_x_6) + unity_ProbeVolumeWorldToObject[3].xyzx);
                    float r2_x_7 = r2_xyzw_7.x;
                    float r2_y_5 = r2_xyzw_7.y;
                    float r2_z_5 = r2_xyzw_7.z;
                    float4 unity_ProbeVolumeParamsSelect_xyzw_8 = (r0_w_6.xxxx ? float4(r2_x_7, r2_y_5, r2_z_5, r2_x_7) : i.texcoord2.xyzx);
                    float unity_ProbeVolumeParamsSelect_x_8 = unity_ProbeVolumeParamsSelect_xyzw_8.x;
                    float unity_ProbeVolumeParamsSelect_y_6 = unity_ProbeVolumeParamsSelect_xyzw_8.y;
                    float unity_ProbeVolumeParamsSelect_z_6 = unity_ProbeVolumeParamsSelect_xyzw_8.z;
                    float4 r2_xyzw_9 = (float4(unity_ProbeVolumeParamsSelect_x_8, unity_ProbeVolumeParamsSelect_y_6, unity_ProbeVolumeParamsSelect_z_6, unity_ProbeVolumeParamsSelect_x_8) + -unity_ProbeVolumeMin.xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_7 = r2_xyzw_9.y;
                    float r2_z_7 = r2_xyzw_9.z;
                    float4 r2_xyzw_8 = (float4(r2_x_9, r2_x_9, r2_y_7, r2_z_7) * unity_ProbeVolumeSizeInv.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_8 = r2_xyzw_8.z;
                    float r2_w_2 = r2_xyzw_8.w;
                    float r0_w_7 = (r2_y_8 * 0.25);
                    float r1_w_10 = (unity_ProbeVolumeParams.z * 0.5);
                    float r2_y_9 = mad(-unity_ProbeVolumeParams.z, 0.5, 0.25);
                    float r0_w_8 = max(r0_w_7, r1_w_10);
                    float r2_x_10 = min(r2_y_9, r0_w_8);
                    float4 r3_xyzw_2 = t2.Sample(sampler_linear_clamp, (float4(r2_x_10, r2_z_8, r2_w_2, r2_x_10)).xyz);
                    float4 r4_xyzw_2 = t2.Sample(sampler_linear_clamp, (((float4(r2_x_10, r2_z_8, r2_w_2, r2_x_10) + float4(0.25, 0, 0, 0))).xyzx).xyz);
                    float4 r2_xyzw_11 = (float4(r2_x_10, r2_z_8, r2_w_2, r2_x_10) + float4(0.5, 0, 0, 0));
                    float r2_x_11 = r2_xyzw_11.x;
                    float r2_y_10 = r2_xyzw_11.y;
                    float r2_z_9 = r2_xyzw_11.z;
                    float4 r2_xyzw_12 = t2.Sample(sampler_linear_clamp, (float4(r2_x_11, r2_y_10, r2_z_9, r2_x_11)).xyz);
                    float3 TEXCOORD1_xyz_1 = i.texcoord1.xyz;
                    float r5_w_1 = 1;
                    float r3_x_3 = dot(r3_xyzw_2, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r5_w_1));
                    float r3_y_3 = dot(r4_xyzw_2, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r5_w_1));
                    float r3_z_3 = dot(r2_xyzw_12, float4(TEXCOORD1_xyz_1.x, TEXCOORD1_xyz_1.y, TEXCOORD1_xyz_1.z, r5_w_1));
                    r3_xyz_4 = float3(r3_x_3, r3_y_3, r3_z_3);
                }
                else
                {
                    float TEXCOORD1_x_3 = i.texcoord1.x;
                    float TEXCOORD1_y_1 = i.texcoord1.y;
                    float TEXCOORD1_z_1 = i.texcoord1.z;
                    float r2_w_1 = 1;
                    float r3_x_1 = dot(cb1_values[39].xyzw, float4(TEXCOORD1_x_3, TEXCOORD1_y_1, TEXCOORD1_z_1, r2_w_1));
                    float r3_y_1 = dot(cb1_values[40].xyzw, float4(TEXCOORD1_x_3, TEXCOORD1_y_1, TEXCOORD1_z_1, r2_w_1));
                    float r3_z_1 = dot(cb1_values[41].xyzw, float4(TEXCOORD1_x_3, TEXCOORD1_y_1, TEXCOORD1_z_1, r2_w_1));
                    r3_xyz_4 = float3(r3_x_1, r3_y_1, r3_z_1);
                }
                float4 r2_xyzw_14 = (r3_xyz_4.xyzx + i.texcoord3.xyzx);
                float r2_x_14 = r2_xyzw_14.x;
                float r2_y_13 = r2_xyzw_14.y;
                float r2_z_12 = r2_xyzw_14.z;
                float4 r2_xyzw_15 = max(float4(r2_x_14, r2_y_13, r2_z_12, r2_x_14), float4(0, 0, 0, 0));
                float r2_x_15 = r2_xyzw_15.x;
                float r2_y_14 = r2_xyzw_15.y;
                float r2_z_13 = r2_xyzw_15.z;
                float r0_w_10 = dot(i.texcoord1.xyzx, unity_ObjectToWorld[0].xyzx);
                float r0_w_11 = max(r0_w_10, 0);
                float4 r1_xyzw_11 = (r0_xyz_4.xyzx * float4(r1_x_10, r1_y_13, r1_z_12, r1_x_10));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_14 = r1_xyzw_11.y;
                float r1_z_13 = r1_xyzw_11.z;
                float4 r2_xyzw_16 = (r0_xyz_4.xyzx * float4(r2_x_15, r2_y_14, r2_z_13, r2_x_15));
                float r2_x_16 = r2_xyzw_16.x;
                float r2_y_15 = r2_xyzw_16.y;
                float r2_z_14 = r2_xyzw_16.z;
                float4 r1_xyzw_12 = mad(float4(r1_x_11, r1_y_14, r1_z_13, r1_x_11), r0_w_11.xxxx, float4(r2_x_16, r2_y_15, r2_z_14, r2_x_16));
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_15 = r1_xyzw_12.y;
                float r1_z_14 = r1_xyzw_12.z;
                o.sv_Target0.xyz = (mad(r0_xyz_4.xyzx, float4(0.05, 0.05, 0.05, 0), float4(r1_x_12, r1_y_15, r1_z_14, r1_x_12))).xyz;
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
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0;
                float4 _Color;
                float _Cutoff;
                float4 _MainTex_ST;
                float4 _LightMap_ST;
                float4 cb0_values[12];
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
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_MainTex;
            SamplerState sampler_LightMap;
            Texture2D _MainTex;
            Texture2D _LightMap;
            Texture2D t2;
            Texture3D t3;
            struct program40Input
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
            struct program40Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program58Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program58Output
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
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord1.xxxy, cb0_values[11].xxxy, cb0_values[11].zzzw)).zw;
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                float3 clipPos_xyz_3 = ((worldPos_xyzw_4.yyyy * cb0_values[5].xyzx)).xyz;
                float3 clipPos_xyz_4 = (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_3.xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.zzzz, clipPos_xyz_4.xyzx)).xyz;
                o.texcoord3.xyz = (mad(_LightMap_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program58Output frag(program58Input i)
            {
                program58Output o = (program58Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + unity_ObjectToWorld[0].xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_2 = (r1_xyzw_1 * cb0_values[8].xyzw);
                float4 r2_xyzw_1 = _LightMap.Sample(sampler_LightMap, (i.texcoord0.zwzz).xy);
                float r0_w_3 = mad(r1_xyzw_2.w, i.color0.w, -cb0_values[9].x);
                float r0_w_4 = (r0_w_3 < 0);
                if (r0_w_4) discard;
                float3 r2_xyz_5 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_5 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_5)
                {
                    float r0_w_6 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_6.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_7 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_3 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_7, r1_w_3);
                    float4 r3_xyzw_9 = t3.Sample(sampler_linear_clamp, (float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8)).xyz);
                    r3_x_10 = r3_xyzw_9.x;
                    r3_y_10 = r3_xyzw_9.y;
                    r3_z_10 = r3_xyzw_9.z;
                    r3_w_4 = r3_xyzw_9.w;
                }
                else
                {
                    float4 r3_xyzw_10 = float4(1, 1, 1, 1);
                    r3_x_10 = r3_xyzw_10.x;
                    r3_y_10 = r3_xyzw_10.y;
                    r3_z_10 = r3_xyzw_10.z;
                    r3_w_4 = r3_xyzw_10.w;
                }
                float r0_w_9 = saturate(dot(float4(r3_x_10, r3_y_10, r3_z_10, r3_w_4), unity_OcclusionMaskSelector));
                float r1_w_5 = dot(r2_xyz_5.xyzx, r2_xyz_5.xyzx);
                float4 r2_xyzw_6 = t2.Sample(sampler_linear_clamp1, (r1_w_5.xxxx).xy);
                float r0_w_10 = (r0_w_9 * r2_xyzw_6.x);
                float4 r0_xyzw_3 = (((((r1_xyzw_2.xyzx * i.color0.xyzx)).xyzx * r2_xyzw_1.xyzx)).xxyz * ((r0_w_10.xxxx * _LightColor0.xyzx)).xxyz);
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_11 = r0_xyzw_3.w;
                o.sv_Target0.xyz = (((max(dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_11, r0_y_3))).xyz;
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
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0;
                float4 _Color;
                float _Cutoff;
                float4 _MainTex_ST;
                float4 _LightMap_ST;
                float4 cb0_values[12];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[47];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_MainTex;
            SamplerState sampler_LightMap;
            Texture2D _MainTex;
            Texture2D _LightMap;
            Texture2D t2;
            Texture3D t3;
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
                float4 color0 : COLOR0;
                float2 texcoord3 : TEXCOORD3;
                float texcoord5 : TEXCOORD5;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program67Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float2 texcoord3 : TEXCOORD3;
                float texcoord5 : TEXCOORD5;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program67Output
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
                o.texcoord5.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord1.xxxy, cb0_values[11].xxxy, cb0_values[11].zzzw)).zw;
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                float2 clipPos_xy_4 = ((worldPos_xyzw_4.yyyy * cb0_values[5].xyxx)).xy;
                float2 clipPos_xy_5 = (mad(_Color.xyxx, worldPos_xyzw_4.xxxx, clipPos_xy_4.xyxx)).xy;
                float2 clipPos_xy_6 = (mad(_MainTex_ST.xyxx, worldPos_xyzw_4.zzzz, clipPos_xy_5.xyxx)).xy;
                o.texcoord3.xy = (mad(_LightMap_ST.xyxx, worldPos_xyzw_4.wwww, clipPos_xy_6.xyxx)).xy;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program67Output frag(program67Input i)
            {
                program67Output o = (program67Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r0_xyzw_2 = (r0_xyzw_1 * cb0_values[8].xyzw);
                float4 r1_xyzw_1 = _LightMap.Sample(sampler_LightMap, (i.texcoord0.zwzz).xy);
                float r0_w_3 = mad(r0_xyzw_2.w, i.color0.w, -cb0_values[9].x);
                float r0_w_4 = (r0_w_3 < 0);
                if (r0_w_4) discard;
                float r0_w_5 = (cb4_values[0].x == 1);
                float r2_x_10;
                float r2_y_10;
                float r2_z_10;
                float r2_w_4;
                if (r0_w_5)
                {
                    float r0_w_6 = (cb4_values[0].y == 1);
                    float3 r2_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord2.zzzz, (mad(cb4_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r2_xyzw_8 = (((((r0_w_6.xxxx ? r2_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_8 = r2_xyzw_8.z;
                    float r2_w_2 = r2_xyzw_8.w;
                    float r0_w_7 = mad(r2_y_8, 0.25, 0.75);
                    float r1_z_2 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r2_x_8 = max(r0_w_7, r1_z_2);
                    float4 r2_xyzw_9 = t3.Sample(sampler_linear_clamp, (float4(r2_x_8, r2_z_8, r2_w_2, r2_x_8)).xyz);
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
                float r0_w_9 = saturate(dot(float4(r2_x_10, r2_y_10, r2_z_10, r2_w_4), cb2_values[46].xyzw));
                float4 r1_xyzw_6 = t2.Sample(sampler_linear_clamp1, ((((mad(cb0_values[6].xyxx, i.texcoord2.zzzz, (mad(cb0_values[4].xyxx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx).xy);
                float r0_w_10 = (r0_w_9 * r1_xyzw_6.w);
                float4 r1_xyzw_7 = (r0_w_10.xxxx * _LightColor0.xyzx);
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_7 = r1_xyzw_7.y;
                float r1_z_5 = r1_xyzw_7.z;
                float r0_w_11 = dot(i.texcoord1.xyzx, unity_ProbeVolumeParams.xyzx);
                float r0_w_12 = max(r0_w_11, 0);
                float r0_w_13 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_14 = (-r0_w_13 + 1);
                float r0_w_15 = (r0_w_14 * cb1_values[5].z);
                float r0_w_16 = max(r0_w_15, 0);
                float r0_w_17 = saturate(mad(r0_w_16, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = ((((r0_w_12.xxxx * ((((((r0_xyzw_2.xyzx * i.color0.xyzx)).xyzx * r1_xyzw_1.xyzx)).xyzx * float4(r1_x_7, r1_y_7, r1_z_5, r1_x_7))).xyzx)).xyzx * r0_w_17.xxxx)).xyz;
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
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0;
                float4 _Color;
                float _Cutoff;
                float4 _MainTex_ST;
                float4 _LightMap_ST;
                float4 cb0_values[12];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[47];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            SamplerState sampler_LightMap;
            Texture2D _MainTex;
            Texture2D _LightMap;
            Texture2D t2;
            TextureCube t3;
            Texture3D t4;
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
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program66Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program66Output
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
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord5.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord1.xxxy, cb0_values[11].xxxy, cb0_values[11].zzzw)).zw;
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                float3 clipPos_xyz_4 = ((worldPos_xyzw_4.yyyy * cb0_values[5].xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.zzzz, (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_4.xyzx)).xyzx)).xyz;
                o.texcoord3.xyz = (mad(_LightMap_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program66Output frag(program66Input i)
            {
                program66Output o = (program66Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + unity_ProbeVolumeParams.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_2 = (r1_xyzw_1 * cb0_values[8].xyzw);
                float4 r2_xyzw_1 = _LightMap.Sample(sampler_LightMap, (i.texcoord0.zwzz).xy);
                float r0_w_3 = mad(r1_xyzw_2.w, i.color0.w, -cb0_values[9].x);
                float r0_w_4 = (r0_w_3 < 0);
                if (r0_w_4) discard;
                float3 r2_xyz_5 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_5 = (cb4_values[0].x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_5)
                {
                    float r0_w_6 = (cb4_values[0].y == 1);
                    float3 r3_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord2.zzzz, (mad(cb4_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r3_xyzw_8 = (((((r0_w_6.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_7 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_3 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_7, r1_w_3);
                    float4 r3_xyzw_9 = t4.Sample(sampler_linear_clamp, (float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8)).xyz);
                    r3_x_10 = r3_xyzw_9.x;
                    r3_y_10 = r3_xyzw_9.y;
                    r3_z_10 = r3_xyzw_9.z;
                    r3_w_4 = r3_xyzw_9.w;
                }
                else
                {
                    float4 r3_xyzw_10 = float4(1, 1, 1, 1);
                    r3_x_10 = r3_xyzw_10.x;
                    r3_y_10 = r3_xyzw_10.y;
                    r3_z_10 = r3_xyzw_10.z;
                    r3_w_4 = r3_xyzw_10.w;
                }
                float r0_w_9 = saturate(dot(float4(r3_x_10, r3_y_10, r3_z_10, r3_w_4), cb2_values[46].xyzw));
                float r1_w_5 = dot(r2_xyz_5.xyzx, r2_xyz_5.xyzx);
                float4 r3_xyzw_11 = t2.Sample(sampler_linear_clamp2, (r1_w_5.xxxx).xy);
                float4 r2_xyzw_6 = t3.Sample(sampler_linear_clamp1, r2_xyz_5.xyz);
                float r1_w_6 = (r2_xyzw_6.w * r3_xyzw_11.x);
                float r0_w_10 = (r0_w_9 * r1_w_6);
                float4 r0_xyzw_3 = (((((r1_xyzw_2.xyzx * i.color0.xyzx)).xyzx * r2_xyzw_1.xyzx)).xxyz * ((r0_w_10.xxxx * _LightColor0.xyzx)).xxyz);
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_11 = r0_xyzw_3.w;
                float4 r0_xyzw_5 = ((max(dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_11, r0_y_3));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float r0_w_12 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_13 = (-r0_w_12 + 1);
                float r0_w_14 = (r0_w_13 * cb1_values[5].z);
                float r0_w_15 = max(r0_w_14, 0);
                float r0_w_16 = saturate(mad(r0_w_15, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5) * r0_w_16.xxxx)).xyz;
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
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0;
                float4 _Color;
                float _Cutoff;
                float4 _MainTex_ST;
                float4 _LightMap_ST;
                float4 cb0_values[12];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[47];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            SamplerState sampler_LightMap;
            Texture2D _MainTex;
            Texture2D _LightMap;
            Texture2D t2;
            Texture2D t3;
            Texture3D t4;
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
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program65Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program65Output
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
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * unity_MatrixVP[1])));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord5.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord1.xxxy, cb0_values[11].xxxy, cb0_values[11].zzzw)).zw;
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_4.yyyy * cb0_values[5].xyzw);
                float4 clipPos_xyzw_5 = mad(_Color, worldPos_xyzw_4.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(_MainTex_ST, worldPos_xyzw_4.zzzz, clipPos_xyzw_5);
                o.texcoord3.xyzw = mad(_LightMap_ST, worldPos_xyzw_4.wwww, clipPos_xyzw_6);
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program65Output frag(program65Input i)
            {
                program65Output o = (program65Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + unity_ProbeVolumeParams.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_2 = (r1_xyzw_1 * cb0_values[8].xyzw);
                float4 r2_xyzw_1 = _LightMap.Sample(sampler_LightMap, (i.texcoord0.zwzz).xy);
                float r0_w_3 = mad(r1_xyzw_2.w, i.color0.w, -cb0_values[9].x);
                float r0_w_4 = (r0_w_3 < 0);
                if (r0_w_4) discard;
                float4 r2_xyzw_5 = (mad(cb0_values[6].xyzw, i.texcoord2.zzzz, mad(cb0_values[4].xyzw, i.texcoord2.xxxx, (i.texcoord2.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r0_w_5 = (cb4_values[0].x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_5)
                {
                    float r0_w_6 = (cb4_values[0].y == 1);
                    float3 r3_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord2.zzzz, (mad(cb4_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r3_xyzw_8 = (((((r0_w_6.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_7 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_3 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_7, r1_w_3);
                    float4 r3_xyzw_9 = t4.Sample(sampler_linear_clamp, (float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8)).xyz);
                    r3_x_10 = r3_xyzw_9.x;
                    r3_y_10 = r3_xyzw_9.y;
                    r3_z_10 = r3_xyzw_9.z;
                    r3_w_4 = r3_xyzw_9.w;
                }
                else
                {
                    float4 r3_xyzw_10 = float4(1, 1, 1, 1);
                    r3_x_10 = r3_xyzw_10.x;
                    r3_y_10 = r3_xyzw_10.y;
                    r3_z_10 = r3_xyzw_10.z;
                    r3_w_4 = r3_xyzw_10.w;
                }
                float r0_w_9 = saturate(dot(float4(r3_x_10, r3_y_10, r3_z_10, r3_w_4), cb2_values[46].xyzw));
                float r1_w_5 = (0 < r2_xyzw_5.z);
                float r1_w_6 = asfloat(asint(r1_w_5) & asint(1065353216));
                float4 r3_xyzw_13 = t2.Sample(sampler_linear_clamp1, (((((r2_xyzw_5.xyxx / r2_xyzw_5.wwww)).xyxx + float4(0.5, 0.5, 0, 0))).xyxx).xy);
                float r1_w_7 = (r1_w_6 * r3_xyzw_13.w);
                float4 r2_xyzw_7 = t3.Sample(sampler_linear_clamp2, ((dot(r2_xyzw_5.xyzx, r2_xyzw_5.xyzx)).xxxx).xy);
                float r1_w_8 = (r1_w_7 * r2_xyzw_7.x);
                float r0_w_10 = (r0_w_9 * r1_w_8);
                float4 r2_xyzw_8 = (r0_w_10.xxxx * _LightColor0.xyzx);
                float r2_x_8 = r2_xyzw_8.x;
                float r2_y_7 = r2_xyzw_8.y;
                float r2_z_7 = r2_xyzw_8.z;
                float4 r0_xyzw_3 = (((((r1_xyzw_2.xyzx * i.color0.xyzx)).xyzx * r2_xyzw_1.xyzx)).xxyz * float4(r2_x_8, r2_x_8, r2_y_7, r2_z_7));
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_11 = r0_xyzw_3.w;
                float4 r0_xyzw_5 = ((max(dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_11, r0_y_3));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float r0_w_12 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_13 = (-r0_w_12 + 1);
                float r0_w_14 = (r0_w_13 * cb1_values[5].z);
                float r0_w_15 = max(r0_w_14, 0);
                float r0_w_16 = saturate(mad(r0_w_15, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5) * r0_w_16.xxxx)).xyz;
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
            HLSLPROGRAM
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
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[47];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_MainTex;
            SamplerState sampler_LightMap;
            Texture2D _MainTex;
            Texture2D _LightMap;
            Texture3D t2;
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
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program64Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program64Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program46Output vert(program46Input i)
            {
                program46Output o = (program46Output)0;
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
                o.texcoord0.zw = (mad(i.texcoord1.xxxy, _LightMap_ST.xxxy, _LightMap_ST.zzzw)).zw;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program64Output frag(program64Input i)
            {
                program64Output o = (program64Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r0_xyzw_2 = (r0_xyzw_1 * cb0_values[4].xyzw);
                float4 r1_xyzw_1 = _LightMap.Sample(sampler_LightMap, (i.texcoord0.zwzz).xy);
                float r0_w_3 = mad(r0_xyzw_2.w, i.color0.w, -cb0_values[5].x);
                float r0_w_4 = (r0_w_3 < 0);
                if (r0_w_4) discard;
                float r0_w_5 = (cb4_values[0].x == 1);
                float r1_x_11;
                float r1_y_12;
                float r1_z_11;
                float r1_w_5;
                if (r0_w_5)
                {
                    float r0_w_6 = (cb4_values[0].y == 1);
                    float3 r1_xyz_6 = (((mad(cb4_values[3].xyzx, i.texcoord2.zzzz, (mad(cb4_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r1_xyzw_9 = (((((r0_w_6.xxxx ? r1_xyz_6.xyzx : i.texcoord2.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r1_y_9 = r1_xyzw_9.y;
                    float r1_z_9 = r1_xyzw_9.z;
                    float r1_w_3 = r1_xyzw_9.w;
                    float r0_w_7 = mad(r1_y_9, 0.25, 0.75);
                    float r1_y_10 = mad(cb4_values[0].z, 0.5, 0.75);
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
                float r0_w_9 = saturate(dot(float4(r1_x_11, r1_y_12, r1_z_11, r1_w_5), cb2_values[46].xyzw));
                float4 r1_xyzw_12 = (r0_w_9.xxxx * _LightColor0.xyzx);
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_13 = r1_xyzw_12.y;
                float r1_z_12 = r1_xyzw_12.z;
                float r0_w_10 = dot(i.texcoord1.xyzx, unity_ProbeVolumeParams.xyzx);
                float r0_w_11 = max(r0_w_10, 0);
                float r0_w_12 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_13 = (-r0_w_12 + 1);
                float r0_w_14 = (r0_w_13 * cb1_values[5].z);
                float r0_w_15 = max(r0_w_14, 0);
                float r0_w_16 = saturate(mad(r0_w_15, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = ((((r0_w_11.xxxx * ((((((r0_xyzw_2.xyzx * i.color0.xyzx)).xyzx * r1_xyzw_1.xyzx)).xyzx * float4(r1_x_12, r1_y_13, r1_z_12, r1_x_12))).xyzx)).xyzx * r0_w_16.xxxx)).xyz;
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
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0;
                float4 _Color;
                float _Cutoff;
                float4 _MainTex_ST;
                float4 _LightMap_ST;
                float4 cb0_values[12];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[47];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_MainTex;
            SamplerState sampler_LightMap;
            Texture2D _MainTex;
            Texture2D _LightMap;
            Texture2D t2;
            Texture3D t3;
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
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program63Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program63Output
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
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord5.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord1.xxxy, cb0_values[11].xxxy, cb0_values[11].zzzw)).zw;
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                float3 clipPos_xyz_4 = ((worldPos_xyzw_4.yyyy * cb0_values[5].xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.zzzz, (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_4.xyzx)).xyzx)).xyz;
                o.texcoord3.xyz = (mad(_LightMap_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program63Output frag(program63Input i)
            {
                program63Output o = (program63Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + unity_ProbeVolumeParams.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_2 = (r1_xyzw_1 * cb0_values[8].xyzw);
                float4 r2_xyzw_1 = _LightMap.Sample(sampler_LightMap, (i.texcoord0.zwzz).xy);
                float r0_w_3 = mad(r1_xyzw_2.w, i.color0.w, -cb0_values[9].x);
                float r0_w_4 = (r0_w_3 < 0);
                if (r0_w_4) discard;
                float3 r2_xyz_5 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_5 = (cb4_values[0].x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_5)
                {
                    float r0_w_6 = (cb4_values[0].y == 1);
                    float3 r3_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord2.zzzz, (mad(cb4_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r3_xyzw_8 = (((((r0_w_6.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_7 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_3 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_7, r1_w_3);
                    float4 r3_xyzw_9 = t3.Sample(sampler_linear_clamp, (float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8)).xyz);
                    r3_x_10 = r3_xyzw_9.x;
                    r3_y_10 = r3_xyzw_9.y;
                    r3_z_10 = r3_xyzw_9.z;
                    r3_w_4 = r3_xyzw_9.w;
                }
                else
                {
                    float4 r3_xyzw_10 = float4(1, 1, 1, 1);
                    r3_x_10 = r3_xyzw_10.x;
                    r3_y_10 = r3_xyzw_10.y;
                    r3_z_10 = r3_xyzw_10.z;
                    r3_w_4 = r3_xyzw_10.w;
                }
                float r0_w_9 = saturate(dot(float4(r3_x_10, r3_y_10, r3_z_10, r3_w_4), cb2_values[46].xyzw));
                float r1_w_5 = dot(r2_xyz_5.xyzx, r2_xyz_5.xyzx);
                float4 r2_xyzw_6 = t2.Sample(sampler_linear_clamp1, (r1_w_5.xxxx).xy);
                float r0_w_10 = (r0_w_9 * r2_xyzw_6.x);
                float4 r0_xyzw_3 = (((((r1_xyzw_2.xyzx * i.color0.xyzx)).xyzx * r2_xyzw_1.xyzx)).xxyz * ((r0_w_10.xxxx * _LightColor0.xyzx)).xxyz);
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_11 = r0_xyzw_3.w;
                float4 r0_xyzw_5 = ((max(dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_11, r0_y_3));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float r0_w_12 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_13 = (-r0_w_12 + 1);
                float r0_w_14 = (r0_w_13 * cb1_values[5].z);
                float r0_w_15 = max(r0_w_14, 0);
                float r0_w_16 = saturate(mad(r0_w_15, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5) * r0_w_16.xxxx)).xyz;
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
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0;
                float4 _Color;
                float _Cutoff;
                float4 _MainTex_ST;
                float4 _LightMap_ST;
                float4 cb0_values[12];
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
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_MainTex;
            SamplerState sampler_LightMap;
            Texture2D _MainTex;
            Texture2D _LightMap;
            Texture2D t2;
            Texture3D t3;
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
                float4 color0 : COLOR0;
                float2 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program62Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float2 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program62Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program44Output vert(program44Input i)
            {
                program44Output o = (program44Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord1.xxxy, cb0_values[11].xxxy, cb0_values[11].zzzw)).zw;
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                float2 clipPos_xy_3 = ((worldPos_xyzw_4.yyyy * cb0_values[5].xyxx)).xy;
                float2 clipPos_xy_5 = (mad(_Color.xyxx, worldPos_xyzw_4.xxxx, clipPos_xy_3.xyxx)).xy;
                float2 clipPos_xy_6 = (mad(_MainTex_ST.xyxx, worldPos_xyzw_4.zzzz, clipPos_xy_5.xyxx)).xy;
                o.texcoord3.xy = (mad(_LightMap_ST.xyxx, worldPos_xyzw_4.wwww, clipPos_xy_6.xyxx)).xy;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program62Output frag(program62Input i)
            {
                program62Output o = (program62Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r0_xyzw_2 = (r0_xyzw_1 * cb0_values[8].xyzw);
                float4 r1_xyzw_1 = _LightMap.Sample(sampler_LightMap, (i.texcoord0.zwzz).xy);
                float r0_w_3 = mad(r0_xyzw_2.w, i.color0.w, -cb0_values[9].x);
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
                    float r1_z_2 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r2_x_8 = max(r0_w_7, r1_z_2);
                    float4 r2_xyzw_9 = t3.Sample(sampler_linear_clamp, (float4(r2_x_8, r2_z_8, r2_w_2, r2_x_8)).xyz);
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
                float4 r1_xyzw_6 = t2.Sample(sampler_linear_clamp1, ((((mad(cb0_values[6].xyxx, i.texcoord2.zzzz, (mad(cb0_values[4].xyxx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx).xy);
                float r0_w_10 = (r0_w_9 * r1_xyzw_6.w);
                float4 r1_xyzw_7 = (r0_w_10.xxxx * _LightColor0.xyzx);
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_7 = r1_xyzw_7.y;
                float r1_z_5 = r1_xyzw_7.z;
                float r0_w_11 = dot(i.texcoord1.xyzx, unity_ObjectToWorld[0].xyzx);
                float r0_w_12 = max(r0_w_11, 0);
                o.sv_Target0.xyz = ((r0_w_12.xxxx * ((((((r0_xyzw_2.xyzx * i.color0.xyzx)).xyzx * r1_xyzw_1.xyzx)).xyzx * float4(r1_x_7, r1_y_7, r1_z_5, r1_x_7))).xyzx)).xyz;
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
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0;
                float4 _Color;
                float _Cutoff;
                float4 _MainTex_ST;
                float4 _LightMap_ST;
                float4 cb0_values[12];
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
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            SamplerState sampler_LightMap;
            Texture2D _MainTex;
            Texture2D _LightMap;
            Texture2D t2;
            TextureCube t3;
            Texture3D t4;
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
                float4 color0 : COLOR0;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program61Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
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
            program43Output vert(program43Input i)
            {
                program43Output o = (program43Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord1.xxxy, cb0_values[11].xxxy, cb0_values[11].zzzw)).zw;
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                float3 clipPos_xyz_3 = ((worldPos_xyzw_4.yyyy * cb0_values[5].xyzx)).xyz;
                float3 clipPos_xyz_4 = (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_3.xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.zzzz, clipPos_xyz_4.xyzx)).xyz;
                o.texcoord3.xyz = (mad(_LightMap_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
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
                float4 r1_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_2 = (r1_xyzw_1 * cb0_values[8].xyzw);
                float4 r2_xyzw_1 = _LightMap.Sample(sampler_LightMap, (i.texcoord0.zwzz).xy);
                float r0_w_3 = mad(r1_xyzw_2.w, i.color0.w, -cb0_values[9].x);
                float r0_w_4 = (r0_w_3 < 0);
                if (r0_w_4) discard;
                float3 r2_xyz_5 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_5 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_5)
                {
                    float r0_w_6 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_6.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_7 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_3 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_7, r1_w_3);
                    float4 r3_xyzw_9 = t4.Sample(sampler_linear_clamp, (float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8)).xyz);
                    r3_x_10 = r3_xyzw_9.x;
                    r3_y_10 = r3_xyzw_9.y;
                    r3_z_10 = r3_xyzw_9.z;
                    r3_w_4 = r3_xyzw_9.w;
                }
                else
                {
                    float4 r3_xyzw_10 = float4(1, 1, 1, 1);
                    r3_x_10 = r3_xyzw_10.x;
                    r3_y_10 = r3_xyzw_10.y;
                    r3_z_10 = r3_xyzw_10.z;
                    r3_w_4 = r3_xyzw_10.w;
                }
                float r0_w_9 = saturate(dot(float4(r3_x_10, r3_y_10, r3_z_10, r3_w_4), unity_OcclusionMaskSelector));
                float r1_w_5 = dot(r2_xyz_5.xyzx, r2_xyz_5.xyzx);
                float4 r3_xyzw_11 = t2.Sample(sampler_linear_clamp2, (r1_w_5.xxxx).xy);
                float4 r2_xyzw_6 = t3.Sample(sampler_linear_clamp1, r2_xyz_5.xyz);
                float r1_w_6 = (r2_xyzw_6.w * r3_xyzw_11.x);
                float r0_w_10 = (r0_w_9 * r1_w_6);
                float4 r0_xyzw_3 = (((((r1_xyzw_2.xyzx * i.color0.xyzx)).xyzx * r2_xyzw_1.xyzx)).xxyz * ((r0_w_10.xxxx * _LightColor0.xyzx)).xxyz);
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_11 = r0_xyzw_3.w;
                o.sv_Target0.xyz = (((max(dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_11, r0_y_3))).xyz;
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
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0;
                float4 _Color;
                float _Cutoff;
                float4 _MainTex_ST;
                float4 _LightMap_ST;
                float4 cb0_values[12];
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
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_MainTex;
            SamplerState sampler_LightMap;
            Texture2D _MainTex;
            Texture2D _LightMap;
            Texture2D t2;
            Texture2D t3;
            Texture3D t4;
            struct program42Input
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
            struct program42Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program60Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program60Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program42Output vert(program42Input i)
            {
                program42Output o = (program42Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord1.xxxy, cb0_values[11].xxxy, cb0_values[11].zzzw)).zw;
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                float clipPos_x_3 = ((worldPos_xyzw_4.yyyy * cb0_values[5].xyzw)).x;
                float clipPos_y_3 = ((worldPos_xyzw_4.yyyy * cb0_values[5].xyzw)).y;
                float clipPos_z_3 = ((worldPos_xyzw_4.yyyy * cb0_values[5].xyzw)).z;
                float clipPos_w_4 = ((worldPos_xyzw_4.yyyy * cb0_values[5].xyzw)).w;
                float4 clipPos_xyzw_4 = mad(_Color, worldPos_xyzw_4.xxxx, float4(clipPos_x_3, clipPos_y_3, clipPos_z_3, clipPos_w_4));
                float4 clipPos_xyzw_5 = mad(_MainTex_ST, worldPos_xyzw_4.zzzz, clipPos_xyzw_4);
                o.texcoord3.xyzw = mad(_LightMap_ST, worldPos_xyzw_4.wwww, clipPos_xyzw_5);
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
                float4 r1_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_2 = (r1_xyzw_1 * cb0_values[8].xyzw);
                float4 r2_xyzw_1 = _LightMap.Sample(sampler_LightMap, (i.texcoord0.zwzz).xy);
                float r0_w_3 = mad(r1_xyzw_2.w, i.color0.w, -cb0_values[9].x);
                float r0_w_4 = (r0_w_3 < 0);
                if (r0_w_4) discard;
                float4 r2_xyzw_5 = (mad(cb0_values[6].xyzw, i.texcoord2.zzzz, mad(cb0_values[4].xyzw, i.texcoord2.xxxx, (i.texcoord2.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r0_w_5 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_5)
                {
                    float r0_w_6 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_6.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_7 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_3 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_7, r1_w_3);
                    float4 r3_xyzw_9 = t4.Sample(sampler_linear_clamp, (float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8)).xyz);
                    r3_x_10 = r3_xyzw_9.x;
                    r3_y_10 = r3_xyzw_9.y;
                    r3_z_10 = r3_xyzw_9.z;
                    r3_w_4 = r3_xyzw_9.w;
                }
                else
                {
                    float4 r3_xyzw_10 = float4(1, 1, 1, 1);
                    r3_x_10 = r3_xyzw_10.x;
                    r3_y_10 = r3_xyzw_10.y;
                    r3_z_10 = r3_xyzw_10.z;
                    r3_w_4 = r3_xyzw_10.w;
                }
                float r0_w_9 = saturate(dot(float4(r3_x_10, r3_y_10, r3_z_10, r3_w_4), unity_OcclusionMaskSelector));
                float r1_w_5 = (0 < r2_xyzw_5.z);
                float r1_w_6 = asfloat(asint(r1_w_5) & asint(1065353216));
                float4 r3_xyzw_13 = t2.Sample(sampler_linear_clamp1, (((((r2_xyzw_5.xyxx / r2_xyzw_5.wwww)).xyxx + float4(0.5, 0.5, 0, 0))).xyxx).xy);
                float r1_w_7 = (r1_w_6 * r3_xyzw_13.w);
                float4 r2_xyzw_7 = t3.Sample(sampler_linear_clamp2, ((dot(r2_xyzw_5.xyzx, r2_xyzw_5.xyzx)).xxxx).xy);
                float r1_w_8 = (r1_w_7 * r2_xyzw_7.x);
                float r0_w_10 = (r0_w_9 * r1_w_8);
                float4 r2_xyzw_8 = (r0_w_10.xxxx * _LightColor0.xyzx);
                float r2_x_8 = r2_xyzw_8.x;
                float r2_y_7 = r2_xyzw_8.y;
                float r2_z_7 = r2_xyzw_8.z;
                float4 r0_xyzw_3 = (((((r1_xyzw_2.xyzx * i.color0.xyzx)).xyzx * r2_xyzw_1.xyzx)).xxyz * float4(r2_x_8, r2_x_8, r2_y_7, r2_z_7));
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_11 = r0_xyzw_3.w;
                o.sv_Target0.xyz = (((max(dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_11, r0_y_3))).xyz;
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
            HLSLPROGRAM
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
