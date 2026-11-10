Shader "Corpus/01 Properties" {
	Properties {
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
		[HDR] _HdrColor ("HDR Color", Vector) = (1,1,1,1)
		[Gamma] _GammaColor ("Gamma Color", Vector) = (0.5,0.5,0.5,1)
		[PerRendererData] _PerRendererColor ("Per Renderer Color", Vector) = (1,1,1,1)
		_BaseMap ("Base Map", 2D) = "white" {}
		_BaseColor ("Base Color", Vector) = (1,1,1,1)
		[HideInInspector] _Hidden ("Hidden", Float) = 0
		_Float ("Float", Float) = 1.5
		_Int ("Int", Float) = 3
		_Color ("Color", Vector) = (1,0,1,1)
		_Vector ("Vector", Vector) = (1,2,3,4)
		_Range ("Range", Range(-5, 5)) = 2
		_Tex2D ("2D", 2D) = "white" {}
		_Tex3D ("3D", 3D) = "black" {}
		_TexCube ("Cube", Cube) = "black" {}
		_Tex2DArray ("2D Array", 2DArray) = "white" {}
		_TexCubeArray ("Cube Array", CubeArray) = "black" {}
	}
	//DummyShaderTextExporter
	SubShader{
		Tags { "RenderType"="Opaque" }
		LOD 200

		Pass
		{
			HLSLPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			float4x4 unity_ObjectToWorld;
			float4x4 unity_MatrixVP;

			struct Vertex_Stage_Input
			{
				float4 pos : POSITION;
			};

			struct Vertex_Stage_Output
			{
				float4 pos : SV_POSITION;
			};

			Vertex_Stage_Output vert(Vertex_Stage_Input input)
			{
				Vertex_Stage_Output output;
				output.pos = mul(unity_MatrixVP, mul(unity_ObjectToWorld, input.pos));
				return output;
			}

			float4 _Color;

			float4 frag(Vertex_Stage_Output input) : SV_TARGET
			{
				return _Color; // RGBA
			}

			ENDHLSL
		}
	}
	Fallback "Diffuse"
}