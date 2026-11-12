Shader "Corpus/25 System Semantics"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _UseDepth ("Use Depth", Float) = 1
    }
    SubShader
    {
        Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
        LOD 0
        Pass
        {
            Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
            Cull Off
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _Color : packoffset(c2);
                float _UseDepth : packoffset(c3.x);
            };
            struct program1Input
            {
                uint sv_Vertexid0 : SV_VertexID;
                uint sv_Instanceid0 : SV_InstanceID;
            };
            struct program1Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                uint texcoord1 : TEXCOORD1;
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                uint texcoord1 : TEXCOORD1;
                uint sv_Primitiveid0 : SV_PrimitiveID;
                uint sv_Isfrontface0 : SV_IsFrontFace;
            };
            struct program3Output
            {
                float4 sv_Target0 : SV_Target;
                float sv_Depth0 : SV_Depth;
                uint sv_Coverage0 : SV_Coverage;
            };
            #pragma vertex vert
            program1Output vert(program1Input i)
            {
                program1Output o = (program1Output)0;
                float r0_x_1 = ((((uint)(0) & ~(1u << (1))) | (((uint)(i.sv_Vertexid0.x) & 1u) << (1))));
                float r0_z_1 = asfloat(asint(i.sv_Vertexid0.x) & asint(2));
                float4 r0_xyzw_2 = (float4)(float4(r0_x_1, r0_z_1, r0_x_1, r0_x_1));
                float r0_x_2 = r0_xyzw_2.x;
                float r0_y_1 = r0_xyzw_2.y;
                o.sv_Position0.xy = (mad(float4(r0_x_2, r0_y_1, r0_x_2, r0_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0))).xy;
                o.texcoord0.xy = (float4(r0_x_2, r0_y_1, r0_x_2, r0_x_2)).xy;
                o.sv_Position0.zw = (float4(0, 0, 0, 1)).zw;
                o.texcoord1.x = i.sv_Instanceid0.x;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float4 r0_xyzw_2 = ((((i.sv_Isfrontface0.x != 0) ? 1 : 0.5)).xxxx * _Color.xyzx);
                float r0_x_2 = r0_xyzw_2.x;
                float r0_y_1 = r0_xyzw_2.y;
                float r0_z_1 = r0_xyzw_2.z;
                float r0_w_1 = asfloat(asint(i.sv_Primitiveid0.x) & asint(1));
                float r0_w_2 = ((r0_w_1 != 0) ? 0.75 : 1);
                float4 r0_xyzw_3 = (r0_w_2.xxxx * float4(r0_x_2, r0_y_1, r0_z_1, r0_x_2));
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_2 = r0_xyzw_3.y;
                float r0_z_2 = r0_xyzw_3.z;
                float r0_w_3 = (float)(i.texcoord1.x);
                float r0_w_4 = mad(r0_w_3, 0.01, 1);
                float4 r0_xyzw_4 = (r0_w_4.xxxx * float4(r0_x_3, r0_y_2, r0_z_2, r0_x_3));
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_3 = r0_xyzw_4.y;
                float r0_z_3 = r0_xyzw_4.z;
                o.sv_Target0.xyz = ((float4(r0_x_4, r0_y_3, r0_z_3, r0_x_4) * i.texcoord0.xyxx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Diffuse"
}
