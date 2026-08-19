Shader "Toon/Basic Outline"
{
    Properties
    {
        _Color ("Main Color", Color) = (0.5,0.5,0.5,1)
        _OutlineColor ("Outline Color", Color) = (0,0,0,1)
        _Outline ("Outline width", Range(0.002, 0.03)) = 0.005
        _MainTex ("Base (RGB)", 2D) = "" {}
        _ToonShade ("ToonShader Cubemap(RGB)", 2D) = "" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 0
        Pass
        {
            Cull Off
            ZTest Disabled
            ZWrite Off
            Stencil
            {
                Ref 0
                ReadMask 0
                WriteMask 0
                Comp Disabled
                Pass Keep
                Fail Keep
                ZFail Keep
            }
            HLSLPROGRAM
            cbuffer cb0 : register(b0)
            {
                float4 cb0_values[4];
            };
            cbuffer cb1 : register(b1)
            {
                float4 cb1_values[8];
            };
            cbuffer cb2 : register(b2)
            {
                float4 cb2_values[21];
            };
            struct program2Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
            };
            struct program2Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 color0 : COLOR0;
            };
            struct program6Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 color0 : COLOR0;
            };
            struct program6Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program2Output vert(program2Input i)
            {
                program2Output o = (program2Output)0;
                float3 r0_xyz_4 = (mad(cb1_values[7].xyzx, cb2_values[15].wwww, (mad(cb1_values[6].xyzx, cb2_values[15].zzzz, (mad(cb1_values[4].xyzx, cb2_values[15].xxxx, ((cb1_values[5].xyzx * cb2_values[15].yyyy)).xyzx)).xyzx)).xyzx)).xyz;
                float r0_z_5 = dot(r0_xyz_4.xyzx, i.normal0.xyzx);
                float3 r1_xyz_4 = (mad(cb1_values[7].xyzx, cb2_values[13].wwww, (mad(cb1_values[6].xyzx, cb2_values[13].zzzz, (mad(cb1_values[4].xyzx, cb2_values[13].xxxx, ((cb1_values[5].xyzx * cb2_values[13].yyyy)).xyzx)).xyzx)).xyzx)).xyz;
                float r0_x_5 = dot(r1_xyz_4.xyzx, i.normal0.xyzx);
                float3 r1_xyz_8 = (mad(cb1_values[7].xyzx, cb2_values[14].wwww, (mad(cb1_values[6].xyzx, cb2_values[14].zzzz, (mad(cb1_values[4].xyzx, cb2_values[14].xxxx, ((cb1_values[5].xyzx * cb2_values[14].yyyy)).xyzx)).xyzx)).xyzx)).xyz;
                float r0_y_5 = dot(r1_xyz_8.xyzx, i.normal0.xyzx);
                float r0_z_6 = dot(float4(r0_x_5, r0_y_5, r0_z_5, r0_x_5), float4(r0_x_5, r0_y_5, r0_z_5, r0_x_5));
                float r0_z_7 = rsqrt(r0_z_6);
                float2 r0_xy_6 = ((r0_z_7.xxxx * float4(r0_x_5, r0_y_5, r0_x_5, r0_x_5))).xy;
                float4 r0_xyzw_7 = (r0_xy_6.yyyy * cb2_values[6].xxyx);
                float r0_y_7 = r0_xyzw_7.y;
                float r0_z_8 = r0_xyzw_7.z;
                float r0_x_7 = (mad(cb2_values[5].xyxx, r0_xy_6.xxxx, float4(r0_y_7, r0_z_8, r0_y_7, r0_y_7))).x;
                float r0_y_8 = (mad(cb2_values[5].xyxx, r0_xy_6.xxxx, float4(r0_y_7, r0_z_8, r0_y_7, r0_y_7))).y;
                float4 worldPos_xyzw_9 = (i.position0.yyyy * cb1_values[1].xyzw);
                float4 worldPos_xyzw_10 = mad(cb1_values[0].xyzw, i.position0.xxxx, worldPos_xyzw_9);
                float4 worldPos_xyzw_11 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_10);
                float4 worldPos_xyzw_12 = (worldPos_xyzw_11 + cb1_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_12.yyyy * cb2_values[18].xyzw);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_12.xxxx, clipPos_xyzw_1);
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_12.zzzz, clipPos_xyzw_2);
                float4 clipPos_xyzw_13 = mad(cb2_values[20].xyzw, worldPos_xyzw_12.wwww, clipPos_xyzw_3);
                float4 r0_xyzw_8 = (float4(r0_x_7, r0_y_8, r0_x_7, r0_x_7) * clipPos_xyzw_13.zzzz);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_9 = r0_xyzw_8.y;
                o.sv_Position0.xy = (mad(float4(r0_x_8, r0_y_9, r0_x_8, r0_x_8), cb0_values[2].xxxx, clipPos_xyzw_13.xyxx)).xy;
                o.sv_Position0.zw = (clipPos_xyzw_13.zzzw).zw;
                o.color0.xyzw = cb0_values[3].xyzw;
                return o;
            }
            #pragma fragment frag
            program6Output frag(program6Input i)
            {
                program6Output o = (program6Output)0;
                o.sv_Target0.xyzw = i.color0.xyzw;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Cull Off
            ZTest Disabled
            ZWrite Off
            Stencil
            {
                Ref 0
                ReadMask 0
                WriteMask 0
                Comp Disabled
                Pass Keep
                Fail Keep
                ZFail Keep
            }
            HLSLPROGRAM
            cbuffer cb0 : register(b0)
            {
                float4 cb0_values[4];
            };
            cbuffer cb1 : register(b1)
            {
                float4 cb1_values[6];
            };
            cbuffer cb2 : register(b2)
            {
                float4 cb2_values[8];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[21];
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[2];
            };
            struct program3Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
            };
            struct program3Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float texcoord0 : TEXCOORD0;
                float4 color0 : COLOR0;
            };
            struct program7Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float texcoord0 : TEXCOORD0;
                float4 color0 : COLOR0;
            };
            struct program7Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program3Output vert(program3Input i)
            {
                program3Output o = (program3Output)0;
                float3 r0_xyz_4 = (mad(cb2_values[7].xyzx, cb3_values[15].wwww, (mad(cb2_values[6].xyzx, cb3_values[15].zzzz, (mad(cb2_values[4].xyzx, cb3_values[15].xxxx, ((cb2_values[5].xyzx * cb3_values[15].yyyy)).xyzx)).xyzx)).xyzx)).xyz;
                float r0_z_5 = dot(r0_xyz_4.xyzx, i.normal0.xyzx);
                float3 r1_xyz_4 = (mad(cb2_values[7].xyzx, cb3_values[13].wwww, (mad(cb2_values[6].xyzx, cb3_values[13].zzzz, (mad(cb2_values[4].xyzx, cb3_values[13].xxxx, ((cb2_values[5].xyzx * cb3_values[13].yyyy)).xyzx)).xyzx)).xyzx)).xyz;
                float r0_x_5 = dot(r1_xyz_4.xyzx, i.normal0.xyzx);
                float3 r1_xyz_8 = (mad(cb2_values[7].xyzx, cb3_values[14].wwww, (mad(cb2_values[6].xyzx, cb3_values[14].zzzz, (mad(cb2_values[4].xyzx, cb3_values[14].xxxx, ((cb2_values[5].xyzx * cb3_values[14].yyyy)).xyzx)).xyzx)).xyzx)).xyz;
                float r0_y_5 = dot(r1_xyz_8.xyzx, i.normal0.xyzx);
                float r0_z_6 = dot(float4(r0_x_5, r0_y_5, r0_z_5, r0_x_5), float4(r0_x_5, r0_y_5, r0_z_5, r0_x_5));
                float r0_z_7 = rsqrt(r0_z_6);
                float2 r0_xy_6 = ((r0_z_7.xxxx * float4(r0_x_5, r0_y_5, r0_x_5, r0_x_5))).xy;
                float4 r0_xyzw_7 = (r0_xy_6.yyyy * cb3_values[6].xxyx);
                float r0_y_7 = r0_xyzw_7.y;
                float r0_z_8 = r0_xyzw_7.z;
                float r0_x_7 = (mad(cb3_values[5].xyxx, r0_xy_6.xxxx, float4(r0_y_7, r0_z_8, r0_y_7, r0_y_7))).x;
                float r0_y_8 = (mad(cb3_values[5].xyxx, r0_xy_6.xxxx, float4(r0_y_7, r0_z_8, r0_y_7, r0_y_7))).y;
                float4 worldPos_xyzw_9 = (i.position0.yyyy * cb2_values[1].xyzw);
                float4 worldPos_xyzw_10 = mad(cb2_values[0].xyzw, i.position0.xxxx, worldPos_xyzw_9);
                float4 worldPos_xyzw_11 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_10);
                float4 worldPos_xyzw_12 = (worldPos_xyzw_11 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_12.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_2 = mad(cb3_values[17].xyzw, worldPos_xyzw_12.xxxx, clipPos_xyzw_1);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_12.zzzz, clipPos_xyzw_2);
                float4 clipPos_xyzw_13 = mad(cb3_values[20].xyzw, worldPos_xyzw_12.wwww, clipPos_xyzw_3);
                float4 r0_xyzw_8 = (float4(r0_x_7, r0_y_8, r0_x_7, r0_x_7) * clipPos_xyzw_13.zzzz);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_9 = r0_xyzw_8.y;
                o.sv_Position0.xy = (mad(float4(r0_x_8, r0_y_9, r0_x_8, r0_x_8), cb0_values[2].xxxx, clipPos_xyzw_13.xyxx)).xy;
                o.sv_Position0.zw = (clipPos_xyzw_13.zzzw).zw;
                o.texcoord0.x = mad(max((((clipPos_xyzw_13.z / cb1_values[5].y) + 1) * cb1_values[5].z), 0), cb4_values[1].z, cb4_values[1].w);
                o.color0.xyzw = cb0_values[3].xyzw;
                return o;
            }
            #pragma fragment frag
            program7Output frag(program7Input i)
            {
                program7Output o = (program7Output)0;
                float TEXCOORD0_x_1 = i.texcoord0.x;
                float3 r0_yzw_1 = ((i.color0.xxyz + -cb0_values[0].xxyz)).yzw;
                o.sv_Target0.xyz = (mad(TEXCOORD0_x_1.xxxx, r0_yzw_1.xyzx, cb0_values[0].xyzx)).xyz;
                o.sv_Target0.w = i.color0.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="ALWAYS" "RenderType"="Opaque" }
            Cull Front
            ZTest LEqual
            ZWrite On
            Blend SrcAlpha OneMinusSrcColor
            HLSLPROGRAM
            ENDHLSL
        }
    }
    Fallback "Toon/Basic"
}
