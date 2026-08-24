Shader "Toon/Lit"
{
    Properties
    {
        _Color ("Main Color", Color) = (0.5,0.5,0.5,1)
        _MainTex ("Base (RGB)", 2D) = "" {}
        _Ramp ("Toon Ramp (RGB)", 2D) = "" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
            };
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_Ramp : register(s1);
            SamplerState sampler_MainTex : register(s2);
            Texture2D _MainTex : register(t0);
            Texture2D _Ramp : register(t1);
            Texture3D t2 : register(t2);
            struct program12Input
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
            struct program12Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program32Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program32Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program12Output vert(program12Input i)
            {
                program12Output o = (program12Output)0;
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
                return o;
            }
            #pragma fragment frag
            program32Output frag(program32Input i)
            {
                program32Output o = (program32Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r0_xyz_2 = ((r0_xyzw_1.xyzx * _Color.xyzx)).xyz;
                float r0_w_2 = (unity_ProbeVolumeParams.x == 1);
                float r1_x_10;
                float r1_y_11;
                float r1_z_10;
                float r1_w_4;
                if (r0_w_2)
                {
                    float r0_w_3 = (unity_ProbeVolumeParams.y == 1);
                    float3 r1_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_3.xxxx ? r1_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r1_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r1_y_8 = r1_xyzw_8.y;
                    float r1_z_8 = r1_xyzw_8.z;
                    float r1_w_2 = r1_xyzw_8.w;
                    float r0_w_4 = mad(r1_y_8, 0.25, 0.75);
                    float r1_y_9 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r1_x_8 = max(r0_w_4, r1_y_9);
                    float4 r1_xyzw_9 = t2.Sample(sampler_linear_clamp, (float4(r1_x_8, r1_z_8, r1_w_2, r1_x_8)).xyz);
                    r1_x_10 = r1_xyzw_9.x;
                    r1_y_11 = r1_xyzw_9.y;
                    r1_z_10 = r1_xyzw_9.z;
                    r1_w_4 = r1_xyzw_9.w;
                }
                else
                {
                    float4 r1_xyzw_10 = float4(1, 1, 1, 1);
                    r1_x_10 = r1_xyzw_10.x;
                    r1_y_11 = r1_xyzw_10.y;
                    r1_z_10 = r1_xyzw_10.z;
                    r1_w_4 = r1_xyzw_10.w;
                }
                float r0_w_6 = dot(float4(r1_x_10, r1_y_11, r1_z_10, r1_w_4), unity_OcclusionMaskSelector);
                float4 r1_xyzw_13 = _Ramp.Sample(sampler_Ramp, ((mad(dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx), 0.5, 0.5)).xxxx).xy);
                float4 r1_xyzw_14 = (r1_xyzw_13.xyzx * ((r0_xyz_2.xyzx * _LightColor0.xyzx)).xyzx);
                float r1_x_14 = r1_xyzw_14.x;
                float r1_y_13 = r1_xyzw_14.y;
                float r1_z_12 = r1_xyzw_14.z;
                float r0_w_7 = (r0_w_6 + r0_w_6);
                float4 r1_xyzw_15 = (r0_w_7.xxxx * float4(r1_x_14, r1_y_13, r1_z_12, r1_x_14));
                float r1_x_15 = r1_xyzw_15.x;
                float r1_y_14 = r1_xyzw_15.y;
                float r1_z_13 = r1_xyzw_15.z;
                o.sv_Target0.xyz = (mad(r0_xyz_2.xyzx, i.texcoord3.xyzx, float4(r1_x_15, r1_y_14, r1_z_13, r1_x_15))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[6];
            };
            cbuffer UnityPerFrame : register(b2)
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
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_Ramp : register(s1);
            SamplerState sampler_linear_clamp2 : register(s2);
            SamplerState sampler_MainTex : register(s3);
            Texture2D _MainTex : register(t0);
            Texture2D _Ramp : register(t1);
            Texture2D t2 : register(t2);
            Texture3D t3 : register(t3);
            struct program23Input
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
            struct program23Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program39Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program39Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program23Output vert(program23Input i)
            {
                program23Output o = (program23Output)0;
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
                float3 r1_xyz_7 = (((log2((max((((mad(cb2_values[45].xyzx, r0_z_11.xxxx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1))).xyzx + float4(r3_x_2, r3_y_2, r3_z_2, r3_x_2))).xyzx, float4(0, 0, 0, 0))).xyzx)).xyzx * float4(0.41666666, 0.41666666, 0.41666666, 0))).xyz;
                o.texcoord3.xyz = (max((mad((exp2(r1_xyz_7.xyzx)).xyzx, float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0))).xyzx, float4(0, 0, 0, 0))).xyz;
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
            program39Output frag(program39Input i)
            {
                program39Output o = (program39Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r0_xyz_2 = ((r0_xyzw_1.xyzx * _Color.xyzx)).xyz;
                float r2_x_1 = cb4_values[9].z;
                float r2_y_1 = cb4_values[10].z;
                float r2_z_1 = cb4_values[11].z;
                float r0_w_2 = dot(((-i.texcoord2.xyzx + cb1_values[4].xyzx)).xyzx, float4(r2_x_1, r2_y_1, r2_z_1, r2_x_1));
                float3 r1_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r0_w_3 = mad(cb3_values[25].w, (-r0_w_2 + sqrt(dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx))), r0_w_2);
                float r0_w_4 = mad(r0_w_3, cb3_values[24].z, cb3_values[24].w);
                float r1_x_13;
                float r1_y_13;
                float r1_z_12;
                float r1_w_8;
                if ((cb6_values[0].x == 1))
                {
                    float4 r1_xyzw_4 = (i.texcoord2.yyyy * cb6_values[2].xxyz);
                    float r1_y_4 = r1_xyzw_4.y;
                    float r1_z_4 = r1_xyzw_4.z;
                    float r1_w_2 = r1_xyzw_4.w;
                    float4 r1_xyzw_5 = mad(cb6_values[1].xxyz, i.texcoord2.xxxx, float4(r1_y_4, r1_y_4, r1_z_4, r1_w_2));
                    float r1_y_5 = r1_xyzw_5.y;
                    float r1_z_5 = r1_xyzw_5.z;
                    float r1_w_3 = r1_xyzw_5.w;
                    float4 r1_xyzw_6 = mad(cb6_values[3].xxyz, i.texcoord2.zzzz, float4(r1_y_5, r1_y_5, r1_z_5, r1_w_3));
                    float r1_y_6 = r1_xyzw_6.y;
                    float r1_z_6 = r1_xyzw_6.z;
                    float r1_w_4 = r1_xyzw_6.w;
                    float4 r1_xyzw_7 = (float4(r1_y_6, r1_y_6, r1_z_6, r1_w_4) + cb6_values[4].xxyz);
                    float r1_y_7 = r1_xyzw_7.y;
                    float r1_z_7 = r1_xyzw_7.z;
                    float r1_w_5 = r1_xyzw_7.w;
                    float4 r1_xyzw_9 = (((cb6_values[0].y == 1)).xxxx ? float4(r1_y_7, r1_z_7, r1_w_5, r1_y_7) : i.texcoord2.xyzx);
                    float r1_x_9 = r1_xyzw_9.x;
                    float r1_y_8 = r1_xyzw_9.y;
                    float r1_z_8 = r1_xyzw_9.z;
                    float4 r1_xyzw_10 = (float4(r1_x_9, r1_y_8, r1_z_8, r1_x_9) + -cb6_values[6].xyzx);
                    float r1_x_10 = r1_xyzw_10.x;
                    float r1_y_9 = r1_xyzw_10.y;
                    float r1_z_9 = r1_xyzw_10.z;
                    float r1_y_10 = ((float4(r1_x_10, r1_x_10, r1_y_9, r1_z_9) * cb6_values[5].xxyz)).y;
                    float r1_z_10 = ((float4(r1_x_10, r1_x_10, r1_y_9, r1_z_9) * cb6_values[5].xxyz)).z;
                    float r1_w_6 = ((float4(r1_x_10, r1_x_10, r1_y_9, r1_z_9) * cb6_values[5].xxyz)).w;
                    float r1_y_11 = mad(r1_y_10, 0.25, 0.75);
                    float r1_x_11 = max(r1_y_11, mad(cb6_values[0].z, 0.5, 0.75));
                    float4 r1_xyzw_12 = t3.Sample(sampler_linear_clamp, (float4(r1_x_11, r1_z_10, r1_w_6, r1_x_11)).xyz);
                    r1_x_13 = r1_xyzw_12.x;
                    r1_y_13 = r1_xyzw_12.y;
                    r1_z_12 = r1_xyzw_12.z;
                    r1_w_8 = r1_xyzw_12.w;
                }
                else
                {
                    float r1_x_7 = (float4(1, 1, 1, 1)).x;
                    float4 r1_xyzw_3 = float4(1, 1, 1, 1);
                    float r1_y_3 = r1_xyzw_3.y;
                    float r1_z_3 = r1_xyzw_3.z;
                    float r1_w_1 = r1_xyzw_3.w;
                    r1_x_13 = r1_x_7;
                    r1_y_13 = r1_y_3;
                    r1_z_12 = r1_z_3;
                    r1_w_8 = r1_w_1;
                }
                float4 r1_xyzw_14 = (i.texcoord5.xxyx / i.texcoord5.wwww);
                float r1_y_14 = r1_xyzw_14.y;
                float r1_z_13 = r1_xyzw_14.z;
                float4 r2_xyzw_4 = _Ramp.Sample(sampler_Ramp, (float4(r1_y_14, r1_z_13, r1_y_14, r1_y_14)).xy);
                float r0_w_5 = mad(r0_w_4, (dot(float4(r1_x_13, r1_y_13, r1_z_12, r1_w_8), cb2_values[46].xyzw) + -r2_xyzw_4.x), r2_xyzw_4.x);
                float4 r1_xyzw_18 = t2.Sample(sampler_linear_clamp2, ((mad(dot(i.texcoord1.xyzx, unity_ProbeVolumeParams.xyzx), 0.5, 0.5)).xxxx).xy);
                float4 r2_xyzw_5 = (r0_xyz_2.xyzx * _LightColor0.xyzx);
                float r2_x_5 = r2_xyzw_5.x;
                float r2_y_3 = r2_xyzw_5.y;
                float r2_z_3 = r2_xyzw_5.z;
                float4 r1_xyzw_19 = (r1_xyzw_18.xyzx * float4(r2_x_5, r2_y_3, r2_z_3, r2_x_5));
                float r1_x_19 = r1_xyzw_19.x;
                float r1_y_16 = r1_xyzw_19.y;
                float r1_z_15 = r1_xyzw_19.z;
                float r0_w_6 = (r0_w_5 + r0_w_5);
                float4 r1_xyzw_20 = (r0_w_6.xxxx * float4(r1_x_19, r1_y_16, r1_z_15, r1_x_19));
                float r1_x_20 = r1_xyzw_20.x;
                float r1_y_17 = r1_xyzw_20.y;
                float r1_z_16 = r1_xyzw_20.z;
                float r0_w_7 = (i.texcoord4.x / cb1_values[5].y);
                float r0_w_8 = (-r0_w_7 + 1);
                float r0_w_9 = (r0_w_8 * cb1_values[5].z);
                float r0_w_10 = max(r0_w_9, 0);
                float r0_w_11 = mad(r0_w_10, cb5_values[1].z, cb5_values[1].w);
                o.sv_Target0.xyz = (mad(r0_w_11.xxxx, (((mad(r0_xyz_2.xyzx, i.texcoord3.xyzx, float4(r1_x_20, r1_y_17, r1_z_16, r1_x_20))).xyzx + -cb5_values[0].xyzx)).xyzx, cb5_values[0].xyzx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[6];
            };
            cbuffer UnityPerFrame : register(b2)
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
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_Ramp : register(s1);
            SamplerState sampler_linear_clamp2 : register(s2);
            SamplerState sampler_MainTex : register(s3);
            Texture2D _MainTex : register(t0);
            Texture2D _Ramp : register(t1);
            Texture2D t2 : register(t2);
            Texture3D t3 : register(t3);
            struct program22Input
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
            struct program22Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program38Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program38Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program22Output vert(program22Input i)
            {
                program22Output o = (program22Output)0;
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
            program38Output frag(program38Input i)
            {
                program38Output o = (program38Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r0_xyz_2 = ((r0_xyzw_1.xyzx * _Color.xyzx)).xyz;
                float r2_x_1 = cb4_values[9].z;
                float r2_y_1 = cb4_values[10].z;
                float r2_z_1 = cb4_values[11].z;
                float r0_w_2 = dot(((-i.texcoord2.xyzx + cb1_values[4].xyzx)).xyzx, float4(r2_x_1, r2_y_1, r2_z_1, r2_x_1));
                float3 r1_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r0_w_3 = mad(cb3_values[25].w, (-r0_w_2 + sqrt(dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx))), r0_w_2);
                float r0_w_4 = mad(r0_w_3, cb3_values[24].z, cb3_values[24].w);
                float r1_x_13;
                float r1_y_13;
                float r1_z_12;
                float r1_w_8;
                if ((cb6_values[0].x == 1))
                {
                    float4 r1_xyzw_4 = (i.texcoord2.yyyy * cb6_values[2].xxyz);
                    float r1_y_4 = r1_xyzw_4.y;
                    float r1_z_4 = r1_xyzw_4.z;
                    float r1_w_2 = r1_xyzw_4.w;
                    float4 r1_xyzw_5 = mad(cb6_values[1].xxyz, i.texcoord2.xxxx, float4(r1_y_4, r1_y_4, r1_z_4, r1_w_2));
                    float r1_y_5 = r1_xyzw_5.y;
                    float r1_z_5 = r1_xyzw_5.z;
                    float r1_w_3 = r1_xyzw_5.w;
                    float4 r1_xyzw_6 = mad(cb6_values[3].xxyz, i.texcoord2.zzzz, float4(r1_y_5, r1_y_5, r1_z_5, r1_w_3));
                    float r1_y_6 = r1_xyzw_6.y;
                    float r1_z_6 = r1_xyzw_6.z;
                    float r1_w_4 = r1_xyzw_6.w;
                    float4 r1_xyzw_7 = (float4(r1_y_6, r1_y_6, r1_z_6, r1_w_4) + cb6_values[4].xxyz);
                    float r1_y_7 = r1_xyzw_7.y;
                    float r1_z_7 = r1_xyzw_7.z;
                    float r1_w_5 = r1_xyzw_7.w;
                    float4 r1_xyzw_9 = (((cb6_values[0].y == 1)).xxxx ? float4(r1_y_7, r1_z_7, r1_w_5, r1_y_7) : i.texcoord2.xyzx);
                    float r1_x_9 = r1_xyzw_9.x;
                    float r1_y_8 = r1_xyzw_9.y;
                    float r1_z_8 = r1_xyzw_9.z;
                    float4 r1_xyzw_10 = (float4(r1_x_9, r1_y_8, r1_z_8, r1_x_9) + -cb6_values[6].xyzx);
                    float r1_x_10 = r1_xyzw_10.x;
                    float r1_y_9 = r1_xyzw_10.y;
                    float r1_z_9 = r1_xyzw_10.z;
                    float r1_y_10 = ((float4(r1_x_10, r1_x_10, r1_y_9, r1_z_9) * cb6_values[5].xxyz)).y;
                    float r1_z_10 = ((float4(r1_x_10, r1_x_10, r1_y_9, r1_z_9) * cb6_values[5].xxyz)).z;
                    float r1_w_6 = ((float4(r1_x_10, r1_x_10, r1_y_9, r1_z_9) * cb6_values[5].xxyz)).w;
                    float r1_y_11 = mad(r1_y_10, 0.25, 0.75);
                    float r1_x_11 = max(r1_y_11, mad(cb6_values[0].z, 0.5, 0.75));
                    float4 r1_xyzw_12 = t3.Sample(sampler_linear_clamp, (float4(r1_x_11, r1_z_10, r1_w_6, r1_x_11)).xyz);
                    r1_x_13 = r1_xyzw_12.x;
                    r1_y_13 = r1_xyzw_12.y;
                    r1_z_12 = r1_xyzw_12.z;
                    r1_w_8 = r1_xyzw_12.w;
                }
                else
                {
                    float r1_x_7 = (float4(1, 1, 1, 1)).x;
                    float4 r1_xyzw_3 = float4(1, 1, 1, 1);
                    float r1_y_3 = r1_xyzw_3.y;
                    float r1_z_3 = r1_xyzw_3.z;
                    float r1_w_1 = r1_xyzw_3.w;
                    r1_x_13 = r1_x_7;
                    r1_y_13 = r1_y_3;
                    r1_z_12 = r1_z_3;
                    r1_w_8 = r1_w_1;
                }
                float4 r1_xyzw_14 = (i.texcoord5.xxyx / i.texcoord5.wwww);
                float r1_y_14 = r1_xyzw_14.y;
                float r1_z_13 = r1_xyzw_14.z;
                float4 r2_xyzw_4 = _Ramp.Sample(sampler_Ramp, (float4(r1_y_14, r1_z_13, r1_y_14, r1_y_14)).xy);
                float r0_w_5 = mad(r0_w_4, (dot(float4(r1_x_13, r1_y_13, r1_z_12, r1_w_8), cb2_values[46].xyzw) + -r2_xyzw_4.x), r2_xyzw_4.x);
                float4 r1_xyzw_18 = t2.Sample(sampler_linear_clamp2, ((mad(dot(i.texcoord1.xyzx, unity_ProbeVolumeParams.xyzx), 0.5, 0.5)).xxxx).xy);
                float4 r2_xyzw_5 = (r0_xyz_2.xyzx * _LightColor0.xyzx);
                float r2_x_5 = r2_xyzw_5.x;
                float r2_y_3 = r2_xyzw_5.y;
                float r2_z_3 = r2_xyzw_5.z;
                float4 r1_xyzw_19 = (r1_xyzw_18.xyzx * float4(r2_x_5, r2_y_3, r2_z_3, r2_x_5));
                float r1_x_19 = r1_xyzw_19.x;
                float r1_y_16 = r1_xyzw_19.y;
                float r1_z_15 = r1_xyzw_19.z;
                float r0_w_6 = (r0_w_5 + r0_w_5);
                float4 r1_xyzw_20 = (r0_w_6.xxxx * float4(r1_x_19, r1_y_16, r1_z_15, r1_x_19));
                float r1_x_20 = r1_xyzw_20.x;
                float r1_y_17 = r1_xyzw_20.y;
                float r1_z_16 = r1_xyzw_20.z;
                float r0_w_7 = (i.texcoord4.x / cb1_values[5].y);
                float r0_w_8 = (-r0_w_7 + 1);
                float r0_w_9 = (r0_w_8 * cb1_values[5].z);
                float r0_w_10 = max(r0_w_9, 0);
                float r0_w_11 = mad(r0_w_10, cb5_values[1].z, cb5_values[1].w);
                o.sv_Target0.xyz = (mad(r0_w_11.xxxx, (((mad(r0_xyz_2.xyzx, i.texcoord3.xyzx, float4(r1_x_20, r1_y_17, r1_z_16, r1_x_20))).xyzx + -cb5_values[0].xyzx)).xyzx, cb5_values[0].xyzx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
                float4 cb2_values[46];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[7];
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[21];
            };
            cbuffer cb5 : register(b5)
            {
                float4 cb5_values[2];
            };
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_Ramp : register(s1);
            SamplerState sampler_MainTex : register(s2);
            Texture2D _MainTex : register(t0);
            Texture2D _Ramp : register(t1);
            Texture3D t2 : register(t2);
            struct program21Input
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
            struct program21Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program37Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program37Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program21Output vert(program21Input i)
            {
                program21Output o = (program21Output)0;
                float4 worldPos_xyzw_2 = mad(cb3_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb3_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb3_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb3_values[3].xyzw);
                o.texcoord2.xyz = (mad(cb3_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb4_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb4_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb4_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb4_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = mul(float4x4(cb4_values[17], cb4_values[18], cb4_values[19], cb4_values[20]), worldPos_xyzw_1);
                o.texcoord4.x = mad(max((((clipPos_xyzw_7.z / unity_WorldToObject[1].y) + 1) * unity_WorldToObject[1].z), 0), cb5_values[1].z, cb5_values[1].w);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_12 = dot(i.normal0.xyzx, cb3_values[4].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, cb3_values[5].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, cb3_values[6].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12), float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12));
                float r0_w_9 = rsqrt(r0_w_8);
                float4 unitWorldNormal_xyzw_13 = (r0_w_9.xxxx * float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12));
                float unitWorldNormal_x_13 = unitWorldNormal_xyzw_13.x;
                float unitWorldNormal_y_9 = unitWorldNormal_xyzw_13.y;
                float unitWorldNormal_z_9 = unitWorldNormal_xyzw_13.z;
                o.texcoord1.xyz = (float4(unitWorldNormal_x_13, unitWorldNormal_y_9, unitWorldNormal_z_9, unitWorldNormal_x_13)).xyz;
                float4 r2_xyzw_1 = (float4(unitWorldNormal_y_9, unitWorldNormal_z_9, unitWorldNormal_z_9, unitWorldNormal_x_13) * float4(unitWorldNormal_x_13, unitWorldNormal_y_9, unitWorldNormal_z_9, unitWorldNormal_z_9));
                float r3_x_1 = dot(cb2_values[42].xyzw, r2_xyzw_1);
                float r3_y_1 = dot(cb2_values[43].xyzw, r2_xyzw_1);
                float r3_z_1 = dot(cb2_values[44].xyzw, r2_xyzw_1);
                float4 r1_xyzw_4 = mad(cb2_values[45].xyzx, (mad(unitWorldNormal_x_13, unitWorldNormal_x_13, (unitWorldNormal_y_9 * unitWorldNormal_y_9))).xxxx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_2 = r1_xyzw_4.y;
                float r1_z_2 = r1_xyzw_4.z;
                float r0_w_10 = 1;
                float r2_x_2 = dot(cb2_values[39].xyzw, float4(unitWorldNormal_x_13, unitWorldNormal_y_9, unitWorldNormal_z_9, r0_w_10));
                float r2_y_2 = dot(cb2_values[40].xyzw, float4(unitWorldNormal_x_13, unitWorldNormal_y_9, unitWorldNormal_z_9, r0_w_10));
                float r2_z_2 = dot(cb2_values[41].xyzw, float4(unitWorldNormal_x_13, unitWorldNormal_y_9, unitWorldNormal_z_9, r0_w_10));
                float4 r0_xyzw_14 = (float4(r1_x_4, r1_y_2, r1_z_2, r1_x_4) + float4(r2_x_2, r2_y_2, r2_z_2, r2_x_2));
                float r0_x_14 = r0_xyzw_14.x;
                float r0_y_10 = r0_xyzw_14.y;
                float r0_z_10 = r0_xyzw_14.z;
                float4 r0_xyzw_15 = max(float4(r0_x_14, r0_y_10, r0_z_10, r0_x_14), float4(0, 0, 0, 0));
                float r0_x_15 = r0_xyzw_15.x;
                float r0_y_11 = r0_xyzw_15.y;
                float r0_z_11 = r0_xyzw_15.z;
                float4 r0_xyzw_16 = log2(float4(r0_x_15, r0_y_11, r0_z_11, r0_x_15));
                float r0_x_16 = r0_xyzw_16.x;
                float r0_y_12 = r0_xyzw_16.y;
                float r0_z_12 = r0_xyzw_16.z;
                float4 r0_xyzw_17 = (float4(r0_x_16, r0_y_12, r0_z_12, r0_x_16) * float4(0.41666666, 0.41666666, 0.41666666, 0));
                float r0_x_17 = r0_xyzw_17.x;
                float r0_y_13 = r0_xyzw_17.y;
                float r0_z_13 = r0_xyzw_17.z;
                float4 r0_xyzw_18 = exp2(float4(r0_x_17, r0_y_13, r0_z_13, r0_x_17));
                float r0_x_18 = r0_xyzw_18.x;
                float r0_y_14 = r0_xyzw_18.y;
                float r0_z_14 = r0_xyzw_18.z;
                float4 r0_xyzw_19 = mad(float4(r0_x_18, r0_y_14, r0_z_14, r0_x_18), float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0));
                float r0_x_19 = r0_xyzw_19.x;
                float r0_y_15 = r0_xyzw_19.y;
                float r0_z_15 = r0_xyzw_19.z;
                o.texcoord3.xyz = (max(float4(r0_x_19, r0_y_15, r0_z_15, r0_x_19), float4(0, 0, 0, 0))).xyz;
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program37Output frag(program37Input i)
            {
                program37Output o = (program37Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r0_xyz_2 = ((r0_xyzw_1.xyzx * _Color.xyzx)).xyz;
                float r0_w_2 = (cb3_values[0].x == 1);
                float r1_x_10;
                float r1_y_11;
                float r1_z_10;
                float r1_w_4;
                if (r0_w_2)
                {
                    float r0_w_3 = (cb3_values[0].y == 1);
                    float3 r1_xyz_5 = (((mad(cb3_values[3].xyzx, i.texcoord2.zzzz, (mad(cb3_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb3_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb3_values[4].xyzx)).xyz;
                    float4 r1_xyzw_8 = (((((r0_w_3.xxxx ? r1_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb3_values[6].xyzx)).xxyz * cb3_values[5].xxyz);
                    float r1_y_8 = r1_xyzw_8.y;
                    float r1_z_8 = r1_xyzw_8.z;
                    float r1_w_2 = r1_xyzw_8.w;
                    float r0_w_4 = mad(r1_y_8, 0.25, 0.75);
                    float r1_y_9 = mad(cb3_values[0].z, 0.5, 0.75);
                    float r1_x_8 = max(r0_w_4, r1_y_9);
                    float4 r1_xyzw_9 = t2.Sample(sampler_linear_clamp, (float4(r1_x_8, r1_z_8, r1_w_2, r1_x_8)).xyz);
                    r1_x_10 = r1_xyzw_9.x;
                    r1_y_11 = r1_xyzw_9.y;
                    r1_z_10 = r1_xyzw_9.z;
                    r1_w_4 = r1_xyzw_9.w;
                }
                else
                {
                    float4 r1_xyzw_10 = float4(1, 1, 1, 1);
                    r1_x_10 = r1_xyzw_10.x;
                    r1_y_11 = r1_xyzw_10.y;
                    r1_z_10 = r1_xyzw_10.z;
                    r1_w_4 = r1_xyzw_10.w;
                }
                float r0_w_6 = dot(float4(r1_x_10, r1_y_11, r1_z_10, r1_w_4), unity_OcclusionMaskSelector);
                float4 r1_xyzw_13 = _Ramp.Sample(sampler_Ramp, ((mad(dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx), 0.5, 0.5)).xxxx).xy);
                float4 r1_xyzw_14 = (r1_xyzw_13.xyzx * ((r0_xyz_2.xyzx * _LightColor0.xyzx)).xyzx);
                float r1_x_14 = r1_xyzw_14.x;
                float r1_y_13 = r1_xyzw_14.y;
                float r1_z_12 = r1_xyzw_14.z;
                float r0_w_7 = (r0_w_6 + r0_w_6);
                float4 r1_xyzw_15 = (r0_w_7.xxxx * float4(r1_x_14, r1_y_13, r1_z_12, r1_x_14));
                float r1_x_15 = r1_xyzw_15.x;
                float r1_y_14 = r1_xyzw_15.y;
                float r1_z_13 = r1_xyzw_15.z;
                float TEXCOORD0_w_8 = i.texcoord4.x;
                o.sv_Target0.xyz = (mad(TEXCOORD0_w_8.xxxx, (((mad(r0_xyz_2.xyzx, i.texcoord3.xyzx, float4(r1_x_15, r1_y_14, r1_z_13, r1_x_15))).xyzx + -unity_ProbeVolumeParams.xyzx)).xyzx, unity_ProbeVolumeParams.xyzx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
            };
            cbuffer UnityPerFrame : register(b2)
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
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[2];
            };
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_Ramp : register(s1);
            SamplerState sampler_MainTex : register(s2);
            Texture2D _MainTex : register(t0);
            Texture2D _Ramp : register(t1);
            Texture3D t2 : register(t2);
            struct program20Input
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
            struct program20Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program36Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program36Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program20Output vert(program20Input i)
            {
                program20Output o = (program20Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord4.x = mad(max((((clipPos_xyzw_7.z / unity_WorldToObject[1].y) + 1) * unity_WorldToObject[1].z), 0), cb4_values[1].z, cb4_values[1].w);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_12 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12), float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12))).xyz;
                o.texcoord3.xyz = (float4(0, 0, 0, 0)).xyz;
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program36Output frag(program36Input i)
            {
                program36Output o = (program36Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r0_xyz_2 = ((r0_xyzw_1.xyzx * _Color.xyzx)).xyz;
                float r0_w_2 = (cb3_values[0].x == 1);
                float r1_x_10;
                float r1_y_11;
                float r1_z_10;
                float r1_w_4;
                if (r0_w_2)
                {
                    float r0_w_3 = (cb3_values[0].y == 1);
                    float3 r1_xyz_5 = (((mad(cb3_values[3].xyzx, i.texcoord2.zzzz, (mad(cb3_values[1].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb3_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb3_values[4].xyzx)).xyz;
                    float4 r1_xyzw_8 = (((((r0_w_3.xxxx ? r1_xyz_5.xyzx : i.texcoord2.xyzx)).xyzx + -cb3_values[6].xyzx)).xxyz * cb3_values[5].xxyz);
                    float r1_y_8 = r1_xyzw_8.y;
                    float r1_z_8 = r1_xyzw_8.z;
                    float r1_w_2 = r1_xyzw_8.w;
                    float r0_w_4 = mad(r1_y_8, 0.25, 0.75);
                    float r1_y_9 = mad(cb3_values[0].z, 0.5, 0.75);
                    float r1_x_8 = max(r0_w_4, r1_y_9);
                    float4 r1_xyzw_9 = t2.Sample(sampler_linear_clamp, (float4(r1_x_8, r1_z_8, r1_w_2, r1_x_8)).xyz);
                    r1_x_10 = r1_xyzw_9.x;
                    r1_y_11 = r1_xyzw_9.y;
                    r1_z_10 = r1_xyzw_9.z;
                    r1_w_4 = r1_xyzw_9.w;
                }
                else
                {
                    float4 r1_xyzw_10 = float4(1, 1, 1, 1);
                    r1_x_10 = r1_xyzw_10.x;
                    r1_y_11 = r1_xyzw_10.y;
                    r1_z_10 = r1_xyzw_10.z;
                    r1_w_4 = r1_xyzw_10.w;
                }
                float r0_w_6 = dot(float4(r1_x_10, r1_y_11, r1_z_10, r1_w_4), unity_OcclusionMaskSelector);
                float4 r1_xyzw_13 = _Ramp.Sample(sampler_Ramp, ((mad(dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx), 0.5, 0.5)).xxxx).xy);
                float4 r1_xyzw_14 = (r1_xyzw_13.xyzx * ((r0_xyz_2.xyzx * _LightColor0.xyzx)).xyzx);
                float r1_x_14 = r1_xyzw_14.x;
                float r1_y_13 = r1_xyzw_14.y;
                float r1_z_12 = r1_xyzw_14.z;
                float r0_w_7 = (r0_w_6 + r0_w_6);
                float4 r1_xyzw_15 = (r0_w_7.xxxx * float4(r1_x_14, r1_y_13, r1_z_12, r1_x_14));
                float r1_x_15 = r1_xyzw_15.x;
                float r1_y_14 = r1_xyzw_15.y;
                float r1_z_13 = r1_xyzw_15.z;
                float TEXCOORD0_w_8 = i.texcoord4.x;
                o.sv_Target0.xyz = (mad(TEXCOORD0_w_8.xxxx, (((mad(r0_xyz_2.xyzx, i.texcoord3.xyzx, float4(r1_x_15, r1_y_14, r1_z_13, r1_x_15))).xyzx + -unity_ProbeVolumeParams.xyzx)).xyzx, unity_ProbeVolumeParams.xyzx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[5];
            };
            cbuffer UnityPerFrame : register(b2)
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
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_Ramp : register(s1);
            SamplerState sampler_linear_clamp2 : register(s2);
            SamplerState sampler_MainTex : register(s3);
            Texture2D _MainTex : register(t0);
            Texture2D _Ramp : register(t1);
            Texture2D t2 : register(t2);
            Texture3D t3 : register(t3);
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
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program35Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program35Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program15Output vert(program15Input i)
            {
                program15Output o = (program15Output)0;
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
                                float3 r1_xyz_8 = (pow(max((float4(r2_x_3, r2_y_1, r2_z_1, r2_x_3) + float4(r3_x_2, r3_y_2, r3_z_2, r3_x_2)).xyz, float3(0, 0, 0)), float3(0.41666666, 0.41666666, 0.41666666)));
                o.texcoord3.xyz = (max((mad(r1_xyz_8.xyzx, float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0))).xyzx, float4(0, 0, 0, 0))).xyz;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r1_xyzw_10 = (float4(clipPos_xyzw_7.x, clipPos_xyzw_7.x, clipPos_xyzw_7.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_z_10 = r1_xyzw_10.z;
                float r1_w_5 = r1_xyzw_10.w;
                o.texcoord5.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord5.xy = ((r1_z_10.xxxx + float4(r1_x_10, r1_w_5, r1_x_10, r1_x_10))).xy;
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program35Output frag(program35Input i)
            {
                program35Output o = (program35Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r0_xyz_2 = ((r0_xyzw_1.xyzx * _Color.xyzx)).xyz;
                float r2_x_1 = cb4_values[9].z;
                float r2_y_1 = cb4_values[10].z;
                float r2_z_1 = cb4_values[11].z;
                float r0_w_2 = dot(((-i.texcoord2.xyzx + cb1_values[4].xyzx)).xyzx, float4(r2_x_1, r2_y_1, r2_z_1, r2_x_1));
                float3 r1_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r0_w_3 = mad(cb3_values[25].w, (-r0_w_2 + sqrt(dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx))), r0_w_2);
                float r0_w_4 = mad(r0_w_3, cb3_values[24].z, cb3_values[24].w);
                float r1_x_13;
                float r1_y_13;
                float r1_z_12;
                float r1_w_8;
                if ((cb5_values[0].x == 1))
                {
                    float4 r1_xyzw_4 = (i.texcoord2.yyyy * cb5_values[2].xxyz);
                    float r1_y_4 = r1_xyzw_4.y;
                    float r1_z_4 = r1_xyzw_4.z;
                    float r1_w_2 = r1_xyzw_4.w;
                    float4 r1_xyzw_5 = mad(cb5_values[1].xxyz, i.texcoord2.xxxx, float4(r1_y_4, r1_y_4, r1_z_4, r1_w_2));
                    float r1_y_5 = r1_xyzw_5.y;
                    float r1_z_5 = r1_xyzw_5.z;
                    float r1_w_3 = r1_xyzw_5.w;
                    float4 r1_xyzw_6 = mad(cb5_values[3].xxyz, i.texcoord2.zzzz, float4(r1_y_5, r1_y_5, r1_z_5, r1_w_3));
                    float r1_y_6 = r1_xyzw_6.y;
                    float r1_z_6 = r1_xyzw_6.z;
                    float r1_w_4 = r1_xyzw_6.w;
                    float4 r1_xyzw_7 = (float4(r1_y_6, r1_y_6, r1_z_6, r1_w_4) + cb5_values[4].xxyz);
                    float r1_y_7 = r1_xyzw_7.y;
                    float r1_z_7 = r1_xyzw_7.z;
                    float r1_w_5 = r1_xyzw_7.w;
                    float4 r1_xyzw_9 = (((cb5_values[0].y == 1)).xxxx ? float4(r1_y_7, r1_z_7, r1_w_5, r1_y_7) : i.texcoord2.xyzx);
                    float r1_x_9 = r1_xyzw_9.x;
                    float r1_y_8 = r1_xyzw_9.y;
                    float r1_z_8 = r1_xyzw_9.z;
                    float4 r1_xyzw_10 = (float4(r1_x_9, r1_y_8, r1_z_8, r1_x_9) + -cb5_values[6].xyzx);
                    float r1_x_10 = r1_xyzw_10.x;
                    float r1_y_9 = r1_xyzw_10.y;
                    float r1_z_9 = r1_xyzw_10.z;
                    float r1_y_10 = ((float4(r1_x_10, r1_x_10, r1_y_9, r1_z_9) * cb5_values[5].xxyz)).y;
                    float r1_z_10 = ((float4(r1_x_10, r1_x_10, r1_y_9, r1_z_9) * cb5_values[5].xxyz)).z;
                    float r1_w_6 = ((float4(r1_x_10, r1_x_10, r1_y_9, r1_z_9) * cb5_values[5].xxyz)).w;
                    float r1_y_11 = mad(r1_y_10, 0.25, 0.75);
                    float r1_x_11 = max(r1_y_11, mad(cb5_values[0].z, 0.5, 0.75));
                    float4 r1_xyzw_12 = t3.Sample(sampler_linear_clamp, (float4(r1_x_11, r1_z_10, r1_w_6, r1_x_11)).xyz);
                    r1_x_13 = r1_xyzw_12.x;
                    r1_y_13 = r1_xyzw_12.y;
                    r1_z_12 = r1_xyzw_12.z;
                    r1_w_8 = r1_xyzw_12.w;
                }
                else
                {
                    float r1_x_7 = (float4(1, 1, 1, 1)).x;
                    float4 r1_xyzw_3 = float4(1, 1, 1, 1);
                    float r1_y_3 = r1_xyzw_3.y;
                    float r1_z_3 = r1_xyzw_3.z;
                    float r1_w_1 = r1_xyzw_3.w;
                    r1_x_13 = r1_x_7;
                    r1_y_13 = r1_y_3;
                    r1_z_12 = r1_z_3;
                    r1_w_8 = r1_w_1;
                }
                float4 r1_xyzw_14 = (i.texcoord5.xxyx / i.texcoord5.wwww);
                float r1_y_14 = r1_xyzw_14.y;
                float r1_z_13 = r1_xyzw_14.z;
                float4 r2_xyzw_4 = _Ramp.Sample(sampler_Ramp, (float4(r1_y_14, r1_z_13, r1_y_14, r1_y_14)).xy);
                float r0_w_5 = mad(r0_w_4, (dot(float4(r1_x_13, r1_y_13, r1_z_12, r1_w_8), cb2_values[46].xyzw) + -r2_xyzw_4.x), r2_xyzw_4.x);
                float4 r1_xyzw_18 = t2.Sample(sampler_linear_clamp2, ((mad(dot(i.texcoord1.xyzx, unity_ProbeVolumeParams.xyzx), 0.5, 0.5)).xxxx).xy);
                float4 r2_xyzw_5 = (r0_xyz_2.xyzx * _LightColor0.xyzx);
                float r2_x_5 = r2_xyzw_5.x;
                float r2_y_3 = r2_xyzw_5.y;
                float r2_z_3 = r2_xyzw_5.z;
                float4 r1_xyzw_19 = (r1_xyzw_18.xyzx * float4(r2_x_5, r2_y_3, r2_z_3, r2_x_5));
                float r1_x_19 = r1_xyzw_19.x;
                float r1_y_16 = r1_xyzw_19.y;
                float r1_z_15 = r1_xyzw_19.z;
                float r0_w_6 = (r0_w_5 + r0_w_5);
                float4 r1_xyzw_20 = (r0_w_6.xxxx * float4(r1_x_19, r1_y_16, r1_z_15, r1_x_19));
                float r1_x_20 = r1_xyzw_20.x;
                float r1_y_17 = r1_xyzw_20.y;
                float r1_z_16 = r1_xyzw_20.z;
                o.sv_Target0.xyz = (mad(r0_xyz_2.xyzx, i.texcoord3.xyzx, float4(r1_x_20, r1_y_17, r1_z_16, r1_x_20))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[5];
            };
            cbuffer UnityPerFrame : register(b2)
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
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_Ramp : register(s1);
            SamplerState sampler_linear_clamp2 : register(s2);
            SamplerState sampler_MainTex : register(s3);
            Texture2D _MainTex : register(t0);
            Texture2D _Ramp : register(t1);
            Texture2D t2 : register(t2);
            Texture3D t3 : register(t3);
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
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program34Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program34Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program14Output vert(program14Input i)
            {
                program14Output o = (program14Output)0;
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
            program34Output frag(program34Input i)
            {
                program34Output o = (program34Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r0_xyz_2 = ((r0_xyzw_1.xyzx * _Color.xyzx)).xyz;
                float r2_x_1 = cb4_values[9].z;
                float r2_y_1 = cb4_values[10].z;
                float r2_z_1 = cb4_values[11].z;
                float r0_w_2 = dot(((-i.texcoord2.xyzx + cb1_values[4].xyzx)).xyzx, float4(r2_x_1, r2_y_1, r2_z_1, r2_x_1));
                float3 r1_xyz_2 = ((i.texcoord2.xyzx + -cb3_values[25].xyzx)).xyz;
                float r0_w_3 = mad(cb3_values[25].w, (-r0_w_2 + sqrt(dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx))), r0_w_2);
                float r0_w_4 = mad(r0_w_3, cb3_values[24].z, cb3_values[24].w);
                float r1_x_13;
                float r1_y_13;
                float r1_z_12;
                float r1_w_8;
                if ((cb5_values[0].x == 1))
                {
                    float4 r1_xyzw_4 = (i.texcoord2.yyyy * cb5_values[2].xxyz);
                    float r1_y_4 = r1_xyzw_4.y;
                    float r1_z_4 = r1_xyzw_4.z;
                    float r1_w_2 = r1_xyzw_4.w;
                    float4 r1_xyzw_5 = mad(cb5_values[1].xxyz, i.texcoord2.xxxx, float4(r1_y_4, r1_y_4, r1_z_4, r1_w_2));
                    float r1_y_5 = r1_xyzw_5.y;
                    float r1_z_5 = r1_xyzw_5.z;
                    float r1_w_3 = r1_xyzw_5.w;
                    float4 r1_xyzw_6 = mad(cb5_values[3].xxyz, i.texcoord2.zzzz, float4(r1_y_5, r1_y_5, r1_z_5, r1_w_3));
                    float r1_y_6 = r1_xyzw_6.y;
                    float r1_z_6 = r1_xyzw_6.z;
                    float r1_w_4 = r1_xyzw_6.w;
                    float4 r1_xyzw_7 = (float4(r1_y_6, r1_y_6, r1_z_6, r1_w_4) + cb5_values[4].xxyz);
                    float r1_y_7 = r1_xyzw_7.y;
                    float r1_z_7 = r1_xyzw_7.z;
                    float r1_w_5 = r1_xyzw_7.w;
                    float4 r1_xyzw_9 = (((cb5_values[0].y == 1)).xxxx ? float4(r1_y_7, r1_z_7, r1_w_5, r1_y_7) : i.texcoord2.xyzx);
                    float r1_x_9 = r1_xyzw_9.x;
                    float r1_y_8 = r1_xyzw_9.y;
                    float r1_z_8 = r1_xyzw_9.z;
                    float4 r1_xyzw_10 = (float4(r1_x_9, r1_y_8, r1_z_8, r1_x_9) + -cb5_values[6].xyzx);
                    float r1_x_10 = r1_xyzw_10.x;
                    float r1_y_9 = r1_xyzw_10.y;
                    float r1_z_9 = r1_xyzw_10.z;
                    float r1_y_10 = ((float4(r1_x_10, r1_x_10, r1_y_9, r1_z_9) * cb5_values[5].xxyz)).y;
                    float r1_z_10 = ((float4(r1_x_10, r1_x_10, r1_y_9, r1_z_9) * cb5_values[5].xxyz)).z;
                    float r1_w_6 = ((float4(r1_x_10, r1_x_10, r1_y_9, r1_z_9) * cb5_values[5].xxyz)).w;
                    float r1_y_11 = mad(r1_y_10, 0.25, 0.75);
                    float r1_x_11 = max(r1_y_11, mad(cb5_values[0].z, 0.5, 0.75));
                    float4 r1_xyzw_12 = t3.Sample(sampler_linear_clamp, (float4(r1_x_11, r1_z_10, r1_w_6, r1_x_11)).xyz);
                    r1_x_13 = r1_xyzw_12.x;
                    r1_y_13 = r1_xyzw_12.y;
                    r1_z_12 = r1_xyzw_12.z;
                    r1_w_8 = r1_xyzw_12.w;
                }
                else
                {
                    float r1_x_7 = (float4(1, 1, 1, 1)).x;
                    float4 r1_xyzw_3 = float4(1, 1, 1, 1);
                    float r1_y_3 = r1_xyzw_3.y;
                    float r1_z_3 = r1_xyzw_3.z;
                    float r1_w_1 = r1_xyzw_3.w;
                    r1_x_13 = r1_x_7;
                    r1_y_13 = r1_y_3;
                    r1_z_12 = r1_z_3;
                    r1_w_8 = r1_w_1;
                }
                float4 r1_xyzw_14 = (i.texcoord5.xxyx / i.texcoord5.wwww);
                float r1_y_14 = r1_xyzw_14.y;
                float r1_z_13 = r1_xyzw_14.z;
                float4 r2_xyzw_4 = _Ramp.Sample(sampler_Ramp, (float4(r1_y_14, r1_z_13, r1_y_14, r1_y_14)).xy);
                float r0_w_5 = mad(r0_w_4, (dot(float4(r1_x_13, r1_y_13, r1_z_12, r1_w_8), cb2_values[46].xyzw) + -r2_xyzw_4.x), r2_xyzw_4.x);
                float4 r1_xyzw_18 = t2.Sample(sampler_linear_clamp2, ((mad(dot(i.texcoord1.xyzx, unity_ProbeVolumeParams.xyzx), 0.5, 0.5)).xxxx).xy);
                float4 r2_xyzw_5 = (r0_xyz_2.xyzx * _LightColor0.xyzx);
                float r2_x_5 = r2_xyzw_5.x;
                float r2_y_3 = r2_xyzw_5.y;
                float r2_z_3 = r2_xyzw_5.z;
                float4 r1_xyzw_19 = (r1_xyzw_18.xyzx * float4(r2_x_5, r2_y_3, r2_z_3, r2_x_5));
                float r1_x_19 = r1_xyzw_19.x;
                float r1_y_16 = r1_xyzw_19.y;
                float r1_z_15 = r1_xyzw_19.z;
                float r0_w_6 = (r0_w_5 + r0_w_5);
                float4 r1_xyzw_20 = (r0_w_6.xxxx * float4(r1_x_19, r1_y_16, r1_z_15, r1_x_19));
                float r1_x_20 = r1_xyzw_20.x;
                float r1_y_17 = r1_xyzw_20.y;
                float r1_z_16 = r1_xyzw_20.z;
                o.sv_Target0.xyz = (mad(r0_xyz_2.xyzx, i.texcoord3.xyzx, float4(r1_x_20, r1_y_17, r1_z_16, r1_x_20))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[46];
            };
            cbuffer UnityPerFrame : register(b2)
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
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_Ramp : register(s1);
            SamplerState sampler_MainTex : register(s2);
            Texture2D _MainTex : register(t0);
            Texture2D _Ramp : register(t1);
            Texture3D t2 : register(t2);
            struct program13Input
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
            struct program13Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program33Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program33Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program13Output vert(program13Input i)
            {
                program13Output o = (program13Output)0;
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
                                float3 r0_xyz_13 = (pow(max((float4(r1_x_4, r1_y_2, r1_z_2, r1_x_4) + float4(r2_x_2, r2_y_2, r2_z_2, r2_x_2)).xyz, float3(0, 0, 0)), float3(0.41666666, 0.41666666, 0.41666666)));
                o.texcoord3.xyz = (max((mad(r0_xyz_13.xyzx, float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0))).xyzx, float4(0, 0, 0, 0))).xyz;
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program33Output frag(program33Input i)
            {
                program33Output o = (program33Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r0_xyz_2 = ((r0_xyzw_1.xyzx * _Color.xyzx)).xyz;
                float r0_w_2 = (unity_ProbeVolumeParams.x == 1);
                float r1_x_10;
                float r1_y_11;
                float r1_z_10;
                float r1_w_4;
                if (r0_w_2)
                {
                    float r0_w_3 = (unity_ProbeVolumeParams.y == 1);
                    float3 r1_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_3.xxxx ? r1_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r1_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r1_y_8 = r1_xyzw_8.y;
                    float r1_z_8 = r1_xyzw_8.z;
                    float r1_w_2 = r1_xyzw_8.w;
                    float r0_w_4 = mad(r1_y_8, 0.25, 0.75);
                    float r1_y_9 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r1_x_8 = max(r0_w_4, r1_y_9);
                    float4 r1_xyzw_9 = t2.Sample(sampler_linear_clamp, (float4(r1_x_8, r1_z_8, r1_w_2, r1_x_8)).xyz);
                    r1_x_10 = r1_xyzw_9.x;
                    r1_y_11 = r1_xyzw_9.y;
                    r1_z_10 = r1_xyzw_9.z;
                    r1_w_4 = r1_xyzw_9.w;
                }
                else
                {
                    float4 r1_xyzw_10 = float4(1, 1, 1, 1);
                    r1_x_10 = r1_xyzw_10.x;
                    r1_y_11 = r1_xyzw_10.y;
                    r1_z_10 = r1_xyzw_10.z;
                    r1_w_4 = r1_xyzw_10.w;
                }
                float r0_w_6 = dot(float4(r1_x_10, r1_y_11, r1_z_10, r1_w_4), unity_OcclusionMaskSelector);
                float4 r1_xyzw_13 = _Ramp.Sample(sampler_Ramp, ((mad(dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx), 0.5, 0.5)).xxxx).xy);
                float4 r1_xyzw_14 = (r1_xyzw_13.xyzx * ((r0_xyz_2.xyzx * _LightColor0.xyzx)).xyzx);
                float r1_x_14 = r1_xyzw_14.x;
                float r1_y_13 = r1_xyzw_14.y;
                float r1_z_12 = r1_xyzw_14.z;
                float r0_w_7 = (r0_w_6 + r0_w_6);
                float4 r1_xyzw_15 = (r0_w_7.xxxx * float4(r1_x_14, r1_y_13, r1_z_12, r1_x_14));
                float r1_x_15 = r1_xyzw_15.x;
                float r1_y_14 = r1_xyzw_15.y;
                float r1_z_13 = r1_xyzw_15.z;
                o.sv_Target0.xyz = (mad(r0_xyz_2.xyzx, i.texcoord3.xyzx, float4(r1_x_15, r1_y_14, r1_z_13, r1_x_15))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
            };
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_Ramp : register(s1);
            SamplerState sampler_linear_clamp2 : register(s2);
            SamplerState sampler_MainTex : register(s3);
            Texture2D _MainTex : register(t0);
            Texture2D _Ramp : register(t1);
            Texture2D t2 : register(t2);
            Texture3D t3 : register(t3);
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
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program58Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program58Output
            {
                float4 sv_Target0 : SV_Target0;
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
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_3 = ((worldPos_xyzw_4.yyyy * _MainTex_ST.xyzx)).xyz;
                float3 clipPos_xyz_4 = (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_3.xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(cb0_values[6].xyzx, worldPos_xyzw_4.zzzz, clipPos_xyz_4.xyzx)).xyz;
                o.texcoord3.xyz = (mad(cb0_values[7].xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program58Output frag(program58Input i)
            {
                program58Output o = (program58Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_2 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r1_w_2);
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
                float r0_w_7 = dot(float4(r3_x_10, r3_y_10, r3_z_10, r3_w_4), unity_OcclusionMaskSelector);
                float r1_w_4 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float4 r2_xyzw_5 = _Ramp.Sample(sampler_Ramp, (r1_w_4.xxxx).xy);
                float4 r3_xyzw_11 = t2.Sample(sampler_linear_clamp2, ((mad(dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0.5, 0.5)).xxxx).xy);
                float4 r0_xyzw_5 = (((r1_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * _LightColor0.xyzx);
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_3 = r0_xyzw_5.y;
                float r0_z_3 = r0_xyzw_5.z;
                float4 r0_xyzw_6 = (r3_xyzw_11.xyzx * float4(r0_x_5, r0_y_3, r0_z_3, r0_x_5));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_4 = r0_xyzw_6.y;
                float r0_z_4 = r0_xyzw_6.z;
                float r0_w_8 = dot(r2_xyzw_5.xxxx, r0_w_7.xxxx);
                o.sv_Target0.xyz = ((r0_w_8.xxxx * float4(r0_x_6, r0_y_4, r0_z_4, r0_x_6))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
            };
            cbuffer UnityPerFrame : register(b2)
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
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[2];
            };
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_Ramp : register(s1);
            SamplerState sampler_linear_clamp2 : register(s2);
            SamplerState sampler_MainTex : register(s3);
            Texture2D _MainTex : register(t0);
            Texture2D _Ramp : register(t1);
            Texture2D t2 : register(t2);
            Texture3D t3 : register(t3);
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
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program67Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program67Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program53Output vert(program53Input i)
            {
                program53Output o = (program53Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord5.x = mad(max((((clipPos_xyzw_2.z / unity_WorldToObject[1].y) + 1) * unity_WorldToObject[1].z), 0), cb4_values[1].z, cb4_values[1].w);
                float4 r1_xyzw_7 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                o.texcoord3.xy = (mad(cb0_values[7].xxxy, r1_xyzw_7.wwww, (mad(cb0_values[6].xyxx, r1_xyzw_7.zzzz, (mad(_Color.xyxx, r1_xyzw_7.xxxx, ((r1_xyzw_7.yyyy * _MainTex_ST.xyxx)).xyxx)).xyxx)).xxxy)).zw;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_w_4 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7));
                float r0_w_5 = rsqrt(r0_w_4);
                o.texcoord1.xyz = ((r0_w_5.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_4, worldNormal_x_7))).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program67Output frag(program67Input i)
            {
                program67Output o = (program67Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float r0_w_2 = (unity_ProbeVolumeParams.x == 1);
                float r2_x_10;
                float r2_y_10;
                float r2_z_10;
                float r2_w_4;
                if (r0_w_2)
                {
                    float r0_w_3 = (unity_ProbeVolumeParams.y == 1);
                    float3 r2_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_3.xxxx ? r2_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r2_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_8 = r2_xyzw_8.z;
                    float r2_w_2 = r2_xyzw_8.w;
                    float r0_w_4 = mad(r2_y_8, 0.25, 0.75);
                    float r1_z_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r2_x_8 = max(r0_w_4, r1_z_1);
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
                float r0_w_6 = dot(float4(r2_x_10, r2_y_10, r2_z_10, r2_w_4), unity_OcclusionMaskSelector);
                float4 r1_xyzw_5 = _Ramp.Sample(sampler_Ramp, ((((mad(cb0_values[6].xyxx, i.texcoord2.zzzz, (mad(cb0_values[4].xyxx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx).xy);
                float4 r2_xyzw_11 = t2.Sample(sampler_linear_clamp2, ((mad(dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx), 0.5, 0.5)).xxxx).xy);
                float r0_w_7 = dot(r1_xyzw_5.wwww, r0_w_6.xxxx);
                float TEXCOORD1_w_8 = i.texcoord5.x;
                o.sv_Target0.xyz = ((((r0_w_7.xxxx * ((r2_xyzw_11.xyzx * ((((r0_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * _LightColor0.xyzx)).xyzx)).xyzx)).xyzx * TEXCOORD1_w_8.xxxx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
            };
            cbuffer UnityPerFrame : register(b2)
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
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[2];
            };
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_linear_clamp1 : register(s1);
            SamplerState sampler_Ramp : register(s2);
            SamplerState sampler_linear_clamp3 : register(s3);
            SamplerState sampler_MainTex : register(s4);
            Texture2D _MainTex : register(t0);
            Texture2D _Ramp : register(t1);
            TextureCube t2 : register(t2);
            Texture2D t3 : register(t3);
            Texture3D t4 : register(t4);
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
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program66Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program66Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program52Output vert(program52Input i)
            {
                program52Output o = (program52Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord5.x = mad(max((((clipPos_xyzw_2.z / unity_WorldToObject[1].y) + 1) * unity_WorldToObject[1].z), 0), cb4_values[1].z, cb4_values[1].w);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7))).xyz;
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 r1_xyzw_8 = (r0_xyzw_4.yyyy * _MainTex_ST.xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_4 = r1_xyzw_8.y;
                float r1_z_4 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = mad(_Color.xyzx, r0_xyzw_4.xxxx, float4(r1_x_8, r1_y_4, r1_z_4, r1_x_8));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_5 = r1_xyzw_9.y;
                float r1_z_5 = r1_xyzw_9.z;
                o.texcoord3.xyz = (mad(cb0_values[7].xyzx, r0_xyzw_4.wwww, (mad(cb0_values[6].xyzx, r0_xyzw_4.zzzz, float4(r1_x_9, r1_y_5, r1_z_5, r1_x_9))).xyzx)).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program66Output frag(program66Input i)
            {
                program66Output o = (program66Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_2 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r1_w_2);
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
                float r0_w_7 = dot(float4(r3_x_10, r3_y_10, r3_z_10, r3_w_4), unity_OcclusionMaskSelector);
                float r1_w_4 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float4 r3_xyzw_11 = _Ramp.Sample(sampler_Ramp, (r1_w_4.xxxx).xy);
                float4 r2_xyzw_5 = t2.Sample(sampler_linear_clamp1, r2_xyz_4.xyz);
                float r1_w_5 = (r2_xyzw_5.w * r3_xyzw_11.x);
                float4 r2_xyzw_6 = t3.Sample(sampler_linear_clamp3, ((mad(dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0.5, 0.5)).xxxx).xy);
                float4 r0_xyzw_5 = (((r1_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * _LightColor0.xyzx);
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_3 = r0_xyzw_5.y;
                float r0_z_3 = r0_xyzw_5.z;
                float4 r0_xyzw_6 = (r2_xyzw_6.xyzx * float4(r0_x_5, r0_y_3, r0_z_3, r0_x_5));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_4 = r0_xyzw_6.y;
                float r0_z_4 = r0_xyzw_6.z;
                float r0_w_8 = dot(r1_w_5.xxxx, r0_w_7.xxxx);
                float4 r0_xyzw_7 = (r0_w_8.xxxx * float4(r0_x_6, r0_y_4, r0_z_4, r0_x_6));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_5 = r0_xyzw_7.y;
                float r0_z_5 = r0_xyzw_7.z;
                float TEXCOORD0_w_9 = i.texcoord5.x;
                o.sv_Target0.xyz = ((float4(r0_x_7, r0_y_5, r0_z_5, r0_x_7) * TEXCOORD0_w_9.xxxx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
            };
            cbuffer UnityPerFrame : register(b2)
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
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[2];
            };
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_Ramp : register(s1);
            SamplerState sampler_linear_clamp2 : register(s2);
            SamplerState sampler_linear_clamp3 : register(s3);
            SamplerState sampler_MainTex : register(s4);
            Texture2D _MainTex : register(t0);
            Texture2D _Ramp : register(t1);
            Texture2D t2 : register(t2);
            Texture2D t3 : register(t3);
            Texture3D t4 : register(t4);
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
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program65Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program65Output
            {
                float4 sv_Target0 : SV_Target0;
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
                o.texcoord5.x = mad(max((((clipPos_xyzw_2.z / unity_WorldToObject[1].y) + 1) * unity_WorldToObject[1].z), 0), cb4_values[1].z, cb4_values[1].w);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7))).xyz;
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 r1_xyzw_8 = (r0_xyzw_4.yyyy * _MainTex_ST);
                float4 r1_xyzw_9 = mad(_Color, r0_xyzw_4.xxxx, r1_xyzw_8);
                float4 r1_xyzw_10 = mad(cb0_values[6].xyzw, r0_xyzw_4.zzzz, r1_xyzw_9);
                o.texcoord3.xyzw = mad(cb0_values[7].xyzw, r0_xyzw_4.wwww, r1_xyzw_10);
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program65Output frag(program65Input i)
            {
                program65Output o = (program65Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r2_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord2.zzzz, mad(cb0_values[4].xyzw, i.texcoord2.xxxx, (i.texcoord2.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_2 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r1_w_2);
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
                float r0_w_7 = dot(float4(r3_x_10, r3_y_10, r3_z_10, r3_w_4), unity_OcclusionMaskSelector);
                float r1_w_4 = (0 < r2_xyzw_4.z);
                float r1_w_5 = asfloat(asint(r1_w_4) & asint(1065353216));
                float4 r3_xyzw_13 = _Ramp.Sample(sampler_Ramp, (((((r2_xyzw_4.xyxx / r2_xyzw_4.wwww)).xyxx + float4(0.5, 0.5, 0, 0))).xyxx).xy);
                float r1_w_6 = (r1_w_5 * r3_xyzw_13.w);
                float4 r2_xyzw_6 = t2.Sample(sampler_linear_clamp2, ((dot(r2_xyzw_4.xyzx, r2_xyzw_4.xyzx)).xxxx).xy);
                float r1_w_7 = (r1_w_6 * r2_xyzw_6.x);
                float4 r2_xyzw_7 = t3.Sample(sampler_linear_clamp3, ((mad(dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0.5, 0.5)).xxxx).xy);
                float4 r0_xyzw_5 = (((r1_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * _LightColor0.xyzx);
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_3 = r0_xyzw_5.y;
                float r0_z_3 = r0_xyzw_5.z;
                float4 r0_xyzw_6 = (r2_xyzw_7.xyzx * float4(r0_x_5, r0_y_3, r0_z_3, r0_x_5));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_4 = r0_xyzw_6.y;
                float r0_z_4 = r0_xyzw_6.z;
                float r0_w_8 = dot(r1_w_7.xxxx, r0_w_7.xxxx);
                float4 r0_xyzw_7 = (r0_w_8.xxxx * float4(r0_x_6, r0_y_4, r0_z_4, r0_x_6));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_5 = r0_xyzw_7.y;
                float r0_z_5 = r0_xyzw_7.z;
                float TEXCOORD0_w_9 = i.texcoord5.x;
                o.sv_Target0.xyz = ((float4(r0_x_7, r0_y_5, r0_z_5, r0_x_7) * TEXCOORD0_w_9.xxxx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[5];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
            };
            cbuffer UnityPerFrame : register(b2)
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
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[2];
            };
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_Ramp : register(s1);
            SamplerState sampler_MainTex : register(s2);
            Texture2D _MainTex : register(t0);
            Texture2D _Ramp : register(t1);
            Texture3D t2 : register(t2);
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
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program64Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program64Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program50Output vert(program50Input i)
            {
                program50Output o = (program50Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord5.x = mad(max((((clipPos_xyzw_7.z / unity_WorldToObject[1].y) + 1) * unity_WorldToObject[1].z), 0), cb4_values[1].z, cb4_values[1].w);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_12 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12), float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12))).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program64Output frag(program64Input i)
            {
                program64Output o = (program64Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float r0_w_2 = (unity_ProbeVolumeParams.x == 1);
                float r1_x_10;
                float r1_y_11;
                float r1_z_10;
                float r1_w_4;
                if (r0_w_2)
                {
                    float r0_w_3 = (unity_ProbeVolumeParams.y == 1);
                    float3 r1_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_3.xxxx ? r1_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r1_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r1_y_8 = r1_xyzw_8.y;
                    float r1_z_8 = r1_xyzw_8.z;
                    float r1_w_2 = r1_xyzw_8.w;
                    float r0_w_4 = mad(r1_y_8, 0.25, 0.75);
                    float r1_y_9 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r1_x_8 = max(r0_w_4, r1_y_9);
                    float4 r1_xyzw_9 = t2.Sample(sampler_linear_clamp, (float4(r1_x_8, r1_z_8, r1_w_2, r1_x_8)).xyz);
                    r1_x_10 = r1_xyzw_9.x;
                    r1_y_11 = r1_xyzw_9.y;
                    r1_z_10 = r1_xyzw_9.z;
                    r1_w_4 = r1_xyzw_9.w;
                }
                else
                {
                    float4 r1_xyzw_10 = float4(1, 1, 1, 1);
                    r1_x_10 = r1_xyzw_10.x;
                    r1_y_11 = r1_xyzw_10.y;
                    r1_z_10 = r1_xyzw_10.z;
                    r1_w_4 = r1_xyzw_10.w;
                }
                float r0_w_6 = dot(float4(r1_x_10, r1_y_11, r1_z_10, r1_w_4), unity_OcclusionMaskSelector);
                float4 r1_xyzw_13 = _Ramp.Sample(sampler_Ramp, ((mad(dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx), 0.5, 0.5)).xxxx).xy);
                float r0_w_7 = (r0_w_6 + r0_w_6);
                float TEXCOORD0_w_8 = i.texcoord5.x;
                o.sv_Target0.xyz = ((((r0_w_7.xxxx * ((r1_xyzw_13.xyzx * ((((r0_xyzw_1.xyzx * cb0_values[4].xyzx)).xyzx * _LightColor0.xyzx)).xyzx)).xyzx)).xyzx * TEXCOORD0_w_8.xxxx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
            };
            cbuffer UnityPerFrame : register(b2)
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
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[2];
            };
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_Ramp : register(s1);
            SamplerState sampler_linear_clamp2 : register(s2);
            SamplerState sampler_MainTex : register(s3);
            Texture2D _MainTex : register(t0);
            Texture2D _Ramp : register(t1);
            Texture2D t2 : register(t2);
            Texture3D t3 : register(t3);
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
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program63Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program63Output
            {
                float4 sv_Target0 : SV_Target0;
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
                o.texcoord5.x = mad(max((((clipPos_xyzw_2.z / unity_WorldToObject[1].y) + 1) * unity_WorldToObject[1].z), 0), cb4_values[1].z, cb4_values[1].w);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord1.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7))).xyz;
                o.texcoord2.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 r1_xyzw_8 = (r0_xyzw_4.yyyy * _MainTex_ST.xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_4 = r1_xyzw_8.y;
                float r1_z_4 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = mad(_Color.xyzx, r0_xyzw_4.xxxx, float4(r1_x_8, r1_y_4, r1_z_4, r1_x_8));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_5 = r1_xyzw_9.y;
                float r1_z_5 = r1_xyzw_9.z;
                o.texcoord3.xyz = (mad(cb0_values[7].xyzx, r0_xyzw_4.wwww, (mad(cb0_values[6].xyzx, r0_xyzw_4.zzzz, float4(r1_x_9, r1_y_5, r1_z_5, r1_x_9))).xyzx)).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program63Output frag(program63Input i)
            {
                program63Output o = (program63Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_2 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r1_w_2);
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
                float r0_w_7 = dot(float4(r3_x_10, r3_y_10, r3_z_10, r3_w_4), unity_OcclusionMaskSelector);
                float r1_w_4 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float4 r2_xyzw_5 = _Ramp.Sample(sampler_Ramp, (r1_w_4.xxxx).xy);
                float4 r3_xyzw_11 = t2.Sample(sampler_linear_clamp2, ((mad(dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0.5, 0.5)).xxxx).xy);
                float4 r0_xyzw_5 = (((r1_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * _LightColor0.xyzx);
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_3 = r0_xyzw_5.y;
                float r0_z_3 = r0_xyzw_5.z;
                float4 r0_xyzw_6 = (r3_xyzw_11.xyzx * float4(r0_x_5, r0_y_3, r0_z_3, r0_x_5));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_4 = r0_xyzw_6.y;
                float r0_z_4 = r0_xyzw_6.z;
                float r0_w_8 = dot(r2_xyzw_5.xxxx, r0_w_7.xxxx);
                float4 r0_xyzw_7 = (r0_w_8.xxxx * float4(r0_x_6, r0_y_4, r0_z_4, r0_x_6));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_5 = r0_xyzw_7.y;
                float r0_z_5 = r0_xyzw_7.z;
                float TEXCOORD0_w_9 = i.texcoord5.x;
                o.sv_Target0.xyz = ((float4(r0_x_7, r0_y_5, r0_z_5, r0_x_7) * TEXCOORD0_w_9.xxxx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
            };
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_Ramp : register(s1);
            SamplerState sampler_linear_clamp2 : register(s2);
            SamplerState sampler_MainTex : register(s3);
            Texture2D _MainTex : register(t0);
            Texture2D _Ramp : register(t1);
            Texture2D t2 : register(t2);
            Texture3D t3 : register(t3);
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
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program62Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program62Output
            {
                float4 sv_Target0 : SV_Target0;
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
                worldPos_xyzw_2 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float2 clipPos_xy_4 = ((worldPos_xyzw_2.yyyy * _MainTex_ST.xyxx)).xy;
                float2 clipPos_xy_5 = (mad(_Color.xyxx, worldPos_xyzw_2.xxxx, clipPos_xy_4.xyxx)).xy;
                float2 clipPos_xy_6 = (mad(cb0_values[6].xyxx, worldPos_xyzw_2.zzzz, clipPos_xy_5.xyxx)).xy;
                o.texcoord3.xy = (mad(cb0_values[7].xxxy, worldPos_xyzw_2.wwww, clipPos_xy_6.xxxy)).zw;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
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
            program62Output frag(program62Input i)
            {
                program62Output o = (program62Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float r0_w_2 = (unity_ProbeVolumeParams.x == 1);
                float r2_x_10;
                float r2_y_10;
                float r2_z_10;
                float r2_w_4;
                if (r0_w_2)
                {
                    float r0_w_3 = (unity_ProbeVolumeParams.y == 1);
                    float3 r2_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_3.xxxx ? r2_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r2_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_8 = r2_xyzw_8.z;
                    float r2_w_2 = r2_xyzw_8.w;
                    float r0_w_4 = mad(r2_y_8, 0.25, 0.75);
                    float r1_z_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r2_x_8 = max(r0_w_4, r1_z_1);
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
                float r0_w_6 = dot(float4(r2_x_10, r2_y_10, r2_z_10, r2_w_4), unity_OcclusionMaskSelector);
                float4 r1_xyzw_5 = _Ramp.Sample(sampler_Ramp, ((((mad(cb0_values[6].xyxx, i.texcoord2.zzzz, (mad(cb0_values[4].xyxx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx).xy);
                float4 r2_xyzw_11 = t2.Sample(sampler_linear_clamp2, ((mad(dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx), 0.5, 0.5)).xxxx).xy);
                float r0_w_7 = dot(r1_xyzw_5.wwww, r0_w_6.xxxx);
                o.sv_Target0.xyz = ((r0_w_7.xxxx * ((r2_xyzw_11.xyzx * ((((r0_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * _LightColor0.xyzx)).xyzx)).xyzx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
            };
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_linear_clamp1 : register(s1);
            SamplerState sampler_Ramp : register(s2);
            SamplerState sampler_linear_clamp3 : register(s3);
            SamplerState sampler_MainTex : register(s4);
            Texture2D _MainTex : register(t0);
            Texture2D _Ramp : register(t1);
            TextureCube t2 : register(t2);
            Texture2D t3 : register(t3);
            Texture3D t4 : register(t4);
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
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program61Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program61Output
            {
                float4 sv_Target0 : SV_Target0;
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
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float3 clipPos_xyz_3 = ((worldPos_xyzw_4.yyyy * _MainTex_ST.xyzx)).xyz;
                float3 clipPos_xyz_4 = (mad(_Color.xyzx, worldPos_xyzw_4.xxxx, clipPos_xyz_3.xyzx)).xyz;
                float3 clipPos_xyz_5 = (mad(cb0_values[6].xyzx, worldPos_xyzw_4.zzzz, clipPos_xyz_4.xyzx)).xyz;
                o.texcoord3.xyz = (mad(cb0_values[7].xyzx, worldPos_xyzw_4.wwww, clipPos_xyz_5.xyzx)).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program61Output frag(program61Input i)
            {
                program61Output o = (program61Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r2_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord2.zzzz, (mad(cb0_values[4].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_2 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r1_w_2);
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
                float r0_w_7 = dot(float4(r3_x_10, r3_y_10, r3_z_10, r3_w_4), unity_OcclusionMaskSelector);
                float r1_w_4 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float4 r3_xyzw_11 = _Ramp.Sample(sampler_Ramp, (r1_w_4.xxxx).xy);
                float4 r2_xyzw_5 = t2.Sample(sampler_linear_clamp1, r2_xyz_4.xyz);
                float r1_w_5 = (r2_xyzw_5.w * r3_xyzw_11.x);
                float4 r2_xyzw_6 = t3.Sample(sampler_linear_clamp3, ((mad(dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0.5, 0.5)).xxxx).xy);
                float4 r0_xyzw_5 = (((r1_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * _LightColor0.xyzx);
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_3 = r0_xyzw_5.y;
                float r0_z_3 = r0_xyzw_5.z;
                float4 r0_xyzw_6 = (r2_xyzw_6.xyzx * float4(r0_x_5, r0_y_3, r0_z_3, r0_x_5));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_4 = r0_xyzw_6.y;
                float r0_z_4 = r0_xyzw_6.z;
                float r0_w_8 = dot(r1_w_5.xxxx, r0_w_7.xxxx);
                o.sv_Target0.xyz = ((r0_w_8.xxxx * float4(r0_x_6, r0_y_4, r0_z_4, r0_x_6))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[10];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
            };
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_Ramp : register(s1);
            SamplerState sampler_linear_clamp2 : register(s2);
            SamplerState sampler_linear_clamp3 : register(s3);
            SamplerState sampler_MainTex : register(s4);
            Texture2D _MainTex : register(t0);
            Texture2D _Ramp : register(t1);
            Texture2D t2 : register(t2);
            Texture2D t3 : register(t3);
            Texture3D t4 : register(t4);
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
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program60Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program60Output
            {
                float4 sv_Target0 : SV_Target0;
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
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[9].xyxx, cb0_values[9].zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 worldPos_xyzw_4 = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float clipPos_x_3 = ((worldPos_xyzw_4.yyyy * _MainTex_ST)).x;
                float clipPos_y_3 = ((worldPos_xyzw_4.yyyy * _MainTex_ST)).y;
                float clipPos_z_3 = ((worldPos_xyzw_4.yyyy * _MainTex_ST)).z;
                float clipPos_w_4 = ((worldPos_xyzw_4.yyyy * _MainTex_ST)).w;
                float4 clipPos_xyzw_4 = mad(_Color, worldPos_xyzw_4.xxxx, float4(clipPos_x_3, clipPos_y_3, clipPos_z_3, clipPos_w_4));
                float4 clipPos_xyzw_5 = mad(cb0_values[6].xyzw, worldPos_xyzw_4.zzzz, clipPos_xyzw_4);
                o.texcoord3.xyzw = mad(cb0_values[7].xyzw, worldPos_xyzw_4.wwww, clipPos_xyzw_5);
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program60Output frag(program60Input i)
            {
                program60Output o = (program60Output)0;
                float3 r0_xyz_1 = ((-i.texcoord2.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r1_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r2_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord2.zzzz, mad(cb0_values[4].xyzw, i.texcoord2.xxxx, (i.texcoord2.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_2 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r1_w_2);
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
                float r0_w_7 = dot(float4(r3_x_10, r3_y_10, r3_z_10, r3_w_4), unity_OcclusionMaskSelector);
                float r1_w_4 = (0 < r2_xyzw_4.z);
                float r1_w_5 = asfloat(asint(r1_w_4) & asint(1065353216));
                float4 r3_xyzw_13 = _Ramp.Sample(sampler_Ramp, (((((r2_xyzw_4.xyxx / r2_xyzw_4.wwww)).xyxx + float4(0.5, 0.5, 0, 0))).xyxx).xy);
                float r1_w_6 = (r1_w_5 * r3_xyzw_13.w);
                float4 r2_xyzw_6 = t2.Sample(sampler_linear_clamp2, ((dot(r2_xyzw_4.xyzx, r2_xyzw_4.xyzx)).xxxx).xy);
                float r1_w_7 = (r1_w_6 * r2_xyzw_6.x);
                float4 r2_xyzw_7 = t3.Sample(sampler_linear_clamp3, ((mad(dot(i.texcoord1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0.5, 0.5)).xxxx).xy);
                float4 r0_xyzw_5 = (((r1_xyzw_1.xyzx * cb0_values[8].xyzx)).xyzx * _LightColor0.xyzx);
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_3 = r0_xyzw_5.y;
                float r0_z_3 = r0_xyzw_5.z;
                float4 r0_xyzw_6 = (r2_xyzw_7.xyzx * float4(r0_x_5, r0_y_3, r0_z_3, r0_x_5));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_4 = r0_xyzw_6.y;
                float r0_z_4 = r0_xyzw_6.z;
                float r0_w_8 = dot(r1_w_7.xxxx, r0_w_7.xxxx);
                o.sv_Target0.xyz = ((r0_w_8.xxxx * float4(r0_x_6, r0_y_4, r0_z_4, r0_x_6))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Color;
                float4 _MainTex_ST;
                float4 cb0_values[5];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _WorldSpaceLightPos0;
                float4x4 unity_WorldToObject;
                float4 unity_OcclusionMaskSelector;
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4x4 unity_MatrixVP;
            };
            SamplerState sampler_linear_clamp : register(s0);
            SamplerState sampler_Ramp : register(s1);
            SamplerState sampler_MainTex : register(s2);
            Texture2D _MainTex : register(t0);
            Texture2D _Ramp : register(t1);
            Texture3D t2 : register(t2);
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
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program59Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program59Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program45Output vert(program45Input i)
            {
                program45Output o = (program45Output)0;
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
            program59Output frag(program59Input i)
            {
                program59Output o = (program59Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float r0_w_2 = (unity_ProbeVolumeParams.x == 1);
                float r1_x_10;
                float r1_y_11;
                float r1_z_10;
                float r1_w_4;
                if (r0_w_2)
                {
                    float r0_w_3 = (unity_ProbeVolumeParams.y == 1);
                    float3 r1_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord2.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord2.xxxx, ((i.texcoord2.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_3.xxxx ? r1_xyz_5.xyzx : i.texcoord2.xyzx)).xyz;
                    float4 r1_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r1_y_8 = r1_xyzw_8.y;
                    float r1_z_8 = r1_xyzw_8.z;
                    float r1_w_2 = r1_xyzw_8.w;
                    float r0_w_4 = mad(r1_y_8, 0.25, 0.75);
                    float r1_y_9 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r1_x_8 = max(r0_w_4, r1_y_9);
                    float4 r1_xyzw_9 = t2.Sample(sampler_linear_clamp, (float4(r1_x_8, r1_z_8, r1_w_2, r1_x_8)).xyz);
                    r1_x_10 = r1_xyzw_9.x;
                    r1_y_11 = r1_xyzw_9.y;
                    r1_z_10 = r1_xyzw_9.z;
                    r1_w_4 = r1_xyzw_9.w;
                }
                else
                {
                    float4 r1_xyzw_10 = float4(1, 1, 1, 1);
                    r1_x_10 = r1_xyzw_10.x;
                    r1_y_11 = r1_xyzw_10.y;
                    r1_z_10 = r1_xyzw_10.z;
                    r1_w_4 = r1_xyzw_10.w;
                }
                float r0_w_6 = dot(float4(r1_x_10, r1_y_11, r1_z_10, r1_w_4), unity_OcclusionMaskSelector);
                float4 r1_xyzw_13 = _Ramp.Sample(sampler_Ramp, ((mad(dot(i.texcoord1.xyzx, _WorldSpaceLightPos0.xyzx), 0.5, 0.5)).xxxx).xy);
                float r0_w_7 = (r0_w_6 + r0_w_6);
                o.sv_Target0.xyz = ((r0_w_7.xxxx * ((r1_xyzw_13.xyzx * ((((r0_xyzw_1.xyzx * cb0_values[4].xyzx)).xyzx * _LightColor0.xyzx)).xyzx)).xyzx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Diffuse"
}
