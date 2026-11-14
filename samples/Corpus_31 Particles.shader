Shader "Corpus/31 Particles"
{
    Properties
    {
        _MainTex ("Particle Texture", 2D) = "" {}
        _TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
        _InvFade ("Soft Particles Factor", Range(0.01, 3)) = 1
        _SoftParticleFactor ("Soft Particle Factor", Range(0, 1)) = 1
        _FlipbookSize ("Flipbook Size", Vector) = (1,1,1,1)
        _FlipbookFPS ("Flipbook FPS", Float) = 30
    }
    SubShader
    {
        Tags { "IGNOREPROJECTOR"="true" "PreviewType"="Plane" "QUEUE"="Transparent" "RenderType"="Transparent" }
        LOD 0
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "PreviewType"="Plane" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            ColorMask RGB
            // Folded keyword variants (base state emitted): FOG_LINEAR, SOFTPARTICLES_ON
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _MainTex_ST : packoffset(c2);
                float4 _TintColor : packoffset(c3);
            };
            cbuffer _UnityPerCameraCB_b1
            {
                float4 _ProjectionParams : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b2
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
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
                float4 color0 : COLOR0;
                float2 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
            };
            struct program1Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 color0 : COLOR0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord2 : TEXCOORD2;
                float4 texcoord1 : TEXCOORD1;
                float2 texcoord3 : TEXCOORD3;
            };
            struct program9Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 color0 : COLOR0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord2 : TEXCOORD2;
                float4 texcoord1 : TEXCOORD1;
                float2 texcoord3 : TEXCOORD3;
            };
            struct program9Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program1Output vert(program1Input i)
            {
                program1Output o = (program1Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_4 = UnityObjectToWorldPos(i.position0.xyz);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_4.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[0], worldPos_xyzw_4.xxxx, clipPos_xyzw_1);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_4.zzzz, clipPos_xyzw_2);
                float4 clipPos_xyzw_4 = mad(unity_MatrixVP[3], worldPos_xyzw_4.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_4);
                o.color0.xyzw = (i.color0.xyzw * _TintColor);
                float r0_y_5 = (worldPos_xyzw_4.y * unity_MatrixV[1].z);
                o.texcoord2.x = mad(unity_MatrixV[3].z, worldPos_xyzw_4.w, mad(unity_MatrixV[2].z, worldPos_xyzw_4.z, mad(unity_MatrixV[0].z, worldPos_xyzw_4.x, r0_y_5)));
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float r0_w_5 = ((clipPos_xyzw_4.y * _ProjectionParams.x) * 0.5);
                float4 r0_xyzw_9 = (clipPos_xyzw_4.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_9 = r0_xyzw_9.x;
                float r0_z_5 = r0_xyzw_9.z;
                o.texcoord1.zw = (clipPos_xyzw_4.zzzw).zw;
                o.texcoord1.xy = ((r0_z_5.xxxx + float4(r0_x_9, r0_w_5, r0_x_9, r0_x_9))).xy;
                o.texcoord3.xy = (i.texcoord1.xyxx).xy;
                return o;
            }
            #pragma fragment frag
            program9Output frag(program9Input i)
            {
                program9Output o = (program9Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                o.sv_Target0.xyzw = (r0_xyzw_1 * i.color0.xyzw);
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Particles/Standard Unlit"
}
