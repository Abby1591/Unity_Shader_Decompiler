Shader "Corpus/10 Surface Tessellation"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo", 2D) = "white" {}
        _Tess ("Tessellation", Range(1, 32)) = 4
        _Disp ("Displacement", Range(0, 1)) = 0.1
        _Phong ("Phong Strength", Range(0, 1)) = 0.5
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }
        LOD 400

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows vertex:disp tessellate:tessEdge tessphong:_Phong
        #pragma target 5.0
        #pragma only_renderers d3d11

        sampler2D _MainTex;
        fixed4 _Color;
        half _Tess;
        half _Disp;
        half _Phong;

        struct Input
        {
            float2 uv_MainTex;
            float3 worldPos;
        };

        float4 tessEdge(appdata_full v0, appdata_full v1, appdata_full v2)
        {
            float4 tess = _Tess.xxxx;
            tess.x = max(1.0, tess.x);
            tess.y = max(1.0, tess.y);
            tess.z = max(1.0, tess.z);
            tess.w = max(1.0, tess.w);
            return tess;
        }

        void disp(inout appdata_full v)
        {
            float2 uv = v.texcoord.xy;
            float wave = sin(uv.x * 12.0 + _Time.y) * cos(uv.y * 10.0 - _Time.y * 0.5);
            v.vertex.xyz += v.normal * wave * _Disp;
        }

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Metallic = 0.1;
            o.Smoothness = 0.5;
            o.Alpha = c.a;
        }
        ENDCG
    }

    FallBack "Standard"
}
