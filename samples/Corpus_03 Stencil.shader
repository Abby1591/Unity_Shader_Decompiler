Shader "Corpus/03 Stencil"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _StencilRef ("Stencil Ref", Range(0, 255)) = 1
        _StencilReadMask ("Stencil Read Mask", Range(0, 255)) = 255
        _StencilWriteMask ("Stencil Write Mask", Range(0, 255)) = 255
    }
    SubShader
    {
        Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
        LOD 0
        Pass
        {
            Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
            Stencil
            {
                Ref 0
                ReadMask 0
                WriteMask 0
                Comp Always
                Pass Keep
                Fail Keep
                ZFail Keep
            }
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
        Pass
        {
            Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
            Stencil
            {
                Ref 2
                ReadMask 127
                WriteMask 127
                Comp Always
                Pass Keep
                Fail Keep
                ZFail Keep
            }
        }
        Pass
        {
            Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
            Stencil
            {
                Ref 3
                ReadMask 255
                WriteMask 255
                Comp Always
                Pass Keep
                Fail Keep
                ZFail Keep
            }
        }
        Pass
        {
            Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
            Stencil
            {
                Ref 4
                ReadMask 255
                WriteMask 255
                Comp Always
                Pass Keep
                Fail Keep
                ZFail Keep
            }
        }
        Pass
        {
            Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
            Stencil
            {
                Ref 5
                ReadMask 255
                WriteMask 255
                Comp Always
                Pass Keep
                Fail Keep
                ZFail Keep
            }
        }
        Pass
        {
            Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
            Stencil
            {
                Ref 6
                ReadMask 255
                WriteMask 255
                Comp Always
                Pass Keep
                Fail Keep
                ZFail Keep
            }
        }
        Pass
        {
            Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
            Stencil
            {
                Ref 7
                ReadMask 255
                WriteMask 255
                Comp Always
                Pass Keep
                Fail Keep
                ZFail Keep
            }
        }
        Pass
        {
            Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
            Stencil
            {
                Ref 8
                ReadMask 255
                WriteMask 255
                Comp Always
                Pass Keep
                Fail Keep
                ZFail Keep
            }
        }
    }
}
