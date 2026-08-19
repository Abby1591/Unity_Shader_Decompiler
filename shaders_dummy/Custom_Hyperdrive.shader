Shader "Custom/Hyperdrive" {
	Properties {
		_MainTex ("Texture1", 2D) = "white" {}
		_Brightness ("Brightness Shift", Range(0, 1)) = 0.007
		_BrightnessFade ("Brightness Fade", Range(0.5, 10)) = 3
		_RedShift ("Red Shift", Range(0, 0.333)) = 0.1
		_ColorShift ("Color Shift", Range(0, 0.01)) = 0.0007
		_Speed ("Speed", Range(0.1, 1)) = 0.6
		_YScale ("Y Scale", Range(0.01, 1)) = 0.271
		_XYScale ("XY Scale", Range(1, 1000)) = 196
		_StarCount ("Star Count", Range(0.001, 0.1)) = 0.04
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
	Fallback "VertexLit"
}