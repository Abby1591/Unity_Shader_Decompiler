Shader "Corpus/08 Surface Blinn Phong"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo", 2D) = "white" {}
        _BumpMap ("Normal", 2D) = "bump" {}
        _SpecColor ("Specular", Color) = (0.5,0.5,0.5,1)
        _Shininess ("Shininess", Range(0.01, 1)) = 0.078125
        _Gloss ("Gloss", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
        LOD 200
        CGPROGRAM
        #include "UnityCG.cginc"
        #pragma surface surf BlinnPhong fullforwardshadows
        #pragma target 3.5

        float4 _Color;
        sampler2D _MainTex;
        sampler2D _BumpMap;
        float _Shininess;
        float _Gloss;

        // Best-effort surface reconstruction from the compiled
        // passes. The passes are authoritative; vertex, finalcolor
        // and tessellation functions (if any) are not recovered.

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
            float3 worldPos;
            INTERNAL_DATA
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
            o.Specular = _Shininess;
            o.Gloss = _Gloss;
            o.Emission = WorldNormalVector(IN, o.Normal) * 0.001;
            o.Alpha = c.a;
        }
        ENDCG

        // Compiled passes omitted for size. Rerun with
        // --keep-passes to include the verified passes.
    }
    Fallback "Legacy Shaders/Specular"
}
