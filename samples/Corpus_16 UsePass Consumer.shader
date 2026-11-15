Shader "Corpus/16 UsePass Consumer"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "" {}
        _OverlayColor ("Overlay Color", Color) = (0,0.5,1,0.5)
    }
    SubShader
    {
        Tags { "CanUseSpriteAtlas"="true" "FORCENOSHADOWCASTING"="true" "IGNOREPROJECTOR"="true" "PreviewType"="Plane" "QUEUE"="Geometry+10" "RenderType"="Opaque" }
        LOD 200
        UsePass "Corpus/16 UsePass Base/BASE"
        Pass
        {
            Tags { "CanUseSpriteAtlas"="true" "FORCENOSHADOWCASTING"="true" "IGNOREPROJECTOR"="true" "PreviewType"="Plane" "QUEUE"="Geometry+10" "RenderType"="Opaque" }
            Cull Back
            ZTest Always
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            HLSLPROGRAM
            cbuffer _UnityPerDrawCB_b0
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
            };
            cbuffer _UnityPerFrameCB_b1
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            struct program1Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
            };
            struct program1Output
            {
                float4 sv_Position0 : SV_POSITION;
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_POSITION;
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
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                o.sv_Target0.xyzw = unity_ObjectToWorld[2];
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Corpus/16 UsePass Base"
}
