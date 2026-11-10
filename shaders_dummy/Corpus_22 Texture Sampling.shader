Shader "Corpus/22 Texture Sampling" {
	Properties {
		_Tex2D ("2D", 2D) = "white" {}
		_Tex3D ("3D", 3D) = "black" {}
		_TexCube ("Cube", Cube) = "black" {}
		_Tex2DArray ("2D Array", 2DArray) = "white" {}
		_TexCubeArray ("Cube Array", CubeArray) = "black" {}
		_Bias ("Bias", Range(0, 4)) = 0
		_Lod ("Lod", Range(0, 8)) = 0
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