Shader "Custom/Planet_Base_OCEANMOD" {
	Properties {
		_Oceancolor ("Ocean Color", Vector) = (0.5,0.5,0.5,0)
		_OceanGlossiness ("Ocean Glossiness", Vector) = (0.5,0.5,0.5,0)
		_OceanAO ("Ocean AO", Vector) = (0.5,0.5,0.5,0)
		_OceanEmission ("Ocean Emission", Vector) = (0.5,0.5,0.5,0)
		_AOalbedo ("AO in albedy", Range(0, 2)) = 0
		_SmoothnessShift ("Smoothness shift", Range(-1, 1)) = 0
		_AOsmoothness ("AO in smoothness", Range(-1, 1)) = 0
		_AOintensity ("AO intensity", Range(0.2, 5)) = 1
		_EmissionScale ("Emission Scale", Float) = 0
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