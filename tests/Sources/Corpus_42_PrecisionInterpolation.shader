Shader "Corpus/42 Precision Interpolation"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Texture", 2D) = "white" {}
        _Precision ("Precision", Range(0, 1)) = 0.5
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }

        Pass
        {
            Name "PRECISION"
            Cull Off
            ZWrite On

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 5.0
            #pragma only_renderers d3d11
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float _Precision;

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
                linear float2 uv : TEXCOORD0;
                centroid float3 normal : TEXCOORD1;
                noperspective float2 screen : TEXCOORD2;
                sample float3 samplePos : TEXCOORD3;
                nointerpolation float4 flatColor : TEXCOORD4;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.screen = o.pos.xy / o.pos.w * 0.5 + 0.5;
                o.samplePos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.flatColor = v.color;
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                half4 halfColor = half4(_Color);
                min16float minColor = (min16float)_Color.r;
                float4 tex = tex2D(_MainTex, i.uv);
                float3 normal = normalize((float3)i.normal);

                float4 color = tex * halfColor;
                color.rgb *= 0.5 + 0.5 * saturate(dot(normal, normalize(UnityWorldSpaceLightDir(i.samplePos))));
                color.rgb += i.flatColor.rgb * 0.1;
                color.rgb += (float)minColor * 0.05;
                color.rgb *= lerp(1.0, i.screen.x, _Precision * 0.1);
                color.rgb += abs(i.samplePos) * 0.0001;
                return color;
            }
            ENDCG
        }
    }

    FallBack "Diffuse"
}
