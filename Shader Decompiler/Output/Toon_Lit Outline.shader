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
            ENDHLSL
        }
    }
    Fallback "Toon/Lit"
}
