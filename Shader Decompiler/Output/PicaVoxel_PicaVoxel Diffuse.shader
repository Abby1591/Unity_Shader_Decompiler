Shader "PicaVoxel/PicaVoxel Diffuse"
{
    Properties
    {
        _Tint ("Tint", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        CGPROGRAM
        #include "UnityCG.cginc"
        #pragma surface surf Lambert

        struct Input
        {
            float4 vertexColor : COLOR;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = (IN.vertexColor.rgb * _Tint.rgb);
            o.Alpha = 1;
        }
        ENDCG

        /*
        The passes below are the compiled surface-shader
        output (the literal bytecode we decompiled). They
        are what the #pragma surface source above generates.
        */
        /*
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Tint;
                float4 cb0_values[7];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityProbeVolume : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[7];
            };
            SamplerState s0 : register(s0);
            Texture3D t0 : register(t0);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program31Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program31Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program9Output vert(program9Input i)
            {
                program9Output o = (program9Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord1.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord0.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program31Output frag(program31Input i)
            {
                program31Output o = (program31Output)0;
                float r0_w_1 = (unity_ProbeVolumeParams.x == 1);
                float r1_x_10;
                float r1_y_11;
                float r1_z_10;
                float r1_w_4;
                if (r0_w_1)
                {
                    float r0_w_2 = (unity_ProbeVolumeParams.y == 1);
                    float3 r1_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_2.xxxx ? r1_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r1_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r1_y_8 = r1_xyzw_8.y;
                    float r1_z_8 = r1_xyzw_8.z;
                    float r1_w_2 = r1_xyzw_8.w;
                    float r0_w_3 = mad(r1_y_8, 0.25, 0.75);
                    float r1_y_9 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r1_x_8 = max(r0_w_3, r1_y_9);
                    float4 r1_xyzw_9 = t0.Sample(s0, float4(r1_x_8, r1_z_8, r1_w_2, r1_x_8));
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
                float r0_w_5 = dot(float4(r1_x_10, r1_y_11, r1_z_10, r1_w_4), unity_OcclusionMaskSelector);
                float4 r1_xyzw_11 = (r0_w_5.xxxx * _LightColor0.xyzx);
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_12 = r1_xyzw_11.y;
                float r1_z_11 = r1_xyzw_11.z;
                float r0_w_6 = dot(i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx);
                float r0_w_7 = max(r0_w_6, 0);
                o.sv_Target0.xyz = ((r0_w_7.xxxx * ((((i.color0.xyzx * _Tint.xyzx)).xyzx * float4(r1_x_11, r1_y_12, r1_z_11, r1_x_11))).xyzx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Tint;
                float4 cb0_values[6];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[46];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
            struct program24Input
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
            struct program24Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program38Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program38Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program24Output vert(program24Input i)
            {
                program24Output o = (program24Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float3 r0_xyz_4 = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = clipPos_xyzw_2;
                o.texcoord3.x = clipPos_xyzw_2.z;
                float worldNormal_x_4 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_w_4 = dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4));
                float r0_w_5 = rsqrt(r0_w_4);
                float3 unitWorldNormal_xyz_5 = ((r0_w_5.xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4))).xyz;
                o.texcoord0.xyz = (unitWorldNormal_xyz_5.xyzx).xyz;
                o.texcoord1.xyz = (r0_xyz_4.xyzx).xyz;
                o.color0.xyzw = i.color0.xyzw;
                float4 r3_xyzw_1 = (-r0_xyz_4.xxxx + cb1_values[3].xyzw);
                float4 r4_xyzw_1 = (-r0_xyz_4.yyyy + cb1_values[4].xyzw);
                float4 r0_xyzw_5 = (-r0_xyz_4.zzzz + cb1_values[5].xyzw);
                float4 r0_xyzw_6 = mad(r0_xyzw_5, r0_xyzw_5, mad(r3_xyzw_1, r3_xyzw_1, (r4_xyzw_1 * r4_xyzw_1)));
                float4 r0_xyzw_7 = max(r0_xyzw_6, float4(1E-06, 1E-06, 1E-06, 1E-06));
                float4 r0_xyzw_8 = mad(r0_xyzw_7, cb1_values[6].xyzw, float4(1, 1, 1, 1));
                float4 r0_xyzw_9 = (float4(1, 1, 1, 1) / r0_xyzw_8);
                float4 r0_xyzw_10 = (r0_xyzw_9 * max((mad(r0_xyzw_5, unitWorldNormal_xyz_5.zzzz, mad(r3_xyzw_1, unitWorldNormal_xyz_5.xxxx, (unitWorldNormal_xyz_5.yyyy * r4_xyzw_1))) * rsqrt(r0_xyzw_7)), float4(0, 0, 0, 0)));
                float3 r0_xyz_12 = (mad(cb1_values[10].xyzx, r0_xyzw_10.wwww, (mad(cb1_values[9].xyzx, r0_xyzw_10.zzzz, (mad(cb1_values[7].xyzx, r0_xyzw_10.xxxx, ((r0_xyzw_10.yyyy * cb1_values[8].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                float r0_w_12 = (unitWorldNormal_xyz_5.y * unitWorldNormal_xyz_5.y);
                float r0_w_13 = mad(unitWorldNormal_xyz_5.x, unitWorldNormal_xyz_5.x, -r0_w_12);
                float4 r2_xyzw_6 = (unitWorldNormal_xyz_5.yzzx * unitWorldNormal_xyz_5.xyzz);
                float r4_x_5 = dot(cb1_values[42].xyzw, r2_xyzw_6);
                float r4_y_5 = dot(cb1_values[43].xyzw, r2_xyzw_6);
                float r4_z_5 = dot(cb1_values[44].xyzw, r2_xyzw_6);
                o.texcoord2.xyz = (mad(r0_xyz_12.xyzx, (mad(r0_xyz_12.xyzx, (mad(r0_xyz_12.xyzx, float4(0.30530602, 0.30530602, 0.30530602, 0), float4(0.6821711, 0.6821711, 0.6821711, 0))).xyzx, float4(0.012522878, 0.012522878, 0.012522878, 0))).xyzx, (mad(cb1_values[45].xyzx, r0_w_13.xxxx, float4(r4_x_5, r4_y_5, r4_z_5, r4_x_5))).xyzx)).xyz;
                float r0_w_14 = ((clipPos_xyzw_2.y * unity_WorldToObject[1].x) * 0.5);
                float4 r0_xyzw_14 = (clipPos_xyzw_2.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_14 = r0_xyzw_14.x;
                float r0_z_13 = r0_xyzw_14.z;
                o.texcoord4.zw = (clipPos_xyzw_2.zzzw).zw;
                o.texcoord4.xy = ((r0_z_13.xxxx + float4(r0_x_14, r0_w_14, r0_x_14, r0_x_14))).xy;
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program38Output frag(program38Input i)
            {
                program38Output o = (program38Output)0;
                float3 r0_xyz_1 = ((i.color0.xyzx * _Tint.xyzx)).xyz;
                float r2_x_1 = cb4_values[9].z;
                float r2_y_1 = cb4_values[10].z;
                float r2_z_1 = cb4_values[11].z;
                float r0_w_1 = dot(((-i.texcoord1.xyzx + cb1_values[4].xyzx)).xyzx, float4(r2_x_1, r2_y_1, r2_z_1, r2_x_1));
                float3 r1_xyz_2 = ((i.texcoord1.xyzx + -cb3_values[25].xyzx)).xyz;
                float r0_w_2 = mad(cb3_values[25].w, (-r0_w_1 + sqrt(dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx))), r0_w_1);
                float r0_w_3 = mad(r0_w_2, cb3_values[24].z, cb3_values[24].w);
                float r1_x_6 = (cb6_values[0].x == 1);
                float r2_x_9;
                float r2_y_9;
                float r2_z_9;
                float r2_w_4;
                if (r1_x_6)
                {
                    float r1_y_3 = (cb6_values[0].y == 1);
                    float3 r2_xyz_6 = (((mad(cb6_values[3].xyzx, i.texcoord1.zzzz, (mad(cb6_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r1_xyzw_4 = (r1_y_3.xxxx ? r2_xyz_6.xxyz : i.texcoord1.xxyz);
                    float r1_y_4 = r1_xyzw_4.y;
                    float r1_z_3 = r1_xyzw_4.z;
                    float r1_w_1 = r1_xyzw_4.w;
                    float4 r1_xyzw_5 = (float4(r1_y_4, r1_y_4, r1_z_3, r1_w_1) + -cb6_values[6].xxyz);
                    float r1_y_5 = r1_xyzw_5.y;
                    float r1_z_4 = r1_xyzw_5.z;
                    float r1_w_2 = r1_xyzw_5.w;
                    float4 r2_xyzw_7 = (float4(r1_y_5, r1_y_5, r1_z_4, r1_w_2) * cb6_values[5].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_2 = r2_xyzw_7.w;
                    float r1_y_6 = mad(r2_y_7, 0.25, 0.75);
                    float r1_z_5 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r2_x_7 = max(r1_z_5, r1_y_6);
                    float4 r2_xyzw_8 = t1.Sample(s0, float4(r2_x_7, r2_z_7, r2_w_2, r2_x_7));
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
                float r1_y_8 = dot(float4(r2_x_9, r2_y_9, r2_z_9, r2_w_4), cb2_values[46].xyzw);
                float4 r1_xyzw_7 = (i.texcoord4.xxxy / i.texcoord4.wwww);
                float r1_z_7 = r1_xyzw_7.z;
                float r1_w_4 = r1_xyzw_7.w;
                float4 r2_xyzw_10 = t0.Sample(s1, float4(r1_z_7, r1_w_4, r1_z_7, r1_z_7));
                float r1_y_9 = (r1_y_8 + -r2_xyzw_10.x);
                float r0_w_4 = mad(r0_w_3, r1_y_9, r2_xyzw_10.x);
                float4 r1_xyzw_10 = (r0_w_4.xxxx * _LightColor0.xxyz);
                float r1_y_10 = r1_xyzw_10.y;
                float r1_z_8 = r1_xyzw_10.z;
                float r1_w_5 = r1_xyzw_10.w;
                float3 r3_xyz_4;
                if ((r1_x_6 != 0))
                {
                    float r0_w_5 = (cb6_values[0].y == 1);
                    float3 r2_xyz_15 = (((mad(cb6_values[3].xyzx, i.texcoord1.zzzz, (mad(cb6_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r2_xyzw_18 = (((((r0_w_5.xxxx ? r2_xyz_15.xyzx : i.texcoord1.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r2_y_18 = r2_xyzw_18.y;
                    float r2_z_18 = r2_xyzw_18.z;
                    float r2_w_7 = r2_xyzw_18.w;
                    float r0_w_6 = (r2_y_18 * 0.25);
                    float r2_y_19 = mad(-cb6_values[0].z, 0.5, 0.25);
                    float r0_w_7 = max(r0_w_6, (cb6_values[0].z * 0.5));
                    float r2_x_18 = min(r2_y_19, r0_w_7);
                    float4 r3_xyzw_2 = t1.Sample(s0, float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18));
                    float4 r4_xyzw_2 = t1.Sample(s0, ((float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18) + float4(0.25, 0, 0, 0))).xyzx);
                    float4 r2_xyzw_19 = (float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18) + float4(0.5, 0, 0, 0));
                    float r2_x_19 = r2_xyzw_19.x;
                    float r2_y_20 = r2_xyzw_19.y;
                    float r2_z_19 = r2_xyzw_19.z;
                    float4 r2_xyzw_20 = t1.Sample(s0, float4(r2_x_19, r2_y_20, r2_z_19, r2_x_19));
                    float3 TEXCOORD0_xyz_1 = (i.texcoord0.xyzx).xyz;
                    float r5_w_1 = 1;
                    float r3_x_3 = dot(r3_xyzw_2, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    float r3_y_3 = dot(r4_xyzw_2, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    float r3_z_3 = dot(r2_xyzw_20, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    r3_xyz_4 = float3(r3_x_3, r3_y_3, r3_z_3);
                }
                else
                {
                    float3 TEXCOORD0_xyz_11 = (i.texcoord0.xyzx).xyz;
                    float r2_w_6 = 1;
                    float r3_x_1 = dot(cb2_values[39].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    float r3_y_1 = dot(cb2_values[40].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    float r3_z_1 = dot(cb2_values[41].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    r3_xyz_4 = float3(r3_x_1, r3_y_1, r3_z_1);
                }
                float4 r2_xyzw_22 = (r3_xyz_4.xyzx + i.texcoord2.xyzx);
                float r2_x_22 = r2_xyzw_22.x;
                float r2_y_23 = r2_xyzw_22.y;
                float r2_z_22 = r2_xyzw_22.z;
                float4 r2_xyzw_23 = max(float4(r2_x_22, r2_y_23, r2_z_22, r2_x_22), float4(0, 0, 0, 0));
                float r2_x_23 = r2_xyzw_23.x;
                float r2_y_24 = r2_xyzw_23.y;
                float r2_z_23 = r2_xyzw_23.z;
                float4 r2_xyzw_24 = log2(float4(r2_x_23, r2_y_24, r2_z_23, r2_x_23));
                float r2_x_24 = r2_xyzw_24.x;
                float r2_y_25 = r2_xyzw_24.y;
                float r2_z_24 = r2_xyzw_24.z;
                float4 r2_xyzw_25 = (float4(r2_x_24, r2_y_25, r2_z_24, r2_x_24) * float4(0.41666666, 0.41666666, 0.41666666, 0));
                float r2_x_25 = r2_xyzw_25.x;
                float r2_y_26 = r2_xyzw_25.y;
                float r2_z_25 = r2_xyzw_25.z;
                float4 r2_xyzw_26 = exp2(float4(r2_x_25, r2_y_26, r2_z_25, r2_x_25));
                float r2_x_26 = r2_xyzw_26.x;
                float r2_y_27 = r2_xyzw_26.y;
                float r2_z_26 = r2_xyzw_26.z;
                float4 r2_xyzw_27 = mad(float4(r2_x_26, r2_y_27, r2_z_26, r2_x_26), float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0));
                float r2_x_27 = r2_xyzw_27.x;
                float r2_y_28 = r2_xyzw_27.y;
                float r2_z_27 = r2_xyzw_27.z;
                float4 r2_xyzw_28 = max(float4(r2_x_27, r2_y_28, r2_z_27, r2_x_27), float4(0, 0, 0, 0));
                float r2_x_28 = r2_xyzw_28.x;
                float r2_y_29 = r2_xyzw_28.y;
                float r2_z_28 = r2_xyzw_28.z;
                float r0_w_9 = dot(i.texcoord0.xyzx, unity_ProbeVolumeParams.xyzx);
                float r0_w_10 = max(r0_w_9, 0);
                float4 r1_xyzw_9 = (r0_xyz_1.xyzx * float4(r1_y_10, r1_z_8, r1_w_5, r1_y_10));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_11 = r1_xyzw_9.y;
                float r1_z_9 = r1_xyzw_9.z;
                float r0_w_11 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_12 = (-r0_w_11 + 1);
                float r0_w_13 = (r0_w_12 * cb1_values[5].z);
                float r0_w_14 = max(r0_w_13, 0);
                float r0_w_15 = mad(r0_w_14, cb5_values[1].z, cb5_values[1].w);
                o.sv_Target0.xyz = (mad(r0_w_15.xxxx, (((mad(float4(r1_x_9, r1_y_11, r1_z_9, r1_x_9), r0_w_10.xxxx, ((r0_xyz_1.xyzx * float4(r2_x_28, r2_y_29, r2_z_28, r2_x_28))).xyzx)).xyzx + -cb5_values[0].xyzx)).xyzx, cb5_values[0].xyzx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Tint;
                float4 cb0_values[6];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[46];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
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
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program38Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
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
                float3 r0_xyz_4 = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = clipPos_xyzw_2;
                float r0_w_4 = (clipPos_xyzw_2.z / unity_WorldToObject[1].y);
                float r0_w_5 = (-r0_w_4 + 1);
                float r0_w_6 = (r0_w_5 * unity_WorldToObject[1].z);
                float r0_w_7 = max(r0_w_6, 0);
                o.texcoord3.x = mad(r0_w_7, cb4_values[1].z, cb4_values[1].w);
                float worldNormal_x_3 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r0_w_9 = rsqrt(r0_w_8);
                float3 unitWorldNormal_xyz_4 = ((r0_w_9.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord0.xyz = (unitWorldNormal_xyz_4.xyzx).xyz;
                o.texcoord1.xyz = (r0_xyz_4.xyzx).xyz;
                o.color0.xyzw = i.color0.xyzw;
                float r0_w_10 = (unitWorldNormal_xyz_4.y * unitWorldNormal_xyz_4.y);
                float r0_w_11 = mad(unitWorldNormal_xyz_4.x, unitWorldNormal_xyz_4.x, -r0_w_10);
                float4 r2_xyzw_4 = (unitWorldNormal_xyz_4.yzzx * unitWorldNormal_xyz_4.xyzz);
                float r3_x_1 = dot(cb1_values[42].xyzw, r2_xyzw_4);
                float r3_y_1 = dot(cb1_values[43].xyzw, r2_xyzw_4);
                float r3_z_1 = dot(cb1_values[44].xyzw, r2_xyzw_4);
                float r1_w_3 = 1;
                float r3_x_2 = dot(cb1_values[39].xyzw, float4(unitWorldNormal_xyz_4.x, unitWorldNormal_xyz_4.y, unitWorldNormal_xyz_4.z, r1_w_3));
                float r3_y_2 = dot(cb1_values[40].xyzw, float4(unitWorldNormal_xyz_4.x, unitWorldNormal_xyz_4.y, unitWorldNormal_xyz_4.z, r1_w_3));
                float r3_z_2 = dot(cb1_values[41].xyzw, float4(unitWorldNormal_xyz_4.x, unitWorldNormal_xyz_4.y, unitWorldNormal_xyz_4.z, r1_w_3));
                float3 r2_xyz_9 = (((log2((max((((mad(cb1_values[45].xyzx, r0_w_11.xxxx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1))).xyzx + float4(r3_x_2, r3_y_2, r3_z_2, r3_x_2))).xyzx, float4(0, 0, 0, 0))).xyzx)).xyzx * float4(0.41666666, 0.41666666, 0.41666666, 0))).xyz;
                float4 r3_xyzw_3 = (-r0_xyz_4.yyyy + cb1_values[4].xyzw);
                float4 r3_xyzw_4 = (r3_xyzw_3 * r3_xyzw_3);
                float4 r5_xyzw_1 = (-r0_xyz_4.xxxx + cb1_values[3].xyzw);
                float4 r0_xyzw_5 = (-r0_xyz_4.zzzz + cb1_values[5].xyzw);
                float4 r1_xyzw_5 = mad(r0_xyzw_5, unitWorldNormal_xyz_4.zzzz, mad(r5_xyzw_1, unitWorldNormal_xyz_4.xxxx, (unitWorldNormal_xyz_4.yyyy * r3_xyzw_3)));
                float4 r3_xyzw_5 = mad(r5_xyzw_1, r5_xyzw_1, r3_xyzw_4);
                float4 r0_xyzw_6 = mad(r0_xyzw_5, r0_xyzw_5, r3_xyzw_5);
                float4 r0_xyzw_7 = max(r0_xyzw_6, float4(1E-06, 1E-06, 1E-06, 1E-06));
                float4 r3_xyzw_6 = rsqrt(r0_xyzw_7);
                float4 r0_xyzw_8 = mad(r0_xyzw_7, cb1_values[6].xyzw, float4(1, 1, 1, 1));
                float4 r0_xyzw_9 = (float4(1, 1, 1, 1) / r0_xyzw_8);
                float4 r1_xyzw_6 = (r1_xyzw_5 * r3_xyzw_6);
                float4 r1_xyzw_7 = max(r1_xyzw_6, float4(0, 0, 0, 0));
                float4 r0_xyzw_10 = (r0_xyzw_9 * r1_xyzw_7);
                float3 r0_xyz_12 = (mad(cb1_values[10].xyzx, r0_xyzw_10.wwww, (mad(cb1_values[9].xyzx, r0_xyzw_10.zzzz, (mad(cb1_values[7].xyzx, r0_xyzw_10.xxxx, ((r0_xyzw_10.yyyy * cb1_values[8].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord2.xyz = (((max((mad((exp2(r2_xyz_9.xyzx)).xyzx, float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0))).xyzx, float4(0, 0, 0, 0))).xyzx + r0_xyz_12.xyzx)).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program38Output frag(program38Input i)
            {
                program38Output o = (program38Output)0;
                float3 r0_xyz_1 = ((i.color0.xyzx * _Tint.xyzx)).xyz;
                float r2_x_1 = cb4_values[9].z;
                float r2_y_1 = cb4_values[10].z;
                float r2_z_1 = cb4_values[11].z;
                float r0_w_1 = dot(((-i.texcoord1.xyzx + cb1_values[4].xyzx)).xyzx, float4(r2_x_1, r2_y_1, r2_z_1, r2_x_1));
                float3 r1_xyz_2 = ((i.texcoord1.xyzx + -cb3_values[25].xyzx)).xyz;
                float r0_w_2 = mad(cb3_values[25].w, (-r0_w_1 + sqrt(dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx))), r0_w_1);
                float r0_w_3 = mad(r0_w_2, cb3_values[24].z, cb3_values[24].w);
                float r1_x_6 = (cb6_values[0].x == 1);
                float r2_x_9;
                float r2_y_9;
                float r2_z_9;
                float r2_w_4;
                if (r1_x_6)
                {
                    float r1_y_3 = (cb6_values[0].y == 1);
                    float3 r2_xyz_6 = (((mad(cb6_values[3].xyzx, i.texcoord1.zzzz, (mad(cb6_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r1_xyzw_4 = (r1_y_3.xxxx ? r2_xyz_6.xxyz : i.texcoord1.xxyz);
                    float r1_y_4 = r1_xyzw_4.y;
                    float r1_z_3 = r1_xyzw_4.z;
                    float r1_w_1 = r1_xyzw_4.w;
                    float4 r1_xyzw_5 = (float4(r1_y_4, r1_y_4, r1_z_3, r1_w_1) + -cb6_values[6].xxyz);
                    float r1_y_5 = r1_xyzw_5.y;
                    float r1_z_4 = r1_xyzw_5.z;
                    float r1_w_2 = r1_xyzw_5.w;
                    float4 r2_xyzw_7 = (float4(r1_y_5, r1_y_5, r1_z_4, r1_w_2) * cb6_values[5].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_2 = r2_xyzw_7.w;
                    float r1_y_6 = mad(r2_y_7, 0.25, 0.75);
                    float r1_z_5 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r2_x_7 = max(r1_z_5, r1_y_6);
                    float4 r2_xyzw_8 = t1.Sample(s0, float4(r2_x_7, r2_z_7, r2_w_2, r2_x_7));
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
                float r1_y_8 = dot(float4(r2_x_9, r2_y_9, r2_z_9, r2_w_4), cb2_values[46].xyzw);
                float4 r1_xyzw_7 = (i.texcoord4.xxxy / i.texcoord4.wwww);
                float r1_z_7 = r1_xyzw_7.z;
                float r1_w_4 = r1_xyzw_7.w;
                float4 r2_xyzw_10 = t0.Sample(s1, float4(r1_z_7, r1_w_4, r1_z_7, r1_z_7));
                float r1_y_9 = (r1_y_8 + -r2_xyzw_10.x);
                float r0_w_4 = mad(r0_w_3, r1_y_9, r2_xyzw_10.x);
                float4 r1_xyzw_10 = (r0_w_4.xxxx * _LightColor0.xxyz);
                float r1_y_10 = r1_xyzw_10.y;
                float r1_z_8 = r1_xyzw_10.z;
                float r1_w_5 = r1_xyzw_10.w;
                float3 r3_xyz_4;
                if ((r1_x_6 != 0))
                {
                    float r0_w_5 = (cb6_values[0].y == 1);
                    float3 r2_xyz_15 = (((mad(cb6_values[3].xyzx, i.texcoord1.zzzz, (mad(cb6_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r2_xyzw_18 = (((((r0_w_5.xxxx ? r2_xyz_15.xyzx : i.texcoord1.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r2_y_18 = r2_xyzw_18.y;
                    float r2_z_18 = r2_xyzw_18.z;
                    float r2_w_7 = r2_xyzw_18.w;
                    float r0_w_6 = (r2_y_18 * 0.25);
                    float r2_y_19 = mad(-cb6_values[0].z, 0.5, 0.25);
                    float r0_w_7 = max(r0_w_6, (cb6_values[0].z * 0.5));
                    float r2_x_18 = min(r2_y_19, r0_w_7);
                    float4 r3_xyzw_2 = t1.Sample(s0, float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18));
                    float4 r4_xyzw_2 = t1.Sample(s0, ((float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18) + float4(0.25, 0, 0, 0))).xyzx);
                    float4 r2_xyzw_19 = (float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18) + float4(0.5, 0, 0, 0));
                    float r2_x_19 = r2_xyzw_19.x;
                    float r2_y_20 = r2_xyzw_19.y;
                    float r2_z_19 = r2_xyzw_19.z;
                    float4 r2_xyzw_20 = t1.Sample(s0, float4(r2_x_19, r2_y_20, r2_z_19, r2_x_19));
                    float3 TEXCOORD0_xyz_1 = (i.texcoord0.xyzx).xyz;
                    float r5_w_1 = 1;
                    float r3_x_3 = dot(r3_xyzw_2, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    float r3_y_3 = dot(r4_xyzw_2, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    float r3_z_3 = dot(r2_xyzw_20, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    r3_xyz_4 = float3(r3_x_3, r3_y_3, r3_z_3);
                }
                else
                {
                    float3 TEXCOORD0_xyz_11 = (i.texcoord0.xyzx).xyz;
                    float r2_w_6 = 1;
                    float r3_x_1 = dot(cb2_values[39].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    float r3_y_1 = dot(cb2_values[40].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    float r3_z_1 = dot(cb2_values[41].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    r3_xyz_4 = float3(r3_x_1, r3_y_1, r3_z_1);
                }
                float4 r2_xyzw_22 = (r3_xyz_4.xyzx + i.texcoord2.xyzx);
                float r2_x_22 = r2_xyzw_22.x;
                float r2_y_23 = r2_xyzw_22.y;
                float r2_z_22 = r2_xyzw_22.z;
                float4 r2_xyzw_23 = max(float4(r2_x_22, r2_y_23, r2_z_22, r2_x_22), float4(0, 0, 0, 0));
                float r2_x_23 = r2_xyzw_23.x;
                float r2_y_24 = r2_xyzw_23.y;
                float r2_z_23 = r2_xyzw_23.z;
                float4 r2_xyzw_24 = log2(float4(r2_x_23, r2_y_24, r2_z_23, r2_x_23));
                float r2_x_24 = r2_xyzw_24.x;
                float r2_y_25 = r2_xyzw_24.y;
                float r2_z_24 = r2_xyzw_24.z;
                float4 r2_xyzw_25 = (float4(r2_x_24, r2_y_25, r2_z_24, r2_x_24) * float4(0.41666666, 0.41666666, 0.41666666, 0));
                float r2_x_25 = r2_xyzw_25.x;
                float r2_y_26 = r2_xyzw_25.y;
                float r2_z_25 = r2_xyzw_25.z;
                float4 r2_xyzw_26 = exp2(float4(r2_x_25, r2_y_26, r2_z_25, r2_x_25));
                float r2_x_26 = r2_xyzw_26.x;
                float r2_y_27 = r2_xyzw_26.y;
                float r2_z_26 = r2_xyzw_26.z;
                float4 r2_xyzw_27 = mad(float4(r2_x_26, r2_y_27, r2_z_26, r2_x_26), float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0));
                float r2_x_27 = r2_xyzw_27.x;
                float r2_y_28 = r2_xyzw_27.y;
                float r2_z_27 = r2_xyzw_27.z;
                float4 r2_xyzw_28 = max(float4(r2_x_27, r2_y_28, r2_z_27, r2_x_27), float4(0, 0, 0, 0));
                float r2_x_28 = r2_xyzw_28.x;
                float r2_y_29 = r2_xyzw_28.y;
                float r2_z_28 = r2_xyzw_28.z;
                float r0_w_9 = dot(i.texcoord0.xyzx, unity_ProbeVolumeParams.xyzx);
                float r0_w_10 = max(r0_w_9, 0);
                float4 r1_xyzw_9 = (r0_xyz_1.xyzx * float4(r1_y_10, r1_z_8, r1_w_5, r1_y_10));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_11 = r1_xyzw_9.y;
                float r1_z_9 = r1_xyzw_9.z;
                float r0_w_11 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_12 = (-r0_w_11 + 1);
                float r0_w_13 = (r0_w_12 * cb1_values[5].z);
                float r0_w_14 = max(r0_w_13, 0);
                float r0_w_15 = mad(r0_w_14, cb5_values[1].z, cb5_values[1].w);
                o.sv_Target0.xyz = (mad(r0_w_15.xxxx, (((mad(float4(r1_x_9, r1_y_11, r1_z_9, r1_x_9), r0_w_10.xxxx, ((r0_xyz_1.xyzx * float4(r2_x_28, r2_y_29, r2_z_28, r2_x_28))).xyzx)).xyzx + -cb5_values[0].xyzx)).xyzx, cb5_values[0].xyzx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Tint;
                float4 cb0_values[6];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            Texture3D t0 : register(t0);
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
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program36Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program36Output
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
                float3 r0_xyz_4 = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = clipPos_xyzw_2;
                float r0_w_4 = (clipPos_xyzw_2.z / unity_WorldToObject[1].y);
                float r0_w_5 = (-r0_w_4 + 1);
                float r0_w_6 = (r0_w_5 * unity_WorldToObject[1].z);
                float r0_w_7 = max(r0_w_6, 0);
                o.texcoord3.x = mad(r0_w_7, cb4_values[1].z, cb4_values[1].w);
                float worldNormal_x_3 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3), float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3));
                float r0_w_9 = rsqrt(r0_w_8);
                float3 unitWorldNormal_xyz_4 = ((r0_w_9.xxxx * float4(worldNormal_x_3, worldNormal_y_3, worldNormal_z_3, worldNormal_x_3))).xyz;
                o.texcoord0.xyz = (unitWorldNormal_xyz_4.xyzx).xyz;
                o.texcoord1.xyz = (r0_xyz_4.xyzx).xyz;
                o.color0.xyzw = i.color0.xyzw;
                float r0_w_10 = (unitWorldNormal_xyz_4.y * unitWorldNormal_xyz_4.y);
                float r0_w_11 = mad(unitWorldNormal_xyz_4.x, unitWorldNormal_xyz_4.x, -r0_w_10);
                float4 r2_xyzw_4 = (unitWorldNormal_xyz_4.yzzx * unitWorldNormal_xyz_4.xyzz);
                float r3_x_1 = dot(cb1_values[42].xyzw, r2_xyzw_4);
                float r3_y_1 = dot(cb1_values[43].xyzw, r2_xyzw_4);
                float r3_z_1 = dot(cb1_values[44].xyzw, r2_xyzw_4);
                float r1_w_3 = 1;
                float r3_x_2 = dot(cb1_values[39].xyzw, float4(unitWorldNormal_xyz_4.x, unitWorldNormal_xyz_4.y, unitWorldNormal_xyz_4.z, r1_w_3));
                float r3_y_2 = dot(cb1_values[40].xyzw, float4(unitWorldNormal_xyz_4.x, unitWorldNormal_xyz_4.y, unitWorldNormal_xyz_4.z, r1_w_3));
                float r3_z_2 = dot(cb1_values[41].xyzw, float4(unitWorldNormal_xyz_4.x, unitWorldNormal_xyz_4.y, unitWorldNormal_xyz_4.z, r1_w_3));
                float3 r2_xyz_9 = (((log2((max((((mad(cb1_values[45].xyzx, r0_w_11.xxxx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1))).xyzx + float4(r3_x_2, r3_y_2, r3_z_2, r3_x_2))).xyzx, float4(0, 0, 0, 0))).xyzx)).xyzx * float4(0.41666666, 0.41666666, 0.41666666, 0))).xyz;
                float4 r3_xyzw_3 = (-r0_xyz_4.yyyy + cb1_values[4].xyzw);
                float4 r3_xyzw_4 = (r3_xyzw_3 * r3_xyzw_3);
                float4 r5_xyzw_1 = (-r0_xyz_4.xxxx + cb1_values[3].xyzw);
                float4 r0_xyzw_5 = (-r0_xyz_4.zzzz + cb1_values[5].xyzw);
                float4 r1_xyzw_5 = mad(r0_xyzw_5, unitWorldNormal_xyz_4.zzzz, mad(r5_xyzw_1, unitWorldNormal_xyz_4.xxxx, (unitWorldNormal_xyz_4.yyyy * r3_xyzw_3)));
                float4 r3_xyzw_5 = mad(r5_xyzw_1, r5_xyzw_1, r3_xyzw_4);
                float4 r0_xyzw_6 = mad(r0_xyzw_5, r0_xyzw_5, r3_xyzw_5);
                float4 r0_xyzw_7 = max(r0_xyzw_6, float4(1E-06, 1E-06, 1E-06, 1E-06));
                float4 r3_xyzw_6 = rsqrt(r0_xyzw_7);
                float4 r0_xyzw_8 = mad(r0_xyzw_7, cb1_values[6].xyzw, float4(1, 1, 1, 1));
                float4 r0_xyzw_9 = (float4(1, 1, 1, 1) / r0_xyzw_8);
                float4 r1_xyzw_6 = (r1_xyzw_5 * r3_xyzw_6);
                float4 r1_xyzw_7 = max(r1_xyzw_6, float4(0, 0, 0, 0));
                float4 r0_xyzw_10 = (r0_xyzw_9 * r1_xyzw_7);
                float3 r0_xyz_12 = (mad(cb1_values[10].xyzx, r0_xyzw_10.wwww, (mad(cb1_values[9].xyzx, r0_xyzw_10.zzzz, (mad(cb1_values[7].xyzx, r0_xyzw_10.xxxx, ((r0_xyzw_10.yyyy * cb1_values[8].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord2.xyz = (((max((mad((exp2(r2_xyz_9.xyzx)).xyzx, float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0))).xyzx, float4(0, 0, 0, 0))).xyzx + r0_xyz_12.xyzx)).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program36Output frag(program36Input i)
            {
                program36Output o = (program36Output)0;
                float3 r0_xyz_1 = ((i.color0.xyzx * _Tint.xyzx)).xyz;
                float r0_w_1 = (cb3_values[0].x == 1);
                float r1_x_10;
                float r1_y_11;
                float r1_z_10;
                float r1_w_4;
                if (r0_w_1)
                {
                    float r0_w_2 = (cb3_values[0].y == 1);
                    float3 r1_xyz_5 = (((mad(cb3_values[3].xyzx, i.texcoord1.zzzz, (mad(cb3_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb3_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb3_values[4].xyzx)).xyz;
                    float4 r1_xyzw_8 = (((((r0_w_2.xxxx ? r1_xyz_5.xyzx : i.texcoord1.xyzx)).xyzx + -cb3_values[6].xyzx)).xxyz * cb3_values[5].xxyz);
                    float r1_y_8 = r1_xyzw_8.y;
                    float r1_z_8 = r1_xyzw_8.z;
                    float r1_w_2 = r1_xyzw_8.w;
                    float r0_w_3 = mad(r1_y_8, 0.25, 0.75);
                    float r1_y_9 = mad(cb3_values[0].z, 0.5, 0.75);
                    float r1_x_8 = max(r0_w_3, r1_y_9);
                    float4 r1_xyzw_9 = t0.Sample(s0, float4(r1_x_8, r1_z_8, r1_w_2, r1_x_8));
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
                float r0_w_5 = dot(float4(r1_x_10, r1_y_11, r1_z_10, r1_w_4), unity_OcclusionMaskSelector);
                float4 r1_xyzw_11 = (r0_w_5.xxxx * _LightColor0.xyzx);
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_12 = r1_xyzw_11.y;
                float r1_z_11 = r1_xyzw_11.z;
                float r0_w_6 = dot(i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx);
                float r0_w_7 = max(r0_w_6, 0);
                float4 r1_xyzw_12 = (r0_xyz_1.xyzx * float4(r1_x_11, r1_y_12, r1_z_11, r1_x_11));
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_13 = r1_xyzw_12.y;
                float r1_z_12 = r1_xyzw_12.z;
                float TEXCOORD0_w_8 = i.texcoord3.x;
                o.sv_Target0.xyz = (mad(TEXCOORD0_w_8.xxxx, (((mad(float4(r1_x_12, r1_y_13, r1_z_12, r1_x_12), r0_w_7.xxxx, ((r0_xyz_1.xyzx * i.texcoord2.xyzx)).xyzx)).xyzx + -unity_ProbeVolumeParams.xyzx)).xyzx, unity_ProbeVolumeParams.xyzx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Tint;
                float4 cb0_values[6];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[46];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
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
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program38Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program38Output
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
                o.texcoord1.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = clipPos_xyzw_7;
                o.texcoord3.x = clipPos_xyzw_7.z;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                float3 unitWorldNormal_xyz_3 = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord0.xyz = (unitWorldNormal_xyz_3.xyzx).xyz;
                o.color0.xyzw = i.color0.xyzw;
                float r1_w_4 = (unitWorldNormal_xyz_3.y * unitWorldNormal_xyz_3.y);
                float r1_w_5 = mad(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.x, -r1_w_4);
                float4 r2_xyzw_1 = (unitWorldNormal_xyz_3.yzzx * unitWorldNormal_xyz_3.xyzz);
                float r1_x_4 = dot(cb1_values[42].xyzw, r2_xyzw_1);
                float r1_y_4 = dot(cb1_values[43].xyzw, r2_xyzw_1);
                float r1_z_4 = dot(cb1_values[44].xyzw, r2_xyzw_1);
                o.texcoord2.xyz = (mad(cb1_values[45].xyzx, r1_w_5.xxxx, float4(r1_x_4, r1_y_4, r1_z_4, r1_x_4))).xyz;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r1_xyzw_5 = (float4(clipPos_xyzw_7.x, clipPos_xyzw_7.x, clipPos_xyzw_7.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_5 = r1_xyzw_5.x;
                float r1_z_5 = r1_xyzw_5.z;
                float r1_w_6 = r1_xyzw_5.w;
                o.texcoord4.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord4.xy = ((r1_z_5.xxxx + float4(r1_x_5, r1_w_6, r1_x_5, r1_x_5))).xy;
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program38Output frag(program38Input i)
            {
                program38Output o = (program38Output)0;
                float3 r0_xyz_1 = ((i.color0.xyzx * _Tint.xyzx)).xyz;
                float r2_x_1 = cb4_values[9].z;
                float r2_y_1 = cb4_values[10].z;
                float r2_z_1 = cb4_values[11].z;
                float r0_w_1 = dot(((-i.texcoord1.xyzx + cb1_values[4].xyzx)).xyzx, float4(r2_x_1, r2_y_1, r2_z_1, r2_x_1));
                float3 r1_xyz_2 = ((i.texcoord1.xyzx + -cb3_values[25].xyzx)).xyz;
                float r0_w_2 = mad(cb3_values[25].w, (-r0_w_1 + sqrt(dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx))), r0_w_1);
                float r0_w_3 = mad(r0_w_2, cb3_values[24].z, cb3_values[24].w);
                float r1_x_6 = (cb6_values[0].x == 1);
                float r2_x_9;
                float r2_y_9;
                float r2_z_9;
                float r2_w_4;
                if (r1_x_6)
                {
                    float r1_y_3 = (cb6_values[0].y == 1);
                    float3 r2_xyz_6 = (((mad(cb6_values[3].xyzx, i.texcoord1.zzzz, (mad(cb6_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r1_xyzw_4 = (r1_y_3.xxxx ? r2_xyz_6.xxyz : i.texcoord1.xxyz);
                    float r1_y_4 = r1_xyzw_4.y;
                    float r1_z_3 = r1_xyzw_4.z;
                    float r1_w_1 = r1_xyzw_4.w;
                    float4 r1_xyzw_5 = (float4(r1_y_4, r1_y_4, r1_z_3, r1_w_1) + -cb6_values[6].xxyz);
                    float r1_y_5 = r1_xyzw_5.y;
                    float r1_z_4 = r1_xyzw_5.z;
                    float r1_w_2 = r1_xyzw_5.w;
                    float4 r2_xyzw_7 = (float4(r1_y_5, r1_y_5, r1_z_4, r1_w_2) * cb6_values[5].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_2 = r2_xyzw_7.w;
                    float r1_y_6 = mad(r2_y_7, 0.25, 0.75);
                    float r1_z_5 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r2_x_7 = max(r1_z_5, r1_y_6);
                    float4 r2_xyzw_8 = t1.Sample(s0, float4(r2_x_7, r2_z_7, r2_w_2, r2_x_7));
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
                float r1_y_8 = dot(float4(r2_x_9, r2_y_9, r2_z_9, r2_w_4), cb2_values[46].xyzw);
                float4 r1_xyzw_7 = (i.texcoord4.xxxy / i.texcoord4.wwww);
                float r1_z_7 = r1_xyzw_7.z;
                float r1_w_4 = r1_xyzw_7.w;
                float4 r2_xyzw_10 = t0.Sample(s1, float4(r1_z_7, r1_w_4, r1_z_7, r1_z_7));
                float r1_y_9 = (r1_y_8 + -r2_xyzw_10.x);
                float r0_w_4 = mad(r0_w_3, r1_y_9, r2_xyzw_10.x);
                float4 r1_xyzw_10 = (r0_w_4.xxxx * _LightColor0.xxyz);
                float r1_y_10 = r1_xyzw_10.y;
                float r1_z_8 = r1_xyzw_10.z;
                float r1_w_5 = r1_xyzw_10.w;
                float3 r3_xyz_4;
                if ((r1_x_6 != 0))
                {
                    float r0_w_5 = (cb6_values[0].y == 1);
                    float3 r2_xyz_15 = (((mad(cb6_values[3].xyzx, i.texcoord1.zzzz, (mad(cb6_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r2_xyzw_18 = (((((r0_w_5.xxxx ? r2_xyz_15.xyzx : i.texcoord1.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r2_y_18 = r2_xyzw_18.y;
                    float r2_z_18 = r2_xyzw_18.z;
                    float r2_w_7 = r2_xyzw_18.w;
                    float r0_w_6 = (r2_y_18 * 0.25);
                    float r2_y_19 = mad(-cb6_values[0].z, 0.5, 0.25);
                    float r0_w_7 = max(r0_w_6, (cb6_values[0].z * 0.5));
                    float r2_x_18 = min(r2_y_19, r0_w_7);
                    float4 r3_xyzw_2 = t1.Sample(s0, float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18));
                    float4 r4_xyzw_2 = t1.Sample(s0, ((float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18) + float4(0.25, 0, 0, 0))).xyzx);
                    float4 r2_xyzw_19 = (float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18) + float4(0.5, 0, 0, 0));
                    float r2_x_19 = r2_xyzw_19.x;
                    float r2_y_20 = r2_xyzw_19.y;
                    float r2_z_19 = r2_xyzw_19.z;
                    float4 r2_xyzw_20 = t1.Sample(s0, float4(r2_x_19, r2_y_20, r2_z_19, r2_x_19));
                    float3 TEXCOORD0_xyz_1 = (i.texcoord0.xyzx).xyz;
                    float r5_w_1 = 1;
                    float r3_x_3 = dot(r3_xyzw_2, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    float r3_y_3 = dot(r4_xyzw_2, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    float r3_z_3 = dot(r2_xyzw_20, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    r3_xyz_4 = float3(r3_x_3, r3_y_3, r3_z_3);
                }
                else
                {
                    float3 TEXCOORD0_xyz_11 = (i.texcoord0.xyzx).xyz;
                    float r2_w_6 = 1;
                    float r3_x_1 = dot(cb2_values[39].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    float r3_y_1 = dot(cb2_values[40].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    float r3_z_1 = dot(cb2_values[41].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    r3_xyz_4 = float3(r3_x_1, r3_y_1, r3_z_1);
                }
                float4 r2_xyzw_22 = (r3_xyz_4.xyzx + i.texcoord2.xyzx);
                float r2_x_22 = r2_xyzw_22.x;
                float r2_y_23 = r2_xyzw_22.y;
                float r2_z_22 = r2_xyzw_22.z;
                float4 r2_xyzw_23 = max(float4(r2_x_22, r2_y_23, r2_z_22, r2_x_22), float4(0, 0, 0, 0));
                float r2_x_23 = r2_xyzw_23.x;
                float r2_y_24 = r2_xyzw_23.y;
                float r2_z_23 = r2_xyzw_23.z;
                float4 r2_xyzw_24 = log2(float4(r2_x_23, r2_y_24, r2_z_23, r2_x_23));
                float r2_x_24 = r2_xyzw_24.x;
                float r2_y_25 = r2_xyzw_24.y;
                float r2_z_24 = r2_xyzw_24.z;
                float4 r2_xyzw_25 = (float4(r2_x_24, r2_y_25, r2_z_24, r2_x_24) * float4(0.41666666, 0.41666666, 0.41666666, 0));
                float r2_x_25 = r2_xyzw_25.x;
                float r2_y_26 = r2_xyzw_25.y;
                float r2_z_25 = r2_xyzw_25.z;
                float4 r2_xyzw_26 = exp2(float4(r2_x_25, r2_y_26, r2_z_25, r2_x_25));
                float r2_x_26 = r2_xyzw_26.x;
                float r2_y_27 = r2_xyzw_26.y;
                float r2_z_26 = r2_xyzw_26.z;
                float4 r2_xyzw_27 = mad(float4(r2_x_26, r2_y_27, r2_z_26, r2_x_26), float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0));
                float r2_x_27 = r2_xyzw_27.x;
                float r2_y_28 = r2_xyzw_27.y;
                float r2_z_27 = r2_xyzw_27.z;
                float4 r2_xyzw_28 = max(float4(r2_x_27, r2_y_28, r2_z_27, r2_x_27), float4(0, 0, 0, 0));
                float r2_x_28 = r2_xyzw_28.x;
                float r2_y_29 = r2_xyzw_28.y;
                float r2_z_28 = r2_xyzw_28.z;
                float r0_w_9 = dot(i.texcoord0.xyzx, unity_ProbeVolumeParams.xyzx);
                float r0_w_10 = max(r0_w_9, 0);
                float4 r1_xyzw_9 = (r0_xyz_1.xyzx * float4(r1_y_10, r1_z_8, r1_w_5, r1_y_10));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_11 = r1_xyzw_9.y;
                float r1_z_9 = r1_xyzw_9.z;
                float r0_w_11 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_12 = (-r0_w_11 + 1);
                float r0_w_13 = (r0_w_12 * cb1_values[5].z);
                float r0_w_14 = max(r0_w_13, 0);
                float r0_w_15 = mad(r0_w_14, cb5_values[1].z, cb5_values[1].w);
                o.sv_Target0.xyz = (mad(r0_w_15.xxxx, (((mad(float4(r1_x_9, r1_y_11, r1_z_9, r1_x_9), r0_w_10.xxxx, ((r0_xyz_1.xyzx * float4(r2_x_28, r2_y_29, r2_z_28, r2_x_28))).xyzx)).xyzx + -cb5_values[0].xyzx)).xyzx, cb5_values[0].xyzx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Tint;
                float4 cb0_values[6];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program37Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program37Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program19Output vert(program19Input i)
            {
                program19Output o = (program19Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = clipPos_xyzw_7;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord3.x = clipPos_xyzw_7.z;
                o.color0.xyzw = i.color0.xyzw;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r1_xyzw_3 = (float4(clipPos_xyzw_7.x, clipPos_xyzw_7.x, clipPos_xyzw_7.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_z_3 = r1_xyzw_3.z;
                float r1_w_4 = r1_xyzw_3.w;
                o.texcoord4.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord4.xy = ((r1_z_3.xxxx + float4(r1_x_3, r1_w_4, r1_x_3, r1_x_3))).xy;
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program37Output frag(program37Input i)
            {
                program37Output o = (program37Output)0;
                float r2_x_1 = cb4_values[9].z;
                float r2_y_1 = cb4_values[10].z;
                float r2_z_1 = cb4_values[11].z;
                float r0_w_1 = dot(((-i.texcoord1.xyzx + cb1_values[4].xyzx)).xyzx, float4(r2_x_1, r2_y_1, r2_z_1, r2_x_1));
                float3 r1_xyz_2 = ((i.texcoord1.xyzx + -cb3_values[25].xyzx)).xyz;
                float r0_w_2 = mad(cb3_values[25].w, (-r0_w_1 + sqrt(dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx))), r0_w_1);
                float r0_w_3 = mad(r0_w_2, cb3_values[24].z, cb3_values[24].w);
                float r1_x_13;
                float r1_y_13;
                float r1_z_12;
                float r1_w_8;
                if ((cb6_values[0].x == 1))
                {
                    float4 r1_xyzw_4 = (i.texcoord1.yyyy * cb6_values[2].xxyz);
                    float r1_y_4 = r1_xyzw_4.y;
                    float r1_z_4 = r1_xyzw_4.z;
                    float r1_w_2 = r1_xyzw_4.w;
                    float4 r1_xyzw_5 = mad(cb6_values[1].xxyz, i.texcoord1.xxxx, float4(r1_y_4, r1_y_4, r1_z_4, r1_w_2));
                    float r1_y_5 = r1_xyzw_5.y;
                    float r1_z_5 = r1_xyzw_5.z;
                    float r1_w_3 = r1_xyzw_5.w;
                    float4 r1_xyzw_6 = mad(cb6_values[3].xxyz, i.texcoord1.zzzz, float4(r1_y_5, r1_y_5, r1_z_5, r1_w_3));
                    float r1_y_6 = r1_xyzw_6.y;
                    float r1_z_6 = r1_xyzw_6.z;
                    float r1_w_4 = r1_xyzw_6.w;
                    float4 r1_xyzw_7 = (float4(r1_y_6, r1_y_6, r1_z_6, r1_w_4) + cb6_values[4].xxyz);
                    float r1_y_7 = r1_xyzw_7.y;
                    float r1_z_7 = r1_xyzw_7.z;
                    float r1_w_5 = r1_xyzw_7.w;
                    float4 r1_xyzw_9 = (((cb6_values[0].y == 1)).xxxx ? float4(r1_y_7, r1_z_7, r1_w_5, r1_y_7) : i.texcoord1.xyzx);
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
                    float4 r1_xyzw_12 = t1.Sample(s0, float4(r1_x_11, r1_z_10, r1_w_6, r1_x_11));
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
                float4 r1_xyzw_14 = (i.texcoord4.xxyx / i.texcoord4.wwww);
                float r1_y_14 = r1_xyzw_14.y;
                float r1_z_13 = r1_xyzw_14.z;
                float4 r2_xyzw_4 = t0.Sample(s1, float4(r1_y_14, r1_z_13, r1_y_14, r1_y_14));
                float r0_w_4 = mad(r0_w_3, (dot(float4(r1_x_13, r1_y_13, r1_z_12, r1_w_8), cb2_values[46].xyzw) + -r2_xyzw_4.x), r2_xyzw_4.x);
                float4 r1_xyzw_16 = (r0_w_4.xxxx * _LightColor0.xyzx);
                float r1_x_16 = r1_xyzw_16.x;
                float r1_y_15 = r1_xyzw_16.y;
                float r1_z_14 = r1_xyzw_16.z;
                float r0_w_5 = dot(i.texcoord0.xyzx, unity_ProbeVolumeParams.xyzx);
                float r0_w_6 = max(r0_w_5, 0);
                float3 r0_xyz_3 = (mad(((((i.color0.xyzx * _Tint.xyzx)).xyzx * float4(r1_x_16, r1_y_15, r1_z_14, r1_x_16))).xyzx, r0_w_6.xxxx, -cb5_values[0].xyzx)).xyz;
                o.sv_Target0.xyz = (mad((mad(max((((i.texcoord3.x / cb1_values[5].y) + 1) * cb1_values[5].z), 0), cb5_values[1].z, cb5_values[1].w)).xxxx, r0_xyz_3.xyzx, cb5_values[0].xyzx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Tint;
                float4 cb0_values[6];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[46];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program38Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program38Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program18Output vert(program18Input i)
            {
                program18Output o = (program18Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                o.texcoord1.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = clipPos_xyzw_7;
                o.texcoord3.x = mad(max((((clipPos_xyzw_7.z / unity_WorldToObject[1].y) + 1) * unity_WorldToObject[1].z), 0), cb4_values[1].z, cb4_values[1].w);
                float worldNormal_x_12 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12), float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12));
                float r0_w_9 = rsqrt(r0_w_8);
                float4 unitWorldNormal_xyzw_13 = (r0_w_9.xxxx * float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12));
                float unitWorldNormal_x_13 = unitWorldNormal_xyzw_13.x;
                float unitWorldNormal_y_9 = unitWorldNormal_xyzw_13.y;
                float unitWorldNormal_z_9 = unitWorldNormal_xyzw_13.z;
                o.texcoord0.xyz = (float4(unitWorldNormal_x_13, unitWorldNormal_y_9, unitWorldNormal_z_9, unitWorldNormal_x_13)).xyz;
                o.color0.xyzw = i.color0.xyzw;
                float4 r2_xyzw_1 = (float4(unitWorldNormal_y_9, unitWorldNormal_z_9, unitWorldNormal_z_9, unitWorldNormal_x_13) * float4(unitWorldNormal_x_13, unitWorldNormal_y_9, unitWorldNormal_z_9, unitWorldNormal_z_9));
                float r3_x_1 = dot(cb1_values[42].xyzw, r2_xyzw_1);
                float r3_y_1 = dot(cb1_values[43].xyzw, r2_xyzw_1);
                float r3_z_1 = dot(cb1_values[44].xyzw, r2_xyzw_1);
                float4 r1_xyzw_4 = mad(cb1_values[45].xyzx, (mad(unitWorldNormal_x_13, unitWorldNormal_x_13, (unitWorldNormal_y_9 * unitWorldNormal_y_9))).xxxx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_2 = r1_xyzw_4.y;
                float r1_z_2 = r1_xyzw_4.z;
                float r0_w_10 = 1;
                float r2_x_2 = dot(cb1_values[39].xyzw, float4(unitWorldNormal_x_13, unitWorldNormal_y_9, unitWorldNormal_z_9, r0_w_10));
                float r2_y_2 = dot(cb1_values[40].xyzw, float4(unitWorldNormal_x_13, unitWorldNormal_y_9, unitWorldNormal_z_9, r0_w_10));
                float r2_z_2 = dot(cb1_values[41].xyzw, float4(unitWorldNormal_x_13, unitWorldNormal_y_9, unitWorldNormal_z_9, r0_w_10));
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
                o.texcoord2.xyz = (max(float4(r0_x_19, r0_y_15, r0_z_15, r0_x_19), float4(0, 0, 0, 0))).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program38Output frag(program38Input i)
            {
                program38Output o = (program38Output)0;
                float3 r0_xyz_1 = ((i.color0.xyzx * _Tint.xyzx)).xyz;
                float r2_x_1 = cb4_values[9].z;
                float r2_y_1 = cb4_values[10].z;
                float r2_z_1 = cb4_values[11].z;
                float r0_w_1 = dot(((-i.texcoord1.xyzx + cb1_values[4].xyzx)).xyzx, float4(r2_x_1, r2_y_1, r2_z_1, r2_x_1));
                float3 r1_xyz_2 = ((i.texcoord1.xyzx + -cb3_values[25].xyzx)).xyz;
                float r0_w_2 = mad(cb3_values[25].w, (-r0_w_1 + sqrt(dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx))), r0_w_1);
                float r0_w_3 = mad(r0_w_2, cb3_values[24].z, cb3_values[24].w);
                float r1_x_6 = (cb6_values[0].x == 1);
                float r2_x_9;
                float r2_y_9;
                float r2_z_9;
                float r2_w_4;
                if (r1_x_6)
                {
                    float r1_y_3 = (cb6_values[0].y == 1);
                    float3 r2_xyz_6 = (((mad(cb6_values[3].xyzx, i.texcoord1.zzzz, (mad(cb6_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r1_xyzw_4 = (r1_y_3.xxxx ? r2_xyz_6.xxyz : i.texcoord1.xxyz);
                    float r1_y_4 = r1_xyzw_4.y;
                    float r1_z_3 = r1_xyzw_4.z;
                    float r1_w_1 = r1_xyzw_4.w;
                    float4 r1_xyzw_5 = (float4(r1_y_4, r1_y_4, r1_z_3, r1_w_1) + -cb6_values[6].xxyz);
                    float r1_y_5 = r1_xyzw_5.y;
                    float r1_z_4 = r1_xyzw_5.z;
                    float r1_w_2 = r1_xyzw_5.w;
                    float4 r2_xyzw_7 = (float4(r1_y_5, r1_y_5, r1_z_4, r1_w_2) * cb6_values[5].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_2 = r2_xyzw_7.w;
                    float r1_y_6 = mad(r2_y_7, 0.25, 0.75);
                    float r1_z_5 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r2_x_7 = max(r1_z_5, r1_y_6);
                    float4 r2_xyzw_8 = t1.Sample(s0, float4(r2_x_7, r2_z_7, r2_w_2, r2_x_7));
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
                float r1_y_8 = dot(float4(r2_x_9, r2_y_9, r2_z_9, r2_w_4), cb2_values[46].xyzw);
                float4 r1_xyzw_7 = (i.texcoord4.xxxy / i.texcoord4.wwww);
                float r1_z_7 = r1_xyzw_7.z;
                float r1_w_4 = r1_xyzw_7.w;
                float4 r2_xyzw_10 = t0.Sample(s1, float4(r1_z_7, r1_w_4, r1_z_7, r1_z_7));
                float r1_y_9 = (r1_y_8 + -r2_xyzw_10.x);
                float r0_w_4 = mad(r0_w_3, r1_y_9, r2_xyzw_10.x);
                float4 r1_xyzw_10 = (r0_w_4.xxxx * _LightColor0.xxyz);
                float r1_y_10 = r1_xyzw_10.y;
                float r1_z_8 = r1_xyzw_10.z;
                float r1_w_5 = r1_xyzw_10.w;
                float3 r3_xyz_4;
                if ((r1_x_6 != 0))
                {
                    float r0_w_5 = (cb6_values[0].y == 1);
                    float3 r2_xyz_15 = (((mad(cb6_values[3].xyzx, i.texcoord1.zzzz, (mad(cb6_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r2_xyzw_18 = (((((r0_w_5.xxxx ? r2_xyz_15.xyzx : i.texcoord1.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r2_y_18 = r2_xyzw_18.y;
                    float r2_z_18 = r2_xyzw_18.z;
                    float r2_w_7 = r2_xyzw_18.w;
                    float r0_w_6 = (r2_y_18 * 0.25);
                    float r2_y_19 = mad(-cb6_values[0].z, 0.5, 0.25);
                    float r0_w_7 = max(r0_w_6, (cb6_values[0].z * 0.5));
                    float r2_x_18 = min(r2_y_19, r0_w_7);
                    float4 r3_xyzw_2 = t1.Sample(s0, float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18));
                    float4 r4_xyzw_2 = t1.Sample(s0, ((float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18) + float4(0.25, 0, 0, 0))).xyzx);
                    float4 r2_xyzw_19 = (float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18) + float4(0.5, 0, 0, 0));
                    float r2_x_19 = r2_xyzw_19.x;
                    float r2_y_20 = r2_xyzw_19.y;
                    float r2_z_19 = r2_xyzw_19.z;
                    float4 r2_xyzw_20 = t1.Sample(s0, float4(r2_x_19, r2_y_20, r2_z_19, r2_x_19));
                    float3 TEXCOORD0_xyz_1 = (i.texcoord0.xyzx).xyz;
                    float r5_w_1 = 1;
                    float r3_x_3 = dot(r3_xyzw_2, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    float r3_y_3 = dot(r4_xyzw_2, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    float r3_z_3 = dot(r2_xyzw_20, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    r3_xyz_4 = float3(r3_x_3, r3_y_3, r3_z_3);
                }
                else
                {
                    float3 TEXCOORD0_xyz_11 = (i.texcoord0.xyzx).xyz;
                    float r2_w_6 = 1;
                    float r3_x_1 = dot(cb2_values[39].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    float r3_y_1 = dot(cb2_values[40].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    float r3_z_1 = dot(cb2_values[41].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    r3_xyz_4 = float3(r3_x_1, r3_y_1, r3_z_1);
                }
                float4 r2_xyzw_22 = (r3_xyz_4.xyzx + i.texcoord2.xyzx);
                float r2_x_22 = r2_xyzw_22.x;
                float r2_y_23 = r2_xyzw_22.y;
                float r2_z_22 = r2_xyzw_22.z;
                float4 r2_xyzw_23 = max(float4(r2_x_22, r2_y_23, r2_z_22, r2_x_22), float4(0, 0, 0, 0));
                float r2_x_23 = r2_xyzw_23.x;
                float r2_y_24 = r2_xyzw_23.y;
                float r2_z_23 = r2_xyzw_23.z;
                float4 r2_xyzw_24 = log2(float4(r2_x_23, r2_y_24, r2_z_23, r2_x_23));
                float r2_x_24 = r2_xyzw_24.x;
                float r2_y_25 = r2_xyzw_24.y;
                float r2_z_24 = r2_xyzw_24.z;
                float4 r2_xyzw_25 = (float4(r2_x_24, r2_y_25, r2_z_24, r2_x_24) * float4(0.41666666, 0.41666666, 0.41666666, 0));
                float r2_x_25 = r2_xyzw_25.x;
                float r2_y_26 = r2_xyzw_25.y;
                float r2_z_25 = r2_xyzw_25.z;
                float4 r2_xyzw_26 = exp2(float4(r2_x_25, r2_y_26, r2_z_25, r2_x_25));
                float r2_x_26 = r2_xyzw_26.x;
                float r2_y_27 = r2_xyzw_26.y;
                float r2_z_26 = r2_xyzw_26.z;
                float4 r2_xyzw_27 = mad(float4(r2_x_26, r2_y_27, r2_z_26, r2_x_26), float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0));
                float r2_x_27 = r2_xyzw_27.x;
                float r2_y_28 = r2_xyzw_27.y;
                float r2_z_27 = r2_xyzw_27.z;
                float4 r2_xyzw_28 = max(float4(r2_x_27, r2_y_28, r2_z_27, r2_x_27), float4(0, 0, 0, 0));
                float r2_x_28 = r2_xyzw_28.x;
                float r2_y_29 = r2_xyzw_28.y;
                float r2_z_28 = r2_xyzw_28.z;
                float r0_w_9 = dot(i.texcoord0.xyzx, unity_ProbeVolumeParams.xyzx);
                float r0_w_10 = max(r0_w_9, 0);
                float4 r1_xyzw_9 = (r0_xyz_1.xyzx * float4(r1_y_10, r1_z_8, r1_w_5, r1_y_10));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_11 = r1_xyzw_9.y;
                float r1_z_9 = r1_xyzw_9.z;
                float r0_w_11 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_12 = (-r0_w_11 + 1);
                float r0_w_13 = (r0_w_12 * cb1_values[5].z);
                float r0_w_14 = max(r0_w_13, 0);
                float r0_w_15 = mad(r0_w_14, cb5_values[1].z, cb5_values[1].w);
                o.sv_Target0.xyz = (mad(r0_w_15.xxxx, (((mad(float4(r1_x_9, r1_y_11, r1_z_9, r1_x_9), r0_w_10.xxxx, ((r0_xyz_1.xyzx * float4(r2_x_28, r2_y_29, r2_z_28, r2_x_28))).xyzx)).xyzx + -cb5_values[0].xyzx)).xyzx, cb5_values[0].xyzx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Tint;
                float4 cb0_values[6];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            Texture3D t0 : register(t0);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program36Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program36Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program18Output vert(program18Input i)
            {
                program18Output o = (program18Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                o.texcoord1.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = clipPos_xyzw_7;
                o.texcoord3.x = mad(max((((clipPos_xyzw_7.z / unity_WorldToObject[1].y) + 1) * unity_WorldToObject[1].z), 0), cb4_values[1].z, cb4_values[1].w);
                float worldNormal_x_12 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12), float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12));
                float r0_w_9 = rsqrt(r0_w_8);
                float4 unitWorldNormal_xyzw_13 = (r0_w_9.xxxx * float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12));
                float unitWorldNormal_x_13 = unitWorldNormal_xyzw_13.x;
                float unitWorldNormal_y_9 = unitWorldNormal_xyzw_13.y;
                float unitWorldNormal_z_9 = unitWorldNormal_xyzw_13.z;
                o.texcoord0.xyz = (float4(unitWorldNormal_x_13, unitWorldNormal_y_9, unitWorldNormal_z_9, unitWorldNormal_x_13)).xyz;
                o.color0.xyzw = i.color0.xyzw;
                float4 r2_xyzw_1 = (float4(unitWorldNormal_y_9, unitWorldNormal_z_9, unitWorldNormal_z_9, unitWorldNormal_x_13) * float4(unitWorldNormal_x_13, unitWorldNormal_y_9, unitWorldNormal_z_9, unitWorldNormal_z_9));
                float r3_x_1 = dot(cb1_values[42].xyzw, r2_xyzw_1);
                float r3_y_1 = dot(cb1_values[43].xyzw, r2_xyzw_1);
                float r3_z_1 = dot(cb1_values[44].xyzw, r2_xyzw_1);
                float4 r1_xyzw_4 = mad(cb1_values[45].xyzx, (mad(unitWorldNormal_x_13, unitWorldNormal_x_13, (unitWorldNormal_y_9 * unitWorldNormal_y_9))).xxxx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_2 = r1_xyzw_4.y;
                float r1_z_2 = r1_xyzw_4.z;
                float r0_w_10 = 1;
                float r2_x_2 = dot(cb1_values[39].xyzw, float4(unitWorldNormal_x_13, unitWorldNormal_y_9, unitWorldNormal_z_9, r0_w_10));
                float r2_y_2 = dot(cb1_values[40].xyzw, float4(unitWorldNormal_x_13, unitWorldNormal_y_9, unitWorldNormal_z_9, r0_w_10));
                float r2_z_2 = dot(cb1_values[41].xyzw, float4(unitWorldNormal_x_13, unitWorldNormal_y_9, unitWorldNormal_z_9, r0_w_10));
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
                o.texcoord2.xyz = (max(float4(r0_x_19, r0_y_15, r0_z_15, r0_x_19), float4(0, 0, 0, 0))).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program36Output frag(program36Input i)
            {
                program36Output o = (program36Output)0;
                float3 r0_xyz_1 = ((i.color0.xyzx * _Tint.xyzx)).xyz;
                float r0_w_1 = (cb3_values[0].x == 1);
                float r1_x_10;
                float r1_y_11;
                float r1_z_10;
                float r1_w_4;
                if (r0_w_1)
                {
                    float r0_w_2 = (cb3_values[0].y == 1);
                    float3 r1_xyz_5 = (((mad(cb3_values[3].xyzx, i.texcoord1.zzzz, (mad(cb3_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb3_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb3_values[4].xyzx)).xyz;
                    float4 r1_xyzw_8 = (((((r0_w_2.xxxx ? r1_xyz_5.xyzx : i.texcoord1.xyzx)).xyzx + -cb3_values[6].xyzx)).xxyz * cb3_values[5].xxyz);
                    float r1_y_8 = r1_xyzw_8.y;
                    float r1_z_8 = r1_xyzw_8.z;
                    float r1_w_2 = r1_xyzw_8.w;
                    float r0_w_3 = mad(r1_y_8, 0.25, 0.75);
                    float r1_y_9 = mad(cb3_values[0].z, 0.5, 0.75);
                    float r1_x_8 = max(r0_w_3, r1_y_9);
                    float4 r1_xyzw_9 = t0.Sample(s0, float4(r1_x_8, r1_z_8, r1_w_2, r1_x_8));
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
                float r0_w_5 = dot(float4(r1_x_10, r1_y_11, r1_z_10, r1_w_4), unity_OcclusionMaskSelector);
                float4 r1_xyzw_11 = (r0_w_5.xxxx * _LightColor0.xyzx);
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_12 = r1_xyzw_11.y;
                float r1_z_11 = r1_xyzw_11.z;
                float r0_w_6 = dot(i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx);
                float r0_w_7 = max(r0_w_6, 0);
                float4 r1_xyzw_12 = (r0_xyz_1.xyzx * float4(r1_x_11, r1_y_12, r1_z_11, r1_x_11));
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_13 = r1_xyzw_12.y;
                float r1_z_12 = r1_xyzw_12.z;
                float TEXCOORD0_w_8 = i.texcoord3.x;
                o.sv_Target0.xyz = (mad(TEXCOORD0_w_8.xxxx, (((mad(float4(r1_x_12, r1_y_13, r1_z_12, r1_x_12), r0_w_7.xxxx, ((r0_xyz_1.xyzx * i.texcoord2.xyzx)).xyzx)).xyzx + -unity_ProbeVolumeParams.xyzx)).xyzx, unity_ProbeVolumeParams.xyzx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Tint;
                float4 cb0_values[6];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program37Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program37Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program17Output vert(program17Input i)
            {
                program17Output o = (program17Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = clipPos_xyzw_7;
                o.texcoord3.x = mad(max((((clipPos_xyzw_7.z / unity_WorldToObject[1].y) + 1) * unity_WorldToObject[1].z), 0), cb3_values[1].z, cb3_values[1].w);
                float worldNormal_x_12 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12), float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord0.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12))).xyz;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program37Output frag(program37Input i)
            {
                program37Output o = (program37Output)0;
                float r2_x_1 = cb4_values[9].z;
                float r2_y_1 = cb4_values[10].z;
                float r2_z_1 = cb4_values[11].z;
                float r0_w_1 = dot(((-i.texcoord1.xyzx + cb1_values[4].xyzx)).xyzx, float4(r2_x_1, r2_y_1, r2_z_1, r2_x_1));
                float3 r1_xyz_2 = ((i.texcoord1.xyzx + -cb3_values[25].xyzx)).xyz;
                float r0_w_2 = mad(cb3_values[25].w, (-r0_w_1 + sqrt(dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx))), r0_w_1);
                float r0_w_3 = mad(r0_w_2, cb3_values[24].z, cb3_values[24].w);
                float r1_x_13;
                float r1_y_13;
                float r1_z_12;
                float r1_w_8;
                if ((cb6_values[0].x == 1))
                {
                    float4 r1_xyzw_4 = (i.texcoord1.yyyy * cb6_values[2].xxyz);
                    float r1_y_4 = r1_xyzw_4.y;
                    float r1_z_4 = r1_xyzw_4.z;
                    float r1_w_2 = r1_xyzw_4.w;
                    float4 r1_xyzw_5 = mad(cb6_values[1].xxyz, i.texcoord1.xxxx, float4(r1_y_4, r1_y_4, r1_z_4, r1_w_2));
                    float r1_y_5 = r1_xyzw_5.y;
                    float r1_z_5 = r1_xyzw_5.z;
                    float r1_w_3 = r1_xyzw_5.w;
                    float4 r1_xyzw_6 = mad(cb6_values[3].xxyz, i.texcoord1.zzzz, float4(r1_y_5, r1_y_5, r1_z_5, r1_w_3));
                    float r1_y_6 = r1_xyzw_6.y;
                    float r1_z_6 = r1_xyzw_6.z;
                    float r1_w_4 = r1_xyzw_6.w;
                    float4 r1_xyzw_7 = (float4(r1_y_6, r1_y_6, r1_z_6, r1_w_4) + cb6_values[4].xxyz);
                    float r1_y_7 = r1_xyzw_7.y;
                    float r1_z_7 = r1_xyzw_7.z;
                    float r1_w_5 = r1_xyzw_7.w;
                    float4 r1_xyzw_9 = (((cb6_values[0].y == 1)).xxxx ? float4(r1_y_7, r1_z_7, r1_w_5, r1_y_7) : i.texcoord1.xyzx);
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
                    float4 r1_xyzw_12 = t1.Sample(s0, float4(r1_x_11, r1_z_10, r1_w_6, r1_x_11));
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
                float4 r1_xyzw_14 = (i.texcoord4.xxyx / i.texcoord4.wwww);
                float r1_y_14 = r1_xyzw_14.y;
                float r1_z_13 = r1_xyzw_14.z;
                float4 r2_xyzw_4 = t0.Sample(s1, float4(r1_y_14, r1_z_13, r1_y_14, r1_y_14));
                float r0_w_4 = mad(r0_w_3, (dot(float4(r1_x_13, r1_y_13, r1_z_12, r1_w_8), cb2_values[46].xyzw) + -r2_xyzw_4.x), r2_xyzw_4.x);
                float4 r1_xyzw_16 = (r0_w_4.xxxx * _LightColor0.xyzx);
                float r1_x_16 = r1_xyzw_16.x;
                float r1_y_15 = r1_xyzw_16.y;
                float r1_z_14 = r1_xyzw_16.z;
                float r0_w_5 = dot(i.texcoord0.xyzx, unity_ProbeVolumeParams.xyzx);
                float r0_w_6 = max(r0_w_5, 0);
                float3 r0_xyz_3 = (mad(((((i.color0.xyzx * _Tint.xyzx)).xyzx * float4(r1_x_16, r1_y_15, r1_z_14, r1_x_16))).xyzx, r0_w_6.xxxx, -cb5_values[0].xyzx)).xyz;
                o.sv_Target0.xyz = (mad((mad(max((((i.texcoord3.x / cb1_values[5].y) + 1) * cb1_values[5].z), 0), cb5_values[1].z, cb5_values[1].w)).xxxx, r0_xyz_3.xyzx, cb5_values[0].xyzx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Tint;
                float4 cb0_values[6];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[21];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[7];
            };
            SamplerState s0 : register(s0);
            Texture3D t0 : register(t0);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program35Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program35Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program17Output vert(program17Input i)
            {
                program17Output o = (program17Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = clipPos_xyzw_7;
                o.texcoord3.x = mad(max((((clipPos_xyzw_7.z / unity_WorldToObject[1].y) + 1) * unity_WorldToObject[1].z), 0), cb3_values[1].z, cb3_values[1].w);
                float worldNormal_x_12 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12), float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord0.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12))).xyz;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program35Output frag(program35Input i)
            {
                program35Output o = (program35Output)0;
                float r0_w_1 = (cb3_values[0].x == 1);
                float r1_x_10;
                float r1_y_11;
                float r1_z_10;
                float r1_w_4;
                if (r0_w_1)
                {
                    float r0_w_2 = (cb3_values[0].y == 1);
                    float3 r1_xyz_5 = (((mad(cb3_values[3].xyzx, i.texcoord1.zzzz, (mad(cb3_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb3_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb3_values[4].xyzx)).xyz;
                    float4 r1_xyzw_8 = (((((r0_w_2.xxxx ? r1_xyz_5.xyzx : i.texcoord1.xyzx)).xyzx + -cb3_values[6].xyzx)).xxyz * cb3_values[5].xxyz);
                    float r1_y_8 = r1_xyzw_8.y;
                    float r1_z_8 = r1_xyzw_8.z;
                    float r1_w_2 = r1_xyzw_8.w;
                    float r0_w_3 = mad(r1_y_8, 0.25, 0.75);
                    float r1_y_9 = mad(cb3_values[0].z, 0.5, 0.75);
                    float r1_x_8 = max(r0_w_3, r1_y_9);
                    float4 r1_xyzw_9 = t0.Sample(s0, float4(r1_x_8, r1_z_8, r1_w_2, r1_x_8));
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
                float r0_w_5 = dot(float4(r1_x_10, r1_y_11, r1_z_10, r1_w_4), unity_OcclusionMaskSelector);
                float4 r1_xyzw_11 = (r0_w_5.xxxx * _LightColor0.xyzx);
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_12 = r1_xyzw_11.y;
                float r1_z_11 = r1_xyzw_11.z;
                float r0_w_6 = dot(i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx);
                float r0_w_7 = max(r0_w_6, 0);
                float TEXCOORD0_x_12 = i.texcoord3.x;
                o.sv_Target0.xyz = (mad(TEXCOORD0_x_12.xxxx, (mad(((((i.color0.xyzx * _Tint.xyzx)).xyzx * float4(r1_x_11, r1_y_12, r1_z_11, r1_x_11))).xyzx, r0_w_7.xxxx, -unity_ProbeVolumeParams.xyzx)).xyzx, unity_ProbeVolumeParams.xyzx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Tint;
                float4 cb0_values[6];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[46];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program38Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program38Output
            {
                float4 sv_Target0 : SV_Target0;
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
                o.sv_Position0.xyzw = clipPos_xyzw_2;
                float worldNormal_x_4 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_w_4 = dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4));
                float r0_w_5 = rsqrt(r0_w_4);
                float3 unitWorldNormal_xyz_5 = ((r0_w_5.xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4))).xyz;
                o.texcoord0.xyz = (unitWorldNormal_xyz_5.xyzx).xyz;
                o.texcoord1.xyz = (r0_xyz_4.xyzx).xyz;
                o.color0.xyzw = i.color0.xyzw;
                float4 r3_xyzw_1 = (-r0_xyz_4.xxxx + cb1_values[3].xyzw);
                float4 r4_xyzw_1 = (-r0_xyz_4.yyyy + cb1_values[4].xyzw);
                float4 r0_xyzw_5 = (-r0_xyz_4.zzzz + cb1_values[5].xyzw);
                float4 r0_xyzw_6 = mad(r0_xyzw_5, r0_xyzw_5, mad(r3_xyzw_1, r3_xyzw_1, (r4_xyzw_1 * r4_xyzw_1)));
                float4 r0_xyzw_7 = max(r0_xyzw_6, float4(1E-06, 1E-06, 1E-06, 1E-06));
                float4 r0_xyzw_8 = mad(r0_xyzw_7, cb1_values[6].xyzw, float4(1, 1, 1, 1));
                float4 r0_xyzw_9 = (float4(1, 1, 1, 1) / r0_xyzw_8);
                float4 r0_xyzw_10 = (r0_xyzw_9 * max((mad(r0_xyzw_5, unitWorldNormal_xyz_5.zzzz, mad(r3_xyzw_1, unitWorldNormal_xyz_5.xxxx, (unitWorldNormal_xyz_5.yyyy * r4_xyzw_1))) * rsqrt(r0_xyzw_7)), float4(0, 0, 0, 0)));
                float3 r0_xyz_12 = (mad(cb1_values[10].xyzx, r0_xyzw_10.wwww, (mad(cb1_values[9].xyzx, r0_xyzw_10.zzzz, (mad(cb1_values[7].xyzx, r0_xyzw_10.xxxx, ((r0_xyzw_10.yyyy * cb1_values[8].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                float r0_w_12 = (unitWorldNormal_xyz_5.y * unitWorldNormal_xyz_5.y);
                float r0_w_13 = mad(unitWorldNormal_xyz_5.x, unitWorldNormal_xyz_5.x, -r0_w_12);
                float4 r2_xyzw_6 = (unitWorldNormal_xyz_5.yzzx * unitWorldNormal_xyz_5.xyzz);
                float r4_x_5 = dot(cb1_values[42].xyzw, r2_xyzw_6);
                float r4_y_5 = dot(cb1_values[43].xyzw, r2_xyzw_6);
                float r4_z_5 = dot(cb1_values[44].xyzw, r2_xyzw_6);
                o.texcoord2.xyz = (mad(r0_xyz_12.xyzx, (mad(r0_xyz_12.xyzx, (mad(r0_xyz_12.xyzx, float4(0.30530602, 0.30530602, 0.30530602, 0), float4(0.6821711, 0.6821711, 0.6821711, 0))).xyzx, float4(0.012522878, 0.012522878, 0.012522878, 0))).xyzx, (mad(cb1_values[45].xyzx, r0_w_13.xxxx, float4(r4_x_5, r4_y_5, r4_z_5, r4_x_5))).xyzx)).xyz;
                float r0_w_14 = ((clipPos_xyzw_2.y * unity_WorldToObject[1].x) * 0.5);
                float4 r0_xyzw_14 = (clipPos_xyzw_2.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_14 = r0_xyzw_14.x;
                float r0_z_13 = r0_xyzw_14.z;
                o.texcoord4.zw = (clipPos_xyzw_2.zzzw).zw;
                o.texcoord4.xy = ((r0_z_13.xxxx + float4(r0_x_14, r0_w_14, r0_x_14, r0_x_14))).xy;
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program38Output frag(program38Input i)
            {
                program38Output o = (program38Output)0;
                float3 r0_xyz_1 = ((i.color0.xyzx * _Tint.xyzx)).xyz;
                float r2_x_1 = cb4_values[9].z;
                float r2_y_1 = cb4_values[10].z;
                float r2_z_1 = cb4_values[11].z;
                float r0_w_1 = dot(((-i.texcoord1.xyzx + cb1_values[4].xyzx)).xyzx, float4(r2_x_1, r2_y_1, r2_z_1, r2_x_1));
                float3 r1_xyz_2 = ((i.texcoord1.xyzx + -cb3_values[25].xyzx)).xyz;
                float r0_w_2 = mad(cb3_values[25].w, (-r0_w_1 + sqrt(dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx))), r0_w_1);
                float r0_w_3 = mad(r0_w_2, cb3_values[24].z, cb3_values[24].w);
                float r1_x_6 = (cb6_values[0].x == 1);
                float r2_x_9;
                float r2_y_9;
                float r2_z_9;
                float r2_w_4;
                if (r1_x_6)
                {
                    float r1_y_3 = (cb6_values[0].y == 1);
                    float3 r2_xyz_6 = (((mad(cb6_values[3].xyzx, i.texcoord1.zzzz, (mad(cb6_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r1_xyzw_4 = (r1_y_3.xxxx ? r2_xyz_6.xxyz : i.texcoord1.xxyz);
                    float r1_y_4 = r1_xyzw_4.y;
                    float r1_z_3 = r1_xyzw_4.z;
                    float r1_w_1 = r1_xyzw_4.w;
                    float4 r1_xyzw_5 = (float4(r1_y_4, r1_y_4, r1_z_3, r1_w_1) + -cb6_values[6].xxyz);
                    float r1_y_5 = r1_xyzw_5.y;
                    float r1_z_4 = r1_xyzw_5.z;
                    float r1_w_2 = r1_xyzw_5.w;
                    float4 r2_xyzw_7 = (float4(r1_y_5, r1_y_5, r1_z_4, r1_w_2) * cb6_values[5].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_2 = r2_xyzw_7.w;
                    float r1_y_6 = mad(r2_y_7, 0.25, 0.75);
                    float r1_z_5 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r2_x_7 = max(r1_z_5, r1_y_6);
                    float4 r2_xyzw_8 = t1.Sample(s0, float4(r2_x_7, r2_z_7, r2_w_2, r2_x_7));
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
                float r1_y_8 = dot(float4(r2_x_9, r2_y_9, r2_z_9, r2_w_4), cb2_values[46].xyzw);
                float4 r1_xyzw_7 = (i.texcoord4.xxxy / i.texcoord4.wwww);
                float r1_z_7 = r1_xyzw_7.z;
                float r1_w_4 = r1_xyzw_7.w;
                float4 r2_xyzw_10 = t0.Sample(s1, float4(r1_z_7, r1_w_4, r1_z_7, r1_z_7));
                float r1_y_9 = (r1_y_8 + -r2_xyzw_10.x);
                float r0_w_4 = mad(r0_w_3, r1_y_9, r2_xyzw_10.x);
                float4 r1_xyzw_10 = (r0_w_4.xxxx * _LightColor0.xxyz);
                float r1_y_10 = r1_xyzw_10.y;
                float r1_z_8 = r1_xyzw_10.z;
                float r1_w_5 = r1_xyzw_10.w;
                float3 r3_xyz_4;
                if ((r1_x_6 != 0))
                {
                    float r0_w_5 = (cb6_values[0].y == 1);
                    float3 r2_xyz_15 = (((mad(cb6_values[3].xyzx, i.texcoord1.zzzz, (mad(cb6_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r2_xyzw_18 = (((((r0_w_5.xxxx ? r2_xyz_15.xyzx : i.texcoord1.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r2_y_18 = r2_xyzw_18.y;
                    float r2_z_18 = r2_xyzw_18.z;
                    float r2_w_7 = r2_xyzw_18.w;
                    float r0_w_6 = (r2_y_18 * 0.25);
                    float r2_y_19 = mad(-cb6_values[0].z, 0.5, 0.25);
                    float r0_w_7 = max(r0_w_6, (cb6_values[0].z * 0.5));
                    float r2_x_18 = min(r2_y_19, r0_w_7);
                    float4 r3_xyzw_2 = t1.Sample(s0, float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18));
                    float4 r4_xyzw_2 = t1.Sample(s0, ((float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18) + float4(0.25, 0, 0, 0))).xyzx);
                    float4 r2_xyzw_19 = (float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18) + float4(0.5, 0, 0, 0));
                    float r2_x_19 = r2_xyzw_19.x;
                    float r2_y_20 = r2_xyzw_19.y;
                    float r2_z_19 = r2_xyzw_19.z;
                    float4 r2_xyzw_20 = t1.Sample(s0, float4(r2_x_19, r2_y_20, r2_z_19, r2_x_19));
                    float3 TEXCOORD0_xyz_1 = (i.texcoord0.xyzx).xyz;
                    float r5_w_1 = 1;
                    float r3_x_3 = dot(r3_xyzw_2, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    float r3_y_3 = dot(r4_xyzw_2, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    float r3_z_3 = dot(r2_xyzw_20, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    r3_xyz_4 = float3(r3_x_3, r3_y_3, r3_z_3);
                }
                else
                {
                    float3 TEXCOORD0_xyz_11 = (i.texcoord0.xyzx).xyz;
                    float r2_w_6 = 1;
                    float r3_x_1 = dot(cb2_values[39].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    float r3_y_1 = dot(cb2_values[40].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    float r3_z_1 = dot(cb2_values[41].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    r3_xyz_4 = float3(r3_x_1, r3_y_1, r3_z_1);
                }
                float4 r2_xyzw_22 = (r3_xyz_4.xyzx + i.texcoord2.xyzx);
                float r2_x_22 = r2_xyzw_22.x;
                float r2_y_23 = r2_xyzw_22.y;
                float r2_z_22 = r2_xyzw_22.z;
                float4 r2_xyzw_23 = max(float4(r2_x_22, r2_y_23, r2_z_22, r2_x_22), float4(0, 0, 0, 0));
                float r2_x_23 = r2_xyzw_23.x;
                float r2_y_24 = r2_xyzw_23.y;
                float r2_z_23 = r2_xyzw_23.z;
                float4 r2_xyzw_24 = log2(float4(r2_x_23, r2_y_24, r2_z_23, r2_x_23));
                float r2_x_24 = r2_xyzw_24.x;
                float r2_y_25 = r2_xyzw_24.y;
                float r2_z_24 = r2_xyzw_24.z;
                float4 r2_xyzw_25 = (float4(r2_x_24, r2_y_25, r2_z_24, r2_x_24) * float4(0.41666666, 0.41666666, 0.41666666, 0));
                float r2_x_25 = r2_xyzw_25.x;
                float r2_y_26 = r2_xyzw_25.y;
                float r2_z_25 = r2_xyzw_25.z;
                float4 r2_xyzw_26 = exp2(float4(r2_x_25, r2_y_26, r2_z_25, r2_x_25));
                float r2_x_26 = r2_xyzw_26.x;
                float r2_y_27 = r2_xyzw_26.y;
                float r2_z_26 = r2_xyzw_26.z;
                float4 r2_xyzw_27 = mad(float4(r2_x_26, r2_y_27, r2_z_26, r2_x_26), float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0));
                float r2_x_27 = r2_xyzw_27.x;
                float r2_y_28 = r2_xyzw_27.y;
                float r2_z_27 = r2_xyzw_27.z;
                float4 r2_xyzw_28 = max(float4(r2_x_27, r2_y_28, r2_z_27, r2_x_27), float4(0, 0, 0, 0));
                float r2_x_28 = r2_xyzw_28.x;
                float r2_y_29 = r2_xyzw_28.y;
                float r2_z_28 = r2_xyzw_28.z;
                float r0_w_9 = dot(i.texcoord0.xyzx, unity_ProbeVolumeParams.xyzx);
                float r0_w_10 = max(r0_w_9, 0);
                float4 r1_xyzw_9 = (r0_xyz_1.xyzx * float4(r1_y_10, r1_z_8, r1_w_5, r1_y_10));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_11 = r1_xyzw_9.y;
                float r1_z_9 = r1_xyzw_9.z;
                float r0_w_11 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_12 = (-r0_w_11 + 1);
                float r0_w_13 = (r0_w_12 * cb1_values[5].z);
                float r0_w_14 = max(r0_w_13, 0);
                float r0_w_15 = mad(r0_w_14, cb5_values[1].z, cb5_values[1].w);
                o.sv_Target0.xyz = (mad(r0_w_15.xxxx, (((mad(float4(r1_x_9, r1_y_11, r1_z_9, r1_x_9), r0_w_10.xxxx, ((r0_xyz_1.xyzx * float4(r2_x_28, r2_y_29, r2_z_28, r2_x_28))).xyzx)).xyzx + -cb5_values[0].xyzx)).xyzx, cb5_values[0].xyzx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Tint;
                float4 cb0_values[6];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[46];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program34Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program34Output
            {
                float4 sv_Target0 : SV_Target0;
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
                o.sv_Position0.xyzw = clipPos_xyzw_2;
                float worldNormal_x_4 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r0_w_4 = dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4));
                float r0_w_5 = rsqrt(r0_w_4);
                float3 unitWorldNormal_xyz_5 = ((r0_w_5.xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4))).xyz;
                o.texcoord0.xyz = (unitWorldNormal_xyz_5.xyzx).xyz;
                o.texcoord1.xyz = (r0_xyz_4.xyzx).xyz;
                o.color0.xyzw = i.color0.xyzw;
                float4 r3_xyzw_1 = (-r0_xyz_4.xxxx + cb1_values[3].xyzw);
                float4 r4_xyzw_1 = (-r0_xyz_4.yyyy + cb1_values[4].xyzw);
                float4 r0_xyzw_5 = (-r0_xyz_4.zzzz + cb1_values[5].xyzw);
                float4 r0_xyzw_6 = mad(r0_xyzw_5, r0_xyzw_5, mad(r3_xyzw_1, r3_xyzw_1, (r4_xyzw_1 * r4_xyzw_1)));
                float4 r0_xyzw_7 = max(r0_xyzw_6, float4(1E-06, 1E-06, 1E-06, 1E-06));
                float4 r0_xyzw_8 = mad(r0_xyzw_7, cb1_values[6].xyzw, float4(1, 1, 1, 1));
                float4 r0_xyzw_9 = (float4(1, 1, 1, 1) / r0_xyzw_8);
                float4 r0_xyzw_10 = (r0_xyzw_9 * max((mad(r0_xyzw_5, unitWorldNormal_xyz_5.zzzz, mad(r3_xyzw_1, unitWorldNormal_xyz_5.xxxx, (unitWorldNormal_xyz_5.yyyy * r4_xyzw_1))) * rsqrt(r0_xyzw_7)), float4(0, 0, 0, 0)));
                float3 r0_xyz_12 = (mad(cb1_values[10].xyzx, r0_xyzw_10.wwww, (mad(cb1_values[9].xyzx, r0_xyzw_10.zzzz, (mad(cb1_values[7].xyzx, r0_xyzw_10.xxxx, ((r0_xyzw_10.yyyy * cb1_values[8].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                float r0_w_12 = (unitWorldNormal_xyz_5.y * unitWorldNormal_xyz_5.y);
                float r0_w_13 = mad(unitWorldNormal_xyz_5.x, unitWorldNormal_xyz_5.x, -r0_w_12);
                float4 r2_xyzw_6 = (unitWorldNormal_xyz_5.yzzx * unitWorldNormal_xyz_5.xyzz);
                float r4_x_5 = dot(cb1_values[42].xyzw, r2_xyzw_6);
                float r4_y_5 = dot(cb1_values[43].xyzw, r2_xyzw_6);
                float r4_z_5 = dot(cb1_values[44].xyzw, r2_xyzw_6);
                o.texcoord2.xyz = (mad(r0_xyz_12.xyzx, (mad(r0_xyz_12.xyzx, (mad(r0_xyz_12.xyzx, float4(0.30530602, 0.30530602, 0.30530602, 0), float4(0.6821711, 0.6821711, 0.6821711, 0))).xyzx, float4(0.012522878, 0.012522878, 0.012522878, 0))).xyzx, (mad(cb1_values[45].xyzx, r0_w_13.xxxx, float4(r4_x_5, r4_y_5, r4_z_5, r4_x_5))).xyzx)).xyz;
                float r0_w_14 = ((clipPos_xyzw_2.y * unity_WorldToObject[1].x) * 0.5);
                float4 r0_xyzw_14 = (clipPos_xyzw_2.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_14 = r0_xyzw_14.x;
                float r0_z_13 = r0_xyzw_14.z;
                o.texcoord4.zw = (clipPos_xyzw_2.zzzw).zw;
                o.texcoord4.xy = ((r0_z_13.xxxx + float4(r0_x_14, r0_w_14, r0_x_14, r0_x_14))).xy;
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program34Output frag(program34Input i)
            {
                program34Output o = (program34Output)0;
                float3 r0_xyz_1 = ((i.color0.xyzx * _Tint.xyzx)).xyz;
                float r2_x_1 = cb4_values[9].z;
                float r2_y_1 = cb4_values[10].z;
                float r2_z_1 = cb4_values[11].z;
                float r0_w_1 = dot(((-i.texcoord1.xyzx + cb1_values[4].xyzx)).xyzx, float4(r2_x_1, r2_y_1, r2_z_1, r2_x_1));
                float3 r1_xyz_2 = ((i.texcoord1.xyzx + -cb3_values[25].xyzx)).xyz;
                float r0_w_2 = mad(cb3_values[25].w, (-r0_w_1 + sqrt(dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx))), r0_w_1);
                float r0_w_3 = mad(r0_w_2, cb3_values[24].z, cb3_values[24].w);
                float r1_x_6 = (cb5_values[0].x == 1);
                float r2_x_9;
                float r2_y_9;
                float r2_z_9;
                float r2_w_4;
                if (r1_x_6)
                {
                    float r1_y_3 = (cb5_values[0].y == 1);
                    float3 r2_xyz_6 = (((mad(cb5_values[3].xyzx, i.texcoord1.zzzz, (mad(cb5_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r1_xyzw_4 = (r1_y_3.xxxx ? r2_xyz_6.xxyz : i.texcoord1.xxyz);
                    float r1_y_4 = r1_xyzw_4.y;
                    float r1_z_3 = r1_xyzw_4.z;
                    float r1_w_1 = r1_xyzw_4.w;
                    float4 r1_xyzw_5 = (float4(r1_y_4, r1_y_4, r1_z_3, r1_w_1) + -cb5_values[6].xxyz);
                    float r1_y_5 = r1_xyzw_5.y;
                    float r1_z_4 = r1_xyzw_5.z;
                    float r1_w_2 = r1_xyzw_5.w;
                    float4 r2_xyzw_7 = (float4(r1_y_5, r1_y_5, r1_z_4, r1_w_2) * cb5_values[5].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_2 = r2_xyzw_7.w;
                    float r1_y_6 = mad(r2_y_7, 0.25, 0.75);
                    float r1_z_5 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r2_x_7 = max(r1_z_5, r1_y_6);
                    float4 r2_xyzw_8 = t1.Sample(s0, float4(r2_x_7, r2_z_7, r2_w_2, r2_x_7));
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
                float r1_y_8 = dot(float4(r2_x_9, r2_y_9, r2_z_9, r2_w_4), cb2_values[46].xyzw);
                float4 r1_xyzw_7 = (i.texcoord4.xxxy / i.texcoord4.wwww);
                float r1_z_7 = r1_xyzw_7.z;
                float r1_w_4 = r1_xyzw_7.w;
                float4 r2_xyzw_10 = t0.Sample(s1, float4(r1_z_7, r1_w_4, r1_z_7, r1_z_7));
                float r1_y_9 = (r1_y_8 + -r2_xyzw_10.x);
                float r0_w_4 = mad(r0_w_3, r1_y_9, r2_xyzw_10.x);
                float4 r1_xyzw_10 = (r0_w_4.xxxx * _LightColor0.xxyz);
                float r1_y_10 = r1_xyzw_10.y;
                float r1_z_8 = r1_xyzw_10.z;
                float r1_w_5 = r1_xyzw_10.w;
                float3 r3_xyz_4;
                if ((r1_x_6 != 0))
                {
                    float r0_w_5 = (cb5_values[0].y == 1);
                    float3 r2_xyz_15 = (((mad(cb5_values[3].xyzx, i.texcoord1.zzzz, (mad(cb5_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r2_xyzw_18 = (((((r0_w_5.xxxx ? r2_xyz_15.xyzx : i.texcoord1.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r2_y_18 = r2_xyzw_18.y;
                    float r2_z_18 = r2_xyzw_18.z;
                    float r2_w_7 = r2_xyzw_18.w;
                    float r0_w_6 = (r2_y_18 * 0.25);
                    float r2_y_19 = mad(-cb5_values[0].z, 0.5, 0.25);
                    float r0_w_7 = max(r0_w_6, (cb5_values[0].z * 0.5));
                    float r2_x_18 = min(r2_y_19, r0_w_7);
                    float4 r3_xyzw_2 = t1.Sample(s0, float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18));
                    float4 r4_xyzw_2 = t1.Sample(s0, ((float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18) + float4(0.25, 0, 0, 0))).xyzx);
                    float4 r2_xyzw_19 = (float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18) + float4(0.5, 0, 0, 0));
                    float r2_x_19 = r2_xyzw_19.x;
                    float r2_y_20 = r2_xyzw_19.y;
                    float r2_z_19 = r2_xyzw_19.z;
                    float4 r2_xyzw_20 = t1.Sample(s0, float4(r2_x_19, r2_y_20, r2_z_19, r2_x_19));
                    float3 TEXCOORD0_xyz_1 = (i.texcoord0.xyzx).xyz;
                    float r5_w_1 = 1;
                    float r3_x_3 = dot(r3_xyzw_2, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    float r3_y_3 = dot(r4_xyzw_2, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    float r3_z_3 = dot(r2_xyzw_20, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    r3_xyz_4 = float3(r3_x_3, r3_y_3, r3_z_3);
                }
                else
                {
                    float3 TEXCOORD0_xyz_11 = (i.texcoord0.xyzx).xyz;
                    float r2_w_6 = 1;
                    float r3_x_1 = dot(cb2_values[39].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    float r3_y_1 = dot(cb2_values[40].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    float r3_z_1 = dot(cb2_values[41].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    r3_xyz_4 = float3(r3_x_1, r3_y_1, r3_z_1);
                }
                float4 r2_xyzw_22 = (r3_xyz_4.xyzx + i.texcoord2.xyzx);
                float r2_x_22 = r2_xyzw_22.x;
                float r2_y_23 = r2_xyzw_22.y;
                float r2_z_22 = r2_xyzw_22.z;
                float4 r2_xyzw_23 = max(float4(r2_x_22, r2_y_23, r2_z_22, r2_x_22), float4(0, 0, 0, 0));
                float r2_x_23 = r2_xyzw_23.x;
                float r2_y_24 = r2_xyzw_23.y;
                float r2_z_23 = r2_xyzw_23.z;
                float4 r2_xyzw_24 = log2(float4(r2_x_23, r2_y_24, r2_z_23, r2_x_23));
                float r2_x_24 = r2_xyzw_24.x;
                float r2_y_25 = r2_xyzw_24.y;
                float r2_z_24 = r2_xyzw_24.z;
                float4 r2_xyzw_25 = (float4(r2_x_24, r2_y_25, r2_z_24, r2_x_24) * float4(0.41666666, 0.41666666, 0.41666666, 0));
                float r2_x_25 = r2_xyzw_25.x;
                float r2_y_26 = r2_xyzw_25.y;
                float r2_z_25 = r2_xyzw_25.z;
                float4 r2_xyzw_26 = exp2(float4(r2_x_25, r2_y_26, r2_z_25, r2_x_25));
                float r2_x_26 = r2_xyzw_26.x;
                float r2_y_27 = r2_xyzw_26.y;
                float r2_z_26 = r2_xyzw_26.z;
                float4 r2_xyzw_27 = mad(float4(r2_x_26, r2_y_27, r2_z_26, r2_x_26), float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0));
                float r2_x_27 = r2_xyzw_27.x;
                float r2_y_28 = r2_xyzw_27.y;
                float r2_z_27 = r2_xyzw_27.z;
                float4 r2_xyzw_28 = max(float4(r2_x_27, r2_y_28, r2_z_27, r2_x_27), float4(0, 0, 0, 0));
                float r2_x_28 = r2_xyzw_28.x;
                float r2_y_29 = r2_xyzw_28.y;
                float r2_z_28 = r2_xyzw_28.z;
                float r0_w_9 = dot(i.texcoord0.xyzx, unity_ProbeVolumeParams.xyzx);
                float r0_w_10 = max(r0_w_9, 0);
                float4 r1_xyzw_9 = (r0_xyz_1.xyzx * float4(r1_y_10, r1_z_8, r1_w_5, r1_y_10));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_11 = r1_xyzw_9.y;
                float r1_z_9 = r1_xyzw_9.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_9, r1_y_11, r1_z_9, r1_x_9), r0_w_10.xxxx, ((r0_xyz_1.xyzx * float4(r2_x_28, r2_y_29, r2_z_28, r2_x_28))).xyzx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Tint;
                float4 cb0_values[46];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
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
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program38Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program38Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program14Output vert(program14Input i)
            {
                program14Output o = (program14Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float3 r0_xyz_4 = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r0_w_4 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r0_w_5 = rsqrt(r0_w_4);
                float3 unitWorldNormal_xyz_3 = ((r0_w_5.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord0.xyz = (unitWorldNormal_xyz_3.xyzx).xyz;
                o.texcoord1.xyz = (r0_xyz_4.xyzx).xyz;
                o.color0.xyzw = i.color0.xyzw;
                float r0_w_6 = (unitWorldNormal_xyz_3.y * unitWorldNormal_xyz_3.y);
                float r0_w_7 = mad(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.x, -r0_w_6);
                float4 r2_xyzw_4 = (unitWorldNormal_xyz_3.yzzx * unitWorldNormal_xyz_3.xyzz);
                float r3_x_1 = dot(cb0_values[42].xyzw, r2_xyzw_4);
                float r3_y_1 = dot(cb0_values[43].xyzw, r2_xyzw_4);
                float r3_z_1 = dot(cb0_values[44].xyzw, r2_xyzw_4);
                float r1_w_2 = 1;
                float r3_x_2 = dot(cb0_values[39].xyzw, float4(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.y, unitWorldNormal_xyz_3.z, r1_w_2));
                float r3_y_2 = dot(cb0_values[40].xyzw, float4(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.y, unitWorldNormal_xyz_3.z, r1_w_2));
                float r3_z_2 = dot(cb0_values[41].xyzw, float4(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.y, unitWorldNormal_xyz_3.z, r1_w_2));
                float3 r2_xyz_9 = (((log2((max((((mad(cb0_values[45].xyzx, r0_w_7.xxxx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1))).xyzx + float4(r3_x_2, r3_y_2, r3_z_2, r3_x_2))).xyzx, float4(0, 0, 0, 0))).xyzx)).xyzx * float4(0.41666666, 0.41666666, 0.41666666, 0))).xyz;
                float4 r3_xyzw_3 = (-r0_xyz_4.yyyy + unity_WorldToObject[0]);
                float4 r3_xyzw_4 = (r3_xyzw_3 * r3_xyzw_3);
                float4 r5_xyzw_1 = (-r0_xyz_4.xxxx + unity_ObjectToWorld[3]);
                float4 r0_xyzw_5 = (-r0_xyz_4.zzzz + unity_WorldToObject[1]);
                float4 r1_xyzw_4 = mad(r0_xyzw_5, unitWorldNormal_xyz_3.zzzz, mad(r5_xyzw_1, unitWorldNormal_xyz_3.xxxx, (unitWorldNormal_xyz_3.yyyy * r3_xyzw_3)));
                float4 r3_xyzw_5 = mad(r5_xyzw_1, r5_xyzw_1, r3_xyzw_4);
                float4 r0_xyzw_6 = mad(r0_xyzw_5, r0_xyzw_5, r3_xyzw_5);
                float4 r0_xyzw_7 = max(r0_xyzw_6, float4(1E-06, 1E-06, 1E-06, 1E-06));
                float4 r3_xyzw_6 = rsqrt(r0_xyzw_7);
                float4 r0_xyzw_8 = mad(r0_xyzw_7, unity_WorldToObject[2], float4(1, 1, 1, 1));
                float4 r0_xyzw_9 = (float4(1, 1, 1, 1) / r0_xyzw_8);
                float4 r1_xyzw_5 = (r1_xyzw_4 * r3_xyzw_6);
                float4 r1_xyzw_6 = max(r1_xyzw_5, float4(0, 0, 0, 0));
                float4 r0_xyzw_10 = (r0_xyzw_9 * r1_xyzw_6);
                float3 r0_xyz_12 = (mad(cb0_values[10].xyzx, r0_xyzw_10.wwww, (mad(cb0_values[9].xyzx, r0_xyzw_10.zzzz, (mad(unity_WorldToObject[3].xyzx, r0_xyzw_10.xxxx, ((r0_xyzw_10.yyyy * cb0_values[8].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord2.xyz = (((max((mad((exp2(r2_xyz_9.xyzx)).xyzx, float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0))).xyzx, float4(0, 0, 0, 0))).xyzx + r0_xyz_12.xyzx)).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program38Output frag(program38Input i)
            {
                program38Output o = (program38Output)0;
                float3 r0_xyz_1 = ((i.color0.xyzx * _Tint.xyzx)).xyz;
                float r2_x_1 = cb4_values[9].z;
                float r2_y_1 = cb4_values[10].z;
                float r2_z_1 = cb4_values[11].z;
                float r0_w_1 = dot(((-i.texcoord1.xyzx + cb1_values[4].xyzx)).xyzx, float4(r2_x_1, r2_y_1, r2_z_1, r2_x_1));
                float3 r1_xyz_2 = ((i.texcoord1.xyzx + -cb3_values[25].xyzx)).xyz;
                float r0_w_2 = mad(cb3_values[25].w, (-r0_w_1 + sqrt(dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx))), r0_w_1);
                float r0_w_3 = mad(r0_w_2, cb3_values[24].z, cb3_values[24].w);
                float r1_x_6 = (cb6_values[0].x == 1);
                float r2_x_9;
                float r2_y_9;
                float r2_z_9;
                float r2_w_4;
                if (r1_x_6)
                {
                    float r1_y_3 = (cb6_values[0].y == 1);
                    float3 r2_xyz_6 = (((mad(cb6_values[3].xyzx, i.texcoord1.zzzz, (mad(cb6_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r1_xyzw_4 = (r1_y_3.xxxx ? r2_xyz_6.xxyz : i.texcoord1.xxyz);
                    float r1_y_4 = r1_xyzw_4.y;
                    float r1_z_3 = r1_xyzw_4.z;
                    float r1_w_1 = r1_xyzw_4.w;
                    float4 r1_xyzw_5 = (float4(r1_y_4, r1_y_4, r1_z_3, r1_w_1) + -cb6_values[6].xxyz);
                    float r1_y_5 = r1_xyzw_5.y;
                    float r1_z_4 = r1_xyzw_5.z;
                    float r1_w_2 = r1_xyzw_5.w;
                    float4 r2_xyzw_7 = (float4(r1_y_5, r1_y_5, r1_z_4, r1_w_2) * cb6_values[5].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_2 = r2_xyzw_7.w;
                    float r1_y_6 = mad(r2_y_7, 0.25, 0.75);
                    float r1_z_5 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r2_x_7 = max(r1_z_5, r1_y_6);
                    float4 r2_xyzw_8 = t1.Sample(s0, float4(r2_x_7, r2_z_7, r2_w_2, r2_x_7));
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
                float r1_y_8 = dot(float4(r2_x_9, r2_y_9, r2_z_9, r2_w_4), cb2_values[46].xyzw);
                float4 r1_xyzw_7 = (i.texcoord4.xxxy / i.texcoord4.wwww);
                float r1_z_7 = r1_xyzw_7.z;
                float r1_w_4 = r1_xyzw_7.w;
                float4 r2_xyzw_10 = t0.Sample(s1, float4(r1_z_7, r1_w_4, r1_z_7, r1_z_7));
                float r1_y_9 = (r1_y_8 + -r2_xyzw_10.x);
                float r0_w_4 = mad(r0_w_3, r1_y_9, r2_xyzw_10.x);
                float4 r1_xyzw_10 = (r0_w_4.xxxx * _LightColor0.xxyz);
                float r1_y_10 = r1_xyzw_10.y;
                float r1_z_8 = r1_xyzw_10.z;
                float r1_w_5 = r1_xyzw_10.w;
                float3 r3_xyz_4;
                if ((r1_x_6 != 0))
                {
                    float r0_w_5 = (cb6_values[0].y == 1);
                    float3 r2_xyz_15 = (((mad(cb6_values[3].xyzx, i.texcoord1.zzzz, (mad(cb6_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r2_xyzw_18 = (((((r0_w_5.xxxx ? r2_xyz_15.xyzx : i.texcoord1.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r2_y_18 = r2_xyzw_18.y;
                    float r2_z_18 = r2_xyzw_18.z;
                    float r2_w_7 = r2_xyzw_18.w;
                    float r0_w_6 = (r2_y_18 * 0.25);
                    float r2_y_19 = mad(-cb6_values[0].z, 0.5, 0.25);
                    float r0_w_7 = max(r0_w_6, (cb6_values[0].z * 0.5));
                    float r2_x_18 = min(r2_y_19, r0_w_7);
                    float4 r3_xyzw_2 = t1.Sample(s0, float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18));
                    float4 r4_xyzw_2 = t1.Sample(s0, ((float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18) + float4(0.25, 0, 0, 0))).xyzx);
                    float4 r2_xyzw_19 = (float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18) + float4(0.5, 0, 0, 0));
                    float r2_x_19 = r2_xyzw_19.x;
                    float r2_y_20 = r2_xyzw_19.y;
                    float r2_z_19 = r2_xyzw_19.z;
                    float4 r2_xyzw_20 = t1.Sample(s0, float4(r2_x_19, r2_y_20, r2_z_19, r2_x_19));
                    float3 TEXCOORD0_xyz_1 = (i.texcoord0.xyzx).xyz;
                    float r5_w_1 = 1;
                    float r3_x_3 = dot(r3_xyzw_2, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    float r3_y_3 = dot(r4_xyzw_2, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    float r3_z_3 = dot(r2_xyzw_20, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    r3_xyz_4 = float3(r3_x_3, r3_y_3, r3_z_3);
                }
                else
                {
                    float3 TEXCOORD0_xyz_11 = (i.texcoord0.xyzx).xyz;
                    float r2_w_6 = 1;
                    float r3_x_1 = dot(cb2_values[39].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    float r3_y_1 = dot(cb2_values[40].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    float r3_z_1 = dot(cb2_values[41].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    r3_xyz_4 = float3(r3_x_1, r3_y_1, r3_z_1);
                }
                float4 r2_xyzw_22 = (r3_xyz_4.xyzx + i.texcoord2.xyzx);
                float r2_x_22 = r2_xyzw_22.x;
                float r2_y_23 = r2_xyzw_22.y;
                float r2_z_22 = r2_xyzw_22.z;
                float4 r2_xyzw_23 = max(float4(r2_x_22, r2_y_23, r2_z_22, r2_x_22), float4(0, 0, 0, 0));
                float r2_x_23 = r2_xyzw_23.x;
                float r2_y_24 = r2_xyzw_23.y;
                float r2_z_23 = r2_xyzw_23.z;
                float4 r2_xyzw_24 = log2(float4(r2_x_23, r2_y_24, r2_z_23, r2_x_23));
                float r2_x_24 = r2_xyzw_24.x;
                float r2_y_25 = r2_xyzw_24.y;
                float r2_z_24 = r2_xyzw_24.z;
                float4 r2_xyzw_25 = (float4(r2_x_24, r2_y_25, r2_z_24, r2_x_24) * float4(0.41666666, 0.41666666, 0.41666666, 0));
                float r2_x_25 = r2_xyzw_25.x;
                float r2_y_26 = r2_xyzw_25.y;
                float r2_z_25 = r2_xyzw_25.z;
                float4 r2_xyzw_26 = exp2(float4(r2_x_25, r2_y_26, r2_z_25, r2_x_25));
                float r2_x_26 = r2_xyzw_26.x;
                float r2_y_27 = r2_xyzw_26.y;
                float r2_z_26 = r2_xyzw_26.z;
                float4 r2_xyzw_27 = mad(float4(r2_x_26, r2_y_27, r2_z_26, r2_x_26), float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0));
                float r2_x_27 = r2_xyzw_27.x;
                float r2_y_28 = r2_xyzw_27.y;
                float r2_z_27 = r2_xyzw_27.z;
                float4 r2_xyzw_28 = max(float4(r2_x_27, r2_y_28, r2_z_27, r2_x_27), float4(0, 0, 0, 0));
                float r2_x_28 = r2_xyzw_28.x;
                float r2_y_29 = r2_xyzw_28.y;
                float r2_z_28 = r2_xyzw_28.z;
                float r0_w_9 = dot(i.texcoord0.xyzx, unity_ProbeVolumeParams.xyzx);
                float r0_w_10 = max(r0_w_9, 0);
                float4 r1_xyzw_9 = (r0_xyz_1.xyzx * float4(r1_y_10, r1_z_8, r1_w_5, r1_y_10));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_11 = r1_xyzw_9.y;
                float r1_z_9 = r1_xyzw_9.z;
                float r0_w_11 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_12 = (-r0_w_11 + 1);
                float r0_w_13 = (r0_w_12 * cb1_values[5].z);
                float r0_w_14 = max(r0_w_13, 0);
                float r0_w_15 = mad(r0_w_14, cb5_values[1].z, cb5_values[1].w);
                o.sv_Target0.xyz = (mad(r0_w_15.xxxx, (((mad(float4(r1_x_9, r1_y_11, r1_z_9, r1_x_9), r0_w_10.xxxx, ((r0_xyz_1.xyzx * float4(r2_x_28, r2_y_29, r2_z_28, r2_x_28))).xyzx)).xyzx + -cb5_values[0].xyzx)).xyzx, cb5_values[0].xyzx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Tint;
                float4 cb0_values[46];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[21];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[7];
            };
            SamplerState s0 : register(s0);
            Texture3D t0 : register(t0);
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
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program36Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program36Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program14Output vert(program14Input i)
            {
                program14Output o = (program14Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float3 r0_xyz_4 = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r0_w_4 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r0_w_5 = rsqrt(r0_w_4);
                float3 unitWorldNormal_xyz_3 = ((r0_w_5.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord0.xyz = (unitWorldNormal_xyz_3.xyzx).xyz;
                o.texcoord1.xyz = (r0_xyz_4.xyzx).xyz;
                o.color0.xyzw = i.color0.xyzw;
                float r0_w_6 = (unitWorldNormal_xyz_3.y * unitWorldNormal_xyz_3.y);
                float r0_w_7 = mad(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.x, -r0_w_6);
                float4 r2_xyzw_4 = (unitWorldNormal_xyz_3.yzzx * unitWorldNormal_xyz_3.xyzz);
                float r3_x_1 = dot(cb0_values[42].xyzw, r2_xyzw_4);
                float r3_y_1 = dot(cb0_values[43].xyzw, r2_xyzw_4);
                float r3_z_1 = dot(cb0_values[44].xyzw, r2_xyzw_4);
                float r1_w_2 = 1;
                float r3_x_2 = dot(cb0_values[39].xyzw, float4(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.y, unitWorldNormal_xyz_3.z, r1_w_2));
                float r3_y_2 = dot(cb0_values[40].xyzw, float4(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.y, unitWorldNormal_xyz_3.z, r1_w_2));
                float r3_z_2 = dot(cb0_values[41].xyzw, float4(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.y, unitWorldNormal_xyz_3.z, r1_w_2));
                float3 r2_xyz_9 = (((log2((max((((mad(cb0_values[45].xyzx, r0_w_7.xxxx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1))).xyzx + float4(r3_x_2, r3_y_2, r3_z_2, r3_x_2))).xyzx, float4(0, 0, 0, 0))).xyzx)).xyzx * float4(0.41666666, 0.41666666, 0.41666666, 0))).xyz;
                float4 r3_xyzw_3 = (-r0_xyz_4.yyyy + unity_WorldToObject[0]);
                float4 r3_xyzw_4 = (r3_xyzw_3 * r3_xyzw_3);
                float4 r5_xyzw_1 = (-r0_xyz_4.xxxx + unity_ObjectToWorld[3]);
                float4 r0_xyzw_5 = (-r0_xyz_4.zzzz + unity_WorldToObject[1]);
                float4 r1_xyzw_4 = mad(r0_xyzw_5, unitWorldNormal_xyz_3.zzzz, mad(r5_xyzw_1, unitWorldNormal_xyz_3.xxxx, (unitWorldNormal_xyz_3.yyyy * r3_xyzw_3)));
                float4 r3_xyzw_5 = mad(r5_xyzw_1, r5_xyzw_1, r3_xyzw_4);
                float4 r0_xyzw_6 = mad(r0_xyzw_5, r0_xyzw_5, r3_xyzw_5);
                float4 r0_xyzw_7 = max(r0_xyzw_6, float4(1E-06, 1E-06, 1E-06, 1E-06));
                float4 r3_xyzw_6 = rsqrt(r0_xyzw_7);
                float4 r0_xyzw_8 = mad(r0_xyzw_7, unity_WorldToObject[2], float4(1, 1, 1, 1));
                float4 r0_xyzw_9 = (float4(1, 1, 1, 1) / r0_xyzw_8);
                float4 r1_xyzw_5 = (r1_xyzw_4 * r3_xyzw_6);
                float4 r1_xyzw_6 = max(r1_xyzw_5, float4(0, 0, 0, 0));
                float4 r0_xyzw_10 = (r0_xyzw_9 * r1_xyzw_6);
                float3 r0_xyz_12 = (mad(cb0_values[10].xyzx, r0_xyzw_10.wwww, (mad(cb0_values[9].xyzx, r0_xyzw_10.zzzz, (mad(unity_WorldToObject[3].xyzx, r0_xyzw_10.xxxx, ((r0_xyzw_10.yyyy * cb0_values[8].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord2.xyz = (((max((mad((exp2(r2_xyz_9.xyzx)).xyzx, float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0))).xyzx, float4(0, 0, 0, 0))).xyzx + r0_xyz_12.xyzx)).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program36Output frag(program36Input i)
            {
                program36Output o = (program36Output)0;
                float3 r0_xyz_1 = ((i.color0.xyzx * _Tint.xyzx)).xyz;
                float r0_w_1 = (cb3_values[0].x == 1);
                float r1_x_10;
                float r1_y_11;
                float r1_z_10;
                float r1_w_4;
                if (r0_w_1)
                {
                    float r0_w_2 = (cb3_values[0].y == 1);
                    float3 r1_xyz_5 = (((mad(cb3_values[3].xyzx, i.texcoord1.zzzz, (mad(cb3_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb3_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb3_values[4].xyzx)).xyz;
                    float4 r1_xyzw_8 = (((((r0_w_2.xxxx ? r1_xyz_5.xyzx : i.texcoord1.xyzx)).xyzx + -cb3_values[6].xyzx)).xxyz * cb3_values[5].xxyz);
                    float r1_y_8 = r1_xyzw_8.y;
                    float r1_z_8 = r1_xyzw_8.z;
                    float r1_w_2 = r1_xyzw_8.w;
                    float r0_w_3 = mad(r1_y_8, 0.25, 0.75);
                    float r1_y_9 = mad(cb3_values[0].z, 0.5, 0.75);
                    float r1_x_8 = max(r0_w_3, r1_y_9);
                    float4 r1_xyzw_9 = t0.Sample(s0, float4(r1_x_8, r1_z_8, r1_w_2, r1_x_8));
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
                float r0_w_5 = dot(float4(r1_x_10, r1_y_11, r1_z_10, r1_w_4), unity_OcclusionMaskSelector);
                float4 r1_xyzw_11 = (r0_w_5.xxxx * _LightColor0.xyzx);
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_12 = r1_xyzw_11.y;
                float r1_z_11 = r1_xyzw_11.z;
                float r0_w_6 = dot(i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx);
                float r0_w_7 = max(r0_w_6, 0);
                float4 r1_xyzw_12 = (r0_xyz_1.xyzx * float4(r1_x_11, r1_y_12, r1_z_11, r1_x_11));
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_13 = r1_xyzw_12.y;
                float r1_z_12 = r1_xyzw_12.z;
                float TEXCOORD0_w_8 = i.texcoord3.x;
                o.sv_Target0.xyz = (mad(TEXCOORD0_w_8.xxxx, (((mad(float4(r1_x_12, r1_y_13, r1_z_12, r1_x_12), r0_w_7.xxxx, ((r0_xyz_1.xyzx * i.texcoord2.xyzx)).xyzx)).xyzx + -unity_ProbeVolumeParams.xyzx)).xyzx, unity_ProbeVolumeParams.xyzx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Tint;
                float4 cb0_values[46];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
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
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program34Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program34Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program14Output vert(program14Input i)
            {
                program14Output o = (program14Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float3 r0_xyz_4 = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r0_w_4 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r0_w_5 = rsqrt(r0_w_4);
                float3 unitWorldNormal_xyz_3 = ((r0_w_5.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord0.xyz = (unitWorldNormal_xyz_3.xyzx).xyz;
                o.texcoord1.xyz = (r0_xyz_4.xyzx).xyz;
                o.color0.xyzw = i.color0.xyzw;
                float r0_w_6 = (unitWorldNormal_xyz_3.y * unitWorldNormal_xyz_3.y);
                float r0_w_7 = mad(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.x, -r0_w_6);
                float4 r2_xyzw_4 = (unitWorldNormal_xyz_3.yzzx * unitWorldNormal_xyz_3.xyzz);
                float r3_x_1 = dot(cb0_values[42].xyzw, r2_xyzw_4);
                float r3_y_1 = dot(cb0_values[43].xyzw, r2_xyzw_4);
                float r3_z_1 = dot(cb0_values[44].xyzw, r2_xyzw_4);
                float r1_w_2 = 1;
                float r3_x_2 = dot(cb0_values[39].xyzw, float4(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.y, unitWorldNormal_xyz_3.z, r1_w_2));
                float r3_y_2 = dot(cb0_values[40].xyzw, float4(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.y, unitWorldNormal_xyz_3.z, r1_w_2));
                float r3_z_2 = dot(cb0_values[41].xyzw, float4(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.y, unitWorldNormal_xyz_3.z, r1_w_2));
                float3 r2_xyz_9 = (((log2((max((((mad(cb0_values[45].xyzx, r0_w_7.xxxx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1))).xyzx + float4(r3_x_2, r3_y_2, r3_z_2, r3_x_2))).xyzx, float4(0, 0, 0, 0))).xyzx)).xyzx * float4(0.41666666, 0.41666666, 0.41666666, 0))).xyz;
                float4 r3_xyzw_3 = (-r0_xyz_4.yyyy + unity_WorldToObject[0]);
                float4 r3_xyzw_4 = (r3_xyzw_3 * r3_xyzw_3);
                float4 r5_xyzw_1 = (-r0_xyz_4.xxxx + unity_ObjectToWorld[3]);
                float4 r0_xyzw_5 = (-r0_xyz_4.zzzz + unity_WorldToObject[1]);
                float4 r1_xyzw_4 = mad(r0_xyzw_5, unitWorldNormal_xyz_3.zzzz, mad(r5_xyzw_1, unitWorldNormal_xyz_3.xxxx, (unitWorldNormal_xyz_3.yyyy * r3_xyzw_3)));
                float4 r3_xyzw_5 = mad(r5_xyzw_1, r5_xyzw_1, r3_xyzw_4);
                float4 r0_xyzw_6 = mad(r0_xyzw_5, r0_xyzw_5, r3_xyzw_5);
                float4 r0_xyzw_7 = max(r0_xyzw_6, float4(1E-06, 1E-06, 1E-06, 1E-06));
                float4 r3_xyzw_6 = rsqrt(r0_xyzw_7);
                float4 r0_xyzw_8 = mad(r0_xyzw_7, unity_WorldToObject[2], float4(1, 1, 1, 1));
                float4 r0_xyzw_9 = (float4(1, 1, 1, 1) / r0_xyzw_8);
                float4 r1_xyzw_5 = (r1_xyzw_4 * r3_xyzw_6);
                float4 r1_xyzw_6 = max(r1_xyzw_5, float4(0, 0, 0, 0));
                float4 r0_xyzw_10 = (r0_xyzw_9 * r1_xyzw_6);
                float3 r0_xyz_12 = (mad(cb0_values[10].xyzx, r0_xyzw_10.wwww, (mad(cb0_values[9].xyzx, r0_xyzw_10.zzzz, (mad(unity_WorldToObject[3].xyzx, r0_xyzw_10.xxxx, ((r0_xyzw_10.yyyy * cb0_values[8].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord2.xyz = (((max((mad((exp2(r2_xyz_9.xyzx)).xyzx, float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0))).xyzx, float4(0, 0, 0, 0))).xyzx + r0_xyz_12.xyzx)).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program34Output frag(program34Input i)
            {
                program34Output o = (program34Output)0;
                float3 r0_xyz_1 = ((i.color0.xyzx * _Tint.xyzx)).xyz;
                float r2_x_1 = cb4_values[9].z;
                float r2_y_1 = cb4_values[10].z;
                float r2_z_1 = cb4_values[11].z;
                float r0_w_1 = dot(((-i.texcoord1.xyzx + cb1_values[4].xyzx)).xyzx, float4(r2_x_1, r2_y_1, r2_z_1, r2_x_1));
                float3 r1_xyz_2 = ((i.texcoord1.xyzx + -cb3_values[25].xyzx)).xyz;
                float r0_w_2 = mad(cb3_values[25].w, (-r0_w_1 + sqrt(dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx))), r0_w_1);
                float r0_w_3 = mad(r0_w_2, cb3_values[24].z, cb3_values[24].w);
                float r1_x_6 = (cb5_values[0].x == 1);
                float r2_x_9;
                float r2_y_9;
                float r2_z_9;
                float r2_w_4;
                if (r1_x_6)
                {
                    float r1_y_3 = (cb5_values[0].y == 1);
                    float3 r2_xyz_6 = (((mad(cb5_values[3].xyzx, i.texcoord1.zzzz, (mad(cb5_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r1_xyzw_4 = (r1_y_3.xxxx ? r2_xyz_6.xxyz : i.texcoord1.xxyz);
                    float r1_y_4 = r1_xyzw_4.y;
                    float r1_z_3 = r1_xyzw_4.z;
                    float r1_w_1 = r1_xyzw_4.w;
                    float4 r1_xyzw_5 = (float4(r1_y_4, r1_y_4, r1_z_3, r1_w_1) + -cb5_values[6].xxyz);
                    float r1_y_5 = r1_xyzw_5.y;
                    float r1_z_4 = r1_xyzw_5.z;
                    float r1_w_2 = r1_xyzw_5.w;
                    float4 r2_xyzw_7 = (float4(r1_y_5, r1_y_5, r1_z_4, r1_w_2) * cb5_values[5].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_2 = r2_xyzw_7.w;
                    float r1_y_6 = mad(r2_y_7, 0.25, 0.75);
                    float r1_z_5 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r2_x_7 = max(r1_z_5, r1_y_6);
                    float4 r2_xyzw_8 = t1.Sample(s0, float4(r2_x_7, r2_z_7, r2_w_2, r2_x_7));
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
                float r1_y_8 = dot(float4(r2_x_9, r2_y_9, r2_z_9, r2_w_4), cb2_values[46].xyzw);
                float4 r1_xyzw_7 = (i.texcoord4.xxxy / i.texcoord4.wwww);
                float r1_z_7 = r1_xyzw_7.z;
                float r1_w_4 = r1_xyzw_7.w;
                float4 r2_xyzw_10 = t0.Sample(s1, float4(r1_z_7, r1_w_4, r1_z_7, r1_z_7));
                float r1_y_9 = (r1_y_8 + -r2_xyzw_10.x);
                float r0_w_4 = mad(r0_w_3, r1_y_9, r2_xyzw_10.x);
                float4 r1_xyzw_10 = (r0_w_4.xxxx * _LightColor0.xxyz);
                float r1_y_10 = r1_xyzw_10.y;
                float r1_z_8 = r1_xyzw_10.z;
                float r1_w_5 = r1_xyzw_10.w;
                float3 r3_xyz_4;
                if ((r1_x_6 != 0))
                {
                    float r0_w_5 = (cb5_values[0].y == 1);
                    float3 r2_xyz_15 = (((mad(cb5_values[3].xyzx, i.texcoord1.zzzz, (mad(cb5_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r2_xyzw_18 = (((((r0_w_5.xxxx ? r2_xyz_15.xyzx : i.texcoord1.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r2_y_18 = r2_xyzw_18.y;
                    float r2_z_18 = r2_xyzw_18.z;
                    float r2_w_7 = r2_xyzw_18.w;
                    float r0_w_6 = (r2_y_18 * 0.25);
                    float r2_y_19 = mad(-cb5_values[0].z, 0.5, 0.25);
                    float r0_w_7 = max(r0_w_6, (cb5_values[0].z * 0.5));
                    float r2_x_18 = min(r2_y_19, r0_w_7);
                    float4 r3_xyzw_2 = t1.Sample(s0, float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18));
                    float4 r4_xyzw_2 = t1.Sample(s0, ((float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18) + float4(0.25, 0, 0, 0))).xyzx);
                    float4 r2_xyzw_19 = (float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18) + float4(0.5, 0, 0, 0));
                    float r2_x_19 = r2_xyzw_19.x;
                    float r2_y_20 = r2_xyzw_19.y;
                    float r2_z_19 = r2_xyzw_19.z;
                    float4 r2_xyzw_20 = t1.Sample(s0, float4(r2_x_19, r2_y_20, r2_z_19, r2_x_19));
                    float3 TEXCOORD0_xyz_1 = (i.texcoord0.xyzx).xyz;
                    float r5_w_1 = 1;
                    float r3_x_3 = dot(r3_xyzw_2, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    float r3_y_3 = dot(r4_xyzw_2, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    float r3_z_3 = dot(r2_xyzw_20, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    r3_xyz_4 = float3(r3_x_3, r3_y_3, r3_z_3);
                }
                else
                {
                    float3 TEXCOORD0_xyz_11 = (i.texcoord0.xyzx).xyz;
                    float r2_w_6 = 1;
                    float r3_x_1 = dot(cb2_values[39].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    float r3_y_1 = dot(cb2_values[40].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    float r3_z_1 = dot(cb2_values[41].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    r3_xyz_4 = float3(r3_x_1, r3_y_1, r3_z_1);
                }
                float4 r2_xyzw_22 = (r3_xyz_4.xyzx + i.texcoord2.xyzx);
                float r2_x_22 = r2_xyzw_22.x;
                float r2_y_23 = r2_xyzw_22.y;
                float r2_z_22 = r2_xyzw_22.z;
                float4 r2_xyzw_23 = max(float4(r2_x_22, r2_y_23, r2_z_22, r2_x_22), float4(0, 0, 0, 0));
                float r2_x_23 = r2_xyzw_23.x;
                float r2_y_24 = r2_xyzw_23.y;
                float r2_z_23 = r2_xyzw_23.z;
                float4 r2_xyzw_24 = log2(float4(r2_x_23, r2_y_24, r2_z_23, r2_x_23));
                float r2_x_24 = r2_xyzw_24.x;
                float r2_y_25 = r2_xyzw_24.y;
                float r2_z_24 = r2_xyzw_24.z;
                float4 r2_xyzw_25 = (float4(r2_x_24, r2_y_25, r2_z_24, r2_x_24) * float4(0.41666666, 0.41666666, 0.41666666, 0));
                float r2_x_25 = r2_xyzw_25.x;
                float r2_y_26 = r2_xyzw_25.y;
                float r2_z_25 = r2_xyzw_25.z;
                float4 r2_xyzw_26 = exp2(float4(r2_x_25, r2_y_26, r2_z_25, r2_x_25));
                float r2_x_26 = r2_xyzw_26.x;
                float r2_y_27 = r2_xyzw_26.y;
                float r2_z_26 = r2_xyzw_26.z;
                float4 r2_xyzw_27 = mad(float4(r2_x_26, r2_y_27, r2_z_26, r2_x_26), float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0));
                float r2_x_27 = r2_xyzw_27.x;
                float r2_y_28 = r2_xyzw_27.y;
                float r2_z_27 = r2_xyzw_27.z;
                float4 r2_xyzw_28 = max(float4(r2_x_27, r2_y_28, r2_z_27, r2_x_27), float4(0, 0, 0, 0));
                float r2_x_28 = r2_xyzw_28.x;
                float r2_y_29 = r2_xyzw_28.y;
                float r2_z_28 = r2_xyzw_28.z;
                float r0_w_9 = dot(i.texcoord0.xyzx, unity_ProbeVolumeParams.xyzx);
                float r0_w_10 = max(r0_w_9, 0);
                float4 r1_xyzw_9 = (r0_xyz_1.xyzx * float4(r1_y_10, r1_z_8, r1_w_5, r1_y_10));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_11 = r1_xyzw_9.y;
                float r1_z_9 = r1_xyzw_9.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_9, r1_y_11, r1_z_9, r1_x_9), r0_w_10.xxxx, ((r0_xyz_1.xyzx * float4(r2_x_28, r2_y_29, r2_z_28, r2_x_28))).xyzx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Tint;
                float4 cb0_values[46];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            Texture3D t0 : register(t0);
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
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program32Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program32Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program14Output vert(program14Input i)
            {
                program14Output o = (program14Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float3 r0_xyz_4 = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r0_w_4 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r0_w_5 = rsqrt(r0_w_4);
                float3 unitWorldNormal_xyz_3 = ((r0_w_5.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord0.xyz = (unitWorldNormal_xyz_3.xyzx).xyz;
                o.texcoord1.xyz = (r0_xyz_4.xyzx).xyz;
                o.color0.xyzw = i.color0.xyzw;
                float r0_w_6 = (unitWorldNormal_xyz_3.y * unitWorldNormal_xyz_3.y);
                float r0_w_7 = mad(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.x, -r0_w_6);
                float4 r2_xyzw_4 = (unitWorldNormal_xyz_3.yzzx * unitWorldNormal_xyz_3.xyzz);
                float r3_x_1 = dot(cb0_values[42].xyzw, r2_xyzw_4);
                float r3_y_1 = dot(cb0_values[43].xyzw, r2_xyzw_4);
                float r3_z_1 = dot(cb0_values[44].xyzw, r2_xyzw_4);
                float r1_w_2 = 1;
                float r3_x_2 = dot(cb0_values[39].xyzw, float4(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.y, unitWorldNormal_xyz_3.z, r1_w_2));
                float r3_y_2 = dot(cb0_values[40].xyzw, float4(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.y, unitWorldNormal_xyz_3.z, r1_w_2));
                float r3_z_2 = dot(cb0_values[41].xyzw, float4(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.y, unitWorldNormal_xyz_3.z, r1_w_2));
                float3 r2_xyz_9 = (((log2((max((((mad(cb0_values[45].xyzx, r0_w_7.xxxx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1))).xyzx + float4(r3_x_2, r3_y_2, r3_z_2, r3_x_2))).xyzx, float4(0, 0, 0, 0))).xyzx)).xyzx * float4(0.41666666, 0.41666666, 0.41666666, 0))).xyz;
                float4 r3_xyzw_3 = (-r0_xyz_4.yyyy + unity_WorldToObject[0]);
                float4 r3_xyzw_4 = (r3_xyzw_3 * r3_xyzw_3);
                float4 r5_xyzw_1 = (-r0_xyz_4.xxxx + unity_ObjectToWorld[3]);
                float4 r0_xyzw_5 = (-r0_xyz_4.zzzz + unity_WorldToObject[1]);
                float4 r1_xyzw_4 = mad(r0_xyzw_5, unitWorldNormal_xyz_3.zzzz, mad(r5_xyzw_1, unitWorldNormal_xyz_3.xxxx, (unitWorldNormal_xyz_3.yyyy * r3_xyzw_3)));
                float4 r3_xyzw_5 = mad(r5_xyzw_1, r5_xyzw_1, r3_xyzw_4);
                float4 r0_xyzw_6 = mad(r0_xyzw_5, r0_xyzw_5, r3_xyzw_5);
                float4 r0_xyzw_7 = max(r0_xyzw_6, float4(1E-06, 1E-06, 1E-06, 1E-06));
                float4 r3_xyzw_6 = rsqrt(r0_xyzw_7);
                float4 r0_xyzw_8 = mad(r0_xyzw_7, unity_WorldToObject[2], float4(1, 1, 1, 1));
                float4 r0_xyzw_9 = (float4(1, 1, 1, 1) / r0_xyzw_8);
                float4 r1_xyzw_5 = (r1_xyzw_4 * r3_xyzw_6);
                float4 r1_xyzw_6 = max(r1_xyzw_5, float4(0, 0, 0, 0));
                float4 r0_xyzw_10 = (r0_xyzw_9 * r1_xyzw_6);
                float3 r0_xyz_12 = (mad(cb0_values[10].xyzx, r0_xyzw_10.wwww, (mad(cb0_values[9].xyzx, r0_xyzw_10.zzzz, (mad(unity_WorldToObject[3].xyzx, r0_xyzw_10.xxxx, ((r0_xyzw_10.yyyy * cb0_values[8].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord2.xyz = (((max((mad((exp2(r2_xyz_9.xyzx)).xyzx, float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0))).xyzx, float4(0, 0, 0, 0))).xyzx + r0_xyz_12.xyzx)).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program32Output frag(program32Input i)
            {
                program32Output o = (program32Output)0;
                float3 r0_xyz_1 = ((i.color0.xyzx * _Tint.xyzx)).xyz;
                float r0_w_1 = (unity_ProbeVolumeParams.x == 1);
                float r1_x_10;
                float r1_y_11;
                float r1_z_10;
                float r1_w_4;
                if (r0_w_1)
                {
                    float r0_w_2 = (unity_ProbeVolumeParams.y == 1);
                    float3 r1_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_2.xxxx ? r1_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r1_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r1_y_8 = r1_xyzw_8.y;
                    float r1_z_8 = r1_xyzw_8.z;
                    float r1_w_2 = r1_xyzw_8.w;
                    float r0_w_3 = mad(r1_y_8, 0.25, 0.75);
                    float r1_y_9 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r1_x_8 = max(r0_w_3, r1_y_9);
                    float4 r1_xyzw_9 = t0.Sample(s0, float4(r1_x_8, r1_z_8, r1_w_2, r1_x_8));
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
                float r0_w_5 = dot(float4(r1_x_10, r1_y_11, r1_z_10, r1_w_4), unity_OcclusionMaskSelector);
                float4 r1_xyzw_11 = (r0_w_5.xxxx * _LightColor0.xyzx);
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_12 = r1_xyzw_11.y;
                float r1_z_11 = r1_xyzw_11.z;
                float r0_w_6 = dot(i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx);
                float r0_w_7 = max(r0_w_6, 0);
                float4 r1_xyzw_12 = (r0_xyz_1.xyzx * float4(r1_x_11, r1_y_12, r1_z_11, r1_x_11));
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_13 = r1_xyzw_12.y;
                float r1_z_12 = r1_xyzw_12.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_12, r1_y_13, r1_z_12, r1_x_12), r0_w_7.xxxx, ((r0_xyz_1.xyzx * i.texcoord2.xyzx)).xyzx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Tint;
                float4 cb0_values[6];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[46];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
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
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program38Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program38Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program12Output vert(program12Input i)
            {
                program12Output o = (program12Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                o.texcoord1.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = clipPos_xyzw_7;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                float3 unitWorldNormal_xyz_3 = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord0.xyz = (unitWorldNormal_xyz_3.xyzx).xyz;
                o.color0.xyzw = i.color0.xyzw;
                float r1_w_4 = (unitWorldNormal_xyz_3.y * unitWorldNormal_xyz_3.y);
                float r1_w_5 = mad(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.x, -r1_w_4);
                float4 r2_xyzw_1 = (unitWorldNormal_xyz_3.yzzx * unitWorldNormal_xyz_3.xyzz);
                float r1_x_4 = dot(cb1_values[42].xyzw, r2_xyzw_1);
                float r1_y_4 = dot(cb1_values[43].xyzw, r2_xyzw_1);
                float r1_z_4 = dot(cb1_values[44].xyzw, r2_xyzw_1);
                o.texcoord2.xyz = (mad(cb1_values[45].xyzx, r1_w_5.xxxx, float4(r1_x_4, r1_y_4, r1_z_4, r1_x_4))).xyz;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r1_xyzw_5 = (float4(clipPos_xyzw_7.x, clipPos_xyzw_7.x, clipPos_xyzw_7.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_5 = r1_xyzw_5.x;
                float r1_z_5 = r1_xyzw_5.z;
                float r1_w_6 = r1_xyzw_5.w;
                o.texcoord4.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord4.xy = ((r1_z_5.xxxx + float4(r1_x_5, r1_w_6, r1_x_5, r1_x_5))).xy;
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program38Output frag(program38Input i)
            {
                program38Output o = (program38Output)0;
                float3 r0_xyz_1 = ((i.color0.xyzx * _Tint.xyzx)).xyz;
                float r2_x_1 = cb4_values[9].z;
                float r2_y_1 = cb4_values[10].z;
                float r2_z_1 = cb4_values[11].z;
                float r0_w_1 = dot(((-i.texcoord1.xyzx + cb1_values[4].xyzx)).xyzx, float4(r2_x_1, r2_y_1, r2_z_1, r2_x_1));
                float3 r1_xyz_2 = ((i.texcoord1.xyzx + -cb3_values[25].xyzx)).xyz;
                float r0_w_2 = mad(cb3_values[25].w, (-r0_w_1 + sqrt(dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx))), r0_w_1);
                float r0_w_3 = mad(r0_w_2, cb3_values[24].z, cb3_values[24].w);
                float r1_x_6 = (cb6_values[0].x == 1);
                float r2_x_9;
                float r2_y_9;
                float r2_z_9;
                float r2_w_4;
                if (r1_x_6)
                {
                    float r1_y_3 = (cb6_values[0].y == 1);
                    float3 r2_xyz_6 = (((mad(cb6_values[3].xyzx, i.texcoord1.zzzz, (mad(cb6_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r1_xyzw_4 = (r1_y_3.xxxx ? r2_xyz_6.xxyz : i.texcoord1.xxyz);
                    float r1_y_4 = r1_xyzw_4.y;
                    float r1_z_3 = r1_xyzw_4.z;
                    float r1_w_1 = r1_xyzw_4.w;
                    float4 r1_xyzw_5 = (float4(r1_y_4, r1_y_4, r1_z_3, r1_w_1) + -cb6_values[6].xxyz);
                    float r1_y_5 = r1_xyzw_5.y;
                    float r1_z_4 = r1_xyzw_5.z;
                    float r1_w_2 = r1_xyzw_5.w;
                    float4 r2_xyzw_7 = (float4(r1_y_5, r1_y_5, r1_z_4, r1_w_2) * cb6_values[5].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_2 = r2_xyzw_7.w;
                    float r1_y_6 = mad(r2_y_7, 0.25, 0.75);
                    float r1_z_5 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r2_x_7 = max(r1_z_5, r1_y_6);
                    float4 r2_xyzw_8 = t1.Sample(s0, float4(r2_x_7, r2_z_7, r2_w_2, r2_x_7));
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
                float r1_y_8 = dot(float4(r2_x_9, r2_y_9, r2_z_9, r2_w_4), cb2_values[46].xyzw);
                float4 r1_xyzw_7 = (i.texcoord4.xxxy / i.texcoord4.wwww);
                float r1_z_7 = r1_xyzw_7.z;
                float r1_w_4 = r1_xyzw_7.w;
                float4 r2_xyzw_10 = t0.Sample(s1, float4(r1_z_7, r1_w_4, r1_z_7, r1_z_7));
                float r1_y_9 = (r1_y_8 + -r2_xyzw_10.x);
                float r0_w_4 = mad(r0_w_3, r1_y_9, r2_xyzw_10.x);
                float4 r1_xyzw_10 = (r0_w_4.xxxx * _LightColor0.xxyz);
                float r1_y_10 = r1_xyzw_10.y;
                float r1_z_8 = r1_xyzw_10.z;
                float r1_w_5 = r1_xyzw_10.w;
                float3 r3_xyz_4;
                if ((r1_x_6 != 0))
                {
                    float r0_w_5 = (cb6_values[0].y == 1);
                    float3 r2_xyz_15 = (((mad(cb6_values[3].xyzx, i.texcoord1.zzzz, (mad(cb6_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r2_xyzw_18 = (((((r0_w_5.xxxx ? r2_xyz_15.xyzx : i.texcoord1.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r2_y_18 = r2_xyzw_18.y;
                    float r2_z_18 = r2_xyzw_18.z;
                    float r2_w_7 = r2_xyzw_18.w;
                    float r0_w_6 = (r2_y_18 * 0.25);
                    float r2_y_19 = mad(-cb6_values[0].z, 0.5, 0.25);
                    float r0_w_7 = max(r0_w_6, (cb6_values[0].z * 0.5));
                    float r2_x_18 = min(r2_y_19, r0_w_7);
                    float4 r3_xyzw_2 = t1.Sample(s0, float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18));
                    float4 r4_xyzw_2 = t1.Sample(s0, ((float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18) + float4(0.25, 0, 0, 0))).xyzx);
                    float4 r2_xyzw_19 = (float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18) + float4(0.5, 0, 0, 0));
                    float r2_x_19 = r2_xyzw_19.x;
                    float r2_y_20 = r2_xyzw_19.y;
                    float r2_z_19 = r2_xyzw_19.z;
                    float4 r2_xyzw_20 = t1.Sample(s0, float4(r2_x_19, r2_y_20, r2_z_19, r2_x_19));
                    float3 TEXCOORD0_xyz_1 = (i.texcoord0.xyzx).xyz;
                    float r5_w_1 = 1;
                    float r3_x_3 = dot(r3_xyzw_2, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    float r3_y_3 = dot(r4_xyzw_2, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    float r3_z_3 = dot(r2_xyzw_20, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    r3_xyz_4 = float3(r3_x_3, r3_y_3, r3_z_3);
                }
                else
                {
                    float3 TEXCOORD0_xyz_11 = (i.texcoord0.xyzx).xyz;
                    float r2_w_6 = 1;
                    float r3_x_1 = dot(cb2_values[39].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    float r3_y_1 = dot(cb2_values[40].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    float r3_z_1 = dot(cb2_values[41].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    r3_xyz_4 = float3(r3_x_1, r3_y_1, r3_z_1);
                }
                float4 r2_xyzw_22 = (r3_xyz_4.xyzx + i.texcoord2.xyzx);
                float r2_x_22 = r2_xyzw_22.x;
                float r2_y_23 = r2_xyzw_22.y;
                float r2_z_22 = r2_xyzw_22.z;
                float4 r2_xyzw_23 = max(float4(r2_x_22, r2_y_23, r2_z_22, r2_x_22), float4(0, 0, 0, 0));
                float r2_x_23 = r2_xyzw_23.x;
                float r2_y_24 = r2_xyzw_23.y;
                float r2_z_23 = r2_xyzw_23.z;
                float4 r2_xyzw_24 = log2(float4(r2_x_23, r2_y_24, r2_z_23, r2_x_23));
                float r2_x_24 = r2_xyzw_24.x;
                float r2_y_25 = r2_xyzw_24.y;
                float r2_z_24 = r2_xyzw_24.z;
                float4 r2_xyzw_25 = (float4(r2_x_24, r2_y_25, r2_z_24, r2_x_24) * float4(0.41666666, 0.41666666, 0.41666666, 0));
                float r2_x_25 = r2_xyzw_25.x;
                float r2_y_26 = r2_xyzw_25.y;
                float r2_z_25 = r2_xyzw_25.z;
                float4 r2_xyzw_26 = exp2(float4(r2_x_25, r2_y_26, r2_z_25, r2_x_25));
                float r2_x_26 = r2_xyzw_26.x;
                float r2_y_27 = r2_xyzw_26.y;
                float r2_z_26 = r2_xyzw_26.z;
                float4 r2_xyzw_27 = mad(float4(r2_x_26, r2_y_27, r2_z_26, r2_x_26), float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0));
                float r2_x_27 = r2_xyzw_27.x;
                float r2_y_28 = r2_xyzw_27.y;
                float r2_z_27 = r2_xyzw_27.z;
                float4 r2_xyzw_28 = max(float4(r2_x_27, r2_y_28, r2_z_27, r2_x_27), float4(0, 0, 0, 0));
                float r2_x_28 = r2_xyzw_28.x;
                float r2_y_29 = r2_xyzw_28.y;
                float r2_z_28 = r2_xyzw_28.z;
                float r0_w_9 = dot(i.texcoord0.xyzx, unity_ProbeVolumeParams.xyzx);
                float r0_w_10 = max(r0_w_9, 0);
                float4 r1_xyzw_9 = (r0_xyz_1.xyzx * float4(r1_y_10, r1_z_8, r1_w_5, r1_y_10));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_11 = r1_xyzw_9.y;
                float r1_z_9 = r1_xyzw_9.z;
                float r0_w_11 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_12 = (-r0_w_11 + 1);
                float r0_w_13 = (r0_w_12 * cb1_values[5].z);
                float r0_w_14 = max(r0_w_13, 0);
                float r0_w_15 = mad(r0_w_14, cb5_values[1].z, cb5_values[1].w);
                o.sv_Target0.xyz = (mad(r0_w_15.xxxx, (((mad(float4(r1_x_9, r1_y_11, r1_z_9, r1_x_9), r0_w_10.xxxx, ((r0_xyz_1.xyzx * float4(r2_x_28, r2_y_29, r2_z_28, r2_x_28))).xyzx)).xyzx + -cb5_values[0].xyzx)).xyzx, cb5_values[0].xyzx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Tint;
                float4 cb0_values[6];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[46];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
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
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program34Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program34Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program12Output vert(program12Input i)
            {
                program12Output o = (program12Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                o.texcoord1.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = clipPos_xyzw_7;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                float3 unitWorldNormal_xyz_3 = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord0.xyz = (unitWorldNormal_xyz_3.xyzx).xyz;
                o.color0.xyzw = i.color0.xyzw;
                float r1_w_4 = (unitWorldNormal_xyz_3.y * unitWorldNormal_xyz_3.y);
                float r1_w_5 = mad(unitWorldNormal_xyz_3.x, unitWorldNormal_xyz_3.x, -r1_w_4);
                float4 r2_xyzw_1 = (unitWorldNormal_xyz_3.yzzx * unitWorldNormal_xyz_3.xyzz);
                float r1_x_4 = dot(cb1_values[42].xyzw, r2_xyzw_1);
                float r1_y_4 = dot(cb1_values[43].xyzw, r2_xyzw_1);
                float r1_z_4 = dot(cb1_values[44].xyzw, r2_xyzw_1);
                o.texcoord2.xyz = (mad(cb1_values[45].xyzx, r1_w_5.xxxx, float4(r1_x_4, r1_y_4, r1_z_4, r1_x_4))).xyz;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r1_xyzw_5 = (float4(clipPos_xyzw_7.x, clipPos_xyzw_7.x, clipPos_xyzw_7.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_5 = r1_xyzw_5.x;
                float r1_z_5 = r1_xyzw_5.z;
                float r1_w_6 = r1_xyzw_5.w;
                o.texcoord4.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord4.xy = ((r1_z_5.xxxx + float4(r1_x_5, r1_w_6, r1_x_5, r1_x_5))).xy;
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program34Output frag(program34Input i)
            {
                program34Output o = (program34Output)0;
                float3 r0_xyz_1 = ((i.color0.xyzx * _Tint.xyzx)).xyz;
                float r2_x_1 = cb4_values[9].z;
                float r2_y_1 = cb4_values[10].z;
                float r2_z_1 = cb4_values[11].z;
                float r0_w_1 = dot(((-i.texcoord1.xyzx + cb1_values[4].xyzx)).xyzx, float4(r2_x_1, r2_y_1, r2_z_1, r2_x_1));
                float3 r1_xyz_2 = ((i.texcoord1.xyzx + -cb3_values[25].xyzx)).xyz;
                float r0_w_2 = mad(cb3_values[25].w, (-r0_w_1 + sqrt(dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx))), r0_w_1);
                float r0_w_3 = mad(r0_w_2, cb3_values[24].z, cb3_values[24].w);
                float r1_x_6 = (cb5_values[0].x == 1);
                float r2_x_9;
                float r2_y_9;
                float r2_z_9;
                float r2_w_4;
                if (r1_x_6)
                {
                    float r1_y_3 = (cb5_values[0].y == 1);
                    float3 r2_xyz_6 = (((mad(cb5_values[3].xyzx, i.texcoord1.zzzz, (mad(cb5_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r1_xyzw_4 = (r1_y_3.xxxx ? r2_xyz_6.xxyz : i.texcoord1.xxyz);
                    float r1_y_4 = r1_xyzw_4.y;
                    float r1_z_3 = r1_xyzw_4.z;
                    float r1_w_1 = r1_xyzw_4.w;
                    float4 r1_xyzw_5 = (float4(r1_y_4, r1_y_4, r1_z_3, r1_w_1) + -cb5_values[6].xxyz);
                    float r1_y_5 = r1_xyzw_5.y;
                    float r1_z_4 = r1_xyzw_5.z;
                    float r1_w_2 = r1_xyzw_5.w;
                    float4 r2_xyzw_7 = (float4(r1_y_5, r1_y_5, r1_z_4, r1_w_2) * cb5_values[5].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_2 = r2_xyzw_7.w;
                    float r1_y_6 = mad(r2_y_7, 0.25, 0.75);
                    float r1_z_5 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r2_x_7 = max(r1_z_5, r1_y_6);
                    float4 r2_xyzw_8 = t1.Sample(s0, float4(r2_x_7, r2_z_7, r2_w_2, r2_x_7));
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
                float r1_y_8 = dot(float4(r2_x_9, r2_y_9, r2_z_9, r2_w_4), cb2_values[46].xyzw);
                float4 r1_xyzw_7 = (i.texcoord4.xxxy / i.texcoord4.wwww);
                float r1_z_7 = r1_xyzw_7.z;
                float r1_w_4 = r1_xyzw_7.w;
                float4 r2_xyzw_10 = t0.Sample(s1, float4(r1_z_7, r1_w_4, r1_z_7, r1_z_7));
                float r1_y_9 = (r1_y_8 + -r2_xyzw_10.x);
                float r0_w_4 = mad(r0_w_3, r1_y_9, r2_xyzw_10.x);
                float4 r1_xyzw_10 = (r0_w_4.xxxx * _LightColor0.xxyz);
                float r1_y_10 = r1_xyzw_10.y;
                float r1_z_8 = r1_xyzw_10.z;
                float r1_w_5 = r1_xyzw_10.w;
                float3 r3_xyz_4;
                if ((r1_x_6 != 0))
                {
                    float r0_w_5 = (cb5_values[0].y == 1);
                    float3 r2_xyz_15 = (((mad(cb5_values[3].xyzx, i.texcoord1.zzzz, (mad(cb5_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r2_xyzw_18 = (((((r0_w_5.xxxx ? r2_xyz_15.xyzx : i.texcoord1.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r2_y_18 = r2_xyzw_18.y;
                    float r2_z_18 = r2_xyzw_18.z;
                    float r2_w_7 = r2_xyzw_18.w;
                    float r0_w_6 = (r2_y_18 * 0.25);
                    float r2_y_19 = mad(-cb5_values[0].z, 0.5, 0.25);
                    float r0_w_7 = max(r0_w_6, (cb5_values[0].z * 0.5));
                    float r2_x_18 = min(r2_y_19, r0_w_7);
                    float4 r3_xyzw_2 = t1.Sample(s0, float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18));
                    float4 r4_xyzw_2 = t1.Sample(s0, ((float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18) + float4(0.25, 0, 0, 0))).xyzx);
                    float4 r2_xyzw_19 = (float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18) + float4(0.5, 0, 0, 0));
                    float r2_x_19 = r2_xyzw_19.x;
                    float r2_y_20 = r2_xyzw_19.y;
                    float r2_z_19 = r2_xyzw_19.z;
                    float4 r2_xyzw_20 = t1.Sample(s0, float4(r2_x_19, r2_y_20, r2_z_19, r2_x_19));
                    float3 TEXCOORD0_xyz_1 = (i.texcoord0.xyzx).xyz;
                    float r5_w_1 = 1;
                    float r3_x_3 = dot(r3_xyzw_2, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    float r3_y_3 = dot(r4_xyzw_2, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    float r3_z_3 = dot(r2_xyzw_20, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    r3_xyz_4 = float3(r3_x_3, r3_y_3, r3_z_3);
                }
                else
                {
                    float3 TEXCOORD0_xyz_11 = (i.texcoord0.xyzx).xyz;
                    float r2_w_6 = 1;
                    float r3_x_1 = dot(cb2_values[39].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    float r3_y_1 = dot(cb2_values[40].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    float r3_z_1 = dot(cb2_values[41].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    r3_xyz_4 = float3(r3_x_1, r3_y_1, r3_z_1);
                }
                float4 r2_xyzw_22 = (r3_xyz_4.xyzx + i.texcoord2.xyzx);
                float r2_x_22 = r2_xyzw_22.x;
                float r2_y_23 = r2_xyzw_22.y;
                float r2_z_22 = r2_xyzw_22.z;
                float4 r2_xyzw_23 = max(float4(r2_x_22, r2_y_23, r2_z_22, r2_x_22), float4(0, 0, 0, 0));
                float r2_x_23 = r2_xyzw_23.x;
                float r2_y_24 = r2_xyzw_23.y;
                float r2_z_23 = r2_xyzw_23.z;
                float4 r2_xyzw_24 = log2(float4(r2_x_23, r2_y_24, r2_z_23, r2_x_23));
                float r2_x_24 = r2_xyzw_24.x;
                float r2_y_25 = r2_xyzw_24.y;
                float r2_z_24 = r2_xyzw_24.z;
                float4 r2_xyzw_25 = (float4(r2_x_24, r2_y_25, r2_z_24, r2_x_24) * float4(0.41666666, 0.41666666, 0.41666666, 0));
                float r2_x_25 = r2_xyzw_25.x;
                float r2_y_26 = r2_xyzw_25.y;
                float r2_z_25 = r2_xyzw_25.z;
                float4 r2_xyzw_26 = exp2(float4(r2_x_25, r2_y_26, r2_z_25, r2_x_25));
                float r2_x_26 = r2_xyzw_26.x;
                float r2_y_27 = r2_xyzw_26.y;
                float r2_z_26 = r2_xyzw_26.z;
                float4 r2_xyzw_27 = mad(float4(r2_x_26, r2_y_27, r2_z_26, r2_x_26), float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0));
                float r2_x_27 = r2_xyzw_27.x;
                float r2_y_28 = r2_xyzw_27.y;
                float r2_z_27 = r2_xyzw_27.z;
                float4 r2_xyzw_28 = max(float4(r2_x_27, r2_y_28, r2_z_27, r2_x_27), float4(0, 0, 0, 0));
                float r2_x_28 = r2_xyzw_28.x;
                float r2_y_29 = r2_xyzw_28.y;
                float r2_z_28 = r2_xyzw_28.z;
                float r0_w_9 = dot(i.texcoord0.xyzx, unity_ProbeVolumeParams.xyzx);
                float r0_w_10 = max(r0_w_9, 0);
                float4 r1_xyzw_9 = (r0_xyz_1.xyzx * float4(r1_y_10, r1_z_8, r1_w_5, r1_y_10));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_11 = r1_xyzw_9.y;
                float r1_z_9 = r1_xyzw_9.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_9, r1_y_11, r1_z_9, r1_x_9), r0_w_10.xxxx, ((r0_xyz_1.xyzx * float4(r2_x_28, r2_y_29, r2_z_28, r2_x_28))).xyzx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Tint;
                float4 cb0_values[6];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program37Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program37Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program11Output vert(program11Input i)
            {
                program11Output o = (program11Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = clipPos_xyzw_7;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.color0.xyzw = i.color0.xyzw;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r1_xyzw_3 = (float4(clipPos_xyzw_7.x, clipPos_xyzw_7.x, clipPos_xyzw_7.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_z_3 = r1_xyzw_3.z;
                float r1_w_4 = r1_xyzw_3.w;
                o.texcoord4.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord4.xy = ((r1_z_3.xxxx + float4(r1_x_3, r1_w_4, r1_x_3, r1_x_3))).xy;
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program37Output frag(program37Input i)
            {
                program37Output o = (program37Output)0;
                float r2_x_1 = cb4_values[9].z;
                float r2_y_1 = cb4_values[10].z;
                float r2_z_1 = cb4_values[11].z;
                float r0_w_1 = dot(((-i.texcoord1.xyzx + cb1_values[4].xyzx)).xyzx, float4(r2_x_1, r2_y_1, r2_z_1, r2_x_1));
                float3 r1_xyz_2 = ((i.texcoord1.xyzx + -cb3_values[25].xyzx)).xyz;
                float r0_w_2 = mad(cb3_values[25].w, (-r0_w_1 + sqrt(dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx))), r0_w_1);
                float r0_w_3 = mad(r0_w_2, cb3_values[24].z, cb3_values[24].w);
                float r1_x_13;
                float r1_y_13;
                float r1_z_12;
                float r1_w_8;
                if ((cb6_values[0].x == 1))
                {
                    float4 r1_xyzw_4 = (i.texcoord1.yyyy * cb6_values[2].xxyz);
                    float r1_y_4 = r1_xyzw_4.y;
                    float r1_z_4 = r1_xyzw_4.z;
                    float r1_w_2 = r1_xyzw_4.w;
                    float4 r1_xyzw_5 = mad(cb6_values[1].xxyz, i.texcoord1.xxxx, float4(r1_y_4, r1_y_4, r1_z_4, r1_w_2));
                    float r1_y_5 = r1_xyzw_5.y;
                    float r1_z_5 = r1_xyzw_5.z;
                    float r1_w_3 = r1_xyzw_5.w;
                    float4 r1_xyzw_6 = mad(cb6_values[3].xxyz, i.texcoord1.zzzz, float4(r1_y_5, r1_y_5, r1_z_5, r1_w_3));
                    float r1_y_6 = r1_xyzw_6.y;
                    float r1_z_6 = r1_xyzw_6.z;
                    float r1_w_4 = r1_xyzw_6.w;
                    float4 r1_xyzw_7 = (float4(r1_y_6, r1_y_6, r1_z_6, r1_w_4) + cb6_values[4].xxyz);
                    float r1_y_7 = r1_xyzw_7.y;
                    float r1_z_7 = r1_xyzw_7.z;
                    float r1_w_5 = r1_xyzw_7.w;
                    float4 r1_xyzw_9 = (((cb6_values[0].y == 1)).xxxx ? float4(r1_y_7, r1_z_7, r1_w_5, r1_y_7) : i.texcoord1.xyzx);
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
                    float4 r1_xyzw_12 = t1.Sample(s0, float4(r1_x_11, r1_z_10, r1_w_6, r1_x_11));
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
                float4 r1_xyzw_14 = (i.texcoord4.xxyx / i.texcoord4.wwww);
                float r1_y_14 = r1_xyzw_14.y;
                float r1_z_13 = r1_xyzw_14.z;
                float4 r2_xyzw_4 = t0.Sample(s1, float4(r1_y_14, r1_z_13, r1_y_14, r1_y_14));
                float r0_w_4 = mad(r0_w_3, (dot(float4(r1_x_13, r1_y_13, r1_z_12, r1_w_8), cb2_values[46].xyzw) + -r2_xyzw_4.x), r2_xyzw_4.x);
                float4 r1_xyzw_16 = (r0_w_4.xxxx * _LightColor0.xyzx);
                float r1_x_16 = r1_xyzw_16.x;
                float r1_y_15 = r1_xyzw_16.y;
                float r1_z_14 = r1_xyzw_16.z;
                float r0_w_5 = dot(i.texcoord0.xyzx, unity_ProbeVolumeParams.xyzx);
                float r0_w_6 = max(r0_w_5, 0);
                float3 r0_xyz_3 = (mad(((((i.color0.xyzx * _Tint.xyzx)).xyzx * float4(r1_x_16, r1_y_15, r1_z_14, r1_x_16))).xyzx, r0_w_6.xxxx, -cb5_values[0].xyzx)).xyz;
                o.sv_Target0.xyz = (mad((mad(max((((i.texcoord3.x / cb1_values[5].y) + 1) * cb1_values[5].z), 0), cb5_values[1].z, cb5_values[1].w)).xxxx, r0_xyz_3.xyzx, cb5_values[0].xyzx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Tint;
                float4 cb0_values[6];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program33Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program33Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program11Output vert(program11Input i)
            {
                program11Output o = (program11Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = clipPos_xyzw_7;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.color0.xyzw = i.color0.xyzw;
                float r0_y_8 = (clipPos_xyzw_7.y * unity_WorldToObject[1].x);
                float4 r1_xyzw_3 = (float4(clipPos_xyzw_7.x, clipPos_xyzw_7.x, clipPos_xyzw_7.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_z_3 = r1_xyzw_3.z;
                float r1_w_4 = r1_xyzw_3.w;
                o.texcoord4.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord4.xy = ((r1_z_3.xxxx + float4(r1_x_3, r1_w_4, r1_x_3, r1_x_3))).xy;
                o.texcoord5.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program33Output frag(program33Input i)
            {
                program33Output o = (program33Output)0;
                float r2_x_1 = cb4_values[9].z;
                float r2_y_1 = cb4_values[10].z;
                float r2_z_1 = cb4_values[11].z;
                float r0_w_1 = dot(((-i.texcoord1.xyzx + cb1_values[4].xyzx)).xyzx, float4(r2_x_1, r2_y_1, r2_z_1, r2_x_1));
                float3 r1_xyz_2 = ((i.texcoord1.xyzx + -cb3_values[25].xyzx)).xyz;
                float r0_w_2 = mad(cb3_values[25].w, (-r0_w_1 + sqrt(dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx))), r0_w_1);
                float r0_w_3 = mad(r0_w_2, cb3_values[24].z, cb3_values[24].w);
                float r1_x_13;
                float r1_y_13;
                float r1_z_12;
                float r1_w_8;
                if ((cb5_values[0].x == 1))
                {
                    float4 r1_xyzw_4 = (i.texcoord1.yyyy * cb5_values[2].xxyz);
                    float r1_y_4 = r1_xyzw_4.y;
                    float r1_z_4 = r1_xyzw_4.z;
                    float r1_w_2 = r1_xyzw_4.w;
                    float4 r1_xyzw_5 = mad(cb5_values[1].xxyz, i.texcoord1.xxxx, float4(r1_y_4, r1_y_4, r1_z_4, r1_w_2));
                    float r1_y_5 = r1_xyzw_5.y;
                    float r1_z_5 = r1_xyzw_5.z;
                    float r1_w_3 = r1_xyzw_5.w;
                    float4 r1_xyzw_6 = mad(cb5_values[3].xxyz, i.texcoord1.zzzz, float4(r1_y_5, r1_y_5, r1_z_5, r1_w_3));
                    float r1_y_6 = r1_xyzw_6.y;
                    float r1_z_6 = r1_xyzw_6.z;
                    float r1_w_4 = r1_xyzw_6.w;
                    float4 r1_xyzw_7 = (float4(r1_y_6, r1_y_6, r1_z_6, r1_w_4) + cb5_values[4].xxyz);
                    float r1_y_7 = r1_xyzw_7.y;
                    float r1_z_7 = r1_xyzw_7.z;
                    float r1_w_5 = r1_xyzw_7.w;
                    float4 r1_xyzw_9 = (((cb5_values[0].y == 1)).xxxx ? float4(r1_y_7, r1_z_7, r1_w_5, r1_y_7) : i.texcoord1.xyzx);
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
                    float4 r1_xyzw_12 = t1.Sample(s0, float4(r1_x_11, r1_z_10, r1_w_6, r1_x_11));
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
                float4 r1_xyzw_14 = (i.texcoord4.xxyx / i.texcoord4.wwww);
                float r1_y_14 = r1_xyzw_14.y;
                float r1_z_13 = r1_xyzw_14.z;
                float4 r2_xyzw_4 = t0.Sample(s1, float4(r1_y_14, r1_z_13, r1_y_14, r1_y_14));
                float r0_w_4 = mad(r0_w_3, (dot(float4(r1_x_13, r1_y_13, r1_z_12, r1_w_8), cb2_values[46].xyzw) + -r2_xyzw_4.x), r2_xyzw_4.x);
                float4 r1_xyzw_16 = (r0_w_4.xxxx * _LightColor0.xyzx);
                float r1_x_16 = r1_xyzw_16.x;
                float r1_y_15 = r1_xyzw_16.y;
                float r1_z_14 = r1_xyzw_16.z;
                float r0_w_5 = dot(i.texcoord0.xyzx, unity_ProbeVolumeParams.xyzx);
                float r0_w_6 = max(r0_w_5, 0);
                o.sv_Target0.xyz = ((r0_w_6.xxxx * ((((i.color0.xyzx * _Tint.xyzx)).xyzx * float4(r1_x_16, r1_y_15, r1_z_14, r1_x_16))).xyzx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Tint;
                float4 cb0_values[46];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program38Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program38Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program10Output vert(program10Input i)
            {
                program10Output o = (program10Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                float3 unitWorldNormal_xyz_8 = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.texcoord0.xyz = (unitWorldNormal_xyz_8.xyzx).xyz;
                o.color0.xyzw = i.color0.xyzw;
                float4 r2_xyzw_1 = (unitWorldNormal_xyz_8.yzzx * unitWorldNormal_xyz_8.xyzz);
                float r3_x_1 = dot(cb0_values[42].xyzw, r2_xyzw_1);
                float r3_y_1 = dot(cb0_values[43].xyzw, r2_xyzw_1);
                float r3_z_1 = dot(cb0_values[44].xyzw, r2_xyzw_1);
                float4 r1_xyzw_4 = mad(cb0_values[45].xyzx, (mad(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.x, (unitWorldNormal_xyz_8.y * unitWorldNormal_xyz_8.y))).xxxx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_2 = r1_xyzw_4.y;
                float r1_z_2 = r1_xyzw_4.z;
                float r0_w_9 = 1;
                float r2_x_2 = dot(cb0_values[39].xyzw, float4(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.y, unitWorldNormal_xyz_8.z, r0_w_9));
                float r2_y_2 = dot(cb0_values[40].xyzw, float4(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.y, unitWorldNormal_xyz_8.z, r0_w_9));
                float r2_z_2 = dot(cb0_values[41].xyzw, float4(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.y, unitWorldNormal_xyz_8.z, r0_w_9));
                float3 r0_xyz_13 = (exp2((((log2((max(((float4(r1_x_4, r1_y_2, r1_z_2, r1_x_4) + float4(r2_x_2, r2_y_2, r2_z_2, r2_x_2))).xyzx, float4(0, 0, 0, 0))).xyzx)).xyzx * float4(0.41666666, 0.41666666, 0.41666666, 0))).xyzx)).xyz;
                o.texcoord2.xyz = (max((mad(r0_xyz_13.xyzx, float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0))).xyzx, float4(0, 0, 0, 0))).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program38Output frag(program38Input i)
            {
                program38Output o = (program38Output)0;
                float3 r0_xyz_1 = ((i.color0.xyzx * _Tint.xyzx)).xyz;
                float r2_x_1 = cb4_values[9].z;
                float r2_y_1 = cb4_values[10].z;
                float r2_z_1 = cb4_values[11].z;
                float r0_w_1 = dot(((-i.texcoord1.xyzx + cb1_values[4].xyzx)).xyzx, float4(r2_x_1, r2_y_1, r2_z_1, r2_x_1));
                float3 r1_xyz_2 = ((i.texcoord1.xyzx + -cb3_values[25].xyzx)).xyz;
                float r0_w_2 = mad(cb3_values[25].w, (-r0_w_1 + sqrt(dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx))), r0_w_1);
                float r0_w_3 = mad(r0_w_2, cb3_values[24].z, cb3_values[24].w);
                float r1_x_6 = (cb6_values[0].x == 1);
                float r2_x_9;
                float r2_y_9;
                float r2_z_9;
                float r2_w_4;
                if (r1_x_6)
                {
                    float r1_y_3 = (cb6_values[0].y == 1);
                    float3 r2_xyz_6 = (((mad(cb6_values[3].xyzx, i.texcoord1.zzzz, (mad(cb6_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r1_xyzw_4 = (r1_y_3.xxxx ? r2_xyz_6.xxyz : i.texcoord1.xxyz);
                    float r1_y_4 = r1_xyzw_4.y;
                    float r1_z_3 = r1_xyzw_4.z;
                    float r1_w_1 = r1_xyzw_4.w;
                    float4 r1_xyzw_5 = (float4(r1_y_4, r1_y_4, r1_z_3, r1_w_1) + -cb6_values[6].xxyz);
                    float r1_y_5 = r1_xyzw_5.y;
                    float r1_z_4 = r1_xyzw_5.z;
                    float r1_w_2 = r1_xyzw_5.w;
                    float4 r2_xyzw_7 = (float4(r1_y_5, r1_y_5, r1_z_4, r1_w_2) * cb6_values[5].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_2 = r2_xyzw_7.w;
                    float r1_y_6 = mad(r2_y_7, 0.25, 0.75);
                    float r1_z_5 = mad(cb6_values[0].z, 0.5, 0.75);
                    float r2_x_7 = max(r1_z_5, r1_y_6);
                    float4 r2_xyzw_8 = t1.Sample(s0, float4(r2_x_7, r2_z_7, r2_w_2, r2_x_7));
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
                float r1_y_8 = dot(float4(r2_x_9, r2_y_9, r2_z_9, r2_w_4), cb2_values[46].xyzw);
                float4 r1_xyzw_7 = (i.texcoord4.xxxy / i.texcoord4.wwww);
                float r1_z_7 = r1_xyzw_7.z;
                float r1_w_4 = r1_xyzw_7.w;
                float4 r2_xyzw_10 = t0.Sample(s1, float4(r1_z_7, r1_w_4, r1_z_7, r1_z_7));
                float r1_y_9 = (r1_y_8 + -r2_xyzw_10.x);
                float r0_w_4 = mad(r0_w_3, r1_y_9, r2_xyzw_10.x);
                float4 r1_xyzw_10 = (r0_w_4.xxxx * _LightColor0.xxyz);
                float r1_y_10 = r1_xyzw_10.y;
                float r1_z_8 = r1_xyzw_10.z;
                float r1_w_5 = r1_xyzw_10.w;
                float3 r3_xyz_4;
                if ((r1_x_6 != 0))
                {
                    float r0_w_5 = (cb6_values[0].y == 1);
                    float3 r2_xyz_15 = (((mad(cb6_values[3].xyzx, i.texcoord1.zzzz, (mad(cb6_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb6_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb6_values[4].xyzx)).xyz;
                    float4 r2_xyzw_18 = (((((r0_w_5.xxxx ? r2_xyz_15.xyzx : i.texcoord1.xyzx)).xyzx + -cb6_values[6].xyzx)).xxyz * cb6_values[5].xxyz);
                    float r2_y_18 = r2_xyzw_18.y;
                    float r2_z_18 = r2_xyzw_18.z;
                    float r2_w_7 = r2_xyzw_18.w;
                    float r0_w_6 = (r2_y_18 * 0.25);
                    float r2_y_19 = mad(-cb6_values[0].z, 0.5, 0.25);
                    float r0_w_7 = max(r0_w_6, (cb6_values[0].z * 0.5));
                    float r2_x_18 = min(r2_y_19, r0_w_7);
                    float4 r3_xyzw_2 = t1.Sample(s0, float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18));
                    float4 r4_xyzw_2 = t1.Sample(s0, ((float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18) + float4(0.25, 0, 0, 0))).xyzx);
                    float4 r2_xyzw_19 = (float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18) + float4(0.5, 0, 0, 0));
                    float r2_x_19 = r2_xyzw_19.x;
                    float r2_y_20 = r2_xyzw_19.y;
                    float r2_z_19 = r2_xyzw_19.z;
                    float4 r2_xyzw_20 = t1.Sample(s0, float4(r2_x_19, r2_y_20, r2_z_19, r2_x_19));
                    float3 TEXCOORD0_xyz_1 = (i.texcoord0.xyzx).xyz;
                    float r5_w_1 = 1;
                    float r3_x_3 = dot(r3_xyzw_2, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    float r3_y_3 = dot(r4_xyzw_2, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    float r3_z_3 = dot(r2_xyzw_20, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    r3_xyz_4 = float3(r3_x_3, r3_y_3, r3_z_3);
                }
                else
                {
                    float3 TEXCOORD0_xyz_11 = (i.texcoord0.xyzx).xyz;
                    float r2_w_6 = 1;
                    float r3_x_1 = dot(cb2_values[39].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    float r3_y_1 = dot(cb2_values[40].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    float r3_z_1 = dot(cb2_values[41].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    r3_xyz_4 = float3(r3_x_1, r3_y_1, r3_z_1);
                }
                float4 r2_xyzw_22 = (r3_xyz_4.xyzx + i.texcoord2.xyzx);
                float r2_x_22 = r2_xyzw_22.x;
                float r2_y_23 = r2_xyzw_22.y;
                float r2_z_22 = r2_xyzw_22.z;
                float4 r2_xyzw_23 = max(float4(r2_x_22, r2_y_23, r2_z_22, r2_x_22), float4(0, 0, 0, 0));
                float r2_x_23 = r2_xyzw_23.x;
                float r2_y_24 = r2_xyzw_23.y;
                float r2_z_23 = r2_xyzw_23.z;
                float4 r2_xyzw_24 = log2(float4(r2_x_23, r2_y_24, r2_z_23, r2_x_23));
                float r2_x_24 = r2_xyzw_24.x;
                float r2_y_25 = r2_xyzw_24.y;
                float r2_z_24 = r2_xyzw_24.z;
                float4 r2_xyzw_25 = (float4(r2_x_24, r2_y_25, r2_z_24, r2_x_24) * float4(0.41666666, 0.41666666, 0.41666666, 0));
                float r2_x_25 = r2_xyzw_25.x;
                float r2_y_26 = r2_xyzw_25.y;
                float r2_z_25 = r2_xyzw_25.z;
                float4 r2_xyzw_26 = exp2(float4(r2_x_25, r2_y_26, r2_z_25, r2_x_25));
                float r2_x_26 = r2_xyzw_26.x;
                float r2_y_27 = r2_xyzw_26.y;
                float r2_z_26 = r2_xyzw_26.z;
                float4 r2_xyzw_27 = mad(float4(r2_x_26, r2_y_27, r2_z_26, r2_x_26), float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0));
                float r2_x_27 = r2_xyzw_27.x;
                float r2_y_28 = r2_xyzw_27.y;
                float r2_z_27 = r2_xyzw_27.z;
                float4 r2_xyzw_28 = max(float4(r2_x_27, r2_y_28, r2_z_27, r2_x_27), float4(0, 0, 0, 0));
                float r2_x_28 = r2_xyzw_28.x;
                float r2_y_29 = r2_xyzw_28.y;
                float r2_z_28 = r2_xyzw_28.z;
                float r0_w_9 = dot(i.texcoord0.xyzx, unity_ProbeVolumeParams.xyzx);
                float r0_w_10 = max(r0_w_9, 0);
                float4 r1_xyzw_9 = (r0_xyz_1.xyzx * float4(r1_y_10, r1_z_8, r1_w_5, r1_y_10));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_11 = r1_xyzw_9.y;
                float r1_z_9 = r1_xyzw_9.z;
                float r0_w_11 = (i.texcoord3.x / cb1_values[5].y);
                float r0_w_12 = (-r0_w_11 + 1);
                float r0_w_13 = (r0_w_12 * cb1_values[5].z);
                float r0_w_14 = max(r0_w_13, 0);
                float r0_w_15 = mad(r0_w_14, cb5_values[1].z, cb5_values[1].w);
                o.sv_Target0.xyz = (mad(r0_w_15.xxxx, (((mad(float4(r1_x_9, r1_y_11, r1_z_9, r1_x_9), r0_w_10.xxxx, ((r0_xyz_1.xyzx * float4(r2_x_28, r2_y_29, r2_z_28, r2_x_28))).xyzx)).xyzx + -cb5_values[0].xyzx)).xyzx, cb5_values[0].xyzx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Tint;
                float4 cb0_values[46];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[21];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[7];
            };
            SamplerState s0 : register(s0);
            Texture3D t0 : register(t0);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program36Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program36Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program10Output vert(program10Input i)
            {
                program10Output o = (program10Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                float3 unitWorldNormal_xyz_8 = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.texcoord0.xyz = (unitWorldNormal_xyz_8.xyzx).xyz;
                o.color0.xyzw = i.color0.xyzw;
                float4 r2_xyzw_1 = (unitWorldNormal_xyz_8.yzzx * unitWorldNormal_xyz_8.xyzz);
                float r3_x_1 = dot(cb0_values[42].xyzw, r2_xyzw_1);
                float r3_y_1 = dot(cb0_values[43].xyzw, r2_xyzw_1);
                float r3_z_1 = dot(cb0_values[44].xyzw, r2_xyzw_1);
                float4 r1_xyzw_4 = mad(cb0_values[45].xyzx, (mad(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.x, (unitWorldNormal_xyz_8.y * unitWorldNormal_xyz_8.y))).xxxx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_2 = r1_xyzw_4.y;
                float r1_z_2 = r1_xyzw_4.z;
                float r0_w_9 = 1;
                float r2_x_2 = dot(cb0_values[39].xyzw, float4(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.y, unitWorldNormal_xyz_8.z, r0_w_9));
                float r2_y_2 = dot(cb0_values[40].xyzw, float4(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.y, unitWorldNormal_xyz_8.z, r0_w_9));
                float r2_z_2 = dot(cb0_values[41].xyzw, float4(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.y, unitWorldNormal_xyz_8.z, r0_w_9));
                float3 r0_xyz_13 = (exp2((((log2((max(((float4(r1_x_4, r1_y_2, r1_z_2, r1_x_4) + float4(r2_x_2, r2_y_2, r2_z_2, r2_x_2))).xyzx, float4(0, 0, 0, 0))).xyzx)).xyzx * float4(0.41666666, 0.41666666, 0.41666666, 0))).xyzx)).xyz;
                o.texcoord2.xyz = (max((mad(r0_xyz_13.xyzx, float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0))).xyzx, float4(0, 0, 0, 0))).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program36Output frag(program36Input i)
            {
                program36Output o = (program36Output)0;
                float3 r0_xyz_1 = ((i.color0.xyzx * _Tint.xyzx)).xyz;
                float r0_w_1 = (cb3_values[0].x == 1);
                float r1_x_10;
                float r1_y_11;
                float r1_z_10;
                float r1_w_4;
                if (r0_w_1)
                {
                    float r0_w_2 = (cb3_values[0].y == 1);
                    float3 r1_xyz_5 = (((mad(cb3_values[3].xyzx, i.texcoord1.zzzz, (mad(cb3_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb3_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb3_values[4].xyzx)).xyz;
                    float4 r1_xyzw_8 = (((((r0_w_2.xxxx ? r1_xyz_5.xyzx : i.texcoord1.xyzx)).xyzx + -cb3_values[6].xyzx)).xxyz * cb3_values[5].xxyz);
                    float r1_y_8 = r1_xyzw_8.y;
                    float r1_z_8 = r1_xyzw_8.z;
                    float r1_w_2 = r1_xyzw_8.w;
                    float r0_w_3 = mad(r1_y_8, 0.25, 0.75);
                    float r1_y_9 = mad(cb3_values[0].z, 0.5, 0.75);
                    float r1_x_8 = max(r0_w_3, r1_y_9);
                    float4 r1_xyzw_9 = t0.Sample(s0, float4(r1_x_8, r1_z_8, r1_w_2, r1_x_8));
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
                float r0_w_5 = dot(float4(r1_x_10, r1_y_11, r1_z_10, r1_w_4), unity_OcclusionMaskSelector);
                float4 r1_xyzw_11 = (r0_w_5.xxxx * _LightColor0.xyzx);
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_12 = r1_xyzw_11.y;
                float r1_z_11 = r1_xyzw_11.z;
                float r0_w_6 = dot(i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx);
                float r0_w_7 = max(r0_w_6, 0);
                float4 r1_xyzw_12 = (r0_xyz_1.xyzx * float4(r1_x_11, r1_y_12, r1_z_11, r1_x_11));
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_13 = r1_xyzw_12.y;
                float r1_z_12 = r1_xyzw_12.z;
                float TEXCOORD0_w_8 = i.texcoord3.x;
                o.sv_Target0.xyz = (mad(TEXCOORD0_w_8.xxxx, (((mad(float4(r1_x_12, r1_y_13, r1_z_12, r1_x_12), r0_w_7.xxxx, ((r0_xyz_1.xyzx * i.texcoord2.xyzx)).xyzx)).xyzx + -unity_ProbeVolumeParams.xyzx)).xyzx, unity_ProbeVolumeParams.xyzx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Tint;
                float4 cb0_values[46];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program34Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program34Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program10Output vert(program10Input i)
            {
                program10Output o = (program10Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                float3 unitWorldNormal_xyz_8 = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.texcoord0.xyz = (unitWorldNormal_xyz_8.xyzx).xyz;
                o.color0.xyzw = i.color0.xyzw;
                float4 r2_xyzw_1 = (unitWorldNormal_xyz_8.yzzx * unitWorldNormal_xyz_8.xyzz);
                float r3_x_1 = dot(cb0_values[42].xyzw, r2_xyzw_1);
                float r3_y_1 = dot(cb0_values[43].xyzw, r2_xyzw_1);
                float r3_z_1 = dot(cb0_values[44].xyzw, r2_xyzw_1);
                float4 r1_xyzw_4 = mad(cb0_values[45].xyzx, (mad(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.x, (unitWorldNormal_xyz_8.y * unitWorldNormal_xyz_8.y))).xxxx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_2 = r1_xyzw_4.y;
                float r1_z_2 = r1_xyzw_4.z;
                float r0_w_9 = 1;
                float r2_x_2 = dot(cb0_values[39].xyzw, float4(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.y, unitWorldNormal_xyz_8.z, r0_w_9));
                float r2_y_2 = dot(cb0_values[40].xyzw, float4(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.y, unitWorldNormal_xyz_8.z, r0_w_9));
                float r2_z_2 = dot(cb0_values[41].xyzw, float4(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.y, unitWorldNormal_xyz_8.z, r0_w_9));
                float3 r0_xyz_13 = (exp2((((log2((max(((float4(r1_x_4, r1_y_2, r1_z_2, r1_x_4) + float4(r2_x_2, r2_y_2, r2_z_2, r2_x_2))).xyzx, float4(0, 0, 0, 0))).xyzx)).xyzx * float4(0.41666666, 0.41666666, 0.41666666, 0))).xyzx)).xyz;
                o.texcoord2.xyz = (max((mad(r0_xyz_13.xyzx, float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0))).xyzx, float4(0, 0, 0, 0))).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program34Output frag(program34Input i)
            {
                program34Output o = (program34Output)0;
                float3 r0_xyz_1 = ((i.color0.xyzx * _Tint.xyzx)).xyz;
                float r2_x_1 = cb4_values[9].z;
                float r2_y_1 = cb4_values[10].z;
                float r2_z_1 = cb4_values[11].z;
                float r0_w_1 = dot(((-i.texcoord1.xyzx + cb1_values[4].xyzx)).xyzx, float4(r2_x_1, r2_y_1, r2_z_1, r2_x_1));
                float3 r1_xyz_2 = ((i.texcoord1.xyzx + -cb3_values[25].xyzx)).xyz;
                float r0_w_2 = mad(cb3_values[25].w, (-r0_w_1 + sqrt(dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx))), r0_w_1);
                float r0_w_3 = mad(r0_w_2, cb3_values[24].z, cb3_values[24].w);
                float r1_x_6 = (cb5_values[0].x == 1);
                float r2_x_9;
                float r2_y_9;
                float r2_z_9;
                float r2_w_4;
                if (r1_x_6)
                {
                    float r1_y_3 = (cb5_values[0].y == 1);
                    float3 r2_xyz_6 = (((mad(cb5_values[3].xyzx, i.texcoord1.zzzz, (mad(cb5_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r1_xyzw_4 = (r1_y_3.xxxx ? r2_xyz_6.xxyz : i.texcoord1.xxyz);
                    float r1_y_4 = r1_xyzw_4.y;
                    float r1_z_3 = r1_xyzw_4.z;
                    float r1_w_1 = r1_xyzw_4.w;
                    float4 r1_xyzw_5 = (float4(r1_y_4, r1_y_4, r1_z_3, r1_w_1) + -cb5_values[6].xxyz);
                    float r1_y_5 = r1_xyzw_5.y;
                    float r1_z_4 = r1_xyzw_5.z;
                    float r1_w_2 = r1_xyzw_5.w;
                    float4 r2_xyzw_7 = (float4(r1_y_5, r1_y_5, r1_z_4, r1_w_2) * cb5_values[5].xxyz);
                    float r2_y_7 = r2_xyzw_7.y;
                    float r2_z_7 = r2_xyzw_7.z;
                    float r2_w_2 = r2_xyzw_7.w;
                    float r1_y_6 = mad(r2_y_7, 0.25, 0.75);
                    float r1_z_5 = mad(cb5_values[0].z, 0.5, 0.75);
                    float r2_x_7 = max(r1_z_5, r1_y_6);
                    float4 r2_xyzw_8 = t1.Sample(s0, float4(r2_x_7, r2_z_7, r2_w_2, r2_x_7));
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
                float r1_y_8 = dot(float4(r2_x_9, r2_y_9, r2_z_9, r2_w_4), cb2_values[46].xyzw);
                float4 r1_xyzw_7 = (i.texcoord4.xxxy / i.texcoord4.wwww);
                float r1_z_7 = r1_xyzw_7.z;
                float r1_w_4 = r1_xyzw_7.w;
                float4 r2_xyzw_10 = t0.Sample(s1, float4(r1_z_7, r1_w_4, r1_z_7, r1_z_7));
                float r1_y_9 = (r1_y_8 + -r2_xyzw_10.x);
                float r0_w_4 = mad(r0_w_3, r1_y_9, r2_xyzw_10.x);
                float4 r1_xyzw_10 = (r0_w_4.xxxx * _LightColor0.xxyz);
                float r1_y_10 = r1_xyzw_10.y;
                float r1_z_8 = r1_xyzw_10.z;
                float r1_w_5 = r1_xyzw_10.w;
                float3 r3_xyz_4;
                if ((r1_x_6 != 0))
                {
                    float r0_w_5 = (cb5_values[0].y == 1);
                    float3 r2_xyz_15 = (((mad(cb5_values[3].xyzx, i.texcoord1.zzzz, (mad(cb5_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb5_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb5_values[4].xyzx)).xyz;
                    float4 r2_xyzw_18 = (((((r0_w_5.xxxx ? r2_xyz_15.xyzx : i.texcoord1.xyzx)).xyzx + -cb5_values[6].xyzx)).xxyz * cb5_values[5].xxyz);
                    float r2_y_18 = r2_xyzw_18.y;
                    float r2_z_18 = r2_xyzw_18.z;
                    float r2_w_7 = r2_xyzw_18.w;
                    float r0_w_6 = (r2_y_18 * 0.25);
                    float r2_y_19 = mad(-cb5_values[0].z, 0.5, 0.25);
                    float r0_w_7 = max(r0_w_6, (cb5_values[0].z * 0.5));
                    float r2_x_18 = min(r2_y_19, r0_w_7);
                    float4 r3_xyzw_2 = t1.Sample(s0, float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18));
                    float4 r4_xyzw_2 = t1.Sample(s0, ((float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18) + float4(0.25, 0, 0, 0))).xyzx);
                    float4 r2_xyzw_19 = (float4(r2_x_18, r2_z_18, r2_w_7, r2_x_18) + float4(0.5, 0, 0, 0));
                    float r2_x_19 = r2_xyzw_19.x;
                    float r2_y_20 = r2_xyzw_19.y;
                    float r2_z_19 = r2_xyzw_19.z;
                    float4 r2_xyzw_20 = t1.Sample(s0, float4(r2_x_19, r2_y_20, r2_z_19, r2_x_19));
                    float3 TEXCOORD0_xyz_1 = (i.texcoord0.xyzx).xyz;
                    float r5_w_1 = 1;
                    float r3_x_3 = dot(r3_xyzw_2, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    float r3_y_3 = dot(r4_xyzw_2, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    float r3_z_3 = dot(r2_xyzw_20, float4(TEXCOORD0_xyz_1.x, TEXCOORD0_xyz_1.y, TEXCOORD0_xyz_1.z, r5_w_1));
                    r3_xyz_4 = float3(r3_x_3, r3_y_3, r3_z_3);
                }
                else
                {
                    float3 TEXCOORD0_xyz_11 = (i.texcoord0.xyzx).xyz;
                    float r2_w_6 = 1;
                    float r3_x_1 = dot(cb2_values[39].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    float r3_y_1 = dot(cb2_values[40].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    float r3_z_1 = dot(cb2_values[41].xyzw, float4(TEXCOORD0_xyz_11.x, TEXCOORD0_xyz_11.y, TEXCOORD0_xyz_11.z, r2_w_6));
                    r3_xyz_4 = float3(r3_x_1, r3_y_1, r3_z_1);
                }
                float4 r2_xyzw_22 = (r3_xyz_4.xyzx + i.texcoord2.xyzx);
                float r2_x_22 = r2_xyzw_22.x;
                float r2_y_23 = r2_xyzw_22.y;
                float r2_z_22 = r2_xyzw_22.z;
                float4 r2_xyzw_23 = max(float4(r2_x_22, r2_y_23, r2_z_22, r2_x_22), float4(0, 0, 0, 0));
                float r2_x_23 = r2_xyzw_23.x;
                float r2_y_24 = r2_xyzw_23.y;
                float r2_z_23 = r2_xyzw_23.z;
                float4 r2_xyzw_24 = log2(float4(r2_x_23, r2_y_24, r2_z_23, r2_x_23));
                float r2_x_24 = r2_xyzw_24.x;
                float r2_y_25 = r2_xyzw_24.y;
                float r2_z_24 = r2_xyzw_24.z;
                float4 r2_xyzw_25 = (float4(r2_x_24, r2_y_25, r2_z_24, r2_x_24) * float4(0.41666666, 0.41666666, 0.41666666, 0));
                float r2_x_25 = r2_xyzw_25.x;
                float r2_y_26 = r2_xyzw_25.y;
                float r2_z_25 = r2_xyzw_25.z;
                float4 r2_xyzw_26 = exp2(float4(r2_x_25, r2_y_26, r2_z_25, r2_x_25));
                float r2_x_26 = r2_xyzw_26.x;
                float r2_y_27 = r2_xyzw_26.y;
                float r2_z_26 = r2_xyzw_26.z;
                float4 r2_xyzw_27 = mad(float4(r2_x_26, r2_y_27, r2_z_26, r2_x_26), float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0));
                float r2_x_27 = r2_xyzw_27.x;
                float r2_y_28 = r2_xyzw_27.y;
                float r2_z_27 = r2_xyzw_27.z;
                float4 r2_xyzw_28 = max(float4(r2_x_27, r2_y_28, r2_z_27, r2_x_27), float4(0, 0, 0, 0));
                float r2_x_28 = r2_xyzw_28.x;
                float r2_y_29 = r2_xyzw_28.y;
                float r2_z_28 = r2_xyzw_28.z;
                float r0_w_9 = dot(i.texcoord0.xyzx, unity_ProbeVolumeParams.xyzx);
                float r0_w_10 = max(r0_w_9, 0);
                float4 r1_xyzw_9 = (r0_xyz_1.xyzx * float4(r1_y_10, r1_z_8, r1_w_5, r1_y_10));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_11 = r1_xyzw_9.y;
                float r1_z_9 = r1_xyzw_9.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_9, r1_y_11, r1_z_9, r1_x_9), r0_w_10.xxxx, ((r0_xyz_1.xyzx * float4(r2_x_28, r2_y_29, r2_z_28, r2_x_28))).xyzx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Tint;
                float4 cb0_values[46];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            Texture3D t0 : register(t0);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program32Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program32Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program10Output vert(program10Input i)
            {
                program10Output o = (program10Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                float3 unitWorldNormal_xyz_8 = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.texcoord0.xyz = (unitWorldNormal_xyz_8.xyzx).xyz;
                o.color0.xyzw = i.color0.xyzw;
                float4 r2_xyzw_1 = (unitWorldNormal_xyz_8.yzzx * unitWorldNormal_xyz_8.xyzz);
                float r3_x_1 = dot(cb0_values[42].xyzw, r2_xyzw_1);
                float r3_y_1 = dot(cb0_values[43].xyzw, r2_xyzw_1);
                float r3_z_1 = dot(cb0_values[44].xyzw, r2_xyzw_1);
                float4 r1_xyzw_4 = mad(cb0_values[45].xyzx, (mad(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.x, (unitWorldNormal_xyz_8.y * unitWorldNormal_xyz_8.y))).xxxx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_2 = r1_xyzw_4.y;
                float r1_z_2 = r1_xyzw_4.z;
                float r0_w_9 = 1;
                float r2_x_2 = dot(cb0_values[39].xyzw, float4(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.y, unitWorldNormal_xyz_8.z, r0_w_9));
                float r2_y_2 = dot(cb0_values[40].xyzw, float4(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.y, unitWorldNormal_xyz_8.z, r0_w_9));
                float r2_z_2 = dot(cb0_values[41].xyzw, float4(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.y, unitWorldNormal_xyz_8.z, r0_w_9));
                float3 r0_xyz_13 = (exp2((((log2((max(((float4(r1_x_4, r1_y_2, r1_z_2, r1_x_4) + float4(r2_x_2, r2_y_2, r2_z_2, r2_x_2))).xyzx, float4(0, 0, 0, 0))).xyzx)).xyzx * float4(0.41666666, 0.41666666, 0.41666666, 0))).xyzx)).xyz;
                o.texcoord2.xyz = (max((mad(r0_xyz_13.xyzx, float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0))).xyzx, float4(0, 0, 0, 0))).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program32Output frag(program32Input i)
            {
                program32Output o = (program32Output)0;
                float3 r0_xyz_1 = ((i.color0.xyzx * _Tint.xyzx)).xyz;
                float r0_w_1 = (unity_ProbeVolumeParams.x == 1);
                float r1_x_10;
                float r1_y_11;
                float r1_z_10;
                float r1_w_4;
                if (r0_w_1)
                {
                    float r0_w_2 = (unity_ProbeVolumeParams.y == 1);
                    float3 r1_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_2.xxxx ? r1_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r1_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r1_y_8 = r1_xyzw_8.y;
                    float r1_z_8 = r1_xyzw_8.z;
                    float r1_w_2 = r1_xyzw_8.w;
                    float r0_w_3 = mad(r1_y_8, 0.25, 0.75);
                    float r1_y_9 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r1_x_8 = max(r0_w_3, r1_y_9);
                    float4 r1_xyzw_9 = t0.Sample(s0, float4(r1_x_8, r1_z_8, r1_w_2, r1_x_8));
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
                float r0_w_5 = dot(float4(r1_x_10, r1_y_11, r1_z_10, r1_w_4), unity_OcclusionMaskSelector);
                float4 r1_xyzw_11 = (r0_w_5.xxxx * _LightColor0.xyzx);
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_12 = r1_xyzw_11.y;
                float r1_z_11 = r1_xyzw_11.z;
                float r0_w_6 = dot(i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx);
                float r0_w_7 = max(r0_w_6, 0);
                float4 r1_xyzw_12 = (r0_xyz_1.xyzx * float4(r1_x_11, r1_y_12, r1_z_11, r1_x_11));
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_13 = r1_xyzw_12.y;
                float r1_z_12 = r1_xyzw_12.z;
                o.sv_Target0.xyz = (mad(float4(r1_x_12, r1_y_13, r1_z_12, r1_x_12), r0_w_7.xxxx, ((r0_xyz_1.xyzx * i.texcoord2.xyzx)).xyzx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Tint;
                float4 cb0_values[7];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[21];
            };
            cbuffer UnityProbeVolume : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program37Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program37Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program9Output vert(program9Input i)
            {
                program9Output o = (program9Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord1.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord0.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program37Output frag(program37Input i)
            {
                program37Output o = (program37Output)0;
                float r2_x_1 = cb4_values[9].z;
                float r2_y_1 = cb4_values[10].z;
                float r2_z_1 = cb4_values[11].z;
                float r0_w_1 = dot(((-i.texcoord1.xyzx + cb1_values[4].xyzx)).xyzx, float4(r2_x_1, r2_y_1, r2_z_1, r2_x_1));
                float3 r1_xyz_2 = ((i.texcoord1.xyzx + -cb3_values[25].xyzx)).xyz;
                float r0_w_2 = mad(cb3_values[25].w, (-r0_w_1 + sqrt(dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx))), r0_w_1);
                float r0_w_3 = mad(r0_w_2, cb3_values[24].z, cb3_values[24].w);
                float r1_x_13;
                float r1_y_13;
                float r1_z_12;
                float r1_w_8;
                if ((cb6_values[0].x == 1))
                {
                    float4 r1_xyzw_4 = (i.texcoord1.yyyy * cb6_values[2].xxyz);
                    float r1_y_4 = r1_xyzw_4.y;
                    float r1_z_4 = r1_xyzw_4.z;
                    float r1_w_2 = r1_xyzw_4.w;
                    float4 r1_xyzw_5 = mad(cb6_values[1].xxyz, i.texcoord1.xxxx, float4(r1_y_4, r1_y_4, r1_z_4, r1_w_2));
                    float r1_y_5 = r1_xyzw_5.y;
                    float r1_z_5 = r1_xyzw_5.z;
                    float r1_w_3 = r1_xyzw_5.w;
                    float4 r1_xyzw_6 = mad(cb6_values[3].xxyz, i.texcoord1.zzzz, float4(r1_y_5, r1_y_5, r1_z_5, r1_w_3));
                    float r1_y_6 = r1_xyzw_6.y;
                    float r1_z_6 = r1_xyzw_6.z;
                    float r1_w_4 = r1_xyzw_6.w;
                    float4 r1_xyzw_7 = (float4(r1_y_6, r1_y_6, r1_z_6, r1_w_4) + cb6_values[4].xxyz);
                    float r1_y_7 = r1_xyzw_7.y;
                    float r1_z_7 = r1_xyzw_7.z;
                    float r1_w_5 = r1_xyzw_7.w;
                    float4 r1_xyzw_9 = (((cb6_values[0].y == 1)).xxxx ? float4(r1_y_7, r1_z_7, r1_w_5, r1_y_7) : i.texcoord1.xyzx);
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
                    float4 r1_xyzw_12 = t1.Sample(s0, float4(r1_x_11, r1_z_10, r1_w_6, r1_x_11));
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
                float4 r1_xyzw_14 = (i.texcoord4.xxyx / i.texcoord4.wwww);
                float r1_y_14 = r1_xyzw_14.y;
                float r1_z_13 = r1_xyzw_14.z;
                float4 r2_xyzw_4 = t0.Sample(s1, float4(r1_y_14, r1_z_13, r1_y_14, r1_y_14));
                float r0_w_4 = mad(r0_w_3, (dot(float4(r1_x_13, r1_y_13, r1_z_12, r1_w_8), cb2_values[46].xyzw) + -r2_xyzw_4.x), r2_xyzw_4.x);
                float4 r1_xyzw_16 = (r0_w_4.xxxx * _LightColor0.xyzx);
                float r1_x_16 = r1_xyzw_16.x;
                float r1_y_15 = r1_xyzw_16.y;
                float r1_z_14 = r1_xyzw_16.z;
                float r0_w_5 = dot(i.texcoord0.xyzx, unity_ProbeVolumeParams.xyzx);
                float r0_w_6 = max(r0_w_5, 0);
                float3 r0_xyz_3 = (mad(((((i.color0.xyzx * _Tint.xyzx)).xyzx * float4(r1_x_16, r1_y_15, r1_z_14, r1_x_16))).xyzx, r0_w_6.xxxx, -cb5_values[0].xyzx)).xyz;
                o.sv_Target0.xyz = (mad((mad(max((((i.texcoord3.x / cb1_values[5].y) + 1) * cb1_values[5].z), 0), cb5_values[1].z, cb5_values[1].w)).xxxx, r0_xyz_3.xyzx, cb5_values[0].xyzx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Tint;
                float4 cb0_values[7];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityProbeVolume : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[1];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[7];
            };
            SamplerState s0 : register(s0);
            Texture3D t0 : register(t0);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program35Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program35Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program9Output vert(program9Input i)
            {
                program9Output o = (program9Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord1.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord0.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program35Output frag(program35Input i)
            {
                program35Output o = (program35Output)0;
                float r0_w_1 = (cb3_values[0].x == 1);
                float r1_x_10;
                float r1_y_11;
                float r1_z_10;
                float r1_w_4;
                if (r0_w_1)
                {
                    float r0_w_2 = (cb3_values[0].y == 1);
                    float3 r1_xyz_5 = (((mad(cb3_values[3].xyzx, i.texcoord1.zzzz, (mad(cb3_values[1].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb3_values[2].xyzx)).xyzx)).xyzx)).xyzx + cb3_values[4].xyzx)).xyz;
                    float4 r1_xyzw_8 = (((((r0_w_2.xxxx ? r1_xyz_5.xyzx : i.texcoord1.xyzx)).xyzx + -cb3_values[6].xyzx)).xxyz * cb3_values[5].xxyz);
                    float r1_y_8 = r1_xyzw_8.y;
                    float r1_z_8 = r1_xyzw_8.z;
                    float r1_w_2 = r1_xyzw_8.w;
                    float r0_w_3 = mad(r1_y_8, 0.25, 0.75);
                    float r1_y_9 = mad(cb3_values[0].z, 0.5, 0.75);
                    float r1_x_8 = max(r0_w_3, r1_y_9);
                    float4 r1_xyzw_9 = t0.Sample(s0, float4(r1_x_8, r1_z_8, r1_w_2, r1_x_8));
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
                float r0_w_5 = dot(float4(r1_x_10, r1_y_11, r1_z_10, r1_w_4), unity_OcclusionMaskSelector);
                float4 r1_xyzw_11 = (r0_w_5.xxxx * _LightColor0.xyzx);
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_12 = r1_xyzw_11.y;
                float r1_z_11 = r1_xyzw_11.z;
                float r0_w_6 = dot(i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx);
                float r0_w_7 = max(r0_w_6, 0);
                float TEXCOORD0_x_12 = i.texcoord3.x;
                o.sv_Target0.xyz = (mad(TEXCOORD0_x_12.xxxx, (mad(((((i.color0.xyzx * _Tint.xyzx)).xyzx * float4(r1_x_11, r1_y_12, r1_z_11, r1_x_11))).xyzx, r0_w_7.xxxx, -unity_ProbeVolumeParams.xyzx)).xyzx, unity_ProbeVolumeParams.xyzx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 _Tint;
                float4 cb0_values[7];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[21];
            };
            cbuffer UnityProbeVolume : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program33Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program33Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program9Output vert(program9Input i)
            {
                program9Output o = (program9Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord1.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord0.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program33Output frag(program33Input i)
            {
                program33Output o = (program33Output)0;
                float r2_x_1 = cb4_values[9].z;
                float r2_y_1 = cb4_values[10].z;
                float r2_z_1 = cb4_values[11].z;
                float r0_w_1 = dot(((-i.texcoord1.xyzx + cb1_values[4].xyzx)).xyzx, float4(r2_x_1, r2_y_1, r2_z_1, r2_x_1));
                float3 r1_xyz_2 = ((i.texcoord1.xyzx + -cb3_values[25].xyzx)).xyz;
                float r0_w_2 = mad(cb3_values[25].w, (-r0_w_1 + sqrt(dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx))), r0_w_1);
                float r0_w_3 = mad(r0_w_2, cb3_values[24].z, cb3_values[24].w);
                float r1_x_13;
                float r1_y_13;
                float r1_z_12;
                float r1_w_8;
                if ((cb5_values[0].x == 1))
                {
                    float4 r1_xyzw_4 = (i.texcoord1.yyyy * cb5_values[2].xxyz);
                    float r1_y_4 = r1_xyzw_4.y;
                    float r1_z_4 = r1_xyzw_4.z;
                    float r1_w_2 = r1_xyzw_4.w;
                    float4 r1_xyzw_5 = mad(cb5_values[1].xxyz, i.texcoord1.xxxx, float4(r1_y_4, r1_y_4, r1_z_4, r1_w_2));
                    float r1_y_5 = r1_xyzw_5.y;
                    float r1_z_5 = r1_xyzw_5.z;
                    float r1_w_3 = r1_xyzw_5.w;
                    float4 r1_xyzw_6 = mad(cb5_values[3].xxyz, i.texcoord1.zzzz, float4(r1_y_5, r1_y_5, r1_z_5, r1_w_3));
                    float r1_y_6 = r1_xyzw_6.y;
                    float r1_z_6 = r1_xyzw_6.z;
                    float r1_w_4 = r1_xyzw_6.w;
                    float4 r1_xyzw_7 = (float4(r1_y_6, r1_y_6, r1_z_6, r1_w_4) + cb5_values[4].xxyz);
                    float r1_y_7 = r1_xyzw_7.y;
                    float r1_z_7 = r1_xyzw_7.z;
                    float r1_w_5 = r1_xyzw_7.w;
                    float4 r1_xyzw_9 = (((cb5_values[0].y == 1)).xxxx ? float4(r1_y_7, r1_z_7, r1_w_5, r1_y_7) : i.texcoord1.xyzx);
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
                    float4 r1_xyzw_12 = t1.Sample(s0, float4(r1_x_11, r1_z_10, r1_w_6, r1_x_11));
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
                float4 r1_xyzw_14 = (i.texcoord4.xxyx / i.texcoord4.wwww);
                float r1_y_14 = r1_xyzw_14.y;
                float r1_z_13 = r1_xyzw_14.z;
                float4 r2_xyzw_4 = t0.Sample(s1, float4(r1_y_14, r1_z_13, r1_y_14, r1_y_14));
                float r0_w_4 = mad(r0_w_3, (dot(float4(r1_x_13, r1_y_13, r1_z_12, r1_w_8), cb2_values[46].xyzw) + -r2_xyzw_4.x), r2_xyzw_4.x);
                float4 r1_xyzw_16 = (r0_w_4.xxxx * _LightColor0.xyzx);
                float r1_x_16 = r1_xyzw_16.x;
                float r1_y_15 = r1_xyzw_16.y;
                float r1_z_14 = r1_xyzw_16.z;
                float r0_w_5 = dot(i.texcoord0.xyzx, unity_ProbeVolumeParams.xyzx);
                float r0_w_6 = max(r0_w_5, 0);
                o.sv_Target0.xyz = ((r0_w_6.xxxx * ((((i.color0.xyzx * _Tint.xyzx)).xyzx * float4(r1_x_16, r1_y_15, r1_z_14, r1_x_16))).xyzx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[9];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program55Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program55Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program41Output vert(program41Input i)
            {
                program41Output o = (program41Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord2.xyz = (mad(unity_WorldToObject[3].xyzx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyzx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program55Output frag(program55Input i)
            {
                program55Output o = (program55Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r2_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord1.zzzz, (mad(cb0_values[4].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r1_w_1);
                    float4 r3_xyzw_9 = t1.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
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
                float r1_w_3 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float4 r2_xyzw_5 = t0.Sample(s1, r1_w_3.xxxx);
                float r0_w_8 = (r0_w_7 * r2_xyzw_5.x);
                float4 r0_xyzw_3 = (((i.color0.xyzx * cb0_values[8].xyzx)).xxyz * ((r0_w_8.xxxx * _LightColor0.xyzx)).xxyz);
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                o.sv_Target0.xyz = (((max(dot(i.texcoord0.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3))).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[9];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
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
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float2 texcoord2 : TEXCOORD2;
                float texcoord4 : TEXCOORD4;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program64Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float2 texcoord2 : TEXCOORD2;
                float texcoord4 : TEXCOORD4;
                float4 texcoord3 : TEXCOORD3;
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
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = clipPos_xyzw_2;
                o.texcoord4.x = mad(max((((clipPos_xyzw_2.z / cb1_values[5].y) + 1) * cb1_values[5].z), 0), cb4_values[1].z, cb4_values[1].w);
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord0.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7))).xyz;
                o.texcoord1.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                float4 r1_xyzw_8 = (r0_xyzw_4.yyyy * unity_WorldToObject[1].xyxx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_4 = r1_xyzw_8.y;
                o.texcoord2.xy = (mad(unity_WorldToObject[3].xyxx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyxx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyxx, r0_xyzw_4.xxxx, float4(r1_x_8, r1_y_4, r1_x_8, r1_x_8))).xyxx)).xyxx)).xy;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program64Output frag(program64Input i)
            {
                program64Output o = (program64Output)0;
                float r0_w_1 = (unity_ProbeVolumeParams.x == 1);
                float r2_x_10;
                float r2_y_10;
                float r2_z_10;
                float r2_w_4;
                if (r0_w_1)
                {
                    float r0_w_2 = (unity_ProbeVolumeParams.y == 1);
                    float3 r2_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_2.xxxx ? r2_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r2_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_8 = r2_xyzw_8.z;
                    float r2_w_2 = r2_xyzw_8.w;
                    float r0_w_3 = mad(r2_y_8, 0.25, 0.75);
                    float r1_z_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r2_x_8 = max(r0_w_3, r1_z_1);
                    float4 r2_xyzw_9 = t1.Sample(s0, float4(r2_x_8, r2_z_8, r2_w_2, r2_x_8));
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
                float r0_w_5 = dot(float4(r2_x_10, r2_y_10, r2_z_10, r2_w_4), unity_OcclusionMaskSelector);
                float4 r1_xyzw_5 = t0.Sample(s1, (((mad(cb0_values[6].xyxx, i.texcoord1.zzzz, (mad(cb0_values[4].xyxx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx);
                float r0_w_6 = (r0_w_5 * r1_xyzw_5.w);
                float4 r1_xyzw_6 = (r0_w_6.xxxx * _LightColor0.xyzx);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_6 = r1_xyzw_6.y;
                float r1_z_4 = r1_xyzw_6.z;
                float r0_w_7 = dot(i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx);
                float r0_w_8 = max(r0_w_7, 0);
                float TEXCOORD2_w_9 = i.texcoord4.x;
                o.sv_Target0.xyz = ((((r0_w_8.xxxx * ((((i.color0.xyzx * cb0_values[8].xyzx)).xyzx * float4(r1_x_6, r1_y_6, r1_z_4, r1_x_6))).xyzx)).xyzx * TEXCOORD2_w_9.xxxx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[9];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            TextureCube t1 : register(t1);
            Texture3D t2 : register(t2);
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
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program63Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program63Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program48Output vert(program48Input i)
            {
                program48Output o = (program48Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = clipPos_xyzw_2;
                o.texcoord4.x = mad(max((((clipPos_xyzw_2.z / cb1_values[5].y) + 1) * cb1_values[5].z), 0), cb4_values[1].z, cb4_values[1].w);
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord0.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7))).xyz;
                o.texcoord1.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                float4 r1_xyzw_8 = (r0_xyzw_4.yyyy * unity_WorldToObject[1]);
                float4 r1_xyzw_9 = mad(unity_WorldToObject[0], r0_xyzw_4.xxxx, r1_xyzw_8);
                float4 r1_xyzw_10 = mad(unity_WorldToObject[2], r0_xyzw_4.zzzz, r1_xyzw_9);
                o.texcoord2.xyzw = mad(unity_WorldToObject[3], r0_xyzw_4.wwww, r1_xyzw_10);
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program63Output frag(program63Input i)
            {
                program63Output o = (program63Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r2_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord1.zzzz, (mad(cb0_values[4].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r1_w_1);
                    float4 r3_xyzw_9 = t2.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
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
                float r1_w_3 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float4 r3_xyzw_11 = t0.Sample(s2, r1_w_3.xxxx);
                float4 r2_xyzw_5 = t1.Sample(s1, r2_xyz_4.xyzx);
                float r1_w_4 = (r2_xyzw_5.w * r3_xyzw_11.x);
                float r0_w_8 = (r0_w_7 * r1_w_4);
                float4 r0_xyzw_3 = (((i.color0.xyzx * cb0_values[8].xyzx)).xxyz * ((r0_w_8.xxxx * _LightColor0.xyzx)).xxyz);
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                float4 r0_xyzw_5 = ((max(dot(i.texcoord0.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float TEXCOORD0_w_10 = i.texcoord4.x;
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5) * TEXCOORD0_w_10.xxxx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[9];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture3D t2 : register(t2);
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
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program62Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program62Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program48Output vert(program48Input i)
            {
                program48Output o = (program48Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = clipPos_xyzw_2;
                o.texcoord4.x = mad(max((((clipPos_xyzw_2.z / cb1_values[5].y) + 1) * cb1_values[5].z), 0), cb4_values[1].z, cb4_values[1].w);
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord0.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7))).xyz;
                o.texcoord1.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                float4 r1_xyzw_8 = (r0_xyzw_4.yyyy * unity_WorldToObject[1]);
                float4 r1_xyzw_9 = mad(unity_WorldToObject[0], r0_xyzw_4.xxxx, r1_xyzw_8);
                float4 r1_xyzw_10 = mad(unity_WorldToObject[2], r0_xyzw_4.zzzz, r1_xyzw_9);
                o.texcoord2.xyzw = mad(unity_WorldToObject[3], r0_xyzw_4.wwww, r1_xyzw_10);
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program62Output frag(program62Input i)
            {
                program62Output o = (program62Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r2_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord1.zzzz, mad(cb0_values[4].xyzw, i.texcoord1.xxxx, (i.texcoord1.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r1_w_1);
                    float4 r3_xyzw_9 = t2.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
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
                float r1_w_3 = (0 < r2_xyzw_4.z);
                float r1_w_4 = asfloat(asint(r1_w_3) & asint(1065353216));
                float4 r3_xyzw_13 = t0.Sample(s1, ((((r2_xyzw_4.xyxx / r2_xyzw_4.wwww)).xyxx + float4(0.5, 0.5, 0, 0))).xyxx);
                float r1_w_5 = (r1_w_4 * r3_xyzw_13.w);
                float4 r2_xyzw_6 = t1.Sample(s2, (dot(r2_xyzw_4.xyzx, r2_xyzw_4.xyzx)).xxxx);
                float r1_w_6 = (r1_w_5 * r2_xyzw_6.x);
                float r0_w_8 = (r0_w_7 * r1_w_6);
                float4 r2_xyzw_7 = (r0_w_8.xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_6 = r2_xyzw_7.y;
                float r2_z_6 = r2_xyzw_7.z;
                float4 r0_xyzw_3 = (((i.color0.xyzx * cb0_values[8].xyzx)).xxyz * float4(r2_x_7, r2_x_7, r2_y_6, r2_z_6));
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                float4 r0_xyzw_5 = ((max(dot(i.texcoord0.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float TEXCOORD0_w_10 = i.texcoord4.x;
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5) * TEXCOORD0_w_10.xxxx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[9];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
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
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program60Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program60Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program48Output vert(program48Input i)
            {
                program48Output o = (program48Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = clipPos_xyzw_2;
                o.texcoord4.x = mad(max((((clipPos_xyzw_2.z / cb1_values[5].y) + 1) * cb1_values[5].z), 0), cb4_values[1].z, cb4_values[1].w);
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord0.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7))).xyz;
                o.texcoord1.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                float4 r1_xyzw_8 = (r0_xyzw_4.yyyy * unity_WorldToObject[1]);
                float4 r1_xyzw_9 = mad(unity_WorldToObject[0], r0_xyzw_4.xxxx, r1_xyzw_8);
                float4 r1_xyzw_10 = mad(unity_WorldToObject[2], r0_xyzw_4.zzzz, r1_xyzw_9);
                o.texcoord2.xyzw = mad(unity_WorldToObject[3], r0_xyzw_4.wwww, r1_xyzw_10);
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program60Output frag(program60Input i)
            {
                program60Output o = (program60Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r2_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord1.zzzz, (mad(cb0_values[4].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r1_w_1);
                    float4 r3_xyzw_9 = t1.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
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
                float r1_w_3 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float4 r2_xyzw_5 = t0.Sample(s1, r1_w_3.xxxx);
                float r0_w_8 = (r0_w_7 * r2_xyzw_5.x);
                float4 r0_xyzw_3 = (((i.color0.xyzx * cb0_values[8].xyzx)).xxyz * ((r0_w_8.xxxx * _LightColor0.xyzx)).xxyz);
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                float4 r0_xyzw_5 = ((max(dot(i.texcoord0.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float TEXCOORD0_w_10 = i.texcoord4.x;
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5) * TEXCOORD0_w_10.xxxx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[6];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[21];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
            SamplerState s0 : register(s0);
            Texture3D t0 : register(t0);
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
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program61Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program61Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program47Output vert(program47Input i)
            {
                program47Output o = (program47Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = clipPos_xyzw_7;
                o.texcoord4.x = mad(max((((clipPos_xyzw_7.z / unity_WorldToObject[1].y) + 1) * unity_WorldToObject[1].z), 0), cb3_values[1].z, cb3_values[1].w);
                float worldNormal_x_12 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12), float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord0.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12))).xyz;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program61Output frag(program61Input i)
            {
                program61Output o = (program61Output)0;
                float r0_w_1 = (unity_ProbeVolumeParams.x == 1);
                float r1_x_10;
                float r1_y_11;
                float r1_z_10;
                float r1_w_4;
                if (r0_w_1)
                {
                    float r0_w_2 = (unity_ProbeVolumeParams.y == 1);
                    float3 r1_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_2.xxxx ? r1_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r1_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r1_y_8 = r1_xyzw_8.y;
                    float r1_z_8 = r1_xyzw_8.z;
                    float r1_w_2 = r1_xyzw_8.w;
                    float r0_w_3 = mad(r1_y_8, 0.25, 0.75);
                    float r1_y_9 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r1_x_8 = max(r0_w_3, r1_y_9);
                    float4 r1_xyzw_9 = t0.Sample(s0, float4(r1_x_8, r1_z_8, r1_w_2, r1_x_8));
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
                float r0_w_5 = dot(float4(r1_x_10, r1_y_11, r1_z_10, r1_w_4), unity_OcclusionMaskSelector);
                float4 r1_xyzw_11 = (r0_w_5.xxxx * _LightColor0.xyzx);
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_12 = r1_xyzw_11.y;
                float r1_z_11 = r1_xyzw_11.z;
                float r0_w_6 = dot(i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx);
                float r0_w_7 = max(r0_w_6, 0);
                float TEXCOORD0_w_8 = i.texcoord4.x;
                o.sv_Target0.xyz = ((((r0_w_7.xxxx * ((((i.color0.xyzx * cb0_values[4].xyzx)).xyzx * float4(r1_x_11, r1_y_12, r1_z_11, r1_x_11))).xyzx)).xyzx * TEXCOORD0_w_8.xxxx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[9];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            TextureCube t1 : register(t1);
            Texture3D t2 : register(t2);
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
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program63Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program63Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program46Output vert(program46Input i)
            {
                program46Output o = (program46Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = clipPos_xyzw_2;
                o.texcoord4.x = mad(max((((clipPos_xyzw_2.z / cb1_values[5].y) + 1) * cb1_values[5].z), 0), cb4_values[1].z, cb4_values[1].w);
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord0.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7))).xyz;
                o.texcoord1.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                float4 r1_xyzw_8 = (r0_xyzw_4.yyyy * unity_WorldToObject[1].xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_4 = r1_xyzw_8.y;
                float r1_z_4 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = mad(unity_WorldToObject[0].xyzx, r0_xyzw_4.xxxx, float4(r1_x_8, r1_y_4, r1_z_4, r1_x_8));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_5 = r1_xyzw_9.y;
                float r1_z_5 = r1_xyzw_9.z;
                o.texcoord2.xyz = (mad(unity_WorldToObject[3].xyzx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyzx, r0_xyzw_4.zzzz, float4(r1_x_9, r1_y_5, r1_z_5, r1_x_9))).xyzx)).xyz;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program63Output frag(program63Input i)
            {
                program63Output o = (program63Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r2_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord1.zzzz, (mad(cb0_values[4].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r1_w_1);
                    float4 r3_xyzw_9 = t2.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
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
                float r1_w_3 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float4 r3_xyzw_11 = t0.Sample(s2, r1_w_3.xxxx);
                float4 r2_xyzw_5 = t1.Sample(s1, r2_xyz_4.xyzx);
                float r1_w_4 = (r2_xyzw_5.w * r3_xyzw_11.x);
                float r0_w_8 = (r0_w_7 * r1_w_4);
                float4 r0_xyzw_3 = (((i.color0.xyzx * cb0_values[8].xyzx)).xxyz * ((r0_w_8.xxxx * _LightColor0.xyzx)).xxyz);
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                float4 r0_xyzw_5 = ((max(dot(i.texcoord0.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float TEXCOORD0_w_10 = i.texcoord4.x;
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5) * TEXCOORD0_w_10.xxxx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[9];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture3D t2 : register(t2);
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
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program62Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program62Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program46Output vert(program46Input i)
            {
                program46Output o = (program46Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = clipPos_xyzw_2;
                o.texcoord4.x = mad(max((((clipPos_xyzw_2.z / cb1_values[5].y) + 1) * cb1_values[5].z), 0), cb4_values[1].z, cb4_values[1].w);
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord0.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7))).xyz;
                o.texcoord1.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                float4 r1_xyzw_8 = (r0_xyzw_4.yyyy * unity_WorldToObject[1].xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_4 = r1_xyzw_8.y;
                float r1_z_4 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = mad(unity_WorldToObject[0].xyzx, r0_xyzw_4.xxxx, float4(r1_x_8, r1_y_4, r1_z_4, r1_x_8));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_5 = r1_xyzw_9.y;
                float r1_z_5 = r1_xyzw_9.z;
                o.texcoord2.xyz = (mad(unity_WorldToObject[3].xyzx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyzx, r0_xyzw_4.zzzz, float4(r1_x_9, r1_y_5, r1_z_5, r1_x_9))).xyzx)).xyz;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program62Output frag(program62Input i)
            {
                program62Output o = (program62Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r2_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord1.zzzz, mad(cb0_values[4].xyzw, i.texcoord1.xxxx, (i.texcoord1.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r1_w_1);
                    float4 r3_xyzw_9 = t2.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
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
                float r1_w_3 = (0 < r2_xyzw_4.z);
                float r1_w_4 = asfloat(asint(r1_w_3) & asint(1065353216));
                float4 r3_xyzw_13 = t0.Sample(s1, ((((r2_xyzw_4.xyxx / r2_xyzw_4.wwww)).xyxx + float4(0.5, 0.5, 0, 0))).xyxx);
                float r1_w_5 = (r1_w_4 * r3_xyzw_13.w);
                float4 r2_xyzw_6 = t1.Sample(s2, (dot(r2_xyzw_4.xyzx, r2_xyzw_4.xyzx)).xxxx);
                float r1_w_6 = (r1_w_5 * r2_xyzw_6.x);
                float r0_w_8 = (r0_w_7 * r1_w_6);
                float4 r2_xyzw_7 = (r0_w_8.xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_6 = r2_xyzw_7.y;
                float r2_z_6 = r2_xyzw_7.z;
                float4 r0_xyzw_3 = (((i.color0.xyzx * cb0_values[8].xyzx)).xxyz * float4(r2_x_7, r2_x_7, r2_y_6, r2_z_6));
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                float4 r0_xyzw_5 = ((max(dot(i.texcoord0.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float TEXCOORD0_w_10 = i.texcoord4.x;
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5) * TEXCOORD0_w_10.xxxx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[9];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
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
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
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
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program60Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program60Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program46Output vert(program46Input i)
            {
                program46Output o = (program46Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = clipPos_xyzw_2;
                o.texcoord4.x = mad(max((((clipPos_xyzw_2.z / cb1_values[5].y) + 1) * cb1_values[5].z), 0), cb4_values[1].z, cb4_values[1].w);
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord0.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7))).xyz;
                o.texcoord1.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                float4 r1_xyzw_8 = (r0_xyzw_4.yyyy * unity_WorldToObject[1].xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_4 = r1_xyzw_8.y;
                float r1_z_4 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = mad(unity_WorldToObject[0].xyzx, r0_xyzw_4.xxxx, float4(r1_x_8, r1_y_4, r1_z_4, r1_x_8));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_5 = r1_xyzw_9.y;
                float r1_z_5 = r1_xyzw_9.z;
                o.texcoord2.xyz = (mad(unity_WorldToObject[3].xyzx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyzx, r0_xyzw_4.zzzz, float4(r1_x_9, r1_y_5, r1_z_5, r1_x_9))).xyzx)).xyz;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program60Output frag(program60Input i)
            {
                program60Output o = (program60Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r2_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord1.zzzz, (mad(cb0_values[4].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r1_w_1);
                    float4 r3_xyzw_9 = t1.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
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
                float r1_w_3 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float4 r2_xyzw_5 = t0.Sample(s1, r1_w_3.xxxx);
                float r0_w_8 = (r0_w_7 * r2_xyzw_5.x);
                float4 r0_xyzw_3 = (((i.color0.xyzx * cb0_values[8].xyzx)).xxyz * ((r0_w_8.xxxx * _LightColor0.xyzx)).xxyz);
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                float4 r0_xyzw_5 = ((max(dot(i.texcoord0.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float TEXCOORD0_w_10 = i.texcoord4.x;
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5) * TEXCOORD0_w_10.xxxx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[9];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
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
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float2 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program64Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float2 texcoord2 : TEXCOORD2;
                float texcoord4 : TEXCOORD4;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program64Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program45Output vert(program45Input i)
            {
                program45Output o = (program45Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord2.xy = (mad(unity_WorldToObject[3].xyxx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyxx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyxx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyxx)).xyxx)).xyxx)).xyxx)).xy;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program64Output frag(program64Input i)
            {
                program64Output o = (program64Output)0;
                float r0_w_1 = (unity_ProbeVolumeParams.x == 1);
                float r2_x_10;
                float r2_y_10;
                float r2_z_10;
                float r2_w_4;
                if (r0_w_1)
                {
                    float r0_w_2 = (unity_ProbeVolumeParams.y == 1);
                    float3 r2_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_2.xxxx ? r2_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r2_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_8 = r2_xyzw_8.z;
                    float r2_w_2 = r2_xyzw_8.w;
                    float r0_w_3 = mad(r2_y_8, 0.25, 0.75);
                    float r1_z_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r2_x_8 = max(r0_w_3, r1_z_1);
                    float4 r2_xyzw_9 = t1.Sample(s0, float4(r2_x_8, r2_z_8, r2_w_2, r2_x_8));
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
                float r0_w_5 = dot(float4(r2_x_10, r2_y_10, r2_z_10, r2_w_4), unity_OcclusionMaskSelector);
                float4 r1_xyzw_5 = t0.Sample(s1, (((mad(cb0_values[6].xyxx, i.texcoord1.zzzz, (mad(cb0_values[4].xyxx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx);
                float r0_w_6 = (r0_w_5 * r1_xyzw_5.w);
                float4 r1_xyzw_6 = (r0_w_6.xxxx * _LightColor0.xyzx);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_6 = r1_xyzw_6.y;
                float r1_z_4 = r1_xyzw_6.z;
                float r0_w_7 = dot(i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx);
                float r0_w_8 = max(r0_w_7, 0);
                float TEXCOORD2_w_9 = i.texcoord4.x;
                o.sv_Target0.xyz = ((((r0_w_8.xxxx * ((((i.color0.xyzx * cb0_values[8].xyzx)).xyzx * float4(r1_x_6, r1_y_6, r1_z_4, r1_x_6))).xyzx)).xyzx * TEXCOORD2_w_9.xxxx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[9];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            TextureCube t1 : register(t1);
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
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float2 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program63Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program63Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program45Output vert(program45Input i)
            {
                program45Output o = (program45Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord2.xy = (mad(unity_WorldToObject[3].xyxx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyxx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyxx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyxx)).xyxx)).xyxx)).xyxx)).xy;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program63Output frag(program63Input i)
            {
                program63Output o = (program63Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r2_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord1.zzzz, (mad(cb0_values[4].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r1_w_1);
                    float4 r3_xyzw_9 = t2.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
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
                float r1_w_3 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float4 r3_xyzw_11 = t0.Sample(s2, r1_w_3.xxxx);
                float4 r2_xyzw_5 = t1.Sample(s1, r2_xyz_4.xyzx);
                float r1_w_4 = (r2_xyzw_5.w * r3_xyzw_11.x);
                float r0_w_8 = (r0_w_7 * r1_w_4);
                float4 r0_xyzw_3 = (((i.color0.xyzx * cb0_values[8].xyzx)).xxyz * ((r0_w_8.xxxx * _LightColor0.xyzx)).xxyz);
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                float4 r0_xyzw_5 = ((max(dot(i.texcoord0.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float TEXCOORD0_w_10 = i.texcoord4.x;
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5) * TEXCOORD0_w_10.xxxx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[9];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
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
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float2 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program62Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program62Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program45Output vert(program45Input i)
            {
                program45Output o = (program45Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord2.xy = (mad(unity_WorldToObject[3].xyxx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyxx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyxx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyxx)).xyxx)).xyxx)).xyxx)).xy;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program62Output frag(program62Input i)
            {
                program62Output o = (program62Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r2_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord1.zzzz, mad(cb0_values[4].xyzw, i.texcoord1.xxxx, (i.texcoord1.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r1_w_1);
                    float4 r3_xyzw_9 = t2.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
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
                float r1_w_3 = (0 < r2_xyzw_4.z);
                float r1_w_4 = asfloat(asint(r1_w_3) & asint(1065353216));
                float4 r3_xyzw_13 = t0.Sample(s1, ((((r2_xyzw_4.xyxx / r2_xyzw_4.wwww)).xyxx + float4(0.5, 0.5, 0, 0))).xyxx);
                float r1_w_5 = (r1_w_4 * r3_xyzw_13.w);
                float4 r2_xyzw_6 = t1.Sample(s2, (dot(r2_xyzw_4.xyzx, r2_xyzw_4.xyzx)).xxxx);
                float r1_w_6 = (r1_w_5 * r2_xyzw_6.x);
                float r0_w_8 = (r0_w_7 * r1_w_6);
                float4 r2_xyzw_7 = (r0_w_8.xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_6 = r2_xyzw_7.y;
                float r2_z_6 = r2_xyzw_7.z;
                float4 r0_xyzw_3 = (((i.color0.xyzx * cb0_values[8].xyzx)).xxyz * float4(r2_x_7, r2_x_7, r2_y_6, r2_z_6));
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                float4 r0_xyzw_5 = ((max(dot(i.texcoord0.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float TEXCOORD0_w_10 = i.texcoord4.x;
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5) * TEXCOORD0_w_10.xxxx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[9];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
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
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float2 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program60Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program60Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program45Output vert(program45Input i)
            {
                program45Output o = (program45Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord2.xy = (mad(unity_WorldToObject[3].xyxx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyxx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyxx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyxx)).xyxx)).xyxx)).xyxx)).xy;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program60Output frag(program60Input i)
            {
                program60Output o = (program60Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r2_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord1.zzzz, (mad(cb0_values[4].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r1_w_1);
                    float4 r3_xyzw_9 = t1.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
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
                float r1_w_3 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float4 r2_xyzw_5 = t0.Sample(s1, r1_w_3.xxxx);
                float r0_w_8 = (r0_w_7 * r2_xyzw_5.x);
                float4 r0_xyzw_3 = (((i.color0.xyzx * cb0_values[8].xyzx)).xxyz * ((r0_w_8.xxxx * _LightColor0.xyzx)).xxyz);
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                float4 r0_xyzw_5 = ((max(dot(i.texcoord0.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float TEXCOORD0_w_10 = i.texcoord4.x;
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5) * TEXCOORD0_w_10.xxxx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[9];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
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
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float2 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program59Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float2 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program59Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program45Output vert(program45Input i)
            {
                program45Output o = (program45Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord2.xy = (mad(unity_WorldToObject[3].xyxx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyxx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyxx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyxx)).xyxx)).xyxx)).xyxx)).xy;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program59Output frag(program59Input i)
            {
                program59Output o = (program59Output)0;
                float r0_w_1 = (unity_ProbeVolumeParams.x == 1);
                float r2_x_10;
                float r2_y_10;
                float r2_z_10;
                float r2_w_4;
                if (r0_w_1)
                {
                    float r0_w_2 = (unity_ProbeVolumeParams.y == 1);
                    float3 r2_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_2.xxxx ? r2_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r2_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_8 = r2_xyzw_8.z;
                    float r2_w_2 = r2_xyzw_8.w;
                    float r0_w_3 = mad(r2_y_8, 0.25, 0.75);
                    float r1_z_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r2_x_8 = max(r0_w_3, r1_z_1);
                    float4 r2_xyzw_9 = t1.Sample(s0, float4(r2_x_8, r2_z_8, r2_w_2, r2_x_8));
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
                float r0_w_5 = dot(float4(r2_x_10, r2_y_10, r2_z_10, r2_w_4), unity_OcclusionMaskSelector);
                float4 r1_xyzw_5 = t0.Sample(s1, (((mad(cb0_values[6].xyxx, i.texcoord1.zzzz, (mad(cb0_values[4].xyxx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx);
                float r0_w_6 = (r0_w_5 * r1_xyzw_5.w);
                float4 r1_xyzw_6 = (r0_w_6.xxxx * _LightColor0.xyzx);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_6 = r1_xyzw_6.y;
                float r1_z_4 = r1_xyzw_6.z;
                float r0_w_7 = dot(i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx);
                float r0_w_8 = max(r0_w_7, 0);
                o.sv_Target0.xyz = ((r0_w_8.xxxx * ((((i.color0.xyzx * cb0_values[8].xyzx)).xyzx * float4(r1_x_6, r1_y_6, r1_z_4, r1_x_6))).xyzx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[9];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            TextureCube t1 : register(t1);
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
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float2 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program58Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program58Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program45Output vert(program45Input i)
            {
                program45Output o = (program45Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord2.xy = (mad(unity_WorldToObject[3].xyxx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyxx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyxx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyxx)).xyxx)).xyxx)).xyxx)).xy;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program58Output frag(program58Input i)
            {
                program58Output o = (program58Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r2_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord1.zzzz, (mad(cb0_values[4].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r1_w_1);
                    float4 r3_xyzw_9 = t2.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
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
                float r1_w_3 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float4 r3_xyzw_11 = t0.Sample(s2, r1_w_3.xxxx);
                float4 r2_xyzw_5 = t1.Sample(s1, r2_xyz_4.xyzx);
                float r1_w_4 = (r2_xyzw_5.w * r3_xyzw_11.x);
                float r0_w_8 = (r0_w_7 * r1_w_4);
                float4 r0_xyzw_3 = (((i.color0.xyzx * cb0_values[8].xyzx)).xxyz * ((r0_w_8.xxxx * _LightColor0.xyzx)).xxyz);
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                o.sv_Target0.xyz = (((max(dot(i.texcoord0.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3))).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[9];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
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
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float2 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program57Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program57Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program45Output vert(program45Input i)
            {
                program45Output o = (program45Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord2.xy = (mad(unity_WorldToObject[3].xyxx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyxx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyxx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyxx)).xyxx)).xyxx)).xyxx)).xy;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program57Output frag(program57Input i)
            {
                program57Output o = (program57Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r2_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord1.zzzz, mad(cb0_values[4].xyzw, i.texcoord1.xxxx, (i.texcoord1.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r1_w_1);
                    float4 r3_xyzw_9 = t2.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
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
                float r1_w_3 = (0 < r2_xyzw_4.z);
                float r1_w_4 = asfloat(asint(r1_w_3) & asint(1065353216));
                float4 r3_xyzw_13 = t0.Sample(s1, ((((r2_xyzw_4.xyxx / r2_xyzw_4.wwww)).xyxx + float4(0.5, 0.5, 0, 0))).xyxx);
                float r1_w_5 = (r1_w_4 * r3_xyzw_13.w);
                float4 r2_xyzw_6 = t1.Sample(s2, (dot(r2_xyzw_4.xyzx, r2_xyzw_4.xyzx)).xxxx);
                float r1_w_6 = (r1_w_5 * r2_xyzw_6.x);
                float r0_w_8 = (r0_w_7 * r1_w_6);
                float4 r2_xyzw_7 = (r0_w_8.xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_6 = r2_xyzw_7.y;
                float r2_z_6 = r2_xyzw_7.z;
                float4 r0_xyzw_3 = (((i.color0.xyzx * cb0_values[8].xyzx)).xxyz * float4(r2_x_7, r2_x_7, r2_y_6, r2_z_6));
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                o.sv_Target0.xyz = (((max(dot(i.texcoord0.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3))).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[9];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
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
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float2 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program55Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program55Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program45Output vert(program45Input i)
            {
                program45Output o = (program45Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord2.xy = (mad(unity_WorldToObject[3].xyxx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyxx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyxx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyxx)).xyxx)).xyxx)).xyxx)).xy;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program55Output frag(program55Input i)
            {
                program55Output o = (program55Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r2_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord1.zzzz, (mad(cb0_values[4].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r1_w_1);
                    float4 r3_xyzw_9 = t1.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
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
                float r1_w_3 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float4 r2_xyzw_5 = t0.Sample(s1, r1_w_3.xxxx);
                float r0_w_8 = (r0_w_7 * r2_xyzw_5.x);
                float4 r0_xyzw_3 = (((i.color0.xyzx * cb0_values[8].xyzx)).xxyz * ((r0_w_8.xxxx * _LightColor0.xyzx)).xxyz);
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                o.sv_Target0.xyz = (((max(dot(i.texcoord0.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3))).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[9];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program64Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float2 texcoord2 : TEXCOORD2;
                float texcoord4 : TEXCOORD4;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program64Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program43Output vert(program43Input i)
            {
                program43Output o = (program43Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                float4 r1_xyzw_3 = (r0_xyzw_4.yyyy * unity_WorldToObject[1]);
                float4 r1_xyzw_4 = mad(unity_WorldToObject[0], r0_xyzw_4.xxxx, r1_xyzw_3);
                float4 r1_xyzw_5 = mad(unity_WorldToObject[2], r0_xyzw_4.zzzz, r1_xyzw_4);
                o.texcoord2.xyzw = mad(unity_WorldToObject[3], r0_xyzw_4.wwww, r1_xyzw_5);
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program64Output frag(program64Input i)
            {
                program64Output o = (program64Output)0;
                float r0_w_1 = (unity_ProbeVolumeParams.x == 1);
                float r2_x_10;
                float r2_y_10;
                float r2_z_10;
                float r2_w_4;
                if (r0_w_1)
                {
                    float r0_w_2 = (unity_ProbeVolumeParams.y == 1);
                    float3 r2_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_2.xxxx ? r2_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r2_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_8 = r2_xyzw_8.z;
                    float r2_w_2 = r2_xyzw_8.w;
                    float r0_w_3 = mad(r2_y_8, 0.25, 0.75);
                    float r1_z_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r2_x_8 = max(r0_w_3, r1_z_1);
                    float4 r2_xyzw_9 = t1.Sample(s0, float4(r2_x_8, r2_z_8, r2_w_2, r2_x_8));
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
                float r0_w_5 = dot(float4(r2_x_10, r2_y_10, r2_z_10, r2_w_4), unity_OcclusionMaskSelector);
                float4 r1_xyzw_5 = t0.Sample(s1, (((mad(cb0_values[6].xyxx, i.texcoord1.zzzz, (mad(cb0_values[4].xyxx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx);
                float r0_w_6 = (r0_w_5 * r1_xyzw_5.w);
                float4 r1_xyzw_6 = (r0_w_6.xxxx * _LightColor0.xyzx);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_6 = r1_xyzw_6.y;
                float r1_z_4 = r1_xyzw_6.z;
                float r0_w_7 = dot(i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx);
                float r0_w_8 = max(r0_w_7, 0);
                float TEXCOORD2_w_9 = i.texcoord4.x;
                o.sv_Target0.xyz = ((((r0_w_8.xxxx * ((((i.color0.xyzx * cb0_values[8].xyzx)).xyzx * float4(r1_x_6, r1_y_6, r1_z_4, r1_x_6))).xyzx)).xyzx * TEXCOORD2_w_9.xxxx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[9];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            TextureCube t1 : register(t1);
            Texture3D t2 : register(t2);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program63Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program63Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program43Output vert(program43Input i)
            {
                program43Output o = (program43Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                float4 r1_xyzw_3 = (r0_xyzw_4.yyyy * unity_WorldToObject[1]);
                float4 r1_xyzw_4 = mad(unity_WorldToObject[0], r0_xyzw_4.xxxx, r1_xyzw_3);
                float4 r1_xyzw_5 = mad(unity_WorldToObject[2], r0_xyzw_4.zzzz, r1_xyzw_4);
                o.texcoord2.xyzw = mad(unity_WorldToObject[3], r0_xyzw_4.wwww, r1_xyzw_5);
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program63Output frag(program63Input i)
            {
                program63Output o = (program63Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r2_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord1.zzzz, (mad(cb0_values[4].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r1_w_1);
                    float4 r3_xyzw_9 = t2.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
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
                float r1_w_3 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float4 r3_xyzw_11 = t0.Sample(s2, r1_w_3.xxxx);
                float4 r2_xyzw_5 = t1.Sample(s1, r2_xyz_4.xyzx);
                float r1_w_4 = (r2_xyzw_5.w * r3_xyzw_11.x);
                float r0_w_8 = (r0_w_7 * r1_w_4);
                float4 r0_xyzw_3 = (((i.color0.xyzx * cb0_values[8].xyzx)).xxyz * ((r0_w_8.xxxx * _LightColor0.xyzx)).xxyz);
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                float4 r0_xyzw_5 = ((max(dot(i.texcoord0.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float TEXCOORD0_w_10 = i.texcoord4.x;
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5) * TEXCOORD0_w_10.xxxx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[9];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture3D t2 : register(t2);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program62Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program62Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program43Output vert(program43Input i)
            {
                program43Output o = (program43Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                float4 r1_xyzw_3 = (r0_xyzw_4.yyyy * unity_WorldToObject[1]);
                float4 r1_xyzw_4 = mad(unity_WorldToObject[0], r0_xyzw_4.xxxx, r1_xyzw_3);
                float4 r1_xyzw_5 = mad(unity_WorldToObject[2], r0_xyzw_4.zzzz, r1_xyzw_4);
                o.texcoord2.xyzw = mad(unity_WorldToObject[3], r0_xyzw_4.wwww, r1_xyzw_5);
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program62Output frag(program62Input i)
            {
                program62Output o = (program62Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r2_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord1.zzzz, mad(cb0_values[4].xyzw, i.texcoord1.xxxx, (i.texcoord1.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r1_w_1);
                    float4 r3_xyzw_9 = t2.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
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
                float r1_w_3 = (0 < r2_xyzw_4.z);
                float r1_w_4 = asfloat(asint(r1_w_3) & asint(1065353216));
                float4 r3_xyzw_13 = t0.Sample(s1, ((((r2_xyzw_4.xyxx / r2_xyzw_4.wwww)).xyxx + float4(0.5, 0.5, 0, 0))).xyxx);
                float r1_w_5 = (r1_w_4 * r3_xyzw_13.w);
                float4 r2_xyzw_6 = t1.Sample(s2, (dot(r2_xyzw_4.xyzx, r2_xyzw_4.xyzx)).xxxx);
                float r1_w_6 = (r1_w_5 * r2_xyzw_6.x);
                float r0_w_8 = (r0_w_7 * r1_w_6);
                float4 r2_xyzw_7 = (r0_w_8.xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_6 = r2_xyzw_7.y;
                float r2_z_6 = r2_xyzw_7.z;
                float4 r0_xyzw_3 = (((i.color0.xyzx * cb0_values[8].xyzx)).xxyz * float4(r2_x_7, r2_x_7, r2_y_6, r2_z_6));
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                float4 r0_xyzw_5 = ((max(dot(i.texcoord0.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float TEXCOORD0_w_10 = i.texcoord4.x;
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5) * TEXCOORD0_w_10.xxxx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[9];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program60Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program60Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program43Output vert(program43Input i)
            {
                program43Output o = (program43Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                float4 r1_xyzw_3 = (r0_xyzw_4.yyyy * unity_WorldToObject[1]);
                float4 r1_xyzw_4 = mad(unity_WorldToObject[0], r0_xyzw_4.xxxx, r1_xyzw_3);
                float4 r1_xyzw_5 = mad(unity_WorldToObject[2], r0_xyzw_4.zzzz, r1_xyzw_4);
                o.texcoord2.xyzw = mad(unity_WorldToObject[3], r0_xyzw_4.wwww, r1_xyzw_5);
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program60Output frag(program60Input i)
            {
                program60Output o = (program60Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r2_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord1.zzzz, (mad(cb0_values[4].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r1_w_1);
                    float4 r3_xyzw_9 = t1.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
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
                float r1_w_3 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float4 r2_xyzw_5 = t0.Sample(s1, r1_w_3.xxxx);
                float r0_w_8 = (r0_w_7 * r2_xyzw_5.x);
                float4 r0_xyzw_3 = (((i.color0.xyzx * cb0_values[8].xyzx)).xxyz * ((r0_w_8.xxxx * _LightColor0.xyzx)).xxyz);
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                float4 r0_xyzw_5 = ((max(dot(i.texcoord0.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float TEXCOORD0_w_10 = i.texcoord4.x;
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5) * TEXCOORD0_w_10.xxxx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[9];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program59Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float2 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program59Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program43Output vert(program43Input i)
            {
                program43Output o = (program43Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                float4 r1_xyzw_3 = (r0_xyzw_4.yyyy * unity_WorldToObject[1]);
                float4 r1_xyzw_4 = mad(unity_WorldToObject[0], r0_xyzw_4.xxxx, r1_xyzw_3);
                float4 r1_xyzw_5 = mad(unity_WorldToObject[2], r0_xyzw_4.zzzz, r1_xyzw_4);
                o.texcoord2.xyzw = mad(unity_WorldToObject[3], r0_xyzw_4.wwww, r1_xyzw_5);
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program59Output frag(program59Input i)
            {
                program59Output o = (program59Output)0;
                float r0_w_1 = (unity_ProbeVolumeParams.x == 1);
                float r2_x_10;
                float r2_y_10;
                float r2_z_10;
                float r2_w_4;
                if (r0_w_1)
                {
                    float r0_w_2 = (unity_ProbeVolumeParams.y == 1);
                    float3 r2_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_2.xxxx ? r2_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r2_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_8 = r2_xyzw_8.z;
                    float r2_w_2 = r2_xyzw_8.w;
                    float r0_w_3 = mad(r2_y_8, 0.25, 0.75);
                    float r1_z_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r2_x_8 = max(r0_w_3, r1_z_1);
                    float4 r2_xyzw_9 = t1.Sample(s0, float4(r2_x_8, r2_z_8, r2_w_2, r2_x_8));
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
                float r0_w_5 = dot(float4(r2_x_10, r2_y_10, r2_z_10, r2_w_4), unity_OcclusionMaskSelector);
                float4 r1_xyzw_5 = t0.Sample(s1, (((mad(cb0_values[6].xyxx, i.texcoord1.zzzz, (mad(cb0_values[4].xyxx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx);
                float r0_w_6 = (r0_w_5 * r1_xyzw_5.w);
                float4 r1_xyzw_6 = (r0_w_6.xxxx * _LightColor0.xyzx);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_6 = r1_xyzw_6.y;
                float r1_z_4 = r1_xyzw_6.z;
                float r0_w_7 = dot(i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx);
                float r0_w_8 = max(r0_w_7, 0);
                o.sv_Target0.xyz = ((r0_w_8.xxxx * ((((i.color0.xyzx * cb0_values[8].xyzx)).xyzx * float4(r1_x_6, r1_y_6, r1_z_4, r1_x_6))).xyzx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[9];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            TextureCube t1 : register(t1);
            Texture3D t2 : register(t2);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program58Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program58Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program43Output vert(program43Input i)
            {
                program43Output o = (program43Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                float4 r1_xyzw_3 = (r0_xyzw_4.yyyy * unity_WorldToObject[1]);
                float4 r1_xyzw_4 = mad(unity_WorldToObject[0], r0_xyzw_4.xxxx, r1_xyzw_3);
                float4 r1_xyzw_5 = mad(unity_WorldToObject[2], r0_xyzw_4.zzzz, r1_xyzw_4);
                o.texcoord2.xyzw = mad(unity_WorldToObject[3], r0_xyzw_4.wwww, r1_xyzw_5);
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program58Output frag(program58Input i)
            {
                program58Output o = (program58Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r2_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord1.zzzz, (mad(cb0_values[4].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r1_w_1);
                    float4 r3_xyzw_9 = t2.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
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
                float r1_w_3 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float4 r3_xyzw_11 = t0.Sample(s2, r1_w_3.xxxx);
                float4 r2_xyzw_5 = t1.Sample(s1, r2_xyz_4.xyzx);
                float r1_w_4 = (r2_xyzw_5.w * r3_xyzw_11.x);
                float r0_w_8 = (r0_w_7 * r1_w_4);
                float4 r0_xyzw_3 = (((i.color0.xyzx * cb0_values[8].xyzx)).xxyz * ((r0_w_8.xxxx * _LightColor0.xyzx)).xxyz);
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                o.sv_Target0.xyz = (((max(dot(i.texcoord0.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3))).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[9];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture3D t2 : register(t2);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program57Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program57Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program43Output vert(program43Input i)
            {
                program43Output o = (program43Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                float4 r1_xyzw_3 = (r0_xyzw_4.yyyy * unity_WorldToObject[1]);
                float4 r1_xyzw_4 = mad(unity_WorldToObject[0], r0_xyzw_4.xxxx, r1_xyzw_3);
                float4 r1_xyzw_5 = mad(unity_WorldToObject[2], r0_xyzw_4.zzzz, r1_xyzw_4);
                o.texcoord2.xyzw = mad(unity_WorldToObject[3], r0_xyzw_4.wwww, r1_xyzw_5);
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program57Output frag(program57Input i)
            {
                program57Output o = (program57Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r2_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord1.zzzz, mad(cb0_values[4].xyzw, i.texcoord1.xxxx, (i.texcoord1.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r1_w_1);
                    float4 r3_xyzw_9 = t2.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
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
                float r1_w_3 = (0 < r2_xyzw_4.z);
                float r1_w_4 = asfloat(asint(r1_w_3) & asint(1065353216));
                float4 r3_xyzw_13 = t0.Sample(s1, ((((r2_xyzw_4.xyxx / r2_xyzw_4.wwww)).xyxx + float4(0.5, 0.5, 0, 0))).xyxx);
                float r1_w_5 = (r1_w_4 * r3_xyzw_13.w);
                float4 r2_xyzw_6 = t1.Sample(s2, (dot(r2_xyzw_4.xyzx, r2_xyzw_4.xyzx)).xxxx);
                float r1_w_6 = (r1_w_5 * r2_xyzw_6.x);
                float r0_w_8 = (r0_w_7 * r1_w_6);
                float4 r2_xyzw_7 = (r0_w_8.xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_6 = r2_xyzw_7.y;
                float r2_z_6 = r2_xyzw_7.z;
                float4 r0_xyzw_3 = (((i.color0.xyzx * cb0_values[8].xyzx)).xxyz * float4(r2_x_7, r2_x_7, r2_y_6, r2_z_6));
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                o.sv_Target0.xyz = (((max(dot(i.texcoord0.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3))).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[9];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program55Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program55Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program43Output vert(program43Input i)
            {
                program43Output o = (program43Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                float4 r1_xyzw_3 = (r0_xyzw_4.yyyy * unity_WorldToObject[1]);
                float4 r1_xyzw_4 = mad(unity_WorldToObject[0], r0_xyzw_4.xxxx, r1_xyzw_3);
                float4 r1_xyzw_5 = mad(unity_WorldToObject[2], r0_xyzw_4.zzzz, r1_xyzw_4);
                o.texcoord2.xyzw = mad(unity_WorldToObject[3], r0_xyzw_4.wwww, r1_xyzw_5);
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program55Output frag(program55Input i)
            {
                program55Output o = (program55Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r2_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord1.zzzz, (mad(cb0_values[4].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r1_w_1);
                    float4 r3_xyzw_9 = t1.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
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
                float r1_w_3 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float4 r2_xyzw_5 = t0.Sample(s1, r1_w_3.xxxx);
                float r0_w_8 = (r0_w_7 * r2_xyzw_5.x);
                float4 r0_xyzw_3 = (((i.color0.xyzx * cb0_values[8].xyzx)).xxyz * ((r0_w_8.xxxx * _LightColor0.xyzx)).xxyz);
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                o.sv_Target0.xyz = (((max(dot(i.texcoord0.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3))).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[7];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityProbeVolume : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[7];
            };
            SamplerState s0 : register(s0);
            Texture3D t0 : register(t0);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program61Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program61Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program42Output vert(program42Input i)
            {
                program42Output o = (program42Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord1.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord0.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program61Output frag(program61Input i)
            {
                program61Output o = (program61Output)0;
                float r0_w_1 = (unity_ProbeVolumeParams.x == 1);
                float r1_x_10;
                float r1_y_11;
                float r1_z_10;
                float r1_w_4;
                if (r0_w_1)
                {
                    float r0_w_2 = (unity_ProbeVolumeParams.y == 1);
                    float3 r1_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_2.xxxx ? r1_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r1_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r1_y_8 = r1_xyzw_8.y;
                    float r1_z_8 = r1_xyzw_8.z;
                    float r1_w_2 = r1_xyzw_8.w;
                    float r0_w_3 = mad(r1_y_8, 0.25, 0.75);
                    float r1_y_9 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r1_x_8 = max(r0_w_3, r1_y_9);
                    float4 r1_xyzw_9 = t0.Sample(s0, float4(r1_x_8, r1_z_8, r1_w_2, r1_x_8));
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
                float r0_w_5 = dot(float4(r1_x_10, r1_y_11, r1_z_10, r1_w_4), unity_OcclusionMaskSelector);
                float4 r1_xyzw_11 = (r0_w_5.xxxx * _LightColor0.xyzx);
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_12 = r1_xyzw_11.y;
                float r1_z_11 = r1_xyzw_11.z;
                float r0_w_6 = dot(i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx);
                float r0_w_7 = max(r0_w_6, 0);
                float TEXCOORD0_w_8 = i.texcoord4.x;
                o.sv_Target0.xyz = ((((r0_w_7.xxxx * ((((i.color0.xyzx * cb0_values[4].xyzx)).xyzx * float4(r1_x_11, r1_y_12, r1_z_11, r1_x_11))).xyzx)).xyzx * TEXCOORD0_w_8.xxxx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[7];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer UnityProbeVolume : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[7];
            };
            SamplerState s0 : register(s0);
            Texture3D t0 : register(t0);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program56Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program56Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program42Output vert(program42Input i)
            {
                program42Output o = (program42Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord1.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord0.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program56Output frag(program56Input i)
            {
                program56Output o = (program56Output)0;
                float r0_w_1 = (unity_ProbeVolumeParams.x == 1);
                float r1_x_10;
                float r1_y_11;
                float r1_z_10;
                float r1_w_4;
                if (r0_w_1)
                {
                    float r0_w_2 = (unity_ProbeVolumeParams.y == 1);
                    float3 r1_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_2.xxxx ? r1_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r1_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r1_y_8 = r1_xyzw_8.y;
                    float r1_z_8 = r1_xyzw_8.z;
                    float r1_w_2 = r1_xyzw_8.w;
                    float r0_w_3 = mad(r1_y_8, 0.25, 0.75);
                    float r1_y_9 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r1_x_8 = max(r0_w_3, r1_y_9);
                    float4 r1_xyzw_9 = t0.Sample(s0, float4(r1_x_8, r1_z_8, r1_w_2, r1_x_8));
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
                float r0_w_5 = dot(float4(r1_x_10, r1_y_11, r1_z_10, r1_w_4), unity_OcclusionMaskSelector);
                float4 r1_xyzw_11 = (r0_w_5.xxxx * _LightColor0.xyzx);
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_12 = r1_xyzw_11.y;
                float r1_z_11 = r1_xyzw_11.z;
                float r0_w_6 = dot(i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx);
                float r0_w_7 = max(r0_w_6, 0);
                o.sv_Target0.xyz = ((r0_w_7.xxxx * ((((i.color0.xyzx * cb0_values[4].xyzx)).xyzx * float4(r1_x_11, r1_y_12, r1_z_11, r1_x_11))).xyzx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[9];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program64Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float2 texcoord2 : TEXCOORD2;
                float texcoord4 : TEXCOORD4;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program64Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program41Output vert(program41Input i)
            {
                program41Output o = (program41Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord2.xyz = (mad(unity_WorldToObject[3].xyzx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyzx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program64Output frag(program64Input i)
            {
                program64Output o = (program64Output)0;
                float r0_w_1 = (unity_ProbeVolumeParams.x == 1);
                float r2_x_10;
                float r2_y_10;
                float r2_z_10;
                float r2_w_4;
                if (r0_w_1)
                {
                    float r0_w_2 = (unity_ProbeVolumeParams.y == 1);
                    float3 r2_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_2.xxxx ? r2_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r2_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_8 = r2_xyzw_8.z;
                    float r2_w_2 = r2_xyzw_8.w;
                    float r0_w_3 = mad(r2_y_8, 0.25, 0.75);
                    float r1_z_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r2_x_8 = max(r0_w_3, r1_z_1);
                    float4 r2_xyzw_9 = t1.Sample(s0, float4(r2_x_8, r2_z_8, r2_w_2, r2_x_8));
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
                float r0_w_5 = dot(float4(r2_x_10, r2_y_10, r2_z_10, r2_w_4), unity_OcclusionMaskSelector);
                float4 r1_xyzw_5 = t0.Sample(s1, (((mad(cb0_values[6].xyxx, i.texcoord1.zzzz, (mad(cb0_values[4].xyxx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx);
                float r0_w_6 = (r0_w_5 * r1_xyzw_5.w);
                float4 r1_xyzw_6 = (r0_w_6.xxxx * _LightColor0.xyzx);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_6 = r1_xyzw_6.y;
                float r1_z_4 = r1_xyzw_6.z;
                float r0_w_7 = dot(i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx);
                float r0_w_8 = max(r0_w_7, 0);
                float TEXCOORD2_w_9 = i.texcoord4.x;
                o.sv_Target0.xyz = ((((r0_w_8.xxxx * ((((i.color0.xyzx * cb0_values[8].xyzx)).xyzx * float4(r1_x_6, r1_y_6, r1_z_4, r1_x_6))).xyzx)).xyzx * TEXCOORD2_w_9.xxxx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[9];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            TextureCube t1 : register(t1);
            Texture3D t2 : register(t2);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program63Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program63Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program41Output vert(program41Input i)
            {
                program41Output o = (program41Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord2.xyz = (mad(unity_WorldToObject[3].xyzx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyzx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program63Output frag(program63Input i)
            {
                program63Output o = (program63Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r2_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord1.zzzz, (mad(cb0_values[4].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r1_w_1);
                    float4 r3_xyzw_9 = t2.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
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
                float r1_w_3 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float4 r3_xyzw_11 = t0.Sample(s2, r1_w_3.xxxx);
                float4 r2_xyzw_5 = t1.Sample(s1, r2_xyz_4.xyzx);
                float r1_w_4 = (r2_xyzw_5.w * r3_xyzw_11.x);
                float r0_w_8 = (r0_w_7 * r1_w_4);
                float4 r0_xyzw_3 = (((i.color0.xyzx * cb0_values[8].xyzx)).xxyz * ((r0_w_8.xxxx * _LightColor0.xyzx)).xxyz);
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                float4 r0_xyzw_5 = ((max(dot(i.texcoord0.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float TEXCOORD0_w_10 = i.texcoord4.x;
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5) * TEXCOORD0_w_10.xxxx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[9];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture3D t2 : register(t2);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program62Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program62Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program41Output vert(program41Input i)
            {
                program41Output o = (program41Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord2.xyz = (mad(unity_WorldToObject[3].xyzx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyzx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program62Output frag(program62Input i)
            {
                program62Output o = (program62Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r2_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord1.zzzz, mad(cb0_values[4].xyzw, i.texcoord1.xxxx, (i.texcoord1.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r1_w_1);
                    float4 r3_xyzw_9 = t2.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
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
                float r1_w_3 = (0 < r2_xyzw_4.z);
                float r1_w_4 = asfloat(asint(r1_w_3) & asint(1065353216));
                float4 r3_xyzw_13 = t0.Sample(s1, ((((r2_xyzw_4.xyxx / r2_xyzw_4.wwww)).xyxx + float4(0.5, 0.5, 0, 0))).xyxx);
                float r1_w_5 = (r1_w_4 * r3_xyzw_13.w);
                float4 r2_xyzw_6 = t1.Sample(s2, (dot(r2_xyzw_4.xyzx, r2_xyzw_4.xyzx)).xxxx);
                float r1_w_6 = (r1_w_5 * r2_xyzw_6.x);
                float r0_w_8 = (r0_w_7 * r1_w_6);
                float4 r2_xyzw_7 = (r0_w_8.xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_6 = r2_xyzw_7.y;
                float r2_z_6 = r2_xyzw_7.z;
                float4 r0_xyzw_3 = (((i.color0.xyzx * cb0_values[8].xyzx)).xxyz * float4(r2_x_7, r2_x_7, r2_y_6, r2_z_6));
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                float4 r0_xyzw_5 = ((max(dot(i.texcoord0.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float TEXCOORD0_w_10 = i.texcoord4.x;
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5) * TEXCOORD0_w_10.xxxx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[9];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program60Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program60Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program41Output vert(program41Input i)
            {
                program41Output o = (program41Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord2.xyz = (mad(unity_WorldToObject[3].xyzx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyzx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program60Output frag(program60Input i)
            {
                program60Output o = (program60Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r2_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord1.zzzz, (mad(cb0_values[4].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r1_w_1);
                    float4 r3_xyzw_9 = t1.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
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
                float r1_w_3 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float4 r2_xyzw_5 = t0.Sample(s1, r1_w_3.xxxx);
                float r0_w_8 = (r0_w_7 * r2_xyzw_5.x);
                float4 r0_xyzw_3 = (((i.color0.xyzx * cb0_values[8].xyzx)).xxyz * ((r0_w_8.xxxx * _LightColor0.xyzx)).xxyz);
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                float4 r0_xyzw_5 = ((max(dot(i.texcoord0.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float TEXCOORD0_w_10 = i.texcoord4.x;
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5) * TEXCOORD0_w_10.xxxx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[9];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture3D t1 : register(t1);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program59Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float2 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program59Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program41Output vert(program41Input i)
            {
                program41Output o = (program41Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord2.xyz = (mad(unity_WorldToObject[3].xyzx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyzx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program59Output frag(program59Input i)
            {
                program59Output o = (program59Output)0;
                float r0_w_1 = (unity_ProbeVolumeParams.x == 1);
                float r2_x_10;
                float r2_y_10;
                float r2_z_10;
                float r2_w_4;
                if (r0_w_1)
                {
                    float r0_w_2 = (unity_ProbeVolumeParams.y == 1);
                    float3 r2_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_2.xxxx ? r2_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r2_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r2_y_8 = r2_xyzw_8.y;
                    float r2_z_8 = r2_xyzw_8.z;
                    float r2_w_2 = r2_xyzw_8.w;
                    float r0_w_3 = mad(r2_y_8, 0.25, 0.75);
                    float r1_z_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r2_x_8 = max(r0_w_3, r1_z_1);
                    float4 r2_xyzw_9 = t1.Sample(s0, float4(r2_x_8, r2_z_8, r2_w_2, r2_x_8));
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
                float r0_w_5 = dot(float4(r2_x_10, r2_y_10, r2_z_10, r2_w_4), unity_OcclusionMaskSelector);
                float4 r1_xyzw_5 = t0.Sample(s1, (((mad(cb0_values[6].xyxx, i.texcoord1.zzzz, (mad(cb0_values[4].xyxx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyxx)).xyxx)).xyxx)).xyxx + cb0_values[7].xyxx)).xyxx);
                float r0_w_6 = (r0_w_5 * r1_xyzw_5.w);
                float4 r1_xyzw_6 = (r0_w_6.xxxx * _LightColor0.xyzx);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_6 = r1_xyzw_6.y;
                float r1_z_4 = r1_xyzw_6.z;
                float r0_w_7 = dot(i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx);
                float r0_w_8 = max(r0_w_7, 0);
                o.sv_Target0.xyz = ((r0_w_8.xxxx * ((((i.color0.xyzx * cb0_values[8].xyzx)).xyzx * float4(r1_x_6, r1_y_6, r1_z_4, r1_x_6))).xyzx)).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[9];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            TextureCube t1 : register(t1);
            Texture3D t2 : register(t2);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program58Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program58Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program41Output vert(program41Input i)
            {
                program41Output o = (program41Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord2.xyz = (mad(unity_WorldToObject[3].xyzx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyzx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program58Output frag(program58Input i)
            {
                program58Output o = (program58Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 r2_xyz_4 = (((mad(cb0_values[6].xyzx, i.texcoord1.zzzz, (mad(cb0_values[4].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * cb0_values[5].xyzx)).xyzx)).xyzx)).xyzx + cb0_values[7].xyzx)).xyz;
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r1_w_1);
                    float4 r3_xyzw_9 = t2.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
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
                float r1_w_3 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float4 r3_xyzw_11 = t0.Sample(s2, r1_w_3.xxxx);
                float4 r2_xyzw_5 = t1.Sample(s1, r2_xyz_4.xyzx);
                float r1_w_4 = (r2_xyzw_5.w * r3_xyzw_11.x);
                float r0_w_8 = (r0_w_7 * r1_w_4);
                float4 r0_xyzw_3 = (((i.color0.xyzx * cb0_values[8].xyzx)).xxyz * ((r0_w_8.xxxx * _LightColor0.xyzx)).xxyz);
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                o.sv_Target0.xyz = (((max(dot(i.texcoord0.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3))).xyz;
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4x4 unity_WorldToObject;
                float4 cb0_values[9];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _WorldSpaceLightPos0;
                float4x4 unity_MatrixVP;
                float4 unity_OcclusionMaskSelector;
                float4 cb1_values[47];
            };
            cbuffer cb2 : register(b2)
            {
                float4 unity_ProbeVolumeParams;
                float4x4 unity_ProbeVolumeWorldToObject;
                float3 unity_ProbeVolumeSizeInv;
                float3 unity_ProbeVolumeMin;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            SamplerState s2 : register(s2);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            Texture3D t2 : register(t2);
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program57Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program57Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program41Output vert(program41Input i)
            {
                program41Output o = (program41Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord2.xyz = (mad(unity_WorldToObject[3].xyzx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyzx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord3.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program57Output frag(program57Input i)
            {
                program57Output o = (program57Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float4 r2_xyzw_4 = (mad(cb0_values[6].xyzw, i.texcoord1.zzzz, mad(cb0_values[4].xyzw, i.texcoord1.xxxx, (i.texcoord1.yyyy * cb0_values[5].xyzw))) + cb0_values[7].xyzw);
                float r0_w_3 = (unity_ProbeVolumeParams.x == 1);
                float r3_x_10;
                float r3_y_10;
                float r3_z_10;
                float r3_w_4;
                if (r0_w_3)
                {
                    float r0_w_4 = (unity_ProbeVolumeParams.y == 1);
                    float3 r3_xyz_5 = (((mad(unity_ProbeVolumeWorldToObject[2].xyzx, i.texcoord1.zzzz, (mad(unity_ProbeVolumeWorldToObject[0].xyzx, i.texcoord1.xxxx, ((i.texcoord1.yyyy * unity_ProbeVolumeWorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ProbeVolumeWorldToObject[3].xyzx)).xyz;
                    float3 unity_ProbeVolumeParamsSelect_xyz_6 = ((r0_w_4.xxxx ? r3_xyz_5.xyzx : i.texcoord1.xyzx)).xyz;
                    float4 r3_xyzw_8 = (((unity_ProbeVolumeParamsSelect_xyz_6.xyzx + -unity_ProbeVolumeMin.xyzx)).xxyz * unity_ProbeVolumeSizeInv.xxyz);
                    float r3_y_8 = r3_xyzw_8.y;
                    float r3_z_8 = r3_xyzw_8.z;
                    float r3_w_2 = r3_xyzw_8.w;
                    float r0_w_5 = mad(r3_y_8, 0.25, 0.75);
                    float r1_w_1 = mad(unity_ProbeVolumeParams.z, 0.5, 0.75);
                    float r3_x_8 = max(r0_w_5, r1_w_1);
                    float4 r3_xyzw_9 = t2.Sample(s0, float4(r3_x_8, r3_z_8, r3_w_2, r3_x_8));
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
                float r1_w_3 = (0 < r2_xyzw_4.z);
                float r1_w_4 = asfloat(asint(r1_w_3) & asint(1065353216));
                float4 r3_xyzw_13 = t0.Sample(s1, ((((r2_xyzw_4.xyxx / r2_xyzw_4.wwww)).xyxx + float4(0.5, 0.5, 0, 0))).xyxx);
                float r1_w_5 = (r1_w_4 * r3_xyzw_13.w);
                float4 r2_xyzw_6 = t1.Sample(s2, (dot(r2_xyzw_4.xyzx, r2_xyzw_4.xyzx)).xxxx);
                float r1_w_6 = (r1_w_5 * r2_xyzw_6.x);
                float r0_w_8 = (r0_w_7 * r1_w_6);
                float4 r2_xyzw_7 = (r0_w_8.xxxx * _LightColor0.xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_6 = r2_xyzw_7.y;
                float r2_z_6 = r2_xyzw_7.z;
                float4 r0_xyzw_3 = (((i.color0.xyzx * cb0_values[8].xyzx)).xxyz * float4(r2_x_7, r2_x_7, r2_y_6, r2_z_6));
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_9 = r0_xyzw_3.w;
                o.sv_Target0.xyz = (((max(dot(i.texcoord0.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0)).xxxx * float4(r0_y_3, r0_z_3, r0_w_9, r0_y_3))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="DEFERRED" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 _Tint;
                float4 cb0_values[7];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4x4 unity_MatrixVP;
                float4 cb1_values[21];
            };
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord2 : TEXCOORD2;
            };
            struct program70Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord2 : TEXCOORD2;
            };
            struct program70Output
            {
                float4 sv_Target0 : SV_Target0;
                float4 sv_Target1 : SV_Target1;
                float4 sv_Target2 : SV_Target2;
                float4 sv_Target3 : SV_Target3;
            };
            #pragma vertex vert
            program65Output vert(program65Input i)
            {
                program65Output o = (program65Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord1.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord0.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord2.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program70Output frag(program70Input i)
            {
                program70Output o = (program70Output)0;
                o.sv_Target0.xyz = ((i.color0.xyzx * _Tint.xyzx)).xyz;
                o.sv_Target0.w = 1;
                o.sv_Target1.xyzw = float4(0, 0, 0, 0);
                o.sv_Target2.xyz = (mad(i.texcoord0.xyzx, float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
                o.sv_Target2.w = 1;
                o.sv_Target3.xyzw = float4(1, 1, 1, 1);
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="DEFERRED" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 _Tint;
                float4 cb0_values[46];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 cb2_values[21];
            };
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program73Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program73Output
            {
                float4 sv_Target0 : SV_Target0;
                float4 sv_Target1 : SV_Target1;
                float4 sv_Target2 : SV_Target2;
                float4 sv_Target3 : SV_Target3;
            };
            #pragma vertex vert
            program66Output vert(program66Input i)
            {
                program66Output o = (program66Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                float3 unitWorldNormal_xyz_8 = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.texcoord0.xyz = (unitWorldNormal_xyz_8.xyzx).xyz;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord2.xyzw = float4(0, 0, 0, 0);
                float4 r2_xyzw_1 = (unitWorldNormal_xyz_8.yzzx * unitWorldNormal_xyz_8.xyzz);
                float r3_x_1 = dot(cb0_values[42].xyzw, r2_xyzw_1);
                float r3_y_1 = dot(cb0_values[43].xyzw, r2_xyzw_1);
                float r3_z_1 = dot(cb0_values[44].xyzw, r2_xyzw_1);
                float4 r1_xyzw_4 = mad(cb0_values[45].xyzx, (mad(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.x, (unitWorldNormal_xyz_8.y * unitWorldNormal_xyz_8.y))).xxxx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_2 = r1_xyzw_4.y;
                float r1_z_2 = r1_xyzw_4.z;
                float r0_w_9 = 1;
                float r2_x_2 = dot(cb0_values[39].xyzw, float4(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.y, unitWorldNormal_xyz_8.z, r0_w_9));
                float r2_y_2 = dot(cb0_values[40].xyzw, float4(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.y, unitWorldNormal_xyz_8.z, r0_w_9));
                float r2_z_2 = dot(cb0_values[41].xyzw, float4(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.y, unitWorldNormal_xyz_8.z, r0_w_9));
                float3 r0_xyz_13 = (exp2((((log2((max(((float4(r1_x_4, r1_y_2, r1_z_2, r1_x_4) + float4(r2_x_2, r2_y_2, r2_z_2, r2_x_2))).xyzx, float4(0, 0, 0, 0))).xyzx)).xyzx * float4(0.41666666, 0.41666666, 0.41666666, 0))).xyzx)).xyz;
                o.texcoord3.xyz = (max((mad(r0_xyz_13.xyzx, float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0))).xyzx, float4(0, 0, 0, 0))).xyz;
                return o;
            }
            #pragma fragment frag
            program73Output frag(program73Input i)
            {
                program73Output o = (program73Output)0;
                o.sv_Target0.w = 1;
                float3 r0_xyz_1 = ((i.color0.xyzx * _Tint.xyzx)).xyz;
                o.sv_Target0.xyz = (r0_xyz_1.xyzx).xyz;
                o.sv_Target3.xyz = ((r0_xyz_1.xyzx * i.texcoord3.xyzx)).xyz;
                o.sv_Target1.xyzw = float4(0, 0, 0, 0);
                o.sv_Target2.xyz = (mad(i.texcoord0.xyzx, float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
                o.sv_Target2.w = 1;
                o.sv_Target3.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="DEFERRED" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 _Tint;
                float4 cb0_values[46];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 cb2_values[21];
            };
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program71Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program71Output
            {
                float4 sv_Target0 : SV_Target0;
                float4 sv_Target1 : SV_Target1;
                float4 sv_Target2 : SV_Target2;
                float4 sv_Target3 : SV_Target3;
            };
            #pragma vertex vert
            program66Output vert(program66Input i)
            {
                program66Output o = (program66Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                float3 unitWorldNormal_xyz_8 = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.texcoord0.xyz = (unitWorldNormal_xyz_8.xyzx).xyz;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord2.xyzw = float4(0, 0, 0, 0);
                float4 r2_xyzw_1 = (unitWorldNormal_xyz_8.yzzx * unitWorldNormal_xyz_8.xyzz);
                float r3_x_1 = dot(cb0_values[42].xyzw, r2_xyzw_1);
                float r3_y_1 = dot(cb0_values[43].xyzw, r2_xyzw_1);
                float r3_z_1 = dot(cb0_values[44].xyzw, r2_xyzw_1);
                float4 r1_xyzw_4 = mad(cb0_values[45].xyzx, (mad(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.x, (unitWorldNormal_xyz_8.y * unitWorldNormal_xyz_8.y))).xxxx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_2 = r1_xyzw_4.y;
                float r1_z_2 = r1_xyzw_4.z;
                float r0_w_9 = 1;
                float r2_x_2 = dot(cb0_values[39].xyzw, float4(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.y, unitWorldNormal_xyz_8.z, r0_w_9));
                float r2_y_2 = dot(cb0_values[40].xyzw, float4(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.y, unitWorldNormal_xyz_8.z, r0_w_9));
                float r2_z_2 = dot(cb0_values[41].xyzw, float4(unitWorldNormal_xyz_8.x, unitWorldNormal_xyz_8.y, unitWorldNormal_xyz_8.z, r0_w_9));
                float3 r0_xyz_13 = (exp2((((log2((max(((float4(r1_x_4, r1_y_2, r1_z_2, r1_x_4) + float4(r2_x_2, r2_y_2, r2_z_2, r2_x_2))).xyzx, float4(0, 0, 0, 0))).xyzx)).xyzx * float4(0.41666666, 0.41666666, 0.41666666, 0))).xyzx)).xyz;
                o.texcoord3.xyz = (max((mad(r0_xyz_13.xyzx, float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0))).xyzx, float4(0, 0, 0, 0))).xyz;
                return o;
            }
            #pragma fragment frag
            program71Output frag(program71Input i)
            {
                program71Output o = (program71Output)0;
                o.sv_Target0.w = 1;
                float3 r0_xyz_1 = ((i.color0.xyzx * _Tint.xyzx)).xyz;
                o.sv_Target0.xyz = (r0_xyz_1.xyzx).xyz;
                o.sv_Target3.xyz = (exp2(((r0_xyz_1.xyzx * i.texcoord3.xyzx)).xyzx)).xyz;
                o.sv_Target1.xyzw = float4(0, 0, 0, 0);
                o.sv_Target2.xyz = (mad(i.texcoord0.xyzx, float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
                o.sv_Target2.w = 1;
                o.sv_Target3.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="DEFERRED" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 _Tint;
                float4 cb0_values[7];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4x4 unity_MatrixVP;
                float4 cb1_values[21];
            };
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord2 : TEXCOORD2;
            };
            struct program73Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program73Output
            {
                float4 sv_Target0 : SV_Target0;
                float4 sv_Target1 : SV_Target1;
                float4 sv_Target2 : SV_Target2;
                float4 sv_Target3 : SV_Target3;
            };
            #pragma vertex vert
            program65Output vert(program65Input i)
            {
                program65Output o = (program65Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord1.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord0.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord2.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program73Output frag(program73Input i)
            {
                program73Output o = (program73Output)0;
                o.sv_Target0.w = 1;
                float3 r0_xyz_1 = ((i.color0.xyzx * _Tint.xyzx)).xyz;
                o.sv_Target0.xyz = (r0_xyz_1.xyzx).xyz;
                o.sv_Target3.xyz = ((r0_xyz_1.xyzx * i.texcoord3.xyzx)).xyz;
                o.sv_Target1.xyzw = float4(0, 0, 0, 0);
                o.sv_Target2.xyz = (mad(i.texcoord0.xyzx, float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
                o.sv_Target2.w = 1;
                o.sv_Target3.w = 1;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="DEFERRED" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 _Tint;
                float4 cb0_values[7];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4x4 unity_MatrixVP;
                float4 cb1_values[21];
            };
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord2 : TEXCOORD2;
            };
            struct program72Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord2 : TEXCOORD2;
            };
            struct program72Output
            {
                float4 sv_Target0 : SV_Target0;
                float4 sv_Target1 : SV_Target1;
                float4 sv_Target2 : SV_Target2;
                float4 sv_Target3 : SV_Target3;
            };
            #pragma vertex vert
            program65Output vert(program65Input i)
            {
                program65Output o = (program65Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord1.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord0.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord2.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program72Output frag(program72Input i)
            {
                program72Output o = (program72Output)0;
                o.sv_Target0.xyz = ((i.color0.xyzx * _Tint.xyzx)).xyz;
                o.sv_Target0.w = 1;
                o.sv_Target1.xyzw = float4(0, 0, 0, 0);
                o.sv_Target2.xyz = (mad(i.texcoord0.xyzx, float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
                o.sv_Target2.w = 1;
                o.sv_Target3.xyzw = float4(0, 0, 0, 1);
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="DEFERRED" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 _Tint;
                float4 cb0_values[7];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4x4 unity_MatrixVP;
                float4 cb1_values[21];
            };
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord2 : TEXCOORD2;
            };
            struct program71Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
                float4 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program71Output
            {
                float4 sv_Target0 : SV_Target0;
                float4 sv_Target1 : SV_Target1;
                float4 sv_Target2 : SV_Target2;
                float4 sv_Target3 : SV_Target3;
            };
            #pragma vertex vert
            program65Output vert(program65Input i)
            {
                program65Output o = (program65Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord1.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord0.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord2.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            #pragma fragment frag
            program71Output frag(program71Input i)
            {
                program71Output o = (program71Output)0;
                o.sv_Target0.w = 1;
                float3 r0_xyz_1 = ((i.color0.xyzx * _Tint.xyzx)).xyz;
                o.sv_Target0.xyz = (r0_xyz_1.xyzx).xyz;
                o.sv_Target3.xyz = (exp2(((r0_xyz_1.xyzx * i.texcoord3.xyzx)).xyzx)).xyz;
                o.sv_Target1.xyzw = float4(0, 0, 0, 0);
                o.sv_Target2.xyz = (mad(i.texcoord0.xyzx, float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
                o.sv_Target2.w = 1;
                o.sv_Target3.w = 1;
                return o;
            }
            ENDHLSL
        }
    }
        */
    }
    Fallback "VertexLit"
}
