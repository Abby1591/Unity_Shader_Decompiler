Shader "Corpus/09 Surface Custom Lighting"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo", 2D) = "" {}
        _RimColor ("Rim Color", Color) = (1,1,1,1)
        _RimPower ("Rim Power", Range(0.1, 8)) = 3
        _Specular ("Specular", Range(0, 1)) = 0.5
        _Gloss ("Gloss", Range(0, 1)) = 0.5
        _Wrap ("Wrap", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
        LOD 250
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
                float4 _RimColor : packoffset(c5);
                float _RimPower : packoffset(c6.x);
                float _Specular : packoffset(c6.y);
                float _Gloss : packoffset(c6.z);
                float _Wrap : packoffset(c6.w);
                float4 _MainTex_ST : packoffset(c7);
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
            Texture2D _MainTex;
            Texture3D t1;
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
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program28Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program28Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program8Output vert(program8Input i)
            {
                program8Output o = (program8Output)0;
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
                o.texcoord3.xyz = (float4(0, 0, 0, 0)).xyz;
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program28Output frag(program28Input i)
            {
                program28Output o = (program28Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_2 = ((r2_xyzw_1.xyzx * _Color.xyzx)).xyz;
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
                    float r2_w_2 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r4_x_8 = max(r1_w_3, r2_w_2);
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
                float r2_w_4 = dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx);
                float r2_w_5 = (r2_w_4 + _Wrap);
                float r3_w_1 = (_Wrap + 1);
                float r2_w_6 = saturate((r2_w_5 / r3_w_1));
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_1.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * _RimPower);
                float r0_y_8 = exp2(r0_y_7);
                float r0_z_4 = (r1_w_5 * r2_w_6);
                                float3 r4_xyz_11 = ((((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * _Specular)).xxxx * _LightColor0.xyzx)).xyz;
                float4 r0_xyzw_9 = mad(((r2_xyz_2.xyzx * _LightColor0.xyzx)).xxyz, r0_z_4.xxxx, ((r1_w_5.xxxx * ((r4_xyz_11.xyzx * _Gloss.xxxx)).xyzx)).xxyz);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + (mad(((r0_y_8.xxxx * _RimColor.xyzx)).xyzx, float4(0.1, 0.1, 0.1, 0), ((r2_xyz_2.xyzx * float4(0.02, 0.02, 0.02, 0))).xyzx)).xyzx);
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_9 = r0_xyzw_10.y;
                float r0_z_6 = r0_xyzw_10.z;
                float4 r0_xyzw_11 = mad(r2_xyz_2.xyzx, i.texcoord3.xyzx, float4(r0_x_10, r0_y_9, r0_z_6, r0_x_10));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_y_10 = r0_xyzw_11.y;
                float r0_z_7 = r0_xyzw_11.z;
                o.sv_Target0.xyz = (mad(r2_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r0_x_11, r0_y_10, r0_z_7, r0_x_11))).xyz;
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
                float4 _RimColor : packoffset(c5);
                float _RimPower : packoffset(c6.x);
                float _Specular : packoffset(c6.y);
                float _Gloss : packoffset(c6.z);
                float _Wrap : packoffset(c6.w);
                float4 _MainTex_ST : packoffset(c7);
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
            Texture2D _MainTex;
            Texture2D t1;
            Texture3D t2;
            struct program19Input
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
            struct program19Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program35Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
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
            program19Output vert(program19Input i)
            {
                program19Output o = (program19Output)0;
                float4 worldPos_xyzw_2 = mad(cb3_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb3_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb3_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb3_values[3].xyzw);
                o.texcoord2.xyz = (mad(cb3_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb4_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb4_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb4_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb4_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = mul(float4x4(cb4_values[17], cb4_values[18], cb4_values[19], cb4_values[20]), worldPos_xyzw_1);
                o.texcoord4.x = clipPos_xyzw_7.z;
                o.texcoord5.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb3_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb3_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb3_values[6].xyzx);
                float r0_z_8 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r0_z_9 = rsqrt(r0_z_8);
                float3 unitWorldNormal_xyz_3 = ((r0_z_9.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = unitWorldNormal_xyz_3.xyz;
                float r0_z_10 = (unitWorldNormal_xyz_3.y * unitWorldNormal_xyz_3.y);
                float r0_z_11 = mad(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.x, -r0_z_10);
                float4 r2_xyzw_1 = (unitWorldNormal_xyz_3.yzzx * unitWorldNormal_xyz_3.xyzz);
                float r3_x_1 = dot(cb2_values[42].xyzw, r2_xyzw_1);
                float r3_y_1 = dot(cb2_values[43].xyzw, r2_xyzw_1);
                float r3_z_1 = dot(cb2_values[44].xyzw, r2_xyzw_1);
                float r1_w_2 = 1;
                float r3_x_2 = dot(cb2_values[39].xyzw, float4(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.y, unitWorldNormal_xyz_3.z, r1_w_2));
                float r3_y_2 = dot(cb2_values[40].xyzw, float4(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.y, unitWorldNormal_xyz_3.z, r1_w_2));
                float r3_z_2 = dot(cb2_values[41].xyzw, float4(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.y, unitWorldNormal_xyz_3.z, r1_w_2));
                o.texcoord3.xyz = (((mad(cb2_values[45].xyzx, r0_z_11.xxxx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1))).xyzx + float4(r3_x_2, r3_y_2, r3_z_2, r3_x_2))).xyz;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r0_xyzw_8 = (clipPos_xyzw_7.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_z_12 = r0_xyzw_8.z;
                float r0_w_8 = (r0_y_8 * 0.5);
                o.texcoord5.xy = ((r0_z_12.xxxx + float4(r0_x_8, r0_w_8, r0_x_8, r0_x_8))).xy;
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
                float r4_x_1 = cb4_values[9].z;
                float r4_y_1 = cb4_values[10].z;
                float r4_z_1 = cb4_values[11].z;
                float r1_w_1 = dot(viewDir_xyz_1.xyzx, float4(r4_x_1, r4_y_1, r4_z_1, r4_x_1));
                float3 r4_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = dot(r4_xyz_2.xyzx, r4_xyz_2.xyzx);
                float r2_w_3 = sqrt(r2_w_2);
                float r2_w_4 = (-r1_w_1 + r2_w_3);
                float r1_w_2 = mad(cb3_values[25].w, r2_w_4, r1_w_1);
                float r1_w_3 = saturate(mad(r1_w_2, cb3_values[24].z, cb3_values[24].w));
                float r2_w_5 = (cb6_values[0].x == 1);
                float r4_x_12;
                float r4_y_12;
                float r4_z_12;
                float r4_w_4;
                if (r2_w_5)
                {
                    float r2_w_6 = (cb6_values[0].y == 1);
                    float3 r4_xyz_7 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r4_xyzw_10 = (((((r2_w_6.xxxx ? r4_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r4_y_10 = r4_xyzw_10.y;
                    float r4_z_10 = r4_xyzw_10.z;
                    float r4_w_2 = r4_xyzw_10.w;
                    float r2_w_7 = mad(r4_y_10, 0.25, 0.75);
                    float r3_w_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r4_x_10 = max(r2_w_7, r3_w_1);
                    float4 r4_xyzw_11 = t2.Sample(sampler_linear_clamp, (float4(r4_x_10, r4_z_10, r4_w_2, r4_x_10)).xyz);
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
                float4 r4_xyzw_14 = t1.Sample(sampler_linear_clamp1, (((i.texcoord5.xyxx / i.texcoord5.wwww)).xyxx).xy);
                float r2_w_10 = (r2_w_9 + -r4_xyzw_14.x);
                float r1_w_4 = mad(r1_w_3, r2_w_10, r4_xyzw_14.x);
                float r2_w_11 = dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx);
                float r2_w_12 = (r2_w_11 + _Wrap);
                float r3_w_3 = (_Wrap + 1);
                float r2_w_13 = saturate((r2_w_12 / r3_w_3));
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_1.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * _RimPower);
                float r0_y_8 = exp2(r0_y_7);
                float r0_z_4 = (r1_w_4 * r2_w_13);
                                float4 r4_xyzw_15 = (((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * _Specular)).xxxx * _LightColor0.xyzx);
                float r4_x_15 = r4_xyzw_15.x;
                float r4_y_15 = r4_xyzw_15.y;
                float r4_z_14 = r4_xyzw_15.z;
                float4 r4_xyzw_16 = (float4(r4_x_15, r4_y_15, r4_z_14, r4_x_15) * _Gloss.xxxx);
                float r4_x_16 = r4_xyzw_16.x;
                float r4_y_16 = r4_xyzw_16.y;
                float r4_z_15 = r4_xyzw_16.z;
                float4 r4_xyzw_17 = (r1_w_4.xxxx * float4(r4_x_16, r4_y_16, r4_z_15, r4_x_16));
                float r4_x_17 = r4_xyzw_17.x;
                float r4_y_17 = r4_xyzw_17.y;
                float r4_z_16 = r4_xyzw_17.z;
                float4 r0_xyzw_9 = mad(((r2_xyz_2.xyzx * _LightColor0.xyzx)).xxyz, r0_z_4.xxxx, float4(r4_x_17, r4_x_17, r4_y_17, r4_z_16));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + (mad(((r0_y_8.xxxx * _RimColor.xyzx)).xyzx, float4(0.1, 0.1, 0.1, 0), ((r2_xyz_2.xyzx * float4(0.02, 0.02, 0.02, 0))).xyzx)).xyzx);
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_9 = r0_xyzw_10.y;
                float r0_z_6 = r0_xyzw_10.z;
                float4 r0_xyzw_11 = mad(r2_xyz_2.xyzx, i.texcoord3.xyzx, float4(r0_x_10, r0_y_9, r0_z_6, r0_x_10));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_y_10 = r0_xyzw_11.y;
                float r0_z_7 = r0_xyzw_11.z;
                float4 r0_xyzw_12 = mad(r2_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r0_x_11, r0_y_10, r0_z_7, r0_x_11));
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_11 = r0_xyzw_12.y;
                float r0_z_8 = r0_xyzw_12.z;
                float r0_w_6 = (i.texcoord4.x / cb1_values[5].y);
                float r0_w_7 = (-r0_w_6 + 1);
                float r0_w_8 = (r0_w_7 * cb1_values[5].z);
                float r0_w_9 = max(r0_w_8, 0);
                float r0_w_10 = saturate(mad(r0_w_9, cb5_values[1].z, cb5_values[1].w));
                float4 r0_xyzw_13 = (float4(r0_x_12, r0_y_11, r0_z_8, r0_x_12) + -cb5_values[0].xyzx);
                float r0_x_13 = r0_xyzw_13.x;
                float r0_y_12 = r0_xyzw_13.y;
                float r0_z_9 = r0_xyzw_13.z;
                o.sv_Target0.xyz = (mad(r0_w_10.xxxx, float4(r0_x_13, r0_y_12, r0_z_9, r0_x_13), cb5_values[0].xyzx)).xyz;
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
                float4 _RimColor : packoffset(c5);
                float _RimPower : packoffset(c6.x);
                float _Specular : packoffset(c6.y);
                float _Gloss : packoffset(c6.z);
                float _Wrap : packoffset(c6.w);
                float4 _MainTex_ST : packoffset(c7);
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
            Texture2D _MainTex;
            Texture2D t1;
            Texture3D t2;
            struct program18Input
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
            struct program18Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program34Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program34Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program18Output vert(program18Input i)
            {
                program18Output o = (program18Output)0;
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
                o.texcoord5.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_z_8 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r0_z_9 = rsqrt(r0_z_8);
                o.texcoord1.xyz = ((r0_z_9.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord3.xyz = (float4(0, 0, 0, 0)).xyz;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r0_xyzw_8 = (clipPos_xyzw_7.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_z_10 = r0_xyzw_8.z;
                float r0_w_8 = (r0_y_8 * 0.5);
                o.texcoord5.xy = ((r0_z_10.xxxx + float4(r0_x_8, r0_w_8, r0_x_8, r0_x_8))).xy;
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
                float r4_x_1 = cb4_values[9].z;
                float r4_y_1 = cb4_values[10].z;
                float r4_z_1 = cb4_values[11].z;
                float r1_w_1 = dot(viewDir_xyz_1.xyzx, float4(r4_x_1, r4_y_1, r4_z_1, r4_x_1));
                float3 r4_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = dot(r4_xyz_2.xyzx, r4_xyz_2.xyzx);
                float r2_w_3 = sqrt(r2_w_2);
                float r2_w_4 = (-r1_w_1 + r2_w_3);
                float r1_w_2 = mad(cb3_values[25].w, r2_w_4, r1_w_1);
                float r1_w_3 = saturate(mad(r1_w_2, cb3_values[24].z, cb3_values[24].w));
                float r2_w_5 = (cb6_values[0].x == 1);
                float r4_x_12;
                float r4_y_12;
                float r4_z_12;
                float r4_w_4;
                if (r2_w_5)
                {
                    float r2_w_6 = (cb6_values[0].y == 1);
                    float3 r4_xyz_7 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r4_xyzw_10 = (((((r2_w_6.xxxx ? r4_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r4_y_10 = r4_xyzw_10.y;
                    float r4_z_10 = r4_xyzw_10.z;
                    float r4_w_2 = r4_xyzw_10.w;
                    float r2_w_7 = mad(r4_y_10, 0.25, 0.75);
                    float r3_w_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r4_x_10 = max(r2_w_7, r3_w_1);
                    float4 r4_xyzw_11 = t2.Sample(sampler_linear_clamp, (float4(r4_x_10, r4_z_10, r4_w_2, r4_x_10)).xyz);
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
                float4 r4_xyzw_14 = t1.Sample(sampler_linear_clamp1, (((i.texcoord5.xyxx / i.texcoord5.wwww)).xyxx).xy);
                float r2_w_10 = (r2_w_9 + -r4_xyzw_14.x);
                float r1_w_4 = mad(r1_w_3, r2_w_10, r4_xyzw_14.x);
                float r2_w_11 = dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx);
                float r2_w_12 = (r2_w_11 + _Wrap);
                float r3_w_3 = (_Wrap + 1);
                float r2_w_13 = saturate((r2_w_12 / r3_w_3));
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_1.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * _RimPower);
                float r0_y_8 = exp2(r0_y_7);
                float r0_z_4 = (r1_w_4 * r2_w_13);
                                float4 r4_xyzw_15 = (((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * _Specular)).xxxx * _LightColor0.xyzx);
                float r4_x_15 = r4_xyzw_15.x;
                float r4_y_15 = r4_xyzw_15.y;
                float r4_z_14 = r4_xyzw_15.z;
                float4 r4_xyzw_16 = (float4(r4_x_15, r4_y_15, r4_z_14, r4_x_15) * _Gloss.xxxx);
                float r4_x_16 = r4_xyzw_16.x;
                float r4_y_16 = r4_xyzw_16.y;
                float r4_z_15 = r4_xyzw_16.z;
                float4 r4_xyzw_17 = (r1_w_4.xxxx * float4(r4_x_16, r4_y_16, r4_z_15, r4_x_16));
                float r4_x_17 = r4_xyzw_17.x;
                float r4_y_17 = r4_xyzw_17.y;
                float r4_z_16 = r4_xyzw_17.z;
                float4 r0_xyzw_9 = mad(((r2_xyz_2.xyzx * _LightColor0.xyzx)).xxyz, r0_z_4.xxxx, float4(r4_x_17, r4_x_17, r4_y_17, r4_z_16));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + (mad(((r0_y_8.xxxx * _RimColor.xyzx)).xyzx, float4(0.1, 0.1, 0.1, 0), ((r2_xyz_2.xyzx * float4(0.02, 0.02, 0.02, 0))).xyzx)).xyzx);
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_9 = r0_xyzw_10.y;
                float r0_z_6 = r0_xyzw_10.z;
                float4 r0_xyzw_11 = mad(r2_xyz_2.xyzx, i.texcoord3.xyzx, float4(r0_x_10, r0_y_9, r0_z_6, r0_x_10));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_y_10 = r0_xyzw_11.y;
                float r0_z_7 = r0_xyzw_11.z;
                float4 r0_xyzw_12 = mad(r2_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r0_x_11, r0_y_10, r0_z_7, r0_x_11));
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_11 = r0_xyzw_12.y;
                float r0_z_8 = r0_xyzw_12.z;
                float r0_w_6 = (i.texcoord4.x / cb1_values[5].y);
                float r0_w_7 = (-r0_w_6 + 1);
                float r0_w_8 = (r0_w_7 * cb1_values[5].z);
                float r0_w_9 = max(r0_w_8, 0);
                float r0_w_10 = saturate(mad(r0_w_9, cb5_values[1].z, cb5_values[1].w));
                float4 r0_xyzw_13 = (float4(r0_x_12, r0_y_11, r0_z_8, r0_x_12) + -cb5_values[0].xyzx);
                float r0_x_13 = r0_xyzw_13.x;
                float r0_y_12 = r0_xyzw_13.y;
                float r0_z_9 = r0_xyzw_13.z;
                o.sv_Target0.xyz = (mad(r0_w_10.xxxx, float4(r0_x_13, r0_y_12, r0_z_9, r0_x_13), cb5_values[0].xyzx)).xyz;
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
                float4 _RimColor : packoffset(c5);
                float _RimPower : packoffset(c6.x);
                float _Specular : packoffset(c6.y);
                float _Gloss : packoffset(c6.z);
                float _Wrap : packoffset(c6.w);
                float4 _MainTex_ST : packoffset(c7);
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
                float4 cb2_values[7];
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
            Texture2D _MainTex;
            Texture3D t1;
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
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program33Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
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
            program17Output vert(program17Input i)
            {
                program17Output o = (program17Output)0;
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
                float worldNormal_x_8 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                float3 unitWorldNormal_xyz_9 = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                o.texcoord1.xyz = unitWorldNormal_xyz_9.xyz;
                float4 r2_xyzw_1 = (unitWorldNormal_xyz_9.yzzx * unitWorldNormal_xyz_9.xyzz);
                float r3_x_1 = dot(cb1_values[42].xyzw, r2_xyzw_1);
                float r3_y_1 = dot(cb1_values[43].xyzw, r2_xyzw_1);
                float r3_z_1 = dot(cb1_values[44].xyzw, r2_xyzw_1);
                float4 r1_xyzw_4 = mad(cb1_values[45].xyzx, (mad(unitWorldNormal_xyz_9.x, unitWorldNormal_xyz_9.x, (unitWorldNormal_xyz_9.y * unitWorldNormal_xyz_9.y))).xxxx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_2 = r1_xyzw_4.y;
                float r1_z_2 = r1_xyzw_4.z;
                float r0_w_10 = 1;
                float r2_x_2 = dot(cb1_values[39].xyzw, float4(unitWorldNormal_xyz_9.x, unitWorldNormal_xyz_9.y, unitWorldNormal_xyz_9.z, r0_w_10));
                float r2_y_2 = dot(cb1_values[40].xyzw, float4(unitWorldNormal_xyz_9.x, unitWorldNormal_xyz_9.y, unitWorldNormal_xyz_9.z, r0_w_10));
                float r2_z_2 = dot(cb1_values[41].xyzw, float4(unitWorldNormal_xyz_9.x, unitWorldNormal_xyz_9.y, unitWorldNormal_xyz_9.z, r0_w_10));
                o.texcoord3.xyz = ((float4(r1_x_4, r1_y_2, r1_z_2, r1_x_4) + float4(r2_x_2, r2_y_2, r2_z_2, r2_x_2))).xyz;
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
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
                float r1_w_1 = (cb4_values[0].x == 1);
                float r4_x_10;
                float r4_y_10;
                float r4_z_10;
                float r4_w_4;
                if (r1_w_1)
                {
                    float r1_w_2 = (cb4_values[0].y == 1);
                    float3 r4_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord2.zzzz, (mad(cb4_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r4_xyzw_8 = (((((r1_w_2.xxxx ? r4_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r4_y_8 = r4_xyzw_8.y;
                    float r4_z_8 = r4_xyzw_8.z;
                    float r4_w_2 = r4_xyzw_8.w;
                    float r1_w_3 = mad(r4_y_8, 0.25, 0.75);
                    float r2_w_2 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r4_x_8 = max(r1_w_3, r2_w_2);
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
                float r2_w_4 = dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx);
                float r2_w_5 = (r2_w_4 + _Wrap);
                float r3_w_1 = (_Wrap + 1);
                float r2_w_6 = saturate((r2_w_5 / r3_w_1));
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_1.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * _RimPower);
                float r0_y_8 = exp2(r0_y_7);
                float r0_z_4 = (r1_w_5 * r2_w_6);
                                float3 r4_xyz_11 = ((((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * _Specular)).xxxx * _LightColor0.xyzx)).xyz;
                float4 r0_xyzw_9 = mad(((r2_xyz_2.xyzx * _LightColor0.xyzx)).xxyz, r0_z_4.xxxx, ((r1_w_5.xxxx * ((r4_xyz_11.xyzx * _Gloss.xxxx)).xyzx)).xxyz);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + (mad(((r0_y_8.xxxx * _RimColor.xyzx)).xyzx, float4(0.1, 0.1, 0.1, 0), ((r2_xyz_2.xyzx * float4(0.02, 0.02, 0.02, 0))).xyzx)).xyzx);
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_9 = r0_xyzw_10.y;
                float r0_z_6 = r0_xyzw_10.z;
                float4 r0_xyzw_11 = mad(r2_xyz_2.xyzx, i.texcoord3.xyzx, float4(r0_x_10, r0_y_9, r0_z_6, r0_x_10));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_y_10 = r0_xyzw_11.y;
                float r0_z_7 = r0_xyzw_11.z;
                float4 r0_xyzw_12 = mad(r2_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r0_x_11, r0_y_10, r0_z_7, r0_x_11));
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_11 = r0_xyzw_12.y;
                float r0_z_8 = r0_xyzw_12.z;
                float r0_w_6 = (i.texcoord4.x / cb1_values[5].y);
                float r0_w_7 = (-r0_w_6 + 1);
                float r0_w_8 = (r0_w_7 * cb1_values[5].z);
                float r0_w_9 = max(r0_w_8, 0);
                float r0_w_10 = saturate(mad(r0_w_9, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w));
                float4 r0_xyzw_13 = (float4(r0_x_12, r0_y_11, r0_z_8, r0_x_12) + -unity_ProbeVolumeParams.xyzx);
                float r0_x_13 = r0_xyzw_13.x;
                float r0_y_12 = r0_xyzw_13.y;
                float r0_z_9 = r0_xyzw_13.z;
                o.sv_Target0.xyz = (mad(r0_w_10.xxxx, float4(r0_x_13, r0_y_12, r0_z_9, r0_x_13), unity_ProbeVolumeParams.xyzx)).xyz;
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
                float4 _RimColor : packoffset(c5);
                float _RimPower : packoffset(c6.x);
                float _Specular : packoffset(c6.y);
                float _Gloss : packoffset(c6.z);
                float _Wrap : packoffset(c6.w);
                float4 _MainTex_ST : packoffset(c7);
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
            Texture2D _MainTex;
            Texture3D t1;
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
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program32Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program32Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program16Output vert(program16Input i)
            {
                program16Output o = (program16Output)0;
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
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                o.texcoord3.xyz = (float4(0, 0, 0, 0)).xyz;
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
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
                float r1_w_1 = (cb4_values[0].x == 1);
                float r4_x_10;
                float r4_y_10;
                float r4_z_10;
                float r4_w_4;
                if (r1_w_1)
                {
                    float r1_w_2 = (cb4_values[0].y == 1);
                    float3 r4_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord2.zzzz, (mad(cb4_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r4_xyzw_8 = (((((r1_w_2.xxxx ? r4_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r4_y_8 = r4_xyzw_8.y;
                    float r4_z_8 = r4_xyzw_8.z;
                    float r4_w_2 = r4_xyzw_8.w;
                    float r1_w_3 = mad(r4_y_8, 0.25, 0.75);
                    float r2_w_2 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r4_x_8 = max(r1_w_3, r2_w_2);
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
                float r2_w_4 = dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx);
                float r2_w_5 = (r2_w_4 + _Wrap);
                float r3_w_1 = (_Wrap + 1);
                float r2_w_6 = saturate((r2_w_5 / r3_w_1));
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_1.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * _RimPower);
                float r0_y_8 = exp2(r0_y_7);
                float r0_z_4 = (r1_w_5 * r2_w_6);
                                float3 r4_xyz_11 = ((((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * _Specular)).xxxx * _LightColor0.xyzx)).xyz;
                float4 r0_xyzw_9 = mad(((r2_xyz_2.xyzx * _LightColor0.xyzx)).xxyz, r0_z_4.xxxx, ((r1_w_5.xxxx * ((r4_xyz_11.xyzx * _Gloss.xxxx)).xyzx)).xxyz);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + (mad(((r0_y_8.xxxx * _RimColor.xyzx)).xyzx, float4(0.1, 0.1, 0.1, 0), ((r2_xyz_2.xyzx * float4(0.02, 0.02, 0.02, 0))).xyzx)).xyzx);
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_9 = r0_xyzw_10.y;
                float r0_z_6 = r0_xyzw_10.z;
                float4 r0_xyzw_11 = mad(r2_xyz_2.xyzx, i.texcoord3.xyzx, float4(r0_x_10, r0_y_9, r0_z_6, r0_x_10));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_y_10 = r0_xyzw_11.y;
                float r0_z_7 = r0_xyzw_11.z;
                float4 r0_xyzw_12 = mad(r2_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r0_x_11, r0_y_10, r0_z_7, r0_x_11));
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_11 = r0_xyzw_12.y;
                float r0_z_8 = r0_xyzw_12.z;
                float r0_w_6 = (i.texcoord4.x / cb1_values[5].y);
                float r0_w_7 = (-r0_w_6 + 1);
                float r0_w_8 = (r0_w_7 * cb1_values[5].z);
                float r0_w_9 = max(r0_w_8, 0);
                float r0_w_10 = saturate(mad(r0_w_9, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w));
                float4 r0_xyzw_13 = (float4(r0_x_12, r0_y_11, r0_z_8, r0_x_12) + -unity_ProbeVolumeParams.xyzx);
                float r0_x_13 = r0_xyzw_13.x;
                float r0_y_12 = r0_xyzw_13.y;
                float r0_z_9 = r0_xyzw_13.z;
                o.sv_Target0.xyz = (mad(r0_w_10.xxxx, float4(r0_x_13, r0_y_12, r0_z_9, r0_x_13), unity_ProbeVolumeParams.xyzx)).xyz;
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
                float4 _RimColor : packoffset(c5);
                float _RimPower : packoffset(c6.x);
                float _Specular : packoffset(c6.y);
                float _Gloss : packoffset(c6.z);
                float _Wrap : packoffset(c6.w);
                float4 _MainTex_ST : packoffset(c7);
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
            Texture2D _MainTex;
            Texture2D t1;
            Texture3D t2;
            struct program11Input
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
            struct program11Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program31Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
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
            program11Output vert(program11Input i)
            {
                program11Output o = (program11Output)0;
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
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb3_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb3_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb3_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                float3 unitWorldNormal_xyz_3 = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = unitWorldNormal_xyz_3.xyz;
                float4 r3_xyzw_1 = (unitWorldNormal_xyz_3.yzzx * unitWorldNormal_xyz_3.xyzz);
                float r4_x_1 = dot(cb2_values[42].xyzw, r3_xyzw_1);
                float r4_y_1 = dot(cb2_values[43].xyzw, r3_xyzw_1);
                float r4_z_1 = dot(cb2_values[44].xyzw, r3_xyzw_1);
                float4 r2_xyzw_3 = mad(cb2_values[45].xyzx, (mad(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.x, (unitWorldNormal_xyz_3.y * unitWorldNormal_xyz_3.y))).xxxx, float4(r4_x_1, r4_y_1, r4_z_1, r4_x_1));
                float r2_x_3 = r2_xyzw_3.x;
                float r2_y_1 = r2_xyzw_3.y;
                float r2_z_1 = r2_xyzw_3.z;
                float r1_w_4 = 1;
                float r3_x_2 = dot(cb2_values[39].xyzw, float4(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.y, unitWorldNormal_xyz_3.z, r1_w_4));
                float r3_y_2 = dot(cb2_values[40].xyzw, float4(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.y, unitWorldNormal_xyz_3.z, r1_w_4));
                float r3_z_2 = dot(cb2_values[41].xyzw, float4(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.y, unitWorldNormal_xyz_3.z, r1_w_4));
                o.texcoord3.xyz = ((float4(r2_x_3, r2_y_1, r2_z_1, r2_x_3) + float4(r3_x_2, r3_y_2, r3_z_2, r3_x_2))).xyz;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r1_xyzw_4 = (float4(clipPos_xyzw_7.x, clipPos_xyzw_7.x, clipPos_xyzw_7.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_z_4 = r1_xyzw_4.z;
                float r1_w_5 = r1_xyzw_4.w;
                o.texcoord5.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord5.xy = ((r1_z_4.xxxx + float4(r1_x_4, r1_w_5, r1_x_4, r1_x_4))).xy;
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
                float r4_x_1 = cb4_values[9].z;
                float r4_y_1 = cb4_values[10].z;
                float r4_z_1 = cb4_values[11].z;
                float r1_w_1 = dot(viewDir_xyz_1.xyzx, float4(r4_x_1, r4_y_1, r4_z_1, r4_x_1));
                float3 r4_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = dot(r4_xyz_2.xyzx, r4_xyz_2.xyzx);
                float r2_w_3 = sqrt(r2_w_2);
                float r2_w_4 = (-r1_w_1 + r2_w_3);
                float r1_w_2 = mad(cb3_values[25].w, r2_w_4, r1_w_1);
                float r1_w_3 = saturate(mad(r1_w_2, cb3_values[24].z, cb3_values[24].w));
                float r2_w_5 = (cb5_values[0].x == 1);
                float r4_x_12;
                float r4_y_12;
                float r4_z_12;
                float r4_w_4;
                if (r2_w_5)
                {
                    float r2_w_6 = (cb5_values[0].y == 1);
                    float3 r4_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r4_xyzw_10 = (((((r2_w_6.xxxx ? r4_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r4_y_10 = r4_xyzw_10.y;
                    float r4_z_10 = r4_xyzw_10.z;
                    float r4_w_2 = r4_xyzw_10.w;
                    float r2_w_7 = mad(r4_y_10, 0.25, 0.75);
                    float r3_w_1 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r4_x_10 = max(r2_w_7, r3_w_1);
                    float4 r4_xyzw_11 = t2.Sample(sampler_linear_clamp, (float4(r4_x_10, r4_z_10, r4_w_2, r4_x_10)).xyz);
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
                float4 r4_xyzw_14 = t1.Sample(sampler_linear_clamp1, (((i.texcoord5.xyxx / i.texcoord5.wwww)).xyxx).xy);
                float r2_w_10 = (r2_w_9 + -r4_xyzw_14.x);
                float r1_w_4 = mad(r1_w_3, r2_w_10, r4_xyzw_14.x);
                float r2_w_11 = dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx);
                float r2_w_12 = (r2_w_11 + _Wrap);
                float r3_w_3 = (_Wrap + 1);
                float r2_w_13 = saturate((r2_w_12 / r3_w_3));
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_1.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * _RimPower);
                float r0_y_8 = exp2(r0_y_7);
                float r0_z_4 = (r1_w_4 * r2_w_13);
                                float4 r4_xyzw_15 = (((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * _Specular)).xxxx * _LightColor0.xyzx);
                float r4_x_15 = r4_xyzw_15.x;
                float r4_y_15 = r4_xyzw_15.y;
                float r4_z_14 = r4_xyzw_15.z;
                float4 r4_xyzw_16 = (float4(r4_x_15, r4_y_15, r4_z_14, r4_x_15) * _Gloss.xxxx);
                float r4_x_16 = r4_xyzw_16.x;
                float r4_y_16 = r4_xyzw_16.y;
                float r4_z_15 = r4_xyzw_16.z;
                float4 r4_xyzw_17 = (r1_w_4.xxxx * float4(r4_x_16, r4_y_16, r4_z_15, r4_x_16));
                float r4_x_17 = r4_xyzw_17.x;
                float r4_y_17 = r4_xyzw_17.y;
                float r4_z_16 = r4_xyzw_17.z;
                float4 r0_xyzw_9 = mad(((r2_xyz_2.xyzx * _LightColor0.xyzx)).xxyz, r0_z_4.xxxx, float4(r4_x_17, r4_x_17, r4_y_17, r4_z_16));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + (mad(((r0_y_8.xxxx * _RimColor.xyzx)).xyzx, float4(0.1, 0.1, 0.1, 0), ((r2_xyz_2.xyzx * float4(0.02, 0.02, 0.02, 0))).xyzx)).xyzx);
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_9 = r0_xyzw_10.y;
                float r0_z_6 = r0_xyzw_10.z;
                float4 r0_xyzw_11 = mad(r2_xyz_2.xyzx, i.texcoord3.xyzx, float4(r0_x_10, r0_y_9, r0_z_6, r0_x_10));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_y_10 = r0_xyzw_11.y;
                float r0_z_7 = r0_xyzw_11.z;
                o.sv_Target0.xyz = (mad(r2_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r0_x_11, r0_y_10, r0_z_7, r0_x_11))).xyz;
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
                float4 _RimColor : packoffset(c5);
                float _RimPower : packoffset(c6.x);
                float _Specular : packoffset(c6.y);
                float _Gloss : packoffset(c6.z);
                float _Wrap : packoffset(c6.w);
                float4 _MainTex_ST : packoffset(c7);
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
            Texture2D _MainTex;
            Texture2D t1;
            Texture3D t2;
            struct program10Input
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
            struct program10Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program30Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program30Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program10Output vert(program10Input i)
            {
                program10Output o = (program10Output)0;
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
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord3.xyz = (float4(0, 0, 0, 0)).xyz;
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
            program30Output frag(program30Input i)
            {
                program30Output o = (program30Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_2 = ((r2_xyzw_1.xyzx * _Color.xyzx)).xyz;
                float r4_x_1 = cb4_values[9].z;
                float r4_y_1 = cb4_values[10].z;
                float r4_z_1 = cb4_values[11].z;
                float r1_w_1 = dot(viewDir_xyz_1.xyzx, float4(r4_x_1, r4_y_1, r4_z_1, r4_x_1));
                float3 r4_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = dot(r4_xyz_2.xyzx, r4_xyz_2.xyzx);
                float r2_w_3 = sqrt(r2_w_2);
                float r2_w_4 = (-r1_w_1 + r2_w_3);
                float r1_w_2 = mad(cb3_values[25].w, r2_w_4, r1_w_1);
                float r1_w_3 = saturate(mad(r1_w_2, cb3_values[24].z, cb3_values[24].w));
                float r2_w_5 = (cb5_values[0].x == 1);
                float r4_x_12;
                float r4_y_12;
                float r4_z_12;
                float r4_w_4;
                if (r2_w_5)
                {
                    float r2_w_6 = (cb5_values[0].y == 1);
                    float3 r4_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r4_xyzw_10 = (((((r2_w_6.xxxx ? r4_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r4_y_10 = r4_xyzw_10.y;
                    float r4_z_10 = r4_xyzw_10.z;
                    float r4_w_2 = r4_xyzw_10.w;
                    float r2_w_7 = mad(r4_y_10, 0.25, 0.75);
                    float r3_w_1 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r4_x_10 = max(r2_w_7, r3_w_1);
                    float4 r4_xyzw_11 = t2.Sample(sampler_linear_clamp, (float4(r4_x_10, r4_z_10, r4_w_2, r4_x_10)).xyz);
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
                float4 r4_xyzw_14 = t1.Sample(sampler_linear_clamp1, (((i.texcoord5.xyxx / i.texcoord5.wwww)).xyxx).xy);
                float r2_w_10 = (r2_w_9 + -r4_xyzw_14.x);
                float r1_w_4 = mad(r1_w_3, r2_w_10, r4_xyzw_14.x);
                float r2_w_11 = dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx);
                float r2_w_12 = (r2_w_11 + _Wrap);
                float r3_w_3 = (_Wrap + 1);
                float r2_w_13 = saturate((r2_w_12 / r3_w_3));
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_1.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * _RimPower);
                float r0_y_8 = exp2(r0_y_7);
                float r0_z_4 = (r1_w_4 * r2_w_13);
                                float4 r4_xyzw_15 = (((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * _Specular)).xxxx * _LightColor0.xyzx);
                float r4_x_15 = r4_xyzw_15.x;
                float r4_y_15 = r4_xyzw_15.y;
                float r4_z_14 = r4_xyzw_15.z;
                float4 r4_xyzw_16 = (float4(r4_x_15, r4_y_15, r4_z_14, r4_x_15) * _Gloss.xxxx);
                float r4_x_16 = r4_xyzw_16.x;
                float r4_y_16 = r4_xyzw_16.y;
                float r4_z_15 = r4_xyzw_16.z;
                float4 r4_xyzw_17 = (r1_w_4.xxxx * float4(r4_x_16, r4_y_16, r4_z_15, r4_x_16));
                float r4_x_17 = r4_xyzw_17.x;
                float r4_y_17 = r4_xyzw_17.y;
                float r4_z_16 = r4_xyzw_17.z;
                float4 r0_xyzw_9 = mad(((r2_xyz_2.xyzx * _LightColor0.xyzx)).xxyz, r0_z_4.xxxx, float4(r4_x_17, r4_x_17, r4_y_17, r4_z_16));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + (mad(((r0_y_8.xxxx * _RimColor.xyzx)).xyzx, float4(0.1, 0.1, 0.1, 0), ((r2_xyz_2.xyzx * float4(0.02, 0.02, 0.02, 0))).xyzx)).xyzx);
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_9 = r0_xyzw_10.y;
                float r0_z_6 = r0_xyzw_10.z;
                float4 r0_xyzw_11 = mad(r2_xyz_2.xyzx, i.texcoord3.xyzx, float4(r0_x_10, r0_y_9, r0_z_6, r0_x_10));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_y_10 = r0_xyzw_11.y;
                float r0_z_7 = r0_xyzw_11.z;
                o.sv_Target0.xyz = (mad(r2_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r0_x_11, r0_y_10, r0_z_7, r0_x_11))).xyz;
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
                float4 _RimColor : packoffset(c5);
                float _RimPower : packoffset(c6.x);
                float _Specular : packoffset(c6.y);
                float _Gloss : packoffset(c6.z);
                float _Wrap : packoffset(c6.w);
                float4 _MainTex_ST : packoffset(c7);
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
                float4 cb2_values[7];
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
            Texture2D _MainTex;
            Texture3D t1;
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
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program29Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program29Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program9Output vert(program9Input i)
            {
                program9Output o = (program9Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                float3 unitWorldNormal_xyz_8 = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.texcoord1.xyz = unitWorldNormal_xyz_8.xyz;
                float4 r2_xyzw_1 = (unitWorldNormal_xyz_8.yzzx * unitWorldNormal_xyz_8.xyzz);
                float r3_x_1 = dot(cb1_values[42].xyzw, r2_xyzw_1);
                float r3_y_1 = dot(cb1_values[43].xyzw, r2_xyzw_1);
                float r3_z_1 = dot(cb1_values[44].xyzw, r2_xyzw_1);
                float4 r1_xyzw_4 = mad(cb1_values[45].xyzx, (mad(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.x, (unitWorldNormal_xyz_8.y * unitWorldNormal_xyz_8.y))).xxxx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_2 = r1_xyzw_4.y;
                float r1_z_2 = r1_xyzw_4.z;
                float r0_w_9 = 1;
                float r2_x_2 = dot(cb1_values[39].xyzw, float4(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.y, unitWorldNormal_xyz_8.z, r0_w_9));
                float r2_y_2 = dot(cb1_values[40].xyzw, float4(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.y, unitWorldNormal_xyz_8.z, r0_w_9));
                float r2_z_2 = dot(cb1_values[41].xyzw, float4(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.y, unitWorldNormal_xyz_8.z, r0_w_9));
                o.texcoord3.xyz = ((float4(r1_x_4, r1_y_2, r1_z_2, r1_x_4) + float4(r2_x_2, r2_y_2, r2_z_2, r2_x_2))).xyz;
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program29Output frag(program29Input i)
            {
                program29Output o = (program29Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_2 = ((r2_xyzw_1.xyzx * _Color.xyzx)).xyz;
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
                    float r2_w_2 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r4_x_8 = max(r1_w_3, r2_w_2);
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
                float r2_w_4 = dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx);
                float r2_w_5 = (r2_w_4 + _Wrap);
                float r3_w_1 = (_Wrap + 1);
                float r2_w_6 = saturate((r2_w_5 / r3_w_1));
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_1.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * _RimPower);
                float r0_y_8 = exp2(r0_y_7);
                float r0_z_4 = (r1_w_5 * r2_w_6);
                                float3 r4_xyz_11 = ((((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * _Specular)).xxxx * _LightColor0.xyzx)).xyz;
                float4 r0_xyzw_9 = mad(((r2_xyz_2.xyzx * _LightColor0.xyzx)).xxyz, r0_z_4.xxxx, ((r1_w_5.xxxx * ((r4_xyz_11.xyzx * _Gloss.xxxx)).xyzx)).xxyz);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + (mad(((r0_y_8.xxxx * _RimColor.xyzx)).xyzx, float4(0.1, 0.1, 0.1, 0), ((r2_xyz_2.xyzx * float4(0.02, 0.02, 0.02, 0))).xyzx)).xyzx);
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_9 = r0_xyzw_10.y;
                float r0_z_6 = r0_xyzw_10.z;
                float4 r0_xyzw_11 = mad(r2_xyz_2.xyzx, i.texcoord3.xyzx, float4(r0_x_10, r0_y_9, r0_z_6, r0_x_10));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_y_10 = r0_xyzw_11.y;
                float r0_z_7 = r0_xyzw_11.z;
                o.sv_Target0.xyz = (mad(r2_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r0_x_11, r0_y_10, r0_z_7, r0_x_11))).xyz;
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
                float4 _RimColor;
                float _RimPower;
                float _Specular;
                float _Gloss;
                float _Wrap;
                float4 _MainTex_ST;
                float4 cb0_values[12];
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
            Texture2D _MainTex;
            Texture2D t1;
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
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program87Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program87Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program41Output vert(program41Input i)
            {
                program41Output o = (program41Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_3 = ((worldPos_xyzw_4.yyyy * _RimColor.xyzx)).xyz;
                float3 clipPos_xyz_4 = (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_3.xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(cb0_values[6].xyzx, worldPos_xyzw_4.zzzz, clipPos_xyz_4.xyzx)).xyz;
                o.texcoord3.xyz = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program87Output frag(program87Input i)
            {
                program87Output o = (program87Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_2 = normalize(viewDir_xyz_1);
                float4 r3_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r3_xyz_2 = ((r3_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float3 r4_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
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
                    float r2_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r5_x_8 = max(r1_w_5, r2_w_1);
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
                float r1_w_7 = saturate(dot(float4(r5_x_10, r5_y_10, r5_z_10, r5_w_4), unity_OcclusionMaskSelector));
                float r2_w_3 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float4 r4_xyzw_5 = t1.Sample(sampler_linear_clamp1, (r2_w_3.xxxx).xy);
                float r1_w_8 = (r1_w_7 * r4_xyzw_5.x);
                float r1_y_2 = (cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_2.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_2.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * cb0_values[10].x);
                float r0_y_8 = exp2(r0_y_7);
                float r0_z_4 = (r1_w_8 * saturate(((dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx) + cb0_values[10].w) / r1_y_2)));
                                float4 r1_xyzw_5 = (((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * cb0_values[10].y)).xxxx * _LightColor0.xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_3 = r1_xyzw_5.y;
                float r1_z_2 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = (float4(r1_x_5, r1_y_3, r1_z_2, r1_x_5) * cb0_values[10].zzzz);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                float4 r1_xyzw_7 = (r1_w_8.xxxx * float4(r1_x_6, r1_y_4, r1_z_3, r1_x_6));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_5 = r1_xyzw_7.y;
                float r1_z_4 = r1_xyzw_7.z;
                float4 r0_xyzw_9 = mad(((r3_xyz_2.xyzx * _LightColor0.xyzx)).xxyz, r0_z_4.xxxx, float4(r1_x_7, r1_x_7, r1_y_5, r1_z_4));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                float4 r1_xyzw_8 = (r0_y_8.xxxx * cb0_values[9].xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_z_5 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = (float4(r1_x_8, r1_y_6, r1_z_5, r1_x_8) * float4(0.1, 0.1, 0.1, 0));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_7 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r1_xyzw_10 = mad(r3_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r1_x_9, r1_y_7, r1_z_6, r1_x_9));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_8 = r1_xyzw_10.y;
                float r1_z_7 = r1_xyzw_10.z;
                o.sv_Target0.xyz = ((float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + float4(r1_x_10, r1_y_8, r1_z_7, r1_x_10))).xyz;
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
                float4 _RimColor;
                float _RimPower;
                float _Specular;
                float _Gloss;
                float _Wrap;
                float4 _MainTex_ST;
                float4 cb0_values[12];
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
            Texture2D _MainTex;
            Texture2D t1;
            TextureCube t2;
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
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program112Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
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
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_4 = ((worldPos_xyzw_4.yyyy * _RimColor.xyzx)).xyz;
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
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_2 = ((r4_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float3 r5_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r1_w_3 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float3 r2_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_4 = mad(cb3_values[25].w, (-r1_w_3 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_3);
                float r1_w_5 = saturate(mad(r1_w_4, cb3_values[24].z, cb3_values[24].w));
                float r2_x_13;
                float r2_y_13;
                float r2_z_12;
                float r2_w_8;
                if ((cb6_values[0].x == 1))
                {
                    float4 r2_xyzw_4 = (i.texcoord2.yyyy * cb6_values[2].xxyz);
                    float r2_y_4 = r2_xyzw_4.y;
                    float r2_z_4 = r2_xyzw_4.z;
                    float r2_w_2 = r2_xyzw_4.w;
                    float4 r2_xyzw_5 = mad(cb6_values[1].xxyz, i.texcoord2.xxxx, float4(r2_y_4, r2_y_4, r2_z_4, r2_w_2));
                    float r2_y_5 = r2_xyzw_5.y;
                    float r2_z_5 = r2_xyzw_5.z;
                    float r2_w_3 = r2_xyzw_5.w;
                    float4 r2_xyzw_6 = mad(cb6_values[3].xxyz, i.texcoord2.zzzz, float4(r2_y_5, r2_y_5, r2_z_5, r2_w_3));
                    float r2_y_6 = r2_xyzw_6.y;
                    float r2_z_6 = r2_xyzw_6.z;
                    float r2_w_4 = r2_xyzw_6.w;
                    float4 r2_xyzw_7 = (float4(r2_y_6, r2_y_6, r2_z_6, r2_w_4) + cb6_values[4].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_5 = r2_xyzw_7.w;
                    float4 r2_xyzw_9 = (((cb6_values[0].y == 1)).xxxx ? float4(r2_y_7, r2_z_7, r2_w_5, r2_y_7) : i.texcoord2.xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_8 = r2_xyzw_9.y;
                    float r2_z_8 = r2_xyzw_9.z;
                    float4 r2_xyzw_10 = (float4(r2_x_9, r2_y_8, r2_z_8, r2_x_9) + -cb6_values[6].xyzx);
                    float r2_x_10 = r2_xyzw_10.x;
                    float r2_y_9 = r2_xyzw_10.y;
                    float r2_z_9 = r2_xyzw_10.z;
                    float r2_y_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).y;
                    float r2_z_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).z;
                    float r2_w_6 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).w;
                    float r2_y_11 = mad(r2_y_10, 0.25, 0.75);
                    float r3_w_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r2_x_11 = max(r2_y_11, r3_w_1);
                    float4 r2_xyzw_12 = t3.Sample(sampler_linear_clamp, (float4(r2_x_11, r2_z_10, r2_w_6, r2_x_11)).xyz);
                    r2_x_13 = r2_xyzw_12.x;
                    r2_y_13 = r2_xyzw_12.y;
                    r2_z_12 = r2_xyzw_12.z;
                    r2_w_8 = r2_xyzw_12.w;
                }
                else
                {
                    float r2_x_7 = (float4(1, 1, 1, 1)).x;
                    float4 r2_xyzw_3 = float4(1, 1, 1, 1);
                    float r2_y_3 = r2_xyzw_3.y;
                    float r2_z_3 = r2_xyzw_3.z;
                    float r2_w_1 = r2_xyzw_3.w;
                    r2_x_13 = r2_x_7;
                    r2_y_13 = r2_y_3;
                    r2_z_12 = r2_z_3;
                    r2_w_8 = r2_w_1;
                }
                float r2_y_14 = (r1_w_5 < 0.99);
                float r2_y_20;
                if (r2_y_14)
                {
                    float4 r2_xyzw_16 = (i.texcoord2.xxyz + -cb2_values[1].xxyz);
                    float r2_y_16 = r2_xyzw_16.y;
                    float r2_z_13 = r2_xyzw_16.z;
                    float r2_w_9 = r2_xyzw_16.w;
                    float r3_w_3 = max(abs(r2_z_13), abs(r2_y_16));
                    float r3_w_4 = max(abs(r2_w_9), r3_w_3);
                    float r3_w_5 = (r3_w_4 + -cb2_values[2].z);
                    float r3_w_6 = max(r3_w_5, 1E-05);
                    float r3_w_7 = (r3_w_6 * cb2_values[2].w);
                    float r3_w_8 = (cb2_values[2].y / r3_w_7);
                    float r3_w_9 = (r3_w_8 + -cb2_values[2].x);
                    float r3_w_10 = (-r3_w_9 + 1);
                    float r6_x_3 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((float4(r2_y_16, r2_z_13, r2_w_9, r2_y_16) + float4(0.0078125, 0.0078125, 0.0078125, 0))).xyzx).xyz, r3_w_10);
                    float r6_y_3 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((float4(r2_y_16, r2_z_13, r2_w_9, r2_y_16) + float4(-0.0078125, -0.0078125, 0.0078125, 0))).xyzx).xyz, r3_w_10);
                    float r6_z_3 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((float4(r2_y_16, r2_z_13, r2_w_9, r2_y_16) + float4(-0.0078125, 0.0078125, -0.0078125, 0))).xyzx).xyz, r3_w_10);
                    float4 r2_xyzw_17 = (float4(r2_y_16, r2_y_16, r2_z_13, r2_w_9) + float4(0, 0.0078125, -0.0078125, -0.0078125));
                    float r2_y_17 = r2_xyzw_17.y;
                    float r2_z_14 = r2_xyzw_17.z;
                    float r2_w_10 = r2_xyzw_17.w;
                    float r6_w_1 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r2_y_17, r2_z_14, r2_w_10, r2_y_17)).xyz, r3_w_10);
                    float r2_y_18 = dot(float4(r6_x_3, r6_y_3, r6_z_3, r6_w_1), float4(0.25, 0.25, 0.25, 0.25));
                    float r2_z_15 = (-cb3_values[24].x + 1);
                    float r2_y_19 = mad(r2_y_18, r2_z_15, cb3_values[24].x);
                    r2_y_20 = r2_y_19;
                }
                else
                {
                    float r2_y_15 = 1;
                    r2_y_20 = r2_y_15;
                }
                float r1_w_6 = mad(r1_w_5, (-r2_y_20 + saturate(dot(float4(r2_x_13, r2_y_13, r2_z_12, r2_w_8), unity_OcclusionMaskSelector))), r2_y_20);
                float r2_x_17 = (t1.Sample(sampler_linear_clamp3, ((dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx)).xxxx).xy)).x;
                float4 r2_xyzw_21 = t1.Sample(sampler_linear_clamp3, ((dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx)).xxxx).xy);
                float r2_y_21 = r2_xyzw_21.y;
                float r2_z_17 = r2_xyzw_21.z;
                float r2_w_12 = r2_xyzw_21.w;
                float4 r5_xyzw_5 = t2.Sample(sampler_linear_clamp2, r5_xyz_4.xyz);
                float r1_w_7 = (r1_w_6 * (r2_x_17 * r5_xyzw_5.w));
                float r1_y_2 = (cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_1.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * cb0_values[10].x);
                float r0_y_8 = exp2(r0_y_7);
                float4 r2_xyzw_19 = (r4_xyz_2.xyzx * _LightColor0.xyzx);
                float r2_x_19 = r2_xyzw_19.x;
                float r2_y_22 = r2_xyzw_19.y;
                float r2_z_18 = r2_xyzw_19.z;
                float r0_z_4 = (r1_w_7 * saturate(((dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx) + cb0_values[10].w) / r1_y_2)));
                                float4 r1_xyzw_5 = (((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * cb0_values[10].y)).xxxx * _LightColor0.xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_3 = r1_xyzw_5.y;
                float r1_z_2 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = (float4(r1_x_5, r1_y_3, r1_z_2, r1_x_5) * cb0_values[10].zzzz);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                float4 r1_xyzw_7 = (r1_w_7.xxxx * float4(r1_x_6, r1_y_4, r1_z_3, r1_x_6));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_5 = r1_xyzw_7.y;
                float r1_z_4 = r1_xyzw_7.z;
                float4 r0_xyzw_9 = mad(float4(r2_x_19, r2_x_19, r2_y_22, r2_z_18), r0_z_4.xxxx, float4(r1_x_7, r1_x_7, r1_y_5, r1_z_4));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                float4 r1_xyzw_8 = (r0_y_8.xxxx * cb0_values[9].xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_z_5 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = (float4(r1_x_8, r1_y_6, r1_z_5, r1_x_8) * float4(0.1, 0.1, 0.1, 0));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_7 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r1_xyzw_10 = mad(r4_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r1_x_9, r1_y_7, r1_z_6, r1_x_9));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_8 = r1_xyzw_10.y;
                float r1_z_7 = r1_xyzw_10.z;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + float4(r1_x_10, r1_y_8, r1_z_7, r1_x_10));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_9 = r0_xyzw_10.y;
                float r0_z_6 = r0_xyzw_10.z;
                float r0_w_6 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_7 = (-r0_w_6 + 1);
                float r0_w_8 = (r0_w_7 * cb1_values[5].z);
                float r0_w_9 = max(r0_w_8, 0);
                float r0_w_10 = saturate(mad(r0_w_9, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_10, r0_y_9, r0_z_6, r0_x_10) * r0_w_10.xxxx)).xyz;
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
                float4 _RimColor;
                float _RimPower;
                float _Specular;
                float _Gloss;
                float _Wrap;
                float4 _MainTex_ST;
                float4 cb0_values[12];
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
            Texture2D _MainTex;
            Texture2D t1;
            TextureCube t2;
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
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program111Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
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
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_4 = ((worldPos_xyzw_4.yyyy * _RimColor.xyzx)).xyz;
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
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_2 = ((r4_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float3 r5_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r1_w_3 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float3 r2_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_4 = mad(cb3_values[25].w, (-r1_w_3 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_3);
                float r1_w_5 = saturate(mad(r1_w_4, cb3_values[24].z, cb3_values[24].w));
                float r2_x_13;
                float r2_y_13;
                float r2_z_12;
                float r2_w_8;
                if ((cb6_values[0].x == 1))
                {
                    float4 r2_xyzw_4 = (i.texcoord2.yyyy * cb6_values[2].xxyz);
                    float r2_y_4 = r2_xyzw_4.y;
                    float r2_z_4 = r2_xyzw_4.z;
                    float r2_w_2 = r2_xyzw_4.w;
                    float4 r2_xyzw_5 = mad(cb6_values[1].xxyz, i.texcoord2.xxxx, float4(r2_y_4, r2_y_4, r2_z_4, r2_w_2));
                    float r2_y_5 = r2_xyzw_5.y;
                    float r2_z_5 = r2_xyzw_5.z;
                    float r2_w_3 = r2_xyzw_5.w;
                    float4 r2_xyzw_6 = mad(cb6_values[3].xxyz, i.texcoord2.zzzz, float4(r2_y_5, r2_y_5, r2_z_5, r2_w_3));
                    float r2_y_6 = r2_xyzw_6.y;
                    float r2_z_6 = r2_xyzw_6.z;
                    float r2_w_4 = r2_xyzw_6.w;
                    float4 r2_xyzw_7 = (float4(r2_y_6, r2_y_6, r2_z_6, r2_w_4) + cb6_values[4].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_5 = r2_xyzw_7.w;
                    float4 r2_xyzw_9 = (((cb6_values[0].y == 1)).xxxx ? float4(r2_y_7, r2_z_7, r2_w_5, r2_y_7) : i.texcoord2.xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_8 = r2_xyzw_9.y;
                    float r2_z_8 = r2_xyzw_9.z;
                    float4 r2_xyzw_10 = (float4(r2_x_9, r2_y_8, r2_z_8, r2_x_9) + -cb6_values[6].xyzx);
                    float r2_x_10 = r2_xyzw_10.x;
                    float r2_y_9 = r2_xyzw_10.y;
                    float r2_z_9 = r2_xyzw_10.z;
                    float r2_y_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).y;
                    float r2_z_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).z;
                    float r2_w_6 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).w;
                    float r2_y_11 = mad(r2_y_10, 0.25, 0.75);
                    float r3_w_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r2_x_11 = max(r2_y_11, r3_w_1);
                    float4 r2_xyzw_12 = t3.Sample(sampler_linear_clamp, (float4(r2_x_11, r2_z_10, r2_w_6, r2_x_11)).xyz);
                    r2_x_13 = r2_xyzw_12.x;
                    r2_y_13 = r2_xyzw_12.y;
                    r2_z_12 = r2_xyzw_12.z;
                    r2_w_8 = r2_xyzw_12.w;
                }
                else
                {
                    float r2_x_7 = (float4(1, 1, 1, 1)).x;
                    float4 r2_xyzw_3 = float4(1, 1, 1, 1);
                    float r2_y_3 = r2_xyzw_3.y;
                    float r2_z_3 = r2_xyzw_3.z;
                    float r2_w_1 = r2_xyzw_3.w;
                    r2_x_13 = r2_x_7;
                    r2_y_13 = r2_y_3;
                    r2_z_12 = r2_z_3;
                    r2_w_8 = r2_w_1;
                }
                float4 r2_xyzw_14 = (i.texcoord2.xxyz + -cb2_values[1].xxyz);
                float r2_y_14 = r2_xyzw_14.y;
                float r2_z_13 = r2_xyzw_14.z;
                float r2_w_9 = r2_xyzw_14.w;
                float r3_w_3 = max(abs(r2_z_13), abs(r2_y_14));
                float r3_w_4 = max(abs(r2_w_9), r3_w_3);
                float r3_w_5 = (r3_w_4 + -cb2_values[2].z);
                float r3_w_6 = max(r3_w_5, 1E-05);
                float r3_w_7 = (r3_w_6 * cb2_values[2].w);
                float r3_w_8 = (cb2_values[2].y / r3_w_7);
                float r3_w_9 = (r3_w_8 + -cb2_values[2].x);
                float r3_w_10 = (-r3_w_9 + 1);
                float r2_y_15 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r2_y_14, r2_z_13, r2_w_9, r2_y_14)).xyz, r3_w_10);
                float r2_z_14 = (-cb3_values[24].x + 1);
                float r2_y_16 = mad(r2_y_15, r2_z_14, cb3_values[24].x);
                float r1_w_6 = mad(r1_w_5, (-r2_y_16 + saturate(dot(float4(r2_x_13, r2_y_13, r2_z_12, r2_w_8), unity_OcclusionMaskSelector))), r2_y_16);
                float4 r2_xyzw_17 = t1.Sample(sampler_linear_clamp3, ((dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx)).xxxx).xy);
                float4 r5_xyzw_5 = t2.Sample(sampler_linear_clamp2, r5_xyz_4.xyz);
                float r1_w_7 = (r1_w_6 * (r2_xyzw_17.x * r5_xyzw_5.w));
                float r1_y_2 = (cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_1.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * cb0_values[10].x);
                float r0_y_8 = exp2(r0_y_7);
                float4 r2_xyzw_19 = (r4_xyz_2.xyzx * _LightColor0.xyzx);
                float r2_x_19 = r2_xyzw_19.x;
                float r2_y_18 = r2_xyzw_19.y;
                float r2_z_16 = r2_xyzw_19.z;
                float r0_z_4 = (r1_w_7 * saturate(((dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx) + cb0_values[10].w) / r1_y_2)));
                                float4 r1_xyzw_5 = (((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * cb0_values[10].y)).xxxx * _LightColor0.xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_3 = r1_xyzw_5.y;
                float r1_z_2 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = (float4(r1_x_5, r1_y_3, r1_z_2, r1_x_5) * cb0_values[10].zzzz);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                float4 r1_xyzw_7 = (r1_w_7.xxxx * float4(r1_x_6, r1_y_4, r1_z_3, r1_x_6));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_5 = r1_xyzw_7.y;
                float r1_z_4 = r1_xyzw_7.z;
                float4 r0_xyzw_9 = mad(float4(r2_x_19, r2_x_19, r2_y_18, r2_z_16), r0_z_4.xxxx, float4(r1_x_7, r1_x_7, r1_y_5, r1_z_4));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                float4 r1_xyzw_8 = (r0_y_8.xxxx * cb0_values[9].xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_z_5 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = (float4(r1_x_8, r1_y_6, r1_z_5, r1_x_8) * float4(0.1, 0.1, 0.1, 0));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_7 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r1_xyzw_10 = mad(r4_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r1_x_9, r1_y_7, r1_z_6, r1_x_9));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_8 = r1_xyzw_10.y;
                float r1_z_7 = r1_xyzw_10.z;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + float4(r1_x_10, r1_y_8, r1_z_7, r1_x_10));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_9 = r0_xyzw_10.y;
                float r0_z_6 = r0_xyzw_10.z;
                float r0_w_6 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_7 = (-r0_w_6 + 1);
                float r0_w_8 = (r0_w_7 * cb1_values[5].z);
                float r0_w_9 = max(r0_w_8, 0);
                float r0_w_10 = saturate(mad(r0_w_9, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_10, r0_y_9, r0_z_6, r0_x_10) * r0_w_10.xxxx)).xyz;
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
                float4 _RimColor;
                float _RimPower;
                float _Specular;
                float _Gloss;
                float _Wrap;
                float4 _MainTex_ST;
                float4 cb0_values[12];
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
            Texture2D _MainTex;
            Texture2D t1;
            Texture3D t2;
            TextureCube t3;
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
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program110Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
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
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_4 = ((worldPos_xyzw_4.yyyy * _RimColor.xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(cb0_values[6].xyzx, worldPos_xyzw_4.zzzz, (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_4.xyzx)).xyzx)).xyz;
                o.texcoord3.xyz = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program110Output frag(program110Input i)
            {
                program110Output o = (program110Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_2 = ((r4_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float3 r5_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r1_w_3 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float3 r2_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_4 = mad(cb3_values[25].w, (-r1_w_3 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_3);
                float r1_w_5 = saturate(mad(r1_w_4, cb3_values[24].z, cb3_values[24].w));
                float r2_x_13;
                float r2_y_13;
                float r2_z_12;
                float r2_w_8;
                if ((cb6_values[0].x == 1))
                {
                    float4 r2_xyzw_4 = (i.texcoord2.yyyy * cb6_values[2].xxyz);
                    float r2_y_4 = r2_xyzw_4.y;
                    float r2_z_4 = r2_xyzw_4.z;
                    float r2_w_2 = r2_xyzw_4.w;
                    float4 r2_xyzw_5 = mad(cb6_values[1].xxyz, i.texcoord2.xxxx, float4(r2_y_4, r2_y_4, r2_z_4, r2_w_2));
                    float r2_y_5 = r2_xyzw_5.y;
                    float r2_z_5 = r2_xyzw_5.z;
                    float r2_w_3 = r2_xyzw_5.w;
                    float4 r2_xyzw_6 = mad(cb6_values[3].xxyz, i.texcoord2.zzzz, float4(r2_y_5, r2_y_5, r2_z_5, r2_w_3));
                    float r2_y_6 = r2_xyzw_6.y;
                    float r2_z_6 = r2_xyzw_6.z;
                    float r2_w_4 = r2_xyzw_6.w;
                    float4 r2_xyzw_7 = (float4(r2_y_6, r2_y_6, r2_z_6, r2_w_4) + cb6_values[4].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_5 = r2_xyzw_7.w;
                    float4 r2_xyzw_9 = (((cb6_values[0].y == 1)).xxxx ? float4(r2_y_7, r2_z_7, r2_w_5, r2_y_7) : i.texcoord2.xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_8 = r2_xyzw_9.y;
                    float r2_z_8 = r2_xyzw_9.z;
                    float4 r2_xyzw_10 = (float4(r2_x_9, r2_y_8, r2_z_8, r2_x_9) + -cb6_values[6].xyzx);
                    float r2_x_10 = r2_xyzw_10.x;
                    float r2_y_9 = r2_xyzw_10.y;
                    float r2_z_9 = r2_xyzw_10.z;
                    float r2_y_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).y;
                    float r2_z_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).z;
                    float r2_w_6 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).w;
                    float r2_y_11 = mad(r2_y_10, 0.25, 0.75);
                    float r3_w_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r2_x_11 = max(r2_y_11, r3_w_1);
                    float4 r2_xyzw_12 = t2.Sample(sampler_linear_clamp, (float4(r2_x_11, r2_z_10, r2_w_6, r2_x_11)).xyz);
                    r2_x_13 = r2_xyzw_12.x;
                    r2_y_13 = r2_xyzw_12.y;
                    r2_z_12 = r2_xyzw_12.z;
                    r2_w_8 = r2_xyzw_12.w;
                }
                else
                {
                    float r2_x_7 = (float4(1, 1, 1, 1)).x;
                    float4 r2_xyzw_3 = float4(1, 1, 1, 1);
                    float r2_y_3 = r2_xyzw_3.y;
                    float r2_z_3 = r2_xyzw_3.z;
                    float r2_w_1 = r2_xyzw_3.w;
                    r2_x_13 = r2_x_7;
                    r2_y_13 = r2_y_3;
                    r2_z_12 = r2_z_3;
                    r2_w_8 = r2_w_1;
                }
                float r2_y_14 = (r1_w_5 < 0.99);
                float r2_y_20;
                if (r2_y_14)
                {
                    float4 r2_xyzw_16 = (i.texcoord2.xxyz + -cb2_values[1].xxyz);
                    float r2_y_16 = r2_xyzw_16.y;
                    float r2_z_13 = r2_xyzw_16.z;
                    float r2_w_9 = r2_xyzw_16.w;
                    float r3_w_3 = max(abs(r2_z_13), abs(r2_y_16));
                    float r3_w_4 = max(abs(r2_w_9), r3_w_3);
                    float r3_w_5 = (r3_w_4 + -cb2_values[2].z);
                    float r3_w_6 = max(r3_w_5, 1E-05);
                    float r3_w_7 = (r3_w_6 * cb2_values[2].w);
                    float r3_w_8 = (cb2_values[2].y / r3_w_7);
                    float r3_w_9 = (r3_w_8 + -cb2_values[2].x);
                    float r3_w_10 = (-r3_w_9 + 1);
                    float r6_x_3 = t3.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((float4(r2_y_16, r2_z_13, r2_w_9, r2_y_16) + float4(0.0078125, 0.0078125, 0.0078125, 0))).xyzx).xyz, r3_w_10);
                    float r6_y_3 = t3.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((float4(r2_y_16, r2_z_13, r2_w_9, r2_y_16) + float4(-0.0078125, -0.0078125, 0.0078125, 0))).xyzx).xyz, r3_w_10);
                    float r6_z_3 = t3.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((float4(r2_y_16, r2_z_13, r2_w_9, r2_y_16) + float4(-0.0078125, 0.0078125, -0.0078125, 0))).xyzx).xyz, r3_w_10);
                    float4 r2_xyzw_17 = (float4(r2_y_16, r2_y_16, r2_z_13, r2_w_9) + float4(0, 0.0078125, -0.0078125, -0.0078125));
                    float r2_y_17 = r2_xyzw_17.y;
                    float r2_z_14 = r2_xyzw_17.z;
                    float r2_w_10 = r2_xyzw_17.w;
                    float r6_w_1 = t3.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r2_y_17, r2_z_14, r2_w_10, r2_y_17)).xyz, r3_w_10);
                    float r2_y_18 = dot(float4(r6_x_3, r6_y_3, r6_z_3, r6_w_1), float4(0.25, 0.25, 0.25, 0.25));
                    float r2_z_15 = (-cb3_values[24].x + 1);
                    float r2_y_19 = mad(r2_y_18, r2_z_15, cb3_values[24].x);
                    r2_y_20 = r2_y_19;
                }
                else
                {
                    float r2_y_15 = 1;
                    r2_y_20 = r2_y_15;
                }
                float r1_w_6 = mad(r1_w_5, (-r2_y_20 + saturate(dot(float4(r2_x_13, r2_y_13, r2_z_12, r2_w_8), unity_OcclusionMaskSelector))), r2_y_20);
                float r2_x_17 = (t1.Sample(sampler_linear_clamp2, ((dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx)).xxxx).xy)).x;
                float4 r2_xyzw_21 = t1.Sample(sampler_linear_clamp2, ((dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx)).xxxx).xy);
                float r2_y_21 = r2_xyzw_21.y;
                float r2_z_17 = r2_xyzw_21.z;
                float r2_w_12 = r2_xyzw_21.w;
                float r1_w_7 = (r1_w_6 * r2_x_17);
                float r1_y_2 = (cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_1.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * cb0_values[10].x);
                float r0_y_8 = exp2(r0_y_7);
                float4 r2_xyzw_18 = (r4_xyz_2.xyzx * _LightColor0.xyzx);
                float r2_x_18 = r2_xyzw_18.x;
                float r2_y_22 = r2_xyzw_18.y;
                float r2_z_18 = r2_xyzw_18.z;
                float r0_z_4 = (r1_w_7 * saturate(((dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx) + cb0_values[10].w) / r1_y_2)));
                                float4 r1_xyzw_5 = (((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * cb0_values[10].y)).xxxx * _LightColor0.xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_3 = r1_xyzw_5.y;
                float r1_z_2 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = (float4(r1_x_5, r1_y_3, r1_z_2, r1_x_5) * cb0_values[10].zzzz);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                float4 r1_xyzw_7 = (r1_w_7.xxxx * float4(r1_x_6, r1_y_4, r1_z_3, r1_x_6));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_5 = r1_xyzw_7.y;
                float r1_z_4 = r1_xyzw_7.z;
                float4 r0_xyzw_9 = mad(float4(r2_x_18, r2_x_18, r2_y_22, r2_z_18), r0_z_4.xxxx, float4(r1_x_7, r1_x_7, r1_y_5, r1_z_4));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                float4 r1_xyzw_8 = (r0_y_8.xxxx * cb0_values[9].xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_z_5 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = (float4(r1_x_8, r1_y_6, r1_z_5, r1_x_8) * float4(0.1, 0.1, 0.1, 0));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_7 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r1_xyzw_10 = mad(r4_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r1_x_9, r1_y_7, r1_z_6, r1_x_9));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_8 = r1_xyzw_10.y;
                float r1_z_7 = r1_xyzw_10.z;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + float4(r1_x_10, r1_y_8, r1_z_7, r1_x_10));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_9 = r0_xyzw_10.y;
                float r0_z_6 = r0_xyzw_10.z;
                float r0_w_6 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_7 = (-r0_w_6 + 1);
                float r0_w_8 = (r0_w_7 * cb1_values[5].z);
                float r0_w_9 = max(r0_w_8, 0);
                float r0_w_10 = saturate(mad(r0_w_9, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_10, r0_y_9, r0_z_6, r0_x_10) * r0_w_10.xxxx)).xyz;
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
                float4 _RimColor;
                float _RimPower;
                float _Specular;
                float _Gloss;
                float _Wrap;
                float4 _MainTex_ST;
                float4 cb0_values[12];
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
            Texture2D _MainTex;
            Texture2D t1;
            Texture3D t2;
            TextureCube t3;
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
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program109Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
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
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_4 = ((worldPos_xyzw_4.yyyy * _RimColor.xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(cb0_values[6].xyzx, worldPos_xyzw_4.zzzz, (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_4.xyzx)).xyzx)).xyz;
                o.texcoord3.xyz = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program109Output frag(program109Input i)
            {
                program109Output o = (program109Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_2 = ((r4_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float3 r5_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r1_w_3 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float3 r2_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_4 = mad(cb3_values[25].w, (-r1_w_3 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_3);
                float r1_w_5 = saturate(mad(r1_w_4, cb3_values[24].z, cb3_values[24].w));
                float r2_x_13;
                float r2_y_13;
                float r2_z_12;
                float r2_w_8;
                if ((cb6_values[0].x == 1))
                {
                    float4 r2_xyzw_4 = (i.texcoord2.yyyy * cb6_values[2].xxyz);
                    float r2_y_4 = r2_xyzw_4.y;
                    float r2_z_4 = r2_xyzw_4.z;
                    float r2_w_2 = r2_xyzw_4.w;
                    float4 r2_xyzw_5 = mad(cb6_values[1].xxyz, i.texcoord2.xxxx, float4(r2_y_4, r2_y_4, r2_z_4, r2_w_2));
                    float r2_y_5 = r2_xyzw_5.y;
                    float r2_z_5 = r2_xyzw_5.z;
                    float r2_w_3 = r2_xyzw_5.w;
                    float4 r2_xyzw_6 = mad(cb6_values[3].xxyz, i.texcoord2.zzzz, float4(r2_y_5, r2_y_5, r2_z_5, r2_w_3));
                    float r2_y_6 = r2_xyzw_6.y;
                    float r2_z_6 = r2_xyzw_6.z;
                    float r2_w_4 = r2_xyzw_6.w;
                    float4 r2_xyzw_7 = (float4(r2_y_6, r2_y_6, r2_z_6, r2_w_4) + cb6_values[4].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_5 = r2_xyzw_7.w;
                    float4 r2_xyzw_9 = (((cb6_values[0].y == 1)).xxxx ? float4(r2_y_7, r2_z_7, r2_w_5, r2_y_7) : i.texcoord2.xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_8 = r2_xyzw_9.y;
                    float r2_z_8 = r2_xyzw_9.z;
                    float4 r2_xyzw_10 = (float4(r2_x_9, r2_y_8, r2_z_8, r2_x_9) + -cb6_values[6].xyzx);
                    float r2_x_10 = r2_xyzw_10.x;
                    float r2_y_9 = r2_xyzw_10.y;
                    float r2_z_9 = r2_xyzw_10.z;
                    float r2_y_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).y;
                    float r2_z_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).z;
                    float r2_w_6 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).w;
                    float r2_y_11 = mad(r2_y_10, 0.25, 0.75);
                    float r3_w_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r2_x_11 = max(r2_y_11, r3_w_1);
                    float4 r2_xyzw_12 = t2.Sample(sampler_linear_clamp, (float4(r2_x_11, r2_z_10, r2_w_6, r2_x_11)).xyz);
                    r2_x_13 = r2_xyzw_12.x;
                    r2_y_13 = r2_xyzw_12.y;
                    r2_z_12 = r2_xyzw_12.z;
                    r2_w_8 = r2_xyzw_12.w;
                }
                else
                {
                    float r2_x_7 = (float4(1, 1, 1, 1)).x;
                    float4 r2_xyzw_3 = float4(1, 1, 1, 1);
                    float r2_y_3 = r2_xyzw_3.y;
                    float r2_z_3 = r2_xyzw_3.z;
                    float r2_w_1 = r2_xyzw_3.w;
                    r2_x_13 = r2_x_7;
                    r2_y_13 = r2_y_3;
                    r2_z_12 = r2_z_3;
                    r2_w_8 = r2_w_1;
                }
                float4 r2_xyzw_14 = (i.texcoord2.xxyz + -cb2_values[1].xxyz);
                float r2_y_14 = r2_xyzw_14.y;
                float r2_z_13 = r2_xyzw_14.z;
                float r2_w_9 = r2_xyzw_14.w;
                float r3_w_3 = max(abs(r2_z_13), abs(r2_y_14));
                float r3_w_4 = max(abs(r2_w_9), r3_w_3);
                float r3_w_5 = (r3_w_4 + -cb2_values[2].z);
                float r3_w_6 = max(r3_w_5, 1E-05);
                float r3_w_7 = (r3_w_6 * cb2_values[2].w);
                float r3_w_8 = (cb2_values[2].y / r3_w_7);
                float r3_w_9 = (r3_w_8 + -cb2_values[2].x);
                float r3_w_10 = (-r3_w_9 + 1);
                float r2_y_15 = t3.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r2_y_14, r2_z_13, r2_w_9, r2_y_14)).xyz, r3_w_10);
                float r2_z_14 = (-cb3_values[24].x + 1);
                float r2_y_16 = mad(r2_y_15, r2_z_14, cb3_values[24].x);
                float r1_w_6 = mad(r1_w_5, (-r2_y_16 + saturate(dot(float4(r2_x_13, r2_y_13, r2_z_12, r2_w_8), unity_OcclusionMaskSelector))), r2_y_16);
                float4 r2_xyzw_17 = t1.Sample(sampler_linear_clamp2, ((dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx)).xxxx).xy);
                float r1_w_7 = (r1_w_6 * r2_xyzw_17.x);
                float r1_y_2 = (cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_1.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * cb0_values[10].x);
                float r0_y_8 = exp2(r0_y_7);
                float4 r2_xyzw_18 = (r4_xyz_2.xyzx * _LightColor0.xyzx);
                float r2_x_18 = r2_xyzw_18.x;
                float r2_y_18 = r2_xyzw_18.y;
                float r2_z_16 = r2_xyzw_18.z;
                float r0_z_4 = (r1_w_7 * saturate(((dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx) + cb0_values[10].w) / r1_y_2)));
                                float4 r1_xyzw_5 = (((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * cb0_values[10].y)).xxxx * _LightColor0.xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_3 = r1_xyzw_5.y;
                float r1_z_2 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = (float4(r1_x_5, r1_y_3, r1_z_2, r1_x_5) * cb0_values[10].zzzz);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                float4 r1_xyzw_7 = (r1_w_7.xxxx * float4(r1_x_6, r1_y_4, r1_z_3, r1_x_6));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_5 = r1_xyzw_7.y;
                float r1_z_4 = r1_xyzw_7.z;
                float4 r0_xyzw_9 = mad(float4(r2_x_18, r2_x_18, r2_y_18, r2_z_16), r0_z_4.xxxx, float4(r1_x_7, r1_x_7, r1_y_5, r1_z_4));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                float4 r1_xyzw_8 = (r0_y_8.xxxx * cb0_values[9].xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_z_5 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = (float4(r1_x_8, r1_y_6, r1_z_5, r1_x_8) * float4(0.1, 0.1, 0.1, 0));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_7 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r1_xyzw_10 = mad(r4_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r1_x_9, r1_y_7, r1_z_6, r1_x_9));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_8 = r1_xyzw_10.y;
                float r1_z_7 = r1_xyzw_10.z;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + float4(r1_x_10, r1_y_8, r1_z_7, r1_x_10));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_9 = r0_xyzw_10.y;
                float r0_z_6 = r0_xyzw_10.z;
                float r0_w_6 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_7 = (-r0_w_6 + 1);
                float r0_w_8 = (r0_w_7 * cb1_values[5].z);
                float r0_w_9 = max(r0_w_8, 0);
                float r0_w_10 = saturate(mad(r0_w_9, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_10, r0_y_9, r0_z_6, r0_x_10) * r0_w_10.xxxx)).xyz;
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
                float4 _RimColor;
                float _RimPower;
                float _Specular;
                float _Gloss;
                float _Wrap;
                float4 _MainTex_ST;
                float4 cb0_values[12];
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
            Texture2D _MainTex;
            Texture2D t1;
            Texture2D t2;
            Texture3D t3;
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
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program108Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
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
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                float4 r2_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                o.texcoord3.xy = (mad(_MainTex_ST.xxxy, r2_xyzw_4.wwww, (mad(cb0_values[6].xyxx, r2_xyzw_4.zzzz, (mad(_Color.xyxx, r2_xyzw_4.xxxx, ((r2_xyzw_4.yyyy * _RimColor.xyxx)).xyxx)).xyxx)).xxxy)).zw;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_w_4 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7));
                float r0_w_5 = rsqrt(r0_w_4);
                o.texcoord1.xyz = ((r0_w_5.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7))).xyz;
                o.texcoord5.x = clipPos_xyzw_2.z;
                float r0_w_6 = ((clipPos_xyzw_2.y * unity_WorldToObject[1].x) * 0.5);
                float4 r0_xyzw_9 = (clipPos_xyzw_2.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                o.texcoord4.zw = (clipPos_xyzw_2.zzzw).zw;
                o.texcoord4.xy = ((r0_z_5.xxxx + float4(r0_x_9, r0_w_6, r0_x_9, r0_x_9))).xy;
                return o;
            }
            #pragma fragment frag
            program108Output frag(program108Input i)
            {
                program108Output o = (program108Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_2 = ((r2_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float r4_x_1 = cb4_values[9].z;
                float r4_y_1 = cb4_values[10].z;
                float r4_z_1 = cb4_values[11].z;
                float r1_w_1 = dot(viewDir_xyz_1.xyzx, float4(r4_x_1, r4_y_1, r4_z_1, r4_x_1));
                float3 r4_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = dot(r4_xyz_2.xyzx, r4_xyz_2.xyzx);
                float r2_w_3 = sqrt(r2_w_2);
                float r2_w_4 = (-r1_w_1 + r2_w_3);
                float r1_w_2 = mad(cb3_values[25].w, r2_w_4, r1_w_1);
                float r1_w_3 = saturate(mad(r1_w_2, cb3_values[24].z, cb3_values[24].w));
                float r2_w_5 = (cb6_values[0].x == 1);
                float r4_x_12;
                float r4_y_12;
                float r4_z_12;
                float r4_w_4;
                if (r2_w_5)
                {
                    float r2_w_6 = (cb6_values[0].y == 1);
                    float3 r4_xyz_7 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r4_xyzw_10 = (((((r2_w_6.xxxx ? r4_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r4_y_10 = r4_xyzw_10.y;
                    float r4_z_10 = r4_xyzw_10.z;
                    float r4_w_2 = r4_xyzw_10.w;
                    float r2_w_7 = mad(r4_y_10, 0.25, 0.75);
                    float r3_z_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r4_x_10 = max(r2_w_7, r3_z_1);
                    float4 r4_xyzw_11 = t3.Sample(sampler_linear_clamp, (float4(r4_x_10, r4_z_10, r4_w_2, r4_x_10)).xyz);
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
                float4 r3_xyzw_3 = (i.texcoord4.xxxy / i.texcoord4.wwww);
                float r3_z_3 = r3_xyzw_3.z;
                float r3_w_1 = r3_xyzw_3.w;
                float4 r4_xyzw_13 = t1.Sample(sampler_linear_clamp1, (float4(r3_z_3, r3_w_1, r3_z_3, r3_z_3)).xy);
                float r2_w_10 = (r2_w_9 + -r4_xyzw_13.x);
                float r1_w_4 = mad(r1_w_3, r2_w_10, r4_xyzw_13.x);
                float4 r3_xyzw_5 = t2.Sample(sampler_linear_clamp2, ((((mad(cb0_values[6].xyxx, i.texcoord2.zzzz, (mad(cb0_values[4].xyxx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx).xy);
                float r1_w_5 = (r1_w_4 * r3_xyzw_5.w);
                float r2_w_11 = dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx);
                float r2_w_12 = (r2_w_11 + cb0_values[10].w);
                float r2_w_13 = saturate((r2_w_12 / (cb0_values[10].w + 1)));
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_1.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * cb0_values[10].x);
                float r0_y_8 = exp2(r0_y_7);
                float r0_z_4 = (r1_w_5 * r2_w_13);
                                float4 r3_xyzw_7 = (((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * cb0_values[10].y)).xxxx * _LightColor0.xyzx);
                float r3_x_7 = r3_xyzw_7.x;
                float r3_y_6 = r3_xyzw_7.y;
                float r3_z_5 = r3_xyzw_7.z;
                float4 r3_xyzw_8 = (float4(r3_x_7, r3_y_6, r3_z_5, r3_x_7) * cb0_values[10].zzzz);
                float r3_x_8 = r3_xyzw_8.x;
                float r3_y_7 = r3_xyzw_8.y;
                float r3_z_6 = r3_xyzw_8.z;
                float4 r3_xyzw_9 = (r1_w_5.xxxx * float4(r3_x_8, r3_y_7, r3_z_6, r3_x_8));
                float r3_x_9 = r3_xyzw_9.x;
                float r3_y_8 = r3_xyzw_9.y;
                float r3_z_7 = r3_xyzw_9.z;
                float4 r0_xyzw_9 = mad(((r2_xyz_2.xyzx * _LightColor0.xyzx)).xxyz, r0_z_4.xxxx, float4(r3_x_9, r3_x_9, r3_y_8, r3_z_7));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + (mad(r2_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), ((((r0_y_8.xxxx * cb0_values[9].xyzx)).xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx)).xyzx);
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_9 = r0_xyzw_10.y;
                float r0_z_6 = r0_xyzw_10.z;
                float r0_w_6 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_7 = (-r0_w_6 + 1);
                float r0_w_8 = (r0_w_7 * cb1_values[5].z);
                float r0_w_9 = max(r0_w_8, 0);
                float r0_w_10 = saturate(mad(r0_w_9, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_10, r0_y_9, r0_z_6, r0_x_10) * r0_w_10.xxxx)).xyz;
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
                float4 _RimColor;
                float _RimPower;
                float _Specular;
                float _Gloss;
                float _Wrap;
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
            Texture2D _MainTex;
            Texture2D t1;
            Texture3D t2;
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
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program107Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
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
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord5.x = clipPos_xyzw_7.z;
                o.texcoord4.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_z_8 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r0_z_9 = rsqrt(r0_z_8);
                o.texcoord1.xyz = ((r0_z_9.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r0_xyzw_8 = (clipPos_xyzw_7.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_z_10 = r0_xyzw_8.z;
                float r0_w_8 = (r0_y_8 * 0.5);
                o.texcoord4.xy = ((r0_z_10.xxxx + float4(r0_x_8, r0_w_8, r0_x_8, r0_x_8))).xy;
                return o;
            }
            #pragma fragment frag
            program107Output frag(program107Input i)
            {
                program107Output o = (program107Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_2 = ((r2_xyzw_1.xyzx * cb0_values[4].xyzx)).xyz;
                float r3_x_1 = cb4_values[9].z;
                float r3_y_1 = cb4_values[10].z;
                float r3_z_1 = cb4_values[11].z;
                float r1_w_1 = dot(viewDir_xyz_1.xyzx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float3 r3_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = dot(r3_xyz_2.xyzx, r3_xyz_2.xyzx);
                float r2_w_3 = sqrt(r2_w_2);
                float r2_w_4 = (-r1_w_1 + r2_w_3);
                float r1_w_2 = mad(cb3_values[25].w, r2_w_4, r1_w_1);
                float r1_w_3 = saturate(mad(r1_w_2, cb3_values[24].z, cb3_values[24].w));
                float r2_w_5 = (cb6_values[0].x == 1);
                float r3_x_12;
                float r3_y_13;
                float r3_z_12;
                float r3_w_4;
                if (r2_w_5)
                {
                    float r2_w_6 = (cb6_values[0].y == 1);
                    float3 r3_xyz_7 = (((mad(cb6_values[3].xyzx, i.texcoord2.zzzz, (mad(cb6_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r3_xyzw_10 = (((((r2_w_6.xxxx ? r3_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r3_y_10 = r3_xyzw_10.y;
                    float r3_z_10 = r3_xyzw_10.z;
                    float r3_w_2 = r3_xyzw_10.w;
                    float r2_w_7 = mad(r3_y_10, 0.25, 0.75);
                    float r3_y_11 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r3_x_10 = max(r2_w_7, r3_y_11);
                    float4 r3_xyzw_11 = t2.Sample(sampler_linear_clamp, (float4(r3_x_10, r3_z_10, r3_w_2, r3_x_10)).xyz);
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
                float4 r3_xyzw_13 = (i.texcoord4.xyxx / i.texcoord4.wwww);
                float r3_x_13 = r3_xyzw_13.x;
                float r3_y_14 = r3_xyzw_13.y;
                float4 r3_xyzw_14 = t1.Sample(sampler_linear_clamp1, (float4(r3_x_13, r3_y_14, r3_x_13, r3_x_13)).xy);
                float r2_w_10 = (r2_w_9 + -r3_xyzw_14.x);
                float r1_w_4 = mad(r1_w_3, r2_w_10, r3_xyzw_14.x);
                float r2_w_11 = dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx);
                float r2_w_12 = (r2_w_11 + cb0_values[6].w);
                float r2_w_13 = saturate((r2_w_12 / (cb0_values[6].w + 1)));
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_1.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * cb0_values[6].x);
                float r0_y_8 = exp2(r0_y_7);
                float r0_z_4 = (r1_w_4 * r2_w_13);
                                float4 r3_xyzw_16 = (((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * cb0_values[6].y)).xxxx * _LightColor0.xyzx);
                float r3_x_16 = r3_xyzw_16.x;
                float r3_y_16 = r3_xyzw_16.y;
                float r3_z_14 = r3_xyzw_16.z;
                float4 r3_xyzw_17 = (float4(r3_x_16, r3_y_16, r3_z_14, r3_x_16) * cb0_values[6].zzzz);
                float r3_x_17 = r3_xyzw_17.x;
                float r3_y_17 = r3_xyzw_17.y;
                float r3_z_15 = r3_xyzw_17.z;
                float4 r3_xyzw_18 = (r1_w_4.xxxx * float4(r3_x_17, r3_y_17, r3_z_15, r3_x_17));
                float r3_x_18 = r3_xyzw_18.x;
                float r3_y_18 = r3_xyzw_18.y;
                float r3_z_16 = r3_xyzw_18.z;
                float4 r0_xyzw_9 = mad(((r2_xyz_2.xyzx * _LightColor0.xyzx)).xxyz, r0_z_4.xxxx, float4(r3_x_18, r3_x_18, r3_y_18, r3_z_16));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + (mad(r2_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), ((((r0_y_8.xxxx * cb0_values[5].xyzx)).xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx)).xyzx);
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_9 = r0_xyzw_10.y;
                float r0_z_6 = r0_xyzw_10.z;
                float r0_w_6 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_7 = (-r0_w_6 + 1);
                float r0_w_8 = (r0_w_7 * cb1_values[5].z);
                float r0_w_9 = max(r0_w_8, 0);
                float r0_w_10 = saturate(mad(r0_w_9, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_10, r0_y_9, r0_z_6, r0_x_10) * r0_w_10.xxxx)).xyz;
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
                float4 _RimColor;
                float _RimPower;
                float _Specular;
                float _Gloss;
                float _Wrap;
                float4 _MainTex_ST;
                float4 cb0_values[17];
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
            Texture2D _MainTex;
            Texture2D t1;
            Texture2D t2;
            Texture3D t3;
            Texture2D t4;
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
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program106Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
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
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * unity_MatrixVP[1])));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord5.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[16].xyxx, cb0_values[16].zwzz)).xy;
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
            program106Output frag(program106Input i)
            {
                program106Output o = (program106Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_2 = ((r4_xyzw_1.xyzx * cb0_values[13].xyzx)).xyz;
                float4 r5_xyzw_4 = (mad(cb0_values[11].xyzw, i.texcoord2.zzzz, mad(cb0_values[9].xyzw, i.texcoord2.xxxx, (i.texcoord2.yyyy * cb0_values[10].xyzw))) + cb0_values[12].xyzw);
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r1_w_3 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float3 r2_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_4 = mad(cb3_values[25].w, (-r1_w_3 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_3);
                float r1_w_5 = saturate(mad(r1_w_4, cb3_values[24].z, cb3_values[24].w));
                float r2_x_13;
                float r2_y_13;
                float r2_z_12;
                float r2_w_8;
                if ((cb6_values[0].x == 1))
                {
                    float4 r2_xyzw_4 = (i.texcoord2.yyyy * cb6_values[2].xxyz);
                    float r2_y_4 = r2_xyzw_4.y;
                    float r2_z_4 = r2_xyzw_4.z;
                    float r2_w_2 = r2_xyzw_4.w;
                    float4 r2_xyzw_5 = mad(cb6_values[1].xxyz, i.texcoord2.xxxx, float4(r2_y_4, r2_y_4, r2_z_4, r2_w_2));
                    float r2_y_5 = r2_xyzw_5.y;
                    float r2_z_5 = r2_xyzw_5.z;
                    float r2_w_3 = r2_xyzw_5.w;
                    float4 r2_xyzw_6 = mad(cb6_values[3].xxyz, i.texcoord2.zzzz, float4(r2_y_5, r2_y_5, r2_z_5, r2_w_3));
                    float r2_y_6 = r2_xyzw_6.y;
                    float r2_z_6 = r2_xyzw_6.z;
                    float r2_w_4 = r2_xyzw_6.w;
                    float4 r2_xyzw_7 = (float4(r2_y_6, r2_y_6, r2_z_6, r2_w_4) + cb6_values[4].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_5 = r2_xyzw_7.w;
                    float4 r2_xyzw_9 = (((cb6_values[0].y == 1)).xxxx ? float4(r2_y_7, r2_z_7, r2_w_5, r2_y_7) : i.texcoord2.xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_8 = r2_xyzw_9.y;
                    float r2_z_8 = r2_xyzw_9.z;
                    float4 r2_xyzw_10 = (float4(r2_x_9, r2_y_8, r2_z_8, r2_x_9) + -cb6_values[6].xyzx);
                    float r2_x_10 = r2_xyzw_10.x;
                    float r2_y_9 = r2_xyzw_10.y;
                    float r2_z_9 = r2_xyzw_10.z;
                    float r2_y_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).y;
                    float r2_z_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).z;
                    float r2_w_6 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).w;
                    float r2_y_11 = mad(r2_y_10, 0.25, 0.75);
                    float r3_w_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r2_x_11 = max(r2_y_11, r3_w_1);
                    float4 r2_xyzw_12 = t3.Sample(sampler_linear_clamp, (float4(r2_x_11, r2_z_10, r2_w_6, r2_x_11)).xyz);
                    r2_x_13 = r2_xyzw_12.x;
                    r2_y_13 = r2_xyzw_12.y;
                    r2_z_12 = r2_xyzw_12.z;
                    r2_w_8 = r2_xyzw_12.w;
                }
                else
                {
                    float r2_x_7 = (float4(1, 1, 1, 1)).x;
                    float4 r2_xyzw_3 = float4(1, 1, 1, 1);
                    float r2_y_3 = r2_xyzw_3.y;
                    float r2_z_3 = r2_xyzw_3.z;
                    float r2_w_1 = r2_xyzw_3.w;
                    r2_x_13 = r2_x_7;
                    r2_y_13 = r2_y_3;
                    r2_z_12 = r2_z_3;
                    r2_w_8 = r2_w_1;
                }
                float r2_y_14 = (r1_w_5 < 0.99);
                float r2_y_27;
                if (r2_y_14)
                {
                    float4 r6_xyzw_2 = (i.texcoord2.yyyy * cb3_values[9].xyzw);
                    float4 r6_xyzw_3 = mad(cb3_values[8].xyzw, i.texcoord2.xxxx, r6_xyzw_2);
                    float4 r6_xyzw_4 = mad(cb3_values[10].xyzw, i.texcoord2.zzzz, r6_xyzw_3);
                    float4 r6_xyzw_5 = (r6_xyzw_4 + cb3_values[11].xyzw);
                    float4 r2_xyzw_16 = (r6_xyzw_5.xxyz / r6_xyzw_5.wwww);
                    float r2_y_16 = r2_xyzw_16.y;
                    float r2_z_13 = r2_xyzw_16.z;
                    float r2_w_9 = r2_xyzw_16.w;
                    float2 r6_xy_7 = (floor((mad(float4(r2_y_16, r2_z_13, r2_y_16, r2_y_16), cb0_values[8].zwzz, float4(0.5, 0.5, 0, 0))).xyxx)).xy;
                    float4 r2_xyzw_17 = mad(float4(r2_y_16, r2_y_16, r2_z_13, r2_y_16), cb0_values[8].zzwz, -r6_xy_7.xxyx);
                    float r2_y_17 = r2_xyzw_17.y;
                    float r2_z_14 = r2_xyzw_17.z;
                    float4 r7_xyzw_1 = (float4(r2_y_17, r2_y_17, r2_z_14, r2_z_14) + float4(0.5, 1, 0.5, 1));
                    float2 r8_xw_1 = ((r7_xyzw_1.xxxz * r7_xyzw_1.xxxz)).xw;
                    float4 r6_xyzw_6 = mad(r8_xw_1.xxxy, float4(0, 0, 0.5, 0.5), -float4(r2_y_17, r2_y_17, r2_y_17, r2_z_14));
                    float r6_z_6 = r6_xyzw_6.z;
                    float r6_w_5 = r6_xyzw_6.w;
                    float2 r7_xz_2 = ((-float4(r2_y_17, r2_y_17, r2_z_14, r2_y_17) + float4(1, 0, 1, 0))).xz;
                    float2 r9_xy_1 = (min(float4(r2_y_17, r2_z_14, r2_y_17, r2_y_17), float4(0, 0, 0, 0))).xy;
                    float2 r7_xz_3 = (mad(-r9_xy_1.xxyx, r9_xy_1.xxyx, r7_xz_2.xxyx)).xz;
                    float4 r2_xyzw_18 = max(float4(r2_y_17, r2_y_17, r2_z_14, r2_y_17), float4(0, 0, 0, 0));
                    float r2_y_18 = r2_xyzw_18.y;
                    float r2_z_15 = r2_xyzw_18.z;
                    float4 r2_xyzw_19 = mad(-float4(r2_y_18, r2_y_18, r2_z_15, r2_y_18), float4(r2_y_18, r2_y_18, r2_z_15, r2_y_18), r7_xyzw_1.yywy);
                    float r2_y_19 = r2_xyzw_19.y;
                    float r2_z_16 = r2_xyzw_19.z;
                    float r9_x_2 = r6_z_6;
                    float r9_y_2 = r7_xz_3.x;
                    float r9_z_1 = r2_y_19;
                    float r9_w_1 = r8_xw_1.x;
                    float4 r9_xyzw_3 = (float4(r9_x_2, r9_y_2, r9_z_1, r9_w_1) * float4(0.44444, 0.44444, 0.44444, 0.22222));
                    float r8_x_2 = r6_w_5;
                    float r8_y_1 = r7_xz_3.y;
                    float r8_z_1 = r2_z_16;
                    float4 r7_xyzw_4 = (float4(r8_x_2, r8_y_1, r8_z_1, r8_xw_1.y) * float4(0.44444, 0.44444, 0.44444, 0.22222));
                    float4 r8_xyzw_3 = (r9_xyzw_3.ywyw + r9_xyzw_3.xzxz);
                    float4 r10_xyzw_1 = (r7_xyzw_4.yyww + r7_xyzw_4.xxzz);
                    float4 r2_xyzw_20 = (r9_xyzw_3.yywy / r8_xyzw_3.zzwz);
                    float r2_y_20 = r2_xyzw_20.y;
                    float r2_z_17 = r2_xyzw_20.z;
                    float4 r2_xyzw_21 = (float4(r2_y_20, r2_y_20, r2_z_17, r2_y_20) + float4(0, -1.5, 0.5, 0));
                    float r2_y_21 = r2_xyzw_21.y;
                    float r2_z_18 = r2_xyzw_21.z;
                    float4 r6_xyzw_7 = (r7_xyzw_4.yyyw / r10_xyzw_1.yyyw);
                    float r6_z_7 = r6_xyzw_7.z;
                    float r6_w_6 = r6_xyzw_7.w;
                    float4 r6_xyzw_8 = (float4(r6_z_7, r6_z_7, r6_z_7, r6_w_6) + float4(0, 0, -1.5, 0.5));
                    float r6_z_8 = r6_xyzw_8.z;
                    float r6_w_7 = r6_xyzw_8.w;
                    float4 r7_xyzw_5 = (float4(r2_y_21, r2_z_18, r2_y_21, r2_y_21) * cb0_values[8].xxxx);
                    float r7_x_5 = r7_xyzw_5.x;
                    float r7_y_3 = r7_xyzw_5.y;
                    float r7_z_5 = ((float4(r6_z_8, r6_z_8, r6_z_8, r6_w_7) * cb0_values[8].yyyy)).z;
                    float r7_w_3 = ((float4(r6_z_8, r6_z_8, r6_z_8, r6_w_7) * cb0_values[8].yyyy)).w;
                    float4 r8_xyzw_4 = (r8_xyzw_3 * r10_xyzw_1);
                    float4 r9_xyzw_4 = mad(r6_xy_7.xyxy, cb0_values[8].xyxy, float4(r7_x_5, r7_z_5, r7_y_3, r7_z_5));
                    float r2_y_22 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r9_xyzw_4.xyxx).xy, r2_w_9);
                    float r2_z_19 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r9_xyzw_4.zwzz).xy, r2_w_9);
                    float r2_z_20 = (r2_z_19 * r8_xyzw_4.y);
                    float r2_y_23 = mad(r8_xyzw_4.x, r2_y_22, r2_z_20);
                    float r6_x_8 = (mad(r6_xy_7.xyxy, cb0_values[8].xyxy, float4(r7_x_5, r7_w_3, r7_y_3, r7_w_3))).x;
                    float r6_y_8 = (mad(r6_xy_7.xyxy, cb0_values[8].xyxy, float4(r7_x_5, r7_w_3, r7_y_3, r7_w_3))).y;
                    float4 r6_xyzw_9 = mad(r6_xy_7.xyxy, cb0_values[8].xyxy, float4(r7_x_5, r7_w_3, r7_y_3, r7_w_3));
                    float r6_z_9 = r6_xyzw_9.z;
                    float r6_w_8 = r6_xyzw_9.w;
                    float r2_z_21 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r6_x_8, r6_y_8, r6_x_8, r6_x_8)).xy, r2_w_9);
                    float r2_y_24 = mad(r8_xyzw_4.z, r2_z_21, r2_y_23);
                    float r2_z_22 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r6_z_9, r6_w_8, r6_z_9, r6_z_9)).xy, r2_w_9);
                    float r2_y_25 = mad(r8_xyzw_4.w, r2_z_22, r2_y_24);
                    float r2_z_23 = (-cb3_values[24].x + 1);
                    float r2_y_26 = mad(r2_y_25, r2_z_23, cb3_values[24].x);
                    r2_y_27 = r2_y_26;
                }
                else
                {
                    float r2_y_15 = 1;
                    r2_y_27 = r2_y_15;
                }
                float r1_w_6 = mad(r1_w_5, (-r2_y_27 + saturate(dot(float4(r2_x_13, r2_y_13, r2_z_12, r2_w_8), unity_OcclusionMaskSelector))), r2_y_27);
                float4 r2_xyzw_28 = (r5_xyzw_4.xxyx / r5_xyzw_4.wwww);
                float r2_y_28 = r2_xyzw_28.y;
                float r2_z_25 = r2_xyzw_28.z;
                float4 r2_xyzw_29 = (float4(r2_y_28, r2_y_28, r2_z_25, r2_y_28) + float4(0, 0.5, 0.5, 0));
                float r2_y_29 = r2_xyzw_29.y;
                float r2_z_26 = r2_xyzw_29.z;
                float4 r6_xyzw_10 = t1.Sample(sampler_linear_clamp2, (float4(r2_y_29, r2_z_26, r2_y_29, r2_y_29)).xy);
                float r2_y_30 = dot(r5_xyzw_4.xyzx, r5_xyzw_4.xyzx);
                float4 r5_xyzw_5 = t2.Sample(sampler_linear_clamp3, (r2_y_30.xxxx).xy);
                float r1_w_7 = (r1_w_6 * ((asfloat(asint((float)((0 < r5_xyzw_4.z))) & asint(1065353216)) * r6_xyzw_10.w) * r5_xyzw_5.x));
                float r1_y_2 = (cb0_values[15].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_1.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * cb0_values[15].x);
                float r0_y_8 = exp2(r0_y_7);
                float r2_x_20 = ((r4_xyz_2.xyzx * _LightColor0.xyzx)).x;
                float4 r2_xyzw_31 = (r4_xyz_2.xyzx * _LightColor0.xyzx);
                float r2_y_31 = r2_xyzw_31.y;
                float r2_z_27 = r2_xyzw_31.z;
                float r0_z_4 = (r1_w_7 * saturate(((dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx) + cb0_values[15].w) / r1_y_2)));
                                float4 r1_xyzw_5 = (((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * cb0_values[15].y)).xxxx * _LightColor0.xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_3 = r1_xyzw_5.y;
                float r1_z_2 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = (float4(r1_x_5, r1_y_3, r1_z_2, r1_x_5) * cb0_values[15].zzzz);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                float4 r1_xyzw_7 = (r1_w_7.xxxx * float4(r1_x_6, r1_y_4, r1_z_3, r1_x_6));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_5 = r1_xyzw_7.y;
                float r1_z_4 = r1_xyzw_7.z;
                float4 r0_xyzw_9 = mad(float4(r2_x_20, r2_x_20, r2_y_31, r2_z_27), r0_z_4.xxxx, float4(r1_x_7, r1_x_7, r1_y_5, r1_z_4));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                float4 r1_xyzw_8 = (r0_y_8.xxxx * cb0_values[14].xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_z_5 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = (float4(r1_x_8, r1_y_6, r1_z_5, r1_x_8) * float4(0.1, 0.1, 0.1, 0));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_7 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r1_xyzw_10 = mad(r4_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r1_x_9, r1_y_7, r1_z_6, r1_x_9));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_8 = r1_xyzw_10.y;
                float r1_z_7 = r1_xyzw_10.z;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + float4(r1_x_10, r1_y_8, r1_z_7, r1_x_10));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_9 = r0_xyzw_10.y;
                float r0_z_6 = r0_xyzw_10.z;
                float r0_w_6 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_7 = (-r0_w_6 + 1);
                float r0_w_8 = (r0_w_7 * cb1_values[5].z);
                float r0_w_9 = max(r0_w_8, 0);
                float r0_w_10 = saturate(mad(r0_w_9, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_10, r0_y_9, r0_z_6, r0_x_10) * r0_w_10.xxxx)).xyz;
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
                float4 _RimColor;
                float _RimPower;
                float _Specular;
                float _Gloss;
                float _Wrap;
                float4 _MainTex_ST;
                float4 cb0_values[12];
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
            Texture2D _MainTex;
            Texture2D t1;
            Texture2D t2;
            Texture3D t3;
            Texture2D t4;
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
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program105Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
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
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * unity_MatrixVP[1])));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord5.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float4 clipPos_xyzw_4 = (worldPos_xyzw_4.yyyy * _RimColor);
                float4 clipPos_xyzw_5 = mad(_Color, worldPos_xyzw_4.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb0_values[6].xyzw, worldPos_xyzw_4.zzzz, clipPos_xyzw_5);
                o.texcoord3.xyzw = mad(_MainTex_ST, worldPos_xyzw_4.wwww, clipPos_xyzw_6);
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
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_2 = ((r4_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float4 r5_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord2.zzzz, mad(cb0_values[4].xyzw, i.texcoord2.xxxx, (i.texcoord2.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r1_w_3 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float3 r2_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_4 = mad(cb3_values[25].w, (-r1_w_3 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_3);
                float r1_w_5 = saturate(mad(r1_w_4, cb3_values[24].z, cb3_values[24].w));
                float r2_x_13;
                float r2_y_13;
                float r2_z_12;
                float r2_w_8;
                if ((cb6_values[0].x == 1))
                {
                    float4 r2_xyzw_4 = (i.texcoord2.yyyy * cb6_values[2].xxyz);
                    float r2_y_4 = r2_xyzw_4.y;
                    float r2_z_4 = r2_xyzw_4.z;
                    float r2_w_2 = r2_xyzw_4.w;
                    float4 r2_xyzw_5 = mad(cb6_values[1].xxyz, i.texcoord2.xxxx, float4(r2_y_4, r2_y_4, r2_z_4, r2_w_2));
                    float r2_y_5 = r2_xyzw_5.y;
                    float r2_z_5 = r2_xyzw_5.z;
                    float r2_w_3 = r2_xyzw_5.w;
                    float4 r2_xyzw_6 = mad(cb6_values[3].xxyz, i.texcoord2.zzzz, float4(r2_y_5, r2_y_5, r2_z_5, r2_w_3));
                    float r2_y_6 = r2_xyzw_6.y;
                    float r2_z_6 = r2_xyzw_6.z;
                    float r2_w_4 = r2_xyzw_6.w;
                    float4 r2_xyzw_7 = (float4(r2_y_6, r2_y_6, r2_z_6, r2_w_4) + cb6_values[4].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_5 = r2_xyzw_7.w;
                    float4 r2_xyzw_9 = (((cb6_values[0].y == 1)).xxxx ? float4(r2_y_7, r2_z_7, r2_w_5, r2_y_7) : i.texcoord2.xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_8 = r2_xyzw_9.y;
                    float r2_z_8 = r2_xyzw_9.z;
                    float4 r2_xyzw_10 = (float4(r2_x_9, r2_y_8, r2_z_8, r2_x_9) + -cb6_values[6].xyzx);
                    float r2_x_10 = r2_xyzw_10.x;
                    float r2_y_9 = r2_xyzw_10.y;
                    float r2_z_9 = r2_xyzw_10.z;
                    float r2_y_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).y;
                    float r2_z_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).z;
                    float r2_w_6 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb6_values[5].xxyz)).w;
                    float r2_y_11 = mad(r2_y_10, 0.25, 0.75);
                    float r3_w_1 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r2_x_11 = max(r2_y_11, r3_w_1);
                    float4 r2_xyzw_12 = t3.Sample(sampler_linear_clamp, (float4(r2_x_11, r2_z_10, r2_w_6, r2_x_11)).xyz);
                    r2_x_13 = r2_xyzw_12.x;
                    r2_y_13 = r2_xyzw_12.y;
                    r2_z_12 = r2_xyzw_12.z;
                    r2_w_8 = r2_xyzw_12.w;
                }
                else
                {
                    float r2_x_7 = (float4(1, 1, 1, 1)).x;
                    float4 r2_xyzw_3 = float4(1, 1, 1, 1);
                    float r2_y_3 = r2_xyzw_3.y;
                    float r2_z_3 = r2_xyzw_3.z;
                    float r2_w_1 = r2_xyzw_3.w;
                    r2_x_13 = r2_x_7;
                    r2_y_13 = r2_y_3;
                    r2_z_12 = r2_z_3;
                    r2_w_8 = r2_w_1;
                }
                float4 r6_xyzw_2 = (i.texcoord2.yyyy * cb3_values[9].xyzw);
                float4 r6_xyzw_3 = mad(cb3_values[8].xyzw, i.texcoord2.xxxx, r6_xyzw_2);
                float4 r6_xyzw_4 = mad(cb3_values[10].xyzw, i.texcoord2.zzzz, r6_xyzw_3);
                float4 r6_xyzw_5 = (r6_xyzw_4 + cb3_values[11].xyzw);
                float4 r2_xyzw_14 = (r6_xyzw_5.xxyz / r6_xyzw_5.wwww);
                float r2_y_14 = r2_xyzw_14.y;
                float r2_z_13 = r2_xyzw_14.z;
                float r2_w_9 = r2_xyzw_14.w;
                float r2_y_15 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r2_y_14, r2_z_13, r2_y_14, r2_y_14)).xy, r2_w_9);
                float r2_z_14 = (-cb3_values[24].x + 1);
                float r2_y_16 = mad(r2_y_15, r2_z_14, cb3_values[24].x);
                float r1_w_6 = mad(r1_w_5, (-r2_y_16 + saturate(dot(float4(r2_x_13, r2_y_13, r2_z_12, r2_w_8), unity_OcclusionMaskSelector))), r2_y_16);
                float4 r2_xyzw_17 = (r5_xyzw_4.xxyx / r5_xyzw_4.wwww);
                float r2_y_17 = r2_xyzw_17.y;
                float r2_z_15 = r2_xyzw_17.z;
                float4 r2_xyzw_18 = (float4(r2_y_17, r2_y_17, r2_z_15, r2_y_17) + float4(0, 0.5, 0.5, 0));
                float r2_y_18 = r2_xyzw_18.y;
                float r2_z_16 = r2_xyzw_18.z;
                float4 r6_xyzw_6 = t1.Sample(sampler_linear_clamp2, (float4(r2_y_18, r2_z_16, r2_y_18, r2_y_18)).xy);
                float r2_y_19 = dot(r5_xyzw_4.xyzx, r5_xyzw_4.xyzx);
                float4 r5_xyzw_5 = t2.Sample(sampler_linear_clamp3, (r2_y_19.xxxx).xy);
                float r1_w_7 = (r1_w_6 * ((asfloat(asint((float)((0 < r5_xyzw_4.z))) & asint(1065353216)) * r6_xyzw_6.w) * r5_xyzw_5.x));
                float r1_y_2 = (cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_1.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * cb0_values[10].x);
                float r0_y_8 = exp2(r0_y_7);
                float4 r2_xyzw_20 = (r4_xyz_2.xyzx * _LightColor0.xyzx);
                float r2_x_20 = r2_xyzw_20.x;
                float r2_y_20 = r2_xyzw_20.y;
                float r2_z_17 = r2_xyzw_20.z;
                float r0_z_4 = (r1_w_7 * saturate(((dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx) + cb0_values[10].w) / r1_y_2)));
                                float4 r1_xyzw_5 = (((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * cb0_values[10].y)).xxxx * _LightColor0.xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_3 = r1_xyzw_5.y;
                float r1_z_2 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = (float4(r1_x_5, r1_y_3, r1_z_2, r1_x_5) * cb0_values[10].zzzz);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                float4 r1_xyzw_7 = (r1_w_7.xxxx * float4(r1_x_6, r1_y_4, r1_z_3, r1_x_6));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_5 = r1_xyzw_7.y;
                float r1_z_4 = r1_xyzw_7.z;
                float4 r0_xyzw_9 = mad(float4(r2_x_20, r2_x_20, r2_y_20, r2_z_17), r0_z_4.xxxx, float4(r1_x_7, r1_x_7, r1_y_5, r1_z_4));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                float4 r1_xyzw_8 = (r0_y_8.xxxx * cb0_values[9].xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_z_5 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = (float4(r1_x_8, r1_y_6, r1_z_5, r1_x_8) * float4(0.1, 0.1, 0.1, 0));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_7 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r1_xyzw_10 = mad(r4_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r1_x_9, r1_y_7, r1_z_6, r1_x_9));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_8 = r1_xyzw_10.y;
                float r1_z_7 = r1_xyzw_10.z;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + float4(r1_x_10, r1_y_8, r1_z_7, r1_x_10));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_9 = r0_xyzw_10.y;
                float r0_z_6 = r0_xyzw_10.z;
                float r0_w_6 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_7 = (-r0_w_6 + 1);
                float r0_w_8 = (r0_w_7 * cb1_values[5].z);
                float r0_w_9 = max(r0_w_8, 0);
                float r0_w_10 = saturate(mad(r0_w_9, cb5_values[1].z, cb5_values[1].w));
                o.sv_Target0.xyz = ((float4(r0_x_10, r0_y_9, r0_z_6, r0_x_10) * r0_w_10.xxxx)).xyz;
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
                float4 _RimColor;
                float _RimPower;
                float _Specular;
                float _Gloss;
                float _Wrap;
                float4 _MainTex_ST;
                float4 cb0_values[12];
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
            Texture2D _MainTex;
            Texture2D t1;
            Texture3D t2;
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
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program104Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
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
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord5.x = clipPos_xyzw_2.z;
                worldPos_xyzw_3 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float2 clipPos_xy_4 = ((worldPos_xyzw_3.yyyy * _RimColor.xyxx)).xy;
                float2 clipPos_xy_5 = (mad(_Color.xyxx, worldPos_xyzw_3.xxxx, clipPos_xy_4.xyxx)).xy;
                float2 clipPos_xy_6 = (mad(cb0_values[6].xyxx, worldPos_xyzw_3.zzzz, clipPos_xy_5.xyxx)).xy;
                o.texcoord3.xy = (mad(_MainTex_ST.xxxy, worldPos_xyzw_3.wwww, clipPos_xy_6.xxxy)).zw;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_4 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7));
                float r0_w_5 = rsqrt(r0_w_4);
                o.texcoord1.xyz = ((r0_w_5.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7))).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program104Output frag(program104Input i)
            {
                program104Output o = (program104Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_2 = ((r2_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float r1_w_1 = (cb4_values[0].x == 1);
                float r4_x_10;
                float r4_y_10;
                float r4_z_10;
                float r4_w_4;
                if (r1_w_1)
                {
                    float r1_w_2 = (cb4_values[0].y == 1);
                    float3 r4_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord2.zzzz, (mad(cb4_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r4_xyzw_8 = (((((r1_w_2.xxxx ? r4_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r4_y_8 = r4_xyzw_8.y;
                    float r4_z_8 = r4_xyzw_8.z;
                    float r4_w_2 = r4_xyzw_8.w;
                    float r1_w_3 = mad(r4_y_8, 0.25, 0.75);
                    float r2_w_2 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r4_x_8 = max(r1_w_3, r2_w_2);
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
                float r1_w_5 = saturate(dot(float4(r4_x_10, r4_y_10, r4_z_10, r4_w_4), unity_OcclusionMaskSelector));
                float4 r3_xyzw_5 = t1.Sample(sampler_linear_clamp1, ((((mad(cb0_values[6].xyxx, i.texcoord2.zzzz, (mad(cb0_values[4].xyxx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx).xy);
                float r1_w_6 = (r1_w_5 * r3_xyzw_5.w);
                float r2_w_4 = dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx);
                float r2_w_5 = (r2_w_4 + cb0_values[10].w);
                float r2_w_6 = saturate((r2_w_5 / (cb0_values[10].w + 1)));
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_1.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * cb0_values[10].x);
                float r0_y_8 = exp2(r0_y_7);
                float r0_z_4 = (r1_w_6 * r2_w_6);
                                float4 r3_xyzw_7 = (((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * cb0_values[10].y)).xxxx * _LightColor0.xyzx);
                float r3_x_7 = r3_xyzw_7.x;
                float r3_y_6 = r3_xyzw_7.y;
                float r3_z_2 = r3_xyzw_7.z;
                float4 r3_xyzw_8 = (float4(r3_x_7, r3_y_6, r3_z_2, r3_x_7) * cb0_values[10].zzzz);
                float r3_x_8 = r3_xyzw_8.x;
                float r3_y_7 = r3_xyzw_8.y;
                float r3_z_3 = r3_xyzw_8.z;
                float4 r3_xyzw_9 = (r1_w_6.xxxx * float4(r3_x_8, r3_y_7, r3_z_3, r3_x_8));
                float r3_x_9 = r3_xyzw_9.x;
                float r3_y_8 = r3_xyzw_9.y;
                float r3_z_4 = r3_xyzw_9.z;
                float4 r0_xyzw_9 = mad(((r2_xyz_2.xyzx * _LightColor0.xyzx)).xxyz, r0_z_4.xxxx, float4(r3_x_9, r3_x_9, r3_y_8, r3_z_4));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + (mad(r2_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), ((((r0_y_8.xxxx * cb0_values[9].xyzx)).xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx)).xyzx);
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_9 = r0_xyzw_10.y;
                float r0_z_6 = r0_xyzw_10.z;
                float r0_w_6 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_7 = (-r0_w_6 + 1);
                float r0_w_8 = (r0_w_7 * cb1_values[5].z);
                float r0_w_9 = max(r0_w_8, 0);
                float r0_w_10 = saturate(mad(r0_w_9, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w));
                o.sv_Target0.xyz = ((float4(r0_x_10, r0_y_9, r0_z_6, r0_x_10) * r0_w_10.xxxx)).xyz;
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
                float4 _RimColor;
                float _RimPower;
                float _Specular;
                float _Gloss;
                float _Wrap;
                float4 _MainTex_ST;
                float4 cb0_values[12];
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
            Texture2D _MainTex;
            Texture2D t1;
            TextureCube t2;
            Texture3D t3;
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
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program103Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
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
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord5.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_4 = ((worldPos_xyzw_4.yyyy * _RimColor.xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(cb0_values[6].xyzx, worldPos_xyzw_4.zzzz, (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_4.xyzx)).xyzx)).xyz;
                o.texcoord3.xyz = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program103Output frag(program103Input i)
            {
                program103Output o = (program103Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_2 = normalize(viewDir_xyz_1);
                float4 r3_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r3_xyz_2 = ((r3_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float3 r4_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
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
                    float r2_w_1 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r5_x_8 = max(r1_w_5, r2_w_1);
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
                float r2_w_3 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float4 r5_xyzw_11 = t1.Sample(sampler_linear_clamp2, (r2_w_3.xxxx).xy);
                float4 r4_xyzw_5 = t2.Sample(sampler_linear_clamp1, r4_xyz_4.xyz);
                float r2_w_4 = (r4_xyzw_5.w * r5_xyzw_11.x);
                float r1_w_8 = (r1_w_7 * r2_w_4);
                float r1_y_2 = (cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_2.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_2.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * cb0_values[10].x);
                float r0_y_8 = exp2(r0_y_7);
                float r0_z_4 = (r1_w_8 * saturate(((dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx) + cb0_values[10].w) / r1_y_2)));
                                float4 r1_xyzw_5 = (((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * cb0_values[10].y)).xxxx * _LightColor0.xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_3 = r1_xyzw_5.y;
                float r1_z_2 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = (float4(r1_x_5, r1_y_3, r1_z_2, r1_x_5) * cb0_values[10].zzzz);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                float4 r1_xyzw_7 = (r1_w_8.xxxx * float4(r1_x_6, r1_y_4, r1_z_3, r1_x_6));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_5 = r1_xyzw_7.y;
                float r1_z_4 = r1_xyzw_7.z;
                float4 r0_xyzw_9 = mad(((r3_xyz_2.xyzx * _LightColor0.xyzx)).xxyz, r0_z_4.xxxx, float4(r1_x_7, r1_x_7, r1_y_5, r1_z_4));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                float4 r1_xyzw_8 = (r0_y_8.xxxx * cb0_values[9].xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_z_5 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = (float4(r1_x_8, r1_y_6, r1_z_5, r1_x_8) * float4(0.1, 0.1, 0.1, 0));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_7 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r1_xyzw_10 = mad(r3_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r1_x_9, r1_y_7, r1_z_6, r1_x_9));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_8 = r1_xyzw_10.y;
                float r1_z_7 = r1_xyzw_10.z;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + float4(r1_x_10, r1_y_8, r1_z_7, r1_x_10));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_9 = r0_xyzw_10.y;
                float r0_z_6 = r0_xyzw_10.z;
                float r0_w_6 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_7 = (-r0_w_6 + 1);
                float r0_w_8 = (r0_w_7 * cb1_values[5].z);
                float r0_w_9 = max(r0_w_8, 0);
                float r0_w_10 = saturate(mad(r0_w_9, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w));
                o.sv_Target0.xyz = ((float4(r0_x_10, r0_y_9, r0_z_6, r0_x_10) * r0_w_10.xxxx)).xyz;
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
                float4 _RimColor;
                float _RimPower;
                float _Specular;
                float _Gloss;
                float _Wrap;
                float4 _MainTex_ST;
                float4 cb0_values[12];
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
            Texture2D _MainTex;
            Texture2D t1;
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
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program102Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
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
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * unity_MatrixVP[1])));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord5.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float4 clipPos_xyzw_4 = (worldPos_xyzw_4.yyyy * _RimColor);
                float4 clipPos_xyzw_5 = mad(_Color, worldPos_xyzw_4.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb0_values[6].xyzw, worldPos_xyzw_4.zzzz, clipPos_xyzw_5);
                o.texcoord3.xyzw = mad(_MainTex_ST, worldPos_xyzw_4.wwww, clipPos_xyzw_6);
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
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_2 = normalize(viewDir_xyz_1);
                float4 r3_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r3_xyz_2 = ((r3_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float4 r4_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord2.zzzz, mad(cb0_values[4].xyzw, i.texcoord2.xxxx, (i.texcoord2.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
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
                    float r2_w_1 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r5_x_8 = max(r1_w_5, r2_w_1);
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
                float r2_w_3 = (0 < r4_xyzw_4.z);
                float r2_w_4 = asfloat(asint(r2_w_3) & asint(1065353216));
                float4 r5_xyzw_13 = t1.Sample(sampler_linear_clamp1, (((((r4_xyzw_4.xyxx / r4_xyzw_4.wwww)).xyxx + float4(0.5, 0.5, 0, 0))).xyxx).xy);
                float r2_w_5 = (r2_w_4 * r5_xyzw_13.w);
                float r3_w_2 = dot(r4_xyzw_4.xyzx, r4_xyzw_4.xyzx);
                float4 r4_xyzw_5 = t2.Sample(sampler_linear_clamp2, (r3_w_2.xxxx).xy);
                float r2_w_6 = (r2_w_5 * r4_xyzw_5.x);
                float r1_w_8 = (r1_w_7 * r2_w_6);
                float r1_y_2 = (cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_2.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_2.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * cb0_values[10].x);
                float r0_y_8 = exp2(r0_y_7);
                float r0_z_4 = (r1_w_8 * saturate(((dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx) + cb0_values[10].w) / r1_y_2)));
                                float4 r1_xyzw_5 = (((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * cb0_values[10].y)).xxxx * _LightColor0.xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_3 = r1_xyzw_5.y;
                float r1_z_2 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = (float4(r1_x_5, r1_y_3, r1_z_2, r1_x_5) * cb0_values[10].zzzz);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                float4 r1_xyzw_7 = (r1_w_8.xxxx * float4(r1_x_6, r1_y_4, r1_z_3, r1_x_6));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_5 = r1_xyzw_7.y;
                float r1_z_4 = r1_xyzw_7.z;
                float4 r0_xyzw_9 = mad(((r3_xyz_2.xyzx * _LightColor0.xyzx)).xxyz, r0_z_4.xxxx, float4(r1_x_7, r1_x_7, r1_y_5, r1_z_4));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                float4 r1_xyzw_8 = (r0_y_8.xxxx * cb0_values[9].xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_z_5 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = (float4(r1_x_8, r1_y_6, r1_z_5, r1_x_8) * float4(0.1, 0.1, 0.1, 0));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_7 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r1_xyzw_10 = mad(r3_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r1_x_9, r1_y_7, r1_z_6, r1_x_9));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_8 = r1_xyzw_10.y;
                float r1_z_7 = r1_xyzw_10.z;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + float4(r1_x_10, r1_y_8, r1_z_7, r1_x_10));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_9 = r0_xyzw_10.y;
                float r0_z_6 = r0_xyzw_10.z;
                float r0_w_6 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_7 = (-r0_w_6 + 1);
                float r0_w_8 = (r0_w_7 * cb1_values[5].z);
                float r0_w_9 = max(r0_w_8, 0);
                float r0_w_10 = saturate(mad(r0_w_9, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w));
                o.sv_Target0.xyz = ((float4(r0_x_10, r0_y_9, r0_z_6, r0_x_10) * r0_w_10.xxxx)).xyz;
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
                float4 _RimColor;
                float _RimPower;
                float _Specular;
                float _Gloss;
                float _Wrap;
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
            Texture2D _MainTex;
            Texture3D t1;
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
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program101Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
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
            program101Output frag(program101Input i)
            {
                program101Output o = (program101Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_2 = ((r2_xyzw_1.xyzx * cb0_values[4].xyzx)).xyz;
                float r1_w_1 = (cb4_values[0].x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r1_w_1)
                {
                    float r1_w_2 = (cb4_values[0].y == 1);
                    float3 r3_xyz_5 = (((mad(cb4_values[3].xyzx, i.texcoord2.zzzz, (mad(cb4_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb4_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb4_values[4].xyzx)).xyz;
                    float4 r3_xyzw_8 = (((((r1_w_2.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb4_values[6].xyzx)).xxyz * cb4_values[5].xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r1_w_3 = mad(r3_y_8, 0.25, 0.75);
                    float r2_w_2 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r3_x_8 = max(r1_w_3, r2_w_2);
                    float4 r3_xyzw_9 = t1.Sample(sampler_linear_clamp, (float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8)).xyz);
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
                float r1_w_5 = saturate(dot(float4(r3_x_10, r3_y_10, r3_z_10, r3_w_4), unity_OcclusionMaskSelector));
                float r2_w_4 = dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx);
                float r2_w_5 = (r2_w_4 + cb0_values[6].w);
                float r2_w_6 = saturate((r2_w_5 / (cb0_values[6].w + 1)));
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_1.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * cb0_values[6].x);
                float r0_y_8 = exp2(r0_y_7);
                float r0_z_4 = (r1_w_5 * r2_w_6);
                                float4 r3_xyzw_12 = (((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * cb0_values[6].y)).xxxx * _LightColor0.xyzx);
                float r3_x_12 = r3_xyzw_12.x;
                float r3_y_11 = r3_xyzw_12.y;
                float r3_z_11 = r3_xyzw_12.z;
                float4 r3_xyzw_13 = (float4(r3_x_12, r3_y_11, r3_z_11, r3_x_12) * cb0_values[6].zzzz);
                float r3_x_13 = r3_xyzw_13.x;
                float r3_y_12 = r3_xyzw_13.y;
                float r3_z_12 = r3_xyzw_13.z;
                float4 r3_xyzw_14 = (r1_w_5.xxxx * float4(r3_x_13, r3_y_12, r3_z_12, r3_x_13));
                float r3_x_14 = r3_xyzw_14.x;
                float r3_y_13 = r3_xyzw_14.y;
                float r3_z_13 = r3_xyzw_14.z;
                float4 r0_xyzw_9 = mad(((r2_xyz_2.xyzx * _LightColor0.xyzx)).xxyz, r0_z_4.xxxx, float4(r3_x_14, r3_x_14, r3_y_13, r3_z_13));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + (mad(r2_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), ((((r0_y_8.xxxx * cb0_values[5].xyzx)).xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx)).xyzx);
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_9 = r0_xyzw_10.y;
                float r0_z_6 = r0_xyzw_10.z;
                float r0_w_6 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_7 = (-r0_w_6 + 1);
                float r0_w_8 = (r0_w_7 * cb1_values[5].z);
                float r0_w_9 = max(r0_w_8, 0);
                float r0_w_10 = saturate(mad(r0_w_9, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w));
                o.sv_Target0.xyz = ((float4(r0_x_10, r0_y_9, r0_z_6, r0_x_10) * r0_w_10.xxxx)).xyz;
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
                float4 _RimColor;
                float _RimPower;
                float _Specular;
                float _Gloss;
                float _Wrap;
                float4 _MainTex_ST;
                float4 cb0_values[12];
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
            Texture2D _MainTex;
            Texture2D t1;
            Texture3D t2;
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
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program100Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
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
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord5.x = clipPos_xyzw_2.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                float worldNormal_x_3 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_4 = ((worldPos_xyzw_4.yyyy * _RimColor.xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(cb0_values[6].xyzx, worldPos_xyzw_4.zzzz, (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_4.xyzx)).xyzx)).xyz;
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
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_2 = normalize(viewDir_xyz_1);
                float4 r3_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r3_xyz_2 = ((r3_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float3 r4_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
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
                    float r2_w_1 = mad(cb4_values[0].z, 0.5, 0.75);
                    float r5_x_8 = max(r1_w_5, r2_w_1);
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
                float r1_w_7 = saturate(dot(float4(r5_x_10, r5_y_10, r5_z_10, r5_w_4), unity_OcclusionMaskSelector));
                float r2_w_3 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float4 r4_xyzw_5 = t1.Sample(sampler_linear_clamp1, (r2_w_3.xxxx).xy);
                float r1_w_8 = (r1_w_7 * r4_xyzw_5.x);
                float r1_y_2 = (cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_2.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_2.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * cb0_values[10].x);
                float r0_y_8 = exp2(r0_y_7);
                float r0_z_4 = (r1_w_8 * saturate(((dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx) + cb0_values[10].w) / r1_y_2)));
                                float4 r1_xyzw_5 = (((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * cb0_values[10].y)).xxxx * _LightColor0.xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_3 = r1_xyzw_5.y;
                float r1_z_2 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = (float4(r1_x_5, r1_y_3, r1_z_2, r1_x_5) * cb0_values[10].zzzz);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                float4 r1_xyzw_7 = (r1_w_8.xxxx * float4(r1_x_6, r1_y_4, r1_z_3, r1_x_6));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_5 = r1_xyzw_7.y;
                float r1_z_4 = r1_xyzw_7.z;
                float4 r0_xyzw_9 = mad(((r3_xyz_2.xyzx * _LightColor0.xyzx)).xxyz, r0_z_4.xxxx, float4(r1_x_7, r1_x_7, r1_y_5, r1_z_4));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                float4 r1_xyzw_8 = (r0_y_8.xxxx * cb0_values[9].xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_z_5 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = (float4(r1_x_8, r1_y_6, r1_z_5, r1_x_8) * float4(0.1, 0.1, 0.1, 0));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_7 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r1_xyzw_10 = mad(r3_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r1_x_9, r1_y_7, r1_z_6, r1_x_9));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_8 = r1_xyzw_10.y;
                float r1_z_7 = r1_xyzw_10.z;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + float4(r1_x_10, r1_y_8, r1_z_7, r1_x_10));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_9 = r0_xyzw_10.y;
                float r0_z_6 = r0_xyzw_10.z;
                float r0_w_6 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_7 = (-r0_w_6 + 1);
                float r0_w_8 = (r0_w_7 * cb1_values[5].z);
                float r0_w_9 = max(r0_w_8, 0);
                float r0_w_10 = saturate(mad(r0_w_9, unity_ProbeVolumeWorldToObject[0].z, unity_ProbeVolumeWorldToObject[0].w));
                o.sv_Target0.xyz = ((float4(r0_x_10, r0_y_9, r0_z_6, r0_x_10) * r0_w_10.xxxx)).xyz;
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
                float4 _RimColor;
                float _RimPower;
                float _Specular;
                float _Gloss;
                float _Wrap;
                float4 _MainTex_ST;
                float4 cb0_values[12];
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
            Texture2D _MainTex;
            Texture2D t1;
            TextureCube t2;
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
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program99Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
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
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_3 = ((worldPos_xyzw_4.yyyy * _RimColor.xyzx)).xyz;
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
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_2 = ((r4_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float3 r5_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r1_w_3 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float3 r2_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_4 = mad(cb3_values[25].w, (-r1_w_3 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_3);
                float r1_w_5 = saturate(mad(r1_w_4, cb3_values[24].z, cb3_values[24].w));
                float r2_x_13;
                float r2_y_13;
                float r2_z_12;
                float r2_w_8;
                if ((cb5_values[0].x == 1))
                {
                    float4 r2_xyzw_4 = (i.texcoord2.yyyy * cb5_values[2].xxyz);
                    float r2_y_4 = r2_xyzw_4.y;
                    float r2_z_4 = r2_xyzw_4.z;
                    float r2_w_2 = r2_xyzw_4.w;
                    float4 r2_xyzw_5 = mad(cb5_values[1].xxyz, i.texcoord2.xxxx, float4(r2_y_4, r2_y_4, r2_z_4, r2_w_2));
                    float r2_y_5 = r2_xyzw_5.y;
                    float r2_z_5 = r2_xyzw_5.z;
                    float r2_w_3 = r2_xyzw_5.w;
                    float4 r2_xyzw_6 = mad(cb5_values[3].xxyz, i.texcoord2.zzzz, float4(r2_y_5, r2_y_5, r2_z_5, r2_w_3));
                    float r2_y_6 = r2_xyzw_6.y;
                    float r2_z_6 = r2_xyzw_6.z;
                    float r2_w_4 = r2_xyzw_6.w;
                    float4 r2_xyzw_7 = (float4(r2_y_6, r2_y_6, r2_z_6, r2_w_4) + cb5_values[4].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_5 = r2_xyzw_7.w;
                    float4 r2_xyzw_9 = (((cb5_values[0].y == 1)).xxxx ? float4(r2_y_7, r2_z_7, r2_w_5, r2_y_7) : i.texcoord2.xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_8 = r2_xyzw_9.y;
                    float r2_z_8 = r2_xyzw_9.z;
                    float4 r2_xyzw_10 = (float4(r2_x_9, r2_y_8, r2_z_8, r2_x_9) + -cb5_values[6].xyzx);
                    float r2_x_10 = r2_xyzw_10.x;
                    float r2_y_9 = r2_xyzw_10.y;
                    float r2_z_9 = r2_xyzw_10.z;
                    float r2_y_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).y;
                    float r2_z_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).z;
                    float r2_w_6 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).w;
                    float r2_y_11 = mad(r2_y_10, 0.25, 0.75);
                    float r3_w_1 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r2_x_11 = max(r2_y_11, r3_w_1);
                    float4 r2_xyzw_12 = t3.Sample(sampler_linear_clamp, (float4(r2_x_11, r2_z_10, r2_w_6, r2_x_11)).xyz);
                    r2_x_13 = r2_xyzw_12.x;
                    r2_y_13 = r2_xyzw_12.y;
                    r2_z_12 = r2_xyzw_12.z;
                    r2_w_8 = r2_xyzw_12.w;
                }
                else
                {
                    float r2_x_7 = (float4(1, 1, 1, 1)).x;
                    float4 r2_xyzw_3 = float4(1, 1, 1, 1);
                    float r2_y_3 = r2_xyzw_3.y;
                    float r2_z_3 = r2_xyzw_3.z;
                    float r2_w_1 = r2_xyzw_3.w;
                    r2_x_13 = r2_x_7;
                    r2_y_13 = r2_y_3;
                    r2_z_12 = r2_z_3;
                    r2_w_8 = r2_w_1;
                }
                float r2_y_14 = (r1_w_5 < 0.99);
                float r2_y_20;
                if (r2_y_14)
                {
                    float4 r2_xyzw_16 = (i.texcoord2.xxyz + -cb2_values[1].xxyz);
                    float r2_y_16 = r2_xyzw_16.y;
                    float r2_z_13 = r2_xyzw_16.z;
                    float r2_w_9 = r2_xyzw_16.w;
                    float r3_w_3 = max(abs(r2_z_13), abs(r2_y_16));
                    float r3_w_4 = max(abs(r2_w_9), r3_w_3);
                    float r3_w_5 = (r3_w_4 + -cb2_values[2].z);
                    float r3_w_6 = max(r3_w_5, 1E-05);
                    float r3_w_7 = (r3_w_6 * cb2_values[2].w);
                    float r3_w_8 = (cb2_values[2].y / r3_w_7);
                    float r3_w_9 = (r3_w_8 + -cb2_values[2].x);
                    float r3_w_10 = (-r3_w_9 + 1);
                    float r6_x_3 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((float4(r2_y_16, r2_z_13, r2_w_9, r2_y_16) + float4(0.0078125, 0.0078125, 0.0078125, 0))).xyzx).xyz, r3_w_10);
                    float r6_y_3 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((float4(r2_y_16, r2_z_13, r2_w_9, r2_y_16) + float4(-0.0078125, -0.0078125, 0.0078125, 0))).xyzx).xyz, r3_w_10);
                    float r6_z_3 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((float4(r2_y_16, r2_z_13, r2_w_9, r2_y_16) + float4(-0.0078125, 0.0078125, -0.0078125, 0))).xyzx).xyz, r3_w_10);
                    float4 r2_xyzw_17 = (float4(r2_y_16, r2_y_16, r2_z_13, r2_w_9) + float4(0, 0.0078125, -0.0078125, -0.0078125));
                    float r2_y_17 = r2_xyzw_17.y;
                    float r2_z_14 = r2_xyzw_17.z;
                    float r2_w_10 = r2_xyzw_17.w;
                    float r6_w_1 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r2_y_17, r2_z_14, r2_w_10, r2_y_17)).xyz, r3_w_10);
                    float r2_y_18 = dot(float4(r6_x_3, r6_y_3, r6_z_3, r6_w_1), float4(0.25, 0.25, 0.25, 0.25));
                    float r2_z_15 = (-cb3_values[24].x + 1);
                    float r2_y_19 = mad(r2_y_18, r2_z_15, cb3_values[24].x);
                    r2_y_20 = r2_y_19;
                }
                else
                {
                    float r2_y_15 = 1;
                    r2_y_20 = r2_y_15;
                }
                float r1_w_6 = mad(r1_w_5, (-r2_y_20 + saturate(dot(float4(r2_x_13, r2_y_13, r2_z_12, r2_w_8), unity_OcclusionMaskSelector))), r2_y_20);
                float r2_x_17 = (t1.Sample(sampler_linear_clamp3, ((dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx)).xxxx).xy)).x;
                float4 r2_xyzw_21 = t1.Sample(sampler_linear_clamp3, ((dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx)).xxxx).xy);
                float r2_y_21 = r2_xyzw_21.y;
                float r2_z_17 = r2_xyzw_21.z;
                float r2_w_12 = r2_xyzw_21.w;
                float4 r5_xyzw_5 = t2.Sample(sampler_linear_clamp2, r5_xyz_4.xyz);
                float r1_w_7 = (r1_w_6 * (r2_x_17 * r5_xyzw_5.w));
                float r1_y_2 = (cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_1.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * cb0_values[10].x);
                float r0_y_8 = exp2(r0_y_7);
                float4 r2_xyzw_19 = (r4_xyz_2.xyzx * _LightColor0.xyzx);
                float r2_x_19 = r2_xyzw_19.x;
                float r2_y_22 = r2_xyzw_19.y;
                float r2_z_18 = r2_xyzw_19.z;
                float r0_z_4 = (r1_w_7 * saturate(((dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx) + cb0_values[10].w) / r1_y_2)));
                                float4 r1_xyzw_5 = (((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * cb0_values[10].y)).xxxx * _LightColor0.xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_3 = r1_xyzw_5.y;
                float r1_z_2 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = (float4(r1_x_5, r1_y_3, r1_z_2, r1_x_5) * cb0_values[10].zzzz);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                float4 r1_xyzw_7 = (r1_w_7.xxxx * float4(r1_x_6, r1_y_4, r1_z_3, r1_x_6));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_5 = r1_xyzw_7.y;
                float r1_z_4 = r1_xyzw_7.z;
                float4 r0_xyzw_9 = mad(float4(r2_x_19, r2_x_19, r2_y_22, r2_z_18), r0_z_4.xxxx, float4(r1_x_7, r1_x_7, r1_y_5, r1_z_4));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                float4 r1_xyzw_8 = (r0_y_8.xxxx * cb0_values[9].xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_z_5 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = (float4(r1_x_8, r1_y_6, r1_z_5, r1_x_8) * float4(0.1, 0.1, 0.1, 0));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_7 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r1_xyzw_10 = mad(r4_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r1_x_9, r1_y_7, r1_z_6, r1_x_9));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_8 = r1_xyzw_10.y;
                float r1_z_7 = r1_xyzw_10.z;
                o.sv_Target0.xyz = ((float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + float4(r1_x_10, r1_y_8, r1_z_7, r1_x_10))).xyz;
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
                float4 _RimColor;
                float _RimPower;
                float _Specular;
                float _Gloss;
                float _Wrap;
                float4 _MainTex_ST;
                float4 cb0_values[12];
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
            Texture2D _MainTex;
            Texture2D t1;
            TextureCube t2;
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
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program98Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
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
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_3 = ((worldPos_xyzw_4.yyyy * _RimColor.xyzx)).xyz;
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
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_2 = ((r4_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float3 r5_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r1_w_3 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float3 r2_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_4 = mad(cb3_values[25].w, (-r1_w_3 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_3);
                float r1_w_5 = saturate(mad(r1_w_4, cb3_values[24].z, cb3_values[24].w));
                float r2_x_13;
                float r2_y_13;
                float r2_z_12;
                float r2_w_8;
                if ((cb5_values[0].x == 1))
                {
                    float4 r2_xyzw_4 = (i.texcoord2.yyyy * cb5_values[2].xxyz);
                    float r2_y_4 = r2_xyzw_4.y;
                    float r2_z_4 = r2_xyzw_4.z;
                    float r2_w_2 = r2_xyzw_4.w;
                    float4 r2_xyzw_5 = mad(cb5_values[1].xxyz, i.texcoord2.xxxx, float4(r2_y_4, r2_y_4, r2_z_4, r2_w_2));
                    float r2_y_5 = r2_xyzw_5.y;
                    float r2_z_5 = r2_xyzw_5.z;
                    float r2_w_3 = r2_xyzw_5.w;
                    float4 r2_xyzw_6 = mad(cb5_values[3].xxyz, i.texcoord2.zzzz, float4(r2_y_5, r2_y_5, r2_z_5, r2_w_3));
                    float r2_y_6 = r2_xyzw_6.y;
                    float r2_z_6 = r2_xyzw_6.z;
                    float r2_w_4 = r2_xyzw_6.w;
                    float4 r2_xyzw_7 = (float4(r2_y_6, r2_y_6, r2_z_6, r2_w_4) + cb5_values[4].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_5 = r2_xyzw_7.w;
                    float4 r2_xyzw_9 = (((cb5_values[0].y == 1)).xxxx ? float4(r2_y_7, r2_z_7, r2_w_5, r2_y_7) : i.texcoord2.xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_8 = r2_xyzw_9.y;
                    float r2_z_8 = r2_xyzw_9.z;
                    float4 r2_xyzw_10 = (float4(r2_x_9, r2_y_8, r2_z_8, r2_x_9) + -cb5_values[6].xyzx);
                    float r2_x_10 = r2_xyzw_10.x;
                    float r2_y_9 = r2_xyzw_10.y;
                    float r2_z_9 = r2_xyzw_10.z;
                    float r2_y_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).y;
                    float r2_z_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).z;
                    float r2_w_6 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).w;
                    float r2_y_11 = mad(r2_y_10, 0.25, 0.75);
                    float r3_w_1 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r2_x_11 = max(r2_y_11, r3_w_1);
                    float4 r2_xyzw_12 = t3.Sample(sampler_linear_clamp, (float4(r2_x_11, r2_z_10, r2_w_6, r2_x_11)).xyz);
                    r2_x_13 = r2_xyzw_12.x;
                    r2_y_13 = r2_xyzw_12.y;
                    r2_z_12 = r2_xyzw_12.z;
                    r2_w_8 = r2_xyzw_12.w;
                }
                else
                {
                    float r2_x_7 = (float4(1, 1, 1, 1)).x;
                    float4 r2_xyzw_3 = float4(1, 1, 1, 1);
                    float r2_y_3 = r2_xyzw_3.y;
                    float r2_z_3 = r2_xyzw_3.z;
                    float r2_w_1 = r2_xyzw_3.w;
                    r2_x_13 = r2_x_7;
                    r2_y_13 = r2_y_3;
                    r2_z_12 = r2_z_3;
                    r2_w_8 = r2_w_1;
                }
                float4 r2_xyzw_14 = (i.texcoord2.xxyz + -cb2_values[1].xxyz);
                float r2_y_14 = r2_xyzw_14.y;
                float r2_z_13 = r2_xyzw_14.z;
                float r2_w_9 = r2_xyzw_14.w;
                float r3_w_3 = max(abs(r2_z_13), abs(r2_y_14));
                float r3_w_4 = max(abs(r2_w_9), r3_w_3);
                float r3_w_5 = (r3_w_4 + -cb2_values[2].z);
                float r3_w_6 = max(r3_w_5, 1E-05);
                float r3_w_7 = (r3_w_6 * cb2_values[2].w);
                float r3_w_8 = (cb2_values[2].y / r3_w_7);
                float r3_w_9 = (r3_w_8 + -cb2_values[2].x);
                float r3_w_10 = (-r3_w_9 + 1);
                float r2_y_15 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r2_y_14, r2_z_13, r2_w_9, r2_y_14)).xyz, r3_w_10);
                float r2_z_14 = (-cb3_values[24].x + 1);
                float r2_y_16 = mad(r2_y_15, r2_z_14, cb3_values[24].x);
                float r1_w_6 = mad(r1_w_5, (-r2_y_16 + saturate(dot(float4(r2_x_13, r2_y_13, r2_z_12, r2_w_8), unity_OcclusionMaskSelector))), r2_y_16);
                float4 r2_xyzw_17 = t1.Sample(sampler_linear_clamp3, ((dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx)).xxxx).xy);
                float4 r5_xyzw_5 = t2.Sample(sampler_linear_clamp2, r5_xyz_4.xyz);
                float r1_w_7 = (r1_w_6 * (r2_xyzw_17.x * r5_xyzw_5.w));
                float r1_y_2 = (cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_1.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * cb0_values[10].x);
                float r0_y_8 = exp2(r0_y_7);
                float4 r2_xyzw_19 = (r4_xyz_2.xyzx * _LightColor0.xyzx);
                float r2_x_19 = r2_xyzw_19.x;
                float r2_y_18 = r2_xyzw_19.y;
                float r2_z_16 = r2_xyzw_19.z;
                float r0_z_4 = (r1_w_7 * saturate(((dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx) + cb0_values[10].w) / r1_y_2)));
                                float4 r1_xyzw_5 = (((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * cb0_values[10].y)).xxxx * _LightColor0.xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_3 = r1_xyzw_5.y;
                float r1_z_2 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = (float4(r1_x_5, r1_y_3, r1_z_2, r1_x_5) * cb0_values[10].zzzz);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                float4 r1_xyzw_7 = (r1_w_7.xxxx * float4(r1_x_6, r1_y_4, r1_z_3, r1_x_6));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_5 = r1_xyzw_7.y;
                float r1_z_4 = r1_xyzw_7.z;
                float4 r0_xyzw_9 = mad(float4(r2_x_19, r2_x_19, r2_y_18, r2_z_16), r0_z_4.xxxx, float4(r1_x_7, r1_x_7, r1_y_5, r1_z_4));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                float4 r1_xyzw_8 = (r0_y_8.xxxx * cb0_values[9].xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_z_5 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = (float4(r1_x_8, r1_y_6, r1_z_5, r1_x_8) * float4(0.1, 0.1, 0.1, 0));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_7 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r1_xyzw_10 = mad(r4_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r1_x_9, r1_y_7, r1_z_6, r1_x_9));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_8 = r1_xyzw_10.y;
                float r1_z_7 = r1_xyzw_10.z;
                o.sv_Target0.xyz = ((float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + float4(r1_x_10, r1_y_8, r1_z_7, r1_x_10))).xyz;
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
                float4 _RimColor;
                float _RimPower;
                float _Specular;
                float _Gloss;
                float _Wrap;
                float4 _MainTex_ST;
                float4 cb0_values[12];
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
            Texture2D _MainTex;
            Texture2D t1;
            Texture3D t2;
            TextureCube t3;
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
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program97Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
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
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_3 = ((worldPos_xyzw_4.yyyy * _RimColor.xyzx)).xyz;
                float3 clipPos_xyz_4 = (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_3.xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(cb0_values[6].xyzx, worldPos_xyzw_4.zzzz, clipPos_xyz_4.xyzx)).xyz;
                o.texcoord3.xyz = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program97Output frag(program97Input i)
            {
                program97Output o = (program97Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_2 = ((r4_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float3 r5_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r1_w_3 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float3 r2_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_4 = mad(cb3_values[25].w, (-r1_w_3 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_3);
                float r1_w_5 = saturate(mad(r1_w_4, cb3_values[24].z, cb3_values[24].w));
                float r2_x_13;
                float r2_y_13;
                float r2_z_12;
                float r2_w_8;
                if ((cb5_values[0].x == 1))
                {
                    float4 r2_xyzw_4 = (i.texcoord2.yyyy * cb5_values[2].xxyz);
                    float r2_y_4 = r2_xyzw_4.y;
                    float r2_z_4 = r2_xyzw_4.z;
                    float r2_w_2 = r2_xyzw_4.w;
                    float4 r2_xyzw_5 = mad(cb5_values[1].xxyz, i.texcoord2.xxxx, float4(r2_y_4, r2_y_4, r2_z_4, r2_w_2));
                    float r2_y_5 = r2_xyzw_5.y;
                    float r2_z_5 = r2_xyzw_5.z;
                    float r2_w_3 = r2_xyzw_5.w;
                    float4 r2_xyzw_6 = mad(cb5_values[3].xxyz, i.texcoord2.zzzz, float4(r2_y_5, r2_y_5, r2_z_5, r2_w_3));
                    float r2_y_6 = r2_xyzw_6.y;
                    float r2_z_6 = r2_xyzw_6.z;
                    float r2_w_4 = r2_xyzw_6.w;
                    float4 r2_xyzw_7 = (float4(r2_y_6, r2_y_6, r2_z_6, r2_w_4) + cb5_values[4].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_5 = r2_xyzw_7.w;
                    float4 r2_xyzw_9 = (((cb5_values[0].y == 1)).xxxx ? float4(r2_y_7, r2_z_7, r2_w_5, r2_y_7) : i.texcoord2.xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_8 = r2_xyzw_9.y;
                    float r2_z_8 = r2_xyzw_9.z;
                    float4 r2_xyzw_10 = (float4(r2_x_9, r2_y_8, r2_z_8, r2_x_9) + -cb5_values[6].xyzx);
                    float r2_x_10 = r2_xyzw_10.x;
                    float r2_y_9 = r2_xyzw_10.y;
                    float r2_z_9 = r2_xyzw_10.z;
                    float r2_y_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).y;
                    float r2_z_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).z;
                    float r2_w_6 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).w;
                    float r2_y_11 = mad(r2_y_10, 0.25, 0.75);
                    float r3_w_1 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r2_x_11 = max(r2_y_11, r3_w_1);
                    float4 r2_xyzw_12 = t2.Sample(sampler_linear_clamp, (float4(r2_x_11, r2_z_10, r2_w_6, r2_x_11)).xyz);
                    r2_x_13 = r2_xyzw_12.x;
                    r2_y_13 = r2_xyzw_12.y;
                    r2_z_12 = r2_xyzw_12.z;
                    r2_w_8 = r2_xyzw_12.w;
                }
                else
                {
                    float r2_x_7 = (float4(1, 1, 1, 1)).x;
                    float4 r2_xyzw_3 = float4(1, 1, 1, 1);
                    float r2_y_3 = r2_xyzw_3.y;
                    float r2_z_3 = r2_xyzw_3.z;
                    float r2_w_1 = r2_xyzw_3.w;
                    r2_x_13 = r2_x_7;
                    r2_y_13 = r2_y_3;
                    r2_z_12 = r2_z_3;
                    r2_w_8 = r2_w_1;
                }
                float r2_y_14 = (r1_w_5 < 0.99);
                float r2_y_20;
                if (r2_y_14)
                {
                    float4 r2_xyzw_16 = (i.texcoord2.xxyz + -cb2_values[1].xxyz);
                    float r2_y_16 = r2_xyzw_16.y;
                    float r2_z_13 = r2_xyzw_16.z;
                    float r2_w_9 = r2_xyzw_16.w;
                    float r3_w_3 = max(abs(r2_z_13), abs(r2_y_16));
                    float r3_w_4 = max(abs(r2_w_9), r3_w_3);
                    float r3_w_5 = (r3_w_4 + -cb2_values[2].z);
                    float r3_w_6 = max(r3_w_5, 1E-05);
                    float r3_w_7 = (r3_w_6 * cb2_values[2].w);
                    float r3_w_8 = (cb2_values[2].y / r3_w_7);
                    float r3_w_9 = (r3_w_8 + -cb2_values[2].x);
                    float r3_w_10 = (-r3_w_9 + 1);
                    float r6_x_3 = t3.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((float4(r2_y_16, r2_z_13, r2_w_9, r2_y_16) + float4(0.0078125, 0.0078125, 0.0078125, 0))).xyzx).xyz, r3_w_10);
                    float r6_y_3 = t3.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((float4(r2_y_16, r2_z_13, r2_w_9, r2_y_16) + float4(-0.0078125, -0.0078125, 0.0078125, 0))).xyzx).xyz, r3_w_10);
                    float r6_z_3 = t3.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (((float4(r2_y_16, r2_z_13, r2_w_9, r2_y_16) + float4(-0.0078125, 0.0078125, -0.0078125, 0))).xyzx).xyz, r3_w_10);
                    float4 r2_xyzw_17 = (float4(r2_y_16, r2_y_16, r2_z_13, r2_w_9) + float4(0, 0.0078125, -0.0078125, -0.0078125));
                    float r2_y_17 = r2_xyzw_17.y;
                    float r2_z_14 = r2_xyzw_17.z;
                    float r2_w_10 = r2_xyzw_17.w;
                    float r6_w_1 = t3.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r2_y_17, r2_z_14, r2_w_10, r2_y_17)).xyz, r3_w_10);
                    float r2_y_18 = dot(float4(r6_x_3, r6_y_3, r6_z_3, r6_w_1), float4(0.25, 0.25, 0.25, 0.25));
                    float r2_z_15 = (-cb3_values[24].x + 1);
                    float r2_y_19 = mad(r2_y_18, r2_z_15, cb3_values[24].x);
                    r2_y_20 = r2_y_19;
                }
                else
                {
                    float r2_y_15 = 1;
                    r2_y_20 = r2_y_15;
                }
                float r1_w_6 = mad(r1_w_5, (-r2_y_20 + saturate(dot(float4(r2_x_13, r2_y_13, r2_z_12, r2_w_8), unity_OcclusionMaskSelector))), r2_y_20);
                float r2_x_17 = (t1.Sample(sampler_linear_clamp2, ((dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx)).xxxx).xy)).x;
                float4 r2_xyzw_21 = t1.Sample(sampler_linear_clamp2, ((dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx)).xxxx).xy);
                float r2_y_21 = r2_xyzw_21.y;
                float r2_z_17 = r2_xyzw_21.z;
                float r2_w_12 = r2_xyzw_21.w;
                float r1_w_7 = (r1_w_6 * r2_x_17);
                float r1_y_2 = (cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_1.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * cb0_values[10].x);
                float r0_y_8 = exp2(r0_y_7);
                float4 r2_xyzw_18 = (r4_xyz_2.xyzx * _LightColor0.xyzx);
                float r2_x_18 = r2_xyzw_18.x;
                float r2_y_22 = r2_xyzw_18.y;
                float r2_z_18 = r2_xyzw_18.z;
                float r0_z_4 = (r1_w_7 * saturate(((dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx) + cb0_values[10].w) / r1_y_2)));
                                float4 r1_xyzw_5 = (((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * cb0_values[10].y)).xxxx * _LightColor0.xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_3 = r1_xyzw_5.y;
                float r1_z_2 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = (float4(r1_x_5, r1_y_3, r1_z_2, r1_x_5) * cb0_values[10].zzzz);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                float4 r1_xyzw_7 = (r1_w_7.xxxx * float4(r1_x_6, r1_y_4, r1_z_3, r1_x_6));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_5 = r1_xyzw_7.y;
                float r1_z_4 = r1_xyzw_7.z;
                float4 r0_xyzw_9 = mad(float4(r2_x_18, r2_x_18, r2_y_22, r2_z_18), r0_z_4.xxxx, float4(r1_x_7, r1_x_7, r1_y_5, r1_z_4));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                float4 r1_xyzw_8 = (r0_y_8.xxxx * cb0_values[9].xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_z_5 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = (float4(r1_x_8, r1_y_6, r1_z_5, r1_x_8) * float4(0.1, 0.1, 0.1, 0));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_7 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r1_xyzw_10 = mad(r4_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r1_x_9, r1_y_7, r1_z_6, r1_x_9));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_8 = r1_xyzw_10.y;
                float r1_z_7 = r1_xyzw_10.z;
                o.sv_Target0.xyz = ((float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + float4(r1_x_10, r1_y_8, r1_z_7, r1_x_10))).xyz;
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
                float4 _RimColor;
                float _RimPower;
                float _Specular;
                float _Gloss;
                float _Wrap;
                float4 _MainTex_ST;
                float4 cb0_values[12];
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
            Texture2D _MainTex;
            Texture2D t1;
            Texture3D t2;
            TextureCube t3;
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
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program96Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
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
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_3 = ((worldPos_xyzw_4.yyyy * _RimColor.xyzx)).xyz;
                float3 clipPos_xyz_4 = (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_3.xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(cb0_values[6].xyzx, worldPos_xyzw_4.zzzz, clipPos_xyz_4.xyzx)).xyz;
                o.texcoord3.xyz = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program96Output frag(program96Input i)
            {
                program96Output o = (program96Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_2 = ((r4_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float3 r5_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r1_w_3 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float3 r2_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_4 = mad(cb3_values[25].w, (-r1_w_3 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_3);
                float r1_w_5 = saturate(mad(r1_w_4, cb3_values[24].z, cb3_values[24].w));
                float r2_x_13;
                float r2_y_13;
                float r2_z_12;
                float r2_w_8;
                if ((cb5_values[0].x == 1))
                {
                    float4 r2_xyzw_4 = (i.texcoord2.yyyy * cb5_values[2].xxyz);
                    float r2_y_4 = r2_xyzw_4.y;
                    float r2_z_4 = r2_xyzw_4.z;
                    float r2_w_2 = r2_xyzw_4.w;
                    float4 r2_xyzw_5 = mad(cb5_values[1].xxyz, i.texcoord2.xxxx, float4(r2_y_4, r2_y_4, r2_z_4, r2_w_2));
                    float r2_y_5 = r2_xyzw_5.y;
                    float r2_z_5 = r2_xyzw_5.z;
                    float r2_w_3 = r2_xyzw_5.w;
                    float4 r2_xyzw_6 = mad(cb5_values[3].xxyz, i.texcoord2.zzzz, float4(r2_y_5, r2_y_5, r2_z_5, r2_w_3));
                    float r2_y_6 = r2_xyzw_6.y;
                    float r2_z_6 = r2_xyzw_6.z;
                    float r2_w_4 = r2_xyzw_6.w;
                    float4 r2_xyzw_7 = (float4(r2_y_6, r2_y_6, r2_z_6, r2_w_4) + cb5_values[4].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_5 = r2_xyzw_7.w;
                    float4 r2_xyzw_9 = (((cb5_values[0].y == 1)).xxxx ? float4(r2_y_7, r2_z_7, r2_w_5, r2_y_7) : i.texcoord2.xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_8 = r2_xyzw_9.y;
                    float r2_z_8 = r2_xyzw_9.z;
                    float4 r2_xyzw_10 = (float4(r2_x_9, r2_y_8, r2_z_8, r2_x_9) + -cb5_values[6].xyzx);
                    float r2_x_10 = r2_xyzw_10.x;
                    float r2_y_9 = r2_xyzw_10.y;
                    float r2_z_9 = r2_xyzw_10.z;
                    float r2_y_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).y;
                    float r2_z_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).z;
                    float r2_w_6 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).w;
                    float r2_y_11 = mad(r2_y_10, 0.25, 0.75);
                    float r3_w_1 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r2_x_11 = max(r2_y_11, r3_w_1);
                    float4 r2_xyzw_12 = t2.Sample(sampler_linear_clamp, (float4(r2_x_11, r2_z_10, r2_w_6, r2_x_11)).xyz);
                    r2_x_13 = r2_xyzw_12.x;
                    r2_y_13 = r2_xyzw_12.y;
                    r2_z_12 = r2_xyzw_12.z;
                    r2_w_8 = r2_xyzw_12.w;
                }
                else
                {
                    float r2_x_7 = (float4(1, 1, 1, 1)).x;
                    float4 r2_xyzw_3 = float4(1, 1, 1, 1);
                    float r2_y_3 = r2_xyzw_3.y;
                    float r2_z_3 = r2_xyzw_3.z;
                    float r2_w_1 = r2_xyzw_3.w;
                    r2_x_13 = r2_x_7;
                    r2_y_13 = r2_y_3;
                    r2_z_12 = r2_z_3;
                    r2_w_8 = r2_w_1;
                }
                float4 r2_xyzw_14 = (i.texcoord2.xxyz + -cb2_values[1].xxyz);
                float r2_y_14 = r2_xyzw_14.y;
                float r2_z_13 = r2_xyzw_14.z;
                float r2_w_9 = r2_xyzw_14.w;
                float r3_w_3 = max(abs(r2_z_13), abs(r2_y_14));
                float r3_w_4 = max(abs(r2_w_9), r3_w_3);
                float r3_w_5 = (r3_w_4 + -cb2_values[2].z);
                float r3_w_6 = max(r3_w_5, 1E-05);
                float r3_w_7 = (r3_w_6 * cb2_values[2].w);
                float r3_w_8 = (cb2_values[2].y / r3_w_7);
                float r3_w_9 = (r3_w_8 + -cb2_values[2].x);
                float r3_w_10 = (-r3_w_9 + 1);
                float r2_y_15 = t3.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r2_y_14, r2_z_13, r2_w_9, r2_y_14)).xyz, r3_w_10);
                float r2_z_14 = (-cb3_values[24].x + 1);
                float r2_y_16 = mad(r2_y_15, r2_z_14, cb3_values[24].x);
                float r1_w_6 = mad(r1_w_5, (-r2_y_16 + saturate(dot(float4(r2_x_13, r2_y_13, r2_z_12, r2_w_8), unity_OcclusionMaskSelector))), r2_y_16);
                float4 r2_xyzw_17 = t1.Sample(sampler_linear_clamp2, ((dot(r5_xyz_4.xyzx, r5_xyz_4.xyzx)).xxxx).xy);
                float r1_w_7 = (r1_w_6 * r2_xyzw_17.x);
                float r1_y_2 = (cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_1.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * cb0_values[10].x);
                float r0_y_8 = exp2(r0_y_7);
                float4 r2_xyzw_18 = (r4_xyz_2.xyzx * _LightColor0.xyzx);
                float r2_x_18 = r2_xyzw_18.x;
                float r2_y_18 = r2_xyzw_18.y;
                float r2_z_16 = r2_xyzw_18.z;
                float r0_z_4 = (r1_w_7 * saturate(((dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx) + cb0_values[10].w) / r1_y_2)));
                                float4 r1_xyzw_5 = (((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * cb0_values[10].y)).xxxx * _LightColor0.xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_3 = r1_xyzw_5.y;
                float r1_z_2 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = (float4(r1_x_5, r1_y_3, r1_z_2, r1_x_5) * cb0_values[10].zzzz);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                float4 r1_xyzw_7 = (r1_w_7.xxxx * float4(r1_x_6, r1_y_4, r1_z_3, r1_x_6));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_5 = r1_xyzw_7.y;
                float r1_z_4 = r1_xyzw_7.z;
                float4 r0_xyzw_9 = mad(float4(r2_x_18, r2_x_18, r2_y_18, r2_z_16), r0_z_4.xxxx, float4(r1_x_7, r1_x_7, r1_y_5, r1_z_4));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                float4 r1_xyzw_8 = (r0_y_8.xxxx * cb0_values[9].xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_z_5 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = (float4(r1_x_8, r1_y_6, r1_z_5, r1_x_8) * float4(0.1, 0.1, 0.1, 0));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_7 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r1_xyzw_10 = mad(r4_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r1_x_9, r1_y_7, r1_z_6, r1_x_9));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_8 = r1_xyzw_10.y;
                float r1_z_7 = r1_xyzw_10.z;
                o.sv_Target0.xyz = ((float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + float4(r1_x_10, r1_y_8, r1_z_7, r1_x_10))).xyz;
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
                float4 _RimColor;
                float _RimPower;
                float _Specular;
                float _Gloss;
                float _Wrap;
                float4 _MainTex_ST;
                float4 cb0_values[12];
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
            Texture2D _MainTex;
            Texture2D t1;
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
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program95Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
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
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                float4 r2_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                o.texcoord3.xy = (mad(_MainTex_ST.xxxy, r2_xyzw_4.wwww, (mad(cb0_values[6].xyxx, r2_xyzw_4.zzzz, (mad(_Color.xyxx, r2_xyzw_4.xxxx, ((r2_xyzw_4.yyyy * _RimColor.xyxx)).xyxx)).xyxx)).xxxy)).zw;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_w_4 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7));
                float r0_w_5 = rsqrt(r0_w_4);
                o.texcoord1.xyz = ((r0_w_5.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7))).xyz;
                float r0_w_6 = ((clipPos_xyzw_2.y * unity_WorldToObject[1].x) * 0.5);
                float4 r0_xyzw_9 = (clipPos_xyzw_2.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                o.texcoord4.zw = (clipPos_xyzw_2.zzzw).zw;
                o.texcoord4.xy = ((r0_z_5.xxxx + float4(r0_x_9, r0_w_6, r0_x_9, r0_x_9))).xy;
                return o;
            }
            #pragma fragment frag
            program95Output frag(program95Input i)
            {
                program95Output o = (program95Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_2 = ((r2_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float r4_x_1 = cb4_values[9].z;
                float r4_y_1 = cb4_values[10].z;
                float r4_z_1 = cb4_values[11].z;
                float r1_w_1 = dot(viewDir_xyz_1.xyzx, float4(r4_x_1, r4_y_1, r4_z_1, r4_x_1));
                float3 r4_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = dot(r4_xyz_2.xyzx, r4_xyz_2.xyzx);
                float r2_w_3 = sqrt(r2_w_2);
                float r2_w_4 = (-r1_w_1 + r2_w_3);
                float r1_w_2 = mad(cb3_values[25].w, r2_w_4, r1_w_1);
                float r1_w_3 = saturate(mad(r1_w_2, cb3_values[24].z, cb3_values[24].w));
                float r2_w_5 = (cb5_values[0].x == 1);
                float r4_x_12;
                float r4_y_12;
                float r4_z_12;
                float r4_w_4;
                if (r2_w_5)
                {
                    float r2_w_6 = (cb5_values[0].y == 1);
                    float3 r4_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r4_xyzw_10 = (((((r2_w_6.xxxx ? r4_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r4_y_10 = r4_xyzw_10.y;
                    float r4_z_10 = r4_xyzw_10.z;
                    float r4_w_2 = r4_xyzw_10.w;
                    float r2_w_7 = mad(r4_y_10, 0.25, 0.75);
                    float r3_z_1 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r4_x_10 = max(r2_w_7, r3_z_1);
                    float4 r4_xyzw_11 = t3.Sample(sampler_linear_clamp, (float4(r4_x_10, r4_z_10, r4_w_2, r4_x_10)).xyz);
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
                float4 r3_xyzw_3 = (i.texcoord4.xxxy / i.texcoord4.wwww);
                float r3_z_3 = r3_xyzw_3.z;
                float r3_w_1 = r3_xyzw_3.w;
                float4 r4_xyzw_13 = t1.Sample(sampler_linear_clamp1, (float4(r3_z_3, r3_w_1, r3_z_3, r3_z_3)).xy);
                float r2_w_10 = (r2_w_9 + -r4_xyzw_13.x);
                float r1_w_4 = mad(r1_w_3, r2_w_10, r4_xyzw_13.x);
                float4 r3_xyzw_5 = t2.Sample(sampler_linear_clamp2, ((((mad(cb0_values[6].xyxx, i.texcoord2.zzzz, (mad(cb0_values[4].xyxx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx).xy);
                float r1_w_5 = (r1_w_4 * r3_xyzw_5.w);
                float r2_w_11 = dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx);
                float r2_w_12 = (r2_w_11 + cb0_values[10].w);
                float r2_w_13 = saturate((r2_w_12 / (cb0_values[10].w + 1)));
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_1.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * cb0_values[10].x);
                float r0_y_8 = exp2(r0_y_7);
                float r0_z_4 = (r1_w_5 * r2_w_13);
                                float4 r3_xyzw_7 = (((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * cb0_values[10].y)).xxxx * _LightColor0.xyzx);
                float r3_x_7 = r3_xyzw_7.x;
                float r3_y_6 = r3_xyzw_7.y;
                float r3_z_5 = r3_xyzw_7.z;
                float4 r3_xyzw_8 = (float4(r3_x_7, r3_y_6, r3_z_5, r3_x_7) * cb0_values[10].zzzz);
                float r3_x_8 = r3_xyzw_8.x;
                float r3_y_7 = r3_xyzw_8.y;
                float r3_z_6 = r3_xyzw_8.z;
                float4 r3_xyzw_9 = (r1_w_5.xxxx * float4(r3_x_8, r3_y_7, r3_z_6, r3_x_8));
                float r3_x_9 = r3_xyzw_9.x;
                float r3_y_8 = r3_xyzw_9.y;
                float r3_z_7 = r3_xyzw_9.z;
                float4 r0_xyzw_9 = mad(((r2_xyz_2.xyzx * _LightColor0.xyzx)).xxyz, r0_z_4.xxxx, float4(r3_x_9, r3_x_9, r3_y_8, r3_z_7));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                o.sv_Target0.xyz = ((float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + (mad(r2_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), ((((r0_y_8.xxxx * cb0_values[9].xyzx)).xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx)).xyzx)).xyz;
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
                float4 _RimColor;
                float _RimPower;
                float _Specular;
                float _Gloss;
                float _Wrap;
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
            Texture2D _MainTex;
            Texture2D t1;
            Texture3D t2;
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
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program94Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
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
            program94Output frag(program94Input i)
            {
                program94Output o = (program94Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_2 = ((r2_xyzw_1.xyzx * cb0_values[4].xyzx)).xyz;
                float r3_x_1 = cb4_values[9].z;
                float r3_y_1 = cb4_values[10].z;
                float r3_z_1 = cb4_values[11].z;
                float r1_w_1 = dot(viewDir_xyz_1.xyzx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float3 r3_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r2_w_2 = dot(r3_xyz_2.xyzx, r3_xyz_2.xyzx);
                float r2_w_3 = sqrt(r2_w_2);
                float r2_w_4 = (-r1_w_1 + r2_w_3);
                float r1_w_2 = mad(cb3_values[25].w, r2_w_4, r1_w_1);
                float r1_w_3 = saturate(mad(r1_w_2, cb3_values[24].z, cb3_values[24].w));
                float r2_w_5 = (cb5_values[0].x == 1);
                float r3_x_12;
                float r3_y_13;
                float r3_z_12;
                float r3_w_4;
                if (r2_w_5)
                {
                    float r2_w_6 = (cb5_values[0].y == 1);
                    float3 r3_xyz_7 = (((mad(cb5_values[3].xyzx, i.texcoord2.zzzz, (mad(cb5_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r3_xyzw_10 = (((((r2_w_6.xxxx ? r3_xyz_7.xyzx : i.texcoord2.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r3_y_10 = r3_xyzw_10.y;
                    float r3_z_10 = r3_xyzw_10.z;
                    float r3_w_2 = r3_xyzw_10.w;
                    float r2_w_7 = mad(r3_y_10, 0.25, 0.75);
                    float r3_y_11 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r3_x_10 = max(r2_w_7, r3_y_11);
                    float4 r3_xyzw_11 = t2.Sample(sampler_linear_clamp, (float4(r3_x_10, r3_z_10, r3_w_2, r3_x_10)).xyz);
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
                float4 r3_xyzw_13 = (i.texcoord4.xyxx / i.texcoord4.wwww);
                float r3_x_13 = r3_xyzw_13.x;
                float r3_y_14 = r3_xyzw_13.y;
                float4 r3_xyzw_14 = t1.Sample(sampler_linear_clamp1, (float4(r3_x_13, r3_y_14, r3_x_13, r3_x_13)).xy);
                float r2_w_10 = (r2_w_9 + -r3_xyzw_14.x);
                float r1_w_4 = mad(r1_w_3, r2_w_10, r3_xyzw_14.x);
                float r2_w_11 = dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx);
                float r2_w_12 = (r2_w_11 + cb0_values[6].w);
                float r2_w_13 = saturate((r2_w_12 / (cb0_values[6].w + 1)));
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_1.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * cb0_values[6].x);
                float r0_y_8 = exp2(r0_y_7);
                float r0_z_4 = (r1_w_4 * r2_w_13);
                                float4 r3_xyzw_16 = (((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * cb0_values[6].y)).xxxx * _LightColor0.xyzx);
                float r3_x_16 = r3_xyzw_16.x;
                float r3_y_16 = r3_xyzw_16.y;
                float r3_z_14 = r3_xyzw_16.z;
                float4 r3_xyzw_17 = (float4(r3_x_16, r3_y_16, r3_z_14, r3_x_16) * cb0_values[6].zzzz);
                float r3_x_17 = r3_xyzw_17.x;
                float r3_y_17 = r3_xyzw_17.y;
                float r3_z_15 = r3_xyzw_17.z;
                float4 r3_xyzw_18 = (r1_w_4.xxxx * float4(r3_x_17, r3_y_17, r3_z_15, r3_x_17));
                float r3_x_18 = r3_xyzw_18.x;
                float r3_y_18 = r3_xyzw_18.y;
                float r3_z_16 = r3_xyzw_18.z;
                float4 r0_xyzw_9 = mad(((r2_xyz_2.xyzx * _LightColor0.xyzx)).xxyz, r0_z_4.xxxx, float4(r3_x_18, r3_x_18, r3_y_18, r3_z_16));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                o.sv_Target0.xyz = ((float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + (mad(r2_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), ((((r0_y_8.xxxx * cb0_values[5].xyzx)).xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx)).xyzx)).xyz;
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
                float4 _RimColor;
                float _RimPower;
                float _Specular;
                float _Gloss;
                float _Wrap;
                float4 _MainTex_ST;
                float4 cb0_values[17];
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
            Texture2D _MainTex;
            Texture2D t1;
            Texture2D t2;
            Texture3D t3;
            Texture2D t4;
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
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program93Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
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
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[16].xyxx, cb0_values[16].zwzz)).xy;
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
            program93Output frag(program93Input i)
            {
                program93Output o = (program93Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_2 = ((r4_xyzw_1.xyzx * cb0_values[13].xyzx)).xyz;
                float4 r5_xyzw_4 = (mad(cb0_values[11].xyzw, i.texcoord2.zzzz, mad(cb0_values[9].xyzw, i.texcoord2.xxxx, (i.texcoord2.yyyy * cb0_values[10].xyzw))) + cb0_values[12].xyzw);
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r1_w_3 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float3 r2_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_4 = mad(cb3_values[25].w, (-r1_w_3 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_3);
                float r1_w_5 = saturate(mad(r1_w_4, cb3_values[24].z, cb3_values[24].w));
                float r2_x_13;
                float r2_y_13;
                float r2_z_12;
                float r2_w_8;
                if ((cb5_values[0].x == 1))
                {
                    float4 r2_xyzw_4 = (i.texcoord2.yyyy * cb5_values[2].xxyz);
                    float r2_y_4 = r2_xyzw_4.y;
                    float r2_z_4 = r2_xyzw_4.z;
                    float r2_w_2 = r2_xyzw_4.w;
                    float4 r2_xyzw_5 = mad(cb5_values[1].xxyz, i.texcoord2.xxxx, float4(r2_y_4, r2_y_4, r2_z_4, r2_w_2));
                    float r2_y_5 = r2_xyzw_5.y;
                    float r2_z_5 = r2_xyzw_5.z;
                    float r2_w_3 = r2_xyzw_5.w;
                    float4 r2_xyzw_6 = mad(cb5_values[3].xxyz, i.texcoord2.zzzz, float4(r2_y_5, r2_y_5, r2_z_5, r2_w_3));
                    float r2_y_6 = r2_xyzw_6.y;
                    float r2_z_6 = r2_xyzw_6.z;
                    float r2_w_4 = r2_xyzw_6.w;
                    float4 r2_xyzw_7 = (float4(r2_y_6, r2_y_6, r2_z_6, r2_w_4) + cb5_values[4].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_5 = r2_xyzw_7.w;
                    float4 r2_xyzw_9 = (((cb5_values[0].y == 1)).xxxx ? float4(r2_y_7, r2_z_7, r2_w_5, r2_y_7) : i.texcoord2.xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_8 = r2_xyzw_9.y;
                    float r2_z_8 = r2_xyzw_9.z;
                    float4 r2_xyzw_10 = (float4(r2_x_9, r2_y_8, r2_z_8, r2_x_9) + -cb5_values[6].xyzx);
                    float r2_x_10 = r2_xyzw_10.x;
                    float r2_y_9 = r2_xyzw_10.y;
                    float r2_z_9 = r2_xyzw_10.z;
                    float r2_y_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).y;
                    float r2_z_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).z;
                    float r2_w_6 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).w;
                    float r2_y_11 = mad(r2_y_10, 0.25, 0.75);
                    float r3_w_1 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r2_x_11 = max(r2_y_11, r3_w_1);
                    float4 r2_xyzw_12 = t3.Sample(sampler_linear_clamp, (float4(r2_x_11, r2_z_10, r2_w_6, r2_x_11)).xyz);
                    r2_x_13 = r2_xyzw_12.x;
                    r2_y_13 = r2_xyzw_12.y;
                    r2_z_12 = r2_xyzw_12.z;
                    r2_w_8 = r2_xyzw_12.w;
                }
                else
                {
                    float r2_x_7 = (float4(1, 1, 1, 1)).x;
                    float4 r2_xyzw_3 = float4(1, 1, 1, 1);
                    float r2_y_3 = r2_xyzw_3.y;
                    float r2_z_3 = r2_xyzw_3.z;
                    float r2_w_1 = r2_xyzw_3.w;
                    r2_x_13 = r2_x_7;
                    r2_y_13 = r2_y_3;
                    r2_z_12 = r2_z_3;
                    r2_w_8 = r2_w_1;
                }
                float r2_y_14 = (r1_w_5 < 0.99);
                float r2_y_27;
                if (r2_y_14)
                {
                    float4 r6_xyzw_2 = (i.texcoord2.yyyy * cb3_values[9].xyzw);
                    float4 r6_xyzw_3 = mad(cb3_values[8].xyzw, i.texcoord2.xxxx, r6_xyzw_2);
                    float4 r6_xyzw_4 = mad(cb3_values[10].xyzw, i.texcoord2.zzzz, r6_xyzw_3);
                    float4 r6_xyzw_5 = (r6_xyzw_4 + cb3_values[11].xyzw);
                    float4 r2_xyzw_16 = (r6_xyzw_5.xxyz / r6_xyzw_5.wwww);
                    float r2_y_16 = r2_xyzw_16.y;
                    float r2_z_13 = r2_xyzw_16.z;
                    float r2_w_9 = r2_xyzw_16.w;
                    float2 r6_xy_7 = (floor((mad(float4(r2_y_16, r2_z_13, r2_y_16, r2_y_16), cb0_values[8].zwzz, float4(0.5, 0.5, 0, 0))).xyxx)).xy;
                    float4 r2_xyzw_17 = mad(float4(r2_y_16, r2_y_16, r2_z_13, r2_y_16), cb0_values[8].zzwz, -r6_xy_7.xxyx);
                    float r2_y_17 = r2_xyzw_17.y;
                    float r2_z_14 = r2_xyzw_17.z;
                    float4 r7_xyzw_1 = (float4(r2_y_17, r2_y_17, r2_z_14, r2_z_14) + float4(0.5, 1, 0.5, 1));
                    float2 r8_xw_1 = ((r7_xyzw_1.xxxz * r7_xyzw_1.xxxz)).xw;
                    float4 r6_xyzw_6 = mad(r8_xw_1.xxxy, float4(0, 0, 0.5, 0.5), -float4(r2_y_17, r2_y_17, r2_y_17, r2_z_14));
                    float r6_z_6 = r6_xyzw_6.z;
                    float r6_w_5 = r6_xyzw_6.w;
                    float2 r7_xz_2 = ((-float4(r2_y_17, r2_y_17, r2_z_14, r2_y_17) + float4(1, 0, 1, 0))).xz;
                    float2 r9_xy_1 = (min(float4(r2_y_17, r2_z_14, r2_y_17, r2_y_17), float4(0, 0, 0, 0))).xy;
                    float2 r7_xz_3 = (mad(-r9_xy_1.xxyx, r9_xy_1.xxyx, r7_xz_2.xxyx)).xz;
                    float4 r2_xyzw_18 = max(float4(r2_y_17, r2_y_17, r2_z_14, r2_y_17), float4(0, 0, 0, 0));
                    float r2_y_18 = r2_xyzw_18.y;
                    float r2_z_15 = r2_xyzw_18.z;
                    float4 r2_xyzw_19 = mad(-float4(r2_y_18, r2_y_18, r2_z_15, r2_y_18), float4(r2_y_18, r2_y_18, r2_z_15, r2_y_18), r7_xyzw_1.yywy);
                    float r2_y_19 = r2_xyzw_19.y;
                    float r2_z_16 = r2_xyzw_19.z;
                    float r9_x_2 = r6_z_6;
                    float r9_y_2 = r7_xz_3.x;
                    float r9_z_1 = r2_y_19;
                    float r9_w_1 = r8_xw_1.x;
                    float4 r9_xyzw_3 = (float4(r9_x_2, r9_y_2, r9_z_1, r9_w_1) * float4(0.44444, 0.44444, 0.44444, 0.22222));
                    float r8_x_2 = r6_w_5;
                    float r8_y_1 = r7_xz_3.y;
                    float r8_z_1 = r2_z_16;
                    float4 r7_xyzw_4 = (float4(r8_x_2, r8_y_1, r8_z_1, r8_xw_1.y) * float4(0.44444, 0.44444, 0.44444, 0.22222));
                    float4 r8_xyzw_3 = (r9_xyzw_3.ywyw + r9_xyzw_3.xzxz);
                    float4 r10_xyzw_1 = (r7_xyzw_4.yyww + r7_xyzw_4.xxzz);
                    float4 r2_xyzw_20 = (r9_xyzw_3.yywy / r8_xyzw_3.zzwz);
                    float r2_y_20 = r2_xyzw_20.y;
                    float r2_z_17 = r2_xyzw_20.z;
                    float4 r2_xyzw_21 = (float4(r2_y_20, r2_y_20, r2_z_17, r2_y_20) + float4(0, -1.5, 0.5, 0));
                    float r2_y_21 = r2_xyzw_21.y;
                    float r2_z_18 = r2_xyzw_21.z;
                    float4 r6_xyzw_7 = (r7_xyzw_4.yyyw / r10_xyzw_1.yyyw);
                    float r6_z_7 = r6_xyzw_7.z;
                    float r6_w_6 = r6_xyzw_7.w;
                    float4 r6_xyzw_8 = (float4(r6_z_7, r6_z_7, r6_z_7, r6_w_6) + float4(0, 0, -1.5, 0.5));
                    float r6_z_8 = r6_xyzw_8.z;
                    float r6_w_7 = r6_xyzw_8.w;
                    float4 r7_xyzw_5 = (float4(r2_y_21, r2_z_18, r2_y_21, r2_y_21) * cb0_values[8].xxxx);
                    float r7_x_5 = r7_xyzw_5.x;
                    float r7_y_3 = r7_xyzw_5.y;
                    float r7_z_5 = ((float4(r6_z_8, r6_z_8, r6_z_8, r6_w_7) * cb0_values[8].yyyy)).z;
                    float r7_w_3 = ((float4(r6_z_8, r6_z_8, r6_z_8, r6_w_7) * cb0_values[8].yyyy)).w;
                    float4 r8_xyzw_4 = (r8_xyzw_3 * r10_xyzw_1);
                    float4 r9_xyzw_4 = mad(r6_xy_7.xyxy, cb0_values[8].xyxy, float4(r7_x_5, r7_z_5, r7_y_3, r7_z_5));
                    float r2_y_22 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r9_xyzw_4.xyxx).xy, r2_w_9);
                    float r2_z_19 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (r9_xyzw_4.zwzz).xy, r2_w_9);
                    float r2_z_20 = (r2_z_19 * r8_xyzw_4.y);
                    float r2_y_23 = mad(r8_xyzw_4.x, r2_y_22, r2_z_20);
                    float r6_x_8 = (mad(r6_xy_7.xyxy, cb0_values[8].xyxy, float4(r7_x_5, r7_w_3, r7_y_3, r7_w_3))).x;
                    float r6_y_8 = (mad(r6_xy_7.xyxy, cb0_values[8].xyxy, float4(r7_x_5, r7_w_3, r7_y_3, r7_w_3))).y;
                    float4 r6_xyzw_9 = mad(r6_xy_7.xyxy, cb0_values[8].xyxy, float4(r7_x_5, r7_w_3, r7_y_3, r7_w_3));
                    float r6_z_9 = r6_xyzw_9.z;
                    float r6_w_8 = r6_xyzw_9.w;
                    float r2_z_21 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r6_x_8, r6_y_8, r6_x_8, r6_x_8)).xy, r2_w_9);
                    float r2_y_24 = mad(r8_xyzw_4.z, r2_z_21, r2_y_23);
                    float r2_z_22 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r6_z_9, r6_w_8, r6_z_9, r6_z_9)).xy, r2_w_9);
                    float r2_y_25 = mad(r8_xyzw_4.w, r2_z_22, r2_y_24);
                    float r2_z_23 = (-cb3_values[24].x + 1);
                    float r2_y_26 = mad(r2_y_25, r2_z_23, cb3_values[24].x);
                    r2_y_27 = r2_y_26;
                }
                else
                {
                    float r2_y_15 = 1;
                    r2_y_27 = r2_y_15;
                }
                float r1_w_6 = mad(r1_w_5, (-r2_y_27 + saturate(dot(float4(r2_x_13, r2_y_13, r2_z_12, r2_w_8), unity_OcclusionMaskSelector))), r2_y_27);
                float4 r2_xyzw_28 = (r5_xyzw_4.xxyx / r5_xyzw_4.wwww);
                float r2_y_28 = r2_xyzw_28.y;
                float r2_z_25 = r2_xyzw_28.z;
                float4 r2_xyzw_29 = (float4(r2_y_28, r2_y_28, r2_z_25, r2_y_28) + float4(0, 0.5, 0.5, 0));
                float r2_y_29 = r2_xyzw_29.y;
                float r2_z_26 = r2_xyzw_29.z;
                float4 r6_xyzw_10 = t1.Sample(sampler_linear_clamp2, (float4(r2_y_29, r2_z_26, r2_y_29, r2_y_29)).xy);
                float r2_y_30 = dot(r5_xyzw_4.xyzx, r5_xyzw_4.xyzx);
                float4 r5_xyzw_5 = t2.Sample(sampler_linear_clamp3, (r2_y_30.xxxx).xy);
                float r1_w_7 = (r1_w_6 * ((asfloat(asint((float)((0 < r5_xyzw_4.z))) & asint(1065353216)) * r6_xyzw_10.w) * r5_xyzw_5.x));
                float r1_y_2 = (cb0_values[15].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_1.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * cb0_values[15].x);
                float r0_y_8 = exp2(r0_y_7);
                float r2_x_20 = ((r4_xyz_2.xyzx * _LightColor0.xyzx)).x;
                float4 r2_xyzw_31 = (r4_xyz_2.xyzx * _LightColor0.xyzx);
                float r2_y_31 = r2_xyzw_31.y;
                float r2_z_27 = r2_xyzw_31.z;
                float r0_z_4 = (r1_w_7 * saturate(((dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx) + cb0_values[15].w) / r1_y_2)));
                                float4 r1_xyzw_5 = (((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * cb0_values[15].y)).xxxx * _LightColor0.xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_3 = r1_xyzw_5.y;
                float r1_z_2 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = (float4(r1_x_5, r1_y_3, r1_z_2, r1_x_5) * cb0_values[15].zzzz);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                float4 r1_xyzw_7 = (r1_w_7.xxxx * float4(r1_x_6, r1_y_4, r1_z_3, r1_x_6));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_5 = r1_xyzw_7.y;
                float r1_z_4 = r1_xyzw_7.z;
                float4 r0_xyzw_9 = mad(float4(r2_x_20, r2_x_20, r2_y_31, r2_z_27), r0_z_4.xxxx, float4(r1_x_7, r1_x_7, r1_y_5, r1_z_4));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                float4 r1_xyzw_8 = (r0_y_8.xxxx * cb0_values[14].xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_z_5 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = (float4(r1_x_8, r1_y_6, r1_z_5, r1_x_8) * float4(0.1, 0.1, 0.1, 0));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_7 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r1_xyzw_10 = mad(r4_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r1_x_9, r1_y_7, r1_z_6, r1_x_9));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_8 = r1_xyzw_10.y;
                float r1_z_7 = r1_xyzw_10.z;
                o.sv_Target0.xyz = ((float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + float4(r1_x_10, r1_y_8, r1_z_7, r1_x_10))).xyz;
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
                float4 _RimColor;
                float _RimPower;
                float _Specular;
                float _Gloss;
                float _Wrap;
                float4 _MainTex_ST;
                float4 cb0_values[12];
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
            Texture2D _MainTex;
            Texture2D t1;
            Texture2D t2;
            Texture3D t3;
            Texture2D t4;
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
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program92Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
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
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float clipPos_x_3 = ((worldPos_xyzw_4.yyyy * _RimColor)).x;
                float clipPos_y_3 = ((worldPos_xyzw_4.yyyy * _RimColor)).y;
                float clipPos_z_3 = ((worldPos_xyzw_4.yyyy * _RimColor)).z;
                float clipPos_w_4 = ((worldPos_xyzw_4.yyyy * _RimColor)).w;
                float4 clipPos_xyzw_4 = mad(_Color, worldPos_xyzw_4.xxxx, float4(clipPos_x_3, clipPos_y_3, clipPos_z_3, clipPos_w_4));
                float4 clipPos_xyzw_5 = mad(cb0_values[6].xyzw, worldPos_xyzw_4.zzzz, clipPos_xyzw_4);
                o.texcoord3.xyzw = mad(_MainTex_ST, worldPos_xyzw_4.wwww, clipPos_xyzw_5);
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
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_1 = normalize(viewDir_xyz_1);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r4_xyz_2 = ((r4_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float4 r5_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord2.zzzz, mad(cb0_values[4].xyzw, i.texcoord2.xxxx, (i.texcoord2.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r6_x_1 = cb4_values[9].z;
                float r6_y_1 = cb4_values[10].z;
                float r6_z_1 = cb4_values[11].z;
                float r1_w_3 = dot(viewDir_xyz_1.xyzx, float4(r6_x_1, r6_y_1, r6_z_1, r6_x_1));
                float3 r2_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r1_w_4 = mad(cb3_values[25].w, (-r1_w_3 + sqrt(dot(r2_xyz_2.xyzx, r2_xyz_2.xyzx))), r1_w_3);
                float r1_w_5 = saturate(mad(r1_w_4, cb3_values[24].z, cb3_values[24].w));
                float r2_x_13;
                float r2_y_13;
                float r2_z_12;
                float r2_w_8;
                if ((cb5_values[0].x == 1))
                {
                    float4 r2_xyzw_4 = (i.texcoord2.yyyy * cb5_values[2].xxyz);
                    float r2_y_4 = r2_xyzw_4.y;
                    float r2_z_4 = r2_xyzw_4.z;
                    float r2_w_2 = r2_xyzw_4.w;
                    float4 r2_xyzw_5 = mad(cb5_values[1].xxyz, i.texcoord2.xxxx, float4(r2_y_4, r2_y_4, r2_z_4, r2_w_2));
                    float r2_y_5 = r2_xyzw_5.y;
                    float r2_z_5 = r2_xyzw_5.z;
                    float r2_w_3 = r2_xyzw_5.w;
                    float4 r2_xyzw_6 = mad(cb5_values[3].xxyz, i.texcoord2.zzzz, float4(r2_y_5, r2_y_5, r2_z_5, r2_w_3));
                    float r2_y_6 = r2_xyzw_6.y;
                    float r2_z_6 = r2_xyzw_6.z;
                    float r2_w_4 = r2_xyzw_6.w;
                    float4 r2_xyzw_7 = (float4(r2_y_6, r2_y_6, r2_z_6, r2_w_4) + cb5_values[4].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_5 = r2_xyzw_7.w;
                    float4 r2_xyzw_9 = (((cb5_values[0].y == 1)).xxxx ? float4(r2_y_7, r2_z_7, r2_w_5, r2_y_7) : i.texcoord2.xyzx);
                    float r2_x_9 = r2_xyzw_9.x;
                    float r2_y_8 = r2_xyzw_9.y;
                    float r2_z_8 = r2_xyzw_9.z;
                    float4 r2_xyzw_10 = (float4(r2_x_9, r2_y_8, r2_z_8, r2_x_9) + -cb5_values[6].xyzx);
                    float r2_x_10 = r2_xyzw_10.x;
                    float r2_y_9 = r2_xyzw_10.y;
                    float r2_z_9 = r2_xyzw_10.z;
                    float r2_y_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).y;
                    float r2_z_10 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).z;
                    float r2_w_6 = ((float4(r2_x_10, r2_x_10, r2_y_9, r2_z_9) * cb5_values[5].xxyz)).w;
                    float r2_y_11 = mad(r2_y_10, 0.25, 0.75);
                    float r3_w_1 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r2_x_11 = max(r2_y_11, r3_w_1);
                    float4 r2_xyzw_12 = t3.Sample(sampler_linear_clamp, (float4(r2_x_11, r2_z_10, r2_w_6, r2_x_11)).xyz);
                    r2_x_13 = r2_xyzw_12.x;
                    r2_y_13 = r2_xyzw_12.y;
                    r2_z_12 = r2_xyzw_12.z;
                    r2_w_8 = r2_xyzw_12.w;
                }
                else
                {
                    float r2_x_7 = (float4(1, 1, 1, 1)).x;
                    float4 r2_xyzw_3 = float4(1, 1, 1, 1);
                    float r2_y_3 = r2_xyzw_3.y;
                    float r2_z_3 = r2_xyzw_3.z;
                    float r2_w_1 = r2_xyzw_3.w;
                    r2_x_13 = r2_x_7;
                    r2_y_13 = r2_y_3;
                    r2_z_12 = r2_z_3;
                    r2_w_8 = r2_w_1;
                }
                float4 r6_xyzw_2 = (i.texcoord2.yyyy * cb3_values[9].xyzw);
                float4 r6_xyzw_3 = mad(cb3_values[8].xyzw, i.texcoord2.xxxx, r6_xyzw_2);
                float4 r6_xyzw_4 = mad(cb3_values[10].xyzw, i.texcoord2.zzzz, r6_xyzw_3);
                float4 r6_xyzw_5 = (r6_xyzw_4 + cb3_values[11].xyzw);
                float4 r2_xyzw_14 = (r6_xyzw_5.xxyz / r6_xyzw_5.wwww);
                float r2_y_14 = r2_xyzw_14.y;
                float r2_z_13 = r2_xyzw_14.z;
                float r2_w_9 = r2_xyzw_14.w;
                float r2_y_15 = t4.SampleCmpLevelZero(sampler_comparison_linear_clamp1, (float4(r2_y_14, r2_z_13, r2_y_14, r2_y_14)).xy, r2_w_9);
                float r2_z_14 = (-cb3_values[24].x + 1);
                float r2_y_16 = mad(r2_y_15, r2_z_14, cb3_values[24].x);
                float r1_w_6 = mad(r1_w_5, (-r2_y_16 + saturate(dot(float4(r2_x_13, r2_y_13, r2_z_12, r2_w_8), unity_OcclusionMaskSelector))), r2_y_16);
                float4 r2_xyzw_17 = (r5_xyzw_4.xxyx / r5_xyzw_4.wwww);
                float r2_y_17 = r2_xyzw_17.y;
                float r2_z_15 = r2_xyzw_17.z;
                float4 r2_xyzw_18 = (float4(r2_y_17, r2_y_17, r2_z_15, r2_y_17) + float4(0, 0.5, 0.5, 0));
                float r2_y_18 = r2_xyzw_18.y;
                float r2_z_16 = r2_xyzw_18.z;
                float4 r6_xyzw_6 = t1.Sample(sampler_linear_clamp2, (float4(r2_y_18, r2_z_16, r2_y_18, r2_y_18)).xy);
                float r2_y_19 = dot(r5_xyzw_4.xyzx, r5_xyzw_4.xyzx);
                float4 r5_xyzw_5 = t2.Sample(sampler_linear_clamp3, (r2_y_19.xxxx).xy);
                float r1_w_7 = (r1_w_6 * ((asfloat(asint((float)((0 < r5_xyzw_4.z))) & asint(1065353216)) * r6_xyzw_6.w) * r5_xyzw_5.x));
                float r1_y_2 = (cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_1.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * cb0_values[10].x);
                float r0_y_8 = exp2(r0_y_7);
                float4 r2_xyzw_20 = (r4_xyz_2.xyzx * _LightColor0.xyzx);
                float r2_x_20 = r2_xyzw_20.x;
                float r2_y_20 = r2_xyzw_20.y;
                float r2_z_17 = r2_xyzw_20.z;
                float r0_z_4 = (r1_w_7 * saturate(((dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx) + cb0_values[10].w) / r1_y_2)));
                                float4 r1_xyzw_5 = (((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * cb0_values[10].y)).xxxx * _LightColor0.xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_3 = r1_xyzw_5.y;
                float r1_z_2 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = (float4(r1_x_5, r1_y_3, r1_z_2, r1_x_5) * cb0_values[10].zzzz);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                float4 r1_xyzw_7 = (r1_w_7.xxxx * float4(r1_x_6, r1_y_4, r1_z_3, r1_x_6));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_5 = r1_xyzw_7.y;
                float r1_z_4 = r1_xyzw_7.z;
                float4 r0_xyzw_9 = mad(float4(r2_x_20, r2_x_20, r2_y_20, r2_z_17), r0_z_4.xxxx, float4(r1_x_7, r1_x_7, r1_y_5, r1_z_4));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                float4 r1_xyzw_8 = (r0_y_8.xxxx * cb0_values[9].xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_z_5 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = (float4(r1_x_8, r1_y_6, r1_z_5, r1_x_8) * float4(0.1, 0.1, 0.1, 0));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_7 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r1_xyzw_10 = mad(r4_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r1_x_9, r1_y_7, r1_z_6, r1_x_9));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_8 = r1_xyzw_10.y;
                float r1_z_7 = r1_xyzw_10.z;
                o.sv_Target0.xyz = ((float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + float4(r1_x_10, r1_y_8, r1_z_7, r1_x_10))).xyz;
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
                float4 _RimColor;
                float _RimPower;
                float _Specular;
                float _Gloss;
                float _Wrap;
                float4 _MainTex_ST;
                float4 cb0_values[12];
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
            Texture2D _MainTex;
            Texture2D t1;
            Texture3D t2;
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
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program91Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
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
                worldPos_xyzw_2 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float2 clipPos_xy_4 = ((worldPos_xyzw_2.yyyy * _RimColor.xyxx)).xy;
                float2 clipPos_xy_5 = (mad(_Color.xyxx, worldPos_xyzw_2.xxxx, clipPos_xy_4.xyxx)).xy;
                float2 clipPos_xy_6 = (mad(cb0_values[6].xyxx, worldPos_xyzw_2.zzzz, clipPos_xy_5.xyxx)).xy;
                o.texcoord3.xy = (mad(_MainTex_ST.xxxy, worldPos_xyzw_2.wwww, clipPos_xy_6.xxxy)).zw;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_4 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7));
                float r0_w_5 = rsqrt(r0_w_4);
                o.texcoord1.xyz = ((r0_w_5.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7))).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program91Output frag(program91Input i)
            {
                program91Output o = (program91Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_2 = ((r2_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
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
                    float r2_w_2 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r4_x_8 = max(r1_w_3, r2_w_2);
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
                float r1_w_5 = saturate(dot(float4(r4_x_10, r4_y_10, r4_z_10, r4_w_4), unity_OcclusionMaskSelector));
                float4 r3_xyzw_5 = t1.Sample(sampler_linear_clamp1, ((((mad(cb0_values[6].xyxx, i.texcoord2.zzzz, (mad(cb0_values[4].xyxx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx).xy);
                float r1_w_6 = (r1_w_5 * r3_xyzw_5.w);
                float r2_w_4 = dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx);
                float r2_w_5 = (r2_w_4 + cb0_values[10].w);
                float r2_w_6 = saturate((r2_w_5 / (cb0_values[10].w + 1)));
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_1.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * cb0_values[10].x);
                float r0_y_8 = exp2(r0_y_7);
                float r0_z_4 = (r1_w_6 * r2_w_6);
                                float4 r3_xyzw_7 = (((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * cb0_values[10].y)).xxxx * _LightColor0.xyzx);
                float r3_x_7 = r3_xyzw_7.x;
                float r3_y_6 = r3_xyzw_7.y;
                float r3_z_2 = r3_xyzw_7.z;
                float4 r3_xyzw_8 = (float4(r3_x_7, r3_y_6, r3_z_2, r3_x_7) * cb0_values[10].zzzz);
                float r3_x_8 = r3_xyzw_8.x;
                float r3_y_7 = r3_xyzw_8.y;
                float r3_z_3 = r3_xyzw_8.z;
                float4 r3_xyzw_9 = (r1_w_6.xxxx * float4(r3_x_8, r3_y_7, r3_z_3, r3_x_8));
                float r3_x_9 = r3_xyzw_9.x;
                float r3_y_8 = r3_xyzw_9.y;
                float r3_z_4 = r3_xyzw_9.z;
                float4 r0_xyzw_9 = mad(((r2_xyz_2.xyzx * _LightColor0.xyzx)).xxyz, r0_z_4.xxxx, float4(r3_x_9, r3_x_9, r3_y_8, r3_z_4));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                o.sv_Target0.xyz = ((float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + (mad(r2_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), ((((r0_y_8.xxxx * cb0_values[9].xyzx)).xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx)).xyzx)).xyz;
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
                float4 _RimColor;
                float _RimPower;
                float _Specular;
                float _Gloss;
                float _Wrap;
                float4 _MainTex_ST;
                float4 cb0_values[12];
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
            Texture2D _MainTex;
            Texture2D t1;
            TextureCube t2;
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
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program90Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
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
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[11].xyxx, cb0_values[11].zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_3 = ((worldPos_xyzw_4.yyyy * _RimColor.xyzx)).xyz;
                float3 clipPos_xyz_4 = (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_3.xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(cb0_values[6].xyzx, worldPos_xyzw_4.zzzz, clipPos_xyz_4.xyzx)).xyz;
                o.texcoord3.xyz = (mad(_MainTex_ST.xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program90Output frag(program90Input i)
            {
                program90Output o = (program90Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_2 = normalize(viewDir_xyz_1);
                float4 r3_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r3_xyz_2 = ((r3_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float3 r4_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
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
                    float r2_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r5_x_8 = max(r1_w_5, r2_w_1);
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
                float r2_w_3 = dot(r4_xyz_4.xyzx, r4_xyz_4.xyzx);
                float4 r5_xyzw_11 = t1.Sample(sampler_linear_clamp2, (r2_w_3.xxxx).xy);
                float4 r4_xyzw_5 = t2.Sample(sampler_linear_clamp1, r4_xyz_4.xyz);
                float r2_w_4 = (r4_xyzw_5.w * r5_xyzw_11.x);
                float r1_w_8 = (r1_w_7 * r2_w_4);
                float r1_y_2 = (cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_2.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_2.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * cb0_values[10].x);
                float r0_y_8 = exp2(r0_y_7);
                float r0_z_4 = (r1_w_8 * saturate(((dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx) + cb0_values[10].w) / r1_y_2)));
                                float4 r1_xyzw_5 = (((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * cb0_values[10].y)).xxxx * _LightColor0.xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_3 = r1_xyzw_5.y;
                float r1_z_2 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = (float4(r1_x_5, r1_y_3, r1_z_2, r1_x_5) * cb0_values[10].zzzz);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                float4 r1_xyzw_7 = (r1_w_8.xxxx * float4(r1_x_6, r1_y_4, r1_z_3, r1_x_6));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_5 = r1_xyzw_7.y;
                float r1_z_4 = r1_xyzw_7.z;
                float4 r0_xyzw_9 = mad(((r3_xyz_2.xyzx * _LightColor0.xyzx)).xxyz, r0_z_4.xxxx, float4(r1_x_7, r1_x_7, r1_y_5, r1_z_4));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                float4 r1_xyzw_8 = (r0_y_8.xxxx * cb0_values[9].xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_z_5 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = (float4(r1_x_8, r1_y_6, r1_z_5, r1_x_8) * float4(0.1, 0.1, 0.1, 0));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_7 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r1_xyzw_10 = mad(r3_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r1_x_9, r1_y_7, r1_z_6, r1_x_9));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_8 = r1_xyzw_10.y;
                float r1_z_7 = r1_xyzw_10.z;
                o.sv_Target0.xyz = ((float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + float4(r1_x_10, r1_y_8, r1_z_7, r1_x_10))).xyz;
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
                float4 _RimColor;
                float _RimPower;
                float _Specular;
                float _Gloss;
                float _Wrap;
                float4 _MainTex_ST;
                float4 cb0_values[12];
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
            Texture2D _MainTex;
            Texture2D t1;
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
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program89Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
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
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float clipPos_x_3 = ((worldPos_xyzw_4.yyyy * _RimColor)).x;
                float clipPos_y_3 = ((worldPos_xyzw_4.yyyy * _RimColor)).y;
                float clipPos_z_3 = ((worldPos_xyzw_4.yyyy * _RimColor)).z;
                float clipPos_w_4 = ((worldPos_xyzw_4.yyyy * _RimColor)).w;
                float4 clipPos_xyzw_4 = mad(_Color, worldPos_xyzw_4.xxxx, float4(clipPos_x_3, clipPos_y_3, clipPos_z_3, clipPos_w_4));
                float4 clipPos_xyzw_5 = mad(cb0_values[6].xyzw, worldPos_xyzw_4.zzzz, clipPos_xyzw_4);
                o.texcoord3.xyzw = mad(_MainTex_ST, worldPos_xyzw_4.wwww, clipPos_xyzw_5);
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
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_2 = normalize(viewDir_xyz_1);
                float4 r3_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r3_xyz_2 = ((r3_xyzw_1.xyzx * cb0_values[8].xyzx)).xyz;
                float4 r4_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord2.zzzz, mad(cb0_values[4].xyzw, i.texcoord2.xxxx, (i.texcoord2.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
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
                    float r2_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r5_x_8 = max(r1_w_5, r2_w_1);
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
                float r2_w_3 = (0 < r4_xyzw_4.z);
                float r2_w_4 = asfloat(asint(r2_w_3) & asint(1065353216));
                float4 r5_xyzw_13 = t1.Sample(sampler_linear_clamp1, (((((r4_xyzw_4.xyxx / r4_xyzw_4.wwww)).xyxx + float4(0.5, 0.5, 0, 0))).xyxx).xy);
                float r2_w_5 = (r2_w_4 * r5_xyzw_13.w);
                float r3_w_2 = dot(r4_xyzw_4.xyzx, r4_xyzw_4.xyzx);
                float4 r4_xyzw_5 = t2.Sample(sampler_linear_clamp2, (r3_w_2.xxxx).xy);
                float r2_w_6 = (r2_w_5 * r4_xyzw_5.x);
                float r1_w_8 = (r1_w_7 * r2_w_6);
                float r1_y_2 = (cb0_values[10].w + 1);
                float3 r0_xyz_2 = (mad(r0_xyz_1.xyzx, r0_w_2.xxxx, unitViewDir_xyz_2.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_2.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * cb0_values[10].x);
                float r0_y_8 = exp2(r0_y_7);
                float r0_z_4 = (r1_w_8 * saturate(((dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx) + cb0_values[10].w) / r1_y_2)));
                                float4 r1_xyzw_5 = (((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * cb0_values[10].y)).xxxx * _LightColor0.xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_3 = r1_xyzw_5.y;
                float r1_z_2 = r1_xyzw_5.z;
                float4 r1_xyzw_6 = (float4(r1_x_5, r1_y_3, r1_z_2, r1_x_5) * cb0_values[10].zzzz);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                float4 r1_xyzw_7 = (r1_w_8.xxxx * float4(r1_x_6, r1_y_4, r1_z_3, r1_x_6));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_5 = r1_xyzw_7.y;
                float r1_z_4 = r1_xyzw_7.z;
                float4 r0_xyzw_9 = mad(((r3_xyz_2.xyzx * _LightColor0.xyzx)).xxyz, r0_z_4.xxxx, float4(r1_x_7, r1_x_7, r1_y_5, r1_z_4));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                float4 r1_xyzw_8 = (r0_y_8.xxxx * cb0_values[9].xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_z_5 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = (float4(r1_x_8, r1_y_6, r1_z_5, r1_x_8) * float4(0.1, 0.1, 0.1, 0));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_7 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r1_xyzw_10 = mad(r3_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), float4(r1_x_9, r1_y_7, r1_z_6, r1_x_9));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_8 = r1_xyzw_10.y;
                float r1_z_7 = r1_xyzw_10.z;
                o.sv_Target0.xyz = ((float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + float4(r1_x_10, r1_y_8, r1_z_7, r1_x_10))).xyz;
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
                float4 _RimColor;
                float _RimPower;
                float _Specular;
                float _Gloss;
                float _Wrap;
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
            Texture2D _MainTex;
            Texture3D t1;
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
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program88Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program88Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program42Output vert(program42Input i)
            {
                program42Output o = (program42Output)0;
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
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program88Output frag(program88Input i)
            {
                program88Output o = (program88Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord2.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_1 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_2 = ((r2_xyzw_1.xyzx * cb0_values[4].xyzx)).xyz;
                float r1_w_1 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r1_w_1)
                {
                    float r1_w_2 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r1_w_2.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r1_w_3 = mad(r3_y_8, 0.25, 0.75);
                    float r2_w_2 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r1_w_3, r2_w_2);
                    float4 r3_xyzw_9 = t1.Sample(sampler_linear_clamp, (float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8)).xyz);
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
                float r1_w_5 = saturate(dot(float4(r3_x_10, r3_y_10, r3_z_10, r3_w_4), unity_OcclusionMaskSelector));
                float r2_w_4 = dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx);
                float r2_w_5 = (r2_w_4 + cb0_values[6].w);
                float r2_w_6 = saturate((r2_w_5 / (cb0_values[6].w + 1)));
                float3 r0_xyz_2 = (mad(viewDir_xyz_1.xyzx, r0_w_2.xxxx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_3 = dot(r0_xyz_2.xyzx, r0_xyz_2.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float r0_y_4 = saturate(dot(i.texcoord1.xyzx, unitViewDir_xyz_1.xyzx));
                float r0_y_5 = (-r0_y_4 + 1);
                float r0_y_6 = log2(r0_y_5);
                float r0_y_7 = (r0_y_6 * cb0_values[6].x);
                float r0_y_8 = exp2(r0_y_7);
                float r0_z_4 = (r1_w_5 * r2_w_6);
                                float4 r3_xyzw_12 = (((pow(saturate(dot(i.texcoord1.xyzx, ((r0_w_4.xxxx * r0_xyz_2.xyzx)).xyzx)), 64) * cb0_values[6].y)).xxxx * _LightColor0.xyzx);
                float r3_x_12 = r3_xyzw_12.x;
                float r3_y_11 = r3_xyzw_12.y;
                float r3_z_11 = r3_xyzw_12.z;
                float4 r3_xyzw_13 = (float4(r3_x_12, r3_y_11, r3_z_11, r3_x_12) * cb0_values[6].zzzz);
                float r3_x_13 = r3_xyzw_13.x;
                float r3_y_12 = r3_xyzw_13.y;
                float r3_z_12 = r3_xyzw_13.z;
                float4 r3_xyzw_14 = (r1_w_5.xxxx * float4(r3_x_13, r3_y_12, r3_z_12, r3_x_13));
                float r3_x_14 = r3_xyzw_14.x;
                float r3_y_13 = r3_xyzw_14.y;
                float r3_z_13 = r3_xyzw_14.z;
                float4 r0_xyzw_9 = mad(((r2_xyz_2.xyzx * _LightColor0.xyzx)).xxyz, r0_z_4.xxxx, float4(r3_x_14, r3_x_14, r3_y_13, r3_z_13));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                float r0_w_5 = r0_xyzw_9.w;
                o.sv_Target0.xyz = ((float4(r0_x_9, r0_z_5, r0_w_5, r0_x_9) + (mad(r2_xyz_2.xyzx, float4(0.02, 0.02, 0.02, 0), ((((r0_y_8.xxxx * cb0_values[5].xyzx)).xyzx * float4(0.1, 0.1, 0.1, 0))).xyzx)).xyzx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Diffuse"
}
