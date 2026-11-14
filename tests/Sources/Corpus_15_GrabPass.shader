Shader "Corpus/15 Grab Pass"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1, 1, 1, 1)
        _Distortion ("Distortion", Range(0, 0.2)) = 0.05
        _Refraction ("Refraction", Range(0, 1)) = 0.5
    }

    SubShader
    {
        Tags { "Queue" = "Transparent" "RenderType" = "Transparent" "IgnoreProjector" = "True" }

        GrabPass { "_GrabTexture" }

        Pass
        {
            Name "REFRACTION"
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            Cull Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0
            #pragma only_renderers d3d11
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _GrabTexture;
            float4 _GrabTexture_TexelSize;
            float4 _Color;
            float _Distortion;
            float _Refraction;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 grabPos : TEXCOORD1;
                float3 worldNormal : TEXCOORD2;
                float3 worldPos : TEXCOORD3;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.grabPos = ComputeGrabScreenPos(o.pos);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                float3 normal = normalize(i.worldNormal);
                float fresnel = pow(1.0 - saturate(dot(normal, viewDir)), 3.0);

                float2 offset = normal.xy * _Distortion * _GrabTexture_TexelSize.xy;
                float4 grab = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.grabPos + float4(offset, 0, 0)));
                float4 albedo = tex2D(_MainTex, i.uv) * _Color;
                float3 color = lerp(grab.rgb, albedo.rgb, _Refraction + fresnel * 0.2);
                return float4(color, albedo.a * (0.5 + fresnel * 0.5));
            }
            ENDCG
        }
    }

    FallBack "Legacy Shaders/Transparent/Diffuse"
}
