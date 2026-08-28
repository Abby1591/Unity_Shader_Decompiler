Shader "Custom/Horizontal Skybox"
{
    Properties
    {
        _Color1 ("Top Color", Color) = (1,1,1,0)
        _Color2 ("Horizon Color", Color) = (1,1,1,0)
        _Color3 ("Bottom Color", Color) = (1,1,1,0)
        _Exponent1 ("Exponent Factor for Top Half", Float) = 1
        _Exponent2 ("Exponent Factor for Bottom Half", Float) = 1
        _Intensity ("Intensity Amplifier", Float) = 1
        _Angle ("Angle", Float) = 0
    }
    SubShader
    {
        Tags { "QUEUE"="Background" "RenderType"="Background" }
        LOD 0
        Pass
        {
            Tags { "QUEUE"="Background" "RenderType"="Background" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            HLSLPROGRAM
            cbuffer _UnityPerDrawCB_b0
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4 _Color3 : packoffset(c4);
                float _Intensity : packoffset(c5.x);
                float _Exponent1 : packoffset(c5.y);
                float _Exponent2 : packoffset(c5.z);
            };
            cbuffer _UnityPerFrameCB_b1
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            struct program1Input
            {
                float4 position0 : POSITION0;
                float3 texcoord0 : TEXCOORD0;
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
                o.texcoord0.xz = (i.texcoord0.yyyy).xz;
                o.texcoord0.y = 0.5;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float r0_x_2 = rsqrt(dot(i.texcoord0.xyzx, i.texcoord0.xyzx));
                float r0_y_1 = mad(-i.texcoord0.x, r0_x_2, 1);
                float r0_x_3 = mad(i.texcoord0.x, r0_x_2, 1);
                float4 r0_xyzw_4 = min(float4(r0_x_3, r0_y_1, r0_x_3, r0_x_3), float4(1, 1, 0, 0));
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_2 = r0_xyzw_4.y;
                                float r0_x_7 = pow(r0_x_4, _Exponent2);
                float r0_y_3 = log2(r0_y_2);
                float r0_y_4 = (r0_y_3 * _Exponent1);
                float r0_y_5 = exp2(r0_y_4);
                float4 r0_xyzw_8 = (-float4(r0_x_7, r0_y_5, r0_x_7, r0_x_7) + float4(1, 1, 0, 0));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_6 = r0_xyzw_8.y;
                float r0_z_1 = (-r0_y_6 + 1);
                float r0_z_2 = (-r0_x_8 + r0_z_1);
                float4 r0_xyzw_9 = mad(_Color3, r0_x_8.xxxx, mad(unity_ObjectToWorld[2], r0_y_6.xxxx, (r0_z_2.xxxx * unity_ObjectToWorld[3])));
                o.sv_Target0.xyzw = (r0_xyzw_9 * _Intensity.xxxx);
                return o;
            }
            ENDHLSL
        }
    }
}
