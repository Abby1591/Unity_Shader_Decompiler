Shader "Corpus/47 Lightmap"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo", 2D) = "" {}
        _LightmapTex ("Lightmap", 2D) = "" {}
    }
    SubShader
    {
        Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
        LOD 0
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
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
            cbuffer _UnityLightmapsCB_b3
            {
                float4 unity_LightmapST : packoffset(c0);
                float4 unity_DynamicLightmapST : packoffset(c1);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program1Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct program1Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
            };
            struct program7Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
            };
            struct program7Output
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
                o.texcoord4.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord1.xy = (mad(i.texcoord1.xxxy, unity_LightmapST.xxxy, unity_LightmapST.zzzw)).zw;
                o.texcoord2.xy = (mad(i.texcoord2.xyxx, unity_DynamicLightmapST.xyxx, unity_DynamicLightmapST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord3.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program7Output frag(program7Input i)
            {
                program7Output o = (program7Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord3.xyzx, i.texcoord3.xyzx))).xxxx * i.texcoord3.xyzx);
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
                float3 r2_xyz_3 = (mad(-i.texcoord4.xyzx, unity_ObjectToWorld[0].wwww, unity_ObjectToWorld[0].xyzx)).xyz;
                float r0_w_2 = dot(r2_xyz_3.xyzx, r2_xyz_3.xyzx);
                float r0_w_3 = rsqrt(r0_w_2);
                float4 r0_xyzw_5 = mad(_LightColor0.xyzx, (saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_3.xxxx * r2_xyz_3.xyzx)).xyzx))).xxxx, float4(r1_x_4, r1_y_2, r1_z_2, r1_x_4));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_2 = r0_xyzw_5.y;
                float r0_z_2 = r0_xyzw_5.z;
                float4 r1_xyzw_5 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_6 = (r1_xyzw_5 * _Color);
                o.sv_Target0.xyz = ((float4(r0_x_5, r0_y_2, r0_z_2, r0_x_5) * r1_xyzw_6.xyzx)).xyz;
                o.sv_Target0.w = r1_xyzw_6.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _MainTex_ST : packoffset(c4);
                float4 _Color : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 unity_SHAr;
                float4 unity_SHAg;
                float4 unity_SHAb;
                float4 unity_SHBr;
                float4 unity_SHBg;
                float4 unity_SHBb;
                float4 unity_SHC;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[46];
            };
            cbuffer _UnityLightmapsCB_b3
            {
                float4 unity_LightmapST;
                float4 unity_DynamicLightmapST;
                float4 cb3_values[2];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program2Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct program2Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float texcoord5 : TEXCOORD5;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
            };
            struct program8Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
                float texcoord5 : TEXCOORD5;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
            };
            struct program8Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program2Output vert(program2Input i)
            {
                program2Output o = (program2Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord4.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord5.x = clipPos_xyzw_7.z;
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord1.xy = (mad(i.texcoord1.xxxy, unity_LightmapST.xxxy, unity_LightmapST.zzzw)).zw;
                o.texcoord2.xy = (mad(i.texcoord2.xyxx, unity_DynamicLightmapST.xyxx, unity_DynamicLightmapST.zwzz)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord3.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program8Output frag(program8Input i)
            {
                program8Output o = (program8Output)0;
                float4 unitWorldNormal_xyzw_3 = ((rsqrt(dot(i.texcoord3.xyzx, i.texcoord3.xyzx))).xxxx * i.texcoord3.xyzx);
                float unitWorldNormal_x_3 = unitWorldNormal_xyzw_3.x;
                float unitWorldNormal_y_1 = unitWorldNormal_xyzw_3.y;
                float unitWorldNormal_z_1 = unitWorldNormal_xyzw_3.z;
                float4 r2_xyzw_1 = (float4(unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1, unitWorldNormal_x_3) * float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_z_1));
                float r3_x_1 = dot(cb2_values[42].xyzw, r2_xyzw_1);
                float r3_y_1 = dot(cb2_values[43].xyzw, r2_xyzw_1);
                float r3_z_1 = dot(cb2_values[44].xyzw, r2_xyzw_1);
                float4 r1_xyzw_3 = mad(cb2_values[45].xyzx, (mad(unitWorldNormal_x_3, unitWorldNormal_x_3, (unitWorldNormal_y_1 * unitWorldNormal_y_1))).xxxx, float4(r3_x_1, r3_y_1, r3_z_1, r3_x_1));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_y_1 = r1_xyzw_3.y;
                float r1_z_1 = r1_xyzw_3.z;
                float r0_w_1 = 1;
                float r2_x_2 = dot(cb2_values[39].xyzw, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r0_w_1));
                float r2_y_2 = dot(cb2_values[40].xyzw, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r0_w_1));
                float r2_z_2 = dot(cb2_values[41].xyzw, float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, r0_w_1));
                float4 r1_xyzw_4 = (float4(r1_x_3, r1_y_1, r1_z_1, r1_x_3) + float4(r2_x_2, r2_y_2, r2_z_2, r2_x_2));
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_2 = r1_xyzw_4.y;
                float r1_z_2 = r1_xyzw_4.z;
                float3 r2_xyz_3 = (mad(-i.texcoord4.xyzx, cb2_values[0].wwww, cb2_values[0].xyzx)).xyz;
                float r0_w_2 = dot(r2_xyz_3.xyzx, r2_xyz_3.xyzx);
                float r0_w_3 = rsqrt(r0_w_2);
                float4 r0_xyzw_5 = mad(_LightColor0.xyzx, (saturate(dot(float4(unitWorldNormal_x_3, unitWorldNormal_y_1, unitWorldNormal_z_1, unitWorldNormal_x_3), ((r0_w_3.xxxx * r2_xyz_3.xyzx)).xyzx))).xxxx, float4(r1_x_4, r1_y_2, r1_z_2, r1_x_4));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_2 = r0_xyzw_5.y;
                float r0_z_2 = r0_xyzw_5.z;
                float4 r1_xyzw_5 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_6 = (r1_xyzw_5 * _Color);
                float4 r0_xyzw_6 = mad(r1_xyzw_6.xyzx, float4(r0_x_5, r0_y_2, r0_z_2, r0_x_5), -cb3_values[0].xyzx);
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_3 = r0_xyzw_6.y;
                float r0_z_3 = r0_xyzw_6.z;
                o.sv_Target0.w = r1_xyzw_6.w;
                float r0_w_4 = (i.texcoord5.x / cb1_values[5].y);
                float r0_w_5 = (-r0_w_4 + 1);
                float r0_w_6 = (r0_w_5 * cb1_values[5].z);
                float r0_w_7 = max(r0_w_6, 0);
                float r0_w_8 = saturate(mad(r0_w_7, cb3_values[1].z, cb3_values[1].w));
                o.sv_Target0.xyz = (mad(r0_w_8.xxxx, float4(r0_x_6, r0_y_3, r0_z_3, r0_x_6), cb3_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Diffuse"
}
