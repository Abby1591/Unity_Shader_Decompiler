Shader "Corpus/28 Unity Macros"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BumpMap ("Normal", 2D) = "bump" {}
        _Color ("Color", Color) = (1, 1, 1, 1)
        _BumpScale ("Bump Scale", Float) = 1
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }

        Pass
        {
            Name "MACROS"
            Cull Back
            ZWrite On

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog
            #pragma target 4.0
            #pragma only_renderers d3d11
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _BumpMap;
            float4 _BumpMap_ST;
            UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);
            float4 _Color;
            float _BumpScale;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 bumpUV : TEXCOORD1;
                float3 normal : TEXCOORD2;
                float3 worldPos : TEXCOORD3;
                float eyeDepth : TEXCOORD4;
                float4 screenPos : TEXCOORD5;
                UNITY_FOG_COORDS(6)
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.pos = UnityPixelSnap(o.pos);
                o.uv = UnityStereoScreenSpaceUVAdjust(TRANSFORM_TEX(v.uv, _MainTex), _MainTex_ST);
                o.bumpUV = TRANSFORM_TEX(v.uv, _BumpMap);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.screenPos = ComputeScreenPos(o.pos);
                COMPUTE_EYEDEPTH(o.eyeDepth);
                UNITY_TRANSFER_FOG(o, o.pos);

                float3 objectDir = UnityWorldToObjectDir(o.normal);
                float3 worldDir = UnityObjectToWorldDir(objectDir);
                o.normal = normalize(worldDir);
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float4 tex = tex2D(_MainTex, i.uv);
                float4 packedNormal = tex2D(_BumpMap, i.bumpUV);
                float3 normal = UnpackNormalDXT5nm(packedNormal);
                normal = UnpackNormalWithScale(packedNormal, _BumpScale);

                float viewDepth = DECODE_EYEDEPTH(UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.screenPos.xy / i.screenPos.w)));
                float linear01 = Linear01Depth(i.eyeDepth);
                float linearEye = LinearEyeDepth(i.eyeDepth);

                float4 encodedRGBA = EncodeFloatRGBA(frac(i.eyeDepth));
                float decodedRGBA = DecodeFloatRGBA(encodedRGBA);
                float2 encodedRG = EncodeFloatRG(frac(i.eyeDepth));
                float decodedRG = DecodeFloatRG(encodedRG);

                float3 objectLight = ObjSpaceLightDir(float4(i.worldPos, 1.0));
                float3 objectView = ObjSpaceViewDir(float4(i.worldPos, 1.0));
                float3 worldLight = UnityWorldSpaceLightDir(i.worldPos);
                float3 worldView = UnityWorldSpaceViewDir(i.worldPos);
                float3 toEye = WorldSpaceViewDir(float4(i.worldPos, 1.0));
                float3 toLight = WorldSpaceLightDir(float4(i.worldPos, 1.0));

                float lum = Luminance(tex.rgb);
                float linearLum = LinearRgbToLuminance(tex.rgb);
                float3 linearColor = GammaToLinearSpace(tex.rgb);
                float3 gamma = LinearToGammaSpace(linearColor);

                float3 color = tex.rgb * _Color.rgb * gamma;
                color += normal * 0.01;
                color += (float3)0.001 * (viewDepth + linear01 + linearEye + decodedRGBA + decodedRG);
                color += (objectLight + objectView + worldLight + worldView + toEye + toLight) * 0.001;
                color *= 0.5 + 0.5 * saturate(lum + linearLum);

                UNITY_APPLY_FOG(i.fogCoord, color);
                return float4(color, tex.a);
            }
            ENDCG
        }
    }

    FallBack "Diffuse"
}
