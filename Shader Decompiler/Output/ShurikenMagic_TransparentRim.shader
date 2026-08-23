Shader "ShurikenMagic/TransparentRim"
{
    Properties
    {
        _RimColor ("Rim Color", Color) = (0.5,0.5,0.5,0.5)
        _InnerColor ("Inner Color", Color) = (0.5,0.5,0.5,0.5)
        _InnerColorPower ("Inner Color Power", Range(0, 1)) = 0.5
        _RimPower ("Rim Power", Range(0, 5)) = 2.5
        _AlphaPower ("Alpha Rim Power", Range(0, 8)) = 4
        _AllPower ("All Power", Range(0, 10)) = 1
    }
    SubShader
    {
        Tags { "QUEUE"="Transparent" }
        LOD 0
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcColor
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 _RimColor;
                float _RimPower;
                float _AlphaPower;
                float _InnerColorPower;
                float _AllPower;
                float4 _InnerColor;
                float4 cb0_values[6];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
            };
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
            };
            struct program14Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
            };
            struct program14Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program6Output vert(program6Input i)
            {
                program6Output o = (program6Output)0;
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
                return o;
            }
            #pragma fragment frag
            program14Output frag(program14Input i)
            {
                program14Output o = (program14Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float3 unitViewDir_xyz_2 = normalize(viewDir_xyz_1);
                float4 r0_xyzw_6 = ((log2((dot(unitViewDir_xyz_2.xyzx, i.texcoord0.xyzx) + 1))).xxxx * cb0_values[5].xyxx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_3 = r0_xyzw_6.y;
                float4 r0_xyzw_7 = exp2(float4(r0_x_6, r0_y_3, r0_x_6, r0_x_6));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_4 = r0_xyzw_7.y;
                float4 r0_xyzw_8 = (r0_x_7.xxxx * _RimColor.xxyz);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_z_3 = r0_xyzw_8.z;
                float r0_w_3 = r0_xyzw_8.w;
                o.sv_Target0.w = (r0_y_4 * _AllPower);
                float3 r1_xyz_1 = ((_InnerColorPower.xxxx * _InnerColor.xyzx)).xyz;
                o.sv_Target0.xyz = (mad(float4(r0_x_8, r0_z_3, r0_w_3, r0_x_8), _AllPower.xxxx, ((r1_xyz_1.xyzx + r1_xyz_1.xyzx)).xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcColor
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 _RimColor;
                float _RimPower;
                float _AlphaPower;
                float _InnerColorPower;
                float _AllPower;
                float4 _InnerColor;
                float4 cb0_values[6];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[46];
            };
            cbuffer cb2 : register(b2)
            {
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
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program17Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program17Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program10Output vert(program10Input i)
            {
                program10Output o = (program10Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                o.texcoord1.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
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
                return o;
            }
            #pragma fragment frag
            program17Output frag(program17Input i)
            {
                program17Output o = (program17Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float3 unitViewDir_xyz_2 = normalize(viewDir_xyz_1);
                float4 r0_xyzw_6 = ((log2((dot(unitViewDir_xyz_2.xyzx, i.texcoord0.xyzx) + 1))).xxxx * cb0_values[5].xyxx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_3 = r0_xyzw_6.y;
                float4 r0_xyzw_7 = exp2(float4(r0_x_6, r0_y_3, r0_x_6, r0_x_6));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_4 = r0_xyzw_7.y;
                float4 r0_xyzw_8 = (r0_x_7.xxxx * _RimColor.xxyz);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_z_3 = r0_xyzw_8.z;
                float r0_w_3 = r0_xyzw_8.w;
                o.sv_Target0.w = (r0_y_4 * _AllPower);
                float3 r1_xyz_1 = ((_InnerColorPower.xxxx * _InnerColor.xyzx)).xyz;
                float4 r0_xyzw_9 = mad(float4(r0_x_8, r0_z_3, r0_w_3, r0_x_8), _AllPower.xxxx, ((r1_xyz_1.xyzx + r1_xyz_1.xyzx)).xyzx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_5 = r0_xyzw_9.y;
                float r0_z_4 = r0_xyzw_9.z;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_y_5, r0_z_4, r0_x_9) + -cb2_values[0].xyzx);
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_6 = r0_xyzw_10.y;
                float r0_z_5 = r0_xyzw_10.z;
                float TEXCOORD0_w_4 = i.texcoord3.x;
                o.sv_Target0.xyz = (mad(TEXCOORD0_w_4.xxxx, float4(r0_x_10, r0_y_6, r0_z_5, r0_x_10), cb2_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcColor
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 _RimColor;
                float _RimPower;
                float _AlphaPower;
                float _InnerColorPower;
                float _AllPower;
                float4 _InnerColor;
                float4 cb0_values[6];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 cb2_values[21];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[2];
            };
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
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
            };
            struct program16Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
            };
            struct program16Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program9Output vert(program9Input i)
            {
                program9Output o = (program9Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                o.texcoord3.x = mad(max((((clipPos_xyzw_7.z / unity_WorldToObject[1].y) + 1) * unity_WorldToObject[1].z), 0), cb3_values[1].z, cb3_values[1].w);
                float worldNormal_x_12 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12), float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord0.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_12, worldNormal_y_8, worldNormal_z_8, worldNormal_x_12))).xyz;
                return o;
            }
            #pragma fragment frag
            program16Output frag(program16Input i)
            {
                program16Output o = (program16Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float3 unitViewDir_xyz_2 = normalize(viewDir_xyz_1);
                float4 r0_xyzw_6 = ((log2((dot(unitViewDir_xyz_2.xyzx, i.texcoord0.xyzx) + 1))).xxxx * cb0_values[5].xyxx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_3 = r0_xyzw_6.y;
                float4 r0_xyzw_7 = exp2(float4(r0_x_6, r0_y_3, r0_x_6, r0_x_6));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_4 = r0_xyzw_7.y;
                float4 r0_xyzw_8 = (r0_x_7.xxxx * _RimColor.xxyz);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_z_3 = r0_xyzw_8.z;
                float r0_w_3 = r0_xyzw_8.w;
                o.sv_Target0.w = (r0_y_4 * _AllPower);
                float3 r1_xyz_1 = ((_InnerColorPower.xxxx * _InnerColor.xyzx)).xyz;
                float4 r0_xyzw_9 = mad(float4(r0_x_8, r0_z_3, r0_w_3, r0_x_8), _AllPower.xxxx, ((r1_xyz_1.xyzx + r1_xyz_1.xyzx)).xyzx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_5 = r0_xyzw_9.y;
                float r0_z_4 = r0_xyzw_9.z;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_y_5, r0_z_4, r0_x_9) + -cb2_values[0].xyzx);
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_6 = r0_xyzw_10.y;
                float r0_z_5 = r0_xyzw_10.z;
                float TEXCOORD0_w_4 = i.texcoord3.x;
                o.sv_Target0.xyz = (mad(TEXCOORD0_w_4.xxxx, float4(r0_x_10, r0_y_6, r0_z_5, r0_x_10), cb2_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcColor
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 _RimColor;
                float _RimPower;
                float _AlphaPower;
                float _InnerColorPower;
                float _AllPower;
                float4 _InnerColor;
                float4 cb0_values[46];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 cb2_values[21];
            };
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
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program15Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program15Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program7Output vert(program7Input i)
            {
                program7Output o = (program7Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                float3 unitWorldNormal_xyz_8 = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                o.texcoord0.xyz = unitWorldNormal_xyz_8.xyz;
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
                                float3 r0_xyz_13 = (pow(max((float4(r1_x_4, r1_y_2, r1_z_2, r1_x_4) + float4(r2_x_2, r2_y_2, r2_z_2, r2_x_2)).xyz, float3(0, 0, 0)), float3(0.41666666, 0.41666666, 0.41666666)));
                o.texcoord2.xyz = (max((mad(r0_xyz_13.xyzx, float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0))).xyzx, float4(0, 0, 0, 0))).xyz;
                return o;
            }
            #pragma fragment frag
            program15Output frag(program15Input i)
            {
                program15Output o = (program15Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float3 unitViewDir_xyz_2 = normalize(viewDir_xyz_1);
                float4 r0_xyzw_6 = ((log2((dot(unitViewDir_xyz_2.xyzx, i.texcoord0.xyzx) + 1))).xxxx * cb0_values[5].xyxx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_3 = r0_xyzw_6.y;
                float4 r0_xyzw_7 = exp2(float4(r0_x_6, r0_y_3, r0_x_6, r0_x_6));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_4 = r0_xyzw_7.y;
                float4 r0_xyzw_8 = (r0_x_7.xxxx * _RimColor.xxyz);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_z_3 = r0_xyzw_8.z;
                float r0_w_3 = r0_xyzw_8.w;
                o.sv_Target0.w = (r0_y_4 * _AllPower);
                float3 r1_xyz_1 = ((_InnerColorPower.xxxx * _InnerColor.xyzx)).xyz;
                o.sv_Target0.xyz = (mad(float4(r0_x_8, r0_z_3, r0_w_3, r0_x_8), _AllPower.xxxx, ((r1_xyz_1.xyzx + r1_xyz_1.xyzx)).xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 _RimColor;
                float _RimPower;
                float _AlphaPower;
                float _InnerColorPower;
                float _AllPower;
                float4 _InnerColor;
                float4 cb0_values[11];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 cb2_values[21];
            };
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
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program30Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program30Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program20Output vert(program20Input i)
            {
                program20Output o = (program20Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = (mad(unity_WorldToObject[3].xyzx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyzx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program30Output frag(program30Input i)
            {
                program30Output o = (program30Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float3 unitViewDir_xyz_2 = normalize(viewDir_xyz_1);
                                o.sv_Target0.w = (pow((dot(unitViewDir_xyz_2.xyzx, i.texcoord0.xyzx) + 1), cb0_values[9].y) * cb0_values[10].x);
                o.sv_Target0.xyz = (float4(0, 0, 0, 0)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 _RimColor;
                float _RimPower;
                float _AlphaPower;
                float _InnerColorPower;
                float _AllPower;
                float4 _InnerColor;
                float4 cb0_values[11];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[6];
            };
            cbuffer cb2 : register(b2)
            {
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
            struct program27Input
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
            struct program27Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float texcoord3 : TEXCOORD3;
            };
            struct program39Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float texcoord3 : TEXCOORD3;
            };
            struct program39Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program27Output vert(program27Input i)
            {
                program27Output o = (program27Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord3.x = mad(max((((clipPos_xyzw_2.z / cb1_values[5].y) + 1) * cb1_values[5].z), 0), cb4_values[1].z, cb4_values[1].w);
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord0.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7))).xyz;
                o.texcoord1.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 r1_xyzw_8 = (r0_xyzw_4.yyyy * unity_WorldToObject[1].xyxx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_4 = r1_xyzw_8.y;
                o.texcoord2.xy = (mad(unity_WorldToObject[3].xyxx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyxx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyxx, r0_xyzw_4.xxxx, float4(r1_x_8, r1_y_4, r1_x_8, r1_x_8))).xyxx)).xyxx)).xy;
                return o;
            }
            #pragma fragment frag
            program39Output frag(program39Input i)
            {
                program39Output o = (program39Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float3 unitViewDir_xyz_2 = normalize(viewDir_xyz_1);
                                o.sv_Target0.w = (pow((dot(unitViewDir_xyz_2.xyzx, i.texcoord0.xyzx) + 1), cb0_values[9].y) * cb0_values[10].x);
                o.sv_Target0.xyz = (float4(0, 0, 0, 0)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 _RimColor;
                float _RimPower;
                float _AlphaPower;
                float _InnerColorPower;
                float _AllPower;
                float4 _InnerColor;
                float4 cb0_values[11];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[6];
            };
            cbuffer cb2 : register(b2)
            {
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
            struct program25Input
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
            struct program25Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
            };
            struct program37Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
            };
            struct program37Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program25Output vert(program25Input i)
            {
                program25Output o = (program25Output)0;
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb2_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord3.x = mad(max((((clipPos_xyzw_2.z / cb1_values[5].y) + 1) * cb1_values[5].z), 0), cb4_values[1].z, cb4_values[1].w);
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord0.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7))).xyz;
                o.texcoord1.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 r1_xyzw_8 = (r0_xyzw_4.yyyy * unity_WorldToObject[1]);
                float4 r1_xyzw_9 = mad(unity_WorldToObject[0], r0_xyzw_4.xxxx, r1_xyzw_8);
                float4 r1_xyzw_10 = mad(unity_WorldToObject[2], r0_xyzw_4.zzzz, r1_xyzw_9);
                o.texcoord2.xyzw = mad(unity_WorldToObject[3], r0_xyzw_4.wwww, r1_xyzw_10);
                return o;
            }
            #pragma fragment frag
            program37Output frag(program37Input i)
            {
                program37Output o = (program37Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float3 unitViewDir_xyz_2 = normalize(viewDir_xyz_1);
                                o.sv_Target0.w = (pow((dot(unitViewDir_xyz_2.xyzx, i.texcoord0.xyzx) + 1), cb0_values[9].y) * cb0_values[10].x);
                o.sv_Target0.xyz = (float4(0, 0, 0, 0)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 _RimColor;
                float _RimPower;
                float _AlphaPower;
                float _InnerColorPower;
                float _AllPower;
                float4 _InnerColor;
                float4 cb0_values[11];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[6];
            };
            cbuffer cb2 : register(b2)
            {
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
                float3 texcoord2 : TEXCOORD2;
            };
            struct program35Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program35Output
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
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_1.zzzz, mad(cb3_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(cb3_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = mul(float4x4(cb3_values[17], cb3_values[18], cb3_values[19], cb3_values[20]), worldPos_xyzw_1);
                o.texcoord3.x = mad(max((((clipPos_xyzw_2.z / cb1_values[5].y) + 1) * cb1_values[5].z), 0), cb4_values[1].z, cb4_values[1].w);
                float worldNormal_x_7 = dot(i.normal0.xyzx, cb2_values[4].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, cb2_values[5].xyzx);
                float worldNormal_z_3 = dot(i.normal0.xyzx, cb2_values[6].xyzx);
                float r1_w_3 = dot(float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7));
                float r1_w_4 = rsqrt(r1_w_3);
                o.texcoord0.xyz = ((r1_w_4.xxxx * float4(worldNormal_x_7, worldNormal_y_3, worldNormal_z_3, worldNormal_x_7))).xyz;
                o.texcoord1.xyz = (mad(cb2_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb2_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 r1_xyzw_8 = (r0_xyzw_4.yyyy * unity_WorldToObject[1].xyzx);
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_4 = r1_xyzw_8.y;
                float r1_z_4 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = mad(unity_WorldToObject[0].xyzx, r0_xyzw_4.xxxx, float4(r1_x_8, r1_y_4, r1_z_4, r1_x_8));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_5 = r1_xyzw_9.y;
                float r1_z_5 = r1_xyzw_9.z;
                o.texcoord2.xyz = (mad(unity_WorldToObject[3].xyzx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyzx, r0_xyzw_4.zzzz, float4(r1_x_9, r1_y_5, r1_z_5, r1_x_9))).xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program35Output frag(program35Input i)
            {
                program35Output o = (program35Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float3 unitViewDir_xyz_2 = normalize(viewDir_xyz_1);
                                o.sv_Target0.w = (pow((dot(unitViewDir_xyz_2.xyzx, i.texcoord0.xyzx) + 1), cb0_values[9].y) * cb0_values[10].x);
                o.sv_Target0.xyz = (float4(0, 0, 0, 0)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 _RimColor;
                float _RimPower;
                float _AlphaPower;
                float _InnerColorPower;
                float _AllPower;
                float4 _InnerColor;
                float4 cb0_values[11];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 cb2_values[21];
            };
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
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct program33Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program33Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program23Output vert(program23Input i)
            {
                program23Output o = (program23Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xy = (mad(unity_WorldToObject[3].xyxx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyxx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyxx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyxx)).xyxx)).xyxx)).xyxx)).xy;
                return o;
            }
            #pragma fragment frag
            program33Output frag(program33Input i)
            {
                program33Output o = (program33Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float3 unitViewDir_xyz_2 = normalize(viewDir_xyz_1);
                                o.sv_Target0.w = (pow((dot(unitViewDir_xyz_2.xyzx, i.texcoord0.xyzx) + 1), cb0_values[9].y) * cb0_values[10].x);
                o.sv_Target0.xyz = (float4(0, 0, 0, 0)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 _RimColor;
                float _RimPower;
                float _AlphaPower;
                float _InnerColorPower;
                float _AllPower;
                float4 _InnerColor;
                float4 cb0_values[11];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 cb2_values[21];
            };
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
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program34Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct program34Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program22Output vert(program22Input i)
            {
                program22Output o = (program22Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                o.texcoord2.xyz = (mad(unity_WorldToObject[3].xyzx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[2].xyzx, r0_xyzw_4.zzzz, (mad(unity_WorldToObject[0].xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_WorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program34Output frag(program34Input i)
            {
                program34Output o = (program34Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float3 unitViewDir_xyz_2 = normalize(viewDir_xyz_1);
                                o.sv_Target0.w = (pow((dot(unitViewDir_xyz_2.xyzx, i.texcoord0.xyzx) + 1), cb0_values[9].y) * cb0_values[10].x);
                o.sv_Target0.xyz = (float4(0, 0, 0, 0)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 _RimColor;
                float _RimPower;
                float _AlphaPower;
                float _InnerColorPower;
                float _AllPower;
                float4 _InnerColor;
                float4 cb0_values[11];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 cb2_values[21];
            };
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
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
            };
            struct program32Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float3 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
            };
            struct program32Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program21Output vert(program21Input i)
            {
                program21Output o = (program21Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord0.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord1.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 r1_xyzw_3 = (r0_xyzw_4.yyyy * unity_WorldToObject[1]);
                float4 r1_xyzw_4 = mad(unity_WorldToObject[0], r0_xyzw_4.xxxx, r1_xyzw_3);
                float4 r1_xyzw_5 = mad(unity_WorldToObject[2], r0_xyzw_4.zzzz, r1_xyzw_4);
                o.texcoord2.xyzw = mad(unity_WorldToObject[3], r0_xyzw_4.wwww, r1_xyzw_5);
                return o;
            }
            #pragma fragment frag
            program32Output frag(program32Input i)
            {
                program32Output o = (program32Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord1.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float3 unitViewDir_xyz_2 = normalize(viewDir_xyz_1);
                                o.sv_Target0.w = (pow((dot(unitViewDir_xyz_2.xyzx, i.texcoord0.xyzx) + 1), cb0_values[9].y) * cb0_values[10].x);
                o.sv_Target0.xyz = (float4(0, 0, 0, 0)).xyz;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "VertexLit"
}
