Shader "Corpus/11 Surface Vertex Color"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo", 2D) = "white" {}
        _Wave ("Wave", Float) = 0.1
        _VertexColorBoost ("Vertex Color Boost", Range(0, 2)) = 0.5
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }
        LOD 350

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows vertex:vert finalcolor:finalColor
        #pragma target 4.0
        #pragma only_renderers d3d11

        sampler2D _MainTex;
        fixed4 _Color;
        float _Wave;
        half _VertexColorBoost;

        struct Input
        {
            float2 uv_MainTex;
            float4 color : COLOR;
            float3 worldPos;
        };

        void vert(inout appdata_full v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input, o);
            o.color = v.color;
            v.vertex.xyz += v.normal * sin(v.vertex.x * 8.0 + _Time.y) * _Wave;
        }

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color * IN.color;
            o.Albedo = c.rgb * (1.0 + _VertexColorBoost);
            o.Metallic = IN.color.r * 0.5;
            o.Smoothness = saturate(IN.color.g);
            o.Alpha = c.a;
        }

        void finalColor(Input IN, SurfaceOutputStandard o, inout fixed4 color)
        {
            color.rgb = lerp(color.rgb, color.rgb * IN.color.rgb, 0.25);
        }
        ENDCG
    }

    FallBack "Standard"
}
