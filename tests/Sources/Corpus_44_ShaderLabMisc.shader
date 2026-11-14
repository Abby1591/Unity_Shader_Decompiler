Shader "Corpus/44 ShaderLab Misc"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Texture", 2D) = "white" {}
        _Mode ("Mode", Int) = 0
        _CategoryColor ("Category Color", Color) = (0.5, 0.5, 0.5, 1)
    }

    Category
    {
        SubShader
        {
            Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }
            LOD 100

            Pass
            {
                Name "CATEGORY_PASS"
                Cull Back
                ZWrite On

                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma target 3.0
                #pragma only_renderers d3d11
                #include "UnityCG.cginc"

                sampler2D _MainTex;
                float4 _MainTex_ST;
                float4 _CategoryColor;
                int _Mode;

                struct v2f { float4 pos : SV_POSITION; float2 uv : TEXCOORD0; };
                v2f vert(appdata_base v) { v2f o; o.pos = UnityObjectToClipPos(v.vertex); o.uv = TRANSFORM_TEX(v.texcoord, _MainTex); return o; }
                float4 frag(v2f i) : SV_Target { return tex2D(_MainTex, i.uv) * _CategoryColor * (_Mode + 1); }
                ENDCG
            }
        }

        SubShader
        {
            Tags { "RenderType" = "Transparent" "Queue" = "Transparent+10" "IgnoreProjector" = "True" }
            LOD 200

            UsePass "Corpus/16 UsePass Base/BASE"

            Pass
            {
                Name "TRANSPARENT_PASS"
                Blend SrcAlpha OneMinusSrcAlpha
                ZWrite Off

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

    FallBack "Diffuse"

    CustomEditor "CorpusShaderGUI"
}
