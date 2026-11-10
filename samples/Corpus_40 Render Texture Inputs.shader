Shader "Corpus/40 Render Texture Inputs"
{
    Properties
    {
        _MainTex ("Source", 2D) = "" {}
        _Intensity ("Intensity", Range(0, 4)) = 1
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
            };
            cbuffer _UnityPerFrameCB_b1
            {
                float4 _Time : packoffset(c0);
                float4 _SinTime : packoffset(c1);
                float4 _CosTime : packoffset(c2);
                float4 unity_DeltaTime : packoffset(c3);
                float3 _WorldSpaceCameraPos : packoffset(c4);
                float4 _ProjectionParams : packoffset(c5);
                float4 _ScreenParams : packoffset(c6);
                float4 _ZBufferParams : packoffset(c7);
                float4 unity_OrthoParams : packoffset(c8);
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            cbuffer _UnityPerCameraRareCB_b2
            {
                float4 unity_CameraWorldClipPlanes[6];
                float4x4 unity_CameraInvProjection;
                float4x4 unity_CameraToWorld;
                float4 cb2_values[1];
            };
            cbuffer _UnityPerFrameCB_b3
            {
                float4x4 unity_MatrixV : packoffset(c9);
            };
            SamplerState sampler_MainTex;
            SamplerState sampler_linear_clamp1;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_linear_clamp3;
            SamplerState sampler_linear_clamp4;
            Texture2D _MainTex;
            Texture2D t1;
            Texture2D t2;
            Texture2D t3;
            Texture2D t4;
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
                float4 r0_xyzw_1 = t2.Sample(sampler_linear_clamp2, (i.texcoord0.xyxx).xy);
                float3 r1_xyz_1 = (mad(r0_xyzw_1.xyzx, float4(3.5554, 3.5554, 0, 0), float4(-1.7777, -1.7777, 1, 0))).xyz;
                float r0_y_2 = dot(r1_xyz_1.xyzx, r1_xyz_1.xyzx);
                float r0_y_3 = (2 / r0_y_2);
                float4 r1_xyzw_2 = t3.Sample(sampler_linear_clamp3, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = t4.Sample(sampler_linear_clamp4, (i.texcoord0.xyxx).xy);
                float4 r0_xyzw_4 = (i.texcoord0.xxyx * _ScreenParams.xxyx);
                float r0_y_4 = r0_xyzw_4.y;
                float r0_z_2 = r0_xyzw_4.z;
                float r0_y_5 = dot(float4(r0_y_4, r0_z_2, r0_y_4, r0_y_4), float4(0.001, 0.001, 0, 0));
                float r0_y_6 = (_ProjectionParams.z + _ProjectionParams.y);
                float r0_y_7 = (r0_y_6 + _ZBufferParams.x);
                float r0_y_8 = (r0_y_7 + _ZBufferParams.y);
                float r0_y_9 = (r0_y_8 + _ZBufferParams.z);
                float r0_y_10 = (r0_y_9 + _ZBufferParams.w);
                float4 r1_xyzw_4 = t1.Sample(sampler_linear_clamp1, (i.texcoord0.xyxx).xy);
                float4 r0_xyzw_11 = mad(_ZBufferParams.xxzx, r1_xyzw_4.xxxx, _ZBufferParams.yywy);
                float r0_y_11 = r0_xyzw_11.y;
                float r0_z_3 = r0_xyzw_11.z;
                float4 r0_xyzw_12 = (float4(1, 1, 1, 1) / float4(r0_y_11, r0_y_11, r0_z_3, r0_y_11));
                float r0_y_12 = r0_xyzw_12.y;
                float r0_z_4 = r0_xyzw_12.z;
                float r0_y_13 = (r0_z_4 + r0_y_12);
                float r0_y_14 = (r0_y_13 + _WorldSpaceCameraPos.x);
                float r0_y_15 = (r0_y_14 + -unity_MatrixV[0].z);
                float r0_y_16 = (r0_y_15 + cb2_values[0].x);
                float r0_x_8 = (r0_y_16 + (r0_y_10 + (r0_y_5 + ((mad(r0_y_3, r1_xyz_1.x, dot(r0_xyzw_1.zwzz, float4(1, 0.003921569, 0, 0))) + r1_xyzw_2.x) + r1_xyzw_3.x))));
                float r0_y_17 = (unity_DeltaTime.x + unity_OrthoParams.x);
                float r0_y_18 = (r0_y_17 + _ProjectionParams.x);
                float4 r0_xyzw_19 = mad(i.texcoord0.xxyx, float4(0, 2, 2, 0), float4(0, -1, -1, 0));
                float r0_y_19 = r0_xyzw_19.y;
                float r0_z_5 = r0_xyzw_19.z;
                float4 r0_xyzw_20 = mad(unity_CameraInvProjection[0].xxyz, r0_y_19.xxxx, ((r0_z_5.xxxx * unity_CameraInvProjection[1].xyzx)).xxyz);
                float r0_y_20 = r0_xyzw_20.y;
                float r0_z_6 = r0_xyzw_20.z;
                float r0_w_2 = r0_xyzw_20.w;
                float4 r0_xyzw_21 = (float4(r0_y_20, r0_y_20, r0_z_6, r0_w_2) + unity_CameraInvProjection[2].xxyz);
                float r0_y_21 = r0_xyzw_21.y;
                float r0_z_7 = r0_xyzw_21.z;
                float r0_w_3 = r0_xyzw_21.w;
                float4 r0_xyzw_22 = (float4(r0_y_21, r0_y_21, r0_z_7, r0_w_3) + unity_CameraInvProjection[3].xxyz);
                float r0_y_22 = r0_xyzw_22.y;
                float r0_z_8 = r0_xyzw_22.z;
                float r0_w_4 = r0_xyzw_22.w;
                float r0_z_9 = (r0_z_8 * unity_CameraToWorld[1].x);
                float r0_y_23 = mad(unity_CameraToWorld[0].x, r0_y_22, r0_z_9);
                float r0_y_24 = mad(unity_CameraToWorld[2].x, r0_w_4, r0_y_23);
                float r0_y_25 = (r0_y_24 + _Time.x);
                float r0_y_26 = (r0_y_25 + _SinTime.x);
                float r0_y_27 = (r0_y_26 + _CosTime.x);
                float4 r1_xyzw_6 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r0_xyzw_13 = mad(r1_xyzw_6.xyzx, (mad(((r0_y_27 + (r0_y_18 + r0_x_8)) * unity_ObjectToWorld[3]), 0.01, 1)).xxxx, -r1_xyzw_6.xyzx);
                float r0_x_13 = r0_xyzw_13.x;
                float r0_y_28 = r0_xyzw_13.y;
                float r0_z_10 = r0_xyzw_13.z;
                o.sv_Target0.xyz = (mad(float4(r0_x_13, r0_y_28, r0_z_10, r0_x_13), float4(0.5, 0.5, 0.5, 0), r1_xyzw_6.xyzx)).xyz;
                o.sv_Target0.w = r1_xyzw_6.w;
                return o;
            }
            ENDHLSL
        }
    }
}
