Shader "Hidden/BlurAndFlares"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "" {}
        _NonBlurredTex ("Base (RGB)", 2D) = "" {}
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
                float4 cb0_values[4];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4x4 unity_MatrixVP;
                float4 cb1_values[21];
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
                float4 r0_xyzw_1 = t0.Sample(s0, i.texcoord0.xyxx);
                o.sv_Target0.xyzw = (r0_xyzw_1 / ((dot(r0_xyzw_1.xyzx, float4(0.22, 0.707, 0.071, 0)) + 1.5)).xxxx);
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
                float4 _Offsets;
                float _StretchWidth;
                float4 cb0_values[5];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 cb1_values[4];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[21];
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
                float2 texcoord5 : TEXCOORD5;
                float2 texcoord6 : TEXCOORD6;
            };
            struct program6Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float2 texcoord4 : TEXCOORD4;
                float2 texcoord5 : TEXCOORD5;
                float2 texcoord6 : TEXCOORD6;
            };
            struct program6Output
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
                o.texcoord0.xy = (i.texcoord0.xyxx).xy;
                float r0_x_5 = (_StretchWidth + _StretchWidth);
                o.texcoord1.xy = (mad(r0_x_5.xxxx, _Offsets.xyxx, i.texcoord0.xyxx)).xy;
                o.texcoord2.xy = (mad(-r0_x_5.xxxx, _Offsets.xyxx, i.texcoord0.xyxx)).xy;
                float4 r0_xyzw_6 = (_StretchWidth.xxxx * float4(4, 4, 6, 6));
                o.texcoord3.xy = (mad(r0_xyzw_6.xyxx, _Offsets.xyxx, i.texcoord0.xyxx)).xy;
                o.texcoord4.xy = (mad(-r0_xyzw_6.xyxx, _Offsets.xyxx, i.texcoord0.xyxx)).xy;
                o.texcoord5.xy = (mad(r0_xyzw_6.zwzz, _Offsets.xyxx, i.texcoord0.xyxx)).xy;
                o.texcoord6.xy = (mad(-r0_xyzw_6.zwzz, _Offsets.xyxx, i.texcoord0.xyxx)).xy;
                return o;
            }
            #pragma fragment frag
            program6Output frag(program6Input i)
            {
                program6Output o = (program6Output)0;
                float4 r0_xyzw_1 = t0.Sample(s0, i.texcoord0.xyxx);
                float4 r1_xyzw_1 = t0.Sample(s0, i.texcoord1.xyxx);
                float4 r1_xyzw_2 = t0.Sample(s0, i.texcoord2.xyxx);
                float4 r1_xyzw_3 = t0.Sample(s0, i.texcoord3.xyxx);
                float4 r1_xyzw_4 = t0.Sample(s0, i.texcoord4.xyxx);
                float4 r1_xyzw_5 = t0.Sample(s0, i.texcoord5.xyxx);
                float4 r1_xyzw_6 = t0.Sample(s0, i.texcoord6.xyxx);
                o.sv_Target0.xyzw = max(max(max(max(max(max(r0_xyzw_1, r1_xyzw_1), r1_xyzw_2), r1_xyzw_3), r1_xyzw_4), r1_xyzw_5), r1_xyzw_6);
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
                float4 _Offsets;
                float4 _TintColor;
                float2 _Threshhold;
                float _Saturation;
                float4 _MainTex_TexelSize;
                float4 cb0_values[6];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 cb1_values[4];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            Texture2D t0 : register(t0);
            struct program7Input
            {
                float4 position0 : POSITION0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program7Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float2 texcoord4 : TEXCOORD4;
                float2 texcoord5 : TEXCOORD5;
                float2 texcoord6 : TEXCOORD6;
            };
            struct program9Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float2 texcoord4 : TEXCOORD4;
                float2 texcoord5 : TEXCOORD5;
                float2 texcoord6 : TEXCOORD6;
            };
            struct program9Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program7Output vert(program7Input i)
            {
                program7Output o = (program7Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_4 = UnityObjectToWorldPos(i.position0.xyz);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_4);
                o.texcoord0.xy = (i.texcoord0.xyxx).xy;
                float2 r0_xy_5 = ((_Offsets.xyxx * _MainTex_TexelSize.xyxx)).xy;
                o.texcoord1.xy = (mad(r0_xy_5.xyxx, float4(0.5, 0.5, 0, 0), i.texcoord0.xyxx)).xy;
                o.texcoord2.xy = (mad(-r0_xy_5.xyxx, float4(0.5, 0.5, 0, 0), i.texcoord0.xyxx)).xy;
                o.texcoord3.xy = (mad(r0_xy_5.xyxx, float4(1.5, 1.5, 0, 0), i.texcoord0.xyxx)).xy;
                o.texcoord4.xy = (mad(-r0_xy_5.xyxx, float4(1.5, 1.5, 0, 0), i.texcoord0.xyxx)).xy;
                o.texcoord5.xy = (mad(r0_xy_5.xyxx, float4(2.5, 2.5, 0, 0), i.texcoord0.xyxx)).xy;
                o.texcoord6.xy = (mad(-r0_xy_5.xyxx, float4(2.5, 2.5, 0, 0), i.texcoord0.xyxx)).xy;
                return o;
            }
            #pragma fragment frag
            program9Output frag(program9Input i)
            {
                program9Output o = (program9Output)0;
                float4 r0_xyzw_1 = t0.Sample(s0, i.texcoord0.xyxx);
                float4 r1_xyzw_1 = t0.Sample(s0, i.texcoord1.xyxx);
                float4 r1_xyzw_2 = t0.Sample(s0, i.texcoord2.xyxx);
                float4 r1_xyzw_3 = t0.Sample(s0, i.texcoord3.xyxx);
                float4 r1_xyzw_4 = t0.Sample(s0, i.texcoord4.xyxx);
                float4 r1_xyzw_5 = t0.Sample(s0, i.texcoord5.xyxx);
                float4 r1_xyzw_6 = t0.Sample(s0, i.texcoord6.xyxx);
                float4 r0_xyzw_8 = mad(((((((r0_xyzw_1 + r1_xyzw_1) + r1_xyzw_2) + r1_xyzw_3) + r1_xyzw_4) + r1_xyzw_5) + r1_xyzw_6), float4(0.14285715, 0.14285715, 0.14285715, 0.14285715), -_Threshhold.xxxx);
                float4 r0_xyzw_9 = max(r0_xyzw_8, float4(0, 0, 0, 0));
                float r1_x_7 = dot(r0_xyzw_9.xyzx, float4(0.22, 0.707, 0.071, 0));
                o.sv_Target0.w = r0_xyzw_9.w;
                o.sv_Target0.xyz = (((mad(_Saturation.xxxx, ((r0_xyzw_9.xyzx + -r1_x_7.xxxx)).xyzx, r1_x_7.xxxx)).xyzx * _TintColor.xyzx)).xyz;
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
                float4 _Offsets;
                float4 _MainTex_TexelSize;
                float4 cb0_values[6];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 cb1_values[4];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            Texture2D t0 : register(t0);
            struct program7Input
            {
                float4 position0 : POSITION0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program7Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float2 texcoord4 : TEXCOORD4;
                float2 texcoord5 : TEXCOORD5;
                float2 texcoord6 : TEXCOORD6;
            };
            struct program10Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float2 texcoord4 : TEXCOORD4;
                float2 texcoord5 : TEXCOORD5;
                float2 texcoord6 : TEXCOORD6;
            };
            struct program10Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program7Output vert(program7Input i)
            {
                program7Output o = (program7Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_4 = UnityObjectToWorldPos(i.position0.xyz);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_4);
                o.texcoord0.xy = (i.texcoord0.xyxx).xy;
                float2 r0_xy_5 = ((_Offsets.xyxx * _MainTex_TexelSize.xyxx)).xy;
                o.texcoord1.xy = (mad(r0_xy_5.xyxx, float4(0.5, 0.5, 0, 0), i.texcoord0.xyxx)).xy;
                o.texcoord2.xy = (mad(-r0_xy_5.xyxx, float4(0.5, 0.5, 0, 0), i.texcoord0.xyxx)).xy;
                o.texcoord3.xy = (mad(r0_xy_5.xyxx, float4(1.5, 1.5, 0, 0), i.texcoord0.xyxx)).xy;
                o.texcoord4.xy = (mad(-r0_xy_5.xyxx, float4(1.5, 1.5, 0, 0), i.texcoord0.xyxx)).xy;
                o.texcoord5.xy = (mad(r0_xy_5.xyxx, float4(2.5, 2.5, 0, 0), i.texcoord0.xyxx)).xy;
                o.texcoord6.xy = (mad(-r0_xy_5.xyxx, float4(2.5, 2.5, 0, 0), i.texcoord0.xyxx)).xy;
                return o;
            }
            #pragma fragment frag
            program10Output frag(program10Input i)
            {
                program10Output o = (program10Output)0;
                float4 r0_xyzw_1 = t0.Sample(s0, i.texcoord0.xyxx);
                float4 r1_xyzw_1 = t0.Sample(s0, i.texcoord1.xyxx);
                float4 r1_xyzw_2 = t0.Sample(s0, i.texcoord2.xyxx);
                float4 r1_xyzw_3 = t0.Sample(s0, i.texcoord3.xyxx);
                float4 r1_xyzw_4 = t0.Sample(s0, i.texcoord4.xyxx);
                float4 r1_xyzw_5 = t0.Sample(s0, i.texcoord5.xyxx);
                float4 r1_xyzw_6 = t0.Sample(s0, i.texcoord6.xyxx);
                float4 r0_xyzw_7 = ((((((r0_xyzw_1 + r1_xyzw_1) + r1_xyzw_2) + r1_xyzw_3) + r1_xyzw_4) + r1_xyzw_5) + r1_xyzw_6);
                o.sv_Target0.xyzw = (r0_xyzw_7 / ((dot(r0_xyzw_7.xyzx, float4(0.22, 0.707, 0.071, 0)) + 7.5)).xxxx);
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
                float4 _Offsets;
                float4 _MainTex_TexelSize;
                float4 cb0_values[3];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 cb1_values[4];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            Texture2D t0 : register(t0);
            struct program11Input
            {
                float4 position0 : POSITION0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program11Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program12Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program12Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program11Output vert(program11Input i)
            {
                program11Output o = (program11Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_4 = UnityObjectToWorldPos(i.position0.xyz);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_4);
                o.texcoord0.xy = (i.texcoord0.xyxx).xy;
                o.texcoord1.xyzw = mad(_Offsets.xyxy, float4(1, 1, -1, -1), i.texcoord0.xyxy);
                o.texcoord2.xyzw = mad(_Offsets.xyxy, float4(2, 2, -2, -2), i.texcoord0.xyxy);
                o.texcoord3.xyzw = mad(_Offsets.xyxy, float4(3, 3, -3, -3), i.texcoord0.xyxy);
                o.texcoord4.xyzw = mad(_Offsets.xyxy, float4(5, 5, -5, -5), i.texcoord0.xyxy);
                return o;
            }
            #pragma fragment frag
            program12Output frag(program12Input i)
            {
                program12Output o = (program12Output)0;
                float4 r0_xyzw_1 = t0.Sample(s0, i.texcoord1.xyxx);
                float4 r1_xyzw_1 = t0.Sample(s0, i.texcoord0.xyxx);
                float4 r1_xyzw_2 = t0.Sample(s0, i.texcoord1.zwzz);
                float4 r1_xyzw_3 = t0.Sample(s0, i.texcoord2.xyxx);
                float4 r1_xyzw_4 = t0.Sample(s0, i.texcoord2.zwzz);
                float4 r0_xyzw_6 = mad(r1_xyzw_4, float4(0.11, 0.11, 0.11, 0.11), mad(r1_xyzw_3, float4(0.11, 0.11, 0.11, 0.11), mad(r1_xyzw_2, float4(0.15, 0.15, 0.15, 0.15), mad(r1_xyzw_1, float4(0.225, 0.225, 0.225, 0.225), (r0_xyzw_1 * float4(0.15, 0.15, 0.15, 0.15))))));
                float4 r1_xyzw_5 = t0.Sample(s0, i.texcoord3.xyxx);
                float4 r1_xyzw_6 = t0.Sample(s0, i.texcoord3.zwzz);
                float4 r1_xyzw_7 = t0.Sample(s0, i.texcoord4.xyxx);
                float4 r1_xyzw_8 = t0.Sample(s0, i.texcoord4.zwzz);
                o.sv_Target0.xyzw = mad(r1_xyzw_8, float4(0.0525, 0.0525, 0.0525, 0.0525), mad(r1_xyzw_7, float4(0.0525, 0.0525, 0.0525, 0.0525), mad(r1_xyzw_6, float4(0.075, 0.075, 0.075, 0.075), mad(r1_xyzw_5, float4(0.075, 0.075, 0.075, 0.075), r0_xyzw_6))));
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
    }
}
