Shader "Corpus/44 ShaderLab Misc"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "" {}
        _Mode ("Mode", Float) = 0
        _CategoryColor ("Category Color", Color) = (0.5,0.5,0.5,1)
    }
    SubShader
    {
        Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
        LOD 100
        Pass
        {
            Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _MainTex_ST : packoffset(c2);
                float4 _CategoryColor : packoffset(c3);
                float _Mode : packoffset(c4.x);
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
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                o.sv_Target0.xyzw = ((r0_xyzw_1 * _CategoryColor) * ((float)((_Mode + 1))).xxxx);
                return o;
            }
            ENDHLSL
        }
    }
    SubShader
    {
        Tags { "IGNOREPROJECTOR"="true" "QUEUE"="Transparent+10" "RenderType"="Transparent" }
        LOD 200
        Pass
        {
            Cull Off
            ZTest Disabled
            ZWrite Off
            Stencil
            {
                Ref 0
                ReadMask 0
                WriteMask 0
                Comp Disabled
                Pass Keep
                Fail Keep
                ZFail Keep
            }
            HLSLPROGRAM
            cbuffer cb0 : register(b0)
            {
                float4 cb0_values[4];
            };
            cbuffer cb1 : register(b1)
            {
                float4 cb1_values[21];
            };
            struct program5Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
            };
            struct program5Output
            {
                float4 sv_Position0 : SV_POSITION;
            };
            struct program7Input
            {
                float4 sv_Position0 : SV_POSITION;
            };
            struct program7Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program5Output vert(program5Input i)
            {
                program5Output o = (program5Output)0;
                float4 worldPos_xyzw_1 = (i.position0.yyyy * cb0_values[1].xyzw);
                float4 worldPos_xyzw_2 = mad(cb0_values[0].xyzw, i.position0.xxxx, worldPos_xyzw_1);
                float4 worldPos_xyzw_3 = mad(cb0_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_4 = (worldPos_xyzw_3 + cb0_values[3].xyzw);
                o.sv_Position0.xyzw = mul(float4x4(cb1_values[17], cb1_values[18], cb1_values[19], cb1_values[20]), worldPos_xyzw_4);
                return o;
            }
            #pragma fragment frag
            program7Output frag(program7Input i)
            {
                program7Output o = (program7Output)0;
                o.sv_Target0.xyzw = cb0_values[2].xyzw;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "QUEUE"="Transparent+10" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcColor
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
    Fallback "Diffuse"
    CustomEditor "CorpusShaderGUI"
}
