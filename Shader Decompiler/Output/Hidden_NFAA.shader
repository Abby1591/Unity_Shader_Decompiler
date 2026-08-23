Shader "Hidden/NFAA"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "" {}
        _BlurTex ("Base (RGB)", 2D) = "" {}
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
                float _OffsetScale;
                float _BlurRadius;
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
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float2 texcoord4 : TEXCOORD4;
                float2 texcoord5 : TEXCOORD5;
                float2 texcoord6 : TEXCOORD6;
                float2 texcoord7 : TEXCOORD7;
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float2 texcoord4 : TEXCOORD4;
                float2 texcoord5 : TEXCOORD5;
                float2 texcoord6 : TEXCOORD6;
                float2 texcoord7 : TEXCOORD7;
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
                float2 r0_yz_5 = ((_MainTex_TexelSize.yyxy * _OffsetScale.xxxx)).yz;
                float2 r0_xw_5 = (float4(0, 0, 0, 0)).xw;
                o.texcoord0.xy = ((float4(r0_xw_5.x, r0_yz_5.x, r0_xw_5.x, r0_xw_5.x) + i.texcoord0.xyxx)).xy;
                o.texcoord1.xy = ((-float4(r0_xw_5.x, r0_yz_5.x, r0_xw_5.x, r0_xw_5.x) + i.texcoord0.xyxx)).xy;
                float2 r1_xy_4 = ((float4(r0_yz_5.y, r0_xw_5.y, r0_yz_5.y, r0_yz_5.y) + i.texcoord0.xyxx)).xy;
                o.texcoord2.xy = (r1_xy_4.xyxx).xy;
                float2 r0_zw_6 = ((-float4(r0_yz_5.y, r0_yz_5.y, r0_yz_5.y, r0_xw_5.y) + i.texcoord0.xxxy)).zw;
                o.texcoord3.xy = (r0_zw_6.xyxx).xy;
                o.texcoord4.xy = ((float4(r0_xw_5.x, r0_yz_5.x, r0_xw_5.x, r0_xw_5.x) + r0_zw_6.xyxx)).xy;
                o.texcoord5.xy = ((-float4(r0_xw_5.x, r0_yz_5.x, r0_xw_5.x, r0_xw_5.x) + r0_zw_6.xyxx)).xy;
                o.texcoord6.xy = ((float4(r0_xw_5.x, r0_yz_5.x, r0_xw_5.x, r0_xw_5.x) + r1_xy_4.xyxx)).xy;
                o.texcoord7.xy = ((-float4(r0_xw_5.x, r0_yz_5.x, r0_xw_5.x, r0_xw_5.x) + r1_xy_4.xyxx)).xy;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float4 r0_xyzw_1 = t0.Sample(s0, i.texcoord2.xyxx);
                float r0_y_2 = dot(r0_xyzw_1.xyzx, float4(0.22, 0.707, 0.071, 0));
                float4 r1_xyzw_1 = t0.Sample(s0, i.texcoord4.xyxx);
                float r1_z_2 = dot(r1_xyzw_1.xyzx, float4(0.22, 0.707, 0.071, 0));
                float r0_x_2 = r1_z_2;
                float4 r2_xyzw_1 = t0.Sample(s0, i.texcoord5.xyxx);
                float r0_z_2 = dot(r2_xyzw_1.xyzx, float4(0.22, 0.707, 0.071, 0));
                float r0_w_2 = dot(float4(1, 1, 1, 0), float4(r0_x_2, r0_y_2, r0_z_2, r0_x_2));
                float4 r2_xyzw_2 = t0.Sample(s0, i.texcoord3.xyxx);
                float r2_y_3 = dot(r2_xyzw_2.xyzx, float4(0.22, 0.707, 0.071, 0));
                float4 r3_xyzw_1 = t0.Sample(s0, i.texcoord6.xyxx);
                float r0_y_3 = dot(r3_xyzw_1.xyzx, float4(0.22, 0.707, 0.071, 0));
                float r2_x_3 = r0_y_3;
                float4 r3_xyzw_2 = t0.Sample(s0, i.texcoord7.xyxx);
                float r1_x_2 = dot(r3_xyzw_2.xyzx, float4(0.22, 0.707, 0.071, 0));
                float r2_z_3 = r1_x_2;
                float r1_w_2 = dot(float4(1, 1, 1, 0), float4(r2_x_3, r2_y_3, r2_z_3, r2_x_3));
                float r2_y_4 = (-r0_w_2 + r1_w_2);
                float4 r3_xyzw_3 = t0.Sample(s0, i.texcoord1.xyxx);
                float r1_y_2 = dot(r3_xyzw_3.xyzx, float4(0.22, 0.707, 0.071, 0));
                float r0_w_3 = dot(float4(1, 1, 1, 0), float4(r1_x_2, r1_y_2, r1_z_2, r1_x_2));
                float4 r1_xyzw_3 = t0.Sample(s0, i.texcoord0.xyxx);
                float r0_x_3 = dot(r1_xyzw_3.xyzx, float4(0.22, 0.707, 0.071, 0));
                float r2_x_4 = (dot(float4(1, 1, 1, 0), float4(r0_x_3, r0_y_3, r0_z_2, r0_x_3)) + r0_w_3);
                float4 r0_xyzw_5 = (_MainTex_TexelSize.xyxx * _BlurRadius.xxxx);
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float4 r0_xyzw_6 = (float4(r0_x_5, r0_y_4, r0_x_5, r0_x_5) * float4(r2_x_4, r2_y_4, r2_x_4, r2_x_4));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_5 = r0_xyzw_6.y;
                float2 r1_xy_4 = ((i.texcoord0.xyxx + i.texcoord1.xyxx)).xy;
                float2 r1_zw_4 = (mad(r1_xy_4.xxxy, float4(0, 0, 0.5, 0.5), float4(r0_x_6, r0_x_6, r0_x_6, r0_y_5))).zw;
                float4 r2_xyzw_5 = t0.Sample(s0, r1_zw_4.xyxx);
                float2 r1_zw_5 = ((r1_xy_4.xxxy * float4(0, 0, 0.5, 0.5))).zw;
                float4 r3_xyzw_4 = t0.Sample(s0, r1_zw_5.xyxx);
                float4 r2_xyzw_6 = (r2_xyzw_5 + r3_xyzw_4);
                float2 r1_zw_6 = (mad(r1_xy_4.xxxy, float4(0, 0, 0.5, 0.5), -float4(r0_x_6, r0_x_6, r0_x_6, r0_y_5))).zw;
                float4 r3_xyzw_5 = t0.Sample(s0, r1_zw_6.xyxx);
                float4 r2_xyzw_7 = (r2_xyzw_6 + r3_xyzw_5);
                float r0_z_3 = -r0_y_5;
                float r0_y_6 = (mad(r1_xy_4.xxxy, float4(0, 0.5, 0, 0.5), float4(r0_x_6, r0_x_6, r0_x_6, r0_z_3))).y;
                float r0_w_4 = (mad(r1_xy_4.xxxy, float4(0, 0.5, 0, 0.5), float4(r0_x_6, r0_x_6, r0_x_6, r0_z_3))).w;
                float4 r0_xyzw_7 = mad(r1_xy_4.xxyx, float4(0.5, 0, 0.5, 0), -float4(r0_x_6, r0_x_6, r0_z_3, r0_x_6));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_z_4 = r0_xyzw_7.z;
                float4 r1_xyzw_5 = t0.Sample(s0, float4(r0_x_7, r0_z_4, r0_x_7, r0_x_7));
                float4 r0_xyzw_8 = t0.Sample(s0, float4(r0_y_6, r0_w_4, r0_y_6, r0_y_6));
                float4 r0_xyzw_9 = (r0_xyzw_8 + r2_xyzw_7);
                float4 r0_xyzw_10 = (r1_xyzw_5 + r0_xyzw_9);
                o.sv_Target0.xyzw = (r0_xyzw_10 * float4(0.2, 0.2, 0.2, 0.2));
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Cull Off
            ZTest Always
            ZWrite Off
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            cbuffer _StubCB : register(b1) { float4x4 unity_MatrixVP; };
            struct v2f { float4 pos : SV_POSITION; };
            v2f vert(float4 v : POSITION) { v2f o; o.pos = mul(unity_MatrixVP, v); return o; }
            float4 frag(v2f i) : SV_Target { return 0; }
            ENDHLSL
        }
    }
}
