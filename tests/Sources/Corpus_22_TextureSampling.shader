Shader "Corpus/22 Texture Sampling"
{
    Properties
    {
        _Tex2D ("2D", 2D) = "white" {}
        _Tex3D ("3D", 3D) = "black" {}
        _TexCube ("Cube", Cube) = "black" {}
        _Tex2DArray ("2D Array", 2DArray) = "white" {}
        _TexCubeArray ("Cube Array", CubeArray) = "black" {}
        _Bias ("Bias", Range(0, 4)) = 0
        _Lod ("Lod", Range(0, 8)) = 0
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }

        Pass
        {
            Name "SAMPLING"
            Cull Off
            ZWrite On

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 5.0
            #pragma only_renderers d3d11
            #include "UnityCG.cginc"

            UNITY_DECLARE_TEX2D(_Tex2D);
            UNITY_DECLARE_TEX3D(_Tex3D);
            UNITY_DECLARE_TEXCUBE(_TexCube);
            UNITY_DECLARE_TEX2DARRAY(_Tex2DArray);
            UNITY_DECLARE_TEXCUBEARRAY(_TexCubeArray);

            Texture2D<float4> _TypedTex;
            SamplerState sampler_TypedTex;
            Texture2D _ShadowMap;
            SamplerComparisonState sampler_ShadowMap;

            // Legacy sampler intrinsics need classic sampler objects rather than
            // the Texture2D/SamplerState pairs declared above.
            sampler2D _LegacyTex2D;
            sampler3D _LegacyTex3D;
            samplerCUBE _LegacyTexCube;

            float _Bias;
            float _Lod;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float3 viewDir : TEXCOORD2;
                float4 screenPos : TEXCOORD3;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.viewDir = UnityWorldSpaceViewDir(mul(unity_ObjectToWorld, v.vertex).xyz);
                o.screenPos = ComputeScreenPos(o.pos);
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float2 uv = i.uv;
                float3 uvw = float3(uv, 0.5);
                float3 dir = normalize(i.normal);
                float2 dx = ddx(uv);
                float2 dy = ddy(uv);

                float4 s0 = _Tex2D.Sample(sampler_Tex2D, uv);
                float4 s1 = _Tex2D.SampleLevel(sampler_Tex2D, uv, _Lod);
                float4 s2 = _Tex2D.SampleGrad(sampler_Tex2D, uv, dx, dy);
                float4 s3 = _Tex2D.SampleBias(sampler_Tex2D, uv, _Bias);
                float4 s4 = _Tex2D.Sample(sampler_Tex2D, uv, int2(1, 1));
                float4 s5 = _Tex2D.Gather(sampler_Tex2D, uv, int2(0, 0));
                float4 s6 = _Tex2D.Load(int3(int2(uv * 256.0), 0));
                uint width, height;
                _Tex2D.GetDimensions(width, height);
                float4 s7 = _TypedTex.Sample(sampler_TypedTex, uv);
                float4 s8 = _ShadowMap.SampleCmp(sampler_ShadowMap, uv, 0.5);
                float4 s9 = _ShadowMap.SampleCmpLevelZero(sampler_ShadowMap, uv, 0.5);

                float4 t0 = _Tex3D.Sample(sampler_Tex3D, uvw);
                float4 t1 = _Tex3D.SampleLevel(sampler_Tex3D, uvw, _Lod);
                float4 c0 = _TexCube.Sample(sampler_TexCube, dir);
                float4 c1 = _TexCube.SampleLevel(sampler_TexCube, dir, _Lod);
                float4 a0 = _Tex2DArray.Sample(sampler_Tex2DArray, float3(uv, 0.0));
                float4 a1 = _Tex2DArray.SampleLevel(sampler_Tex2DArray, float3(uv, 0.0), _Lod);
                float4 ca0 = _TexCubeArray.Sample(sampler_TexCubeArray, float4(dir, 0.0));
                float4 ca1 = _TexCubeArray.SampleLevel(sampler_TexCubeArray, float4(dir, 0.0), _Lod);

                float4 l0 = tex2D(_LegacyTex2D, uv);
                float4 l1 = tex2Dlod(_LegacyTex2D, float4(uv, 0, _Lod));
                float4 l2 = tex2Dproj(_LegacyTex2D, UNITY_PROJ_COORD(i.screenPos));
                float4 l3 = tex2Dbias(_LegacyTex2D, float4(uv, 0, _Bias));
                float4 l4 = tex3D(_LegacyTex3D, uvw);
                float4 l5 = texCUBE(_LegacyTexCube, dir);

                float4 result = s0 + s1 + s2 + s3 + s4 + s5 + s6 + s7 + s8 + s9;
                result += t0 + t1 + c0 + c1 + a0 + a1 + ca0 + ca1;
                result += l0 + l1 + l2 + l3 + l4 + l5;
                result *= 1.0 / 29.0;
                result.a = saturate((float)width / max((float)height, 1.0));
                return result;
            }
            ENDCG
        }
    }

    FallBack "Diffuse"
}
