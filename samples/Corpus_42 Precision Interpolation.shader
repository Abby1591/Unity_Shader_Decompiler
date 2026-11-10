Shader "Corpus/42 Precision Interpolation"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "" {}
        _Precision ("Precision", Range(0, 1)) = 0.5
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
                float4 _MainTex_ST : packoffset(c2);
                float4 _Color : packoffset(c3);
                float _Precision : packoffset(c4.x);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
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
                float4 color0 : COLOR0;
            };
            struct program1Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
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
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord3.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord2.xy = (mad(((clipPos_xyzw_7.xyxx / clipPos_xyzw_7.wwww)).xyxx, float4(0.5, 0.5, 0, 0), float4(0.5, 0.5, 0, 0))).xy;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_9 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_9 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_9, worldNormal_y_9, worldNormal_z_8, worldNormal_x_9), float4(worldNormal_x_9, worldNormal_y_9, worldNormal_z_8, worldNormal_x_9));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord1.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_9, worldNormal_y_9, worldNormal_z_8, worldNormal_x_9))).xyz;
                o.texcoord4.xyzw = i.color0.xyzw;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float3 r0_xyz_1 = (mad(-i.texcoord3.xyzx, unity_ObjectToWorld[0].wwww, unity_ObjectToWorld[0].xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float4 r0_xyzw_3 = (i.texcoord4.xxyz * float4(0, 0.1, 0.1, 0.1));
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_5 = r0_xyzw_3.w;
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                float4 r0_xyzw_5 = mad(r1_xyzw_3.xyzx, (mad(saturate(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx)), 0.5, 0.5)).xxxx, float4(r0_y_3, r0_z_3, r0_w_5, r0_y_3));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                o.sv_Target0.w = r1_xyzw_3.w;
                float4 r0_xyzw_6 = mad(_Color.xxxx, float4(0.05, 0.05, 0.05, 0), float4(r0_x_5, r0_y_4, r0_z_4, r0_x_5));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_5 = r0_xyzw_6.y;
                float r0_z_5 = r0_xyzw_6.z;
                float r0_w_6 = (_Precision * 0.1);
                float r0_w_7 = mad(r0_w_6, (i.texcoord2.x + -1), 1);
                float4 r1_xyzw_5 = (abs(i.texcoord3.xyzx) * float4(0.0001, 0.0001, 0.0001, 0));
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_4 = r1_xyzw_5.y;
                float r1_z_4 = r1_xyzw_5.z;
                o.sv_Target0.xyz = (mad(float4(r0_x_6, r0_y_5, r0_z_5, r0_x_6), r0_w_7.xxxx, float4(r1_x_5, r1_y_4, r1_z_4, r1_x_5))).xyz;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Diffuse"
}
