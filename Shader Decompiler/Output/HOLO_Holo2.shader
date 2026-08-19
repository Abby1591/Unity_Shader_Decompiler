Shader "HOLO/Holo2"
{
    Properties
    {
        _MainTex ("Not used confusing", 2D) = "" {}
        _originalDiffuse ("Original Diffuse Map", 2D) = "" {}
        _Diffuse ("Diffuse Map", 2D) = "" {}
        _diff_Color ("Diffuse Color Mult", Color) = (1,1,1,1)
        _N_map ("Noise", 2D) = "" {}
        _M_map ("Mask", 2D) = "" {}
        [Toggle]
        _mask_type ("Use Map as Mask", Float) = 1
        _intensity ("Intensity", Float) = 0
        _deform ("Deformation Intensity", Float) = 1
        _Color ("Outline Color Mult", Color) = (1,1,1,1)
        _Opacity ("Base Opacity", Range(0, 1)) = 0
        _Bias ("Bias", Range(0, 1)) = 0
        _Scale ("Scale ", Range(0, 10)) = 0
        _Power ("Power", Range(0, 3)) = 0
        _Speed ("Speed", Range(0, 1)) = 0
        _t ("Extra Option", Range(0, 1)) = 0
        _noise_details ("G/H Noise Details Amount ", Range(1, 16)) = 0
        [Toggle]
        _X ("Active X Axe", Float) = 1
        [Toggle]
        _Y ("Active X Axe", Float) = 1
        [Toggle]
        _glitchColor ("Display G/H Color", Float) = 1
        [Toggle]
        _monochrom ("Monochromatic", Float) = 1
        [Toggle]
        _OriginalUVSwitch ("Switch to Orginal UVs on/off", Float) = 0
        _Distance ("Distance", Float) = 0
        _Amplitude ("Amplitude", Float) = 0
        _Speed_Up ("_Speed_Up", Float) = 0
        _Amount ("Amount", Range(0, 1)) = 0
        _cut_level ("Cut Level", Range(0, 1)) = 0
    }
    SubShader
    {
        Tags { "IGNOREPROJECTOR"="true" "QUEUE"="Transparent" "RenderType"="Transparent" }
        LOD 0
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite On
            Blend SrcAlpha OneMinusSrcColor
            HLSLPROGRAM
            ENDHLSL
        }
    }
    CustomEditor "Glitch_Editor_lite"
}
