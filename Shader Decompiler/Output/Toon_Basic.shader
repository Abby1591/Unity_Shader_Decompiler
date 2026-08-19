Shader "Toon/Basic"
{
    Properties
    {
        _Color ("Main Color", Color) = (0.5,0.5,0.5,1)
        _MainTex ("Base (RGB)", 2D) = "" {}
        _ToonShade ("ToonShader Cubemap(RGB)", 2D) = "" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 0
        Pass
        {
            Tags { "RenderType"="Opaque" }
            Cull Off
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _MainTex_ST;
                float4 _Color;
                float4 cb0_values[4];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 cb1_values[4];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4x4 unity_MatrixV;
                float4x4 unity_MatrixVP;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            TextureCube t1 : register(t1);
            struct program2Input
            {
                float4 position0 : POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 normal0 : NORMAL0;
            };
            struct program2Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
            };
            struct program6Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
            };
            struct program6Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program2Output vert(program2Input i)
            {
                program2Output o = (program2Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_4 = UnityObjectToWorldPos(i.position0.xyz);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_4);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float3 objectToView1_xyz_5 = ((unity_ObjectToWorld[1].yyyy * unity_MatrixV[1].xyzx)).xyz;
                float3 objectToView1_xyz_6 = (mad(unity_MatrixV[0].xyzx, unity_ObjectToWorld[1].xxxx, objectToView1_xyz_5.xyzx)).xyz;
                float3 objectToView1_xyz_7 = (mad(unity_MatrixV[2].xyzx, unity_ObjectToWorld[1].zzzz, objectToView1_xyz_6.xyzx)).xyz;
                float3 objectToView1_xyz_8 = (mad(unity_MatrixV[3].xyzx, unity_ObjectToWorld[1].wwww, objectToView1_xyz_7.xyzx)).xyz;
                float3 viewNormal_xyz_9 = ((objectToView1_xyz_8.xyzx * i.normal0.yyyy)).xyz;
                float3 objectToView0_xyz_4 = ((unity_ObjectToWorld[0].yyyy * unity_MatrixV[1].xyzx)).xyz;
                float3 objectToView0_xyz_5 = (mad(unity_MatrixV[0].xyzx, unity_ObjectToWorld[0].xxxx, objectToView0_xyz_4.xyzx)).xyz;
                float3 objectToView0_xyz_6 = (mad(unity_MatrixV[2].xyzx, unity_ObjectToWorld[0].zzzz, objectToView0_xyz_5.xyzx)).xyz;
                float3 objectToView0_xyz_7 = (mad(unity_MatrixV[3].xyzx, unity_ObjectToWorld[0].wwww, objectToView0_xyz_6.xyzx)).xyz;
                float3 viewNormal_xyz_10 = (mad(objectToView0_xyz_7.xyzx, i.normal0.xxxx, viewNormal_xyz_9.xyzx)).xyz;
                float3 objectToView2_xyz_8 = ((unity_ObjectToWorld[2].yyyy * unity_MatrixV[1].xyzx)).xyz;
                float3 objectToView2_xyz_9 = (mad(unity_MatrixV[0].xyzx, unity_ObjectToWorld[2].xxxx, objectToView2_xyz_8.xyzx)).xyz;
                float3 objectToView2_xyz_10 = (mad(unity_MatrixV[2].xyzx, unity_ObjectToWorld[2].zzzz, objectToView2_xyz_9.xyzx)).xyz;
                float3 objectToView2_xyz_11 = (mad(unity_MatrixV[3].xyzx, unity_ObjectToWorld[2].wwww, objectToView2_xyz_10.xyzx)).xyz;
                o.texcoord1.xyz = (mad(objectToView2_xyz_11.xyzx, i.normal0.zzzz, viewNormal_xyz_10.xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program6Output frag(program6Input i)
            {
                program6Output o = (program6Output)0;
                float4 r0_xyzw_1 = t1.Sample(s1, i.texcoord1.xyzx);
                float4 r1_xyzw_1 = t0.Sample(s0, i.texcoord0.xyxx);
                float4 r1_xyzw_2 = (r1_xyzw_1 * _Color);
                o.sv_Target0.xyz = ((((r0_xyzw_1.xyzx + r0_xyzw_1.xyzx)).xyzx * r1_xyzw_2.xyzx)).xyz;
                o.sv_Target0.w = r1_xyzw_2.w;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "RenderType"="Opaque" }
            Cull Off
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _MainTex_ST;
                float4 _Color;
                float4 cb0_values[4];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 cb1_values[6];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4x4 unity_MatrixV;
                float4x4 unity_MatrixVP;
                float4 cb2_values[4];
            };
            cbuffer cb3 : register(b3)
            {
                float4 cb3_values[21];
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[2];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            TextureCube t1 : register(t1);
            struct program3Input
            {
                float4 position0 : POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 normal0 : NORMAL0;
            };
            struct program3Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord2 : TEXCOORD2;
                float3 texcoord1 : TEXCOORD1;
            };
            struct program7Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord2 : TEXCOORD2;
                float3 texcoord1 : TEXCOORD1;
            };
            struct program7Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program3Output vert(program3Input i)
            {
                program3Output o = (program3Output)0;
                float4 worldPos_xyzw_1 = (i.position0.yyyy * cb2_values[1].xyzw);
                float4 worldPos_xyzw_2 = mad(cb2_values[0].xyzw, i.position0.xxxx, worldPos_xyzw_1);
                float4 worldPos_xyzw_3 = mad(cb2_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_4 = (worldPos_xyzw_3 + cb2_values[3].xyzw);
                float4 clipPos_xyzw_1 = (worldPos_xyzw_4.yyyy * cb3_values[18].xyzw);
                float4 clipPos_xyzw_2 = mad(cb3_values[17].xyzw, worldPos_xyzw_4.xxxx, clipPos_xyzw_1);
                float4 clipPos_xyzw_3 = mad(cb3_values[19].xyzw, worldPos_xyzw_4.zzzz, clipPos_xyzw_2);
                float4 clipPos_xyzw_5 = mad(cb3_values[20].xyzw, worldPos_xyzw_4.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = clipPos_xyzw_5;
                o.texcoord2.x = mad(max((((clipPos_xyzw_5.z / cb1_values[5].y) + 1) * cb1_values[5].z), 0), cb4_values[1].z, cb4_values[1].w);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float4 r0_xyzw_10 = (cb2_values[1].yyyy * cb3_values[10].xyzx);
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_6 = r0_xyzw_10.y;
                float r0_z_6 = r0_xyzw_10.z;
                float4 r0_xyzw_11 = mad(cb3_values[9].xyzx, cb2_values[1].xxxx, float4(r0_x_10, r0_y_6, r0_z_6, r0_x_10));
                float r0_x_11 = r0_xyzw_11.x;
                float r0_y_7 = r0_xyzw_11.y;
                float r0_z_7 = r0_xyzw_11.z;
                float4 r0_xyzw_12 = mad(cb3_values[11].xyzx, cb2_values[1].zzzz, float4(r0_x_11, r0_y_7, r0_z_7, r0_x_11));
                float r0_x_12 = r0_xyzw_12.x;
                float r0_y_8 = r0_xyzw_12.y;
                float r0_z_8 = r0_xyzw_12.z;
                float4 r0_xyzw_13 = mad(cb3_values[12].xyzx, cb2_values[1].wwww, float4(r0_x_12, r0_y_8, r0_z_8, r0_x_12));
                float r0_x_13 = r0_xyzw_13.x;
                float r0_y_9 = r0_xyzw_13.y;
                float r0_z_9 = r0_xyzw_13.z;
                float4 r0_xyzw_14 = (float4(r0_x_13, r0_y_9, r0_z_9, r0_x_13) * i.normal0.yyyy);
                float r0_x_14 = r0_xyzw_14.x;
                float r0_y_10 = r0_xyzw_14.y;
                float r0_z_10 = r0_xyzw_14.z;
                float3 r1_xyz_7 = (mad(cb3_values[12].xyzx, cb2_values[0].wwww, (mad(cb3_values[11].xyzx, cb2_values[0].zzzz, (mad(cb3_values[9].xyzx, cb2_values[0].xxxx, ((cb2_values[0].yyyy * cb3_values[10].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                float4 r0_xyzw_15 = mad(r1_xyz_7.xyzx, i.normal0.xxxx, float4(r0_x_14, r0_y_10, r0_z_10, r0_x_14));
                float r0_x_15 = r0_xyzw_15.x;
                float r0_y_11 = r0_xyzw_15.y;
                float r0_z_11 = r0_xyzw_15.z;
                float3 r1_xyz_11 = (mad(cb3_values[12].xyzx, cb2_values[2].wwww, (mad(cb3_values[11].xyzx, cb2_values[2].zzzz, (mad(cb3_values[9].xyzx, cb2_values[2].xxxx, ((cb2_values[2].yyyy * cb3_values[10].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                o.texcoord1.xyz = (mad(r1_xyz_11.xyzx, i.normal0.zzzz, float4(r0_x_15, r0_y_11, r0_z_11, r0_x_15))).xyz;
                return o;
            }
            #pragma fragment frag
            program7Output frag(program7Input i)
            {
                program7Output o = (program7Output)0;
                float4 r0_xyzw_1 = t1.Sample(s1, i.texcoord1.xyzx);
                float4 r1_xyzw_1 = t0.Sample(s0, i.texcoord0.xyxx);
                float4 r1_xyzw_2 = (r1_xyzw_1 * _Color);
                o.sv_Target0.w = r1_xyzw_2.w;
                float TEXCOORD0_w_2 = i.texcoord2.x;
                o.sv_Target0.xyz = (mad(TEXCOORD0_w_2.xxxx, (mad(((r0_xyzw_1.xyzx + r0_xyzw_1.xyzx)).xyzx, r1_xyzw_2.xyzx, -cb1_values[0].xyzx)).xyzx, cb1_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "RenderType"="Opaque" }
            Cull Off
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _MainTex_ST;
                float4 _Color;
                float4 cb0_values[4];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 cb1_values[4];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4x4 unity_MatrixV;
                float4x4 unity_MatrixVP;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            TextureCube t1 : register(t1);
            struct program2Input
            {
                float4 position0 : POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 normal0 : NORMAL0;
            };
            struct program2Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
            };
            struct program7Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float2 texcoord0 : TEXCOORD0;
                float texcoord2 : TEXCOORD2;
                float3 texcoord1 : TEXCOORD1;
            };
            struct program7Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program2Output vert(program2Input i)
            {
                program2Output o = (program2Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                #define UnityObjectToWorldPos(v) mul(unity_ObjectToWorld, float4(v, 1.0))
                float4 worldPos_xyzw_4 = UnityObjectToWorldPos(i.position0.xyz);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_4);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float3 objectToView1_xyz_5 = ((unity_ObjectToWorld[1].yyyy * unity_MatrixV[1].xyzx)).xyz;
                float3 objectToView1_xyz_6 = (mad(unity_MatrixV[0].xyzx, unity_ObjectToWorld[1].xxxx, objectToView1_xyz_5.xyzx)).xyz;
                float3 objectToView1_xyz_7 = (mad(unity_MatrixV[2].xyzx, unity_ObjectToWorld[1].zzzz, objectToView1_xyz_6.xyzx)).xyz;
                float3 objectToView1_xyz_8 = (mad(unity_MatrixV[3].xyzx, unity_ObjectToWorld[1].wwww, objectToView1_xyz_7.xyzx)).xyz;
                float3 viewNormal_xyz_9 = ((objectToView1_xyz_8.xyzx * i.normal0.yyyy)).xyz;
                float3 objectToView0_xyz_4 = ((unity_ObjectToWorld[0].yyyy * unity_MatrixV[1].xyzx)).xyz;
                float3 objectToView0_xyz_5 = (mad(unity_MatrixV[0].xyzx, unity_ObjectToWorld[0].xxxx, objectToView0_xyz_4.xyzx)).xyz;
                float3 objectToView0_xyz_6 = (mad(unity_MatrixV[2].xyzx, unity_ObjectToWorld[0].zzzz, objectToView0_xyz_5.xyzx)).xyz;
                float3 objectToView0_xyz_7 = (mad(unity_MatrixV[3].xyzx, unity_ObjectToWorld[0].wwww, objectToView0_xyz_6.xyzx)).xyz;
                float3 viewNormal_xyz_10 = (mad(objectToView0_xyz_7.xyzx, i.normal0.xxxx, viewNormal_xyz_9.xyzx)).xyz;
                float3 objectToView2_xyz_8 = ((unity_ObjectToWorld[2].yyyy * unity_MatrixV[1].xyzx)).xyz;
                float3 objectToView2_xyz_9 = (mad(unity_MatrixV[0].xyzx, unity_ObjectToWorld[2].xxxx, objectToView2_xyz_8.xyzx)).xyz;
                float3 objectToView2_xyz_10 = (mad(unity_MatrixV[2].xyzx, unity_ObjectToWorld[2].zzzz, objectToView2_xyz_9.xyzx)).xyz;
                float3 objectToView2_xyz_11 = (mad(unity_MatrixV[3].xyzx, unity_ObjectToWorld[2].wwww, objectToView2_xyz_10.xyzx)).xyz;
                o.texcoord1.xyz = (mad(objectToView2_xyz_11.xyzx, i.normal0.zzzz, viewNormal_xyz_10.xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program7Output frag(program7Input i)
            {
                program7Output o = (program7Output)0;
                float4 r0_xyzw_1 = t1.Sample(s1, i.texcoord1.xyzx);
                float4 r1_xyzw_1 = t0.Sample(s0, i.texcoord0.xyxx);
                float4 r1_xyzw_2 = (r1_xyzw_1 * _Color);
                o.sv_Target0.w = r1_xyzw_2.w;
                float TEXCOORD0_w_2 = i.texcoord2.x;
                o.sv_Target0.xyz = (mad(TEXCOORD0_w_2.xxxx, (mad(((r0_xyzw_1.xyzx + r0_xyzw_1.xyzx)).xyzx, r1_xyzw_2.xyzx, -cb1_values[0].xyzx)).xyzx, cb1_values[0].xyzx)).xyz;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "VertexLit"
}
