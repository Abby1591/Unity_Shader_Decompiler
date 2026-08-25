Shader "Hidden/FXAA Preset 3"
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
            cbuffer _UnityPerDrawCB : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _MainTex_TexelSize;
            };
            cbuffer _UnityPerFrameCB : register(b1)
            {
                float4x4 unity_MatrixVP;
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program1Input
            {
                float4 position0 : POSITION0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program1Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program3Output
            {
                float4 sv_Target0 : SV_Target;
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
                float4 r0_xyzw_1 = mad(_MainTex_TexelSize.xyxy, float4(0, -1, -1, 0), i.texcoord0.xyxy);
                float4 r1_xyzw_1 = _MainTex.Sample(sampler_MainTex, (r0_xyzw_1.xyxx).xy);
                float4 r0_xyzw_2 = _MainTex.Sample(sampler_MainTex, (r0_xyzw_1.zwzz).xy);
                float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r3_xyzw_1 = mad(_MainTex_TexelSize.xyxy, float4(1, 0, 0, 1), i.texcoord0.xyxy);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (r3_xyzw_1.xyxx).xy);
                float4 r3_xyzw_2 = _MainTex.Sample(sampler_MainTex, (r3_xyzw_1.zwzz).xy);
                float r0_w_3 = mad(r1_xyzw_1.y, 1.9632107, r1_xyzw_1.x);
                float r1_w_2 = mad(r0_xyzw_2.y, 1.9632107, r0_xyzw_2.x);
                float r2_w_2 = mad(r2_xyzw_1.y, 1.9632107, r2_xyzw_1.x);
                float r3_w_3 = mad(r4_xyzw_1.y, 1.9632107, r4_xyzw_1.x);
                float r4_w_2 = mad(r3_xyzw_2.y, 1.9632107, r3_xyzw_2.x);
                float r5_y_1 = min(r3_w_3, r4_w_2);
                float r5_y_2 = max(r0_w_3, r1_w_2);
                float r5_z_1 = max(r3_w_3, r4_w_2);
                float r5_y_3 = max(r5_z_1, r5_y_2);
                float r5_y_4 = max(r2_w_2, r5_y_3);
                float r5_x_4 = (min(r2_w_2, min(r5_y_1, min(r0_w_3, r1_w_2))) + r5_y_4);
                float r5_y_5 = (r5_y_4 * 0.125);
                float r5_y_6 = max(r5_y_5, 0.041666668);
                float r5_y_7 = (r5_x_4 >= r5_y_6);
                float3 r2_xyz_3 = r2_xyzw_1.xyz;
                if (r5_y_7)
                {
                    float r1_x_8 = max(((mad((r4_w_2 + (r3_w_3 + (r0_w_3 + r1_w_2))), 0.25, -r2_w_2) / r5_x_4) + -0.25), 0);
                    float r1_x_10 = min((r1_x_8 * 1.3333334), 0.75);
                    float2 r1_yz_2 = ((i.texcoord0.xxyx + -_MainTex_TexelSize.xxyx)).yz;
                    float4 r5_xyzw_5 = _MainTex.Sample(sampler_MainTex, (r1_yz_2.xyxx).xy);
                    float4 r6_xyzw_1 = mad(_MainTex_TexelSize.xyxy, float4(1, -1, -1, 1), i.texcoord0.xyxy);
                    float4 r7_xyzw_1 = _MainTex.Sample(sampler_MainTex, (r6_xyzw_1.xyxx).xy);
                    float4 r6_xyzw_2 = _MainTex.Sample(sampler_MainTex, (r6_xyzw_1.zwzz).xy);
                    float2 r1_yz_3 = ((i.texcoord0.xxyx + _MainTex_TexelSize.xxyx)).yz;
                    float4 r8_xyzw_1 = _MainTex.Sample(sampler_MainTex, (r1_yz_3.xyxx).xy);
                    float3 r3_xyz_5 = ((r8_xyzw_1.xyzx + ((r6_xyzw_2.xyzx + ((r5_xyzw_5.xyzx + r7_xyzw_1.xyzx)).xyzx)).xyzx)).xyz;
                    float3 r0_xyz_7 = ((((r3_xyzw_2.xyzx + ((r4_xyzw_1.xyzx + ((r2_xyzw_1.xyzx + ((r0_xyzw_2.xyzx + r1_xyzw_1.xyzx)).xyzx)).xyzx)).xyzx)).xyzx + r3_xyz_5.xyzx)).xyz;
                    float r1_y_4 = mad(r5_xyzw_5.y, 1.9632107, r5_xyzw_5.x);
                    float r1_z_4 = mad(r7_xyzw_1.y, 1.9632107, r7_xyzw_1.x);
                    float r3_x_6 = mad(r6_xyzw_2.y, 1.9632107, r6_xyzw_2.x);
                    float r3_y_6 = mad(r8_xyzw_1.y, 1.9632107, r8_xyzw_1.x);
                    float r3_z_6 = (r0_w_3 * -0.5);
                    float r3_z_7 = mad(r1_y_4, 0.25, r3_z_6);
                    float r3_z_8 = mad(r1_z_4, 0.25, r3_z_7);
                    float r4_y_2 = mad(r1_w_2, 0.5, -r2_w_2);
                    float r4_z_2 = (r3_w_3 * -0.5);
                    float r4_y_3 = mad(r3_w_3, 0.5, r4_y_2);
                    float r3_z_9 = (abs(r3_z_8) + abs(r4_y_3));
                    float r4_y_4 = (r4_w_2 * -0.5);
                    float r4_y_5 = mad(r3_x_6, 0.25, r4_y_4);
                    float r4_y_6 = mad(r3_y_6, 0.25, r4_y_5);
                    float r3_z_10 = (r3_z_9 + abs(r4_y_6));
                    float r1_y_5 = mad(r1_y_4, 0.25, (r1_w_2 * -0.5));
                    float r1_y_6 = mad(r3_x_6, 0.25, r1_y_5);
                    float r1_y_7 = (abs(r1_y_6) + mad(r4_w_2, 0.5, mad(r0_w_3, 0.5, -r2_w_2)));
                    float r1_z_5 = mad(r1_z_4, 0.25, r4_z_2);
                    float r1_z_6 = mad(r3_y_6, 0.25, r1_z_5);
                    float r1_y_8 = (abs(r1_z_6) + r1_y_7);
                    float r1_y_9 = (r1_y_8 >= r3_z_10);
                    float r1_z_7 = (r1_y_9 ? -_MainTex_TexelSize.y : -_MainTex_TexelSize.x);
                    float r0_w_4 = (r1_y_9 ? r0_w_3 : r1_w_2);
                    float r1_w_3 = (r1_y_9 ? r4_w_2 : r3_w_3);
                    float r3_x_9 = (-r2_w_2 + r0_w_4);
                    float r3_y_7 = (-r2_w_2 + r1_w_3);
                    float r0_w_5 = (r2_w_2 + r0_w_4);
                    float r0_w_6 = (r0_w_5 * 0.5);
                    float r1_w_4 = (r2_w_2 + r1_w_3);
                    float r1_w_5 = (r1_w_4 * 0.5);
                    float r3_z_11 = (abs(r3_x_9) >= abs(r3_y_7));
                    float r0_w_7 = (r3_z_11 ? r0_w_6 : r1_w_5);
                    float r1_w_6 = (r3_z_11 ? abs(r3_x_9) : abs(r3_y_7));
                    float r1_z_8 = (r3_z_11 ? r1_z_7 : -r1_z_7);
                    float r3_x_10 = (r1_z_8 * 0.5);
                    float r3_y_8 = (r1_y_9 ? 0 : r3_x_10);
                    float r3_x_11 = asfloat(asint(r1_y_9) & asint(r3_x_10));
                    float4 r4_xyzw_3 = (float4(r3_y_8, r3_x_11, r3_y_8, r3_y_8) + i.texcoord0.xyxx);
                    float r4_x_3 = r4_xyzw_3.x;
                    float r4_y_7 = r4_xyzw_3.y;
                    float r1_w_7 = (r1_w_6 * 0.25);
                    float4 r3_xyzw_9 = float4(0, 0, 0, 0);
                    float r3_y_9 = r3_xyzw_9.y;
                    float r3_z_12 = r3_xyzw_9.z;
                    float r3_x_12 = (_MainTex_TexelSize.xxxy).x;
                    float r3_w_4 = (_MainTex_TexelSize.xxxy).w;
                    float4 r3_xyzw_13 = (r1_y_9.xxxx ? float4(r3_x_12, r3_y_9, r3_x_12, r3_x_12) : float4(r3_z_12, r3_w_4, r3_z_12, r3_z_12));
                    float r3_x_13 = r3_xyzw_13.x;
                    float r3_y_10 = r3_xyzw_13.y;
                    float r3_z_13 = ((-float4(r3_x_13, r3_x_13, r3_x_13, r3_y_10) + float4(r4_x_3, r4_x_3, r4_x_3, r4_y_7))).z;
                    float r3_w_5 = ((-float4(r3_x_13, r3_x_13, r3_x_13, r3_y_10) + float4(r4_x_3, r4_x_3, r4_x_3, r4_y_7))).w;
                    float4 r4_xyzw_4 = (float4(r3_x_13, r3_y_10, r3_x_13, r3_x_13) + float4(r4_x_3, r4_y_7, r4_x_3, r4_x_3));
                    float r4_x_4 = r4_xyzw_4.x;
                    float r4_y_8 = r4_xyzw_4.y;
                    float2 r4_zw_3 = (float4(r3_z_13, r3_z_13, r3_z_13, r3_w_5)).zw;
                    float r5_x_6 = r4_x_4;
                    float r5_y_9 = r4_y_8;
                    float r5_z_3 = r0_w_7;
                    float r5_w_2 = r0_w_7;
                    float r7_w_2 = r7_xyzw_1.w;
                    float3 r6_xyz_4 = (float4(0, 0, 0, 0)).xyz;
                    float r5_x_7 = r5_x_6;
                    float r5_y_10 = r5_y_9;
                    float r5_z_4 = r5_z_3;
                    float r5_w_3 = r5_w_2;
                    float2 r4_zw_4 = r4_zw_3.xy;
                    float r6_w_4;
                    float r5_z_7;
                    float r5_w_6;
                    float r7_y_7;
                    float r7_y_8;
                    float r6_x_5;
                    float r7_y_9;
                    float r7_y_10;
                    float r6_y_5;
                    float r7_y_11;
                    float r7_y_12;
                    float r7_z_7;
                    float2 r4_zw_5;
                    float r7_y_13;
                    float r7_z_8;
                    float r5_x_8;
                    float r5_y_11;
                    float r6_z_5;
                    float r5_z_5;
                    float r5_w_4;
                    [loop]
                    while (true)
                    {
                        r6_w_4 = (r6_xyz_4.z >= 16);
                        r5_z_7 = r5_z_4;
                        r5_w_6 = r5_w_3;
                        if (r6_w_4) break;
                        float r7_w_4;
                        float r6_w_7;
                        if (r6_xyz_4.x)
                        {
                            float4 r7_xyzw_3 = _MainTex.Sample(sampler_MainTex, (r4_zw_4.xyxx).xy);
                            float r6_w_6 = mad(r7_xyzw_3.y, 1.9632107, r7_xyzw_3.x);
                            r7_w_4 = r7_xyzw_3.w;
                            r6_w_7 = r6_w_6;
                        }
                        else
                        {
                            float r6_w_5 = r5_z_4;
                            r7_w_4 = r7_w_2;
                            r6_w_7 = r6_w_5;
                        }
                        float r7_x_8;
                        float r7_w_6;
                        if ((r6_xyz_4.y != 0))
                        {
                            float4 r7_xyzw_6 = _MainTex.Sample(sampler_MainTex, (float4(r5_x_7, r5_y_10, r5_x_7, r5_x_7)).xy);
                            float r7_x_7 = mad(r7_xyzw_6.y, 1.9632107, r7_xyzw_6.x);
                            r7_x_8 = r7_x_7;
                            r7_w_6 = r7_xyzw_6.w;
                        }
                        else
                        {
                            float r7_x_5 = r5_w_3;
                            r7_x_8 = r7_x_5;
                            r7_w_6 = r7_w_4;
                        }
                        r7_y_7 = (-r0_w_7 + r6_w_7);
                        r7_y_8 = (abs(r7_y_7) >= r1_w_7);
                        r6_x_5 = asfloat(asint(r6_xyz_4.x) | asint(r7_y_8));
                        r7_y_9 = (-r0_w_7 + r7_x_8);
                        r7_y_10 = (abs(r7_y_9) >= r1_w_7);
                        r6_y_5 = asfloat(asint(r6_xyz_4.y) | asint(r7_y_10));
                        r7_y_11 = asfloat(asint(r6_y_5) & asint(r6_x_5));
                        if ((r7_y_11 != 0))
                        {
                            float r5_z_6 = r6_w_7;
                            float r5_w_5 = r7_x_8;
                            r5_z_7 = r5_z_6;
                            r5_w_6 = r5_w_5;
                            break;
                        }
                        float4 r7_xyzw_12 = (-float4(r3_x_13, r3_x_13, r3_y_10, r3_x_13) + r4_zw_4.xxyx);
                        r7_y_12 = r7_xyzw_12.y;
                        r7_z_7 = r7_xyzw_12.z;
                        r4_zw_5 = (((r6_x_5.xxxx != 0) ? r4_zw_4.xxxy : float4(r7_y_12, r7_y_12, r7_y_12, r7_z_7))).zw;
                        float4 r7_xyzw_13 = (float4(r3_x_13, r3_x_13, r3_y_10, r3_x_13) + float4(r5_x_7, r5_x_7, r5_y_10, r5_x_7));
                        r7_y_13 = r7_xyzw_13.y;
                        r7_z_8 = r7_xyzw_13.z;
                        float4 r5_xyzw_8 = ((r6_y_5.xxxx != 0) ? float4(r5_x_7, r5_y_10, r5_x_7, r5_x_7) : float4(r7_y_13, r7_z_8, r7_y_13, r7_y_13));
                        r5_x_8 = r5_xyzw_8.x;
                        r5_y_11 = r5_xyzw_8.y;
                        r6_z_5 = (r6_xyz_4.z + 1);
                        r5_z_5 = r6_w_7;
                        r5_w_4 = r7_x_8;
                        r7_w_2 = r7_w_6;
                        r6_xyz_4 = float3(r6_x_5, r6_y_5, r6_z_5);
                        r5_x_7 = r5_x_8;
                        r5_y_10 = r5_y_11;
                        r5_z_4 = r5_z_5;
                        r5_w_3 = r5_w_4;
                        r4_zw_4 = r4_zw_5.xy;
                    }
                    float4 r3_xyzw_14 = (-r4_zw_4.xyxx + i.texcoord0.xyxx);
                    float r3_x_14 = r3_xyzw_14.x;
                    float r3_y_11 = r3_xyzw_14.y;
                    float r1_w_8 = (r1_y_9 ? r3_x_14 : r3_y_11);
                    float4 r3_xyzw_15 = (float4(r5_x_7, r5_y_10, r5_x_7, r5_x_7) + -i.texcoord0.xyxx);
                    float r3_x_15 = r3_xyzw_15.x;
                    float r3_y_12 = r3_xyzw_15.y;
                    float r3_x_16 = ((r1_y_9 != 0) ? r3_x_15 : r3_y_12);
                    float r3_y_13 = (r1_w_8 < r3_x_16);
                    float r3_z_14 = (r3_y_13 ? r5_z_7 : r5_w_6);
                    float r2_w_3 = (-r0_w_7 + r2_w_2);
                    float r2_w_4 = (r2_w_3 < 0);
                    float r0_w_8 = (-r0_w_7 + r3_z_14);
                    float r0_w_9 = (r0_w_8 < 0);
                    float r0_w_10 = (r0_w_9 == r2_w_4);
                    float r0_w_11 = (r0_w_10 ? 0 : r1_z_8);
                    float r1_z_9 = (r1_w_8 + r3_x_16);
                    float r1_w_9 = ((r3_y_13 != 0) ? r1_w_8 : r3_x_16);
                    float r1_z_10 = (-1 / r1_z_9);
                    float r1_z_11 = mad(r1_w_9, r1_z_10, 0.5);
                    float r0_w_12 = (r0_w_11 * r1_z_11);
                    float r1_z_12 = ((r1_y_9 != 0) ? 0 : r0_w_12);
                    float r3_x_17 = (r1_z_12 + i.texcoord0.x);
                    float r0_w_13 = asfloat(asint(r0_w_12) & asint(r1_y_9));
                    float r3_y_14 = (r0_w_13 + i.texcoord0.y);
                    float4 r3_xyzw_18 = _MainTex.Sample(sampler_MainTex, (float4(r3_x_17, r3_y_14, r3_x_17, r3_x_17)).xy);
                    r2_xyz_3 = (mad(-r1_x_10.xxxx, r3_xyzw_18.xyzx, (mad(((r1_x_10.xxxx * r0_xyz_7.xyzx)).xyzx, float4(0.11111111, 0.11111111, 0.11111111, 0), r3_xyzw_18.xyzx)).xyzx)).xyz;
                }
                o.sv_Target0.xyz = r2_xyz_3.xyz;
                o.sv_Target0.w = 0;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Hidden/FXAA II"
}
