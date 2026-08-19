Shader "PicaVoxel/PicaVoxel PBR OneMinus Alpha Emissive" {
	Properties {
		_Metallic ("Metallic", Range(0, 1)) = 0
		_Gloss ("Gloss", Range(0, 1)) = 0.8
		_GlowAmount ("Glow Amount", Range(1, 100)) = 1
		_Tint ("Tint", Vector) = (1,1,1,1)
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
	Fallback "PicaVoxel/PicaVoxel Diffuse"
	//CustomEditor "ShaderForgeMaterialInspector"
}