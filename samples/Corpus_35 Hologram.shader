Shader "Corpus/35 Hologram"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "" {}
        _Color ("Color", Color) = (0.1,0.8,1,1)
        _FresnelPower ("Fresnel Power", Range(0.1, 8)) = 3
        _ScanlineDensity ("Scanline Density", Range(1, 200)) = 80
        _ScanlineSpeed ("Scanline Speed", Range(-10, 10)) = 3
        _FlickerSpeed ("Flicker Speed", Range(0, 20)) = 7
        _NoiseStrength ("Noise Strength", Range(0, 1)) = 0.2
        _Alpha ("Alpha", Range(0, 1)) = 0.6
    }
    SubShader
    {
        Tags { "IGNOREPROJECTOR"="true" "QUEUE"="Transparent" "RenderType"="Transparent" }
        LOD 0
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _MainTex_ST : packoffset(c2);
                float4 _Color : packoffset(c3);
                float _FresnelPower : packoffset(c4.x);
                float _ScanlineDensity : packoffset(c4.y);
                float _ScanlineSpeed : packoffset(c4.z);
                float _FlickerSpeed : packoffset(c4.w);
                float _NoiseStrength : packoffset(c5.x);
                float _Alpha : packoffset(c5.y);
            };
            cbuffer _UnityPerCameraCB_b1
            {
                float4 _Time : packoffset(c0);
                float3 _WorldSpaceCameraPos : packoffset(c4);
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
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
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
                float3 worldPos_xyz_4 = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_4 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r0_w_5 = rsqrt(r0_w_4);
                o.texcoord1.xyz = ((r0_w_5.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = worldPos_xyz_4.xyz;
                o.texcoord3.xyz = ((-worldPos_xyz_4.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float2 r0_xy_1 = (mad(i.texcoord0.xyxx, float4(32, 32, 0, 0), _Time.yyyy)).xy;
                float2 r0_zw_1 = (floor(r0_xy_1.xxxy)).zw;
                float2 r1_xy_3 = (frac(((((r0_zw_1.xyxx + float4(1, 1, 0, 0))).xyxx * float4(0.1031, 0.1031, 0, 0))).xyxx)).xy;
                float r1_z_1 = dot(r1_xy_3.xyxx, ((r1_xy_3.yxxy + float4(33.33, 33.33, 33.33, 0))).xyzx);
                float2 r1_xy_4 = ((r1_z_1.xxxx + r1_xy_3.xyxx)).xy;
                float r1_y_5 = (r1_xy_4.y + r1_xy_4.x);
                float r1_x_5 = (r1_xy_4.x * r1_y_5);
                float4 r2_xyzw_2 = (r0_zw_1.yxyx + float4(0, 1, 1, 0));
                float2 r0_zw_2 = ((r0_zw_1.xxxy * float4(0, 0, 0.1031, 0.1031))).zw;
                float4 r0_xyzw_2 = frac(float4(r0_xy_1.x, r0_xy_1.y, r0_zw_2.x, r0_zw_2.y));
                float4 r2_xyzw_3 = (r2_xyzw_2 * float4(0.1031, 0.1031, 0.1031, 0.1031));
                float4 r2_xyzw_4 = frac(r2_xyzw_3);
                float4 r3_xyzw_1 = (r2_xyzw_4 + float4(33.33, 33.33, 33.33, 33.33));
                float r1_y_6 = dot(r2_xyzw_4.wzww, r3_xyzw_1.zwwz);
                float r1_z_2 = dot(r2_xyzw_4.yxyy, r3_xyzw_1.xyyx);
                float4 r1_xyzw_3 = (r1_z_2.xxxx + r2_xyzw_4.yyyx);
                float r1_z_3 = r1_xyzw_3.z;
                float r1_w_1 = r1_xyzw_3.w;
                float2 r2_xy_5 = ((r1_y_6.xxxx + r2_xyzw_4.wzww)).xy;
                float r1_y_7 = (r2_xy_5.y + r2_xy_5.x);
                float r1_y_8 = (r2_xy_5.x * r1_y_7);
                float4 r1_xyzw_6 = frac(float4(r1_x_5, r1_y_8, r1_x_5, r1_x_5));
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_9 = r1_xyzw_6.y;
                float2 r0_xy_4 = (((mad(-r0_xyzw_2.xyxx, float4(2, 2, 0, 0), float4(3, 3, 0, 0))).xyxx * ((r0_xyzw_2.xyxx * r0_xyzw_2.xyxx)).xyxx)).xy;
                float4 r2_xyzw_7 = (r0_xyzw_2.wzzw + float4(33.33, 33.33, 33.33, 0));
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_7 = r2_xyzw_7.y;
                float r2_z_5 = r2_xyzw_7.z;
                float r1_y_10 = dot(r0_xyzw_2.zwzz, float4(r2_x_7, r2_y_7, r2_z_5, r2_x_7));
                float2 r0_zw_4 = ((r0_xyzw_2.zzzw + r1_y_10.xxxx)).zw;
                float r0_w_5 = (r0_zw_4.y + r0_zw_4.x);
                float r0_z_5 = (r0_zw_4.x * r0_w_5);
                float r0_w_6 = (r1_w_1 + r1_z_3);
                float r0_w_7 = (r1_z_3 * r0_w_6);
                float4 r0_xyzw_6 = frac(float4(r0_z_5, r0_z_5, r0_z_5, r0_w_7));
                float r0_z_6 = r0_xyzw_6.z;
                float r0_w_8 = r0_xyzw_6.w;
                float r0_w_9 = (-r0_z_6 + r0_w_8);
                float r0_x_5 = mad(r0_xy_4.x, r0_w_9, r0_z_6);
                float r0_z_7 = (-r0_x_5 + mad(r0_xy_4.x, (-r1_y_9 + r1_x_6), r1_y_9));
                float r0_y_5 = dot(i.texcoord1.xyzx, i.texcoord1.xyzx);
                float r0_y_6 = rsqrt(r0_y_5);
                float4 unitWorldPos_xyzw_7 = (r0_y_6.xxxx * i.texcoord1.xxyz);
                float unitWorldPos_y_7 = unitWorldPos_xyzw_7.y;
                float unitWorldPos_z_8 = unitWorldPos_xyzw_7.z;
                float unitWorldPos_w_10 = unitWorldPos_xyzw_7.w;
                float4 unitWorldPos_xyzw_11 = ((rsqrt(dot(i.texcoord3.xyzx, i.texcoord3.xyzx))).xxxx * i.texcoord3.xyzx);
                float unitWorldPos_x_11 = unitWorldPos_xyzw_11.x;
                float unitWorldPos_y_11 = unitWorldPos_xyzw_11.y;
                float unitWorldPos_z_4 = unitWorldPos_xyzw_11.z;
                float r0_y_8 = saturate(dot(float4(unitWorldPos_y_7, unitWorldPos_z_8, unitWorldPos_w_10, unitWorldPos_y_7), float4(unitWorldPos_x_11, unitWorldPos_y_11, unitWorldPos_z_4, unitWorldPos_x_11)));
                float r0_y_9 = (-r0_y_8 + 1);
                float r0_y_10 = log2(r0_y_9);
                float r0_y_11 = (r0_y_10 * _FresnelPower);
                float r0_y_12 = exp2(r0_y_11);
                float4 r1_xyzw_12 = (r0_y_12.xxxx * _Color.xyzx);
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_12 = r1_xyzw_12.y;
                float r1_z_5 = r1_xyzw_12.z;
                float4 r1_xyzw_13 = (float4(r1_x_12, r1_y_12, r1_z_5, r1_x_12) + float4(r1_x_12, r1_y_12, r1_z_5, r1_x_12));
                float r1_x_13 = r1_xyzw_13.x;
                float r1_y_13 = r1_xyzw_13.y;
                float r1_z_6 = r1_xyzw_13.z;
                float4 r2_xyzw_8 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_14 = mad(_Color.xyzx, r2_xyzw_8.xyzx, float4(r1_x_13, r1_y_13, r1_z_6, r1_x_13));
                float r1_x_14 = r1_xyzw_14.x;
                float r1_y_14 = r1_xyzw_14.y;
                float r1_z_7 = r1_xyzw_14.z;
                float r0_z_9 = mad(_Time.y, _ScanlineSpeed, i.texcoord2.y);
                float r0_z_10 = (r0_z_9 * _ScanlineDensity);
                float r0_z_11 = sin(r0_z_10);
                float4 r0_xyzw_12 = mad(r0_z_11.xxxx, float4(0, 0, 0.5, 0.5), float4(0, 0, -0.5, 0.5));
                float r0_z_12 = r0_xyzw_12.z;
                float r0_w_11 = r0_xyzw_12.w;
                float r0_z_13 = mad(r0_z_12, 0.7, 1);
                float r0_y_13 = mad(r0_w_11, 0.3, r0_y_12);
                float r0_y_14 = (r0_y_13 * _Alpha);
                float r0_y_15 = saturate((r2_xyzw_8.w * r0_y_14));
                float4 r1_xyzw_15 = (r0_z_13.xxxx * float4(r1_x_14, r1_y_14, r1_z_7, r1_x_14));
                float r1_x_15 = r1_xyzw_15.x;
                float r1_y_15 = r1_xyzw_15.y;
                float r1_z_8 = r1_xyzw_15.z;
                float4 r0_xyzw_9 = ((mad(_NoiseStrength, (mad(r0_xy_4.y, r0_z_7, r0_x_5) + -1), 1)).xxxx * float4(r1_x_15, r1_x_15, r1_y_15, r1_z_8));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_14 = r0_xyzw_9.z;
                float r0_w_12 = r0_xyzw_9.w;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_x_9, r0_z_14, r0_w_12) * (mad(sin((_FlickerSpeed * _Time.y)), 0.3, 0.7)).xxxx);
                float r0_x_10 = r0_xyzw_10.x;
                float r0_z_15 = r0_xyzw_10.z;
                float r0_w_13 = r0_xyzw_10.w;
                o.sv_Target0.xyz = ((r0_y_15.xxxx * float4(r0_x_10, r0_z_15, r0_w_13, r0_x_10))).xyz;
                o.sv_Target0.w = r0_y_15;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Legacy Shaders/Transparent/VertexLit"
}
