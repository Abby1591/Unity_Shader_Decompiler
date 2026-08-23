Shader "Hidden/DLAA"
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
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _MainTex_TexelSize;
            };
            cbuffer UnityPerFrame : register(b1)
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
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
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
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float4 r0_xyzw_2 = t0.Sample(s0, ((i.texcoord0.xyxx + -_MainTex_TexelSize.xyxx)).xyxx);
                float4 r1_xyzw_1 = mad(_MainTex_TexelSize.xyxy, float4(1, -1, -1, 1), i.texcoord0.xyxy);
                float4 r2_xyzw_1 = t0.Sample(s0, r1_xyzw_1.xyxx);
                float4 r1_xyzw_2 = t0.Sample(s0, r1_xyzw_1.zwzz);
                float4 r0_xyzw_3 = (r0_xyzw_2.xyzx + r2_xyzw_1.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_2 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = (r1_xyzw_2.xyzx + float4(r0_x_3, r0_y_3, r0_z_2, r0_x_3));
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_4 = r0_xyzw_4.y;
                float r0_z_3 = r0_xyzw_4.z;
                float4 r1_xyzw_4 = t0.Sample(s0, ((i.texcoord0.xyxx + _MainTex_TexelSize.xyxx)).xyxx);
                float4 r0_xyzw_5 = (float4(r0_x_4, r0_y_4, r0_z_3, r0_x_4) + r1_xyzw_4.xyzx);
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_5 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float4 r1_xyzw_5 = t0.Sample(s0, i.texcoord0.xyxx);
                float4 r0_xyzw_6 = mad(-r1_xyzw_5.xyzx, float4(4, 4, 4, 0), float4(r0_x_5, r0_y_5, r0_z_4, r0_x_5));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_6 = r0_xyzw_6.y;
                float r0_z_5 = r0_xyzw_6.z;
                o.sv_Target0.xyz = r1_xyzw_5.xyz;
                float4 r0_xyzw_7 = (abs(float4(r0_x_6, r0_y_6, r0_z_5, r0_x_6)) * float4(4, 4, 4, 0));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_7 = r0_xyzw_7.y;
                float r0_z_6 = r0_xyzw_7.z;
                o.sv_Target0.w = dot(float4(r0_x_7, r0_y_7, r0_z_6, r0_x_7), float4(0.33, 0.33, 0.33, 0));
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
