Shader "Corpus/28 Unity Macros"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "" {}
        _BumpMap ("Normal", 2D) = "" {}
        _Color ("Color", Color) = (1,1,1,1)
        _BumpScale ("Bump Scale", Float) = 1
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
                float4 _BumpMap_ST : packoffset(c3);
                float4 _Color : packoffset(c4);
                float _BumpScale : packoffset(c5.x);
            };
            cbuffer _UnityPerCameraCB_b1
            {
                float3 _WorldSpaceCameraPos : packoffset(c4);
                float4 _ProjectionParams : packoffset(c5);
                float4 _ScreenParams : packoffset(c6);
                float4 _ZBufferParams : packoffset(c7);
            };
            cbuffer _UnityPerDrawCB_b2
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b3
            {
                float4x4 unity_ObjectToWorld_b3 : packoffset(c0);
                float4x4 unity_WorldToObject_b3 : packoffset(c4);
                float4x4 unity_MatrixV : packoffset(c9);
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            SamplerState sampler_BumpMap;
            SamplerState sampler_linear_clamp2;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D t2;
            struct program1Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float4 tangent0 : TANGENT0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program1Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float texcoord4 : TEXCOORD4;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program5Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float texcoord4 : TEXCOORD4;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program5Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program1Output vert(program1Input i)
            {
                program1Output o = (program1Output)0;
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord3.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                float2 r2_zw_1 = ((_ScreenParams.xxxy * float4(0, 0, 0.5, 0.5))).zw;
                float2 r0_xy_8 = ((clipPos_xyzw_7.wwww * (((round(((r2_zw_1.xyxx * ((clipPos_xyzw_7.xyxx / clipPos_xyzw_7.wwww)).xyxx)).xyxx)).xyxx / r2_zw_1.xyxx)).xyxx)).xy;
                o.sv_Position0.xyzw = float4(r0_xy_8.x, r0_xy_8.y, clipPos_xyzw_7.z, clipPos_xyzw_7.w);
                float2 uvMainTex_xy_5 = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord0.xy = (mad(uvMainTex_xy_5.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord1.xy = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                float r1_y_2 = (worldPos_xyzw_1.y * unity_MatrixV[1].z);
                o.texcoord4.x = mad(unity_MatrixV[3].z, worldPos_xyzw_1.w, mad(unity_MatrixV[2].z, worldPos_xyzw_1.z, mad(unity_MatrixV[0].z, worldPos_xyzw_1.x, r1_y_2)));
                float worldNormal_x_5 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_3 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_5, worldNormal_y_3, worldNormal_z_2, worldNormal_x_5), float4(worldNormal_x_5, worldNormal_y_3, worldNormal_z_2, worldNormal_x_5));
                float r1_w_3 = rsqrt(r1_w_2);
                float4 unitWorldNormal_xyzw_6 = (r1_w_3.xxxx * float4(worldNormal_x_5, worldNormal_y_3, worldNormal_z_2, worldNormal_x_5));
                float unitWorldNormal_x_6 = unitWorldNormal_xyzw_6.x;
                float unitWorldNormal_y_4 = unitWorldNormal_xyzw_6.y;
                float unitWorldNormal_z_3 = unitWorldNormal_xyzw_6.z;
                float4 r2_xyzw_6 = (unitWorldNormal_y_4.xxxx * unity_WorldToObject[1].xyzx);
                float r2_x_6 = r2_xyzw_6.x;
                float r2_y_6 = r2_xyzw_6.y;
                float r2_z_2 = r2_xyzw_6.z;
                float4 r1_xyzw_7 = mad(unity_WorldToObject[0].xyxz, unitWorldNormal_x_6.xxxx, float4(r2_x_6, r2_y_6, r2_x_6, r2_z_2));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_5 = r1_xyzw_7.y;
                float r1_w_4 = r1_xyzw_7.w;
                float4 r1_xyzw_8 = mad(unity_WorldToObject[2].xyzx, unitWorldNormal_z_3.xxxx, float4(r1_x_7, r1_y_5, r1_w_4, r1_x_7));
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_6 = r1_xyzw_8.y;
                float r1_z_4 = r1_xyzw_8.z;
                float r1_w_5 = dot(float4(r1_x_8, r1_y_6, r1_z_4, r1_x_8), float4(r1_x_8, r1_y_6, r1_z_4, r1_x_8));
                float r1_w_6 = rsqrt(r1_w_5);
                float4 r1_xyzw_9 = (r1_w_6.xxxx * float4(r1_x_8, r1_y_6, r1_z_4, r1_x_8));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_7 = r1_xyzw_9.y;
                float r1_z_5 = r1_xyzw_9.z;
                float4 r2_xyzw_7 = (r1_y_7.xxxx * unity_ObjectToWorld[1].xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_7 = r2_xyzw_7.y;
                float r2_z_3 = r2_xyzw_7.z;
                float4 r1_xyzw_10 = mad(unity_ObjectToWorld[0].xyxz, r1_x_9.xxxx, float4(r2_x_7, r2_y_7, r2_x_7, r2_z_3));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_8 = r1_xyzw_10.y;
                float r1_w_7 = r1_xyzw_10.w;
                float4 r1_xyzw_11 = mad(unity_ObjectToWorld[2].xyzx, r1_z_5.xxxx, float4(r1_x_10, r1_y_8, r1_w_7, r1_x_10));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_9 = r1_xyzw_11.y;
                float r1_z_6 = r1_xyzw_11.z;
                float r1_w_8 = dot(float4(r1_x_11, r1_y_9, r1_z_6, r1_x_11), float4(r1_x_11, r1_y_9, r1_z_6, r1_x_11));
                float r1_w_9 = rsqrt(r1_w_8);
                o.texcoord2.xyz = ((r1_w_9.xxxx * float4(r1_x_11, r1_y_9, r1_z_6, r1_x_11))).xyz;
                float4 r1_xyzw_12 = (float4(r0_xy_8.x, r0_xy_8.x, clipPos_xyzw_7.w, r0_xy_8.x) * float4(0.5, 0, 0.5, 0));
                float r1_x_12 = r1_xyzw_12.x;
                float r1_z_7 = r1_xyzw_12.z;
                float r1_w_10 = ((r0_xy_8.y * _ProjectionParams.x) * 0.5);
                o.texcoord5.xy = ((r1_z_7.xxxx + float4(r1_x_12, r1_w_10, r1_x_12, r1_x_12))).xy;
                o.texcoord5.zw = (clipPos_xyzw_7.zzzw).zw;
                return o;
            }
            #pragma fragment frag
            program5Output frag(program5Input i)
            {
                program5Output o = (program5Output)0;
                #define LinearEyeDepth(d) (1.0 / (_ZBufferParams.z * (d) + _ZBufferParams.w))
                float3 r0_xyz_4 = (mad(unity_WorldToObject[3].xyzx, unity_ObjectToWorld[0].wwww, (mad(unity_WorldToObject[2].xyzx, unity_ObjectToWorld[0].zzzz, (mad(unity_WorldToObject[0].xyzx, unity_ObjectToWorld[0].xxxx, ((unity_ObjectToWorld[0].yyyy * unity_WorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                float3 r1_xyz_4 = (((mad(unity_WorldToObject[2].xyzx, _WorldSpaceCameraPos.zzzz, (mad(unity_WorldToObject[0].xyzx, _WorldSpaceCameraPos.xxxx, ((_WorldSpaceCameraPos.yyyy * unity_WorldToObject[1].xyzx)).xyzx)).xyzx)).xyzx + unity_WorldToObject[3].xyzx)).xyz;
                float3 r1_xyz_6 = (mad(-i.texcoord3.xyzx, unity_ObjectToWorld[0].wwww, unity_ObjectToWorld[0].xyzx)).xyz;
                float3 viewDir_xyz_7 = ((-i.texcoord3.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float3 r0_xyz_8 = (((((((mad(-i.texcoord3.xyzx, unity_ObjectToWorld[0].wwww, r0_xyz_4.xyzx)).xyzx + ((r1_xyz_4.xyzx + -i.texcoord3.xyzx)).xyzx)).xyzx + r1_xyz_6.xyzx)).xyzx + viewDir_xyz_7.xyzx)).xyz;
                float3 worldPos_xyz_11 = (((mad(unity_ObjectToWorld[2].xyzx, i.texcoord3.zzzz, (mad(unity_ObjectToWorld[0].xyzx, i.texcoord3.xxxx, ((i.texcoord3.yyyy * unity_ObjectToWorld[1].xyzx)).xyzx)).xyzx)).xyzx + unity_ObjectToWorld[3].xyzx)).xyz;
                float3 viewDir_xyz_1 = ((-worldPos_xyz_11.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float4 r1_xyzw_14 = t2.Sample(sampler_linear_clamp2, (((i.texcoord5.xyxx / i.texcoord5.wwww)).xyxx).xy);
                float r0_w_2 = LinearEyeDepth(r1_xyzw_14.x);
                float2 r1_xy_16 = ((float4(1, 1, 1, 1) / (mad(_ZBufferParams.xzxx, i.texcoord4.xxxx, _ZBufferParams.ywyy)).xyxx)).xy;
                float r0_w_3 = (r0_w_2 + r1_xy_16.x);
                float r0_w_4 = (r1_xy_16.y + r0_w_3);
                float4 r1_xyzw_18 = ((frac(i.texcoord4.x)).xxxx * float4(1, 255, 65025, 16581375));
                float4 r1_xyzw_19 = frac(r1_xyzw_18);
                float4 r2_xyzw_2 = mad(-r1_xyzw_19.yzww, float4(0.003921569, 0.003921569, 0.003921569, 0.003921569), r1_xyzw_19);
                float r1_z_16 = dot(r2_xyzw_2, float4(1, 0.003921569, 1.53787E-05, 6.030863E-08));
                float r1_x_20 = r2_xyzw_2.x;
                float r0_w_5 = (r0_w_4 + r1_z_16);
                float r0_w_6 = (dot(float4(r1_x_20, r1_xyzw_19.y, r1_x_20, r1_x_20), float4(1, 0.003921569, 0, 0)) + r0_w_5);
                float4 r1_xyzw_22 = _BumpMap.Sample(sampler_BumpMap, (i.texcoord1.xyxx).xy);
                float r1_x_23 = (r1_xyzw_22.w * r1_xyzw_22.x);
                float4 r1_xyzw_24 = mad(float4(r1_x_23, r1_xyzw_22.y, r1_x_23, r1_x_23), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r1_x_24 = r1_xyzw_24.x;
                float r1_y_20 = r1_xyzw_24.y;
                float4 r1_xyzw_25 = (float4(r1_x_24, r1_y_20, r1_x_24, r1_x_24) * _BumpScale.xxxx);
                float r1_x_25 = r1_xyzw_25.x;
                float r1_y_21 = r1_xyzw_25.y;
                float r1_w_5 = dot(float4(r1_x_25, r1_y_21, r1_x_25, r1_x_25), float4(r1_x_25, r1_y_21, r1_x_25, r1_x_25));
                float r1_w_6 = min(r1_w_5, 1);
                float r1_w_7 = (-r1_w_6 + 1);
                float r1_z_18 = sqrt(r1_w_7);
                float4 r1_xyzw_26 = (float4(r1_x_25, r1_y_21, r1_z_18, r1_x_25) * float4(0.01, 0.01, 0.01, 0));
                float r1_x_26 = r1_xyzw_26.x;
                float r1_y_22 = r1_xyzw_26.y;
                float r1_z_19 = r1_xyzw_26.z;
                float4 r2_xyzw_3 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float3 r3_xyz_5 = (log2((max(((r2_xyzw_3.xyzx * (mad(r2_xyzw_3.xyzx, (mad(r2_xyzw_3.xyzx, float4(0.30530602, 0.30530602, 0.30530602, 0), float4(0.6821711, 0.6821711, 0.6821711, 0))).xyzx, float4(0.012522878, 0.012522878, 0.012522878, 0))).xyzx)).xyzx, float4(0, 0, 0, 0))).xyzx)).xyz;
                float3 r4_xyz_1 = ((r2_xyzw_3.xyzx * _Color.xyzx)).xyz;
                float4 r1_xyzw_27 = mad(r4_xyz_1.xyzx, (max((mad((exp2(((r3_xyz_5.xyzx * float4(0.41666666, 0.41666666, 0.41666666, 0))).xyzx)).xyzx, float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0))).xyzx, float4(0, 0, 0, 0))).xyzx, float4(r1_x_26, r1_y_22, r1_z_19, r1_x_26));
                float r1_x_27 = r1_xyzw_27.x;
                float r1_y_23 = r1_xyzw_27.y;
                float r1_z_20 = r1_xyzw_27.z;
                float4 r1_xyzw_28 = mad(r0_w_6.xxxx, float4(0.001, 0.001, 0.001, 0), float4(r1_x_27, r1_y_23, r1_z_20, r1_x_27));
                float r1_x_28 = r1_xyzw_28.x;
                float r1_y_24 = r1_xyzw_28.y;
                float r1_z_21 = r1_xyzw_28.z;
                float3 r0_xyz_11 = (mad((((mad(-worldPos_xyz_11.xyzx, unity_ObjectToWorld[0].wwww, unity_ObjectToWorld[0].xyzx)).xyzx + ((r0_xyz_8.xyzx + viewDir_xyz_1.xyzx)).xyzx)).xyzx, float4(0.001, 0.001, 0.001, 0), float4(r1_x_28, r1_y_24, r1_z_21, r1_x_28))).xyz;
                float r0_w_7 = dot(r2_xyzw_3.xyzx, float4(0.039681915, 0.4580218, 0.0060965396, 0));
                o.sv_Target0.w = r2_xyzw_3.w;
                float r0_w_8 = saturate((r0_w_7 + dot(r2_xyzw_3.xyzx, float4(0.2126729, 0.7151522, 0.072175, 0))));
                float r0_w_9 = mad(r0_w_8, 0.5, 0.5);
                o.sv_Target0.xyz = ((r0_w_9.xxxx * r0_xyz_11.xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Diffuse"
}
