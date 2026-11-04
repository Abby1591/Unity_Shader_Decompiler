Shader "Custom/Wipe_NoKeyframe"
{
    Properties
    {
        _MainTex ("Texture1", 2D) = "" {}
        _MaterialTime ("Current Time", Float) = 0
        _Gradient ("Gradient", Color) = (0,1,0,0.35)
        _BarOpacity ("Bar Opacity", Float) = 0.35
        _BarEmissionScale ("Bar Emission Scale", Float) = 2
        _BarWidth ("Gradient Width", Float) = 64
        _StreakLength ("Streak Length (inverted)", Float) = 0.035
        _GlitchAmount ("Glitch Amount", Float) = 0.02
        _PixelResolution ("Pixel Resolution", Float) = 50
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
            #pragma vertex vert
            #pragma fragment frag
            cbuffer _StubCB : register(b1) { float4x4 unity_MatrixVP; };
            struct v2f { float4 pos : SV_POSITION; };
            v2f vert(float4 v : POSITION) { v2f o; o.pos = mul(unity_MatrixVP, v); return o; }
            float4 frag(v2f i) : SV_Target { return 0; }
            ENDHLSL
        }
    }
    Fallback "VertexLit"
}
