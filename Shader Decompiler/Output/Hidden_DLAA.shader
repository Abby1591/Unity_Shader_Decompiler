Shader "Hidden/DLAA"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "" {}
    }
    SubShader
    {
        LOD 0
        Pass
        {
            Cull Off
            ZTest Always
            ZWrite Off
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _MainTex_TexelSize;
                float4 cb0_values[4];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4x4 unity_MatrixVP;
                float4 cb1_values[21];
            };
            SamplerState s0 : register(s0);
            Texture2D t0 : register(t0);
            struct program1Input
            {
                float4 position0 : POSITION0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program1Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program3Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program1Output vert(program1Input i)
            {
                program1Output o = (program1Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_4 = UnityObjectToWorldPos(i.position0.xyz);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_4);
                o.texcoord0.xy = (i.texcoord0.xyxx).xy;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float4 r0_xyzw_2 = t0.Sample(s0, ((i.texcoord0.xyxx + -_MainTex_TexelSize.xyxx)).xyxx);
                float4 r1_xyzw_1 = mad(_MainTex_TexelSize.xyxy, float4(1, -1, -1, 1), i.texcoord0.xyxy);
                float4 r2_xyzw_1 = t0.Sample(s0, r1_xyzw_1.xyxx);
                float4 r1_xyzw_2 = t0.Sample(s0, r1_xyzw_1.zwzz);
                float4 r0_xyzw_3 = (r0_xyzw_2.xyzx + r2_xyzw_1.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_2 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = (r1_xyzw_2.xyzx + float4(r0_x_3, r0_y_3, r0_z_2, r0_x_3));
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_4 = r0_xyzw_4.y;
                float r0_z_3 = r0_xyzw_4.z;
                float4 r1_xyzw_4 = t0.Sample(s0, ((i.texcoord0.xyxx + _MainTex_TexelSize.xyxx)).xyxx);
                float4 r0_xyzw_5 = (float4(r0_x_4, r0_y_4, r0_z_3, r0_x_4) + r1_xyzw_4.xyzx);
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_5 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float4 r1_xyzw_5 = t0.Sample(s0, i.texcoord0.xyxx);
                float4 r0_xyzw_6 = mad(-r1_xyzw_5.xyzx, float4(4, 4, 4, 0), float4(r0_x_5, r0_y_5, r0_z_4, r0_x_5));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_6 = r0_xyzw_6.y;
                float r0_z_5 = r0_xyzw_6.z;
                o.sv_Target0.xyz = (r1_xyzw_5.xyzx).xyz;
                float4 r0_xyzw_7 = (abs(float4(r0_x_6, r0_y_6, r0_z_5, r0_x_6)) * float4(4, 4, 4, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_7 = r0_xyzw_7.y;
                float r0_z_6 = r0_xyzw_7.z;
                o.sv_Target0.w = dot(float4(r0_x_7, r0_y_7, r0_z_6, r0_x_7), float4(0.33, 0.33, 0.33, 0));
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Cull Off
            ZTest Always
            ZWrite Off
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _MainTex_TexelSize;
                float4 cb0_values[4];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4x4 unity_MatrixVP;
                float4 cb1_values[21];
            };
            SamplerState s0 : register(s0);
            Texture2D t0 : register(t0);
            struct program1Input
            {
                float4 position0 : POSITION0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program1Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program5Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program5Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program1Output vert(program1Input i)
            {
                program1Output o = (program1Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_4 = UnityObjectToWorldPos(i.position0.xyz);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_4);
                o.texcoord0.xy = (i.texcoord0.xyxx).xy;
                return o;
            }
            #pragma fragment frag
            program5Output frag(program5Input i)
            {
                program5Output o = (program5Output)0;
                float4 r0_xyzw_1 = mad(_MainTex_TexelSize.xyxy, float4(0, 3.5, 0, 5.5), i.texcoord0.xyxy);
                float4 r1_xyzw_1 = t0.Sample(s0, r0_xyzw_1.zwzz);
                float4 r0_xyzw_2 = t0.Sample(s0, r0_xyzw_1.xyxx);
                float4 r2_xyzw_1 = mad(_MainTex_TexelSize.xyxy, float4(0, -1.5, 0, 1.5), i.texcoord0.xyxy);
                float4 r3_xyzw_1 = t0.Sample(s0, r2_xyzw_1.zwzz);
                float4 r2_xyzw_2 = t0.Sample(s0, r2_xyzw_1.xyxx);
                float4 r1_xyzw_2 = mad(_MainTex_TexelSize.xyxy, float4(0, 7.5, 0, -3.5), i.texcoord0.xyxy);
                float4 r4_xyzw_1 = t0.Sample(s0, r1_xyzw_2.xyxx);
                float4 r1_xyzw_3 = t0.Sample(s0, r1_xyzw_2.zwzz);
                float4 r1_xyzw_4 = mad(_MainTex_TexelSize.xyxy, float4(0, -5.5, 0, -7.5), i.texcoord0.xyxy);
                float4 r2_xyzw_3 = t0.Sample(s0, r1_xyzw_4.xyxx);
                float4 r1_xyzw_5 = t0.Sample(s0, r1_xyzw_4.zwzz);
                float4 r0_xyzw_9 = (r1_xyzw_5.wxyz + ((r1_xyzw_3.wxyz + (r2_xyzw_2.wxyz + ((r1_xyzw_1.wxyz + (r0_xyzw_2.wxyz + r3_xyzw_1.wxyz)) + r4_xyzw_1.wxyz))) + r2_xyzw_3.wxyz));
                float3 r0_yzw_10 = ((r0_xyzw_9.yyzw * float4(0, 0.125, 0.125, 0.125))).yzw;
                float r0_x_10 = mad(r0_xyzw_9.x, 0.25, -1);
                float r0_y_11 = dot(r0_yzw_10.xyzx, float4(0.33, 0.33, 0.33, 0));
                float4 r1_xyzw_6 = mad(_MainTex_TexelSize.xyxy, float4(-1, 0, 1, 0), i.texcoord0.xyxy);
                float4 r2_xyzw_4 = t0.Sample(s0, r1_xyzw_6.xyxx);
                float4 r1_xyzw_7 = t0.Sample(s0, r1_xyzw_6.zwzz);
                float r0_z_11 = dot(r2_xyzw_4.xyzx, float4(0.33, 0.33, 0.33, 0));
                float r0_w_11 = (-r0_z_11 + r0_y_11);
                float4 r4_xyzw_2 = t0.Sample(s0, i.texcoord0.xyxx);
                float r5_x_1 = dot(r4_xyzw_2.xyzx, float4(0.33, 0.33, 0.33, 0));
                float r5_y_1 = (-r0_z_11 + r5_x_1);
                float r0_z_12 = (r0_z_11 == r5_x_1);
                float r0_w_12 = (r0_w_11 / r5_y_1);
                float r0_z_13 = (r0_z_12 ? 0 : r0_w_12);
                float r0_z_14 = dot((((mad(-r4_xyzw_2.xyzx, float4(2, 2, 2, 0), ((r1_xyzw_7.xyzx + r2_xyzw_4.xyzx)).xyzx)).xyzx * float4(0.5, 0.5, 0.5, 0))).xyzx, float4(0.33, 0.33, 0.33, 0));
                float r0_z_15 = mad(r0_z_14, 3, -0.1);
                float4 r2_xyzw_8 = (-r1_xyzw_7 + mad(r0_z_13.xxxx, (-r2_xyzw_4 + r4_xyzw_2), r2_xyzw_4));
                float r0_y_12 = (r0_y_11 + -r5_x_1);
                float r0_w_13 = dot(r1_xyzw_7.xyzx, float4(0.33, 0.33, 0.33, 0));
                float r5_y_2 = (-r0_w_13 + r5_x_1);
                float r0_w_14 = (r0_w_13 == r5_x_1);
                float r0_y_13 = (r0_y_12 / r5_y_2);
                float r0_y_14 = (r0_y_13 + 1);
                float r0_y_15 = (r0_w_14 ? 0 : r0_y_14);
                float4 r2_xyzw_9 = (r4_xyzw_2 + r4_xyzw_2);
                float4 r3_xyzw_3 = mad((r3_xyzw_1 + r2_xyzw_2), float4(2, 2, 2, 2), r2_xyzw_9);
                float4 r5_xyzw_3 = (r3_xyzw_3.xxyz * float4(0, 0.16666667, 0.16666667, 0.16666667));
                float r5_y_3 = r5_xyzw_3.y;
                float r5_z_1 = r5_xyzw_3.z;
                float r5_w_1 = r5_xyzw_3.w;
                float r0_y_16 = dot(float4(r5_y_3, r5_z_1, r5_w_1, r5_y_3), float4(0.33, 0.33, 0.33, 0));
                float r0_y_17 = (r0_z_15 / r0_y_16);
                float r0_y_18 = (r0_y_17 * 0.5);
                float4 r6_xyzw_3 = mad(_MainTex_TexelSize.xyxy, float4(-1.5, 0, 1.5, 0), i.texcoord0.xyxy);
                float4 r7_xyzw_1 = t0.Sample(s0, r6_xyzw_3.xyxx);
                float4 r6_xyzw_4 = t0.Sample(s0, r6_xyzw_3.zwzz);
                float4 r2_xyzw_10 = mad((r6_xyzw_4 + r7_xyzw_1), float4(2, 2, 2, 2), r2_xyzw_9);
                float r0_z_16 = dot(((r2_xyzw_10.xyzx * float4(0.16666667, 0.16666667, 0.16666667, 0))).xyzx, float4(0.33, 0.33, 0.33, 0));
                float4 r2_xyzw_12 = mad(_MainTex_TexelSize.xyxy, float4(0, -1, 0, 1), i.texcoord0.xyxy);
                float4 r9_xyzw_1 = t0.Sample(s0, r2_xyzw_12.xyxx);
                float4 r2_xyzw_13 = t0.Sample(s0, r2_xyzw_12.zwzz);
                float4 r5_xyzw_4 = (r2_xyzw_13.xxyz + r9_xyzw_1.xxyz);
                float r5_y_4 = r5_xyzw_4.y;
                float r5_z_2 = r5_xyzw_4.z;
                float r5_w_2 = r5_xyzw_4.w;
                float4 r5_xyzw_5 = mad(-r4_xyzw_2.xxyz, float4(0, 2, 2, 2), float4(r5_y_4, r5_y_4, r5_z_2, r5_w_2));
                float r5_y_5 = r5_xyzw_5.y;
                float r5_z_3 = r5_xyzw_5.z;
                float r5_w_3 = r5_xyzw_5.w;
                float4 r5_xyzw_6 = (abs(float4(r5_y_5, r5_y_5, r5_z_3, r5_w_3)) * float4(0, 0.5, 0.5, 0.5));
                float r5_y_6 = r5_xyzw_6.y;
                float r5_z_4 = r5_xyzw_6.z;
                float r5_w_4 = r5_xyzw_6.w;
                float r0_w_15 = dot(float4(r5_y_6, r5_z_4, r5_w_4, r5_y_6), float4(0.33, 0.33, 0.33, 0));
                float r0_w_16 = mad(r0_w_15, 3, -0.1);
                float r0_z_17 = (r0_w_16 / r0_z_16);
                float4 r8_xyzw_3 = mad(r0_z_17.xxxx, mad(r2_xyzw_10, float4(0.16666667, 0.16666667, 0.16666667, 0.16666667), -r4_xyzw_2), r4_xyzw_2);
                float4 r3_xyzw_5 = mad(r0_y_18.xxxx, mad(r3_xyzw_3, float4(0.16666667, 0.16666667, 0.16666667, 0.16666667), -r8_xyzw_3), r8_xyzw_3);
                float4 r1_xyzw_10 = mad(r0_x_10.xxxx, (mad(r0_y_15.xxxx, r2_xyzw_8, r1_xyzw_7) + -r3_xyzw_5), r3_xyzw_5);
                float4 r8_xyzw_4 = mad(_MainTex_TexelSize.xyxy, float4(3.5, 0, 5.5, 0), i.texcoord0.xyxy);
                float4 r10_xyzw_1 = t0.Sample(s0, r8_xyzw_4.xyxx);
                float4 r8_xyzw_5 = t0.Sample(s0, r8_xyzw_4.zwzz);
                float4 r8_xyzw_6 = mad(_MainTex_TexelSize.xyxy, float4(7.5, 0, -3.5, 0), i.texcoord0.xyxy);
                float4 r10_xyzw_2 = t0.Sample(s0, r8_xyzw_6.xyxx);
                float4 r8_xyzw_7 = t0.Sample(s0, r8_xyzw_6.zwzz);
                float4 r7_xyzw_2 = mad(_MainTex_TexelSize.xyxy, float4(-5.5, 0, -7.5, 0), i.texcoord0.xyxy);
                float4 r8_xyzw_8 = t0.Sample(s0, r7_xyzw_2.xyxx);
                float4 r7_xyzw_3 = t0.Sample(s0, r7_xyzw_2.zwzz);
                float4 r6_xyzw_11 = (r7_xyzw_3.wxyz + ((r8_xyzw_7.wxyz + (r7_xyzw_1.wxyz + ((r8_xyzw_5.wxyz + (r6_xyzw_4.wxyz + r10_xyzw_1.wxyz)) + r10_xyzw_2.wxyz))) + r8_xyzw_8.wxyz));
                float4 r0_xyzw_19 = (r6_xyzw_11.yyzw * float4(0, 0.125, 0.125, 0.125));
                float r0_y_19 = r0_xyzw_19.y;
                float r0_z_18 = r0_xyzw_19.z;
                float r0_w_17 = r0_xyzw_19.w;
                float r5_y_7 = mad(r6_xyzw_11.x, 0.25, -1);
                float r0_y_20 = dot(float4(r0_y_19, r0_z_18, r0_w_17, r0_y_19), float4(0.33, 0.33, 0.33, 0));
                float r0_z_19 = dot(r9_xyzw_1.xyzx, float4(0.33, 0.33, 0.33, 0));
                float r0_w_18 = (-r0_z_19 + r0_y_20);
                float r0_y_21 = (-r5_x_1 + r0_y_20);
                float r5_z_5 = (-r0_z_19 + r5_x_1);
                float r0_z_20 = (r0_z_19 == r5_x_1);
                float r0_w_19 = (r0_w_18 / r5_z_5);
                float r0_z_21 = (r0_z_20 ? 0 : r0_w_19);
                float r0_z_22 = dot(r2_xyzw_13.xyzx, float4(0.33, 0.33, 0.33, 0));
                float r0_w_20 = (-r0_z_22 + r5_x_1);
                float r0_z_23 = (r0_z_22 == r5_x_1);
                float r0_y_22 = (r0_y_21 / r0_w_20);
                float r0_y_23 = (r0_y_22 + 1);
                float r0_y_24 = (r0_z_23 ? 0 : r0_y_23);
                float4 r2_xyzw_14 = mad(r0_y_24.xxxx, (-r2_xyzw_13 + mad(r0_z_21.xxxx, (r4_xyzw_2 + -r9_xyzw_1), r9_xyzw_1)), r2_xyzw_13);
                float4 r2_xyzw_15 = (-r1_xyzw_10 + r2_xyzw_14);
                o.sv_Target0.xyzw = (((0.2 < (-r0_x_10 + r5_y_7))).xxxx ? mad(r5_y_7.xxxx, r2_xyzw_15, r1_xyzw_10) : r3_xyzw_5);
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Cull Off
            ZTest Always
            ZWrite Off
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _MainTex_TexelSize;
                float4 cb0_values[4];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4x4 unity_MatrixVP;
                float4 cb1_values[21];
            };
            SamplerState s0 : register(s0);
            Texture2D t0 : register(t0);
            struct program1Input
            {
                float4 position0 : POSITION0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program1Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program4Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program4Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program1Output vert(program1Input i)
            {
                program1Output o = (program1Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_4 = UnityObjectToWorldPos(i.position0.xyz);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_4);
                o.texcoord0.xy = (i.texcoord0.xyxx).xy;
                return o;
            }
            #pragma fragment frag
            program4Output frag(program4Input i)
            {
                program4Output o = (program4Output)0;
                float4 r0_xyzw_1 = mad(_MainTex_TexelSize.xyxy, float4(0, -1.5, 0, 1.5), i.texcoord0.xyxy);
                float4 r1_xyzw_1 = t0.Sample(s0, r0_xyzw_1.xyxx);
                float4 r0_xyzw_2 = t0.Sample(s0, r0_xyzw_1.zwzz);
                float4 r2_xyzw_1 = (r0_xyzw_2 + r1_xyzw_1);
                float4 r4_xyzw_1 = t0.Sample(s0, i.texcoord0.xyxx);
                float r3_x_5 = mad(dot((((mad(-r4_xyzw_1.xyzx, float4(4, 4, 4, 0), ((r2_xyzw_1.xyzx + r2_xyzw_1.xyzx)).xyzx)).xyzx * float4(0.25, 0.25, 0.25, 0))).xyzx, float4(0.33, 0.33, 0.33, 0)), 3, -0.1);
                float4 r5_xyzw_1 = mad(_MainTex_TexelSize.xyxy, float4(-1.5, 0, 1.5, 0), i.texcoord0.xyxy);
                float4 r6_xyzw_1 = t0.Sample(s0, r5_xyzw_1.xyxx);
                float4 r5_xyzw_2 = t0.Sample(s0, r5_xyzw_1.zwzz);
                float4 r7_xyzw_1 = (r5_xyzw_2 + r6_xyzw_1);
                float4 r8_xyzw_1 = (r4_xyzw_1 + r4_xyzw_1);
                float4 r9_xyzw_1 = mad(r7_xyzw_1, float4(2, 2, 2, 2), r8_xyzw_1);
                float4 r3_xyzw_4 = (r7_xyzw_1.xxyz + r7_xyzw_1.xxyz);
                float r3_y_4 = r3_xyzw_4.y;
                float r3_z_4 = r3_xyzw_4.z;
                float r3_w_1 = r3_xyzw_4.w;
                float4 r3_xyzw_5 = mad(-r4_xyzw_1.xxyz, float4(0, 4, 4, 4), float4(r3_y_4, r3_y_4, r3_z_4, r3_w_1));
                float r3_y_5 = r3_xyzw_5.y;
                float r3_z_5 = r3_xyzw_5.z;
                float r3_w_2 = r3_xyzw_5.w;
                float4 r3_xyzw_6 = (abs(float4(r3_y_5, r3_y_5, r3_z_5, r3_w_2)) * float4(0, 0.25, 0.25, 0.25));
                float r3_y_6 = r3_xyzw_6.y;
                float r3_z_6 = r3_xyzw_6.z;
                float r3_w_3 = r3_xyzw_6.w;
                float r3_y_7 = dot(float4(r3_y_6, r3_z_6, r3_w_3, r3_y_6), float4(0.33, 0.33, 0.33, 0));
                float r3_y_8 = mad(r3_y_7, 3, -0.1);
                float4 r2_xyzw_2 = mad(r2_xyzw_1, float4(2, 2, 2, 2), r8_xyzw_1);
                float r3_z_7 = dot(((r9_xyzw_1.xyzx * float4(0.16666667, 0.16666667, 0.16666667, 0))).xyzx, float4(0.33, 0.33, 0.33, 0));
                float4 r7_xyzw_3 = mad(((r3_x_5 / r3_z_7)).xxxx, mad(r9_xyzw_1, float4(0.16666667, 0.16666667, 0.16666667, 0.16666667), -r4_xyzw_1), r4_xyzw_1);
                float4 r2_xyzw_6 = mad(((r3_y_8 / dot(((r2_xyzw_2.xyzx * float4(0.16666667, 0.16666667, 0.16666667, 0))).xyzx, float4(0.33, 0.33, 0.33, 0)))).xxxx, mad(r2_xyzw_2, float4(0.16666667, 0.16666667, 0.16666667, 0.16666667), -r7_xyzw_3), r7_xyzw_3);
                float4 r3_xyzw_7 = mad(_MainTex_TexelSize.xyxy, float4(0, 3.5, 0, 5.5), i.texcoord0.xyxy);
                float4 r7_xyzw_4 = t0.Sample(s0, r3_xyzw_7.xyxx);
                float4 r3_xyzw_8 = t0.Sample(s0, r3_xyzw_7.zwzz);
                float4 r3_xyzw_9 = mad(_MainTex_TexelSize.xyxy, float4(0, 7.5, 0, -3.5), i.texcoord0.xyxy);
                float4 r7_xyzw_5 = t0.Sample(s0, r3_xyzw_9.xyxx);
                float4 r3_xyzw_10 = t0.Sample(s0, r3_xyzw_9.zwzz);
                float4 r1_xyzw_2 = mad(_MainTex_TexelSize.xyxy, float4(0, -5.5, 0, -7.5), i.texcoord0.xyxy);
                float4 r3_xyzw_11 = t0.Sample(s0, r1_xyzw_2.xyxx);
                float4 r1_xyzw_3 = t0.Sample(s0, r1_xyzw_2.zwzz);
                float4 r0_xyzw_9 = (r1_xyzw_3.wxyz + ((r3_xyzw_10.wxyz + (r1_xyzw_1.wxyz + ((r3_xyzw_8.wxyz + (r0_xyzw_2.wxyz + r7_xyzw_4.wxyz)) + r7_xyzw_5.wxyz))) + r3_xyzw_11.wxyz));
                float3 r0_yzw_10 = ((r0_xyzw_9.yyzw * float4(0, 0.125, 0.125, 0.125))).yzw;
                float r0_x_10 = mad(r0_xyzw_9.x, 0.25, -1);
                float r0_y_11 = dot(r0_yzw_10.xyzx, float4(0.33, 0.33, 0.33, 0));
                float4 r1_xyzw_4 = mad(_MainTex_TexelSize.xyxy, float4(-1, 0, 1, 0), i.texcoord0.xyxy);
                float4 r3_xyzw_12 = t0.Sample(s0, r1_xyzw_4.xyxx);
                float4 r1_xyzw_5 = t0.Sample(s0, r1_xyzw_4.zwzz);
                float r0_z_11 = dot(r3_xyzw_12.xyzx, float4(0.33, 0.33, 0.33, 0));
                float r0_w_11 = (-r0_z_11 + r0_y_11);
                float r7_x_6 = dot(r4_xyzw_1.xyzx, float4(0.33, 0.33, 0.33, 0));
                float r7_y_6 = (-r0_z_11 + r7_x_6);
                float r0_z_12 = (r0_z_11 == r7_x_6);
                float r0_w_12 = (r0_w_11 / r7_y_6);
                float r0_z_13 = (r0_z_12 ? 0 : r0_w_12);
                float4 r3_xyzw_13 = mad(r0_z_13.xxxx, (-r3_xyzw_12 + r4_xyzw_1), r3_xyzw_12);
                float4 r3_xyzw_14 = (-r1_xyzw_5 + r3_xyzw_13);
                float r0_y_12 = (r0_y_11 + -r7_x_6);
                float r0_z_14 = dot(r1_xyzw_5.xyzx, float4(0.33, 0.33, 0.33, 0));
                float r0_w_13 = (-r0_z_14 + r7_x_6);
                float r0_z_15 = (r0_z_14 == r7_x_6);
                float r0_y_13 = (r0_y_12 / r0_w_13);
                float r0_y_14 = (r0_y_13 + 1);
                float r0_y_15 = (r0_z_15 ? 0 : r0_y_14);
                float4 r1_xyzw_8 = mad(r0_x_10.xxxx, (-r2_xyzw_6 + mad(r0_y_15.xxxx, r3_xyzw_14, r1_xyzw_5)), r2_xyzw_6);
                float4 r3_xyzw_15 = mad(_MainTex_TexelSize.xyxy, float4(3.5, 0, 5.5, 0), i.texcoord0.xyxy);
                float4 r8_xyzw_5 = t0.Sample(s0, r3_xyzw_15.xyxx);
                float4 r3_xyzw_16 = t0.Sample(s0, r3_xyzw_15.zwzz);
                float4 r3_xyzw_17 = (r3_xyzw_16.wxyz + (r5_xyzw_2.wxyz + r8_xyzw_5.wxyz));
                float4 r5_xyzw_4 = mad(_MainTex_TexelSize.xyxy, float4(7.5, 0, -3.5, 0), i.texcoord0.xyxy);
                float4 r8_xyzw_6 = t0.Sample(s0, r5_xyzw_4.xyxx);
                float4 r5_xyzw_5 = t0.Sample(s0, r5_xyzw_4.zwzz);
                float4 r3_xyzw_18 = (r3_xyzw_17 + r8_xyzw_6.wxyz);
                float4 r3_xyzw_19 = (r6_xyzw_1.wxyz + r3_xyzw_18);
                float4 r3_xyzw_20 = (r5_xyzw_5.wxyz + r3_xyzw_19);
                float4 r5_xyzw_6 = mad(_MainTex_TexelSize.xyxy, float4(-5.5, 0, -7.5, 0), i.texcoord0.xyxy);
                float4 r6_xyzw_2 = t0.Sample(s0, r5_xyzw_6.xyxx);
                float4 r5_xyzw_7 = t0.Sample(s0, r5_xyzw_6.zwzz);
                float4 r3_xyzw_21 = (r3_xyzw_20 + r6_xyzw_2.wxyz);
                float4 r3_xyzw_22 = (r5_xyzw_7.wxyz + r3_xyzw_21);
                float4 r0_xyzw_16 = (r3_xyzw_22.yyzw * float4(0, 0.125, 0.125, 0.125));
                float r0_y_16 = r0_xyzw_16.y;
                float r0_z_16 = r0_xyzw_16.z;
                float r0_w_14 = r0_xyzw_16.w;
                float r3_x_23 = mad(r3_xyzw_22.x, 0.25, -1);
                float r0_y_17 = dot(float4(r0_y_16, r0_z_16, r0_w_14, r0_y_16), float4(0.33, 0.33, 0.33, 0));
                float4 r5_xyzw_8 = mad(_MainTex_TexelSize.xyxy, float4(0, -1, 0, 1), i.texcoord0.xyxy);
                float4 r6_xyzw_3 = t0.Sample(s0, r5_xyzw_8.xyxx);
                float4 r5_xyzw_9 = t0.Sample(s0, r5_xyzw_8.zwzz);
                float r0_z_17 = dot(r6_xyzw_3.xyzx, float4(0.33, 0.33, 0.33, 0));
                float r0_w_15 = (-r0_z_17 + r0_y_17);
                float r0_y_18 = (-r7_x_6 + r0_y_17);
                float r3_y_25 = (-r0_z_17 + r7_x_6);
                float r0_z_18 = (r0_z_17 == r7_x_6);
                float r0_w_16 = (r0_w_15 / r3_y_25);
                float r0_z_19 = (r0_z_18 ? 0 : r0_w_16);
                float r0_z_20 = dot(r5_xyzw_9.xyzx, float4(0.33, 0.33, 0.33, 0));
                float r0_w_17 = (-r0_z_20 + r7_x_6);
                float r0_z_21 = (r0_z_20 == r7_x_6);
                float r0_y_19 = (r0_y_18 / r0_w_17);
                float r0_y_20 = (r0_y_19 + 1);
                float r0_y_21 = (r0_z_21 ? 0 : r0_y_20);
                float4 r1_xyzw_9 = mad(r3_x_23.xxxx, (-r1_xyzw_8 + mad(r0_y_21.xxxx, (-r5_xyzw_9 + mad(r0_z_19.xxxx, (r4_xyzw_1 + -r6_xyzw_3), r6_xyzw_3)), r5_xyzw_9)), r1_xyzw_8);
                float r0_y_22 = (0 < r3_x_23);
                o.sv_Target0.xyzw = ((asfloat(asint((float)((0 < r0_x_10))) | asint(r0_y_22))).xxxx ? r1_xyzw_9 : r2_xyzw_6);
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Cull Off
            ZTest Always
            ZWrite Off
            HLSLPROGRAM
            ENDHLSL
        }
        Pass
        {
            Cull Off
            ZTest Always
            ZWrite Off
            HLSLPROGRAM
            ENDHLSL
        }
    }
}
