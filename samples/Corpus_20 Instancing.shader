Shader "Corpus/20 Instancing"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "" {}
        _Scale ("Per Instance Scale", Range(0, 2)) = 1
    }
    SubShader
    {
        Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
        LOD 0
        Pass
        {
            Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _Color : packoffset(c0);
                float4 _MainTex_ST : packoffset(c2);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            cbuffer Props : register(b3)
            {
                float4 _Color_b3 : packoffset(c0);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program1Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program1Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
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
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float3 worldNormal_xyz_5 = ((i.normal0.yyyy * unity_ObjectToWorld[1].xyzx)).xyz;
                float3 worldNormal_xyz_6 = (mad(unity_ObjectToWorld[0].xyzx, i.normal0.xxxx, worldNormal_xyz_5.xyzx)).xyz;
                float3 worldNormal_xyz_7 = (mad(unity_ObjectToWorld[2].xyzx, i.normal0.zzzz, worldNormal_xyz_6.xyzx)).xyz;
                float r0_w_5 = dot(worldNormal_xyz_7.xyzx, worldNormal_xyz_7.xyzx);
                float r0_w_6 = rsqrt(r0_w_5);
                o.texcoord1.xyz = ((r0_w_6.xxxx * worldNormal_xyz_7.xyzx)).xyz;
                o.texcoord2.xyzw = _Color;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float unitWorldNormal_x_3 = (rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx)) * i.texcoord1.y);
                float4 r1_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = ((r1_xyzw_1 * _Color) * i.texcoord2.xyzw);
                o.sv_Target0.xyz = (((saturate(mad(unitWorldNormal_x_3, 0.5, 0.5))).xxxx * r1_xyzw_3.xyzx)).xyz;
                o.sv_Target0.w = r1_xyzw_3.w;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Diffuse"
}
