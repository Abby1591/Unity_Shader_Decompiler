Shader "Corpus/15 Grab Pass"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "" {}
        _Color ("Tint", Color) = (1,1,1,1)
        _Distortion ("Distortion", Range(0, 0.2)) = 0.05
        _Refraction ("Refraction", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "IGNOREPROJECTOR"="true" "QUEUE"="Transparent" "RenderType"="Transparent" }
        LOD 0
        Pass
        {
            Cull Off
            ZTest Disabled
            ZWrite Off
            Stencil
            {
                Ref 0
                ReadMask 0
                WriteMask 0
                Comp Disabled
                Pass Keep
                Fail Keep
                ZFail Keep
            }
            HLSLPROGRAM
            cbuffer cb0 : register(b0)
            {
                float4 cb0_values[6];
            };
            cbuffer cb1 : register(b1)
            {
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 cb2_values[21];
            };
            SamplerState sampler_linear_clamp;
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            Texture2D t1;
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
                float4 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
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
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                o.texcoord3.xyz = (mad(cb1_values[3].xyzx, i.position0.wwww, worldPos_xyzw_3.xyzx)).xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw);
                float4 clipPos_xyzw_5 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = mul(float4x4(cb2_values[17], cb2_values[18], cb2_values[19], cb2_values[20]), worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, cb0_values[2].xyxx, cb0_values[2].zwzz)).xy;
                float3 r1_xyz_2 = ((clipPos_xyzw_7.xwyx * float4(0.5, 0.5, -0.5, 0))).xyz;
                o.texcoord1.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord1.xy = ((r1_xyz_2.yyyy + r1_xyz_2.xzxx)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord2.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float3 r0_xyz_1 = ((-i.texcoord3.xyzx + cb1_values[4].xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord2);
                float2 r0_yz_3 = ((unitWorldNormal_xyz_1.xxyx * cb0_values[5].xxxx)).yz;
                float2 r1_xy_2 = ((r0_yz_3.xyxx * cb0_values[3].xyxx)).xy;
                float r0_x_4 = (saturate(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx)) + 1);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_x_5 = (r0_y_4 * r0_x_4);
                float r0_y_5 = mad(r0_x_5, 0.2, cb0_values[5].y);
                float r1_z_2 = 0;
                float3 r1_xyz_3 = ((float4(r1_xy_2.x, r1_xy_2.y, r1_z_2, r1_xy_2.x) + i.texcoord1.xywx)).xyz;
                float4 r0_xyzw_4 = (r1_xyz_3.xxxy / r1_xyz_3.zzzz);
                float r0_z_4 = r0_xyzw_4.z;
                float r0_w_5 = r0_xyzw_4.w;
                float4 r1_xyzw_4 = _MainTex.Sample(sampler_MainTex, (float4(r0_z_4, r0_w_5, r0_z_4, r0_z_4)).xy);
                float4 r2_xyzw_1 = t1.Sample(sampler_linear_clamp, (i.texcoord0.xyxx).xy);
                o.sv_Target0.xyz = (mad(r0_y_5.xxxx, (mad(r2_xyzw_1.xyzx, cb0_values[4].xyzx, -r1_xyzw_4.xyzx)).xyzx, r1_xyzw_4.xyzx)).xyz;
                float r0_y_6 = (r2_xyzw_1.w * cb0_values[4].w);
                o.sv_Target0.w = (mad(r0_x_5, 0.5, 0.5) * r0_y_6);
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcColor
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            cbuffer _StubCB : register(b1) { float4x4 unity_MatrixVP; };
            struct v2f { float4 pos : SV_POSITION; };
            v2f vert(float4 v : POSITION) { v2f o; o.pos = mul(unity_MatrixVP, v); return o; }
            float4 frag(v2f i) : SV_Target { return 0; }
            ENDHLSL
        }
    }
    Fallback "Legacy Shaders/Transparent/Diffuse"
}
