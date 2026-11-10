Shader "Corpus/41 Global Arrays"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "" {}
        _ArrayCount ("Array Count", Float) = 4
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
                float4 _MainTex_ST;
                float4 _Color;
                float _ArrayCount;
                float4 _Points[16];
                float4x4 _Matrices[8];
                float4 _Colors[4];
                float _Scalars[8];
                float4 cb0_values[65];
            };
            cbuffer _UnityPerDrawCB_b2
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b3
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            cbuffer CorpusConstantBuffer : register(b1)
            {
                float4 _CBColor : packoffset(c0);
                float4x4 _CBMatrix : packoffset(c1);
                float _CBFloat : packoffset(c5.x);
                float _CBInt : packoffset(c5.y);
                float2 _CBVector : packoffset(c5.z);
            };
            SamplerState sampler_MainTex;
            SamplerState sampler_linear_clamp1;
            Texture2D _MainTex;
            Texture2DArray t1;
            struct program1Input
            {
                float4 position0 : POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 normal0 : NORMAL0;
            };
            struct program1Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program3Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program1Output vert(program1Input i)
            {
                program1Output o = (program1Output)0;
                float3 r0_xyz_4 = (mad(cb0_values[8].xyzx, float4(0.001, 0.001, 0.001, 0), (mad(cb0_values[7].xyzx, float4(0.001, 0.001, 0.001, 0), (mad(cb0_values[6].xyzx, float4(0.001, 0.001, 0.001, 0), (mad(cb0_values[5].xyzx, float4(0.001, 0.001, 0.001, 0), i.position0.xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                float4 r0_xyzw_5 = mad(_CBMatrix[0].xyxz, r0_xyz_4.xxxx, ((r0_xyz_4.yyyy * _CBMatrix[1].xyzx)).xyxz);
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_5 = r0_xyzw_5.y;
                float r0_w_1 = r0_xyzw_5.w;
                float4 r0_xyzw_6 = mad(_CBMatrix[2].xyzx, r0_xyz_4.zzzz, float4(r0_x_5, r0_y_5, r0_w_1, r0_x_5));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_6 = r0_xyzw_6.y;
                float r0_z_5 = r0_xyzw_6.z;
                float4 r0_xyzw_7 = mad(_CBMatrix[3].xyzx, i.position0.wwww, float4(r0_x_6, r0_y_6, r0_z_5, r0_x_6));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_7 = r0_xyzw_7.y;
                float r0_z_6 = r0_xyzw_7.z;
                float4 r1_xyzw_2 = (r0_y_7.xxxx * unity_ObjectToWorld[1]);
                float4 r1_xyzw_3 = mad(unity_ObjectToWorld[0], r0_x_7.xxxx, r1_xyzw_2);
                float4 r0_xyzw_8 = mad(unity_ObjectToWorld[2], r0_z_6.xxxx, r1_xyzw_3);
                float4 r0_xyzw_9 = (r0_xyzw_8 + unity_ObjectToWorld[3]);
                float4 r1_xyzw_4 = (r0_xyzw_9.yyyy * unity_MatrixVP[1]);
                float4 r1_xyzw_5 = mad(unity_MatrixVP[0], r0_xyzw_9.xxxx, r1_xyzw_4);
                float4 r1_xyzw_6 = mad(unity_MatrixVP[2], r0_xyzw_9.zzzz, r1_xyzw_5);
                o.sv_Position0.xyzw = mad(unity_MatrixVP[3], r0_xyzw_9.wwww, r1_xyzw_6);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float4 worldPos_xyzw_10 = (i.position0.yyyy * unity_ObjectToWorld[1].xyzx);
                float worldPos_x_10 = worldPos_xyzw_10.x;
                float worldPos_y_10 = worldPos_xyzw_10.y;
                float worldPos_z_9 = worldPos_xyzw_10.z;
                float4 worldPos_xyzw_11 = mad(unity_ObjectToWorld[0].xyzx, i.position0.xxxx, float4(worldPos_x_10, worldPos_y_10, worldPos_z_9, worldPos_x_10));
                float worldPos_x_11 = worldPos_xyzw_11.x;
                float worldPos_y_11 = worldPos_xyzw_11.y;
                float worldPos_z_10 = worldPos_xyzw_11.z;
                float4 worldPos_xyzw_12 = mad(unity_ObjectToWorld[2].xyzx, i.position0.zzzz, float4(worldPos_x_11, worldPos_y_11, worldPos_z_10, worldPos_x_11));
                float worldPos_x_12 = worldPos_xyzw_12.x;
                float worldPos_y_12 = worldPos_xyzw_12.y;
                float worldPos_z_11 = worldPos_xyzw_12.z;
                o.texcoord1.xyz = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, float4(worldPos_x_12, worldPos_y_12, worldPos_z_11, worldPos_x_12))).xyz;
                float worldNormal_x_13 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_13 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_12 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_4 = dot(float4(worldNormal_x_13, worldNormal_y_13, worldNormal_z_12, worldNormal_x_13), float4(worldNormal_x_13, worldNormal_y_13, worldNormal_z_12, worldNormal_x_13));
                float r0_w_5 = rsqrt(r0_w_4);
                o.texcoord2.xyz = ((r0_w_5.xxxx * float4(worldNormal_x_13, worldNormal_y_13, worldNormal_z_12, worldNormal_x_13))).xyz;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float r0_x_1 = (_CBColor.x + _CBMatrix[0].x);
                float r0_y_1 = (_CBColor.y + _CBMatrix[1].x);
                float r0_z_1 = (_CBColor.z + _CBMatrix[2].x);
                float r0_w_1 = (_CBColor.w + _CBMatrix[3].x);
                float4 r1_xyzw_2 = (cb0_values[53].xyzw + cb0_values[54].xyzw);
                float4 r1_xyzw_3 = (r1_xyzw_2 + cb0_values[55].xyzw);
                float4 r1_xyzw_4 = (r1_xyzw_3 + cb0_values[56].xyzw);
                float4 r1_xyzw_5 = (cb0_values[5].xyzw + cb0_values[6].xyzw);
                float4 r1_xyzw_6 = (r1_xyzw_5 + cb0_values[7].xyzw);
                float4 r1_xyzw_7 = (r1_xyzw_6 + cb0_values[8].xyzw);
                float r1_x_9 = ((cb0_values[21].x + cb0_values[25].y) + cb0_values[29].z);
                float r1_y_7 = ((cb0_values[22].x + cb0_values[26].y) + cb0_values[30].z);
                float r1_z_7 = ((cb0_values[23].x + cb0_values[27].y) + cb0_values[31].z);
                float r1_w_7 = ((cb0_values[24].x + cb0_values[28].y) + cb0_values[32].z);
                float4 r0_xyzw_7 = ((((((float4(r0_x_1, r0_y_1, r0_z_1, r0_w_1) + _CBFloat.xxxx) + ((float)(_CBInt)).xxxx) + _CBVector.xyxy) + r1_xyzw_4) + r1_xyzw_7) + float4(r1_x_9, r1_y_7, r1_z_7, r1_w_7));
                float4 r1_xyzw_10 = t2.Load(0);
                float r2_x_4 = (t3.Load(0)).x;
                float4 r1_xyzw_11 = (r1_xyzw_10 + r2_x_4.xxxx);
                float TEXCOORD0_x_12 = (i.texcoord0.xyxx).x;
                float TEXCOORD0_y_10 = (i.texcoord0.xyxx).y;
                float r1_z_10 = 0;
                float4 r1_xyzw_13 = t1.Sample(sampler_linear_clamp1, (float4(TEXCOORD0_x_12, TEXCOORD0_y_10, r1_z_10, TEXCOORD0_x_12)).xyz);
                float4 r2_xyzw_5 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_14 = (r1_xyzw_13 + r2_xyzw_5);
                float4 r0_xyzw_12 = (((((r0_xyzw_7 + r1_xyzw_11) + r1_xyzw_14) + (((cb0_values[57].x + cb0_values[58].x) + cb0_values[59].x)).xxxx) + float4(1.5, 3, 4.5, 0)) * _Color);
                float r1_x_18 = min(max(_ArrayCount, 0), 7);
                o.sv_Target0.xyz = (mad(cb0_values[r1_x_18 + 57].xxxx, float4(0.1, 0.1, 0.1, 0), r0_xyzw_12.xyzx)).xyz;
                o.sv_Target0.w = r0_xyzw_12.w;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Diffuse"
}
