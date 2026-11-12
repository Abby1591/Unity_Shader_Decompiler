Shader "Corpus/45 Debug"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "" {}
        _Color ("Color", Color) = (1,1,1,1)
        _DebugMode ("Debug Mode", Float) = 0
        _DebugScale ("Debug Scale", Float) = 1
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
                float _DebugMode : packoffset(c4.x);
                float _DebugScale : packoffset(c4.y);
            };
            cbuffer _UnityPerCameraCB_b1
            {
                float3 _WorldSpaceCameraPos : packoffset(c4);
                float4 _ProjectionParams : packoffset(c5);
            };
            cbuffer _UnityPerDrawCB_b2
            {
                float4x4 unity_ObjectToWorld : packoffset(c0);
                float4x4 unity_WorldToObject : packoffset(c4);
            };
            cbuffer _UnityPerFrameCB_b3
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
            SamplerState sampler_MainTex;
            Texture2D _MainTex;
            struct program1Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
                float4 tangent0 : TANGENT0;
                float2 texcoord0 : TEXCOORD0;
                float4 color0 : COLOR0;
            };
            struct program1Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 color0 : COLOR0;
                float3 texcoord3 : TEXCOORD3;
                float3 texcoord4 : TEXCOORD4;
                float4 texcoord5 : TEXCOORD5;
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
                float4 worldPos_xyzw_1 = UnityObjectToWorldPos(i.position0.xyz);
                float3 worldPos_xyz_4 = worldPos_xyzw_1.xyz;
                float4 clipPos_xyzw_1 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_3 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_1));
                float4 clipPos_xyzw_2 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord0.xy = (mad(i.texcoord0.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float worldNormal_x_4 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_4 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_4 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_4 = dot(float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4), float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4));
                float r0_w_5 = rsqrt(r0_w_4);
                o.texcoord1.xyz = ((r0_w_5.xxxx * float4(worldNormal_x_4, worldNormal_y_4, worldNormal_z_4, worldNormal_x_4))).xyz;
                float3 worldTangent_xyz_5 = ((i.tangent0.yyyy * unity_ObjectToWorld[1].xyzx)).xyz;
                float3 worldTangent_xyz_6 = (mad(unity_ObjectToWorld[0].xyzx, i.tangent0.xxxx, worldTangent_xyz_5.xyzx)).xyz;
                float3 worldTangent_xyz_7 = (mad(unity_ObjectToWorld[2].xyzx, i.tangent0.zzzz, worldTangent_xyz_6.xyzx)).xyz;
                float r0_w_6 = dot(worldTangent_xyz_7.xyzx, worldTangent_xyz_7.xyzx);
                float r0_w_7 = rsqrt(r0_w_6);
                o.texcoord2.xyz = ((r0_w_7.xxxx * worldTangent_xyz_7.xyzx)).xyz;
                o.texcoord2.w = i.tangent0.w;
                o.color0.xyzw = i.color0.xyzw;
                o.texcoord3.xyz = worldPos_xyz_4.xyz;
                o.texcoord4.xyz = ((-worldPos_xyz_4.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_8 = ((clipPos_xyzw_2.y * _ProjectionParams.x) * 0.5);
                float4 r0_xyzw_6 = (clipPos_xyzw_2.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_z_5 = r0_xyzw_6.z;
                o.texcoord5.zw = (clipPos_xyzw_2.zzzw).zw;
                o.texcoord5.xy = ((r0_z_5.xxxx + float4(r0_x_6, r0_w_8, r0_x_6, r0_x_6))).xy;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float4 r0_xyzw_1 = _MainTex.Sample(sampler_MainTex, (i.texcoord0.xyxx).xy);
                float4 unitWorldPos_xyzw_3 = ((rsqrt(dot(i.texcoord1.xyzx, i.texcoord1.xyzx))).xxxx * i.texcoord1.xyzx);
                float unitWorldPos_x_3 = unitWorldPos_xyzw_3.x;
                float unitWorldPos_y_1 = unitWorldPos_xyzw_3.y;
                float unitWorldPos_z_1 = unitWorldPos_xyzw_3.z;
                float3 unitWorldPos_xyz_1 = normalize(i.texcoord2);
                float3 COLOR0_xyz_12;
                float r0_x_5;
                float r0_y_3;
                float r0_z_3;
                float r0_x_6;
                float r0_y_4;
                float r0_z_4;
                float r0_x_7;
                float r0_y_5;
                float r0_z_5;
                float3 TEXCOORD0_xyz_7;
                float3 COLOR0_xyz_6;
                float unitWorldPos_x_4;
                float unitWorldPos_y_2;
                float unitWorldPos_z_2;
                float r0_x_9;
                float r0_y_7;
                float r0_z_7;
                float r0_x_10;
                float r0_y_8;
                float r0_z_8;
                float r0_x_11;
                float r0_y_9;
                float r0_z_9;
                float r0_x_12;
                float r0_y_10;
                float r0_z_10;
                float r0_x_13;
                float r0_y_11;
                float r0_z_11;
                switch ((_DebugMode).x)
                {
                case 0:
                    COLOR0_xyz_12 = ((r0_xyzw_1.xyzx * _Color.xyzx)).xyz;
                    break;
                case 1:
                    COLOR0_xyz_12 = (mad(float4(unitWorldPos_x_3, unitWorldPos_y_1, unitWorldPos_z_1, unitWorldPos_x_3), float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
                    break;
                case 2:
                    COLOR0_xyz_12 = (mad(unitWorldPos_xyz_1.zxyz, float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
                    break;
                case 3:
                    float4 r0_xyzw_5 = (float4(unitWorldPos_z_1, unitWorldPos_x_3, unitWorldPos_y_1, unitWorldPos_z_1) * unitWorldPos_xyz_1.xyzx);
                    r0_x_5 = r0_xyzw_5.x;
                    r0_y_3 = r0_xyzw_5.y;
                    r0_z_3 = r0_xyzw_5.z;
                    float4 r0_xyzw_6 = mad(float4(unitWorldPos_y_1, unitWorldPos_z_1, unitWorldPos_x_3, unitWorldPos_y_1), unitWorldPos_xyz_1.yzxy, -float4(r0_x_5, r0_y_3, r0_z_3, r0_x_5));
                    r0_x_6 = r0_xyzw_6.x;
                    r0_y_4 = r0_xyzw_6.y;
                    r0_z_4 = r0_xyzw_6.z;
                    float4 r0_xyzw_7 = (float4(r0_x_6, r0_y_4, r0_z_4, r0_x_6) * i.texcoord2.wwww);
                    r0_x_7 = r0_xyzw_7.x;
                    r0_y_5 = r0_xyzw_7.y;
                    r0_z_5 = r0_xyzw_7.z;
                    COLOR0_xyz_12 = (mad(float4(r0_x_7, r0_y_5, r0_z_5, r0_x_7), float4(0.5, 0.5, 0.5, 0), float4(0.5, 0.5, 0.5, 0))).xyz;
                    break;
                case 4:
                    TEXCOORD0_xyz_7 = (i.texcoord0.xyxx).xyz;
                    COLOR0_xyz_12 = TEXCOORD0_xyz_7;
                    break;
                case 5:
                    COLOR0_xyz_6 = i.color0.xyz;
                    COLOR0_xyz_12 = COLOR0_xyz_6;
                    break;
                case 6:
                    COLOR0_xyz_12 = (frac(i.texcoord3.xyzx)).xyz;
                    break;
                case 7:
                    float4 unitWorldPos_xyzw_4 = ((rsqrt(dot(i.texcoord4.xyzx, i.texcoord4.xyzx))).xxxx * i.texcoord4.xyzx);
                    unitWorldPos_x_4 = unitWorldPos_xyzw_4.x;
                    unitWorldPos_y_2 = unitWorldPos_xyzw_4.y;
                    unitWorldPos_z_2 = unitWorldPos_xyzw_4.z;
                    COLOR0_xyz_12 = saturate(dot(float4(unitWorldPos_x_3, unitWorldPos_y_1, unitWorldPos_z_1, unitWorldPos_x_3), float4(unitWorldPos_x_4, unitWorldPos_y_2, unitWorldPos_z_2, unitWorldPos_x_4)));
                    break;
                case 8:
                    COLOR0_xyz_12 = ((i.texcoord5.xyxx / i.texcoord5.wwww)).xyz;
                    break;
                case 9:
                    COLOR0_xyz_12 = (r0_xyzw_1.wwww).xyz;
                    break;
                default:
                    COLOR0_xyz_12 = (float4(1, 0, 1, 0)).xyz;
                    break;
                    float4 r0_xyzw_9 = saturate((COLOR0_xyz_12.xyzx * _DebugScale.xxxx));
                    r0_x_9 = r0_xyzw_9.x;
                    r0_y_7 = r0_xyzw_9.y;
                    r0_z_7 = r0_xyzw_9.z;
                    float4 r0_xyzw_10 = log2(float4(r0_x_9, r0_y_7, r0_z_7, r0_x_9));
                    r0_x_10 = r0_xyzw_10.x;
                    r0_y_8 = r0_xyzw_10.y;
                    r0_z_8 = r0_xyzw_10.z;
                    float4 r0_xyzw_11 = (float4(r0_x_10, r0_y_8, r0_z_8, r0_x_10) * float4(0.41666666, 0.41666666, 0.41666666, 0));
                    r0_x_11 = r0_xyzw_11.x;
                    r0_y_9 = r0_xyzw_11.y;
                    r0_z_9 = r0_xyzw_11.z;
                    float4 r0_xyzw_12 = exp2(float4(r0_x_11, r0_y_9, r0_z_9, r0_x_11));
                    r0_x_12 = r0_xyzw_12.x;
                    r0_y_10 = r0_xyzw_12.y;
                    r0_z_10 = r0_xyzw_12.z;
                    float4 r0_xyzw_13 = mad(float4(r0_x_12, r0_y_10, r0_z_10, r0_x_12), float4(1.055, 1.055, 1.055, 0), float4(-0.055, -0.055, -0.055, 0));
                    r0_x_13 = r0_xyzw_13.x;
                    r0_y_11 = r0_xyzw_13.y;
                    r0_z_11 = r0_xyzw_13.z;
                    o.sv_Target0.xyz = (max(float4(r0_x_13, r0_y_11, r0_z_11, r0_x_13), float4(0, 0, 0, 0))).xyz;
                    o.sv_Target0.w = 1;
                    return o;
                }
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Diffuse"
}
