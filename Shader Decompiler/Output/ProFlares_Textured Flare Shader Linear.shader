Shader "ProFlares/Textured Flare Shader Linear "
{
    Properties
    {
        _MainTex ("Texture", 2D) = "" {}
    }
    SubShader
    {
        Tags { "IGNOREPROJECTOR"="true" "QUEUE"="Transparent+100" "RenderType"="Transparent" }
        LOD 0
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "QUEUE"="Transparent+100" "RenderType"="Transparent" }
            Cull Back
            ZTest Always
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
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
                float4 color0 : COLOR0;
            };
            struct program1Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float4 color0 : COLOR0;
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float4 color0 : COLOR0;
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
                float4 r0_xyzw_6 = (((i.color0.w * 3)).xxxx * i.color0.xyzw);
                float4 r0_xyzw_7 = log2(r0_xyzw_6);
                float4 r0_xyzw_8 = (r0_xyzw_7 * float4(2.2, 2.2, 2.2, 2.2));
                o.color0.xyzw = exp2(r0_xyzw_8);
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float4 r0_xyzw_1 = t0.Sample(s0, i.texcoord0.xyxx);
                o.sv_Target0.xyzw = (r0_xyzw_1 * i.color0.xyzw);
                return o;
            }
            ENDHLSL
        }
    }
}
