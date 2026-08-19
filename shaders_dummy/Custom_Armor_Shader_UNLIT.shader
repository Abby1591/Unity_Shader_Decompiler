Shader "Custom/Armor_Shader_UNLIT" {
	Properties {
		_ArmorColor ("Armor Color", Vector) = (1,0.639,0,0.7)
		_EmissionColor ("Emission Color", Vector) = (1,0.75,0,0)
		_EmissionScale ("Emission Scale", Range(0.01, 10)) = 4.5
		_AnimationSpeed ("Animation Speed", Float) = 30
		_AnimationAmount ("Animation Amount", Range(0, 1)) = 0.3
		_RippleSize ("Ripple Size", Range(1, 200)) = 200
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
	Fallback "Unlit"
}