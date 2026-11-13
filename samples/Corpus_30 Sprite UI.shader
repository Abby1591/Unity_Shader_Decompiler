Shader "Corpus/30 Sprite UI"
{
    Properties
    {
        _MainTex ("Sprite Texture", 2D) = "" {}
        _Color ("Tint", Color) = (1,1,1,1)
        [MaterialToggle]
        PixelSnap ("Pixel Snap", Float) = 0
        _RendererColor ("Renderer Color", Color) = (1,1,1,1)
        _Flip ("Flip", Vector) = (1,1,1,1)
        _AlphaTex ("External Alpha", 2D) = "" {}
        _EnableExternalAlpha ("Enable External Alpha", Float) = 0
        _ClipRect ("Clip Rect", Vector) = (-32767,-32767,32767,32767)
        _ColorMask ("Color Mask", Float) = 15
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilComp ("Stencil Comparison", Float) = 8
        _StencilReadMask ("Stencil Read Mask", Float) = 255
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
    }
    SubShader
    {
        Tags { "CanUseSpriteAtlas"="true" "IGNOREPROJECTOR"="true" "PreviewType"="Plane" "QUEUE"="Transparent" "RenderType"="Transparent" }
        LOD 0
        Pass
        {
            Tags { "CanUseSpriteAtlas"="true" "IGNOREPROJECTOR"="true" "PreviewType"="Plane" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest Disabled
            ZWrite Off
            Blend One OneMinusSrcColor
            Stencil
            {
                Ref 0
                ReadMask 0
                WriteMask 0
                Comp Always
                Pass Keep
                Fail Keep
                ZFail Keep
            }
            // Folded keyword variants (base state emitted): ETC1_EXTERNAL_ALPHA, PIXELSNAP_ON
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _MainTex_ST : packoffset(c2);
                float4 _Color : packoffset(c3);
                float4 _RendererColor : packoffset(c4);
                float4 _Flip : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program2Input
            {
                float4 position0 : POSITION0;
                float4 color0 : COLOR0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program2Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 color0 : COLOR0;
                float2 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
            };
            struct program8Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 color0 : COLOR0;
                float2 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
            };
            struct program8Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program2Output vert(program2Input i)
            {
                program2Output o = (program2Output)0;
                float2 r0_xy_1 = ((i.position0.xyxx * _Flip.xyxx)).xy;
                o.texcoord1.xy = (r0_xy_1.xyxx).xy;
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[2], i.position0.zzzz, mad(unity_ObjectToWorld[0], r0_xy_1.xxxx, (r0_xy_1.yyyy * unity_ObjectToWorld[1])));
                float4 r0_xyzw_3 = (worldPos_xyzw_2 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = mad(unity_MatrixVP[3], r0_xyzw_3.wwww, mad(unity_MatrixVP[2], r0_xyzw_3.zzzz, mad(unity_MatrixVP[0], r0_xyzw_3.xxxx, (r0_xyzw_3.yyyy * unity_MatrixVP[1]))));
                float4 r0_xyzw_4 = (i.color0.xyzw * _Color);
                o.color0.xyzw = (r0_xyzw_4 * _RendererColor);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.texcoord1.zw = (i.position0.zzzw).zw;
                return o;
            }
            #pragma fragment frag
            program8Output frag(program8Input i)
            {
                program8Output o = (program8Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r0_xyzw_2 = (r0_xyzw_1 * i.color0.xyzw);
                o.sv_Target0.xyz = ((r0_xyzw_2.wwww * r0_xyzw_2.xyzx)).xyz;
                o.sv_Target0.w = r0_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "UI/Default"
}
