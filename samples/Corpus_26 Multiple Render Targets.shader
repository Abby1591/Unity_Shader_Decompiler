Shader "Corpus/26 Multiple Render Targets"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "" {}
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
                float4 texcoord0 : TEXCOORD0;
            };
            struct program1Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program3Output
            {
                float4 sv_Target0 : SV_Target;
                float4 sv_Target1 : SV_Target1;
                float4 sv_Target2 : SV_Target2;
                float4 sv_Target3 : SV_Target3;
                float4 sv_Target4 : SV_Target4;
                float4 sv_Target5 : SV_Target5;
                float4 sv_Target6 : SV_Target6;
                float4 sv_Target7 : SV_Target7;
            };
            #pragma vertex vert
            program1Output vert(program1Input i)
            {
                program1Output o = (program1Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                o.texcoord2.xyz = worldPos_xyzw_1.xyz;
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                o.sv_Target0.xyzw = (r0_xyzw_1 * _Color);
                float4 unitWorldNormal_xyzw_4 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldNormal_x_4 = unitWorldNormal_xyzw_4.x;
                float unitWorldNormal_y_2 = unitWorldNormal_xyzw_4.y;
                float unitWorldNormal_z_2 = unitWorldNormal_xyzw_4.z;
                o.sv_Target1.xyz = (mad(float4(unitWorldNormal_x_4, unitWorldNormal_y_2, unitWorldNormal_z_2, unitWorldNormal_x_4), float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
                o.sv_Target1.w = 1;
                o.sv_Target2.xyz = ((i.texcoord2.xyzx * float4(0.1, 0.1, 0.1, 0))).xyz;
                o.sv_Target2.w = 1;
                o.sv_Target3.xy = (i.texcoord0.xyxx).xy;
                o.sv_Target3.zw = (float4(0, 0, 0, 1)).zw;
                o.sv_Target4.xyzw = float4(1, 0, 0, 1);
                o.sv_Target5.xyzw = float4(0, 1, 0, 1);
                o.sv_Target6.xyzw = float4(0, 0, 1, 1);
                o.sv_Target7.xyz = (frac(i.texcoord2.xyzx)).xyz;
                o.sv_Target7.w = 1;
                return o;
            }
            ENDHLSL
        }
    }
}
