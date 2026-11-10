Shader "Corpus/21 Stereo"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "" {}
        _EyeTint ("Eye Tint", Color) = (1,0.5,0.5,1)
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
                float4 _MainTex_ST : packoffset(c2);
                float4 _Color : packoffset(c3);
                float4 _EyeTint : packoffset(c4);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float unity_StereoEyeIndex : packoffset(c21.x);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
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
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
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
                float worldNormal_x_5 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_5 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_5 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_5 = dot(float4(worldNormal_x_5, worldNormal_y_5, worldNormal_z_5, worldNormal_x_5), float4(worldNormal_x_5, worldNormal_y_5, worldNormal_z_5, worldNormal_x_5));
                float r0_w_6 = rsqrt(r0_w_5);
                o.texcoord1.xyz = ((r0_w_6.xxxx * float4(worldNormal_x_5, worldNormal_y_5, worldNormal_z_5, worldNormal_x_5))).xyz;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float unitWorldNormal_x_3 = (rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx)) * i.texcoord1.y);
                float r0_y_1 = (float)(unity_StereoEyeIndex);
                float4 r1_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_2 = (r1_xyzw_1 * _Color);
                float4 r0_xyzw_2 = mad(r0_y_1.xxxx, (mad(r1_xyzw_2.xyzx, _EyeTint.xyzx, -r1_xyzw_2.xyzx)).xxyz, r1_xyzw_2.xxyz);
                float r0_y_2 = r0_xyzw_2.y;
                float r0_z_1 = r0_xyzw_2.z;
                float r0_w_1 = r0_xyzw_2.w;
                o.sv_Target0.w = r1_xyzw_2.w;
                o.sv_Target0.xyz = (((saturate(mad(unitWorldNormal_x_3, 0.5, 0.5))).xxxx * float4(r0_y_2, r0_z_1, r0_w_1, r0_y_2))).xyz;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Diffuse"
}
