Shader "Custom/Planets_Atmosphere" {
	Properties {
		_Highatmospherecolor ("High atmosphere color", Vector) = (0.5,0.5,0.5,0)
		_Lowatmospherecolor ("Low atmosphere color", Vector) = (0.5,0.5,0.5,1)
		_Inneratmosphere ("Inner atmosphere", Vector) = (0.5,0.5,0.5,1)
		_Outeratmospherelimit ("Outer atmosphere limit", Range(0, 1)) = 0.548887
		_Outeratmopsheredensity ("Outer atmopshere density", Range(0, 1)) = 1
		_Inneratmopsheredensity ("Inner atmopshere density", Range(0, 1)) = 0.08092485
		_Innerouterlimit ("Inner outer limit", Range(0, 1)) = 0.6647399
		_Inneroutersmoothness ("Inner outer smoothness", Range(0, 1)) = 0.2572428
		_DisplacementAtmosphere ("Displacement atmosphere", Range(0, 0.1)) = 0.1
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