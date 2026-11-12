Shader "Corpus/22 Texture Sampling"
{
    Properties
    {
        _Tex2D ("2D", 2D) = "" {}
        _Tex3D ("3D", 2D) = "" {}
        _TexCube ("Cube", 2D) = "" {}
        _Tex2DArray ("2D Array", 2D) = "" {}
        _TexCubeArray ("Cube Array", 2D) = "" {}
        _Bias ("Bias", Range(0, 4)) = 0
        _Lod ("Lod", Range(0, 8)) = 0
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
            cbuffer _UnityPerCameraCB_b0
            {
                float _Bias : packoffset(c2.x);
                float _Lod : packoffset(c2.y);
                float3 _WorldSpaceCameraPos : packoffset(c4);
                float4 _ProjectionParams : packoffset(c5);
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
            SamplerState sampler_Tex2DArray;
            SamplerState sampler_TexCubeArray;
            SamplerState sampler_linear_clamp2;
            SamplerState sampler_linear_clamp3;
            SamplerState sampler_linear_clamp4;
            SamplerState sampler_linear_clamp5;
            SamplerComparisonState sampler_comparison_linear_clamp6;
            SamplerState sampler_Tex2D;
            SamplerState sampler_Tex3D;
            SamplerState sampler_TexCube;
            Texture2D _Tex2D;
            Texture3D _Tex3D;
            TextureCube _TexCube;
            Texture2D _Tex2DArray;
            Texture3D _TexCubeArray;
            TextureCube t5;
            Texture2DArray t6;
            TextureCubeArray t7;
            Texture2D t8;
            Texture2D t9;
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
                float4 texcoord3 : TEXCOORD3;
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
            };
            struct program3Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program1Output vert(program1Input i)
            {
                program1Output o = (program1Output)0;
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                float3 worldPos_xyz_4 = worldPos_xyzw_1.xyz;
                o.texcoord2.xyz = ((-worldPos_xyz_4.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float4 clipPos_xyzw_5 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_6);
                float4 clipPos_xyzw_8 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_7);
                o.sv_Position0.xyzw = clipPos_xyzw_8;
                o.texcoord0.xy = (i.texcoord0.xyxx).xy;
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float r0_y_9 = (clipPos_xyzw_8.y * _ProjectionParams.x);
                float4 r1_xyzw_3 = (float4(clipPos_xyzw_8.x, clipPos_xyzw_8.x, clipPos_xyzw_8.w, r0_y_9) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_z_3 = r1_xyzw_3.z;
                float r1_w_4 = r1_xyzw_3.w;
                o.texcoord3.zw = (clipPos_xyzw_8.zzzw).zw;
                o.texcoord3.xy = ((r1_z_3.xxxx + float4(r1_x_3, r1_w_4, r1_x_3, r1_x_3))).xy;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float2 r0_zw_1 = (ddy_coarse(i.texcoord0.xxxy)).zw;
                float3 r0_xyz_2 = (_Tex2DArray.SampleGrad(sampler_Tex2DArray, (i.texcoord0.xyxx).xy, (ddx_coarse(i.texcoord0.xyxx)).xyxx, r0_zw_1.xyxx)).xyz;
                float3 r1_xyz_1 = (_Tex2DArray.Sample(sampler_Tex2DArray, (i.texcoord0.xyxx).xy)).xyz;
                float3 r2_xyz_1 = (_Tex2DArray.SampleLevel(sampler_Tex2DArray, (i.texcoord0.xyxx).xy, _Lod)).xyz;
                float3 r1_xyz_3 = (_Tex2DArray.SampleBias(sampler_Tex2DArray, (i.texcoord0.xyxx).xy, _Bias)).xyz;
                float3 r1_xyz_5 = (_Tex2DArray.Gather(sampler_Tex2DArray, (i.texcoord0.xyxx).xy)).xyz;
                float3 r0_xyz_6 = ((((((((r0_xyz_2.xyzx + ((r1_xyz_1.xyzx + r2_xyz_1.xyzx)).xyzx)).xyzx + r1_xyz_3.xyzx)).xyzx + (r1_xyz_1).xyzx)).xyzx + r1_xyz_5.xyzx)).xyz;
                float2 r1_xy_7 = ((int4)(((i.texcoord0.xyxx * float4(256, 256, 0, 0))).xyxx)).xy;
                float4 r1_xyzw_6 = float4(0, 0, 0, 0);
                float r1_z_6 = r1_xyzw_6.z;
                float r1_w_1 = r1_xyzw_6.w;
                float4 r1_xyzw_8 = _Tex2DArray.Load(float4(r1_xy_7.x, r1_xy_7.y, r1_z_6, r1_w_1));
                float r1_x_8 = r1_xyzw_8.x;
                float r1_y_8 = r1_xyzw_8.y;
                float r1_z_7 = r1_xyzw_8.z;
                float4 r1_xyzw_9 = t8.Sample(sampler_linear_clamp5, (i.texcoord0.xyxx).xy);
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_9 = r1_xyzw_9.y;
                float r1_z_8 = r1_xyzw_9.z;
                float r0_w_2 = t9.SampleCmp(sampler_comparison_linear_clamp6, (i.texcoord0.xyxx).xy, 0.5);
                float r0_w_3 = t9.SampleCmpLevelZero(sampler_comparison_linear_clamp6, (i.texcoord0.xyxx).xy, 0.5);
                float2 TEXCOORD0_xy_10 = (i.texcoord0.xyxx).xy;
                float r1_z_9 = 0.5;
                float3 r2_xyz_2 = (_TexCubeArray.Sample(sampler_TexCubeArray, (float4(TEXCOORD0_xy_10.x, TEXCOORD0_xy_10.y, r1_z_9, TEXCOORD0_xy_10.x)).xyz)).xyz;
                float3 r3_xyz_1 = (_TexCubeArray.SampleLevel(sampler_TexCubeArray, (float4(TEXCOORD0_xy_10.x, TEXCOORD0_xy_10.y, r1_z_9, TEXCOORD0_xy_10.x)).xyz, _Lod)).xyz;
                float4 r1_xyzw_11 = _Tex3D.Sample(sampler_Tex3D, (float4(TEXCOORD0_xy_10.x, TEXCOORD0_xy_10.y, r1_z_9, TEXCOORD0_xy_10.x)).xyz);
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_11 = r1_xyzw_11.y;
                float r1_z_10 = r1_xyzw_11.z;
                float3 unitWorldNormal_xyz_2 = normalize(i.texcoord1);
                float3 r4_xyz_1 = (t5.Sample(sampler_linear_clamp2, unitWorldNormal_xyz_2.xyz)).xyz;
                float3 r4_xyz_2 = (t5.SampleLevel(sampler_linear_clamp2, unitWorldNormal_xyz_2.xyz, _Lod)).xyz;
                float2 TEXCOORD0_xy_3 = (i.texcoord0.xyxx).xy;
                float r4_z_3 = 0;
                float3 r5_xyz_1 = (t6.Sample(sampler_linear_clamp3, (float4(TEXCOORD0_xy_3.x, TEXCOORD0_xy_3.y, r4_z_3, TEXCOORD0_xy_3.x)).xyz)).xyz;
                float3 r4_xyz_4 = (t6.SampleLevel(sampler_linear_clamp3, (float4(TEXCOORD0_xy_3.x, TEXCOORD0_xy_3.y, r4_z_3, TEXCOORD0_xy_3.x)).xyz, _Lod)).xyz;
                float3 r2_xyz_7 = ((r4_xyz_4.xyzx + ((((((((r2_xyz_2.xyzx + r3_xyz_1.xyzx)).xyzx + r4_xyz_1.xyzx)).xyzx + r4_xyz_2.xyzx)).xyzx + r5_xyz_1.xyzx)).xyzx)).xyz;
                float r3_w_1 = 0;
                float3 r4_xyz_5 = (t7.Sample(sampler_linear_clamp4, (float4(unitWorldNormal_xyz_2.x, unitWorldNormal_xyz_2.y, unitWorldNormal_xyz_2.z, r3_w_1)).xyzw)).xyz;
                float3 r5_xyz_2 = (t7.SampleLevel(sampler_linear_clamp4, (float4(unitWorldNormal_xyz_2.x, unitWorldNormal_xyz_2.y, unitWorldNormal_xyz_2.z, r3_w_1)).xyzw, _Lod)).xyz;
                float3 r3_xyz_3 = (_TexCube.Sample(sampler_TexCube, unitWorldNormal_xyz_2.xyz)).xyz;
                float3 r2_xyz_9 = ((r5_xyz_2.xyzx + ((r2_xyz_7.xyzx + r4_xyz_5.xyzx)).xyzx)).xyz;
                float3 r0_xyz_11 = ((((r0_w_3.xxxx + ((r0_w_2.xxxx + ((((r0_xyz_6.xyzx + float4(r1_x_8, r1_y_8, r1_z_7, r1_x_8))).xyzx + float4(r1_x_9, r1_y_9, r1_z_8, r1_x_9))).xyzx)).xyzx)).xyzx + r2_xyz_9.xyzx)).xyz;
                float3 r2_xyz_10 = (_Tex2D.Sample(sampler_Tex2D, (i.texcoord0.xyxx).xy)).xyz;
                float3 r4_xyz_6 = (_Tex2D.SampleLevel(sampler_Tex2D, (i.texcoord0.xyxx).xy, _Lod)).xyz;
                float4 r4_xyzw_8 = _Tex2D.Sample(sampler_Tex2D, (((i.texcoord3.xyxx / i.texcoord3.wwww)).xyxx).xy);
                float r4_x_8 = r4_xyzw_8.x;
                float r4_y_8 = r4_xyzw_8.y;
                float r4_z_7 = r4_xyzw_8.z;
                float4 r4_xyzw_9 = _Tex2D.SampleBias(sampler_Tex2D, (i.texcoord0.xyxx).xy, _Bias);
                float r4_x_9 = r4_xyzw_9.x;
                float r4_y_9 = r4_xyzw_9.y;
                float r4_z_8 = r4_xyzw_9.z;
                float4 r1_xyzw_12 = (float4(r1_x_11, r1_y_11, r1_z_10, r1_x_11) + ((((((r2_xyz_10.xyzx + r4_xyz_6.xyzx)).xyzx + float4(r4_x_8, r4_y_8, r4_z_7, r4_x_8))).xyzx + float4(r4_x_9, r4_y_9, r4_z_8, r4_x_9))).xyzx);
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_12 = r1_xyzw_12.y;
                float r1_z_11 = r1_xyzw_12.z;
                float4 r1_xyzw_13 = (r3_xyz_3.xyzx + float4(r1_x_12, r1_y_12, r1_z_11, r1_x_12));
                float r1_x_13 = r1_xyzw_13.x;
                float r1_y_13 = r1_xyzw_13.y;
                float r1_z_12 = r1_xyzw_13.z;
                o.sv_Target0.xyz = ((((r0_xyz_11.xyzx + float4(r1_x_13, r1_y_13, r1_z_12, r1_x_13))).xyzx * float4(0.03448276, 0.03448276, 0.03448276, 0))).xyz;
                float2 r0_xy_13 = /* TODO: no confirmed HLSL mapping for ResInfo */ _Tex2DArray.ResInfo();
                float2 r0_xy_14 = ((float4)(r0_xy_13.xyxx)).xy;
                float r0_y_15 = max(r0_xy_14.y, 1);
                o.sv_Target0.w = min((r0_xy_14.x / r0_y_15), 1);
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Diffuse"
}
