Shader "Corpus/37 Water"
{
    Properties
    {
        _Color ("Water Color", Color) = (0.1, 0.3, 0.5, 1)
        _NormalMap ("Normal Map", 2D) = "bump" {}
        _NormalScale ("Normal Scale", Float) = 1
        _WaveMap ("Wave Map", 2D) = "gray" {}
        _WaveSpeed ("Wave Speed", Vector) = (0.5, 0.5, 0, 0)
        _WaveScale ("Wave Scale", Float) = 1
        _ReflectionCube ("Reflection", Cube) = "black" {}
        _ReflectionStrength ("Reflection Strength", Range(0, 1)) = 0.5
        _RefractionStrength ("Refraction Strength", Range(0, 0.2)) = 0.05
        _FresnelPower ("Fresnel Power", Range(0.1, 8)) = 4
        _DepthFade ("Depth Fade", Range(0.01, 10)) = 1
        _Specular ("Specular", Range(0, 1)) = 0.5
    }

    SubShader
    {
        Tags { "Queue" = "Transparent" "RenderType" = "Transparent" "IgnoreProjector" = "True" }

        GrabPass { "_WaterGrab" }

        Pass
        {
            Name "WATER"
            Blend SrcAlpha OneMinusSrcAlpha
            ZWrite Off
            Cull Back

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 4.0
            #pragma only_renderers d3d11
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "CorpusCommon.cginc"

            sampler2D _NormalMap;
            float4 _NormalMap_ST;
            sampler2D _WaveMap;
            float4 _WaveMap_ST;
            sampler2D _WaterGrab;
            float4 _WaterGrab_TexelSize;
            samplerCUBE _ReflectionCube;
            float4 _Color;
            float _NormalScale;
            float4 _WaveSpeed;
            float _WaveScale;
            float _ReflectionStrength;
            float _RefractionStrength;
            float _FresnelPower;
            float _DepthFade;
            float _Specular;
            UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 grabPos : TEXCOORD1;
                float3 normal : TEXCOORD2;
                float3 worldPos : TEXCOORD3;
                float3 viewDir : TEXCOORD4;
                float eyeDepth : TEXCOORD5;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.grabPos = ComputeGrabScreenPos(o.pos);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.viewDir = UnityWorldSpaceViewDir(o.worldPos);
                o.eyeDepth = -UnityObjectToViewPos(v.vertex).z;
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float2 waveUV1 = TRANSFORM_TEX(i.uv, _WaveMap) + _Time.y * _WaveSpeed.xy;
                float2 waveUV2 = TRANSFORM_TEX(i.uv, _WaveMap) * 1.37 - _Time.y * _WaveSpeed.zw;
                float wave1 = tex2D(_WaveMap, waveUV1).r;
                float wave2 = tex2D(_WaveMap, waveUV2).r;
                float wave = (wave1 + wave2) * 0.5 * _WaveScale;

                float2 normalUV = TRANSFORM_TEX(i.uv, _NormalMap) + wave * 0.1;
                float3 tangentNormal = UnpackNormalWithScale(tex2D(_NormalMap, normalUV), _NormalScale);
                float3 normal = normalize(i.normal + tangentNormal * 0.5);

                float3 viewDir = normalize(i.viewDir);
                float fresnel = CorpusFresnel(normal, viewDir, _FresnelPower);
                float3 reflectDir = reflect(-viewDir, normal);
                float3 reflection = texCUBE(_ReflectionCube, reflectDir).rgb;

                float2 offset = normal.xy * _RefractionStrength * _WaterGrab_TexelSize.xy;
                float4 grab = tex2Dproj(_WaterGrab, UNITY_PROJ_COORD(i.grabPos + float4(offset, 0, 0)));

                float sceneZ = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.grabPos)));
                float depthFade = saturate((sceneZ - i.eyeDepth) / _DepthFade);

                float3 lightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                float3 halfDir = normalize(lightDir + viewDir);
                float spec = pow(saturate(dot(normal, halfDir)), 128.0) * _Specular;
                float3 lightColor = _LightColor0.rgb * saturate(dot(normal, lightDir));

                float3 color = _Color.rgb * grab.rgb;
                color = lerp(color, reflection, _ReflectionStrength * fresnel);
                color += lightColor * 0.25 + spec;
                color += CorpusNoise(i.uv * 20.0 + _Time.y) * 0.02;

                float alpha = saturate(_Color.a * (0.4 + fresnel) * depthFade);
                return float4(color, alpha);
            }
            ENDCG
        }
    }

    FallBack "Legacy Shaders/Transparent/Diffuse"
}
