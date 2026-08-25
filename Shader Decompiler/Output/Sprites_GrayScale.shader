Shader "Sprites/GrayScale"
{
    Properties
    {
        _MainTex ("Sprite Texture", 2D) = "" {}
        _Color ("Tint", Color) = (1,1,1,1)
        [MaterialToggle]
        PixelSnap ("Pixel snap", Float) = 0
        _EffectAmount ("Effect Amount", Range(0, 1)) = 1
    }
    SubShader
    {
        Tags { "CanUseSpriteAtlas"="true" "IGNOREPROJECTOR"="true" "PreviewType"="Plane" "QUEUE"="Transparent" "RenderType"="Transparent" }
        LOD 0
        Pass
        {
            Tags { "CanUseSpriteAtlas"="true" "IGNOREPROJECTOR"="true" "PreviewType"="Plane" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcColor
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _Color;
                float _EffectAmount;
            };
            cbuffer _UnityPerDrawCB : register(b1)
            {
                float4x4 unity_ObjectToWorld;
            };
            cbuffer _UnityPerFrameCB : register(b2)
            {
                float4x4 unity_MatrixVP;
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
            };
            struct program5Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 color0 : COLOR0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program5Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program2Output vert(program2Input i)
            {
                program2Output o = (program2Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_4 = UnityObjectToWorldPos(i.position0.xyz);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_4);
                o.color0.xyzw = (i.color0.xyzw * _Color);
                o.texcoord0.xy = (i.texcoord0.xyxx).xy;
                return o;
            }
            #pragma fragment frag
            program5Output frag(program5Input i)
            {
                program5Output o = (program5Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_2 = (-r0_xyzw_1.xyzx + (dot(r0_xyzw_1.xyzx, float4(0.3, 0.59, 0.11, 0))).xxxx);
                float r1_x_2 = r1_xyzw_2.x;
                float r1_y_1 = r1_xyzw_2.y;
                float r1_z_1 = r1_xyzw_2.z;
                float3 r0_xyz_2 = (mad(_EffectAmount.xxxx, float4(r1_x_2, r1_y_1, r1_z_1, r1_x_2), r0_xyzw_1.xyzx)).xyz;
                o.sv_Target0.xyzw = (float4(r0_xyz_2.x, r0_xyz_2.y, r0_xyz_2.z, r0_xyzw_1.w) * i.color0.xyzw);
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "CanUseSpriteAtlas"="true" "IGNOREPROJECTOR"="true" "PreviewType"="Plane" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Off
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcColor
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _Color;
                float _EffectAmount;
            };
            cbuffer _UnityPerDrawCB : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 cb1_values[7];
            };
            cbuffer _UnityPerFrameCB : register(b2)
            {
                float4x4 unity_MatrixVP;
                float4 cb2_values[4];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[21];
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program3Input
            {
                float4 position0 : POSITION0;
                float4 color0 : COLOR0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program3Output
            {
                float4 sv_Position0 : SV_POSITION;
                float4 color0 : COLOR0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program6Input
            {
                float4 sv_Position0 : SV_POSITION;
                float4 color0 : COLOR0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program6Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program3Output vert(program3Input i)
            {
                program3Output o = (program3Output)0;
                float4 worldPos_xyzw_1 = (i.position0.yyyy * cb2_values[1].xyzw);
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, worldPos_xyzw_1);
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_4 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_4.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_2 = mad(cb3_values[17].xyzw, worldPos_xyzw_4.xxxx, clipPos_xyzw_1);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_4.zzzz, clipPos_xyzw_2);
                float4 clipPos_xyzw_5 = mad(cb3_values[20].xyzw, worldPos_xyzw_4.wwww, clipPos_xyzw_3);
                float2 r1_xy_4 = ((cb1_values[6].xyxx * float4(0.5, 0.5, 0, 0))).xy;
                o.sv_Position0.xy = ((clipPos_xyzw_5.wwww * (((round(((((clipPos_xyzw_5.xyxx / clipPos_xyzw_5.wwww)).xyxx * r1_xy_4.xyxx)).xyxx)).xyxx / r1_xy_4.xyxx)).xyxx)).xy;
                o.sv_Position0.zw = (clipPos_xyzw_5.zzzw).zw;
                o.color0.xyzw = (i.color0.xyzw * _Color);
                o.texcoord0.xy = (i.texcoord0.xyxx).xy;
                return o;
            }
            #pragma fragment frag
            program6Output frag(program6Input i)
            {
                program6Output o = (program6Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_2 = (-r0_xyzw_1.xyzx + (dot(r0_xyzw_1.xyzx, float4(0.3, 0.59, 0.11, 0))).xxxx);
                float r1_x_2 = r1_xyzw_2.x;
                float r1_y_1 = r1_xyzw_2.y;
                float r1_z_1 = r1_xyzw_2.z;
                float3 r0_xyz_2 = (mad(_EffectAmount.xxxx, float4(r1_x_2, r1_y_1, r1_z_1, r1_x_2), r0_xyzw_1.xyzx)).xyz;
                o.sv_Target0.xyzw = (float4(r0_xyz_2.x, r0_xyz_2.y, r0_xyz_2.z, r0_xyzw_1.w) * i.color0.xyzw);
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Sprites/Default"
}
