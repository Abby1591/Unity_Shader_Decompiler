Shader "Custom/Hyperdrive"
{
    Properties
    {
        _MainTex ("Texture1", 2D) = "" {}
        _Brightness ("Brightness Shift", Range(0, 1)) = 0.007
        _BrightnessFade ("Brightness Fade", Range(0.5, 10)) = 3
        _RedShift ("Red Shift", Range(0, 0.333)) = 0.1
        _ColorShift ("Color Shift", Range(0, 0.01)) = 0.0007
        _Speed ("Speed", Range(0.1, 1)) = 0.6
        _YScale ("Y Scale", Range(0.01, 1)) = 0.271
        _XYScale ("XY Scale", Range(1, 1000)) = 196
        _StarCount ("Star Count", Range(0.001, 0.1)) = 0.04
    }
    SubShader
    {
        Tags { "FORCENOSHADOWCASTING"="true" }
        LOD 0
        Pass
        {
            Tags { "FORCENOSHADOWCASTING"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _MainTex_ST;
                float _BrightnessFade;
                float _Brightness;
                float _RedShift;
                float _ColorShift;
                float _Speed;
                float _YScale;
                float _XYScale;
                float _StarCount;
            };
            cbuffer _UnityPerDrawCB : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _Time;
            };
            cbuffer _UnityPerFrameCB : register(b2)
            {
                float4x4 unity_MatrixVP;
            };
            struct program1Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
            };
            struct program1Output
            {
                float4 sv_Position0 : SV_Position;
                float4 color0 : COLOR0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_Position;
                float4 color0 : COLOR0;
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
                o.color0.xyzw = float4(1, 1, 1, 1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float r0_y_1 = 1;
                float r0_z_1 = mad(-_Time.x, _Speed, -_ColorShift);
                float r0_w_1 = (r0_z_1 + -_ColorShift);
                float2 r1_xz_1 = ((float4(r0_z_1, r0_z_1, r0_w_1, r0_z_1) * float4(300, 0, 300, 0))).xz;
                float r0_z_2 = (r0_w_1 + -_ColorShift);
                float r0_x_1 = (r0_z_2 * 300);
                float r0_z_3 = log2(i.texcoord0.y);
                float r0_z_4 = (r0_z_3 * _YScale);
                float r2_x_1 = exp2(r0_z_4);
                float TEXCOORD0_y_1 = i.texcoord0.x;
                float2 r0_xy_2 = (mad(float4(r2_x_1, TEXCOORD0_y_1, r2_x_1, r2_x_1), _XYScale.xxxx, -float4(r0_x_1, r0_y_1, r0_x_1, r0_x_1))).xy;
                float4 r0_xyzw_5 = frac(r0_xy_2.xxxy);
                float r0_z_5 = r0_xyzw_5.z;
                float r0_w_2 = r0_xyzw_5.w;
                float2 r0_xy_3 = ((-float4(r0_z_5, r0_w_2, r0_z_5, r0_z_5) + r0_xy_2.xyxx)).xy;
                float r0_z_6 = dot(float4(r0_z_5, r0_w_2, r0_z_5, r0_z_5), float4(r0_z_5, r0_w_2, r0_z_5, r0_z_5));
                float r0_z_7 = sqrt(r0_z_6);
                float r0_z_8 = (-r0_z_7 + _BrightnessFade);
                float r0_x_10 = dot(r0_z_8.xxxx, (asfloat(asint((float)((_StarCount >= frac((sin(mad(r0_xy_3.y, 100, r0_xy_3.x)) * 1000))))) & asint(1065353216))).xxxx);
                float r0_y_4 = (i.texcoord0.y + -0.4);
                float r0_y_5 = saturate((r0_y_4 * 1.6666666));
                float r0_z_9 = mad(r0_y_5, -2, 3);
                float r0_y_6 = (r0_y_5 * r0_y_5);
                float r0_y_7 = (r0_y_6 * r0_z_9);
                float r0_z_10 = mad(-_RedShift, 3, 1);
                float r0_w_3 = (r0_z_10 + _RedShift);
                float r0_z_11 = mad(_RedShift, 2, r0_z_10);
                o.sv_Target0.z = (r0_w_3 * ((r0_y_7 * (r0_x_10 * i.texcoord0.y)) * _Brightness));
                float2 r1_yw_1 = (float4(0, 1, 0, 1)).yw;
                float4 r0_xyzw_14 = mad(float4(r2_x_1, r2_x_1, r2_x_1, TEXCOORD0_y_1), _XYScale.xxxx, -float4(r1_xz_1.x, r1_xz_1.x, r1_xz_1.x, r1_yw_1.x));
                float r0_x_14 = r0_xyzw_14.x;
                float r0_w_4 = r0_xyzw_14.w;
                float2 r1_xy_2 = (mad(float4(r2_x_1, TEXCOORD0_y_1, r2_x_1, r2_x_1), _XYScale.xxxx, -float4(r1_xz_1.y, r1_yw_1.y, r1_xz_1.y, r1_xz_1.y))).xy;
                float2 r1_zw_2 = (frac(float4(r0_x_14, r0_x_14, r0_x_14, r0_w_4))).zw;
                float4 r0_xyzw_15 = (float4(r0_x_14, r0_x_14, r0_x_14, r0_w_4) + -r1_zw_2.xxxy);
                float r0_x_15 = r0_xyzw_15.x;
                float r0_w_5 = r0_xyzw_15.w;
                float r1_z_3 = dot(r1_zw_2.xyxx, r1_zw_2.xyxx);
                float r1_z_4 = sqrt(r1_z_3);
                float r1_z_5 = (-r1_z_4 + _BrightnessFade);
                float r0_x_22 = dot(r1_z_5.xxxx, (asfloat(asint((float)((_StarCount >= frac((sin(mad(r0_w_5, 100, r0_x_15)) * 1000))))) & asint(1065353216))).xxxx);
                o.sv_Target0.x = ((r0_y_7 * (r0_x_22 * i.texcoord0.y)) * _Brightness);
                float4 r0_xyzw_25 = frac(r1_xy_2.xxxy);
                float r0_x_25 = r0_xyzw_25.x;
                float r0_w_6 = r0_xyzw_25.w;
                float2 r1_xy_3 = ((-float4(r0_x_25, r0_w_6, r0_x_25, r0_x_25) + r1_xy_2.xyxx)).xy;
                float r0_w_7 = mad(r1_xy_3.y, 100, r1_xy_3.x);
                float r0_w_8 = sin(r0_w_7);
                float r0_w_9 = (r0_w_8 * 1000);
                float r0_w_10 = frac(r0_w_9);
                float r0_w_11 = (_StarCount >= r0_w_10);
                float r0_w_12 = asfloat(asint(r0_w_11) & asint(1065353216));
                float r0_x_32 = ((r0_y_7 * (dot(((sqrt(dot(float4(r0_x_25, r0_w_6, r0_x_25, r0_x_25), float4(r0_x_25, r0_w_6, r0_x_25, r0_x_25))) + _BrightnessFade)).xxxx, r0_w_12.xxxx) * i.texcoord0.y)) * _Brightness);
                o.sv_Target0.y = (r0_z_11 * r0_x_32);
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "VertexLit"
}
