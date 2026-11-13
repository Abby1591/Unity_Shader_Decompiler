Shader "Corpus/32 Terrain"
{
    Properties
    {
        _Control ("Splat Control", 2D) = "" {}
        _Splat0 ("Splat 0", 2D) = "" {}
        _Splat1 ("Splat 1", 2D) = "" {}
        _Splat2 ("Splat 2", 2D) = "" {}
        _Splat3 ("Splat 3", 2D) = "" {}
        _Normal0 ("Normal 0", 2D) = "" {}
        _Normal1 ("Normal 1", 2D) = "" {}
        _Normal2 ("Normal 2", 2D) = "" {}
        _Normal3 ("Normal 3", 2D) = "" {}
        _Metallic ("Metallic", Range(0, 1)) = 0
        _Smoothness ("Smoothness", Range(0, 1)) = 0.2
        _HeightBlend ("Height Blend", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "QUEUE"="Geometry" "RenderType"="Opaque" "TerrainCompatible"="true" }
        LOD 0
        Pass
        {
            Tags { "QUEUE"="Geometry" "RenderType"="Opaque" "TerrainCompatible"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            // Folded keyword variants (base state emitted): FOG_LINEAR
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _Control_ST : packoffset(c4);
                float4 _Splat0_ST : packoffset(c5);
                float4 _Splat1_ST : packoffset(c6);
                float4 _Splat2_ST : packoffset(c7);
                float4 _Splat3_ST : packoffset(c8);
                float _Metallic : packoffset(c9.x);
                float _Smoothness : packoffset(c9.y);
                float _HeightBlend : packoffset(c9.z);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
                float4 unity_SHAr : packoffset(c39);
                float4 unity_SHAg : packoffset(c40);
                float4 unity_SHAb : packoffset(c41);
                float4 unity_SHBr : packoffset(c42);
                float4 unity_SHBg : packoffset(c43);
                float4 unity_SHBb : packoffset(c44);
                float4 unity_SHC : packoffset(c45);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_Control;
            SamplerState sampler_Splat0;
            SamplerState sampler_Splat1;
            SamplerState sampler_Splat2;
            SamplerState sampler_Splat3;
            SamplerState sampler_Normal0;
            SamplerState sampler_Normal1;
            SamplerState sampler_Normal2;
            SamplerState sampler_Normal3;
            Texture2D _Control;
            Texture2D _Splat0;
            Texture2D _Splat1;
            Texture2D _Splat2;
            Texture2D _Splat3;
            Texture2D _Normal0;
            Texture2D _Normal1;
            Texture2D _Normal2;
            Texture2D _Normal3;
            struct program1Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
            };
            struct program1Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float2 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
            };
            struct program5Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float2 texcoord3 : TEXCOORD3;
                float2 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
                float3 texcoord6 : TEXCOORD6;
            };
            struct program5Output
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
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _Control_ST.xyxx, _Control_ST.zwzz)).xy;
                o.texcoord1.xy = (mad(i.texcoord0.xxxy, _Splat0_ST.xxxy, _Splat0_ST.zzzw)).zw;
                o.texcoord2.xy = (mad(i.texcoord0.xyxx, _Splat1_ST.xyxx, _Splat1_ST.zwzz)).xy;
                o.texcoord3.xy = (mad(i.texcoord0.xxxy, _Splat2_ST.xxxy, _Splat2_ST.zzzw)).zw;
                o.texcoord4.xy = (mad(i.texcoord0.xyxx, _Splat3_ST.xyxx, _Splat3_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord5.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program5Output frag(program5Input i)
            {
                program5Output o = (program5Output)0;
                float4 r0_xyzw_1 = _Normal2.Sample(sampler_Normal2, (i.texcoord3.xyxx).xy);
                float r0_x_2 = (r0_xyzw_1.w * r0_xyzw_1.x);
                float4 r0_xyzw_3 = mad(float4(r0_x_2, r0_xyzw_1.y, r0_x_2, r0_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_2 = r0_xyzw_3.y;
                float r0_w_2 = dot(float4(r0_x_3, r0_y_2, r0_x_3, r0_x_3), float4(r0_x_3, r0_y_2, r0_x_3, r0_x_3));
                float r0_w_3 = min(r0_w_2, 1);
                float r0_w_4 = (-r0_w_3 + 1);
                float r0_z_2 = sqrt(r0_w_4);
                float4 r1_xyzw_1 = _Normal0.Sample(sampler_Normal0, (i.texcoord1.xyxx).xy);
                float r1_x_2 = (r1_xyzw_1.w * r1_xyzw_1.x);
                float4 r1_xyzw_3 = mad(float4(r1_x_2, r1_xyzw_1.y, r1_x_2, r1_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_2 = r1_xyzw_3.y;
                float r0_w_5 = dot(float4(r1_x_3, r1_y_2, r1_x_3, r1_x_3), float4(r1_x_3, r1_y_2, r1_x_3, r1_x_3));
                float r0_w_6 = min(r0_w_5, 1);
                float r0_w_7 = (-r0_w_6 + 1);
                float r1_z_2 = sqrt(r0_w_7);
                float4 r2_xyzw_1 = _Normal1.Sample(sampler_Normal1, (i.texcoord2.xyxx).xy);
                float r2_x_2 = (r2_xyzw_1.w * r2_xyzw_1.x);
                float4 r2_xyzw_3 = mad(float4(r2_x_2, r2_xyzw_1.y, r2_x_2, r2_x_2), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r2_x_3 = r2_xyzw_3.x;
                float r2_y_2 = r2_xyzw_3.y;
                float r0_w_8 = dot(float4(r2_x_3, r2_y_2, r2_x_3, r2_x_3), float4(r2_x_3, r2_y_2, r2_x_3, r2_x_3));
                float r0_w_9 = min(r0_w_8, 1);
                float r0_w_10 = (-r0_w_9 + 1);
                float r2_z_2 = sqrt(r0_w_10);
                float4 r3_xyzw_1 = _Control.Sample(sampler_Control, (i.texcoord0.xyxx).xy);
                float4 r3_xyzw_2 = (r3_xyzw_1 * r3_xyzw_1);
                float4 r3_xyzw_3 = (r3_xyzw_2 * r3_xyzw_2);
                float r0_w_11 = dot(r3_xyzw_3, float4(1, 1, 1, 1));
                float r0_w_12 = max(r0_w_11, 1E-05);
                float4 r3_xyzw_4 = (r3_xyzw_3 / r0_w_12.xxxx);
                float4 r2_xyzw_4 = (float4(r2_x_3, r2_y_2, r2_z_2, r2_x_3) * r3_xyzw_4.yyyy);
                float r2_x_4 = r2_xyzw_4.x;
                float r2_y_3 = r2_xyzw_4.y;
                float r2_z_3 = r2_xyzw_4.z;
                float4 r1_xyzw_4 = mad(float4(r1_x_3, r1_y_2, r1_z_2, r1_x_3), r3_xyzw_4.xxxx, float4(r2_x_4, r2_y_3, r2_z_3, r2_x_4));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_3 = r1_xyzw_4.y;
                float r1_z_3 = r1_xyzw_4.z;
                float4 r0_xyzw_4 = mad(float4(r0_x_3, r0_y_2, r0_z_2, r0_x_3), r3_xyzw_4.zzzz, float4(r1_x_4, r1_y_3, r1_z_3, r1_x_4));
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_3 = r0_xyzw_4.y;
                float r0_z_3 = r0_xyzw_4.z;
                float4 r1_xyzw_5 = _Normal3.Sample(sampler_Normal3, (i.texcoord4.xyxx).xy);
                float r1_x_6 = (r1_xyzw_5.w * r1_xyzw_5.x);
                float4 r1_xyzw_7 = mad(float4(r1_x_6, r1_xyzw_5.y, r1_x_6, r1_x_6), float4(2, 2, 0, 0), float4(-1, -1, 0, 0));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_5 = r1_xyzw_7.y;
                float r0_w_13 = dot(float4(r1_x_7, r1_y_5, r1_x_7, r1_x_7), float4(r1_x_7, r1_y_5, r1_x_7, r1_x_7));
                float r0_w_14 = min(r0_w_13, 1);
                float r0_w_15 = (-r0_w_14 + 1);
                float r1_z_5 = sqrt(r0_w_15);
                float4 r0_xyzw_5 = mad(float4(r1_x_7, r1_y_5, r1_z_5, r1_x_7), r3_xyzw_4.wwww, float4(r0_x_4, r0_y_3, r0_z_3, r0_x_4));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_4 = r0_xyzw_5.z;
                float r0_z_5 = (r0_z_4 + _HeightBlend);
                float r0_w_16 = dot(float4(r0_x_5, r0_y_4, r0_z_5, r0_x_5), float4(r0_x_5, r0_y_4, r0_z_5, r0_x_5));
                float r0_w_17 = rsqrt(r0_w_16);
                float4 r0_xyzw_6 = (r0_w_17.xxxx * float4(r0_x_5, r0_y_4, r0_z_5, r0_x_5));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_5 = r0_xyzw_6.y;
                float r0_z_6 = r0_xyzw_6.z;
                float4 r0_xyzw_7 = mad(float4(r0_x_6, r0_y_5, r0_z_6, r0_x_6), float4(0.5, 0.5, 0.5, 0), i.texcoord5.xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_6 = r0_xyzw_7.y;
                float r0_z_7 = r0_xyzw_7.z;
                float r0_w_18 = dot(float4(r0_x_7, r0_y_6, r0_z_7, r0_x_7), float4(r0_x_7, r0_y_6, r0_z_7, r0_x_7));
                float r0_w_19 = rsqrt(r0_w_18);
                float4 r0_xyzw_8 = (r0_w_19.xxxx * float4(r0_x_7, r0_y_6, r0_z_7, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_7 = r0_xyzw_8.y;
                float r0_z_8 = r0_xyzw_8.z;
                float4 r2_xyzw_5 = (float4(r0_y_7, r0_z_8, r0_z_8, r0_x_8) * float4(r0_x_8, r0_y_7, r0_z_8, r0_z_8));
                float r4_x_1 = dot(unity_SHBr, r2_xyzw_5);
                float r4_y_1 = dot(unity_SHBg, r2_xyzw_5);
                float r4_z_1 = dot(unity_SHBb, r2_xyzw_5);
                float4 r1_xyzw_10 = mad(unity_SHC.xyzx, (mad(r0_x_8, r0_x_8, (r0_y_7 * r0_y_7))).xxxx, float4(r4_x_1, r4_y_1, r4_z_1, r4_x_1));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_6 = r1_xyzw_10.y;
                float r1_z_6 = r1_xyzw_10.z;
                float r0_w_20 = 1;
                float r2_x_6 = dot(unity_SHAr, float4(r0_x_8, r0_y_7, r0_z_8, r0_w_20));
                float r2_y_5 = dot(unity_SHAg, float4(r0_x_8, r0_y_7, r0_z_8, r0_w_20));
                float r2_z_5 = dot(unity_SHAb, float4(r0_x_8, r0_y_7, r0_z_8, r0_w_20));
                float4 r1_xyzw_11 = (float4(r1_x_10, r1_y_6, r1_z_6, r1_x_10) + float4(r2_x_6, r2_y_5, r2_z_5, r2_x_6));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_7 = r1_xyzw_11.y;
                float r1_z_7 = r1_xyzw_11.z;
                float4 r2_xyzw_7 = mad(-i.texcoord6.xyzx, unity_ObjectToWorld[0].wwww, unity_ObjectToWorld[0].xyzx);
                float r2_x_7 = r2_xyzw_7.x;
                float r2_y_6 = r2_xyzw_7.y;
                float r2_z_6 = r2_xyzw_7.z;
                float r0_w_21 = dot(float4(r2_x_7, r2_y_6, r2_z_6, r2_x_7), float4(r2_x_7, r2_y_6, r2_z_6, r2_x_7));
                float r0_w_22 = rsqrt(r0_w_21);
                float4 r2_xyzw_8 = (r0_w_22.xxxx * float4(r2_x_7, r2_y_6, r2_z_6, r2_x_7));
                float r2_x_8 = r2_xyzw_8.x;
                float r2_y_7 = r2_xyzw_8.y;
                float r2_z_7 = r2_xyzw_8.z;
                float4 r0_xyzw_10 = mad(_LightColor0.xyzx, (saturate(dot(float4(r0_x_8, r0_y_7, r0_z_8, r0_x_8), float4(r2_x_8, r2_y_7, r2_z_7, r2_x_8)))).xxxx, float4(r1_x_11, r1_y_7, r1_z_7, r1_x_11));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_8 = r0_xyzw_10.y;
                float r0_z_9 = r0_xyzw_10.z;
                float4 r1_xyzw_12 = _Splat1.Sample(sampler_Splat1, (i.texcoord2.xyxx).xy);
                float4 r1_xyzw_13 = (r3_xyzw_4.yyyy * r1_xyzw_12.xyzx);
                float r1_x_13 = r1_xyzw_13.x;
                float r1_y_9 = r1_xyzw_13.y;
                float r1_z_9 = r1_xyzw_13.z;
                float4 r2_xyzw_9 = _Splat0.Sample(sampler_Splat0, (i.texcoord1.xyxx).xy);
                float4 r1_xyzw_14 = mad(r2_xyzw_9.xyzx, r3_xyzw_4.xxxx, float4(r1_x_13, r1_y_9, r1_z_9, r1_x_13));
                float r1_x_14 = r1_xyzw_14.x;
                float r1_y_10 = r1_xyzw_14.y;
                float r1_z_10 = r1_xyzw_14.z;
                float4 r2_xyzw_10 = _Splat2.Sample(sampler_Splat2, (i.texcoord3.xyxx).xy);
                float4 r1_xyzw_15 = mad(r2_xyzw_10.xyzx, r3_xyzw_4.zzzz, float4(r1_x_14, r1_y_10, r1_z_10, r1_x_14));
                float r1_x_15 = r1_xyzw_15.x;
                float r1_y_11 = r1_xyzw_15.y;
                float r1_z_11 = r1_xyzw_15.z;
                float4 r2_xyzw_11 = _Splat3.Sample(sampler_Splat3, (i.texcoord4.xyxx).xy);
                float4 r1_xyzw_16 = mad(r2_xyzw_11.xyzx, r3_xyzw_4.wwww, float4(r1_x_15, r1_y_11, r1_z_11, r1_x_15));
                float r1_x_16 = r1_xyzw_16.x;
                float r1_y_12 = r1_xyzw_16.y;
                float r1_z_12 = r1_xyzw_16.z;
                float4 r0_xyzw_11 = (float4(r0_x_10, r0_y_8, r0_z_9, r0_x_10) * float4(r1_x_16, r1_y_12, r1_z_12, r1_x_16));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_y_9 = r0_xyzw_11.y;
                float r0_z_10 = r0_xyzw_11.z;
                float r0_w_23 = (_Smoothness * 0.05);
                o.sv_Target0.xyz = (mad(float4(r0_x_11, r0_y_9, r0_z_10, r0_x_11), (mad(-_Metallic, 0.5, 1)).xxxx, r0_w_23.xxxx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Diffuse"
}
