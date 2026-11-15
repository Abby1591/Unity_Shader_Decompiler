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
            ZClip Off
            Stencil
            {
                ReadMask 0
                WriteMask 0
                Comp Disabled
                Pass Keep
                Fail Keep
                ZFail Keep
            }
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _MainTex_ST : packoffset(c2);
                float4 _GrabTexture_TexelSize : packoffset(c3);
                float4 _Color : packoffset(c4);
                float _Distortion : packoffset(c5.x);
                float _Refraction : packoffset(c5.y);
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
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord3.xyz = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float3 r1_xyz_2 = ((clipPos_xyzw_7.xwyx * float4(0.5, 0.5, -0.5, 0))).xyz;
                o.texcoord1.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord1.xy = ((r1_xyz_2.yyyy + r1_xyz_2.xzxx)).xy;
                float worldNormal_x_8 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_8 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_8 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_8 = dot(float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8), float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8));
                float r0_w_9 = rsqrt(r0_w_8);
                o.texcoord2.xyz = ((r0_w_9.xxxx * float4(worldNormal_x_8, worldNormal_y_8, worldNormal_z_8, worldNormal_x_8))).xyz;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord3.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float3 unitViewDir_xyz_2 = normalize(viewDir_xyz_1);
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord2);
                float2 r0_yz_3 = ((unitWorldNormal_xyz_1.xxyx * _Distortion.xxxx)).yz;
                float2 r1_xy_2 = ((r0_yz_3.xyxx * _GrabTexture_TexelSize.xyxx)).xy;
                float r0_x_4 = (saturate(dot(unitWorldNormal_xyz_1.xyzx, unitViewDir_xyz_2.xyzx)) + 1);
                float r0_y_4 = (r0_x_4 * r0_x_4);
                float r0_x_5 = (r0_y_4 * r0_x_4);
                float r0_y_5 = mad(r0_x_5, 0.2, _Refraction);
                float r1_z_2 = 0;
                float3 r1_xyz_3 = ((float4(r1_xy_2.x, r1_xy_2.y, r1_z_2, r1_xy_2.x) + i.texcoord1.xywx)).xyz;
                float4 r0_xyzw_4 = (r1_xyz_3.xxxy / r1_xyz_3.zzzz);
                float r0_z_4 = r0_xyzw_4.z;
                float r0_w_5 = r0_xyzw_4.w;
                float4 r1_xyzw_4 = _MainTex.Sample(sampler_MainTex, (float4(r0_z_4, r0_w_5, r0_z_4, r0_z_4)).xy);
                float4 r2_xyzw_1 = t1.Sample(sampler_linear_clamp, (i.texcoord0.xyxx).xy);
                o.sv_Target0.xyz = (mad(r0_y_5.xxxx, (mad(r2_xyzw_1.xyzx, _Color.xyzx, -r1_xyzw_4.xyzx)).xyzx, r1_xyzw_4.xyzx)).xyz;
                float r0_y_6 = (r2_xyzw_1.w * _Color.w);
                o.sv_Target0.w = (mad(r0_x_5, 0.5, 0.5) * r0_y_6);
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Legacy Shaders/Transparent/Diffuse"
}
