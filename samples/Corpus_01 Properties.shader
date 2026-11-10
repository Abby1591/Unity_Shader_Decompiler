Shader "Corpus/01 Properties"
{
    Properties
    {
        [Header(Header Label)]
        _Header ("Header", Float) = 0
        [Space(12)]
        _Space ("Space", Float) = 0
        [Toggle]
        _Toggle ("Toggle", Float) = 1
        [ToggleOff]
        _ToggleOff ("Toggle Off", Float) = 0
        [Enum(UnityEngine.Rendering.CullMode)]
        _CullEnum ("Cull Mode", Float) = 2
        [Enum(Off,0,On,1)]
        _CustomEnum ("Custom Enum", Float) = 1
        [PowerSlider(3.0)]
        _Power ("Power", Range(0.01, 1)) = 0.5
        [IntRange]
        _IntRange ("Int Range", Range(0, 10)) = 5
        _NoScaleTex ("No Scale", 2D) = "" {}
        _NormalMap ("Normal Map", 2D) = "" {}
        _HdrColor ("HDR Color", Color) = (1,1,1,1)
        _GammaColor ("Gamma Color", Color) = (0.5,0.5,0.5,1)
        _PerRendererColor ("Per Renderer Color", Color) = (1,1,1,1)
        _BaseMap ("Base Map", 2D) = "" {}
        _BaseColor ("Base Color", Color) = (1,1,1,1)
        _Hidden ("Hidden", Float) = 0
        _Float ("Float", Float) = 1.5
        _Int ("Int", Float) = 3
        _Color ("Color", Color) = (1,0,1,1)
        _Vector ("Vector", Vector) = (1,2,3,4)
        _Range ("Range", Range(-5, 5)) = 2
        _Tex2D ("2D", 2D) = "" {}
        _Tex3D ("3D", 2D) = "" {}
        _TexCube ("Cube", 2D) = "" {}
        _Tex2DArray ("2D Array", 2D) = "" {}
        _TexCubeArray ("Cube Array", 2D) = "" {}
    }
    SubShader
    {
        Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
        LOD 100
        Pass
        {
            Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _BaseMap_ST : packoffset(c2);
                float _Float : packoffset(c3.x);
                float _Int : packoffset(c3.y);
                float4 _Color : packoffset(c4);
                float4 _Vector : packoffset(c5);
                float4 _HdrColor : packoffset(c6);
                float4 _GammaColor : packoffset(c7);
                float4 _BaseColor : packoffset(c8);
                float4 _PerRendererColor : packoffset(c9);
            };
            cbuffer _UnityPerDrawCB_b1
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b2
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_NoScaleTex;
            SamplerState sampler_NormalMap;
            SamplerState sampler_BaseMap;
            SamplerState sampler_Tex2D;
            SamplerState sampler_Tex3D;
            SamplerState sampler_TexCube;
            SamplerState sampler_Tex2DArray;
            Texture2D _NoScaleTex;
            Texture2D _NormalMap;
            Texture2D _BaseMap;
            Texture3D _Tex2D;
            TextureCube _Tex3D;
            Texture2DArray _TexCube;
            TextureCubeArray _Tex2DArray;
            struct program1Input
            {
                float4 position0 : POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 normal0 : NORMAL0;
            };
            struct program1Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
            };
            struct program3Output
            {
                float4 sv_Target0 : SV_Target;
            };
            #pragma vertex vert
            program1Output vert(program1Input i)
            {
                program1Output o = (program1Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_4 = UnityObjectToWorldPos(i.position0.xyz);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_4);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _BaseMap_ST.xyxx, _BaseMap_ST.zwzz)).xy;
                float worldNormal_x_5 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_5 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_5 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_5 = dot(float4(worldNormal_x_5, worldNormal_y_5, worldNormal_z_5, worldNormal_x_5), float4(worldNormal_x_5, worldNormal_y_5, worldNormal_z_5, worldNormal_x_5));
                float r0_w_6 = rsqrt(r0_w_5);
                o.texcoord1.xyz = ((r0_w_6.xxxx * float4(worldNormal_x_5, worldNormal_y_5, worldNormal_z_5, worldNormal_x_5))).xyz;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float3 r0_xyz_1 = ((-i.texcoord1.xyzx + unity_WorldToObject[0].xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitWorldNormal_xyz_1 = normalize(i.texcoord1);
                float r0_x_4 = (saturate(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx)) + 1);
                float4 r1_xyzw_2 = _NoScaleTex.Sample(sampler_NoScaleTex, (i.texcoord0.xyxx).xy);
                float4 r2_xyzw_1 = _NormalMap.Sample(sampler_NormalMap, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * r2_xyzw_1);
                float4 r2_xyzw_2 = _BaseMap.Sample(sampler_BaseMap, (i.texcoord0.xyxx).xy);
                float4 r1_xyzw_4 = (r1_xyzw_3 * r2_xyzw_2);
                float2 TEXCOORD0_xy_3 = (i.texcoord0.xyxx).xy;
                float r2_z_3 = 0.5;
                float4 r2_xyzw_4 = _Tex2D.Sample(sampler_Tex2D, (float4(TEXCOORD0_xy_3.x, TEXCOORD0_xy_3.y, r2_z_3, TEXCOORD0_xy_3.x)).xyz);
                float4 r1_xyzw_5 = (r1_xyzw_4 * r2_xyzw_4);
                float4 r2_xyzw_5 = _Tex3D.Sample(sampler_Tex3D, i.texcoord1.xyz);
                float4 r1_xyzw_6 = (r1_xyzw_5 * r2_xyzw_5);
                float2 TEXCOORD0_xy_6 = (i.texcoord0.xyxx).xy;
                float r2_z_6 = 0;
                float4 r2_xyzw_7 = _TexCube.Sample(sampler_TexCube, (float4(TEXCOORD0_xy_6.x, TEXCOORD0_xy_6.y, r2_z_6, TEXCOORD0_xy_6.x)).xyz);
                float4 r1_xyzw_7 = (r1_xyzw_6 * r2_xyzw_7);
                float3 TEXCOORD1_xyz_8 = i.texcoord1.xyz;
                float r2_w_6 = 0;
                float4 r2_xyzw_9 = _Tex2DArray.Sample(sampler_Tex2DArray, (float4(TEXCOORD1_xyz_8.x, TEXCOORD1_xyz_8.y, TEXCOORD1_xyz_8.z, r2_w_6)).xyzw);
                float4 r1_xyzw_8 = (r1_xyzw_7 * r2_xyzw_9);
                float4 r2_xyzw_10 = (_Color + _BaseColor);
                float4 r2_xyzw_11 = (r2_xyzw_10 + _HdrColor);
                float4 r2_xyzw_12 = (r2_xyzw_11 + _GammaColor);
                float4 r2_xyzw_13 = (r2_xyzw_12 + _PerRendererColor);
                float4 r1_xyzw_9 = (r1_xyzw_8 * r2_xyzw_13);
                float4 r0_xyzw_3 = mad(r1_xyzw_9.xxyz, float4(0, 0.30530602, 0.30530602, 0.30530602), float4(0, 0.6821711, 0.6821711, 0.6821711));
                float r0_y_3 = r0_xyzw_3.y;
                float r0_z_3 = r0_xyzw_3.z;
                float r0_w_5 = r0_xyzw_3.w;
                float4 r0_xyzw_4 = mad(r1_xyzw_9.xxyz, float4(r0_y_3, r0_y_3, r0_z_3, r0_w_5), float4(0, 0.012522878, 0.012522878, 0.012522878));
                float r0_y_4 = r0_xyzw_4.y;
                float r0_z_4 = r0_xyzw_4.z;
                float r0_w_6 = r0_xyzw_4.w;
                o.sv_Target0.w = r1_xyzw_9.w;
                float4 r0_xyzw_7 = mad(float4(r0_y_4, r0_z_4, r0_w_6, r0_y_4), ((r1_xyzw_9.xyzx * r1_xyzw_9.xyzx)).xyzx, (((r0_x_4 * r0_x_4) * 0.001)).xxxx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_5 = r0_xyzw_7.y;
                float r0_z_5 = r0_xyzw_7.z;
                float r0_w_7 = (float)(_Int);
                float r0_w_8 = (r0_w_7 + _Float);
                float r0_w_9 = (r0_w_8 + _Vector.x);
                float r0_w_10 = (r0_w_9 + _Vector.y);
                float r0_w_11 = (r0_w_10 + _Vector.z);
                float r0_w_12 = (r0_w_11 + _Vector.w);
                o.sv_Target0.xyz = (mad(r0_w_12.xxxx, float4(0.001, 0.001, 0.001, 0), float4(r0_x_7, r0_y_5, r0_z_5, r0_x_7))).xyz;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Diffuse"
}
