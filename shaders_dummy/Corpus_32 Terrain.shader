Shader "Corpus/32 Terrain" {
	Properties {
		_Control ("Splat Control", 2D) = "white" {}
		_Splat0 ("Splat 0", 2D) = "white" {}
		_Splat1 ("Splat 1", 2D) = "white" {}
		_Splat2 ("Splat 2", 2D) = "white" {}
		_Splat3 ("Splat 3", 2D) = "white" {}
		_Normal0 ("Normal 0", 2D) = "bump" {}
		_Normal1 ("Normal 1", 2D) = "bump" {}
		_Normal2 ("Normal 2", 2D) = "bump" {}
		_Normal3 ("Normal 3", 2D) = "bump" {}
		_Metallic ("Metallic", Range(0, 1)) = 0
		_Smoothness ("Smoothness", Range(0, 1)) = 0.2
		_HeightBlend ("Height Blend", Range(0, 1)) = 0.5
	}
	//DummyShaderTextExporter
	SubShader{
		Tags { "RenderType" = "Opaque" }
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

			float4 frag(Vertex_Stage_Output input) : SV_TARGET
			{
				return float4(1.0, 1.0, 1.0, 1.0); // RGBA
			}

			ENDHLSL
		}
	}
	Fallback "Diffuse"
}