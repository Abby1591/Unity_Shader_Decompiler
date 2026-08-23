Shader "Hidden/FXAA III (Console)"
{
    Properties
    {
        _MainTex ("-", 2D) = "" {}
        _EdgeThresholdMin ("Edge threshold min", Float) = 0.125
        _EdgeThreshold ("Edge Threshold", Float) = 0.25
        _EdgeSharpness ("Edge sharpness", Float) = 4
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
            cbuffer _Globals : register(b0)
            {
                float _EdgeThresholdMin;
                float _EdgeThreshold;
                float _EdgeSharpness;
                float4 _MainTex_TexelSize;
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4x4 unity_MatrixVP;
            };
            SamplerState sampler_linear_clamp : register(s0);
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
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
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
                o.texcoord1.xy = (mad(-_MainTex_TexelSize.xyxx, float4(0.5, 0.5, 0, 0), i.texcoord0.xyxx)).xy;
                o.texcoord1.zw = (mad(_MainTex_TexelSize.xxxy, float4(0, 0, 0.5, 0.5), i.texcoord0.xxxy)).zw;
                o.texcoord2.xyzw = (_MainTex_TexelSize.xyxy * float4(-0.5, -0.5, 0.5, 0.5));
                o.texcoord3.xy = ((_MainTex_TexelSize.xyxx * float4(-2, -2, 0, 0))).xy;
                o.texcoord3.zw = ((_MainTex_TexelSize.xxxy + _MainTex_TexelSize.xxxy)).zw;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float4 r0_xyzw_1 = t0.Sample(sampler_linear_clamp, (i.texcoord1.xyxx).xy);
                float r0_x_2 = dot(r0_xyzw_1.xyzx, float4(0.22, 0.707, 0.071, 0));
                float4 r1_xyzw_1 = t0.Sample(sampler_linear_clamp, (i.texcoord1.xwxx).xy);
                float r0_y_2 = dot(r1_xyzw_1.xyzx, float4(0.22, 0.707, 0.071, 0));
                float4 r1_xyzw_2 = t0.Sample(sampler_linear_clamp, (i.texcoord1.zyzz).xy);
                float r0_z_2 = dot(r1_xyzw_2.xyzx, float4(0.22, 0.707, 0.071, 0));
                float4 r1_xyzw_3 = t0.Sample(sampler_linear_clamp, (i.texcoord1.zwzz).xy);
                float r0_w_2 = dot(r1_xyzw_3.xyzx, float4(0.22, 0.707, 0.071, 0));
                float4 r1_xyzw_4 = t0.Sample(sampler_linear_clamp, (i.texcoord0.xyxx).xy);
                float r1_w_5 = dot(r1_xyzw_4.xyzx, float4(0.22, 0.707, 0.071, 0));
                float r0_z_3 = (r0_z_2 + 0.0026041667);
                float2 r2_xz_1 = (max(float4(r0_y_2, r0_y_2, r0_w_2, r0_y_2), float4(r0_x_2, r0_x_2, r0_z_3, r0_x_2))).xz;
                float2 r2_yw_1 = (min(float4(r0_y_2, r0_y_2, r0_y_2, r0_w_2), float4(r0_x_2, r0_x_2, r0_x_2, r0_z_3))).yw;
                float r2_x_2 = max(r2_xz_1.x, r2_xz_1.y);
                float r2_y_2 = min(r2_yw_1.x, r2_yw_1.y);
                float r2_z_2 = (r2_x_2 * _EdgeThreshold);
                float r2_w_2 = min(r1_w_5, r2_y_2);
                float r2_z_3 = max(r2_z_2, _EdgeThresholdMin);
                float r1_w_6 = max(r1_w_5, r2_x_2);
                float r1_w_7 = (-r2_w_2 + r1_w_6);
                float r1_w_8 = (r1_w_7 >= r2_z_3);
                float3 r1_xyz_6 = r1_xyzw_4.xyz;
                if (r1_w_8)
                {
                    float2 r0_xy_3 = ((-float4(r0_x_2, r0_z_3, r0_x_2, r0_x_2) + float4(r0_w_2, r0_y_2, r0_w_2, r0_w_2))).xy;
                    float r3_x_1 = (r0_xy_3.x + r0_xy_3.y);
                    float r3_y_1 = (-r0_xy_3.x + r0_xy_3.y);
                    float4 r0_xyzw_6 = ((rsqrt(dot(float4(r3_x_1, r3_y_1, r3_x_1, r3_x_1), float4(r3_x_1, r3_y_1, r3_x_1, r3_x_1)))).xxxx * float4(r3_x_1, r3_y_1, r3_x_1, r3_x_1));
                    float r0_x_6 = r0_xyzw_6.x;
                    float r0_y_4 = r0_xyzw_6.y;
                    float4 r0_xyzw_4 = mad(-float4(r0_x_6, r0_x_6, r0_x_6, r0_y_4), i.texcoord2.zzzw, i.texcoord0.xxxy);
                    float r0_z_4 = r0_xyzw_4.z;
                    float r0_w_3 = r0_xyzw_4.w;
                    float4 r3_xyzw_2 = t0.Sample(sampler_linear_clamp, (float4(r0_z_4, r0_w_3, r0_z_4, r0_z_4)).xy);
                    float4 r0_xyzw_5 = mad(float4(r0_x_6, r0_x_6, r0_x_6, r0_y_4), i.texcoord2.zzzw, i.texcoord0.xxxy);
                    float r0_z_5 = r0_xyzw_5.z;
                    float r0_w_4 = r0_xyzw_5.w;
                    float4 r4_xyzw_1 = t0.Sample(sampler_linear_clamp, (float4(r0_z_5, r0_w_4, r0_z_5, r0_z_5)).xy);
                    float r0_z_6 = min(abs(r0_y_4), abs(r0_x_6));
                    float r0_z_7 = (r0_z_6 * _EdgeSharpness);
                    float4 r0_xyzw_7 = (float4(r0_x_6, r0_y_4, r0_x_6, r0_x_6) / r0_z_7.xxxx);
                    float r0_x_7 = r0_xyzw_7.x;
                    float r0_y_5 = r0_xyzw_7.y;
                    float4 r0_xyzw_8 = max(float4(r0_x_7, r0_y_5, r0_x_7, r0_x_7), float4(-2, -2, 0, 0));
                    float r0_x_8 = r0_xyzw_8.x;
                    float r0_y_6 = r0_xyzw_8.y;
                    float4 r0_xyzw_9 = min(float4(r0_x_8, r0_y_6, r0_x_8, r0_x_8), float4(2, 2, 0, 0));
                    float r0_x_9 = r0_xyzw_9.x;
                    float r0_y_7 = r0_xyzw_9.y;
                    float r0_z_8 = (mad(-float4(r0_x_9, r0_x_9, r0_x_9, r0_y_7), i.texcoord3.zzzw, i.texcoord0.xxxy)).z;
                    float r0_w_5 = (mad(-float4(r0_x_9, r0_x_9, r0_x_9, r0_y_7), i.texcoord3.zzzw, i.texcoord0.xxxy)).w;
                    float4 r5_xyzw_1 = t0.Sample(sampler_linear_clamp, (float4(r0_z_8, r0_w_5, r0_z_8, r0_z_8)).xy);
                    float4 r0_xyzw_10 = mad(float4(r0_x_9, r0_y_7, r0_x_9, r0_x_9), i.texcoord3.zwzz, i.texcoord0.xyxx);
                    float r0_x_10 = r0_xyzw_10.x;
                    float r0_y_8 = r0_xyzw_10.y;
                    float4 r0_xyzw_11 = t0.Sample(sampler_linear_clamp, (float4(r0_x_10, r0_y_8, r0_x_10, r0_x_10)).xy);
                    float4 r3_xyzw_3 = (r3_xyzw_2.xyzx + r4_xyzw_1.xyzx);
                    float r3_x_3 = r3_xyzw_3.x;
                    float r3_y_3 = r3_xyzw_3.y;
                    float r3_z_2 = r3_xyzw_3.z;
                    float4 r0_xyzw_12 = (r0_xyzw_11.xyzx + r5_xyzw_1.xyzx);
                    float r0_x_12 = r0_xyzw_12.x;
                    float r0_y_10 = r0_xyzw_12.y;
                    float r0_z_10 = r0_xyzw_12.z;
                    float4 r0_xyzw_13 = mad(float4(r0_x_12, r0_y_10, r0_z_10, r0_x_12), float4(0.25, 0.25, 0.25, 0), ((float4(r3_x_3, r3_y_3, r3_z_2, r3_x_3) * float4(0.25, 0.25, 0.25, 0))).xyzx);
                    float r0_x_13 = r0_xyzw_13.x;
                    float r0_y_11 = r0_xyzw_13.y;
                    float r0_z_11 = r0_xyzw_13.z;
                    float r0_w_7 = dot(float4(r3_x_3, r3_y_3, r3_z_2, r3_x_3), float4(0.22, 0.707, 0.071, 0));
                    float r0_w_8 = (r0_w_7 < r2_y_2);
                    float r1_w_9 = dot(float4(r0_x_13, r0_y_11, r0_z_11, r0_x_13), float4(0.22, 0.707, 0.071, 0));
                    float r1_w_10 = (r2_x_2 < r1_w_9);
                    float r0_w_9 = asfloat(asint(r0_w_8) | asint(r1_w_10));
                    float4 r2_xyzw_3 = (float4(r3_x_3, r3_y_3, r3_z_2, r3_x_3) * float4(0.5, 0.5, 0.5, 0));
                    float r2_x_3 = r2_xyzw_3.x;
                    float r2_y_3 = r2_xyzw_3.y;
                    float r2_z_4 = r2_xyzw_3.z;
                    r1_xyz_6 = ((r0_w_9.xxxx ? float4(r2_x_3, r2_y_3, r2_z_4, r2_x_3) : float4(r0_x_13, r0_y_11, r0_z_11, r0_x_13))).xyz;
                }
                o.sv_Target0.xyz = r1_xyz_6.xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
    }
}
