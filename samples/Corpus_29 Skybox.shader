Shader "Corpus/29 Skybox"
{
    Properties
    {
        _Tex ("Cubemap", 2D) = "" {}
        _Tint ("Tint", Color) = (0.5,0.5,0.5,0.5)
        _Exposure ("Exposure", Float) = 1
        _Rotation ("Rotation", Range(0, 360)) = 0
        _GroundColor ("Ground Color", Color) = (0.1,0.1,0.1,1)
        _GroundHeight ("Ground Height", Range(-1, 1)) = -0.2
    }
    SubShader
    {
        Tags { "PreviewType"="Skybox" "QUEUE"="Background" "RenderType"="Background" }
        LOD 0
        Pass
        {
            Tags { "PreviewType"="Skybox" "QUEUE"="Background" "RenderType"="Background" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            HLSLPROGRAM
            cbuffer _UnityPerDrawCB_b0
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float _Exposure : packoffset(c4.x);
                float _Rotation : packoffset(c4.y);
                float4 _GroundColor : packoffset(c5);
                float _GroundHeight : packoffset(c6.x);
            };
            cbuffer _UnityPerFrameCB_b1
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_Tex;
            TextureCube _Tex;
            struct program1Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
            };
            struct program1Output
            {
                float4 sv_Position0 : SV_POSITION;
                float3 texcoord0 : TEXCOORD0;
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_POSITION;
                float3 texcoord0 : TEXCOORD0;
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
                o.texcoord0.xyz = i.position0.xyz;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float r0_x_1 = (_Rotation * 0.017453292);
                float r1_x_1 = sin(-r0_x_1);
                float r0_x_2 = sin(r0_x_1);
                float r0_y_1 = dot(i.texcoord0.xyzx, i.texcoord0.xyzx);
                float r0_y_2 = rsqrt(r0_y_1);
                float3 r2_yzw_1 = ((r0_y_2.xxxx * i.texcoord0.xxyz)).yzw;
                float r0_y_3 = mad(i.texcoord0.y, r0_y_2, -_GroundHeight);
                float r0_y_4 = saturate((r0_y_3 * 5));
                float r1_y_1 = cos(r0_x_2);
                float r1_z_1 = r0_x_2;
                float r3_z_1 = dot(float4(r1_z_1, r1_y_1, r1_z_1, r1_z_1), r2_yzw_1.xzxx);
                float r3_x_1 = dot(float4(r1_y_1, r1_x_1, r1_y_1, r1_y_1), r2_yzw_1.xzxx);
                float r3_y_1 = r2_yzw_1.y;
                float4 r1_xyzw_2 = _Tex.Sample(sampler_Tex, (float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1)).xyz);
                                float4 r0_xyzw_9 = (r1_xyzw_2.xxyz * ((pow(mad(unity_ObjectToWorld[2].w, (r1_xyzw_2.w + -1), 1), unity_ObjectToWorld[2].y) * unity_ObjectToWorld[2].x)).xxxx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_1 = r0_xyzw_9.z;
                float r0_w_1 = r0_xyzw_9.w;
                o.sv_Target0.w = r1_xyzw_2.w;
                float4 r0_xyzw_10 = mad(float4(r0_x_9, r0_x_9, r0_z_1, r0_w_1), ((unity_ObjectToWorld[3].xyzx * _Exposure.xxxx)).xxyz, -_GroundColor.xxyz);
                float r0_x_10 = r0_xyzw_10.x;
                float r0_z_2 = r0_xyzw_10.z;
                float r0_w_2 = r0_xyzw_10.w;
                float r0_y_5 = (r0_y_4 * r0_y_4);
                float r0_y_6 = (r0_y_5 * mad(r0_y_4, -2, 3));
                float4 r0_xyzw_11 = mad(r0_y_6.xxxx, float4(r0_x_10, r0_z_2, r0_w_2, r0_x_10), _GroundColor.xyzx);
                float r0_x_11 = r0_xyzw_11.x;
                float r0_y_7 = r0_xyzw_11.y;
                float r0_z_3 = r0_xyzw_11.z;
                float4 r0_xyzw_12 = max(float4(r0_x_11, r0_y_7, r0_z_3, r0_x_11), float4(0, 0, 0, 0));
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_8 = r0_xyzw_12.y;
                float r0_z_4 = r0_xyzw_12.z;
                float4 r0_xyzw_13 = log2(float4(r0_x_12, r0_y_8, r0_z_4, r0_x_12));
                float r0_x_13 = r0_xyzw_13.x;
                float r0_y_9 = r0_xyzw_13.y;
                float r0_z_5 = r0_xyzw_13.z;
                float4 r0_xyzw_14 = (float4(r0_x_13, r0_y_9, r0_z_5, r0_x_13) * float4(0.41666666, 0.41666666, 0.41666666, 0));
                float r0_x_14 = r0_xyzw_14.x;
                float r0_y_10 = r0_xyzw_14.y;
                float r0_z_6 = r0_xyzw_14.z;
                float4 r0_xyzw_15 = exp2(float4(r0_x_14, r0_y_10, r0_z_6, r0_x_14));
                float r0_x_15 = r0_xyzw_15.x;
                float r0_y_11 = r0_xyzw_15.y;
                float r0_z_7 = r0_xyzw_15.z;
                float4 r0_xyzw_16 = mad(float4(r0_x_15, r0_y_11, r0_z_7, r0_x_15), float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0));
                float r0_x_16 = r0_xyzw_16.x;
                float r0_y_12 = r0_xyzw_16.y;
                float r0_z_8 = r0_xyzw_16.z;
                o.sv_Target0.xyz = (max(float4(r0_x_16, r0_y_12, r0_z_8, r0_x_16), float4(0, 0, 0, 0))).xyz;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Skybox/Procedural"
}
