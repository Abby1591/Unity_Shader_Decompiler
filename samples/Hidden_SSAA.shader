Shader "Hidden/SSAA"
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
            cbuffer _GlobalsCB_b0
            {
                float4 _MainTex_TexelSize : packoffset(c2);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
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
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float2 texcoord4 : TEXCOORD4;
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float2 texcoord4 : TEXCOORD4;
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
                float2 r0_yz_5 = ((_MainTex_TexelSize.yyxy * float4(0, 1.75, 1.75, 0))).yz;
                float2 r0_xw_5 = (float4(0, 0, 0, 0)).xw;
                o.texcoord0.xy = ((-float4(r0_xw_5.x, r0_yz_5.x, r0_xw_5.x, r0_xw_5.x) + i.texcoord0.xyxx)).xy;
                o.texcoord1.xy = ((-float4(r0_yz_5.y, r0_xw_5.y, r0_yz_5.y, r0_yz_5.y) + i.texcoord0.xyxx)).xy;
                o.texcoord2.xy = ((float4(r0_yz_5.y, r0_xw_5.y, r0_yz_5.y, r0_yz_5.y) + i.texcoord0.xyxx)).xy;
                o.texcoord3.xy = ((float4(r0_xw_5.x, r0_yz_5.x, r0_xw_5.x, r0_xw_5.x) + i.texcoord0.xyxx)).xy;
                o.texcoord4.xy = (i.texcoord0.xyxx).xy;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord1.xyxx).xy);
                float r0_y_2 = dot(r1_xyzw_1.xyzx, float4(0.22, 0.707, 0.071, 0));
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord2.xyxx).xy);
                float r0_z_2 = dot(r1_xyzw_2.xyzx, float4(0.22, 0.707, 0.071, 0));
                float4 r1_xyzw_3 = _MainTex.Sample(sampler_MainTex, (i.texcoord3.xyxx).xy);
                float r0_w_2 = dot(r1_xyzw_3.xyzx, float4(0.22, 0.707, 0.071, 0));
                float r1_x_4 = (-r0_w_2 + dot(r0_xyzw_1.xyzx, float4(0.22, 0.707, 0.071, 0)));
                float r1_y_4 = (-r0_y_2 + r0_z_2);
                float r0_x_5 = sqrt(dot(float4(r1_x_4, r1_y_4, r1_x_4, r1_x_4), float4(r1_x_4, r1_y_4, r1_x_4, r1_x_4)));
                float r0_y_3 = (r0_x_5 < 0.0625);
                if (r0_y_3)
                {
                    o.sv_Target0.xyzw = _MainTex.Sample(sampler_MainTex, (i.texcoord4.xyxx).xy);
                    o.sv_Target0.xyzw = o.sv_Target0.xyzw;
                }
                else
                {
                    float4 r0_xyzw_6 = (_MainTex_TexelSize.xyxx / r0_x_5.xxxx);
                    float r0_x_6 = r0_xyzw_6.x;
                    float r0_y_4 = r0_xyzw_6.y;
                    float2 r0_zw_3 = ((float4(r0_x_6, r0_x_6, r0_x_6, r0_y_4) * float4(r1_x_4, r1_x_4, r1_x_4, r1_y_4))).zw;
                    float4 r2_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord4.xyxx).xy);
                    float2 r1_zw_4 = (mad(r0_zw_3.xxxy, float4(0, 0, 0.5, 0.5), i.texcoord4.xxxy)).zw;
                    float4 r3_xyzw_1 = _MainTex.Sample(sampler_MainTex, (r1_zw_4.xyxx).xy);
                    float2 r0_zw_4 = (mad(-r0_zw_3.xxxy, float4(0, 0, 0.5, 0.5), i.texcoord4.xxxy)).zw;
                    float4 r4_xyzw_1 = _MainTex.Sample(sampler_MainTex, (r0_zw_4.xyxx).xy);
                    float2 r0_zw_5 = (mad(float4(r1_x_4, r1_x_4, r1_x_4, r1_y_4), float4(r0_x_6, r0_x_6, r0_x_6, r0_y_4), i.texcoord4.xxxy)).zw;
                    float4 r5_xyzw_1 = _MainTex.Sample(sampler_MainTex, (r0_zw_5.xyxx).xy);
                    float4 r0_xyzw_7 = mad(-float4(r1_x_4, r1_y_4, r1_x_4, r1_x_4), float4(r0_x_6, r0_y_4, r0_x_6, r0_x_6), i.texcoord4.xyxx);
                    float r0_x_7 = r0_xyzw_7.x;
                    float r0_y_5 = r0_xyzw_7.y;
                    float4 r0_xyzw_8 = _MainTex.Sample(sampler_MainTex, (float4(r0_x_7, r0_y_5, r0_x_7, r0_x_7)).xy);
                    float4 r0_xyzw_9 = mad(r0_xyzw_8, float4(0.75, 0.75, 0.75, 0.75), mad(r5_xyzw_1, float4(0.75, 0.75, 0.75, 0.75), mad(r4_xyzw_1, float4(0.9, 0.9, 0.9, 0.9), mad(r3_xyzw_1, float4(0.9, 0.9, 0.9, 0.9), r2_xyzw_1))));
                    o.sv_Target0.xyzw = (r0_xyzw_9 * float4(0.23255813, 0.23255813, 0.23255813, 0.23255813));
                    o.sv_Target0.xyzw = o.sv_Target0.xyzw;
                }
                return o;
            }
            ENDHLSL
        }
    }
}
