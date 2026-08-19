Shader "Custom/Planet_Clouds_Atmosphere" {
	Properties {
		_MainTex ("Clouds Base (RGB)", 2D) = "white" {}
		_AlphaScale ("Clouds alpha Scale", Range(0, 2)) = 1
		[NoScaleOffset] _BumpMap ("Clouds normal Map", 2D) = "bump" {}
		_BumpScale ("Clouds bump Scale", Range(0, 1)) = 1
		_DisplacementClouds ("Clouds displacement", Range(0, 0.05)) = 0.005
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
		Tags { "RenderType"="Opaque" }
		LOD 200

		Pass
		{
			HLSLPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			float4x4 unity_ObjectToWorld;
			float4x4 unity_MatrixVP;
			float4 _MainTex_ST;

			struct Vertex_Stage_Input
			{
				float4 pos : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct Vertex_Stage_Output
			{
				float2 uv : TEXCOORD0;
				float4 pos : SV_POSITION;
			};

			Vertex_Stage_Output vert(Vertex_Stage_Input input)
			{
				Vertex_Stage_Output output;
				output.uv = (input.uv.xy * _MainTex_ST.xy) + _MainTex_ST.zw;
				output.pos = mul(unity_MatrixVP, mul(unity_ObjectToWorld, input.pos));
				return output;
			}

			Texture2D<float4> _MainTex;
			SamplerState sampler_MainTex;

			struct Fragment_Stage_Input
			{
				float2 uv : TEXCOORD0;
			};

			float4 frag(Fragment_Stage_Input input) : SV_TARGET
			{
				return _MainTex.Sample(sampler_MainTex, input.uv.xy);
			}

			ENDHLSL
		}
	}
	Fallback "Diffuse"
}