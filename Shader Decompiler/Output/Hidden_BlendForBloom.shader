Shader "Hidden/BlendForBloom"
{
    Properties
    {
        _MainTex ("Screen Blended", 2D) = "" {}
        _ColorBuffer ("Color", 2D) = "" {}
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
                float _Intensity;
                float4 _ColorBuffer_TexelSize;
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
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
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
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
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
                float r0_y_5 = (-i.texcoord0.y + 1);
                o.texcoord1.y = ((_ColorBuffer_TexelSize.y < 0) ? r0_y_5 : i.texcoord0.y);
                o.texcoord1.x = i.texcoord0.x;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float4 r0_xyzw_1 = t0.Sample(s1, i.texcoord0.xyxx);
                float4 r1_xyzw_1 = t1.Sample(s0, i.texcoord1.xyxx);
                o.sv_Target0.xyzw = mad(mad(-r0_xyzw_1, _Intensity.xxxx, float4(1, 1, 1, 1)), (-r1_xyzw_1 + float4(1, 1, 1, 1)), float4(1, 1, 1, 1));
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
            cbuffer _Globals : register(b0)
            {
                float4 _ColorBuffer_TexelSize;
                float4 cb0_values[5];
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
            struct program5Input
            {
                float4 position0 : POSITION0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program5Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float2 texcoord4 : TEXCOORD4;
            };
            struct program7Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float2 texcoord4 : TEXCOORD4;
            };
            struct program7Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program5Output vert(program5Input i)
            {
                program5Output o = (program5Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_4 = UnityObjectToWorldPos(i.position0.xyz);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_4);
                o.texcoord0.xy = (mad(cb0_values[4].xyxx, float4(0.5, 0.5, 0, 0), i.texcoord0.xyxx)).xy;
                o.texcoord1.xy = (mad(-cb0_values[4].xyxx, float4(0.5, 0.5, 0, 0), i.texcoord0.xyxx)).xy;
                o.texcoord2.xy = (mad(-cb0_values[4].xyxx, float4(0.5, -0.5, 0, 0), i.texcoord0.xyxx)).xy;
                o.texcoord3.xy = (mad(cb0_values[4].xyxx, float4(0.5, -0.5, 0, 0), i.texcoord0.xyxx)).xy;
                o.texcoord4.xy = (i.texcoord0.xyxx).xy;
                return o;
            }
            #pragma fragment frag
            program7Output frag(program7Input i)
            {
                program7Output o = (program7Output)0;
                float4 r0_xyzw_1 = t0.Sample(s0, i.texcoord4.xyxx);
                float4 r1_xyzw_1 = t0.Sample(s0, i.texcoord0.xyxx);
                float4 r1_xyzw_2 = t0.Sample(s0, i.texcoord1.xyxx);
                float4 r1_xyzw_3 = t0.Sample(s0, i.texcoord2.xyxx);
                float4 r1_xyzw_4 = t0.Sample(s0, i.texcoord3.xyxx);
                o.sv_Target0.xyzw = max(max(max(max(r0_xyzw_1, r1_xyzw_1), r1_xyzw_2), r1_xyzw_3), r1_xyzw_4);
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
            ENDHLSL
        }
        Pass
        {
            Cull Off
            ZTest Always
            ZWrite Off
            HLSLPROGRAM
            ENDHLSL
        }
        Pass
        {
            Cull Off
            ZTest Always
            ZWrite Off
            HLSLPROGRAM
            ENDHLSL
        }
        Pass
        {
            Cull Off
            ZTest Always
            ZWrite Off
            HLSLPROGRAM
            ENDHLSL
        }
        Pass
        {
            Cull Off
            ZTest Always
            ZWrite Off
            HLSLPROGRAM
            ENDHLSL
        }
        Pass
        {
            Cull Off
            ZTest Always
            ZWrite Off
            Blend Zero SrcAlpha
            HLSLPROGRAM
            ENDHLSL
        }
        Pass
        {
            Cull Off
            ZTest Always
            ZWrite Off
            HLSLPROGRAM
            ENDHLSL
        }
        Pass
        {
            Cull Off
            ZTest Always
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            ENDHLSL
        }
        Pass
        {
            Cull Off
            ZTest Always
            ZWrite Off
            Blend One One
            BlendOp Max
            HLSLPROGRAM
            ENDHLSL
        }
    }
}
