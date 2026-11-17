Shader "Corpus/19 Hull Domain"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
        _Tess ("Tessellation", Range(1, 32)) = 4
        _Displacement ("Displacement", Range(0, 1)) = 0.1
    }
    SubShader
    {
        Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
        Pass
        {
            Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            #pragma target 5.0
            cbuffer _GlobalsCB_b0
            {
                float4 _MainTex_ST : packoffset(c2);
                float4 _Color : packoffset(c3);
                float _Tess : packoffset(c4.x);
                float _Displacement : packoffset(c4.y);
            };
            cbuffer _UnityLightingCB_b1
            {
                float4 _WorldSpaceLightPos0 : packoffset(c0);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            cbuffer _UnityPerDrawCB_b2
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b3
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            struct program1Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program1Output
            {
                float4 sv_Position0 : SV_Position;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_POSITION;
                float3 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
            };
            struct program3Output
            {
                float4 sv_Target0 : SV_Target;
            };
            struct program5Input
            {
                float4 sv_Position0 : SV_Position;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program5Output
            {
                float4 sv_Position0 : SV_Position;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program5PatchConstant
            {
                float edges[3] : SV_TessFactor;
                float inside : SV_InsideTessFactor;
            };
            struct program7Input
            {
                float4 sv_Position0 : SV_Position;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
            };
            struct program7Output
            {
                float4 sv_Position0 : SV_POSITION;
                float3 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
            };
            struct program7PatchConstant
            {
                float edges[3] : SV_TessFactor;
                float inside : SV_InsideTessFactor;
            };
            #pragma vertex vert
            program1Output vert(program1Input i)
            {
                program1Output o = (program1Output)0;
                o.sv_Position0.xyzw = i.position0.xyzw;
                o.normal0.xyz = i.normal0.xyz;
                o.texcoord0.xy = (i.texcoord0.xyxx).xy;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float4 r0_xyzw_3 = ((rsqrt(dot(i.texcoord0.xyzx, i.texcoord0.xyzx))).xxxx * i.texcoord0.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float3 lightDir_xyz_1 = normalize(_WorldSpaceLightPos0);
                float4 r1_xyzw_2 = _MainTex.Sample(sampler_MainTex, (i.texcoord1.xyxx).xy);
                float4 r1_xyzw_3 = (r1_xyzw_2 * _Color);
                o.sv_Target0.xyz = (((mad(saturate(dot(float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3), lightDir_xyz_1.xyzx)), 0.5, 0.5)).xxxx * r1_xyzw_3.xyzx)).xyz;
                o.sv_Target0.w = r1_xyzw_3.w;
                return o;
            }
            program5PatchConstant hull_const(InputPatch<program5Input, 3> patch)
            {
                program5PatchConstant o = (program5PatchConstant)0;
                for (uint forkID = 0; forkID < 3; forkID++)
                {
                    float r0_x_1 = forkID;
                    o.edges[r0_x_1].x = _Tess;
                    o.inside.x = _Tess;
                }
                return o;
            }
            #pragma hull hull
            [domain("tri")]
            [partitioning("fractional_odd")]
            [outputtopology("triangle_cw")]
            [outputcontrolpoints(3)]
            [patchconstantfunc("hull_const")]
            program5Output hull(InputPatch<program5Input, 3> patch, uint id : SV_OutputControlPointID)
            {
                program5Output o = (program5Output)0;
                o.sv_Position0 = patch[id].sv_Position0;
                o.normal0 = patch[id].normal0;
                o.texcoord0 = patch[id].texcoord0;
                return o;
            }
            #pragma domain domain
            [domain("tri")]
            program7Output domain(program7PatchConstant CONST, OutputPatch<program7Input, 3> patch, float3 bary : SV_DomainLocation)
            {
                program7Output o = (program7Output)0;
                float3 r0_xyz_1 = ((bary.yyyy * patch[1].sv_Position0.xyzx)).xyz;
                float3 r0_xyz_3 = (mad(patch[2].sv_Position0.xyzx, bary.zzzz, (mad(patch[0].sv_Position0.xyzx, bary.xxxx, r0_xyz_1.xyzx)).xyzx)).xyz;
                float r0_w_1 = mad(r0_xyz_3.x, 8, _WorldSpaceLightPos0.y);
                float r0_w_2 = sin(r0_w_1);
                float3 r1_xyz_3 = (mad(patch[2].normal0.xyzx, bary.zzzz, (mad(patch[0].normal0.xyzx, bary.xxxx, (r0_xyz_1).xyzx)).xyzx)).xyz;
                float3 r1_xyz_4 = normalize(r1_xyz_3);
                float3 r0_xyz_4 = (mad(((r0_w_2.xxxx * r1_xyz_4.xyzx)).xyzx, _Displacement.xxxx, r0_xyz_3.xyzx)).xyz;
                float4 r2_xyzw_2 = (r0_xyz_4.yyyy * unity_ObjectToWorld[1]);
                float4 r2_xyzw_3 = mad(unity_ObjectToWorld[0], r0_xyz_4.xxxx, r2_xyzw_2);
                float4 r0_xyzw_5 = mad(unity_ObjectToWorld[2], r0_xyz_4.zzzz, r2_xyzw_3);
                float4 r0_xyzw_6 = (r0_xyzw_5 + unity_ObjectToWorld[3]);
                float4 r2_xyzw_4 = (r0_xyzw_6.yyyy * unity_MatrixVP[1]);
                float4 r2_xyzw_5 = mad(unity_MatrixVP[0], r0_xyzw_6.xxxx, r2_xyzw_4);
                float4 r2_xyzw_6 = mad(unity_MatrixVP[2], r0_xyzw_6.zzzz, r2_xyzw_5);
                o.sv_Position0.xyzw = mad(unity_MatrixVP[3], r0_xyzw_6.wwww, r2_xyzw_6);
                float r0_x_7 = dot(r1_xyz_4.xyzx, unity_WorldToObject[0].xyzx);
                float r0_y_7 = dot(r1_xyz_4.xyzx, unity_WorldToObject[1].xyzx);
                float r0_z_7 = dot(r1_xyz_4.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_5 = dot(float4(r0_x_7, r0_y_7, r0_z_7, r0_x_7), float4(r0_x_7, r0_y_7, r0_z_7, r0_x_7));
                float r0_w_6 = rsqrt(r0_w_5);
                o.texcoord0.xyz = ((r0_w_6.xxxx * float4(r0_x_7, r0_y_7, r0_z_7, r0_x_7))).xyz;
                o.texcoord1.xy = (mad((mad(patch[2].texcoord0.xyxx, bary.zzzz, (mad(patch[0].texcoord0.xyxx, bary.xxxx, ((bary.yyyy * patch[1].texcoord0.xyxx)).xyxx)).xyxx)).xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Diffuse"
}
