Shader "Hidden/LensFlareCreate"
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
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 colorA;
                float4 colorB;
                float4 colorC;
                float4 colorD;
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4x4 unity_MatrixVP;
            };
            SamplerState sampler_MainTex : register(s0);
            Texture2D _MainTex : register(t0);
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
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
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
                float4 r0_xyzw_5 = (i.texcoord0.xyxy + float4(-0.5, -0.5, -0.5, -0.5));
                o.texcoord0.xy = (mad(r0_xyzw_5.zwzz, float4(-0.85, -0.85, 0, 0), float4(0.5, 0.5, 0, 0))).xy;
                o.texcoord1.xy = (mad(r0_xyzw_5.zwzz, float4(-1.45, -1.45, 0, 0), float4(0.5, 0.5, 0, 0))).xy;
                o.texcoord2.xy = (mad(r0_xyzw_5.xyxx, float4(-2.55, -2.55, 0, 0), float4(0.5, 0.5, 0, 0))).xy;
                o.texcoord3.xy = (mad(r0_xyzw_5.zwzz, float4(-4.15, -4.15, 0, 0), float4(0.5, 0.5, 0, 0))).xy;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord1.xyxx).xy);
                float4 r1_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord2.xyxx).xy);
                float4 r1_xyzw_3 = _MainTex.Sample(sampler_MainTex, (i.texcoord3.xyxx).xy);
                o.sv_Target0.xyzw = mad(r1_xyzw_3, colorD, mad(r1_xyzw_2, colorC, mad(r1_xyzw_1, colorA, (r0_xyzw_1 * colorB))));
                return o;
            }
            ENDHLSL
        }
    }
}
