Shader "Corpus/24 Flow Control"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "" {}
        _Iterations ("Iterations", Float) = 8
        _Threshold ("Threshold", Range(0, 1)) = 0.5
        _Mode ("Mode", Float) = 0
    }
    SubShader
    {
        Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
        LOD 0
        Pass
        {
            Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
            Cull Off
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _UnityPerDrawCB_b0
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
            };
            cbuffer _UnityPerFrameCB_b1
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program1Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
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
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float r0_y_2 = r0_xyzw_1.x;
                float r0_z_2 = 0;
                float2 r0_yz_3 = float2(r0_y_2, r0_z_2);
                float r0_y_15;
                float r0_z_8;
                [loop]
                while (true)
                {
                    if ((r0_yz_3.y >= unity_ObjectToWorld[2])) break;
                    r0_y_15 = mad(r0_yz_3.x, 0.5, 0.25);
                    r0_z_8 = (r0_yz_3.y + 1);
                    r0_yz_3 = float2(r0_y_15, r0_z_8);
                }
                float r0_x_6 = mad(mad(mad(mad(mad(r0_yz_3.x, 0.5, 0.125), 0.5, 0.125), 0.5, 0.125), 0.5, 0.125), 0.5, 0.125);
                float r0_x_9 = mad(mad(mad(r0_x_6, 0.5, 0.125), 0.5, 0.125), 0.5, 0.125);
                float r0_y_4 = (unity_ObjectToWorld[2] < r0_x_9);
                float r0_z_5 = r0_yz_3.y;
                if (r0_y_4)
                {
                    float r0_z_4 = (r0_x_9 + r0_x_9);
                    r0_z_5 = r0_z_4;
                }
                float r0_x_11 = (r0_y_4 ? r0_z_5 : (r0_x_9 * 0.5));
                float r0_y_5 = (0.5 < r0_x_11);
                float r0_z_6 = (-r0_x_11 + 1);
                float r0_x_12 = (r0_y_5 ? r0_z_6 : r0_x_11);
                switch (unity_ObjectToWorld[2])
                {
                case 0:
                    float r0_y_10 = (r0_x_12 + 0.1);
                    float r0_y_11 = r0_y_10;
                    break;
                case 1:
                    float r0_y_9 = (r0_x_12 + 0.2);
                    r0_y_11 = r0_y_9;
                    break;
                case 2:
                    float r0_y_8 = (r0_x_12 + 0.3);
                    r0_y_11 = r0_y_8;
                    break;
                case 3:
                    float r0_y_7 = (r0_x_12 + 0.4);
                    r0_y_11 = r0_y_7;
                    break;
                default:
                    float r0_y_6 = (r0_x_12 + 0.5);
                    r0_y_11 = r0_y_6;
                    break;
                    float r0_z_7 = unity_ObjectToWorld[2];
                    float r1_x_4 = 0;
                    float r0_x_14 = r0_y_11;
                    float r1_y_2;
                    float r2_y_1;
                    float r1_y_3;
                    float r1_z_2;
                    float r1_w_2;
                    float2 r1_zw_3;
                    [loop]
                    while (true)
                    {
                        r1_y_2 = (r1_x_4 >= 4);
                        if (r1_y_2) break;
                        r2_y_1 = (float)(r1_x_4);
                        r1_y_3 = r0_z_7;
                        r1_z_2 = r0_x_14;
                        r1_w_2 = 0;
                        r1_zw_3 = float2(r1_z_2, r1_w_2);
                        float r2_z_3;
                        float r2_z_4;
                        float r2_z_5;
                        float r2_x_1;
                        float r2_x_2;
                        float r2_z_6;
                        float4 r3_xyzw_1;
                        float r1_z_4;
                        float r1_w_4;
                        [loop]
                        while (true)
                        {
                            r2_z_3 = (r1_zw_3.y >= 4);
                            if (r2_z_3) break;
                            r2_z_4 = (r1_x_4 * r1_zw_3.y);
                            r2_z_5 = ((float4(r0_z_7, r0_z_7, r0_x_14, r0_z_7) < r2_z_4)).z;
                            if (r2_z_5)
                            {
                                o.sv_Target0.xyz = (r1_zw_3.xxxx).xyz;
                                o.sv_Target0.w = 1;
                                return o;
                            }
                            r2_x_1 = (float)(r1_zw_3.y);
                            float4 r2_xyzw_2 = mad(float4(r2_x_1, r2_x_1, r2_y_1, r2_x_1), float4(0.01, 0, 0.01, 0), i.texcoord0.xxyx);
                            r2_x_2 = r2_xyzw_2.x;
                            r2_z_6 = r2_xyzw_2.z;
                            r3_xyzw_1 = _MainTex.Sample(sampler_MainTex, (float4(r2_x_2, r2_z_6, r2_x_2, r2_x_2)).xy);
                            r1_z_4 = mad(r3_xyzw_1.x, 0.01, r1_zw_3.x);
                            r1_w_4 = (r1_zw_3.y + 1);
                            r1_zw_3 = float2(r1_z_4, r1_w_4);
                        }
                        r1_x_4 = (r1_x_4 + 1);
                        r0_x_14 = r1_zw_3.x;
                    }
                    float r0_x_20 = frac(mad(frac(mad(frac(mad(r0_x_14, 1.37, 0.11)), 1.37, 0.11)), 1.37, 0.11));
                    float r0_y_12 = (r0_xyzw_1.w + -unity_ObjectToWorld[2]);
                    float r0_y_13 = (r0_y_12 < 0);
                    if (r0_y_13) discard;
                    float r0_y_14 = (r0_x_20 < 0.01);
                    if (r0_y_14) discard;
                    o.sv_Target0.xyz = (frac(r0_x_20.xxxx)).xyz;
                    o.sv_Target0.w = 1;
                    return o;
                }
            }
            ENDHLSL
        }
    }
    Fallback "Diffuse"
}
