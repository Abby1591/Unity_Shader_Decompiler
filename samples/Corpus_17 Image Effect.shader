Shader "Corpus/17 Image Effect"
{
    Properties
    {
        _MainTex ("Source", 2D) = "" {}
        _Intensity ("Intensity", Range(0, 4)) = 1
        _BlurSize ("Blur Size", Range(0, 8)) = 1
        _DepthStrength ("Depth Strength", Range(0, 4)) = 1
        _Vignette ("Vignette", Range(0, 2)) = 0.5
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
            cbuffer _UnityPerDrawCB_b0
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float _Intensity : packoffset(c4.x);
                float _BlurSize : packoffset(c4.y);
                float _DepthStrength : packoffset(c4.z);
                float _Vignette : packoffset(c4.w);
            };
            cbuffer _UnityPerFrameCB_b1
            {
                float4 _ZBufferParams : packoffset(c7);
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_linear_clamp3;
            Texture2D _MainTex;
            Texture2D t1;
            Texture2D t2;
            Texture2D t3;
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
                #define LinearEyeDepth(d) (1.0 / (_ZBufferParams.z * (d) + _ZBufferParams.w))
                float2 r0_xy_1 = ((unity_ObjectToWorld[2].xyxx * _BlurSize.xxxx)).xy;
                float r0_z_1 = 0;
                float r1_y_1 = (-i.texcoord0.y + 1);
                float r1_y_2 = ((unity_ObjectToWorld[2].y < 0) ? r1_y_1 : i.texcoord0.y);
                float TEXCOORD0_x_2 = i.texcoord0.x;
                float4 r2_xyzw_1 = (float4(r0_xy_1.x, r0_z_1, r0_z_1, r0_xy_1.y) + float4(TEXCOORD0_x_2, r1_y_2, TEXCOORD0_x_2, r1_y_2));
                float4 r3_xyzw_1 = _MainTex.Sample(sampler_MainTex, (r2_xyzw_1.xyxx).xy);
                float4 r2_xyzw_2 = _MainTex.Sample(sampler_MainTex, (r2_xyzw_1.zwzz).xy);
                float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (float4(TEXCOORD0_x_2, r1_y_2, TEXCOORD0_x_2, TEXCOORD0_x_2)).xy);
                float r0_w_1 = -r0_xy_1.x;
                float2 r0_zw_2 = ((float4(r0_w_1, r0_w_1, r0_w_1, r0_z_1) + float4(TEXCOORD0_x_2, TEXCOORD0_x_2, TEXCOORD0_x_2, r1_y_2))).zw;
                float4 r5_xyzw_1 = _MainTex.Sample(sampler_MainTex, (r0_zw_2.xyxx).xy);
                float4 r0_xyzw_3 = _MainTex.Sample(sampler_MainTex, ((mad(float4(r0_z_1, r0_xy_1.y, r0_z_1, r0_z_1), float4(1, -1, 0, 0), float4(TEXCOORD0_x_2, r1_y_2, TEXCOORD0_x_2, TEXCOORD0_x_2))).xyxx).xy);
                float3 r0_xyz_4 = ((r0_xyzw_3.xyzx + ((r2_xyzw_2.xyzx + (((mad(r4_xyzw_1.xyzx, float4(4, 4, 4, 0), r3_xyzw_1.xyzx)).xyzx + r5_xyzw_1.xyzx)).xyzx)).xyzx)).xyz;
                float4 r2_xyzw_4 = t1.Sample(sampler_linear_clamp1, (float4(TEXCOORD0_x_2, r1_y_2, TEXCOORD0_x_2, TEXCOORD0_x_2)).xy);
                float r0_w_5 = LinearEyeDepth(r2_xyzw_4.x);
                float r0_w_6 = (r0_w_5 * _DepthStrength);
                float r0_w_7 = saturate((r0_w_6 * 0.1));
                float4 r2_xyzw_5 = t2.Sample(sampler_linear_clamp2, (float4(TEXCOORD0_x_2, r1_y_2, TEXCOORD0_x_2, TEXCOORD0_x_2)).xy);
                float4 r1_xyzw_3 = t3.Sample(sampler_linear_clamp3, (float4(TEXCOORD0_x_2, r1_y_2, TEXCOORD0_x_2, TEXCOORD0_x_2)).xy);
                float4 r1_xyzw_4 = (r1_xyzw_3.xyxx * unity_ObjectToWorld[3].xyxx);
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_4 = r1_xyzw_4.y;
                float r1_z_2 = r1_xyzw_4.z;
                float3 r2_xyz_6 = (mad(r2_xyzw_5.xyzx, float4(3.5554, 3.5554, 0, 0), float4(-1.7777, -1.7777, 1, 0))).xyz;
                float r0_w_8 = dot(r2_xyz_6.xyzx, r2_xyz_6.xyzx);
                float r0_w_9 = (2 / r0_w_8);
                float2 r2_xy_7 = ((r2_xyz_6.xyxx * r0_w_9.xxxx)).xy;
                float r2_z_7 = (r0_w_9 + -1);
                float3 r0_xyz_7 = (mad((mad(r0_w_7.xxxx, (mad(r0_xyz_4.xyzx, float4(0.125, 0.125, 0.125, 0), -r4_xyzw_1.xyzx)).xyzx, r4_xyzw_1.xyzx)).xyzx, _Intensity.xxxx, ((float4(r2_xy_7.x, r2_xy_7.y, r2_z_7, r2_xy_7.x) * float4(0.01, 0.01, 0.01, 0))).xyzx)).xyz;
                float3 r0_xyz_8 = (mad(float4(r1_x_4, r1_y_4, r1_z_2, r1_x_4), float4(0.1, 0.1, 0.1, 0), r0_xyz_7.xyzx)).xyz;
                float2 r1_xy_5 = ((i.texcoord0.xyxx + float4(-0.5, -0.5, 0, 0))).xy;
                float r0_w_10 = dot(r1_xy_5.xyxx, r1_xy_5.xyxx);
                float r0_w_11 = sqrt(r0_w_10);
                float r0_w_12 = (r0_w_11 + -0.2);
                float r0_w_13 = saturate((r0_w_12 * _Vignette));
                float r0_w_14 = (-r0_w_13 + 1);
                float4 r1_xyzw_6 = (r0_w_14.xxxx * r0_xyz_8.xyzx);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_6 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                float3 r0_xyz_13 = (((log2((max(((float4(r1_x_6, r1_y_6, r1_z_3, r1_x_6) / (mad(r0_xyz_8.xyzx, r0_w_14.xxxx, float4(1, 1, 1, 0))).xyzx)).xyzx, float4(0, 0, 0, 0))).xyzx)).xyzx * float4(0.41666666, 0.41666666, 0.41666666, 0))).xyz;
                o.sv_Target0.xyz = (max((mad((exp2(r0_xyz_13.xyzx)).xyzx, float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0))).xyzx, float4(0, 0, 0, 0))).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
    }
}
