Shader "Custom/Scanline"
{
    Properties
    {
        _MainTex ("Texture1", 2D) = "" {}
        _GlitchAmount ("Glitch Amount", Float) = 0.02
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
            ENDHLSL
        }
    }
    Fallback "VertexLit"
}
