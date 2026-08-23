Shader "Toon/Lit Outline"
{
    Properties
    {
        _Color ("Main Color", Color) = (0.5,0.5,0.5,1)
        _OutlineColor ("Outline Color", Color) = (0,0,0,1)
        _Outline ("Outline width", Range(0.002, 0.03)) = 0.005
        _MainTex ("Base (RGB)", 2D) = "" {}
        _Ramp ("Toon Ramp (RGB)", 2D) = "" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 0
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
            #pragma vertex vert
            #pragma fragment frag
            cbuffer _StubCB : register(b1) { float4x4 unity_MatrixVP; };
            struct v2f { float4 pos : SV_POSITION; };
            v2f vert(float4 v : POSITION) { v2f o; o.pos = mul(unity_MatrixVP, v); return o; }
            float4 frag(v2f i) : SV_Target { return 0; }
            ENDHLSL
        }
    }
    Fallback "Toon/Lit"
}
