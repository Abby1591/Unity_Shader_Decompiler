Shader "Corpus/17 Image Effect"
{
    Properties
    {
        _MainTex ("Source", 2D) = "white" {}
        _Intensity ("Intensity", Range(0, 4)) = 1
        _BlurSize ("Blur Size", Range(0, 8)) = 1
        _DepthStrength ("Depth Strength", Range(0, 4)) = 1
        _Vignette ("Vignette", Range(0, 2)) = 0.5
    }

    SubShader
    {
        Cull Off
        ZWrite Off
        ZTest Always

        Pass
        {
            Name "DEPTH_BLUR_TONEMAP"
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #pragma target 4.0
            #pragma only_renderers d3d11
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_TexelSize;
            UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);
            sampler2D _CameraDepthNormalsTexture;
            sampler2D _CameraMotionVectorsTexture;
            float4 _CameraMotionVectorsTexture_TexelSize;
            float _Intensity;
            float _BlurSize;
            float _DepthStrength;
            float _Vignette;

            float4 frag(v2f_img i) : SV_Target
            {
                float2 uv = i.uv;
                #if UNITY_UV_STARTS_AT_TOP
                if (_MainTex_TexelSize.y < 0.0)
                    uv.y = 1.0 - uv.y;
                #endif

                float2 texel = _MainTex_TexelSize.xy * _BlurSize;
                float4 center = tex2D(_MainTex, uv);
                float4 blur = center * 4.0;
                blur += tex2D(_MainTex, uv + float2(texel.x, 0.0));
                blur += tex2D(_MainTex, uv + float2(-texel.x, 0.0));
                blur += tex2D(_MainTex, uv + float2(0.0, texel.y));
                blur += tex2D(_MainTex, uv + float2(0.0, -texel.y));
                blur *= 0.125;

                float rawDepth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv);
                float eyeDepth = LinearEyeDepth(rawDepth);
                float sceneDepth = Linear01Depth(rawDepth);

                float4 depthNormals = tex2D(_CameraDepthNormalsTexture, uv);
                float depth;
                float3 normal;
                DecodeDepthNormal(depthNormals, depth, normal);

                float4 motion = tex2D(_CameraMotionVectorsTexture, uv);
                float2 motionOffset = motion.xy * _CameraMotionVectorsTexture_TexelSize.xy;

                float3 color = lerp(center.rgb, blur.rgb, saturate(eyeDepth * 0.1 * _DepthStrength));
                color *= _Intensity;
                color += normal * 0.01;
                color += motionOffset.xyx * 0.1;
                color *= 1.0 - saturate((distance(i.uv, 0.5) - 0.2) * _Vignette);
                color = color / (1.0 + color);
                color = LinearToGammaSpace(max(color, 0.0));
                return float4(color, 1.0);
            }
            ENDCG
        }
    }

    FallBack Off
}
