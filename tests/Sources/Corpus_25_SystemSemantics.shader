Shader "Corpus/25 System Semantics"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _UseDepth ("Use Depth", Float) = 1
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }

        Pass
        {
            Name "SYSTEM_SEMANTICS"
            Cull Off
            ZWrite On

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 5.0
            #pragma only_renderers d3d11
            #include "UnityCG.cginc"

            float4 _Color;
            float _UseDepth;

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                uint instanceID : TEXCOORD1;
            };

            struct fout
            {
                float4 color : SV_Target0;
                float depth : SV_Depth;
                uint coverage : SV_Coverage;
            };

            v2f vert(uint vertexID : SV_VertexID, uint instanceID : SV_InstanceID)
            {
                v2f o;
                float2 uv = float2((vertexID << 1) & 2, vertexID & 2);
                o.pos = float4(uv * 2.0 - 1.0, 0.0, 1.0);
                o.uv = uv;
                o.instanceID = instanceID;
                return o;
            }

            fout frag(v2f i, uint primitiveID : SV_PrimitiveID, bool isFrontFace : SV_IsFrontFace)
            {
                fout o;
                float3 color = _Color.rgb * (isFrontFace ? 1.0 : 0.5);
                color *= (primitiveID % 2) == 0 ? 1.0 : 0.75;
                color *= 1.0 + (float)i.instanceID * 0.01;
                color *= i.uv.xyx;
                o.color = float4(color, 1.0);
                o.depth = _UseDepth > 0.5 ? i.pos.z / i.pos.w : 0.5;
                o.coverage = 0xFFFFFFFFu;
                return o;
            }
            ENDCG
        }
    }

    FallBack "Diffuse"
}
