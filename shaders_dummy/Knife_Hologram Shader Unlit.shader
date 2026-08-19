Shader "Knife/Hologram Shader Unlit" {
	Properties {
		[HDR] _MainColor ("Main Color", Vector) = (0.620945,1.420074,3.953349,0.05098039)
		[NoScaleOffset] _Line1 ("Line 1", 2D) = "white" {}
		_Line1Speed ("Line 1 Speed", Float) = -3.57
		_Line1Frequency ("Line 1 Frequency", Float) = 100
		_Line1Hardness ("Line 1 Hardness", Float) = 1.45
		_Line1InvertedThickness ("Line 1 Inverted Thickness", Range(0, 1)) = 0
		_Line1Alpha ("Line 1 Alpha", Float) = 0.15
		[NoScaleOffset] _Line2 ("Line 2", 2D) = "white" {}
		_Line2Speed ("Line 2 Speed", Float) = -1
		_Line2Frequency ("Line 2 Frequency", Float) = 1
		_Line2Hardness ("Line 2 Hardness", Float) = 2
		_Line2InvertedThickness ("Line 2 Inverted Thickness", Range(0, 1)) = 0.255
		_Line2Alpha ("Line 2 Alpha", Float) = 0.1
		[NoScaleOffset] _LineGlitch ("Line Glitch", 2D) = "white" {}
		_LineGlitchOffset ("Line Glitch Offset", Vector) = (0.03,0,0,0)
		_RandomGlitchOffset ("Random Glitch Offset", Vector) = (-0.5,0,0,0)
		_RandomGlitchAmount ("Random Glitch Amount", Range(0, 1)) = 0.089
		_ColorGlitchAffect ("Color Glitch Affect", Range(0, 1)) = 0.5
		_LineGlitchSpeed ("Line Glitch Speed", Float) = -0.26
		_LineGlitchFrequency ("Line Glitch Frequency", Float) = 0.2
		_LineGlitchHardness ("Line Glitch Hardness", Float) = 5
		_LineGlitchInvertedThickness ("Line Glitch Inverted Thickness", Range(0, 1)) = 0.825
		_FresnelScale ("Fresnel Scale", Float) = 1
		_FresnelPower ("Fresnel Power", Float) = 2
		_FresnelAlphaScale ("Fresnel Alpha Scale", Float) = 1
		_FresnelAlphaPower ("Fresnel Alpha Power", Float) = 2
		_NormalMap ("NormalMap", 2D) = "bump" {}
		_NormalScale ("NormalScale", Float) = 0
		_SoftIntersection2Distance ("Soft Intersection 2 Distance", Float) = 0
		_SoftIntersection1Distance ("Soft Intersection 1 Distance", Float) = 0
		_NormalAffect ("NormalAffect", Range(0, 1)) = 0
		_MaskCenter ("Mask Center", Vector) = (0,0,0,0)
		_SoftIntersection2Intensity ("Soft Intersection 2 Intensity", Float) = 1
		_SoftIntersection2Affect ("Soft Intersection 2 Affect", Range(0, 1)) = 1
		_SoftIntersection1Intensity ("Soft Intersection 1 Intensity", Float) = 1
		_SoftIntersection1Affect ("Soft Intersection 1 Affect", Range(0, 1)) = 1
		_MaskSize ("Mask Size", Vector) = (0,0,0,0)
		_RandomGlitchConstant ("Random Glitch Constant", Range(0, 1)) = 0
		_DissolveScale ("Dissolve Scale", Vector) = (0.1,1.01,5,0)
		_GrainScale ("Grain Scale", Vector) = (50,50,50,0)
		_GrainAffect ("Grain Affect", Range(0, 1)) = 1
		[Toggle(_COLORGLITCHFEATURE_ON)] _ColorGlitchFeature ("Color Glitch Feature", Float) = 0
		[Toggle(_GRAINFEATURE_ON)] _GrainFeature ("Grain Feature", Float) = 0
		_GrainValues ("Grain Values", Vector) = (0,1,0,0)
		_RandomGlitchTiling ("Random Glitch Tiling", Float) = 2.83
		_MaskFalloff ("Mask Falloff", Float) = 0
		[Toggle(_LINE2FEATURE_ON)] _Line2Feature ("Line 2 Feature", Float) = 0
		[Toggle(_FRESNELFEATURE_ON)] _FresnelFeature ("Fresnel Feature", Float) = 0
		[Toggle(_LINEGLITCHFEATURE_ON)] _LineGlitchFeature ("Line Glitch Feature", Float) = 0
		[Toggle(_RANDOMGLITCHFEATURE_ON)] _RandomGlitchFeature ("Random Glitch Feature", Float) = 0
		[KeywordEnum(Off,Alpha,Color)] _SoftIntersection2Feature ("Soft Intersection 2 Feature", Float) = 0
		[KeywordEnum(Off,Alpha,Color)] _SoftIntersection1Feature ("Soft Intersection 1 Feature", Float) = 0
		[Toggle(_LINE1FEATURE_ON)] _Line1Feature ("Line 1 Feature", Float) = 0
		[Toggle(_LINEBOTHFEATURE_ON)] _LineBothFeature ("Line Both Feature", Float) = 0
		_DissolveHide ("Dissolve Hide", Range(-1, 1)) = -1
		[Toggle(_DISSOLVEFEATURE_ON)] _DissolveFeature ("Dissolve Feature", Float) = 0
		[Toggle(_MASKFEATURE_ON)] _MaskFeature ("Mask Feature", Float) = 0
		[Toggle(_NORMALMAPFEATURE_ON)] _NormalMapFeature ("Normal Map Feature", Float) = 0
		[KeywordEnum(X,Y,Z)] _PositionFeature ("Position Feature", Float) = 1
		[KeywordEnum(World,Local,Custom)] _PositionSpaceFeature ("Position Space Feature", Float) = 0
		_PositionDirection ("Position Direction", Float) = 1
		_RandomOffset ("Random Offset", Float) = 0
		_AlphaMask ("Alpha Mask", 2D) = "white" {}
		_AlphaMaskAffect ("Alpha Mask Affect", Range(0, 1)) = 0.5
		[Toggle(_ALPHAMASKFEATURE_ON)] _AlphaMaskFeature ("Alpha Mask Feature", Float) = 0
		[Toggle] _ZWrite ("ZWrite", Float) = 0
		[Enum(UnityEngine.Rendering.CullMode)] _CullMode ("Cull Mode", Float) = 2
		[Toggle(_MASKLOCALFEATURE_ON)] _MaskLocalFeature ("Mask Local Feature", Float) = 0
		_MaskInversion ("Mask Inversion", Range(0, 1)) = 0
		_Voxelization ("Voxelization", Float) = 100
		_VoxelizationAffect ("Voxelization Affect", Range(0, 1)) = 1
		[Toggle(_VOXELIZATIONFEATURE_ON)] _VoxelizationFeature ("Voxelization Feature", Float) = 0
		_Alpha ("Alpha", Range(0, 1)) = 1
		[HideInInspector] _texcoord ("", 2D) = "white" {}
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
	//CustomEditor "Knife.HologramEffect.HologramShaderEditor"
}