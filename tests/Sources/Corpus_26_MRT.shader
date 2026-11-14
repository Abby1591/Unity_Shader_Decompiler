Shader "Corpus/26 Multiple Render Targets"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Texture", 2D) = "white" {}
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }

        Pass
        {
            Name "MRT8"
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

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
            };

            struct fout
            {
                float4 t0 : SV_Target0;
                float4 t1 : SV_Target1;
                float4 t2 : SV_Target2;
                float4 t3 : SV_Target3;
                float4 t4 : SV_Target4;
                float4 t5 : SV_Target5;
                float4 t6 : SV_Target6;
                float4 t7 : SV_Target7;
            };

            v2f vert(appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                return o;
            }

            fout frag(v2f i)
            {
                float4 albedo = tex2D(_MainTex, i.uv) * _Color;
                float3 normal = normalize(i.normal);

                fout o;
                o.t0 = albedo;
                o.t1 = float4(normal * 0.5 + 0.5, 1.0);
                o.t2 = float4(i.worldPos * 0.1, 1.0);
                o.t3 = float4(i.uv, 0.0, 1.0);
                o.t4 = float4(1.0, 0.0, 0.0, 1.0);
                o.t5 = float4(0.0, 1.0, 0.0, 1.0);
                o.t6 = float4(0.0, 0.0, 1.0, 1.0);
                o.t7 = float4(frac(i.worldPos.x), frac(i.worldPos.y), frac(i.worldPos.z), 1.0);
                return o;
            }
            ENDCG
        }
    }

    FallBack Off
}
