Shader "Corpus/18 Geometry Shader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "" {}
        _Extrude ("Extrude", Range(0, 1)) = 0.1
    }
    SubShader
    {
        Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
        LOD 0
        Pass
        {
            Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
            Cull Off
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _MainTex_ST : packoffset(c2);
                float4 _Color : packoffset(c3);
                float _Extrude : packoffset(c4.x);
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
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program1Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float2 texcoord0 : TEXCOORD0;
                float4 color0 : COLOR0;
            };
            struct program1Output
            {
                float4 sv_Position0 : SV_POSITION;
                float3 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_POSITION;
                float3 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
            };
            struct program3Output
            {
                float4 sv_Target0 : SV_Target;
            };
            struct program4Input
            {
                float4 sv_Position0 : SV_POSITION;
                float3 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
            };
            struct program4Output
            {
                float4 sv_Position0 : SV_POSITION;
                float3 texcoord0 : TEXCOORD0;
                float2 texcoord1 : TEXCOORD1;
                float4 color0 : COLOR0;
            };
            #pragma vertex vert
            program1Output vert(program1Input i)
            {
                program1Output o = (program1Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_4 = UnityObjectToWorldPos(i.position0.xyz);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_4);
                float worldNormal_x_5 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_5 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_5 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_5 = dot(float4(worldNormal_x_5, worldNormal_y_5, worldNormal_z_5, worldNormal_x_5), float4(worldNormal_x_5, worldNormal_y_5, worldNormal_z_5, worldNormal_x_5));
                float r0_w_6 = rsqrt(r0_w_5);
                o.texcoord0.xyz = ((r0_w_6.xxxx * float4(worldNormal_x_5, worldNormal_y_5, worldNormal_z_5, worldNormal_x_5))).xyz;
                o.texcoord1.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                o.color0.xyzw = i.color0.xyzw;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float unitWorldNormal_x_3 = (rsqrt(dot(i.texcoord0.xyzx, i.texcoord0.xyzx)) * i.texcoord0.y);
                float4 r1_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord1.xyxx).xy);
                float4 r1_xyzw_3 = ((r1_xyzw_1 * _Color) * i.color0.xyzw);
                o.sv_Target0.xyz = (((saturate(mad(unitWorldNormal_x_3, 0.5, 0.5))).xxxx * r1_xyzw_3.xyzx)).xyz;
                o.sv_Target0.w = r1_xyzw_3.w;
                return o;
            }
            #pragma geometry geom
            [maxvertexcount(3)]
            void geom(triangle program4Input i[3], uint sv_Primitiveid0 : SV_PrimitiveID, inout TriangleStream<program4Output> stream)
            {
                program4Output o = (program4Output)0;
                float3 r0_xyz_1 = ((-i[0].sv_Position0.zxyz + i[1].sv_Position0.zxyz)).xyz;
                float3 r1_xyz_1 = ((-i[0].sv_Position0.yzxy + i[2].sv_Position0.yzxy)).xyz;
                float3 r0_xyz_2 = (mad(r0_xyz_1.zxyz, r1_xyz_1.yzxy, ((r0_xyz_1.xyzx * r1_xyz_1.xyzx)).xyzx)).xyz;
                float3 r0_xyz_4 = normalize(r0_xyz_2);
                o.sv_Position0.xyz = ((mad(r0_xyz_4.xyzx, float4(0.01, 0.01, 0.01, 0), i[0].sv_Position0.xyzx)).xyzx).xyz;
                o.sv_Position0.w = i[0].sv_Position0.w;
                o.texcoord0.xyz = i[0].texcoord0.xyz;
                o.texcoord1.xy = (i[0].texcoord1.xyxx).xy;
                float r0_w_3 = asfloat(asint(sv_Primitiveid0) & asint(1));
                float r0_w_4 = ((r0_w_3 != 0) ? 0.5 : 1);
                float4 r1_xyzw_3 = (r0_w_4.xxxx * i[0].color0.xyzw);
                o.color0.xyzw = r1_xyzw_3;
                stream.Append(o);
                o.sv_Position0.xyz = ((mad(r0_xyz_4.xyzx, float4(0.01, 0.01, 0.01, 0), i[1].sv_Position0.xyzx)).xyzx).xyz;
                o.sv_Position0.w = i[1].sv_Position0.w;
                o.texcoord0.xyz = i[1].texcoord0.xyz;
                o.texcoord1.xy = (i[1].texcoord1.xyxx).xy;
                float4 r1_xyzw_5 = (r0_w_4.xxxx * i[1].color0.xyzw);
                float4 r2_xyzw_2 = (r0_w_4.xxxx * i[2].color0.xyzw);
                o.color0.xyzw = r1_xyzw_5;
                stream.Append(o);
                o.sv_Position0.xyz = ((mad(r0_xyz_4.xyzx, float4(0.01, 0.01, 0.01, 0), i[2].sv_Position0.xyzx)).xyzx).xyz;
                o.sv_Position0.w = i[2].sv_Position0.w;
                o.texcoord0.xyz = i[2].texcoord0.xyz;
                o.texcoord1.xy = (i[2].texcoord1.xyxx).xy;
                o.color0.xyzw = r2_xyzw_2;
                stream.Append(o);
                stream.RestartStrip();
                return;
            }
            ENDHLSL
        }
    }
    Fallback "Diffuse"
}
