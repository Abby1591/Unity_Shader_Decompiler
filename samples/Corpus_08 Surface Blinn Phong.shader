Shader "Corpus/08 Surface Blinn Phong"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo", 2D) = "" {}
        _BumpMap ("Normal", 2D) = "" {}
        _SpecColor ("Specular", Color) = (0.5,0.5,0.5,1)
        _Shininess ("Shininess", Range(0.01, 1)) = 0.078125
        _Gloss ("Gloss", Range(0, 1)) = 0.5
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
                float4 _SpecColor : packoffset(c3);
                float4 _Color : packoffset(c4);
                float _Shininess : packoffset(c5.x);
                float _Gloss : packoffset(c5.y);
                float4 _MainTex_ST : packoffset(c6);
                float4 _BumpMap_ST : packoffset(c7);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
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
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program30Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
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
                float3 worldPos_xyz_4 = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord1.w = worldPos_xyz_4.x;
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float3 unitWorldNormal_xyz_3 = (((rsqrt(dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2)))).xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = (((rsqrt(dot(worldTangent_xyz_6.xyzx, worldTangent_xyz_6.xyzx))).xxxx * worldTangent_xyz_6.xyzx)).xyz;
                float3 r3_xyz_3 = ((((i.tangent0.w * unity_WorldTransformParams.w)).xxxx * (mad(unitWorldNormal_xyz_3.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_3.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_3.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_3.z;
                o.texcoord3.z = unitWorldNormal_xyz_3.x;
                o.texcoord2.w = worldPos_xyz_4.y;
                o.texcoord3.w = worldPos_xyz_4.z;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program30Output frag(program30Input i)
            {
                program30Output o = (program30Output)0;
                float TEXCOORD1_y_1 = i.texcoord1.w;
                float TEXCOORD2_z_1 = i.texcoord2.w;
                float TEXCOORD3_w_1 = i.texcoord3.w;
                float3 viewDir_xyz_1 = ((-float4(TEXCOORD1_y_1, TEXCOORD2_z_1, TEXCOORD3_w_1, TEXCOORD1_y_1) + unity_WorldToObject[0].xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r3_x_2 = (r3_xyzw_1.w * r3_xyzw_1.x);
                float4 r3_xyzw_3 = mad(float4(r3_x_2, r3_xyzw_1.y, r3_x_2, r3_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r1_w_1 = dot(float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3), float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r3_z_2 = sqrt(r1_w_3);
                float r1_w_4 = (unity_ProbeVolumeParams.x == 1);
                float r4_x_8;
                float r4_y_8;
                float r4_z_8;
                float r4_w_4;
                if (r1_w_4)
                {
                    float r1_w_5 = (unity_ProbeVolumeParams.y == 1);
                    float3 r4_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord3.wwww, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.wwww, ((i.texcoord2.wwww * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_yzw_2 = ((r1_w_5.xxxx ? r4_xyz_5.xxyz : float4(TEXCOORD1_y_1, TEXCOORD1_y_1, TEXCOORD2_z_1, TEXCOORD3_w_1))).yzw;
                    float3 r0_yzw_3 = ((unity_ProbeVolumeParamsSelect_yzw_2.xxyz + -unity_ProbeVolumeMin.xxyz)).yzw;
                    float4 r4_xyzw_6 = (r0_yzw_3.xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r4_y_6 = r4_xyzw_6.y;
                    float r4_z_6 = r4_xyzw_6.z;
                    float r4_w_2 = r4_xyzw_6.w;
                    float r0_y_4 = mad(r4_y_6, 0.25, 0.75);
                    float r0_z_4 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r4_x_6 = max(r0_z_4, r0_y_4);
                    float4 r4_xyzw_7 = t2.Sample(sampler_linear_clamp, (float4(r4_x_6, r4_z_6, r4_w_2, r4_x_6)).xyz);
                    r4_x_8 = r4_xyzw_7.x;
                    r4_y_8 = r4_xyzw_7.y;
                    r4_z_8 = r4_xyzw_7.z;
                    r4_w_4 = r4_xyzw_7.w;
                }
                else
                {
                    float4 r4_xyzw_8 = float4(1, 1, 1, 1);
                    r4_x_8 = r4_xyzw_8.x;
                    r4_y_8 = r4_xyzw_8.y;
                    r4_z_8 = r4_xyzw_8.z;
                    r4_w_4 = r4_xyzw_8.w;
                }
                float r0_y_6 = saturate(dot(float4(r4_x_8, r4_y_8, r4_z_8, r4_w_4), unity_OcclusionMaskSelector));
                float r4_x_9 = dot(i.texcoord1.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_y_9 = dot(i.texcoord2.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_z_9 = dot(i.texcoord3.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r0_z_6 = dot(float4(r4_x_9, r4_y_9, r4_z_9, r4_x_9), float4(r4_x_9, r4_y_9, r4_z_9, r4_x_9));
                float r0_z_7 = rsqrt(r0_z_6);
                float4 r3_xyzw_4 = (r0_z_7.xxxx * float4(r4_x_9, r4_y_9, r4_z_9, r4_x_9));
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r3_z_3 = r3_xyzw_4.z;
                float4 r0_xyzw_7 = (r0_y_6.xxxx * _LightColor0.xxyz);
                float r0_y_7 = r0_xyzw_7.y;
                float r0_z_8 = r0_xyzw_7.z;
                float r0_w_5 = r0_xyzw_7.w;
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, (rsqrt(dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx))).xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r1_y_4 = (_Shininess * 128);
                                float r1_x_8 = pow(max(dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), (((rsqrt(dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx))).xxxx * r1_xyz_2.xyzx)).xyzx), 0), r1_y_4);
                float4 r1_xyzw_5 = (float4(r0_y_7, r0_y_7, r0_z_8, r0_w_5) * ((r2_xyzw_1.xyzx * _Color.xyzx)).xxyz);
                float r1_y_5 = r1_xyzw_5.y;
                float r1_z_4 = r1_xyzw_5.z;
                float r1_w_7 = r1_xyzw_5.w;
                float4 r0_xyzw_8 = (float4(r0_y_7, r0_y_7, r0_z_8, r0_w_5) * _SpecColor.xxyz);
                float r0_y_8 = r0_xyzw_8.y;
                float r0_z_9 = r0_xyzw_8.z;
                float r0_w_6 = r0_xyzw_8.w;
                float4 r0_xyzw_9 = (((r1_x_8 * _Gloss)).xxxx * float4(r0_y_8, r0_y_8, r0_z_9, r0_w_6));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_10 = r0_xyzw_9.z;
                float r0_w_7 = r0_xyzw_9.w;
                o.sv_Target0.xyz = (mad(float4(r1_y_5, r1_z_4, r1_w_7, r1_y_5), (max(dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), _WorldSpaceLightPos0.xyzx), 0)).xxxx, float4(r0_y_9, r0_z_10, r0_w_7, r0_y_9))).xyz;
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
                float4 _SpecColor : packoffset(c3);
                float4 _Color : packoffset(c4);
                float _Shininess : packoffset(c5.x);
                float _Gloss : packoffset(c5.y);
                float4 _MainTex_ST : packoffset(c6);
                float4 _BumpMap_ST : packoffset(c7);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
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
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program37Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
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
                float3 r0_xyz_4 = (mad(cb3_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb4_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb4_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb4_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb4_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb4_values[17], cb4_values[18], cb4_values[19], cb4_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord1.w = r0_xyz_4.x;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * cb3_values[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(cb3_values[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(cb3_values[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = (((rsqrt(dot(worldTangent_xyz_6.xyzx, worldTangent_xyz_6.xyzx))).xxxx * worldTangent_xyz_6.xyzx)).xyz;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                float worldNormal_x_1 = dot(i.normal0.xyzx, cb3_values[4].xyzx);
                float worldNormal_y_1 = dot(i.normal0.xyzx, cb3_values[5].xyzx);
                float worldNormal_z_1 = dot(i.normal0.xyzx, cb3_values[6].xyzx);
                float4 unitWorldNormal_xyzw_2 = ((rsqrt(dot(float4(worldNormal_x_1, worldNormal_y_1, worldNormal_z_1, worldNormal_x_1), float4(worldNormal_x_1, worldNormal_y_1, worldNormal_z_1, worldNormal_x_1)))).xxxx * float4(worldNormal_x_1, worldNormal_y_1, worldNormal_z_1, worldNormal_z_1));
                float3 r4_xyz_3 = ((((i.tangent0.w * cb3_values[9].w)).xxxx * (mad(unitWorldNormal_xyzw_2.ywxy, unitWorldTangent_xyz_7.yzxy, ((unitWorldTangent_xyz_7.xyzx * unitWorldNormal_xyzw_2.wxyw)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r4_xyz_3.x;
                o.texcoord1.z = unitWorldNormal_xyzw_2.x;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.w = r0_xyz_4.y;
                o.texcoord3.w = r0_xyz_4.z;
                o.texcoord2.y = r4_xyz_3.y;
                o.texcoord3.y = r4_xyz_3.z;
                o.texcoord2.z = unitWorldNormal_xyzw_2.y;
                o.texcoord3.z = unitWorldNormal_xyzw_2.w;
                float4 r2_xyzw_8 = (unitWorldNormal_xyzw_2.ywzx * unitWorldNormal_xyzw_2);
                float r3_x_3 = dot(cb2_values[42].xyzw, r2_xyzw_8);
                float r3_y_3 = dot(cb2_values[43].xyzw, r2_xyzw_8);
                float r3_z_3 = dot(cb2_values[44].xyzw, r2_xyzw_8);
                o.texcoord4.xyz = (mad(cb2_values[45].xyzx, (mad(unitWorldNormal_xyzw_2.x, unitWorldNormal_xyzw_2.x, (unitWorldNormal_xyzw_2.y * unitWorldNormal_xyzw_2.y))).xxxx, float4(r3_x_3, r3_y_3, r3_z_3, r3_x_3))).xyz;
                o.texcoord5.x = clipPos_xyzw_2.z;
                float r0_w_4 = ((clipPos_xyzw_2.y * unity_WorldToObject[1].x) * 0.5);
                float4 r0_xyzw_13 = (clipPos_xyzw_2.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_13 = r0_xyzw_13.x;
                float r0_z_5 = r0_xyzw_13.z;
                o.texcoord6.zw = (clipPos_xyzw_2.zzzw).zw;
                o.texcoord6.xy = ((r0_z_5.xxxx + float4(r0_x_13, r0_w_4, r0_x_13, r0_x_13))).xy;
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program37Output frag(program37Input i)
            {
                program37Output o = (program37Output)0;
                float TEXCOORD1_y_1 = i.texcoord1.w;
                float TEXCOORD2_z_1 = i.texcoord2.w;
                float TEXCOORD3_w_1 = i.texcoord3.w;
                float3 viewDir_xyz_1 = ((-float4(TEXCOORD1_y_1, TEXCOORD2_z_1, TEXCOORD3_w_1, TEXCOORD1_y_1) + unity_WorldToObject[0].xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_2 = ((r2_xyzw_1.xyzx * _Color.xyzx)).xyz;
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r3_x_2 = (r3_xyzw_1.w * r3_xyzw_1.x);
                float4 r3_xyzw_3 = mad(float4(r3_x_2, r3_xyzw_1.y, r3_x_2, r3_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r1_w_1 = dot(float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3), float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r3_z_2 = sqrt(r1_w_3);
                float r4_x_1 = cb4_values[9].z;
                float r4_y_1 = cb4_values[10].z;
                float r4_z_1 = cb4_values[11].z;
                float r1_w_4 = dot(viewDir_xyz_1.xyzx, float4(r4_x_1, r4_y_1, r4_z_1, r4_x_1));
                float3 r4_xyz_2 = ((float4(TEXCOORD1_y_1, TEXCOORD2_z_1, TEXCOORD3_w_1, TEXCOORD1_y_1) + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = dot(r4_xyz_2.xyzx, r4_xyz_2.xyzx);
                float r2_w_3 = sqrt(r2_w_2);
                float r2_w_4 = (-r1_w_4 + r2_w_3);
                float r1_w_5 = mad(cb3_values[25].w, r2_w_4, r1_w_4);
                float r1_w_6 = saturate(mad(r1_w_5, cb3_values[24].z, cb3_values[24].w));
                float r2_w_5 = (cb6_values[0].x == 1);
                float r4_x_12;
                float r4_y_13;
                float r4_z_12;
                float r4_w_4;
                if (r2_w_5)
                {
                    float r3_w_2 = (cb6_values[0].y == 1);
                    float3 r4_xyz_7 = (((mad(cb6_values[3].xyzx, i.texcoord3.wwww, (mad(cb6_values[1].xyzx, i.texcoord1.wwww, ((i.texcoord2.wwww * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r4_xyzw_10 = (((((r3_w_2.xxxx ? r4_xyz_7.xyzx : float4(TEXCOORD1_y_1, TEXCOORD2_z_1, TEXCOORD3_w_1, TEXCOORD1_y_1))).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r4_y_10 = r4_xyzw_10.y;
                    float r4_z_10 = r4_xyzw_10.z;
                    float r4_w_2 = r4_xyzw_10.w;
                    float r3_w_3 = mad(r4_y_10, 0.25, 0.75);
                    float r4_y_11 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r4_x_10 = max(r3_w_3, r4_y_11);
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
                float r3_w_5 = saturate(dot(float4(r4_x_12, r4_y_13, r4_z_12, r4_w_4), unity_OcclusionMaskSelector));
                float4 r4_xyzw_13 = (i.texcoord6.xyxx / i.texcoord6.wwww);
                float r4_x_13 = r4_xyzw_13.x;
                float r4_y_14 = r4_xyzw_13.y;
                float4 r4_xyzw_14 = t2.Sample(sampler_linear_clamp1, (float4(r4_x_13, r4_y_14, r4_x_13, r4_x_13)).xy);
                float r3_w_6 = (r3_w_5 + -r4_xyzw_14.x);
                float r1_w_7 = mad(r1_w_6, r3_w_6, r4_xyzw_14.x);
                float r4_x_15 = dot(i.texcoord1.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_y_16 = dot(i.texcoord2.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_z_14 = dot(i.texcoord3.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float4 r3_xyzw_6 = ((rsqrt(dot(float4(r4_x_15, r4_y_16, r4_z_14, r4_x_15), float4(r4_x_15, r4_y_16, r4_z_14, r4_x_15)))).xxxx * float4(r4_x_15, r4_y_16, r4_z_14, r4_x_15));
                float r3_x_6 = r3_xyzw_6.x;
                float r3_y_3 = r3_xyzw_6.y;
                float r3_z_3 = r3_xyzw_6.z;
                float4 r4_xyzw_16 = (r1_w_7.xxxx * _LightColor0.xyzx);
                float r4_x_16 = r4_xyzw_16.x;
                float r4_y_17 = r4_xyzw_16.y;
                float r4_z_15 = r4_xyzw_16.z;
                float3 r6_xyz_4;
                if (r2_w_5)
                {
                    float r1_w_8 = (cb6_values[0].y == 1);
                    float3 r5_xyz_4 = (((mad(cb6_values[3].xyzx, i.texcoord3.wwww, (mad(cb6_values[1].xyzx, i.texcoord1.wwww, ((i.texcoord2.wwww * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float3 r0_yzw_2 = ((r1_w_8.xxxx ? r5_xyz_4.xxyz : float4(TEXCOORD1_y_1, TEXCOORD1_y_1, TEXCOORD2_z_1, TEXCOORD3_w_1))).yzw;
                    float3 r0_yzw_3 = ((r0_yzw_2.xxyz + -cb6_values[6].xxyz)).yzw;
                    float4 r5_xyzw_5 = (r0_yzw_3.xxyz * cb6_values[5].xxyz);
                    float r5_y_5 = r5_xyzw_5.y;
                    float r5_z_5 = r5_xyzw_5.z;
                    float r5_w_1 = r5_xyzw_5.w;
                    float r0_y_4 = (r5_y_5 * 0.25);
                    float r0_z_4 = (cb6_values[0].z * 0.5);
                    float r0_w_4 = mad(-cb6_values[0].z, 0.5, 0.25);
                    float r0_y_5 = max(r0_z_4, r0_y_4);
                    float r5_x_5 = min(r0_w_4, r0_y_5);
                    float4 r6_xyzw_2 = t3.Sample(sampler_linear_clamp, (float4(r5_x_5, r5_z_5, r5_w_1, r5_x_5)).xyz);
                    float4 r0_xyzw_6 = (float4(r5_x_5, r5_x_5, r5_z_5, r5_w_1) + float4(0, 0.25, 0, 0));
                    float r0_y_6 = r0_xyzw_6.y;
                    float r0_z_5 = r0_xyzw_6.z;
                    float r0_w_5 = r0_xyzw_6.w;
                    float4 r7_xyzw_1 = t3.Sample(sampler_linear_clamp, (float4(r0_y_6, r0_z_5, r0_w_5, r0_y_6)).xyz);
                    float4 r0_xyzw_7 = (float4(r5_x_5, r5_x_5, r5_z_5, r5_w_1) + float4(0, 0.5, 0, 0));
                    float r0_y_7 = r0_xyzw_7.y;
                    float r0_z_6 = r0_xyzw_7.z;
                    float r0_w_6 = r0_xyzw_7.w;
                    float4 r5_xyzw_6 = t3.Sample(sampler_linear_clamp, (float4(r0_y_7, r0_z_6, r0_w_6, r0_y_7)).xyz);
                    float r3_w_8 = 1;
                    float r6_x_3 = dot(r6_xyzw_2, float4(r3_x_6, r3_y_3, r3_z_3, r3_w_8));
                    float r6_y_3 = dot(r7_xyzw_1, float4(r3_x_6, r3_y_3, r3_z_3, r3_w_8));
                    float r6_z_3 = dot(r5_xyzw_6, float4(r3_x_6, r3_y_3, r3_z_3, r3_w_8));
                    r6_xyz_4 = float3(r6_x_3, r6_y_3, r6_z_3);
                }
                else
                {
                    float r3_w_7 = 1;
                    float r6_x_1 = dot(cb2_values[39].xyzw, float4(r3_x_6, r3_y_3, r3_z_3, r3_w_7));
                    float r6_y_1 = dot(cb2_values[40].xyzw, float4(r3_x_6, r3_y_3, r3_z_3, r3_w_7));
                    float r6_z_1 = dot(cb2_values[41].xyzw, float4(r3_x_6, r3_y_3, r3_z_3, r3_w_7));
                    r6_xyz_4 = float3(r6_x_1, r6_y_1, r6_z_1);
                }
                float4 r0_xyzw_9 = (r6_xyz_4.xxyz + i.texcoord4.xxyz);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_8 = r0_xyzw_9.z;
                float r0_w_8 = r0_xyzw_9.w;
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, (rsqrt(dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx))).xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_x_5 = dot(float4(r3_x_6, r3_y_3, r3_z_3, r3_x_6), _WorldSpaceLightPos0.xyzx);
                float r0_x_6 = (max(float4(r0_x_5, r0_y_9, r0_z_8, r0_w_8), float4(0, 0, 0, 0))).x;
                float4 r0_xyzw_10 = max(float4(r0_x_5, r0_y_9, r0_z_8, r0_w_8), float4(0, 0, 0, 0));
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_9 = r0_xyzw_10.z;
                float r0_w_9 = r0_xyzw_10.w;
                float r1_y_4 = (_Shininess * 128);
                                float r1_x_8 = pow(max(dot(float4(r3_x_6, r3_y_3, r3_z_3, r3_x_6), (((rsqrt(dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx))).xxxx * r1_xyz_2.xyzx)).xyzx), 0), r1_y_4);
                float4 r1_xyzw_5 = (r2_xyz_2.xxyz * float4(r4_x_16, r4_x_16, r4_y_17, r4_z_15));
                float r1_y_5 = r1_xyzw_5.y;
                float r1_z_4 = r1_xyzw_5.z;
                float r1_w_10 = r1_xyzw_5.w;
                float4 r3_xyzw_7 = (float4(r4_x_16, r4_y_17, r4_z_15, r4_x_16) * _SpecColor.xyzx);
                float r3_x_7 = r3_xyzw_7.x;
                float r3_y_4 = r3_xyzw_7.y;
                float r3_z_4 = r3_xyzw_7.z;
                float4 r3_xyzw_8 = (((r1_x_8 * _Gloss)).xxxx * float4(r3_x_7, r3_y_4, r3_z_4, r3_x_7));
                float r3_x_8 = r3_xyzw_8.x;
                float r3_y_5 = r3_xyzw_8.y;
                float r3_z_5 = r3_xyzw_8.z;
                float4 r1_xyzw_10 = mad(float4(r1_y_5, r1_z_4, r1_w_10, r1_y_5), r0_x_6.xxxx, float4(r3_x_8, r3_y_5, r3_z_5, r3_x_8));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_6 = r1_xyzw_10.y;
                float r1_z_5 = r1_xyzw_10.z;
                float r0_x_7 = (mad(r2_xyz_2.xyzx, float4(r0_y_10, r0_z_9, r0_w_9, r0_y_10), float4(r1_x_10, r1_y_6, r1_z_5, r1_x_10))).x;
                float4 r0_xyzw_11 = mad(r2_xyz_2.xyzx, float4(r0_y_10, r0_z_9, r0_w_9, r0_y_10), float4(r1_x_10, r1_y_6, r1_z_5, r1_x_10));
                float r0_y_11 = r0_xyzw_11.y;
                float r0_z_10 = r0_xyzw_11.z;
                float r0_w_10 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_11 = (-r0_w_10 + 1);
                float r0_w_12 = (r0_w_11 * cb1_values[5].z);
                float r0_w_13 = max(r0_w_12, 0);
                float r0_w_14 = saturate(mad(r0_w_13, cb5_values[1].z, cb5_values[1].w));
                float4 r0_xyzw_8 = (float4(r0_x_7, r0_y_11, r0_z_10, r0_x_7) + -cb5_values[0].xyzx);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_11 = r0_xyzw_8.z;
                o.sv_Target0.xyz = (mad(r0_w_14.xxxx, float4(r0_x_8, r0_y_12, r0_z_11, r0_x_8), cb5_values[0].xyzx)).xyz;
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
                float4 _SpecColor : packoffset(c3);
                float4 _Color : packoffset(c4);
                float _Shininess : packoffset(c5.x);
                float _Gloss : packoffset(c5.y);
                float4 _MainTex_ST : packoffset(c6);
                float4 _BumpMap_ST : packoffset(c7);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[10];
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
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program36Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
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
                float3 r0_xyz_4 = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord1.w = r0_xyz_4.x;
                float r2_y_4 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float r2_z_4 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float r2_x_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float3 unitWorldNormal_xyz_5 = (((rsqrt(dot(float4(r2_x_4, r2_y_4, r2_z_4, r2_x_4), float4(r2_x_4, r2_y_4, r2_z_4, r2_x_4)))).xxxx * float4(r2_x_4, r2_y_4, r2_z_4, r2_x_4))).xyz;
                float3 worldTangent_xyz_1 = ((i.tangent0.yyyy * cb2_values[1].yzxy)).xyz;
                float3 worldTangent_xyz_2 = (mad(cb2_values[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_1.xyzx)).xyz;
                float3 worldTangent_xyz_3 = (mad(cb2_values[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_2.xyzx)).xyz;
                float3 unitWorldTangent_xyz_4 = (((rsqrt(dot(worldTangent_xyz_3.xyzx, worldTangent_xyz_3.xyzx))).xxxx * worldTangent_xyz_3.xyzx)).xyz;
                float3 r4_xyz_3 = ((((i.tangent0.w * cb2_values[9].w)).xxxx * (mad(unitWorldNormal_xyz_5.zxyz, unitWorldTangent_xyz_4.yzxy, ((unitWorldNormal_xyz_5.xyzx * unitWorldTangent_xyz_4.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r4_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_4.z;
                o.texcoord1.z = unitWorldNormal_xyz_5.y;
                o.texcoord2.x = unitWorldTangent_xyz_4.x;
                o.texcoord3.x = unitWorldTangent_xyz_4.y;
                o.texcoord2.z = unitWorldNormal_xyz_5.z;
                o.texcoord3.z = unitWorldNormal_xyz_5.x;
                o.texcoord2.w = r0_xyz_4.y;
                o.texcoord3.w = r0_xyz_4.z;
                o.texcoord2.y = r4_xyz_3.y;
                o.texcoord3.y = r4_xyz_3.z;
                o.texcoord5.x = clipPos_xyzw_2.z;
                float r0_w_4 = ((clipPos_xyzw_2.y * unity_WorldToObject[1].x) * 0.5);
                float4 r0_xyzw_11 = (clipPos_xyzw_2.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_z_5 = r0_xyzw_11.z;
                o.texcoord6.zw = (clipPos_xyzw_2.zzzw).zw;
                o.texcoord6.xy = ((r0_z_5.xxxx + float4(r0_x_11, r0_w_4, r0_x_11, r0_x_11))).xy;
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program36Output frag(program36Input i)
            {
                program36Output o = (program36Output)0;
                float TEXCOORD1_y_1 = i.texcoord1.w;
                float TEXCOORD2_z_1 = i.texcoord2.w;
                float TEXCOORD3_w_1 = i.texcoord3.w;
                float3 viewDir_xyz_1 = ((-float4(TEXCOORD1_y_1, TEXCOORD2_z_1, TEXCOORD3_w_1, TEXCOORD1_y_1) + unity_WorldToObject[0].xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r3_x_2 = (r3_xyzw_1.w * r3_xyzw_1.x);
                float4 r3_xyzw_3 = mad(float4(r3_x_2, r3_xyzw_1.y, r3_x_2, r3_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r1_w_1 = dot(float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3), float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r3_z_2 = sqrt(r1_w_3);
                float r4_x_1 = cb4_values[9].z;
                float r4_y_1 = cb4_values[10].z;
                float r4_z_1 = cb4_values[11].z;
                float r1_w_4 = dot(viewDir_xyz_1.xyzx, float4(r4_x_1, r4_y_1, r4_z_1, r4_x_1));
                float3 r4_xyz_2 = ((float4(TEXCOORD1_y_1, TEXCOORD2_z_1, TEXCOORD3_w_1, TEXCOORD1_y_1) + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = dot(r4_xyz_2.xyzx, r4_xyz_2.xyzx);
                float r2_w_3 = sqrt(r2_w_2);
                float r2_w_4 = (-r1_w_4 + r2_w_3);
                float r1_w_5 = mad(cb3_values[25].w, r2_w_4, r1_w_4);
                float r1_w_6 = saturate(mad(r1_w_5, cb3_values[24].z, cb3_values[24].w));
                float r2_w_5 = (cb6_values[0].x == 1);
                float r4_x_10;
                float r4_y_10;
                float r4_z_10;
                float r4_w_4;
                if (r2_w_5)
                {
                    float r2_w_6 = (cb6_values[0].y == 1);
                    float3 r4_xyz_7 = (((mad(cb6_values[3].xyzx, i.texcoord3.wwww, (mad(cb6_values[1].xyzx, i.texcoord1.wwww, ((i.texcoord2.wwww * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float3 r0_yzw_2 = ((r2_w_6.xxxx ? r4_xyz_7.xxyz : float4(TEXCOORD1_y_1, TEXCOORD1_y_1, TEXCOORD2_z_1, TEXCOORD3_w_1))).yzw;
                    float3 r0_yzw_3 = ((r0_yzw_2.xxyz + -cb6_values[6].xxyz)).yzw;
                    float4 r4_xyzw_8 = (r0_yzw_3.xxyz * cb6_values[5].xxyz);
                    float r4_y_8 = r4_xyzw_8.y;
                    float r4_z_8 = r4_xyzw_8.z;
                    float r4_w_2 = r4_xyzw_8.w;
                    float r0_y_4 = mad(r4_y_8, 0.25, 0.75);
                    float r0_z_4 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r4_x_8 = max(r0_z_4, r0_y_4);
                    float4 r4_xyzw_9 = t3.Sample(sampler_linear_clamp, (float4(r4_x_8, r4_z_8, r4_w_2, r4_x_8)).xyz);
                    r4_x_10 = r4_xyzw_9.x;
                    r4_y_10 = r4_xyzw_9.y;
                    r4_z_10 = r4_xyzw_9.z;
                    r4_w_4 = r4_xyzw_9.w;
                }
                else
                {
                    float4 r4_xyzw_3 = float4(1, 1, 1, 1);
                    r4_x_10 = r4_xyzw_3.x;
                    r4_y_10 = r4_xyzw_3.y;
                    r4_z_10 = r4_xyzw_3.z;
                    r4_w_4 = r4_xyzw_3.w;
                }
                float r0_y_6 = saturate(dot(float4(r4_x_10, r4_y_10, r4_z_10, r4_w_4), unity_OcclusionMaskSelector));
                float4 r0_xyzw_6 = (i.texcoord6.xxxy / i.texcoord6.wwww);
                float r0_z_6 = r0_xyzw_6.z;
                float r0_w_5 = r0_xyzw_6.w;
                float4 r4_xyzw_11 = t2.Sample(sampler_linear_clamp1, (float4(r0_z_6, r0_w_5, r0_z_6, r0_z_6)).xy);
                float r0_y_7 = (r0_y_6 + -r4_xyzw_11.x);
                float r0_y_8 = mad(r1_w_6, r0_y_7, r4_xyzw_11.x);
                float r4_x_12 = dot(i.texcoord1.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_y_12 = dot(i.texcoord2.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_z_12 = dot(i.texcoord3.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r0_z_7 = dot(float4(r4_x_12, r4_y_12, r4_z_12, r4_x_12), float4(r4_x_12, r4_y_12, r4_z_12, r4_x_12));
                float r0_z_8 = rsqrt(r0_z_7);
                float4 r3_xyzw_4 = (r0_z_8.xxxx * float4(r4_x_12, r4_y_12, r4_z_12, r4_x_12));
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r3_z_3 = r3_xyzw_4.z;
                float4 r0_xyzw_9 = (r0_y_8.xxxx * _LightColor0.xxyz);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_9 = r0_xyzw_9.z;
                float r0_w_6 = r0_xyzw_9.w;
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, (rsqrt(dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx))).xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r1_y_4 = (_Shininess * 128);
                                float r1_x_8 = pow(max(dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), (((rsqrt(dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx))).xxxx * r1_xyz_2.xyzx)).xyzx), 0), r1_y_4);
                float4 r1_xyzw_5 = (float4(r0_y_9, r0_y_9, r0_z_9, r0_w_6) * ((r2_xyzw_1.xyzx * _Color.xyzx)).xxyz);
                float r1_y_5 = r1_xyzw_5.y;
                float r1_z_4 = r1_xyzw_5.z;
                float r1_w_7 = r1_xyzw_5.w;
                float4 r0_xyzw_10 = (float4(r0_y_9, r0_y_9, r0_z_9, r0_w_6) * _SpecColor.xxyz);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_10 = r0_xyzw_10.z;
                float r0_w_7 = r0_xyzw_10.w;
                float4 r0_xyzw_11 = (((r1_x_8 * _Gloss)).xxxx * float4(r0_y_10, r0_y_10, r0_z_10, r0_w_7));
                float r0_y_11 = r0_xyzw_11.y;
                float r0_z_11 = r0_xyzw_11.z;
                float r0_w_8 = r0_xyzw_11.w;
                float4 r0_xyzw_7 = mad(float4(r1_y_5, r1_z_4, r1_w_7, r1_y_5), (max(dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), _WorldSpaceLightPos0.xyzx), 0)).xxxx, float4(r0_y_11, r0_z_11, r0_w_8, r0_y_11));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_12 = r0_xyzw_7.y;
                float r0_z_12 = r0_xyzw_7.z;
                float r0_w_9 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_10 = (-r0_w_9 + 1);
                float r0_w_11 = (r0_w_10 * cb1_values[5].z);
                float r0_w_12 = max(r0_w_11, 0);
                float r0_w_13 = saturate(mad(r0_w_12, cb5_values[1].z, cb5_values[1].w));
                float4 r0_xyzw_8 = (float4(r0_x_7, r0_y_12, r0_z_12, r0_x_7) + -cb5_values[0].xyzx);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_13 = r0_xyzw_8.y;
                float r0_z_13 = r0_xyzw_8.z;
                o.sv_Target0.xyz = (mad(r0_w_13.xxxx, float4(r0_x_8, r0_y_13, r0_z_13, r0_x_8), cb5_values[0].xyzx)).xyz;
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
                float4 _SpecColor : packoffset(c3);
                float4 _Color : packoffset(c4);
                float _Shininess : packoffset(c5.x);
                float _Gloss : packoffset(c5.y);
                float4 _MainTex_ST : packoffset(c6);
                float4 _BumpMap_ST : packoffset(c7);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
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
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb3_values[21];
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[7];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_MainTex;
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program35Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
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
                float3 r0_xyz_4 = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord5.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord1.w = r0_xyz_4.x;
                float3 worldTangent_xyz_3 = ((i.tangent0.yyyy * cb2_values[1].yzxy)).xyz;
                float3 worldTangent_xyz_4 = (mad(cb2_values[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_3.xyzx)).xyz;
                float3 worldTangent_xyz_5 = (mad(cb2_values[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_4.xyzx)).xyz;
                float3 unitWorldTangent_xyz_6 = (((rsqrt(dot(worldTangent_xyz_5.xyzx, worldTangent_xyz_5.xyzx))).xxxx * worldTangent_xyz_5.xyzx)).xyz;
                o.texcoord1.x = unitWorldTangent_xyz_6.z;
                float worldNormal_x_4 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float4 unitWorldNormal_xyzw_5 = ((rsqrt(dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4)))).xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_z_4));
                float3 r3_xyz_3 = ((((i.tangent0.w * cb2_values[9].w)).xxxx * (mad(unitWorldNormal_xyzw_5.ywxy, unitWorldTangent_xyz_6.yzxy, ((unitWorldTangent_xyz_6.xyzx * unitWorldNormal_xyzw_5.wxyw)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.z = unitWorldNormal_xyzw_5.x;
                o.texcoord2.x = unitWorldTangent_xyz_6.x;
                o.texcoord3.x = unitWorldTangent_xyz_6.y;
                o.texcoord2.w = r0_xyz_4.y;
                o.texcoord3.w = r0_xyz_4.z;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord2.z = unitWorldNormal_xyzw_5.y;
                o.texcoord3.z = unitWorldNormal_xyzw_5.w;
                float4 r1_xyzw_7 = (unitWorldNormal_xyzw_5.ywzx * unitWorldNormal_xyzw_5);
                float r2_x_6 = dot(cb1_values[42].xyzw, r1_xyzw_7);
                float r2_y_6 = dot(cb1_values[43].xyzw, r1_xyzw_7);
                float r2_z_6 = dot(cb1_values[44].xyzw, r1_xyzw_7);
                o.texcoord4.xyz = (mad(cb1_values[45].xyzx, (mad(unitWorldNormal_xyzw_5.x, unitWorldNormal_xyzw_5.x, (unitWorldNormal_xyzw_5.y * unitWorldNormal_xyzw_5.y))).xxxx, float4(r2_x_6, r2_y_6, r2_z_6, r2_x_6))).xyz;
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program35Output frag(program35Input i)
            {
                program35Output o = (program35Output)0;
                float TEXCOORD1_y_1 = i.texcoord1.w;
                float TEXCOORD2_z_1 = i.texcoord2.w;
                float TEXCOORD3_w_1 = i.texcoord3.w;
                float3 viewDir_xyz_1 = ((-float4(TEXCOORD1_y_1, TEXCOORD2_z_1, TEXCOORD3_w_1, TEXCOORD1_y_1) + unity_WorldToObject[0].xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_2 = ((r2_xyzw_1.xyzx * _Color.xyzx)).xyz;
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r3_x_2 = (r3_xyzw_1.w * r3_xyzw_1.x);
                float4 r3_xyzw_3 = mad(float4(r3_x_2, r3_xyzw_1.y, r3_x_2, r3_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r1_w_1 = dot(float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3), float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r3_z_2 = sqrt(r1_w_3);
                float r1_w_4 = (cb4_values[0].x == 1);
                float r4_x_10;
                float r4_y_10;
                float r4_z_10;
                float r4_w_4;
                if (r1_w_4)
                {
                    float r2_w_2 = (cb4_values[0].y == 1);
                    float3 r4_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord3.wwww, (mad(cb4_values[1].xyzx, i.texcoord1.wwww, ((i.texcoord2.wwww * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r4_xyzw_8 = (((((r2_w_2.xxxx ? r4_xyz_5.xyzx : float4(TEXCOORD1_y_1, TEXCOORD2_z_1, TEXCOORD3_w_1, TEXCOORD1_y_1))).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r4_y_8 = r4_xyzw_8.y;
                    float r4_z_8 = r4_xyzw_8.z;
                    float r4_w_2 = r4_xyzw_8.w;
                    float r2_w_3 = mad(r4_y_8, 0.25, 0.75);
                    float r3_w_2 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r4_x_8 = max(r2_w_3, r3_w_2);
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
                float r2_w_5 = saturate(dot(float4(r4_x_10, r4_y_10, r4_z_10, r4_w_4), unity_OcclusionMaskSelector));
                float r4_x_11 = dot(i.texcoord1.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_y_11 = dot(i.texcoord2.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_z_11 = dot(i.texcoord3.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float4 r3_xyzw_6 = ((rsqrt(dot(float4(r4_x_11, r4_y_11, r4_z_11, r4_x_11), float4(r4_x_11, r4_y_11, r4_z_11, r4_x_11)))).xxxx * float4(r4_x_11, r4_y_11, r4_z_11, r4_x_11));
                float r3_x_6 = r3_xyzw_6.x;
                float r3_y_3 = r3_xyzw_6.y;
                float r3_z_3 = r3_xyzw_6.z;
                float3 r4_xyz_12 = ((r2_w_5.xxxx * _LightColor0.xyzx)).xyz;
                float3 r6_xyz_4;
                if (r1_w_4)
                {
                    float r1_w_5 = (cb4_values[0].y == 1);
                    float3 r5_xyz_4 = (((mad(cb4_values[3].xyzx, i.texcoord3.wwww, (mad(cb4_values[1].xyzx, i.texcoord1.wwww, ((i.texcoord2.wwww * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float3 r0_yzw_2 = ((r1_w_5.xxxx ? r5_xyz_4.xxyz : float4(TEXCOORD1_y_1, TEXCOORD1_y_1, TEXCOORD2_z_1, TEXCOORD3_w_1))).yzw;
                    float3 r0_yzw_3 = ((r0_yzw_2.xxyz + -cb4_values[6].xxyz)).yzw;
                    float4 r5_xyzw_5 = (r0_yzw_3.xxyz * cb4_values[5].xxyz);
                    float r5_y_5 = r5_xyzw_5.y;
                    float r5_z_5 = r5_xyzw_5.z;
                    float r5_w_1 = r5_xyzw_5.w;
                    float r0_y_4 = (r5_y_5 * 0.25);
                    float r0_z_4 = (cb4_values[0].z * 0.5);
                    float r0_w_4 = mad(-cb4_values[0].z, 0.5, 0.25);
                    float r0_y_5 = max(r0_z_4, r0_y_4);
                    float r5_x_5 = min(r0_w_4, r0_y_5);
                    float4 r6_xyzw_2 = t2.Sample(sampler_linear_clamp, (float4(r5_x_5, r5_z_5, r5_w_1, r5_x_5)).xyz);
                    float4 r0_xyzw_6 = (float4(r5_x_5, r5_x_5, r5_z_5, r5_w_1) + float4(0, 0.25, 0, 0));
                    float r0_y_6 = r0_xyzw_6.y;
                    float r0_z_5 = r0_xyzw_6.z;
                    float r0_w_5 = r0_xyzw_6.w;
                    float4 r7_xyzw_1 = t2.Sample(sampler_linear_clamp, (float4(r0_y_6, r0_z_5, r0_w_5, r0_y_6)).xyz);
                    float4 r0_xyzw_7 = (float4(r5_x_5, r5_x_5, r5_z_5, r5_w_1) + float4(0, 0.5, 0, 0));
                    float r0_y_7 = r0_xyzw_7.y;
                    float r0_z_6 = r0_xyzw_7.z;
                    float r0_w_6 = r0_xyzw_7.w;
                    float4 r5_xyzw_6 = t2.Sample(sampler_linear_clamp, (float4(r0_y_7, r0_z_6, r0_w_6, r0_y_7)).xyz);
                    float r3_w_5 = 1;
                    float r6_x_3 = dot(r6_xyzw_2, float4(r3_x_6, r3_y_3, r3_z_3, r3_w_5));
                    float r6_y_3 = dot(r7_xyzw_1, float4(r3_x_6, r3_y_3, r3_z_3, r3_w_5));
                    float r6_z_3 = dot(r5_xyzw_6, float4(r3_x_6, r3_y_3, r3_z_3, r3_w_5));
                    r6_xyz_4 = float3(r6_x_3, r6_y_3, r6_z_3);
                }
                else
                {
                    float r3_w_4 = 1;
                    float r6_x_1 = dot(cb2_values[39].xyzw, float4(r3_x_6, r3_y_3, r3_z_3, r3_w_4));
                    float r6_y_1 = dot(cb2_values[40].xyzw, float4(r3_x_6, r3_y_3, r3_z_3, r3_w_4));
                    float r6_z_1 = dot(cb2_values[41].xyzw, float4(r3_x_6, r3_y_3, r3_z_3, r3_w_4));
                    r6_xyz_4 = float3(r6_x_1, r6_y_1, r6_z_1);
                }
                float4 r0_xyzw_9 = (r6_xyz_4.xxyz + i.texcoord4.xxyz);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_8 = r0_xyzw_9.z;
                float r0_w_8 = r0_xyzw_9.w;
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, (rsqrt(dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx))).xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_x_5 = dot(float4(r3_x_6, r3_y_3, r3_z_3, r3_x_6), _WorldSpaceLightPos0.xyzx);
                float r0_x_6 = (max(float4(r0_x_5, r0_y_9, r0_z_8, r0_w_8), float4(0, 0, 0, 0))).x;
                float4 r0_xyzw_10 = max(float4(r0_x_5, r0_y_9, r0_z_8, r0_w_8), float4(0, 0, 0, 0));
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_9 = r0_xyzw_10.z;
                float r0_w_9 = r0_xyzw_10.w;
                float r1_y_4 = (_Shininess * 128);
                                float r1_x_8 = pow(max(dot(float4(r3_x_6, r3_y_3, r3_z_3, r3_x_6), (((rsqrt(dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx))).xxxx * r1_xyz_2.xyzx)).xyzx), 0), r1_y_4);
                float4 r1_xyzw_5 = (r2_xyz_2.xxyz * r4_xyz_12.xxyz);
                float r1_y_5 = r1_xyzw_5.y;
                float r1_z_4 = r1_xyzw_5.z;
                float r1_w_7 = r1_xyzw_5.w;
                float4 r3_xyzw_7 = (r4_xyz_12.xyzx * _SpecColor.xyzx);
                float r3_x_7 = r3_xyzw_7.x;
                float r3_y_4 = r3_xyzw_7.y;
                float r3_z_4 = r3_xyzw_7.z;
                float4 r3_xyzw_8 = (((r1_x_8 * _Gloss)).xxxx * float4(r3_x_7, r3_y_4, r3_z_4, r3_x_7));
                float r3_x_8 = r3_xyzw_8.x;
                float r3_y_5 = r3_xyzw_8.y;
                float r3_z_5 = r3_xyzw_8.z;
                float4 r1_xyzw_10 = mad(float4(r1_y_5, r1_z_4, r1_w_7, r1_y_5), r0_x_6.xxxx, float4(r3_x_8, r3_y_5, r3_z_5, r3_x_8));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_6 = r1_xyzw_10.y;
                float r1_z_5 = r1_xyzw_10.z;
                float r0_x_7 = (mad(r2_xyz_2.xyzx, float4(r0_y_10, r0_z_9, r0_w_9, r0_y_10), float4(r1_x_10, r1_y_6, r1_z_5, r1_x_10))).x;
                float4 r0_xyzw_11 = mad(r2_xyz_2.xyzx, float4(r0_y_10, r0_z_9, r0_w_9, r0_y_10), float4(r1_x_10, r1_y_6, r1_z_5, r1_x_10));
                float r0_y_11 = r0_xyzw_11.y;
                float r0_z_10 = r0_xyzw_11.z;
                float r0_w_10 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_11 = (-r0_w_10 + 1);
                float r0_w_12 = (r0_w_11 * cb1_values[5].z);
                float r0_w_13 = max(r0_w_12, 0);
                float r0_w_14 = saturate(mad(r0_w_13, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w));
                float4 r0_xyzw_8 = (float4(r0_x_7, r0_y_11, r0_z_10, r0_x_7) + -unity_ProbeVolumeParams.xyzx);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_12 = r0_xyzw_8.y;
                float r0_z_11 = r0_xyzw_8.z;
                o.sv_Target0.xyz = (mad(r0_w_14.xxxx, float4(r0_x_8, r0_y_12, r0_z_11, r0_x_8), unity_ProbeVolumeParams.xyzx)).xyz;
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
                float4 _SpecColor : packoffset(c3);
                float4 _Color : packoffset(c4);
                float _Shininess : packoffset(c5.x);
                float _Gloss : packoffset(c5.y);
                float4 _MainTex_ST : packoffset(c6);
                float4 _BumpMap_ST : packoffset(c7);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
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
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program34Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
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
                float3 worldPos_xyz_4 = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord5.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord1.w = worldPos_xyz_4.x;
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float3 unitWorldNormal_xyz_4 = (((rsqrt(dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3)))).xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = (((rsqrt(dot(worldTangent_xyz_6.xyzx, worldTangent_xyz_6.xyzx))).xxxx * worldTangent_xyz_6.xyzx)).xyz;
                float3 r3_xyz_3 = ((((i.tangent0.w * unity_WorldTransformParams.w)).xxxx * (mad(unitWorldNormal_xyz_4.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_4.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_4.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_4.z;
                o.texcoord3.z = unitWorldNormal_xyz_4.x;
                o.texcoord2.w = worldPos_xyz_4.y;
                o.texcoord3.w = worldPos_xyz_4.z;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program34Output frag(program34Input i)
            {
                program34Output o = (program34Output)0;
                float TEXCOORD1_y_1 = i.texcoord1.w;
                float TEXCOORD2_z_1 = i.texcoord2.w;
                float TEXCOORD3_w_1 = i.texcoord3.w;
                float3 viewDir_xyz_1 = ((-float4(TEXCOORD1_y_1, TEXCOORD2_z_1, TEXCOORD3_w_1, TEXCOORD1_y_1) + unity_WorldToObject[0].xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r3_x_2 = (r3_xyzw_1.w * r3_xyzw_1.x);
                float4 r3_xyzw_3 = mad(float4(r3_x_2, r3_xyzw_1.y, r3_x_2, r3_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r1_w_1 = dot(float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3), float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r3_z_2 = sqrt(r1_w_3);
                float r1_w_4 = (cb4_values[0].x == 1);
                float r4_x_8;
                float r4_y_8;
                float r4_z_8;
                float r4_w_4;
                if (r1_w_4)
                {
                    float r1_w_5 = (cb4_values[0].y == 1);
                    float3 r4_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord3.wwww, (mad(cb4_values[1].xyzx, i.texcoord1.wwww, ((i.texcoord2.wwww * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float3 r0_yzw_2 = ((r1_w_5.xxxx ? r4_xyz_5.xxyz : float4(TEXCOORD1_y_1, TEXCOORD1_y_1, TEXCOORD2_z_1, TEXCOORD3_w_1))).yzw;
                    float3 r0_yzw_3 = ((r0_yzw_2.xxyz + -cb4_values[6].xxyz)).yzw;
                    float4 r4_xyzw_6 = (r0_yzw_3.xxyz * cb4_values[5].xxyz);
                    float r4_y_6 = r4_xyzw_6.y;
                    float r4_z_6 = r4_xyzw_6.z;
                    float r4_w_2 = r4_xyzw_6.w;
                    float r0_y_4 = mad(r4_y_6, 0.25, 0.75);
                    float r0_z_4 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r4_x_6 = max(r0_z_4, r0_y_4);
                    float4 r4_xyzw_7 = t2.Sample(sampler_linear_clamp, (float4(r4_x_6, r4_z_6, r4_w_2, r4_x_6)).xyz);
                    r4_x_8 = r4_xyzw_7.x;
                    r4_y_8 = r4_xyzw_7.y;
                    r4_z_8 = r4_xyzw_7.z;
                    r4_w_4 = r4_xyzw_7.w;
                }
                else
                {
                    float4 r4_xyzw_8 = float4(1, 1, 1, 1);
                    r4_x_8 = r4_xyzw_8.x;
                    r4_y_8 = r4_xyzw_8.y;
                    r4_z_8 = r4_xyzw_8.z;
                    r4_w_4 = r4_xyzw_8.w;
                }
                float r0_y_6 = saturate(dot(float4(r4_x_8, r4_y_8, r4_z_8, r4_w_4), unity_OcclusionMaskSelector));
                float r4_x_9 = dot(i.texcoord1.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_y_9 = dot(i.texcoord2.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_z_9 = dot(i.texcoord3.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r0_z_6 = dot(float4(r4_x_9, r4_y_9, r4_z_9, r4_x_9), float4(r4_x_9, r4_y_9, r4_z_9, r4_x_9));
                float r0_z_7 = rsqrt(r0_z_6);
                float4 r3_xyzw_4 = (r0_z_7.xxxx * float4(r4_x_9, r4_y_9, r4_z_9, r4_x_9));
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r3_z_3 = r3_xyzw_4.z;
                float4 r0_xyzw_7 = (r0_y_6.xxxx * _LightColor0.xxyz);
                float r0_y_7 = r0_xyzw_7.y;
                float r0_z_8 = r0_xyzw_7.z;
                float r0_w_5 = r0_xyzw_7.w;
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, (rsqrt(dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx))).xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r1_y_4 = (_Shininess * 128);
                                float r1_x_8 = pow(max(dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), (((rsqrt(dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx))).xxxx * r1_xyz_2.xyzx)).xyzx), 0), r1_y_4);
                float4 r1_xyzw_5 = (float4(r0_y_7, r0_y_7, r0_z_8, r0_w_5) * ((r2_xyzw_1.xyzx * _Color.xyzx)).xxyz);
                float r1_y_5 = r1_xyzw_5.y;
                float r1_z_4 = r1_xyzw_5.z;
                float r1_w_7 = r1_xyzw_5.w;
                float4 r0_xyzw_8 = (float4(r0_y_7, r0_y_7, r0_z_8, r0_w_5) * _SpecColor.xxyz);
                float r0_y_8 = r0_xyzw_8.y;
                float r0_z_9 = r0_xyzw_8.z;
                float r0_w_6 = r0_xyzw_8.w;
                float4 r0_xyzw_9 = (((r1_x_8 * _Gloss)).xxxx * float4(r0_y_8, r0_y_8, r0_z_9, r0_w_6));
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_10 = r0_xyzw_9.z;
                float r0_w_7 = r0_xyzw_9.w;
                float r0_x_7 = (mad(float4(r1_y_5, r1_z_4, r1_w_7, r1_y_5), (max(dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), _WorldSpaceLightPos0.xyzx), 0)).xxxx, float4(r0_y_9, r0_z_10, r0_w_7, r0_y_9))).x;
                float4 r0_xyzw_10 = mad(float4(r1_y_5, r1_z_4, r1_w_7, r1_y_5), (max(dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), _WorldSpaceLightPos0.xyzx), 0)).xxxx, float4(r0_y_9, r0_z_10, r0_w_7, r0_y_9));
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_11 = r0_xyzw_10.z;
                float r0_w_8 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_9 = (-r0_w_8 + 1);
                float r0_w_10 = (r0_w_9 * cb1_values[5].z);
                float r0_w_11 = max(r0_w_10, 0);
                float r0_w_12 = saturate(mad(r0_w_11, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w));
                float r0_x_8 = ((float4(r0_x_7, r0_y_10, r0_z_11, r0_x_7) + -unity_ProbeVolumeParams.xyzx)).x;
                float4 r0_xyzw_11 = (float4(r0_x_7, r0_y_10, r0_z_11, r0_x_7) + -unity_ProbeVolumeParams.xyzx);
                float r0_y_11 = r0_xyzw_11.y;
                float r0_z_12 = r0_xyzw_11.z;
                o.sv_Target0.xyz = (mad(r0_w_12.xxxx, float4(r0_x_8, r0_y_11, r0_z_12, r0_x_8), unity_ProbeVolumeParams.xyzx)).xyz;
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
                float4 _SpecColor : packoffset(c3);
                float4 _Color : packoffset(c4);
                float _Shininess : packoffset(c5.x);
                float _Gloss : packoffset(c5.y);
                float4 _MainTex_ST : packoffset(c6);
                float4 _BumpMap_ST : packoffset(c7);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
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
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program33Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
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
                float3 r0_xyz_4 = (mad(cb3_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb4_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb4_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb4_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb4_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb4_values[17], cb4_values[18], cb4_values[19], cb4_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord1.w = r0_xyz_4.x;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * cb3_values[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(cb3_values[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(cb3_values[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = (((rsqrt(dot(worldTangent_xyz_6.xyzx, worldTangent_xyz_6.xyzx))).xxxx * worldTangent_xyz_6.xyzx)).xyz;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                float worldNormal_x_1 = dot(i.normal0.xyzx, cb3_values[4].xyzx);
                float worldNormal_y_1 = dot(i.normal0.xyzx, cb3_values[5].xyzx);
                float worldNormal_z_1 = dot(i.normal0.xyzx, cb3_values[6].xyzx);
                float4 unitWorldNormal_xyzw_2 = ((rsqrt(dot(float4(worldNormal_x_1, worldNormal_y_1, worldNormal_z_1, worldNormal_x_1), float4(worldNormal_x_1, worldNormal_y_1, worldNormal_z_1, worldNormal_x_1)))).xxxx * float4(worldNormal_x_1, worldNormal_y_1, worldNormal_z_1, worldNormal_z_1));
                float3 r4_xyz_3 = ((((i.tangent0.w * cb3_values[9].w)).xxxx * (mad(unitWorldNormal_xyzw_2.ywxy, unitWorldTangent_xyz_7.yzxy, ((unitWorldTangent_xyz_7.xyzx * unitWorldNormal_xyzw_2.wxyw)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r4_xyz_3.x;
                o.texcoord1.z = unitWorldNormal_xyzw_2.x;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.w = r0_xyz_4.y;
                o.texcoord3.w = r0_xyz_4.z;
                o.texcoord2.y = r4_xyz_3.y;
                o.texcoord3.y = r4_xyz_3.z;
                o.texcoord2.z = unitWorldNormal_xyzw_2.y;
                o.texcoord3.z = unitWorldNormal_xyzw_2.w;
                float4 r2_xyzw_8 = (unitWorldNormal_xyzw_2.ywzx * unitWorldNormal_xyzw_2);
                float r3_x_3 = dot(cb2_values[42].xyzw, r2_xyzw_8);
                float r3_y_3 = dot(cb2_values[43].xyzw, r2_xyzw_8);
                float r3_z_3 = dot(cb2_values[44].xyzw, r2_xyzw_8);
                o.texcoord4.xyz = (mad(cb2_values[45].xyzx, (mad(unitWorldNormal_xyzw_2.x, unitWorldNormal_xyzw_2.x, (unitWorldNormal_xyzw_2.y * unitWorldNormal_xyzw_2.y))).xxxx, float4(r3_x_3, r3_y_3, r3_z_3, r3_x_3))).xyz;
                float r0_w_4 = ((clipPos_xyzw_2.y * unity_WorldToObject[1].x) * 0.5);
                float4 r0_xyzw_13 = (clipPos_xyzw_2.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_13 = r0_xyzw_13.x;
                float r0_z_5 = r0_xyzw_13.z;
                o.texcoord6.zw = (clipPos_xyzw_2.zzzw).zw;
                o.texcoord6.xy = ((r0_z_5.xxxx + float4(r0_x_13, r0_w_4, r0_x_13, r0_x_13))).xy;
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program33Output frag(program33Input i)
            {
                program33Output o = (program33Output)0;
                float TEXCOORD1_y_1 = i.texcoord1.w;
                float TEXCOORD2_z_1 = i.texcoord2.w;
                float TEXCOORD3_w_1 = i.texcoord3.w;
                float3 viewDir_xyz_1 = ((-float4(TEXCOORD1_y_1, TEXCOORD2_z_1, TEXCOORD3_w_1, TEXCOORD1_y_1) + unity_WorldToObject[0].xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_2 = ((r2_xyzw_1.xyzx * _Color.xyzx)).xyz;
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r3_x_2 = (r3_xyzw_1.w * r3_xyzw_1.x);
                float4 r3_xyzw_3 = mad(float4(r3_x_2, r3_xyzw_1.y, r3_x_2, r3_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r1_w_1 = dot(float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3), float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r3_z_2 = sqrt(r1_w_3);
                float r4_x_1 = cb4_values[9].z;
                float r4_y_1 = cb4_values[10].z;
                float r4_z_1 = cb4_values[11].z;
                float r1_w_4 = dot(viewDir_xyz_1.xyzx, float4(r4_x_1, r4_y_1, r4_z_1, r4_x_1));
                float3 r4_xyz_2 = ((float4(TEXCOORD1_y_1, TEXCOORD2_z_1, TEXCOORD3_w_1, TEXCOORD1_y_1) + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = dot(r4_xyz_2.xyzx, r4_xyz_2.xyzx);
                float r2_w_3 = sqrt(r2_w_2);
                float r2_w_4 = (-r1_w_4 + r2_w_3);
                float r1_w_5 = mad(cb3_values[25].w, r2_w_4, r1_w_4);
                float r1_w_6 = saturate(mad(r1_w_5, cb3_values[24].z, cb3_values[24].w));
                float r2_w_5 = (cb5_values[0].x == 1);
                float r4_x_12;
                float r4_y_13;
                float r4_z_12;
                float r4_w_4;
                if (r2_w_5)
                {
                    float r3_w_2 = (cb5_values[0].y == 1);
                    float3 r4_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord3.wwww, (mad(cb5_values[1].xyzx, i.texcoord1.wwww, ((i.texcoord2.wwww * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r4_xyzw_10 = (((((r3_w_2.xxxx ? r4_xyz_7.xyzx : float4(TEXCOORD1_y_1, TEXCOORD2_z_1, TEXCOORD3_w_1, TEXCOORD1_y_1))).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r4_y_10 = r4_xyzw_10.y;
                    float r4_z_10 = r4_xyzw_10.z;
                    float r4_w_2 = r4_xyzw_10.w;
                    float r3_w_3 = mad(r4_y_10, 0.25, 0.75);
                    float r4_y_11 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r4_x_10 = max(r3_w_3, r4_y_11);
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
                float r3_w_5 = saturate(dot(float4(r4_x_12, r4_y_13, r4_z_12, r4_w_4), unity_OcclusionMaskSelector));
                float4 r4_xyzw_13 = (i.texcoord6.xyxx / i.texcoord6.wwww);
                float r4_x_13 = r4_xyzw_13.x;
                float r4_y_14 = r4_xyzw_13.y;
                float4 r4_xyzw_14 = t2.Sample(sampler_linear_clamp1, (float4(r4_x_13, r4_y_14, r4_x_13, r4_x_13)).xy);
                float r3_w_6 = (r3_w_5 + -r4_xyzw_14.x);
                float r1_w_7 = mad(r1_w_6, r3_w_6, r4_xyzw_14.x);
                float r4_x_15 = dot(i.texcoord1.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_y_16 = dot(i.texcoord2.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_z_14 = dot(i.texcoord3.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float4 r3_xyzw_6 = ((rsqrt(dot(float4(r4_x_15, r4_y_16, r4_z_14, r4_x_15), float4(r4_x_15, r4_y_16, r4_z_14, r4_x_15)))).xxxx * float4(r4_x_15, r4_y_16, r4_z_14, r4_x_15));
                float r3_x_6 = r3_xyzw_6.x;
                float r3_y_3 = r3_xyzw_6.y;
                float r3_z_3 = r3_xyzw_6.z;
                float4 r4_xyzw_16 = (r1_w_7.xxxx * _LightColor0.xyzx);
                float r4_x_16 = r4_xyzw_16.x;
                float r4_y_17 = r4_xyzw_16.y;
                float r4_z_15 = r4_xyzw_16.z;
                float3 r6_xyz_4;
                if (r2_w_5)
                {
                    float r1_w_8 = (cb5_values[0].y == 1);
                    float3 r5_xyz_4 = (((mad(cb5_values[3].xyzx, i.texcoord3.wwww, (mad(cb5_values[1].xyzx, i.texcoord1.wwww, ((i.texcoord2.wwww * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float3 r0_yzw_2 = ((r1_w_8.xxxx ? r5_xyz_4.xxyz : float4(TEXCOORD1_y_1, TEXCOORD1_y_1, TEXCOORD2_z_1, TEXCOORD3_w_1))).yzw;
                    float3 r0_yzw_3 = ((r0_yzw_2.xxyz + -cb5_values[6].xxyz)).yzw;
                    float4 r5_xyzw_5 = (r0_yzw_3.xxyz * cb5_values[5].xxyz);
                    float r5_y_5 = r5_xyzw_5.y;
                    float r5_z_5 = r5_xyzw_5.z;
                    float r5_w_1 = r5_xyzw_5.w;
                    float r0_y_4 = (r5_y_5 * 0.25);
                    float r0_z_4 = (cb5_values[0].z * 0.5);
                    float r0_w_4 = mad(-cb5_values[0].z, 0.5, 0.25);
                    float r0_y_5 = max(r0_z_4, r0_y_4);
                    float r5_x_5 = min(r0_w_4, r0_y_5);
                    float4 r6_xyzw_2 = t3.Sample(sampler_linear_clamp, (float4(r5_x_5, r5_z_5, r5_w_1, r5_x_5)).xyz);
                    float4 r0_xyzw_6 = (float4(r5_x_5, r5_x_5, r5_z_5, r5_w_1) + float4(0, 0.25, 0, 0));
                    float r0_y_6 = r0_xyzw_6.y;
                    float r0_z_5 = r0_xyzw_6.z;
                    float r0_w_5 = r0_xyzw_6.w;
                    float4 r7_xyzw_1 = t3.Sample(sampler_linear_clamp, (float4(r0_y_6, r0_z_5, r0_w_5, r0_y_6)).xyz);
                    float4 r0_xyzw_7 = (float4(r5_x_5, r5_x_5, r5_z_5, r5_w_1) + float4(0, 0.5, 0, 0));
                    float r0_y_7 = r0_xyzw_7.y;
                    float r0_z_6 = r0_xyzw_7.z;
                    float r0_w_6 = r0_xyzw_7.w;
                    float4 r5_xyzw_6 = t3.Sample(sampler_linear_clamp, (float4(r0_y_7, r0_z_6, r0_w_6, r0_y_7)).xyz);
                    float r3_w_8 = 1;
                    float r6_x_3 = dot(r6_xyzw_2, float4(r3_x_6, r3_y_3, r3_z_3, r3_w_8));
                    float r6_y_3 = dot(r7_xyzw_1, float4(r3_x_6, r3_y_3, r3_z_3, r3_w_8));
                    float r6_z_3 = dot(r5_xyzw_6, float4(r3_x_6, r3_y_3, r3_z_3, r3_w_8));
                    r6_xyz_4 = float3(r6_x_3, r6_y_3, r6_z_3);
                }
                else
                {
                    float r3_w_7 = 1;
                    float r6_x_1 = dot(cb2_values[39].xyzw, float4(r3_x_6, r3_y_3, r3_z_3, r3_w_7));
                    float r6_y_1 = dot(cb2_values[40].xyzw, float4(r3_x_6, r3_y_3, r3_z_3, r3_w_7));
                    float r6_z_1 = dot(cb2_values[41].xyzw, float4(r3_x_6, r3_y_3, r3_z_3, r3_w_7));
                    r6_xyz_4 = float3(r6_x_1, r6_y_1, r6_z_1);
                }
                float4 r0_xyzw_9 = (r6_xyz_4.xxyz + i.texcoord4.xxyz);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_8 = r0_xyzw_9.z;
                float r0_w_8 = r0_xyzw_9.w;
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, (rsqrt(dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx))).xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_x_5 = dot(float4(r3_x_6, r3_y_3, r3_z_3, r3_x_6), _WorldSpaceLightPos0.xyzx);
                float r0_x_6 = (max(float4(r0_x_5, r0_y_9, r0_z_8, r0_w_8), float4(0, 0, 0, 0))).x;
                float4 r0_xyzw_10 = max(float4(r0_x_5, r0_y_9, r0_z_8, r0_w_8), float4(0, 0, 0, 0));
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_9 = r0_xyzw_10.z;
                float r0_w_9 = r0_xyzw_10.w;
                float r1_y_4 = (_Shininess * 128);
                                float r1_x_8 = pow(max(dot(float4(r3_x_6, r3_y_3, r3_z_3, r3_x_6), (((rsqrt(dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx))).xxxx * r1_xyz_2.xyzx)).xyzx), 0), r1_y_4);
                float4 r1_xyzw_5 = (r2_xyz_2.xxyz * float4(r4_x_16, r4_x_16, r4_y_17, r4_z_15));
                float r1_y_5 = r1_xyzw_5.y;
                float r1_z_4 = r1_xyzw_5.z;
                float r1_w_10 = r1_xyzw_5.w;
                float4 r3_xyzw_7 = (float4(r4_x_16, r4_y_17, r4_z_15, r4_x_16) * _SpecColor.xyzx);
                float r3_x_7 = r3_xyzw_7.x;
                float r3_y_4 = r3_xyzw_7.y;
                float r3_z_4 = r3_xyzw_7.z;
                float4 r3_xyzw_8 = (((r1_x_8 * _Gloss)).xxxx * float4(r3_x_7, r3_y_4, r3_z_4, r3_x_7));
                float r3_x_8 = r3_xyzw_8.x;
                float r3_y_5 = r3_xyzw_8.y;
                float r3_z_5 = r3_xyzw_8.z;
                float4 r1_xyzw_10 = mad(float4(r1_y_5, r1_z_4, r1_w_10, r1_y_5), r0_x_6.xxxx, float4(r3_x_8, r3_y_5, r3_z_5, r3_x_8));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_6 = r1_xyzw_10.y;
                float r1_z_5 = r1_xyzw_10.z;
                o.sv_Target0.xyz = (mad(r2_xyz_2.xyzx, float4(r0_y_10, r0_z_9, r0_w_9, r0_y_10), float4(r1_x_10, r1_y_6, r1_z_5, r1_x_10))).xyz;
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
                float4 _SpecColor : packoffset(c3);
                float4 _Color : packoffset(c4);
                float _Shininess : packoffset(c5.x);
                float _Gloss : packoffset(c5.y);
                float4 _MainTex_ST : packoffset(c6);
                float4 _BumpMap_ST : packoffset(c7);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[10];
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
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program32Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
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
                float3 r0_xyz_4 = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord1.w = r0_xyz_4.x;
                float r2_y_4 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float r2_z_4 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float r2_x_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float3 unitWorldNormal_xyz_5 = (((rsqrt(dot(float4(r2_x_4, r2_y_4, r2_z_4, r2_x_4), float4(r2_x_4, r2_y_4, r2_z_4, r2_x_4)))).xxxx * float4(r2_x_4, r2_y_4, r2_z_4, r2_x_4))).xyz;
                float3 worldTangent_xyz_1 = ((i.tangent0.yyyy * cb2_values[1].yzxy)).xyz;
                float3 worldTangent_xyz_2 = (mad(cb2_values[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_1.xyzx)).xyz;
                float3 worldTangent_xyz_3 = (mad(cb2_values[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_2.xyzx)).xyz;
                float3 unitWorldTangent_xyz_4 = (((rsqrt(dot(worldTangent_xyz_3.xyzx, worldTangent_xyz_3.xyzx))).xxxx * worldTangent_xyz_3.xyzx)).xyz;
                float3 r4_xyz_3 = ((((i.tangent0.w * cb2_values[9].w)).xxxx * (mad(unitWorldNormal_xyz_5.zxyz, unitWorldTangent_xyz_4.yzxy, ((unitWorldNormal_xyz_5.xyzx * unitWorldTangent_xyz_4.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r4_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_4.z;
                o.texcoord1.z = unitWorldNormal_xyz_5.y;
                o.texcoord2.x = unitWorldTangent_xyz_4.x;
                o.texcoord3.x = unitWorldTangent_xyz_4.y;
                o.texcoord2.z = unitWorldNormal_xyz_5.z;
                o.texcoord3.z = unitWorldNormal_xyz_5.x;
                o.texcoord2.w = r0_xyz_4.y;
                o.texcoord3.w = r0_xyz_4.z;
                o.texcoord2.y = r4_xyz_3.y;
                o.texcoord3.y = r4_xyz_3.z;
                float r0_w_4 = ((clipPos_xyzw_2.y * unity_WorldToObject[1].x) * 0.5);
                float4 r0_xyzw_11 = (clipPos_xyzw_2.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_z_5 = r0_xyzw_11.z;
                o.texcoord6.zw = (clipPos_xyzw_2.zzzw).zw;
                o.texcoord6.xy = ((r0_z_5.xxxx + float4(r0_x_11, r0_w_4, r0_x_11, r0_x_11))).xy;
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program32Output frag(program32Input i)
            {
                program32Output o = (program32Output)0;
                float TEXCOORD1_y_1 = i.texcoord1.w;
                float TEXCOORD2_z_1 = i.texcoord2.w;
                float TEXCOORD3_w_1 = i.texcoord3.w;
                float3 viewDir_xyz_1 = ((-float4(TEXCOORD1_y_1, TEXCOORD2_z_1, TEXCOORD3_w_1, TEXCOORD1_y_1) + unity_WorldToObject[0].xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r3_x_2 = (r3_xyzw_1.w * r3_xyzw_1.x);
                float4 r3_xyzw_3 = mad(float4(r3_x_2, r3_xyzw_1.y, r3_x_2, r3_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r1_w_1 = dot(float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3), float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r3_z_2 = sqrt(r1_w_3);
                float r4_x_1 = cb4_values[9].z;
                float r4_y_1 = cb4_values[10].z;
                float r4_z_1 = cb4_values[11].z;
                float r1_w_4 = dot(viewDir_xyz_1.xyzx, float4(r4_x_1, r4_y_1, r4_z_1, r4_x_1));
                float3 r4_xyz_2 = ((float4(TEXCOORD1_y_1, TEXCOORD2_z_1, TEXCOORD3_w_1, TEXCOORD1_y_1) + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = dot(r4_xyz_2.xyzx, r4_xyz_2.xyzx);
                float r2_w_3 = sqrt(r2_w_2);
                float r2_w_4 = (-r1_w_4 + r2_w_3);
                float r1_w_5 = mad(cb3_values[25].w, r2_w_4, r1_w_4);
                float r1_w_6 = saturate(mad(r1_w_5, cb3_values[24].z, cb3_values[24].w));
                float r2_w_5 = (cb5_values[0].x == 1);
                float r4_x_10;
                float r4_y_10;
                float r4_z_10;
                float r4_w_4;
                if (r2_w_5)
                {
                    float r2_w_6 = (cb5_values[0].y == 1);
                    float3 r4_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord3.wwww, (mad(cb5_values[1].xyzx, i.texcoord1.wwww, ((i.texcoord2.wwww * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float3 r0_yzw_2 = ((r2_w_6.xxxx ? r4_xyz_7.xxyz : float4(TEXCOORD1_y_1, TEXCOORD1_y_1, TEXCOORD2_z_1, TEXCOORD3_w_1))).yzw;
                    float3 r0_yzw_3 = ((r0_yzw_2.xxyz + -cb5_values[6].xxyz)).yzw;
                    float4 r4_xyzw_8 = (r0_yzw_3.xxyz * cb5_values[5].xxyz);
                    float r4_y_8 = r4_xyzw_8.y;
                    float r4_z_8 = r4_xyzw_8.z;
                    float r4_w_2 = r4_xyzw_8.w;
                    float r0_y_4 = mad(r4_y_8, 0.25, 0.75);
                    float r0_z_4 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r4_x_8 = max(r0_z_4, r0_y_4);
                    float4 r4_xyzw_9 = t3.Sample(sampler_linear_clamp, (float4(r4_x_8, r4_z_8, r4_w_2, r4_x_8)).xyz);
                    r4_x_10 = r4_xyzw_9.x;
                    r4_y_10 = r4_xyzw_9.y;
                    r4_z_10 = r4_xyzw_9.z;
                    r4_w_4 = r4_xyzw_9.w;
                }
                else
                {
                    float4 r4_xyzw_3 = float4(1, 1, 1, 1);
                    r4_x_10 = r4_xyzw_3.x;
                    r4_y_10 = r4_xyzw_3.y;
                    r4_z_10 = r4_xyzw_3.z;
                    r4_w_4 = r4_xyzw_3.w;
                }
                float r0_y_6 = saturate(dot(float4(r4_x_10, r4_y_10, r4_z_10, r4_w_4), unity_OcclusionMaskSelector));
                float4 r0_xyzw_6 = (i.texcoord6.xxxy / i.texcoord6.wwww);
                float r0_z_6 = r0_xyzw_6.z;
                float r0_w_5 = r0_xyzw_6.w;
                float4 r4_xyzw_11 = t2.Sample(sampler_linear_clamp1, (float4(r0_z_6, r0_w_5, r0_z_6, r0_z_6)).xy);
                float r0_y_7 = (r0_y_6 + -r4_xyzw_11.x);
                float r0_y_8 = mad(r1_w_6, r0_y_7, r4_xyzw_11.x);
                float r4_x_12 = dot(i.texcoord1.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_y_12 = dot(i.texcoord2.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_z_12 = dot(i.texcoord3.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r0_z_7 = dot(float4(r4_x_12, r4_y_12, r4_z_12, r4_x_12), float4(r4_x_12, r4_y_12, r4_z_12, r4_x_12));
                float r0_z_8 = rsqrt(r0_z_7);
                float4 r3_xyzw_4 = (r0_z_8.xxxx * float4(r4_x_12, r4_y_12, r4_z_12, r4_x_12));
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r3_z_3 = r3_xyzw_4.z;
                float4 r0_xyzw_9 = (r0_y_8.xxxx * _LightColor0.xxyz);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_9 = r0_xyzw_9.z;
                float r0_w_6 = r0_xyzw_9.w;
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, (rsqrt(dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx))).xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r1_y_4 = (_Shininess * 128);
                                float r1_x_8 = pow(max(dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), (((rsqrt(dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx))).xxxx * r1_xyz_2.xyzx)).xyzx), 0), r1_y_4);
                float4 r1_xyzw_5 = (float4(r0_y_9, r0_y_9, r0_z_9, r0_w_6) * ((r2_xyzw_1.xyzx * _Color.xyzx)).xxyz);
                float r1_y_5 = r1_xyzw_5.y;
                float r1_z_4 = r1_xyzw_5.z;
                float r1_w_7 = r1_xyzw_5.w;
                float4 r0_xyzw_10 = (float4(r0_y_9, r0_y_9, r0_z_9, r0_w_6) * _SpecColor.xxyz);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_10 = r0_xyzw_10.z;
                float r0_w_7 = r0_xyzw_10.w;
                float4 r0_xyzw_11 = (((r1_x_8 * _Gloss)).xxxx * float4(r0_y_10, r0_y_10, r0_z_10, r0_w_7));
                float r0_y_11 = r0_xyzw_11.y;
                float r0_z_11 = r0_xyzw_11.z;
                float r0_w_8 = r0_xyzw_11.w;
                o.sv_Target0.xyz = (mad(float4(r1_y_5, r1_z_4, r1_w_7, r1_y_5), (max(dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), _WorldSpaceLightPos0.xyzx), 0)).xxxx, float4(r0_y_11, r0_z_11, r0_w_8, r0_y_11))).xyz;
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
                float4 _SpecColor : packoffset(c3);
                float4 _Color : packoffset(c4);
                float _Shininess : packoffset(c5.x);
                float _Gloss : packoffset(c5.y);
                float4 _MainTex_ST : packoffset(c6);
                float4 _BumpMap_ST : packoffset(c7);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
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
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb3_values[21];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_MainTex;
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
            };
            struct program31Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord6 : TEXCOORD6;
                float4 texcoord7 : TEXCOORD7;
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
                float3 r0_xyz_4 = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord1.w = r0_xyz_4.x;
                float3 worldTangent_xyz_2 = ((i.tangent0.yyyy * cb2_values[1].yzxy)).xyz;
                float3 worldTangent_xyz_3 = (mad(cb2_values[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_2.xyzx)).xyz;
                float3 worldTangent_xyz_4 = (mad(cb2_values[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_3.xyzx)).xyz;
                float3 unitWorldTangent_xyz_5 = (((rsqrt(dot(worldTangent_xyz_4.xyzx, worldTangent_xyz_4.xyzx))).xxxx * worldTangent_xyz_4.xyzx)).xyz;
                o.texcoord1.x = unitWorldTangent_xyz_5.z;
                float worldNormal_x_4 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float4 unitWorldNormal_xyzw_5 = ((rsqrt(dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4)))).xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_z_4));
                float3 r3_xyz_3 = ((((i.tangent0.w * cb2_values[9].w)).xxxx * (mad(unitWorldNormal_xyzw_5.ywxy, unitWorldTangent_xyz_5.yzxy, ((unitWorldTangent_xyz_5.xyzx * unitWorldNormal_xyzw_5.wxyw)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.z = unitWorldNormal_xyzw_5.x;
                o.texcoord2.x = unitWorldTangent_xyz_5.x;
                o.texcoord3.x = unitWorldTangent_xyz_5.y;
                o.texcoord2.w = r0_xyz_4.y;
                o.texcoord3.w = r0_xyz_4.z;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord2.z = unitWorldNormal_xyzw_5.y;
                o.texcoord3.z = unitWorldNormal_xyzw_5.w;
                float4 r1_xyzw_6 = (unitWorldNormal_xyzw_5.ywzx * unitWorldNormal_xyzw_5);
                float r2_x_6 = dot(cb1_values[42].xyzw, r1_xyzw_6);
                float r2_y_6 = dot(cb1_values[43].xyzw, r1_xyzw_6);
                float r2_z_6 = dot(cb1_values[44].xyzw, r1_xyzw_6);
                o.texcoord4.xyz = (mad(cb1_values[45].xyzx, (mad(unitWorldNormal_xyzw_5.x, unitWorldNormal_xyzw_5.x, (unitWorldNormal_xyzw_5.y * unitWorldNormal_xyzw_5.y))).xxxx, float4(r2_x_6, r2_y_6, r2_z_6, r2_x_6))).xyz;
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                o.texcoord7.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program31Output frag(program31Input i)
            {
                program31Output o = (program31Output)0;
                float TEXCOORD1_y_1 = i.texcoord1.w;
                float TEXCOORD2_z_1 = i.texcoord2.w;
                float TEXCOORD3_w_1 = i.texcoord3.w;
                float3 viewDir_xyz_1 = ((-float4(TEXCOORD1_y_1, TEXCOORD2_z_1, TEXCOORD3_w_1, TEXCOORD1_y_1) + unity_WorldToObject[0].xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_2 = ((r2_xyzw_1.xyzx * _Color.xyzx)).xyz;
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r3_x_2 = (r3_xyzw_1.w * r3_xyzw_1.x);
                float4 r3_xyzw_3 = mad(float4(r3_x_2, r3_xyzw_1.y, r3_x_2, r3_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r1_w_1 = dot(float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3), float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r3_z_2 = sqrt(r1_w_3);
                float r1_w_4 = (unity_ProbeVolumeParams.x == 1);
                float r4_x_10;
                float r4_y_10;
                float r4_z_10;
                float r4_w_4;
                if (r1_w_4)
                {
                    float r2_w_2 = (unity_ProbeVolumeParams.y == 1);
                    float3 r4_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord3.wwww, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.wwww, ((i.texcoord2.wwww * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r2_w_2.xxxx ? r4_xyz_5.xyzx : float4(TEXCOORD1_y_1, TEXCOORD2_z_1, TEXCOORD3_w_1, TEXCOORD1_y_1))).xyz;
                    float4 r4_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r4_y_8 = r4_xyzw_8.y;
                    float r4_z_8 = r4_xyzw_8.z;
                    float r4_w_2 = r4_xyzw_8.w;
                    float r2_w_3 = mad(r4_y_8, 0.25, 0.75);
                    float r3_w_2 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r4_x_8 = max(r2_w_3, r3_w_2);
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
                float r2_w_5 = saturate(dot(float4(r4_x_10, r4_y_10, r4_z_10, r4_w_4), unity_OcclusionMaskSelector));
                float r4_x_11 = dot(i.texcoord1.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_y_11 = dot(i.texcoord2.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_z_11 = dot(i.texcoord3.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float4 r3_xyzw_6 = ((rsqrt(dot(float4(r4_x_11, r4_y_11, r4_z_11, r4_x_11), float4(r4_x_11, r4_y_11, r4_z_11, r4_x_11)))).xxxx * float4(r4_x_11, r4_y_11, r4_z_11, r4_x_11));
                float r3_x_6 = r3_xyzw_6.x;
                float r3_y_3 = r3_xyzw_6.y;
                float r3_z_3 = r3_xyzw_6.z;
                float3 r4_xyz_12 = ((r2_w_5.xxxx * _LightColor0.xyzx)).xyz;
                float3 r6_xyz_4;
                if (r1_w_4)
                {
                    float r1_w_5 = (unity_ProbeVolumeParams.y == 1);
                    float3 r5_xyz_4 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord3.wwww, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.wwww, ((i.texcoord2.wwww * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_yzw_2 = ((r1_w_5.xxxx ? r5_xyz_4.xxyz : float4(TEXCOORD1_y_1, TEXCOORD1_y_1, TEXCOORD2_z_1, TEXCOORD3_w_1))).yzw;
                    float3 r0_yzw_3 = ((unity_ProbeVolumeParamsSelect_yzw_2.xxyz + -unity_ProbeVolumeMin.xxyz)).yzw;
                    float4 r5_xyzw_5 = (r0_yzw_3.xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r5_y_5 = r5_xyzw_5.y;
                    float r5_z_5 = r5_xyzw_5.z;
                    float r5_w_1 = r5_xyzw_5.w;
                    float r0_y_4 = (r5_y_5 * 0.25);
                    float r0_z_4 = (unity_ProbeVolumeParams.z * 0.5);
                    float r0_w_4 = mad(-unity_ProbeVolumeParams.z, 0.5, 0.25);
                    float r0_y_5 = max(r0_z_4, r0_y_4);
                    float r5_x_5 = min(r0_w_4, r0_y_5);
                    float4 r6_xyzw_2 = t2.Sample(sampler_linear_clamp, (float4(r5_x_5, r5_z_5, r5_w_1, r5_x_5)).xyz);
                    float4 r0_xyzw_6 = (float4(r5_x_5, r5_x_5, r5_z_5, r5_w_1) + float4(0, 0.25, 0, 0));
                    float r0_y_6 = r0_xyzw_6.y;
                    float r0_z_5 = r0_xyzw_6.z;
                    float r0_w_5 = r0_xyzw_6.w;
                    float4 r7_xyzw_1 = t2.Sample(sampler_linear_clamp, (float4(r0_y_6, r0_z_5, r0_w_5, r0_y_6)).xyz);
                    float4 r0_xyzw_7 = (float4(r5_x_5, r5_x_5, r5_z_5, r5_w_1) + float4(0, 0.5, 0, 0));
                    float r0_y_7 = r0_xyzw_7.y;
                    float r0_z_6 = r0_xyzw_7.z;
                    float r0_w_6 = r0_xyzw_7.w;
                    float4 r5_xyzw_6 = t2.Sample(sampler_linear_clamp, (float4(r0_y_7, r0_z_6, r0_w_6, r0_y_7)).xyz);
                    float r3_w_5 = 1;
                    float r6_x_3 = dot(r6_xyzw_2, float4(r3_x_6, r3_y_3, r3_z_3, r3_w_5));
                    float r6_y_3 = dot(r7_xyzw_1, float4(r3_x_6, r3_y_3, r3_z_3, r3_w_5));
                    float r6_z_3 = dot(r5_xyzw_6, float4(r3_x_6, r3_y_3, r3_z_3, r3_w_5));
                    r6_xyz_4 = float3(r6_x_3, r6_y_3, r6_z_3);
                }
                else
                {
                    float r3_w_4 = 1;
                    float r6_x_1 = dot(cb2_values[39].xyzw, float4(r3_x_6, r3_y_3, r3_z_3, r3_w_4));
                    float r6_y_1 = dot(cb2_values[40].xyzw, float4(r3_x_6, r3_y_3, r3_z_3, r3_w_4));
                    float r6_z_1 = dot(cb2_values[41].xyzw, float4(r3_x_6, r3_y_3, r3_z_3, r3_w_4));
                    r6_xyz_4 = float3(r6_x_1, r6_y_1, r6_z_1);
                }
                float4 r0_xyzw_9 = (r6_xyz_4.xxyz + i.texcoord4.xxyz);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_8 = r0_xyzw_9.z;
                float r0_w_8 = r0_xyzw_9.w;
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, (rsqrt(dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx))).xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_x_5 = dot(float4(r3_x_6, r3_y_3, r3_z_3, r3_x_6), _WorldSpaceLightPos0.xyzx);
                float r0_x_6 = (max(float4(r0_x_5, r0_y_9, r0_z_8, r0_w_8), float4(0, 0, 0, 0))).x;
                float4 r0_xyzw_10 = max(float4(r0_x_5, r0_y_9, r0_z_8, r0_w_8), float4(0, 0, 0, 0));
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_9 = r0_xyzw_10.z;
                float r0_w_9 = r0_xyzw_10.w;
                float r1_y_4 = (_Shininess * 128);
                                float r1_x_8 = pow(max(dot(float4(r3_x_6, r3_y_3, r3_z_3, r3_x_6), (((rsqrt(dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx))).xxxx * r1_xyz_2.xyzx)).xyzx), 0), r1_y_4);
                float4 r1_xyzw_5 = (r2_xyz_2.xxyz * r4_xyz_12.xxyz);
                float r1_y_5 = r1_xyzw_5.y;
                float r1_z_4 = r1_xyzw_5.z;
                float r1_w_7 = r1_xyzw_5.w;
                float4 r3_xyzw_7 = (r4_xyz_12.xyzx * _SpecColor.xyzx);
                float r3_x_7 = r3_xyzw_7.x;
                float r3_y_4 = r3_xyzw_7.y;
                float r3_z_4 = r3_xyzw_7.z;
                float4 r3_xyzw_8 = (((r1_x_8 * _Gloss)).xxxx * float4(r3_x_7, r3_y_4, r3_z_4, r3_x_7));
                float r3_x_8 = r3_xyzw_8.x;
                float r3_y_5 = r3_xyzw_8.y;
                float r3_z_5 = r3_xyzw_8.z;
                float4 r1_xyzw_10 = mad(float4(r1_y_5, r1_z_4, r1_w_7, r1_y_5), r0_x_6.xxxx, float4(r3_x_8, r3_y_5, r3_z_5, r3_x_8));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_6 = r1_xyzw_10.y;
                float r1_z_5 = r1_xyzw_10.z;
                o.sv_Target0.xyz = (mad(r2_xyz_2.xyzx, float4(r0_y_10, r0_z_9, r0_w_9, r0_y_10), float4(r1_x_10, r1_y_6, r1_z_5, r1_x_10))).xyz;
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
                float4 _SpecColor;
                float4 _Color;
                float _Shininess;
                float _Gloss;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 cb0_values[12];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
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
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program89Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
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
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[11].xxxy, cb0_values[11].zzzw)).zw;
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                float3 unitWorldNormal_xyz_3 = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_6 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_6.xxxx * (mad(unitWorldNormal_xyz_3.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_3.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_3.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_3.z;
                o.texcoord3.z = unitWorldNormal_xyz_3.x;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord4.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_4 = ((worldPos_xyzw_4.yyyy * cb0_values[5].xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.zzzz, (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_4.xyzx)).xyzx)).xyz;
                o.texcoord5.xyz = (mad(_BumpMap_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program89Output frag(program89Input i)
            {
                program89Output o = (program89Output)0;
                float3 r0_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r0_xyz_2 = normalize(r0_xyz_1);
                float3 viewDir_xyz_1 = ((-i.texcoord4.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_3 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r3_x_2 = (r3_xyzw_1.w * r3_xyzw_1.x);
                float4 r3_xyzw_3 = mad(float4(r3_x_2, r3_xyzw_1.y, r3_x_2, r3_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r1_w_1 = dot(float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3), float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r3_z_2 = sqrt(r1_w_3);
                float3 r4_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord4.zzzz, (mad(cb0_values[4].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r1_w_4 = (unity_ProbeVolumeParams.x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r1_w_4)
                {
                    float r1_w_5 = (unity_ProbeVolumeParams.y == 1);
                    float3 r5_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord4.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r1_w_5.xxxx ? r5_xyz_5.xyzx : i.texcoord4.xyzx)).xyz;
                    float4 r5_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r1_w_6 = mad(r5_y_8, 0.25, 0.75);
                    float r2_w_2 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r5_x_8 = max(r1_w_6, r2_w_2);
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
                float r1_w_8 = saturate(dot(float4(r5_x_10, r5_y_10, r5_z_10, r5_w_4), unity_OcclusionMaskSelector));
                float r2_w_4 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float4 r4_xyzw_5 = t2.Sample(sampler_linear_clamp1, (r2_w_4.xxxx).xy);
                float r1_w_9 = (r1_w_8 * r4_xyzw_5.x);
                float r4_x_6 = dot(i.texcoord1.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_y_6 = dot(i.texcoord2.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_z_6 = dot(i.texcoord3.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r2_w_5 = dot(float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6), float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r2_w_6 = rsqrt(r2_w_5);
                float4 r3_xyzw_4 = (r2_w_6.xxxx * float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r3_z_3 = r3_xyzw_4.z;
                float3 r4_xyz_7 = ((r1_w_9.xxxx * _LightColor0.xyzx)).xyz;
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_4.xxxx, r0_xyz_2.xyzx)).xyz;
                float r0_w_5 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_6 = rsqrt(r0_w_5);
                float r0_x_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), r0_xyz_2.xyzx);
                float r0_y_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), ((r0_w_6.xxxx * r1_xyz_2.xyzx)).xyzx);
                float2 r0_xy_4 = (max(float4(r0_x_3, r0_y_3, r0_x_3, r0_x_3), float4(0, 0, 0, 0))).xy;
                float r0_z_3 = (cb0_values[9].x * 128);
                float r0_y_5 = log2(r0_xy_4.y);
                float r0_y_6 = (r0_y_5 * r0_z_3);
                float r0_y_7 = exp2(r0_y_6);
                float r0_y_8 = (r0_y_7 * cb0_values[9].y);
                float4 r0_xyzw_9 = (r0_y_8.xxxx * ((r4_xyz_7.xyzx * _SpecColor.xyzx)).xxyz);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_4 = r0_xyzw_9.z;
                float r0_w_7 = r0_xyzw_9.w;
                o.sv_Target0.xyz = (mad(((((r2_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * r4_xyz_7.xyzx)).xyzx, r0_xy_4.xxxx, float4(r0_y_9, r0_z_4, r0_w_7, r0_y_9))).xyz;
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
                float4 _SpecColor;
                float4 _Color;
                float _Shininess;
                float _Gloss;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 cb0_values[12];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
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
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float texcoord7 : TEXCOORD7;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program114Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord7 : TEXCOORD7;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
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
                o.texcoord7.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[11].xxxy, cb0_values[11].zzzw)).zw;
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                float3 unitWorldNormal_xyz_4 = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_7 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_7.xxxx * (mad(unitWorldNormal_xyz_4.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_4.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_4.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_4.z;
                o.texcoord3.z = unitWorldNormal_xyz_4.x;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord4.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_6 = (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, ((worldPos_xyzw_4.yyyy * cb0_values[5].xyzx)).xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.zzzz, clipPos_xyz_6.xyzx)).xyz;
                o.texcoord5.xyz = (mad(_BumpMap_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program114Output frag(program114Input i)
            {
                program114Output o = (program114Output)0;
                float3 r0_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r0_xyz_2 = normalize(r0_xyz_1);
                float3 viewDir_xyz_1 = ((-i.texcoord4.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_3 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r3_x_2 = (r3_xyzw_1.w * r3_xyzw_1.x);
                float4 r3_xyzw_3 = mad(float4(r3_x_2, r3_xyzw_1.y, r3_x_2, r3_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r1_w_1 = dot(float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3), float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r3_z_2 = sqrt(r1_w_3);
                float3 r4_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord4.zzzz, (mad(cb0_values[4].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r5_x_1 = cb4_values[9].z;
                float r5_y_1 = cb4_values[10].z;
                float r5_z_1 = cb4_values[11].z;
                float r1_w_4 = dot(viewDir_xyz_1.xyzx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1));
                float3 r5_xyz_2 = ((i.texcoord4.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = dot(r5_xyz_2.xyzx, r5_xyz_2.xyzx);
                float r2_w_3 = sqrt(r2_w_2);
                float r2_w_4 = (-r1_w_4 + r2_w_3);
                float r1_w_5 = mad(cb3_values[25].w, r2_w_4, r1_w_4);
                float r1_w_6 = saturate(mad(r1_w_5, cb3_values[24].z, cb3_values[24].w));
                float r2_w_5 = (cb6_values[0].x == 1);
                float r5_x_12;
                float r5_y_12;
                float r5_z_12;
                float r5_w_4;
                if (r2_w_5)
                {
                    float r2_w_6 = (cb6_values[0].y == 1);
                    float3 r5_xyz_7 = (((mad(cb6_values[3].xyzx, i.texcoord4.zzzz, (mad(cb6_values[1].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r5_xyzw_10 = (((((r2_w_6.xxxx ? r5_xyz_7.xyzx : i.texcoord4.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r5_y_10 = r5_xyzw_10.y;
                    float r5_z_10 = r5_xyzw_10.z;
                    float r5_w_2 = r5_xyzw_10.w;
                    float r2_w_7 = mad(r5_y_10, 0.25, 0.75);
                    float r3_w_2 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r5_x_10 = max(r2_w_7, r3_w_2);
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
                float r2_w_9 = saturate(dot(float4(r5_x_12, r5_y_12, r5_z_12, r5_w_4), unity_OcclusionMaskSelector));
                float r3_w_4 = (r1_w_6 < 0.99);
                float r3_w_16;
                if (r3_w_4)
                {
                    float3 r5_xyz_13 = ((i.texcoord4.xyzx + -cb2_values[1].xyzx)).xyz;
                    float r3_w_6 = max(abs(r5_xyz_13.y), abs(r5_xyz_13.x));
                    float r3_w_7 = max(abs(r5_xyz_13.z), r3_w_6);
                    float r3_w_8 = (r3_w_7 + -cb2_values[2].z);
                    float r3_w_9 = max(r3_w_8, 1E-05);
                    float r3_w_10 = (r3_w_9 * cb2_values[2].w);
                    float r3_w_11 = (cb2_values[2].y / r3_w_10);
                    float r3_w_12 = (r3_w_11 + -cb2_values[2].x);
                    float r3_w_13 = (-r3_w_12 + 1);
                    float r6_x_2 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r5_xyz_13.xyzx + float4(0.0078125, 0.0078125, 0.0078125, 0))).xyzx).xyz, r3_w_13);
                    float r6_y_2 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r5_xyz_13.xyzx + float4(-0.0078125, -0.0078125, 0.0078125, 0))).xyzx).xyz, r3_w_13);
                    float r6_z_2 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r5_xyz_13.xyzx + float4(-0.0078125, 0.0078125, -0.0078125, 0))).xyzx).xyz, r3_w_13);
                    float r6_w_1 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r5_xyz_13.xyzx + float4(0.0078125, -0.0078125, -0.0078125, 0))).xyzx).xyz, r3_w_13);
                    float r3_w_14 = dot(float4(r6_x_2, r6_y_2, r6_z_2, r6_w_1), float4(0.25, 0.25, 0.25, 0.25));
                    float r4_w_1 = (-cb3_values[24].x + 1);
                    float r3_w_15 = mad(r3_w_14, r4_w_1, cb3_values[24].x);
                    r3_w_16 = r3_w_15;
                }
                else
                {
                    float r3_w_5 = 1;
                    r3_w_16 = r3_w_5;
                }
                float r2_w_10 = (r2_w_9 + -r3_w_16);
                float r1_w_7 = mad(r1_w_6, r2_w_10, r3_w_16);
                float r2_w_11 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float4 r5_xyzw_16 = t2.Sample(sampler_linear_clamp3, (r2_w_11.xxxx).xy);
                float4 r4_xyzw_5 = t3.Sample(sampler_linear_clamp2, r4_xyz_4.xyz);
                float r2_w_12 = (r4_xyzw_5.w * r5_xyzw_16.x);
                float r1_w_8 = (r1_w_7 * r2_w_12);
                float r4_x_6 = dot(i.texcoord1.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_y_6 = dot(i.texcoord2.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_z_6 = dot(i.texcoord3.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r2_w_13 = dot(float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6), float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r2_w_14 = rsqrt(r2_w_13);
                float4 r3_xyzw_4 = (r2_w_14.xxxx * float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r3_z_3 = r3_xyzw_4.z;
                float3 r4_xyz_7 = ((r1_w_8.xxxx * _LightColor0.xyzx)).xyz;
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_4.xxxx, r0_xyz_2.xyzx)).xyz;
                float r0_w_5 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_6 = rsqrt(r0_w_5);
                float r0_x_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), r0_xyz_2.xyzx);
                float r0_y_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), ((r0_w_6.xxxx * r1_xyz_2.xyzx)).xyzx);
                float2 r0_xy_4 = (max(float4(r0_x_3, r0_y_3, r0_x_3, r0_x_3), float4(0, 0, 0, 0))).xy;
                float r0_z_3 = (cb0_values[9].x * 128);
                float r0_y_5 = log2(r0_xy_4.y);
                float r0_y_6 = (r0_y_5 * r0_z_3);
                float r0_y_7 = exp2(r0_y_6);
                float r0_y_8 = (r0_y_7 * cb0_values[9].y);
                float4 r0_xyzw_9 = (r0_y_8.xxxx * ((r4_xyz_7.xyzx * _SpecColor.xyzx)).xxyz);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_4 = r0_xyzw_9.z;
                float r0_w_7 = r0_xyzw_9.w;
                float4 r0_xyzw_5 = mad(((((r2_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * r4_xyz_7.xyzx)).xyzx, r0_xy_4.xxxx, float4(r0_y_9, r0_z_4, r0_w_7, r0_y_9));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_10 = r0_xyzw_5.y;
                float r0_z_5 = r0_xyzw_5.z;
                float r0_w_8 = (i.texcoord7.x / cb1_values[5].y);
                float r0_w_9 = (-r0_w_8 + 1);
                float r0_w_10 = (r0_w_9 * cb1_values[5].z);
                float r0_w_11 = max(r0_w_10, 0);
                float r0_w_12 = saturate(mad(r0_w_11, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_10, r0_z_5, r0_x_5) * r0_w_12.xxxx)).xyz;
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
                float4 _SpecColor;
                float4 _Color;
                float _Shininess;
                float _Gloss;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 cb0_values[12];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
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
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float texcoord7 : TEXCOORD7;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program113Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord7 : TEXCOORD7;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
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
                o.texcoord7.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[11].xxxy, cb0_values[11].zzzw)).zw;
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                float3 unitWorldNormal_xyz_4 = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_7 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_7.xxxx * (mad(unitWorldNormal_xyz_4.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_4.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_4.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_4.z;
                o.texcoord3.z = unitWorldNormal_xyz_4.x;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord4.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_6 = (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, ((worldPos_xyzw_4.yyyy * cb0_values[5].xyzx)).xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.zzzz, clipPos_xyz_6.xyzx)).xyz;
                o.texcoord5.xyz = (mad(_BumpMap_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program113Output frag(program113Input i)
            {
                program113Output o = (program113Output)0;
                float3 r0_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r0_xyz_2 = normalize(r0_xyz_1);
                float3 viewDir_xyz_1 = ((-i.texcoord4.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_3 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r3_x_2 = (r3_xyzw_1.w * r3_xyzw_1.x);
                float4 r3_xyzw_3 = mad(float4(r3_x_2, r3_xyzw_1.y, r3_x_2, r3_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r1_w_1 = dot(float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3), float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r3_z_2 = sqrt(r1_w_3);
                float3 r4_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord4.zzzz, (mad(cb0_values[4].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r5_x_1 = cb4_values[9].z;
                float r5_y_1 = cb4_values[10].z;
                float r5_z_1 = cb4_values[11].z;
                float r1_w_4 = dot(viewDir_xyz_1.xyzx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1));
                float3 r5_xyz_2 = ((i.texcoord4.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = dot(r5_xyz_2.xyzx, r5_xyz_2.xyzx);
                float r2_w_3 = sqrt(r2_w_2);
                float r2_w_4 = (-r1_w_4 + r2_w_3);
                float r1_w_5 = mad(cb3_values[25].w, r2_w_4, r1_w_4);
                float r1_w_6 = saturate(mad(r1_w_5, cb3_values[24].z, cb3_values[24].w));
                float r2_w_5 = (cb6_values[0].x == 1);
                float r5_x_12;
                float r5_y_12;
                float r5_z_12;
                float r5_w_4;
                if (r2_w_5)
                {
                    float r2_w_6 = (cb6_values[0].y == 1);
                    float3 r5_xyz_7 = (((mad(cb6_values[3].xyzx, i.texcoord4.zzzz, (mad(cb6_values[1].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r5_xyzw_10 = (((((r2_w_6.xxxx ? r5_xyz_7.xyzx : i.texcoord4.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r5_y_10 = r5_xyzw_10.y;
                    float r5_z_10 = r5_xyzw_10.z;
                    float r5_w_2 = r5_xyzw_10.w;
                    float r2_w_7 = mad(r5_y_10, 0.25, 0.75);
                    float r3_w_2 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r5_x_10 = max(r2_w_7, r3_w_2);
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
                float r2_w_9 = saturate(dot(float4(r5_x_12, r5_y_12, r5_z_12, r5_w_4), unity_OcclusionMaskSelector));
                float3 r5_xyz_13 = ((i.texcoord4.xyzx + -cb2_values[1].xyzx)).xyz;
                float r3_w_4 = max(abs(r5_xyz_13.y), abs(r5_xyz_13.x));
                float r3_w_5 = max(abs(r5_xyz_13.z), r3_w_4);
                float r3_w_6 = (r3_w_5 + -cb2_values[2].z);
                float r3_w_7 = max(r3_w_6, 1E-05);
                float r3_w_8 = (r3_w_7 * cb2_values[2].w);
                float r3_w_9 = (cb2_values[2].y / r3_w_8);
                float r3_w_10 = (r3_w_9 + -cb2_values[2].x);
                float r3_w_11 = (-r3_w_10 + 1);
                float r3_w_12 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, r5_xyz_13.xyz, r3_w_11);
                float r4_w_1 = (-cb3_values[24].x + 1);
                float r3_w_13 = mad(r3_w_12, r4_w_1, cb3_values[24].x);
                float r2_w_10 = (r2_w_9 + -r3_w_13);
                float r1_w_7 = mad(r1_w_6, r2_w_10, r3_w_13);
                float r2_w_11 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float4 r5_xyzw_14 = t2.Sample(sampler_linear_clamp3, (r2_w_11.xxxx).xy);
                float4 r4_xyzw_5 = t3.Sample(sampler_linear_clamp2, r4_xyz_4.xyz);
                float r2_w_12 = (r4_xyzw_5.w * r5_xyzw_14.x);
                float r1_w_8 = (r1_w_7 * r2_w_12);
                float r4_x_6 = dot(i.texcoord1.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_y_6 = dot(i.texcoord2.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_z_6 = dot(i.texcoord3.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r2_w_13 = dot(float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6), float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r2_w_14 = rsqrt(r2_w_13);
                float4 r3_xyzw_4 = (r2_w_14.xxxx * float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r3_z_3 = r3_xyzw_4.z;
                float3 r4_xyz_7 = ((r1_w_8.xxxx * _LightColor0.xyzx)).xyz;
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_4.xxxx, r0_xyz_2.xyzx)).xyz;
                float r0_w_5 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_6 = rsqrt(r0_w_5);
                float r0_x_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), r0_xyz_2.xyzx);
                float r0_y_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), ((r0_w_6.xxxx * r1_xyz_2.xyzx)).xyzx);
                float2 r0_xy_4 = (max(float4(r0_x_3, r0_y_3, r0_x_3, r0_x_3), float4(0, 0, 0, 0))).xy;
                float r0_z_3 = (cb0_values[9].x * 128);
                float r0_y_5 = log2(r0_xy_4.y);
                float r0_y_6 = (r0_y_5 * r0_z_3);
                float r0_y_7 = exp2(r0_y_6);
                float r0_y_8 = (r0_y_7 * cb0_values[9].y);
                float4 r0_xyzw_9 = (r0_y_8.xxxx * ((r4_xyz_7.xyzx * _SpecColor.xyzx)).xxyz);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_4 = r0_xyzw_9.z;
                float r0_w_7 = r0_xyzw_9.w;
                float4 r0_xyzw_5 = mad(((((r2_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * r4_xyz_7.xyzx)).xyzx, r0_xy_4.xxxx, float4(r0_y_9, r0_z_4, r0_w_7, r0_y_9));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_10 = r0_xyzw_5.y;
                float r0_z_5 = r0_xyzw_5.z;
                float r0_w_8 = (i.texcoord7.x / cb1_values[5].y);
                float r0_w_9 = (-r0_w_8 + 1);
                float r0_w_10 = (r0_w_9 * cb1_values[5].z);
                float r0_w_11 = max(r0_w_10, 0);
                float r0_w_12 = saturate(mad(r0_w_11, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_10, r0_z_5, r0_x_5) * r0_w_12.xxxx)).xyz;
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
                float4 _SpecColor;
                float4 _Color;
                float _Shininess;
                float _Gloss;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 cb0_values[12];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
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
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float texcoord7 : TEXCOORD7;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program112Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord7 : TEXCOORD7;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
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
                o.texcoord7.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[11].xxxy, cb0_values[11].zzzw)).zw;
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                float3 unitWorldNormal_xyz_4 = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_7 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_7.xxxx * (mad(unitWorldNormal_xyz_4.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_4.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_4.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_4.z;
                o.texcoord3.z = unitWorldNormal_xyz_4.x;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord4.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_6 = (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, ((worldPos_xyzw_4.yyyy * cb0_values[5].xyzx)).xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.zzzz, clipPos_xyz_6.xyzx)).xyz;
                o.texcoord5.xyz = (mad(_BumpMap_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program112Output frag(program112Input i)
            {
                program112Output o = (program112Output)0;
                float3 r0_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r0_xyz_2 = normalize(r0_xyz_1);
                float3 viewDir_xyz_1 = ((-i.texcoord4.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_3 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r3_x_2 = (r3_xyzw_1.w * r3_xyzw_1.x);
                float4 r3_xyzw_3 = mad(float4(r3_x_2, r3_xyzw_1.y, r3_x_2, r3_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r1_w_1 = dot(float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3), float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r3_z_2 = sqrt(r1_w_3);
                float3 r4_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord4.zzzz, (mad(cb0_values[4].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r5_x_1 = cb4_values[9].z;
                float r5_y_1 = cb4_values[10].z;
                float r5_z_1 = cb4_values[11].z;
                float r1_w_4 = dot(viewDir_xyz_1.xyzx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1));
                float3 r5_xyz_2 = ((i.texcoord4.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = dot(r5_xyz_2.xyzx, r5_xyz_2.xyzx);
                float r2_w_3 = sqrt(r2_w_2);
                float r2_w_4 = (-r1_w_4 + r2_w_3);
                float r1_w_5 = mad(cb3_values[25].w, r2_w_4, r1_w_4);
                float r1_w_6 = saturate(mad(r1_w_5, cb3_values[24].z, cb3_values[24].w));
                float r2_w_5 = (cb6_values[0].x == 1);
                float r5_x_12;
                float r5_y_12;
                float r5_z_12;
                float r5_w_4;
                if (r2_w_5)
                {
                    float r2_w_6 = (cb6_values[0].y == 1);
                    float3 r5_xyz_7 = (((mad(cb6_values[3].xyzx, i.texcoord4.zzzz, (mad(cb6_values[1].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r5_xyzw_10 = (((((r2_w_6.xxxx ? r5_xyz_7.xyzx : i.texcoord4.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r5_y_10 = r5_xyzw_10.y;
                    float r5_z_10 = r5_xyzw_10.z;
                    float r5_w_2 = r5_xyzw_10.w;
                    float r2_w_7 = mad(r5_y_10, 0.25, 0.75);
                    float r3_w_2 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r5_x_10 = max(r2_w_7, r3_w_2);
                    float4 r5_xyzw_11 = t3.Sample(sampler_linear_clamp, (float4(r5_x_10, r5_z_10, r5_w_2, r5_x_10)).xyz);
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
                float r2_w_9 = saturate(dot(float4(r5_x_12, r5_y_12, r5_z_12, r5_w_4), unity_OcclusionMaskSelector));
                float r3_w_4 = (r1_w_6 < 0.99);
                float r3_w_16;
                if (r3_w_4)
                {
                    float3 r5_xyz_13 = ((i.texcoord4.xyzx + -cb2_values[1].xyzx)).xyz;
                    float r3_w_6 = max(abs(r5_xyz_13.y), abs(r5_xyz_13.x));
                    float r3_w_7 = max(abs(r5_xyz_13.z), r3_w_6);
                    float r3_w_8 = (r3_w_7 + -cb2_values[2].z);
                    float r3_w_9 = max(r3_w_8, 1E-05);
                    float r3_w_10 = (r3_w_9 * cb2_values[2].w);
                    float r3_w_11 = (cb2_values[2].y / r3_w_10);
                    float r3_w_12 = (r3_w_11 + -cb2_values[2].x);
                    float r3_w_13 = (-r3_w_12 + 1);
                    float r6_x_2 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r5_xyz_13.xyzx + float4(0.0078125, 0.0078125, 0.0078125, 0))).xyzx).xyz, r3_w_13);
                    float r6_y_2 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r5_xyz_13.xyzx + float4(-0.0078125, -0.0078125, 0.0078125, 0))).xyzx).xyz, r3_w_13);
                    float r6_z_2 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r5_xyz_13.xyzx + float4(-0.0078125, 0.0078125, -0.0078125, 0))).xyzx).xyz, r3_w_13);
                    float r6_w_1 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r5_xyz_13.xyzx + float4(0.0078125, -0.0078125, -0.0078125, 0))).xyzx).xyz, r3_w_13);
                    float r3_w_14 = dot(float4(r6_x_2, r6_y_2, r6_z_2, r6_w_1), float4(0.25, 0.25, 0.25, 0.25));
                    float r4_w_1 = (-cb3_values[24].x + 1);
                    float r3_w_15 = mad(r3_w_14, r4_w_1, cb3_values[24].x);
                    r3_w_16 = r3_w_15;
                }
                else
                {
                    float r3_w_5 = 1;
                    r3_w_16 = r3_w_5;
                }
                float r2_w_10 = (r2_w_9 + -r3_w_16);
                float r1_w_7 = mad(r1_w_6, r2_w_10, r3_w_16);
                float r2_w_11 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float4 r4_xyzw_5 = t2.Sample(sampler_linear_clamp2, (r2_w_11.xxxx).xy);
                float r1_w_8 = (r1_w_7 * r4_xyzw_5.x);
                float r4_x_6 = dot(i.texcoord1.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_y_6 = dot(i.texcoord2.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_z_6 = dot(i.texcoord3.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r2_w_12 = dot(float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6), float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r2_w_13 = rsqrt(r2_w_12);
                float4 r3_xyzw_4 = (r2_w_13.xxxx * float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r3_z_3 = r3_xyzw_4.z;
                float3 r4_xyz_7 = ((r1_w_8.xxxx * _LightColor0.xyzx)).xyz;
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_4.xxxx, r0_xyz_2.xyzx)).xyz;
                float r0_w_5 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_6 = rsqrt(r0_w_5);
                float r0_x_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), r0_xyz_2.xyzx);
                float r0_y_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), ((r0_w_6.xxxx * r1_xyz_2.xyzx)).xyzx);
                float2 r0_xy_4 = (max(float4(r0_x_3, r0_y_3, r0_x_3, r0_x_3), float4(0, 0, 0, 0))).xy;
                float r0_z_3 = (cb0_values[9].x * 128);
                float r0_y_5 = log2(r0_xy_4.y);
                float r0_y_6 = (r0_y_5 * r0_z_3);
                float r0_y_7 = exp2(r0_y_6);
                float r0_y_8 = (r0_y_7 * cb0_values[9].y);
                float4 r0_xyzw_9 = (r0_y_8.xxxx * ((r4_xyz_7.xyzx * _SpecColor.xyzx)).xxyz);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_4 = r0_xyzw_9.z;
                float r0_w_7 = r0_xyzw_9.w;
                float4 r0_xyzw_5 = mad(((((r2_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * r4_xyz_7.xyzx)).xyzx, r0_xy_4.xxxx, float4(r0_y_9, r0_z_4, r0_w_7, r0_y_9));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_10 = r0_xyzw_5.y;
                float r0_z_5 = r0_xyzw_5.z;
                float r0_w_8 = (i.texcoord7.x / cb1_values[5].y);
                float r0_w_9 = (-r0_w_8 + 1);
                float r0_w_10 = (r0_w_9 * cb1_values[5].z);
                float r0_w_11 = max(r0_w_10, 0);
                float r0_w_12 = saturate(mad(r0_w_11, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_10, r0_z_5, r0_x_5) * r0_w_12.xxxx)).xyz;
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
                float4 _SpecColor;
                float4 _Color;
                float _Shininess;
                float _Gloss;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 cb0_values[12];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
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
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float texcoord7 : TEXCOORD7;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program111Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord7 : TEXCOORD7;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
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
                o.texcoord7.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[11].xxxy, cb0_values[11].zzzw)).zw;
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                float3 unitWorldNormal_xyz_4 = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_7 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_7.xxxx * (mad(unitWorldNormal_xyz_4.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_4.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_4.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_4.z;
                o.texcoord3.z = unitWorldNormal_xyz_4.x;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord4.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_6 = (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, ((worldPos_xyzw_4.yyyy * cb0_values[5].xyzx)).xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.zzzz, clipPos_xyz_6.xyzx)).xyz;
                o.texcoord5.xyz = (mad(_BumpMap_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program111Output frag(program111Input i)
            {
                program111Output o = (program111Output)0;
                float3 r0_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r0_xyz_2 = normalize(r0_xyz_1);
                float3 viewDir_xyz_1 = ((-i.texcoord4.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_3 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r3_x_2 = (r3_xyzw_1.w * r3_xyzw_1.x);
                float4 r3_xyzw_3 = mad(float4(r3_x_2, r3_xyzw_1.y, r3_x_2, r3_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r1_w_1 = dot(float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3), float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r3_z_2 = sqrt(r1_w_3);
                float3 r4_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord4.zzzz, (mad(cb0_values[4].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r5_x_1 = cb4_values[9].z;
                float r5_y_1 = cb4_values[10].z;
                float r5_z_1 = cb4_values[11].z;
                float r1_w_4 = dot(viewDir_xyz_1.xyzx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1));
                float3 r5_xyz_2 = ((i.texcoord4.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = dot(r5_xyz_2.xyzx, r5_xyz_2.xyzx);
                float r2_w_3 = sqrt(r2_w_2);
                float r2_w_4 = (-r1_w_4 + r2_w_3);
                float r1_w_5 = mad(cb3_values[25].w, r2_w_4, r1_w_4);
                float r1_w_6 = saturate(mad(r1_w_5, cb3_values[24].z, cb3_values[24].w));
                float r2_w_5 = (cb6_values[0].x == 1);
                float r5_x_12;
                float r5_y_12;
                float r5_z_12;
                float r5_w_4;
                if (r2_w_5)
                {
                    float r2_w_6 = (cb6_values[0].y == 1);
                    float3 r5_xyz_7 = (((mad(cb6_values[3].xyzx, i.texcoord4.zzzz, (mad(cb6_values[1].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r5_xyzw_10 = (((((r2_w_6.xxxx ? r5_xyz_7.xyzx : i.texcoord4.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r5_y_10 = r5_xyzw_10.y;
                    float r5_z_10 = r5_xyzw_10.z;
                    float r5_w_2 = r5_xyzw_10.w;
                    float r2_w_7 = mad(r5_y_10, 0.25, 0.75);
                    float r3_w_2 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r5_x_10 = max(r2_w_7, r3_w_2);
                    float4 r5_xyzw_11 = t3.Sample(sampler_linear_clamp, (float4(r5_x_10, r5_z_10, r5_w_2, r5_x_10)).xyz);
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
                float r2_w_9 = saturate(dot(float4(r5_x_12, r5_y_12, r5_z_12, r5_w_4), unity_OcclusionMaskSelector));
                float3 r5_xyz_13 = ((i.texcoord4.xyzx + -cb2_values[1].xyzx)).xyz;
                float r3_w_4 = max(abs(r5_xyz_13.y), abs(r5_xyz_13.x));
                float r3_w_5 = max(abs(r5_xyz_13.z), r3_w_4);
                float r3_w_6 = (r3_w_5 + -cb2_values[2].z);
                float r3_w_7 = max(r3_w_6, 1E-05);
                float r3_w_8 = (r3_w_7 * cb2_values[2].w);
                float r3_w_9 = (cb2_values[2].y / r3_w_8);
                float r3_w_10 = (r3_w_9 + -cb2_values[2].x);
                float r3_w_11 = (-r3_w_10 + 1);
                float r3_w_12 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, r5_xyz_13.xyz, r3_w_11);
                float r4_w_1 = (-cb3_values[24].x + 1);
                float r3_w_13 = mad(r3_w_12, r4_w_1, cb3_values[24].x);
                float r2_w_10 = (r2_w_9 + -r3_w_13);
                float r1_w_7 = mad(r1_w_6, r2_w_10, r3_w_13);
                float r2_w_11 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float4 r4_xyzw_5 = t2.Sample(sampler_linear_clamp2, (r2_w_11.xxxx).xy);
                float r1_w_8 = (r1_w_7 * r4_xyzw_5.x);
                float r4_x_6 = dot(i.texcoord1.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_y_6 = dot(i.texcoord2.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_z_6 = dot(i.texcoord3.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r2_w_12 = dot(float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6), float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r2_w_13 = rsqrt(r2_w_12);
                float4 r3_xyzw_4 = (r2_w_13.xxxx * float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r3_z_3 = r3_xyzw_4.z;
                float3 r4_xyz_7 = ((r1_w_8.xxxx * _LightColor0.xyzx)).xyz;
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_4.xxxx, r0_xyz_2.xyzx)).xyz;
                float r0_w_5 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_6 = rsqrt(r0_w_5);
                float r0_x_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), r0_xyz_2.xyzx);
                float r0_y_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), ((r0_w_6.xxxx * r1_xyz_2.xyzx)).xyzx);
                float2 r0_xy_4 = (max(float4(r0_x_3, r0_y_3, r0_x_3, r0_x_3), float4(0, 0, 0, 0))).xy;
                float r0_z_3 = (cb0_values[9].x * 128);
                float r0_y_5 = log2(r0_xy_4.y);
                float r0_y_6 = (r0_y_5 * r0_z_3);
                float r0_y_7 = exp2(r0_y_6);
                float r0_y_8 = (r0_y_7 * cb0_values[9].y);
                float4 r0_xyzw_9 = (r0_y_8.xxxx * ((r4_xyz_7.xyzx * _SpecColor.xyzx)).xxyz);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_4 = r0_xyzw_9.z;
                float r0_w_7 = r0_xyzw_9.w;
                float4 r0_xyzw_5 = mad(((((r2_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * r4_xyz_7.xyzx)).xyzx, r0_xy_4.xxxx, float4(r0_y_9, r0_z_4, r0_w_7, r0_y_9));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_10 = r0_xyzw_5.y;
                float r0_z_5 = r0_xyzw_5.z;
                float r0_w_8 = (i.texcoord7.x / cb1_values[5].y);
                float r0_w_9 = (-r0_w_8 + 1);
                float r0_w_10 = (r0_w_9 * cb1_values[5].z);
                float r0_w_11 = max(r0_w_10, 0);
                float r0_w_12 = saturate(mad(r0_w_11, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_10, r0_z_5, r0_x_5) * r0_w_12.xxxx)).xyz;
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
                float4 _SpecColor;
                float4 _Color;
                float _Shininess;
                float _Gloss;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 cb0_values[12];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[10];
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
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float2 texcoord5 : TEXCOORD5;
                float texcoord7 : TEXCOORD7;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program110Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float2 texcoord5 : TEXCOORD5;
                float texcoord7 : TEXCOORD7;
                float4 texcoord6 : TEXCOORD6;
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
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[11].xxxy, cb0_values[11].zzzw)).zw;
                float r2_y_4 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float r2_z_4 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float r2_x_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r2_w_4 = dot(float4(r2_x_4, r2_y_4, r2_z_4, r2_x_4), float4(r2_x_4, r2_y_4, r2_z_4, r2_x_4));
                float r2_w_5 = rsqrt(r2_w_4);
                float3 unitWorldNormal_xyz_5 = ((r2_w_5.xxxx * float4(r2_x_4, r2_y_4, r2_z_4, r2_x_4))).xyz;
                float3 worldTangent_xyz_1 = ((i.tangent0.yyyy * cb2_values[1].yzxy)).xyz;
                float3 worldTangent_xyz_2 = (mad(cb2_values[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_1.xyzx)).xyz;
                float3 worldTangent_xyz_3 = (mad(cb2_values[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_2.xyzx)).xyz;
                float3 unitWorldTangent_xyz_4 = normalize(worldTangent_xyz_3);
                float r2_w_8 = (i.tangent0.w * cb2_values[9].w);
                float3 r4_xyz_3 = ((r2_w_8.xxxx * (mad(unitWorldNormal_xyz_5.zxyz, unitWorldTangent_xyz_4.yzxy, ((unitWorldNormal_xyz_5.xyzx * unitWorldTangent_xyz_4.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r4_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_4.z;
                o.texcoord1.z = unitWorldNormal_xyz_5.y;
                o.texcoord2.x = unitWorldTangent_xyz_4.x;
                o.texcoord3.x = unitWorldTangent_xyz_4.y;
                o.texcoord2.z = unitWorldNormal_xyz_5.z;
                o.texcoord3.z = unitWorldNormal_xyz_5.x;
                o.texcoord2.y = r4_xyz_3.y;
                o.texcoord3.y = r4_xyz_3.z;
                o.texcoord4.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord5.xy = (mad(_BumpMap_ST.xyxx, r0_xyzw_4.wwww, (mad(_MainTex_ST.xyxx, r0_xyzw_4.zzzz, (mad(_Color.xyxx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx)).xy;
                o.texcoord7.x = clipPos_xyzw_2.z;
                o.texcoord6.zw = (clipPos_xyzw_2.zzzw).zw;
                float2 r1_xz_3 = ((clipPos_xyzw_2.xxwx * float4(0.5, 0, 0.5, 0))).xz;
                float r1_w_3 = ((clipPos_xyzw_2.y * unity_WorldToObject[1].x) * 0.5);
                o.texcoord6.xy = ((r1_xz_3.yyyy + float4(r1_xz_3.x, r1_w_3, r1_xz_3.x, r1_xz_3.x))).xy;
                return o;
            }
            #pragma fragment frag
            program110Output frag(program110Input i)
            {
                program110Output o = (program110Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord4.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r2_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r2_x_2 = (r2_xyzw_1.w * r2_xyzw_1.x);
                float4 r2_xyzw_3 = mad(float4(r2_x_2, r2_xyzw_1.y, r2_x_2, r2_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r2_x_3 = r2_xyzw_3.x;
                float r2_y_2 = r2_xyzw_3.y;
                float r1_w_2 = dot(float4(r2_x_3, r2_y_2, r2_x_3, r2_x_3), float4(r2_x_3, r2_y_2, r2_x_3, r2_x_3));
                float r1_w_3 = min(r1_w_2, 1);
                float r1_w_4 = (-r1_w_3 + 1);
                float r2_z_2 = sqrt(r1_w_4);
                float r4_x_1 = cb4_values[9].z;
                float r4_y_1 = cb4_values[10].z;
                float r4_z_1 = cb4_values[11].z;
                float r1_w_5 = dot(viewDir_xyz_1.xyzx, float4(r4_x_1, r4_y_1, r4_z_1, r4_x_1));
                float3 r4_xyz_2 = ((i.texcoord4.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = dot(r4_xyz_2.xyzx, r4_xyz_2.xyzx);
                float r2_w_3 = sqrt(r2_w_2);
                float r2_w_4 = (-r1_w_5 + r2_w_3);
                float r1_w_6 = mad(cb3_values[25].w, r2_w_4, r1_w_5);
                float r1_w_7 = saturate(mad(r1_w_6, cb3_values[24].z, cb3_values[24].w));
                float r2_w_5 = (cb6_values[0].x == 1);
                float r4_x_12;
                float r4_y_12;
                float r4_z_12;
                float r4_w_4;
                if (r2_w_5)
                {
                    float r2_w_6 = (cb6_values[0].y == 1);
                    float3 r4_xyz_7 = (((mad(cb6_values[3].xyzx, i.texcoord4.zzzz, (mad(cb6_values[1].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r4_xyzw_10 = (((((r2_w_6.xxxx ? r4_xyz_7.xyzx : i.texcoord4.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r4_y_10 = r4_xyzw_10.y;
                    float r4_z_10 = r4_xyzw_10.z;
                    float r4_w_2 = r4_xyzw_10.w;
                    float r2_w_7 = mad(r4_y_10, 0.25, 0.75);
                    float r3_z_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r4_x_10 = max(r2_w_7, r3_z_1);
                    float4 r4_xyzw_11 = t4.Sample(sampler_linear_clamp, (float4(r4_x_10, r4_z_10, r4_w_2, r4_x_10)).xyz);
                    r4_x_12 = r4_xyzw_11.x;
                    r4_y_12 = r4_xyzw_11.y;
                    r4_z_12 = r4_xyzw_11.z;
                    r4_w_4 = r4_xyzw_11.w;
                }
                else
                {
                    float4 r4_xyzw_3 = float4(1, 1, 1, 1);
                    r4_x_12 = r4_xyzw_3.x;
                    r4_y_12 = r4_xyzw_3.y;
                    r4_z_12 = r4_xyzw_3.z;
                    r4_w_4 = r4_xyzw_3.w;
                }
                float r2_w_9 = saturate(dot(float4(r4_x_12, r4_y_12, r4_z_12, r4_w_4), unity_OcclusionMaskSelector));
                float4 r3_xyzw_3 = (i.texcoord6.xxxy / i.texcoord6.wwww);
                float r3_z_3 = r3_xyzw_3.z;
                float r3_w_1 = r3_xyzw_3.w;
                float4 r4_xyzw_13 = t2.Sample(sampler_linear_clamp1, (float4(r3_z_3, r3_w_1, r3_z_3, r3_z_3)).xy);
                float r2_w_10 = (r2_w_9 + -r4_xyzw_13.x);
                float r1_w_8 = mad(r1_w_7, r2_w_10, r4_xyzw_13.x);
                float4 r3_xyzw_5 = t3.Sample(sampler_linear_clamp2, ((((mad(cb0_values[6].xyxx, i.texcoord4.zzzz, (mad(cb0_values[4].xyxx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx).xy);
                float r1_w_9 = (r1_w_8 * r3_xyzw_5.w);
                float r3_x_6 = dot(i.texcoord1.xyzx, float4(r2_x_3, r2_y_2, r2_z_2, r2_x_3));
                float r3_y_6 = dot(i.texcoord2.xyzx, float4(r2_x_3, r2_y_2, r2_z_2, r2_x_3));
                float r3_z_5 = dot(i.texcoord3.xyzx, float4(r2_x_3, r2_y_2, r2_z_2, r2_x_3));
                float4 r2_xyzw_6 = ((rsqrt(dot(float4(r3_x_6, r3_y_6, r3_z_5, r3_x_6), float4(r3_x_6, r3_y_6, r3_z_5, r3_x_6)))).xxxx * float4(r3_x_6, r3_y_6, r3_z_5, r3_x_6));
                float r2_x_6 = r2_xyzw_6.x;
                float r2_y_3 = r2_xyzw_6.y;
                float r2_z_3 = r2_xyzw_6.z;
                float4 r3_xyzw_7 = (r1_w_9.xxxx * _LightColor0.xyzx);
                float r3_x_7 = r3_xyzw_7.x;
                float r3_y_7 = r3_xyzw_7.y;
                float r3_z_6 = r3_xyzw_7.z;
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_w_5 = dot(float4(r2_x_6, r2_y_3, r2_z_3, r2_x_6), _WorldSpaceLightPos0.xyzx);
                float r0_x_4 = dot(float4(r2_x_6, r2_y_3, r2_z_3, r2_x_6), ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx);
                float4 r0_xyzw_5 = max(float4(r0_x_4, r0_x_4, r0_x_4, r0_w_5), float4(0, 0, 0, 0));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_w_6 = r0_xyzw_5.w;
                float r0_y_4 = (cb0_values[9].x * 128);
                float4 r2_xyzw_7 = (float4(r3_x_7, r3_y_7, r3_z_6, r3_x_7) * _SpecColor.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_4 = r2_xyzw_7.y;
                float r2_z_4 = r2_xyzw_7.z;
                                float4 r0_xyzw_10 = (((pow(r0_x_5, r0_y_4) * cb0_values[9].y)).xxxx * float4(r2_x_7, r2_y_4, r2_z_4, r2_x_7));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_5 = r0_xyzw_10.y;
                float r0_z_4 = r0_xyzw_10.z;
                float4 r0_xyzw_11 = mad(((((r1_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * float4(r3_x_7, r3_y_7, r3_z_6, r3_x_7))).xyzx, r0_w_6.xxxx, float4(r0_x_10, r0_y_5, r0_z_4, r0_x_10));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_y_6 = r0_xyzw_11.y;
                float r0_z_5 = r0_xyzw_11.z;
                float r0_w_7 = (i.texcoord7.x / cb1_values[5].y);
                float r0_w_8 = (-r0_w_7 + 1);
                float r0_w_9 = (r0_w_8 * cb1_values[5].z);
                float r0_w_10 = max(r0_w_9, 0);
                float r0_w_11 = saturate(mad(r0_w_10, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_11, r0_y_6, r0_z_5, r0_x_11) * r0_w_11.xxxx)).xyz;
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
                float4 _SpecColor;
                float4 _Color;
                float _Shininess;
                float _Gloss;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 cb0_values[6];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[10];
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
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float texcoord7 : TEXCOORD7;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program109Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord7 : TEXCOORD7;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord6 : TEXCOORD6;
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
                o.texcoord4.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord7.x = clipPos_xyzw_7.z;
                float r1_y_2 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float r1_z_2 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float r1_x_2 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_2 = dot(float4(r1_x_2, r1_y_2, r1_z_2, r1_x_2), float4(r1_x_2, r1_y_2, r1_z_2, r1_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                float3 unitWorldNormal_xyz_3 = ((r1_w_3.xxxx * float4(r1_x_2, r1_y_2, r1_z_2, r1_x_2))).xyz;
                float3 worldTangent_xyz_1 = ((i.tangent0.yyyy * cb2_values[1].yzxy)).xyz;
                float3 worldTangent_xyz_2 = (mad(cb2_values[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_1.xyzx)).xyz;
                float3 worldTangent_xyz_3 = (mad(cb2_values[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_2.xyzx)).xyz;
                float3 unitWorldTangent_xyz_4 = normalize(worldTangent_xyz_3);
                float r1_w_6 = (i.tangent0.w * cb2_values[9].w);
                float3 r3_xyz_3 = ((r1_w_6.xxxx * (mad(unitWorldNormal_xyz_3.zxyz, unitWorldTangent_xyz_4.yzxy, ((unitWorldNormal_xyz_3.xyzx * unitWorldTangent_xyz_4.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_4.z;
                o.texcoord1.z = unitWorldNormal_xyz_3.y;
                o.texcoord2.x = unitWorldTangent_xyz_4.x;
                o.texcoord3.x = unitWorldTangent_xyz_4.y;
                o.texcoord2.z = unitWorldNormal_xyz_3.z;
                o.texcoord3.z = unitWorldNormal_xyz_3.x;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r1_xyzw_4 = (float4(clipPos_xyzw_7.x, clipPos_xyzw_7.x, clipPos_xyzw_7.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_z_4 = r1_xyzw_4.z;
                float r1_w_7 = r1_xyzw_4.w;
                o.texcoord6.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord6.xy = ((r1_z_4.xxxx + float4(r1_x_4, r1_w_7, r1_x_4, r1_x_4))).xy;
                return o;
            }
            #pragma fragment frag
            program109Output frag(program109Input i)
            {
                program109Output o = (program109Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord4.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r2_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r2_x_2 = (r2_xyzw_1.w * r2_xyzw_1.x);
                float4 r2_xyzw_3 = mad(float4(r2_x_2, r2_xyzw_1.y, r2_x_2, r2_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r2_x_3 = r2_xyzw_3.x;
                float r2_y_2 = r2_xyzw_3.y;
                float r1_w_2 = dot(float4(r2_x_3, r2_y_2, r2_x_3, r2_x_3), float4(r2_x_3, r2_y_2, r2_x_3, r2_x_3));
                float r1_w_3 = min(r1_w_2, 1);
                float r1_w_4 = (-r1_w_3 + 1);
                float r2_z_2 = sqrt(r1_w_4);
                float r3_x_1 = cb4_values[9].z;
                float r3_y_1 = cb4_values[10].z;
                float r3_z_1 = cb4_values[11].z;
                float r1_w_5 = dot(viewDir_xyz_1.xyzx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float3 r3_xyz_2 = ((i.texcoord4.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = dot(r3_xyz_2.xyzx, r3_xyz_2.xyzx);
                float r2_w_3 = sqrt(r2_w_2);
                float r2_w_4 = (-r1_w_5 + r2_w_3);
                float r1_w_6 = mad(cb3_values[25].w, r2_w_4, r1_w_5);
                float r1_w_7 = saturate(mad(r1_w_6, cb3_values[24].z, cb3_values[24].w));
                float r2_w_5 = (cb6_values[0].x == 1);
                float r3_x_12;
                float r3_y_13;
                float r3_z_12;
                float r3_w_4;
                if (r2_w_5)
                {
                    float r2_w_6 = (cb6_values[0].y == 1);
                    float3 r3_xyz_7 = (((mad(cb6_values[3].xyzx, i.texcoord4.zzzz, (mad(cb6_values[1].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r3_xyzw_10 = (((((r2_w_6.xxxx ? r3_xyz_7.xyzx : i.texcoord4.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r3_y_10 = r3_xyzw_10.y;
                    float r3_z_10 = r3_xyzw_10.z;
                    float r3_w_2 = r3_xyzw_10.w;
                    float r2_w_7 = mad(r3_y_10, 0.25, 0.75);
                    float r3_y_11 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r3_x_10 = max(r2_w_7, r3_y_11);
                    float4 r3_xyzw_11 = t3.Sample(sampler_linear_clamp, (float4(r3_x_10, r3_z_10, r3_w_2, r3_x_10)).xyz);
                    r3_x_12 = r3_xyzw_11.x;
                    r3_y_13 = r3_xyzw_11.y;
                    r3_z_12 = r3_xyzw_11.z;
                    r3_w_4 = r3_xyzw_11.w;
                }
                else
                {
                    float4 r3_xyzw_3 = float4(1, 1, 1, 1);
                    r3_x_12 = r3_xyzw_3.x;
                    r3_y_13 = r3_xyzw_3.y;
                    r3_z_12 = r3_xyzw_3.z;
                    r3_w_4 = r3_xyzw_3.w;
                }
                float r2_w_9 = saturate(dot(float4(r3_x_12, r3_y_13, r3_z_12, r3_w_4), unity_OcclusionMaskSelector));
                float4 r3_xyzw_13 = (i.texcoord6.xyxx / i.texcoord6.wwww);
                float r3_x_13 = r3_xyzw_13.x;
                float r3_y_14 = r3_xyzw_13.y;
                float4 r3_xyzw_14 = t2.Sample(sampler_linear_clamp1, (float4(r3_x_13, r3_y_14, r3_x_13, r3_x_13)).xy);
                float r2_w_10 = (r2_w_9 + -r3_xyzw_14.x);
                float r1_w_8 = mad(r1_w_7, r2_w_10, r3_xyzw_14.x);
                float r3_x_15 = dot(i.texcoord1.xyzx, float4(r2_x_3, r2_y_2, r2_z_2, r2_x_3));
                float r3_y_16 = dot(i.texcoord2.xyzx, float4(r2_x_3, r2_y_2, r2_z_2, r2_x_3));
                float r3_z_14 = dot(i.texcoord3.xyzx, float4(r2_x_3, r2_y_2, r2_z_2, r2_x_3));
                float4 r2_xyzw_6 = ((rsqrt(dot(float4(r3_x_15, r3_y_16, r3_z_14, r3_x_15), float4(r3_x_15, r3_y_16, r3_z_14, r3_x_15)))).xxxx * float4(r3_x_15, r3_y_16, r3_z_14, r3_x_15));
                float r2_x_6 = r2_xyzw_6.x;
                float r2_y_3 = r2_xyzw_6.y;
                float r2_z_3 = r2_xyzw_6.z;
                float4 r3_xyzw_16 = (r1_w_8.xxxx * _LightColor0.xyzx);
                float r3_x_16 = r3_xyzw_16.x;
                float r3_y_17 = r3_xyzw_16.y;
                float r3_z_15 = r3_xyzw_16.z;
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_w_5 = dot(float4(r2_x_6, r2_y_3, r2_z_3, r2_x_6), _WorldSpaceLightPos0.xyzx);
                float r0_x_4 = dot(float4(r2_x_6, r2_y_3, r2_z_3, r2_x_6), ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx);
                float4 r0_xyzw_5 = max(float4(r0_x_4, r0_x_4, r0_x_4, r0_w_5), float4(0, 0, 0, 0));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_w_6 = r0_xyzw_5.w;
                float r0_y_4 = (cb0_values[5].x * 128);
                float4 r2_xyzw_7 = (float4(r3_x_16, r3_y_17, r3_z_15, r3_x_16) * _SpecColor.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_4 = r2_xyzw_7.y;
                float r2_z_4 = r2_xyzw_7.z;
                                float4 r0_xyzw_10 = (((pow(r0_x_5, r0_y_4) * cb0_values[5].y)).xxxx * float4(r2_x_7, r2_y_4, r2_z_4, r2_x_7));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_5 = r0_xyzw_10.y;
                float r0_z_4 = r0_xyzw_10.z;
                float4 r0_xyzw_11 = mad(((((r1_xyzw_1.xyzx * cb0_values[4].xyzx)).xyzx * float4(r3_x_16, r3_y_17, r3_z_15, r3_x_16))).xyzx, r0_w_6.xxxx, float4(r0_x_10, r0_y_5, r0_z_4, r0_x_10));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_y_6 = r0_xyzw_11.y;
                float r0_z_5 = r0_xyzw_11.z;
                float r0_w_7 = (i.texcoord7.x / cb1_values[5].y);
                float r0_w_8 = (-r0_w_7 + 1);
                float r0_w_9 = (r0_w_8 * cb1_values[5].z);
                float r0_w_10 = max(r0_w_9, 0);
                float r0_w_11 = saturate(mad(r0_w_10, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_11, r0_y_6, r0_z_5, r0_x_11) * r0_w_11.xxxx)).xyz;
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
                float4 _SpecColor;
                float4 _Color;
                float _Shininess;
                float _Gloss;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 cb0_values[17];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
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
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float texcoord7 : TEXCOORD7;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program108Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord7 : TEXCOORD7;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
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
                o.texcoord7.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[15].xyxx, cb0_values[15].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[16].xxxy, cb0_values[16].zzzw)).zw;
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                float3 unitWorldNormal_xyz_4 = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_7 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_7.xxxx * (mad(unitWorldNormal_xyz_4.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_4.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_4.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_4.z;
                o.texcoord3.z = unitWorldNormal_xyz_4.x;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord4.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float4 clipPos_xyzw_5 = (worldPos_xyzw_4.yyyy * cb0_values[10].xyzw);
                float4 clipPos_xyzw_6 = mad(cb0_values[9].xyzw, worldPos_xyzw_4.xxxx, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb0_values[11].xyzw, worldPos_xyzw_4.zzzz, clipPos_xyzw_6);
                o.texcoord5.xyzw = mad(cb0_values[12].xyzw, worldPos_xyzw_4.wwww, clipPos_xyzw_7);
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program108Output frag(program108Input i)
            {
                program108Output o = (program108Output)0;
                float3 r0_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r0_xyz_2 = normalize(r0_xyz_1);
                float3 viewDir_xyz_1 = ((-i.texcoord4.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_3 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r3_x_2 = (r3_xyzw_1.w * r3_xyzw_1.x);
                float4 r3_xyzw_3 = mad(float4(r3_x_2, r3_xyzw_1.y, r3_x_2, r3_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r1_w_1 = dot(float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3), float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r3_z_2 = sqrt(r1_w_3);
                float4 r4_xyzw_4 = (mad(cb0_values[11].xyzw, i.texcoord4.zzzz, mad(cb0_values[9].xyzw, i.texcoord4.xxxx, (i.texcoord4.yyyy * cb0_values[10].xyzw))) + cb0_values[12].xyzw);
                float r5_x_1 = cb4_values[9].z;
                float r5_y_1 = cb4_values[10].z;
                float r5_z_1 = cb4_values[11].z;
                float r1_w_4 = dot(viewDir_xyz_1.xyzx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1));
                float3 r5_xyz_2 = ((i.texcoord4.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = dot(r5_xyz_2.xyzx, r5_xyz_2.xyzx);
                float r2_w_3 = sqrt(r2_w_2);
                float r2_w_4 = (-r1_w_4 + r2_w_3);
                float r1_w_5 = mad(cb3_values[25].w, r2_w_4, r1_w_4);
                float r1_w_6 = saturate(mad(r1_w_5, cb3_values[24].z, cb3_values[24].w));
                float r2_w_5 = (cb6_values[0].x == 1);
                float r5_x_12;
                float r5_y_12;
                float r5_z_12;
                float r5_w_4;
                if (r2_w_5)
                {
                    float r2_w_6 = (cb6_values[0].y == 1);
                    float3 r5_xyz_7 = (((mad(cb6_values[3].xyzx, i.texcoord4.zzzz, (mad(cb6_values[1].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r5_xyzw_10 = (((((r2_w_6.xxxx ? r5_xyz_7.xyzx : i.texcoord4.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r5_y_10 = r5_xyzw_10.y;
                    float r5_z_10 = r5_xyzw_10.z;
                    float r5_w_2 = r5_xyzw_10.w;
                    float r2_w_7 = mad(r5_y_10, 0.25, 0.75);
                    float r3_w_2 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r5_x_10 = max(r2_w_7, r3_w_2);
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
                float r2_w_9 = saturate(dot(float4(r5_x_12, r5_y_12, r5_z_12, r5_w_4), unity_OcclusionMaskSelector));
                float r3_w_4 = (r1_w_6 < 0.99);
                float r3_w_11;
                if (r3_w_4)
                {
                    float4 r5_xyzw_13 = (i.texcoord4.yyyy * cb3_values[9].xyzw);
                    float4 r5_xyzw_14 = mad(cb3_values[8].xyzw, i.texcoord4.xxxx, r5_xyzw_13);
                    float4 r5_xyzw_15 = mad(cb3_values[10].xyzw, i.texcoord4.zzzz, r5_xyzw_14);
                    float4 r5_xyzw_16 = (r5_xyzw_15 + cb3_values[11].xyzw);
                    float3 r5_xyz_17 = ((r5_xyzw_16.xyzx / r5_xyzw_16.wwww)).xyz;
                    float2 r6_xy_2 = (floor((mad(r5_xyz_17.xyxx, cb0_values[8].zwzz, float4(0.5, 0.5, 0, 0))).xyxx)).xy;
                    float2 r5_xy_18 = (mad(r5_xyz_17.xyxx, cb0_values[8].zwzz, -r6_xy_2.xyxx)).xy;
                    float4 r7_xyzw_1 = (r5_xy_18.xxyy + float4(0.5, 1, 0.5, 1));
                    float2 r8_xw_1 = ((r7_xyzw_1.xxxz * r7_xyzw_1.xxxz)).xw;
                    float2 r6_zw_1 = (mad(r8_xw_1.xxxy, float4(0, 0, 0.5, 0.5), -r5_xy_18.xxxy)).zw;
                    float2 r7_xz_2 = ((-r5_xy_18.xxyx + float4(1, 0, 1, 0))).xz;
                    float2 r9_xy_1 = (min(r5_xy_18.xyxx, float4(0, 0, 0, 0))).xy;
                    float2 r7_xz_3 = (mad(-r9_xy_1.xxyx, r9_xy_1.xxyx, r7_xz_2.xxyx)).xz;
                    float2 r5_xy_19 = (max(r5_xy_18.xyxx, float4(0, 0, 0, 0))).xy;
                    float2 r5_xy_20 = (mad(-r5_xy_19.xyxx, r5_xy_19.xyxx, r7_xyzw_1.ywyy)).xy;
                    float r9_x_2 = r6_zw_1.x;
                    float r9_y_2 = r7_xz_3.x;
                    float r9_z_1 = r5_xy_20.x;
                    float r9_w_1 = r8_xw_1.x;
                    float4 r9_xyzw_3 = (float4(r9_x_2, r9_y_2, r9_z_1, r9_w_1) * float4(0.44444, 0.44444, 0.44444, 0.22222));
                    float r8_x_2 = r6_zw_1.y;
                    float r8_y_1 = r7_xz_3.y;
                    float r8_z_1 = r5_xy_20.y;
                    float4 r7_xyzw_4 = (float4(r8_x_2, r8_y_1, r8_z_1, r8_xw_1.y) * float4(0.44444, 0.44444, 0.44444, 0.22222));
                    float4 r8_xyzw_3 = (r9_xyzw_3.ywyw + r9_xyzw_3.xzxz);
                    float4 r10_xyzw_1 = (r7_xyzw_4.yyww + r7_xyzw_4.xxzz);
                    float2 r6_zw_2 = ((r7_xyzw_4.yyyw / r10_xyzw_1.yyyw)).zw;
                    float2 r6_zw_3 = ((r6_zw_2.xxxy + float4(0, 0, -1.5, 0.5))).zw;
                    float4 r7_xyzw_5 = (((((r9_xyzw_3.ywyy / r8_xyzw_3.zwzz)).xyxx + float4(-1.5, 0.5, 0, 0))).xyxx * cb0_values[8].xxxx);
                    float r7_x_5 = r7_xyzw_5.x;
                    float r7_y_3 = r7_xyzw_5.y;
                    float r7_z_5 = ((r6_zw_3.xxxy * cb0_values[8].yyyy)).z;
                    float r7_w_3 = ((r6_zw_3.xxxy * cb0_values[8].yyyy)).w;
                    float4 r8_xyzw_4 = (r8_xyzw_3 * r10_xyzw_1);
                    float4 r9_xyzw_4 = mad(r6_xy_2.xyxy, cb0_values[8].xyxy, float4(r7_x_5, r7_z_5, r7_y_3, r7_z_5));
                    float r3_w_6 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r9_xyzw_4.xyxx).xy, r5_xyz_17.z);
                    float r5_x_23 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r9_xyzw_4.zwzz).xy, r5_xyz_17.z);
                    float r3_w_7 = mad(r8_xyzw_4.x, r3_w_6, (r5_x_23 * r8_xyzw_4.y));
                    float4 r6_xyzw_3 = mad(r6_xy_2.xyxy, cb0_values[8].xyxy, float4(r7_x_5, r7_w_3, r7_y_3, r7_w_3));
                    float r5_x_25 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r6_xyzw_3.xyxx).xy, r5_xyz_17.z);
                    float r3_w_8 = mad(r8_xyzw_4.z, r5_x_25, r3_w_7);
                    float r5_x_26 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r6_xyzw_3.zwzz).xy, r5_xyz_17.z);
                    float r3_w_9 = mad(r8_xyzw_4.w, r5_x_26, r3_w_8);
                    float r3_w_10 = mad(r3_w_9, (-cb3_values[24].x + 1), cb3_values[24].x);
                    r3_w_11 = r3_w_10;
                }
                else
                {
                    float r3_w_5 = 1;
                    r3_w_11 = r3_w_5;
                }
                float r2_w_10 = (r2_w_9 + -r3_w_11);
                float r1_w_7 = mad(r1_w_6, r2_w_10, r3_w_11);
                float r2_w_11 = (0 < r4_xyzw_4.z);
                float r2_w_12 = asfloat(asint(r2_w_11) & asint(1065353216));
                float4 r5_xyzw_29 = (r4_xyzw_4.xyxx / r4_xyzw_4.wwww);
                float r5_x_29 = r5_xyzw_29.x;
                float r5_y_24 = r5_xyzw_29.y;
                float4 r5_xyzw_30 = (float4(r5_x_29, r5_y_24, r5_x_29, r5_x_29) + float4(0.5, 0.5, 0, 0));
                float r5_x_30 = r5_xyzw_30.x;
                float r5_y_25 = r5_xyzw_30.y;
                float4 r5_xyzw_31 = t2.Sample(sampler_linear_clamp2, (float4(r5_x_30, r5_y_25, r5_x_30, r5_x_30)).xy);
                float r2_w_13 = (r2_w_12 * r5_xyzw_31.w);
                float r3_w_12 = dot(r4_xyzw_4.xyzx, r4_xyzw_4.xyzx);
                float4 r4_xyzw_5 = t3.Sample(sampler_linear_clamp3, (r3_w_12.xxxx).xy);
                float r2_w_14 = (r2_w_13 * r4_xyzw_5.x);
                float r1_w_8 = (r1_w_7 * r2_w_14);
                float r4_x_6 = dot(i.texcoord1.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_y_6 = dot(i.texcoord2.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_z_6 = dot(i.texcoord3.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r2_w_15 = dot(float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6), float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r2_w_16 = rsqrt(r2_w_15);
                float4 r3_xyzw_4 = (r2_w_16.xxxx * float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r3_z_3 = r3_xyzw_4.z;
                float3 r4_xyz_7 = ((r1_w_8.xxxx * _LightColor0.xyzx)).xyz;
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_4.xxxx, r0_xyz_2.xyzx)).xyz;
                float r0_w_5 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_6 = rsqrt(r0_w_5);
                float r0_x_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), r0_xyz_2.xyzx);
                float r0_y_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), ((r0_w_6.xxxx * r1_xyz_2.xyzx)).xyzx);
                float2 r0_xy_4 = (max(float4(r0_x_3, r0_y_3, r0_x_3, r0_x_3), float4(0, 0, 0, 0))).xy;
                float r0_z_3 = (cb0_values[14].x * 128);
                float r0_y_5 = log2(r0_xy_4.y);
                float r0_y_6 = (r0_y_5 * r0_z_3);
                float r0_y_7 = exp2(r0_y_6);
                float r0_y_8 = (r0_y_7 * cb0_values[14].y);
                float4 r0_xyzw_9 = (r0_y_8.xxxx * ((r4_xyz_7.xyzx * _SpecColor.xyzx)).xxyz);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_4 = r0_xyzw_9.z;
                float r0_w_7 = r0_xyzw_9.w;
                float4 r0_xyzw_5 = mad(((((r2_xyzw_1.xyzx * cb0_values[13].xyzx)).xyzx * r4_xyz_7.xyzx)).xyzx, r0_xy_4.xxxx, float4(r0_y_9, r0_z_4, r0_w_7, r0_y_9));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_10 = r0_xyzw_5.y;
                float r0_z_5 = r0_xyzw_5.z;
                float r0_w_8 = (i.texcoord7.x / cb1_values[5].y);
                float r0_w_9 = (-r0_w_8 + 1);
                float r0_w_10 = (r0_w_9 * cb1_values[5].z);
                float r0_w_11 = max(r0_w_10, 0);
                float r0_w_12 = saturate(mad(r0_w_11, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_10, r0_z_5, r0_x_5) * r0_w_12.xxxx)).xyz;
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
                float4 _SpecColor;
                float4 _Color;
                float _Shininess;
                float _Gloss;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 cb0_values[12];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
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
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float texcoord7 : TEXCOORD7;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program107Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord7 : TEXCOORD7;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
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
                o.texcoord7.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[11].xxxy, cb0_values[11].zzzw)).zw;
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                float3 unitWorldNormal_xyz_4 = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_7 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_7.xxxx * (mad(unitWorldNormal_xyz_4.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_4.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_4.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_4.z;
                o.texcoord3.z = unitWorldNormal_xyz_4.x;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord4.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float4 clipPos_xyzw_5 = (worldPos_xyzw_4.yyyy * cb0_values[5].xyzw);
                float4 clipPos_xyzw_6 = mad(_Color, worldPos_xyzw_4.xxxx, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(_MainTex_ST, worldPos_xyzw_4.zzzz, clipPos_xyzw_6);
                o.texcoord5.xyzw = mad(_BumpMap_ST, worldPos_xyzw_4.wwww, clipPos_xyzw_7);
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program107Output frag(program107Input i)
            {
                program107Output o = (program107Output)0;
                float3 r0_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r0_xyz_2 = normalize(r0_xyz_1);
                float3 viewDir_xyz_1 = ((-i.texcoord4.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_3 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r3_x_2 = (r3_xyzw_1.w * r3_xyzw_1.x);
                float4 r3_xyzw_3 = mad(float4(r3_x_2, r3_xyzw_1.y, r3_x_2, r3_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r1_w_1 = dot(float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3), float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r3_z_2 = sqrt(r1_w_3);
                float4 r4_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord4.zzzz, mad(cb0_values[4].xyzw, i.texcoord4.xxxx, (i.texcoord4.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r5_x_1 = cb4_values[9].z;
                float r5_y_1 = cb4_values[10].z;
                float r5_z_1 = cb4_values[11].z;
                float r1_w_4 = dot(viewDir_xyz_1.xyzx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1));
                float3 r5_xyz_2 = ((i.texcoord4.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = dot(r5_xyz_2.xyzx, r5_xyz_2.xyzx);
                float r2_w_3 = sqrt(r2_w_2);
                float r2_w_4 = (-r1_w_4 + r2_w_3);
                float r1_w_5 = mad(cb3_values[25].w, r2_w_4, r1_w_4);
                float r1_w_6 = saturate(mad(r1_w_5, cb3_values[24].z, cb3_values[24].w));
                float r2_w_5 = (cb6_values[0].x == 1);
                float r5_x_12;
                float r5_y_12;
                float r5_z_12;
                float r5_w_4;
                if (r2_w_5)
                {
                    float r2_w_6 = (cb6_values[0].y == 1);
                    float3 r5_xyz_7 = (((mad(cb6_values[3].xyzx, i.texcoord4.zzzz, (mad(cb6_values[1].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r5_xyzw_10 = (((((r2_w_6.xxxx ? r5_xyz_7.xyzx : i.texcoord4.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r5_y_10 = r5_xyzw_10.y;
                    float r5_z_10 = r5_xyzw_10.z;
                    float r5_w_2 = r5_xyzw_10.w;
                    float r2_w_7 = mad(r5_y_10, 0.25, 0.75);
                    float r3_w_2 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r5_x_10 = max(r2_w_7, r3_w_2);
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
                float r2_w_9 = saturate(dot(float4(r5_x_12, r5_y_12, r5_z_12, r5_w_4), unity_OcclusionMaskSelector));
                float4 r5_xyzw_13 = (i.texcoord4.yyyy * cb3_values[9].xyzw);
                float4 r5_xyzw_14 = mad(cb3_values[8].xyzw, i.texcoord4.xxxx, r5_xyzw_13);
                float4 r5_xyzw_15 = mad(cb3_values[10].xyzw, i.texcoord4.zzzz, r5_xyzw_14);
                float4 r5_xyzw_16 = (r5_xyzw_15 + cb3_values[11].xyzw);
                float3 r5_xyz_17 = ((r5_xyzw_16.xyzx / r5_xyzw_16.wwww)).xyz;
                float r3_w_4 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r5_xyz_17.xyxx).xy, r5_xyz_17.z);
                float r3_w_5 = mad(r3_w_4, (-cb3_values[24].x + 1), cb3_values[24].x);
                float r2_w_10 = (r2_w_9 + -r3_w_5);
                float r1_w_7 = mad(r1_w_6, r2_w_10, r3_w_5);
                float r2_w_11 = (0 < r4_xyzw_4.z);
                float r2_w_12 = asfloat(asint(r2_w_11) & asint(1065353216));
                float4 r5_xyzw_19 = (r4_xyzw_4.xyxx / r4_xyzw_4.wwww);
                float r5_x_19 = r5_xyzw_19.x;
                float r5_y_18 = r5_xyzw_19.y;
                float4 r5_xyzw_20 = (float4(r5_x_19, r5_y_18, r5_x_19, r5_x_19) + float4(0.5, 0.5, 0, 0));
                float r5_x_20 = r5_xyzw_20.x;
                float r5_y_19 = r5_xyzw_20.y;
                float4 r5_xyzw_21 = t2.Sample(sampler_linear_clamp2, (float4(r5_x_20, r5_y_19, r5_x_20, r5_x_20)).xy);
                float r2_w_13 = (r2_w_12 * r5_xyzw_21.w);
                float r3_w_6 = dot(r4_xyzw_4.xyzx, r4_xyzw_4.xyzx);
                float4 r4_xyzw_5 = t3.Sample(sampler_linear_clamp3, (r3_w_6.xxxx).xy);
                float r2_w_14 = (r2_w_13 * r4_xyzw_5.x);
                float r1_w_8 = (r1_w_7 * r2_w_14);
                float r4_x_6 = dot(i.texcoord1.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_y_6 = dot(i.texcoord2.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_z_6 = dot(i.texcoord3.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r2_w_15 = dot(float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6), float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r2_w_16 = rsqrt(r2_w_15);
                float4 r3_xyzw_4 = (r2_w_16.xxxx * float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r3_z_3 = r3_xyzw_4.z;
                float3 r4_xyz_7 = ((r1_w_8.xxxx * _LightColor0.xyzx)).xyz;
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_4.xxxx, r0_xyz_2.xyzx)).xyz;
                float r0_w_5 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_6 = rsqrt(r0_w_5);
                float r0_x_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), r0_xyz_2.xyzx);
                float r0_y_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), ((r0_w_6.xxxx * r1_xyz_2.xyzx)).xyzx);
                float2 r0_xy_4 = (max(float4(r0_x_3, r0_y_3, r0_x_3, r0_x_3), float4(0, 0, 0, 0))).xy;
                float r0_z_3 = (cb0_values[9].x * 128);
                float r0_y_5 = log2(r0_xy_4.y);
                float r0_y_6 = (r0_y_5 * r0_z_3);
                float r0_y_7 = exp2(r0_y_6);
                float r0_y_8 = (r0_y_7 * cb0_values[9].y);
                float4 r0_xyzw_9 = (r0_y_8.xxxx * ((r4_xyz_7.xyzx * _SpecColor.xyzx)).xxyz);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_4 = r0_xyzw_9.z;
                float r0_w_7 = r0_xyzw_9.w;
                float4 r0_xyzw_5 = mad(((((r2_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * r4_xyz_7.xyzx)).xyzx, r0_xy_4.xxxx, float4(r0_y_9, r0_z_4, r0_w_7, r0_y_9));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_10 = r0_xyzw_5.y;
                float r0_z_5 = r0_xyzw_5.z;
                float r0_w_8 = (i.texcoord7.x / cb1_values[5].y);
                float r0_w_9 = (-r0_w_8 + 1);
                float r0_w_10 = (r0_w_9 * cb1_values[5].z);
                float r0_w_11 = max(r0_w_10, 0);
                float r0_w_12 = saturate(mad(r0_w_11, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_10, r0_z_5, r0_x_5) * r0_w_12.xxxx)).xyz;
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
                float4 _SpecColor;
                float4 _Color;
                float _Shininess;
                float _Gloss;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 cb0_values[12];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
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
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float2 texcoord5 : TEXCOORD5;
                float texcoord7 : TEXCOORD7;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program106Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float2 texcoord5 : TEXCOORD5;
                float texcoord7 : TEXCOORD7;
                float4 texcoord6 : TEXCOORD6;
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
                o.texcoord7.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[11].xxxy, cb0_values[11].zzzw)).zw;
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                float3 unitWorldNormal_xyz_4 = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_7 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_7.xxxx * (mad(unitWorldNormal_xyz_4.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_4.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_4.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_4.z;
                o.texcoord3.z = unitWorldNormal_xyz_4.x;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord4.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float2 clipPos_xy_5 = (mad(_Color.xyxx, worldPos_xyzw_4.xxxx, ((worldPos_xyzw_4.yyyy * cb0_values[5].xyxx)).xyxx)).xy;
                float2 clipPos_xy_6 = (mad(_MainTex_ST.xyxx, worldPos_xyzw_4.zzzz, clipPos_xy_5.xyxx)).xy;
                o.texcoord5.xy = (mad(_BumpMap_ST.xyxx, worldPos_xyzw_4.wwww, clipPos_xy_6.xyxx)).xy;
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program106Output frag(program106Input i)
            {
                program106Output o = (program106Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord4.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r2_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r2_x_2 = (r2_xyzw_1.w * r2_xyzw_1.x);
                float4 r2_xyzw_3 = mad(float4(r2_x_2, r2_xyzw_1.y, r2_x_2, r2_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r2_x_3 = r2_xyzw_3.x;
                float r2_y_2 = r2_xyzw_3.y;
                float r1_w_2 = dot(float4(r2_x_3, r2_y_2, r2_x_3, r2_x_3), float4(r2_x_3, r2_y_2, r2_x_3, r2_x_3));
                float r1_w_3 = min(r1_w_2, 1);
                float r1_w_4 = (-r1_w_3 + 1);
                float r2_z_2 = sqrt(r1_w_4);
                float r1_w_5 = (cb4_values[0].x == 1);
                float r4_x_10;
                float r4_y_10;
                float r4_z_10;
                float r4_w_4;
                if (r1_w_5)
                {
                    float r1_w_6 = (cb4_values[0].y == 1);
                    float3 r4_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord4.zzzz, (mad(cb4_values[1].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r4_xyzw_8 = (((((r1_w_6.xxxx ? r4_xyz_5.xyzx : i.texcoord4.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r4_y_8 = r4_xyzw_8.y;
                    float r4_z_8 = r4_xyzw_8.z;
                    float r4_w_2 = r4_xyzw_8.w;
                    float r1_w_7 = mad(r4_y_8, 0.25, 0.75);
                    float r2_w_2 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r4_x_8 = max(r1_w_7, r2_w_2);
                    float4 r4_xyzw_9 = t3.Sample(sampler_linear_clamp, (float4(r4_x_8, r4_z_8, r4_w_2, r4_x_8)).xyz);
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
                float r1_w_9 = saturate(dot(float4(r4_x_10, r4_y_10, r4_z_10, r4_w_4), unity_OcclusionMaskSelector));
                float4 r3_xyzw_5 = t2.Sample(sampler_linear_clamp1, ((((mad(cb0_values[6].xyxx, i.texcoord4.zzzz, (mad(cb0_values[4].xyxx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx).xy);
                float r1_w_10 = (r1_w_9 * r3_xyzw_5.w);
                float r3_x_6 = dot(i.texcoord1.xyzx, float4(r2_x_3, r2_y_2, r2_z_2, r2_x_3));
                float r3_y_6 = dot(i.texcoord2.xyzx, float4(r2_x_3, r2_y_2, r2_z_2, r2_x_3));
                float r3_z_2 = dot(i.texcoord3.xyzx, float4(r2_x_3, r2_y_2, r2_z_2, r2_x_3));
                float4 r2_xyzw_6 = ((rsqrt(dot(float4(r3_x_6, r3_y_6, r3_z_2, r3_x_6), float4(r3_x_6, r3_y_6, r3_z_2, r3_x_6)))).xxxx * float4(r3_x_6, r3_y_6, r3_z_2, r3_x_6));
                float r2_x_6 = r2_xyzw_6.x;
                float r2_y_3 = r2_xyzw_6.y;
                float r2_z_3 = r2_xyzw_6.z;
                float4 r3_xyzw_7 = (r1_w_10.xxxx * _LightColor0.xyzx);
                float r3_x_7 = r3_xyzw_7.x;
                float r3_y_7 = r3_xyzw_7.y;
                float r3_z_3 = r3_xyzw_7.z;
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_w_5 = dot(float4(r2_x_6, r2_y_3, r2_z_3, r2_x_6), _WorldSpaceLightPos0.xyzx);
                float r0_x_4 = dot(float4(r2_x_6, r2_y_3, r2_z_3, r2_x_6), ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx);
                float4 r0_xyzw_5 = max(float4(r0_x_4, r0_x_4, r0_x_4, r0_w_5), float4(0, 0, 0, 0));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_w_6 = r0_xyzw_5.w;
                float r0_y_4 = (cb0_values[9].x * 128);
                float4 r2_xyzw_7 = (float4(r3_x_7, r3_y_7, r3_z_3, r3_x_7) * _SpecColor.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_4 = r2_xyzw_7.y;
                float r2_z_4 = r2_xyzw_7.z;
                                float4 r0_xyzw_10 = (((pow(r0_x_5, r0_y_4) * cb0_values[9].y)).xxxx * float4(r2_x_7, r2_y_4, r2_z_4, r2_x_7));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_5 = r0_xyzw_10.y;
                float r0_z_4 = r0_xyzw_10.z;
                float4 r0_xyzw_11 = mad(((((r1_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * float4(r3_x_7, r3_y_7, r3_z_3, r3_x_7))).xyzx, r0_w_6.xxxx, float4(r0_x_10, r0_y_5, r0_z_4, r0_x_10));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_y_6 = r0_xyzw_11.y;
                float r0_z_5 = r0_xyzw_11.z;
                float r0_w_7 = (i.texcoord7.x / cb1_values[5].y);
                float r0_w_8 = (-r0_w_7 + 1);
                float r0_w_9 = (r0_w_8 * cb1_values[5].z);
                float r0_w_10 = max(r0_w_9, 0);
                float r0_w_11 = saturate(mad(r0_w_10, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w));
                o.sv_Target0.xyz = ((float4(r0_x_11, r0_y_6, r0_z_5, r0_x_11) * r0_w_11.xxxx)).xyz;
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
                float4 _SpecColor;
                float4 _Color;
                float _Shininess;
                float _Gloss;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 cb0_values[12];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
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
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float texcoord7 : TEXCOORD7;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program105Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord7 : TEXCOORD7;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
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
                o.texcoord7.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[11].xxxy, cb0_values[11].zzzw)).zw;
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                float3 unitWorldNormal_xyz_4 = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_7 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_7.xxxx * (mad(unitWorldNormal_xyz_4.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_4.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_4.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_4.z;
                o.texcoord3.z = unitWorldNormal_xyz_4.x;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord4.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_6 = (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, ((worldPos_xyzw_4.yyyy * cb0_values[5].xyzx)).xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.zzzz, clipPos_xyz_6.xyzx)).xyz;
                o.texcoord5.xyz = (mad(_BumpMap_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program105Output frag(program105Input i)
            {
                program105Output o = (program105Output)0;
                float3 r0_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r0_xyz_2 = normalize(r0_xyz_1);
                float3 viewDir_xyz_1 = ((-i.texcoord4.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_3 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r3_x_2 = (r3_xyzw_1.w * r3_xyzw_1.x);
                float4 r3_xyzw_3 = mad(float4(r3_x_2, r3_xyzw_1.y, r3_x_2, r3_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r1_w_1 = dot(float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3), float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r3_z_2 = sqrt(r1_w_3);
                float3 r4_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord4.zzzz, (mad(cb0_values[4].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r1_w_4 = (cb4_values[0].x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r1_w_4)
                {
                    float r1_w_5 = (cb4_values[0].y == 1);
                    float3 r5_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord4.zzzz, (mad(cb4_values[1].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r5_xyzw_8 = (((((r1_w_5.xxxx ? r5_xyz_5.xyzx : i.texcoord4.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r1_w_6 = mad(r5_y_8, 0.25, 0.75);
                    float r2_w_2 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r5_x_8 = max(r1_w_6, r2_w_2);
                    float4 r5_xyzw_9 = t4.Sample(sampler_linear_clamp, (float4(r5_x_8, r5_z_8, r5_w_2, r5_x_8)).xyz);
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
                float r2_w_4 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float4 r5_xyzw_11 = t2.Sample(sampler_linear_clamp2, (r2_w_4.xxxx).xy);
                float4 r4_xyzw_5 = t3.Sample(sampler_linear_clamp1, r4_xyz_4.xyz);
                float r2_w_5 = (r4_xyzw_5.w * r5_xyzw_11.x);
                float r1_w_9 = (r1_w_8 * r2_w_5);
                float r4_x_6 = dot(i.texcoord1.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_y_6 = dot(i.texcoord2.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_z_6 = dot(i.texcoord3.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r2_w_6 = dot(float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6), float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r2_w_7 = rsqrt(r2_w_6);
                float4 r3_xyzw_4 = (r2_w_7.xxxx * float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r3_z_3 = r3_xyzw_4.z;
                float3 r4_xyz_7 = ((r1_w_9.xxxx * _LightColor0.xyzx)).xyz;
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_4.xxxx, r0_xyz_2.xyzx)).xyz;
                float r0_w_5 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_6 = rsqrt(r0_w_5);
                float r0_x_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), r0_xyz_2.xyzx);
                float r0_y_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), ((r0_w_6.xxxx * r1_xyz_2.xyzx)).xyzx);
                float2 r0_xy_4 = (max(float4(r0_x_3, r0_y_3, r0_x_3, r0_x_3), float4(0, 0, 0, 0))).xy;
                float r0_z_3 = (cb0_values[9].x * 128);
                float r0_y_5 = log2(r0_xy_4.y);
                float r0_y_6 = (r0_y_5 * r0_z_3);
                float r0_y_7 = exp2(r0_y_6);
                float r0_y_8 = (r0_y_7 * cb0_values[9].y);
                float4 r0_xyzw_9 = (r0_y_8.xxxx * ((r4_xyz_7.xyzx * _SpecColor.xyzx)).xxyz);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_4 = r0_xyzw_9.z;
                float r0_w_7 = r0_xyzw_9.w;
                float4 r0_xyzw_5 = mad(((((r2_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * r4_xyz_7.xyzx)).xyzx, r0_xy_4.xxxx, float4(r0_y_9, r0_z_4, r0_w_7, r0_y_9));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_10 = r0_xyzw_5.y;
                float r0_z_5 = r0_xyzw_5.z;
                float r0_w_8 = (i.texcoord7.x / cb1_values[5].y);
                float r0_w_9 = (-r0_w_8 + 1);
                float r0_w_10 = (r0_w_9 * cb1_values[5].z);
                float r0_w_11 = max(r0_w_10, 0);
                float r0_w_12 = saturate(mad(r0_w_11, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w));
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_10, r0_z_5, r0_x_5) * r0_w_12.xxxx)).xyz;
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
                float4 _SpecColor;
                float4 _Color;
                float _Shininess;
                float _Gloss;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 cb0_values[12];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
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
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float texcoord7 : TEXCOORD7;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program104Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord7 : TEXCOORD7;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
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
                o.texcoord7.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[11].xxxy, cb0_values[11].zzzw)).zw;
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                float3 unitWorldNormal_xyz_4 = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_7 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_7.xxxx * (mad(unitWorldNormal_xyz_4.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_4.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_4.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_4.z;
                o.texcoord3.z = unitWorldNormal_xyz_4.x;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord4.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float4 clipPos_xyzw_5 = (worldPos_xyzw_4.yyyy * cb0_values[5].xyzw);
                float4 clipPos_xyzw_6 = mad(_Color, worldPos_xyzw_4.xxxx, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(_MainTex_ST, worldPos_xyzw_4.zzzz, clipPos_xyzw_6);
                o.texcoord5.xyzw = mad(_BumpMap_ST, worldPos_xyzw_4.wwww, clipPos_xyzw_7);
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program104Output frag(program104Input i)
            {
                program104Output o = (program104Output)0;
                float3 r0_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r0_xyz_2 = normalize(r0_xyz_1);
                float3 viewDir_xyz_1 = ((-i.texcoord4.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_3 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r3_x_2 = (r3_xyzw_1.w * r3_xyzw_1.x);
                float4 r3_xyzw_3 = mad(float4(r3_x_2, r3_xyzw_1.y, r3_x_2, r3_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r1_w_1 = dot(float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3), float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r3_z_2 = sqrt(r1_w_3);
                float4 r4_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord4.zzzz, mad(cb0_values[4].xyzw, i.texcoord4.xxxx, (i.texcoord4.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r1_w_4 = (cb4_values[0].x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r1_w_4)
                {
                    float r1_w_5 = (cb4_values[0].y == 1);
                    float3 r5_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord4.zzzz, (mad(cb4_values[1].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r5_xyzw_8 = (((((r1_w_5.xxxx ? r5_xyz_5.xyzx : i.texcoord4.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r1_w_6 = mad(r5_y_8, 0.25, 0.75);
                    float r2_w_2 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r5_x_8 = max(r1_w_6, r2_w_2);
                    float4 r5_xyzw_9 = t4.Sample(sampler_linear_clamp, (float4(r5_x_8, r5_z_8, r5_w_2, r5_x_8)).xyz);
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
                float r2_w_4 = (0 < r4_xyzw_4.z);
                float r2_w_5 = asfloat(asint(r2_w_4) & asint(1065353216));
                float4 r5_xyzw_13 = t2.Sample(sampler_linear_clamp1, (((((r4_xyzw_4.xyxx / r4_xyzw_4.wwww)).xyxx + float4(0.5, 0.5, 0, 0))).xyxx).xy);
                float r2_w_6 = (r2_w_5 * r5_xyzw_13.w);
                float r3_w_2 = dot(r4_xyzw_4.xyzx, r4_xyzw_4.xyzx);
                float4 r4_xyzw_5 = t3.Sample(sampler_linear_clamp2, (r3_w_2.xxxx).xy);
                float r2_w_7 = (r2_w_6 * r4_xyzw_5.x);
                float r1_w_9 = (r1_w_8 * r2_w_7);
                float r4_x_6 = dot(i.texcoord1.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_y_6 = dot(i.texcoord2.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_z_6 = dot(i.texcoord3.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r2_w_8 = dot(float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6), float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r2_w_9 = rsqrt(r2_w_8);
                float4 r3_xyzw_4 = (r2_w_9.xxxx * float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r3_z_3 = r3_xyzw_4.z;
                float3 r4_xyz_7 = ((r1_w_9.xxxx * _LightColor0.xyzx)).xyz;
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_4.xxxx, r0_xyz_2.xyzx)).xyz;
                float r0_w_5 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_6 = rsqrt(r0_w_5);
                float r0_x_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), r0_xyz_2.xyzx);
                float r0_y_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), ((r0_w_6.xxxx * r1_xyz_2.xyzx)).xyzx);
                float2 r0_xy_4 = (max(float4(r0_x_3, r0_y_3, r0_x_3, r0_x_3), float4(0, 0, 0, 0))).xy;
                float r0_z_3 = (cb0_values[9].x * 128);
                float r0_y_5 = log2(r0_xy_4.y);
                float r0_y_6 = (r0_y_5 * r0_z_3);
                float r0_y_7 = exp2(r0_y_6);
                float r0_y_8 = (r0_y_7 * cb0_values[9].y);
                float4 r0_xyzw_9 = (r0_y_8.xxxx * ((r4_xyz_7.xyzx * _SpecColor.xyzx)).xxyz);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_4 = r0_xyzw_9.z;
                float r0_w_7 = r0_xyzw_9.w;
                float4 r0_xyzw_5 = mad(((((r2_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * r4_xyz_7.xyzx)).xyzx, r0_xy_4.xxxx, float4(r0_y_9, r0_z_4, r0_w_7, r0_y_9));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_10 = r0_xyzw_5.y;
                float r0_z_5 = r0_xyzw_5.z;
                float r0_w_8 = (i.texcoord7.x / cb1_values[5].y);
                float r0_w_9 = (-r0_w_8 + 1);
                float r0_w_10 = (r0_w_9 * cb1_values[5].z);
                float r0_w_11 = max(r0_w_10, 0);
                float r0_w_12 = saturate(mad(r0_w_11, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w));
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_10, r0_z_5, r0_x_5) * r0_w_12.xxxx)).xyz;
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
                float4 _SpecColor;
                float4 _Color;
                float _Shininess;
                float _Gloss;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 cb0_values[6];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
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
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float texcoord7 : TEXCOORD7;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program103Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord7 : TEXCOORD7;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord6 : TEXCOORD6;
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
                o.texcoord4.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord7.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                float3 unitWorldNormal_xyz_9 = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                float3 worldTangent_xyz_2 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_3 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_2.xyzx)).xyz;
                float3 worldTangent_xyz_4 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_3.xyzx)).xyz;
                float3 unitWorldTangent_xyz_5 = normalize(worldTangent_xyz_4);
                float r0_w_12 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r2_xyz_3 = ((r0_w_12.xxxx * (mad(unitWorldNormal_xyz_9.zxyz, unitWorldTangent_xyz_5.yzxy, ((unitWorldNormal_xyz_9.xyzx * unitWorldTangent_xyz_5.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r2_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_5.z;
                o.texcoord1.z = unitWorldNormal_xyz_9.y;
                o.texcoord2.x = unitWorldTangent_xyz_5.x;
                o.texcoord3.x = unitWorldTangent_xyz_5.y;
                o.texcoord2.z = unitWorldNormal_xyz_9.z;
                o.texcoord3.z = unitWorldNormal_xyz_9.x;
                o.texcoord2.y = r2_xyz_3.y;
                o.texcoord3.y = r2_xyz_3.z;
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program103Output frag(program103Input i)
            {
                program103Output o = (program103Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord4.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r2_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r2_x_2 = (r2_xyzw_1.w * r2_xyzw_1.x);
                float4 r2_xyzw_3 = mad(float4(r2_x_2, r2_xyzw_1.y, r2_x_2, r2_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r2_x_3 = r2_xyzw_3.x;
                float r2_y_2 = r2_xyzw_3.y;
                float r1_w_2 = dot(float4(r2_x_3, r2_y_2, r2_x_3, r2_x_3), float4(r2_x_3, r2_y_2, r2_x_3, r2_x_3));
                float r1_w_3 = min(r1_w_2, 1);
                float r1_w_4 = (-r1_w_3 + 1);
                float r2_z_2 = sqrt(r1_w_4);
                float r1_w_5 = (cb4_values[0].x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r1_w_5)
                {
                    float r1_w_6 = (cb4_values[0].y == 1);
                    float3 r3_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord4.zzzz, (mad(cb4_values[1].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r3_xyzw_8 = (((((r1_w_6.xxxx ? r3_xyz_5.xyzx : i.texcoord4.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r1_w_7 = mad(r3_y_8, 0.25, 0.75);
                    float r2_w_2 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r3_x_8 = max(r1_w_7, r2_w_2);
                    float4 r3_xyzw_9 = t2.Sample(sampler_linear_clamp, (float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8)).xyz);
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
                float r1_w_9 = saturate(dot(float4(r3_x_10, r3_y_10, r3_z_10, r3_w_4), unity_OcclusionMaskSelector));
                float r3_x_11 = dot(i.texcoord1.xyzx, float4(r2_x_3, r2_y_2, r2_z_2, r2_x_3));
                float r3_y_11 = dot(i.texcoord2.xyzx, float4(r2_x_3, r2_y_2, r2_z_2, r2_x_3));
                float r3_z_11 = dot(i.texcoord3.xyzx, float4(r2_x_3, r2_y_2, r2_z_2, r2_x_3));
                float4 r2_xyzw_6 = ((rsqrt(dot(float4(r3_x_11, r3_y_11, r3_z_11, r3_x_11), float4(r3_x_11, r3_y_11, r3_z_11, r3_x_11)))).xxxx * float4(r3_x_11, r3_y_11, r3_z_11, r3_x_11));
                float r2_x_6 = r2_xyzw_6.x;
                float r2_y_3 = r2_xyzw_6.y;
                float r2_z_3 = r2_xyzw_6.z;
                float3 r3_xyz_12 = ((r1_w_9.xxxx * _LightColor0.xyzx)).xyz;
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_w_5 = dot(float4(r2_x_6, r2_y_3, r2_z_3, r2_x_6), _WorldSpaceLightPos0.xyzx);
                float r0_x_4 = dot(float4(r2_x_6, r2_y_3, r2_z_3, r2_x_6), ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx);
                float4 r0_xyzw_5 = max(float4(r0_x_4, r0_x_4, r0_x_4, r0_w_5), float4(0, 0, 0, 0));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_w_6 = r0_xyzw_5.w;
                float r0_y_4 = (cb0_values[5].x * 128);
                float4 r2_xyzw_7 = (r3_xyz_12.xyzx * _SpecColor.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_4 = r2_xyzw_7.y;
                float r2_z_4 = r2_xyzw_7.z;
                                float4 r0_xyzw_10 = (((pow(r0_x_5, r0_y_4) * cb0_values[5].y)).xxxx * float4(r2_x_7, r2_y_4, r2_z_4, r2_x_7));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_5 = r0_xyzw_10.y;
                float r0_z_4 = r0_xyzw_10.z;
                float4 r0_xyzw_11 = mad(((((r1_xyzw_1.xyzx * cb0_values[4].xyzx)).xyzx * r3_xyz_12.xyzx)).xyzx, r0_w_6.xxxx, float4(r0_x_10, r0_y_5, r0_z_4, r0_x_10));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_y_6 = r0_xyzw_11.y;
                float r0_z_5 = r0_xyzw_11.z;
                float r0_w_7 = (i.texcoord7.x / cb1_values[5].y);
                float r0_w_8 = (-r0_w_7 + 1);
                float r0_w_9 = (r0_w_8 * cb1_values[5].z);
                float r0_w_10 = max(r0_w_9, 0);
                float r0_w_11 = saturate(mad(r0_w_10, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w));
                o.sv_Target0.xyz = ((float4(r0_x_11, r0_y_6, r0_z_5, r0_x_11) * r0_w_11.xxxx)).xyz;
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
                float4 _SpecColor;
                float4 _Color;
                float _Shininess;
                float _Gloss;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 cb0_values[12];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
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
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float texcoord7 : TEXCOORD7;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program102Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float texcoord7 : TEXCOORD7;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
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
                o.texcoord7.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[11].xxxy, cb0_values[11].zzzw)).zw;
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                float3 unitWorldNormal_xyz_4 = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_7 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_7.xxxx * (mad(unitWorldNormal_xyz_4.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_4.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_4.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_4.z;
                o.texcoord3.z = unitWorldNormal_xyz_4.x;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord4.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_6 = (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, ((worldPos_xyzw_4.yyyy * cb0_values[5].xyzx)).xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.zzzz, clipPos_xyz_6.xyzx)).xyz;
                o.texcoord5.xyz = (mad(_BumpMap_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program102Output frag(program102Input i)
            {
                program102Output o = (program102Output)0;
                float3 r0_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r0_xyz_2 = normalize(r0_xyz_1);
                float3 viewDir_xyz_1 = ((-i.texcoord4.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_3 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r3_x_2 = (r3_xyzw_1.w * r3_xyzw_1.x);
                float4 r3_xyzw_3 = mad(float4(r3_x_2, r3_xyzw_1.y, r3_x_2, r3_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r1_w_1 = dot(float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3), float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r3_z_2 = sqrt(r1_w_3);
                float3 r4_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord4.zzzz, (mad(cb0_values[4].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r1_w_4 = (cb4_values[0].x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r1_w_4)
                {
                    float r1_w_5 = (cb4_values[0].y == 1);
                    float3 r5_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord4.zzzz, (mad(cb4_values[1].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r5_xyzw_8 = (((((r1_w_5.xxxx ? r5_xyz_5.xyzx : i.texcoord4.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r1_w_6 = mad(r5_y_8, 0.25, 0.75);
                    float r2_w_2 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r5_x_8 = max(r1_w_6, r2_w_2);
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
                float r1_w_8 = saturate(dot(float4(r5_x_10, r5_y_10, r5_z_10, r5_w_4), unity_OcclusionMaskSelector));
                float r2_w_4 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float4 r4_xyzw_5 = t2.Sample(sampler_linear_clamp1, (r2_w_4.xxxx).xy);
                float r1_w_9 = (r1_w_8 * r4_xyzw_5.x);
                float r4_x_6 = dot(i.texcoord1.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_y_6 = dot(i.texcoord2.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_z_6 = dot(i.texcoord3.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r2_w_5 = dot(float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6), float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r2_w_6 = rsqrt(r2_w_5);
                float4 r3_xyzw_4 = (r2_w_6.xxxx * float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r3_z_3 = r3_xyzw_4.z;
                float3 r4_xyz_7 = ((r1_w_9.xxxx * _LightColor0.xyzx)).xyz;
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_4.xxxx, r0_xyz_2.xyzx)).xyz;
                float r0_w_5 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_6 = rsqrt(r0_w_5);
                float r0_x_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), r0_xyz_2.xyzx);
                float r0_y_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), ((r0_w_6.xxxx * r1_xyz_2.xyzx)).xyzx);
                float2 r0_xy_4 = (max(float4(r0_x_3, r0_y_3, r0_x_3, r0_x_3), float4(0, 0, 0, 0))).xy;
                float r0_z_3 = (cb0_values[9].x * 128);
                float r0_y_5 = log2(r0_xy_4.y);
                float r0_y_6 = (r0_y_5 * r0_z_3);
                float r0_y_7 = exp2(r0_y_6);
                float r0_y_8 = (r0_y_7 * cb0_values[9].y);
                float4 r0_xyzw_9 = (r0_y_8.xxxx * ((r4_xyz_7.xyzx * _SpecColor.xyzx)).xxyz);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_4 = r0_xyzw_9.z;
                float r0_w_7 = r0_xyzw_9.w;
                float4 r0_xyzw_5 = mad(((((r2_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * r4_xyz_7.xyzx)).xyzx, r0_xy_4.xxxx, float4(r0_y_9, r0_z_4, r0_w_7, r0_y_9));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_10 = r0_xyzw_5.y;
                float r0_z_5 = r0_xyzw_5.z;
                float r0_w_8 = (i.texcoord7.x / cb1_values[5].y);
                float r0_w_9 = (-r0_w_8 + 1);
                float r0_w_10 = (r0_w_9 * cb1_values[5].z);
                float r0_w_11 = max(r0_w_10, 0);
                float r0_w_12 = saturate(mad(r0_w_11, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w));
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_10, r0_z_5, r0_x_5) * r0_w_12.xxxx)).xyz;
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
                float4 _SpecColor;
                float4 _Color;
                float _Shininess;
                float _Gloss;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 cb0_values[12];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
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
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program101Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
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
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[11].xxxy, cb0_values[11].zzzw)).zw;
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                float3 unitWorldNormal_xyz_3 = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_6 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_6.xxxx * (mad(unitWorldNormal_xyz_3.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_3.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_3.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_3.z;
                o.texcoord3.z = unitWorldNormal_xyz_3.x;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord4.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_4 = ((worldPos_xyzw_4.yyyy * cb0_values[5].xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.zzzz, (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_4.xyzx)).xyzx)).xyz;
                o.texcoord5.xyz = (mad(_BumpMap_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program101Output frag(program101Input i)
            {
                program101Output o = (program101Output)0;
                float3 r0_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r0_xyz_2 = normalize(r0_xyz_1);
                float3 viewDir_xyz_1 = ((-i.texcoord4.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_3 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r3_x_2 = (r3_xyzw_1.w * r3_xyzw_1.x);
                float4 r3_xyzw_3 = mad(float4(r3_x_2, r3_xyzw_1.y, r3_x_2, r3_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r1_w_1 = dot(float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3), float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r3_z_2 = sqrt(r1_w_3);
                float3 r4_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord4.zzzz, (mad(cb0_values[4].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r5_x_1 = cb4_values[9].z;
                float r5_y_1 = cb4_values[10].z;
                float r5_z_1 = cb4_values[11].z;
                float r1_w_4 = dot(viewDir_xyz_1.xyzx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1));
                float3 r5_xyz_2 = ((i.texcoord4.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = dot(r5_xyz_2.xyzx, r5_xyz_2.xyzx);
                float r2_w_3 = sqrt(r2_w_2);
                float r2_w_4 = (-r1_w_4 + r2_w_3);
                float r1_w_5 = mad(cb3_values[25].w, r2_w_4, r1_w_4);
                float r1_w_6 = saturate(mad(r1_w_5, cb3_values[24].z, cb3_values[24].w));
                float r2_w_5 = (cb5_values[0].x == 1);
                float r5_x_12;
                float r5_y_12;
                float r5_z_12;
                float r5_w_4;
                if (r2_w_5)
                {
                    float r2_w_6 = (cb5_values[0].y == 1);
                    float3 r5_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord4.zzzz, (mad(cb5_values[1].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r5_xyzw_10 = (((((r2_w_6.xxxx ? r5_xyz_7.xyzx : i.texcoord4.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r5_y_10 = r5_xyzw_10.y;
                    float r5_z_10 = r5_xyzw_10.z;
                    float r5_w_2 = r5_xyzw_10.w;
                    float r2_w_7 = mad(r5_y_10, 0.25, 0.75);
                    float r3_w_2 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r5_x_10 = max(r2_w_7, r3_w_2);
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
                float r2_w_9 = saturate(dot(float4(r5_x_12, r5_y_12, r5_z_12, r5_w_4), unity_OcclusionMaskSelector));
                float r3_w_4 = (r1_w_6 < 0.99);
                float r3_w_16;
                if (r3_w_4)
                {
                    float3 r5_xyz_13 = ((i.texcoord4.xyzx + -cb2_values[1].xyzx)).xyz;
                    float r3_w_6 = max(abs(r5_xyz_13.y), abs(r5_xyz_13.x));
                    float r3_w_7 = max(abs(r5_xyz_13.z), r3_w_6);
                    float r3_w_8 = (r3_w_7 + -cb2_values[2].z);
                    float r3_w_9 = max(r3_w_8, 1E-05);
                    float r3_w_10 = (r3_w_9 * cb2_values[2].w);
                    float r3_w_11 = (cb2_values[2].y / r3_w_10);
                    float r3_w_12 = (r3_w_11 + -cb2_values[2].x);
                    float r3_w_13 = (-r3_w_12 + 1);
                    float r6_x_2 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r5_xyz_13.xyzx + float4(0.0078125, 0.0078125, 0.0078125, 0))).xyzx).xyz, r3_w_13);
                    float r6_y_2 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r5_xyz_13.xyzx + float4(-0.0078125, -0.0078125, 0.0078125, 0))).xyzx).xyz, r3_w_13);
                    float r6_z_2 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r5_xyz_13.xyzx + float4(-0.0078125, 0.0078125, -0.0078125, 0))).xyzx).xyz, r3_w_13);
                    float r6_w_1 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r5_xyz_13.xyzx + float4(0.0078125, -0.0078125, -0.0078125, 0))).xyzx).xyz, r3_w_13);
                    float r3_w_14 = dot(float4(r6_x_2, r6_y_2, r6_z_2, r6_w_1), float4(0.25, 0.25, 0.25, 0.25));
                    float r4_w_1 = (-cb3_values[24].x + 1);
                    float r3_w_15 = mad(r3_w_14, r4_w_1, cb3_values[24].x);
                    r3_w_16 = r3_w_15;
                }
                else
                {
                    float r3_w_5 = 1;
                    r3_w_16 = r3_w_5;
                }
                float r2_w_10 = (r2_w_9 + -r3_w_16);
                float r1_w_7 = mad(r1_w_6, r2_w_10, r3_w_16);
                float r2_w_11 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float4 r5_xyzw_16 = t2.Sample(sampler_linear_clamp3, (r2_w_11.xxxx).xy);
                float4 r4_xyzw_5 = t3.Sample(sampler_linear_clamp2, r4_xyz_4.xyz);
                float r2_w_12 = (r4_xyzw_5.w * r5_xyzw_16.x);
                float r1_w_8 = (r1_w_7 * r2_w_12);
                float r4_x_6 = dot(i.texcoord1.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_y_6 = dot(i.texcoord2.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_z_6 = dot(i.texcoord3.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r2_w_13 = dot(float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6), float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r2_w_14 = rsqrt(r2_w_13);
                float4 r3_xyzw_4 = (r2_w_14.xxxx * float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r3_z_3 = r3_xyzw_4.z;
                float3 r4_xyz_7 = ((r1_w_8.xxxx * _LightColor0.xyzx)).xyz;
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_4.xxxx, r0_xyz_2.xyzx)).xyz;
                float r0_w_5 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_6 = rsqrt(r0_w_5);
                float r0_x_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), r0_xyz_2.xyzx);
                float r0_y_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), ((r0_w_6.xxxx * r1_xyz_2.xyzx)).xyzx);
                float2 r0_xy_4 = (max(float4(r0_x_3, r0_y_3, r0_x_3, r0_x_3), float4(0, 0, 0, 0))).xy;
                float r0_z_3 = (cb0_values[9].x * 128);
                float r0_y_5 = log2(r0_xy_4.y);
                float r0_y_6 = (r0_y_5 * r0_z_3);
                float r0_y_7 = exp2(r0_y_6);
                float r0_y_8 = (r0_y_7 * cb0_values[9].y);
                float4 r0_xyzw_9 = (r0_y_8.xxxx * ((r4_xyz_7.xyzx * _SpecColor.xyzx)).xxyz);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_4 = r0_xyzw_9.z;
                float r0_w_7 = r0_xyzw_9.w;
                o.sv_Target0.xyz = (mad(((((r2_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * r4_xyz_7.xyzx)).xyzx, r0_xy_4.xxxx, float4(r0_y_9, r0_z_4, r0_w_7, r0_y_9))).xyz;
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
                float4 _SpecColor;
                float4 _Color;
                float _Shininess;
                float _Gloss;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 cb0_values[12];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
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
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program100Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
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
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[11].xxxy, cb0_values[11].zzzw)).zw;
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                float3 unitWorldNormal_xyz_3 = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_6 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_6.xxxx * (mad(unitWorldNormal_xyz_3.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_3.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_3.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_3.z;
                o.texcoord3.z = unitWorldNormal_xyz_3.x;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord4.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_4 = ((worldPos_xyzw_4.yyyy * cb0_values[5].xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.zzzz, (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_4.xyzx)).xyzx)).xyz;
                o.texcoord5.xyz = (mad(_BumpMap_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program100Output frag(program100Input i)
            {
                program100Output o = (program100Output)0;
                float3 r0_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r0_xyz_2 = normalize(r0_xyz_1);
                float3 viewDir_xyz_1 = ((-i.texcoord4.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_3 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r3_x_2 = (r3_xyzw_1.w * r3_xyzw_1.x);
                float4 r3_xyzw_3 = mad(float4(r3_x_2, r3_xyzw_1.y, r3_x_2, r3_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r1_w_1 = dot(float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3), float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r3_z_2 = sqrt(r1_w_3);
                float3 r4_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord4.zzzz, (mad(cb0_values[4].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r5_x_1 = cb4_values[9].z;
                float r5_y_1 = cb4_values[10].z;
                float r5_z_1 = cb4_values[11].z;
                float r1_w_4 = dot(viewDir_xyz_1.xyzx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1));
                float3 r5_xyz_2 = ((i.texcoord4.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = dot(r5_xyz_2.xyzx, r5_xyz_2.xyzx);
                float r2_w_3 = sqrt(r2_w_2);
                float r2_w_4 = (-r1_w_4 + r2_w_3);
                float r1_w_5 = mad(cb3_values[25].w, r2_w_4, r1_w_4);
                float r1_w_6 = saturate(mad(r1_w_5, cb3_values[24].z, cb3_values[24].w));
                float r2_w_5 = (cb5_values[0].x == 1);
                float r5_x_12;
                float r5_y_12;
                float r5_z_12;
                float r5_w_4;
                if (r2_w_5)
                {
                    float r2_w_6 = (cb5_values[0].y == 1);
                    float3 r5_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord4.zzzz, (mad(cb5_values[1].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r5_xyzw_10 = (((((r2_w_6.xxxx ? r5_xyz_7.xyzx : i.texcoord4.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r5_y_10 = r5_xyzw_10.y;
                    float r5_z_10 = r5_xyzw_10.z;
                    float r5_w_2 = r5_xyzw_10.w;
                    float r2_w_7 = mad(r5_y_10, 0.25, 0.75);
                    float r3_w_2 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r5_x_10 = max(r2_w_7, r3_w_2);
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
                float r2_w_9 = saturate(dot(float4(r5_x_12, r5_y_12, r5_z_12, r5_w_4), unity_OcclusionMaskSelector));
                float3 r5_xyz_13 = ((i.texcoord4.xyzx + -cb2_values[1].xyzx)).xyz;
                float r3_w_4 = max(abs(r5_xyz_13.y), abs(r5_xyz_13.x));
                float r3_w_5 = max(abs(r5_xyz_13.z), r3_w_4);
                float r3_w_6 = (r3_w_5 + -cb2_values[2].z);
                float r3_w_7 = max(r3_w_6, 1E-05);
                float r3_w_8 = (r3_w_7 * cb2_values[2].w);
                float r3_w_9 = (cb2_values[2].y / r3_w_8);
                float r3_w_10 = (r3_w_9 + -cb2_values[2].x);
                float r3_w_11 = (-r3_w_10 + 1);
                float r3_w_12 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, r5_xyz_13.xyz, r3_w_11);
                float r4_w_1 = (-cb3_values[24].x + 1);
                float r3_w_13 = mad(r3_w_12, r4_w_1, cb3_values[24].x);
                float r2_w_10 = (r2_w_9 + -r3_w_13);
                float r1_w_7 = mad(r1_w_6, r2_w_10, r3_w_13);
                float r2_w_11 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float4 r5_xyzw_14 = t2.Sample(sampler_linear_clamp3, (r2_w_11.xxxx).xy);
                float4 r4_xyzw_5 = t3.Sample(sampler_linear_clamp2, r4_xyz_4.xyz);
                float r2_w_12 = (r4_xyzw_5.w * r5_xyzw_14.x);
                float r1_w_8 = (r1_w_7 * r2_w_12);
                float r4_x_6 = dot(i.texcoord1.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_y_6 = dot(i.texcoord2.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_z_6 = dot(i.texcoord3.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r2_w_13 = dot(float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6), float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r2_w_14 = rsqrt(r2_w_13);
                float4 r3_xyzw_4 = (r2_w_14.xxxx * float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r3_z_3 = r3_xyzw_4.z;
                float3 r4_xyz_7 = ((r1_w_8.xxxx * _LightColor0.xyzx)).xyz;
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_4.xxxx, r0_xyz_2.xyzx)).xyz;
                float r0_w_5 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_6 = rsqrt(r0_w_5);
                float r0_x_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), r0_xyz_2.xyzx);
                float r0_y_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), ((r0_w_6.xxxx * r1_xyz_2.xyzx)).xyzx);
                float2 r0_xy_4 = (max(float4(r0_x_3, r0_y_3, r0_x_3, r0_x_3), float4(0, 0, 0, 0))).xy;
                float r0_z_3 = (cb0_values[9].x * 128);
                float r0_y_5 = log2(r0_xy_4.y);
                float r0_y_6 = (r0_y_5 * r0_z_3);
                float r0_y_7 = exp2(r0_y_6);
                float r0_y_8 = (r0_y_7 * cb0_values[9].y);
                float4 r0_xyzw_9 = (r0_y_8.xxxx * ((r4_xyz_7.xyzx * _SpecColor.xyzx)).xxyz);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_4 = r0_xyzw_9.z;
                float r0_w_7 = r0_xyzw_9.w;
                o.sv_Target0.xyz = (mad(((((r2_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * r4_xyz_7.xyzx)).xyzx, r0_xy_4.xxxx, float4(r0_y_9, r0_z_4, r0_w_7, r0_y_9))).xyz;
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
                float4 _SpecColor;
                float4 _Color;
                float _Shininess;
                float _Gloss;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 cb0_values[12];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
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
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program99Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
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
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[11].xxxy, cb0_values[11].zzzw)).zw;
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                float3 unitWorldNormal_xyz_3 = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_6 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_6.xxxx * (mad(unitWorldNormal_xyz_3.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_3.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_3.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_3.z;
                o.texcoord3.z = unitWorldNormal_xyz_3.x;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord4.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_4 = ((worldPos_xyzw_4.yyyy * cb0_values[5].xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.zzzz, (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_4.xyzx)).xyzx)).xyz;
                o.texcoord5.xyz = (mad(_BumpMap_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program99Output frag(program99Input i)
            {
                program99Output o = (program99Output)0;
                float3 r0_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r0_xyz_2 = normalize(r0_xyz_1);
                float3 viewDir_xyz_1 = ((-i.texcoord4.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_3 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r3_x_2 = (r3_xyzw_1.w * r3_xyzw_1.x);
                float4 r3_xyzw_3 = mad(float4(r3_x_2, r3_xyzw_1.y, r3_x_2, r3_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r1_w_1 = dot(float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3), float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r3_z_2 = sqrt(r1_w_3);
                float3 r4_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord4.zzzz, (mad(cb0_values[4].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r5_x_1 = cb4_values[9].z;
                float r5_y_1 = cb4_values[10].z;
                float r5_z_1 = cb4_values[11].z;
                float r1_w_4 = dot(viewDir_xyz_1.xyzx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1));
                float3 r5_xyz_2 = ((i.texcoord4.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = dot(r5_xyz_2.xyzx, r5_xyz_2.xyzx);
                float r2_w_3 = sqrt(r2_w_2);
                float r2_w_4 = (-r1_w_4 + r2_w_3);
                float r1_w_5 = mad(cb3_values[25].w, r2_w_4, r1_w_4);
                float r1_w_6 = saturate(mad(r1_w_5, cb3_values[24].z, cb3_values[24].w));
                float r2_w_5 = (cb5_values[0].x == 1);
                float r5_x_12;
                float r5_y_12;
                float r5_z_12;
                float r5_w_4;
                if (r2_w_5)
                {
                    float r2_w_6 = (cb5_values[0].y == 1);
                    float3 r5_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord4.zzzz, (mad(cb5_values[1].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r5_xyzw_10 = (((((r2_w_6.xxxx ? r5_xyz_7.xyzx : i.texcoord4.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r5_y_10 = r5_xyzw_10.y;
                    float r5_z_10 = r5_xyzw_10.z;
                    float r5_w_2 = r5_xyzw_10.w;
                    float r2_w_7 = mad(r5_y_10, 0.25, 0.75);
                    float r3_w_2 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r5_x_10 = max(r2_w_7, r3_w_2);
                    float4 r5_xyzw_11 = t3.Sample(sampler_linear_clamp, (float4(r5_x_10, r5_z_10, r5_w_2, r5_x_10)).xyz);
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
                float r2_w_9 = saturate(dot(float4(r5_x_12, r5_y_12, r5_z_12, r5_w_4), unity_OcclusionMaskSelector));
                float r3_w_4 = (r1_w_6 < 0.99);
                float r3_w_16;
                if (r3_w_4)
                {
                    float3 r5_xyz_13 = ((i.texcoord4.xyzx + -cb2_values[1].xyzx)).xyz;
                    float r3_w_6 = max(abs(r5_xyz_13.y), abs(r5_xyz_13.x));
                    float r3_w_7 = max(abs(r5_xyz_13.z), r3_w_6);
                    float r3_w_8 = (r3_w_7 + -cb2_values[2].z);
                    float r3_w_9 = max(r3_w_8, 1E-05);
                    float r3_w_10 = (r3_w_9 * cb2_values[2].w);
                    float r3_w_11 = (cb2_values[2].y / r3_w_10);
                    float r3_w_12 = (r3_w_11 + -cb2_values[2].x);
                    float r3_w_13 = (-r3_w_12 + 1);
                    float r6_x_2 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r5_xyz_13.xyzx + float4(0.0078125, 0.0078125, 0.0078125, 0))).xyzx).xyz, r3_w_13);
                    float r6_y_2 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r5_xyz_13.xyzx + float4(-0.0078125, -0.0078125, 0.0078125, 0))).xyzx).xyz, r3_w_13);
                    float r6_z_2 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r5_xyz_13.xyzx + float4(-0.0078125, 0.0078125, -0.0078125, 0))).xyzx).xyz, r3_w_13);
                    float r6_w_1 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((r5_xyz_13.xyzx + float4(0.0078125, -0.0078125, -0.0078125, 0))).xyzx).xyz, r3_w_13);
                    float r3_w_14 = dot(float4(r6_x_2, r6_y_2, r6_z_2, r6_w_1), float4(0.25, 0.25, 0.25, 0.25));
                    float r4_w_1 = (-cb3_values[24].x + 1);
                    float r3_w_15 = mad(r3_w_14, r4_w_1, cb3_values[24].x);
                    r3_w_16 = r3_w_15;
                }
                else
                {
                    float r3_w_5 = 1;
                    r3_w_16 = r3_w_5;
                }
                float r2_w_10 = (r2_w_9 + -r3_w_16);
                float r1_w_7 = mad(r1_w_6, r2_w_10, r3_w_16);
                float r2_w_11 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float4 r4_xyzw_5 = t2.Sample(sampler_linear_clamp2, (r2_w_11.xxxx).xy);
                float r1_w_8 = (r1_w_7 * r4_xyzw_5.x);
                float r4_x_6 = dot(i.texcoord1.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_y_6 = dot(i.texcoord2.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_z_6 = dot(i.texcoord3.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r2_w_12 = dot(float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6), float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r2_w_13 = rsqrt(r2_w_12);
                float4 r3_xyzw_4 = (r2_w_13.xxxx * float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r3_z_3 = r3_xyzw_4.z;
                float3 r4_xyz_7 = ((r1_w_8.xxxx * _LightColor0.xyzx)).xyz;
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_4.xxxx, r0_xyz_2.xyzx)).xyz;
                float r0_w_5 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_6 = rsqrt(r0_w_5);
                float r0_x_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), r0_xyz_2.xyzx);
                float r0_y_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), ((r0_w_6.xxxx * r1_xyz_2.xyzx)).xyzx);
                float2 r0_xy_4 = (max(float4(r0_x_3, r0_y_3, r0_x_3, r0_x_3), float4(0, 0, 0, 0))).xy;
                float r0_z_3 = (cb0_values[9].x * 128);
                float r0_y_5 = log2(r0_xy_4.y);
                float r0_y_6 = (r0_y_5 * r0_z_3);
                float r0_y_7 = exp2(r0_y_6);
                float r0_y_8 = (r0_y_7 * cb0_values[9].y);
                float4 r0_xyzw_9 = (r0_y_8.xxxx * ((r4_xyz_7.xyzx * _SpecColor.xyzx)).xxyz);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_4 = r0_xyzw_9.z;
                float r0_w_7 = r0_xyzw_9.w;
                o.sv_Target0.xyz = (mad(((((r2_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * r4_xyz_7.xyzx)).xyzx, r0_xy_4.xxxx, float4(r0_y_9, r0_z_4, r0_w_7, r0_y_9))).xyz;
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
                float4 _SpecColor;
                float4 _Color;
                float _Shininess;
                float _Gloss;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 cb0_values[12];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
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
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program98Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
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
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[11].xxxy, cb0_values[11].zzzw)).zw;
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                float3 unitWorldNormal_xyz_3 = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_6 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_6.xxxx * (mad(unitWorldNormal_xyz_3.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_3.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_3.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_3.z;
                o.texcoord3.z = unitWorldNormal_xyz_3.x;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord4.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_4 = ((worldPos_xyzw_4.yyyy * cb0_values[5].xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.zzzz, (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_4.xyzx)).xyzx)).xyz;
                o.texcoord5.xyz = (mad(_BumpMap_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program98Output frag(program98Input i)
            {
                program98Output o = (program98Output)0;
                float3 r0_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r0_xyz_2 = normalize(r0_xyz_1);
                float3 viewDir_xyz_1 = ((-i.texcoord4.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_3 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r3_x_2 = (r3_xyzw_1.w * r3_xyzw_1.x);
                float4 r3_xyzw_3 = mad(float4(r3_x_2, r3_xyzw_1.y, r3_x_2, r3_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r1_w_1 = dot(float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3), float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r3_z_2 = sqrt(r1_w_3);
                float3 r4_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord4.zzzz, (mad(cb0_values[4].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r5_x_1 = cb4_values[9].z;
                float r5_y_1 = cb4_values[10].z;
                float r5_z_1 = cb4_values[11].z;
                float r1_w_4 = dot(viewDir_xyz_1.xyzx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1));
                float3 r5_xyz_2 = ((i.texcoord4.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = dot(r5_xyz_2.xyzx, r5_xyz_2.xyzx);
                float r2_w_3 = sqrt(r2_w_2);
                float r2_w_4 = (-r1_w_4 + r2_w_3);
                float r1_w_5 = mad(cb3_values[25].w, r2_w_4, r1_w_4);
                float r1_w_6 = saturate(mad(r1_w_5, cb3_values[24].z, cb3_values[24].w));
                float r2_w_5 = (cb5_values[0].x == 1);
                float r5_x_12;
                float r5_y_12;
                float r5_z_12;
                float r5_w_4;
                if (r2_w_5)
                {
                    float r2_w_6 = (cb5_values[0].y == 1);
                    float3 r5_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord4.zzzz, (mad(cb5_values[1].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r5_xyzw_10 = (((((r2_w_6.xxxx ? r5_xyz_7.xyzx : i.texcoord4.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r5_y_10 = r5_xyzw_10.y;
                    float r5_z_10 = r5_xyzw_10.z;
                    float r5_w_2 = r5_xyzw_10.w;
                    float r2_w_7 = mad(r5_y_10, 0.25, 0.75);
                    float r3_w_2 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r5_x_10 = max(r2_w_7, r3_w_2);
                    float4 r5_xyzw_11 = t3.Sample(sampler_linear_clamp, (float4(r5_x_10, r5_z_10, r5_w_2, r5_x_10)).xyz);
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
                float r2_w_9 = saturate(dot(float4(r5_x_12, r5_y_12, r5_z_12, r5_w_4), unity_OcclusionMaskSelector));
                float3 r5_xyz_13 = ((i.texcoord4.xyzx + -cb2_values[1].xyzx)).xyz;
                float r3_w_4 = max(abs(r5_xyz_13.y), abs(r5_xyz_13.x));
                float r3_w_5 = max(abs(r5_xyz_13.z), r3_w_4);
                float r3_w_6 = (r3_w_5 + -cb2_values[2].z);
                float r3_w_7 = max(r3_w_6, 1E-05);
                float r3_w_8 = (r3_w_7 * cb2_values[2].w);
                float r3_w_9 = (cb2_values[2].y / r3_w_8);
                float r3_w_10 = (r3_w_9 + -cb2_values[2].x);
                float r3_w_11 = (-r3_w_10 + 1);
                float r3_w_12 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, r5_xyz_13.xyz, r3_w_11);
                float r4_w_1 = (-cb3_values[24].x + 1);
                float r3_w_13 = mad(r3_w_12, r4_w_1, cb3_values[24].x);
                float r2_w_10 = (r2_w_9 + -r3_w_13);
                float r1_w_7 = mad(r1_w_6, r2_w_10, r3_w_13);
                float r2_w_11 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float4 r4_xyzw_5 = t2.Sample(sampler_linear_clamp2, (r2_w_11.xxxx).xy);
                float r1_w_8 = (r1_w_7 * r4_xyzw_5.x);
                float r4_x_6 = dot(i.texcoord1.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_y_6 = dot(i.texcoord2.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_z_6 = dot(i.texcoord3.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r2_w_12 = dot(float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6), float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r2_w_13 = rsqrt(r2_w_12);
                float4 r3_xyzw_4 = (r2_w_13.xxxx * float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r3_z_3 = r3_xyzw_4.z;
                float3 r4_xyz_7 = ((r1_w_8.xxxx * _LightColor0.xyzx)).xyz;
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_4.xxxx, r0_xyz_2.xyzx)).xyz;
                float r0_w_5 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_6 = rsqrt(r0_w_5);
                float r0_x_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), r0_xyz_2.xyzx);
                float r0_y_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), ((r0_w_6.xxxx * r1_xyz_2.xyzx)).xyzx);
                float2 r0_xy_4 = (max(float4(r0_x_3, r0_y_3, r0_x_3, r0_x_3), float4(0, 0, 0, 0))).xy;
                float r0_z_3 = (cb0_values[9].x * 128);
                float r0_y_5 = log2(r0_xy_4.y);
                float r0_y_6 = (r0_y_5 * r0_z_3);
                float r0_y_7 = exp2(r0_y_6);
                float r0_y_8 = (r0_y_7 * cb0_values[9].y);
                float4 r0_xyzw_9 = (r0_y_8.xxxx * ((r4_xyz_7.xyzx * _SpecColor.xyzx)).xxyz);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_4 = r0_xyzw_9.z;
                float r0_w_7 = r0_xyzw_9.w;
                o.sv_Target0.xyz = (mad(((((r2_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * r4_xyz_7.xyzx)).xyzx, r0_xy_4.xxxx, float4(r0_y_9, r0_z_4, r0_w_7, r0_y_9))).xyz;
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
                float4 _SpecColor;
                float4 _Color;
                float _Shininess;
                float _Gloss;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 cb0_values[12];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[10];
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
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float2 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program97Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float2 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
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
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[11].xxxy, cb0_values[11].zzzw)).zw;
                float r2_y_4 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float r2_z_4 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float r2_x_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r2_w_4 = dot(float4(r2_x_4, r2_y_4, r2_z_4, r2_x_4), float4(r2_x_4, r2_y_4, r2_z_4, r2_x_4));
                float r2_w_5 = rsqrt(r2_w_4);
                float3 unitWorldNormal_xyz_5 = ((r2_w_5.xxxx * float4(r2_x_4, r2_y_4, r2_z_4, r2_x_4))).xyz;
                float3 worldTangent_xyz_1 = ((i.tangent0.yyyy * cb2_values[1].yzxy)).xyz;
                float3 worldTangent_xyz_2 = (mad(cb2_values[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_1.xyzx)).xyz;
                float3 worldTangent_xyz_3 = (mad(cb2_values[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_2.xyzx)).xyz;
                float3 unitWorldTangent_xyz_4 = normalize(worldTangent_xyz_3);
                float r2_w_8 = (i.tangent0.w * cb2_values[9].w);
                float3 r4_xyz_3 = ((r2_w_8.xxxx * (mad(unitWorldNormal_xyz_5.zxyz, unitWorldTangent_xyz_4.yzxy, ((unitWorldNormal_xyz_5.xyzx * unitWorldTangent_xyz_4.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r4_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_4.z;
                o.texcoord1.z = unitWorldNormal_xyz_5.y;
                o.texcoord2.x = unitWorldTangent_xyz_4.x;
                o.texcoord3.x = unitWorldTangent_xyz_4.y;
                o.texcoord2.z = unitWorldNormal_xyz_5.z;
                o.texcoord3.z = unitWorldNormal_xyz_5.x;
                o.texcoord2.y = r4_xyz_3.y;
                o.texcoord3.y = r4_xyz_3.z;
                o.texcoord4.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord5.xy = (mad(_BumpMap_ST.xyxx, r0_xyzw_4.wwww, (mad(_MainTex_ST.xyxx, r0_xyzw_4.zzzz, (mad(_Color.xyxx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx)).xy;
                float r0_w_5 = ((clipPos_xyzw_2.y * unity_WorldToObject[1].x) * 0.5);
                float4 r0_xyzw_8 = (clipPos_xyzw_2.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_z_5 = r0_xyzw_8.z;
                o.texcoord6.zw = (clipPos_xyzw_2.zzzw).zw;
                o.texcoord6.xy = ((r0_z_5.xxxx + float4(r0_x_8, r0_w_5, r0_x_8, r0_x_8))).xy;
                return o;
            }
            #pragma fragment frag
            program97Output frag(program97Input i)
            {
                program97Output o = (program97Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord4.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r2_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r2_x_2 = (r2_xyzw_1.w * r2_xyzw_1.x);
                float4 r2_xyzw_3 = mad(float4(r2_x_2, r2_xyzw_1.y, r2_x_2, r2_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r2_x_3 = r2_xyzw_3.x;
                float r2_y_2 = r2_xyzw_3.y;
                float r1_w_2 = dot(float4(r2_x_3, r2_y_2, r2_x_3, r2_x_3), float4(r2_x_3, r2_y_2, r2_x_3, r2_x_3));
                float r1_w_3 = min(r1_w_2, 1);
                float r1_w_4 = (-r1_w_3 + 1);
                float r2_z_2 = sqrt(r1_w_4);
                float r4_x_1 = cb4_values[9].z;
                float r4_y_1 = cb4_values[10].z;
                float r4_z_1 = cb4_values[11].z;
                float r1_w_5 = dot(viewDir_xyz_1.xyzx, float4(r4_x_1, r4_y_1, r4_z_1, r4_x_1));
                float3 r4_xyz_2 = ((i.texcoord4.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = dot(r4_xyz_2.xyzx, r4_xyz_2.xyzx);
                float r2_w_3 = sqrt(r2_w_2);
                float r2_w_4 = (-r1_w_5 + r2_w_3);
                float r1_w_6 = mad(cb3_values[25].w, r2_w_4, r1_w_5);
                float r1_w_7 = saturate(mad(r1_w_6, cb3_values[24].z, cb3_values[24].w));
                float r2_w_5 = (cb5_values[0].x == 1);
                float r4_x_12;
                float r4_y_12;
                float r4_z_12;
                float r4_w_4;
                if (r2_w_5)
                {
                    float r2_w_6 = (cb5_values[0].y == 1);
                    float3 r4_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord4.zzzz, (mad(cb5_values[1].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r4_xyzw_10 = (((((r2_w_6.xxxx ? r4_xyz_7.xyzx : i.texcoord4.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r4_y_10 = r4_xyzw_10.y;
                    float r4_z_10 = r4_xyzw_10.z;
                    float r4_w_2 = r4_xyzw_10.w;
                    float r2_w_7 = mad(r4_y_10, 0.25, 0.75);
                    float r3_z_1 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r4_x_10 = max(r2_w_7, r3_z_1);
                    float4 r4_xyzw_11 = t4.Sample(sampler_linear_clamp, (float4(r4_x_10, r4_z_10, r4_w_2, r4_x_10)).xyz);
                    r4_x_12 = r4_xyzw_11.x;
                    r4_y_12 = r4_xyzw_11.y;
                    r4_z_12 = r4_xyzw_11.z;
                    r4_w_4 = r4_xyzw_11.w;
                }
                else
                {
                    float4 r4_xyzw_3 = float4(1, 1, 1, 1);
                    r4_x_12 = r4_xyzw_3.x;
                    r4_y_12 = r4_xyzw_3.y;
                    r4_z_12 = r4_xyzw_3.z;
                    r4_w_4 = r4_xyzw_3.w;
                }
                float r2_w_9 = saturate(dot(float4(r4_x_12, r4_y_12, r4_z_12, r4_w_4), unity_OcclusionMaskSelector));
                float4 r3_xyzw_3 = (i.texcoord6.xxxy / i.texcoord6.wwww);
                float r3_z_3 = r3_xyzw_3.z;
                float r3_w_1 = r3_xyzw_3.w;
                float4 r4_xyzw_13 = t2.Sample(sampler_linear_clamp1, (float4(r3_z_3, r3_w_1, r3_z_3, r3_z_3)).xy);
                float r2_w_10 = (r2_w_9 + -r4_xyzw_13.x);
                float r1_w_8 = mad(r1_w_7, r2_w_10, r4_xyzw_13.x);
                float4 r3_xyzw_5 = t3.Sample(sampler_linear_clamp2, ((((mad(cb0_values[6].xyxx, i.texcoord4.zzzz, (mad(cb0_values[4].xyxx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx).xy);
                float r1_w_9 = (r1_w_8 * r3_xyzw_5.w);
                float r3_x_6 = dot(i.texcoord1.xyzx, float4(r2_x_3, r2_y_2, r2_z_2, r2_x_3));
                float r3_y_6 = dot(i.texcoord2.xyzx, float4(r2_x_3, r2_y_2, r2_z_2, r2_x_3));
                float r3_z_5 = dot(i.texcoord3.xyzx, float4(r2_x_3, r2_y_2, r2_z_2, r2_x_3));
                float4 r2_xyzw_6 = ((rsqrt(dot(float4(r3_x_6, r3_y_6, r3_z_5, r3_x_6), float4(r3_x_6, r3_y_6, r3_z_5, r3_x_6)))).xxxx * float4(r3_x_6, r3_y_6, r3_z_5, r3_x_6));
                float r2_x_6 = r2_xyzw_6.x;
                float r2_y_3 = r2_xyzw_6.y;
                float r2_z_3 = r2_xyzw_6.z;
                float4 r3_xyzw_7 = (r1_w_9.xxxx * _LightColor0.xyzx);
                float r3_x_7 = r3_xyzw_7.x;
                float r3_y_7 = r3_xyzw_7.y;
                float r3_z_6 = r3_xyzw_7.z;
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_w_5 = dot(float4(r2_x_6, r2_y_3, r2_z_3, r2_x_6), _WorldSpaceLightPos0.xyzx);
                float r0_x_4 = dot(float4(r2_x_6, r2_y_3, r2_z_3, r2_x_6), ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx);
                float4 r0_xyzw_5 = max(float4(r0_x_4, r0_x_4, r0_x_4, r0_w_5), float4(0, 0, 0, 0));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_w_6 = r0_xyzw_5.w;
                float r0_y_4 = (cb0_values[9].x * 128);
                float4 r2_xyzw_7 = (float4(r3_x_7, r3_y_7, r3_z_6, r3_x_7) * _SpecColor.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_4 = r2_xyzw_7.y;
                float r2_z_4 = r2_xyzw_7.z;
                                float4 r0_xyzw_10 = (((pow(r0_x_5, r0_y_4) * cb0_values[9].y)).xxxx * float4(r2_x_7, r2_y_4, r2_z_4, r2_x_7));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_5 = r0_xyzw_10.y;
                float r0_z_4 = r0_xyzw_10.z;
                o.sv_Target0.xyz = (mad(((((r1_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * float4(r3_x_7, r3_y_7, r3_z_6, r3_x_7))).xyzx, r0_w_6.xxxx, float4(r0_x_10, r0_y_5, r0_z_4, r0_x_10))).xyz;
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
                float4 _SpecColor;
                float4 _Color;
                float _Shininess;
                float _Gloss;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 cb0_values[6];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb2_values[10];
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
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program96Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord6 : TEXCOORD6;
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
                o.texcoord4.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                float r1_y_2 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float r1_z_2 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float r1_x_2 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_2 = dot(float4(r1_x_2, r1_y_2, r1_z_2, r1_x_2), float4(r1_x_2, r1_y_2, r1_z_2, r1_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                float3 unitWorldNormal_xyz_3 = ((r1_w_3.xxxx * float4(r1_x_2, r1_y_2, r1_z_2, r1_x_2))).xyz;
                float3 worldTangent_xyz_1 = ((i.tangent0.yyyy * cb2_values[1].yzxy)).xyz;
                float3 worldTangent_xyz_2 = (mad(cb2_values[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_1.xyzx)).xyz;
                float3 worldTangent_xyz_3 = (mad(cb2_values[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_2.xyzx)).xyz;
                float3 unitWorldTangent_xyz_4 = normalize(worldTangent_xyz_3);
                float r1_w_6 = (i.tangent0.w * cb2_values[9].w);
                float3 r3_xyz_3 = ((r1_w_6.xxxx * (mad(unitWorldNormal_xyz_3.zxyz, unitWorldTangent_xyz_4.yzxy, ((unitWorldNormal_xyz_3.xyzx * unitWorldTangent_xyz_4.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_4.z;
                o.texcoord1.z = unitWorldNormal_xyz_3.y;
                o.texcoord2.x = unitWorldTangent_xyz_4.x;
                o.texcoord3.x = unitWorldTangent_xyz_4.y;
                o.texcoord2.z = unitWorldNormal_xyz_3.z;
                o.texcoord3.z = unitWorldNormal_xyz_3.x;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r1_xyzw_4 = (float4(clipPos_xyzw_7.x, clipPos_xyzw_7.x, clipPos_xyzw_7.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_z_4 = r1_xyzw_4.z;
                float r1_w_7 = r1_xyzw_4.w;
                o.texcoord6.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord6.xy = ((r1_z_4.xxxx + float4(r1_x_4, r1_w_7, r1_x_4, r1_x_4))).xy;
                return o;
            }
            #pragma fragment frag
            program96Output frag(program96Input i)
            {
                program96Output o = (program96Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord4.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r2_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r2_x_2 = (r2_xyzw_1.w * r2_xyzw_1.x);
                float4 r2_xyzw_3 = mad(float4(r2_x_2, r2_xyzw_1.y, r2_x_2, r2_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r2_x_3 = r2_xyzw_3.x;
                float r2_y_2 = r2_xyzw_3.y;
                float r1_w_2 = dot(float4(r2_x_3, r2_y_2, r2_x_3, r2_x_3), float4(r2_x_3, r2_y_2, r2_x_3, r2_x_3));
                float r1_w_3 = min(r1_w_2, 1);
                float r1_w_4 = (-r1_w_3 + 1);
                float r2_z_2 = sqrt(r1_w_4);
                float r3_x_1 = cb4_values[9].z;
                float r3_y_1 = cb4_values[10].z;
                float r3_z_1 = cb4_values[11].z;
                float r1_w_5 = dot(viewDir_xyz_1.xyzx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float3 r3_xyz_2 = ((i.texcoord4.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = dot(r3_xyz_2.xyzx, r3_xyz_2.xyzx);
                float r2_w_3 = sqrt(r2_w_2);
                float r2_w_4 = (-r1_w_5 + r2_w_3);
                float r1_w_6 = mad(cb3_values[25].w, r2_w_4, r1_w_5);
                float r1_w_7 = saturate(mad(r1_w_6, cb3_values[24].z, cb3_values[24].w));
                float r2_w_5 = (cb5_values[0].x == 1);
                float r3_x_12;
                float r3_y_13;
                float r3_z_12;
                float r3_w_4;
                if (r2_w_5)
                {
                    float r2_w_6 = (cb5_values[0].y == 1);
                    float3 r3_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord4.zzzz, (mad(cb5_values[1].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r3_xyzw_10 = (((((r2_w_6.xxxx ? r3_xyz_7.xyzx : i.texcoord4.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r3_y_10 = r3_xyzw_10.y;
                    float r3_z_10 = r3_xyzw_10.z;
                    float r3_w_2 = r3_xyzw_10.w;
                    float r2_w_7 = mad(r3_y_10, 0.25, 0.75);
                    float r3_y_11 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r3_x_10 = max(r2_w_7, r3_y_11);
                    float4 r3_xyzw_11 = t3.Sample(sampler_linear_clamp, (float4(r3_x_10, r3_z_10, r3_w_2, r3_x_10)).xyz);
                    r3_x_12 = r3_xyzw_11.x;
                    r3_y_13 = r3_xyzw_11.y;
                    r3_z_12 = r3_xyzw_11.z;
                    r3_w_4 = r3_xyzw_11.w;
                }
                else
                {
                    float4 r3_xyzw_3 = float4(1, 1, 1, 1);
                    r3_x_12 = r3_xyzw_3.x;
                    r3_y_13 = r3_xyzw_3.y;
                    r3_z_12 = r3_xyzw_3.z;
                    r3_w_4 = r3_xyzw_3.w;
                }
                float r2_w_9 = saturate(dot(float4(r3_x_12, r3_y_13, r3_z_12, r3_w_4), unity_OcclusionMaskSelector));
                float4 r3_xyzw_13 = (i.texcoord6.xyxx / i.texcoord6.wwww);
                float r3_x_13 = r3_xyzw_13.x;
                float r3_y_14 = r3_xyzw_13.y;
                float4 r3_xyzw_14 = t2.Sample(sampler_linear_clamp1, (float4(r3_x_13, r3_y_14, r3_x_13, r3_x_13)).xy);
                float r2_w_10 = (r2_w_9 + -r3_xyzw_14.x);
                float r1_w_8 = mad(r1_w_7, r2_w_10, r3_xyzw_14.x);
                float r3_x_15 = dot(i.texcoord1.xyzx, float4(r2_x_3, r2_y_2, r2_z_2, r2_x_3));
                float r3_y_16 = dot(i.texcoord2.xyzx, float4(r2_x_3, r2_y_2, r2_z_2, r2_x_3));
                float r3_z_14 = dot(i.texcoord3.xyzx, float4(r2_x_3, r2_y_2, r2_z_2, r2_x_3));
                float4 r2_xyzw_6 = ((rsqrt(dot(float4(r3_x_15, r3_y_16, r3_z_14, r3_x_15), float4(r3_x_15, r3_y_16, r3_z_14, r3_x_15)))).xxxx * float4(r3_x_15, r3_y_16, r3_z_14, r3_x_15));
                float r2_x_6 = r2_xyzw_6.x;
                float r2_y_3 = r2_xyzw_6.y;
                float r2_z_3 = r2_xyzw_6.z;
                float4 r3_xyzw_16 = (r1_w_8.xxxx * _LightColor0.xyzx);
                float r3_x_16 = r3_xyzw_16.x;
                float r3_y_17 = r3_xyzw_16.y;
                float r3_z_15 = r3_xyzw_16.z;
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_w_5 = dot(float4(r2_x_6, r2_y_3, r2_z_3, r2_x_6), _WorldSpaceLightPos0.xyzx);
                float r0_x_4 = dot(float4(r2_x_6, r2_y_3, r2_z_3, r2_x_6), ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx);
                float4 r0_xyzw_5 = max(float4(r0_x_4, r0_x_4, r0_x_4, r0_w_5), float4(0, 0, 0, 0));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_w_6 = r0_xyzw_5.w;
                float r0_y_4 = (cb0_values[5].x * 128);
                float4 r2_xyzw_7 = (float4(r3_x_16, r3_y_17, r3_z_15, r3_x_16) * _SpecColor.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_4 = r2_xyzw_7.y;
                float r2_z_4 = r2_xyzw_7.z;
                                float4 r0_xyzw_10 = (((pow(r0_x_5, r0_y_4) * cb0_values[5].y)).xxxx * float4(r2_x_7, r2_y_4, r2_z_4, r2_x_7));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_5 = r0_xyzw_10.y;
                float r0_z_4 = r0_xyzw_10.z;
                o.sv_Target0.xyz = (mad(((((r1_xyzw_1.xyzx * cb0_values[4].xyzx)).xyzx * float4(r3_x_16, r3_y_17, r3_z_15, r3_x_16))).xyzx, r0_w_6.xxxx, float4(r0_x_10, r0_y_5, r0_z_4, r0_x_10))).xyz;
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
                float4 _SpecColor;
                float4 _Color;
                float _Shininess;
                float _Gloss;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 cb0_values[17];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
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
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program95Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
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
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[15].xyxx, cb0_values[15].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[16].xxxy, cb0_values[16].zzzw)).zw;
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                float3 unitWorldNormal_xyz_3 = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_6 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_6.xxxx * (mad(unitWorldNormal_xyz_3.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_3.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_3.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_3.z;
                o.texcoord3.z = unitWorldNormal_xyz_3.x;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord4.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float4 clipPos_xyzw_4 = (worldPos_xyzw_4.yyyy * cb0_values[10].xyzw);
                float4 clipPos_xyzw_5 = mad(cb0_values[9].xyzw, worldPos_xyzw_4.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb0_values[11].xyzw, worldPos_xyzw_4.zzzz, clipPos_xyzw_5);
                o.texcoord5.xyzw = mad(cb0_values[12].xyzw, worldPos_xyzw_4.wwww, clipPos_xyzw_6);
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program95Output frag(program95Input i)
            {
                program95Output o = (program95Output)0;
                float3 r0_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r0_xyz_2 = normalize(r0_xyz_1);
                float3 viewDir_xyz_1 = ((-i.texcoord4.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_3 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r3_x_2 = (r3_xyzw_1.w * r3_xyzw_1.x);
                float4 r3_xyzw_3 = mad(float4(r3_x_2, r3_xyzw_1.y, r3_x_2, r3_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r1_w_1 = dot(float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3), float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r3_z_2 = sqrt(r1_w_3);
                float4 r4_xyzw_4 = (mad(cb0_values[11].xyzw, i.texcoord4.zzzz, mad(cb0_values[9].xyzw, i.texcoord4.xxxx, (i.texcoord4.yyyy * cb0_values[10].xyzw))) + cb0_values[12].xyzw);
                float r5_x_1 = cb4_values[9].z;
                float r5_y_1 = cb4_values[10].z;
                float r5_z_1 = cb4_values[11].z;
                float r1_w_4 = dot(viewDir_xyz_1.xyzx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1));
                float3 r5_xyz_2 = ((i.texcoord4.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = dot(r5_xyz_2.xyzx, r5_xyz_2.xyzx);
                float r2_w_3 = sqrt(r2_w_2);
                float r2_w_4 = (-r1_w_4 + r2_w_3);
                float r1_w_5 = mad(cb3_values[25].w, r2_w_4, r1_w_4);
                float r1_w_6 = saturate(mad(r1_w_5, cb3_values[24].z, cb3_values[24].w));
                float r2_w_5 = (cb5_values[0].x == 1);
                float r5_x_12;
                float r5_y_12;
                float r5_z_12;
                float r5_w_4;
                if (r2_w_5)
                {
                    float r2_w_6 = (cb5_values[0].y == 1);
                    float3 r5_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord4.zzzz, (mad(cb5_values[1].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r5_xyzw_10 = (((((r2_w_6.xxxx ? r5_xyz_7.xyzx : i.texcoord4.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r5_y_10 = r5_xyzw_10.y;
                    float r5_z_10 = r5_xyzw_10.z;
                    float r5_w_2 = r5_xyzw_10.w;
                    float r2_w_7 = mad(r5_y_10, 0.25, 0.75);
                    float r3_w_2 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r5_x_10 = max(r2_w_7, r3_w_2);
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
                float r2_w_9 = saturate(dot(float4(r5_x_12, r5_y_12, r5_z_12, r5_w_4), unity_OcclusionMaskSelector));
                float r3_w_4 = (r1_w_6 < 0.99);
                float r3_w_11;
                if (r3_w_4)
                {
                    float4 r5_xyzw_13 = (i.texcoord4.yyyy * cb3_values[9].xyzw);
                    float4 r5_xyzw_14 = mad(cb3_values[8].xyzw, i.texcoord4.xxxx, r5_xyzw_13);
                    float4 r5_xyzw_15 = mad(cb3_values[10].xyzw, i.texcoord4.zzzz, r5_xyzw_14);
                    float4 r5_xyzw_16 = (r5_xyzw_15 + cb3_values[11].xyzw);
                    float3 r5_xyz_17 = ((r5_xyzw_16.xyzx / r5_xyzw_16.wwww)).xyz;
                    float2 r6_xy_2 = (floor((mad(r5_xyz_17.xyxx, cb0_values[8].zwzz, float4(0.5, 0.5, 0, 0))).xyxx)).xy;
                    float2 r5_xy_18 = (mad(r5_xyz_17.xyxx, cb0_values[8].zwzz, -r6_xy_2.xyxx)).xy;
                    float4 r7_xyzw_1 = (r5_xy_18.xxyy + float4(0.5, 1, 0.5, 1));
                    float2 r8_xw_1 = ((r7_xyzw_1.xxxz * r7_xyzw_1.xxxz)).xw;
                    float2 r6_zw_1 = (mad(r8_xw_1.xxxy, float4(0, 0, 0.5, 0.5), -r5_xy_18.xxxy)).zw;
                    float2 r7_xz_2 = ((-r5_xy_18.xxyx + float4(1, 0, 1, 0))).xz;
                    float2 r9_xy_1 = (min(r5_xy_18.xyxx, float4(0, 0, 0, 0))).xy;
                    float2 r7_xz_3 = (mad(-r9_xy_1.xxyx, r9_xy_1.xxyx, r7_xz_2.xxyx)).xz;
                    float2 r5_xy_19 = (max(r5_xy_18.xyxx, float4(0, 0, 0, 0))).xy;
                    float2 r5_xy_20 = (mad(-r5_xy_19.xyxx, r5_xy_19.xyxx, r7_xyzw_1.ywyy)).xy;
                    float r9_x_2 = r6_zw_1.x;
                    float r9_y_2 = r7_xz_3.x;
                    float r9_z_1 = r5_xy_20.x;
                    float r9_w_1 = r8_xw_1.x;
                    float4 r9_xyzw_3 = (float4(r9_x_2, r9_y_2, r9_z_1, r9_w_1) * float4(0.44444, 0.44444, 0.44444, 0.22222));
                    float r8_x_2 = r6_zw_1.y;
                    float r8_y_1 = r7_xz_3.y;
                    float r8_z_1 = r5_xy_20.y;
                    float4 r7_xyzw_4 = (float4(r8_x_2, r8_y_1, r8_z_1, r8_xw_1.y) * float4(0.44444, 0.44444, 0.44444, 0.22222));
                    float4 r8_xyzw_3 = (r9_xyzw_3.ywyw + r9_xyzw_3.xzxz);
                    float4 r10_xyzw_1 = (r7_xyzw_4.yyww + r7_xyzw_4.xxzz);
                    float2 r6_zw_2 = ((r7_xyzw_4.yyyw / r10_xyzw_1.yyyw)).zw;
                    float2 r6_zw_3 = ((r6_zw_2.xxxy + float4(0, 0, -1.5, 0.5))).zw;
                    float4 r7_xyzw_5 = (((((r9_xyzw_3.ywyy / r8_xyzw_3.zwzz)).xyxx + float4(-1.5, 0.5, 0, 0))).xyxx * cb0_values[8].xxxx);
                    float r7_x_5 = r7_xyzw_5.x;
                    float r7_y_3 = r7_xyzw_5.y;
                    float r7_z_5 = ((r6_zw_3.xxxy * cb0_values[8].yyyy)).z;
                    float r7_w_3 = ((r6_zw_3.xxxy * cb0_values[8].yyyy)).w;
                    float4 r8_xyzw_4 = (r8_xyzw_3 * r10_xyzw_1);
                    float4 r9_xyzw_4 = mad(r6_xy_2.xyxy, cb0_values[8].xyxy, float4(r7_x_5, r7_z_5, r7_y_3, r7_z_5));
                    float r3_w_6 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r9_xyzw_4.xyxx).xy, r5_xyz_17.z);
                    float r5_x_23 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r9_xyzw_4.zwzz).xy, r5_xyz_17.z);
                    float r3_w_7 = mad(r8_xyzw_4.x, r3_w_6, (r5_x_23 * r8_xyzw_4.y));
                    float4 r6_xyzw_3 = mad(r6_xy_2.xyxy, cb0_values[8].xyxy, float4(r7_x_5, r7_w_3, r7_y_3, r7_w_3));
                    float r5_x_25 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r6_xyzw_3.xyxx).xy, r5_xyz_17.z);
                    float r3_w_8 = mad(r8_xyzw_4.z, r5_x_25, r3_w_7);
                    float r5_x_26 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r6_xyzw_3.zwzz).xy, r5_xyz_17.z);
                    float r3_w_9 = mad(r8_xyzw_4.w, r5_x_26, r3_w_8);
                    float r3_w_10 = mad(r3_w_9, (-cb3_values[24].x + 1), cb3_values[24].x);
                    r3_w_11 = r3_w_10;
                }
                else
                {
                    float r3_w_5 = 1;
                    r3_w_11 = r3_w_5;
                }
                float r2_w_10 = (r2_w_9 + -r3_w_11);
                float r1_w_7 = mad(r1_w_6, r2_w_10, r3_w_11);
                float r2_w_11 = (0 < r4_xyzw_4.z);
                float r2_w_12 = asfloat(asint(r2_w_11) & asint(1065353216));
                float4 r5_xyzw_29 = (r4_xyzw_4.xyxx / r4_xyzw_4.wwww);
                float r5_x_29 = r5_xyzw_29.x;
                float r5_y_24 = r5_xyzw_29.y;
                float4 r5_xyzw_30 = (float4(r5_x_29, r5_y_24, r5_x_29, r5_x_29) + float4(0.5, 0.5, 0, 0));
                float r5_x_30 = r5_xyzw_30.x;
                float r5_y_25 = r5_xyzw_30.y;
                float4 r5_xyzw_31 = t2.Sample(sampler_linear_clamp2, (float4(r5_x_30, r5_y_25, r5_x_30, r5_x_30)).xy);
                float r2_w_13 = (r2_w_12 * r5_xyzw_31.w);
                float r3_w_12 = dot(r4_xyzw_4.xyzx, r4_xyzw_4.xyzx);
                float4 r4_xyzw_5 = t3.Sample(sampler_linear_clamp3, (r3_w_12.xxxx).xy);
                float r2_w_14 = (r2_w_13 * r4_xyzw_5.x);
                float r1_w_8 = (r1_w_7 * r2_w_14);
                float r4_x_6 = dot(i.texcoord1.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_y_6 = dot(i.texcoord2.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_z_6 = dot(i.texcoord3.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r2_w_15 = dot(float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6), float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r2_w_16 = rsqrt(r2_w_15);
                float4 r3_xyzw_4 = (r2_w_16.xxxx * float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r3_z_3 = r3_xyzw_4.z;
                float3 r4_xyz_7 = ((r1_w_8.xxxx * _LightColor0.xyzx)).xyz;
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_4.xxxx, r0_xyz_2.xyzx)).xyz;
                float r0_w_5 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_6 = rsqrt(r0_w_5);
                float r0_x_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), r0_xyz_2.xyzx);
                float r0_y_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), ((r0_w_6.xxxx * r1_xyz_2.xyzx)).xyzx);
                float2 r0_xy_4 = (max(float4(r0_x_3, r0_y_3, r0_x_3, r0_x_3), float4(0, 0, 0, 0))).xy;
                float r0_z_3 = (cb0_values[14].x * 128);
                float r0_y_5 = log2(r0_xy_4.y);
                float r0_y_6 = (r0_y_5 * r0_z_3);
                float r0_y_7 = exp2(r0_y_6);
                float r0_y_8 = (r0_y_7 * cb0_values[14].y);
                float4 r0_xyzw_9 = (r0_y_8.xxxx * ((r4_xyz_7.xyzx * _SpecColor.xyzx)).xxyz);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_4 = r0_xyzw_9.z;
                float r0_w_7 = r0_xyzw_9.w;
                o.sv_Target0.xyz = (mad(((((r2_xyzw_1.xyzx * cb0_values[13].xyzx)).xyzx * r4_xyz_7.xyzx)).xyzx, r0_xy_4.xxxx, float4(r0_y_9, r0_z_4, r0_w_7, r0_y_9))).xyz;
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
                float4 _SpecColor;
                float4 _Color;
                float _Shininess;
                float _Gloss;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 cb0_values[12];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
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
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program94Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
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
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[11].xxxy, cb0_values[11].zzzw)).zw;
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                float3 unitWorldNormal_xyz_3 = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_6 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_6.xxxx * (mad(unitWorldNormal_xyz_3.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_3.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_3.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_3.z;
                o.texcoord3.z = unitWorldNormal_xyz_3.x;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord4.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float4 clipPos_xyzw_4 = (worldPos_xyzw_4.yyyy * cb0_values[5].xyzw);
                float4 clipPos_xyzw_5 = mad(_Color, worldPos_xyzw_4.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(_MainTex_ST, worldPos_xyzw_4.zzzz, clipPos_xyzw_5);
                o.texcoord5.xyzw = mad(_BumpMap_ST, worldPos_xyzw_4.wwww, clipPos_xyzw_6);
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program94Output frag(program94Input i)
            {
                program94Output o = (program94Output)0;
                float3 r0_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r0_xyz_2 = normalize(r0_xyz_1);
                float3 viewDir_xyz_1 = ((-i.texcoord4.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_3 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r3_x_2 = (r3_xyzw_1.w * r3_xyzw_1.x);
                float4 r3_xyzw_3 = mad(float4(r3_x_2, r3_xyzw_1.y, r3_x_2, r3_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r1_w_1 = dot(float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3), float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r3_z_2 = sqrt(r1_w_3);
                float4 r4_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord4.zzzz, mad(cb0_values[4].xyzw, i.texcoord4.xxxx, (i.texcoord4.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r5_x_1 = cb4_values[9].z;
                float r5_y_1 = cb4_values[10].z;
                float r5_z_1 = cb4_values[11].z;
                float r1_w_4 = dot(viewDir_xyz_1.xyzx, float4(r5_x_1, r5_y_1, r5_z_1, r5_x_1));
                float3 r5_xyz_2 = ((i.texcoord4.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = dot(r5_xyz_2.xyzx, r5_xyz_2.xyzx);
                float r2_w_3 = sqrt(r2_w_2);
                float r2_w_4 = (-r1_w_4 + r2_w_3);
                float r1_w_5 = mad(cb3_values[25].w, r2_w_4, r1_w_4);
                float r1_w_6 = saturate(mad(r1_w_5, cb3_values[24].z, cb3_values[24].w));
                float r2_w_5 = (cb5_values[0].x == 1);
                float r5_x_12;
                float r5_y_12;
                float r5_z_12;
                float r5_w_4;
                if (r2_w_5)
                {
                    float r2_w_6 = (cb5_values[0].y == 1);
                    float3 r5_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord4.zzzz, (mad(cb5_values[1].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r5_xyzw_10 = (((((r2_w_6.xxxx ? r5_xyz_7.xyzx : i.texcoord4.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r5_y_10 = r5_xyzw_10.y;
                    float r5_z_10 = r5_xyzw_10.z;
                    float r5_w_2 = r5_xyzw_10.w;
                    float r2_w_7 = mad(r5_y_10, 0.25, 0.75);
                    float r3_w_2 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r5_x_10 = max(r2_w_7, r3_w_2);
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
                float r2_w_9 = saturate(dot(float4(r5_x_12, r5_y_12, r5_z_12, r5_w_4), unity_OcclusionMaskSelector));
                float4 r5_xyzw_13 = (i.texcoord4.yyyy * cb3_values[9].xyzw);
                float4 r5_xyzw_14 = mad(cb3_values[8].xyzw, i.texcoord4.xxxx, r5_xyzw_13);
                float4 r5_xyzw_15 = mad(cb3_values[10].xyzw, i.texcoord4.zzzz, r5_xyzw_14);
                float4 r5_xyzw_16 = (r5_xyzw_15 + cb3_values[11].xyzw);
                float3 r5_xyz_17 = ((r5_xyzw_16.xyzx / r5_xyzw_16.wwww)).xyz;
                float r3_w_4 = t5.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r5_xyz_17.xyxx).xy, r5_xyz_17.z);
                float r3_w_5 = mad(r3_w_4, (-cb3_values[24].x + 1), cb3_values[24].x);
                float r2_w_10 = (r2_w_9 + -r3_w_5);
                float r1_w_7 = mad(r1_w_6, r2_w_10, r3_w_5);
                float r2_w_11 = (0 < r4_xyzw_4.z);
                float r2_w_12 = asfloat(asint(r2_w_11) & asint(1065353216));
                float4 r5_xyzw_19 = (r4_xyzw_4.xyxx / r4_xyzw_4.wwww);
                float r5_x_19 = r5_xyzw_19.x;
                float r5_y_18 = r5_xyzw_19.y;
                float4 r5_xyzw_20 = (float4(r5_x_19, r5_y_18, r5_x_19, r5_x_19) + float4(0.5, 0.5, 0, 0));
                float r5_x_20 = r5_xyzw_20.x;
                float r5_y_19 = r5_xyzw_20.y;
                float4 r5_xyzw_21 = t2.Sample(sampler_linear_clamp2, (float4(r5_x_20, r5_y_19, r5_x_20, r5_x_20)).xy);
                float r2_w_13 = (r2_w_12 * r5_xyzw_21.w);
                float r3_w_6 = dot(r4_xyzw_4.xyzx, r4_xyzw_4.xyzx);
                float4 r4_xyzw_5 = t3.Sample(sampler_linear_clamp3, (r3_w_6.xxxx).xy);
                float r2_w_14 = (r2_w_13 * r4_xyzw_5.x);
                float r1_w_8 = (r1_w_7 * r2_w_14);
                float r4_x_6 = dot(i.texcoord1.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_y_6 = dot(i.texcoord2.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_z_6 = dot(i.texcoord3.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r2_w_15 = dot(float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6), float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r2_w_16 = rsqrt(r2_w_15);
                float4 r3_xyzw_4 = (r2_w_16.xxxx * float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r3_z_3 = r3_xyzw_4.z;
                float3 r4_xyz_7 = ((r1_w_8.xxxx * _LightColor0.xyzx)).xyz;
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_4.xxxx, r0_xyz_2.xyzx)).xyz;
                float r0_w_5 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_6 = rsqrt(r0_w_5);
                float r0_x_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), r0_xyz_2.xyzx);
                float r0_y_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), ((r0_w_6.xxxx * r1_xyz_2.xyzx)).xyzx);
                float2 r0_xy_4 = (max(float4(r0_x_3, r0_y_3, r0_x_3, r0_x_3), float4(0, 0, 0, 0))).xy;
                float r0_z_3 = (cb0_values[9].x * 128);
                float r0_y_5 = log2(r0_xy_4.y);
                float r0_y_6 = (r0_y_5 * r0_z_3);
                float r0_y_7 = exp2(r0_y_6);
                float r0_y_8 = (r0_y_7 * cb0_values[9].y);
                float4 r0_xyzw_9 = (r0_y_8.xxxx * ((r4_xyz_7.xyzx * _SpecColor.xyzx)).xxyz);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_4 = r0_xyzw_9.z;
                float r0_w_7 = r0_xyzw_9.w;
                o.sv_Target0.xyz = (mad(((((r2_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * r4_xyz_7.xyzx)).xyzx, r0_xy_4.xxxx, float4(r0_y_9, r0_z_4, r0_w_7, r0_y_9))).xyz;
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
                float4 _SpecColor;
                float4 _Color;
                float _Shininess;
                float _Gloss;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 cb0_values[12];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
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
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float2 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program93Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float2 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
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
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[11].xxxy, cb0_values[11].zzzw)).zw;
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                float3 unitWorldNormal_xyz_3 = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_6 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_6.xxxx * (mad(unitWorldNormal_xyz_3.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_3.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_3.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_3.z;
                o.texcoord3.z = unitWorldNormal_xyz_3.x;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord4.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float2 clipPos_xy_4 = ((worldPos_xyzw_4.yyyy * cb0_values[5].xyxx)).xy;
                float2 clipPos_xy_5 = (mad(_Color.xyxx, worldPos_xyzw_4.xxxx, clipPos_xy_4.xyxx)).xy;
                float2 clipPos_xy_6 = (mad(_MainTex_ST.xyxx, worldPos_xyzw_4.zzzz, clipPos_xy_5.xyxx)).xy;
                o.texcoord5.xy = (mad(_BumpMap_ST.xyxx, worldPos_xyzw_4.wwww, clipPos_xy_6.xyxx)).xy;
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program93Output frag(program93Input i)
            {
                program93Output o = (program93Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord4.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r2_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r2_x_2 = (r2_xyzw_1.w * r2_xyzw_1.x);
                float4 r2_xyzw_3 = mad(float4(r2_x_2, r2_xyzw_1.y, r2_x_2, r2_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r2_x_3 = r2_xyzw_3.x;
                float r2_y_2 = r2_xyzw_3.y;
                float r1_w_2 = dot(float4(r2_x_3, r2_y_2, r2_x_3, r2_x_3), float4(r2_x_3, r2_y_2, r2_x_3, r2_x_3));
                float r1_w_3 = min(r1_w_2, 1);
                float r1_w_4 = (-r1_w_3 + 1);
                float r2_z_2 = sqrt(r1_w_4);
                float r1_w_5 = (unity_ProbeVolumeParams.x == 1);
                float r4_x_10;
                float r4_y_10;
                float r4_z_10;
                float r4_w_4;
                if (r1_w_5)
                {
                    float r1_w_6 = (unity_ProbeVolumeParams.y == 1);
                    float3 r4_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord4.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r1_w_6.xxxx ? r4_xyz_5.xyzx : i.texcoord4.xyzx)).xyz;
                    float4 r4_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r4_y_8 = r4_xyzw_8.y;
                    float r4_z_8 = r4_xyzw_8.z;
                    float r4_w_2 = r4_xyzw_8.w;
                    float r1_w_7 = mad(r4_y_8, 0.25, 0.75);
                    float r2_w_2 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r4_x_8 = max(r1_w_7, r2_w_2);
                    float4 r4_xyzw_9 = t3.Sample(sampler_linear_clamp, (float4(r4_x_8, r4_z_8, r4_w_2, r4_x_8)).xyz);
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
                float r1_w_9 = saturate(dot(float4(r4_x_10, r4_y_10, r4_z_10, r4_w_4), unity_OcclusionMaskSelector));
                float4 r3_xyzw_5 = t2.Sample(sampler_linear_clamp1, ((((mad(cb0_values[6].xyxx, i.texcoord4.zzzz, (mad(cb0_values[4].xyxx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx).xy);
                float r1_w_10 = (r1_w_9 * r3_xyzw_5.w);
                float r3_x_6 = dot(i.texcoord1.xyzx, float4(r2_x_3, r2_y_2, r2_z_2, r2_x_3));
                float r3_y_6 = dot(i.texcoord2.xyzx, float4(r2_x_3, r2_y_2, r2_z_2, r2_x_3));
                float r3_z_2 = dot(i.texcoord3.xyzx, float4(r2_x_3, r2_y_2, r2_z_2, r2_x_3));
                float4 r2_xyzw_6 = ((rsqrt(dot(float4(r3_x_6, r3_y_6, r3_z_2, r3_x_6), float4(r3_x_6, r3_y_6, r3_z_2, r3_x_6)))).xxxx * float4(r3_x_6, r3_y_6, r3_z_2, r3_x_6));
                float r2_x_6 = r2_xyzw_6.x;
                float r2_y_3 = r2_xyzw_6.y;
                float r2_z_3 = r2_xyzw_6.z;
                float4 r3_xyzw_7 = (r1_w_10.xxxx * _LightColor0.xyzx);
                float r3_x_7 = r3_xyzw_7.x;
                float r3_y_7 = r3_xyzw_7.y;
                float r3_z_3 = r3_xyzw_7.z;
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_w_5 = dot(float4(r2_x_6, r2_y_3, r2_z_3, r2_x_6), _WorldSpaceLightPos0.xyzx);
                float r0_x_4 = dot(float4(r2_x_6, r2_y_3, r2_z_3, r2_x_6), ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx);
                float4 r0_xyzw_5 = max(float4(r0_x_4, r0_x_4, r0_x_4, r0_w_5), float4(0, 0, 0, 0));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_w_6 = r0_xyzw_5.w;
                float r0_y_4 = (cb0_values[9].x * 128);
                float4 r2_xyzw_7 = (float4(r3_x_7, r3_y_7, r3_z_3, r3_x_7) * _SpecColor.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_4 = r2_xyzw_7.y;
                float r2_z_4 = r2_xyzw_7.z;
                                float4 r0_xyzw_10 = (((pow(r0_x_5, r0_y_4) * cb0_values[9].y)).xxxx * float4(r2_x_7, r2_y_4, r2_z_4, r2_x_7));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_5 = r0_xyzw_10.y;
                float r0_z_4 = r0_xyzw_10.z;
                o.sv_Target0.xyz = (mad(((((r1_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * float4(r3_x_7, r3_y_7, r3_z_3, r3_x_7))).xyzx, r0_w_6.xxxx, float4(r0_x_10, r0_y_5, r0_z_4, r0_x_10))).xyz;
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
                float4 _SpecColor;
                float4 _Color;
                float _Shininess;
                float _Gloss;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 cb0_values[12];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
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
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program92Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
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
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[11].xxxy, cb0_values[11].zzzw)).zw;
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                float3 unitWorldNormal_xyz_3 = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_6 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_6.xxxx * (mad(unitWorldNormal_xyz_3.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_3.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_3.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_3.z;
                o.texcoord3.z = unitWorldNormal_xyz_3.x;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord4.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_4 = ((worldPos_xyzw_4.yyyy * cb0_values[5].xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.zzzz, (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_4.xyzx)).xyzx)).xyz;
                o.texcoord5.xyz = (mad(_BumpMap_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program92Output frag(program92Input i)
            {
                program92Output o = (program92Output)0;
                float3 r0_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r0_xyz_2 = normalize(r0_xyz_1);
                float3 viewDir_xyz_1 = ((-i.texcoord4.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_3 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r3_x_2 = (r3_xyzw_1.w * r3_xyzw_1.x);
                float4 r3_xyzw_3 = mad(float4(r3_x_2, r3_xyzw_1.y, r3_x_2, r3_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r1_w_1 = dot(float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3), float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r3_z_2 = sqrt(r1_w_3);
                float3 r4_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord4.zzzz, (mad(cb0_values[4].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r1_w_4 = (unity_ProbeVolumeParams.x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r1_w_4)
                {
                    float r1_w_5 = (unity_ProbeVolumeParams.y == 1);
                    float3 r5_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord4.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r1_w_5.xxxx ? r5_xyz_5.xyzx : i.texcoord4.xyzx)).xyz;
                    float4 r5_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r1_w_6 = mad(r5_y_8, 0.25, 0.75);
                    float r2_w_2 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r5_x_8 = max(r1_w_6, r2_w_2);
                    float4 r5_xyzw_9 = t4.Sample(sampler_linear_clamp, (float4(r5_x_8, r5_z_8, r5_w_2, r5_x_8)).xyz);
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
                float r2_w_4 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float4 r5_xyzw_11 = t2.Sample(sampler_linear_clamp2, (r2_w_4.xxxx).xy);
                float4 r4_xyzw_5 = t3.Sample(sampler_linear_clamp1, r4_xyz_4.xyz);
                float r2_w_5 = (r4_xyzw_5.w * r5_xyzw_11.x);
                float r1_w_9 = (r1_w_8 * r2_w_5);
                float r4_x_6 = dot(i.texcoord1.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_y_6 = dot(i.texcoord2.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_z_6 = dot(i.texcoord3.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r2_w_6 = dot(float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6), float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r2_w_7 = rsqrt(r2_w_6);
                float4 r3_xyzw_4 = (r2_w_7.xxxx * float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r3_z_3 = r3_xyzw_4.z;
                float3 r4_xyz_7 = ((r1_w_9.xxxx * _LightColor0.xyzx)).xyz;
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_4.xxxx, r0_xyz_2.xyzx)).xyz;
                float r0_w_5 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_6 = rsqrt(r0_w_5);
                float r0_x_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), r0_xyz_2.xyzx);
                float r0_y_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), ((r0_w_6.xxxx * r1_xyz_2.xyzx)).xyzx);
                float2 r0_xy_4 = (max(float4(r0_x_3, r0_y_3, r0_x_3, r0_x_3), float4(0, 0, 0, 0))).xy;
                float r0_z_3 = (cb0_values[9].x * 128);
                float r0_y_5 = log2(r0_xy_4.y);
                float r0_y_6 = (r0_y_5 * r0_z_3);
                float r0_y_7 = exp2(r0_y_6);
                float r0_y_8 = (r0_y_7 * cb0_values[9].y);
                float4 r0_xyzw_9 = (r0_y_8.xxxx * ((r4_xyz_7.xyzx * _SpecColor.xyzx)).xxyz);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_4 = r0_xyzw_9.z;
                float r0_w_7 = r0_xyzw_9.w;
                o.sv_Target0.xyz = (mad(((((r2_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * r4_xyz_7.xyzx)).xyzx, r0_xy_4.xxxx, float4(r0_y_9, r0_z_4, r0_w_7, r0_y_9))).xyz;
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
                float4 _SpecColor;
                float4 _Color;
                float _Shininess;
                float _Gloss;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 cb0_values[12];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
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
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program91Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
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
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[10].xyxx, cb0_values[10].zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, cb0_values[11].xxxy, cb0_values[11].zzzw)).zw;
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                float3 unitWorldNormal_xyz_3 = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = normalize(worldTangent_xyz_6);
                float r1_w_6 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r3_xyz_3 = ((r1_w_6.xxxx * (mad(unitWorldNormal_xyz_3.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_3.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_3.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_3.z;
                o.texcoord3.z = unitWorldNormal_xyz_3.x;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord4.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float4 clipPos_xyzw_4 = (worldPos_xyzw_4.yyyy * cb0_values[5].xyzw);
                float4 clipPos_xyzw_5 = mad(_Color, worldPos_xyzw_4.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(_MainTex_ST, worldPos_xyzw_4.zzzz, clipPos_xyzw_5);
                o.texcoord5.xyzw = mad(_BumpMap_ST, worldPos_xyzw_4.wwww, clipPos_xyzw_6);
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program91Output frag(program91Input i)
            {
                program91Output o = (program91Output)0;
                float3 r0_xyz_1 = ((-i.texcoord4.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float3 r0_xyz_2 = normalize(r0_xyz_1);
                float3 viewDir_xyz_1 = ((-i.texcoord4.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_3 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r3_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r3_x_2 = (r3_xyzw_1.w * r3_xyzw_1.x);
                float4 r3_xyzw_3 = mad(float4(r3_x_2, r3_xyzw_1.y, r3_x_2, r3_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r3_x_3 = r3_xyzw_3.x;
                float r3_y_2 = r3_xyzw_3.y;
                float r1_w_1 = dot(float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3), float4(r3_x_3, r3_y_2, r3_x_3, r3_x_3));
                float r1_w_2 = min(r1_w_1, 1);
                float r1_w_3 = (-r1_w_2 + 1);
                float r3_z_2 = sqrt(r1_w_3);
                float4 r4_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord4.zzzz, mad(cb0_values[4].xyzw, i.texcoord4.xxxx, (i.texcoord4.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r1_w_4 = (unity_ProbeVolumeParams.x == 1);
                float r5_x_10;
                float r5_y_10;
                float r5_z_10;
                float r5_w_4;
                if (r1_w_4)
                {
                    float r1_w_5 = (unity_ProbeVolumeParams.y == 1);
                    float3 r5_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord4.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r1_w_5.xxxx ? r5_xyz_5.xyzx : i.texcoord4.xyzx)).xyz;
                    float4 r5_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r5_y_8 = r5_xyzw_8.y;
                    float r5_z_8 = r5_xyzw_8.z;
                    float r5_w_2 = r5_xyzw_8.w;
                    float r1_w_6 = mad(r5_y_8, 0.25, 0.75);
                    float r2_w_2 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r5_x_8 = max(r1_w_6, r2_w_2);
                    float4 r5_xyzw_9 = t4.Sample(sampler_linear_clamp, (float4(r5_x_8, r5_z_8, r5_w_2, r5_x_8)).xyz);
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
                float r2_w_4 = (0 < r4_xyzw_4.z);
                float r2_w_5 = asfloat(asint(r2_w_4) & asint(1065353216));
                float4 r5_xyzw_13 = t2.Sample(sampler_linear_clamp1, (((((r4_xyzw_4.xyxx / r4_xyzw_4.wwww)).xyxx + float4(0.5, 0.5, 0, 0))).xyxx).xy);
                float r2_w_6 = (r2_w_5 * r5_xyzw_13.w);
                float r3_w_2 = dot(r4_xyzw_4.xyzx, r4_xyzw_4.xyzx);
                float4 r4_xyzw_5 = t3.Sample(sampler_linear_clamp2, (r3_w_2.xxxx).xy);
                float r2_w_7 = (r2_w_6 * r4_xyzw_5.x);
                float r1_w_9 = (r1_w_8 * r2_w_7);
                float r4_x_6 = dot(i.texcoord1.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_y_6 = dot(i.texcoord2.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r4_z_6 = dot(i.texcoord3.xyzx, float4(r3_x_3, r3_y_2, r3_z_2, r3_x_3));
                float r2_w_8 = dot(float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6), float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r2_w_9 = rsqrt(r2_w_8);
                float4 r3_xyzw_4 = (r2_w_9.xxxx * float4(r4_x_6, r4_y_6, r4_z_6, r4_x_6));
                float r3_x_4 = r3_xyzw_4.x;
                float r3_y_3 = r3_xyzw_4.y;
                float r3_z_3 = r3_xyzw_4.z;
                float3 r4_xyz_7 = ((r1_w_9.xxxx * _LightColor0.xyzx)).xyz;
                float3 r1_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_4.xxxx, r0_xyz_2.xyzx)).xyz;
                float r0_w_5 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_6 = rsqrt(r0_w_5);
                float r0_x_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), r0_xyz_2.xyzx);
                float r0_y_3 = dot(float4(r3_x_4, r3_y_3, r3_z_3, r3_x_4), ((r0_w_6.xxxx * r1_xyz_2.xyzx)).xyzx);
                float2 r0_xy_4 = (max(float4(r0_x_3, r0_y_3, r0_x_3, r0_x_3), float4(0, 0, 0, 0))).xy;
                float r0_z_3 = (cb0_values[9].x * 128);
                float r0_y_5 = log2(r0_xy_4.y);
                float r0_y_6 = (r0_y_5 * r0_z_3);
                float r0_y_7 = exp2(r0_y_6);
                float r0_y_8 = (r0_y_7 * cb0_values[9].y);
                float4 r0_xyzw_9 = (r0_y_8.xxxx * ((r4_xyz_7.xyzx * _SpecColor.xyzx)).xxyz);
                float r0_y_9 = r0_xyzw_9.y;
                float r0_z_4 = r0_xyzw_9.z;
                float r0_w_7 = r0_xyzw_9.w;
                o.sv_Target0.xyz = (mad(((((r2_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * r4_xyz_7.xyzx)).xyzx, r0_xy_4.xxxx, float4(r0_y_9, r0_z_4, r0_w_7, r0_y_9))).xyz;
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
                float4 _SpecColor;
                float4 _Color;
                float _Shininess;
                float _Gloss;
                float4 _MainTex_ST;
                float4 _BumpMap_ST;
                float4 cb0_values[6];
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
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
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program90Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord6 : TEXCOORD6;
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
                o.texcoord4.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                float3 unitWorldNormal_xyz_8 = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                float3 worldTangent_xyz_2 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_3 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_2.xyzx)).xyz;
                float3 worldTangent_xyz_4 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_3.xyzx)).xyz;
                float3 unitWorldTangent_xyz_5 = normalize(worldTangent_xyz_4);
                float r0_w_11 = (i.tangent0.w * unity_WorldTransformParams.w);
                float3 r2_xyz_3 = ((r0_w_11.xxxx * (mad(unitWorldNormal_xyz_8.zxyz, unitWorldTangent_xyz_5.yzxy, ((unitWorldNormal_xyz_8.xyzx * unitWorldTangent_xyz_5.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r2_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_5.z;
                o.texcoord1.z = unitWorldNormal_xyz_8.y;
                o.texcoord2.x = unitWorldTangent_xyz_5.x;
                o.texcoord3.x = unitWorldTangent_xyz_5.y;
                o.texcoord2.z = unitWorldNormal_xyz_8.z;
                o.texcoord3.z = unitWorldNormal_xyz_8.x;
                o.texcoord2.y = r2_xyz_3.y;
                o.texcoord3.y = r2_xyz_3.z;
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program90Output frag(program90Input i)
            {
                program90Output o = (program90Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord4.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r2_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r2_x_2 = (r2_xyzw_1.w * r2_xyzw_1.x);
                float4 r2_xyzw_3 = mad(float4(r2_x_2, r2_xyzw_1.y, r2_x_2, r2_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r2_x_3 = r2_xyzw_3.x;
                float r2_y_2 = r2_xyzw_3.y;
                float r1_w_2 = dot(float4(r2_x_3, r2_y_2, r2_x_3, r2_x_3), float4(r2_x_3, r2_y_2, r2_x_3, r2_x_3));
                float r1_w_3 = min(r1_w_2, 1);
                float r1_w_4 = (-r1_w_3 + 1);
                float r2_z_2 = sqrt(r1_w_4);
                float r1_w_5 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r1_w_5)
                {
                    float r1_w_6 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord4.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord4.xxxx, ((i.texcoord4.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r1_w_6.xxxx ? r3_xyz_5.xyzx : i.texcoord4.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r1_w_7 = mad(r3_y_8, 0.25, 0.75);
                    float r2_w_2 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r1_w_7, r2_w_2);
                    float4 r3_xyzw_9 = t2.Sample(sampler_linear_clamp, (float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8)).xyz);
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
                float r1_w_9 = saturate(dot(float4(r3_x_10, r3_y_10, r3_z_10, r3_w_4), unity_OcclusionMaskSelector));
                float r3_x_11 = dot(i.texcoord1.xyzx, float4(r2_x_3, r2_y_2, r2_z_2, r2_x_3));
                float r3_y_11 = dot(i.texcoord2.xyzx, float4(r2_x_3, r2_y_2, r2_z_2, r2_x_3));
                float r3_z_11 = dot(i.texcoord3.xyzx, float4(r2_x_3, r2_y_2, r2_z_2, r2_x_3));
                float4 r2_xyzw_6 = ((rsqrt(dot(float4(r3_x_11, r3_y_11, r3_z_11, r3_x_11), float4(r3_x_11, r3_y_11, r3_z_11, r3_x_11)))).xxxx * float4(r3_x_11, r3_y_11, r3_z_11, r3_x_11));
                float r2_x_6 = r2_xyzw_6.x;
                float r2_y_3 = r2_xyzw_6.y;
                float r2_z_3 = r2_xyzw_6.z;
                float3 r3_xyz_12 = ((r1_w_9.xxxx * _LightColor0.xyzx)).xyz;
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_w_5 = dot(float4(r2_x_6, r2_y_3, r2_z_3, r2_x_6), _WorldSpaceLightPos0.xyzx);
                float r0_x_4 = dot(float4(r2_x_6, r2_y_3, r2_z_3, r2_x_6), ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx);
                float4 r0_xyzw_5 = max(float4(r0_x_4, r0_x_4, r0_x_4, r0_w_5), float4(0, 0, 0, 0));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_w_6 = r0_xyzw_5.w;
                float r0_y_4 = (cb0_values[5].x * 128);
                float4 r2_xyzw_7 = (r3_xyz_12.xyzx * _SpecColor.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_4 = r2_xyzw_7.y;
                float r2_z_4 = r2_xyzw_7.z;
                                float4 r0_xyzw_10 = (((pow(r0_x_5, r0_y_4) * cb0_values[5].y)).xxxx * float4(r2_x_7, r2_y_4, r2_z_4, r2_x_7));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_5 = r0_xyzw_10.y;
                float r0_z_4 = r0_xyzw_10.z;
                o.sv_Target0.xyz = (mad(((((r1_xyzw_1.xyzx * cb0_values[4].xyzx)).xyzx * r3_xyz_12.xyzx)).xyzx, r0_w_6.xxxx, float4(r0_x_10, r0_y_5, r0_z_4, r0_x_10))).xyz;
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
                float4 _SpecColor : packoffset(c3);
                float4 _Color : packoffset(c4);
                float _Shininess : packoffset(c5.x);
                float _Gloss : packoffset(c5.y);
                float4 _MainTex_ST : packoffset(c6);
                float4 _BumpMap_ST : packoffset(c7);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program123Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
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
                float3 worldPos_xyz_4 = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord1.w = worldPos_xyz_4.x;
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float3 unitWorldNormal_xyz_3 = (((rsqrt(dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2)))).xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = (((rsqrt(dot(worldTangent_xyz_6.xyzx, worldTangent_xyz_6.xyzx))).xxxx * worldTangent_xyz_6.xyzx)).xyz;
                float3 r3_xyz_3 = ((((i.tangent0.w * unity_WorldTransformParams.w)).xxxx * (mad(unitWorldNormal_xyz_3.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_3.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_3.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_3.z;
                o.texcoord3.z = unitWorldNormal_xyz_3.x;
                o.texcoord2.w = worldPos_xyz_4.y;
                o.texcoord3.w = worldPos_xyz_4.z;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program123Output frag(program123Input i)
            {
                program123Output o = (program123Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                o.sv_Target0.xyz = ((r0_xyzw_1.xyzx * _Color.xyzx)).xyz;
                o.sv_Target0.w = 1;
                o.sv_Target1.xyz = ((((_SpecColor.xyzx * _Gloss.xxxx)).xyzx * float4(0.31830987, 0.31830987, 0.31830987, 0))).xyz;
                o.sv_Target1.w = _Shininess;
                float4 r0_xyzw_3 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r0_x_4 = (r0_xyzw_3.w * r0_xyzw_3.x);
                float4 r0_xyzw_5 = mad(float4(r0_x_4, r0_xyzw_3.y, r0_x_4, r0_x_4), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_w_3 = dot(float4(r0_x_5, r0_y_4, r0_x_5, r0_x_5), float4(r0_x_5, r0_y_4, r0_x_5, r0_x_5));
                float r0_w_4 = min(r0_w_3, 1);
                float r0_w_5 = (-r0_w_4 + 1);
                float r0_z_4 = sqrt(r0_w_5);
                float r1_x_1 = dot(i.texcoord1.xyzx, float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5));
                float r1_y_1 = dot(i.texcoord2.xyzx, float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5));
                float r1_z_1 = dot(i.texcoord3.xyzx, float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5));
                float4 r0_xyzw_8 = ((rsqrt(dot(float4(r1_x_1, r1_y_1, r1_z_1, r1_x_1), float4(r1_x_1, r1_y_1, r1_z_1, r1_x_1)))).xxxx * float4(r1_x_1, r1_y_1, r1_z_1, r1_x_1));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_5 = r0_xyzw_8.y;
                float r0_z_5 = r0_xyzw_8.z;
                o.sv_Target2.xyz = (mad(float4(r0_x_8, r0_y_5, r0_z_5, r0_x_8), float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
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
                float4 _SpecColor : packoffset(c3);
                float4 _Color : packoffset(c4);
                float _Shininess : packoffset(c5.x);
                float _Gloss : packoffset(c5.y);
                float4 _MainTex_ST : packoffset(c6);
                float4 _BumpMap_ST : packoffset(c7);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
                float4 cb1_values[46];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[10];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[21];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_MainTex;
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
            };
            struct program126Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
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
                float3 r0_xyz_4 = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord1.w = r0_xyz_4.x;
                float3 worldTangent_xyz_2 = ((i.tangent0.yyyy * cb2_values[1].yzxy)).xyz;
                float3 worldTangent_xyz_3 = (mad(cb2_values[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_2.xyzx)).xyz;
                float3 worldTangent_xyz_4 = (mad(cb2_values[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_3.xyzx)).xyz;
                float3 unitWorldTangent_xyz_5 = (((rsqrt(dot(worldTangent_xyz_4.xyzx, worldTangent_xyz_4.xyzx))).xxxx * worldTangent_xyz_4.xyzx)).xyz;
                o.texcoord1.x = unitWorldTangent_xyz_5.z;
                float worldNormal_x_4 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float4 unitWorldNormal_xyzw_5 = ((rsqrt(dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4)))).xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_z_4));
                float3 r3_xyz_3 = ((((i.tangent0.w * cb2_values[9].w)).xxxx * (mad(unitWorldNormal_xyzw_5.ywxy, unitWorldTangent_xyz_5.yzxy, ((unitWorldTangent_xyz_5.xyzx * unitWorldNormal_xyzw_5.wxyw)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.z = unitWorldNormal_xyzw_5.x;
                o.texcoord2.x = unitWorldTangent_xyz_5.x;
                o.texcoord3.x = unitWorldTangent_xyz_5.y;
                o.texcoord2.w = r0_xyz_4.y;
                o.texcoord3.w = r0_xyz_4.z;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord2.z = unitWorldNormal_xyzw_5.y;
                o.texcoord3.z = unitWorldNormal_xyzw_5.w;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                float4 r1_xyzw_6 = (unitWorldNormal_xyzw_5.ywzx * unitWorldNormal_xyzw_5);
                float r2_x_6 = dot(cb1_values[42].xyzw, r1_xyzw_6);
                float r2_y_6 = dot(cb1_values[43].xyzw, r1_xyzw_6);
                float r2_z_6 = dot(cb1_values[44].xyzw, r1_xyzw_6);
                o.texcoord5.xyz = (mad(cb1_values[45].xyzx, (mad(unitWorldNormal_xyzw_5.x, unitWorldNormal_xyzw_5.x, (unitWorldNormal_xyzw_5.y * unitWorldNormal_xyzw_5.y))).xxxx, float4(r2_x_6, r2_y_6, r2_z_6, r2_x_6))).xyz;
                return o;
            }
            #pragma fragment frag
            program126Output frag(program126Input i)
            {
                program126Output o = (program126Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r0_xyz_2 = ((r0_xyzw_1.xyzx * _Color.xyzx)).xyz;
                float4 r1_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r1_x_2 = (r1_xyzw_1.w * r1_xyzw_1.x);
                float4 r1_xyzw_3 = mad(float4(r1_x_2, r1_xyzw_1.y, r1_x_2, r1_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_2 = r1_xyzw_3.y;
                float r0_w_2 = dot(float4(r1_x_3, r1_y_2, r1_x_3, r1_x_3), float4(r1_x_3, r1_y_2, r1_x_3, r1_x_3));
                float r0_w_3 = min(r0_w_2, 1);
                float r0_w_4 = (-r0_w_3 + 1);
                float r1_z_2 = sqrt(r0_w_4);
                float r2_x_1 = dot(i.texcoord1.xyzx, float4(r1_x_3, r1_y_2, r1_z_2, r1_x_3));
                float r2_y_1 = dot(i.texcoord2.xyzx, float4(r1_x_3, r1_y_2, r1_z_2, r1_x_3));
                float r2_z_1 = dot(i.texcoord3.xyzx, float4(r1_x_3, r1_y_2, r1_z_2, r1_x_3));
                float r0_w_5 = dot(float4(r2_x_1, r2_y_1, r2_z_1, r2_x_1), float4(r2_x_1, r2_y_1, r2_z_1, r2_x_1));
                float r0_w_6 = rsqrt(r0_w_5);
                float4 r1_xyzw_4 = (r0_w_6.xxxx * float4(r2_x_1, r2_y_1, r2_z_1, r2_x_1));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_3 = r1_xyzw_4.y;
                float r1_z_3 = r1_xyzw_4.z;
                float r0_w_7 = (cb2_values[0].x == 1);
                float3 r3_xyz_5;
                if (r0_w_7)
                {
                    float r0_w_8 = (cb2_values[0].y == 1);
                    float3 r2_xyz_5 = (((mad(cb2_values[3].xyzx, i.texcoord3.wwww, (mad(cb2_values[1].xyzx, i.texcoord1.wwww, ((i.texcoord2.wwww * cb2_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb2_values[4].xyzx)).xyz;
                    float TEXCOORD1_y_2 = i.texcoord1.w;
                    float TEXCOORD2_z_2 = i.texcoord2.w;
                    float TEXCOORD3_w_1 = i.texcoord3.w;
                    float4 r2_xyzw_8 = (((((r0_w_8.xxxx ? r2_xyz_5.xyzx : float4(TEXCOORD1_y_2, TEXCOORD2_z_2, TEXCOORD3_w_1, TEXCOORD1_y_2))).xyzx + -cb2_values[6].xyzx)).xxyz * cb2_values[5].xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_8 = r2_xyzw_8.z;
                    float r2_w_1 = r2_xyzw_8.w;
                    float r0_w_9 = (r2_y_8 * 0.25);
                    float r2_y_9 = (cb2_values[0].z * 0.5);
                    float r0_w_10 = max(r0_w_9, r2_y_9);
                    float r2_x_8 = min(mad(-cb2_values[0].z, 0.5, 0.25), r0_w_10);
                    float4 r3_xyzw_3 = t2.Sample(sampler_linear_clamp, (float4(r2_x_8, r2_z_8, r2_w_1, r2_x_8)).xyz);
                    float4 r4_xyzw_2 = t2.Sample(sampler_linear_clamp, (((float4(r2_x_8, r2_z_8, r2_w_1, r2_x_8) + float4(0.25, 0, 0, 0))).xyzx).xyz);
                    float4 r2_xyzw_9 = (float4(r2_x_8, r2_z_8, r2_w_1, r2_x_8) + float4(0.5, 0, 0, 0));
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_10 = r2_xyzw_9.y;
                    float r2_z_9 = r2_xyzw_9.z;
                    float4 r2_xyzw_10 = t2.Sample(sampler_linear_clamp, (float4(r2_x_9, r2_y_10, r2_z_9, r2_x_9)).xyz);
                    float r1_w_3 = 1;
                    float r3_x_4 = dot(r3_xyzw_3, float4(r1_x_4, r1_y_3, r1_z_3, r1_w_3));
                    float r3_y_4 = dot(r4_xyzw_2, float4(r1_x_4, r1_y_3, r1_z_3, r1_w_3));
                    float r3_z_4 = dot(r2_xyzw_10, float4(r1_x_4, r1_y_3, r1_z_3, r1_w_3));
                    r3_xyz_5 = float3(r3_x_4, r3_y_4, r3_z_4);
                }
                else
                {
                    float r1_w_2 = 1;
                    float r3_x_1 = dot(cb1_values[39].xyzw, float4(r1_x_4, r1_y_3, r1_z_3, r1_w_2));
                    float r3_y_1 = dot(cb1_values[40].xyzw, float4(r1_x_4, r1_y_3, r1_z_3, r1_w_2));
                    float r3_z_1 = dot(cb1_values[41].xyzw, float4(r1_x_4, r1_y_3, r1_z_3, r1_w_2));
                    r3_xyz_5 = float3(r3_x_1, r3_y_1, r3_z_1);
                }
                float4 r2_xyzw_12 = (r3_xyz_5.xyzx + i.texcoord5.xyzx);
                float r2_x_12 = r2_xyzw_12.x;
                float r2_y_13 = r2_xyzw_12.y;
                float r2_z_12 = r2_xyzw_12.z;
                float4 r2_xyzw_13 = max(float4(r2_x_12, r2_y_13, r2_z_12, r2_x_12), float4(0, 0, 0, 0));
                float r2_x_13 = r2_xyzw_13.x;
                float r2_y_14 = r2_xyzw_13.y;
                float r2_z_13 = r2_xyzw_13.z;
                o.sv_Target1.xyz = ((((_SpecColor.xyzx * _Gloss.xxxx)).xyzx * float4(0.31830987, 0.31830987, 0.31830987, 0))).xyz;
                o.sv_Target2.xyz = (mad(float4(r1_x_4, r1_y_3, r1_z_3, r1_x_4), float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
                o.sv_Target3.xyz = ((r0_xyz_2.xyzx * float4(r2_x_13, r2_y_14, r2_z_13, r2_x_13))).xyz;
                o.sv_Target0.xyz = r0_xyz_2.xyz;
                o.sv_Target0.w = 1;
                o.sv_Target1.w = _Shininess;
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
                float4 _SpecColor : packoffset(c3);
                float4 _Color : packoffset(c4);
                float _Shininess : packoffset(c5.x);
                float _Gloss : packoffset(c5.y);
                float4 _MainTex_ST : packoffset(c6);
                float4 _BumpMap_ST : packoffset(c7);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program125Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
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
                float3 worldPos_xyz_4 = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord1.w = worldPos_xyz_4.x;
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float3 unitWorldNormal_xyz_3 = (((rsqrt(dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2)))).xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float3 worldTangent_xyz_4 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].yzxy)).xyz;
                float3 worldTangent_xyz_5 = (mad(unity_ObjectToWorld[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_4.xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_5.xyzx)).xyz;
                float3 unitWorldTangent_xyz_7 = (((rsqrt(dot(worldTangent_xyz_6.xyzx, worldTangent_xyz_6.xyzx))).xxxx * worldTangent_xyz_6.xyzx)).xyz;
                float3 r3_xyz_3 = ((((i.tangent0.w * unity_WorldTransformParams.w)).xxxx * (mad(unitWorldNormal_xyz_3.zxyz, unitWorldTangent_xyz_7.yzxy, ((unitWorldNormal_xyz_3.xyzx * unitWorldTangent_xyz_7.xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.x = unitWorldTangent_xyz_7.z;
                o.texcoord1.z = unitWorldNormal_xyz_3.y;
                o.texcoord2.x = unitWorldTangent_xyz_7.x;
                o.texcoord3.x = unitWorldTangent_xyz_7.y;
                o.texcoord2.z = unitWorldNormal_xyz_3.z;
                o.texcoord3.z = unitWorldNormal_xyz_3.x;
                o.texcoord2.w = worldPos_xyz_4.y;
                o.texcoord3.w = worldPos_xyz_4.z;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program125Output frag(program125Input i)
            {
                program125Output o = (program125Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                o.sv_Target0.xyz = ((r0_xyzw_1.xyzx * _Color.xyzx)).xyz;
                o.sv_Target0.w = 1;
                o.sv_Target1.xyz = ((((_SpecColor.xyzx * _Gloss.xxxx)).xyzx * float4(0.31830987, 0.31830987, 0.31830987, 0))).xyz;
                o.sv_Target1.w = _Shininess;
                float4 r0_xyzw_3 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r0_x_4 = (r0_xyzw_3.w * r0_xyzw_3.x);
                float4 r0_xyzw_5 = mad(float4(r0_x_4, r0_xyzw_3.y, r0_x_4, r0_x_4), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_w_3 = dot(float4(r0_x_5, r0_y_4, r0_x_5, r0_x_5), float4(r0_x_5, r0_y_4, r0_x_5, r0_x_5));
                float r0_w_4 = min(r0_w_3, 1);
                float r0_w_5 = (-r0_w_4 + 1);
                float r0_z_4 = sqrt(r0_w_5);
                float r1_x_1 = dot(i.texcoord1.xyzx, float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5));
                float r1_y_1 = dot(i.texcoord2.xyzx, float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5));
                float r1_z_1 = dot(i.texcoord3.xyzx, float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5));
                float4 r0_xyzw_8 = ((rsqrt(dot(float4(r1_x_1, r1_y_1, r1_z_1, r1_x_1), float4(r1_x_1, r1_y_1, r1_z_1, r1_x_1)))).xxxx * float4(r1_x_1, r1_y_1, r1_z_1, r1_x_1));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_5 = r0_xyzw_8.y;
                float r0_z_5 = r0_xyzw_8.z;
                o.sv_Target2.xyz = (mad(float4(r0_x_8, r0_y_5, r0_z_5, r0_x_8), float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
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
                float4 _SpecColor : packoffset(c3);
                float4 _Color : packoffset(c4);
                float _Shininess : packoffset(c5.x);
                float _Gloss : packoffset(c5.y);
                float4 _MainTex_ST : packoffset(c6);
                float4 _BumpMap_ST : packoffset(c7);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_WorldTransformParams;
                float4 cb1_values[46];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[10];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[21];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_MainTex;
            SamplerState sampler_BumpMap;
            Texture2D _MainTex;
            Texture2D _BumpMap;
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
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
            };
            struct program124Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
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
                float3 r0_xyz_4 = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.zw = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord1.w = r0_xyz_4.x;
                float3 worldTangent_xyz_2 = ((i.tangent0.yyyy * cb2_values[1].yzxy)).xyz;
                float3 worldTangent_xyz_3 = (mad(cb2_values[0].yzxy, i.tangent0.xxxx, worldTangent_xyz_2.xyzx)).xyz;
                float3 worldTangent_xyz_4 = (mad(cb2_values[2].yzxy, i.tangent0.zzzz, worldTangent_xyz_3.xyzx)).xyz;
                float3 unitWorldTangent_xyz_5 = (((rsqrt(dot(worldTangent_xyz_4.xyzx, worldTangent_xyz_4.xyzx))).xxxx * worldTangent_xyz_4.xyzx)).xyz;
                o.texcoord1.x = unitWorldTangent_xyz_5.z;
                float worldNormal_x_4 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float4 unitWorldNormal_xyzw_5 = ((rsqrt(dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4)))).xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_z_4));
                float3 r3_xyz_3 = ((((i.tangent0.w * cb2_values[9].w)).xxxx * (mad(unitWorldNormal_xyzw_5.ywxy, unitWorldTangent_xyz_5.yzxy, ((unitWorldTangent_xyz_5.xyzx * unitWorldNormal_xyzw_5.wxyw)).xyzx)).xyzx)).xyz;
                o.texcoord1.y = r3_xyz_3.x;
                o.texcoord1.z = unitWorldNormal_xyzw_5.x;
                o.texcoord2.x = unitWorldTangent_xyz_5.x;
                o.texcoord3.x = unitWorldTangent_xyz_5.y;
                o.texcoord2.w = r0_xyz_4.y;
                o.texcoord3.w = r0_xyz_4.z;
                o.texcoord2.y = r3_xyz_3.y;
                o.texcoord3.y = r3_xyz_3.z;
                o.texcoord2.z = unitWorldNormal_xyzw_5.y;
                o.texcoord3.z = unitWorldNormal_xyzw_5.w;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                float4 r1_xyzw_6 = (unitWorldNormal_xyzw_5.ywzx * unitWorldNormal_xyzw_5);
                float r2_x_6 = dot(cb1_values[42].xyzw, r1_xyzw_6);
                float r2_y_6 = dot(cb1_values[43].xyzw, r1_xyzw_6);
                float r2_z_6 = dot(cb1_values[44].xyzw, r1_xyzw_6);
                o.texcoord5.xyz = (mad(cb1_values[45].xyzx, (mad(unitWorldNormal_xyzw_5.x, unitWorldNormal_xyzw_5.x, (unitWorldNormal_xyzw_5.y * unitWorldNormal_xyzw_5.y))).xxxx, float4(r2_x_6, r2_y_6, r2_z_6, r2_x_6))).xyz;
                return o;
            }
            #pragma fragment frag
            program124Output frag(program124Input i)
            {
                program124Output o = (program124Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r0_xyz_2 = ((r0_xyzw_1.xyzx * _Color.xyzx)).xyz;
                float4 r1_xyzw_1 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord0.zwzz).xy);
                float r1_x_2 = (r1_xyzw_1.w * r1_xyzw_1.x);
                float4 r1_xyzw_3 = mad(float4(r1_x_2, r1_xyzw_1.y, r1_x_2, r1_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_2 = r1_xyzw_3.y;
                float r0_w_2 = dot(float4(r1_x_3, r1_y_2, r1_x_3, r1_x_3), float4(r1_x_3, r1_y_2, r1_x_3, r1_x_3));
                float r0_w_3 = min(r0_w_2, 1);
                float r0_w_4 = (-r0_w_3 + 1);
                float r1_z_2 = sqrt(r0_w_4);
                float r2_x_1 = dot(i.texcoord1.xyzx, float4(r1_x_3, r1_y_2, r1_z_2, r1_x_3));
                float r2_y_1 = dot(i.texcoord2.xyzx, float4(r1_x_3, r1_y_2, r1_z_2, r1_x_3));
                float r2_z_1 = dot(i.texcoord3.xyzx, float4(r1_x_3, r1_y_2, r1_z_2, r1_x_3));
                float r0_w_5 = dot(float4(r2_x_1, r2_y_1, r2_z_1, r2_x_1), float4(r2_x_1, r2_y_1, r2_z_1, r2_x_1));
                float r0_w_6 = rsqrt(r0_w_5);
                float4 r1_xyzw_4 = (r0_w_6.xxxx * float4(r2_x_1, r2_y_1, r2_z_1, r2_x_1));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_3 = r1_xyzw_4.y;
                float r1_z_3 = r1_xyzw_4.z;
                float r0_w_7 = (cb2_values[0].x == 1);
                float3 r3_xyz_5;
                if (r0_w_7)
                {
                    float r0_w_8 = (cb2_values[0].y == 1);
                    float3 r2_xyz_5 = (((mad(cb2_values[3].xyzx, i.texcoord3.wwww, (mad(cb2_values[1].xyzx, i.texcoord1.wwww, ((i.texcoord2.wwww * cb2_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb2_values[4].xyzx)).xyz;
                    float TEXCOORD1_y_2 = i.texcoord1.w;
                    float TEXCOORD2_z_2 = i.texcoord2.w;
                    float TEXCOORD3_w_1 = i.texcoord3.w;
                    float4 r2_xyzw_8 = (((((r0_w_8.xxxx ? r2_xyz_5.xyzx : float4(TEXCOORD1_y_2, TEXCOORD2_z_2, TEXCOORD3_w_1, TEXCOORD1_y_2))).xyzx + -cb2_values[6].xyzx)).xxyz * cb2_values[5].xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_8 = r2_xyzw_8.z;
                    float r2_w_1 = r2_xyzw_8.w;
                    float r0_w_9 = (r2_y_8 * 0.25);
                    float r2_y_9 = (cb2_values[0].z * 0.5);
                    float r0_w_10 = max(r0_w_9, r2_y_9);
                    float r2_x_8 = min(mad(-cb2_values[0].z, 0.5, 0.25), r0_w_10);
                    float4 r3_xyzw_3 = t2.Sample(sampler_linear_clamp, (float4(r2_x_8, r2_z_8, r2_w_1, r2_x_8)).xyz);
                    float4 r4_xyzw_2 = t2.Sample(sampler_linear_clamp, (((float4(r2_x_8, r2_z_8, r2_w_1, r2_x_8) + float4(0.25, 0, 0, 0))).xyzx).xyz);
                    float4 r2_xyzw_9 = (float4(r2_x_8, r2_z_8, r2_w_1, r2_x_8) + float4(0.5, 0, 0, 0));
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_10 = r2_xyzw_9.y;
                    float r2_z_9 = r2_xyzw_9.z;
                    float4 r2_xyzw_10 = t2.Sample(sampler_linear_clamp, (float4(r2_x_9, r2_y_10, r2_z_9, r2_x_9)).xyz);
                    float r1_w_3 = 1;
                    float r3_x_4 = dot(r3_xyzw_3, float4(r1_x_4, r1_y_3, r1_z_3, r1_w_3));
                    float r3_y_4 = dot(r4_xyzw_2, float4(r1_x_4, r1_y_3, r1_z_3, r1_w_3));
                    float r3_z_4 = dot(r2_xyzw_10, float4(r1_x_4, r1_y_3, r1_z_3, r1_w_3));
                    r3_xyz_5 = float3(r3_x_4, r3_y_4, r3_z_4);
                }
                else
                {
                    float r1_w_2 = 1;
                    float r3_x_1 = dot(cb1_values[39].xyzw, float4(r1_x_4, r1_y_3, r1_z_3, r1_w_2));
                    float r3_y_1 = dot(cb1_values[40].xyzw, float4(r1_x_4, r1_y_3, r1_z_3, r1_w_2));
                    float r3_z_1 = dot(cb1_values[41].xyzw, float4(r1_x_4, r1_y_3, r1_z_3, r1_w_2));
                    r3_xyz_5 = float3(r3_x_1, r3_y_1, r3_z_1);
                }
                float4 r2_xyzw_12 = (r3_xyz_5.xyzx + i.texcoord5.xyzx);
                float r2_x_12 = r2_xyzw_12.x;
                float r2_y_13 = r2_xyzw_12.y;
                float r2_z_12 = r2_xyzw_12.z;
                float4 r2_xyzw_13 = max(float4(r2_x_12, r2_y_13, r2_z_12, r2_x_12), float4(0, 0, 0, 0));
                float r2_x_13 = r2_xyzw_13.x;
                float r2_y_14 = r2_xyzw_13.y;
                float r2_z_13 = r2_xyzw_13.z;
                o.sv_Target1.xyz = ((((_SpecColor.xyzx * _Gloss.xxxx)).xyzx * float4(0.31830987, 0.31830987, 0.31830987, 0))).xyz;
                o.sv_Target2.xyz = (mad(float4(r1_x_4, r1_y_3, r1_z_3, r1_x_4), float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
                float4 r1_xyzw_5 = (r0_xyz_2.xyzx * float4(r2_x_13, r2_y_14, r2_z_13, r2_x_13));
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_4 = r1_xyzw_5.y;
                float r1_z_4 = r1_xyzw_5.z;
                o.sv_Target3.xyz = (exp2(-float4(r1_x_5, r1_y_4, r1_z_4, r1_x_5))).xyz;
                o.sv_Target0.xyz = r0_xyz_2.xyz;
                o.sv_Target0.w = 1;
                o.sv_Target1.w = _Shininess;
                o.sv_Target2.w = 1;
                o.sv_Target3.w = 1;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Legacy Shaders/Specular"
}
