Shader "Hidden/FXAA II"
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
            cbuffer _Globals : register(b0)
            {
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
                float4 texcoord0 : TEXCOORD0;
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
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
                o.texcoord0.zw = (mad(-_MainTex_TexelSize.xxxy, float4(0, 0, 0.75, 0.75), (mad((mad(i.texcoord0.xyxx, float4(2, 2, 0, 0), float4(-1, -1, 0, 0))).xyxx, float4(0.5, 0.5, 0, 0), float4(0.5, 0.5, 0, 0))).xxxy)).zw;
                o.texcoord0.xy = (i.texcoord0.xyxx).xy;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float4 r0_xyzw_1 = mad(_MainTex_TexelSize.xyxy, float4(1, 0, 0, 1), i.texcoord0.zwzw);
                float4 r1_xyzw_1 = t0.Sample(s0, r0_xyzw_1.xyxx);
                float4 r0_xyzw_2 = t0.Sample(s0, r0_xyzw_1.zwzz);
                float r0_x_3 = dot(r0_xyzw_2.xyzx, float4(0.299, 0.587, 0.114, 0));
                float r0_y_3 = dot(r1_xyzw_1.xyzx, float4(0.299, 0.587, 0.114, 0));
                float2 r0_zw_3 = ((i.texcoord0.zzzw + _MainTex_TexelSize.xxxy)).zw;
                float4 r1_xyzw_2 = t0.Sample(s0, r0_zw_3.xyxx);
                float r0_z_4 = dot(r1_xyzw_2.xyzx, float4(0.299, 0.587, 0.114, 0));
                float r0_w_4 = (r0_z_4 + r0_y_3);
                float4 r1_xyzw_3 = t0.Sample(s0, i.texcoord0.zwzz);
                float r1_x_4 = dot(r1_xyzw_3.xyzx, float4(0.299, 0.587, 0.114, 0));
                float r1_y_4 = (r0_x_3 + r1_x_4);
                float2 r2_yw_1 = ((-r0_w_4.xxxx + r1_y_4.xxxx)).yw;
                float r0_w_5 = (r0_y_3 + r1_x_4);
                float r1_y_5 = (r0_z_4 + r0_x_3);
                float r1_y_6 = (r0_w_5 + -r1_y_5);
                float r0_w_6 = (r0_x_3 + r0_w_5);
                float r0_w_7 = (r0_z_4 + r0_w_6);
                float r0_w_8 = (r0_w_7 * 0.03125);
                float r0_w_9 = max(r0_w_8, 0.0078125);
                float r1_z_4 = min(abs(r2_yw_1.y), abs(r1_y_6));
                float2 r2_xz_1 = (-r1_y_6.xxxx).xz;
                float r0_w_10 = (r0_w_9 + r1_z_4);
                float r0_w_11 = ((float4(1, 1, 1, 1) / r0_w_10)).w;
                float4 r2_xyzw_5 = (min(max((r0_w_11.xxxx * float4(r2_xz_1.x, r2_yw_1.x, r2_xz_1.y, r2_yw_1.y)), float4(-8, -8, -8, -8)), float4(8, 8, 8, 8)) * _MainTex_TexelSize.xyxy);
                float4 r3_xyzw_1 = mad(r2_xyzw_5, float4(-0.5, -0.5, 0.5, 0.5), i.texcoord0.xyxy);
                float4 r2_xyzw_6 = mad(r2_xyzw_5.zwzw, float4(-0.16666667, -0.16666667, 0.16666667, 0.16666667), i.texcoord0.xyxy);
                float4 r4_xyzw_1 = t0.Sample(s0, r3_xyzw_1.xyxx);
                float4 r3_xyzw_2 = t0.Sample(s0, r3_xyzw_1.zwzz);
                float4 r1_xyzw_7 = (r3_xyzw_2.xxyz + r4_xyzw_1.xxyz);
                float r1_y_7 = r1_xyzw_7.y;
                float r1_z_5 = r1_xyzw_7.z;
                float r1_w_4 = r1_xyzw_7.w;
                float4 r1_xyzw_8 = (float4(r1_y_7, r1_y_7, r1_z_5, r1_w_4) * float4(0, 0.25, 0.25, 0.25));
                float r1_y_8 = r1_xyzw_8.y;
                float r1_z_6 = r1_xyzw_8.z;
                float r1_w_5 = r1_xyzw_8.w;
                float4 r3_xyzw_3 = t0.Sample(s0, r2_xyzw_6.xyxx);
                float4 r2_xyzw_7 = t0.Sample(s0, r2_xyzw_6.zwzz);
                float3 r2_xyz_8 = ((r2_xyzw_7.xyzx + r3_xyzw_3.xyzx)).xyz;
                float4 r1_xyzw_9 = mad(r2_xyz_8.xxyz, float4(0, 0.25, 0.25, 0.25), float4(r1_y_8, r1_y_8, r1_z_6, r1_w_5));
                float r1_y_9 = r1_xyzw_9.y;
                float r1_z_7 = r1_xyzw_9.z;
                float r1_w_6 = r1_xyzw_9.w;
                float r0_w_12 = dot(float4(r1_y_9, r1_z_7, r1_w_6, r1_y_9), float4(0.299, 0.587, 0.114, 0));
                float r2_w_8 = min(r0_z_4, r0_x_3);
                float r0_z_5 = min(r0_y_3, r1_x_4);
                float r0_y_4 = max(r0_y_3, r1_x_4);
                float r0_y_5 = min(r2_w_8, r0_z_5);
                float4 r3_xyzw_4 = t0.Sample(s0, i.texcoord0.xyxx);
                float r0_z_6 = dot(r3_xyzw_4.xyzx, float4(0.299, 0.587, 0.114, 0));
                float r0_y_6 = min(r0_y_5, r0_z_6);
                float r0_x_6 = max(max(max(r0_z_4, r0_x_3), r0_y_4), r0_z_6);
                float2 r0_xy_7 = ((float4(r0_x_6, r0_w_12, r0_x_6, r0_x_6) < float4(r0_w_12, r0_y_6, r0_w_12, r0_w_12))).xy;
                o.sv_Target0.xyz = (((asfloat(asint(r0_xy_7.x) | asint(r0_xy_7.y))).xxxx ? ((r2_xyz_8.xyzx * float4(0.5, 0.5, 0.5, 0))).xyzx : float4(r1_y_9, r1_z_7, r1_w_6, r1_y_9))).xyz;
                o.sv_Target0.w = 0;
                return o;
            }
            ENDHLSL
        }
    }
}
