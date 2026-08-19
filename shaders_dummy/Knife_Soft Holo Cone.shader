Shader "Knife/Soft Holo Cone" {
	Properties {
		_Softness ("Softness", Range(0, 1)) = 0
		[HDR] _Color ("Color", Vector) = (0,0,0,0)
		_Mask ("Mask", 2D) = "white" {}
		_DepthFadeDistance ("DepthFadeDistance", Float) = 0
		_MaskSoftness ("MaskSoftness", Range(0, 1)) = 0
		_MaskSoftness2 ("MaskSoftness 2", Range(0, 1)) = 0
		_Mask2 ("Mask 2", 2D) = "white" {}
		_Mask2Speed ("Mask2Speed", Vector) = (0,0,0,0)
		_Alpha ("Alpha", Range(0, 1)) = 1
		[HideInInspector] _texcoord ("", 2D) = "white" {}
		[HideInInspector] __dirty ("", Float) = 1
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
	//CustomEditor "ASEMaterialInspector"
}