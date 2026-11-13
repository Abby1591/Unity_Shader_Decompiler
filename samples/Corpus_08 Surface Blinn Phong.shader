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
    }
    Fallback "Legacy Shaders/Specular"
}
