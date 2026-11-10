Shader "Corpus/37 Water" {
	Properties {
		_Color ("Water Color", Vector) = (0.1,0.3,0.5,1)
		_NormalMap ("Normal Map", 2D) = "bump" {}
		_NormalScale ("Normal Scale", Float) = 1
		_WaveMap ("Wave Map", 2D) = "gray" {}
		_WaveSpeed ("Wave Speed", Vector) = (0.5,0.5,0,0)
		_WaveScale ("Wave Scale", Float) = 1
		_ReflectionCube ("Reflection", Cube) = "black" {}
		_ReflectionStrength ("Reflection Strength", Range(0, 1)) = 0.5
		_RefractionStrength ("Refraction Strength", Range(0, 0.2)) = 0.05
		_FresnelPower ("Fresnel Power", Range(0.1, 8)) = 4
		_DepthFade ("Depth Fade", Range(0.01, 10)) = 1
		_Specular ("Specular", Range(0, 1)) = 0.5
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
	Fallback "Legacy Shaders/Transparent/Diffuse"
}