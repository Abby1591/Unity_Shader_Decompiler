Shader "Corpus/01 Properties"
{
    Properties
    {
        [Header(Header Label)] _Header ("Header", Float) = 0
        [Space(12)] _Space ("Space", Float) = 0
        [Toggle] _Toggle ("Toggle", Float) = 1
        [ToggleOff] _ToggleOff ("Toggle Off", Float) = 0
        [Enum(UnityEngine.Rendering.CullMode)] _CullEnum ("Cull Mode", Float) = 2
        [Enum(Off,0,On,1)] _CustomEnum ("Custom Enum", Float) = 1
        [PowerSlider(3.0)] _Power ("Power", Range(0.01, 1)) = 0.5
        [IntRange] _IntRange ("Int Range", Range(0, 10)) = 5
        [NoScaleOffset] _NoScaleTex ("No Scale", 2D) = "white" {}
        [Normal] _NormalMap ("Normal Map", 2D) = "bump" {}
        [HDR] _HdrColor ("HDR Color", Color) = (1, 1, 1, 1)
        [Gamma] _GammaColor ("Gamma Color", Color) = (0.5, 0.5, 0.5, 1)
        [PerRendererData] _PerRendererColor ("Per Renderer Color", Color) = (1, 1, 1, 1)
        [MainTexture] _BaseMap ("Base Map", 2D) = "white" {}
        [MainColor] _BaseColor ("Base Color", Color) = (1, 1, 1, 1)
        [HideInInspector] _Hidden ("Hidden", Float) = 0
        _Float ("Float", Float) = 1.5
        _Int ("Int", Int) = 3
        _Color ("Color", Color) = (1, 0, 1, 1)
        _Vector ("Vector", Vector) = (1, 2, 3, 4)
        _Range ("Range", Range(-5, 5)) = 2
        _Tex2D ("2D", 2D) = "white" {}
        _Tex3D ("3D", 3D) = "black" {}
        _TexCube ("Cube", Cube) = "black" {}
        _Tex2DArray ("2D Array", 2DArray) = "white" {}
        _TexCubeArray ("Cube Array", CubeArray) = "black" {}
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Geometry" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 4.5
            #pragma only_renderers d3d11

            #include "UnityCG.cginc"
            #include "CorpusCommon.cginc"

            sampler2D _BaseMap;
            float4 _BaseMap_ST;
            sampler2D _NormalMap;
            sampler2D _NoScaleTex;
            sampler2D _Tex2D;
            sampler3D _Tex3D;
            samplerCUBE _TexCube;
            UNITY_DECLARE_TEX2DARRAY(_Tex2DArray);
            UNITY_DECLARE_TEXCUBEARRAY(_TexCubeArray);

            float _Float;
            int _Int;
            float4 _Color;
            float4 _Vector;
            float4 _HdrColor;
            float4 _GammaColor;
            float4 _BaseColor;
            float4 _PerRendererColor;

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
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _BaseMap);
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                float4 baseMap = tex2D(_BaseMap, i.uv);
                float4 noScale = tex2D(_NoScaleTex, i.uv);
                float4 tex2d = tex2D(_Tex2D, i.uv);
                float4 tex3d = tex3D(_Tex3D, float3(i.uv, 0.5));
                float4 texCube = texCUBE(_TexCube, i.normal);
                float4 tex2dArray = UNITY_SAMPLE_TEX2DARRAY(_Tex2DArray, float3(i.uv, 0.0));
                float4 texCubeArray = UNITY_SAMPLE_TEXCUBEARRAY(_TexCubeArray, float4(i.normal, 0.0));

                float scalar = _Float + _Int + _Vector.x + _Vector.y + _Vector.z + _Vector.w;
                float4 combined = baseMap * noScale * tex2d * tex3d * texCube * tex2dArray * texCubeArray;
                combined *= _BaseColor + _Color + _HdrColor + _GammaColor + _PerRendererColor;
                combined.rgb *= CorpusSrgbToLinear(combined.rgb);
                combined.rgb += CorpusFresnel(i.normal, UnityWorldSpaceViewDir(i.normal), 2.0).xxx * 0.001;
                combined.rgb += scalar * 0.001;
                return combined;
            }
            ENDCG
        }
    }

    Fallback "Diffuse"
}
