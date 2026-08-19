Shader "Custom/Horizontal Skybox" {
	Properties {
		_Color1 ("Top Color", Vector) = (1,1,1,0)
		_Color2 ("Horizon Color", Vector) = (1,1,1,0)
		_Color3 ("Bottom Color", Vector) = (1,1,1,0)
		_Exponent1 ("Exponent Factor for Top Half", Float) = 1
		_Exponent2 ("Exponent Factor for Bottom Half", Float) = 1
		_Intensity ("Intensity Amplifier", Float) = 1
		_Angle ("Angle", Float) = 0
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
}