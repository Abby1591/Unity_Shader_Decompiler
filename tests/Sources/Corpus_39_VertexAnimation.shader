Shader "Corpus/39 Vertex Animation"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1, 1, 1, 1)
        _WaveAmplitude ("Wave Amplitude", Range(0, 1)) = 0.1
        _WaveFrequency ("Wave Frequency", Range(0, 20)) = 4
        _WaveSpeed ("Wave Speed", Range(0, 10)) = 2
        _WindDirection ("Wind Direction", Vector) = (1, 0, 1, 0)
        _WindStrength ("Wind Strength", Range(0, 1)) = 0.2
        _Billboard ("Billboard", Range(0, 1)) = 0
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }

        Pass
        {
            Name "VERTEX_ANIMATION"
            Cull Off
            ZWrite On

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 4.0
            #pragma only_renderers d3d11
            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float _WaveAmplitude;
            float _WaveFrequency;
            float _WaveSpeed;
            float4 _WindDirection;
            float _WindStrength;
            float _Billboard;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float4 color : COLOR;
                float3 worldPos : TEXCOORD2;
            };

            v2f vert(appdata v)
            {
                v2f o;
                float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                float3 wind = normalize(_WindDirection.xyz);

                float wave = sin(worldPos.x * _WaveFrequency + _Time.y * _WaveSpeed);
                wave += sin(worldPos.z * _WaveFrequency * 1.3 - _Time.y * _WaveSpeed * 0.7);
                worldPos += worldNormal * wave * _WaveAmplitude * v.color.r;
                worldPos += wind * _WindStrength * (0.5 + 0.5 * sin(_Time.y + worldPos.x));

                float3 right = UNITY_MATRIX_V[0].xyz;
                float3 up = UNITY_MATRIX_V[1].xyz;
                float3 billboardPos = worldPos + right * v.vertex.x + up * v.vertex.y;
                worldPos = lerp(worldPos, billboardPos, _Billboard);

                o.pos = mul(UNITY_MATRIX_VP, float4(worldPos, 1.0));
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = worldNormal;
                o.color = v.color;
                o.worldPos = worldPos;
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float4 c = tex2D(_MainTex, i.uv) * _Color * i.color;
                float3 n = normalize(i.normal);
                float3 l = normalize(UnityWorldSpaceLightDir(i.worldPos));
                c.rgb *= 0.5 + 0.5 * saturate(dot(n, l));
                c.rgb += ShadeSH9(float4(n, 1.0)) * 0.5;
                return c;
            }
            ENDCG
        }
    }

    FallBack "Diffuse"
}
