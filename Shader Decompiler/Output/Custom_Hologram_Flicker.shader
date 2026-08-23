Shader "Custom/Hologram_Flicker"
{
    Properties
    {
        _MainTex ("Texture1", 2D) = "" {}
        _SecondTex ("Texture2", 2D) = "" {}
        _RotationSpeed ("Rotation Speed", Float) = 1
        _ReverseSpeed ("Reverse Speed", Float) = 1
        _GlitchAmount ("Glitch Amount", Float) = 0.02
        _FlickerAmount ("Flicker Amount", Float) = 0.5
    }
    SubShader
    {
        Tags { "FORCENOSHADOWCASTING"="true" "IGNOREPROJECTOR"="true" "QUEUE"="Transparent" "RenderType"="Transparent" }
        LOD 0
        Pass
        {
            Tags { "FORCENOSHADOWCASTING"="true" "IGNOREPROJECTOR"="true" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcColor
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _MainTex_ST;
                float _RotationSpeed;
                float _ReverseSpeed;
                float _GlitchAmount;
                float _FlickerAmount;
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _Time;
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4x4 unity_MatrixVP;
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            struct program1Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
            };
            struct program1Output
            {
                float4 sv_Position0 : SV_Position0;
                float4 color0 : COLOR0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_Position0;
                float4 color0 : COLOR0;
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
                o.color0.xyzw = float4(1, 1, 1, 1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float r0_x_8 = ((min(frac((sin(((i.texcoord0.x * _Time.x) * 12.9898)) * 43758.547)), _GlitchAmount) + _GlitchAmount) + i.texcoord0.x);
                float r0_y_1 = mad(_Time.x, _RotationSpeed, r0_x_8);
                float r0_x_9 = mad(-_Time.x, _ReverseSpeed, r0_x_8);
                float2 r1_xz_1 = (frac(float4(r0_y_1, r0_y_1, r0_x_9, r0_y_1))).xz;
                float2 TEXCOORD0_yw_1 = (i.texcoord0.yyyy).yw;
                float4 r0_xyzw_10 = t0.Sample(s0, float4(r1_xz_1.x, TEXCOORD0_yw_1.x, r1_xz_1.x, r1_xz_1.x));
                float4 r1_xyzw_2 = t1.Sample(s1, float4(r1_xz_1.y, TEXCOORD0_yw_1.y, r1_xz_1.y, r1_xz_1.y));
                float4 r0_xyzw_11 = (r0_xyzw_10 + r1_xyzw_2);
                o.sv_Target0.w = (r0_xyzw_11.w + min(frac((sin(_Time.x) * 43758.547)), _FlickerAmount));
                o.sv_Target0.xyz = r0_xyzw_11.xyz;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "VertexLit"
}
