Shader "HOLO/Holo2" {
	Properties {
		_MainTex ("Not used confusing", 2D) = "white" {}
		_originalDiffuse ("Original Diffuse Map", 2D) = "white" {}
		_Diffuse ("Diffuse Map", 2D) = "white" {}
		[HDR] _diff_Color ("Diffuse Color Mult", Vector) = (1,1,1,1)
		_N_map ("Noise", 2D) = "white" {}
		_M_map ("Mask", 2D) = "white" {}
		[Toggle] _mask_type ("Use Map as Mask", Float) = 1
		_intensity ("Intensity", Float) = 0
		_deform ("Deformation Intensity", Float) = 1
		[HDR] _Color ("Outline Color Mult", Vector) = (1,1,1,1)
		_Opacity ("Base Opacity", Range(0, 1)) = 0
		_Bias ("Bias", Range(0, 1)) = 0
		_Scale ("Scale ", Range(0, 10)) = 0
		_Power ("Power", Range(0, 3)) = 0
		_Speed ("Speed", Range(0, 1)) = 0
		_t ("Extra Option", Range(0, 1)) = 0
		_noise_details ("G/H Noise Details Amount ", Range(1, 16)) = 0
		[Toggle] _X ("Active X Axe", Float) = 1
		[Toggle] _Y ("Active X Axe", Float) = 1
		[Toggle] _glitchColor ("Display G/H Color", Float) = 1
		[Toggle] _monochrom ("Monochromatic", Float) = 1
		[Toggle] _OriginalUVSwitch ("Switch to Orginal UVs on/off", Float) = 0
		_Distance ("Distance", Float) = 0
		_Amplitude ("Amplitude", Float) = 0
		_Speed_Up ("_Speed_Up", Float) = 0
		_Amount ("Amount", Range(0, 1)) = 0
		_cut_level ("Cut Level", Range(0, 1)) = 0
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
			float4 _Color;

			struct Fragment_Stage_Input
			{
				float2 uv : TEXCOORD0;
			};

			float4 frag(Fragment_Stage_Input input) : SV_TARGET
			{
				return _MainTex.Sample(sampler_MainTex, input.uv.xy) * _Color;
			}

			ENDHLSL
		}
	}
	//CustomEditor "Glitch_Editor_lite"
}