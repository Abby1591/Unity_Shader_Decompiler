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
        Pass
        {
            Cull Off
            ZTest Disabled
            ZWrite Off
            ZClip Off
            Stencil
            {
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
                float4 worldPos_xyzw_1 = (i.position0.yyyy * cb0_values[1].xyzw);
                float4 worldPos_xyzw_2 = mad(cb0_values[0].xyzw, i.position0.xxxx, worldPos_xyzw_1);
                float4 worldPos_xyzw_3 = mad(cb0_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_4 = (worldPos_xyzw_3 + cb0_values[3].xyzw);
                o.sv_Position0.xyzw = mul(float4x4(cb1_values[17], cb1_values[18], cb1_values[19], cb1_values[20]), worldPos_xyzw_4);
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                o.sv_Target0.xyzw = cb0_values[2].xyzw;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "CanUseSpriteAtlas"="true" "FORCENOSHADOWCASTING"="true" "IGNOREPROJECTOR"="true" "PreviewType"="Plane" "QUEUE"="Geometry+10" "RenderType"="Opaque" }
            Cull Back
            ZTest Always
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
        }
    }
    Fallback "Corpus/16 UsePass Base"
}
