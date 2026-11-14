Shader "Corpus/45 Debug"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1, 1, 1, 1)
        _DebugMode ("Debug Mode", Int) = 0
        _DebugScale ("Debug Scale", Float) = 1
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }

        Pass
        {
            Name "DEBUG"
            Cull Off
            ZWrite On

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 4.0
            #pragma only_renderers d3d11
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            int _DebugMode;
            float _DebugScale;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float4 tangent : TEXCOORD2;
                float4 color : COLOR;
                float3 worldPos : TEXCOORD3;
                float3 viewDir : TEXCOORD4;
                float4 screenPos : TEXCOORD5;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.tangent = float4(UnityObjectToWorldDir(v.tangent.xyz), v.tangent.w);
                o.color = v.color;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.viewDir = UnityWorldSpaceViewDir(o.worldPos);
                o.screenPos = ComputeScreenPos(o.pos);
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float4 tex = tex2D(_MainTex, i.uv);
                float3 normal = normalize(i.normal);
                float3 tangent = normalize(i.tangent.xyz);
                float3 bitangent = cross(normal, tangent) * i.tangent.w;
                float3 viewDir = normalize(i.viewDir);
                float ndotv = saturate(dot(normal, viewDir));
                float3 color = 0;

                switch (_DebugMode)
                {
                    case 0: color = tex.rgb * _Color.rgb; break;
                    case 1: color = normal * 0.5 + 0.5; break;
                    case 2: color = tangent * 0.5 + 0.5; break;
                    case 3: color = bitangent * 0.5 + 0.5; break;
                    case 4: color = i.uv.xyx; break;
                    case 5: color = i.color.rgb; break;
                    case 6: color = frac(i.worldPos); break;
                    case 7: color = ndotv.xxx; break;
                    case 8: color = (i.screenPos.xy / i.screenPos.w).xyx; break;
                    case 9: color = tex.a.xxx; break;
                    default: color = float3(1, 0, 1); break;
                }

                color *= _DebugScale;
                color = LinearToGammaSpace(saturate(color));
                return float4(color, 1.0);
            }
            ENDCG
        }
    }

    FallBack "Diffuse"
}
