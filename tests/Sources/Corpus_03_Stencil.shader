Shader "Corpus/03 Stencil"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _StencilRef ("Stencil Ref", Range(0, 255)) = 1
        _StencilReadMask ("Stencil Read Mask", Range(0, 255)) = 255
        _StencilWriteMask ("Stencil Write Mask", Range(0, 255)) = 255
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }

        Pass
        {
            Name "STENCIL_ALWAYS"
            Stencil
            {
                Ref [_StencilRef]
                ReadMask [_StencilReadMask]
                WriteMask [_StencilWriteMask]
                Comp Always
                Pass Replace
                Fail Keep
                ZFail Zero
            }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0
            #pragma only_renderers d3d11
            #include "UnityCG.cginc"
            float4 _Color;
            struct v2f { float4 pos : SV_POSITION; };
            v2f vert(appdata_base v) { v2f o; o.pos = UnityObjectToClipPos(v.vertex); return o; }
            float4 frag(v2f i) : SV_Target { return _Color; }
            ENDCG
        }

        Pass
        {
            Name "STENCIL_NEVER"
            Stencil
            {
                Ref 2
                ReadMask 127
                WriteMask 127
                Comp Never
                Pass Keep
                Fail IncrSat
                ZFail DecrSat
            }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0
            #pragma only_renderers d3d11
            #include "UnityCG.cginc"
            float4 _Color;
            struct v2f { float4 pos : SV_POSITION; };
            v2f vert(appdata_base v) { v2f o; o.pos = UnityObjectToClipPos(v.vertex); return o; }
            float4 frag(v2f i) : SV_Target { return _Color; }
            ENDCG
        }

        Pass
        {
            Name "STENCIL_LESS"
            Stencil
            {
                Ref 3
                Comp Less
                Pass Invert
                Fail IncrWrap
                ZFail DecrWrap
            }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0
            #pragma only_renderers d3d11
            #include "UnityCG.cginc"
            float4 _Color;
            struct v2f { float4 pos : SV_POSITION; };
            v2f vert(appdata_base v) { v2f o; o.pos = UnityObjectToClipPos(v.vertex); return o; }
            float4 frag(v2f i) : SV_Target { return _Color; }
            ENDCG
        }

        Pass
        {
            Name "STENCIL_LEQUAL"
            Stencil { Ref 4 Comp LEqual Pass Replace }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0
            #pragma only_renderers d3d11
            #include "UnityCG.cginc"
            float4 _Color;
            struct v2f { float4 pos : SV_POSITION; };
            v2f vert(appdata_base v) { v2f o; o.pos = UnityObjectToClipPos(v.vertex); return o; }
            float4 frag(v2f i) : SV_Target { return _Color; }
            ENDCG
        }

        Pass
        {
            Name "STENCIL_EQUAL"
            Stencil { Ref 5 Comp Equal Pass Keep }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0
            #pragma only_renderers d3d11
            #include "UnityCG.cginc"
            float4 _Color;
            struct v2f { float4 pos : SV_POSITION; };
            v2f vert(appdata_base v) { v2f o; o.pos = UnityObjectToClipPos(v.vertex); return o; }
            float4 frag(v2f i) : SV_Target { return _Color; }
            ENDCG
        }

        Pass
        {
            Name "STENCIL_GEQUAL"
            Stencil { Ref 6 Comp GEqual Pass Zero }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0
            #pragma only_renderers d3d11
            #include "UnityCG.cginc"
            float4 _Color;
            struct v2f { float4 pos : SV_POSITION; };
            v2f vert(appdata_base v) { v2f o; o.pos = UnityObjectToClipPos(v.vertex); return o; }
            float4 frag(v2f i) : SV_Target { return _Color; }
            ENDCG
        }

        Pass
        {
            Name "STENCIL_GREATER"
            Stencil { Ref 7 Comp Greater Pass Replace }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0
            #pragma only_renderers d3d11
            #include "UnityCG.cginc"
            float4 _Color;
            struct v2f { float4 pos : SV_POSITION; };
            v2f vert(appdata_base v) { v2f o; o.pos = UnityObjectToClipPos(v.vertex); return o; }
            float4 frag(v2f i) : SV_Target { return _Color; }
            ENDCG
        }

        Pass
        {
            Name "STENCIL_NOTEQUAL"
            Stencil { Ref 8 Comp NotEqual Pass Invert }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0
            #pragma only_renderers d3d11
            #include "UnityCG.cginc"
            float4 _Color;
            struct v2f { float4 pos : SV_POSITION; };
            v2f vert(appdata_base v) { v2f o; o.pos = UnityObjectToClipPos(v.vertex); return o; }
            float4 frag(v2f i) : SV_Target { return _Color; }
            ENDCG
        }
    }
}
