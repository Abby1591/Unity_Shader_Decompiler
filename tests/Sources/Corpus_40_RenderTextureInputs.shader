Shader "Corpus/40 Render Texture Inputs"
{
    Properties
    {
        _MainTex ("Source", 2D) = "white" {}
        _Intensity ("Intensity", Range(0, 4)) = 1
    }

    SubShader
    {
        Cull Off
        ZWrite Off
        ZTest Always

        Pass
        {
            Name "GLOBALS"
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
            sampler2D _CameraOpaqueTexture;
            float _Intensity;

            float4 frag(v2f_img i) : SV_Target
            {
                float2 uv = i.uv;
                float4 color = tex2D(_MainTex, uv);
                float rawDepth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv);
                float4 depthNormals = tex2D(_CameraDepthNormalsTexture, uv);
                float4 motion = tex2D(_CameraMotionVectorsTexture, uv);
                float4 opaque = tex2D(_CameraOpaqueTexture, uv);

                float depth;
                float3 normal;
                DecodeDepthNormal(depthNormals, depth, normal);

                float2 screenSize = _ScreenParams.xy;
                float2 screenUV = uv * screenSize;
                float near = _ProjectionParams.y;
                float far = _ProjectionParams.z;
                float4 zBuffer = _ZBufferParams;
                float linear01 = Linear01Depth(rawDepth);
                float linearEye = LinearEyeDepth(rawDepth);
                float3 cameraPos = _WorldSpaceCameraPos;
                float3 cameraForward = -UNITY_MATRIX_V[2].xyz;
                float4 clipPlane0 = unity_CameraWorldClipPlanes[0];
                float ortho = unity_OrthoParams.x;
                float deltaTime = unity_DeltaTime.x;
                float2 projection = _ProjectionParams.xy;

                float3 viewRay = mul(unity_CameraInvProjection, float4(uv * 2.0 - 1.0, 1.0, 1.0)).xyz;
                float3 worldRay = mul((float3x3)unity_CameraToWorld, viewRay);

                float value = depth + normal.x + motion.x + opaque.x;
                value += screenUV.x * 0.001 + screenUV.y * 0.001;
                value += near + far + zBuffer.x + zBuffer.y + zBuffer.z + zBuffer.w;
                value += linear01 + linearEye + cameraPos.x + cameraForward.x + clipPlane0.x;
                value += ortho + deltaTime + projection.x;
                value += worldRay.x + _Time.x + _SinTime.x + _CosTime.x;
                value *= _Intensity;

                color.rgb = lerp(color.rgb, color.rgb * (1.0 + value * 0.01), 0.5);
                return color;
            }
            ENDCG
        }
    }

    FallBack Off
}
