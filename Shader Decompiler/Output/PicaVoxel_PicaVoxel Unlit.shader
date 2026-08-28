Shader "PicaVoxel/PicaVoxel Unlit"
{
    Properties
    {
        _Tint ("Tint", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
        Pass
        {
            Tags { "LIGHTMODE"="ALWAYS" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _UnityPerDrawCB_b0
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
            };
            cbuffer _UnityPerFrameCB_b1
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            struct program1Input
            {
                float4 position0 : POSITION0;
                float4 color0 : COLOR0;
            };
            struct program1Output
            {
                float4 sv_Position0 : SV_Position;
                float4 color0 : COLOR0;
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_Position;
                float4 color0 : COLOR0;
            };
            struct program3Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program1Output vert(program1Input i)
            {
                program1Output o = (program1Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_4 = UnityObjectToWorldPos(i.position0.xyz);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_4);
                o.color0.xyzw = i.color0.xyzw;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                o.sv_Target0.xyzw = (i.color0.xyzw * unity_ObjectToWorld[0]);
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "VertexLit"
}
