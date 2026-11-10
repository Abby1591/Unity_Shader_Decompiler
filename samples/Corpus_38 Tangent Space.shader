Shader "Corpus/38 Tangent Space"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo", 2D) = "" {}
        _BumpMap ("Normal", 2D) = "" {}
        _BumpScale ("Normal Scale", Float) = 1
        _ParallaxMap ("Height", 2D) = "" {}
        _Parallax ("Parallax", Range(0, 0.1)) = 0.02
        _DetailMask ("Detail Mask", 2D) = "" {}
        _DetailAlbedo ("Detail Albedo", 2D) = "" {}
        _DetailNormal ("Detail Normal", 2D) = "" {}
        _DetailScale ("Detail Scale", Float) = 4
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
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _BumpMap_ST : packoffset(c5);
                float4 _ParallaxMap_ST : packoffset(c6);
                float4 _Color : packoffset(c9);
                float _BumpScale : packoffset(c10.x);
                float _Parallax : packoffset(c10.y);
                float _DetailScale : packoffset(c10.z);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_WorldTransformParams : packoffset(c9);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4 _WorldSpaceLightPos0 : packoffset(c0);
                float4x4 unity_MatrixVP : packoffset(c17);
                float4 unity_SHAr : packoffset(c39);
                float4 unity_SHAg : packoffset(c40);
                float4 unity_SHAb : packoffset(c41);
                float4 unity_SHBr : packoffset(c42);
                float4 unity_SHBg : packoffset(c43);
                float4 unity_SHBb : packoffset(c44);
                float4 unity_SHC : packoffset(c45);
            };
            SamplerState sampler_BumpMap;
            SamplerState sampler_ParallaxMap;
            SamplerState sampler_MainTex;
            SamplerState sampler_DetailMask;
            SamplerState sampler_DetailAlbedo;
            SamplerState sampler_DetailNormal;
            Texture2D _MainTex;
            Texture2D _BumpMap;
            Texture2D _ParallaxMap;
            Texture2D _DetailMask;
            Texture2D _DetailAlbedo;
            Texture2D _DetailNormal;
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
                float2 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
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
                o.texcoord6.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord1.xy = (mad(i.texcoord0.xxxy, _BumpMap_ST.xxxy, _BumpMap_ST.zzzw)).zw;
                o.texcoord2.xy = (mad(i.texcoord0.xyxx, _ParallaxMap_ST.xyxx, _ParallaxMap_ST.zwzz)).xy;
                float3 worldTangent_xyz_7 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].xyzx)).xyz;
                float3 worldTangent_xyz_8 = (mad(unity_ObjectToWorld[0].xyzx, i.tangent0.xxxx, worldTangent_xyz_7.xyzx)).xyz;
                float3 worldTangent_xyz_9 = (mad(unity_ObjectToWorld[2].xyzx, i.tangent0.zzzz, worldTangent_xyz_8.xyzx)).xyz;
                float3 unitWorldTangent_xyz_10 = normalize(worldTangent_xyz_9);
                o.texcoord3.xyz = unitWorldTangent_xyz_10.xyz;
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_9 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r0_w_10 = rsqrt(r0_w_9);
                float3 unitWorldNormal_xyz_3 = ((r0_w_10.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord5.xyz = unitWorldNormal_xyz_3.xyz;
                o.texcoord4.xyz = (((((mad(unitWorldNormal_xyz_3.yzxy, unitWorldTangent_xyz_10.zxyz, ((unitWorldTangent_xyz_10.yzxy * unitWorldNormal_xyz_3.zxyz)).xyzx)).xyzx * i.tangent0.wwww)).xyzx * unity_WorldTransformParams.wwww)).xyz;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord2.xyxx).xy);
                float3 viewDir_yzw_2 = ((-i.texcoord6.xxyz + unity_WorldToObject[0].xxyz)).yzw;
                float3 unitViewDir_yzw_3 = ((viewDir_yzw_2.xxyz * (rsqrt(dot(viewDir_yzw_2.xyzx, viewDir_yzw_2.xyzx))).xxxx)).yzw;
                float4 unitWorldTangent_xyzw_5 = ((rsqrt(dot(i.texcoord3.xyzx, i.texcoord3.xyzx))).xxxx * i.texcoord3.xyzx);
                float unitWorldTangent_x_5 = unitWorldTangent_xyzw_5.x;
                float unitWorldTangent_y_1 = unitWorldTangent_xyzw_5.y;
                float unitWorldTangent_z_1 = unitWorldTangent_xyzw_5.z;
                float nDotV_x_1 = dot(unitViewDir_yzw_3.xyzx, float4(unitWorldTangent_x_5, unitWorldTangent_y_1, unitWorldTangent_z_1, unitWorldTangent_x_5));
                float3 r3_xyz_1 = normalize(i.texcoord4);
                float r2_y_1 = dot(unitViewDir_yzw_3.xyzx, r3_xyz_1.xyzx);
                float4 r0_xyzw_4 = mad((((r0_xyzw_1.x + -0.5) * _Parallax)).xxxx, float4(nDotV_x_1, r2_y_1, nDotV_x_1, r2_y_1), float4(i.texcoord0.x, i.texcoord0.y, i.texcoord1.x, i.texcoord1.y));
                float4 r2_xyzw_2 = _ParallaxMap.Sample(sampler_ParallaxMap, (r0_xyzw_4.zwzz).xy);
                float r2_x_3 = (r2_xyzw_2.w * r2_xyzw_2.x);
                float2 r0_zw_5 = (mad(float4(r2_x_3, r2_x_3, r2_x_3, r2_xyzw_2.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1))).zw;
                float4 r2_xyzw_4 = (r0_zw_5.xyxx * _BumpScale.xxxx);
                float r2_x_4 = r2_xyzw_4.x;
                float r2_y_3 = r2_xyzw_4.y;
                float r0_z_6 = dot(float4(r2_x_4, r2_y_3, r2_x_4, r2_x_4), float4(r2_x_4, r2_y_3, r2_x_4, r2_x_4));
                float r0_z_7 = min(r0_z_6, 1);
                float r0_z_8 = (-r0_z_7 + 1);
                float r2_z_2 = sqrt(r0_z_8);
                float4 r0_xyzw_9 = (r0_xyzw_4.xxxy * _DetailScale.xxxx);
                float r0_z_9 = r0_xyzw_9.z;
                float r0_w_6 = r0_xyzw_9.w;
                float4 r4_xyzw_1 = _DetailNormal.Sample(sampler_DetailNormal, (float4(r0_z_9, r0_w_6, r0_z_9, r0_z_9)).xy);
                float4 r5_xyzw_1 = _DetailAlbedo.Sample(sampler_DetailAlbedo, (float4(r0_z_9, r0_w_6, r0_z_9, r0_z_9)).xy);
                float r4_x_2 = (r4_xyzw_1.w * r4_xyzw_1.x);
                float4 r0_xyzw_10 = mad(float4(r4_x_2, r4_x_2, r4_x_2, r4_xyzw_1.y), float4(0, 0, 2, 2), float4(0, 0, -1, -1));
                float r0_z_10 = r0_xyzw_10.z;
                float r0_w_7 = r0_xyzw_10.w;
                float4 r4_xyzw_3 = (float4(r0_z_10, r0_w_7, r0_z_10, r0_z_10) * _BumpScale.xxxx);
                float r4_x_3 = r4_xyzw_3.x;
                float r4_y_2 = r4_xyzw_3.y;
                float r0_z_11 = dot(float4(r4_x_3, r4_y_2, r4_x_3, r4_x_3), float4(r4_x_3, r4_y_2, r4_x_3, r4_x_3));
                float r0_z_12 = min(r0_z_11, 1);
                float r0_z_13 = (-r0_z_12 + 1);
                float r4_z_2 = sqrt(r0_z_13);
                float4 r6_xyzw_1 = _DetailMask.Sample(sampler_DetailMask, (r0_xyzw_4.xyxx).xy);
                float4 r0_xyzw_5 = _BumpMap.Sample(sampler_BumpMap, (r0_xyzw_4.xyxx).xy);
                float4 r0_xyzw_6 = (r0_xyzw_5 * _Color);
                float4 r2_xyzw_5 = mad(float4(r4_x_3, r4_y_2, r4_z_2, r4_x_3), r6_xyzw_1.xxxx, float4(r2_x_4, r2_y_3, r2_z_2, r2_x_4));
                float r2_x_5 = r2_xyzw_5.x;
                float r2_y_4 = r2_xyzw_5.y;
                float r2_z_3 = r2_xyzw_5.z;
                float4 r4_xyzw_4 = mad(r6_xyzw_1.xxxx, (mad(r5_xyzw_1.xyzx, float4(2, 2, 2, 0), float4(-2, -2, -2, 0))).xyzx, float4(1, 1, 1, 0));
                float r4_x_4 = r4_xyzw_4.x;
                float r4_y_3 = r4_xyzw_4.y;
                float r4_z_3 = r4_xyzw_4.z;
                float4 r0_xyzw_7 = (r0_xyzw_6.xyzx * float4(r4_x_4, r4_y_3, r4_z_3, r4_x_4));
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_7 = r0_xyzw_7.y;
                float r0_z_16 = r0_xyzw_7.z;
                o.sv_Target0.w = r0_xyzw_6.w;
                float r0_w_10 = dot(float4(r2_x_5, r2_y_4, r2_z_3, r2_x_5), float4(r2_x_5, r2_y_4, r2_z_3, r2_x_5));
                float r0_w_11 = rsqrt(r0_w_10);
                float4 r2_xyzw_6 = (r0_w_11.xxxx * float4(r2_x_5, r2_y_4, r2_z_3, r2_x_5));
                float r2_x_6 = r2_xyzw_6.x;
                float r2_y_5 = r2_xyzw_6.y;
                float r2_z_4 = r2_xyzw_6.z;
                float4 r1_xyzw_6 = mad(r2_x_6.xxxx, float4(unitWorldTangent_x_5, unitWorldTangent_y_1, unitWorldTangent_z_1, unitWorldTangent_x_5), ((r3_xyz_1.xyzx * r2_y_5.xxxx)).xyzx);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_2 = r1_xyzw_6.y;
                float r1_z_2 = r1_xyzw_6.z;
                float r0_w_12 = dot(i.texcoord5.xyzx, i.texcoord5.xyzx);
                float r0_w_13 = rsqrt(r0_w_12);
                float4 unitWorldNormal_xyzw_7 = (r0_w_13.xxxx * i.texcoord5.xyxz);
                float unitWorldNormal_x_7 = unitWorldNormal_xyzw_7.x;
                float unitWorldNormal_y_6 = unitWorldNormal_xyzw_7.y;
                float unitWorldNormal_w_2 = unitWorldNormal_xyzw_7.w;
                float4 r1_xyzw_7 = mad(r2_z_4.xxxx, float4(unitWorldNormal_x_7, unitWorldNormal_y_6, unitWorldNormal_w_2, unitWorldNormal_x_7), float4(r1_x_6, r1_y_2, r1_z_2, r1_x_6));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_3 = r1_xyzw_7.y;
                float r1_z_3 = r1_xyzw_7.z;
                float r0_w_14 = dot(float4(r1_x_7, r1_y_3, r1_z_3, r1_x_7), float4(r1_x_7, r1_y_3, r1_z_3, r1_x_7));
                float r0_w_15 = rsqrt(r0_w_14);
                float4 r1_xyzw_8 = (r0_w_15.xxxx * float4(r1_x_7, r1_y_3, r1_z_3, r1_x_7));
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_4 = r1_xyzw_8.y;
                float r1_z_4 = r1_xyzw_8.z;
                float r0_w_16 = (r1_y_4 * r1_y_4);
                float r0_w_17 = mad(r1_x_8, r1_x_8, -r0_w_16);
                float4 r2_xyzw_8 = (float4(r1_y_4, r1_z_4, r1_z_4, r1_x_8) * float4(r1_x_8, r1_y_4, r1_z_4, r1_z_4));
                float r3_x_3 = dot(unity_SHBr, r2_xyzw_8);
                float r3_y_3 = dot(unity_SHBg, r2_xyzw_8);
                float r3_z_3 = dot(unity_SHBb, r2_xyzw_8);
                float4 r2_xyzw_9 = mad(unity_SHC.xyzx, r0_w_17.xxxx, float4(r3_x_3, r3_y_3, r3_z_3, r3_x_3));
                float r2_x_9 = r2_xyzw_9.x;
                float r2_y_8 = r2_xyzw_9.y;
                float r2_z_6 = r2_xyzw_9.z;
                float r1_w_3 = 1;
                float r3_x_4 = dot(unity_SHAr, float4(r1_x_8, r1_y_4, r1_z_4, r1_w_3));
                float r3_y_4 = dot(unity_SHAg, float4(r1_x_8, r1_y_4, r1_z_4, r1_w_3));
                float r3_z_4 = dot(unity_SHAb, float4(r1_x_8, r1_y_4, r1_z_4, r1_w_3));
                float4 r2_xyzw_10 = (float4(r2_x_9, r2_y_8, r2_z_6, r2_x_9) + float4(r3_x_4, r3_y_4, r3_z_4, r3_x_4));
                float r2_x_10 = r2_xyzw_10.x;
                float r2_y_9 = r2_xyzw_10.y;
                float r2_z_7 = r2_xyzw_10.z;
                float3 r3_xyz_5 = (mad(-i.texcoord6.xyzx, _WorldSpaceLightPos0.wwww, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_18 = dot(r3_xyz_5.xyzx, r3_xyz_5.xyzx);
                float r0_w_19 = rsqrt(r0_w_18);
                float r0_w_20 = saturate(dot(float4(r1_x_8, r1_y_4, r1_z_4, r1_x_8), ((r0_w_19.xxxx * r3_xyz_5.xyzx)).xyzx));
                float4 r1_xyzw_9 = mad(_LightColor0.xyzx, r0_w_20.xxxx, float4(r2_x_10, r2_y_9, r2_z_7, r2_x_10));
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_5 = r1_xyzw_9.y;
                float r1_z_5 = r1_xyzw_9.z;
                o.sv_Target0.xyz = ((float4(r0_x_7, r0_y_7, r0_z_16, r0_x_7) * float4(r1_x_9, r1_y_5, r1_z_5, r1_x_9))).xyz;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Bumped Diffuse"
}
