Shader "Corpus/39 Vertex Animation"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "" {}
        _Color ("Color", Color) = (1,1,1,1)
        _WaveAmplitude ("Wave Amplitude", Range(0, 1)) = 0.1
        _WaveFrequency ("Wave Frequency", Range(0, 20)) = 4
        _WaveSpeed ("Wave Speed", Range(0, 10)) = 2
        _WindDirection ("Wind Direction", Vector) = (1,0,1,0)
        _WindStrength ("Wind Strength", Range(0, 1)) = 0.2
        _Billboard ("Billboard", Range(0, 1)) = 0
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
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
                float _WaveAmplitude : packoffset(c6.x);
                float _WaveFrequency : packoffset(c6.y);
                float _WaveSpeed : packoffset(c6.z);
                float4 _WindDirection : packoffset(c7);
                float _WindStrength : packoffset(c8.x);
                float _Billboard : packoffset(c8.y);
            };
            cbuffer _UnityPerCameraCB_b1
            {
                float4 _WorldSpaceLightPos0 : packoffset(c0);
                float4 unity_SHAr : packoffset(c39);
                float4 unity_SHAg : packoffset(c40);
                float4 unity_SHAb : packoffset(c41);
                float4 unity_SHBr : packoffset(c42);
                float4 unity_SHBg : packoffset(c43);
                float4 unity_SHBb : packoffset(c44);
                float4 unity_SHC : packoffset(c45);
            };
            cbuffer _UnityPerDrawCB_b2
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b3
            {
                float4x4 unity_MatrixV : packoffset(c9);
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
                float4 color0 : COLOR0;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
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
                float3 worldPos_xyz_1 = ((i.position0.yyyy * unity_ObjectToWorld[1].xyzx)).xyz;
                float3 worldPos_xyz_2 = (mad(unity_ObjectToWorld[0].xyzx, i.position0.xxxx, worldPos_xyz_1.xyzx)).xyz;
                float3 worldPos_xyz_3 = (mad(unity_ObjectToWorld[2].xyzx, i.position0.zzzz, worldPos_xyz_2.xyzx)).xyz;
                float3 worldPos_xyz_4 = (mad(unity_ObjectToWorld[3].xyzx, i.position0.wwww, worldPos_xyz_3.xyzx)).xyz;
                float r0_w_1 = (worldPos_xyz_4.z * _WaveFrequency);
                float r1_x_1 = (_WaveSpeed * _WorldSpaceLightPos0.y);
                float r1_y_1 = (r1_x_1 * 0.7);
                float r0_w_2 = mad(r0_w_1, 1.3, -r1_y_1);
                float r0_w_3 = sin(r0_w_2);
                float noiseAccum_w_4 = (r0_w_3 + sin(mad(worldPos_xyz_4.x, _WaveFrequency, r1_x_1)));
                float worldNormal_x_4 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_1 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_1 = dot(float4(worldNormal_x_4, worldNormal_y_2, worldNormal_z_1, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_2, worldNormal_z_1, worldNormal_x_4));
                float r1_w_2 = rsqrt(r1_w_1);
                float4 unitWorldNormal_xyzw_5 = (r1_w_2.xxxx * float4(worldNormal_x_4, worldNormal_y_2, worldNormal_z_1, worldNormal_x_4));
                float unitWorldNormal_x_5 = unitWorldNormal_xyzw_5.x;
                float unitWorldNormal_y_3 = unitWorldNormal_xyzw_5.y;
                float unitWorldNormal_z_2 = unitWorldNormal_xyzw_5.z;
                o.texcoord1.xyz = (float4(unitWorldNormal_x_5, unitWorldNormal_y_3, unitWorldNormal_z_2, unitWorldNormal_x_5)).xyz;
                float4 r1_xyzw_6 = (((noiseAccum_w_4.xxxx * float4(unitWorldNormal_x_5, unitWorldNormal_y_3, unitWorldNormal_z_2, unitWorldNormal_x_5))).xyzx * _WaveAmplitude.xxxx);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                float3 r0_xyz_5 = (mad(float4(r1_x_6, r1_y_4, r1_z_3, r1_x_6), i.color0.xxxx, worldPos_xyz_4.xyzx)).xyz;
                float r0_w_5 = (r0_xyz_5.x + _WorldSpaceLightPos0.y);
                float r0_w_6 = sin(r0_w_5);
                float r0_w_7 = mad(r0_w_6, 0.5, 0.5);
                float4 r1_xyzw_9 = ((rsqrt(dot(_WindDirection.xyzx, _WindDirection.xyzx))).xxxx * _WindDirection.xyzx);
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_5 = r1_xyzw_9.y;
                float r1_z_4 = r1_xyzw_9.z;
                float4 r1_xyzw_10 = (float4(r1_x_9, r1_y_5, r1_z_4, r1_x_9) * _WindStrength.xxxx);
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_6 = r1_xyzw_10.y;
                float r1_z_5 = r1_xyzw_10.z;
                float3 r0_xyz_6 = (mad(float4(r1_x_10, r1_y_6, r1_z_5, r1_x_10), r0_w_7.xxxx, r0_xyz_5.xyzx)).xyz;
                float r1_x_11 = (i.position0.x * unity_MatrixV[0].x);
                float r1_y_7 = (i.position0.x * unity_MatrixV[1].x);
                float r1_z_6 = (i.position0.x * unity_MatrixV[2].x);
                float4 r1_xyzw_12 = (r0_xyz_6.xyzx + float4(r1_x_11, r1_y_7, r1_z_6, r1_x_11));
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_8 = r1_xyzw_12.y;
                float r1_z_7 = r1_xyzw_12.z;
                float r2_x_2 = (i.position0.y * unity_MatrixV[0].y);
                float r2_y_2 = (i.position0.y * unity_MatrixV[1].y);
                float r2_z_2 = (i.position0.y * unity_MatrixV[2].y);
                float4 r1_xyzw_13 = (float4(r1_x_12, r1_y_8, r1_z_7, r1_x_12) + float4(r2_x_2, r2_y_2, r2_z_2, r2_x_2));
                float r1_x_13 = r1_xyzw_13.x;
                float r1_y_9 = r1_xyzw_13.y;
                float r1_z_8 = r1_xyzw_13.z;
                float4 r1_xyzw_14 = (-r0_xyz_6.xyzx + float4(r1_x_13, r1_y_9, r1_z_8, r1_x_13));
                float r1_x_14 = r1_xyzw_14.x;
                float r1_y_10 = r1_xyzw_14.y;
                float r1_z_9 = r1_xyzw_14.z;
                float3 r0_xyz_7 = (mad(_Billboard.xxxx, float4(r1_x_14, r1_y_10, r1_z_9, r1_x_14), r0_xyz_6.xyzx)).xyz;
                float4 r1_xyzw_15 = (r0_xyz_7.yyyy * unity_MatrixVP[1]);
                float4 r1_xyzw_16 = mad(unity_MatrixVP[0], r0_xyz_7.xxxx, r1_xyzw_15);
                float4 r1_xyzw_17 = mad(unity_MatrixVP[2], r0_xyz_7.zzzz, r1_xyzw_16);
                o.texcoord2.xyz = r0_xyz_7.xyz;
                o.sv_Position0.xyzw = (r1_xyzw_17 + unity_MatrixVP[3]);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.color0.xyzw = i.color0.xyzw;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float4 r2_xyzw_1 = (float4(unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1, unitWorldNormal_x_3) * float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1));
                float r3_x_1 = dot(unity_SHBr, r2_xyzw_1);
                float r3_y_1 = dot(unity_SHBg, r2_xyzw_1);
                float r3_z_1 = dot(unity_SHBb, r2_xyzw_1);
                float4 r1_xyzw_3 = mad(unity_SHC.xyzx, (mad(unitWorldNormal_x_3, unitWorldNormal_x_3, (unitWorldNormal_y_1 * unitWorldNormal_y_1))).xxxx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_1 = r1_xyzw_3.y;
                float r1_z_1 = r1_xyzw_3.z;
                float r0_w_1 = 1;
                float r2_x_2 = dot(unity_SHAr, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r0_w_1));
                float r2_y_2 = dot(unity_SHAg, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r0_w_1));
                float r2_z_2 = dot(unity_SHAb, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r0_w_1));
                float4 r1_xyzw_4 = (float4(r1_x_3, r1_y_1, r1_z_1, r1_x_3) + float4(r2_x_2, r2_y_2, r2_z_2, r2_x_2));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_2 = r1_xyzw_4.y;
                float r1_z_2 = r1_xyzw_4.z;
                float4 r1_xyzw_5 = (float4(r1_x_4, r1_y_2, r1_z_2, r1_x_4) * float4(0.5, 0.5, 0.5, 0));
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_3 = r1_xyzw_5.y;
                float r1_z_3 = r1_xyzw_5.z;
                float4 r2_xyzw_3 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r2_xyzw_4 = (r2_xyzw_3 * _Color);
                float4 r2_xyzw_5 = (r2_xyzw_4 * i.color0.xyzw);
                float3 r3_xyz_2 = (mad(-i.texcoord2.xyzx, _WorldSpaceLightPos0.wwww, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_2 = dot(r3_xyz_2.xyzx, r3_xyz_2.xyzx);
                float r0_w_3 = rsqrt(r0_w_2);
                o.sv_Target0.xyz = (mad(r2_xyzw_5.xyzx, (mad(saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_3.xxxx * r3_xyz_2.xyzx)).xyzx)), 0.5, 0.5)).xxxx, float4(r1_x_5, r1_y_3, r1_z_3, r1_x_5))).xyz;
                o.sv_Target0.w = r2_xyzw_5.w;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Diffuse"
}
