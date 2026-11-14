Shader "Corpus/31 Particles"
{
    Properties
    {
        _MainTex ("Particle Texture", 2D) = "white" {}
        _TintColor ("Tint Color", Color) = (0.5, 0.5, 0.5, 0.5)
        _InvFade ("Soft Particles Factor", Range(0.01, 3)) = 1
        _SoftParticleFactor ("Soft Particle Factor", Range(0, 1)) = 1
        _FlipbookSize ("Flipbook Size", Vector) = (1, 1, 1, 1)
        _FlipbookFPS ("Flipbook FPS", Float) = 30
    }

    SubShader
    {
        Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" "PreviewType" = "Plane" }
        Blend SrcAlpha OneMinusSrcAlpha
        ColorMask RGB
        Cull Off
        Lighting Off
        ZWrite Off

        Pass
        {
            Name "PARTICLES"
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_particles
            #pragma multi_compile_fog
            #pragma target 3.0
            #pragma only_renderers d3d11
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _TintColor;
            float _InvFade;
            float _SoftParticleFactor;
            float4 _FlipbookSize;
            float _FlipbookFPS;
            UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);

            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 uv : TEXCOORD0;
                float4 uv2 : TEXCOORD1;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float4 color : COLOR;
                float2 uv : TEXCOORD0;
                float4 projPos : TEXCOORD1;
                float eyeDepth : TEXCOORD2;
                float2 flipbook : TEXCOORD3;
                UNITY_FOG_COORDS(4)
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.color = v.color * _TintColor;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.projPos = ComputeScreenPos(o.pos);
                o.eyeDepth = -UnityObjectToViewPos(v.vertex).z;
                o.flipbook = v.uv2.xy;
                UNITY_TRANSFER_FOG(o, o.pos);
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float2 uv = i.uv;
                #ifdef SOFTPARTICLES_ON
                float2 frame = i.flipbook * _FlipbookSize.xy;
                uv = (uv + floor(frame)) / _FlipbookSize.xy;
                float sceneZ = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));
                float fade = saturate(_InvFade * (sceneZ - i.eyeDepth));
                fade = lerp(1.0, fade, _SoftParticleFactor);
                #else
                float fade = 1.0;
                #endif

                float4 color = tex2D(_MainTex, uv) * i.color;
                color.a *= fade;
                UNITY_APPLY_FOG_COLOR(i.fogCoord, color, fixed4(0, 0, 0, 0));
                return color;
            }
            ENDCG
        }
    }

    FallBack "Particles/Standard Unlit"
}
