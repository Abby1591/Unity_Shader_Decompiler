Shader "Corpus/29 Skybox"
{
    Properties
    {
        [HDR] _Tex ("Cubemap", Cube) = "" {}
        _Tint ("Tint", Color) = (0.5, 0.5, 0.5, 0.5)
        _Exposure ("Exposure", Float) = 1
        _Rotation ("Rotation", Range(0, 360)) = 0
        _GroundColor ("Ground Color", Color) = (0.1, 0.1, 0.1, 1)
        _GroundHeight ("Ground Height", Range(-1, 1)) = -0.2
    }

    SubShader
    {
        Tags { "Queue" = "Background" "RenderType" = "Background" "PreviewType" = "Skybox" }
        Cull Off
        ZWrite Off

        Pass
        {
            Name "SKYBOX"
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0
            #pragma only_renderers d3d11
            #include "UnityCG.cginc"

            samplerCUBE _Tex;
            float4 _Tex_HDR;
            float4 _Tint;
            float _Exposure;
            float _Rotation;
            float4 _GroundColor;
            float _GroundHeight;

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 texcoord : TEXCOORD0;
            };

            v2f vert(appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.texcoord = v.vertex.xyz;
                return o;
            }

            float3 RotateAroundY(float3 dir, float radians)
            {
                float2x2 rot = float2x2(cos(radians), -sin(radians), sin(radians), cos(radians));
                return float3(mul(rot, dir.xz), dir.y).xzy;
            }

            float4 frag(v2f i) : SV_Target
            {
                float3 dir = normalize(i.texcoord);
                dir = RotateAroundY(dir, radians(_Rotation));
                float4 color = texCUBE(_Tex, dir);
                color.rgb = DecodeHDR(color, _Tex_HDR);
                color.rgb *= _Tint.rgb * _Exposure;
                float ground = smoothstep(_GroundHeight, _GroundHeight + 0.2, dir.y);
                color.rgb = lerp(_GroundColor.rgb, color.rgb, ground);
                color.rgb = LinearToGammaSpace(color.rgb);
                return color;
            }
            ENDCG
        }
    }

    FallBack "Skybox/Procedural"
}
